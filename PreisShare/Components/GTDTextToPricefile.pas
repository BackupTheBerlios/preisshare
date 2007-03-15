unit GTDTextToPricefile;

interface

uses
  {$IFDEF WIN32}
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,GTDBizDocs;
  {$ELSE}
  SysUtils, Types, Classes, Variants, QTypes, QGraphics, QControls, QForms,
  QDialogs, QStdCtrls,GTDBizDocs;
  {$ENDIF}

const
    MaxInputPricefileColumns = 100;

    LOGICAL_CODE_COL = 1;
    LOGICAL_NAME_COL = 2;
    LOGICAL_DESC_COL = 3;
    LOGICAL_BUY_COL  = 4;
    LOGICAL_SELL_COL = 5;
    LOGICAL_GROUPLVL1= 6;

type
  gtPriceInputFileType       = (pltReportLayout, // -- Printed Style
                                pltDataLayout    // -- Data style
                               );
                               
  gtPriceFileProcessingState = (plpNone,
                                plpAddress,     // -- Company address information
								plpChurn,		// -- Nothing of consequence
								plpHeader,	    // -- Some sort of header
								plpItemData     // -- Compact
                               );
        gtPriceFileLineType        = (pltUnRecognised,
								pltWhitespace,	// -- Nothing of consequence
                                pltColumnHeader,// -- Has names of columns
								pltGroup1,	    // -- Some sort of header
								pltGroup2,	    // -- Some sort of header
								pltGroup3,	    // -- Some sort of header
								pltItemData     // -- Compact
               				   );
  gtPriceFileItemDataLayout  = (plilTabbed,     // -- Tab seperated
                                plilCSV,        // -- Comma seperated
								plilFixed	    // -- fixed width
               				   );

  GTDPricefileConversionProgress = procedure(Sender : TObject; PercentComplete : Integer; Description : String) of object;

  GTDPricefileDataCol = class(Tobject)
  public
    xPos,
    xWidth              : Integer;
    ColumnName          : String;
    LogicalCol          : Integer;
  end;

  GTDPricefileConvertor = class(TMemo)
  private
	   { Private declarations }
   	fState : gtPriceFileProcessingState;

    fLearning,
    fItemsGroupedProperly : Boolean;

    fInputData,
   	fFieldMap,
    fVendorInfo         : TStringList;
    fProductGroupCount  : Integer;

   	fOutputDoc         : GTDBizDoc;

    fDataFormat         : gtPriceInputFileType;

    fLineItemLayout     : gtPriceFileItemDataLayout;

    fOnConversionProgress : GTDPricefileConversionProgress;

    HaveSeenColumnHeading : Boolean;

    // -- Quick Indexes
    // -- Fixed with field positions
   	fCodePos,fCodeLen,
   	fDescPos,fDescLen,
   	fBuyPos,fBuyLen,
   	fSellPos,fSellLen,
    fGroupLevel1Pos,fGroupLevel1Len   : Integer;

    // -- Names of the columns
    fCodeCol,
    fDescCol,
    fBuyCol,
    fSellCol,
    fGroupLevel1Col,

    // -- Filtering options
   	fHeadingTextWords,
   	fRejectLineWords,
   	fStripWords : String;

    // -- Keywords
    fCodeWords,
    fDescWords,
    fBuyWords,
    fSellWords : String;

    lastlineType : gtPriceFileLineType;

    // -- Product Group Tracking
    l1GrpName,l2GrpName,l3GrpName : String;

  protected
	{ Protected declarations }
  public
	{ Public declarations }

    // -- Public definitions for mappings
    CodeColumn,
    DescColumn,
    BuyColumn,
    SellColumn,

    ColCount            : Integer;
    ColDefs             : Array[1..MaxInputPricefileColumns] of GTDPricefileDataCol;

    procedure Clear;
   	procedure Start;
   	procedure Finish;

    procedure ProcessFromConfigFile(aConfigFileName : String);

   	function  ProcessList(aList : TStrings; ExamineFormatOnly : Boolean = False; AsAProductGroup : Boolean = False):Boolean;
   	function  DetermineLineType(aLine : String;hasExtraFormatting : Boolean = False):gtPriceFileLineType;

    function  ProcessColumnHeaders(aLine : String):Boolean;
    function  LooksLikeaColumnHeading(aLine : String):Boolean;
   	procedure ProcessHeaderLine(aLine : String);
   	procedure ProcessItemLine(aLine : String);

   	function  CleanLine(aLine : String):String;
   	function  ExtractText(aLine : String; StartPos, Width : Integer):String;
    function  CountLeadingSpaces(aLine : String):Integer;
    function  ExtractTabbedField(aLine : String; FieldNumber : Integer):String;
    function  PostExtractionFixup(var Product_Id : String;
                                                   var Product_Name : String;
                                                   var Product_Desc : String;
                                                   var Product_List : String;
                                                   var Product_Sell : String;
                                                   var G1_Name : String
                                                  ):gtPriceFileLineType;

    procedure OutputTraderInformation;
    procedure StartProductInformation;
    procedure EndProductInformation;
    procedure StartProductGroup(aGroup : String; Level : Integer = 1);
    procedure EndProductGroup(Level : Integer = 1);
    procedure OutputLineItem(aLineItem : String);

    procedure UseVendorInfoFile(aFilename : String);

    procedure AssignOutputTo(aList : TStrings);
    procedure SaveOutputToFile(aFilename : String);

    procedure LoadCSV(aFilename : String);

    // -- Column discovery variables
    procedure ClearDiscoveredColumns;
    function AddDiscoveredColumn(ColumnName : String; FixedPosition,VarPosStart,VarPosLen : Integer):Boolean;
    function ResolvedDiscoveredColumns:Boolean;

    // -- Column mapping functions
    procedure ClearColumnMappings;
    function MapColumnToField(ColumnName, LogicalplField : String):Boolean;

    procedure ReportMessage(const msgType : WideString; const MsgText : WideString);

  published
	{ Published declarations }
    property DataFormat   : gtPriceInputFileType read fDataFormat write fDataFormat;

   	property CodePosition : integer read fCodePos write fCodePos;
   	property CodeLength   : integer read fCodeLen write fCodeLen;
    property CodeWords    : String read fCodeWords write fCodeWords;
    property DescPosition : integer read fDescPos write fDescPos;
    property DescLength   : integer read fDescLen write fDescLen;
    property DescWords    : String read fDescWords write fDescWords;
   	property BuyPosition  : integer read fBuyPos  write fBuyPos;
	   property BuyLength    : integer read fBuyLen  write fBuyLen;
    property BuyWords     : String read fBuyWords write fBuyWords;
	   property SellPosition : integer read fSellPos write fSellPos;
	   property SellLength   : integer read fSellLen write fSellLen;
    property SellWords    : String read fSellWords write fSellWords;

    property CodeColumnName : string read fCodeCol write fCodeCol;
    property DescColumnName : string read fDescCol write fDescCol;
    property BuyColumnName  : string read fBuyCol  write fBuyCol;
    property SellColumnName : string read fSellCol write fSellCol;

    property HeadingTextWords : String read fHeadingTextWords write fHeadingTextWords;
    property LineRejectWords  : String read fRejectLineWords write fRejectLineWords;
    property LineRemoveWords  : String read fStripWords write fStripWords;

    property LineItemLayout : gtPriceFileItemDataLayout read fLineItemLayout write fLineItemLayout;

    property FieldMap       : TStringList read fFieldMap;

    property Learning       : Boolean read fLearning write fLearning;

    property OutputPricelist : GTDBizDoc read fOutputDoc write fOutputDoc;

    property OnConversionProgress : GTDPricefileConversionProgress read fOnConversionProgress write fOnConversionProgress;

  end;

