unit GTDStdBizDocPanel;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, bsSkinTabs, bsSkinCtrls, Mask, bsSkinBoxCtrls, StdCtrls,
  QRPrntr, GTDBizDocs, GTDBizLinks, bsSkinData, ExtCtrls, bsSkinGrids,
  bsDialogs, SmtpProt, Menus, bsSkinMenus, ImgList, bsMessages, bsdbctrls;

type
  TStdBizDocPanel = class(TFrame)
	pnlBackground: TbsSkinPanel;
	tbsNotebook: TbsSkinPageControl;
	bsSkinTabSheet1: TbsSkinTabSheet;
	bsSkinTabSheet2: TbsSkinTabSheet;
	lsvLineItems: TbsSkinListView;
	bsSkinTabSheet4: TbsSkinTabSheet;
	lstHistory: TbsSkinListView;
	bsSkinTabSheet5: TbsSkinTabSheet;
	lblDate: TbsSkinLabel;
	txtDocDate: TbsSkinDateEdit;
	bsSkinLabel3: TbsSkinLabel;
	txtTelephone: TbsSkinEdit;
	bsSkinLabel4: TbsSkinLabel;
	txtLocation: TbsSkinEdit;
	bsSkinLabel5: TbsSkinLabel;
	txtStatus: TbsSkinEdit;
	pnlInfo: TbsSkinGroupBox;
	txtName: TbsSkinEdit;
	bsSkinStdLabel1: TbsSkinStdLabel;
	txtAddress1: TbsSkinEdit;
	bsSkinStdLabel2: TbsSkinStdLabel;
	txtAddress2: TbsSkinEdit;
	txtCity: TbsSkinEdit;
	txtState: TbsSkinEdit;
	txtCountry: TbsSkinEdit;
	bsSkinStdLabel3: TbsSkinStdLabel;
	bsSkinStdLabel4: TbsSkinStdLabel;
	bsSkinStdLabel5: TbsSkinStdLabel;
	pnlTaxMode: TbsSkinGroupBox;
	rdoTaxInclusive: TbsSkinCheckRadioBox;
	rdoTaxExclusive: TbsSkinCheckRadioBox;
	txtTaxRate: TbsSkinMaskEdit;
	bsSkinStdLabel6: TbsSkinStdLabel;
	pnlDocDetails: TbsSkinGroupBox;
	pnlYourStatus: TbsSkinLabel;
	cbxOrderOurStatusCode: TbsSkinComboBox;
	rchOrderOurStatusCmts: TbsSkinRichEdit;
	lblOrderYourComments: TbsSkinLabel;
	txtOrderTheirStatusCode: TbsSkinEdit;
	txtOrderTheirStatusCmts: TbsSkinRichEdit;
	lblOrderTheirComments: TbsSkinLabel;
	lblOrderTheirStatus: TbsSkinLabel;
	bsSkinControlBar1: TbsSkinControlBar;
	btnLineEdit: TbsSkinSpeedButton;
	btnLineAdd: TbsSkinSpeedButton;
	btnSearchProduct: TbsSkinSpeedButton;
	btnLineDelete: TbsSkinSpeedButton;
	btnSend: TbsSkinSpeedButton;
	btnCancel: TbsSkinSpeedButton;
	grdDocProperties: TbsSkinListView;
	bsSkinStdLabel7: TbsSkinStdLabel;
	txtPostcode: TbsSkinEdit;
	txtTaxType: TbsSkinStdLabel;
	btnSave: TbsSkinSpeedButton;
	Emailer: TSmtpCli;
	dlgEmailBody: TbsSkinTextDialog;
	mmoText: TbsSkinMemo2;
	sbSourceV: TbsSkinScrollBar;
	dlgTextInput: TbsSkinTextDialog;
	pnlJobNumbers: TbsSkinGroupBox;
	lblJobSelect: TbsSkinLabel;
	btnReceiveItem: TbsSkinSpeedButton;
	btnPrint1: TbsSkinMenuButton;
	mnuPrintOptions: TbsSkinPopupMenu;
	mnuPrintPreview: TMenuItem;
	mnuPrinter: TMenuItem;
	btnNote: TbsSkinSpeedButton;
	bsSkinInputDialog1: TbsSkinInputDialog;
	ImageList1: TImageList;
	bsSkinMessage1: TbsSkinMessage;
	cbxJobSelect: TbsSkinComboBox;
	procedure bsSkinControlBar1CanResize(Sender: TObject; var NewWidth,
	  NewHeight: Integer; var Resize: Boolean);
	procedure btnLineDeleteClick(Sender: TObject);
	procedure btnSendClick(Sender: TObject);
	procedure EmailerDisplay(Sender: TObject; Msg: String);
	procedure tbsNotebookChange(Sender: TObject);
	procedure FrameResize(Sender: TObject);
	procedure cbxOrderOurStatusCodeChange(Sender: TObject);
	procedure rchOrderOurStatusCmtsChange(Sender: TObject);
	procedure txtLocationButtonClick(Sender: TObject);
	procedure btnNoteClick(Sender: TObject);
	procedure btnReceiveItemClick(Sender: TObject);
	procedure lsvLineItemsClick(Sender: TObject);
    procedure cbxJobSelectChange(Sender: TObject);
  private
	{ Private declarations }
	fDocRegistry: GTDDocumentRegistry;
	fSkinData   : TbsSkinData;
	fCurrentDoc : GTDBizDoc;
	fCanEdit    : Boolean;
	fisLoading  : Boolean;
	fJobNum		: Integer;
	fJobSupport	: Boolean;
	fAsk4DDocNum: Boolean;			// After receiving items on an order, do we
									// prompt the user for a delivery docket #
									// before saving the document

	procedure SetSkinData(newSkin : TbsSkinData);
	procedure SetJobNumber(newJobNumber : Integer);

  public
	{ Public declarations }
	JobNumberChanged : Boolean;

	constructor Create(AOwner : TComponent); override;
	destructor Destroy; override;

	procedure Clear;

	function LoadDocument(dno : Integer):Boolean;
	procedure RefreshDisplay;
	procedure RefreshDisplayLines;
	function GetDocumentTitle:String;
	function SetDocumentTypeMode(const DocType : String):Boolean;
	procedure SetHeaderProperty(const TagName : String; const Value : String);
	procedure Email;

	function HasChanged:Boolean;
	procedure Check4DeliveryDocketNumber;

  published
	property DocRegistry: GTDDocumentRegistry read fDocRegistry write fDocRegistry;
	property SkinData : TbsSkinData read fSkinData write SetSkinData;
	property CurrentDocument : GTDBizDoc read fCurrentDoc write fCurrentDoc;
	property CanEdit:Boolean read fCanEdit write fCanEdit;
	property isLoading  : Boolean read fisLoading write fisLoading;
	property JobNumber : Integer read fJobNum write SetJobNumber;
	property JobSupport : Boolean read fJobSupport write fJobSupport;
  end;

