unit GTDPricelists;

interface

uses
  {$IFDEF LINUX}
	SysUtils, Types, Classes, Variants, QTypes, QGraphics, QControls, QForms,
	QDialogs, QStdCtrls, DateUtils,QExtCtrls,
  {$ELSE}
	Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
	StdCtrls, ToolWin, ComCtrls, FileCtrl, Db, DbTables, BDE, ShlObj,
	ShellAPI,
	{$IFNDEF HW_SIMPLE} jpeg ,GTDColorButtonList, {$ENDIF}
	extctrls, HCMngr, DiffUnit,
  {$ENDIF}
  GTDBizDocs,
  {Sinu added for vtkExport}
  BIFF8_Types, vteExcel, vteExcelTypes, vteWriters,
  xmldom, XMLIntf, msxmldom, XMLDoc
  {Sinu}
  ;

const
    // -- These constants function as bit flags
    PL_ITEM_STEADY = 0;
    PL_ITEM_NEW = 1;
    PL_ITEM_REMOVED = 2;
    PL_ITEM_RISEN = 4;
    PL_ITEM_FALLEN = 8;
    PL_ITEM_DETAILS = 16;

type
  //-- Pricelist - This is an abstraction of a pricelist
  GTDPricelist = class(GTDBizDoc)
	public
      ItemList   : TStringList;

	    function LoadProductGroupTree(aListView : TTreeView):Boolean; overload;
      function LoadProductGroupTree(aList : TStringList):Boolean; overload;

      // -- This function loads all selected items as line items into a stringlist
 	    function LoadSelectedAsItemList(aListView : TTreeView; aStringList : TStringList):Boolean;
      procedure LoadItemsFromNodeToList(aNode : GTDNode; aStringList : TStringList; aGroupName : String);
      procedure LoadAllItemsToList(aStringList : TStringList);

      procedure StartItemIterator;      // -- An itemlist gets loaded in this one
      procedure ReStartItemIterator;    // -- The itemlist is not reloaded, just the index is reset

      function NextItemIteration(aNode : GTDNode):Boolean;
      procedure EndItemIterator;
      procedure FlagCurrentItem(FlagValue : Integer);   // -- Set the flag of the current item
      function  GetCurrentItemFlag:Integer;             // -- Read the flag of the current item
      function  GetCurrentItemProductGroupName:String;

      procedure SaveItemsToFile(aFilename : String);

      // -- XML Output
      procedure ExportAsXML(aRegistry : GTDDocumentRegistry; aFilename,columnList : String);

      // -- Excel Output
      procedure ExportAsXLS(aRegistry : GTDDocumentRegistry; aFilename, columnList : String); {Sinu}

      // -- PDF Output
      procedure ExportAsStandardPDF(aRegistry : GTDDocumentRegistry; aFilename,columnList : String);
      procedure ExportAsCustomerSpecifiedPDF(aRegistry : GTDDocumentRegistry; Trader_ID : Integer; aFilename : String; Headings : Boolean = True);

      // -- CSV Output
      procedure ExportAsStandardCSV(aFilename,columnList : String; ShowHeadings : Boolean = True);
      procedure ExportAsCustomerSpecifiedCSV(aRegistry : GTDDocumentRegistry; Trader_ID : Integer; aFilename : String; Headings : Boolean = True);

	private
      iteratorLineNumber : Integer;

      function GetColumnCount(AColumns:String):Integer;

	published
  end;

  TXMLOp = class
  private
    FXMLDoc : TXMLDocument;
    FFileName: String;
    procedure SetFileName(const Value: String);

  public
    constructor CreateXMLOp(AOwner: TComponent; AFileName : String);
    destructor Destroy;override;

    function AddRootNode(ACaption : String):IXMLNode;
    function AddChildNode(AParentNode : IXMLNode; ACaption , AText : String):IXMLNode;
    procedure SetTextValue(ANode : IXMLNode; AValue : String);
    procedure SaveFile;

    property FileName : String read FFileName write SetFileName;
  end;

implementation
uses FastStrings;

// ----------------------------------------------------------------------------

//-- Pricelist - This is an abstraction of a pricelist
function GTDPricelist.LoadProductGroupTree(aListView : TTreeView):Boolean;
var
	ProductGroupNode : GTDNode;
	aNode : TTreeNode;
	gn : String;
