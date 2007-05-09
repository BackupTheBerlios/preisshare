unit AddToQuote;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BusinessSkinForm, bsSkinCtrls,
  GTDTraderSelectPanel, StdCtrls, bsSkinBoxCtrls, Mask, ExtCtrls, jpeg,
  xmldom, XMLIntf, OleCtrls, SHDocVw, msxmldom, XMLDoc, ShellAPI, OleCtnrs,
  SmtpProt, EDBImage, DB, GTDBizDocs, GTDBizLinks,
  bsMessages,ComCtrls;

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
    lblImageName: TbsSkinStdLabel;
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
    tfrLog: TMemo;
    bsSkinMessage1: TbsSkinMessage;
    btnMore: TbsSkinButton;
    txtPLU: TbsSkinEdit;
    bsSkinLabel4: TbsSkinLabel;
    txtQuantity: TbsSkinMaskEdit;
    procedure FormCreate(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure bsSkinButton2Click(Sender: TObject);
    procedure SmtpEmailRequestDone(Sender: TObject; RqType: TSmtpRequest;
      ErrorCode: Word);
    procedure btnSendClick(Sender: TObject);
    procedure SmtpEmailCommand(Sender: TObject; Msg: String);
    procedure SmtpEmailResponse(Sender: TObject; Msg: String);
    procedure SmtpEmailRcptToError(Sender: TObject; ErrorCode: Word;
      RcptNameIdx: Integer; var Action: TSmtpRcptToErrorAction);
    procedure btnMoreClick(Sender: TObject);
  private
    { Private declarations }
    fProductImage : TEDBImage;

    fQuoteNumber : Integer;
    fQuoteTotal,
    fQuoteTax    : Double;

    procedure AddInformationToList;
    procedure PostCleanup;

  public
    { Public declarations }
    myClient : TpnlTraderGet;

    procedure Report(msgCode, Description : String);
    procedure Email;

    procedure Busy(TrueOrFalse : Boolean);

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

  btnNext.Top := btnSend.Top;

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
  txtPLU.Text := frmMain.productDB.qryFindProducts.FieldByName(PLU_Col).AsString;
  txtProductName.Text := frmMain.productDB.qryFindProducts.FieldByName(PName_Col).AsString;
  txtDescription.Text := frmMain.productDB.qryFindProducts.FieldByName(PDesc_Col).AsString;
  txtProductAmount.Text := frmMain.productDB.qryFindProducts.FieldByName(PSellPrice).AsString;

  // -- Copy the product image if any
  fProductImage.DataField := 'Picture';

  if not Assigned(fProductImage.Picture) then
    lblImageName.Caption := 'No Picture'
  else
    // -- Make up an imagename
    lblImageName.Caption := FloatToStr(Now) + '.jpg';

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

  Busy(False);

  btnNext.Visible := True;
  btnMore.Visible := True;

end;

procedure TfrmQuote.AddInformationToList;
var
  newItem : TListItem;
  amt : Double;
begin
    amt := StrToFloat(txtQuantity.Text) * StrToFloat(txtProductAmount.Text);

    // -- Add these products to the trolley
    newItem := frmMain.lsvTrolley.Items.Add;

    newItem.Caption := txtPLU.Text;
    newItem.SubItems.Add(txtProductName.Text);
    newItem.SubItems.Add(txtDescription.Text);
    newItem.SubItems.Add(txtQuantity.Text);
    newItem.SubItems.Add(txtProductAmount.Text);
    newItem.SubItems.Add(FloatToStr(amt));
    newItem.SubItems.Add(FloatToStr(amt * 0.10));
    if Assigned(fProductImage.Picture) then
    begin
      newItem.SubItems.Add(lblImageName.Caption);
      fProductImage.Picture.SaveToFile(lblImageName.Caption);
    end
    else
      // -- Blank image name
      newItem.SubItems.Add('');
end;

procedure TfrmQuote.btnNextClick(Sender: TObject);
begin
  if pnlProductInfo.Visible then
  begin

    AddInformationToList;

    xplEditProducts.Visible := False;
    xplKeyClient.Visible := True;
    xplEmail.Visible := False;
    pnlProductInfo.Visible := False;
    myClient.Visible := True;
    myClient.SelectProspectClientOrAddNew(1);

    btnMore.Visible := False;

  end
  else if myClient.Visible then
  begin
    xplEditProducts.Visible := False;
    xplKeyClient.Visible := False;
    xplEmail.Visible := True;
    myClient.Visible := False;
    grpPreview.Visible := True;
    btnNext.Visible := False;
    btnMore.Visible := False;

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

        PostCleanup;
        
        SmtpEmail.Quit;

     end
     else if (RqType = smtpQuit) and (ErrorCode = 0) then
     begin
        dlgSendProgress.Value := 100;
        Report('Show','Session closed Successfully');
        Report('Show','Quotation Mail function completed Successfully');

//        bsSkinGauge1.Visible := False;
//        if (txtAttachment.Text <> '')and FileExists(txtAttachment.Text) then
//            DeleteFile(txtAttachment.Text)

        Busy(False);

        PostCleanup;

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

        // -- Add the session log into the display
        for xc := 0 to tfrLog.Lines.Count -1 do
        begin
          mmoLog.Lines.Add(tfrLog.Lines[xc]);
        end;

        Busy(False);

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

  // -- Add some elementory validation
  if txtRecipient.Text = '' then
  begin
    bsSkinMessage1.MessageDlg('No email address specified',mtError,[mbOk],0);
    Exit;
  end;

  // -- Add some elementory validation
  if Pos('@',txtRecipient.Text) = 0 then
  begin
    bsSkinMessage1.MessageDlg('This doesn''t appear to be a valid email address.',mtError,[mbOk],0);
    Exit;
  end;

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

    if frmMain.DocRegistry.GetSettingMemoString('/Settings',GTD_REG_SMTP_PORT,s) then
        SmtpEmail.Port := s;
    if s = '' then
        SmtpEmail.Port := '25';

    if frmMain.DocRegistry.GetSettingMemoString('/Settings',GTD_REG_EMAIL_LOGINREQ,s) then
    begin
      if (s = 'True') or (s = 'Auto') then
      begin
          if (s = 'True') then
            SmtpEmail.AuthType  := smtpAuthLogin
          else if (s = 'Auto') then
            SmtpEmail.AuthType  := smtpAuthAutoSelect;

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
  Busy(True);

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
  SmtpEmail.HdrSender  := txtOriginator.Text;
  SmtpEmail.FromName   := txtOriginator.Text;
  SmtpEmail.HdrReturnPath := txtOriginator.Text;
  SmtpEmail.HdrReplyTo    := txtOriginator.Text;

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
    Busy(False);
    Report('Show','Unable to connect');
  end;

end;

procedure TfrmQuote.BuildHTMLQuoteText;
var
  xc : Integer;
  s : WideString;
  topnode,
  SellerInfo,
  BuyerInfo,
  HeaderInfo,
  LineItems,
  LineItem : IXMLNode;
begin
  fQuotetotal := 0;
  fQuoteTax := 0;
  for xc := 0 to frmMain.lsvTrolley.Items.Count - 1 do
  begin
    // -- Add the total
    if frmMain.lsvTrolley.Items[xc].SubItems[4] <> '' then
      fQuotetotal := fQuotetotal + StrToFloat(frmMain.lsvTrolley.Items[xc].SubItems[4]);
    if frmMain.lsvTrolley.Items[xc].SubItems[5] <> '' then
      fQuoteTax := fQuoteTax + StrToFloat(frmMain.lsvTrolley.Items[xc].SubItems[5]);
  end;

  // -- Start building the XML quote document
  XMLQuote.Active := False;
  XMLQuote.XML.Clear;
  XMLQuote.Active := True;

  // -- Create the topmost node
  topnode := XMLQuote.AddChild('Quotation');

  // -- Now add these subnodes
  BuyerInfo := topNode.AddChild(AsXMLTag(STDDOC_BUYER));
  SellerInfo := topNode.AddChild(AsXMLTag(STDDOC_SELLER));
  HeaderInfo := topNode.AddChild(AsXMLTag(STDDOC_HDR));
  LineItems := topNode.AddChild(AsXMLTag(STDDOC_LINE_ITEMS));

  with HeaderInfo do
  begin

    ChildValues[STDDOC_HDR_ELE_TITLE] := 'Quotation ' + IntToStr(fQuoteNumber); //       = 'Document_Title';
    ChildValues[STDDOC_HDR_ELE_REF_NUM] := IntToStr(fQuoteNumber); //     = 'Document_Number';
    ChildValues[STDDOC_HDR_ELE_DATE] := DateToStr(Now); //        = 'Document_Date';
    ChildValues[STDDOC_HDR_ELE_TOTAL_AMOUNT] := FloatToStr(fQuoteTotal); //= 'Document_Total';       // -- 10%, 12%
    ChildValues[STDDOC_HDR_ELE_TAX_AMOUNT] := FloatToStr(fQuoteTax); //  = 'Document_Tax';            // -- 10%, 12%
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
    ChildValues[STDDOC_ELE_COMPANY_NAME]   := frmMain.DocRegistry.GetCompanyName;
    ChildValues[STDDOC_ELE_ADDRESS_LINE_1] := frmMain.DocRegistry.GetAddress1;
    ChildValues[STDDOC_ELE_ADDRESS_LINE_2] := frmMain.DocRegistry.GetAddress2;
    ChildValues[STDDOC_ELE_TOWN]           := frmMain.DocRegistry.GetCity;
    ChildValues[STDDOC_ELE_STATE_REGION]   := frmMain.DocRegistry.GetState;
    ChildValues[STDDOC_ELE_POSTALCODE]     := frmMain.DocRegistry.GetPostcode;
    ChildValues[STDDOC_ELE_COUNTRYCODE]    := frmMain.DocRegistry.GetCountryCode;
    ChildValues[STDDOC_ELE_TELEPHONE]      := frmMain.DocRegistry.GetTelephone;
    ChildValues[STDDOC_ELE_OTHER_INFO]     := frmMain.DocRegistry.GetOtherInformation;
  end;

  with SellerInfo do
  begin
    ChildValues[STDDOC_ELE_COMPANY_NAME]   := frmMain.DocRegistry.GetCompanyName;
    ChildValues[STDDOC_ELE_ADDRESS_LINE_1] := frmMain.DocRegistry.GetAddress1;
    ChildValues[STDDOC_ELE_ADDRESS_LINE_2] := frmMain.DocRegistry.GetAddress2;
    ChildValues[STDDOC_ELE_TOWN]           := frmMain.DocRegistry.GetCity;
    ChildValues[STDDOC_ELE_STATE_REGION]   := frmMain.DocRegistry.GetState;
    ChildValues[STDDOC_ELE_POSTALCODE]     := frmMain.DocRegistry.GetPostcode;
    ChildValues[STDDOC_ELE_COUNTRYCODE]    := frmMain.DocRegistry.GetCountryCode;
    ChildValues[STDDOC_ELE_TELEPHONE]      := frmMain.DocRegistry.GetTelephone;
    ChildValues[STDDOC_ELE_OTHER_INFO]     := frmMain.DocRegistry.GetOtherInformation;
//    ChildValues[STDDOC_ELE_TELEPHONE2]     :=
//    ChildValues[STDDOC_ELE_EMAIL_ADDRESS]  :=
  end;

  // -- Build all the line items
  with frmMain.lsvTrolley do
  begin
    for xc := 0 to Items.Count -1 do
    begin
      LineItem := LineItems.AddChild(AsXMLTag(STDDOC_LINE_ITEM));

      LineItem.ChildValues[STDDOC_ELE_ITEM_CODE]   := Items[xc].Caption;
      LineItem.ChildValues[STDDOC_ELE_ITEM_NAME]   := Items[xc].SubItems[0];
      LineItem.ChildValues[STDDOC_ELE_ITEM_DESC]   := Items[xc].SubItems[1];
      LineItem.ChildValues[STDDOC_ELE_ITEM_QTY]    := Items[xc].SubItems[2];
      LineItem.ChildValues[STDDOC_ELE_ITEM_RATE]   := Items[xc].SubItems[3];
      LineItem.ChildValues[STDDOC_ELE_ITEM_AMOUNT] := Items[xc].SubItems[4];
      LineItem.ChildValues[STDDOC_ELE_ITEM_TAX]    := Items[xc].SubItems[5];
      LineItem.ChildValues[STDDOC_ELE_ITEM_IMAGE]  := Items[xc].SubItems[6];
//      LineItem.ChildValues[STDDOC_ELE_ITEM_UNIT]   := ;

    end;
  end;

  XMLQuote.SaveToFile('Quotation ' + IntToStr(fQuoteNumber) + '.xml');

  Report('Show','Building HTML via XML Transformation');

  // -- Load the source document

  // -- Load the transformation
  XMLTransformation.Active := False;

  // -- Load up the quotation transformation file if it exists
  if FileExists('Quotation.xsl') then
    XMLTransformation.LoadFromFile('Quotation.xsl');

  XMLTransformation.Active := True;

  // -- Now transform the document
  XMLQuote.Node.TransformNode(xmlTransformation.Node,s);

  SmtpEmail.ContentType := smtpHTML;
  SmtpEmail.MailMessage.Text := s;

end;

procedure TfrmQuote.SmtpEmailCommand(Sender: TObject; Msg: String);
begin
  tfrLog.Lines.Add('Command >' + Msg);
end;

procedure TfrmQuote.SmtpEmailResponse(Sender: TObject; Msg: String);
begin
  tfrLog.Lines.Add('Response <' + Msg);
end;

procedure TfrmQuote.SmtpEmailRcptToError(Sender: TObject; ErrorCode: Word;
  RcptNameIdx: Integer; var Action: TSmtpRcptToErrorAction);
begin
  Report('Error',SmtpEmail.RcptName[RcptNameIdx] + ' isn''t a valid email address');
  Action := srteIgnore;
end;

procedure TfrmQuote.Busy(TrueOrFalse : Boolean);
begin
  if TrueOrFalse then
    Screen.Cursor := crHourglass
  else
    Screen.Cursor := crDefault;

  // -- Disable the UI controls
  txtRecipient.ReadOnly := TrueOrFalse;
  txtOriginator.ReadOnly := TrueOrFalse;
  txtSubject.ReadOnly := TrueOrFalse;
  mmoBodyText.ReadOnly := TrueOrFalse;
  mmoLog.ReadOnly := TrueOrFalse;
  btnSend.Enabled := not TrueOrFalse;
  btnClose.Enabled := not TrueOrFalse;

end;

procedure TfrmQuote.btnMoreClick(Sender: TObject);
begin
  AddInformationToList;

  // -- Here we close up
  Close;
end;

procedure TfrmQuote.PostCleanup;
begin
  // -- This will clear all the items
  frmMain.lsvTrolley.Items.Clear;
end;

end.
