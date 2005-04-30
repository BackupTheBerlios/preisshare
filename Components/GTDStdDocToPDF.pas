unit GTDStdDocToPDF;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  PReport, jpeg, PRJpegImage, ExtCtrls, PdfDoc, StdCtrls, SmtpProt,GTDBizDocs,
  ShellAPI, bsSkinCtrls;

type
  TrptPrintStdDocToPDF = class(TForm)
    Button1: TButton;
    PDFReport: TPReport;
    pdfQuotePage: TPRPage;
    PRLayoutPanel1: TPRLayoutPanel;
    qriLogo: TPRJpegImage;
    qrlHeaderName: TPRLabel;
    lblDocumentName: TPRLabel;
    PRRect2: TPRRect;
    qrlDocDate: TPRLabel;
    PRLabel7: TPRLabel;
    qrlToName: TPRLabel;
    qrlFieldLabel1: TPRLabel;
    qrlField1: TPRLabel;
    qrlFieldLabel2: TPRLabel;
    qrlField2: TPRLabel;
    qrlFieldLabel3: TPRLabel;
    qrlField3: TPRLabel;
    PRRect4: TPRRect;
    PRLabel18: TPRLabel;
    PRLabel19: TPRLabel;
    PRLabel20: TPRLabel;
    PRLabel21: TPRLabel;
    PRLabel22: TPRLabel;
    PRLabel23: TPRLabel;
    PRLayoutPanel2: TPRLayoutPanel;
    PRRect5: TPRRect;
    qrlTotalLabel: TPRLabel;
    PRRect6: TPRRect;
    qrlDocTotal: TPRLabel;
    qrlIncTaxTotal: TPRLabel;
    qrlFieldLabel4: TPRLabel;
    qrlField4: TPRLabel;
    qrlTotalTax: TPRLabel;
    qrlSpecialInstructions: TPRText;
    lblDeliveryCharge: TPRLabel;
    qrlDeliveryCharge: TPRLabel;
    qrlDocNum: TPRLabel;
    PRLabel1: TPRLabel;
    qrlToAddress: TPRText;
    qrlHeaderAddress: TPRText;
    Band1: TPRLayoutPanel;
    qrlProduct1: TPRLabel;
    qrlName1: TPRText;
    qrlDesc1: TPRText;
    qrlQty1: TPRLabel;
    qrlUnit1: TPRLabel;
    qrlRate1: TPRLabel;
    qrlAmount1: TPRLabel;
    bsSkinButton1: TbsSkinButton;
    Band2: TPRLayoutPanel;
    qrlProduct2: TPRLabel;
    qrlQty2: TPRLabel;
    qrlUnit2: TPRLabel;
    qrlRate2: TPRLabel;
    qrlAmount2: TPRLabel;
    qrlName2: TPRText;
    qrlDesc2: TPRText;
    Band5: TPRLayoutPanel;
    qrlProduct5: TPRLabel;
    qrlName5: TPRText;
    qrlDesc5: TPRText;
    qrlQty5: TPRLabel;
    qrlUnit5: TPRLabel;
    qrlRate5: TPRLabel;
    qrlAmount5: TPRLabel;
    Band4: TPRLayoutPanel;
    qrlProduct4: TPRLabel;
    qrlName4: TPRText;
    qrlDesc4: TPRText;
    qrlQty4: TPRLabel;
    qrlUnit4: TPRLabel;
    qrlRate4: TPRLabel;
    qrlAmount4: TPRLabel;
    Band3: TPRLayoutPanel;
    qrlProduct3: TPRLabel;
    qrlName3: TPRText;
    qrlDesc3: TPRText;
    qrlQty3: TPRLabel;
    qrlUnit3: TPRLabel;
    qrlAmount3: TPRLabel;
    qrlRate3: TPRLabel;
    PRLabel2: TPRLabel;
    PRRect7: TPRRect;
    PRRect8: TPRRect;
    PRRect9: TPRRect;
    PRRect1: TPRRect;
    PRRect3: TPRRect;
    lblDeliverTo: TPRLabel;
    qrlOrdDeliveryAddress: TPRText;
    PRRect10: TPRRect;
    PRRect11: TPRRect;
    PRRect12: TPRRect;
    PRRect13: TPRRect;
    PRRect14: TPRRect;
    PRRect15: TPRRect;
    PRRect16: TPRRect;
    PRRect17: TPRRect;
    PRLayoutPanel3: TPRLayoutPanel;
    PRRect28: TPRRect;
    procedure bsSkinButton1Click(Sender: TObject);
  private
	aMark : HECMLMarker;
    CurrentDoc  : GTDBizDoc;
    LineNo : Integer;
	procedure PrepareHeader;
    function FillPageItems:Boolean;
    function HaveMoreItems:Boolean;
  public
	procedure PrintDocToFile(aDoc : GTDBizDoc; toFileName : String);
  end;

