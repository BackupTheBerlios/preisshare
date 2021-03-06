unit GTDProductDetails;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  bsSkinCtrls, bsSkinGrids, bsDBGrids, bsSkinData, Jpeg,
  BusinessSkinForm, Menus, ComCtrls, StdCtrls, Mask, bsSkinBoxCtrls,
  Dialogs, bsSkinTabs, ExtCtrls, DB, DBTables,
  bsdbctrls, bsSkinMenus, DBCtrls,EDBImage, bsDialogs,
  GTDPricelists, ImgList, bsSkinShellCtrls;

type
  TProductDetails = class(TFrame)
    dsProductInfo: TDataSource;
    bsSkinPopupMenu1: TbsSkinPopupMenu;
    ManufacturersWebsite1: TMenuItem;
    ProductWebsite1: TMenuItem;
    nbkProductInfo: TbsSkinPageControl;
    tbsBasic: TbsSkinTabSheet;
    dbeProductCode: TbsSkinDBEdit;
    dbeProductName: TbsSkinDBEdit;
    dbeCostPrice: TbsSkinDBEdit;
    dbeSellPrice: TbsSkinDBEdit;
    lblProductCode: TbsSkinLabel;
    lblProductName: TbsSkinLabel;
    dbeProductDescription: TbsSkinDBMemo2;
    lblDescription: TbsSkinLabel;
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
    Paste1: TMenuItem;
    LoadfromFile1: TMenuItem;
    SavetoFile1: TMenuItem;
    bsSkinPopupMenu2: TbsSkinPopupMenu;
    One1: TMenuItem;
    wo1: TMenuItem;
    tbsRelay: TbsSkinTabSheet;
    lstItemRelayGroup: TbsSkinTreeView;
    lblItemRelayGroup: TbsSkinLabel;
    btnItemRelayUpdate: TbsSkinSpeedButton;
    btnItemRelayCancel: TbsSkinSpeedButton;
    dlgAddProductGroup: TbsSkinInputDialog;
    nbkOurDetails: TbsSkinGroupBox;
    lblOurProductCode: TbsSkinLabel;
    lblOurName: TbsSkinLabel;
    lblOurDescription: TbsSkinLabel;
    txtOurProductCode: TbsSkinEdit;
    txtOurName: TbsSkinEdit;
    txtOurDescription: TbsSkinMemo;
    rdoItemRelayStatus: TbsSkinRadioGroup;
    bsSkinMenuSpeedButton1: TbsSkinMenuSpeedButton;
    ImageList1: TImageList;
    dlgLoadPicture: TbsSkinOpenPictureDialog;
    dlgSavePicture: TbsSkinSavePictureDialog;
    Copy1: TMenuItem;
    procedure bsSkinSpeedButton1Click(Sender: TObject);
    procedure lblPictureClick(Sender: TObject);
    procedure rdoItemRelayStatusClick(Sender: TObject);
    procedure nbkProductInfoChanging(Sender: TObject;
      var AllowChange: Boolean);
    procedure rdoItemRelayStatusChecked(Sender: TObject);
    procedure ClearPicture1Click(Sender: TObject);
    procedure LoadfromFile1Click(Sender: TObject);
    procedure Paste1Click(Sender: TObject);
    procedure SavetoFile1Click(Sender: TObject);
    procedure Copy1Click(Sender: TObject);
  private
    { Private declarations }
    fSkinData: TbsSkinData;
    fProductImage : TEDBImage;
    fCursor : TQuery;

    procedure SetSkinData(Value: TbsSkinData); {override;}

    procedure LoadRelayInfo;
    procedure SaveRelayInfo;

  public
    { Public declarations }
    MainPricelist : GTDPricelist;

    procedure Initialise;

    procedure DisplayItem(ProductCursor : TQuery);
    procedure EnableRelayItems(OnOrOff : Boolean);

  published
    property SkinData: TbsSkinData read fSkinData write SetSkinData;
    property ProductImage : TEDBImage read fProductImage;
  end;

implementation

uses Main, GTDBizDocs;

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
  lblCostPrice.SkinData := Value;
  lblSellPrice.SkinData := Value;
  lblBrand.SkinData := Value;
  dbeBrand.SkinData := Value;
  lblModel.SkinData := Value;
  dbeModel.SkinData := Value;
  pnlPicture.SkinData := Value;
  mnuPictureOptions.SkinData := Value;
  bsSkinMenuSpeedButton1.SkinData := Value;

  // -- Relay parameters page
  rdoItemRelayStatus.SkinData := Value;
