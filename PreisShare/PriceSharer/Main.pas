unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  bsSkinCtrls, ComCtrls, bsSkinTabs, bsTrayIcon, bsSkinData,
  BusinessSkinForm, Menus, bsSkinMenus, ExtCtrls, GTDGeoView, Db, ShellAPI,
  bsSkinBoxCtrls, StdCtrls, Mask, ScktComp, GTDBizLinks, CustomerLinks,
  GTDBizDocs, ImgList, Grids, DBGrids, DMaster, DDB, DTables,
  bsSkinGrids, bsDBGrids, bsSkinShellCtrls;

type
  TfrmMain = class(TForm)
    bsBusinessSkinForm1: TbsBusinessSkinForm;
    bsSkinData1: TbsSkinData;
    sknxFactor: TbsStoredSkin;
    bsTrayIcon1: TbsTrayIcon;
    nbkMain: TbsSkinPageControl;
    pgConnections: TbsSkinTabSheet;
    bsSkinButton1: TbsSkinButton;
    bsSkinPopupMenu1: TbsSkinPopupMenu;
    Shutdown1: TMenuItem;
    Restore1: TMenuItem;
    pgIdentity: TbsSkinTabSheet;
    DataSource1: TDataSource;
    bsSkinButton2: TbsSkinButton;
    bsSkinGroupBox1: TbsSkinGroupBox;
    bsSkinLabel1: TbsSkinLabel;
    CommunityLink: gtCommunityLink;
    bsSkinButton7: TbsSkinButton;
    bsSkinStdLabel1: TbsSkinStdLabel;
    bsSkinStdLabel2: TbsSkinStdLabel;
    bsSkinBevel2: TbsSkinBevel;
    bsSkinBevel3: TbsSkinBevel;
    Skin1: TMenuItem;
    rdoSkinxFactor: TMenuItem;
    bsSkinButton4: TbsSkinButton;
    bsSkinTabSheet3: TbsSkinTabSheet;
    lsvLog: TbsSkinListView;
    bsSkinButton5: TbsSkinButton;
    txtPassword: TbsSkinPasswordEdit;
    bsSkinLabel2: TbsSkinLabel;
    bsSkinTabSheet2: TbsSkinTabSheet;
    GTDConnectionList1: GTDConnectionList;
    DocRegistry: GTDDocumentRegistry;
    cbxLocalGTL: TbsSkinEdit;
    txtCustomerNum: TbsSkinEdit;
    bsSkinLabel3: TbsSkinLabel;
    bsSkinBevel4: TbsSkinBevel;
    bsSkinStdLabel3: TbsSkinStdLabel;
    bsSkinStdLabel4: TbsSkinStdLabel;
    bsSkinButtonLabel1: TbsSkinButtonLabel;
    bsSkinStdLabel5: TbsSkinStdLabel;
    bsSkinStdLabel6: TbsSkinStdLabel;
    bsSkinStdLabel7: TbsSkinStdLabel;
    bsSkinStdLabel8: TbsSkinStdLabel;
    bsSkinStdLabel9: TbsSkinStdLabel;
    bsSkinButton6: TbsSkinButton;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    EditProducts1: TMenuItem;
    mnuConnected: TMenuItem;
    N4: TMenuItem;
    CheckMailfornewPriceFiles1: TMenuItem;
    bsSkinStdLabel10: TbsSkinStdLabel;
    NetworkSearches1: TMenuItem;
    PriceChangeSummary1: TMenuItem;
    ImageList1: TImageList;
    Timer1: TTimer;
    EmailPriceliststoClients1: TMenuItem;
    AddProspectCustomer1: TMenuItem;
    dbProductDB: TDMaster;
    bsSkinTabSheet1: TbsSkinTabSheet;
    bsSkinLabel4: TbsSkinLabel;
    bsSkinTimeEdit1: TbsSkinTimeEdit;
    mmoTodayDoList: TbsSkinMemo;
    btnShowToday: TbsSkinSpeedButton;
    N6: TMenuItem;
    bsCompressedStoredSkin1: TbsCompressedStoredSkin;
    sknCorner: TbsStoredSkin;
    Corner1: TMenuItem;
    bsStoredSkin1: TbsStoredSkin;
    SmartStyle1: TMenuItem;
    N5: TMenuItem;
    BuildPricelistfromDB1: TMenuItem;
    bsOpenSkinDialog1: TbsOpenSkinDialog;
    Load1: TMenuItem;
    EmailPricelists1: TMenuItem;
    Configuration1: TMenuItem;
    Vie1: TMenuItem;
    SupplierDataFeeds1: TMenuItem;
    N7: TMenuItem;
    PriceRelay1: TMenuItem;
    procedure Restore1Click(Sender: TObject);
	procedure Shutdown1Click(Sender: TObject);
    procedure bsSkinButton1Click(Sender: TObject);
    procedure bsSkinButton2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bsSkinButton4Click(Sender: TObject);
    procedure CommunityLinkUserInformation(Sender: TObject; GTL,
      Description: String; PerCentComplete, IconIndex: Integer);
    procedure CommunityLinkStatusChange(Sender: TObject; GTL: String;
      NewStatus: gtSessionUserState; LongStatus: String);
    procedure bsSkinButton5Click(Sender: TObject);
    procedure bsSkinButton7Click(Sender: TObject);
    procedure mnuConnectedClick(Sender: TObject);
    procedure Search1Click(Sender: TObject);
    procedure NetworkSearches1Click(Sender: TObject);
    procedure EditProducts1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure AddProspectCustomer1Click(Sender: TObject);
    procedure bsSkinSpeedButton1Click(Sender: TObject);
    procedure FromXLSfile1Click(Sender: TObject);
    procedure EmailPriceliststoClients1Click(Sender: TObject);
    procedure btnShowTodayClick(Sender: TObject);
    procedure rdoSkinxFactorClick(Sender: TObject);
    procedure Corner1Click(Sender: TObject);
    procedure SmartStyle1Click(Sender: TObject);
    procedure BuildPricelistfromDB1Click(Sender: TObject);
    procedure Load1Click(Sender: TObject);
    procedure EmailPricelists1Click(Sender: TObject);
    procedure Configuration1Click(Sender: TObject);
    procedure Vie1Click(Sender: TObject);
    procedure PriceRelay1Click(Sender: TObject);
    procedure SupplierDataFeeds1Click(Sender: TObject);
  private
    { Private declarations }
	myConnections : TCustomerTcpListener;

    fSearchFormShown : Boolean;

    procedure DisplayIt(Msg : String);

  public
	{ Public declarations }
	procedure Initialise;
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.DFM}
Uses Data, Accounts, Settings, Search, NetworkSearches, ProductEdit,
     AdoAPI, ActiveX, ComObj, CustomerAdd, SpreadSheetImport, GenPricelists,
     NewsLetter, BuildDBPricelist, Config, LogView, RelayEditor,
  DataFeedEditor;

