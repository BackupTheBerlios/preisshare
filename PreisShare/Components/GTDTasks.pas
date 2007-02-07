unit GTDTasks;

interface

uses
  {$IFDEF LINUX}
    SysUtils, Types, Classes, Variants, QTypes, QGraphics, QControls, QForms,
    QDialogs, QStdCtrls, DateUtils,QExtCtrls,
  {$ELSE}
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    StdCtrls, ToolWin, ComCtrls, FileCtrl, Db, DbTables, BDE, ShlObj,
    ShellAPI,
    {$IFNDEF HW_SIMPLE} jpeg ,GTDColorButtonList, {$ENDIF}
    extctrls, HCMngr, DiffUnit,
  {$ENDIF}

  GTDBizDocs,

  // -- Indy components
  IdBaseComponent, IdCoder, IdCoder3to4,
  IdCoderMIME, bsSkinBoxCtrls, DosCommand, bsSkinCtrls, SmtpProt, FtpCli,
  bsMessages,bsSkinData, Menus, bsSkinMenus, IdComponent, IdTCPConnection,
  IdTCPClient, IdFTP;

const
    GTTM_START_SEND = WM_APP + 306;
    GTTM_CLEANUP    = WM_APP + 307;
    GTTM_ERRSTART   = WM_APP + 308;
    GTTM_RUNNEXT    = WM_APP + 309;
    GTTM_FTPEVENT   = WM_APP + 310;
type
  TGTDTaskPanel = class(TFrame)
    DosCommand: TDosCommand;
    mmoReport: TbsSkinMemo;
    bsSkinSpeedButton1: TbsSkinSpeedButton;
    bsSkinSpeedButton2: TbsSkinSpeedButton;
    bsSkinSpeedButton3: TbsSkinSpeedButton;
    SmtpCli1: TSmtpCli;
    bsSkinGauge1: TbsSkinGauge;
    bsSkinMessage1: TbsSkinMessage;
    lstCheckList: TbsSkinListView;
    bsSkinPanel1: TbsSkinPanel;
    bsSkinPopupMenu1: TbsSkinPopupMenu;
    Run1: TMenuItem;
    Stop1: TMenuItem;
    cbxTasks: TbsSkinComboBox;
    btnShowDetails: TbsSkinSpeedButton;
    btnProcess: TbsSkinButton;
    ftpClient: TIdFTP;
    procedure DosCommandNewLine(Sender: TObject; NewLine: String;
      OutputType: TOutputType);
    procedure DosCommandTerminated(Sender: TObject);
    procedure bsSkinSpeedButton1Click(Sender: TObject);
    procedure bsSkinSpeedButton2Click(Sender: TObject);
    procedure bsSkinSpeedButton3Click(Sender: TObject);
    procedure SmtpCli1RequestDone(Sender: TObject; RqType: TSmtpRequest;
      ErrorCode: Word);
    procedure bsSkinSpeedButton4Click(Sender: TObject);
    procedure btnShowDetailsClick(Sender: TObject);
    procedure Run1Click(Sender: TObject);
    procedure btnProcessClick(Sender: TObject);
    procedure IdFTPClientStatus(ASender: TObject; const AStatus: TIdStatus;
      const AStatusText: String);
    procedure IdFTPClientAfterClientLogin(Sender: TObject);
    procedure FTPClientDisplay(Sender: TObject; var Msg: String);
    procedure ftpClientStatus(ASender: TObject; const AStatus: TIdStatus;
      const AStatusText: String);
    procedure ftpClientAfterClientLogin(Sender: TObject);
    procedure ftpClientWork(Sender: TObject; AWorkMode: TWorkMode;
      const AWorkCount: Integer);
  private
    { Private declarations }
    fTaskName,
    fProcessName,
    fEmailTemplate,
    fFTPTemplate,
    fFileList,
    fWorkDir,
    fTestEmailDest,
    fMainFile    : String;

    fSkinData   : TbsSkinData;

    currentDisplayItem : TListItem;
    runningAll : Boolean;
    runningItemNumber : Integer;

    procedure SetSkinData(newSkin : TbsSkinData);

  published

    property SkinData : TbsSkinData read fSkinData write SetSkinData;
    property TestEmailDest : String read fTestEmailDest write fTestEmailDest;

  public
    { Public declarations }
    DocumentRegistry : GTDDocumentRegistry;

    function Load(const TaskName : String):Boolean;
    procedure RunAll;
    function Start:Boolean;
    function Stop:Boolean;
    function StartProcessing:Boolean;
    function StartEmailDespatch:Boolean;
    function StartFTPDespatch:Boolean;
    procedure Report(const Msgtype : String; Const Description : String);

    procedure ProcessNextCommand(var aMsg : TMsg); message GTTM_START_SEND;
    procedure ProcessCleanup(var aMsg : TMsg); message GTTM_CLEANUP;
    procedure ProcessErrorStart(var aMsg : TMsg); message GTTM_ERRSTART;
    procedure ProcessRunNext(var aMsg : TMsg); message GTTM_RUNNEXT;
    procedure ProcessFTP(var aMsg : TMsg); message GTTM_FTPEVENT;
    procedure DisplayJobList;

  end;

