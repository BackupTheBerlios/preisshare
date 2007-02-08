unit PricelistGenerate;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, bsSkinData,bsSkinBoxCtrls, bsSkinCtrls, ComCtrls, Db, DBTables, GTDBizDocs,
  GTDBizLinks, Variants,
  SmtpProt, bsSkinGrids, bsDBGrids, bsMessages, ShellAPI,
  GTDBuildPricelistFromDBRun,GTDBuildPricelistFromDBConfig,GTDPricelists,
  Buttons, Grids, DBGrids, HTTPApp, HTTPProd, jpeg, ExtCtrls, FastStrings,
  FtpCli, OleCtrls, ImgList;

const
    GTTM_SETUP            = WM_APP + 405;
    GTTM_PROCESS_CURRENT  = WM_APP + 406;
    GTTM_MOVE_NEXT        = WM_APP + 407;
    GTTM_CLEANUP          = WM_APP + 408;
    GTTM_ERRSTART         = WM_APP + 409;

type
  TPricelistGenerator = class(TFrame)
    sgProgress: TbsSkinGauge;
  	qryFindTargets: TQuery;
    pnlBack: TbsSkinPanel;
    lblStatus: TbsSkinStdLabel;
    mmoLog: TbsSkinMemo;
    lblListCount: TbsSkinStdLabel;
    btnList: TbsSkinSpeedButton;
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
    btnProcess: TbsSkinSpeedButton;
    gbErrorLog: TbsSkinGroupBox;
    mmoErrLog: TbsSkinMemo;
    PageProducer1: TPageProducer;
    Image1: TImage;
    rdoGenerateForHowMany: TbsSkinRadioGroup;
    Scheduler: TTimer;
    lsvCustomerList: TbsSkinListView;
    cbxShowDetails: TbsSkinCheckRadioBox;
    FtpClSendPricelist: TFtpClient;
    SmtpSummary: TSmtpCli;
    cbxForce: TbsSkinCheckRadioBox;
    btnCancel: TbsSkinButton;
    ImageList1: TImageList;
    procedure btnProcessClick(Sender: TObject);
    procedure btnListClick(Sender: TObject);
    procedure SmtpEmailSinuDisplay(Sender: TObject; Msg: String);
    procedure SmtpEmailSinuRequestDone(Sender: TObject; RqType: TSmtpRequest;
      ErrorCode: Word);
    procedure btnPreviewClick(Sender: TObject);
    procedure SmtpEmailDisplay(Sender: TObject; Msg: String);
    procedure SmtpEmailRequestDone(Sender: TObject; RqType: TSmtpRequest;
      ErrorCode: Word);
    procedure SchedulerTimer(Sender: TObject);
    procedure lsvCustomerListChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure cbxShowDetailsClick(Sender: TObject);
    procedure FtpClSendPricelistStateChange(Sender: TObject);
    procedure FtpClSendPricelistDisplay(Sender: TObject; var Msg: String);
    procedure FtpClSendPricelistRequestDone(Sender: TObject;
      RqType: TFtpRequest; ErrCode: Word);
    procedure btnCancelClick(Sender: TObject);
    procedure FtpClSendPricelistError(Sender: TObject; var Msg: String);
    procedure lsvCustomerListChanging(Sender: TObject; Item: TListItem;
      Change: TItemChange; var AllowChange: Boolean);
    procedure FtpClSendPricelistProgress(Sender: TObject; Count: Integer;
      var Abort: Boolean);
  private
	  { Private declarations }
	  fSkinData           : TbsSkinData;
    fDocRegistry        : GTDDocumentRegistry;
    fplBuilder          : TBuildPricelistFromDBRun;
    fplBuildConfig      : TBuildPricelistFromDBConfig;
    fLatestpl           : GTDPricelist;

    fNeedToStop,
    fConnectionErr,
    fProcessing ,
    fSendToAll          : Boolean; {Sinu}

    fUploadSize         : Integer;

    fPricelistFormat    : String;

    function CollectEmailDistributionList:Boolean;
    function CreateHTMLEmailfromTemplate(TemplateFileName : String):Boolean;
    function EmailFileSetToCustomer:Boolean;

    function SendEmail(AFileName,AEmailId,delivFormat : String; PricelistRef : GTDPricelist):Boolean;
    function SendFTP(AFileName,delivFormat : String; PricelistRef : GTDPricelist):Boolean;

    procedure MoveProgressBar;
  public
    { Public declarations }
    function Init:Boolean;
    function SendToAll:Boolean;
    function SendToTrader(Trader_ID : Integer; ForcedSend : Boolean = False):Boolean;
    function Cancel:Boolean;
    procedure Report(const msgType, msgText : String; newState : Integer = -1);

    procedure SetSkinData(Value: TbsSkinData);
    procedure SetPriceListTimer(ASeconds : Integer);

    procedure ProcessSetup(var aMsg : TMsg); message GTTM_SETUP;
    procedure ProcessCurrent(var aMsg : TMsg); message GTTM_PROCESS_CURRENT;
    procedure ProcessMoveNext(var aMsg : TMsg); message GTTM_MOVE_NEXT;
    procedure ProcessFinalCleanup(var aMsg : TMsg); message GTTM_CLEANUP;
    {
    procedure ProcessErrorStart(var aMsg : TMsg); message GTTM_ERRSTART;
    }

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
  PL_DELIV_LAST_RUN     = 'Last_Run';
  PL_DELIV_LAST_SENT    = 'Last_Sent';
  PL_DELIV_MECHANISM    = 'Delivery_Mechanism';
  PL_DELIV_MECH_FTP     = 'FTP';
  PL_DELIV_MECH_SMTP    = 'SMTP';

  PL_FTP_DELIV_HOST     = 'FTP_Host';
  PL_FTP_DELIV_USER     = 'FTP_User';
  PL_FTP_DELIV_PASSWD   = 'FTP_Password';
  PL_FTP_DELIV_DIR      = 'FTP_Directory';

  // -- Display states, these correspond to the states in the icon
  PL_CLNT_STATE_READY   = 0;
  PL_CLNT_STATE_BUSY    = 1;
  PL_CLNT_STATE_SEND    = 2;
  PL_CLNT_STATE_ERROR   = 3;
  PL_CLNT_STATE_DONE    = 4;

