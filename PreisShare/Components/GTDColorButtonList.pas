unit GTDColorButtonList;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, ExtCtrls
  {$IFNDEF NO_SKINS}
    ,bsSkinData, BusinessSkinForm, bsSkinCtrls, bsSkinBoxCtrls
  {$ENDIF}
  ;

type
  hButtonClickEvent = procedure(Sender: TObject; Identifier, Description : String) of object;
  hPanelMouseMoveEvent = procedure(Sender: TObject; Shift: TShiftState; X, Y: Integer) of object;

  {$IFNDEF NO_SKINS}
  hColorButtonList = class(TbsSkinGroupBOX)
  private
    { Private declarations }
    fColor          : TColor;
    fFont           : TFont;
    fButtons        : TStrings;
    fGap,
    fWidth,
    fHeight         : Integer;
    fEnableRedraw	: Boolean;
    FOnButtonClick   : hButtonClickEvent;
    fSkinData       :   TbsSkinData;

    procedure setButtons(Value : TStrings);
    procedure CreateControls;
	procedure DestroyControls;
    procedure setButtonHeight(newHeight : Integer);
    procedure setButtonWidth(newWidth : Integer);
    procedure setButtonGap(newGap : Integer);

    procedure doButtonClick(Sender : TObject);
    function  DoubleAmpersand(s : String):String;
    function  SingleAmpersand(s : String):String;

  protected
    { Protected declarations }
    procedure SetSkinData(Value: TbsSkinData); override;
  public
    { Public declarations }
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;

    procedure Clear;
    procedure Add(aCode, aDisplayLabel : String; IsChild : Boolean = False);
    procedure BeginUpdate;
	procedure EndUpdate;
	procedure SetButtonPosByCode(aCode : String; PushDown : Boolean; FireEvent : Boolean = True);
    function  GetSelectedButton:String;
	procedure Resize;

  published
    { Published declarations }
	property ButtonList : TStrings read fButtons write setButtons;
	property ButtonWidth : Integer read fWidth write setButtonWidth;
	property ButtonHeight : Integer read fHeight write setButtonHeight;
	property ButtonGap : Integer read fGap write setButtonGap;
	property OnButtonClick : hButtonClickEvent read FOnButtonClick write FOnButtonClick;
    property SkinData   : TbsSkinData read fSkinData write SetSkinData;
    property Color : TColor read fColor write fColor;
    property Font : TFont read fFont write fFont;
  end;
  {$ELSE}
  hColorButtonList = class(TScrollBox)
  private
    { Private declarations }
    fButtons        : TStrings;
    fGap,
    fWidth,
    fHeight         : Integer;
    fEnableRedraw	: Boolean;
    FOnButtonClick   : hButtonClickEvent;

    procedure setButtons(Value : TStrings);
    procedure CreateControls;
	procedure DestroyControls;
    procedure setButtonHeight(newHeight : Integer);
    procedure setButtonWidth(newWidth : Integer);
    procedure setButtonGap(newGap : Integer);

    procedure doButtonClick(Sender : TObject);
    procedure doButtonMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure doPanelMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    function DoubleAmpersand(s : String):String;
    function  SingleAmpersand(s : String):String;

  protected
    { Protected declarations }
  public
    { Public declarations }
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;

    procedure Clear;
    procedure Add(aCode, aDisplayLabel : String; IsChild : Boolean = False);
    procedure BeginUpdate;
	procedure EndUpdate;
	procedure SetButtonPosByCode(aCode : String; PushDown : Boolean; FireEvent : Boolean = True);
	procedure Resize;
    function  GetSelectedButton:String;

  published
    { Published declarations }
	property ButtonList : TStrings read fButtons write setButtons;
	property ButtonWidth : Integer read fWidth write setButtonWidth;
	property ButtonHeight : Integer read fHeight write setButtonHeight;
	property ButtonGap : Integer read fGap write setButtonGap;
	property OnButtonClick : hButtonClickEvent read FOnButtonClick write FOnButtonClick;
  end;
  {$ENDIF}

procedure Register;

implementation
	uses GTDBizDocs;

const
	btnSelectColor = $008A4A0B;
	btnNormalColor = $00B7620D;

procedure Register;
begin
  RegisterComponents('Tradalogs', [hColorButtonList]);
end;

function hColorButtonList.DoubleAmpersand(s : String):String;
var
    xc : Integer;
