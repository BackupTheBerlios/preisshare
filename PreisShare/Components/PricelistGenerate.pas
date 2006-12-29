unit PricelistGenerate;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, bsSkinData,bsSkinBoxCtrls, bsSkinCtrls, ComCtrls, Db, DBTables, GTDBizDocs,
  SmtpProt, bsSkinGrids, bsDBGrids, bsMessages,ShellAPI,
  GTDBuildPricelistFromDBRun,GTDBuildPricelistFromDBConfig,GTDPricelists,
  Buttons, Grids, DBGrids, HTTPApp, HTTPProd, jpeg, ExtCtrls, FastStrings ;

type
  TPricelistGenerator = class(TFrame)
    sgProgress: TbsSkinGauge;
  	qryFindTargets: TQuery;
    pnlBack: TbsSkinPanel;
    lblStatus: TbsSkinStdLabel;
    mmoLog: TbsSkinMemo;
    lsvItems: TbsSkinListView;
    lblListCount: TbsSkinStdLabel;
    btnList: TbsSkinSpeedButton;
    dbgCustomerList: TbsSkinDBGrid;
    DataSource1: TDataSource;
    pnlSettings: TbsSkinGroupBox;
    cbxSpecialsOnly: TbsSkinCheckRadioBox;
    cbxNewProducts: TbsSkinCheckRadioBox;
    cbxFullPricelist: TbsSkinCheckRadioBox;
    bsSkinMessage1: TbsSkinMessage;
    cbxTemplateName: TbsSkinComboBox;
    lblTemplateName: TbsSkinLabel;
    btnPreview: TbsSkinSpeedButton;
    SmtpEmail: TSmtpCli;
    btnGenerateAll: TbsSkinSpeedButton;
    gbErrorLog: TbsSkinGroupBox;
    mmoErrLog: TbsSkinMemo;
    PageProducer1: TPageProducer;
    Image1: TImage;
    rdoGenerateForHowMany: TbsSkinRadioGroup;
    procedure btnGenerateAllClick(Sender: TObject);
    procedure btnListClick(Sender: TObject);
    procedure lblListCountClick(Sender: TObject);
    procedure SmtpEmailSinuDisplay(Sender: TObject; Msg: String);
    procedure SmtpEmailSinuRequestDone(Sender: TObject; RqType: TSmtpRequest;
      ErrorCode: Word);
    procedure btnPreviewClick(Sender: TObject);
    procedure SmtpEmailDisplay(Sender: TObject; Msg: String);
    procedure SmtpEmailRequestDone(Sender: TObject; RqType: TSmtpRequest;
      ErrorCode: Word);
  private
	  { Private declarations }
	  fSkinData           : TbsSkinData;
    fDocRegistry        : GTDDocumentRegistry;
    fplBuilder          : TBuildPricelistFromDBRun;
    fplBuildConfig      : TBuildPricelistFromDBConfig;

    fConnectionErr,
    fProcessing      : Boolean; {Sinu}

    function CollectEmailDistributionList:Boolean;
    function CreateHTMLEmailfromTemplate(TemplateFileName : String):Boolean;
    function EmailFileSetToCustomer:Boolean;

    function SendEmail(AFileName,AEmailId,delivFormat : String; PricelistRef : GTDPricelist):Boolean;

    procedure MoveProgressBar;
  public
    { Public declarations }
    function Init:Boolean;
    function GenerateForAll:Boolean;
    function GenerateForTrader(Trader_ID : Integer):Boolean;
    function Cancel:Boolean;
    procedure SetSkinData(Value: TbsSkinData);
  published
    property SkinData   : TbsSkinData read fSkinData write SetSkinData;
    property DocRegistry : GTDDocumentRegistry read fDocRegistry write fDocRegistry;
  end;