//  rdoItemRelaySource.SkinData := Value;
//  txtItemRelayPercentage.SkinData := Value;
//  lblItemRelayPercentage.SkinData := Value;
  lstItemRelayGroup.SkinData := Value;
  lblItemRelayGroup.SkinData := Value;
  btnItemRelayUpdate.SkinData := Value;
  btnItemRelayCancel.SkinData := Value;

  nbkOurDetails.SkinData := Value;
  lblOurProductCode.SkinData := Value;
  txtOurProductCode.SkinData := Value;
  lblOurName.SkinData := Value;
  txtOurName.SkinData := Value;
  lblOurDescription.SkinData := Value;
  txtOurDescription.SkinData := Value;

  dlgAddProductGroup.CtrlSkinData := Value;
  dlgAddProductGroup.SkinData := Value;

  dlgLoadPicture.SkinData := Value;
  dlgLoadPicture.CtrlSkinData := Value;

  dlgSavePicture.SkinData := Value;
  dlgSavePicture.CtrlSkinData := Value;
  
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
    Stretch := True;
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

  // -- Setup the data field links
  dbeProductCode.DataField := PLU_Col;
  dbeProductName.DataField := PName_Col;
  dbeProductDescription.DataField := PDesc_Col;
  dbeCostPrice.DataField := PCostPrice;
  dbeSellPrice.DataField := PSellPrice;
  dbeBrand.DataField := PBrandBrandName;
  dbeModel.DataField := '';

  dbeBrand.Enabled := False;
  dbeModel.Enabled := False;

  // -- Make sure that the right page is selected
  nbkProductInfo.ActivePage := tbsBasic;

  fCursor := ProductCursor;
  
end;

procedure TProductDetails.bsSkinSpeedButton1Click(Sender: TObject);
var jp: TJPEGImage;
begin
end;

procedure TProductDetails.lblPictureClick(Sender: TObject);
begin
  mnuPictureOptions.Popup(0,0);
end;

procedure TProductDetails.rdoItemRelayStatusClick(Sender: TObject);
var
  pg : String;
begin
  EnableRelayItems(rdoItemRelayStatus.ItemIndex = 1);

  if (rdoItemRelayStatus.ItemIndex = 1) then
  begin
    if lstItemRelayGroup.Items.Count = 0 then
    begin
      // -- There are no product groups. Which we need
      if dlgAddProductGroup.InputQuery('Add Product Group','No product groups exist. ' + #13 + 'You''ll need to add one for this item.',pg) then
      begin
        if not Assigned(MainPricelist) then
          Exit;
        // -- Change the product group
        MainPricelist.SetStringElement(GTD_PL_PRODUCTINFO_NODE + '/' + GTD_PL_PRODUCTGROUP_NODE + '[1]',GTD_PL_ELE_GROUP_NAME,pg);

        MainPricelist.xml.SaveToFile(GTD_CURRENT_PRICELIST);

        MainPricelist.LoadProductGroupTree(TTreeView(lstItemRelayGroup));

      end;
    end;
  end;
end;

procedure TProductDetails.EnableRelayItems(OnOrOff : Boolean);
begin
  lstItemRelayGroup.Enabled := OnOrOff;
  btnItemRelayUpdate.Visible := OnOrOff;
  btnItemRelayCancel.Visible := OnOrOff;

  if OnOrOff then
    tbsRelay.Caption := 'Relay Options (On)'
  else
    tbsRelay.Caption := 'Relay Options (Off)';

end;


procedure TProductDetails.nbkProductInfoChanging(Sender: TObject;
  var AllowChange: Boolean);
begin
  if nbkProductInfo.ActivePage = tbsBasic then
  begin
    // --
    LoadRelayInfo;
  end
  else begin
  end;
end;

procedure TProductDetails.LoadRelayInfo;
begin
  if not Assigned(MainPricelist) then
     Exit;

  if FileExists(GTD_CURRENT_PRICELIST) then
    MainPricelist.LoadFromFile(GTD_CURRENT_PRICELIST)
  else
    MainPricelist.Clear;

  // -- Load the pricelist structure into a tree for display
  MainPricelist.LoadProductGroupTree(TTreeView(lstItemRelayGroup));

end;

procedure TProductDetails.SaveRelayInfo;
begin
end;

procedure TProductDetails.rdoItemRelayStatusChecked(Sender: TObject);
begin
  tbsRelay.Enabled := rdoItemRelayStatus.ItemIndex = 1;

end;

procedure TProductDetails.ClearPicture1Click(Sender: TObject);
begin
  // -- Put the recordset into edit mode
  if not (fCursor.State in [dsInsert,dsEdit]) then
    fCursor.Edit;

  fCursor.FieldByName('Picture').Clear;
end;

procedure TProductDetails.LoadfromFile1Click(Sender: TObject);
begin
  // --
  if dlgLoadPicture.Execute then
  begin
     // -- Load up the selected imageage
     fProductImage.LoadFromFile(dlgLoadPicture.FileName);
  end;
end;

procedure TProductDetails.Paste1Click(Sender: TObject);
begin
  // -- Paste the picture from the clipboard
  fProductImage.PasteFromClipboard;
end;

procedure TProductDetails.SavetoFile1Click(Sender: TObject);
begin
  // -- Now save the picture to a file
  if dlgSavePicture.Execute then
  begin
    fProductImage.SaveToFile(dlgSavePicture.FileName);
  end;
end;

procedure TProductDetails.Copy1Click(Sender: TObject);
begin
  fProductImage.CopyToClipboard;
end;

end.
