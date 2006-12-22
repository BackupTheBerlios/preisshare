unit PatchImportFrame;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, DBTables, bsSkinCtrls, bsSkinGrids, bsDBGrids, bsSkinData,
  BusinessSkinForm, Menus, ComCtrls, StdCtrls, Mask, bsSkinBoxCtrls, Tabs,
  ExtCtrls, bsSkinTabs, GTDBizDocs, Buttons, HCMngr, ProductLister,
  bsSkinShellCtrls, bsMessages, bsCalendar, bsDialogs, DDB, DTables,
  DMaster,DEditors, bsdbctrls;

type
  TTradalogImportTypes = (tit1Table1Group_csv,
                          tit1Level1Table_csv,

                          tit1Table1Group_exp,
                          tit1Level1Table_exp,
                          tit1Level2Table_exp,
                          tit2Level3Table_exp,

                          tit1Table1Group_sync,
                          tit1Level1Table_sync,
                          tit1Level2Table_sync,
                          tit2Level3Table_sync
                          );

  TPatchImportPanel = class(TFrame)
    nbkMain: TbsSkinPageControl;
    bsSkinTabSheet1: TbsSkinTabSheet;
    bsSkinTabSheet2: TbsSkinTabSheet;
    bsSkinTabSheet3: TbsSkinTabSheet;
    pgColumnMappings: TbsSkinTabSheet;
    bsSkinTabSheet5: TbsSkinTabSheet;
    pnlStart1: TbsSkinGroupBox;
    bsSkinTextLabel2: TbsSkinTextLabel;
    pnlMappingsSel: TbsSkinGroupBox;
    bsSkinTextLabel1: TbsSkinTextLabel;
    btnImportGotoRun: TbsSkinStdLabel;
    pnldbContents: TbsSkinGroupBox;
    bsSkinLabel2: TbsSkinLabel;
    dbgTableData: TbsSkinDBGrid;
    bsTableList: TbsSkinListBox;
    pnlDbType: TbsSkinGroupBox;
    pnldbTypeScrolly: TbsSkinScrollPanel;
    rdodbTypedBase: TbsSkinCheckRadioBox;
    rdodbTypeAccess: TbsSkinCheckRadioBox;
    rdodbTypeBorlandBDE: TbsSkinCheckRadioBox;
    rdodbTypeODBC: TbsSkinCheckRadioBox;
    rdoTypeCSV: TbsSkinCheckRadioBox;
    pnldbParams: TbsSkinGroupBox;
    bsSkinButton1: TbsSkinButton;
    bsSkinButton8: TbsSkinButton;
    pnlTableStructInfo: TbsSkinGroupBox;
    bsSkinTextLabel8: TbsSkinTextLabel;
    bsSkinStdLabel3: TbsSkinStdLabel;
    bsSkinStdLabel4: TbsSkinStdLabel;
    bsSkinStdLabel5: TbsSkinStdLabel;
    cbxImport1LevelStockTable: TbsSkinCheckRadioBox;
    cbxImportGroupStockTables: TbsSkinCheckRadioBox;
    cbxImportGroupSubGroupStockTable: TbsSkinCheckRadioBox;
    cbxImport2LevelStockTable: TbsSkinCheckRadioBox;
    pnlTableMap: TbsSkinGroupBox;
    Bevel3: TBevel;
    Bevel5: TBevel;
    Bevel6: TBevel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Bevel4: TBevel;
    Bevel7: TBevel;
    Bevel8: TBevel;
    lblImportProductGroup: TbsSkinLabel;
    txtImportProductGroupDesc: TbsSkinListBox;
    bsSkinLabel19: TbsSkinLabel;
    lblImportProductGroupCodeColumn: TbsSkinLabel;
    lblImportProductGroupDescColumn: TbsSkinLabel;
    cbxProductGroupCodeColumn: TbsSkinComboBox;
    cbxProductGroupNameColumn: TbsSkinComboBox;
    cbxProductGroupTable: TbsSkinComboBox;
    cbxProductTable: TbsSkinComboBox;
    cbxProductGroupColumn: TbsSkinComboBox;
    cbxProductSubGroupCodeColumn: TbsSkinComboBox;
    cbxProductSubGroupTable: TbsSkinComboBox;
    lblImportProductSubGroup: TbsSkinLabel;
    cbxProductSubGroupSubCodeColumn: TbsSkinComboBox;
    cbxProductSubGroupNameColumn: TbsSkinComboBox;
    lblProductFieldLabel: TbsSkinLabel;
    bsSkinLabel4: TbsSkinLabel;
    lstInputFields: TbsSkinListBox;
    bsSkinLabel7: TbsSkinLabel;
    dbgViewData: TbsSkinDBGrid;
    mmoQuery: TbsSkinMemo;
    grdFieldMappings: TbsSkinStringGrid;
    bsSkinButton7: TbsSkinButton;
    btnRemoveColumnMap: TbsSkinButton;
    btnAddColumnMap: TbsSkinButton;
    bsSkinLabel5: TbsSkinLabel;
    btnCancel: TbsSkinButton;
    btnProcess: TbsSkinButton;
    barProgress: TbsSkinGauge;
    pnlReady2Apply: TbsSkinGroupBox;
    bsSkinTextLabel6: TbsSkinTextLabel;
    mmoProgress: TbsSkinMemo;
    bsSkinTabSheet6: TbsSkinTabSheet;
    pnlUpdateRules: TbsSkinGroupBox;
    bsSkinTextLabel3: TbsSkinTextLabel;
    bsSkinCheckRadioBox1: TbsSkinCheckRadioBox;
    bsSkinCheckRadioBox2: TbsSkinCheckRadioBox;
    lblSupplierTable: TbsSkinLabel;
    cbxSupplierTable: TbsSkinComboBox;
    Bevel9: TBevel;
    cbxSupplierCodeColumn: TbsSkinComboBox;
    lblProductSupplierCodeColumn: TbsSkinLabel;
    cbxProductSupplierCodeColumn: TbsSkinComboBox;
    Bevel10: TBevel;
    Bevel11: TBevel;
    pnlNewProductOpts: TbsSkinGroupBox;
    bsSkinCheckRadioBox3: TbsSkinCheckRadioBox;
    pnlDeletedProductOpts: TbsSkinGroupBox;
    pnlUpdateOpts: TbsSkinGroupBox;
    bsSkinCheckRadioBox4: TbsSkinCheckRadioBox;
    bsSkinCheckRadioBox6: TbsSkinCheckRadioBox;
    bsSkinComboBox4: TbsSkinComboBox;
    bsSkinEdit1: TbsSkinEdit;
    bsSkinLabel6: TbsSkinLabel;
    bsSkinLabel8: TbsSkinLabel;
    bsSkinStringGrid1: TbsSkinStringGrid;
    bsSkinLabel9: TbsSkinLabel;
    bsSkinCheckRadioBox7: TbsSkinCheckRadioBox;
    bsSkinCheckListBox1: TbsSkinCheckListBox;
    cbxNoDeleteItems: TbsSkinCheckRadioBox;
    pblSupplierDetails: TbsSkinGroupBox;
    bsSkinLabel10: TbsSkinLabel;
    txtSupplierName: TbsSkinEdit;
    bsSkinLabel11: TbsSkinLabel;
    txtSupplierLocation: TbsSkinEdit;
    txtValidFrom: TbsSkinEdit;
    bsSkinLabel12: TbsSkinLabel;
    bsSkinLabel13: TbsSkinLabel;
    txtValidTo: TbsSkinEdit;
    bsSkinLabel14: TbsSkinLabel;
    txtItemCount: TbsSkinEdit;
    bsSkinTreeView1: TbsSkinTreeView;
    bsSkinLabel15: TbsSkinLabel;
    pnldbaseParams: TbsSkinPanel;
    bsSkinTextLabel4: TbsSkinTextLabel;
    bsSkinLabel16: TbsSkinLabel;
    txtdbaseDir: TbsSkinEdit;
    db1: TDatabase;
    pnlBDEParams: TbsSkinPanel;
    bsSkinTextLabel9: TbsSkinTextLabel;
    bsSkinLabel17: TbsSkinLabel;
    cbxBDEALIAS: TbsSkinComboBox;
    qryTemp: TQuery;
    pnlADOParams: TbsSkinPanel;
    bsSkinTextLabel12: TbsSkinTextLabel;
    bsSkinLabel21: TbsSkinLabel;
    txtAccessdb: TbsSkinEdit;
    pnlCSVParams: TbsSkinPanel;
    bsSkinTextLabel13: TbsSkinTextLabel;
    bsSkinLabel23: TbsSkinLabel;
    txtCSVFile: TbsSkinEdit;
    cbxHasColumnNames: TbsSkinCheckRadioBox;
    rdoImportCommas: TbsSkinCheckRadioBox;
    rdoImportTabs: TbsSkinCheckRadioBox;
    dlgOpen: TbsSkinOpenDialog;
    bsSkinMessage1: TbsSkinMessage;
    tblTemp: TTable;
    qrySourceData: TQuery;
    dsSourceData: TDataSource;
	cbxNew: TbsSkinCheckRadioBox;
    cbsImportUseMap: TbsSkinCheckRadioBox;
    cbsImportDeleteMap: TbsSkinCheckRadioBox;
	optExportCSV: TbsSkinCheckRadioBox;
	optExportDatabase: TbsSkinCheckRadioBox;
    optExportSync: TbsSkinCheckRadioBox;
    optExportCompare: TbsSkinCheckRadioBox;
    dsLoadMappings: TDataSource;
    qryLoadMappings: TQuery;
    lstMappings: TbsSkinListBox;
    btnNext1: TbsSkinButton;
    btnNext2: TbsSkinButton;
    btnNext3: TbsSkinButton;
    btnNext4: TbsSkinButton;
    btnNext5: TbsSkinButton;
    btnSaveMapping: TbsSkinButton;
    bsSkinButton10: TbsSkinButton;
    bsSkinButton12: TbsSkinButton;
    bsSkinButton13: TbsSkinButton;
    bsSkinButton14: TbsSkinButton;
    btnNext6: TbsSkinButton;
    tblSysVal: TTable;
    dbgUpdates: TbsSkinDBGrid;
    tblProductUpdates: TTable;
    dsProductUpdates: TDataSource;
    sbUpdates: TbsSkinScrollBar;
    bsSkinLabel18: TbsSkinLabel;
    txtRevisionNumber: TbsSkinEdit;
    qryPurgeRevisions: TQuery;
    dlgSaveProfileName: TbsSkinInputDialog;
    cbxHaveSupplierTable: TbsSkinCheckRadioBox;
    bsSkinLabel1: TbsSkinLabel;
    txtSupplierCode: TbsSkinEdit;
    DTable1: TDTable;
    DQuery1: TDQuery;
    qryADOTemp: TDQuery;
    dbADO: TDMaster;
    qryADOSourceData: TDQuery;
    procedure bsSkinButton1Click(Sender: TObject);
    procedure rdodbTypedBaseClick(Sender: TObject);
    procedure rdodbTypeBorlandBDEClick(Sender: TObject);
    procedure rdodbTypeAccessClick(Sender: TObject);
    procedure rdoTypeCSVClick(Sender: TObject);
    procedure txtCSVFileButtonClick(Sender: TObject);
    procedure bsTableListListBoxClick(Sender: TObject);
    procedure bsSkinButton8Click(Sender: TObject);
    procedure txtAccessdbButtonClick(Sender: TObject);
    procedure cbxProductGroupTableChange(Sender: TObject);
    procedure cbxProductTableChange(Sender: TObject);
    procedure cbxSupplierTableChange(Sender: TObject);
    procedure nbkMainChanging(Sender: TObject;
      var AllowChange: Boolean);
    procedure cbxImport1LevelStockTableClick(Sender: TObject);
    procedure cbxImport2LevelStockTableClick(Sender: TObject);
    procedure cbxImportGroupStockTablesClick(Sender: TObject);
    procedure cbxImportGroupSubGroupStockTableClick(Sender: TObject);
    procedure btnProcessClick(Sender: TObject);
    procedure btnAddColumnMapClick(Sender: TObject);
    procedure btnRemoveColumnMapClick(Sender: TObject);
    procedure btnSaveMappingClick(Sender: TObject);
    procedure cbxHaveSupplierTableClick(Sender: TObject);
    procedure lstMappingsListBoxDblClick(Sender: TObject);
    procedure btnNext2Click(Sender: TObject);
  protected
    { Protected declarations }
  private
    { Private declarations }
    dbProfileName       : String;

    mRevisionNo         : Integer;

    mTradalog,

    bdFieldMap,
    Doc1InvtItems,
    Doc2TLogItems       : GTDBizDoc;

    Diffs,
    InsertionItems,
    DeletionItems,
    ChangeItems,

    TextFileFields,
    TextFileRecord,
    TextFileData        : TStringList;

    fSkinData           : TbsSkinData ;

    ce                  : TDConnectionEditor;

    function ReadTextFileLine(Dest : TStringList; const L : String):Boolean;
    procedure LoadFieldList(TableName : String; AddTableName : Boolean; StringListDest : TStrings);
    procedure SetupProductFieldList;
    procedure ReadTableNames;
    procedure DisplayProductTableFields;
    function  FindColumnNameOf(ADefinedElementName : String):String;
    function LoadImportMapping(MapName : String):Boolean;
    function SaveImportMapping(MapName : String):Boolean;

    // -- Procedures for the actual patch run
    function InitPatchRun:Boolean;
    function LoadTradalogCodes:Boolean;
    function LoadInventoryCodes:Boolean;
    function FindAdditionsRemovals:Boolean;
    function LoadTradalogItemDetails:Boolean;
    function LoadInventoryItemDetails:Boolean;
    function FindFieldChanges:Boolean;
    function ResortOnProductCode:Boolean;
    function DetermineUpdateQueries:Boolean;
    function ApplyUpdates:Boolean;

    function ExportToDB:Boolean;
    function ExportToCSV:Boolean;

    procedure SetupBlankTableNames;
    procedure Clear;

  public
    { Public declarations }
    reportOnly  : Boolean;

    function OpenUserdb:Boolean;
    procedure CloseUserdb;

    procedure Init;

    function OpenTradalog(myDoc : GTDBizDoc):Boolean;

    function Run:Boolean;

    function ApplyTradalog:Boolean;
    procedure SetSkinData(Value: TbsSkinData); {override;}
    procedure BuildReport(const mType : String; const Msg : String);
  published
    property SkinData   : TbsSkinData read fSkinData write SetSkinData;

  end;

