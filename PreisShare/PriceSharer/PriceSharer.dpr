program PriceSharer;

uses
  Forms,
  Main in 'Main.pas' {frmMain},
  Data in 'Data.pas' {DataModule1: TDataModule},
  Accounts in 'Accounts.pas' {frmAccounts},
  Settings in 'Settings.pas' {frmSettings},
  Search in 'Search.pas' {frmSearch},
  NetworkSearches in 'NetworkSearches.pas' {frmNetworkSearches},
  ProductEdit in 'ProductEdit.pas' {frmProductEdit},
  AddProductGroup in 'AddProductGroup.pas' {frmAddProductGroup},
  CustomerAdd in 'CustomerAdd.pas' {frmCustomerAdd},
  SpreadSheetImport in 'SpreadSheetImport.pas' {frmSpreadSheetImport},
  GenPricelists in 'GenPricelists.pas' {frmGeneratePL},
  NewsLetter in 'NewsLetter.pas' {frmNewsletter},
  BuildDBPricelist in 'BuildDBPricelist.pas' {frmBuildDBPricelist},
  Config in 'Config.pas' {frmConfig},
  GTDBuildPricelistFromDBConfig in '..\Components\GTDBuildPricelistFromDBConfig.pas' {BuildPricelistFromDBConfig: TFrame},
  GTDSearchTextHandler in '..\Components\GTDSearchTextHandler.pas' {SearchTextHandler: TFrame},
  GTDBizDocs in '..\Components\GTDBizDocs.pas',
  GTDBuildPricelistFromDBRun in '..\Components\GTDBuildPricelistFromDBRun.pas' {BuildPricelistFromDBRun: TFrame},
  GTDPricelists in '..\Components\GTDPricelists.pas',
  GTDXLSPriceReader in '..\Components\GTDXLSPriceReader.pas' {GTDXLStoPL: TFrame},
  ProductLister in '..\Components\ProductLister.pas',
  vteExcel in '..\Components\vtkexp\Source\vteExcel.pas',
  PricelistGenerate in '..\Components\PricelistGenerate.pas' {PricelistGenerator: TFrame},
  LogView in 'LogView.pas' {frmLogView},
  RelayEditor in 'RelayEditor.pas' {frmRelay},
  DataFeedEditor in 'DataFeedEditor.pas' {frmDataFeeds},
  GTDCollectSupplierPricelists in '..\Components\GTDCollectSupplierPricelists.pas' {Frame1: TFrame};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmProductEdit, frmProductEdit);
  Application.CreateForm(TfrmAddProductGroup, frmAddProductGroup);
  Application.CreateForm(TfrmCustomerAdd, frmCustomerAdd);
  Application.CreateForm(TfrmNewsletter, frmNewsletter);
  Application.CreateForm(TfrmBuildDBPricelist, frmBuildDBPricelist);
  Application.CreateForm(TfrmConfig, frmConfig);
  Application.CreateForm(TfrmLogView, frmLogView);
  Application.CreateForm(TfrmRelay, frmRelay);
  Application.CreateForm(TfrmDataFeeds, frmDataFeeds);
  Application.Run;
end.
