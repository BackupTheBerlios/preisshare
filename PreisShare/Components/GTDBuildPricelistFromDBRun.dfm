object BuildPricelistFromDBRun: TBuildPricelistFromDBRun
  Left = 0
  Top = 0
  Width = 396
  Height = 445
  TabOrder = 0
  object bsSkinStdLabel2: TbsSkinStdLabel
    Left = 116
    Top = 44
    Width = 80
    Height = 13
    UseSkinFont = True
    DefaultFont.Charset = DEFAULT_CHARSET
    DefaultFont.Color = clWindowText
    DefaultFont.Height = -11
    DefaultFont.Name = 'MS Sans Serif'
    DefaultFont.Style = []
    SkinDataName = 'stdlabel'
    Caption = 'bsSkinStdLabel2'
  end
  object bsSkinSpeedButton1: TbsSkinSpeedButton
    Left = 124
    Top = 176
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
    Caption = 'Cancel'
    ShowCaption = True
    NumGlyphs = 1
    Spacing = 1
    OnClick = bsSkinSpeedButton1Click
  end
  object pnlBackground: TbsSkinPanel
    Left = 0
    Top = 0
    Width = 396
    Height = 445
    TabOrder = 1
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
    BorderStyle = bvNone
    CaptionMode = False
    RollUpMode = False
    RollUpState = False
    NumGlyphs = 1
    Spacing = 2
    Caption = 'pnlBackground'
    Align = alClient
    object lblHeading: TbsSkinStdLabel
      Left = 32
      Top = 24
      Width = 301
      Height = 13
      UseSkinFont = True
      DefaultFont.Charset = DEFAULT_CHARSET
      DefaultFont.Color = clWindowText
      DefaultFont.Height = -11
      DefaultFont.Name = 'MS Sans Serif'
      DefaultFont.Style = []
      SkinDataName = 'stdlabel'
      Alignment = taCenter
      AutoSize = False
      Caption = 'lblHeading'
    end
    object lblDescription: TbsSkinStdLabel
      Left = 32
      Top = 44
      Width = 297
      Height = 13
      UseSkinFont = True
      DefaultFont.Charset = DEFAULT_CHARSET
      DefaultFont.Color = clWindowText
      DefaultFont.Height = -11
      DefaultFont.Name = 'MS Sans Serif'
      DefaultFont.Style = []
      SkinDataName = 'stdlabel'
      Alignment = taCenter
      AutoSize = False
      Caption = 'lblDescription'
    end
    object bsSkinButton1: TbsSkinButton
      Left = 144
      Top = 116
      Width = 75
      Height = 25
      TabOrder = 0
      SkinDataName = 'button'
      DefaultFont.Charset = DEFAULT_CHARSET
      DefaultFont.Color = clWindowText
      DefaultFont.Height = 14
      DefaultFont.Name = 'Arial'
      DefaultFont.Style = []
      DefaultWidth = 0
      DefaultHeight = 0
      UseSkinFont = True
      RepeatMode = False
      RepeatInterval = 100
      AllowAllUp = False
      TabStop = True
      CanFocused = True
      Down = False
      GroupIndex = 0
      Caption = 'Start'
      NumGlyphs = 1
      Spacing = 1
      Cancel = True
      OnClick = bsSkinButton1Click
    end
    object mmoOutput: TbsSkinMemo2
      Left = 8
      Top = 188
      Width = 381
      Height = 233
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = 14
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ScrollBars = ssBoth
      TabOrder = 1
      WordWrap = False
      DefaultFont.Charset = DEFAULT_CHARSET
      DefaultFont.Color = clWindowText
      DefaultFont.Height = 14
      DefaultFont.Name = 'Arial'
      DefaultFont.Style = []
      UseSkinFont = True
      SkinDataName = 'memo'
    end
    object btnShowPricelist: TbsSkinCheckRadioBox
      Left = 8
      Top = 160
      Width = 150
      Height = 25
      TabOrder = 2
      SkinDataName = 'checkbox'
      DefaultFont.Charset = DEFAULT_CHARSET
      DefaultFont.Color = clWindowText
      DefaultFont.Height = 14
      DefaultFont.Name = 'Arial'
      DefaultFont.Style = []
      DefaultWidth = 0
      DefaultHeight = 0
      UseSkinFont = True
      ImageIndex = 0
      Flat = True
      TabStop = True
      CanFocused = True
      Radio = False
      Checked = True
      GroupIndex = 0
      Caption = 'Show Pricelist'
    end
  end
  object ggeProgress: TbsSkinGauge
    Left = 32
    Top = 72
    Width = 297
    Height = 20
    TabOrder = 0
    Visible = False
    SkinDataName = 'gauge'
    DefaultFont.Charset = DEFAULT_CHARSET
    DefaultFont.Color = clWindowText
    DefaultFont.Height = 14
    DefaultFont.Name = 'Arial'
    DefaultFont.Style = []
    DefaultWidth = 0
    DefaultHeight = 0
    UseSkinFont = True
    UseSkinSize = True
    ShowProgressText = False
    ShowPercent = False
    MinValue = 0
    MaxValue = 100
    Value = 50
    Vertical = False
  end
  object ADOConnection1: TADOConnection
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=D:\PreisShare\Utili' +
      'ties\_cmd_buildplfromdb\TestData;Extended Properties=dBASE IV;Us' +
      'er ID=Admin;Password='
    LoginPrompt = False
    Mode = cmShareDenyNone
    Provider = 'Microsoft.Jet.OLEDB.4.0'
    Left = 184
    Top = 4
  end
  object qryGetItems: TADOQuery
    Connection = ADOConnection1
    Parameters = <>
    Left = 216
    Top = 4
  end
  object dlgSelectProfile: TbsSkinSelectValueDialog
    AlphaBlend = True
    AlphaBlendValue = 255
    AlphaBlendAnimation = True
    ButtonSkinDataName = 'button'
    LabelSkinDataName = 'stdlabel'
    ComboboxSkinDataName = 'combobox'
    DefaultValue = -1
    DefaultLabelFont.Charset = DEFAULT_CHARSET
    DefaultLabelFont.Color = clWindowText
    DefaultLabelFont.Height = 14
    DefaultLabelFont.Name = 'Arial'
    DefaultLabelFont.Style = []
    DefaultButtonFont.Charset = DEFAULT_CHARSET
    DefaultButtonFont.Color = clWindowText
    DefaultButtonFont.Height = 14
    DefaultButtonFont.Name = 'Arial'
    DefaultButtonFont.Style = []
    DefaultComboBoxFont.Charset = DEFAULT_CHARSET
    DefaultComboBoxFont.Color = clWindowText
    DefaultComboBoxFont.Height = 14
    DefaultComboBoxFont.Name = 'Arial'
    DefaultComboBoxFont.Style = []
    UseSkinFont = True
    Left = 256
    Top = 4
  end
end
