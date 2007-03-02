unit RelayEditor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BusinessSkinForm, GTDBizDocs, SynEditHighlighter,
  SynHighlighterPas, SynEdit, SynMemo, bsSkinCtrls;

type
  TfrmRelay = class(TForm)
    bsBusinessSkinForm1: TbsBusinessSkinForm;
    mmoRelay: TSynMemo;
    SynPasSyn1: TSynPasSyn;
    btnClose: TbsSkinButton;
    btnSave: TbsSkinSpeedButton;
    btnCompile: TbsSkinSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmRelay: TfrmRelay;

implementation

{$R *.dfm}
uses Main;

procedure TfrmRelay.FormCreate(Sender: TObject);
begin
  bsBusinessSkinForm1.SkinData := frmMain.bsSkinData1;
  btnClose.SkinData := frmMain.bsSkinData1;
  btnSave.SkinData := frmMain.bsSkinData1;
  btnCompile.SkinData := frmMain.bsSkinData1;

  // -- If the relay file exists, then load it
  if FileExists(GTD_RELAYCALCSFILE) then
  begin
    mmoRelay.Lines.LoadFromFile(GTD_RELAYCALCSFILE);
  end
  else begin
    mmoRelay.Lines.Clear;
    mmoRelay.Lines.Add('function Calc_Actual_IncTax(CostPrice : Float): Float;');
    mmoRelay.Lines.Add('begin');
    mmoRelay.Lines.Add('  Result := 1.25 * CostPrice;');
    mmoRelay.Lines.Add('end;');
  end;

end;

procedure TfrmRelay.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmRelay.btnSaveClick(Sender: TObject);
begin
  mmoRelay.Lines.SaveToFile(GTD_RELAYCALCSFILE);
end;

end.
