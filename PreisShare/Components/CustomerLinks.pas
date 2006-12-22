{*_* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

Author:       David Lyon
Description:  This code is the Customer link handler code. It handles all
              incoming links from Customers.
Creation:     September 25, 2002
Version:      1.00
EMail:        http://users.swing.be/francois.piette  francois.piette@swing.be
              http://www.rtfm.be/fpiette             francois.piette@rtfm.be
              francois.piette@pophost.eunet.be
Legal issues: Copyright (C) 2002 by David Lyon
              3/1 Gannon Ave Dolls Point NSW

History:

 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
unit CustomerLinks;

{$B-}           { Enable partial boolean evaluation   }
{$T-}           { Untyped pointers                    }
{$X+}           { Enable extended syntax              }
{$IFNDEF VER80} { Not for Delphi 1                    }
    {$H+}       { Use long strings                    }
    {$J+}       { Allow typed constant to be modified }
{$ENDIF}

interface

uses
  WinTypes, WinProcs, Messages, SysUtils, Classes, WSocket, WSocketS, HttpSrv,
  GTDBizLinks, GTDBizDocs, Forms, DbTables,Mask, HCMngr, DB,
  IdBaseComponent, IdCoder, IdCoder3to4, IdCoderMIME,IdCoderUUE;

const
    TcpCmdVersion           = 100;
    CopyRight    : String   = ' Computergrid Server (c) 2002 David Lyon V1.00 ';
    LineTerm                = #13;
type
  TCustomerData = class;

  gtClientStat = (csAwaitUserID,            // Processing a login
                  csAwaitChallengeRsp,      // Waiting for the challenge response
                  csAwaitCommand,           // Waiting for a command
				  csSendingDoc,             // Sending a document
				  cdSendingAwaitRsp,        // Awaiting a response
				  csReceivingDoc,           // Receiving a document
				  csProcessingNotfcn);      // Processing a notification

  TDisplayProc = procedure (Msg : String) of object;

  // -- TCommandResponse
  //    Describes the result to a command response where it fits on a single line
  TCommandResponse = class(TObject)
  private
  public
	ResultCode      :   Integer;            // The basic value, 0=Success etc
    ResultText      :   String;             // A Text description
	ResultExtra     :   String;             // Extra text for the line as required
	ResultHTTPHdr   :   String;
    DocumentData    :   GTDBizDoc;          // Pointer to a business document
    TerminateLink   :   Boolean;            // Terminate the link after send
    LinkNotification,
    LANNotification :   String;
    NeedToRespond   :   Boolean;

	procedure Clear;
	procedure AddLinkNotification(L : String);
	procedure AddLANNotification(L : String);

  end;

  // -- TCommandHandler
  //    This class can interprete a command placed on a line and
  //    process it along with a TCustomerData link
  TCommandHandler = class(TObject)
  private
	fStatus             : gtClientStat;

	fRecvLinesExpected,
	fRecvLinesReceived	: Integer;

	TimeOutAt		    : TDateTime;

  public

	ExtraParams         : String;

	// -- These methods provide the basic functionality
	procedure ProcessLine(L : String; var Customer : TCustomerData; var Response : TCommandResponse);
	procedure ProcessLoginReq(L :String; var Customer : TCustomerData; var Response : TCommandResponse);
	procedure ProcessChallengeRsp(L :String; var Customer : TCustomerData; var Response : TCommandResponse);
	procedure ProcessNewDocumentList(L : String; var Customer : TCustomerData; var Response : TCommandResponse);
	procedure ProcessDownloadDocumentRequest(L :String; var Customer : TCustomerData; var Response : TCommandResponse);
	procedure ProcessTakeDocument(L :String; var Customer : TCustomerData; var Response : TCommandResponse);
	procedure ProcessCatalogReq(L :String; var Customer : TCustomerData; var Response : TCommandResponse);
	procedure ProcessDocumentStatusChange(L : String; var Customer : TCustomerData; var Response : TCommandResponse);
	procedure ProcessNotification(L : String; var Customer : TCustomerData; var Response : TCommandResponse);
	procedure ProcessDocumentNotification(L : String; var Customer : TCustomerData; var Response : TCommandResponse);
	procedure ProcessChatLine(L :String; var Response : TCommandResponse);
	procedure ProcessSentDocumentResponse(L : String; var Customer : TCustomerData; var Response : TCommandResponse);
	procedure ProcessRecvMessageLine(L : String; var Customer : TCustomerData; var Response : TCommandResponse);
	procedure ProcessSendImage(L :String; var Customer : TCustomerData; var Response : TCommandResponse);

  end;

  // -- TCustomerData
  //    Describes the basic data needed by any Customer link
  //    be it either a native tcp or http link.
  TCustomerData = class(TObject)
  private
	fMerchantID,
	fTraderID           : Integer;
	fTraderGTL          : String;
	fWorkingDoc         : GTDBizDoc;
	fRegistry           : GTDDocumentRegistry;
	ParamCount          : Integer;
	Param               : array [0..10] of String;
	FOnDisplay          : TDisplayProc;
//    RFC2945Challenge    : String;
	HashManager         : THashManager;
	CipherManager       : TCipherManager;
	fEncryptedLink      : Boolean;

   public
	UseDBPricelist      : Boolean;

	constructor Create;
	destructor  Destroy;

	function VerifyLoginDetails(TID,CID : Integer;  Password : String):Boolean;
	function EncodeLinkLine(L : String):String;
	function DecodeLinkLine(L : String):String;

	procedure Close; virtual;

   published
	property Trader_ID : Integer read fTraderID write fTraderID;
  end;

  TCustomerTCPLink = class(TWSocketClient)
  private
	FDebugMessages  : Boolean;
	FOnDisplay      : TDisplayProc;

	procedure Display(Msg : String);
	procedure ReturnData(Response : TCommandResponse);
  public
	RcvdLine        : String;
	ConnectTime     : TDateTime;
	fCustomer       : TCustomerData;
	fCmdHandler     : TCommandHandler;
	fCmdResponse    : TCommandResponse;
	fCmdCancelled   : Boolean;
	fUseDBPricelist : Boolean;

	constructor Create(Owner : TComponent); override;
	destructor  Destroy; override;

	property OnDisplay : TDisplayProc read FOnDisplay write FOnDisplay;
	procedure SendLine(L : String);

  end;

  { This class is used as a client class for TWSocketServer. Each time a    }
  { client connect to the server, TWSocketServer will instanciate a new     }
  { TTcpSrvClient to handle the client.                                     }
  TCustomerHTTPLink = class(THttpConnection)
  private
	procedure ReturnData(Response : TCommandResponse);
  protected
	FPostedDataBuffer   : PChar;     { Will hold dynamically allocated buffer }
	FPostedDataSize     : Integer;   { Databuffer size                        }
	FDataLen            : Integer;   { Keep track of received byte count.     }
	fCustomer           : TCustomerData;
	fCmdHandler         : TCommandHandler;
//    FRequestHeader      : TStringList;
	fCmdCancelled       : Boolean;
	FDebugMessages  : Boolean;
  public
	destructor  Destroy; override;
  end;

  { This class encapsulate all the work for a basic TCP server. It include }
  { a basic command interpreter.                                           }
  TCustomerTcpListener = class(TComponent)
  private
	WSocketServer1 : TWSocketServer;
	FPort          : String;
	FAddr          : String;
	FOnDisplay     : TDisplayProc;
	fCommunity     : gtCommunityLink;
	fLANNofifier   : GTDLANServerPoint;
	fMerchantID     : Integer;
	fUseDBPricelist: Boolean;
	fDatabaseName  : String;
	fRegistry      : GTDDocumentRegistry;

	procedure Display(Msg : String);
	procedure WSocketServer1BgException(Sender: TObject; E: Exception; var CanClose: Boolean);
	procedure WSocketServer1ClientConnect(Sender: TObject; Client: TWSocketClient; Error: Word);
	procedure WSocketServer1ClientDisconnect(Sender: TObject; Client: TWSocketClient; Error: Word);
	procedure WSocketServer1OnError(Sender: TObject);
	procedure ClientDataAvailable(Sender: TObject; Error: Word);
	procedure ProcessData(Client: TCustomerTCPLink);
	procedure ClientBgException(Sender: TObject; E: Exception; var CanClose: Boolean);
	function  GetBanner: String;
	procedure SetBanner(const Value: String);

	procedure CommunityConnect(Sender: TObject; GTL, Opcode,  Description: String);
	procedure CommunityDisconnect(Sender: TObject; GTL, Opcode,  Description: String);

	procedure HandleNewDocumentToSend(Sender: TObject; Trader_ID: Integer; GTL: String; DocumentNumber: Integer);

  public
	constructor Create(Owner : TComponent); override;
	destructor  Destroy; override;
	procedure   Start(StartLANNotifier : Boolean = True);
	procedure   Stop;
	procedure   StartCommunityServer;

	// -- These procedures are used to send notifications to connected traders
	procedure NotifyTraderHasNewDoc(Trader_ID : Integer);
	procedure NotifyTraderHasDocChg(Trader_ID : Integer);
	procedure NotifyTraderHasNewPricelist(Trader_ID : Integer);

	procedure TestPricelist(L : String);

  published
	property CommunityLink : gtCommunityLink read fCommunity write fCommunity;
	property UsePricelistInDb : Boolean read fUseDBPricelist write fUseDBPricelist;
    property DatabaseName : String read fDatabaseName write fDatabaseName;
    property MerchantID : Integer read fMerchantID write fMerchantID;
	property OnDisplay : TDisplayProc read FOnDisplay write FOnDisplay;
	{ Make Banner property available to the outside. We could make other    }
	{ TWSocket properties available.                                        }
	property Banner : String          read GetBanner  write SetBanner;
    property Port   : String          read FPort      write FPort;
    property Addr   : String          read FAddr      write FAddr;
  end;

  // -
  TCustomerHTTPListener = class(TObject)
  private
    FPort           : String;
    FAddr           : String;
    FOnDisplay      : TDisplayProc;
    HttpServer1     : THttpServer;
    FCountRequests  : Integer;
    procedure Display(Msg : String);

    procedure HttpServer1ClientConnect(Sender : TObject;Client : TObject;Error  : Word);
    procedure HttpServer1BgException(Sender: TObject; E: Exception; var CanClose: Boolean);
    procedure HttpServer1GetDocument(Sender : TObject; Client : TObject; var Flags : THttpGetFlag);
    procedure HttpServer1PostDocument(Sender : TObject; Client : TObject; var Flags : THttpGetFlag);
	procedure HttpServer1PostedData(Sender : TObject; Client : TObject; Error  : Word);

	procedure CreateVirtualDocument_time_htm(Sender : TObject; Client  : TObject; var Flags : THttpGetFlag);
	procedure CreateVirtualDocument_login_htm(Sender : TObject; Client  : TObject; var Flags : THttpGetFlag);

	procedure ProcessPostedData_CgiFrm1(Client : TCustomerHTTPLink);

	// -- These handlers process data from the http posts
	procedure ProcessHttpPostedCommand(Client : TCustomerHTTPLink);
	procedure ProcessHttpPostedDocument(Client : TCustomerHTTPLink);

	procedure ProcessHttpPostedNewDocList(Client : TCustomerHTTPLink);
	procedure ProcessHttpPostedNewStatDocList(Client : TCustomerHTTPLink);
	procedure ProcessHttpPostGetDoc(Client : TCustomerHTTPLink);
	procedure ProcessHttpPostGetDocStat(Client : TCustomerHTTPLink);
	procedure ProcessHttpPostTakeNewDoc(Client : TCustomerHTTPLink);
	procedure ProcessHttpPostChgDocStat(Client : TCustomerHTTPLink);

  public
	constructor Create; virtual;
	destructor  Destroy; override;
	procedure   Start;
	procedure   Stop;
	property OnDisplay : TDisplayProc read FOnDisplay write FOnDisplay;
  end;

implementation

const
    WEB_CGIPAGE = '/cgi-bin/web_tradalog.cgi';
    HTTP_CGIPAGE = '/cgi-bin/tradalog.cgi';

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
constructor TCustomerTcpListener.Create(Owner : TComponent);
begin
	inherited Create(Owner);
    WSocketServer1        := TWSocketServer.Create(nil);
    WSocketServer1.Banner := '%Welcome to the ComputerGrid Server v1.0';
    FPort                 := '100';
    FAddr                 := '0.0.0.0';

    // -- Setup communications to workstations on the LAN
    fLANNofifier    := GTDLANServerPoint.Create(nil);
    fLANNofifier.OnNewDocument := HandleNewDocumentToSend;

end;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
destructor  TCustomerTcpListener.Destroy;
begin
    if Assigned(WSocketServer1) then begin
        WSocketServer1.Destroy;
        WSocketServer1 := nil;
    end;
	if Assigned(fLANNofifier) then
    begin
        fLANNofifier.Destroy;
        fLANNofifier := nil;
    end;
    inherited Destroy;
end;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TCustomerTcpListener.WSocketServer1BgException(Sender: TObject;
  E: Exception; var CanClose: Boolean);
begin
    Display('Server exception occured: ' + E.ClassName + ': ' + E.Message);
    CanClose := FALSE;  { Hoping that server will still work ! }
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ This event is called each time a new client connect. We can setup our     }
{ client class to fit our needs (We use line mode and two events)           }
procedure TCustomerTcpListener.WSocketServer1ClientConnect(
	Sender : TObject;
    Client : TWSocketClient;
    Error  : Word);

    function Buildrfc2945Challenge:String;
    begin
        // -- Build a challenge - any string will do
        Result := FloatToStr(Random(10000));
    end;
