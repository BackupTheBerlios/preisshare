unit CommunityMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, GTDBizLinks, WSocket, WSocketS, ComCtrls, GTDBizDocs, CustomerLinks;

type
  TForm1 = class(TForm)
	GTDDocumentRegistry1: GTDDocumentRegistry;
	gtdLANPoint1: gtdLANPoint;
	GTDLANServerPoint1: GTDLANServerPoint;
	Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
	{ Private declarations }
	chttplink : TCustomerHTTPListener;
	clink : TCustomerTCPListener;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
begin
	clink := TCustomerTCPListener(Form1);
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
	clink.StartCommunityServer;
end;

end.