implementation
uses bde;

{$R *.DFM}
function TPatchImportPanel.OpenUserdb:Boolean;
begin
    // Set the neccessary properties to open your database
    db1.Connected := False;
    db1.LoginPrompt := False;
    db1.Params.Clear;

    // -- Different settings will need to be loaded
    if (rdodbTypedBase.Checked) then
    begin
        db1.DatabaseName := txtdbaseDir.Text;
        db1.AliasName    := '';

        // -- Now try to open the database
        db1.Connected := True;

    end
    else if (rdodbTypeBorlandBDE.Checked) then
    begin
        db1.DatabaseName := 'SourceDB';
        db1.AliasName    := cbxBDEALIAS.Text;

        // -- Now try to open the database
        db1.Connected := True;

    end
    else if (rdodbTypeAccess.Checked) then
    begin
        // -- Setup to use Access
		dbADO.Connection := txtAccessdb.Text;
		dbADO.Connected := True;
    end
    else if (rdoTypeCSV.Checked) then
    begin
        db1.DatabaseName := ExtractFilePath(Application.ExeName);
        db1.AliasName    := '';

        // -- Now try to open the database
        db1.Connected := True;

    end;

    // -- Read out all the table names
    ReadTableNames;

    DisplayProductTableFields;

    // -- Fill relationships
    cbxSupplierTable.Items.Assign(bsTableList.Items);
    cbxProductGroupTable.Items.Assign(bsTableList.Items);
    cbxProductSubGroupTable.Items.Assign(bsTableList.Items);
    cbxProductTable.Items.Assign(bsTableList.Items);
end;

procedure TPatchImportPanel.bsSkinButton1Click(Sender: TObject);
begin
    OpenUserdb;

    bsSkinButton8.Visible := True;
end;

procedure TPatchImportPanel.ReadTableNames;
var
  hCursor: hDBICur;        // Cursor for table and query names
  ListDesc: TBLBaseDesc;   // Record of the cursor
begin
  bsTableList.Clear;
  try

    if rdodbTypeAccess.Checked then
    begin
        // -- ADO Data
        dbADO.CentralData.GetADOTableNames(bsTableList.Items);
    end
    else begin
        // -- BDE Data

        // -- Generates a cursor with all table and query names
        Check(DbiOpenTableList(db1.Handle, False, False, '*', hCursor));

        // -- Move thru the records of the cursor to get the names
        while (DbiGetNextRecord(hCursor, dbiNOLOCK, @ListDesc, nil)
              = dbiErr_None) do
        if ListDesc.bView then     // Is it a query?
          bsTableList.Items.Add(ListDesc.szName)
          else
            bsTableList.Items.Add(ListDesc.szName);

        // Close the cursor
        dbiCloseCursor(hCursor);

    end;

  except
    raise;
  end;
end;

procedure TPatchImportPanel.DisplayProductTableFields;

    procedure AddField(FieldName : String);
    begin
    end;

    procedure ReadFieldsOfOneTable(TableName : String);
    var
        xc : Integer;
    begin
        if rdodbTypeAccess.Checked then
        begin
            // --
            with qryADOTemp do
            begin
                Active := False;

                // -- Set database access parameters
                Connection := dbADO.Connection;

                SQL.Clear;
                SQL.Add('Select * from ' + TableName);
                Active := True;

                for xc := 1 to Fields.Count do
                begin
                    lstInputFields.Items.Add(TableName + '.' + FieldDefs[xc-1].Name);
                end;

            end;
        end
        else begin
            // -- BDE
            with qryTemp do
            begin
                Active := False;
                if (db1.AliasName <> '') then
                    DatabaseName := db1.AliasName
                else
                    DatabaseName := db1.DatabaseName;
                SQL.Clear;
                SQL.Add('Select * from ' + TableName);
                Active := True;

                for xc := 1 to Fields.Count do
                begin
                    lstInputFields.Items.Add(FieldDefs[xc-1].Name);
                    // lstInputFields.Items.Add(TableName + '.' + FieldDefs[xc-1].Name);
                end;

            end;
        end;
    end;

var
    tablename : String;
    xc,xd : Integer;
begin
    lstInputFields.Items.Clear;

    if (cbxProductTable.Text = '') then
        Exit;

    for xc := 1 to 1 do
    begin

        tablename := cbxProductTable.Text;

        if (Pos(' ',TableName) <> 0) then
        begin
            if rdodbTypeAccess.Checked then
                TableName := '[' + TableName + ']'
            else
                TableName := '"' + TableName + '"'
        end;

        ReadFieldsOfOneTable(TableName);

    end;

end;

procedure TPatchImportPanel.rdodbTypedBaseClick(Sender: TObject);
begin
    pnlCSVParams.Visible := False;
    pnlBDEParams.Visible := False;
    pnlADOParams.Visible := False;
    pnlDBaseParams.Visible := True;
end;

procedure TPatchImportPanel.rdodbTypeBorlandBDEClick(Sender: TObject);
begin
    pnlBDEParams.Top  := pnldbaseParams.Top;
    pnlBDEParams.Left := pnldbaseParams.Left;
    pnlBDEParams.Height := pnldbaseParams.Height;
    pnlBDEParams.BorderStyle := bvNone;
    pnlBDEParams.Visible := True;
    pnlADOParams.Visible := False;
    pnlDBaseParams.Visible := False;
    pnlCSVParams.Visible := False;

    // -- Also get aliases
    GetAliases(cbxBDEALIAS.Items,'');

end;

procedure TPatchImportPanel.rdodbTypeAccessClick(Sender: TObject);
begin
    pnlADOParams.Top  := pnldbaseParams.Top;
    pnlADOParams.Left := pnldbaseParams.Left;
    pnlADOParams.Height := pnldbaseParams.Height;
    pnlADOParams.BorderStyle := bvNone;
    pnlADOParams.Visible := True;
    pnlBDEParams.Visible := False;
    pnlDBaseParams.Visible := False;
    pnlCSVParams.Visible := False;
end;

procedure TPatchImportPanel.rdoTypeCSVClick(Sender: TObject);
begin
    pnlCSVParams.Top  := pnldbaseParams.Top;
    pnlCSVParams.Left := pnldbaseParams.Left;
    pnlCSVParams.Height := pnldbaseParams.Height;
    pnlCSVParams.BorderStyle := bvNone;
    pnlCSVParams.Visible := True;
    pnlBDEParams.Visible := False;
    pnlDBaseParams.Visible := False;
    pnlADOParams.Visible := False;
end;

procedure TPatchImportPanel.txtCSVFileButtonClick(Sender: TObject);
var
    xc,xd,sl : Integer;
    s  : String;
