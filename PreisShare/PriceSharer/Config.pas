unit Config;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mask, DBCtrls, Buttons, ComCtrls, OleCtrls, db, ExtCtrls, GTDGeoView,
  StdVcl, ShellAPI, Jpeg, GTDBizLinks,
  // -- From RX_UTIL
  // FileUtil,
  OleCtnrs, ActiveX, ComObj, ShlObj, BusinessSkinForm, bsSkinTabs,
  bsSkinCtrls, bsSkinBoxCtrls, bsSkinShellCtrls;

type
  TfrmConfig = class(TForm)
    bsSkinPageControl1: TbsSkinPageControl;
    bsSkinTabSheet1: TbsSkinTabSheet;
    bsSkinTabSheet2: TbsSkinTabSheet;
    bsSkinTabSheet4: TbsSkinTabSheet;
    bsBusinessSkinForm1: TbsBusinessSkinForm;
    bsSkinLabel1: TbsSkinLabel;
    bsSkinLabel2: TbsSkinLabel;
    bsSkinLabel3: TbsSkinLabel;
    bsSkinLabel4: TbsSkinLabel;
    bsSkinLabel5: TbsSkinLabel;
    bsSkinLabel6: TbsSkinLabel;
    bsSkinLabel7: TbsSkinLabel;
    bsSkinLabel8: TbsSkinLabel;
    bsSkinLabel9: TbsSkinLabel;
    bsSkinLabel10: TbsSkinLabel;
    bsSkinGroupBox1: TbsSkinGroupBox;
    chkHTTPDriver: TbsSkinCheckRadioBox;
    chkNetAccounts: TbsSkinCheckRadioBox;
    bsSkinLabel11: TbsSkinLabel;
    bsSkinLabel12: TbsSkinLabel;
    rdoUsageType: TbsSkinRadioGroup;
    rdoNoProxy: TbsSkinCheckRadioBox;
    rdoProxy: TbsSkinCheckRadioBox;
    txtProxyAddress: TbsSkinEdit;
    bsSkinLabel13: TbsSkinLabel;
    txtGTL: TbsSkinEdit;
    Image1: TImage;
    txtUserName: TbsSkinEdit;
    txtCompany: TbsSkinEdit;
    txtStreet1: TbsSkinEdit;
    txtStreet2: TbsSkinEdit;
    txtCity: TbsSkinEdit;
    cbxCountry: TbsSkinComboBox;
    cbxState: TbsSkinComboBox;
    txtPostCode: TbsSkinEdit;
    txtTelephone: TbsSkinEdit;
    txtFax: TbsSkinEdit;
    txtOtherInfo: TbsSkinEdit;
    txtPosition: TbsSkinEdit;
    cbxDepartment: TbsSkinComboBox;
    btnCancel: TbsSkinButton;
    btnOK: TbsSkinButton;
    chkServer: TbsSkinCheckRadioBox;
    txtProxyPort: TbsSkinEdit;
    bsSkinLabel14: TbsSkinLabel;
    txtUserID: TbsSkinEdit;
    bsSkinLabel15: TbsSkinLabel;
    pnlYellow1: TPanel;
    bsSkinTextLabel2: TbsSkinTextLabel;
    Panel1: TPanel;
    bsSkinTextLabel1: TbsSkinTextLabel;
    bsSkinTabSheet3: TbsSkinTabSheet;
    imgLogo: TImage;
    Bevel1: TBevel;
    Panel2: TPanel;
    bsSkinTextLabel4: TbsSkinTextLabel;
    bsSkinLabel18: TbsSkinLabel;
    dlgPictureSelect: TbsSkinOpenPictureDialog;
    bsSkinLabel19: TbsSkinLabel;
    txtLogoFilename: TbsSkinEdit;
    bsSkinLabel20: TbsSkinLabel;
    bsSkinLabel21: TbsSkinLabel;
    Shape1: TShape;
    Image2: TImage;
    bsSkinTabSheet5: TbsSkinTabSheet;
    txtQuoteTerms: TbsSkinMemo;
    bsSkinLabel22: TbsSkinLabel;
    Panel3: TPanel;
    bsSkinTextLabel3: TbsSkinTextLabel;
    bsSkinLabel23: TbsSkinLabel;
    cbxQuoteExpiry: TbsSkinSpinEdit;
    bsSkinLabel24: TbsSkinLabel;
    cbxQuoteDeliveryMode: TbsSkinComboBox;
    bsSkinLabel25: TbsSkinLabel;
    txtQuoteDeliveryCharge: TbsSkinNumericEdit;
    lblLogoError: TbsSkinStdLabel;
    cbxCompanyNameAlignment: TbsSkinComboBox;
    cbxCompanyAddressAlignment: TbsSkinComboBox;
    rdoConnectionType: TbsSkinGroupBox;
    cbxLAN: TbsSkinCheckRadioBox;
    cbxDialup: TbsSkinCheckRadioBox;
    cbxDialups: TbsSkinComboBox;
    bsSkinLabel17: TbsSkinLabel;
    txtRegStatus: TbsSkinEdit;
    txtPassword: TbsSkinPasswordEdit;
    grpEmailConfig: TbsSkinGroupBox;
    txtMailServer: TbsSkinEdit;
    bsSkinLabel26: TbsSkinLabel;
    txtEmailUserName: TbsSkinEdit;
    txtUserEmailPasswd: TbsSkinPasswordEdit;
    bsSkinLabel27: TbsSkinLabel;
    bsSkinLabel28: TbsSkinLabel;
    cbxMailHostLogin: TbsSkinCheckRadioBox;
    txtDisplayName: TbsSkinEdit;
    bsSkinLabel30: TbsSkinLabel;
    grpDatabase: TbsSkinGroupBox;
    cbxDatabase: TbsSkinComboBox;
    bsSkinLabel29: TbsSkinLabel;
	procedure btnOkClick(Sender: TObject);
	procedure btnCancel1Click(Sender: TObject);
	procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbxCountryChange(Sender: TObject);
    procedure chkHTTPDriverClick(Sender: TObject);
    procedure rdoProxyClick(Sender: TObject);
    procedure txtLogoFilenameButtonClick(Sender: TObject);
    procedure cbxDatabaseChange(Sender: TObject);
  private
	{ Private declarations }
  public
	{ Public declarations }
	procedure RefreshCompanyInfo;
	procedure SaveConfig(interactive : Boolean);
  end;