procedure Register;

implementation
uses DelphiUtils;

const
    StdCodeWords   = 'CODE;PRODUCT_ID;PRODUCT NO;ITEM NUMBER;PART NUMBER;PART NO.;ARTICLE NO.;PLU;PID';
    StdCodeRatings = '50;50;50';
    StdNameWords   = 'NAME;DESCRIPTION;ITEM DESCRIPTION;PART DESCRIPTION';
    StdNameRatings = '50;50';
    StdDescWords   = 'DESCRIPTION';
    StdDescRatings = '50';
    StdBuyWords    = 'YOUR PRICE;COST PRICE;PRICE';
    StdBuyRatings  = '50;50';
    StdSellWords   = 'RETAIL;LIST PRICE;RRP';
    StdSellRatings = '50;50';

    StdAllWords    = StdCodeWords + ';' +
                     StdNameWords + ';' +
                     StdDescWords + ';' +
                     StdBuyWords + ';' +
                     StdSellWords;

//---------------------------------------------------------------------------
procedure GTDPricefileConvertor.Start;
var
    xc : Integer;
begin
	fState := plpNone;

    HaveSeenColumnHeading := False;

    fProductGroupCount := 0;

    // -- This is where the output is going so clear it
    fOutputDoc.XML.Clear;

end;
//---------------------------------------------------------------------------
//
// CLear
//
// This is the initialisation routine.
//
procedure GTDPricefileConvertor.Clear;
var
    xc : Integer;
