unit DataFeedEditor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, bsSkinCtrls, ComCtrls, BusinessSkinForm;

type
  TfrmDataFeeds = class(TForm)
    bsBusinessSkinForm1: TbsBusinessSkinForm;
    lsvParams: TbsSkinListView;
    btnClose: TbsSkinButton;
    procedure FormCreate(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmDataFeeds: TfrmDataFeeds;

implementation
uses Main;

{$R *.dfm}

procedure TfrmDataFeeds.FormCreate(Sender: TObject);
begin
  bsBusinessSkinForm1.SkinData := frmMain.bsSkinData1;
  otlFeeds.SkinData := frmMain.bsSkinData1;
  lsvParams.SkinData := frmMain.bsSkinData1;
  btnClose.SkinData := frmMain.bsSkinData1;

  
end;

procedure TfrmDataFeeds.btnCloseClick(Sender: TObject);
begin
  Close;
  
end;

end.
