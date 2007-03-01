unit GTDBuildPricelistFromDBConfig;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  bsSkinData,
  BusinessSkinForm,
  StdCtrls, bsSkinBoxCtrls, bsSkinCtrls, Mask, ComCtrls, DB, ADODB,
  GTDBizDocs, bsSkinGrids, bsDBGrids, Menus, bsSkinMenus, bsDialogs,
  bsMessages;

type
  TBuildPricelistFromDBConfig = class(TFrame)
    pnlQueryParameters: TbsSkinGroupBox;
    mmoQry: TbsSkinMemo;
    lsvFieldList: TbsSkinListView;
    bsSkinStdLabel3: TbsSkinStdLabel;
    GTDBizDoc1: GTDBizDoc;
    ADOConnection1: TADOConnection;
    qryGetItems: TADOQuery;
    btnLoad: TbsSkinSpeedButton;
    bsSkinDBGrid1: TbsSkinDBGrid;
    DataSource1: TDataSource;
    pnlDBConnection: TbsSkinGroupBox;
    bsSkinStdLabel5: TbsSkinStdLabel;
    bsSkinStdLabel6: TbsSkinStdLabel;
    cbxConnectionList: TbsSkinComboBox;
    txtConnectionString: TbsSkinEdit;
    btnSaveData: TbsSkinSpeedButton;
    mnuFieldList: TbsSkinPopupMenu;
    S1: TMenuItem;
    bsSkinSelectValueDialog1: TbsSkinSelectValueDialog;
    bsSkinMessage1: TbsSkinMessage;
    bsSkinInputDialog1: TbsSkinInputDialog;
    pnlBackground: TbsSkinPanel;
    procedure btnLoadClick(Sender: TObject);
    procedure lsvFieldListDblClick(Sender: TObject);
    procedure bsSkinDBGrid1CellClick(Column: TbsColumn);
    procedure btnSaveDataClick(Sender: TObject);
    procedure cbxConnectionListCloseUp(Sender: TObject);
  private
    { Private declarations }
    fCustomerID : Integer;

    fDocRegistry : GTDDocumentRegistry;
	fSkinData: TbsSkinData;

    procedure SetSkinData(Value: TbsSkinData);


  public
    { Public declarations }

    // -- These mappings are like custom generates
    function LoadMapping(MapName : String):Boolean;
    function SaveMapping(MapName : String):Boolean;

    // -- These are dedicated customer mappings
    function LoadCustomerMapping(aTrader_ID : Integer):Boolean;
    function SaveCustomerMapping(aTrader_ID : Integer):Boolean;

    procedure Initialise;

  published
    property Trader_ID : Integer read fCustomerID write fCustomerID;

	property SkinData: TbsSkinData read fSkinData write SetSkinData;
    property DocRegistry : GTDDocumentRegistry read fDocRegistry write fDocRegistry;

  end;

const
    BldplfrmDbConfigKey = 'Pricelist Build Map';
    not_assigned = '<Not Assigned>';
    l1_group = '<Level 1 Product Group>';
    l2_group = '<Level 2 Product Group>';
    custom_column = '<Custom Column>';

implementation
{$R *.DFM}

//---------------------------------------------------------------------------
procedure TBuildPricelistFromDBConfig.Initialise;
begin
    fCustomerID := -1;

    bsSkinSelectValueDialog1.SelectValues.Add(not_assigned);

    bsSkinSelectValueDialog1.SelectValues.Add(l1_group);
    bsSkinSelectValueDialog1.SelectValues.Add(l2_group);

    bsSkinSelectValueDialog1.SelectValues.Add(GTD_PL_ELE_PRODUCT_CODE);
    bsSkinSelectValueDialog1.SelectValues.Add(GTD_PL_ELE_PRODUCT_NAME);
    bsSkinSelectValueDialog1.SelectValues.Add(GTD_PL_ELE_PRODUCT_DESC);
    bsSkinSelectValueDialog1.SelectValues.Add(GTD_PL_ELE_PRODUCT_KEYWORDS);
    bsSkinSelectValueDialog1.SelectValues.Add(GTD_PL_ELE_PRODUCT_LIST);
    bsSkinSelectValueDialog1.SelectValues.Add(GTD_PL_ELE_PRODUCT_ACTUAL);
    bsSkinSelectValueDialog1.SelectValues.Add(GTD_PL_ELE_PRODUCT_TAXR);
    bsSkinSelectValueDialog1.SelectValues.Add(GTD_PL_ELE_PRODUCT_UNIT);
    bsSkinSelectValueDialog1.SelectValues.Add(GTD_PL_ELE_BRANDNAME);
    bsSkinSelectValueDialog1.SelectValues.Add(GTP_PL_ELE_MANUFACT_PRODINFO);

    bsSkinSelectValueDialog1.SelectValues.Add(custom_column);

    // -- Load up the list of saved mappings
    if Assigned(fDocRegistry) then
        fDocRegistry.GetSettingItemList(BldplfrmDbConfigKey,cbxConnectionList.Items);

