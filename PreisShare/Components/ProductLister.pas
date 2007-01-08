unit ProductLister;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, extctrls,
  bsSkinCtrls, bsSkinGrids, GTDBizDocs, GTDBizLinks;

type

    TProductGridOption = (pgoEditing, pgoShowHeader, pgoShowListPrice);
    TProductGridOptions = set of TProductGridOption;

    // -- Field Abreviation list
    // C = Code,
    // N = Name,
    // P = Pict,
    // D = Desc,
    // L = List,
    // S = Sell,
    // I = Info,
    // A = Avail,
    // V = Vari,
    // O = Opt);

    TProductFields = (CellHasCode,
                      CellHasName,
                      CellHasPict,
					  CellHasDesc,
                      CellHasList,
                      CellHasSell,
                      CellHasInfo,
                      CellHasAvail,
                      CellHasVari,
                      CellHasOpt);
    TProductCellFields = set of TProductFields;

  // -- Describes each of the fields in a product
  TCellField = record
    Available   : Boolean;
    x,y,w,h     : Integer;
    TextColor   : TColor;

    Picture     : TImage;
    Text        : String;

    {
    procedure MyMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure MyResize(Sender: TObject);
    procedure MyMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    }
  end;

  TProductDisplayStyles = (ProductBasicStyle, ProductLeftPictStyle, ProductRightPictStyle, ProductAltPictStyle);

  TProductCellPictureAlign = (palAbsoluteLeft, palAbsoluteRight, palUnderName);

  TProductNameSelected = procedure(Sender: TObject; ItemNumber : Integer; ProductText : String) of object;

  TProductCellData = class(TObject)
  private
  public

    // -- A Listing of all the fields that we have
    C,              // Code,
    N,              // Name,
    P,              // Pict,
    D,              // Desc,
    L,              // List,
    S,              // Sell,
    I,              // Info,
    A,              // Avail,
    V,              // Vari,
    O               // Opt);
                    : TCellField;

    AvailableFields : TProductCellFields;

    DetailsLoaded   : Boolean;

    NameX, NameY,
	NameH, NameL    : Integer;
	NameSelected    : Boolean;

	onSpecialFlag,

	DisplayAsFound  : Boolean;

  end;

  TProductLister = class(TbsSkinDrawGrid)
  private
	fSellPriceLabel,
	fListPriceLabel     : String;
	fFoundColor         : TColor;
	fGridOptions        : TProductGridOptions;

	fOnItemNameSelected : TProductNameSelected;
	fRegistry           : GTDDocumentRegistry;
	fSupplierLink 		: gtTradingLink;
	fDisplayStyle       : TProductDisplayStyles;

	// -- Defaults for positioning
	pHeight,
	pTop,
	pNameTop,
	pNameLeft,
	pDescTop,
	pDescLeft,
	pPictTop,
	pPictLeft,
	pPictHeight,
	pListRight,
	pListTop,
	pSellRight,
	pSellTop            : Integer;

	pOnSpecialLabel     : String;

	fHidePictures       : Boolean;
	fPictureWidth,
	fPictureHeight      : Integer;

	maxNameLength,
	maxDescLength       : Integer;

	{ Private declarations }
	procedure myDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure MyMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
	procedure MyResize(Sender: TObject);
	procedure MyMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
	procedure HandleImageReceived(Sender: TObject; GTL : String; ShortFileName : String; DataInBase64 : GTDBizDoc);

  protected
    { Protected declarations }
    procedure LoadFromSourceData(ItemIndex : Integer);
    procedure DestroyItemData;
    procedure SetDisplayStyle(NewStyle : TProductDisplayStyles);
	procedure SetPictureHeight(NewHeight : Integer);
    procedure SetPictureWidth(NewWidth : Integer);
    procedure SetPicturesHidden(ShowThem : Boolean);
    procedure ForceItemReload;
    procedure CalcLabelPositions;
    procedure SetSellPriceLabel(NewLabel : String);
    procedure SetListPriceLabel(NewLabel : String);

  public

    Items           : TStringList;
    fProductNode    : GTDNode;

	constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;

    // -- Here we are asked to load in information to display an item
    procedure Clear;
	procedure LoadProductGroup(aNode : GTDNode);
    procedure SelectItemCode(ItemCode : String);

    {
    function CellRect(ACol, ARow: Longint): TRect;
    procedure MouseToCell(X, Y: Integer; var ACol, ARow: Longint);
    }
    property Canvas;
    property Col;
    property ColWidths;
	property EditorMode;
    property GridHeight;
    property GridWidth;
    property LeftCol;
    property Selection;
    property Row;
    property RowHeights;
    property TabStops;
    property TopRow;

  published
    property Align;
    property Anchors;
    property BiDiMode;
    property BorderStyle;
    property Color;
	property ColCount;
    property Constraints;
	property Ctl3D;
    property DefaultColWidth;
    property DefaultRowHeight;
    property DefaultDrawing;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property FixedColor;
    property FixedCols;
	property RowCount;