begin
    Result := '';
    for xc := 1 to Length(s) do
        if s[xc] = '&' then
            Result := Result + '&&'
        else
            Result := Result + s[xc];
end;

function hColorButtonList.SingleAmpersand(s : String):String;
var
	xc : Integer;
begin
    Result := '';
    for xc := 1 to Length(s)-1 do
        if (s[xc] = '&') and (s[xc+1] = '&') then
            
        else
            Result := Result + s[xc];
end;

{$IFDEF NO_SKINS}
constructor hColorButtonList.Create(AOwner : TComponent);
begin
    inherited Create(AOwner);

    // -- Create the list to hold the buttons
    fButtons := TStringList.Create;

    fEnableRedraw := True;

    fGap := 5;
    fWidth := 50;
    fHeight := 30;

	OnMouseMove := doPanelMouseMove;

	CreateControls;

end;

destructor hColorButtonList.Destroy;
begin

    fButtons.Free;

    inherited Destroy;
end;

procedure hColorButtonList.Clear;
begin
    fButtons.Clear;
	DestroyControls;
end;

procedure hColorButtonList.BeginUpdate;
begin
	fEnableRedraw := False;
end;

procedure hColorButtonList.EndUpdate;
begin
	fEnableRedraw := True;
	CreateControls;
end;

procedure hColorButtonList.Add(aCode, aDisplayLabel : String; IsChild : Boolean);
var
    s : String;
begin
    s := aCode + ';' + aDisplayLabel;

    if IsChild then
        s := '-' + s;

	fButtons.Add(s);

	// -- Only Redraw if we are finished updating
	if fEnableRedraw then
		CreateControls;
end;

procedure hColorButtonList.SetButtonPosByCode(aCode : String; PushDown : Boolean; FireEvent : Boolean = True);
var
	xc : Integer;
	c  : TPanel;
begin
	// -- Destroy each of the controls one by one
	for xc := 1 to ControlCount do
	begin
		// -- Destroy the first control in the list
		c := TPanel(Self.Controls[xc-1]);

		// -- Change the button so that it looks right
		if (c.hint = aCode) then
		begin
			c.BevelOuter := bvRaised;
			c.Color := btnSelectColor;
		end
		else begin
			c.BevelOuter := bvLowered;
			c.Color := btnNormalColor;
		end;
	end;

end;

procedure hColorButtonList.doButtonClick(Sender : TObject);
var
	c,m : TPanel;
	xc : Integer;
begin
	m := TPanel(Sender);

	// -- Destroy each of the controls one by one
	for xc := 1 to ControlCount do
	begin
		// -- Destroy the first control in the list
		c := TPanel(Self.Controls[xc-1]);

		// -- Make the button look normal
		if (c <> m) and ((c.BevelOuter <> bvLowered) or (c.Color <> btnNormalColor)) then
		begin
			c.BevelOuter := bvLowered;
			c.Color := btnNormalColor;
		end;
	end;

	// -- Here we raise the panel
	if m.BevelOuter <> bvRaised then
	begin
		m.BevelOuter := bvRaised;
	end;

	// -- Go selected now
	m.Color := btnSelectColor;

	if Assigned(FOnButtonClick) then
		FOnButtonClick(Sender,m.Hint,m.Caption);
end;

procedure hColorButtonList.setButtons(Value : TStrings);
begin
    if fButtons.Text <> Value.Text then
    begin
        fButtons.BeginUpdate;
        try
            fButtons.Assign(Value);
        finally
            fButtons.EndUpdate;
        end;
    end;

    CreateControls;
end;

procedure hColorButtonList.CreateControls;
var
    xc 		: Integer;
    aPanel  : TPanel;
    aStr	: String;