var
  frmConfig: TfrmConfig;

procedure SetupWorkArea;

procedure CreateFileShortcut(const FileName, DisplayName, ProgramArgs, InitDir: string; Folder: Integer);

implementation

{$R *.DFM}

uses
	Data, Main, GTDBizDocs;

procedure TfrmConfig.btnOkClick(Sender: TObject);
begin
	SaveConfig(True);
    Close;
end;

procedure TfrmConfig.SaveConfig(interactive : Boolean);
var
	markA : HECMLMarker;
begin
	// -- Type of Internet connection
	if cbxDialup.Checked = True then
		SaveSettingString(GTD_REG_NOD_GENERAL,GTD_REG_CONNECTION,'Dialup')
	else
		SaveSettingString(GTD_REG_NOD_GENERAL,GTD_REG_CONNECTION,'Permanent');

	// -- Save the useage type
	if rdoUsageType.ItemIndex = 0 then
		SaveSettingString(GTD_REG_NOD_GENERAL,'Usage','Private')
	else
		SaveSettingString(GTD_REG_NOD_GENERAL,'Usage','Business');

	// -- We have all these settings to save
	SaveSettingString(GTD_REG_NOD_GENERAL,GTD_REG_GTL,txtGTL.Text);
	SaveSettingString(GTD_REG_NOD_GENERAL,GTD_REG_USER_NAME,txtUserName.Text);
	SaveSettingString(GTD_REG_NOD_GENERAL,GTD_REG_USER_POSITION,txtPosition.Text);
	SaveSettingString(GTD_REG_NOD_GENERAL,GTD_REG_USER_DEPARTMENT,cbxDepartment.Text);

    frmMain.DocRegistry.SaveSettingString(GTD_REG_NOD_GENERAL,GTD_REG_COMPANY_NAME,txtCompany.Text);
    frmMain.DocRegistry.SaveSettingString(GTD_REG_NOD_GENERAL,GTD_REG_ADDRESS_LINE_1,txtStreet1.Text);
    frmMain.DocRegistry.SaveSettingString(GTD_REG_NOD_GENERAL,GTD_REG_ADDRESS_LINE_2,txtStreet2.Text);
    frmMain.DocRegistry.SaveSettingString(GTD_REG_NOD_GENERAL,GTD_REG_TOWN,txtCity.Text);
    if cbxState.ItemIndex <> -1 then
        frmMain.DocRegistry.SaveSettingString(GTD_REG_NOD_GENERAL,GTD_REG_STATE_REGION,cbxState.Items[cbxState.ItemIndex])
    else
        frmMain.DocRegistry.SaveSettingString(GTD_REG_NOD_GENERAL,GTD_REG_STATE_REGION,cbxState.Text);
    frmMain.DocRegistry.SaveSettingString(GTD_REG_NOD_GENERAL,GTD_REG_POSTALCODE,txtPostCode.Text);
    frmMain.DocRegistry.SaveSettingString(GTD_REG_NOD_GENERAL,GTD_REG_COUNTRYCODE,GetCodeFromCountryName(cbxCountry.Text));
    frmMain.DocRegistry.SaveSettingString(GTD_REG_NOD_GENERAL,GTD_REG_TELEPHONE,txtTelephone.Text);
    frmMain.DocRegistry.SaveSettingString(GTD_REG_NOD_GENERAL,GTD_REG_FAX,txtFax.Text);
    frmMain.DocRegistry.SaveSettingString(GTD_REG_NOD_GENERAL,GTD_REG_OTHER_INFO,txtOtherInfo.Text);