begin
    ColCount := 0;

	if not Assigned(fFieldMap) then
        fFieldMap := TStringList.Create
    else
        fFieldMap.Clear;

    if not Assigned(fVendorInfo) then
        fVendorInfo := TStringList.Create;

    if not Assigned(ColDefs[1]) then
        for xc := 1 to MaxInputPricefileColumns do
            ColDefs[xc] := GTDPricefileDataCol.Create;

    if not Assigned(fOutputDoc) then
        fOutputDoc := GTDBizDoc.Create(Self)
    else
        fOutputDoc.Clear;

    // -- Clear the display
    Lines.Clear;
    // -- Now add some user information
    Lines.Add('Spreadsheet Price Decoder');
    Lines.Add('(c) Global Tradedesk Technology Pty Limited 2004-2006');
    Lines.Add('Initialised and ready.');

    fCodePos := -1;
    fCodeLen := 0;
    fDescPos := -1;
    fDescLen := 0;
    fBuyPos  := -1;
    fBuyLen  := 0;
    fSellPos := -1;
    fSellLen := 0;
    fGroupLevel1Pos := -1;
    fGroupLevel1Len := 0;

    fItemsGroupedProperly := False;

end;
//---------------------------------------------------------------------------
procedure GTDPricefileConvertor.Finish;
begin
	if Assigned(fFieldMap) then
    begin
		fFieldMap.Destroy;
        fFieldMap := nil;
    end;
end;
//---------------------------------------------------------------------------
function GTDPricefileConvertor.ProcessList(aList : TStrings; ExamineFormatOnly, AsAProductGroup : Boolean):Boolean;
var
	xc : Integer;
	l : String;
    lineType : gtPriceFileLineType;

    function WordFilterCheck(aLine : WideString):Boolean;
    var
        w,s : String;
    begin
        Result := True;
		s := fRejectLineWords;
		w := Parse(s,'|');
		while w <> '' do
		begin
            // -- Check for the word
			if Pos(w,aLine) <> 0 then
			begin
				Result := False;
				break;
			end;

			// -- Get the              next word
			w := Parse(s,'|');
		end;
    end;

begin
	Start;

    fLearning := ExamineFormatOnly;

    if not AsAProductGroup then
    begin
        OutputTraderInformation;

        StartProductInformation;
    end;

	for xc := 0 to aList.Count-1 do
	begin

		l := aList[xc];

		// -- Check for words that will reject the line
		if not WordFilterCheck(l) then
			continue;

        lineType := DetermineLineType(l,aList.Objects[xc] <> nil);

        case lineType of
            pltUnRecognised : ;
            pltWhitespace :	// -- Nothing of consequence
                            ;
            pltColumnHeader:
                            // -- Locations of all the columns
                            ProcessColumnHeaders(Uppercase(l));
			pltGroup1 :	    // -- Some sort of header
                            ProcessHeaderLine(l);
			pltGroup2 :	    // -- Some sort of header
                            ;
			pltGroup3 :	    // -- Some sort of header
                            ;
			pltItemData :   // -- Compact
                            if ExamineFormatOnly then
                            begin
                                // -- Don't process data, we have done everything
                                Result := True;
                                Exit;
                            end
                            else
                                ProcessItemLine(l);
        else
            ;
        end;

        // -- Save the last linetype for next line
        lastlineType := lineType;

	end;

    EndProductGroup;
    if not AsAProductGroup then
    begin
        EndProductInformation;
    end;

	Finish;

    Result := True;
end;
//---------------------------------------------------------------------------
function  GTDPricefileConvertor.DetermineLineType(aLine : String; hasExtraFormatting : Boolean):gtPriceFileLineType;
var
    ls : Integer;
begin
    if Length(aLine) = 0 then
    begin
        Result := pltWhitespace;
        Exit;
    end;

    // -- The default
    Result := pltUnRecognised;

    // -- Do a different determination if it is text or tabbed
    if fDataFormat = pltReportLayout then
    begin
        // -- This really should have some kind of pattern matching
        ls := CountLeadingSpaces(aLine);

        if (ls = 0) then
            Result := pltGroup1
        else
            Result := pltItemData;
    end
    else if fDataFormat = pltDataLayout then
    begin
        if not HaveSeenColumnHeading then
        begin
            if LooksLikeaColumnHeading(Uppercase(aLine)) then
            begin
                HaveSeenColumnHeading := True;
                Result := pltColumnHeader;
            end;
        end
        else begin
            if hasExtraFormatting then
                Result := pltGroup1
            else
                Result := pltItemData;
        end;
    end;