implementation
  uses DateUtils,FastStringFuncs;

{$R *.DFM}

function TPricelistGenerator.Init:Boolean;
var
  sStatus : String;
begin
    // -- Create a new registry object if one isn't assigned
    if not Assigned(fDocRegistry) then
    begin
        fDocRegistry := GTDDocumentRegistry.Create(Self);
        fDocRegistry.Visible := False;
    end;

    // -- Open the registry
    fDocRegistry.OpenRegistry('',sStatus);

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

    fSendToAll := False;

    CollectEmailDistributionList; {Collect all traders}
end;

procedure TPricelistGenerator.SetSkinData(Value: TbsSkinData);
begin
  pnlBack.SkinData := Value;
  mmoLog.SkinData := Value;
  mmoErrLog.SkinData := Value;{Sinu}
  gbErrorLog.SkinData := Value;{Sinu}

  lsvCustomerList.SkinData := Value;
  rdoGenerateForHowMany.SkinData := Value;
  btnProcess.SkinData := Value;
  sgProgress.SkinData := Value;

  btnList.SkinData := Value;
  pnlSettings.SkinData := Value;
  cbxSpecialsOnly.SkinData := Value;
  cbxNewProducts.SkinData := Value;
  cbxFullPricelist.SkinData := Value;
  btnPreview.SkinData := Value;
  btnCancel.SkinData := Value;
  cbxTemplateName.SkinData := Value;
  lblTemplateName.SkinData := Value;
  cbxShowDetails.SkinData := Value;

end;

function TPricelistGenerator.SendToAll:Boolean;
var
	iCount : Integer;
begin

  // -- Generate pricelists for everybody
  fSendToAll          := True;
  iCount              := 0;

  // -- Start at the top
  qryFindTargets.First;
  lsvCustomerList.Selected := lsvCustomerList.Items[0];

  // -- Get the window to disable all the appropriate controls   
  PostMessage(Handle,GTTM_SETUP,0,0);

  // -- Send to the currently selected trader
  PostMessage(Handle,GTTM_PROCESS_CURRENT,0,0);

end;

