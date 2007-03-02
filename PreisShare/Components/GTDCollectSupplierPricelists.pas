unit GTDCollectSupplierPricelists;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, ComCtrls, bsSkinCtrls, StdCtrls, bsSkinBoxCtrls, HttpProt,
  bsMessages,bsSkinData, bsSkinMenus, Menus, bsDialogs, Mask;
type
  TCollectPricelistFrame = class(TFrame)
    HttpCli1: THttpCli;
    pnlBackground: TbsSkinPanel;
    btnAdd: TbsSkinSpeedButton;
    btnRun: TbsSkinSpeedButton;
    otlFeeds: TbsSkinTreeView;
    Memo1: TbsSkinMemo2;
    barProgress: TbsSkinGauge;
    lblProgress: TbsSkinStdLabel;
    bsSkinPopupMenu1: TbsSkinPopupMenu;
    AddURL1: TMenuItem;
    dlgURL: TbsSkinInputDialog;
    pnlFeedSettings: TbsSkinGroupBox;
    btnSave: TbsSkinButton;
    bsSkinLabel1: TbsSkinLabel;
    bsSkinEdit1: TbsSkinEdit;
    procedure HttpCli1DocData(Sender: TObject; Buffer: Pointer;
      Len: Integer);
    procedure btnRunClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    fSkinData   : TbsSkinData;

    procedure SetSkinData(newSkin : TbsSkinData);

  published

    property SkinData : TbsSkinData read fSkinData write SetSkinData;
  end;

implementation

{$R *.dfm}

procedure TCollectPricelistFrame.HttpCli1DocData(Sender: TObject;
  Buffer: Pointer; Len: Integer);
var
  s : String;
  xc : Integer;
  p : PChar;
begin
  p := PChar(Buffer);
  for xc := 1 to Len do
  begin
    s := s + p^;
    Inc(p);
  end;
  Memo1.Lines.Append(s);

end;

procedure TCollectPricelistFrame.btnRunClick(Sender: TObject);
begin
//  HttpCli1.Url := 'http://www.i-tech.com.au/Products.xml';
  HttpCli1.Url := 'http://www.i-tech.com.au/Products.csv';
  HttpCli1.GetAsync;
end;

procedure TCollectPricelistFrame.SetSkinData(newSkin : TbsSkinData);
begin
  pnlBackGround.SkinData := newSkin;
  btnAdd.SkinData := newSkin;
  btnRun.SkinData := newSkin;
  otlFeeds.SkinData := newSkin;
  Memo1.SkinData := newSkin;
  lblProgress.SkinData := newSkin;
  barProgress.SkinData := newSkin;
  dlgURL.SkinData := newSkin;
  dlgURL.CtrlSkinData := newSkin;
  pnlFeedSettings.SkinData := newSkin;
end;

procedure TCollectPricelistFrame.btnAddClick(Sender: TObject);
begin
  pnlFeedSettings.Visible := True;
end;

end.