implementation

{$R *.DFM}

constructor TStdBizDocPanel.Create(AOwner : TComponent);
begin
	inherited;

	{
	StrCopy(@cname,'Creating StdDocPanel');
	SendMessage(displaycreateswnd,WM_USER+3001,0,Integer(Addr(cname)));
	}

	if not Assigned(fCurrentDoc) then
		fCurrentDoc := GTDBizDoc.Create(Self);

	pnlBackground.Align := alClient;

end;

destructor TStdBizDocPanel.Destroy;
begin
    if Assigned(fDocRegistry) then
        fDocRegistry := nil;

    if Assigned(fCurrentDoc) then
    begin
        fCurrentDoc.Destroy;
		fCurrentDoc := nil;
    end;

    inherited;
end;

procedure TStdBizDocPanel.Clear;
begin
	// -- Clear the document
	fCurrentDoc.Clear;

	fisLoading := True;

	fAsk4DDocNum := False;

	 // -- Clear all the display fields
	cbxOrderOurStatusCode.Items.Clear;
    rchOrderOurStatusCmts.Lines.Clear;
	txtOrderTheirStatusCode.Text := '';
    txtOrderTheirStatusCmts.Lines.Clear;
    lsvLineItems.Items.Clear;
    lstHistory.Items.Clear;
    mmoText.Lines.Clear;
    txtDocDate.Text := '';
    txtLocation.Text   := '';
    txtTelephone.Text  := '';
    txtStatus.Text := '';

	cbxJobSelect.Items.Clear;

	bsSkinControlBar1.Realign;

	JobNumberChanged := False;

	// -- Hide the button
	btnSave.Visible := False;
	btnCancel.Visible := False;

	fCanEdit := False;
	fisLoading := False;

end;

function TStdBizDocPanel.LoadDocument(dno : Integer):Boolean;
begin

	if Assigned(fDocRegistry) then
	begin

		try
			// -- Hide these buttons
			btnSave.Visible := False;
			btnCancel.Visible := False;

			// -- Attempt to load the document
			if fDocRegistry.Load(dno,fCurrentDoc) then
			begin
				SetDocumentTypeMode(fCurrentDoc.Document_Type);

				RefreshDisplay;

				if tbsNotebook.ActivePageIndex = 3 then
					// -- Only load up the source if they change to this page
					mmoText.Lines.Assign(fCurrentDoc.XML);

			end;

		finally
		end;
	end;

end;