begin
	// -- Calculate a cursor for the product group
	ProductGroupNode := GTDNode.Create;

	// -- Load out the
	if not ProductGroupNode.LoadFromDocument(Self,GTD_PL_PRODUCTINFO_NODE,True) then
	begin
        ProductGroupNode.Destroy;
		Exit;
	end;

	aListView.Items.Clear;

	while ProductGroupNode.FindTag(GTD_PL_PRODUCTGROUP_TAG) do
	begin

		gn := ProductGroupNode.ReadStringField(GTD_PL_ELE_GROUP_NAME);

		if gn <> '' then
		begin
			aNode := AListView.Items.Add(nil,gn);
			aNode.StateIndex := 3;
		end;

	end;

	ProductGroupNode.Destroy;

end;

function GTDPricelist.LoadProductGroupTree(aList : TStringList):Boolean;
var
	ProductGroupNode : GTDNode;
	gn : String;
begin
	// -- Calculate a cursor for the product group
	ProductGroupNode := GTDNode.Create;

	// -- Load out the
	if not ProductGroupNode.LoadFromDocument(Self,GTD_PL_PRODUCTINFO_NODE,True) then
	begin
        ProductGroupNode.Destroy;
		Exit;
	end;

	aList.Clear;

	while ProductGroupNode.FindTag(GTD_PL_PRODUCTGROUP_TAG) do
	begin

		gn := ProductGroupNode.ReadStringField(GTD_PL_ELE_GROUP_NAME);

		if gn <> '' then
		begin
			AList.Add(gn);
		end;

	end;

	ProductGroupNode.Destroy;

end;

function GTDPricelist.LoadSelectedAsItemList(aListView : TTreeView; aStringList : TStringList):Boolean;
begin
end;

procedure GTDPricelist.LoadItemsFromNodeToList(aNode : GTDNode; aStringList : TStringList; aGroupName : String);
var
    xc,ItemCount : Integer;
    L : String;
    ProductNode : GTDNode;

begin
	// -- Calculate a cursor for the product group
	ProductNode := GTDNode.Create;

    try
        ItemCount := 0;

        // -- Extract each product item from the group
        while ProductNode.ExtractTaggedSection(GTD_PL_PRODUCTITEM_TAG,aNode) do
        begin
            // --
            L := EncodeStringField(GTD_PL_PRODUCTGROUP_TAG,aGroupName) + #13;

            // -- Add all lines into one line
            for xc := 1 to ProductNode.MsgLines.Count do
                L := L + ProductNode.MsgLines[xc-1] + #13;
                
            // -- Now add this line to the items list
            aStringList.Add(L);

            // -- Adjust the number of cells to the height
            Inc(ItemCount);

        end;

    finally
 	    ProductNode.Destroy;
    end;

end;

procedure GTDPricelist.LoadAllItemsToList(aStringList : TStringList);
var
    xc,gc : Integer;
    gn : String;
    ProductGroupNode : GTDNode;
begin

    ProductGroupNode := GTDNode.Create;

    // -- Initialise our string list
    aStringList.Clear;

    // -- This will loop through all level 1 groups
    gc := Self.NodeCount(GTD_PL_PRODUCTINFO_NODE+GTD_PL_PRODUCTGROUP_NODE);

    // -- Not all pricelists have product groups.
    //    First we process ones that do
    if gc > 0 then
    begin
        // -- For every major product group
        for xc := 1 to gc do
        begin
            // -- Calculate the nodepath
            gn := GTD_PL_PRODUCTINFO_NODE+GTD_PL_PRODUCTGROUP_NODE + '[' + IntToStr(xc) + ']';

            // -- Now load in all the items
            if ProductGroupNode.LoadFromDocument(Self,gn,False) then
            begin
                // -- Reset to the start
                ProductGroupNode.GotoStart;

                LoadItemsFromNodeToList(ProductGroupNode,aStringList,ProductGroupNode.ReadStringField(GTD_PL_ELE_GROUP_NAME));
            end;
        end;
    end
    else begin
        // -- No product groups
        gn := GTD_PL_PRODUCTINFO_NODE;

        // -- Now load in all the items
        if ProductGroupNode.LoadFromDocument(Self,gn,False) then
        begin
            // -- Reset to the start
            ProductGroupNode.GotoStart;

            LoadItemsFromNodeToList(ProductGroupNode,aStringList,'');
        end;
    end;
    ProductGroupNode.Destroy;
