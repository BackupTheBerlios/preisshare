//---------------------------------------------------------------------------
// GTDBizLinks
//
// (c) Copyright Global TradeDesk Technologies Pty Ltd
//
//     This file contains proprietory and confidential property
//     of Global TradeDesk Technologies and is licensed under
//     terms of the Global TradeDesk Source Code License
//
// Synopsis
//
//     This file contains classes for Communication sessions
//     the Global TradeDesk Product.
//
//     The classes include:
//
//          * gtSessionLink     - The basic ancestor
//          * gtExchangeLink    - A Link to the Exchange
//          * gtTradingLink     - A Link to another party
//          * gtdConnectionList - A connection Manager
//          * gtdLANPoint       - A connection from a machine on the LAN to the server
//
//---------------------------------------------------------------------------
unit GTDBizLinks;

interface

{$IFDEF VER100}
	// -- Delphi 3
	{$DEFINE HW_SIMPLE}
{$ELSE}
	{$IFDEF VER110}
		// -- C++ Builder 3
        {$DEFINE HW_SIMPLE}
	{$ENDIF}
{$ENDIF}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  FileCtrl, comctrls,
  {$IFDEF HW_SIMPLE}
  SocketComponents,
  {$ELSE}
  ScktComp,
  {$ENDIF}
  Winsock,GTDBizDocs,WSocket, WSocketS, HttpProt;

const

	// -- The whereis command
	GTD_WER_ELE_COMPANY_CODE        = GTD_LGN_ELE_COMPANY_CODE;
	GTD_WER_ELE_IP_ADDRESS          = 'IP_Address';
	GTD_WER_ELE_DIRECT_CONNECT      = 'Direct_Connect';
	GTD_WER_ELE_PORT_NUMBER         = 'Port_Number';

    // -- Stuff for skins
	GTD_REG_SKINNAME                = 'Skin';
	GTD_REG_SKIN_CORONA             = 'Corona';
    GTD_REG_SKIN_XPULSE             = 'X-Pulse';
	GTD_REG_SKIN_WXPBLUE            = 'WXPBlue';
	GTD_REG_SKIN_WBMANIAL           = 'WBManial';
    GTD_REG_SKIN_KROMOL             = 'Kromol';
	GTD_REG_SKIN_HANGON             = 'HangOn';
	GTD_REG_SKIN_EMERGENCY          = 'E-Mergency';
	GTD_REG_SKIN_KETIX              = 'Ketix';
    GTD_REG_SKIN_WINAQUA            = 'WinAqua';

	GTD_REG_USERID                  = 'UserID';
	GTD_REG_PASSWORD                = 'Password';

    GTD_LANTALK_UDP_STATION_PORT    = 100;
	GTD_LANTALK_UDP_SERVER_PORT     = 101;
    GTD_WANTALK_PORT                = 100;

    GTD_REG_LOGO_IMAGE              = 'LogoImage';

	GTD_REG_DFLT_QUOTE_AGE          = 'Default Quote Age';
	GTD_REG_DFLT_QUOTE_DESPATCH     = 'Default Quote Despatch Mode';
	GTD_REG_DFLT_QUOTE_DELCHG       = 'Default Quote Delivery Charge';
	GTD_REG_DFLT_QUOTE_TERMS        = 'Default Quote Terms';

	GTD_REG_EMAIL_HOST              = 'Email Host';
	GTD_REG_EMAIL_LOGINREQ          = 'Email Login Required';
	GTD_REG_EMAIL_USERNAME          = 'Email User Name';
	GTD_REG_EMAIL_PASSWORD          = 'Email Config';
	GTD_REG_EMAIL_DISPLAYNAME       = 'Email Display Name';


//    GTD_DFLT_BIZEXCHANGE            = '192.168.2.20';
	GTD_DFLT_BIZEXCHANGE            = '220.233.76.153';

	GTD_GRIDSERVER					= 'Grid';

    // -- Registry settings for StatementSender
	GTD_REG_SERIALCPTR              = 'Serial Port Capture';
	GTD_REG_SERIALCPTR_BAUDRATE     = 'Serial Port Baud';
    GTD_REG_SERIALCPTR_PORTID       = 'Serial Port Identifier';
    GTD_REG_SERIALCPTR_BITS         = 'Serial Port BitSettings';

    GTD_REG_FILECPTR                = 'PrintFile Capture';
	GTD_REG_FILECPTR_PRINTFILE      = 'PrintFile Location';

	//
    // -- Registry settings for StatementSender Coordinates
	GTD_REG_STMNT_TOPTEXT           = 'Document Designator';
    GTD_REG_STMNT_TOPTEXT_CORDS     = 'Document Designator Coords';
    GTD_REG_STMNT_PAGELENGTH        = 'PageLength';
	GTD_REG_STMNT_PAGENUM           = 'PageNum Coords';
    GTD_REG_STMNT_DATE_CORDS        = 'Statement Date Coords';
    GTD_REG_STMNT_CS_ACNTCD_CORDS   = 'Customer Account Code Coords';
    GTD_REG_STMNT_CS_NAME_CORDS     = 'Customer Name Coords';
	GTD_REG_STMNT_CS_ADD1_CORDS     = 'Customer Address_1 Coords';
	GTD_REG_STMNT_CS_ADD2_CORDS     = 'Customer Address_2 Coords';

	GTD_REG_STMNT_TN_AREA_CORDS     = 'Transaction Area Coords';
    GTD_REG_STMNT_TN_TYPE_CORDS     = 'Transaction Item Type Coords';
    GTD_REG_STMNT_TN_REF_CORDS      = 'Transaction Item Reference Coords';
    GTD_REG_STMNT_TN_DATE_CORDS     = 'Transaction Item Date Coords';
    GTD_REG_STMNT_TN_DESC_CORDS     = 'Transaction Item Description Coords';
	GTD_REG_STMNT_TN_DR_CORDS       = 'Transaction Item Debit Coords';
	GTD_REG_STMNT_TN_CR_CORDS       = 'Transaction Item Credit Coords';
	GTD_REG_STMNT_TN_AMT_CORDS      = 'Transaction Item Amount Coords';
    GTD_REG_STMNT_TN_BAL_CORDS      = 'Transaction Item Balance Coords';

	GTD_REG_STMNT_SY_CURR_CORDS     = 'Transaction Summary Current Coords';
    GTD_REG_STMNT_SY_30DY_CORDS     = 'Transaction Summary 30 Day Coords';
	GTD_REG_STMNT_SY_60DY_CORDS     = 'Transaction Summary 60 Day Coords';
	GTD_REG_STMNT_SY_90DY_CORDS     = 'Transaction Summary 90 Day Coords';
	GTD_REG_STMNT_SY_BAL_CORDS      = 'Transaction Summary Balance Coords';

	// -- Error messages
	GTD_SESSNERROR_BASE             = -8000;
	GTD_ERROR_NOT_CNECTD2XCHG       = GTD_SESSNERROR_BASE + 001;
    GTD_MESSG_NOT_CNECTD2XCHG       = 'Unable to Connect. Not Connected to Exchange';
    GTD_ERROR_NOT_CNECTD2RMOT       = GTD_SESSNERROR_BASE + 002;
    GTD_MESSG_NOT_CNECTD2RMOT       = 'Not Connected';
    GTD_ERROR_CHAT_AUTOREJECT       = GTD_SESSNERROR_BASE + 003;
    GTD_MESSG_CHAT_AUTOREJECT       = 'Chat Session already rejected';
    GTD_ERROR_SAVE_IMAGE            = GTD_SESSNERROR_BASE + 004;
    GTD_MESSG_SAVE_IMAGE            = 'Unable to save Image';
	GTD_ERROR_LOAD_DOCUMENT         = GTD_SESSNERROR_BASE + 005;
	GTD_MESSG_LOAD_DOCUMENT         = 'Unable to Load Document';
	GTD_ERROR_NO_REGISTRY           = GTD_SESSNERROR_BASE + 006;
	GTD_MESSG_NO_REGISTRY           = 'No Open DOcument Registry';
	GTD_ERROR_NOT_IMPLEMENTED       = GTD_SESSNERROR_BASE + 007;
	GTD_MESSG_NOT_IMPLEMENTED       = 'Not Implemented';
	GTD_ERROR_USER_CANCELLED        = GTD_SESSNERROR_BASE + 008;
	GTD_MESSG_USER_CANCELLED        = 'Transfer cancelled by User';
	GTD_ERROR_NOT_AVAILABLE         = GTD_SESSNERROR_BASE + 009;
	GTD_MESSG_NOT_AVAILABLE         = 'Not Available';
	GTD_ERROR_BAD_PRICELIST         = GTD_SESSNERROR_BASE + 010;
	GTD_MESSG_BAD_PRICELIST         = 'Invalid Pricelist';

	GTD_LOGIN_REFUSED               = 500;
	GTD_ERROR_LOGIN_REFUSED         = 'Access Denied';

    GTD_NETOPTION_HTTP_ACCEPT       = 'HTTP_80_LISTEN';
	GTD_NETOPTION_100_ACCEPTS       = 'NETACCOUNTS_LISTEN';
    GTD_NETOPTION_NOLISTEN          = 'NO_LISTEN';
    GTD_NETOPTION_SSL               = 'SSL';
    GTD_NETOPTION_USER_ENCRYPTION   = 'PRIVATE_ENCRYPTION';

    nl = #13#10;

    // -- These are messages Window messages
	GTWM_SERVICE_QUEUE              = WM_APP + 300;
//  CM_PROCESSNEXTCOMMAND       = WM_APP + 50;

type
	gtWorkstationType  = (  gtwtServer,         // -- Offline
							gtwtWorkstation,    // -- Connecting to the Exchange
							gtwtViewstation     // -- Connecting to the Peer
						  );

	// -- Determination for the session Status
	gtSessionUserState = (  gtusOffline,        // -- Offline
							gtusConnectXchg,    // -- Connecting to the Exchange
							gtusConnectPeer,    // -- Connecting to the Peer
							gtusAuthenticate,   // -- Authenticating (Logging in)
							gtusChkPricelist,   // -- Checking and Downloading the pricelist
							gtusSending,        // -- Receiving
							gtusReceiving,      // -- Sending
							gtusOnlineReady,    // -- Connected and Ready
							gtusStopped,        // -- Stopped/Error etc
							gtusChgDocStatus,   // -- Changing a document status
							gtusChkNewDocs,     // -- Go and  look for new documents
							gtusComplete
						);

  // -- Event prototypes
  hBizParticipationEvent = procedure(Sender: TObject; GTL, EventCode, ExtraInfo : String) of object;
  hBizOnConnectEvent = procedure(Sender: TObject; GTL, Opcode, Description : String) of object;
  hBizOnNewPricelistEvent = procedure(Sender: TObject; GTL : String; TimeStamp : TDateTime) of object;
  hBizOnNewStatementEvent = procedure(Sender: TObject; GTL : String; StmDocNo : Integer) of object;
  hBizOnCallbackRequestEvent = procedure(Sender: TObject; GTL : String) of object;
  hBizOnNewDocumentEvent = procedure(Sender: TObject; Trader_ID : Integer; GTL : String; DocumentNumber : Integer) of object;
  hBizOnNewDocumentStatusEvent = procedure(Sender: TObject; GTL : String; DocumentNumber : Integer; StatusInfo : String) of object;
  hBizOnSentDocumentEvent = procedure(Sender: TObject; GTL : String; DocumentNumber : Integer; DocType, DocReference : String) of object;
  hBizOnProductImageReceived = procedure(Sender: TObject; GTL : String; ShortFileName : String; DataInBase64 : GTDBizDoc) of object;
  hBizOnSearchTextReceived = procedure(Sender: TObject; GTL : String; SearchTextString : String) of object;
  hBizOnDisconnectEvent = procedure(Sender: TObject; GTL, Opcode, Description : String) of object;
  hBizOnLinkErrorEvent = procedure(Sender: TObject; ErrorType, ErrorDescription : String) of object;
  hBizOnStatusEvent = procedure(Sender: TObject; GTL, OperationType, Description : String) of object;
  hBizOnUserInformation = procedure(Sender: TObject; GTL, Description : String; PerCentComplete, IconIndex : Integer) of object;
  hBizOnChatLineEvent = procedure(Sender: TObject; Originator, Department, MessageText : String) of object;
  hBizOnChatStatusEvent = procedure(Sender: TObject; Originator, Department, ShortStatus : String) of object;
  hBizOnGetPeerAddressEvent = procedure(Sender: TObject; GTL, Opcode : String) of object;
  hBizOnGetPublicKeyEvent = procedure(Sender: TObject; ErrorType, ErrorDescription : String) of object;
  hBizOnGetPrivateKeyEvent = procedure(Sender: TObject; GTL, Opcode : String) of object;
  hBizOnVirtualConnectRequestEvent = procedure(Sender: TObject; GTL, Opcode : String) of object;
  hBizOnVirtualReadDataEvent = procedure(Sender: TObject; GTL, Opcode : String) of object;
  hBizOnVirtualDisconnectEvent = procedure(Sender: TObject; GTL, Opcode : String) of object;
  hBizOnLinkStatusEvent = procedure(Sender: TObject; GTL : String; NewStatus : gtSessionUserState; LongStatus: String) of object;
  hBizOnServerLogMessageEvent = procedure(Sender : TObject; ServerName, Opcode, Description : String) of object;
  hBizOnNewConnectionIDEvent = procedure(Sender: TObject; GTL : String; CID : Integer; CPWD : String) of object;

  hBizOnAllConnectionsDone = procedure(Sender : TObject; ErrorCount, WarningCount : Integer) of object;
  hBizOnConnectionCountChange = procedure(Sender: TObject; OutGoingCount, IncomingCount : Integer) of object;

  hBizOnPricelistUpdateEvent = procedure(Sender: TObject; GTL : String; NewPricelistDateTime : TDateTime) of object;

  // -- Events
  gtSessionEventType = (gteOpenConnection,	// -- Connection is now open
						gteDropConnection,	// -- Connection is dropped
						gteCommsError,      // -- Cannot connect
						gteWriteEnable,		// -- Channel open for writing
						gteWriteDisable,	// -- Channel closed for writing
						gteReceivedData,	// -- Data was received and needs to be processed
						gteTimerExpired,	// -- A timer has expired
						gteHeartBeat,
						gteHaveCommand,     // -- There is a new command to process
						gteOpComplete       // -- An operation has completed
					);

  gtSessionState = (	gtsInactive,		// -- Inactive or closed
						gtsConnecting,		// -- Connecting
						gtsSecConnect,		// -- Connecting to seconday
						gtsWaitToWrite,     // -- Waiting to write
						gtsWaitWhereIs,     // -- Wait for the IP Address
						gtsWaitLoginRsp,    // -- Waiting for a login response
						gtsIdle,			// -- Logged in and idle
						gtsRecvPricelist,   // -- Receiving a pricelist
						gtsSendPricelist,   // -- Sending a pricelist
						gtsSendDoc,			// -- Sending a document
						gtsRecvDoc,			// -- Receiving a document
						gtsProcCmd,			// -- Processing a command
						gtsRecvImage,		// -- Receiving a document
						gtsRecvNewList,     // -- Receiving new list of documents from the server
						gtsDocStatusChg,    // -- Waiting to hear back after changing the status of a document
						gtsError,			// -- In an error condition - disconnected
						gtsComplete         // -- All done, mark with a tick
					 );

  gtCommunityState = (	gtscInactive,	    // -- Inactive or closed
						gtscConnectIS,	    // -- Connecting to intermediate server
						gtscWaitIP,		    // -- Waiting on the IP of the main server
						gtscConnecting,	    // -- Connecting to main community server
						gtscIdle,		    // -- Logged in and idle
						gtscSendDoc,	    // -- Sending a document
						gtscRecvDoc,	    // -- Receiving a document
						gtscProcCmd		    // -- Processing a command
					 );

  gtProtocol = (	    tpHTTP,	            // -- Inactive or closed
						tpAsync 	        // -- Connecting to intermediate server
					 );

  gtTradingLink = class;
  gtCommunityLink = class;
  GTDConnectionList = class;

  // == gtSessionEvent ========================================================
  //
  // Description:
  //
  gtSessionEvent = class(TObject)
  public
	ID   		: Integer;
	EventType   : gtSessionEventType;
	Data 		: String;
  end;

  // == gtSessionLink =========================================================
  //
  // Description:
  //
  // This component forms the basis for communication and represents
  // an asynchronous peer-to-peer session. It can be both a supplier
  // of events as well as a responder.
  //
  // It uses a command channel and generates events to perform events
  // outside it's scope.
  //
  // This component is normally inherited to form more useful components
  gtSessionLink = class(TClientSocket)
  private
//	fHandle				: THandle;
	fCurrentState 		: gtSessionState;
	fUserState          : gtSessionUserState;

	fSizeExpected,
	fSizeReceived,

	ftx_buffer_size,
	fLastCmd	  		: Integer;
	fCmdPending,
	fCmdCancelled,
	fCanWrite,
	fSerialisedCmds     : Boolean;

	HttpCli1            : THttpCli;

	fTraderID			: Integer;

	DocFileName         : String;

	fNetOpts,
	fLocalGTL,
	fLocalCompanyName,
	fRemoteGTL,
	fLocalKey,

	fUserID,
	fPassword,
	fHostName,
	fpHash,

	fRegistration,
	fCommand,
	fParams,
	fLastError,
	fLoginCmd           : String;           // - Different components have different login commands

	fSessionType        : gtWorkstationType;

	fCommandList,							// - Holds commands, one command per line
											// - Buffers received data
	fSendBuffer 		: String;			// - Buffers data to be sent
	fRecvBuffer         : TStrings;         // - Holds a list of lines received
	fHalfLine           : String;           // - Holds the last half of a full line

	// -- Variables required when changing to secondary machine
	fChangingSecondaryIP:Boolean;
	fLoginData			:String;

	// -- These are all the events
	fOnConnect			: hBizOnConnectEvent;
	fOnDisconnect		: hBizOnDisconnectEvent;
	fOnParticipation    : hBizParticipationEvent;
	fOnLinkError        : hBizOnLinkErrorEvent;
	fOnStatus           : hBizOnStatusEvent;
	fOnNewPricelist     : hBizOnNewPricelistEvent;
	fOnNewDocument      : hBizOnNewDocumentEvent;
	fOnNewDocumentStatus: hBizOnNewDocumentStatusEvent;
	fOnSentDocument     : hBizOnSentDocumentEvent;
	fOnProductImageReceived : hBizOnProductImageReceived;
	fOnGetPublicKeyEvent: hBizOnGetPublicKeyEvent;
	fOnUserInformation  : hBizOnUserInformation;
	fOnPricelistUpdate  : hBizOnPricelistUpdateEvent;
    fOnSearchText       : hBizOnSearchTextReceived;
	fOnNewStatement     : hBizOnNewStatementEvent;
	fOnLinkStatus       : hBizOnLinkStatusEvent;
	fOnChatLine         : hBizOnChatLineEvent;
	fOnChatStatus       : hBizOnChatStatusEvent;
	fOnCallbackRequest  : hBizOnCallbackRequestEvent;
	fOnNewConnectionID  : hBizOnNewConnectionIDEvent;

	// -- Here are the HTTP based events
    procedure HttpCli1DocBegin(Sender: TObject);
    procedure HttpCli1DocEnd(Sender: TObject);

	// -- This is where the fsm runs
	procedure fsm(EventData : gtSessionEvent);
	procedure ChangeState(NewState : gtSessionState);
	function  CurrentState:gtSessionState;
	procedure ServiceQueue;

	//
	function PerformLogin:Boolean;

    procedure SetGTL(newGTL : String);

	// -- Low level event handlers
	procedure ProcessBufferedWrites(Sender: TObject; Socket: TCustomWinSocket);
	procedure ProcessConnecting(Sender: TObject; Socket: TCustomWinSocket);
	procedure ProcessConnected(Sender: TObject; Socket: TCustomWinSocket);
	procedure ProcessDisconnect(Sender: TObject; Socket: TCustomWinSocket);
	procedure ProcessError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
	procedure ProcessRead(Sender: TObject; Socket: TCustomWinSocket);
//    procedure ProcessRcvdDataBuffer(S : String);
	procedure ProcessRcvdDataBuffer(cptr : Pointer; BuffSize : Integer);

    // -- Notify the user what is happening
	procedure NotifyUser(TextMessage : String; PerCentComplete : Integer = 0; IconIndex : Integer = 0);
	procedure NotifyDebug(TextMessage : String);

	procedure ProcessNextCommand(var aMsg : TMsg); message GTWM_SERVICE_QUEUE;

  protected

	fProtocol           : gtProtocol; // -- HTTP or Async
	fServerPortNumber   : Integer;

	function BuildHTTPCommand(aNativeCommand : String):String;

	function EventRunInactive(anEvent : gtSessionEvent) : Boolean;
	function EventRunConnecting(anEvent : gtSessionEvent): Boolean;
	function EventRunLoginResponse(anEvent : gtSessionEvent): Boolean;
	function EventRunIdle(anEvent : gtSessionEvent): Boolean;
    function EventRunRecvPricelist(anEvent : gtSessionEvent): Boolean; virtual;
	function EventRunSendDoc(anEvent : gtSessionEvent): Boolean; virtual;
	function EventRunRecvDoc(anEvent : gtSessionEvent): Boolean; virtual;
	function EventRunProcCmd(anEvent : gtSessionEvent): Boolean;
	function EventRunError(anEvent : gtSessionEvent): Boolean;
	function EventRunRecvImage(anEvent : gtSessionEvent):Boolean; virtual;
	function EventRunRecvNewList(anEvent : gtSessionEvent):Boolean; virtual;
	function EventRunRecvStatusChg(anEvent : gtSessionEvent):Boolean; virtual;
	function EventDefaultHandler(anEvent : gtSessionEvent): Boolean;
  public

	constructor Create(AOwner: TComponent); override;
	destructor Destroy; override;

	// -- Loging in/out
	function  LogIn(GTL : String; ExtraInfo : String):Boolean;
	function  LoggedIn:Boolean;
	procedure LogOut;

	// -- Sending data
	function  SendCommand(aCmd : String; var ResultCode : Integer; var ResultDescription : String; var ExtraInfo : String):Boolean;
	procedure PostCommand(aCmd : String; ChangeToState : gtSessionState; ExtraHeaderParams : String = '');
	procedure SendDataLine(l : String);
	procedure SendNotification(aMsg : String; var CmdNumber : Integer);
    procedure SendBufferedText(S : String); virtual;
	procedure SendResponse(S : String); virtual;
	procedure AddCommand(newCmd : String);

	// -- Build a template web page
    procedure BuildTemplateWebForm(NativeCommand : String; var aStream : TMemoryStream);
    // -- Add a tradalog document(text) to a multipart message
    procedure AddDocumentToWeb(var aStream : TMemoryStream; myDoc : GTDBizDoc);

	// -- User commands
    procedure NotifyNewPricelist(NewPricelistTime : TDateTime);

	// -- Receiving data
    function GetNextLine(var L : String):Boolean;
	function GetDataLine(CmdNumber : Integer):String;
	function GetCommandResult(CmdNumber : Integer; var ResultLine : String; WaitForResult : Boolean):Boolean;

	// -- Queue processing
	procedure PostEvent(EventData : gtSessionEvent);
	procedure CompleteCommand(ExitStatus : Integer; someComment : String);
	{$IFNDEF HW_SIMPLE}
	overload;
    {$ENDIF}

	// -- Configuration access
	function GetSettingString(SectionName,ElementName : String; var ValueStr : String):Boolean;
	function GetSettingInt(SectionName,ElementName : String; var ValueInt : Integer):Boolean;
	function GetNextConfigInt(SectionName,ElementName : String; var ValueInt : Integer):Boolean;
	function SaveSettingInt(SectionName,ElementName : String; ValueInt : Integer):Boolean;
	function SaveSettingString(SectionName,ElementName : String; ValueStr : String):Boolean;

	procedure Cancel;

