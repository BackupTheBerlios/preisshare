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
  BIFF8_Types, vteExcel, vteExcelTypes, vteWriters
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

      procedure SaveItemsToFile(aFilename : String);

      procedure ExportAsXML(aFilename,columnList : String);

      // -- Excel Output
      procedure ExportAsStandardXLS(aFilename, columnList : String); {Sinu}
      procedure ExportAsCustomerSpecifiedXLS(aRegistry : GTDDocumentRegistry; Trader_ID : Integer; aFilename : String; Headings : Boolean = True);

      // -- PDF Output
      procedure ExportAsStandardPDF(aFilename,columnList : String);
      procedure ExportAsCustomerSpecifiedPDF(aRegistry : GTDDocumentRegistry; Trader_ID : Integer; aFilename : String; Headings : Boolean = True);

      // -- CSV Output
      procedure ExportAsStandardCSV(aFilename,columnList : String; ShowHeadings : Boolean = True);
      procedure ExportAsCustomerSpecifiedCSV(aRegistry : GTDDocumentRegistry; Trader_ID : Integer; aFilename : String; Headings : Boolean = True);

	private
      iteratorLineNumber : Integer;

      {Sinu}
      procedure WriteHeader(AWorkSheet: TvteXLSWorksheet;AColumns : String);
      function GetColumnCount(AColumns:String):Integer;
      {Sinu}
	published
  end;

implementation

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
//     gc := Self.NodeCount(GTD_PL_PRODUCTINFO_NODE+'/Product Item');  //sinu

//    gc := 1;
    showmessage(inttostr(gc));
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
//      EndItemIterator;
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

procedure GTDPricelist.SaveItemsToFile(aFilename : String);
begin
    StartItemIterator;

    ItemList.SaveToFile(aFilename);
end;

// -- Excel Output
procedure GTDPricelist.ExportAsStandardXLS(aFilename,columnList : String);
var
  iRow,iCol, fc : Integer;
  sColumns,sField,sFieldValue : String;
  tmpProduct : GTDNode;
  sXLSFile  : TStringList;
  tmpWorkBook : TvteXLSWorkbook;
  tmpWorkSheet : TvteXLSWorksheet;
begin
  tmpProduct    := GTDNode.Create;
  sXLSFile      := TStringList.Create;
  tmpWorkBook   := TvteXLSWorkbook.Create;
  tmpWorkSheet  := tmpWorkBook.AddSheet;
  try
    ReStartItemIterator;
    WriteHeader(tmpWorkSheet,ColumnList);
    iRow        := 5;

    while NextItemIteration(tmpProduct) do
    begin
      // -- Reload the columnlist for every item
      sColumns  := ColumnList;
      iCol      := 0;
      repeat
        // -- Extract the next field name
        sField := Parse(sColumns,';');

        // -- Now extract the value of that field
        if (sField[1] <> '<') then
        begin
          sFieldValue := tmpProduct.ReadStringField(sField);
          tmpWorkSheet.Ranges[iCol,iRow,iCol,iRow].Value := sFieldValue;
          Inc(iCol);
        end;
      until (sColumns = '');

      Inc(iRow);
    end;
    tmpWorkBook.SaveAsXLSToFile(aFilename);
  finally
    tmpProduct.Destroy;
    FreeAndNil(tmpWorkBook);
  end;
end;

procedure GTDPricelist.ExportAsCustomerSpecifiedXLS(aRegistry : GTDDocumentRegistry; Trader_ID : Integer; aFilename : String; Headings : Boolean = True);
begin
end;

// -- PDF Output
procedure GTDPricelist.ExportAsStandardPDF(aFilename,columnList : String);
begin
end;

procedure GTDPricelist.ExportAsCustomerSpecifiedPDF(aRegistry : GTDDocumentRegistry; Trader_ID : Integer; aFilename : String; Headings : Boolean = True);
begin
end;

procedure GTDPricelist.ExportAsCustomerSpecifiedCSV(aRegistry : GTDDocumentRegistry; Trader_ID : Integer; aFilename : String; Headings : Boolean = True);
begin
end;

// -- Output the pricelist in XML format
procedure GTDPricelist.ExportAsXML(aFilename,columnList : String);
begin
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

procedure GTDPricelist.WriteHeader(AWorkSheet: TvteXLSWorksheet;AColumns : String);
var
  iColCount, iCol : Integer;
  sCol : String;
begin
  if Not Assigned(AWorkSheet) then
    Exit;

  iColCount := GetColumnCount(AColumns)-1;
  //AWorkSheet.Title := 'PriceList';

  {Company name}
  AWorkSheet.Ranges[0,1,iColCount,1].FillPattern                := vtefpSolid;
  AWorkSheet.Ranges[0,1,iColCount,1].ForegroundFillPatternColor := clYellow;
  AWorkSheet.Ranges[0,1,iColCount,1].Value      := 'My Sample Company';
  AWorkSheet.Ranges[0,1,iColCount,1].HorizontalAlignment := vtexlHAlignCenter;
  AWorkSheet.Ranges[0,1,iColCount,1].Font.Size  := 16;

  {Company address}
  AWorkSheet.Ranges[0,2,iColCount,2].FillPattern                := vtefpSolid;
  AWorkSheet.Ranges[0,2,iColCount,2].ForegroundFillPatternColor := clYellow;
  AWorkSheet.Ranges[0,2,iColCount,2].Value      := '3,Frog Rock Road, Sydney';
  AWorkSheet.Ranges[0,2,iColCount,2].HorizontalAlignment := vtexlHAlignCenter;
  AWorkSheet.Ranges[0,2,iColCount,2].Font.Size  := 10;

  {columnn headers}
  iCol := 0;
  Repeat
    sCol := Parse(AColumns,';');

    if (sCol[1] <> '<') then
    begin
      AWorkSheet.Ranges[iCol,4,iCol,4].Value                       := sCol;
      AWorkSheet.Cols[iCol].Width                                  := 5000; 
      AWorkSheet.Ranges[iCol,4,iCol,4].FillPattern                 := vtefpSolid;
      AWorkSheet.Ranges[iCol,4,iCol,4].ForegroundFillPatternColor  := clBlue;

      Inc(iCol);
    end;

  until (AColumns = '');
end;

function GTDPricelist.GetColumnCount(AColumns:String): Integer;
var
  sCol, sTemp : String;
  iIndex , iCount: Integer;
begin
  iCount := 0;

  Repeat
    sCol := Parse(AColumns,';');

    if (sCol[1] <> '<') then
      Inc(iCount);

  until (AColumns = '');

  Result := iCount;
end;

end.