const
  PL_DELIV_FORMAT       = 'Delivery_Format';
  PL_DELIV_CSV          = 'CSV';
  PL_DELIV_XLS          = 'XLS';
  PL_DELIV_XML          = 'XML';
  PL_OUTPUT_STD_COLUMNS = GTD_PL_ELE_PRODUCT_PLU + ';' + GTD_PL_ELE_PRODUCT_NAME + ';' + GTD_PL_ELE_PRODUCT_ACTUAL;
  PL_PRICELIST_FILENAME = 'PriceList';

  PL_DELIV_NODE         = '/Pricelist Delivery';

  PL_DELIV_FREQUENCY    = 'Update_Frequency';
  PL_DELIV_FREQ_INSTANT = 'When Changed';
  PL_DELIV_FREQ_DAILY   = 'Daily';
  PL_DELIV_FREQ_WEEKLY  = 'Weekly';
  PL_DELIV_FREQ_FORTNIGHT = 'Fortnightly';

implementation

{$R *.DFM}

function TPricelistGenerator.Init:Boolean;
var
	newItem : TListItem;
  sStatus : String;
begin
    if not Assigned(fDocRegistry) then
    begin
        fDocRegistry := GTDDocumentRegistry.Create(Self);
        fDocRegistry.Visible := False;
    end;

    fDocRegistry.OpenRegistry('',sStatus);

	lsvItems.Items.Clear;

	newItem := lsvItems.Items.Add;
	newItem.Caption := 'Ready';
	newItem.SubItems.Add('Retail Pricelist');
	newItem.SubItems.Add('All Retail Customers');
	newItem.SubItems.Add('Grid');

	with qryFindTargets do
	begin

		Active := False;

		DatabaseName := GTD_ALIAS;

		SQL.Clear;
		SQL.Add('select * from SysVals');
		SQL.Add('where ');
		SQL.Add('  (Section = "Special Generator") or');
		SQL.Add('  (Section = "Customer Generator")');

		Active := True;

		First;
		while not Eof do
		begin

			newItem := lsvItems.Items.Add;

			if FieldByName('Section').AsString = 'Special Generator' then
			begin
				newItem.Caption := 'Not Started';
				newItem.SubItems.Add('Custom');
				newItem.SubItems.Add(FieldByName('KeyName').AsString);
				newItem.SubItems.Add(FieldByName('KeyValue').AsString);
			end
			else if FieldByName('Section').AsString = 'Customer Generator' then
			begin
				newItem.Caption := 'Not Started';
				newItem.SubItems.Add('Pricelist');
				newItem.SubItems.Add(FieldByName('KeyValue').AsString);
				newItem.SubItems.Add('Grid');
			end;

			Next;
		end;

	end;

    if not Assigned(fplBuildConfig) then
    begin
        fplBuildConfig := TBuildPricelistFromDBConfig.Create(Self);
        with fplBuildConfig do
        begin
            Left := 750;
            Top  := 10;
            Parent := Self;
            DocRegistry := fDocRegistry;
            Visible := False;{Made false : Sinu}
        end;
    end;

    if not Assigned(fplBuilder) then
    begin
        fplBuilder := TBuildPricelistFromDBRun.Create(Self);
        with fplBuilder do
        begin
            Left := 350;
            Top  := 10;
            Parent := Self;
            Visible := False; {Made false : Sinu}
            Configuration := fplBuildConfig;
            DocRegistry := fDocRegistry;
        end;
    end;

  {Sinu}
  CollectEmailDistributionList; {Collect all traders}
  {Sinu}
end;

procedure TPricelistGenerator.SetSkinData(Value: TbsSkinData);
begin
    pnlBack.SkinData := Value;
	mmoLog.SkinData := Value;
    mmoErrLog.SkinData := Value;{Sinu}
    gbErrorLog.SkinData := Value;{Sinu}

	lsvItems.SkinData := Value;
	rdoGenerateForHowMany.SkinData := Value;
	btnGenerateAll.SkinData := Value;
	sgProgress.SkinData := Value;

    btnList.SkinData := Value;
    dbgCustomerList.SkinData := Value;
    pnlSettings.SkinData := Value;
    cbxSpecialsOnly.SkinData := Value;
    cbxNewProducts.SkinData := Value;
    cbxFullPricelist.SkinData := Value;
    btnPreview.SkinData := Value;
    cbxTemplateName.SkinData := Value;
    lblTemplateName.SkinData := Value;
