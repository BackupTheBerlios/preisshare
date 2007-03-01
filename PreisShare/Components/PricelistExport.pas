unit PricelistExport;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, DBTables, bsSkinCtrls, bsSkinGrids, bsDBGrids, bsSkinData,
  BusinessSkinForm, Menus, ComCtrls, StdCtrls, Mask, bsSkinBoxCtrls, Tabs,
  ExtCtrls, bsSkinTabs, GTDBizDocs, Buttons, HCMngr,
  bsSkinShellCtrls, bsMessages, bsCalendar, bsDialogs,
  bsdbctrls, comObj, ActiveX, DBCtrls, ADODB2000,
  ImgList, GTDPricelists, DMaster, DDB, DTables, SynEditHighlighter,
  SynHighlighterSQL, SynEdit, SynMemo;

const
    PRICELIST_DBTYPE_ADO   = 'ADO';
    PRICELIST_DBTYPE_MYSQL = 'MYSQL';
    PRICELIST_DBTYPE_IB    = 'INTERBASE';

    PRICELIST_EXPORTMAP_NOVALUE         = '%NOVALUE';           // No value, don't add, used for counters
    PRICELIST_EXPORTMAP_NEW_ROWID       = '%NEW_ROWID';         // =GENERATOR    Generated ROWID
    PRICELIST_EXPORTMAP_CATEGORY_NAME   = '%CATEGORY_NAME';     //    Name of the Category
    PRICELIST_EXPORTMAP_CATEGORY_PATH   = '%CATEGORY_PATH';     //     Path of the Category ie 'Parts/Powered'
    PRICELIST_EXPORTMAP_CATEGORY_FIELD  = '%CATEGORY_FIELD';    // =FLDNAME A field value from the Category table
    PRICELIST_EXPORTMAP_TRADER_FIELD    = '%TRADER_FIELD';      // =FLDNAME   A field value from the Trader Table
    PRICELIST_EXPORTMAP_SUPPLIER_CODE   = '%SUPPLIER_CODE';     // The Supplier Account code
    PRICELIST_EXPORTMAP_SUPPLIER_NAME   = '%SUPPLIER_NAME';     // The Supplier Account code
    PRICELIST_EXPORTMAP_TRADER_ID       = '%TRADER_ID';         // Trader_ID field from Trader Table
    PRICELIST_EXPORTMAP_TRADER_NAME     = '%TRADER_NAME';       // Trader_Name field from Trader Table
    PRICELIST_EXPORTMAP_CATEGORY_INDEX  = '%CATEGORY_INDEX';    // Number of the product group

    PRICELIST_EXPORTMAP_SUP_CODE        = 'Supplier_Code';
    PRICELIST_EXPORTMAP_SUP_NAME        = 'Supplier_Name';

    //
// Pricelist Fields
    PRICELIST_EXPORTMAP_PRODUCT_CODE    = '@' + GTD_PL_ELE_PRODUCT_CODE;    //     = 'Name';
    PRICELIST_EXPORTMAP_PRODUCT_NAME    = '@' + GTD_PL_ELE_PRODUCT_NAME;    //     = 'Name';
	PRICELIST_EXPORTMAP_PRODUCT_DESC    = '@' + GTD_PL_ELE_PRODUCT_DESC;    //     = 'Description';
	PRICELIST_EXPORTMAP_PRODUCT_KEYWORDS= '@' + GTD_PL_ELE_PRODUCT_KEYWORDS;// = 'Keywords';
	PRICELIST_EXPORTMAP_PRODUCT_LIST    = '@' + GTD_PL_ELE_PRODUCT_LIST;    //     = 'List_Price';
	PRICELIST_EXPORTMAP_PRODUCT_ACTUAL  = '@' + GTD_PL_ELE_PRODUCT_ACTUAL;    //     = 'Your_Price';
	PRICELIST_EXPORTMAP_PRODUCT_TAXR    = '@' + GTD_PL_ELE_PRODUCT_TAXR;    //     = 'Tax_Rate';
	PRICELIST_EXPORTMAP_PRODUCT_BRAND   = '@' + GTD_PL_ELE_PRODUCT_BRAND;   //    = 'Brand';
	PRICELIST_EXPORTMAP_PRODUCT_UNIT    = '@' + GTD_PL_ELE_PRODUCT_UNIT;    //     = 'Unit';
	PRICELIST_EXPORTMAP_PRODUCT_MINORDQTY = '@' + GTD_PL_ELE_PRODUCT_MINORDQTY;    //= 'MinOrderQty';
	PRICELIST_EXPORTMAP_PRODUCT_TYPE    = '@' + GTD_PL_ELE_PRODUCT_TYPE;    //     = 'Product_Type';
	PRICELIST_EXPORTMAP_PRODUCT_THUMIMG = '@' + GTD_PL_ELE_PRODUCT_IMAGE;    //    = 'Thumbnail';
//	PRICELIST_EXPORTMAP_PRODUCT_FULLIMG = '@' + GTD_PL_ELE_PRODUCT_BIGIMAGE;    // = 'Picture';
	PRICELIST_EXPORTMAP_PRODUCT_MOREINFO= '@' + GTD_PL_ELE_PRODUCT_MOREINFO;    // = 'Further_Info_URL';
    {
	PRICELIST_EXPORTMAP_ = '@' + GTD_PL_ELE_MANUFACT_NAME    = 'Manufacturer.Name';
	PRICELIST_EXPORTMAP_ = '@' + GTD_PL_ELE_MANUFACT_GTL     = 'Manufacturer.GTL';
	PRICELIST_EXPORTMAP_ = '@' + GTP_PL_ELE_MANUFACT_PRODINFO= 'Manufacturer.Product_URL';
	PRICELIST_EXPORTMAP_ = '@' + GTD_PL_ELE_PRODUCT_AVAIL_FLAG = 'Availability.Flag';
	PRICELIST_EXPORTMAP_ = '@' + GTD_PL_ELE_PRODUCT_AVAIL_DATE = 'Availability.Date';
	PRICELIST_EXPORTMAP_ = '@' + GTD_PL_ELE_PRODUCT_AVAIL_STATUS = 'Availability.Status';
	PRICELIST_EXPORTMAP_ = '@' + GTD_PL_ELE_PRODUCT_AVAIL_BACKORD= 'Availability.OnBackOrder';
	PRICELIST_EXPORTMAP_ = '@' + GTD_PL_ELE_ONSPECIAL        = 'OnSpecial_Flag';
	PRICELIST_EXPORTMAP_ = '@' + GTD_PL_ELE_ONSPECIAL_TILL   = 'OnSpecial_Until';
    }
    RECORDDATA_IN_SUBITEM_INDEX = 4;
    CATEGORYINDEX_IN_SUBITEM_INDEX = 5;
type
  TTradalogImportTypes = (tit1Table1Group_csv,
    tit1Level1Table_csv,

    tit1Table1Group_exp,
    tit1Level1Table_exp,
    tit1Level2Table_exp,
    tit2Level3Table_exp,

    tit1Table1Group_sync,
    tit1Level1Table_sync,
  	tit1Level2Table_sync,
    tit2Level3Table_sync
	);

  TGTDPricelistExportFrame = class(TFrame)
    db1: TDatabase;
  	qryTemp: TQuery;
    dlgOpen: TbsSkinOpenDialog;
    bsSkinMessage1: TbsSkinMessage;
    qrySourceData: TQuery;
    dsSourceData: TDataSource;
    dsLoadMappings: TDataSource;
	  qryLoadMappings: TQuery;
    tblSysVal: TTable;
    tblProductUpdates: TTable;
    dsProductUpdates: TDataSource;
    qryPurgeRevisions: TQuery;
    dlgSaveProfileName: TbsSkinInputDialog;
    DSAccess: TDataSource;
    DataSource1: TDataSource;
    ImageList1: TImageList;
	  pnlBackGround: TbsSkinPanel;
    DQryGroups: TDQuery;
    DeersoftDB: TDMaster;
    DQryItems: TDQuery;
    DtblDestItems: TDTable;
    imgRises: TImage;
    txtRisesCount: TLabel;
    ImgFalls: TImage;
    txtFallsCount: TLabel;
    imgSteady: TImage;
    txtSteadyCount: TLabel;
    txtChangedCount: TLabel;
    imgDetails: TImage;
    txtRemovedCount: TLabel;
    imgRemoved: TImage;
    txtNewCount: TLabel;
    imgNew: TImage;
    btnShowSQL: TbsSkinSpeedButton;
    btnShowData: TbsSkinSpeedButton;
    barProgress: TbsSkinGauge;
    lblProgress: TbsSkinStdLabel;
    btnCancel: TbsSkinButton;
    mmoProgress: TbsSkinMemo;
    btnProcess: TbsSkinButton;
    lsvItems: TbsSkinListView;
    lstProdGroups: TbsSkinTreeView;
    DQrySuppliers: TDQuery;
    Shape1: TShape;
    Shape2: TShape;
    Shape4: TShape;
    Shape5: TShape;
    Shape6: TShape;
    Shape3: TShape;
    mmoSQL: TSynMemo;
    SynSQLSyn1: TSynSQLSyn;
    Shape7: TShape;
    Shape8: TShape;
    Shape9: TShape;
    Shape10: TShape;
    Shape11: TShape;
    Shape12: TShape;
  	procedure bsSkinButton8Click(Sender: TObject);
  	procedure btnNext2Click(Sender: TObject);
  	procedure FormCreate(Sender: TObject);
  	procedure btnProcessClick(Sender: TObject);
  	procedure btnShowDataClick(Sender: TObject);
  	procedure lstProdGroupsDblClick(Sender: TObject);
    procedure btnNext1Click(Sender: TObject);
    procedure pgRunShow(Sender: TObject);
    procedure btnShowSQLClick(Sender: TObject);
    procedure imgRisesClick(Sender: TObject);
    procedure ImgFallsClick(Sender: TObject);
    procedure imgSteadyClick(Sender: TObject);
    procedure imgNewClick(Sender: TObject);
    procedure imgRemovedClick(Sender: TObject);
    procedure imgDetailsClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);

  protected
	{ Protected declarations }
  private
	{ Private declarations }
  	dbProfileName: string;

	  mRevisionNo: Integer;

    fDWSActualPriceCalcFormula,         // -- DelphiWebScript price calculation formula
    fDWSListPriceCalcFormula,           // -- DelphiWebScript price calculation formula

    fSQLTrace : TStrings;               // -- Can hold SQL Statements that are issued

    fDocRegistry : GTDDocumentRegistry;

    fKeepRunning : Boolean;
    fShowProcessButton : Boolean;

  	bdFieldMap	: GTDBizDoc;

	  TextFileFields,
  	TextFileRecord,
	  TextFileData: TStringList;

  	fSkinData: TbsSkinData;

    fShowSQL : Boolean;

    dbType,                         // -- Type of database 'Ado', MySQL etc...

  	txtBDEAlias,
	  txtdbaseDir,
  	txtAccessdb: String;

    dbExport        : TDatabase;

    qrySupplierUpdate,
    qryGroupUpdate,
    qryItemUpdate   : TQuery;

    fSupplierTableName,
    fGroupOutputTableName,
    fItemOutputTableName   : String;

    // -- Price adjustment for the list price
    fListAdjustment_pc,
    fListTax_pc,
    fListCharges,

    // -- Price adjustment for the actual price
    fActualAdjustment_pc,
    fActualTax_pc,
    fActualCharges            : Double;

    // -- These variables are for the handling of multiple suppliers
    fHaveSupplierCode       : Boolean;
    fSupplierCodeSQLEncoded,
    fSupplierColumnName : String;

  	procedure LoadFieldList(TableName: string; AddTableName: Boolean;StringListDest: TStrings);
	  procedure SetupProductFieldList;
  	procedure ReadTableNames;
	  procedure DisplayProductTableFields;
  	function FindColumnNameOf(ADefinedElementName: string): string;

	  // -- Procedures for the actual patch run
  	function DetermineUpdateQueries: Boolean;

	  function ExportToCSV: Boolean;

  	procedure SetupBlankTableNames;
  	procedure Clear;
	  function  CheckOutputTables(UpdateFlag : Boolean):Boolean;
  	function  CreateAccessDatabase(databasename: wideString): Boolean;
	  function  ConnectAccessDatabase(databasename: wideString): Boolean;

    procedure ClearItems;
    function  LoadAllSelectedGroups:Boolean;
    function  LoadItemsFromGroup(NodePath : WideString; CategoryIndex : Integer):Boolean;

  	procedure AddProduct(pcode, pdesc, price: string); //for testing
	  function  TableExistsInSelectedDataBase(tablename: WideString):Boolean;
  	function  CreateGroupTable(TableName: wideString): Boolean;
	  function  CreateItemsTable(TableName: wideString): Boolean;

    procedure UpdateSuppliers(UpdateFlag : Boolean);
  	procedure UpdateGroups(UpdateFlag : Boolean);
	  procedure UpdateItems(UpdateFlag : Boolean);

    function BuildFieldValue(FieldIndex : Integer; Heirachy : Char='I'; ItemListIndex : Integer=-1):String; overload;
    function BuildFieldValue(FieldIndex : Integer; ProductNode : GTDNode):String; overload;

  	procedure DropTempTable(Tablename: WideString);
	  function  ExecuteSQL(var qc : TQuery; cs: WideString):Boolean;
  	function  DisplayProductGroups:Boolean;
	  function  DisplayItems:Boolean;
  	procedure SetSkinData(Value: TbsSkinData); {override;}
	  procedure BuildReport(const mType: string; const Msg: string);
  	procedure ReportMessage(Msg: string);
    procedure ShowStatus(Msg: String);

    procedure ClearDisplayCounters;
    procedure IncDisplayRises;
    procedure IncDisplayFalls;
    procedure IncDisplaySteady;
    procedure IncDisplayNew;
    procedure IncDisplayRemovals;
    procedure IncDisplayDetails;

    function GetPriceRisesCount:Integer;
    function GetPriceFallsCount:Integer;
    function GetPricesSteadyCount:Integer;
    function GetNewProductsCount:Integer;
    function GetRemovedProductsCount:Integer;
    function GetChangedDetailsCount:Integer;

    procedure LoadItems(ItemStatusFlag : Integer);

    procedure SetProcessButtonVisible(ShowIt : Boolean);

  public
  	{ Public declarations }
	  Pricelist : GTDPricelist;

  	SupplierOutputFieldNames,
	  SupplierOutputFieldMappings,
    SupplierOutputFieldTypes,

  	GroupOutputFieldNames,
	  GroupOutputFieldMappings,
    GroupOutputFieldTypes,

  	ItemOutputFieldNames,
	  ItemOutputFieldMappings,
    ItemOutputFieldTypes	: TStringList;

    WorkingNode             : GTDNode;

  	UpdateFlag : Boolean;

	  constructor Create(AOwner: TComponent); override;
  	destructor Destroy; override;

	  function  OpenUserdb: Boolean;
  	procedure CloseUserdb;
	  procedure Init;

    // -- This function loads the definitions required for
    //    the system defined product database.
    function  LoadSystemExportMap:Boolean;
    function  LoadExportMapping(ExportMap: TStringList): Boolean; overload;
  	function  LoadExportMapping(MapName: string): Boolean; overload;
	  function  SaveExportMapping(MapName: string): Boolean;

  	function  LoadSuppliersPricelist(Supplier_ID : Integer): Boolean;
	  function  LoadPricelist(myDoc: GTDBizDoc): Boolean;
  	function  LoadfromFile(filename : String): Boolean;

    procedure ClearSupplierMappings;
    procedure AddSupplierFieldMapping(DatabaseFieldName, PricelistFieldName, SQLFieldFormat : String);

    procedure ClearGroupMappings;
    procedure AddGroupFieldMapping(DatabaseFieldName, PricelistFieldName, SQLFieldFormat : String);

    procedure ClearItemMappings;
    procedure AddItemFieldMapping(DatabaseFieldName, PricelistFieldName, SQLFieldFormat : String);

    function  GetADOVersion: Double;
    procedure SetADOOutput(MDBFileName : String);

	  function  Run: Boolean;
    function  ExportToTSF(filename : String; pGauge : TbsSkinGauge = nil): Boolean;

  published
  	property SkinData: TbsSkinData read fSkinData write SetSkinData;

    property DocRegistry : GTDDocumentRegistry read fDocRegistry write fDocRegistry;

    property SupplierTable : String read fSupplierTableName write fSupplierTableName;
    property ProductItemsTable : String read fItemOutputTableName write fItemOutputTableName;
    property ProductGroupTable : String read fGroupOutputTableName write fGroupOutputTableName;

    property ShowProcessButton : Boolean read fShowProcessButton write SetProcessButtonVisible;

    property PriceRisesCount : Integer read GetPriceRisesCount;
    property PriceFallsCount : Integer read GetPriceFallsCount;
    property PricesSteadyCount : Integer read GetPricesSteadyCount;
    property NewProductsCount : Integer read GetNewProductsCount;
    property RemovedProductsCount : Integer read GetRemovedProductsCount;
    property ChangedDetailsCount : Integer read GetChangedDetailsCount;

    property List_AdjustmentPercentage : Double read fListAdjustment_pc write fListAdjustment_pc;
    property List_Charges : Double read fListCharges write fListCharges;
    property List_TaxPercentage : Double read fListTax_pc write fListTax_pc;
    property List_DWSPriceFormula : TStrings read fDWSListPriceCalcFormula write fDWSListPriceCalcFormula;
    property Actual_AdjustmentPercentage : Double read fActualAdjustment_pc write fActualAdjustment_pc;
    property Actual_Charges : Double read fActualCharges write fActualCharges;
    property Actual_TaxPercentage : Double read fActualTax_pc write fActualTax_pc;
    property Actual_DWSPriceFormula : TStrings read fDWSActualPriceCalcFormula write fDWSActualPriceCalcFormula;

  end;