end;

//---------------------------------------------------------------------------
procedure GTDPricefileConvertor.ClearDiscoveredColumns;
begin
    ColCount := 0;
end;

//---------------------------------------------------------------------------
function GTDPricefileConvertor.AddDiscoveredColumn(ColumnName : String; FixedPosition,VarPosStart,VarPosLen : Integer):Boolean;
begin
    fFieldMap.Add(ColumnName);

    Inc(ColCount);

    // -- Check that we haven't added too many columns
    if (ColCount > MaxInputPricefileColumns) then
    begin
        ReportMessage('Error',' Too many columns at column ' + ColumnName);
        Exit;
    end;

    ColDefs[ColCount].ColumnName := ColumnName;
    with ColDefs[ColCount] do
    begin
        if FixedPosition <> -1 then
            xPos := FixedPosition
        else
        begin
            xPos := VarPosStart;
            xWidth := VarPosLen;
        end;
    end;

    // -- Product_ID
    if Pos(ColumnName,StdCodeWords) <> 0 then
    begin
        ReportMessage('Show',' Found column ' + ColumnName + '. Using as product code');

        if FixedPosition <> -1 then
            fCodePos := FixedPosition
        else
        begin
            fCodePos := VarPosStart;
            fCodeLen := VarPosLen;
        end;

        fCodeCol := ColumnName;

        ColDefs[ColCount].LogicalCol := LOGICAL_CODE_COL;

    end
    // -- Product Name
    else if Pos(ColumnName,StdNameWords) <> 0 then
    begin

        ReportMessage('Show',' Found column ' + ColumnName + '. Using as product Name');

        if FixedPosition <> -1 then
            fDescPos := FixedPosition
        else
        begin
            fDescPos:= VarPosStart;
            fDescLen := VarPosLen;
        end;

        fDescCol := ColumnName;

        ColDefs[ColCount].LogicalCol := LOGICAL_NAME_COL;
    end
    // --
    else if Pos(ColumnName,StdDescWords) <> 0 then
    begin
        ReportMessage('Show',' Found column ' + ColumnName + '. Using as product Description');

        if FixedPosition <> -1 then
            fDescPos := FixedPosition
        else
        begin
            fDescPos:= VarPosStart;
            fDescLen := VarPosLen;
        end;
        ColDefs[ColCount].LogicalCol := LOGICAL_DESC_COL;
    end
    // --
    else if Pos(ColumnName,StdBuyWords) <> 0 then
    begin
        ReportMessage('Show',' Found column ' + ColumnName + '. Using as Buy Price');

        if FixedPosition <> -1 then
            fBuyPos := FixedPosition
        else
        begin
            fBuyPos := VarPosStart;
            fBuyLen := VarPosLen;
        end;

        fBuyCol := ColumnName;
        ColDefs[ColCount].LogicalCol := LOGICAL_BUY_COL;

    end
    // --
    else if Pos(ColumnName,StdSellWords) <> 0 then
    begin
        ReportMessage('Show',' Found column ' + ColumnName + '. Using as Sell Price');

        if FixedPosition <> -1 then
            fSellPos := FixedPosition
        else
        begin
            fSellPos := VarPosStart;
            fSellLen := VarPosLen;
        end;

        fSellCol := ColumnName;
        ColDefs[ColCount].LogicalCol := LOGICAL_SELL_COL;

    end;
    // --
end;

//---------------------------------------------------------------------------
function GTDPricefileConvertor.ResolvedDiscoveredColumns:Boolean;
begin
end;

//---------------------------------------------------------------------------
// ProcessColumnHeaders
//
// This routine is manily for data in tabular format
//
function GTDPricefileConvertor.ProcessColumnHeaders(aLine : String):Boolean;
var
    l, w : String;
    cc : Integer;
begin
    // --
    if (DataFormat = pltDataLayout) then
    begin
        l := Uppercase(aLine);

        // -- Process each of the column headers
        if fLineItemLayout = plilTabbed then
        begin
            if fLearning then
            begin
                ClearDiscoveredColumns;

                cc := 0;
                repeat
                    w := Parse(l,Chr(9));

                    if (w <> '') then
                        AddDiscoveredColumn(w,cc,-1,-1);

                    Inc(cc);

                until (l = '');
            end;
        end;
    end;
