unit NewsLetter;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, bsSkinCtrls, ComCtrls, StdCtrls, bsSkinBoxCtrls,
  BusinessSkinForm, bsColorCtrls, ExtCtrls;

type
  TfrmNewsletter = class(TForm)
    bsBusinessSkinForm1: TbsBusinessSkinForm;
    bsSkinRichEdit1: TbsSkinRichEdit;
    bsSkinBevel1: TbsSkinBevel;
    bsSkinTextLabel1: TbsSkinTextLabel;
    bsSkinButton1: TbsSkinButton;
    bsSkinButton2: TbsSkinButton;
    bsSkinLabel1: TbsSkinLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmNewsletter: TfrmNewsletter;

implementation

{$R *.dfm}
uses Main;

end.