//    property FixedRows;
    property Font;
    property GridLineWidth;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
//    property ScrollBars;
    property ShowHint;

    property SellPriceLabel : String read fSellPriceLabel write SetSellPriceLabel;
    property ListPriceLabel : String read fListPriceLabel write SetListPriceLabel;

    property Registry : GTDDocumentRegistry read fRegistry write fRegistry;

	property SupplierLink : gtTradingLink read fSupplierLink write fSupplierLink;

	property DisplayOptions : TProductGridOptions read fGridOptions write fGridOptions;
    property DisplayStyle : TProductDisplayStyles read fDisplayStyle write SetDisplayStyle;

    property FoundColor     : TColor read fFoundColor write fFoundColor default $00FFFFA8;
    property HidePictures   : Boolean read fHidePictures write SetPicturesHidden;
    property PictureHeight  : Integer read fPictureHeight write SetPictureHeight default 100;
    property PictureWidth   : Integer read fPictureWidth write SetPictureWidth default 100;

	property TabOrder;
    property TabStop;
    property Visible;
    property VisibleColCount;
    property VisibleRowCount;
    property OnClick;
//    property OnColumnMoved: TMovedEvent read FOnColumnMoved write FOnColumnMoved;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnDrawCell;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
//    property OnGetEditMask: TGetEditEvent read FOnGetEditMask write FOnGetEditMask;
//    property OnGetEditText: TGetEditEvent read FOnGetEditText write FOnGetEditText;
    property OnItemNameSelected : TProductNameSelected read fOnItemNameSelected write fOnItemNameSelected;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
//    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
//    property OnRowMoved: TMovedEvent read FOnRowMoved write FOnRowMoved;
//    property OnSelectCell: TSelectCellEvent read FOnSelectCell write FOnSelectCell;
//    property OnSetEditText: TSetEditEvent read FOnSetEditText write FOnSetEditText;
    property OnStartDock;
    property OnStartDrag;
//    property OnTopLeftChanged: TNotifyEvent read FOnTopLeftChanged write FOnTopLeftChanged;
  end;

procedure Register;

implementation

function NextLineOf(var s : String; NoMoreCharThan : Integer):String;
var
    xc : Integer;
    foundbr : Boolean;
