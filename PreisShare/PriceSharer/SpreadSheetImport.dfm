object frmSpreadSheetImport: TfrmSpreadSheetImport
  Left = 201
  Top = 107
  AutoScroll = False
  BorderIcons = []
  Caption = 'Spreadsheet Data Import'
  ClientHeight = 514
  ClientWidth = 547
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object btnOk: TbsSkinButton
    Left = 360
    Top = 468
    Width = 75
    Height = 25
    TabOrder = 0
    Visible = False
    SkinData = frmMain.bsSkinData1
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
    Caption = 'Ok'
    NumGlyphs = 1
    Spacing = 1
    ModalResult = 1
  end
  object btnClose: TbsSkinButton
    Left = 444
    Top = 468
    Width = 75
    Height = 25
    TabOrder = 1
    SkinData = frmMain.bsSkinData1
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
    Caption = 'Close'
    NumGlyphs = 1
    Spacing = 1
    Cancel = True
    ModalResult = 2
  end
  object pnlNoOffice: TbsSkinGroupBox
    Left = 76
    Top = 44
    Width = 373
    Height = 261
    TabOrder = 2
    SkinData = frmMain.bsSkinData1
    SkinDataName = 'groupbox'
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
    CaptionMode = True
    RollUpMode = False
    RollUpState = False
    NumGlyphs = 1
    Spacing = 2
    Caption = 'Office not loaded'
    object bsSkinTextLabel1: TbsSkinTextLabel
      Left = 248
      Top = 96
      Width = 65
      Height = 65
      UseSkinFont = True
      DefaultFont.Charset = DEFAULT_CHARSET
      DefaultFont.Color = clWindowText
      DefaultFont.Height = -11
      DefaultFont.Name = 'MS Sans Serif'
      DefaultFont.Style = []
      SkinDataName = 'stdlabel'
    end
    object bsSkinTextLabel2: TbsSkinTextLabel
      Left = 32
      Top = 64
      Width = 308
      Height = 117
      UseSkinFont = True
      Lines.Strings = (
        'You are seeing this screen because a version of Microsoft Office'
        'isn'#39't currently installed on this computer.'
        ''
        
          'It therefore isn'#39't possible to import data out of Spreadsheets a' +
          't the'
        'moment.'
        ''
        'You can also check the preisshare.net website to see if a newer'
        'version of the software has corrected this problem.')
      DefaultFont.Charset = DEFAULT_CHARSET
      DefaultFont.Color = clWindowText
      DefaultFont.Height = -11
      DefaultFont.Name = 'MS Sans Serif'
      DefaultFont.Style = []
      SkinData = frmMain.bsSkinData1
      SkinDataName = 'stdlabel'
    end
  end
  object bsBusinessSkinForm1: TbsBusinessSkinForm
    ClientWidth = 0
    ClientHeight = 0
    HideCaptionButtons = False
    AlwaysShowInTray = False
    LogoBitMapTransparent = False
    AlwaysMinimizeToTray = False
    UseSkinFontInMenu = True
    ShowIcon = False
    MaximizeOnFullScreen = False
    AlphaBlend = False
    AlphaBlendAnimation = False
    AlphaBlendValue = 200
    ShowObjectHint = False
    MenusAlphaBlend = False
    MenusAlphaBlendAnimation = False
    MenusAlphaBlendValue = 200
    DefCaptionFont.Charset = DEFAULT_CHARSET
    DefCaptionFont.Color = clBtnText
    DefCaptionFont.Height = 14
    DefCaptionFont.Name = 'Arial'
    DefCaptionFont.Style = [fsBold]
    DefInActiveCaptionFont.Charset = DEFAULT_CHARSET
    DefInActiveCaptionFont.Color = clBtnShadow
    DefInActiveCaptionFont.Height = 14
    DefInActiveCaptionFont.Name = 'Arial'
    DefInActiveCaptionFont.Style = [fsBold]
    DefMenuItemHeight = 20
    DefMenuItemFont.Charset = DEFAULT_CHARSET
    DefMenuItemFont.Color = clWindowText
    DefMenuItemFont.Height = 14
    DefMenuItemFont.Name = 'Arial'
    DefMenuItemFont.Style = []
    UseDefaultSysMenu = True
    SkinData = frmMain.bsSkinData1
    MinHeight = 0
    MinWidth = 0
    Magnetic = False
    MagneticSize = 5
    BorderIcons = [biSystemMenu, biMinimize, biMaximize, biRollUp]
    Left = 356
    Top = 12
  end
end
