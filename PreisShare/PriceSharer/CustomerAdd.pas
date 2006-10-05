unit CustomerAdd;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  BusinessSkinForm, StdCtrls, Mask, bsSkinBoxCtrls, bsSkinCtrls, ExtCtrls;

type
  TfrmCustomerAdd = class(TForm)
    bsBusinessSkinForm1: TbsBusinessSkinForm;
    bsSkinGroupBox1: TbsSkinGroupBox;
    bsSkinGroupBox2: TbsSkinGroupBox;
    bsSkinButton1: TbsSkinButton;
    bsSkinButton2: TbsSkinButton;
    bsSkinCheckRadioBox1: TbsSkinCheckRadioBox;
    bsSkinCheckRadioBox2: TbsSkinCheckRadioBox;
    bsSkinCheckRadioBox3: TbsSkinCheckRadioBox;
    bsSkinLabel1: TbsSkinLabel;
    bsSkinEdit1: TbsSkinEdit;
    bsSkinEdit2: TbsSkinEdit;
    bsSkinLabel2: TbsSkinLabel;
    bsSkinGroupBox3: TbsSkinGroupBox;
    bsSkinCheckRadioBox4: TbsSkinCheckRadioBox;
    bsSkinCheckRadioBox5: TbsSkinCheckRadioBox;
    bsSkinCheckRadioBox6: TbsSkinCheckRadioBox;
    bsSkinControlBar1: TbsSkinControlBar;
    bsSkinToolBar1: TbsSkinToolBar;
    bsSkinSpeedButton1: TbsSkinSpeedButton;
    bsSkinSpeedButton2: TbsSkinSpeedButton;
    bsSkinCheckRadioBox7: TbsSkinCheckRadioBox;
    bsSkinCheckRadioBox8: TbsSkinCheckRadioBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCustomerAdd: TfrmCustomerAdd;

implementation

{$R *.DFM}
uses Main;

end.
