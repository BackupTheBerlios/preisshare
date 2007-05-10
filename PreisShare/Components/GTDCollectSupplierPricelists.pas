unit GTDCollectSupplierPricelists;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, bsSkinCtrls, StdCtrls, bsSkinBoxCtrls, HttpProt,
  bsMessages,bsSkinData, bsSkinMenus, Menus, bsDialogs, Mask, DB, DBTables,
  GTDBizDocs,GTDTraderSelectPanel, PricelistExport, GTDPricelists, ExtCtrls, TeeProcs, TeEngine, Chart,
  jpeg, ImgList, HTTPApp;

const
  CM_DOALLFEEDS = WM_APP + 50;
  CM_DONEXTFEED = WM_APP + 51;
  CM_SETUPSAMPLEFEEDS = WM_APP + 52;

  type TCollectPricelistFrame = class(TFrame)
    HttpCli1: THttpCli;
    pnlBackground: TbsSkinPanel;
    btnAdd: TbsSkinSpeedButton;
    otlFeeds: TbsSkinTreeView;
    Memo1: TbsSkinMemo2;
    bsSkinPopupMenu1: TbsSkinPopupMenu;
    AddURL1: TMenuItem;
    dlgURL: TbsSkinInputDialog;
    pnlFeedSettings: TbsSkinGroupBox;
    btnSave: TbsSkinButton;
    lblURL: TbsSkinLabel;
    txtURL: TbsSkinEdit;
    qrySources: TQuery;
    lstColumnMap: TbsSkinListView;
    bsSkinPopupMenu2: TbsSkinPopupMenu;
    grpCollection: TbsSkinGroupBox;
    Image1: TImage;
    bsSkinTextLabel1: TbsSkinTextLabel;
    btnProcess: TbsSkinButton;
    lblProgress: TbsSkinStdLabel;
    barProgress: TbsSkinGauge;
    ImageList1: TImageList;
    lblListCount: TbsSkinStdLabel;
    btnGet: TbsSkinSpeedButton;
    btnSampleFeeds: TbsSkinSpeedButton;
    lblSampleFeeds: TbsSkinTextLabel;
    lblSupplierDiscount: TbsSkinLabel;
    mmoData: TbsSkinMemo2;
    txtSupplierDiscount: TbsSkinNumericEdit;
    dlgFields: TbsSkinSelectValueDialog;
    btnSaveCfg: TbsSkinSpeedButton;
    procedure HttpCli1DocData(Sender: TObject; Buffer: Pointer;
      Len: Integer);
    procedure btnAddClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure otlFeedsClick(Sender: TObject);
    procedure HttpCli1DocEnd(Sender: TObject);
    procedure lstColumnMapDblClick(Sender: TObject);
    procedure btnSaveCfgClick(Sender: TObject);
    procedure HttpCli1SocketError(Sender: TObject);
    procedure btnGetClick(Sender: TObject);
    procedure btnSampleFeedsClick(Sender: TObject);
  private
    { Private declarations }
    fDocRegistry : GTDDocumentRegistry;
    fSkinData   : TbsSkinData;
    fTraderDetails : TpnlTraderGet;

    fProcessAll : Boolean;

    mySPD : TGTDPricelistExportFrame;
    myPL : GTDPricelist;

    LineData : String;

    dayNode,WeekNode,MonthNode,FileNode : TTreeNode;

    function BuildCollectionList:Boolean;

    function LoadTrader(Trader_Id : Integer):Integer;

    procedure Busy(YesOrNo : Boolean);

  public
    { Public declarations }

    procedure SetSkinData(Value: TbsSkinData);

    function Run_All:Boolean;
    function Run_Selected:Boolean;
    function Prepare:Boolean;

    procedure TraderSelectedClick(Sender: TObject);

    procedure AddDailyCSVPricelistFeed(CompanyName,URL,ColumnMappings : String);
    function LoadPricelistFile(FileName : String):Boolean;

    procedure ShowPLMessage(msgType, msgDescription : String);

    procedure ProcessStartFeed(var aMsg : TMsg); message CM_DOALLFEEDS;
    procedure ProcessNextFeed(var aMsg : TMsg); message CM_DONEXTFEED;
    procedure SetupSampleFeeds(var aMsg : TMsg); message CM_SETUPSAMPLEFEEDS;

  published

    property SkinData   : TbsSkinData read fSkinData write SetSkinData;
    property DocRegistry : GTDDocumentRegistry read fDocRegistry write fDocRegistry;
  end;

