unit GTDBuildPricelistFromDBRun;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  bsSkinData, BusinessSkinForm, bsSkinCtrls, StdCtrls, bsSkinBoxCtrls,
  GTDBizDocs, GTDBuildPricelistFromDBConfig, GTDPricelists,
  DB, ADODB, bsDialogs;

type
  TBuildPricelistFromDBRun = class(TFrame)
    ggeProgress: TbsSkinGauge;
    bsSkinStdLabel2: TbsSkinStdLabel;
    bsSkinSpeedButton1: TbsSkinSpeedButton;
    pnlBackground: TbsSkinPanel;
    lblHeading: TbsSkinStdLabel;
    bsSkinButton1: TbsSkinButton;
    lblDescription: TbsSkinStdLabel;
    ADOConnection1: TADOConnection;
    qryGetItems: TADOQuery;
    mmoOutput: TbsSkinMemo2;
    btnShowPricelist: TbsSkinCheckRadioBox;
    dlgSelectProfile: TbsSkinSelectValueDialog;
    procedure bsSkinButton1Click(Sender: TObject);
  private
    { Private declarations }
    fDocRegistry        : GTDDocumentRegistry;
	fSkinData           : TbsSkinData;
    fConfig             : TBuildPricelistFromDBConfig;
    fOutputPricelist    : GTDBizDoc;

    fADOConnectionString,
    fSQL : String;

    fAllInOneLine,

    fFirstGroup         : Boolean;
    fl1_GroupValue,
    fl2_GroupValue      : String;

    fTrader_ID          : Integer;

    fOutputFields       : TStringList;

    procedure SetSkinData(Value: TbsSkinData);
    function LoadFromConfig:Boolean;
    function ProcessCurrentRecord:Boolean;

  public
    { Public declarations }
    procedure Initialise;
    function Load(const MapName : String):Boolean;
    function Run:Boolean;

    // -- Loads the map for a particular customer
    function RunCustomerPricelist(Trader_ID : Integer):Boolean;

    function ChooseProfileThenRun:Boolean;
    function ChooseTraderProfileThenRun:Boolean;

    procedure Report(const MsgType, Msg : String);
  published
    property SkinData: TbsSkinData read fSkinData write SetSkinData;
    property DocRegistry : GTDDocumentRegistry read fDocRegistry write fDocRegistry;
    property Configuration : TBuildPricelistFromDBConfig read fConfig write fConfig;

  end;

implementation
uses
    PricelistGenerate,GTDBuildPricelistFromDBSelect,
    FastStrings,FastStringFuncs;
const
    newline = chr(13);

{$R *.DFM}

//---------------------------------------------------------------------------
procedure TBuildPricelistFromDBRun.Initialise;
begin
    fOutputFields := TStringList.Create;
    fOutputPricelist := GTDBizDoc.Create(Self);

    lblHeading.Caption := 'Pricelist Builder';
    lblDescription.Caption := '';

end;
//---------------------------------------------------------------------------
function TBuildPricelistFromDBRun.ProcessCurrentRecord:Boolean;

    // -- Builds a custom column
    function CustomColumnRead(fldno : Integer):String;
    var
        dbfieldno : Integer;
        s,fname : String;
    begin
      dbfieldno := Integer(fOutputFields.Objects[fldno]);

      fname := qryGetItems.FieldDefs[dbfieldno].Name;

      case qryGetItems.FieldDefList[dbfieldno].DataType of

          ftBoolean :   s := '           ' + EncodeBooleanField(fname,qryGetItems.Fields[dbfieldno].Value);

          ftDate,
          ftTime,
          ftDateTime,

          ftString,
          ftWideString,       // Wide string field
          ftBytes,            // Fixed number of bytes (binary storage)
          ftVarBytes,	        // Variable number of bytes (binary storage)
          ftMemo,	            // Text memo field
          ftFmtMemo,          //	Formatted text memo field
          ftFixedChar :    	// Fixed character field
                          s := '           ' + EncodeStringField(fname,qryGetItems.Fields[dbfieldno].AsString);

          ftSmallint,	        // 16-bit integer field
          ftLargeint, 	    // Large integer field
          ftInteger,	        // 32-bit integer field
          ftWord,	            // 16-bit unsigned integer field
          ftFloat,            // Floating-point numeric field
          ftBCD,              // Binary-Coded Decimal field that can be converted to Currency type without a loss of precision.

          ftAutoInc :          // Auto-incrementing 32-bit integer counter field
                          s := '           ' + EncodeIntegerField(fname,qryGetItems.Fields[dbfieldno].AsInteger);

          ftCurrency:	        // Money field
                          s := '           ' + EncodeCurrencyField(fname,qryGetItems.Fields[dbfieldno].AsFloat);
      end;

      Result := s;
  end;