procedure TStdBizDocPanel.SetSkinData(newSkin : TbsSkinData);
begin
	fSkinData                        := newSkin;

	dlgTextInput.SkinData			 := newSkin;
	dlgTextInput.CtrlSkinData 		 := newSkin;
	bsSkinInputDialog1.SkinData		 := newSkin;
	bsSkinInputDialog1.CtrlSkinData	 := newSkin;
	bsSkinMessage1.SkinData		 	 := newSkin;
	bsSkinMessage1.CtrlSkinData	 	 := newSkin;

	pnlBackground.SkinData           := newSkin;
	pnlTaxMode.SkinData              := newSkin;
    tbsNotebook.SkinData             := newSkin;
    pnlInfo.SkinData                 := newSkin;

    bsSkinControlBar1.SkinData       := newSkin;
    btnPrint1.SkinData               := newSkin;
    //btnPrint2.SkinData               := newSkin;
    btnLineEdit.SkinData             := newSkin;
    btnLineAdd.SkinData              := newSkin;
    btnPrint1.SkinData               := newSkin;
    btnCancel.SkinData               := newSkin;
    btnSearchProduct.SkinData        := newSkin;
    btnLineDelete.SkinData           := newSkin;
    btnSend.SkinData                 := newSkin;
    btnSave.SkinData                 := newSkin;
	btnReceiveItem.SkinData			 := newSkin;

    lblDate.SkinData                 := newSkin;
    bsSkinLabel4.SkinData            := newSkin;
	bsSkinLabel3.SkinData            := newSkin;
    bsSkinLabel5.SkinData            := newSkin;
    txtDocDate.SkinData              := newSkin;
    txtLocation.SkinData             := newSkin;
    txtTelephone.SkinData            := newSkin;
    txtStatus.SkinData               := newSkin;
    lstHistory.SkinData              := newSkin;

    // -- Second page
    txtName.SkinData                 := newSkin;
    txtAddress1.SkinData             := newSkin;
    txtAddress2.SkinData             := newSkin;
    txtCity.SkinData                 := newSkin;
    txtState.SkinData                := newSkin;
    txtPostcode.SkinData             := newSkin;
    txtCountry.SkinData              := newSkin;

    lsvLineItems.SkinData            := newSkin;

    // -- First page
    btnPrint1.SkinData               := newSkin;
    pnlYourStatus.SkinData           := newSkin;
    cbxOrderOurStatusCode.SkinData   := newSkin;
    lblOrderYourComments.SkinData    := newSkin;
    rchOrderOurStatusCmts.SkinData   := newSkin;
    lblOrderTheirStatus.SkinData     := newSkin;
    txtOrderTheirStatusCode.SkinData := newSkin;
    lblOrderTheirComments.SkinData   := newSkin;
	txtOrderTheirStatusCmts.SkinData := newSkin;

	btnNote.SkinData 			 	 := newSkin;
	pnlJobNumbers.SkinData 			 := newSkin;
	lblJobSelect.SkinData 			 := newSkin;
	cbxJobSelect.SkinData 			 := newSkin;

    grdDocProperties.SkinData        := newSkin;
	pnlDocDetails.SkinData           := newSkin;

    // -- Source page
    mmoText.SkinData                 := newSkin;
    sbSourceV.SkinData               := newSkin;

end;

function TStdBizDocPanel.SetDocumentTypeMode(const DocType : String):Boolean;
begin
	if DocType = GTD_ORDER_TYPE then
	begin
		// --
		txtDocDate.ReadOnly    := False;
		txtDocDate.ButtonMode  := True;
		lblDate.Caption        := 'Delivery Date';
//		txtLocation.ReadOnly   := False;
		txtLocation.ButtonMode := True;

		pnlJobNumbers.Visible  := fJobSupport;

		btnReceiveItem.Visible := False;
		btnReceiveItem.Left    := 366;

	end
	else begin
		txtDocDate.ReadOnly    := True;
		txtDocDate.ButtonMode  := False;
		txtLocation.ButtonMode := False;
		lblDate.Caption        := 'Date';

		pnlJobNumbers.Visible  := False;

		btnReceiveItem.Visible := False;

	end;
	CurrentDocument.SetDocumentType(DocType);
end;

function TStdBizDocPanel.GetDocumentTitle:String;
begin
    if not Assigned(fCurrentDoc) then
		Result := 'No Document Loaded'
    else
        Result := fCurrentDoc.Document_Type + ' ' + fCurrentDoc.Document_Ref;
end;

procedure TStdBizDocPanel.bsSkinControlBar1CanResize(Sender: TObject;
  var NewWidth, NewHeight: Integer; var Resize: Boolean);
begin
    if NewHeight > 35 then
        Resize := False
    else
        Resize := True;
end;

procedure TStdBizDocPanel.btnLineDeleteClick(Sender: TObject);
begin
	if Assigned(lsvLineItems.Selected) then
    begin
        // -- delete the item
        lsvLineItems.Items.Delete(lsvLineItems.Selected.Index);

        // -- Display the Save/cancel buttons
        if not btnSave.Visible then
            btnSave.Visible := True;
        if not btnCancel.Visible then
            btnCancel.Visible := True;
    end;
end;

procedure TStdBizDocPanel.SetHeaderProperty(const TagName : String; const Value : String);
var
   anItem : TListItem;
