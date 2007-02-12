unit GTDProductDBSearch;

interface

uses
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, bsSkinCtrls, StdCtrls, Mask, bsSkinBoxCtrls, bsSkinData, Db,
  bsSkinGrids, bsDBGrids, DDB, DTables, DMaster, DBTables, ADODB,GTDBizDocs,
  TeEngine, Series, ExtCtrls, TeeProcs, Chart, Buttons, Windows, Menus,
  bsSkinMenus,GTDProductDetails;

const
    DBTYPE_ADO   = 1;
    DBTYPE_MYSQL = 2;
    DBTYPE_IB    = 3;
type
  TProductdBSearch = class(TFrame)
    DataSource1: TDataSource;
    pnlHolder: TbsSkinGroupBox;
    btnSearch: TbsSkinSpeedButton;
    txtSearchText: TbsSkinEdit;
    grdProducts: TbsSkinDBGrid;
    bsSkinScrollBar1: TbsSkinScrollBar;
    lblItemsCount: TbsSkinStdLabel;
    Label2: TLabel;
    Label3: TLabel;
    Memo1: TbsSkinMemo;
    qryFindProducts: TADOQuery;
    qryCountStuff: TADOQuery;
    qryWordCheck: TADOQuery;
    bsSkinDBGrid1: TbsSkinDBGrid;
    DataSource2: TDataSource;
    bsSkinMemo1: TbsSkinMemo;
    Label4: TLabel;
    Shape1: TShape;
    Chart1: TChart;
    Series1: TPieSeries;
    btnImport: TbsSkinSpeedButton;
    mnuProductOps: TbsSkinPopupMenu;
    AddToPricelist1: TMenuItem;
    btnBack: TbsSkinSpeedButton;
    procedure btnSearchClick(Sender: TObject);
    procedure bsSkinSpeedButton1Click(Sender: TObject);
    procedure txtSearchTextKeyPress(Sender: TObject; var Key: Char);
    procedure Label2Click(Sender: TObject);
    procedure Chart1ClickSeries(Sender: TCustomChart; Series: TChartSeries;
      ValueIndex: Integer; Button: TMouseButton; Shift: TShiftState; X,
      Y: Integer);
    procedure txtSearchTextChange(Sender: TObject);
    procedure grdProductsDblClick(Sender: TObject);
    procedure btnBackClick(Sender: TObject);
  private
    { Private declarations }
    fSkinData: TbsSkinData;
    fADOConnectionString : String;
    fVendorList : TStringList;
    fDocRegistry : GTDDocumentRegistry;
    fProductDetails : TProductDetails;

    fdbType : Integer;   //   DBTYPE_ADO   = 1;     DBTYPE_MYSQL = 2;     DBTYPE_IB    = 3;
    fLikeChar : String;

    procedure SetSkinData(Value: TbsSkinData);
    procedure CountItemsInProductDatabase;

  public
    { Public declarations }
    function Search(const SearchString : String):Boolean;

    procedure Initialise;

    procedure SetConnectionString(ADOConnectionString : String);

  published
  	property SkinData: TbsSkinData read fSkinData write SetSkinData;
    property DocumentRegistry : GTDDocumentRegistry read fDocRegistry write fDocRegistry;
  end;

implementation

{$R *.DFM}
uses DelphiUtils;

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

procedure TProductdBSearch.Initialise;
begin
    // -- Hardcode to use ado right now
    fDbType := DBTYPE_ADO;

    fLikeChar := '%';

    if not Assigned(fVendorList) then
        fVendorList := TStringList.Create;

    if Assigned(fDocRegistry) then
        fDocRegistry.GetVendorShortnameList(fVendorList);

    // -- Position the chart
    Chart1.Top := grdProducts.Top;
    Chart1.Left := grdProducts.Left;
    Chart1.Width := grdProducts.Width;
    Chart1.Height := grdProducts.Height;

    // -- Setup column names
    grdProducts.Columns[0].FieldName := PLU_Col;
    grdProducts.Columns[1].FieldName := PName_Col;
    grdProducts.Columns[2].FieldName := PCostPrice;
    grdProducts.Columns[3].FieldName := PSellPrice;

    if not Assigned(fProductDetails) then
    begin
      fProductDetails := TProductDetails.Create(Self);
      with fProductDetails do
      begin
        Top    := grdProducts.Top;
        Left   := grdProducts.Left;
        Width  := grdProducts.Width;
        Height := grdProducts.Height;
        Parent := Self;
        Visible := False;
      end;
      fProductDetails.SkinData := fSkinData;
    end;

    CountItemsInProductDatabase;