end;

procedure GTDPricelist.StartItemIterator;
begin
    iteratorLineNumber := 0;

    // -- Create our itemlist if it doesn't exist
    if not Assigned(ItemList) then
    begin
        ItemList := TStringList.Create;
    end
    else
        ItemList.Clear;

    // -- Now load all our items into it
    LoadAllItemsToList(ItemList);

end;

procedure GTDPricelist.ReStartItemIterator;
begin
    // -- Check that we have variables assigned
    if not Assigned(ItemList) then
        StartItemIterator
    else
        iteratorLineNumber := 0;
end;

function GTDPricelist.NextItemIteration(aNode : GTDNode):Boolean;
begin
    if not Assigned(ItemList) then
        Exit;

    Inc(iteratorLineNumber);

    if (iteratorLineNumber <= ItemList.Count) then
    begin
        aNode.UseSingleLine(ItemList.Strings[iteratorLineNumber-1]);
        Result := True;
    end
    else begin
        Result := False;
    end;

end;

procedure GTDPricelist.EndItemIterator;
begin
    if Assigned(ItemList) then
    begin
        ItemList.Destroy;
        ItemList := nil;
    end;
end;

procedure GTDPricelist.FlagCurrentItem(FlagValue : Integer);
begin
    ItemList.Objects[iteratorLineNumber-1] := TObject(FlagValue);
end;

function GTDPricelist.GetCurrentItemFlag:Integer;             // -- Read the flag of the current item
begin
  Result := Integer(ItemList.Objects[iteratorLineNumber-1]);
end;

function GTDPricelist.GetCurrentItemProductGroupName:String;
begin
  // -- busted
  Result := ''; // ProductGroupNode.ReadStringField(GTD_PL_ELE_GROUP_NAME);
end;

procedure GTDPricelist.SaveItemsToFile(aFilename : String);
begin
    StartItemIterator;

    ItemList.SaveToFile(aFilename);
end;

// -- Excel Output
procedure GTDPricelist.ExportAsXLS(aRegistry : GTDDocumentRegistry; aFilename, columnList : String);

    procedure AddPriceChangeSummarySheet;
    var
      y : integer;
      sh : TvteXLSWorksheet;

      procedure af(number : double; const format : string);
      begin
      sh.Ranges[0,y,0,y].Value := number;
      sh.Ranges[1,y,1,y].Value := number;
      sh.Ranges[1,y,1,y].Format := format;
      sh.Ranges[2,y,2,y].Value := format;
      sh.Ranges[2,y,2,y].HorizontalAlignment := vtexlHAlignRight;
      Inc(y);
      end;

    begin