implementation

{$R *.DFM}

//---------------------------------------------------------------------------
function TGTDTaskPanel.Load(const TaskName : String):Boolean;
var
    s : String;
    xc : Integer;
begin
    if not Assigned(DocumentRegistry) then
    begin
        Report('Error','Unable to load configuration. Document Registry not assigned');
        Exit;
    end;

    if not DocumentRegistry.GetSettingString('processjob',TaskName,s) then
    begin
        Report('Error','Unable to load configuration. Job details not found');
        Exit;
    end;

    // -- Find the task name in the current list
    currentDisplayItem := nil;
    for xc := 0 to lstCheckList.Items.Count-1 do
        if lstCheckList.Items[xc].SubItems[0] = TaskName then
        begin
            fTaskName := TaskName;
            currentDisplayItem := lstCheckList.Items[xc];
            break;
        end;

//    if DocumentRegistry.GetSettingMemoString('/process settings','mainfile',s) then
//        txtProFilename.Text := s
//    else
//        txtProFilename.Text := '';
//
//    if DocumentRegistry.GetSettingMemoString('/process settings','working-directory',s) then
//        txtWorkingDirectory.Text := s
//    else
//        txtWorkingDirectory.Text := '';
//

    // -- Initialisation
    fTaskName := TaskName;
    fProcessName := '';
    fFileList := '';
    fEmailTemplate := '';
    fFTPTemplate := '';
    fMainFile := '';

    // -- Read values from the configuration
    if DocumentRegistry.GetSettingMemoString('/process settings','mainfile',s) then
        fMainFile := s;

    if DocumentRegistry.GetSettingMemoString('/process settings','send-method',s) then
    begin
        if s = 'ftp' then
        begin
            if DocumentRegistry.GetSettingMemoString('/process settings','ftpsend-name',s) then
                fFTPTemplate := s;
        end
        else if s = 'email' then
        begin
            if DocumentRegistry.GetSettingMemoString('/process settings','emailsend-name',s) then
                fEmailTemplate := s;
        end;
    end;

    if DocumentRegistry.GetSettingMemoString('/process settings','process',s) then
    begin
        fProcessName := s;
    end;

    // -- Read the working directory
    if DocumentRegistry.GetSettingMemoString('/process settings','working-directory',s) then
    begin
        fWorkDir := s;
    end else
        fWorkDir := '';

    if DocumentRegistry.GetSettingMemoString('/process settings','sendfilelist',s) then
        fFileList := s;

    Result := True;

end;
//---------------------------------------------------------------------------
function TGTDTaskPanel.Start:Boolean;
begin

    // -- First thing we must do is to check that the primary file exists
    if (fmainfile <> '') and (not FileExists(fMainfile)) then
    begin
        Report('Show','Skipping Processing Set ' + fTaskName + '. File ' + fMainfile + ' not found');
        Report('Show','Skipped.');

        // -- Now run the next processing set if any
        PostMessage(Handle,GTTM_RUNNEXT,0,0);
        Exit;
    end
    else
        Report('Show','Starting Processing Set ' + fTaskName);

    Screen.Cursor := crHourglass;

    // -- There might not be a process
    if (fProcessName <> '') then
    begin
        Report('Show','Starting ' + fProcessName);

        try
        // -- Setup the process component
        DosCommand.CommandLine := fProcessName;
        DosCommand.Execute;
        except
          on E: Exception do
          begin
            Report('Error',E.Message);
            Report('Show','Error.');
          end;
        end;
    end
    else
        PostMessage(Handle,	GTTM_START_SEND,0,0);