end;

procedure TProductdBSearch.CountItemsInProductDatabase;
var
    ItemsInDB : Integer;
begin
    Chart1.SeriesList[0].Clear;

    with qryCountStuff do
    begin
        Active := False;

        SQL.Clear;
        SQL.Add('SELECT products.SupplierID, Count(*) AS ItemCount, Suppliers.CompanyName');
        SQL.Add('FROM [' + PProdTblName + '] INNER JOIN [Suppliers] ON products.SupplierID = Suppliers.SupplierID');
        SQL.Add('GROUP BY [products.SupplierID], [Suppliers.CompanyName]');

        // -- Open the query and add every field to the database
        ItemsInDB := 0;

        Active := True;
        First;
        while not Eof do
        begin

            // -- Add the supplier to the chart
            Chart1.SeriesList[0].Add(Fields[1].AsFloat, Fields[2].AsString);

            // -- Do a running total
            ItemsInDB := ItemsInDB + Fields[1].AsInteger;

            Next;

        end;

        lblItemsCount.Caption := 'You currently have ' + IntToStr(ItemsInDB) + ' Products in your Product Database';

        Active := False;
    end;

end;

procedure TProductdBSearch.btnSearchClick(Sender: TObject);
var
    SrchTerm : String;
    SrchWords: TStringList;

    procedure ParseSearchText;
    var
        l,w : String;
    begin
        l  := txtSearchText.Text;

        while l <> '' do
        begin
            w := Parse(l,' ');
            SrchWords.Add(w)
        end;
    end;

    function SearchWithWildCards:Boolean;
    begin
        with qryFindProducts do
        begin

            Active := False;

            // -- Build the query
            SQL.Clear;
            SQL.Add('select ' + PLU_Col + ', ' + PProdTblName + '.' + PName_Col + ', ' + PCostPrice + ',' + PSellPrice);
            SQL.Add('from [' + PProdTblName + ']');

            if SrchTerm <> '' then
                SQL.Add('where (' + PProdTblName + '.' + PName_Col + ' LIKE "' + fLikeChar + SrchTerm + fLikeChar + '")');

            Memo1.Lines.Assign(SQL);

            // -- Now run it
            Active := True;

        end;

        Result := qryFindProducts.RecordCount <> 0;

    end;

    procedure DisplayResultsCount;
    begin
        with qryCountStuff do
        begin
            Active := False;
            SQL.Clear;
            SQL.Add('select count(*) from ' + PProdTblName);

            Active := True;

            lblItemsCount.Caption := IntToStr(qryFindProducts.RecordCount) + ' Item(s) from ' + Fields[0].AsString + ' Total Items in your Product Database';

        end;
    end;

begin

    SrchWords := TStringList.Create;

    try

        Search(txtSearchText.Text);

        Chart1.Visible := False;
        bsSkinScrollBar1.Visible := True;

        {
        // -- Split up each of the words and load them in the list
        ParseSearchText;

        SrchTerm := txtSearchText.Text;

        SearchWithWildCards;

        DisplayResultsCount;
        }

    finally
        SrchWords.Destroy
    end;
end;

procedure TProductdBSearch.SetSkinData(Value: TbsSkinData);

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

begin
    SkinaPanel(pnlHolder);
    txtSearchText.SkinData := Value;
    btnSearch.SkinData := Value;
    btnImport.SkinData := Value;
    mnuProductOps.SkinData := Value;
    Memo1.SkinData := Value;
    btnBack.SkinData := Value;

    // -- Save for later
    fSkinData := Value;
end;

procedure TProductdBSearch.bsSkinSpeedButton1Click(Sender: TObject);
begin
    QryFindProducts.Filter := '[ProductName] LIKE "' + fLikeChar + txtSearchText.Text + fLikeChar + '"';
    QryFindProducts.Filtered := not QryFindProducts.Filtered;
end;

procedure TProductdBSearch.txtSearchTextKeyPress(Sender: TObject;
  var Key: Char);
begin
    if Key = #13 then
    begin
        btnSearchClick(Sender);
    end;

end;

procedure TProductdBSearch.Label2Click(Sender: TObject);
begin
  // -- Swap visibility
  Memo1.Visible := not Memo1.Visible;
  bsSkinMemo1.visible   := not bsSkinMemo1.Visible;
  bsSkinDBGrid1.visible := not bsSkinDBGrid1.Visible;
