unit GTDXLSPriceReader;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  OleServer, StdCtrls, Excel97, bsSkinCtrls, bsSkinBoxCtrls, bsSkinData,
  bsSkinShellCtrls,GTDTextToPricefile, GTDBizDocs, GTDTraderSelectPanel, Mask, bsDialogs, ComCtrls,
  bsSkinTabs, Buttons, ExcelXP, Variants,
  GTDUpdateSummary, GTDProductDBUpdate, PricelistExport, jpeg, ExtCtrls;


type
  TGTDXLStoPL = class(TFrame)
    ExcelApplication1: TExcelApplication;
    ws: TExcelWorksheet;
    WkBk: TExcelWorkbook;
    bsSkinOpenDialog1: TbsSkinOpenDialog;
    bsSkinSpeedButton1: TbsSkinSpeedButton;
    bsSkinTextDialog1: TbsSkinTextDialog;
    bsSkinSelectValueDialog1: TbsSkinSelectValueDialog;
    pnlBackground: TbsSkinPanel;
    bsSkinPanel2: TbsSkinPanel;
    lblProgress: TbsSkinStdLabel;
    btnView: TbsSkinSpeedButton;
    bsSkinLabel4: TbsSkinLabel;
    ssgProgress: TbsSkinGauge;
    bsSkinPanel3: TbsSkinPanel;
    pnlSheetSettings: TbsSkinPanel;
    lblSheetCount: TbsSkinLabel;
    cbxSheetList: TbsSkinComboBox;
    bsSkinLabel3: TbsSkinLabel;
    txtCellStart: TbsSkinEdit;
    bsSkinStdLabel2: TbsSkinStdLabel;
    bsSkinStdLabel3: TbsSkinStdLabel;
    txtCellEnd: TbsSkinEdit;
    lstColMap: TbsSkinListView;
    bsSkinPanel1: TbsSkinPanel;
    lblStepUpTo: TbsSkinStdLabel;
    lblStep1Text: TbsSkinTextLabel;
    bsSkinLabel2: TbsSkinLabel;
    pnlSheetOpen: TbsSkinPanel;
    lblStep2Text: TbsSkinTextLabel;
    lblFilename: TbsSkinLabel;
    txtSpreadsheetName: TbsSkinFileEdit;
    btnConvert: TbsSkinButton;
    lblStep3Text: TbsSkinTextLabel;
    lblStep4Text: TbsSkinTextLabel;
    btnBack: TbsSkinButton;
    btnRescan: TbsSkinSpeedButton;
    Image1: TImage;
    procedure bsSkinSpeedButton3Click(Sender: TObject);
    procedure bsSkinSpeedButton4Click(Sender: TObject);
    procedure bsSkinSpeedButton2Click(Sender: TObject);
    procedure bsSkinSpeedButton5Click(Sender: TObject);
    procedure bsSkinSpeedButton6Click(Sender: TObject);
    procedure bsSkinSpeedButton1Click(Sender: TObject);
    procedure bsSkinSpeedButton7Click(Sender: TObject);
    procedure lstColMapDblClick(Sender: TObject);
    procedure btnConvertClick(Sender: TObject);
    procedure txtSpreadsheetNameChange(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure btnBackClick(Sender: TObject);
    procedure txtCellStartChange(Sender: TObject);
    procedure btnRescanClick(Sender: TObject);
  private
    { Private declarations }
    lcid: integer;
    plcvt : GTDPricefileConvertor;
    fDocReg : GTDDocumentRegistry;
    tsel : TpnlTraderGet;
    pnlUpdSum: TGTDPriceUpdateSummary;
//    pnldbUpdate : TGTDProductDBUpdateFrame;
    pnldbUpdate : TGTDPricelistExportFrame;
    fStepNumber : Integer;

    SheetFileName : String;

	fSkinData: TbsSkinData;

	procedure SetSkinData(Value: TbsSkinData);

  public
    { Public declarations }
    NeedToStop : Boolean;

    function Initialise:Boolean;
    function OpenPriceSpreadsheet(const XLSFileName : String):Boolean;
    function SelectSheetWithDialog:Boolean;

    function ProcessSheet(ExamineFormatOnly : Boolean=False):Boolean;
    function Close:Boolean;
    function SavePricelist(Trader_ID : Integer):Boolean;

    procedure GotoPreviousStep;
    procedure GotoNextStep;
    function GotoStep(StepNumber : Integer):Boolean;

  published
	property SkinData: TbsSkinData read fSkinData write SetSkinData;
    property DocRegistry : GTDDocumentRegistry read fDocReg write fDocReg;
  end;

implementation

{$R *.DFM}
uses ComObj, ActiveX;

function TGTDXLStoPL.Initialise:Boolean;
begin
    // --
    if not Assigned(plcvt) then
    begin
        plcvt := GTDPricefileConvertor.Create(Self);
        with plcvt do
        begin
            Top := bsSkinPanel3.Top;
            Left := bsSkinPanel3.Left;
            Width := bsSkinPanel3.Width;
            Height := bsSkinPanel3.Height;
            Parent := pnlBackGround;
            Visible := True;
        end;
    end
    else
        plcvt.Clear;

    if not Assigned(tsel) then
    begin
        tsel := TpnlTraderGet.Create(self);
        with tsel do
        begin
            Top := pnlSheetOpen.Top;
            Left := pnlSheetOpen.Left;
            Width := pnlSheetOpen.Width;
            Height := pnlSheetOpen.Height;

            Parent := Self;
            DocRegistry := fDocReg;
            Visible := False;
        end;
    end;

    // -- This component only displays the database updating work
    if not Assigned(pnlUpdSum) then
    begin
        pnlUpdSum := TGTDPriceUpdateSummary.Create(Self);
        with pnlUpdSum do
        begin
            Top := pnlSheetOpen.Top;
            Left := pnlSheetOpen.Left;
            Width := pnlSheetOpen.Width;
            Height := pnlSheetOpen.Height;

            Parent := Self;
            Visible := False;
        end;
        pnlUpdSum.SkinData := SkinData;

    end;

    // -- This component actually does the database updating work
    if not Assigned(pnldbUpdate) then
    begin
        pnldbUpdate := TGTDPricelistExportFrame.Create(Self);
        with pnldbUpdate do
        begin
            Top := 10;
            Left := 10;
            Parent := Self;
            Visible := False;

            DocRegistry := fDocReg;

            Initialise;

            Visible := False; // ** debugging **

        end;
        pnldbUpdate.SkinData := SkinData;
    end;

    lstColMap.Items.Clear;

    // --
    pnlSheetSettings.Top  := pnlSheetOpen.Top;
    pnlSheetSettings.Left := pnlSheetOpen.Left;
    pnlUpdSum.Top       := pnlSheetOpen.Top;
    pnlUpdSum.Left      := pnlSheetOpen.Left;
    lblStep2Text.Top      := lblStep1Text.Top;
    lblStep2Text.Left     := lblStep1Text.Left;
    lblStep3Text.Top      := lblStep1Text.Top;
    lblStep3Text.Left     := lblStep1Text.Left;
    lblStep4Text.Top      := lblStep1Text.Top;
    lblStep4Text.Left     := lblStep1Text.Left;

    fStepNumber := 1;

    Result := True;
end;

function TGTDXLStoPL.OpenPriceSpreadsheet(const XLSFileName : String):Boolean;
begin
    // -- Check that the file exists
    if not FileExists(xlsFileName) then
    begin
        plcvt.ReportMessage('Error','File doesn''t exist');
        Exit;
    end;

    // -- Set the filename
    SheetFileName := XLSFileName;

    // -- Connect and open the sheet
    {$IFDEF VER100}
      // -- Delphi 5
      WkBk.ConnectTo(ExcelApplication1.Workbooks.Open(XLSFilename,EmptyParam,1,EmptyParam,EmptyParam,EmptyParam,EmptyParam,EmptyParam,EmptyParam,EmptyParam,EmptyParam,EmptyParam,EmptyParam,lcid));
    {$ENDIF}
    {$IFDEF VER150}
      // -- Delphi 7
      WkBk.ConnectTo(ExcelApplication1.Workbooks.Open(XLSFilename,EmptyParam,1,EmptyParam,EmptyParam,EmptyParam,EmptyParam,EmptyParam,EmptyParam,EmptyParam,EmptyParam,EmptyParam,EmptyParam,EmptyParam,EmptyParam,lcid));
    {$ENDIF}
    WS.ConnectTo(WkBk.Worksheets[1] as _Worksheet);

    Result := True;

end;

procedure TGTDXLStoPL.bsSkinSpeedButton4Click(Sender: TObject);
begin
  WS.Disconnect;
  WkBk.Disconnect;
  ExcelApplication1.Disconnect;
end;

procedure TGTDXLStoPL.bsSkinSpeedButton2Click(Sender: TObject);
begin
end;
// --
//
// Notes:
//
//      If we are examining the sheet then we can set parameters
//      according to how we find things in the sheet.
//
//      If we are not examining, then we are running and must
//      leave things alone.
//
function TGTDXLStoPL.ProcessSheet(ExamineFormatOnly : Boolean):Boolean;
var
    UsedCols,UsedRows : Integer;
    sl : TStringList;
    i : TListItem;
    sheetcount,sn,
    xc : Integer;

    function FindUsedRowsAndCols:Boolean;
    const
        MaxColumnsAllowed = 25;
    var
        j : Integer;
    begin
        UsedCols := 0;
        UsedRows := 0;

        plcvt.ReportMessage('Show','Determining sheet');

        UsedRows := WS.UsedRange[lcid].Rows.Count;
        UsedCols := WS.UsedRange[lcid].Columns.Count;

        if (UsedCols > MaxColumnsAllowed) then
            UsedCols := MaxColumnsAllowed;

        plcvt.ReportMessage('Show','Columns='+IntToStr(UsedCols) + ' Rows='+IntToStr(UsedRows));

        // -- Here we can update the display if we are examining
        if ExamineFormatOnly then
        begin
            // -- Display the used Cell Range
            if txtCellStart.Text = '' then
                txtCellStart.Text := 'R1C1';

            if txtCellEnd.Text = '' then
                txtCellEnd.Text := 'R' + IntToStr(UsedRows) + 'C' + IntToStr(UsedCols);

            btnRescan.Visible := False;

            if (plcvt.ColCount = 0) and (lstColMap.Items.Count = 0) then
            begin

                // -- Add blank columns to the list
                for j := 1 to UsedCols do
                begin
                    // -- Add a new item to the list
                    i := lstColMap.Items.Add;
                    i.Caption := 'Column' + IntToStr(j);
                end;

                // -- Set the number of columns
                plcvt.ColCount := UsedCols

            end;

        end;


        Result := True;
    end;

    function ReadColumnWidths:Boolean;
    var
        Rnge, cWidth: OleVariant;
        xc,a : Integer;
    begin

        // --
        plcvt.ReportMessage('Show','Checking column widths');

        // -- Code breaks here if more than 26 columns
        a := Ord('A') - 1;
        for xc := 1 to UsedCols do
        begin

            Rnge :=  Ws.Range[Chr(a + xc) + '1',Chr(a + xc) + '100'];
            cWidth := Rnge.EntireColumn.ColumnWidth;

            plcvt.ReportMessage('Show',' - Columnwidth[' + IntToStr(xc) +']='+IntToStr(cWidth));

        end;

        Result := True;

    end;

    // -- This would display saved conversion information
    procedure DisplayDiscoveredConversionInfo;
    var
        xc : Integer;
    begin
        // -- Extract and display column mappings
        lstColMap.Items.Clear;
        for xc := 1 to plcvt.ColCount do
        begin
            // -- Add a new item to the list
            i := lstColMap.Items.Add;
            i.Caption := plcvt.ColDefs[xc].ColumnName;
            case plcvt.ColDefs[xc].LogicalCol of
                LOGICAL_CODE_COL : i.SubItems.Add(GTD_PL_ELE_PRODUCT_CODE);
                LOGICAL_NAME_COL : i.SubItems.Add(GTD_PL_ELE_PRODUCT_NAME);
                LOGICAL_DESC_COL : i.SubItems.Add(GTD_PL_ELE_PRODUCT_DESC);
                LOGICAL_BUY_COL  : i.SubItems.Add(GTD_PL_ELE_PRODUCT_ACTUAL);
                LOGICAL_SELL_COL : i.SubItems.Add(GTD_PL_ELE_PRODUCT_LIST);
                LOGICAL_GROUPLVL1: i.SubItems.Add(GTD_PL_PRODUCTGROUP_TAG);
            else
                i.SubItems.Add('');
            END;
        end;

        if (plcvt.ColCount = 0) then
        begin
            plcvt.ReportMessage('Show','No columns discovered - You may wish to change area');
            txtCellStart.ReadOnly := False;
            txtCellEnd.ReadOnly := False;
            btnRescan.Visible := True;
        end;
    end;

    function SetupConversionInfo:Boolean;
    var
        xc : Integer;
    begin

        plcvt.ClearColumnMappings;    

        // -- Save the Column mappings from the screen
        for xc := 1 to lstColMap.Items.Count do
        begin
            // -- Add a new item to the list
            i := lstColMap.Items[xc-1];

            // -- Use the mapping the user set
            plcvt.MapColumnToField(i.Caption,i.SubItems[0]);

        end;

    end;

    function ReadRowNumber(const ARCVal : String):Integer;
    var
        rstart,cstart : Integer;
    begin
        rstart := Pos('R',ARCVal);
        cstart := Pos('C',ARCVal);
        if (rstart <> 0) and (cstart <> 0) and (rstart < cstart) then
        begin
            Result := StrToInt(Copy(ARCVal,rstart+1,cstart-rstart-1));
        end;
    end;

    function ConvertDataToStringList:Boolean;
    const
        ExamineLinesNeeded = 100;
    var
        rc,cl,f,sr,lr : Integer;
        l,s : String;
        NormalCellColor, CellColor : TColor;
    begin
        if ExamineFormatOnly then
            plcvt.ReportMessage('Show','Examining sheet')
        else
            plcvt.ReportMessage('Show','Converting sheet');

        // -- Determine the normal color of cells in the sheet
        NormalCellColor := WS.Range['DT2000', 'DT2000'].Interior.Color;

        // -- Determine the first row to start with
        sr := ReadRowNumber(txtCellStart.Text);
        lr := ReadRowNumber(txtCellEnd.Text);

        // -- If we are examining the sheet to read the format
        //    cut down on the total number of rows if necessary
        //    so that the whole sheet is not processed
        if ExamineFormatOnly then
        begin
            // -- Reduce used-rows if neccessary
            if UsedRows > ExamineLinesNeeded then
                lr := sr + ExamineLinesNeeded;
        end;

        try

            Result := False;

            // -- Load all the spreadsheet cells in as a big tabbed list
            for rc := sr to lr do
            begin
                // -- Reset the line variable
                l := '';

                // -- Add all the cells
                for cl := 1 to UsedCols do
                begin
                    // -- Read out the cell contents
                    s := WS.Cells.Item[rc,cl].Value;

                    // -- Add it to our line
                    l := l + s + Chr(9);
                end;

                // -- Now Check for formatting as this can denote a product group
                f := 0;
                CellColor := WS.Range['A'+IntToStr(rc), 'A'+IntToStr(rc)].Interior.Color;
                if CellColor <> NormalCellColor then
                begin
                    f := 1;
                    plcvt.ReportMessage('Debug','  Found non-background color = '+ColorToString(CellColor));
                end;

                // -- Add our tabbed data to the list
                sl.AddObject(l,TObject(f));

                if NeedToStop then
                    break;
            end;

            Result := True;

        except
		 on E : Exception do
            begin
    			plcvt.ReportMessage('Error','Error' + e.Message + '@ R' + IntToStr(rc));
            end;
        end;

    end;

    function CheckExcelIsRunning:Boolean; // -- Connect/setup stuff
    begin
        if (lcid = 0) then
        begin
            lcid := GetUserDefaultLCID;
            ExcelApplication1.AutoConnect := True;
            ExcelApplication1.Visible[lcid]:=True;
        end;
    end;


begin

    Result := False;

    sl := TStringlist.Create;

    try

        Screen.Cursor := crHourglass;

        CheckExcelIsRunning;

        ssgProgress.Visible := True;
        ssgProgress.Update;

        lblProgress.Visible := True;
        lblProgress.Update;

        // -- If we have already parsed the sheet then we
        //    don't need to initialise
        if ExamineFormatOnly then
        begin
            // -- Don't open it a second time
            if (txtSpreadSheetName.Text <> SheetFileName) or (not Assigned(WkBk)) then
                if not OpenPriceSpreadsheet(SheetFileName) then
                    Exit;
        end;

        // -- Clear all important variables ready to go
        plcvt.Clear;

        sheetcount := WkBk.Worksheets.Count;

        // -- Check the number of workbooks
        lblSheetCount.Caption := 'Sheets (' + IntToStr(sheetcount) + ')';
        if sheetcount = 1 then
            plcvt.ReportMessage('Show','Workbook has only one sheet')
        else
            plcvt.ReportMessage('Show','Workbook has multiple sheets');

        cbxSheetList.Items.Clear;

        // -- Multiple Worksheets exist
        for sn := 1 to sheetcount do
        begin
            // -- Connect to this sheet
            WS.ConnectTo(WkBk.Worksheets[sn] as _Worksheet);

            plcvt.ReportMessage('Show','Found Sheet name '+ws.Name);

            // -- Add it to the list
            cbxSheetList.Items.Add(ws.Name);

            if not FindUsedRowsAndCols then
                Exit;

            ReadColumnWidths;

            if ExamineFormatOnly then
            begin
                plcvt.LineItemLayout := plilTabbed;
                plcvt.DataFormat := pltDataLayout;
                plcvt.ClearDiscoveredColumns;
            end
            else
                SetupConversionInfo;

            if not ConvertDataToStringList then
                Exit;

            if plcvt.ProcessList(sl,ExamineFormatOnly) then
            begin
                if ExamineFormatOnly then
                    DisplayDiscoveredConversionInfo;
            end
            else
                Exit;

            Application.ProcessMessages;

            plcvt.ReportMessage('Show','Sheet ' + ws.Name + ' Completed');

            ssgProgress.Value := (sn * 100) div sheetcount;
            ssgProgress.Update;

        end;

        cbxSheetList.ItemIndex := 0;

        if ExamineFormatOnly then
        begin
            plcvt.ReportMessage('Show','Examination Completed')

        end
        else begin
            // -- Now let the users change the settings
            plcvt.ReportMessage('Show','Conversion Completed');

        end;

        Result := True;

    finally
        sl.Destroy;

        ssgProgress.Visible := False;
        lblProgress.Visible := False;

        Screen.Cursor := crDefault;
    end;

end;

procedure TGTDXLStoPL.bsSkinSpeedButton5Click(Sender: TObject);
begin
    ProcessSheet;
end;

procedure TGTDXLStoPL.bsSkinSpeedButton6Click(Sender: TObject);
var
    xc,sc : Integer;
begin
    sc := WkBk.Worksheets.Count;

    // -- Check the number of workbooks
    if sc = 1 then
    begin
        // -- Only one Worksheet exists
        plcvt.ReportMessage('Show','Workbook has only one sheet');

        ProcessSheet;

    end
    else begin
        // -- Multiple Worksheets exist
        for xc := 1 to sc do
        begin
            // -- Connect to this sheet
            WS.ConnectTo(WkBk.Worksheets[xc] as _Worksheet);

            plcvt.ReportMessage('Show','Found Sheet name '+ws.Name);

            ProcessSheet;

        end;
    end;
//    WS.ConnectTo(WkBk.Worksheets[1] as _Worksheet);

end;

procedure TGTDXLStoPL.SetSkinData(Value: TbsSkinData);

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
  xc : Integer;
begin
    SkinaPanel(bsSkinPanel2);

    bsSkinLabel3.SkinData := Value;

    bsSkinTextDialog1.SkinData := Value;
    bsSkinTextDialog1.CtrlSkinData := Value;

    bsSkinSelectValueDialog1.SkinData := Value;
    bsSkinSelectValueDialog1.CtrlSkinData := Value;

    bsSkinOpenDialog1.SkinData := Value;
    bsSkinOpenDialog1.CtrlSkinData := Value;

    lblSheetCount.SkinData := Value;

    lstColMap.SkinData := Value;

    cbxSheetList.SkinData := Value;
    txtCellStart.SkinData := Value;
    txtCellEnd.SkinData := Value;

    lblFilename.SkinData := Value;
    txtSpreadsheetName.SkinData := Value;
    txtSpreadsheetName.DlgSkinData := Value;
    txtSpreadsheetName.DlgCtrlSkinData := Value;

    btnRescan.SkinData := Value;
    btnView.SkinData := Value;
    
    pnlBackground.SkinData := Value;
    if Assigned(tsel) then
        tsel.SkinData := Value;

    if Assigned(pnlUpdSum) then
        pnlUpdSum.SkinData := Value;

    fSkinData := Value;
    
end;

procedure TGTDXLStoPL.bsSkinSpeedButton1Click(Sender: TObject);
begin
    MessageDlg(intToStr(lcid),mtInformation,[mbOk],0);
end;

procedure TGTDXLStoPL.bsSkinSpeedButton7Click(Sender: TObject);
begin
    plcvt.AssignOutputTo(bsSkinTextDialog1.Lines);
    bsSkinTextDialog1.Execute;
end;

procedure TGTDXLStoPL.lstColMapDblClick(Sender: TObject);
var
    xc : Integer;

    function findfieldindex(const astring : String):Integer;
    begin
        Result := -1;

        if (aString <> '') then
            Result := bsSkinSelectValueDialog1.SelectValues.IndexOf(aString);

    end;
begin
    if not Assigned(lstColMap.Selected) then
        Exit;

    // -- Load up the list
    bsSkinSelectValueDialog1.SelectValues.Clear;
    with bsSkinSelectValueDialog1.SelectValues do
    begin
        Add(GTD_PL_ELE_PRODUCT_PLU);
        Add(GTD_PL_ELE_PRODUCT_NAME);
        Add(GTD_PL_ELE_PRODUCT_DESC);
        Add(GTD_PL_ELE_PRODUCT_KEYWORDS);
        Add(GTD_PL_ELE_PRODUCT_LIST);
        Add(GTD_PL_ELE_PRODUCT_ACTUAL);
        Add(GTD_PL_PRODUCTGROUP_TAG);
        Add(GTD_PL_ELE_PRODUCT_BRAND);
        Add(GTD_PL_ELE_PRODUCT_UNIT);
        Add(GTD_PL_ELE_PRODUCT_TYPE);
        Add(GTD_PL_ELE_BRANDNAME);

//        Add(GTD_PL_ELE_PRODUCT_TAXR);
//        Add(GTD_PL_ELE_PRODUCT_TAXT);
//        Add(GTD_PL_ELE_PRODUCT_MINORDQTY);
//        Add(GTD_PL_ELE_PRODUCT_IMAGE);
//        Add(GTD_PL_ELE_PRODUCT_BIGIMAGE);
//        Add(GTD_PL_ELE_PRODUCT_MOREINFO);
//        Add(GTD_PL_ELE_MANUFACT_NAME);
//        Add(GTD_PL_ELE_MANUFACT_GTL);
//        Add(GTP_PL_ELE_MANUFACT_PRODINFO);
//        Add(GTD_PL_ELE_PRODUCT_AVAIL_FLAG);
//        Add(GTD_PL_ELE_PRODUCT_AVAIL_DATE);
//        Add(GTD_PL_ELE_PRODUCT_AVAIL_STATUS);
    end;

    // -- Now try to find the existing value in the list
    bsSkinSelectValueDialog1.DefaultValue := findfieldindex(lstColMap.Selected.SubItems[0]);

    if bsSkinSelectValueDialog1.Execute('Column Mapping','Select the logical field to map this column to:',xc) then
    begin

        // -- Select that particular field
        lstColMap.Selected.SubItems[0] := bsSkinSelectValueDialog1.SelectValues.Strings[xc];// IntToStr(xc);

    end;
end;

procedure TGTDXLStoPL.bsSkinSpeedButton3Click(Sender: TObject);
begin
    SelectSheetWithDialog;
end;

function TGTDXLStoPL.Close:Boolean;
begin
    Initialise;

    lstColMap.Items.Clear;
    plcvt.Clear;
    cbxSheetList.Items.Clear;

    WS.Disconnect;
    WkBk.Disconnect;
    ExcelApplication1.Disconnect;
    SheetFileName := '';

    lcid := 0;

end;

function TGTDXLStoPL.SelectSheetWithDialog:Boolean;
begin
    if bsSkinOpenDialog1.Execute then
    begin
        SheetFileName := bsSkinOpenDialog1.Filename;

        ProcessSheet(True);
    end;
end;

procedure TGTDXLStoPL.btnConvertClick(Sender: TObject);
begin
    GotoNextStep;
end;

function TGTDXLStoPL.SavePricelist(Trader_ID : Integer):Boolean;
var
    myPricelist : TStringList;
begin
    myPricelist := TStringList.Create;

    plcvt.AssignOutputTo(myPricelist);

    myPricelist.Destroy;

end;

procedure TGTDXLStoPL.txtSpreadsheetNameChange(Sender: TObject);
begin
    if (txtSpreadSheetName.Text <> '') and (FileExists(txtSpreadSheetName.Text)) then
    begin
        // -- Open the file
        if OpenPriceSpreadsheet(txtSpreadSheetName.Text) then

            // -- Open in examination mode
            plcvt.ReportMessage('Show',txtSpreadSheetName.Text + ' selected.');
            plcvt.ReportMessage('Show','Ready to begin Sheet examination.');
    end;
end;

procedure TGTDXLStoPL.GotoPreviousStep;
begin
    if (fStepNumber > 1) then
        GotoStep(fStepNumber - 1);
end;

procedure TGTDXLStoPL.GotoNextStep;
begin
    GotoStep(fStepNumber + 1);
end;

function TGTDXLStoPL.GotoStep(StepNumber : Integer):Boolean;

    procedure CloseExcel;
    begin
        // -- Close Excel now
        WS.Disconnect;
        WkBk.Disconnect;
        ExcelApplication1.Disconnect;
        SheetFileName := '';
//        lcid := 0;
    end;

var
    s : String;
begin
    Result := False;

    case StepNumber of
     1 : begin
            // -- Select the file
            pnlSheetOpen.Visible := True;
            pnlSheetSettings.Visible := False;
            pnlUpdSum.Visible := False;

            lblStepUpTo.Caption := 'Step 1 of 4';
            btnConvert.Caption := 'Next >>';
            btnConvert.Visible := True;
            btnBack.Visible := True;

            lblStep1Text.Visible := True;
            lblStep2Text.Visible := False;
            lblStep3Text.Visible := False;
            lblStep4Text.Visible := False;

            bsSkinPanel1.Visible := True;
            bsSkinLabel2.Visible := True;

            pnldbUpdate.Visible := False;
            
            if Assigned(tsel) then
                tsel.Visible := false;

            fStepNumber := 1;

            txtSpreadsheetName.SetFocus;
            
            Result := True;
         end;
     2 : begin
            // -- Open the file, change any column mappings
            //    and process the XLS to a pricefile
            if SheetFileName <> '' then
            begin

                if (lcid = 0) then
                    Initialise;

                // -- Process the sheet but examine only
                if ProcessSheet(True) then
                begin
                    Inc(fStepNumber);
                    Result := True;
                end;
                
                pnlSheetOpen.Visible := False;
                pnlSheetSettings.Visible := True;
                pnlUpdSum.Visible := False;

                tsel.Visible := false;
                lblStepUpTo.Caption := 'Step 2 of 4';
                btnConvert.Caption := 'Next >>';
                lblStep1Text.Visible := False;
                lblStep2Text.Visible := True;
                lblStep3Text.Visible := False;
                lblStep4Text.Visible := False;

                txtCellStart.ReadOnly := False;
                txtCellEnd.ReadOnly := False;
                btnRescan.Visible := False;

            end;
         end;
     3 : begin
            // -- Actually process the sheet this time
            if ProcessSheet then
            begin
                Inc(fStepNumber);
                Result := True;
            end;

            lblStepUpTo.Caption := 'Step 3 of 4';
            btnConvert.Caption := 'Next >>';
            lblStep1Text.Visible := False;
            lblStep2Text.Visible := False;
            lblStep3Text.Visible := True;
            lblStep4Text.Visible := False;

            // -- These all get turned on if successful
            pnlSheetSettings.Visible := False;
            pnlSheetOpen.Visible := False;
            pnlUpdSum.Visible := False;

            // -- Select the company
            tsel.SkinData := fSkinData;
            tsel.Visible := True;
            tsel.SelectSupplierOrAddNew;

            btnView.Visible := True;
            btnConvert.Default := False;

         end;
     4 : begin
            // -- Validate that a proper trader was selected
            if not tsel.ValidateTraderEntry then
                Exit;

            CloseExcel;

            // -- Save the pricelist

            // -- Determine the correct traderid by magic means..
            tsel.TraderID := fDocReg.Traders.FieldByName(GTD_DB_COL_TRADER_ID).AsInteger;
            fDocReg.Trader_ID := tsel.TraderID; // -- Save against the correct supplier

            // -- Add the trader information from the database record
            fDocReg.AddCurrentTraderVendorInfo(plcvt.OutputPricelist);

            // -- Now save the pricelist
            if fDocReg.SaveAsLatestPriceList(plcvt.OutputPricelist,Now,s,False) then
            begin

                lblStepUpTo.Caption := 'Step 4 of 4';
                btnConvert.Caption := 'Finish';
                lblStep1Text.Visible := False;
                lblStep2Text.Visible := False;
                lblStep3Text.Visible := False;
                lblStep4Text.Visible := True;

                tsel.Visible := False;

                // -- Now show the database update panel
                pnldbUpdate.Visible := True;
                pnldbUpdate.ShowProcessButton := False;

                fStepNumber := 4;

                bsSkinPanel1.Visible := False;
                bsSkinLabel2.Visible := False;

                Result := True;
            end;

         end;
     5 : begin
            // -- Update database then Finished
            pnldbUpdate.LoadPricelist(plcvt.OutputPricelist);
            pnldbUpdate.UpdateFlag := True;
            if pnldbUpdate.Run then
            begin
                btnConvert.Visible := False;
                btnBack.Visible := False;
                lblStepUpTo.Caption := 'Finished';
                fStepNumber := 0;
                Result := True;
            end;
         end;
    else
        ;
    end;
end;

procedure TGTDXLStoPL.SpeedButton1Click(Sender: TObject);
begin
    Initialise;
    GotoStep(1);
end;

procedure TGTDXLStoPL.SpeedButton2Click(Sender: TObject);
begin
    GotoStep(2);
end;

procedure TGTDXLStoPL.SpeedButton3Click(Sender: TObject);
begin
    GotoStep(3);
end;

procedure TGTDXLStoPL.SpeedButton4Click(Sender: TObject);
begin
    GotoStep(4);
end;

procedure TGTDXLStoPL.btnBackClick(Sender: TObject);
begin
    GotoPreviousStep;
end;

procedure TGTDXLStoPL.txtCellStartChange(Sender: TObject);
begin
    btnRescan.Visible := True;
end;

procedure TGTDXLStoPL.btnRescanClick(Sender: TObject);
begin
    // -- Rescan the sheet
    ProcessSheet(True);
end;

end.

