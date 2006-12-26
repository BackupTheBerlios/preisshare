unit PricelistGenerate;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, bsSkinData,bsSkinBoxCtrls, bsSkinCtrls, ComCtrls, Db, DBTables, GTDBizDocs,
  SmtpProt, bsSkinGrids, bsDBGrids, bsMessages,ShellAPI,
  GTDBuildPricelistFromDBRun,GTDBuildPricelistFromDBConfig,GTDPricelists;

type
  TPricelistGenerator = class(TFrame)
    btnGenerateAll: TbsSkinButton;
    sgProgress: TbsSkinGauge;
	qryFindTargets: TQuery;
    pnlBack: TbsSkinPanel;
    SmtpCli1: TSmtpCli;
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
    btnGenerate1: TbsSkinSpeedButton;
    procedure btnGenerateAllClick(Sender: TObject);
    procedure btnListClick(Sender: TObject);
    procedure lblListCountClick(Sender: TObject);
    procedure SmtpCli1Display(Sender: TObject; Msg: String);
    procedure SmtpCli1RequestDone(Sender: TObject; RqType: TSmtpRequest;
      ErrorCode: Word);
    procedure btnPreviewClick(Sender: TObject);
    procedure btnGenerate1Click(Sender: TObject);
  private
	{ Private declarations }
	fSkinData           : TbsSkinData;
    fDocRegistry        : GTDDocumentRegistry;
    fplBuilder          : TBuildPricelistFromDBRun;
    fplBuildConfig      : TBuildPricelistFromDBConfig;

    function CollectEmailDistributionList:Boolean;
    function CreateHTMLEmailfromTemplate(TemplateFileName : String):Boolean;
    function EmailFileSetToCustomer:Boolean;

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
    PL_DELIV_NODE = '/Pricelist Delivery';
    PL_DELIV_FORMAT = 'Delivery_Format';
    PL_DELIV_CSV = 'CSV';
    PL_DELIV_XLS = 'XLS';
    PL_DELIV_XML = 'XML';
    PL_OUTPUT_STD_COLUMNS = GTD_PL_ELE_PRODUCT_PLU + ';' + GTD_PL_ELE_PRODUCT_NAME + ';'
                            + GTD_PL_ELE_PRODUCT_LIST + ';' + GTD_PL_ELE_PRODUCT_ACTUAL; 

    PL_DELIV_FREQUENCY = 'Update_Frequency';
    PL_DELIV_FREQ_INSTANT = 'Instant';
    PL_DELIV_FREQ_DAILY = 'Daily';
    PL_DELIV_FREQ_WEEKLY = 'Weekly';
    PL_DELIV_FREQ_FORTNIGHT = 'Fortnightly';
    PL_DELIV_FREQ_MONTHLY = 'Monthly';

implementation

{$R *.DFM}

function TPricelistGenerator.Init:Boolean;
var
	newItem : TListItem;
begin

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

    {
    if not Assigned(fplBuildConfig) then
    begin
        fplBuildConfig := TBuildPricelistFromDBConfig.Create(Self);
        with fplBuildConfig do
        begin
            Left := 750;
            Top  := 10;
            Parent := Self;
            DocRegistry := fDocRegistry;
            Visible := True;
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
            Visible := True;
            Configuration := fplBuildConfig;
            DocRegistry := fDocRegistry;
        end;
    end;
    }

end;

procedure TPricelistGenerator.SetSkinData(Value: TbsSkinData);
begin
	pnlBack.SkinData := Value;
	mmoLog.SkinData := Value;
	lsvItems.SkinData := Value;
	btnGenerate1.SkinData := Value;
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
	xc : Integer;
begin
	sgProgress.Visible := True;
	sgProgress.MaxValue := lsvItems.Items.Count;

	for xc := 2 to lsvItems.Items.Count do
	begin

		sgProgress.Value := xc;

		lsvItems.Items[xc-1].Caption := 'Running';
		lsvItems.Update;
		Sleep(500);

		lsvItems.Items[xc-1].Caption := 'Complete';

	end;
	sgProgress.Visible := False;
end;

procedure TPricelistGenerator.btnGenerateAllClick(Sender: TObject);
begin
    GenerateForAll;
end;

procedure TPricelistGenerator.btnGenerate1Click(Sender: TObject);
begin
    GenerateForTrader(qryFindTargets.FieldByName(GTD_DB_COL_TRADER_ID).AsInteger);
end;

function TPricelistGenerator.CollectEmailDistributionList:Boolean;
var
    newItem : TListItem;
    ListCount : Integer;
begin
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
    mmoLog.Lines.Clear;
    sgProgress.Visible := True;

    // -- Debugging code
    with SmtpCli1 do
    begin
        Connect;
    end;

end;

procedure TPricelistGenerator.SmtpCli1Display(Sender: TObject;
  Msg: String);
begin
    sgProgress.ProgressText := Msg;
    mmoLog.Lines.Add(Msg);
end;

procedure TPricelistGenerator.SmtpCli1RequestDone(Sender: TObject;
  RqType: TSmtpRequest; ErrorCode: Word);
var
    xc : Integer;

    procedure Report(aCode, aMsg : String);
    begin
        //sgProgress.ProgressText := aMsg;
        mmoLog.Lines.Add(aMsg);
    end;

begin