var
  rptPrintStdDocToPDF: TrptPrintStdDocToPDF;

implementation

{$R *.DFM}

procedure TrptPrintStdDocToPDF.PrepareHeader;
var
	amt,bal,delchg : Double;
	xc,ar  : Integer;
	DocumentRegPath,s,l,t,f,o,np,c,taxType,FromNodeName,ToNodeName,CountryCode : String;
	workingNode  : GTDNode;
begin

	WorkingNode := GTDNode.Create;

	// -- Setup to use the current countrycode as the default
//    GetSettingString(GTD_REG_NOD_GENERAL,GTD_REG_COUNTRYCODE,CountryCode);

	// -- Set the document name
	lblDocumentName.Caption := CurrentDoc.Document_Type;

	if CurrentDoc.Document_Type = GTD_INVOICE_TYPE then
		lblDeliverTo.Caption := 'Delivered to:'
	else
		lblDeliverTo.Caption := 'Deliver to:';

	// -- Swap Buyer/seller according to who owns the document
	if (CurrentDoc.Owned_By = 0) and (CurrentDoc.Document_Type = GTD_INVOICE_TYPE) then
	begin
	   FromNodeName := STDDOC_SELLER_NODE;
	   ToNodeName := STDDOC_BUYER_NODE;
	end
	else begin
	   FromNodeName := STDDOC_BUYER_NODE;
	   ToNodeName := STDDOC_SELLER_NODE;
	end;

	// -- Load up details for the other party
	if WorkingNode.LoadFromDocument(CurrentDoc,ToNodeName,True) then
	begin

		// -- Determine the country code
		CountryCode              := WorkingNode.ReadStringField(GTD_PL_ELE_COUNTRYCODE,CountryCode);
		qrlTotalTax.Caption      := 'Total ' + GetTaxNameFromCountryCode(CountryCode);

		// -- Fields on second page - Basic Vendor details
		qrlToName.Caption    := WorkingNode.ReadStringField(STDDOC_ELE_COMPANY_NAME);
		qrlToAddress.Text    := BuildTraderAddress(WorkingNode.ReadStringField(STDDOC_ELE_ADDRESS_LINE_1),
													   WorkingNode.ReadStringField(STDDOC_ELE_ADDRESS_LINE_2),
													   WorkingNode.ReadStringField(STDDOC_ELE_TOWN),
													   WorkingNode.ReadStringField(STDDOC_ELE_STATE_REGION),
													   WorkingNode.ReadStringField(STDDOC_ELE_POSTALCODE),
													   WorkingNode.ReadStringField(GetNameFromCountryCode(CountryCode)),
													   WorkingNode.ReadStringField(STDDOC_ELE_TELEPHONE),
													   WorkingNode.ReadStringField(STDDOC_ELE_TELEPHONE2),
													   WorkingNode.ReadStringField(STDDOC_ELE_OTHER_INFO));


	end
	else begin
		// -- No details available
		qrlToName.Caption    := '';
		qrlToAddress.Text := '';
	end;

	// -- Reset these fields
	qriLogo.Enabled := False;
    qrlHeaderName.Left := 12;
	qrlHeaderAddress.Left := 12;

    // -- Load up details for the other party
    if WorkingNode.LoadFromDocument(CurrentDoc,STDDOC_HDR_NODE,True) then
    begin

        // -- Read the logo
		s := WorkingNode.ReadStringField(STDDOC_HDR_LOGO_IMAGE);
		if (s <> '') then
		begin

            try

                // -- Write out our attachment
                if CurrentDoc.WriteAttachment(s, GetTempDir) then
                begin

                    // -- Load the image
                    qriLogo.Picture.LoadFromFile(GetTempDir + s);

                    qriLogo.Printable:= True;

                    // -- Now resize the image to the right width
                    ar := (qriLogo.Picture.Width * 100) div qriLogo.Picture.Height;
					qriLogo.Width := (qriLogo.Height * ar) div 100;

					qrlHeaderName.Left := qriLogo.Left + qriLogo.Width + 10;
					qrlHeaderAddress.Left := qrlHeaderName.Left;
                end;

            except
				qriLogo.Enabled := False;
            end;

			DeleteFile(GetTempDir + s);
		end;

        // -- Fix up the label at the bottom
		qrlTotalLabel.Caption := 'Total';

		qrlIncTaxTotal.Caption := Format('%m',[CurrentDoc.Tax_Total]);
		if CurrentDoc.Tax_Total <> 0 then
        begin
			qrlIncTaxTotal.Printable := True;
			qrlTotalTax.Printable    := True;
		end
		else begin
			qrlIncTaxTotal.Printable := False;
            qrlTotalTax.Printable    := False;
        end;

		qrlSpecialInstructions.Text := WorkingNode.ReadStringField(STDDOC_HDR_ELE_GEN_TERMS);

        // -- Only display the delivery charge if there is none
        delchg := WorkingNode.ReadNumberField(STDDOC_HDR_ELE_DELIV_CHG,0);
        if delchg = 0 then
        begin
            // -- No delivery charge; so move things around
            qrlDeliveryCharge.Printable := False;
            lblDeliveryCharge.Printable := False;
        end
		else begin
			// -- delivery charge; so move things around
			qrlDeliveryCharge.Caption := Format('%m',[delchg]);
            qrlDeliveryCharge.Printable := True;
            lblDeliveryCharge.Printable := True;
        end;

        // -- Company Name formatting
        s := WorkingNode.ReadStringField(STDDOC_HDR_NAME_ALIGN);
        if (s = STDDOC_CONST_HDR_ALIGN_RIGHT) then
        begin
            // -- Right justify the company name
			qrlHeaderName.Printable := True;
			qrlHeaderName.Left := 504;
			qrlHeaderName.Alignment := taRightJustify;
        end
        else if (s = STDDOC_CONST_HDR_ALIGN_HIDE) then
		begin
            // -- Hide the display of the company name
			qrlHeaderName.Printable := False;
        end
        else begin
            // -- Default to left justification
			qrlHeaderName.Printable := True;
			qrlHeaderName.Left := 12;
			qrlHeaderName.Alignment := taLeftJustify;
		end;

		// -- Company address formatting
		s := WorkingNode.ReadStringField(STDDOC_HDR_ADDRESS_ALIGN);
		if (s = STDDOC_CONST_HDR_ALIGN_RIGHT) then
		begin
			// -- Right justify the company name
			qrlHeaderAddress.Enabled := True;
			qrlHeaderAddress.Left := 340;
			// Powerpdf doesn't support qrlHeaderAddress.Alignment := taRightJustify;
			if not qrlHeaderName.Printable then
				// -- move the address up
				qrlHeaderAddress.Top := 24 // qrlCompanyName.Top
			else
				qrlHeaderAddress.Top := 36;

		end
		else if (s = STDDOC_CONST_HDR_ALIGN_HIDE) then
		begin
			// -- Hide the display of the company name
			qrlHeaderAddress.Enabled := False;
		end
		else begin
			// -- Default to left justification
			qrlHeaderAddress.Enabled := True;
			qrlHeaderAddress.Left := 12;
            // qrlHeaderAddress.Alignment := taLeftJustify;
			if not qrlHeaderName.Enabled then
				// -- move the address up
				qrlHeaderAddress.Top := qrlHeaderName.Top
			else
                qrlHeaderAddress.Top := 36;
        end;

    end
    else begin
        qrlTotalLabel.Caption := 'Total';
        qrlSpecialInstructions.Text := '';
        lblDeliveryCharge.Printable := False;
        qrlDeliveryCharge.Printable := False;
        qrlIncTaxTotal.Printable := False;
        qrlTotalTax.Printable    := False;
    end;

	// -- Read the details for the Header
	//qrlLocalStatus.Caption := CurrentDoc.Local_Status_Code;
	//qrlVendorsStatus.Caption := CurrentDoc.Remote_Status_Code;
	qrlDocNum.Caption := CurrentDoc.Document_Ref;
	if CurrentDoc.Document_Date = 0 then
		qrlDocDate.Caption := ''
	else
		qrlDocDate.Caption := FormatDateTime('c',CurrentDoc.Document_Date);
	qrlDocTotal.Caption := Format('%m',[CurrentDoc.Document_Total]);

	// -- This is actually the name part at the top
	if WorkingNode.LoadFromDocument(CurrentDoc,FromNodeName,true) then
	begin
		qrlHeaderName.Caption  := WorkingNode.ReadStringField(STDDOC_ELE_COMPANY_NAME);
		qrlHeaderAddress.Text := BuildTraderAddress(WorkingNode.ReadStringField(STDDOC_ELE_ADDRESS_LINE_1),
                                                       WorkingNode.ReadStringField(STDDOC_ELE_ADDRESS_LINE_2),
                                                       WorkingNode.ReadStringField(STDDOC_ELE_TOWN),
                                                       WorkingNode.ReadStringField(STDDOC_ELE_STATE_REGION),
                                                       WorkingNode.ReadStringField(STDDOC_ELE_POSTALCODE),
                                                       WorkingNode.ReadStringField(GetNameFromCountryCode(CountryCode)),
                                                       WorkingNode.ReadStringField(STDDOC_ELE_TELEPHONE),
                                                       WorkingNode.ReadStringField(STDDOC_ELE_TELEPHONE2),
													   WorkingNode.ReadStringField(STDDOC_ELE_OTHER_INFO));

	end;


    //qrlPaymentTerms.Caption := CurrentDoc.GetStringElement(GTD_PO_PAYMENT_NODE,GTD_PO_ELE_PMT_TYPE);

	// -- Print out the delivery information
    {
	np := GTD_PO_DEL_NODE;
    qrlDeliveryMode.Caption         := CurrentDoc.GetStringElement(np,GTD_PO_DEL_ELE_MODE);
    qrlDeliveryDate.Caption         := CurrentDoc.GetStringElement(np,GTD_PO_DEL_ELE_DATE);
	}

	// -- Print out the delivery information
	qrlOrdDeliveryAddress.Text      := CurrentDoc.GetStringElement(STDDOC_HDR_NODE,GTD_PO_DEL_ELE_ADDR);
	qrlFieldLabel1.Caption          := 'Delivery Date';
	qrlFieldLabel2.Caption 			:= 'Contact';

	if CurrentDoc.Document_Type = GTD_ORDER_TYPE then
	begin
		qrlFieldLabel3.Caption      := 'Approved by';
		qrlField3.Caption           := CurrentDoc.GetStringElement(STDDOC_HDR_NODE,STDDOC_HDR_ELE_APPRVD_BY);
	end
	else if CurrentDoc.Document_Type = GTD_INVOICE_TYPE then
	begin
		qrlFieldLabel3.Caption      := '';
		qrlField3.Caption           := '';
	end;

	qrlFieldLabel4.Caption          := '';
	qrlField1.Caption               := CurrentDoc.GetStringElement(STDDOC_HDR_NODE,STDDOC_HDR_ELE_DELIV_DATE);
	qrlField2.Caption               := CurrentDoc.GetStringElement(STDDOC_HDR_NODE,STDDOC_HDR_ELE_CONTACT);
	qrlField4.Caption               := '';

	workingNode.Destroy;
