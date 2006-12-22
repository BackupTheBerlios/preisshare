object plMailDropPanel: TplMailDropPanel
  Left = 0
  Top = 0
  Width = 421
  Height = 243
  TabOrder = 0
  object pnlHolder: TbsSkinPanel
    Left = 0
    Top = 0
    Width = 418
    Height = 240
    TabOrder = 0
    SkinDataName = 'panel'
    DefaultFont.Charset = DEFAULT_CHARSET
    DefaultFont.Color = clWindowText
    DefaultFont.Height = 14
    DefaultFont.Name = 'Arial'
    DefaultFont.Style = []
    DefaultWidth = 0
    DefaultHeight = 0
    UseSkinFont = True
    RealHeight = -1
    AutoEnabledControls = True
    CheckedMode = False
    Checked = False
    DefaultAlignment = taLeftJustify
    DefaultCaptionHeight = 22
    BorderStyle = bvFrame
    CaptionMode = False
    RollUpMode = False
    RollUpState = False
    NumGlyphs = 1
    Spacing = 2
    Caption = 'pnlHolder'
    object bsSkinStdLabel1: TbsSkinStdLabel
      Left = 8
      Top = 192
      Width = 69
      Height = 13
      UseSkinFont = True
      DefaultFont.Charset = DEFAULT_CHARSET
      DefaultFont.Color = clWindowText
      DefaultFont.Height = -11
      DefaultFont.Name = 'MS Sans Serif'
      DefaultFont.Style = []
      SkinDataName = 'stdlabel'
      Caption = 'Time Running:'
    end
    object bsSkinSpeedButton1: TbsSkinSpeedButton
      Left = 304
      Top = 12
      Width = 89
      Height = 25
      SkinDataName = 'toolbutton'
      DefaultFont.Charset = DEFAULT_CHARSET
      DefaultFont.Color = clWindowText
      DefaultFont.Height = 14
      DefaultFont.Name = 'Arial'
      DefaultFont.Style = []
      DefaultWidth = 0
      DefaultHeight = 0
      UseSkinFont = True
      WidthWithCaption = 0
      WidthWithoutCaption = 0
      ImageIndex = 0
      RepeatMode = False
      RepeatInterval = 100
      Transparent = False
      Flat = False
      AllowAllUp = False
      Down = False
      GroupIndex = 0
      Caption = 'Check Now'
      ShowCaption = True
      NumGlyphs = 1
      Spacing = 1
      OnClick = bsSkinSpeedButton1Click
    end
    object bsSkinSpeedButton2: TbsSkinSpeedButton
      Left = 304
      Top = 44
      Width = 89
      Height = 25
      SkinDataName = 'toolbutton'
      DefaultFont.Charset = DEFAULT_CHARSET
      DefaultFont.Color = clWindowText
      DefaultFont.Height = 14
      DefaultFont.Name = 'Arial'
      DefaultFont.Style = []
      DefaultWidth = 0
      DefaultHeight = 0
      UseSkinFont = True
      WidthWithCaption = 0
      WidthWithoutCaption = 0
      ImageIndex = 0
      RepeatMode = False
      RepeatInterval = 100
      Transparent = False
      Flat = False
      AllowAllUp = False
      Down = False
      GroupIndex = 0
      Caption = 'Review Changes'
      ShowCaption = True
      NumGlyphs = 1
      Spacing = 1
    end
    object bsSkinListView1: TbsSkinListView
      Left = 8
      Top = 32
      Width = 289
      Height = 150
      Columns = <
        item
          Caption = 'Last Updated'
          Width = 90
        end
        item
          Caption = 'Supplier'
          Width = 90
        end
        item
          Caption = 'Status'
          Width = 90
        end>
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = 14
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      ViewStyle = vsReport
      HeaderSkinDataName = 'resizebutton'
      DefaultFont.Charset = DEFAULT_CHARSET
      DefaultFont.Color = clWindowText
      DefaultFont.Height = 14
      DefaultFont.Name = 'Arial'
      DefaultFont.Style = []
      UseSkinFont = True
      SkinDataName = 'listview'
      DefaultColor = clWindow
    end
    object bsSkinLabel1: TbsSkinLabel
      Left = 8
      Top = 12
      Width = 289
      Height = 21
      TabOrder = 1
      SkinDataName = 'label'
      DefaultFont.Charset = DEFAULT_CHARSET
      DefaultFont.Color = clWindowText
      DefaultFont.Height = 14
      DefaultFont.Name = 'Arial'
      DefaultFont.Style = []
      DefaultWidth = 0
      DefaultHeight = 0
      UseSkinFont = True
      BorderStyle = bvFrame
      Caption = 'Mail Drop'
      AutoSize = False
    end
  end
  object Pop3Cli1: TPop3Cli
    Tag = 0
    LocalAddr = '0.0.0.0'
    Port = 'pop3'
    MsgLines = 0
    MsgNum = 0
    OnDisplay = Pop3Cli1Display
    Left = 308
    Top = 76
  end
  object MbxHandler1: TMbxHandler
    Active = False
    Left = 340
    Top = 76
  end
  object IdPOP31: TIdPOP3
    MaxLineAction = maException
    Left = 308
    Top = 108
  end
  object IdDecoderMIME1: TIdDecoderMIME
    FillChar = '='
    Left = 328
    Top = 164
  end
end