begin
    DestroyControls;

    for xc := 1 to fButtons.Count do
    begin
        // -- Create the new control
		aPanel := TPanel.Create(Self);
        aPanel.Top := (fGap * xc) + ((xc-1) * fHeight);
        aPanel.Height := fHeight;
        aPanel.Width := Width - (5 * fGap);
        aPanel.Left := 10;
        aPanel.Parent := Self;
        aPanel.Visible := True;
        aPanel.BevelOuter := bvLowered;

		// -- Setup a few other properties
		aStr := fButtons.Strings[xc-1];
		aPanel.Hint := Parse(aStr,';,+');
		aPanel.Caption := DoubleAmpersand(Parse(aStr,';,+'));
		aPanel.OnClick := doButtonClick;
		aPanel.OnMouseMove := doButtonMouseMove;

		// -- Now assign a color
		aPanel.Color := btnNormalColor; // $00D31207;
		{
		case ((xc-1) mod 6) of
			0 : aPanel.Color := $00C4DCFD;
			1 : aPanel.Color := $00CDBBAB;
			2 : aPanel.Color := $0099E1E8;
			3 : aPanel.Color := $00DCC7F3;
			4 : aPanel.Color := $00E8FDC4;
			5 : aPanel.Color := $00C5FEFB;
			6 : aPanel.Color := $00FAD8E8;
		else
			aPanel.Color := clBlue;
		end;
		}
    end;

end;

procedure hColorButtonList.DestroyControls;
var
    c : TControl;
begin
	// -- Destroy each of the controls one by one
	while Self.ControlCount > 0 do
    begin
    	try
        	// -- Destroy the first control in the list
        	c := Self.Controls[0];
			c.Destroy;
        finally
        end;
    end;

end;

procedure hColorButtonList.setButtonHeight(newHeight : Integer);
begin
    fHeight := newHeight;
    CreateControls;
end;

procedure hColorButtonList.setButtonWidth(newWidth : Integer);
begin
    fWidth := newWidth;
    CreateControls;
end;

procedure hColorButtonList.setButtonGap(newGap : Integer);
begin
    fGap := newGap;
    CreateControls;
end;

procedure hColorButtonList.doButtonMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
	c,m : TPanel;
	xc : Integer;
begin
	m := TPanel(Sender);

	// -- Destroy each of the controls one by one
	for xc := 1 to ControlCount do
	begin
		// -- Destroy the first control in the list
		c := TPanel(Self.Controls[xc-1]);

		if (c <> m) and (c.BevelOuter <> bvLowered) then
		begin
			c.BevelOuter := bvLowered;
//			c.Color := btnNormalColor;
		end;
	end;

	// -- Here we raise the panel
	if m.BevelOuter <> bvRaised then
	begin
		m.BevelOuter := bvRaised;
	end;

end;

procedure hColorButtonList.doPanelMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
	c : TPanel;
	xc : Integer;
begin

	// -- Destroy each of the controls one by one
	for xc := 1 to ControlCount do
	begin
		// -- Destroy the first control in the list
		c := TPanel(Self.Controls[xc-1]);

		if c.BevelOuter <> bvLowered then
		begin
			c.BevelOuter := bvLowered;
//			c.Color := btnNormalColor;
		end;
	end;
end;

procedure hColorButtonList.Resize;
var
	c : TPanel;
	xc : Integer;
begin
	// -- Destroy each of the controls one by one
	for xc := 1 to ControlCount do
	begin
		// -- Resize every control in the list
		c := TPanel(Self.Controls[xc-1]);

		c.Width := Width - (5 * fGap);
	end;
end;
{$ELSE}
constructor hColorButtonList.Create(AOwner : TComponent);
begin
	inherited Create(AOwner);

	// -- Create the list to hold the buttons
	fButtons := TStringList.Create;

	fEnableRedraw := True;

	fGap := 5;
	fWidth := 50;
	fHeight := 25;

	Caption := 'Product Groups';

	CreateControls;

end;

destructor hColorButtonList.Destroy;
begin

    fButtons.Free;

    inherited Destroy;
end;

procedure hColorButtonList.Clear;
begin
    fButtons.Clear;
	DestroyControls;
end;

procedure hColorButtonList.BeginUpdate;
begin
	fEnableRedraw := False;
end;

procedure hColorButtonList.EndUpdate;
begin
	fEnableRedraw := True;
    CreateControls;
end;

procedure hColorButtonList.Add(aCode, aDisplayLabel : String; IsChild : Boolean);
var
    s : String;
begin
    s := aCode + ';' + aDisplayLabel;

    if IsChild then
        s := '-' + s;

	fButtons.Add(s);

	// -- Only Redraw if we are finished updating
	if fEnableRedraw then
		CreateControls;
end;

procedure hColorButtonList.SetButtonPosByCode(aCode : String; PushDown : Boolean; FireEvent : Boolean = True);
var
	xc,xd : Integer;
    c : TbsSkinButton;
    sb : TbsSkinScrollBox;