implementation

{$R *.dfm}
uses FastStrings, FastStringFuncs;

const
  PL_COLLECT_FORMAT       = 'Collection_Format';
  PL_COLLECT_CSV          = 'CSV';
  PL_COLLECT_XLS          = 'XLS';
  PL_COLLECT_XML          = 'XML';
  PL_OUTPUT_STD_COLUMNS = GTD_PL_ELE_PRODUCT_PLU + ';' + GTD_PL_ELE_PRODUCT_NAME + ';' + GTD_PL_ELE_PRODUCT_ACTUAL;
  PL_PRICELIST_FILENAME = 'PriceList';

  PL_COLLECT_NODE         = '/Pricelist Collection';

  PL_COLLECT_FREQUENCY    = 'Update_Frequency';
  PL_COLLECT_FREQ_INSTANT = 'When Changed';
  PL_COLLECT_FREQ_DAILY   = 'Daily';
  PL_COLLECT_FREQ_WEEKLY  = 'Weekly';
  PL_COLLECT_FREQ_FORTNIGHT = 'Fortnightly';
  PL_COLLECT_LAST_RUN     = 'Last_Run';
  PL_COLLECT_LAST_SENT    = 'Last_Sent';
  PL_COLLECT_MECHANISM    = 'Collection_Mechanism';
  PL_COLLECT_MECH_FTP     = 'FTP';
  PL_COLLECT_MECH_SMTP    = 'SMTP';
  PL_COLLECT_MECH_HTTP    = 'HTTP';
  PL_COLLECT_HTTP_LOCATION= 'Location';

  PL_FTP_COLLECT_HOST     = 'FTP_Host';
  PL_FTP_COLLECT_USER     = 'FTP_User';
  PL_FTP_COLLECT_PASSWD   = 'FTP_Password';
  PL_FTP_COLLECT_DIR      = 'FTP_Directory';

  // -- Display states, these correspond to the states in the icon
  PL_CLNT_STATE_READY   = 0;
  PL_CLNT_STATE_BUSY    = 1;
  PL_CLNT_STATE_SEND    = 2;
  PL_CLNT_STATE_ERROR   = 3;
  PL_CLNT_STATE_DONE    = 4;

function ReadNextCSVField(var L : String; cfDelim : Char):String;
var
  xpos,slen : Integer;
  inQuote : Boolean;
  r : String;
begin
  Result := '';
  inQuote := L[1] = '"';
  slen := Length(L);

  // -- Look for the next delimiter
  xpos := FastPos(L,cfDelim,Length(l),1,1);

  if (xpos <> 0) then
  begin
    // -- Chop it
    Result := LeftStr(L,xpos-1);

    L := RightStr(L,Length(L)-Length(Result)-1);

  end
  else begin
    Result := L;
    L := '';
  end;

  // -- Remove double quotes
  if (Length(Result)>0) then
  begin
    if (Result[1]='"') and (Result[Length(Result)]='"') then
    Result := CopyStr(Result,2,Length(Result)-2);
  end;

  // -- Finally trim it
  Result := Trim(Result);
end;

procedure TCollectPricelistFrame.HttpCli1DocData(Sender: TObject;
  Buffer: Pointer; Len: Integer);
var
  s : String;
  xc : Integer;
  p : PChar;
begin
  p := PChar(Buffer);
  for xc := 1 to Len do
  begin
    s := s + p^;
    Inc(p);
  end;

  LineData := LineData + s;

  if mmoData.Visible then
    mmoData.Lines.Append(s);
end;

procedure TCollectPricelistFrame.SetSkinData(Value: TbsSkinData);
begin
  pnlBackGround.SkinData := Value;
  btnAdd.SkinData := Value;
  btnProcess.SkinData := Value;
  otlFeeds.SkinData := Value;
  Memo1.SkinData := Value;
  lblProgress.SkinData := Value;
  barProgress.SkinData := Value;
  dlgURL.SkinData := Value;
  dlgURL.CtrlSkinData := Value;
  pnlFeedSettings.SkinData := Value;

  lstColumnMap.SkinData := Value;
  txtURL.SkinData := Value;
  lblURL.SkinData := Value;
  grpCollection.SkinData := Value;

  btnSampleFeeds.SkinData := Value;
  lblSampleFeeds.SkinData := Value;

  txtSupplierDiscount.SkinData := Value;
  lblSupplierDiscount.SkinData := Value;

  btnSave.SkinData := Value;
  btnGet.SkinData := Value;
  btnSaveCfg.SkinData := Value;

  dlgFields.CtrlSkinData := Value;
  dlgFields.SkinData := Value;

  if Assigned(mySPD) then
    mySPD.SkinData := Value;

  fSkinData := Value;

  grpCollection.Top := pnlFeedSettings.Top;
  grpCollection.Left := pnlFeedSettings.Left;

