unit BuildDBPricelist;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  GTDBuildPricelistFromDBConfig, GTDBuildPricelistFromDBRun, ComCtrls,
  GTDBizDocs, bsSkinData, BusinessSkinForm, bsSkinCtrls, StdCtrls,
  bsSkinBoxCtrls, jpeg, ExtCtrls;
type
  TfrmBuildDBPricelist = class(TForm)
    bsBusinessSkinForm1: TbsBusinessSkinForm;
    btnConfig: TbsSkinSpeedButton;
    btnRun: TbsSkinSpeedButton;
    btnClose: TbsSkinButton;
    Image1: TImage;
    bsSkinMemo1: TbsSkinMemo;
    bsSkinGroupBox1: TbsSkinGroupBox;
    btnAddCustomer: TbsSkinSpeedButton;
    bsSkinSpeedButton3: TbsSkinSpeedButton;
    lblNoCustomers: TbsSkinTextLabel;
    lsvCustomers: TbsSkinListView;
    lblHaveCustomers: TbsSkinTextLabel;
    procedure FormCreate(Sender: TObject);
    procedure bsSkinSpeedButton1Click(Sender: TObject);
    procedure btnRunClick(Sender: TObject);
    procedure btnConfigClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure bsSkinSpeedButton3Click(Sender: TObject);
    procedure btnAddCustomerClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lsvCustomersChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
  private
    { Private declarations }
  public
    { Public declarations }
    myConfig : TBuildPricelistFromDBConfig;
    myRun    : TBuildPricelistFromDBRun;

    procedure Initialise;
    procedure LoadCustomerList;

  end;

var
  frmBuildDBPricelist: TfrmBuildDBPricelist;

implementation

uses Main, CustomerAdd, PricelistGenerate;

{$R *.DFM}
const
    BldCustomplfrmDbKey = 'Pricelist Build Map';

procedure TfrmBuildDBPricelist.FormCreate(Sender: TObject);
var
    s : String;
begin

    bsBusinessSkinForm1.SkinData := frmMain.bsSkinData1;

    // -- Create the configuration object
    myConfig := TBuildPricelistFromDBConfig.Create(Self);
    with myConfig do
    begin
        Left := 8;
        Top  := 8;
        Parent := Self;
        DocRegistry := frmMain.DocRegistry;
        SkinData := frmMain.bsSkinData1;
        Visible := False;
        Initialise;
    end;

    // -- Create the run object
    myRun := TBuildPricelistFromDBRun.Create(Self);
    with myRun do
    begin
        Left := 8;
        Top  := 8;
        Visible := False;
        Parent := Self;
        SkinData := frmMain.bsSkinData1;
        Configuration := myConfig;
        DocRegistry := frmMain.DocRegistry;
        Initialise;
    end;

    lblHaveCustomers.Left := lblNoCustomers.Left;
    lblHaveCustomers.Top  := lblNoCustomers.Top;

end;

procedure TfrmBuildDBPricelist.bsSkinSpeedButton1Click(Sender: TObject);
begin
    myRun.Visible := True;
    myConfig.Visible := False;
    myRun.ChooseTraderProfileThenRun;
end;

procedure TfrmBuildDBPricelist.btnRunClick(Sender: TObject);
var
    tid : Integer;
begin
    // --
    myRun.Visible := True;
    myConfig.Visible := False;

    Application.ProcessMessages;

    if Assigned(lsvCustomers.Selected) then
    begin
        // -- Extract the customer number
        tid := StrToInt(lsvCustomers.Selected.SubItems[2]);

        myRun.RunCustomerPricelist(tid);
    end;

    // -- Redisplay the list
    LoadCustomerList;

end;

procedure TfrmBuildDBPricelist.btnConfigClick(Sender: TObject);
var
    tid : Integer;
begin
    // --
    myRun.Visible := True;
    myConfig.Visible := False;

    Application.ProcessMessages;

    if Assigned(lsvCustomers.Selected) then
    begin
        // -- Extract the customer number
        tid := StrToInt(lsvCustomers.Selected.SubItems[2]);

        myConfig.LoadCustomerMapping(tid);
        
        myConfig.Visible := True;
        myRun.Visible := False;

    end;
end;

procedure TfrmBuildDBPricelist.btnCloseClick(Sender: TObject);
begin
    Close;
end;

procedure TfrmBuildDBPricelist.bsSkinSpeedButton3Click(Sender: TObject);
begin
    myConfig.Visible := False;
    myRun.Visible := False;
    btnRun.Visible := False;

    LoadCustomerList;

end;

procedure TfrmBuildDBPricelist.btnAddCustomerClick(Sender: TObject);
begin
    frmCustomerAdd.ShowModal;

    if frmCustomerAdd.CustomerAdded then
    begin
        // -- Setup the configuration dialog 
        myConfig.Initialise;

        myConfig.Trader_ID := frmMain.DocRegistry.Trader_ID;

        myConfig.Show;

    end;
end;

procedure TfrmBuildDBPricelist.Initialise;
begin
    if not Assigned(frmMain.DocRegistry) then
        Exit;

    LoadCustomerList;
end;

procedure TfrmBuildDBPricelist.LoadCustomerList;
var
    myList : TStringList;
    xc,tid : Integer;
    s,k,v : String;
    anItem : TListItem;
    dt : TDateTime;
begin
    myList := TStringList.Create;
    try

        lsvCustomers.Items.Clear;
            
        // -- Read a list of all the Customers in
        frmMain.DocRegistry.GetSettingItemList(BldCustomplfrmDbKey,myList);

        k := 'Trader#=';

        // -- Scan through all the entries
        for xc := 1 to myList.Count do
        begin

            s := myList[xc-1];

            if Pos(k,s) <> 0 then
            begin
                // -- Retrieve the trader number
                tid := StrToInt(Copy(s,9,Length(s)-8));

                // -- Open this Trader
                if frmMain.DocRegistry.OpenForTraderNumber(tid) then
                begin
                    // -- Now add the Customer name into the list
                    anItem := lsvCustomers.Items.Add;
                    anItem.Caption := frmMain.DocRegistry.Trader_Name;

                    v := '';
                    frmMain.DocRegistry.GetTraderSettingString(PL_DELIV_NODE,PL_DELIV_LAST_RUN,v);
                    if v = '' then
                    begin
                        dt := frmMain.DocRegistry.GetLatestPriceListDateTime;
                        if (dt = 0) then
                            v := 'Never'
                        else
                            v := DateTimeToStr(dt);
                    end;

                    anItem.SubItems.Add(v);

                    v := '';
                    frmMain.DocRegistry.GetTraderSettingString(PL_DELIV_NODE,PL_DELIV_FREQUENCY,v);
                    anItem.SubItems.Add(v);

                    // -- Add in the Trader_ID as the last column
                    anItem.SubItems.Add(IntToStr(tid));

                end;
            end;

        end;

        if lsvCustomers.Items.Count = 0 then
        begin
            lblNoCustomers.Visible := True;
            lblHaveCustomers.Visible := False;
        end
        else begin
            lblNoCustomers.Visible := False;
            lblHaveCustomers.Visible := True;
        end;

    finally
        myList.Destroy;
    end;

end;

procedure TfrmBuildDBPricelist.FormShow(Sender: TObject);
begin
    Initialise;
end;

procedure TfrmBuildDBPricelist.lsvCustomersChange(Sender: TObject;
  Item: TListItem; Change: TItemChange);
begin
    btnRun.Visible := Assigned(lsvCustomers.Selected);
    btnConfig.Visible := Assigned(lsvCustomers.Selected);
end;

end.
