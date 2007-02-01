unit GTDSupplierPriceParams;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, ComCtrls, SynEdit,
  bsSkinData, bsSkinBoxCtrls, bsSkinCtrls, bsSkinGrids,
  SynEditHighlighter, SynHighlighterPas,
  PricelistExport;

type
  TSupplierPriceParamsFrame = class(TFrame)
    SynPasSyn1: TSynPasSyn;
    bsSkinPanel1: TbsSkinScrollBox;
    SynEdit1: TSynEdit;
    lblSynEdit1: TbsSkinLabel;
    txtAdjustValue: TbsSkinSpinEdit;
    lblAdjustValue: TbsSkinLabel;
    lblOtherCharges: TbsSkinLabel;
    txtOtherCharges: TbsSkinNumericEdit;
    txtAddTax: TbsSkinSpinEdit;
    lblAddTax: TbsSkinLabel;
    bsSkinScrollBar1: TbsSkinScrollBar;
    cbxAdvancedCalculator: TbsSkinCheckRadioBox;
    cbxSimple: TbsSkinCheckRadioBox;
    procedure cbxAdvancedCalculatorClick(Sender: TObject);
  private
    { Private declarations }
  	fSkinData       : TbsSkinData;
    fAdjustment_pc,
    fCharges,
    fTax_pc         : Double;

    fUpdateComponent : TGTDPricelistExportFrame;

  	procedure SetSkinData(Value: TbsSkinData); {override;}
  public
    { Public declarations }
  published
  	property SkinData   : TbsSkinData read fSkinData write SetSkinData;

    property AdjustmentPercentage : Double read fAdjustment_pc write fAdjustment_pc;
    property Charges : Double read fCharges write fCharges;
    property TaxPercentage : Double read fTax_pc write fTax_pc;

    property UpdateComponent : TGTDPricelistExportFrame read fUpdateComponent write fUpdateComponent;

  end;

implementation

{$R *.dfm}

procedure TSupplierPriceParamsFrame.SetSkinData(Value: TbsSkinData);
begin
    // -- Change the skin values
    bsSkinPanel1.SkinData := Value;

    lblSynEdit1.SkinData := Value;
    txtAdjustValue.SkinData := Value;
    lblAdjustValue.SkinData := Value;
    lblOtherCharges.SkinData := Value;
    txtOtherCharges.SkinData := Value;
    txtAddTax.SkinData := Value;
    lblAddTax.SkinData := Value;
    bsSkinScrollBar1.SkinData := Value;
    cbxAdvancedCalculator.SkinData := Value;
    cbxSimple.SkinData := Value;

end;

procedure TSupplierPriceParamsFrame.cbxAdvancedCalculatorClick(
  Sender: TObject);
begin
  if cbxAdvancedCalculator.Checked then
  begin
    // --
    Self.Height := 149;
    lblSynEdit1.Visible := True;
    lblSynEdit1.Top := lblAdjustValue.Top;
    SynEdit1.Top := txtAdjustValue.Top;
    SynEdit1.Visible := True;
  end
  else begin
    Self.Height := 105;
    SynEdit1.Visible := False;
    lblSynEdit1.Visible := False;
  end;
end;

end.
