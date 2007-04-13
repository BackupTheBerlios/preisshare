object ProductDetails: TProductDetails
  Left = 0
  Top = 0
  Width = 519
  Height = 299
  TabOrder = 0
  object nbkProductInfo: TbsSkinPageControl
    Left = 0
    Top = 0
    Width = 519
    Height = 299
    ActivePage = tbsBasic
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBtnText
    Font.Height = 14
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnChanging = nbkProductInfoChanging
    DefaultFont.Charset = DEFAULT_CHARSET
    DefaultFont.Color = clBtnText
    DefaultFont.Height = 14
    DefaultFont.Name = 'Arial'
    DefaultFont.Style = []
    UseSkinFont = True
    DefaultItemHeight = 20
    SkinDataName = 'tab'
    object tbsBasic: TbsSkinTabSheet
      Caption = 'Basic Details'
      object bsSkinMenuSpeedButton1: TbsSkinMenuSpeedButton
        Left = 280
        Top = 64
        Width = 81
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
        Caption = 'Picture..'
        ShowCaption = True
        Glyph.Data = {
          36030000424D3603000000000000360000002800000010000000100000000100
          18000000000000030000130B0000130B00000000000000000000B1B5B3858A88
          858A88858A88858A88858A88858A88858A88858A88858A88858A88858A88858A
          88858A88858A88AFB1B1858A88FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF858A88858A88FFFFFF
          A46534A46534A46534A46534FAFBFBFAFBFBFCFCFDFDFCFCA46534A46534A465
          34A46534FFFFFF858A88858A88FFFFFFA46534A46534A46534F9FAFAF9F9F9F9
          FAF9FBFBFBFBFBFCFBFBFCA46534A46534A46534FFFFFF858A88858A88FFFFFF
          A46534A46636A76A3BAB7246F8F9F8F8F9F9FAFAFAFAFAFBAA7043A56737A465
          34A46534FFFFFF858A88858A88FFFFFFA46635F6F7F7AE774CB98B67C9A68BF7
          F8F8F9F9F9D1B59EBD916FAE764BF9FAFAA46534FFFFFF858A88858A88FFFFFF
          F5F6F6F4F6F6F6F6F7CAAA90DBC7B7E6DBD3EAE2DBE4D6CAD4BAA6F8F9F9F9FA
          FAF9F9F9FFFFFF858A88858A88FFFFFFF3F5F5F3F5F5F4F5F5F4F5F6E3D7CCF5
          F5F6F6F7F7EAE1D9F7F8F8F8F9F8F7F9F9F8F8F9FFFFFF858A88858A88FFFFFF
          EFF1F1F0F1F1F0F1F2F0F2F1DFD2C7F0F2F2F2F3F4E2D7CEF3F4F5F3F4F5F3F5
          F5F4F5F4FFFFFF858A88858A88FFFFFFEFF0F0EFF0F0EFF1F1CFB4A0D8C7B9E0
          D3C9E2D7CDDCCBBDCFB49FF2F4F4F3F4F3F2F4F4FFFFFF858A88858A88FFFFFF
          A46635EDEFEFB3825CC39F83CFB6A2EEF0F0F0F2F1CCB099C0987AB27F57F1F3
          F3A56737FFFFFF858A88858A88FFFFFFA46534A56736AA7043B4845FEEEFEFEE
          EFEFF0F1F1F0F1F1AE784EA96E40A56838A46534FFFFFF858A88858A88FFFFFF
          A46534A46534A56736ECEEEEECEEEEECEEEFEEF0F0EEF0F0EEF0F0A56736A465
          34A46534FFFFFF858A88858A88FFFFFFA46534A46534A46534A46534ECEEEEEC
          EEEEEEEFEFEDEFEFA46534A46534A46534A46534FFFFFF858A88858A88FFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFF858A88B6B9B8858A88858A88858A88858A88858A88858A8885
          8A88858A88858A88858A88858A88858A88858A88858A88B6B9B8}
        NumGlyphs = 1
        Spacing = 1
        SkinPopupMenu = mnuPictureOptions
        TrackButtonMode = False
      end
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
      object lblCostPrice: TbsSkinLabel
        Left = 8
        Top = 232
        Width = 97
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
        Caption = 'Cost Price'
        AutoSize = False
      end
      object lblSellPrice: TbsSkinLabel
        Left = 120
        Top = 232
        Width = 113
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
        Caption = 'Sell Price'
        AutoSize = False
      end
      object lblBrand: TbsSkinLabel
        Left = 240
        Top = 232
        Width = 121
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
        TabOrder = 11
        AutoSize = False
        DataSource = dsProductInfo
      end
      object lblModel: TbsSkinLabel
        Left = 216
        Top = 16
        Width = 129
        Height = 17
        TabOrder = 12
        Visible = False
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
        Left = 216
        Top = 33
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
        TabOrder = 13
        Visible = False
        AutoSize = False
        DataSource = dsProductInfo
      end
      object pnlPicture: TbsSkinPanel
        Left = 280
        Top = 88
        Width = 225
        Height = 141
        TabOrder = 14
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
      object rdoItemRelayStatus: TbsSkinRadioGroup
        Left = 376
        Top = 4
        Width = 129
        Height = 53
        TabOrder = 15
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
        Caption = 'Relayed'
        OnChecked = rdoItemRelayStatusChecked
        OnClick = rdoItemRelayStatusClick
        ButtonSkinDataName = 'radiobox'
        ButtonDefaultFont.Charset = DEFAULT_CHARSET
        ButtonDefaultFont.Color = clWindowText
        ButtonDefaultFont.Height = 14
        ButtonDefaultFont.Name = 'Arial'
        ButtonDefaultFont.Style = []
        Columns = 2
        ItemIndex = 0
        Items.Strings = (
          'No'
          'Yes')
      end
    end
    object tbsRelay: TbsSkinTabSheet
      Caption = 'Relay Options (Off)'
      object btnItemRelayUpdate: TbsSkinSpeedButton
        Left = 380
        Top = 244
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
        Caption = 'Update'
        ShowCaption = True
        NumGlyphs = 1
        Spacing = 1
      end
      object btnItemRelayCancel: TbsSkinSpeedButton
        Left = 448
        Top = 244
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
        Caption = 'Cancel'
        ShowCaption = True
        NumGlyphs = 1
        Spacing = 1
      end
      object lstItemRelayGroup: TbsSkinTreeView
        Left = 8
        Top = 24
        Width = 149
        Height = 249
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
        HideSelection = False
        Indent = 19
        ParentFont = False
        TabOrder = 0
      end
      object lblItemRelayGroup: TbsSkinLabel
        Left = 8
        Top = 8
        Width = 149
        Height = 18
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
        Caption = 'In Product Group'
        AutoSize = False
      end
      object nbkOurDetails: TbsSkinGroupBox
        Left = 168
        Top = 8
        Width = 337
        Height = 225
        TabOrder = 2
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
        Caption = 'Our Details'
        object lblOurProductCode: TbsSkinLabel
          Left = 8
          Top = 32
          Width = 121
          Height = 17
          TabOrder = 0
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
        object lblOurName: TbsSkinLabel
          Left = 8
          Top = 72
          Width = 313
          Height = 17
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
          Caption = 'Product Name'
          AutoSize = False
        end
        object lblOurDescription: TbsSkinLabel
          Left = 8
          Top = 120
          Width = 313
          Height = 17
          TabOrder = 2
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
        object txtOurProductCode: TbsSkinEdit
          Left = 8
          Top = 48
          Width = 121
          Height = 20
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
        end
        object txtOurName: TbsSkinEdit
          Left = 8
          Top = 88
          Width = 313
          Height = 20
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
          TabOrder = 4
        end
        object txtOurDescription: TbsSkinMemo
          Left = 8
          Top = 136
          Width = 313
          Height = 81
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = 14
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 5
          DefaultFont.Charset = DEFAULT_CHARSET
          DefaultFont.Color = clWindowText
          DefaultFont.Height = 14
          DefaultFont.Name = 'Arial'
          DefaultFont.Style = []
          UseSkinFont = True
          BitMapBG = False
          SkinDataName = 'memo'
        end
      end
    end
  end
  object dsProductInfo: TDataSource
    Left = 212
  end
  object bsSkinPopupMenu1: TbsSkinPopupMenu
    Left = 276
    object ProductWebsite1: TMenuItem
      Caption = 'Product Website'
    end
    object ManufacturersWebsite1: TMenuItem
      Caption = 'Manufacturers Website'
    end
  end
  object mnuPictureOptions: TbsSkinPopupMenu
    Images = ImageList1
    Left = 308
    object ClearPicture1: TMenuItem
      Caption = 'Clear Picture'
      ImageIndex = 0
      OnClick = ClearPicture1Click
    end
    object Paste1: TMenuItem
      Caption = 'Paste'
      ImageIndex = 1
      OnClick = Paste1Click
    end
    object Copy1: TMenuItem
      Caption = 'Copy'
      ImageIndex = 4
      OnClick = Copy1Click
    end
    object LoadfromFile1: TMenuItem
      Caption = 'Load from File'
      ImageIndex = 2
      OnClick = LoadfromFile1Click
    end
    object SavetoFile1: TMenuItem
      Caption = 'Save to File'
      ImageIndex = 3
      OnClick = SavetoFile1Click
    end
  end
  object bsSkinPopupMenu2: TbsSkinPopupMenu
    Left = 244
    object One1: TMenuItem
      Caption = 'One'
    end
    object wo1: TMenuItem
      Caption = 'Two'
    end
  end
  object dlgAddProductGroup: TbsSkinInputDialog
    AlphaBlend = False
    AlphaBlendValue = 200
    AlphaBlendAnimation = False
    ButtonSkinDataName = 'button'
    LabelSkinDataName = 'stdlabel'
    EditSkinDataName = 'edit'
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
    DefaultEditFont.Charset = DEFAULT_CHARSET
    DefaultEditFont.Color = clWindowText
    DefaultEditFont.Height = 14
    DefaultEditFont.Name = 'Arial'
    DefaultEditFont.Style = []
    UseSkinFont = True
    Left = 344
  end
  object ImageList1: TImageList
    Left = 376
    Bitmap = {
      494C010105000900040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000003000000001001000000000000018
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000D65A30463046
      3046304630463046304694521863000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000003146DE7BDE7B
      DE7B0000FF7F5A6B724E9C733046186300000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000003146FF7FDD7B
      DD7BDD7BFF7FFF7F724EFF7F9C73304693520000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000007B6F18631863186330460000DD7B
      DD7BDD7BDD7BFF7F724EFF7FFE7F9C7330460000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000001863FF7FFF7FFF7F31460000DD7B
      DD7BDD7BDD7BDD7B314631463146314630460000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000018630000DE7BDE7B31460000DD7B
      18631863186318631863BD77DE7B186330460000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000018630000DE7B9C7330460000DD7B
      DD7BDD7BDD7BDD7BDD7BDD7BFF7FDE7B30460000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000018630000DE7BDE7B31460000DD7B
      18631863186318631863DD7BDD7B000030460000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000018630000DE7B9C7330460000DD7B
      DD7BDD7BDD7BDD7BDD7BDD7BDD7B000030460000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000018630000FE7FDE7B31460000DD7B
      186318631863186318631863DD7B000030460000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000018630000FE7F9C7330460000DD7B
      DD7BDD7BDD7BDD7BDD7BDD7BDD7B000030460000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000018630000FE7FFE7F314600000000
      0000000000000000000000000000000030460000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000018630000FE7F9C73B55630463046
      30463046304630463046304630463046D65A0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000018630000FE7FDE7BDE7BDE7BDE7B
      DE7BFE7FFE7F0000186300000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000001863000000000000000000000000
      0000000000000000186300000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000007B6F186318631863186318631863
      18631863186318637B6F00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000DC7B
      42524252EC62DB7B000000000000000000000000D36242390035003500350035
      0035003500350035003500354239F46600000000000000000000000000000000
      0000000000000000000000000000000000000000CD35CD35CD35CD35CD35CD35
      CD35CD35CD35CD35CD35CD35CD35CD35000000000000000000000000DD7F6356
      0A6B4B73C6624252CA5EDD7B00000000000000002139E45DE751AC39AD35AD35
      AD35AD35AD35E751E751E751E459223900001436941994199419941994199419
      941994199419941994199419941914360000CD35FF7FFF7FFF7FFF7FFF7FFF7F
      FF7FFF7FFF7FFF7F0000FF7FFF7FFF7FCD3500000000000000000000A75AC762
      6B73246F49736D73C6626356BB7B00000000DD7B21390462AC39BD7700000000
      0000BD770000AC310462046204620035FE7F4A29B556BA467936793679367936
      793679327932593259325932FB4ED2297546CD35FF7FF65AF65AF65AF65AF65A
      F65AF65AF65AFF7F0000FF7FFF7FFF7FCD350000000000000000977364566D77
      026F006F006F026F4B732A6B425298730000DD7B21390462AC3100009C737A6F
      1763D65A00000000AC31046205620035FE7F4A291763D32DFB4E793A793A7936
      7936793679367936793679367936DB4A9419CD35BD77D556D556D556D556D556
      D556D556D556BD770000BD77BD77BD77CD350000000000000000855A2B6F6877
      43732273006F006F006F49732B6F4152DC7BDD7B21390462AC310000BC779C73
      7A6FF65E000000000000AC3105620035FE7F4A29396794191C57DA46DB46DA46
      BA46BA46BA42BA429A3E9A3A793AFB4E9419CD357B6F7B6F7B6F7B6F7B6F7B6F
      7B6F7B6F7B6F7B6F00007B6F7B6F7B6FCD35000000000000DC7B4356B17F877F
      867F657B44772273006F006F4A73C662CA62DD7B21390462AC310000BD77BD77
      BC773967F65EF65E0000AC3105620035FE7F4A29176394191C57DB46DB46DB46
      DB46DB46DB46DB46DB46DB46BA461C539419CD35945294529452945294529452
      94529452945294529452945294529452CD35000000000000346FC662B17FAB7F
      AC7FAA7F877F657B4373026F49734C734252DD7B21390462AC310000BD77BD77
      BD77BC777B6F39670000AC3105620035FE7F4A29396794197D635D5F5D5F5D5F
      5D5F5D5F5D5F5D5F5D5F5D5F5D5F7D639419CD35DE7B9C73BD77FF7FFF7F5967
      B11D911DB64EFF7FFF7FBD779C73DE7BCD3500000000000005590255B07FAD7F
      B07FAD7FAA7F887F8C7B6E770967845A4252DD7B21390462AC310000DD7BBD77
      BD77BD77BD777B6F0000AC3105620035FE7F4A291763F3319419941994199419
      94199419941994199419941994199419B321CD35FF7FBD77FF7F9C733763911D
      3C57FB4EB11D954A9C73FF7FBD77DE7BCD350000546F4252A65E255DE35C6C7B
      AC7FAD7FAF7FB17FE9664152CB6297730000DD7B21390462AC310000DD7BD65A
      D65AD65AD65ABD770000AC3105620035FE7F6A2D396794529452B4520000DE7B
      3967396739677A6FDE7BDE7B0000B4520000CD35FF7FFF7F9C733763911DFB4E
      783A783A3B57911D954A9C73DE7BDE7BCD350000546F4152296F6D77A6656154
      CC6A6E77E9664252EC62DC7B000000000000DD7B21390462AC310000DD7BDD7B
      DD7BDD7BBD77BD770000AC3105620035FE7F6B2D1763524A524AB4520000DE7B
      DE7BDE7BDE7BDE7BDE7BDE7B0000B4520000CD35FF7FBD773867911DFB4E773A
      773A773A783AFB4A911DB54ABD77DE7BCD3500000000CF62204EE8666E77A359
      2355855A316BDD7B00000000000000000000DD7B21390462AC310000DD7BD65A
      D65AD65AD65ABD770000AC3105620035FE7F6B2D396794529452B4520000DE7B
      39673967396739673967DE7B0000B4520000CD35FF7FBD77911D911D911D911D
      993E572E911D911D911D911DBD77DE7BCD3500004D5A4141C1592052A65E855A
      987300000000000000000000000000000000DD7B21392462AC310000DD7BDD7B
      DD7BDD7BDD7BDD7B0000AC3105620035FE7F8B311763524A524AB4520000DE7B
      DE7BDE7BDE7BDE7BDE7BDE7B0000B4520000CD39FF7FBD77BD779B6F763A911D
      993ED946B11DF856BD77BD77BD77DE7BCD35D2626145E15DE26161456656204E
      BA7700000000000000000000000000000000DD7B21392462AC39DE7B9C73F75E
      F75EF75EF75E9C73DE7BAC3504620035FE7FAC31396794529452B45200000000
      0000000000000000000000000000B4520000CD359B73FF7F9A6F5B677636911D
      3C57DA4AF3297C6BFF7FFF7FFF7FDE7BCD354241C159E261A155844500000F67
      DD7F00000000000000000000000000000000000021390462E751AC396B2DEF3D
      0F420F42EF3D6B2DAC35E851E45D22390000AD351763524A524A734EB452B452
      B452B452B452B452B452B452B45238670000D756CE31CE31B025D321F321FB4E
      7D63152AAF25CD35CD35CD35CD35CD3500006345A151A1554141376F00000000
      0000000000000000000000000000000000000000D3624239003500356B2D514A
      514A514A514A6B2D003500354239F4660000AD35396739673967396739673967
      18638C3118630000000000000000000000003A5F3B5B9D6B7D637D6B7D631B4F
      3436B121DD77FF7FFF7FFF7FFF7FFF7FFF7F587384456345376F000000000000
      0000000000000000000000000000000000000000000000000000000031466B2D
      6B2D6B2D6B2D314600000000000000000000B556AD35AD35AD35AD35AD35AC31
      AC31175F0000000000000000000000000000175FF952F956B74A132E911DB121
      F12DF756FF7FFF7FFF7FFF7FFF7FFF7FFF7F424D3E000000000000003E000000
      2800000040000000300000000100010000000000800100000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000F003000000000000F081000000000000
      F000000000000000040000000000000004000000000000004400000000000000
      4400000000000000440200000000000044020000000000004402000000000000
      440200000000000047FE0000000000004000000000000000402F000000000000
      7FEF000000000000000F000000000000FC1F8001FFFF8001F807800100010000
      F803074000000000F001086000000000F000087000000000E000081000000000
      E000081000000000E00008100000000080010810040500008007081004050000
      C01F08100405000080FF08100405000000FF000007FD000004FF800100010001
      07FF8001003F00000FFFF81F007F000000000000000000000000000000000000
      000000000000}
  end
  object dlgLoadPicture: TbsSkinOpenPictureDialog
    StretchPicture = False
    MultiSelection = False
    AlphaBlend = False
    AlphaBlendValue = 200
    AlphaBlendAnimation = False
    CtrlAlphaBlend = False
    CtrlAlphaBlendValue = 225
    CtrlAlphaBlendAnimation = False
    LVHeaderSkinDataName = 'resizebutton'
    DefaultFont.Charset = DEFAULT_CHARSET
    DefaultFont.Color = clWindowText
    DefaultFont.Height = 14
    DefaultFont.Name = 'Arial'
    DefaultFont.Style = []
    Title = 'Open picture'
    Filter = 
      'All (*.bmp;*.ico;*.emf;*.jpg)|*.bmp;*.ico;*.emf;*.wmf|Bitmaps (*' +
      '.bmp)|*.bmp|Icons (*.ico)|*.ico|Enhanced Metafiles (*.emf)|*.emf' +
      '|Jpeg Files (*.jpg)|*.jpg'
    FilterIndex = 1
    Left = 180
  end
  object dlgSavePicture: TbsSkinSavePictureDialog
    StretchPicture = False
    MultiSelection = False
    AlphaBlend = False
    AlphaBlendValue = 200
    AlphaBlendAnimation = False
    CtrlAlphaBlend = False
    CtrlAlphaBlendValue = 225
    CtrlAlphaBlendAnimation = False
    LVHeaderSkinDataName = 'resizebutton'
    DefaultFont.Charset = DEFAULT_CHARSET
    DefaultFont.Color = clWindowText
    DefaultFont.Height = 14
    DefaultFont.Name = 'Arial'
    DefaultFont.Style = []
    Title = 'Save file'
    Filter = 
      'All (*.bmp;*.jpg)|*.bmp;*.jpg|Bitmaps (*.bmp)|*.bmp|Jpeg (*.jpg)' +
      '|*.jpg'
    FilterIndex = 1
    Left = 180
    Top = 32
  end
end