var
    xc,fldno : Integer;
    g,s,fldname : String;
begin
    // -- Add the starting tag
    s := '         <' + GTD_PL_PRODUCTITEM_TAG + '>';
    if not fAllInOneLine then
        s := s + newline;

    // -- Here we output every field in the output list
    for xc := 0 to fOutputFields.Count-1 do
    begin
        // -- Retrieve the fieldname
        fldname := fOutputFields.Strings[xc];

        // -- Retrieve the field number stored with the string
        //    and use 0 based values on the recordset
        fldno := Integer(fOutputFields.Objects[xc]);

        // -- Check for control fields
        if (fldname[1] = '<') then
        begin
            if (fldname = l1_group) then
            begin
                // -- If there is a field break
                if (fl1_GroupValue <> qryGetItems.Fields[fldno].AsString) then
                begin
                    // -- Ouput the tag
                    if not ffirstgroup then
                    begin
                        g := g + '       </' + GTD_PL_PRODUCTITEMS_TAG + '>' + newline;
                        g := g + '    </' + GTD_PL_PRODUCTGROUP_TAG + '>' + newline;
                    end
                    else
                        ffirstgroup := false;

                    // -- Save the new value
                    fl1_GroupValue := qryGetItems.Fields[fldno].AsString;

                    // -- Start with the new group
                    g := g + '    <' + GTD_PL_PRODUCTGROUP_TAG + '>' + newline;
                    g := g + '       ' + EncodeStringField(GTD_PL_ELE_GROUP_NAME,fl1_GroupValue) + newline;
                    g := g + '       <' + GTD_PL_PRODUCTITEMS_TAG + '>';

                    Report('Show','Processing ' + fl1_GroupValue);

                    // -- Output it, now
                    if btnShowPricelist.Checked then
                        mmoOutput.Lines.Add(g);

                    while Length(g) > 0 do
                    begin
                      fOutputPricelist.XML.Add(Parse(g,newline));
                    end;

                end;
            end
            else if (fldname = l2_group) then
            begin
            end
            else if (fldname = custom_column) then
            begin
                if (not qryGetItems.Fields[fldno].IsNull) then
                begin
                    // -- Output the column
                    s := s + CustomColumnRead(xc);
                    if not fAllInOneLine then
                        s := s + newline;
                end;
            end;
        end
        else
        // -- If there is a field then output it depending on field type
        if (fldno <> -1)then
        begin
            case qryGetItems.FieldDefList[fldno].DataType of

                ftBoolean	:   s := s + '           ' + EncodeBooleanField(fldname,qryGetItems.Fields[fldno].Value);

                ftDate,
                ftTime,
                ftDateTime,

                ftString,
                ftWideString,       // Wide string field
                ftBytes,            // Fixed number of bytes (binary storage)
                ftVarBytes,	        // Variable number of bytes (binary storage)
                ftMemo,	            // Text memo field
                ftFmtMemo,          //	Formatted text memo field
                ftFixedChar :    	// Fixed character field
                                s := s + '           ' + EncodeStringField(fldname,qryGetItems.Fields[fldno].AsString);

                ftSmallint,	        // 16-bit integer field
                ftLargeint, 	    // Large integer field
                ftInteger,	        // 32-bit integer field
                ftWord,	            // 16-bit unsigned integer field

                ftAutoInc :          // Auto-incrementing 32-bit integer counter field
                                s := s + '           ' + EncodeIntegerField(fldname,qryGetItems.Fields[fldno].AsInteger);

                ftFloat,            // Floating-point numeric field
                ftBCD,              // Binary-Coded Decimal field that can be converted to Currency type without a loss of precision.
                ftCurrency:	        // Money field
                                s := s + '           ' + EncodeCurrencyField(fldname,qryGetItems.Fields[fldno].AsFloat);
            else
              // -- Use string type as fallback
              s := s + '           ' + EncodeStringField(fldname,qryGetItems.Fields[fldno].AsString);
            end;

            if not fAllInOneLine then
                s := s + newline;
            end;
        end;

    // -- Add the closing tag
    s := s + '         </' + GTD_PL_PRODUCTITEM_TAG + '>';

    if btnShowPricelist.Checked then
        mmoOutput.Lines.Add(S);

    // -- Now add the lines to the output. s is multiline
    //    so it needs to be parsed otherwise the stringlist
    //    will get the wrong number of lines and cause
    //    errors further down the line
    while Length(s) > 0 do
    begin
      fOutputPricelist.XML.Add(Parse(s,newline));
    end;