begin

    // -- Initialise the new Client
    with Client as TCustomerTCPLink do begin

        // -- Setup for display of debug information if required
        OnDisplay := Self.OnDisplay;
		FDebugMessages := True;
        if FDebugMessages then
            Display('Client connecting: ' + PeerAddr);

        LineMode        := TRUE;
        LineEdit        := TRUE;
        LineEnd         := #10;
        OnDataAvailable := ClientDataAvailable;
        OnBgException   := ClientBgException;
        ConnectTime     := Now;

        // -- Setup the customer thing
		fCustomer       := TCustomerData.Create;
        fCustomer.fMerchantID := MerchantID;
        fCustomer.UseDBPricelist := UsePricelistInDb;

//        fCustomer.RFC2945Challenge:= Buildrfc2945Challenge;

    end;
end;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ This event is called each time a client disconnect. No many things to do  }
{ here. Just display a message.                                             }
procedure TCustomerTcpListener.WSocketServer1ClientDisconnect(
    Sender : TObject;
    Client : TWSocketClient;
	Error  : Word);
begin
    with Client as TCustomerTCPLink do begin
        Display('Client disconnecting: ' + PeerAddr + '   ' +
                'Duration: ' + FormatDateTime('hh:nn:ss',
                Now - ConnectTime));
    end;
end;

procedure TCustomerTcpListener.WSocketServer1OnError(Sender: TObject);
begin
    Display('Error on Listener object');
end;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TCustomerTcpListener.ClientDataAvailable(
    Sender : TObject;
    Error  : Word);