end;
//---------------------------------------------------------------------------
function GTDPricefileConvertor.LooksLikeaColumnHeading(aLine : String):Boolean;
var
    xc,tic : Integer;
    l,s,w : String;
begin
    Result := False;

    // -- Firstly, there should be text in more than one column
    if (DataFormat = pltDataLayout) then
    begin
      l := aLine;
      tic := 0;
      // -- Count up the number of columns with text
      repeat
        w := Parse(l,Chr(9));
        if (Length(w) <> 0) then
          Inc(tic);
      until Length(l) = 0;

      // -- If text is in only one column then it cannot be
      if (tic <= 1) then
        Exit;
    end;

    // -- If any column heading word is found, return true
    //    note, this function should really return true only
    //    if several words are found
    l := StdAllWords;
    w := Parse(l,';');
    while w <> '' do
    begin
        // -- Check for the word
        if Pos(w,aLine) <> 0 then
        begin
            Result := True;
            break;
        end;

        // -- Get the next word
        w := Parse(l,';');
    end;

end;
//---------------------------------------------------------------------------
procedure GTDPricefileConvertor.ProcessHeaderLine(aLine : String);
var
	l : String;
begin
	l := Trim(CleanLine(aLine));
	if l <> '' then
    begin
        // -- Before we start a new product group, we may have to close
        //    off the last one
        if (fProductGroupCount <> 0) then
            EndProductGroup;

        Inc(fProductGroupCount);

		StartProductGroup(l,1);
    end;
end;
//---------------------------------------------------------------------------
procedure GTDPricefileConvertor.ProcessItemLine(aLine : String);
var
	c,n,d,r,l,lp,sp,g1 : String;
	xc,fnws : Integer;
    lt : gtPriceFileLineType;
begin
    if fLineItemLayout = plilFixed then
    begin

        l := CleanLine(aLine);
        for xc := 1 to length(l) do
            if (l[xc]<>' ') then
            begin
                fnws := xc;
                break;
            end;

        // -- Extract the item code
        c := ExtractText(l,fCodePos,fCodeLen);
        if c = '' then
            Exit;

        n := ExtractText(l,fDescPos,fDescLen);
        if n = '' then
            Exit;

        if (c[1]=' ') or (d[1]=' ') then
            Exit;

        sp := Trim(ExtractText(l,fBuyPos,fBuyLen));
        if (sp = '') or (not isNumber(sp)) then
            Exit;

    	r := IntToStr(fnws) + '('+IntToStr(Ord(l[fnws])) + ') ';

    end
    else if fLineItemLayout = plilTabbed then
    begin
        r := '';

        // -- Here we extract values from a tab seperated line
        if (CodePosition <> -1) then
            c := Trim(ExtractTabbedField(aLine,CodePosition));
        if (DescPosition <> -1) then
	    	n := Trim(ExtractTabbedField(aLine,DescPosition));
        if (BuyPosition <> -1) then
    		sp := ExtractTabbedField(aLine,BuyPosition);
        if (SellPosition <> -1) then
    		lp := ExtractTabbedField(aLine,SellPosition);
        if (fGroupLevel1Pos <> -1) then
            g1 := ExtractTabbedField(aLine,fGroupLevel1Pos);

    end;

    // -- Here we re-examine all the data, shuffle if neccessary before saving
    lt := PostExtractionFixup(c,n,d,lp,sp,g1);

    if (lt = pltItemData) then
    begin

        // -- It's possible that no product group was found for these items
        //    so what we do is provide for them a default group
        if not fItemsGroupedProperly then
        begin
            if (g1 = '') then
                g1 := 'Items';

            StartProductGroup(g1);

            fItemsGroupedProperly := True;
        end
        // -- Check for a change in group name
        else if (g1 <> l1GrpName) then
        begin
            EndProductGroup;
            StartProductGroup(g1);
        end;

        if (c <> '') then
            r := r + EncodeStringField(GTD_PL_ELE_PRODUCT_PLU,c) + #13 + #10;

        if (n <> '') then
            r := r + '          ' + EncodeStringField(GTD_PL_ELE_PRODUCT_NAME,n) + #13 + #10;

        if (lp <> '') then
            r := r + '          ' + EncodeStringField(GTD_PL_ELE_PRODUCT_LIST,lp);

        if (sp <> '') then
            r := r + '          ' + EncodeStringField(GTD_PL_ELE_PRODUCT_ACTUAL,sp);

        OutputLineItem(r);
    end
    else if (lt = pltGroup1) then
    begin
        // -- We are in a new product group
        EndProductGroup;
        StartProductGroup(g1);
    end;

