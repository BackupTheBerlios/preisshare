unit GTDGeoView;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  db, dbctrls, ExtCtrls;

type
  hGeoPoint = class(TObject)
  private
    { Private declarations }
    shape_component			: TShape;
  protected
    { Protected declarations }
  public
    { Public declarations }
    lattitude, longitude    : double;
    shape_size,
    shape_type              : integer;
    shape_color,
    line_color              : TColor;
    pFullName               : String;

	destructor Destroy; override;

  published
    { Published declarations }
    property FullName : String read pFullName write pFullName;
  end;

  hPointClickEvent = procedure(Sender: TObject; Org_Code : String; PointInfo : hGeoPoint) of object;
  hMapClickEvent = procedure(Sender: TObject; var New_Org_Code : String; PointInfo : hGeoPoint; var KeepPoint : Boolean) of object;

  hGeoView = class(TPanel)
  private
    FDataLink		: TFieldDataLink;
    FUpdating		: Boolean;
    FStateChanging	: Boolean;
    FMemoLoaded		: Boolean;
    FAutoDisplay	: Boolean;
    FFocused		: Boolean;
    FDataSave		: string;
    MapImage        : TDBImage;
    FOnPointClick   : hPointClickEvent;
    FOnMapClick   	: hMapClickEvent;
    mCoords			: String;

    procedure hGeoPointMouseDown(Sender: TObject; Button: TMouseButton;
                                 Shift: TShiftState; X, Y: Integer);
    procedure hGeoMapMouseDown(Sender: TObject; Button: TMouseButton;
                                 Shift: TShiftState; X, Y: Integer);
    function GetDataField: string;
    function GetDataSource: TDataSource;
    procedure SetDataField(const Value: string);
    procedure SetDataSource(Value: TDataSource);
    procedure ShowIfOnMap(aPoint : hGeoPoint);
    procedure DataChange(Sender: TObject);
  protected
    { Protected declarations }
  public
    { Private declarations }
    PointList       : TStringList;
    Start_Lattitude,
    Start_Longitude,
    End_Lattitude,
    End_Longitude   : double;

    { Public declarations }
	constructor Create(AOwner: TComponent); override;
	destructor Destroy; override;

    procedure Add(Org_Code : String; PointInfo : hGeoPoint);
    procedure AddLink(Org_Code : String; PointInfo : hGeoPoint);
    procedure Delete(Org_Code : String);
    procedure ReDraw;
    procedure Clear;

  published
    { Published declarations }
    property OnPointClick: hPointClickEvent read FOnPointClick write FOnPointClick;
    property OnMapClick: hMapClickEvent read FOnMapClick write FOnMapClick;
    property DataField: string read GetDataField write SetDataField;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property Coordinates : String read mCoords write mCoords;

  protected
    property OnClick;
    property OnMouseMove;
    property OnMouseDown;
    property OnMouseUp;
  end;

procedure Register;

implementation

constructor hGeoView.Create(AOwner: TComponent);
begin
	inherited Create(AOwner);

	PointList := TStringList.Create;

    Start_Lattitude := 0;
    Start_Longitude := 0;
    End_Lattitude   := 0;
    End_Longitude   := 0;

    // -- Create the TImage control used to hold the map
    MapImage := TDBImage.Create(Self);
    MapImage.Visible := True;
    MapImage.Parent := Self;
    MapImage.Align := alClient;
    MapImage.onMouseDown := hGeoMapMouseDown;
    MapImage.Stretch := True;

  	FDataLink := TFieldDataLink.Create;
  	FDataLink.Control := Self;

	FDataLink.OnDataChange := DataChange;
//  	MapImage.FDataLink.OnEditingChange := EditingChange;
//  	MapImage.FDataLink.OnUpdateData := UpdateData;

end;

destructor hGeoView.Destroy;
begin
    PointList.Free;
    FDataLink.Free;
    MapImage.Free;

	inherited Destroy;