end;

procedure TCollectPricelistFrame.btnAddClick(Sender: TObject);
begin

  if not Assigned(otlFeeds.Selected)then
  begin
    otlFeeds.Selected := dayNode;
  end;

  if otlFeeds.Selected.Level = 1 then
    otlFeeds.Selected := otlFeeds.Selected.Parent;

  if not Assigned(fTraderDetails) then
  begin
    fTraderDetails := TpnlTraderGet.Create(Self);
    with fTraderDetails do
    begin
      top := pnlFeedSettings.Top;
      Left := pnlFeedSettings.Left;
      Height := 290;
      Parent := Self;
      Visible := False;
      CreateButtonText := 'Next >>';
      SelectButtonText := 'Next >>';
      OnTraderSelected := TraderSelectedClick;
    end;
    fTraderDetails.SkinData := SkinData;
    fTraderDetails.DocRegistry := fDocRegistry;
    fTraderDetails.Visible := True;
    fTraderDetails.SelectSupplierOrAddNew(1);
  end;

  btnSave.Visible := True;
  btnProcess.Visible := False;

  grpCollection.Visible := False;
  pnlFeedSettings.Visible := True;

  Memo1.Visible := False;
end;

function TCollectPricelistFrame.BuildCollectionList:Boolean;
var
    newItem : TTreeNode;
    ListCount,tid : Integer;
    v : String;
    dt : TDateTime;
begin
  // -- Select all traders from the trader table
  otlFeeds.Items.Clear;
  dayNode := otlFeeds.Items.Add(nil,'Daily');
  dayNode.ImageIndex := 1;
  WeekNode := otlFeeds.Items.Add(nil,'Weekly');
  WeekNode.ImageIndex := 2;
  MonthNode := otlFeeds.Items.Add(nil,'Monthly');
  MonthNode.ImageIndex := 3;
  FileNode := otlFeeds.Items.Add(nil,'File');
  MonthNode.ImageIndex := 4;

  // -- Select all traders from the trader table
  with qrySources do
  begin

    Active := False;

    DatabaseName := GTD_ALIAS;

    SQL.Clear;
    SQL.Add('select * from Trader');
    SQL.Add('where ');
    SQL.Add(' ((' + GTD_DB_COL_STATUS_CODE + ' = "' + GTD_TRADER_STATUS_ACTIVE + '") or');
    SQL.Add('  (' + GTD_DB_COL_STATUS_CODE + ' = "' + GTD_TRADER_STATUS_PROSPECT + '")) and ');
    SQL.Add('  (' + GTD_DB_COL_RELATIONSHIP + ' = "' + GTD_TRADER_RLTNSHP_SUPPLIER + '")');

    Active := True;

    // -- Cycle through each of the records
    First;
    ListCount :=0;
    while not Eof do
    begin

      tid := FieldByName(GTD_DB_COL_TRADER_ID).AsInteger;

      // -- Open this Trader
      if fDocRegistry.OpenForTraderNumber(tid) then
      begin

        // -- Determine the frequency
        v := '';
        fDocRegistry.GetTraderSettingString(PL_COLLECT_NODE,PL_COLLECT_FREQUENCY,v);
        if v = PL_COLLECT_FREQ_FORTNIGHT then
          newItem := otlFeeds.Items.AddChildObject(MonthNode,fDocRegistry.Trader_Name,TObject(tid))
        else if v = PL_COLLECT_FREQ_WEEKLY then
          newItem := otlFeeds.Items.AddChildObject(WeekNode,fDocRegistry.Trader_Name,TObject(tid))
        else if v = PL_COLLECT_FREQ_DAILY then
          newItem := otlFeeds.Items.AddChildObject(DayNode,fDocRegistry.Trader_Name,TObject(tid))
        else begin
          // -- We don't do anything
          Next;
          continue;
        end;

        Inc(ListCount);

        // -- Add the company to the list
        newItem.StateIndex := 0;

        // -- Last run
        v := '';
        fDocRegistry.GetTraderSettingString(PL_COLLECT_NODE,PL_COLLECT_LAST_RUN,v);
        if v = '' then
        begin
            dt := fDocRegistry.GetLatestPriceListDateTime;
            if (dt = 0) then
                v := 'Never'
            else
                v := DateTimeToStr(dt);
        end;
