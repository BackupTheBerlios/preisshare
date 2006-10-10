unit Search;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  BusinessSkinForm,GTDProductDBSearch, bsSkinCtrls, StdCtrls;

type
  TfrmSearch = class(TForm)
    bsBusinessSkinForm1: TbsBusinessSkinForm;
    bsSkinButton1: TbsSkinButton;
    procedure FormCreate(Sender: TObject);
    procedure bsSkinButton1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    productDB : TProductdBSearch;
  end;

var
  frmSearch: TfrmSearch;

implementation

{$R *.DFM}
uses Main;

procedure TfrmSearch.FormCreate(Sender: TObject);
begin

    bsBusinessSkinForm1.SkinData := frmMain.bsSkinData1;

    bsSkinButton1.SkinData := bsBusinessSkinForm1.SkinData;

    productDB := TProductdBSearch.Create(Self);
    with productDB do
    begin
        Parent := Self;
        Top := 80;
        Left := 10;
        Visible := True;
        SendToBack;
        SkinData := bsBusinessSkinForm1.SkinData;
    //    productDB.dqryFindProducts.Connection := frmMain.dbProductDB.Connection;
    end;

end;

procedure TfrmSearch.bsSkinButton1Click(Sender: TObject);
begin
    Close;
end;

procedure TfrmSearch.FormActivate(Sender: TObject);
begin
    If Assigned(productDB) then
    begin
        productDB.txtSearchText.SetFocus;
    end;
end;

end.