//		frmMain.DocRegistry.SaveSettingString(GTD_REG_NOD_GENERAL,GTD_REG_XCHG_USERID,txtUserID.Text);
    frmMain.DocRegistry.SaveSettingString(GTD_REG_NOD_GENERAL,GTD_REG_XCHG_PASSWORD,txtPassword.Text);

	// SaveSettingString(GTD_REG_NOD_GENERAL,GTD_REG_USER_EMAIL,txtEmail.Text);

	// -- Proxy configuration stuff
	if rdoNoProxy.Checked then
		SaveSettingString(GTD_REG_NOD_GENERAL,GTD_REG_USE_PROXY,'False')
	else begin
		SaveSettingString(GTD_REG_NOD_GENERAL,GTD_REG_USE_PROXY,'True');

		SaveSettingString(GTD_REG_NOD_GENERAL,GTD_REG_PROXY_ADDRESS,txtProxyAddress.Text);
		SaveSettingString(GTD_REG_NOD_GENERAL,GTD_REG_PROXY_PORT,txtProxyPort.Text);
	end;

	// -- Logo
	SaveSettingString(GTD_REG_NOD_GENERAL,GTD_REG_LOGO_IMAGE,txtLogoFilename.Text);

	// -- Quote settings
	SaveSettingInt(GTD_REG_NOD_GENERAL,GTD_REG_DFLT_QUOTE_AGE,Round(cbxQuoteExpiry.Value));
	SaveSettingString(GTD_REG_NOD_GENERAL,GTD_REG_DFLT_QUOTE_DESPATCH,cbxQuoteDeliveryMode.Text);
	SaveSettingString(GTD_REG_NOD_GENERAL,GTD_REG_DFLT_QUOTE_DELCHG,txtQuoteDeliveryCharge.Text);
	SaveSettingString(GTD_REG_NOD_GENERAL,GTD_REG_DFLT_QUOTE_TERMS,txtQuoteTerms.Text);

	// -- Email configuration
    frmMain.DocRegistry.SaveSettingString(GTD_REG_NOD_GENERAL,GTD_REG_USER_EMAIL,'');
	frmMain.DocRegistry.SaveSettingMemoString('/Settings',GTD_REG_EMAIL_HOST,txtMailServer.Text,False);
	frmMain.DocRegistry.SaveSettingMemoString('/Settings',GTD_REG_EMAIL_USERNAME,txtEmailUserName.Text,False);
    frmMain.DocRegistry.SaveSettingMemoString('/Settings',GTD_REG_EMAIL_PASSWORD,txtUserEmailPasswd.Text,False);
    frmMain.DocRegistry.SaveSettingMemoString('/Settings',GTD_REG_EMAIL_DISPLAYNAME,txtDisplayName.Text,False);

    if cbxMailHostLogin.Checked then
        frmMain.DocRegistry.SaveSettingMemoString('/Settings',GTD_REG_EMAIL_LOGINREQ,'True',True)
    else
        frmMain.DocRegistry.SaveSettingMemoString('/Settings',GTD_REG_EMAIL_LOGINREQ,'False',True);

    // --
    if cbxDatabase.Tag <> 0 then
    begin
        SaveSettingString(GTD_REG_NOD_GENERAL,GTD_REG_BDE_ALIAS,cbxDatabase.Text);
        cbxDatabase.Tag := 0;
    end;