//        newItem.SubItems.Add(v);

        // -- Last sent
        v := '';
        fDocRegistry.GetTraderSettingString(PL_COLLECT_NODE,PL_COLLECT_LAST_SENT,v);

//        newItem.SubItems.Add(v);
//        newItem.SubItems.Add(FieldByName(GTD_DB_COL_TRADER_ID).AsString);

      end;

      Next;
    end;
  end;

  // -- Update the label
  lblListCount.Caption := IntToStr(ListCount) + ' Supplier Pricelist Feeds';

  // -- If no feeds then provide sample ones
  if ListCount = 0 then
  begin
    btnSampleFeeds.Visible := True;
    lblSampleFeeds.Visible := True;
  end;

end;

function TCollectPricelistFrame.Run_Selected:Boolean;
begin
  LineData := '';

  HttpCli1.Url := txtURL.Text;
  HttpCli1.GetAsync;

  Busy(True);
end;

function TCollectPricelistFrame.Run_All:Boolean;
var
  xc : Integer;
begin
  fProcessAll := True;
  otlFeeds.Selected := otlFeeds.Items[0];

  Run_Selected;
end;

function TCollectPricelistFrame.Prepare:Boolean;
begin
  if not Assigned(mySPD) then
  begin
    mySPD := TGTDPricelistExportFrame.Create(Self);
    with mySPD do
    begin
      Parent := Self;
      Left := otlFeeds.Left;
      Top := otlFeeds.Top;
      DocRegistry := fDocRegistry;
    end;
  end;

  // -- Set the size coordinates properly
  mySPD.Visible := False;
  mySPD.Height := Self.Height - (mySPD.Top);
  mySPD.Width := Self.Width - (2 * mySPD.Left);
  mySPD.Init;

  if not Assigned(myPL) then
  begin
    myPL := GTDPricelist.Create(Self);
    myPL.OnReportMessage := ShowPLMessage;
  end;

  BuildCollectionList;
end;

procedure TCollectPricelistFrame.TraderSelectedClick(Sender: TObject);
var
  newNode : TTreeNode;
begin
  // -- Finished with trader details, advance to settings
  fTraderDetails.Visible := False;
  pnlFeedSettings.Visible := True;

  // -- Now add the name into the selected schedule
  newNode := otlFeeds.Items.AddChildObject(otlFeeds.Selected,fDocRegistry.Traders.FieldByName(GTD_DB_COL_COMPANY_NAME).AsString,TObject(1));

  if Assigned(otlFeeds.Selected) then
    otlFeeds.Selected.Expand(True);

  otlFeeds.Selected := NewNode;

  txtURL.SetFocus;

  btnSave.Visible := True;

end;

procedure TCollectPricelistFrame.btnSaveClick(Sender: TObject);
begin
  // -- Save this setting
  btnProcess.Visible := True;

  if fTraderDetails.Visible then
  begin
    fTraderDetails.Visible := False;
    btnSave.Visible := True;
  end
  else begin
    btnSave.Visible := False;
    fTraderDetails.Visible := True;
    fTraderDetails.SelectSupplierOrAddNew(0);
  end;
end;