procedure TPricelistGenerator.btnProcessClick(Sender: TObject);
begin
    if rdoGenerateForHowMany.ItemIndex = 1 then
        SendToAll
    else begin
        if Assigned(lsvCustomerList.Selected) then
        begin
          // -- Lookup the TraderID
          if qryFindTargets.Locate(GTD_DB_COL_TRADER_ID,VarArrayOf([StrToInt(lsvCustomerList.Selected.SubItems[2])]),[]) then
            SendToTrader(qryFindTargets.FieldByName(GTD_DB_COL_TRADER_ID).AsInteger,cbxForce.Checked)
          else
            bsSkinMessage1.MessageDlg('Customer not found.',mtError,[mbOk],0);

        end
        else
          bsSkinMessage1.MessageDlg('No Customer selected',mtError,[mbOk],0);
    end;
end;

function TPricelistGenerator.CollectEmailDistributionList:Boolean;
var
    newItem : TListItem;
    ListCount,tid : Integer;
    v : String;
    dt : TDateTime;
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
    lsvCustomerList.Items.Clear;
    First;
    ListCount :=0;
    while not Eof do
    begin

      tid := FieldByName(GTD_DB_COL_TRADER_ID).AsInteger;

      // -- Open this Trader
      if fDocRegistry.OpenForTraderNumber(tid) then
      begin

        // -- Add the company to the list
        newItem := lsvCustomerList.Items.Add;
        newItem.Caption := fDocRegistry.Trader_Name;
        newItem.StateIndex := 0;

        // -- Last run
        v := '';
        fDocRegistry.GetTraderSettingString(PL_DELIV_NODE,PL_DELIV_LAST_RUN,v);
        if v = '' then
        begin
            dt := fDocRegistry.GetLatestPriceListDateTime;
            if (dt = 0) then
                v := 'Never'
            else
                v := DateTimeToStr(dt);
        end;
        newItem.SubItems.Add(v);

        // -- Last sent
        v := '';
        fDocRegistry.GetTraderSettingString(PL_DELIV_NODE,PL_DELIV_LAST_SENT,v);
        newItem.SubItems.Add(v);

        newItem.SubItems.Add(FieldByName(GTD_DB_COL_TRADER_ID).AsString);

      end;

      Next;
    end;

	end;

  // -- Update the label
  lblListCount.Caption := IntToStr(ListCount) + ' Customers found';
end;

function TPricelistGenerator.Cancel:Boolean;
begin
end;

procedure TPricelistGenerator.btnListClick(Sender: TObject);
begin
  CollectEmailDistributionList;
  lsvCustomerList.Visible := not lsvCustomerList.Visible;
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
    Report('STATUS','Sending Pricelist',PL_CLNT_STATE_SEND);
    Report('SHOW','Mail server connected Successfully.');
    Report('SHOW','Sending price list.');

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
    sgProgress.Visible := False;
    Report('SHOW','Product Data Mailed Successfully');
    Report('STATUS','Complete',PL_CLNT_STATE_DONE);

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

        Report('NOT SENT','Product Data generated but not sent.',PL_CLNT_STATE_ERROR);
      end;
    end
    else
    begin
      // -- Display the error message
      Report('ERROR','Error ' + IntToStr(ErrorCode) + ' encountered',PL_CLNT_STATE_ERROR);
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

function TPricelistGenerator.SendToTrader(Trader_ID : Integer; ForcedSend : Boolean):Boolean;

  procedure ResetBeforeExit;
  begin
    fProcessing         := False;
    sgProgress.Value    := 100;
    sgProgress.Visible  := False;
    Screen.Cursor       := crDefault;

    btnProcess.Enabled  := True;
  end;

var
  sFormat,sColName,sColumns,sFileName , sFrequency , sLastSent, sDelType: String;
  dLastSent: TDateTime;
  fTimeDiff : Double;
  i,xd, iColCount : Integer;
  bNeedToProcess : Boolean;