procedure TfrmMain.Restore1Click(Sender: TObject);
begin
    Show;
end;

procedure TfrmMain.Shutdown1Click(Sender: TObject);
begin
    Application.Terminate;
end;

procedure TfrmMain.bsSkinButton1Click(Sender: TObject);
begin
	Application.Minimize;
end;

procedure TfrmMain.bsSkinButton2Click(Sender: TObject);
begin
    ShellExecute(Self.ParentWindow,'open','CatalogWorkShop.exe',nil,nil,2);
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
    nbkMain.ActivePage := pgConnections;

	  myConnections := TCustomerTcpListener.Create(Self);

    myConnections.OnDisplay := DisplayIt;

    // -- There seems to be some bug somewhere so this needs to be done
	  Initialise;

end;

procedure TfrmMain.bsSkinButton4Click(Sender: TObject);
begin
    ShellExecute(Self.ParentWindow,'open','TradeDesk.exe',nil,nil,2);
end;

procedure TfrmMain.DisplayIt(Msg : String);
var
	newItem : TListItem;
begin
	newItem := lsvLog.Items.Add;
	newItem.Caption := FormatDateTime('c',Now);
	newItem.SubItems.Add(Msg);
end;

procedure TfrmMain.CommunityLinkUserInformation(Sender: TObject; GTL,
  Description: String; PerCentComplete, IconIndex: Integer);
begin
	DisplayIt(Description);
end;

procedure TfrmMain.CommunityLinkStatusChange(Sender: TObject; GTL: String;
  NewStatus: gtSessionUserState; LongStatus: String);
begin
	if NewStatus = gtusOnlineReady then
	begin
		// -- Here we have connected
		myConnections.CommunityLink := CommunityLink;
		myConnections.Start;

		Application.Minimize;

        mnuConnected.Caption := 'Disconnect';
        frmMain.Caption := 'PreisShare (Connected)';
        bsTrayIcon1.IconIndex := 1;

	end
    else begin
        mnuConnected.Caption := 'Connect';
        frmMain.Caption := 'PreisShare (Not Connected)';
        bsTrayIcon1.IconIndex := 0;
    end;