begin
     anItem := grdDocProperties.FindCaption(0,TagName,False,True,False);
     if Assigned(anItem) then
        // -- We found the item so update it
        anItem.SubItems[0] := Value
     else begin

        // -- Some fields are on the main panel so filter these out first
        if TagName = STDDOC_HDR_ELE_TAX_MODE then
        begin
            if Value = STDDOC_CONST_TAX_MODE_INC then
				rdoTaxInclusive.Checked := True
            else
                rdoTaxExclusive.Checked := True;
        end
        else begin
            // -- Create the item in the list
            anItem := grdDocProperties.Items.Add;
            anItem.Caption := TagName;
            anItem.SubItems.Add(Value);
        end;
     end;

     // -- We also should be updating the document
end;

procedure TStdBizDocPanel.btnSendClick(Sender: TObject);
begin
    // -- This method will attempt to email the document
    Email;
end;

procedure TStdBizDocPanel.Email;
var
    pdfFileName,msgRecipient,msgSender,mailhost : String;
begin
    if fCurrentDoc.Document_Type <> GTD_QUOTE_TYPE then
        Exit;

    // -- A method to email off the document with attachments
	dlgEmailBody.Caption := 'Email Header Message...';
    if not dlgEmailBody.Execute then
        Exit;

    // -- Produce the PDF file with the document
    pdfFileName := fCurrentDoc.Document_Type + ' ' + fCurrentDoc.Document_Ref;

    Emailer.HdrTo      := msgRecipient;
    Emailer.HdrSubject := 'Quotation';
    Emailer.FromName   := msgSender;

    Emailer.EmailFiles.Clear;
    Emailer.EmailFiles.Add(pdfFileName);

    // -- Attach the message
    Emailer.MailMessage.Assign(dlgEmailBody.Lines);

    // -- Now connect to the server
    Emailer.Connect;

end;

procedure TStdBizDocPanel.EmailerDisplay(Sender: TObject; Msg: String);
var
    anItem : TListItem;
begin
    anItem := lstHistory.Items.Add;
    anItem.Caption := FormatDateTime('t',Now);
    anItem.SubItems.Add('Emailer');
    anItem.SubItems.Add(Msg);
end;

procedure TStdBizDocPanel.tbsNotebookChange(Sender: TObject);
begin
    if tbsNotebook.ActivePageIndex = 3 then
    begin
        // -- Only load up the source if they change to this page
        mmoText.Lines.Assign(fCurrentDoc.XML);
    end;
end;

function TStdBizDocPanel.HasChanged:Boolean;
begin
    //
    Result := fCurrentDoc.HasChanged;
end;

procedure TStdBizDocPanel.FrameResize(Sender: TObject);
begin
    // -- Resize controls
    tbsNotebook.Height := Self.Height - tbsNotebook.Top - 15;
    tbsNotebook.Width  := Self.Width  - tbsNotebook.Left - 10;

    lsvLineItems.Height := bsSkinTabSheet2.Height - lsvLineItems.Top - lsvLineItems.Left;
    lsvLineItems.Width  := bsSkinTabSheet2.Width - (2 * lsvLineItems.Left);

    lstHistory.Width    := bsSkinTabSheet2.Width - (2 * lstHistory.Left);
    lstHistory.Height   := bsSkinTabSheet2.Height - lstHistory.Top - 10;

    // -- Source page
    mmoText.Height      := bsSkinTabSheet2.Height - mmoText.Top - 10;
    mmoText.Width       := bsSkinTabSheet2.Width - mmoText.Left - mmoText.Left - sbSourceV.Width;
    sbSourceV.Height    := mmoText.Height;
    sbSourceV.Left      := mmoText.Left + mmoText.Width;

	pnlBackground.Height:= Self.Height+50;

end;

procedure TStdBizDocPanel.RefreshDisplayLines;

	procedure ShowOrderStatus(lineItem : TListItem; liNode : String);
	var
	  cs : String;
	  rcvdsofar,qtyordered: Integer;
	begin
		// -- Find out how many have been received so far
		rcvdsofar := CurrentDocument.GetIntegerElement(liNode,STDDOC_ELE_ITEM_QTY_RCVD,0);

		// -- Determine quantity ordered
		qtyordered := CurrentDocument.GetIntegerElement(liNode,STDDOC_ELE_ITEM_QTY,0);

		// -- Now determine which icon to use
		if (qtyOrdered = rcvdsofar) then
			lineItem.StateIndex := 2
		else if ((rcvdsofar > 0) and ((rcvdsofar)< qtyordered)) then
			lineItem.StateIndex := 1
		else
			lineItem.StateIndex := 0;

	end;

var
	xc : Integer;
	workingNode  : GTDNode;
	Item : TListItem;
	linode : String;