end;
//---------------------------------------------------------------------------
function GTDPricefileConvertor.PostExtractionFixup(var Product_Id : String;
                                                   var Product_Name : String;
                                                   var Product_Desc : String;
                                                   var Product_List : String;
                                                   var Product_Sell : String;
                                                   var G1_Name : String
                                                  ):gtPriceFileLineType;
var
    x : Integer;
begin
    // -- Here we re-examine the line contents
    //    and change the line type if neccessary

    // -- This is arbitary logic

    // -- This first check is for a product group
    if (Product_Id <> '') and (Product_Name='') and (Product_Desc='')
                          and (Product_List='') and (Product_Sell='') then
    begin
        // -- Probably a product group
        G1_Name := Product_Id;
        Result := pltGroup1;
        Exit;
    end;

    // -- This first check is for a product group
    if (Product_Name <> '') and (Product_Id='') and (Product_Desc='')
                          and (Product_List='') and (Product_Sell='') then
    begin
        // -- Probably a product group
        G1_Name := Product_Name;
        Result := pltGroup1;
        Exit;
    end;

    if (Product_Name <> '') then
        Result := pltItemData;

    // -- Clean up the list price
    if Pos('$',Product_List)<>0 then
        Product_List := ReplaceText('$','',Product_List);

    // -- Clean up the sell price
    if Pos('$',Product_Sell)<>0 then
        Product_Sell := ReplaceText('$','',Product_Sell);

end;
//---------------------------------------------------------------------------
function  GTDPricefileConvertor.CleanLine(aLine : String):String;
var
	s,w,l : String;
	wp : Integer;
begin
	// -- Check the line to see if it has any Heading indicators
	l := aLine;

	// -- Remove stripwords
	s := fStripWords;
	w := Parse(s,'|');
	while w <> '' do
	begin
		wp := Pos(w,l);
		if wp <> 0 then
		begin
			l := Copy(l,1,wp-1) + Copy(l,wp+Length(w),Length(l)-(wp+Length(w)));
		end;

		// -- Get the next word
		w := Parse(s,'|');

	end;

	// -- Convert tabs to spaces
	s := l;
	l := '';
	for wp := 1 to Length(s) do
		if s[wp] <> #9 then
			l := l + s[wp]
		else
			l := l + '        ';

	Result := l;
end;
//---------------------------------------------------------------------------
function GTDPricefileConvertor.ExtractText(aLine : String; StartPos, Width : Integer):String;
var
	s : String;
begin
	s := Copy(aLine,STartPos,Width);
	s := Trim(s);

	Result := s;
end;

//---------------------------------------------------------------------------
procedure GTDPricefileConvertor.OutputTraderInformation;
var
    xc : Integer;
begin
    fOutputDoc.XML.Add('<'+GTD_PL_PRICELIST_TAG+'>');
    if Assigned(fVendorInfo) and (fVendorInfo.Count > 0) then
    begin
        for xc := 1 to fVendorInfo.Count do
        begin
            fOutputDoc.XML.Add(fVendorInfo.Strings[xc-1]);
        end;
    end;
end;
//---------------------------------------------------------------------------
procedure GTDPricefileConvertor.StartProductInformation;
begin
    fOutputDoc.XML.Add('  <'+GTD_PL_PRODUCTINFO_TAG+'>');
end;
//---------------------------------------------------------------------------
procedure GTDPricefileConvertor.EndProductInformation;
begin
    fOutputDoc.XML.Add('  </'+GTD_PL_PRODUCTINFO_TAG+'>');
    fOutputDoc.XML.Add('</'+GTD_PL_PRICELIST_TAG+'>');
end;
//---------------------------------------------------------------------------
procedure GTDPricefileConvertor.StartProductGroup(aGroup : String; Level : Integer = 1);
begin
    ReportMessage('Show','Processing Product Group [' + aGroup + ']');

    fOutputDoc.XML.Add('    <'+GTD_PL_PRODUCTGROUP_TAG+'>');
    fOutputDoc.XML.Add('      ' + EncodeStringField(GTD_PL_ELE_GROUP_NAME,aGroup));
    fOutputDoc.XML.Add('      <'+GTD_PL_PRODUCTITEMS_TAG+'>');

    if (Level =1) then
        l1GrpName := aGroup;

    fItemsGroupedProperly := True;

