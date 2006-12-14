unit GTDPricelists;

interface

uses
  {$IFDEF LINUX}
	SysUtils, Types, Classes, Variants, QTypes, QGraphics, QControls, QForms,
	QDialogs, QStdCtrls, DateUtils,QExtCtrls,
  {$ELSE}
	Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
	StdCtrls, ToolWin, ComCtrls, FileCtrl, Db, DbTables, BDE, ShlObj,
	ShellAPI,ComObj,
	{$IFNDEF HW_SIMPLE} jpeg ,GTDColorButtonList, {$ENDIF}
	extctrls, HCMngr, DiffUnit,
  {$ENDIF}
  GTDBizDocs;

const
    // -- These constants function as bit flags
    PL_ITEM_STEADY = 0;
    PL_ITEM_NEW = 1;
    PL_ITEM_REMOVED = 2;
    PL_ITEM_RISEN = 4;
    PL_ITEM_FALLEN = 8;
    PL_ITEM_DETAILS = 16;

    //    <Pricelist Delivery>
    //  Requires_Own_Pricelist?=True
    PL_DELIV_FORMAT = 'Delivery_Format';    //  Delivery_Format&="CSV"
      PL_DELIV_CSV    = 'CSV';
      PL_DELIV_XML    = 'XML';
      PL_DELIV_HTML   = 'HTML';
      PL_DELIV_XLS    = 'XLS';
      
    PL_DELIV_REQUIRED = 'Delivery_Required';//  Delivery_Required&="When Changed"
    //  Delivery_Method&="ftp"
    //  Last_Sent@=
    // </Pricelist Delivery>

    PL_OUTPUT_STD_COLUMNS = GTD_PL_ELE_PRODUCT_PLU + ';' +
                            GTD_PL_ELE_PRODUCT_NAME+ ';' +
                            GTD_PL_ELE_PRODUCT_LIST+ ';' +
                            GTD_PL_ELE_PRODUCT_ACTUAL;


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
      procedure ExportAsStandardXLS(aFilename,columnList : String);
      procedure ExportAsCustomerSpecifiedXLS(aRegistry : GTDDocumentRegistry; Trader_ID : Integer; aFilename : String; Headings : Boolean = True);

      // -- PDF Output
      procedure ExportAsStandardPDF(aFilename,columnList : String);
      procedure ExportAsCustomerSpecifiedPDF(aRegistry : GTDDocumentRegistry; Trader_ID : Integer; aFilename : String; Headings : Boolean = True);

      // -- CSV Output
      procedure ExportAsStandardCSV(aFilename,columnList : String; ShowHeadings : Boolean = True);
      procedure ExportAsCustomerSpecifiedCSV(aRegistry : GTDDocumentRegistry; Trader_ID : Integer; aFilename : String; Headings : Boolean = True);

	private
      iteratorLineNumber : Integer;
	published
  end;

implementation
uses FastStrings,MSXML_TLB;
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
    ProductInfoNode : GTDNode;
begin

    ProductInfoNode := GTDNode.Create;

    // -- Initialise our string list
    aStringList.Clear;

    // -- For every major product group
    gn := GTD_PL_PRODUCTINFO_NODE;

        // -- Now load in all the items
    if ProductInfoNode.LoadFromDocument(Self,gn,False) then
    begin
        // -- Reset to the start
        ProductInfoNode.GotoStart;

        LoadItemsFromNodeToList(ProductInfoNode,aStringList,'');
    end;

    ProductInfoNode.Destroy;
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
begin
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

    function GetSpecialField(sf :String):String;
    begin
        Result := '';
    end;
var
    i,fc : Integer;
    s,f,v,l : String;
    thisProduct : GTDNode;
    xml : String;
    doc : IXMLDOMDocument;
    root, child, child1 : IXMLDomElement;
    text1, text2        : IXMLDOMText;

begin
    try
        thisproduct := GTDNode.Create;

        i := 0;

        // Progressbar1.step:=round(1/bsSkinListView1.Items.count );
        // comapring data of list view with selected table
        ReStartItemIterator;

    	// barProgress.MaxValue := Pricelist.ItemList.count;

        // -- Set the root name of the xml file
        xml  := 'Pricelist';
        doc  := CreateOleObject('Microsoft.XMLDOM') as IXMLDomDocument;

        root := doc.createElement(xml);
        doc.appendchild(root);

        while NextItemIteration(thisproduct) do
        begin

            // -- Reload the columnlist for every item
            s := columnList;
            l := '';

            // -- Add the first level children records
            child:= doc.createElement('Product_Items');
            root.appendchild(child);

            repeat
                // -- Extract the next field name
                f := Parse(s,';');

                // -- Now extract the value of that field
                if (f[1] <> '<') then
                    v := thisProduct.ReadStringField(f)
                else
                    v := GetSpecialField(f);

                child1 := doc.createElement(f);
                child.appendchild(child1);
                //Check field types
                child1.appendChild(doc.createTextNode(v));

            until (s = '');

        end;

        doc.save(xml+'.xml');

    finally
        thisProduct.Destroy;
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
    doc                 : IXMLDOMDocument;
    root, child, child1 : IXMLDomElement;
    text1, text2        : IXMLDOMText;

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
                l := l + '"' + v + '",';

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

                // -- Double-quote all quotes
                v := FastReplace(v,'"','""');

                // -- Build the line
                l := l + '"' + v + '",';

            until (s = '');

            // -- Chop off the last comma
            if Length(l) <> 0 then
                l := Copy(l,1,Length(l)-1);

            // -- Add it to the list
            csvFile.Add(l);

        end;

        csvFile.SaveToFile(aFilename);

    finally
        thisProduct.Destroy;
        csvFile.Destroy;
    end;
end;


end.
