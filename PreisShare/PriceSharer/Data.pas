unit Data;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, DBTables;

type
  TDataModule1 = class(TDataModule)
    tblSysMaps: TTable;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DataModule1: TDataModule1;

implementation

{$R *.DFM}

procedure TDataModule1.DataModuleCreate(Sender: TObject);
begin
    //tblSysMaps.Active := True;
end;

end.