end;

procedure TfrmConfig.btnCancel1Click(Sender: TObject);
begin
    Close;
end;

procedure TfrmConfig.FormActivate(Sender: TObject);
begin
	// -- Set the Active Page
    GetAliases(cbxDataBase.Items,'OPM');

	// -- Get all the company information
	RefreshCompanyInfo;

end;

procedure TfrmConfig.RefreshCompanyInfo;
var
	xc : Integer;
	s : String;
	UseProxy : Boolean;
	ProxyAddr,ProxyPort : String;

begin

	// -- Name and Address tab
	GetSettingString(GTD_REG_NOD_GENERAL,GTD_REG_USER_NAME,s);
	txtUserName.Text := s;

	GetSettingString(GTD_REG_NOD_GENERAL,GTD_REG_USER_POSITION,s);
	txtPosition.Text := s;

	GetSettingString(GTD_REG_NOD_GENERAL,GTD_REG_USER_DEPARTMENT,s);
	cbxDepartment.Text := s;

	// -- Load Company Name/Address information
    // -- Values are read from sysvals
    frmMain.DocRegistry.GetSettingString(GTD_REG_NOD_GENERAL,GTD_REG_COMPANY_NAME,s);
    txtCompany.Text := s;

    frmMain.DocRegistry.GetSettingString(GTD_REG_NOD_GENERAL,GTD_REG_ADDRESS_LINE_1,s);
    txtStreet1.Text := s;

    frmMain.DocRegistry.GetSettingString(GTD_REG_NOD_GENERAL,GTD_REG_ADDRESS_LINE_2,s);
    txtStreet2.Text := s;

    frmMain.DocRegistry.GetSettingString(GTD_REG_NOD_GENERAL,GTD_REG_TOWN,s);
    txtCity.Text := s;

    frmMain.DocRegistry.GetSettingString(GTD_REG_NOD_GENERAL,GTD_REG_POSTALCODE,s);
    txtPostCode.Text := s;

    frmMain.DocRegistry.GetSettingString(GTD_REG_NOD_GENERAL,GTD_REG_COUNTRYCODE,s);
    if s = '' then
        cbxCountry.Text := GetEnglishCountryName()
    else begin
        cbxCountry.ItemIndex := cbxCountry.Items.IndexOf(GetNameFromCountryCode(s));
    end;

    // -- While we are here, load the state list for this country
    LoadStateNames(s,cbxState.Items);
    frmMain.DocRegistry.GetSettingString(GTD_REG_NOD_GENERAL,GTD_REG_STATE_REGION,s);
    cbxState.ItemIndex := cbxState.Items.IndexOf(s);

    frmMain.DocRegistry.GetSettingString(GTD_REG_NOD_GENERAL,GTD_REG_TELEPHONE,s);
    txtTelephone.Text := s;

    frmMain.DocRegistry.GetSettingString(GTD_REG_NOD_GENERAL,GTD_REG_FAX,s);
    txtFax.Text := s;

    frmMain.DocRegistry.GetSettingString(GTD_REG_NOD_GENERAL,GTD_REG_OTHER_INFO,s);
    txtOtherInfo.Text := s;

    // -- User Details page
    s := '';
