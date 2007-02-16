unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  bsSkinData, BusinessSkinForm, bsSkinCtrls, StdCtrls, Mask, bsSkinBoxCtrls,
  ComCtrls, bsMessages, GTDProductDBSearch, Db,
  Grids, DBGrids, ADODB, FMTBcd, SqlExpr, GTDBizDocs, bsDialogs,
  bsSkinShellCtrls;

type
  TfrmMain = class(TForm)
    bsBusinessSkinForm1: TbsBusinessSkinForm;
    bsSkinData1: TbsSkinData;
    bsStoredSkin1: TbsStoredSkin;
    bsSkinButton1: TbsSkinButton;
    bsSkinMessage1: TbsSkinMessage;
    DataSource1: TDataSource;
    ADOConnection: TADOConnection;
    DocRegistry: GTDDocumentRegistry;
    dlgSelectFormat: TbsSkinSelectValueDialog;
    dlgOpenDatabase: TbsSkinOpenDialog;
    bsCompressedStoredSkin1: TbsCompressedStoredSkin;
    bsOpenSkinDialog1: TbsOpenSkinDialog;
    procedure btnSearchClick(Sender: TObject);
    procedure bsSkinButton1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DocRegistryClick(Sender: TObject);
    procedure FormDblClick(Sender: TObject);
  private
    { Private declarations }
    productDB : TProductdBSearch;

    procedure DisplaySearchMessage(DisplayMsg : String);

  public
    { Public declarations }
//    procedure Search;
    procedure UpdateSellPrices(Sender : TObject);
  end;

var
  frmMain: TfrmMain;

implementation

uses SpreadSheetImport, UpdateSellPrices;

{$R *.DFM}

procedure TfrmMain.btnSearchClick(Sender: TObject);
begin
//    bsSkinMessage1.MessageDlg(txtSearchText.Text,mtInformation,[mbOk],0);
end;

procedure TfrmMain.bsSkinButton1Click(Sender: TObject);
begin
    Close;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
var
    s,dbname: String;
begin

    DocRegistry.OpenRegistry('',s);

    // -- Retrieve the name of the Access database
    DocRegistry.GetSettingString(GTD_PRODUCTDB_KEY,GTD_PRODDB_NAME,dbname);

    // -- If the database file doesn't exist, then let the user choose
    if not FileExists(dbName) then
    begin

        // -- Ask the user for the location of the database
        dlgOpenDatabase.Title := 'Select Product Database..';

        if dlgOpenDatabase.Execute then
        begin
            // -- Retrieve the name of the file
            dbName := dlgOpenDatabase.FileName;

            // -- Now store it back
            DocRegistry.SaveSettingString(GTD_PRODUCTDB_KEY,GTD_PRODDB_NAME,dbname);

        end;
    end;

    // -- Build the correct connection string
    ADOConnection.ConnectionString := 'Provider=Microsoft.Jet.OLEDB.4.0;'+
                                      'User ID=Admin;Data Source=' +
                                      dbName +
                                      ';Mode=Share Deny None;'+
                                      'Persist Security Info=False;';
    ADOConnection.Connected := True;

    // -- Create the search component
    productDB := TProductdBSearch.Create(Self);
    with productDB do
    begin
        Parent := Self;
        Top := 10;
        Left := 10;
        Visible := True;
        SendToBack;
        SkinData := bsSkinData1;
        qryWordCheck.Connection := ADOConnection;
        QryFindProducts.Connection := ADOConnection;
        qryCountStuff.Connection := ADOConnection;
        DocumentRegistry := DocRegistry;

        Initialise;
    end;

    // -- Here we will assign the onclicks. They need to run from
    //    somewhere like here because new forms will be created
    //    and we're not doing it inside the frames
    productDB.mnuImport.OnClick := DocRegistryClick;
    productDB.mnuUpdateSellPrices.OnClick := UpdateSellPrices;

    ActiveControl := productDB.txtSearchText;

end;

procedure TfrmMain.DocRegistryClick(Sender: TObject);
var
    xc : Integer;
begin
    // -- Dynamically create the form
    if not Assigned(frmSpreadSheetImport) then
        Application.CreateForm(TfrmSpreadSheetImport, frmSpreadSheetImport);

    xc := 1;
    // -- Show the spreadsheet import wizard
    if dlgSelectFormat.Execute('Pricelist Import Facility','Select the format of the pricelist to import',xc) then
    begin
        frmSpreadSheetImport.ShowModal;
    end;
end;

procedure TfrmMain.FormDblClick(Sender: TObject);
begin
    if bsOpenSkinDialog1.Execute then
    begin
        bsSkinData1.LoadFromFile(bsOpenSkinDialog1.FileName);
    end;
end;

procedure TfrmMain.UpdateSellPrices(Sender : TObject);
begin
  frmUpdateSellPrices.ShowModal;
end;

procedure TfrmMain.DisplaySearchMessage(DisplayMsg : String);
begin
//  lblDisplaySeachMessage.Caption := DisplayMsg;
end;

end.



