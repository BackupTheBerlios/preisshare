unit GTDProductDetails;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  bsSkinCtrls, bsSkinGrids, bsDBGrids, bsSkinData, Jpeg,
  BusinessSkinForm, Menus, ComCtrls, StdCtrls, Mask, bsSkinBoxCtrls,
  Dialogs, bsSkinTabs, ExtCtrls, DB, DBTables,
  bsdbctrls, bsSkinMenus, DBCtrls,EDBImage;

type
  TProductDetails = class(TFrame)
    dsProductInfo: TDataSource;
    bsSkinPopupMenu1: TbsSkinPopupMenu;
    ManufacturersWebsite1: TMenuItem;
    ProductWebsite1: TMenuItem;
    nbkProductInfo: TbsSkinPageControl;
    bsSkinTabSheet1: TbsSkinTabSheet;
    dbeProductCode: TbsSkinDBEdit;
    dbeProductName: TbsSkinDBEdit;
    dbeCostPrice: TbsSkinDBEdit;
    dbeSellPrice: TbsSkinDBEdit;
    lblProductCode: TbsSkinLabel;
    lblProductName: TbsSkinLabel;
    dbeProductDescription: TbsSkinDBMemo2;
    lblDescription: TbsSkinLabel;
    lblPicture: TbsSkinLabel;
    lblCostPrice: TbsSkinLabel;
    lblSellPrice: TbsSkinLabel;
    lblBrand: TbsSkinLabel;
    dbeBrand: TbsSkinDBEdit;
    lblModel: TbsSkinLabel;
    dbeModel: TbsSkinDBEdit;
    pnlPicture: TbsSkinPanel;
    bsSkinStdLabel1: TbsSkinStdLabel;
    mnuPictureOptions: TbsSkinPopupMenu;
    ClearPicture1: TMenuItem;
    Copy1: TMenuItem;
    Paste1: TMenuItem;
    LoadfromFile1: TMenuItem;
    SavetoFile1: TMenuItem;
    bsSkinPopupMenu2: TbsSkinPopupMenu;
    One1: TMenuItem;
    wo1: TMenuItem;
    procedure bsSkinSpeedButton1Click(Sender: TObject);
    procedure lblPictureClick(Sender: TObject);
  private
    { Private declarations }
    fSkinData: TbsSkinData;
    fProductImage : TEDBImage;

    procedure SetSkinData(Value: TbsSkinData); {override;}

  public
    { Public declarations }
    procedure Initialise;

    procedure DisplayItem(ProductCursor : TQuery);

  published
    property SkinData: TbsSkinData read fSkinData write SetSkinData;
  end;

implementation

{$R *.dfm}
procedure TProductDetails.SetSkinData(Value: TbsSkinData);

  procedure SkinaPanel(where: TWinControl);
  var
    I               : Integer;
  begin
    with where do
      begin
        for I := 0 to Where.ControlCount - 1 do
          if Where.Controls[I] is TbsSkinControl then
            TbsSkinControl(Where.Controls[I]).SkinData := Value;
      end;
    TbsSkinControl(where).SkinData := Value;
  end;

begin
  nbkProductInfo.SkinData := Value;

  dbeProductCode.SkinData := Value;
  dbeProductName.SkinData := Value;
  dbeCostPrice.SkinData := Value;
  dbeSellPrice.SkinData := Value;
  lblProductCode.SkinData := Value;
  lblProductName.SkinData := Value;
  dbeProductDescription.SkinData := Value;
  lblDescription.SkinData := Value;
  lblPicture.SkinData := Value;
  lblCostPrice.SkinData := Value;
  lblSellPrice.SkinData := Value;
  lblBrand.SkinData := Value;
  dbeBrand.SkinData := Value;
  lblModel.SkinData := Value;
  dbeModel.SkinData := Value;
  pnlPicture.SkinData := Value;
  mnuPictureOptions.SkinData := Value;
end;

procedure TProductDetails.Initialise;
begin
  fProductImage := TEDBImage.Create(Self);
  with fProductImage do
  begin
    Parent := pnlPicture;
    Align := alClient;
    DataSource := dsProductInfo;
    DataField := 'Picture';
    BorderStyle := bsNone;
    Visible := True;
    Color := 5318157;
    PopupMenu := mnuPictureOptions;
  end;
end;

procedure TProductDetails.DisplayItem(ProductCursor : TQuery);
const
    PLU_Col = 'VendorProductID';
    PName_Col = 'ProductName';
    PDesc_Col = 'ProductDescription';
    PCostPrice = 'OurBuyingPrice';
    PSellPrice = 'OurSellingPrice';
    PProdTblName = 'Products';
    PBrandTblName = 'Brands';
    PBrandBrandName = '';
    PSupplierTblName = 'Suppliers';
    PSupplierIDCol = 'SupplierID';
    PSupplierNameCol = 'CompanyName';

begin
  // -- Set the product cursor to the data source
  dsProductInfo.DataSet := ProductCursor;

  dbeProductCode.DataField := PLU_Col;
  dbeProductName.DataField := PName_Col;
  dbeProductDescription.DataField := PDesc_Col;
  dbeCostPrice.DataField := PCostPrice;
  dbeSellPrice.DataField := PSellPrice;
  dbeBrand.DataField := PBrandBrandName;
  dbeModel.DataField := '';

  dbeBrand.Enabled := False;
  dbeModel.Enabled := False;

end;

procedure TProductDetails.bsSkinSpeedButton1Click(Sender: TObject);
var jp: TJPEGImage;
begin
    fProductImage.LoadFromFile('d:\truco.jpg');
end;

procedure TProductDetails.lblPictureClick(Sender: TObject);
begin
  mnuPictureOptions.Popup(0,0);
end;

end.