begin
    with Sender as TCustomerTCPLink do begin
        { We use line mode. We will receive complete lines }
        RcvdLine := ReceiveStr;
        { Remove trailing CR/LF }
		while (Length(RcvdLine) > 0) and
              (RcvdLine[Length(RcvdLine)] in [#13, #10]) do
            RcvdLine := Copy(RcvdLine, 1, Length(RcvdLine) - 1);
        Display('Received from ' + GetPeerAddr + ': ''' + RcvdLine + '''');
        ProcessData(Sender as TCustomerTCPLink);
    end;
end;

procedure TCustomerTcpListener.NotifyTraderHasNewDoc(Trader_ID : Integer);
var
    I   : Integer;
    AClient : TCustomerTCPLink;
    N       : String;
begin

    // -- Build the notification string
    N := RO_NOTIFICATION + EncodeStringField(GTLINK_NTFN_EVENTFIELD,GTLINK_NTFN_NEWDOC);

	// -- Look through the connnections to find the correct one
    if Trader_ID = -1 then
    begin
        // -- This is probably not required but was used in testing
        for I := WSocketServer1.ClientCount - 1 downto 0 do
		begin
            // -- Obtain the address for the client
            AClient := TCustomerTCPLink(WSocketServer1.Client[I]);

            // -- Now send them a notification
            AClient.SendLine(N);
        end;

    end
    else begin

        for I := WSocketServer1.ClientCount - 1 downto 0 do
        begin
            // -- Obtain the address for the client
            AClient := TCustomerTCPLink(WSocketServer1.Client[I]);

            if AClient.fCustomer.fTraderID = Trader_ID then
            begin
                // -- We have found the client
                AClient.SendLine(N);
                break;
            end;

		end;

	end;
end;

procedure TCustomerTcpListener.NotifyTraderHasDocChg(Trader_ID : Integer);
var
	I   : Integer;
	AClient : TCustomerTCPLink;
	N       : String;
begin

	// -- Build the notification string
	N := RO_NOTIFICATION + EncodeStringField(GTLINK_NTFN_EVENTFIELD,GTLINK_NTFN_NEWDOC);

	// -- Look through the connnections to find the correct one
	if Trader_ID = -1 then
	begin
		// -- This is probably not required but was used in testing
		for I := WSocketServer1.ClientCount - 1 downto 0 do
		begin
			// -- Obtain the address for the client
			AClient := TCustomerTCPLink(WSocketServer1.Client[I]);

			// -- Now send them a notification
			AClient.SendLine(N);
		end;

	end
	else begin

		for I := WSocketServer1.ClientCount - 1 downto 0 do
		begin
			// -- Obtain the address for the client
			AClient := TCustomerTCPLink(WSocketServer1.Client[I]);

			if AClient.fCustomer.fTraderID = Trader_ID then
			begin
				// -- We have found the client
				AClient.SendLine(N);
				break;
			end;

		end;

	end;
end;

procedure TCustomerTcpListener.NotifyTraderHasNewPricelist(Trader_ID : Integer);
var
	I   : Integer;
	AClient : TCustomerTCPLink;
	N       : String;
begin

	// -- Build the notification string
	N := RO_NOTIFICATION + EncodeStringField(GTLINK_NTFN_EVENTFIELD,GTLINK_NTFN_NEW_PRICELIST);

	// -- Look through the connnections to find the correct one
	if Trader_ID = -1 then
	begin
		// -- This is probably not required but was used in testing
		for I := WSocketServer1.ClientCount - 1 downto 0 do
		begin
			// -- Obtain the address for the client
			AClient := TCustomerTCPLink(WSocketServer1.Client[I]);

			// -- Now send them a notification
			AClient.SendLine(N);
		end;

	end
	else begin

		for I := WSocketServer1.ClientCount - 1 downto 0 do
		begin
			// -- Obtain the address for the client
			AClient := TCustomerTCPLink(WSocketServer1.Client[I]);

			if AClient.fCustomer.fTraderID = Trader_ID then
			begin
				// -- We have found the client
				AClient.SendLine(N);
				break;
			end;

		end;

	end;
end;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ Split a command line into an array of words. Use spaces or tabs as        }
{ command delimiter. Commands words have to be delimited by doubles quotes  }
{ if they include spaces or tabs.                                           }
function ParseCommandLine(
    const CmdLine     : String;
    var   ParamsArray : array of string) : Integer;
var
    Index   : Integer;
    I, J    : Integer;
begin
    I      := 1;
    Index  := Low(ParamsArray);
    while (Index <= High(ParamsArray)) and
          (I <= Length(CmdLine)) do begin
        { Skip spaces and tabs }
		while (I <= Length(CmdLine)) and (CmdLine[I] in [' ', #9]) do
            Inc(I);
        if I > Length(CmdLine) then
            break;
        { Check if quoted parameters (can have embeded spaces) }
        if CmdLine[I] = '"' then begin
            Inc(I);
            ParamsArray[Index] := '';
			while I <= Length(CmdLine) do begin
                if CmdLine[I] = '"' then begin
                    if (I >= Length(CmdLine)) or (CmdLine[I + 1] <> '"') then begin
                        Inc(I);
                        break;
                    end;
                    ParamsArray[Index] := ParamsArray[Index] + '"';
                    Inc(I, 2);
                end
                else begin
                    ParamsArray[Index] := ParamsArray[Index] + CmdLine[I];
                    Inc(I);
                end;
            end;
        end
        else begin
            J := I;
            while (I <= Length(CmdLine)) and (not (CmdLine[I] in [' ', #9])) do
                Inc(I);
			if J = I then
                break;
            ParamsArray[Index] := Copy(CmdLine, J, I - J);
        end;
		Inc(Index);
    end;
    Result := Index - Low(ParamsArray);
end;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ Process a command line received from any client. If process takes time,   }
{ you should use a thread to do the work and return immediately.            }
procedure TCustomerTcpListener.ProcessData(Client : TCustomerTCPLink);
begin
    // -- Have the client process it's own text
    Client.fCmdHandler.ProcessLine(Client.RcvdLine,Client.fCustomer,Client.fCmdResponse);
    
    Client.ReturnData(Client.fCmdResponse);

    // -- Is there a message that we need to display somewhere ?
    if Client.fCmdResponse.LANNotification <> '' then
        Display(Client.fCmdResponse.LANNotification);
        
    // -- Check and close the connection if nessessary
    if Client.fCmdResponse.TerminateLink then
        Client.CloseDelayed;
end;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ This event handler is called when a client socket experience a background }
{ exception. It is likely to occurs when client aborted connection and data }
{ has not been sent yet.                                                    }
procedure TCustomerTcpListener.ClientBgException(
    Sender       : TObject;
    E            : Exception;
    var CanClose : Boolean);
begin
    Display('Client exception occured: ' + E.ClassName + ': ' + E.Message);
    CanClose := TRUE;   { Goodbye client ! }
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TCustomerTcpListener.Display(Msg: String);
begin
    // -- If the User defined message display is provided, then use it
	if Assigned(FOnDisplay) then
		FOnDisplay(Msg);

	// -- Now send the message out on the link
	fLANNofifier.NotifyServerLogMessage('Document Sender',Msg);
end;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TCustomerTcpListener.Start(StartLANNotifier : Boolean);
begin

	// -- Attempt to connect to the Community
	if not Assigned(fCommunity) then
	begin
		fCommunity := gtCommunityLink.Create(nil);
		fCommunity.OnLinkUp   := CommunityConnect;
		fCommunity.OnLinkDown := CommunityDisconnect;

		fCommunity.LogIn(fRegistry);
	end;

	if WSocketServer1.State <> wsListening then
	begin
		// -- Set the socket up for listening
		WSocketServer1.OnBgException      := WSocketServer1BgException;
		WSocketServer1.OnClientConnect    := WSocketServer1ClientConnect;
		WSocketServer1.OnClientDisconnect := WSocketServer1ClientDisconnect;
		WSocketServer1.OnError            := WSocketServer1OnError;
		WSocketServer1.Proto              := 'tcp';
		WSocketServer1.Port               := FPort;
		WSocketServer1.Addr               := FAddr;
		WSocketServer1.ClientClass        := TCustomerTCPLink;
		WSocketServer1.Listen;

		Display('TCP Service Interface Started. Waiting for Customer Connections..');
	end;

	// -- If there are multiple servers running on
	//    the machine then this won't be started
	if StartLANNotifier then
		fLANNofifier.Start;

end;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TCustomerTcpListener.StartCommunityServer;
begin
	if WSocketServer1.State <> wsListening then
	begin
		// -- Set the socket up for listening
//		WSocketServer1.Proto              := 'tcp';
		WSocketServer1.Port               := FPort;
		WSocketServer1.Addr               := FAddr;
		WSocketServer1.ClientClass        := TCustomerTCPLink;
		WSocketServer1.OnBgException      := WSocketServer1BgException;
		WSocketServer1.OnClientConnect    := WSocketServer1ClientConnect;
		WSocketServer1.OnClientDisconnect := WSocketServer1ClientDisconnect;
		WSocketServer1.OnError            := WSocketServer1OnError;
		WSocketServer1.Listen;

		Display('TCP Service Interface Started. Waiting for Customer Connections..');
	end;

end;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TCustomerTcpListener.HandleNewDocumentToSend(Sender: TObject;
  Trader_ID: Integer; GTL: String; DocumentNumber: Integer);
begin
	// --
	NotifyTraderHasNewDoc(Trader_ID);

	Display('New Document created locally for Trader ' + IntToStr(Trader_ID));
end;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TCustomerTcpListener.CommunityConnect(Sender: TObject; GTL, Opcode,  Description: String);
begin
    Display('Connected: To Exchange');
end;
{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TCustomerTcpListener.CommunityDisconnect(Sender: TObject; GTL, Opcode,  Description: String);
begin
    Display('Disconnected:' + GTL + ' ' + Opcode + ' ' + Description);
end;
{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TCustomerTcpListener.Stop;
var
	I       : Integer;
    AClient : TCustomerTCPLink;
begin
    // -- Now close all the connections
    for I := WSocketServer1.ClientCount - 1 downto 0 do
    begin
        AClient := TCustomerTCPLink(WSocketServer1.Client[I]);

        Display('Closing connection ' + AClient.PeerAddr + ':' + AClient.GetPeerPort);
        AClient.CloseDelayed;

    end;

    // -- Disconnect from the exchange
    fCommunity.Logout;

    Display('Main Service Socket closed...');
    WSocketServer1.Close;
end;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TCustomerTcpListener.GetBanner: String;
begin
    Result := WSocketServer1.Banner;
end;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TCustomerTcpListener.SetBanner(const Value: String);
begin
    WSocketServer1.Banner := Value;
end;

constructor TCustomerData.Create;
begin
	inherited Create;

	fTraderID           := -1;
	fWorkingDoc         := nil;
	fRegistry           := nil;
	
	UseDBPricelist      := True;

	{ Problem with this code
	HashManager         := nil;
	CipherManager       := nil;
	HashManager         := THashManager.Create(Nil);
	CipherManager       := TCipherManager.Create(Nil);
	CipherManager.HashManager := HashManager;
	}
end;

destructor  TCustomerData.Destroy;
begin
	// -- Destroy these values
	if Assigned(fWorkingDoc) then
		fWorkingDoc.Destroy;
    if Assigned(fRegistry) then
        fRegistry.Destroy;

	{
	if Assigned(HashManager) then
		HashManager.Destroy;

	if Assigned(CipherManager) then
		CipherManager.Destroy;
	}
	    
    inherited Destroy;
end;
{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TCustomerTCPLink.Display(Msg: String);
begin
    if Assigned(FOnDisplay) then
        FOnDisplay(Msg);
end;
{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TCustomerTCPLink.ReturnData(Response : TCommandResponse);
var
	L : String;
	xc : Integer;
begin
	if Assigned(Response.DocumentData) then
	begin

		// -- Here we sending back each line of the message
		if Response.DocumentData.XML.Count <> 0 then
		begin
            // -- Build the transmission header
            L := RO_PROGRESS;
            L := L + EncodeIntegerField('LineCount',Response.DocumentData.XML.Count);
            SendLine(L);

			for xc := 1 to Response.DocumentData.XML.Count do
			begin
				// -- Take a line and send it
				SendLine(RO_MSGLINE + Response.DocumentData.XML[xc-1]);

				// --- Every hundred lines or so check for a cancellation
				if xc mod 100 = 0 then
				begin
					// -- Let the click on stuff
					Application.ProcessMessages;

					// -- Check for cancellations of the transfer etc
					if fCmdCancelled or Application.Terminated then
						break;
				end;

			end;
			// -- Clear out the data for next time
			Response.DocumentData.Clear;
		end;

		// -- If they cancelled, then we have to change around the response code
		if fCmdCancelled or Application.Terminated then
		begin
			// -- Change the error message
			Response.ResultCode := GTD_ERROR_USER_CANCELLED;
			Response.ResultText := GTD_MESSG_USER_CANCELLED;
		end;

    end;

    // --
    if Response.NeedToRespond then
    begin

        // -- Quite a simple command, format and send the data back on the link
        L := RO_CMDRESP + EncodeIntegerField(GTLINK_RESPONSE_CODE,Response.ResultCode) + ' ';
        L := L +          EncodeStringField(GTLINK_RESPONSE_TEXT,Response.ResultText) + Response.ResultExtra;

		// -- If we are in debug mode then we should display what we saw on the screen
		if FDebugMessages then
			Display(L);

		// -- Now send this line back to the other side
		SendLine(L);

		// -- Flush the buffer
		Flush;

	end;

end;
{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ We need to override parent class destructor because we have allocated     }
{ memory for our data buffer.                                               }
destructor TCustomerHttpLink.Destroy;
begin
    if Assigned(FPostedDataBuffer) then
    begin
        FreeMem(FPostedDataBuffer, FPostedDataSize);
        FPostedDataBuffer := nil;
        FPostedDataSize   := 0;
    end;

    if Assigned(fCustomer) then
    begin
        fCustomer.Destroy;
        fCustomer := nil;
    end;

    inherited Destroy;
end;

constructor TCustomerTCPLink.Create(Owner : TComponent);
begin
    inherited Create(Owner);

    // -- Create data for these connection elements
    fCustomer       := TCustomerData(Owner);
    fCmdHandler     := TCommandHandler.Create;
    fCmdResponse    := TCommandResponse.Create;

end;

destructor TCustomerTCPLink.Destroy;
begin
	if Assigned(fCustomer) then
	begin
		fCustomer.Destroy;
		fCustomer := nil;
	end;

	{
	if Assigned(fCmdHandler) then
	begin
		fCmdHandler.Destroy;
		fCmdHandler := nil;
	end;

	if Assigned(fCmdResponse) then
	begin
		fCmdResponse.Destroy;
		fCmdResponse := nil;
	end;
	}
	inherited Destroy;
end;

procedure TCustomerTCPLink.SendLine(L : String);
begin
    SendStr(L + LineTerm);
end;

procedure TCustomerHTTPLink.ReturnData(Response : TCommandResponse);
begin
end;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TCustomerHTTPListener.Display(Msg: String);
begin
    if Assigned(FOnDisplay) then
        FOnDisplay(Msg);
end;
{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
constructor TCustomerHTTPListener.Create;
begin
    inherited Create;
    HTTPServer1             := THTTPServer.Create(nil);
    FPort                   := '80';
    FAddr                   := '0.0.0.0';

    // -- Now initiliase our methods so that everything gets called
    HttpServer1.OnGetDocument  := HttpServer1GetDocument;
    HttpServer1.OnPostDocument := HttpServer1PostDocument;
    HttpServer1.OnPostedData   := HttpServer1PostedData;
    HttpServer1.OnClientConnect:= HttpServer1ClientConnect;
end;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
destructor  TCustomerHTTPListener.Destroy;
begin
    if Assigned(HTTPServer1) then begin
        HTTPServer1.Destroy;
        HTTPServer1:= nil;
    end;
    inherited Destroy;
end;
{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ This event is called each time a new client connect. We can setup our     }
{ client class to fit our needs (We use line mode and two events)           }
procedure TCustomerHttpListener.HttpServer1ClientConnect(
    Sender : TObject;
    Client : TObject;
    Error  : Word);
begin
    // -- Initialise the new Client
    with Client as TCustomerHTTPLink do begin
        Display('Client connecting: ' + PeerAddr);
//      OnBgException   := ClientBgException;
//      ConnectTime     := Now;
//      DisplayWriter   := fOnDisplay;

        fCustomer       := TCustomerData.Create;

    end;
end;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TCustomerHTTPListener.HTTPServer1BgException(Sender: TObject;
  E: Exception; var CanClose: Boolean);
begin
    Display('Server exception occured: ' + E.ClassName + ': ' + E.Message);
    CanClose := FALSE;  { Hoping that server will still work ! }
end;
{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TCustomerHTTPListener.Start;
begin
    HttpServer1.DocDir      := ExtractFileDir(Application.Exename) + '\Webpages';
    HttpServer1.DefaultDoc  := 'login.html';
    HttpServer1.Port        := '80';
    HttpServer1.ClientClass := TCustomerHTTPLink;
    HttpServer1.Start;

    Display('HTTP Service Interface Started. Waiting for Customer Connections..');

end;
{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TCustomerHTTPListener.Stop;
begin
    HttpServer1.Stop;
end;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ This event handler is triggered when HTTP server component receive a GET  }
{ command from any client.                                                  }
{ We count the request, display a message and trap '/time.htm' path for     }
{ special handling.                                                         }
{ There is no document time.htm on disk, we will create it on the fly. With }
{ a classic webserver we would have used a CGI or ISAPI/NSAPI to achieve    }
{ the same goal. It is much easier here since we can use Delphi code        }
{ directly to generate whatever we wants. Here for the demo we generate a   }
{ page with server data and time displayed.                                 }
procedure TCustomerHTTPListener.HttpServer1GetDocument(
    Sender    : TObject;            { HTTP server component                 }
    Client    : TObject;            { Client connection issuing command     }
    var Flags : THttpGetFlag);      { Tells what HTTP server has to do next }
begin
    { Count request and display a message }
    Inc(FCountRequests);
    Display('[' + FormatDateTime('HH:NN:SS', Now) + ' ' +
            TWSocket(Client).GetPeerAddr + '] ' + IntToStr(FCountRequests) +
            ': GET ' + TCustomerHTTPLink(Client).Path);
//  DisplayHeader(TCustomerHTTPLink(Client));

    { Trap '/time.htm' path to dynamically generate an answer. }
    if CompareText(THttpConnection(Client).Path, '/time.html') = 0 then
        CreateVirtualDocument_time_htm(Sender, Client, Flags)
    else if CompareText(THttpConnection(Client).Path, '/login.html') = 0 then
        CreateVirtualDocument_login_htm(Sender, Client, Flags);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ This procedure is use to generate /time.htm document                      }
procedure TCustomerHTTPListener.CreateVirtualDocument_time_htm(
    Sender    : TObject;            { HTTP server component                 }
    Client    : TObject;            { Client connection issuing command     }
    var Flags : THttpGetFlag);      { Tells what HTTP server has to do next }
var
    Body   : String;
    Header : String;
    Stream : TMemoryStream;
begin
    { Let HTTP server component know we will send data to client }
    Flags  := hgWillSendMySelf;
    { Create a stream to hold data sent to client that is the answer }
    { made of a HTTP header and a body made of HTML code.            }
    Stream := TMemoryStream.Create;

    Body   := '<HTML>' +
                '<HEAD>' +
                  '<TITLE>ICS WebServer Demo</TITLE>' +
                '</HEAD>' + #13#10 +
                '<BODY>' +
                  '<H2>Time at server side:</H2>' + #13#10 +
                  '<P>' + DateTimeToStr(Now) +'</P>' + #13#10 +
                  '<P>' + TCustomerHTTPLink(Client).Params + '</P>' + #13#10 +
                '</BODY>' +
              '</HTML>' + #13#10;
    Header := TCustomerHTTPLink(Client).Version + ' 200 OK' + #13#10 +
              'Content-Type: text/html' + #13#10 +
              'Content-Length: ' +
              IntToStr(Length(Body)) + #13#10 +
              #13#10;
    Stream.Write(Header[1], Length(Header));
    Stream.Write(Body[1],   Length(Body));
    { We need to seek to start of stream ! }
    Stream.Seek(0, 0);
    { We ask server component to send the stream for us. }
    TCustomerHTTPLink(Client).DocStream := Stream;
    TCustomerHTTPLink(Client).SendStream;
end;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ This procedure is use to generate /time.htm document                      }
procedure TCustomerHTTPListener.CreateVirtualDocument_login_htm(
    Sender    : TObject;            { HTTP server component                 }
    Client    : TObject;            { Client connection issuing command     }
    var Flags : THttpGetFlag);      { Tells what HTTP server has to do next }
var
    Body   : String;
    Header : String;
    Stream : TMemoryStream;
begin
    { Let HTTP server component know we will send data to client }
    Flags  := hgWillSendMySelf;
    { Create a stream to hold data sent to client that is the answer }
    { made of a HTTP header and a body made of HTML code.            }
    Stream := TMemoryStream.Create;

    Body   := '<HTML>' + #13#10 +
              '  <HEAD>' + #13#10 +
              '    <TITLE>Tradalog(tm) Document Server</TITLE>' + #13#10 +
              '   </HEAD>' + #13#10 +
              '   <BODY>' + #13#10 +
              '     <H2>Enter your Login ID and Password</H2>' + #13#10 +
              '     <FORM METHOD="POST" ACTION="' + WEB_CGIPAGE + '">' + #13#10 +
              '       <TABLE BORDER="0" ALIGN="DEFAULT" WIDTH="100%">' + #13#10 +
              '         <TR>' + #13#10 +
              '           <TD>UserID</TD>' + #13#10 +
              '           <TD><INPUT TYPE="TEXT" NAME="UserID"' + #13#10 +
              '                      MAXLENGTH="25" VALUE=""></TD>' + #13#10 +
              '         </TR>' + #13#10 +
              '         <TR>' + #13#10 +
              '           <TD>Password</TD>' + #13#10 +
              '           <TD><INPUT TYPE="TEXT" NAME="Password"' + #13#10 +
              '                      MAXLENGTH="25" VALUE=""></TD>' + #13#10 +
              '         </TR>' + #13#10 +
              '       </TABLE>' + #13#10 +
              '       <P><INPUT TYPE="SUBMIT" NAME="Submit" VALUE="Login"></P>' + #13#10 +
              '     </FORM>' + #13#10 +
              '  </BODY>' + #13#10 +
              '</HTML>' + #13#10;

    Header := TCustomerHTTPLink(Client).Version + ' 200 OK' + #13#10 +
              'Content-Type: text/html' + #13#10 +
              'Content-Length: ' +
              IntToStr(Length(Body)) + #13#10 +
              #13#10;
    Stream.Write(Header[1], Length(Header));
    Stream.Write(Body[1],   Length(Body));
    { We need to seek to start of stream ! }
    Stream.Seek(0, 0);
    { We ask server component to send the stream for us. }
    TCustomerHTTPLink(Client).DocStream := Stream;
    TCustomerHTTPLink(Client).SendStream;
end;

procedure TCustomerData.Close;
begin
    if Assigned(fWorkingDoc) then
    begin
        fWorkingDoc.Destroy;
        fWorkingDoc := nil;
    end;

    if Assigned(fRegistry) then
    begin
        fRegistry.Destroy;
        fRegistry := nil;
    end;
end;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ This event handler is triggered when HTTP server component receive a POST }
{ command from any client.                                                  }
{ We count the request, display a message and trap posted data.             }
{ To check for posted data, you may construct the following HTML document:  }
{ <HTML>                                                                    }
{   <HEAD>                                                                  }
{     <TITLE>Test Form 1</TITLE>                                            }
{   </HEAD>                                                                 }
{   <BODY>                                                                  }
{     <H2>Enter your first and last name</H2>                               }
{     <FORM METHOD="POST" ACTION="/cgi-bin/cgifrm1.exe">                    }
{       <TABLE BORDER="0" ALIGN="DEFAULT" WIDTH="100%">                     }
{         <TR>                                                              }
{           <TD>First name</TD>                                             }
{           <TD><INPUT TYPE="TEXT" NAME="FirstName"                         }
{                      MAXLENGTH="25" VALUE="YourFirstName"></TD>           }
{         </TR>                                                             }
{         <TR>                                                              }
{           <TD>Last name</TD>                                              }
{           <TD><INPUT TYPE="TEXT" NAME="LastName"                          }
{                      MAXLENGTH="25" VALUE="YourLastName"></TD>            }
{         </TR>                                                             }
{       </TABLE>                                                            }
{       <P><INPUT TYPE="SUBMIT" NAME="Submit" VALUE="Button"></P>           }
{     </FORM>                                                               }
{   </BODY>                                                                 }
{ </HTML>                                                                   }
procedure TCustomerHTTPListener.HttpServer1PostDocument(
    Sender    : TObject;            { HTTP server component                 }
    Client    : TObject;            { Client connection issuing command     }
    var Flags : THttpGetFlag);      { Tells what HTTP server has to do next }
var
    Remote      : TCustomerHTTPLink;
    CanAccept   : Boolean;
begin
    { It's easyer to do the cast one time. Could use with clause... }
    Remote := TCustomerHTTPLink(Client);

    { Count request and display a message }
    Inc(FCountRequests);
    Display(IntToStr(FCountRequests) + ': POST ' + Remote.Path + '?' + Remote.Params);
//    DisplayHeader(Remote);

    CanAccept := False;

    // -- Verify the URL that is being passed accross as the CGI
    if // (CompareText(Remote.Path, GTURL_TRADALOG_CGI) = 0) or
       (CompareText(Remote.Path, WEB_CGIPAGE) = 0) or
       (CompareText(Remote.Path, GTURL_POST_DOCUMENT) = 0) then
       // -- We can accept the data being posted
       CanAccept := True;

    { Check for request past. We only accept data for '/cgi-bin/cgifrm1.exe' }
    if CanAccept then begin
        { Tell HTTP server that we will accept posted data        }
        { OnPostedData event will be triggered when data comes in }
        Flags := hgAcceptData;
        { We wants to receive any data type. So we turn line mode off on   }
        { client connection.                                               }
        Remote.LineMode := FALSE;
        { We need a buffer to hold posted data. We allocate as much as the }
        { size of posted data plus one byte for terminating nul char.      }
        { We should check for ContentLength = 0 and handle that case...    }
{$IFDEF VER80}
        if Remote.FPostedDataSize = 0 then begin
            Remote.FPostedDataSize := Remote.RequestContentLength + 1;
            GetMem(Remote.FPostedDataBuffer, Remote.FPostedDataSize);
        end
        else begin
            ReallocMem(Remote.FPostedDataBuffer, Remote.FPostedDataSize, Remote.RequestContentLength + 1);
            Remote.FPostedDataSize := Remote.RequestContentLength + 1;
        end;
{$ELSE}
        ReallocMem(Remote.FPostedDataBuffer, Remote.RequestContentLength + 1);
{$ENDIF}
        { Clear received length }
        Remote.FDataLen := 0;
    end
    else
        Flags := hg404;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ This event handler is triggered for each data packet posted by client     }
{ when we told HTTP server component that we will accept posted data.       }
{ We have to receive ALL data which is sent by remote client, even if there }
{ is more than what ContentLength tells us !                                }
{ If ContentLength = 0, then we should receive data until connection is     }
{ closed...                                                                 }
procedure TCustomerHTTPListener.HttpServer1PostedData(
    Sender : TObject;               { HTTP server component                 }
    Client : TObject;               { Client posting data                   }
    Error  : Word);                 { Error in data receiving               }
var
    Len     : Integer;
    Remains : Integer;
    Junk    : array [0..255] of char;
    Remote  : TCustomerHTTPLink;
begin
    { It's easyer to do the cast one time. Could use with clause... }
    Remote := TCustomerHTTPLink(Client);

    { How much data do we have to receive ? }
    Remains := Remote.RequestContentLength - Remote.FDataLen;
    if Remains <= 0 then begin
        { We got all our data. Junk anything else ! }
        Len := Remote.Receive(@Junk, SizeOf(Junk) - 1);
        if Len >= 0 then
            Junk[Len] := #0;
        Exit;
    end;
    { Receive as much data as we need to receive. But warning: we may       }
    { receive much less data. Data will be split into several packets we    }
    { have to assemble in our buffer.                                       }
    Len := Remote.Receive(Remote.FPostedDataBuffer + Remote.FDataLen, Remains);
    { Sometimes, winsock doesn't wants to givve any data... }
    if Len <= 0 then
        Exit;

    { Add received length to our count }
    Inc(Remote.FDataLen, Len);
    { Add a nul terminating byte (handy to handle data as a string) }
    Remote.FPostedDataBuffer[Remote.FDataLen] := #0;
    { Display receive data so far }
    Display('Data: ''' + StrPas(Remote.FPostedDataBuffer) + '''');

    { When we received the whole thing, we can process it }
    if Remote.FDataLen = Remote.RequestContentLength then begin
        if CompareText(Remote.Path, WEB_CGIPAGE) = 0 then
            ProcessPostedData_CgiFrm1(Remote)
//        else if (CompareText(Remote.Path, GTURL_TRADALOG_CGI) = 0) then
//            ProcessHttpPostedCommand(Remote)
        else if (CompareText(Remote.Path, GTURL_POST_DOCUMENT) = 0) then
            ProcessHttpPostedDocument(Remote)
        else
            Remote.Answer404;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ This will process posted data for CgiFrm1.exe                             }
procedure TCustomerHTTPListener.ProcessPostedData_CgiFrm1(Client : TCustomerHTTPLink);
var
    Stream    : TStream;
    FileName  : String;
    Body      : String;
    Header    : String;
    UserID, Password : String;
    HostName  : String;
    Buf       : String;
begin
    { Extract fields from posted data. }
    ExtractURLEncodedValue(Client.FPostedDataBuffer, 'UserID', UserID);
    ExtractURLEncodedValue(Client.FPostedDataBuffer, 'Password',  Password);
    { Get client IP address. We could to ReverseDnsLookup to get hostname }
    HostName := Client.PeerAddr;
    { Build the record to write to data file }
    Buf      := FormatDateTime('YYYYMMDD HHNNSS ', Now) +
                UserID + '.' + Password + '@' + HostName + #13#10;

    { Save data to a text file }
    FileName := ExtractFilePath(Application.ExeName) + 'CgiFrm1.txt';
    if FileExists(FileName) then
        Stream := TFileStream.Create(FileName, fmOpenWrite)
    else
        Stream := TFileStream.Create(FileName, fmCreate);
    Stream.Seek(0, soFromEnd);
    Stream.Write(Buf[1], Length(Buf));
    Stream.Destroy;

    Stream := TMemoryStream.Create;

    // -- Now validate the user
	if Client.fCustomer.VerifyLoginDetails(1,1, Password) then
    begin
        // Now create output stream to send back to remote client
        Body   := '<HTML>' +
                    '<HEAD>' +
                      '<TITLE>Tradalog Server (tm)</TITLE>' +
                    '</HEAD>' + #13#10 +
                    '<BODY>' +
                      '<H2>Your login was successful:</H2>' + #13#10 +
                      '<H3>' + Client.fCustomer.fRegistry.Trader_Name + '</H3>' + #13#10 +
                      '<P>' + UserID + '.' + Password + '@' + HostName +'</P>' +

                    '</BODY>' +
                  '</HTML>' + #13#10;



        Header := Client.Version + ' 200 OK' + #13#10 +
                  'Content-Type: text/html' + #13#10 +
                  'Content-Length: ' + IntToStr(Length(Body)) + #13#10 +
                  #13#10;
    end
    else begin
        // Now create output stream to send back to remote client
        Body   := '<HTML>' +
                    '<HEAD>' +
                      '<TITLE>Tradalog Server (tm)</TITLE>' +
                    '</HEAD>' + #13#10 +
                    '<BODY>' +
                      '<H2>Your login was not successful:</H2>' + #13#10 +
                      '<P>' + UserID + '.' + Password + '@' + HostName +'</P>' +
                    '</BODY>' +
                  '</HTML>' + #13#10;
        Header := Client.Version + ' 200 OK' + #13#10 +
                  'Content-Type: text/html' + #13#10 +
                  'Content-Length: ' + IntToStr(Length(Body)) + #13#10 +
                  #13#10;

    end;

    Stream.Write(Header[1], Length(Header));
    Stream.Write(Body[1],   Length(Body));
    Stream.Seek(0, 0);
    { Ask HTTP server component to send data stream for us }
    Client.DocStream := Stream;
    Client.SendStream;
end;

// -- This procedure encrypts a line of data
function TCustomerData.EncodeLinkLine(L : String):String;
begin
	Result := CipherManager.EncodeString(L);
end;
// -- This procedure decrypts a line of data
function TCustomerData.DecodeLinkLine(L : String):String;
begin
	Result := CipherManager.DecodeString(L);
end;

function TCustomerData.VerifyLoginDetails(TID,CID : Integer;  Password : String):Boolean;
var
	pwd : String;
	mCID : Integer;
begin
	try
		Result := False;

		if not Assigned(fRegistry) then
		begin
			// -- Create the registry and working document
			fRegistry := GTDDocumentRegistry.Create(nil);
			fWorkingDoc := GTDBizDoc.Create(nil);
		end;

		fTraderID := TID;

		// -- Now try to open the registry for that trader
		if fRegistry.OpenForTraderNumber(TID) then
		begin
			if fRegistry.GetCustomerAccessInfo(TID,CID,pwd) then
			begin
				// doesn't work not sure why
//				if (pwd = Password) and (mCID=CID) then
					Result := True;
			end
			else
				Result := False;

		end;

		{
		if Password <> '' then
		begin
			fEncryptedLink := True;

			if fEncryptedLink then
				CipherManager.InitKey(Password,nil);
		end;
		}
	except

	end;
end;

procedure TCustomerHTTPListener.ProcessHttpPostedDocument(Client : TCustomerHTTPLink);
var
	Stream    : TStream;
	FileName  : String;
	Body      : String;
	Header    : String;
    UserID, Password, TraderID,Command  : String;
    myCmdHndlr: TCommandHandler;
    Response: TCommandResponse;
    L : String;
    xc : Integer;

    procedure SendLine(S : String);
    begin
        if Client.fCustomer.fEncryptedLink then
            // -- Send an encrypted body line
            Body := Body + '[' + Client.fCustomer.EncodeLinkLine(s) + ']' + #13#10
        else
            // -- Nonencrypted body line
            Body := Body + S + #13#10;
    end;

begin
        // -- Now validate the user
		myCmdHndlr := TCommandHandler.Create;
        Response := TCommandResponse.Create;

        // -- Change the status to indicate that we have logged in ok
        myCmdHndlr.fStatus := csAwaitCommand;

            Body   := '<HTML>' +
                            '<HEAD>' +
                              '<TITLE>Tradalog Server (tm)</TITLE>' +
                            '</HEAD>' + #13#10 +
                            '<BODY>' +
                              '<H3>Document Received</H3>' + #13#10;
            Body := Body + '</BODY>' +
                          '</HTML>' + #13#10;


        // --
        if Response.NeedToRespond then
        begin

            // -- Quite a simple command, format and send the data back on the link
            L := RO_CMDRESP + EncodeIntegerField(GTLINK_RESPONSE_CODE,Response.ResultCode) + ' ';
            L := L +          EncodeStringField(GTLINK_RESPONSE_TEXT,Response.ResultText) + Response.ResultExtra;

            // -- Now send this line back to the other side
            SendLine(L);

			// -- Flush the buffer
//            Flush;

        end;

   // -- Destroy these objects
        myCmdHndlr.Destroy;
        Response.Destroy;

    // -- Build the Header
    Header := Client.Version + ' 200 OK' + #13#10 +
                  'Content-Type: application/tradalog' + #13#10 +
                  'Content-Length: ' + IntToStr(Length(Body)) + #13#10 +
                  GTHTTP_EXTRAHDR + IntToStr(4058372) + #13#10 +
                  #13#10;

    Stream := TMemoryStream.Create;
    Stream.Write(Header[1], Length(Header));
    Stream.Write(Body[1],   Length(Body));
    Stream.Seek(0, 0);

    { Ask HTTP server component to send data stream for us }
    Client.DocStream := Stream;
    Client.SendStream;
end;

procedure TCustomerHTTPListener.ProcessHttpPostedCommand(Client : TCustomerHTTPLink);
var
    Stream    : TStream;
    FileName  : String;
    Body      : String;
    Header    : String;
    UserID, Password, TraderID,Command,xt  : String;
    myCmdHndlr: TCommandHandler;
    Response: TCommandResponse;
    L : String;
    xc : Integer;

    procedure SendLine(S : String);
    begin
        if Client.fCustomer.fEncryptedLink then
            // -- Send an encrypted body line
            Body := Body + '[' + Client.fCustomer.EncodeLinkLine(s) + ']' + #13#10
        else
            // -- Nonencrypted body line
            Body := Body + S + #13#10;
    end;

begin
    // -- Decode the URL
    L := UrlDecode(TCustomerHTTPLink(Client).Params);

    // -- Extract fields from posted data.
    ExtractURLEncodedValue(PChar(TCustomerHTTPLink(Client).Params), 'Trader_ID', TraderID);
	ExtractURLEncodedValue(Client.FPostedDataBuffer, 'UserID', UserID);
    ExtractURLEncodedValue(Client.FPostedDataBuffer, 'Password',  Password);

    if ExtractURLEncodedValue(PChar(L), 'Command',  Command) then
        Display('Processing Command '+ Command)
    else
        Display('Unable to decode Command '+ L);

    // -- First validate the users details
	if not Client.fCustomer.VerifyLoginDetails(1,1, Password) then
    begin
        // -- Build a response that tells them that it didn't work
        Body   := '<HTML>' +
                        '<HEAD>' +
                          '<TITLE>Tradalog Server (tm)</TITLE>' +
                        '</HEAD>' + #13#10 +
                        '<BODY>' +
                          '<H3>Login unsuccessful</H3>' + #13#10;
        Body := Body + '</BODY>' +
                      '</HTML>' + #13#10;

    end;

        // -- Now validate the user
        myCmdHndlr := TCommandHandler.Create;
        Response := TCommandResponse.Create;

		// -- Change the status to indicate that we have logged in ok
        myCmdHndlr.fStatus := csAwaitCommand;

        // -- Stuff that couldn't go in the command line goes in one of the headers
        myCmdHndlr.ExtraParams := Client.RequestReferer;

        // -- Load the string into memory
        if Client.FPostedDataSize <> 0 then
        begin
            xt := String(Client.FPostedDataBuffer);

            Client.fCustomer.fWorkingDoc.XML.Text := xt;
        end;

        myCmdHndlr.ProcessLine(Command, Client.fCustomer, Response);

        // -- If they provided a document to send back, send it back
        if Assigned(Response.DocumentData) then
        begin

            // -- Build the transmission header
            L := RO_PROGRESS;
            L := L + EncodeIntegerField('LineCount',Response.DocumentData.XML.Count);
            SendLine(L);

            // -- Here we sending back each line of the message
            for xc := 1 to Response.DocumentData.XML.Count do
			begin

                // -- Take a line and send it
                SendLine(RO_MSGLINE + Response.DocumentData.XML[xc-1]);

                // --- Every hundred lines or so check for a cancellation
                if xc mod 100 = 0 then
                begin
                    // -- Let the click on stuff
                    Application.ProcessMessages;

                    // -- Check for cancellations of the transfer etc
                    if { fCmdCancelled or } Application.Terminated then
                        break;
                end;

            end;

            // -- If they cancelled, then we have to change around the response code
            if { fCmdCancelled or } Application.Terminated then
            begin
                // -- Change the error message
                Response.ResultCode := GTD_ERROR_USER_CANCELLED;
                Response.ResultText := GTD_MESSG_USER_CANCELLED;
            end;

        end else
		begin
            Body   := '<HTML>' +
                            '<HEAD>' +
                              '<TITLE>Tradalog Server (tm)</TITLE>' +
                            '</HEAD>' + #13#10 +
                            '<BODY>' +
                              '<H3>Nothing to do</H3>' + #13#10;
            Body := Body + '</BODY>' +
                          '</HTML>' + #13#10;

        end;

        // --
        if Response.NeedToRespond then
        begin

            // -- Quite a simple command, format and send the data back on the link
            L := RO_CMDRESP + EncodeIntegerField(GTLINK_RESPONSE_CODE,Response.ResultCode) + ' ';
            L := L +          EncodeStringField(GTLINK_RESPONSE_TEXT,Response.ResultText) + Response.ResultExtra;


            // -- If we are in debug mode then we should display what we saw on the screen
//            if FDebugMessages then
//                Display(L);

            // -- Now send this line back to the other side
            SendLine(L);

            // -- Flush the buffer
//            Flush;

        end;

        xt := Response.ResultHTTPHdr;


    // -- Build a custom Header that can be read by the other end
    Header := Client.Version + ' 200 OK' + #13#10 +
              'Content-Type: application/tradalog' + #13#10 +
              GTLINK_RESPONSE_CODE + ': ' + IntToStr(Response.ResultCode) + #13#10 +
              GTLINK_RESPONSE_TEXT + ': ' + Response.ResultText + #13#10 +
              GTHTTP_EXTRAHDR + Response.ResultExtra + #13#10 +
              'Content-Length: ' + IntToStr(Length(Body)) + #13#10
              + #13#10;

    Stream := TMemoryStream.Create;
    Stream.Write(Header[1], Length(Header));
    Stream.Write(Body[1],   Length(Body));
    Stream.Seek(0, 0);

    { Ask HTTP server component to send data stream for us }
    Client.DocStream := Stream;
    Client.SendStream;

	// -- Destroy these objects
    myCmdHndlr.Destroy;
    Response.Destroy;

end;

procedure TCustomerHTTPListener.ProcessHttpPostedNewDocList(Client : TCustomerHTTPLink);
var
    Stream    : TStream;
    FileName  : String;
    Body      : String;
    Header    : String;
    UserID, Password, TraderID  : String;
begin
    { Extract fields from posted data. }
    ExtractURLEncodedValue(Client.FPostedDataBuffer, 'Trader_ID', TraderID);
    ExtractURLEncodedValue(Client.FPostedDataBuffer, 'UserID', UserID);
    ExtractURLEncodedValue(Client.FPostedDataBuffer, 'Password',  Password);

    // -- Now validate the user
	if Client.fCustomer.VerifyLoginDetails(1,1, Password) then
    begin
        if TraderID <> '' then
        begin

            Body   := '<HTML>' +
                            '<HEAD>' +
							  '<TITLE>Tradalog Server (tm)</TITLE>' +
                            '</HEAD>' + #13#10 +
                            '<BODY>' +
                              '<H2>Your document list is as follows:</H2>' + #13#10;
            Body := Body + '</BODY>' +
                          '</HTML>' + #13#10;
        end
        else begin
            Body   := '<HTML>' +
                            '<HEAD>' +
                              '<TITLE>Tradalog Server (tm)</TITLE>' +
                            '</HEAD>' + #13#10 +
                            '<BODY>' +
                              '<H2>No Documents</H2>' + #13#10;
            Body := Body + '</BODY>' +
                          '</HTML>' + #13#10;

        end;
    end
    else begin
            Body   := '<HTML>' +
                            '<HEAD>' +
                              '<TITLE>Tradalog Server (tm)</TITLE>' +
                            '</HEAD>' + #13#10 +
                            '<BODY>' +
                              '<H3>No Documents</H3>' + #13#10;
            Body := Body + '</BODY>' +
						  '</HTML>' + #13#10;
    end;

    // -- Build the Header
    Header := Client.Version + ' 200 OK' + #13#10 +
                  'Content-Type: text/html' + #13#10 +
                  'Content-Length: ' + IntToStr(Length(Body)) + #13#10 +
                  #13#10;

    Stream := TMemoryStream.Create;
    Stream.Write(Header[1], Length(Header));
    Stream.Write(Body[1],   Length(Body));
    Stream.Seek(0, 0);

    { Ask HTTP server component to send data stream for us }
    Client.DocStream := Stream;
    Client.SendStream;

end;

procedure TCustomerHTTPListener.ProcessHttpPostedNewStatDocList(Client : TCustomerHTTPLink);
begin
end;

procedure TCustomerHTTPListener.ProcessHttpPostGetDoc(Client : TCustomerHTTPLink);
var
    Stream    : TStream;
	FileName  : String;
    Body      : String;
    Header    : String;
    DocID     : String;
begin
    Stream := TMemoryStream.Create;

    ExtractURLEncodedValue(Client.FPostedDataBuffer, 'Document_ID', DocID);

        Body   := '<HTML>' +
                    '<HEAD>' +
                      '<TITLE>Tradalog Server (tm)</TITLE>' +
                    '</HEAD>' + #13#10 +
                    '<BODY>' +
                      '<H2>Your document was found:</H2>' + #13#10 +
                      '<P>' + DocID + '</P>' +
                    '</BODY>' +
                  '</HTML>' + #13#10;
        Header := Client.Version + ' 200 OK' + #13#10 +
                  'Content-Type: text/html' + #13#10 +
                  'Content-Length: ' + IntToStr(Length(Body)) + #13#10 +
                  #13#10;

    Stream.Write(Header[1], Length(Header));
    Stream.Write(Body[1],   Length(Body));
    Stream.Seek(0, 0);

	{ Ask HTTP server component to send data stream for us }
    Client.DocStream := Stream;
    Client.SendStream;
end;

procedure TCustomerHTTPListener.ProcessHttpPostGetDocStat(Client : TCustomerHTTPLink);
begin
end;

procedure TCustomerHTTPListener.ProcessHttpPostTakeNewDoc(Client : TCustomerHTTPLink);
var
    Stream    : TStream;
    FileName  : String;
    Body      : String;
    Header    : String;
    DocID     : String;
begin
    Stream := TMemoryStream.Create;

//    ExtractURLEncodedValue(Client.FPostedDataBuffer, 'Document_ID', DocID);

    DocID := 'Fred';

        Body   := '<HTML>' +
                    '<HEAD>' +
                      '<TITLE>Tradalog Server (tm)</TITLE>' +
                    '</HEAD>' + #13#10 +
					'<BODY>' +
                      '<H2>Your document has been posted:</H2>' + #13#10 +
                      '<P>' + DocID + '</P>' +
                    '</BODY>' +
                  '</HTML>' + #13#10;
        Header := Client.Version + ' 200 OK' + #13#10 +
                  'Content-Type: text/html' + #13#10 +
                  'Content-Length: ' + IntToStr(Length(Body)) + #13#10 +
                  #13#10;

    Stream.Write(Header[1], Length(Header));
    Stream.Write(Body[1],   Length(Body));
    Stream.Seek(0, 0);

    { Ask HTTP server component to send data stream for us }
    Client.DocStream := Stream;
    Client.SendStream;
end;

procedure TCustomerHTTPListener.ProcessHttpPostChgDocStat(Client : TCustomerHTTPLink);
begin
end;

//---------------------------------------------------------------------------
procedure TCommandHandler.ProcessLine(L : String; var Customer : TCustomerData; var Response : TCommandResponse);
var
    I       : Integer;
	cmd     : String;
begin

    // -- If we are waiting for a userid
    if fStatus = csAwaitUserID then
    begin
        ProcessLoginReq(L,Customer,Response);
        Exit;
    end;

    if Length(L)=0 then
    begin
        Response.ResultCode := GTD_ERROR_NOT_IMPLEMENTED;
		Response.ResultText := GTD_MESSG_NOT_IMPLEMENTED;
		Exit;
	end;

	// -- First thing we need to do is check for notification events
	if L[1] = RO_NOTIFICATION then
		// -- A Notification of some sort
		ProcessNotification(L,Customer,Response)
	else if L[1] = RO_DOCSTATCHG then
		// -- A Document status notification
		ProcessDocumentNotification(L, Customer, Response)
	else if L[1] = RO_CHATLINE then
		// -- A Chat line
		ProcessChatLine(L, Response)
	else begin
		// -- Look for a command response
		if (fStatus = csSendingDoc) and (L[1] = RO_CMDRESP) then
		begin

			// --- Process the command response
			ProcessSentDocumentResponse(L, Customer, Response);

		end
		else if (fStatus = csReceivingDoc) and (L[1] = RO_MSGLINE) then

			// -- Process the line
			ProcessRecvMessageLine(L, Customer,Response)

		else begin

			// -- Clear the response
			Response.Clear;

			// -- Extract the command
			cmd := Parse(L,' ');

			if cmd = GTLINK_COMMAND_LOGIN then
				ProcessLoginReq(L,Customer,Response)
			else if cmd = GTLINK_COMMAND_CATALOG then
				ProcessCatalogReq(L,Customer,Response)
			else if cmd = GTLINK_COMMAND_OPENCHAT then
				// -- 'open_chat';
			else if cmd = GTLINK_COMMAND_CLOSECHAT then
				// -- 'close_chat';
			else if cmd = GTLINK_COMMAND_LISTNEWDOCS then
				// -- List new documents on the server;
				ProcessNewDocumentList(L, Customer, Response)
			else if cmd = GTLINK_COMMAND_SENDDOC then
				// -- Send a particular document
				ProcessDownloadDocumentRequest(L, Customer, Response)
			else if cmd = GTLINK_COMMAND_CHG_STATUS then
				ProcessDocumentStatusChange(L, Customer, Response)
			else if cmd = GTLINK_COMMAND_TAKE then
				ProcessTakeDocument(L, Customer, Response)
			else if cmd = GTLINK_COMMAND_SENDIMAGE then
				ProcessSendImage(L, Customer,Response)
			else if cmd = 'quit' then
				Response.TerminateLink := True
			else begin
				// -- Unknown command
				Response.ResultCode := GTD_ERROR_NOT_IMPLEMENTED;
				Response.ResultText := GTD_MESSG_NOT_IMPLEMENTED;
			end;

            {
    procedure ProcessLoginReq(L :String; var Customer : TCustomerData; var Response : TCommandResponse);
    procedure ProcessChallengeRsp(L :String; var Customer : TCustomerData; var Response : TCommandResponse);
    procedure ProcessUploadDocumentRequest(L :String; var Customer : TCustomerData; var Response : TCommandResponse);
    procedure ProcessNotification(L : String; var Customer : TCustomerData; var Response : TCommandResponse);
    procedure ProcessDocumentNotification(L : String; var Customer : TCustomerData; var Response : TCommandResponse);
	procedure ProcessChatLine(L :String; var Response : TCommandResponse);
}

            {
                // Send client list to client
                //
                SendStr('There are ' + IntToStr(WSocketServer1.ClientCount) +
                               ' connected users:' + #13#10);
                for I := WSocketServer1.ClientCount - 1 downto 0 do begin
                    AClient := TTcpSrvClient(WSocketServer1.Client[I]);
                    SendStr(AClient.PeerAddr + ':' + AClient.GetPeerPort + ' ' +
                                   DateTimeToStr(AClient.ConnectTime) + #13#10);
                end;
                //
			}
		end;
	end;

end;
//---------------------------------------------------------------------------
procedure TCommandHandler.ProcessLoginReq(L :String; var Customer : TCustomerData; var Response : TCommandResponse);
var
	passed_gtl,  passed_ph : String;
	tid,passed_cid,t : Integer;
	myNode : GTDNode;
begin
	Response.Clear;

	myNode := GTDNode.Create;
	myNode.UseSingleLine(L);

	if not Assigned(Customer.fRegistry) then
	begin
		// -- Create the registry and working document
		Customer.fRegistry := GTDDocumentRegistry.Create(nil);
		Customer.fWorkingDoc := GTDBizDoc.Create(nil);
	end;

	// -- First extract out the login id
	tid                 := myNode.ReadIntegerField(GTD_LGN_ELE_TRADER_ID,-1);
	passed_gtl          := myNode.ReadStringField(GTD_LGN_ELE_COMPANY_CODE);
	passed_cid          := myNode.ReadIntegerField(GTD_LGN_ELE_USER_NAME,-1);
	passed_ph           := myNode.ReadStringField(GTD_LGN_ELE_PWORD);

	if (tid = -1) then
	begin
		// --If this is a new customer, send back their connection id
		if Customer.fRegistry.ProcessAutoSubscribe(L,tid,passed_cid) then
			Response.ResultExtra := EncodeIntegerField(GTD_LGN_ELE_CONNECTION_ID,passed_cid);
	end;

	myNode.Destroy;

	// -- Verify that the login details are all ok and if they are continue on
	if Customer.VerifyLoginDetails(tid,passed_cid,passed_ph) then
	begin
		Response.ResultText := 'Your login was successful';

		// -- Change to the correct state
		fStatus := csAwaitCommand;
	end
	else begin
		// -- The login was not successful so terminate the connection now
		Response.ResultCode := 500;
		Response.ResultText := 'Access Denied';
		Response.TerminateLink := True;
	end;


end;
//---------------------------------------------------------------------------
procedure TCommandHandler.ProcessChallengeRsp(L :String; var Customer : TCustomerData; var Response : TCommandResponse);
begin
	Response.Clear;
end;
//---------------------------------------------------------------------------
procedure TCommandHandler.ProcessNewDocumentList(L : String; var Customer : TCustomerData; var Response : TCommandResponse);
var
	dl,dn,ll  :   String;
    dc  :   Integer;
begin
    Response.Clear;

    // -- Here we need to go off and build a new download list and send it
    dl := Customer.fRegistry.GetNewDocumentNumbers(dc);

    dl := EncodeStringField(GTDOCLST_NEW_DOCLIST,dl);
    dl := dl + ' ' + EncodeIntegerField(GTDOCLST_NEW_DOCCOUNT,dc);

	if dc = 0 then
    begin
        // -- No documents were found
        Response.ResultCode := 100;
        Response.ResultText := 'No Documents to send';
    end
	else begin
        // -- These are the documents to download
        Response.ResultText := IntToStr(dc) + ' new documents';
        Response.ResultExtra := dl;
    end;

    // -- In this command we also notify of updated documents
    dl := Customer.fRegistry.GetUpdatedDocumentNumbers(True);
	while dl <> '' do
    begin

        // -- Extract the next document number
		dn := Parse(dl,GTD_DOC_LIST_SEPERATOR);

        // -- Now build the notification
        ll := RO_DOCSTATCHG + EncodeStringField(GTLINK_NTFN_EVENTFIELD,GTLINK_NTFN_DOCSTATUSCHG);
        ll := ll + ' ' + EncodeStringField(GTDOCUPD_NTFN_DOCID,dn);

        Response.AddLinkNotification(ll);

	end;

end;
//---------------------------------------------------------------------------
procedure TCommandHandler.ProcessDownloadDocumentRequest(L :String; var Customer : TCustomerData; var Response : TCommandResponse);
var
    s : String;
	xc, xd, dno : Integer;
    docLoaded   : Boolean;
begin
    DocLoaded := False;
    Response.Clear;

    // -- Read the parameter which is the document number
    dno := StrToInt(L);

    // -- Use the working document in the customer area
	Response.DocumentData := Customer.fWorkingDoc;

	try
		// -- Attempt to Load the document
		if Customer.fRegistry.Load(dno,Response.DocumentData) then
        begin

            // -- Load in the extra document data
            // -- At the end of the transmission, we have to send along the
            //    data neccessary to store it at the other side
			Response.ResultExtra := Customer.fRegistry.ExtractDocDetails(Customer.fWorkingDoc);

            // -- We loaded up the document ok
            docLoaded := True;

            // -- Sending the document
            fStatus := csSendingDoc;

        end;

    except
    end;

    if not DocLoaded then
    begin
        // -- Report an error if the document wasn't found
        Response.ResultCode := 150;
        Response.ResultText := 'Document not found';
        Response.DocumentData := nil;
    end;

end;
//---------------------------------------------------------------------------
procedure TCommandHandler.ProcessTakeDocument(L :String; var Customer : TCustomerData; var Response : TCommandResponse);

var
	markA               : HECMLMarker;
begin
	// --
	Response.Clear;

	// -- Some initial error checking
	if not Assigned(Customer.fRegistry) then
	begin
		// -- We don't handle receiving documents yet
		Response.ResultCode := GTD_ERROR_NOT_IMPLEMENTED;
		Response.ResultText := GTD_MESSG_NOT_IMPLEMENTED;
		Exit;
	end;

	try
		// -- Create a marker to read details
		markA := HECMLMarker.Create;

		if ExtraParams <> '' then
		begin
			// -- We've been given a http header
			L := ExtraParams;
		end;

		markA.UseSingleLine(L);

		// -- Save the pricelist to the document registry
		if Assigned(Customer.fRegistry) then
		begin

            // -- Clear the document
            Customer.fWorkingDoc.Clear;
            Customer.fWorkingDoc.Shared_With := 0;
            Customer.fWorkingDoc.Owned_By := Customer.Trader_ID;

			// -- Extract the document number and write that back to
			//    the database.
			Customer.fWorkingDoc.UpdateCurrentDocStatus(markA,True);

			// -- Hardwire this for the moment
			if Customer.fWorkingDoc.Remote_Status_Code = 'Not Sent' then
				Customer.fWorkingDoc.Remote_Status_Code := 'Sent';

            {
			// -- Save the docxument in the registry
			Customer.fRegistry.Save(Customer.fWorkingDoc,GTD_AUDITCD_RCV,GTD_AUDITDS_RCV,True);

			// -- Extract document posiion information now
			l := Customer.fRegistry.ExtractDocDetails(Customer.fWorkingDoc);

			// -- Put together a response
			Response.ResultCode := 0;
			Response.ResultText := GTD_AUDITDS_RCV;
			Response.ResultExtra:= GTHTTP_EXTRAHDR + l;
            }

            Response.NeedToRespond := False;

		end;

		fRecvLinesExpected  := MarkA.ReadIntegerField('Body_Line_Count',0);
		fRecvLinesReceived	:= 0;

		fStatus := csReceivingDoc;

	finally
		markA.Destroy;
	end;

end;
//---------------------------------------------------------------------------
procedure TCommandHandler.ProcessCatalogReq(L :String; var Customer : TCustomerData; var Response : TCommandResponse);
var
	markA  : HECMLMarker;
	plfn,s,plsendtype : String;
	haveNewPricelist : Boolean;
	ourplDate,plDate : TDateTime;
	xc,y,pf : Integer;
	plfind_qry, patch_qry : TQuery;
	aMemo : TMemoField;
	aSL : TStringList;
begin

	Response.Clear;

	markA      := HECMLMarker.Create;
	plfind_qry := TQuery.Create(Customer.fRegistry);
	patch_qry  := TQuery.Create(Customer.fRegistry);
	aSL        := TStringList.Create;

	// -- Our response has everything that we need in it
	markA.UseSingleLine(L);

	plDate := markA.ReadDateTimeField('DateStamp',0);

	// -- BODGY ALERT - ONLY APPLIES TO HTTP
    {
	y := Pos('GTL=',L);
	if (y <> 0) then
	begin
		s := Copy(L,y+4,Length(L)-y-3);
		plfn := s + GTD_PRICELIST_EXT;
	end;
    }

	if Customer.UseDBPricelist and (Customer.fMerchantID <> -1) then
	begin

		with plfind_qry do
		begin

			DatabaseName := GTD_ALIAS;

			// GTD_PRICELIST_PATCH_TYPE

			// -- First look in the document table for the pricelist
			SQL.Clear;
			SQL.Add('select');
			SQL.Add('	*');
			SQL.Add('from');
			SQL.Add('	Trader_Documents');
			SQL.Add('where');
			SQL.Add('	document_name="'+GTD_PRICELIST_TYPE+'"');
			SQL.Add('	and (owned_by=' + IntToStr(Customer.fMerchantID) + ')');
			SQL.Add('	and (shared_with = -1)');
//			SQL.Add('	and (local_status_code = "Active")');
//			SQL.Add('order by');
//			SQL.Add('	document_date');

			Active := True;

			First;

			if not Eof then
			begin

				// -- Initialise the number of patches found
				pf := 0;

				// -- Did they provide a date to look after?
				if pldate <> 0 then
				begin
					// ** -- PATCH the pricelist -- **

					// -- Look for patches
					patch_qry.SQL.Clear;
					patch_qry.DatabaseName := GTD_ALIAS;

					// -- Build the SQL
					patch_qry.SQL.Clear;
					patch_qry.SQL.Add('select');
					patch_qry.SQL.Add('	*');
					patch_qry.SQL.Add('from');
					patch_qry.SQL.Add('	Trader_AuditTrail');
					patch_qry.SQL.Add('where');
					patch_qry.SQL.Add('	Trader_ID='+IntToStr(Customer.fMerchantID));
					patch_qry.SQL.Add('	and (Document_ID=' + FieldByName('Document_ID').ASString + ')');
					patch_qry.SQL.Add('	and (Audit_Code="' + GTD_PRICELIST_PATCH_TYPE + '")');
					patch_qry.SQL.Add('	and (Local_TimeStamp > "' + AsSQLDate(plDate) + '")');
					patch_qry.SQL.Add('order by');
					patch_qry.SQL.Add('	Document_Audit_ID');

					patch_qry.Active := True;

					patch_qry.First;
					while Not patch_qry.Eof do
					begin

						// -- Increment the number of patches found
						Inc(pf);

						// -- Assign from the blob
						aMemo := TMemoField(patch_qry.FieldByName('Audit_Log'));

						// -- Point to the string list
						aSL.Assign(aMemo);

						// -- Add all our fields to the list
						for xc := 0 to aSL.Count-1 do
							Customer.fWorkingDoc.XML.ADd(asl.Strings[xc]);

						patch_qry.Next;
					end;

					if (pf <> 0) then
					begin
						plsendtype := GTD_PL_UPDATE_PATCH;
						haveNewPricelist := True;
					end;

				end;

				// -- Did we find any patches ? if not....
				if (pf = 0) then
				begin

					// ** -- REPLACE the whole pricelist -- **

					// -- This is the pricelist date
					if FieldByName(GTD_DB_DOC_DATE).IsNull then
						ourplDate := Now
					else
						ourplDate := FieldByName(GTD_DB_DOC_DATE).AsFloat;

					// -- Initialise
					Customer.fWorkingDoc.Clear;
					Customer.fWorkingDoc.XML.Clear;

					// -- Reload the pricelist if they have an old one
					if plDate < ourplDate then
					begin
						plsendtype := GTD_PL_UPDATE_REPLACE;
						if Customer.fRegistry.Load(FieldByName(GTD_DB_DOC_DOC_ID).AsInteger,Customer.fWorkingDoc) then
        					haveNewPricelist := True;
					end;

				end;

				// -- Check the number of lines
				if Customer.fWorkingDoc.XML.Count <> 0 then
				begin
            		Response.ResultCode   := 0;
					Response.DocumentData := Customer.fWorkingDoc;
					Response.ResultExtra  := EncodeDateTimeField(GTLINK_ELE_CATALOG_TIME,ourplDate) +
											 EncodeStringField(GTD_PL_ELE_UPDATE_TYPE,plsendtype);

					haveNewPricelist := True;
				end
				else
					haveNewPricelist := False;

			end
			else begin
				haveNewPricelist := False;
			end;

		end;

	end
	else begin
		plfn := GTD_CURRENT_PRICELIST;

		if FileExists(plfn) then
		begin
			// -- Check the date/time
			ourplDate := FileDateToDateTime(FileAge(plfn));

			if plDate < ourplDate then
				haveNewPricelist := True;
		end
		else
			haveNewPricelist := False;

		// -- Send down the new pricelist if there is one
		if haveNewPricelist then
		begin

			// -- Load up the new pricelist from the file
			// plfn := GTD_CURRENT_PRICELIST;
			if FileExists(plfn) then
			begin
				// -- Load this file into the current pricelist
				Customer.fWorkingDoc.Clear;
				Customer.fWorkingDoc.LoadFromFile(plfn);
				Response.DocumentData := Customer.fWorkingDoc;
				Response.ResultExtra  := EncodeDateTimeField(GTLINK_ELE_CATALOG_TIME,ourplDate) +
										 EncodeStringField(GTD_PL_ELE_UPDATE_TYPE,GTD_PL_UPDATE_REPLACE);
			end;
		end
	end;

	if not haveNewPricelist then
	begin
		// -- There isn't a more up to date pricelist at this point in time
		Response.ResultCode := 100;
		Response.ResultText := 'Pricelist is current';
	end;

	aSl.Destroy;
	MarkA.Destroy;
	Patch_qry.Destroy;
	plfind_qry.Destroy;

end;
//---------------------------------------------------------------------------
procedure TCommandHandler.ProcessDocumentStatusChange(L : String; var Customer : TCustomerData; var Response : TCommandResponse);
var
	markA  : HECMLMarker;
	rcode,rcmts,msgid : String;
	dno : Integer;
begin
	// -- In this case we don't need to respond to the other side at all
	Response.Clear;

	try

		markA  := HECMLMarker.Create;

		// -- Our response has everything that we need in it
		markA.UseSingleLine(L);

		msgid := markA.ReadStringField(GTD_DB_DOC_MSGID);
		dno   := Customer.fWorkingDoc.LocalToRemoteMsgID(msgid);

		if Customer.fRegistry.Load(dno,Customer.fWorkingDoc) then
		begin
			Customer.fWorkingDoc.Remote_Status_Code := markA.ReadStringField('Status_Code');
			Customer.fWorkingDoc.Remote_Status_Comments := markA.ReadStringField('Status_Comments');

			Customer.fRegistry.Save(Customer.fWorkingDoc,'Updated','Document Status Updated');

			Response.ResultText := 'Document Status Updated';

		end
		else begin
			Response.ResultCode := -2312;
			Response.ResultText := 'Document Status not Updated';
		end;


	finally

		markA.Destroy;

	end;
end;
//---------------------------------------------------------------------------
procedure TCommandHandler.ProcessRecvMessageLine(L : String; var Customer : TCustomerData; var Response : TCommandResponse);
begin
	if (L[1]=RO_MSGLINE) then
	begin
		Customer.fWorkingDoc.Add(Copy(L,2,Length(L)-1));

		Inc(fRecvLinesReceived);
		if (fRecvLinesReceived >= fRecvLinesExpected) then
		begin
			Customer.fRegistry.Save(Customer.fWorkingDoc,GTD_AUDITCD_RCV,GTD_AUDITDS_RCV);

			Response.ResultCode := 0;
			Response.ResultText := 'Document Received';
			Response.DocumentData := nil;
			Response.ResultExtra := EncodeStringField(GTD_DB_DOC_MSGID,Customer.fWorkingDoc.RemoteToLocalMsgID(Customer.fWorkingDoc.Local_Doc_ID)) +
									EncodeStringField(GTD_DB_DOC_LOCSTAT,Customer.fWorkingDoc.Local_Status_Code) +
									EncodeStringField(GTD_DB_DOC_LOCCMTS,Customer.fWorkingDoc.Local_Status_Comments);

			fStatus := csAwaitCommand;

            Response.NeedToRespond := True;

		end
        else
            Response.NeedToRespond := False;
        
	end;
end;
//---------------------------------------------------------------------------
procedure TCommandHandler.ProcessSentDocumentResponse(L : String; var Customer : TCustomerData; var Response : TCommandResponse);
var
	markA  : HECMLMarker;
begin
	// -- In this case we don't need to respond to the other side at all
	Response.Clear;
	Response.NeedToRespond := False;

	try

		markA  := HECMLMarker.Create;

		// -- Our response has everything that we need in it
		markA.UseSingleLine(L);

		// -- Now we have to process the line and update our doccument
		Customer.fWorkingDoc.UpdateCurrentDocStatus(MarkA,True);

		// -- Manually change the status to say that it has been received
		Customer.fWorkingDoc.Local_Status_Code := GTD_AUDITCD_SND;

		// -- Now the document can be marked as sent
		Customer.fRegistry.Save(Customer.fWorkingDoc, GTD_AUDITCD_SND, GTD_AUDITDS_SND);

		// -- Update the display
		Response.AddLANNotification('Document Type=' + Customer.fWorkingDoc.Document_Type + ', Reference=' + Customer.fWorkingDoc.Document_Ref + ' Sent');

	finally

		markA.Destroy;

	end;

	// -- We can change to another status


end;
//---------------------------------------------------------------------------
procedure TCommandHandler.ProcessNotification(L : String; var Customer : TCustomerData; var Response : TCommandResponse);
begin
    Response.Clear;
end;
//---------------------------------------------------------------------------
procedure TCommandHandler.ProcessDocumentNotification(L : String; var Customer : TCustomerData; var Response : TCommandResponse);
begin
    Response.Clear;
end;
//---------------------------------------------------------------------------
procedure TCommandHandler.ProcessChatLine(L :String; var Response : TCommandResponse);
begin
    Response.Clear;
end;
//---------------------------------------------------------------------------
procedure TCommandHandler.ProcessSendImage(L :String; var Customer : TCustomerData; var Response : TCommandResponse);
var
	markA  : HECMLMarker;
	fp,ld,et    : String;
	imagefile : TFileStream;

	IdEncoderMIME1 : TIdEncoderMIME;
	IdEncoderUUE1 : TIdEncoderUUE;

begin
	// -- In this case we don't need to respond to the other side at all
	Response.Clear;

    if not Assigned(Customer.fWorkingDoc) then
        Customer.fWorkingDoc := GTDBizDoc.Create(nil);

	Response.DocumentData := Customer.fWorkingDoc;

	try

        IdEncoderMIME1 := nil;
        IdEncoderUUE1 := nil;

		markA  := HECMLMarker.Create;

		// -- Our response has everything that we need in it
		markA.UseSingleLine(L);

		fp := markA.ReadStringField(GTLINK_SENDIMAGEREF_PARAM);
		et := markA.ReadStringField(GTLINK_SENDIMAGEENC_PARAM);

        fp := Customer.fRegistry.GetOurImageDir + '\' + fp;

		Response.DocumentData.Clear;

		if FileExists(fp) then
		begin

			imagefile := TFileStream.Create(fp,fmOpenRead);
			if (et = 'UUE') then
			begin
				// -- UU Encoding
            	IdEncoderUUE1 := TIdEncoderUUE.Create(nil);

				ld := IdEncoderUUE1.Encode(imagefile,72);
				while (ld <> '') do
				begin
					Response.DocumentData.Add(ld);
					ld := IdEncoderUUE1.Encode(imagefile,72);
				end;

                IdEncoderUUE1.Destroy;
                IdEncoderUUE1 := nil;

			end
			else begin
				// -- Mime Encoding
            	IdEncoderMIME1 := TIdEncoderMIME.Create(nil);

                Response.DocumentData.Add('====begin-base64 644 ' + markA.ReadStringField(GTLINK_SENDIMAGEREF_PARAM));

				ld := IdEncoderMIME1.Encode(imagefile,72);
				while (ld <> '') do
				begin
					Response.DocumentData.Add(ld);
					ld := IdEncoderMIME1.Encode(imagefile,72);
				end;

                IdEncoderMIME1.Destroy;
                IdEncoderMIME1 := nil;

                Response.DocumentData.Add('====end==========================================');

                {
                Customer.fWorkingDoc.Clear;
                Customer.fWorkingDoc.LoadImageAsBase64(fp);
                }
			end;
			imagefile.Destroy;

        	Response.ResultText := 'Image Sent';

		end
        else begin
        	Response.ResultCode := GTD_SESSNERROR_BASE;
        	Response.ResultText := GTD_MESSG_NOT_AVAILABLE;
        end;

	finally
    
        if Assigned(IdEncoderUUE1) then
            IdEncoderUUE1.Destroy;
        if Assigned(IdEncoderMIME1) then
            IdEncoderMIME1.Destroy;

		markA.Destroy;
	end;

end;
//---------------------------------------------------------------------------
procedure TCommandResponse.Clear;
begin
    // -- Here all members are reset back to nothing
    ResultCode      := 0;
    ResultText      := '';
    ResultExtra     := '';
    TerminateLink   := False;
    NeedToRespond   := True;
    DocumentData    := nil;
    LinkNotification:= '';
    LANNotification := '';
end;
//---------------------------------------------------------------------------
procedure TCommandResponse.AddLinkNotification(L : String);
begin
    // -- Add this new notification to the existing ones
    LinkNotification := LinkNotification + L + LineTerm;
end;
//---------------------------------------------------------------------------
procedure TCommandResponse.AddLANNotification(L : String);
begin
	// -- Add this new notification to the existing ones
	LANNotification := LANNotification + L;
end;
//---------------------------------------------------------------------------
procedure TCustomerTCPListener.TestPricelist(L : String);
var
	ml : TCustomerTCPLink;
	xc : Integer;
	oldalias : String;
begin
	ml := TCustomerTCPLink.Create(Self);

    oldalias := GTD_ALIAS;

	ml.fCustomer       := TCustomerData.Create;
	ml.fCmdHandler     := TCommandHandler.Create;
	ml.fCmdResponse    := TCommandResponse.Create;

	ml.fCustomer.fWorkingDoc := GTDBizDoc.Create(Self);
	ml.fCustomer.fRegistry := GTDDocumentRegistry.Create(Self);
	ml.fCustomer.fRegistry.DatabaseName := 'ComputerGrid';

	ml.fCustomer.fMerchantID := 85;

	ml.fCmdHandler.ProcessCatalogReq(L,ml.fCustomer,ml.fCmdResponse);

	{
	if ml.fCmdResponse.ResultCode = 0 then
	begin
	MessageDlg(ml.fCmdResponse.DocumentData.XML,mtInformation,[mbok],0);
	for xc := 0 to ml.fCmdResponse.DocumentData.XML.COunt-1 do
		ml.Display(ml.fCmdResponse.DocumentData.XML.Strings[xc]);
}
	ml.Destroy;

    GTD_ALIAS := oldalias;
end;

end.
