unit GTDTraderSelectPanel;

interface

uses 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  bsSkinData, bsSkinBoxCtrls, bsSkinCtrls, StdCtrls, Mask, bsSkinGrids, bsDBGrids, GTDBizDocs,
  Db, bsMessages;

type

  TOnTraderSelectedEvent = procedure (Sender: TObject) of object;

  TpnlTraderGet = class(TFrame)
    DataSource1: TDataSource;
    bsSkinPanel1: TbsSkinPanel;
    btnSelect: TbsSkinButton;
    bsSkinDBGrid1: TbsSkinDBGrid;
    pnlNewTrader: TbsSkinGroupBox;
    lblAddress: TbsSkinLabel;
    txtAddress1: TbsSkinEdit;
    txtAddress2: TbsSkinEdit;
    lblState: TbsSkinLabel;
    cbxState: TbsSkinComboBox;
    cbxCountry: TbsSkinComboBox;
    lblCountry: TbsSkinLabel;
    bsSkinLabel1: TbsSkinLabel;
    txtEnterTraderName: TbsSkinEdit;
    dlg1: TbsSkinMessage;
    lblSuburbTown: TbsSkinLabel;
    txtSuburbTown: TbsSkinEdit;
    txtShortname: TbsSkinEdit;
    lblShortName: TbsSkinLabel;
    lblCustomerType: TbsSkinLabel;
    cbxCustomerType: TbsSkinComboBox;
    procedure txtEnterTraderNameButtonClick(Sender: TObject);
    procedure bsSkinDBGrid1CellClick(Column: TbsColumn);
    procedure FrameResize(Sender: TObject);
    procedure cbxCountryClick(Sender: TObject);
    procedure cbxCustomerTypeChange(Sender: TObject);
    procedure txtEnterTraderNameKeyPress(Sender: TObject; var Key: Char);
    procedure btnSelectClick(Sender: TObject);
  private
    { Private declarations }
  	fSkinData       : TbsSkinData;
    fTraderID       : Integer;
    fDocRegistry    : GTDDocumentRegistry;
    fOnTraderSelected : TOnTraderSelectedEvent;

    procedure SetRegistry(NewRegistry : GTDDocumentRegistry);
  	procedure SetSkinData(Value: TbsSkinData); {override;}

  public
    { Public declarations }
    function SelectSupplierOrAddNew:Boolean;
    function ValidateTraderEntry:Boolean;

  published
    property DocRegistry : GTDDocumentRegistry read fDocRegistry write SetRegistry;
  	property SkinData   : TbsSkinData read fSkinData write SetSkinData;
    property TraderID : Integer read fTraderID write fTraderID;
    property OnTraderSelected : TOnTraderSelectedEvent read fOnTraderSelected write fOnTraderSelected; 
  end;

implementation

{$R *.DFM}

procedure TpnlTraderGet.SetRegistry(NewRegistry : GTDDocumentRegistry);
var
    c : String;
begin
    fDocRegistry := NewRegistry;
    DataSource1.DataSet := fDocRegistry.Traders;

    // -- Some initialisation
    c := GetEnglishCountryName;
    GetCountryNameList(cbxCountry.Items);
    cbxCountry.ItemIndex := cbxCountry.Items.IndexOf(c);

end;

procedure TpnlTraderGet.txtEnterTraderNameButtonClick(Sender: TObject);
begin
    pnlNewTrader.Visible := False;
end;

function TpnlTraderGet.SelectSupplierOrAddNew:Boolean;
begin
    if Assigned(fDocRegistry) then
    begin
        DataSource1.DataSet := fDocRegistry.Traders;
        fDocRegistry.Traders.Active := True;
    end;

    if not Self.Visible then
        Self.Visible := True;
        
    pnlNewTrader.Visible := False;
    cbxCustomerType.ItemIndex := 0;

    Visible := True;

end;

procedure TpnlTraderGet.SetSkinData(Value: TbsSkinData);
begin
    // -- Change the skin values
	bsSkinPanel1.SkinData := Value;
	bsSkinLabel1.SkinData := Value;
	bsSkinDBGrid1.SkinData := Value;
	btnSelect.SkinData := Value;
  txtEnterTraderName.SkinData := Value;
  cbxCustomerType.SkinData := Value;
  lblCustomerType.SkinData := Value;
  pnlNewTrader.SkinData := Value;

  lblAddress.SkinData := Value;
  txtAddress1.SkinData := Value;
  txtAddress2.SkinData := Value;
  cbxState.SkinData := Value;
  cbxCountry.SkinData := Value;
  txtEnterTraderName.SkinData := Value;
  lblState.SkinData := Value;
  lblCountry.SkinData := Value;
  lblSuburbTown.SkinData := Value;
  txtSuburbTown.SkinData := Value;

  lblShortName.SkinData := Value;
  txtShortName.SkinData := Value;

  dlg1.CtrlSkinData := Value;
  dlg1.SkinData := Value;