protected
	// -- These handlers are the initiators
	procedure InitiateClearDisplay(Params : String);
	procedure InitiateDial(Params : String);
	procedure InitiateHangup(Params : String);
	procedure InitiateOpenLink(Params : String);
	procedure InitiateCloseLink(Params : String);
	procedure InitiateCheckCertificate(Params : String);
	procedure InitiateResolveLinkIP(Params : String);
	procedure InitiateCloseWindow(Params : String);
	procedure InitiateOpenChatLink(Params : String);
	procedure InitiateCloseChatLink(Params : String);
	procedure InitiateSendChatLine(Params : String);
	procedure InitiateCheckChatStatus(Params : String);

	procedure InitiateCheckPricelist(Params : String); virtual;
	procedure InitiateSendDocument(Params : String); virtual;
	procedure InitiateRecvDocument(Params : String); virtual;
	procedure InitiateDocStatusChg(Params : String); virtual;
	procedure InitiateGetImage(Params : String); virtual;
	procedure InitiateGetNewDocList(Params : String); virtual;

	procedure InitiateTraderSearch(Params : String);
	procedure InitiateProductSearch(Params : String);
	procedure InitiateProductAvail(Params : String);

	// -- These handlers are the completions
	procedure CompleteRecvImage(CommandResult : String); virtual;
	procedure CompleteGetPricelist(CommandResult : String); virtual;
	procedure CompleteGetNewDocList(CommandResult : String); virtual;
	procedure CompleteRecvDocument(CommandResult : String); virtual;
	procedure CompleteSendDocument(CommandResult : String); virtual;

  published
	property Active;
	property Address;
	property Host;
	property Port;
	property LocalGTL : string read fLocalGTL write fLocalGTL;
	property LocalOrganisation : string read fLocalCompanyName write fLocalCompanyName;
	property Trader_ID : integer read fTraderID write fTraderID;
	property AccessKey : string read fLocalKey write fLocalKey;
	property UserID : string read fUserID write fUserID;
	property Password : string read fPassword write fPassword;
	property HostName : string read fHostname write fHostname;
	property SessionType : gtWorkstationType read fSessionType write fSessionType;
	property OptionString : string read fNetOpts write fNetOpts;
	property RegistrationDetails : string read fRegistration write fRegistration;
	property ServerPortNumber : Integer read fServerPortNumber write fServerPortNumber;

	property GTL : string read fRemoteGTL write SetGTL;
	property OnLinkUp : hBizOnConnectEvent read fOnConnect write fOnConnect;
	property OnLinkDown : hBizOnDisconnectEvent read fOnDisconnect write fOnDisconnect;
	property OnLinkError : hBizOnLinkErrorEvent read fOnLinkError write fOnLinkError;

	property OnParticipation : hBizParticipationEvent read fOnParticipation write fOnParticipation;
	property OnNewPricelist : hBizOnNewPricelistEvent read fOnNewPricelist write fOnNewPricelist;
	property OnNewDocument : hBizOnNewDocumentEvent read fOnNewDocument write fOnNewDocument;
	property OnNewDocumentStatus : hBizOnNewDocumentStatusEvent read fOnNewDocumentStatus write fOnNewDocumentStatus;
	property OnSentDocument : hBizOnSentDocumentEvent read fOnSentDocument write fOnSentDocument;
	property OnNewStatement : hBizOnNewStatementEvent read fOnNewStatement write fOnNewStatement;
    property OnSearchText : hBizOnSearchTextReceived read fOnSearchText write fOnSearchText;

	property OnGetPublicKey : hBizOnGetPublicKeyEvent read fOnGetPublicKeyEvent write fOnGetPublicKeyEvent;
	property OnError;

	property OnPricelistUpdate : hBizOnPricelistUpdateEvent read fOnPricelistUpdate write fOnPricelistUpdate;
	property OnProductImageReceived : hBizOnProductImageReceived read fOnProductImageReceived write fOnProductImageReceived;
	property OnStatusChange    : hBizOnLinkStatusEvent read fOnLinkStatus write fOnLinkStatus;
	property OnUserInformation : hBizOnUserInformation read fOnUserInformation write fOnUserInformation;

	property OnChatLine : hBizOnChatLineEvent read fOnChatLine write fOnChatLine;
	property OnChatStatus : hBizOnChatStatusEvent read fOnChatStatus write fOnChatStatus;

	property OnNewConnectionID : hBizOnNewConnectionIDEvent read fOnNewConnectionID write fOnNewConnectionID;

	property State : gtSessionUserState read fUserState;

	property LastError : String read fLastError;

	property Protocol : gtProtocol read fProtocol write fProtocol default tpAsync;

  private
	property OnRead;
	property OnWrite;
  end;

  // -- Event prototypes
  hBizOnConnectRequestEvent = procedure(Sender: TObject; GTL, Opcode : String) of object;
  hBizOnReadDataEvent = procedure(Sender: TObject; GTL, Opcode : String) of object;

  hBizOnGetChatRequestEvent = procedure(Sender: TObject; GTL, Opcode : String) of object;
  hBizOnGetChatLineEvent = procedure(Sender: TObject; channel : Integer; ChatText : String) of object;
  hBizOnGetChatCloseEvent = procedure(Sender: TObject; GTL, Opcode : String) of object;

  hBizOnGetDocCreateEvent = procedure(Sender: TObject; GTL, Opcode : String) of object;
  hBizOnGetDocUpdateEvent = procedure(Sender: TObject; GTL, Opcode : String) of object;
  hBizOnGetDocStatusEvent = procedure(Sender: TObject; GTL, Opcode : String) of object;

  hBizOnNeedEncryptionEvent = procedure(Sender: TObject; GTL, Opcode : String) of object;
  hBizOnNeedDecryptionEvent = procedure(Sender: TObject; GTL, Opcode : String) of object;

  // == gtTradingLink =========================================================
  //
  // Description:
  //
  // This component represents a normal Peer-to-Peer trading link between
  // two organisations.
  //
  gtTradingLink = class(gtSessionLink)
  private
	fImageName      : String;
  protected
	fDocuments      : GTDDocumentRegistry;
	fExchange       : gtCommunityLink;
	fChatList       : TStrings;
	fConnectionList : GTDConnectionList;
	fConnectionItem : TListItem;
	fWorkingDoc     : GTDBizDoc;

    property OnRead;
    property OnWrite;

	procedure InitiateCheckPricelist(Params : String); override;
	procedure InitiateSendDocument(Params : String); override;
    procedure InitiateGetNewDocList(Params : String); override;
	procedure InitiateRecvDocument(Params : String); override;
	procedure InitiateDocStatusChg(Params : String); override;
	procedure InitiateGetImage(Params : String); override;

    procedure CompleteRecvImage(CommandResult : String); override;
    procedure CompleteGetPricelist(CommandResult : String); override;
    procedure CompleteGetNewDocList(CommandResult : String); override;
    procedure CompleteRecvDocument(CommandResult : String); override;
	procedure CompleteSendDocument(CommandResult : String); override;
    function  CompleteUpdateStatus(CommandResult : String):Boolean;

    function EventRunRecvPricelist(anEvent : gtSessionEvent): Boolean; override;
	function EventRunSendDoc(anEvent : gtSessionEvent): Boolean; override;
	function EventRunRecvDoc(anEvent : gtSessionEvent): Boolean; override;
    function EventRunRecvImage(anEvent : gtSessionEvent):Boolean; override;
    function EventRunRecvNewList(anEvent : gtSessionEvent):Boolean; override;
    function EventRunRecvStatusChg(anEvent : gtSessionEvent):Boolean; override;

    procedure SendBufferedText(S : String); override;

	function LoadAuthenticationInfo(forTrader_ID : Integer; ForOutgoing :Boolean = True):Boolean;

  public
	fThruExchange   : Boolean;

	constructor Create(AOwner: TComponent); override;
	destructor Destroy; override;

	// -- Loging in/out
	function LogIn(Trader_Number : Integer; ExtraInfo : String):Boolean; overload;
	function OpenSession(GTL : String):Boolean;

	// -- Keyring functions
	function RequestNewPrivateKey(GTL : String; var Private_Key : String):String;

	// -- Document Functions
    function CheckPricelist:Boolean;
	function SendAllNewDocs:Boolean;
	function ReceiveAllNewDocs:Boolean;
	function UpdateAllDocStatuses:Boolean;
	function SendDocument(Doc_ID : Integer):Boolean;
	function GetNewDocList:Boolean;
	function RecvDocument(Doc_ID : Integer):Boolean;
	function ReceiveImage(ImageName : String; CompressionType :String = 'MIME'):Boolean;
    function SendDocumentUpdates(Doc_ID : Integer):Boolean;

    procedure ReSync;

	// -- Chatting functions
	function OpenChatLine(DepartmentName, AreaName, TheirName : String; var ResultCode : Integer; var ResultDescription : String):Integer;
    function SendChatText(channel : Integer; ChatMessage : String):Boolean;
	function CloseChatLine(channel : Integer):Boolean;
	function LeaveMessage(DepartmentName, AreaName, UserName, MessageText : String):String;

  published
	property Active;
	property Address;
    property UserID;
    property Password;
    property HostName;
	property Host;
	property Port;
    property Documents : GTDDocumentRegistry read fDocuments write fDocuments;
    property Exchange  : gtCommunityLink read fExchange write fExchange;
    property ConnectionList : GTDConnectionList read fConnectionList write fConnectionList;
    property ConnectionItem : TListItem read fConnectionItem write fConnectionItem;
	property OnConnecting;
	property OnConnect;
	property OnDisconnect;
	property OnError;
	property RouteThruExchange : Boolean read fThruExchange write fThruExchange default true;
	function  LogIn(GTL : String; ExtraInfo : String):Boolean; overload;
  end;

  // == gtCommunityLink =======================================================
  //
  // Description:
  //
  // This component talks to the community server. It is based upon a
  // gtSessionLink.
  //
  // It uses a command channel and generates events to perform events
  // outside it's scope.
  //
  gtCommunityLink = class(gtTradingLink)
  private
	fInConnectionCount,
	fOutConnectionCount : Integer;
	fOnConnectionCountChange : hBizOnConnectionCountChange;

  protected
  public
	constructor Create(AOwner: TComponent); override;
//	destructor Destroy; override;

	function DetermineOptimumHost:String;

	// -- Keyring functions
	function CheckPublicKey(ResultCode : Integer; var ResultDescription : String):Boolean;
	function RequestNewPublicKey(ResultCode : Integer; var ResultDescription : String; var ExtraInfo : String):Boolean;
	function RequestNewPrivateKey(GTL : String; var Private_Key : String):String;

	// -- Directory functions
	function WhereIs(GTL :String; var ResultCode : Integer; var ResultDescription : String):String;
	function WhosLike(s : String):String;
	function WhoHas(s : String):String;

//	function LogIn(PricelistTime : TDateTime; ExtraInfo : String):Boolean;
	function LogIn(myRegistry : GTDDocumentRegistry):Boolean;
    function UploadPricelist(DocID : Integer = -1):Boolean;

	function GetExchangeAddress:String;

	procedure IncOutboundConnectionCount;
	procedure DecOutboundConnectionCount;

	// -- Routing functions
	procedure SendLineTo(Destination, L : String);

  published
	property Active;
	property Address;
	property Host;
	property Port default 100;

	property OnCallbackRequest : hBizOnCallbackRequestEvent read fOnCallbackRequest write fOnCallbackRequest;
	property OnConnecting;
	property OnConnectionCountChange : hBizOnConnectionCountChange read fOnConnectionCountChange write fOnConnectionCountChange;

//	property OnError;
  end;

  // == gtConnectionList ======================================================
  //
  // Description:
  //
  // This component provides a visual manager that both runs and
  // displays connections. It is based on a Listbox and can display
  // connections either for a single organisation or for many.
  //
  GTDConnectionList = class(TListView)
  private

	fActiveCount             : Integer;
	fLocalGTL                : String;
	fExchange                : gtCommunityLink;
	fDocuments               : GTDDocumentRegistry;

	fOnNewPricelist          : hBizOnNewPricelistEvent;
	fOnNewStatement          : hBizOnNewStatementEvent;
	fOnNewDocument           : hBizOnNewDocumentEvent;
	fOnNewDocumentStatus     : hBizOnNewDocumentStatusEvent;
	fOnSentDocument          : hBizOnSentDocumentEvent;
	fOnProductImageReceived  : hBizOnProductImageReceived;
	fOnStatusEvent           : hBizOnStatusEvent;

	fOnConnectionCountChange : hBizOnConnectionCountChange;
	fOnAllConnectionsDone    : hBizOnAllConnectionsDone;

	procedure HandleNewPricelistNotification(Sender: TObject; GTL : String; TimeStamp : TDateTime);
	procedure HandlePricelistUpdate(Sender: TObject; GTL : String; NewPricelistDateTime : TDateTime);
	procedure HandleNewLinkStatus(Sender: TObject; GTL : String; NewStatus : gtSessionUserState; LongStatus: String);
	procedure HandleUserInformation(Sender: TObject; GTL, Description : String; PerCentComplete, IconIndex : Integer);
	procedure RequestLatestPricelist(GTL : String; PricelistDateStamp : TDateTime);

  public
	constructor Create(AOwner: TComponent); override;

	// -- Connection functions
	function  AddSupplierConnection(GTL, Name : String; Trader_ID : Integer):gtTradingLink;
	function  LoadSupplierConnections:Boolean; // Loads but doesn't open
	function  OpenAllSupplierConnections:Boolean;
	procedure CloseAllSupplierConnections;
	procedure OpenConnection(GTL : String);
	function  CloseConnection(GTL : String):Boolean;
	function  GetLink(GTL : String):gtTradingLink;
	procedure ReSync(GTL : String);

  published
	property Exchange  : gtCommunityLink read fExchange write fExchange;
	property Documents : GTDDocumentRegistry read fDocuments write fDocuments;
	property LocalGTL  : String read fLocalGTL write fLocalGTL;

	property OnNewPricelist : hBizOnNewPricelistEvent read fOnNewPricelist write fOnNewPricelist;
	property OnNewDocument  : hBizOnNewDocumentEvent read fOnNewDocument write fOnNewDocument;
	property OnNewDocumentStatus: hBizOnNewDocumentStatusEvent read fOnNewDocumentStatus write fOnNewDocumentStatus;
	property OnSentDocument  : hBizOnSentDocumentEvent read fOnSentDocument write fOnSentDocument;
	property OnNewStatement : hBizOnNewStatementEvent read fOnNewStatement write fOnNewStatement;
	property OnProductImageReceived : hBizOnProductImageReceived read fOnProductImageReceived write fOnProductImageReceived;
	property OnStatusEvent : hBizOnStatusEvent read fOnStatusEvent write fOnStatusEvent;

	property OnConnectionCountChange : hBizOnConnectionCountChange read fOnConnectionCountChange write fOnConnectionCountChange;
	property OnConnectionsDone : hBizOnAllConnectionsDone read fOnAllConnectionsDone write fOnAllConnectionsDone;

  end;

  // == gtdLANPoint ===========================================================
  //
  // Description:
  //
  // This component provides a non-visual component that enables
  // a workstation on a LAN to talk to the central server and
  // send/receive notifications.
  //
  // The way that this component works is that it listens on
  // a network port, usually udp/100 and receives broadcasts
  // from the server on the local LAN.
  //
  // The types of notifications received:
  //  - New Documents/Catalogs received
  //  - New Document Status updates
  //  - Companies going on/off the grid
  //  - Chat text
  //
  // The types of notifications sent to the Server
  //  - New documents posted to the document register
  //  - Chat text to go
  //
  gtdLANPoint = class(TCustomWSocket)
  private
    // --
    fOnNewPricelist         : hBizOnNewPricelistEvent;
    fOnNewDocument          : hBizOnNewDocumentEvent;
    fOnNewDocumentStatus    : hBizOnNewDocumentStatusEvent;
    fOnParticipation        : hBizParticipationEvent;
    fOnConnect              : hBizOnConnectEvent;
    fOnNewStatement         : hBizOnNewStatementEvent;
    fOnSentDocument         : hBizOnSentDocumentEvent;
    fOnProductImageReceived : hBizOnProductImageReceived;
    fOnDisconnect           : hBizOnDisconnectEvent;
    fOnServerLogMessage     : hBizOnServerLogMessageEvent;
    fOnSearchText           : hBizOnSearchTextReceived;

    fBroadcaster : TWSocket;

    procedure HandleDataReceived(Sender : TObject; Error : WORD);

    procedure SendServerLine(L : String);

  published

    property OnConnect       : hBizOnConnectEvent read fOnConnect write fOnConnect;
    property OnDisconnect    : hBizOnDisconnectEvent read fOnDisconnect write fOnDisconnect;
    property OnParticipation : hBizParticipationEvent read fOnParticipation write fOnParticipation;
    property OnNewPricelist : hBizOnNewPricelistEvent read fOnNewPricelist write fOnNewPricelist;
    property OnNewDocument  : hBizOnNewDocumentEvent read fOnNewDocument write fOnNewDocument;
    property OnNewDocumentStatus: hBizOnNewDocumentStatusEvent read fOnNewDocumentStatus write fOnNewDocumentStatus;
    property OnNewStatement  : hBizOnNewStatementEvent read fOnNewStatement write fOnNewStatement;
    property OnSentDocument  : hBizOnSentDocumentEvent read fOnSentDocument write fOnSentDocument;
    property OnProductImageReceived : hBizOnProductImageReceived read fOnProductImageReceived write fOnProductImageReceived;
    property OnServerLogMessage : hBizOnServerLogMessageEvent read fOnServerLogMessage write fOnServerLogMessage;
    property OnSearchText : hBizOnSearchTextReceived read fOnSearchText write fOnSearchText;
    property OnError;
    property LastError;
  public

	constructor Create(AOwner: TComponent); override;

	// --
    procedure FindCentralListenPoint;
    procedure NotifyWeHaveNewDocToSend(Trader_ID, Document_ID : Integer);
    procedure NotifyWeHaveChgedDocStatus(Trader_ID, Document_ID : Integer);
    procedure NotifyWeHaveNewPricelist(forTrader_ID : Integer);

    procedure Start;
    procedure StartSendOnly;
    procedure Finish;

    procedure LogMessage(Opcode, Description : String);
  end;

  // == gtdLANServerPoint =====================================================
  //
  // Description:
  //
  // This component provides a non-visual component that runs on
  // the server to keep in touch with workstations on the LAN via
  // send/receive notifications.
  //
  // The way that this component works is that it listens on
  // a network port, usually udp/101 and receives broadcasts
  // from the server on the local LAN.
  //
  // The types of notifications received:
  //  - New Documents/Catalogs received
  //  - New Document Status updates
  //  - Companies going on/off the grid
  //  - Chat text
  //
  // The types of notifications sent to the Server
  //  - New documents posted to the document register
  //  - Chat text to go
  //
  GTDLANServerPoint = class(TWSocketServer)
  private

	// -- These events are fired when a new document is created
    //    or it's status changes on the LAN.
    fOnNewDocument : hBizOnNewDocumentEvent;
    fOnNewDocumentStatus : hBizOnNewDocumentStatusEvent;

    fBroadcaster : TWSocket;

    procedure HandleDataReceived(Sender : TObject; Error : WORD);
	procedure BroadCastLine(L : String);

  public
    // --
    constructor Create(AOwner: TComponent); override;
    procedure Start;
	procedure Stop;

    procedure NotifyConnect;
    procedure NotifyDisconnect;
    procedure NotifyServerLogMessage(Opcode, Description : String);
    procedure NotifyStatus(ExtraParams : String);
    {
	procedure NotifyParticipation;
    procedure NotifyNewPricelist;
    procedure NotifyNewDocument;
    procedure NotifyNewDocumentStatus;
    procedure NotifyNewStatement;
	procedure NotifySentDocument;
    procedure NotifyProductImageReceived;
    }
  published
    property OnNewDocument  : hBizOnNewDocumentEvent read fOnNewDocument write fOnNewDocument;
	property OnNewDocumentStatus: hBizOnNewDocumentStatusEvent read fOnNewDocumentStatus write fOnNewDocumentStatus;

  end;

procedure Register;

const
    // -- Public constants

    GTLINK_RESPONSE_CODE        = 'Response_Code';
	GTLINK_RESPONSE_TEXT        = 'Response_Description';

	GTLINK_LOGIN_HASH			= 'Password_Hash';

	// -- These commands are sent out on the link
	GTLINK_COMMAND_WHEREIS      = 'whereis';
	GTLINK_COMMAND_CATALOG      = 'catalog';
	GTLINK_ELE_CATALOG_TIME     = 'TimeStamp';
	GTLINK_COMMAND_SENDCATALOG  = 'sendcatalog';
	GTLINK_COMMAND_OPENCHAT     = 'open_chat';
	GTLINK_COMMAND_CLOSECHAT    = 'close_chat';
	GTLINK_COMMAND_LISTNEWDOCS  = 'newdocs';
	GTLINK_COMMAND_SENDDOC      = 'senddoc';
	GTLINK_COMMAND_SENDIMAGE    = 'sendimage';
	  GTLINK_SENDIMAGEREF_PARAM = 'Image_Ref';
	  GTLINK_SENDIMAGEENC_PARAM = 'Encoding';
	GTLINK_COMMAND_TAKE         = 'take';
	GTLINK_COMMAND_LOGIN        = 'login';
	GTLINK_COMMAND_CHG_STATUS   = 'update_status';
	GTLINK_COMMAND_RESET        = 'reset';
	GTLINK_COMMAND_QUIT         = 'quit';

	// -- These are notification items
	GTLINK_NTFN_EVENTFIELD      = 'Event';
    GTLINK_NTFN_EVENTDESCR      = 'Description';
    GTLINK_NTFN_NEW_PRICELIST   = 'Pricelist Change';
    GTLINK_NTFN_PARTY_JOIN      = 'Join';
    GTLINK_NTFN_PARTY_LEAVE     = 'Leave';
    GTLINK_NTFN_ACTIVITY        = 'Activity';
    GTLINK_NTFN_CALLBACK_REQ    = 'Callback';
    GTLINK_NTFN_DOCSTATUSCHG    = 'Document Status';
    GTLINK_NTFN_NEWDOC          = 'New Document';
    GTLINK_NTFN_CONNECTION      = 'Connnection';
	GTLINK_NTFN_CONNECTIONCHECK = 'AliveCheck';
	GTLINK_NTFN_MD5INFO         = 'MD5';

    // -- Values for the Document_Status updates
	GTDOCUPD_NTFN_OP            = 'Operation';
	GTDOCUPD_NTFN_MSGID         = 'Msg_ID';
	GTDOCUPD_NTFN_DOCID         = 'Doc_ID';
	GTDOCUPD_NTFN_CODE          = 'Status_Code';
	GTDOCUPD_NTFN_CMTS          = 'Status_Comments';
	GTDOCUPD_NTFN_OP_READ       = 'Read';
	GTDOCUPD_NTFN_OP_UPDATE     = 'Update';

	// -- These have to do with chatting
	GTCHAT_ELE_ORIGINATOR       = 'From_Person';
	GTCHAT_ELE_FROM_POSITION    = 'From_Position';
	GTCHAT_ELE_RECIPIENT        = 'To_Person';
	GTCHAT_ELE_CHATMSG          = 'Chat_Text';
	GTCHAT_ELE_FROM_DEPT        = 'From_Department';
	GTCHAT_ELE_TO_DEPT          = 'To_Department';
	GTCHAT_ELE_FROM_AREA        = 'From_Area';
	GTCHAT_ELE_TO_AREA          = 'To_Area';
	GTCHAT_ELE_CHATPAIR         = 'Chat_ID';
	GTCHAT_ELE_PERSONAVAIL      = 'Person_Available';
	GTCHAT_ELE_PERSONSTATUS     = 'Person_Status';
	GTCHAT_ELE_EVENT            = 'Event';
	GTCHAT_ELE_CALLTAKER        = 'Call_Taker';

	// -- Chat Events
	GTCHAT_EVENT_OPEN           = 'Open';
	GTCHAT_EVENT_ACCEPT         = 'Accept';
	GTCHAT_EVENT_REJECT         = 'Reject';
	GTCHAT_EVENT_CHATLINE       = 'ChatLine';
	GTCHAT_EVENT_CLOSE          = 'Close';
	GTCHAT_EVENT_TIMEDOUT       = 'TimedOut';

	GTDOCLST_NEW_DOCLIST        = 'Document_List';
	GTDOCLST_NEW_DOCCOUNT       = 'Document_Count';

	// -- LAN Broadcast Commands that can be interpreted by the server
   	GTLAN_CMD_CHECKPROXY        = 'ANY_PROXY';
	GTLAN_CMD_RESYNC            = 'RESYNC';
    GTLAN_CMD_SERVER_STATUS     = 'REPORT_STATUS';

    // - Notifications going to and from the server
    GTLAN_NOTIFY_NEW_DOCUMENT   = 'NEW_DOCUMENT';
    GTLAN_NOTIFY_CHG_DOCUMENT   = 'CHG_DOCUMENT';
    GTLAN_NOTIFY_NEW_PRICELIST  = 'NEW_PRICELIST';
    GTLAN_NOTIFY_LOCAL_STATUS   = 'NEW_LOCAL_STATUS';
    GTLAN_NOTIFY_REMOTE_STATUS  = 'NEW_REMOTE_STATUS';
    GTLAN_NOTIFY_LOG_MESSAGE    = 'SERVER_MESSAGE';
    GTLAN_NOTIFY_CONNECT        = 'SERVER_CONNECT';
    GTLAN_NOTIFY_DISCONNECT     = 'SERVER_DISCONNECT';
    GTLAN_NOTIFY_SERVER_STATUS  = 'SERVER_STATUS';

    // -- Protocol constants
    RO_REROUTE      = '>';
    RO_PROGRESS     = '%';
    RO_NOTIFICATION = '-';
	RO_CMDRESP      = '*';
	RO_MSGLINE      = '+';
    RO_DOCSTATCHG   = '!';
    RO_CHATLINE     = '~';
    RO_BINDATA      = '.';

    // -- These are URLs for the various document functions
    GTURL_LIST_NEW              = '/cgi-bin/list_newdocs.cgi';
    GTURL_LIST_STATUS_CHG       = '/cgi-bin/list_statuschg.cgi';
    GTURL_GET_DOCUMENT          = '/cgi-bin/get_document.cgi';
    GTURL_GET_DOCSTAT           = '/cgi-bin/get_docstat.cgi';
    GTURL_PUT_DOCUMENT          = '/cgi-bin/put_document.cgi';
    GTURL_CHG_DOCSTAT           = '/cgi-bin/chg_docstat.cgi';
    GTURL_LOCATE_COMPANY        = '/cgi-bin/find_trader.cgi';

	// -- This URL provides an interface to post documents
	GTURL_POST_DOCUMENT         = '/cgi-bin/post_document.cgi';

    // -- This is a custom header added to messages
    GTHTTP_EXTRAHDR             = 'Document-Trace : ';

	// -- These are the commands that are issued to the
	//    components to drive them
	GTSESSION_CMD_CHKPRICELIST 	= 'CHECK_PRICELIST';
	GTSESSION_CMD_GETNEWDOCLIST = 'SEND_NEW';
	GTSESSION_CMD_SENDDOCUMENT	= 'SEND_DOCUMENT';
	GTSESSION_CMD_RECVDOCUMENT  = 'RECV_DOCUMENT';
	GTSESSION_CMD_GETIMAGE 		= 'GET_IMAGE';
    GTSESSION_CMD_RESYNC        = 'RESYNC';

	GTSESSION_CMD_GO 		    = 'GO';
	GTSESSION_CMD_CLEAR 		= 'CLEAR_WINDOW';
	GTSESSION_CMD_DIAL 			= 'DIAL';
	GTSESSION_CMD_HANGUP 		= 'HANGUP';
	GTSESSION_CMD_OPENLINK 		= 'OPEN';
	GTSESSION_CMD_CLOSELINK 	= 'CLOSE';
	GTSESSION_CMD_CHECKCERT 	= 'CHECK_CERTIFICATE';
	GTSESSION_CMD_RESOLVEIP 	= 'RESOLVE';
	GTSESSION_CMD_NOTIFYDOCSTAT = 'UPDATE_DOCSTAT';
	GTSESSION_CMD_CLOSEWINDOW   = 'CLOSE_WINDOW';
	GTSESSION_CMD_OPENCHATLINK  = 'OPEN_CHATLINK';
	GTSESSION_CMD_CLOSECHATLINK = 'CLOSE_CHATLINK';
	GTSESSION_CMD_SENDCHATLINE  = 'CHATTEXT';
	GTSESSION_CMD_CHECKCHATSTAT = 'CHATSTAT';
	GTSESSION_CMD_TRADERSEARCH 	= 'TRADER_SEARCH';
	GTSESSION_CMD_PRODUCTSEARCH = 'PRODUCT_SEARCH';
	GTSESSION_CMD_CHECKAVAIL    = 'CHECK_AVAILABILITY';
	GTSESSION_CMD_CHECKPROXY    = 'ANY_PROXY';

procedure CheckProxySettings(var UseProxy : Boolean; var ProxyAddr : String; var ProxyPort : String);
procedure CheckIEProxySettings(var UseProxy : Boolean; var ProxyAddr : String; var ProxyPort : String);
function ReadHTTPPageTime(L : String):TDateTime;

implementation

	{$IFNDEF LIGHTWEIGHT}
    uses db,dbTables, DelphiUtils;
    {$ENDIF}

const
    // -- This is the bogus error number passed to winsock
    //    so that we can get a callback so that we can do
    //    something
    GTSESSION_PROCESSQUEUE_S    = $5555;
    GTSESSION_PROCESSQUEUE_L    = $55550000;

    // -- These things are used in the web transport
	GTLINK_URL                  = 'http://www.tradalogs.com/cgi-bin/tradamatrix';
	GT_HTTPOPCODE_LOGIN         = 'C52987505';
	GT_HTTPOPCODE_UPLOAD_DOC    = 'C53921305';
	GT_HTTP_accountidfield      = 'ac';
	GT_HTTP_accountpassfield    = 'metro';
	GTCGIOPCODE                 = 'token';

    GTMIME_PART_BOUNDARY        = '----------0xKhTmLbOuNdArY';
    contdisp = 'Content-Disposition: form-data; name="';


// == gtSessionLink =========================================================
//
constructor gtSessionLink.Create(AOwner: TComponent);
begin
	//  RPR;
	inherited Create(AOwner);

	// -- Initialisation
	fChangingSecondaryIP := False;
	fLastCmd := 0;
	fSerialisedCmds := False;
	fCanWrite := False;

    // -- Allocate space for the receive buffer
    fRecvBuffer  := TStringList.Create;

	// -- Initialisation of methods
	OnWrite 	 := ProcessBufferedWrites;
	OnConnecting := ProcessConnecting;
	OnConnect  	 := ProcessConnected;
	onDisconnect := ProcessDisconnect;
	onError 	 := ProcessError;
	onRead 		 := ProcessRead;

end;

destructor gtSessionLink.Destroy;
begin

    // -- Destroy the receive buffer
    fRecvBuffer.Destroy;

	inherited Destroy;
end;

procedure gtSessionLink.ServiceQueue;
begin
	// -- Tell ourself that we have something to do
	PostMessage(Socket.Handle,CM_SOCKETMESSAGE,0,GTSESSION_PROCESSQUEUE_L);
end;

procedure gtSessionLink.fsm(EventData : gtSessionEvent);
var
	EventHandled :Boolean;
	myEvent : gtSessionEvent;
	done1	: Boolean;

	function GetEvents(var anEvent : gtSessionEvent):Boolean;
	begin
		if not done1 then
		begin
			Result := true;
			done1 := true;
		end
		else
			Result := false;
	end;