begin
	// -- Destroy each of the controls one by one
	for xc := 1 to ControlCount do
	begin
        if Self.Controls[xc-1] is TbsSkinScrollBox then
        begin
            sb := TbsSkinScrollBox(Self.Controls[xc-1]);

            for xd := 1 to sb.ControlCount do
            begin
        		// -- Destroy the first control in the list
        		c := TbsSkinButton(sb.Controls[xd-1]);

        		// -- Change the button so that it looks right
                if (c.hint = aCode) then
                begin
		        	c.Down := PushDown;

                    // -- Check that this button is visible
                    if Assigned(sb.VScrollBar) then
                    begin
                        if (sb.VScrollBar.Position > (c.Top+c.Height))
                       // and (sb.VScrollBar.Position then
                        then
                        begin
//                            sb.VScrollBar.Position := (c.Top-sb.VScrollBar.Position);
                        end
                        else if ((sb.VScrollBar.Position + c.Height) < c.Top) then
//                            sb.VScrollBar.Position := c.Top-sb.VScrollBar.Position;
                    end;

                    // -- Now fire the buttonclick method manually
                    if FireEvent then
                        doButtonClick(c);
                    break;
		        end;
            end;

            break;
        end;
	end;
end;

procedure hColorButtonList.doButtonClick(Sender : TObject);
var
    aButton : TbsSkinButton;
    aCheck  : TbsSkinCheckRadioBox;
begin
    if Sender is TbsSkinButton then
    begin
        aButton := TbsSkinButton(Sender);
    	if Assigned(FOnButtonClick) then
	    	FOnButtonClick(Sender,aButton.Hint,aButton.Caption);
    end
    else if Sender is TbsSkinCheckRadioBox then
    begin
        aCheck := TbsSkinCheckRadioBox(Sender);
    	if Assigned(FOnButtonClick) then
	    	FOnButtonClick(Sender,aCheck.Hint,aCheck.Caption);
    end;

end;

procedure hColorButtonList.setButtons(Value : TStrings);
begin
    if fButtons.Text <> Value.Text then
    begin
        fButtons.BeginUpdate;
        try
            fButtons.Assign(Value);
        finally
            fButtons.EndUpdate;
        end;
    end;

    CreateControls;
end;

procedure hColorButtonList.CreateControls;

    function DoubleAmpersand(s : String):String;
    var
		xc : Integer;
    begin
        Result := '';
        for xc := 1 to Length(s) do
            if s[xc] = '&' then
				Result := Result + '&&'
            else
                Result := Result + s[xc];
    end;
var
    xc,AllowedWidth : Integer;
    aPanel  : TbsSkinButton;
    aSubItem: TbsSkinCheckRadioBox;
    bsSkinScrollBox1 : TbsSkinScrollBox;
    bsSkinScrollBar1 : TbsSkinScrollBar;
    aStr	: String;
    scrolln : Boolean;
    BoxOwner : TWinControl;
    StartGap : Integer;
begin
    DestroyControls;

    AllowedWidth := Width - (4 * fGap);
    StartGap := 25;

    // -- Determine if scrolling is required
    scrolln := (fButtons.Count * fHeight) > Height;