end;

procedure TpnlTraderGet.bsSkinDBGrid1CellClick(Column: TbsColumn);
begin
    // --

end;

procedure TpnlTraderGet.FrameResize(Sender: TObject);
begin
    // -- Only provide for width changes at the moment
    bsSkinLabel1.Width := Self.Width - (2 * bsSkinLabel1.Left);
    txtEnterTraderName.Width := Self.Width - cbxCustomerType.Width - (2 * txtEnterTraderName.Left);
    bsSkinDBGrid1.Width := Self.Width - (2 * bsSkinDBGrid1.Left);
    cbxCustomerType.Left := txtEnterTraderName.Left + txtEnterTraderName.Width;
end;

procedure TpnlTraderGet.cbxCountryClick(Sender: TObject);
begin
    LoadStateNames(GetCodeFromCountryName(cbxCountry.Text),cbxState.Items);
end;

function TpnlTraderGet.ValidateTraderEntry:Boolean;

    function InformationIsValid:Boolean;
    begin
        Result := False;

        if (txtEnterTraderName.Text = '') then
        begin
            dlg1.MessageDlg('Supplier Name is required',mtError,[mbOk],0);
            txtEnterTraderName.SetFocus;
            Exit;
        end;

        if (txtSuburbTown.Text = '') then
        begin
            dlg1.MessageDlg('Suburb/Town is required',mtError,[mbOk],0);
            txtSuburbTown.SetFocus;
            Exit;
        end;

        Result := True;
    end;
begin
    if pnlNewTrader.Visible then
    begin
        // -- Validate the data
        if not InformationIsValid then
            Exit;

        // -- Save the information to the registry
        with DocRegistry.Traders do
        begin
            Append;
            FieldByName(GTD_DB_COL_COMPANY_NAME).AsString := txtEnterTraderName.Text;
            FieldByName(GTD_DB_COL_ADDRESS_LINE_1).AsString := txtAddress1.Text;
            FieldByName(GTD_DB_COL_ADDRESS_LINE_2).AsString := txtAddress2.Text;
            FieldByName(GTD_DB_COL_TOWN).AsString := txtSuburbTown.Text;
            FieldByName(GTD_DB_COL_STATE_REGION).AsString := cbxState.Text;
            FieldByName(GTD_DB_COL_COUNTRYCODE).AsString := GetCodeFromCountryName(cbxCountry.Text);
            FieldByName(GTD_DB_COL_RELATIONSHIP).AsString := GTD_TRADER_RLTNSHP_SUPPLIER;
            FieldByName(GTD_DB_COL_SHORTNAME).AsString := txtShortname.Text;
            FieldByName(GTD_DB_COL_STATUS_CODE).AsString := GTD_TRADER_STATUS_ACTIVE;
            Post;
        end;

        // -- Hide the panel now
        pnlNewTrader.Visible := False;

    end;

    // -- Check that an active supplier is selected
    if (DocRegistry.Traders.FieldByName(GTD_DB_COL_RELATIONSHIP).AsString = GTD_TRADER_RLTNSHP_SUPPLIER) and
       (DocRegistry.Traders.FieldByName(GTD_DB_COL_STATUS_CODE).AsString = GTD_TRADER_STATUS_ACTIVE) then
    begin
      fTraderID := DocRegistry.Traders.FieldByName(GTD_DB_COL_TRADER_ID).AsInteger;

      // -- Reselect this company
      DocRegistry.OpenForTraderNumber(fTraderID);

      // -- The supplier is ok
      Result := True;
    end;
    // -- Fire off the event if it has been provided
end;

procedure TpnlTraderGet.cbxCustomerTypeChange(Sender: TObject);
begin
    if cbxCustomerType.ItemIndex = 0 then
    begin
        pnlNewTrader.Visible := False;
    end
    else begin
        pnlNewTrader.Visible := True;
    end;
    
    txtEnterTraderName.SetFocus;

end;

procedure TpnlTraderGet.txtEnterTraderNameKeyPress(Sender: TObject;
  var Key: Char);
begin
    if Assigned(DocRegistry) and (DocRegistry.Traders.Active) and (cbxCustomerType.ItemIndex = 0) then
    begin
        if (cbxCustomerType.ItemIndex = 0) then
        begin
            // -- Find the closest match
//            DocRegistry.Traders.SetKey;
//            DocRegistry.Traders.FieldByName(GTD_DB_COL_COMPANY_NAME).AsString := txtEnterTraderName.Text;
//            DocRegistry.Traders.GotoNearest;
        end;
    end;
end;

procedure TpnlTraderGet.btnSelectClick(Sender: TObject);
begin
    if not ValidateTraderEntry then
        Exit;

    if Assigned(fOnTraderSelected) then
        fOnTraderSelected(Sender);
end;

end.