begin
  Result := False;
  // -- Use the registry to load the trader record
  if not Assigned(fDocRegistry) then
    Exit;

  // -- Load up the trader
  if fDocRegistry.OpenForTraderNumber(Trader_ID) then
  begin
    MoveProgressBar;

    // -- Progess display
    Report('STATUS','Checking Pricelist',PL_CLNT_STATE_BUSY);
    Report('SHOW','Checking pricelist for ' + fDocRegistry.Trader_Name);

    // -- Create a pricelist if not already done
    if not Assigned(fLatestpl) then
      fLatestpl := GTDPricelist.Create(Self)
    else
      fLatestpl.Clear;

    // -- Retrieve the Customers latest pricelist
    if not fDocRegistry.GetLatestPriceList(GTDBizDoc(fLatestpl))then
    begin
      // -- If not then use the standard pricelist
      if FileExists(GTD_CURRENT_PRICELIST) then
        fLatestpl.xml.LoadFromFile(GTD_CURRENT_PRICELIST)
      else
        // -- No pricelist to load, didn't work
        Exit;
    end
    else
      // -- Yes we could load the pricelist
      Report('SHOW','Using pricelist from ' + DateTimeToStr(fLatestpl.Document_Date));

    // -- Get pricelist delivery frequency
    fDocRegistry.GetTraderSettingString(PL_DELIV_NODE,PL_DELIV_FREQUENCY,sFrequency);

    // -- Get the time when the pricelist delivered  previously
    fDocRegistry.GetTraderSettingString(PL_DELIV_NODE,PL_DELIV_LAST_SENT,sLastSent);
    if Trim(sLastSent) <> '' then
    begin
      // -- Here we determine if it is time to send again
      dLastSent   := StrToDateTime(sLastSent);
      fTimeDiff   := DaysBetween(Now ,dLastSent);
      sFrequency  := UpperCase(Trim(sFrequency));

      bNeedToProcess := False;

      // -- Check the last sent date. Here it is a little complicated
      if (fLatestpl.Document_Date > dLastSent) then
      begin
        // -- Time to send ?
        bNeedToProcess := ((sFrequency = UpperCase(PL_DELIV_FREQ_DAILY)) and (fTimeDiff >= 1)) or
                ((sFrequency = UpperCase(PL_DELIV_FREQ_WEEKLY)) and (fTimeDiff >= 7)) or
                ((sFrequency = UpperCase(PL_DELIV_FREQ_FORTNIGHT)) and (fTimeDiff >= 14)) or
                (sFrequency = UpperCase(PL_DELIV_FREQ_INSTANT));
      end
      else begin
        // -- Check if it was a forced send
        bNeedToProcess := ForcedSend;
      end;

      // -- Display the results
      if not bNeedToProcess then
        Report('SHOW','No changes since sent last.',PL_CLNT_STATE_READY);

      if not bNeedToProcess then
      begin
        PostMessage(Handle,GTTM_MOVE_NEXT,0,0);
        Exit;
      end

    end;

    // -- Retrieve the format that they want the pricelist in
    fDocRegistry.GetTraderSettingString(PL_DELIV_NODE,PL_DELIV_FORMAT,sFormat);

    iColCount := 0;

    // -- Save this for later
    fPricelistFormat := sFormat;

    // -- Depending on the format required
    iColCount := 0;
    if (sFormat = PL_DELIV_CSV) then
      fDocRegistry.GetTraderSettingInt('/CSV Pricelist Output','Column_Count',iColCount)
    else if (sFormat = PL_DELIV_XLS) then
      fDocRegistry.GetTraderSettingInt('/XLS Pricelist Output','Column_Count',iColCount)
    else if (sFormat = PL_DELIV_XML) then
      fDocRegistry.GetTraderSettingInt('/XML OutputFormat','Column_Count',iColCount);

    if iColCount = 0 then
      // -- There were no standard columns defined
      sColumns := PL_OUTPUT_STD_COLUMNS
    else begin
      // -- Force a reload on the config file
      sColumns := '';
      for xd := 1 to iColCount do
      begin
        // -- Add in a custom column for every definition
        sColumns := '<Custom Column>;' + sColumns;
      end;
    end;

    // -- Add all the column names from the definition
    if Trim(fDocRegistry.Trader_Name) = '' then
      sFileName := PL_PRICELIST_FILENAME
    else
    begin
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

      Report('STATUS','Converting pricelist to CSV');

      // -- Save the price list in csv format
      fLatestpl.ExportAsStandardCSV(sFileName,sColumns,False);

      MoveProgressBar;
    end
    else if (sFormat = PL_DELIV_XLS) then
    begin
      sFileName := sFileName + '.xls';

      Report('STATUS','Converting pricelist to XLS');

      // -- Save the price list in xls format
      fLatestpl.ExportAsXLS(fDocRegistry, sFileName,sColumns);

      MoveProgressBar;

    end
    else if (sFormat = PL_DELIV_XML) then
    begin
      sFileName := sFileName + '.xml';

      Report('STATUS','Converting pricelist to XML');

      // -- Save the price list in xls format
      fLatestpl.ExportAsXML(fDocRegistry,sFileName,sColumns);

      MoveProgressBar;
    end;

    // -- Retrieve the delivery mechanism
    fDocRegistry.GetTraderSettingString(PL_DELIV_NODE,PL_DELIV_MECHANISM, sDelType);

    if (sDelType = PL_DELIV_MECH_FTP) then
    begin

      // -- Send te file by FTP
      SendFTP(sFileName,sFormat,fLatestpl);

    end
    else

      // -- Send the file to the customer by email
      SendEmail(sFileName,qryFindTargets.FieldByName(GTD_DB_COL_EMAILADDRESS).AsString,sFormat,fLatestpl);

  end;