begin

    // -- test code
	myEvent := EventData;
	done1:=false;

    // -- Whilst there are events to process
    while GetEvents(myEvent) do
    begin

        case CurrentState of

            gtsInactive:		// -- Inactive or closed
                                EventHandled := EventRunInactive(myEvent);
            gtsConnecting:		// -- Connecting
                                EventHandled := EventRunConnecting(myEvent);
            gtsWaitLoginRsp:	// -- Awaiting login response
                                EventHandled := EventRunLoginResponse(myEvent);
            gtsIdle:			// -- Logged in and idle
                                EventHandled := EventRunIdle(myEvent);
            gtsRecvPricelist:   // -- Receiving a pricelist
                                EventHandled := EventRunRecvPricelist(myEvent);
            gtsSendDoc:			// -- Sending a document
                                EventHandled := EventRunSendDoc(myEvent);
            gtsRecvDoc:			// -- Receiving a document
                                EventHandled := EventRunRecvDoc(myEvent);
            gtsProcCmd:			// -- Processing a command
                                EventHandled := EventRunProcCmd(myEvent);
            gtsRecvImage:       // -- Receive an image
                                EventHandled := EventRunRecvImage(myEvent);
            gtsRecvNewList:     // -- Receiving the list of documents
                                EventHandled := EventRunRecvNewList(myEvent);
            gtsDocStatusChg:    // -- Receiving a response to a document update request
                                EventHandled := EventRunRecvStatusChg(myEvent);
            gtsError:			// -- In an error condition - disconnected
                                EventHandled := EventRunError(myEvent);
        end;

        // -- Run the default event handler if neccessary
        if not EventHandled then
            EventDefaultHandler(myEvent);

    end;

end;

procedure gtSessionLink.ProcessNextCommand(var aMsg : TMsg);
begin
    MessageDlg('ProcessNextCommand',mtError,[mbOk],0);
end;

// -- Builds a web page with fields that is the basis for posting
procedure gtSessionLink.BuildTemplateWebForm(NativeCommand : String; var aStream : TMemoryStream);

    // -- A little helper function
    procedure swrite(const S : PChar);
    var
        l : Integer;
    begin
        l := Length(S);
        aStream.Write(S^,l);
    end;

	function TranslateCmdToAction(NativeCmd : String):String;
	begin
		if NativeCommand = GTLINK_COMMAND_LOGIN then
			Result := GT_HTTPOPCODE_LOGIN
        else if NativeCommand = GTLINK_COMMAND_WHEREIS then
            Result := ''
        else if NativeCommand = GTLINK_COMMAND_CATALOG  then
            Result := ''
        else if NativeCommand = GTLINK_COMMAND_OPENCHAT  then
            Result := ''
        else if NativeCommand = GTLINK_COMMAND_CLOSECHAT  then
            Result := ''
        else if NativeCommand = GTLINK_COMMAND_LISTNEWDOCS  then
            Result := ''
        else if NativeCommand = GTLINK_COMMAND_SENDDOC then
			Result := ''
		else if NativeCommand = GTLINK_COMMAND_SENDIMAGE then
            Result := ''
        else if NativeCommand = GTLINK_COMMAND_TAKE  then
            Result := GT_HTTPOPCODE_UPLOAD_DOC
        else if NativeCommand = GTLINK_COMMAND_LOGIN  then
            Result := ''
        else if NativeCommand = GTLINK_COMMAND_CHG_STATUS  then
            Result := ''
        else if NativeCommand = GTLINK_COMMAND_RESET then
            Result := ''
    end;

var
    s,cmd : String;
begin
    // -- Set the content type so that it can be processed
    httpcli1.ContentTypePost := 'multipart/form-data; boundary=' + GTMIME_PART_BOUNDARY;

s := nl + '------------0xKhTmLbOuNdArY' + nl +
'Content-Disposition: form-data; name="token"' + nl +
nl +
TranslateCmdToAction(NativeCommand) + nl +
// 'C53921305' {TranslateCmdToAction(NativeCommand)}  + nl +
'------------0xKhTmLbOuNdArY' + nl +
'Content-Disposition: form-data; name="' + GT_HTTP_accountidfield + '"' + nl +
nl +
fUserID + nl +
'------------0xKhTmLbOuNdArY' + nl +
'Content-Disposition: form-data; name="' + GT_HTTP_accountpassfield + '"' + nl +
nl +
fPassword + nl +
'------------0xKhTmLbOuNdArY' + nl;

