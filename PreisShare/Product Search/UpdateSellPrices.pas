unit UpdateSellPrices;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, bsSkinCtrls, BusinessSkinForm, bsSkinBoxCtrls, DB, ADODB;

type
  TfrmUpdateSellPrices = class(TForm)
    bsBusinessSkinForm1: TbsBusinessSkinForm;
    bsSkinGroupBox1: TbsSkinGroupBox;
    btnOk: TbsSkinButton;
    btnCancel: TbsSkinButton;
    rdoColumnSelect: TbsSkinRadioGroup;
    bsSkinLabel1: TbsSkinLabel;
    bsSkinSpinEdit1: TbsSkinSpinEdit;
    lstSupplierList: TbsSkinCheckListBox;
    lblSupplierList: TbsSkinLabel;
    QryDoUpdates: TADOQuery;
    procedure FormCreate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmUpdateSellPrices: TfrmUpdateSellPrices;

implementation

uses Main;

const
    PLU_Col = 'VendorProductID';
    PName_Col = 'ProductName';
    PDesc_Col = 'ProductDescription';
    PCostPrice = 'OurBuyingPrice';
    PSellPrice = 'OurSellingPrice';
    PProdTblName = 'Products';
    PBrandTblName = 'Brands';
    PBrandBrandName = 'Brand_Name';
    PSupplierTblName = 'Suppliers';
    PSupplierIDCol = 'SupplierID';
    PSupplierNameCol = 'CompanyName';

{$R *.dfm}

procedure TfrmUpdateSellPrices.FormCreate(Sender: TObject);
begin
  // -- Do some initialisation with the skins
  bsBusinessSkinForm1.SkinData := frmMain.bsSkinData1;
  rdoColumnSelect.SkinData := frmMain.bsSkinData1;
  bsSkinGroupBox1.SkinData := frmMain.bsSkinData1;
  bsSkinLabel1.SkinData := frmMain.bsSkinData1;
  bsSkinSpinEdit1.SkinData := frmMain.bsSkinData1;
  btnOk.SkinData := frmMain.bsSkinData1;
  btnCancel.SkinData := frmMain.bsSkinData1;
  lblSupplierList.SkinData := frmMain.bsSkinData1;
  lstSupplierList.SkinData := frmMain.bsSkinData1;

  QryDoUpdates.Connection := frmMain.ADOConnection;

end;

procedure TfrmUpdateSellPrices.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmUpdateSellPrices.btnOkClick(Sender: TObject);
begin
  Close;

end;

procedure TfrmUpdateSellPrices.FormActivate(Sender: TObject);
begin
  lstSupplierList.Items.Clear;

  with QryDoUpdates do
  begin
    Active := False;

    SQL.Clear;
    SQL.Add('select ');
    SQL.Add('  ' + PSupplierIDCol + ', ' + PSupplierNameCol);
    SQL.Add(' from ' + PSupplierTblName);

    Active := True;

    while not Eof do
    begin

      lstSupplierList.Items.AddObject(FieldByName(PSupplierNameCol).AsString,TObject(FieldByName(PSupplierIDCol).AsInteger));

      Next;
    end;
  end;


end;

end.