end;
//---------------------------------------------------------------------------
procedure GTDPricefileConvertor.EndProductGroup(Level : Integer = 1);
begin
    if (Level = 1) then
    begin
        if (l1GrpName <> '') then
        begin
            fOutputDoc.XML.Add('      </'+GTD_PL_PRODUCTITEMS_TAG+'>');
            fOutputDoc.XML.Add('    </'+GTD_PL_PRODUCTGROUP_TAG+'>');
            l1GrpName := '';
        end;
    end;
end;
//---------------------------------------------------------------------------
procedure GTDPricefileConvertor.OutputLineItem(aLineItem : String);
begin
    fOutputDoc.XML.Add('        <'+GTD_PL_PRODUCTITEM_TAG+'>');
    fOutputDoc.XML.Add('          ' + aLineItem);
    fOutputDoc.XML.Add('        </'+GTD_PL_PRODUCTITEM_TAG+'>');
end;
//---------------------------------------------------------------------------
procedure GTDPricefileConvertor.SaveOutputToFile(aFilename : String);
begin
    ReportMessage('Show','Saving to file ' + aFilename);
    fOutputDoc.XML.SaveToFile(aFilename);
end;
//---------------------------------------------------------------------------
procedure GTDPricefileConvertor.AssignOutputTo(aList : TStrings);
begin
    aList.Assign(fOutputDoc.XML);
end;
//---------------------------------------------------------------------------
procedure GTDPricefileConvertor.UseVendorInfoFile(aFilename : String);
begin
    if not Assigned(fVendorInfo) then
        fVendorInfo := TStringList.Create;

    fVendorInfo.LoadFromFile(aFilename);
end;
//---------------------------------------------------------------------------
function GTDPricefileConvertor.ExtractTabbedField(aLine : String; FieldNumber : Integer):String;
var
    xc,foundtabs,fieldstartpos  : Integer;
begin
    foundtabs := 0;
    fieldstartpos := 0;

    // -- Loop through the line
    for xc := 1 to Length(aLine) do
    begin
        if aLine[xc] = #9 then
        begin
            Inc(foundtabs);

            if (foundtabs = FieldNumber-1) then
                // -- We have found the start of our field
                fieldstartpos := xc + 1
            else if (foundtabs = FieldNumber) then
            begin
                // -- We have found the next tab so stop
                if (fieldstartpos = 0) then
                    fieldstartpos := 1;
                    
                Result := Copy(aLine,fieldstartpos,xc-fieldstartpos);
                break;
            end;
        end;
    end;
    // -- if we got to here we probably were supposed to return the last field
    if (fieldstartpos <> 0) and (Result = '') then
    begin
        Result := Copy(aLine,fieldstartpos,Length(aLine)-fieldstartpos);
    end;
end;
//---------------------------------------------------------------------------
function GTDPricefileConvertor.CountLeadingSpaces(aLine : String):Integer;
var
    xc,mypos : Integer;
begin
    Result := 0;
    mypos  := 1;
    for xc := 1 to Length(aLine) do
    begin
        if aLine[xc] = #9 then
        begin
            // -- We have a tab
            mypos := mypos + 8;
        end
        else if aLine[xc] = ' ' then
            // -- A space means increment the count
            Inc(mypos)
        else begin
            // -- Non whitespace, finish up
            Result := mypos - 1;
            break;
        end
    end;
end;
//---------------------------------------------------------------------------
procedure GTDPricefileConvertor.ReportMessage(const msgType : WideString; const MsgText : WideString);
begin
    if (msgType = 'Clear') then
        Lines.Clear
    else
        Lines.Add(MsgText);
end;

//---------------------------------------------------------------------------
procedure GTDPricefileConvertor.ClearColumnMappings;
begin
    // -- This was the original way of doing things
	fCodePos := -1;
    fCodeLen := -1;
	fDescPos := -1;
    fDescLen := -1;
	fBuyPos  := -1;
    fBuyLen  := -1;
	fSellPos := -1;
    fSellLen := -1;

    // -- This is the new way, but not sure if implemented
    if Assigned(fFieldMap) then
        fFieldMap.Clear;
end;
//---------------------------------------------------------------------------
function GTDPricefileConvertor.MapColumnToField(ColumnName, LogicalplField : String):Boolean;
var
    dc : GTDPricefileDataCol;
    xc,cn : Integer;
