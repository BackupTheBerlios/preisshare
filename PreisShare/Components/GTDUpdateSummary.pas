unit GTDUpdateSummary;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, ComCtrls, StdCtrls, ExtCtrls,
  bsSkinData, bsSkinBoxCtrls, bsSkinCtrls, Mask, bsSkinGrids, bsDBGrids, GTDBizDocs;

type
  TGTDPriceUpdateSummary = class(TFrame)
    pnlMain: TbsSkinPanel;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    txtRisesCount: TLabel;
    txtNewCount: TLabel;
    txtFallsCount: TLabel;
    txtRemovedCount: TLabel;
    txtSteadyCount: TLabel;
    Image6: TImage;
    txtChangedCount: TLabel;
    lsvItems: TbsSkinListView;
    mmoProgress: TbsSkinMemo2;
    Shape1: TShape;
    Shape2: TShape;
    Shape3: TShape;
    Shape4: TShape;
    Shape5: TShape;
    Shape6: TShape;
  private
    { Private declarations }
	fSkinData           : TbsSkinData;

	procedure SetSkinData(Value: TbsSkinData); {override;}
  public
    { Public declarations }
	procedure ReportMessage(Msg: string);
  published
	property SkinData   : TbsSkinData read fSkinData write SetSkinData;
  end;

implementation

{$R *.dfm}

procedure TGTDPriceUpdateSummary.SetSkinData(Value: TbsSkinData);
begin
    pnlMain.SkinData := Value;
    lsvItems.SkinData := Value;

    fSkinData := Value;
end;

procedure TGTDPriceUpdateSummary.ReportMessage(Msg: string);
begin
  mmoProgress.ReadOnly := false;
  mmoProgress.Lines.Append(Msg);
  mmoProgress.ReadOnly := true;
end;

end.