//      sh := wb.AddSheet;
      sh.Title := 'Changes';

      sh.Ranges[0,0,0,0].Value := 'Number';
      sh.Ranges[0,0,0,0].FillPattern := vtefpSolid;
      sh.Ranges[0,0,0,0].BackgroundFillPatternColor := clWhite;
      sh.Ranges[0,0,0,0].ForegroundFillPatternColor := $00FF00;
      sh.Cols[0].Width := 10*256;

      sh.Ranges[1,0,1,0].Value := 'Format';
      sh.Ranges[1,0,1,0].FillPattern := vtefpSolid;
      sh.Ranges[1,0,1,0].BackgroundFillPatternColor := clWhite;
      sh.Ranges[1,0,1,0].ForegroundFillPatternColor := $00FF00;
      sh.Cols[1].Width := 10*256;

      sh.Ranges[2,0,2,0].Value := 'Formatted number';
      sh.Ranges[2,0,2,0].FillPattern := vtefpSolid;
      sh.Ranges[2,0,2,0].BackgroundFillPatternColor := clWhite;
      sh.Ranges[2,0,2,0].ForegroundFillPatternColor := $00FF00;
      sh.Cols[2].Width := 20*256;

      y := 1;
      af(10123.456,'# ##0.00');
      af(10123.456,'#,##0.00 "€"');
      af(10123.456,'#,0.00');
      af(10123.456,'0');
    end;

    procedure WriteHeader(AWorkSheet: TvteXLSWorksheet;AColumns : String);
    var
      iColCount, iCol,cw : Integer;
      sCol,s : String;
    begin
      if Not Assigned(AWorkSheet) then
        Exit;

      iColCount := GetColumnCount(AColumns)-1;
      //AWorkSheet.Title := 'PriceList';

      // -- Company name
      AWorkSheet.Ranges[0,1,iColCount,1].FillPattern                := vtefpSolid;
      AWorkSheet.Ranges[0,1,iColCount,1].ForegroundFillPatternColor := clYellow;
      AWorkSheet.Ranges[0,1,iColCount,1].Value      := aRegistry.GetCompanyName;
      AWorkSheet.Ranges[0,1,iColCount,1].HorizontalAlignment := vtexlHAlignCenter;
      AWorkSheet.Ranges[0,1,iColCount,1].Font.Size  := 16;

      // -- Company address
      AWorkSheet.Ranges[0,2,iColCount,2].FillPattern                := vtefpSolid;
      AWorkSheet.Ranges[0,2,iColCount,2].ForegroundFillPatternColor := clYellow;
      aRegistry.BuildSingleAddressLine(s);
      AWorkSheet.Ranges[0,2,iColCount,2].Value      := s;
      AWorkSheet.Ranges[0,2,iColCount,2].HorizontalAlignment := vtexlHAlignCenter;
      AWorkSheet.Ranges[0,2,iColCount,2].Font.Size  := 10;

      // -- Columnn headers
      iCol := 0;
      Repeat
        sCol := Parse(AColumns,';');

        // -- Standard Column setup stuff here
        AWorkSheet.Cols[iCol].Width                                  := 5000;
        AWorkSheet.Ranges[iCol,4,iCol,4].FillPattern                 := vtefpSolid;
        AWorkSheet.Ranges[iCol,4,iCol,4].ForegroundFillPatternColor  := clBlue;
        AWorkSheet.Ranges[iCol,4,iCol,4].Font.Color                  := clWhite;

        if (sCol[1] <> '<') then
        begin
          // -- Set the column name
          AWorkSheet.Ranges[iCol,4,iCol,4].Value                       := sCol;

          // -- Make the product name wider if it is encountered
          if sCol = GTD_PL_ELE_PRODUCT_PLU then
          begin
            AWorkSheet.Cols[iCol].Width := 15 * 256;
          end
          else if sCol = GTD_PL_ELE_PRODUCT_NAME then
          begin
            AWorkSheet.Cols[iCol].Width := 60 * 256;
          end;

        end
        else begin
          // -- Custom columns. If this is the case, the custom columns
          //    are defined in in the Trader.Settings memo field
          if sCol = '<Custom Column>' then
          begin
            // -- Retrieve the display title
            if aRegistry.GetTraderSettingString('/XLS Pricelist Output/Column ' + IntToStr(iCol+1),'Display_Title',s) then
              AWorkSheet.Ranges[iCol,4,iCol,4].Value := s
            else
            if aRegistry.GetTraderSettingString('/XLS Pricelist Output/Column ' + IntToStr(iCol+1),'Element_Name',s) then
              AWorkSheet.Ranges[iCol,4,iCol,4].Value := s
            else
              AWorkSheet.Ranges[iCol,4,iCol,4].Value := 'Column ' + IntToStr(iCol+1);


            // -- Retrieve the column width
            if aRegistry.GetTraderSettingInt('/XLS Pricelist Output/Column ' + IntToStr(iCol+1),'Width',cw) then
              AWorkSheet.Cols[iCol].Width := cw * 256;

          end;
        end;

        // -- Advance the column count
        Inc(iCol);

      until (AColumns = '');
    end;

var
  iRow,iCol, fc : Integer;
  sColumns,sField,sFieldValue : String;
  fFloatField : Double;
  tmpProduct : GTDNode;
  wb : TvteXLSWorkbook;
  sh : TvteXLSWorksheet;
  Writer : TvteCustomWriter;
