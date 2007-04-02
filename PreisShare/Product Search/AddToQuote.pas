unit AddToQuote;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BusinessSkinForm, bsSkinCtrls,
  GTDTraderSelectPanel, StdCtrls, bsSkinBoxCtrls, Mask, ExtCtrls, jpeg,
  xmldom, XMLIntf, OleCtrls, SHDocVw, msxmldom, XMLDoc, ShellAPI, OleCtnrs,
  SmtpProt;

type
  TfrmQuote = class(TForm)
    bsBusinessSkinForm1: TbsBusinessSkinForm;
    btnClose: TbsSkinButton;
    btnSend: TbsSkinButton;
    pnlProductInfo: TbsSkinGroupBox;
    lblTrader: TbsSkinLabel;
    bsSkinLabel2: TbsSkinLabel;
    txtProductName: TbsSkinEdit;
    txtDescription: TbsSkinMemo;
    txtProductAmount: TbsSkinMaskEdit;
    bsSkinLabel1: TbsSkinLabel;
    btnNext: TbsSkinButton;
    bsSkinGroupBox2: TbsSkinGroupBox;
    Image2: TImage;
    bsSkinTextLabel1: TbsSkinTextLabel;
    XMLDocument1: TXMLDocument;
    bvlPicture: TbsSkinBevel;
    bsSkinStdLabel1: TbsSkinStdLabel;
    imgPicture: TImage;
    grpPreview: TbsSkinGroupBox;
    mmoLog: TbsSkinMemo2;
    bsSkinLabel3: TbsSkinLabel;
    icsEmailer: TSmtpCli;
    dlgSendProgress: TbsSkinGauge;
    bsSkinStdLabel2: TbsSkinStdLabel;
    txtRecipient: TbsSkinEdit;
    bsSkinStdLabel3: TbsSkinStdLabel;
    txtOriginator: TbsSkinEdit;
    bsSkinStdLabel4: TbsSkinStdLabel;
    txtSubject: TbsSkinEdit;
    mmoBodyText: TbsSkinMemo;
    procedure FormCreate(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure bsSkinButton2Click(Sender: TObject);
    procedure icsEmailerRequestDone(Sender: TObject; RqType: TSmtpRequest;
      ErrorCode: Word);
    procedure btnSendClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    myClient : TpnlTraderGet;

    procedure Report(msgCode, Description : String);
    procedure Email;

    procedure QuoteFromData;
  end;

var
  frmQuote: TfrmQuote;

implementation

uses Main, GTDProductDBSearch;

{$R *.dfm}

procedure TfrmQuote.FormCreate(Sender: TObject);
begin
  // -- Setup skin data
  bsBusinessSkinForm1.SkinData := frmMain.bsSkinData1;
  pnlProductInfo.SkinData := frmMain.bsSkinData1;
  btnSend.SkinData := frmMain.bsSkinData1;
  btnClose.SkinData := frmMain.bsSkinData1;
  bvlPicture.SkinData := frmMain.bsSkinData1;

  myClient := TpnlTraderGet.Create(Self);
  with myClient do
  begin
    Top := lblTrader.Top + lblTrader.Height;
    Left := lblTrader.Left;
    Visible := False;
    Parent := Self;
    SkinData := frmMain.bsSkinData1;
    DocRegistry := frmMain.DocRegistry;
  end;
  lblTrader.Width := myClient.Width;
  pnlProductInfo.Width := myClient.Width;


end;

procedure TfrmQuote.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmQuote.QuoteFromData;
begin
  txtProductName.Text := frmMain.productDB.qryFindProducts.FieldByName(PName_Col).AsString;
  txtDescription.Text := frmMain.productDB.qryFindProducts.FieldByName(PDesc_Col).AsString;
  txtProductAmount.Text := frmMain.productDB.qryFindProducts.FieldByName(PSellPrice).AsString;
end;

procedure TfrmQuote.btnNextClick(Sender: TObject);
begin
  if pnlProductInfo.Visible then
  begin
    pnlProductInfo.Visible := False;
    myClient.Visible := True;
    myClient.SelectProspectClientOrAddNew(1);
  end
  else if myClient.Visible then
  begin
    myClient.Visible := False;
    grpPreview.Visible := True;
    btnNext.Visible := False;
  end
  else if grpPreview.Visible then
  begin
  end;
end;

procedure TfrmQuote.bsSkinButton2Click(Sender: TObject);
begin
//  WebBrowser1.Navigate('file:///C:/Documents%20and%20Settings/DL/Desktop/MFSIM%20Newletter.htm');

    ShellExecute(frmMain.Handle,	// handle to parent window
                 'open',	        // pointer to string that specifies operation to perform
                 'file:///C:/Documents%20and%20Settings/DL/Desktop/MFSIM%20Newletter.htm',	// pointer to filename or folder name string
                 nil,	            // pointer to string that specifies executable-file parameters
                 nil,	            // pointer to string that specifies default directory
                 SW_SHOWNORMAL 	    // whether file is shown when opened
                 );

end;

procedure TfrmQuote.icsEmailerRequestDone(Sender: TObject;
  RqType: TSmtpRequest; ErrorCode: Word);
begin
     if (RqType = smtpConnect) and (ErrorCode = 0) then
     begin
        // -- Do the mailing
        Report('Show','Connected Successfully. Now Mailing files - please wait');
        icsEmailer.Mail;

        dlgSendProgress.Value := 35;
     end
     else if (RqType = smtpMail) and (ErrorCode = 0) then
     begin
        dlgSendProgress.Value := 90;

        // -- Write every entry
//        for xc :=1 to SmtpCli1.EmailFiles.Count do
//            dlgSendProgress.Caption := 'Successfully sent ' + SmtpCli1.EmailFiles.Strings[xc-1];

        Report('Show','Product Data Mailed Successfully');

        icsEmailer.Quit;

//        CleanupInvoices;

     end
     else if (RqType = smtpQuit) and (ErrorCode = 0) then
     begin
        dlgSendProgress.Value := 100;
        Report('Show','Session closed Successfully');
        Report('Show','Product Data Mailing Function complete.');

//        bsSkinGauge1.Visible := False;
//        if (txtAttachment.Text <> '')and FileExists(txtAttachment.Text) then
//            DeleteFile(txtAttachment.Text)
     end
     else if (ErrorCode <> 0) then
     begin
//        bsSkinGauge1.Visible := False;

        if (ErrorCode = 11004) then
        begin
{
            if mrYes = bsSkinMessage1.MessageDlg('You are not Connected: Do you want to generate files to manually email anyway?',mtConfirmation,[mbYes, mbNo, mbCancel],0) then
            begin
//                GenerateInvoices;

                bsSkinGauge1.Value := 100;
                bsSkinGauge1.Visible := False;

                dlgSendProgress.Caption := 'Product Data generated but not sent.');
            end;
}
        end
        else begin
            // -- Display the error message
            Report('Show','Error ' + IntToStr(ErrorCode) + ' encountered');
        end;
     end;