end;
//---------------------------------------------------------------------------
function TBuildPricelistFromDBRun.Run:Boolean;

  // -- Output the names of the columns
  procedure OutputColumnTypes;
  var
    xc,fldno : Integer;
    s, f,dc : String;
  begin
    for xc := 0 to fOutputFields.Count-1 do
    begin
        // -- If there is a defined field, sometimes there is not
        f := fOutputFields[xc];

        // -- Cater for custom columns
        if (Length(f) > 0) and (f[1] = '<') then
        begin
          f := fConfig.lsvFieldList.Items[xc].Caption;
        end;

        dc := fConfig.lsvFieldList.Items[Integer(fOutputFields.Objects[xc])].Caption;
        if dc <> '' then
        begin
            // -- Lookup this column
            // fConfig.lsvFieldList
            //    in the recordset
            fldno := qryGetItems.FieldDefs.Find(dc).FieldNo - 1;

            case qryGetItems.FieldDefList[fldno].DataType of

                ftBoolean	:   s := s + f + '(?);';

                ftDate,ftTime,ftDateTime : s := s + f + '(@);';

                ftString,
                ftWideString,       // Wide string field
                ftBytes,            // Fixed number of bytes (binary storage)
                ftVarBytes,	        // Variable number of bytes (binary storage)
                ftMemo,	            // Text memo field
                ftFmtMemo,          //	Formatted text memo field
                ftFixedChar :    	// Fixed character field
                                s := s + f + '(&);';

                ftSmallint,	        // 16-bit integer field
                ftLargeint, 	    // Large integer field
                ftInteger,	        // 32-bit integer field
                ftWord,	            // 16-bit unsigned integer field

                ftAutoInc :          // Auto-incrementing 32-bit integer counter field
                                s := s + f + '(!);';

                ftFloat,            // Floating-point numeric field
                ftBCD,              // Binary-Coded Decimal field that can be converted to Currency type without a loss of precision.
                ftCurrency:	        // Money field
                                s := s + f + '($);';
            else
              // -- Use string type as fallback
              s := s + f + '(&);';
            end;
        end
    end;

    // -- Knock off the last ;
    SetLength(s,Length(s)-1);

    // -- Write it to the documet
    fOutputPricelist.SetStringElement(GTD_PL_PRODUCTSUMMARY_NODE,GTD_PL_ELE_COLUMNLIST,s);

  end;

  // -- Here we need to correct the actual field numbers
  //    from the recordset
  procedure CorrectFieldNumbers;
  var
    xc,xd,rsc : Integer;
    f,dc : String;
  begin
        // -- For every defined field
        for xc := 0 to fOutputFields.Count-1 do
        begin
            // -- If there is a defined field, sometimes there is not
            f := fOutputFields[xc];
            dc := fConfig.lsvFieldList.Items[Integer(fOutputFields.Objects[xc])].Caption;
            if f <> '' then
            begin
                // -- Lookup this column
                // fConfig.lsvFieldList
                //    in the recordset
                rsc := qryGetItems.FieldDefs.Find(dc).FieldNo - 1;
                if rsc > 0 then
                  fOutputFields.Objects[xc] := TObject(rsc)
                else
                  fOutputFields.Objects[xc] := TObject(xc);
           end;
        end;
  end;