end;

procedure hGeoView.Add(Org_Code : String; PointInfo : hGeoPoint);
var
    newIndex : Integer;
    aPoint   : TShape;
begin
    // -- Create the new point in the display
    newIndex := PointList.Add(Org_Code);

    // -- Add in the object data
    PointList.Objects[newIndex] := PointInfo;

    // -- Create a new component
    aPoint := TShape.Create(Self);
    aPoint.Top := Round(PointInfo.Longitude);
    aPoint.Left := Round(PointInfo.Lattitude);

    // -- Setup the size of the point
    if PointInfo.shape_size = 0 then
        aPoint.Width := 5
    else
        aPoint.Width := PointInfo.shape_size;
    if PointInfo.shape_size = 0 then
        aPoint.Height := 5
    else
        aPoint.Height := PointInfo.shape_size;

    aPoint.Brush.Color := PointInfo.shape_color;
    if (PointInfo.shape_type = 0) then
        aPoint.Shape := stSquare
    else
        aPoint.Shape := stEllipse;
    aPoint.Parent := MapImage;
    aPoint.onMouseDown := hGeoPointMouseDown;
    aPoint.Tag := newIndex;
    aPoint.Cursor := crHandpoint;
    if PointInfo.FullName <> '' then
    begin
    	// -- Setup the full name as the hint
		aPoint.Hint := PointInfo.FullName;
        aPoint.ShowHint := True;
    end;

    PointInfo.shape_component := aPoint;

    // -- Decide whether the point is visible or not
	ShowIfOnMap(PointInfo);

end;

procedure hGeoView.AddLink(Org_Code : String; PointInfo : hGeoPoint);
var
    newIndex : Integer;
    aPoint   : TShape;
begin
    // -- First add the point
    Add(Org_Code,PointInfo);

    // -- Create the new point in the display
    newIndex := PointList.Add('Link to ' + Org_Code);

    // -- Add in the object data
    PointList.Objects[newIndex] := PointInfo;

    // -- Create a new component
    aPoint := TShape.Create(Self);
    aPoint.Top := Round(PointInfo.Longitude);
    aPoint.Left := Round(PointInfo.Lattitude);
    aPoint.Width := 5;
    aPoint.Height := 5;
    aPoint.Brush.Color := PointInfo.shape_color;
    aPoint.Shape := stSquare;
    aPoint.Parent := MapImage;
    aPoint.onMouseDown := hGeoPointMouseDown;
    aPoint.Tag := newIndex;
    aPoint.Cursor := crHandpoint;
    if PointInfo.FullName <> '' then
    begin
    	// -- Setup the full name as the hint
		aPoint.Hint := PointInfo.FullName;
        aPoint.ShowHint := True;
    end;

    PointInfo.shape_component := aPoint;

    // -- Decide whether the point is visible or not
	ShowIfOnMap(PointInfo);
end;

procedure hGeoView.Clear;
var
	xc		 : Integer;
    aPoint   : hGeoPoint;
begin
	for xc := 1 to PointList.Count do
    begin
        // -- Find the component
        aPoint := hGeoPoint(PointList.Objects[xc-1]);

        // -- Delete the component
        aPoint.Destroy;

		PointList.Objects[xc-1] := nil;

    end;

    // -- Delete it if found
    PointList.Clear;

    Repaint;
end;

procedure hGeoView.Delete(Org_Code : String);
var
    pIndex : Integer;
    aPoint   : hGeoPoint;
begin
    // -- Look for the item
    pIndex := PointList.IndexOf(Org_Code);
    if (pIndex <> -1) then
    begin

        // -- Find the component
        aPoint := hGeoPoint(PointList.Objects[pIndex]);

        // -- Delete the component
        aPoint.Free;

        // -- Delete it if found
        PointList.Delete(pIndex);

        Repaint;

    end;

end;

procedure hGeoView.ReDraw;
begin

end;

