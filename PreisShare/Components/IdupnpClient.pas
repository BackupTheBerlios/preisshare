unit IdupnpClient;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  IdBaseComponent, IdComponent, IdUDPBase, IdUDPClient;

type
  TIdupnpClient = class(TIdUDPClient)
  private
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
  published
    { Published declarations }
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Tradalogs', [TIdupnpClient]);
end;

end.