var
    reccount,recsavail : Integer;
begin
    // -- Setup the connection
    ADOConnection1.Connected := False;

    Screen.Cursor := crHourglass;

    try

        fFirstgroup := True;
        fAllInOneLine := False;

        Report('Show','Opening Database');

        // -- Reset and use the provided connection string
        ADOConnection1.ConnectionString := fADOConnectionString;
        ADOConnection1.Connected := True;

        // -- Reset the progress display
        ggeProgress.Visible := True;
        ggeProgress.Value := 10;
        ggeProgress.Update;

        with qryGetItems do
        begin
            Active := False;

            SQL.Clear;
            SQL.Add(fSQL);

            Report('Show','Running Query');

            Active := True;

            // -- Clear the current pricelist
            fOutputPricelist.Clear;
            fDocRegistry.AddStandardVendorInfo(fOutputPricelist);

            // -- Writes the column names to the pricelist header
            OutputColumnTypes;

            // -- Temporarily knock off the last line (for speed)
            fOutputPricelist.XML.Delete(fOutputPricelist.XML.Count-1);
            fOutputPricelist.XML.Add('  <' + GTD_PL_PRODUCTINFO_TAG + '>');

            CorrectFieldNumbers;

            Report('Show','Producing Pricelist');

            // -- Progress report
            ggeProgress.Value := 20;
            recsavail := RecordCount;
            reccount := 0;

            First;
            while not Eof do
            begin

                ProcessCurrentRecord;

                Inc(reccount);

                ggeProgress.Value := 20 + (70 * ((100 * reccount) div recsavail)) div 100;

                Next;
            end;

            ggeProgress.Value := 90;

            Report('Show','Saving file');

            // -- Put back the last line
            fOutputPricelist.XML.Add('       </' + GTD_PL_PRODUCTITEMS_TAG + '>');
            fOutputPricelist.XML.Add('    </' + GTD_PL_PRODUCTGROUP_TAG + '>');
            fOutputPricelist.XML.Add('  </' + GTD_PL_PRODUCTINFO_TAG + '>');
            fOutputPricelist.XML.Add('</' + GTD_PL_PRICELIST_TAG + '>');

            ggeProgress.Value := 100;
            Report('Show','Complete');

            Result := True;

        end;
        
    finally
 	    Screen.Cursor := crDefault;
      ADOConnection1.Connected := False;
    end;
end;
//---------------------------------------------------------------------------
procedure TBuildPricelistFromDBRun.SetSkinData(Value: TbsSkinData);

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

    SkinaPanel(pnlBackground);

    dlgSelectProfile.SkinData := Value;
    dlgSelectProfile.CtrlSkinData := Value;
    ggeProgress.SkinData := Value;

    fSkinData := Value;
end;
//---------------------------------------------------------------------------
procedure TBuildPricelistFromDBRun.Report(const MsgType, Msg : String);
begin
    lblDescription.Caption := Msg;
    lblDescription.Update;
end;
//---------------------------------------------------------------------------
function TBuildPricelistFromDBRun.Load(const MapName : String):Boolean;
begin
    if not Assigned(fConfig) then
    begin
        // -- We exit now, although we could create the fConfig
        Exit;
    end
    else begin
        Result := fConfig.LoadMapping(MapName);
    end;
end;
//---------------------------------------------------------------------------
function TBuildPricelistFromDBRun.LoadFromConfig:Boolean;
var
    xc : Integer;
    f : String;
begin
    if Assigned(fConfig) then
    begin
        // -- Load the database stuff
        fADOConnectionString := fConfig.txtConnectionString.Text;
        fSQL := fConfig.mmoQry.Text;

        // -- Load the field mapping
        if not Assigned(fOutputFields) then
            fOutputFields := TStringlist.Create
        else
            fOutputFields.Clear;

        // -- For every defined field
        for xc := 0 to fConfig.lsvFieldList.Items.Count-1 do
        begin
            // -- If there is a defined field, sometimes there is not
            f := fConfig.lsvFieldList.Items[xc].SubItems[0];
            if f <> '' then
            begin
                // -- Add the logical pricelist column, then the number of the column
                //    in the recordset
                fOutputFields.AddObject(f,TObject(xc));
            end;
        end;

        Result := True;

    end;
