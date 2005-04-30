unit GTDDialup;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls;

const
	WM_RASDIALEVENT = $CCCD;
type

  hDialMessageEvent = procedure(Sender: TObject; Dial_Event_Number : Integer; Dial_Event_Text : String) of object;
  hDialConnectEvent = procedure(Sender: TObject) of object;
  hDialDisconnectEvent = procedure(Sender: TObject) of object;

  hRAS = class(TCustomControl)
  private
	{ Private declarations }
	hRasConn : THandle;
	FActive  : Boolean;
	FConnected : Boolean;
	FIP_Address : String;

	FOnDialMessage : hDialMessageEvent;
	FOnConnect : hDialConnectEvent;
	FOnDisconnect : hDialDisconnectEvent;

	function HaveAConnection:Boolean;
	procedure LogMessage(s : String);

  protected
	{ Protected declarations }
  public
	{ Public declarations }

	function Dial(Connection, UserName, Password : String):Boolean;
	function Disconnect:Boolean;
	function GetPhoneBookEntries(var EntryList : TStrings):Boolean;
	function GetPhoneBookDetails(EntryName : String; Details : TStrings):Boolean;
	function RasAvailable:Boolean;

	procedure WndProc(var Msg: TMessage); override;

  published
	{ Published declarations }
	property Active: Boolean read RasAvailable;
	property Connected : Boolean read HaveAConnection;
	property IP_Address : String read FIP_Address;

	property OnDialMessage: hDialMessageEvent read FOnDialMessage write FOnDialMessage;
	property OnConnect: hDialConnectEvent read FOnConnect write FOnConnect;
	property OnDisconnect: hDialDisconnectEvent read FOnDisconnect write FOnDisconnect;

  end;

procedure Register;

implementation

{$DEFINE WINVER400}
const
	RasUnitVersion        = 110;
	rasapi32              = 'rasapi32.dll';
	altrasapi32			  = 'rnaph.dll';

	UNLEN                 = 256;    // Maximum user name length
	PWLEN                 = 256;    // Maximum password length
	CNLEN                 = 15;     // Computer name length
	DNLEN                 = CNLEN;  // Maximum domain name length

	RAS_MaxDeviceType     = 16;
	RAS_MaxPhoneNumber    = 128;
	RAS_MaxIpAddress      = 15;
	RAS_MaxIpxAddress     = 21;

{$IFDEF WINVER400}
	RAS_MaxEntryName      = 256;
	RAS_MaxDeviceName     = 128;
	RAS_MaxCallbackNumber = RAS_MaxPhoneNumber;
{$ELSE}
	RAS_MaxEntryName      = 20;
	RAS_MaxDeviceName     = 32;
	RAS_MaxCallbackNumber = 48;
{$ENDIF}

	RAS_MaxAreaCode       = 10;
	RAS_MaxPadType        = 32;
	RAS_MaxX25Address     = 200;
	RAS_MaxFacilities     = 200;
	RAS_MaxUserData       = 200;

	RASCS_OpenPort            = 0;
	RASCS_PortOpened          = 1;
	RASCS_ConnectDevice       = 2;
	RASCS_DeviceConnected     = 3;
	RASCS_AllDevicesConnected = 4;
	RASCS_Authenticate        = 5;
	RASCS_AuthNotify          = 6;
	RASCS_AuthRetry           = 7;
	RASCS_AuthCallback        = 8;
	RASCS_AuthChangePassword  = 9;
	RASCS_AuthProject         = 10;
	RASCS_AuthLinkSpeed       = 11;
	RASCS_AuthAck             = 12;
	RASCS_ReAuthenticate      = 13;
	RASCS_Authenticated       = 14;
	RASCS_PrepareForCallback  = 15;
	RASCS_WaitForModemReset   = 16;
	RASCS_WaitForCallback     = 17;
	RASCS_Projected           = 18;

