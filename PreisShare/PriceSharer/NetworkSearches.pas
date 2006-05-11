unit NetworkSearches;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  BusinessSkinForm, GTDSearchTextHandler;

type
  TfrmNetworkSearches = class(TForm)
    bsBusinessSkinForm1: TbsBusinessSkinForm;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    myST : TSearchTextHandler;
  end;

var
  frmNetworkSearches: TfrmNetworkSearches;

implementation

{$R *.DFM}
uses Main;

procedure TfrmNetworkSearches.FormCreate(Sender: TObject);
begin
    myST := TSearchTextHandler.Create(Self);
    with myST do
    begin
        Top := 10;
        Left := 10;
        Parent := Self;
        Visible := True;
        SkinData := frmMain.bsSkinData1;
    end;

end;

end.
