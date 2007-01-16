//---------------------------------------------------------------------------
// GTDBizDocs
//
// (c) Copyright Global TradeDesk Technologies Pty Ltd
//
//     This file contains proprietory and confidential property
//     of Global TradeDesk Technologies and is licensed under
//     terms of the Global TradeDesk Source Code License
//
// Synopsis
//
//     This file contains classes for document management for
//     the Global TradeDesk Product.
//
//     The classes include:
//
//          - GTDBizDoc
//          - GTDNode
//          - GTDDocumentRegistry
//          - HECMLMarker (Legacy)
//
//---------------------------------------------------------------------------
unit GTDBizDocs;

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
  {$IFDEF LINUX}
    SysUtils, Types, Classes, Variants, QTypes, QGraphics, QControls, QForms,
    QDialogs, QStdCtrls, DateUtils,QExtCtrls,
  {$ELSE}
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
	StdCtrls, ToolWin, ComCtrls, FileCtrl, Db, DbTables, BDE, ShlObj,
	ShellAPI, bsSkinData, BusinessSkinForm,
    {$IFNDEF HW_SIMPLE} jpeg ,GTDColorButtonList, {$ENDIF}
    extctrls, HCMngr, DiffUnit,
  {$ENDIF}

  // -- Indy components
  IdBaseComponent, IdCoder, IdCoder3to4,
  IdCoderMIME;

type
  hBizOnDocumentChangeEvent = procedure(Sender: TObject; GTL : String; DocumentNumber : Integer; StatusInfo : String) of object;
  HWxmldtErrEvent = procedure(Sender : TObject; Errnum : Integer; Description : String) of object;

  gtDiffType = (	    dtUnified,	            // -- Standard Unix Unified format
						dtCompact               // -- Compact
					 );

  // -- Forward definition for our GTDode class
  GTDNode = class;
  HECMLMarker = class;

  GTDBizDoc = class(TScrollbox)
  private
	{ Private declarations }
    fDocNumber              :   Integer;
    fDirty                  :   Boolean;
	fDef,
	fBody,
	fParams                 :   TStrings;
    fBody_Chg               :   Boolean;
    fFileName               :   String;

	fRemote_Doc_ID          :   Integer;
	fRemote_Doc_ID_Chg      :   Boolean;
    fMsg_ID                 :   String;
    fMsg_ID_Chg             :   Boolean;
    fOwned_By               :   Integer;
    fOwned_By_Chg           :   Boolean;
	fShared_With            :   Integer;
	fShared_With_Chg        :   Boolean;
    fSystem_Name            :   String;
	fSystem_Name_Chg        :   Boolean;
	fDocument_Type          :   String;
    fDocument_Type_Chg      :   Boolean;
	fDocument_Ref           :   String;
    fDocument_Ref_Chg       :   Boolean;
	fDocument_Date          :   TDateTime;
	fDocument_Date_Chg      :   Boolean;
	fDocument_Total         :   Double;
    fDocument_Total_Chg     :   Boolean;
	fTax_Total              :   Double;
	fTax_Total_Chg          :   Boolean;
	fLocal_Status_Code      :   String;
    fLocal_Status_Code_Chg  :   Boolean;
    fLocal_Status_Cmts      :   String;
    fLocal_Status_Cmts_Chg  :   Boolean;
    fRemote_Status_Code     :   String;
	fRemote_Status_Code_Chg :   Boolean;
	fRemote_Status_Cmts     :   String;
    fRemote_Status_Cmts_Chg :   Boolean;
	fDeliv_Status_Code      :   String;
    fDeliv_Status_Code_Chg  :   Boolean;
    fDeliv_Status_Cmts      :   String;
    fDeliv_Status_Cmts_Chg  :   Boolean;
    fMime_Type              :   String;
	fMime_Type_Chg          :   Boolean;
    fDocument_Options       :   String;
    fDocument_Options_chg   :   Boolean;
    fUpdate_Flag            :   String;
	fUpdate_Flag_Chg        :   Boolean;

	procedure SetLocal_Doc_ID(NewValue : Integer);
    procedure SetMsg_ID(NewValue : String);
	procedure SetRemote_Doc_ID(NewValue : Integer);
    procedure SetOwned_By(NewValue : Integer);
    procedure SetShared_With(NewValue : Integer);
    procedure SetSystem_Name(NewValue : String);
    procedure SetDocument_Type(NewValue : String);
	procedure SetDocument_Ref(NewValue : String);
	procedure SetDocument_Date(NewValue : TDateTime);
	procedure SetDocument_Total(NewValue : Double);
	procedure SetTax_Total(NewValue : Double);
	procedure SetLocal_Status_Code(NewValue : String);
	procedure SetLocal_Status_Cmts(NewValue : String);
    procedure SetRemote_Status_Code(NewValue : String);
    procedure SetRemote_Status_Cmts(NewValue : String);
    procedure SetDeliv_Status_Code(NewValue : String);
    procedure SetDeliv_Status_Cmts(NewValue : String);
    procedure SetMime_Type(NewValue : String);
    procedure SetDocument_Options(NewValue : String);
    procedure SetUpdate_Flag(NewValue : String);
	procedure ChangeField(FieldTypeH_HeaderS_Status_B_Body : Char);

	procedure SetDef(Value: TStrings);
	procedure SetXml(Value: TStrings);
	procedure SetParams(Value: TStrings);

	// -- These methods relate to reading from the internal structured definition
	function LastNodeName(n :String):String;
	procedure SetIndexLine(LineNum : Integer; L : String);
	function GetIndexLine(LineNum : Integer):String;
	function IsIndexErrorLine(LineNum : Integer):Boolean;
	function GetIndexLineWithoutIndexes(LineNum : Integer):String;
	function isChild(ParentNodePath, ChildNodePath : String):Boolean;
	function ExtractChildPart(ParentNodePath, ChildNodePath : String):String;
	function GetNodeIndex(NodeToCheck : String):Integer;
	function ChopAtLevel(NodePath : String; NestLevel : Integer):String;
	function NodeOfLevel(NodePath : String; NestLevel : Integer):String;
	function NormalisedNodeName(NodePath : String):String;
	function ReadDefinitionLineNumber(LineNum : Integer):Integer;
    function FindNodePathLine(NodePath : String):Integer;

	function FindElementData(Const aNode : GTDNode; ElementName : String; var LineCount, ColumnNumber, DataWidth : Integer):Integer;
    function SetBasicElement(Const NodePath, ElementName, ElementValue : String; ElementType : Char):Boolean;
    function ComposeElement(Const ElementName, ElementValue : String; ElementType : Char):String;

  protected
	{ Protected declarations }
	// --
    function Msg_ID_Changed:Boolean;
    function BodyChanged:Boolean;
    function Remote_Doc_ID_Changed:Boolean;
	function Owned_By_Changed:Boolean;
    function Shared_With_Changed:Boolean;
    function System_Name_Changed:Boolean;
    function Document_Type_Changed:Boolean;
	function Document_Ref_Changed:Boolean;
    function Document_Date_Changed:Boolean;
	function Document_Total_Changed:Boolean;
	function Tax_Total_Changed:Boolean;
	function Local_Status_Cmts_Changed:Boolean;
	function Remote_Status_Code_Changed:Boolean;
	function Remote_Status_Cmts_Changed:Boolean;
	function Deliv_Status_Code_Changed:Boolean;
    function Deliv_Status_Cmts_Changed:Boolean;
    function Mime_Type_Changed:Boolean;
    function Document_Options_Changed:Boolean;
    function Update_Flag_Changed:Boolean;

  public
	{ Public declarations }
	constructor Create(AOwner: TComponent); override;
	destructor Destroy; override;

    procedure Clear;

	procedure SetDocumentType(aType : String);
	function GetDocumentType : String;

	procedure AddTaggedString(theTag, theValue : String);
	function ExtractTaggedString(theTag : String):String;

	function ReplaceNode(aNode : GTDNode):Boolean;
	function ReplaceTaggedSection(aMarker : HECMLMarker):Boolean;
	function ReadNextTag(var aTag : HECMLMarker):String;

    // -- Insert or Add a line in the document using 1 base
	function Insert(Index : Integer; S : String):Integer;
	function Add(S : String):Integer;

	// -- Parses the document structure. Saves the parsed results to
    //    the "Definition" StringList. Any errors found also are stored
    //    within the "Definition" but the lines start with the text
    //    'ERROR:' at the start of the line
	function FindTag(TagToFind : String; StartLine : Integer):Integer;

	// -- Counts the number of nodes
	function NodeCount(NodePathToCount: String):Integer;
	function NodeExists(NodePathToCheck: String):Boolean;

    // -- Creates nodes within the document
    function CreateNodesInDocument(NodePath : String):Boolean;
	function CreateSingleNodeInDocument(NodePath, NodeName : String):Boolean;
	function NodeNameWithoutLastIndex(n :String):String;
    function RemoveNode(NodePath : String):Boolean;

    // -- Methods for checking elements
//	function FindElement(Const NodePath, ElementName : String):Integer;
    function ElementExists(Const NodePath, ElementName : String):Boolean;
	function ElementType(Const NodePath, ElementName : String):Char;
	function GetNestCount(NodePath : String):Integer;

	// -- Methods for reading elements
    function GetStringElement(Const NodePath, ElementName : String):String;
    function GetNumberElement(Const NodePath, ElementName : String):Double;
	function GetIntegerElement(Const NodePath, ElementName : String; DefaultValue : Integer):Integer;
    function GetDateElement(Const NodePath, ElementName : String):TDateTime;
    function GetDateTimeElement(Const NodePath, ElementName : String):TDateTime;
    function GetBoolElement(Const NodePath, ElementName : String; DefaultValue : Boolean):Boolean;

	function ReadStringElement(Const NodePath, ElementName : String; var Value : String):Boolean;
	function ReadNumberElement(Const NodePath, ElementName : String; var Value : Double):Boolean;
	function ReadIntegerElement(Const NodePath, ElementName : String; var Value : Integer):Boolean;
    function ReadDateElement(Const NodePath, ElementName : String; var Value : TDateTime):Boolean;
    function ReadDateTimeElement(Const NodePath, ElementName : String; var Value : TDateTime):Boolean;
	function ReadBoolElement(Const NodePath, ElementName : String; var Value : Boolean):Boolean;
    function ReadMultiLineTStrings(Const NodePath, ElementName : String; aList : TStrings):Boolean;

	// -- Typed data updating methods
    function SetStringElement(Const NodePath, ElementName, ElementValue : String):Boolean;
    function SetCurrencyElement(Const NodePath, ElementName : String; ElementValue : Double):Boolean;
    function SetNumberElement(Const NodePath, ElementName : String; ElementValue : Double):Boolean;
    function SetIntegerElement(Const NodePath, ElementName : String; ElementValue : Integer):Boolean;
    function SetBooleanElement(Const NodePath, ElementName : String; ElementValue : Boolean):Boolean;
	function SetDateElement(Const NodePath, ElementName : String; ElementValue : TDateTime):Boolean;
	function SetMultiLineTStrings(Const NodePath, ElementName : String; ElementValue : TStrings):Boolean;

	// -- These functions are for converting images to/from base64
    function EncodeBase64(InputData: PChar; InputLen: Integer; var OutputString:string):Byte;
    {$IFDEF WIN32}
    function DecodeBase64(InputString :String; OutputData: PChar; var bytesOutput: Integer; filterdecodeinput : Boolean):Byte;
    function LoadImageAsBase64(Const SourceFileName : String):Boolean;
    {$ENDIF}

    function WriteAttachment(AttachmentName, OutputFilename : String):Boolean;
    function WriteAttachmentToStream(AttachmentName : String; OutputStream : TStream):Boolean;
    function CheckForFileInBody(const FileName : String):Integer;

    procedure LoadFromFile(FilePath : String);
    procedure LoadFromMultiLineString(SourceStr : String);

    // -- Procedures to generate diff/patch
    {$IFDEF WIN32}
    function BuildPatch(InputList : TStrings; PatchOutput : TStrings; DiffType : gtDiffType):Boolean;
    function ApplyPatch(PatchData : TStrings):Boolean;
	{$ENDIF}

    // -- Not really a public function
	function UpdateCurrentDocStatus(Returned_DocInfo : HECMLMarker; needToReverse : Boolean):Boolean;
	function RemoteToLocalMsgID(RemoteDocID : Integer):String;
	function LocalToRemoteMsgID(LocalMsgID : String):Integer;

	function Local_Status_Code_Changed:Boolean;

published
	{ Published declarations }
	property DocumentNumber : Integer read fDocNumber write fDocNumber;
	property Definition : TStrings read fDef write SetDef;
	property XML : TStrings read fBody write SetXML;
	property Params : TStrings read fParams write setParams;
	property FileName : String read fFileName;

	property Local_Doc_ID: Integer read fDocNumber write SetLocal_Doc_ID;
	property Remote_Doc_ID: Integer read fRemote_Doc_ID write SetRemote_Doc_ID;
	property Msg_ID: String read fMsg_ID write SetMsg_ID;
	property Owned_By: Integer read fOwned_By write SetOwned_By;
	property Shared_With: Integer read fShared_With write SetShared_With;
	property System_Name : String read fSystem_Name write SetSystem_Name;
    property Document_Type : String read fDocument_Type write SetDocument_Type;
    property Document_Ref:  String read fDocument_Ref write SetDocument_Ref;
    property Document_Date : TDateTime read fDocument_Date write SetDocument_Date;
	property Document_Total: Double read fDocument_Total write SetDocument_Total;
	property Tax_Total: Double read fTax_Total write SetTax_Total;
	property Local_Status_Code : String read fLocal_Status_Code write SetLocal_Status_Code;
	property Local_Status_Comments : String read fLocal_Status_Cmts write SetLocal_Status_Cmts;
	property Remote_Status_Code: String read fRemote_Status_Code write SetRemote_Status_Code;
    property Remote_Status_Comments: String read fRemote_Status_Cmts write SetRemote_Status_Cmts;
    property Delivery_Status_Code: String read fDeliv_Status_Code write SetDeliv_Status_Code;
	property Delivery_Status_Comments: String read fDeliv_Status_Cmts write SetDeliv_Status_Cmts;
	property Mime_Type: String read fMime_Type write SetMime_Type;
    property Document_Options: String read fDocument_Options write SetDocument_Options;
    property Update_Flag: String read fUpdate_Flag write SetUpdate_Flag;
    property HasChanged : Boolean read fDirty;

	property Visible;

	// These methods read from the control
        {$IFDEF WIN32}
	procedure lsvLoadSubItems(aListView : TListView; SearchSection : HECMLMarker; ColumnNames : String);
	  {$IFNDEF HW_SIMPLE}
	  procedure PrepareXML;
  	  {$ENDIF}
        {$ENDIF}
	function FindLine(StartPos : Integer; TagName,ColumnName,DataValue : String):Integer;

  end;

  //-- Markers - This is a class that needs to be phased out as it is
  //             obsolete but is used within the legacy code
  HECMLMarker = class(TObject)
	public

		LineNumber, ColumnNumber, RegionEndLine : Integer;
		SectionMarking,onTag : Boolean;
		SectionName : String;
		MsgLines : TStringList;
		CameFromLine, CameFromCol, CameFromCount, defaultElementCol : Integer;

		constructor Create;
		procedure UseBodyText(UseStrings : TStrings);
        procedure UseSingleLine(S : String);

		// -- Simple Navigation Methods
		function ReadNextTag:String;
		function FindTag(TagToFind : String; StopAtLine :Integer = -1):Boolean;
		function FindTagRegion(TagToFind : String):Boolean;
		procedure SkipTaggedSection;
		procedure GotoStart;
		procedure GotoLine(const l: Integer);

		// -- Rudimentory Editing Methods
		procedure Clear;
		function Add(S : String):Integer;
		function Insert(Index : Integer; S : String):Integer;

		procedure Assign(TagToCopy : HECMLMarker);
		{$IFDEF HW_SIMPLE}
		function ExtractTaggedSection(aSection : string; fromMarker : HECMLMarker):Boolean;
		{$ELSE}
		function ExtractTaggedSection(aSection : string; FromStringList : TStrings):Boolean; overload;
		function ExtractTaggedSection(aSection : string; fromMarker : HECMLMarker):Boolean; overload;
		{$ENDIF}
		{$IFDEF HW_SIMPLE}
		function AppendTaggedSection(SectionTag : String; aTag : HECMLMarker; TabIndex : Integer):Boolean;
                {$ELSE}
		function AppendTaggedSection(SectionTag : String; aTag : HECMLMarker; TabIndex : Integer = 0):Boolean;
				{$ENDIF}
		function RemoveTaggedSection(aSection : string; var LineNo : Integer):Boolean;
		function ReplaceTaggedSection(aSection : string; aTag : HECMLMarker):Boolean;
		function ReplaceMarker(aTag : HECMLMarker):Boolean;
		function InsertTaggedSection(SectionTag : String; aTag : HECMLMarker; LineNumber : Integer):Boolean;
		function InsertMarkerBefore(SectionTag : String; aTag : HECMLMarker):Boolean;

		{$IFNDEF LINUX}
		procedure LoadDataLSV(RecordTag, ColumnNames : String; aListView : TListView);
		{$ENDIF}

		// -- Typed data extraction methods
        function ReadRawField(FieldName : String; DefaultValue : String; var FieldType : Char):String;
		function ReadStringField(FieldName : String; DefaultValue : String = ''):String;
		function ReadIntegerField(FieldName : String; DefaultValue : Integer):Integer;
		function ReadNumberField(FieldName : String; defaultValue : Double):Extended;
		function ReadDateField(FieldName : String; defaultValue :TDateTime):TDateTime;
		function ReadDateTimeField(Fieldname : String; defaultValue :TDateTime):TDateTime;

		procedure ReadMultiLineTStrings(FieldName : String; aList : TStrings);

		function ReadBooleanField(FieldName : String; DefaultValue : Boolean):Boolean;

		// -- Typed data updating methods
		procedure WriteStringField(FieldName, FieldValue : String);

                {$IFDEF WIN32}
		{$IFNDEF HW_SIMPLE}
		procedure LoadDataCBL(RecordTag, ColumnNames : String; aButtonList : hColorButtonList);
		{$ENDIF}
                {$ENDIF}
	protected
	private
	published
  end;

  // -- GTDNode
  //
  // Synopsis
  // This class holds a node (and nested nodes) within a document
  // tree. Editing of fields is done by first loading up a node
  // and then editing the field elements within that node directly
  GTDNode = class(HECMLMarker)
	public
//		constructor Create;

        // - Load a node from an existing document
		function LoadFromDocument(SourceDoc : GTDBizDoc; NodePath : String; LockSection : Boolean):Boolean;

  end;

  // -- GTDDocumentRegistry
  //
  // Synopsis
  // This class represents the document Registry for Global TradeDesk
  // which is assumed to operate over the top of an SQL Database
  //
  {$IFDEF LINUX}
  GTDDocumentRegistry = class(TMemo)
  {$ELSE}
  GTDDocumentRegistry = class(TListView)
  {$ENDIF}
	public
		// --
		constructor Create(AOwner: TComponent); override;
		destructor Destroy; override;

		// -- Open the registry to test the Database connection
		function OpenRegistry(Params : String; var StatusText : String):Boolean;
		procedure Close;

		// -- Open the registry for a particular organisation
                {$IFNDEF LINUX}
		function CreateFor(OrganisationsGTL, OrganisationName, Trading_Relationship, Trading_Status_Code : String):Boolean;
		function OpenFor(OrganisationsGTL : String):Boolean;
		function OpenForTraderNumber(TraderNumber : Integer):Boolean;

		// -- A search to locate an exact match
		function FindTraderByAccountCode(AccountCode : String):Integer;

		// -- Creates a TQuery filled with documents - destroy after use
                {$IFNDEF LIGHTWEIGHT}
		function BuildDocumentRecordset:TQuery;
                {$ENDIF}
                {$ENDIF} // LInux

		// -- Simple loading and saving documents
		function AddNew(var newDoc : GTDBizDoc; DocType : String):Boolean;
		function Load(DocumentNumber : Integer; var Destination : GTDBizDoc):Boolean;
		function Save(Doc : GTDBizDoc; AuditCode, AuditText : String; ReceivedDoc : Boolean = False ):Boolean;
		function Delete(var newDoc : GTDBizDoc):Boolean;
		function RefreshStatus(var Doc : GTDBizDoc):Boolean;

		// --
		function GetLatestStatement(var Statement : GTDBizDoc):Boolean;
		function GetLatestPriceList(var PriceList : GTDBizDoc):Boolean;

		function SaveAsLatestPriceList(PriceList : GTDBizDoc; PriceListDateTime : TDateTime; var LogText : String; Validate : Boolean = True):Boolean;
		{$IFNDEF LINUX}
		{$IFDEF LIGHTWEIGHT}
		function GetLatestStatementFileName:String;
		function GetLatestPriceListFileName:String;
		{$ENDIF}
		{$ENDIF}

        // -- Adds Vendor information to a pricelist
        function AddStandardVendorInfo(aDoc : GTDBizDoc):Boolean;
        function AddCurrentTraderVendorInfo(aDoc : GTDBizDoc):Boolean;

		// -- Some document validation procedures
		function ValidatePriceList(aDoc : GTDBizDoc; Options : String; var Log : String):Boolean;
		function ValidatePurchaseOrder(aDoc : GTDBizDoc; Options : String; var Log : String):Boolean;
		function ValidateInvoice(aDoc : GTDBizDoc; Options : String; var Log : String):Boolean;
		function ValidateStatement(aDoc : GTDBizDoc; Options : String; var Log : String):Boolean;
		function ValidatePaymentAdvice(aDoc : GTDBizDoc; Options : String; var Log : String):Boolean;

		// -- Login/Security
		function  ProcessAutoSubscribe(LoginLine : String; var newTID:Integer; var newCID:Integer):Boolean;
		function  GetSupplierAccessInfo(Trader_ID : Integer; var requiredConnection_ID : Integer; var Password : String):Boolean;
		function  GetCustomerAccessInfo(Trader_ID : Integer; requiredConnection_ID : Integer; var Password : String):Boolean;
		function  SaveTraderAccessInfo(Trader_ID : Integer; Connection_ID : Integer; Password : String):Boolean;
		function  GetCustomerNumber:Integer;
        procedure SaveCustomerNumber(NewNumber:Integer; NewPassword : String = '');
		function  GetCustomerPassword:String;
        procedure SaveCustomerPassword(NewPassword:String);

                {$IFNDEF LINUX}
		function GetNewDocumentNumbers(var TotalDocsAvailable : Integer):String;
		function GetUpdatedDocumentNumbers(ReturnRemoteIDs : Boolean = False):String;

		function SetReadOnlyFlag(DocumentNumber : Integer; FlagStatus : Boolean):Boolean;
		{$IFDEF LIGHTWEIGHT}
		function ConvertPricelistNameToGTL(PricelistPath : String):String;
		{$ENDIF}

		// -- Directory and file management functions
		{$IFDEF LIGHTWEIGHT}
		function GetTradalogDir:String;
		function GetReceivedDocDir:String;
		Procedure SetTradalogDir(newDir :String);
		{$ENDIF}
		function GetOurImageDir:String;
		function GetDownloadImageDir:String;
		function SaveReceivedImage(ShortFileName: String; Base64ImageDocument : GTDBizDoc):Boolean;
		function AddProductImage(ImageFileName : String; FullWidth, ThumbWidth : Integer):String;

		function HaveImage(ImageFileName : String):Boolean;
		function LoadImage(ImageFileName : String; WhereTo : TImage; UseThumbnailOk : Boolean = True):Boolean;
		function GetFullImagePath(ImageFileName : String):String;

		function GetNextRegistryInt(SectionName,ElementName : String; var ValueInt : Integer):Boolean;

		function DisplayActiveDocuments:Boolean;

		procedure LoadHistoryToLSV(aDoc : GTDBizDoc; var HistoryDisplayList : TListView);

		// -- This method allows for writing to the history file
		function RecordAuditTrail(aDoc : GTDBizDoc; AuditCode, AuditDescription : String; ExtraText : TStrings = nil):Boolean;

		// -- Secuurity functions
		procedure SignDocument(aDoc : GTDBizDoc);
		function  CalcDocumentSignature(aDoc : GTDBizDoc):String;
		function  DocumentSignatureOk(aDoc : GTDBizDoc):Boolean;
		procedure SetFieldEncryptionKey(KeyText : String);
		function  LoadKeyFile(KeyFileName : String):Boolean;
		procedure Generatekeyfile(targetGTL, Passphrase, KeyFileName : String);

		// -- Registration key functions
		function  LoadRegistrationInfo(RegistrationText : TStringList):Boolean;
		function  DecodeRegistrationInfo(RegistrationText : TStringList):Boolean;
		procedure BuildRegistrationInfo(OrgGTL,OrgName,state_code,country_code,MachineNames,os_name : String; Expiry_Date : TDateTime; CodedRegistration : TStringList);
		function  AddRegistrationInfo(RegistrationText : TStringList):Boolean;

		function GetLatestPriceListDateTime:TDateTime;
		{$IFDEF LIGHTWEIGHT}
		function FindPricelistFileForGTL(GTL : String):String;
		function GetActiveDocumentDir:String;
		{$ELSE}
//        procedure UseDatabase(UserDB : TDatabase);
		{$ENDIF}
		{$ENDIF}

		// -- Information about the local company
		function GetGTL:String;
		function GetCompanyName:String;
		function GetAddress1:String;
		function GetAddress2:String;
		function GetCity:String;
		function GetState:String;
		function GetPostcode:String;
		function GetCountryCode:String;

        // -- Multi-lingual multicountry address line build
        procedure BuildSingleAddressLine(var Line : String);
        procedure BuildDoubleAddressLine(var Line1 : String; var Line2 : String);

		// -- Configuration functions.
		//    why here? the DocumentRegistry has access to the database
		//    and these gunctions read/write to the sysvals table.
		function GetSettingString(SectionName,ElementName : String; var ValueStr : String):Boolean;
		function GetSettingInt(SectionName,ElementName : String; var ValueInt : Integer):Boolean;
		function GetNextSettingInt(SectionName,ElementName : String; var ValueInt : Integer):Boolean;

		function SaveSettingString(SectionName,ElementName : String; ValueStr : String):Boolean;
		function SaveSettingInt(SectionName,ElementName : String; ValueInt : Integer):Boolean;

        function RenameSettingRecord(SectionName,ElementName,NewElementName : String):Boolean;
        function DeleteSettingRecord(SectionName,ElementName : String):Boolean;

        //    These functions read and write to the memo field within
        //    the current configuration record
   		function GetSettingMemoString(NodePath, ElementName : String; var ValueStr : String):Boolean;
   		function GetSettingMemoInt(NodePath, ElementName : String; var ValueInt : Integer):Boolean;
   		function GetSettingMemoBoolean(NodePath, ElementName : String; var Value : Boolean):Boolean;
		function SaveSettingMemoString(NodePath, ElementName, ValueStr : String; FinalSave : Boolean = True):Boolean;
		function SaveSettingMemoInt(NodePath, ElementName : String; ValueInt : Integer; FinalSave : Boolean):Boolean;
        //    Retrieve a list of all available items into a list for a given section
   		function GetSettingItemList(SectionName : String; ElementNames : TStrings):Boolean;

        // -- These functions read and write to the memo field
        //    "settings" on the currently select trader_record
   		function GetTraderSettingString(NodePath, ElementName : String; var ValueStr : String):Boolean;
   		function GetTraderSettingInt(NodePath, ElementName : String; var ValueInt : Integer):Boolean;
   		function GetTraderSettingBoolean(NodePath, ElementName : String; var Value : Boolean):Boolean;
		function SaveTraderSettingString(NodePath, ElementName, ValueStr : String; FinalSave : Boolean = True):Boolean;
		function SaveTraderSettingInt(NodePath, ElementName : String; ValueInt : Integer; FinalSave : Boolean = True):Boolean;

		function ExtractDocDetails(aDocument : GTDBizDoc):String;

        function GetVendorShortnameList(aList : TStringList):Boolean;

	private
		fSessionName,
		fDatabaseName       : String;

		fRemoteGTL          : String;
		fRemoteTraderID     : Integer;
		fTraderName         : String;

		fPricelistDateTime  : TDateTime;
		fPricelistDocNum    : Integer;
		fOnDocumentChange   : hBizOnDocumentChangeEvent;

		{$IFDEF WIN32}
		fHashManager        : THashManager;
		fCipherManager      : TCipherManager;
		{$ENDIF}

        fDoingPricelistPatches : Boolean;
        
		{$IFDEF LIGHTWEIGHT}
		fTradalogDir,
		fDocumentDir,
		fDocumentRegPath    : String;
		{$ELSE}
		fSysValTbl,
		fDocTbl,
		fTraderTbl,
		fAuditTbl,
		fKeyTbl            : TTable;
		{$ENDIF}
		function GetTraderIDFromGTL:Integer;
		procedure SetGTL(newGTL : String);

		{$IFNDEF LINUX}
		function LoadRegistryDetails(DocumentNumber : Integer; var aDocument : GTDBizDoc):Boolean;
		{$ENDIF}
		{$IFNDEF LIGHTWEIGHT}
		procedure SetDatabaseName(NewDBName : String);
		{$ENDIF}

	published
		{$IFNDEF LIGHTWEIGHT}
		property DatabaseName : String read fDatabaseName write SetDatabaseName;
		{$ELSE}
		property DatabaseName : String read fDatabaseName write fDatabaseName;
		{$ENDIF}
		property SessionName : String read fSessionName write fSessionName;
		property GTL : String read fRemoteGTL write SetGTL;
		property Trader_ID : Integer read fRemoteTraderID write fRemoteTraderID;
		property Trader_Name : String read fTraderName write fTraderName;
		property PriceListDocumentNumber : Integer read fPricelistDocNum;
		property OnDocumentChange : hBizOnDocumentChangeEvent read fOnDocumentChange write fOnDocumentChange;
		{$IFDEF WIN32}
		property HashManager : THashManager read fHashManager write fHashManager;
		property CipherManager : TCipherManager read fCipherManager write fCipherManager;
		{$ENDIF}
		{$IFDEF LIGHTWEIGHT}
		{$IFNDEF LINUX}
		property TradalogDir : String read fTradalogDir write SetTradalogDir;
		property PriceListDateTime : TDateTime read GetLatestPriceListDateTime;
		property PriceListFileName : String read GetLatestPriceListFileName;
		{$ENDIF}
		{$ELSE}
		property PriceListDateTime : TDateTime read fPricelistDateTime;
        property Traders : TTable read fTraderTbl write fTraderTbl;
        property Documents : TTable read fDocTbl write fDocTbl;
		{$ENDIF}
	public
		{$IFDEF LIGHTWEIGHT}    // -- not nice but neccesary for the ClientConnector
		fStorage            : GTDBizDoc;
		{$ENDIF}

  end;

procedure Register;
function StringToFloat(const S: string): Extended;
function EncodeString(StringToEncode : String; EncodeType : Char):String;
function DecodeString(StringToEncode : String; EncodeType : Char):String;
function AsCurrency(Val : Double; CountryCode : String = ''):String;
function AsSQLDateTime(anyDate : TDateTime):String;
function AsSQLDate(anyDate : TDateTime):String;
function Parse(var StringToParse : String; const delims : String):String;
function EncodeSQLString(S : String):String;
function EncodeStringField(ElementName, s : String):String;
function EncodeBooleanField(ElementName : String; v : Boolean):String;
function EncodeDateTimeField(ElementName : String; aTime : TDateTime):String;
function EncodeCurrencyField(ElementName : String; CurrencyValue : Currency):String;
function EncodeIntegerField(ElementName : String; i : Integer):String;
function GetCodeFromCountryName(CountryName : String):String;
function GetNameFromCountryCode(CountryCode : String):String;
function GetTaxNameFromCountryCode(CountryCode : String = ''):String;
function GetSalesTaxRateFromCountryCode(CountryCode : String):Currency;
function GetSalesTaxIsInclusive(CountryCode : String = ''):Boolean;
function BuildTraderAddress(a1, a2, city, state, postcode, countrycode, tel1, tel2, acn : String):String;
function GetCountryNameList(CountryList : TStrings):Boolean;
function GetEnglishCountryName:String;
function GetSystemCountryNumber:String;
function GetCountryCode:String;
function LoadStateNames(CountryCode : String; aList : TStrings):Boolean;
function GetSoftwareInstallDir(ProductName : String = ''):String;
function GetBuildInfoString: String;
{$IFDEF WIN32}
  procedure GetAliases (const AList: TStrings; const IncludeTypes : String);
  function BDEAliasExists(DBName: string):Boolean;
  function GetDesktopPath: string;
  function ProgramRunWait(const CommandLine,DefaultDirectory: string; Wait, QuietMode : boolean; var ErrorMessage : String):Boolean;
  function RunAProgram (const theProgram, itsParameters, defaultDirectory: string; QuietMode : boolean; var ErrorMessage : String):Boolean;
{$ENDIF}
function isNumber(S : String; ExtraChars : String = ''):Boolean;
function HashLine(const line: string; IgnoreCase, IgnoreBlanks: boolean): pointer;
function StringListToString(aList : TStrings):String;
function pad(s:string; n:integer): string;
function GetTempDir:String;
function GetMachineName:String;
function GetCurrentUserName:String;

// -- Functions for using the registry  (absolute windows path}
function GetConfigString(SectionName,ElementName : String; var ValueStr : String):Boolean;
function GetConfigInt(SectionName,ElementName : String; var ValueInt : Integer):Boolean;
function GetNextConfigInt(SectionName,ElementName : String; var ValueInt : Integer):Boolean;

// -- Generic functions - uses gtKeyPath
function GetSettingString(SectionName,ElementName : String; var ValueStr : String):Boolean;
function GetSettingInt(SectionName,ElementName : String; var ValueInt : Integer):Boolean;
function GetNextSettingInt(SectionName,ElementName : String; var ValueInt : Integer):Boolean;

function SaveSettingString(SectionName,ElementName : String; ValueStr : String):Boolean;
function SaveSettingInt(SectionName,ElementName : String; ValueInt : Integer):Boolean;

// -- Absolute path into the registry
function GetRegistryString(SectionName,ElementName : String; var ValueStr : String):Boolean;
function SaveRegistryString(SectionName,ElementName : String; ValueStr : String):Boolean;

{$IFNDEF LINUX}
function LoadUserSkinForm(SkinData : TbsSkinData):Boolean;
{$ENDIF}

const
	gtKeyPath                   = 'Software\PreisShare\';

    {$IFNDEF LINUX}
    pathslash                   = '\';
    {$ELSE}
    pathslash                   = '/';
    {$ENDIF}

	// -- Configuration keys
	GTD_REG_NOD_GENERAL         = 'General';
    GTD_REG_NOD_ORDERSERVER     = 'Ordering Server';
    GTD_REG_NOD_CONNECTOR       = 'PreisShare';
	GTD_REG_NOD_ACCOUNTSENDER   = 'BillSender';
	GTD_REG_NOD_PRLSTREADER     = 'Pricelist Sender';
    GTD_REG_NOD_FILEWRITER      = 'File Writer';

	GTD_REG_DATABASE_DRIVER     = 'Database_Driver';
	GTD_REG_BDE_ALIAS           = 'BDE_Alias';
	GTD_REG_BDE_DIRECTORY       = 'BDE_Directory';
	TRADAMATRIX_MIME_DOC        = 'text/tradalog';
	TRADALOG_MIME_DOC           = 'text/tradalog';

	ECML_STRING_SUFFIX          = '&';
	ECML_CURRENCY_SUFFIX        = '$';
    ECML_EURO_SUFFIX            = '€';
	ECML_INTEGER_SUFFIX         = '!';
	ECML_NUMBER_SUFFIX          = '#';
	ECML_DATE_SUFFIX            = '@';
	ECML_LONGUTEXT_SUFFIX       = '^';
	ECML_LONGFTEXT_SUFFIX       = '^';
	ECML_BOOLEAN_SUFFIX         = '?';
	ECML_JPEG_SUFFIX            = '<';
	ECML_GIF_SUFFIX             = '>';
	ECML_ALL_SUFFIXES           = '&$!#@^?<>';

	DOCDEF_ERROR_TAG            = 'ERROR:';

	// -- These are passwords for the database, that are stored in the registry
	GTD_REG_USERID              = 'RF_Sync';
	GTD_REG_PASSWORD            = 'RF_Value';

	// -- These are keys for reading from the registry
	GTD_REG_GTL                     = 'Grid Trading Location';				// -- Grid trading location
	GTD_REG_USER_NAME               = 'My Name';
	GTD_REG_USER_POSITION           = 'My Position';
	GTD_REG_USER_DEPARTMENT         = 'My Department';
	GTD_REG_USER_EMAIL              = 'Email';
	GTD_REG_COMPANY_NAME            = 'Organisation_Name';
	GTD_REG_ADDRESS_LINE_1          = 'Address_Line_1';
	GTD_REG_ADDRESS_LINE_2          = 'Address_Line_2';
    GTD_REG_TOWN                    = 'Suburb_Town';
	GTD_REG_STATE_REGION            = 'State_Region';
	GTD_REG_POSTALCODE              = 'ZIP_Postcode';
    GTD_REG_COUNTRYCODE             = 'Country_Code';
    GTD_REG_FAX                     = 'Fax';
	GTD_REG_WEBSITE                 = 'Website';
    GTD_REG_TELEPHONE               = 'Telephone';
	GTD_REG_OTHER_INFO              = 'Other_Information';
	GTD_REG_RELATIONSHIP            = 'Trading_Relationship';
	GTD_REG_STATUS_CODE             = 'Trading_Status_Code';
    GTD_REG_CATEGORIES              = 'Category_List';
    GTD_REG_LATTITUDE               = 'Lattitude';
    GTD_REG_LONGITUDE               = 'Longitude';
	GTD_REG_KEY_CATEGORIES          = 'Registered Categories';
	GTD_REG_COM_SERVERIP            = 'Exchange IP Address';
	GTD_REG_LOC_MAP_X               = 'World Map X';
    GTD_REG_LOC_MAP_Y               = 'World Map Y';
    GTD_REG_CONNECTION              = 'Connection';

    // -- These keys tell where the product database is
    GTD_PRODUCTDB_KEY               = 'Product Database';
    GTD_PRODDB_SUPPLIER_TABLE       = 'Supplier Table';
    GTD_PRODDB_GROUPS_TABLE         = 'Product Groups Table';
    GTD_PRODDB_ITEMS_TABLE          = 'Product Items Table';
    GTD_PRODDB_NAME                 = 'Name';
    GTD_PRODDB_TYPE                 = 'Type';
    GTD_PRODDB_SUPPLIER_ID_COL      = 'Supplier_ID';

	// -- Exchange UserID and Password
	GTD_REG_XCHG_CUSTOMERID         = 'Customer_Number';
    GTD_REG_XCHG_PASSWORD           = 'Customer_Key';

	GTD_REG_USE_PROXY               = 'Use Proxy';
	GTD_REG_PROXY_ADDRESS           = 'Proxy Address';
	GTD_REG_PROXY_PORT              = 'Proxy Port';

	TabCharCount                = 2;            // -- Number of characters for tab padding

//    GTD_STD_DATEMASK            = 'YYYY-MMM-DD';
//    GTD_STD_DATETIMEMASK        = 'DD-MMM-YYY HH:NN:SS';

	GTD_DATETIMESTAMPFORMAT     = 'YYYY-MM-DD HH:NN:SS';
	GTD_DATESTAMPFORMAT         = 'YYYY-MM-DD';
	GTD_DATECATTIMEFORMAT       = 'YYYY-MM-DD HH:NN:SS';

	// -- These are the elements that are transmitted
	//    in a login session and within PriceLists
	// -- primary list
	GTD_LGN_ELE_TRADER_ID        	= 'Trader_ID';			// Trader_ID
	GTD_LGN_ELE_CONNECTION_ID      	= 'Connection_ID'; 		// Trader_ID
	GTD_LGN_ELE_COMPANY_CODE        = 'PreisShare_ID';      // Logical Name
	GTD_LGN_ELE_USER_NAME           = 'User_Name';          // Users login name
	GTD_LGN_ELE_MACHINE_NAME        = 'Machine_Name';       //
	GTD_LGN_ELE_PWORD               = 'Password';
	GTD_LGN_ELE_PASSWORD_HASH       = 'Password_Hash';
	GTD_LGN_ELE_ACCESS_TYPE			= 'Machine_Type';
		// -- Types of the above
		GTD_LGN_ACCESS_SERVER       = 'Server';
		GTD_LGN_ACCESS_WORKSTATION  = 'Workstation';
		GTD_LGN_ACCESS_VIEWSTATION  = 'ViewStation';
	// -- secondary, or for honest login
	GTD_LGN_ELE_COMPANY_NAME        = 'Organisation_Name';
	GTD_LGN_ELE_ADDRESS_LINE_1      = 'Address_Line_1';
	GTD_LGN_ELE_ADDRESS_LINE_2      = 'Address_Line_2';
	GTD_LGN_ELE_TOWN                = 'Suburb_Town';
	GTD_LGN_ELE_STATE_REGION        = 'State_Region';
	GTD_LGN_ELE_POSTALCODE          = 'ZIP_Postcode';
	GTD_LGN_ELE_COUNTRYCODE         = 'Country_Code';
	GTD_LGN_ELE_FAX                 = 'Fax';
	GTD_LGN_ELE_TELEPHONE           = 'Telephone';
	GTD_LGN_ELE_RELATIONSHIP        = 'Trading_Relationship';
	GTD_LGN_ELE_STATUS_CODE         = 'Trading_Status_Code';
	GTD_LGN_ELE_CATEGORIES          = 'Category_List';
	GTD_LGN_ELE_LATTITUDE           = 'Lattitude';
	GTD_LGN_ELE_LONGITUDE           = 'Longitude';
	GTD_LGN_ELE_ACCESS_KEY          = 'Public_Key';

	// -- Pricelist Document Node and Element Definitions
    GTD_PL_VENDORINFO_TAG       = 'Vendor Information';
    GTD_PL_VENDORINFO_NODE      = '/PriceList/' + GTD_PL_VENDORINFO_TAG;
    GTD_PL_ELE_COMPANY_CODE     = 'PreisShare_ID';
	GTD_PL_ELE_COMPANY_NAME     = 'Organisation_Name';
	GTD_PL_ELE_ADDRESS_LINE_1   = 'Address_Line_1';
	GTD_PL_ELE_ADDRESS_LINE_2   = 'Address_Line_2';
	GTD_PL_ELE_TOWN             = 'Suburb_Town';
	GTD_PL_ELE_STATE_REGION     = 'State_Region';
	GTD_PL_ELE_POSTALCODE       = 'ZIP_Postcode';
	GTD_PL_ELE_COUNTRYCODE      = 'Country_Code';
    GTD_PL_ELE_IPADDRESS        = 'IP_Address';
	GTD_PL_ELE_FAX              = 'Fax';
	GTD_PL_ELE_PROFILE          = 'Profile_Description';
	GTD_PL_ELE_TELEPHONE        = 'Telephone';
	GTD_PL_ELE_TELEPHONE2       = 'Telephone_2';
	GTD_PL_ELE_EMAIL_ADDRESS    = 'Email_Address';
	GTD_PL_ELE_OTHER_INFO       = 'Other_Information';
	GTD_PL_ELE_SELL_CATEGORIES  = 'Selling_Categories';
	GTD_PL_ELE_BUY_CATEGORIES   = 'Buying_Categories';
	GTD_PL_ELE_LATTITUDE        = 'Lattitude';
	GTD_PL_ELE_LONGITUDE        = 'Longitude';
	GTD_PL_ELE_COORDINATES      = 'Coordinates';
	GTD_PL_ELE_CONTACT          = 'Contact';

	GTD_PL_DELIVERY_NODE        = '/PriceList/Delivery Information';
	GTD_PL_ELE_DELIVERY_MODE    = 'Delivery_Modes';
	GTD_PL_DELIVTYPE_UPS        = 'UPS';
    GTD_PL_DELIVTYPE_FEDEX      = 'Fedex';
    GTD_PL_DELIVTYPE_AIR        = 'Air Freight';
    GTD_PL_DELIVTYPE_SEA        = 'Sea';
    GTD_PL_DELIVTYPE_COLLECT    = 'Collect';
	GTD_PL_DELIVTYPE_COURIER    = 'Courier';
    GTD_PL_ELE_MIN_DELIV_CHARGE = 'Minimum_Delivery_Cost';

	// -- Information area
	GTD_PL_INFORMATION_TAG      = 'Summary';
	GTD_PL_INFORMATION_NODE     = '/PriceList/' + GTD_PL_INFORMATION_TAG;
	GTD_PL_ELE_COLUMNS_USED     = 'Columns_Used';

    GTD_PL_INFORMATION_ITEM_NODE= '/Item';
	GTD_PL_ELE_INFO_TITLE       = 'Title';
	GTD_PL_ELE_INFO_TEXT        = 'Description';
	GTD_PL_INFO_IMAGE_NODE      = '/Image';
    GTD_PL_ELE_INFO_IMAGE_ID    = 'Filename';

    // -- Banking details
    GTD_PL_BANKING_NODE         = '/PriceList/Banking Details';
    GTD_PL_ELE_BANK_BSB         = 'Our_BSB';
	GTD_PL_ELE_BANK_ACCT        = 'Our_Account_Number';
    GTD_PL_ELE_BANK_GTL         = 'Our_Bank_GTL';
    GTD_PL_ELE_PAYMENT_TYPES    = 'Payment_Types';

	// -- Payment/Card Types
    GTD_PL_PAYTYPE_ACCOUNT      = 'Account';
    GTD_PL_CARDTYPE_EFT         = 'Eft';
    GTD_PL_CARDTYPE_AMEX        = 'American Express';
	GTD_PL_CARDTYPE_DINERS      = 'Diners Club';
    GTD_PL_CARDTYPE_JCB         = 'JCB';
    GTD_PL_CARDTYPE_CARTEBLACHE = 'Carte Blache';
    GTD_PL_CARDTYPE_VISA        = 'Visa';
    GTD_PL_CARDTYPE_MC          = 'MasterCard';
	GTD_PL_CARDTYPE_BC          = 'BankCard';
    GTD_PL_CARDTYPE_DISCNOVUS   = 'Discover/Novus';

	GTD_PL_PRICELIST_TAG        = 'PriceList';
	GTD_PL_PATCH_TAG            = 'Pricelst Patch';

	GTD_PL_PRODUCTINFO_TAG      = 'Product Information';
	GTD_PL_PRODUCTINFO_NODE     = '/PriceList/' + GTD_PL_PRODUCTINFO_TAG; // /PriceList/Product Information
    GTD_PL_PRODUCTGROUP_TAG     = 'Product Group';
    GTD_PL_PRODUCTGROUP_NODE    = '/' + GTD_PL_PRODUCTGROUP_TAG;
    GTD_PL_PRODUCTGROUPL2_TAG   = 'Product Group Level 2';
    GTD_PL_PRODUCTGROUPL2_NODE  = '/' + GTD_PL_PRODUCTGROUPL2_TAG;
	GTD_PL_PRODUCTGROUPL3_NODE  = '/Product Group Level 3';
    GTD_PL_ELE_GROUP_NAME       = 'Group_Description';
	GTD_PL_ELE_GROUPL2_NAME     = 'Group_Description_2';
    GTD_PL_ELE_GROUPL3_NAME     = 'Group_Description_3';
    GTD_PL_PRODUCTITEMS_NODE    = '/Product Items';
	GTD_PL_PRODUCTITEM_NODE     = '/Product';
	GTD_PL_PRODUCTITEMS_TAG     = 'Product Items';
	GTD_PL_PRODUCTITEM_TAG      = 'Product';
	GTD_PL_ELE_PRODUCT_PLU      = 'PLU';            // <== The new identifier
	GTD_PL_ELE_PRODUCT_CODE     = GTD_PL_ELE_PRODUCT_PLU;            // <== The new identifier
	GTD_PL_ELE_PRODUCT_NAME     = 'Name';
	GTD_PL_ELE_PRODUCT_DESC     = 'Description';
	GTD_PL_ELE_PRODUCT_KEYWORDS = 'Keywords';
	GTD_PL_ELE_PRODUCT_LIST     = 'List_Price';
	GTD_PL_ELE_PRODUCT_ACTUAL   = 'Actual_Price';     // <= and here is the new
	GTD_PL_ELE_PRODUCT_TAXR     = 'Tax_Rate';
	GTD_PL_ELE_PRODUCT_TAXT     = 'Tax_Type';
	GTD_PL_ELE_PRODUCT_TAXAMT   = 'Tax_Amount';
	GTD_PL_ELE_PRODUCT_BRAND    = 'Brand';
	GTD_PL_ELE_PRODUCT_UNIT     = 'Unit';
	GTD_PL_ELE_PRODUCT_MINORDQTY= 'MinOrderQty';
	GTD_PL_ELE_PRODUCT_TYPE     = 'Product_Type';
	GTD_PL_ELE_PRODUCT_IMAGE    = 'Thumbnail';
	GTD_PL_ELE_PRODUCT_BIGIMAGE = 'FullImage';
	GTD_PL_ELE_PRODUCT_MOREINFO = 'Further_Info_URL';
	GTD_PL_ELE_BRANDNAME        = 'Brand';
	GTD_PL_ELE_MANUFACT_NAME    = 'Manufacturer';
	GTD_PL_ELE_MANUFACT_GTL     = 'Manufacturer.GTL';
	GTP_PL_ELE_MANUFACT_PRODINFO= 'Manufacturer.Product_URL';
	GTD_PL_ELE_PRODUCT_AVAIL_FLAG = 'Availability.Flag';
	GTD_PL_ELE_PRODUCT_AVAIL_DATE = 'Availability.Date';
	GTD_PL_ELE_PRODUCT_AVAIL_STATUS = 'Availability.Status';
	  GTD_PL_AVAIL_FLAG_UNKNOWN   = '';
	  GTD_PL_AVAIL_FLAG_HIGH      = 'High';
	  GTD_PL_AVAIL_FLAG_MEDIUM    = 'Medium';
	  GTD_PL_AVAIL_FLAG_LOW       = 'Low';
	  GTD_PL_AVAIL_FLAG_AFTER     = 'After';
	  GTD_PL_AVAIL_FLAG_OUTOFSTOCK= 'OutOfStock';
	  GTD_PL_AVAIL_FLAG_NONSTOCK  = 'NonStock';
	GTD_PL_ELE_PRODUCT_AVAIL_BACKORD= 'Availability.OnBackOrder';
	GTD_PL_ELE_ONSPECIAL        = 'OnSpecial_Flag';
	GTD_PL_ELE_ONSPECIAL_TILL   = 'OnSpecial_Until';

	// -- Product variations, ie size, styles, colors
	GTD_PL_VARIATIONS_TAG       = 'Variations';

	// -- Product options added on but not essential
	GTD_PL_OPTIONS_TAG          = 'Options';

	// -- Product Information/Summary Section
	GTD_PL_PRODUCTSUMMARY_TAG   = 'Summary';
	GTD_PL_PRODUCTSUMMARY_NODE  = '/' + GTD_PL_PRODUCTSUMMARY_TAG;
    GTD_PL_ELE_ITEMCOUNT        = 'ItemCount';
	GTD_PL_ELE_MAJORGROUPS      = 'ProductGroupCount';
	GTD_PL_ELE_VALID_FROM       = 'Valid_From';
    GTD_PL_ELE_VALID_TO         = 'Valid_To';
    
    // -- Pricelist Image Elements
    // -- ** Simplistic **
    GTD_PL_ELE_PRODUCT_PICTURE  = GTD_PL_ELE_PRODUCT_IMAGE;
    // -- ** complex **
    GTD_PL_PRODUCT_IMAGE_TAG = 'Image';
    GTD_PL_PRODUCT_IMAGE_NODE = '/' + GTD_PL_PRODUCT_IMAGE_TAG;
    GTD_PL_ELE_PRODUCT_IMAGE_ID = 'Filename';
	GTD_PL_ELE_PRODUCT_IMAGE_WIDTH = 'Display_Width';
	GTD_PL_ELE_PRODUCT_IMAGE_HEIGHT = 'Display_Height';

	// -- Pricelist Display options
	GTD_PL_DISPLAYINFO_TAG      = 'Display Options';
	GTD_PL_DISPLAYINFO_NODE     = '/' + GTD_PL_DISPLAYINFO_TAG;
	GTD_PL_ELE_SHOWLIST         = 'ListPrice_Displayed';
	GTD_PL_ELE_SHOWYOUR  		= 'YourPrice_Displayed';
	GTD_PL_LEVELCOUNT           = 'Product_Group_Levels';

    // -- Pricelist Contact information
    GTD_PL_DEPARTMNTS_NODE      = '/PriceList/Contact Information/Departments';
    GTD_PL_ADEPARTMNT_NODE      = '/Department';
    GTD_PL_CONTACT_DFLT_SM      = 'Sales & Marketing';
	GTD_PL_CONTACT_DFLT_CS      = 'Customer Service';
    GTD_PL_CONTACT_DFLT_FA      = 'Finance & Administration';
	GTD_PL_ONECONTACT_NODE      = '/Contacts/Contact';
    GTD_PL_ELE_DPMNT_NAME       = 'Department_Name';
	GTD_PL_ELE_CONTACT_NAME     = 'Name';
	GTD_PL_ELE_CONTACT_POSTN    = 'Position';
	GTD_PL_ELE_CONTACT_TEL      = 'Telephone_Number';
    GTD_PL_ELE_CONTACT_MOB      = 'Mobile_Number';
    GTD_PL_ELE_CONTACT_EMAIL    = 'Email';
    GTD_PL_ELE_CONTACT_DESC     = 'Description';

	// -- These are columns within the Trader table
    GTD_DB_COL_TRADER_ID        = 'Trader_ID';
	GTD_DB_COL_COMPANY_CODE     = 'PreisShare_ID';
	GTD_DB_COL_COMPANY_NAME     = 'Name';
	GTD_DB_COL_ADDRESS_LINE_1   = 'Address_Line_1';
	GTD_DB_COL_ADDRESS_LINE_2   = 'Address_Line_2';
	GTD_DB_COL_TOWN             = 'Suburb_Town';
	GTD_DB_COL_STATE_REGION     = 'State_Region';
	GTD_DB_COL_POSTALCODE       = 'ZIP_Postcode';
	GTD_DB_COL_COUNTRYCODE      = 'Country_Code';
	GTD_DB_COL_TELEPHONE        = 'Telephone_1';
	GTD_DB_COL_TELEPHONE2       = 'Telephone_2';
  	GTD_DB_COL_CONTACT          = 'Contact_Name';

	GTD_DB_COL_EMAILADDRESS     = 'Email';
	GTD_DB_COL_RELATIONSHIP     = 'Trading_Relationship';
		// -- Values for Trader_Documents.Trading_Relationship
		GTD_TRADER_RLTNSHP_SUPPLIER = 'Supplier';
		GTD_TRADER_RLTNSHP_CUSTOMER = 'Customer';
	GTD_DB_COL_STATUS_CODE      = 'Trading_Status_Code';
		// -- Values for Trader_Documents.Trading_Status_Code
		GTD_TRADER_STATUS_ACTIVE    = 'Active';
		GTD_TRADER_STATUS_INACTIVE  = 'InActive';
		GTD_TRADER_STATUS_PROSPECT  = 'Prospective';
		GTD_TRADER_RLTNSHP_COMPETITOR = 'Competitor';
	GTD_DB_COL_LATTITUDE        = 'Lattitude';
	GTD_DB_COL_LONGITUDE        = 'Longitude';
	GTD_DB_COL_CREATED          = 'Created';
	GTD_DB_COL_AR_CODE          = 'AR_Account_Code';
	GTD_DB_COL_AP_CODE          = 'AP_Account_Code';
	GTD_DB_COL_SHORTNAME        = 'Short_Name';

	// -- These are columns within the Trader_Documents table
	GTD_DB_DOC_DOC_ID           = 'Document_ID';
	GTD_DB_DOC_MSGID            = 'Msg_ID';
	GTD_DB_DOC_OWNER            = 'Owned_By';
	GTD_DB_DOC_USER             = 'Shared_With';
	GTD_DB_DOC_DATE             = 'Document_Date';
	GTD_DB_DOC_REFERENCE        = 'Document_Reference';
	GTD_DB_DOC_TYPE             = 'Document_Name';
	GTD_DB_DOC_TOTAL            = 'Document_Total';
	GTD_DB_DOC_TOTAL_TAX        = 'Document_Tax';
	GTD_DB_DOC_SYSTEM           = 'System_Name';
	GTD_DB_DOC_REMSTAT          = 'Remote_Status_Code';
	GTD_DB_DOC_REMCMTS          = 'Remote_Status_Comments';
	GTD_DB_DOC_LOCSTAT          = 'Local_Status_Code';
	GTD_DB_DOC_LOCCMTS          = 'Local_Status_Comments';
	GTD_DB_DOC_UPDATEFLAG       = 'Update_Flag';
	GTD_LW_DOC_FILENAME         = 'Filename';               // Used in the ClientConnector to store filename

	// -- Values for Trader_Documents.Update_Flag
	GTD_DB_UPDDOCFLAG_NEW       = '+';
	GTD_DB_UPDDOCFLAG_SYNC      = '=';
	GTD_DB_UPDDOCFLAG_DIRTYSTAT = '^';
	GTD_DB_UPDDOCFLAG_DIRTYHDR  = '%';
	GTD_DB_UPDDOCFLAG_DIRTYBODY = '~';
	GTD_DB_UPDDOCFLAG_DIRTYALL  = '\';

	// -- These are the columns within the Trader_AuditTrail table
    GTD_DB_AUDIT_TRADER_ID      = 'Trader_ID';
	GTD_DB_AUDIT_DOC_ID         = 'Document_ID';
	GTD_DB_AUDIT_LOCAL_TIMESTAMP= 'Local_TimeStamp';
    GTD_DB_AUDIT_REMOT_TIMESTAMP= 'Remote_TimeStamp';
	GTD_DB_AUDIT_CODE           = 'Audit_Code';
    GTD_DB_AUDIT_DESC           = 'Audit_Description';
	GTD_DB_AUDIT_LOG            = 'Audit_Log';
	GTD_DB_AUDIT_CREATOR        = 'Audit_Creator';
	GTD_DB_AUDIT_UPDATEFLAG     = 'Update_Flag';
    GTD_DB_AUDIT_MSGID          = 'Msg_ID';

    //    Values for the Trader_AuditTrail.Audit_Code field
    GTD_DB_AUDIT_CDE_PRCLST_SNT = 'PriceList Sent';
    GTD_DB_AUDIT_CDE_PRCLST_RCV = 'PriceList Received';
    GTD_AUDITCD_CRT             = 'Create';
    GTD_AUDITDS_CRT             = 'Document Created';
	GTD_AUDITCD_UPD             = 'Updated';
    GTD_AUDITDS_UPD             = 'Document Updated';
    GTD_AUDITCD_RCV             = 'Received';
    GTD_AUDITDS_RCV             = 'Document Received';
	GTD_AUDITCD_SND             = 'Sent';
	GTD_AUDITDS_SND             = 'Document Sent';
    GTD_AUDITCD_STAT            = 'Status';
	GTD_AUDITDS_STAT            = 'Status Changed';
	GTD_AUDITCD_CMTS            = 'Comments';
    GTD_AUDITDS_CMTS            = 'Comments Changed';
    GTD_AUDITCD_STCM            = 'Status/Comments';
    GTD_AUDITDS_STCM            = 'Comments/Status Changed';
    GTD_AUDITCD_SYNC            = 'Synch';
    GTD_AUDITDS_SYNC            = 'Trading Partner Updated';

    // -- Document registry specifications
	Base_Dir                    = '\Program Files\BestComputerPrices'; // ** Use GetSoftwareInstallDir
	DocumentRegName             = 'Doclist.dat';
    GTD_DR_RECVD_DOCS_SUBDIR    = '\Documents\Received';
	GTD_DR_ACTIVE_DOCS_SUBDIR   = '\Documents\Active';
    GTD_DR_COMPLETE_DOCS_SUBDIR = '\Documents\Complete';
    GTD_DR_OUR_IMAGES_SUBDIR    = 'Our Images';
    GTD_DR_DOWNLOAD_IMAGES_SUBDIR = 'Downloaded Images';
	GTD_DR_MYCDCATALOG          = '\My CD Business Card';

	GTD_PRICELIST_TYPE          = 'PreisFile';
	GTD_PRICELIST_EXT           = '.PreisFile';
	GTD_CURRENT_PRICELIST       = 'Current Pricelist' + GTD_PRICELIST_EXT;
	GTD_PRICELIST_PATCH_EXT     = '.PreisFile_Patch';
	GTD_TRADALOG_OPEN_FILTER    = 'PreisShare Files|*.PreisFile|All Files|*.*';
	GTD_SERVER_CERTFILE         = 'Server_Registration.txt';

	// -- Used in patching pricelist
	GTD_PL_ELE_UPDATE_TYPE      = 'Update_Type';
	GTD_PL_UPDATE_REPLACE       = 'Replace';
	GTD_PL_UPDATE_PATCH         = 'Pricelist Update';

	// -- Definitions for file transfers
	GTD_FT_TYPE                 = 'File Transfer';
	GTD_FW_OUTPUT_DIR           = 'Output Directory';

	GTD_QUOTE_TYPE              = 'Quotation';
	GTD_ORDER_TYPE              = 'Purchase Order';
	GTD_INVOICE_TYPE            = 'Invoice';
	GTD_PRICELIST_PATCH_TYPE    = 'Pricelist_Patch';

    // ---------------------------------------------------------------------
    //
    // <Standard Document Fields>
    //
	// ---------------------------------------------------------------------

    // -- Issuer Details
	STDDOC_BUYER               = 'BuyerParty';
    STDDOC_BUYER_NODE          = '/' + STDDOC_BUYER;
	// -- Recipient Details
    STDDOC_SELLER              = 'SellerParty';
    STDDOC_SELLER_NODE         = '/' + STDDOC_SELLER;

    STDDOC_ELE_COMPANY_CODE    = GTD_PL_ELE_COMPANY_CODE;
    STDDOC_ELE_COMPANY_NAME    = GTD_PL_ELE_COMPANY_NAME;
    STDDOC_ELE_ADDRESS_LINE_1  = GTD_PL_ELE_ADDRESS_LINE_1;
    STDDOC_ELE_ADDRESS_LINE_2  = GTD_PL_ELE_ADDRESS_LINE_2;
    STDDOC_ELE_TOWN            = GTD_PL_ELE_TOWN;
	STDDOC_ELE_STATE_REGION    = GTD_PL_ELE_STATE_REGION;
    STDDOC_ELE_POSTALCODE      = GTD_PL_ELE_POSTALCODE;
    STDDOC_ELE_COUNTRYCODE     = GTD_PL_ELE_COUNTRYCODE;
	STDDOC_ELE_TELEPHONE       = GTD_PL_ELE_TELEPHONE;
    STDDOC_ELE_TELEPHONE2      = GTD_PL_ELE_TELEPHONE2;
    STDDOC_ELE_EMAIL_ADDRESS   = GTD_PL_ELE_EMAIL_ADDRESS;
	STDDOC_ELE_OTHER_INFO      = GTD_PL_ELE_OTHER_INFO;

    STDDOC_HDR                 = 'Header Information';
    STDDOC_HDR_NODE            = '/' + STDDOC_HDR;
    STDDOC_HDR_ELE_TITLE       = 'Document_Title';
    STDDOC_HDR_ELE_REF_NUM     = 'Document_Number';
    STDDOC_HDR_ELE_DATE        = 'Document_Date';
	STDDOC_HDR_ELE_TOTAL_AMOUNT= 'Document_Total';       // -- 10%, 12%
	STDDOC_HDR_ELE_TAX_AMOUNT  = 'Document_Tax';            // -- 10%, 12%
	STDDOC_HDR_ELE_SALES_PERSON= 'Sales_Person';
	STDDOC_HDR_ELE_CONTACT     = 'Contact';
	STDDOC_HDR_ELE_DELIV_MODE  = 'Delivery_Mode';
    STDDOC_HDR_ELE_DELIV_DATE  = 'Delivery_Date';
    STDDOC_HDR_ELE_DELIV_ADDR  = 'Delivery_Address';
    STDDOC_HDR_ELE_DELIV_FROM  = 'Delivery_From';
    STDDOC_HDR_ELE_DELIV_VIA   = 'Delivery_Via';
    STDDOC_HDR_ELE_DELIV_CHG   = 'Delivery_Charge';
    STDDOC_HDR_ELE_APPRVD_BY   = 'Approved_By';

    STDDOC_HDR_ELE_SPECL_INSTR = 'Special_Instructions';
    STDDOC_HDR_ELE_PMT_TERMS   = 'Payment_Terms';
    STDDOC_HDR_ELE_GEN_TERMS   = 'General_Terms';      // -- Genereal terms
	STDDOC_HDR_ELE_TAX_MODE    = 'Tax_Mode';           // -- Inclusive, Exclusive
      STDDOC_CONST_TAX_MODE_INC   = 'Inclusive';
      STDDOC_CONST_TAX_MODE_EXC   = 'Exclusive';
    STDDOC_HDR_ELE_TAX_NAME    = 'Tax_Name';           // -- GST, VAT etc
    STDDOC_HDR_ELE_TAX_RATE    = 'Tax_Rate';           // -- 10%, 12%
    STDDOC_HDR_ELE_TAX_TOTAL   = 'Tax_Total';          // -- Total for the document
    STDDOC_HDR_CURRENCY_CODE   = 'Currency_Code';      // -- USD, AUD etc
	STDDOC_HDR_ORIGIN_CODE     = 'Country_Code';       // -- US, AU, FR etc
    STDDOC_HDR_DISPLAY_FORMAT  = 'Display_Format';     // -- Predefined image format
    STDDOC_HDR_LOGO_IMAGE      = 'LogoImage';          // -- Name of logo image
    STDDOC_HDR_PAPER_SIZE      = 'PaperSize';          // -- Default Paper size A4 etc
    STDDOC_HDR_PRINT_ORIENT    = 'PrintOrientation';   // -- Printer Orientation ie Portrait/Landscape
    STDDOC_HDR_HEADER_COLS     = 'HeaderColumns';      // -- Column names printed on header
	STDDOC_HDR_ITEM_COLS       = 'ItemColumns';        // -- Line item Column names
    STDDOC_HDR_QUOTE_EXPIRES   = 'Valid_Until';
	STDDOC_HDR_NAME_ALIGN      = 'Name_Position';
    STDDOC_HDR_ADDRESS_ALIGN   = 'Address_Position';
	  STDDOC_CONST_HDR_ALIGN_LEFT  = 'Show Left Top';
      STDDOC_CONST_HDR_ALIGN_RIGHT = 'Show Right Top';
      STDDOC_CONST_HDR_ALIGN_HIDE  = 'Hide';

    STDDOC_LINE_ITEMS          = 'Line Item List';
    STDDOC_LINE_ITEMS_NODE     = '/' + STDDOC_LINE_ITEMS;
    STDDOC_LINE_ITEM           = 'Line Item';
    STDDOC_LINE_ITEM_NODE      = '/' + STDDOC_LINE_ITEM;

    STDDOC_ELE_ITEM_CODE        = 'Code';
	STDDOC_ELE_ITEM_NAME        = 'Name';
	STDDOC_ELE_ITEM_DESC        = 'Description';
	STDDOC_ELE_ITEM_QTY         = 'Quantity';
	STDDOC_ELE_ITEM_UNIT        = 'Unit';
	STDDOC_ELE_ITEM_RATE        = 'Rate';
	STDDOC_ELE_ITEM_TAX         = 'Tax';
	STDDOC_ELE_ITEM_AMOUNT      = 'Amount';
	STDDOC_ELE_ITEM_IMAGE       = 'Image';

	STDDOC_ELE_ITEM_QTY_RCVD    = 'Quantity_Rcvd';

	// ---------------------------------------------------------------------
    //
	// </Standard Document Fields>
    //
    // ---------------------------------------------------------------------

    // -- Purchase order definitions
	GTD_PO_EXT                  = '.Purchase Order';
	GTD_PO_TYPE                 = 'Purchase Order';

    GTD_PO_ELE_ITEM_CODE        = 'Code';
    GTD_PO_ELE_ITEM_NAME        = 'Name';
	GTD_PO_ELE_ITEM_DESC        = 'Description';
    GTD_PO_ELE_ITEM_QTY         = 'Quantity';
    GTD_PO_ELE_ITEM_UNIT        = 'Unit';
    GTD_PO_ELE_ITEM_RATE        = 'Rate';
    GTD_PO_ELE_ITEM_TAX         = 'Tax';
    GTD_PO_ELE_ITEM_AMOUNT      = 'Amount';

    GTD_PO_DEL_TAG              = 'Delivery Details';
    GTD_PO_DEL_NODE             = '/' + GTD_PO_DEL_TAG;
    GTD_PO_DEL_ELE_MODE         = 'Delivery_Mode';
    GTD_PO_DEL_ELE_DATE         = 'Delivery_Date';
    GTD_PO_DEL_ELE_INSTR        = 'Delivery_Instructions';
    GTD_PO_DEL_ELE_ADDR         = 'Delivery_Address';
	GTD_PO_DEL_ELE_CHARGE       = 'Delivery_Charge';

    // -- Credit card payment fields
    GTD_PO_PAYMENT_NODE         = '/Payment Details';
	GTD_PO_PMT_NODE             = 'Payment Details';
    GTD_PO_ELE_PMT_TYPE         = 'Payment_Method';
    GTD_PO_PMT_CARDNUM          = 'CD';
    GTD_PO_PMT_CARDTYPE         = 'TP';
	GTD_PO_PMT_CARDEXPIRE       = 'XP';

	GTD_PO_COMPANY_ADDRESS      = 'Company_Address';

	GTD_RES_EXT                 = '.Reservation';
	GTD_RES_TYPE                = 'Reservation';

	GTD_RECEIPT_TYPE            = 'Receipt';

    // -- Invoices
    GTD_INV_EXT                 = '.Invoice';
	GTD_INV_TYPE                = 'Invoice';
	GTD_INV_LINE_ITEMS_NODE     = '/Line Item List';
	// -- Invoice Header Elements
    GTD_INV_HDR_NODE            = '/Header Information';
    GTD_INV_HDR_ELE_TITLE       = 'Document_Title';
    GTD_INV_HDR_ELE_ORDER_NUM   = 'Order_Number';
	GTD_INV_HDR_ELE_ORDER_DATE  = 'Order_Date';
    GTD_INV_HDR_ELE_SALES_PERSON= 'Sales_Person';
    GTD_INV_HDR_ELE_CONTACT     = 'Contact';
	GTD_INV_HDR_ELE_DELIV_MODE  = 'Delivery_Mode';
    GTD_INV_HDR_ELE_DELIV_DATE  = 'Delivery_Date';
    GTD_INV_HDR_ELE_DELIV_ADDR  = 'Delivery_Address';
	GTD_INV_HDR_ELE_DELIV_FROM  = 'Delivery_From';
    GTD_INV_HDR_ELE_DELIV_VIA   = 'Delivery_Via';
    GTD_INV_HDR_ELE_PMT_TERMS   = 'Payment_Terms';

    // -- Issuer Details
	GTD_INV_ISSUER_NODE         = '/Issuer Details';
	// -- Recipient Details
	GTD_INV_RECIPIENT_NODE      = '/Recipient Details';

    // -- These elements are the same for Issuer and Recipient
    GTD_INV_ELE_COMPANY_CODE     = GTD_PL_ELE_COMPANY_CODE;
    GTD_INV_ELE_COMPANY_NAME     = GTD_PL_ELE_COMPANY_NAME;
    GTD_INV_ELE_ADDRESS_LINE_1   = GTD_PL_ELE_ADDRESS_LINE_1;
    GTD_INV_ELE_ADDRESS_LINE_2   = GTD_PL_ELE_ADDRESS_LINE_2;
    GTD_INV_ELE_ADDRESS_LINE_3   = 'Address_Line_3';
    GTD_INV_ELE_ADDRESS_LINE_4   = 'Address_Line_4';
	GTD_INV_ELE_OTHER_INFO       = GTD_PL_ELE_OTHER_INFO;
    GTD_INV_ELE_ACCOUNT_CODE     = 'Account_Code';

	// -- Invoice Line Elements
    GTD_INV_ELE_ITEM_NODE       = '/Invoice Items';
    GTD_INV_ELE_ITEM_CODE       = 'Code';
    GTD_INV_ELE_ITEM_NAME       = 'Name';
    GTD_INV_ELE_ITEM_DESC       = 'Description';
    GTD_INV_ELE_ITEM_QTY        = 'Quantity';
	GTD_INV_ELE_ITEM_UNIT       = 'Unit';
    GTD_INV_ELE_ITEM_RATE       = 'Rate';
	GTD_INV_ELE_ITEM_TAX        = 'Tax';
    GTD_INV_ELE_ITEM_DISC_PC    = 'Disc_Percentage';
    GTD_INV_ELE_ITEM_DISC_AMOUNT= 'Disc_Amount';
    GTD_INV_ELE_ITEM_AMOUNT     = 'Amount';

    // -- Invoice Trailer
	GTD_INV_TRL_NODE            = '/Summary';
    GTD_INV_TRL_TAX_TOTAL_TITLE = 'Total_Tax_Title';
	GTL_INV_TRL_TAX_TOTAL       = 'Total_Tax';
    GTL_INV_TRL_DISC_TOTAL      = 'Total_Discount';
    GTL_INV_TRL_FREIGHT_TOTAL   = 'Total_Freight';

    // -- Statement Definitions
    GTD_STM_EXT                 = '.Statement';
	GTD_STM_TYPE                = 'Statement';

    // -- Payment Definitions
	GTD_PMT_TYPE                = 'Payment';
    GTD_PMT_EXT                 = '.Payment';

    GTD_BodyFieldname           = 'MIME_TEXT';
    GTD_SYSTEM					= 'STANDARD';

    GTD_DOC_LIST_SEPERATOR      = ';';

    GTD_LANGUAGE                = '<?EuroMarkup(tm) Version#=1.0 encoding&="UTF-8" LangID&="EN">';

	PRODUCT_UPDATE_ADDITION     = 'Addition';
    PRODUCT_UPDATE_REMOVAL      = 'Removal';
	PRODUCT_UPDATE_UPDATE       = 'Update';

    sqlSetOpenBracket           = '(';
    sqlSetCloseBracket          = ')';

	BASE64_OK       = 0; // no errors, conversion successful
    BASE64_ERROR    = 1; // unknown error (e.g. can't encode octet in input stream) -> error in implementation
	BASE64_INVALID  = 2; // invalid characters in input string (may occur only when filterdecodeinput=false)
    BASE64_LENGTH   = 3; // input data length is not a Base64 length (mod 4)
    BASE64_DATALEFT = 4; // too much input data left (receveived 'end of encoded data' but not end of input string)
    BASE64_PADDING  = 5; // wrong padding (input data isn't closed with correct padding characters)

    AlphabetLength = 64;
	Alphabet:string[AlphabetLength]='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
    MimePadChar = '=';

    // -- This key is used to designate what type of database
	SYSVAL_DBTYPE_SECTION 		 = 'Database';
	SYSVAL_DBTYPE_KEYNAME 		 = 'ProductName';
	SYSVAL_DBVER_KEYNAME  		 = 'Version';

	// -- These things are for the system registry
	SYSVAL_LICENSE_SECTION 		 = 'License Keys';
	SYSVAL_JOB_LICENCE_KEYNAME 	 = 'JobSupport';
	SYSVAL_LICENSE_KEYNAME 		 = 'Product Registration';

	// - These constants are in the encryption file
    KEYTEXT_ELEM_GTL     = GTD_PL_ELE_COMPANY_CODE;
	KEYTEXT_ELEM_ORGNAME = GTD_PL_ELE_COMPANY_NAME;
	KEYTEXT_ELEM_REGION  = GTD_PL_ELE_STATE_REGION;
	KEYTEXT_ELEM_COUNTRY = GTD_PL_ELE_COUNTRYCODE;
    KEYTEXT_ELEM_IPADDR  = GTD_PL_ELE_IPADDRESS;
	KEYTEXT_ELEM_MACHINE = 'Machine_Name';
	KEYTEXT_ELEM_OS_NAME = 'Operating_System';
	KEYTEXT_ELEM_EXP_DATE= 'Expiry_Date';

	// -- Known Document status
	GTD_DOCSTAT_SENT             = 'Sent';
	GTD_DOCSTAT_NOT_SENT         = 'Not Sent';
	GTD_DOCSTAT_QOUTE_AWAIT_RESP = 'Awaiting Response';
	GTD_DOCSTAT_PO_AWAIT_DELIV   = 'Awaiting Delivery';
	GTD_DOCSTAT_PO_PARTIAL_DELIV = 'Partially Delivered';
	GTD_DOCSTAT_INV_AWAIT_PMT    = 'Awaiting Payment';
	GTD_DOCSTAT_COMPLETE		 = 'Complete';

var
		GTD_ALIAS : String;

implementation

{$IFNDEF LINUX}
uses DelphiUtils,DECUtil,IdHashCRC,JpegUtilities;
{$ELSE}
uses DelphiUtils,IdHashCRC;
{$ENDIF}
// ----------------------------------------------------------------------------
constructor GTDBizDoc.Create(AOwner: TComponent);
begin
	inherited Create(AOwner);

    // -- Initialise some member properties
	fDef        := TStringList.Create;
	fBody       := TStringList.Create;
	fParams     := TStringList.Create;
    fDocNumber  := -1;
	fDirty      := False;

    fSystem_Name:= 'STANDARD';

	Color := $004080FF

end;

// ----------------------------------------------------------------------------
destructor GTDBizDoc.Destroy;
begin
	fDef.Free;
	fBody.Free;
	fParams.Free;

	inherited Destroy;
end;
// ----------------------------------------------------------------------------
procedure GTDBizDoc.Clear;
begin
	fDef.Clear;
	fParams.Clear;
	fBody.Clear;
	fBody.Add(GTD_LANGUAGE);

    // -- Reset all the properties
    fDocNumber              := -1;
    fDirty                  := False;
	fDef.Clear;
	fParams.Clear;
    fBody_Chg               := False;
    fFileName               := '';

    fRemote_Doc_ID          := -1;
    fRemote_Doc_ID_Chg      := False;
    fMsg_ID                 := '';
    fMsg_ID_Chg             := False;
    fOwned_By               := -1;
    fOwned_By_Chg           := False;
    fShared_With            := -1;
    fShared_With_Chg        := False;
    fSystem_Name            := GTD_SYSTEM;
    fSystem_Name_Chg        := False;
    fDocument_Type          := '';
    fDocument_Type_Chg      := False;
    fDocument_Ref           := '';
    fDocument_Ref_Chg       := False;
    fDocument_Date          := Date;
	fDocument_Date_Chg      := False;
	fDocument_Total         := 0;
    fDocument_Total_Chg     := False;
	fTax_Total              := 0;
	fTax_Total_Chg          := False;
	fLocal_Status_Code      := 'Not Sent';
    fLocal_Status_Code_Chg  := False;
    fLocal_Status_Cmts      := '';
	fLocal_Status_Cmts_Chg  := False;
    fRemote_Status_Code     := 'Not Received';
    fRemote_Status_Code_Chg := False;
	fRemote_Status_Cmts     := '';
    fRemote_Status_Cmts_Chg := False;
    fDeliv_Status_Code      := '';
    fDeliv_Status_Code_Chg  := False;
    fDeliv_Status_Cmts      := '';
    fDeliv_Status_Cmts_Chg  := False;
    fMime_Type              := '';
    fMime_Type_Chg          := False;
    fDocument_Options       := '';
    fDocument_Options_chg   := False;
    fUpdate_Flag            := '';
    fUpdate_Flag_Chg        := False;

end;
// ----------------------------------------------------------------------------
procedure GTDBizDoc.SetDef(Value: TStrings);
begin
  if fDef.Text <> Value.Text then
  begin
	fDef.BeginUpdate;
	try
	  fDef.Assign(Value);
	finally
	  fDef.EndUpdate;
	end;
  end;
end;

// ----------------------------------------------------------------------------
procedure GTDBizDoc.SetXml(Value: TStrings);
begin
  if fBody.Text <> Value.Text then
  begin
	fBody.BeginUpdate;
	try
	  fBody.Assign(Value);
	finally
	  fBody.EndUpdate;
	end;
  end;
end;

// ----------------------------------------------------------------------------
procedure GTDBizDoc.SetParams(Value: TStrings);
begin
  if fParams.Text <> Value.Text then
  begin
	fParams.BeginUpdate;
	try
	  fParams.Assign(Value);
	finally
	  fParams.EndUpdate;
	end;
  end;
end;
// ----------------------------------------------------------------------------
procedure GTDBizDoc.ChangeField(FieldTypeH_HeaderS_Status_B_Body : Char);
begin
    // -- First thing to do is consolidate the Update flag
    if (FieldTypeH_HeaderS_Status_B_Body = 'H') then
    begin
        // -- Toggle the update flag
        if (Update_Flag = GTD_DB_UPDDOCFLAG_SYNC) then
            Update_Flag := GTD_DB_UPDDOCFLAG_DIRTYHDR
		else if (Update_Flag = GTD_DB_UPDDOCFLAG_DIRTYSTAT) then
            Update_Flag := GTD_DB_UPDDOCFLAG_DIRTYHDR
        else if (Update_Flag = GTD_DB_UPDDOCFLAG_DIRTYBODY) then
            Update_Flag := GTD_DB_UPDDOCFLAG_DIRTYALL;
    end
    else if (FieldTypeH_HeaderS_Status_B_Body = 'S') then
    begin
        // -- Toggle the update flag
        if (Update_Flag = GTD_DB_UPDDOCFLAG_SYNC) then
            Update_Flag := GTD_DB_UPDDOCFLAG_DIRTYSTAT
        else if (Update_Flag = GTD_DB_UPDDOCFLAG_DIRTYBODY) then
            Update_Flag := GTD_DB_UPDDOCFLAG_DIRTYALL;

    end
    else if (FieldTypeH_HeaderS_Status_B_Body = 'B') then
    begin
        // -- Toggle the update flag
		if (Update_Flag = GTD_DB_UPDDOCFLAG_SYNC) then
            Update_Flag := GTD_DB_UPDDOCFLAG_DIRTYBODY
        else if (Update_Flag = GTD_DB_UPDDOCFLAG_DIRTYSTAT) then
			Update_Flag := GTD_DB_UPDDOCFLAG_DIRTYALL
        else if (Update_Flag = GTD_DB_UPDDOCFLAG_DIRTYHDR) then
            Update_Flag := GTD_DB_UPDDOCFLAG_DIRTYALL;
    end
    else begin
		// -- Unknown - force retransmit
//    	GTD_DB_UPDDOCFLAG_DIRTYALL  = '\';
    end;

end;
// ----------------------------------------------------------------------------
procedure GTDBizDoc.SetLocal_Doc_ID(NewValue : Integer);
begin
    fDocNumber              := NewValue;
    ChangeField('H');
end;
// ----------------------------------------------------------------------------
procedure GTDBizDoc.SetMsg_ID(NewValue : String);
begin
    fMsg_ID                 := NewValue;
	fMsg_ID_Chg             := True;
    ChangeField('H');
end;
// ----------------------------------------------------------------------------
procedure GTDBizDoc.SetRemote_Doc_ID(NewValue : Integer);
begin
    fRemote_Doc_ID          := NewValue;
    fRemote_Doc_ID_Chg      := True;
	ChangeField('H');
end;
// ----------------------------------------------------------------------------
procedure GTDBizDoc.SetOwned_By(NewValue : Integer);
begin
    fOwned_By               := NewValue;
    fOwned_By_Chg           := True;
    ChangeField('H');
end;
// ----------------------------------------------------------------------------
procedure GTDBizDoc.SetShared_With(NewValue : Integer);
begin
    fShared_With            := NewValue;
    fShared_With_Chg        := True;
    ChangeField('H');
end;
// ----------------------------------------------------------------------------
procedure GTDBizDoc.SetSystem_Name(NewValue : String);
begin
    fSystem_Name            := NewValue;
	fSystem_Name_Chg        := True;
    ChangeField('H');
end;
// ----------------------------------------------------------------------------
procedure GTDBizDoc.SetDocument_Type(NewValue : String);
begin
    fDocument_Type          := NewValue;
	fDocument_Type_Chg      := True;
	ChangeField('H');
end;
// ----------------------------------------------------------------------------
procedure GTDBizDoc.SetDocument_Ref(NewValue : String);
begin
    fDocument_Ref           := NewValue;
    fDocument_Ref_Chg       := True;
    ChangeField('H');
end;
// ----------------------------------------------------------------------------
procedure GTDBizDoc.SetDocument_Date(NewValue : TDateTime);
begin
    fDocument_Date          := NewValue;
    fDocument_Date_Chg      := True;
    ChangeField('H');
end;
// ----------------------------------------------------------------------------
procedure GTDBizDoc.SetDocument_Total(NewValue : Double);
begin
	fDocument_Total         := NewValue;
	fDocument_Total_Chg     := True;
	ChangeField('H');
end;
// ----------------------------------------------------------------------------
procedure GTDBizDoc.SetTax_Total(NewValue : Double);
begin
	fTax_Total         		:= NewValue;
	fTax_Total_Chg          := True;
	ChangeField('H');
end;
// ----------------------------------------------------------------------------
procedure GTDBizDoc.SetLocal_Status_Code(NewValue : String);
begin
    fLocal_Status_Code      := NewValue;
    fLocal_Status_Code_Chg  := True;
	ChangeField('S');
end;
// ----------------------------------------------------------------------------
procedure GTDBizDoc.SetLocal_Status_Cmts(NewValue : String);
begin
    fLocal_Status_Cmts      := NewValue;
    fLocal_Status_Cmts_Chg  := True;
    ChangeField('S');
end;
// ----------------------------------------------------------------------------
procedure GTDBizDoc.SetRemote_Status_Code(NewValue : String);
begin
    fRemote_Status_Code     := NewValue;
    fRemote_Status_Code_Chg := True;
end;
// ----------------------------------------------------------------------------
procedure GTDBizDoc.SetRemote_Status_Cmts(NewValue : String);
begin
	fRemote_Status_Cmts     := NewValue;
    fRemote_Status_Cmts_Chg := True;
end;
// ----------------------------------------------------------------------------
procedure GTDBizDoc.SetDeliv_Status_Code(NewValue : String);
begin
    fDeliv_Status_Code      := NewValue;
    fDeliv_Status_Code_Chg  := True;
end;
// ----------------------------------------------------------------------------
procedure GTDBizDoc.SetDeliv_Status_Cmts(NewValue : String);
begin
    fDeliv_Status_Cmts      := NewValue;
    fDeliv_Status_Cmts_Chg  := True;
end;
// ----------------------------------------------------------------------------
procedure GTDBizDoc.SetMime_Type(NewValue : String);
begin
    fMime_Type              := NewValue;
    fMime_Type_Chg          := True;
    ChangeField('B');
end;
// ----------------------------------------------------------------------------
procedure GTDBizDoc.SetDocument_Options(NewValue : String);
begin
    fDocument_Options       := NewValue;
    fDocument_Options_chg   := True;
end;
// ----------------------------------------------------------------------------
procedure GTDBizDoc.SetUpdate_Flag(NewValue : String);
begin
    fUpdate_Flag        := NewValue;
    fUpdate_Flag_Chg    := True;
end;
// ----------------------------------------------------------------------------
function GTDBizDoc.BodyChanged:Boolean;
begin
    Result := fBody_Chg;
end;
// ----------------------------------------------------------------------------
function GTDBizDoc.Msg_ID_Changed:Boolean;
begin
    Result := fMsg_ID_Chg;
end;
// ----------------------------------------------------------------------------
function GTDBizDoc.Remote_Doc_ID_Changed:Boolean;
begin
    Result := fRemote_Doc_ID_Chg;
end;
// ----------------------------------------------------------------------------
function GTDBizDoc.Owned_By_Changed:Boolean;
begin
    Result := fOwned_By_Chg;
end;
// ----------------------------------------------------------------------------
function GTDBizDoc.Shared_With_Changed:Boolean;
begin
    Result := fShared_With_Chg;
end;
// ----------------------------------------------------------------------------
function GTDBizDoc.System_Name_Changed:Boolean;
begin
    Result := fSystem_Name_Chg;
end;
// ----------------------------------------------------------------------------
function GTDBizDoc.Document_Type_Changed:Boolean;
begin
    Result := fDocument_Type_Chg;
end;
// ----------------------------------------------------------------------------
function GTDBizDoc.Document_Ref_Changed:Boolean;
begin
    Result := fDocument_Ref_Chg;
end;
// ----------------------------------------------------------------------------
function GTDBizDoc.Document_Date_Changed:Boolean;
begin
    Result := fDocument_Date_Chg;
end;
// ----------------------------------------------------------------------------
function GTDBizDoc.Document_Total_Changed:Boolean;
begin
	Result := fDocument_Total_Chg;
end;
// ----------------------------------------------------------------------------
function GTDBizDoc.Tax_Total_Changed:Boolean;
begin
	Result := fTax_Total_Chg;
end;
// ----------------------------------------------------------------------------
function GTDBizDoc.Local_Status_Code_Changed:Boolean;
begin
    Result := fLocal_Status_Code_Chg;
end;
// ----------------------------------------------------------------------------
function GTDBizDoc.Local_Status_Cmts_Changed:Boolean;
begin
    Result := fLocal_Status_Cmts_Chg;
end;
// ----------------------------------------------------------------------------
function GTDBizDoc.Remote_Status_Code_Changed:Boolean;
begin
    Result := fRemote_Status_Code_Chg;
end;
// ----------------------------------------------------------------------------
function GTDBizDoc.Remote_Status_Cmts_Changed:Boolean;
begin
    Result := fRemote_Status_Cmts_Chg;
end;
// ----------------------------------------------------------------------------
function GTDBizDoc.Deliv_Status_Code_Changed:Boolean;
begin
	Result := fDeliv_Status_Code_Chg;
end;
// ----------------------------------------------------------------------------
function GTDBizDoc.Deliv_Status_Cmts_Changed:Boolean;
begin
    Result := fDeliv_Status_Cmts_Chg;
end;
// ----------------------------------------------------------------------------
function GTDBizDoc.Mime_Type_Changed:Boolean;
begin
    Result := fMime_Type_Chg;
end;
// ----------------------------------------------------------------------------
function GTDBizDoc.Document_Options_Changed:Boolean;
begin
	Result := fDocument_Options_Chg;
end;
// ----------------------------------------------------------------------------
function GTDBizDoc.Update_Flag_Changed:Boolean;
begin
    Result := fUpdate_Flag_Chg;
end;
// ----------------------------------------------------------------------------

// -- Counts the number of levels
function GTDBizDoc.GetNestCount(NodePath : String):Integer;
var
	lc,xc,xd : Integer;
begin
    if (NodePath = '/') then
        // -- The nobrainer test
        Result := 0
    else begin
        // -- We have to count here
		lc := 0;
		xd := Length(NodePath);
        for xc := 1 to xd do
            if NodePath[xc]='/' then
                Inc(lc);

        Result := lc;
    end;
end;

// ----------------------------------------------------------------------------
// -- Here we chop everything below a certain level
function GTDBizDoc.ChopAtLevel(NodePath : String; NestLevel : Integer):String;
var
	lc,xc,xd : Integer;
begin
	Result := NodePath;
	lc := 0;
	xd := Length(NodePath);

    // -- Remove everything
	for xc := 1 to xd do
		if (NodePath[xc]='/') then
		begin
			if (lc = NestLevel) then
			begin
				Result := Copy(NodePath,1,xc-1);
                if Result = '' then
                    Result := '/';
				break;
			end;
			Inc(lc);
		end;

end;

// ----------------------------------------------------------------------------
function GTDBizDoc.NodeOfLevel(NodePath : String; NestLevel : Integer):String;
var
    n : String;
begin
    Result := '';

    // -- Validate that we aren't reading in too deep
    if (NestLevel > GetNestCount(NodePath)) or (NestLevel <= 0) then
        Exit;

    n := ChopAtLevel(NodePath,NestLevel);

    Result := LastNodeName(n);

end;

// ----------------------------------------------------------------------------
// -- Reads the Index count within a string at a specified level
//    If there is no specific index then the return value is 1
//    and if the node does not exist then the return value is -1
function GTDBizDoc.GetNodeIndex(NodeToCheck : String):Integer;
var
	s : String;
	xc,ls : Integer;
begin
	Result := -1;
	ls := Length(NodeToCheck);
	if ls = 0 then
		Exit;

	// -- If the item doesn't end with an index then just return 1
	if NodeToCheck[ls] <> ']' then
	begin
		Result := 1;
		Exit;
	end;

	// --
	for xc := ls downto 1 do
		if NodeToCheck[xc] = '[' then
		begin
			// -- We should have our result now
			s := Copy(NodeToCheck,xc+1,ls-xc-1);
			if (s<>'') then
				Result := StrToInt(s);
			break;
		end;

end;

// ----------------------------------------------------------------------------
// -- Checks if a Node exists
function GTDBizDoc.NodeExists(NodePathToCheck: String):Boolean;
var
	xc : Integer;
	l,s : String;
	usingIndexing : Boolean;

begin
	// -- ignore some bad redundant ugly code
   	Result := NodeCount(NodePathToCheck) <> 0;
end;

// ----------------------------------------------------------------------------
// -- Counts the number of nodes
function GTDBizDoc.NodeCount(NodePathToCount: String):Integer;
var
	xc, xd, c,tc : Integer;
	s,l,r,np,nnp : String;
	usingIndexing,tagFound : Boolean;
	MarkA : HECMLMarker;

begin
    np := NormalisedNodeName(NodePathToCount);

    MarkA := HECMLMarker.Create;
    MarkA.UseBodyText(XML);
    tagFound := True;

    tc := 0;

    // -- This is an experimental technique
    for xc := 1 to GetNestCount(NodePathToCount) do
    begin
        // --
        nnp := NodeOfLevel(np,xc);

        if GetNodeIndex(nnp) = 1 then
        begin
            if xc = GetNestCount(NodePathToCount) then
            begin
                // --
                if MarkA.FindTag(nnp) then
                begin
                    tagFound := True;
                    continue;
                end
                else begin
                    tagFound := False;
                    break;
                end;
            end
            else begin
                if MarkA.FindTagRegion(nnp) then
                begin
                    tagFound := True;
                    continue;
                end
                else begin
                    tagFound := False;
                    break;
                end;
            end;
        end
        else begin
            s := NodeNameWithoutLastIndex(nnp);

            for xd := 1 to GetNodeIndex(nnp) do
            begin
                if xd < GetNodeIndex(nnp) then
                begin
                    if MarkA.FindTag(s) then
                    begin
                        tagFound := True;
                        continue;
                    end
                    else
                    begin
                        tagFound := false;
                        break;
                    end
                end
                else begin
                    if MarkA.FindTagRegion(s) then
                    begin
                        tagFound := True;
                        continue;
                    end
                    else begin
                        tagFound := false;
                        break;
                    end;
                end;
            end;
        end;
    end;

    if tagFound then
    begin
        tc := 1;

        // -- We have to count all additional nodes
        while MarkA.FindTag(nnp) and (MarkA.LineNumber <= MarkA.RegionEndLine) do
            Inc(tc);

        Result := tc;
    end
    else
        Result := 0;

    MarkA.Destroy;
end;

// ----------------------------------------------------------------------------
{$IFDEF WIN32}
procedure GTDBizDoc.lsvLoadSubItems(aListView : TListView; SearchSection : HECMLMarker; ColumnNames : String);
var
	LineNum, ColumnCount, xc,xd : Integer;
	aLine, endTag,ColName,aValue,s1,s2		: String;
	anItem	: TListItem;
	ColList : TStringList;
	c : Char;

begin

	aListView.Selected := nil;

	if (SearchSection.LineNumber > fBody.Count) or (SearchSection.LineNumber<0) then
		Exit;

	ColList := TStringList.Create;

	try

		aListView.Items.BeginUpdate;

		// First split up any column names, and count
		// the number of columns
		s2 := ColumnNames;
		repeat
			StrSliceS2(s2 , ';', s1, s2);
			if s1 <> '' then
				ColList.Add(s1);
		until (s1 = '');
		ColumnCount := ColList.Count;

		// Read the message until the endtag is found
		endTag := '</' + SearchSection.SectionName + '>';

		aListView.Items.Clear;

		LineNum := SearchSection.LineNumber;
		while LineNum < fBody.Count do
		begin

			aLine := fBody.Strings[LineNum-1];

			// Look for the end tag
			if (Pos(endTag,aLine)<>0) then
				Break;

			// Look for each column
			for xc := 1 to ColumnCount do
			begin

				ColName := ColList.Strings[xc-1];

				xd := Pos(ColName,aLine);
				if (xd<>0) then
				begin
					// We have to extract the data value of this column
					Inc(xd, Length(ColName));

					aValue := SearchSection.ReadStringField(ColName);

					// Add an item to the list, and now add
					// the data to either the caption or as a
					// subitem.
					if xc = 1 then
					begin
						anItem := aListView.Items.Add;
						anItem.Caption := aValue
					end else if Assigned(anItem) then
						anItem.SubItems.Add(aValue);

				end;
			end;

			// Advance onto the next line
			Inc(LineNum);
			if LineNum > fBody.Count then
				Break;
		end;

		if aListView.Items.Count <> 0 then
		begin
			aListView.Selected := aListView.Items[0];
		end;

	finally
		aListView.Items.EndUpdate;
		ColList.Free;
	end;
end;
{$ENDIF}
// ----------------------------------------------------------------------------
function GTDBizDoc.FindLine(StartPos : Integer; TagName,ColumnName,DataValue : String):Integer;
var
	xc,xd : Integer;
	startTag,EndTag,aLine : String;
	FoundStartTag : Boolean;
begin
	Result := -1;
	if StartPos = -1 then
		Exit;

	startTag := '<' + TagName + '>';

	xd := fBody.Count;
	FoundStartTag := False;
	for xc := StartPos to xd do
	begin
		// Load the line into a temporary variable
		aLine := fBody.Strings[xc-1];

		if Pos(startTag,aLine)<>0 then
		begin
			// Advance to the next line
			aLine := fBody.Strings[xc];

			// Do some trickery
			if (Pos(ColumnName,aLine)<>0) and (Pos(DataValue,aLine)<>0) then
			begin
				Result := xc;
				break;
			end;
		end;
	end;

end;

{$IFDEF WIN32}
// ----------------------------------------------------------------------------
//
// Synopsis: Builds a nested markup file
//
//  ------------------------------------
//  Levels=1
//  Alias="DBDEMOS"
//  Level1_Query=select * from Parts
//  Level1_Tag=Items
//  ------------------------------------
//
//  ->      BizDoc.Definition.Assign(bsSkinMemo1.Lines);
//          BizDoc.PrepareXML;
//          bsSkinMemo2.Lines.Assign(BizDoc.XML);
//
procedure GTDBizDoc.PrepareXML;
var
	qryList : Array[1..10] of TQuery;

	function GetValueString(aList : TStrings; aKey : String):String;
	var
		xc,xd : Integer;
		aLine,tmstr : String;
	begin
		Result := '';
		for xc := 1 to aList.Count do
		begin
			aLine := aList.Strings[xc-1];

			// Take a copy of the string
			xd := Pos('=',aLine);
			if xd <> 0 then
			begin
				// Copy out the tag
				tmstr := Copy(aLine,1,xd-1);
				// Check the tag
				if (tmstr = aKey) then
				begin
					Result := Copy(aLine,xd+1,Length(aLine)-xd);

					// Remove any quotes
					if Result[1]='"' then
						Result := Copy(Result,2,Length(Result)-1);
					if Result[Length(Result)]='"' then
						Result := Copy(Result,1,Length(Result)-1);

					break;
				end;
			end;

		end;
	end;

	function GetValueInteger(aList : TStrings; aKey : String):Integer;
	begin
		Result := StrToInt(GetValueString(aList,aKey));
	end;

	procedure FixParams(LevelNumber : Integer);
	var
		xc,xd,xe,sLevel : Integer;
		s,se,sx,sv : String;
	begin
		//
		with qryList[LevelNumber].SQL do
		begin
			Clear;

			Add(GetValueString(fDef,'Level'+IntToStr(LevelNumber)+'_Query'));

			for xc := 1 to Count do
			begin
				// Load the string into memory
				s := Strings[xc-1];

				while Pos('#',s) <> 0 do
				begin
					// Look for the %
					xd := Pos('#',s);
					if (xd <> 0) then
					begin
						se := Copy(s,xd+1,Length(s)-xd);
						xe := Pos('#',se);
						if (xe <> 0) then
						begin
							// Extract our fieldname
							sx := Copy(se,1,xe-1);

							// Read our value
							sv := '"' + GetValueString(fParams,sx) + '"';

							// Rewrite the string
							s := Copy(s,1,xd-1) + sv + Copy(se,xe+1,Length(se)-xe);

						end;

					end;
				end;

				while Pos('%',s) <> 0 do
				begin
					// Look for the %
					xd := Pos('%',s);
					if (xd <> 0) then
					begin
						se := Copy(s,xd+1,Length(s)-xd);
						xe := Pos('%',se);
						if (xe <> 0) then
						begin
							// Extract our fieldname
							sLevel := Ord(se[1]) - Ord('0');
							if (sLevel>0) and (sLevel<9) then
							begin
								sx := Copy(se,3,xe-3);

								// Read our value
								sv := '"' + qryList[sLevel].FieldByName(sx).AsString + '"';

								// Rewrite the string
								s := Copy(s,1,xd-1) + sv + Copy(se,xe+1,Length(se)-xe);

							end;

						end ; {else
							Insert(s,xd,'%'); }
					end;
				end;
				Strings[xc-1] := s;
			end;
		end;
	end;

	procedure OutputOpenTag(LevelNumber : Integer);
	var
		aTag : String;
	begin
		aTag := GetValueString(fDef,'Level'+IntToStr(LevelNumber)+'_Tag');
		if aTag <> '' then
			fBody.Add(Copy('         ',1,LevelNumber)+'<' + aTag + '>');
	end;

	procedure OutputCloseTag(LevelNumber : Integer);
	var
		aTag : String;
	begin
		aTag := GetValueString(fDef,'Level'+IntToStr(LevelNumber)+'_Tag');
		if aTag <> '' then
			fBody.Add(Copy('         ',1,LevelNumber)+'</' + aTag + '>');
	end;

	procedure OutputData(LevelNumber : Integer);
	var
		xc,numFields : Integer;
		s : String;
	begin
		// Provide some indenting
		s := Copy('         ',1,LevelNumber);

		with qryList[LevelNumber] do
		begin
			// Add all the fields to the string
			for xc := 1 to FieldDefs.Count do
                case FieldDefs[xc-1].DataType of

                    ftBoolean	:   s := s + ' ' + EncodeBooleanField(FieldDefs[xc-1].Name,Fields[xc-1].Value);


                    ftDate,
                    ftTime,
                    ftDateTime,

                    ftString,
                    ftWideString,       // Wide string field
                    ftBytes,            // Fixed number of bytes (binary storage)
                    ftVarBytes,	        // Variable number of bytes (binary storage)
                    ftMemo,	            // Text memo field
                    ftFmtMemo,          //	Formatted text memo field
                    ftFixedChar :    	// Fixed character field
                                    s := s + ' ' + EncodeStringField(FieldDefs[xc-1].Name,Fields[xc-1].AsString);

                    ftSmallint,	        // 16-bit integer field
                    ftLargeint, 	    // Large integer field
                    ftInteger,	        // 32-bit integer field
                    ftWord,	            // 16-bit unsigned integer field
                    ftFloat,            // Floating-point numeric field
                    ftBCD,              // Binary-Coded Decimal field that can be converted to Currency type without a loss of precision.

                    ftAutoInc :          // Auto-incrementing 32-bit integer counter field
                                    s := s + ' ' + EncodeIntegerField(FieldDefs[xc-1].Name,Fields[xc-1].AsInteger);

                    ftCurrency:	        // Money field
                                    s := s + ' ' + EncodeCurrencyField(FieldDefs[xc-1].Name,Fields[xc-1].AsFloat);
                end;
                                    //                    ftBlob,             // Binary Large OBject field
//                    ftGraphic,          //	Bitmap field
// ftParadoxOle	Paradox OLE field
// ftDBaseOle	dBASE OLE field
// ftTypedBinary	Typed binary field
// ftCursor	Output cursor from an Oracle stored procedure (TParam only)

// ftADT	Abstract Data Type field
// ftArray	Array field
// ftReference	REF field
// ftDataSet	DataSet field
// ftOraBlob	BLOB fields in Oracle 8 tables
// ftOraClob	CLOB fields in Oracle 8 tables
// ftVariant	Data of unknown or undetermined type
// ftInterface	References to interfaces (IUnknown)
// ftIDispatch	References to IDispatch interfaces
// ftGuid	globally unique identifier (GUID) values
// ftTimeStamp	Date and time field accessed through dbExpress
// ftFMTBcd	Binary-Coded Decimal field that is too large for ftBCD.

		end;

		// Write out the result string
		fBody.Add(s);

	end;

	procedure UnWindLevel(LevelNumber,LevelCount : Integer);
	begin
		with qryList[LevelNumber] do
		begin
			// Check and replace any parameters
			FixParams(LevelNumber);

			Open;

			First;
			while not Eof do
			begin

				// Output the opening <tag>
				OutputOpenTag(LevelNumber);

				// Output the data for the item
				OutputData(LevelNumber);

				// Do any or all lower levels
				if (LevelNumber<LevelCount) then
					UnWindLevel(LevelNumber+1,LevelCount);

				Next;

				// Output the opening </tag>
				OutputCloseTag(LevelNumber);

			end;

			Close;

			Application.ProcessMessages;

		end;
	end;

var
	dbAlias : String;
	xc,
	LevelCount : Integer;
begin

	// Look for an Alias to use
	LevelCount := GetValueInteger(fDef,'Levels');
	dbAlias := GetValueString(fDef,'Alias');

	try

		// Create the TQuery objects
		for xc :=1 to LevelCount do
		begin
			// Create the object
			qryList[xc] := TQuery.Create(Self);

			with qryList[xc] do
			begin
				// Setup the TQuery object
				DatabaseName := dbAlias;
				SQL.Clear;
				SQL.Add(GetValueString(fDef,'Level' + IntToStr(xc)+'_Query'));
			end;
		end;

		// Now we run over each of the queries and process them
		UnWindLevel(1,LevelCount);

	finally

		// Destroy all of the queries for use again
		for xc := 1 to LevelCount do
			qryList[xc].Destroy;

	end;

end;
{$ENDIF}
// ----------------------------------------------------------------------------
procedure GTDBizDoc.SetDocumentType(aType : String);
begin
	if xml.Count = 0 then
	begin
		// -- This is our cool header which stops illegal copying of the software
		xml.Add(GTD_LANGUAGE);
		xml.Add('<!DOCTYPE "' + aType + '">');
	end;
end;

// ----------------------------------------------------------------------------
function GTDBizDoc.GetDocumentType  : String;
var
	xc : Integer;
	aStr : String;
begin

	for xc := 1 to xml.Count do
		if Copy(xml.Strings[xc-1],1,11) = '<!DOCTYPE "' then
		begin
			aStr := Copy(xml.Strings[xc-1],12,Length(xml.Strings[xc-1])-13);
			Result := aStr;
			break;
		end;
end;

// ----------------------------------------------------------------------------
procedure GTDBizDoc.AddTaggedString(theTag, theValue : String);
var
	newLine : String;
begin
	// Build the new line
	newLine := '<' + theTag + '>' + theValue + '</'+ theTag + '>';

	fBody.Add(newLine);

    fBody_Chg := True;

end;

// ----------------------------------------------------------------------------
function GTDBizDoc.ExtractTaggedString(theTag : String):String;
var
	xc,xd,tagLen : Integer;
	startTag,endTag,aValue : String;
	tagFound : Boolean;
begin
	if fBody.Count = 0 then
	begin
		ExtractTaggedString := '';
		Exit;
	end;

	// -- Build the tag and search for it
	startTag := '<' + theTag + '>';
	endTag := '</' + theTag + '>';
	tagLen := Length(StartTag);
	ExtractTaggedString := '';

	tagFound := False;
	xd := fBody.Count;
	for xc := 1 to xd do
		if CompareText(Copy(fBody.Strings[xc-1],1,tagLen),startTag)=0 then
		begin
			tagFound := True;

			// Now extract the value
			aValue := Copy(fBody.Strings[xc-1],tagLen+1,
						   Length(fBody.Strings[xc-1])-(2*tagLen)-1);

			ExtractTaggedString := aValue;
			break;
		end;

end;

// ----------------------------------------------------------------------------
function GTDBizDoc.ReadNextTag(var aTag : HECMLMarker):String;
begin
	Result := aTag.ReadNextTag;
end;

// ----------------------------------------------------------------------------
function GTDBizDoc.LastNodeName(n :String):String;
var
	p : Integer;
begin
	Result := n;
	for p := Length(n) downto 1 do
		if n[p] = '/' then
		begin
			Result := Copy(n,p+1,Length(n)-p);
			break;
		end;
end;

// ----------------------------------------------------------------------------
function GTDBizDoc.RemoveNode(NodePath : String):Boolean;
var
	xc,xd,sl,el : Integer;
    aNode : GTDNode;
begin
    Result := False;
    aNode := GTDNode.Create;

	if aNode.LoadFromDocument(Self,NodePath,false) then
    begin

    	// -- Determine where to delete from
        sl := aNode.CameFromLine;
    	// -- Determine how many lines to delete
        xd := aNode.CameFromCount + 2;

		// -- Now delete all the lines
		for xc := 1 to xd do
		begin
			XML.Delete(sl-1); {0 Based deletion}
		end;

        Result := True;
    end;

    aNode.Destroy;

end;

// ----------------------------------------------------------------------------
function GTDBizDoc.NodeNameWithoutLastIndex(n :String):String;
var
	s : String;
	j : Integer;
begin
	// -- Default return value will be standard input value
	Result := n;

    // -- If we have nothing then finish straight away
    if n = '' then
        Exit;

    // -- Check the last character for a ]
    if n[Length(n)] = ']' then
	begin
        // -- We have an Index at the end so chop it all off
        for j := Length(n) downto 1 do
        begin
            if n[j] = '[' then
            begin
                Result := Copy(n,1,j-1);
                break;
			end;
        end;
    end;
end;

// ----------------------------------------------------------------------------
procedure GTDBizDoc.SetIndexLine(LineNum : Integer; L : String);
begin
	// -- Put the string back in
	fDef.Strings[LineNum-1] := Copy(fDef.Strings[LineNum-1],1,8) + L;
end;

function GTDBizDoc.isIndexErrorLine(LineNum : Integer):Boolean;
begin
	if Copy(fDef.Strings[LineNum-1],1,Length(DOCDEF_ERROR_TAG)) = DOCDEF_ERROR_TAG then
		Result := True
	else
		Result := False;
end;

// ----------------------------------------------------------------------------
function GTDBizDoc.GetIndexLine(LineNum : Integer):String;
var
	xc : Integer;
	s : String;
begin
	// -- Load up the string into a temporary
	s := fDef.Strings[LineNum-1];
	xc := Pos('/',s);
	if xc = 0 then
	begin
		Result := s;
		Exit;
	end
	else
		Result := Copy(s,xc,length(s)-xc+1);
end;
// ----------------------------------------------------------------------------
// -- This function chops the linenumber off from the
//    start of a line in the fdef collection
function GTDBizDoc.GetIndexLineWithoutIndexes(LineNum : Integer):String;
var
	xc,xd : Integer;
	s : String;
begin
	s := GetIndexLine(LineNum);

	// -- Do nothing if we are doing an error message
	if Copy(s,1,Length(DOCDEF_ERROR_TAG)) = DOCDEF_ERROR_TAG then
	begin
		Result := '';
		Exit;
	end;

	// -- Now we have to remove any indexes
	xc := Pos('[',s);
	xd := Pos(']',s);
	while (xc <> 0) and (xd <> 0) do
	begin
		// -- Chop the indexed part out of the string
		s := Copy(s,1,xc-1) + Copy(s,xd+1,Length(s)-xd);

		// -- Check again now
		xc := Pos('[',s);
		xd := Pos(']',s);

	end;

	Result := s;

end;


// ----------------------------------------------------------------------------
function GTDBizDoc.isChild(ParentNodePath, ChildNodePath : String):Boolean;
var
	pl, cl : Integer;
begin
	Result := False;

	pl := Length(ParentNodePath);
	cl := Length(ChildNodePath);

	// -- If the child is shorter than the parent it's not a child
	if cl < pl then
		Exit;

	// -- Now check
	if Copy(ChildNodePath,1,pl) = ParentNodePath then
		Result := True;
end;

// ----------------------------------------------------------------------------
function GTDBizDoc.ExtractChildPart(ParentNodePath, ChildNodePath : String):String;
begin
	if IsChild(ParentNodePath,ChildNodePath) then
		Result := Copy(ChildNodePath,Length(ParentNodePath)+1,Length(ChildNodePath)-Length(ParentNodePath))
	else
		Result := '';
end;

// ----------------------------------------------------------------------------
procedure GTDBizDoc.LoadFromMultiLineString(SourceStr : String);
var
    s,l : String;
begin
    Clear;

    s := SourceStr;
    while (s <> '') do
	begin
        l := Parse(s,#10 + #13);
        Add(l);
    end;
    fBody_Chg := False;

end;
// ----------------------------------------------------------------------------
procedure GTDBizDoc.LoadFromFile(FilePath : String);
begin
    // -- Load the file
    XML.LoadFromFile(FilePath);

    // -- Mark the body of the document as having changed
    fBody_Chg := True;

    fFileName := FilePath;

end;
// ----------------------------------------------------------------------------
// NormalisedNodeName
//
// Synopsis:    This function removes [1] references out of a node
//              path. It leaves others. This is neccessary for doing
//              comparisons of node paths.
//
function GTDBizDoc.NormalisedNodeName(NodePath : String):String;
var
    s : String;
    xc : Integer;
begin
    // -- Check that we've been passed something meaningful
	if NodePath = '' then
        Exit;

	// -- Load up the nodepath into a temporary
	s := NodePath;

	// -- If there's padding at the start then chop it off
	if s[1] <> '/' then
	begin
		// -- This will take off the line number at the start of the line
		xc := Pos('/',s);
		if xc <> 0 then
			s := Copy(s,xc,Length(s)-xc+1);
	end;

    // -- Remove all the [1] indexes
    repeat
        xc := Pos('[1]',s);
        if xc <> 0 then
		begin
            // -- Chop out the [1] text
            s := Copy(s,1,xc-1) + Copy(s,xc+3,Length(s)-(xc+2));
		end;
	until xc = 0;

    // -- Remove the trailing / if it exists
    if s[Length(s)]='/' then
		s := Copy(s,1,Length(s)-1);

	Result := s;
end;

// ----------------------------------------------------------------------------
function GTDBizDoc.ReadDefinitionLineNumber(LineNum : Integer):Integer;
var
	xc : Integer;
	s : String;
begin
	Result := 0;

	// -- Read the line
	s := fDef.Strings[LineNum-1];
	xc := Pos(':',s);
	if (xc <> 0) then
	begin
		s := Trim(Copy(s,1,xc-1));

		Result := StrToInt(s);
	end;
end;

function GTDBizDoc.FindNodePathLine(NodePath : String):Integer;
var
    xc,xd : Integer;
    l,n : String;
begin
	Result := 0;

	// -- Here we have to parse the structure and find the
	//    highest numbered node
	xd := fDef.Count;

    n := NormalisedNodeName(NodePath);

	for xc := 1 to fDef.Count do
	begin
		// -- Pull the line out and load it into a temporary variable
		l := NormalisedNodeName(GetIndexLine(xc));
        if l = n then
        begin
            // -- We now have to go and get the source line number
            Result := ReadDefinitionLineNumber(xc);
            break;
        end;
    end;

end;
// -- Methods for reading elements
// ----------------------------------------------------------------------------
function GTDBizDoc.GetStringElement(Const NodePath, ElementName : String):String;
var
    s : String;
begin
    ReadStringElement(NodePath, ElementName, s);
	Result := s;
end;
// ----------------------------------------------------------------------------
function GTDBizDoc.GetNumberElement(Const NodePath, ElementName : String):Double;
var
    d : Double;
begin
    ReadNumberElement(NodePath,ElementName,d);
	Result := d;
end;
// ----------------------------------------------------------------------------
function GTDBizDoc.GetIntegerElement(Const NodePath, ElementName : String; DefaultValue : Integer):Integer;
var
    i : Integer;
begin
    i := DefaultValue;
    ReadIntegerElement(NodePath,ElementName,i);
    Result := i;
end;
// ----------------------------------------------------------------------------
function GTDBizDoc.GetDateElement(Const NodePath, ElementName : String):TDateTime;
var
    d : TDateTime;
begin
    ReadDateElement(NodePath,ElementName,d);
    Result := d;
end;
// ----------------------------------------------------------------------------
function GTDBizDoc.GetDateTimeElement(Const NodePath, ElementName : String):TDateTime;
var
    d : TDateTime;
begin
    ReadDateTimeElement(NodePath,ElementName,d);
    Result := d;
end;
// ----------------------------------------------------------------------------
function GTDBizDoc.GetBoolElement(Const NodePath, ElementName : String; DefaultValue : Boolean):Boolean;
var
    b : Boolean;
begin
    b := DefaultValue;
    ReadBoolElement(NodePath,ElementName,b);
    Result := b;
end;
// ----------------------------------------------------------------------------
function GTDBizDoc.ReadStringElement(Const NodePath, ElementName : String; var Value : String):Boolean;
var
	aNode : GTDNode;
begin
    Result := False;

    // -- Create a node
    aNode := GTDNode.Create;

    if aNode.LoadFromDocument(Self,NodePath,True) then
    begin
		Value := aNode.ReadStringField(ElementName);
        Result := True;
    end;

    aNode.Destroy;

end;
// ----------------------------------------------------------------------------
function GTDBizDoc.ReadNumberElement(Const NodePath, ElementName : String; var Value : Double):Boolean;
var
    aNode : GTDNode;
begin
	Result := False;

    // -- Create a node
    aNode := GTDNode.Create;

    if aNode.LoadFromDocument(Self,NodePath,True) then
    begin
		Value := aNode.ReadNumberField(ElementName,0);
        Result := True;
    end;

    aNode.Destroy;
end;
// ----------------------------------------------------------------------------
function GTDBizDoc.ReadIntegerElement(Const NodePath, ElementName : String; var Value : Integer):Boolean;
var
	aNode : GTDNode;
begin
    Result := False;

    // -- Create a node
    aNode := GTDNode.Create;

    if aNode.LoadFromDocument(Self,NodePath,True) then
	begin
		Value := aNode.ReadIntegerField(ElementName,Value);
        Result := True;
    end;

    aNode.Destroy;
end;
// ----------------------------------------------------------------------------
function GTDBizDoc.ReadDateElement(Const NodePath, ElementName : String; var Value : TDateTime):Boolean;
var
    aNode : GTDNode;
begin
    Result := False;

    // -- Create a node
    aNode := GTDNode.Create;

    if aNode.LoadFromDocument(Self,NodePath,True) then
    begin
        Value := aNode.ReadDateField(ElementName,Value);
		Result := True;
    end;

    aNode.Destroy;
end;
// ----------------------------------------------------------------------------
function GTDBizDoc.ReadDateTimeElement(Const NodePath, ElementName : String; var Value : TDateTime):Boolean;
var
	aNode : GTDNode;
begin
    Result := False;

    // -- Create a node
    aNode := GTDNode.Create;

    if aNode.LoadFromDocument(Self,NodePath,True) then
    begin
        Value := aNode.ReadDateField(ElementName,Value);
        Result := True;
	end;

    aNode.Destroy;
end;
// ----------------------------------------------------------------------------
function GTDBizDoc.ReadBoolElement(Const NodePath, ElementName : String; var Value : Boolean):Boolean;
var
    aNode : GTDNode;
begin
	Result := False;

    // -- Create a node
	aNode := GTDNode.Create;

    if aNode.LoadFromDocument(Self,NodePath,True) then
    begin
        Value := aNode.ReadBooleanField(ElementName,Value);
		Result := True;
    end;

    aNode.Destroy;
end;
// ----------------------------------------------------------------------------
// ComposeElement
//
// Synopsis
//
// This function builds a completely formed element.
//
function GTDBizDoc.ComposeElement(Const ElementName, ElementValue : String; ElementType : Char):String;
begin
    Result := ElementName + ElementType + '=' + EncodeString(ElementValue, ElementType);
end;

// ----------------------------------------------------------------------------
function GTDBizDoc.FindElementData(Const aNode : GTDNode; ElementName : String; var LineCount, ColumnNumber, DataWidth : Integer):Integer;
var
	aLine : String;
	inField, finished, FoundField,
	QuotedField, EndOfField, escaping : Boolean;
	xc, LineNumber, StartLineNumber,StartColNumber,
	FieldStartPos, FieldLength : integer;
	aChar, FieldType,c : char;
begin
	// -- Look for the field
	FoundField := False;
	finished := False;
	EndOfField := False;
    Result := 0;

    for LineNumber := 1 to aNode.MsgLines.Count do
    begin

		// -- Read the next line
		aLine := aNode.MsgLines[LineNumber-1];

		// -- Can we find the tag, then read the value
		xc := Pos(ElementName,aLine);
        if ((xc > 1) and ((aLine[xc-1]=',') or (aLine[xc-1]=' ')) or (xc = 1)) then
		begin

			// -- Skip over the fieldname
			FieldStartPos := xc + Length(ElementName);

			// -- Probe for our fieldtype
			FieldType := aLine[FieldStartPos];

			// -- Look for the '='
			if aLine[FieldStartPos + 1] = '=' then
			begin

				// -- Get everything after the '='
				FieldStartPos := FieldStartPos + 2;
				inField := True;
				ColumnNumber := FieldStartPos;
				FieldLength  := 0;
				escaping := False;

				// -- Now start reading the datafield
				EndOfField := False;
				inField := False;
				QuotedField := False;
				while (not EndOfField) and (FieldStartPos <= length(aLine)) do
				begin

					// -- Read the next character
					aChar := aLine[FieldStartPos];
					Inc(FieldStartPos);
					Inc(FieldLength);

					case aChar of
						// -- Process character escapes '\'
						'^' : begin
								escaping := True;
							  end;
						// -- Field quoting ?
						'"' : begin
								if (escaping) then
									escaping := False
								else if not inField then
								begin
									// -- We have found a quoted field
									inField := True;
									QuotedField := True;
								end
								else
									EndOfField := True
							  end;
					else
						// -- Add normal characters
						if (not inField) then
							inField := True;

					end;

				end;

                // -- We have found the correct line so return the result
                Result := LineNumber;
                DataWidth := FieldLength;

				break;

			end;


		end;

        ColumnNumber := 1;
	end;

end;

// ----------------------------------------------------------------------------
// SetBasicElement
//
// This function is the worker function that adds an element into a nodepath
// within the document
function GTDBizDoc.SetBasicElement(Const NodePath, ElementName, ElementValue : String; ElementType : Char):Boolean;

	function InsertBasicElement(Const NodePath, ElementName, ElementValue : String; ElementType : Char):Boolean;
    var
        aNode : GTDNode;
        s : String;
    begin
        Result := False;

        // -- Create a node
        aNode := GTDNode.Create;

        // -- Pull in the Node to edit it
        if aNode.LoadFromDocument(Self,NodePath,True) then
        begin
            // -- Build a tabbed string
            s := StringOfChar(' ',TabCharCount * GetNestCount(NodePath));

            // -- Put together the value
			s := s + ComposeElement(ElementName,ElementValue,ElementType);

            // -- Add the whole line to the node, at the start before anything else
            aNode.Insert(0,s);

			// -- Replace back the node into the document
            ReplaceTaggedSection(HECMLMarker(aNode));

			Result := True;
        end;

        aNode.Destroy;

    end;

    function UpdateBasicElement(Const NodePath, ElementName, ElementValue : String; ElementType : Char):Boolean;
    var
		aNode : GTDNode;
        s : String;
        LineNumber, ColNumber, LineCount, DataWidth : Integer;
    begin
        Result := False;

        // -- Create a node
        aNode := GTDNode.Create;

        // -- Pull in the Node to edit it
		if aNode.LoadFromDocument(Self,NodePath,True) then
        begin

            // -- Find the element
            LineNumber := FindElementData(aNode,ElementName,LineCount, ColNumber, DataWidth);

            if LineNumber <> 0 then
            begin
			    // -- Read the line out for easy debug
				s := aNode.MsgLines[LineNumber-1];

                // -- Pop back in the new value
                {
    			s := Copy(s,1,ColNumber - 1) +
					 ComposeElement(ElementName,ElementValue,ElementType) +
					 Copy(s,ColNumber + DataWidth, Length(s) - (ColNumber + DataWidth));
                }
                // -- Replace the whole line
    			s := Copy(s,1,ColNumber - 3 - Length(ElementName)) +
					 ComposeElement(ElementName,ElementValue,ElementType);

                // -- Store it back into the array
                aNode.MsgLines[LineNumber-1] := s;

                // -- Replace back the node into the document
				ReplaceTaggedSection(HECMLMarker(aNode));
                Result := True;
            end;

        end;

		aNode.Destroy;
    end;

begin
    Result := False;

    // -- First do node validation
    if not NodeExists(NodePath) then
    begin
        Result := CreateNodesInDocument(NodePath);

		// -- If we couldn't create the nodes then we can't go further
        if not Result then Exit;
    end;

    // -- Either add or update the existing element
    if ElementExists(NodePath,ElementName) then
        //
        Result := UpdateBasicElement(NodePath, ElementName, ElementValue, ElementType)
	else
		//
        Result := InsertBasicElement(NodePath, ElementName, ElementValue, ElementType)

end;
// ----------------------------------------------------------------------------
function GTDBizDoc.SetStringElement(Const NodePath, ElementName, ElementValue : String):Boolean;
begin
    Result := SetBasicElement(NodePath, ElementName,ElementValue,ECML_STRING_SUFFIX);
end;
// ----------------------------------------------------------------------------
function GTDBizDoc.SetCurrencyElement(Const NodePath, ElementName : String; ElementValue : Double):Boolean;
var
    s : String;
begin
    // -- Convert the number to a string
    s := FloatToStr(ElementValue);

    // -- Write the value to the message
    Result := SetBasicElement(NodePath, ElementName,s,ECML_CURRENCY_SUFFIX);
end;
// ----------------------------------------------------------------------------
function GTDBizDoc.SetNumberElement(Const NodePath, ElementName : String; ElementValue : Double):Boolean;
var
    s : String;
begin
    // -- Convert the number to a string
    s := FloatToStr(ElementValue);

    // -- Write the value to the message
    Result := SetBasicElement(NodePath, ElementName,s,ECML_NUMBER_SUFFIX);
end;
// ----------------------------------------------------------------------------
function GTDBizDoc.SetIntegerElement(Const NodePath, ElementName : String; ElementValue : Integer):Boolean;
var
    s : String;
begin
    // -- Convert the number to a string
    s := IntToStr(ElementValue);

	// -- Write the value to the message
    Result := SetBasicElement(NodePath, ElementName,s,ECML_INTEGER_SUFFIX);
end;
// ----------------------------------------------------------------------------
function GTDBizDoc.SetBooleanElement(Const NodePath, ElementName : String; ElementValue : Boolean):Boolean;
var
    s : String;
begin
	// -- Convert the number to a string
    if ElementValue then
		s := 'True'
    else
        s := 'False';

    // -- Write the value to the message
    Result := SetBasicElement(NodePath, ElementName,s,ECML_BOOLEAN_SUFFIX);
end;
// ----------------------------------------------------------------------------
function GTDBizDoc.SetDateElement(Const NodePath, ElementName : String; ElementValue : TDateTime):Boolean;
var
    s : String;
begin
    // -- Convert the vale to a string
    s := FormatDateTime(GTD_DATESTAMPFORMAT,ElementValue);

    Result := SetBasicElement(NodePath, ElementName,s,ECML_DATE_SUFFIX);
end;
// ----------------------------------------------------------------------------
function GTDBizDoc.CreateNodesInDocument(NodePath : String):Boolean;
var
    xc, levelsRequired : Integer;
    np,nn : String;
    nodeAdded : Boolean;

begin
	nodeAdded := False;
	Result := False;

    //    MessageDlg('Create new nodes at ' + NodePath, mtInformation,
    //           [mbOK], 0);

    if NodeExists(NodePath) then
    begin
        // -- We are duplicating
        nn := LastNodeName(NodePath);
        np := ChopAtLevel(NodePath,GetNestCount(NodePath)-1);

		// -- Run the node create a single time
        nodeAdded := CreateSingleNodeInDocument(np,nn);
    end
    else begin
        // -- Determine how many levels will be required
        levelsRequired := GetNestCount(NodePath);

        // -- Add nodes recursively into document
        for xc := 1 to levelsRequired do
		begin
            // -- Chop the nodepath to the appropriate level
            np := ChopAtLevel(NodePath,xc);

			// -- Check if the node exists
            if not NodeExists(np) then
            begin

				// -- Create the single node (as we can only do one at a time)
                nodeAdded := CreateSingleNodeInDocument(ChopAtLevel(NodePath,xc-1),NodeOfLevel(NodePath,xc));
            end;
        end;
    end;

    // -- Return to the caller with the result
    Result := nodeAdded;
end;
// ----------------------------------------------------------------------------
function GTDBizDoc.CreateSingleNodeInDocument(NodePath, NodeName : String):Boolean;
var
	xc,xd,xe : Integer;
    tagname,l1,l2,nn : String;
    aNode : GTDNode;
begin
    Result := False;

    // -- Create a node
    aNode := GTDNode.Create;

	// -- We actually load out the node and then replace it
    if (NodePath = '/') then
    begin
        // -- Now insert the lines into the node (last first)
        tagname := NodeNameWithoutLastIndex(NodeName);
		XML.Add('<' + tagname + '>');
		XML.Add('</' + tagname + '>');
		Result := True;
	end
	else if aNode.LoadFromDocument(Self,NodePath,True) then
	begin

		// -- Process the exact name of the tag
		tagname := NodeNameWithoutLastIndex(NodeName);
		xd := GetNodeIndex(NodeName);

		// -- Search for the tag
		xe := -2;
		for xc := 1 to xd-1 do
		begin
			if aNode.FindTag('/'+tagname) then
				xe := aNode.LineNumber;
		end;

		// -- If we couldn't find it, then we need to search for any
		//    tag
		if (xe = -2) and (aNode.MsgLines.Count <>0) then
		begin
			// -- We are looking for lines that are tagged, ie start with '<'
			for xc := 0 to aNode.MsgLines.Count-1 do
			begin
				nn := Trim(aNode.MsgLines[xc]);
				if (Length(nn)<>0) and (nn[1] = '<') then
				begin
					// -- We have found our first tagged line, insert here
					xe := xc - 1;
					break;
				end;
			end;
			// -- No tagged lines? INsert at end after possible elements
			if (xe = -2) then
				xe := aNode.MsgLines.Count-1;
		end;

		// -- Build the lines to be added
		l1 := StringOfChar(' ',TabCharCount * GetNestCount(NodePath)) + '<' + tagname + '>';
		l2 := StringOfChar(' ',TabCharCount * GetNestCount(NodePath)) + '</' + tagname + '>';

		// -- Now insert the lines into the node (last first)
		aNode.Insert(xe+2,l2);
		aNode.Insert(xe+2,l1);

		fBody_Chg := True;

        // -- Replace the note back into the document
		ReplaceNode(aNode);

        Result := True;
    end;

    aNode.Destroy;

end;

// ----------------------------------------------------------------------------
function GTDBizDoc.ElementExists(Const NodePath, ElementName : String):Boolean;
var
    LineCount, ColumnNumber, DataWidth : Integer;
    aNode : GTDNode;
begin
    Result := False;

    // -- Create a node
    aNode := GTDNode.Create;

	// -- Load the document and check for the element
    if aNode.LoadFromDocument(Self,NodePath,True) then
        if 0 <> FindElementData(aNode, ElementName,LineCount, ColumnNumber, DataWidth) then
            Result := True;

    aNode.Destroy;
end;
// ----------------------------------------------------------------------------
function GTDBizDoc.ElementType(Const NodePath, ElementName : String):Char;
begin
    Result := '*';
end;

// ----------------------------------------------------------------------------
function GTDBizDoc.Add(S : String):Integer;
begin
	Result := fBody.Add(S);
    fBody_Chg := True;
end;
// ----------------------------------------------------------------------------
function GTDBizDoc.Insert(Index : Integer; S : String):Integer;
begin
	if Index = 0 then
		fBody.Insert(Index,S)
	else if Index = 1 then
	begin
		// -- It's impossible to insert at line 1 with VCL
		if fBody.Count > 0 then
		begin
			// -- Put our value in at position 0
			fBody.Insert(0,s);
			// -- Now insert line 0 back at 0
			fBody.Exchange(1,0);
		end
		else
			fBody.Insert(0,s);
	end
	else
		// -- Insert at the correct spot
		fBody.Insert(Index-1,S);

    fBody_Chg := True;
	Result := 0;
end;
// ----------------------------------------------------------------------------
function GTDBizDoc.FindTag(TagToFind : String; StartLine : Integer):Integer;
var
	xc,xd,LineNumber : Integer;
	aLine : String;
	finished : Boolean;

begin
	// -- This next function reads every tag in
	//    It has to look for properly formed tags and yet
	//    be able to ignore "<" & ">" characters that are
	//    in the text

	finished := False;
    Result := 0;

	// -- Don't read over the end of the array
	if (StartLine >= fBody.Count) then
		Exit;

	for LineNumber := StartLine to fBody.Count do
    begin

		// -- Read the next line
		aLine := fBody.Strings[LineNumber-1];

		// -- Look for the tag opener
		xc := Pos('<' + TagToFind + '>',aLine);

		if (xc <> 0) then
		begin
			//-- Copy the name of the tag back
			Result := LineNumber;
            break;
		end;

	end;

end;
// ----------------------------------------------------------------------------
function GTDBizDoc.WriteAttachment(AttachmentName, OutputFileName : String):Boolean;
var
	ostrm : TFileStream;
begin
	Result := False;

	ostrm := TFileStream.Create(OutputFileName,fmCreate or fmOpenWrite);
	try

		result := WriteAttachmentToStream(AttachmentName,ostrm);

	except
		raise;
	end;

	ostrm.Destroy;

end;

// ----------------------------------------------------------------------------
function GTDBizDoc.WriteAttachmentToStream(AttachmentName : String; OutputStream : TStream):Boolean;
var
	lineNo              : Integer;
	CurLine,
	DestFileName        : String;

	function WriteAttachmentLines(var LineNumber : Integer):Boolean;
	var
		CurLine : String;
		xc : Integer;
		IndyMIMEDecoder : TIdDecoderMIME;
	begin

		IndyMIMEDecoder := TIdDecoderMIME.Create(Self);

		Result := False;

		try

			for xc := LineNumber + 1 to XML.Count do
			begin

				// -- Load up the current line
				CurLine := fBody.Strings[xc-1];

				// -- Check if we have
				if (Length(CurLine)>0) and (CurLine[1] = '=')
					and (CompareStr(Copy(CurLine, 1, 7), '====end') = 0) then
				begin
					// -- We have finished
					Result := True;
					break;
				end;

				// -- Otherwise pass the string onto our decoder
				IndyMIMEDecoder.DecodeToStream(CurLine,OutputStream);

			end;

		except
			raise;
		end;

		IndyMimeDecoder.Destroy;

	end;

begin
	Result := False;

    lineNo := CheckForFileInBody(AttachmentName);

    if (LineNo <> -1) then
        Result := WriteAttachmentLines(lineNo);

end;

// ----------------------------------------------------------------------------
constructor HECMLMarker.Create();
begin
	inherited Create;

	MsgLines := TStringList.Create;
end;

// ----------------------------------------------------------------------------
procedure HECMLMarker.Clear;
begin
	LineNumber := 0;
	ColumnNumber := 0;
	SectionMarking := False;
	onTag := False;
	SectionName := '';
	MsgLines.Clear;
	CameFromLine := 0;
	CameFromCol := 0;
	CameFromCount := 0;
end;

// ----------------------------------------------------------------------------
function HECMLMarker.Add(S : String):Integer;
begin
	Result := MsgLines.Add(S);
end;

// ----------------------------------------------------------------------------
function HECMLMarker.Insert(Index : Integer; S : String):Integer;
begin
	if Index = 0 then
		MsgLines.Insert(Index,S)
	else if Index = 1 then
	begin
		// -- It's impossible to insert at line 1 with VCL
		if MsgLines.Count > 0 then
		begin
			// -- Put our value in at position 0
			MsgLines.Insert(0,s);
			// -- Now insert line 0 back at 0
			MsgLines.Exchange(1,0);
		end
		else
			MsgLines.Insert(0,s);
	end
	else
		// -- Insert at the correct spot
		MsgLines.Insert(Index-1,S);

	Result := 0;
end;

// ----------------------------------------------------------------------------
procedure HECMLMarker.UseBodyText(UseStrings : TStrings);
begin
	LineNumber := 0;
	ColumnNumber := 0;
	SectionMarking := True;
	onTag := False;
	SectionName := '';

	MsgLines := TStringList(UseStrings);
end;
// ----------------------------------------------------------------------------
procedure HECMLMarker.UseSingleLine(S : String);
begin
    MsgLines.Clear;
    MsgLines.Add(S);
end;

// ----------------------------------------------------------------------------
function HECMLMarker.ReadNextTag:String;
var
	xc,xd : Integer;
	aLine : String;
	finished : Boolean;

	procedure AdvanceNextLine;
	begin
		Inc(LineNumber);
		ColumnNumber := 1;
		if (LineNumber = MsgLines.Count) then
			finished := True;
	end;
begin
	// -- This next function reads every tag in
	//    It has to look for properly formed tags and yet
	//    be able to ignore "<" & ">" characters that are
	//    in the text

	finished := False;
	Result := '';
	SectionName := '';

	// -- Don't read over the end of the array
	if (LineNumber >= MsgLines.Count) then
		Exit;

	repeat

		// -- Read the next line
		aLine := MsgLines.Strings[LineNumber];
		aLine := Copy(aLine,ColumnNumber,Length(aLine)-ColumnNumber+1);

		// -- Look for the tag opener
		xc := Pos('<',aLine);

		// -- There must be a tag closer also here somewhere
		xd := Pos('>',aLine);

		if ((xc <> 0) and (xd <> 0)) then
		begin
			//-- Copy the name of the tag back
			SectionName := Copy(aLine,xc+1,xd - xc -1);
			onTag := True;
			ColumnNumber := ColumnNumber + xd + 1;
			if (ColumnNumber >= Length(MsgLines.Strings[LineNumber])) then
				AdvanceNextLine;
			finished := True;
		end
		else begin
			// Advance onto the next line
			AdvanceNextLine;
		end;

	until finished;

	Result := SectionName;

end;

// ----------------------------------------------------------------------------
procedure HECMLMarker.SkipTaggedSection;
var
	TagStack : TStringList;
	aTag,endTag  : String;
	NestCount    : Integer;
	finished 	 : Boolean;
begin
	// -- Create a stack so that we can advance into nested tagged
	//    sections
	TagStack := TStringList.Create;
	endTag := '/' + SectionName;
	NestCount := 0;
	finished := False;

	repeat
		// -- We must find the next tag
		aTag := ReadNextTag;
		if (aTag = '') then
			// -- No more tags
			finished := true
		else begin

			// -- We just might be finished
			if ((NestCount = 0) and (endTag = aTag)) then
				finished := True

			// -- Are we getting more nested or less nested
			else if (aTag[1] = '/') then
			begin
				// -- We're getting less nested
				TagStack.Delete(NestCount);
				Dec(NestCount);
			end
			else begin
				// -- We're getting more nested
				TagStack.Add(aTag);
				Inc(NestCount);
			end;
		end;
	until finished;

	TagStack.Destroy;
end;

function HECMLMarker.ReadRawField(FieldName : String; DefaultValue : String;var FieldType : Char):String;
var
	aLine,l : String;
	inField, finished, QuotedField, EndOfField,fieldfound : Boolean;
	xc, xd, StartLineNumber,StartColNumber : integer;
	aChar, c : char;
begin
	// -- Look for the field
	finished := False;
	EndOfField := False;
    fieldfound := False;
	Result := '';

	// -- Don't read over the end of the array
	if (LineNumber >= MsgLines.Count) then
		Exit;

	// -- Save the starting line number
	StartLineNumber := LineNumber;
	StartColNumber := ColumnNumber;

	repeat

		// -- Read the next line
		aLine := MsgLines.Strings[LineNumber];
		aLine := Copy(aLine,ColumnNumber,Length(aLine)-ColumnNumber+1);

		// -- We must only read up to the closing tag
		xc := Pos('</' + SectionName +'>',aLine);
		if (xc <> 0) then
		begin
			aLine := Copy(aLine,1,xc - 1);
			finished := True;
		end;

		// -- Can we find the tag, then read the value
        l := aLine;
        xd := Pos(FieldName,l);
        while (xd <> 0) and (not Finished) and (xd <> -1) do
        begin

            // -- We must check the character before the start
            //    of the tag name and make sure that it's not
            //    some other character, otherwise we may not
			//    have the right field
            if ((xd >= 2) and (Pos(l[xd-1],', *'+#7+#9)=0)) then
                // -- This is not the right tag, but might be there later
                break;

            // -- We have found the right field
            fieldfound := True;

			// -- Find the fieldname
            xd := Pos(FieldName,l);
            if (xd <> 0) then
                l := Copy(l,xd+Length(FieldName),Length(l));

			// -- Skip over the fieldname
			ColumnNumber := xd;

			// -- Probe for our fieldtype
 			FieldType := l[1];
            if Pos(FieldType,ECML_ALL_SUFFIXES)=0 then
			begin
                // -- This isn't the value we are looking for
                l := l;
                continue;
            end;

			// -- Look for the '='
			xc := Pos('=',l);
			if (xc <> 0) then
			begin
				// -- Get everything after the '='
				ColumnNumber := ColumnNumber + xc + 2;
				inField := True;
				l := Copy(l,xc+1,Length(l)-xc);
			end;

			// -- Now start reading the datafield
			EndOfField := False;
			inField := False;
			QuotedField := False;
			while not EndOfField do
			begin

				// -- Read the next character
				if (Length(l)=0) then
					EndOfField := True

				else begin

					// -- Read the next character
					aChar := l[1];
					Inc(ColumnNumber);
					l := Copy(l,2,Length(l)-2+1);

					case aChar of
						// -- Process character escapes '\'
						'^' : begin
								if (Length(l) > 1) then
								begin
									c := l[1];
									if ((c >= 'a') and (c <= 'z')) then
										// -- Lowercase
										Result := Result + Chr(Ord(c) - Ord('a') + 1)
									else if ((c >= 'A') and (c <= 'Z')) then
										// -- Uppercase
										Result := Result + Chr(Ord(c) - Ord('A') + 1)
									else
										// -- Simply use the next character
										Result := Result + c;

									Inc(ColumnNumber);
									l := Copy(l,2,Length(l)-2+1);
								end;
							  end;
						// -- Field quoting ?
						'"' : begin
								if (not inField) then
								begin
									// -- We have found a quoted field
									inField := True;
									QuotedField := True;
								end
								else
									EndOfField := True
							  end;
						// -- Spacing
						' ',',' : begin
								if (QuotedField) then
									Result := Result + aChar
								else if (inField) then
									EndOfField := True
							  end;
                        // -- End of line
            			#13,#10 : begin
                                if not QuotedField then
                                    EndOfField := True;
                              end;

					else
						// -- Add normal characters
						if (not inField) then
							inField := True;

						Result := Result + aChar;
					end;

				end;

			end;

			// -- We have finished processing
			if (EndOfField) then
			begin
                Finished := True;
				break;
			end;

            // -- Now chop from after the field
            if not Finished then
			begin
                l := Copy(l,xd+Length(FieldName)+1,Length(l)-(Length(FieldName)+1));
                xd := Pos(FieldName,l);
            end;

		end;

		// -- Advance onto the next line
		Inc(LineNumber);
		ColumnNumber := 1;
		if (LineNumber = MsgLines.Count) then
			finished := True;

	until finished;

	// -- Restore the line number and column position
	LineNumber := StartLineNumber;
	ColumnNumber := StartColNumber;

	// -- Use the default value if we did not find anything
    if not fieldfound then
       Result := DefaultValue;
end;

// ----------------------------------------------------------------------------
function HECMLMarker.ReadStringField(FieldName : String; DefaultValue : String):String;
var
   FieldType : Char;
   myDateTime : TDateTime;
begin
    Result := ReadRawField(FieldName,DefaultValue,FieldType);

    // -- Special formatting for dates
    if FieldType = ECML_DATE_SUFFIX then
    begin
        // -- Reread the field, to obtain the value, then nicely format it
		myDateTime := 0;
        myDateTime := ReadDateTimeField(FieldName,myDateTime);
        if myDateTime <> 0 then
        begin
            // -- We have a date, do we have a time?
            if Round(myDateTime) <> myDateTime then
                // -- We have a date and a time
                Result := FormatDateTime('ddddd tt',myDateTime)
            else
                // -- A date only
                Result := FormatDateTime('ddddd',myDateTime);
		end;
    end;

end;

// ----------------------------------------------------------------------------
function StringToFloat(const S: string): Extended;
var
	xc : Integer;
	afterdot, isneg : Boolean;
	decFactor : Double;
	c : char;
begin
	// -- Read out the value
	afterdot := false;
	isneg := false;
	decFactor := 1;

	// -- Do a simple conversion here
	if Length(s) > 0 then
	begin
		Result := 0;
		for xc := 1 to Length(s) do
		begin
			c := s[xc];

			if (c <= '9') and (c >= '0') then
			begin
				if (not afterdot) then

					// -- A Positive digit
					Result := (Result * 10) + Ord(c) - Ord('0')

				else
				begin
					// -- We're doing decimal points
					decFactor := decFactor / 10;
					Result := Result + ((Ord(c) - Ord('0')) * decFactor);
				end;

			end
			else if ((c = '.') or (c = ',')) then
				afterdot := true
			else if ((c = '-') or (c = '(')) then
				isneg  := true
			else if (c=' ') then
				break;
		end;

		// -- Flip into negative
		if isneg then
			Result := Result * -1;
	end
	else
		Result := 0;

end;

// ----------------------------------------------------------------------------
function HECMLMarker.ReadNumberField(FieldName : String; defaultValue : Double):Extended;
var
	s : String;
    FieldType : Char;
begin
	// -- Read out the value
	s := ReadRawField(FieldName,FloatToStr(defaultValue),FieldType);
	if Length(s) > 0 then
		Result := StringToFloat(s)
	else
		// -- Use the default value
		Result := defaultValue;
end;

// ----------------------------------------------------------------------------
function HECMLMarker.ReadDateField(FieldName : String; defaultValue :TDateTime):TDateTime;
var
	s : String;
	xc : Integer;
	dd,mm,yy : Word;
    FieldType,c : Char;
begin
    Result := defaultValue;

	// -- Read out the value
	s := ReadRawField(FieldName,'',FieldType);

    if FieldType = ECML_DATE_SUFFIX then
    begin
        // -- Due a rudimentory check
        if (s[5]='-') and (s[8]='-') then
        begin
            yy := Word(Round(StringToFloat(Copy(s,1,4))));
            mm := Word(Round(StringToFloat(Copy(s,6,2))));
			dd := Word(Round(StringToFloat(Copy(s,9,2))));
            Result := EncodeDate(yy,mm,dd);
            Exit;
        end;
    end;

    // 2003-Oct-19
	// -- This will do for the moment
	if ((Length(s) = 0) or (Length(s) <> 11) or
		(s[5] <> '-') or (s[9] <> '-')) then
		Result := defaultValue
	else begin
		// -- Do all this crap
		yy := ((Ord(s[3])-Ord('0')) * 10) + (Ord(s[4])-Ord('0'));
		mm := (Pos(Copy(s,6,3),'JanFebMarAprMayJunJulAugSepOctNovDec') div 3) + 1;
		dd := ((Ord(s[10])-Ord('0')) * 10) + (Ord(s[11])-Ord('0'));

		// -- Do a fixup on dates
		if ((yy >= 0) and (yy <= 20)) then
			yy := yy + 2000
		else if ((yy >= 0) and (yy <= 99) and (yy > 20)) then
			yy := yy + 1900;

		if ((dd >= 1) and (dd <= 31) and
			(mm >= 1) and (mm <= 12) and
			(yy >= 0) and (yy <= 3000)) then
			// -- This date looks ok
			Result := EncodeDate(yy,mm,dd)
		else
			// -- This date looks crap
			Result := defaultValue;
	end;
end;
// ----------------------------------------------------------------------------
function HECMLMarker.ReadDateTimeField(FieldName : String; defaultValue :TDateTime):TDateTime;
var
	dd,mm,yy,hh,mi,ss : Word;
    s : String;
    FieldType : Char;
begin
    Result := defaultValue;

	s := ReadRawField(FieldName,'',FieldType);
    if s = '' then
        exit;

    // -- Due a rudimentory check
	if (s[5]='-') and (s[8]='-') then
    begin
        yy := Word(Round(StringToFloat(Copy(s,1,4))));
        mm := Word(Round(StringToFloat(Copy(s,6,2))));
        dd := Word(Round(StringToFloat(Copy(s,9,2))));
    end
    else
        Exit;

	// -- If our string contains 'T', then we have a time
    if Pos('T',s) = 0 then
        Result := EncodeDate(yy,mm,dd)
    else
    begin
        hh := StrToInt(Copy(s,12,2));
        mi := StrToInt(Copy(s,15,2));
        ss := StrToInt(Copy(s,18,2));
		Result := EncodeDate(yy,mm,dd) + EncodeTime(hh,mi,ss,0);
    end;

end;

// ----------------------------------------------------------------------------
function HECMLMarker.ReadIntegerField(FieldName : String; DefaultValue : Integer):Integer;
var
	s : String;
	xc : Integer;
	isPos : boolean;
	FieldType : Char;
begin
	// -- Read out the value
	s := ReadRawField(FieldName,IntToStr(DefaultValue),FieldType);

	if Length(s) = 0 then
		Result := DefaultValue
	else begin
		// -- Do a simple conversion here
		Result := 0;
		isPos := True;
		for xc := 1 to Length(s) do
			if (s[xc] = '-') then
				isPos := False
			else if (s[xc] <= '9') and (s[xc] >= '0') then
				Result := (Result * 10) + Ord(s[xc]) - Ord('0')
			else
				break;

		if not isPos then
			Result := Result * -1;
	end;
end;

// ----------------------------------------------------------------------------
function HECMLMarker.ReadBooleanField(FieldName : String; DefaultValue : Boolean):Boolean;
var
	s : String;
	FieldType : Char;
begin

	// -- Read out the value
	s := ReadRawField(FieldName,'',FieldType);
	if Length(s) > 0 then
	begin
		// --
		Result := Uppercase(s) = 'TRUE';
	end
	else
		// -- Use the default value
		Result := DefaultValue;
end;
// ----------------------------------------------------------------------------
function HECMLMarker.FindTag(TagToFind : String; StopAtLine : Integer):Boolean;
var
	xc,xd : Integer;
	aLine, origSectionName : String;
	finished : Boolean;
	origLineNumber, origColumnNumber : Integer;

begin
	// -- This next function reads every tag in
	//    It has to look for properly formed tags and yet
	//    be able to ignore "<" & ">" characters that are
	//    in the text

	finished := False;
	Result := False;
	SectionName := '';

	// -- Save these values for the case where we can't find the tag
	origLineNumber := LineNumber;
	origColumnNumber := ColumnNumber;
    origSectionName := SectionName;

	if StopAtLine = -1 then
        StopAtLine := MsgLines.Count;

	// -- Don't read over the end of the array
	if (LineNumber >= MsgLines.Count) then
		Exit;

	repeat

		// -- Read the next line
		aLine := MsgLines.Strings[LineNumber];
        // -- If it's the first line, read only after the tag
        if LineNumber = origLineNumber then
		    aLine := Copy(aLine,ColumnNumber,Length(aLine)-ColumnNumber+1);

		// -- Look for the tag opener
		xc := Pos('<' + TagToFind + '>',aLine);

		if (xc <> 0) then
		begin
			//-- Copy the name of the tag back
			SectionName := TagToFind;
			onTag := True;
			ColumnNumber := ColumnNumber + Length(SectionName);
			finished := True;
			Result := True;
		end
		else begin
			// Advance onto the next line
			Inc(LineNumber);
			ColumnNumber := 1;
			if ((LineNumber = MsgLines.Count) or (LineNumber = StopAtLine)) then
				finished := True;
		end;

	until finished;

	// -- If we couldn't find what we were looking for, then we need to
	//    restore our original position
	if not Result then
	begin
		LineNumber := origLineNumber;
		ColumnNumber := origColumnNumber;
		SectionName := origSectionName;
	end;

end;
// ----------------------------------------------------------------------------
function HECMLMarker.FindTagRegion(TagToFind : String):Boolean;
var
	xc,xd : Integer;
	aLine, origSectionName : String;
	finished : Boolean;
	origLineNumber, origColumnNumber,StopLineNumber : Integer;

begin
	// -- This next function reads every tag in
	//    It has to look for properly formed tags and yet
	//    be able to ignore "<" & ">" characters that are
	//    in the text

	finished := False;
	Result := False;
	SectionName := '';

	// -- Save these values for the case where we can't find the tag
	origLineNumber := LineNumber;
	origColumnNumber := ColumnNumber;
    origSectionName := SectionName;

    if RegionEndLine = 0 then
        RegionEndLine := MsgLines.Count;

	// -- Don't read over the end of the array
	if (LineNumber >= MsgLines.Count) then
		Exit;

	repeat

		// -- Read the next line
		aLine := MsgLines.Strings[LineNumber];
        // -- If it's the first line, read only after the tag
        if LineNumber = origLineNumber then
		    aLine := Copy(aLine,ColumnNumber,Length(aLine)-ColumnNumber+1);

		// -- Look for the tag opener
		xc := Pos('<' + TagToFind + '>',aLine);

		if (xc <> 0) then
		begin
			//-- Copy the name of the tag back
			SectionName := TagToFind;
			onTag := True;
			ColumnNumber := ColumnNumber + Length(SectionName);
			finished := True;
			Result := True;

		end
		else begin
			// Advance onto the next line
			Inc(LineNumber);
			ColumnNumber := 1;
			if (LineNumber = MsgLines.Count) or (LineNumber = RegionEndLine) then
				finished := True;
		end;

	until finished;

    if result then
    begin

        // -- We found the first tag, but not the last
		result := false;
        finished := False;
        StopLineNumber := LineNumber;

        // -- We are going to go looking for the closing tag
        repeat

            // -- Read the next line
			aLine := MsgLines.Strings[StopLineNumber];

            // -- If it's the first line, read only after the tag
            if LineNumber = origLineNumber then
                aLine := Copy(aLine,ColumnNumber,Length(aLine)-ColumnNumber+1);

            // -- Look for the tag opener
            xc := Pos('</' + TagToFind + '>',aLine);

            if (xc <> 0) then
            begin
				//-- Copy the name of the tag back
                RegionEndLine := StopLineNumber;
                Result := True;
                finished := true;
            end
            else begin
                // Advance onto the next line
                Inc(StopLineNumber);
                ColumnNumber := 1;
				if (StopLineNumber = MsgLines.Count) or (StopLineNumber = RegionEndLine) then
                    finished := True;
            end;

        until finished;
    end;

	// -- If we couldn't find what we were looking for, then we need to
	//    restore our original position
	if not Result then
	begin
		LineNumber := origLineNumber;
		ColumnNumber := origColumnNumber;
		SectionName := origSectionName;
	end;
end;
// ----------------------------------------------------------------------------
procedure HECMLMarker.Assign(TagToCopy : HECMLMarker);
begin
	LineNumber 		:= TagToCopy.LineNumber;
	ColumnNumber 	:= TagToCopy.ColumnNumber;
	SectionMarking 	:= TagToCopy.SectionMarking;
	onTag 			:= TagToCopy.onTag;
	SectionName 	:= TagToCopy.SectionName;
	MsgLines		:= TagToCopy.MsgLines;

	CameFromLine 	:= TagToCopy.CameFromLine;
	CameFromCol  	:= TagToCopy.CameFromCol;
	CameFromCount 	:= TagToCopy.CameFromCount;

end;

// ----------------------------------------------------------------------------
procedure HECMLMarker.WriteStringField(FieldName, FieldValue : String);
var
	aLine : String;
	inField, finished, FoundField,
	QuotedField, EndOfField, escaping : Boolean;
	xc, StartLineNumber,StartColNumber,
	FieldStartPos, FieldLength : integer;
	aChar, FieldType,c : char;
begin
	// -- Look for the field
	FoundField := False;
	finished := False;
	EndOfField := False;

	// -- Add the field onto the end and finish up
	if (LineNumber >= MsgLines.Count) then
    begin
        // aLine := StringOfChar(' ',TabCharCount * GetNestCount(NodePath));
        aLine := StringOfChar(' ',defaultElementCol) + FieldName + '&=' + EncodeString(FieldValue,'&');
        MsgLines.Add(aLine);
        Exit;
    end;

	// -- Save the starting line number
	StartLineNumber := LineNumber;
	StartColNumber := ColumnNumber;

	repeat

		// -- Read the next line
		aLine := MsgLines.Strings[LineNumber];

		// -- We must only read up to the closing tag
		xc := Pos('</' + SectionName +'>',aLine);
		if (xc <> 0) then
		begin
			finished := True;
			Exit;
		end;

		// -- Can we find the tag, then read the value
		xc := Pos(FieldName,aLine);
		if ((xc > 1) and ((aLine[xc-1]=',') or (aLine[xc-1]=' ')) or (xc = 1)) then
		begin

			// -- Skip over the fieldname
			ColumnNumber := xc + Length(FieldName);

			// -- Probe for our fieldtype
			FieldType := aLine[ColumnNumber];

			// -- Look for the '='
			if aLine[ColumnNumber + 1] = '=' then
			begin

				// -- Get everything after the '='
				ColumnNumber := ColumnNumber + 2;
				inField := True;
				FieldStartPos := ColumnNumber;
				FieldLength   := 0;
				escaping := False;

				// -- Now start reading the datafield
				EndOfField := False;
				inField := False;
				QuotedField := False;
				while (not EndOfField) and (ColumnNumber <= length(aLine)) do
				begin

					// -- Read the next character
					aChar := aLine[ColumnNumber];
					Inc(ColumnNumber);
					Inc(FieldLength);

					case aChar of
						// -- Process character escapes '\'
						'^' : begin
								escaping := True;
							  end;
						// -- Field quoting ?
						'"' : begin
								if (escaping) then
									escaping := False
								else if not inField then
								begin
									// -- We have found a quoted field
									inField := True;
									QuotedField := True;
								end
								else
									EndOfField := True
							  end;
					else
						// -- Add normal characters
						if (not inField) then
							inField := True;

					end;

				end;

			end;

			// -- Update the field
			aLine := Copy(aLine,1,FieldStartPos - 1) +
					 EncodeString(FieldValue,'&') +
					 Copy(aLine,FieldStartPos + FieldLength, Length(aLine) - (FieldStartPos + FieldLength));

			MsgLines.Strings[LineNumber] := aLine;
			finished := True;

		end;

		// -- Advance onto the next line
		Inc(LineNumber);
		ColumnNumber := 1;
		if (LineNumber = MsgLines.Count) then
			finished := True;

	until finished;

	// -- Restore the line number and column position
	LineNumber := StartLineNumber;
	ColumnNumber := StartColNumber;

end;

// ----------------------------------------------------------------------------
function HECMLMarker.ReplaceMarker(aTag : HECMLMarker):Boolean;
var
	xc,l : Integer;
	s : String;
begin
	// -- First we go through the original and chop out the
	//    old copy of our marker
	if aTag.CameFromCount <> 0 then
	begin

		// -- Chop the old stuff out
		for xc := 1 to aTag.CameFromCount do
			MsgLines.Delete(aTag.CameFromLine);

		// -- Replace our tagged section (with possibly
		//    a different number of lines
		for xc := aTag.MsgLines.Count downto 1 do
		begin
			s := aTag.MsgLines[xc-1];

			Insert(aTag.CameFromLine+1,s);
		end;

		aTag.CameFromCount := aTag.MsgLines.Count;

	end
	else begin

		// -- Add our tagged section one line before the end
		if MsgLines.Count <> 0 then
		begin
			// -- We've already got some lines
			for xc := 1 to aTag.MsgLines.Count do
				Insert(MsgLines.Count, aTag.MsgLines[xc-1]);
		end
		else
			// -- We haven't got any lines
			for xc := 1 to aTag.MsgLines.Count do
				MsgLines.Add(aTag.MsgLines[xc-1]);

		// -- And update our pointers
		aTag.CameFromCount := aTag.MsgLines.Count;
	end;
end;

// ----------------------------------------------------------------------------
function HECMLMarker.ReplaceTaggedSection(aSection : string; aTag : HECMLMarker):Boolean;
var
	xc,l : Integer;
begin
	// -- First we go through the original and chop out the
	//    old copy of our marker
	if aTag.CameFromCount <> 0 then
	begin

		// -- Chop the old stuff out
		for xc := 1 to aTag.CameFromCount do
			MsgLines.Delete(aTag.CameFromLine);

		// -- This is where we had nothing to remove
        if aSection <> '' then
        begin
            MsgLines.Insert(aTag.CameFromLine, '<' + aSection + '>');
			MsgLines.Insert(aTag.CameFromLine+1, '</' + aSection + '>');
        end;

		// -- Replace our tagged section (with possibly
		//    a different number of lines
		for xc := 1 to aTag.MsgLines.Count do
			MsgLines.Insert(aTag.CameFromLine+xc-1,aTag.MsgLines[xc-1]);
	end
	else begin

		// -- This is where we had nothing to remove
		MsgLines.Add('<' + aSection + '>');

		// -- Add our tagged section onto the end
		for xc := 1 to aTag.MsgLines.Count do
			MsgLines.Add(aTag.MsgLines[xc-1]);

		// and terminate the section
		MsgLines.Add('</' + aSection + '>');
	end;

end;

// ----------------------------------------------------------------------------
function HECMLMarker.InsertTaggedSection(SectionTag : String; aTag : HECMLMarker; LineNumber : Integer):Boolean;
var
	xc : Integer;
begin
	MsgLines.Insert(LineNumber-1,'<' + SectionTag +'>');
	MsgLines.Insert(LineNumber, '</' + SectionTag +'>');

	// -- Copy all the values out
	for xc := 1 to aTag.MsgLines.Count do
	begin
		Insert(LineNumber,aTag.MsgLines.Strings[xc-1]);
	end;

	Result := True;

end;

// ----------------------------------------------------------------------------
function HECMLMarker.AppendTaggedSection(SectionTag : String; aTag : HECMLMarker; TabIndex : Integer):Boolean;
var
	xc : Integer;
	pad : String;
begin
	// -- Build a padding string
	pad := Copy('                                                     ',
				1,
				TabIndex * TabCharCount);

	// -- Put the tag header into the array
	Add(pad + '<' + SectionTag +'>');

	// -- Copy all the values out
	for xc := 1 to aTag.MsgLines.Count do
	begin
		Add(pad + aTag.MsgLines.Strings[xc-1]);
	end;

	// -- Finish up now
	Add(pad + '</' + SectionTag +'>');

	Result := True;

end;

// ----------------------------------------------------------------------------
function HECMLMarker.InsertMarkerBefore(SectionTag : String; aTag : HECMLMarker):Boolean;
var
	xc,li : Integer;
	s : String;
begin
	if FindTag(SectionTag) then
	begin
		// -- Copy all the values out
		for xc := aTag.MsgLines.Count downto 1 do
		begin
			// -- Find the value
			s := aTag.MsgLines.Strings[xc-1];

			// -- Insert it
			Insert(LineNumber + 1,s);
		end;

		// -- Fix these markers
		aTag.CameFromLine := LineNumber;
		aTag.CameFromCount := aTag.MsgLines.Count;

		Result := True;
	end
	else
		Result := False;

end;

{$IFNDEF HW_SIMPLE}
// ----------------------------------------------------------------------------
function HECMLMarker.ExtractTaggedSection(aSection : string; FromStringList : TStrings):Boolean;
var
	aTag : HECMLMarker;
	endTag,s	: string;
	sl, el, xc  : Integer;
begin
	aTag := HECMLMarker.Create;
	Result := False;

	// -- Clear out our existing list before we do anything
	MsgLines.Clear;

	// -- Load our tag with the correct list of values
	aTag.UseBodyText(FromStringList);

	if aTag.FindTag(aSection) then
	begin

		endTag := '/' + aSection;

		// -- Save the starting line number
		sl := aTag.LineNumber;

		if aTag.FindTag(endTag) then
		begin

			el := aTag.LineNumber;

			// -- These values are recorded if we need
			//    to put this section back in
			CameFromLine := sl + 1;
			CameFromCol := 0;
			CameFromCount := el - sl - 1;

			// -- Copy all the values out
			for xc := (sl+1) to (el-1) do
			begin
				// -- Here is the line
				s := aTag.MsgLines.Strings[xc];

				MsgLines.Add(s);
			end;

			CameFromCount := MsgLines.Count;

			// -- We have to copy over the section name
			SectionName := aSection;

			Result := True;

		end
		else begin

//			MessageDlg('Can''t find tag ' + endTag, mtError,[mbok],0);

			Result := False;
		end;

	end;

	aTag.Destroy;
end;
{$ENDIF}

// ----------------------------------------------------------------------------
function HECMLMarker.ExtractTaggedSection(aSection : string; FromMarker: HECMLMarker):Boolean;
var
	s,endTag 	: string;
	sl, el, xc  : Integer;
	FoundTag    : Boolean;
begin
	Result := False;

	// -- Clear out our existing list before we do anything
	MsgLines.Clear;

	// -- If we're not on the tag then we have to look for it
	if (FromMarker.SectionName = aSection) then
		FoundTag := True
	else
		FoundTag := FromMarker.FindTag(aSection);

	// -- If we found the tag then we can get data
	if FoundTag then
	begin

		endTag := '/' + aSection;

		// -- Save the starting line number
		sl := FromMarker.LineNumber;

		if FromMarker.FindTag(endTag) then
		begin

			el := FromMarker.LineNumber;

			// -- These values are recorded if we need
			//    to put this section back in
			CameFromLine := sl + 1;
			CameFromCol := 0;
			CameFromCount := el - sl - 1;

			// -- Copy all the values out
			for xc := (sl+1) to (el-1) do
			begin
				// -- Here is the line
				s := FromMarker.MsgLines.Strings[xc];

				MsgLines.Add(s);
			end;

			CameFromCount := MsgLines.Count;

			// -- We have to copy over the section name
			SectionName := aSection;

			Result := True;

		end
		else begin

//			MessageDlg('Can''t find tag ' + endTag, mtError,[mbok],0);

			Result := False;
		end;

	end;

end;

// ----------------------------------------------------------------------------
function HECMLMarker.RemoveTaggedSection(aSection : string; var LineNo : Integer):Boolean;
var
	aTag : HECMLMarker;
	endTag		: string;
	sl, el, xc  : Integer;
begin
	aTag := HECMLMarker.Create;
	LineNo := -1;

	// -- Load our tag with the correct list of values
	aTag.UseBodyText(MsgLines);

	if aTag.FindTag(aSection) then
	begin

		endTag := '/' + aSection;

		// -- Save the starting line number
		sl := aTag.LineNumber;

		if aTag.FindTag(endTag) then
		begin

			el := aTag.LineNumber;

			// -- Copy all the values out
			for xc := (sl+1) to (el-1) do
			begin
				MsgLines.Delete(sl+1);
			end;

			// -- We have to copy over the section name
			SectionName := aSection;

			// -- Tell the caller the answer
			LineNo := sl;

			Result := True;

		end
		else begin

			// -- Missing end section tag
			MessageDlg('Missing end section tag ' + endTag, mtError,[mbok],0);
			Result := False;

		end;

	end
	else
		Result := False;

	aTag.Destroy;
end;

// ----------------------------------------------------------------------------
{$IFNDEF LINUX}
procedure HECMLMarker.LoadDataLSV(RecordTag, ColumnNames : String; aListView : TListView);
var
	FieldList, aField, aValue, endTag, thisTag	: String;
	ColumnNum	: Integer;
	newItem		: TListItem;
	recMarker	: HECMLMarker;
begin
	recMarker := HECMLMarker.Create;

	// -- Save (push) the current section
	thisTag := SectionName;

	// -- Clear out the list of any existing items
	aListView.Items.BeginUpdate;
	aListView.Items.Clear;

	// -- Now go looking for the records
	while (FindTag(RecordTag)) do
	begin

		recMarker.ExtractTaggedSection(RecordTag,Self);

		// -- Start procoessing
		FieldList := ColumnNames;
		ColumnNum := 0;
		newItem := nil;

		while FieldList <> '' do
		begin

			aField := Parse(FieldList,';,');

			// -- Read the next field out
			if aField <> '' then
			begin
				aValue := recMarker.ReadStringField(aField);
				if ColumnNum = 0 then
				begin
					// -- We need to add the item
					newItem := aListView.Items.Add;

					newItem.Caption := aValue;
				end
				else begin
					// -- It's not the first column so add to subitems
					if Assigned(newItem) then
						newItem.SubItems.Add(aValue);
				end;

				Inc(ColumnNum);
			end;
		end;
	end;

	// -- Restore (pop) the section name
	SectionName := thisTag;

	aListView.Items.EndUpdate;

	recMarker.Destroy;

end;
{$ENDIF}
// ----------------------------------------------------------------------------
procedure HECMLMarker.GotoStart;
begin
	LineNumber := 0;
	ColumnNumber := 0;
	SectionName := '';
	onTag := False;
end;

// ----------------------------------------------------------------------------
procedure HECMLMarker.GotoLine(const l : Integer);
begin
	LineNumber := l;
	ColumnNumber := 0;
	SectionName := '';
	onTag := False;
end;

{$IFDEF WIN32}
{$IFNDEF HW_SIMPLE}
// ----------------------------------------------------------------------------
procedure HECMLMarker.LoadDataCBL(RecordTag, ColumnNames : String; aButtonList : hColorButtonList);
var
	FieldList, aField, aCode, aDesc, aValue, endTag, thisTag	: String;
	ColumnNum	: Integer;
	newItem		: TListItem;
begin
	// -- Save (push) the current section
	thisTag := SectionName;

	// -- Clear out the list of any existing items
	aButtonList.BeginUpdate;
	aButtonList.Clear;

	// -- Now go looking for the records
	while (FindTag(RecordTag)) do
	begin

		// -- Start procoessing
    	FieldList := ColumnNames;
		ColumnNum := 0;
        newItem := nil;

		while FieldList <> '' do
		begin

        	aField := Parse(FieldList,';,');

	    	// -- Read the next field out
            if aField <> '' then
            begin
				aValue := ReadStringField(aField);

				if ColumnNum = 0 then
				begin
					// -- We need to add the item
					aCode := aValue;
				end
				else begin
					// -- It's not the first column so add to subitems
					aDesc := aValue;

					aButtonList.Add(aCode, aDesc);
				end;

				Inc(ColumnNum);
			end;
        end;
    end;

    // -- Restore (pop) the section name
    SectionName := thisTag;
	aButtonList.EndUpdate;

end;
{$ENDIF}
{$ENDIF}
// ----------------------------------------------------------------------------
function Parse(var StringToParse : String; const delims : String):String;
var
	xc,xd : Integer;
	c : Char;
	wasFound : Boolean;
begin

	wasFound := False;
	Result := '';
	xd := Length(StringToParse);

	// -- Process all characters in the string to Parse
	for xc := 1 to xd do
	begin

		// -- Load a character into memory
		c := StringToParse[xc];

		// -- Look for the character in the string
		if (Pos(c,Delims)<>0) then
		begin

			// -- We are finished now
			StringToParse := Copy(StringToParse,xc+1,Length(StringToParse)-xc);

			// -- Indicate that we found our delimeter
			wasFound := True;

			break;
		end
		else
			// -- Add this character into the result
			Result := Result + c;

	end;

	// -- If no delimeter was found then the whole string needs to be returned
	if (not wasFound) then
	begin
		SetLength(StringToParse,0);
	end;

end;

// ----------------------------------------------------------------------------
function EncodeString(StringToEncode : String; EncodeType : Char):String;
var
	xc : Integer;
	c : Char;
begin
	// -- Initialise our result
	Result := '';

	// -- Process every character in the string
	for xc := 1 to Length(StringToEncode) do
	begin
		c := StringToEncode[xc];
		case c of
			'"' : Result := Result + '^"';
			'^' : Result := Result + '^^';
			'/' : Result := Result + '^/';
			#0 	: Result := Result + '^0';
			#1 .. #26:
				  Result := Result + '^' + Chr(Ord('a') + Ord(c) - 1);
		else
			Result := Result + c;
		end;
	end;

	// -- Do some cleanup on the data
	if EncodeType = ECML_STRING_SUFFIX then
		Result := '"' + Result + '"'
	else
		Result := Trim(Result); 

end;

// ----------------------------------------------------------------------------
function DecodeString(StringToEncode : String; EncodeType : Char):String;
var
	xc : Integer;
begin
	Result := '';

	for xc := 1 to Length(StringToEncode) do
	begin

	end;
end;

// ----------------------------------------------------------------------------
procedure HECMLMarker.ReadMultiLineTStrings(FieldName : String; aList : TStrings);
var
	s : String;
begin
	s := ReadStringField(FieldName);
	aList.Clear;
	aList.BeginUpdate;
	while s <> '' do
	begin
		aList.Add(Parse(s,#13));
	end;
	aList.EndUpdate;
end;

// ----------------------------------------------------------------------------
//
//  * This function should replace "GTDBizDoc.ReplaceTaggedSection" 
function GTDBizDoc.ReplaceNode(aNode : GTDNode):Boolean;
begin
    Result := ReplaceTaggedSection(HECMLMarker(aNode));
end;
// ----------------------------------------------------------------------------
function GTDBizDoc.ReplaceTaggedSection(aMarker : HECMLMarker):Boolean;
var
	xc, xd : Integer;
	s : String;
begin

	// -- First delete out all the old lines
	xd := aMarker.CameFromCount;
	for xc := 1 to xd do
		XML.Delete(aMarker.CameFromLine);

	// -- Now add back in the new lines
	xd := aMarker.MsgLines.Count;
	for xc := 1 to xd do
	begin
		// -- We actually need to work backwards
		s := aMarker.MsgLines[aMarker.MsgLines.Count - xc];

		Insert(aMarker.CameFromLine + 1,s);
	end;

end;
// ----------------------------------------------------------------------------
function GTDBizDoc.ReadMultiLineTStrings(Const NodePath, ElementName : String; aList : TStrings):Boolean;
var
	s,l : String;
begin
    // -- Clear the list provided no matter what the outcome
   	aList.Clear;

    // -- Call the standard string reader to lift the value
    if (ReadStringElement(NodePath, ElementName, s)) then
    begin

        // -- Now parse the string into lines and stick into the tlist
    	aList.BeginUpdate;
    	while s <> '' do
    	begin
			// -- Now parse the text
            l := Parse(s,#13 + #10);

            // --
            if (s<>'') and (s[1] = #10) then
                s := Copy(s,2,Length(s)-1);

    		aList.Add(l);
    	end;
    	aList.EndUpdate;

		Result := True;
    end;
end;
// ----------------------------------------------------------------------------
function GTDBizDoc.SetMultiLineTStrings(Const NodePath, ElementName : String; ElementValue : TStrings):Boolean;
var
	s : String;
    xc : Integer;
begin
    // -- Build the new string
    for xc := 1 to ElementValue.Count do
    begin
        // -- Put the value back as a whole line
        s := s + ElementValue.Strings[xc-1] + #13;
    end;

    // -- Write it back to the correct location
	result := SetStringElement(NodePath, ElementName, s);

end;

//******************************************************************
// Encodes a string to its base64 representation in ASCII Format
// returns BASE64_OK if conversion was done without errors
//******************************************************************
function GTDBizDoc.EncodeBase64(InputData: PChar; InputLen: Integer; var OutputString:string):Byte;

    //******************************************************************
    // converts a value in the range of 0..AlphabetLength-1 to the
    // corresponding base64 alphabet representation
    // returns true if the value is in the alphabet range
    //******************************************************************
    function ValueToCharacter(value:Byte;var character:char):boolean;
    begin
     Result:=true;
     if (value>AlphabetLength-1) then Result:=false
                                 else character:=Alphabet[value+1];
    end;

var i:integer;
    currentb,prevb:Byte;
    c:Byte;
	s:char;

begin
	i:=0;
    if (InputLen=0) then
    begin
        Result:=BASE64_OK;
        exit;
	end;

    OutputString := '';

    repeat
        // process first group
        currentb:=ord(InputData[i]);
        i:=i+1;
        InputLen:=InputLen-1;
        c:=(currentb shr 2);
        if not ValueToCharacter(c,s) then
        begin
            Result:=BASE64_ERROR;
            exit;
        end;
        OutputString := OutputString + s;
        prevb:=currentb;

        // process second group
        if InputLen=0 then
			currentb:=0
        else
        begin
			currentb:=ord(InputData[i]);
            i:=i+1;
        end;

        InputLen:=InputLen-1;
		c:=(prevb and $03) shl 4 + (currentb shr 4);
        if not ValueToCharacter(c,s) then
        begin
            Result:=BASE64_ERROR;
            exit;
        end;
        OutputString:=OutputString+s;
        prevb:=currentb;

        // process third group
        if InputLen<0 then
            s:=MimePadChar
        else
        begin
            if InputLen=0 then
                currentb:=0
            else begin
                currentb:=ord(InputData[i]);
                i:=i+1;
            end;
			InputLen:=InputLen-1;
            c:=(prevb and $0F) shl 2 + (currentb shr 6);
            if not ValueToCharacter(c,s) then
			begin
                Result:=BASE64_ERROR;
                exit;
            end;
        end;

        OutputString:=OutputString+s;

        // process fourth group
        if InputLen<0 then
            s:=MimePadChar
        else begin
            c:=(currentb and $3F);
            if not ValueToCharacter(c,s) then
            begin
                Result:=BASE64_ERROR;
                exit;
            end;
        end;
        OutputString:=OutputString+s;

    until InputLen<=0;

    result:=BASE64_OK;
end;

//******************************************************************
// Decodes a base64 representation in ASCII format into a string
// returns BASE64_OK if conversion was done without errors
//******************************************************************
{$IFDEF WIN32}
function GTDBizDoc.DecodeBase64(InputString :String; OutputData: PChar; var bytesOutput: Integer; filterdecodeinput : Boolean):Byte;
var
    mimeStr : TStringFormat_MIME64;

    s : String;
    b : Integer;
begin
    mimeStr := TStringFormat_MIME64.Create;

    s := mimeStr.ToStr(Pchar(InputString),Length(InputString));
    b := Length(s);

    bytesOutput := b;

    // -- Move the data over
    Move(Pchar(s)^, OutputData^, bytesOutput);

    mimeStr.Destroy;

end;
// ----------------------------------------------------------------------------
function GTDBizDoc.LoadImageAsBase64(Const SourceFileName : String):Boolean;
const
    LineReadSize = 45;
var
	CurLine     : String;
    BlockCount,
    BlockMod    : Integer;
    EncodedLine : String;
    FileBuffer,FilePtr  : PChar;
    fHandle         : THandle;
    xc,xd, fSize    : Integer;
    bytesread       : DWORD;
    MemBuffer       : HGLOBAL;
begin
    Result := False;

	// -- Check that the input file exists
    if not FileExists(SourceFileName) then
        Exit;

    // -- Initialise
//  Clear;
    fBody.Add('====begin-base64 644 ' + ExtractFileName(SourceFileName));

	// -- Open the file
    fHandle := CreateFile(PChar(SourceFileName),
                             GENERIC_READ,
                             FILE_SHARE_READ,
                             nil,
                             OPEN_EXISTING,
                             FILE_FLAG_SEQUENTIAL_SCAN,0);

	// -- If it doesn't work then return
    if fHandle = 0 then
        Exit;

    // -- Determine the size of the file
    fSize := GetFileSize(fHandle,nil);

    // -- Allocate a nice piece of virtual memory for the operation
    MemBuffer := GlobalAlloc(GMEM_FIXED,fsize);
    FileBuffer := GlobalLock(MemBuffer);

    if Assigned(FileBuffer) then
	begin
        // -- Read the file
        ReadFile(fHandle,FileBuffer^,fSize,bytesread,nil);
        if bytesread = fSize then
        begin

            // -- Now process the data
            FilePtr := FileBuffer;
			BlockCount := fSize div LineReadSize;
            BlockMod   := fSize mod LineReadSize;
            for xc := 1 to BlockCount do
            begin

                // -- Process a line at a time
                EncodeBase64(FilePtr,LineReadSize,EncodedLine);
                Inc(FilePtr,LineReadSize);

                fBody.Add(EncodedLine);

            end;

            // -- Process the remainder
            EncodeBase64(FilePtr,BlockMod,EncodedLine);
            fBody.Add(EncodedLine);

            fbody.Add('====end==========================================');

            // -- Free the memory that we have used
			GlobalUnLock(MemBuffer);
            GlobalFree(MemBuffer);

            // -- Remember that we have changed the body
            fBody_Chg := True;

            Result := True;
        end;
	end;

    // -- Close the handle to the file
    CloseHandle(fHandle);

end;
{$ENDIF}

// ----------------------------------------------------------------------------
// -- Checks a message and determines at what line the body part is
function GTDBizDoc.CheckForFileInBody(const FileName : String):Integer;
var
    xc : Integer;
    CurLine,mimepartname : String;

begin
    Result := -1;

    // -- Scan through all the lines
    for xc := 1 to XML.Count do
    begin

        // -- Load up the current line
        CurLine := fBody.Strings[xc-1];

        // -- Check if we have
        if (Length(CurLine)>0) and (CurLine[1] = '=')
            and (CompareStr(Copy(CurLine, 1, 21), '====begin-base64 644 ') = 0) then
        begin

            mimepartname := Copy(CurLine,22,Length(CurLine)-21);

            if CompareStr(mimepartname,FileName) = 0 then
            begin
                // -- We have finished
                Result := xc;
				break;
            end;
        end;

    end;

end;

// ----------------------------------------------------------------------------
function GTDBizDoc.UpdateCurrentDocStatus(Returned_DocInfo : HECMLMarker; needToReverse : Boolean):Boolean;
begin
    // -- Try to read out the document number
    if (not needToReverse) then
		Local_Doc_ID := Returned_DocInfo.ReadIntegerField(GTD_DB_DOC_DOC_ID,-1)
    else
        Remote_Doc_ID := Returned_DocInfo.ReadIntegerField(GTD_DB_DOC_DOC_ID,-1);

    // -- This will do a conversion on the messageids
    { Msg_ID := RemoteToLocalMsgID(Returned_DocInfo.ReadStringField(GTD_DB_DOC_MSGID)); }

    // -- If we received a docuument then we need to decode this stuff
	if (fOwned_By <> 0) or (fOwned_By <> -1) then
    begin
        // -- Decode all these values
        Document_Ref            := Returned_DocInfo.ReadStringField(GTD_DB_DOC_REFERENCE);
        Document_Type           := Returned_DocInfo.ReadStringField(GTD_DB_DOC_TYPE);
		Document_Total          := Returned_DocInfo.ReadNumberField(GTD_DB_DOC_TOTAL,0);
		Tax_Total               := Returned_DocInfo.ReadNumberField(GTD_DB_DOC_TOTAL_TAX,0);
		System_Name             := Returned_DocInfo.ReadStringField(GTD_DB_DOC_SYSTEM);
	end;

    if needToReverse then
    begin
        // -- Flip the statuses around
        Remote_Status_Code      := Returned_DocInfo.ReadStringField(GTD_DB_DOC_LOCSTAT);
        Remote_Status_Comments  := Returned_DocInfo.ReadStringField(GTD_DB_DOC_LOCCMTS);
		Local_Status_Code       := GTD_AUDITCD_RCV;
        Local_Status_Comments   := '';
    end
    else begin
        // -- Update the status codes
        Local_Status_Code       := Returned_DocInfo.ReadStringField(GTD_DB_DOC_LOCSTAT);
		Local_Status_Comments   := Returned_DocInfo.ReadStringField(GTD_DB_DOC_LOCCMTS);
        Remote_Status_Code      := Returned_DocInfo.ReadStringField(GTD_DB_DOC_REMSTAT);
        Remote_Status_Comments  := Returned_DocInfo.ReadStringField(GTD_DB_DOC_REMCMTS);
    end;

end;

// ----------------------------------------------------------------------------
{$IFDEF WIN32}
function GTDBizDoc.BuildPatch(InputList : TStrings; PatchOutput : TStrings; DiffType : gtDiffType):Boolean;
var
    optIgnoreCase,optIgnoreBlanks : Boolean;
    HashList1,HashList2: TList;
    Lines1, Lines2     : TStrings;
	i: integer;
    optionsStr: string;
    Diff : TDiff;

    procedure OutputDiffs(Const OutFormat:Char);
    var
        xc,xd,xe,
        clines : Integer;
        CompactOutput : Boolean;
    begin
        if (OutFormat = 'C') then
        begin
            // -- Compact format has no context
            CompactOutput := True;
            clines := 0;
		end
        else begin
            // -- Unified format has 3 context lines
            CompactOutput := False;
            clines := 3;
        end;

        // -- Process all the changes
		for xc := 1 to Diff.ChangeCount do
        begin
            with Diff.Changes[xc-1] do
            begin
                case Kind of
					ckAdd    : begin
                                PatchOutput.Add('@@ -' + IntToStr(x) + ',' + IntToStr((clines*2)) +
                                                  ' +' + IntToStr(y) + ',' + IntToStr((clines*2)+Range) + ' @@');
                                // -- Context (but must be enough lines at start)
                                for xe := 1 to clines do
                                    if ((y+xe-clines-1) >= 0) then
                                        PatchOutput.Add(' ' + Lines2[y+xe-clines-1]);

                                // -- The lines that are to be inserted
                                for xd := 1 to Range do
                                    PatchOutput.Add('+' + Lines2[y+xd-1]);

                                // -- Context (but must be enough lines after
                                for xe := 1 to clines do
                                    if ((y+xe+Range-1) < Lines2.Count) then
                                        PatchOutput.Add(' ' + Lines2[y+xe+Range-1]);

							   end;
                    ckDelete : begin
								PatchOutput.Add('@@ -' + IntToStr(x-clines+1) + ', +' + IntToStr(y) + ' @@');
                                // -- Context
                                for xe := 1 to clines do
                                    PatchOutput.Add(' ' + Lines1[x+xe-clines-1]);

                                // -- The lines to be deleted
								for xd := 1 to Range do
                                    PatchOutput.Add('-' + Lines1[x+xd-1]);

                                // -- Context
                                for xe := 1 to clines do
									PatchOutput.Add(' ' + Lines1[x+xe+Range-1]);

                               end;
                    ckModify : begin
                                PatchOutput.Add('@@ -' + IntToStr(x-clines+1) + ',' + IntToStr((clines * 2) + 1) +
                                                  ' +' + IntToStr(y-clines+1) + ',' + IntToStr((clines * 2) + 1) + ' @@');
                                // -- Context
                                for xe := 1 to clines do
                                    if ((x+xe-clines-1) >= 0) then
                                        PatchOutput.Add(' ' + Lines1[x+xe-clines-1]);

                                if not CompactOutput then
                                begin
                                    PatchOutput.Add('-' + Lines1[x]);
                                    PatchOutput.Add('+' + Lines2[y]);
                                end
								else
                                    PatchOutput.Add('#' + Lines2[y]);

                                // -- Context
                                for xe := 1 to clines do
								begin
                                    xd := y+xe;
                                    if (xd < Lines2.Count) then
										PatchOutput.Add(' ' + Lines2[xd]);
                                end;
                               end;
                end;

			end;
        end;
    end;

begin
    Result := False;

    // -- Set these defaults
    optIgnoreCase   := False;
    optIgnoreBlanks := False;

    // -- Use Lines1 and Lines2 to make it easier
    Lines1 := InputList;
    Lines2 := XML;

    // -- This function will build a patch

    Diff := TDiff.create(self);
//  Diff.OnProgress := DiffProgress;
    HashList1 := TList.create;
    HashList2 := TList.create;

    try
    //  Create the hash lists used to compare line differences.
    //  nb - there is a small possibility of different lines hashing to the
    //  same value. However the probability of an invalid match occuring
    //  in proximity to its invalid partner is remote. Ideally, these hash
    //  collisions should be managed by ? incrementing the hash value.
    HashList1.capacity := Lines1.Count;
    HashList2.capacity := Lines2.Count;
    for i := 0 to Lines1.Count-1 do
        HashList1.add(HashLine(Lines1[i],optIgnoreCase,optIgnoreBlanks));
    for i := 0 to Lines2.Count-1 do
        HashList2.add(HashLine(Lines2[i],optIgnoreCase,optIgnoreBlanks));

    // -- CALCULATE THE DIFFS HERE ...
    if Diff.Execute(DiffUnit.PIntArray(HashList1.List),DiffUnit.PIntArray(HashList2.List),HashList1.count, HashList2.count) then
    begin

        if Diff.ChangeCount <> 0 then
        begin

            if (DiffType = dtUnified) then
                OutputDiffs('U')
            else
                OutputDiffs('C');

            // -- Yes there was some difference in the files
            Result := True;
        end
        else
            // -- No there was no differences
            Result := False;
    end;

	finally
      HashList1.Free;
      HashList2.Free;
      Diff.Free;
    end;

end;
// ----------------------------------------------------------------------------
function GTDBizDoc.ApplyPatch(PatchData : TStrings):Boolean;
begin
    // -- This function will apply a patch
end;
{$ENDIF}

// =============================================================================
// GTDNode
// =============================================================================

// ----------------------------------------------------------------------------
// - Load a node from an existing document
function GTDNode.LoadFromDocument(SourceDoc : GTDBizDoc; NodePath : String; LockSection : Boolean):Boolean;
var
    s,d,np,nnp : String;
    xc,xd : Integer;
	MarkA : HECMLMarker;
    usingIndexing,tagFound : Boolean;
begin
    Result := False;

    // --
    if (SourceDoc.GetNestCount(NodePath) = 1) then
    begin
        if (NodePath[1]='/') then
			s := Copy(NodePath,2,Length(NodePath)-1)
        else
            s := NodePath;

            MarkA := HECMLMarker.Create;

            MarkA.UseBodyText(SourceDoc.XML);

			// -- This is the simplest case
			Result := ExtractTaggedSection(s, MarkA);

			MarkA.Destroy;

	end
	else begin

		np := SourceDoc.NormalisedNodeName(NodePath);

        usingIndexing := False;

        if not usingIndexing then
        begin
            MarkA := HECMLMarker.Create;
			MarkA.UseBodyText(SourceDoc.XML);
            tagFound := True;

            // -- This is an experimental technique
            for xc := 1 to SourceDoc.GetNestCount(NodePath) do
			begin
                // --
                nnp := SourceDoc.NodeOfLevel(np,xc);

                if SourceDoc.GetNodeIndex(nnp) = 1 then
                begin
                    if MarkA.FindTagRegion(nnp) then
                    begin
                        tagFound := True;
                        continue;
                    end
                    else begin
                        tagFound := False;
                        break;
                    end;
				end
                else begin
                    s := SourceDoc.NodeNameWithoutLastIndex(nnp);

                    for xd := 1 to (SourceDoc.GetNodeIndex(nnp)) do
                    begin
                        if MarkA.FindTag(s,MarkA.RegionEndLine) then
                        begin
							tagFound := True;
                            continue;
                        end
                        else begin
                            tagFound := False;
							break;
                        end;
                    end;
                end;
            end;

            if tagFound then
            begin

                // -- Calculate the default position for new elements
                defaultElementCol := SourceDoc.GetNestCount(NodePath) * TabCharCount;

                s := SourceDoc.NodeNameWithoutLastIndex(nnp);
                Result := ExtractTaggedSection(s, MarkA);
            end;

            MarkA.Destroy;
        end
        else begin
            // -- To find our node, we are going to look through the definition
            for xc := 1 to SourceDoc.Definition.Count do
            begin
                // --
				d := SourceDoc.NormalisedNodeName(SourceDoc.Definition.Strings[xc-1]);
                if d = np then
                begin
                    // -- Now read the data
                    S := SourceDoc.NodeNameWithoutLastIndex(SourceDoc.LastNodeName(d));

                    MarkA := HECMLMarker.Create;

                    MarkA.UseBodyText(SourceDoc.XML);
                    MarkA.GotoLine(SourceDoc.ReadDefinitionLineNumber(xc)-1);

                    // -- This is the simplest case
                    Result := ExtractTaggedSection(s, MarkA);

                    MarkA.Destroy;

                    Result := True;
                    break;
                end;
            end;
		end;
	end;

end;

// ----------------------------------------------------------------------------
function EncodeStringField(ElementName, s : String):String;
begin
    Result := ElementName + ECML_STRING_SUFFIX + '=' + EncodeString(s,ECML_STRING_SUFFIX) + ' ';
end;
// ----------------------------------------------------------------------------
function EncodeCurrencyField(ElementName : String; CurrencyValue : Currency):String;
begin
    Result := ElementName + ECML_CURRENCY_SUFFIX + '=' + FloatToStr(CurrencyValue) + ' ';
end;
// ----------------------------------------------------------------------------
function EncodeBooleanField(ElementName : String; v : Boolean):String;
begin
    if v then
        Result := ElementName + ECML_BOOLEAN_SUFFIX + '=True '
    else
        Result := ElementName + ECML_BOOLEAN_SUFFIX + '=False '
end;
// ----------------------------------------------------------------------------
function EncodeIntegerField(ElementName : String; i : Integer):String;
var
    s : String;
begin
    // -- Convert our number to a string
	s := IntToStr(i);

    // -- Now pop it into a field
    Result := ElementName + ECML_NUMBER_SUFFIX + '=' + EncodeString(s,ECML_NUMBER_SUFFIX) + ' ';
end;
// ----------------------------------------------------------------------------
function EncodeDateTimeField(ElementName : String; aTime : TDateTime):String;
var
    {$IFDEF WIN32}
    tz : _TIME_ZONE_INFORMATION;
    {$ENDIF}
    bias : Integer;
    bh,bm : Integer;
	bs    : String;
begin
    if aTime = 0 then
        Exit;

    {$IFDEF WIN32}
    // -- Retrieve the timezone information
    if GetTimeZoneInformation(tz) <> -1 then
    begin
        // -- Format this bias into something we can use
        bias := tz.Bias;
        bh := bias div 60;
        bm := bias mod 60;
        bs := Format('%.2d:%.2d',[bh,bm]);
    end
    else
        bs := '+00:00';
	{$ELSE}
        bs := '+00:00';
    {$ENDIF}

    // -- If we have a time component
    if Round(aTime) <> aTime then
        // -- We do have a time component
		Result := ElementName + ECML_DATE_SUFFIX + '="' + FormatDateTime('YYYY-MM-DD',aTime) + 'T' + FormatDateTime('HH:NN:SS',aTime) + ' ' + bs + '" '
	else
		// -- Only a date
		Result := ElementName + ECML_DATE_SUFFIX + '="' + FormatDateTime(GTD_DATESTAMPFORMAT,aTime) + '" '

end;
// ----------------------------------------------------------------------------
constructor GTDDocumentRegistry.Create(AOwner: TComponent);
var
	dbDir,dbName : String;
	i : Integer;
begin
	inherited Create(AOwner);

	{$IFDEF LIGHTWEIGHT}
		fStorage := GTDBizDoc.Create(Self);
        {$IFNDEF LINUX}
		fDocumentRegPath := GetActiveDocumentDir + pathslash + DocumentRegName;
        {$ENDIF}
	{$ELSE}
		fDocTbl     := TTable.Create(Self);
		fTraderTbl  := TTable.Create(Self);
		fAuditTbl   := TTable.Create(Self);
		fSysValTbl	:= TTable.Create(Self);
		fKeyTbl     := TTable.Create(Self);

		// -- Determine the database
		fDatabaseName := '';

		// -- Check that the database driver is BDE
		GetRegistryString(gtKeyPath + GTD_REG_NOD_GENERAL,GTD_REG_DATABASE_DRIVER,dbName);
		if dbName = 'BDE' then
		begin

			// -- Check the command line
			dbName := '';
			for i := 1 to ParamCount do
			begin
				if copy(ParamStr(i),1,11)='/BDE_ALIAS=' then
				begin
					dbName := copy(ParamStr(i),11+1,Length(ParamStr(i))-11);
				end
			end;

			if dbName <> '' then
			begin
				// -- Use the database provided
				fDatabaseName := dbName;
			end
			else begin

				// -- First read out the location of the database files
				if GetRegistryString(gtKeyPath + GTD_REG_NOD_GENERAL,GTD_REG_BDE_DIRECTORY,dbDir) then
				begin
					// -- MessageDlg('DBDIR='+dbDir,mtError,[mbok],0);//*****

					if DirectoryExists(dbDir) then
						fDatabaseName := dbDir;
				end
				else if GetRegistryString(gtKeyPath + GTD_REG_NOD_GENERAL,GTD_REG_BDE_ALIAS,dbName) then
				begin
					fDatabaseName := dbName;
				end;

			end;
		end
		else begin
			// -- Looking in the registry failed
			fDatabaseName := GTD_ALIAS;
		end;

		// -- Setup some simple information
		fSessionName := 'Default';

		// -- Now we will change GTD_ALIAS
		GTD_ALIAS := fDatabaseName;

		if fSessionName <> '' then
		begin
			fDocTbl.SessionName   := fSessionName;
			fTraderTbl.SessionName:= fSessionName;
			fAuditTbl.SessionName := fSessionName;
			fSysValTbl.SessionName:= fSessionName;
			fKeyTbl.SessionName   := fSessionName;
		end;

		fDocTbl.DatabaseName      := fDatabaseName;
		fTraderTbl.DatabaseName   := fDatabaseName;
		fAuditTbl.DatabaseName    := fDatabaseName;
		fSysValTbl.DatabaseName   := fDatabaseName;
		fKeyTbl.DatabaseName      := fDatabaseName;

		fDocTbl.TableName         := 'Trader_Documents';
		fTraderTbl.TableName      := 'Trader';
		fAuditTbl.TableName       := 'Trader_AuditTrail';
		fSysValTbl.TableName      := 'SysVals';
		fKeyTbl.TableName         := 'Trader_Keys';

		fSysValTbl.IndexFieldNames:= 'SECTION;KEYNAME';
	{$ENDIF}

	// -- Cipher managers
        {$IFDEF WIN32}
	CipherManager := TCipherManager.Create(Self);
	HashManager := THashManager.Create(Self);
	CipherManager.HashManager := HashManager;
        {$ENDIF}

end;

destructor GTDDocumentRegistry.Destroy;
begin
	// -- Close encryption capabilities
		{$IFDEF WIN32}
	CipherManager.Destroy;
	HashManager.Destroy;
		{$ENDIF}

	{$IFDEF LIGHTWEIGHT}
		fStorage.Destroy;
	{$ELSE}
		// -- Force the BDE to write these changes
		DbiSaveChanges(fDocTbl.Handle);
		fDocTbl.Destroy;

		// -- Force the BDE to write these changes
		DbiSaveChanges(fTraderTbl.Handle);
		fTraderTbl.Destroy;

		// -- Force the BDE to write these changes
		DbiSaveChanges(fAuditTbl.Handle);
		fAuditTbl.Destroy;

		DbiSaveChanges(fSysValTbl.Handle);
		fSysValTbl.Destroy;
	{$ENDIF}

	inherited Destroy;
end;

{$IFNDEF LIGHTWEIGHT}
procedure GTDDocumentRegistry.SetDatabaseName(NewDBName : String);
begin
	fDatabaseName := NewDBName;

	fDocTbl.DatabaseName      := fDatabaseName;
	fTraderTbl.DatabaseName   := fDatabaseName;
	fAuditTbl.DatabaseName    := fDatabaseName;
	fSysValTbl.DatabaseName   := fDatabaseName;
	fKeyTbl.DatabaseName      := fDatabaseName;
end;
{$ENDIF}

// ----------------------------------------------------------------------------
function GTDDocumentRegistry.GetLatestStatement(var Statement : GTDBizDoc):Boolean;
{$IFNDEF LIGHTWEIGHT}
var
	qryFindPriceList : TQuery;
	aMemo : TMemoField;
begin
	// -- Clear out the old pricelist
	Statement.Clear;

	// -- Setup the Database information
	qryFindPriceList := TQuery.Create(Self);
	qryFindPriceList.DatabaseName := fDatabaseName;
	qryFindPriceList.SessionName  := fSessionName;

	with qryFindPriceList do
	begin
		// -- Build the SQL
		SQL.Add('select');
		SQL.Add('	Document_ID, Document_Date, Document_Reference, MIME_TEXT');
		SQL.Add('from');
		SQL.Add('	Trader_Documents');
		SQL.Add('where');
		SQL.Add('	((System_Name = "STANDARD") and (Document_Name = "Statement")');
		SQL.Add('	and (Shared_with = 0) and (Owned_By = ' + IntToStr(fRemoteTraderID) + ')');
		SQL.Add('	and (Local_Status_Code <> "Inactive"))');
		SQL.Add(' or');
		SQL.Add('	((System_Name = "STANDARD") and (Document_Name = "Statement")');
		SQL.Add('	and (Shared_with = ' + IntToStr(fRemoteTraderID) + ') and (Owned_By = 0)');
		SQL.Add('	and (Local_Status_Code <> "Inactive"))');
		SQL.Add('order by');
		SQL.Add('   ' + GTD_DB_DOC_DATE + ' desc');

        Active := True;

        First;
        if not Eof then
		begin

            // -- Find the field
            aMemo := TMemoField(FieldByName(GTD_BodyFieldname));

            Statement.Clear;

			// -- Load the contents
            Statement.XML.Assign(aMemo);

            // -- We assume that it worked
            Result := True;
        end
        else
            // -- Do something - but what ?
			Result := False;

        Destroy;
	end;
{$ELSE}
var
    s : String;
begin
	{$IFDEF WIN32}
	s := GetLatestStatementFileName;
	// -- Try again now
	if (s <> '') then
	begin
		// -- Now that we have the most recent, load it
		Statement.LoadFromFile(s);
		fPricelistDateTime := FileDateToDateTime(FileAge(s));
	end;
	{$ENDIF}
{$ENDIF}
end;
// ----------------------------------------------------------------------------
function GTDDocumentRegistry.GetGTL:String;
var
	s : String;
begin
	if GetSettingString(GTD_REG_NOD_GENERAL,GTD_REG_GTL,s) then
		Result := s
    else
        Result := '<None>';
end;
// ----------------------------------------------------------------------------
function GTDDocumentRegistry.GetCompanyName:String;
var
	s : String;
begin
	if GetSettingString(GTD_REG_NOD_GENERAL,GTD_REG_COMPANY_NAME,s) then
		Result := s;
end;
// ----------------------------------------------------------------------------
function GTDDocumentRegistry.GetAddress1:String;
var
	s : String;
begin
	if GetSettingString(GTD_REG_NOD_GENERAL,GTD_REG_ADDRESS_LINE_1,s) then
		Result := s;
end;
// ----------------------------------------------------------------------------
function GTDDocumentRegistry.GetAddress2:String;
var
	s : String;
begin
	if GetSettingString(GTD_REG_NOD_GENERAL,GTD_REG_ADDRESS_LINE_2,s) then
		Result := s;
end;
// ----------------------------------------------------------------------------
function GTDDocumentRegistry.GetCity:String;
var
	s : String;
begin
	if GetSettingString(GTD_REG_NOD_GENERAL,GTD_REG_TOWN,s) then
		Result := s;
end;
// ----------------------------------------------------------------------------
function GTDDocumentRegistry.GetState:String;
var
	s : String;
begin
	if GetSettingString(GTD_REG_NOD_GENERAL,GTD_REG_STATE_REGION,s) then
		Result := s;
end;
// ----------------------------------------------------------------------------
function GTDDocumentRegistry.GetPostcode:String;
var
	s : String;
begin
	if GetSettingString(GTD_REG_NOD_GENERAL,GTD_REG_POSTALCODE,s) then
		Result := s;
end;
// ----------------------------------------------------------------------------
function GTDDocumentRegistry.GetCountryCode:String;
var
	s : String;
begin
	if GetSettingString(GTD_REG_NOD_GENERAL,GTD_REG_COUNTRYCODE,s) then
		Result := s;
end;
// ----------------------------------------------------------------------------
procedure GTDDocumentRegistry.BuildSingleAddressLine(var Line : String);
var
    cc : String;
begin
    cc := Self.GetCountryCode;
    if (cc = 'DE') then
    begin
        Line := GetAddress1 + ', ';
        if GetAddress2 <> '' then
            Line := Line + GetAddress2 + ', ';
        if GetCity <> '' then
            Line := Line + GetCity + ', ';
        if GetPostcode <> '' then
            Line := Line + GetPostcode;
        // if GetState <> '' then
        //    Line := Line + GetState + ', ';
    end
    else if (cc = 'FR') then
    begin
        Line := GetAddress1 + ', ';
        if GetAddress2 <> '' then
            Line := Line + GetAddress2 + ', ';
        if GetCity <> '' then
            Line := Line + GetCity + ', ';
        if GetPostcode <> '' then
            Line := Line + GetPostcode;
    end
    else begin
        // -- All other countries
        Line := GetAddress1 + ', ';
        if GetAddress2 <> '' then
            Line := Line + GetAddress2 + ', ';
        if GetCity <> '' then
            Line := Line + GetCity + ', ';
        if GetState <> '' then
            Line := Line + GetState + ', ';
        if GetPostcode <> '' then
            Line := Line + GetPostcode;

    end;
end;
// ----------------------------------------------------------------------------
procedure GTDDocumentRegistry.BuildDoubleAddressLine(var Line1 : String; var Line2 : String);
begin
end;
// ----------------------------------------------------------------------------
function GTDDocumentRegistry.GetLatestPriceList(var PriceList : GTDBizDoc):Boolean;
var
	qryFindPriceList : TQuery;

	aMemo : TMemoField;
begin
	// -- Clear out the old pricelist
	PriceList.Clear;

	// -- Setup the Database information
	qryFindPriceList := TQuery.Create(Self);
	qryFindPriceList.DatabaseName := fDatabaseName;
	qryFindPriceList.SessionName  := fSessionName;

	try
		with qryFindPriceList do
		begin
			// -- Build the SQL
			SQL.Add('select');
			SQL.Add('	' + GTD_DB_DOC_DOC_ID + ', ' + GTD_DB_DOC_DATE);
			SQL.Add('from');
			SQL.Add('	Trader_Documents');
			SQL.Add('where');
			SQL.Add('	((System_Name = "STANDARD") and (Document_Name = "' + GTD_PRICELIST_TYPE + '")');
			SQL.Add('	and (Shared_with = 0) and (Owned_By = ' + IntToStr(fRemoteTraderID) + ')');
			SQL.Add('	and (Local_Status_Code <> "Inactive"))');
			SQL.Add('	or');
			SQL.Add('	((System_Name = "STANDARD") and (Document_Name = "' + GTD_PRICELIST_TYPE + '")');
			SQL.Add('	and (Shared_with = ' + IntToStr(fRemoteTraderID) + ') and (Owned_By = 0)');
			SQL.Add('	and (Local_Status_Code <> "Inactive"))');

			Active := True;

			First;
			if not Eof then
			begin

				Result := Load(FieldByName(GTD_DB_DOC_DOC_ID).AsInteger,PriceList);

				// -- Store the time
				fPricelistDateTime := FieldByName(GTD_DB_DOC_DATE).AsFloat;

				// -- Store the document number
				fPricelistDocNum := FieldByName(GTD_DB_DOC_DOC_ID).AsInteger;

				// -- We assume that it worked
				Result := True;
			end
			else
				// -- Do something - but what ?
				;

		end;
	finally
		qryFindPriceList.Destroy;
	end;
end;

//---------------------------------------------------------------------------
// -- We need this function as the directory FindFirst isn't visible from
//    within the GTDDocumentRegistry as there is a clash with the TTABLE.FindFirst
//---------------------------------------------------------------------------
function FileCtrl_FindFirst(const Path: string; Attr: Integer; var F: TSearchRec): Integer;
begin
    Result := FindFirst(Path, Attr, F);
end;
//---------------------------------------------------------------------------
function FileCtrl_FindNext(var F: TSearchRec): Integer;
begin
	Result := FindNext(F);
end;
// ----------------------------------------------------------------------------
function GTDDocumentRegistry.SaveAsLatestPriceList(PriceList : GTDBizDoc; PriceListDateTime : TDateTime; var LogText : String; Validate : Boolean):Boolean;
var
    PurgeThem : Boolean;
    s : String;
    rc,dno : Integer;
    lastPricelist : GTDBizDoc;
    PriceDiffs : TStringList;

    aMemo 	: TMemoField;

	// -- Updates details on the trader record
    procedure UpdateTraderDetails;
    var
        TraderDetailsChanged : String;
    begin
		with fTraderTbl do
        begin
            // -- Open the table
			if not Active then
			begin
				UpdateMode := upwhereKeyOnly;
				IndexFieldNames := 'Trader_ID';
				Active := True;
			end;

            // --
            if FieldByName(GTD_DB_COL_TRADER_ID).AsInteger <> fRemoteTraderID then
                FindKey([fRemoteTraderID]);

            // -- Start updating fields in the table that have changed
            TraderDetailsChanged := '';
			Edit;

            // -- Check if any fields need to be updated
            if FieldByName(GTD_DB_COL_COMPANY_NAME).AsString <> PriceList.GetStringElement(GTD_PL_VENDORINFO_NODE,GTD_PL_ELE_COMPANY_NAME) then
            begin
                // -- Update the field
                FieldByName(GTD_DB_COL_COMPANY_NAME).AsString := PriceList.GetStringElement(GTD_PL_VENDORINFO_NODE,GTD_PL_ELE_COMPANY_NAME);
				TraderDetailsChanged := TraderDetailsChanged + GTD_DB_COL_COMPANY_NAME + ' updated.' + #13;
            end;

            if FieldByName(GTD_DB_COL_ADDRESS_LINE_1).AsString <> PriceList.GetStringElement(GTD_PL_VENDORINFO_NODE,GTD_PL_ELE_ADDRESS_LINE_1) then
            begin
                // -- Update the field
                FieldByName(GTD_DB_COL_ADDRESS_LINE_1).AsString := PriceList.GetStringElement(GTD_PL_VENDORINFO_NODE,GTD_PL_ELE_ADDRESS_LINE_1);
                TraderDetailsChanged := TraderDetailsChanged + GTD_DB_COL_ADDRESS_LINE_1 + ' updated.' + #13;
            end;

            if FieldByName(GTD_DB_COL_ADDRESS_LINE_2).AsString <> PriceList.GetStringElement(GTD_PL_VENDORINFO_NODE,GTD_PL_ELE_ADDRESS_LINE_2) then
			begin
                // -- Update the field
				FieldByName(GTD_DB_COL_ADDRESS_LINE_2).AsString := PriceList.GetStringElement(GTD_PL_VENDORINFO_NODE,GTD_PL_ELE_ADDRESS_LINE_2);
                TraderDetailsChanged := TraderDetailsChanged + GTD_DB_COL_ADDRESS_LINE_2 + ' updated.' + #13;
            end;

            if FieldByName(GTD_DB_COL_TOWN).AsString <> PriceList.GetStringElement(GTD_PL_VENDORINFO_NODE,GTD_PL_ELE_TOWN) then
            begin
                // -- Update the field
                FieldByName(GTD_DB_COL_TOWN).AsString := PriceList.GetStringElement(GTD_PL_VENDORINFO_NODE,GTD_PL_ELE_TOWN);
				TraderDetailsChanged := TraderDetailsChanged + GTD_DB_COL_TOWN + ' updated.' + #13;
            end;

            if FieldByName(GTD_DB_COL_POSTALCODE).AsString <> PriceList.GetStringElement(GTD_PL_VENDORINFO_NODE,GTD_PL_ELE_POSTALCODE) then
            begin
                // -- Update the field
				FieldByName(GTD_DB_COL_POSTALCODE).AsString := PriceList.GetStringElement(GTD_PL_VENDORINFO_NODE,GTD_PL_ELE_POSTALCODE);
                TraderDetailsChanged := TraderDetailsChanged + GTD_DB_COL_POSTALCODE + ' updated.' + #13;
            end;

            if FieldByName(GTD_DB_COL_STATE_REGION).AsString <> PriceList.GetStringElement(GTD_PL_VENDORINFO_NODE,GTD_PL_ELE_STATE_REGION) then
            begin
                // -- Update the field
                FieldByName(GTD_DB_COL_STATE_REGION).AsString := PriceList.GetStringElement(GTD_PL_VENDORINFO_NODE,GTD_PL_ELE_STATE_REGION);
                TraderDetailsChanged := TraderDetailsChanged + GTD_DB_COL_STATE_REGION + ' updated.' + #13;
            end;

			if FieldByName(GTD_DB_COL_COUNTRYCODE).AsString <> PriceList.GetStringElement(GTD_PL_VENDORINFO_NODE,GTD_PL_ELE_COUNTRYCODE) then
            begin
                // -- Update the field
				FieldByName(GTD_DB_COL_COUNTRYCODE).AsString := PriceList.GetStringElement(GTD_PL_VENDORINFO_NODE,GTD_PL_ELE_COUNTRYCODE);
                TraderDetailsChanged := TraderDetailsChanged + GTD_DB_COL_COUNTRYCODE + ' updated.' + #13;
            end;

            if FieldByName(GTD_DB_COL_TELEPHONE).AsString <> PriceList.GetStringElement(GTD_PL_VENDORINFO_NODE,GTD_PL_ELE_TELEPHONE) then
            begin
                // -- Update the field
                FieldByName(GTD_DB_COL_TELEPHONE).AsString := PriceList.GetStringElement(GTD_PL_VENDORINFO_NODE,GTD_PL_ELE_TELEPHONE);
				TraderDetailsChanged := TraderDetailsChanged + GTD_DB_COL_TELEPHONE + ' updated.' + #13;
            end;

            if FieldByName(GTD_DB_COL_TELEPHONE2).AsString <> PriceList.GetStringElement(GTD_PL_VENDORINFO_NODE,GTD_PL_ELE_FAX) then
            begin
				// -- Update the field
                FieldByName(GTD_DB_COL_TELEPHONE2).AsString := PriceList.GetStringElement(GTD_PL_VENDORINFO_NODE,GTD_PL_ELE_FAX);
                TraderDetailsChanged := TraderDetailsChanged + GTD_DB_COL_TELEPHONE2 + ' updated.' + #13;
            end;

            if FieldByName(GTD_DB_COL_LATTITUDE).AsString <> PriceList.GetStringElement(GTD_PL_VENDORINFO_NODE,GTD_PL_ELE_LATTITUDE) then
            begin
                // -- Update the field
                FieldByName(GTD_DB_COL_LATTITUDE).AsString := PriceList.GetStringElement(GTD_PL_VENDORINFO_NODE,GTD_PL_ELE_LATTITUDE);
                TraderDetailsChanged := TraderDetailsChanged + GTD_DB_COL_LATTITUDE + ' updated.' + #13;
            end;

            if FieldByName(GTD_DB_COL_LONGITUDE).AsString <> PriceList.GetStringElement(GTD_PL_VENDORINFO_NODE,GTD_PL_ELE_LONGITUDE) then
            begin
                // -- Update the field
				FieldByName(GTD_DB_COL_LONGITUDE).AsString := PriceList.GetStringElement(GTD_PL_VENDORINFO_NODE,GTD_PL_ELE_LONGITUDE);
                TraderDetailsChanged := TraderDetailsChanged + GTD_DB_COL_LONGITUDE + ' updated.' + #13;
            end;

            if TraderDetailsChanged = '' then
                // Cancel the edits
                Cancel
            else begin
				// -- Post the edits
                Post;
                DbiSaveChanges(fTraderTbl.Handle);
            end;

            LogText := LogText + TraderDetailsChanged;
        end;
    end;

    {$IFDEF WIN32}
    procedure PurgeOldPricelists;
    var
        qryPurgeOldPricelists : TQuery;
    begin

		// -- Delete out any old catalogs
        qryPurgeOldPricelists := TQuery.Create(Self);

        // -- Setup the Database information
        qryPurgeOldPricelists.DatabaseName := fDatabaseName;
		qryPurgeOldPricelists.SessionName  := fSessionName;

        // FileSetDate(
        with qryPurgeOldPricelists do
        begin
            PurgeThem := True;

            if PurgeThem then
			begin
                SQL.Add('delete from Trader_Documents');
                SQL.Add('where');
				SQL.Add(' ((Owned_By=' + IntToStr(fRemoteTraderID) + ')');
                SQL.Add('  and (Shared_With=0))');
                SQL.Add(' or ');
				SQL.Add(' ((Owned_By=0)');
                SQL.Add('  and (Shared_With=' + IntToStr(fRemoteTraderID) + '))');
                SQL.Add(' and (Document_Name="' + GTD_PRICELIST_TYPE + '")');
                ExecSQL;
            end
            else begin
                SQL.Add('update Trader_Documents');
                SQL.Add('set Local_Status_Code = "Inactive"');
                SQL.Add('where');
                SQL.Add(' (Owned_By=' + IntToStr(fRemoteTraderID) + ')');
                SQL.Add(' and (Shared_With=0)');
				SQL.Add(' and (Document_Name="' + GTD_PRICELIST_TYPE + '")');

                ExecSQL;
            end;
        end;

		// -- Force the BDE to write these changes
        DbiSaveChanges(qryPurgeOldPricelists.Handle);

        // -- Now destroy the object
        qryPurgeOldPricelists.Destroy;
    end;

    procedure UpdateTraderCategories(CategoryCodes : String);
	var
        s,tc,qry, insertCodes, DeleteCodes : String;
		havesome : Boolean;
        qryTraderCategories : TQuery;
    begin

        qryTraderCategories := TQuery.Create(Self);

        try

            qryTraderCategories.DatabaseName := fDatabaseName;
            qryTraderCategories.SessionName  := fSessionName;

			with qryTraderCategories do
            begin


                // -- Lazilly Delete everything
                SQL.Add('delete from Trader_Categories');
                SQL.Add('where Trader_ID = ' + IntToStr(fRemoteTraderID));

                ExecSQL;

                if CategoryCodes <> '' then
                begin

                    // -- Add all the known category codes
                    s := CategoryCodes;
					while s <> '' do
					begin
                        tc := Parse(s,';');
                        if tc <> '' then
                        begin
                            // -- Add all the category codes back in
                            SQL.Clear;
                            SQL.Add('insert into Trader_Categories');
                            SQL.Add('	(trader_id, Category_Code)');
                            SQL.Add('values');

                            SQL.Add('  	(' + IntToStr(fRemoteTraderID) + ',"' + tc + '")');

                            // -- Now do it
                            ExecSQL;
                        end;
                    end;

                end;

			end;

        finally
            qryTraderCategories.Destroy;
        end;

    end;
    {$ENDIF}

begin
    Result := False;
    LogText := '';

    if Validate then
    begin
        // -- Validate the pricelist
        if not ValidatePricelist(Pricelist,'',LogText) then
        begin
            // -- We don't save pricelists that don't validate
            Exit;
        end;
    end;

	// -- Now kill all old catalogs for this company
    {$IFDEF WIN32}
        // -- Main database update section is here

        // -- Create the Trader if it doesn't exist
		if (fRemoteTraderID = 0) or (fRemoteTraderID = -1) then
		begin
			// -- Check the trader doesn't already exist
			if not OpenFor(Pricelist.GetStringElement(GTD_PL_VENDORINFO_NODE,GTD_PL_ELE_COMPANY_CODE)) then
			begin
				// -- Create the trader
				if not CreateFor(Pricelist.GetStringElement(GTD_PL_VENDORINFO_NODE,GTD_PL_ELE_COMPANY_CODE),
								 Pricelist.GetStringElement(GTD_PL_VENDORINFO_NODE,GTD_PL_ELE_COMPANY_NAME),
								 GTD_TRADER_RLTNSHP_SUPPLIER, GTD_TRADER_STATUS_ACTIVE) then
				begin
					LogText := 'Unable to create Trader ' + Pricelist.GetStringElement(GTD_PL_VENDORINFO_NODE,GTD_PL_ELE_COMPANY_NAME) + #13;
					Exit;
				end
				else
					// -- We created the trader
					LogText := LogText + 'Created Supplier ' + Pricelist.GetStringElement(GTD_PL_VENDORINFO_NODE,GTD_PL_ELE_COMPANY_NAME) + #13;

			end
			else
				// -- We are updating
				LogText := LogText + 'Updating ' + Pricelist.GetStringElement(GTD_PL_VENDORINFO_NODE,GTD_PL_ELE_COMPANY_NAME) + #13;

			fTraderName := Pricelist.GetStringElement(GTD_PL_VENDORINFO_NODE,GTD_PL_ELE_COMPANY_NAME);

		end;

        // -- If the table isn't open it then we better do so
        if not fDocTbl.Active then
        begin
            fDocTbl.DatabaseName := DatabaseName;
            fDocTbl.SessionName  := SessionName;
            fDocTbl.Active := true;
		end;

        // -- Look up the last pricelist and save a patch for it
        lastPricelist := GTDBizDoc.Create(Self);

        if GetLatestPriceList(lastPricelist) then
        begin

            PriceDiffs := TStringList.Create;

            // -- Build a diff for it
            if fDoingPricelistPatches then
            begin
                lastPriceList.XML.SaveToFile('old.txt');
                Pricelist.XML.SaveToFile('new.txt');

                if (Pricelist.BuildPatch(lastPriceList.XML,PriceDiffs,dtUnified)) then
                begin

                    PriceDiffs.SaveToFile('diffs.txt');

                    // -- This saves the pricelist into the document table
                    with fDocTbl do
                    begin

                        // -- Write to the database
                        aMemo := TMemoField(FieldByName(GTD_BodyFieldname));

                        Append;
                        FieldByName(GTD_DB_DOC_OWNER).AsInteger := fRemoteTraderID;
                        FieldByName(GTD_DB_DOC_USER).AsInteger := 0;
                        FieldByName(GTD_DB_DOC_TYPE).AsString := GTD_PL_UPDATE_PATCH;
                        FieldByName(GTD_DB_DOC_REFERENCE).AsString := 'Pricelist update ' + FormatDateTime('c',Date);
                        FieldByName(GTD_DB_DOC_SYSTEM).AsString := 'STANDARD';
                        FieldByName(GTD_DB_DOC_DATE).AsFloat := PriceListDateTime;
                        FieldByName(GTD_DB_DOC_UPDATEFLAG).AsString := '=';
                        FieldByName(GTD_DB_DOC_LOCSTAT).AsString := 'Generated';
                        FieldByName(GTD_DB_DOC_REMSTAT).AsString := 'Sent';

                        // -- Write the memo
                        aMemo.Assign(PriceDiffs);

                        Post;

                        LogText := LogText + 'Pricelist updated.' + #13;
                    end;
                end;
            end;

            PriceDiffs.Destroy;

        end;
        lastPricelist.Destroy;

   		PurgeOldPricelists;

        // -- This saves the pricelist into the document table
        with fDocTbl do
        begin

            // -- Write to the database
            aMemo := TMemoField(FieldByName(GTD_BodyFieldname));

            Append;
            if (Pricelist.Owned_By = 0) and (Pricelist.Shared_With <> 0) then
            begin
                FieldByName(GTD_DB_DOC_OWNER).AsInteger := 0;
                FieldByName(GTD_DB_DOC_USER).AsInteger := fRemoteTraderID;
            end
            else begin
                FieldByName(GTD_DB_DOC_OWNER).AsInteger := fRemoteTraderID;
                FieldByName(GTD_DB_DOC_USER).AsInteger := 0;
            end;
            FieldByName(GTD_DB_DOC_TYPE).AsString := GTD_PRICELIST_TYPE;
            FieldByName(GTD_DB_DOC_REFERENCE).AsString := 'Pricelist stored ' + FormatDateTime('c',Date);
            FieldByName(GTD_DB_DOC_SYSTEM).AsString := 'STANDARD';
            FieldByName(GTD_DB_DOC_DATE).AsFloat := PriceListDateTime;
			FieldByName(GTD_DB_DOC_UPDATEFLAG).AsString := '=';
            FieldByName(GTD_DB_DOC_LOCSTAT).AsString := 'Current';
            FieldByName(GTD_DB_DOC_REMSTAT).AsString := 'Sent';

			// -- Write the memo
            aMemo.Assign(PriceList.XML);

            Post;

            LogText := LogText + 'Pricelist saved.' + #13;
        end;

        // -- Now we have to possibly update all the trader details with those
        //    found in the catalog
        if (Pricelist.Owned_By <> 0) then
        begin
            // -- Update the database from the pricelist details
            UpdateTraderDetails;

            UpdateTraderCategories(Pricelist.GetStringElement(GTD_PL_VENDORINFO_NODE,GTD_PL_ELE_SELL_CATEGORIES));
        end;
		// -- Finally, update the categories with those found in the pricelist

    {$ENDIF} // Windows
    Result := True;

end;
//---------------------------------------------------------------------------
{$IFDEF WIN32}
function GTDDocumentRegistry.LoadRegistrationInfo(RegistrationText : TStringList):Boolean;
var
	myMemo : TMemoField;
begin
	Result := False;

	{$IFNDEF LIGHTWEIGHT}
	with fSysValTbl do
	begin

		// -- Table may not be open
		if not Active then
			Active := True;

		// -- Load up the license information
		if FindKey([SYSVAL_LICENSE_SECTION,SYSVAL_LICENSE_KEYNAME]) then
		begin
			// -- Load the text from the list
			myMemo := TMemoField(FieldByName('KEYTEXT'));
			RegistrationText.Assign(myMemo);

			Result := True;
		end;

	end;
	{$ENDIF}
end;
{$ENDIF}
//---------------------------------------------------------------------------
{$IFDEF WIN32}
function GTDDocumentRegistry.AddRegistrationInfo(RegistrationText : TStringList):Boolean;
var
	myMemo : TMemoField;
	sl : TStringList;
	xc : Integer;
begin
	Result := False;

	{$IFNDEF LIGHTWEIGHT}
	with fSysValTbl do
	begin

		// -- Table may not be open
		if not Active then
			Active := True;


		// -- Load up the license information
		if FindKey([SYSVAL_LICENSE_SECTION,SYSVAL_LICENSE_KEYNAME]) then
		begin
			// -- Load the text from the list
			myMemo := TMemoField(FieldByName('KEYTEXT'));

			// -- Go into edit mode
			Edit;

			sl := TStringList.Create;
			sl.Assign(myMemo);

			// -- Append everything that we have into the list
			for xc := 1 to RegistrationText.Count do
			begin
				sl.Add(RegistrationText.Strings[xc-1]);
			end;

			// -- Write the value back to the field
			myMemo.Assign(sl);

			// -- Destroy before doing a post
			sl.Destroy;

			// -- Update the record
			Post;

			Result := True;
		end;

	end;
	{$ENDIF}

end;
{$ENDIF}
//---------------------------------------------------------------------------
{$IFDEF WIN32}
function GTDDocumentRegistry.DecodeRegistrationInfo(RegistrationText : TStringList):Boolean;
var
	e : String;
	xc : Integer;
begin
	Result := False;

	// -- Check that there is an encryption key
	if GetMachineName = '' then
		Exit;

	// -- Set the algorithm and initialise the key
        {$IFDEF WIN32}
	fCipherManager.Algorithm := 'Twofish';
	fCipherManager.InitKey(GetMachineName,nil);

	// -- Correct the lengths of every string to the same thing
	for xc := 1 to RegistrationText.Count do
	begin
		e := RegistrationText.Strings[xc-1];
		e := fCipherManager.DecodeString(e);
		RegistrationText.Strings[xc-1] := e;
	end;

	// -- Scan through the text and see if we can find something
	for xc := 1 to RegistrationText.Count do
	begin
		if Pos(KEYTEXT_ELEM_ORGNAME,RegistrationText.Strings[xc-1]) <> 0 then
		begin
			Result := True;
			break;
		end;
	end;
        {$ENDIF}

end;
{$ENDIF}
//---------------------------------------------------------------------------
{$IFDEF WIN32}
procedure GTDDocumentRegistry.BuildRegistrationInfo(OrgGTL,
                                                    OrgName,
											        state_code,
													country_code,
													MachineNames,
													os_name : String;
													Expiry_Date : TDateTime;
													CodedRegistration : TStringList);
var
	RegistrationText : TStringList;
	M,ML,e : String;
	xc : Integer;
begin
	// --
	ML := MachineNames;

	// --
	RegistrationText := TStringList.Create;

	{$IFDEF WIN32}
        fCipherManager.Algorithm := 'Twofish';
        {$ENDIF}

	// -- dummy header data
	RegistrationText.Add('fd sadf adf dcvx sdcvx sdew dfg cxvb sgfhs');
	RegistrationText.Add('sgfhs fd adf dcvx sdew dfg cxvb sdcvx sadf');
	RegistrationText.Add('sdew adf dcvx fd sadf sdcvx cxvb sgfhs dfg ');
	RegistrationText.Add('1fd 1sadf 1adf 1dcvx 1sdcvx 1sdew 1dfg 1cxvb');
	RegistrationText.Add('2sgfhs 2fd 2adf 2dcvx 2sdew 2dfg 2cxvb 2sdcvx');
	RegistrationText.Add('3sdew 3adf 3dcvx 3fd 3sadf 3sdcvx 3cxvb 3sgfhs');

	// -- this is the real data
	RegistrationText.Add(EncodeStringField(KEYTEXT_ELEM_GTL,OrgGTL));
	RegistrationText.Add(EncodeStringField(KEYTEXT_ELEM_ORGNAME,OrgName));
	RegistrationText.Add(EncodeStringField(KEYTEXT_ELEM_REGION,state_code));
	RegistrationText.Add(EncodeStringField(KEYTEXT_ELEM_COUNTRY,country_code));
	RegistrationText.Add(EncodeStringField(KEYTEXT_ELEM_MACHINE,MachineNames));
	RegistrationText.Add(EncodeStringField(KEYTEXT_ELEM_OS_NAME,os_name));
	RegistrationText.Add(EncodeDateTimeField(KEYTEXT_ELEM_EXP_DATE,Expiry_Date));

	// -- dummy trailer data
	RegistrationText.Add('3sdew 3adf 3dcvx 3fd 3sadf 3sdcvx 3cxvb 3sgfhs');
	RegistrationText.Add('2sgfhs 2fd 2adf 2dcvx 2sdew 2dfg 2cxvb 2sdcvx');
	RegistrationText.Add('1fd 1sadf 1adf 1dcvx 1sdcvx 1sdew 1dfg 1cxvb');
	RegistrationText.Add('sdew adf dcvx fd sadf sdcvx cxvb sgfhs dfg ');
	RegistrationText.Add('fd sadf adf dcvx sdcvx sdew dfg cxvb sgfhs');

	// -- Correct the lengths of every string to the same thing
	for xc := 1 to RegistrationText.Count do
	begin
		e := RegistrationText.Strings[xc-1];
		SetLength(e,70);
		RegistrationText.Strings[xc-1] := e;
	end;

	// --
        {$IFDEF WIN32}
	m := Parse(ML,';');
	while m <> '' do
	begin
		fCipherManager.InitKey(m,nil);

		// -- Pick
		for xc := 1 to RegistrationText.Count do
		begin
			// -- Get the next line and encrypt it
			e := fCipherManager.EncodeString(RegistrationText.Strings[xc-1]);

			// -- Add this to the list
			CodedRegistration.Add(e);
		end;

		// -- Read the next machine name
		m := Parse(ML,';');

	end;
        {$ENDIF}
	RegistrationText.Destroy;

end;
{$ENDIF}
//---------------------------------------------------------------------------
//
// Synopsis : Adds Vendor information to a pricelist from the registry
//
function GTDDocumentRegistry.AddStandardVendorInfo(aDoc : GTDBizDoc):Boolean;
begin
    aDoc.SetStringElement(GTD_PL_VENDORINFO_NODE,GTD_PL_ELE_COMPANY_CODE,GetGTL);
	aDoc.SetStringElement(GTD_PL_VENDORINFO_NODE,GTD_PL_ELE_COMPANY_NAME,GetCompanyName);
    aDoc.SetStringElement(GTD_PL_VENDORINFO_NODE,GTD_PL_ELE_ADDRESS_LINE_1,GetAddress1);
    aDoc.SetStringElement(GTD_PL_VENDORINFO_NODE,GTD_PL_ELE_ADDRESS_LINE_2,GetAddress2);
    aDoc.SetStringElement(GTD_PL_VENDORINFO_NODE,GTD_PL_ELE_TOWN,GetCity);
	aDoc.SetStringElement(GTD_PL_VENDORINFO_NODE,GTD_PL_ELE_POSTALCODE,GetPostcode);
    aDoc.SetStringElement(GTD_PL_VENDORINFO_NODE,GTD_PL_ELE_STATE_REGION,GetState);
    aDoc.SetStringElement(GTD_PL_VENDORINFO_NODE,GTD_PL_ELE_COUNTRYCODE,GetCountryCode);
end;
//---------------------------------------------------------------------------
// Synopsis : Adds <Vendor information> to a pricelist from the current trader
//
function GTDDocumentRegistry.AddCurrentTraderVendorInfo(aDoc : GTDBizDoc):Boolean;
begin
    aDoc.SetStringElement(GTD_PL_VENDORINFO_NODE,GTD_PL_ELE_COMPANY_CODE,fTraderTbl.FieldByName(GTD_DB_COL_COMPANY_CODE).AsString);
	aDoc.SetStringElement(GTD_PL_VENDORINFO_NODE,GTD_PL_ELE_COMPANY_NAME,fTraderTbl.FieldByName(GTD_DB_COL_COMPANY_NAME).AsString);
    aDoc.SetStringElement(GTD_PL_VENDORINFO_NODE,GTD_PL_ELE_ADDRESS_LINE_1,fTraderTbl.FieldByName(GTD_DB_COL_ADDRESS_LINE_1).AsString);
    aDoc.SetStringElement(GTD_PL_VENDORINFO_NODE,GTD_PL_ELE_ADDRESS_LINE_2,fTraderTbl.FieldByName(GTD_DB_COL_ADDRESS_LINE_2).AsString);
    aDoc.SetStringElement(GTD_PL_VENDORINFO_NODE,GTD_PL_ELE_TOWN,fTraderTbl.FieldByName(GTD_DB_COL_TOWN).AsString);
	aDoc.SetStringElement(GTD_PL_VENDORINFO_NODE,GTD_PL_ELE_POSTALCODE,fTraderTbl.FieldByName(GTD_DB_COL_POSTALCODE).AsString);
    aDoc.SetStringElement(GTD_PL_VENDORINFO_NODE,GTD_PL_ELE_STATE_REGION,fTraderTbl.FieldByName(GTD_DB_COL_STATE_REGION).AsString);
    aDoc.SetStringElement(GTD_PL_VENDORINFO_NODE,GTD_PL_ELE_COUNTRYCODE,fTraderTbl.FieldByName(GTD_DB_COL_COUNTRYCODE).AsString);
end;
//---------------------------------------------------------------------------
function GTDDocumentRegistry.ValidatePurchaseOrder(aDoc : GTDBizDoc; Options : String; var Log : String):Boolean;
begin
end;
//---------------------------------------------------------------------------
function GTDDocumentRegistry.ValidateInvoice(aDoc : GTDBizDoc; Options : String; var Log : String):Boolean;
begin
end;
//---------------------------------------------------------------------------
function GTDDocumentRegistry.ValidateStatement(aDoc : GTDBizDoc; Options : String; var Log : String):Boolean;
begin
end;
//---------------------------------------------------------------------------
function GTDDocumentRegistry.ValidatePaymentAdvice(aDoc : GTDBizDoc; Options : String; var Log : String):Boolean;
begin
end;
//---------------------------------------------------------------------------
function GTDDocumentRegistry.ValidatePriceList(aDoc : GTDBizDoc; Options : String; var Log : String):Boolean;
var
    t_Ref,
    t_Name,
    t_Street_Address_1,
    t_Street_Address_2,
    t_City_Town,
    t_Postcode_ZIP,
    t_State_Province,
    t_Country,
    t_Phone,
    t_Fax,
    problist : String;
begin
    // -- Validate the vendor information section
    if aDoc.NodeExists(GTD_PL_VENDORINFO_NODE) then
    begin
        // -- Find our how many levels in our catalog
        t_Ref				:= aDoc.GetStringElement(GTD_PL_VENDORINFO_NODE,GTD_PL_ELE_COMPANY_CODE);
		t_Name 				:= aDoc.GetStringElement(GTD_PL_VENDORINFO_NODE,GTD_PL_ELE_COMPANY_NAME);
        t_Street_Address_1	:= aDoc.GetStringElement(GTD_PL_VENDORINFO_NODE,GTD_PL_ELE_ADDRESS_LINE_1);
        t_Street_Address_2	:= aDoc.GetStringElement(GTD_PL_VENDORINFO_NODE,GTD_PL_ELE_ADDRESS_LINE_2);
        t_City_Town			:= aDoc.GetStringElement(GTD_PL_VENDORINFO_NODE,GTD_PL_ELE_TOWN);
		t_Postcode_ZIP		:= aDoc.GetStringElement(GTD_PL_VENDORINFO_NODE,GTD_PL_ELE_POSTALCODE);
        t_State_Province	:= aDoc.GetStringElement(GTD_PL_VENDORINFO_NODE,GTD_PL_ELE_STATE_REGION);
        t_Country			:= aDoc.GetStringElement(GTD_PL_VENDORINFO_NODE,GTD_PL_ELE_COUNTRYCODE);
        t_Phone				:= aDoc.GetStringElement(GTD_PL_VENDORINFO_NODE,GTD_PL_ELE_TELEPHONE);
		t_Fax				:= aDoc.GetStringElement(GTD_PL_VENDORINFO_NODE,GTD_PL_ELE_FAX);

        // -- Validate
        if t_Ref = '' then
        begin
            problist := problist + 'Missing Trader PreisShare_ID (' + GTD_PL_VENDORINFO_NODE + '/' + GTD_PL_ELE_COMPANY_CODE + ')' + #13;
        end
        else if t_Name = '' then
        begin
            problist := problist + 'Missing Trader Name (' + GTD_PL_VENDORINFO_NODE + '/' + GTD_PL_ELE_COMPANY_NAME + ')' + #13;
        end
        else
            Result := True;

    end
    else begin
        problist := problist + 'Document is Missing (' + GTD_PL_VENDORINFO_NODE + ')' + #13;
    end;

    // -- Display the dialog box
	if problist <> '' then
        MessageDlg(problist,mtError,[mbOk],0);
end;
//---------------------------------------------------------------------------
{$IFDEF LIGHTWEIGHT}
{$IFNDEF LINUX}
function GTDDocumentRegistry.GetTradalogDir:String;
begin
    if fTradalogDir = '' then
		Result := ExtractFilePath(Application.Exename)
    else
        Result := fTradalogDir;
end;
{$ENDIF}
{$ENDIF}
//---------------------------------------------------------------------------
{$IFDEF LIGHTWEIGHT}
{$IFNDEF LINUX}
function GTDDocumentRegistry.GetReceivedDocDir:String;
begin
    if fDocumentDir = '' then
    begin
        fDocumentDir := GetSoftwareInstallDir;

        // -- Remove the last \
        if Length(fDocumentDir) > 0 then
            if fDocumentDir[Length(fDocumentDir)] = pathslash then
                fDocumentDir := Copy(fDocumentDir,2,Length(fDocumentDir)-1);

        if fDocumentDir <> '' then
            Result := fDocumentDir + GTD_DR_RECVD_DOCS_SUBDIR;

    end
	else
        Result := fDocumentDir + GTD_DR_RECVD_DOCS_SUBDIR;
end;
{$ENDIF}
{$ENDIF}
//---------------------------------------------------------------------------
{$IFDEF LIGHTWEIGHT}
{$IFDEF WIN32}
function GTDDocumentRegistry.GetActiveDocumentDir:String;
begin
    if fDocumentDir = '' then
    begin
		fDocumentDir := GetSoftwareInstallDir;

        // -- Remove the last \
        if Length(fDocumentDir) > 0 then
            if fDocumentDir[Length(fDocumentDir)] = pathslash then
                fDocumentDir := Copy(fDocumentDir,2,Length(fDocumentDir)-1);

        if fDocumentDir <> '' then
            Result := fDocumentDir + GTD_DR_ACTIVE_DOCS_SUBDIR;

    end
    else
        Result := fDocumentDir + GTD_DR_ACTIVE_DOCS_SUBDIR;
end;
{$ENDIF}
{$ENDIF}
//---------------------------------------------------------------------------
{$IFNDEF LINUX}
{$IFDEF LIGHTWEIGHT}
Procedure GTDDocumentRegistry.SetTradalogDir(newDir :String);
begin
	fTradalogDir := newDir;
		// -- Set this value also
		fDocumentRegPath := GetActiveDocumentDir + pathslash + DocumentRegName;
end;
{$ENDIF}
//---------------------------------------------------------------------------
function GTDDocumentRegistry.GetOurImageDir:String;
begin
	Result := ExtractFilePath(Application.ExeName) + GTD_DR_OUR_IMAGES_SUBDIR;
end;
//---------------------------------------------------------------------------
function GTDDocumentRegistry.GetDownloadImageDir:String;
var
    aBuff   : Array [1..200] of char;
begin
    {$IFNDEF LIGHTWEIGHT}
    // -- Use the download directory for the Desktop version
    Result := ExtractFilePath(Application.ExeName) + GTD_DR_DOWNLOAD_IMAGES_SUBDIR;
    {$ELSE}
    // -- Use the windows temporary directory
    {$IFDEF WIN32}
    if (GetTempPath(sizeof(aBuff),@aBuff) = 0) then
        // -- Isn't this bad !
        Result := 'c:\'
    else
        Result := StrPas(@aBuff);
    {$ENDIF}
    {$ENDIF}
end;
{$ENDIF}
//---------------------------------------------------------------------------
function GTDDocumentRegistry.GetSettingString(SectionName,ElementName : String; var ValueStr : String):Boolean;
begin
	Result := False;

	// -- Open the configuration table if nessessary
	if not fSysValTbl.Active then
	begin
		fSysValTbl.DatabaseName := DatabaseName;
		fSysValTbl.SessionName  := SessionName;
	end;

	with fSysValTbl do
	begin
		// -- Open the table if it's closed
		if not Active then Active := true;

		// -- Lookup the value in the database
		if FindKey([SectionName,ElementName]) then
		begin
			ValueStr := FieldByName('KEYVALUE').AsString;
			Result := True;
		end;
	end;
end;
//---------------------------------------------------------------------------
function GTDDocumentRegistry.GetSettingInt(SectionName,ElementName : String; var ValueInt : Integer):Boolean;
begin
	Result := False;

	// -- Open the configuration table if nessessary
	{$IFNDEF LIGHTWEIGHT}
	if not fSysValTbl.Active then
	begin
		fSysValTbl.DatabaseName := DatabaseName;
		fSysValTbl.SessionName  := SessionName;
	end;

	with fSysValTbl do
	begin
		// -- Open the table if it's closed
		if not Active then Active := true;

		// -- Lookup the value in the database
		if FindKey([SectionName,ElementName]) then
		begin
			ValueInt := Round(StringToFloat(FieldByName('KEYVALUE').AsString));
			Result := True;
		end;
	end;
	{$ENDIF}
end;
//---------------------------------------------------------------------------
function GTDDocumentRegistry.GetNextSettingInt(SectionName,ElementName : String; var ValueInt : Integer):Boolean;
begin
	{$IFNDEF LIGHTWEIGHT}
	if not GetSettingInt(SectionName,ElementName,ValueInt) then
	begin
		with fSysValTbl do
		begin
			Append;
			FieldByName('SECTION').AsString := SectionName;
			FieldByName('KEYNAME').AsString := ElementName;
			FieldByName('KEYVALUE').AsString := IntToStr(ValueInt);
			Post;
		end;
		Result := True;
	end
	else begin
		with fSysValTbl do
		begin
			Edit;
			FieldByName('KEYVALUE').AsInteger := Round(StringToFloat(FieldByName('KEYVALUE').AsString) + 1);
			Post;

			ValueInt := Round(StringToFloat(FieldByName('KEYVALUE').AsString));
		end;
		Result := True;
	end;
        {$ENDIF}
end;
//---------------------------------------------------------------------------
function GTDDocumentRegistry.SaveSettingString(SectionName,ElementName : String; ValueStr : String):Boolean;
var
	oldVal : String;
begin
	{$IFNDEF LIGHTWEIGHT}
	if GetSettingString(SectionName,ElementName,oldVal) then
	begin
		with fSysValTbl do
		begin
			Edit;
			FieldByName('KEYVALUE').AsString := ValueStr;
			Post;
		end;

		DbiSaveChanges(fSysValTbl.Handle);
		Result := True;
	end
	else begin
		with fSysValTbl do
		begin
			Append;
			FieldByName('SECTION').AsString := SectionName;
			FieldByName('KEYNAME').AsString := ElementName;
			FieldByName('KEYVALUE').AsString := ValueStr;
			Post;
		end;
		Result := True;
	end;
		{$ENDIF}
end;
//---------------------------------------------------------------------------
function GTDDocumentRegistry.SaveSettingInt(SectionName,ElementName : String; ValueInt : Integer):Boolean;
begin
	{$IFNDEF LIGHTWEIGHT}
	if not GetSettingInt(SectionName,ElementName,ValueInt) then
	begin
		with fSysValTbl do
		begin
			Append;
			FieldByName('SECTION').AsString := SectionName;
			FieldByName('KEYNAME').AsString := ElementName;
			FieldByName('KEYVALUE').AsString := IntToStr(ValueInt);
			Post;
		end;
		Result := True;
	end
	else begin
		with fSysValTbl do
		begin
			Edit;
			FieldByName('KEYVALUE').AsInteger := ValueInt;
			Post;
		end;
		Result := True;
	end;
        {$ENDIF}
end;
//---------------------------------------------------------------------------
function GTDDocumentRegistry.DeleteSettingRecord(SectionName,ElementName : String):Boolean;
var
    s : String;
begin
    Result := False;
    if not GetSettingString(SectionName,ElementName,s) then
        Exit;

    // -- The record is in memory, we can delete it
	fSysValTbl.Delete;

    Result := True;
end;
//---------------------------------------------------------------------------
function GTDDocumentRegistry.RenameSettingRecord(SectionName,ElementName,NewElementName : String):Boolean;
var
    s : String;
begin
    Result := False;
    if not GetSettingString(SectionName,ElementName,s) then
        Exit;

    // -- The record is in memory, we can delete it
	with fSysValTbl do
    begin
        Edit;
        FieldByName('KEYNAME').AsString := NewElementName;
        Post;
    end;

    Result := True;
end;
//---------------------------------------------------------------------------
function GTDDocumentRegistry.GetSettingMemoString(NodePath, ElementName : String; var ValueStr : String):Boolean;
var
    tempDoc : GTDBizDoc;
begin
	Result := False;

	// -- This function only works when the table is open
	if not fSysValTbl.Active then
	begin
        Exit;
	end;

    tempDoc := GTDBizDoc.Create(Self);

    //	myMemo := TMemoField(FieldByName('KEYTEXT'));
    tempDoc.XML.Assign(TMemoField(fSysValTbl.FieldByName('KEYTEXT')));

    Result := tempDoc.ReadStringElement(NodePath, ElementName, ValueStr);

    tempDoc.Destroy;

end;
//---------------------------------------------------------------------------
function GTDDocumentRegistry.GetSettingMemoInt(NodePath, ElementName : String; var ValueInt : Integer):Boolean;
var
    tempDoc : GTDBizDoc;
begin
	Result := False;

	// -- This function only works when the table is open
	if not fSysValTbl.Active then
	begin
        Exit;
	end;

    tempDoc := GTDBizDoc.Create(Self);

    //	myMemo := TMemoField(FieldByName('KEYTEXT'));
    tempDoc.XML.Assign(TMemoField(fSysValTbl.FieldByName('KEYTEXT')));

    Result := tempDoc.ReadIntegerElement(NodePath, ElementName, ValueInt);

    tempDoc.Destroy;

end;
//---------------------------------------------------------------------------
function GTDDocumentRegistry.GetSettingMemoBoolean(NodePath, ElementName : String; var Value : Boolean):Boolean;
begin
end;
//---------------------------------------------------------------------------
function GTDDocumentRegistry.SaveSettingMemoString(NodePath, ElementName, ValueStr : String; FinalSave : Boolean):Boolean;
var
    tempDoc : GTDBizDoc;
begin
	Result := False;

	// -- This function only works when the table is open
	if not fSysValTbl.Active then
	begin
        Exit;
	end;

    // -- Put the record into Edit mode
	if not (fSysValTbl.State in [dsEdit]) then
    begin
        fSysValTbl.Edit;
    end;
    tempDoc := GTDBizDoc.Create(Self);

    // -- Read the whole memo into memory
    tempDoc.XML.Assign(TMemoField(fSysValTbl.FieldByName('KEYTEXT')));

    // -- Change the required element
    Result := tempDoc.SetStringElement(NodePath, ElementName, ValueStr);

    // -- Write the whole thing back
    TMemoField(fSysValTbl.FieldByName('KEYTEXT')).Assign(tempDoc.XML);

    tempDoc.Destroy;

    // -- If the record must be saved then do so
    if FinalSave then
        fSysValTbl.Post;

end;
//---------------------------------------------------------------------------
function GTDDocumentRegistry.SaveSettingMemoInt(NodePath, ElementName : String; ValueInt : Integer; FinalSave : Boolean):Boolean;
var
    tempDoc : GTDBizDoc;
begin
	Result := False;

	// -- This function only works when the table is open
	if not fSysValTbl.Active then
	begin
        Exit;
	end;

    // -- Put the record into Edit mode
	if not (fSysValTbl.State in [dsEdit]) then
    begin
        fSysValTbl.Edit;
    end;
    tempDoc := GTDBizDoc.Create(Self);

    // -- Read the whole memo into memory
    tempDoc.XML.Assign(TMemoField(fSysValTbl.FieldByName('KEYTEXT')));

    // -- Change the required element
    Result := tempDoc.SetIntegerElement(NodePath, ElementName, ValueInt);

    // -- Write the whole thing back
    TMemoField(fSysValTbl.FieldByName('KEYTEXT')).Assign(tempDoc.XML);

    tempDoc.Destroy;

    // -- If the record must be saved then do so
    if FinalSave then
        fSysValTbl.Post;

end;
//---------------------------------------------------------------------------
//
// -- This function retrieves a list of named records for a configuration
//    into a stringlist
function GTDDocumentRegistry.GetSettingItemList(SectionName : String; ElementNames : TStrings):Boolean;
var
    aQry : TQuery;
begin
    aQry := TQuery.Create(Self);
    try
        ElementNames.Clear;

        with aQry do
        begin
            DatabaseName := fDatabaseName;
            SQL.Add('Select KeyName from SysVals where (Section = "' + SectionName + '")');
			Active := True;

            // -- Cycle through the records and read out all the values
            First;
            while not Eof do
            begin
                ElementNames.Add(FieldByName('KEYNAME').AsString);
                Next;
            end;
        end;

    finally
        aQry.Destroy;
    end;
    Result := False;
end;
//---------------------------------------------------------------------------
function GTDDocumentRegistry.GetTraderSettingString(NodePath, ElementName : String; var ValueStr : String):Boolean;
var
    tempDoc : GTDBizDoc;
begin
	Result := False;

	// -- This function only works when the table is open
	if not fTraderTbl.Active then
	begin
        Exit;
	end;

    tempDoc := GTDBizDoc.Create(Self);

    //	myMemo := TMemoField(FieldByName('SETTINGS'));
    tempDoc.XML.Assign(TMemoField(fTraderTbl.FieldByName('SETTINGS')));

    Result := tempDoc.ReadStringElement(NodePath, ElementName, ValueStr);

    tempDoc.Destroy;

end;
//---------------------------------------------------------------------------
function GTDDocumentRegistry.GetTraderSettingInt(NodePath, ElementName : String; var ValueInt : Integer):Boolean;
var
    tempDoc : GTDBizDoc;
begin
	Result := False;

	// -- This function only works when the table is open
	if not fTraderTbl.Active then
	begin
        Exit;
	end;

    tempDoc := GTDBizDoc.Create(Self);

    //	myMemo := TMemoField(FieldByName('SETTINGS'));
    tempDoc.XML.Assign(TMemoField(fTraderTbl.FieldByName('SETTINGS')));

    Result := tempDoc.ReadIntegerElement(NodePath, ElementName, ValueInt);

    tempDoc.Destroy;

end;
//---------------------------------------------------------------------------
function GTDDocumentRegistry.GetTraderSettingBoolean(NodePath, ElementName : String; var Value : Boolean):Boolean;
begin
end;
//---------------------------------------------------------------------------
function GTDDocumentRegistry.SaveTraderSettingString(NodePath, ElementName, ValueStr : String; FinalSave : Boolean):Boolean;
var
    tempDoc : GTDBizDoc;
begin
	Result := False;

	// -- This function only works when the table is open
	if not fTraderTbl.Active then
	begin
        Exit;
	end;

    // -- Put the record into Edit mode
	if not (fTraderTbl.State in [dsEdit]) then
    begin
        fTraderTbl.Edit;
    end;
    tempDoc := GTDBizDoc.Create(Self);

    // -- Read the whole memo into memory
    tempDoc.XML.Assign(TMemoField(fTraderTbl.FieldByName('SETTINGS')));

    // -- Change the required element
    Result := tempDoc.SetStringElement(NodePath, ElementName, ValueStr);

    // -- Write the whole thing back
    TMemoField(fTraderTbl.FieldByName('SETTINGS')).Assign(tempDoc.XML);

    tempDoc.Destroy;

    // -- If the record must be saved then do so
    if FinalSave then
        fTraderTbl.Post;

end;
//---------------------------------------------------------------------------
function GTDDocumentRegistry.SaveTraderSettingInt(NodePath, ElementName : String; ValueInt : Integer; FinalSave : Boolean):Boolean;
var
    tempDoc : GTDBizDoc;
begin
	Result := False;

	// -- This function only works when the table is open
	if not fTraderTbl.Active then
	begin
        Exit;
	end;

    // -- Put the record into Edit mode
	if not (fTraderTbl.State in [dsEdit]) then
    begin
        fTraderTbl.Edit;
    end;
    tempDoc := GTDBizDoc.Create(Self);

    // -- Read the whole memo into memory
    tempDoc.XML.Assign(TMemoField(fTraderTbl.FieldByName('SETTINGS')));

    // -- Change the required element
    Result := tempDoc.SetIntegerElement(NodePath, ElementName, ValueInt);

    // -- Write the whole thing back
    TMemoField(fTraderTbl.FieldByName('SETTINGS')).Assign(tempDoc.XML);

    tempDoc.Destroy;

    // -- If the record must be saved then do so
    if FinalSave then
        fTraderTbl.Post;

end;

//---------------------------------------------------------------------------
function GetTempDir:String;
var
	aBuff   : Array [1..200] of char;
begin
    {$IFDEF WIN32}
    // -- Use the windows temporary directory
    if (GetTempPath(sizeof(aBuff),@aBuff) = 0) then
        // -- Isn't this bad !
        Result := 'c:\'
    else
        Result := StrPas(@aBuff);
    {$ENDIF}
end;
//---------------------------------------------------------------------------
{$IFDEF WIN32}
function GTDDocumentRegistry.GetNextRegistryInt(SectionName,ElementName : String; var ValueInt : Integer):Boolean;
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
{$ENDIF}

//---------------------------------------------------------------------------
function GTDDocumentRegistry.OpenRegistry(Params : String; var StatusText : String):Boolean;
var
	openedOK : Boolean;
begin
    try

        openedOK := False;

    	fDocTbl.Active := False;
        fTraderTbl.Active := False;
        fAuditTbl.Active := False;
		fSysValTbl.Active := False;

		// -- Now try opening up the tablse
		fDocTbl.Active := True;
		fTraderTbl.Active := True;
		fAuditTbl.Active := True;
		fSysValTbl.Active := True;

        // -- If it got to here then it worked
        openedOK := True;
        StatusText := 'Database opened Successfully';

    except
        on E: Exception do
            StatusText := E.Message; // , E.HelpContext);
    else
	end;

    Result := openedOK;
end;
//---------------------------------------------------------------------------
procedure GTDDocumentRegistry.Close;
begin
    {$IFDEF WIN32}
    {$IFNDEF LIGHTWEIGHT}
	fDocTbl.Active := False;
    fTraderTbl.Active := False;
    fAuditTbl.Active := False;
    {$ENDIF}
    {$ENDIF}
end;

//---------------------------------------------------------------------------
procedure GTDDocumentRegistry.SetGTL(newGTL : String);
{$IFDEF WIN32}
var
    qryFindTraderID : TQuery;
begin
    // --
    qryFindTraderID := TQuery.Create(Self);

    // -- Setup the Database information
    qryFindTraderID.DatabaseName := fDatabaseName;
    qryFindTraderID.SessionName  := fSessionName;

    with qryFindTraderID do
    begin

		// -- Build the SQL
        SQL.Add('Select Trader_ID from Trader');
        SQL.Add('where ' + GTD_DB_COL_COMPANY_CODE + ' ="' + newGTL + '"');

        Active := True;

        First;
		if not Eof then
            fRemoteTraderID := FieldByName(GTD_DB_COL_TRADER_ID).AsInteger
        else
            fRemoteTraderID := 0;

        Destroy;
    end;
{$ELSE}
begin
{$ENDIF}
end;
//---------------------------------------------------------------------------
// ExtractDocDetails
//
// Synopsis
//
// This method extracts details for a document into a format that is
// suitable for sending to the other party
//---------------------------------------------------------------------------
function GTDDocumentRegistry.ExtractDocDetails(aDocument : GTDBizDoc):String;
{$IFDEF LIGHTWEIGHT}
var
	Doc_ID      : Integer;
	NodePath    : String;
{$ENDIF}
begin
	Result := '';
	{$IFNDEF LIGHTWEIGHT}
	with fDocTbl do
	begin
		// -- Remote_Doc_ID
		if not FieldByName(GTD_DB_DOC_MSGID).isNull then
			Result := Result + GTD_DB_DOC_MSGID + '!=' + FieldByName(GTD_DB_DOC_MSGID).AsString + ',';

		// -- Local_Doc_ID
		if not FieldByName(GTD_DB_DOC_DOC_ID).isNull then
			Result := Result + GTD_DB_DOC_DOC_ID + '!=' + FieldByName(GTD_DB_DOC_DOC_ID).AsString + ',';

		// -- Owned_By
		if not FieldByName('Owned_By').isNull then
			Result := Result + 'Owned_By!=' + FieldByName('Owned_By').AsString + ',';

		// -- System_Name
		if not FieldByName('System_Name').isNull then
			Result := Result + 'System_Name&=' + EncodeString(FieldByName('System_Name').AsString,'&') + ',';

		// -- Document_Name
		if not FieldByName('Document_Name').isNull then
			Result := Result + 'Document_Name&=' + EncodeString(FieldByName('Document_Name').AsString,'&') + ',';

		// -- Document Reference
		if not FieldByName('Document_Reference').isNull then
			Result := Result + 'Document_Reference&=' + EncodeString(FieldByName('Document_Reference').AsString,'&') + ',';

		// -- Document Date
		if not FieldByName('Document_Date').isNull then
			Result := Result + EncodeDateTimeField('Document_Date', FieldByName('Document_Date').AsDateTime) + ',';

		// -- Document Total
		if not FieldByName('Document_Total').isNull then
			Result := Result + 'Document_Total$=' + FieldByName('Document_Total').AsString + ',';

		// -- Tax Total
		if not FieldByName('Document_Tax').isNull then
			Result := Result + 'Tax_Total$=' + FieldByName('Document_Tax').AsString + ',';

		// -- Local Status code
		if not FieldByName('Local_Status_Code').isNull then
			Result := Result + 'Local_Status_Code&=' + EncodeString(FieldByName('Local_Status_Code').AsString,'&') + ',';

		// -- Local status comments
		if not FieldByName('Local_Status_Comments').isNull then
			Result := Result + 'Local_Status_Comments&=' + EncodeString(FieldByName('Local_Status_Comments').AsString,'&') + ',';

		// -- Knock off the last comma if any
		if Result[Length(Result)] = ',' then
			Result := Copy(Result,1,Length(Result)-1);

	end;
	{$ELSE}

		Result := '';

		NodePath := '/Documents/Document ' + IntToStr(aDocument.Local_Doc_ID);

		// -- Local_Doc_ID
		Result := Result + 'Local_Doc_ID!=' + fStorage.GetStringElement(NodePath,GTD_DB_DOC_DOC_ID) + ',';

		// -- Owned_By
		Result := Result + 'Owned_By!=0, '; // + MarkB.ReadStringField('Owned_By') + ',';

		// -- System_Name
		Result := Result + 'System_Name&=' + EncodeString(fStorage.GetStringElement(NodePath,GTD_DB_DOC_SYSTEM),'&') + ',';

		// -- Document_Name
		Result := Result + 'Document_Name&=' + EncodeString(fStorage.GetStringElement(NodePath,GTD_DB_DOC_TYPE),'&') + ',';

		// -- Document Reference
		Result := Result + 'Document_Reference&=' + EncodeString(fStorage.GetStringElement(NodePath,GTD_DB_DOC_REFERENCE),'&') + ',';

		// -- Document Date
	//    Result := Result + EncodeDateTimeField('Document_Date',FileDateToDateTime(FileAge(aDocument.fFileName))) + ',';

		// -- Document Total
		Result := Result + 'Document_Total$=' + fStorage.GetStringElement(NodePath,GTD_DB_DOC_TOTAL)+ ',';

		// -- Document Total
		Result := Result + 'Tax_Total$=' + fStorage.GetStringElement(NodePath,'Document_Tax')+ ',';

		// -- Local Status code
		Result := Result + 'Local_Status_Code&=' + EncodeString(fStorage.GetStringElement(NodePath,GTD_DB_DOC_LOCSTAT),'&') + ',';

		// -- Local status comments
		Result := Result + 'Local_Status_Comments&=' + EncodeString(fStorage.GetStringElement(NodePath,GTD_DB_DOC_LOCCMTS),'&') + ',';

	{$ENDIF}
end;
//---------------------------------------------------------------------------
// GetVendorShortNameList
//
// Retrieves a list of all the short vendor names
function GTDDocumentRegistry.GetVendorShortnameList(aList : TStringList):Boolean;
var
	qryVendorNames : TQuery;
	aMemo : TMemoField;
begin
	// -- Clear out the old pricelist
	aList.Clear;

	// -- Setup the Database information
	qryVendorNames := TQuery.Create(Self);
	qryVendorNames.DatabaseName := fDatabaseName;
	qryVendorNames.SessionName  := fSessionName;

	with qryVendorNames do
	begin
		// -- Build the SQL
		SQL.Add('select');
		SQL.Add('	' + GTD_DB_COL_TRADER_ID + ',' + GTD_DB_COL_SHORTNAME);
		SQL.Add('from');
		SQL.Add('	Trader');
		SQL.Add('where');
		SQL.Add('	(' + GTD_DB_COL_SHORTNAME + ' is not null)');

        Active := True;

        First;
        while not Eof do
        begin
            // -- Add each name along with the trader_id as a pointer
            aList.AddObject(UpperCase(FieldByName(GTD_DB_COL_SHORTNAME).AsString),TObject(FieldByName(GTD_DB_COL_TRADER_ID).AsInteger));
            Next;
        end;

        Result := True;
        
        Destroy;
	end;
end;
//---------------------------------------------------------------------------
{$IFNDEF LINUX}
function GTDDocumentRegistry.LoadRegistryDetails(DocumentNumber : Integer; var aDocument : GTDBizDoc):Boolean;
{$IFDEF LIGHTWEIGHT}
var
	Doc_ID      : Integer;
	NodePath    : String;
{$ENDIF}
begin
	Result := False;
	{$IFDEF WIN32}
	{$IFNDEF LIGHTWEIGHT}
	with fDocTbl do
	begin
		// -- Local_Doc_ID
        aDocument.Local_Doc_ID      := FieldByName(GTD_DB_DOC_DOC_ID).AsInteger;

        // -- Remote_Doc_ID
        aDocument.Msg_ID            := FieldByName(GTD_DB_DOC_MSGID).AsString;

        // -- Owned_By
        aDocument.Owned_By          := FieldByName(GTD_DB_DOC_OWNER).AsInteger;

        // -- System_Name
        aDocument.System_Name       := FieldByName(GTD_DB_DOC_SYSTEM).AsString;

		// -- Document_Name
        aDocument.Document_Type     := FieldByName(GTD_DB_DOC_TYPE).AsString;

        // -- Document Reference
        aDocument.Document_Ref      := FieldByName(GTD_DB_DOC_REFERENCE).AsString;

		// -- Document Date
        aDocument.Document_Date     := FieldByName(GTD_DB_DOC_DATE).AsFloat;

		// -- Document Total
		aDocument.Document_Total    := FieldByName(GTD_DB_DOC_TOTAL).AsFloat;

		// -- Document Total
		aDocument.Tax_Total         := FieldByName(GTD_DB_DOC_TOTAL_TAX).AsFloat;

		// -- Local Status code
		aDocument.Local_Status_Code := FieldByName(GTD_DB_DOC_LOCSTAT).AsString;

        // -- Local status comments
        aDocument.Local_Status_Comments := FieldByName(GTD_DB_DOC_LOCCMTS).AsString;

        // -- Remote Status code
        aDocument.Remote_Status_Code := FieldByName(GTD_DB_DOC_REMSTAT).AsString;

        // -- Remote status comments
        aDocument.Remote_Status_Comments := FieldByName(GTD_DB_DOC_REMCMTS).AsString;

        // -- Update flag
		aDocument.Update_Flag := FieldByName(GTD_DB_DOC_UPDATEFLAG).AsString;

    end;
    {$ELSE}

        Result := False;

        // -- Load it in from disk again
        if FileExists(fDocumentRegPath) then
            fStorage.LoadFromFile(fDocumentRegPath);

        NodePath := '/Documents/Document ' + IntToStr(DocumentNumber);

		// -- Local_Doc_ID
		aDocument.Local_Doc_ID      := Round(fStorage.GetNumberElement(NodePath,GTD_DB_DOC_DOC_ID));

		// -- Remote_Doc_ID
//      aDocument.Remote_Doc_ID     := Round(fStorage.GetNumberElement(NodePath,GTD_DB_DOC_REMDOC_ID));

        // -- Owned_By
        aDocument.Owned_By          := Round(fStorage.GetNumberElement(NodePath,GTD_DB_DOC_OWNER));

        // -- System_Name
        aDocument.System_Name       := fStorage.GetStringElement(NodePath,GTD_DB_DOC_SYSTEM);

        // -- Document_Name
        aDocument.Document_Type     := fStorage.GetStringElement(NodePath,GTD_DB_DOC_TYPE);

        // -- Document Reference
        aDocument.Document_Ref      := fStorage.GetStringElement(NodePath,GTD_DB_DOC_REFERENCE);

        // -- Document Date
        aDocument.Document_Date     := fStorage.GetDateTimeElement(NodePath,GTD_DB_DOC_DATE);

		// -- Document Total
		aDocument.Document_Total    := fStorage.GetNumberElement(NodePath,GTD_DB_DOC_TOTAL);

		// -- Document Total
		aDocument.Tax_Total    		:= fStorage.GetNumberElement(NodePath,'Document_Tax');

		// -- Local Status code
		aDocument.Local_Status_Code := fStorage.GetStringElement(NodePath,GTD_DB_DOC_LOCSTAT);

        // -- Local status comments
        aDocument.Local_Status_Comments := fStorage.GetStringElement(NodePath,GTD_DB_DOC_LOCCMTS);

        // -- Local Status code
        aDocument.Remote_Status_Code := fStorage.GetStringElement(NodePath,GTD_DB_DOC_REMSTAT);

        // -- Local status comments
        aDocument.Remote_Status_Comments := fStorage.GetStringElement(NodePath,GTD_DB_DOC_REMCMTS);

        // -- Update flag
        aDocument.Update_Flag := fStorage.GetStringElement(NodePath,GTD_DB_DOC_UPDATEFLAG);

    {$ENDIF}
    {$ENDIF}

    // -- Set all these back to unchanged
    aDocument.fMsg_ID_Chg := False;
    aDocument.fBody_Chg := False;
    aDocument.fRemote_Doc_ID_Chg := False;
    aDocument.fOwned_By_Chg := False;
    aDocument.fShared_With_Chg := False;
    aDocument.fSystem_Name_Chg := False;
    aDocument.fDocument_Type_Chg := False;
	aDocument.fDocument_Ref_Chg := False;
    aDocument.fDocument_Date_Chg := False;
	aDocument.fDocument_Total_Chg := False;
	aDocument.fTax_Total_Chg := False;
	aDocument.fLocal_Status_Code_Chg := False;
    aDocument.fLocal_Status_Cmts_Chg := False;
    aDocument.fRemote_Status_Code_Chg := False;
    aDocument.fRemote_Status_Cmts_Chg := False;
    aDocument.fDeliv_Status_Code_Chg := False;
	aDocument.fDeliv_Status_Cmts_Chg := False;
	aDocument.fMime_Type_Chg := False;
    aDocument.fDocument_Options_Chg := False;
    aDocument.fUpdate_Flag_Chg := False;
end;
{$ENDIF}
//---------------------------------------------------------------------------
function GTDDocumentRegistry.AddNew(var newDoc : GTDBizDoc; DocType : String):Boolean;
var
    DocNum      : Integer;
    newFileName : String;
begin
    // -- These will be some Default settings
   	newDoc.System_Name  := 'STANDARD';
    newDoc.Update_Flag := GTD_DB_UPDDOCFLAG_NEW;

    {$IFDEF LIGHTWEIGHT}
        // -- We Retrieve the latest Document number via the registry
		DocNum := 1;
		GetNextSettingInt('Global','Last Document',DocNum);

		newDoc.fDocNumber := DocNum;

		// -- Work out a new filename
        {$IFNDEF LINUX}
		newFileName := GetActiveDocumentDir + pathslash + IntToStr(DocNum) + '-' + fRemoteGTL + '.' + DocType;
        {$ENDIF}

        newDoc.fFileName := newFileName;

	{$ELSE}
		// -- If we were using Oracle/Interbase, we could go off and get the next
		//    document number to use here
		newDoc.fDocNumber := -1;
        newDoc.fDocument_Type := DocType;
    {$ENDIF}
end;

//---------------------------------------------------------------------------
function GTDDocumentRegistry.Load(DocumentNumber : Integer; var Destination : GTDBizDoc):Boolean;
var
	l,s,d,NodePath 	: String;
        {$IFDEF WIN32}
	aMemo 	: TMemoField;
        {$ENDIF}
	xc		: Integer;
begin
    // -- Clear out all details
    Destination.Clear;

    {$IFDEF WIN32}
    {$IFNDEF LIGHTWEIGHT}
	// -- Open the table if neccessary
	if not fDocTbl.Active then
	begin
		fDocTbl.DatabaseName := DatabaseName;
		fDocTbl.Active := True;
	end;

	with fDocTbl do
	begin

		// -- Lookup the document
		if FindKey([DocumentNumber]) then
		begin

			// -- Load the data
			aMemo := TMemoField(FieldByName(GTD_BodyFieldname));

			Destination.XML.Assign(aMemo);

            Destination.DocumentNumber := DocumentNumber;

            // -- Load all the fields
			LoadRegistryDetails(DocumentNumber,Destination);

			Result := True;

		end
		else
			// -- Document send could not work
			Result := False;

	end;
	{$ELSE}
		try
			Screen.Cursor := crHourglass;

            NodePath := '/Documents/Document ' + IntToStr(DocumentNumber);

            // -- Determine where the file is and if it still exists
            l := fStorage.GetStringElement(NodePath,GTD_LW_DOC_FILENAME);

            if FileExists(l) then
			begin
				Destination.LoadFromFile(l);
                Result := True;
            end
            else
                Result := False;

            // -- Load all the fields
			LoadRegistryDetails(DocumentNumber,Destination);

		finally
			Screen.Cursor := crDefault;
		end;
	{$ENDIF}
    {$ENDIF}
end;
// ----------------------------------------------------------------------------
function GTDDocumentRegistry.Save(Doc : GTDBizDoc; AuditCode, AuditText : String; ReceivedDoc : Boolean):Boolean;
var
{$IFDEF WIN32}
{$IFNDEF LIGHTWEIGHT}
	l,s,d,NodePath 	: String;
	aMemo 	: TMemoField;
	xc		: Integer;
{$ELSE}
    NodePath : String;
    DocNum   : Integer;
{$ENDIF}
{$ENDIF}
    SavedOK     : Boolean;

begin
    SavedOK := False;

    try
    {$IFDEF WIN32}
    {$IFNDEF LIGHTWEIGHT}
        with fDocTbl do
        begin
            // -- Open the table if neccessary
            if not Active then
                Active := True;

            if Doc.fDocNumber = -1 then
            begin

                // -- Set the recipient if not already set
                if Doc.fShared_With = -1 then
                begin
                    if ReceivedDoc then
					begin
                        Doc.fOwned_By    := fRemoteTraderID;
                        Doc.fShared_With := 0;
                    end
                    else begin
                        Doc.fOwned_By    := 0;
                        Doc.fShared_With := fRemoteTraderID;
                    end;
				end;

                // -- Add this new record in
				Append;
                FieldByName(GTD_DB_DOC_OWNER).AsInteger     := Doc.fOwned_By;
                FieldByName(GTD_DB_DOC_USER).AsInteger      := Doc.fShared_With;
                FieldByName(GTD_DB_DOC_DATE).AsFloat        := Doc.fDocument_Date;
                FieldByName(GTD_DB_DOC_REFERENCE).AsString  := Doc.fDocument_Ref;
                FieldByName(GTD_DB_DOC_SYSTEM).AsString     := Doc.fSystem_Name;
                FieldByName(GTD_DB_DOC_TYPE).AsString       := Doc.fDocument_Type;
                FieldByName(GTD_DB_DOC_LOCSTAT).AsString    := Doc.fLocal_Status_Code;
                FieldByName(GTD_DB_DOC_REMSTAT).AsString    := Doc.fRemote_Status_Code;
                FieldByName(GTD_DB_DOC_UPDATEFLAG).AsString := GTD_DB_UPDDOCFLAG_NEW;

                if Doc.fMsg_ID <> '' then
                    FieldByName(GTD_DB_DOC_MSGID).AsString  := Doc.fMsg_ID
                else if (Doc.fRemote_Doc_ID <> -1) and (Doc.fRemote_Doc_ID <> 0) then
                    FieldByName(GTD_DB_DOC_MSGID).AsString := Doc.RemoteToLocalMsgID(Doc.fRemote_Doc_ID);

            end
            // -- Lookup the document
            else if FindKey([Doc.fDocNumber]) then
            begin

                // -- Simply update the record
				Edit;

            end
            else begin
                // -- Document save could not work
                Result := False;
                Exit;
            end;

            // -- Post in the relavent fields
            if Doc.Remote_Doc_ID_Changed then
            begin
//                FieldByName(GTD_DB_DOC_MSGID).AsInteger := Doc.Msg_ID;
                // -- Change the update flag also
                Doc.Update_Flag := GTD_DB_UPDDOCFLAG_SYNC;
            end;
            if Doc.Msg_ID_Changed then
                FieldByName(GTD_DB_DOC_MSGID).AsString      := Doc.fMsg_ID;
			if Doc.Document_Total_Changed then
				FieldByName(GTD_DB_DOC_TOTAL).AsFloat       := Doc.fDocument_Total;
			if Doc.Tax_Total_Changed then
				FieldByName(GTD_DB_DOC_TOTAL_TAX).AsFloat   := Doc.fTax_Total;
			if Doc.Remote_Status_Code_Changed then
				FieldByName(GTD_DB_DOC_REMSTAT).AsString    := Doc.fRemote_Status_Code;
            if Doc.Remote_Status_Cmts_Changed then
                FieldByName(GTD_DB_DOC_REMCMTS).AsString    := Doc.fRemote_Status_Cmts;
            if Doc.Local_Status_Code_Changed then
                FieldByName(GTD_DB_DOC_LOCSTAT).AsString    := Doc.fLocal_Status_Code;
            if Doc.Local_Status_Cmts_Changed then
                FieldByName(GTD_DB_DOC_LOCCMTS).AsString    := Doc.fLocal_Status_Cmts;
			if Doc.Update_Flag_Changed then
                FieldByName(GTD_DB_DOC_UPDATEFLAG).AsString := Doc.fUpdate_Flag;

            // -- Save the body of the message
            if Doc.BodyChanged then
            begin
                aMemo := TMemoField(FieldByName(GTD_BodyFieldname));
                aMemo.Assign(Doc.XML);
			end;

            // -- Post the changes to the table
            Post;

			Refresh;
			
            if Doc.fDocNumber = -1 then
                Doc.fDocNumber := FieldByName(GTD_DB_DOC_DOC_ID).AsInteger;
        end;

        // -- Now save the audit record
        with fAuditTbl do
        begin
            // -- Open the table if neccessary
            if not Active then
                Active := True;

            // -- Post all the details to the audit record
			Append;
			FieldByName(GTD_DB_AUDIT_TRADER_ID).AsInteger := fRemoteTraderID;
			FieldByName(GTD_DB_AUDIT_DOC_ID).AsInteger := Doc.fDocNumber;
			FieldByName(GTD_DB_AUDIT_LOCAL_TIMESTAMP).AsFloat := Now;
			FieldByName(GTD_DB_AUDIT_CODE).AsString := AuditCode;
            FieldByName(GTD_DB_AUDIT_DESC).AsString := AuditText;
            Post;
        end;

		// -- There seems to be trouble with saving records if the
        //    tables aren't closed
        DbiSaveChanges(fDocTbl.Handle);
        DbiSaveChanges(fAuditTbl.Handle);

    {$ELSE}
			// -- We must have this Directory present
            ForceDirectories(GetActiveDocumentDir);

            // -- Build the DocIndex
            DocNum   := Doc.Local_Doc_ID;
            if DocNum = -1 then
            begin
                // -- Obtain the document number
				DocNum := 1;
				GetNextRegistryInt(GTD_REG_NOD_GENERAL,'Last Document',DocNum);
                Doc.Local_Doc_ID := DocNum;

                // -- Calculate the filename
                if Doc.FileName = '' then
				begin
                    // -- Outbound documents go in the active dir
                    if Doc.Remote_Doc_ID = -1 then
                        Doc.fFileName := GetActiveDocumentDir + pathslash + IntToStr(DocNum) + '-' + fRemoteGTL + '.' + Doc.Document_Type
                    else
                        // -- Inbound documents go in the inbound directory
                        Doc.fFileName := GetReceivedDocDir + pathslash + IntToStr(DocNum) + '-' + fRemoteGTL + '.' + Doc.Document_Type;
                end;
			end;

            // -- If the body has changed
            if Doc.BodyChanged then
            begin
                Doc.XML.SaveToFile(Doc.FileName);
            end;

            // -- Build a pointer to the document information in the registry
            NodePath := '/Documents/Document ' + IntToStr(Doc.Local_Doc_ID);

            // -- These fields are absolutely mandatory
			fStorage.SetNumberElement(NodePath,GTD_DB_DOC_DOC_ID,Doc.Local_Doc_ID);
			fStorage.SetStringElement(NodePath,GTD_LW_DOC_FILENAME,Doc.FileName);
			fStorage.SetStringElement(NodePath,GTD_DB_DOC_SYSTEM,Doc.System_Name);
			fStorage.SetStringElement(NodePath,GTD_DB_DOC_TYPE,Doc.Document_Type);
			fStorage.SetStringElement(NodePath,GTD_DB_DOC_REFERENCE,Doc.Document_Ref);
			fStorage.SetNumberElement(NodePath,GTD_DB_DOC_TOTAL,Doc.Document_Total);
			fStorage.SetNumberElement(NodePath,GTD_DB_DOC_TOTAL_TAX,Doc.Tax_Total);
			fStorage.SetStringElement(NodePath,GTD_DB_DOC_USER,fRemoteGTL);

//			if Doc.Remote_Doc_ID_Changed then
//                fStorage.SetNumberElement(NodePath,GTD_DB_DOC_REMDOC_ID,Doc.Remote_Doc_ID);

            // GTD_DB_DOC_MSGID            = 'Msg_ID';

            // -- None of these are really used
            {
            if Doc.Owned_By_Changed then
				SetStringElement(NodePath,GTD_DB_DOC_OWNER,);
            if Doc.Shared_With_Changed then
                SetStringElement(NodePath,GTD_DB_DOC_USER,);
            }

            if Doc.Document_Ref_Changed then
                fStorage.SetStringElement(NodePath,GTD_DB_DOC_REFERENCE,Doc.Document_Ref);
            if Doc.Document_Date_Changed then
				fStorage.SetDateElement(NodePath,GTD_DB_DOC_DATE,Doc.Document_Date);
            if Doc.Local_Status_Code_Changed then
                // -- Change the status code
                fStorage.SetStringElement(NodePath,GTD_DB_DOC_LOCSTAT,Doc.Local_Status_Code);
            if Doc.Local_Status_Cmts_Changed then
                // -- Change the status comments
                fStorage.SetStringElement(NodePath,GTD_DB_DOC_LOCCMTS,Doc.Local_Status_Comments);
            if Doc.Remote_Status_Code_Changed then
                fStorage.SetStringElement(NodePath,GTD_DB_DOC_REMSTAT,Doc.Remote_Status_Code);
            if Doc.Remote_Status_Cmts_Changed then
                fStorage.SetStringElement(NodePath,GTD_DB_DOC_REMCMTS,Doc.Remote_Status_Comments);
            {
			if Doc.Deliv_Status_Code_Changed then
                SetStringElement(NodePath,,);
            if Doc.Deliv_Status_Cmts_Changed then
                SetStringElement(NodePath,,);
            if Doc.Mime_Type_Changed then
                SetStringElement(NodePath,,);
            if Doc.Document_Options_Changed then
                SetStringElement(NodePath,,);
			}
            if Doc.Update_Flag_Changed then
                fStorage.SetStringElement(NodePath,GTD_DB_DOC_UPDATEFLAG,Doc.Update_Flag);

            // -- Save the body
			fStorage.XML.SaveToFile(fDocumentRegPath);
        {$ENDIF}
    {$ENDIF} // WINDOWS
        // -- Fire off an event
		if Assigned(fOnDocumentChange) then
            fOnDocumentChange(Self,fRemoteGTL,Doc.fDocNumber,'Save');

        SavedOK := True;

    except
    else
    end;

    Result := SavedOK;

end;
//---------------------------------------------------------------------------
function GTDDocumentRegistry.Delete(var newDoc : GTDBizDoc):Boolean;
begin
    // -- Fire off an event
    if Assigned(fOnDocumentChange) then
        fOnDocumentChange(Self,fRemoteGTL,newDoc.fDocNumber,'Delete');
end;
//---------------------------------------------------------------------------
function GTDDocumentRegistry.RefreshStatus(var Doc : GTDBizDoc):Boolean;
begin
    // -- Take the lazy approach and reload the document
    Result := Load(Doc.Local_Doc_ID,Doc);
end;

//---------------------------------------------------------------------------
{$IFNDEF LINUX}
procedure GTDDocumentRegistry.SignDocument(aDoc : GTDBizDoc);
const
	arbitaryNum = 8;
var
    ms : TMemoryStream;
    xc,xd,sl : Integer;
    l,cs  : String;
begin
    // -- Bail out if there is no Hash or Cipher Manager
    if (not Assigned(fHashManager)) or (not Assigned(fCipherManager))
        or (aDoc.XML.Count = 0) then
        Exit;

    try
        ms := TMemoryStream.Create;

        // -- Has the document already got a header ?
        if Copy(aDoc.XML.Strings[0],1,arbitaryNum) = Copy(GTD_LANGUAGE,1,arbitaryNum) then
            sl := 2
        else
			sl := 1;

        for xc := sl to aDoc.XML.Count do
        begin

			// -- Load up a string
            l := aDoc.XML.Strings[xc-1] + #13;

            // -- Write the string to the stream
            xd := Length(l);
            ms.WriteBuffer(l,xd);

        end;

        // -- Rewind the stream
        ms.Seek(0,soFromBeginning);

        fHashManager.CalcStream(ms, ms.Size);

        // -- Now obtain the MD5 Hash
		cs := fHashManager.DigestString[fmtMIME64];

        // -- Now update the header
        if sl = 1 then
        begin
            // -- We weren't given a header
            L := GTD_LANGUAGE;
            aDoc.XML.Insert(0,L);
		end
        else
            // -- We have a header line to update
            L := aDoc.XML.Strings[0];

        // -- Now redo the checksum
		xc := Pos('Checksum',L);
        if xc < 1 then
            L := Copy(L,1,Length(l)-1) + ' Checksum&="' + cs + '">'
        else
            L := Copy(L,1,xc-1) + ' Checksum&="' + cs + '">';

		// -- Now write the signature back
        aDoc.XML.Strings[0] := L;
    finally
        ms.Destroy;
    end;
end;
{$ENDIF}
//---------------------------------------------------------------------------
{$IFNDEF LINUX}
function  GTDDocumentRegistry.CalcDocumentSignature(aDoc : GTDBizDoc):String;
begin
end;
{$ENDIF}
//---------------------------------------------------------------------------
{$IFNDEF LINUX}
function  GTDDocumentRegistry.DocumentSignatureOk(aDoc : GTDBizDoc):Boolean;
begin
end;
{$ENDIF}
//---------------------------------------------------------------------------
{$IFNDEF LINUX}
procedure GTDDocumentRegistry.SetFieldEncryptionKey(KeyText : String);
begin
end;
{$ENDIF}
//---------------------------------------------------------------------------
{$IFNDEF LINUX}
function GTDDocumentRegistry.LoadKeyFile(KeyFileName : String):Boolean;
begin
end;
{$ENDIF}
//---------------------------------------------------------------------------
{$IFNDEF LINUX}
procedure GTDDocumentRegistry.Generatekeyfile(targetGTL, Passphrase, KeyFileName : String);
begin
end;
{$ENDIF}
// ----------------------------------------------------------------------------
{$IFNDEF LIGHTWEIGHT}
function GTDDocumentRegistry.BuildDocumentRecordset:TQuery;
var
    FindDocs : TQuery;
begin
    FindDocs := TQuery.Create(Self);

	// -- Do we know who
    if Trader_ID = -1 then
        GetTraderIDFromGTL;

    with FindDocs do
    begin
        DatabaseName := GTD_ALIAS;
        SQL.Add('select * from Trader_Documents ');
		SQL.Add('where');
        SQL.Add('(' + GTD_DB_DOC_OWNER + '=' + IntToStr(Trader_ID) + ') and');
        SQL.Add('(' + GTD_DB_DOC_USER + '=0)');
        SQL.Add('or');
        SQL.Add('where');
		SQL.Add('(' + GTD_DB_DOC_USER + '=' + IntToStr(Trader_ID) + ') and');
        SQL.Add('(' + GTD_DB_DOC_OWNER + '=0)');

        Open;
    end;

    Result := FindDocs;

end;
{$ENDIF}
//---------------------------------------------------------------------------
{$IFNDEF LINUX}
function GTDDocumentRegistry.DisplayActiveDocuments:Boolean;
var
    FindDocs : TQuery;
    anItem : TListItem;
begin
	{
	FindDocs := BuildDocumentRecordset;

	Items.Clear;

	with FindDocs do
	begin
		First;
		while not Eof do
		begin
			// -- Add an item to the list
			anItem := Self.Items.Add;
			anItem.Caption := FieldByName(GTD_DB_DOC_DOC_ID).AsString;

			if Items.Count > 500 then
				break;

			Next;
		end;
	end;

	FindDocs.Destroy;
    }
end;
{$ENDIF}
//---------------------------------------------------------------------------
function GTDDocumentRegistry.OpenForTraderNumber(TraderNumber : Integer):Boolean;
var
    CheckTraderID : TQuery;
begin
	CheckTraderID := TQuery.Create(Self);
    CheckTraderID.DatabaseName := DatabaseName;
    CheckTraderID.SessionName  := SessionName;

    try

        Result := False;

        // -- Build a query to find the trader
        with CheckTraderID do
        begin

            SQL.Add('select ' + GTD_DB_COL_COMPANY_CODE + ', ' + GTD_DB_COL_COMPANY_NAME + ' from Trader ');
            SQL.Add('where ' + GTD_DB_COL_TRADER_ID + ' = ' + IntToStr(TraderNumber));
            Active := True;

            First;
			if not Eof then
            begin
                fRemoteGTL  := FieldByName(GTD_DB_COL_COMPANY_CODE).AsString;
				fTraderName := FieldByName(GTD_DB_COL_COMPANY_NAME).AsString;
                Result := True;
            end
            else
                fRemoteGTL := '';
        end;

    	if not fTraderTbl.Active then
	    begin
            fTraderTbl.Active := True;
	    end;

        // -- Lookup the trader by Trader_ID
        if fTraderTbl.FindKey([TraderNumber]) then
            Result := True;
        
    except
		// -- Obviously it didn't work that well
    end;

    CheckTraderID.Destroy;
    Trader_ID := TraderNumber;
end;
//---------------------------------------------------------------------------
{$IFNDEF LINUX}
function GTDDocumentRegistry.FindTraderByAccountCode(AccountCode : String):Integer;
var
    qryFindTrader : TQuery;
begin
    // -- Initialise
    Result := 0;

    // -- Check that they have supplied the right parameter
    if AccountCode = '' then
        Exit;

    // -- Setup the Database information
	qryFindTrader := TQuery.Create(Self);
    qryFindTrader.DatabaseName := fDatabaseName;
    qryFindTrader.SessionName  := fSessionName;

    with qryFindTrader do
    begin

        // -- This function looks up a company
		SQL.Add('select Trader_ID');
        SQL.Add('from Trader');
        SQL.Add('where (' + GTD_DB_COL_AR_CODE + ' = "' + AccountCode + '") or');
        SQL.Add('(' + GTD_DB_COL_AR_CODE + ' = "' + AccountCode + '") or');
        SQL.Add('(' + GTD_DB_COL_COMPANY_CODE + ' = "' + AccountCode + '")');

        Active := True;

        First;
		if not Eof then
        begin

            // -- The trader number is in the first column
            Result := Fields[0].AsInteger;

        end;

        Destroy;
    end;

end;
{$ENDIF}
//---------------------------------------------------------------------------
{$IFNDEF LINUX}
function GTDDocumentRegistry.CreateFor(OrganisationsGTL, OrganisationName, Trading_Relationship, Trading_Status_Code : String):Boolean;
begin
    // -- Force the gtl into lower case
    fRemoteGTL := LowerCase(OrganisationsGTL);
  	{$IFDEF LIGHTWEIGHT}
        Result := False;
	{$ELSE}
        // -- Here we must create the trader
        with fTraderTbl do
        begin
            // -- Open the table
            if not Active then
                Active := True;

            // -- Lookup the GTL
            Append;
			FieldByName(GTD_DB_COL_COMPANY_CODE).AsString := OrganisationsGTL;
            FieldByName(GTD_DB_COL_COMPANY_NAME).AsString := OrganisationName;
            FieldByName(GTD_DB_COL_RELATIONSHIP).AsString := Trading_Relationship;
            FieldByName(GTD_DB_COL_STATUS_CODE).AsString := Trading_Status_Code;
            Post;

            Refresh;

            // -- Reload the trader id
            Trader_ID := FieldByName(GTD_DB_COL_TRADER_ID).AsInteger;

            Result := True;
        end;


    {$ENDIF}
end;
{$ENDIF}
//---------------------------------------------------------------------------
{$IFNDEF LINUX}
function GTDDocumentRegistry.OpenFor(OrganisationsGTL : String):Boolean;
begin
    fRemoteGTL := OrganisationsGTL;
  	{$IFDEF LIGHTWEIGHT}
        if FileExists(fDocumentRegPath) then
            fStorage.LoadFromFile(fDocumentRegPath);
        Result := True;
    {$ELSE}
        Trader_ID := GetTraderIDFromGTL;
        if Trader_ID <> -1 then
			Result := True
		else
			Result := False;
    {$ENDIF}
end;
{$ENDIF}
//---------------------------------------------------------------------------
{$IFNDEF LINUX}
function FindTraderByAccountCode(AccountCode : String):Integer;
begin
	Result := -1;
end;
{$ENDIF}
//---------------------------------------------------------------------------
// Synopsis:
//
// This function encodes a remote msg_id (document number) into a form
// so that it can be store in an obscured format.
function GTDBizDoc.RemoteToLocalMsgID(RemoteDocID: Integer):String;
var
    h : TIdHashCRC32;
    s : TMemoryStream;
    l : String;
begin
    h := TIdHashCRC32.Create;
    s := TMemoryStream.Create;

    l := IntToStr(RemoteDocID);
    s.Write(l,Length(l));
    s.Seek(0,soFromBeginning);
    l := IntToStr(h.HashValue(s));
    if Length(l) > 6 then
        l := Copy(l,1,6) + '-' + Copy(l,7,Length(l)-6);
    if Length(l) > 4 then
        l := Copy(l,1,3) + '-' + Format('%x',[RemoteDocID]) + '-' + Copy(l,4,Length(l)-3);

    Result := l;

    s.Destroy;
    h.Destroy;
end;
// ----------------------------------------------------------------------------
// Synopsis:
//
// This function decodes a remote msg_id (document number) and yields the
// encoded document number stored within.
function GTDBizDoc.LocalToRemoteMsgID(LocalMsgID : String):Integer;
var
    e : Integer;
    s,m : String;
begin
    s := LocalMsgID;
    m := Parse(s,'-');
    m := Parse(s,'-');

    if m <> '' then
    begin
        Result := StrToInt('$' + m);
    end
    else
        Result := -1;

end;
// ----------------------------------------------------------------------------
{$IFNDEF LINUX}
function GTDDocumentRegistry.HaveImage(ImageFileName : String):Boolean;
var
	n : String;
begin
	// -- If there is no path for this image it means that it doesn't exist
	n := GetFullImagePath(ImageFileName);

	Result := FileExists(n);

end;
{$ENDIF}
//---------------------------------------------------------------------------
{$IFNDEF LINUX}
function GTDDocumentRegistry.GetFullImagePath(ImageFileName : String):String;
var
	n1, n2 ,n3,n4 : String;
begin
	// -- Build a list of possible places that the file could be in
	n1 := GetOurImageDir + pathslash + ImageFileName;

	{$IFNDEF LIGHTWEIGHT}
	n2 := GetDownloadImageDir + pathslash + IntToStr(fRemoteTraderID) + '-' + ImageFileName;
	{$ELSE}
	n2 := GetDownloadImageDir + pathslash + fRemoteGTL + '-' + ImageFileName;
	{$ENDIF}

	n3 := GetSoftwareInstallDir + pathslash + GTD_DR_OUR_IMAGES_SUBDIR + '\' + ImageFileName;

	n4 := GetSoftwareInstallDir + pathslash + GTD_DR_DOWNLOAD_IMAGES_SUBDIR + '\' + fRemoteGTL + '-' + ImageFileName;

	// -- Check all the possibilities and if one exists then return it
	if FileExists(n1) then
		Result := n1
	else if FileExists(n2) then
		Result := n2
	else if FileExists(n3) then
		Result := n3
	else if FileExists(n4) then
		Result := n4

end;
{$ENDIF}
//---------------------------------------------------------------------------
{$IFNDEF LINUX}
function GTDDocumentRegistry.LoadImage(ImageFileName : String;WhereTo : TImage; UseThumbnailOk : Boolean):Boolean;

	procedure SetJPEGOptions(Image1 : TImage);
    var
      Temp: Boolean;
    begin
      {$IFNDEF HW_SIMPLE}
      Temp := Image1.Picture.Graphic is TJPEGImage;
      if Temp then
		with TJPEGImage(Image1.Picture.Graphic) do
        begin
          PixelFormat := TJPEGPixelFormat(0);
          Scale := TJPEGScale(0);
          Grayscale := False;
          Performance := TJPEGPerformance(0);
          ProgressiveDisplay := False;
        end;
      {$ENDIF}
	end;
var
	n,nt : String;
    dp : Integer;
begin
	// -- Initialise
	Result := False;
	WhereTo.Picture.Graphic := nil;

	// -- Build the filename
    if UseThumbnailOk then
    begin
        // -- Chop up the filename
        dp := Pos('.',ImageFileName);
        if (dp <> 0) then
            nt := Copy(ImageFileName,1,dp-1) + '_t' + Copy(ImageFileName,dp,Length(ImageFileName)-dp+1);

        nt := GetFullImagePath(nt);

    end;

    // -- We must use the whole picture
    if nt <> '' then
        n := nt
    else
        n := GetFullImagePath(ImageFileName);

    if n = '' then
        Exit;

	try
		if FileExists(n) then
		begin
			WhereTo.Picture.LoadFromFile(n);
			Result := True;
		end
		else if FileExists(nt) then
		begin
			WhereTo.Picture.LoadFromFile(nt);
			Result := True;
		end
		else
			Result := False;

    	if WhereTo.Picture.Graphic is TJPEGImage then
	    	SetJPEGOptions(WhereTo);

	except
		on EInvalidGraphic do
		  WhereTo.Picture.Graphic := nil;
	end;

end;
{$ENDIF}
//---------------------------------------------------------------------------
{$IFNDEF LINUX}
function GTDDocumentRegistry.GetNewDocumentNumbers(var TotalDocsAvailable : Integer):String;
const
    MAX_DOCUMENT_COUNT  = 200;

{$IFNDEF LIGHTWEIGHT} // -- This is the file based version
    function BuildNewDocQuery:TQuery;
    var
        FindDocs : TQuery;
    begin
        FindDocs := TQuery.Create(Self);

        // -- Do we know who
        if Trader_ID = -1 then
            GetTraderIDFromGTL;

        with FindDocs do
        begin
			DatabaseName := GTD_ALIAS;

            SQL.Add('select * from Trader_Documents ');
            SQL.Add('where');
            SQL.Add('(' + GTD_DB_DOC_USER + '=' + IntToStr(Trader_ID) + ') and');
            SQL.Add('(' + GTD_DB_DOC_OWNER + '=0) and ');
            SQL.Add('(' + GTD_DB_DOC_UPDATEFLAG + '="' + GTD_DB_UPDDOCFLAG_NEW + '")');

            Open;
        end;

        Result := FindDocs;
    end;

    var
		DocQuery    : TQuery;
        xc          : Integer;
    begin

        DocQuery := BuildNewDocQuery;

    	with DocQuery do
    	begin
            // --
            First;
            xc := 0;

            TotalDocsAvailable := RecordCount;

			// -- Process each record
            while not Eof do
            begin

                // -- Look for new documents
                if ((FieldByName(GTD_DB_DOC_UPDATEFLAG).AsString = GTD_DB_UPDDOCFLAG_NEW) or
				   // -- but also include documents where everything has changed
                   (FieldByName(GTD_DB_DOC_UPDATEFLAG).AsString = GTD_DB_UPDDOCFLAG_DIRTYALL))
                    then
                begin
                    // -- Now send this document through
                    // -- New document, send it through
                    Result := Result + FieldByName(GTD_DB_DOC_DOC_ID).AsString + GTD_DOC_LIST_SEPERATOR;
                end;

                // -- Never process too many documents
                Inc(xc);
                if xc > MAX_DOCUMENT_COUNT then
                    break;

                Next;
            end;
        end;

		DocQuery.Destroy;

{$ELSE}
    var
	    MarkA       : HECMLMarker;
		s,t,d,n		: String;
    begin
        // -- Refresh the document list
		if not FileExists(fDocumentRegPath) then
        begin
			// -- Absolutely no point in continuing when there are no documents
            Exit;
        end;

        // -- Load in the document list
        fStorage.LoadFromFile(fDocumentRegPath);

		// -- We have to use in memory document register
		MarkA := HECMLMarker.Create;
		MarkA.UseBodyText(fStorage.XML);

        // -- Find the first tag
        MarkA.FindTag('Documents');

		repeat
			t := MarkA.ReadNextTag;
			// -- If we have a tag
			if ((t <> '') and (t[1] <> '/')) then
			begin
				d := fStorage.GetStringElement('/Documents/' + t, GTD_DB_DOC_DOC_ID);
				s := fStorage.GetStringElement('/Documents/' + t, GTD_DB_DOC_UPDATEFLAG);
                n := fStorage.GetStringElement('/Documents/' + t, GTD_DB_DOC_USER);

                // -- does it belong to the company that we want ?
				if ((s = GTD_DB_UPDDOCFLAG_NEW) or
                   // -- but also include documents where everything has changed
				   (s = GTD_DB_UPDDOCFLAG_DIRTYALL)) and
                   (fRemoteGTL = n) then
				begin
					// -- New document, send it through
                    Result := Result + d + GTD_DOC_LIST_SEPERATOR;
				end;

			end;
		until t = '';

		MarkA.Destroy;
	{$ENDIF}

end;
{$ENDIF}
//---------------------------------------------------------------------------
{$IFNDEF LINUX}
function GTDDocumentRegistry.GetUpdatedDocumentNumbers(ReturnRemoteIDs : Boolean):String;
const
    MAX_DOCUMENT_COUNT = 200;

{$IFNDEF LIGHTWEIGHT} // -- This is the file based version
    function BuildUpdatedDocQuery:TQuery;
    var
        FindDocs : TQuery;
    begin
        FindDocs := TQuery.Create(Self);

        // -- Do we know who
		if Trader_ID = -1 then
			GetTraderIDFromGTL;

		with FindDocs do
        begin
            DatabaseName := GTD_ALIAS;

            SQL.Add('select * from Trader_Documents ');
            SQL.Add('where');
            SQL.Add('(' + GTD_DB_DOC_USER + '=' + IntToStr(Trader_ID) + ') and');
            SQL.Add('(' + GTD_DB_DOC_OWNER + '=0) and ');
			SQL.Add('(' + GTD_DB_DOC_UPDATEFLAG + '="' + GTD_DB_UPDDOCFLAG_DIRTYSTAT + '")');
            // Add these also onedeay + GTD_DB_UPDDOCFLAG_DIRTYHDR + GTD_DB_UPDDOCFLAG_DIRTYBODY + GTD_DB_UPDDOCFLAG_DIRTYALL

            Open;
        end;

        Result := FindDocs;
    end;

    var
        DocQuery    : TQuery;
        xc          : Integer;
    begin

        DocQuery := BuildUpdatedDocQuery;

    	with DocQuery do
    	begin
			// --
            First;
			xc := 0;

            // -- Process each record
            while not Eof do
            begin

                if (Pos(FieldByName(GTD_DB_DOC_UPDATEFLAG).AsString,
                	    GTD_DB_UPDDOCFLAG_DIRTYSTAT + GTD_DB_UPDDOCFLAG_DIRTYHDR +
						GTD_DB_UPDDOCFLAG_DIRTYBODY + GTD_DB_UPDDOCFLAG_DIRTYALL) <> 0) then
                begin
                    // -- Now send this document through
                    // -- New document, send it through
                    if ReturnRemoteIDs then
                        Result := Result + FieldByName(GTD_DB_DOC_MSGID).AsString + GTD_DOC_LIST_SEPERATOR
                    else
                        Result := Result + FieldByName(GTD_DB_DOC_DOC_ID).AsString + GTD_DOC_LIST_SEPERATOR;
                end;

                // -- Never process too many documents
                Inc(xc);
                if xc > MAX_DOCUMENT_COUNT then
                    break;

                Next;
            end;
        end;

		DocQuery.Destroy;

{$ELSE}
    var
	    MarkA       : HECMLMarker;
	    s,t,d		: String;
    begin
        // -- Refresh the document list
        if not FileExists(fDocumentRegPath) then
			// -- Absolutely no point in continuing
            Exit;

        // -- Load in the document list
        fStorage.LoadFromFile(fDocumentRegPath);

		// -- We have to use in memory document register
		MarkA := HECMLMarker.Create;
		MarkA.UseBodyText(fStorage.XML);

        // -- Find the first tag
        MarkA.FindTag('Documents');

		repeat
			t := MarkA.ReadNextTag;
			// -- If we have a tag
			if ((t <> '') and (t[1] <> '/')) then
			begin
				d := fStorage.GetStringElement('/Documents/' + t, GTD_DB_DOC_DOC_ID);
				s := fStorage.GetStringElement('/Documents/' + t, GTD_DB_DOC_UPDATEFLAG);

                if (Pos(s, GTD_DB_UPDDOCFLAG_DIRTYSTAT + GTD_DB_UPDDOCFLAG_DIRTYHDR +
                           GTD_DB_UPDDOCFLAG_DIRTYBODY + GTD_DB_UPDDOCFLAG_DIRTYALL) <> 0) then
                begin
					// -- New document, send it through
                    Result := Result + d + GTD_DOC_LIST_SEPERATOR;
				end;

			end;
		until t = '';

		MarkA.Destroy;
	{$ENDIF}
end;
{$ENDIF}
//---------------------------------------------------------------------------
{$IFNDEF LINUX}
function GTDDocumentRegistry.SetReadOnlyFlag(DocumentNumber : Integer; FlagStatus : Boolean):Boolean;
begin
end;
{$ENDIF}
//---------------------------------------------------------------------------
{$IFNDEF LINUX}
function GTDDocumentRegistry.SaveReceivedImage(ShortFileName: String; Base64ImageDocument : GTDBizDoc):Boolean;
var
	FullFileName : String;
begin
	try

		// -- Work out where exactly the file will go
		{$IFDEF LIGHTWEIGHT}
		FullFileName := GetDownloadImageDir + pathslash + fRemoteGTL + '-' + ShortFileName;
		{$ELSE}
		FullFileName := GetDownloadImageDir + pathslash + IntToSTr(fRemoteTraderID) + '-' + ShortFileName;
		{$ENDIF}

		// -- Write it out to our stream
		Result := Base64ImageDocument.WriteAttachment(ShortFileName, FullFileName);

	except
		raise;
	end;

end;
{$ENDIF}
//---------------------------------------------------------------------------
{$IFNDEF LINUX}
function GTDDocumentRegistry.AddProductImage(ImageFileName : String; FullWidth, ThumbWidth : Integer):String;
var
	iname,tname : String;
begin
	tname := GetOurImageDir + pathslash + ExtractFileName(ImageFileName);

	// -- Create the directory if it doesn't exist
	if not DirectoryExists(GetOurImageDir) then
	begin
		CreateDirectory(PChar(GetOurImageDir),nil);
	end;

	if (FullWidth <> 0) or (FullWidth <> -1) then
		ResizeImage(ImageFileName,GetOurImageDir,'',FullWidth);

	if (ThumbWidth <> 0) or (ThumbWidth <> -1) then
		ResizeImage(ImageFileName,GetOurImageDir,'_t',ThumbWidth);

	{
	if CopyFile(PChar(ImageFileName),PCHar(tname),False) then
		Result := ''
	else
		Result := SysErrorMessage(GetLastError);
	}


end;
{$ENDIF}
//---------------------------------------------------------------------------
{$IFNDEF LINUX}
function GTDDocumentRegistry.GetLatestPriceListDateTime:TDateTime;
	{$IFDEF LIGHTWEIGHT}
	var
		s : String;
	begin
		s := GetLatestPriceListFileName;
		if s <> '' then
			fPricelistDateTime := FileDateToDateTime(FileAge(s))
		else
			fPricelistDateTime := 0;
		// -- Just read the value
		Result := fPricelistDateTime;
	{$ELSE}
		var
			FindDocs : TQuery;
		begin
			FindDocs := TQuery.Create(Self);

			with FindDocs do
			begin
				DatabaseName := GTD_ALIAS;

				SQL.Add('select * from Trader_Documents ');
				SQL.Add('where');
				SQL.Add('((' + GTD_DB_DOC_USER + '=0) and');
				SQL.Add(' (' + GTD_DB_DOC_OWNER + '=' + IntToStr(Trader_ID) + ')) ');
				SQL.Add('or ((' + GTD_DB_DOC_USER + '=' + IntToStr(Trader_ID) + ') and');
				SQL.Add(' (' + GTD_DB_DOC_OWNER + '=0))' );
				SQL.Add('and (' + GTD_DB_DOC_TYPE + '="' + GTD_PRICELIST_TYPE + '")');
				// Add these also onedeay + GTD_DB_UPDDOCFLAG_DIRTYHDR + GTD_DB_UPDDOCFLAG_DIRTYBODY + GTD_DB_UPDDOCFLAG_DIRTYALL

				Open;

				First;
				if not Eof then
				begin
					fPricelistDateTime := FieldByName(GTD_DB_DOC_DATE).AsFloat;
					Result := fPricelistDateTime;
				end;

			end;

			FindDocs.Destroy;
	{$ENDIF}
end;
{$ENDIF}
//---------------------------------------------------------------------------
{$IFNDEF LINUX}
{$IFDEF LIGHTWEIGHT}
// -- This function converts from global@tampa(fl-us)
//    to d:\xx\global@tampa(fl-us)
function GTDDocumentRegistry.FindPricelistFileForGTL(GTL : String):String;
var
    s,n,DocumentDir : String;
	SearchRec: TSearchRec;
	foundrec : Boolean;
    plDateTime : TDateTime;

begin

    plDateTime := 0;

    // -- This first iteration will check the current directory
    s := '.\*' + GTL + GTD_PRICELIST_EXT;
    foundrec := FindFirst(s, faAnyFile, SearchRec) = 0;
    while foundrec do
    begin

        // -- Rebuild the filename
        s := '.\' + SearchRec.Name;

        if FileDateToDateTime(FileAge(s)) > plDateTime then
        begin
            // -- Use this catalog instead
            plDateTime := FileDateToDateTime(FileAge(s));
			// -- Save the filename (so we can reload catalog
            n := s;
        end;

		foundrec := FindNext(SearchRec) = 0;

    end;

	FindClose(SearchRec);

    // -- Although we may have already loaded a catalog
    //    we must now check and see if a more recent one
    //    exists on our hard disk
    DocumentDir := GetTradalogDir;
    s := DocumentDir + '\*' + GTL + GTD_PRICELIST_EXT;
    foundrec := FindFirst(s, faAnyFile, SearchRec) = 0;
    while foundrec do
    begin

        // -- Rebuild the filename
        s := DocumentDir + pathslash + SearchRec.Name;

        if FileDateToDateTime(FileAge(s)) > plDateTime then
        begin
            // -- Use this catalog instead
            plDateTime := FileDateToDateTime(FileAge(s));
            // -- Save the filename (so we can reload catalog
            n := s;
		end;

        foundrec := FindNext(SearchRec) = 0;

    end;

    FindClose(SearchRec);

	// -- Nothing worked. So use the default pricelist
    if (AnsiCompareText(n,'.\' + GTD_CURRENT_PRICELIST)=0) or
	   (n = '') then
    begin
        // -- If the file exists then use it
        if FileExists('.\' + GTD_CURRENT_PRICELIST) then
            n := ExpandFileName('.\' + GTD_CURRENT_PRICELIST);

        // MessageDlg('Using pricelist at [' + n + ']', mtInformation,[mbOK], 0);

    end;

    // -- Now load the file
    Result := n;

end;
{$ENDIF}
{$ENDIF}
//---------------------------------------------------------------------------
// -- This function converts from d:\xx\global@tampa(fl-us)
//    to global@tampa(fl-us)
{$IFDEF LIGHTWEIGHT}
{$IFNDEF LINUX}
function GTDDocumentRegistry.ConvertPricelistNameToGTL(PricelistPath : String):String;
var
    xc,xd       : Integer;
    AllNumbers  : Boolean;
    s           : String;
    aDoc        : GTDBizDoc;
begin
	// -- Build the trader code
    s := ExtractFileName(PricelistPath);

    if Lowercase(s) = Lowercase(GTD_CURRENT_PRICELIST) then
    begin
		// -- We are after the GTL in the pricelist
        aDoc := GTDBizDoc.Create(Self);

        // -- Load the file and pull out the gtl
        aDoc.LoadFromFile(PricelistPath);
        s    := aDoc.GetStringElement(GTD_PL_VENDORINFO_NODE,GTD_PL_ELE_COMPANY_CODE);

        aDoc.Destroy;
    end
    else begin
        // -- Chop the pricelist extension off
        if AnsiUpperCase(Copy(s,Length(s)-Length(GTD_PRICELIST_EXT)+1,Length(GTD_PRICELIST_EXT))) = AnsiUpperCase(GTD_PRICELIST_EXT) then
            s := Copy(s,1,Length(s)-Length(GTD_PRICELIST_EXT));

        // -- Now chop any Document numbers off the start
        xd := Pos('-',s);
        allNumbers := True;
		for xc := 1 to xd do
        begin
            // -- Look for the last dot
            if Pos(s[xc],'0123456789') = 0 then
            begin
                allNumbers := False;
                break;
			end;
		end;

        if AllNumbers then
            s := Copy(s,xc+1,Length(s)-xc);

    end;
    Result := s;
end;
// ----------------------------------------------------------------------------
{$ENDIF}
{$ENDIF}
{$IFNDEF LINUX}
{$IFDEF LIGHTWEIGHT}
function GTDDocumentRegistry.GetLatestStatementFileName:String;
var
	s,n,DocumentDir : String;
	SearchRec: TSearchRec;
	foundrec : Boolean;
	stDateTime : TDateTime;

begin
	// -- This first iteration will check the current directory
	s := '.\*' + GTL + GTD_STM_EXT;
	foundrec := FindFirst(s, faAnyFile, SearchRec) = 0;
	while foundrec do
	begin

		// -- Rebuild the filename
		s := '.\' + SearchRec.Name;

		if FileDateToDateTime(FileAge(s)) > stDateTime then
		begin
			// -- Use this catalog instead
			stDateTime := FileDateToDateTime(FileAge(s));
			// -- Save the filename (so we can reload catalog
			n := s;
		end;

		foundrec := FindNext(SearchRec) = 0;

	end;

	FindClose(SearchRec);

	// -- Although we may have already loaded a catalog
	//    we must now check and see if a more recent one
	//    exists on our hard disk
	DocumentDir := GetReceivedDocDir;
	s := DocumentDir + pathslash + '*-' + GTL + GTD_STM_EXT;
	foundrec := FindFirst(s, faAnyFile, SearchRec) = 0;
	while foundrec do
	begin

		// -- Rebuild the filename
		s := DocumentDir + pathslash + SearchRec.Name;

		if FileDateToDateTime(FileAge(s)) > stDateTime then
		begin
			// -- Use this catalog instead
			stDateTime := FileDateToDateTime(FileAge(s));
			// -- Save the filename (so we can reload catalog
			n := s;
		end;

		foundrec := FindNext(SearchRec) = 0;

	end;

	FindClose(SearchRec);

	// -- Now load the file
	Result := n;
end;
{$ENDIF}
{$ENDIF}
//---------------------------------------------------------------------------
{$IFNDEF LINUX}
procedure GTDDocumentRegistry.LoadHistoryToLSV(aDoc : GTDBizDoc; var HistoryDisplayList : TListView);
var
	aQry    : TQuery;
	anItem  : TListItem;
begin
	HistoryDisplayList.Items.Clear;

	{$IFNDEF LIGHTWEIGHT}
	aQry := TQuery.Create(Self);
	try

        aQry.DatabaseName := fDatabaseName;

		with aQry do
		begin

			// -- Build the query to find the records
            SQL.Add('select * from Trader_AuditTrail');
            SQL.Add('where Document_ID = ' + IntToStr(aDoc.Local_Doc_ID));
            SQL.Add('order by Document_Audit_ID Desc');

            // -- Open the query
            Active := True;

            // -- Scan the records and load them into the list
            while not Eof do
            begin
                anItem := HistoryDisplayList.Items.Add;
                {
                if FieldByName(GTD_DB_AUDIT_CREATOR).AsString = 'L' then }
                    anItem.Caption := FieldByName(GTD_DB_AUDIT_LOCAL_TIMESTAMP).AsString;
                {else
                    anItem.Caption := FieldByName(GTD_DB_AUDIT_REMOT_TIMESTAMP).AsString;
				}
                anItem.SubItems.Add(FieldByName(GTD_DB_AUDIT_CODE).AsString);
                anItem.SubItems.Add(FieldByName(GTD_DB_AUDIT_DESC).AsString);
                Next;
            end;

        end;
    finally
		aQry.Destroy;
    end;
    {$ENDIF}

end;
{$ENDIF}
//---------------------------------------------------------------------------
{$IFNDEF LINUX}
// - Writes some information to the audit table
function GTDDocumentRegistry.RecordAuditTrail(aDoc : GTDBizDoc; AuditCode, AuditDescription : String; ExtraText : TStrings):Boolean;
{$IFDEF LIGHTWEIGHT}
begin
    Result := False;
end;
{$ELSE}
var
    qryInsertAudit : TQuery;
    tid            : Integer;
begin

    qryInsertAudit := TQuery.Create(Self);

	try

        qryInsertAudit.DatabaseName := fDatabaseName;
        qryInsertAudit.SessionName  := fSessionName;

        // -- Check thata we have a valid document number
        if (aDoc.fDocNumber = -1) or (aDoc.fDocNumber = 0) then
        begin
			Result := False;
            Exit;
        end;

		// -- Now try to innsert a vale into the audit table
        with qryInsertAudit do
        begin
            // -- Add all the category codes back in
            SQL.Clear;
            SQL.Add('insert into Trader_AuditTrail');
			SQL.Add('	(trader_id, Document_ID, Audit_Code, Audit_Description)');
			SQL.Add('values');

			SQL.Add('  	(' + IntToStr(tid) + ',' + IntToStr(aDoc.fDocNumber) + ',"' + AuditCode + '", "' + AuditDescription + '")');

            // -- Now do it
            ExecSQL;

            Result  := True;

		end;
    except
    end;

    qryInsertAudit.Destroy;

end;
{$ENDIF}
{$ENDIF}
//---------------------------------------------------------------------------
{$IFNDEF LINUX}
{$IFDEF LIGHTWEIGHT}
function GTDDocumentRegistry.GetLatestPriceListFileName:String;
begin
	Result := FindPricelistFileForGTL(fRemoteGTL);
end;
{$ENDIF}
{$ENDIF}
//---------------------------------------------------------------------------
function GTDDocumentRegistry.GetTraderIDFromGTL:Integer;
{$IFDEF WIN32}
var
    CheckGTL : TQuery;
begin
	CheckGTL := TQuery.Create(Self);
    CheckGTL.DatabaseName := fDatabaseName;
    CheckGTL.SessionName  := fSessionName;

    with CheckGTL do
    begin

        SQL.Add('select ' + GTD_DB_COL_TRADER_ID + ' from Trader ');
		SQL.Add('where ' + GTD_DB_COL_COMPANY_CODE + ' =''' + fRemoteGTL +'''');
        Active := True;

        First;
        if not Eof then
            Result := FieldByName(GTD_DB_COL_TRADER_ID).AsInteger
        else
            Result := -1;
    end;

    CheckGTL.Destroy;
{$ELSE}
begin
{$ENDIF}
end;
// ----------------------------------------------------------------------------
function GetCountryNameList(CountryList : TStrings):Boolean;
{$IFDEF DOITASTUPIDLONGWAY}
var
	aQry    : TQuery;
    markA,markB   : HECMLMarker;
    xc : Integer;
    cn : String;
    aMemo : TMemoField;
begin
    CountryList.Clear;
	markA := HECMLMarker.Create;
	markB := HECMLMarker.Create;
    aQry := TQuery.Create(Application.MainForm);
    try
        with aQry do
        begin
            DatabaseName := GTD_ALIAS;
            SQL.Add('Select KeyText from SysVals where (Section = "MASTER") and (KEYNAME = "COUNTRY LIST")');
			Active := True;

            First;
            if not Eof then
            begin
				aMemo := TMemoField(FieldByName('KEYTEXT'));
				Marka.MsgLines.Assign(aMemo);

				for xc := 1 to markA.MsgLines.Count do
                begin
                    markB.Clear;
                    markB.Add(markA.MsgLines[xc-1]);

                    // -- Read the field out
					cn := markB.ReadStringField('Name');

                    // -- Add it to the list
                    if (cn <> '') then
                        CountryList.Add(cn);
                end;
            end;
        end;
    finally
        MarkB.Destroy;
        MarkA.Destroy;
        aQry.Destroy;
    end;
{$ELSE}
begin
    CountryList.Add('United States of America'     );
    CountryList.Add('Andorra'                      );
    CountryList.Add('United Arab Emirates'         );
    CountryList.Add('Afghanistan'                  );
    CountryList.Add('Antigua & Barbuda'            );
    CountryList.Add('Anguilla'                     );
    CountryList.Add('Albania'                      );
	CountryList.Add('Armenia'                      );
    CountryList.Add('Netherlands Antilles'         );
    CountryList.Add('Angola'                       );
    CountryList.Add('Antarctica'                   );
    CountryList.Add('Argentina'                    );
    CountryList.Add('American Samoa'               );
    CountryList.Add('Austria'                      );
	CountryList.Add('Australia'                    );
    CountryList.Add('Aruba'                        );
    CountryList.Add('Azerbaijan'                   );
    CountryList.Add('Bosnia and Herzegovina'       );
    CountryList.Add('Barbados'                     );
    CountryList.Add('Bangladesh'                   );
    CountryList.Add('Belgium'                      );
    CountryList.Add('Burkina Faso'                 );
    CountryList.Add('Bulgaria'                     );
    CountryList.Add('Bahrain'                      );
    CountryList.Add('Burundi'                      );
    CountryList.Add('Benin'                        );
    CountryList.Add('Bermuda'                      );
	CountryList.Add('Brunei Darussalam'            );
    CountryList.Add('Bolivia'                      );
    CountryList.Add('Brazil'                       );
    CountryList.Add('Bahama'                       );
    CountryList.Add('Bhutan'                       );
    CountryList.Add('Burma'                        );
    CountryList.Add('Bouvet Island'                );
    CountryList.Add('Botswana'                     );
	CountryList.Add('Belarus'                      );
    CountryList.Add('Belize'                       );
    CountryList.Add('Canada'                       );
    CountryList.Add('Cocos (Keeling) Islands'      );
    CountryList.Add('Central African Republic'     );
    CountryList.Add('Congo'                        );
    CountryList.Add('Switzerland'                  );
    CountryList.Add('Côte D''ivoire (Ivory Coast)' );
	CountryList.Add('Cook Iislands'                );
    CountryList.Add('Chile'                        );
    CountryList.Add('Cameroon'                     );
    CountryList.Add('China'                        );
    CountryList.Add('Colombia'                     );
    CountryList.Add('Costa Rica'                   );
    CountryList.Add('Cuba'                         );
    CountryList.Add('Cape Verde'                   );
    CountryList.Add('Christmas Island'             );
    CountryList.Add('Cyprus'                       );
    CountryList.Add('Czech Republic'               );
    CountryList.Add('Djibouti'                     );
	CountryList.Add('Denmark'                      );
    CountryList.Add('Dominica'                     );
    CountryList.Add('Dominican Republic'           );
    CountryList.Add('Algeria'                      );
    CountryList.Add('Ecuador'                      );
    CountryList.Add('Estonia'                      );
    CountryList.Add('Egypt'                        );
    CountryList.Add('Western Sahara'               );
	CountryList.Add('Eritrea'                      );
    CountryList.Add('Spain'                        );
    CountryList.Add('Ethiopia'                     );
    CountryList.Add('Finland'                      );
    CountryList.Add('Fiji'                         );
    CountryList.Add('Falkland Islands (Malvinas)'  );
    CountryList.Add('Micronesia'                   );
    CountryList.Add('Faroe Islands'                );
    CountryList.Add('France'                       );
	CountryList.Add('France, Metropolitan'         );
    CountryList.Add('Gabon'                        );
    CountryList.Add('United Kingdom (Great Britain)' );
    CountryList.Add('Grenada'                      );
    CountryList.Add('Georgia'                      );
    CountryList.Add('French Guiana'                );
    CountryList.Add('Ghana'                        );
    CountryList.Add('Gibraltar'                    );
    CountryList.Add('Germany'                      );
    CountryList.Add('Greenland'                    );
    CountryList.Add('Gambia'                       );
	CountryList.Add('Guinea'                       );
    CountryList.Add('Guadeloupe'                   );
    CountryList.Add('Equatorial Guinea'            );
    CountryList.Add('Greece'                       );
    CountryList.Add('South Georgia and the South Sandwich Islands' );
    CountryList.Add('Guatemala'                    );
    CountryList.Add('Guam'                         );
    CountryList.Add('Guinea-Bissau'                );
	CountryList.Add('Guyana'                       );
    CountryList.Add('Hong Kong'                    );
    CountryList.Add('Heard & McDonald Islands'     );
    CountryList.Add('Honduras'                     );
    CountryList.Add('Croatia'                      );
    CountryList.Add('Haiti'                        );
    CountryList.Add('Hungary'                      );
    CountryList.Add('Indonesia'                    );
    CountryList.Add('Ireland'                      );
    CountryList.Add('Israel'                       );
	CountryList.Add('India'                        );
    CountryList.Add('British Indian Ocean Territory' );
    CountryList.Add('Iraq'                         );
    CountryList.Add('Islamic Republic of Iran'     );
    CountryList.Add('Iceland'                      );
    CountryList.Add('Italy'                        );
    CountryList.Add('Jamaica'                      );
    CountryList.Add('Jordan'                       );
    CountryList.Add('Japan'                        );
    CountryList.Add('Kenya'                        );
	CountryList.Add('Kyrgyzstan'                   );
    CountryList.Add('Cambodia'                     );
    CountryList.Add('Kiribati'                     );
    CountryList.Add('Comoros'                      );
    CountryList.Add('St. Kitts and Nevis'          );
    CountryList.Add('Korea, Democratic People''s Republic of' );
    CountryList.Add('Korea, Republic of'           );
    CountryList.Add('Kuwait'                       );
	CountryList.Add('Cayman Islands'               );
    CountryList.Add('Kazakhstan'                   );
    CountryList.Add('Lao People''s Democratic Republic' );
    CountryList.Add('Lebanon'                      );
    CountryList.Add('Saint Lucia'                  );
    CountryList.Add('Liechtenstein'                );
    CountryList.Add('Sri Lanka'                    );
    CountryList.Add('Liberia'                      );
    CountryList.Add('Lesotho'                      );
    CountryList.Add('Lithuania'                    );
    CountryList.Add('Luxembourg'                   );
	CountryList.Add('Latvia'                       );
    CountryList.Add('Libyan Arab Jamahiriya'       );
    CountryList.Add('Morocco'                      );
    CountryList.Add('Monaco'                       );
    CountryList.Add('Moldova, Republic of'         );
    CountryList.Add('Madagascar'                   );
    CountryList.Add('Marshall Islands'             );
    CountryList.Add('Mali'                         );
    CountryList.Add('Mongolia'                     );
	CountryList.Add('Myanmar'                      );
    CountryList.Add('Macau'                        );
    CountryList.Add('Northern Mariana Islands'     );
    CountryList.Add('Martinique'                   );
    CountryList.Add('Mauritania'                   );
    CountryList.Add('Monserrat'                    );
    CountryList.Add('Malta'                        );
    CountryList.Add('Mauritius'                    );
	CountryList.Add('Maldives'                     );
    CountryList.Add('Malawi'                       );
    CountryList.Add('Mexico'                       );
    CountryList.Add('Malaysia'                     );
    CountryList.Add('Mozambique'                   );
    CountryList.Add('Nambia'                       );
    CountryList.Add('New Caledonia'                );
    CountryList.Add('Niger'                        );
    CountryList.Add('Norfolk Island'               );
    CountryList.Add('Nigeria'                      );
    CountryList.Add('Nicaragua'                    );
    CountryList.Add('Netherlands'                  );
	CountryList.Add('Norway'                       );
    CountryList.Add('Nepal'                        );
    CountryList.Add('Nauru'                        );
    CountryList.Add('Niue'                         );
    CountryList.Add('New Zealand'                  );
    CountryList.Add('Oman'                         );
    CountryList.Add('Panama'                       );
    CountryList.Add('Peru'                         );
	CountryList.Add('French Polynesia'             );
    CountryList.Add('Papua New Guinea'             );
    CountryList.Add('Philippines'                  );
    CountryList.Add('Pakistan'                     );
    CountryList.Add('Poland'                       );
    CountryList.Add('St. Pierre & Miquelon'        );
    CountryList.Add('Pitcairn'                     );
    CountryList.Add('Puerto Rico'                  );
	CountryList.Add('Portugal'                     );
    CountryList.Add('Palau'                        );
    CountryList.Add('Paraguay'                     );
    CountryList.Add('Qatar'                        );
    CountryList.Add('Réunion'                      );
    CountryList.Add('Romania'                      );
    CountryList.Add('Russian Federation'           );
    CountryList.Add('Rwanda'                       );
    CountryList.Add('Saudi Arabia'                 );
    CountryList.Add('Solomon Islands'              );
    CountryList.Add('Seychelles'                   );
    CountryList.Add('Sudan'                        );
    CountryList.Add('Sweden'                       );
	CountryList.Add('Singapore'                    );
    CountryList.Add('St. Helena'                   );
    CountryList.Add('Slovenia'                     );
    CountryList.Add('Svalbard & Jan Mayen Islands' );
    CountryList.Add('Slovakia'                     );
    CountryList.Add('Sierra Leone'                 );
    CountryList.Add('San Marino'                   );
	CountryList.Add('Senegal'                      );
    CountryList.Add('Somalia'                      );
    CountryList.Add('Suriname'                     );
    CountryList.Add('Sao Tome & Principe'          );
    CountryList.Add('El Salvador'                  );
    CountryList.Add('Syrian Arab Republic'         );
    CountryList.Add('Swaziland'                    );
    CountryList.Add('Turks & Caicos Islands'       );
	CountryList.Add('Chad'                         );
    CountryList.Add('French Southern Territories'  );
    CountryList.Add('Togo'                         );
    CountryList.Add('Thailand'                     );
    CountryList.Add('Tajikistan'                   );
    CountryList.Add('Tokelau'                      );
    CountryList.Add('Turkmenistan'                 );
    CountryList.Add('Tunisia'                      );
    CountryList.Add('Tonga'                        );
    CountryList.Add('East Timor'                   );
    CountryList.Add('Turkey'                       );
    CountryList.Add('Trinidad & Tobago'            );
    CountryList.Add('Tuvalu'                       );
    CountryList.Add('Taiwan, Province of China'    );
	CountryList.Add('Tanzania, United Republic of' );
    CountryList.Add('Ukraine'                      );
    CountryList.Add('Uganda'                       );
    CountryList.Add('United States Minor Outlying Islands' );
    CountryList.Add('Uruguay'                      );
    CountryList.Add('Uzbekistan'                   );
	CountryList.Add('Vatican City State (Holy See)' );
    CountryList.Add('St. Vincent & the Grenadines' );
    CountryList.Add('Venezuela'                    );
    CountryList.Add('British Virgin Islands'       );
    CountryList.Add('United States Virgin Islands' );
    CountryList.Add('Viet Nam'                     );
    CountryList.Add('Vanuatu'                      );
    CountryList.Add('Wallis & Futuna Islands'      );
	CountryList.Add('Samoa'                        );
    CountryList.Add('Yemen'                        );
    CountryList.Add('Mayott'                       );
    CountryList.Add('Yugoslavia'                   );
    CountryList.Add('South Africa'                 );
    CountryList.Add('Zambia'                       );
    CountryList.Add('Zaire'                        );
    CountryList.Add('Zimbabwe'                     );
    CountryList.Add('Unknown or unspecified country' );
{$ENDIF}
end;
// ----------------------------------------------------------------------------
function GetCodeFromCountryName(CountryName : String):String;
{$IFDEF BADSTUFF}
var
	aQry    : TQuery;
    markA,markB   : HECMLMarker;
    xc : Integer;
    cn : String;
    aMemo : TMemoField;
begin
	markA := HECMLMarker.Create;
	markB := HECMLMarker.Create;
    aQry := TQuery.Create(Application.MainForm);
    try
        with aQry do
        begin
			DatabaseName := GTD_ALIAS;
			SQL.Add('Select KeyText from SysVals where (Section = "MASTER") and (KEYNAME = "COUNTRY LIST")');
            Active := True;

            First;
            if not Eof then
            begin
				aMemo := TMemoField(FieldByName('KEYTEXT'));
				Marka.MsgLines.Assign(aMemo);

                for xc := 1 to markA.MsgLines.Count do
                begin
                    markB.Clear;
                    markB.Add(markA.MsgLines[xc-1]);

                    // -- Read the field out
                    cn := markB.ReadStringField('Name');

                    if (CountryName = cn) then
                    begin
                        Result := markB.ReadStringField('Code');
						break;
                    end;

                end;
            end;
        end;
	finally
        MarkB.Destroy;
		MarkA.Destroy;
        aQry.Destroy;
    end;
{$ELSE}
begin
    if CountryName = 'United States of America'     then Result := 'US' else
    if CountryName = 'Andorra'                      then Result := 'AD' else
    if CountryName = 'United Arab Emirates'         then Result := 'AE' else
    if CountryName = 'Afghanistan'                  then Result := 'AF' else
    if CountryName = 'Antigua & Barbuda'            then Result := 'AG' else
    if CountryName = 'Anguilla'                     then Result := 'AI' else
    if CountryName = 'Albania'                      then Result := 'AL' else
    if CountryName = 'Armenia'                      then Result := 'AM' else
    if CountryName = 'Netherlands Antilles'         then Result := 'AN' else
    if CountryName = 'Angola'                       then Result := 'AO' else
    if CountryName = 'Antarctica'                   then Result := 'AQ' else
    if CountryName = 'Argentina'                    then Result := 'AR' else
	if CountryName = 'American Samoa'               then Result := 'AS' else
    if CountryName = 'Austria'                      then Result := 'AT' else
    if CountryName = 'Australia'                    then Result := 'AU' else
	if CountryName = 'Aruba'                        then Result := 'AW' else
    if CountryName = 'Azerbaijan'                   then Result := 'AZ' else
    if CountryName = 'Bosnia and Herzegovina'       then Result := 'BA' else
    if CountryName = 'Barbados'                     then Result := 'BB' else
    if CountryName = 'Bangladesh'                   then Result := 'BD' else
    if CountryName = 'Belgium'                      then Result := 'BE' else
    if CountryName = 'Burkina Faso'                 then Result := 'BF' else
    if CountryName = 'Bulgaria'                     then Result := 'BG' else
	if CountryName = 'Bahrain'                      then Result := 'BH' else
    if CountryName = 'Burundi'                      then Result := 'BI' else
    if CountryName = 'Benin'                        then Result := 'BJ' else
    if CountryName = 'Bermuda'                      then Result := 'BM' else
    if CountryName = 'Brunei Darussalam'            then Result := 'BN' else
    if CountryName = 'Bolivia'                      then Result := 'BO' else
    if CountryName = 'Brazil'                       then Result := 'BR' else
    if CountryName = 'Bahama'                       then Result := 'BS' else
    if CountryName = 'Bhutan'                       then Result := 'BT' else
    if CountryName = 'Burma'                        then Result := 'BU' else
    if CountryName = 'Bouvet Island'                then Result := 'BV' else
    if CountryName = 'Botswana'                     then Result := 'BW' else
    if CountryName = 'Belarus'                      then Result := 'BY' else
    if CountryName = 'Belize'                       then Result := 'BZ' else
    if CountryName = 'Canada'                       then Result := 'CA' else
    if CountryName = 'Cocos (Keeling) Islands'      then Result := 'CC' else
    if CountryName = 'Central African Republic'     then Result := 'CF' else
    if CountryName = 'Congo'                        then Result := 'CG' else
	if CountryName = 'Switzerland'                  then Result := 'CH' else
    if CountryName = 'Côte D''ivoire (Ivory Coast)' then Result := 'CI' else
	if CountryName = 'Cook Iislands'                then Result := 'CK' else
    if CountryName = 'Chile'                        then Result := 'CL' else
    if CountryName = 'Cameroon'                     then Result := 'CM' else
    if CountryName = 'China'                        then Result := 'CN' else
    if CountryName = 'Colombia'                     then Result := 'CO' else
    if CountryName = 'Costa Rica'                   then Result := 'CR' else
    if CountryName = 'Cuba'                         then Result := 'CU' else
    if CountryName = 'Cape Verde'                   then Result := 'CV' else
	if CountryName = 'Christmas Island'             then Result := 'CX' else
    if CountryName = 'Cyprus'                       then Result := 'CY' else
    if CountryName = 'Czech Republic'               then Result := 'CZ' else
    if CountryName = 'Germany'                      then Result := 'DE' else
    if CountryName = 'Djibouti'                     then Result := 'DJ' else
    if CountryName = 'Denmark'                      then Result := 'DK' else
    if CountryName = 'Dominica'                     then Result := 'DM' else
    if CountryName = 'Dominican Republic'           then Result := 'DO' else
    if CountryName = 'Algeria'                      then Result := 'DZ' else
    if CountryName = 'Ecuador'                      then Result := 'EC' else
    if CountryName = 'Estonia'                      then Result := 'EE' else
    if CountryName = 'Egypt'                        then Result := 'EG' else
    if CountryName = 'Western Sahara'               then Result := 'EH' else
    if CountryName = 'Eritrea'                      then Result := 'ER' else
    if CountryName = 'Spain'                        then Result := 'ES' else
    if CountryName = 'Ethiopia'                     then Result := 'ET' else
    if CountryName = 'Finland'                      then Result := 'FI' else
    if CountryName = 'Fiji'                         then Result := 'FJ' else
    if CountryName = 'Falkland Islands (Malvinas)'  then Result := 'FK' else
	if CountryName = 'Micronesia'                   then Result := 'FM' else
	if CountryName = 'Faroe Islands'                then Result := 'FO' else
    if CountryName = 'France'                       then Result := 'FR' else
    if CountryName = 'France, Metropolitan'         then Result := 'FX' else
    if CountryName = 'Gabon'                        then Result := 'GA' else
    if CountryName = 'United Kingdom (Great Britain)' then Result := 'GB' else
    if CountryName = 'Grenada'                      then Result := 'GD' else
    if CountryName = 'Georgia'                      then Result := 'GE' else
    if CountryName = 'French Guiana'                then Result := 'GF' else
	if CountryName = 'Ghana'                        then Result := 'GH' else
    if CountryName = 'Gibraltar'                    then Result := 'GI' else
    if CountryName = 'Greenland'                    then Result := 'GL' else
    if CountryName = 'Gambia'                       then Result := 'GM' else
    if CountryName = 'Guinea'                       then Result := 'GN' else
    if CountryName = 'Guadeloupe'                   then Result := 'GP' else
    if CountryName = 'Equatorial Guinea'            then Result := 'GQ' else
    if CountryName = 'Greece'                       then Result := 'GR' else
    if CountryName = 'South Georgia and the South Sandwich Islands' then Result :=  'GS'  else
    if CountryName = 'Guatemala'                    then Result := 'GT' else
    if CountryName = 'Guam'                         then Result := 'GU' else
    if CountryName = 'Guinea-Bissau'                then Result := 'GW' else
    if CountryName = 'Guyana'                       then Result := 'GY' else
    if CountryName = 'Hong Kong'                    then Result := 'HK' else
    if CountryName = 'Heard & McDonald Islands'     then Result := 'HM' else
    if CountryName = 'Honduras'                     then Result := 'HN' else
    if CountryName = 'Croatia'                      then Result :=  'HR'  else
    if CountryName = 'Haiti'                        then Result :=  'HT' else
    if CountryName = 'Hungary'                      then Result :=  'HU' else
    if CountryName = 'Indonesia'                    then Result :=  'ID' else
	if CountryName = 'Ireland'                      then Result :=  'IE' else
    if CountryName = 'Israel'                       then Result :=  'IL' else
    if CountryName = 'India'                        then Result :=  'IN' else
    if CountryName = 'British Indian Ocean Territory' then Result :=  'IO' else
    if CountryName = 'Iraq'                         then Result :=  'IQ' else
    if CountryName = 'Islamic Republic of Iran'     then Result :=  'IR' else
    if CountryName = 'Iceland'                      then Result :=  'IS' else
    if CountryName = 'Italy'                        then Result :=  'IT' else
	if CountryName = 'Jamaica'                      then Result :=  'JM' else
    if CountryName = 'Jordan'                       then Result :=  'JO' else
    if CountryName = 'Japan'                        then Result :=  'JP' else
    if CountryName = 'Kenya'                        then Result :=  'KE' else
    if CountryName = 'Kyrgyzstan'                   then Result :=  'KG' else
    if CountryName = 'Cambodia'                     then Result :=  'KH' else
    if CountryName = 'Kiribati'                     then Result :=  'KI' else
    if CountryName = 'Comoros'                      then Result :=  'KM' else
    if CountryName = 'St. Kitts and Nevis'          then Result :=  'KN' else
    if CountryName = 'Korea, Democratic People''s Republic of' then Result :=  'KP' else
    if CountryName = 'Korea, Republic of'           then Result :=  'KR' else
    if CountryName = 'Kuwait'                       then Result :=  'KW' else
    if CountryName = 'Cayman Islands'               then Result :=  'KY'  else
    if CountryName = 'Kazakhstan'                   then Result :=  'KZ' else
    if CountryName = 'Lao People''s Democratic Republic' then Result :=  'LA' else
    if CountryName = 'Lebanon'                      then Result :=  'LB' else
    if CountryName = 'Saint Lucia'                  then Result :=  'LC' else
    if CountryName = 'Liechtenstein'                then Result :=  'LI' else
    if CountryName = 'Sri Lanka'                    then Result :=  'LK' else
    if CountryName = 'Liberia'                      then Result :=  'LR' else
	if CountryName = 'Lesotho'                      then Result :=  'LS' else
	if CountryName = 'Lithuania'                    then Result :=  'LT' else
    if CountryName = 'Luxembourg'                   then Result :=  'LU' else
    if CountryName = 'Latvia'                       then Result :=   'LV' else
    if CountryName = 'Libyan Arab Jamahiriya'       then Result :=  'LY' else
    if CountryName = 'Morocco'                      then Result :=  'MA' else
    if CountryName = 'Monaco'                       then Result :=  'MC' else
    if CountryName = 'Moldova, Republic of'         then Result :=  'MD' else
	if CountryName = 'Madagascar'                   then Result :=  'MG' else
    if CountryName = 'Marshall Islands'             then Result :=  'MH' else
    if CountryName = 'Mali'                         then Result :=  'ML' else
    if CountryName = 'Mongolia'                     then Result :=  'MN' else
    if CountryName = 'Myanmar'                      then Result :=  'MM' else
    if CountryName = 'Macau'                        then Result :=  'MO' else
    if CountryName = 'Northern Mariana Islands'     then Result :=  'MP' else
    if CountryName = 'Martinique'                   then Result :=  'MQ' else
    if CountryName = 'Mauritania'                   then Result :=  'MR' else
    if CountryName = 'Monserrat'                    then Result :=  'MS' else
    if CountryName = 'Malta'                        then Result :=  'MT' else
    if CountryName = 'Mauritius'                    then Result :=  'MU' else
    if CountryName = 'Maldives'                     then Result :=  'MV' else
    if CountryName = 'Malawi'                       then Result :=  'MW' else
    if CountryName = 'Mexico'                       then Result :=  'MX' else
    if CountryName = 'Malaysia'                     then Result :=  'MY' else
    if CountryName = 'Mozambique'                   then Result :=  'MZ' else
    if CountryName = 'Nambia'                       then Result :=  'NA' else
    if CountryName = 'New Caledonia'                then Result :=  'NC' else
    if CountryName = 'Niger'                        then Result :=  'NE' else
	if CountryName = 'Norfolk Island'               then Result :=  'NF' else
    if CountryName = 'Nigeria'                      then Result :=  'NG' else
	if CountryName = 'Nicaragua'                    then Result :=  'NI' else
    if CountryName = 'Netherlands'                  then Result :=  'NL' else
    if CountryName = 'Norway'                       then Result :=  'NO' else
    if CountryName = 'Nepal'                        then Result :=  'NP' else
    if CountryName = 'Nauru'                        then Result :=  'NR' else
    if CountryName = 'Niue'                         then Result :=  'NU' else
	if CountryName = 'New Zealand'                  then Result :=  'NZ' else
    if CountryName = 'Oman'                         then Result :=  'OM' else
    if CountryName = 'Panama'                       then Result :=  'PA' else
    if CountryName = 'Peru'                         then Result :=  'PE' else
    if CountryName = 'French Polynesia'             then Result :=  'PF' else
    if CountryName = 'Papua New Guinea'             then Result :=  'PG' else
    if CountryName = 'Philippines'                  then Result :=  'PH' else
    if CountryName = 'Pakistan'                     then Result :=  'PK' else
    if CountryName = 'Poland'                       then Result :=  'PL' else
    if CountryName = 'St. Pierre & Miquelon'        then Result :=  'PM' else
    if CountryName = 'Pitcairn'                     then Result :=  'PN' else
    if CountryName = 'Puerto Rico'                  then Result :=  'PR' else
    if CountryName = 'Portugal'                     then Result :=  'PT' else
    if CountryName = 'Palau'                        then Result :=  'PW' else
    if CountryName = 'Paraguay'                     then Result :=  'PY' else
    if CountryName = 'Qatar'                        then Result :=  'QA' else
    if CountryName = 'Réunion'                      then Result :=  'RE' else
    if CountryName = 'Romania'                      then Result :=  'RO' else
    if CountryName = 'Russian Federation'           then Result :=  'RU' else
    if CountryName = 'Rwanda'                       then Result :=  'RW' else
	if CountryName = 'Saudi Arabia'                 then Result :=  'SA' else
    if CountryName = 'Solomon Islands'              then Result :=  'SB' else
    if CountryName = 'Seychelles'                   then Result :=  'SC' else
	if CountryName = 'Sudan'                        then Result :=  'SD' else
    if CountryName = 'Sweden'                       then Result :=  'SE' else
    if CountryName = 'Singapore'                    then Result :=  'SG' else
    if CountryName = 'St. Helena'                   then Result :=  'SH' else
    if CountryName = 'Slovenia'                     then Result :=  'SI' else
	if CountryName = 'Svalbard & Jan Mayen Islands' then Result :=  'SJ' else
    if CountryName = 'Slovakia'                     then Result :=  'SK' else
    if CountryName = 'Sierra Leone'                 then Result :=  'SL' else
    if CountryName = 'San Marino'                   then Result :=  'SM' else
    if CountryName = 'Senegal'                      then Result :=  'SN' else
    if CountryName = 'Somalia'                      then Result :=  'SO' else
    if CountryName = 'Suriname'                     then Result :=  'SR' else
    if CountryName = 'Sao Tome & Principe'          then Result :=  'ST' else
    if CountryName = 'El Salvador'                  then Result :=  'SV' else
    if CountryName = 'Syrian Arab Republic'         then Result :=  'SY' else
    if CountryName = 'Swaziland'                    then Result :=  'SZ' else
    if CountryName = 'Turks & Caicos Islands'       then Result :=  'TC' else
    if CountryName = 'Chad'                         then Result :=  'TD' else
    if CountryName = 'French Southern Territories'  then Result :=  'TF' else
    if CountryName = 'Togo'                         then Result :=  'TG' else
    if CountryName = 'Thailand'                     then Result :=  'TH' else
    if CountryName = 'Tajikistan'                   then Result :=  'TJ' else
    if CountryName = 'Tokelau'                      then Result :=  'TK' else
    if CountryName = 'Turkmenistan'                 then Result :=  'TM' else
    if CountryName = 'Tunisia'                      then Result :=  'TN' else
	if CountryName = 'Tonga'                        then Result :=  'TO' else
    if CountryName = 'East Timor'                   then Result :=  'TP' else
    if CountryName = 'Turkey'                       then Result :=  'TR' else
    if CountryName = 'Trinidad & Tobago'            then Result :=  'TT' else
	if CountryName = 'Tuvalu'                       then Result :=  'TV' else
    if CountryName = 'Taiwan, Province of China'    then Result :=  'TW' else
    if CountryName = 'Tanzania, United Republic of' then Result :=  'TZ' else
    if CountryName = 'Ukraine'                      then Result :=  'UA' else
	if CountryName = 'Uganda'                       then Result :=  'UG' else
    if CountryName = 'United States Minor Outlying Islands' then Result :=  'UM' else
    if CountryName = 'Uruguay'                      then Result :=  'UY' else
    if CountryName = 'Uzbekistan'                   then Result :=  'UZ' else
    if CountryName = 'Vatican City State (Holy See)' then Result :=  'VA' else
    if CountryName = 'St. Vincent & the Grenadines' then Result :=  'VC' else
    if CountryName = 'Venezuela'                    then Result :=   'VE'                        else
    if CountryName = 'British Virgin Islands'       then Result :=  'VG' else
    if CountryName = 'United States Virgin Islands' then Result :=  'VI' else
    if CountryName = 'Viet Nam'                     then Result :=  'VN' else
    if CountryName = 'Vanuatu'                      then Result :=  'VU' else
    if CountryName = 'Wallis & Futuna Islands'      then Result :=  'WF' else
    if CountryName = 'Samoa'                        then Result :=  'WS' else
    if CountryName = 'Yemen'                        then Result :=  'YE' else
    if CountryName = 'Mayott'                       then Result :=  'YT' else
    if CountryName = 'Yugoslavia'                   then Result :=  'YU' else
    if CountryName = 'South Africa'                 then Result :=  'ZA' else
    if CountryName = 'Zambia'                       then Result :=  'ZM' else
    if CountryName = 'Zaire'                        then Result :=   'ZR' else
    if CountryName = 'Zimbabwe'                     then Result :=  'ZW' else
	if CountryName = 'Unknown or unspecified country' then Result :=  'ZZ' else
        Result := 'ZZ';
{$ENDIF}
end;
// ----------------------------------------------------------------------------
function GetTaxNameFromCountryCode(CountryCode : String):String;
begin
    if CountryCode = '' then
		CountryCode := GetCountryCode;

    // -- Returns the tax name for the country
    if (CountryCode = 'US') then
        Result := 'Sales Tax'
    else if (CountryCode = 'UK') then
        Result := 'VAT'
    else if (CountryCode = 'AU') or (CountryCode = 'CA') then
        Result := 'GST'
    else
        Result := 'Tax';
end;
// ----------------------------------------------------------------------------
function GetSalesTaxRateFromCountryCode(CountryCode : String):Currency;
begin
	// -- Returns the tax name for the country
	if (CountryCode = 'US') then
		Result := 0
	else if (CountryCode = 'UK') then
		Result := 12.5
	else if (CountryCode = 'AU') then
		Result := 10
	else if (CountryCode = 'CA') then
		Result := 12.5
	else
		Result := 0;
end;
// ----------------------------------------------------------------------------
function GetSalesTaxIsInclusive(CountryCode : String):Boolean;
begin
	// -- Only do inclusive for Australia
	if (CountryCode = 'AU') then
		Result := True
	else
		Result := False;
end;
// ----------------------------------------------------------------------------
function GetNameFromCountryCode(CountryCode : String):String;
{
var
    aQry    : TQuery;
    markA,markB   : HECMLMarker;
    xc : Integer;
    cn : String;
    aMemo : TMemoField;
begin
	markA := HECMLMarker.Create;
	markB := HECMLMarker.Create;
    aQry := TQuery.Create(Application.MainForm);
    try
        with aQry do
        begin
            DatabaseName := GTD_ALIAS;
            SQL.Add('Select KeyText from SysVals where (Section = "MASTER") and (KEYNAME = "COUNTRY LIST")');
            Active := True;

            First;
			if not Eof then
            begin
				aMemo := TMemoField(FieldByName('KEYTEXT'));
				Marka.MsgLines.Assign(aMemo);

                for xc := 1 to markA.MsgLines.Count do
                begin
					markB.Clear;
					markB.Add(markA.MsgLines[xc-1]);

                    // -- Read the field out
                    cn := markB.ReadStringField('Code');

                    if (CountryCode = cn) then
                    begin
                        Result := markB.ReadStringField('Name');
                        break;
                    end;

                end;
            end;
        end;
    finally
        MarkB.Destroy;
        MarkA.Destroy;
        aQry.Destroy;
    end;
}
begin
    if CountryCode = 'US' then Result := 'United States of America' else
    if CountryCode = 'AD' then Result := 'Andorra' else
    if CountryCode = 'AE' then Result := 'United Arab Emirates' else
    if CountryCode = 'AF' then Result := 'Afghanistan' else
    if CountryCode = 'AG' then Result := 'Antigua & Barbuda' else
    if CountryCode = 'AI' then Result := 'Anguilla' else
    if CountryCode = 'AL' then Result := 'Albania' else
	if CountryCode = 'AM' then Result := 'Armenia' else
    if CountryCode = 'AN' then Result := 'Netherlands Antilles' else
    if CountryCode = 'AO' then Result := 'Angola' else
    if CountryCode = 'AQ' then Result := 'Antarctica' else
    if CountryCode = 'AR' then Result := 'Argentina' else
    if CountryCode = 'AS' then Result := 'American Samoa' else
    if CountryCode = 'AT' then Result := 'Austria' else
    if CountryCode = 'AU' then Result := 'Australia' else
    if CountryCode = 'AW' then Result := 'Aruba' else
    if CountryCode = 'AZ' then Result := 'Azerbaijan' else
    if CountryCode = 'BA' then Result := 'Bosnia and Herzegovina' else
    if CountryCode = 'BB' then Result := 'Barbados' else
    if CountryCode = 'BD' then Result := 'Bangladesh' else
    if CountryCode = 'BE' then Result := 'Belgium' else
    if CountryCode = 'BF' then Result := 'Burkina Faso' else
    if CountryCode = 'BG' then Result := 'Bulgaria' else
    if CountryCode = 'BH' then Result := 'Bahrain' else
    if CountryCode = 'BI' then Result := 'Burundi' else
    if CountryCode = 'BJ' then Result := 'Benin' else
    if CountryCode = 'BM' then Result := 'Bermuda' else
	if CountryCode = 'BN' then Result := 'Brunei Darussalam' else
    if CountryCode = 'BO' then Result := 'Bolivia' else
    if CountryCode = 'BR' then Result := 'Brazil' else
    if CountryCode = 'BS' then Result := 'Bahama' else
    if CountryCode = 'BT' then Result := 'Bhutan' else
    if CountryCode = 'BU' then Result := 'Burma (no longer exists)' else
    if CountryCode = 'BV' then Result := 'Bouvet Island' else
    if CountryCode = 'BW' then Result := 'Botswana' else
	if CountryCode = 'BY' then Result := 'Belarus' else
	if CountryCode = 'BZ' then Result := 'Belize' else
    if CountryCode = 'CA' then Result := 'Canada' else
    if CountryCode = 'CC' then Result := 'Cocos (Keeling) Islands' else
    if CountryCode = 'CF' then Result := 'Central African Republic' else
    if CountryCode = 'CG' then Result := 'Congo' else
    if CountryCode = 'CH' then Result := 'Switzerland' else
    if CountryCode = 'CI' then Result := 'Côte D''ivoire (Ivory Coast)' else
    if CountryCode = 'CK' then Result := 'Cook Iislands' else
    if CountryCode = 'CL' then Result := 'Chile' else
    if CountryCode = 'CM' then Result := 'Cameroon' else
    if CountryCode = 'CN' then Result := 'China' else
    if CountryCode = 'CO' then Result := 'Colombia' else
    if CountryCode = 'CR' then Result := 'Costa Rica' else
    if CountryCode = 'CS' then Result := 'Czechoslovakia (no longer exists)' else
    if CountryCode = 'CU' then Result := 'Cuba' else
    if CountryCode = 'CV' then Result := 'Cape Verde' else
    if CountryCode = 'CX' then Result := 'Christmas Island' else
    if CountryCode = 'CY' then Result := 'Cyprus' else
    if CountryCode = 'CZ' then Result := 'Czech Republic' else
	if CountryCode = 'DD' then Result := 'German Democratic Republic (no longer exists)' else
    if CountryCode = 'DE' then Result := 'Germany' else
    if CountryCode = 'DJ' then Result := 'Djibouti' else
    if CountryCode = 'DK' then Result := 'Denmark' else
    if CountryCode = 'DM' then Result := 'Dominica' else
    if CountryCode = 'DO' then Result := 'Dominican Republic' else
    if CountryCode = 'DZ' then Result := 'Algeria' else
    if CountryCode = 'EC' then Result := 'Ecuador' else
	if CountryCode = 'EE' then Result := 'Estonia' else
    if CountryCode = 'EG' then Result := 'Egypt' else
	if CountryCode = 'EH' then Result := 'Western Sahara' else
    if CountryCode = 'ER' then Result := 'Eritrea' else
    if CountryCode = 'ES' then Result := 'Spain' else
    if CountryCode = 'ET' then Result := 'Ethiopia' else
    if CountryCode = 'FI' then Result := 'Finland' else
    if CountryCode = 'FJ' then Result := 'Fiji' else
    if CountryCode = 'FK' then Result := 'Falkland Islands (Malvinas)' else
    if CountryCode = 'FM' then Result := 'Micronesia' else
    if CountryCode = 'FO' then Result := 'Faroe Islands' else
    if CountryCode = 'FR' then Result := 'France' else
    if CountryCode = 'FX' then Result := 'France, Metropolitan' else
    if CountryCode = 'GA' then Result := 'Gabon' else
    if CountryCode = 'GB' then Result := 'United Kingdom (Great Britain)' else
    if CountryCode = 'GD' then Result := 'Grenada' else
    if CountryCode = 'GE' then Result := 'Georgia' else
    if CountryCode = 'GF' then Result := 'French Guiana' else
    if CountryCode = 'GH' then Result := 'Ghana' else
    if CountryCode = 'GI' then Result := 'Gibraltar' else
	if CountryCode = 'GL' then Result := 'Greenland' else
    if CountryCode = 'GM' then Result := 'Gambia' else
    if CountryCode = 'GN' then Result := 'Guinea' else
    if CountryCode = 'GP' then Result := 'Guadeloupe' else
    if CountryCode = 'GQ' then Result := 'Equatorial Guinea' else
    if CountryCode = 'GR' then Result := 'Greece' else
    if CountryCode = 'GS' then Result := 'South Georgia and the South Sandwich Islands' else
    if CountryCode = 'GT' then Result := 'Guatemala' else
	if CountryCode = 'GU' then Result := 'Guam' else
    if CountryCode = 'GW' then Result := 'Guinea-Bissau' else
    if CountryCode = 'GY' then Result := 'Guyana' else
	if CountryCode = 'HK' then Result := 'Hong Kong' else
    if CountryCode = 'HM' then Result := 'Heard & McDonald Islands' else
    if CountryCode = 'HN' then Result := 'Honduras' else
    if CountryCode = 'HR' then Result := 'Croatia' else
    if CountryCode = 'HT' then Result := 'Haiti' else
    if CountryCode = 'HU' then Result := 'Hungary' else
    if CountryCode = 'ID' then Result := 'Indonesia' else
    if CountryCode = 'IE' then Result := 'Ireland' else
    if CountryCode = 'IL' then Result := 'Israel' else
    if CountryCode = 'IN' then Result := 'India' else
    if CountryCode = 'IO' then Result := 'British Indian Ocean Territory' else
    if CountryCode = 'IQ' then Result := 'Iraq' else
    if CountryCode = 'IR' then Result := 'Islamic Republic of Iran' else
    if CountryCode = 'IS' then Result := 'Iceland' else
    if CountryCode = 'IT' then Result := 'Italy' else
    if CountryCode = 'JM' then Result := 'Jamaica' else
    if CountryCode = 'JO' then Result := 'Jordan' else
	if CountryCode = 'JP' then Result := 'Japan' else
    if CountryCode = 'KE' then Result := 'Kenya' else
    if CountryCode = 'KG' then Result := 'Kyrgyzstan' else
    if CountryCode = 'KH' then Result := 'Cambodia' else
    if CountryCode = 'KI' then Result := 'Kiribati' else
    if CountryCode = 'KM' then Result := 'Comoros' else
    if CountryCode = 'KN' then Result := 'St. Kitts and Nevis' else
    if CountryCode = 'KP' then Result := 'Korea, Democratic People''s Republic of' else
	if CountryCode = 'KR' then Result := 'Korea, Republic of' else
    if CountryCode = 'KW' then Result := 'Kuwait' else
    if CountryCode = 'KY' then Result := 'Cayman Islands' else
    if CountryCode = 'KZ' then Result := 'Kazakhstan' else
	if CountryCode = 'LA' then Result := 'Lao People''s Democratic Republic' else
    if CountryCode = 'LB' then Result := 'Lebanon' else
    if CountryCode = 'LC' then Result := 'Saint Lucia' else
    if CountryCode = 'LI' then Result := 'Liechtenstein' else
    if CountryCode = 'LK' then Result := 'Sri Lanka' else
    if CountryCode = 'LR' then Result := 'Liberia' else
    if CountryCode = 'LS' then Result := 'Lesotho' else
    if CountryCode = 'LT' then Result := 'Lithuania' else
    if CountryCode = 'LU' then Result := 'Luxembourg' else
    if CountryCode = 'LV' then Result := 'Latvia' else
    if CountryCode = 'LY' then Result := 'Libyan Arab Jamahiriya' else
    if CountryCode = 'MA' then Result := 'Morocco' else
    if CountryCode = 'MC' then Result := 'Monaco' else
    if CountryCode = 'MD' then Result := 'Moldova, Republic of' else
    if CountryCode = 'MG' then Result := 'Madagascar' else
    if CountryCode = 'MH' then Result := 'Marshall Islands' else
	if CountryCode = 'ML' then Result := 'Mali' else
    if CountryCode = 'MN' then Result := 'Mongolia' else
    if CountryCode = 'MM' then Result := 'Myanmar' else
    if CountryCode = 'MO' then Result := 'Macau' else
    if CountryCode = 'MP' then Result := 'Northern Mariana Islands' else
    if CountryCode = 'MQ' then Result := 'Martinique' else
    if CountryCode = 'MR' then Result := 'Mauritania' else
    if CountryCode = 'MS' then Result := 'Monserrat' else
	if CountryCode = 'MT' then Result := 'Malta' else
    if CountryCode = 'MU' then Result := 'Mauritius' else
    if CountryCode = 'MV' then Result := 'Maldives' else
    if CountryCode = 'MW' then Result := 'Malawi' else
    if CountryCode = 'MX' then Result := 'Mexico' else
	if CountryCode = 'MY' then Result := 'Malaysia' else
    if CountryCode = 'MZ' then Result := 'Mozambique' else
    if CountryCode = 'NA' then Result := 'Nambia' else
    if CountryCode = 'NC' then Result := 'New Caledonia' else
    if CountryCode = 'NE' then Result := 'Niger' else
    if CountryCode = 'NF' then Result := 'Norfolk Island' else
    if CountryCode = 'NG' then Result := 'Nigeria' else
    if CountryCode = 'NI' then Result := 'Nicaragua' else
    if CountryCode = 'NL' then Result := 'Netherlands' else
    if CountryCode = 'NO' then Result := 'Norway' else
    if CountryCode = 'NP' then Result := 'Nepal' else
    if CountryCode = 'NR' then Result := 'Nauru' else
    if CountryCode = 'NT' then Result := 'Neutral Zone (no longer exists)' else
    if CountryCode = 'NU' then Result := 'Niue' else
    if CountryCode = 'NZ' then Result := 'New Zealand' else
	if CountryCode = 'OM' then Result := 'Oman' else
    if CountryCode = 'PA' then Result := 'Panama' else
    if CountryCode = 'PE' then Result := 'Peru' else
    if CountryCode = 'PF' then Result := 'French Polynesia' else
    if CountryCode = 'PG' then Result := 'Papua New Guinea' else
    if CountryCode = 'PH' then Result := 'Philippines' else
    if CountryCode = 'PK' then Result := 'Pakistan' else
    if CountryCode = 'PL' then Result := 'Poland' else
	if CountryCode = 'PM' then Result := 'St. Pierre & Miquelon' else
    if CountryCode = 'PN' then Result := 'Pitcairn' else
    if CountryCode = 'PR' then Result := 'Puerto Rico' else
    if CountryCode = 'PT' then Result := 'Portugal' else
    if CountryCode = 'PW' then Result := 'Palau' else
    if CountryCode = 'PY' then Result := 'Paraguay' else
	if CountryCode = 'QA' then Result := 'Qatar' else
    if CountryCode = 'RE' then Result := 'Réunion' else
    if CountryCode = 'RO' then Result := 'Romania' else
    if CountryCode = 'RU' then Result := 'Russian Federation' else
    if CountryCode = 'RW' then Result := 'Rwanda' else
    if CountryCode = 'SA' then Result := 'Saudi Arabia' else
    if CountryCode = 'SB' then Result := 'Solomon Islands' else
    if CountryCode = 'SC' then Result := 'Seychelles' else
    if CountryCode = 'SD' then Result := 'Sudan' else
    if CountryCode = 'SE' then Result := 'Sweden' else
    if CountryCode = 'SG' then Result := 'Singapore' else
    if CountryCode = 'SH' then Result := 'St. Helena' else
    if CountryCode = 'SI' then Result := 'Slovenia' else
    if CountryCode = 'SJ' then Result := 'Svalbard & Jan Mayen Islands' else
	if CountryCode = 'SK' then Result := 'Slovakia' else
    if CountryCode = 'SL' then Result := 'Sierra Leone' else
    if CountryCode = 'SM' then Result := 'San Marino' else
    if CountryCode = 'SN' then Result := 'Senegal' else
    if CountryCode = 'SO' then Result := 'Somalia' else
    if CountryCode = 'SR' then Result := 'Suriname' else
    if CountryCode = 'ST' then Result := 'Sao Tome & Principe' else
    if CountryCode = 'SU' then Result := 'Union of Soviet Socialist Republics (no longer exists)' else
	if CountryCode = 'SV' then Result := 'El Salvador' else
    if CountryCode = 'SY' then Result := 'Syrian Arab Republic' else
    if CountryCode = 'SZ' then Result := 'Swaziland' else
    if CountryCode = 'TC' then Result := 'Turks & Caicos Islands' else
    if CountryCode = 'TD' then Result := 'Chad' else
    if CountryCode = 'TF' then Result := 'French Southern Territories' else
    if CountryCode = 'TG' then Result := 'Togo' else
	if CountryCode = 'TH' then Result := 'Thailand' else
    if CountryCode = 'TJ' then Result := 'Tajikistan' else
    if CountryCode = 'TK' then Result := 'Tokelau' else
    if CountryCode = 'TM' then Result := 'Turkmenistan' else
    if CountryCode = 'TN' then Result := 'Tunisia' else
    if CountryCode = 'TO' then Result := 'Tonga' else
    if CountryCode = 'TP' then Result := 'East Timor' else
    if CountryCode = 'TR' then Result := 'Turkey' else
    if CountryCode = 'TT' then Result := 'Trinidad & Tobago' else
    if CountryCode = 'TV' then Result := 'Tuvalu' else
    if CountryCode = 'TW' then Result := 'Taiwan, Province of China' else
    if CountryCode = 'TZ' then Result := 'Tanzania, United Republic of' else
    if CountryCode = 'UA' then Result := 'Ukraine' else
	if CountryCode = 'UG' then Result := 'Uganda' else
    if CountryCode = 'UM' then Result := 'United States Minor Outlying Islands' else
    if CountryCode = 'UY' then Result := 'Uruguay' else
	if CountryCode = 'UZ' then Result := 'Uzbekistan' else
    if CountryCode = 'VA' then Result := 'Vatican City State (Holy See)' else
    if CountryCode = 'VC' then Result := 'St. Vincent & the Grenadines' else
    if CountryCode = 'VE' then Result := 'Venezuela' else
    if CountryCode = 'VG' then Result := 'British Virgin Islands' else
	if CountryCode = 'VI' then Result := 'United States Virgin Islands' else
    if CountryCode = 'VN' then Result := 'Viet Nam' else
    if CountryCode = 'VU' then Result := 'Vanuatu' else
    if CountryCode = 'WF' then Result := 'Wallis & Futuna Islands' else
    if CountryCode = 'WS' then Result := 'Samoa' else
    if CountryCode = 'YD' then Result := 'Democratic Yemen (no longer exists)' else
    if CountryCode = 'YE' then Result := 'Yemen' else
    if CountryCode = 'YT' then Result := 'Mayott' else
	if CountryCode = 'YU' then Result := 'Yugoslavia' else
    if CountryCode = 'ZA' then Result := 'South Africa' else
    if CountryCode = 'ZM' then Result := 'Zambia' else
    if CountryCode = 'ZR' then Result := 'Zaire' else
    if CountryCode = 'ZW' then Result := 'Zimbabwe' else
    if CountryCode = 'ZZ' then Result := 'Unknown or unspecified country';

end;
// ----------------------------------------------------------------------------
function LoadStateNames(CountryCode : String; aList : TStrings):Boolean;
begin
    aList.Clear;
    
    // Use this to get more http://pgrc3.agr.ca/cgi-bin/npgs/html/statelist.pl?Italy
	if CountryCode = 'US' then
	begin
		aList.Clear;
		aList.Add('Alaska');
		aList.Add('Alabama');
		aList.Add('Arkansas');
		aList.Add('Arizona');
		aList.Add('California');
		aList.Add('Colorado');
		aList.Add('Connecticut');
		aList.Add('District of Columbia');
		aList.Add('Delaware');
		aList.Add('Florida');
		aList.Add('Georgia');
		aList.Add('Hawaii');
		aList.Add('Iowa');
		aList.Add('Idaho');
		aList.Add('Illinois');
		aList.Add('Indiana');
		aList.Add('Kansas');
		aList.Add('Kentucky');
		aList.Add('Louisiana');
		aList.Add('Massachusetts');
		aList.Add('Maryland');
		aList.Add('Maine');
		aList.Add('Michigan');
		aList.Add('Minnesota');
		aList.Add('Missouri');
		aList.Add('Mississippi');
		aList.Add('Montana');
		aList.Add('North Carolina');
		aList.Add('North Dakota');
		aList.Add('Nebraska');
		aList.Add('New Hampshire');
		aList.Add('New Jersey');
		aList.Add('New Mexico');
		aList.Add('Nevada');
		aList.Add('New York');
		aList.Add('Ohio');
		aList.Add('Oklahoma');
		aList.Add('Oregon');
		aList.Add('Pennsylvania');
		aList.Add('Rhode Island');
		aList.Add('South Carolina');
		aList.Add('South Dakota');
		aList.Add('Tennessee');
		aList.Add('Texas');
		aList.Add('Utah');
		aList.Add('Virginia');
		aList.Add('Vermont');
		aList.Add('Washington');
		aList.Add('Wisconsin');
		aList.Add('West Virginia');
        aList.Add('Wyoming');
	end
	else if CountryCode = 'AU' then
	begin
		aList.Add('ACT');
		aList.Add('NSW');
		aList.Add('NT');
		aList.Add('QLD');
		aList.Add('VIC');
		aList.Add('WA');
		aList.Add('SA');
		aList.Add('TAS');
    end
    else if CountryCode = 'DE' then
    begin
		aList.Add('Baden-Wurttemberg');
		aList.Add('Bavaria');
		aList.Add('Berlin');
		aList.Add('Brandenburg');
		aList.Add('Bremen');
		aList.Add('Hamburg');
		aList.Add('Hessen');
		aList.Add('Lower Saxony');
		aList.Add('Mecklenburg-W.P.');
		aList.Add('N. Rhine-Westphalia');
		aList.Add('Niedersachsen');
		aList.Add('Rhineland-Palatinate');
		aList.Add('Saarland');
		aList.Add('Saxony');
		aList.Add('Saxony-Anhalt');
		aList.Add('Schleswig-Holstein');
		aList.Add('Thuringia');
    end
    else if CountryCode = 'FR' then
    begin
		aList.Add('Ain');
		aList.Add('Aisne');
		aList.Add('Allier');
		aList.Add('Alpes-Maritimes');
		aList.Add('Alpes-de-Haute-Prov.');
		aList.Add('Ardeche');
		aList.Add('Ardennes');
		aList.Add('Ariege');
		aList.Add('Aube');
		aList.Add('Aude');
		aList.Add('Aveyron');
		aList.Add('Bas-Rhin');
		aList.Add('Bouches-du-Rhone');
		aList.Add('Calvados');
		aList.Add('Cantal');
		aList.Add('Charente');
		aList.Add('Charente-Maritime');
		aList.Add('Cher');
		aList.Add('Correze');
		aList.Add('Corsica');
		aList.Add('Cote-d''Or');
		aList.Add('Cotes-du-Nord');
		aList.Add('Creuse');
		aList.Add('Deux-Sevres');
		aList.Add('Dordogne');
		aList.Add('Doubs');
		aList.Add('Drome');
		aList.Add('Essonne');
		aList.Add('Eure');
		aList.Add('Eure-et-Loir');
		aList.Add('Finistere');
		aList.Add('Gard');
		aList.Add('Gers');
		aList.Add('Gironde');
		aList.Add('Haute-Garonne');
		aList.Add('Haute-Loire');
		aList.Add('Haute-Marne');
		aList.Add('Haute-Rhin');
		aList.Add('Haute-Saone');
		aList.Add('Haute-Savoie');
		aList.Add('Haute-Vienne');
		aList.Add('Hautes-Alpes');
		aList.Add('Hautes-Pyrenees');
		aList.Add('Hauts-de-Seine');
		aList.Add('Herault');
		aList.Add('Ille-et-Vilaine');
		aList.Add('Indre');
		aList.Add('Indre-et-Loire');
		aList.Add('Isere');
		aList.Add('Jura');
		aList.Add('Landes');
		aList.Add('Loir-et-Cher');
		aList.Add('Loire');
		aList.Add('Loire-Atlantique');
		aList.Add('Loiret');
		aList.Add('Lot');
		aList.Add('Lot-et-Garonne');
		aList.Add('Lozere');
		aList.Add('Maine-et-Loire');
		aList.Add('Manche');
		aList.Add('Marne');
		aList.Add('Mayenne');
		aList.Add('Meurthe-et-Moselle');
		aList.Add('Meuse');
		aList.Add('Morbihan');
		aList.Add('Moselle');
		aList.Add('Nievre');
		aList.Add('Nord');
		aList.Add('Oise');
		aList.Add('Orne');
		aList.Add('Pas-de-Calais');
		aList.Add('Puy-de-Dome');
		aList.Add('Pyrenees-Atlantiques');
		aList.Add('Pyrenees-Orientales');
		aList.Add('Rhone');
		aList.Add('Saone-et-Loire');
		aList.Add('Sarthe');
		aList.Add('Savoie');
		aList.Add('Seine-Maritime');
		aList.Add('Seine-Saint-Denis');
		aList.Add('Seine-et-Marne');
		aList.Add('Somme');
		aList.Add('Tarn');
		aList.Add('Tarn-et-Garonne');
		aList.Add('Terr. de Belfort');
		aList.Add('Val-d''Oise');
		aList.Add('Val-de-Marne');
		aList.Add('Var');
		aList.Add('Vaucluse');
		aList.Add('Vendee');
		aList.Add('Vienne');
		aList.Add('Ville-de-Paris');
		aList.Add('Vosges');
		aList.Add('Yonne');
		aList.Add('Yvelines');
    end
    else if CountryCode = 'UK' then
    begin
    end
    else if CountryCode = 'CH' then
    begin
		aList.Add('Aargau');
		aList.Add('Appenzell');
		aList.Add('Basel');
		aList.Add('Bern');
		aList.Add('Fribourg');
		aList.Add('Geneva');
		aList.Add('Glarus');
		aList.Add('Graubunden');
		aList.Add('Jura');
		aList.Add('Lucerne');
		aList.Add('Neuchatel');
		aList.Add('Saint Gall');
		aList.Add('Schaffhausen');
		aList.Add('Schwyz');
		aList.Add('Solothurn');
		aList.Add('Thurgau');
		aList.Add('Ticino');
		aList.Add('Unterwalden');
		aList.Add('Uri');
		aList.Add('Valais');
		aList.Add('Vaud');
		aList.Add('Zug');
		aList.Add('Zurich');
    end
    else if CountryCode = 'AT' then
    begin
		aList.Add('Burgenland');
		aList.Add('Carinthia');
		aList.Add('Lower Austria');
		aList.Add('Salzburg');
		aList.Add('Styria');
		aList.Add('Tirol');
		aList.Add('Upper Austria');
		aList.Add('Vienna');
		aList.Add('Vorarlberg');
	end
    else if CountryCode = 'ES' then
    begin
		aList.Add('Alava');
		aList.Add('Albacete');
		aList.Add('Alicante');
		aList.Add('Almeria');
		aList.Add('Avila');
		aList.Add('Badajoz');
		aList.Add('Baleares');
		aList.Add('Balearic Islands');
		aList.Add('Barcelona');
		aList.Add('Burgos');
		aList.Add('Caceres');
		aList.Add('Cadiz');
		aList.Add('Canary Islands');
		aList.Add('Castellon de Plana');
		aList.Add('Ciudad Real');
		aList.Add('Cordoba');
		aList.Add('Cuenca');
		aList.Add('Gerona');
		aList.Add('Granada');
		aList.Add('Guadalajara');
		aList.Add('Guipuzcoa');
		aList.Add('Huelva');
		aList.Add('Huesca');
		aList.Add('Jaen');
		aList.Add('La Coruna');
		aList.Add('La Palmas');
		aList.Add('Leon');
		aList.Add('Lerida');
		aList.Add('Logrono');
		aList.Add('Lugo');
		aList.Add('Madrid');
		aList.Add('Malaga');
		aList.Add('Murcia');
		aList.Add('Navarra');
		aList.Add('Orense');
		aList.Add('Oviedo');
		aList.Add('Palencia');
		aList.Add('Pontevedra');
		aList.Add('Salamanca');
		aList.Add('Santa Cruz Tenerife');
		aList.Add('Santander');
		aList.Add('Segovia');
		aList.Add('Sevilla');
		aList.Add('Soria');
		aList.Add('Tarragona');
		aList.Add('Teruel');
		aList.Add('Toledo');
		aList.Add('Valencia');
		aList.Add('Valladolid');
		aList.Add('Vizcaya');
		aList.Add('Zamora');
		aList.Add('Zaragoza');
    end
	else if CountryCode = 'IT' then
    begin
		aList.Add('Abruzzi');
		aList.Add('Apulia');
		aList.Add('Basilicata');
		aList.Add('Calabria');
		aList.Add('Campania');
		aList.Add('Emilia-Romagna');
		aList.Add('Friuli-Venezia');
		aList.Add('Latium');
		aList.Add('Liguria');
		aList.Add('Lombardy');
		aList.Add('Marches');
		aList.Add('Molise');
		aList.Add('Piedmont');
		aList.Add('Sardinia');
		aList.Add('Sicily');
		aList.Add('Trentino-Alto Adige');
		aList.Add('Tuscany');
		aList.Add('Umbria');
		aList.Add('Valle d''Aosta');
		aList.Add('Veneto');
    end
    else if CountryCode = 'DA' then
    begin
		aList.Add('Arhus');
		aList.Add('Bornholm');
		aList.Add('Copenhagen');
		aList.Add('Frederiksberg');
		aList.Add('Fyn');
		aList.Add('Nordjylland');
		aList.Add('Ribe');
		aList.Add('Ringkobing');
		aList.Add('Roskilde');
		aList.Add('Sonderjylland');
		aList.Add('Storstrom');
		aList.Add('Vejle');
		aList.Add('Vestsjaelland');
		aList.Add('Viborg');
    end
    else if CountryCode = 'SV' then
    begin
		aList.Add('Alvsborg');
		aList.Add('Blekinge');
		aList.Add('Gavleborg');
		aList.Add('Goteborg and Bohus');
		aList.Add('Gotland');
		aList.Add('Halland');
		aList.Add('Jamtland');
		aList.Add('Jonkoping');
		aList.Add('Kalmar');
		aList.Add('Kopparberg');
		aList.Add('Kristianstad');
		aList.Add('Kronoberg');
		aList.Add('Malmohus');
		aList.Add('Norrbotten');
		aList.Add('Orebro');
		aList.Add('Ostergotland');
		aList.Add('Skaraborg');
		aList.Add('Sodermanland');
		aList.Add('Stockholm');
		aList.Add('Uppsala');
		aList.Add('Varmland');
		aList.Add('Vasterbotten');
		aList.Add('Vasternorrland');
		aList.Add('Vastmanland');
    end
    else
        aList.Clear;

end;
// ----------------------------------------------------------------------------
function GetCountryCode:String;
begin
    Result := GetCodeFromCountryName(GetEnglishCountryName);
end;
// ----------------------------------------------------------------------------
function GetEnglishCountryName:String;
begin
    {$IFDEF WIN32}
    Result := GetLocaleStr(LOCALE_USER_DEFAULT,LOCALE_SENGCOUNTRY,'');
    {$ENDIF}
end;
// ----------------------------------------------------------------------------
function GetSystemCountryNumber:String;
begin
    {$IFDEF WIN32}
	Result := GetLocaleStr(LOCALE_USER_DEFAULT,LOCALE_ICOUNTRY,'1');
    {$ENDIF}
end;
// ----------------------------------------------------------------------------
function GetSoftwareInstallDir(ProductName : String):String;
var
    k,s : String;
begin
    // -- Look and ask the registry where the software was installed
    if ProductName = '' then
        k := gtKeyPath + Application.Title
    else
        k := gtKeyPath + ProductName;

    {$IFDEF WIN32}
    s := '';
	if GetRegistryString(Pchar(k),'Install_Dir',s) then
        Result := s
	else
		Result := '';
    {$ENDIF}
end;
// ----------------------------------------------------------------------------
function GetConfigString(SectionName,ElementName : String; var ValueStr : String):Boolean;
{$IFDEF WIN32}
var
	configDataHandle : HKEY;
	textbuff : array[1..500] of byte;
	textbufflen : Integer;
	xc 	   : Integer;
	s		: String;
	lpType : DWORD;
begin
	Result := False;

	// -- Build the section name
	s := SectionName;

	// -- By default we return nothing
    ValueStr := '';

	// -- Open the string
	if (0 = RegOpenKey(HKEY_LOCAL_MACHINE,PChar(s),configDataHandle)) then
	begin
		// -- Look for the version
		textbufflen := sizeof(textbuff);
		xc:=RegQueryValueEx(configDataHandle,PChar(ElementName),nil,LPDWORD(@lpType),@textbuff,LPDWORD(@textbufflen));
		if (xc=0) then
		begin
			// -- Write the new updated value
			if (textbufflen > 0) then
                ValueStr := StrPas(@textbuff);
			Result := True;
		end;

		RegCloseKey(configDataHandle);

	end;
{$ELSE}
begin
{$ENDIF}
end;
//---------------------------------------------------------------------------
function GetConfigInt(SectionName,ElementName : String; var ValueInt : Integer):Boolean;
{$IFDEF WIN32}
var
	configDataHandle : HKEY;
	intbuff,
	intbufflen  : Integer;
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
		intbufflen := sizeof(ValueInt);

		xc:=RegQueryValueEx(configDataHandle,PChar(ElementName),nil,LPDWORD(@lpType),@intbuff,LPDWORD(@intbufflen));
		if (xc=0) then
		begin
			// -- Write the new updated value
			ValueInt := IntBuff;
			Result := True;
		end;

		RegCloseKey(configDataHandle);

	end;
{$ELSE}
begin
{$ENDIF}
end;
//---------------------------------------------------------------------------
function GetNextConfigInt(SectionName,ElementName : String; var ValueInt : Integer):Boolean;
{$IFDEF WIN32}
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

{$ELSE}
begin
{$ENDIF}
end;
//---------------------------------------------------------------------------
// -- Generic functions
function GetSettingString(SectionName,ElementName : String; var ValueStr : String):Boolean;
begin
	Result := GetConfigString(gtKeyPath + SectionName,ElementName,ValueStr);
end;
//---------------------------------------------------------------------------
function GetSettingInt(SectionName,ElementName : String; var ValueInt : Integer):Boolean;
begin
	Result := GetConfigInt(gtKeyPath + SectionName,ElementName, ValueInt);
end;
//---------------------------------------------------------------------------
function GetNextSettingInt(SectionName,ElementName : String; var ValueInt : Integer):Boolean;
begin
	Result := GetNextConfigInt(gtKeyPath + SectionName,ElementName,ValueInt);
end;
//---------------------------------------------------------------------------
function SaveRegistryString(SectionName,ElementName : String; ValueStr : String):Boolean;
{$IFDEF WIN32}
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
	s := SectionName;

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
{$ELSE}
begin
{$ENDIF}
end;
//---------------------------------------------------------------------------
function SaveSettingString(SectionName,ElementName : String; ValueStr : String):Boolean;
begin
	Result := SaveRegistryString(gtKeyPath + SectionName,ElementName,ValueStr);
end;
//---------------------------------------------------------------------------
function SaveSettingInt(SectionName,ElementName : String; ValueInt : Integer):Boolean;
{$IFDEF WIN32}
var
	i : Integer;
	configDataHandle : HKEY;
	xc 	   : Integer;
	s		: String;
	lpType, lpLen : DWORD;
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
	lpType := REG_DWORD;
	lpLen := Sizeof(ValueInt);

	xc:=RegSetValueEx(configDataHandle,PChar(ElementName),0,lpType,@ValueInt,lpLen);
	if (xc = 0) then
	begin
		// -- Write the new updated value
		Result := True;
	end;

	RegCloseKey(configDataHandle);
{$ELSE}
begin
{$ENDIF}
end;
//---------------------------------------------------------------------------
function GetRegistryString(SectionName,ElementName : String; var ValueStr : String):Boolean;
{$IFDEF WIN32}
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
	s := SectionName;

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
            if textbufflen > 0 then
			    ValueStr := StrPas(@textbuff);
			Result := True;
		end;

		RegCloseKey(configDataHandle);

	end;
{$ELSE}
begin
{$ENDIF}
end;
//---------------------------------------------------------------------------
function GetBuildInfoString: String;

	function ConvertToCString(aString : String):String;
    var
        s : String;
        xc,xd : Integer;
    begin
        s := '';
        xd := Length(aString);
        for xc := 1 to xd do
			if aString[xc] = '\' then
                s := s + '\\'
            else
                s := s + aString[xc];
        Result := s;
    end;

    procedure GetBuildInfo(var V1, V2, V3, V4: Word);
    {$IFDEF WIN32}
    var
       VerInfoSize: DWORD;
	   VerInfo: Pointer;
       VerValueSize: DWORD;
       VerValue: PVSFixedFileInfo;
       Dummy: DWORD;
       myName : String;
    begin
     myName := ParamStr(0);

     VerInfoSize := GetFileVersionInfoSize(PChar(myName), Dummy);
     if VerInfoSize = 0 then
		Exit;

     GetMem(VerInfo, VerInfoSize);
     GetFileVersionInfo(PChar(ParamStr(0)), 0, VerInfoSize, VerInfo);
     VerQueryValue(VerInfo, '\', Pointer(VerValue), VerValueSize);
     with VerValue^ do
       begin
       V1 := dwFileVersionMS shr 16;
	   V2 := dwFileVersionMS and $FFFF;
	   V3 := dwFileVersionLS shr 16;
	   V4 := dwFileVersionLS and $FFFF;
	   end;
	 FreeMem(VerInfo, VerInfoSize);
        {$ELSE}
        begin
        {$ENDIF}
	end;
var
	V1, V2, V3, V4: Word;
begin
	GetBuildInfo(V1, V2, V3, V4);
	Result := Format('Version %d.%d. Release %d. Build %d', [V1, V2, V3, V4]);
end;
//---------------------------------------------------------------------------
// -- Function to encode a value as an SQL string
function EncodeSQLString(S : String):String;
var
    i : Integer;
    t : String;
    c : Char;
begin
    t := '';
    for i := 1 to Length(s) do
    begin
        c := S[i];
        if (c = '''') then
            t := t + ''''''
        else
            t := t + c;
    end;
	Result := '''' + t + '''';
end;
//---------------------------------------------------------------------------
// -- Function to determine if a string is made from numbers
function isNumber(S : String; ExtraChars : String):Boolean;
var
	xc : Integer;
	AllowedChars : String;
begin
	Result := True;
	if S = '' then
		Exit;

	AllowedChars := '0123456789' + ExtraChars;

	for xc := 1 to Length(S) do
	begin
		if (Pos(s[xc],AllowedChars) = 0) then
		begin
			Result := False;
			break;
		end;
	end;

end;
//---------------------------------------------------------------------------
// -- Function to convert a number to the local currency
function AsCurrency(Val : Double; CountryCode : String):String;
begin
	Result := Format('%m',[Val]);
end;
//---------------------------------------------------------------------------
{$IFDEF WIN32}
procedure GetAliases (const AList: TStrings; Const IncludeTypes : String);
var
  i    : Integer;
  Desc : DBDesc;
  Buff : Array [0..254] Of char;
begin
  // list all BDE aliases
  Session.GetAliasNames (AList);

  if IncludeTypes <> '' then
  begin
      for i := AList.Count - 1 downto 0 do
      begin
        StrPCopy (Buff, AList[i]);
        Check (DbiGetDatabaseDesc (Buff, @Desc));
        if (0 = Pos('P',IncludeTypes)) then
        begin
            // -- Paradox and Dbase
			if StrPas (Desc.szDBType) = 'STANDARD' then
              AList.Delete (i)
        end
        else if (0 = Pos('O',IncludeTypes)) then
        begin
            // -- ODBC
            if StrPas (Desc.szDBType) = 'ODBC' then
              AList.Delete (i)
        end
        else if (0 = Pos('M',IncludeTypes)) then
		begin
			// -- MSAccess
            if StrPas (Desc.szDBType) = 'MSACCESS' then
              AList.Delete (i)
        end
        else if (0 = Pos('I',IncludeTypes)) then
        begin
            // -- Interbase
			if StrPas (Desc.szDBType) = 'INTERBASE' then
              AList.Delete (i)
        end;

      end
  end;
end;
{$ENDIF}
//--------------------------------------------------------------------------
function GetCurrentUserName:String;
{$IFDEF LINUX}
begin
end;
{$ELSE}
var
	ubuff : Array[1..60] of char;
	bsize : DWORD;
begin
	bsize := sizeof(ubuff);
	if GetUserName(@ubuff,bsize) then
	begin
		Result := StrPas(@ubuff);
	end;
end;
{$ENDIF}
//--------------------------------------------------------------------------
// Read the name of the machine from the registry
function GetMachineName:String;
var
	m : String;
begin
	{$IFDEF LINUX}
	{$ELSE}
	if GetRegistryString('SYSTEM\CurrentControlSet\Control\ComputerName\ComputerName','ComputerName',m) then
		Result := m
	else
		Result := '';
	{$ENDIF}
end;

//--------------------------------------------------------------------------
//CRC algorithm courtesy of Earl F. Glynn ...
//(http://www.efg2.com/Lab/Mathematics/CRC.htm)
function CalcCRC32(p: pchar; length: integer): dword;
const
  table:  ARRAY[0..255] OF DWORD =
 ($00000000, $77073096, $EE0E612C, $990951BA,
  $076DC419, $706AF48F, $E963A535, $9E6495A3,
  $0EDB8832, $79DCB8A4, $E0D5E91E, $97D2D988,
  $09B64C2B, $7EB17CBD, $E7B82D07, $90BF1D91,
  $1DB71064, $6AB020F2, $F3B97148, $84BE41DE,
  $1ADAD47D, $6DDDE4EB, $F4D4B551, $83D385C7,
  $136C9856, $646BA8C0, $FD62F97A, $8A65C9EC,
  $14015C4F, $63066CD9, $FA0F3D63, $8D080DF5,
  $3B6E20C8, $4C69105E, $D56041E4, $A2677172,
  $3C03E4D1, $4B04D447, $D20D85FD, $A50AB56B,
  $35B5A8FA, $42B2986C, $DBBBC9D6, $ACBCF940,
  $32D86CE3, $45DF5C75, $DCD60DCF, $ABD13D59,
  $26D930AC, $51DE003A, $C8D75180, $BFD06116,
  $21B4F4B5, $56B3C423, $CFBA9599, $B8BDA50F,
  $2802B89E, $5F058808, $C60CD9B2, $B10BE924,
  $2F6F7C87, $58684C11, $C1611DAB, $B6662D3D,

  $76DC4190, $01DB7106, $98D220BC, $EFD5102A,
  $71B18589, $06B6B51F, $9FBFE4A5, $E8B8D433,
  $7807C9A2, $0F00F934, $9609A88E, $E10E9818,
  $7F6A0DBB, $086D3D2D, $91646C97, $E6635C01,
  $6B6B51F4, $1C6C6162, $856530D8, $F262004E,
  $6C0695ED, $1B01A57B, $8208F4C1, $F50FC457,
  $65B0D9C6, $12B7E950, $8BBEB8EA, $FCB9887C,
  $62DD1DDF, $15DA2D49, $8CD37CF3, $FBD44C65,
  $4DB26158, $3AB551CE, $A3BC0074, $D4BB30E2,
  $4ADFA541, $3DD895D7, $A4D1C46D, $D3D6F4FB,
  $4369E96A, $346ED9FC, $AD678846, $DA60B8D0,
  $44042D73, $33031DE5, $AA0A4C5F, $DD0D7CC9,
  $5005713C, $270241AA, $BE0B1010, $C90C2086,
  $5768B525, $206F85B3, $B966D409, $CE61E49F,
  $5EDEF90E, $29D9C998, $B0D09822, $C7D7A8B4,
  $59B33D17, $2EB40D81, $B7BD5C3B, $C0BA6CAD,

  $EDB88320, $9ABFB3B6, $03B6E20C, $74B1D29A,
  $EAD54739, $9DD277AF, $04DB2615, $73DC1683,
  $E3630B12, $94643B84, $0D6D6A3E, $7A6A5AA8,
  $E40ECF0B, $9309FF9D, $0A00AE27, $7D079EB1,
  $F00F9344, $8708A3D2, $1E01F268, $6906C2FE,
  $F762575D, $806567CB, $196C3671, $6E6B06E7,
  $FED41B76, $89D32BE0, $10DA7A5A, $67DD4ACC,
  $F9B9DF6F, $8EBEEFF9, $17B7BE43, $60B08ED5,
  $D6D6A3E8, $A1D1937E, $38D8C2C4, $4FDFF252,
  $D1BB67F1, $A6BC5767, $3FB506DD, $48B2364B,
  $D80D2BDA, $AF0A1B4C, $36034AF6, $41047A60,
  $DF60EFC3, $A867DF55, $316E8EEF, $4669BE79,
  $CB61B38C, $BC66831A, $256FD2A0, $5268E236,
  $CC0C7795, $BB0B4703, $220216B9, $5505262F,
  $C5BA3BBE, $B2BD0B28, $2BB45A92, $5CB36A04,
  $C2D7FFA7, $B5D0CF31, $2CD99E8B, $5BDEAE1D,

  $9B64C2B0, $EC63F226, $756AA39C, $026D930A,
  $9C0906A9, $EB0E363F, $72076785, $05005713,
  $95BF4A82, $E2B87A14, $7BB12BAE, $0CB61B38,
  $92D28E9B, $E5D5BE0D, $7CDCEFB7, $0BDBDF21,
  $86D3D2D4, $F1D4E242, $68DDB3F8, $1FDA836E,
  $81BE16CD, $F6B9265B, $6FB077E1, $18B74777,
  $88085AE6, $FF0F6A70, $66063BCA, $11010B5C,
  $8F659EFF, $F862AE69, $616BFFD3, $166CCF45,
  $A00AE278, $D70DD2EE, $4E048354, $3903B3C2,
  $A7672661, $D06016F7, $4969474D, $3E6E77DB,
  $AED16A4A, $D9D65ADC, $40DF0B66, $37D83BF0,
  $A9BCAE53, $DEBB9EC5, $47B2CF7F, $30B5FFE9,
  $BDBDF21C, $CABAC28A, $53B39330, $24B4A3A6,
  $BAD03605, $CDD70693, $54DE5729, $23D967BF,
  $B3667A2E, $C4614AB8, $5D681B02, $2A6F2B94,
  $B40BBE37, $C30C8EA1, $5A05DF1B, $2D02EF8D);
var
  i: integer;
begin
  result := $FFFFFFFF;
  for i := 0 to length-1 do
  begin
    result := (result shr 8) xor table[ pbyte(p)^ xor (result and $000000ff) ];
    inc(p);
  end;
  result := not result;
end;
//--------------------------------------------------------------------------
function HashLine(const line: string; IgnoreCase, IgnoreBlanks: boolean): pointer;
var
  i, j, len: integer;
  s: string;
begin
  s := line;
  if IgnoreBlanks then
  begin
	i := 1;
    j := 1;
    len := length(line);
    while i <= len do
    begin
      if not (line[i] in [#9,#32]) then
	  begin
        s[j] := line[i];
		inc(j);
      end;
	  inc(i);
    end;
    setlength(s,j-1);
  end;
  if IgnoreCase then s := AnsiLowerCase(s);
  //return result as a pointer to save typecasting later...
  result := pointer(CalcCRC32(pchar(s), length(s)));
end;
//---------------------------------------------------------------------
function StringListToString(aList : TStrings):String;
var
	xc : Integer;
begin
	// -- Add every string in the list
	for xc := 1 to aList.Count do
		Result := Result + aList[xc-1] + #13;
end;
//---------------------------------------------------------------------
function pad(s:string; n:integer): string;
var
	l: integer;
begin
	l := length(s);
	if (l < n) and (n < 255) then
	while l<n do
	begin
		s := s + ' ';
		inc(l);
	end;
	pad := s;
end;
//---------------------------------------------------------------------
function GTDDocumentRegistry.ProcessAutoSubscribe(LoginLine : String; var newTID:Integer; var newCID:Integer):Boolean;
var
	myNode : GTDNode;
	p : String;
	cid : Integer;
begin
	myNode := GTDNode.Create;
	myNode.UseSingleLine(LoginLine);

	Result := False;

	if (myNode.ReadStringField(GTD_LGN_ELE_COMPANY_NAME) <> '') and
	   (myNode.ReadStringField(GTD_LGN_ELE_TOWN) <> '') and
	   (myNode.ReadStringField(GTD_LGN_ELE_COUNTRYCODE) <> '') then
	begin
		{$IFNDEF LIGHTWEIGHT}
		// -- Createthe Customer in the Trader Table
		try

			with fTraderTbl do
			begin

				if not Active then
					Active := True;

				Append;
				FieldByName(GTD_DB_COL_COMPANY_NAME).AsString := myNode.ReadStringField(GTD_LGN_ELE_COMPANY_NAME);
				FieldByName(GTD_DB_COL_ADDRESS_LINE_1).AsString := myNode.ReadStringField(GTD_LGN_ELE_ADDRESS_LINE_1);
				FieldByName(GTD_DB_COL_ADDRESS_LINE_2).AsString := myNode.ReadStringField(GTD_LGN_ELE_ADDRESS_LINE_2);
				FieldByName(GTD_DB_COL_TOWN).AsString := myNode.ReadStringField(GTD_LGN_ELE_TOWN);
				FieldByName(GTD_DB_COL_STATE_REGION).AsString := myNode.ReadStringField(GTD_LGN_ELE_STATE_REGION);
				FieldByName(GTD_DB_COL_POSTALCODE).AsString := myNode.ReadStringField(GTD_LGN_ELE_POSTALCODE);
				FieldByName(GTD_DB_COL_COUNTRYCODE).AsString := myNode.ReadStringField(GTD_LGN_ELE_COUNTRYCODE);

				FieldByName(GTD_DB_COL_RELATIONSHIP).AsString := myNode.ReadStringField(GTD_LGN_ELE_COUNTRYCODE);
				FieldByName(GTD_DB_COL_STATUS_CODE).AsString := myNode.ReadStringField(GTD_LGN_ELE_COUNTRYCODE);
				fTraderTbl.Post;

				fTraderTbl.Refresh;
			end;

			// -- Pull out the bext id
			if GetNextSettingInt('Global','Last_Connection_ID',cid) then
				SaveTraderAccessInfo(fTraderTbl.FieldByName('Trader_ID').AsInteger,cid,p);

			// -- We have to send back this value later
			newTID := fTraderTbl.FieldByName('Trader_ID').AsInteger;
			newCID := cid;

			Result := True;
		except
			Result := False;
		end;
		{$ENDIF}
	end;

	myNode.Destroy;
end;
//---------------------------------------------------------------------
//
// The customer number must be stored in the registry
//
function  GTDDocumentRegistry.GetCustomerNumber:Integer;
var
	s : String;
begin
	if GetRegistryString(gtKeyPath + GTD_REG_NOD_GENERAL,GTD_REG_XCHG_CUSTOMERID,s) then
	begin
		Result := StrToInt(LoPowerDecrypt(s));
	end
	else
		Result := -1;
end;
//---------------------------------------------------------------------
procedure GTDDocumentRegistry.SaveCustomerNumber(NewNumber:Integer; NewPassword : String);
begin
	SaveRegistryString(gtKeyPath + GTD_REG_NOD_GENERAL,GTD_REG_XCHG_CUSTOMERID,LoPowerEncrypt(IntToStr(NewNumber)));
    if (NewPassword <> '') then
        SaveCustomerPassword(NewPassword);
end;
//---------------------------------------------------------------------
//
// The customer number must be stored in the registry
//
function  GTDDocumentRegistry.GetCustomerPassword:String;
var
	s : String;
begin
	if GetRegistryString(gtKeyPath + GTD_REG_NOD_GENERAL,GTD_REG_XCHG_PASSWORD,s) then
	begin
		Result := LoPowerDecrypt(s);
	end
	else
		Result := '';
end;
//---------------------------------------------------------------------
procedure GTDDocumentRegistry.SaveCustomerPassword(NewPassword:String);
begin
	SaveRegistryString(gtKeyPath + GTD_REG_NOD_GENERAL,GTD_REG_XCHG_PASSWORD,LoPowerEncrypt(NewPassword));
end;
//---------------------------------------------------------------------
function GTDDocumentRegistry.GetSupplierAccessInfo(Trader_ID : Integer; var requiredConnection_ID : Integer; var Password : String):Boolean;
{$IFDEF WIN32}
var
	k : String;
	cn : Integer;
	qryFindKey : TQuery;
begin
	Result := False;

	cn := GetCustomerNumber;
	if (cn = -1) then
		Exit;

	// -- Build up the key, my customer + their trzder #
	k := IntToStr(cn) + '/' + IntToStr(Trader_ID);

	// -- Setup the Database information
	qryFindKey := TQuery.Create(Self);

	with qryFindKey do
	begin

		DatabaseName := fDatabaseName;
		SessionName  := fSessionName;

		SQL.Clear;

		SQL.Add('Select');
		SQL.Add('    *');
		SQL.Add('from');
		SQL.Add('    Trader_Keys');
		SQL.Add('where');
		SQL.Add('    (key_reference = "' + k + '")');

		Active := True;
		First;
		if not Eof then
		begin
			// --
			Password := LoPowerDecrypt(FieldByName('Key_Value').AsString);
			requiredConnection_ID := FieldByName('Connection_ID').AsInteger;
			Result := True;
		end
		else
			;

		Destroy;
	end;
{$ELSE}
begin
{$ENDIF}
end;
//---------------------------------------------------------------------
function GTDDocumentRegistry.GetCustomerAccessInfo(Trader_ID : Integer; requiredConnection_ID : Integer; var Password : String):Boolean;
{$IFDEF WIN32}
var
	k : String;
	qryFindKey : TQuery;
begin
	Result := False;

	// -- Build up the key, my customer + their trzder #
	k := IntToStr(requiredConnection_ID) + '/' + IntToStr(Trader_ID);

	// -- Setup the Database information
	qryFindKey := TQuery.Create(Self);

	with qryFindKey do
	begin

		DatabaseName := fDatabaseName;
		SessionName  := fSessionName;

		SQL.Clear;

		SQL.Add('Select');
		SQL.Add('    *');
		SQL.Add('from');
		SQL.Add('    Trader_Keys');
		SQL.Add('where');
		SQL.Add('    (key_reference = "' + k + '")');

		Active := True;
		First;
		if not Eof then
		begin
			// --
			Password := LoPowerDecrypt(FieldByName('Key_Value').AsString);
			requiredConnection_ID := FieldByName('Connection_ID').AsInteger;
			Result := True;
		end
		else
			;

		Destroy;
	end;
{$ELSE}
begin
{$ENDIF}
end;
//---------------------------------------------------------------------
function GTDDocumentRegistry.SaveTraderAccessInfo(Trader_ID : Integer; Connection_ID : Integer; Password : String):Boolean;
var
	k : String;
begin
	// -- Build up the key, my customer + their trzder #
	k := IntToStr(Connection_ID) + '/' + IntToStr(Trader_ID);

	// -- Now create an accesskey for next time
	{$IFNDEF LIGHTWEIGHT}
	if not fKeyTbl.Active then
		fKeyTbl.Active := True;

	fKeyTbl.Append;
	fKeyTbl.FieldByName('Key_Reference').AsString  := k;
	fKeyTbl.FieldByName('Connection_ID').AsInteger := Connection_ID;
	fKeyTbl.FieldByName('Key_Type').AsString := 'Workstation';
	fKeyTbl.FieldByName('Status_Code').AsString := 'Active';
	fKeyTbl.FieldByName('Key_Value').AsString := LoPowerEncrypt(Password);
	fKeyTbl.Post;
	{$ENDIF}
	
	Result := True;
end;
//---------------------------------------------------------------------
function BuildTraderAddress(a1, a2, city, state, postcode, countrycode, tel1, tel2, acn : String):String;
var
	AddrString : String;
begin
	AddrString := '';

	if (a1 <> '') then
		AddrString := a1 + #13;
	if (a2 <> '') then
		AddrString := AddrString + a2 + #13;
	if (city <> '') then
		AddrString := AddrString + city;
	if (state <> '') then
		AddrString := AddrString + ', ' + state;
	if (countrycode <> '') then
		AddrString := AddrString + ', ' + GetNameFromCountryCode(countrycode);

	// -- Terminate the last compound line with a carriage
	if (city <> '') or (state <> '') or (postcode <> '') or (countrycode <> '') then
		AddrString := AddrString + #13;

	if tel1 <> '' then
	begin
		AddrString := AddrString + 'Tel: ' + tel1;
		if tel2 <> '' then
			AddrString := AddrString + ' ' + ' - ' + tel2 + #13
		else
			AddrString := AddrString + #13;
	end;

	// -- This line holds registration details such as ABN# etc
	if acn <> '' then
	begin
		AddrString := AddrString + acn;
	end;

	Result := AddrString;

end;
//---------------------------------------------------------------------------
{$IFDEF WIN32}
function RunAProgram (const theProgram, itsParameters, defaultDirectory: string; QuietMode : boolean; var ErrorMessage : String):Boolean;
var
  rslt: integer;
  msg: string;
begin
	Result := False;
	rslt := ShellExecute(0, 'open',
					   pChar (theProgram),
					   pChar (itsParameters),
					   pChar (defaultDirectory),
					   sw_ShowNormal);
	if rslt <= 32 then
	begin
	  case rslt of
		0,
		se_err_OOM:
		  msg := 'Out of memory/resources';
		error_File_Not_Found:
		  msg := 'File "' + theProgram + '" not found';
		error_Path_Not_Found:
		  msg := 'Path not found';
		error_Bad_Format:
		  msg := 'Damaged or invalid exe';
		se_err_AccessDenied:
		  msg := 'Access denied';
		se_err_NoAssoc,
		se_err_AssocIncomplete:
		  msg := 'Filename association invalid';
		se_err_DDEBusy,
		se_err_DDEFail,
		se_err_DDETimeOut:
		  msg := 'DDE error';
		se_err_Share:
		  msg := 'Sharing violation';
		else
		  msg := 'no text';
	  end;

	  // -- Build the error message
	  msg := 'Error running ' + theProgram + IntToStr (rslt) + ': ' + msg;

	  if not QuietMode then
		  raise Exception.Create(msg)
	  else
		  ErrorMessage := msg;

	end
	else begin
		msg := 'Program executed successfully';
		Result := True;
	end;
end;
//---------------------------------------------------------------------------
function ProgramRunWait(const CommandLine,DefaultDirectory: string; Wait, QuietMode : boolean; var ErrorMessage : String):Boolean;
var
  StartUpInfo: TStartUpInfo;
  ProcInfo: Process_Information;
  Dir, Msg: PChar;
  ErrNo: integer;
  E: Exception;
begin
  FillChar(StartUpInfo, SizeOf(StartUpInfo), 0);
  StartUpInfo.cb := SizeOf(StartUpInfo);
  if DefaultDirectory <> '' then
	Dir := PChar(DefaultDirectory)
  else
	Dir := nil;
  if CreateProcess(nil,
				   PChar(CommandLine),
				   nil,
				   nil,
				   False,
				   0,
				   nil,
				   Dir,
				   StartUpInfo,
				   ProcInfo) then
  begin
	try
	  if Wait then
		WaitForSingleObject(ProcInfo.hProcess,
							INFINITE);
	finally
	  CloseHandle(ProcInfo.hThread);
	  CloseHandle(ProcInfo.hProcess);
	end;
  end
  else
  begin
	ErrNo := GetLastError;
	Msg := AllocMem(4096);
	try
	  FormatMessage(FORMAT_MESSAGE_FROM_SYSTEM,
					nil,
					ErrNo,
					0,
					Msg,
					4096,
					nil);
	  E := Exception.Create('Create Process Error #'
							+ IntToStr(ErrNo)
							+ ': '
							+ string(Msg));
	finally
	  FreeMem(Msg);
	end;
	raise E;
  end;
end;
//---------------------------------------------------------------------------

// uses Windows, SysUtils
{
var hMyMutex : tHandle;
begin
  hMyMutex := CreateMutex (nil, True,
						   pChar (Uppercase (ExtractFileName (Application.ExeName))
  if (hMyMutex = 0) or (GetLastError = error_Already_Exists) then
	Application.Terminate
  try
	// the code maintained by Delphi
	Application.Initialize;
	. . .
  finally
	ReleaseMutex (hMyMutex);
  end;
end;
}

//---------------------------------------------------------------------------
function GetDesktopPath: string;
var
 PID: PItemIDList;
 Path: array[0..MAX_PATH-1] of Char;
begin
	// -- Retrieve our value
	SHGetSpecialFolderLocation(Application.Handle, CSIDL_DESKTOPDIRECTORY, PID);

	// -- These are some other possibles
	// CSIDL_BITBUCKET ‚²‚Ý”
	// CSIDL_DESKTOPDIRECTORY ƒfƒXƒNƒgƒbƒv
	// CSIDL_FAVORITES ‚¨‹C‚É“ü‚è
	// CSIDL_PERSONAL ƒ}ƒCƒhƒLƒ…ƒƒ“ƒg
	// CSIDL_PROGRAMS ƒXƒ^[ƒgƒƒjƒ…[‚ÌƒvƒƒOƒ‰ƒ€ƒtƒHƒ‹ƒ_
	// CSIDL_RECENT Å‹ßŽg‚Á‚½ƒtƒ@ƒCƒ‹
	// CSIDL_SENDTO ‘—‚é
	// CSIDL_STARTMENU ƒXƒ^[ƒgƒƒjƒ…[
	// CCSIDL_STARTUP

	SHGetPathFromIDList(PID, Path);
	Result:=Path;
end;
//---------------------------------------------------------------------------
function BDEAliasExists(DBName: string):Boolean;
const
  DescStr = 'Driver Name: %s'#13#10'AliasName: %s'#13#10 +
	'Text: %s'#13#10'Physical Name/Path: %s';
var
  dbDes: DBDesc;
  rc : DBIResult ;
begin
//	  Check(DbiGetDatabaseDesc(PChar(DBName), @dbDes));
  rc := DbiGetDatabaseDesc(PChar(DBName), @dbDes);
  if rc = 0 then
  begin
	Result := True;
	// with dbDes do ShowMessage(Format(DescStr, [szDbType, szName, szText, szPhyName]))
  end
  else
	Result := False;
//	ShowMessage('Not found');
end;
{$ENDIF}
//---------------------------------------------------------------------------
//
// Returns as a SQL formatted datetime
function AsSQLDateTime(anyDate : TDateTime):String;
begin
	Result := FormatDateTime('mm/dd/yy hh:nn:ss am/pm',anyDate);
end;
//---------------------------------------------------------------------------
function AsSQLDate(anyDate : TDateTime):String;
begin
	if {dbType = MYSQL} True then
		Result := FormatDateTime('yyyy-mm-dd',anyDate)
	else
		Result := FormatDateTime('mm/dd/yy',anyDate);
end;

//---------------------------------------------------------------------------
function LoadUserSkinForm(SkinData : TbsSkinData):Boolean;
begin
    if Assigned(SkinData.StoredSkin) then
        SkinData.StoredSkin.Filename := 'D:\Skins\Ampix3\skin.ini';


end;

//---------------------------------------------------------------------------
procedure Register;
begin
	 RegisterComponents('PreisShare', [GTDBizDoc]);
	 RegisterComponents('PreisShare', [GTDDocumentRegistry]);
end;
//---------------------------------------------------------------------------
Initialization
begin
	// -- Attempt to determine the standard database location
	if not GetRegistryString(gtKeyPath + GTD_REG_NOD_GENERAL,GTD_REG_BDE_ALIAS,GTD_ALIAS) then
    begin
    	if GetRegistryString(gtKeyPath + GTD_REG_NOD_GENERAL,GTD_REG_BDE_DIRECTORY,GTD_ALIAS) then
            // -- Our database directory has been set
        else
            // -- Otherwise use the standard alias
    		GTD_ALIAS := 'PREISSHARE';
    end;
end;


end.