end;
//---------------------------------------------------------------------------
procedure TBuildPricelistFromDBConfig.btnLoadClick(
  Sender: TObject);

    procedure LoadColumnList;
    var
        xc : Integer;
        anItem : TlistItem;
    begin
        for xc := 1 to qryGetItems.FieldDefs.Count do
        begin
            // -- Add to the field assignments
            anItem := lsvFieldList.Items.Add;
            anItem.Caption := qryGetItems.FieldDefs[xc-1].Name;
            anItem.SubItems.Add('');
        end;
    end;

begin

    // -- Setup the connection
    ADOConnection1.Connected := False;

    Screen.Cursor := crHourglass;

    try
        // -- Reset and use the provided connection string
        ADOConnection1.ConnectionString := txtConnectionString.Text;
        ADOConnection1.Connected := True;

        with qryGetItems do
        begin
            Active := False;

            SQL.Assign(mmoQry.Lines);

            Active := True;

            if lsvFieldList.Items.Count = 0 then
               LoadColumnList;

        end;
    finally
 	    Screen.Cursor := crDefault;
    end;
end;
//---------------------------------------------------------------------------
function TBuildPricelistFromDBConfig.LoadMapping(MapName : String):Boolean;
var
    xc,xd : Integer;
    s : String;
    anItem : TListItem;
begin
    // -- Open the table if not already so
    if not Assigned(fDocRegistry) then
        Exit;

    lsvFieldList.Items.Clear;
    
    if fDocRegistry.GetSettingString(BldplfrmDbConfigKey,MapName,s) then
    begin

        fDocRegistry.GetSettingMemoString('/Database','Driver',s);
        fDocRegistry.GetSettingMemoString('/Database','ConnectionString',s); txtConnectionString.Text := s;
        fDocRegistry.GetSettingMemoString('/Recordset','SQL_QueryText',s); mmoQry.Text := s;

        if fDocRegistry.GetSettingMemoInt('/Mappings','Count',xd) then
        begin
            for xc := 1 to xd do
            begin
                // -- Retrieve each value
                fDocRegistry.GetSettingMemoString('/Mappings','Column_'+IntToStr(xc),s);

                // -- Add the value to the field list
                anItem := lsvFieldList.Items.Add;
                anItem.Caption := Parse(s,'=');
                anItem.SubItems.Add(s);
            end;
        end;

        // -- Last value saves the record
        Result := True;

    end;
end;
//---------------------------------------------------------------------------
function TBuildPricelistFromDBConfig.SaveMapping(MapName : String):Boolean;
var
    xc : Integer;
begin
    // -- Open the table if not already so
    if not Assigned(fDocRegistry) then
        Exit;

    fDocRegistry.SaveSettingString(BldplfrmDbConfigKey,MapName,'');

    fDocRegistry.SaveSettingMemoString('/Database','Driver','ADO');
    fDocRegistry.SaveSettingMemoString('/Database','ConnectionString',txtConnectionString.Text);

    fDocRegistry.SaveSettingMemoString('/Recordset','SQL_QueryText',mmoQry.Text,False);

    // -- Save every mapped field in the list
    for xc := 1 to lsvFieldList.Items.Count do
    begin
        // --
        fDocRegistry.SaveSettingMemoString('/Mappings','Column_'+IntToStr(xc),lsvFieldList.Items[xc-1].Caption + '=' + lsvFieldList.Items[xc-1].SubItems[0],False);
    end;

    // -- Last value saves the record
    fDocRegistry.SaveSettingMemoInt('/Mappings','Count',lsvFieldList.Items.Count,True);

    // -- reload up the list of saved mappings
    fDocRegistry.GetSettingItemList(BldplfrmDbConfigKey,cbxConnectionList.Items);

end;
//---------------------------------------------------------------------------
procedure TBuildPricelistFromDBConfig.lsvFieldListDblClick(
  Sender: TObject);
var
    r : Integer;
begin
    if not Assigned(lsvFieldList.Selected) then
        Exit;

    if bsSkinSelectValueDialog1.Execute('Column Mappings','Please select a column',r) then
    begin
        if (r = 0) then
            lsvFieldList.Selected.SubItems[0] := ''
        else
            lsvFieldList.Selected.SubItems[0] := bsSkinSelectValueDialog1.SelectValues[r];
    end;
end;
//---------------------------------------------------------------------------
procedure TBuildPricelistFromDBConfig.bsSkinDBGrid1CellClick(
  Column: TbsColumn);
begin
    //
    lsvFieldList.Selected := lsvFieldList.Items[Column.Index];
    lsvFieldList.Selected.MakeVisible(True);
