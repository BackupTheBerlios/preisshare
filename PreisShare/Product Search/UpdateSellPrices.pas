unit UpdateSellPrices;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, bsSkinCtrls, BusinessSkinForm, bsSkinBoxCtrls, DB, ADODB,
  bsMessages, SynEdit, SynEditHighlighter, SynHighlighterSQL, bsDialogs,
  SynMemo;

type
  TfrmUpdateSellPrices = class(TForm)
    bsBusinessSkinForm1: TbsBusinessSkinForm;
    bsSkinGroupBox1: TbsSkinGroupBox;
    btnOk: TbsSkinButton;
    btnCancel: TbsSkinButton;
    rdoColumnSelect: TbsSkinRadioGroup;
    bsSkinLabel1: TbsSkinLabel;
    txtMarkupPercentage: TbsSkinSpinEdit;
    lstSupplierList: TbsSkinCheckListBox;
    lblSupplierList: TbsSkinLabel;
    QryDoUpdates: TADOQuery;
    dlgMessage: TbsSkinMessage;
    SynSQLSyn1: TSynSQLSyn;
    dlgSQL: TbsSkinTextDialog;
    SynMemo1: TSynMemo;
    procedure FormCreate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure rdoColumnSelectClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure RunPriceUpdate;
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
  txtMarkupPercentage.SkinData := frmMain.bsSkinData1;
  btnOk.SkinData := frmMain.bsSkinData1;
  btnCancel.SkinData := frmMain.bsSkinData1;
  lblSupplierList.SkinData := frmMain.bsSkinData1;
  lstSupplierList.SkinData := frmMain.bsSkinData1;
  dlgMessage.SkinData := frmMain.bsSkinData1;
  dlgMessage.CtrlSkinData := frmMain.bsSkinData1;

  QryDoUpdates.Connection := frmMain.ADOConnection;

end;

procedure TfrmUpdateSellPrices.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmUpdateSellPrices.btnOkClick(Sender: TObject);
begin
  // -- Go run the price update
  RunPriceUpdate;

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

procedure TfrmUpdateSellPrices.RunPriceUpdate;
const
  UPDATE_USING_COST = 0;
  UPDATE_USING_LIST = 1;
  UPDATE_USING_SQL = 2;
var
  xc,sid,sc : Integer;
  s : String;
begin
  // -- Check for custom sql
  if rdoColumnSelect.ItemIndex = UPDATE_USING_SQL then
  begin
    try
      Screen.Cursor := crHourglass;

      QryDoUpdates.SQL.Clear;
      QryDoUpdates.SQL.Assign(SynMemo1.Lines);
      QryDoUpdates.ExecSQL;
    finally
      Screen.Cursor := crDefault;
    end;

    Exit;
  end;

  // -- Validate the user input
  if txtMarkupPercentage.Value = 0 then
  begin
    if rdoColumnSelect.ItemIndex = UPDATE_USING_LIST then
    begin
      dlgMessage.MessageDlg('Please enter a markup percentage',mtError,[mbOk],0);
      Exit;
    end
    else if mrCancel = dlgMessage.MessageDlg('This will set the Sell price to the same as the Cost price. Do you wish to continue ?',mtConfirmation,[mbYes,mbCancel],0) then
    begin
      Exit;
    end;
  end;

  // -- Validate that they selected at least one supplier
  sc := 0;
  for xc := 0 to lstSupplierList.Items.Count-1 do
  begin
    if lstSupplierList.Selected[xc] then
      Inc(sc);
  end;
  if (sc = 0) then
  begin
    // -- Pop up an error message if no suppliers were selected
    dlgMessage.MessageDlg('Please select one or more Suppliers',mtError,[mbOk],0);
    Exit;
  end;

  // -- Build and execute the update query
  with QryDoUpdates do
  begin
    Active := False;

    SQL.Clear;
    SQL.Add('UPDATE');
    SQL.Add('  ' + PProdTblName);
    SQL.Add('SET');

    Screen.Cursor := crDefault;
  end;

  // -- Handle updating from the cost price column
  if rdoColumnSelect.ItemIndex = UPDATE_USING_COST then
  begin
      QryDoUpdates.SQL.Add('  ' + PSellPrice + ' = (' + PCostPrice + ' * ' + FloatToStr((100 + txtMarkupPercentage.Value) / 100) + ')');
  end
  // -- Handle updating from the list price column
  else if rdoColumnSelect.ItemIndex = UPDATE_USING_LIST then
  begin
      QryDoUpdates.SQL.Add('  ' + PSellPrice + ' = (' + PSellPrice + ' * ' + FloatToStr((100 + txtMarkupPercentage.Value) / 100) + ')');
  end;

  // -- Now add in the supplier selection stuff
  with QryDoUpdates do
  begin
    SQL.Add('WHERE');

    // -- Build a list of supplierIDs
    s := '  ' + PSupplierIDCol + ' in (';

    // -- Retrieve all the supplierids from the list
    for xc := 0 to lstSupplierList.Items.Count-1 do
    begin
      if lstSupplierList.Selected[xc] then
      begin
        // -- Read out the supplier id
        sid := Integer(lstSupplierList.Items.Objects[xc]);

        s := s + IntToStr(sid) + ',';
      end;
    end;
    // -- Chop the last comma
    SetLength(s,Length(s)-1);

    // -- Add in the '['
    s := s + ')';

    SQL.Add(s);

    try
      Screen.Cursor := crHourglass;

      // -- Now run the query and hope for the best
      ExecSQL;

      dlgMessage.MessageDlg('Prices successfully updated',mtInformation,[mbOk],0);

      
    finally
      Screen.Cursor := crDefault;
    end;
  end;

end;

procedure TfrmUpdateSellPrices.rdoColumnSelectClick(Sender: TObject);
begin
  SynMemo1.Visible := rdoColumnSelect.ItemIndex = 2;
end;

end.