//		frmMain.DocRegistry.GetSettingString(GTD_REG_NOD_GENERAL,GTD_REG_XCHG_USERID,s);
    txtUserID.Text := s;

    s := '';
    frmMain.DocRegistry.GetSettingString(GTD_REG_NOD_GENERAL,GTD_REG_XCHG_PASSWORD,s);
    txtPassword.Text := s;

//    s := '';
//  GetSettingString(GTD_REG_NOD_GENERAL,GTD_REG_USER_EMAIL,s);
//  txtEmail.Text := s;

    // -- Network page
    frmMain.DocRegistry.GetSettingString(GTD_REG_NOD_GENERAL,GTD_REG_CONNECTION,s);
    if s = 'Dialup' then
        cbxDialup.Checked := True
    else
        cbxLAN.Checked := True;

    // -- Email configuration
    frmMain.DocRegistry.GetSettingString(GTD_REG_NOD_GENERAL,GTD_REG_USER_EMAIL,s);
    frmMain.DocRegistry.GetSettingMemoString('/Settings',GTD_REG_EMAIL_HOST,s);
    txtMailServer.Text := s;
    frmMain.DocRegistry.GetSettingMemoString('/Settings',GTD_REG_EMAIL_USERNAME,s);
    txtEmailUserName.Text := s;
    frmMain.DocRegistry.GetSettingMemoString('/Settings',GTD_REG_EMAIL_PASSWORD,s);
    txtUserEmailPasswd.Text := s;
    frmMain.DocRegistry.GetSettingMemoString('/Settings',GTD_REG_EMAIL_DISPLAYNAME,s);
    txtDisplayName.Text := s;

    frmMain.DocRegistry.GetSettingMemoString('/Settings',GTD_REG_EMAIL_LOGINREQ,s);
    if s = 'True' then
        cbxMailHostLogin.Checked := True
    else
        cbxMailHostLogin.Checked := False;

    // -- Proxy configuration stuff
    s := '';
    GetSettingString(GTD_REG_NOD_GENERAL,GTD_REG_USE_PROXY,s);
    if s = '' then
    begin
        // -- Loadup any IE
        CheckIEProxySettings(UseProxy,ProxyAddr,ProxyPort);
        if UseProxy then
        begin
            // --
            rdoProxy.Checked := True;
            txtProxyAddress.Text := ProxyAddr;
            txtProxyPort.Text := ProxyPort;
        end
        else begin
            rdoProxy.Checked := False;
            txtProxyAddress.Text := '';
            txtProxyPort.Text := '';
        end;
    end
    else begin
        // --
        if s = 'True' then
            rdoProxy.Checked := True
        else
            rdoNoProxy.Checked := True;

        s := '';
        GetSettingString(GTD_REG_NOD_GENERAL,GTD_REG_PROXY_ADDRESS,s);
        txtProxyAddress.Text := s;
        s := '';
        GetSettingString(GTD_REG_NOD_GENERAL,GTD_REG_PROXY_PORT,s);
        txtProxyPort.Text := s;
    end;

    GetSettingString(GTD_REG_NOD_GENERAL,GTD_REG_GTL,s);
    txtGTL.Text := s;

    // -- Company logo
    s := '';
    GetSettingString(GTD_REG_NOD_GENERAL,GTD_REG_LOGO_IMAGE,s);
    txtLogoFilename.Text := s;

    // -- Attempt to load the logo
    try
        lblLogoError.Caption := '';
        imgLogo.Picture.LoadFromFile(s);
        // txtLogoWidth.Text := IntToStr(imgLogo.Picture.Width);
        // txtLogoHeight.Text := IntToStr(imgLogo.Picture.Height);

    except
        lblLogoError.Caption := 'Error';
    end;

    // -- Quotes expire after
    xc := 7;
    if GetSettingInt(GTD_REG_NOD_GENERAL,GTD_REG_DFLT_QUOTE_AGE,xc) then
        cbxQuoteExpiry.Value := xc
    else
        cbxQuoteExpiry.Value := 7;

    // -- Default despatch mode for quotes
    s := '';
    if GetSettingString(GTD_REG_NOD_GENERAL,GTD_REG_DFLT_QUOTE_DESPATCH,s) then
        cbxQuoteDeliveryMode.Text := s;

    // -- Default delivery charge
	s := '';
    if GetSettingString(GTD_REG_NOD_GENERAL,GTD_REG_DFLT_QUOTE_DELCHG,s) then
        txtQuoteDeliveryCharge.Text := s;

    // -- Default Quotation terms
    s := '';
    if GetSettingString(GTD_REG_NOD_GENERAL,GTD_REG_DFLT_QUOTE_TERMS,s) then
        txtQuoteTerms.Text := s;

    // -- Display the database alias
    s := '';
    if GetSettingString(GTD_REG_NOD_GENERAL,GTD_REG_BDE_ALIAS,s) then
        cbxDatabase.ItemIndex := cbxDatabase.Items.IndexOf(s);

	// -- UserID
	if GetSettingInt(GTD_REG_NOD_GENERAL,GTD_REG_XCHG_CUSTOMERID,xc) then
	begin
		txtUserID.Text := IntToStr(xc);
		if xc < 0 then
			txtRegStatus.Text := 'Trial Registration'
		else
			txtRegStatus.Text := 'Registered';
	end
	else begin
		txtUserID.Text := '';
		txtRegStatus.Text := 'Unregistered';
	end;

	// -- Password
	s := '';
	GetSettingString(GTD_REG_NOD_GENERAL,GTD_REG_XCHG_PASSWORD,s);
	txtPassword.Text := s;