end;

function TrptPrintStdDocToPDF.HaveMoreItems:Boolean;
var
    nl : String;
begin
    nl := STDDOC_LINE_ITEMS_NODE + STDDOC_LINE_ITEM_NODE + '[' + IntToStr(LineNo) + ']';

    Result := CurrentDoc.NodeExists(nl);
end;

function TrptPrintStdDocToPDF.FillPageItems:Boolean;
const
    PrintableRows = 5;
    picwidth = 185;
    picHeight = 117;
var
	ProductItemNodes, ProductItemNode : GTDNode;
	nl : String;
	picID : Integer;
	qrlName,
	qrlDesc  :TPRText;
	qrlProduct,
    qrlUnit,
    qrlRate,
    qrlQty,
    qrlAmount : TPRLabel;
	PrintLinePos : Integer;
    DetailBand1 : TPRLayoutPanel;
begin

    Result := False;

    nl := STDDOC_LINE_ITEMS_NODE + STDDOC_LINE_ITEM_NODE + '[' + IntToStr(LineNo) + ']';

    if not CurrentDoc.NodeExists(nl) then
        Exit;

    ProductItemNodes := GTDNode.Create;
    ProductItemNode := GTDNode.Create;

    PrintLinePos := LineNo mod PrintableRows;

    case PrintLinePos of
		1 : begin
				DetailBand1:= Band1;
				qrlName    := qrlName1;
				qrlDesc    := qrlDesc1;
				qrlProduct := qrlProduct1;
				qrlUnit    := qrlUnit1;
				qrlRate    := qrlRate1;
				qrlQty     := qrlQty1;
				qrlAmount  := qrlAmount1;
			end;
		2 : begin
				DetailBand1:= Band2;
				Band2.Top  := Band1.Top + Band1.Height;
				qrlName    := qrlName2;
				qrlDesc    := qrlDesc2;
				qrlProduct := qrlProduct2;
				qrlUnit    := qrlUnit2;
				qrlRate    := qrlRate2;
				qrlQty     := qrlQty2;
				qrlAmount  := qrlAmount2;
			end;
        3 : begin
                DetailBand1:= Band3;
                Band3.Top  := Band2.Top + Band2.Height;
                qrlName    := qrlName3;
                qrlDesc    := qrlDesc3;
                qrlProduct := qrlProduct3;
                qrlUnit    := qrlUnit3;
                qrlRate    := qrlRate3;
                qrlQty     := qrlQty3;
				qrlAmount  := qrlAmount3;
			end;
		4 : begin
				DetailBand1:= Band4;
				Band4.Top  := Band3.Top + Band3.Height;
				qrlName    := qrlName4;
				qrlDesc    := qrlDesc4;
				qrlProduct := qrlProduct4;
				qrlUnit    := qrlUnit4;
				qrlRate    := qrlRate4;
				qrlQty     := qrlQty4;
				qrlAmount  := qrlAmount4;
			end;
        5 : begin
                DetailBand1:= Band5;
                Band5.Top  := Band4.Top + Band4.Height;
                qrlName    := qrlName5;
                qrlDesc    := qrlDesc5;
                qrlProduct := qrlProduct5;
                qrlUnit    := qrlUnit5;
                qrlRate    := qrlRate5;
                qrlQty     := qrlQty5;
                qrlAmount  := qrlAmount5;
			end
			else begin
				DetailBand1:= Band1;
				qrlName    := qrlName1;
				qrlDesc    := qrlDesc1;
				qrlProduct := qrlProduct1;
				qrlUnit    := qrlUnit1;
				qrlRate    := qrlRate1;
				qrlQty     := qrlQty1;
				qrlAmount  := qrlAmount1;
			end;
	end;

	// -- Initialise all fields for this line as printable (excpet picture)
	qrlName.Printable := True;
	qrlDesc.Printable := True;
	qrlProduct.Printable := True;
	qrlUnit.Printable := True;
	qrlRate.Printable := True;                                          
	qrlQty.Printable := True;
	qrlAmount.Printable := True;

	// -- We have a line item
	qrlProduct.Caption   := CurrentDoc.GetStringElement(nl, STDDOC_ELE_ITEM_CODE);
	qrlName.Text         := CurrentDoc.GetStringElement(nl, STDDOC_ELE_ITEM_NAME);

	qrlDesc.WordWrap     := False;
	qrlDesc.Text         := CurrentDoc.GetStringElement(nl, STDDOC_ELE_ITEM_DESC);
	if qrlDesc.Text <> '' then
	begin
		qrlDesc.WordWrap := True;
		picID := qrlDesc.Lines.Count;
		qrlDesc.Height   := 30; // BUG IN ORIGINAL CODE - > qrlDesc.Lines.Count * 15;
	end;

	if qrlDesc.Text = '' then
	begin
		DetailBand1.Height := qrlName.Top + qrlName.Height;
	end
	else begin
		DetailBand1.Height := qrlDesc.Top + qrlDesc.Height;
	end;

	qrlQty.Caption      := CurrentDoc.GetStringElement(nl, STDDOC_ELE_ITEM_QTY);
	qrlRate.Caption     := CurrentDoc.GetStringElement(nl, STDDOC_ELE_ITEM_RATE);
	qrlUnit.Caption     := CurrentDoc.GetStringElement(nl, STDDOC_ELE_ITEM_UNIT);
	qrlAmount.Caption   := CurrentDoc.GetStringElement(nl, STDDOC_ELE_ITEM_AMOUNT);

    ProductItemNodes.Destroy;
    ProductItemNode.Destroy;

    Inc(LineNo);

    Result := True;
