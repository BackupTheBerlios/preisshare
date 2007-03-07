unit UpdateSellPrices;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, bsSkinCtrls, BusinessSkinForm, bsSkinBoxCtrls, DB, ADODB,
  bsMessages, SynEdit, SynEditHighlighter, SynHighlighterSQL, bsDialogs,
  SynMemo, SynHighlighterPas, StdCtrls, Mask, dws2Comp, dws2Compiler,
  dws2HtmlFilter;

type
  TfrmUpdateSellPrices = class(TForm)
    bsBusinessSkinForm1: TbsBusinessSkinForm;
    btnOk: TbsSkinButton;
    btnCancel: TbsSkinButton;
    rdoColumnSelect: TbsSkinRadioGroup;
    lstSupplierList: TbsSkinCheckListBox;
    lblSupplierList: TbsSkinLabel;
    QryDoUpdates: TADOQuery;
    dlgMessage: TbsSkinMessage;
    SynSQLSyn1: TSynSQLSyn;
    dlgSQL: TbsSkinTextDialog;
    SynMemo1: TSynMemo;
    bsSkinGroupBox1: TbsSkinGroupBox;
    bsSkinLabel1: TbsSkinLabel;
    SynPasSyn1: TSynPasSyn;
    txtMarkupPercentage: TbsSkinSpinEdit;
    DelphiWebScriptII: TDelphiWebScriptII;
    gagProgress: TbsSkinGauge;
    dlgCompileErrors: TbsSkinTextDialog;
    procedure FormCreate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure rdoColumnSelectClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function RunPriceUpdate:Boolean;
  end;

var
  frmUpdateSellPrices: TfrmUpdateSellPrices;

implementation

uses Main, GTDBizDocs, dws2Exprs, dws2Errors;

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

    LAST_SQL_FILENAME = 'last_price_update.sql';

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
  gagProgress.SkinData := frmMain.bsSkinData1;
  dlgMessage.SkinData := frmMain.bsSkinData1;
  dlgMessage.CtrlSkinData := frmMain.bsSkinData1;
  dlgCompileErrors.SkinData := frmMain.bsSkinData1;
  dlgCompileErrors.CtrlSkinData := frmMain.bsSkinData1;

  QryDoUpdates.Connection := frmMain.ADOConnection;



end;

procedure TfrmUpdateSellPrices.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmUpdateSellPrices.btnOkClick(Sender: TObject);
begin
  // -- Go run the price update
  if RunPriceUpdate then

    Close;

end;

procedure TfrmUpdateSellPrices.FormActivate(Sender: TObject);
begin
  lstSupplierList.Items.Clear;

  // -- Select the relay calculation file by default if it exists
  if FileExists(GTD_RELAYCALCSFILE) then
  begin
    rdoColumnSelect.ItemIndex := 0;
    SynMemo1.Lines.LoadFromFile(GTD_RELAYCALCSFILE);
  end else
    rdoColumnSelect.ItemIndex := 1;

  // -- Build the query to find the Suppliers
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

function TfrmUpdateSellPrices.RunPriceUpdate:Boolean;
const
  UPDATE_USING_RELAYFORMULA = 0;
  UPDATE_USING_COST = 1;
  UPDATE_USING_LIST = 2;
  UPDATE_USING_SQL = 3;