end;

procedure SetupWorkArea;
begin
end;

procedure CreateFileShortcut(const FileName, DisplayName, ProgramArgs, InitDir: string; Folder: Integer);
const
  LinkExt = '.lnk';
var
  aObject    : IUnknown;
  aSLink     : IShellLink;
  aPFile     : IPersistFile;
  sDirectory : string;
  wsFileName : WideString;
  szWinDir   : array[0..29] of char;

	function GetShellFolderPath(const aFolder : integer) : string;
	var
	  pIIL : PItemIDList;
	  szPath : array[0..MAX_PATH] of char;
	  aMalloc : IMalloc;
	begin
	  Result := '';

	  Assert(aFolder <= CSIDL_PRINTHOOD, 'Falsche ShellFolder-Konstante');
	  OleCheck(SHGetSpecialFolderLocation(0, aFolder, pIIL));
	  SHGetPathFromIDList(pIIL, szPath);
	  OleCheck(SHGetMalloc(aMalloc));
	  aMalloc.Free(pIIL);
	  Result := szPath;
	end;

begin
  FillChar(szWinDir, SizeOf(szWinDir), #0);
  GetWindowsDirectory(szWinDir, SizeOf(szWinDir));
  aObject := CreateComObject(CLSID_ShellLink);
  aSLInk  := aObject as IShellLink;
  aPFile  := aObject as IPersistFile;

  with aSLink do
  begin
	SetPath(PChar(FileName));
	if ProgramArgs <> '' then
		SetArguments(PCHar(ProgramArgs));
	if InitDir <> '' then                                                    
		SetWorkingDirectory(Pchar(InitDir));
  end;

  // -- Obtain the directory location for the specified folder
  sDirectory := GetShellFolderPath(Folder);

  Assert(sDirectory[Length(sDirectory)] <> '\', 'Backslash!');
  wsFileName := sDirectory + '\' + DisplayName + LinkExt;
  aPFile.Save(PWChar(wsFileName), false);

  // -- This alternate method uses the RX components
  //	CreateFileLink(FileName, DisplayName,Folder);

end;

procedure TfrmConfig.FormCreate(Sender: TObject);
begin
    // --
    {$IFDEF LIGHTWEIGHT}
        chkServer.Visible := False;
//        chkNetAccounts.Visible := False;
//        rdoFile.Checked := True;
    {$ELSE}
//        rdoParadox.Checked := True;
    {$ENDIF}
    GetCountryNameList(cbxCountry.Items);

    // -- Manually set the skins as these seem to always get lost
	bsBusinessSkinForm1.SkinData := frmMain.bsSkinData1;
	bsSkinPageControl1.SkinData := frmMain.bsSkinData1;
	bsBusinessSkinForm1.SkinData := frmMain.bsSkinData1;
	dlgPictureSelect.SkinData := frmMain.bsSkinData1;
	dlgPictureSelect.CtrlSkinData := frmMain.bsSkinData1;
	bsSkinLabel1.SkinData := frmMain.bsSkinData1;
	bsSkinLabel2.SkinData := frmMain.bsSkinData1;
	bsSkinLabel3.SkinData := frmMain.bsSkinData1;
	bsSkinLabel4.SkinData := frmMain.bsSkinData1;
	bsSkinLabel5.SkinData := frmMain.bsSkinData1;
	bsSkinLabel6.SkinData := frmMain.bsSkinData1;
	bsSkinLabel7.SkinData := frmMain.bsSkinData1;
	bsSkinLabel8.SkinData := frmMain.bsSkinData1;
	bsSkinLabel9.SkinData := frmMain.bsSkinData1;
	bsSkinLabel10.SkinData := frmMain.bsSkinData1;
	bsSkinLabel11.SkinData := frmMain.bsSkinData1;
	bsSkinLabel12.SkinData := frmMain.bsSkinData1;
	bsSkinLabel13.SkinData := frmMain.bsSkinData1;
	bsSkinLabel14.SkinData := frmMain.bsSkinData1;
	bsSkinLabel18.SkinData := frmMain.bsSkinData1;
	bsSkinLabel19.SkinData := frmMain.bsSkinData1;
	bsSkinLabel20.SkinData := frmMain.bsSkinData1;
	bsSkinLabel21.SkinData := frmMain.bsSkinData1;
	bsSkinLabel22.SkinData := frmMain.bsSkinData1;
	bsSkinLabel26.SkinData := frmMain.bsSkinData1;
	bsSkinLabel27.SkinData := frmMain.bsSkinData1;
	bsSkinLabel28.SkinData := frmMain.bsSkinData1;
	bsSkinLabel30.SkinData := frmMain.bsSkinData1;
	cbxDialups.SkinData := frmMain.bsSkinData1;
	txtDisplayName.SkinData := frmMain.bsSkinData1;
	txtLogoFilename.SkinData := frmMain.bsSkinData1;
	txtUserID.SkinData := frmMain.bsSkinData1;
	txtPassword.SkinData := frmMain.bsSkinData1;
	cbxCompanyNameAlignment.SkinData := frmMain.bsSkinData1;
	cbxCompanyAddressAlignment.SkinData := frmMain.bsSkinData1;
	grpEmailConfig.SkinData := frmMain.bsSkinData1;
	txtMailServer.SkinData := frmMain.bsSkinData1;
	txtEmailUserName.SkinData := frmMain.bsSkinData1;
	txtUserEmailPasswd.SkinData := frmMain.bsSkinData1;
	grpDatabase.SkinData := frmMain.bsSkinData1;
	bsSkinLabel29.SkinData := frmMain.bsSkinData1;
	cbxDatabase.SkinData := frmMain.bsSkinData1;
	bsSkinLabel23.SkinData := frmMain.bsSkinData1;
	cbxQuoteExpiry.SkinData := frmMain.bsSkinData1;
	bsSkinLabel24.SkinData := frmMain.bsSkinData1;
	cbxQuoteDeliveryMode.SkinData := frmMain.bsSkinData1;
	bsSkinLabel25.SkinData := frmMain.bsSkinData1;
	txtQuoteDeliveryCharge.SkinData := frmMain.bsSkinData1;
	txtQuoteTerms.SkinData := frmMain.bsSkinData1;
	bsSkinGroupBox1.SkinData := frmMain.bsSkinData1;
	chkHTTPDriver.SkinData := frmMain.bsSkinData1;
	chkNetAccounts.SkinData := frmMain.bsSkinData1;
	rdoUsageType.SkinData := frmMain.bsSkinData1;
	rdoConnectionType.SkinData := frmMain.bsSkinData1;
	rdoNoProxy.SkinData := frmMain.bsSkinData1;
	rdoProxy.SkinData := frmMain.bsSkinData1;
	txtProxyAddress.SkinData := frmMain.bsSkinData1;
	txtUserID.SkinData := frmMain.bsSkinData1;
	txtPassword.SkinData := frmMain.bsSkinData1;
	txtGTL.SkinData := frmMain.bsSkinData1;
	txtUserName.SkinData := frmMain.bsSkinData1;
	txtCompany.SkinData := frmMain.bsSkinData1;
	txtStreet1.SkinData := frmMain.bsSkinData1;
	txtStreet2.SkinData := frmMain.bsSkinData1;
	txtCity.SkinData := frmMain.bsSkinData1;
	cbxCountry.SkinData := frmMain.bsSkinData1;
	cbxState.SkinData := frmMain.bsSkinData1;
	txtPostCode.SkinData := frmMain.bsSkinData1;
	txtTelephone.SkinData := frmMain.bsSkinData1;
	txtFax.SkinData := frmMain.bsSkinData1;
	txtOtherInfo.SkinData := frmMain.bsSkinData1;
	txtPosition.SkinData := frmMain.bsSkinData1;
	cbxDepartment.SkinData := frmMain.bsSkinData1;
	btnCancel.SkinData := frmMain.bsSkinData1;
	btnOK.SkinData := frmMain.bsSkinData1;
	chkServer.SkinData := frmMain.bsSkinData1;
	bsSkinLabel17.SkinData := frmMain.bsSkinData1;
	txtRegStatus.SkinData := frmMain.bsSkinData1;
	bsSkinLabel15.SkinData := frmMain.bsSkinData1;

	bsSkinPageControl1.ActivePage := bsSkinTabSheet1;

	lblLogoError.Caption := '';

end;

procedure TfrmConfig.cbxCountryChange(Sender: TObject);
begin
	LoadStateNames(GetCodeFromCountryName(cbxCountry.Text),cbxState.Items);
end;

procedure TfrmConfig.chkHTTPDriverClick(Sender: TObject);
begin
	if chkHTTPDriver.Checked then
	begin
		rdoNoProxy.Enabled := True;
		rdoProxy.Enabled   := True;
		txtProxyAddress.ReadOnly := False;
	end
    else begin
        rdoNoProxy.Enabled := False;
        rdoNoProxy.Checked := False;
        rdoProxy.Enabled   := False;
        rdoProxy.Checked   := False;
        txtProxyAddress.ReadOnly := True;
    end;
end;

procedure TfrmConfig.rdoProxyClick(Sender: TObject);
begin
//    txtProxyAddress.Enabled := rdoProxy.Checked;
//    txtProxyPort.Enabled := rdoProxy.Checked;
    txtProxyAddress.ReadOnly := not rdoProxy.Checked;
    txtProxyPort.ReadOnly := not rdoProxy.Checked;
end;

procedure TfrmConfig.txtLogoFilenameButtonClick(Sender: TObject);
begin
    dlgPictureSelect.Filter :='All (*.jpg)|*.jpg';
    if dlgPictureSelect.Execute then
    begin
        // --
        imgLogo.Picture.LoadFromFile(dlgPictureSelect.FileName);

        txtLogoFilename.Text := dlgPictureSelect.FileName;
    end;
end;

procedure TfrmConfig.cbxDatabaseChange(Sender: TObject);
begin
    cbxDatabase.Tag := 1;
end;

end.


