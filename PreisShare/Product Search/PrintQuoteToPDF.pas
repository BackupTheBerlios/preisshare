unit PrintQuoteToPDF;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  PReport, jpeg, PRJpegImage, ExtCtrls, PdfDoc, StdCtrls, SmtpProt,GTDBizDocs,
  ShellAPI, bsSkinCtrls;

type
  TrptPrintQuoteToPDF = class(TForm)
    Button1: TButton;
    PDFReport: TPReport;
    pdfQuotePage: TPRPage;
    PRLayoutPanel1: TPRLayoutPanel;
    qriLogo: TPRJpegImage;
    qrlCompanyName: TPRLabel;
    PRRect1: TPRRect;
    PRLabel5: TPRLabel;
    PRRect2: TPRRect;
    qrlDocDate: TPRLabel;
    PRRect3: TPRRect;
    PRLabel7: TPRLabel;
    qrlVendorName: TPRLabel;
    PRLabel12: TPRLabel;
    qrlDeliveryMode: TPRLabel;
    PRLabel14: TPRLabel;
    qrlDeliveryDate: TPRLabel;
    PRLabel16: TPRLabel;
    qrlContact: TPRLabel;
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
    qrlTaxName: TPRLabel;
    qrlTaxType: TPRLabel;
    qrlTotalTax: TPRLabel;
    qrlSpecialInstructions: TPRText;
    lblDeliveryCharge: TPRLabel;
    qrlDeliveryCharge: TPRLabel;
    qrlDocNum: TPRLabel;
    PRLabel1: TPRLabel;
    qrlVendorAddress: TPRText;
    qrlTraderAddress: TPRText;
    Band1: TPRLayoutPanel;
    qrlProduct1: TPRLabel;
    qrlName1: TPRText;
    qrlDesc1: TPRText;
    qrlQty1: TPRLabel;
    qrlUnit1: TPRLabel;
    qrlRate1: TPRLabel;
    qrlAmount1: TPRLabel;
    qpiPic1: TPRJpegImage;
    Image1: TImage;
    bsSkinButton1: TbsSkinButton;
    Band2: TPRLayoutPanel;
    qrlProduct2: TPRLabel;
    qrlQty2: TPRLabel;
    qrlUnit2: TPRLabel;
    qrlRate2: TPRLabel;
    qrlAmount2: TPRLabel;
    qrlName2: TPRText;
    qrlDesc2: TPRText;
    qpiPic2: TPRJpegImage;
    Band5: TPRLayoutPanel;
    qrlProduct5: TPRLabel;
    qrlName5: TPRText;
    qrlDesc5: TPRText;
    qpiPic5: TPRJpegImage;
    qrlQty5: TPRLabel;
    qrlUnit5: TPRLabel;
    qrlRate5: TPRLabel;
    qrlAmount5: TPRLabel;
    Band4: TPRLayoutPanel;
    qrlProduct4: TPRLabel;
    qrlName4: TPRText;
    qrlDesc4: TPRText;
    qpiPic4: TPRJpegImage;
    qrlQty4: TPRLabel;
    qrlUnit4: TPRLabel;
    qrlRate4: TPRLabel;
    qrlAmount4: TPRLabel;
    Band3: TPRLayoutPanel;
    qrlProduct3: TPRLabel;
    qrlName3: TPRText;
    qrlDesc3: TPRText;
    qpiPic3: TPRJpegImage;
    qrlQty3: TPRLabel;
    qrlUnit3: TPRLabel;
    qrlAmount3: TPRLabel;
    qrlRate3: TPRLabel;
    PRLabel2: TPRLabel;
    procedure bsSkinButton1Click(Sender: TObject);
  private
    aMark : HECMLMarker;
    CurrentDoc  : GTDBizDoc;
    LineNo : Integer;
	procedure PrepareHeader;
    function FillPageItems:Boolean;
    function HaveMoreItems:Boolean;
  public
    procedure PrintQuote(aDoc : GTDBizDoc; toFileName : String);
  end;

var
  rptPrintQuoteToPDF: TrptPrintQuoteToPDF;

implementation

uses Main;

{$R *.DFM}

procedure TrptPrintQuoteToPDF.PrepareHeader;
var
	amt,bal,delchg : Double;
	xc,ar  : Integer;
	DocumentRegPath,s,l,t,f,o,np,c,taxType,VendorNodeName,CountryCode : String;
    workingNode  : GTDNode;
