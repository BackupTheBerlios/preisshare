unit Relay;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, bsSkinCtrls, BusinessSkinForm;

type
  TfrmRelayOptions = class(TForm)
    bsBusinessSkinForm1: TbsBusinessSkinForm;
    bsSkinButton1: TbsSkinButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmRelayOptions: TfrmRelayOptions;

implementation

{$R *.dfm}

end.
