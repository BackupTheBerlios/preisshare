object ProductdBSearch: TProductdBSearch
  Left = 0
  Top = 0
  Width = 570
  Height = 512
  TabOrder = 0
  object pnlHolder: TbsSkinGroupBox
    Left = 0
    Top = 0
    Width = 570
    Height = 512
    TabOrder = 0
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
    CaptionMode = False
    RollUpMode = False
    RollUpState = False
    NumGlyphs = 1
    Spacing = 2
    Caption = 'Search Box'
    Align = alClient
    object btnSearch: TbsSkinSpeedButton
      Left = 488
      Top = 116
      Width = 57
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
      Caption = 'Search'
      ShowCaption = True
      NumGlyphs = 1
      Spacing = 1
      OnClick = btnSearchClick
    end
    object lblItemsCount: TbsSkinStdLabel
      Left = 8
      Top = 484
      Width = 340
      Height = 13
      UseSkinFont = True
      DefaultFont.Charset = DEFAULT_CHARSET
      DefaultFont.Color = clWindowText
      DefaultFont.Height = -11
      DefaultFont.Name = 'MS Sans Serif'
      DefaultFont.Style = []
      SkinDataName = 'stdlabel'
      Caption = 
        'You currently have 0 Products from 0 Vendors in your Product Dat' +
        'abase'
    end
    object Label2: TLabel
      Left = 304
      Top = 60
      Width = 154
      Height = 16
      Caption = 'Product Database Search'
      Font.Charset = ANSI_CHARSET
      Font.Color = clGray
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold, fsItalic]
      ParentFont = False
      Transparent = True
      OnClick = Label2Click
    end
    object Label3: TLabel
      Left = 16
      Top = 26
      Width = 76
      Height = 32
      Alignment = taCenter
      Caption = 'Preis'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -27
      Font.Name = 'Verdana'
      Font.Style = [fsBold, fsItalic]
      ParentFont = False
      Transparent = True
    end
    object Label4: TLabel
      Left = 290
      Top = 26
      Width = 87
      Height = 32
      Caption = 'Share'
      Color = clWindow
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlue
      Font.Height = -27
      Font.Name = 'Verdana'
      Font.Style = [fsBold, fsItalic]
      ParentColor = False
      ParentFont = False
      Transparent = True
    end
    object Shape1: TShape
      Left = 44
      Top = 212
      Width = 65
      Height = 113
    end
    object btnBack: TbsSkinSpeedButton
      Left = 8
      Top = 476
      Width = 57
      Height = 25
      Visible = False
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
      Caption = '<< Back'
      ShowCaption = True
      NumGlyphs = 1
      Spacing = 1
      OnClick = btnBackClick
    end
    object btnTasks: TbsSkinMenuSpeedButton
      Left = 472
      Top = 476
      Width = 73
      Height = 25
      SkinDataName = 'toolmenubutton'
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
      Caption = 'Tasks..'
      ShowCaption = True
      NumGlyphs = 1
      Spacing = 1
      SkinPopupMenu = mnuMaintain
      TrackButtonMode = False
    end
    object txtSearchText: TbsSkinEdit
      Left = 8
      Top = 116
      Width = 457
      Height = 28
      DefaultFont.Charset = ANSI_CHARSET
      DefaultFont.Color = clWindowText
      DefaultFont.Height = -19
      DefaultFont.Name = 'Tahoma'
      DefaultFont.Style = []
      UseSkinFont = True
      DefaultWidth = 0
      DefaultHeight = 28
      ButtonMode = False
      SkinDataName = 'edit'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = []
      HideSelection = False
      ParentFont = False
      TabOrder = 0
      OnChange = txtSearchTextChange
      OnKeyPress = txtSearchTextKeyPress
    end
    object grdProducts: TbsSkinDBGrid
      Left = 8
      Top = 152
      Width = 537
      Height = 317
      TabOrder = 1
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
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
      PopupMenu = mnuProductOps
      ReadOnly = True
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
      OnDblClick = grdProductsDblClick
      Columns = <
        item
          Expanded = False
          FieldName = 'VendorProductID'
          Title.Caption = 'Product Code'
          Width = 101
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ProductName'
          Title.Caption = 'Product Name'
          Width = 260
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'OurBuyingPrice'
          Title.Caption = 'Unit Price'
          Width = 75
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'VendorSuggestedSellPrice'
          Title.Caption = 'Sell Price'
          Width = 77
          Visible = True
        end>
    end
    object bsSkinScrollBar1: TbsSkinScrollBar
      Left = 544
      Top = 152
      Width = 19
      Height = 317
      TabOrder = 2
      Visible = False
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
    object Memo1: TbsSkinMemo
      Left = 8
      Top = 380
      Width = 253
      Height = 57
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = 14
      Font.Name = 'Arial'
      Font.Style = []
      Lines.Strings = (
        'Memo1')
      ParentFont = False
      TabOrder = 3
      Visible = False
      DefaultFont.Charset = DEFAULT_CHARSET
      DefaultFont.Color = clWindowText
      DefaultFont.Height = 14
      DefaultFont.Name = 'Arial'
      DefaultFont.Style = []
      UseSkinFont = True
      BitMapBG = False
      SkinDataName = 'memo'
    end
    object bsSkinDBGrid1: TbsSkinDBGrid
      Left = 16
      Top = 8
      Width = 121
      Height = 100
      TabOrder = 4
      Visible = False
      SkinDataName = 'grid'
      UseSkinFont = True
      UseSkinCellHeight = True
      GridLineColor = clWindowText
      DefaultCellHeight = 20
      UseColumnsFont = False
      DefaultRowHeight = 17
      MouseWheelSupport = False
      SaveMultiSelection = False
      PickListBoxSkinDataName = 'listbox'
      PickListBoxCaptionMode = False
      DataSource = DataSource2
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
    end
    object bsSkinMemo1: TbsSkinMemo
      Left = 8
      Top = 444
      Width = 249
      Height = 37
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = 14
      Font.Name = 'Arial'
      Font.Style = []
      Lines.Strings = (
        'bsSkinMemo1')
      ParentFont = False
      TabOrder = 5
      Visible = False
      DefaultFont.Charset = DEFAULT_CHARSET
      DefaultFont.Color = clWindowText
      DefaultFont.Height = 14
      DefaultFont.Name = 'Arial'
      DefaultFont.Style = []
      UseSkinFont = True
      BitMapBG = False
      SkinDataName = 'memo'
    end
    object Chart1: TChart
      Left = 120
      Top = 216
      Width = 353
      Height = 185
      AllowPanning = pmNone
      AllowZoom = False
      BackWall.Brush.Color = clWhite
      BackWall.Brush.Style = bsClear
      BackWall.Color = 8404992
      BackWall.Pen.Visible = False
      Title.Text.Strings = (
        'Suppliers Product Database')
      OnClickSeries = Chart1ClickSeries
      AxisVisible = False
      BackColor = 8404992
      ClipPoints = False
      Frame.Visible = False
      View3DOptions.Elevation = 315
      View3DOptions.Orthogonal = False
      View3DOptions.Perspective = 0
      View3DOptions.Rotation = 360
      View3DWalls = False
      BevelOuter = bvLowered
      Color = 5318656
      TabOrder = 6
      object Series1: TPieSeries
        Marks.ArrowLength = 8
        Marks.Visible = True
        SeriesColor = clRed
        OtherSlice.Text = 'Other'
        PieValues.DateTime = False
        PieValues.Name = 'Pie'
        PieValues.Multiplier = 1.000000000000000000
        PieValues.Order = loNone
      end
    end
  end
  object DataSource1: TDataSource
    DataSet = qryFindProducts
    Left = 528
    Top = 88
  end
  object qryFindProducts: TADOQuery
    Parameters = <>
    Left = 496
    Top = 88
  end
  object qryCountStuff: TADOQuery
    Parameters = <>
    Left = 372
    Top = 92
  end
  object qryWordCheck: TADOQuery
    ParamCheck = False
    Parameters = <>
    Left = 496
    Top = 44
  end
  object DataSource2: TDataSource
    DataSet = qryWordCheck
    Left = 528
    Top = 44
  end
  object mnuProductOps: TbsSkinPopupMenu
    Left = 144
    Top = 8
    object AddToPricelist1: TMenuItem
      Caption = 'Add To Products we sell..'
      Enabled = False
    end
    object AddtoaCustomerQuote1: TMenuItem
      Caption = 'Add to a Customer Quote..'
      Enabled = False
    end
    object AddtoaCustomerInvoice1: TMenuItem
      Caption = 'Add to a Customer Invoice..'
      Enabled = False
    end
  end
  object mnuMaintain: TbsSkinPopupMenu
    Left = 144
    Top = 40
    object mnuUpdateSellPrices: TMenuItem
      Caption = 'Update Sell Prices by percentage..'
    end
    object mnuRemoveSupplier: TMenuItem
      Caption = 'Remove a Supplier from the Database..'
      OnClick = mnuRemoveSupplierClick
    end
    object mnuImport: TMenuItem
      Caption = 'Import a Price file..'
    end
    object ChangeView1: TMenuItem
      Caption = 'Search Screen Visualisation'
      Visible = False
      object ProductsbyVendorGraph1: TMenuItem
        Caption = 'Products by Vendor'
        Checked = True
        RadioItem = True
      end
      object ProductsbyBrandGraph1: TMenuItem
        Caption = 'Products by Brand'
        Enabled = False
        RadioItem = True
      end
      object NewProducts1: TMenuItem
        Caption = 'New Products'
        Enabled = False
        RadioItem = True
      end
    end
  end
  object dlgSelectValues: TbsSkinSelectValueDialog
    AlphaBlend = False
    AlphaBlendValue = 200
    AlphaBlendAnimation = False
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
    Left = 184
    Top = 72
  end
end
