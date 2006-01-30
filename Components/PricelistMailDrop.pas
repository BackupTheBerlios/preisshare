unit PricelistMailDrop;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  bsSkinCtrls, ComCtrls, StdCtrls, MbxFile, Pop3Prot, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, IdMessageClient, IdPOP3, bsSkinData,
  IdCoder, IdCoder3to4, IdCoderMIME;

type
  TplMailDropPanel = class(TFrame)
    Pop3Cli1: TPop3Cli;
    MbxHandler1: TMbxHandler;
    IdPOP31: TIdPOP3;
    pnlHolder: TbsSkinPanel;
    bsSkinStdLabel1: TbsSkinStdLabel;
    bsSkinListView1: TbsSkinListView;
    bsSkinLabel1: TbsSkinLabel;
    bsSkinSpeedButton1: TbsSkinSpeedButton;
    bsSkinSpeedButton2: TbsSkinSpeedButton;
    IdDecoderMIME1: TIdDecoderMIME;
    procedure Pop3Cli1Display(Sender: TObject; Msg: String);
    procedure bsSkinSpeedButton1Click(Sender: TObject);
  private
    { Private declarations }
    fMailHost,
    fUserName,
    fPasswd : String;
	fSkinData: TbsSkinData;

    procedure SetSkinData(Value: TbsSkinData);

  public
    { Public declarations }
  published
    property MailHost : String read fMailHost write fMailHost;
    property UserName : String read fUserName write fUserName;
    property Password : String read fPasswd write fPasswd;

	property SkinData: TbsSkinData read fSkinData write SetSkinData;
  end;

implementation

{$R *.DFM}

procedure TplMailDropPanel.Pop3Cli1Display(Sender: TObject; Msg: String);
begin
    bsSkinStdLabel1.Caption := Msg;
end;

procedure TplMailDropPanel.bsSkinSpeedButton1Click(Sender: TObject);
begin
    Pop3Cli1.UserName := 'david.lyon@computergrid.net';
    Pop3Cli1.Password := 'thaimusic';
    Pop3Cli1.Host := 'mail.computergrid.net';
end;

procedure TplMailDropPanel.SetSkinData(Value: TbsSkinData);
begin
    pnlHolder.SkinData := Value;
    bsSkinListView1.SkinData := Value;
    bsSkinLabel1.SkinData := Value;
    bsSkinSpeedButton1.SkinData := Value;
    bsSkinSpeedButton2.SkinData := Value;
end;

end.
