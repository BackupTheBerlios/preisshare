unit ProductEdit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  BusinessSkinForm, bsSkinCtrls, bsSkinBoxCtrls, StdCtrls, ComCtrls, Mask, Jpeg,
  ExtCtrls, bsSkinGrids, ProductLister, bsSkinTabs, GTDBizDocs, bsMessages, DB,
  Menus, bsSkinShellCtrls, bsSkinData;

type
  TfrmProductEdit = class(TForm)
    bsBusinessSkinForm1: TbsBusinessSkinForm;
    nbkEditing: TbsSkinPageControl;
    pgGroups: TbsSkinTabSheet;
    btnEditTheItems: TbsSkinButton;
    bsSkinPanel1: TbsSkinPanel;
    bsSkinToolBar2: TbsSkinToolBar;
    btnAddProductGroup: TbsSkinSpeedButton;
    btnDeleteProductGroup: TbsSkinSpeedButton;
    btnProductGroupUp: TbsSkinSpeedButton;
    btnProductGroupDown: TbsSkinSpeedButton;
    btnProductGroupRename: TbsSkinSpeedButton;
    tvwGroups: TbsSkinTreeView;
    ssbGroups: TbsSkinScrollBar;
    pdlList1: TProductLister;
    ssbItems: TbsSkinScrollBar;
    bsSkinToolBar4: TbsSkinToolBar;
    btnBasicViewStyle: TbsSkinSpeedButton;
    btnLeftViewStyle: TbsSkinSpeedButton;
    pgItems: TbsSkinTabSheet;
    lsvItems: TbsSkinListView;
    bsSkinScrollBar1: TbsSkinScrollBar;
    bsSkinToolBar1: TbsSkinToolBar;
    btnAddItem: TbsSkinSpeedButton;
    btnDelItem: TbsSkinSpeedButton;
    btnUpItem: TbsSkinSpeedButton;
    btnDownItem: TbsSkinSpeedButton;
    bsSkinPageControl1: TbsSkinPageControl;
    pgBasicItemInformation: TbsSkinTabSheet;
    bsSkinSpeedButton1: TbsSkinSpeedButton;
    bsSkinBevel6: TbsSkinBevel;
    imgProduct: TImage;
    lblImageSize: TbsSkinStdLabel;
    stbAvailability: TbsSkinTrackBar;
    lblAvailability: TbsSkinLabel;
    lblListPrice: TbsSkinLabel;
    txtProductList: TbsSkinNumericEdit;
    txtProductSell: TbsSkinNumericEdit;
    lblSellPrice: TbsSkinLabel;
    lblName: TbsSkinLabel;
    txtProductName: TbsSkinEdit;
    txtProductDesc: TbsSkinRichEdit;
    lblDescription: TbsSkinLabel;
    lblProductCode: TbsSkinLabel;
    txtProductCode: TbsSkinEdit;
    lblUnitOfMeasure: TbsSkinLabel;
    cbxUOM: TbsSkinComboBox;
    cbxBrand: TbsSkinComboBox;
    lblBrand: TbsSkinLabel;
    lblTaxRate: TbsSkinLabel;
    cbxTaxRate: TbsSkinComboBox;
    cbxOnSpecial: TbsSkinCheckRadioBox;
    lblPicture: TbsSkinLabel;
    txtPicture: TbsSkinEdit;
    cbxAvailability: TbsSkinEdit;
    tbsProductExtended: TbsSkinTabSheet;
    lsvFeatures: TbsSkinListView;
    lblFeatures: TbsSkinLabel;
    lblStyles: TbsSkinLabel;
    lsvStyles: TbsSkinListView;
    lsvOptions: TbsSkinListView;
    lblOptions: TbsSkinLabel;
    btnClose: TbsSkinButton;
    btnUpdate: TbsSkinButton;
    bsSkinMessage1: TbsSkinMessage;
    pnlDirty: TbsSkinLabel;
    pnlFileName: TbsSkinLabel;
    bsSkinButtonsBar1: TbsSkinButtonsBar;
    PopupMenu1: TPopupMenu;
    Add1: TMenuItem;
    AddSubgroup1: TMenuItem;
    Rename1: TMenuItem;
    Delete1: TMenuItem;
    bsSkinOpenPictureDialog1: TbsSkinOpenPictureDialog;
    Image1: TImage;
    Label2: TLabel;
    Label1: TLabel;
    procedure btnCloseClick(Sender: TObject);
    procedure btnAddProductGroupClick(Sender: TObject);
    procedure btnDeleteProductGroupClick(Sender: TObject);
    procedure btnBasicViewStyleClick(Sender: TObject);
    procedure btnLeftViewStyleClick(Sender: TObject);
    procedure btnAddItemClick(Sender: TObject);
    procedure btnDelItemClick(Sender: TObject);
    procedure btnUpdateClick(Sender: TObject);
    procedure FieldChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lsvItemsChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure tvwGroupsChange(Sender: TObject; Node: TTreeNode);
    procedure nbkEditingChanging(Sender: TObject;
      var AllowChange: Boolean);
    procedure btnEditTheItemsClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure bsSkinSpeedButton1Click(Sender: TObject);
  private
    { Private declarations }
    usingAppendingMethod,
    CancelRun : Boolean;
    productInfoStartLine,
    ItemsDoneCount,

    CatalogLevels,
    Level1Group,Level2Group        : Integer;

    ProductNode,
    ProductGroupNode : GTDNode;

    ProductGroupCursor,
    ProductItemCursor,
	PricelistFileName,

    dbProfileName : String;                    // -- Filename for pricelist

    TextFileFields,
    TextFileRecord,
    TextFileData  : TStringList;

    procedure SetDirty(onoroff : Boolean = True);
    procedure SetSkinData;

  public
    { Public declarations }
    CurrentPricelist : GTDBizDoc;
    LoadingItem,
    ItemChanged,
    PricelistChanged : Boolean;

    procedure ClearPricelist;
    procedure SavePricelist;
	procedure LoadPricelist(const tFileName : String = GTD_CURRENT_PRICELIST);
	procedure LoadProductGroups;
	procedure LoadItemsInGroup(ForPageIndex : Integer);
    procedure LoadProductItem;
    function  UseProductImage(picfilename : String):Boolean;
    procedure SaveItemChanges;
  end;