begin
    // -- Open up the database select
    if dlgOpen.Execute then
    begin
        // -- Set the filename
        txtCSVFile.Text := dlgOpen.Filename;

        // -- Now load the data up
        TextFileData.LoadFromFile(txtCSVFile.Text);

        try

            if cbxHasColumnNames.Checked then
            begin

                // -- Check the first line to determine delimiters
                s := TextFileData.Strings[0];
                for xc := 1 to Length(s) do
                begin
                    if (s[xc] = #9) then
                    begin
                        rdoImportTabs.Checked := True;
                        break;
                    end
                    else if (s[xc] = ',') then
                    begin
                        rdoImportCommas.Checked := True;
                        break;
                    end;
                end;

                // --
                ReadTextFileLine(TextFileFields,TextFileData.Strings[0]);

                // -- Display what we have
                s := 'These columns will be added : ' + #13;
                for xc := 1 to TextFileFields.Count do
                    s := s + TextFileFields.Strings[xc-1] + #13;

                bsSkinMessage1.MessageDlg(s,mtInformation,[mbOk],0);

            end;

            // --
            with tblTemp do
            begin

                Active := False;

                // -- If our table exists, then purge it
                if FileExists(TableName) then
                    DeleteTable;

                with FieldDefs do
                begin

                    Clear;

                    for xc := 1 to TextFileFields.Count do
                        // -- Add the new field
                        with AddFieldDef do
                        begin
                            Name := TextFileFields.Strings[xc-1];
                            DataType := ftString;
                            Size := 30;
                        end;

                end;

                // -- Now create the table
                CreateTable;

                // -- Now open the table
                Active := True;

                // -- Now process every line
                if cbxHasColumnNames.Checked then
                    sl := 2
                else
                    sl := 1;

                for xc := sl to TextFileData.Count do
                begin
                    // -- Read each line
                    ReadTextFileLine(TextFileRecord,TextFileData.Strings[xc-1]);

                    Append;

                    for xd := 1 to Fields.Count do
                    begin
                        if xd < TextFileRecord.Count then
                            Fields[xd-1].AsString := TextFileRecord.Strings[xd-1];
                    end;

                    Post;
                end;

            end;

            // -- Now that the table is created, pass it over
            OpenUserDB;

            // -- Autoselect the first item
            if bsTableList.Items.Count > 0 then
            begin
                // -- Automatically open the file and display
                bsTableList.ItemIndex := bsTableList.Items.IndexOf(tblTemp.TableName);
                bsTableListListBoxClick(Sender);

                // -- Set
                cbxProductTable.ItemIndex := 0;

            end;
                
        finally
            TextFileData.Clear;
        end;
    end;
end;

function TPatchImportPanel.ReadTextFileLine(Dest : TStringList; const L : String):Boolean;
const
    lDelim = #13#10;
var
    xc,fState,fNum : Integer;
    c,fDelim  : Char;
    isString  : Boolean;
    r : String;
begin
    fState := 0;
    fNum   := 0;

    if rdoImportCommas.Checked then
        fdelim := ','
    else
        fDelim := #9;

    // -- Clear out any previous values
    Dest.Clear;

    for xc := 1 to Length(L) do
    begin
        // -- Load up the character
        c := L[xc];
        case fState of
            0 : begin
                    if (c = '"') then
                        isString := True
                    else
                        isString := False;

                    if not isString then
                        R := R + c;

                    fState := 1;
                end;
            1 : begin
//                    if (((c = '"') or ((c = ',') and not isString))) then
                    if ((c = fdelim) and not isString) then
                    begin
                        fState := 0;
                        Inc(fNum);
                        Dest.Add(R);
                        R := '';
                    end
                    else if ((c = '"') and IsString) then
                        IsString := False
                    else
                        R := R + c;

                end;
        end;
    end;

    if r <> '' then
        Dest.Add(R);

    Result := True;
end;

procedure TPatchImportPanel.bsTableListListBoxClick(Sender: TObject);
var
    tablename : String;
    xc : Integer;
begin
    if bsTableList.ItemIndex = -1 then
        Exit;

    tablename := bsTableList.Items[bsTableList.ItemIndex];

    try
        Screen.Cursor := crHourglass;

        if (Pos(' (Table)',TableName) <> 0) then
            TableName := Copy(TableName,1,Length(TableName)-8)
        else if (Pos(' (Query)',TableName) <> 0) then
            TableName := Copy(TableName,1,Length(TableName)-8);

        if (rdodbTypeAccess.Checked) then
        begin
			dsSourceData.DataSet := qryADOSourceData;

            if (Pos(' ',TableName) <> 0) then
            begin
                TableName := '[' + TableName + ']';
            end;

            with qryADOSourceData do
            begin
                // --
                Active := False;

                Connection := dbADO.Connection;

                sql.Clear;
                SQL.Add('Select * from ' + TableName);

                Active := True;
            end;
        end
        else begin

            dsSourceData.DataSet := qrySourceData;

            if (Pos(' ',TableName) <> 0) then
            begin
                TableName := '"' + TableName + '"';
            end;

            with qrySourceData do
            begin
                // --
                Active := False;

                DatabaseName := db1.DatabaseName;

                sql.Clear;
                SQL.Add('Select * from "' + TableName + '"');

                Active := True;
            end;
        end;
        
        dbgTableData.Visible := True;
//        sbhtabledata.Visible := True;
//        sbvtabledata.Visible := True;

    finally
        Screen.Cursor := crDefault;
    end;
end;

procedure TPatchImportPanel.CloseUserdb;
begin
    dbADO.Connected := False;
    db1.Connected := False;
    bsTableList.Items.Clear;
end;

procedure TPatchImportPanel.bsSkinButton8Click(Sender: TObject);
begin
    CloseUserdb;
end;

procedure TPatchImportPanel.txtAccessdbButtonClick(Sender: TObject);
begin
    if not Assigned(ce) then
        // -- For editing ADO connections
        ce := TDConnectionEditor.Create(Self);

    if ce.Execute then
    begin
        txtAccessdb.Text := ce.Connection;
    end;

end;

procedure TPatchImportPanel.cbxProductGroupTableChange(Sender: TObject);
begin
    // -- Load up the columns for this table
    LoadFieldList(cbxProductGroupTable.Text, False, cbxProductGroupCodeColumn.Items);
    LoadFieldList(cbxProductGroupTable.Text, False, cbxProductGroupNameColumn.Items);

    cbxProductGroupCodeColumn.Text := '';
    cbxProductGroupNameColumn.Text := '';

end;

procedure TPatchImportPanel.cbxProductTableChange(Sender: TObject);
begin
    LoadFieldList(cbxProductTable.Text, False, cbxProductGroupColumn.Items);
    LoadFieldList(cbxProductTable.Text, False, cbxProductSupplierCodeColumn.Items);

    cbxProductGroupColumn.Text := '';

    if ((rdodbTypeAccess.Checked) and dbADO.Connected) or
        ((rdodbTypedBase.Checked or rdodbTypeBorlandBDE.Checked) and db1.Connected) then
        DisplayProductTableFields;

end;

procedure TPatchImportPanel.LoadFieldList(TableName : String; AddTableName : Boolean; StringListDest : TStrings);
var
    xc : Integer;
begin
    // -- We really can't do anything if the db is closed
    if ((rdodbTypeAccess.Checked) and not dbADO.Connected) or
        ((rdodbTypedBase.Checked or rdodbTypeBorlandBDE.Checked) and not db1.Connected) then
        Exit;

    if (rdodbTypeAccess.Checked) then
    begin

        // -- Correct for bugs in the ADO library
        if (Pos(' ',TableName) <> 0) then
        begin
            TableName := '[' + TableName + ']';
        end;

        dbADO.CentralData.GetADOFieldNames(TableName,StringListDest);
    end
    else
        with qryTemp do
        begin
            Active := False;

            if (db1.AliasName <> '') then
                DatabaseName := db1.AliasName
            else
                DatabaseName := db1.DatabaseName;
            SQL.Clear;

            // -- Clean up the string if neccessary
            if (Pos(' (Table)',TableName) <> 0) then
                TableName := Copy(TableName,1,Length(TableName)-8)
            else if (Pos(' (Query)',TableName) <> 0) then
                TableName := Copy(TableName,1,Length(TableName)-8);

            SQL.Add('Select * from "' + TableName + '"');
            Active := True;

            for xc := 1 to Fields.Count do
            begin
                if AddTableName then
                    StringListDest.Add(TableName + '.' + FieldDefs[xc-1].Name)
                else
                    StringListDest.Add(FieldDefs[xc-1].Name);
            end;

        end;
end;

procedure TPatchImportPanel.cbxSupplierTableChange(Sender: TObject);
begin
    LoadFieldList(cbxSupplierTable.Text, False, cbxSupplierCodeColumn.Items);

    cbxSupplierCodeColumn.Text := '';

end;

procedure TPatchImportPanel.SetupProductFieldList;

    procedure AddColumn(FieldName : String);
    begin
        grdFieldMappings.Cells[0,grdFieldMappings.RowCount-1] := FieldName;
        grdFieldMappings.RowCount := grdFieldMappings.RowCount + 1;
    end;

begin
    // -- Initialise the Grid
    grdFieldMappings.RowCount := 2;
    grdFieldMappings.FixedRows := 1;
    grdFieldMappings.Cells[0,0] := 'Tradalog';
    grdFieldMappings.Cells[1,0] := 'Your db';

    // -- Standard Product Line Item fields
    AddColumn(GTD_PL_ELE_PRODUCT_CODE);         //     = 'Product_ID';
    AddColumn(GTD_PL_ELE_PRODUCT_NAME);         //     = 'Name';
    AddColumn(GTD_PL_ELE_PRODUCT_DESC);         //     = 'Description';
    AddColumn(GTD_PL_ELE_PRODUCT_LIST);         //     = 'List_Price';
    AddColumn(GTD_PL_ELE_PRODUCT_SELL);         //     = 'Your_Price';
    AddColumn(GTD_PL_ELE_PRODUCT_TAXR);         //     = 'Tax_Rate';
    AddColumn(GTD_PL_ELE_PRODUCT_TAXT);         //     = 'Tax_Type';
	AddColumn(GTD_PL_ELE_PRODUCT_BRAND);         //     = 'Manufacturer';
	AddColumn(GTD_PL_ELE_PRODUCT_UNIT);         //     = 'Unit';
    AddColumn(GTD_PL_ELE_PRODUCT_TYPE);         //     = 'Product_Type';
    AddColumn(GTD_PL_ELE_PRODUCT_MOREINFO);     // = 'Further_Info_URL';
    AddColumn(GTD_PL_ELE_BRANDNAME);            //        = 'Brand_Name';
    AddColumn(GTD_PL_ELE_MANUFACT_NAME);        //    = 'Manufacturer.Name';
    AddColumn(GTD_PL_ELE_MANUFACT_GTL);         //     = 'Manufacturer.GTL';
    AddColumn(GTP_PL_ELE_MANUFACT_PRODINFO);    //= 'Manufacturer.Product_URL';
    AddColumn(GTD_PL_ELE_PRODUCT_AVAIL_FLAG);   // = 'Availability.Flag';
    AddColumn(GTD_PL_ELE_PRODUCT_AVAIL_DATE);   // = 'Availability.Date';
    AddColumn(GTD_PL_ELE_PRODUCT_AVAIL_STATUS); // = 'Availability.Status';
    AddColumn(GTD_PL_ELE_PRODUCT_AVAIL_BACKORD); //= 'Availability.OnBackOrder';
    AddColumn(GTD_PL_ELE_ONSPECIAL);
    AddColumn(GTD_PL_ELE_ONSPECIAL_TILL);
    AddColumn(GTD_PL_PRODUCT_IMAGE_TAG + '.' + GTD_PL_ELE_PRODUCT_IMAGE_ID);

    // -- Chop the last row, it should be blank
    grdFieldMappings.RowCount := grdFieldMappings.RowCount - 1;

end;

procedure TPatchImportPanel.nbkMainChanging(Sender: TObject;
  var AllowChange: Boolean);
begin
    SetupProductFieldList;
end;

procedure TPatchImportPanel.cbxImport1LevelStockTableClick(
  Sender: TObject);
var
    ShowIt : Boolean;
begin
    ShowIt := not cbxImport1LevelStockTable.Checked;

    // -- Hide/Show the Product Table Code Column
    lblProductFieldLabel.Visible  := False;
    cbxProductGroupColumn.Visible := False;
//    txtImportProductDesc.Top := cbxProductTable.Top + cbxProductTable.Height;
//    txtImportProductDesc.Height :=

    Bevel3.Visible := ShowIt;
    Bevel5.Visible := ShowIt;
    Bevel6.Visible := ShowIt;
    Bevel7.Visible := ShowIt;
    lblImportProductGroup.Visible := ShowIt;
    cbxProductGroupTable.Visible := ShowIt;
    txtImportProductGroupDesc.Visible := ShowIt;
    lblImportProductGroupCodeColumn.Visible := ShowIt;
    cbxProductGroupCodeColumn.Visible := ShowIt;
    lblImportProductGroupDescColumn.Visible := ShowIt;
    cbxProductGroupNameColumn.Visible := ShowIt;

    // -- SubGroup stuff
    Bevel1.Visible := ShowIt;
    Bevel2.Visible := ShowIt;
    Bevel4.Visible := ShowIt;

    lblImportProductSubGroup.Visible := ShowIt;
    cbxProductSubGroupTable.Visible := ShowIt;
    cbxProductSubGroupCodeColumn.Visible := ShowIt;
    // txtImportProductSubGroupDesc.Visible := ShowIt;
    cbxProductSubGroupSubCodeColumn.Visible := ShowIt;
    cbxProductSubGroupNameColumn.Visible := ShowIt;

    // -- if some default table names are needed
    SetupBlankTableNames;

end;

procedure TPatchImportPanel.cbxImport2LevelStockTableClick(
  Sender: TObject);
var
    ShowIt : Boolean;
begin
    ShowIt := not cbxImport2LevelStockTable.Checked;

    // -- Hide/Show the Product Table Code Column
    lblProductFieldLabel.Visible  := True;
    cbxProductGroupColumn.Visible := True;
    lblProductFieldLabel.Caption := 'Product Group Column';

    Bevel3.Visible := ShowIt;
    Bevel5.Visible := ShowIt;
    Bevel6.Visible := ShowIt;
    Bevel7.Visible := ShowIt;
    lblImportProductGroup.Visible := ShowIt;
    cbxProductGroupTable.Visible := ShowIt;
    txtImportProductGroupDesc.Visible := ShowIt;
    lblImportProductGroupCodeColumn.Visible := ShowIt;
    cbxProductGroupCodeColumn.Visible := ShowIt;
    lblImportProductGroupDescColumn.Visible := ShowIt;
    cbxProductGroupNameColumn.Visible := ShowIt;

    // -- SubGroup stuff
    Bevel1.Visible := ShowIt;
    Bevel2.Visible := ShowIt;
    Bevel4.Visible := ShowIt;
    lblImportProductSubGroup.Visible := ShowIt;
    cbxProductSubGroupTable.Visible := ShowIt;
    cbxProductSubGroupCodeColumn.Visible := ShowIt;
    // txtImportProductSubGroupDesc.Visible := ShowIt;
    cbxProductSubGroupSubCodeColumn.Visible := ShowIt;
    cbxProductSubGroupNameColumn.Visible := ShowIt;
end;

procedure TPatchImportPanel.cbxImportGroupStockTablesClick(
  Sender: TObject);
var
    ShowIt : Boolean;
begin
    ShowIt := cbxImportGroupStockTables.Checked;

    // -- Hide/Show the Product Table Code Column
    lblProductFieldLabel.Visible  := True;
    cbxProductGroupColumn.Visible := True;
    lblProductFieldLabel.Caption := 'Product Group Code Column';

    lblImportProductGroup.Visible := ShowIt;
    cbxProductGroupTable.Visible := ShowIt;
    txtImportProductGroupDesc.Visible := ShowIt;
    lblImportProductGroupCodeColumn.Visible := ShowIt;
    cbxProductGroupCodeColumn.Visible := ShowIt;
    lblImportProductGroupDescColumn.Visible := ShowIt;
    cbxProductGroupNameColumn.Visible := ShowIt;
    Bevel5.Visible := ShowIt;
    Bevel3.Visible := ShowIt;
    Bevel6.Visible := ShowIt;

    // -- Subgroup stuff
    Bevel1.Visible := not ShowIt;
    Bevel2.Visible := not ShowIt;
    Bevel4.Visible := not ShowIt;
    Bevel7.Visible := not ShowIt;
    Bevel8.Visible := not ShowIt;
    lblImportProductSubGroup.Visible := not ShowIt;
    cbxProductSubGroupTable.Visible := not ShowIt;
    cbxProductSubGroupCodeColumn.Visible := not ShowIt;
    cbxProductSubGroupSubCodeColumn.Visible := not ShowIt;
    cbxProductSubGroupNameColumn.Visible := not ShowIt;
    //txtImportProductSubGroupDesc.Visible := not ShowIt;

end;

procedure TPatchImportPanel.cbxImportGroupSubGroupStockTableClick(
  Sender: TObject);
var
    ShowIt : Boolean;
begin
    ShowIt := cbxImportGroupSubGroupStockTable.Checked;

    // -- Hide/Show the Product Table Code Column
    lblProductFieldLabel.Visible  := True;
    cbxProductGroupColumn.Visible := True;
    lblProductFieldLabel.Caption := 'Product Group Code Column';

    Bevel3.Visible := not ShowIt;
    Bevel5.Visible := ShowIt;
    Bevel6.Visible := not ShowIt;
    lblImportProductGroup.Visible := ShowIt;
    cbxProductGroupTable.Visible := ShowIt;
    txtImportProductGroupDesc.Visible := ShowIt;
    lblImportProductGroupCodeColumn.Visible := ShowIt;
    cbxProductGroupCodeColumn.Visible := ShowIt;
    lblImportProductGroupDescColumn.Visible := ShowIt;
    cbxProductGroupNameColumn.Visible := ShowIt;
    Bevel2.Visible := ShowIt;
    Bevel4.Visible := ShowIt;
    Bevel1.Visible := ShowIt;
    Bevel7.Visible := ShowIt;
    Bevel8.Visible := ShowIt;
    lblImportProductSubGroup.Visible := ShowIt;
    cbxProductSubGroupTable.Visible := ShowIt;
    cbxProductSubGroupCodeColumn.Visible := ShowIt;
    cbxProductSubGroupSubCodeColumn.Visible := ShowIt;
    cbxProductSubGroupNameColumn.Visible := ShowIt;
    //txtImportProductSubGroupDesc.Visible := ShowIt;
end;

function TPatchImportPanel.ApplyTradalog:Boolean;
var
    pg,pgc,sg,sgc : Integer;
begin
    // -- Loop through each of the selected product groups
    for pg := 1 to pgc do
    begin
        for sg := 1 to sgc do
        begin
        end;
    end;
end;

function TPatchImportPanel.OpenTradalog(myDoc : GTDBizDoc):Boolean;
var
    VendorInfoNode : GTDNode;
begin
    VendorInfoNode := GTDNode.Create;

    if VendorInfoNode.LoadFromDocument(myDoc,GTD_PL_VENDORINFO_NODE,True) then
    begin
        // -- Basic Vendor details

        // -- If the node doesn't exist then exit
        {
        Trader_GTL              := VendorInfoNode.ReadStringField(GTD_PL_ELE_COMPANY_CODE);
        Trader_Name 			:= VendorInfoNode.ReadStringField(GTD_PL_ELE_COMPANY_NAME);
        Trader_Street_Address	:= VendorInfoNode.ReadStringField(GTD_PL_ELE_ADDRESS_LINE_1);
                            s   := VendorInfoNode.ReadStringField(GTD_PL_ELE_ADDRESS_LINE_2);
        if Length(s) <> 0 then
            Trader_Street_Address := Trader_Street_Address + #13 + s;

        Trader_City_Town		:= VendorInfoNode.ReadStringField(GTD_PL_ELE_TOWN);
        Trader_Postcode_ZIP		:= VendorInfoNode.ReadStringField(GTD_PL_ELE_POSTALCODE);
        Trader_State_Province	:= VendorInfoNode.ReadStringField(GTD_PL_ELE_STATE_REGION);

        Trader_CountryCode      := VendorInfoNode.ReadStringField(GTD_PL_ELE_COUNTRYCODE);
        Trader_CountryName      := GetNameFromCountryCode(Trader_CountryCode);
        Trader_Phone			:= VendorInfoNode.ReadStringField(GTD_PL_ELE_TELEPHONE);
        Trader_Fax				:= VendorInfoNode.ReadStringField(GTD_PL_ELE_FAX);

        Trader_RegistrationText := VendorInfoNode.ReadStringField(GTD_PL_ELE_OTHER_INFO);
        txtGTL.Text             := Trader_GTL;
        }

        txtSupplierName.Text    := VendorInfoNode.ReadStringField(GTD_PL_ELE_COMPANY_NAME);
        txtSupplierLocation.Text:= VendorInfoNode.ReadStringField(GTD_PL_ELE_TOWN) + ', ' + VendorInfoNode.ReadStringField(GTD_PL_ELE_STATE_REGION);
        txtValidFrom.Text       := FormatDateTime('c',Date - 14);
        txtValidTo.Text         := FormatDateTime('c',Date + 14);

        {
        txtAddress_1.Text       := VendorInfoNode.ReadStringField(GTD_PL_ELE_ADDRESS_LINE_1);
        txtAddress_2.Text       := VendorInfoNode.ReadStringField(GTD_PL_ELE_ADDRESS_LINE_2);
        txtPostCodeZip.Text     := Trader_Postcode_ZIP;
        txtCountry.ItemIndex    := txtCountry.Items.IndexOf(Trader_CountryName);
        txtStateProvince.ItemIndex := txtStateProvince.Items.IndexOf(Trader_State_Province);
        if txtStateProvince.ItemIndex = -1 then
        begin
            txtStateProvince.Items.Insert(0,Trader_State_Province);
            txtStateProvince.ItemIndex := 0;
        end;
        txtTelephone.Text       := Trader_Phone;
        txtFascimile.Text       := Trader_Fax;
        }
    end;

    // -- Now load the document accross
    if not Assigned(mTradalog) then
        mTradalog := GTDBizDoc.Create(Self);
    mTradalog.Clear;
    mTradalog.XML.Assign(myDoc.XML);

    // -- Switch to the first page
    nbkMain.ActivePageIndex := 0;

    VendorInfoNode.Destroy;

end;

procedure TPatchImportPanel.SetSkinData(Value: TbsSkinData);

    procedure SkinaPanel(where : TWinControl);
    var
        I: Integer;
    begin

        with where do
        begin
          for I := 0 to Where.ControlCount - 1 do
            if Where.Controls[I] is TbsSkinControl
            then
                TbsSkinControl(Where.Controls[I]).SkinData := Value;
        end;

        TbsSkinControl(where).SkinData := Value;

    end;

var
	xc : Integer;
begin

    nbkMain.SkinData := Value;

    SkinaPanel(pnlStart1);
    SkinaPanel(pblSupplierDetails);
    SkinaPanel(pnlMappingsSel);
    SkinaPanel(pnlDbType);
    SkinaPanel(pnldbTypeScrolly);
    SkinaPanel(pnldbParams);
    SkinaPanel(pnldbContents);
    SkinaPanel(pnlTableStructInfo);
    SkinaPanel(pnlTableMap);
    SkinaPanel(pnlUpdateRules);
    SkinaPanel(pnlNewProductOpts);
    SkinaPanel(pnlDeletedProductOpts);
    SkinaPanel(pnlReady2Apply);
    SkinaPanel(pnlUpdateOpts);

    dbgUpdates.SkinData := Value;
    sbUpdates.SkinData := Value;

    btnNext1.SkinData := Value;
    btnNext2.SkinData := Value;
    btnNext3.SkinData := Value;
    btnNext4.SkinData := Value;
    btnNext5.SkinData := Value;
    btnNext6.SkinData := Value;

    dlgSaveProfileName.SkinData := Value;
    dlgSaveProfileName.CtrlSkinData := Value;
    bsSkinMessage1.SkinData := Value;
    bsSkinMessage1.CtrlSkinData := Value;

//  inherited;
end;

function TPatchImportPanel.InitPatchRun:Boolean;
begin
    // -- Initialise or clear
    if not Assigned(Doc1InvtItems) then
        Doc1InvtItems := GTDBizDoc.Create(Self)
    else
        Doc1InvtItems.Clear;

    if not Assigned(Doc2TLogItems) then
        Doc2TLogItems := GTDBizDoc.Create(Self)
    else
        Doc2TLogItems.Clear;

    if not Assigned(Diffs) then
        Diffs := TStringList.Create
    else
        Diffs.Clear;

    if not Assigned(InsertionItems) then
        InsertionItems := TStringList.Create
    else
        InsertionItems.Clear;

    if not Assigned(DeletionItems) then
        DeletionItems := TStringList.Create
    else
        DeletionItems.Clear;

    if not Assigned(ChangeItems) then
        ChangeItems := TStringList.Create
    else
        ChangeItems.Clear;

    mmoProgress.Clear;

    // -- Now open tables
    if not tblSysVal.Active then
        tblSysVal.Active := True;

    // -- Remove any old revisions
    qryPurgeRevisions.ParamByName('TraderNo').AsInteger := mTradalog.Owned_By;
    qryPurgeRevisions.ParamByName('Revision').AsInteger := mRevisionNo;
    qryPurgeRevisions.ExecSQL;

    if not tblProductUpdates.Active then
        tblProductUpdates.Active := True;

end;

function TPatchImportPanel.LoadTradalogCodes:Boolean;
var
    myList : TStringList;

    procedure BuildCodesByScanningGroups;
    var
        l1c,l2c,ic : Integer;
        s,t,inodeaddr,pcode : String;
    begin
        for l1c := 1 to mTradalog.NodeCount(GTD_PL_PRODUCTGROUP_NODE) do
        begin
            // -- Calculate the address of the level1 node
            s := GTD_PL_PRODUCTINFO_NODE + GTD_PL_PRODUCTGROUP_NODE + '[' + IntToStr(l1c) + ']' + GTD_PL_PRODUCTITEMS_NODE + GTD_PL_PRODUCTITEM_NODE;

            // -- For all the items in the major group
            for ic := 1 to mTradalog.NodeCount(s) do
            begin

                inodeaddr := s + '[' + IntToStr(ic) + ']';

                pcode := mTradalog.GetStringElement(inodeaddr,GTD_PL_ELE_PRODUCT_CODE);

                // -- Add this to the list if we get a result
                if pcode <> '' then
                begin
                    myList.Add(EncodeStringField(GTD_PL_ELE_PRODUCT_CODE,pcode));
                    // BuildReport('Debug','Adding Tradalog product ' + pcode);
                end;

            end;

            // -- for any subgroups
            for l2c := 1 to mTradalog.NodeCount(s + GTD_PL_PRODUCTGROUPL2_NODE) do
            begin
                // -- For all the items in the second level group
                t := s + GTD_PL_PRODUCTGROUPL2_NODE + GTD_PL_PRODUCTITEMS_NODE + GTD_PL_PRODUCTITEM_NODE;
                for ic := 1 to mTradalog.NodeCount(t) do
                begin

                    inodeaddr := t + '[' + IntToStr(ic) + ']';

                    pcode := mTradalog.GetStringElement(inodeaddr,GTD_PL_ELE_PRODUCT_CODE);

                    // -- Add this to the list if we get a result
                    if pcode <> '' then
                    begin
                        myList.Add(EncodeStringField(GTD_PL_ELE_PRODUCT_CODE,pcode));
                        // BuildReport('Debug','Adding Tradalog product ' + pcode);
                    end;

                end;
            end;
        end;
    end;

begin
    Result := False;

    BuildReport('Show','Checking items in Tradalog');

    myList := TStringList.Create;
    try

        BuildCodesByScanningGroups;

    finally
        // -- Now sort the product codes
        myList.Sort;

        // -- Copy them over
        Doc2TLogItems.XML.Assign(myList);

        myList.Destroy;
    end;

    // -- If there were no items found, then no point in going further
    if Doc2TLogItems.XML.Count = 0 then
    begin
        BuildReport('Error','No Items found in Tradalog');
        Exit;
    end;

    Result := True;
end;

function TPatchImportPanel.LoadInventoryCodes:Boolean;
var
    SQLs,pcode : String;
    myDS : TDataSet;
    myList : TStringList;
begin
    Result := False;

    // -- Check that there is a product table specified
    if cbxProductTable.Text = '' then
    begin
        BuildReport('Error','Product Table not specified');
        Exit;
    end;

    // -- Work out exactly what the product code is
    pcode := FindColumnNameOf(GTD_PL_ELE_PRODUCT_CODE);

    // -- Check that there is a product table specified
    if pcode = '' then
    begin
        BuildReport('Error','Product Code field specified');
        Exit;
    end;

    SQLs := 'SELECT' + #13 +
           #9 + pcode + #13 +
           'FROM' + #13 +
           #9 + cbxProductTable.Text + #13;

    if cbxHaveSupplierTable.Checked then
    begin
        if cbxProductSupplierCodeColumn.Text = '' then
        begin
            BuildReport('Error','Supplier Code Column not specified');
            Exit;
        end;

        // --
        SQLs := SQLs + 'WHERE' + #13 +
                '(' + cbxProductTable.Text + '.' + cbxProductSupplierCodeColumn.Text +
                ' = "' + txtSupplierCode.Text + '")' + #13;
    end;

    SQLs := SQLs + 'ORDER BY' + #13 +
           FindColumnNameOf(GTD_PL_ELE_PRODUCT_CODE);

    if rdodbTypeAccess.Checked then
    begin
        // --
        with qryADOTemp do
        begin
            Active := False;

            // -- Set database access parameters
            Connection := dbADO.Connection;

            SQL.Clear;
            SQL.Add(SQLs);
            Active := True;

            myDS := TDataSet(qryADOTemp);
        end;
    end
    else begin
        // -- BDE
        with qryTemp do
        begin
            Active := False;
            if (db1.AliasName <> '') then
                DatabaseName := db1.AliasName
            else
                DatabaseName := db1.DatabaseName;

            SQL.Clear;
            SQL.Add(SQLs);
            Active := True;

            myDS := TDataSet(qryTemp);
        end;
    end;

    // -- Now add all these product codes to our list
    myList := TStringList.Create;

    try
        with myDS do
        begin
            First;

            while not Eof do
            begin

                myList.Add(EncodeStringField(GTD_PL_ELE_PRODUCT_CODE,FieldByName(pcode).AsString));

                Next;
            end;

        end;
    finally
        // -- Now sort the product codes
        myList.Sort;

        // -- Copy them over
        Doc1InvtItems.XML.Assign(myList);

        myList.Destroy;
    end;

    Result := True;
end;

function TPatchImportPanel.FindAdditionsRemovals:Boolean;

    procedure AddInsertion(Doc2TLogLine : Integer);
    var
        pcode : String;
    begin
        InsertionItems.Add(Doc2TLogItems.XML.Strings[Doc2TLogLine]);

        // -- Clean up the product code
        pcode := Trim(Copy(Doc2TLogItems.XML.Strings[Doc2TLogLine],Length(GTD_PL_ELE_PRODUCT_CODE) + 4,Length(Doc2TLogItems.XML.Strings[Doc2TLogLine])));
        pcode := Copy(pcode,1,Length(pcode)-1);

        with tblProductUpdates do
        begin
            // -- See if the product already exists
            Append;
            FieldByName('Revision_Number').AsInteger := mRevisionNo;
            FieldByName('TimeStamp').AsFloat := mTradalog.Document_Date;
            FieldByName('Trader_ID').AsInteger := mTradalog.Owned_By;
            FieldByName('Update_Type').AsString := PRODUCT_UPDATE_ADDITION;
            FieldByName('Product_Code').AsString := pcode;
            FieldByName('Applied_Flag').AsString := '*';
            Post;
        end;
    end;

    procedure AddDeletion(Doc2TLogLine : Integer);
    var
        pcode : String;
    begin
        DeletionItems.Add(Doc2TLogItems.XML.Strings[Doc2TLogLine]);

        // -- Clean up the product code
        pcode := Trim(Copy(Doc2TLogItems.XML.Strings[Doc2TLogLine],Length(GTD_PL_ELE_PRODUCT_CODE) + 4,Length(Doc2TLogItems.XML.Strings[Doc2TLogLine])));
        pcode := Copy(pcode,1,Length(pcode)-1);

        with tblProductUpdates do
        begin
            // -- See if the product already exists
            Append;
            FieldByName('Revision_Number').AsInteger := mRevisionNo;
            FieldByName('TimeStamp').AsFloat := mTradalog.Document_Date;
            FieldByName('Trader_ID').AsInteger := mTradalog.Owned_By;
            FieldByName('Update_Type').AsString := PRODUCT_UPDATE_REMOVAL;
            FieldByName('Product_Code').AsString := pcode;
            FieldByName('Applied_Flag').AsString := '*';
            Post;
        end;
    end;

var
    xc,LineNo : Integer;
    L : String;
begin
    Result := False;

    // -- Check for if all items are insertions
    if (Doc1InvtItems.XML.Count = 0) then
    begin
        // -- Add all the items
        for xc := 1 to Doc2TLogItems.XML.Count do
            AddInsertion(xc - 1);
    end
    else begin

        // -- Find the differences
        Doc2TLogItems.BuildPatch(Doc1InvtItems.XML,Diffs,dtCompact);

        // -- Now process them
        for xc := 1 to Diffs.Count do
        begin
            L := Diffs.Strings[xc - 1];
            case L[1] of
                '@' : begin
                        BuildReport('Debug','Context :' + L);
                        
                      end;
                '-' : if cbxNoDeleteItems.Checked then
                      begin
                          // --
                          BuildReport('Debug','Removal :' + L);
                      end
                      else begin
                          // --
                          BuildReport('Debug','Removal :' + L);
                      end;
                '+' : begin
                        BuildReport('Debug','Insertion :' + L);
                        InsertionItems.Add(Doc2TLogItems.XML.Strings[xc - 1]);
                      end;
                '#' : BuildReport('Debug','Change :' + L);
            end;
        end;

    end;

    BuildReport('Debug','InsertionItems=' + IntToStr(InsertionItems.Count));
    BuildReport('Debug','DeletionItems=' + IntToStr(DeletionItems.Count));

    Result := True;
end;

function TPatchImportPanel.LoadTradalogItemDetails:Boolean;
begin
    Result := False;
    Result := True;
end;

function TPatchImportPanel.LoadInventoryItemDetails:Boolean;
begin
    Result := False;
    Result := True;
end;

function TPatchImportPanel.FindFieldChanges:Boolean;
begin
    Result := False;
    BuildReport('Debug','UpdateItems=' + IntToStr(ChangeItems.Count));
    Result := True;
end;

function TPatchImportPanel.ResortOnProductCode:Boolean;
begin
    Result := False;
    Result := True;
end;

function TPatchImportPanel.DetermineUpdateQueries:Boolean;
var
    sql : String;
    
    function BuildInsertQuery:Boolean;
    var
        xc : Integer;
        allblank : Boolean;
    begin
        Result := True;

        SQL := 'INSERT INTO' + #13 +
               #9 + cbxProductTable.Text + #13 +
               '(';

        // -- Process each of the possible fields
        allblank := True;
        for xc := 1 to grdFieldMappings.RowCount - 1 do
        begin
            if grdFieldMappings.Cells[1,xc] <> '' then
            begin
                // -- Add the name of the field
                SQL := SQL + grdFieldMappings.Cells[1,xc] + ',';
                allblank := False;
            end;
        end;

        if (allblank) then
        begin
            BuildReport('Error','No fields mapped');
            Exit;
        end;

        // -- Trim the last comma, close the bracket
        SQL := Copy(SQL,1,Length(SQL)-1) + ')' + #13;

        SQL := SQL + 'VALUES (' + #13;

        // -- Process each of the fields
        for xc := 1 to grdFieldMappings.RowCount - 1 do
        begin
            if grdFieldMappings.Cells[1,xc] <> '' then
            begin
                // -- Add the name of the field
                SQL := SQL + '""'  + ',';
            end;
        end;

        // -- Trim the last comma, close the bracket
        SQL := Copy(SQL,1,Length(SQL)-1) + ')' + #13;

    end;
    procedure BuildRemovalQuery;
    begin
    end;
    procedure BuildUpdateQuery;
    begin
    end;

begin
    Result := True;

    with tblProductUpdates do
    begin
        First;

        while not Eof do
        begin

            // -- Initialise the sql variable, when changed it get saved
            Sql := '';

            // -- Each different type
            if FieldByName('Update_Type').AsString = PRODUCT_UPDATE_ADDITION then
            begin
                Result := BuildInsertQuery;
            end
            else if FieldByName('Update_Type').AsString = PRODUCT_UPDATE_REMOVAL then
            begin
                BuildRemovalQuery;
            end
            else if FieldByName('Update_Type').AsString = PRODUCT_UPDATE_UPDATE then
            begin
                BuildUpdateQuery;
            end;

            // -- If one record didn't process properly then break
            if not Result then
                Exit;

            // -- Update the record
            if SQL <> '' then
            begin
                Edit;
                FieldByName('SQL_Update_Text').AsString := SQL;
                FieldByName('Applied_Flag').AsString := 'N';
                Post;
            end;

            // -- Advance onto next record
            Next;

        end;
    end;

end;

function TPatchImportPanel.ApplyUpdates:Boolean;
var
    xc : Integer;
begin
    Result := False;

    // tblProductUpdates

    Result := True;
end;

procedure TPatchImportPanel.Init;
begin
    lstMappings.Items.Clear;
    qryLoadMappings.Active := True;
    qryLoadMappings.First;
    while not qryLoadMappings.Eof do
    begin
        lstMappings.Items.Add(qryLoadMappings.FieldByName('KEYNAME').AsString);

        qryLoadMappings.Next;
    end;
end;

function TPatchImportPanel.Run:Boolean;
begin
    Result := False;

    // -- Run all the procedures. If any fail then stop
    if not InitPatchRun then Exit;
    if not LoadTradalogCodes then Exit;
    if not LoadInventoryCodes then Exit;
    if not FindAdditionsRemovals then Exit;
    if not LoadTradalogItemDetails then Exit;
    if not LoadInventoryItemDetails then Exit;
    if not FindFieldChanges then Exit;
    if not ResortOnProductCode then Exit;
    if not DetermineUpdateQueries then Exit;
    if not ApplyUpdates then Exit;

    Result := True;
    
end;

procedure TPatchImportPanel.BuildReport(const mType : String; const Msg : String);
begin
    // -- Display something in our message box
    if (mType = 'Clear') then
        mmoProgress.Lines.Clear
    else if mType = 'Show' then
        mmoProgress.Lines.Add(Msg)
    else
        mmoProgress.Lines.Add(mType + ': ' + Msg)
end;

function TPatchImportPanel.LoadImportMapping(MapName : String):Boolean;

    procedure SetColumnNameOf(AColumn, AValue : String);
    var
        xc : Integer;
    begin
        for xc := 1 to grdFieldMappings.RowCount do
        begin
            if (Acolumn = grdFieldMappings.Cells[0,xc]) then
            begin
                grdFieldMappings.Cells[1,xc] := AValue;
                break;
            end;
        end;
    end;

var
    dbType,s : String;
begin
    Result := False;

    // -- Open the table if not already so
    if not tblSysVal.Active then
        tblSysVal.Active := True;

    if not Assigned(bdFieldMap) then
        bdFieldMap := GTDBizDoc.Create(Self);

    // -- Do we need to create a new record in sysvals?
    if (tblSysVal.FindKey(['TRADALOG_IMPORT_MAP',MapName])) then
    begin

        // -- Load the params up
        bdFieldMap.XML.Assign(TMemoField(tblSysVal.FieldByName('KEYTEXT')));

        // -- Database specific information
        dbType := bdFieldMap.GetStringElement('/Database', 'Driver');
        if (dbType = 'dBase') then
        begin
            rdodbTypedBase.Checked := True;
            txtdbaseDir.Text := bdFieldMap.GetStringElement('/dBase', 'DataDirectory');
        end
        else if (dbType = 'MS-Access') then
        begin
            rdodbTypeAccess.Checked := True;
            txtAccessdb.Text := bdFieldMap.GetStringElement('/ADO', 'Connection');
        end
        else if (dbType = 'BDE') then
        begin
            rdodbTypeBorlandBDE.Checked := True;

            // -- Load the aliases
            GetAliases(cbxBDEALIAS.Items,'');
            cbxBDEALIAS.ItemIndex := cbxBDEALIAS.Items.IndexOf(bdFieldMap.GetStringElement('/BDE', 'AliasName'));
        end
        else if (dbType = 'ODBC') then
        begin
        end;

        // -- Which structure
        s                                 := bdFieldMap.GetStringElement('/Database Heirachy', 'Structure');
        if (s = '1LevelStockTable') then
            cbxImport1LevelStockTable.Checked := True
        else if (s = '2LevelStockTable') then
            cbxImport2LevelStockTable.Checked := True
        else if (s = '2LevelStockGroupTables') then
            cbxImportGroupStockTables.Checked := True
        else if (s = '2LevelStockGroupSubGroupTables') then
            cbxImportGroupSubGroupStockTable.Checked := True;

        // -- Load in the selected values
        cbxProductGroupTable.Style         := bscbEditStyle;
        cbxProductGroupCodeColumn.Style    := bscbEditStyle;
        cbxProductGroupNameColumn.Style    := bscbEditStyle;

        cbxProductSubGroupTable.Style      := bscbEditStyle;
        cbxProductSubGroupCodeColumn.Style := bscbEditStyle;
     cbxProductSubGroupSubCodeColumn.Style := bscbEditStyle;
        cbxProductSubGroupNameColumn.Style := bscbEditStyle;

        cbxProductTable.Style              := bscbEditStyle;
        cbxProductGroupColumn.Style        := bscbEditStyle;

        // -- Table mappings
        cbxProductGroupTable.Text         := bdFieldMap.GetStringElement('/Database Heirachy', 'ProductGroup_TableName');
        cbxProductGroupCodeColumn.Text    := bdFieldMap.GetStringElement('/Database Heirachy', 'ProductGroup_CodeColumn');
        cbxProductGroupNameColumn.Text    := bdFieldMap.GetStringElement('/Database Heirachy', 'ProductGroup_NameColumn');

        cbxProductSubGroupTable.Text      := bdFieldMap.GetStringElement('/Database Heirachy', 'ProductSubGroup_TableName');
        cbxProductSubGroupCodeColumn.Text := bdFieldMap.GetStringElement('/Database Heirachy', 'ProductSubGroup_CodeColumn');
     cbxProductSubGroupSubCodeColumn.Text := bdFieldMap.GetStringElement('/Database Heirachy', 'ProductSubGroup_SubCodeColumn');
        cbxProductSubGroupNameColumn.Text := bdFieldMap.GetStringElement('/Database Heirachy', 'ProductSubGroup_NameColumn');

        {
        s := 'cbxProductSubGroupTable.Text = ' + bdFieldMap.GetStringElement('/Database Heirachy', 'ProductSubGroup_TableName') + #13 +
             'cbxProductSubGroupCodeColumn.Text = ' + bdFieldMap.GetStringElement('/Database Heirachy', 'ProductSubGroup_CodeColumn') + #13 +
             'cbxProductSubGroupSubCodeColumn.Text = ' + bdFieldMap.GetStringElement('/Database Heirachy', 'ProductSubGroup_SubCodeColumn') + #13 +
             'cbxProductSubGroupNameColumn.Text = ' + bdFieldMap.GetStringElement('/Database Heirachy', 'ProductSubGroup_NameColumn');
        bsSkinMessage1.MessageDlg(s,mtInformation,[mbOk],0);
        }

        cbxProductTable.Text              := bdFieldMap.GetStringElement('/Database Heirachy', 'Product_TableName');
        cbxProductGroupColumn.Text        := bdFieldMap.GetStringElement('/Database Heirachy', 'Product_GroupColumn');

        // -- Column mappings
        SetColumnNameOf(GTD_PL_ELE_PRODUCT_CODE,bdFieldMap.GetStringElement('/Column Mappings', GTD_PL_ELE_PRODUCT_CODE));         //     = 'Product_ID';
        SetColumnNameOf(GTD_PL_ELE_PRODUCT_NAME,bdFieldMap.GetStringElement('/Column Mappings', GTD_PL_ELE_PRODUCT_NAME));         //     = 'Name';
        SetColumnNameOf(GTD_PL_ELE_PRODUCT_DESC,bdFieldMap.GetStringElement('/Column Mappings', GTD_PL_ELE_PRODUCT_DESC));         //     = 'Description';
        SetColumnNameOf(GTD_PL_ELE_PRODUCT_LIST,bdFieldMap.GetStringElement('/Column Mappings', GTD_PL_ELE_PRODUCT_LIST));         //     = 'List_Price';
        SetColumnNameOf(GTD_PL_ELE_PRODUCT_SELL,bdFieldMap.GetStringElement('/Column Mappings', GTD_PL_ELE_PRODUCT_SELL));         //     = 'Your_Price';
        SetColumnNameOf(GTD_PL_ELE_PRODUCT_TAXR,bdFieldMap.GetStringElement('/Column Mappings', GTD_PL_ELE_PRODUCT_TAXR));         //     = 'Tax_Rate';
        SetColumnNameOf(GTD_PL_ELE_PRODUCT_TAXT,bdFieldMap.GetStringElement('/Column Mappings', GTD_PL_ELE_PRODUCT_TAXT));         //     = 'Tax_Type';
		SetColumnNameOf(GTD_PL_ELE_PRODUCT_BRAND,bdFieldMap.GetStringElement('/Column Mappings', GTD_PL_ELE_PRODUCT_BRAND));         //     = 'Manufacturer';
        SetColumnNameOf(GTD_PL_ELE_PRODUCT_UNIT,bdFieldMap.GetStringElement('/Column Mappings', GTD_PL_ELE_PRODUCT_UNIT));         //     = 'Unit';
        SetColumnNameOf(GTD_PL_ELE_PRODUCT_TYPE,bdFieldMap.GetStringElement('/Column Mappings', GTD_PL_ELE_PRODUCT_TYPE));         //     = 'Product_Type';
        SetColumnNameOf(GTD_PL_ELE_PRODUCT_MOREINFO,bdFieldMap.GetStringElement('/Column Mappings', GTD_PL_ELE_PRODUCT_MOREINFO));     // = 'Further_Info_URL';
        SetColumnNameOf(GTD_PL_ELE_BRANDNAME,bdFieldMap.GetStringElement('/Column Mappings', GTD_PL_ELE_BRANDNAME));            //        = 'Brand_Name';
        SetColumnNameOf(GTD_PL_ELE_MANUFACT_NAME,bdFieldMap.GetStringElement('/Column Mappings', GTD_PL_ELE_MANUFACT_NAME));        //    = 'Manufacturer.Name';
        SetColumnNameOf(GTD_PL_ELE_MANUFACT_GTL,bdFieldMap.GetStringElement('/Column Mappings', GTD_PL_ELE_MANUFACT_GTL));         //     = 'Manufacturer.GTL';
        SetColumnNameOf(GTP_PL_ELE_MANUFACT_PRODINFO,bdFieldMap.GetStringElement('/Column Mappings', GTP_PL_ELE_MANUFACT_PRODINFO));    //= 'Manufacturer.Product_URL';
        SetColumnNameOf(GTD_PL_ELE_PRODUCT_AVAIL_FLAG,bdFieldMap.GetStringElement('/Column Mappings', GTD_PL_ELE_PRODUCT_AVAIL_FLAG));   // = 'Availability.Flag';
        SetColumnNameOf(GTD_PL_ELE_PRODUCT_AVAIL_DATE,bdFieldMap.GetStringElement('/Column Mappings', GTD_PL_ELE_PRODUCT_AVAIL_DATE));   // = 'Availability.Date';
        SetColumnNameOf(GTD_PL_ELE_PRODUCT_AVAIL_STATUS,bdFieldMap.GetStringElement('/Column Mappings', GTD_PL_ELE_PRODUCT_AVAIL_STATUS)); // = 'Availability.Status';
        SetColumnNameOf(GTD_PL_ELE_PRODUCT_AVAIL_BACKORD,bdFieldMap.GetStringElement('/Column Mappings', GTD_PL_ELE_PRODUCT_AVAIL_BACKORD)); //= 'Availability.OnBackOrder';
        SetColumnNameOf(GTD_PL_ELE_ONSPECIAL,bdFieldMap.GetStringElement('/Column Mappings', GTD_PL_ELE_ONSPECIAL));
        SetColumnNameOf(GTD_PL_ELE_ONSPECIAL_TILL,bdFieldMap.GetStringElement('/Column Mappings', GTD_PL_ELE_ONSPECIAL_TILL));
        SetColumnNameOf(GTD_PL_ELE_PRODUCT_IMAGE_ID,bdFieldMap.GetStringElement('/Column Mappings', GTD_PL_ELE_PRODUCT_IMAGE_ID));

        dbProfileName := MapName;

        Result := True;
    end;

end;

function TPatchImportPanel.SaveImportMapping(MapName : String):Boolean;
var
    defmemo : TMemoField;
begin
    // -- Open the table if not already so
    if not tblSysVal.Active then
        tblSysVal.Active := True;

    if not Assigned(bdFieldMap) then
        bdFieldMap := GTDBizDoc.Create(Self);

    // -- Do we need to create a new record in sysvals?
    if (tblSysVal.FindKey(['TRADALOG_IMPORT_MAP',MapName])) then
    begin
        tblSysVal.Edit;
    end
    else
    begin
        tblSysVal.Append;
        tblSysVal.FieldByName('SECTION').AsString := 'TRADALOG_IMPORT_MAP';
        tblSysVal.FieldByName('KEYNAME').AsString := dbProfileName;
    end;

    // -- The database type
    if (rdodbTypedBase.Checked) then
    begin
        bdFieldMap.SetStringElement('/Database', 'Driver', 'dBase');
        bdFieldMap.SetStringElement('/dBase', 'DataDirectory', txtdbaseDir.Text)
    end
    else if (rdodbTypeAccess.Checked) then
    begin
        bdFieldMap.SetStringElement('/Database', 'Driver', 'MS-Access');
        bdFieldMap.SetStringElement('/ADO', 'Connection', txtAccessdb.Text);
    end
    else if (rdodbTypeBorlandBDE.Checked) then
    begin
        bdFieldMap.SetStringElement('/Database', 'Driver', 'BDE');
        bdFieldMap.SetStringElement('/BDE', 'AliasName', cbxBDEALIAS.Text)
    end
    else if (rdodbTypeODBC.Checked) then
        bdFieldMap.SetStringElement('/Database', 'Driver', 'ODBC');

    // -- Table mappings
    bdFieldMap.SetStringElement('/Database Heirachy', 'ProductGroup_TableName',cbxProductGroupTable.Text);
    bdFieldMap.SetStringElement('/Database Heirachy', 'ProductGroup_CodeColumn',cbxProductGroupCodeColumn.Text);
    bdFieldMap.SetStringElement('/Database Heirachy', 'ProductGroup_NameColumn',cbxProductGroupNameColumn.Text);

    bdFieldMap.SetStringElement('/Database Heirachy', 'ProductSubGroup_TableName',cbxProductSubGroupTable.Text);
    bdFieldMap.SetStringElement('/Database Heirachy', 'ProductSubGroup_CodeColumn',cbxProductSubGroupCodeColumn.Text);
    bdFieldMap.SetStringElement('/Database Heirachy', 'ProductSubGroup_SubCodeColumn',cbxProductSubGroupSubCodeColumn.Text);
    bdFieldMap.SetStringElement('/Database Heirachy', 'ProductSubGroup_NameColumn',cbxProductSubGroupNameColumn.Text);

    bdFieldMap.SetStringElement('/Database Heirachy', 'Product_TableName',cbxProductTable.Text);
    bdFieldMap.SetStringElement('/Database Heirachy', 'Product_GroupColumn',cbxProductGroupColumn.Text);

    // -- Save the structure
    if (cbxImport1LevelStockTable.Checked) then
        bdFieldMap.SetStringElement('/Database Heirachy', 'Structure','1LevelStockTable')
    else if (cbxImport2LevelStockTable.Checked) then
        bdFieldMap.SetStringElement('/Database Heirachy', 'Structure','2LevelStockTable')
    else if (cbxImportGroupStockTables.Checked) then
        bdFieldMap.SetStringElement('/Database Heirachy', 'Structure','2LevelStockGroupTables')
    else if (cbxImportGroupSubGroupStockTable.Checked) then
        bdFieldMap.SetStringElement('/Database Heirachy', 'Structure','2LevelStockGroupSubGroupTables');

    // -- Column mappings
    bdFieldMap.SetStringElement('/Column Mappings', GTD_PL_ELE_PRODUCT_CODE,FindColumnNameOf(GTD_PL_ELE_PRODUCT_CODE));         //     = 'Product_ID';
    bdFieldMap.SetStringElement('/Column Mappings', GTD_PL_ELE_PRODUCT_NAME,FindColumnNameOf(GTD_PL_ELE_PRODUCT_NAME));         //     = 'Name';
    bdFieldMap.SetStringElement('/Column Mappings', GTD_PL_ELE_PRODUCT_DESC,FindColumnNameOf(GTD_PL_ELE_PRODUCT_DESC));         //     = 'Description';
    bdFieldMap.SetStringElement('/Column Mappings', GTD_PL_ELE_PRODUCT_LIST,FindColumnNameOf(GTD_PL_ELE_PRODUCT_LIST));         //     = 'List_Price';
    bdFieldMap.SetStringElement('/Column Mappings', GTD_PL_ELE_PRODUCT_SELL,FindColumnNameOf(GTD_PL_ELE_PRODUCT_SELL));         //     = 'Your_Price';
    bdFieldMap.SetStringElement('/Column Mappings', GTD_PL_ELE_PRODUCT_TAXR,FindColumnNameOf(GTD_PL_ELE_PRODUCT_TAXR));         //     = 'Tax_Rate';
    bdFieldMap.SetStringElement('/Column Mappings', GTD_PL_ELE_PRODUCT_TAXT,FindColumnNameOf(GTD_PL_ELE_PRODUCT_TAXT));         //     = 'Tax_Type';
    bdFieldMap.SetStringElement('/Column Mappings', GTD_PL_ELE_PRODUCT_BRAND,FindColumnNameOf(GTD_PL_ELE_PRODUCT_BRAND));         //     = 'Manufacturer';
    bdFieldMap.SetStringElement('/Column Mappings', GTD_PL_ELE_PRODUCT_UNIT,FindColumnNameOf(GTD_PL_ELE_PRODUCT_UNIT));         //     = 'Unit';
    bdFieldMap.SetStringElement('/Column Mappings', GTD_PL_ELE_PRODUCT_TYPE,FindColumnNameOf(GTD_PL_ELE_PRODUCT_TYPE));         //     = 'Product_Type';
    bdFieldMap.SetStringElement('/Column Mappings', GTD_PL_ELE_PRODUCT_MOREINFO,FindColumnNameOf(GTD_PL_ELE_PRODUCT_MOREINFO));     // = 'Further_Info_URL';
    bdFieldMap.SetStringElement('/Column Mappings', GTD_PL_ELE_BRANDNAME,FindColumnNameOf(GTD_PL_ELE_BRANDNAME));            //        = 'Brand_Name';
    bdFieldMap.SetStringElement('/Column Mappings', GTD_PL_ELE_MANUFACT_NAME,FindColumnNameOf(GTD_PL_ELE_MANUFACT_NAME));        //    = 'Manufacturer.Name';
    bdFieldMap.SetStringElement('/Column Mappings', GTD_PL_ELE_MANUFACT_GTL,FindColumnNameOf(GTD_PL_ELE_MANUFACT_GTL));         //     = 'Manufacturer.GTL';
    bdFieldMap.SetStringElement('/Column Mappings', GTP_PL_ELE_MANUFACT_PRODINFO,FindColumnNameOf(GTP_PL_ELE_MANUFACT_PRODINFO));    //= 'Manufacturer.Product_URL';
    bdFieldMap.SetStringElement('/Column Mappings', GTD_PL_ELE_PRODUCT_AVAIL_FLAG,FindColumnNameOf(GTD_PL_ELE_PRODUCT_AVAIL_FLAG));   // = 'Availability.Flag';
    bdFieldMap.SetStringElement('/Column Mappings', GTD_PL_ELE_PRODUCT_AVAIL_DATE,FindColumnNameOf(GTD_PL_ELE_PRODUCT_AVAIL_DATE));   // = 'Availability.Date';
    bdFieldMap.SetStringElement('/Column Mappings', GTD_PL_ELE_PRODUCT_AVAIL_STATUS,FindColumnNameOf(GTD_PL_ELE_PRODUCT_AVAIL_STATUS)); // = 'Availability.Status';
    bdFieldMap.SetStringElement('/Column Mappings', GTD_PL_ELE_PRODUCT_AVAIL_BACKORD,FindColumnNameOf(GTD_PL_ELE_PRODUCT_AVAIL_BACKORD)); //= 'Availability.OnBackOrder';
    bdFieldMap.SetStringElement('/Column Mappings', GTD_PL_ELE_ONSPECIAL,FindColumnNameOf(GTD_PL_ELE_ONSPECIAL));
    bdFieldMap.SetStringElement('/Column Mappings', GTD_PL_ELE_ONSPECIAL_TILL,FindColumnNameOf(GTD_PL_ELE_ONSPECIAL_TILL));
    bdFieldMap.SetStringElement('/Column Mappings', GTD_PL_ELE_PRODUCT_IMAGE_ID,FindColumnNameOf(GTD_PL_ELE_PRODUCT_IMAGE_ID));

    // -- Update the memo field
    defmemo := TMemoField(tblSysVal.FieldByName('KEYTEXT'));
    defmemo.Assign(bdFieldMap.XML);

    // -- Now write to the table
    tblSysVal.Post;

    dbProfileName := MapName;
end;

procedure TPatchImportPanel.btnProcessClick(Sender: TObject);
begin
    Run;
end;

// -- Here we look up what a column should be translated to
function TPatchImportPanel.FindColumnNameOf(ADefinedElementName : String):String;
var
    xc, xd : Integer;
    c       : String;
begin
    Result := '';
    for xc := 1 to grdFieldMappings.RowCount do
    begin
        if grdFieldMappings.Cells[0,xc] = ADefinedElementName then
        begin

            c := grdFieldMappings.Cells[1,xc];

            xd := Pos('.',c);
            if xd <> 0 then
                c := Copy(c,xd+1,Length(c)-xd);

            Result := c;
            break;
        end;
    end;
end;

procedure TPatchImportPanel.btnAddColumnMapClick(Sender: TObject);
begin
    // -- Check that something was sellected
    if lstInputFields.ItemIndex = -1 then
        Exit;

    // -- Now copy over this field into our mapping list
    grdFieldMappings.Cells[1,grdFieldMappings.Row] := lstInputFields.Items[lstInputFields.ItemIndex];

    // -- Advance down to the next row
    grdFieldMappings.Row := grdFieldMappings.Row + 1;

end;

procedure TPatchImportPanel.btnRemoveColumnMapClick(Sender: TObject);
begin
    // -- Now copy over this field into our mapping list
    grdFieldMappings.Cells[1,grdFieldMappings.Row] := '';

end;

procedure TPatchImportPanel.btnSaveMappingClick(Sender: TObject);
begin
    // --
    if (dbProfileName = '') then
    begin
        // --
        if not dlgSaveProfileName.InputQuery('Save Mapping','Please enter a name for this mapping',dbProfileName) then
            Exit;
    end;

    // -- Save
    SaveImportMapping(dbProfileName);

end;

procedure TPatchImportPanel.cbxHaveSupplierTableClick(Sender: TObject);
var
    onoroff : Boolean;
begin
    onoroff := cbxHaveSupplierTable.Checked;
    lblProductSupplierCodeColumn.Visible := onoroff;
    cbxProductSupplierCodeColumn.Visible := onoroff;
    Bevel11.Visible := onoroff;
    Bevel10.Visible := onoroff;
    Bevel9.Visible := onoroff;
    cbxSupplierCodeColumn.Visible := onoroff;
    cbxSupplierTable.Visible := onoroff;
    lblSupplierTable.Visible := onoroff;
end;

procedure TPatchImportPanel.lstMappingsListBoxDblClick(Sender: TObject);
begin
    if (lstMappings.Items.Count <> 0) then
    begin

        // -- Flip a few controls here and there
        cbsImportUseMap.Checked := True;
        btnImportGotoRun.Visible := True;

        // -- Load up this mapping
        LoadImportMapping(lstMappings.Items[lstMappings.ItemIndex]);

    end;

end;

procedure TPatchImportPanel.SetupBlankTableNames;
const
    dfltPgrpTableName = 'Product_Groups';
    dfltSubPrgpTableName = 'Product_SubGroups';
    dfltProductTableName = 'Products';
    dfltSupplierTableName = 'Suppliers';
begin
    // -- Well, if there are no table configurations
    //    then may as well suggest some
    if optExportDatabase.Checked then
    begin

        // -- Change all fields so users can type in their own values
        if cbxSupplierTable.Visible then
            cbxSupplierTable.Style        := bscbEditStyle;
        if cbxProductGroupTable.Visible then
            cbxProductGroupTable.Style    := bscbEditStyle;
        if cbxProductSubGroupTable.Visible then
            cbxProductSubGroupTable.Style := bscbEditStyle;
        cbxProductTable.Style         := bscbEditStyle;

        if cbxImport1LevelStockTable.Checked then
        begin
        end
        else if cbxImport2LevelStockTable .Checked then
        begin
        end
        else if cbxImportGroupStockTables.Checked then
        begin
        end
        else if cbxImportGroupSubGroupStockTable.Checked then
        begin
        end;

        if cbxHaveSupplierTable.Checked then
        begin
            if cbxSupplierTable.Text = '' then
                cbxSupplierTable.Text := dfltSupplierTableName;
        end;

        // -- Product Groups
        if cbxProductGroupTable.Text = '' then
            cbxProductGroupTable.Text := dfltPgrpTableName;

        // -- Product Subgroups
        if cbxProductSubGroupTable.Text = '' then
            cbxProductSubGroupTable.Text := dfltSubPrgpTableName;

        // -- Product Items
        if cbxProductTable.Text = '' then
            cbxProductTable.Text := dfltProductTableName;
    end;

end;

procedure TPatchImportPanel.Clear;
begin
    cbxProductGroupTable.Text := '';

end;

procedure TPatchImportPanel.btnNext2Click(Sender: TObject);
begin
    SetupBlankTableNames;
    nbkMain.ActivePageIndex := 2;
end;

function TPatchImportPanel.ExportToDB:Boolean;
begin
end;

function TPatchImportPanel.ExportToCSV:Boolean;
begin
end;

end.