begin
    // -- Find the column
    cn := -1;
    for xc := 1 to MaxInputPricefileColumns do
    begin
        dc := ColDefs[xc];
        if (dc.ColumnName = ColumnName) then
        begin
            cn := xc;
            break;
        end;
    end;

    // -- Now set variables if the column was found
    if (cn <> -1) then
    begin
        if (LogicalplField = GTD_PL_ELE_PRODUCT_PLU) then
        begin
            fCodePos := cn;
        end
        else if (LogicalplField = GTD_PL_ELE_PRODUCT_NAME) then
        begin
            fDescPos := cn;
        end
        else if (LogicalplField = GTD_PL_ELE_PRODUCT_DESC) then
        begin
        end
        else if (LogicalplField = GTD_PL_ELE_PRODUCT_LIST) then
        begin
            fSellPos := cn;
        end
        else if (LogicalplField = GTD_PL_ELE_PRODUCT_ACTUAL) then
        begin
            fBuyPos := cn;
        end
        else if (LogicalplField = GTD_PL_PRODUCTGROUP_TAG) then
        begin
            fGroupLevel1Pos := cn;
        end
        else if (LogicalplField = GTD_PL_ELE_PRODUCT_TAXR) then
        begin
        end
        else if (LogicalplField = GTD_PL_ELE_PRODUCT_BRAND) then
        begin

            // Add(GTD_PL_ELE_PRODUCT_TAXT);
            // Add(GTD_PL_ELE_PRODUCT_UNIT);
            // Add(GTD_PL_ELE_PRODUCT_MINORDQTY);
            // Add(GTD_PL_ELE_PRODUCT_TYPE);
            // Add(GTD_PL_ELE_PRODUCT_IMAGE);
            // Add(GTD_PL_ELE_PRODUCT_BIGIMAGE);
            // Add(GTD_PL_ELE_PRODUCT_MOREINFO);
            // Add(GTD_PL_ELE_BRANDNAME);
            // Add(GTD_PL_ELE_MANUFACT_NAME);
            // Add(GTD_PL_ELE_MANUFACT_GTL);
            // Add(GTP_PL_ELE_MANUFACT_PRODINFO);
            // Add(GTD_PL_ELE_PRODUCT_AVAIL_FLAG);
            // Add(GTD_PL_ELE_PRODUCT_AVAIL_DATE);
            // Add(GTD_PL_ELE_PRODUCT_AVAIL_STATUS);

        end;
    end;

    //xPos,
    //xWidth              : Integer;
    //ColumnName          : String;
    //LogicalCol          : Integer;


end;
//---------------------------------------------------------------------------
procedure GTDPricefileConvertor.ProcessFromConfigFile(aConfigFileName : String);
var
    myConf : GTDBizDoc;
    myFile : TStringList;
    vendorInfoFilename,ploutputFilename,txtinputFilename : String;
begin
    myFile := TStringList.Create;
    myConf := GTDBizDoc.Create(Self);

    try

        myConf.LoadFromFile(aConfigFileName);

        // -- Load up the field positions
        CodePosition := myConf.GetIntegerElement('/Fixed Field Positions','CodePosition',0);
        DescPosition := myConf.GetIntegerElement('/Fixed Field Positions','DescPosition',0);
        BuyPosition  := myConf.GetIntegerElement('/Fixed Field Positions','BuyPosition',0);

        // -- Load up filters
        HeadingTextWords := myConf.GetStringElement('/Filters','HeadingTextWords');
        LineRemoveWords  := myConf.GetStringElement('/Filters','LineRemoveWords');
        LineRejectWords  := myConf.GetStringElement('/Filters','LineRejectWords');

        LineItemLayout := plilTabbed;

        // -- Load up our primary input
        txtinputFilename := myConf.GetStringElement('/File Paths','InputFile');
        if (txtinputFilename <> '') and (FileExists(txtinputFilename)) then
            myFile.LoadFromFile(txtinputFilename);

        // -- Vendor Information can be stored in a file
        vendorInfoFilename := myConf.GetStringElement('/File Paths','VendorInfoFile');
        if (vendorInfoFilename <> '') and (FileExists(vendorInfoFilename)) then
            UseVendorInfoFile(vendorInfoFilename);

        ProcessList(myFile);

        // -- If we have a file to output to, send it there
        ploutputFilename := myConf.GetStringElement('/File Paths','PricelistOutputFile');
        if (ploutputFilename <> '') then
            SaveOutputToFile(ploutputFilename);
    finally
        myFile.Destroy;
        myConf.Destroy;
    end;
end;

procedure GTDPricefileConvertor.LoadCSV(aFilename : String);
begin
  ClearColumnMappings;

  fDataFormat := pltDataLayout;

end;

procedure Register;
begin
  RegisterComponents('PreisShare', [GTDPricefileConvertor]);
end;

end.