begin

   WorkingNode := GTDNode.Create;

    // -- Setup to use the current countrycode as the default
//    GetSettingString(GTD_REG_NOD_GENERAL,GTD_REG_COUNTRYCODE,CountryCode);

    // -- Swap Buyer/seller according to who owns the document
    if (CurrentDoc.Owned_By = 0) then
       VendorNodeName := STDDOC_BUYER_NODE
    else
       VendorNodeName := STDDOC_SELLER_NODE;

    // -- Load up details for the other party
    if WorkingNode.LoadFromDocument(CurrentDoc,VendorNodeName,True) then
    begin

        // -- Determine the country code
        CountryCode              := WorkingNode.ReadStringField(GTD_PL_ELE_COUNTRYCODE,CountryCode);
        qrlTotalTax.Caption      := 'Total ' + GetTaxNameFromCountryCode(CountryCode);

        // -- Fields on second page - Basic Vendor details
        qrlVendorName.Caption    := WorkingNode.ReadStringField(STDDOC_ELE_COMPANY_NAME);
        qrlVendorAddress.Text    := BuildTraderAddress(WorkingNode.ReadStringField(STDDOC_ELE_ADDRESS_LINE_1),
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
        qrlVendorName.Caption    := '';
        qrlVendorAddress.Text := '';
    end;

    // -- Reset these fields
    qriLogo.Enabled := False;
    qrlCompanyName.Left := 12;
    qrlTraderAddress.Left := 12;

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

                    qrlCompanyName.Left := qriLogo.Left + qriLogo.Width + 10;
                    qrlTraderAddress.Left := qrlCompanyName.Left;
                end;

            except
                qriLogo.Enabled := False;
            end;

            DeleteFile(GetTempDir + s);
        end;

        // -- Tax setup
        qrlTaxName.Caption := WorkingNode.ReadStringField(STDDOC_HDR_ELE_TAX_NAME,GetTaxNameFromCountryCode(CountryCode));
        taxType := WorkingNode.ReadStringField(STDDOC_HDR_ELE_TAX_MODE,STDDOC_CONST_TAX_MODE_EXC);

        // -- Fix up the label at the bottom
        if (taxType = STDDOC_CONST_TAX_MODE_EXC) then
           qrlTotalLabel.Caption := 'Total (Ex. ' + qrlTaxName.Caption + ')'
        else
           qrlTotalLabel.Caption := 'Total (Inc.' + qrlTaxName.Caption + ')';

        qrlTotalTax.Caption := 'Total ' + qrlTaxName.Caption;
        qrlIncTaxTotal.Caption := Format('%m',[WorkingNode.ReadNumberField(STDDOC_HDR_ELE_TAX_TOTAL,0)]);
        if qrlIncTaxTotal.Caption <> '' then
        begin
            qrlIncTaxTotal.Enabled := True;
            qrlTotalTax.Enabled    := True;
        end
        else begin
            qrlIncTaxTotal.Enabled := False;
            qrlTotalTax.Enabled    := False;
        end;

        qrlTaxType.Caption := TaxType;

        qrlTaxType.Left := qrlTaxName.Left + qrlTaxName.Width + 5;
        qrlDeliveryMode.Caption := WorkingNode.ReadStringField(STDDOC_HDR_ELE_DELIV_MODE);
        qrlDeliveryDate.Caption := WorkingNode.ReadStringField(STDDOC_HDR_QUOTE_EXPIRES);
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
            qrlCompanyName.Printable := True;
            qrlCompanyName.Left := 504;
            qrlCompanyName.Alignment := taRightJustify;
        end
        else if (s = STDDOC_CONST_HDR_ALIGN_HIDE) then
        begin
            // -- Hide the display of the company name
            qrlCompanyName.Printable := False;
        end
        else begin
            // -- Default to left justification
            qrlCompanyName.Printable := True;
            qrlCompanyName.Left := 32;
            qrlCompanyName.Alignment := taLeftJustify;
        end;

        // -- Company address formatting
        s := WorkingNode.ReadStringField(STDDOC_HDR_ADDRESS_ALIGN);
        if (s = STDDOC_CONST_HDR_ALIGN_RIGHT) then
        begin
            // -- Right justify the company name
            qrlTraderAddress.Enabled := True;
            qrlTraderAddress.Left := 340;
            // Powerpdf doesn't support qrlTraderAddress.Alignment := taRightJustify;
            if not qrlCompanyName.Printable then
                // -- move the address up
                qrlTraderAddress.Top := 24 // qrlCompanyName.Top
            else
                qrlTraderAddress.Top := 36;

        end
        else if (s = STDDOC_CONST_HDR_ALIGN_HIDE) then
        begin
            // -- Hide the display of the company name
            qrlTraderAddress.Enabled := False;
        end
        else begin
            // -- Default to left justification
            qrlTraderAddress.Enabled := True;
            qrlTraderAddress.Left := 12;
            // qrlTraderAddress.Alignment := taLeftJustify;
            if not qrlCompanyName.Enabled then
                // -- move the address up
                qrlTraderAddress.Top := qrlCompanyName.Top
            else
                qrlTraderAddress.Top := 36;
        end;

    end
    else begin
        qrlTaxName.Caption := GetTaxNameFromCountryCode(CountryCode);
        qrlTotalLabel.Caption := 'Total';
        qrlTaxType.Caption := STDDOC_CONST_TAX_MODE_EXC;
        qrlDeliveryMode.Caption := '';
        qrlDeliveryDate.Caption := '';
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

    // -- Swap Buyer/seller according to who owns the document
    if (CurrentDoc.Owned_By <> 0) then
       VendorNodeName := STDDOC_BUYER_NODE
    else
       VendorNodeName := STDDOC_SELLER_NODE;

	if WorkingNode.LoadFromDocument(CurrentDoc,VendorNodeName,true) then
	begin
 		qrlCompanyName.Caption  := WorkingNode.ReadStringField(STDDOC_ELE_COMPANY_NAME);
   qrlTraderAddress.Text := BuildTraderAddress(WorkingNode.ReadStringField(STDDOC_ELE_ADDRESS_LINE_1),
                                                       WorkingNode.ReadStringField(STDDOC_ELE_ADDRESS_LINE_2),
                                                       WorkingNode.ReadStringField(STDDOC_ELE_TOWN),
                                                       WorkingNode.ReadStringField(STDDOC_ELE_STATE_REGION),
                                                       WorkingNode.ReadStringField(STDDOC_ELE_POSTALCODE),
                                                       WorkingNode.ReadStringField(GetNameFromCountryCode(CountryCode)),
                                                       WorkingNode.ReadStringField(STDDOC_ELE_TELEPHONE),
                                                       WorkingNode.ReadStringField(STDDOC_ELE_TELEPHONE2),
                                                       WorkingNode.ReadStringField(STDDOC_ELE_OTHER_INFO));

		 qrlContact.Caption      := WorkingNode.ReadStringField('Contact');

	end
	else begin
		 qrlContact.Caption      := '';
	end;


    //qrlPaymentTerms.Caption := CurrentDoc.GetStringElement(GTD_PO_PAYMENT_NODE,GTD_PO_ELE_PMT_TYPE);

    // -- Print out the delivery information
    {
	np := GTD_PO_DEL_NODE;
    qrlDeliveryMode.Caption         := CurrentDoc.GetStringElement(np,GTD_PO_DEL_ELE_MODE);
    qrlDeliveryDate.Caption         := CurrentDoc.GetStringElement(np,GTD_PO_DEL_ELE_DATE);
    //qrlOrdDeliveryAddress.Caption   := CurrentDoc.GetStringElement(np,GTD_PO_DEL_ELE_ADDR);
    }

    workingNode.Destroy;
end;

function TrptPrintQuoteToPDF.HaveMoreItems:Boolean;
var
    nl : String;
begin
    nl := STDDOC_LINE_ITEMS_NODE + STDDOC_LINE_ITEM_NODE + '[' + IntToStr(LineNo) + ']';

    Result := CurrentDoc.NodeExists(nl);
end;

function TrptPrintQuoteToPDF.FillPageItems:Boolean;
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
    qpiPic : TPRJpegImage;
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
                qpiPic     := qpiPic1;
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
                qpiPic     := qpiPic2;
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
                qpiPic     := qpiPic3;
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
                qpiPic     := qpiPic4;
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
                qpiPic     := qpiPic5;
            end;
        6 : begin
                {
                qrlName    := qrlName6;
                qrlDesc    := qrlDesc6;
                qrlProduct := qrlProduct6;
                qrlUnit    := qrlUnit6;
                qrlRate    := qrlRate6;
                qrlQty     := qrlQty6;
                qrlAmount  := qrlAmount6;
                qpiPic     := qpiPic6;
                }
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
    qpiPic.Printable := True;

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

    // -- Now load up details of the picture
    picID := CurrentDoc.GetIntegerElement(nl, STDDOC_ELE_ITEM_IMAGE,-1);

    {
    if (picID <> -1) and (dmlData.LoadLibraryPic(PicID,Image1,picwidth,picHeight) = '') then
    begin
        qpiPic.Picture.Assign(Image1.Picture);
        qpiPic.Top := qrlName.Top + qrlName.Height;
        qpiPic.Width := Image1.Width;
        qpiPic.Height := Image1.Height;
        qpiPic.Printable := True;
        qrlDesc.Top := qpiPic.Top + qpiPic.Height + 5;
    end
    else begin
        qpiPic.Picture.Graphic := nil;
        qpiPic.Printable := False;
        qrlName.Top := 4;
        qrlDesc.Top := 24;
    end;
    }

    if qrlDesc.Text = '' then
    begin
        DetailBand1.Height := qrlName.Top + qrlName.Height + qpiPic.Height;
    end
    else begin
        DetailBand1.Height := qrlDesc.Top + qrlDesc.Height;
    end;

    if DetailBand1.Height < 30 then
    begin
        qrlQty.Top := 4;
        qrlRate.Top := 4;
        qrlUnit.Top := 4;
        qrlAmount.Top := 4;
    end
    else begin
        if qrlDesc.Text = '' then
        begin
            qrlQty.Top := DetailBand1.Height - qrlQty.Height - 4;
            qrlRate.Top := DetailBand1.Height - qrlRate.Height - 4;
            qrlUnit.Top := DetailBand1.Height - qrlUnit.Height - 4;
            qrlAmount.Top := DetailBand1.Height - qrlAmount.Height - 4;
        end
        else begin
            qrlQty.Top := qrlDesc.Top;
            qrlRate.Top := qrlDesc.Top;
            qrlUnit.Top := qrlDesc.Top;
            qrlAmount.Top := qrlDesc.Top;
        end;
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

procedure TrptPrintQuoteToPDF.PrintQuote(aDoc : GTDBizDoc; toFileName : String);

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
        qpiPic1.Printable := False;

        // Band2.Printable := False;
        qrlName2.Printable := False;
        qrlDesc2.Printable := False;
        qrlProduct2.Printable := False;
        qrlUnit2.Printable := False;
        qrlRate2.Printable := False;
        qrlQty2.Printable := False;
        qrlAmount2.Printable := False;
        qpiPic2.Printable := False;

        // Band3.Printable := False;
        qrlName3.Printable := False;
        qrlDesc3.Printable := False;
        qrlProduct3.Printable := False;
        qrlUnit3.Printable := False;
        qrlRate3.Printable := False;
        qrlQty3.Printable := False;
        qrlAmount3.Printable := False;
        qpiPic3.Printable := False;

        // Band4.Printable := False;
        qrlName4.Printable := False;
        qrlDesc4.Printable := False;
        qrlProduct4.Printable := False;
        qrlUnit4.Printable := False;
        qrlRate4.Printable := False;
        qrlQty4.Printable := False;
        qrlAmount4.Printable := False;
        qpiPic4.Printable := False;

        // Band5.Printable := False;
        qrlName5.Printable := False;
        qrlDesc5.Printable := False;
        qrlProduct5.Printable := False;
        qrlUnit5.Printable := False;
        qrlRate5.Printable := False;
        qrlQty5.Printable := False;
        qrlAmount5.Printable := False;
        qpiPic5.Printable := False;
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

procedure TrptPrintQuoteToPDF.bsSkinButton1Click(Sender: TObject);
begin
    ShellExecute(frmMain.Handle,	// handle to parent window
                 'open',	        // pointer to string that specifies operation to perform
                 PChar(PDFReport.FileName),	// pointer to filename or folder name string
                 nil,	            // pointer to string that specifies executable-file parameters
                 nil,	            // pointer to string that specifies default directory
                 SW_SHOWNORMAL 	    // whether file is shown when opened
                 );

end;

end.