end;

function TProductdbSearch.Search(const SearchString : String):Boolean;
var
    haveVendorName : Boolean;
    SupplierID     : Integer;
    VendorName     : String;
    haveFirstAnd   : Boolean;
const
	StdWordLen = 30;

    // -- Removes the minus "-" padding that we are using
	function unpad(aStr : String):String;
	var
		xc : Integer;
	begin
		for xc := Length(aStr) downto 1 do
		begin
			if aStr[xc] <> '-' then
			begin
				Result := Copy(aStr,1,xc);
				break;
			end;
		end;
	end;

        procedure CheckForVendorName;
        var
            idx : Integer;
        begin

            with qryWordCheck do
            begin

                Filtered := False;

                // -- Check for Brand
                Filtered := False;
                Filter   := '(ELEMENT = ''VENDORID'')';
                Filtered := True;

                First;
                if not Eof then
                begin
                    SupplierID := FieldByName('ITEM_COUNT').AsInteger;
                    haveVendorName := True;
                    VendorName     := FieldByName('WORD').AsString;
                end
                else begin
                    SupplierID := -1;
                    haveVendorName := False;
                end;
            end;
        end;

        procedure AddSQLWhereClause(aClause : String);
        begin
    		with qryFindProducts do
	    	begin
                if (haveFirstAnd) then
			        SQL.Add('AND')
                else begin
                    haveFirstAnd := True;
                end;
                SQL.Add(aClause);
            end;
        end;

	procedure AddBasicSelects(PMFTABLE : String);

		procedure AddTypeFilters;
		var
			bc : Integer;
			s : String;
			haveType,haveBrand : Boolean;
		begin

			// -- Scan through the brands, we may get two word brands
			with qryWordCheck do
			begin

				Filtered := False;

				// -- Check for Brand
				Filtered := False;
				Filter   := '(ITEM_COUNT > 0)';
				Filtered := True;

				haveType := False;
				haveBrand:= False;

				First;
				while not Eof do
				begin
					if FieldByName('ELEMENT').AsString = 'TYPE' then
						haveType := True
					else if FieldByName('ELEMENT').AsString = 'BRAND' then
						haveBrand := True;

					Next;
				end;

				// -- What happens here is that if we have a brand and
				//    a type then don't filter on type, so exit
				if (haveType and haveBrand) then
					Exit;

        {
				Filtered := False;
				Filter   := '(ELEMENT = ''PMFTYPE'') AND (ITEM_COUNT > 0)';
				Filtered := True;
				//

				if (RecordCount = 1) then
				begin
					First;
					qryFindProducts.SQL.Add('	AND (PMFTYPE.PGRP IN (SELECT PMFTYPE.PGRP FROM PMFTYPE');
					qryFindProducts.SQL.Add('WHERE (TNAME LIKE "%' + unpad(FieldByName('WORD').AsString) + '%")))');
				end
				else if (RecordCount > 1) then
				begin
					bc := 0;
					First;
					while Not Eof do
					begin
						if bc = 0 then
						begin
							qryFindProducts.SQL.Add('	AND (PMFTYPE.PGRP IN (SELECT PMFTYPE.PGRP FROM PMFTYPE WHERE');
							qryFindProducts.SQL.Add('        (TNAME LIKE "%' + unpad(FieldByName('WORD').AsString) + '%")');
						end
						else
							qryFindProducts.SQL.Add('	AND (TNAME LIKE "%' + unpad(FieldByName('WORD').AsString) + '%")');

						Inc(bc);

						Next;
					end;
					// -- Add the closing bracket
					qryFindProducts.SQL.Add('))');

				end;
        }
			end;
		end;

		procedure AddBrandFilters;
		var
			bc : Integer;
		begin
			// -- Scan through the brands, we may get two word brands
			with qryWordCheck do
			begin
				Filtered := False;
				Filter   := '(ELEMENT = ''BRAND--'') AND (ITEM_COUNT > 0)';

				// -- Correct the length of our parameter
				Filtered := True;

				if (RecordCount = 1) then
				begin
					First;
					qryFindProducts.SQL.Add('	AND (TRIM(BRAND) LIKE "' + fLikeChar + unpad(FieldByName('WORD').AsString) + fLikeChar + '")');
				end
				else if (RecordCount > 1) then
				begin
					bc := 0;
					First;
					while Not Eof do
					begin
						if bc = 0 then
						begin
							qryFindProducts.SQL.Add('	AND (');
							qryFindProducts.SQL.Add('        (TRIM(BRAND) LIKE "' + fLikeChar + unpad(FieldByName('WORD').AsString) + fLikeChar + '")');
						end
						else
							qryFindProducts.SQL.Add('	OR (TRIM(BRAND) LIKE "' + fLikeChar + unpad(FieldByName('WORD').AsString) + fLikeChar + '")');

						Inc(bc);

						Next;
					end;
					// -- Add the closing bracket
					qryFindProducts.SQL.Add(')');

				end;

			end;
		end;

		procedure AddCodeFilters;
		var
			bc : Integer;
            w : String;
		begin
			// -- Scan through the brands, we may get two word brands
			with qryWordCheck do
			begin

				{ ALTCODE CATALNO PMF2CODE }
                Filtered := False;
                Filter   := '(ELEMENT = ''PLU'') AND (ITEM_COUNT > 0)';
                Filtered := True;

                if (RecordCount = 1) then
                begin
                    w := unpad(FieldByName('WORD').AsString);

                    First;
                    AddSQLWhereClause(' (' + PProdTblName + '.' + PLU_Col + '= "' + w + '")');
                end;

				// -- CATALNO
                {
				if PMFTABLE = 'PMFALL' then
				begin
					Filtered := False;
					Filter   := '(ELEMENT = ''CATALNO'') AND (ITEM_COUNT > 0)';
					Filtered := True;

					if (RecordCount = 1) then
					begin
						First;
						qryFindProducts.SQL.Add('	AND (' + PMFTABLE + '.CATALNO LIKE "' + unpad(FieldByName('WORD').AsString + '%")'));
					end
				end;

				else if (RecordCount > 1) then
				begin
					bc := 0;
					First;
					while Not Eof do
					begin
						if bc = 0 then
						begin
							qryFindProducts.SQL.Add('	AND (PMFTYPE.PGRP IN (SELECT PMFTYPE.PGRP FROM PMFTYPE WHERE');
							qryFindProducts.SQL.Add('        (TNAME LIKE "%' + Trim(FieldByName('WORD').AsString) + '%")');
						end
						else
							qryFindProducts.SQL.Add('	AND (TNAME LIKE "%' + Trim(FieldByName('WORD').AsString) + '%")');

						Inc(bc);

						Next;
					end;
					// -- Add the closing bracket
					qryFindProducts.SQL.Add('))');

				end;
				}
			end;
		end;

		procedure AddProdDescFilters;
		var
			xc : Integer;
			L, Word : String;
			wasFound : Boolean;
		PaddedWord : String;
		begin
			// -- Here we go through all the words and
			//    anything that was not found anywhere
			//    is thrown into a description filter
			L := SearchString;

			while L <> '' do
			begin
				Word := Parse(L,' ');
				// -- Correct the length of our parameter
				PaddedWord := pad(Word,StdWordLen,'-');
				if Word <> '' then
				begin
					// -- The idea is to find words with ITEM_COUNT all
					//    set to zero. These words are then thrown into
					//    the description wildcard search
					with qryWordCheck do
					begin
						Filtered := False;
						Filter   := '(WORD = ''' + PaddedWord + ''')';
						Filtered := True;

						wasFound := False;
						First;
						while Not Eof do
						begin
							if FieldByName('ITEM_COUNT').AsInteger > 0 then
							begin
								wasFound := True;
								break;
							end;
							Next;
						end;
					end;

					// -- Can we add the word
					if not WasFound then
					begin
                        AddSQLWhereClause(' (' + PProdTblName + '.' + PName_Col + ' LIKE "' + fLikeChar + Word + fLikeChar + '")');
					end;

				end;
			end;

		end;

	begin
		with qryFindProducts do
		begin

			SQL.Add('SELECT');
			SQL.Add('	*');

			SQL.Add('FROM ' + PProdTblName { + ', ' + PSupplierTblName} );
            SQL.Add('RIGHT JOIN Suppliers ON ' + PSupplierTblName + '.SupplierID = Products.SupplierID');
//			SQL.Add('	WHERE (' + PProdTblName + '.SupplierID = ' + PSupplierTblName + '.SupplierID)');
			SQL.Add('	WHERE ');

            // -- Check to see if a vendor name was supplied
            CheckForVendorName;
            if haveVendorName then
            begin

                // -- Lookup this supplier
                fDocRegistry.OpenForTraderNumber(SupplierID);

    			AddSQLWhereClause('	([Products.SupplierID] = ' + IntToStr(SupplierID) + ')');

            end;

            // -- Check for the product code
			AddCodeFilters;

			// -- Add any brands
//			AddBrandFilters;

			// -- Add all other words
			AddProdDescFilters;

		end;
	end;

	procedure AddExtraClauses(PMFTABLE : String);
	begin
		with qryFindProducts do
		begin
			SQL.Add('AND');
		end;
	end;

	// -- Build Brand wordcount
	procedure AddClauseForBrand(Word : String);
	var
		PaddedWord : String;
	begin
		// -- Correct the length of our parameter
		PaddedWord := pad(Word,StdWordLen,'-');

		with qryWordCheck.SQL do
		begin
			if Count <> 0 then
				Add('UNION ALL');

			Add('SELECT');
			Add('	DISTINCT COUNT(' + PBrandBrandName + ') AS ITEM_COUNT,');
			Add('   ''' + PaddedWord + ''' AS WORD,');
			Add('   ''BRAND--'' AS ELEMENT');
			Add('FROM');
			Add('	' + PBrandTblName);
			Add('WHERE');
			Add('	(' + PBrandBrandName + ' LIKE ''' + fLikeChar + Word + fLikeChar + ''')');
		end;
	end;

	procedure AddClauseForPMFType(Word : String);
	var
		PaddedWord : String;
	begin
		// -- Correct the length of our parameter
//		PaddedWord := pad(Word,StdWordLen,'-');

		with qryWordCheck.SQL do
		begin
			if Count <> 0 then
				Add('UNION ALL');

			Add('SELECT');
			Add('   "' + PaddedWord + '" WORD,');
			Add('	"PMFTYPE" AS ELEMENT,');
			Add('        COUNT(DISTINCT PMFTYPE.TNAME) ITEM_COUNT');
			Add('FROM');
			Add('	PMFTYPE');
			Add('WHERE');
			Add('         (PMFTYPE.TNAME LIKE "' + fLikeChar + Word + fLikeChar + '")');
		end;
	end;

	procedure AddClauseForVendorName(Word : String);
	var
		PaddedWord : String;
	begin
		// -- Correct the length of our parameter
		PaddedWord := pad(Word,StdWordLen,'-');

        // -- There is a nasty bug, if this is set on then this
        //    particular query won't run properly
        qryWordCheck.ParamCheck := False;

		with qryWordCheck.SQL do
		begin
			// -- PMF
			if Count <> 0 then
				Add('UNION ALL');

			Add('SELECT');
			Add('   COUNT(*) AS ITEM_COUNT,');
			Add('   ''' + PaddedWord + ''' AS WORD,');
			Add('   ''VENDOR'' AS ELEMENT');
			Add('FROM');
			Add(PSupplierTblName);
			Add('WHERE');
			Add('(' + PSupplierTblName + '.' + PSupplierNameCol + ' LIKE ''' + Word + fLikeChar + ''')');

			Add('UNION ALL');

			Add('SELECT');
			Add('   ' + PSupplierIDCol + ' AS ITEM_COUNT,');
			Add('   ''' + PaddedWord + ''' AS WORD,');
			Add('   ''VENDORID'' AS ELEMENT');
			Add('FROM');
			Add(PSupplierTblName);
			Add('WHERE');
			Add('(' + PSupplierTblName + '.' + PSupplierNameCol + ' LIKE ''' + Word + fLikeChar + ''')');
		end;
	end;

	procedure AddClauseForProductCode(Word : String);
	var
		PaddedWord : String;
	begin
		// -- Correct the length of our parameter
		PaddedWord := pad(Word,StdWordLen,'-');

		with qryWordCheck.SQL do
		begin
			if Count <> 0 then
				Add('UNION ALL');

			Add('SELECT');
            case fDbType of
                // -- ADO2003 doesn't like DISTINCT
                DBTYPE_ADO: Add('   COUNT(*) AS ITEM_COUNT,');
            else
                // -- Anything else except ADO
        		Add('   COUNT(DISTINCT ' + PProdTblName + '.' + PLU_Col + ') AS ITEM_COUNT,');
            end;
			Add('   "' + PaddedWord + '" AS WORD,');
			Add('	"PLU" AS ELEMENT');
			Add('FROM');
			Add('	' + PProdTblName);
			Add('WHERE');
			Add('         (' + PProdTblName + '.' + PLU_Col + '= "' + Word + '")');
		end;
	end;

	procedure AddWordToQuerySet(Word : String);
	begin
		// -- Check the type; it will hint at where to look
//        CheckForVendorName(Word);

		if IsNumber(Word) then
		begin
			// -- The word is numeric, can only be a code
			AddClauseForProductCode(Word);
		end
		else begin
			// -- The word is not numeric, might be a type or brand
            AddClauseForVendorName(Word);
//			AddClauseForBrand(Word);
//			AddClauseForPMFType(Word);
		end;


		// -- The word could be either
//		AddClauseForAltCode(Word);
//		AddClauseForCatalNo(Word);

	end;

var
	xc, xd : Integer;
	Word,L : String;

begin
	// -- List of keywords
	L := SearchString;
	if L = '' then
		Exit;

    // -- Initialise the word check query
    with qryWordCheck do
    begin
        Active := False;
	    SQL.Clear;
    end;

    // -- For every word in the string, do a word lookup
	while L <> '' do
	begin
		Word := Parse(L,' ');
		if Word <> '' then
			AddWordToQuerySet(Word);
	end;

    Memo1.Lines.Assign(qryWordCheck.SQL);

    // -- The first query justs looks up everything to obtain a wordcount
	with qryWordCheck do
	begin
		Active := False;
		Screen.Cursor := crHourglass;
		try
			Active := True;
		except
		 on EDBEngineError do begin
			MessageDlg(StringListToString(SQL),mtError,[mbOk],0);
		 end;
		end;
		Screen.Cursor := crDefault;
	end;

	// -- Now prepare for the product selection query
	// -- Debugging
    haveFirstAnd := False;
	qryFindProducts.Active := False;
	qryFindProducts.SQL.Clear;

	AddBasicSelects(PProdTblName);

	bsSkinMemo1.Lines.Assign(qryFindProducts.SQL);
	qryWordCheck.Filtered := False;

	with qryFindProducts do
	begin
		Active := False;
		try

			Screen.Cursor := crHourglass;

            // -- Now run the final search
			Active := True;

			// -- Display the number of items on the screen
			if RecordCount = 1 then
				lblItemsCount.Caption := '1 Item.'
			else
				lblItemsCount.Caption := IntToStr(RecordCount) + ' Items found.';

            // -- If there are any records the function returns true
            if (RecordCount > 0) then
                Result := True;

		except
		 on EDBEngineError do
     begin
     	 Screen.Cursor := crDefault;
         MessageDlg(StringListToString(SQL),mtError,[mbOk],0);
     end;
		end;
	end;

	Screen.Cursor := crDefault;

end;
// -- Setup all the connectionstrings for the frame
procedure TProductdBSearch.SetConnectionString(ADOConnectionString : String);
begin
    fADOConnectionString := ADOConnectionString;

    qryCountStuff.ConnectionString := fADOConnectionString;
    qryWordCheck.ConnectionString := fADOConnectionString;
    qryFindProducts.ConnectionString := fADOConnectionString;

end;

procedure TProductdBSearch.Chart1ClickSeries(Sender: TCustomChart;
  Series: TChartSeries; ValueIndex: Integer; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
    s : String;
begin
    // -- Extract the name of the supplier
    s := Chart1.Series[0].XLabel[ValueIndex];

    // -- Now copy in the name of the supplier
    txtSearchText.Text := s + ' ';
    txtSearchText.SetFocus;

    // -- Move the cursor to the end of the field
    PostMessage(txtSearchText.Handle,WM_KEYDOWN,VK_END,VK_END);
end;

procedure TProductdBSearch.txtSearchTextChange(Sender: TObject);
begin
    // -- If the user clears the search field, redisplay the graph
    if txtSearchText.Text = '' then
    begin
        CountItemsInProductDatabase;

        Chart1.Visible := True;
        bsSkinScrollBar1.Visible := False;
    end;

end;

procedure TProductdBSearch.grdProductsDblClick(Sender: TObject);
begin
  // -- Make the product display panel visible
  fProductDetails.Visible := True;
  btnBack.Visible := True;
  lblItemsCount.Visible := False;
  bsSkinScrollBar1.Visible := False;
  btnImport.Visible := False;

  // -- Now load the correct item
  fProductDetails.DisplayItem(TQuery(qryFindProducts));
end;

procedure TProductdBSearch.btnBackClick(Sender: TObject);
begin
  // -- Hide the product display panel visible after use
  fProductDetails.Visible := False;
  btnBack.Visible := False;
  lblItemsCount.Visible := True;
  bsSkinScrollBar1.Visible := True;
  btnImport.Visible := True;
end;

end.