procedure hGeoView.hGeoMapMouseDown(Sender: TObject; Button: TMouseButton;
                                 Shift: TShiftState; X, Y: Integer);
var
    newPoint 	: hGeoPoint;
    keepPoint 	: Boolean;
    newCode		: String;
begin
    newPoint := hGeoPoint.Create;
    newPoint.lattitude := x;
    newPoint.longitude := y;

    keepPoint := False;

    // -- Now run the users procedure
	if Assigned(FOnMapClick) then
    	FonMapClick(Sender, newCode, newPoint, keepPoint);

    // -- Add this point if they wish to keep it
    if keepPoint then
        Add(newCode,newPoint)

end;

procedure hGeoView.hGeoPointMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
    thisControl : TShape;
    thisPoint	: hGeoPoint;
    xc			: Integer;
begin
	// -- Determine the control
    thisControl := TShape(Sender);

    // -- Find the point
    for xc := 1 to PointList.Count do
    begin
    	thisPoint := hGeoPoint(PointList.Objects[xc-1]);
        if (thisPoint.shape_component = thisControl) then
        begin

		    // -- Fire off the event if it's available
		    if Assigned(FOnPointClick) then
		        FOnPointClick(Self,PointList.Strings[xc-1],thisPoint)
			else
            	MessageDlg('You''ve clicked on Trader ' + PointList.Strings[xc-1],mtInformation,[mbOk],0);

            break;
        end;
	end;

end;

procedure Register;
begin
  RegisterComponents('Tradalogs', [hGeoView]);
end;

function hGeoView.GetDataSource: TDataSource;
begin
	//  Result := FDataLink.DataSource;
    Result := MapImage.DataSource;
end;

procedure hGeoView.SetDataSource(Value: TDataSource);
begin
	{
  FDataLink.DataSource := Value;
  if Value <> nil then Value.FreeNotification(Self);
  }
  MapImage.DataSource := Value;
  if Value <> nil then Value.FreeNotification(Self);
end;

function hGeoView.GetDataField: string;
begin
//  Result := FDataLink.FieldName;
  Result := MapImage.DataField;
end;

procedure hGeoView.SetDataField(const Value: string);
begin
  FDataLink.FieldName := Value;
  MapImage.DataField := Value;
end;

procedure hGeoView.ShowIfOnMap(aPoint : hGeoPoint);
var
	aShape : TShape;
begin
	aShape := aPoint.shape_component;

	// -- Default by hiding the component
	aShape.Visible := False;

	// -- If none of the values are set then don't display
	if (Start_Lattitude = 0) and
	   (Start_Longitude = 0) and
	   (End_Lattitude = 0) and
       (End_Longitude = 0) then
    begin
    	Exit;
    end;

    // -- If it's in the range then display
    if (aPoint.lattitude >= Start_Lattitude) and
       (aPoint.lattitude <= End_Lattitude) and
       (aPoint.Longitude >= Start_Longitude) and
       (aPoint.Longitude <= End_Lattitude) then
	begin
		aShape.Visible := True;
        aShape.BringToFront;
    end;

end;

destructor hGeoPoint.Destroy;
begin
	shape_component.Destroy;

	inherited Destroy;
end;

procedure hGeoView.DataChange(Sender: TObject);
var
	ds : TDataSet;
begin
	if FDataLink.DataSet = nil then begin
    	if (csDesigning in ComponentState) then ;
  	end
  	else begin
    	ds := FDataLink.DataSet;
        if ds.State = dsBrowse then
        begin
        	try
        		Start_Lattitude := ds.FieldByName('Start_Lattitude').AsFloat;
        		End_Lattitude := ds.FieldByName('End_Lattitude').AsFloat;
        		Start_Longitude := ds.FieldByName('Start_Longitude').AsFloat;
        		End_Longitude := ds.FieldByName('End_Longitude').AsFloat;
            finally

            end;
        end;
  	end;
end;


end.