implementation
uses bde;

{$R *.DFM}

// ----------------------------------------------------------------------------
function EncodeSQLFieldName(ColumnName : String):WideString;
begin
    Result := '[' + ColumnName + ']';
end;
// ----------------------------------------------------------------------------
constructor TGTDPricelistExportFrame.Create(AOwner: TComponent);
begin
	inherited Create(AOwner);

	Pricelist := GTDPricelist.Create(Self);

	SupplierOutputFieldNames := TStringList.Create;
	SupplierOutputFieldMappings := TStringList.Create;
  SupplierOutputFieldTypes := TStringList.Create;

	GroupOutputFieldNames	 := TStringList.Create;
	GroupOutputFieldMappings := TStringList.Create;
  GroupOutputFieldTypes    := TStringList.Create;

	ItemOutputFieldNames	 := TStringList.Create;
	ItemOutputFieldMappings  := TStringList.Create;
  ItemOutputFieldTypes     := TStringList.Create;

  WorkingNode              := GTDNode.Create;

//  btnCancel.Left := btnProcess.Left;
//  btnCancel.Top := btnProcess.Top;

  // -- The sql log
  mmoSQL.Top  := mmoProgress.Top;
  mmoSQL.Left := mmoProgress.Left;
  mmoSQL.Height := mmoProgress.Height;
  mmoSQL.Width := mmoProgress.Width;

  lsvItems.Top  := mmoProgress.Top;
  lsvItems.Left := mmoProgress.Left;
  lsvItems.Height := mmoProgress.Height;
  lsvItems.Width := mmoProgress.Width;

  fDWSActualPriceCalcFormula := TStrings.Create;
  fDWSListPriceCalcFormula := TStrings.Create;

end;
// ----------------------------------------------------------------------------
destructor TGTDPricelistExportFrame.Destroy;
begin
  Pricelist.Free;
  WorkingNode.Destroy;

	SupplierOutputFieldNames.Destroy;
	SupplierOutputFieldMappings.Destroy;
  SupplierOutputFieldTypes.Destroy;

	GroupOutputFieldNames.Destroy;
	GroupOutputFieldMappings.Destroy;
  GroupOutputFieldTypes.Destroy;

	ItemOutputFieldNames.Destroy;
	ItemOutputFieldMappings.Destroy;
  ItemOutputFieldTypes.Destroy;

  fDWSActualPriceCalcFormula.Destroy;
  fDWSListPriceCalcFormula.Destroy;

	inherited Destroy;
  
end;
// ----------------------------------------------------------------------------
procedure TGTDPricelistExportFrame.FormCreate(Sender: TObject);
const
  _Title            = 'Form Converter';
begin
	Pricelist := GTDPricelist.Create(Self);

//	if (csDesigning in ComponentState) then
//		MessageBox(0,'TPriceListExport Component ' + #13 +'Copyright 2005 by David Lyon' + #13#13 +'', _Title,MB_ICONINFORMATION);
end;
// ----------------------------------------------------------------------------
function TGTDPricelistExportFrame.OpenUserdb: Boolean;
begin

end;
// ----------------------------------------------------------------------------
procedure TGTDPricelistExportFrame.ReadTableNames;
begin

end;
// ----------------------------------------------------------------------------
procedure TGTDPricelistExportFrame.DisplayProductTableFields;
begin

end;
// ----------------------------------------------------------------------------
procedure TGTDPricelistExportFrame.CloseUserdb;
begin
  //dbADO.Connected := False;
  db1.Connected := False;
end;
// ----------------------------------------------------------------------------
function TGTDPricelistExportFrame.GetADOVersion: Double;
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
        ReportMessage('Please install Microsoft ADO ActivX component Version ' + FloatToStr(minAdoVersion) + ' or greater!');
        Result := -1;
        Exit;
      end;

      Result := versionNumber;

    end                               //Assigned(oAdo)
  else
    begin
        ReportMessage('Please install Microsoft ADO ActivX component Version ' + FloatToStr(minAdoVersion) + ' or greater!');
        Result := -1;
        Exit;
    end;
end;
// ----------------------------------------------------------------------------
procedure TGTDPricelistExportFrame.bsSkinButton8Click(Sender: TObject);
begin
  CloseUserdb;
end;
// ----------------------------------------------------------------------------
procedure TGTDPricelistExportFrame.LoadFieldList(TableName: string; AddTableName:
  Boolean; StringListDest: TStrings);
begin

end;
// ----------------------------------------------------------------------------
function TGTDPricelistExportFrame.DisplayProductGroups: Boolean;
var
  pg, pgc, sg, sgc  : Integer;
begin
	// -- Loop through each of the selected product groups
	// pricelist.LoadProductGroupTree(TTreeView(lstProdGroups));
end;
// ----------------------------------------------------------------------------
function TGTDPricelistExportFrame.DisplayItems:Boolean;
begin
	// -- table operations
  {
    if ZDB.Connected then
    begin
        ZDB.LoginPrompt := False;
        if tblDestItems.Active then
            tblDestItems.close;
        tblDestItems.TableName := ItemOutputTableName;
        tblDestItems.Open;
    end
    else begin
        DtblDestItems.Active := False;
        DtblDestItems.TableName := ItemOutputTableName;
        DtblDestItems.Open;
        DSAccess.DataSet := DtblDestItems;
    end;
    }
end;
// ----------------------------------------------------------------------------
function  TGTDPricelistExportFrame.LoadSuppliersPricelist(Supplier_ID : Integer): Boolean;
var
	myDoc : GTDBizDoc;
begin
    if not Assigned(fDocRegistry) then
        Exit;

	myDoc := GTDBizDoc.Create(Self);
	try

        // -- Open the registry for the trader
        if fDocRegistry.OpenForTraderNumber(Supplier_ID) then
        begin

            // -- Retrieve their latest pricelist
            if fDocRegistry.GetLatestPriceList(myDoc) then

                // -- Now load it into our component
                Result := LoadPricelist(myDoc);
        end;
        
	finally
		myDoc.Destroy;
	end;
end;
// ----------------------------------------------------------------------------
function TGTDPricelistExportFrame.LoadfromFile(filename : String): Boolean;
var
	myDoc : GTDBizDoc;
begin
	myDoc := GTDBizDoc.Create(Self);
	try
		// --
		myDoc.xml.LoadfromFile(filename);

		LoadPricelist(myDoc);

	finally
		myDoc.Destroy;
	end;
end;
// ----------------------------------------------------------------------------
function TGTDPricelistExportFrame.LoadPricelist(myDoc: GTDBizDoc): Boolean;
var
	VendorInfoNode    : GTDNode;
begin
	VendorInfoNode := GTDNode.Create;

	if VendorInfoNode.LoadFromDocument(myDoc, GTD_PL_VENDORINFO_NODE, True) then
	begin
	  // -- Basic Vendor details

	  // -- If the node doesn't exist then exit
	  {
	  Trader_GTL              := VendorInfoNode.ReadStringField(GTD_PL_ELE_COMPANY_CODE);
	  Trader_Name 			:= VendorInfoNode.ReadStringField(GTD_PL_ELE_COMPANY_NAME);
	  Trader_Street_Address	:= VendorInfoNode.ReadStringField(GTD_PL_ELE_ADDRESS_LINE_1);
						  s   := VendorInfoNode.ReadStringField(GTD_PL_ELE_ADDRESS_LINE_2);
	  if Length(s) <> 0 then
		  Trader_Street_Address := Trader_Street_Address + #13 + s;

	  Trader_City_Town		:= VendorInfoNode.ReadStringField(GTD_PL_ELE_TOWN);
	  Trader_Postcode_ZIP		:= VendorInfoNode.ReadStringField(GTD_PL_ELE_POSTALCODE);
	  Trader_State_Province	:= VendorInfoNode.ReadStringField(GTD_PL_ELE_STATE_REGION);

	  Trader_CountryCode      := VendorInfoNode.ReadStringField(GTD_PL_ELE_COUNTRYCODE);
	  Trader_CountryName      := GetNameFromCountryCode(Trader_CountryCode);
	  Trader_Phone			:= VendorInfoNode.ReadStringField(GTD_PL_ELE_TELEPHONE);
	  Trader_Fax				:= VendorInfoNode.ReadStringField(GTD_PL_ELE_FAX);

	  Trader_RegistrationText := VendorInfoNode.ReadStringField(GTD_PL_ELE_OTHER_INFO);
	  txtGTL.Text             := Trader_GTL;

	  txtSupplierName.Caption := VendorInfoNode.ReadStringField(GTD_PL_ELE_COMPANY_NAME);

	  txtAddress_1.Text       := VendorInfoNode.ReadStringField(GTD_PL_ELE_ADDRESS_LINE_1);
	  txtAddress_2.Text       := VendorInfoNode.ReadStringField(GTD_PL_ELE_ADDRESS_LINE_2);
	  txtPostCodeZip.Text     := Trader_Postcode_ZIP;
	  txtCountry.ItemIndex    := txtCountry.Items.IndexOf(Trader_CountryName);
	  txtStateProvince.ItemIndex := txtStateProvince.Items.IndexOf(Trader_State_Province);
	  if txtStateProvince.ItemIndex = -1 then
	  begin
		  txtStateProvince.Items.Insert(0,Trader_State_Province);
		  txtStateProvince.ItemIndex := 0;
	  end;
	  txtTelephone.Text       := Trader_Phone;
	  txtFascimile.Text       := Trader_Fax;
	  }
	end;

	Pricelist.Clear;
	Pricelist.XML.Assign(myDoc.XML);

	// -- Switch to the first page
//	nbkMain.ActivePageIndex := 0;

	// --
//	Pricelist.LoadProductGroupTree(TTreeView(lstProdGroups));

	VendorInfoNode.Destroy;

