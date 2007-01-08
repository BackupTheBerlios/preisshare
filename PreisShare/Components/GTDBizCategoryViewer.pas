unit GTDBizCategoryViewer;

interface
{$IFDEF VER100}
{$DEFINE HW_SIMPLE}
{$ELSE}
{$IFDEF VER110}
{$DEFINE HW_SIMPLE}
{$ENDIF}
{$ENDIF}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, Outline, Comctrls,
  Winsock;
  
const
	bizCatSelIndex = 1;
	bizCatUnsIndex = 0;

type

  hCategoryClickEvent = procedure(Sender: TObject; Identifier, Description : String) of object;

  type hBizCatViewStyles = (vsAll, vsSelectedOnly);

  hBizCategory = class(TCustomTreeView)
  private
	{ Private declarations }
	FOnCategoryClick   : hCategoryClickEvent;
	fViewStyle 		   : hBizCatViewStyles;

	function fReadSelectedCode : String;
	function fGetSelectedCodeList : String;
	procedure fSetSelectedCodeList(aList : String);
	function fGetViewStyle : hBizCatViewStyles;
	procedure fSetViewStyle(const newViewStyle : hBizCatViewStyles);

    procedure GetSelectedIndex(Node : TTreeNode); override;

  protected
	{ Protected declarations }
  public
	{ Public declarations }
	function LoadUserList(aList : TStrings):Boolean;
	function LoadMasterList(aList : TStrings):Boolean;
  published
	{ Published declarations }
	property OnCategoryClick : hCategoryClickEvent read FOnCategoryClick write FOnCategoryClick;

	property SelectedCode : String read fReadSelectedCode;
	property SelectedCodeList : String read fGetSelectedCodeList write fSetSelectedCodeList;

	property ViewStyle : hBizCatViewStyles read fGetViewStyle write fSetViewStyle default vsAll;

	property Align;
	property DragCursor;
	property DragMode;
	property Enabled;
	property Font;
	property HideSelection;
	{$IFNDEF HW_SIMPLE}
  	property Anchors;
  	property AutoExpand;
  	property BiDiMode;
  	property BorderStyle;
  	property BorderWidth;
  	property ChangeDelay;
  	property Color;
  	property Ctl3D;
  	property Constraints;
  	property DragKind;
  	property HotTrack;
  	property ParentBiDiMode;
  	property RowSelect;
  	property ShowButtons;
  	property ToolTips;
  	property OnEndDock;
	property OnStartDock;
	{$ENDIF}
  	property Images;
	property Indent;
	property ParentColor default False;
	property ParentCtl3D;
	property ParentFont;
	property ParentShowHint;
	property PopupMenu;
	property ReadOnly;
	property RightClickSelect;
	property ShowHint;
	property ShowLines;
	property ShowRoot;
	property SortType;
	property StateImages;
	property TabOrder;
	property TabStop default True;
	property Visible;
	property OnClick;
	property OnCollapsing;
	property OnCollapsed;
	property OnDblClick;
	property OnDragDrop;
	property OnDragOver;
	property OnEdited;
	property OnEditing;
	property OnEndDrag;
	property OnEnter;
	property OnExit;
	property OnExpanding;
	property OnExpanded;
	property OnGetImageIndex;
//	property OnGetSelectedIndex;
	property OnStartDrag;
  end;

  hCategoryElem = class(TObject)
  public
	category_code : String;
  end;

procedure Register;

implementation
	uses GTDBizDocs;

procedure Register;
begin
	RegisterComponents('PreisShare', [hBizCategory]);
end;

function hBizCategory.LoadUserList(aList : TStrings):Boolean;
begin

end;

function hBizCategory.LoadMasterList(aList : TStrings):Boolean;
var
	markB : HECMLMarker;
	xc,xd : Integer;
	l,s, cc, cd : String;
	vb : Boolean;
	anItem,topItem : TTreeNode;
	anElem : hCategoryElem;
begin
	markB := HECMLMarker.Create;

	Items.Clear;

	// -- Create the topmost element
	anElem := hCategoryElem.Create;
	anElem.category_code := 'All';
	topItem := Items.AddObject(nil,'All', anElem);

    // -- Read each line
    for xc := 1 to aList.Count do
    begin
        markB.Clear;
        markB.Add(aList.Strings[xc-1]);

        cc := markB.ReadStringField('Category_Code');
        cd := markB.ReadStringField('Category_Description');
        vb := markB.ReadBooleanField('Visible',True);

        if (cc <> '') and (cd <> '') and (vb) then
        begin

            // -- Create the element
            anElem := hCategoryElem.Create;
            anElem.category_code := cc;

            anItem := Items.AddChildObject(topItem,cd, anElem);

            // -- We always use stateindex if it's available
            if Assigned(StateImages) then
                anItem.StateIndex := bizCatUnsIndex;
        end;

    end;

	// -- Ensure that we can see all the items under this
	topItem.Expand(false);

	markB.Destroy;
end;

function hBizCategory.fReadSelectedCode : String;
var
	anElem : hCategoryElem;
begin
	Result := '';

	if Assigned(Selected) then
	begin
		anElem := hCategoryElem(Selected.Data);

		if Assigned(anElem) then
			Result := anElem.category_code;

	end;
end;

function hBizCategory.fGetSelectedCodeList : String;
var
	xc : Integer;
	anElem : hCategoryElem;
begin
	// -- Look through all the items and find ones that have
	//    the right imageindex. Build these into a string and
	//    then return them.
	for xc := 1 to Items.Count do
	begin
		if Items[xc-1].ImageIndex = bizCatSelIndex then
		begin
			anElem := hCategoryElem(Items[xc-1].Data);

			if Assigned(anElem) then
			begin
				if Result <> '' then
					Result := Result + ';';

				Result := Result + anElem.category_code;
			end;
		end;

	end;
end;

procedure hBizCategory.fSetSelectedCodeList(aList : String);
var
	xc : Integer;
	anElem : hCategoryElem;
begin
	// -- Look through all the items and find ones that have
	//    the right imageindex. Build these into a string and
	//    then return them.

	for xc := 1 to Items.Count do
	begin
		anElem := hCategoryElem(Items[xc-1].Data);

		if Assigned(anElem) then
		begin
			if Pos(anElem.Category_Code,aList)<> 0 then
				Items[xc-1].ImageIndex := bizCatSelIndex
			else
				Items[xc-1].ImageIndex := bizCatUnsIndex;
		end
		else
			Items[xc-1].ImageIndex := bizCatUnsIndex;

	end;
end;

function hBizCategory.fGetViewStyle : hBizCatViewStyles;
begin
	Result := fViewStyle;
end;

procedure hBizCategory.fSetViewStyle(const newViewStyle : hBizCatViewStyles);
begin
	fViewStyle := newViewStyle;
end;

procedure hBizCategory.GetSelectedIndex(Node : TTreeNode);
begin
	Node.SelectedIndex := Node.ImageIndex;
end;

end.