begin
    Result := '';

    // -- Jump to the last position and work back from there
    if length(s) < NoMoreCharThan then
    begin
        // -- We are finished now
        Result := s;
        s := '';
        Exit;
    end;

    // -- Now look for the last space
    foundbr := False;
    for xc := NoMoreCharThan downto 1 do
    begin
        if (s[xc] = ' ') or (s[xc] = #13) then
        begin
            Result := Copy(s,1,xc-1);
            s := Copy(s,xc+1,Length(s)-xc);
            foundbr := True;
            break;
        end;
    end;
    if not foundbr then
    begin
        Result := Copy(s,1,NoMoreCharThan);
        s := '';
    end;
end;

function LineCountLineOf(var s : String; NoMoreCharThan : Integer):Integer;
var
    xc,lc,l : Integer;
begin
    lc := 0;
    if (s = '') then
        Exit;

    // -- Jump to the last position and work back from there
    if length(s) < NoMoreCharThan then
    begin
        // -- We are finished now
        Result := 1;
        Exit;
    end;

    // -- Now look for the last space
    while length(s) > 0 do
    begin
        l := length(s);
        
        if l < NoMoreCharThan then
        begin
            // -- We are finished now
            Inc(lc);
            break;
        end;

        // -- First choice, look for spaces
        for xc := NoMoreCharThan downto 1 do
        begin
            if (s[xc] = ' ') or (s[xc] = #13) then
            begin
                Inc(lc);
                s := Copy(s,xc+1,Length(s)-xc);
                break;
            end;
        end;

        for xc := NoMoreCharThan downto 1 do
        begin
            if (s[xc] = ',') or (s[xc] = '-') then
            begin
                Inc(lc);
                s := Copy(s,xc+1,Length(s)-xc);
                break;
            end;
        end;

        // -- This is dire here, but get out to avoid looping
        // -- We are finished now
        s := Copy(s, NoMoreCharThan, Length(s)-NoMoreCharThan);
        Inc(lc);

    end;
    // -- Return with the number of lines
    Result := lc;
end;

procedure Register;
begin
  RegisterComponents('PreisShare', [TProductLister]);
end;

constructor TProductLister.Create(AOwner: TComponent);
begin
    inherited Create(AOwner);

    // -- Setup the internal methods
    OnDrawCell  := MyDrawCell;
    OnMouseMove := MyMouseMove;
    OnMouseDown := MyMouseDown;
    OnResize    := MyResize;

    Items := TStringList.Create;
    fProductNode := GTDNode.Create;

    if fSellPriceLabel = '' then
        fSellPriceLabel := 'Your Price';
    if fListPriceLabel = '' then
        fListPriceLabel := 'List Price';

    // -- Default positions
    pOnSpecialLabel := 'Special Price!';

    // -- Position defaults
    pTop := 5;
    pNameTop  := pTop;
    pNameLeft := 50;
    pDescTop  := 20;
    pDescLeft := 50;
    pListRight := 270;
    pListTop  := pTop;
    pSellRight := 340;
    pSellTop  := pTop;
    pHeight    := 20;

    fPictureHeight := 100;
    fPictureWidth := 100;
    pPictHeight := 100;
    
    fHidePictures := False;

    BGColor := $00F9E8E3;
    Color := BGColor;
    FixedCols := 0;

end;

destructor TProductLister.Destroy;
begin
    DestroyItemData;

    Items.Destroy;

    fProductNode.Destroy;

    inherited Destroy;
end;

procedure TProductLister.DestroyItemData;
var
    myCell  : TProductCellData;
    xc      : Integer;
begin
    // -- Destroy any pictures
    for xc := 1 to Items.Count do
    begin
        myCell := TProductCellData(Items.Objects[xc-1]);
        if Assigned(myCell) then
        begin
            if myCell.P.Available and Assigned(myCell.P.Picture) then
            begin
                myCell.P.Picture.Destroy;
                myCell.P.Picture := nil;
            end;

            myCell.Destroy;

            Items.Objects[xc-1] := nil;
        end;
    end;
end;

procedure TProductLister.MyMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
    r,c,cX,cY,Index : LongInt;
    myRect : TRect;
    s : String;
    myCell : TProductCellData;
begin
    // -- Work out where in the cell
    MouseToCell(X, Y, c, r);
    myRect := CellRect(c,r);
    cX := X - myRect.Left;
    cY := Y - myRect.Top;

    // -- Calculate the cell
    Index := (r * ColCount) + (c-1);
    if (Index >= 0) and (Index < Items.Count) then
    begin
        myCell := TProductCellData(Items.Objects[Index]);

        if Assigned(myCell) then
        begin
            if (cX >= MyCell.NameX) and (cX < (MyCell.NameX + MyCell.NameL)) and
               (cY >= MyCell.NameY) and (cY < (MyCell.NameY + MyCell.NameH)) then
            begin
                if not MyCell.NameSelected then
                begin
                    // -- Select the name
                    Canvas.Brush.Style := bsClear;
                    Canvas.Font.Style := [fsBold,fsUnderline];
                    Canvas.Font.Color := clBlue;
                    Canvas.TextOut(MyRect.Left + myCell.NameX,MyRect.Top + myCell.NameY,myCell.N.Text);
                    MyCell.NameSelected := True;
                end;
            end
            else begin
                if MyCell.NameSelected then
                begin
                    MyCell.NameSelected := False;
                    InvalidateCell(c,r);
                end;
            end;
        end;
    end;

end;

procedure TProductLister.MyMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
    r,c,cX,cY,Index : LongInt;
    myRect : TRect;
    s : String;
    myCell : TProductCellData;
begin
    // -- Work out where in the cell
    MouseToCell(X, Y, c, r);
    myRect := CellRect(c,r);
    cX := X - myRect.Left;
    cY := Y - myRect.Top;

    // -- Calculate the cell
    Index := (r * ColCount) + (c-1);
    if (Index >= 0) and (Index < Items.Count) then
    begin
        myCell := TProductCellData(Items.Objects[Index]);

        if Assigned(myCell) then
        begin
            // -- Did we click on the Name ?
            if (cX >= MyCell.NameX) and (cX < (MyCell.NameX + MyCell.NameL)) and
               (cY >= MyCell.NameY) and (cY < (MyCell.NameY + MyCell.NameH)) then
            begin
                // -- Select the name
                if Assigned(fOnItemNameSelected) then
                    fOnItemNameSelected(Sender,Index,Items.Strings[Index]);

            end
            else begin
                // -- We clicked elsewhere than the name
                if MyCell.NameSelected then
                begin
                    MyCell.NameSelected := False;
                    InvalidateCell(c,r);
                end;
            end;
        end;
    end;
end;

procedure TProductLister.MyDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
const
    Floodfilling = False;
var
  index, x, yy, rh: integer;
  aColor    : TColor;
  pCode, pName, pDesc, pList, pSell,L : String;
  myCell : TProductCellData;
  pRect: TRect;
begin

    with Sender as TbsSkinDrawGrid do
    begin

        // -- Paint the background
        if gdFixed in State then
        begin
            if pgoShowHeader in DisplayOptions then
            begin
                // -- We only paint over the old header
                Canvas.Brush.Style := bsSolid;
                Canvas.Brush.Color := $00F9D8D3;
                Canvas.FillRect(Rect);
//              Canvas.Brush.Style := bsClear;
                Canvas.TextOut(Rect.Left+pTop,Rect.Top + pTop,'Code');
                Canvas.TextOut(Rect.Left+pNameLeft,Rect.Top + pTop,'Description');
                Canvas.TextOut(Rect.Left+pListRight-Canvas.TextWidth(ListPriceLabel),Rect.Top + pTop,ListPriceLabel);
                Canvas.TextOut(Rect.Left+pSellRight-Canvas.TextWidth(SellPriceLabel),Rect.Top + pTop,SellPriceLabel);
                Canvas.Brush.Style := bsSolid;
            end;
        end
        else begin

            Canvas.Brush.Style := bsSolid;

            // -- The first thing that we have to do is calculate the
            //    index into the list for the entry
            Index := (ARow * ColCount) + ACol-1;

            // -- Here we will read out some data
            if (Index < Items.Count) and (Index >= 0) then
            begin
                // -- Determine
                myCell := TProductCellData(Items.Objects[Index]);

                if Assigned(myCell) and (not myCell.DetailsLoaded) then
                    LoadFromSourceData(Index);

            end
            else begin
                myCell := nil;
                pName := 'Cell ';
            end;

            // -- Fill in the Cell with the background
            if Index mod 2 = 0 then
                Canvas.Brush.Color := $00F9E8E3
            else
                Canvas.Brush.Color := $00F4DCD7;

            // -- Color the Cell
            if Assigned(myCell) then
            begin
                // -- Is it part of a search
                if myCell.DisplayAsFound then
                    Canvas.Brush.Color := $00F2F2B8;
            end;

            // -- Now paint it
            Canvas.FillRect(Rect);

            // -- Work out what colors for text
            if (gdFocused in State) then
            begin
                aColor := FontColor;
                Canvas.Font.Style := [fsBold];
            end
            else begin
                Canvas.Font.Style := [];
            end;

            Canvas.Brush.Style := bsClear;

            // -- Display the name
            if Assigned(myCell) then
            begin

                // -- Paint the product name
                if CellHasName in myCell.AvailableFields then
                begin

                    // -- Check the length of the name (modify the original)
                    if Length(myCell.N.Text) > maxNameLength then
                        myCell.N.Text := Copy(myCell.N.Text,1,maxNameLength) + '..';
                    pName := myCell.N.Text;

                    myCell.NameX := pNameLeft;
                    myCell.NameY := pTop;
                    myCell.NameH := Canvas.TextHeight(pName);
                    myCell.NameL := Canvas.TextWidth(pName);
                    Canvas.Font.Color := clBlue;
                    Canvas.Font.Style := Canvas.Font.Style + [fsBold];
                    if pName <> '' then
                        Canvas.TextOut(Rect.Left+myCell.n.x,Rect.Top + myCell.N.Y,pName);
                end;

                // -- Now paint all the various fields
                Canvas.Font.Color := clBlack;
                Canvas.Font.Style := [];

                if CellHasCode in myCell.AvailableFields then
                begin
                    // Canvas.Font.Size := Canvas.Font.Size - 2;
                    pCode := myCell.C.Text;
                    if length(pCode) > 8 then
                        pCode := Copy(pCode,1,8) + '..';
					Canvas.TextOut(Rect.Left+myCell.C.X,Rect.Top + myCell.C.Y,pCode);
					// Canvas.Font.Size := Canvas.Font.Size + 2;
				end;

				if CellHasPict in myCell.AvailableFields then
				begin

					if Assigned(myCell.P.Picture) then
					begin
						pRect.Left  := Rect.Left + myCell.P.x;
						pRect.Top   := Rect.Top + myCell.P.y;
						pRect.Right := pRect.Left + myCell.P.w;
						pRect.Bottom:= pRect.Top + myCell.P.h;

						// -- Draw the product picture
						if Floodfilling then
						begin
							if Index mod 2 = 0 then
								Canvas.Brush.Color := $00F9E8E3
							else
								Canvas.Brush.Color := $00F4DCD7;
							Canvas.FloodFill(pRect.Left+5, pRect.Top+5, clWhite, fsSurface);
						end
						else begin
							x := Canvas.CopyMode;
							Canvas.CopyMode := cmSrcAnd;
							Canvas.StretchDraw(pRect,myCell.P.Picture.Picture.Graphic);
							Canvas.CopyMode := x;
						end;
					end;
				end;

				if CellHasDesc in myCell.AvailableFields then
				begin
					// -- This one needs to wordwrap
					L := myCell.D.Text;
					yy := Rect.Top + myCell.D.y;
                    rh := Canvas.TextHeight(L);

                    if (Length(L) > maxDescLength) then
                    begin
                        repeat
                            // -- Get every line
                            Canvas.TextOut(Rect.Left+pDescLeft,yy,NextLineOf(L,maxDescLength));
                            Inc(yy,rh);
                        until (L = '');
                    end
                    else
                        // -- Default write the text
                        Canvas.TextOut(Rect.Left+pDescLeft,yy,L);
                end;

                if CellHasList in myCell.AvailableFields then
                begin
                    Canvas.TextOut(Rect.Left+myCell.L.X-Canvas.TextWidth(myCell.L.Text),Rect.Top + myCell.L.y,myCell.L.Text);
                end;

                if CellHasSell in myCell.AvailableFields then
                begin
                    if myCell.onSpecialFlag then
                    begin
                        // -- Write on Special
                        Canvas.Font.Color := clRed;

                        // Canvas.Font.Size := Canvas.Font.Size - 2;
                        Canvas.TextOut(Rect.Left+myCell.S.x-Canvas.TextWidth(pOnSpecialLabel),Rect.Top + myCell.S.y + Canvas.TextHeight(pOnSpecialLabel),pOnSpecialLabel);
                        // Canvas.Font.Size := Canvas.Font.Size + 2;

                        Canvas.Font.Style := [fsBold];
                    end;

                    Canvas.TextOut(Rect.Left+myCell.S.x-Canvas.TextWidth(myCell.S.Text),Rect.Top + myCell.S.y,myCell.S.Text);

                end;

            end;

            if gdFocused in State then
            begin
                Canvas.Font.Color := aColor;
            end;

            // -- Draw one of our images
//            ImageList1.Draw(Canvas,Rect.Left,Rect.Top,index);
//            Canvas.StretchDraw(Rect,ImageList1.);

            Canvas.Brush.Style := bsSolid;

            if gdFocused in State then
                Canvas.DrawFocusRect(Rect);

		end;
	end;
end;

procedure TProductLister.LoadProductGroup(aNode : GTDNode);
var
	xc, iNumber : Integer;
	ProductNode : GTDNode;
	l,p         : String;
	CellData    : TProductCellData;
begin

	ProductNode := GTDNode.Create;

	try

		// -- Free any old ProductCellData
		for xc := 1 to Items.Count do
		begin
			CellData := TProductCellData(Items.Objects[xc-1]);
			if Assigned(CellData) then
			begin
				CellData.Destroy;
				Items.Objects[xc-1] := nil;
			end;
		end;

		// --
		aNode.GotoStart;

		// -- Setup some defaults
		ColWidths[0] := Width;

		Items.Clear;

		if pgoShowHeader in DisplayOptions then
		begin
			FixedRows := 1;
			RowCount := 2;
			iNumber := 1;
			RowHeights[0] := DefaultRowHeight;
		end
		else
		begin
			FixedRows := 0;
			RowCount := 1;
			iNumber := 0;
		end;

		// -- Extract each product item from the group
		while ProductNode.ExtractTaggedSection(GTD_PL_PRODUCTITEM_TAG,aNode) do
		begin
			// --
			L := '';
			// -- Add all lines into one line
			for xc := 1 to ProductNode.MsgLines.Count do
				L := L + ProductNode.MsgLines[xc-1] + #13;

			// -- Check if there might be an image to reload
			if Assigned(fRegistry) and Assigned(fSupplierLink) then
			begin
				// -- If there is a picture
				p := ProductNode.ReadStringField(GTD_PL_ELE_PRODUCT_IMAGE);
				if (p <> '') and (not fRegistry.HaveImage(p)) then
				begin
					// -- Request that the image be downloaded
					fSupplierLink.ReceiveImage(p);

					// -- Make sure that when the image is received, we see it
					fSupplierLink.OnProductImageReceived := HandleImageReceived;

				end;
			end;

			// -- Adjust the number of cells to the height
			RowCount := iNumber + 1;

			// -- Create an object to hold additional cell data
			CellData := TProductCellData.Create;

			// -- Now add this line to the items list
			Items.AddObject(L,CellData);

			Inc(iNumber);

		end;

		Refresh;

    finally
        ProductNode.Destroy;
    end;

end;

procedure TProductLister.MyResize(Sender: TObject);
begin
    // -- Default positions
	pTop := 5;

    ColWidths[0] := Width;

    CalcLabelPositions;

    if fDisplayStyle = ProductBasicStyle then
    begin
        maxNameLength := ((pListRight - pDescLeft) - 10) div 7;
        maxDescLength := maxNameLength;
    end
    else if fDisplayStyle = ProductLeftPictStyle then
    begin
        maxNameLength := ((pSellRight - pDescLeft) - 10) div 6;
        maxDescLength := maxNameLength;
    end;

    ForceItemReload;

end;

procedure TProductLister.SelectItemCode(ItemCode : String);
var
    xc : Integer;
    s : String;
    CellData : TProductCellData;
    ProductNode : GTDNode;
begin
	// --
    // --
    ProductNode := GTDNode.Create;

    for xc := 1 to Items.Count do
    begin
        CellData := TProductCellData(Items.Objects[xc-1]);

        ProductNode.UseSingleLine(Items[xc-1]);

        s := ProductNode.ReadStringField(GTD_PL_ELE_PRODUCT_CODE);

        if s = ItemCode then
        begin
            CellData.DisplayAsFound := True;

            //-- Select this row
            Row := xc;
        end
        else
            CellData.DisplayAsFound := False;

    end;

    ProductNode.Destroy;

    Update;
end;

procedure TProductLister.LoadFromSourceData(ItemIndex : Integer);
var
    s : String;
    myCell : TProductCellData;
    SubSection : GTDNode;
    AspectR,o,rHeight : Integer;
begin
    // -- First get a pointer on our cell
    myCell := TProductCellData(Items.Objects[ItemIndex]);

    fProductNode.UseSingleLine(Items[ItemIndex]);

    rHeight := pHeight;

    // -- Some initialisation
    myCell.AvailableFields := [];

    // -- Load details for the CODE
    s := fProductNode.ReadStringField(GTD_PL_ELE_PRODUCT_CODE);
    if s <> '' then
    begin
        // -- Load all the information that we need for the Code
        myCell.C.Available := True;
        myCell.C.Text := s;
        myCell.C.x := pListTop;
        myCell.C.y := pListTop;
        Include(myCell.AvailableFields,CellHasCode);
	end
    else
        myCell.N.Available := False;

    // -- Load details for the NAME
    s := fProductNode.ReadStringField(GTD_PL_ELE_PRODUCT_NAME);
    if s <> '' then
    begin
        // -- Load all the information that we need for the Code
        myCell.N.Available := True;
        myCell.N.Text := s;
        myCell.N.y    := pNameTop;
        myCell.N.x    := pNameLeft;
        Include(myCell.AvailableFields,CellHasName);
    end
    else
        myCell.N.Available := False;

    // -- Load details for the DESCRIPTION
    s := fProductNode.ReadStringField(GTD_PL_ELE_PRODUCT_DESC);
    if s <> '' then
    begin
        // -- Load all the information that we need for the Code
        myCell.D.Available  := True;
        myCell.D.Text       := s;
        myCell.D.y          := pDescTop;
        myCell.D.x          := pDescLeft;
        Include(myCell.AvailableFields,CellHasDesc);

        // -- Add extra height
        rHeight := rHeight + (13 * LineCountLineOf(s,maxDescLength)) + 5;
    end
    else
        myCell.D.Available := False;

    // -- Load details for the LIST Price
    s := fProductNode.ReadStringField(GTD_PL_ELE_PRODUCT_LIST);
    if s <> '' then
    begin
        // -- Load all the information that we need for the Code
        myCell.L.Available := True;
        myCell.L.Text := Format('%m',[StringToFloat(s)]);
        Include(myCell.AvailableFields,CellHasList);
        myCell.L.y := pListTop;
        myCell.L.x := pListRight;
    end
    else
        myCell.L.Available := False;

    // -- Load details for the SELL Price
    s := fProductNode.ReadStringField(GTD_PL_ELE_PRODUCT_ACTUAL);
    if s <> '' then
    begin
        // -- Load all the information that we need for the Code
        myCell.S.Available := True;
        myCell.S.Text := Format('%m',[StringToFloat(s)]);;
		Include(myCell.AvailableFields,CellHasSell);
        myCell.S.y := pSellTop;
        myCell.S.x := pSellRight;
    end
    else
        myCell.S.Available := False;

    // -- If there is no sell, use the list
    if (not myCell.S.Available) and (myCell.L.Available) then
    begin
        myCell.S.Available := True;
        myCell.S.Text      := myCell.L.Text;
        myCell.L.Available := False;
        myCell.S.x         := pSellRight;
        myCell.S.y         := myCell.L.y;
        Exclude(myCell.AvailableFields,CellHasList);
        Include(myCell.AvailableFields,CellHasSell);
    end;

    // -- OnSpecial Indicator
    if fProductNode.ReadStringField(GTD_PL_ELE_ONSPECIAL) = 'True' then
        myCell.onSpecialFlag := True
    else
        myCell.onSpecialFlag := False;

    // -- Availability
    s := fProductNode.ReadStringField(GTD_PL_ELE_PRODUCT_AVAIL_STATUS);
    if s <> '' then
	begin
        myCell.A.Available := True;
        myCell.A.Text := s;
        Include(myCell.AvailableFields,CellHasAvail);
    end;

    // -- Product pictures
    if not fHidePictures then
    begin

        {
        if fProductNode.FindTagRegion(GTD_PL_PRODUCT_IMAGE_TAG) then
        begin
            fProductNode.GotoStart;

            s := fProductNode.ReadStringField(GTD_PL_ELE_PRODUCT_IMAGE_ID);
		}

			fProductNode.GotoStart;

			s := fProductNode.ReadStringField(GTD_PL_ELE_PRODUCT_IMAGE);

			if s <> '' then
			begin
				if Assigned(fRegistry) then
				begin
					myCell.P.Picture := TImage.Create(Self);
					if fRegistry.LoadImage(s,myCell.P.Picture) then
					begin

						if fDisplayStyle = ProductBasicStyle then
						begin
							AspectR := (myCell.P.Picture.Picture.Width * 100) div myCell.P.Picture.Picture.Height;

							// -- We have to adjust the width to obtain the correct aspect ratio
							myCell.P.h := fPictureHeight;
							myCell.P.w := (fPictureHeight * AspectR) div 100;
							myCell.P.x := pPictLeft;
							myCell.P.y := pPictTop;

							rHeight := rHeight + fPictureHeight;
						end
						else if fDisplayStyle = ProductLeftPictStyle then
						begin
							AspectR := (myCell.P.Picture.Picture.Height * 100) div myCell.P.Picture.Picture.Width;

							// -- We have to adjust the width to obtain the correct aspect ratio
							myCell.P.h := (fPictureWidth * AspectR) div 100;
							myCell.P.w := fPictureWidth;
							myCell.P.x := pPictLeft;
							myCell.P.y := pPictTop;

							rHeight := myCell.P.h + (2 * pTop);
						end;

						myCell.P.Available := True;
						Include(myCell.AvailableFields,CellHasPict);

					end
					else begin
						// -- De-initialise and remove
						myCell.P.Picture.Free;
						myCell.P.Picture:=nil;
					end;
				end;
            end;
        {
        end;
        }
    end;

    // -- Product Variations
    if fProductNode.FindTagRegion(GTD_PL_VARIATIONS_TAG) then
    begin

    end;

    // -- Product Options/Accessories
    if fProductNode.FindTagRegion(GTD_PL_OPTIONS_TAG) then
    begin

    end;

    // -- Ok, now reformat everything according to the style
    if fDisplayStyle = ProductBasicStyle then
    begin

        if myCell.P.Available and myCell.D.Available then
        begin
            myCell.D.y := pDescTop + myCell.P.h;
        end;

    end;

    // -- Now set the row height
    if pgoShowHeader in DisplayOptions then
        RowHeights[ItemIndex+1] := rHeight
    else
        RowHeights[ItemIndex] := rHeight;

    // -- Very important, no need to load the details again
    myCell.DetailsLoaded := True;

end;

procedure TProductLister.SetDisplayStyle(NewStyle : TProductDisplayStyles);
begin
    fDisplayStyle := NewStyle;

    if NewStyle = ProductBasicStyle then
    begin
        pTop := 5;
        pNameTop  := pTop;
        pNameLeft := 70;
        pDescTop  := 20;
        pDescLeft := 70;
        pHeight    := 25;
        pPictTop   := pDescTop;
        pPictLeft  := pDescLeft;
        pPictHeight:= 100;
    end
    else if NewStyle = ProductLeftPictStyle then
    begin
        pPictTop   := pTop;
        pPictLeft  := pTop;
        pTop := 5;
        pNameTop  := pTop;
        pNameLeft := pPictLeft + fPictureWidth + 15;
        pDescTop  := 20;
        pDescLeft := pNameLeft;
        pHeight    := 25;
    end
    else if NewStyle = ProductRightPictStyle then
    begin
    end
    else if NewStyle = ProductAltPictStyle then
    begin
    end;

    ForceItemReload;

end;

procedure TProductLister.SetPictureHeight(NewHeight : Integer);
begin
    fPictureHeight := NewHeight;
    
    fHidePictures := NewHeight = 0;

    SetDisplayStyle(fDisplayStyle);
end;

procedure TProductLister.SetPictureWidth(NewWidth : Integer);
begin
    fPictureWidth := NewWidth;
    fHidePictures := NewWidth = 0;
    SetDisplayStyle(fDisplayStyle);
end;

procedure TProductLister.SetPicturesHidden(ShowThem : Boolean);
begin
    fHidePictures := not ShowThem;

    SetDisplayStyle(fDisplayStyle);
end;

procedure TProductLister.CalcLabelPositions;
begin
    if fDisplayStyle = ProductBasicStyle then
    begin

        pNameLeft := 70;
        pDescTop  := 20;
        pDescLeft := 70;
        pSellTop  := pTop;
        pListTop  := pTop;

        if (fSellPriceLabel <> '') and (fListPriceLabel <> '') then
        begin
            pSellRight := Width - pTop;
            pListRight := pSellRight - 90;
        end
        else if (fSellPriceLabel <> '') and (fListPriceLabel = '') then
        begin
            pSellRight := Width - pTop;
			pListRight := pSellRight - pTop;
		end
		else if (fSellPriceLabel = '') and (fListPriceLabel <> '') then
		begin
			pSellRight := Width - pTop;
			pListRight := pSellRight - 90;
		end;

    end
    else if fDisplayStyle = ProductBasicStyle then
    begin
        pNameLeft := 70;
        pDescTop  := 20;
        pDescLeft := 70;
        pSellRight := Width - pTop;
        pSellTop  := pTop;
        pListRight := pSellRight - 90;
        pListTop  := pTop;
    end;
end;

procedure TProductLister.ForceItemReload;
var
    s : String;
    xc : Integer;
    myCell : TProductCellData;
begin
    // -- Now we need to force a reload on all fields
    //    so that they will get redisplayed
    for xc := 1 to Items.Count do
    begin
        // -- First get a pointer on our cell
        myCell := TProductCellData(Items.Objects[xc-1]);

        myCell.DetailsLoaded := False;

    end;

    Refresh;
end;

procedure TProductLister.HandleImageReceived(Sender: TObject; GTL : String; ShortFileName : String; DataInBase64 : GTDBizDoc);
begin
	ForceItemReload;
end;

procedure TProductLister.SetSellPriceLabel(NewLabel : String);
begin
    fSellPriceLabel := newLabel;
    CalcLabelPositions;
end;

procedure TProductLister.SetListPriceLabel(NewLabel : String);
begin
    fListPriceLabel := newLabel;

    CalcLabelPositions;
end;

procedure TProductLister.Clear;
begin
    // -- Clear all important fields

    DestroyItemData;

    Items.Clear;
    fProductNode.Clear;
    if pgoShowHeader in DisplayOptions then
        RowCount := 2
    else
        RowCount := 1;

    //Refresh;
end;

end.