end;

procedure TfrmQuote.Report(msgCode, Description : String);
begin
  // --
  if msgCode = 'Clear' then
    mmoLog.Lines.Clear
  else
    mmoLog.Lines.Add(Description);
end;

procedure TfrmQuote.btnSendClick(Sender: TObject);
begin
  Email;
end;

procedure TfrmQuote.Email;
begin
    // -- Setup the authentication type
    {
    if frmConfig.cbxMailHostLogin.Checked then
        icsEmailer.AuthType := smtpAuthLogin
    else
        icsEmailer.AuthType := smtpAuthNone;
    }
    
    // -- Setup the message header
    icsEmailer.HdrTo      := txtRecipient.Text;
    icsEmailer.RcptName.Clear;
    icsEmailer.RcptName.Add(txtRecipient.Text);

    icsEmailer.HdrSubject := txtSubject.Text;
    icsEMailer.HdrFrom    := txtOriginator.Text;
    icsEmailer.FromName   := txtOriginator.Text;
  {  icsEMailer.Host       := frmConfig.txtMailServer.Text;}

    // -- Add our attachment
    icsEmailer.EmailFiles.Clear;
 {   if txtAttachment.Text <> '' then
    begin
        icsEmailer.EmailFiles.Add(txtAttachment.Text);
    end; }

    // -- Attach the message
    icsEmailer.MailMessage.Assign(mmoBodyText.Lines);

    // -- Now connect to the server
    icsEmailer.Connect;

end;

end.