end;

function TPricelistGenerator.GenerateForAll:Boolean;
var
	iCount : Integer;
begin
  {Sinu start}

  fProcessing         := False;
  iCount              := 0;
  with qryFindTargets do
  begin
    First;
    while (Not Eof) do
    begin
      if Not fProcessing then
      begin
        {Initialize progress bar for sending each mail}
        sgProgress.Value       := 1;
        sgProgress.MaxValue    := lsvItems.Items.Count * 10;
        sgProgress.Visible     := True;

        fProcessing            := True;
        rdoGenerateForHowMany.Enabled   := False;
        btnGenerateAll.Enabled := False;
        Screen.Cursor          := crHourGlass;

        MoveProgressBar; {Move position of progress bar}

        {Generate and send price list for each trader}
        GenerateForTrader(qryFindTargets.FieldByName(GTD_DB_COL_TRADER_ID).AsInteger);
      end;

      {repeat this loop until a reply gets from the mail server.
      Call GenerateForTrader and process all messages till gets a reply from mail server.
      After finishing the process of mail sending , loop to do the same for another trader.}
      repeat
        Application.ProcessMessages;
      until fProcessing = False;

      {If there is any mail server problem, break from the loop.}
      if fConnectionErr then
        Break;

      Next; {Take the next trader}
    end;
  end;

	{for xc := 2 to lsvItems.Items.Count do
	begin

		sgProgress.Value := xc;

		lsvItems.Items[xc-1].Caption := 'Running';
		lsvItems.Update;
		Sleep(500);

		lsvItems.Items[xc-1].Caption := 'Complete';

	end;}

  {Sinu stop}
end;

procedure TPricelistGenerator.btnGenerateAllClick(Sender: TObject);
begin
    if rdoGenerateForHowMany.ItemIndex = 1 then
        GenerateForAll
    else begin
        sgProgress.Visible      := True;
        sgProgress.MaxValue     := 11;
        rdoGenerateForHowMany.Enabled    := False;
        btnGenerateAll.Enabled  := False;
        Screen.Cursor           := crHourGlass;

        sgProgress.Value        := 1;
        GenerateForTrader(qryFindTargets.FieldByName(GTD_DB_COL_TRADER_ID).AsInteger);
    end;
end;

function TPricelistGenerator.CollectEmailDistributionList:Boolean;
var
    newItem : TListItem;
    ListCount : Integer;
begin
  {Select all traders from the trader table}
	with qryFindTargets do
	begin

		Active := False;

		DatabaseName := GTD_ALIAS;

		SQL.Clear;
		SQL.Add('select * from Trader');
		SQL.Add('where ');
		SQL.Add(' ((' + GTD_DB_COL_STATUS_CODE + ' = "' + GTD_TRADER_STATUS_ACTIVE + '") or');
		SQL.Add('  (' + GTD_DB_COL_STATUS_CODE + ' = "' + GTD_TRADER_STATUS_PROSPECT + '")) and ');
    SQL.Add('  (' + GTD_DB_COL_RELATIONSHIP + ' = "' + GTD_TRADER_RLTNSHP_CUSTOMER + '")');

		Active := True;

    // -- Cycle through each of the records
		First;
		ListCount :=0;

    while not Eof do
		begin
      CreateHTMLEmailfromTemplate('');

      EmailFileSetToCustomer;

      Inc(ListCount);

			Next;
		end;

    // -- Update the label
    lblListCount.Caption := IntToStr(ListCount) + ' Customers found';
	end;
end;

function TPricelistGenerator.Cancel:Boolean;
begin
end;

procedure TPricelistGenerator.btnListClick(Sender: TObject);
begin
  CollectEmailDistributionList;
  dbgCustomerList.Visible := not dbgCustomerList.Visible;
end;

procedure TPricelistGenerator.lblListCountClick(Sender: TObject);
begin
  sgProgress.Visible := True;

  // -- Debugging code
  with SmtpEmail do
  begin
      Connect;
  end;
end;

procedure TPricelistGenerator.SmtpEmailSinuDisplay(Sender: TObject;
  Msg: String);
