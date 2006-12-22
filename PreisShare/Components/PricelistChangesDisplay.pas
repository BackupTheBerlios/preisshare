unit PricelistChangesDisplay;

interface

uses 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  bsSkinCtrls, ComCtrls;

type
  TPriceChangeDisplay = class(TFrame)
    z: TbsSkinTreeView;
    bsSkinListView1: TbsSkinListView;
    bsSkinSpeedButton1: TbsSkinSpeedButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

end.
