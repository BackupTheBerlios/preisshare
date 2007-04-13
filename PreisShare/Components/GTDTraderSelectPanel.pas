unit GTDTraderSelectPanel;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  bsSkinData, bsSkinBoxCtrls, bsSkinCtrls, StdCtrls, Mask, bsSkinGrids, bsDBGrids, GTDBizDocs,
  Db, bsMessages;

type

  TOnTraderSelectedEvent = procedure (Sender: TObject) of object;

  TpnlTraderGet  = class(TFrame)
    dsSource: TDataSource;
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
    lblEnterTraderName: TbsSkinLabel;
    txtEnterTraderName: TbsSkinEdit;
    dlg1: TbsSkinMessage;
    lblSuburbTown: TbsSkinLabel;
    txtSuburbTown: TbsSkinEdit;
    txtShortname: TbsSkinEdit;
    lblShortName: TbsSkinLabel;
    lblCustomerType: TbsSkinLabel;
    cbxCustomerType: TbsSkinComboBox;
    grdScroll: TbsSkinScrollBar;
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
    fCreateText,
    fSelectText     : String;
    fSelectMode     : String; // S=Supplier, C=Client, CP=Client/Prospect

    procedure SetRegistry(NewRegistry : GTDDocumentRegistry);
   	procedure SetSkinData(Value: TbsSkinData); {override;}

  public
    { Public declarations }
    function SelectSupplierOrAddNew(ModeIndex : Integer = 0):Boolean;
    function SelectProspectClientOrAddNew(ModeIndex : Integer = 0):Boolean;
    function ValidateTraderEntry:Boolean;

    procedure AfterScroll(DataSet: TDataSet);

  published
    property DocRegistry : GTDDocumentRegistry read fDocRegistry write SetRegistry;
  	 property SkinData   : TbsSkinData read fSkinData write SetSkinData;
    property TraderID : Integer read fTraderID write fTraderID;
    property OnTraderSelected : TOnTraderSelectedEvent read fOnTraderSelected write fOnTraderSelected;
    property CreateButtonText : String read fCreateText write fCreateText;
    property SelectButtonText : String read fSelectText write fSelectText;
  end;

implementation

{$R *.DFM}

procedure TpnlTraderGet.SetRegistry(NewRegistry : GTDDocumentRegistry);
var
    c : String;
begin
    fDocRegistry := NewRegistry;
    dsSource.DataSet := fDocRegistry.Traders;

    // -- Some initialisation
    c := GetEnglishCountryName;
    GetCountryNameList(cbxCountry.Items);
    cbxCountry.ItemIndex := cbxCountry.Items.IndexOf(c);

end;

procedure TpnlTraderGet.txtEnterTraderNameButtonClick(Sender: TObject);
begin
    pnlNewTrader.Visible := False;
end;

function TpnlTraderGet.SelectSupplierOrAddNew(ModeIndex : Integer):Boolean;
begin
    if Assigned(fDocRegistry) then
    begin
        dsSource.DataSet := fDocRegistry.Traders;
        fDocRegistry.Traders.Active := True;
        fDocRegistry.Traders.AfterScroll := AfterScroll;
    end;

    fSelectMode := 'S';

    // -- Change some fields specifically for client entry
    lblShortName.Caption := 'Short Name (used for searching)';

    if not Self.Visible then
        Self.Visible := True;

    pnlNewTrader.Visible := False;
    cbxCustomerType.ItemIndex := ModeIndex;
    cbxCustomerTypeChange(Self);

    Visible := True;

end;

function TpnlTraderGet.SelectProspectClientOrAddNew(ModeIndex : Integer):Boolean;
begin
    if Assigned(fDocRegistry) then
    begin
        dsSource.DataSet := fDocRegistry.Traders;
        fDocRegistry.Traders.Active := True;
        fDocRegistry.Traders.AfterScroll := AfterScroll;
    end;

    fSelectMode := 'CP';

    // -- Change some fields specifically for client entry
    lblShortName.Caption := 'Email Address';

    if not Self.Visible then
        Self.Visible := True;

    pnlNewTrader.Visible := False;
    cbxCustomerType.ItemIndex := ModeIndex;
    cbxCustomerTypeChange(Self);

    Visible := True;
