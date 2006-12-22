unit GTDSearchTextHandler;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  OleServer, StdCtrls, Excel97, bsSkinCtrls, bsSkinBoxCtrls, bsSkinData,
  bsSkinShellCtrls,GTDTextToPricefile, GTDBizDocs,
  Mask, bsDialogs, ComCtrls, bsSkinTabs, WSocket, GTDBizLinks;

type
  TSearchTextHandler = class(TFrame)
    pnlMain: TbsSkinPanel;
    bsSkinToolBar1: TbsSkinToolBar;
    bsSkinSpeedButton1: TbsSkinSpeedButton;
    bsSkinSpeedButton2: TbsSkinSpeedButton;
    bsSkinSpeedButton3: TbsSkinSpeedButton;
    bsSkinStdLabel1: TbsSkinStdLabel;
    bsSkinScrollBar1: TbsSkinScrollBar;
    bsSkinListView1: TbsSkinListView;
    bsSkinStdLabel2: TbsSkinStdLabel;
    gtdLANPoint1: gtdLANPoint;
  private
    { Private declarations }
	fSkinData: TbsSkinData;

	procedure SetSkinData(Value: TbsSkinData);

  public
    { Public declarations }
  published
	property SkinData: TbsSkinData read fSkinData write SetSkinData;
  end;

implementation

{$R *.DFM}

procedure TSearchTextHandler.SetSkinData(Value: TbsSkinData);
begin
    pnlMain.SkinData            := Value;
    bsSkinToolBar1.SkinData     := Value;
    bsSkinSpeedButton1.SkinData := Value;
    bsSkinSpeedButton2.SkinData := Value;
    bsSkinSpeedButton3.SkinData := Value;
    bsSkinStdLabel1.SkinData    := Value;
    bsSkinScrollBar1.SkinData   := Value;
    bsSkinListView1.SkinData    := Value;
end;

end.
