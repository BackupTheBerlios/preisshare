object PriceChangeDisplay: TPriceChangeDisplay
  Left = 0
  Top = 0
  Width = 617
  Height = 273
  TabOrder = 0
  object bsSkinSpeedButton1: TbsSkinSpeedButton
    Left = 536
    Top = 16
    Width = 65
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
    Caption = 'Report'
    ShowCaption = True
    NumGlyphs = 1
    Spacing = 1
  end
  object z: TbsSkinTreeView
    Left = 8
    Top = 16
    Width = 141
    Height = 77
    Items.Data = {
      04000000270000000000000000000000FFFFFFFFFFFFFFFF0000000000000000
      0E4368616E67656420507269636573280000000000000000000000FFFFFFFFFF
      FFFFFF00000000000000000F4368616E6765642044657461696C732200000000
      00000000000000FFFFFFFFFFFFFFFF0000000000000000094E6577204974656D
      73210000000000000000000000FFFFFFFFFFFFFFFF0000000000000000084F62
      736F6C657465}
    DefaultFont.Charset = DEFAULT_CHARSET
    DefaultFont.Color = clWindowText
    DefaultFont.Height = 14
    DefaultFont.Name = 'Arial'
    DefaultFont.Style = []
    UseSkinFont = True
    SkinDataName = 'treeview'
    DefaultColor = clWindow
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = 14
    Font.Name = 'Arial'
    Font.Style = []
    Indent = 19
    ParentFont = False
    TabOrder = 0
  end
  object bsSkinListView1: TbsSkinListView
    Left = 160
    Top = 16
    Width = 369
    Height = 209
    Columns = <
      item
        Caption = 'Product ID'
        Width = 80
      end
      item
        Caption = 'Description'
        Width = 180
      end
      item
        Caption = 'Price'
        Width = 80
      end>
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = 14
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
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
end