end;

procedure TpnlTraderGet.SetSkinData(Value: TbsSkinData);
begin
    // -- Change the skin values
	bsSkinPanel1.SkinData := Value;
	lblEnterTraderName.SkinData := Value;
	bsSkinDBGrid1.SkinData := Value;
	btnSelect.SkinData := Value;
  txtEnterTraderName.SkinData := Value;
  cbxCustomerType.SkinData := Value;
  lblCustomerType.SkinData := Value;
  pnlNewTrader.SkinData := Value;

  grdScroll.SkinData := Value;
  
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
    txtEnterTraderName.Width := Self.Width - cbxCustomerType.Width - (2 * txtEnterTraderName.Left);
    lblEnterTraderName.Width := txtEnterTraderName.Width;
    bsSkinDBGrid1.Width := Self.Width - (2 * bsSkinDBGrid1.Left) - grdScroll.width;
    grdScroll.Left := bsSkinDBGrid1.Left + bsSkinDBGrid1.Width;
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
            if fSelectMode = 'S' then
              FieldByName(GTD_DB_COL_SHORTNAME).AsString := txtShortname.Text
            else if fSelectMode = 'CP' then
              FieldByName(GTD_DB_COL_EMAILADDRESS).AsString := txtShortname.Text;
            FieldByName(GTD_DB_COL_STATUS_CODE).AsString := GTD_TRADER_STATUS_ACTIVE;
            Post;
        end;

        // -- Hide the panel now
        pnlNewTrader.Visible := False;

    end;

    // -- Check that an active supplier is selected
    if fSelectMode = 'S' then
    begin
      DocRegistry.Traders.FieldByName(GTD_DB_COL_RELATIONSHIP).AsString := GTD_TRADER_RLTNSHP_SUPPLIER;
      DocRegistry.Traders.FieldByName(GTD_DB_COL_STATUS_CODE).AsString := GTD_TRADER_STATUS_ACTIVE;
    end
    else if fSelectMode = 'CP' then
    begin
      DocRegistry.Traders.FieldByName(GTD_DB_COL_RELATIONSHIP).AsString := GTD_TRADER_RLTNSHP_CUSTOMER;
      DocRegistry.Traders.FieldByName(GTD_DB_COL_STATUS_CODE).AsString := GTD_TRADER_STATUS_PROSPECT;
    end;

      fTraderID := DocRegistry.Traders.FieldByName(GTD_DB_COL_TRADER_ID).AsInteger;

      // -- Reselect this company
      DocRegistry.OpenForTraderNumber(fTraderID);

      // -- The supplier is ok
      Result := True;
    // -- Fire off the event if it has been provided
end;

procedure TpnlTraderGet.cbxCustomerTypeChange(Sender: TObject);
begin
    if cbxCustomerType.ItemIndex = 0 then
    begin
        // -- Select existing trader
        pnlNewTrader.Visible := False;
        if fCreateText <>'' then
          btnSelect.Caption := fCreateText;
    end
    else begin
        // -- Create a new trader
        pnlNewTrader.Visible := True;
        if fSelectText <> '' then
          btnSelect.Caption := fSelectText;
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

    // -- Drop the assignment on this field
    fDocRegistry.Traders.AfterScroll := nil;

    if Assigned(fOnTraderSelected) then
        fOnTraderSelected(Sender);
end;

procedure TpnlTraderGet.AfterScroll(DataSet: TDataSet);
begin
  // --
  if cbxCustomerType.ItemIndex = 0 then
    txtEnterTraderName.Text := DataSet.FieldByName(GTD_DB_COL_COMPANY_NAME).AsString;
end;

end.