end;
//---------------------------------------------------------------------------
procedure TBuildPricelistFromDBRun.bsSkinButton1Click(Sender: TObject);
begin
    if LoadFromConfig then
        Run;
end;

//---------------------------------------------------------------------------
function TBuildPricelistFromDBRun.ChooseProfileThenRun:Boolean;
var
    r : Integer;
    s : String;
begin
    if Assigned(fDocRegistry) then
    begin
        fDocRegistry.GetSettingItemList(BldplfrmDbConfigKey,dlgSelectProfile.SelectValues);
    end
    else
        Exit;

    if dlgSelectProfile.Execute('Pricelist Build','Select Profile',r) then
    begin
        // --
        s := dlgSelectProfile.SelectValues[r];

        // -- Here we read everything from the file
        Load(s);

        LoadFromConfig;

        Run;
    end;
end;
//---------------------------------------------------------------------------
function TBuildPricelistFromDBRun.ChooseTraderProfileThenRun:Boolean;

    procedure LoadCustomerList(CustList : TStringlist);
    var
        myList : TStringList;
        xc,tid : Integer;
        s,k : String;
    begin
        myList := TStringList.Create;
        try

            CustList.Clear;

            // -- Read a list of all the Customers in
            fDocRegistry.GetSettingItemList(BldCustomplfrmDbKey,myList);

            k := 'Trader#=';

            // -- Scan through all the entries
            for xc := 1 to myList.Count do
            begin

                s := myList[xc-1];

                if Pos(k,s) <> 0 then
                begin
                    // -- Retrieve the trader number
                    tid := StrToInt(Copy(s,9,Length(s)-8));

                    // -- Open this Trader
                    if fDocRegistry.OpenForTraderNumber(tid) then
                    begin
                        // -- Now add the Customer name into the list
                        CustList.AddObject(fDocRegistry.Trader_Name,TObject(tid));

                    end;
                end;

            end;

        finally
            myList.Destroy;
        end;

    end;

var
    r : Integer;
    s : String;
    CustList : TStringList;
begin
    dlgSelectProfile.SelectValues.Clear;

    if not Assigned(fDocRegistry) then
        Exit;

    try
        CustList := TStringList.Create;

        // -- Load up the names and ids of customers with special pricelists
        LoadCustomerList(CustList);

        // -- Copy over names to the dialog box
        dlgSelectProfile.SelectValues.Assign(CustList);

        // -- Pop the dialog
        if dlgSelectProfile.Execute('Pricelist Build','Select Customer ',r) then
        begin
            // -- Get the trader number
            fTrader_ID := Integer(CustList.Objects[r]);

            RunCustomerPricelist(fTrader_ID);
        end;

    finally
        CustList.Destroy;
    end;
end;
//---------------------------------------------------------------------------
function TBuildPricelistFromDBRun.RunCustomerPricelist(Trader_ID : Integer):Boolean;
var
    s : String;
    RunTime : TDateTime;
begin
    s := 'Trader#='+IntToStr(Trader_ID);

    // -- Here we read everything from the file
    if Load(s) then
    begin

        LoadFromConfig;

        if Run then
        begin

          RunTime := Now;

          // -- Open the registry on this trader
          fDocRegistry.OpenForTraderNumber(Trader_ID);

          // -- Set ownership properties
          fOutputPricelist.Owned_By := 0;
          fOutputPricelist.Shared_With := Trader_ID;

          // -- Now save this pricelist
          fDocRegistry.SaveAsLatestPriceList(fOutputPricelist,RunTime,s);

          // -- Save
          fDocRegistry.SaveTraderSettingDateTime(PL_DELIV_NODE,PL_DELIV_LAST_GEN,RunTime);

//<Pricelist Delivery>
//  Last_Sent
        end;

    end;
end;
//---------------------------------------------------------------------------
{function TBuildPricelistFromDBRun.CheckNeedsRebuild(Trader_ID : Integer):Boolean;
begin
  // -- To implement: This function should check if
  Result := True;
end;
}
end.
