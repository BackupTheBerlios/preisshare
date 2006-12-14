program plgSearch;

uses
  Forms,
  Main in 'Main.pas' {frmMain},
  GTDProductDBSearch in '..\..\Components\GTDProductDBSearch.pas' {ProductdB: TFrame},
  SpreadSheetImport in 'SpreadSheetImport.pas' {frmSpreadSheetImport},
  GTDXLSPriceReader in '..\..\Components\GTDXLSPriceReader.pas' {GTDXLStoPL: TFrame},
  GTDProductDBUpdate in '..\..\Components\GTDProductDBUpdate.pas' {GTDProductDBUpdateFrame: TFrame},
  GTDBizDocs in '..\..\Components\GTDBizDocs.pas',
  PricelistExport in '..\..\Components\PricelistExport.pas' {GTDPricelistExportFrame: TFrame},
  GTDProductDBUpdateParams in '..\..\Components\GTDProductDBUpdateParams.pas' {Frame1: TFrame},
  GTDTextToPricefile in '..\..\Components\GTDTextToPricefile.pas',
  GTDTraderSelectPanel in '..\..\Components\GTDTraderSelectPanel.pas' {pnlTraderGet: TFrame},
  GTDPricelists in '..\..\Components\GTDPricelists.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'PreisShare Search';
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
