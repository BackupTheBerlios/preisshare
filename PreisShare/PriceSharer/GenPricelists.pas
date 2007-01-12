unit GenPricelists;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  BusinessSkinForm,PricelistGenerate, bsSkinCtrls;

type
  TfrmGeneratePL = class(TForm)
    bsBusinessSkinForm1: TbsBusinessSkinForm;
    btnClose: TbsSkinButton;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    myList : TPricelistGenerator;
  end;

var
  frmGeneratePL: TfrmGeneratePL;

implementation

{$R *.DFM}
uses Main;

procedure TfrmGeneratePL.FormCreate(Sender: TObject);
begin
    bsBusinessSkinForm1.SkinData := frmMain.bsSkinData1;
    btnClose.SkinData := frmMain.bsSkinData1;

    myList := TPricelistGenerator.Create(Self);

    with myList do
    begin
        Top := 10;
        Left := 10;
        Parent := Self;
        Visible := True;
        SkinData := bsBusinessSkinForm1.SkinData;
        DocRegistry := frmMain.DocRegistry;
        Init;
        SendToBack;
    end;

end;

end.