{$IFDEF WINVER400}
	RASCS_StartAuthentication = 19;
	RASCS_CallbackComplete    = 20;
	RASCS_LogonNetwork        = 21;
{$ENDIF}
	RASCS_SubEntryConnected   = 22;
	RASCS_SubEntryDisconnected= 23;

	RASCS_PAUSED              = $1000;
	RASCS_Interactive         = RASCS_PAUSED;
	RASCS_RetryAuthentication = (RASCS_PAUSED + 1);
	RASCS_CallbackSetByCaller = (RASCS_PAUSED + 2);
	RASCS_PasswordExpired     = (RASCS_PAUSED + 3);

	RASCS_DONE                = $2000;
	RASCS_Connected           = RASCS_DONE;
	RASCS_Disconnected        = (RASCS_DONE + 1);

	// If using RasDial message notifications, get the notification message code
	// by passing this string to the RegisterWindowMessageA() API.
	// WM_RASDIALEVENT is used only if a unique message cannot be registered.
	RASDIALEVENT    = 'RasDialEvent';

	// TRASPROJECTION
	RASP_Amb        = $10000;
	RASP_PppNbf     = $0803F;
	RASP_PppIpx     = $0802B;
	RASP_PppIp      = $08021;
	RASP_Slip       = $20000;