end;

function TPricelistGenerator.SendEmail(AFileName,AEmailId,delivFormat : String; PricelistRef : GTDPricelist): Boolean;

    procedure BuildMessageBody;
    var
        s : String;
    begin
      SmtpEmail.MailMessage.Clear;

      fDocRegistry.GetTraderSettingString(PL_DELIV_NODE,'Email_BodyText',s);

      s := Trim(s);

      // -- Check for custom message body, or use standard one
      if (s <> '') then
      begin
        // -- Custom defined email message body
        SmtpEmail.MailMessage.Add(s);
      end
      else begin

        // -- Here we will use the first word of the contact field
        s := qryFindTargets.FieldByName(GTD_DB_COL_CONTACT).AsString;
        if (s = '') then
          SmtpEmail.MailMessage.Add('Hello,')
        else
          SmtpEmail.MailMessage.Add('Hi ' + Parse(s,' ') + ',');

        SmtpEmail.MailMessage.Add('');
        SmtpEmail.MailMessage.Add('Please find our latest Pricelist.');

        // -- Build the message
        SmtpEmail.MailMessage.Add('');
  //    SmtpEmail.MailMessage.Add('  Items  : ' + IntToStr(PricelistRef.xml.Count));
        SmtpEmail.MailMessage.Add('  Date   : ' + DateTimeToStr(Now));
        SmtpEmail.MailMessage.Add('  Format : ' + UpperCase(delivFormat));
  //    SmtpEmail.MailMessage.Add('  Frequency : ' + IntToStr(PricelistRef.xml.Count));

        SmtpEmail.MailMessage.Add('');
        SmtpEmail.MailMessage.Add('Best Regards');
        SmtpEmail.MailMessage.Add('');
        SmtpEmail.MailMessage.Add(fDocRegistry.GetCompanyName);

      end;
    end;
var
  s : String;

begin
  if not Assigned(fDocRegistry) then
    Exit;

  SmtpEmail.HdrTo      := AEmailId;

  // -- Build the message subject
  if fDocRegistry.GetTraderSettingString(PL_DELIV_NODE,'Email Subject',s) then
  begin
    // -- Use the Custom message subject
    SmtpEmail.HdrSubject := s
  end;

  if SmtpEmail.HdrSubject='' then
  begin
    // -- No custom message subject. So build one from the company name
    if fDocRegistry.GetCompanyName <> '' then
      s := 'Latest Pricelist from ' + fDocRegistry.GetCompanyName
    else
      s := 'Latest Price List';
    SmtpEmail.HdrSubject := s;
  end;

  // -- Load the appropriate configuration record
  if not fDocRegistry.GetSettingString(GTD_REG_NOD_GENERAL,GTD_REG_USER_EMAIL,s) then
  begin
      // -- Might be a new record
      Report('Error','Unable to load configuration. Template not available');
      Exit;
  end
  else begin
      if fDocRegistry.GetSettingMemoString('/Settings',GTD_REG_EMAIL_HOST,s) then
          SmtpEmail.Host := s
      else
          SmtpEmail.Host := '';

      if fDocRegistry.GetSettingMemoString('/Settings',GTD_REG_EMAIL_LOGINREQ,s) then
      begin
          if (s = 'True') then
          begin
              SmtpEmail.AuthType  := smtpAuthLogin;

              if fDocRegistry.GetSettingMemoString('/Settings',GTD_REG_EMAIL_USERNAME,s) then
                  SmtpEmail.UserName := s
              else
                  SmtpEmail.UserName := '';

              if fDocRegistry.GetSettingMemoString('/Settings',GTD_REG_EMAIL_PASSWORD,s) then
                  SmtpEmail.Password := s
              else
                  SmtpEmail.Password := '';
          end
          else
              SmtpEmail.AuthType  := smtpAuthNone;
      end
      else
          SmtpEmail.AuthType  := smtpAuthNone;

      if fDocRegistry.GetSettingMemoString('/Settings',GTD_REG_EMAIL_DISPLAYNAME,s) then
      begin
          SmtpEmail.FromName:= s;
          SmtpEmail.HdrFrom := s;
      end
      else
          SmtpEmail.HdrFrom := '';
      end;

