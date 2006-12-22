unit ReceiptEntry;

interface

uses 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  bsCalendar, bsSkinCtrls, bsSkinGrids;

type
  TfmeReceiptEntry = class(TFrame)
    bsSkinGroupBox1: TbsSkinGroupBox;
    bsSkinLabel1: TbsSkinLabel;
    bsSkinLabel2: TbsSkinLabel;
    bsSkinLabel3: TbsSkinLabel;
    bsSkinMonthCalendar1: TbsSkinMonthCalendar;
    bsSkinGroupBox2: TbsSkinGroupBox;
    bsSkinStringGrid1: TbsSkinStringGrid;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

end.
