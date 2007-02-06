object frmLogView: TfrmLogView
  Left = 200
  Top = 114
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Log'
  ClientHeight = 385
  ClientWidth = 545
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object bsSkinDBGrid1: TbsSkinDBGrid
    Left = 8
    Top = 16
    Width = 505
    Height = 241
    TabOrder = 0
    SkinData = frmMain.bsSkinData1
    SkinDataName = 'grid'
    UseSkinFont = True
    UseSkinCellHeight = True
    VScrollBar = bsSkinScrollBar1
    GridLineColor = clWindowText
    DefaultCellHeight = 20
    UseColumnsFont = False
    DefaultRowHeight = 17
    MouseWheelSupport = False
    SaveMultiSelection = False
    PickListBoxSkinDataName = 'listbox'
    PickListBoxCaptionMode = False
    DataSource = DataSource1
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
  end
  object bsSkinButton1: TbsSkinButton
    Left = 456
    Top = 344
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
    Caption = 'Ok'
    NumGlyphs = 1
    Spacing = 1
    OnClick = bsSkinButton1Click
  end
  object bsSkinDBMemo1: TbsSkinDBMemo
    Left = 8
    Top = 264
    Width = 337
    Height = 105
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = 14
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      'bsSkinDBMemo1')
    ParentFont = False
    TabOrder = 2
    DefaultFont.Charset = DEFAULT_CHARSET
    DefaultFont.Color = clWindowText
    DefaultFont.Height = 14
    DefaultFont.Name = 'Arial'
    DefaultFont.Style = []
    UseSkinFont = True
    BitMapBG = False
    SkinData = frmMain.bsSkinData1
    SkinDataName = 'memo'
    DataField = 'Audit_Log'
    DataSource = DataSource1
  end
  object bsSkinScrollBar1: TbsSkinScrollBar
    Left = 512
    Top = 16
    Width = 19
    Height = 241
    TabOrder = 3
    Visible = False
    SkinData = frmMain.bsSkinData1
    SkinDataName = 'vscrollbar'
    DefaultFont.Charset = DEFAULT_CHARSET
    DefaultFont.Color = clWindowText
    DefaultFont.Height = 14
    DefaultFont.Name = 'Arial'
    DefaultFont.Style = []
    DefaultWidth = 19
    DefaultHeight = 0
    UseSkinFont = True
    Both = False
    BothMarkerWidth = 19
    BothSkinDataName = 'bothhscrollbar'
    CanFocused = False
    Kind = sbVertical
    PageSize = 0
    Min = 0
    Max = 100
    Position = 0
    SmallChange = 1
    LargeChange = 1
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
    Left = 464
    Top = 16
  end
  object qryFindRecords: TQuery
    SQL.Strings = (
      'select'
      #9'A.Local_Timestamp,'
      #9'T.Name,'
      #9'A.Audit_Code,'
      #9'A.Audit_Description,'
      #9'A.Audit_Log'
      ''
      'from'
      #9'Trader_AuditTrail A,'
      #9'Trader T'
      'where'
      #9'(Trader_AuditTrail.Trader_ID = Trader.Trader_ID)'
      'order by'
      #9'Trader_AuditTrail.Local_Timestamp desc')
    Left = 400
    Top = 16
    object qryFindRecordsLocal_Timestamp: TDateTimeField
      FieldName = 'Local_Timestamp'
      Origin = 'PREISSHARE."Trader_AuditTrail.DB".Local_TimeStamp'
    end
    object qryFindRecordsName: TStringField
      DisplayWidth = 30
      FieldName = 'Name'
      Origin = 'PREISSHARE."Trader.DB".Name'
      Size = 50
    end
    object qryFindRecordsAudit_Code: TStringField
      FieldName = 'Audit_Code'
      Origin = 'PREISSHARE."Trader_AuditTrail.DB".Audit_Code'
      Visible = False
      Size = 15
    end
    object qryFindRecordsAudit_Description: TStringField
      FieldName = 'Audit_Description'
      Origin = 'PREISSHARE."Trader_AuditTrail.DB".Audit_Description'
      Size = 80
    end
    object qryFindRecordsAudit_Log: TMemoField
      FieldName = 'Audit_Log'
      Origin = 'PREISSHARE."Trader_AuditTrail.DB".Audit_Log'
      Visible = False
      BlobType = ftMemo
      Size = 100
    end
  end
  object DataSource1: TDataSource
    DataSet = qryFindRecords
    Left = 432
    Top = 16
  end
end