procedure TCollectPricelistFrame.SetupSampleFeeds(var aMsg : TMsg); 
begin
  // -- Setup some sample feeds in the system
  AddDailyCSVPricelistFeed('I-Tech','http://www.i-tech.com.au/products/Products.csv','Product ID=PLU;Name=Name;Category=<Product Group>;Price=Actual_Price');
  AddDailyCSVPricelistFeed('SoftwareBox','http://www.softwarebox.de/shop/products.csv','productid=PLU;name=Name;brand=;offerid=;category=<Product Group>;description=Description;price=Actual_Price;image=;url=;availability=;shipping=;special=');
  AddDailyCSVPricelistFeed('ABit','hhtp://www.abit.com.au/computer-system/Products.csv','');
  AddDailyCSVPricelistFeed('Sotel','http://www.sotel.de/products.csv','');
  AddDailyCSVPricelistFeed('comnations','http://www.comnations.de/products.csv','');
  AddDailyCSVPricelistFeed('IBuy','www.ibuy.com.au/buy/products.csv','');
  AddDailyCSVPricelistFeed('MyChams','http://www.mycharms.de/products.csv','');
  AddDailyCSVPricelistFeed('Cleverwerben','http://www.clever-werben.info/shop/elmar_products.php','');
  AddDailyCSVPricelistFeed('arkana23','http://www.arkana23.de/elmar_products.php','');
  AddDailyCSVPricelistFeed('erfolgsshop','http://www.erfolgsshop.de/elmar_products.php','');
  AddDailyCSVPricelistFeed('triologic','http://bekleidungskammer.de/elmar_products.php','');
  AddDailyCSVPricelistFeed('bauey','http://www.bauey.de/elmar_products.php','');
  AddDailyCSVPricelistFeed('homemedia4u','http://www.homemedia4u.com/catalog/elmar_products.php','');
  AddDailyCSVPricelistFeed('sold2u','http://www.sold2u.de/elmar_products.php','');
  AddDailyCSVPricelistFeed('mwv-computer','http://www.mwv-computer.eu/elmar_products.php','');

  // http://www.special-media.de/shopinfo.xml
  AddDailyCSVPricelistFeed('special-media','http://www.special-media.de/export/produktexport.txt','');

  // http://www.kochs-online-shop.de/shopinfo.xml
  AddDailyCSVPricelistFeed('kochs','http://www.kochs-online-shop.de/elmar_products.php','');

  // http://www.runmarkt.de/shopinfo.xml
  AddDailyCSVPricelistFeed('runmarkt','http://www.runmarkt.de/elmar_products.php','');

  // http://www.csb-battery.eu/shopinfo.xml
  AddDailyCSVPricelistFeed('csb-battery','http://www.csb-battery.eu/elmar_products.php','');

  // http://aurora-store.com/shopinfo.xml
  AddDailyCSVPricelistFeed('aurora-store','http://aurora-store.com/export/preisauskunft.csv','');

  // http://www.gz-computer.de/shopinfo.xml

  // -- Refresh the display
  BuildCollectionList;
end;

procedure TCollectPricelistFrame.AddDailyCSVPricelistFeed(CompanyName,URL,ColumnMappings : String);
begin
  if not Assigned(fDocRegistry) then
    Exit;

  // -- Add to the supplier table
  with fDocRegistry.Traders do
  begin
    // -- Create the main trader record with the appropriate fields
    Append;
    FieldByName(GTD_DB_COL_COMPANY_NAME).AsString := CompanyName;
    FieldByName(GTD_DB_COL_RELATIONSHIP).AsString := GTD_TRADER_RLTNSHP_SUPPLIER;
    FieldByName(GTD_DB_COL_STATUS_CODE).AsString := GTD_TRADER_STATUS_ACTIVE;
    Post;

    // -- Add all these configuration settings
    fDocRegistry.SaveTraderSettingString(PL_COLLECT_NODE,PL_COLLECT_FREQUENCY,PL_COLLECT_FREQ_DAILY,False);
    fDocRegistry.SaveTraderSettingString(PL_COLLECT_NODE,PL_COLLECT_FREQUENCY,PL_COLLECT_FREQ_DAILY,False);
    fDocRegistry.SaveTraderSettingString(PL_COLLECT_NODE,PL_COLLECT_MECHANISM,PL_COLLECT_MECH_HTTP,False);
    fDocRegistry.SaveTraderSettingString(PL_COLLECT_NODE,PL_COLLECT_HTTP_LOCATION,URL,False);
    fDocRegistry.SaveTraderSettingString(PL_COLLECT_NODE,PL_COLLECT_FORMAT,PL_COLLECT_CSV,True);

    myPL.SaveCustomerSpecifiedCSVFieldMap(fDocRegistry,fDocRegistry.Traders.FieldByName(GTD_DB_COL_TRADER_ID).AsInteger,ColumnMappings);

  end;

end;

procedure TCollectPricelistFrame.otlFeedsClick(Sender: TObject);
begin
  if not Assigned(otlFeeds.Selected) then
    Exit;

  if otlFeeds.Selected.Level = 0 then
  begin
    GrpCollection.Visible := True;
    Exit;
  end;

  if otlFeeds.Selected.Level = 1 then
  begin
    GrpCollection.Visible := False;
    pnlFeedSettings.Visible := True;

    LoadTrader(Integer(otlFeeds.Selected.Data));

    btnSave.Visible := False;
  end;

