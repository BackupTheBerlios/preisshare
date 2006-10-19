unit SpreadSheetImport;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  GTDXLSPriceReader, bsSkinCtrls, BusinessSkinForm;

type
  TfrmSpreadSheetImport = class(TForm)
    bsBusinessSkinForm1: TbsBusinessSkinForm;
    btnOk: TbsSkinButton;
    btnClose: TbsSkinButton;
    pnlNoOffice: TbsSkinGroupBox;
    bsSkinTextLabel1: TbsSkinTextLabel;
    bsSkinTextLabel2: TbsSkinTextLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }

  public
    { Public declarations }
    myReader : TGTDXLStoPL;
  end;

var
  frmSpreadSheetImport: TfrmSpreadSheetImport;

implementation

{$R *.DFM}
uses Main;

procedure TfrmSpreadSheetImport.FormCreate(Sender: TObject);
begin
    myReader := TGTDXLStoPL.Create(Self);

    with myReader do
    begin
        Top := 10;
        Left := 10;
        Parent := Self;
        Visible := True;
        SkinData := bsBusinessSkinForm1.SkinData;
        DocRegistry := frmMain.DocRegistry;
        BringToFront;
    end;

    btnOk.Top := myReader.Top + myReader.Height + 15;
    btnClose.Top := btnOk.Top;

    Height := btnOk.Top + 80;

end;

end.
