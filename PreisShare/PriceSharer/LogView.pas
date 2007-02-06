unit LogView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BusinessSkinForm, DB, DBTables, bsSkinCtrls, bsSkinGrids,
  bsDBGrids, StdCtrls, bsSkinBoxCtrls, bsdbctrls;

type
  TfrmLogView = class(TForm)
    bsBusinessSkinForm1: TbsBusinessSkinForm;
    bsSkinDBGrid1: TbsSkinDBGrid;
    qryFindRecords: TQuery;
    DataSource1: TDataSource;
    bsSkinButton1: TbsSkinButton;
    bsSkinDBMemo1: TbsSkinDBMemo;
    bsSkinScrollBar1: TbsSkinScrollBar;
    qryFindRecordsLocal_Timestamp: TDateTimeField;
    qryFindRecordsName: TStringField;
    qryFindRecordsAudit_Code: TStringField;
    qryFindRecordsAudit_Description: TStringField;
    qryFindRecordsAudit_Log: TMemoField;
    procedure FormCreate(Sender: TObject);
    procedure bsSkinButton1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmLogView: TfrmLogView;

implementation

{$R *.dfm}

uses
  Main;

procedure TfrmLogView.FormCreate(Sender: TObject);
begin
  qryFindRecords.DatabaseName := frmMain.DocRegistry.DatabaseName;
  qryFindRecords.Active := True;
end;

procedure TfrmLogView.bsSkinButton1Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmLogView.FormActivate(Sender: TObject);
begin
  // -- Refresh the view
  qryFindRecords.Active := False;

  qryFindRecords.Active := True;
  
end;

end.