end;
// ----------------------------------------------------------------------------
procedure TGTDPricelistExportFrame.SetSkinData(Value: TbsSkinData);

  procedure SkinaPanel(where: TWinControl);
  var
    I               : Integer;
  begin

    with where do
      begin
        for I := 0 to Where.ControlCount - 1 do
          if Where.Controls[I] is TbsSkinControl then
            TbsSkinControl(Where.Controls[I]).SkinData := Value;
      end;

	TbsSkinControl(where).SkinData := Value;

  end;

var
  xc                : Integer;
begin

//  nbkMain.SkinData := Value;

  SkinaPanel(pnlBackGround);

//  lstProdGroups.SkinData := Value;
//  pnlProdGroups.SkinData := Value;

  btnShowData.SkinData := Value;
  mmoProgress.SkinData := Value;
  barProgress.SkinData := Value;
  btnProcess.SkinData := Value;
  btnCancel.SkinData := Value;

//  sbUpdates.SkinData := Value;
//  btnNext1.SkinData := Value;
  btnShowSQL.SkinData := Value;

  lsvItems.SkinData := Value;

  dlgOpen.SkinData := Value;
  dlgOpen.CtrlSkinData := Value;

  dlgSaveProfileName.SkinData := Value;
  dlgSaveProfileName.CtrlSkinData := Value;
  bsSkinMessage1.SkinData := Value;
  bsSkinMessage1.CtrlSkinData := Value;

  //	grdFieldMappings.SkinData := Value;
  //  bsUpDateProcess.SkinData := Value;
  //  inherited;

end;
// ----------------------------------------------------------------------------
function TGTDPricelistExportFrame.DetermineUpdateQueries: Boolean;
var
  sql               : string;

  function BuildInsertQuery: Boolean;
  var
	xc              : Integer;
	allblank        : Boolean;
  begin

  end;

  procedure BuildRemovalQuery;
  begin
  end;

  procedure BuildUpdateQuery;
  begin
  end;

begin
	Result := True;

	with tblProductUpdates do
	begin
		First;

		while not Eof do
		begin

		  // -- Initialise the sql variable, when changed it get saved
		  Sql := '';

		  // -- Each different type
		  if FieldByName('Update_Type').AsString = PRODUCT_UPDATE_ADDITION then
			begin
			  Result := BuildInsertQuery;
			end
		  else if FieldByName('Update_Type').AsString = PRODUCT_UPDATE_REMOVAL
			then
			begin
			  BuildRemovalQuery;
			end
		  else if FieldByName('Update_Type').AsString = PRODUCT_UPDATE_UPDATE
			then
			begin
			  BuildUpdateQuery;
			end;

		  // -- If one record didn't process properly then break
		  if not Result then
			Exit;

		  // -- Update the record
		  if SQL <> '' then
			begin
			  Edit;
			  FieldByName('SQL_Update_Text').AsString := SQL;
			  FieldByName('Applied_Flag').AsString := 'N';
			  Post;
			end;

		  // -- Advance onto next record
		  Next;

		end;
	end;

end;
// ----------------------------------------------------------------------------
procedure TGTDPricelistExportFrame.Init;
begin
end;
// ----------------------------------------------------------------------------
procedure TGTDPricelistExportFrame.BuildReport(const mType: string; const Msg:
  string);
begin
  // -- Display something in our message box
  if (mType = 'Clear') then
    mmoProgress.Lines.Clear
  else if mType = 'Show' then
	mmoProgress.Lines.Add(Msg)
  else
	mmoProgress.Lines.Add(mType + ': ' + Msg)
end;
// ----------------------------------------------------------------------------
function TGTDPricelistExportFrame.LoadExportMapping(MapName: string): Boolean;
var
  configMap         : TStringList;
begin
	Result := False;

	// -- Open the table if not already so
	if not tblSysVal.Active then
		tblSysVal.Active := True;

	if not Assigned(bdFieldMap) then
		bdFieldMap := GTDBizDoc.Create(Self);

	// -- Do we need to create a new record in sysvals?
	if (tblSysVal.FindKey(['Pricelist Export', MapName])) then
	begin

		// -- Load the params up
		// bdFieldMap.XML.Assign(TMemoField(tblSysVal.FieldByName('KEYTEXT')));

        configMap := TStringList.Create;

        configMap.Assign(TMemoField(tblSysVal.FieldByName('KEYTEXT')));

		LoadExportMapping(configMap);

        configMap.Destroy;

  	    Result := True;
	end;

end;
// ----------------------------------------------------------------------------
function TGTDPricelistExportFrame.LoadExportMapping(ExportMap: TStringList): Boolean;

  procedure SetColumnNameOf(AColumn, AValue: string);
  var
	xc              : Integer;
  begin

  end;
begin
	if not Assigned(bdFieldMap) then
		bdFieldMap := GTDBizDoc.Create(Self);

    // -- Load the definition
    bdFieldMap.Assign(ExportMap);

	// -- Database specific information
	dbType := bdFieldMap.GetStringElement('/Database', 'Driver');
	if (dbType = 'dBase') then
	begin
		txtdbaseDir := bdFieldMap.GetStringElement('/dBase', 'DataDirectory');
	end
	else if (dbType = Uppercase('Ado')) then
	begin

        txtAccessdb := bdFieldMap.GetStringElement('/ADO', 'Connection');

	    // load the database & directory name to txtDbName
        // txtDbName.Text := bdFieldMap.GetStringElement('/Database','Directory');

		//load the tablename to txtTableName
		fItemOutputTableName := bdFieldMap.GetStringElement('/Database','ProductTable');

      //load the grid with data from the Access table & the given database names loaded previously
      // by calling the Process Method

                // -- Column mappings
      SetColumnNameOf(GTD_PL_ELE_PRODUCT_CODE,bdFieldMap.GetStringElement('/Column Mappings',GTD_PL_ELE_PRODUCT_CODE));    //     = 'Product_ID';
      SetColumnNameOf(GTD_PL_ELE_PRODUCT_NAME,bdFieldMap.GetStringElement('/Column Mappings',GTD_PL_ELE_PRODUCT_NAME));    //     = 'Name';
      SetColumnNameOf(GTD_PL_ELE_PRODUCT_DESC,bdFieldMap.GetStringElement('/Column Mappings',GTD_PL_ELE_PRODUCT_DESC));    //     = 'Description';
      SetColumnNameOf(GTD_PL_ELE_PRODUCT_LIST,bdFieldMap.GetStringElement('/Column Mappings',GTD_PL_ELE_PRODUCT_LIST));    //     = 'List_Price';
      SetColumnNameOf(GTD_PL_ELE_PRODUCT_ACTUAL,bdFieldMap.GetStringElement('/Column Mappings',GTD_PL_ELE_PRODUCT_ACTUAL));    //     = 'Your_Price';
      SetColumnNameOf(GTD_PL_ELE_PRODUCT_TAXR,bdFieldMap.GetStringElement('/Column Mappings',GTD_PL_ELE_PRODUCT_TAXR));    //     = 'Tax_Rate';
      SetColumnNameOf(GTD_PL_ELE_PRODUCT_BRAND,bdFieldMap.GetStringElement('/Column Mappings',GTD_PL_ELE_PRODUCT_BRAND));   //     = 'Manufacturer';
      SetColumnNameOf(GTD_PL_ELE_PRODUCT_UNIT,bdFieldMap.GetStringElement('/Column Mappings',GTD_PL_ELE_PRODUCT_UNIT));    //     = 'Unit';
      SetColumnNameOf(GTD_PL_ELE_PRODUCT_TYPE,bdFieldMap.GetStringElement('/Column Mappings',GTD_PL_ELE_PRODUCT_TYPE));    //     = 'Product_Type';
      SetColumnNameOf(GTD_PL_ELE_PRODUCT_MOREINFO,bdFieldMap.GetStringElement('/Column Mappings',GTD_PL_ELE_PRODUCT_MOREINFO)); // = 'Further_Info_URL';
      SetColumnNameOf(GTD_PL_ELE_BRANDNAME,bdFieldMap.GetStringElement('/Column Mappings', GTD_PL_ELE_BRANDNAME));  //        = 'Brand_Name';
      SetColumnNameOf(GTD_PL_ELE_MANUFACT_NAME,bdFieldMap.GetStringElement('/Column Mappings',GTD_PL_ELE_MANUFACT_NAME));   //    = 'Manufacturer.Name';
      SetColumnNameOf(GTD_PL_ELE_MANUFACT_GTL,bdFieldMap.GetStringElement('/Column Mappings',GTD_PL_ELE_MANUFACT_GTL));    //     = 'Manufacturer.GTL';
      SetColumnNameOf(GTP_PL_ELE_MANUFACT_PRODINFO,bdFieldMap.GetStringElement('/Column Mappings',GTP_PL_ELE_MANUFACT_PRODINFO)); //= 'Manufacturer.Product_URL';
      SetColumnNameOf(GTD_PL_ELE_PRODUCT_AVAIL_FLAG,bdFieldMap.GetStringElement('/Column Mappings',GTD_PL_ELE_PRODUCT_AVAIL_FLAG)); // = 'Availability.Flag';
      SetColumnNameOf(GTD_PL_ELE_PRODUCT_AVAIL_DATE,bdFieldMap.GetStringElement('/Column Mappings',GTD_PL_ELE_PRODUCT_AVAIL_DATE)); // = 'Availability.Date';
      SetColumnNameOf(GTD_PL_ELE_PRODUCT_AVAIL_STATUS,bdFieldMap.GetStringElement('/Column Mappings',GTD_PL_ELE_PRODUCT_AVAIL_STATUS)); // = 'Availability.Status';
      SetColumnNameOf(GTD_PL_ELE_PRODUCT_AVAIL_BACKORD,bdFieldMap.GetStringElement('/Column Mappings',GTD_PL_ELE_PRODUCT_AVAIL_BACKORD)); //= 'Availability.OnBackOrder';
      SetColumnNameOf(GTD_PL_ELE_ONSPECIAL,bdFieldMap.GetStringElement('/Column Mappings',GTD_PL_ELE_ONSPECIAL));
      SetColumnNameOf(GTD_PL_ELE_ONSPECIAL_TILL,bdFieldMap.GetStringElement('/Column Mappings',GTD_PL_ELE_ONSPECIAL_TILL));
      SetColumnNameOf(GTD_PL_ELE_PRODUCT_IMAGE_ID,bdFieldMap.GetStringElement('/Column Mappings',GTD_PL_ELE_PRODUCT_IMAGE_ID));

      btnProcessClick(Self);

    end
	else if (dbType = 'BDE') then
	begin

		  // -- Load the aliases
		  txtBDEAlias := bdFieldMap.GetStringElement('/BDE', 'AliasName');
	end
	else if (dbType = 'ODBC') then
	begin
	end;
end;
// ----------------------------------------------------------------------------
function TGTDPricelistExportFrame.LoadSystemExportMap:Boolean;
var
    configMap       : TStringList;
    s               : String;