begin
  sgProgress.ProgressText := Msg;
  //mmoLog.Lines.Add(Msg); Sinu
  mmoErrLog.Lines.Add(Msg); {Sinu}
end;

procedure TPricelistGenerator.SmtpEmailSinuRequestDone(Sender: TObject;
  RqType: TSmtpRequest; ErrorCode: Word);
var
  xc : Integer;

  procedure Report(aCode, aMsg : String);
  begin
    //sgProgress.ProgressText := aMsg;
    //mmoLog.Lines.Add(aMsg); Sinu
    mmoErrLog.Lines.Add(aMsg); {Sinu}
  end;

begin
  fConnectionErr := False;

  if (RqType = smtpAuth) and (ErrorCode = 0) then
  begin
    sgProgress.Value := 20;
  end
  else
  if (RqType = smtpConnect) and (ErrorCode = 0) then
  begin
    // -- Do the mailing
    Report('SHOW','Mail server connected Successfully.');
    Report('SHOW','Now price lists can be sent.');
    {Sinu}
    btnGenerateAll.Enabled := True;
    rdoGenerateForHowMany.Enabled   := True;
    {Sinu}
    SmtpEMail.Mail;
    sgProgress.Value := 40;
  end
  else if (RqType = smtpMail) and (ErrorCode = 0) then
  begin
    sgProgress.Value := 90;
    // -- Write every entry
    for xc :=1 to SmtpEmail.EmailFiles.Count do
      Report('SENT','Successfully sent ' + SmtpEmail.EmailFiles.Strings[xc-1]);

    SmtpEmail.Quit;

  end
  else if (RqType = smtpQuit) and (ErrorCode = 0) then
  begin
    sgProgress.Value := 100;
    Report('SHOW','Session closed Successfully');
    Report('COMPLETE','Product Data Mailing Function complete.');
    sgProgress.Visible := False;
    Report('SHOW','Product Data Mailed Successfully');

    fProcessing := False;
  end
  else if (ErrorCode <> 0) then
  begin
    fConnectionErr      := True;
    sgProgress.Visible  := False;

    if (ErrorCode = 11004) then
    begin
      if mrYes = bsSkinMessage1.MessageDlg('You are not Connected: Do you want to generate files to manually email anyway?',mtConfirmation,[mbYes, mbNo, mbCancel],0) then
      begin
        sgProgress.Value := 100;
        sgProgress.Visible := False;

        Report('NOT SENT','Product Data generated but not sent.');
      end;
    end
    else
    begin
      // -- Display the error message
      Report('ERROR','Error ' + IntToStr(ErrorCode) + ' encountered');
    end;
    fProcessing := False;
  end;
end;

procedure TPricelistGenerator.btnPreviewClick(Sender: TObject);
begin
  CopyFile(PChar('Specials Templates\SpecialsListing.html'),PChar('Specials Templates\SpecialsMerge.html'),False);
  ShellExecute(GetFocus(),'open',PChar('Specials Templates\SpecialsMerge.html'),nil,nil,SW_SHOW);
end;

function TPricelistGenerator.CreateHTMLEmailfromTemplate(TemplateFileName : String):Boolean;
begin

end;

function TPricelistGenerator.EmailFileSetToCustomer;
begin
//
end;

function TPricelistGenerator.GenerateForTrader(Trader_ID : Integer):Boolean;
var
  pl : GTDPricelist;
  sFormat,sColName,sColumns,sFileName : String;
  i,iColCount : Integer;