var
  frmProductEdit: TfrmProductEdit;

implementation

{$R *.DFM}
uses Main, AddProductGroup, GenPricelists;

procedure TfrmProductEdit.btnCloseClick(Sender: TObject);
begin
    Close;
end;

procedure TfrmProductEdit.btnAddProductGroupClick(Sender: TObject);
var
    s : String;
    aNode : TTreeNode;
    l1grpNum, l2grpNum : Integer;
begin
    with frmAddProductGroup do
    begin
        // -- Set a default
        txtGroupName.Text := '';

        if not Assigned(tvwGroups.Selected) then
            rdoSubGroup.Enabled := False
        else
            rdoSubGroup.Enabled := True;

        ActiveControl := txtGroupName;

        if mrOk = ShowModal then
        begin
            if rdoMainGroup.Checked then
            begin

                // -- Create the element at the end in the outline control
                aNode := tvwGroups.Items.Add(tvwGroups.Selected,frmAddProductGroup.txtGroupName.Text);

                // -- Now add the product group
                s := '/' + GTD_PL_PRICELIST_TAG + '/' + GTD_PL_PRODUCTINFO_TAG + '/' + GTD_PL_PRODUCTGROUP_TAG;

                l1grpNum := CurrentPricelist.NodeCount(s) + 1;

                // -- Recalculate the cursor
                ProductGroupCursor := s + '[' + IntToStr(l1grpNum) + ']';

                // -- Create the nodes in the document
                CurrentPricelist.SetStringElement(ProductGroupCursor,GTD_PL_ELE_GROUP_NAME,txtGroupName.Text);

            end
            else begin

                // -- Create the item
                if tvwGroups.Selected.Level = 0 then
                begin
                    aNode := tvwGroups.Items.AddChild(tvwGroups.Selected,frmAddProductGroup.txtGroupName.Text);
                end
                else
                    aNode := tvwGroups.Items.AddChild(tvwGroups.Selected.Parent,frmAddProductGroup.txtGroupName.Text)
            end;

            SetDirty;
        end;
    end;

end;

procedure TfrmProductEdit.btnDeleteProductGroupClick(Sender: TObject);
begin
    if not Assigned(tvwGroups.Selected) then
    begin
        bsSkinMessage1.messagedlg('Please select a Product Group first',mtInformation,[mbOk],0);
        Exit;    
    end;

    // --Confirm deletion of the line
    if mrYes = bsSkinMessage1.messagedlg('Delete this Group (and all items) ?',mtConfirmation,[mbYes,mbno],0) then
    begin
        tvwGroups.Items.Delete(tvwGroups.Selected);
        SetDirty;
        if not CurrentPricelist.RemoveNode(ProductGroupCursor) then
            bsSkinMessage1.messagedlg('Unable to delete this Group [' + ProductGroupCursor + '/' + ProductItemCursor + ']',mtError,[mbOk],0);
	end;

end;

procedure TfrmProductEdit.btnBasicViewStyleClick(Sender: TObject);
begin
//    pdlList1.HidePictures := True;
    pdlList1.DisplayStyle := ProductBasicStyle;
end;

procedure TfrmProductEdit.btnLeftViewStyleClick(Sender: TObject);
begin
//    pdlList1.HidePictures := True;
    pdlList1.DisplayStyle := ProductLeftPictStyle;
end;

procedure TfrmProductEdit.btnAddItemClick(Sender: TObject);
var
    anItem      : TListItem;
    i           : Integer;