//    end;

  // -- Set the recipient
  SmtpEmail.HdrTo := AEmailId;
  SmtpEmail.RcptName.Clear;
  SmtpEmail.RcptName.Add(AEmailId);

  // -- Attach the attachments
  SmtpEmail.EmailFiles.Clear;
  SmtpEmail.EmailFiles.Add(AFileName);

  // -- Attach the message
  BuildMessageBody;

  // -- Now send mail
  while not (SmtpEmail.State in [smtpReady, smtpInternalReady]) do
  begin
    Application.ProcessMessages;
    Report('Show','Email component not ready');
  end;

  // -- Now connect
  SmtpEmail.Connect;

end;

procedure TPricelistGenerator.SmtpEmailDisplay(Sender: TObject;
  Msg: String);
begin
  Report('Show',Msg);
end;

procedure TPricelistGenerator.SmtpEmailRequestDone(Sender: TObject;
  RqType: TSmtpRequest; ErrorCode: Word);
var
  xc : Integer;
  s : String;
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
    btnProcess.Enabled  := False;
    Screen.Cursor           := crHourGlass;

    // -- Do the mailing
    Report('SHOW','Connected to Mail server.');
    Report('STATUS','Sending Pricelist.',PL_CLNT_STATE_SEND);
    MoveProgressBar;
    SmtpEMail.Mail;

    //sgProgress.Value := iRecord * 40;
  end
  else if (RqType = smtpMail) and (ErrorCode = 0) then
  begin

    Report('SHOW','Pricelist sent.',PL_CLNT_STATE_DONE);

    // -- Set current time as the delivery time
    fDocRegistry.SaveTraderSettingString(PL_DELIV_NODE,PL_DELIV_LAST_SENT,DateTimeToStr(Now));

    //sgProgress.Value := iRecord * 90;
    MoveProgressBar;
    // -- Write every entry
    for xc :=1 to SmtpEmail.EmailFiles.Count do
      Report('SENT','Successfully sent ' + SmtpEmail.EmailFiles.Strings[xc-1]);

    SmtpEmail.Quit;

    // -- Now change the document status to sent
    if Assigned(fLatestpl) then
    begin
      // -- Change the status
      fLatestpl.Local_Status_Code := GTD_AUDITCD_SND;

      // -- Save it back in the registry
      s := fPricelistFormat + ' Pricelist sent to ';
      for xc := 0 to SmtpEmail.RcptName.Count-1 do
      begin
        s := s + SmtpEmail.RcptName[xc] + ',';
      end;

      // -- Save the updated pricelist
      fDocRegistry.Save(fLatestpl,GTD_AUDITCD_SND,s);

    end;

    fProcessing := False;
  end
  else if (RqType = smtpQuit) and (ErrorCode = 0) then
  begin
    //sgProgress.Value := iRecord * 100;
    MoveProgressBar;

    Report('SHOW','Session closed Successfully');
    Report('COMPLETE','Product Data Mailing Function complete.');
    sgProgress.Visible := False;
    Report('SHOW','Product Data Mailed Successfully to ' + SmtpEmail.HdrTo);

    fProcessing             := False;

    PostMessage(Handle,GTTM_MOVE_NEXT,0,0);

  end
  else if (ErrorCode <> 0) then
  begin
    fConnectionErr      := True;

    Screen.Cursor       := crDefault;

    if (ErrorCode = 11004) then
    begin
      if mrYes = bsSkinMessage1.MessageDlg('You are not Connected: Do you want to generate files to manually email anyway?',mtConfirmation,[mbYes, mbNo, mbCancel],0) then
      begin
        Report('NOT SENT','Product Data generated but not sent.',PL_CLNT_STATE_ERROR);
      end;
    end
    else
    begin
      // -- Display the error message
      Report('ERROR','Error ' + IntToStr(ErrorCode) + ' encountered',PL_CLNT_STATE_ERROR);
    end;
    fProcessing := False;

    // -- Better luck with the next record
    PostMessage(Handle,GTTM_MOVE_NEXT,0,0);

  end;
end;