begin
  Result := False;
  // -- Use the registry to load the trader record
  if not Assigned(fDocRegistry) then
    Exit;

  // -- Load up the trader
  if fDocRegistry.OpenForTraderNumber(Trader_ID) then
  begin
    MoveProgressBar;

    pl := GTDPricelist.Create(Self);

    // -- Retrieve the Customers latest pricelist
    if not fDocRegistry.GetLatestPriceList(GTDBizDoc(pl))then    begin
      // -- If not then use the standard pricelist
      if FileExists(GTD_CURRENT_PRICELIST) then
        pl.xml.LoadFromFile(GTD_CURRENT_PRICELIST)
      else {No pricelist to load, didn't work}
        Exit;
    end;
    MoveProgressBar;

    {Now see what format they want it in }
    fDocRegistry.GetTraderSettingString(PL_DELIV_NODE,PL_DELIV_FORMAT,sFormat);
    iColCount := 0;
    MoveProgressBar;    if (sFormat = PL_DELIV_CSV) then
      fDocRegistry.GetTraderSettingInt('/CSV OutputFormat','Column_Count',iColCount)
    else if (sFormat = PL_DELIV_XLS) then
      fDocRegistry.GetTraderSettingInt('/XLS OutputFormat','Column_Count',iColCount);

    MoveProgressBar;

    {If there are no columns defined to use, then use the standard column list}
    if (iColCount = 0) then
      sColumns := PL_OUTPUT_STD_COLUMNS
    else
    begin
      {Add all the column names from the definition}      for i := 1 to iColCount do
      begin
        {Retrieve every column}
        sColName := '';
        if (sFormat = PL_DELIV_CSV) then          fDocRegistry.GetTraderSettingString('/CSV OutputFormat','Column_' + IntToStr(i),sColName)
        else if (sFormat = PL_DELIV_XLS) then
          fDocRegistry.GetTraderSettingString('/XLS OutputFormat','Column_' + IntToStr(i),sColName);
        if Trim(sColumns) = '' then          sColumns := sColName        else          sColumns := sColumns + ';' +  sColName;      end;
    end;
    MoveProgressBar;

    // -- Check whether the trader name is empty or not.
    if Trim(fDocRegistry.Trader_Name) = '' then
      sFileName := PL_PRICELIST_FILENAME
    else begin
      // -- Retrieve our company name
      sFileName := Trim(fDocRegistry.GetCompanyName);

      // -- We need to remove all '.'
      if (FastCharPos(sFileName,'.',1) <> 0) then
          sFileName := FastReplace(sFileName,'.','');
    end;

    // -- Now output the file
    if (sFormat = PL_DELIV_CSV) then
    begin
      sFileName := sFileName + '.csv';

      // -- Save the price list in csv format
      pl.ExportAsStandardCSV(sFileName,sColumns,False);
      MoveProgressBar;
    end
    else if (sFormat = PL_DELIV_XLS) then
    begin
      sFileName := sFileName + '.xls';

      // -- Save the price list in xls format
      pl.ExportAsStandardXLS(fDocRegistry, sFileName,sColumns);
      
      MoveProgressBar;

    end;

    {Send the file to the customer}
    SendEmail(sFileName,qryFindTargets.FieldByName('Email').AsString,sFormat,pl);
  end;
end;

function TPricelistGenerator.SendEmail(AFileName,AEmailId,delivFormat : String; PricelistRef : GTDPricelist): Boolean;

    procedure BuildMessageBody;
    var
        s : String;
    begin
      SmtpEmail.MailMessage.Clear;

      // -- Here we will use the first word of the contact field
      s := qryFindTargets.FieldByName(GTD_DB_COL_CONTACT).AsString;
      if (s = '') then
        SmtpEmail.MailMessage.Add('Hello,')
      else
        SmtpEmail.MailMessage.Add('Hi ' + Parse(s,' ') + ',');

      SmtpEmail.MailMessage.Add('');
      SmtpEmail.MailMessage.Add('Please find our latest Pricelist');

      // -- Build the message
      SmtpEmail.MailMessage.Add('');
//    SmtpEmail.MailMessage.Add('  Items  : ' + IntToStr(PricelistRef.xml.Count));
      SmtpEmail.MailMessage.Add('  Date   : ' + DateTimeToStr(Now));
      SmtpEmail.MailMessage.Add('  Format : ' + UpperCase(delivFormat));
//    SmtpEmail.MailMessage.Add('  Frequency : ' + IntToStr(PricelistRef.xml.Count));

    end;

var
  s : String;

begin
  if not Assigned(fDocRegistry) then
    Exit;

  SmtpEmail.HdrTo      := AEmailId;

  // -- Build the message subject
  if fDocRegistry.GetCompanyName <> '' then
    s := 'Latest Pricelist from ' + fDocRegistry.GetCompanyName
  else
    s := 'Latest Price List';
  SmtpEmail.HdrSubject := s;

  {Attach the attachments}
  SmtpEmail.EmailFiles.Clear;
  SmtpEmail.EmailFiles.Add(AFileName);

  SmtpEmail.RcptName.Clear;
  SmtpEmail.RcptName.Add(AEmailId);

  {Attach the message}
  BuildMessageBody;

  {Now send mail}
  SmtpEmail.Connect;
end;

procedure TPricelistGenerator.SmtpEmailDisplay(Sender: TObject;
  Msg: String);
begin
  sgProgress.ProgressText := Msg;

  //mmoLog.Lines.Add(Msg); Sinu
  mmoErrLog.Lines.Add(Msg); {Sinu}
end;

procedure TPricelistGenerator.SmtpEmailRequestDone(Sender: TObject;
  RqType: TSmtpRequest; ErrorCode: Word);
var
  xc : Integer;

  procedure Report(aCode, aMsg : String);
  begin
    //sgProgress.ProgressText := aMsg;

    //mmoLog.Lines.Add(aMsg); Sinu
    mmoErrLog.Lines.Add(aMsg); {Sinu}
  end;

begin
  fConnectionErr := False;

  if (RqType = smtpAuth) and (ErrorCode = 0) then
    //sgProgress.Value := iRecord * 20
    MoveProgressBar
  else
  if (RqType = smtpConnect) and (ErrorCode = 0) then
  begin
    fConnectionErr          := False;
    rdoGenerateForHowMany.Enabled    := False;
    btnGenerateAll.Enabled  := False;
    Screen.Cursor           := crHourGlass;

    // -- Do the mailing
    Report('SHOW','Mail server connected Successfully.');
    Report('SHOW','Now price lists can be sent.');
    MoveProgressBar;
    SmtpEMail.Mail;
    //sgProgress.Value := iRecord * 40;
  end
  else if (RqType = smtpMail) and (ErrorCode = 0) then
  begin
    //sgProgress.Value := iRecord * 90;
    MoveProgressBar;
    // -- Write every entry
    for xc :=1 to SmtpEmail.EmailFiles.Count do
      Report('SENT','Successfully sent ' + SmtpEmail.EmailFiles.Strings[xc-1]);

    SmtpEmail.Quit;
  end
  else if (RqType = smtpQuit) and (ErrorCode = 0) then
  begin
    //sgProgress.Value := iRecord * 100;
    MoveProgressBar;

    Report('SHOW','Session closed Successfully');
    Report('COMPLETE','Product Data Mailing Function complete.');
    sgProgress.Visible := False;
    Report('SHOW','Product Data Mailed Successfully to ' + SmtpEmail.HdrTo);

    rdoGenerateForHowMany.Enabled    := True;
    btnGenerateAll.Enabled  := True;
    Screen.Cursor           := crDefault;
    fProcessing             := False;
  end
  else if (ErrorCode <> 0) then
  begin
    fConnectionErr      := True;

    sgProgress.Visible  := False;
    Screen.Cursor       := crDefault;

    if (ErrorCode = 11004) then
    begin
      if mrYes = bsSkinMessage1.MessageDlg('You are not Connected: Do you want to generate files to manually email anyway?',mtConfirmation,[mbYes, mbNo, mbCancel],0) then
      begin
        sgProgress.Value := sgProgress.MaxValue;
        sgProgress.Visible := False;

        Report('NOT SENT','Product Data generated but not sent.');
      end;
    end
    else
    begin
      // -- Display the error message
      Report('ERROR','Error ' + IntToStr(ErrorCode) + ' encountered');
    end;
    fProcessing := False;

    rdoGenerateForHowMany.Enabled    := True;
    btnGenerateAll.Enabled  := True;
  end;
end;

procedure TPricelistGenerator.MoveProgressBar;
begin
  sgProgress.Value := sgProgress.Value + 1;
end;

end.