begin
	txtStatus.Text := fCurrentDoc.Local_Status_Code;

	WorkingNode := GTDNode.Create;

	lsvLineItems.Items.Clear;
	
	// -- Load the body text
	if WorkingNode.ExtractTaggedSection(STDDOC_LINE_ITEMS,fCurrentDoc.XML) then
	begin
		// -- Load all the data into the list
		WorkingNode.LoadDataLSV(STDDOC_LINE_ITEM, STDDOC_ELE_ITEM_CODE + ';' +
									   STDDOC_ELE_ITEM_NAME + ';' +
									   STDDOC_ELE_ITEM_QTY  + ';' +
									   STDDOC_ELE_ITEM_RATE + ';' +
									   STDDOC_ELE_ITEM_UNIT + ';' +
									   STDDOC_ELE_ITEM_AMOUNT,TListView(lsvLineItems));

		// -- Quickly fix up the data
		for xc := 1 to lsvLineItems.Items.Count do
		begin
			Item := lsvLineItems.Items[xc-1];

			// -- Fix up the icon
			Item.ImageIndex := 11;

			// -- Calculate the path to the node
			linode := STDDOC_LINE_ITEMS_NODE + STDDOC_LINE_ITEM_NODE + '[' + IntToStr(xc) + ']';

			// -- If it's a purchase order then there are some extra things to do
			if CurrentDocument.Document_Type = GTD_ORDER_TYPE then
				ShowOrderStatus(item,liNode)
			else
				Item.StateIndex := -1;
			end;

		// -- Display the account balance at the bottom
		// lblOrderTotal.Caption := Format('%m',[fWorkingDoc.Document_Total]);

	end;

	WorkingNode.Destroy;

end;

procedure TStdBizDocPanel.RefreshDisplay;
var
	xc  : Integer;
    Loaded : Boolean;
    VendorNodeName, s, taxType, CountryCode : String;
    md : TDateTime;
    workingNode  : GTDNode;

    procedure LoadHeaderFields;
        procedure AddField(EleName, EleValue : String);
        var
            anItem : TListItem;
        begin
            if EleValue <> '' then
            begin
                anItem := grdDocProperties.Items.Add;
                anItem.Caption := EleName;
                anItem.SubItems.Add(Elevalue);
            end;
        end;
    begin
        grdDocProperties.Items.Clear;

//    STDDOC_HDR_ELE_TITLE       = 'Document_Title';
//    STDDOC_HDR_ELE_ORDER_NUM   = 'Document_Number';
//    STDDOC_HDR_ELE_ORDER_DATE  = 'Document_Date';
		AddField(STDDOC_HDR_ELE_SALES_PERSON, WorkingNode.ReadStringField(STDDOC_HDR_ELE_SALES_PERSON));
        AddField(STDDOC_HDR_ELE_CONTACT,      WorkingNode.ReadStringField(STDDOC_HDR_ELE_CONTACT));
        AddField(STDDOC_HDR_ELE_DELIV_MODE,   WorkingNode.ReadStringField(STDDOC_HDR_ELE_DELIV_MODE));
        AddField(STDDOC_HDR_ELE_DELIV_DATE,   WorkingNode.ReadStringField(STDDOC_HDR_ELE_DELIV_DATE));
        AddField(STDDOC_HDR_ELE_DELIV_ADDR,   WorkingNode.ReadStringField(STDDOC_HDR_ELE_DELIV_ADDR));
        AddField(STDDOC_HDR_ELE_DELIV_FROM,   WorkingNode.ReadStringField(STDDOC_HDR_ELE_DELIV_FROM));
        AddField(STDDOC_HDR_ELE_DELIV_VIA,    WorkingNode.ReadStringField(STDDOC_HDR_ELE_DELIV_VIA));
        AddField(STDDOC_HDR_ELE_DELIV_CHG,    WorkingNode.ReadStringField(STDDOC_HDR_ELE_DELIV_CHG));
        AddField(STDDOC_HDR_ELE_PMT_TERMS,    WorkingNode.ReadStringField(STDDOC_HDR_ELE_PMT_TERMS));
        AddField(STDDOC_HDR_ELE_GEN_TERMS,    WorkingNode.ReadStringField(STDDOC_HDR_ELE_GEN_TERMS));
        AddField(STDDOC_HDR_ELE_TAX_MODE,     WorkingNode.ReadStringField(STDDOC_HDR_ELE_TAX_MODE));
        AddField(STDDOC_HDR_ELE_TAX_NAME,     WorkingNode.ReadStringField(STDDOC_HDR_ELE_TAX_NAME));
		AddField(STDDOC_HDR_ELE_TAX_RATE,     WorkingNode.ReadStringField(STDDOC_HDR_ELE_TAX_RATE));
        AddField(STDDOC_HDR_CURRENCY_CODE,    WorkingNode.ReadStringField(STDDOC_HDR_CURRENCY_CODE));
        AddField(STDDOC_HDR_ORIGIN_CODE,      WorkingNode.ReadStringField(STDDOC_HDR_ORIGIN_CODE));
        AddField(STDDOC_HDR_DISPLAY_FORMAT,   WorkingNode.ReadStringField(STDDOC_HDR_DISPLAY_FORMAT));
        AddField(STDDOC_HDR_LOGO_IMAGE,       WorkingNode.ReadStringField(STDDOC_HDR_LOGO_IMAGE));
        AddField(STDDOC_HDR_PAPER_SIZE,       WorkingNode.ReadStringField(STDDOC_HDR_PAPER_SIZE));
        AddField(STDDOC_HDR_PRINT_ORIENT,     WorkingNode.ReadStringField(STDDOC_HDR_PRINT_ORIENT));
        AddField(STDDOC_HDR_HEADER_COLS,      WorkingNode.ReadStringField(STDDOC_HDR_HEADER_COLS));
        AddField(STDDOC_HDR_ITEM_COLS,        WorkingNode.ReadStringField(STDDOC_HDR_ITEM_COLS));

	end;