end;

procedure TfrmMain.bsSkinButton5Click(Sender: TObject);
begin
	if not Assigned(frmAccounts) then
		Application.CreateForm(TfrmAccounts, frmAccounts);

	frmAccounts.ShowModal;

end;

procedure TfrmMain.bsSkinButton7Click(Sender: TObject);
begin
	if not Assigned(frmSettings) then
		Application.CreateForm(TfrmSettings, frmSettings);

	frmSettings.ShowModal;

end;


procedure TfrmMain.Initialise;

    function GetADOVersion: Double;
    const
      Jet10           = 1;
      Jet11           = 2;
      Jet20           = 3;
      Jet3x           = 4;
      Jet4x           = 5;
      minAdoVersion   = 2.0;
    var
      oAdo            : _Connection;
      versionNumber   : double;
      version         : wideString;
    begin
      Result := -1;
      OleCheck(CoCreateInstance(CLASS_Connection, nil, CLSCTX_ALL,
        IID__Connection, oAdo));
      if Assigned(oAdo) then
        begin
          versionNumber := StringToFloat(oAdo.version);

          if versionNumber >= minAdoVersion then
          begin
    //        versionNumber := int(versionNumber) + 1;
              version := FormatFloat('##.##',versionNumber);
          end                           //versionNumber >= 2
          else if VersionNumber < minAdoVersion then
          begin
//            ReportMessage('Please install Microsoft ADO ActivX component Version ' + FloatToStr(minAdoVersion) + ' or greater!');
            Result := -1;
            Exit;
          end;

          Result := versionNumber;

        end                               //Assigned(oAdo)
      else
        begin
//            ReportMessage('Please install Microsoft ADO ActivX component Version ' + FloatToStr(minAdoVersion) + ' or greater!');
            Result := -1;
            Exit;
        end;
    end;
var
	s : String;
begin
	DocRegistry.OpenRegistry('',s);

    {
	// -- Pull out the information required for doing a session
	s := '';
	DocRegistry.GetSettingString(GTD_REG_NOD_GENERAL,GTD_REG_COMPANY_NAME,s);
	CommunityLink.LocalOrganisation := s;

	s := '';
	if DocRegistry.GetSettingString(GTD_REG_NOD_GENERAL,'Customer_Number',s) then
	begin
		CommunityLink.Trader_ID := StrToInt(s);
		txtCustomerNum.Text := s;
	end
	else begin
		CommunityLink.Trader_ID := -1;
		txtCustomerNum.Text := '';
	end;

	s := '';
	DocRegistry.GetSettingString(GTD_REG_NOD_GENERAL,GTD_REG_GTL,s);
	CommunityLink.LocalGTL := s;
	cbxLocalGTL.Text := s;

	s := '';
	DocRegistry.GetSettingString(GTD_REG_NOD_GENERAL,'Customer_Password',s);
	CommunityLink.Password := s;
	txtPassword.Text := s;
    }

    // -- Open the Product Supplier database
    s := FormatFloat('##.##',GetADOVersion);

    s := 'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=' + GetCurrentDir + '\Supplier Product Database.mdb;Persist Security Info=False';
    dbProductDB.Connection := s;

	{
	GetSettingString(GTD_REG_NOD_GENERAL,GTD_REG_ADDRESS_LINE_1,s);
	txtStreet1.Text := s;

	GetSettingString(GTD_REG_NOD_GENERAL,GTD_REG_ADDRESS_LINE_2,s);
	txtStreet2.Text := s;

	GetSettingString(GTD_REG_NOD_GENERAL,GTD_REG_TOWN,s);
	txtCity.Text := s;

	GetSettingString(GTD_REG_NOD_GENERAL,GTD_REG_POSTALCODE,s);
	txtPostCode.Text := s;

	GetSettingString(GTD_REG_NOD_GENERAL,GTD_REG_COUNTRYCODE,s);
	if s = '' then
		cbxCountry.Text := GetEnglishCountryName()
	else begin
		cbxCountry.ItemIndex := cbxCountry.Items.IndexOf(GetNameFromCountryCode(s));
	end;

	// -- While we are here, load the state list for this country
	LoadStateNames(s,cbxState.Items);
	GetSettingString(GTD_REG_NOD_GENERAL,GTD_REG_STATE_REGION,s);
	cbxState.ItemIndex := cbxState.Items.IndexOf(s);

	GetSettingString(GTD_REG_NOD_GENERAL,GTD_REG_TELEPHONE,s);
	txtTelephone.Text := s;

	GetSettingString(GTD_REG_NOD_GENERAL,GTD_REG_FAX,s);
	txtFax.Text := s;
	}
	// -- User Details page
