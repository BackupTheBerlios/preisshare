unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  bsSkinData, BusinessSkinForm, StdCtrls, bsSkinBoxCtrls, bsdbctrls,
  bsSkinCtrls, bsSkinGrids, bsDBGrids, Db, DBTables;

type
  TForm1 = class(TForm)
    Table1: TTable;
    DataSource1: TDataSource;
    bsSkinDBGrid1: TbsSkinDBGrid;
    bsSkinDBMemo21: TbsSkinDBMemo2;
    bsBusinessSkinForm1: TbsBusinessSkinForm;
    bsSkinData1: TbsSkinData;
    bsStoredSkin1: TbsStoredSkin;
    Table1Section: TStringField;
    Table1KeyName: TStringField;
    Table1KeyValue: TStringField;
    Table1KeyText: TMemoField;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
begin
  Table1.DatabaseName := ExtractFileDir(Application.ExeName) +  '\DATAPX';
  Table1.Active := True;
end;

end.