begin

	// try

		WorkingNode := GTDNode.Create;

		fisLoading := True;

		// -- Setup to use the current countrycode as the default
		GetSettingString(GTD_REG_NOD_GENERAL,GTD_REG_COUNTRYCODE,CountryCode);
		txtTaxType.Caption := GetTaxNameFromCountryCode(CountryCode);
		txtTaxRate.Text    := FloatToStr(GetSalesTaxRateFromCountryCode(CountryCode)) + '%';

		// -- Swap Buyer/seller according to who owns the document
		if (fCurrentDoc.Owned_By = 0) then
		   VendorNodeName := STDDOC_BUYER_NODE
		else
		   VendorNodeName := STDDOC_SELLER_NODE;

		// -- Load up details for the other party
		if WorkingNode.LoadFromDocument(fCurrentDoc,VendorNodeName,True) then
		begin

			// -- Determine the country code
			CountryCode        := WorkingNode.ReadStringField(GTD_PL_ELE_COUNTRYCODE,CountryCode);
			txtTaxType.Caption := GetTaxNameFromCountryCode(CountryCode);

			// -- Fields on second page - Basic Vendor details
			txtName.Text       := WorkingNode.ReadStringField(STDDOC_ELE_COMPANY_NAME);
			txtAddress1.Text   := WorkingNode.ReadStringField(STDDOC_ELE_ADDRESS_LINE_1);
			txtAddress2.Text   := WorkingNode.ReadStringField(STDDOC_ELE_ADDRESS_LINE_2);
			txtCity.Text       := WorkingNode.ReadStringField(STDDOC_ELE_TOWN);
			txtState.Text      := WorkingNode.ReadStringField(STDDOC_ELE_STATE_REGION);
			txtPostcode.Text   := WorkingNode.ReadStringField(STDDOC_ELE_POSTALCODE);
			txtCountry.Text    := GetNameFromCountryCode(CountryCode);

			// -- Fields on the first page, but must come second because some fields are calculated
			if txtState.Text <> '' then
			   txtLocation.Text := txtCity.Text + ', ' + txtState.Text
			ELSE
			   txtLocation.Text := txtCity.Text;
			txtTelephone.Text  := WorkingNode.ReadStringField(STDDOC_ELE_TELEPHONE);

		end
		else begin
			// -- No details available
			txtLocation.Text   := '';
			txtTelephone.Text  := '';

			txtName.Text       := '';
			txtAddress1.Text   := '';
			txtAddress2.Text   := '';
			txtCity.Text       := '';
			txtState.Text      := '';
			txtPostcode.Text   := '';
			txtCountry.Text    := '';

			grdDocProperties.Items.Clear;

		end;

		// -- Load up details for the other party
		if WorkingNode.LoadFromDocument(fCurrentDoc,STDDOC_HDR_NODE,True) then
		begin
			// -- Read the countrycode
			// -- Tax setup
			taxType := WorkingNode.ReadStringField(STDDOC_HDR_ELE_TAX_MODE,STDDOC_CONST_TAX_MODE_EXC);
			if (taxType = STDDOC_CONST_TAX_MODE_INC) then
			   rdoTaxInclusive.Checked := True
			else
			   rdoTaxExclusive.Checked := True;

			LoadHeaderFields;

		end
		else begin
			rdoTaxExclusive.Checked := True;
		end;


	if fCurrentDoc.Document_Type = GTD_ORDER_TYPE then
	begin
		md := fCurrentDoc.GetDateElement(STDDOC_HDR_NODE,STDDOC_HDR_ELE_DELIV_DATE);

		if md = 0 then
			txtDocDate.Text := ''
		else
			txtDocDate.Date := md;
	end
	else
		txtDocDate.Date := fCurrentDoc.Document_Date;

	txtStatus.Text  := fCurrentDoc.Local_Status_Code;
	cbxOrderOurStatusCode.Text := fCurrentDoc.Local_Status_Code;
	rchOrderOurStatusCmts.Text := fCurrentDoc.Local_Status_Comments;
	txtOrderTheirStatusCode.Text := fCurrentDoc.Remote_Status_Code;
	txtOrderTheirStatusCmts.Text := fCurrentDoc.Remote_Status_Comments;

	// -- Some history
	if Assigned(fDocRegistry) then
		fDocRegistry.LoadHistoryToLSV(fCurrentDoc,TListView(lstHistory));

	RefreshDisplayLines;

	Loaded := True;
	CanEdit := True;
	fisLoading := False;

	WorkingNode.Destroy;