//    aStream.LoadFromFile('x:\httpfileinput.txt');
    swrite(PChar(s));
    Exit;

    swrite(GTMIME_PART_BOUNDARY);
    swrite(Pchar(contdisp + 'token' + '"' + #10 + #10 + 'C52987505' + #10));

    // -- Account code
    swrite(GTMIME_PART_BOUNDARY);
//    swrite(Pchar(contdisp + accountidfield + '"' + #13 + #13 + fUserID + #13));

    // -- Password
    swrite(GTMIME_PART_BOUNDARY);
//    swrite(PChar(contdisp + accountidfield + '"' + #13 + #13 + fPassword + #13));

end;

procedure gtSessionLink.AddDocumentToWeb(var aStream : TMemoryStream; myDoc : GTDBizDoc);

    // -- A little helper function
    procedure swrite(S : String);
    begin
        aStream.Write(S,Length(S));
    end;

var
    xc : Integer;
begin

    // -- Header
    swrite(GTMIME_PART_BOUNDARY);
    swrite('Content-Disposition: form-data; name="file"; filename="' + IntToStr(myDoc.DocumentNumber) + '"' + #13);
    swrite('Content-Type:' + 'Application/PreisShare' + #13 + #13);

    // -- Body
    for xc := 0 to myDoc.XML.Count-1 do
    begin
        // -- Write the line
        swrite(myDoc.XML.Strings[xc] + #13);
    end;

end;

function gtSessionLink.GetNextLine(var L : String):Boolean;
begin
    // --
    if (fRecvBuffer.Count = 0) then
        Result := False
    else begin
        // -- Return the first line from the buffer
        L := fRecvBuffer.Strings[0];
        fRecvBuffer.Delete(0);

		Result := True;
    end;
end;

// -- These handlers are the completions
// -- gtSessionLink.---------------------------------------------------------
procedure gtSessionLink.CompleteRecvImage;
begin
end;
// -- gtSessionLink.---------------------------------------------------------
procedure gtSessionLink.CompleteGetPricelist;
begin
end;
// -- gtSessionLink.---------------------------------------------------------
procedure gtSessionLink.CompleteRecvDocument(CommandResult : String);
begin
end;
procedure gtSessionLink.CompleteGetNewDocList(CommandResult : String);
begin
end;
// -- gtSessionLink.---------------------------------------------------------
procedure gtSessionLink.CompleteSendDocument;
begin
end;

// -- gtSessionLink.---------------------------------------------------------
//
function gtSessionLink.EventRunInactive(anEvent : gtSessionEvent): Boolean;
begin
	Result := False;
	case anEvent.EventType of
		gteOpenConnection:	// -- Connection is now open
							;
		gteDropConnection:	// -- Connection is dropped
							;
		gteWriteEnable:		// -- Channel open for writing
							;
		gteWriteDisable:	// -- Channel closed for writing
							;
		gteReceivedData:	// -- Data was received and needs to be processed
							;
		gteTimerExpired:	// -- A timer has expired
							;
	end;
end;

// -- gtSessionLink.---------------------------------------------------------
//
function gtSessionLink.EventRunConnecting(anEvent : gtSessionEvent):Boolean;
    function HandleConnectError:Boolean;
    begin
        // -- Save the error text for later
        fLastError := anEvent.Data;
        ChangeState(gtsError);

        // -- Fire off the error method
        if Assigned(fOnLinkError) then
            fOnLinkError(Self,'Connection',anEvent.Data);

        Result := true;
    end;
begin
	Result := False;
	case anEvent.EventType of
		gteOpenConnection:	// -- Connection is now open
                            ChangeState(gtsWaitToWrite);
		gteDropConnection:	// -- Connection is dropped
                            Result := HandleConnectError;
        gteCommsError:      // -- A Connection error
							Result := HandleConnectError;
		gteWriteEnable:		// -- Channel open for writing
							;
		gteWriteDisable:	// -- Channel closed for writing
							;
		gteReceivedData:	// -- Data was received and needs to be processed
							;
		gteTimerExpired:	// -- A timer has expired
							;
	end;
end;

// -- gtSessionLink.---------------------------------------------------------
//
function gtSessionLink.EventRunLoginResponse(anEvent : gtSessionEvent):Boolean;

	function ProcessLoginResponse:Boolean;
	var
		markA 	: HECMLMarker;
		rc,xc,tid	: Integer;
		s,d,L		: String;
	begin
        // -- Pull out our command response
        for xc := 1 to fRecvBuffer.Count do
		begin
            // -- Read out a line
            L := fRecvBuffer.Strings[xc-1];

            if (L[1] = RO_CMDRESP) then
			begin
                fRecvBuffer.Delete(xc-1);
                break;
            end

        end;

        // -- Check the response by the other system
		if (L <> '') and (L[1] = RO_CMDRESP) then
        begin
			markA := HECMLMarker.Create;

            // -- Add our data
            markA.MsgLines.Add(L);

            // -- Initialisation
            fChangingSecondaryIP := False;

            // -- Read the response code
			rc := MarkA.ReadIntegerField(GTLINK_RESPONSE_CODE,-1);
			s  := MarkA.ReadStringField(GTLINK_RESPONSE_TEXT);
			if (rc = 0) then
			begin

				Result := True;

				// -- Run the user event to notify that the connection was made
				CompleteCommand(rc,s);

				// -- See if we have been given a TraderID to store
				tid := MarkA.ReadIntegerField(GTD_LGN_ELE_CONNECTION_ID,-1);
				if (tid <> -1) then
				begin
					if (Assigned(fOnNewConnectionID)) then
						fOnNewConnectionID(Self,GTL,tid,fPassword)
					//else
					//	Documents.SaveTraderAccessInfo(fDocuments.Trader_ID,tid,Password);
				end;

            end
            else if (rc = -100) then
            begin

        		Result := True;

                // -- We have to change to a different IP Address
                d := MarkA.ReadStringField('IP_Address');
				if (d <> '') then
                begin
                    // -- Close this socket down, try to go up
                    //    on the new address
                    Active := False;
                    Address := d;

                    d := MarkA.ReadStringField('Port');
                    if (d <> '') then
                        Port := StrToInt(d);

                    PerformLogin;

                end
                else
    				CompleteCommand(rc,s);
			end
			{
			else if (rc = GTD_LOGIN_REFUSED) then
			begin
                // -- ALL SERVER ERRORS HANDLED HERE
            	fcmdPending := False;

                // -- Save the authentication error so that it gets displayed
                fLastError := s;

                // -- Change to the error state because we couldn't get in
                ChangeState(gtsError);

				CompleteCommand(rc,s);

                // -- Fire off a user event
                if Assigned(fOnLinkError) then
                begin
                    fOnLinkError(Self,'Login',s);
                end;

                result := False;
			end
            }
            else begin
                // -- ALL SERVER ERRORS HANDLED HERE
            	fcmdPending := False;

				// -- Save the authentication error so that it gets displayed
                fLastError := s;

                // -- Change to the error state because we couldn't get in
				ChangeState(gtsError);

                // -- Fire off a user event
                if Assigned(fOnLinkError) then
                begin
                    fOnLinkError(Self,GTD_ERROR_LOGIN_REFUSED,s);
                end;

				// -- For some reason our connection failed
				if Assigned(fOnUserInformation) then
					fOnUserInformation(Self,'','Login at ' + fRemoteGTL + ' : ' + fLastError,0,0);

				CompleteCommand(rc,s);

                result := False;

            end;
            {
            else begin
                // -- Run the user event to notify that the connection was made
				CompleteCommand(rc,s);
            end;
            }

			markA.Destroy;

		end;

	end;


begin
	Result := False;
	case anEvent.EventType of
		gteOpenConnection:	// -- Connection is now open
							;
		gteDropConnection:	// -- Connection is dropped
							if fChangingSecondaryIP then
								Result := True
							else
								ChangeState(gtsInactive);
		gteWriteEnable:		// -- Channel open for writing
							;
		gteWriteDisable:	// -- Channel closed for writing
							;
		gteReceivedData:	begin
								// -- Data was received and needs to be processed
								Result := ProcessLoginResponse;

								if Result then
								begin
									// -- Increment our connection count ?
									// ChangeState(gtsIdle);

									// -- We are now connected
									if Assigned(fOnConnect) then
										fOnConnect(Self,'', 'Connect', '');
								end
								else begin
									// -- We got an error

									// This section is not quite true,
									// as we may be waiting for the whole
									// lot of data to come through
									{
									if Assigned(fOnLinkError) then
										fOnLinkError(Self,'Error', fLastError);
									}
								end;

								// -- We are telling the caller whether we
                                //    handled this even, which is true
                                Result := True;
                            end;
        gteOpComplete:      // -- We have been signalled that the operation is complete
                            begin
                                // -- I guess we have to change state
                                ChangeState(gtsIdle);
								Result := True;
                            end;
		gteTimerExpired:	// -- A timer has expired
							;
	end;

end;

// -- gtSessionLink.---------------------------------------------------------
//
function gtSessionLink.EventRunIdle(anEvent : gtSessionEvent):Boolean;

    // -- Reads the next command from the command queue
    function ProcessNextCommand:Boolean;
    begin

        // -- If we're not currently doing anything
        if (fCmdPending = False) and (fCommandList <> '') then
        begin

            // -- Pop the next command from the queue
            fParams := Parse(fCommandList,#13);
            fCommand := Parse(fParams,' ');

            // --
            fCmdPending := True;
            fCmdCancelled := False;

            if fCommand = GTSESSION_CMD_CLEAR then
            begin
                // -- Clear the display
                InitiateClearDisplay(fParams);
            end
            else if fCommand = GTSESSION_CMD_DIAL then
			begin
                // -- Dial
                InitiateDial(fParams);
            end
            else if fCommand = GTSESSION_CMD_HANGUP then
            begin
                // -- Hangup the connection
                InitiateHangup(fParams);
            end
            else if fCommand = GTSESSION_CMD_OPENLINK then
            begin
                // -- Open the link
                InitiateOpenLink(fParams);
            end
            else if fCommand = GTSESSION_CMD_CLOSELINK then
            begin
                // -- Close the link
                InitiateCloseLink(fParams);
            end
			else if fCommand = GTSESSION_CMD_CHECKCERT then
            begin
                // -- Check the certificate
                InitiateCheckCertificate(fParams);
            end
            else if fCommand = GTSESSION_CMD_RESOLVEIP then
            begin
                InitiateResolveLinkIP(fParams);
            end
            else if fCommand = GTSESSION_CMD_CHKPRICELIST then
            begin
                InitiateCheckPricelist(fParams);
            end
            else if fCommand = GTSESSION_CMD_NOTIFYDOCSTAT then
            begin
                InitiateDocStatusChg(fParams);
            end
            else if fCommand = GTSESSION_CMD_GETNEWDOCLIST then
            begin
				InitiateGetNewDocList(fParams);
            end
			else if fCommand = GTSESSION_CMD_GETIMAGE then
            begin
                InitiateGetImage(fParams);
            end
            else if fCommand = GTSESSION_CMD_CLOSEWINDOW then
            begin
                InitiateCloseWindow(fParams);
            end
            else if fCommand = GTSESSION_CMD_SENDDOCUMENT then
            begin
                InitiateSendDocument(fParams);
            end
            else if fCommand = GTSESSION_CMD_RECVDOCUMENT then
            begin
                InitiateRecvDocument(fParams);
            end
            else if fCommand = GTSESSION_CMD_OPENCHATLINK then
			begin
                InitiateOpenChatLink(fParams);
            end
            else if fCommand = GTSESSION_CMD_CLOSECHATLINK then
            begin
                InitiateCloseChatLink(fParams);
            end
            else if fCommand = GTSESSION_CMD_SENDCHATLINE then
            begin
                InitiateSendChatLine(fParams);
            end
            else if fCommand = GTSESSION_CMD_CHECKCHATSTAT then
            begin
                InitiateCheckChatStatus(fParams);
            end
            else if fCommand = GTSESSION_CMD_TRADERSEARCH then
            begin
                InitiateTraderSearch(fParams);
            end
			else if fCommand = GTSESSION_CMD_PRODUCTSEARCH then
            begin
                InitiateProductSearch(fParams);
            end
            else if fCommand = GTSESSION_CMD_CHECKAVAIL then
            begin
                InitiateProductAvail(fParams);
            end;
        end;

        Result := True;

    end;

begin
	Result := False;
	case anEvent.EventType of
		gteDropConnection:	// -- Connection is dropped
							begin
								fLastError := 'Disconnected';
								ChangeState(gtsInactive);
//								if Assigned(fOnDisconnect) then
//									fOnDisconnect(Self,'','Disconnect','Disconnected');
							end;
		gteTimerExpired:	// -- A timer has expired
							;
		gteHaveCommand:     Result := ProcessNextCommand;
		gteOpComplete:      Result := ProcessNextCommand;
	end;
end;

// -- gtSessionLink.---------------------------------------------------------
//
function gtSessionLink.EventRunRecvPricelist(anEvent : gtSessionEvent): Boolean;
begin
    // -- We really can't process this so return false
    Result := False;
end;

// -- gtSessionLink.---------------------------------------------------------
//
function gtSessionLink.EventRunSendDoc(anEvent : gtSessionEvent):Boolean;
begin
	Result := False;
end;

// -- gtSessionLink.---------------------------------------------------------
function gtSessionLink.EventRunRecvImage(anEvent : gtSessionEvent):Boolean;
begin
	Result := False;
end;

// -- gtSessionLink.---------------------------------------------------------
//
function gtSessionLink.EventRunRecvDoc(anEvent : gtSessionEvent):Boolean;
begin
    // -- Tell the caller that we did not process here
    Result := False;
end;
// -- gtSessionLink.---------------------------------------------------------
function gtSessionLink.EventRunRecvNewList(anEvent : gtSessionEvent):Boolean;
begin
    // -- Tell the caller that we did not process here
    Result := False;
end;
//
function gtSessionLink.EventRunProcCmd(anEvent : gtSessionEvent):Boolean;
begin
	Result := False;
	case anEvent.EventType of
		gteOpenConnection:	// -- Connection is now open
							;
		gteDropConnection:	// -- Connection is dropped
							;
		gteWriteEnable:		// -- Channel open for writing
							;
		gteWriteDisable:	// -- Channel closed for writing
							;
		gteReceivedData:	// -- Data was received and needs to be processed
							;
		gteTimerExpired:	// -- A timer has expired
							;
	end;
end;
// -- gtSessionLink.---------------------------------------------------------
function gtSessionLink.EventRunRecvStatusChg(anEvent : gtSessionEvent):Boolean;
begin
    Result := False;
end;
// -- gtSessionLink.---------------------------------------------------------
//
function gtSessionLink.EventRunError(anEvent : gtSessionEvent):Boolean;
begin
	Result := False;
	case anEvent.EventType of
		gteOpenConnection:	// -- Connection is now open
							;
		gteDropConnection:	// -- Connection is dropped
							;
		gteWriteEnable:		// -- Channel open for writing
							;
		gteWriteDisable:	// -- Channel closed for writing
							;
		gteReceivedData:	// -- Data was received and needs to be processed
							;
		gteTimerExpired:	// -- A timer has expired
							;
	end;
end;

function gtSessionLink.EventDefaultHandler(anEvent : gtSessionEvent): Boolean;

    // -- Process participation notification
	procedure ProcessParticipationNotification;
    begin
    end;

    procedure ProcessDocStatus(L : String);
    var
		markA 	  : HECMLMarker;
        dno       : String;
	begin
		markA := HECMLMarker.Create;

		// -- Add our data
		markA.MsgLines.Add(L);

        // -- we now need to post a request to read the status of this document
        dno := markA.ReadStringField(GTDOCUPD_NTFN_DOCID);

        if dno <> '' then
        begin
            // -- Add the command to the queue
            AddCommand(GTSESSION_CMD_NOTIFYDOCSTAT + ' ' + dno);
        end;

		markA.Destroy;

    end;

    procedure ProcessChatText(L : String);
    var
        eventcode,chatline,
        Originator,Department,ShortStatus : String;
		markA 	  : HECMLMarker;
	begin
		markA := HECMLMarker.Create;

		// -- Add our data
		markA.MsgLines.Add(L);

		// -- Read the response code
		eventcode := MarkA.ReadStringField(GTCHAT_ELE_EVENT);
        Originator  := MarkA.ReadStringField(GTCHAT_ELE_ORIGINATOR);
        Department  := MarkA.ReadStringField(GTCHAT_ELE_FROM_DEPT);
        if (eventcode = GTCHAT_EVENT_CHATLINE) then
        begin
            // -- We have a line of chat text
            chatline := MarkA.ReadStringField(GTCHAT_ELE_CHATMSG);
			if Assigned(fOnChatLine) then
                fOnChatLine(Self,Originator,Department,chatline);
        end
        else begin
            // -- All the other events change the status
            ShortStatus := eventcode;

            if eventcode = GTCHAT_EVENT_ACCEPT then
            begin
                Originator := MarkA.ReadStringField(GTCHAT_ELE_CALLTAKER);
            end;

            if Assigned(fOnChatStatus) then
                fOnChatStatus(Self,Originator,Department,ShortStatus);
        end;

        markA.Destroy;

    end;

    // -- Processes a notification
    procedure ProcessNotification(L : String);
    var
		gtl,eventcode,extrainfo : String;
		markA 	: HECMLMarker;
	begin
		markA := HECMLMarker.Create;

		// -- Add our data
		markA.MsgLines.Add(L);

		// -- Read the response code
		eventcode := MarkA.ReadStringField(GTLINK_NTFN_EVENTFIELD);
		if ((eventcode = GTLINK_NTFN_PARTY_JOIN) or (eventcode = GTLINK_NTFN_PARTY_LEAVE)) then
        begin
            // -- Participation notifications
    		gtl  := MarkA.ReadStringField(GTD_LGN_ELE_COMPANY_CODE);

            // -- If the event is assigned then run it
            if Assigned(fOnParticipation) then
                fOnParticipation(Self,gtl,eventcode,l);
        end else
		if (eventcode = GTLINK_NTFN_NEW_PRICELIST) then
        begin
            // -- Pricelist update
    		gtl  := MarkA.ReadStringField(GTD_LGN_ELE_COMPANY_CODE);
			if gtl = '' then
                gtl := fRemoteGTL;

            // -- If the event is assigned then run it
            if Assigned(fOnNewPricelist) then
                fOnNewPricelist(Self,gtl,Now);
        end
        else if (eventcode = GTLINK_NTFN_CALLBACK_REQ) then
        begin
            // -- Pass the callback request onto the handler
            if Assigned(fOnCallbackRequest) then
                fOnCallbackRequest(Self,gtl);
        end
        else if (eventcode = GTLINK_NTFN_NEWDOC) then
        begin

            // -- Post a command to ourselves to download any new docs
            PostCommand(GTLINK_COMMAND_LISTNEWDOCS,gtsRecvNewList);

        end;

        markA.Destroy;

	end;

    // -- Processes our input buffer leaving notifications
    //    intact
    function ExtractNotifications:Boolean;
        function GetNextNotification:String;
        var
            xc : Integer;
            L : String;
        begin
            GetNextNotification := '';
            for xc := 1 to fRecvBuffer.Count  do
            begin
                // -- Read out a line
                L := fRecvBuffer.Strings[xc-1];
                if (L[1] = RO_NOTIFICATION) or (L[1] = RO_CHATLINE) or (L[1] = RO_DOCSTATCHG) then
                begin
                    fRecvBuffer.Delete(xc-1);
                    GetNextNotification := L;
                    break;
                end;
            end;
        end;
	var
       xc : Integer;
        L : String;
        c : Char;
    begin
        // -- We have to work backwards
        L := GetNextNotification;
        while l <> '' do
        begin
            if (L[1] = RO_NOTIFICATION) then
				ProcessNotification(Copy(L,2,Length(L)-1))
			else if (L[1] = RO_CHATLINE) then
				ProcessChatText(Copy(L,2,Length(L)-1))
			else if (L[1] = RO_DOCSTATCHG) then
				ProcessDocStatus(Copy(L,2,Length(L)-1));

            // -- Make sure we read the next notification
            L := GetNextNotification;
        end;
        Result := True;
    end;

    function HandleDefaultErrors:Boolean;
	begin
		// -- Store the description of the error
		fLastError := anEvent.Data;
		Result := True;
	end;

	function HandleConnectionLoss:Boolean;
	begin
		// -- Tell the user that we have been disconnected
		if Assigned(fOnDisconnect) then
			fOnDisconnect(Self,fRemoteGTL,'Disconnect','Connection closed');

		ChangeState(gtsInactive);

		Result := True;
	end;

	procedure ClearCommandOrphans;
	begin
	end;

	function HandleHeartBeat:Boolean;
	begin
		NotifyUser('Heartbeat');
		Result  := True;
	end;

begin
	Result := False;
	case anEvent.EventType of
		gteOpenConnection:	// -- Connection is now open
							;
		gteDropConnection:	// -- Connection is dropped
							Result := HandleConnectionLoss;
		gteCommsError:      // -- A line error occurred
							Result := HandleDefaultErrors;
		gteWriteEnable:		// -- Channel open for writing
							;
		gteWriteDisable:	// -- Channel closed for writing
							;
		gteReceivedData:	// -- Data was received and needs to be processed
							result := ExtractNotifications;
		gteTimerExpired:	// -- A timer has expired
							;
		gteHeartBeat:		result := HandleHeartBeat;
	end;
end;

procedure gtSessionLink.ProcessBufferedWrites(Sender: TObject; Socket: TCustomWinSocket);
var
	ErrorCode,rc,bs, b2s : Integer;
begin
	ErrorCode := 0;

	// -- Do we have anything to send
	while ((Length(fSendBuffer) <> 0) and (ErrorCode = 0)) do
	begin

        // -- Determine how many bytes we can send
        b2s := Length(fSendBuffer);
		if (b2s > ftx_buffer_size) then
			b2s := ftx_buffer_size;

		// -- Now send a buffer load of data
		bs := Socket.SendBuf(Pointer(fSendBuffer)^,b2s);

		// -- Check and see if we can go back to unbuffered sending
		if (bs = 0) or (bs = -1) then
			// -- unable to send that buffer load
			ErrorCode := WSAGetLastError
		else
		begin
			// -- After successfully sending our block, adjust our buffers
            fSendBuffer := Copy(fSendBuffer, 1 + bs, Length(fSendBuffer) - bs);

		end;
	end;

	// -- Do this stuff before leaving
	if (ErrorCode <> WSAEWOULDBLOCK) then
	begin
        // -- Finally we can start writing again
        fCanWrite := true;
    end;

end;

procedure gtSessionLink.NotifyDebug(TextMessage : String);
begin
    if Assigned(fOnUserInformation) then
        fOnUserInformation(Self,fRemoteGTL,TextMessage,0,0);
end;

// -- gtSessionLink.---------------------------------------------------------
procedure gtSessionLink.NotifyUser(TextMessage : String; PerCentComplete, IconIndex : Integer);
begin
    if Assigned(fOnUserInformation) then
        fOnUserInformation(Self,fRemoteGTL,TextMessage,PerCentComplete,IconIndex);
end;

// -- gtSessionLink.---------------------------------------------------------
//
procedure gtSessionLink.ProcessConnecting(Sender: TObject; Socket: TCustomWinSocket);
begin
end;

// -- gtSessionLink.---------------------------------------------------------
//
procedure gtSessionLink.ProcessConnected(Sender: TObject; Socket: TCustomWinSocket);

	// -- This procedure reads the output buffer size
	procedure readOutputBufferSize;
	var
		Len: Integer;
		OldOpenType : Integer;
        s : String;
	begin
		Len := SizeOf(OldOpenType);
		if (0 = getsockopt(Socket.SocketHandle, SOL_SOCKET, SO_SNDBUF, PChar(@OldOpenType),Len)) then
			ftx_buffer_size := OldOpenType
		else begin
			// -- This might cause some problems
			ftx_buffer_size := 8192;
            Len := WSAGetLastError;
            case Len of
                WSANOTINITIALISED:  s := 'A successful WSAStartup must occur before using this function.';
                WSAENETDOWN:        s := 'The network subsystem has failed.';
                WSAEFAULT:          s := 'One of the optval or the optlen arguments is not a valid part of the user address space, or the optlen argument is too small.';
                WSAEINPROGRESS:     s := 'A blocking Windows Sockets 1.1 call is in progress, or the service provider is still processing a callback function.';
                WSAEINVAL:          s := 'level is unknown or invalid';
                WSAENOPROTOOPT:     s := 'The option is unknown or unsupported by the indicated protocol family.';
                WSAENOTSOCK:        s := 'The descriptor is not a socket.';
            end;

//          MessageDlg(s,mtError,[mbOk],0);

        end;
	end;

    procedure SetNoDelay;
    var
        delayFlag : BOOL;
        rc : Integer;
    begin
        // -- Show that connection has been made
        delayFlag := False;
        rc := setsockopt(Socket.SocketHandle, IPPROTO_TCP, TCP_NODELAY, PChar(@DelayFlag),sizeof(DelayFlag));
        if rc <> 0 then
        begin
            // -- Not a serious error
        end;
    end;

var
	e : gtSessionEvent;
begin
    // -- Calculate the buffer size that we have
    readOutputBufferSize;

    SetNoDelay;

	// -- Read data from the socket
	e := gtSessionEvent.Create;
	e.EventType := gteOpenConnection;

	// -- Tell our handler that we have new data
	PostEvent(e);

	e.Destroy;

//    PostMessage(Socket.Handle,CM_PROCESSNEXTCOMMAND,0,0);

end;


// -- gtSessionLink.---------------------------------------------------------
//
procedure gtSessionLink.ProcessDisconnect(Sender: TObject; Socket: TCustomWinSocket);
var
	e : gtSessionEvent;
begin
	// -- Read data from the socket
	e := gtSessionEvent.Create;
	e.EventType := gteDropConnection;

	// -- Tell our handler that we have new data
	PostEvent(e);

	e.Destroy;
end;

// -- gtSessionLink.---------------------------------------------------------
//
procedure gtSessionLink.ProcessError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
var
	s,L : String;
	e : gtSessionEvent;
begin
    // -- Create an event
	e := gtSessionEvent.Create;

    if ErrorCode = GTSESSION_PROCESSQUEUE_S then
    begin
        // -- We need to tell our fsm to process the next command
        e.EventType := gteHaveCommand;
        e.Data		:= 'Command to Process';
    end
    else begin

        // -- Determine what sort of error was encountered
        e.EventType := gteCommsError;
        if (ErrorCode = WSAECONNREFUSED) then
            s := fRemoteGTL + ' is temporarily not accepting new connections. Please try again later.'
        else if (ErrorCode = WSAETIMEDOUT) then
            s := 'The ' + fRemoteGTL + ' could not be accessed.'
        else if (ErrorCode = WSAEHOSTUNREACH) then
            s := fRemoteGTL + ' is not reachable on this network'
        else if (ErrorCode = WSAEADDRNOTAVAIL) then
            s := fRemoteGTL + ' IP address is not available'
        else if (ErrorCode = WSAENETRESET) then
        begin
            s := 'Network Reset - Connection closed';
            e.EventType := gteDropConnection;
        end
        else if (ErrorCode = WSAECONNABORTED) then
        begin
            s := 'Connection Aborted - Link closed';
            e.EventType := gteDropConnection;
        end
        else if (ErrorCode = WSAECONNRESET) then
        begin
            s := 'Connection closed by remote';
            e.EventType := gteDropConnection;
        end
        else
            s := 'Socket Error ' + IntToStr(ErrorCode);

        {
        WSANOTINITIALISED:  s := 'A successful WSAStartup must occur before using this function.';
        WSAENETDOWN:        s := 'The network subsystem has failed.';
        WSAEFAULT:          s := 'One of the optval or the optlen arguments is not a valid part of the user address space, or the optlen argument is too small.';
        WSAEINPROGRESS:     s := 'A blocking Windows Sockets 1.1 call is in progress, or the service provider is still processing a callback function.';
        WSAEINVAL:          s := 'level is unknown or invalid';
        WSAENOPROTOOPT:     s := 'The option is unknown or unsupported by the indicated protocol family.';
        WSAENOTSOCK:        s := 'The descriptor is not a socket.';
        }

        // -- Setup the event
        e.Data		:= s;
    end;

	// -- Tell our handler that we have new data
	PostEvent(e);

	e.Destroy;

	// -- Tell our caller that we have handled the error
	ErrorCode := 0;

end;

// -- gtSessionLink.---------------------------------------------------------
procedure gtSessionLink.ProcessRcvdDataBuffer(cptr : Pointer; BuffSize : Integer);
var
	xc,p            : Integer;
	L               : String;
	e               : gtSessionEvent;
	cpos            : ^Char;
begin
	if (BuffSize=0) or not Assigned(cptr) then
		Exit;

	// -- Create a new event to send over to the FSM
	e := gtSessionEvent.Create;
	e.EventType := gteReceivedData;
//    e.Data		:= S;

	L := '';
	cpos := cptr;

	// -- Parse the inbound buffer and place each line
	//    into the input buffer
	for p := 1 to BuffSize do
	begin

		// -- Parse the buffer
		if ((cpos^ = #13) or (cpos^ = #10)) then
		begin
			// -- Add the line
			if (L <> '') then
			begin
				// -- Check for a line remainder
				if fHalfLine <> '' then
				begin
					L := fHalfLine + L;
					fHalfLine := '';
				end;
				fRecvBuffer.Add(L);
				L := '';
			end;
		end
		else
			// -- Read the next character
			L := L + cpos^;

		Inc(cpos);

	end;

	// -- Do we have a half line
	if L <> '' then
		fHalfLine := L;

	// -- Tell our handler that we have new data
	PostEvent(e);

	e.Destroy;


{
		// -- Rip out a line
		xc := Pos(#13,S);
		if xc = 0 then
			xc := Pos(#10,S);

		// -- Parse the line on line boundaries
		if xc <> 0 then
		begin
			// -- Pull out one line
			if S[1] = Chr(10) then
				L := Copy(S,2,xc-2)
			else
				L := Copy(S,1,xc-1);

			// -- Add the line
            if (L <> '') then
            begin
                // -- Check for a line remainder
                if fHalfLine <> '' then
                begin
                    L := fHalfLine + L;
                    fHalfLine := '';
                end;
                fRecvBuffer.Add(L);
            end;
            // -- Adjust the buffer
            S := Copy(S,xc+1,Length(S)-(xc-1));
            AllLinesDone := False;
        end
        else begin
            fHalfLine := S;
            AllLinesDone := True;
        end;

    end;

	// -- Tell our handler that we have new data
	PostEvent(e);

	e.Destroy;
}

end;

// -- gtSessionLink.---------------------------------------------------------
//
procedure gtSessionLink.ProcessRead(Sender: TObject; Socket: TCustomWinSocket);
var
	InBuff        : String;
begin
	// -- Read data from the socket
	InBuff := Socket.ReceiveText;

    ProcessRcvdDataBuffer(PChar(InBuff),Length(InBuff));
end;

// -- Sending data
function gtSessionLink.SendCommand(aCmd : String; var ResultCode : Integer; var ResultDescription : String; var ExtraInfo : String):Boolean;
var
	l,r : String;
    xc  : Integer;
    markA : HECMLMarker;
begin
    if fCurrentState = gtsInActive then
    begin
        ResultCode := -56;
        ResultDescription := 'Unable to execute when not connected';
        Exit;
    end;

    // -- Quickly clear the input buffer of any leftover commands

	if fSerialisedCmds then
	begin
		// -- Increment the command number
		Inc(fLastCmd);

		// --
		l := '{' + IntToStr(fLastCmd) + '}';
	end;

    // -- Some last minute
    l := aCmd;

	// -- Build the complete command string
    PostCommand(l, gtsProcCmd);

    // -- Now wait for the result
	if GetCommandResult(fLastCmd, r, true) then
    begin
        markA := HECMLMarker.Create;

        markA.Add(r);

        // -- Decode the response codes for the caller
        ResultCode := markA.ReadIntegerField(GTLINK_RESPONSE_CODE,-1);
        ResultDescription := markA.ReadStringField(GTLINK_RESPONSE_TEXT);
        ExtraInfo := r;

        markA.Destroy;

        if fCurrentState = gtsProcCmd then
            fCurrentState := gtsIdle;

        Result := True;
    end;

end;

procedure gtSessionLink.PostCommand(aCmd : String; ChangeToState : gtSessionState; ExtraHeaderParams : String);

    procedure ClearCommandResultOrphans;
    var
        xc : Integer;
        l : String;
    begin
        // -- Work the buffer backwards
        for xc := fRecvBuffer.Count downto 1 do
        begin
            // -- Extract out one line
            l := fRecvBuffer.Strings[xc - 1];
            if l[1] = RO_CMDRESP then
            begin
                // -- Extract the original
                fRecvBuffer.Delete(xc-1);
            end;
        end;
    end;

    procedure ExtractAndSendResult;
    var
        e       : gtSessionEvent;
        I       : Integer;
        s,r     : String;
    begin

        for I := 0 to httpcli1.RcvdHeader.Count - 1 do
        begin
            s := httpcli1.RcvdHeader.Strings[I];
            if Copy(s,1,Length(GTLINK_RESPONSE_CODE))= GTLINK_RESPONSE_CODE then
                r := r + GTLINK_RESPONSE_CODE + '#=' + Copy(s,Length(GTLINK_RESPONSE_CODE)+3,Length(s)-Length(GTLINK_RESPONSE_CODE)-2) + ' ';
            if Copy(s,1,Length(GTLINK_RESPONSE_TEXT))= GTLINK_RESPONSE_TEXT then
                r := r + GTLINK_RESPONSE_TEXT + '&=' + Copy(s,Length(GTLINK_RESPONSE_TEXT)+3,Length(s)-Length(GTLINK_RESPONSE_TEXT)-2) + ' ';
        end;
        r := RO_CMDRESP + r;

        // -- Create a new event to send over to the FSM
        e := gtSessionEvent.Create;
        e.EventType := gteReceivedData;

        fRecvBuffer.Add(r);

        // -- Tell our handler that we have new data
        PostEvent(e);

        e.Destroy;
    end;

var
    l : String;
    DataOut : TMemoryStream;
    DataIn  : TFileStream;
    I       : Integer;
    UseProxy : Boolean;
    ProxyAddr : String;
    ProxyPort : String;

begin
    // -- Clear any leftover command orphans
    ClearCommandResultOrphans;

    // -- When starting a command, we haven't cancelled
    fCmdCancelled := False;
    fCommand := aCmd;

    // -- Now change over to this new state
    ChangeState(ChangeToState);

    if fProtocol = tpAsync then
    begin
        // -- Build the command and send it
        l := aCmd + #10;

        SendBufferedText(l);
    end
    else if fProtocol = tpHTTP then
    begin

        // -- Clear out the receive buffer now
        fRecvBuffer.Clear;

        l := BuildHTTPCommand(aCmd);

        try

            DataOut := TMemoryStream.Create;
            if Length(fSendBuffer) > 0 then      { Check if some data to post }
                DataOut.Write(fSendBuffer[1], Length(fSendBuffer))
            else
                DataOut.Write('----', 4);

            DataOut.Seek(0, soFromBeginning);

            httpcli1.SendStream := DataOut;
            httpcli1.RcvdStream := nil;
            httpcli1.URL        := l;
            httpcli1.Reference  := ExtraHeaderParams;

            CheckProxySettings(UseProxy,ProxyAddr,ProxyPort);
            if UseProxy then
            begin
                httpcli1.Proxy := ProxyAddr;
                httpcli1.ProxyPort := ProxyPort;
                NotifyUser('Using proxy ''' + httpcli1.Proxy + ':' + httpcli1.ProxyPort + '''')
            end;

			try

				// -- Wait for the component to be ready
				repeat
					Application.ProcessMessages;
					//Sleep(50);
				until (httpcli1.State = httpReady) or (Application.Terminated) or (fcmdCancelled);

//				httpcli1.Post;
				httpcli1.Get;

            except
                DataOut.Free;
                NotifyUser('POST Failed !');
                NotifyUser('StatusCode   = ' + IntToStr(httpcli1.StatusCode));
                NotifyUser('ReasonPhrase = ' + httpcli1.ReasonPhrase);
                Exit;
            end;

            //if httpcli1.StatusCode <> 200 then
            //    NotifyUser('Command Failed StatusCode = ' + IntToStr(httpcli1.StatusCode))
            //else
            //    NotifyUser('Command Succeeded');

            ExtractAndSendResult;

            // for I := 0 to httpcli1.RcvdHeader.Count - 1 do
            //    NotifyUser('hdr>' + httpcli1.RcvdHeader.Strings[I]);

        finally
    //        SetButtonState(TRUE);
        end;

    end;

end;

procedure gtSessionLink.SetGTL(newGTL : String);
begin
    // -- Disconnect
    if (newGTL <> fRemoteGTL) then
    begin
        // -- Deactivate if connected
        if Active then
            Active := False;

        fRemoteGTL := newGTL;
    end;
end;

procedure gtSessionLink.SendNotification(aMsg : String; var CmdNumber : Integer);
var
	l : String;
begin

	if fSerialisedCmds then
	begin
		// -- Increment the command number
		Inc(fLastCmd);

		// --
		l := '{' + IntToStr(fLastCmd) + '}';
	end;

	// -- Build the complete command string
	l := l + RO_NOTIFICATION + aMsg + #10;

	// -- Now send it out
    SendBufferedText(l);

end;

procedure gtSessionLink.SendResponse(S : String);
begin
    // -- Send this text back as a response of some sort
    SendBufferedText(RO_CMDRESP + S + #10);
end;

procedure gtSessionLink.SendBufferedText(S : String);
var
    sLen,bSent : Integer;
begin
    // -- Determine the best way to write out the data
	if fCanWrite and Socket.Connected then
    begin
        // -- Take the length of the string
        sLen := Length(S);

        // -- Try sending the text, but if it doesn't work
        //    then simply add it to the output buffer
        bSent := Socket.SendBuf(Pointer(S)^,sLen);
        if bSent = -1 then
            bSent := 0;
        if bSent < sLen then
        begin
            // -- We have to buffer unwritten characters
            fCanWrite := False;
            fSendBuffer := fSendBuffer + Copy(S,bSent+1,sLen-bSent);

            // -- Process some messages while we wait
            Application.ProcessMessages;
        end;
        
	end
    else
        // -- Simply add to the output buffer and it will be sent when ready
		fSendBuffer := fSendBuffer + S;
end;

procedure gtSessionLink.SendDataLine(l : String);
var
	d : String;
begin

	if fSerialisedCmds then
	begin
		// -- Increment the command number
		Inc(fLastCmd);

		// --
		d := '{' + IntToStr(fLastCmd) + '}';
	end;

	// -- Build the complete command string
	d := d + RO_MSGLINE + l + #10;

	// -- Now send it out
	SendBufferedText(d);

end;

// -- Receiving data
function gtSessionLink.GetDataLine(CmdNumber : Integer):String;
begin
end;

// -- Receiving data
function gtSessionLink.GetCommandResult(CmdNumber : Integer; var ResultLine : String; WaitForResult : Boolean):Boolean;

    function HaveResult(var cmdResult : String):Boolean;
    var
        xc : Integer;
        l : String;
    begin
        Result := False;
        for xc := fRecvBuffer.Count downto 1 do
        begin
            // -- Extract out one line
            l := fRecvBuffer.Strings[xc - 1];
            if l[1] = RO_CMDRESP then
            begin
                // -- Pull out the line and return it
                CmdResult := l;

                // -- Extract the original
                fRecvBuffer.Delete(xc-1);

                // -- Mark this function as successful
                Result := True;
                break;
            end;
        end;
    end;
var
    FoundResponse : Boolean;
begin
    // -- Here we are going to scan the input buffer until
    //    we have a result
    FoundResponse := HaveResult(ResultLine);

    // -- Do we have to keep looking forever ? There
    //    also should be a timeout here
    if (not FoundResponse) and (WaitForResult) then
    begin
        // -- Keep on processing for as long as possible
        while (not FoundResponse) and (not fCmdCancelled) and
              (not Application.Terminated) and (Socket.Connected) do
        begin
			// -- Pass some time
			Application.ProcessMessages;

			// -- Note, this HaveResult
			FoundResponse := HaveResult(ResultLine);
		end;
	end;

	Result := FoundResponse;

end;

// -- Loging in/out
function gtSessionLink.LogIn(GTL : String; ExtraInfo : String):Boolean;
var
	s, uid, oid, tid, ei : String;
	x,y : Integer;
begin
	// -- Logout
	if LoggedIn then
		LogOut;

	// -- Check the state before proceeding
	if not (fCurrentState in [gtsInactive,gtsError,gtsComplete]) then
		Exit;

	// -- Save the name of the crowd we are logging into
	if (fRemoteGTL <> GTL) then
	begin
		fRemoteGTL := GTL;
		Self.Active := False;
	end;

	// -- We have even more fields to add here
	ei := ExtraInfo;

	// -- Use the standard port & Address
	if Port = 0 then
		Port := 100;

	// -- Look the gtl up from the registry if we don't know it
	if fLocalGTL = '' then
		// -- Load from the registry
		GetSettingString(GTD_REG_NOD_GENERAL,GTD_REG_GTL,oid)
	else
		// -- Use the member value
		oid := fLocalGTL;

	// -- Look these values up from the registry
	if fUserID = '' then
	begin
		// -- Look in the registry for a userid
		if GetSettingString(GTD_REG_NOD_GENERAL,GTD_REG_USER_NAME,s) then
			uid := s;
	end
	else
		uid := fUserID;

	// -- This is the unique access number for this workstation
	if GetSettingString(GTD_REG_NOD_GENERAL,GTD_LGN_ELE_ACCESS_KEY,s) then
		ei := ei + ' ' + EncodeStringField(GTD_LGN_ELE_ACCESS_KEY,s);

	case SessionType of
		gtwtServer 		: begin
							tid := GTD_LGN_ACCESS_SERVER;
							if (fServerPortNumber <> 0) then
								ei := ei + EncodeIntegerField(GTD_WER_ELE_PORT_NUMBER,fServerPortNumber);
						  end;
		gtwtWorkstation : tid := GTD_LGN_ACCESS_WORKSTATION;
		gtwtViewstation : tid := GTD_LGN_ACCESS_VIEWSTATION;
	end;

	// -- Build the login string which actually needs to be saved
	fLoginData := fLoginCmd +
				  EncodeIntegerField(GTD_LGN_ELE_TRADER_ID,fTraderID) +
				  EncodeStringField(GTD_LGN_ELE_ACCESS_TYPE,tid) +
				  EncodeStringField(GTD_LGN_ELE_COMPANY_CODE,oid) +
				  EncodeStringField(GTD_LGN_ELE_COMPANY_NAME,fLocalCompanyName) +
				  EncodeStringField(GTD_LGN_ELE_MACHINE_NAME,GetMachineName) +
				  EncodeStringField(GTD_LGN_ELE_USER_NAME,GetCurrentUserName) +
				  fRegistration;

	// -- Password/password hash
	if (fpHash <> '') then
		fLoginData := fLoginData + EncodeStringField(GTD_LGN_ELE_PASSWORD_HASH,fpHash)
	else if (fPassword <> '') then
		fLoginData := fLoginData + EncodeStringField(GTD_LGN_ELE_PWORD,fPassword);

	fLoginData := fLoginData + ' ' + ei;

	// -- Now do the actual login
	result := PerformLogin;

end;

procedure gtSessionLink.LogOut;
begin

	PostCommand(GTLINK_COMMAND_QUIT,gtsComplete);

	// -- Do we need to close up
//	if (Active) and (fProtocol = tpAsync) then
//		Active := False;
end;

function  gtSessionLink.LoggedIn:Boolean;
begin
    Result := CurrentState in [gtsIdle,gtsSendDoc,gtsRecvDoc,gtsProcCmd];

    // -- Also check the protocol
    if (not Active) and (fProtocol = tpAsync) then
        Result := False;
end;

function gtSessionLink.BuildHTTPCommand(aNativeCommand : String):String;
begin
    if Copy(aNativeCommand,1,5) = 'http:' then
		Result := aNativeCommand
    else
        Result := GTLINK_URL; // + 'NOP';
end;


procedure gtSessionLink.ChangeState(NewState : gtSessionState);
var
    StateDesc   : String;
    xState      : gtSessionUserState;
begin
	fCurrentState := NewState;

	case NewState of
        gtsInactive:        begin
    							Active := False;
	    						fCanWrite := False;
                                xState    := gtusOffline;
                                StateDesc := fLastError;
                            end;
        gtsConnecting:      begin
                                if fRemoteGTL = GTD_GRIDSERVER then
                                    xState := gtusConnectXchg
                                else
                                    xState := gtusConnectPeer;
                                StateDesc := 'Connecting';
                            end;
        gtsSecConnect:      begin
                                xState := gtusConnectXchg;
                                StateDesc := 'Connecting';
                            end;
        gtsWaitLoginRsp:    begin
                                xState    := gtusAuthenticate;
                                StateDesc := 'Authenticating';
                            end;
        gtsIdle:            begin
                                xState    := gtusOnlineReady;
                                StateDesc := 'Online and Ready';
                            end;
        gtsSendDoc:         begin
                                xState    := gtusSending;
                                StateDesc := 'Sending';
                            end;
        gtsRecvDoc:         begin
                                xState    := gtusReceiving;
                                StateDesc := 'Receiving';
                            end;
        gtsProcCmd:         begin
                                xState    := gtusReceiving;
                                StateDesc := 'Processing';
                            end;
        gtsError:           begin
                                // -- This one is different
                                xState    := gtusStopped;
                                StateDesc := fLastError;
                            end;
        gtsWaitToWrite:     begin
                                // -- This one is different
                                xState    := gtusAuthenticate;
                                StateDesc := 'Connected';
                            end;
        gtsRecvPricelist:   begin
                                xState    := gtusChkPricelist;
                                StateDesc := 'Checking Pricelist';
                            end;
        gtsRecvImage:       begin
                                xState    := gtusChkPricelist;
                                StateDesc := 'Downloading Image';
                            end;
        gtsDocStatusChg:    begin
                                xState    := gtusChgDocStatus;
                                StateDesc := 'Updating Document Status';
                            end;
        gtsComplete:        begin
                                xState    := gtusComplete;
                                StateDesc := 'Complete';
                            end;
    end;

    // -- Save the State
    fUserState := xState;

    // -- Run the event
    if Assigned(fOnLinkStatus) then
    begin
        if (fRemoteGTL = GTD_GRIDSERVER) then
            // -- A Connection as a server
            fOnLinkStatus(Self,fLocalGTL,xState,StateDesc)
        else
            // -- A normal connection to a server
            fOnLinkStatus(Self,fRemoteGTL,xState,StateDesc);
    end;
    
    // -- Have the system do any work that needs to be done
    ServiceQueue;
end;

// -- gtSessionLink.ClearDisplay---------------------------------------------
//
procedure gtSessionLink.InitiateClearDisplay;
var
	xc,i 	: Integer;
	s		: String;
begin
	// -- We should do more here

	// -- We're done now
	CompleteCommand(0,'Display Cleared');

end;

// -- gtSessionLink.CmdDial--------------------------------------------------
//
procedure gtSessionLink.InitiateDial(Params : String);
begin
	// -- We're done now
	CompleteCommand(0,'Dialing Completed');
end;

// -- gtSessionLink.---------------------------------------------------------
//
procedure gtSessionLink.InitiateHangup(Params : String);
begin
	// -- We're done now
	CompleteCommand(0,'Hangup Completed');
end;

// -- gtSessionLink.---------------------------------------------------------
//
procedure gtSessionLink.InitiateOpenLink(Params : String);
begin
	// -- We're done now
	CompleteCommand(0,'Link Opened');
end;

// -- gtSessionLink.---------------------------------------------------------
//
procedure gtSessionLink.InitiateCloseLink(Params : String);
begin
    // -- Close down the link
    if fProtocol = tpAsync then
    begin
        ChangeState(gtsInactive);
        Close;
    end
    else
        ChangeState(gtsComplete);
    
	// -- We're done now
	CompleteCommand(0,'Link Closed');
end;

// -- gtSessionLink.---------------------------------------------------------
//
procedure gtSessionLink.InitiateCheckCertificate(Params : String);
begin
	// -- We're done now
	CompleteCommand(0,'Certificate Checked');
end;

// -- gtSessionLink.---------------------------------------------------------
//
procedure gtSessionLink.InitiateResolveLinkIP(Params : String);
begin
	// -- We're done now
	CompleteCommand(0,'Address resolved');
end;

// -- gtSessionLink.---------------------------------------------------------
//
procedure gtSessionLink.InitiateCheckPricelist(Params : String);
begin
	// -- We're done now
	CompleteCommand(0,'Pricelist Timestamped');
end;
// -- gtSessionLink.---------------------------------------------------------
//
procedure gtSessionLink.InitiateRecvDocument(Params : String);
begin
end;

// -- gtSessionLink.---------------------------------------------------------
//
procedure gtSessionLink.InitiateDocStatusChg(Params : String);
begin
	// -- We're done now
	CompleteCommand(0,'Document Status Changed');
end;
// -- gtSessionLink.---------------------------------------------------------
//
procedure gtSessionLink.InitiateGetNewDocList(Params : String);
begin
	// -- We're done now
	CompleteCommand(0,'Operation completed');
end;

// -- gtSessionLink.---------------------------------------------------------
//
procedure gtSessionLink.InitiateGetImage(Params : String);
begin
	// -- We're done now
	CompleteCommand(0,'Operation completed');
end;

// -- gtSessionLink.---------------------------------------------------------
//
procedure gtSessionLink.InitiateCloseWindow(Params : String);
begin
	// -- We're done now
	CompleteCommand(0,'Operation completed');
end;

// -- gtSessionLink.---------------------------------------------------------
//
procedure gtSessionLink.InitiateSendDocument(Params : String);
begin
end;

// -- gtSessionLink.---------------------------------------------------------
//
procedure gtSessionLink.InitiateOpenChatLink(Params : String);
begin
	// -- We're done now
	CompleteCommand(0,'Operation completed');
end;

// -- gtSessionLink.---------------------------------------------------------
//
procedure gtSessionLink.InitiateCloseChatLink(Params : String);
begin
	// -- We're done now
	CompleteCommand(0,'Operation completed');
end;

// -- gtSessionLink.---------------------------------------------------------
//
procedure gtSessionLink.InitiateSendChatLine(Params : String);
begin
	// -- We're done now
	CompleteCommand(0,'Operation completed');
end;

// -- gtSessionLink.---------------------------------------------------------
//
procedure gtSessionLink.InitiateCheckChatStatus(Params : String);
begin
	// -- We're done now
	CompleteCommand(0,'Operation completed');
end;

// -- gtSessionLink.---------------------------------------------------------
//
procedure gtSessionLink.InitiateTraderSearch(Params : String);
begin
	// -- We're done now
	CompleteCommand(0,'Operation completed');
end;

// -- gtSessionLink.---------------------------------------------------------
//
procedure gtSessionLink.InitiateProductSearch(Params : String);
begin
	// -- We're done now
	CompleteCommand(0,'Operation completed');
end;

// -- gtSessionLink.NotifyNewPricelist---------------------------------------
//
procedure gtSessionLink.NotifyNewPricelist(NewPricelistTime : TDateTime);
var
    i : Integer;
	s : String;
begin
	if (GTL <> '') then
	begin
		// -- Build the notification string
		s := EncodeStringField('Event',GTLINK_NTFN_NEW_PRICELIST) +
			 EncodeStringField('Recipient','*') +
			 EncodeDateTimeField('TimeStamp',NewPricelistTime) +
			 EncodeStringField(GTD_LGN_ELE_COMPANY_CODE,LocalGTL);

		SendNotification(s,i);
	end;
end;

// -- gtSessionLink.---------------------------------------------------------
//
procedure gtSessionLink.InitiateProductAvail(Params : String);
begin
	// -- We're done now
	CompleteCommand(0,'Operation completed');
end;

// -- gtSessionLink.---------------------------------------------------------
//
procedure gtSessionLink.PostEvent(EventData : gtSessionEvent);
begin
	// -- Go and do the Finite state machine
	fsm(EventData);
end;
//---------------------------------------------------------------------------
procedure gtSessionLink.AddCommand(newCmd : String);
begin
    // -- Add this command to the queue
    fCommandList := fCommandList + newCmd + #13;

    ServiceQueue;

end;

//---------------------------------------------------------------------------
procedure gtSessionLink.CompleteCommand(ExitStatus : Integer; someComment : String);
begin
	fcmdPending := False;

    if CurrentState <> gtsComplete then
    begin
        // -- If everything worked ok then we are idle now
        if ExitStatus = 0 then
            ChangeState(gtsIdle)
        else
            ChangeState(gtsError);
    end;

	// -- Process the next command
	if fCommandList <> '' then
        PostMessage(Socket.Handle,CM_SOCKETMESSAGE,ExitStatus,GTSESSION_PROCESSQUEUE_L);

end;

//---------------------------------------------------------------------------
procedure gtSessionLink.Cancel;
begin
    fCmdCancelled := True;
end;

// == gtCommunityLink =======================================================
//
constructor gtCommunityLink.Create(AOwner: TComponent);
var
	s : String;
begin
	inherited Create(AOwner);

	// -- Use the standard port
	Port := 100;

	// -- Read the address from the registry
    Address := GetExchangeAddress;

    // -- We are talking to the exchange
    fRemoteGTL := GTD_GRIDSERVER;
    fLoginCmd  := 'register ';

end;

function gtCommunityLink.UploadPricelist(DocID : Integer):Boolean;
var
    l,r : String;
    xc  : Integer;
begin
	// -- Check that we are in the right state
//	if (DocID <> -1) and not fDocuments.Load(DocID, fWorkingDoc) then
//	begin
//		CompleteCommand(GTD_ERROR_LOAD_DOCUMENT,GTD_MESSG_LOAD_DOCUMENT);
//		Exit;
//	end;

    fWorkingDoc.Clear;
    if (DocID <> -1) then
        fDocuments.Load(DocID,fWorkingDoc)
    else
        fWorkingDoc.XML.LoadFromFile(ExtractFilePath(Application.ExeName) + GTD_CURRENT_PRICELIST);

	if fSerialisedCmds then
	begin
		// -- Increment the command number
		Inc(fLastCmd);

		// --
		l := '{' + IntToStr(fLastCmd) + '}';
	end;

	// -- When starting a command, we haven't cancelled
	fCmdCancelled := False;

	// -- Build the complete command string
	l := GTLINK_COMMAND_SENDCATALOG + ' Body_Line_Count#=' + IntToStr(fWorkingDoc.XML.Count) + ',' + fDocuments.ExtractDocDetails(fWorkingDoc);

	// -- The sending process is slightly different for http/async
	//    If it async then the lines are sent after the command
	//    whereas with http they need to be bundled together.
	if fProtocol = tpAsync then
	begin

		// -- Use our function to send out the text
		PostCommand(l,gtsSendDoc);

		// -- Assemble the message into chunks as close as possible
		//    to the size of the output buffer
        r := '';
        for xc := 1 to fWorkingDoc.XML.Count do
        begin

            // -- Load a line
            l := fWorkingDoc.XML.Strings[xc-1];

            // -- Send what we have
            SendDataLine(l);

            // -- Be good and let other stuff go through
            //    and check if we have been cancelled
            if (xc mod 100) = 0 then
            begin
				Application.ProcessMessages;
                //Sleep(0);
            end;

            if fCmdCancelled then
                break;

        end;
    end;
end;

function gtSessionLink.PerformLogin:Boolean;
var
	i : Integer;
	l, ResultDescription, ExtraInfo : String;

	function PostLoginViaHTTP(d : String):Boolean;
	var
		DataOut : TMemoryStream;
		DataIn  : TMemoryStream;
		Buf     : String;
		I       : Integer;
		UseProxy : Boolean;
		ProxyAddr : String;
        ProxyPort : String;
    begin
        Result := False;

        try
            // -- Create a memory stream to write our web form to
            DataIn  := TMemoryStream.Create;
            DataOut := TMemoryStream.Create;

            // -- Fill in our form
            BuildTemplateWebForm(GTLINK_COMMAND_LOGIN,DataOut);

            // -- Check that our proxy is setup ready to go
            CheckProxySettings(UseProxy,ProxyAddr,ProxyPort);
            if UseProxy then
            begin
                httpcli1.Proxy := ProxyAddr;
                httpcli1.ProxyPort := ProxyPort;
//              NotifyUser('Using proxy ''' + httpcli1.Proxy + ':' + httpcli1.ProxyPort + '''')
            end;

            // -- Prepare some other values
			DataOut.Seek(0, soFromBeginning);
            httpcli1.SendStream := DataOut;
            httpcli1.RcvdStream := DataIn;
			httpcli1.URL        := 'http://www.computergrid.net/cgi-bin/computergrid1?' +
								   GTCGIOPCODE + '=' + GT_HTTPOPCODE_LOGIN + ';' +
								   GT_HTTP_accountidfield + '=' + fUserID + ';' +
								   GT_HTTP_accountpassfield + '=' + fPassword;

			try

				ChangeState(gtsWaitLoginRsp);

				// -- Let the user know what we are trying to do
				NotifyUser('Logging in to Grid');

				repeat
					Application.ProcessMessages;
					//Sleep(50);
				until (httpcli1.State = httpReady) or (Application.Terminated) or (fcmdCancelled);

				// -- Now post
				httpcli1.Get;

				// -- Here we really should validate our login
				//    but for now we'll just pretend that we're in
				if httpcli1.StatusCode = 200 then
				begin
					Result := True;
				end;

			except
				// -- If that didn't work...
				ChangeState(gtsError);
				if httpcli1.StatusCode = 500 then
                    // -- This is an "Internal Server Error"; somebody stuffed the CGI script on the server
                    NotifyUser('Service is down - try again later')
                else if httpcli1.StatusCode <> 200 then
                    NotifyUser('Login Failed [' + IntToStr(httpcli1.StatusCode) + '] ' + httpcli1.ReasonPhrase)
				else
                    NotifyUser('Login Failed ');

            end;

        finally
            // -- We can assume that it came back from the post
    //        SetButtonState(TRUE);
		end;
    end;

begin
    fCmdCancelled := False;
    Result := False;

    // --
    if fProtocol = tpAsync then
    begin

        // -- Turn the socket on if it's not on
        if not Self.Active then
		begin
            fLastError := '';

            ChangeState(gtsConnecting);

            if Address = '' then
            begin
                // -- Definitely can't connect without an address
                ChangeState(gtsError);
                fLastError := 'No GTL specified';
				Exit;
			end;

			// -- We must open the socket
			Active := True;

			// -- Now get in a hopefully non-endless loop until connected
			while (not Socket.Connected) and (not Application.Terminated)
				  and (fCurrentState = gtsConnecting) and (not fCmdCancelled)
			do
			begin
				Application.ProcessMessages;
			end;
		end;

		if not Socket.Connected then
		begin
			// -- For some reason our connection failed
			if Assigned(fOnUserInformation) then
				fOnUserInformation(Self,'','Unable to connect to ' + fRemoteGTL + ' at ' + Host + ' on ' + IntToStr(Port),0,0);

			ChangeState(gtsError);
			Exit;
		end
		else
		if Assigned(fOnUserInformation) then
			fOnUserInformation(Self,'','Connect to ' + fRemoteGTL + ' on ' + IntToStr(Port),0,0);

		// -- Build the complete command string
		l := l + fLoginData;

		// -- Go into a state where we await login results
		PostCommand(l,gtsWaitLoginRsp);

		// -- Wait for the response
		// -- Now get in a hopefully non-endless loop until connected
		while (not Application.Terminated) and (not fCmdCancelled)
			  and (fCurrentState = gtsWaitLoginRsp)
		do
        begin
            Application.ProcessMessages;
        end;

        // -- If we are in idle state then we have connected
		if CurrentState = gtsIdle then
		begin
			Result := True;
			// -- For some reason our connection failed
			if Assigned(fOnUserInformation) then
				fOnUserInformation(Self,'','Logged in to ' + fRemoteGTL + ' at ' + Address + ':' + IntToStr(Port),0,0);
		end;
	end
	else begin
        // -- HTTP style login
        HttpCli1 := THttpCli.Create(Self);

        // -- Setup all the methods
		HttpCli1.OnDocBegin := HttpCli1DocBegin;
        HttpCli1.OnDocEnd := HttpCli1DocEnd;

        Result := PostLoginViaHTTP(fLoginData);

    end;

end;

//---------------------------------------------------------------------------
{
function gtCommunityLink.LogIn(PricelistTime : TDateTime; ExtraInfo : String):Boolean;
var
    s,t, CatList : String;
begin
    Result := False;

    // -- Modify the Extrainfo parameter
	s := ExtraInfo;

    // -- From the registry read the list of categories
   	if GetSettingString(GTD_REG_NOD_GENERAL,GTD_REG_KEY_CATEGORIES,t) then
    	CatList := t;

    // -- We have to add some parameters to use this method
    if PricelistTime <> 0 then
        s := s + ' Pricelist_Timestamp@=' + FormatDateTime(GTD_DATETIMESTAMPFORMAT,PricelistTime);
    if CatList <> '' then
        s := s + ' Category_List&="' + CatList + '"';

	// -- Check that we have an address as we may not
    if Address = '' then
        Address := GetExchangeAddress;

    if Port = 0 then
    	Port := 100;

	Result := inherited Login(GTD_GRIDSERVER, S);

end;
}
//---------------------------------------------------------------------------
function gtCommunityLink.LogIn(myRegistry : GTDDocumentRegistry):Boolean;
var
	ei,s,t, CatList : String;
begin
	Result := False;

	// -- Load some basic details
	if Assigned(myRegistry) then
	begin
		// -- Load some details from the registry
		Trader_ID := myRegistry.GetCustomerNumber;
		LocalOrganisation := myRegistry.GetCompanyName;
		Password  := myRegistry.GetCustomerPassword;
		LocalGTL  := myRegistry.GetGTL;

		if Trader_ID = -1 then
		begin

			if Password = '' then
				Password := FloatToStr(Now);

			// -- These should be the minumum field requirements
			ei := ei + ' ' + EncodeStringField(GTD_LGN_ELE_ADDRESS_LINE_1,myRegistry.GetAddress1);
			ei := ei + ' ' + EncodeStringField(GTD_LGN_ELE_TOWN,myRegistry.GetCity);
			ei := ei + ' ' + EncodeStringField(GTD_LGN_ELE_STATE_REGION,myRegistry.GetState);
			ei := ei + ' ' + EncodeStringField(GTD_LGN_ELE_COUNTRYCODE,myRegistry.GetCountryCode);

			RegistrationDetails := ei;

		end;

		// -- We have to add some parameters to use this method
		s := s + ' Pricelist_Timestamp@=' + FormatDateTime(GTD_DATETIMESTAMPFORMAT,myRegistry.GetLatestPriceListDateTime);
		if CatList <> '' then
			s := s + ' Category_List&="' + CatList + '"';
	end;

	// -- Check that we have an address as we may not
	if Address = '' then
		Address := GetExchangeAddress;

	if Port = 0 then
		Port := 100;

//	Result := inherited Login(GTD_GRIDSERVER, S);
	Result := inherited Login(-1, S);

end;
//---------------------------------------------------------------------------
function gtCommunityLink.GetExchangeAddress:String;
var
	s : String;
begin
	// -- Check for the address in the registry and if thats
    //    not it then use the hardwired constant
   	if GetSettingString(GTD_REG_NOD_GENERAL,GTD_REG_COM_SERVERIP,s) then
        Result := s
    else
        Result := GTD_DFLT_BIZEXCHANGE;

    // -- Check that we actually got a result back
    if Result = '' then
        Result := GTD_DFLT_BIZEXCHANGE;

end;

//---------------------------------------------------------------------------
function gtCommunityLink.DetermineOptimumHost:String;
begin
	Socket.SendText('whosbest' + #13);

	Result := Socket.ReceiveText;
end;

//---------------------------------------------------------------------------
function gtCommunityLink.CheckPublicKey(ResultCode : Integer; var ResultDescription : String):Boolean;
var
    Public_Key, rs, ei : String;
    rc : Integer;
begin
	// -- Check to see if we have a public key
	if not GetSettingString(GTD_REG_NOD_GENERAL,'Public_Key',Public_Key) then
	begin
        // -- If we aren't connected then we can go no further
        if Socket.Connected then
            Result := RequestNewPublicKey(rc,rs,ei);
    end;

    // -- If we were successful
    if Result then
    begin
        ResultCode := rc;
        ResultDescription := rs;
        Result := True;
    end;

end;

// -- Keyring functions
function gtCommunityLink.RequestNewPublicKey(ResultCode : Integer; var ResultDescription : String; var ExtraInfo : String):Boolean;
var
    s,n,gtl : String;
begin
    GetSettingString(GTD_REG_NOD_GENERAL,GTD_REG_COMPANY_NAME,n);

    GetSettingString(GTD_REG_NOD_GENERAL,GTD_REG_GTL,gtl);

    // -- Create the text to send
    s := 'create certificate Company_Name&=' + EncodeString(n,'&');

    // -- Now send the command
    Result := SendCommand(s, ResultCode,ResultDescription,ExtraInfo);

    { This code will decode the result
		if rc = 0 then
		begin
			// -- Read our public key
			Public_Key := markA.ReadStringField('Certificate_ID');

			// -- Save our public key
			if Public_Key <> '' then
				SaveSettingString(GTD_REG_NOD_GENERAL,'Public_Key',Public_Key);

			lsvProgress.Items[PROGRESS_ITEM_CHKKEY].StateIndex := stTick;

			CompleteCommand(0,'Public key obtained for ' + frmConfig.txtCompany.Text);

		end
		else begin
			lsvProgress.Items[1].StateIndex := stFailed;

			// -- We failed to obtain a public key
			CompleteCommand(-856,'Unable to obtain Public key - ' + MarkA.ReadStringField('Response'));
		end;
    }
end;

//---------------------------------------------------------------------------
procedure gtCommunityLink.SendLineTo(Destination, L : String);
var
    S : String;
begin
    // -- Build the line
    S := RO_REROUTE + #9 + Destination + #9 + fLocalGTL + #9 + L;

    // -- Now use the primative to send the data
    SendDataLine(L);

end;

//---------------------------------------------------------------------------
function gtCommunityLink.RequestNewPrivateKey(GTL : String; var Private_Key : String):String;
begin
end;

// -- Directory functions
//---------------------------------------------------------------------------
function gtCommunityLink.WhereIs(GTL :String; var ResultCode : Integer; var ResultDescription : String):String;
var
	s, rs,ei : String;
	rc : Integer;
	MarkA : HECMLMarker;
begin
	if not LoggedIn then
	begin
		ResultCode := GTD_ERROR_NOT_CNECTD2XCHG;
		ResultDescription := GTD_MESSG_NOT_CNECTD2XCHG;
		Exit;
	end;

	fLastError := '';

	// -- Ask the system
	s := GTLINK_COMMAND_WHEREIS + ' ' + EncodeStringField(GTD_WER_ELE_COMPANY_CODE,GTL);

	// --
	if SendCommand(s, ResultCode,ResultDescription,ei) then
	begin
		markA := HECMLMarker.Create;
		markA.MsgLines.Add(ei);

		if ResultCode = 0 then
		begin
			Result :=  markA.ReadStringField('IP_Address');
		end
		else begin
			ResultCode := GTD_ERROR_NOT_AVAILABLE;
			ResultDescription := GTD_MESSG_NOT_AVAILABLE;
		end;

		// -- BODGY TEMPORARY FIX TO FORCE ALL ACCESS THROUGH EXCHANGE
		{
		if Result = '' then
		begin
			ResultCode := 0;
			Result := GTD_GRIDSERVER;
			// ResultDescription
		end;
		}

		markA.Destroy;
	end;

	ChangeState(gtsIdle);

end;

//---------------------------------------------------------------------------
function gtCommunityLink.WhosLike(s : String):String;
begin
end;

//---------------------------------------------------------------------------
function gtCommunityLink.WhoHas(s : String):String;
begin
	Socket.SendText('whohas ' + s + #13);

	Result := Socket.ReceiveText;
end;
//---------------------------------------------------------------------------
procedure gtCommunityLink.IncOutboundConnectionCount;
begin
	// -- Increment our internal counter
	Inc(fOutConnectionCount);

	// -- Fire off the user event
	if Assigned(fOnConnectionCountChange) then
		fOnConnectionCountChange(Self,fOutConnectionCount,fInConnectionCount);
end;
//---------------------------------------------------------------------------
procedure gtCommunityLink.DecOutboundConnectionCount;
begin
	// -- Increment our internal counter
	if fOutConnectionCount>=1 then
		Dec(fOutConnectionCount);

	// -- Fire off the user event
	if Assigned(fOnConnectionCountChange) then
		fOnConnectionCountChange(Self,fOutConnectionCount,fInConnectionCount);
end;

//---------------------------------------------------------------------------
constructor gtTradingLink.Create(AOwner: TComponent);
begin
	inherited Create(AOwner);

	// -- Use the standard port
	Port := 100;

    // -- We are talking to the exchange
    fLoginCmd  := 'login visitor ';

    fChatList  := TStrings.Create;

    fWorkingDoc := GTDBizDoc.Create(Self);

end;

//---------------------------------------------------------------------------
destructor gtTradingLink.Destroy;
begin
    // -- Destroy what we have created
	fChatList.Destroy;
    fWorkingDoc.Destroy;

    inherited Destroy;
end;
//---------------------------------------------------------------------------
procedure gtTradingLink.SendBufferedText(S : String);
begin
    // -- Work out which dynamic method to use
	if fThruExchange and Assigned(fExchange) then
		// -- Use the exchange to route the data
		fExchange.SendLineTo(fRemoteGTL, S)
	else
		// -- Go through our simple socket
		inherited SendBufferedText(s);
end;
//---------------------------------------------------------------------------
function gtTradingLink.LoadAuthenticationInfo(forTrader_ID : Integer; ForOutgoing :Boolean):Boolean;
var
	Connection_ID : Integer;
	pwd,ei : String;
begin
	// --
	LocalOrganisation := fDocuments.GetCompanyName;

	if fDocuments.GetSupplierAccessInfo(forTrader_ID,Connection_ID,pwd) then
	begin
		// -- Copy these values in
		Trader_ID := Connection_ID;
		Password  := pwd;
	end
	else begin
		// -- We are doing an autosubscribe
		Trader_ID := -1;
		Password  := FloatToStr(Now);

		// -- Build everything automatically
		ei := ei + ' ' + EncodeStringField(GTD_LGN_ELE_ADDRESS_LINE_1,fDocuments.GetAddress1);
		ei := ei + ' ' + EncodeStringField(GTD_LGN_ELE_TOWN,fDocuments.GetCity);
		ei := ei + ' ' + EncodeStringField(GTD_LGN_ELE_STATE_REGION,fDocuments.GetState);
		ei := ei + ' ' + EncodeStringField(GTD_LGN_ELE_COUNTRYCODE,fDocuments.GetCountryCode);

		RegistrationDetails := ei;

	end;
end;
//---------------------------------------------------------------------------
function gtTradingLink.OpenSession(GTL : String):Boolean;
var
	isOk    : Boolean;
	rc      : Integer;
	rs      : String;
begin
	// -- Load up the authentication information that will be needed here
	if Assigned(fDocuments) then
	begin
		if not fDocuments.OpenFor(GTL) then
			NotifyUser(GTL + ' is not on file. Continuing anyway');

		LoadAuthenticationInfo(fDocuments.Trader_ID);
		
		// -- Need to copy the name for our reference later
		fRemoteGTL := GTL;

	end;

    // --
    if not LoggedIn then
    begin
        // -- Attempt to login
		if not LogIn(fDocuments.Trader_ID,'') then
            Exit;
    end;

    // -- Do everything in the basic session
    Resync;

    Result := LoggedIn;

end;

function gtTradingLink.LogIn(GTL : String; ExtraInfo : String):Boolean;
begin
    inherited Login(GTL,ExtraInfo);
end;

// -- Loging in/out
function gtTradingLink.LogIn(Trader_Number : Integer; ExtraInfo : String):Boolean;
var
	GTL : String;
    rc : Integer;
	rs,a : String;
begin

	// -- Initialisation
	GTL := fRemoteGTL;
	rc := 0;

	// -- Maybe we don't know the address so we should look it up
	//    using the exchange
	if GTL = GTD_GRIDSERVER then
		Address := GTD_DFLT_BIZEXCHANGE
	else if (GTL <> '') and (WSocketIsDottedIP(GTL)) then
		// -- Here we can use a dotted IP Address as a  destination
		Address := GTL
	else if Assigned(fExchange) and (GTL <> '') and (Address = '') and (not Socket.Connected) then
	begin

		// -- Do we go through the exchange?
		if not fThruExchange then
			a := fExchange.WhereIs(GTL,rc,rs)
		else if Assigned(fExchange) then
			a := fExchange.GetExchangeAddress;

		if (rc = GTD_ERROR_NOT_CNECTD2RMOT) or (rc = GTD_ERROR_NOT_AVAILABLE)then
		begin
			// -- Offline
			ChangeState(gtsInactive);
			Exit;
		end
		else begin
			// -- Split Port out if neccessary
			if Pos(':',a)<> 0 then
			begin
				Address := Parse(a,':');
				Port    := StrToInt(a);
			end
			else
				Address := a;
		end;
	end;

	if Address = GTD_GRIDSERVER then
	begin
		// -- The link is not available, go through the exchange
		fThruExchange := True;
		Address := GTD_DFLT_BIZEXCHANGE;
	end;

	// -- If we were able to obtain the address
	if (rc = 0) then
		Result := inherited Login(GTL,ExtraInfo)
	else begin
		// -- We need to report this error
		fLastError := rs;

		ChangeState(gtsError);
	end;
end;

// -- Keyring functions

//---------------------------------------------------------------------------
function gtTradingLink.RequestNewPrivateKey(GTL : String; var Private_Key : String):String;
begin
end;

//---------------------------------------------------------------------------
function gtTradingLink.LeaveMessage(DepartmentName, AreaName, UserName, MessageText : String):String;
begin
end;
//---------------------------------------------------------------------------
function gtTradingLink.CheckPricelist:Boolean;
begin
    // -- Here we simply add the command to check the pricelist
    //    onto the command queue
    AddCommand(GTSESSION_CMD_CHKPRICELIST);
    Result := True;
end;
//---------------------------------------------------------------------------
{
function AdjustGMTtoLocal(aDateTime : TDateTime):TDateTime;
var
    tz : _TIME_ZONE_INFORMATION;
    bias : Integer;
begin
end;
}
function ReadHTTPPageTime(L : String):TDateTime;
var
    d,m,y, hh,mm,ss,bh,bm : Word;
    I : Integer;
    mt : String;
    ctime : TDateTime;
    tz : _TIME_ZONE_INFORMATION;
    bias : Integer;
begin
    // -- Retrieve the timezone information
    if GetTimeZoneInformation(tz) <> -1 then
        // -- Format this bias into something we can use
        bias := tz.Bias;

    d  := StrToInt(Copy(L,21,2));
    mt := Copy(L,24,3);
    m  := (Pos(mt,'JanFebMarAprMayJunJulAugSepOctNovDec') div 3) + 1;
    y  := StrToInt(Copy(L,28,4));
    hh := StrToInt(Copy(L,33,2));
    mm := StrToInt(Copy(L,36,2));
    ss := StrToInt(Copy(L,39,2));

    // -- Now Assemble it all
    ctime := EncodeDate(y,m,d) + EncodeTime(hh,mm,ss,0);

//  MessageDlg(FormatDateTime('',ctime),mtInformation,[mbok],0);

    if bias > 0 then
    begin
        bh := bias div 60;
        bm := bias mod 60;
        ctime := ctime - EncodeTime(bh,bm,0,0);
    end
    else
    begin
        bh := (-1 * bias) div 60;
        bm := (-1 * bias) mod 60;
        ctime := ctime + EncodeTime(bh,bm,0,0);
    end;

//  MessageDlg(FormatDateTime('',ctime),mtInformation,[mbok],0);

    Result := ctime;
end;

//---------------------------------------------------------------------------
procedure gtTradingLink.InitiateCheckPricelist(Params : String);

    // -- This function will go off and do a HEAD on the
    //    server which will allow us to check the datestamp
    //    that we have for our file with the one on the server.
    //
    //    If an update is required then the function returns true
    //    and a download is performed
    function HaveNewHTTPDoc(URL : String; plTime : TDateTime):Boolean;
    var
        UseProxy : Boolean;
        L, ProxyAddr,
        ProxyPort   : String;
        I           : Integer;
        ctime       : TDateTime;
    begin
        Result := True;

        try

            httpcli1.SendStream := nil;
            httpcli1.RcvdStream := nil;
            httpcli1.URL        := URL;

            CheckProxySettings(UseProxy,ProxyAddr,ProxyPort);
            if UseProxy then
            begin
                httpcli1.Proxy := ProxyAddr;
                httpcli1.ProxyPort := ProxyPort;
//                NotifyUser('Using proxy ''' + httpcli1.Proxy + ':' + httpcli1.ProxyPort + '''')
            end;

            NotifyUser('Checking Pricelist');

            try

                // -- Wait for the component to be ready
                repeat
                    Application.ProcessMessages;
                    //Sleep(50);
                until (httpcli1.State = httpReady) or (Application.Terminated) or (fcmdCancelled);
            
                httpcli1.Head;

            except
                NotifyUser('POST Failed !');
                NotifyUser('StatusCode   = ' + IntToStr(httpcli1.StatusCode));
                NotifyUser('ReasonPhrase = ' + httpcli1.ReasonPhrase);
                Exit;
            end;

            if httpcli1.StatusCode <> 200 then
                NotifyUser('Command Failed StatusCode = ' + IntToStr(httpcli1.StatusCode))
            else
            begin
                for I := 0 to httpcli1.RcvdHeader.Count - 1 do
                begin
                    L := httpcli1.RcvdHeader.Strings[I];

                    if Pos('Last-Modified:',L) <> 0 then
                    begin

                        ctime := ReadHTTPPageTime(L);

                        // MessageDlg('HeaderTime:' + FormatDateTime('c',plTime) + #13 + 'PricelistTime:' + FormatDateTime('c',cTime),mtInformation,[mbOk],0);

                        // -- Now the comparison
                        if plTime >= ctime then
                            Result := False;

                        break;
                    end;
                end;
            end;

//            ExtractAndSendResult;


        finally
    //        SetButtonState(TRUE);
        end;

    end;

var
    c,d,ei : String;
    plTime : TDateTime;
    ourPricelistDateTime : TDateTime;
begin

	// -- Initialise some variables here
	fSizeExpected := 0;
	fSizeReceived := 0;

	// -- Read the latest pricelist time
	plTime := fDocuments.GetLatestPriceListDateTime;

	if fProtocol = tpAsync then
	begin
		// -- Build the command for async
		c := GTLINK_COMMAND_CATALOG + ' ' + EncodeDateTimeField('DateStamp',plTime);

		if fThruExchange then
			c := c + ' ' + EncodeStringField('GTL',GTL);

		// -- Ask the server for a new pricelist
		PostCommand(c,gtsRecvPricelist);

	end
	else begin

        // -- Show that we are checking for a new pricelist
        ChangeState(gtsRecvPricelist);

        // -- Build the command for http
//      c := 'http://www.tradalogs.com/tradalogs/' + urlencode(GTL) + '.pricelist';

        {$IFNDEF BCP_EVALI}
            // -- Normal execution goes through here
            if HaveNewHTTPDoc(c,plTime) then
			begin
                // -- Ask the server for a new pricelist
                PostCommand(c,gtsRecvPricelist);
            end
            else begin

                CompleteCommand(0,'Pricelist OK');

			end;
		{$ELSE}
			// -- Our Evaluation version is crippled
			CompleteCommand(0,'Pricelist Not Updated');
		{$ENDIF}


	end;

end;
// -- gtTradingLink.---------------------------------------------------------
procedure gtTradingLink.CompleteGetPricelist(CommandResult : String);

	function UpdatePricelist(newPricelistDateTime : TDateTime;UpdateType : String):Integer;
	var
		xc,I     : Integer;
		s,d,L    : String;
		endfound : Boolean;
	begin
		Result := 0;

		// -- Initialise the document
		fWorkingDoc.Clear;
		fWorkingDoc.Owned_By := fTraderID;

		// -- Mark everything as having completed fine
		NotifyUser('Checking received pricelist.. ' + IntToStr(fRecvBuffer.Count) + ' Lines');

		if fProtocol = tpAsync then
		begin

			if UpdateType = GTD_PL_UPDATE_PATCH then
			begin

				// -- Load the last pricelist and attempt a patch
				if fDocuments.GetLatestPriceList(fWorkingDoc) then
				begin
					// -- Apply the patch
					if fWorkingDoc.ApplyPatch(fRecvBuffer) then
						NotifyUser('Pricelist patch applied')
					else
						NotifyUser('Problem encountered applying pricelist patch');
				end;
			end
			else if (UpdateType = GTD_PL_UPDATE_REPLACE) or (UpdateType = '') then
			begin

				// -- Validate that the </Pricelist> was found
				endfound := False;
				d := '</' + GTD_PL_PRICELIST_TAG + '>';
				for xc := fRecvBuffer.Count downto 1 do
				begin
					if Pos(d,fRecvBuffer[xc-1]) <> 0 then
					begin
						endfound := True;

						// -- There is an extra line bug somewhere else
						for I := fRecvBuffer.Count downto xc+1 do
							fRecvBuffer.Delete(i-1);

						break;
					end;
				end;

				// -- Report if not found
				if not endfound then
				begin
					NotifyUser('End of pricelist not found');
					Result := GTD_ERROR_BAD_PRICELIST;
					fLastError := GTD_MESSG_BAD_PRICELIST;
					Exit;
				end;

				// -- We have to transfer all the pricelist lines
				//    out of our input buffer and into the gtdbizdoc
				for xc := 1 to fRecvBuffer.Count do
					if fRecvBuffer.Strings[xc-1][1] = RO_MSGLINE then
					begin
						// -- Add the line, delete the old one later
						//    as the strings with the xc index get stuffed
						s := fRecvBuffer.Strings[xc-1];

						// -- we need to chop the RO_MSGLINE off the start
						s := Copy(s,2,Length(s)-1);

						// -- Add it to the list
						fWorkingDoc.XML.Add(s);
					end;

				// -- Now delete out the message lines
				for xc := fRecvBuffer.Count downto 1 do
				begin
					if fRecvBuffer.Strings[xc-1][1] = RO_MSGLINE then
						fRecvBuffer.Delete(xc-1);
				end;

			end

		end
		else begin

			// -- Copy over all the lines
			fWorkingDoc.XML.Assign(fRecvBuffer);
			fRecvBuffer.Clear;

		end;

		// -- Save the pricelist to the document registry
		if Assigned(fDocuments) and (fWorkingDoc.xml.Count > 0) then
		begin

			// -- should be reading from commandresult
//			newPricelistDateTime := Now;

			NotifyUser('Saving Pricelist');

//			fWorkingDoc.XML.SaveToFile('d:\pricelist.txt');
						
			// -- Doubled check these values are correct
			fDocuments.SaveAsLatestPriceList(fWorkingDoc,newPricelistDateTime,s);

			// -- Now that we have the document save it
			if Assigned(fOnPricelistUpdate) then
				fOnPricelistUpdate(Self, fRemoteGTL, newPricelistDateTime);
		end;

	end;
var
	markA : HECMLMarker;
	I,ResultCode : Integer;
	ResultDescription,L,updateType : String;
	plTime : TDateTime;

begin
	MarkA := HECMLMarker.Create;

	try
		MarkA.UseSingleLine(CommandResult);

		// -- Extract the result
		ResultCode := MarkA.ReadIntegerField(GTLINK_RESPONSE_CODE,0);
		ResultDescription := MarkA.ReadStringField(GTLINK_RESPONSE_TEXT);

		// -- 100 = Pricelist is ok
		if ResultCode = 100 then
		begin
			// --
			ResultCode := 0;
			ResultDescription := 'Pricelist update not required';

			NotifyUser('Pricelist Current');

		end
		else if ResultCode = 0 then
		begin

			// -- We must extract the timestamp from the input buffer
			//    and write an updated pricelist, but only if we have
			//    a http transfer
			if fProtocol = tpHTTP then
			begin
				// -- We need to extract the file datetime from the
				//    http header
				plTime := 0;
				for I := 0 to httpcli1.RcvdHeader.Count - 1 do
				begin
					L := httpcli1.RcvdHeader.Strings[I];

					if Pos('Last-Modified:',L) <> 0 then
					begin

						plTime := ReadHTTPPageTime(L);

						break;
					end;
				end;
			end
			else if fProtocol = tpAsync then
			begin
				// -- What type of update did we get ?
				UpdateType := MarkA.ReadStringField(GTD_PL_ELE_UPDATE_TYPE);
				// -- What timestamp?
				plTime := MarkA.ReadDateTimeField(GTLINK_ELE_CATALOG_TIME,Now);
			end;

			ResultCode := UpdatePricelist(plTime,updateType);

		end
		else
		begin
			// -- Undeterminable return code - skip
			ResultCode := 0;
			ResultDescription := 'Pricelist Check skipped';
		end;
	finally

		markA.Destroy;

		CompleteCommand(ResultCode,ResultDescription);
	end;

end;

//---------------------------------------------------------------------------
function gtTradingLink.SendDocument(Doc_ID : Integer):Boolean;
begin
    AddCommand(GTSESSION_CMD_SENDDOCUMENT + ' ' + IntToStr(Doc_ID));

    Result := True;
end;
//---------------------------------------------------------------------------
procedure gtTradingLink.InitiateSendDocument(Params : String);

    // -- A little helper function
    procedure swrite(aStream : TStream; const S : PChar);
    var
        l : Integer;
    begin
        l := Length(S);
        aStream.Write(S^,l);
    end;

    function PostDocumentViaHTTP:Boolean;
    var
        DataOut : TMemoryStream;
        DataIn  : TMemoryStream;
        Buf,r,fnx    : String;
        I,xc     : Integer;
        UseProxy : Boolean;
        ProxyAddr : String;
        ProxyPort : String;
    begin
        Result := False;

        try
            // -- Create a memory stream to write our web form to
            DataIn  := TMemoryStream.Create;
            DataOut := TMemoryStream.Create;

            //DataOut.LoadFromFile('x:\httpfileinput.txt');

            // -- Fill in our form
            BuildTemplateWebForm(GTLINK_COMMAND_TAKE,DataOut);

            // -- Start the mime Part
            fnx := fUserID + '-' + IntToStr(fWorkingDoc.Local_Doc_ID) + '.'  + fWorkingDoc.Document_Type ;

            swrite(DataOut,Pchar('Content-Disposition: form-data; name="file"; filename="' + fnx + '"' + #13#10));
            swrite(DataOut,Pchar('Content-Type: text/x-chdr' + #13#10 + #13#10));

            // -- Write out the document in mime
            for xc := 1 to fWorkingDoc.XML.Count do
            begin

                // -- Load a line
                r := fWorkingDoc.XML.Strings[xc-1] +  #13#10;

                // -- Send what we have
                swrite(DataOut,Pchar(r));

                if fCmdCancelled then
                    break;
            end;
            // -- finish the mime Part
            swrite(DataOut,PChar(#13#10 + '------------0xKhTmLbOuNdArY' + #13#10#10#10));


            // -- Check that our proxy is setup ready to go
            CheckProxySettings(UseProxy,ProxyAddr,ProxyPort);
            if UseProxy then
            begin
                httpcli1.Proxy := ProxyAddr;
                httpcli1.ProxyPort := ProxyPort;
//              NotifyUser('Using proxy ''' + httpcli1.Proxy + ':' + httpcli1.ProxyPort + '''')
            end;

            // -- Prepare some other values
            //DataOut.Seek(0, soFromBeginning);
            //DataOut.SaveToFile('x:\proggenstuff2.txt');

            DataOut.Seek(0, soFromBeginning);
            httpcli1.SendStream := DataOut;
            httpcli1.RcvdStream := DataIn;
            httpcli1.URL        := BuildHTTPCommand(GTLINK_COMMAND_TAKE);

            try

                ChangeState(gtsSendDoc);

                // -- Wait for the component to be ready
                repeat
                    Application.ProcessMessages;
                    //Sleep(50);
                until (httpcli1.State = httpReady) or (Application.Terminated) or (fcmdCancelled);

                // -- Let the user know what we are trying to do
                // NotifyUser('Sending');

                // -- Now post
                httpcli1.Post;

            except
                // -- If that didn't work...
                ChangeState(gtsError);
                if httpcli1.StatusCode = 500 then
                    // -- This is an "Internal Server Error"; somebody stuffed the CGI script on the server
                    NotifyUser('Service is down - try again later')
                else if httpcli1.StatusCode <> 200 then
                    NotifyUser('Sending Document [' + IntToStr(httpcli1.StatusCode) + '] ' + httpcli1.ReasonPhrase)
                else
                    NotifyUser('Sending Document Failed ');

                Exit;

//                NotifyUser('StatusCode   = ' + IntToStr(httpcli1.StatusCode));
//                NotifyUser('ReasonPhrase = ' + httpcli1.ReasonPhrase);

            end;

            // -- Here we really should validate our login
            //    but for now we'll just pretend that we're in
            if httpcli1.StatusCode = 200 then
            begin
                Result := True;
            end;

        finally
    //        SetButtonState(TRUE);
        end;
    end;

    procedure UpdateHTTPSentDoc;
    var
        e       : gtSessionEvent;
        I       : Integer;
        s,r     : String;
    begin
        // -- We need to search the http header to find the line
        //    that we need.
        r := ''; //httpcli1.Reference;

        for I := 0 to httpcli1.RcvdHeader.Count - 1 do
        begin
            s := httpcli1.RcvdHeader.Strings[I];
            if Copy(s,1,Length(GTHTTP_EXTRAHDR))= GTHTTP_EXTRAHDR then
            begin
                r := Copy(s,Length(GTHTTP_EXTRAHDR)+1,Length(s)-Length(GTHTTP_EXTRAHDR)) + ' ';
                break;
            end;
        end;

        // -- Run this whether we have a result or not
        CompleteSendDocument(r);


    end;
var
    l,r : String;
    xc,rdno,Doc_ID : Integer;
    markA : HECMLMarker;
begin
    // -- Check that we are in the right state
    if fCurrentState = gtsInActive then
    begin
        CompleteCommand(GTD_ERROR_NOT_CNECTD2RMOT,GTD_MESSG_NOT_CNECTD2RMOT);
        Exit;
    end;

    // -- Check that we are in the right state
    if not Assigned(fDocuments) then
    begin
		CompleteCommand(GTD_ERROR_NO_REGISTRY,GTD_MESSG_LOAD_DOCUMENT);
		Exit;
	end;

	// -- Read the document number
	Doc_ID := StrToInt(Params);

	// -- Check that we are in the right state
	if not fDocuments.Load(Doc_ID, fWorkingDoc) then
	begin
		CompleteCommand(GTD_ERROR_LOAD_DOCUMENT,GTD_MESSG_LOAD_DOCUMENT);
		Exit;
	end;

	if fSerialisedCmds then
	begin
		// -- Increment the command number
		Inc(fLastCmd);

		// --
		l := '{' + IntToStr(fLastCmd) + '}';
	end;

	// -- When starting a command, we haven't cancelled
	fCmdCancelled := False;

	// -- Build the complete command string
	l := GTLINK_COMMAND_TAKE + ' Body_Line_Count#=' + IntToStr(fWorkingDoc.XML.Count) + ',' + fDocuments.ExtractDocDetails(fWorkingDoc);

	// -- The sending process is slightly different for http/async
	//    If it async then the lines are sent after the command
	//    whereas with http they need to be bundled together.
	if fProtocol = tpAsync then
	begin

		// -- Use our function to send out the text
		PostCommand(l,gtsSendDoc);

		// -- Assemble the message into chunks as close as possible
		//    to the size of the output buffer
        r := '';
        for xc := 1 to fWorkingDoc.XML.Count do
        begin

            // -- Load a line
            l := fWorkingDoc.XML.Strings[xc-1];

            // -- Send what we have
            SendDataLine(l);

            // -- Be good and let other stuff go through
            //    and check if we have been cancelled
            if (xc mod 100) = 0 then
            begin
				Application.ProcessMessages;
                //Sleep(0);
            end;

            if fCmdCancelled then
                break;

        end;
    end
    else begin

        PostDocumentViaHTTP;

//        UpdateHTTPSentDoc;

    end;

end;
// -- gtTradingLink.---------------------------------------------------------
procedure gtTradingLink.CompleteSendDocument(CommandResult : String);
var
	markA               : HECMLMarker;
	rc,rmtdocid	        : Integer;
	msgid               : String;
	ResultCode          : Integer;
	ResultDescription   : String;
	responseok          : Boolean;
begin
	markA := HECMLMarker.Create;

	MarkA.UseSingleLine(CommandResult);

	// -- Extract the result
	ResultCode := MarkA.ReadIntegerField(GTLINK_RESPONSE_CODE,0);
	ResultDescription := MarkA.ReadStringField(GTLINK_RESPONSE_TEXT);

	// -- Look at our big one line message
	if ResultCode = 0 then
	begin

		responseok := False;

		msgid := markA.ReadStringField(GTD_DB_DOC_MSGID);
		if msgid<>'' then
		begin
			fWorkingDoc.Remote_Doc_ID := fWorkingDoc.LocalToRemoteMsgID(msgid);
		end
		else begin
			rmtdocid := markA.ReadIntegerField(GTD_DB_DOC_DOC_ID,0);
			if (rmtdocid = 0) and (fProtocol = tpAsync) then
			begin
				// -- This didn't work for some reason
				fDocuments.RecordAuditTrail(fWorkingDoc,'Send Error', 'Receiver Reported -> Error:' + IntToStr(ResultCode) + ' ' + ResultDescription);
			end
			else
				fWorkingDoc.Remote_Doc_ID := rmtdocid;
		end;

		// -- We should checking everything
		if fWorkingDoc.Local_Status_Code = 'Not Sent' then
			fWorkingDoc.Local_Status_Code := 'Sent';
		fWorkingDoc.Update_Flag             := GTD_DB_UPDDOCFLAG_SYNC;
		fWorkingDoc.Remote_Status_Code      := markA.ReadStringField(GTD_DB_DOC_LOCSTAT);
		fWorkingDoc.Remote_Status_Comments  := markA.ReadStringField(GTD_DB_DOC_LOCCMTS);
		if Assigned(fDocuments) then
			// -- Save the document back into the registry with history information
			fDocuments.Save(fWorkingDoc,GTD_AUDITCD_SND,GTD_AUDITDS_SND);

		// -- Run the user defined event to say that it worked
		if Assigned(fOnSentDocument) then
			fOnSentDocument(Self,fRemoteGTL,fWorkingDoc.DocumentNumber,fWorkingDoc.Document_Type,fWorkingDoc.Document_Ref);

	end
	else begin
        // -- We'll record what we got back as an error in the log
        fDocuments.RecordAuditTrail(fWorkingDoc,'Send Error', 'Receiver Reported -> Error:' + IntToStr(ResultCode) + ' ' + ResultDescription);

        // -- With a send error, we'll skip the error so that the session can continue
        {
        ResultCode := 0;
        ResultDescription := 'Transfer Errors';
        }

        NotifyUser('Send Error: ' + ResultDescription);
        
        // -- Make a note of the error
        fLastError := ResultDescription;
        ChangeState(gtsError);

    end;
	markA.Destroy;

    // -- Return the Status
    CompleteCommand(ResultCode,ResultDescription);

end;
//---------------------------------------------------------------------------
function gtTradingLink.EventRunRecvNewList(anEvent : gtSessionEvent):Boolean;
var
    rc : Integer;
    rs : String;
begin
    if anEvent.EventType = gteReceivedData then
    begin
        if GetCommandResult(rc, rs, false) then
        begin
            CompleteGetNewDocList(rs);
        end;
    end;
end;
//---------------------------------------------------------------------------
//
// RecvNewDocList
function gtTradingLink.GetNewDocList:Boolean;
begin
    AddCommand(GTSESSION_CMD_GETNEWDOCLIST);

    Result := True;
end;
//---------------------------------------------------------------------------
procedure gtTradingLink.InitiateGetNewDocList(Params : String);
var
    l : String;
begin
    l := GTLINK_COMMAND_LISTNEWDOCS;

    PostCommand(l,gtsRecvNewList);
end;
//---------------------------------------------------------------------------
procedure gtTradingLink.CompleteGetNewDocList(CommandResult : String);
var
    markA : HECMLMarker;
    ResultCode,dc,dac : Integer;
    ResultDescription,dl,dn : String;
begin

    markA := HECMLMarker.Create;
    try

        markA.UseSingleLine(CommandResult);

        // -- Decode the response codes for the caller
        ResultCode := markA.ReadIntegerField(GTLINK_RESPONSE_CODE,-1);
        ResultDescription := markA.ReadStringField(GTLINK_RESPONSE_TEXT);

        dl := markA.ReadStringField(GTDOCLST_NEW_DOCLIST);
        dc := markA.ReadIntegerField(GTDOCLST_NEW_DOCCOUNT,0);

        // -- We will post a request onto our local queue for every document
        //    that we have been asked for.
        if (ResultCode = 0) and (dc > 0) then
        begin
            dac := 0;
            while Length(dl) <> 0 do
            begin
                dn := Parse(dl,';');
                if dn <>'' then
                begin
                    // -- Now place a request to download on the queue
                    RecvDocument(StrToInt(dn));
                    Inc(dac);
                end;
            end;

            // -- If we've asked for less documents than are available
            //    then we must tell ourselves to ask again for the new
            //    list after we have downloaded this lot. Here we simply
            //    post the command to our command queue.
            if dac < dc then
                GetNewDocList;

        end;
    finally
        markA.Destroy;
    end;

    CompleteCommand(0,'New Document list retrieved');
end;
//---------------------------------------------------------------------------
function gtTradingLink.RecvDocument(Doc_ID : Integer):Boolean;
begin
    AddCommand(GTSESSION_CMD_RECVDOCUMENT + ' ' + IntToStr(Doc_ID));

    Result := True;
end;
//---------------------------------------------------------------------------
procedure gtTradingLink.InitiateRecvDocument(Params : String);
var
    l : String;
begin
    // -- Build the command to send a document
	l := GTLINK_COMMAND_SENDDOC + ' ' + Params;

    // -- Send it along the link
    PostCommand(l,gtsRecvDoc);
end;
// -- gtTradingLink.---------------------------------------------------------
procedure gtTradingLink.CompleteRecvDocument(CommandResult : String);
var
    xc,ResultCode       : Integer;
    s,d,
    ResultDescription   : String;
    markA               : HECMLMarker;
    haveNewStatement    : Boolean;
begin

    markA := HECMLMarker.Create;
    try

        markA.UseSingleLine(CommandResult);

        // -- Decode the response codes for the caller
        ResultCode := markA.ReadIntegerField(GTLINK_RESPONSE_CODE,-1);
		ResultDescription := markA.ReadStringField(GTLINK_RESPONSE_TEXT);

        if ResultCode = 0 then
        begin
			// -- Mark everything as having completed fine
            //      NotifyUser('New Document Received');

            // -- We have to transfer all the pricelist lines
            //    out of our input buffer and into the gtdbizdoc
            fWorkingDoc.Clear;
            for xc := 1 to fRecvBuffer.Count do
            begin
                if fRecvBuffer.Strings[xc-1][1] = RO_MSGLINE then
                begin
                    // -- Add the line, delete the old one later
                    //    as the strings with the xc index get stuffed
                    s := fRecvBuffer.Strings[xc-1];

                    // -- we need to chop the RO_MSGLINE off the start
                    s := Copy(s,2,Length(s)-1);

                    // -- Add it to the list
                    fWorkingDoc.Add(s);
                end;
            end;

			// -- Now delete out the message lines
            for xc := fRecvBuffer.Count downto 1 do
            begin
                if fRecvBuffer.Strings[xc-1][1] = RO_MSGLINE then
                    fRecvBuffer.Delete(xc-1);
            end;

            // -- Extract the document number and write that back to
            //    the database.
            fWorkingDoc.UpdateCurrentDocStatus(markA,True);

            // -- Save the pricelist to the document registry
            if Assigned(fDocuments) then
            begin

                // -- Hardwire this for the moment
                if fWorkingDoc.Remote_Status_Code = 'Not Sent' then
                    fWorkingDoc.Remote_Status_Code := 'Sent';

                // -- Save the docxument in the registry
                fDocuments.Save(fWorkingDoc,GTD_AUDITCD_RCV,GTD_AUDITDS_RCV,True);

                // -- We must notify the
                s := GTLINK_RESPONSE_CODE + '!=0 ';
                //  GTLINK_RESPONSE_TEXT = 'Response_Description';

				s := s + fDocuments.ExtractDocDetails(fWorkingDoc);

                SendResponse(s);

                // -- Look for a statement
                if fWorkingDoc.Document_Type = GTD_STM_TYPE then
                    // -- Defer firing off the event until later though
                    haveNewStatement := True;

                // -- Now go and run the event
                if Assigned(fOnNewDocument) then
                    fOnNewDocument(Self,fWorkingDoc.Owned_By,fRemoteGTL,fWorkingDoc.Local_Doc_ID);

            end
            else
                SendResponse(GTLINK_RESPONSE_CODE + '!=500');
        end;

    finally
        markA.Destroy;
    end;

    // -- Here we need to save the document and send back the document
    //    number
    CompleteCommand(ResultCode,ResultDescription);

	// -- If we have a new statement then fire off the appropriate event
    if haveNewStatement then
    begin
        // -- Fire off the event if it is assigned
        if Assigned(fOnNewStatement) then
            fOnNewStatement(Self,fRemoteGTL,fWorkingDoc.Local_Doc_ID);
    end;

end;
//---------------------------------------------------------------------------
function gtTradingLink.ReceiveImage(ImageName : String;CompressionType :String):Boolean;
var
	l : String;
begin
	// -- Save the image name so that we know where to save it for later
	fImageName := ImageName;

	// -- Build the command
	l := GTSESSION_CMD_GETIMAGE + ' ' + EncodeStringField(GTLINK_SENDIMAGEREF_PARAM,ImageName)
									  + EncodeStringField(GTLINK_SENDIMAGEENC_PARAM,CompressionType);

	AddCommand(l);

end;
//---------------------------------------------------------------------------
procedure gtTradingLink.InitiateGetImage(Params : String);
var
	c : String;
begin
    // -- Build the command that we need to send to the server
	c := GTLINK_COMMAND_SENDIMAGE + ' ' + Params;

	// -- Download the image
	PostCommand(c, gtsRecvImage);
end;
// -- gtTradingLink.---------------------------------------------------------
procedure gtTradingLink.CompleteRecvImage(CommandResult : String);
var
	xc,r,ResultCode    : Integer;
	s,d,
	ResultDescription   : String;
	markA               : HECMLMarker;
begin

	markA := HECMLMarker.Create;
	try

		markA.UseSingleLine(CommandResult);

		// -- Decode the response codes for the caller
		ResultCode := markA.ReadIntegerField(GTLINK_RESPONSE_CODE,-1);
		ResultDescription := markA.ReadStringField(GTLINK_RESPONSE_TEXT);

		if ResultCode = 0 then
        begin
			fWorkingDoc.Clear;

			{fRecvBuffer.SaveToFile('d:\rcvbuff.txt');}

			// -- We have to transfer all the pricelist lines
			//    out of our input buffer and into the gtdbizdoc
			for xc := 1 to fRecvBuffer.Count do
			begin
				if fRecvBuffer.Strings[xc-1][1] = RO_MSGLINE then
				begin
					// -- Add the line, delete the old one later
					//    as the strings with the xc index get stuffed
					s := fRecvBuffer.Strings[xc-1];

					// -- we need to chop the RO_BINDATA off the start
					s := Copy(s,2,Length(s)-1);

					// -- Add it to the list
					fWorkingDoc.Add(s);
				end;
			end;

            // -- in debug, save what is received
			//fRecvBuffer.SaveToFile('d:\rcvbuff.txt');
			//fWorkingDoc.XML.SaveToFile('d:\rcvdoc.txt');

			// -- Now delete out the message lines
			for xc := fRecvBuffer.Count downto 1 do
			begin
				if fRecvBuffer.Strings[xc-1][1] = RO_MSGLINE then
					fRecvBuffer.Delete(xc-1);
			end;

			// -- Save the pricelist to the document registry
			if Assigned(fDocuments) then
				fDocuments.SaveReceivedImage(fImageName,fWorkingDoc);

			// -- Now that we have the document save it
			if Assigned(fOnProductImageReceived) then
				fOnProductImageReceived(Self, fRemoteGTL, fImageName, fWorkingDoc);
		end;

	finally
		markA.Destroy;
    end;

    CompleteCommand(ResultCode,ResultDescription);

end;
//---------------------------------------------------------------------------
function gtTradingLink.SendAllNewDocs:Boolean;
var
    thisDocNum, NewDocList,rs : String;
    dno,rc : Integer;
begin
    if Assigned(fDocuments) then
    begin
        // -- We need to check that
        fDocuments.OpenFor(fRemoteGTL);

        // -- Get a list of all the new documents in the registry
        NewDocList := fDocuments.GetNewDocumentNumbers(rc);

        thisDocNum := Parse(NewDocList,GTD_DOC_LIST_SEPERATOR);
        while thisDocNum <> '' do
        begin
            // -- Convert the document number
            dno := StrToInt(thisDocNum);

            // -- Send the document
            SendDocument(dno);

            // -- Get the next document number
            thisDocNum := Parse(NewDocList,GTD_DOC_LIST_SEPERATOR);

        end;

        Result := True;
    end;

    Result := False;
end;
//---------------------------------------------------------------------------
function gtTradingLink.ReceiveAllNewDocs:Boolean;
begin
    GetNewDocList;
end;
//---------------------------------------------------------------------------
function gtTradingLink.UpdateAllDocStatuses:Boolean;
var
    thisDocNum, NewDocList,rs : String;
    dno,rc : Integer;
begin
    if Assigned(fDocuments) then
    begin
        // -- Get a list of all the new documents in the registry
        NewDocList := fDocuments.GetUpdatedDocumentNumbers;

        thisDocNum := Parse(NewDocList,GTD_DOC_LIST_SEPERATOR);
        while thisDocNum <> '' do
        begin
            // -- Convert the document number
            dno := StrToInt(thisDocNum);

            // -- Send the document
            SendDocumentUpdates(dno);

            // -- Get the next document number
            thisDocNum := Parse(NewDocList,GTD_DOC_LIST_SEPERATOR);

        end;

        Result := True;
    end;

    Result := False;
end;
//---------------------------------------------------------------------------
function gtTradingLink.SendDocumentUpdates(Doc_ID : Integer):Boolean;
begin
    // -- Add the command to the command queue
    AddCommand(GTSESSION_CMD_NOTIFYDOCSTAT + ' ' + IntToStr(Doc_ID));
end;
//---------------------------------------------------------------------------
procedure gtTradingLink.InitiateDocStatusChg(Params : String);
var
    Doc_ID : Integer;
    l : String;
begin
    if Assigned(fDocuments) then
    begin

        // -- Build the update string
        l := GTLINK_COMMAND_CHG_STATUS + ' ';

        if Params <> '' then
        begin
            // -- We need the document to send
            Doc_ID := StrToInt(Params);
        end
        else begin
            // -- Fail in the event that a document number was not provided
            CompleteCommand(888,'Invalid Parameters');
            Exit;
        end;

        // -- First thing to do is to loadup the document
        if fDocuments.Load(Doc_ID,fWorkingDoc) then
        begin

            // -- Put it all together
            l := l + EncodeStringField(GTDOCUPD_NTFN_MSGID,fWorkingDoc.Msg_ID) + ' ';

            // -- Examine update flag to determine exactly what has changed
        	if fWorkingDoc.Update_Flag = GTD_DB_UPDDOCFLAG_DIRTYSTAT then
            begin
                // -- Send back the new status information
                l := l + EncodeStringField(GTDOCUPD_NTFN_OP,GTDOCUPD_NTFN_OP_UPDATE) + ' ';
                l := l + EncodeStringField(GTDOCUPD_NTFN_CODE,fWorkingDoc.Local_Status_Code) + ' ';
                l := l + EncodeStringField(GTDOCUPD_NTFN_CMTS,fWorkingDoc.Local_Status_Comments) + ' ';
            end
            else if fWorkingDoc.Update_Flag = GTD_DB_UPDDOCFLAG_DIRTYHDR then
            begin
                // -- Here we should be sending all header information from the document
            end
            else if fWorkingDoc.Update_Flag = GTD_DB_UPDDOCFLAG_DIRTYBODY then
            begin
                // -- Here we should be sending the body
            end
            else
                // -- If there is nothing to update on the host then we must assume
                //    that all we need to do is to simply read the status off the host
                //    and update the status locally
                l := l + EncodeStringField(GTDOCUPD_NTFN_OP,GTDOCUPD_NTFN_OP_READ) + ' ';

            // -- Now send the data
            PostCommand(l,gtsDocStatusChg);

        end;
    end;
end;
//---------------------------------------------------------------------------
function gtTradingLink.CompleteUpdateStatus(CommandResult : String):Boolean;
var
    xc,r,ResultCode     : Integer;
    ResultDescription,
    rstatcode,
    rstatcmts           : String;
    markA               : HECMLMarker;
    StatusChanged       : Boolean;
begin

    markA := HECMLMarker.Create;
    try

    	// -- Something
        markA.UseSingleLine(CommandResult);

        // -- Decode the response codes for the caller
        ResultCode := markA.ReadIntegerField(GTLINK_RESPONSE_CODE,-1);
        ResultDescription := markA.ReadStringField(GTLINK_RESPONSE_TEXT);

        if ResultCode = 0 then
        begin
            // -- Check for new status
            rstatcode := markA.ReadStringField(GTDOCUPD_NTFN_CODE);
            if rstatcode <> fWorkingDoc.Remote_Status_Code then
            begin
                fWorkingDoc.Remote_Status_Code := rstatcode;
                StatusChanged := True;
            end;

            // -- Check for new comments
            rstatcmts := markA.ReadStringField(GTDOCUPD_NTFN_CMTS);
            if rstatcmts <> fWorkingDoc.Remote_Status_Comments then
            begin
                fWorkingDoc.Remote_Status_Comments := rstatcmts;
                StatusChanged := True;
            end;

            // -- Now reset the document so that the change won't be sent through again
            fWorkingDoc.Update_Flag := GTD_DB_UPDDOCFLAG_SYNC;
            fDocuments.Save(fWorkingDoc,GTD_AUDITCD_SYNC,GTD_AUDITDS_SYNC);

            // -- Run the Event to notify that the document has changed
            if StatusChanged and Assigned(fOnNewDocumentStatus) then
                fOnNewDocumentStatus(Self,fRemoteGTL,fWorkingDoc.Local_Doc_ID,'');
        end;

    finally
        markA.Destroy;
    end;

    CompleteCommand(ResultCode,ResultDescription);
end;
// -- Event Handlers
//---------------------------------------------------------------------------
function gtTradingLink.EventRunRecvPricelist(anEvent : gtSessionEvent): Boolean;

	procedure DisplayProgress;
    var
        pcc,xc : Integer;
        L : String;
    begin

        // -- Try to calculate the lines expected if we don't know
        if fSizeExpected = 0 then
        begin
            for xc := 1 to fRecvBuffer.Count do
                if fRecvBuffer.Strings[xc-1][1] = RO_PROGRESS then
                begin
                    pcc := Pos('=',fRecvBuffer.Strings[xc-1]);
                    if pcc <> 0 then
                    begin
                        L := Copy(fRecvBuffer.Strings[xc-1],pcc+1,Length(fRecvBuffer.Strings[xc-1])-pcc-1);
                        fSizeExpected := StrToInt(L);
                    end;
                    break;
                end;
        end;


		// -- We have this many lines in the buffer
		fSizeReceived := fRecvBuffer.Count;

		if fSizeExpected <> 0 then
		begin
			pcc := (fSizeReceived * 100) div fSizeExpected;
			NotifyUser(IntToStr(pcc) + '% Complete');
        end
        else
            NotifyUser(IntToStr(fSizeReceived) + ' Lines');

        Application.ProcessMessages;
    end;

var
    CommandResult : String;
begin
	Result := False;
	case anEvent.EventType of
		gteDropConnection:	// -- Connection is dropped
							;
		gteReceivedData:	// -- Data was received and needs to be processed
//                            HandleData;
                            if GetCommandResult(0, CommandResult, False) then
                                CompleteGetPricelist(CommandResult)
                            else
                                DisplayProgress;
		gteTimerExpired:	// -- A timer has expired
							;
	end;
end;
//---------------------------------------------------------------------------
function gtTradingLink.EventRunSendDoc(anEvent : gtSessionEvent): Boolean;

    function HandleData:Boolean;
    var
        r : String;
    begin
        if GetCommandResult(fLastCmd, r, false) then
        begin

            CompleteSendDocument(r);

        end;

        Result := True;
    end;
begin
	Result := False;
	case anEvent.EventType of
		gteOpenConnection:	// -- Connection is now open
							;
		gteDropConnection:	// -- Connection is dropped
							;
		gteWriteEnable:		// -- Channel open for writing
							;
		gteWriteDisable:	// -- Channel closed for writing
							;
		gteReceivedData:	// -- Data was received and needs to be processed
                            Result := HandleData;
		gteTimerExpired:	// -- A timer has expired
							;
	end;
end;
//---------------------------------------------------------------------------
function gtTradingLink.EventRunRecvDoc(anEvent : gtSessionEvent): Boolean;

    function HandleData:Boolean;
    var
        r  : String;
    begin
        if GetCommandResult(fLastCmd, r, false) then
        begin

            CompleteRecvDocument(r);

        end;

        Result := True;
    end;
begin
	Result := False;

	if anEvent.EventType = gteReceivedData then
        Result := HandleData;
end;
//---------------------------------------------------------------------------
function gtTradingLink.EventRunRecvImage(anEvent : gtSessionEvent):Boolean;
    function HandleData:Boolean;
    var
        r  : String;
    begin
        if GetCommandResult(fLastCmd, r, false) then
        begin

            CompleteRecvImage(r);

        end;

        Result := True;
    end;
begin
	Result := False;
	case anEvent.EventType of
		gteOpenConnection:	// -- Connection is now open
							;
		gteDropConnection:	// -- Connection is dropped
							;
		gteWriteEnable:		// -- Channel open for writing
							;
		gteWriteDisable:	// -- Channel closed for writing
							;
		gteReceivedData:	// -- Data was received and needs to be processed
							Result := HandleData;
		gteTimerExpired:	// -- A timer has expired
							;
	end;
end;
// -- gtSessionLink.---------------------------------------------------------
function gtTradingLink.EventRunRecvStatusChg(anEvent : gtSessionEvent):Boolean;
    function HandleData:Boolean;
    var
        r  : String;
    begin
		if GetCommandResult(fLastCmd, r, false) then
        begin

            CompleteUpdateStatus(r);

            CompleteCommand(0,'Remote Status Updated');
            
        end
        else
            CompleteCommand(0,'Remote Status Updated');

        Result := True;
    end;
begin
	Result := False;
	case anEvent.EventType of
		gteReceivedData:	// -- Data was received and needs to be processed
							Result := HandleData;
	end;
end;
// -- Chatting functions
//---------------------------------------------------------------------------
function gtTradingLink.OpenChatLine(DepartmentName, AreaName, TheirName : String; var ResultCode : Integer; var ResultDescription : String):Integer;
var
    s,ei,c,MyName,MyDept,MyArea,MyPos : String;
    i : Integer;
begin
    // -- Extract all the user information that is needed from the registry
	GetSettingString(GTD_REG_NOD_GENERAL,GTD_REG_USER_NAME,MyName);
	GetSettingString(GTD_REG_NOD_GENERAL,GTD_REG_USER_POSITION,MyPos);
	GetSettingString(GTD_REG_NOD_GENERAL,GTD_REG_USER_DEPARTMENT,MyDept);
    MyArea := '';

    // -- Build the information string
    c := EncodeStringField(GTCHAT_ELE_TO_DEPT,DepartmentName) + ' ' +
         EncodeStringField(GTCHAT_ELE_TO_AREA,AreaName) +
         EncodeStringField(GTCHAT_ELE_RECIPIENT,TheirName) +
         EncodeStringField(GTCHAT_ELE_FROM_DEPT,MyDept) +
         EncodeStringField(GTCHAT_ELE_FROM_AREA,MyArea) +
         EncodeStringField(GTCHAT_ELE_FROM_POSITION,MyPos) +
         EncodeStringField(GTCHAT_ELE_ORIGINATOR,MyName);

    s := GTLINK_COMMAND_OPENCHAT + ' ' + c;

    // -- Open up a chat line
    SendCommand(s, ResultCode, ResultDescription, ei);

    Result := ResultCode;

end;
//---------------------------------------------------------------------------
function gtTradingLink.SendChatText(channel : Integer; ChatMessage : String):Boolean;
var
    l : String;
begin
    // -- Now send out our chat text along with all the other
    //    chat session information that we provided
    l := RO_CHATLINE + EncodeStringField(GTCHAT_ELE_EVENT,GTCHAT_EVENT_CHATLINE) + ' ' +
         EncodeStringField(GTCHAT_ELE_CHATMSG,ChatMessage) + #10;

    // -- Now send the data down the line
    SendBufferedText(l);

    Result := True;
end;
//---------------------------------------------------------------------------
function gtTradingLink.CloseChatLine(Channel : Integer):Boolean;
var
    l : String;
begin
    l := RO_CHATLINE + EncodeStringField(GTCHAT_ELE_EVENT,GTCHAT_EVENT_CLOSE) + #10;

    // -- Now send the data down the line
    SendBufferedText(l);

    Result := True;
end;
//---------------------------------------------------------------------------
procedure gtTradingLink.ReSync;
begin
    // --
    CheckPricelist;

	SendAllNewDocs;
    
    if fProtocol = tpHTTP then
    begin
        // -- Close down the link
        AddCommand(GTSESSION_CMD_CLOSELINK);
        Exit;
    end;

	ReceiveAllNewDocs;
	UpdateAllDocStatuses;
end;
//---------------------------------------------------------------------------
function  gtSessionLink.CurrentState:gtSessionState;
begin
	Result := fCurrentState;
end;

//---------------------------------------------------------------------------
function gtSessionLink.GetSettingString(SectionName,ElementName : String; var ValueStr : String):Boolean;
var
	configDataHandle : HKEY;
	textbuff : array[1..500] of byte;
	textbufflen : Integer;
	xc 	   : Integer;
	s		: String;
	lpType : DWORD;
begin
	Result := False;
	ValueStr := '';

	// -- Build the section name
	s := gtKeyPath + SectionName;

	// -- Open the string
	if (0 = RegOpenKey(HKEY_LOCAL_MACHINE,PChar(s),configDataHandle)) then
	begin
		// -- Look for the version
		lpType := REG_SZ;
		textbufflen := sizeof(textbuff);
		xc:=RegQueryValueEx(configDataHandle,PChar(ElementName),nil,LPDWORD(@lpType),@textbuff,LPDWORD(@textbufflen));
		if (xc=0) then
		begin
			// -- Write the new updated value
			ValueStr := StrPas(@textbuff);
			Result := True;
		end;

		RegCloseKey(configDataHandle);

	end;

end;

//---------------------------------------------------------------------------
function gtSessionLink.GetSettingInt(SectionName,ElementName : String; var ValueInt : Integer):Boolean;
var
	configDataHandle : HKEY;
	intbuff : Integer;
	textbufflen : Integer;
	xc 	   : Integer;
	s		: String;
	lpType : DWORD;
begin
	Result := False;

	// -- Build the section name
	s := gtKeyPath + SectionName;

	// -- Open the string
	if (0 = RegOpenKey(HKEY_LOCAL_MACHINE,PChar(s),configDataHandle)) then
	begin
		// -- Look for the version
		lpType := REG_DWORD;
		textbufflen := sizeof(intbuff);
		xc:=RegQueryValueEx(configDataHandle,PChar(ElementName),nil,LPDWORD(@lpType),@intbuff,LPDWORD(@textbufflen));
		if (xc=0) then
		begin
			// -- Write the new updated value
			ValueInt := IntBuff;
			Result := True;
		end;

		RegCloseKey(configDataHandle);

	end;
end;

//---------------------------------------------------------------------------
function gtSessionLink.SaveSettingString(SectionName,ElementName : String; ValueStr : String):Boolean;
var
	i : Integer;
	configDataHandle : HKEY;
	textbuff : array[1..500] of byte;
	textbufflen : Integer;
	xc 	   : Integer;
	s		: String;
	lpType : DWORD;
begin
	Result := False;

	// -- Build the section name
	s := gtKeyPath + SectionName;

	// -- Open the string
	if (0 <> RegOpenKey(HKEY_LOCAL_MACHINE,PChar(s),configDataHandle)) then
	begin

		// -- We need to create the key
		RegCreateKey(HKEY_LOCAL_MACHINE,PChar(s),configDataHandle);

	end;

	// -- Now write the values in
	for xc := 1 to sizeof(textbuff) do
		textbuff[xc] := 0;
	lpType := REG_SZ;
	StrLCopy(@textbuff,PChar(ValueStr),sizeof(textbuff));
	textbufflen := Length(ValueStr) + 1;

	xc:=RegSetValueEx(configDataHandle,PChar(ElementName),0,lpType,@textbuff,textbufflen);
	if (xc = 0) then
	begin
		// -- Write the new updated value
		Result := True;
	end;

	RegCloseKey(configDataHandle);
end;

//---------------------------------------------------------------------------
function gtSessionLink.SaveSettingInt(SectionName,ElementName : String; ValueInt : Integer):Boolean;
var
	i : Integer;
	configDataHandle : HKEY;
	xc 	   : Integer;
	s		: String;
	lpType, lpLen : DWORD;
begin
	{
	Result := SaveSettingString(SectionName,ElementName,IntToStr(ValueInt));
	}
	Result := False;

	// -- Build the section name
	s := gtKeyPath + SectionName;

	// -- Open the string
	if (0 <> RegOpenKey(HKEY_LOCAL_MACHINE,PChar(s),configDataHandle)) then
	begin

		// -- We need to create the key
		RegCreateKey(HKEY_LOCAL_MACHINE,PChar(s),configDataHandle);

	end;

	// -- Now write the values in
	lpType := REG_DWORD;
	lpLen := Sizeof(ValueInt);

	xc:=RegSetValueEx(configDataHandle,PChar(ElementName),0,lpType,@ValueInt,lpLen);
	if (xc = 0) then
	begin
		// -- Write the new updated value
		Result := True;
	end;

	RegCloseKey(configDataHandle);
end;

//---------------------------------------------------------------------------
function gtSessionLink.GetNextConfigInt(SectionName,ElementName : String; var ValueInt : Integer):Boolean;
var
	i : Integer;
	configDataHandle : HKEY;
	intbuff,
	intbufflen  : Integer;
	xc 	   : Integer;
	s		: String;
	lpType : DWORD;
begin
	// -- Initialisation
	intbuff := ValueInt;
	Result := False;

	// -- Build the section name
	s := gtKeyPath + SectionName;

	// -- Open the section
	if (0 = RegOpenKey(HKEY_LOCAL_MACHINE,PChar(s),configDataHandle)) then
	begin
		// -- Look for the version
		lpType := REG_DWORD;
		intbufflen := sizeof(intbuff);

		xc:=RegQueryValueEx(configDataHandle,PChar(ElementName),nil,LPDWORD(@lpType),@intbuff,LPDWORD(@intbufflen));
		if (xc=0) then
		begin
			// -- Write the new updated value
			Inc(IntBuff);
		end;

	end
	else begin
		// -- We need to create the key
		RegCreateKey(HKEY_LOCAL_MACHINE,PChar(s),configDataHandle);

	end;

	// -- Look for the version
	lpType := REG_DWORD;
	intbufflen := sizeof(integer);

	// -- Update the current value
	xc:=RegSetValueEx(configDataHandle,PChar(ElementName),0,lpType,@intbuff,intbufflen);
	if (xc=0) then
	begin
		// -- Write the new updated value
		ValueInt := IntBuff;
		Result := True;
	end;

	RegCloseKey(configDataHandle);

end;

//---------------------------------------------------------------------------
constructor GTDConnectionList.Create(AOwner: TComponent);
begin
    inherited Create(AOwner);

//    ViewStyle := vsReport;
//    RowSelect := True;
//    Readonly := True;
end;

// -- Connection functions
function GTDConnectionList.AddSupplierConnection(GTL, Name : String; Trader_ID : Integer):gtTradingLink;
var
    xc,portno : Integer;
    newItem : TListItem;
    newLink : gtTradingLink;
begin

    // -- Now setup this link with all the data that it needs
    // -- Check for some tricky things
    xc := Pos(':',GTL);
    if xc <> 0 then
    begin
        // -- Take off the port number from the GTL
        PortNo  := StrToInt(Copy(GTL,xc+1,Length(GTL)-xc));
        GTL := Copy(GTL,1,xc-1);
    end
    else
        PortNo := GTD_WANTALK_PORT;

    // -- Check that we haven't already got this one
    newItem := FindCaption(0,GTL,False,True,True);
    if Assigned(newItem) then
    begin
        newLink := gtTradingLink(newItem.Data);
        newLink.ReSync;
        Result := newLink;
        Exit;
    end;

    newItem := Items.Add;
    // -- Caption is the GTL
    newItem.Caption := GTL;
    // -- First subitem is the name
    newItem.SubItems.Add(Name);
    // -- second subitem is the status
    newItem.SubItems.Add('Not Connected');
    newItem.SubItems.Add(IntToStr(Trader_ID));
    newItem.ImageIndex := 1;

    // -- Now create a connection item for this one
    newLink := gtTradingLink.Create(Self);

    // -- Return this as a pointer so that they can modify or acccess other
    //    properties
    result  := newLink;

    newLink.Port           := PortNo;
    newLink.GTL            := GTL;
    if fLocalGTL <> '' then
        newLink.LocalGTL   := fLocalGTL;

    newLink.ConnectionList      := Self;
    newLink.ConnectionItem      := newItem;
    newLink.Exchange            := fExchange;
    newLink.OnStatusChange      := HandleNewLinkStatus;
    newLink.OnUserInformation   := HandleUserInformation;

    // -- Setup events for the link based on the higher level events
    newLink.OnNewPricelist      := HandleNewPricelistNotification;
    newLink.OnPricelistUpdate   := HandlePricelistUpdate;

    // -- Copy all our assigned events down to each link so that they will fire
    if Assigned(fOnProductImageReceived) then
        newLink.OnProductImageReceived := fOnProductImageReceived;
    if Assigned(fOnNewDocument) then
        newLink.OnNewDocument := fOnNewDocument;
    if Assigned(fOnNewDocumentStatus) then
        newLink.OnNewDocumentStatus := fOnNewDocumentStatus;
    if Assigned(fOnNewStatement) then
        newLink.OnNewStatement := fOnNewStatement;
    if Assigned(fOnSentDocument) then
        newLink.OnSentDocument := fOnSentDocument;

    // -- Create a new document registry just for this company
    //    and open it.
    newLink.Documents      := GTDDocumentRegistry.Create(Self);
    newLink.Documents.OpenFor(GTL);

    {$IFNDEF LIGHTWEIGHT}
	newLink.LoadAuthenticationInfo(Trader_ID);
	{$ELSE}
		// -- Need to transfer this over
		newLink.Documents.TradalogDir := Documents.TradalogDir;
	{$ENDIF}

	// -- Now save our pointer for later
	newItem.Data := newLink;

	// -- Set the item to the default state which is inactive
	newLink.ChangeState(gtsInactive);

end;
//---------------------------------------------------------------------------
function GTDConnectionList.LoadSupplierConnections:Boolean;
{$IFDEF LIGHTWEIGHT}
	function LoadSuppliersFromDir(d : String):Boolean;
	var
		SearchRec: TSearchRec;
		foundRec,foundAny : Boolean;
		cgtl,cname,clocation,s,n : String;
		xc,xd                    : Integer;
		aDoc                     : GTDBizDoc;
	begin
		foundAny := False;
		Result := False;

		if Copy(d,Length(d),1) ='\' then
			s := d + '*' + GTD_PRICELIST_EXT
		else
			s := d + '\*' + GTD_PRICELIST_EXT;

		foundrec := FindFirst(s, faAnyFile, SearchRec) = 0;
		while foundrec do
		begin

			// -- Load the file quickly and extract all the details about the company
			//    that we need for the display.
			try
				aDoc := GTDBizDoc.Create(Self);

				// -- Load the file and pull out the gtl
				aDoc.LoadFromFile(d + '\' + SearchRec.Name);

				// -- Extract these fields
				cgtl        := aDoc.GetStringElement(GTD_PL_VENDORINFO_NODE,GTD_PL_ELE_COMPANY_CODE);
				cname       := aDoc.GetStringElement(GTD_PL_VENDORINFO_NODE,GTD_PL_ELE_COMPANY_NAME);
				clocation   := aDoc.GetStringElement(GTD_PL_VENDORINFO_NODE,GTD_PL_ELE_TOWN);

				// -- If the name wasn't available, then use the name from the filename
				if cname = '' then
				begin
					// -- Chop out the extension
					n := '';
					s := Copy(SearchRec.Name,1,Length(SearchRec.Name)-Length(GTD_PRICELIST_EXT));
					xc := Pos('@',s);
					if xc <> 0 then
					begin
						// -- Here's the business name
						cname := Copy(s,1,xc-1);
						xd := Pos('(',s);
						if (xd <> 0) then
						begin
							// -- Use this part as the location if there isn't one
							if clocation = '' then
							begin
								clocation := Copy(s,xc+1,xd-xc-1);
								clocation := AnsiUppercase(Copy(clocation,1,1)) + Copy(clocation,2,Length(clocation)-1);
							end;
						end;
					end
					else
						cname := s;
				end;

			finally
				aDoc.Destroy;
			end;

			// -- If we don't have a gtl then use the one in the filename
			if (cgtl = '') and Assigned(fDocuments) then
				cgtl := fDocuments.ConvertPricelistNameToGTL(SearchRec.Name);

			// -- Do we have this connection
			if nil = FindCaption(0,cgtl,false,true,false) then
			begin
				// -- Add this one because we don't have it
				AddSupplierConnection(cgtl,cname,-1);
				foundAny := True;
			end;


			foundrec := FindNext(SearchRec) = 0;

		end;

		FindClose(SearchRec);

		Result := foundAny;

	end;

begin
	if not LoadSuppliersFromDir(ExtractFilePath(Application.ExeName)) then
		if Assigned(Documents) then
			LoadSuppliersFromDir(Documents.GetTradalogDir);
{$ELSE}
var
	qrySuppliers    : TQuery;
	xc              : Integer;
	aLink           : gtTradingLink;

	procedure FindAllSuppliers;
	begin
		with qrySuppliers do
		begin
			// -- Setup the alias
			DatabaseName := GTD_ALIAS;

			SQL.Add('Select * from Trader');
			SQL.Add('where ');
			SQL.Add('(Trading_Relationship = "Supplier") and');
			SQL.Add('(Trading_Status_Code  = "Active") and');
			SQL.Add('(' + GTD_DB_COL_COMPANY_CODE + ' is not null)');
			SQL.Add('order by');
			SQL.Add(GTD_DB_COL_COMPANY_NAME);

			Open;
		end;
	end;

begin
	Result := False;

	// -- First step is to build a query
	qrySuppliers := TQuery.Create(Self);
	try

		with qrySuppliers do
		begin

			// -- Look for all the suppliers in the database
			FindAllSuppliers;

			// -- Add these to the existing list but don't add
			//    any a second time
			First;
			while not Eof do
			begin
				aLink := nil;
				for xc := 1 to Items.Count do
				begin
					if Items[xc-1].Caption = FieldByName(GTD_DB_COL_COMPANY_CODE).AsString then
						aLink := gtTradingLink(Items[xc-1].Data);
				end;
				if not Assigned(aLink) then
					// -- Add this one because we don't have it
					AddSupplierConnection(qrySuppliers.FieldByName(GTD_DB_COL_COMPANY_CODE).AsString,qrySuppliers.FieldByName(GTD_DB_COL_COMPANY_NAME).AsString,qrySuppliers.FieldByName(GTD_DB_COL_TRADER_ID).AsInteger);

				// --
				//if nil = FindCaption(0,FieldByName(GTD_DB_COL_COMPANY_CODE).AsString,false,true,false) then
				//begin
				//    // -- Add this one because we don't have it
				//    AddSupplierConnection(qrySuppliers.FieldByName(GTD_DB_COL_COMPANY_CODE).AsString,qrySuppliers.FieldByName(GTD_DB_COL_COMPANY_NAME).AsString,qrySuppliers.FieldByName(GTD_DB_COL_TRADER_ID).AsInteger);
				// end;

				Next;
			end;
		end;
	finally
		qrySuppliers.Destroy;
	end;

	// -- Did we find any suppliers that we could connect to
	if Items.Count <> 0 then
		Result := True;

{$ENDIF}
end;
//---------------------------------------------------------------------------
function GTDConnectionList.OpenAllSupplierConnections:Boolean;
var
	aLink   : gtTradingLink;
	xc,rc   : Integer;
	rs      : String;
begin
	Result := False;

	// -- Scroll back to top
	Scroll(0,-3000);

	// -- Reset the state of any existing connections
	for xc := 1 to Items.Count do
	begin
		// -- Have each of the connections login
		aLink := gtTradingLink(Items[xc-1].Data);
		if Assigned(aLink) then
		begin
			// -- Reset the state back to inactive
			if (aLink.fCurrentState in [gtsError,gtsComplete,gtsInactive]) then
				aLink.ChangeState(gtsInactive);

		end;
	end;

	// -- Load our list
	LoadSupplierConnections;

	// -- Display the new states also
	Update;

	// -- We must NOT connect if we don't have access to the exchange
	if Assigned(Exchange) and (not Exchange.LoggedIn) then
		Exit;

	// -- Now open up a connection to all the suppliers one by one
	for xc := 1 to Items.Count do
	begin

		// -- Do some primitive scrolling
		if xc > 6 then
		begin
			Scroll(0,10); // Selected := RowHeight; // Items[xc-5]
		end;

		// -- Have each of the connections login
		aLink := gtTradingLink(Items[xc-1].Data);
		if Assigned(aLink) then
		begin

			{$IFDEF LIGHTWEIGHT}
			// Do this because it's the only thing working at the moment
			aLink.fThruExchange := True;
			aLink.UserID := Exchange.UserID;
			aLink.Password := Exchange.Password;
			{$ENDIF}

			aLink.Protocol := Exchange.Protocol;

//			if aLink.Address = '' then
//				aLink.Address := Exchange.WhereIs(aLink.Gtl,rc,rs);

			aLink.OpenSession(Items[xc-1].Caption);
		end;
	end;

	// -- Now trigger an event to mark completion
	if Assigned(fOnAllConnectionsDone) then
		fOnAllConnectionsDone(Self,0,0);

	if Assigned(Exchange) and (not Exchange.LoggedIn) and (Exchange.fProtocol = tpHTTP) then

	// -- Did we find any suppliers that we could connect to
	if Items.Count <> 0 then
		Result := True;

end;
//---------------------------------------------------------------------------
procedure GTDConnectionList.CloseAllSupplierConnections;
var
	xc : Integer;
	aLink : gtTradingLink;
begin
	for xc := 1 to Items.Count do
	begin

		// -- Do some primitive scrolling
		if xc > 6 then
		begin
			Scroll(0,10); // Selected := RowHeight; // Items[xc-5]
		end;

		// -- Have each of the connections login
		aLink := gtTradingLink(Items[xc-1].Data);
		if Assigned(aLink) then
		begin
			aLink.Close;
		end;
	end;
end;
//---------------------------------------------------------------------------
procedure GTDConnectionList.OpenConnection(GTL : String);
var
	anItem : TListItem;
	aLink           : gtTradingLink;
begin
	// -- Here
	anItem := FindCaption(0,GTL,false,true,false);
	if not Assigned(anItem) then
		Exit;

    // -- Otherwise close everything down
    aLink := gtTradingLink(anItem.Data);

    // -- Now try to open the session
    if Assigned(aLink) then
        aLink.OpenSession(GTL);
end;

//---------------------------------------------------------------------------
function GTDConnectionList.CloseConnection(GTL : String):Boolean;
var
    anItem : TListItem;
    aLink           : gtTradingLink;
begin
    // -- Here
    anItem := FindCaption(0,GTL,false,true,false);
    if not Assigned(anItem) then
        Exit;

    // -- Otherwise close everything down
    aLink := gtTradingLink(anItem.Data);

    if Assigned(aLink) then
    begin
        // -- Destroy the link
        aLink.Destroy;

        // -- Destroy the item in the list
        Items.Delete(anItem.Index);

        Result := True;
    end;

end;
//---------------------------------------------------------------------------
procedure GTDConnectionList.HandleUserInformation(Sender: TObject; GTL, Description : String; PerCentComplete, IconIndex : Integer);
var
    anItem : TListItem;
    xc : Integer;
    ShortStatusCode : String;
begin
    // -- Find the item
    anItem := FindCaption(0,GTL,false,true,false);
    if Assigned(anItem) then
	begin
        // -- Update the status in the list
		anItem.SubItems[1] := Description;

		// -- Update the text so that it can be seen
		anItem.Update;
	end;
end;
//---------------------------------------------------------------------------
procedure GTDConnectionList.HandleNewLinkStatus(Sender: TObject; GTL : String; NewStatus : gtSessionUserState; LongStatus: String);
var
	anItem : TListItem;
	xc : Integer;
	ShortStatusCode : String;

	procedure ReCountConnections;
	var
		xc, cc : Integer;
	begin
		cc := 0;
		for xc := 0 to Items.Count-1 do
		begin
			anItem := Items[xc];
			if not(anItem.StateIndex in [Ord(gtusOffline),Ord(gtusStopped),Ord(gtusComplete)]) then
				Inc(cc);
		end;

		// -- Fire off the event if assigned
		if Assigned(fOnConnectionCountChange) then
			fOnConnectionCountChange(Sender,cc,Items.Count);

	end;

begin
	// -- Find the item
	anItem := FindCaption(0,GTL,false,true,false);
	if Assigned(anItem) then
	begin
		// -- Update the status in the list
		anItem.SubItems[1] := LongStatus;
		// -- Change to the new status
		xc   := Ord(NewStatus);
		anItem.StateIndex  := xc;
	end;

	// -- Now fire off the user defined event if there is one
	if Assigned(fOnStatusEvent) then
		fOnStatusEvent(Sender,GTL, ShortStatusCode, LongStatus);

	// -- Fire off an event changing the number of connections
	if Assigned(Exchange) then
	begin
		ReCountConnections;

		{
		if (NewStatus = gtusOffline) or (NewStatus = gtusComplete) then
		begin
			// Exchange.DecOutboundConnectionCount;
		end
		else if (NewStatus = gtusOnlineReady) then
		begin
			Exchange.IncOutboundConnectionCount;
		end;
		}
	end;

end;
//---------------------------------------------------------------------------
procedure GTDConnectionList.HandlePricelistUpdate(Sender: TObject; GTL : String; NewPricelistDateTime : TDateTime);
begin
    if Assigned(fOnNewPricelist) then
		fOnNewPricelist(Sender,GTL,NewPricelistDateTime);
end;
//---------------------------------------------------------------------------
procedure GTDConnectionList.HandleNewPricelistNotification(Sender: TObject; GTL : String; TimeStamp : TDateTime);
var
    anItem  : TListItem;
    theLink : gtTradingLink;
    plTime  : TDateTime;
    rc      : Integer;
    rs      : String;
begin
    // -- Find the item
    anItem := FindCaption(0,GTL,false,true,false);
    if Assigned(anItem) then
    begin
        if Assigned(anItem.Data) then
        begin
            // -- Get a pointer
            theLink := gtTradingLink(anItem.Data);

            // -- Now request off a pricelist download
            theLink.CheckPricelist;
        end;
    end;
end;
//---------------------------------------------------------------------------
procedure GTDConnectionList.ReSync(GTL : String);
var
    aLink : gtTradingLink;
    anItem : TListItem;
    xc : Integer;
begin
    if GTL = '*' then
    begin
        // -- Resync all the GTLs
        for xc := 1 to Items.Count do
        begin
            // -- Find the item
            anItem := Items[xc - 1];

            // -- Update the status in the list
            aLink := gtTradingLink(anItem.Data);
            if Assigned(aLink) then
                aLink.ReSync;
        end;
    end
    else begin
        // -- Resync just one GTL
        aLink := GetLink(GTL);
        if Assigned(aLink) then
            aLink.ReSync;
    end;
end;

//---------------------------------------------------------------------------
function GTDConnectionList.GetLink(GTL : String):gtTradingLink;
var
    anItem : TListItem;

begin
    // -- Find the item
    anItem := FindCaption(0,GTL,false,true,false);
    if Assigned(anItem) then
    begin
        // -- Update the status in the list
        Result := gtTradingLink(anItem.Data);
    end
    else
        Result := nil;
end;
//---------------------------------------------------------------------------
procedure GTDConnectionList.RequestLatestPricelist(GTL : String; PricelistDateStamp : TDateTime);
begin

end;
//---------------------------------------------------------------------------
constructor GTDLANPoint.Create(AOwner: TComponent);
begin
    inherited Create(AOwner);

    // --
    fBroadcaster := TWSocket.Create(Self);

end;
//---------------------------------------------------------------------------
procedure GTDLANPoint.FindCentralListenPoint;
begin
end;
//---------------------------------------------------------------------------
procedure GTDLANPoint.SendServerLine(L : String);
begin
    fBroadcaster.SendStr(L);
end;
//---------------------------------------------------------------------------
procedure GTDLANPoint.LogMessage(Opcode, Description : String);
begin
    // -- Send this line off to the server
    SendServerLine(RO_NOTIFICATION + GTLAN_NOTIFY_LOG_MESSAGE + ' ' +
                  EncodeStringField(GTLINK_NTFN_EVENTFIELD,OpCode) + ' ' +
                  EncodeStringField(GTLINK_NTFN_EVENTDESCR,Description));

    // -- Only send out the log message if it's assigned
    if Assigned(fOnServerLogMessage) then
        fOnServerLogMessage(Self,'',OpCode,Description);


end;
//---------------------------------------------------------------------------
procedure GTDLANPoint.NotifyWeHaveNewDocToSend(Trader_ID, Document_ID : Integer);
var
    L : String;
begin
    // -- Build up the complete notification
    L := GTLAN_CMD_RESYNC + ' ' + EncodeIntegerField(GTD_DB_COL_TRADER_ID,Trader_ID) + ' ' +
                                  EncodeIntegerField(GTD_DB_DOC_DOC_ID,Document_ID);

    // -- Now send the line off to the server
    SendServerLine(L);
end;
//---------------------------------------------------------------------------
procedure GTDLANPoint.NotifyWeHaveChgedDocStatus(Trader_ID, Document_ID : Integer);
begin
end;
//---------------------------------------------------------------------------
procedure GTDLANPoint.NotifyWeHaveNewPricelist(forTrader_ID : Integer);
begin
end;
//---------------------------------------------------------------------------
procedure GTDLANPoint.HandleDataReceived(Sender : TObject; Error : WORD);
const
    BuffDataSize = 512;
var
    p, FromLen, tno     : Integer;
    From                : sockaddr_in;
    Buffer              : Array[1..BuffDataSize] of Char;
    Organisation_ID,
    rcvStr,rspStr,
    notfcntype,notfcndesc,
    servername,opcode
                        : String;
	markA               : HECMLMarker;
begin
    // -- This data will be filled in by the socket
    FromLen := sizeof(From);

    // -- Initialise the buffer
    for p := 1 to BuffDataSize do
        Buffer[p] := #0;

    // -- Load the packet
	ReceiveFrom(@Buffer, sizeof(Buffer), From, FromLen);
    rcvStr := StrPas(@Buffer);

    if Length(rcvStr) = 0 then
        Exit;

    // -- Create a marker structure
    markA := HECMLMarker.Create;
    markA.UseSingleLine(rcvStr);

    if rcvStr[1] = RO_NOTIFICATION then
    begin

        // -- Read the type of the notification
        notfcntype := markA.ReadStringField(GTLINK_NTFN_EVENTFIELD);

        if notfcntype = GTLINK_NTFN_NEW_PRICELIST then
        begin
        end
        else if notfcntype = GTLINK_NTFN_PARTY_JOIN then
        begin
        end
        else if notfcntype = GTLINK_NTFN_PARTY_LEAVE then
        begin
        end
        else if notfcntype = GTLINK_NTFN_DOCSTATUSCHG then
        begin
        end
        else if notfcntype = GTLINK_NTFN_NEWDOC then
        begin
        end
        else if notfcntype = GTLINK_NTFN_CONNECTION then
        begin
        end;
        begin

            // -- Read out the
            opcode     := markA.ReadStringField(GTLINK_NTFN_EVENTFIELD);
            notfcndesc := markA.ReadStringField(GTLINK_NTFN_EVENTDESCR);
            servername := markA.ReadStringField(GTD_PL_ELE_COMPANY_CODE);

            // -- Fire off the event to notify the user
            if Assigned(fOnServerLogMessage) then
                fOnServerLogMessage(Self,servername,opcode,notfcndesc);
        end;

    end;

    markA.Destroy;

    // -- Send back the response string
    rspStr := rspStr + #13;
    if (rcvStr <> '') then
        SendTo(From,FromLen,Pchar(rspStr),Length(rspStr));

end;
//---------------------------------------------------------------------------
procedure GTDLANPoint.Start;
var
    mBuff   : Array[1..100] of char;
    mLen    : DWORD;
    mName   : String;
begin
    fBroadcaster.Close;
    fBroadcaster.Proto := 'udp';
    fBroadcaster.Port  := IntToStr(GTD_LANTALK_UDP_SERVER_PORT);
    fBroadcaster.Addr  := '255.255.255.255';
    fBroadcaster.Connect;

    Close;

    // -- Assign the event for when data is received
    OnDataAvailable := HandleDataReceived;

    // -- Do a broadcast to find the server
    Proto:= 'udp';
    Port := IntToStr(GTD_LANTALK_UDP_SERVER_PORT);
    if true then
        Addr := '127.0.0.1'
    else
        Addr := '255.255.255.255';

    // -- Read thhe name of this machine
    mLen := sizeof(mBuff);
    if GetComputerName(@mBuff,mLen) then
        mName := StrPas(@mBuff)
    else
        mName := 'Local Machine';

    LogMessage('Start', Application.ExeName + ' starting on machine ' + mName);

    // --
    Connect;

    if LastError = 0 then
    begin

        SendStr(GTLAN_CMD_CHECKPROXY);

        Close;
    end
    else begin
        if Assigned(fOnServerLogMessage) then
            fOnServerLogMessage(Self,'','Network','Checking Local Machine for Server');
        Addr := '127.0.0.1';
        Port := IntToStr(GTD_LANTALK_UDP_SERVER_PORT);
        Proto:= 'udp';
        Connect;
    end;

    // -- Now setup for normal listeing
    Addr := LocalIPList.Strings[0];
    Port := IntToStr(GTD_LANTALK_UDP_STATION_PORT);
    Proto:= 'udp';
    if Assigned(fOnServerLogMessage) then
        fOnServerLogMessage(Self,'','Network','Waiting for Activity');
    Listen;
end;
//---------------------------------------------------------------------------
procedure GTDLANPoint.StartSendOnly;
begin
    fBroadcaster.Close;
    fBroadcaster.Proto := 'udp';
    fBroadcaster.Port  := IntToStr(GTD_LANTALK_UDP_STATION_PORT);
    fBroadcaster.Addr  := '255.255.255.255';
    fBroadcaster.Connect;

end;

//---------------------------------------------------------------------------
procedure GTDLANPoint.Finish;
begin
    Close;
end;
//---------------------------------------------------------------------------
constructor GTDLANServerPoint.Create(AOwner: TComponent);
begin
    inherited Create(AOwner);

    fBroadcaster := TWSocket.Create(Self);
    fBroadcaster.Proto := 'udp';
    fBroadcaster.Port  := IntToStr(GTD_LANTALK_UDP_STATION_PORT);
    fBroadcaster.Addr  := '255.255.255.255';
    fBroadcaster.Connect;

end;
//---------------------------------------------------------------------------
procedure GTDLANServerPoint.Start;
begin

    try
        // -- Setup to listen
        Proto := 'udp';
        Port := IntToStr(GTD_LANTALK_UDP_SERVER_PORT);
        Addr := LocalIPList.Strings[0];

        // -- Assign the event for when data is received
        OnDataAvailable := HandleDataReceived;

        // -- Now start listening on the address
        Listen;

        NotifyServerLogMessage(ExtractFileName(Application.ExeName), 'Successfully started.');

    except
        NotifyServerLogMessage('Error', Application.Exename + ' could not start');
    end;

end;
//---------------------------------------------------------------------------
procedure GTDLANServerPoint.Stop;
begin
    NotifyServerLogMessage(ExtractFileName(Application.ExeName), 'Successfully stopped.');

    Close;
end;
//---------------------------------------------------------------------------
procedure GTDLANServerPoint.HandleDataReceived(Sender : TObject; Error : WORD);
const
    BuffDataSize = 512;
var
    p, FromLen, tno, dno : Integer;
    From            : sockaddr_in;
    Buffer          : Array[1..BuffDataSize] of Char;
    Organisation_ID,
    rcvStr,rspStr   : String;
	markA           : HECMLMarker;
begin
    // -- This data will be filled in by the socket
    FromLen := sizeof(From);

    // -- Initialise the buffer
    for p := 1 to BuffDataSize do
        Buffer[p] := #0;

    // -- Load the packet
	ReceiveFrom(@Buffer, sizeof(Buffer), From, FromLen);
    rcvStr := StrPas(@Buffer);

    // -- Process the command
    if (Copy(rcvStr,1,Length(GTLAN_CMD_CHECKPROXY)) = GTLAN_CMD_CHECKPROXY) then
    begin

        // -- Our proxy is here - send back the IP Address
        rspStr := '*Response_Code#=0 IP_Address&="' + LocalIPList.Strings[0] + '" Our_GTL&="' + Organisation_ID + '"';

    end
    else if (Copy(rcvStr,1,Length(GTLAN_CMD_RESYNC)) = GTLAN_CMD_RESYNC) then
    begin

        markA := HECMLMarker.Create;

        markA.UseSingleLine(rcvStr);

        tno := markA.ReadIntegerField(GTD_DB_COL_TRADER_ID,-1);

        markA.Destroy;

        // -- Resync a communication session
        rspStr := '*Response_Code#=0';

        // -- Fire off an event
        if Assigned(fOnNewDocument) then
            fOnNewDocument(Self,tno,Organisation_ID, dno);

        // -- Add something to the display so that we can see that we have a new doc
        {
        string g("New Document created for Trader ");
        g += intostr(tno);
        frmMain->LogMessage("New",g,0);
        }

    end
    else if (Copy(rcvStr,1,Length(GTLAN_NOTIFY_NEW_DOCUMENT)) = GTLAN_NOTIFY_NEW_DOCUMENT) then
    begin

        markA := HECMLMarker.Create;

        markA.UseSingleLine(rcvStr);

        tno := markA.ReadIntegerField(GTD_DB_COL_TRADER_ID,-1);

        markA.Destroy;

        // -- Notify the main window that we need a resync
        {
        if Assigned(fConnectionList) then
            fConnectionList.Resync(tno);
        }

        // -- Resync a communication session
        rspStr := '*Response_Code#=0';

    end
    else if (Copy(rcvStr,1,Length(GTLAN_NOTIFY_CHG_DOCUMENT)) = GTLAN_NOTIFY_CHG_DOCUMENT) then
    begin

        // -- Somebody on the LAN has changed a document
        rspStr := '*Response_Code#=0';

    end
    else if (Copy(rcvStr,1,Length(GTLAN_NOTIFY_LOCAL_STATUS)) = GTLAN_NOTIFY_LOCAL_STATUS) then
    begin

        {
		HECMLMarker *markA;

		markA = new HECMLMarker;
        markA->MsgLines->Add(rcvStr);

        int dno,tno;
        dno = markA->ReadIntegerField(GTD_DB_DOC_DOC_ID,-1);
        tno = markA->ReadIntegerField(GTLINK_RESPONSE_TEXT,-1);

        delete markA;

        NotifyDocStatusChange(tno,dno);
        }

        // -- The local status of a document has changed
        rspStr := '*Response_Code#=0\n';
    end;

    // -- Send back the response string
    rspStr := rspStr + #13;
    if (rcvStr <> '') then
        SendTo(From,FromLen,Pchar(rspStr),Length(rspStr));

end;
//---------------------------------------------------------------------------
procedure GTDLANServerPoint.NotifyConnect;
begin
    SendStr(RO_NOTIFICATION + GTLAN_NOTIFY_CONNECT);
end;
//---------------------------------------------------------------------------
procedure GTDLANServerPoint.NotifyDisconnect;
begin
    SendStr(RO_NOTIFICATION + GTLAN_NOTIFY_DISCONNECT);
end;
//---------------------------------------------------------------------------
procedure GTDLANServerPoint.NotifyServerLogMessage(Opcode, Description : String);
begin
    BroadCastLine(RO_NOTIFICATION + GTLAN_NOTIFY_LOG_MESSAGE + ' ' +
                  EncodeStringField(GTLINK_NTFN_EVENTFIELD,OpCode) + ' ' +
                  EncodeStringField(GTLINK_NTFN_EVENTDESCR,Description));
end;
//---------------------------------------------------------------------------
procedure GTDLANServerPoint.NotifyStatus(ExtraParams : String);
begin
    SendStr(RO_NOTIFICATION + GTLAN_NOTIFY_SERVER_STATUS + ' ' + ExtraParams);
end;
//---------------------------------------------------------------------------
procedure GTDLANServerPoint.BroadCastLine(L : String);
begin
    fBroadcaster.SendStr(L);
end;
//---------------------------------------------------------------------------
procedure Register;
begin
  RegisterComponents('PreisShare', [gtSessionLink]);
  RegisterComponents('PreisShare', [gtTradingLink]);
  RegisterComponents('PreisShare', [gtCommunityLink]);
  RegisterComponents('PreisShare', [GTDConnectionList]);
  RegisterComponents('PreisShare', [GTDLANServerPoint]);
  RegisterComponents('PreisShare', [gtdLANPoint]);
end;

procedure gtSessionLink.HttpCli1DocEnd(Sender: TObject);
const
    maxchunksize = 100 * 1024;
var
    xc,bs,bp,br     : Integer;
    abuff           : array[0..maxchunksize+1] of char;
    okStr, NotokStr : String;
begin
    if httpcli1.RcvdStream <> nil then
    begin

        // -- Create a new event to send over to the FSM
        bp := 0;

        // -- Rewind the memory stream
        httpcli1.RcvdStream.Seek(0,soFromBeginning);

        while bp < httpcli1.RcvdStream.Size do
        begin

            // -- Do we have more or less than a buffer full
            if httpcli1.RcvdStream.Size > maxchunksize then
                bs := maxchunksize
            else
                bs := httpcli1.RcvdStream.Size;

            // -- Read a chunk into the buffer
            br := httpcli1.RcvdStream.Read(abuff,bs);
            abuff[bs] := #0;

            ProcessRcvdDataBuffer(@aBuff,bs);

            bp := bp + br;

            if br = 0 then
                break;

        end;

        httpcli1.RcvdStream.Free;
        httpcli1.RcvdStream := nil;

        {
        // -- Add one line to our buffer which will simulate
        okStr    := EncodeIntegerField(GTLINK_RESPONSE_CODE,0) + ' ' + EncodeStringField(GTLINK_RESPONSE_TEXT,'Success');
        NotokStr := EncodeIntegerField(GTLINK_RESPONSE_CODE,GTD_ERROR_LOAD_DOCUMENT) + ' ' + EncodeStringField(GTLINK_RESPONSE_TEXT,'Command Failed');

        // -- Check for failure or success
        if httpcli1.StatusCode = 200 then
            ProcessRcvdDataBuffer(PChar(okStr),Length(okStr))
        else
            ProcessRcvdDataBuffer(PChar(NotokStr),Length(NotokStr))
        }
    end
    else
        // -- For some reason our download did not work
        ProcessRcvdDataBuffer(PChar(NotokStr),Length(NotokStr));

    // -- Destroy the input stream
    if Assigned(httpcli1.SendStream) then
    begin
        httpcli1.SendStream.Free;
        httpcli1.SendStream := nil;
    end;


end;
//---------------------------------------------------------------------------
procedure gtSessionLink.HttpCli1DocBegin(Sender: TObject);
begin
    DocFileName := httpcli1.DocName;

    if httpcli1.ContentType = 'image/gif' then
        ReplaceExt(DocFileName, 'gif')
    else if httpcli1.ContentType = 'image/jpeg' then
        ReplaceExt(DocFileName, 'jpg')
    else if httpcli1.ContentType = 'image/bmp' then
        ReplaceExt(DocFileName, 'bmp');

    if DocFileName = '' then
        DocFileName := 'HttpTst.htm';
    try
        httpcli1.RcvdStream := TMemoryStream.Create;

        // -- A quick and dirty way of telling the user that we are
        //    now doing something
        if CurrentState = gtsRecvPricelist then
            NotifyUser('Downloading..');

    except
        on E:Exception do begin
            NotifyUser('Error opening file: ' + E.Message);
            DocFileName := 'HttpTst.htm';
            NotifyUser('Using default file name: ' + DocFileName);
            httpcli1.RcvdStream := TFileStream.Create(DocFileName, fmCreate);
        end;
    end;
end;

procedure CheckProxySettings(var UseProxy : Boolean; var ProxyAddr : String; var ProxyPort : String);
var
    s : String;
begin
    s := '';
    GetSettingString(GTD_REG_NOD_GENERAL,GTD_REG_USE_PROXY,s);
    if s = '' then
    begin
        // -- This means that they've never configured. So pick up
        //    whatever IE settings that they may have
        CheckIEProxySettings(UseProxy, ProxyAddr, ProxyPort);
    end
    else if s = 'True' then
    begin
        // -- They have configured, so we can use these settings
        UseProxy := True;
        s := '';
        GetSettingString(GTD_REG_NOD_GENERAL,GTD_REG_PROXY_ADDRESS,s);
        ProxyAddr := s;
        s := '';
        GetSettingString(GTD_REG_NOD_GENERAL,GTD_REG_PROXY_PORT,s);
        ProxyPort := s;
    end
    else
        // -- They have configured and don't use a proxy
        UseProxy := False;


end;

procedure CheckIEProxySettings(var UseProxy : Boolean; var ProxyAddr : String; var ProxyPort : String);
const
    ProxyElement = 'ProxyEnable';
    ProxyAddressElement = 'ProxyServer';
    ProxyPortElement = 'ProxyPort';
    AutoDial = 'EnableAutoDial';
    ProxyKey = 'Software\Microsoft\Windows\CurrentVersion\Internet Settings';
var
	i : Integer;
	configDataHandle : HKEY;
    ProxyEnable,
    ValueInt,
	intbuff,
	intbufflen  : Integer;
	xc 	   : Integer;
	s,ElementName		: String;
	lpType : DWORD;
	textbuff : array[1..100] of byte;
	textbufflen : Integer;
begin
	// -- Initialisation
	intbuff := 0;
    UseProxy := False;

	// -- Open the section
	if (0 = RegOpenKey(HKEY_CURRENT_USER,PChar(ProxyKey),configDataHandle)) then
	begin
		// -- Look for the version
		lpType := REG_DWORD;
		intbufflen := sizeof(intbuff);

        // -- Look for proxy support
		xc:=RegQueryValueEx(configDataHandle,PChar(ProxyElement),nil,LPDWORD(@lpType),@intbuff,LPDWORD(@intbufflen));
		if (xc=0) then
		begin
			// -- Write the new updated value
			ProxyEnable := IntBuff;
            UseProxy := ProxyEnable <> 0;
		end;

        if ProxyEnable<>0 then
        begin
            // -- Look for the proxy address
    		lpType := REG_SZ;
            textbufflen := SizeOf(textbuff);
    		xc:=RegQueryValueEx(configDataHandle,PChar(ProxyAddressElement),nil,LPDWORD(@lpType),@textbuff,LPDWORD(@textbufflen));
            if (xc=0) then
            begin
                ProxyAddr := StrPas(@textbuff);
                i := Pos(':',ProxyAddr);
                if i > 0 then
                begin
                    ProxyPort := Copy(ProxyAddr,i+1,Length(ProxyAddr)-i);
                    ProxyAddr := Copy(ProxyAddr,1,i-1);
                end;
            end;

        end;
	end;

    // -- Now close down the key
	RegCloseKey(configDataHandle);
end;

end.
