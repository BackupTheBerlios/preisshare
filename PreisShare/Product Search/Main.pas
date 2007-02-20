unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  bsSkinData, BusinessSkinForm, bsSkinCtrls, StdCtrls, Mask, bsSkinBoxCtrls,
  ComCtrls, bsMessages, GTDProductDBSearch, Db, DBTables,
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
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }

    procedure DisplaySearchMessage(DisplayMsg : String);
    procedure SelectDisplayColumns(Sender : TObject);

  public
    { Public declarations }
    productDB : TProductdBSearch;
//    procedure Search;
    procedure UpdateSellPrices(Sender : TObject);
  end;

var
  frmMain: TfrmMain;

implementation

uses SpreadSheetImport, UpdateSellPrices, ColumnParams;

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
    p,t,l : Integer;
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

    // -- Now look up form positions
    if DocRegistry.GetSettingString('Product Search','Settings',s) then
    begin
      Position := poDefault;

      // -- Read positions from the registry
      t := -1; L := -1;
      if DocRegistry.GetSettingMemoInt('/Position','Top',p) then
        T := p;
      if DocRegistry.GetSettingMemoInt('/Position','Left',p) then
        L := p;

      { -- Add these later
      if DocRegistry.GetSettingMemoInt('/Position','Width',p) then
        W := p;
      if DocRegistry.GetSettingMemoInt('/Position','Height',p) then
        H := p;
      }

      // -- Use the Win32 Api because it seems to work
      if (T <> -1) and (L <> -1) then
        MoveWindow(Handle,L,T,Width,Height,False);


    end
    else
      Position := poDesktopCenter;


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
    productDB.mnuSelectColumns.OnClick := SelectDisplayColumns;

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

procedure TfrmMain.SelectDisplayColumns(Sender : TObject);
begin
  frmColumnParams.LoadColumnInfo(TQuery(productDB.qryFindProducts));
  frmColumnParams.ShowModal;
end;

procedure TfrmMain.DisplaySearchMessage(DisplayMsg : String);
begin
//  lblDisplaySeachMessage.Caption := DisplayMsg;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
var
  s : String;
  xc : Integer;
begin

  // -- Save the X,Y, Width and Height coordinates
  if DocRegistry.SysVals.Active then
  begin
    // -- Only try doing the update if the config table is open
    //    otherwise it won't be possible to close down the application
    if DocRegistry.GetSettingString('Product Search','Settings',s) then
    begin
      DocRegistry.SaveSettingMemoInt('/Position','Top',Top, False);
      DocRegistry.SaveSettingMemoInt('/Position','Left',Left, False);
      DocRegistry.SaveSettingMemoInt('/Position','Width',Width, False);
      DocRegistry.SaveSettingMemoInt('/Position','Height',Height, True);
    end;
    // -- Now save the column settings
    productDB.SaveColumnDefinitions;
  end;
end;

end.



