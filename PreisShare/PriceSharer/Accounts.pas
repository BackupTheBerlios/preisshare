unit Accounts;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  bsSkinCtrls, bsSkinGrids, bsDBGrids, BusinessSkinForm, Db, DBTables,
  StdCtrls, Mask, bsSkinBoxCtrls;

type
  TfrmAccounts = class(TForm)
    bsBusinessSkinForm1: TbsBusinessSkinForm;
    bsSkinDBGrid1: TbsSkinDBGrid;
    bsSkinPanel1: TbsSkinPanel;
    bsSkinButton1: TbsSkinButton;
    bsSkinButton2: TbsSkinButton;
    DataSource1: TDataSource;
    tblAccounts: TTable;
    bsSkinEdit1: TbsSkinEdit;
    bsSkinLabel1: TbsSkinLabel;
    bsSkinLabel2: TbsSkinLabel;
    bsSkinEdit2: TbsSkinEdit;
    bsSkinRadioGroup1: TbsSkinRadioGroup;
    procedure bsSkinButton2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAccounts: TfrmAccounts;

implementation
	uses Main;
{$R *.DFM}

procedure TfrmAccounts.bsSkinButton2Click(Sender: TObject);
begin
	Close;
end;

end.
