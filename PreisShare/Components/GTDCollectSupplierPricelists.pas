unit GTDCollectSupplierPricelists;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, bsSkinCtrls, StdCtrls, bsSkinBoxCtrls, HttpProt,
  bsMessages,bsSkinData, bsSkinMenus, Menus, bsDialogs, Mask, DB, DBTables,
  GTDBizDocs;
type
  TCollectPricelistFrame = class(TFrame)
    HttpCli1: THttpCli;
    pnlBackground: TbsSkinPanel;
    btnAdd: TbsSkinSpeedButton;
    btnRun: TbsSkinSpeedButton;
    otlFeeds: TbsSkinTreeView;
    Memo1: TbsSkinMemo2;
    barProgress: TbsSkinGauge;
    lblProgress: TbsSkinStdLabel;
    bsSkinPopupMenu1: TbsSkinPopupMenu;
    AddURL1: TMenuItem;
    dlgURL: TbsSkinInputDialog;
    pnlFeedSettings: TbsSkinGroupBox;
    btnSave: TbsSkinButton;
    bsSkinLabel1: TbsSkinLabel;
    bsSkinEdit1: TbsSkinEdit;
    qrySources: TQuery;
    lsvSupplierList: TbsSkinListView;
    bsSkinListView1: TbsSkinListView;
    bsSkinLabel2: TbsSkinLabel;
    bsSkinListView2: TbsSkinListView;
    procedure HttpCli1DocData(Sender: TObject; Buffer: Pointer;
      Len: Integer);
    procedure btnRunClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
  private
    { Private declarations }
    fDocRegistry : GTDDocumentRegistry;
    fSkinData   : TbsSkinData;

    function BuildCollectionList:Boolean;

  public
    { Public declarations }

    procedure SetSkinData(Value: TbsSkinData);

    function Run:Boolean;

  published

    property SkinData   : TbsSkinData read fSkinData write SetSkinData;
    property DocRegistry : GTDDocumentRegistry read fDocRegistry write fDocRegistry;
  end;

implementation

{$R *.dfm}

const
  PL_COLLECT_FORMAT     = 'Collection_Format';
  PL_COLLECT_CSV               = 'CSV';
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
  Memo1.Lines.Append(s);

end;

procedure TCollectPricelistFrame.btnRunClick(Sender: TObject);
begin
//  HttpCli1.Url := 'http://www.i-tech.com.au/Products.xml';
  HttpCli1.Url := 'http://www.i-tech.com.au/Products.csv';
  HttpCli1.GetAsync;
end;

procedure TCollectPricelistFrame.SetSkinData(Value: TbsSkinData);
begin
  pnlBackGround.SkinData := Value;
  btnAdd.SkinData := Value;
  btnRun.SkinData := Value;
  otlFeeds.SkinData := Value;
  Memo1.SkinData := Value;
  lblProgress.SkinData := Value;
  barProgress.SkinData := Value;
  dlgURL.SkinData := Value;
  dlgURL.CtrlSkinData := Value;
  pnlFeedSettings.SkinData := Value;
end;

procedure TCollectPricelistFrame.btnAddClick(Sender: TObject);
begin
  pnlFeedSettings.Visible := True;
end;

function TCollectPricelistFrame.BuildCollectionList:Boolean;
var
    newItem : TListItem;
    ListCount,tid : Integer;
    v : String;
    dt : TDateTime;
begin
  {Select all traders from the trader table}
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
    lsvSupplierList.Items.Clear;
    First;
    ListCount :=0;
    while not Eof do
    begin

      tid := FieldByName(GTD_DB_COL_TRADER_ID).AsInteger;

      // -- Open this Trader
      if fDocRegistry.OpenForTraderNumber(tid) then
      begin

        // -- Add the company to the list
        newItem := lsvSupplierList.Items.Add;
        newItem.Caption := fDocRegistry.Trader_Name;
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
        newItem.SubItems.Add(v);

        // -- Last sent
        v := '';
        fDocRegistry.GetTraderSettingString(PL_COLLECT_NODE,PL_COLLECT_LAST_SENT,v);
        newItem.SubItems.Add(v);

        newItem.SubItems.Add(FieldByName(GTD_DB_COL_TRADER_ID).AsString);

      end;

      Next;
    end;

	end;

  // -- Update the label
//  lblListCount.Caption := IntToStr(ListCount) + ' Customers found';
end;


function TCollectPricelistFrame.Run:Boolean;
begin
end;

end.
