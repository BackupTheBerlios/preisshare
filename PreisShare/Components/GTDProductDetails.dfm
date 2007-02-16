object ProductDetails: TProductDetails
  Left = 0
  Top = 0
  Width = 519
  Height = 303
  TabOrder = 0
  object nbkProductInfo: TbsSkinPageControl
    Left = 0
    Top = 0
    Width = 519
    Height = 303
    ActivePage = bsSkinTabSheet1
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBtnText
    Font.Height = 14
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    DefaultFont.Charset = DEFAULT_CHARSET
    DefaultFont.Color = clBtnText
    DefaultFont.Height = 14
    DefaultFont.Name = 'Arial'
    DefaultFont.Style = []
    UseSkinFont = True
    DefaultItemHeight = 20
    SkinDataName = 'tab'
    object bsSkinTabSheet1: TbsSkinTabSheet
      Caption = 'Basic Details'
      object dbeProductCode: TbsSkinDBEdit
        Left = 8
        Top = 33
        Width = 121
        Height = 20
        Text = 'dbeProductCode'
        DefaultFont.Charset = DEFAULT_CHARSET
        DefaultFont.Color = clWindowText
        DefaultFont.Height = 14
        DefaultFont.Name = 'Arial'
        DefaultFont.Style = []
        UseSkinFont = True
        DefaultWidth = 0
        DefaultHeight = 20
        ButtonMode = False
        SkinDataName = 'edit'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = 14
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        AutoSize = False
        DataSource = dsProductInfo
      end
      object dbeProductName: TbsSkinDBEdit
        Left = 8
        Top = 81
        Width = 257
        Height = 20
        Text = 'dbeProductName'
        DefaultFont.Charset = DEFAULT_CHARSET
        DefaultFont.Color = clWindowText
        DefaultFont.Height = 14
        DefaultFont.Name = 'Arial'
        DefaultFont.Style = []
        UseSkinFont = True
        DefaultWidth = 0
        DefaultHeight = 20
        ButtonMode = False
        SkinDataName = 'edit'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = 14
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        AutoSize = False
        DataSource = dsProductInfo
      end
      object dbeCostPrice: TbsSkinDBEdit
        Left = 8
        Top = 249
        Width = 97
        Height = 20
        Text = 'dbeCostPrice'
        DefaultFont.Charset = DEFAULT_CHARSET
        DefaultFont.Color = clWindowText
        DefaultFont.Height = 14
        DefaultFont.Name = 'Arial'
        DefaultFont.Style = []
        UseSkinFont = True
        DefaultWidth = 0
        DefaultHeight = 20
        ButtonMode = False
        SkinDataName = 'edit'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = 14
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        AutoSize = False
        DataSource = dsProductInfo
      end
      object dbeSellPrice: TbsSkinDBEdit
        Left = 120
        Top = 249
        Width = 113
        Height = 20
        Text = 'dbeSellPrice'
        DefaultFont.Charset = DEFAULT_CHARSET
        DefaultFont.Color = clWindowText
        DefaultFont.Height = 14
        DefaultFont.Name = 'Arial'
        DefaultFont.Style = []
        UseSkinFont = True
        DefaultWidth = 0
        DefaultHeight = 20
        ButtonMode = False
        SkinDataName = 'edit'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = 14
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
        AutoSize = False
        DataSource = dsProductInfo
      end
      object lblProductCode: TbsSkinLabel
        Left = 8
        Top = 16
        Width = 121
        Height = 17
        TabOrder = 4
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
        Caption = 'Product Code'
        AutoSize = False
      end
      object lblProductName: TbsSkinLabel
        Left = 8
        Top = 64
        Width = 257
        Height = 17
        TabOrder = 5
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
        Caption = 'Product Name'
        AutoSize = False
      end
      object dbeProductDescription: TbsSkinDBMemo2
        Left = 8
        Top = 131
        Width = 257
        Height = 97
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = 14
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          'bsSkinDBMemo21')
        ParentFont = False
        ScrollBars = ssBoth
        TabOrder = 6
        DefaultFont.Charset = DEFAULT_CHARSET
        DefaultFont.Color = clWindowText
        DefaultFont.Height = 14
        DefaultFont.Name = 'Arial'
        DefaultFont.Style = []
        UseSkinFont = True
        SkinDataName = 'memo'
        DataSource = dsProductInfo
      end
      object lblDescription: TbsSkinLabel
        Left = 8
        Top = 112
        Width = 257
        Height = 17
        TabOrder = 7
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
        Caption = 'Description'
        AutoSize = False
      end
      object lblPicture: TbsSkinLabel
        Left = 280
        Top = 64
        Width = 225
        Height = 17
        TabOrder = 8
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
        Caption = 'Picture'
        PopupMenu = mnuPictureOptions
        AutoSize = False
        OnClick = lblPictureClick
      end
      object lblCostPrice: TbsSkinLabel
        Left = 8
        Top = 232
        Width = 97
        Height = 17
        TabOrder = 9
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
        Caption = 'Cost Price'
        AutoSize = False
      end
      object lblSellPrice: TbsSkinLabel
        Left = 120
        Top = 232
        Width = 113
        Height = 17
        TabOrder = 10
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
        Caption = 'Sell Price'
        AutoSize = False
      end
      object lblBrand: TbsSkinLabel
        Left = 240
        Top = 232
        Width = 121
        Height = 17
        TabOrder = 11
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
        Caption = 'Brand'
        AutoSize = False
      end
      object dbeBrand: TbsSkinDBEdit
        Left = 240
        Top = 249
        Width = 121
        Height = 20
        Text = 'dbeBrand'
        DefaultFont.Charset = DEFAULT_CHARSET
        DefaultFont.Color = clWindowText
        DefaultFont.Height = 14
        DefaultFont.Name = 'Arial'
        DefaultFont.Style = []
        UseSkinFont = True
        DefaultWidth = 0
        DefaultHeight = 20
        ButtonMode = False
        SkinDataName = 'edit'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = 14
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 12
        AutoSize = False
        DataSource = dsProductInfo
      end
      object lblModel: TbsSkinLabel
        Left = 376
        Top = 232
        Width = 129
        Height = 17
        TabOrder = 13
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
        Caption = 'Model'
        AutoSize = False
      end
      object dbeModel: TbsSkinDBEdit
        Left = 376
        Top = 249
        Width = 129
        Height = 20
        Text = 'dbeModel'
        DefaultFont.Charset = DEFAULT_CHARSET
        DefaultFont.Color = clWindowText
        DefaultFont.Height = 14
        DefaultFont.Name = 'Arial'
        DefaultFont.Style = []
        UseSkinFont = True
        DefaultWidth = 0
        DefaultHeight = 20
        ButtonMode = False
        SkinDataName = 'edit'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = 14
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 14
        AutoSize = False
        DataSource = dsProductInfo
      end
      object pnlPicture: TbsSkinPanel
        Left = 280
        Top = 80
        Width = 225
        Height = 145
        TabOrder = 15
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
        Caption = 'pnlPicture'
        PopupMenu = mnuPictureOptions
        object bsSkinStdLabel1: TbsSkinStdLabel
          Left = 96
          Top = 64
          Width = 32
          Height = 13
          UseSkinFont = True
          DefaultFont.Charset = DEFAULT_CHARSET
          DefaultFont.Color = clWindowText
          DefaultFont.Height = -11
          DefaultFont.Name = 'MS Sans Serif'
          DefaultFont.Style = []
          SkinDataName = 'stdlabel'
          Caption = '(None)'
        end
      end
    end
  end
  object dsProductInfo: TDataSource
    Left = 176
    Top = 48
  end
  object bsSkinPopupMenu1: TbsSkinPopupMenu
    Left = 280
    Top = 32
    object ProductWebsite1: TMenuItem
      Caption = 'Product Website'
    end
    object ManufacturersWebsite1: TMenuItem
      Caption = 'Manufacturers Website'
    end
  end
  object mnuPictureOptions: TbsSkinPopupMenu
    Left = 336
    Top = 32
    object ClearPicture1: TMenuItem
      Caption = 'Clear Picture'
    end
    object Copy1: TMenuItem
      Caption = 'Copy'
    end
    object Paste1: TMenuItem
      Caption = 'Paste'
    end
    object LoadfromFile1: TMenuItem
      Caption = 'Load from File'
    end
    object SavetoFile1: TMenuItem
      Caption = 'Save to File'
    end
  end
  object bsSkinPopupMenu2: TbsSkinPopupMenu
    Left = 232
    Top = 40
    object One1: TMenuItem
      Caption = 'One'
    end
    object wo1: TMenuItem
      Caption = 'Two'
    end
  end
end