procedure TPricelistGenerator.MoveProgressBar;
begin
  sgProgress.Value := sgProgress.Value + 1;
end;

procedure TPricelistGenerator.Report(const msgType, msgText : String; newState : Integer);
begin
  if (msgType = 'STATUS') then
  begin
    // --
    lblStatus.Caption := msgText;
    lblStatus.Update;
  end
  else begin
    // -- Display it in the box
    mmoErrLog.Lines.Add(msgtype + ' - ' + msgText);
    mmoErrLog.Update;
  end;

  if (newState <> -1) then
  begin
    if Assigned(lsvCustomerList.Selected) then
      lsvCustomerList.Selected.StateIndex := newState;
  end;

end;

procedure TPricelistGenerator.SetPriceListTimer(ASeconds: Integer);
begin
  Scheduler.Enabled   := False;
  Scheduler.Interval  := 1000 * ASeconds;

  // -- Turn off the schedular with a 0 or -1 value
  if (ASeconds <> 0) and (ASeconds <> -1) then
    Scheduler.Enabled := True
  else
    Scheduler.Enabled := False;

  if Scheduler.Enabled then
    Report('STATUS','Waiting on Scheduler')
  else
    Report('STATUS','Ready');

end;

procedure TPricelistGenerator.SchedulerTimer(Sender: TObject);
begin
  if Not fSendToAll then
    SendToAll;
end;

procedure TPricelistGenerator.lsvCustomerListChange(Sender: TObject;
  Item: TListItem; Change: TItemChange);
begin
  if (Item = lsvCustomerList.Selected) and (Change = ctState) then
  begin
  end;
end;

procedure TPricelistGenerator.cbxShowDetailsClick(Sender: TObject);
begin
  if not cbxShowDetails.Checked then
  begin
    // --
    lsvCustomerList.Visible := True;
  end
  else begin
    // --
    lsvCustomerList.Visible := False;
  end;
end;

function TPricelistGenerator.SendFTP(AFileName,delivFormat : String; PricelistRef : GTDPricelist):Boolean;
var
  sUser,sPasswd,sHostName,sDir : String;
begin

  // -- Read the ftp settings from the trader configuration record
  fDocRegistry.GetTraderSettingString(PL_DELIV_NODE,PL_FTP_DELIV_HOST, sHostName);
  fDocRegistry.GetTraderSettingString(PL_DELIV_NODE,PL_FTP_DELIV_USER, sUser);
  fDocRegistry.GetTraderSettingString(PL_DELIV_NODE,PL_FTP_DELIV_PASSWD, sPasswd);
  fDocRegistry.GetTraderSettingString(PL_DELIV_NODE,PL_FTP_DELIV_DIR, sDir);

  FtpClSendPricelist.UserName := sUser;
  FtpClSendPricelist.HostName := sHostName;
  FtpClSendPricelist.PassWord := sPasswd;
  FtpClSendPricelist.HostDirName := sDir;

  FtpClSendPricelist.LocalFileName := aFileName;
  FtpClSendPricelist.HostFileName := ExtractFileName(aFileName);

  Report('STATUS','Connecting to FTP Site');

  FtpClSendPricelist.Tag := 0;
  fUploadSize := 0;

  FtpClSendPricelist.Connect;

end;

procedure TPricelistGenerator.FtpClSendPricelistStateChange(
  Sender: TObject);
begin
  Report('Show','State' + IntToStr(Ord(FtpClSendPricelist.State)));

  if fNeedToStop then
    Exit;

  // -- Do we need to change directory
  if ((FtpClSendPricelist.State = ftpReady) and (FtpClSendPricelist.Tag = 0)) then
  begin
    FtpClSendPricelist.CwdAsync;
    FtpClSendPricelist.Tag := 1;
  end;

  if ((FtpClSendPricelist.State = ftpReady) and (FtpClSendPricelist.Tag = 1)) then
  begin
    Report('STATUS','Uploading file',PL_CLNT_STATE_SEND);

    FtpClSendPricelist.Tag := 2;
    FtpClSendPricelist.Put;

  end;

  if (FtpClSendPricelist.State = ftpNotConnected) then
    Report('STATUS','Done');

end;

procedure TPricelistGenerator.FtpClSendPricelistDisplay(Sender: TObject;
  var Msg: String);
var
  s : String;