begin
    // -- New Item
    if Assigned(lsvItems.Selected) then
    begin
        anItem := lsvItems.Items.Insert(lsvItems.Selected.Index+1);
        i := lsvItems.Selected.Index + 2;
    end
    else begin
        anItem := lsvItems.Items.Add;
        i := lsvItems.Items.Count;
    end;

    anItem.Caption := 'New Item';
    txtProductName.Tag := 1;

    // -- Calculate the item cursor
    ProductItemCursor := GTD_PL_PRODUCTITEMS_NODE + '/' + GTD_PL_PRODUCTITEM_TAG + '[' + IntToStr(i) + ']';

    // -- Create the item in the pricelist
    if not CurrentPricelist.CreateNodesInDocument(ProductGroupCursor + ProductItemCursor) then
    begin
        bsSkinMessage1.MessageDlg('Item not created.',mtError,[mbOk],0);
    end
    else begin
    end;

    // -- Move the cursor to the right spot
    txtProductName.SetFocus;
    lsvItems.Selected := anItem;


end;

procedure TfrmProductEdit.btnDelItemClick(Sender: TObject);
begin
    // --Confirm deletion of the line
    if not Assigned(lsvItems.Selected) then
    begin
        bsSkinMessage1.messagedlg('Please select an Item first',mtInformation,[mbOk],0);
        Exit;
    end;

    // --Confirm deletion of the line
    if mrYes = bsSkinMessage1.messagedlg('Delete this Item?',mtConfirmation,[mbYes,mbno],0) then
    begin
        lsvItems.Items.Delete(lsvItems.Selected.Index);
        SetDirty;
        if not CurrentPricelist.RemoveNode(ProductGroupCursor + '/' + ProductItemCursor) then
            bsSkinMessage1.messagedlg('Unable to deleting this Item [' + ProductGroupCursor + '/' + ProductItemCursor + ']',mtError,[mbOk],0);
    end;

end;

procedure TfrmProductEdit.btnUpdateClick(Sender: TObject);
begin

    SavePricelist;

//    if Server.CommunityLink.Active then
//    begin
//
//        if Exchange.LoggedIn then
//        begin

//        end;

//        Server.NotifyTraderHasNewPricelist(-1);

//    end;

    // -- Now we have to distribute the new prices
    if not Assigned(frmGeneratePL) then
        Application.CreateForm(TfrmGeneratePL, frmGeneratePL);

//    frmSaveGenerate.Close;

end;

procedure TfrmProductEdit.SetDirty(onoroff : Boolean);
begin
    if onoroff then
        pnlDirty.Caption := 'Status: Modified'
    else
        pnlDirty.Caption := 'Status: ';

    btnUpdate.Visible := onoroff;        
end;

procedure TfrmProductEdit.ClearPricelist;
begin
    CurrentPricelist.Clear;
    lsvItems.Items.Clear;
    tvwGroups.Items.Clear;
    pdlList1.Clear;
end;