end;

procedure TStdBizDocPanel.cbxOrderOurStatusCodeChange(Sender: TObject);
begin
	if not fisLoading then
	begin
		CurrentDocument.Local_Status_Code := cbxOrderOurStatusCode.Text;

		btnSave.Visible := True;
		btnCancel.Visible := True;
	end;
end;

procedure TStdBizDocPanel.rchOrderOurStatusCmtsChange(Sender: TObject);
begin
	if not fisLoading then
	begin
		CurrentDocument.Local_Status_Comments := rchOrderOurStatusCmts.Text;

		btnSave.Visible := True;
		btnCancel.Visible := True;
	end;

end;

procedure TStdBizDocPanel.txtLocationButtonClick(Sender: TObject);
begin
	dlgTextInput.Caption := 'Enter Delivery Address';

	dlgTextInput.Lines.Text := CurrentDocument.GetStringElement(STDDOC_HDR_NODE,STDDOC_HDR_ELE_DELIV_ADDR);
	if dlgTextInput.Execute then
	begin
		// -- Save back the values
		CurrentDocument.SetStringElement(STDDOC_HDR_NODE,STDDOC_HDR_ELE_DELIV_ADDR,dlgTextInput.Lines.Text);

		btnSave.Visible := True;
		btnCancel.Visible := True;
	end;

end;

procedure TStdBizDocPanel.btnNoteClick(Sender: TObject);
var
	s : String;
begin
	if not Assigned(fDocRegistry) then
		Exit;

	// -- Popup a dialog box for them to enter something into
	s := bsSkinInputDialog1.InputBox('Enter Note..', 'Please enter a short comment to record:','');
	if s <> '' then
	begin
		fDocRegistry.RecordAuditTrail(CurrentDocument,'Note',s);
		fDocRegistry.LoadHistoryToLSV(fCurrentDoc,TListView(lstHistory));
	end;

end;

procedure TStdBizDocPanel.btnReceiveItemClick(Sender: TObject);

	function AllItemsReceived:Boolean;
	var
		xc : Integer;
	begin
		Result := True;

		// -- All lines must be received
		for xc := 1 to lsvLineItems.Items.Count do
		begin
			if lsvLineItems.Items[xc - 1].StateIndex <> 2 then
			begin
				Result := False;
				break;
			end;
		end;

	end;

var
	cs,linode : String;
	xc,rcvd,rcvdsofar,qtyordered: Integer;