//     if (RqType = smtpConnect) and (ErrorCode = 0) then
//     begin
//        bsSkinGauge1.Value := 10;
//     end
//     else
     if (RqType = smtpAuth) and (ErrorCode = 0) then
     begin
        sgProgress.Value := 20;
     end
     else
     if (RqType = smtpConnect) and (ErrorCode = 0) then
     begin
        // -- Do the mailing
        Report('SHOW','Connected Successfully.');
        Report('SHOW','Now Mailing files - please wait');
        SmtpCli1.Mail;

        sgProgress.Value := 40;
     end
     else if (RqType = smtpMail) and (ErrorCode = 0) then
     begin
        sgProgress.Value := 90;

        // -- Write every entry
        for xc :=1 to SmtpCli1.EmailFiles.Count do
            Report('SENT','Successfully sent ' + SmtpCli1.EmailFiles.Strings[xc-1]);

        SmtpCli1.Quit;

     end
     else if (RqType = smtpQuit) and (ErrorCode = 0) then
     begin
        sgProgress.Value := 100;
        Report('SHOW','Session closed Successfully');
        Report('COMPLETE','Product Data Mailing Function complete.');

        sgProgress.Visible := False;

        Report('SHOW','Product Data Mailed Successfully');

    //    SmtpCli1.Quit;
//        PostMessage(Handle,GTTM_CLEANUP	,0,0);

     end
     else if (ErrorCode <> 0) then
     begin
        sgProgress.Visible := False;

        if (ErrorCode = 11004) then
        begin

            if mrYes = bsSkinMessage1.MessageDlg('You are not Connected: Do you want to generate files to manually email anyway?',mtConfirmation,[mbYes, mbNo, mbCancel],0) then
            begin

                sgProgress.Value := 100;
                sgProgress.Visible := False;

                Report('NOT SENT','Product Data generated but not sent.');
            end;

        end
        else begin
            // -- Display the error message
            Report('ERROR','Error ' + IntToStr(ErrorCode) + ' encountered');
        end;

      //  PostMessage(Handle,GTTM_CLEANUP	,0,0);

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
end;

function TPricelistGenerator.GenerateForTrader(Trader_ID : Integer):Boolean;
var
    pl : GTDPricelist;
    pf,cn,cl,oFileName : String;
    xc,cc : Integer;
begin
    // -- Use the registry to load the trader record
    if not Assigned(fDocRegistry) then
        Exit;

    // -- Load up the trader
    if fDocRegistry.OpenForTraderNumber(Trader_ID) then
    begin

        pl := GTDPricelist.Create(Self);

        // -- Retrieve the Customers latest pricelist
        if not fDocRegistry.GetLatestPriceList(GTDBizDoc(pl)) then
        begin
            // -- If not then use the standard pricelist
            if FileExists(GTD_CURRENT_PRICELIST) then
                pl.xml.LoadFromFile(GTD_CURRENT_PRICELIST)
            else
                // -- No pricelist to load, didn't work
                Exit;
        end;

        // -- Now see what format they want it in
        fDocRegistry.GetTraderSettingString('/Pricelist Delivery',PL_DELIV_FORMAT,pf);

        if (pf = PL_DELIV_CSV) then
        begin
            cc := 0;
            fDocRegistry.GetTraderSettingInt('/CSV Output Format','Column_Count',cc);

            // -- If there are no columns defined to use, then use the standard column list
            if (cc = 0) then
                cl := PL_OUTPUT_STD_COLUMNS
            else begin
                // -- Add all the column names from the definition
                for xc := 1 to cc do
                begin
                    // -- Retrieve every column
                    cn := '';
                    fDocRegistry.GetTraderSettingString('/CSV Output Format','Column_' + IntToStr(xc),cn);
                    cl := cl + cn;
                end;
            end;

            // -- Now output the file
            oFileName := fDocRegistry.Trader_Name + '.csv';
            pl.ExportAsStandardCSV(oFileName,cl,False);
        end
        else if (pf = PL_DELIV_XML) then
        begin
            cc := 0;
            fDocRegistry.GetTraderSettingInt('/XML Output Format','Column_Count',cc);

            // -- If there are no columns defined to use, then use the standard column list
            if (cc = 0) then
                cl := PL_OUTPUT_STD_COLUMNS
            else begin
                // -- Add all the column names from the definition
                for xc := 1 to cc do
                begin
                    // -- Retrieve every column
                    cn := '';
                    fDocRegistry.GetTraderSettingString('/XML Output Format','Column_' + IntToStr(xc),cn);
                    cl := cl + cn;
                end;
            end;

            // -- Now output the file
            oFileName := fDocRegistry.Trader_Name + '.xml';
            pl.ExportAsXML(oFileName,cl);

        end
        else if (pf = PL_DELIV_XLS) then
        begin
            cc := 0;
            fDocRegistry.GetTraderSettingInt('/XLS Output Format','Column_Count',cc);

            // -- If there are no columns defined to use, then use the standard column list
            if (cc = 0) then
                cl := PL_OUTPUT_STD_COLUMNS
            else begin
                // -- Add all the column names from the definition
                for xc := 1 to cc do
                begin
                    // -- Retrieve every column
                    cn := '';
                    fDocRegistry.GetTraderSettingString('/XLS Output Format','Column_' + IntToStr(xc),cn);
                    cl := cl + cn;
                end;
            end;

            // -- Now output the file
            oFileName := fDocRegistry.Trader_Name + '.xls';
            pl.ExportAsStandardXLS(oFileName,cl);

        end;

//      PL_DELIV_HTML   = 'HTML';
//      PL_DELIV_XLS    = 'XLS';

        // -- First see if they need a pricelist generated
        //    and if not use the standard retail pricelist
//        if fDocRegistry.GetTraderSettingBoolean('/Pricelist Delivery','Requires_Own_Pricelist') then
        begin

        end;

        // --

        Result := True;
    end;
end;


end.
