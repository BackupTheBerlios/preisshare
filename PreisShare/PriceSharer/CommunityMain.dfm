object Form1: TForm1
  Left = 192
  Top = 114
  Width = 696
  Height = 480
  Caption = 'ComputerGrid Community Connection Manager'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object GTDDocumentRegistry1: GTDDocumentRegistry
    Left = 12
    Top = 8
    Width = 250
    Height = 150
    Columns = <>
    TabOrder = 0
    DatabaseName = 'COMPUTERGRID'
    SessionName = 'Default'
    Trader_ID = 0
  end
  object Button1: TButton
    Left = 268
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Listen'
    TabOrder = 1
    OnClick = Button1Click
  end
  object gtdLANPoint1: gtdLANPoint
    Left = 156
    Top = 284
  end
  object GTDLANServerPoint1: GTDLANServerPoint
    LineMode = False
    LineLimit = 65536
    LineEnd = #13#10
    LineEcho = False
    LineEdit = False
    Proto = 'tcp'
    LocalAddr = '0.0.0.0'
    LocalPort = '0'
    MultiThreaded = False
    MultiCast = False
    MultiCastIpTTL = 1
    ReuseAddr = False
    ComponentOptions = []
    FlushTimeout = 60
    SendFlags = wsSendNormal
    LingerOnOff = wsLingerOn
    LingerTimeout = 0
    SocksLevel = '5'
    SocksAuthentication = socksNoAuthentication
    Banner = 'Welcome to TcpSrv'
    BannerToBusy = 'Sorry, too many clients'
    MaxClients = 0
    Left = 148
    Top = 228
  end
end
