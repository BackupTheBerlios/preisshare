unit GTDStdBizDocEmailer;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  bsSkinCtrls, StdCtrls, bsSkinBoxCtrls, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdMessageClient, IdSMTP,IdMessage,
  GTDBizDocs,GTDBizLinks;

type
  TStdDocEmailer = class(TFrame)
    bsSkinPanel1: TbsSkinPanel;
    ggProgress: TbsSkinGauge;
    lstDisplay: TbsSkinMemo;
    btnSendCancel: TbsSkinButton;
    IdSMTP1: TIdSMTP;
    IdMessage1: TIdMessage;
    bsSkinButton1: TbsSkinButton;
    bsSkinButton2: TbsSkinButton;
    procedure btnSendCancelClick(Sender: TObject);
    procedure IdSMTP1Connected(Sender: TObject);
    procedure IdSMTP1Status(ASender: TObject; const AStatus: TIdStatus;
      const AStatusText: String);
    procedure bsSkinButton1Click(Sender: TObject);
    procedure IdSMTP1WorkEnd(Sender: TObject; AWorkMode: TWorkMode);
    procedure bsSkinButton2Click(Sender: TObject);
  private
    { Private declarations }
    procedure SetupMailerFromConfig;
  public
    Registry : GTDDocumentRegistry;

    { Public declarations }
    function SendDocumentAsPDF(dno : Integer; MsgSubject, MsgBody : WideString; SenderName:WideString='';SenderAddress:WideString='';ReceiverName:WideString='';ReceiverAddress:Widestring=''):Boolean;

    procedure ReportMessage(aMsg : WideString);
  end;

implementation

uses GTDStdDocToPDF;

{$R *.DFM}

function TStdDocEmailer.SendDocumentAsPDF(dno : Integer; MsgSubject, MsgBody : WideString; SenderName:WideString;SenderAddress:WideString;ReceiverName:WideString;ReceiverAddress:Widestring):Boolean;
var
    WorkingDoc : GTDBizDoc;
    n : WideString;
    s : String;

    procedure SetupMessageToFrom;
    begin
        // -- Setup the subject
        if MsgSubject <> '' then
            IdMessage1.Subject := MsgSubject
        else
            IdMessage1.Subject := WorkingDoc.Document_Type + ' ' + WorkingDoc.Document_Ref;

        // -- Setup the message body
        if MsgBody <> '' then
            IdMessage1.Body.Text := MsgBody
        else
            IdMessage1.Body.Text := 'Please find attached ' + IdMessage1.Subject;

        // -- Email Address of sender
        if SenderAddress <> '' then
            IdMessage1.From.Address := SenderAddress
        else begin
            // -- Otherwise use the username from the registry
            s := '';
            if GetRegistryString(gtKeyPath + GTD_REG_NOD_GENERAL,GTD_REG_EMAIL_USERNAME,s) then
                IdMessage1.From.Name := s;
        end;

        // -- Name of sender
        if SenderName <> '' then
            // -- Use the name provided
            IdMessage1.From.Name := SenderName
        else begin
            // -- Otherwise use the username from the registry
            s := '';
            if GetRegistryString(gtKeyPath + GTD_REG_NOD_GENERAL,GTD_REG_EMAIL_DISPLAYNAME,s) then
                IdMessage1.From.Name := s;
        end;

        // -- Recever name
        if ReceiverName <> '' then
        //    IdMessage1.Receiver.Name := ReceiverName
        else
        begin
        end;

        // -- Receiver Address
        if ReceiverAddress <> '' then
            IdMessage1.Recipients.Add.Address := ReceiverAddress
        else
        begin
        end;

    end;

begin
    WorkingDoc := GTDBizDoc.Create(Self);
    try

        // -- Load up the document
        if not Registry.Load(dno,WorkingDoc) then
        begin
            ReportMessage('Document not found');
            Exit;
        end;

        // -- Initialise the message
        IdMessage1.Clear;

        SetupMessageToFrom;

        // -- Build a pdf writer
        if not Assigned(rptPrintStdDocToPDF) then
            Application.CreateForm(TrptPrintStdDocToPDF, rptPrintStdDocToPDF);

        // -- Build a filename in the temporary directory
        n := GetTempDir + WorkingDoc.Document_Type + ' ' + WorkingDoc.Document_Ref + '.pdf';

        // -- Now create the file
        rptPrintStdDocToPDF.PrintDocToFile(WorkingDoc,n);

        // -- Add the attachment
        TIdAttachment.Create(IdMessage1.MessageParts,n); 

    finally
        WorkingDoc.Destroy;
    end;
end;

procedure TStdDocEmailer.SetupMailerFromConfig;
var
    s : String;
begin
    // -- Read the name of the mail host (this actually comes from the database)
    s := '';
    if GetRegistryString(gtKeyPath + GTD_REG_NOD_GENERAL,GTD_REG_EMAIL_HOST,s) then
        IdSMTP1.Host := s;
    IdSMTP1.Host := 'mail.computergrid.net';

    // -- Setup the user name
    s := '';
    if GetRegistryString(gtKeyPath + GTD_REG_NOD_GENERAL,GTD_REG_EMAIL_USERNAME,s) then
        IdSMTP1.Username := s;

    // -- Read the password
    s := '';
    if GetRegistryString(gtKeyPath + GTD_REG_NOD_GENERAL,GTD_REG_EMAIL_PASSWORD,s) then
        IdSMTP1.Password := s;

    // -- Read the Authentication type
    s := '';
    if GetRegistryString(gtKeyPath + GTD_REG_NOD_GENERAL,GTD_REG_EMAIL_LOGINREQ,s) then
    begin
        if s = 'True' then
        begin
            IdSMTP1.AuthenticationType := atLogin;
            IdSMTP1.MailAgent := IdSMTP1.Host;
        end
        else
            IdSMTP1.AuthenticationType := atNone;
    end
    else
        IdSMTP1.AuthenticationType := atNone;

    // -- Now setup the message

//	GTD_REG_EMAIL_DISPLAYNAME       = 'Email Display Name';

end;

procedure TStdDocEmailer.btnSendCancelClick(Sender: TObject);
begin
    if btnSendCancel.Caption = 'Send' then
    begin
        // IdSMTP1.Connect;
        SetupMailerFromConfig;
        IdSMTP1.Connect;
    end
    else begin
    end;
end;

procedure TStdDocEmailer.ReportMessage(aMsg : WideString);
begin
    lstDisplay.Lines.Add(aMsg);
end;

procedure TStdDocEmailer.IdSMTP1Connected(Sender: TObject);
begin
    ReportMessage('Connected to '+IdSMTP1.Host);
end;

procedure TStdDocEmailer.IdSMTP1Status(ASender: TObject;
  const AStatus: TIdStatus; const AStatusText: String);
begin
    ReportMessage(aStatusText);
end;

procedure TStdDocEmailer.bsSkinButton1Click(Sender: TObject);
begin
    IdSMTP1.Send(IdMessage1);
end;

procedure TStdDocEmailer.IdSMTP1WorkEnd(Sender: TObject;
  AWorkMode: TWorkMode);
begin
    ReportMessage('Message Sent');
end;

procedure TStdDocEmailer.bsSkinButton2Click(Sender: TObject);
begin
    TIdAttachment.Create(IdMessage1.MessageParts, 'C:\DOCUME~1\X\LOCALS~1\Temp\Purchase Order 1000.pdf');
end;

end.