end;

function TCollectPricelistFrame.LoadTrader(Trader_Id : Integer):Integer;
var
  s,f,colmappings : String;
  SupplierDiscountPercentage : Double;
  newItem : TListItem;
begin
  // -- Open this Trader
  if fDocRegistry.OpenForTraderNumber(Trader_ID) then
  begin
    // -- Display the URL
    fDocRegistry.GetTraderSettingString(PL_COLLECT_NODE,PL_COLLECT_HTTP_LOCATION,s);
    txtURL.Text := s;

    // -- Retrieve the standard discount
    SupplierDiscountPercentage := 0;
    if DocRegistry.GetTraderSettingNumber('/Supplier Discounts','Standard_Discount',SupplierDiscountPercentage) then
    begin
      txtSupplierDiscount.Value := SupplierDiscountPercentage;
    end
    else
      txtSupplierDiscount.Value := 0;

    lstColumnMap.Items.Clear;

    // -- Now load the columns
    if myPL.GetCustomerSpecifiedCSVFieldMap(DocRegistry,Trader_ID,colmappings) then
    begin
      while colmappings <> '' do
      begin
        s := Parse(colmappings,';');
        f := Parse(s,'=');

        newItem := lstColumnMap.Items.Add;
        newItem.Caption := s;
        newItem.SubItems.Add(f);
      end;
    end;

  end;

  dlgFields.SelectValues.Clear;
  dlgFields.SelectValues.Add(GTD_PL_ELE_PRODUCT_PLU);
  dlgFields.SelectValues.Add(GTD_PL_ELE_PRODUCT_NAME);
  dlgFields.SelectValues.Add(GTD_PL_ELE_PRODUCT_DESC);
  dlgFields.SelectValues.Add(GTD_PL_ELE_PRODUCT_LIST);
  dlgFields.SelectValues.Add(GTD_PL_ELE_PRODUCT_ACTUAL);
  dlgFields.SelectValues.Add(GTD_PL_ELE_PRODUCT_BRAND);
  dlgFields.SelectValues.Add(GTD_PL_ELE_PRODUCT_UNIT);
  dlgFields.SelectValues.Add(GTD_PL_ELE_PRODUCT_MINORDQTY);
  dlgFields.SelectValues.Add(GTD_PL_ELE_PRODUCT_IMAGE);
  dlgFields.SelectValues.Add(GTD_PL_ELE_PRODUCT_BIGIMAGE);
  dlgFields.SelectValues.Add(GTD_PL_ELE_PRODUCT_MOREINFO);
  dlgFields.SelectValues.Add(GTD_PL_ELE_BRANDNAME);
  dlgFields.SelectValues.Add(GTD_PL_ELE_MANUFACT_NAME);
  dlgFields.SelectValues.Add(GTP_PL_ELE_MANUFACT_PRODINFO);
  dlgFields.SelectValues.Add(GTD_PL_ELE_PRODUCT_ACTUALEX);
  dlgFields.SelectValues.Add(GTD_PL_ELE_PRODUCT_ACTUALINC);

end;

procedure TCollectPricelistFrame.ShowPLMessage(msgType, msgDescription : String);
begin
  lblProgress.Caption := msgDescription;

  // Lines.Add(msgType + ' - ' + msgDescription);
end;

procedure TCollectPricelistFrame.HttpCli1DocEnd(Sender: TObject);
var
  cfDelim : Char;
  FL,f : String;
  li : TListItem;
  tid : Integer;
