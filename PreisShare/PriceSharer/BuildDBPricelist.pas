unit BuildDBPricelist;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  GTDBuildPricelistFromDBConfig, GTDBuildPricelistFromDBRun, ComCtrls,
  GTDBizDocs, bsSkinData, BusinessSkinForm, bsSkinCtrls;
type
  TfrmBuildDBPricelist = class(TForm)
    bsBusinessSkinForm1: TbsBusinessSkinForm;
    bsSkinSpeedButton1: TbsSkinSpeedButton;
    btnConfig: TbsSkinSpeedButton;
    btnRun: TbsSkinSpeedButton;
    btnClose: TbsSkinButton;
    procedure FormCreate(Sender: TObject);
    procedure bsSkinSpeedButton1Click(Sender: TObject);
    procedure btnRunClick(Sender: TObject);
    procedure btnConfigClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    myConfig : TBuildPricelistFromDBConfig;
    myRun    : TBuildPricelistFromDBRun;
  end;

var
  frmBuildDBPricelist: TfrmBuildDBPricelist;

implementation

uses Main;

{$R *.DFM}

procedure TfrmBuildDBPricelist.FormCreate(Sender: TObject);
var
    s : String;
begin

    bsBusinessSkinForm1.SkinData := frmMain.bsSkinData1;
    
    // -- Create the configuration object
    myConfig := TBuildPricelistFromDBConfig.Create(Self);
    with myConfig do
    begin
        Left := 20;
        Top  := 20;
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
        Left := 20;
        Top  := 20;
        Parent := Self;
        SkinData := frmMain.bsSkinData1;
        Configuration := myConfig;
        DocRegistry := frmMain.DocRegistry;
        Initialise;
    end;
    
end;

procedure TfrmBuildDBPricelist.bsSkinSpeedButton1Click(Sender: TObject);
begin
    myRun.Visible := True;
    myConfig.Visible := False;
    myRun.ChooseProfileThenRun;
end;

procedure TfrmBuildDBPricelist.btnRunClick(Sender: TObject);
begin
    // --
    myRun.Visible := True;
    myConfig.Visible := False;
end;

procedure TfrmBuildDBPricelist.btnConfigClick(Sender: TObject);
begin
    myConfig.Visible := True;
    myRun.Visible := False;
    btnRun.Visible := True;
end;

procedure TfrmBuildDBPricelist.btnCloseClick(Sender: TObject);
begin
    Close;
end;

end.