begin
	Result := False;

	// -- Open the table if not already so
    if not Assigned(fDocRegistry) then
        Exit;

	if not Assigned(bdFieldMap) then
		bdFieldMap := GTDBizDoc.Create(Self);

    dbType := PRICELIST_DBTYPE_ADO;

    // -- Read out the database name
    fDocRegistry.GetSettingString(GTD_PRODUCTDB_KEY,GTD_PRODDB_NAME, txtAccessdb);

    // -- Read the Supplier table export mappings
    fDocRegistry.GetSettingString(GTD_PRODUCTDB_KEY,GTD_PRODDB_SUPPLIER_TABLE, fSupplierTableName);
    ClearSupplierMappings;
    fDocRegistry.GetSettingMemoString('/Column Mappings',PRICELIST_EXPORTMAP_SUP_CODE,s);
    if (s <> '') then
        AddSupplierFieldMapping(s, PRICELIST_EXPORTMAP_SUPPLIER_CODE, 'INTEGER');
    fDocRegistry.GetSettingMemoString('/Column Mappings',PRICELIST_EXPORTMAP_SUP_NAME,s);
    if (s <> '') then
        AddSupplierFieldMapping(s, PRICELIST_EXPORTMAP_SUPPLIER_NAME, 'VARCHAR(35)');

    // -- Product Group area
    ClearGroupMappings;
    fDocRegistry.GetSettingString(GTD_PRODUCTDB_KEY,GTD_PRODDB_GROUPS_TABLE, fGroupOutputTableName);
    fDocRegistry.GetSettingMemoString('/Column Mappings',GTD_PL_ELE_PRODUCT_CODE,s);
    if (s <> '') then
        AddGroupFieldMapping(s, PRICELIST_EXPORTMAP_CATEGORY_NAME, 'VARCHAR(35)');

    // -- Product Items area
    ClearItemMappings;
    fDocRegistry.GetSettingString(GTD_PRODUCTDB_KEY,GTD_PRODDB_ITEMS_TABLE, fItemOutputTableName);

    fDocRegistry.GetSettingMemoString('/Column Mappings',GTD_PL_ELE_PRODUCT_CODE,s);
    if (s <> '') then
        AddItemFieldMapping(s, PRICELIST_EXPORTMAP_PRODUCT_CODE,'VARCHAR(30)');    //     = 'Product_ID';

    fDocRegistry.GetSettingMemoString('/Column Mappings',GTD_PL_ELE_PRODUCT_NAME,s);
    if (s <> '') then
        AddItemFieldMapping(s, PRICELIST_EXPORTMAP_PRODUCT_NAME ,'VARCHAR(100)');    //     = 'Product_Name';

    fDocRegistry.GetSettingMemoString('/Column Mappings',GTD_PL_ELE_PRODUCT_LIST,s);
    if (s <> '') then
        AddItemFieldMapping(s, PRICELIST_EXPORTMAP_PRODUCT_LIST,'Currency');    //     = 'Product_List';

    fDocRegistry.GetSettingMemoString('/Column Mappings',GTD_PL_ELE_PRODUCT_ACTUAL,s);
    if (s <> '') then
        AddItemFieldMapping(s, PRICELIST_EXPORTMAP_PRODUCT_ACTUAL,'Currency');    //     = 'Product_Sell';

    fDocRegistry.GetSettingMemoString('/Column Mappings',PRICELIST_EXPORTMAP_SUP_CODE,s);
    if (s <> '') then
        AddItemFieldMapping(s, PRICELIST_EXPORTMAP_SUPPLIER_CODE,'Integer');    //     = 'Product_Sell';
    {
      SetColumnNameOf(GTD_PL_ELE_PRODUCT_NAME,bdFieldMap.GetStringElement('/Column Mappings',GTD_PL_ELE_PRODUCT_NAME));    //     = 'Name';
      SetColumnNameOf(GTD_PL_ELE_PRODUCT_DESC,bdFieldMap.GetStringElement('/Column Mappings',GTD_PL_ELE_PRODUCT_DESC));    //     = 'Description';
      SetColumnNameOf(GTD_PL_ELE_PRODUCT_LIST,bdFieldMap.GetStringElement('/Column Mappings',GTD_PL_ELE_PRODUCT_LIST));    //     = 'List_Price';
      SetColumnNameOf(GTD_PL_ELE_PRODUCT_SELL,bdFieldMap.GetStringElement('/Column Mappings',GTD_PL_ELE_PRODUCT_SELL));    //     = 'Your_Price';
      SetColumnNameOf(GTD_PL_ELE_PRODUCT_TAXR,bdFieldMap.GetStringElement('/Column Mappings',GTD_PL_ELE_PRODUCT_TAXR));    //     = 'Tax_Rate';
      SetColumnNameOf(GTD_PL_ELE_PRODUCT_TAXT,bdFieldMap.GetStringElement('/Column Mappings',GTD_PL_ELE_PRODUCT_TAXT));    //     = 'Tax_Type';
      SetColumnNameOf(GTD_PL_ELE_PRODUCT_BRAND,bdFieldMap.GetStringElement('/Column Mappings',GTD_PL_ELE_PRODUCT_BRAND));   //     = 'Manufacturer';
      SetColumnNameOf(GTD_PL_ELE_PRODUCT_UNIT,bdFieldMap.GetStringElement('/Column Mappings',GTD_PL_ELE_PRODUCT_UNIT));    //     = 'Unit';
      SetColumnNameOf(GTD_PL_ELE_PRODUCT_TYPE,bdFieldMap.GetStringElement('/Column Mappings',GTD_PL_ELE_PRODUCT_TYPE));    //     = 'Product_Type';
      SetColumnNameOf(GTD_PL_ELE_PRODUCT_MOREINFO,bdFieldMap.GetStringElement('/Column Mappings',GTD_PL_ELE_PRODUCT_MOREINFO)); // = 'Further_Info_URL';
      SetColumnNameOf(GTD_PL_ELE_BRANDNAME,bdFieldMap.GetStringElement('/Column Mappings', GTD_PL_ELE_BRANDNAME));  //        = 'Brand_Name';
      SetColumnNameOf(GTD_PL_ELE_MANUFACT_NAME,bdFieldMap.GetStringElement('/Column Mappings',GTD_PL_ELE_MANUFACT_NAME));   //    = 'Manufacturer.Name';
      SetColumnNameOf(GTD_PL_ELE_MANUFACT_GTL,bdFieldMap.GetStringElement('/Column Mappings',GTD_PL_ELE_MANUFACT_GTL));    //     = 'Manufacturer.GTL';
      SetColumnNameOf(GTP_PL_ELE_MANUFACT_PRODINFO,bdFieldMap.GetStringElement('/Column Mappings',GTP_PL_ELE_MANUFACT_PRODINFO)); //= 'Manufacturer.Product_URL';
      SetColumnNameOf(GTD_PL_ELE_PRODUCT_AVAIL_FLAG,bdFieldMap.GetStringElement('/Column Mappings',GTD_PL_ELE_PRODUCT_AVAIL_FLAG)); // = 'Availability.Flag';
      SetColumnNameOf(GTD_PL_ELE_PRODUCT_AVAIL_DATE,bdFieldMap.GetStringElement('/Column Mappings',GTD_PL_ELE_PRODUCT_AVAIL_DATE)); // = 'Availability.Date';
      SetColumnNameOf(GTD_PL_ELE_PRODUCT_AVAIL_STATUS,bdFieldMap.GetStringElement('/Column Mappings',GTD_PL_ELE_PRODUCT_AVAIL_STATUS)); // = 'Availability.Status';
      SetColumnNameOf(GTD_PL_ELE_PRODUCT_AVAIL_BACKORD,bdFieldMap.GetStringElement('/Column Mappings',GTD_PL_ELE_PRODUCT_AVAIL_BACKORD)); //= 'Availability.OnBackOrder';
      SetColumnNameOf(GTD_PL_ELE_ONSPECIAL,bdFieldMap.GetStringElement('/Column Mappings',GTD_PL_ELE_ONSPECIAL));
      SetColumnNameOf(GTD_PL_ELE_ONSPECIAL_TILL,bdFieldMap.GetStringElement('/Column Mappings',GTD_PL_ELE_ONSPECIAL_TILL));
      SetColumnNameOf(GTD_PL_ELE_PRODUCT_IMAGE_ID,bdFieldMap.GetStringElement('/Column Mappings',GTD_PL_ELE_PRODUCT_IMAGE_ID));
    }
end;
// ----------------------------------------------------------------------------
function TGTDPricelistExportFrame.SaveExportMapping(MapName: string): Boolean;
var
  defmemo           : TMemoField;
begin
	// -- Open the table if not already so
	if not tblSysVal.Active then
		tblSysVal.Active := True;

	if not Assigned(bdFieldMap) then
		bdFieldMap := GTDBizDoc.Create(Self);

	// -- Do we need to create a new record in sysvals?
	if (tblSysVal.FindKey(['Pricelist Export', MapName])) then
	begin
		tblSysVal.Edit;
	end
	else
	begin
		tblSysVal.Append;
		tblSysVal.FieldByName('SECTION').AsString := 'Pricelist Export';
		tblSysVal.FieldByName('KEYNAME').AsString := MapName;

		// -- The database type    for Access Database
		bdFieldMap.SetStringElement('/Database', 'Driver', 'ADO');
//		bdFieldMap.SetStringElement('/Database', 'Directory', txtDbName.Text);
		bdFieldMap.SetStringElement('/Database', 'ProductTable',fItemOutputTableName);

		// -- Column mappings
		bdFieldMap.SetStringElement('/Column Mappings', GTD_PL_ELE_PRODUCT_CODE,FindColumnNameOf(GTD_PL_ELE_PRODUCT_CODE)); //     = 'Product_ID';
		bdFieldMap.SetStringElement('/Column Mappings', GTD_PL_ELE_PRODUCT_NAME,FindColumnNameOf(GTD_PL_ELE_PRODUCT_NAME)); //     = 'Name';
		bdFieldMap.SetStringElement('/Column Mappings', GTD_PL_ELE_PRODUCT_DESC,FindColumnNameOf(GTD_PL_ELE_PRODUCT_DESC)); //     = 'Description';
		bdFieldMap.SetStringElement('/Column Mappings', GTD_PL_ELE_PRODUCT_LIST,FindColumnNameOf(GTD_PL_ELE_PRODUCT_LIST)); //     = 'List_Price';
		bdFieldMap.SetStringElement('/Column Mappings', GTD_PL_ELE_PRODUCT_ACTUAL,FindColumnNameOf(GTD_PL_ELE_PRODUCT_ACTUAL)); //     = 'Your_Price';
		bdFieldMap.SetStringElement('/Column Mappings', GTD_PL_ELE_PRODUCT_TAXR,FindColumnNameOf(GTD_PL_ELE_PRODUCT_TAXR)); //     = 'Tax_Rate';
		bdFieldMap.SetStringElement('/Column Mappings', GTD_PL_ELE_PRODUCT_BRAND,FindColumnNameOf(GTD_PL_ELE_PRODUCT_BRAND)); //     = 'Manufacturer';
		bdFieldMap.SetStringElement('/Column Mappings', GTD_PL_ELE_PRODUCT_UNIT,FindColumnNameOf(GTD_PL_ELE_PRODUCT_UNIT)); //     = 'Unit';
		bdFieldMap.SetStringElement('/Column Mappings', GTD_PL_ELE_PRODUCT_TYPE,FindColumnNameOf(GTD_PL_ELE_PRODUCT_TYPE)); //     = 'Product_Type';
		bdFieldMap.SetStringElement('/Column Mappings', GTD_PL_ELE_PRODUCT_MOREINFO,FindColumnNameOf(GTD_PL_ELE_PRODUCT_MOREINFO)); // = 'Further_Info_URL';
		bdFieldMap.SetStringElement('/Column Mappings', GTD_PL_ELE_BRANDNAME,FindColumnNameOf(GTD_PL_ELE_BRANDNAME)); //        = 'Brand_Name';
		bdFieldMap.SetStringElement('/Column Mappings', GTD_PL_ELE_MANUFACT_NAME,FindColumnNameOf(GTD_PL_ELE_MANUFACT_NAME)); //    = 'Manufacturer.Name';
		bdFieldMap.SetStringElement('/Column Mappings', GTD_PL_ELE_MANUFACT_GTL,FindColumnNameOf(GTD_PL_ELE_MANUFACT_GTL)); //     = 'Manufacturer.GTL';
		bdFieldMap.SetStringElement('/Column Mappings',GTP_PL_ELE_MANUFACT_PRODINFO,FindColumnNameOf(GTP_PL_ELE_MANUFACT_PRODINFO));  //= 'Manufacturer.Product_URL';
		bdFieldMap.SetStringElement('/Column Mappings',GTD_PL_ELE_PRODUCT_AVAIL_FLAG,FindColumnNameOf(GTD_PL_ELE_PRODUCT_AVAIL_FLAG)); // = 'Availability.Flag';
		bdFieldMap.SetStringElement('/Column Mappings',GTD_PL_ELE_PRODUCT_AVAIL_DATE,FindColumnNameOf(GTD_PL_ELE_PRODUCT_AVAIL_DATE)); // = 'Availability.Date';
		bdFieldMap.SetStringElement('/Column Mappings',GTD_PL_ELE_PRODUCT_AVAIL_STATUS,FindColumnNameOf(GTD_PL_ELE_PRODUCT_AVAIL_STATUS));  // = 'Availability.Status';
		bdFieldMap.SetStringElement('/Column Mappings',GTD_PL_ELE_PRODUCT_AVAIL_BACKORD,FindColumnNameOf(GTD_PL_ELE_PRODUCT_AVAIL_BACKORD));  //= 'Availability.OnBackOrder';
		bdFieldMap.SetStringElement('/Column Mappings', GTD_PL_ELE_ONSPECIAL,FindColumnNameOf(GTD_PL_ELE_ONSPECIAL));
		bdFieldMap.SetStringElement('/Column Mappings', GTD_PL_ELE_ONSPECIAL_TILL,FindColumnNameOf(GTD_PL_ELE_ONSPECIAL_TILL));
		bdFieldMap.SetStringElement('/Column Mappings',GTD_PL_ELE_PRODUCT_IMAGE_ID,FindColumnNameOf(GTD_PL_ELE_PRODUCT_IMAGE_ID));

		// -- Table mappings

		  // -- Update the memo field
		defmemo := TMemoField(tblSysVal.FieldByName('KEYTEXT'));
		defmemo.Assign(bdFieldMap.XML);
		// -- Now write to the table
		tblSysVal.Post;

		dbProfileName := MapName;
		init; //to update the listbox1 items with mapping names

	end;

end;

// ----------------------------------------------------------------------------
// -- Here we look up what a column should be translated to
function TGTDPricelistExportFrame.FindColumnNameOf(ADefinedElementName: string):string;
var
  xc, xd            : Integer;
  c                 : string;
begin

  Result := '';

end;
// ----------------------------------------------------------------------------
procedure TGTDPricelistExportFrame.SetupBlankTableNames;
const
  dfltPgrpTableName = 'Product_Groups';
  dfltSubPrgpTableName = 'Product_SubGroups';
  dfltProductTableName = 'Products';
  dfltSupplierTableName = 'Suppliers';
begin

end;
// ----------------------------------------------------------------------------
procedure TGTDPricelistExportFrame.Clear;
begin
end;
// ----------------------------------------------------------------------------
procedure TGTDPricelistExportFrame.btnNext2Click(Sender: TObject);
begin
  SetupBlankTableNames;
//  nbkMain.ActivePageIndex := 2;
end;
// ----------------------------------------------------------------------------
function TGTDPricelistExportFrame.ExecuteSQL(var qc : TQuery; cs: WideString):Boolean;
begin

    // -- Keep a track of every SQL statement issued
    fSQLTrace := mmoSQL.Lines;
    if Assigned(fSQLTrace) then
    begin
        fSQLTrace.Add(cs);
    end;

    try

      Result := False;

      // -- Run the SQL
      if DeersoftDB.Connected then
      begin
          if (qc = TQuery(DQrySuppliers)) then
          with DQrySuppliers do
          begin
              Active := False;
              Params.Clear();
              SQL.Text := cs;
              ExecSQL(cs);
          end
          else if (qc = TQuery(DQryGroups)) then
          with DQryGroups do
          begin
              Active := False;
              Params.Clear();
              SQL.Text := cs;
              ExecSQL(cs);
          end
          else if (qc = TQuery(DQryItems)) then
          with DQryItems do
          begin
              Active := False;
              Params.Clear();
              SQL.Clear;
              SQL.Add(cs);
              ExecSQL(cs);
          end;
      end;

      Result := True;

  except
    on E: Exception do
      ReportMessage('Error - Unable to run SQL ' + cs);
  end;
end;
// ----------------------------------------------------------------------------
// this procedure will create a MS Access database (.mdb) based on the name given in the database edit box
// It will not be created if the database already exists
function TGTDPricelistExportFrame.createAccessDatabase(databasename: wideString):
  Boolean;