begin
  tmpProduct    := GTDNode.Create;
  wb            := TvteXLSWorkbook.Create;

  wb.Clear;

  // -- Create a new worksheet and name it
  sh  := wb.AddSheet;
  sh.Title := 'Prices';

  try
    ReStartItemIterator;

    // -- Write the spreadsheet header, including names and set column widths
    WriteHeader(sh,ColumnList);

    iRow := 5;

    while NextItemIteration(tmpProduct) do
    begin
      // -- Reload the columnlist for every item
      sColumns  := ColumnList;
      iCol      := 0;
      repeat
        // -- Extract the next field name
        sField := Parse(sColumns,';');

        // -- Now extract the value of that field
        if (sField = '<Custom Column>') then
        begin
            // -- Read the value of the custom field name, which
            //    will be one level deeper
            if aRegistry.GetTraderSettingString('/XLS Pricelist Output/Column ' + IntToStr(iCol+1),'Element_Name',sField) then
              ;

        end;

        // -- Now output the field
        if ((length(sField) <> 0) and (sField[1] <> '<')) then
        begin
          if (sField = GTD_PL_ELE_PRODUCT_LIST) or (sField = GTD_PL_ELE_PRODUCT_ACTUAL) then
          begin
              sh.Ranges[iCol,iRow,iCol,iRow].Format := '#,0.00';
              fFloatField := tmpProduct.ReadNumberField(sField,0);
              sh.Ranges[iCol,iRow,iCol,iRow].Value := fFloatField;
          end
          else begin
              // -- All non-price fields get stored as strings
              sFieldValue := tmpProduct.ReadStringField(sField);
              sh.Ranges[iCol,iRow,iCol,iRow].Value := sFieldValue;
          end;

        end
        else if (sField = '<Product Group>') then
        begin
          // -- Extract the product group
          sh.Ranges[iCol,iRow,iCol,iRow].Value := tmpProduct.ReadStringField(GTD_PL_PRODUCTGROUP_TAG);
        end;

        // -- Advance the column number
        Inc(iCol);

      until (sColumns = '');

      Inc(iRow);
    end;

//    AddNumberFormatsSheet;

    // -- Create the writer
    Writer := TvteExcelWriter.Create;
    try
        Writer.Save(wb,aFilename);
    finally
        Writer.Free;
    end;

  finally
    tmpProduct.Destroy;
    FreeAndNil(wb);
  end;
end;

// -- PDF Output
procedure GTDPricelist.ExportAsStandardPDF(aRegistry : GTDDocumentRegistry; aFilename,columnList : String);
begin
end;

procedure GTDPricelist.ExportAsCustomerSpecifiedPDF(aRegistry : GTDDocumentRegistry; Trader_ID : Integer; aFilename : String; Headings : Boolean = True);
begin
end;

procedure GTDPricelist.ExportAsCustomerSpecifiedCSV(aRegistry : GTDDocumentRegistry; Trader_ID : Integer; aFilename : String; Headings : Boolean = True);
begin
end;

// -- Output the pricelist in XML format
procedure GTDPricelist.ExportAsXML(aRegistry : GTDDocumentRegistry; aFilename, columnList : String);

  // -- Function to remove spaces so that they work as xml tags
  function AsXMLTag(const aString : String):String;
  var
    s : String;
  begin
    s := FastReplace(aString,' ','_');
    Result := s;
  end;

var
  fc : Integer;
  sColumns,sField,sFieldValue : String;
  fFloatField : Double;
  tmpProduct : GTDNode;
  XMLOpObj : TXMLOp;
  PriceList , PInfo , PriceGrp , PrdItem , Product: IXMLNode;
begin
  tmpProduct := GTDNode.Create;

  // -- Create the top level nodes
  XMLOpObj  :=  TXMLOp.CreateXMLOp(Self, aFilename);
  PriceList :=  XMLOpObj.AddRootNode(AsXMLTag(GTD_PL_PRICELIST_TAG));
  PInfo     :=  XMLOpObj.AddChildNode(PriceList,asXMLTag(GTD_PL_PRODUCTINFO_TAG),'');
  PriceGrp  :=  XMLOpObj.AddChildNode(PInfo,asXMLTag(GTD_PL_PRODUCTGROUP_TAG),'');

  try
    ReStartItemIterator;

    while NextItemIteration(tmpProduct) do
    begin
      //Reload the columnlist for every item
      sColumns  := ColumnList;
      PrdItem := XMLOpObj.AddChildNode(PriceGrp,asXMLTag(GTD_PL_PRODUCTITEM_TAG),'');
      repeat
        //Extract the next field name
        sField := Parse(sColumns,';');

        //Now extract the value of that field
        if (sField[1] <> '<') then
        begin
          //if amount, readnumberfield is used.
          if (sField = GTD_PL_ELE_PRODUCT_LIST) or (sField = GTD_PL_ELE_PRODUCT_ACTUAL) then
          begin
            fFloatField := tmpProduct.ReadNumberField(sField,0);
            XMLOpObj.AddChildNode(PrdItem,sField,FormatFloat('###########.##',fFloatField));
          end
          else
          begin
            //All non-price fields get stored as strings
            sFieldValue := tmpProduct.ReadStringField(sField);
            XMLOpObj.AddChildNode(PrdItem,sField,sFieldValue);
          end;
        end
      until (sColumns = '');
    end;//while

    XMLOpObj.SaveFile;

  finally
    FreeAndNil(XMLOpObj);
    tmpProduct.Destroy;
  end;
