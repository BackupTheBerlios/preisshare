unit AddProductGroup;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  bsSkinCtrls, BusinessSkinForm, StdCtrls, Mask, bsSkinBoxCtrls;

type
  TfrmAddProductGroup = class(TForm)
    bsBusinessSkinForm1: TbsBusinessSkinForm;
    bsSkinGroupBox1: TbsSkinGroupBox;
    bsSkinButton1: TbsSkinButton;
    bsSkinButton2: TbsSkinButton;
    rdoMainGroup: TbsSkinCheckRadioBox;
    rdoSubGroup: TbsSkinCheckRadioBox;
    bsSkinLabel1: TbsSkinLabel;
    txtGroupName: TbsSkinEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAddProductGroup: TfrmAddProductGroup;

implementation
uses Main;

{$R *.DFM}

end.