const
  Jet10             = 1;
  Jet11             = 2;
  Jet20             = 3;
  Jet3x             = 4;
  Jet4x             = 5;
var
  oAdo              : _Connection;
  accessEngine      : variant;
  adoString         : WideString;
  versionNumber     : double;
  version           : wideString;
  dbName            : WideString;
begin

  dbName := databasename;
  if not fileExists(dbName) then
  begin
	  OleCheck(CoCreateInstance(CLASS_Connection, nil, CLSCTX_ALL,IID__Connection, oAdo));
	  if Assigned(oAdo) then
		begin
		  versionNumber := StringTofloat(oAdo.version);
		  if versionNumber >= 2 then
			begin
			  versionNumber := int(versionNumber) + 1;
			  version := FormatFloat('##.##',versionNumber);
			  accessEngine := CreateOleObject('ADOX.Catalog');
			  adoString := 'Provider=Microsoft.Jet.OLEDB.4.0' +
				';Jet OLEDB:Engine Type=' + version +
				';Data Source=' + dbName;
			  accessEngine.Create(adoString);

			end                         //versionNumber >= 2
          else if VersionNumber < 2 then
            MessageDlg('Please install Microsoft ADO ActivX component' +
              ' Ver 2 or greater!', mtWarning, [mbCancel], 0);

        end                             //Assigned(oAdo)
      else
		MessageDlg('Microsoft ADO ActivX components not installed!', mtWarning,
          [mbCancel], 0);

    end;                                //not fileExists(dbName)

end;
// ----------------------------------------------------------------------------
//to check whether a given table exists as part of a database
function TGTDPricelistExportFrame.TableExistsInSelectedDataBase(tablename:WideString): Boolean;
var
    Pattern           : string;
    listCounter       : integer;
    dbObjectList      : TStringList;
begin

    Result := False;

    // -- Create our stringlist
    dbObjectList := TStringList.Create;

    // -- Check if we are using this one
    if DeersoftDB.Connected then
    begin
        // --
        DeersoftDB.CentralData.GetADOTableNames(dbObjectList);
    end;

    //  check for match from the table items of the database & given tableName
    for listCounter := 0 to dbObjectList.Count - 1 do
    begin
        if dbObjectList.Strings[listCounter] = tablename then
        begin
            Result := true;
            break;
        end;
    end;

    dbObjectList.Destroy;

end;
// ----------------------------------------------------------------------------
// -- Create the product groups table
function TGTDPricelistExportFrame.CreateGroupTable(tableName:wideString): Boolean;
var
    qs : wideString;
    xc : Integer;
begin

    // -- Build the SQL to create the category table
    qs := 'CREATE TABLE ' + tableName + ' (';

    // -- Add in all the field names and types that were provided
    for xc := 0 to GroupOutputFieldMappings.Count-1 do
    begin
		qs := qs + ' ' + GroupOutputFieldNames[xc] + ' ' +
                         GroupOutputFieldTypes[xc] + ',';
    end;
    qs := Copy(qs,1,Length(qs)-1) + ')';

    // -- create the table by executing the query
    Result := ExecuteSQL(qryGroupUpdate,qs);

//  cs := 'CREATE INDEX idxPrimary ON ' + TableName + '( Code ) WITH PRIMARY';
//  create index    by executing the query
//  ExecuteSQL(cs);
end;
// ----------------------------------------------------------------------------
procedure TGTDPricelistExportFrame.UpdateSuppliers(UpdateFlag : Boolean);
var
    NoOfInserts,
    NoOfUpdates,
    i, xc       : integer;
    SupName,
    SupColName,
    SupCodeCol, qfs,qs	: String;

    function FindSupplierCodeColumn:String;
    var
        xc : Integer;
    begin
        for xc := 0 to SupplierOutputFieldMappings.Count-1 do
        begin
            if SupplierOutputFieldMappings[xc] = PRICELIST_EXPORTMAP_SUPPLIER_CODE then
            begin
                Result := SupplierOutputFieldNames[xc];
                break
            end;
        end;
    end;
    function FindSupplierNameColumn:String;
    var
        xc : Integer;
    begin
        for xc := 0 to SupplierOutputFieldMappings.Count-1 do
        begin
            if SupplierOutputFieldMappings[xc] = PRICELIST_EXPORTMAP_SUPPLIER_NAME then
            begin
                Result := SupplierOutputFieldNames[xc];
                break
            end;
        end;
    end;

begin
    // -- There should only be one Supplier, so what we do is to
    //    look him up and retrieve the unique ID. If there is no
    //
    qfs := '';
//        AddSupplierFieldMapping(s, PRICELIST_EXPORTMAP_SUPPLIER_CODE, 'INTEGER');
//    fDocRegistry.GetSettingMemoString('/Column Mappings',PRICELIST_EXPORTMAP_SUP_NAME,s);
//    if (s <> '') then
//        AddGroupFieldMapping(s, PRICELIST_EXPORTMAP_SUPPLIER_NAME, 'VARCHAR(35)');

	// -- progressbar opeartions
	barProgress.Value := 10;

    // -- We use the column from the supplier table (that the
    //    user just selected)
    SupName := fDocRegistry.Traders.FieldByName(GTD_DB_COL_COMPANY_NAME).AsString;

    ReportMessage('Updating Supplier Table for ' + SupName);

    // -- Find the name of the supplier id column
    SupCodeCol := FindSupplierCodeColumn;
    fSupplierColumnName := FindSupplierCodeColumn;

    // -- Determine the supplier name column
    SupColName := FindSupplierNameColumn;
    if SupColName = '' then
    begin
        ReportMessage('Unable to Update Supplier Table, no Supplier name parameter specified');
        Exit;
    end;

    // -- Look up the Supplier by their name
    qfs := 'select * from ' + fSupplierTableName + ' where (' + SupColName +  ' = ' + EncodeSQLString(SupName) + ')';

    ExecuteSQL(QrySupplierUpdate,qfs);

	QrySupplierUpdate.Open;
	QrySupplierUpdate.first;

	//check whether any records have been returned by checking for eof function   .The number
	//of records retunrd will be 0 or 1

	if QrySupplierUpdate.eof then
	begin

        // -- If the table does not have a matching record
        //    & hence the data from listview should be inserted into the table through insert statement

        qs := 'Insert into  ' + fSupplierTableName + '( ';

        // -- Add all columns from the mapping table
        for xc := 0 to SupplierOutputFieldMappings.Count-1 do
        begin
            // -- Add all columns except novalue
            if (SupplierOutputFieldMappings[xc] <> '%NOVALUE') and (SupplierOutputFieldMappings[xc] <> '%SUPPLIER_CODE') then
            begin
                qs := qs + SupplierOutputFieldNames[xc] + ', ';
            end;
        end;
        // -- Chop off the last comma
        qs := Copy(qs,1,Length(qs)-2);

        qs := qs + ') Values ' + '(';

        // -- Calculate all the column values the mapping table
        for xc := 0 to SupplierOutputFieldMappings.Count-1 do
        begin
            // -- Add all columns except novalue
            if SupplierOutputFieldMappings[xc] = '%SUPPLIER_NAME' then
                qs := qs + EncodeSQLString(SupName) + ', '
            else if (SupplierOutputFieldMappings[xc] <> '%NOVALUE') and (SupplierOutputFieldMappings[xc] <> '%SUPPLIER_CODE') then
                // -- Here is a big gap of functionality to add..
                qs := qs + BuildFieldValue(xc,'S',0) + ', ';
        end;
        // -- Chop off the last comma
        qs := Copy(qs,1,Length(qs)-2)+')';

        if UpdateFlag then
        begin

            // -- Insert query will will be excuted only if user has asked for inserts
            //    by selecting the check box Report and Updatees
            ExecuteSQL(QrySupplierUpdate,qs);

            // -- Now we have to reread the value to get the supplier code
            ExecuteSQL(QrySupplierUpdate,qfs);
        	QrySupplierUpdate.Open;
        	QrySupplierUpdate.first;

        	//check whether any records have been returned by checking for eof function   .The number
        	//of records retunrd will be 0 or 1
        	if not QrySupplierUpdate.eof then
            begin
                if SupCodeCol <> '' then
                begin
                    fSupplierCodeSQLEncoded := DQrySuppliers.FieldByName(SupCodeCol).AsString;
                    fHaveSupplierCode := True;
                end;
            end;

        	QrySupplierUpdate.Close;

        end;

        NoOfInserts := NoOfInserts + 1;  //keep track of the Number of inserts

	end
	else
	begin
        // -- The table has a matching record so return the code
        if (SupCodeCol <> '') then
        begin
            fSupplierCodeSQLEncoded := DQrySuppliers.FieldByName(SupCodeCol).AsString;
            // -- This flag tells that we have a supplier code
            fHaveSupplierCode := True;
        end;
	end;

end;
// ----------------------------------------------------------------------------
procedure TGTDPricelistExportFrame.UpdateGroups(UpdateFlag : Boolean);
var
    NoOfInserts,
    NoOfUpdates,
    i, xc       : integer;
    catName,
    catColName,qs	: String;

    function FindGroupFieldColumn:String;
    var
        xc : Integer;
    begin
        for xc := 0 to GroupOutputFieldMappings.Count-1 do
        begin
            if GroupOutputFieldMappings[xc] = '%CATEGORY_NAME' then
            begin
                Result := GroupOutputFieldNames[xc];
                break
            end;
        end;
    end;

begin
	// -- progressbar opeartions
	barProgress.Value := 10;

    ReportMessage('Updating Product Groups');

    // -- We need to
    catColName := FindGroupFieldColumn;
    if catColName = '' then
    begin
        ReportMessage('Unable to Update Product Groups, no column name specified');
        Exit;
    end;

	// -- loop through the product Groups
	with lstProdGroups.Items do
	begin
		for i := 0 to Count - 1 do
		begin
			// -- Get the category name
			catName := Item[i].Text;

			// -- Look up the category code
			qs := 'select * from ' + fGroupOutputTableName + ' where (' + catColName +  ' = ' + EncodeSQLString(catName) + ')';

			ExecuteSQL(qryGroupUpdate,qs);
			qryGroupUpdate.Open;
			qryGroupUpdate.first;

			//check whether any records have been returned by checking for eof function   .The number
			//of records retunrd will be 0 or 1

			if qryGroupUpdate.eof then
			begin
                //the table does not have a matching record
	    		// & hence the data from listview should be inserted into the table through insert statement

				qs := 'Insert into  ' + fGroupOutputTableName + '( ';

                // -- Add all columns from the mapping table
                for xc := 0 to GroupOutputFieldMappings.Count-1 do
                begin
                    // -- Add all columns except novalue
                    if GroupOutputFieldMappings[xc] <> '%NOVALUE' then
                    begin
                        qs := qs + GroupOutputFieldNames[xc] + ', ';
                    end;
                end;
                // -- Chop off the last comma
                qs := Copy(qs,1,Length(qs)-2);

                qs := qs + ') Values ' + '(';

                // -- Calculate all the column values the mapping table
                for xc := 0 to GroupOutputFieldMappings.Count-1 do
                begin
                    // -- Add all columns except novalue
                    if GroupOutputFieldMappings[xc] = '%CATEGORY_NAME' then
                        qs := qs + EncodeSQLString(catName) + ', '
                    else if GroupOutputFieldMappings[xc] <> '%NOVALUE' then
                        // -- Here is a big gap of functionality to add..
                        qs := qs + BuildFieldValue(xc,'G',0) + ', ';
                end;
                // -- Chop off the last comma
                qs := Copy(qs,1,Length(qs)-2)+')';

			    if UpdateFlag then
                    // -- Insert query will will be excuted only if user has asked for inserts
				    //    by selecting the check box Report and Updatees
					ExecuteSQL(qryGroupUpdate,qs);

			  NoOfInserts := NoOfInserts + 1;  //keep track of the Number of inserts

			end
			else
			begin //the table has a matching record & then comapare  Prices of ListView & table
			  // If the Prices do not match update the record of the table from listview
//			barProgress.value := i;       //update the value of progreesbar
			end;
		end;
	end;
//	barProgress.Value := i;

end;
// ----------------------------------------------------------------------------
function TGTDPricelistExportFrame.BuildFieldValue(FieldIndex : Integer; Heirachy : Char; ItemListIndex : Integer):String;
var
    funcType : Char;
    funcName,
    datatype,
    funcParms,
    fieldname : String;
    L,V       : String;
begin
    // -- We might be doing product groups or product items
    if Heirachy = 'S' then
    begin
        funcName := SupplierOutputFieldMappings[FieldIndex];
        datatype := SupplierOutputFieldTypes[FieldIndex];
    end
    else if Heirachy = 'G' then
    begin
        funcName := GroupOutputFieldMappings[FieldIndex];
        datatype := GroupOutputFieldTypes[FieldIndex];
    end
    else begin
        funcName := ItemOutputFieldMappings[FieldIndex];
        datatype := ItemOutputFieldTypes[FieldIndex];
    end;

    funcType := funcName[1];
    if funcType = '%' then
    begin
        L := funcName;

        funcName := Parse(L,'=');
        funcParms := L;

        if funcName = PRICELIST_EXPORTMAP_NOVALUE then

        else if funcName = PRICELIST_EXPORTMAP_NEW_ROWID then
        begin
            // -- A generated rowid
        end
        else if funcName = PRICELIST_EXPORTMAP_CATEGORY_INDEX then
        begin
            // -- The Product Group Index
            Result := lsvItems.Items[ItemListIndex].SubItems[CATEGORYINDEX_IN_SUBITEM_INDEX];
        end
        else if funcName = PRICELIST_EXPORTMAP_CATEGORY_NAME then
        begin
        end
        else if funcName = PRICELIST_EXPORTMAP_CATEGORY_PATH then
        begin
        end
        else if funcName = PRICELIST_EXPORTMAP_CATEGORY_FIELD then
        begin
            // -- We need to do a lookup
            Result := '1';
        end
        else if funcName = PRICELIST_EXPORTMAP_TRADER_FIELD then
        begin
            // =FLDNAME   A field value from the Trader Table
        end
        else if funcName = PRICELIST_EXPORTMAP_SUPPLIER_CODE then
        begin
            // The Supplier Account code
            if fHaveSupplierCode then
                Result := fSupplierCodeSQLEncoded;
        end
        else if funcName = PRICELIST_EXPORTMAP_TRADER_ID then
        begin
            // Trader_ID field from Trader Table
        end
        else if funcName = PRICELIST_EXPORTMAP_TRADER_NAME then
        begin
            // Trader_Name field from Trader Table
        end

    end
    else if funcType = '@' then
    begin
        // -- Rip out the fieldname that we need
        fieldname := Copy(funcName,2,Length(funcName)-1);

        WorkingNode.UseSingleLine(lsvItems.Items[ItemListIndex].SubItems[RECORDDATA_IN_SUBITEM_INDEX]);

        // -- Read out the string
        v := WorkingNode.ReadStringField(fieldname);

        if (Pos(UpperCase(datatype),'DOUBLE|CURRENCY|INTEGER')<>0) then
        begin
            // -- Then we have to clean up the variable
            if (v = '') then
                // -- Numeric zero
                Result := '0'
            else
                // -- This will do a safe cleanup of the value
                Result := Format('%f',[StringToFloat(v)]);
        end
        else
            Result := EncodeSQLString(v);

    end;