//    scrolln := True;
    if scrolln then
    begin
        // -- Create a scrollbax
        bsSkinScrollBar1 := TbsSkinScrollBar.Create(Self);
        bsSkinScrollBar1.Parent := Self;
        bsSkinScrollBar1.ALign := alRight;
        bsSkinScrollBar1.Kind := sbVertical;
        bsSkinScrollBar1.SkinData := SkinData;
        bsSkinScrollBar1.Width := 12;
        bsSkinScrollBar1.SkinDataName := 'vscrollbar';
        bsSkinScrollBar1.SmallChange  := 10;
        bsSkinScrollBar1.LargeChange  := 50;
        bsSkinScrollBar1.Visible := True;
        bsSkinScrollBar1.ChangeSkinData;

        // -- Create the scrollbox
        bsSkinScrollBox1 := TbsSkinScrollBox.Create(Self);
        bsSkinScrollBox1.Parent := Self;
        bsSkinScrollBox1.Visible := True;
        bsSkinScrollBox1.ALign := alClient;
        bsSkinScrollBox1.SkinData := fSkinData;
        bsSkinScrollbox1.VScrollBar := bsSkinScrollBar1;

        BoxOwner := bsSkinScrollBox1;

        AllowedWidth := AllowedWidth - 12;
        StartGap := 0;
    end
    else
        boxOwner := TWinControl(Self);

    for xc := 1 to fButtons.Count do
    begin
		aStr := fButtons.Strings[xc-1];

        if aStr[1] <> '-' then
        begin
            // -- Create the new control
            aPanel := TbsSkinButton.Create(Self);
            aPanel.Top := (fGap * xc) + ((xc-1) * fHeight) + StartGap;
            aPanel.Height := fHeight;
            aPanel.Width := AllowedWidth;

            if scrolln then
                aPanel.Left := 5
            else
                aPanel.Left := 10;

            aPanel.Parent := boxOwner;
            aPanel.Visible := True;
            aPanel.GroupIndex := 67;
            aPanel.SkinData := fSkinData;

            // -- Setup a few other properties
            aPanel.Hint := Parse(aStr,';,+');
            aPanel.Caption := DoubleAmpersand(Parse(aStr,';,+'));
            aPanel.OnClick := doButtonClick;
        end
        else begin
            // -- Create the new control
            aSubItem := TbsSkinCheckRadioBox.Create(Self);
            aSubItem.Top := (fGap * xc) + ((xc-1) * fHeight) + StartGap;
            aSubItem.Height := fHeight;
            aSubItem.Width := AllowedWidth - 10;
            aSubItem.Left := 20;
            aSubItem.Parent := boxOwner;
            aSubItem.Visible := True;
            aSubItem.Radio := True;
            aSubItem.GroupIndex := 68;
            aSubItem.SkinData := fSkinData;

            // -- Setup a few other properties
            aSubItem.Hint := Parse(aStr,';,+');
            aSubItem.Caption := DoubleAmpersand(Parse(aStr,';,+'));
            aSubItem.OnClick := doButtonClick;
        end;
    end;

    if scrolln then
    begin
        bsSkinScrollBox1.ChangeSkinData;
    end;

end;

procedure hColorButtonList.DestroyControls;
var
    c : TControl;
begin
	// -- Destroy each of the controls one by one
	while Self.ControlCount > 0 do
    begin
    	try
        	// -- Destroy the first control in the list
        	c := Self.Controls[0];
			c.Destroy;
        finally
        end;
    end;

end;

procedure hColorButtonList.setButtonHeight(newHeight : Integer);
begin
    fHeight := newHeight;
    CreateControls;
end;

procedure hColorButtonList.setButtonWidth(newWidth : Integer);
begin
    fWidth := newWidth;
    CreateControls;
end;

procedure hColorButtonList.setButtonGap(newGap : Integer);
begin
    fGap := newGap;
    CreateControls;
end;

procedure hColorButtonList.Resize;
var
	c : TPanel;
	xc : Integer;
begin
	// -- Destroy each of the controls one by one
	for xc := 1 to ControlCount do
	begin
		// -- Resize every control in the list
		c := TPanel(Self.Controls[xc-1]);

		c.Width := Width - (5 * fGap);
	end;
end;

procedure hColorButtonList.SetSkinData(Value: TbsSkinData);
var
	xc : Integer;
    I: Integer;
begin
  inherited;

  fSkinData := Value;

  for I := 0 to ControlCount - 1 do
  if Controls[I] is TbsSkinControl
  then
    TbsSkinControl(Controls[I]).SkinData := fSkinData;

end;

{$ENDIF}

function hColorButtonList.GetSelectedButton:String;
var
	xc,xd : Integer;
{$IFNDEF NO_SKINS}
    c : TbsSkinButton;
    sb : TbsSkinScrollBox;
{$ENDIF}
begin
{$IFNDEF NO_SKINS}
    Result := '';

	// -- Destroy each of the controls one by one
	for xc := 1 to ControlCount do
	begin
        if Self.Controls[xc-1] is TbsSkinScrollBox then
        begin
            sb := TbsSkinScrollBox(Self.Controls[xc-1]);

            for xd := 1 to sb.ControlCount do
            begin
        		// -- Destroy the first control in the list
        		c := TbsSkinButton(sb.Controls[xd-1]);

        		// -- Change the button so that it looks right
		        if (c.Down) then
        		begin
		        	Result := SingleAmpersand(c.Caption);
                    break;
		        end;
            end;

            break;
        end;
	end;
{$ENDIF}
end;


end.