begin

  Busy(False);

  mmoData.Lines.Text := LineData;
  LineData := '';

  FL := mmoData.Lines[0];

  // -- Determine the field delimiter.
  //    If it isn't a tab, then it must be a comma.
  if (FastPos(FL,#9,Length(FL),1,1) <> 0) then
    cfDelim := #9
  else if (FastPos(FL,',',Length(FL),1,1) <> 0) then
    cfDelim := ','
  else
    Exit;

  // -- Parse all the fields and load them
  if lstColumnMap.Items.Count = 0 then
  begin
    while (FL <> '') do
    begin
      f := ReadNextCSVField(FL,cfDelim);

      if f <> '' then
      begin
        // -- Add the field to the list
        li := lstColumnMap.Items.Add;
        li.Caption := f;
        li.SubItems.Add('');
      end;
    end;
  end
  else begin

    f := ExtractFileName(UnixPathToDosPath(txtURL.Text));

    // -- Save the file
    mmoData.Lines.SaveToFile(f);

    tid := Integer(otlFeeds.Selected.Data);

    if myPL.ImportAsCustomerSpecifiedCSV(DocRegistry,tid,f) then
    begin

      // -- Now run the database load
      mySPD.UpdateFlag := True;
      mySPD.Visible := True;
      mySPD.Pricelist := myPL;
      mySPD.LoadTraderSettings(tid);
      mySPD.SkinData := fSkinData;
      Application.ProcessMessages;
      mySPD.Run;
    end;
  end;

end;

function TCollectPricelistFrame.LoadPricelistFile(FileName : String):Boolean;
var
  cfDelim : Char;
  FL,f : String;
  li : TListItem;
begin
  lstColumnMap.Items.Clear;

  // -- Load and display the filename
  mmoData.Lines.LoadFromFile(FileName);

  FL := mmoData.Lines[0];

  // -- Determine the field delimiter.
  //    If it isn't a tab, then it must be a comma.
  if (FastPos(FL,#9,Length(FL),1,1) <> 0) then
    cfDelim := #9
  else if (FastPos(FL,',',Length(FL),1,1) <> 0) then
    cfDelim := ','
  else
    Exit;

  // -- Parse all the fields and load them
  while (FL <> '') do
  begin
    f := ReadNextCSVField(FL,cfDelim);

    if f <> '' then
    begin
      // -- Add the field to the list
      li := lstColumnMap.Items.Add;
      li.Caption := f;
      li.SubItems.Add('');
    end;

  end;

end;

procedure TCollectPricelistFrame.lstColumnMapDblClick(Sender: TObject);
var
  r : Integer;
begin
  if dlgFields.Execute('Column Destination','Select Column destination',r) then
  begin
    // --
    if Assigned(lstColumnMap.Selected) then;

    lstColumnMap.Selected.SubItems[0] := dlgFields.SelectValues[r];

    // -- Display the save button
    btnSaveCfg.Visible := True;
    
  end;
end;

procedure TCollectPricelistFrame.btnSaveCfgClick(Sender: TObject);
var
  xc,tid : Integer;
  s : String;
begin
  tid := Integer(otlFeeds.Selected.Data);

  for xc := 0 to lstColumnMap.Items.Count-1 do
  begin
    // --
    s := s + lstColumnMap.Items[xc].Caption + '=' + lstColumnMap.Items[xc].SubItems[0] + ';';
  end;
  s := LeftStr(s,Length(s)-1);

  // -- Now we save it
  myPL.SaveCustomerSpecifiedCSVFieldMap(DocRegistry,tid,s);

end;

procedure TCollectPricelistFrame.Busy(YesOrNo : Boolean);
begin
  if YesOrNo then
    Screen.Cursor := crHourglass
  else
    Screen.Cursor := crDefault;

  btnAdd.Enabled := not YesOrNo;
  btnGet.Enabled := not YesOrNo;
  otlFeeds.Enabled := not YesOrNo;
  txtUrl.Enabled := not YesOrNo;
  lstColumnMap.Enabled := not YesOrNo;

end;

procedure TCollectPricelistFrame.HttpCli1SocketError(Sender: TObject);
begin
  Busy(False);
end;

procedure TCollectPricelistFrame.btnGetClick(Sender: TObject);
begin
  if not Assigned(otlFeeds.Selected) then
  begin
    Run_All;
  end
  else if otlFeeds.Selected.Level = 0 then
  begin
    Run_All;
  end
  else if otlFeeds.Selected.Level = 1 then
  begin
    Run_Selected;
  end;
end;

procedure TCollectPricelistFrame.ProcessStartFeed(var aMsg : TMsg);
begin
  Run_All;
end;

procedure TCollectPricelistFrame.ProcessNextFeed(var aMsg : TMsg);
begin
  if otlFeeds.Selected.Index < otlFeeds.Items.Count then
  begin
    otlFeeds.Selected := otlFeeds.Items[otlFeeds.Selected.Index + 1];

    Run_Selected;

  end;

end;

procedure TCollectPricelistFrame.btnSampleFeedsClick(Sender: TObject);
begin
  PostMessage(Handle,CM_SETUPSAMPLEFEEDS,0,0);
end;

end.