begin
  Report('Show',Msg);
  if Pos('! Upload Size',Msg) <> 0 then
  begin
    s := RightStr(Msg,Length(Msg)-14);
    fUploadSize := StrToInt(s);
  end;

end;

procedure TPricelistGenerator.FtpClSendPricelistRequestDone(
  Sender: TObject; RqType: TFtpRequest; ErrCode: Word);
begin
  if RqType = ftpPutAsync then
  begin
    fProcessing := False;

    if ErrCode = 0 then
    begin

      Report('Show','Uploaded');
      Report('STATUS','Done',PL_CLNT_STATE_DONE);

      FtpClSendPricelist.Quit;
    end
    else begin
      // -- We had an upload error
      Report('Error','Error uploading',PL_CLNT_STATE_ERROR);
    end;

    // -- Move onto the next record
    PostMessage(Handle,GTTM_MOVE_NEXT,0,0);

  end
  else begin

      if (ErrCode <> 0) then
      begin

        // -- Report the error
        Report('Error','Error connecting',PL_CLNT_STATE_ERROR);

        // -- Move onto the next record
        PostMessage(Handle,GTTM_MOVE_NEXT,0,0);

      end
      else
        Report('Show','Request done' + IntToStr(Ord(RqType)));

  end

end;

procedure TPricelistGenerator.btnCancelClick(Sender: TObject);
begin
  fNeedToStop := True;
end;

procedure TPricelistGenerator.ProcessSetup(var aMsg : TMsg);
begin
  // -- Take care of some screen things
  Screen.Cursor           := crHourGlass;
  rdoGenerateForHowMany.Visible := False;
  btnProcess.Visible  := False;
  sgProgress.Visible      := True;
  sgProgress.Value        := 1;
  sgProgress.MaxValue     := 11;
  rdoGenerateForHowMany.Enabled    := False;
  btnProcess.Enabled  := False;
  fNeedToStop             := False;
  btnCancel.Visible       := True;
end;

procedure TPricelistGenerator.ProcessCurrent(var aMsg : TMsg);
begin
  SendToTrader(qryFindTargets.FieldByName('Trader_ID').AsInteger);
end;

procedure TPricelistGenerator.ProcessMoveNext(var aMsg : TMsg);
begin
  if fSendToAll and not(fNeedToStop) then
  begin
    // -- Advance to the next record in the set
    qryFindTargets.Next;
    if not qryFindTargets.Eof then
    begin

      // -- Now move to the next item in the list
      lsvCustomerList.Selected := lsvCustomerList.Items[lsvCustomerList.Selected.Index + 1];

      // -- Initiate the next transfer
      PostMessage(Handle,GTTM_PROCESS_CURRENT,0,0);
    end
    else begin
      // -- Looks like we are finished so do a cleanup
      PostMessage(Handle,GTTM_CLEANUP,0,0);
    end;
  end else
    // -- Looks like we are finished so do a cleanup
    PostMessage(Handle,GTTM_CLEANUP,0,0);
end;

procedure TPricelistGenerator.ProcessFinalCleanup(var aMsg : TMsg);
begin
  // -- Cleanup
  Screen.Cursor := crDefault;
  btnProcess.Enabled := True;
  btnProcess.Visible := True;
  btnCancel.Visible := False;
  rdoGenerateForHowMany.Visible    := True;
  lsvCustomerList.Visible := True;
  sgProgress.Visible      := False;
  fNeedToStop             := False;
  fSendToAll := False;

  Report('STATUS','Completed.');

end;


procedure TPricelistGenerator.FtpClSendPricelistError(Sender: TObject;
  var Msg: String);
begin
  Report('ERROR','FTP Error : ' + Msg,PL_CLNT_STATE_ERROR);

  // -- Better luck with the next record
  PostMessage(Handle,GTTM_MOVE_NEXT,0,0);
end;

procedure TPricelistGenerator.lsvCustomerListChanging(Sender: TObject;
  Item: TListItem; Change: TItemChange; var AllowChange: Boolean);
begin
  {
  if fSendToAll then
    AllowChange := False;
  }
end;

procedure TPricelistGenerator.FtpClSendPricelistProgress(Sender: TObject;
  Count: Integer; var Abort: Boolean);
begin
  // Report('PROGRESS',IntToStr(Count div 1024));

  if (fUploadSize <> 0) then
      Report('STATUS','Uploading ' + IntToStr((Count * 100) div fUploadSize) + '%');

  Abort := fNeedToStop;
end;

end.