var
  xc,sid,sc : Integer;
  s : String;
  prog: TProgram;
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
    if lstSupplierList.Checked[xc] then
      Inc(sc);
  end;
  if (sc = 0) then
  begin
    // -- Pop up an error message if no suppliers were selected
    dlgMessage.MessageDlg('Please select one or more Suppliers',mtError,[mbOk],0);
    Exit;
  end;

  if rdoColumnSelect.ItemIndex = UPDATE_USING_RELAYFORMULA then
  begin
    // -- Compile the DWSII formula
    try
      prog := DelphiWebScriptII.Compile(SynMemo1.Text);
    finally
    end;

    if prog.Msgs.HasCompilerErrors then
    begin
      dlgCompileErrors.Lines.Clear;
      for xc := 1 to prog.Msgs.Count do
      begin
        dlgCompileErrors.Lines.Add(prog.Msgs[xc-1].AsString);
      end;
      dlgCompileErrors.Caption := 'Script Compilation Errors';
      dlgCompileErrors.Execute;
      Exit;
    end;

    // -- Save the script
    SynMemo1.Lines.SaveToFile(GTD_RELAYCALCSFILE);

    // -- Here we build a recordset, cycle through each
    //    record, and run our price calculation over it
    with QryDoUpdates do
    begin
      Active := False;

      SQL.Clear;
      SQL.Add('SELECT *');
      SQL.Add('FROM  ' + PProdTblName);
      SQL.Add('WHERE');

      // -- Build a list of supplierIDs
      s := '  ' + PSupplierIDCol + ' in (';

      // -- Retrieve all the supplierids from the list
      for xc := 0 to lstSupplierList.Items.Count-1 do
      begin
        if lstSupplierList.Checked[xc] then
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

        Active := True;

        // -- Display the progress bar
        gagProgress.Visible := True;
        gagProgress.Value := 0;
        gagProgress.MaxValue := RecordCount;

        // -- Now cycle through each of the records and update
        while Not Eof do
        begin

          // -- We pass our cost price in and expect to get our sell price out
          prog.BeginProgram;

          // -- Recalculate the new selling price
          Edit;
          FieldByName(PSellPrice).AsCurrency := prog.Info.Func['Calc_Actual_IncTax'].Call([FieldByName(PCostPrice).AsCurrency]).Value;
          Post;

          prog.EndProgram;

          Next;

          gagProgress.Value := gagProgress.Value + 1;

        end;

      finally
        Screen.Cursor := crDefault;
        gagProgress.Visible := False;
        prog.Free;
      end;

      dlgMessage.MessageDlg(IntToStr(RecordCount) + ' records updated.',mtInformation,[mbOk],0);

      Result := True;

      Exit;

    end;

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
      if lstSupplierList.Checked[xc] then
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

      Result := True;

    finally
      Screen.Cursor := crDefault;
    end;
  end;

end;

procedure TfrmUpdateSellPrices.rdoColumnSelectClick(Sender: TObject);
begin
  SynMemo1.Visible := (rdoColumnSelect.ItemIndex = 3) or (rdoColumnSelect.ItemIndex = 0);
  if (rdoColumnSelect.ItemIndex = 0) then
  begin
    // -- Go to pascal editing
    SynMemo1.Highlighter := SynPasSyn1;

    if FileExists(GTD_RELAYCALCSFILE) then
      SynMemo1.Lines.LoadFromFile(GTD_RELAYCALCSFILE)
    else begin
      SynMemo1.Lines.Clear;
      SynMemo1.Lines.Add('function Calc_Actual_IncTax(CostPrice : Float): Float;');
      SynMemo1.Lines.Add('begin');
      SynMemo1.Lines.Add('  // -- Here are the calculations');
      SynMemo1.Lines.Add('  Result := 1.25 * CostPrice;');
      SynMemo1.Lines.Add('end;');
    end;
  end
  else if (rdoColumnSelect.ItemIndex = 3) then
  begin
    // -- Go to sql editing
    SynMemo1.Highlighter := SynSQLSyn1;

    // -- Update the selling prices
    if FileExists(LAST_SQL_FILENAME) then
      // -- Load the last saved query from the file
      SynMemo1.Lines.LoadFromFile(LAST_SQL_FILENAME)
    else begin
      // -- Update the query
      SynMemo1.Lines.Clear;
      SynMemo1.Lines.Add('UPDATE');
      SynMemo1.Lines.Add('  ' + PProdTblName);
      SynMemo1.Lines.Add('SET');
      SynMemo1.Lines.Add('  OurSellingPrice = ROUND((OurBuyingPrice*1.5)*1.1,2)');
    end;

  end

end;

end.