begin
	// -- This function works slightly differently according to whether
	//    there are more than one item selected
	if lsvLineItems.SelCount = 1 then
	begin

		// -- Only 1 line was selected

		// -- Calculate the path to the node
		linode := STDDOC_LINE_ITEMS_NODE + STDDOC_LINE_ITEM_NODE + '[' + IntToStr(lsvLineItems.Selected.Index + 1) + ']';

		// -- Find out how many have been received so far
		rcvdsofar := CurrentDocument.GetIntegerElement(liNode,STDDOC_ELE_ITEM_QTY_RCVD,0);

		// -- Determine quantity ordered
		qtyordered := CurrentDocument.GetIntegerElement(liNode,STDDOC_ELE_ITEM_QTY,0);

		cs := IntToStr(qtyOrdered - rcvdsofar);

		// -- Popup a dialog box for them to enter something into
		cs := bsSkinInputDialog1.InputBox('Items Received..', 'Please enter number of items received:',cs);
		if cs <> '' then
		begin
			rcvd := StrToInt(cs);

			// -- Write the value back
			CurrentDocument.SetIntegerElement(liNode,STDDOC_ELE_ITEM_QTY_RCVD,rcvd + rcvdsofar);

			// -- Now determine which icon to use
			if (qtyOrdered = rcvdsofar + rcvd) then
				lsvLineItems.Selected.StateIndex := 2
			else if ((rcvdsofar + rcvd > 0) and ((rcvdsofar + rcvd)< qtyordered)) then
				lsvLineItems.Selected.StateIndex := 1
			else
				lsvLineItems.Selected.StateIndex := 0;

		end;

		// -- Show the buttons
		btnSave.Visible := True;
		btnCancel.Visible := True;

	end
	else if lsvLineItems.SelCount > 1 then
	begin
		// -- Multiple items received
		for xc := 1 to lsvLineItems.Items.Count do
		begin

			// -- We only want to process selected items
			if not lsvLineItems.Items[xc-1].Selected then
				continue;

			// -- Calculate the path to the node
			linode := STDDOC_LINE_ITEMS_NODE + STDDOC_LINE_ITEM_NODE + '[' + IntToStr(xc) + ']';

			// -- Find out how many have been received so far
			rcvdsofar := CurrentDocument.GetIntegerElement(liNode,STDDOC_ELE_ITEM_QTY_RCVD,0);

			// -- Determine quantity ordered
			qtyordered := CurrentDocument.GetIntegerElement(liNode,STDDOC_ELE_ITEM_QTY,0);

			rcvd := qtyordered - rcvdsofar;

			// -- Write the value back
			CurrentDocument.SetIntegerElement(liNode,STDDOC_ELE_ITEM_QTY_RCVD,qtyOrdered);

			// -- Now determine which icon to use
			if (qtyOrdered = rcvdsofar + rcvd) then
				lsvLineItems.Items[xc-1].StateIndex := 2
			else if ((rcvdsofar + rcvd > 0) and ((rcvdsofar + rcvd)< qtyordered)) then
				lsvLineItems.Items[xc-1].StateIndex := 1
			else
				lsvLineItems.Items[xc-1].StateIndex := 0;

		end;

		// -- Show the buttons
		btnSave.Visible := True;
		btnCancel.Visible := True;
	end;

	// -- Important to change this flag
	fAsk4DDocNum := True;

	// -- A final check at the end to see if everything was received
	if (AllItemsReceived) and
	   ((CurrentDocument.Local_Status_Code = GTD_DOCSTAT_SENT) or
		(CurrentDocument.Local_Status_Code = GTD_DOCSTAT_PO_AWAIT_DELIV) or
		(CurrentDocument.Local_Status_Code = GTD_DOCSTAT_PO_PARTIAL_DELIV)) then
	begin
		// --
		if mrYes = bsSkinMessage1.MessageDlg('All items have been received.' + #13 + #13 +
											 'Save and Mark this Purchase Order as complete ?',mtConfirmation,[mbYes,mbNo],0) then
		begin
			// -- prompt for a delivery docket number
			Check4DeliveryDocketNumber;

			cbxOrderOurStatusCode.Text := GTD_DOCSTAT_COMPLETE;
			CurrentDocument.Local_Status_Code := GTD_DOCSTAT_COMPLETE;

			// -- Save the document
			fDocRegistry.Save(CurrentDocument,'Status','Document marked as Complete');

			// -- Reload the history
			fDocRegistry.LoadHistoryToLSV(fCurrentDoc,TListView(lstHistory));

			btnSave.Visible := False;
			btnCancel.Visible := False;

		end;
	end

end;

procedure TStdBizDocPanel.lsvLineItemsClick(Sender: TObject);
begin
	if CurrentDocument.Document_Type = GTD_ORDER_TYPE then
	begin
		btnReceiveItem.Visible := True;
		btnReceiveItem.Left    := 366;
		btnReceiveItem.Width   := 60;
	end;
end;

procedure TStdBizDocPanel.Check4DeliveryDocketNumber;
var
	cs : String;
begin
	// -- Disable the flag
	if fAsk4DDocNum then
	begin
		// -- Change the flag
		fAsk4DDocNum := False;

		// -- Prompt the user for a delivery docket number
		cs := bsSkinInputDialog1.InputBox('Delivery Docket..', 'Please enter the delivery docket number:',cs);
		if cs <> '' then
		begin
			// -- Save the entry
			fDocRegistry.RecordAuditTrail(CurrentDocument,'Delivery','Items received on Delivery Docket:' + cs);
		end;
	end;
end;

procedure TStdBizDocPanel.SetJobNumber(newJobNumber : Integer);
var
	xc : Integer;
	s : String;
	foundit : Boolean;
begin
	fJobNum := newJobNumber;

	// -- Update the flag
	if not fisLoading then
		JobNumberChanged := True;

	for xc := 2 to cbxJobSelect.Items.Count do
	begin
		// --
		s := cbxJobSelect.Items[xc-1];
		if StrToInt(Parse(s,',')) = newJobNumber then
		begin
			cbxJobSelect.ItemIndex := xc - 1;
			foundit := true;
			break;
		end;
	end;

	// -- not found so set to -1
	if not foundit then
		cbxJobSelect.ItemIndex := -1;
end;

procedure TStdBizDocPanel.cbxJobSelectChange(Sender: TObject);
var
	s : String;
begin
	if not fisLoading then
	begin
		JobNumberChanged := True;

		if cbxJobSelect.ItemIndex = 0 then
			fJobNum := -1
		else begin
			s := cbxJobSelect.Text;
			fJobNum := StrToInt(Parse(s,','));
		end;

		btnSave.Visible := True;
		btnCancel.Visible := True;
	end;
end;

end.
