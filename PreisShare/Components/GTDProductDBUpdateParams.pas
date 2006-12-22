unit GTDProductDBUpdateParams;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, bsSkinCtrls, ComCtrls, bsSkinBoxCtrls;

type
  TFrame1 = class(TFrame)
    pnlStart1: TbsSkinGroupBox;
    bsSkinTextLabel2: TbsSkinTextLabel;
    optExportCSV: TbsSkinCheckRadioBox;
    optExportExternalDB: TbsSkinCheckRadioBox;
    optExportCompare: TbsSkinCheckRadioBox;
    optExportProductDB: TbsSkinCheckRadioBox;
    pblSupplierDetails: TbsSkinGroupBox;
    bsSkinLabel10: TbsSkinLabel;
    bsSkinSpinEdit1: TbsSkinSpinEdit;
    bsSkinLabel5: TbsSkinLabel;
    bsSkinCheckRadioBox1: TbsSkinCheckRadioBox;
    bsSkinStatusPanel1: TbsSkinStatusPanel;
    bsSkinLabel6: TbsSkinLabel;
    txtSupplierName: TbsSkinStatusPanel;
    pnlProdGroups: TbsSkinGroupBox;
    lstProdGroups: TbsSkinTreeView;
    btnNext1: TbsSkinButton;
    bsSkinCheckRadioBox3: TbsSkinCheckRadioBox;
    cbxNoUpdate: TbsSkinCheckRadioBox;
    cbxUpdate: TbsSkinCheckRadioBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

end.