//	s := '';
//	DocReg.GetSettingString(GTD_REG_NOD_GENERAL,GTD_REG_XCHG_USERID,s);
//	CommunityLink.UserID := s;

end;

procedure TfrmMain.mnuConnectedClick(Sender: TObject);
begin
	with CommunityLink do
	begin
		if (State = gtusOffline) or (State = gtusComplete) then
		begin
			SessionType := gtwtServer;
			Protocol := tpAsync;
			LogIn(DocRegistry);
		end
		else begin
			Logout;
		end;
	end;
end;

procedure TfrmMain.Search1Click(Sender: TObject);
begin
    frmSearch.ShowModal;
end;

procedure TfrmMain.NetworkSearches1Click(Sender: TObject);
begin
    frmNetworkSearches.ShowModal;
end;

procedure TfrmMain.EditProducts1Click(Sender: TObject);
begin
    frmProductEdit.ShowModal;
end;

procedure TfrmMain.Timer1Timer(Sender: TObject);
begin
    if not fSearchFormShown then
    begin

        fSearchFormShown := True;

        // -- Check the command line parameter
//        if (ParamCount >= 1) and (ParamStr(1) = '/TRAY') then ** this is what is meant
        if (ParamCount = 0) then
        begin
            // -- Show the product editing screen
            frmProductEdit.Show;
        end;

        Hide;
    end;

end;

procedure TfrmMain.AddProspectCustomer1Click(Sender: TObject);
begin
    frmCustomerAdd.ShowModal;
end;

procedure TfrmMain.bsSkinSpeedButton1Click(Sender: TObject);
begin
    dbProductDB.Connected := True;
end;

procedure TfrmMain.FromXLSfile1Click(Sender: TObject);
begin
    if not Assigned(frmSpreadSheetImport) then
        Application.CreateForm(TfrmSpreadSheetImport, frmSpreadSheetImport);
        
    frmSpreadSheetImport.ShowModal;
end;

procedure TfrmMain.EmailPriceliststoClients1Click(Sender: TObject);
begin
    frmNewsletter.ShowModal;

//    if not Assigned(frmGeneratePL) then
//        Application.CreateForm(TfrmGeneratePL, frmGeneratePL);

//    frmGeneratePL.ShowModal;
end;

procedure TfrmMain.btnShowTodayClick(Sender: TObject);
begin
    mmoTodayDoList.Lines.Clear;
    mmoTodayDoList.Lines.Add('Nothing for today');
end;

procedure TfrmMain.rdoSkinxFactorClick(Sender: TObject);
begin
    bsSkinData1.StoredSkin := sknxFactor;
end;

procedure TfrmMain.Corner1Click(Sender: TObject);
begin
    bsSkinData1.StoredSkin := sknCorner;
end;

procedure TfrmMain.SmartStyle1Click(Sender: TObject);
begin
    bsSkinData1.StoredSkin := bsStoredSkin1;
end;

procedure TfrmMain.BuildPricelistfromDB1Click(Sender: TObject);
begin
    frmBuildDBPricelist.ShowModal;
end;

procedure TfrmMain.Load1Click(Sender: TObject);
begin
    if bsOpenSkinDialog1.Execute then
    begin
        bsSkinData1.LoadFromFile(bsOpenSkinDialog1.FileName);
    end;

end;

procedure TfrmMain.EmailPricelists1Click(Sender: TObject);
begin
    if not Assigned(frmGeneratePL) then
    begin
        Application.CreateForm(TfrmGeneratePL, frmGeneratePL);
    end;
    
    frmGeneratePL.ShowModal;
    Application.ProcessMessages;


end;

procedure TfrmMain.Configuration1Click(Sender: TObject);
begin
    frmConfig.SHowModal;
end;

procedure TfrmMain.Vie1Click(Sender: TObject);
begin
  frmLogView.ShowModal;
end;

procedure TfrmMain.PriceRelay1Click(Sender: TObject);
begin
  frmRelay.ShowModal;
end;

procedure TfrmMain.SupplierDataFeeds1Click(Sender: TObject);
begin
  frmDataFeeds.ShowModal;
end;

end.