end;
//---------------------------------------------------------------------------
function TGTDTaskPanel.Stop:Boolean;
begin
end;
//---------------------------------------------------------------------------
function TGTDTaskPanel.StartProcessing:Boolean;
begin
end;
//---------------------------------------------------------------------------
function TGTDTaskPanel.StartEmailDespatch:Boolean;

    function SetupEmailer:Boolean;
    var
       s,e,d : String;
    begin
        if not Assigned(DocumentRegistry) then
        begin
            Report('Error','Unable to load configuration. Document Registry not assigned');
            Exit;
        end;

        // -- Load the appropriate configuration record
        if not DocumentRegistry.GetSettingString('emailsend',fEmailTemplate,s) then
        begin
            // -- Might be a new record
            Report('Error','Unable to load configuration. Template not available');
            Exit;
        end
        else begin

            if DocumentRegistry.GetSettingMemoString('/email settings','mailserver',s) then
                SmtpCli1.Host := s
            else
                SmtpCli1.Host := '';

            if DocumentRegistry.GetSettingMemoString('/email settings','login-required',s) then
            begin
                if (s = 'True') then
                begin
                    smtpCli1.AuthType  := smtpAuthLogin;

                    if DocumentRegistry.GetSettingMemoString('/email settings','username',s) then
                        smtpCli1.UserName := s
                    else
                        smtpCli1.UserName := '';

                    if DocumentRegistry.GetSettingMemoString('/email settings','password',s) then
                        smtpCli1.Password := s
                    else
                        smtpCli1.Password := '';
                end
                else
                    smtpCli1.AuthType  := smtpAuthNone;
            end
            else
                smtpCli1.AuthType  := smtpAuthNone;

            if DocumentRegistry.GetSettingMemoString('/email settings','sender',s) then
            begin
                SmtpCli1.FromName:= s;
                SmtpCli1.HdrFrom := s;
            end
            else
                SmtpCli1.HdrFrom := '';

            if fTestEmailDest <> '' then
            begin
                // -- This means that there is a test email target
                //    to which things will go
                SmtpCli1.HdrTo := fTestEmailDest;
                SmtpCli1.RcptName.Clear;
                SmtpCli1.RcptName.Add(fTestEmailDest);
            end
            else begin
                // -- Normal email recipient target
                if DocumentRegistry.GetSettingMemoString('/email settings','recipient',s) then
                begin
                    SmtpCli1.HdrTo := s;
                    SmtpCli1.RcptName.Clear;
                    SmtpCli1.RcptName.Add(s);
                end
                else
                    SmtpCli1.RcptName.Clear;
            end;

            if DocumentRegistry.GetSettingMemoString('/email settings','subject',s) then
                SmtpCli1.HdrSubject := s
            else
                SmtpCli1.HdrSubject := '';

            if DocumentRegistry.GetSettingMemoString('/email settings','bodytext',s) then
            begin
                SmtpCli1.MailMessage.Clear;
                SmtpCli1.MailMessage.Add(s);
            end
            else
                SmtpCli1.MailMessage.Clear;

        end;

        // -- Attach all the files
        d := fWorkDir;
        s := fFileList;

        SmtpCli1.EmailFiles.Clear;
        // -- Add all existing files
        repeat
            e := Parse(s,#13);
            if (e <> '') then
            begin
                if (FileExists(d + e)) then
                    SmtpCli1.EmailFiles.Add(d + e)
                else
                    Report('Warning','File not found ' + d + e);
            end;

        until e = '';

    end;

begin

    SetupEmailer;

    with bsSkinGauge1 do
    begin
        Visible := True;
        Value := 10;
    end;

    SmtpCli1.Connect;

    Report('Show','Commencing sending of files by email');

end;
//---------------------------------------------------------------------------
function TGTDTaskPanel.StartFTPDespatch:Boolean;

    procedure SetupFTP;
    var
       s,e,d : String;
    begin
        if not Assigned(DocumentRegistry) then
        begin
            Report('Error','Unable to load configuration. Document Registry not assigned');
            Exit;
        end;

        // -- Load the appropriate configuration record
        if not DocumentRegistry.GetSettingString('ftpsend',fFTPTemplate,s) then
        begin
            // -- Might be a new record
            Report('Error','Unable to load configuration. Template not available');
            Exit;
        end
        else begin

            if DocumentRegistry.GetSettingMemoString('/ftp settings','ftpserver',s) then
                FTPClient.Host := s
            else
                FTPClient.Host := '';

            if DocumentRegistry.GetSettingMemoString('/ftp settings','username',s) then
                FTPClient.username := s
            else
                FTPClient.username := '';

            if DocumentRegistry.GetSettingMemoString('/ftp settings','password',s) then
                FTPClient.password := s
            else
                FTPClient.password := '';

            // if DocumentRegistry.GetSettingMemoString('/ftp settings','uploaddir',s) then
            //     FTPClient.HostDirName := s
            // else
            //    FTPClient.HostDirName := '';
        end;

    end;

begin
    SetupFTP;

    with bsSkinGauge1 do
    begin
        Visible := True;
        Value := 10;
    end;

//    fFileList := 'd:\Brochure-p1.pdf';

    ftpClient.Connect;

    Report('Show','Commencing sending of files by ftp');

    PostMessage(Handle,GTTM_CLEANUP	,0,0);
end;
//---------------------------------------------------------------------------
procedure TGTDTaskPanel.Report(const Msgtype : String; Const Description : String);
begin
    if lstCheckList.Visible then
    begin
        if not bsSkinGauge1.ShowProgressText then
            bsSkinGauge1.ShowProgressText := True;

        bsSkinGauge1.ProgressText := Description;

        if Assigned(currentDisplayItem) then
            currentDisplayItem.SubItems[1] := Description;
    end;

    if (MsgType = 'Clear') then
        mmoReport.Lines.Clear
    else
        mmoReport.Lines.Add(Description);

end;
//---------------------------------------------------------------------------
procedure TGTDTaskPanel.DosCommandNewLine(Sender: TObject;
  NewLine: String; OutputType: TOutputType);
begin
    Report('Show',NewLine);
end;
//---------------------------------------------------------------------------
procedure TGTDTaskPanel.DosCommandTerminated(Sender: TObject);
begin
    Report('Show',fProcessName + ' task finished.');
    PostMessage(Handle,	GTTM_START_SEND,0,0);
end;
//---------------------------------------------------------------------------
procedure TGTDTaskPanel.bsSkinSpeedButton1Click(Sender: TObject);
begin

end;
//---------------------------------------------------------------------------
procedure TGTDTaskPanel.bsSkinSpeedButton2Click(Sender: TObject);
begin
    DosCommand.Stop;
end;
//---------------------------------------------------------------------------
procedure TGTDTaskPanel.bsSkinSpeedButton3Click(Sender: TObject);
begin
    if not Assigned(DocumentRegistry) then
    begin
        Report('Error','Unable to load configuration. Document Registry not assigned');
        Exit;
    end;

  //  DocumentRegistry.GetSettingItemList('processjob',cbxTasks.Items);

end;
//---------------------------------------------------------------------------
procedure TGTDTaskPanel.ProcessNextCommand(var aMsg : TMsg);
begin
    if (fEmailTemplate <> '') then
        StartEmailDespatch
    else if (fFTPTemplate <> '') then
        StartFTPDespatch
    else
        PostMessage(Handle,GTTM_CLEANUP	,0,0);
end;
//---------------------------------------------------------------------------
procedure TGTDTaskPanel.ProcessCleanup(var aMsg : TMsg);
var
    f, fl : String;
begin
    Report('Show','Cleaning up.');

    // -- Do a file cleanup
    if (fFileList <> '') then
    begin
        fl := fFileList;
        f := parse(fl,#13 + #10);
        if (f <> '') then
        begin
            // -- Prepend the working directory
            if (fWorkDir <> '') then
            begin
                f := fWorkDir + f;
            end;

            // -- Delete the file
            if FileExists(f) then
                DeleteFile(f);
        end;
    end;

    Report('Show','Completed.');

    PostMessage(Handle,GTTM_RUNNEXT,0,0);

end;
//---------------------------------------------------------------------------
procedure TGTDTaskPanel.ProcessRunNext(var aMsg : TMsg);
var
    p : String;
begin
    if runningAll then
    begin
        // -- Advance to the next item and run that one
        if RunningItemNumber < (lstCheckList.Items.Count-1) then
        begin

            Inc(runningItemNumber);

            lstCheckList.Selected := lstCheckList.Items[RunningItemNumber];

            p := lstCheckList.Selected.SubItems[0];
            if Load(p) then
                Start
            else
                Screen.Cursor := crDefault;
        end
        else
            Screen.Cursor := crDefault;

    end;
end;

procedure TGTDTaskPanel.ProcessErrorStart(var aMsg : TMsg);
begin
    Report('Error','Error starting process.');
    Report('Show','Completed.');
end;

procedure TGTDTaskPanel.SmtpCli1RequestDone(Sender: TObject;
  RqType: TSmtpRequest; ErrorCode: Word);
var
    xc : Integer;
begin
//     if (RqType = smtpConnect) and (ErrorCode = 0) then
//     begin
//        bsSkinGauge1.Value := 10;
//     end
//     else
     if (RqType = smtpAuth) and (ErrorCode = 0) then
     begin
        bsSkinGauge1.Value := 20;
     end
     else
     if (RqType = smtpConnect) and (ErrorCode = 0) then
     begin
        // -- Do the mailing
        Report('SHOW','Connected Successfully.');
        Report('SHOW','Now Mailing files - please wait');
        SmtpCli1.Mail;

        bsSkinGauge1.Value := 40;
     end
     else if (RqType = smtpMail) and (ErrorCode = 0) then
     begin
        bsSkinGauge1.Value := 90;

        // -- Write every entry
        for xc :=1 to SmtpCli1.EmailFiles.Count do
            Report('SENT','Successfully sent ' + SmtpCli1.EmailFiles.Strings[xc-1]);

        SmtpCli1.Quit;

     end
     else if (RqType = smtpQuit) and (ErrorCode = 0) then
     begin
        bsSkinGauge1.Value := 100;
        Report('SHOW','Session closed Successfully');
        Report('COMPLETE','Product Data Mailing Function complete.');

        bsSkinGauge1.Visible := False;

        Report('SHOW','Product Data Mailed Successfully');

    //    SmtpCli1.Quit;
        PostMessage(Handle,GTTM_CLEANUP	,0,0);

     end
     else if (ErrorCode <> 0) then
     begin
        bsSkinGauge1.Visible := False;

        if (ErrorCode = 11004) then
        begin

            if mrYes = bsSkinMessage1.MessageDlg('You are not Connected: Do you want to generate files to manually email anyway?',mtConfirmation,[mbYes, mbNo, mbCancel],0) then
            begin

                bsSkinGauge1.Value := 100;
                bsSkinGauge1.Visible := False;

                Report('NOT SENT','Product Data generated but not sent.');
            end;

        end
        else begin
            // -- Display the error message
            Report('ERROR','Error ' + IntToStr(ErrorCode) + ' encountered');
        end;

        PostMessage(Handle,GTTM_CLEANUP	,0,0);

     end;
end;

procedure TGTDTaskPanel.SetSkinData(newSkin : TbsSkinData);
begin
    bsSkinPanel1.SkinData := newSkin;
    mmoReport.SkinData := newSkin;
    bsSkinGauge1.SkinData := newSkin;
    lstCheckList.SkinData := newSkin;
    btnShowDetails.SkinData := newSkin;
    btnProcess.SkinData := newSkin;
end;

procedure TGTDTaskPanel.DisplayJobList;

    procedure LoadDetails(anItem : TListItem; taskName : String);
    var
        s : String;
    begin
        // -- Load up the record
        if not DocumentRegistry.GetSettingString('processjob',TaskName,s) then
        begin
            Report('Error','Unable to load configuration. Job details not found');
            Exit;
        end;

        if DocumentRegistry.GetSettingMemoString('/process settings','mainfile',s) then
            anItem.Caption := s;

        anItem.SubItems.Add(taskName);
        anItem.SubItems.Add('Ready');

    end;

var
    anItem : TlistItem;
    xc : Integer;
begin
    if not Assigned(DocumentRegistry) then
    begin
        Report('Error','Unable to load configuration. Document Registry not assigned');
        Exit;
    end;

    DocumentRegistry.GetSettingItemList('processjob',cbxTasks.Items);

    // -- Load up all the details into the list
    lstCheckList.Items.Clear;
    for xc := 1 to cbxTasks.Items.count do
    begin
        anItem := lstCheckList.Items.Add;

        LoadDetails(anItem,cbxTasks.Items[xc-1]);

    end;

end;

procedure TGTDTaskPanel.bsSkinSpeedButton4Click(Sender: TObject);
begin
    DisplayJobList;
end;

procedure TGTDTaskPanel.btnShowDetailsClick(Sender: TObject);
begin
    if lstCheckList.Visible then
    begin
        lstCheckList.Visible := False;
        btnShowDetails.Caption := 'Details : On';
    end
    else begin
        lstCheckList.Visible := True;
        btnShowDetails.Caption := 'Details : Off';
    end;
end;

procedure TGTDTaskPanel.RunAll;
var
    xc : Integer;
    anItem : TListItem;
    p : String;
begin

    runningAll := True;
    runningItemNumber := 0;

    Screen.Cursor := crHourglass;

    if lstCheckList.Items.Count <> 0 then
    begin
        anItem := lstCheckList.Items[0];
        lstCheckList.Selected := anItem;

        p := anItem.SubItems[0];
        if Load(p) then
            Start;
    end;
end;

procedure TGTDTaskPanel.Run1Click(Sender: TObject);
begin
    runningAll := False;

    if Assigned(lstCheckList.Selected) then
    begin
        if not Load(lstCheckList.Selected.SubItems[0]) then
            Exit;

        Start;
    end;
end;

procedure TGTDTaskPanel.btnProcessClick(Sender: TObject);
begin
    RunAll;
end;

procedure TGTDTaskPanel.IdFTPClientStatus(ASender: TObject;
  const AStatus: TIdStatus; const AStatusText: String);
begin
    Report('ftp',AStatusText);

    case AStatus of

        hsResolving:        bsSkinGauge1.Value := 5;
        hsConnecting:       bsSkinGauge1.Value := 10;
        hsConnected:        bsSkinGauge1.Value := 15;
        hsDisconnecting:    bsSkinGauge1.Value := 95;
        hsDisconnected:     bsSkinGauge1.Value := 100;
        hsStatusText:       ;
        ftpTransfer:        ;
        ftpReady:           PostMessage(Handle,GTTM_FTPEVENT,0,0);
    end;

end;

procedure TGTDTaskPanel.IdFTPClientAfterClientLogin(Sender: TObject);
begin
    PostMessage(Handle,GTTM_FTPEVENT,0,0);

end;

procedure TGTDTaskPanel.FTPClientDisplay(Sender: TObject; var Msg: String);
begin
    Report('Show',Msg);
end;

procedure TGTDTaskPanel.ftpClientStatus(ASender: TObject;
  const AStatus: TIdStatus; const AStatusText: String);
begin
    Report('Show',AStatusText);

    case AStatus of
        hsResolving:        bsSkinGauge1.Value := 5;
        hsConnecting:       bsSkinGauge1.Value := 10;
        hsConnected:        bsSkinGauge1.Value := 15;
        hsDisconnecting:    bsSkinGauge1.Value := 95;
        ftpTransfer:        Report('SHOW','Uploading Files');
        ftpReady:           // -- Tell the component to send the next file
                            PostMessage(Handle,GTTM_FTPEVENT,0,0);
        hsDisconnected:     begin
                              bsSkinGauge1.Value := 100;
                              Report('COMPLETE','FTP Upload Complete');
                              PostMessage(Handle,GTTM_RUNNEXT,0,0);
                            end;
    end;

end;

procedure TGTDTaskPanel.ftpClientAfterClientLogin(Sender: TObject);
begin                     
    PostMessage(Handle,GTTM_FTPEVENT,0,0);
end;

procedure TGTDTaskPanel.ProcessFTP(var aMsg : TMsg);
var
    fname : String;
begin
    if (fFileList <> '') then
    begin
        Report('Show','Uploading ' + fFileList);

        // -- Put the full path
        fname := fFileList;
        if ExtractFilePath(fname) = '' then
          fname := fWorkDir + '\' + fname;

        // -- Upload the file
        ftpClient.Put(fname);
        fFileList := '';
    end
    else
        ftpClient.Quit;
end;

procedure TGTDTaskPanel.ftpClientWork(Sender: TObject;
  AWorkMode: TWorkMode; const AWorkCount: Integer);
begin
//    Report('Show','Uploading ' + IntToStr(AWorkCount) + '%');
end;

end.