end;
//---------------------------------------------------------------------------
procedure TBuildPricelistFromDBConfig.btnSaveDataClick(Sender: TObject);
var
    s : String;
begin
    if fCustomerID <> -1 then
    begin
        // --
        SaveCustomerMapping(fCustomerID);
    end
    else begin
        // -- Use the currently selected name if any
        if cbxConnectionList.ItemIndex <> -1 then
            s := cbxConnectionList.Text;

        if bsSkinInputDialog1.InputQuery('Save Profile','Enter a name to save this profile as',s) then
        begin
            if (s <> '') then
                SaveMapping(s);
        end;
    end;
end;
//---------------------------------------------------------------------------
procedure TBuildPricelistFromDBConfig.cbxConnectionListCloseUp(
  Sender: TObject);
begin
    if (cbxConnectionList.Text <> '') then
        LoadMapping(cbxConnectionList.Text);
end;
//---------------------------------------------------------------------------
procedure TBuildPricelistFromDBConfig.SetSkinData(Value: TbsSkinData);

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

var
  xc                : Integer;
begin

    SkinaPanel(pnlDBConnection);
    SkinaPanel(pnlQueryParameters);

    btnLoad.SkinData := Value;
    lsvFieldList.SkinData := Value;
    btnSaveData.SkinData := Value;
    txtConnectionString.SkinData := Value;
    mmoQry.SkinData := Value;
    pnlBackground.SkinData := Value;

    // -- Dialogs
    bsSkinSelectValueDialog1.SkinData := Value;
    bsSkinSelectValueDialog1.CtrlSkinData := Value;

    bsSkinMessage1.SkinData := Value;
    bsSkinMessage1.CtrlSkinData := Value;

    bsSkinInputDialog1.SkinData := Value;
    bsSkinInputDialog1.CtrlSkinData := Value;

    fSkinData := Value;
end;

// -- These are dedicated customer mappings
function TBuildPricelistFromDBConfig.LoadCustomerMapping(aTrader_ID : Integer):Boolean;
var
    xc,xd : Integer;
    s : String;
    anItem : TListItem;
begin
    // -- Open the table if not already so
    if not Assigned(fDocRegistry) then
        Exit;

    if fDocRegistry.OpenForTraderNumber(aTrader_ID) then
    begin

        fCustomerID := aTrader_ID;

        if fDocRegistry.GetSettingString(BldplfrmDbConfigKey,EncodeIntegerField('Trader',Trader_ID),s) then
        begin

            fDocRegistry.GetSettingMemoString('/Database','Driver',s);
            fDocRegistry.GetSettingMemoString('/Database','ConnectionString',s); txtConnectionString.Text := s;
            fDocRegistry.GetSettingMemoString('/Recordset','SQL_QueryText',s); mmoQry.Text := s;

            lsvFieldList.Items.Clear;
            
            if fDocRegistry.GetSettingMemoInt('/Mappings','Count',xd) then
            begin
                for xc := 1 to xd do
                begin
                    // -- Retrieve each value
                    fDocRegistry.GetSettingMemoString('/Mappings','Column_'+IntToStr(xc),s);

                    // -- Add the value to the field list
                    anItem := lsvFieldList.Items.Add;
                    anItem.Caption := Parse(s,'=');
                    anItem.SubItems.Add(s);
                end;
            end;

            // -- Last value saves the record
            Result := True;

        end;
    end;
end;

function TBuildPricelistFromDBConfig.SaveCustomerMapping(aTrader_ID : Integer):Boolean;
var
    xc : Integer;
begin
    // -- Open the table if not already so
    if not Assigned(fDocRegistry) then
        Exit;

    SaveMapping('Trader#=' + IntToStr(aTrader_ID));

    fCustomerID := aTrader_ID;

    {
    fDocRegistry.SaveSettingString(BldplfrmDbConfigKey,EncodeIntegerField('Trader',aTrader_ID),'');

    fDocRegistry.SaveSettingMemoString('/Database','Driver','ADO');
    fDocRegistry.SaveSettingMemoString('/Database','ConnectionString',txtConnectionString.Text);

    fDocRegistry.SaveSettingMemoString('/Recordset','SQL_QueryText',mmoQry.Text,False);

    // -- Save every mapped field in the list
    for xc := 1 to lsvFieldList.Items.Count do
    begin
        // --
        fDocRegistry.SaveSettingMemoString('/Mappings','Column_'+IntToStr(xc),lsvFieldList.Items[xc-1].Caption + '=' + lsvFieldList.Items[xc-1].SubItems[0],False);
    end;

    // -- Last value saves the record
    fDocRegistry.SaveSettingMemoInt('/Mappings','Count',lsvFieldList.Items.Count,True);
    }

    // -- reload up the list of saved mappings
    fDocRegistry.GetSettingItemList(BldplfrmDbConfigKey,cbxConnectionList.Items);
end;

end.