procedure TfrmProductEdit.SavePricelist;

    function BuildCompanyInformation:Boolean;
    var
        e : String;
    begin

        Result := True;
        e := '';

        if (frmMain.DocRegistry.GetGTL = '') then
        begin
            e := e + 'Missing PreisShare_ID' + #13;
        end;

        if (frmMain.DocRegistry.GetCompanyName = '') then
        begin
            e := e + 'Missing Organisation Name' + #13;
        end;

        if (frmMain.DocRegistry.GetCity = '') then
        begin
            e := e + 'Missing City Name' + #13;
        end;

        if (frmMain.DocRegistry.GetState = '') then
        begin
            e := e + 'Missing State/Province' + #13;
        end;

        if (frmMain.DocRegistry.GetCountryCode = '') then
        begin
            e := e + 'Missing Country Code' + #13;
        end;

        if (e <> '') then
        begin
            bsSkinMessage1.MessageDlg('Configuration information is not complete:' + #13 + #13 + e,mtError,[mbOk],0);
            Result := False;
        end;

        CurrentPricelist.SetStringElement(GTD_PL_VENDORINFO_NODE,GTD_PL_ELE_COMPANY_CODE,frmMain.DocRegistry.GetGTL);
        CurrentPricelist.SetStringElement(GTD_PL_VENDORINFO_NODE,GTD_PL_ELE_COMPANY_NAME,frmMain.DocRegistry.GetCompanyName);
        CurrentPricelist.SetStringElement(GTD_PL_VENDORINFO_NODE,GTD_PL_ELE_ADDRESS_LINE_1,frmMain.DocRegistry.GetAddress1);
        CurrentPricelist.SetStringElement(GTD_PL_VENDORINFO_NODE,GTD_PL_ELE_ADDRESS_LINE_2,frmMain.DocRegistry.GetAddress2);
        CurrentPricelist.SetStringElement(GTD_PL_VENDORINFO_NODE,GTD_PL_ELE_TOWN,frmMain.DocRegistry.GetCity);
        CurrentPricelist.SetStringElement(GTD_PL_VENDORINFO_NODE,GTD_PL_ELE_STATE_REGION,frmMain.DocRegistry.GetState);
        CurrentPricelist.SetStringElement(GTD_PL_VENDORINFO_NODE,GTD_PL_ELE_POSTALCODE,frmMain.DocRegistry.GetPostcode);
        CurrentPricelist.SetStringElement(GTD_PL_VENDORINFO_NODE,GTD_PL_ELE_COUNTRYCODE,frmMain.DocRegistry.GetCountryCode);

        {
        CurrentPricelist.SetStringElement(GTD_PL_VENDORINFO_NODE,GTD_PL_ELE_IPADDRESS,DocRegistry.);
        CurrentPricelist.SetStringElement(GTD_PL_VENDORINFO_NODE,GTD_PL_ELE_FAX,DocRegistry.);
        CurrentPricelist.SetStringElement(GTD_PL_VENDORINFO_NODE,GTD_PL_ELE_PROFILE,DocRegistry.);
        CurrentPricelist.SetStringElement(GTD_PL_VENDORINFO_NODE,GTD_PL_ELE_TELEPHONE,DocRegistry.);
        CurrentPricelist.SetStringElement(GTD_PL_VENDORINFO_NODE,GTD_PL_ELE_TELEPHONE2,DocRegistry.);
        CurrentPricelist.SetStringElement(GTD_PL_VENDORINFO_NODE,GTD_PL_ELE_EMAIL_ADDRESS,DocRegistry.);
        CurrentPricelist.SetStringElement(GTD_PL_VENDORINFO_NODE,GTD_PL_ELE_OTHER_INFO,DocRegistry.);
        }

    end;


var
    OldPricelist : GTDBizDoc;
    sl    : TStringList;
    aMemo 	: TMemoField;
begin
    sl          := TStringList.Create;
    OldPricelist := GTDBizDoc.Create(Self);

    try
		// -- Load what we had before
		if FileExists(PricelistFileName) then
			oldPricelist.LoadFromFile(PricelistFileName {'original.pricelist'})
		else
			oldPricelist.Clear;

        // -- Do we have a company information section and if not then add it
        if (CurrentPricelist.GetStringElement(GTD_PL_VENDORINFO_NODE,GTD_PL_ELE_COMPANY_CODE) = '') or
           (CurrentPricelist.GetStringElement(GTD_PL_VENDORINFO_NODE,GTD_PL_ELE_COMPANY_NAME) = '') then
        begin
            BuildCompanyInformation;
        end;

        // -- Save our current work to disk first
//        frmSaveGenerate.SetRetailStatus('Saving');
        CurrentPricelist.XML.SaveToFile(ExtractFilePath(Application.Exename) + '\' + GTD_CURRENT_PRICELIST);

		SetDirty(False);

        // -- Now build the patch file
		CurrentPricelist.BuildPatch(oldPricelist.xml,sl,dtUnified);

		if sl.Count <> 0 then
		begin

			// -- Add the patch tags to the start and end
			sl.Insert(0,'<' + GTD_PL_PATCH_TAG + '>');
			sl.Add('</' + GTD_PL_PATCH_TAG + '>');

		  //	with tblAuditTrail do
		  //	begin

				// -- Open the table if it is closed
		  //		if not Active then
		  //		begin
		  //			DatabaseName := GTD_ALIAS;
		  //			Active := True;
		  //		end;

				// -- Add everything to create the record
		  //		Append;
		  //		FieldByName('Trader_ID').AsInteger := 0;
		  //		FieldByName('Local_Timestamp').AsFloat := Now;
		  //		FieldByName('Audit_Code').AsString := GTD_PRICELIST_PATCH_TYPE;
		  //		FieldByName('Audit_Description').AsString := 'Diff Patch';
		  //		FieldByName('Document_ID').AsInteger := -100;
		  //		aMemo := TMemoField(FieldByName('Audit_Log'));
		  //		aMemo.Assign(sl);
		  //		Post;
		  //	end;

		end;

		// -- Refresh this query
		//qryHistory.Active := False;
		//qryHistory.Active := True;

	finally
		OldPricelist.Free;
		sl.Free;
	end;
    //frmSaveGenerate.SetRetailStatus('Done');
end;

procedure TfrmProductEdit.LoadPricelist(const tFileName : String);
var
    f : String;
begin
    f := tFileName;

    // -- Ensure we use a file from the current directory
    if tFileName = GTD_CURRENT_PRICELIST then
        f := ExtractFilePath(Application.ExeName) + GTD_CURRENT_PRICELIST
    else
        f := tFileName;

    // -- Display the name
    pnlFileName.Caption := f;

    // -- Load the file from the current directory
    if FileExists(f) then
    begin
        // -- Load the Pricelist from disk
        CurrentPricelist.LoadFromFile(f);

        LoadProductGroups;

        // -- Automatically select the first group
        if Assigned(tvwGroups.TopItem) then
            tvwGroups.Selected := tvwGroups.TopItem;

    end
    else begin

        // -- This line was taken out because it makes a GPF at startup
//        bsSkinMessage1.MessageDlg('A pricelist file does not exist. A new one will be created now.',mtInformation,[mbOk],0);

        // -- This section is needed to due to some faults in the api
        CurrentPricelist.Clear;
        CurrentPricelist.XML.Add('<PriceList>');
        CurrentPricelist.XML.Add('  <Vendor Information>');
        CurrentPricelist.XML.Add('  </Vendor Information>');
        CurrentPricelist.XML.Add('  <Product Information>');
        CurrentPricelist.XML.Add('  </Product Information>');
        CurrentPricelist.XML.Add('</PriceList>');

//        CurrentPricelist.CreateNodesInDocument(GTD_PL_VENDORINFO_NODE);
//        CurrentPricelist.CreateNodesInDocument(GTD_PL_PRODUCTINFO_NODE);
    end;

    ItemChanged := False;
    PricelistChanged := False;

    SetDirty(False);

end;

procedure TfrmProductEdit.LoadProductGroups;
var
    ng,gc : Integer;
    gn, myGroupCursor,s : String;
    aPanel : TPanel;
begin

    // -- Calculate a cursor for the product group
    gc := 0;
    Level2Group := 0;
    tvwGroups.Items.Clear;

    // -- Determine how many levels
    s := GTD_PL_PRODUCTINFO_NODE + '/' + GTD_PL_DISPLAYINFO_NODE;

    CatalogLevels := CurrentPricelist.GetIntegerElement(s,GTD_PL_LEVELCOUNT,1);

    if (ProductGroupNode.LoadFromDocument(CurrentPricelist,'/' + GTD_PL_PRODUCTINFO_TAG,false)) then
    begin

        while ProductGroupNode.FindTag(GTD_PL_PRODUCTGROUP_TAG) do
        begin

            Inc(gc);
            gn := ProductGroupNode.ReadStringField(GTD_PL_ELE_GROUP_NAME);

            tvwGroups.Items.Add(nil,gn);

            //cblProductGroups.Add(IntToStr(gc),gn);

        end;
	end;

//    ProductGroupNode.Destroy;
end;

procedure TfrmProductEdit.LoadItemsInGroup(ForPageIndex : Integer);
var
	aNode       : GTDNode;
	l,ia        : String;
	CellData    : TProductCellData;
	xc          : Integer;
	anItem      : TListItem;
begin
	if not Assigned(tvwGroups.Selected) then
		Exit;

	// -- Determine the product item cursor
	if tvwGroups.Selected.Level = 0 then
		ProductGroupCursor := '/' + GTD_PL_PRICELIST_TAG + '/' + GTD_PL_PRODUCTINFO_TAG + '/' + GTD_PL_PRODUCTGROUP_TAG + '[' + IntToStr(Level1Group) + ']'
	else if tvwGroups.Selected.Level = 1 then
	   ProductGroupCursor := ProductGroupCursor + GTD_PL_PRODUCTGROUPL2_NODE + '[' + IntToStr(Level2Group) + ']';

	// -- Clear everything that holds items
	pdlList1.Clear;
	ProductGroupNode.Clear;
	lsvItems.Items.Clear;

	// -- Load up the product group
	if not ProductGroupNode.LoadFromDocument(CurrentPricelist,ProductGroupCursor,True) then
	begin
		 Exit;
	end;

	if ForPageIndex = 0 then
	begin
		// -- Display all items
		ProductGroupNode.GotoStart;
		pdlList1.LoadProductGroup(ProductGroupNode);
	end
	else begin
		aNode := GTDNode.Create;

		try

			Screen.Cursor := crHourglass;

            lsvItems.Items.BeginUpdate;

			// -- Load our product lister
			ProductGroupNode.GotoStart;

			for xc := 1 to CurrentPricelist.NodeCount(ProductGroupCursor + GTD_PL_PRODUCTITEMS_NODE + GTD_PL_PRODUCTITEM_NODE) do
			begin

				ia := ProductGroupCursor + GTD_PL_PRODUCTITEMS_NODE + GTD_PL_PRODUCTITEM_NODE + '[' + IntToStr(xc) + ']';

				L := CurrentPricelist.GetStringElement(ia,GTD_PL_ELE_PRODUCT_NAME);

				anItem := lsvItems.Items.Add;
				anItem.Caption := L;
			end;

		finally
            lsvItems.Items.EndUpdate;

			Screen.Cursor := crDefault;
			aNode.Destroy;
		end;
	end;
end;

procedure TfrmProductEdit.LoadProductItem;
var
    i : String;
begin

    LoadingItem := True;

    if (ProductNode.LoadFromDocument(CurrentPricelist,ProductGroupCursor + ProductItemCursor,false)) then
    begin

         // -- Load all the individual fields out as required
         txtProductCode.Text  := ProductNode.ReadStringField(GTD_PL_ELE_PRODUCT_CODE);
         txtProductName.Text  := ProductNode.ReadStringField(GTD_PL_ELE_PRODUCT_NAME);
         txtProductDesc.Text  := ProductNode.ReadStringField(GTD_PL_ELE_PRODUCT_DESC);
         txtProductList.Text  := ProductNode.ReadStringField(GTD_PL_ELE_PRODUCT_LIST);
         txtProductSell.Text  := ProductNode.ReadStringField(GTD_PL_ELE_PRODUCT_ACTUAL);
         cbxUOM.Text          := ProductNode.ReadStringField(GTD_PL_ELE_PRODUCT_UNIT);
         cbxBrand.Text        := ProductNode.ReadStringField(GTD_PL_ELE_PRODUCT_BRAND);
         cbxTaxRate.Text      := ProductNode.ReadStringField(GTD_PL_ELE_PRODUCT_TAXR);
         cbxOnSpecial.Checked := ProductNode.ReadBooleanField(GTD_PL_ELE_ONSPECIAL,False);
         cbxAvailability.Text := ProductNode.ReadStringField(GTD_PL_ELE_PRODUCT_AVAIL_STATUS);

         // -- Change the availability bar
		 if cbxAvailability.Text = GTD_PL_AVAIL_FLAG_UNKNOWN then
			stbAvailability.Value := 0
		 else if cbxAvailability.Text = GTD_PL_AVAIL_FLAG_OUTOFSTOCK then
			stbAvailability.Value := 1
		 else if cbxAvailability.Text = GTD_PL_AVAIL_FLAG_LOW then
			stbAvailability.Value := 2
		 else if cbxAvailability.Text = GTD_PL_AVAIL_FLAG_MEDIUM then
			stbAvailability.Value := 3
		 else if cbxAvailability.Text = GTD_PL_AVAIL_FLAG_HIGH then
			stbAvailability.Value := 4;

		// -- Load stuff for the picture
		txtPicture.Text := ProductNode.ReadStringField(GTD_PL_ELE_PRODUCT_IMAGE);
		if (txtPicture.Text = '') then
		   imgProduct.Picture.Graphic := nil
		else begin
			i := frmMain.DocRegistry.GetOurImageDir + PathSlash + txtPicture.Text;

            if frmMain.DocRegistry.LoadImage(txtPicture.Text,imgProduct) then
	    		// -- Display the size
    			with TJPEGImage(imgProduct.Picture.Graphic) do
		    	begin
			    	lblImageSize.Caption := IntToStr(Width)+'x'+IntToStr(Height);
    			end
            else
                lblImageSize.Caption := '';

		end;

	end
	else begin
		 txtProductCode.Text  := '';
		 txtProductName.Text  := '';
		 txtProductDesc.Text  := '';
		 txtProductList.Text  := '';
         txtProductSell.Text  := '';
         cbxUOM.Text          := '';
         cbxBrand.Text        := '';
         cbxTaxRate.Text      := '';
         cbxOnSpecial.Checked := False;
         cbxAvailability.Text := '';

         if Assigned(imgProduct.Picture) then
         begin
//            imgProduct.Picture.Destroy;
            imgProduct.Picture.Graphic := nil;
         end;
    end;

    // -- Now reset the editing flag for all those
    txtProductCode.Tag  := 0;
    txtProductName.Tag  := 0;
    txtProductDesc.Tag  := 0;
    txtProductList.Tag  := 0;
    txtProductSell.Tag  := 0;
    txtPicture.Tag      := 0;
    cbxUOM.Tag          := 0;
    cbxBrand.Tag        := 0;
    cbxTaxRate.Tag      := 0;
    cbxOnSpecial.Checked := False;
    cbxAvailability.Tag := 0;

    LoadingItem := False;
    ItemChanged := False;

end;

function TfrmProductEdit.UseProductImage(picfilename : String):Boolean;
const
	full_tw = 640;
	thumb_tw = 150;
var
	s : String;
	ar : Integer;
begin
	// -- Save the image
	s := frmMain.DocRegistry.AddProductImage(picfilename, full_tw, thumb_tw);
	if s = '' then
	begin
		// -- Now update the document
		txtPicture.Text := ExtractFileName(picfilename);

		// -- Display the picture
		if frmMain.DocRegistry.LoadImage(ExtractFileName(picfilename),imgProduct) then
        begin

            with TJPEGImage(imgProduct.Picture.Graphic) do
            begin
                lblImageSize.Caption := IntToStr(Width)+'x'+IntToStr(Height);

                // -- Determine the aspect ratio
                ar := (Width * 100) div Height;


                if Width > full_tw then
                begin
                    // -- Shrink it
                    Width := full_tw;
                    Height := (full_tw * 100) div ar;
                    Compress;

    //				SaveToFile('d:\x.jpg');
                end;

            end;

            // -- Mark this field as having changed
            FieldChange(txtPicture);
        end;

	 end
	 else
		bsSkinMessage1.MessageDlg(s,mtError,[mbOk],0);

end;

procedure TfrmProductEdit.SaveItemChanges;
var
	ic : String;
begin
	ic := ProductGroupCursor + ProductItemCursor;

    // -- Items go in backwards
	if cbxUOM.Tag <> 0 then
		 CurrentPricelist.SetStringElement(ic,GTD_PL_ELE_PRODUCT_UNIT,cbxUOM.Text);

	if cbxBrand.Tag <> 0 then
		 CurrentPricelist.SetStringElement(ic,GTD_PL_ELE_PRODUCT_BRAND,cbxBrand.Text);

	if cbxTaxRate.Tag <> 0 then
		 CurrentPricelist.SetStringElement(ic,GTD_PL_ELE_PRODUCT_TAXR,cbxTaxRate.Text);

	if cbxOnSpecial.Tag <> 0 then
		 CurrentPricelist.SetBooleanElement(ic,GTD_PL_ELE_ONSPECIAL,cbxOnSpecial.Checked);

	if cbxAvailability.Tag <> 0 then
		 CurrentPricelist.SetStringElement(ic,GTD_PL_ELE_PRODUCT_AVAIL_STATUS,cbxAvailability.Text);

    if txtPicture.Tag <> 0 then
		 CurrentPricelist.SetStringElement(ic,GTD_PL_ELE_PRODUCT_PICTURE,txtPicture.Text);

	if txtProductSell.Tag <> 0 then
		 CurrentPricelist.SetCurrencyElement(ic,GTD_PL_ELE_PRODUCT_ACTUAL,StringToFloat(txtProductSell.Text));
	if txtProductList.Tag <> 0 then
		 CurrentPricelist.SetCurrencyElement(ic,GTD_PL_ELE_PRODUCT_LIST,StringToFloat(txtProductList.Text));

	if txtProductDesc.Tag <> 0 then
		 CurrentPricelist.SetStringElement(ic,GTD_PL_ELE_PRODUCT_DESC,txtProductDesc.Text);

	if txtProductName.Tag <> 0 then
	begin
		CurrentPricelist.SetStringElement(ic,GTD_PL_ELE_PRODUCT_NAME,txtProductName.Text);
		if Assigned(lsvItems.Selected) then
			lsvItems.Selected.Caption := txtProductName.Text;
	end;

	if txtProductCode.Tag <> 0 then
	begin
		CurrentPricelist.SetStringElement(ic,GTD_PL_ELE_PRODUCT_CODE,txtProductCode.Text);
    end;

    if txtPicture.Tag <> 0 then
        CurrentPricelist.SetStringElement(ic,GTD_PL_ELE_PRODUCT_IMAGE,txtPicture.Text);

	txtProductCode.Tag := 0;
	txtProductName.Tag := 0;
	txtProductDesc.Tag := 0;
	txtProductList.Tag := 0;
	txtProductSell.Tag := 0;
	txtPicture.Tag     := 0;

	PricelistChanged := True;

end;

procedure TfrmProductEdit.FieldChange(Sender: TObject);
var
   mf : TControl;
begin
    mf := TControl(Sender);
    mf.Tag := 1;

    if not LoadingItem then
    begin
        if lsvItems.Items.Count = 0 then
        begin
            btnAddItemClick(Sender);
        end;

        SaveItemChanges;
        SetDirty;
    end;
end;

procedure TfrmProductEdit.FormCreate(Sender: TObject);
begin
	// -- This business doc holds the catalog
	CurrentPricelist  := GTDBizDoc.Create(Self);

	// -- This node holds the selected product group
	ProductGroupNode := GTDNode.Create;

	// -- This node holds the selected item
	ProductNode      := GTDNode.Create;

    LoadPricelist;

    pdlList1.HidePictures := False;

    SetSkinData;

end;

procedure TfrmProductEdit.lsvItemsChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
begin
    // -- If the selected item changes, reload the item
    if (Change = ctState) and (Item = lsvItems.Selected) then
    begin

        if ItemChanged then
        begin
            SaveItemChanges;
        end;

        // -- Calculate the cursor to the item
        ProductItemCursor := GTD_PL_PRODUCTITEMS_NODE + '/' + GTD_PL_PRODUCTITEM_TAG + '[' + IntToStr(lsvItems.Selected.Index + 1) + ']';

        // -- Display our cursor for debug
        // bsSkinStatusPanel1.Caption := ProductGroupCursor + ProductItemCursor;

        LoadProductItem;

     end;

end;

procedure TfrmProductEdit.tvwGroupsChange(Sender: TObject;
  Node: TTreeNode);
begin
	 if (Node = tvwGroups.Selected) then
	 begin
		  // Level1Group,Level2Group
		//  Label1.Caption := Node.Text;
		//  Label2.Caption := Node.Text;

		  // -- Read out the Location
		  Level1Group := Node.AbsoluteIndex + 1;
		  Level2Group := 1;

		  // -- Recalculate the cursor
		  ProductGroupCursor := '/' + GTD_PL_PRICELIST_TAG + '/' + GTD_PL_PRODUCTINFO_TAG + '/' + GTD_PL_PRODUCTGROUP_TAG + '[' + IntToStr(Level1Group) + ']';
		  if CatalogLevels = 2 then
			 ProductGroupCursor := ProductGroupCursor + GTD_PL_PRODUCTGROUPL2_NODE + '[' + IntToStr(Level2Group) + ']';

		  // bsSkinStatusPanel1.Caption := ProductGroupCursor;
			// -- Load the Items in the Group
		  LoadItemsInGroup(0);

	 end;

end;

procedure TfrmProductEdit.nbkEditingChanging(Sender: TObject;
  var AllowChange: Boolean);
begin
	 if nbkEditing.ActivePage = pgGroups then
	 begin
		  LoadItemsInGroup(1);
	 end
	 else if Assigned(tvwGroups.Selected) then
     begin
		  LoadItemsInGroup(0);
          if lsvItems.Items.Count > 0 then
          begin
             // -- Select the first item
             lsvItems.Selected := lsvItems.Items[0];
          end;
     end;

end;

procedure TfrmProductEdit.btnEditTheItemsClick(Sender: TObject);
begin
    nbkEditing.ActivePage := pgItems;
	LoadItemsInGroup(1);

    // -- Select the first item if there is one
    if lsvItems.Items.Count > 0 then
    begin
        lsvItems.Selected := lsvItems.Items[0];
    end;

end;

procedure TfrmProductEdit.FormShow(Sender: TObject);
begin
    nbkEditing.ActivePage := pgGroups;
end;

procedure TfrmProductEdit.bsSkinSpeedButton1Click(Sender: TObject);
begin
    if bsSkinOpenPictureDialog1.Execute then
	begin
	    UseProductImage(bsSkinOpenPictureDialog1.FileName);
    end;
end;

procedure TfrmProductEdit.SetSkinData;
var
    sd : TbsSkinData;
begin
    sd := frmMain.bsSkinData1;
    bsBusinessSkinForm1.SkinData := sd;
    nbkEditing.SkinData := sd;
    bsSkinPanel1.SkinData := sd;
    tvwGroups.SkinData := sd;
    ssbGroups.SkinData := sd;
    bsSkinToolBar2.SkinData := sd;
    bsSkinToolBar4.SkinData := sd;
    btnEditTheItems.SkinData := sd;
    pnlFileName.SkinData := sd;
    bsSkinToolBar1.SkinData := sd;
    lsvItems.SkinData := sd;
    bsSkinScrollBar1.SkinData := sd;

    bsSkinPageControl1.SkinData := sd;
    lblPicture.SkinData := sd;
    bsSkinSpeedButton1.SkinData := sd;
    lblAvailability.SkinData := sd;
    cbxAvailability.SkinData := sd;
    stbAvailability.SkinData := sd;
    lblProductCode.SkinData := sd;
    txtProductCode.SkinData := sd;
    lblListPrice.SkinData := sd;
    txtProductList.SkinData := sd;
    lblSellPrice.SkinData := sd;
    txtProductSell.SkinData := sd;
    lblName.SkinData := sd;
    txtProductName.SkinData := sd;
    lblDescription.SkinData := sd;
    txtProductDesc.SkinData := sd;
    lblUnitOfMeasure.SkinData := sd;
    cbxUOM.SkinData := sd;
    lblBrand.SkinData := sd;
    cbxBrand.SkinData := sd;
    lblTaxRate.SkinData := sd;
    cbxTaxRate.SkinData := sd;
    cbxOnSpecial.SkinData := sd;

    bsSkinMessage1.SkinData := sd;
    bsSkinMessage1.CtrlSkinData := sd;
    
    ssbItems.SkinData := sd;

    bsSkinOpenPictureDialog1.SkinData := sd;
    bsSkinOpenPictureDialog1.CtrlSkinData := sd;
    
    pnlDirty.SkinData := sd;

    btnUpdate.SkinData := sd;
    btnClose.SkinData := sd;

    lblFeatures.SkinData := sd;
    lsvFeatures.SkinData := sd;
    lblStyles.SkinData := sd;
    lsvStyles.SkinData := sd;
    lblOptions.SkinData := sd;
    lsvOptions.SkinData := sd;

end;

end.