end;

// -- CSV Output
procedure GTDPricelist.ExportAsStandardCSV(aFilename,columnList : String; ShowHeadings : Boolean = True);

    function GetSpecialField(sf :String):String;
    begin
        Result := '';
    end;
var
    i,fc : Integer;
    s,f,v,l : String;
    thisProduct : GTDNode;
    csvFile : TStringList;
begin
    try
        thisproduct := GTDNode.Create;
        csvFile := TStringList.Create;

        i := 0;

        // Progressbar1.step:=round(1/bsSkinListView1.Items.count );
        // comapring data of list view with selected table
        ReStartItemIterator;

    	// barProgress.MaxValue := Pricelist.ItemList.count;

        if ShowHeadings then
        begin
            s := columnList;
            l := '';

            repeat
                // -- Extract the next field name
                f := Parse(s,';');

                // -- Now extract the value of that field
                if (f[1] <> '<') then
                    v := thisProduct.ReadStringField(f)
                else
                    v := GetSpecialField(f);

                // -- Build the line
                l := l + '"' + v + '","';

            until (s = '');
        end;

        while NextItemIteration(thisproduct) do
        begin

            // -- Reload the columnlist for every item
            s := columnList;
            l := '';

            repeat
                // -- Extract the next field name
                f := Parse(s,';');

                // -- Now extract the value of that field
                if (f[1] <> '<') then
                    v := thisProduct.ReadStringField(f)
                else
                    v := GetSpecialField(f);

                // -- Build the line
                l := l + '"' + v + '","';

            until (s = '');

            // -- Chop off the last comma

            // -- Add it to the list
            csvFile.Add(l);

        end;

        csvFile.SaveToFile(aFilename);

    finally
        thisProduct.Destroy;
        csvFile.Destroy;
    end;
end;


function GTDPricelist.GetColumnCount(AColumns:String): Integer;
var
  sCol, sTemp : String;
  iIndex , iCount: Integer;
begin
  iCount := 0;

  Repeat
    sCol := Parse(AColumns,';');

    Inc(iCount);

  until (AColumns = '');

  Result := iCount;
end;

{ TXMLOp }

function TXMLOp.AddChildNode(AParentNode: IXMLNode; ACaption,
  AText: String): IXMLNode;
begin
  Result := Nil;

  if Assigned(AParentNode) then
  if Trim(ACaption) <> '' then
  begin
    Result      := AParentNode.AddChild(ACaption);
    if Trim(AText) <> '' then
      Result.Text := AText;
  end;
end;

function TXMLOp.AddRootNode(ACaption: String): IXMLNode;
begin
  Result := Nil;

  if Assigned(FXMLDoc) then
  if Trim(ACaption) <> '' then
    Result := FXMLDoc.AddChild(ACaption);
end;

constructor TXMLOp.CreateXMLOp(AOwner: TComponent; AFileName : String);
begin
  inherited Create;
  FXMLDoc   := TXMLDocument.Create(AOwner);
  FFileName := AFileName;
  FXMLDoc.Active    := True;
end;

destructor TXMLOp.Destroy;
begin
  FXMLDoc.Active := False;
  
  if Assigned(FXMLDoc) then
    FreeAndNil(FXMLDoc);

  inherited;
end;

procedure TXMLOp.SaveFile;
begin
  FXMLDoc.SaveToFile(FFileName);
end;

procedure TXMLOp.SetFileName(const Value: String);
begin
  FFileName         := Value;
  FXMLDoc.FileName  := FFileName;
end;

procedure TXMLOp.SetTextValue(ANode: IXMLNode; AValue: String);
begin
  if Assigned(ANode) then
    ANode.Text := AValue;
end;

end.