end;

procedure TrptPrintStdDocToPDF.PrintDocToFile(aDoc : GTDBizDoc; toFileName : String);

    procedure BlankAllFields;
    begin

        Band1.Height := 0;
        Band2.Height := 0;
        Band3.Height := 0;
        Band4.Height := 0;
        Band5.Height := 0;

        qrlName1.Printable := False;
        qrlDesc1.Printable := False;
        qrlProduct1.Printable := False;
        qrlUnit1.Printable := False;
        qrlRate1.Printable := False;
        qrlQty1.Printable := False;
        qrlAmount1.Printable := False;

        // Band2.Printable := False;
        qrlName2.Printable := False;
        qrlDesc2.Printable := False;
        qrlProduct2.Printable := False;
        qrlUnit2.Printable := False;
        qrlRate2.Printable := False;
        qrlQty2.Printable := False;
        qrlAmount2.Printable := False;

        // Band3.Printable := False;
        qrlName3.Printable := False;
        qrlDesc3.Printable := False;
        qrlProduct3.Printable := False;
        qrlUnit3.Printable := False;
        qrlRate3.Printable := False;
        qrlQty3.Printable := False;
        qrlAmount3.Printable := False;

        // Band4.Printable := False;
        qrlName4.Printable := False;
        qrlDesc4.Printable := False;
        qrlProduct4.Printable := False;
        qrlUnit4.Printable := False;
        qrlRate4.Printable := False;
        qrlQty4.Printable := False;
        qrlAmount4.Printable := False;

		// Band5.Printable := False;
		qrlName5.Printable := False;
		qrlDesc5.Printable := False;
        qrlProduct5.Printable := False;
        qrlUnit5.Printable := False;
        qrlRate5.Printable := False;
        qrlQty5.Printable := False;
        qrlAmount5.Printable := False;
	end;

begin
	CurrentDoc := aDoc;

    PDFReport.FileName := toFileName;
    PDFReport.BeginDoc;
    PrepareHeader;

    BlankAllFields;

    LineNo := 1;

    // -- Now do the printing of the items
    while HaveMoreItems do
    begin
        FillPageItems;
    end;

    PDFReport.Print(pdfQuotePage);
    PDFReport.EndDoc;

end;

procedure TrptPrintStdDocToPDF.bsSkinButton1Click(Sender: TObject);
begin
    {
    ShellExecute(frmMain.Handle,	// handle to parent window
                 'open',	        // pointer to string that specifies operation to perform
                 PChar(PDFReport.FileName),	// pointer to filename or folder name string
                 nil,	            // pointer to string that specifies executable-file parameters
                 nil,	            // pointer to string that specifies default directory
                 SW_SHOWNORMAL 	    // whether file is shown when opened
                 );
    }
end;

end.
