unit ColumnParams;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DBTables, bsSkinCtrls, ComCtrls, BusinessSkinForm, Menus,
  bsSkinMenus, bsDialogs, bsMessages;

type
  TfrmColumnParams = class(TForm)
    bsBusinessSkinForm1: TbsBusinessSkinForm;
    lstFieldList: TbsSkinListView;
    btnOk: TbsSkinButton;
    btnCancel: TbsSkinButton;
    btnAddColumn: TbsSkinSpeedButton;
    btnDeleteColumn: TbsSkinSpeedButton;
    mnuFieldList: TbsSkinPopupMenu;
    dlgSelectColumn: TbsSkinSelectValueDialog;
    dlgMessage: TbsSkinMessage;
    procedure btnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnAddColumnClick(Sender: TObject);
    procedure lstFieldListDblClick(Sender: TObject);
    procedure btnDeleteColumnClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
      procedure LoadColumnInfo(aDataSet : TQuery);

  end;

var
  frmColumnParams: TfrmColumnParams;

implementation

{$R *.dfm}
uses Main, GTDProductDBSearch,bsdbgrids;

procedure TfrmColumnParams.LoadColumnInfo(aDataSet : TQuery);
var
  xc,xd : Integer;
  newMenuItem : TMenuItem;
  newListItem : TListItem;
begin
  lstFieldList.Items.Clear;
  mnuFieldList.Items.Clear;

  // -- Create a menu item with all the fields
  dlgSelectColumn.SelectValues.Clear;
  for xc := 0 to aDataSet.FieldCount-1 do
  begin
    // -- Create the item in the menu
    newMenuItem := TMenuItem.Create(Self);
    newMenuItem.Caption := aDataSet.FieldDefs[xc].Name;

    dlgSelectColumn.SelectValues.Add(aDataSet.FieldDefs[xc].Name);
  end;

  // -- Now create the list of columns
  for xc := 0 to frmMain.productDB.grdProducts.Columns.Count-1 do
  begin
    newListItem := lstFieldList.Items.Add;
    newListItem.Caption := frmMain.productDB.grdProducts.Columns[xc].Title.Caption;
    newListItem.SubItems.Add(frmMain.productDB.grdProducts.Columns[xc].FieldName);
    newListItem.SubItems.Add(IntToStr(frmMain.productDB.grdProducts.Columns[xc].Width));
  end;

end;

procedure TfrmColumnParams.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmColumnParams.FormCreate(Sender: TObject);
begin
  // -- Setup skin data
  bsBusinessSkinForm1.SkinData := frmMain.bsSkinData1;
  lstFieldList.SkinData := frmMain.bsSkinData1;
  btnOk.SkinData := frmMain.bsSkinData1;
  btnCancel.SkinData := frmMain.bsSkinData1;
  dlgSelectColumn.SkinData := frmMain.bsSkinData1;
  dlgSelectColumn.CtrlSkinData := frmMain.bsSkinData1;
  btnAddColumn.SkinData := frmMain.bsSkinData1;
  btnDeleteColumn.SkinData := frmMain.bsSkinData1;
end;

procedure TfrmColumnParams.btnAddColumnClick(Sender: TObject);
var
  newItem : TListItem;
  xc : Integer;
begin
  if dlgSelectColumn.Execute('Add Column..','Select Column',xc) then
  begin
    newItem := lstFieldList.Items.Add;
    newItem.Caption := dlgSelectColumn.SelectValues[xc];
    newItem.SubItems.Add(dlgSelectColumn.SelectValues[xc]);
    newItem.SubItems.Add('40');
  end;
end;

procedure TfrmColumnParams.lstFieldListDblClick(Sender: TObject);
var
  xc : Integer;
begin
  if dlgSelectColumn.Execute('Column Mappings','Select Column',xc) then
  ;
end;

procedure TfrmColumnParams.btnDeleteColumnClick(Sender: TObject);
begin
  if not Assigned(lstFieldList.Selected) then
    Exit;

  // -- Remove the dialog with confirmation
  if mrYes = dlgMessage.MessageDlg('Remove Column',mtConfirmation,[mbYes,mbCancel],0) then
  begin
    lstFieldList.Items.Delete(lstFieldList.Selected.Index);
  end;
end;

procedure TfrmColumnParams.btnOkClick(Sender: TObject);
var
  xc : Integer;
  s : TbsColumn;
begin
  frmMain.productDB.grdProducts.Columns.Clear;

  // -- Here we need to change the columns that are displayed
  //    and make sure that the settings are save back to the
  //    registry.
  for xc := 0 to lstFieldList.Items.Count-1 do
  begin
    s := frmMain.productDB.grdProducts.Columns.Add;
    s.FieldName := lstFieldList.Items[xc].SubItems[0];
    s.Title.Caption := lstFieldList.Items[xc].Caption;
    s.Width := StrToInt(lstFieldList.Items[xc].SubItems[1]);
  end;

  Close;
  
end;

end.