type
	THRASCONN     = THandle;
	PHRASCONN     = ^THRASCONN;
	TRASCONNSTATE = DWORD;
	PDWORD        = ^DWORD;
	PBOOL         = ^BOOL;

	TRASDIALPARAMS = packed record
		dwSize           : DWORD;
		szEntryName      : array [0..RAS_MaxEntryName] of Char;
		szPhoneNumber    : array [0..RAS_MaxPhoneNumber] of Char;
		szCallbackNumber : array [0..RAS_MaxCallbackNumber] of Char;
		szUserName       : array [0..UNLEN] of Char;
		szPassword       : array [0..PWLEN] of Char;
		szDomain         : array [0..DNLEN] of Char;
{$IFDEF WINVER401}
		dwSubEntry       : DWORD;
		dwCallbackId     : DWORD;
{$ENDIF}
		szPadding        : array [0..2] of Char;
	end;
	PRASDIALPARAMS = ^TRASDIALPARAMS;

	TRASDIALEXTENSIONS = packed record
		dwSize     : DWORD;
        dwfOptions : DWORD;
		hwndParent : HWND;
        reserved   : DWORD;
    end;
	PRASDIALEXTENSIONS = ^TRASDIALEXTENSIONS;

    TRASCONNSTATUS = packed record
        dwSize       : DWORD;
        RasConnState : TRASCONNSTATE;
		dwError      : DWORD;
		szDeviceType : array [0..RAS_MaxDeviceType] of char;
		szDeviceName : array [0..RAS_MaxDeviceName] of char;
		szPadding    : array [0..1] of Char;
	end;
	PRASCONNSTATUS = ^TRASCONNSTATUS;

	TRASCONN = packed record
        dwSize       : DWORD;
        hRasConn     : THRASCONN;
		szEntryName  : array [0..RAS_MaxEntryName] of char;
{$IFDEF WINVER400}
        szDeviceType : array [0..RAS_MaxDeviceType] of char;
		szDeviceName : array [0..RAS_MaxDeviceName] of char;
{$ENDIF}
        szPadding    : array [0..0] of Char;
	end;
    PRASCONN = ^TRASCONN;

    TRASENTRYNAME = packed record
		dwSize       : DWORD;
		szEntryName  : array [0..RAS_MaxEntryName] of char;
		szPadding    : array [0..2] of Char;
	end;
	PRASENTRYNAME = ^TRASENTRYNAME;

	TRASENTRYDLG = packed record
        dwSize       : DWORD;
        hWndOwner    : HWND;
		dwFlags      : DWORD;
		xDlg         : LongInt;
		yDlg         : LongInt;
		szEntry      : array [0..RAS_MaxEntryName] of char;
		dwError      : DWORD;
		Reserved     : DWORD;
		Reserved2    : DWORD;
		szPadding    : array [0..2] of Char;
	end;
	PRASENTRYDLG = ^TRASENTRYDLG;

	TRASPROJECTION = integer;
	TRASPPPIP = record
		dwSize  : DWORD;
		dwError : DWORD;
		szIpAddress : array [0..RAS_MaxIpAddress] of char;
	end;
{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
TRasDialA =  function(RasDialExtensions: PRASDIALEXTENSIONS;
					  PhoneBook     : PChar;
					  RasDialParams : PRASDIALPARAMS;
					  NotifierType  : DWORD;
					  Notifier      : DWORD {Pointer };
					  RasConn       : PHRASCONN
					 ): DWORD; stdcall;
TRasGetErrorStringA = function(
						uErrorValue   : DWORD; // error to get string for
						szErrorString : PChar; // buffer to hold error string
						cBufSize      : DWORD	 // size, in characters, of buffer
					  ): DWORD; stdcall;
TRasHangupA = function (RasConn: THRASCONN): DWORD; stdcall;
TRasGetConnectStatusA = function (
				  hRasConn: THRASCONN;   // handle to RAS connection of interest
				  lpRasConnStatus : PRASCONNSTATUS // buffer to receive status data
				 ): DWORD; stdcall;
TRasEnumConnectionsA = function (
				  pRasConn : PRASCONN;	 // buffer to receive connections data
				  pCB      : PDWORD;	 // size in bytes of buffer
				  pcConnections : PDWORD // number of connections written to buffer
				 ) : DWORD; stdcall;
TRasEnumEntriesA = function (
				  Reserved : Pointer;	 // reserved, must be NIL
				  szPhonebook : PChar;	 // full path and filename of phonebook file
				  lpRasEntryName : PRASENTRYNAME; // buffer to receive entries
				  lpcb : PDWORD;	 // size in bytes of buffer
				  lpcEntries : PDWORD	 // number of entries written to buffer
				 ) : DWORD; stdcall;
TRasGetEntryDialParamsA = function (
				  lpszPhonebook : PChar; // pointer to the full path and filename of the phonebook file
				  lprasdialparams : PRASDIALPARAMS;	// pointer to a structure that receives the connection parameters
				  lpfPassword : PBOOL    // indicates whether the user's password was retrieved
				 ) : DWORD; stdcall;
TRasEditPhonebookEntryA = function (
				   hWndParent : HWND;     // handle to the parent window of the dialog box
				   lpszPhonebook : PChar; // pointer to the full path and filename of the phonebook file
				   lpszEntryName : PChar  // pointer to the phonebook entry name
				 ) : DWORD; stdcall;
TRasEntryDlgA = function (
				   lpszPhonebook : PChar; // pointer to the full path and filename of the phone-book file
				   lpszEntry : PChar;     // pointer to the name of the phone-book entry to edit, copy, or create
				   lpInfo : PRASENTRYDLG  // pointer to a structure that contains additional parameters
				 ) : DWORD; stdcall;
TRasCreatePhonebookEntryA = function (
					 hWndParent : HWND;    // handle to the parent window of the dialog box
					 lpszPhonebook : PChar // pointer to the full path and filename of the phonebook file
				   ) : DWORD; stdcall;

TRasGetProjectionInfoA = function (
					hRasConn      : THRASCONN;      // handle that specifies remote access connection of interest
					RasProjection : TRASPROJECTION; // specifies type of projection information to obtain
					lpProjection  : Pointer;        // points to buffer that receives projection information
					lpcb          : PDWORD          // points to variable that specifies buffer size
				   ) : DWORD; stdcall;

var
	RasDialA 					: TRasDialA;
	RasGetErrorStringA			: TRasGetErrorStringA;
	RasHangupA					: TRasHangupA;
	RasGetConnectStatusA		: TRasGetConnectStatusA;
	RasEnumConnectionsA			: TRasEnumConnectionsA;
	RasEnumEntriesA				: TRasEnumEntriesA;
	RasGetEntryDialParamsA		: TRasGetEntryDialParamsA;
	RasEditPhonebookEntryA		: TRasEditPhonebookEntryA;
	RasEntryDlgA				: TRasEntryDlgA;
	RasCreatePhonebookEntryA	: TRasCreatePhonebookEntryA;
	RasGetProjectionInfoA		: TRasGetProjectionInfoA;

	RasLibraryHandle			: THandle;
	fDUNMsg  					: Integer;

procedure Register;
begin
  RegisterComponents('Tradalogs', [hRAS]);
end;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function RasConnectionStateToString(nState : Integer) : String;
begin
	case nState of
	RASCS_OpenPort:             Result := 'Opening Port';
	RASCS_PortOpened:           Result := 'Port Opened';
	RASCS_ConnectDevice:        Result := 'Connecting to ISP';
	RASCS_DeviceConnected:      Result := 'Connected';
	RASCS_AllDevicesConnected:  Result := 'All Devices Connected';
	RASCS_Authenticate:         Result := 'Logging in to ISP';
	RASCS_AuthNotify:           Result := 'Authentication Notify';
	RASCS_AuthRetry:            Result := 'Authentication Retry';
	RASCS_AuthCallback:         Result := 'Callback Requested';
	RASCS_AuthChangePassword:   Result := 'Change Password Requested';
	RASCS_AuthProject:          Result := 'Projection Phase Started';
	RASCS_AuthLinkSpeed:        Result := 'Link Speed Calculation';
	RASCS_AuthAck:              Result := 'Authentication Acknowledged';
	RASCS_ReAuthenticate:       Result := 'Reauthentication Started';
	RASCS_Authenticated:        Result := 'Authenticated';
	RASCS_PrepareForCallback:   Result := 'Preparation For Callback';
	RASCS_WaitForModemReset:    Result := 'Waiting For Modem Reset';
	RASCS_WaitForCallback:      Result := 'Waiting For Callback';
	RASCS_Projected:            Result := 'Projected';
{$IFDEF WINVER400}
	RASCS_StartAuthentication:  Result := 'Start Authentication';
	RASCS_CallbackComplete:     Result := 'Callback Complete';
	RASCS_LogonNetwork:         Result := 'Logon Network';
{$ENDIF}
	RASCS_SubEntryConnected:    Result := '';
	RASCS_SubEntryDisconnected: Result := '';
	RASCS_Interactive:          Result := 'Interactive';
	RASCS_RetryAuthentication:  Result := 'Retry Authentication';
	RASCS_CallbackSetByCaller:  Result := 'Callback Set By Caller';
	RASCS_PasswordExpired:      Result := 'Password Expired';
	RASCS_Connected:            Result := 'Connected';
	RASCS_Disconnected:         Result := 'Disconnected';
	else
		Result := 'Connection state #' + IntToStr(nState);
	end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function RasGetIPAddress: string;
var
	RASConns   : TRasConn;
	dwSize     : DWORD;
	dwCount    : DWORD;
	RASpppIP   : TRASPPPIP;
begin
	if RasLibraryHandle = 0 then
		Exit;

	Result          := '';
	RASConns.dwSize := SizeOf(TRASConn);
	RASpppIP.dwSize := SizeOf(RASpppIP);
	dwSize          := SizeOf(RASConns);
	if RASEnumConnectionsA(@RASConns, @dwSize, @dwCount) = 0 then begin
		if dwCount > 0 then begin
			dwSize := SizeOf(RASpppIP);
			RASpppIP.dwSize := SizeOf(RASpppIP);
			if RASGetProjectionInfoA(RASConns.hRasConn,
									 RASP_PppIp,
									 @RasPPPIP,
									 @dwSize) = 0 then
				Result := StrPas(RASpppIP.szIPAddress);
	   end;
	end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{
function RasDialA; external rasapi32 name 'RasDialA';
function RasGetErrorStringA; external rasapi32 name 'RasGetErrorStringA';
function RasHangUpA; external rasapi32 name 'RasHangUpA';
function RasGetConnectStatusA; external rasapi32 name 'RasGetConnectStatusA';
function RasEnumConnectionsA; external rasapi32 name 'RasEnumConnectionsA';
function RasEnumEntriesA; external rasapi32 name 'RasEnumEntriesA';
function RasGetEntryDialParamsA; external rasapi32 name 'RasGetEntryDialParamsA';
function RasEditPhonebookEntryA; external rasapi32 name 'RasEditPhonebookEntryA';
//function RasEntryDlgA; external rasapi32 name 'RasEntryDlgA';
function RasCreatePhonebookEntryA; external rasapi32 name 'RasCreatePhonebookEntryA';
function RasGetProjectionInfoA; external rasapi32 name 'RasGetProjectionInfoA';
}
{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function RasGetUserDetails(RASEntryName : String; var UserName : String; var Passwd : String):Boolean;
var
	gotpswd			 : BOOL;
	lpType 			 : DWORD;
	rdParams 		 : TRASDIALPARAMS;
	xc		 		 : Integer;
begin
	if RasLibraryHandle = 0 then
		Exit;

	Passwd := '';
	Result := False;

	// setup RAS Dial Parameters
	FillChar(rdParams, SizeOf(rdParams), 0);
	rdParams.dwSize              := SizeOf(TRASDIALPARAMS);
	strCopy(rdParams.szUserName,  PChar(UserName));
	strCopy(rdParams.szPassword,  PChar(Passwd));
	strCopy(rdParams.szEntryName, PChar(RASEntryName));
	rdParams.szPhoneNumber[0]    := #0;
	rdParams.szCallbackNumber[0] := '*';
	rdParams.szDomain            := '*';

	// -- Go and find details on the entry
	xc := RasGetEntryDialParamsA(nil,@rdParams,@gotpswd);
	if (xc = 0) then
	begin
		UserName := rdParams.szUserName;

		// -- Write the new updated value
		if gotpswd then
			Passwd := rdParams.szPassword;

		Result := True;
	end;

end;

function hRAS.RasAvailable:Boolean;
begin
	FActive := RasLibraryHandle <> 0;
	
	Result := FActive;
end;

procedure hRAS.WndProc(var Msg: TMessage);
var
	Buf      : array [0..255] of Char;
begin
	if Msg.Msg <> fDUNMsg then
	begin
		inherited WndProc(Msg);
		Exit;
	end;

	if not RasAvailable then
		Exit;

	LogMessage(RasConnectionStateToString(Msg.wParam));
	if Msg.wParam = RASCS_Connected then begin

		FConnected := True;
		FIP_Address := RasGetIPAddress;
		LogMessage('Connected on IP ' + RasGetIPAddress);

		if Assigned(FOnConnect) then
			FOnConnect(Self);

	end
	else if Msg.wParam = RASCS_Disconnected then begin
		RasGetErrorStringA(Msg.lParam, @Buf[0], SizeOf(Buf));
		LogMessage(Buf);
		FConnected := False;
		FIP_Address := '';

		if Assigned(FOnConnect) then
			FOnDisconnect(Self);
	end
	else begin
		// -- Do nothing, we don't care about these ones
		// LogMessage('Unrecognised RAS message' + IntToStr(Msg.wParam));
	end;

end;

function hRAS.Dial(Connection, UserName, Password : String):Boolean;
var
	rdParams : TRASDIALPARAMS;
	dwRet    : DWORD;
	Buf      : array [0..255] of Char;
	s  : String;
	i		: Integer;
begin
	// -- Try to initialise RAS
	if not Active then
	begin
		Result := False;
		exit;
	end;

	// setup RAS Dial Parameters
	FillChar(rdParams, SizeOf(rdParams), 0);
	rdParams.dwSize              := SizeOf(TRASDIALPARAMS);
	strCopy(rdParams.szUserName,  PChar(UserName));
	strCopy(rdParams.szPassword,  PChar(Password));
	strCopy(rdParams.szEntryName, PChar(Connection));
	rdParams.szPhoneNumber[0]    := #0;
	rdParams.szCallbackNumber[0] := '*';
	rdParams.szDomain            := '*';

	hRasConn := 0;
	dwRet  := RasDialA(nil, nil, @rdParams, $FFFFFFFF, Self.Handle, @hRasConn);
	if dwRet <> 0 then begin
		RasGetErrorStringA(dwRet, @Buf[0], SizeOf(Buf));
		LogMessage(IntToStr(dwRet) + ' ' + Buf);
		Result := False;
	end
	else begin
		LogMessage('Dialing ''' + Connection + '''');
		Result := True;
	end;
end;

function hRAS.Disconnect:Boolean;
begin
	if Not Active then
	begin
		Result := False;
		Exit;
	end;

	// -- Disconnect
	RasHangUpA(hRasConn);
	hRasConn := 0;

	// -- Notify them
	if Assigned(FOnDisconnect) then
		FOnDisconnect(Self);

end;

function hRAS.GetPhoneBookEntries(var EntryList : TStrings):Boolean;
var
    Entries : Array[1..15] of TRASENTRYNAME;
    cb, cEntries, dwRet : DWORD;
    Buf     : Array[1..127] of char;
    I       : Integer;
begin
	if Not Active then
	begin
		Result := False;
		Exit;
	end;

    EntryList.Clear;

    // memchr(Entries, sizeof(Entries), 0);

    Entries[1].dwSize := sizeof(TRASENTRYNAME);
    cb := sizeof(Entries);
    cEntries := 0;
    dwRet := RasEnumEntriesA(nil, nil, @Entries, @cb, @cEntries);
    if (dwRet <> 0) then
    begin
    {
        RasGetErrorStringA(dwRet, Buf, sizeof(Buf));
        // LogMessage(Buf);
    }
    end;

    // -- Now add them to the list
    for I := 1 to cEntries do
    begin
        EntryList.Add(Entries[I].szEntryName);
    end;

    Result := True;
end;

function hRAS.GetPhoneBookDetails(EntryName : String; Details : TStrings):Boolean;
begin
end;

{
procedure hRAS.OnDialEvent(var aMsg : TMsg);
var
	Buf      : array [0..255] of Char;
begin
	LogMessage(RasConnectionStateToString(aMsg.wParam));
	if aMsg.wParam = RASCS_Connected then begin

		FConnected := True;
		FIP_Address := RasGetIPAddress;
		LogMessage('Connected on IP ' + RasGetIPAddress);

		if Assigned(FOnConnect) then
			FOnConnect(Self);

	end
	else if aMsg.wParam = RASCS_Disconnected then begin
		RasGetErrorStringA(aMsg.lParam, @Buf[0], SizeOf(Buf));
		LogMessage(Buf);
		FConnected := False;
		FIP_Address := '';

		if Assigned(FOnConnect) then
			FOnDisconnect(Self);
	end
	else begin
		// -- Just ignore the message for now
		LogMessage('Unrecognised RAS message' + IntToStr(Msg.wParam));
	end;

end;
}

procedure hRAS.LogMessage(s : String);
begin
	if Assigned(FOnDialMessage) then
		FOnDialMessage(Self,0,s);

end;

function hRAS.HaveAConnection:Boolean;
var
	dwRet    : DWORD;
	nCB      : DWORD;
	Buf      : array [0..255] of Char;
	aRasConn        : array [0..10] of TRASCONN;
	nRasConnCount   : DWORD;

begin
	if not Active then
	begin
		Result := False;
		Exit;
	end;

	// -- Check
	aRasConn[0].dwSize := SizeOf(aRasConn[0]);
	nCB   := SizeOf(aRasConn);
	dwRet := RasEnumConnectionsA(@aRasConn, @nCB, @nRasConnCount);
	if dwRet <> 0 then begin
		RasGetErrorStringA(dwRet, @Buf[0], SizeOf(Buf));
		LogMessage(Buf);
		nRasConnCount := 0;
	end;

	// -- Return true if we have an active RAS connection
	Result := nRasConnCount <> 0;
end;

initialization
	RasLibraryHandle := LoadLibrary(rasapi32);
	if RasLibraryHandle <> 0 then
	begin

		@RasDialA 					:= GetProcAddress(RasLibraryHandle,'RasDialA');
		@RasGetErrorStringA			:= GetProcAddress(RasLibraryHandle,'RasGetErrorStringA');
		@RasHangupA					:= GetProcAddress(RasLibraryHandle,'RasHangUpA');
		@RasGetConnectStatusA		:= GetProcAddress(RasLibraryHandle,'RasGetConnectStatusA');
		@RasEnumConnectionsA		:= GetProcAddress(RasLibraryHandle,'RasEnumConnectionsA');
		@RasEnumEntriesA			:= GetProcAddress(RasLibraryHandle,'RasEnumEntriesA');
		@RasGetEntryDialParamsA		:= GetProcAddress(RasLibraryHandle,'RasGetEntryDialParamsA');
		@RasEditPhonebookEntryA		:= GetProcAddress(RasLibraryHandle,'RasEditPhonebookEntryA');
		@RasEntryDlgA				:= GetProcAddress(RasLibraryHandle,'RasEntryDlgA');
		@RasCreatePhonebookEntryA	:= GetProcAddress(RasLibraryHandle,'RasCreatePhonebookEntryA');
		@RasGetProjectionInfoA		:= GetProcAddress(RasLibraryHandle,'RasGetProjectionInfoA');

		fDUNMsg := RegisterWindowMessageA( RASDIALEVENT );
		if (fdunMsg = 0) then
			fdunMsg := WM_RASDIALEVENT;

	end
	else begin
		// -- Support for really old RAS
		RasLibraryHandle := LoadLibrary(altrasapi32);
		if RasLibraryHandle <> 0 then
		begin
			@RasDialA 					:= GetProcAddress(RasLibraryHandle,'RasDial');
			@RasGetErrorStringA			:= GetProcAddress(RasLibraryHandle,'RasGetErrorString');
			@RasHangupA					:= GetProcAddress(RasLibraryHandle,'RasHangup');
			@RasGetConnectStatusA		:= GetProcAddress(RasLibraryHandle,'RasGetConnectStatus');
			@RasEnumConnectionsA		:= GetProcAddress(RasLibraryHandle,'RasEnumConnections');
			@RasEnumEntriesA			:= GetProcAddress(RasLibraryHandle,'RasEnumEntries');
			@RasGetEntryDialParamsA		:= GetProcAddress(RasLibraryHandle,'RasGetEntryDialParams');
			@RasEditPhonebookEntryA		:= GetProcAddress(RasLibraryHandle,'RasEditPhonebookEntry');
			@RasEntryDlgA				:= GetProcAddress(RasLibraryHandle,'RasEntryDlg');
			@RasCreatePhonebookEntryA	:= GetProcAddress(RasLibraryHandle,'RasCreatePhonebookEntry');
			@RasGetProjectionInfoA		:= GetProcAddress(RasLibraryHandle,'RasGetProjectionInfo');
		end;
	end;

finalization
	if RasLibraryHandle <> 0 then
		FreeLibrary(RasLibraryHandle);

end.