end;
// ----------------------------------------------------------------------------
function TGTDPricelistExportFrame.BuildFieldValue(FieldIndex : Integer; ProductNode : GTDNode):String;
var
    funcType : Char;
    funcName,
    datatype,
    funcParms,
    fieldname : String;
    L,V       : String;
begin
    // -- We might be doing product groups or product items
    funcName := ItemOutputFieldMappings[FieldIndex];
    datatype := ItemOutputFieldTypes[FieldIndex];

    funcType := funcName[1];
    if funcType = '%' then
    begin
        L := funcName;

        funcName := Parse(L,'=');
        funcParms := L;

        if funcName = PRICELIST_EXPORTMAP_NOVALUE then

        else if funcName = PRICELIST_EXPORTMAP_NEW_ROWID then
        begin
            // -- A generated rowid
        end
        else if funcName = PRICELIST_EXPORTMAP_CATEGORY_INDEX then
        begin
            // -- The Product Group Index
            // Result := ;
        end
        else if funcName = PRICELIST_EXPORTMAP_CATEGORY_NAME then
        begin
        end
        else if funcName = PRICELIST_EXPORTMAP_CATEGORY_PATH then
        begin
        end
        else if funcName = PRICELIST_EXPORTMAP_CATEGORY_FIELD then
        begin
            // -- We need to do a lookup
            Result := '1';
        end
        else if funcName = PRICELIST_EXPORTMAP_TRADER_FIELD then
        begin
            // =FLDNAME   A field value from the Trader Table
        end
        else if funcName = PRICELIST_EXPORTMAP_SUPPLIER_CODE then
        begin
            // The Supplier Account code
            if fHaveSupplierCode then
                Result := fSupplierCodeSQLEncoded;
        end
        else if funcName = PRICELIST_EXPORTMAP_TRADER_ID then
        begin
            // Trader_ID field from Trader Table
        end
        else if funcName = PRICELIST_EXPORTMAP_TRADER_NAME then
        begin
            // Trader_Name field from Trader Table
        end

    end
    else if funcType = '@' then
    begin
        // -- Rip out the fieldname that we need
        fieldname := Copy(funcName,2,Length(funcName)-1);

        // -- Read out the string
        v := ProductNode.ReadStringField(fieldname);

        if (Pos(UpperCase(datatype),'DOUBLE|CURRENCY|INTEGER')<>0) then
        begin
            // -- Then we have to clean up the variable
            if (v = '') then
                // -- Numeric zero
                Result := '0'
            else
                // -- This will do a safe cleanup of the value
                Result := Format('%f',[StringToFloat(v)]);
        end
        else
            Result := EncodeSQLString(v);

    end;
end;
// ----------------------------------------------------------------------------
// -- Create the product items table
function TGTDPricelistExportFrame.CreateItemsTable(tableName:wideString): Boolean;
var
    qs : wideString;
    xc : Integer;
begin

    // -- Build the SQL to create the category table
    qs := 'CREATE TABLE ' + tableName + ' (';

    // -- Add in all the field names and types that were provided
    for xc := 0 to ItemOutputFieldMappings.Count-1 do
    begin
		qs := qs + ' ' + ItemOutputFieldNames[xc] + ' ' +
                         ItemOutputFieldTypes[xc] + ',';
    end;
    qs := Copy(qs,1,Length(qs)-1) + ')';

    // -- create the table by executing the query
    ExecuteSQL(qryItemUpdate,qs);

    // -- create an index by executing the query
    //  cs := 'CREATE INDEX idxPrimary ON ' + TableName + '( Code ) WITH PRIMARY';
    //  ExecuteSQL(cs);

end;
// ----------------------------------------------------------------------------
// -- Load the data into table from list view by looping through the listview rows
procedure TGTDPricelistExportFrame.UpdateItems(UpdateFlag : Boolean);
var
    qs,s              : String;
    i, j, xc          : integer;
    ItemProductCode,
    ItemProductName,
    CodeLookupColumn,
    NameLookupColumn,
    PriceCompareField,
    SupplierWhereClause : string;
    noOfRecords       : integer;
    pricelistListPrice,
    pricelistActualPrice,
    CurrentDBPrice: Double;

    CheckingByProductCode,
    CheckingByProductName,
    PriceChanged   : Boolean;

    thisProduct : GTDNode;

    function FindItemActualColumn:String;
    var
        xc : Integer;
    begin
        for xc := 0 to ItemOutputFieldMappings.Count-1 do
        begin
            if ItemOutputFieldMappings[xc] = PRICELIST_EXPORTMAP_PRODUCT_ACTUAL then
            begin
                Result := ItemOutputFieldNames[xc];
                break
            end;
        end;
    end;
    function FindItemCodeColumn:String;
    var
        xc : Integer;
    begin
        for xc := 0 to ItemOutputFieldMappings.Count-1 do
        begin
            if ItemOutputFieldMappings[xc] = PRICELIST_EXPORTMAP_PRODUCT_CODE then
            begin
                Result := ItemOutputFieldNames[xc];
                break
            end;
        end;
    end;
    function FindItemNameColumn:String;
    var
        xc : Integer;
    begin
        for xc := 0 to ItemOutputFieldMappings.Count-1 do
        begin
            if ItemOutputFieldMappings[xc] = PRICELIST_EXPORTMAP_PRODUCT_NAME  then
            begin
                Result := ItemOutputFieldNames[xc];
                break
            end;
        end;
    end;
