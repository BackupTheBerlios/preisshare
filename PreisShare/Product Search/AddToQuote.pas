unit AddToQuote;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BusinessSkinForm, bsSkinCtrls,
  GTDTraderSelectPanel, StdCtrls, bsSkinBoxCtrls, Mask, ExtCtrls, jpeg,
  xmldom, XMLIntf, OleCtrls, SHDocVw, msxmldom, XMLDoc, ShellAPI, OleCtnrs,
  SmtpProt, EDBImage, DB, GTDBizDocs, GTDBizLinks;

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
    xplEditProducts: TbsSkinTextLabel;
    XMLQuote: TXMLDocument;
    bvlPicture: TbsSkinBevel;
    bsSkinStdLabel1: TbsSkinStdLabel;
    grpPreview: TbsSkinGroupBox;
    mmoLog: TbsSkinMemo2;
    bsSkinLabel3: TbsSkinLabel;
    SmtpEmail: TSmtpCli;
    dlgSendProgress: TbsSkinGauge;
    bsSkinStdLabel2: TbsSkinStdLabel;
    txtRecipient: TbsSkinEdit;
    bsSkinStdLabel3: TbsSkinStdLabel;
    txtOriginator: TbsSkinEdit;
    bsSkinStdLabel4: TbsSkinStdLabel;
    txtSubject: TbsSkinEdit;
    mmoBodyText: TbsSkinMemo;
    DataSource1: TDataSource;
    xplKeyClient: TbsSkinTextLabel;
    xplEmail: TbsSkinTextLabel;
    xmlTransformation: TXMLDocument;
    procedure FormCreate(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure bsSkinButton2Click(Sender: TObject);
    procedure SmtpEmailRequestDone(Sender: TObject; RqType: TSmtpRequest;
      ErrorCode: Word);
    procedure btnSendClick(Sender: TObject);
    procedure SmtpEmailCommand(Sender: TObject; Msg: String);
    procedure SmtpEmailResponse(Sender: TObject; Msg: String);
  private
    { Private declarations }
    fProductImage : TEDBImage;

    fQuoteNumber : Integer;
    fQuoteTotal,
    fQuoteTax    : Double;

  public
    { Public declarations }
    myClient : TpnlTraderGet;

    procedure Report(msgCode, Description : String);
    procedure Email;

    procedure QuoteFromData;
    procedure BuildHTMLQuoteText;
    
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
    btnSelect.Visible := False;
  end;

  fProductImage := TEDBImage.Create(Self);
  with fProductImage do
  begin
    Parent := pnlProductInfo;
    BorderStyle := bsNone;
    Visible := True;
    Color := 5318157;
    Stretch := True;
    fProductImage.Left := bvlPicture.Left + 2;
    fProductImage.Top := bvlPicture.Top + 2;
    fProductImage.Width := bvlPicture.Width - 4;
    fProductImage.Height := bvlPicture.Height - 4;
    DataSource := DataSource1;
  end;

  // -- Hook onto the source of the data
  DataSource1.DataSet := frmMain.productDB.qryFindProducts;

  lblTrader.Width := myClient.Width;
  pnlProductInfo.Width := myClient.Width;

  xplKeyClient.Top := xplEditProducts.Top;
  xplKeyClient.Left := xplEditProducts.Left;
  xplEmail.Top := xplEditProducts.Top;
  xplEmail.Left := xplEditProducts.Left;

  grpPreview.Left := pnlProductInfo.Left;
  grpPreview.Top := pnlProductInfo.Top;

end;

procedure TfrmQuote.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmQuote.QuoteFromData;
var
  s : String;
begin
  // -- Copy accross the default field values
  txtProductName.Text := frmMain.productDB.qryFindProducts.FieldByName(PName_Col).AsString;
  txtDescription.Text := frmMain.productDB.qryFindProducts.FieldByName(PDesc_Col).AsString;
  txtProductAmount.Text := frmMain.productDB.qryFindProducts.FieldByName(PSellPrice).AsString;

  // -- Copy the product image if any
  fProductImage.DataField := 'Picture';

  xplEditProducts.Visible := True;
  xplKeyClient.Visible := False;
  xplEmail.Visible := False;

  // -- Get the message sender
  if frmMain.DocRegistry.GetSettingMemoString('/Settings',GTD_REG_EMAIL_DISPLAYNAME,s) then
        txtOriginator.Text := s;
  txtSubject.Text := 'Quotation';
  
  // -- Clear out the following fields
  mmoLog.Lines.Clear;
  mmoBodyText.Lines.Clear;
  grpPreview.Visible := False;
  myClient.Visible := False;
  pnlProductInfo.Visible := True;

  txtRecipient.Enabled := True;
  txtOriginator.Enabled := True;
  txtSubject.Enabled := True;
  mmoBodyText.Enabled := True;
  mmoLog.Enabled := True;
  btnSend.Enabled := True;

  btnNext.Visible := True;

end;

procedure TfrmQuote.btnNextClick(Sender: TObject);
begin
  if pnlProductInfo.Visible then
  begin
    xplEditProducts.Visible := False;
    xplKeyClient.Visible := True;
    xplEmail.Visible := False;
    pnlProductInfo.Visible := False;
    myClient.Visible := True;
    myClient.SelectProspectClientOrAddNew(1);
  end
  else if myClient.Visible then
  begin
    xplEditProducts.Visible := False;
    xplKeyClient.Visible := False;
    xplEmail.Visible := True;
    myClient.Visible := False;
    grpPreview.Visible := True;
    btnNext.Visible := False;

    // -- Copy over the client details
    with mmoBodyText.Lines do
    begin
      Clear;
      Add('QUOTATION');
      Add('=========');
      Add('');
      Add(txtProductName.Text);
      if txtDescription.Text <> '' then
        Add(txtDescription.Text);
      Add('');
      Add('Price: ' + txtProductAmount.Text)
    end;

    // --
    txtSubject.Text := 'Quotation';
    txtRecipient.Text := myClient.txtShortname.Text;


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

procedure TfrmQuote.SmtpEmailRequestDone(Sender: TObject;
  RqType: TSmtpRequest; ErrorCode: Word);

  procedure EnableControls;
  begin
    // -- Disable the UI controls
    txtRecipient.Enabled := True;
    txtOriginator.Enabled := True;
    txtSubject.Enabled := True;
    mmoBodyText.Enabled := True;
    mmoLog.Enabled := True;
    btnSend.Enabled := True;
    btnClose.Enabled := True;

    Screen.Cursor := crDefault;

  end;

var
  xc : Integer;
begin
     if (RqType = smtpConnect) and (ErrorCode = 0) then
     begin
        // -- Do the mailing
        Report('Show','Connected Successfully. Now Mailing files - please wait');
        SmtpEmail.Mail;

        dlgSendProgress.Value := 35;
     end
     else if (RqType = smtpMail) and (ErrorCode = 0) then
     begin
        dlgSendProgress.Value := 90;

        // -- Write every entry
        for xc :=1 to SmtpEmail.EmailFiles.Count do
            Report('Show','Successfully sent ' + SmtpEmail.EmailFiles.Strings[xc-1]);

        Report('Show','Quotation Mailed Successfully');

        SmtpEmail.Quit;

//        CleanupInvoices;

     end
     else if (RqType = smtpQuit) and (ErrorCode = 0) then
     begin
        dlgSendProgress.Value := 100;
        Report('Show','Session closed Successfully');
        Report('Show','Quotation Mail function completed Successfully');

//        bsSkinGauge1.Visible := False;
//        if (txtAttachment.Text <> '')and FileExists(txtAttachment.Text) then
//            DeleteFile(txtAttachment.Text)

        EnableControls;

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

        EnableControls;

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
var
  s : String;

begin
  if not Assigned(frmMain.DocRegistry) then
    Exit;

  // -- Load the appropriate configuration record
  if not frmMain.DocRegistry.GetSettingString(GTD_REG_NOD_GENERAL,GTD_REG_USER_EMAIL,s) then
  begin
      // -- Might be a new record
      Report('Error','Unable to load configuration. Email Configuration not set up');
      Exit;
  end
  else begin

    if frmMain.DocRegistry.GetSettingMemoString('/Settings',GTD_REG_EMAIL_HOST,s) then
        SmtpEmail.Host := s
    else
        SmtpEmail.Host := '';

    if frmMain.DocRegistry.GetSettingMemoString('/Settings',GTD_REG_EMAIL_LOGINREQ,s) then
    begin
        if (s = 'True') then
        begin
            SmtpEmail.AuthType  := smtpAuthLogin;

            if frmMain.DocRegistry.GetSettingMemoString('/Settings',GTD_REG_EMAIL_USERNAME,s) then
                SmtpEmail.UserName := s
            else
                SmtpEmail.UserName := '';

            if frmMain.DocRegistry.GetSettingMemoString('/Settings',GTD_REG_EMAIL_PASSWORD,s) then
                SmtpEmail.Password := s
            else
                SmtpEmail.Password := '';
        end
        else
            SmtpEmail.AuthType  := smtpAuthNone;
    end
    else
        SmtpEmail.AuthType  := smtpAuthNone;

    if frmMain.DocRegistry.GetSettingMemoString('/Settings',GTD_REG_EMAIL_DISPLAYNAME,s) then
    begin
        SmtpEmail.FromName:= s;
        SmtpEmail.HdrFrom := s;

        txtOriginator.Text := s;

    end
    else
        SmtpEmail.HdrFrom := '';
    end;

  BuildHTMLQuoteText;

  // -- Disable the UI controls
  txtRecipient.Enabled := False;
  txtOriginator.Enabled := False;
  txtSubject.Enabled := False;
  mmoBodyText.Enabled := False;
  mmoLog.Enabled := False;
  btnSend.Enabled := False;
//  btnClose.Enabled := False;

  Screen.Cursor := crHourglass;

  // -- Attach the attachments
  SmtpEmail.EmailFiles.Clear;
//  SmtpEmail.EmailFiles.Add(AFileName);

  // -- Now send mail
  while not (SmtpEmail.State in [smtpReady, smtpInternalReady]) do
  begin
    Application.ProcessMessages;
  end;

  // -- Now connect
  SmtpEmail.HdrTo      := txtRecipient.Text;
  SmtpEmail.RcptName.Clear;
  SmtpEmail.RcptName.Add(txtRecipient.Text);

  SmtpEmail.HdrSubject := txtSubject.Text;
  SmtpEmail.HdrFrom    := txtOriginator.Text;
  SmtpEmail.FromName   := txtOriginator.Text;


  // SmtpEmail.MailMessage.Assign(mmoBodyText.Lines);

  // -- Add our attachment
  SmtpEmail.EmailFiles.Clear;
{   if txtAttachment.Text <> '' then
  begin
      icsEmailer.EmailFiles.Add(txtAttachment.Text);
  end; }

  Report('Show','Connecting..');

  // -- Now connect to the server
  try
  SmtpEmail.Connect;
  except
   txtRecipient.Enabled := True;
   txtOriginator.Enabled := True;
   txtSubject.Enabled := True;
   mmoBodyText.Enabled := True;
   mmoLog.Enabled := True;
   btnSend.Enabled := True;
   Report('Show','Unable to connect');
   Screen.Cursor := crDefault;
  end;

end;

procedure TfrmQuote.BuildHTMLQuoteText;
var
  s : WideString;
  topnode,
  SellerInfo,
  BuyerInfo,
  HeaderInfo : IXMLNode;
begin
//  iDoc := NewXMLDocument;
//  iDoc.Active := True;

  XMLQuote.Active := False;
  XMLQuote.XML.Clear;
  XMLQuote.Active := True;

  topnode := XMLQuote.AddChild('Quotation');

  BuyerInfo := topNode.AddChild(STDDOC_BUYER);
  SellerInfo := topNode.AddChild(STDDOC_SELLER);
  HeaderInfo := topNode.AddChild('Header_Information'{STDDOC_HDR});

  with HeaderInfo do
  begin

    ChildValues[STDDOC_HDR_ELE_TITLE] := 'Quotation ' + IntToStr(fQuoteNumber); //       = 'Document_Title';
    ChildValues[STDDOC_HDR_ELE_REF_NUM] := IntToStr(fQuoteNumber); //     = 'Document_Number';
    ChildValues[STDDOC_HDR_ELE_DATE] := DateToStr(Now); //        = 'Document_Date';
	   ChildValues[STDDOC_HDR_ELE_TOTAL_AMOUNT] := FloatToStr(fQuoteTotal); //= 'Document_Total';       // -- 10%, 12%
	   ChildValues[STDDOC_HDR_ELE_TAX_AMOUNT] := FloatToStr(fQuoteTotal); //  = 'Document_Tax';            // -- 10%, 12%
	   ChildValues[STDDOC_HDR_ELE_SALES_PERSON] := ''; //= 'Sales_Person';
	   ChildValues[STDDOC_HDR_ELE_CONTACT] := ''; //     = 'Contact';
	   ChildValues[STDDOC_HDR_ELE_TAX_MODE] := STDDOC_CONST_TAX_MODE_INC; //    = 'Tax_Mode';           // -- Inclusive, Exclusive
    ChildValues[STDDOC_HDR_ELE_TAX_NAME] := 'GST'; //    = 'Tax_Name';           // -- GST, VAT etc
    ChildValues[STDDOC_HDR_ELE_TAX_RATE] := '10'; //    = 'Tax_Rate';           // -- 10%, 12%
    ChildValues[STDDOC_HDR_ELE_TAX_TOTAL] := FloatToStr(fQuoteTax); //   = 'Tax_Total';          // -- Total for the document
    ChildValues[STDDOC_HDR_CURRENCY_CODE] := 'AUD'; //   = 'Currency_Code';      // -- USD, AUD etc
//	   ChildValues[STDDOC_HDR_ORIGIN_CODE] := ''; //     = 'Country_Code';       // -- US, AU, FR etc
//    ChildValues[STDDOC_HDR_DISPLAY_FORMAT] := ''; //  = 'Display_Format';     // -- Predefined image format
//    ChildValues[STDDOC_HDR_LOGO_IMAGE] := ''; //      = 'LogoImage';          // -- Name of logo image
//    ChildValues[STDDOC_HDR_PAPER_SIZE] := ''; //      = 'PaperSize';          // -- Default Paper size A4 etc
//    ChildValues[STDDOC_HDR_PRINT_ORIENT] := ''; //    = 'PrintOrientation';   // -- Printer Orientation ie Portrait/Landscape
//    ChildValues[STDDOC_HDR_HEADER_COLS] := ''; //     = 'HeaderColumns';      // -- Column names printed on header
//	   ChildValues[STDDOC_HDR_ITEM_COLS] := ''; //       = 'ItemColumns';        // -- Line item Column names
//    ChildValues[STDDOC_HDR_QUOTE_EXPIRES] := ''; //   = 'Valid_Until';
//	   ChildValues[STDDOC_HDR_NAME_ALIGN] := ''; //      = 'Name_Position';
//    ChildValues[STDDOC_HDR_ADDRESS_ALIGN] := ''; //   = 'Address_Position';
//	   ChildValues[STDDOC_CONST_HDR_ALIGN_LEFT] := ''; //  = 'Show Left Top';
//    ChildValues[STDDOC_CONST_HDR_ALIGN_RIGHT] := ''; //] := ''; // = 'Show Right Top';
//    ChildValues[STDDOC_CONST_HDR_ALIGN_HIDE] := ''; //  = 'Hide';
//	   ChildValues[STDDOC_HDR_ELE_DELIV_MODE] := ''; //  = 'Delivery_Mode';
//    ChildValues[STDDOC_HDR_ELE_DELIV_DATE] := ''; //  = 'Delivery_Date';
//    ChildValues[STDDOC_HDR_ELE_DELIV_ADDR] := ''; //  = 'Delivery_Address';
//    ChildValues[STDDOC_HDR_ELE_DELIV_FROM] := ''; //  = 'Delivery_From';
//    ChildValues[STDDOC_HDR_ELE_DELIV_VIA] := ''; //   = 'Delivery_Via';
//    ChildValues[STDDOC_HDR_ELE_DELIV_CHG] := ''; //   = 'Delivery_Charge';
//    ChildValues[STDDOC_HDR_ELE_APPRVD_BY] := ''; //   = 'Approved_By';

//    ChildValues[STDDOC_HDR_ELE_SPECL_INSTR] := ''; // = 'Special_Instructions';
//    ChildValues[STDDOC_HDR_ELE_PMT_TERMS] := ''; //   = 'Payment_Terms';
//    ChildValues[STDDOC_HDR_ELE_GEN_TERMS] := ''; //   = 'General_Terms';      // -- Genereal terms

  end;

  with BuyerInfo do
  begin
  
  end;

  with SellerInfo do
  begin
  end;

  Report('Show','Building HTML via XML Transformation');

  // -- Load the source document

  // -- Load the transformation
  XMLTransformation.Active := False;
//  XMLTransformation.xml.Assign(Memo2.Lines);
  XMLTransformation.Active := True;

  // -- Now transform the document
  XMLQuote.Node.TransformNode(xmlTransformation.Node,s);

//  memo3.Text := s;
  SmtpEmail.ContentType := smtpHTML;
  SmtpEmail.MailMessage.Text := s;

end;

procedure TfrmQuote.SmtpEmailCommand(Sender: TObject; Msg: String);
begin
  Report('Show',' - Command=' + Msg);
end;

procedure TfrmQuote.SmtpEmailResponse(Sender: TObject; Msg: String);
begin
  Report('Show',' - Response=' + Msg);

end;

end.
