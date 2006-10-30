program PriceSharer;

uses
  Forms,
  Main in 'Main.pas' {frmMain},
  Data in 'Data.pas' {DataModule1: TDataModule},
  Accounts in 'Accounts.pas' {frmAccounts},
  Settings in 'Settings.pas' {frmSettings},
  CustomerLinks in '..\..\Components\CustomerLinks.pas',
  Search in 'Search.pas' {frmSearch},
  GTDProductDBSearch in '..\..\Components\GTDProductDBSearch.pas' {ProductdB: TFrame},
  NetworkSearches in 'NetworkSearches.pas' {frmNetworkSearches},
  GTDSearchTextHandler in '..\..\Components\GTDSearchTextHandler.pas' {SearchTextHandler: TFrame},
  ProductEdit in 'ProductEdit.pas' {frmProductEdit},
  AddProductGroup in 'AddProductGroup.pas' {frmAddProductGroup},
  GTDBizDocs in '..\..\Components\GTDBizDocs.pas',
  ProductLister in '..\..\Components\ProductLister.pas',
  CustomerAdd in 'CustomerAdd.pas' {frmCustomerAdd},
  SpreadSheetImport in 'SpreadSheetImport.pas' {frmSpreadSheetImport},
  GTDXLSPriceReader in '..\..\Components\GTDXLSPriceReader.pas' {GTDXLStoPL: TFrame},
  GenPricelists in 'GenPricelists.pas' {frmGeneratePL},
  NewsLetter in 'NewsLetter.pas' {frmNewsletter},
  GTDBuildPricelistFromDBRun in '..\..\Components\GTDBuildPricelistFromDBRun.pas' {BuildPricelistFromDBRun: TFrame},
  BuildDBPricelist in 'BuildDBPricelist.pas' {frmBuildDBPricelist};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmProductEdit, frmProductEdit);
  Application.CreateForm(TfrmAddProductGroup, frmAddProductGroup);
  Application.CreateForm(TfrmCustomerAdd, frmCustomerAdd);
  Application.CreateForm(TfrmNewsletter, frmNewsletter);
  Application.CreateForm(TfrmBuildDBPricelist, frmBuildDBPricelist);
  Application.Run;
end.