begin
	// -- Initilaise varaiables
    i := 0;
  	barProgress.MinValue := 0;
	  barProgress.Value := 30;
  	lsvItems.SmallImages := ImageList1;

    PriceCompareField := FindItemActualColumn;
    CodeLookupColumn  := FindItemCodeColumn;
    NameLookupColumn  := FindItemNameColumn;

    CheckingByProductCode := CodeLookupColumn <> '';
    CheckingByProductName := NameLookupColumn <> '';

    mmoProgress.Visible := True;
    if fShowSQL then
    begin
        mmoSQL.Visible := True;
        mmoSQL.BringToFront;
    end
    else begin
        mmoSQL.Visible := False;
        mmoSQL.SendToBack;
    end;

    if CheckingByProductCode then
        // -- Select the code lookup in preference to name lookups
        CheckingByProductName := False;

    ShowStatus('Updating Product Items');
    ReportMessage('Updating Product Items');

    if (not CheckingByProductCode) and (not CheckingByProductName) then
    begin
        ReportMessage('Unable to run comparison, no product code or name columns specified');
        Exit;
    end;

    try
        thisproduct := GTDNode.Create;

        i := 0;

        ClearDisplayCounters;
        fKeepRunning := True;
        btnProcess.Visible := False;
        btnCancel.Visible := True;

        // Progressbar1.step:=round(1/bsSkinListView1.Items.count );
        // comapring data of list view with selected table
        Pricelist.StartItemIterator;

        barProgress.MaxValue := Pricelist.ItemList.count;

        // -- Build this value here instead of inside the loop
        if fHaveSupplierCode then
            SupplierWhereClause := ' and (' + fSupplierColumnName + '=' + fSupplierCodeSQLEncoded + ')';

        while Pricelist.NextItemIteration(thisproduct) and fKeepRunning do
        begin

            // -- May as well load these up they will be used in
            //    lots of places
            ItemProductCode := thisProduct.ReadStringField(GTD_PL_ELE_PRODUCT_CODE);
            ItemProductName := thisProduct.ReadStringField(GTD_PL_ELE_PRODUCT_NAME);

            // -- Price adjustment for the Actual price
            pricelistActualPrice := ((100 + fActualAdjustment_pc) * thisProduct.ReadNumberField(GTD_PL_ELE_PRODUCT_ACTUAL,0) / 100) +
                                  fActualCharges +
                                  ((100 + fActualTax_pc) * thisProduct.ReadNumberField(GTD_PL_ELE_PRODUCT_ACTUAL,0) / 100);

            // -- Price adjustment for the list price
            pricelistListPrice := ((100 + fListAdjustment_pc) * thisProduct.ReadNumberField(GTD_PL_ELE_PRODUCT_LIST,0) / 100) +
                                  fListCharges +
                                  ((100 + fListTax_pc) * thisProduct.ReadNumberField(GTD_PL_ELE_PRODUCT_LIST,0) / 100);

            // --
            if CheckingByProductCode then
            begin
                // -- For each row of ListView  try to find a match based on Column Code from the table

                // -- Build the query
                qs := 'select * from ' + fItemOutputTableName +
                      ' where (' + EncodeSQLFieldName(CodeLookupColumn) + ' = ' + EncodeSQLString(ItemProductCode) + ')';

                // The Supplier Account code
                if fHaveSupplierCode then
                    qs := qs + SupplierWhereClause;

            end
            else if CheckingByProductName then
            begin
                // -- For each row of ListView  try to find a match based on Column Code from the table

                // -- Build the query
                qs := 'select * from ' + fItemOutputTableName +
                      ' where (' + EncodeSQLFieldName(NameLookupColumn) + ' = ' + EncodeSQLString(ItemProductName) + ')';

                if fHaveSupplierCode then
                    qs := qs + SupplierWhereClause;
            end
            else
                continue;

            // -- Now execute the query to find the item
            if not ExecuteSQL(qryItemUpdate,qs) then
              Break;

            qryItemUpdate.Open;
            qryItemUpdate.First;

            // Check whether any records have been returned by checking for eof function   .The number
            // of records retunrd will be 0 or 1
            if qryItemUpdate.eof then
            begin

                qs := 'Insert into  ' + fItemOutputTableName + '( ';

                // -- Add all columns from the mapping table
                for xc := 0 to ItemOutputFieldMappings.Count-1 do
                begin
                    // -- Add all columns except novalue
                    if ItemOutputFieldMappings[xc] <> '%NOVALUE' then
                    begin
                        qs := qs + EncodeSQLFieldName(ItemOutputFieldNames[xc]) + ', ';
                    end;
                end;
                // -- Chop off the last comma
                qs := Copy(qs,1,Length(qs)-2);

                qs := qs + ') Values ' + '(';

                // -- Calculate all the column values the mapping table
                for xc := 0 to ItemOutputFieldMappings.Count-1 do
                begin
                    // -- Add all columns except novalue
                    s := ItemOutputFieldMappings[xc];

                    if s = PRICELIST_EXPORTMAP_PRODUCT_NAME then
                        qs := qs + EncodeSQLString(ItemProductName) + ', '
                    else if s = PRICELIST_EXPORTMAP_PRODUCT_CODE then
                        qs := qs + EncodeSQLString(ItemProductCode) + ', '
                    else if s <> '%NOVALUE' then
                        // -- Here is a big gap of functionality to add..
                        qs := qs + BuildFieldValue(xc,thisproduct) + ', ';
                end;
                // -- Chop off the last comma
                qs := Copy(qs,1,Length(qs)-2)+')';

                if UpdateFlag then
                    // Insert query will will be excuted only if user has asked for inserts}
                    // by selecting the check box Report and Updatees
                    if not ExecuteSQL(qryItemUpdate,qs) then
                      break;

                // -- Update the display counter
                IncDisplayNew;

                // -- Here we set the status of the item to NEW
                Pricelist.FlagCurrentItem(PL_ITEM_NEW);

            end

            // -- The table has a matching record & then comapare  Prices of ListView & table
            //    If the Prices do not match update the record of the table from listview
            else if PriceCompareField <> '' then
            begin
                CurrentDBPrice := qryItemUpdate.FieldByName(PriceCompareField).asFloat;

                PriceChanged := pricelistActualPrice <> CurrentDBPrice;

                if (pricelistActualPrice < CurrentDBPrice) then
                begin

                    Pricelist.FlagCurrentItem(PL_ITEM_RISEN);

                    // -- Price Up
                    IncDisplayRises;

                end
                else if (pricelistActualPrice > CurrentDBPrice) then
                begin

                    Pricelist.FlagCurrentItem(PL_ITEM_FALLEN);

                    // -- Price Down
                    IncDisplayFalls

                end
                else begin

                    Pricelist.FlagCurrentItem(PL_ITEM_STEADY);

                    // -- Price unchanged
                    IncDisplaySteady;

                end;

                if PriceChanged then
                begin

                    // --
                    if CheckingByProductCode then
                    begin
                        // -- Build the update query
                        qs := 'Update ' + fItemOutputTableName +
                              ' set ' + PriceCompareField + ' = ' + FloatToStr(pricelistActualPrice) +
                              ' where ' + EncodeSQLFieldName(CodeLookupColumn) + ' = ' + EncodeSQLString(ItemProductCode);
                    end
                    else if CheckingByProductName then
                    begin
                        // -- For each row of ListView  try to find a match based on Column Code from the table
                        // -- Build the update query
                        qs := 'Update ' + fItemOutputTableName +
                              ' set ' + PriceCompareField + ' = ' + FloatToStr(pricelistActualPrice) +
                              ' where ' + EncodeSQLFieldName(NameLookupColumn) + ' = ' + EncodeSQLString(ItemProductName);

                    end;
                    if UpdateFlag then
                        if not ExecuteSQL(qryItemUpdate,qs) then
                          break;

                end;
            end;

            // -- Every hundred records sleep for a bit
            if ((i mod 100)=0) then
                Application.ProcessMessages
            else if ((i mod 10)=0) then
                Sleep(100);

            barProgress.value := i;       //update the value of progreesbar
            Inc(i);
        end;

    finally
        if fShowProcessButton then
            btnProcess.Visible := True;
        btnCancel.Visible := False;
        thisProduct.Destroy;
    end;

  	barProgress.value := i;

    // -- It worked to here so now time to show some buttons
    btnShowSQL.Visible := True;
    btnShowData.Visible := True;

  	// -- Display the number of inserts & updates to memo compo   as a report
    ShowStatus('');
	  barProgress.Visible := False;

  	ReportMessage('Process completed');
	  if UpdateFlag then {//if user had selected to update records}
  	begin
	  	ReportMessage((IntToStr(txtNewCount.Tag) + ' Record(s) Added'));  //show log message for adding new records to  Access table   from Listview data
  		ReportMessage((IntToStr(txtRisesCount.Tag + txtFallsCount.Tag + txtChangedCount.Tag) + ' Record(s) Updated'));  //show log message for updating  records in  Access table   from Listview data
  		ReportMessage((IntToStr(txtSteadyCount.Tag) + ' Record(s) Steady'));  //show log message for updating  records in  Access table   from Listview data
      end
  	else //if user had not selected to update records
	  begin
  		ReportMessage((IntToStr(txtNewCount.Tag) + ' Record(s) to be Added  '));  //show log message for No of new records likely to be added to  Access table   from Listview data
	  	ReportMessage((IntToStr(txtRisesCount.Tag + txtFallsCount.Tag + txtChangedCount.Tag) + ' Record(s) to be Updated  '));  //show log message for No of records likely to be updated in  Access table   from Listview data
  		ReportMessage((IntToStr(txtSteadyCount.Tag) + ' Record(s) Steady  '));  //show log message for No of records likely to be updated in  Access table   from Listview data
	  end
end;
// ----------------------------------------------------------------------------
// -- for deleting a table.Presemtly this is not being called any where
procedure TGTDPricelistExportFrame.DropTempTable(Tablename: WideString);
var
  cs                : WideString;
begin
  cs := 'Drop TABLE ' + tableName;
  ExecuteSQL(qryItemUpdate,cs);
  cs := '';
end;
// ----------------------------------------------------------------------------
function TGTDPricelistExportFrame.CheckOutputTables(UpdateFlag : Boolean):Boolean;
var
  DataSource        : string;
  cs                : string;
  i, j              : integer;
  needToCreateTable : Boolean;
begin
    Result := False;

    if (dbType = PRICELIST_DBTYPE_ADO) then
    begin
        // -- If the database does not exist then create it
        if not FileExists(txtAccessdb) then
        begin
            if (UpdateFlag) then
            begin
                ReportMessage('Creating  ' + txtAccessdb);  //show log message for creting Access database
                createAccessDatabase(txtAccessdb)
            end
            else begin
                ReportMessage(txtAccessdb + 'doesn''t exist. Unable to continue');  //show log message for creting Access database
                Exit;
            end;
        end
        else
            ReportMessage('Using  ' + txtAccessdb);

        // -- Now connect to the database
        if not connectAccessDatabase(txtAccessdb) then
        begin
            ReportMessage('Unable to connect to database ' + txtAccessdb);
            Exit;
        end;
    end;

	// -- Create the product groups table
	needToCreateTable := not TableExistsInSelectedDataBase(fGroupOutputTableName);
	if needToCreateTable then
	begin
		ReportMessage('Creating ' + fGroupOutputTableName);  //show log message for creating new Access table
		CreateGroupTable(fGroupOutputTableName);
	end
	else
		ReportMessage('Using  ' + fGroupOutputTableName);  //show log message for displaying  existing Access table

	// -- Create the items table
	needToCreateTable := not TableExistsInSelectedDataBase(fItemOutputTableName);
	if needToCreateTable then
	begin
		ReportMessage('Creating ' + fItemOutputTableName);  //show log message for creating new Access table
		CreateItemsTable(fItemOutputTableName);
	end
	else
		ReportMessage('Using  ' + fItemOutputTableName);  //show log message for displaying  existing Access table

    Result := True;

end;

// ----------------------------------------------------------------------------
 //   Main Process
 //   Checks if enetered database & table exists & creates them if they do not exist & loads data into them from Listview
 //   Compares data of table with list view
 //   If user had selected to  update data ,updates data in table viz a viz Listview
 //   In all cases display suitable log message in the log window
procedure TGTDPricelistExportFrame.btnProcessClick(Sender: TObject);
begin
	Run;
end;
// ----------------------------------------------------------------------------
function TGTDPricelistExportFrame.ConnectAccessDatabase(databasename: wideString):Boolean;
var
    ConnectString : wideString;
begin
    Result := False;

    // -- Check that ADO is installed
    if GetADOVersion = -1 then
    begin
        ReportMessage('DAO Components aren''t installed - Cannot continue');
        Exit;
    end;

    // -- Build the ADO connection string
    ConnectString := 'Provider=Microsoft.Jet.OLEDB.4.0;' +
                     'Data Source=' + databasename +
                     ';Persist Security Info=false';

    // -- Check for older version of ADO
{    if GetADOVersion <= 2.5 then
    begin -- for now, only use Deersoft }
        try
            // -- Do it with Deersoft

            // -- Connect the deersoft database
            DeersoftDB.Connected := False;
            DeersoftDB.Connection := ConnectString;
            DeersoftDB.Connected := True;

            // -- Use this database object
            dbExport := TDatabase(DeersoftDB);
            qrySupplierUpdate := TQuery(DQrySuppliers);
            qryGroupUpdate := TQuery(DQryGroups);
            qryItemUpdate  := TQuery(DQryItems);

            Result := True;

        finally
        end;
{    end
    else begin
        // -- Do it with Zeos
        try
            if zDB.Connected then
                zDB.Disconnect;

            // -- Setup the database component
            zDB.Protocol := 'ado';
            ZDB.Database := DataSource;
            ZDB.Connected := true;

            Result := True;
        finally
        end;
    end;
}

end;
// ----------------------------------------------------------------------------
// -- comapare the list view & table
//    Update/Insert data into table based on user selction of the  Radio Boxes ie to Report & Update or
//    only report   .In acse of report total insert & updates will be displayed in the memo
//    If Rreport & Update the data will be updated &/or Inserted
procedure TGTDPricelistExportFrame.SetupProductFieldList;
begin

end;
// ----------------------------------------------------------------------------
procedure TGTDPricelistExportFrame.AddProduct(pcode, pdesc, price: string);
var
    anItem            : TListItem;
begin
    anItem := lsvItems.Items.Add;
    anItem.Caption := pcode;
    anItem.SubItems.Add(pdesc);
    anItem.SubItems.Add(price);
    anItem.SubItems.Add('');
    //added availalbilty as empty string since it was given before
end;
// ----------------------------------------------------------------------------
procedure TGTDPricelistExportFrame.ShowStatus(Msg: String);
begin
    lblProgress.Caption := Msg;
    lblProgress.Update;
end;
// ----------------------------------------------------------------------------
procedure TGTDPricelistExportFrame.ReportMessage(Msg: string);
begin
  mmoProgress.ReadOnly := false;
  mmoProgress.Lines.Append(Msg);
  mmoProgress.ReadOnly := true;
end;
// ----------------------------------------------------------------------------
//show datagrid/Hide data grid
//show log window/hide log window
procedure TGTDPricelistExportFrame.btnShowDataClick(Sender: TObject);
begin

  mmoProgress.Visible := not mmoProgress.Visible; // hide/show the log memo

   //Change the caption of the Button
  if btnShowData.Caption = 'Show Data' then
   btnShowData.Caption := 'Hide Data'
  else
	btnShowData.Caption := 'Show Data';

  barProgress.visible := false;         //hide the progressbar

end;
// ----------------------------------------------------------------------------
procedure TGTDPricelistExportFrame.lstProdGroupsDblClick(Sender: TObject);
begin
	if Assigned(lstProdGroups.Selected) then
	begin
		if lstProdGroups.Selected.StateIndex <> 3 then
			lstProdGroups.Selected.StateIndex := 3
		else
			lstProdGroups.Selected.StateIndex := 4;
	end;
end;
// ----------------------------------------------------------------------------
procedure TGTDPricelistExportFrame.ClearSupplierMappings;
begin
	SupplierOutputFieldNames.Clear;
	SupplierOutputFieldMappings.Clear;
	SupplierOutputFieldTypes.Clear;
end;
// ----------------------------------------------------------------------------
procedure TGTDPricelistExportFrame.AddSupplierFieldMapping(DatabaseFieldName, PricelistFieldName, SQLFieldFormat : String);
begin
	SupplierOutputFieldNames.Add(DatabaseFieldName);
	SupplierOutputFieldMappings.Add(PricelistFieldName);
    SupplierOutputFieldTypes.Add(SQLFieldFormat);
end;
// ----------------------------------------------------------------------------
procedure TGTDPricelistExportFrame.ClearGroupMappings;
begin
	GroupOutputFieldNames.Clear;
	GroupOutputFieldMappings.Clear;
	GroupOutputFieldTypes.Clear;
end;
// ----------------------------------------------------------------------------
procedure TGTDPricelistExportFrame.AddGroupFieldMapping(DatabaseFieldName, PricelistFieldName, SQLFieldFormat : String);
begin
	GroupOutputFieldNames.Add(DatabaseFieldName);
	GroupOutputFieldMappings.Add(PricelistFieldName);
    GroupOutputFieldTypes.Add(SQLFieldFormat);
end;
// ----------------------------------------------------------------------------
procedure TGTDPricelistExportFrame.ClearItemMappings;
begin
	ItemOutputFieldNames.Clear;
	ItemOutputFieldMappings.Clear;
    ItemOutputFieldTypes.Clear;
end;

// ----------------------------------------------------------------------------
// -- Some examples
// Constants
//		=&"Hello there"         String constant
//      =#25                    Integer constant
//      =?True                  Logical Constant
//
// Functions/Virtual Fields
//
//		%NOVALUE                No value, don't add, used for counters
//		%NEW_ROWID=GENERATOR    Generated ROWID
//      %CATEGORY_NAME          Name of the Category
//      %CATEGORY_PATH          Path of the Category ie 'Parts/Powered'
//		%CATEGORY_FIELD=FLDNAME A field value from the Category table
//      %TRADER_FIELD=FLDNAME   A field value from the Trader Table
//		%SUPPLIER_CODE          The Supplier Account code
//		%TRADER_ID              Trader_ID field from Trader Table
//		%TRADER_NAME            Trader_Name field from Trader Table
//
// Pricelist Fields
//
//		Add('@Thumbnail_Image');
//		Add('@Fullsize_Image');
//		Add('@Name');
//
// ----------------------------------------------------------------------------
procedure TGTDPricelistExportFrame.AddItemFieldMapping(DatabaseFieldName, PricelistFieldName, SQLFieldFormat : String);
begin
	ItemOutputFieldNames.Add(DatabaseFieldName);
	ItemOutputFieldMappings.Add(PricelistFieldName);
    ItemOutputFieldTypes.Add(SQLFieldFormat);
end;
// ----------------------------------------------------------------------------
procedure TGTDPricelistExportFrame.ClearItems;
begin
    lsvItems.Items.Clear;
end;
// ----------------------------------------------------------------------------
function TGTDPricelistExportFrame.LoadAllSelectedGroups:Boolean;
var
    i : Integer;
    catName,gc : WideString;
begin

    ClearItems;

	// -- loop through the product Groups
	with lstProdGroups.Items do
	begin
		for i := 0 to Count - 1 do
		begin
			// -- Get the category name
			catName := Item[i].Text;

            // -- Calculate the group cursors
            gc := GTD_PL_PRODUCTINFO_NODE + GTD_PL_PRODUCTGROUP_NODE + '[' + IntToStr(i+1) + ']';

            if lstProdGroups.Items[i].StateIndex = 3 then
                LoadItemsFromGroup(gc,i+1);

        end;
    end;
end;
// ----------------------------------------------------------------------------
function TGTDPricelistExportFrame.LoadItemsFromGroup(NodePath : WideString; CategoryIndex : Integer):Boolean;
var
	ProductNode,
    GroupNode   : GTDNode;
    L           : WideString;
    xc          : Integer;
    newItem     : TListItem;
begin
	GroupNode := GTDNode.Create;

    // -- Load up the entire product group
    if not GroupNode.LoadFromDocument(Pricelist,NodePath,false) then
    begin
        GroupNode.Destroy;
        Exit;
    end;

	ProductNode := GTDNode.Create;

    try
		// -- Extract each product item from the group
		while ProductNode.ExtractTaggedSection(GTD_PL_PRODUCTITEM_TAG,GroupNode) do
		begin
            // -- Add Extractable fields
            newItem := lsvItems.Items.Add;

            newItem.Caption := ProductNode.ReadStringField(GTD_PL_ELE_PRODUCT_CODE);
            newItem.SubItems.Add(ProductNode.ReadStringField(GTD_PL_ELE_PRODUCT_NAME));
            newItem.SubItems.Add(ProductNode.ReadStringField(GTD_PL_ELE_PRODUCT_ACTUAL));
            newItem.SubItems.Add(ProductNode.ReadStringField(GTD_PL_ELE_PRODUCT_LIST));
            newItem.SubItems.Add(''); // ProductNode.ReadStringField(GTD_PL_ELE_PRODUCT_TAX));

			// -- Here we are going to add all the record data in for later retrieval
			L := '';
			// -- Add all lines into one line
			for xc := 1 to ProductNode.MsgLines.Count do
				L := L + ProductNode.MsgLines[xc-1] + #13;
            newItem.SubItems.Add(L);

            // -- Also add in the cateogry
            newItem.SubItems.Add(IntToStr(CategoryIndex));

        end;
    finally
        ProductNode.Destroy;
        GroupNode.Destroy;
    end;
end;
// ----------------------------------------------------------------------------
procedure TGTDPricelistExportFrame.btnNext1Click(Sender: TObject);
begin
end;
// ----------------------------------------------------------------------------
procedure TGTDPricelistExportFrame.pgRunShow(Sender: TObject);
begin
    // -- Clear stuff when the display page gets shown
    btnShowSQL.Visible := False;
    btnShowData.Visible := False;
    ClearDisplayCounters;

    with mmoProgress.Lines do
    begin
        Clear;
        Add('We are now ready to apply the prices in');
        Add('the pricelist to the database.');
        Add('');
        Add('Press [Process] to continue..');
    end;

end;
// ----------------------------------------------------------------------------
function TGTDPricelistExportFrame.Run: Boolean;
begin
  // -- Load up the configuration
  LoadSystemExportMap;

  // -- check if database & table exists.If yes display them else create them,load data from list view & then display them
  if not CheckOutputTables(UpdateFlag) then
        Exit;

  barProgress.Visible := True;          //show the progressbar

  try

      Screen.Cursor := crHourglass;
      btnCancel.Visible := True;

      mmoProgress.Lines.Clear;
      mmoSQL.Lines.Clear;

      // -- call the procedue for comapring,insertin,Updating & generating report
      UpdateSuppliers(UpdateFlag);
      UpdateGroups(UpdateFlag);
      UpdateItems(UpdateFlag);

      Result := True;

  finally
      btnCancel.Visible := False;
      Screen.Cursor := crDefault;
  end;

end;
// ----------------------------------------------------------------------------
//
function TGTDPricelistExportFrame.ExportToTSF(filename : String; pGauge : TbsSkinGauge): Boolean;
var
    xc,pstep : Integer;
    thisproduct : GTDNode;
    myfile : TStringList;
    pid,pname,pbuy,tabc,l,f : String;
begin
    thisproduct := GTDNode.Create;

    myfile := TStringList.Create;

    Pricelist.StartItemIterator;

    barProgress.MaxValue := Pricelist.ItemList.count;

    try
        Screen.Cursor := crHourglass;

        // -- Setup the tab character
        tabc := Chr(9);

        // -- These columns are hardwired for the moment. This should be
        //    changed to read from the output mappings list. It is already
        //    there so it shouldn't be too hard.
        myfile.Add(GTD_PL_ELE_PRODUCT_CODE + tabc +
                   GTD_PL_ELE_PRODUCT_NAME + tabc +
                   GTD_PL_ELE_PRODUCT_ACTUAL);

        // -- Iterate through all items
        while Pricelist.NextItemIteration(thisproduct) do
        begin

            if Assigned(pGauge) then
            begin
                pGauge.Visible := True;
                pGauge.MaxValue := pricelist.ItemList.Count + 20;
                pstep := lsvItems.Items.Count div 20;
            end;

            // -- Build all the column values the mapping table
//            l := '';
//            for xc := 0 to ItemOutputFieldMappings.Count-1 do
//            begin
                // -- Add all columns except novalue
//                f := ItemOutputFieldMappings[xc];

//                if f <> '%NOVALUE' then
                    // -- Here is a big gap of functionality to add..
//                    l := l + BuildFieldValue(xc,thisproduct) + tabc;
//            end;

            // -- Read out these fields
            pid     := thisproduct.ReadStringField(GTD_PL_ELE_PRODUCT_CODE);
            pname   := thisproduct.ReadStringField(GTD_PL_ELE_PRODUCT_NAME);
            pbuy    := thisproduct.ReadStringField(GTD_PL_ELE_PRODUCT_ACTUAL);
            if (pbuy = '') then
                pbuy := thisproduct.ReadStringField(GTD_PL_ELE_PRODUCT_LIST);

            // -- Add in the values
            myfile.Add(pid + tabc +
                       pname + tabc +
                       pbuy);

            // -- Update the progress
            if Assigned(pGauge) then
            begin
                pGauge.Value := pGauge.Value + 1;
                pGauge.Update;
            end;
        end;

        myfile.SaveToFile(filename);

        {
        GTD_PL_ELE_PRODUCT_DESC     = 'Description';
        GTD_PL_ELE_PRODUCT_KEYWORDS = 'Keywords';
        GTD_PL_ELE_PRODUCT_LIST     = 'List_Price';
        GTD_PL_ELE_PRODUCT_TAXR     = 'Tax_Rate';
        GTD_PL_ELE_PRODUCT_TAXT     = 'Tax_Type';
        }
    finally
        myfile.Destroy;
        thisproduct.Destroy;

        if Assigned(pGauge) then
        begin
            pGauge.Value := 0;
            pGauge.Visible := False;
        end;

        Screen.Cursor := crDefault;
    end;

end;
// ----------------------------------------------------------------------------
function TGTDPricelistExportFrame.ExportToCSV: Boolean;
begin
end;
// ----------------------------------------------------------------------------
procedure TGTDPricelistExportFrame.SetADOOutput(MDBFileName : String);
begin
    // -- Setup the database type
    dbType := PRICELIST_DBTYPE_ADO;
    txtAccessdb := MDBFileName;
end;

// ----------------------------------------------------------------------------
procedure TGTDPricelistExportFrame.ClearDisplayCounters;
begin
    txtRisesCount.Caption := '0';
    txtRisesCount.Tag := 0;
    txtRisesCount.Font.Color := clWhite;
    txtRisesCount.Update;

    txtFallsCount.Caption := '0';
    txtFallsCount.Tag := 0;
    txtFallsCount.Font.Color := clWhite;
    txtFallsCount.Update;

    txtSteadyCount.Caption := '0';
    txtSteadyCount.Tag := 0;
    txtSteadyCount.Font.Color := clWhite;
    txtSteadyCount.Update;

    txtNewCount.Caption := '0';
    txtNewCount.Tag := 0;
    txtNewCount.Font.Color := clWhite;
    txtNewCount.Update;

    txtRemovedCount.Caption := '0';
    txtRemovedCount.Tag := 0;
    txtRemovedCount.Font.Color := clWhite;
    txtRemovedCount.Update;

    txtChangedCount.Caption := '0';
    txtChangedCount.Tag := 0;
    txtChangedCount.Font.Color := clWhite;
    txtChangedCount.Update;
end;
// ----------------------------------------------------------------------------
procedure TGTDPricelistExportFrame.IncDisplayRises;
begin
    // -- We increment the tag, then convert it to string. Faster than
    //    converting the text to int, incrementing it and back
    txtRisesCount.Tag := txtRisesCount.Tag + 1;
    if (txtRisesCount.Tag = 1) then
        txtRisesCount.Font.Color := clBlack;
    txtRisesCount.Caption := IntToStr(txtRisesCount.Tag);
    txtRisesCount.Update;
end;
// ----------------------------------------------------------------------------
procedure TGTDPricelistExportFrame.IncDisplayFalls;
begin
    txtFallsCount.Tag := txtFallsCount.Tag + 1;
    if (txtFallsCount.Tag = 1) then
        txtFallsCount.Font.Color := clBlack;

    txtFallsCount.Caption := IntToStr(txtFallsCount.Tag);
    txtFallsCount.Update;
end;
// ----------------------------------------------------------------------------
procedure TGTDPricelistExportFrame.IncDisplaySteady;
begin
    txtSteadyCount.Tag := txtSteadyCount.Tag + 1;
    if (txtSteadyCount.Tag = 1) then
        txtSteadyCount.Font.Color := clBlack;
    txtSteadyCount.Caption := IntToStr(txtSteadyCount.Tag);
    txtSteadyCount.Update;
end;
// ----------------------------------------------------------------------------
procedure TGTDPricelistExportFrame.IncDisplayNew;
begin
    txtNewCount.Tag := txtNewCount.Tag + 1;
    if (txtNewCount.Tag = 1) then
        txtNewCount.Font.Color := clBlack;
    txtNewCount.Caption := IntToStr(txtNewCount.Tag);
    txtNewCount.Update;
end;
// ----------------------------------------------------------------------------
procedure TGTDPricelistExportFrame.IncDisplayRemovals;
begin
    txtRemovedCount.Tag := txtRemovedCount.Tag + 1;
    if (txtRemovedCount.Tag = 1) then
        txtRemovedCount.Font.Color := clBlack;
    txtRemovedCount.Caption := IntToStr(txtRemovedCount.Tag);
    txtRemovedCount.Update;
end;
// ----------------------------------------------------------------------------
procedure TGTDPricelistExportFrame.IncDisplayDetails;
begin
    txtChangedCount.Tag := txtChangedCount.Tag;
    if (txtChangedCount.Tag = 1) then
        txtChangedCount.Font.Color := clBlack;
    txtChangedCount.Caption := IntToStr(txtChangedCount.Tag);
    txtChangedCount.Update;
end;
// ----------------------------------------------------------------------------
function TGTDPricelistExportFrame.GetPriceRisesCount:Integer;
begin
    Result := txtRisesCount.Tag;
end;
// ----------------------------------------------------------------------------
function TGTDPricelistExportFrame.GetPriceFallsCount:Integer;
begin
    Result := txtFallsCount.Tag;
end;
// ----------------------------------------------------------------------------
function TGTDPricelistExportFrame.GetPricesSteadyCount:Integer;
begin
    Result := txtSteadyCount.Tag;
end;
// ----------------------------------------------------------------------------
function TGTDPricelistExportFrame.GetNewProductsCount:Integer;
begin
    Result := txtNewCount.Tag;
end;
// ----------------------------------------------------------------------------
function TGTDPricelistExportFrame.GetRemovedProductsCount:Integer;
begin
    Result := txtRemovedCount.Tag
end;
// ----------------------------------------------------------------------------
function TGTDPricelistExportFrame.GetChangedDetailsCount:Integer;
begin
    Result := txtChangedCount.Tag;
end;
// ----------------------------------------------------------------------------
procedure TGTDPricelistExportFrame.btnShowSQLClick(
  Sender: TObject);
begin
    if mmoSQL.Visible then
    begin
        mmoSQL.Visible := False;
    end
    else begin
        mmoSQL.Visible := True;
        mmoSQL.BringToFront;
    end;
end;

// -- Load all items into the list for a given status
procedure TGTDPricelistExportFrame.LoadItems(ItemStatusFlag : Integer);
var
    thisProduct : GTDNode;
    anItem : TListItem;
    ItemProductCode,ItemProductName : String;
    pricelistActualPrice : Double;
begin

    thisProduct := GTDNode.Create;

    // -- Here we restart the iterator because we want to use prior values
    Pricelist.ReStartItemIterator;

    lsvItems.Items.Clear;

    // -- Hide this so that the user can see the data
    if mmoProgress.Visible then
        mmoProgress.Visible := False;

    try

        Screen.Cursor := crHourglass;

        // -- For every product
        while Pricelist.NextItemIteration(thisproduct) do
        begin

            if (Pricelist.GetCurrentItemFlag = ItemStatusFlag) then
            begin

                // -- May as well load these up they will be used in
                //    lots of places
                ItemProductCode := thisProduct.ReadStringField(GTD_PL_ELE_PRODUCT_CODE);
                ItemProductName := thisProduct.ReadStringField(GTD_PL_ELE_PRODUCT_NAME);
                pricelistActualPrice := thisProduct.ReadNumberField(GTD_PL_ELE_PRODUCT_ACTUAL,0);;

                // -- Create the item in the list
                anItem := lsvItems.Items.Add;
                anItem.Caption := ItemProductCode;
                anItem.SubItems.Add(ItemProductName);
                anItem.SubItems.Add(FloatToStr(pricelistActualPrice));

            end;

        end;

    finally
        Screen.Cursor := crDefault;
        thisProduct.Destroy;
    end;
end;

procedure TGTDPricelistExportFrame.imgRisesClick(Sender: TObject);
begin
    // -- Load and display all the items that have risen in price
    LoadItems(PL_ITEM_RISEN);
end;

procedure TGTDPricelistExportFrame.ImgFallsClick(Sender: TObject);
begin
    // -- Load and display all the items that have risen in price
    LoadItems(PL_ITEM_FALLEN);
end;

procedure TGTDPricelistExportFrame.imgSteadyClick(Sender: TObject);
begin
    LoadItems(PL_ITEM_STEADY);
end;

procedure TGTDPricelistExportFrame.imgNewClick(Sender: TObject);
begin
    LoadItems(PL_ITEM_NEW);
end;

procedure TGTDPricelistExportFrame.imgRemovedClick(Sender: TObject);
begin
    LoadItems(PL_ITEM_REMOVED);
end;

procedure TGTDPricelistExportFrame.imgDetailsClick(Sender: TObject);
begin
    LoadItems(PL_ITEM_DETAILS);
end;

procedure TGTDPricelistExportFrame.SetProcessButtonVisible(ShowIt : Boolean);
begin
    // -- Here we do some resizing
    if ShowIt then
    begin
        // --
        mmoProgress.Height := 137;
    end
    else begin
        mmoProgress.Height := 177;
    end;

    mmoSQL.Height := mmoProgress.Height;
    lsvItems.Height := mmoProgress.Height;
    
end;

procedure TGTDPricelistExportFrame.btnCancelClick(Sender: TObject);
begin
    fKeepRunning := False;
    ReportMessage('User Cancelling update run');
end;

end.

