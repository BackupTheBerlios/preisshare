object GTDPricelistExportFrame: TGTDPricelistExportFrame
  Left = 0
  Top = 0
  Width = 716
  Height = 479
  TabOrder = 0
  object pnlBackGround: TbsSkinPanel
    Left = 0
    Top = 0
    Width = 716
    Height = 479
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
    Caption = 'pnlBackGround'
    Align = alClient
  end
  object nbkMain: TbsSkinPageControl
    Left = 4
    Top = 4
    Width = 697
    Height = 401
    ActivePage = bsSkinTabSheet1
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
      Caption = 'Start'
      object pnlStart1: TbsSkinGroupBox
        Left = 8
        Top = 12
        Width = 197
        Height = 357
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
        CaptionMode = True
        RollUpMode = False
        RollUpState = False
        NumGlyphs = 1
        Spacing = 2
        Caption = 'Pricelist Export'
        object bsSkinTextLabel2: TbsSkinTextLabel
          Left = 8
          Top = 32
          Width = 185
          Height = 143
          UseSkinFont = True
          Lines.Strings = (
            'This wizard will take you through the'
            'process of exporting the prices/product'
            'information  in this Pricelist file into '
            'your Inventory or Accounting system.'
            ''
            'You can also run this tool simply to'
            'produce a report on what changes'
            'need to be done to bring your'
            'Inventory system up to date with your'
            'suppliers pricelist.')
          DefaultFont.Charset = DEFAULT_CHARSET
          DefaultFont.Color = clWindowText
          DefaultFont.Height = -11
          DefaultFont.Name = 'MS Sans Serif'
          DefaultFont.Style = []
          SkinDataName = 'stdlabel'
        end
        object optExportCSV: TbsSkinCheckRadioBox
          Left = 16
          Top = 232
          Width = 150
          Height = 25
          TabOrder = 0
          Visible = False
          SkinDataName = 'radiobox'
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
          Radio = True
          Checked = False
          GroupIndex = 1
          Caption = 'Export to a Text/CSV File'
          Enabled = False
        end
        object optExportExternalDB: TbsSkinCheckRadioBox
          Left = 16
          Top = 276
          Width = 169
          Height = 25
          TabOrder = 1
          SkinDataName = 'radiobox'
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
          Radio = True
          Checked = False
          GroupIndex = 1
          Caption = 'Export to External Database'
        end
        object optExportCompare: TbsSkinCheckRadioBox
          Left = 16
          Top = 184
          Width = 193
          Height = 25
          TabOrder = 2
          Visible = False
          SkinDataName = 'radiobox'
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
          Radio = True
          Checked = False
          GroupIndex = 1
          Caption = 'Compare with Inventory System'
        end
        object optExportProductDB: TbsSkinCheckRadioBox
          Left = 16
          Top = 252
          Width = 173
          Height = 25
          TabOrder = 3
          SkinDataName = 'radiobox'
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
          Radio = True
          Checked = True
          GroupIndex = 1
          Caption = 'Export to Product Database'
        end
      end
      object pblSupplierDetails: TbsSkinGroupBox
        Left = 220
        Top = 12
        Width = 461
        Height = 125
        TabOrder = 1
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
        Caption = 'Pricelist / Supplier Details'
        object bsSkinLabel10: TbsSkinLabel
          Left = 120
          Top = 32
          Width = 265
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
          Caption = 'Name'
          AutoSize = False
        end
        object bsSkinLabel14: TbsSkinLabel
          Left = 344
          Top = 60
          Width = 85
          Height = 17
          TabOrder = 1
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
          Caption = 'Number of Items'
          AutoSize = False
        end
        object txtItemCount: TbsSkinEdit
          Left = 344
          Top = 76
          Width = 85
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
          ReadOnly = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = 14
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          Visible = False
        end
        object bsSkinLabel1: TbsSkinLabel
          Left = 8
          Top = 32
          Width = 101
          Height = 17
          TabOrder = 3
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
          Caption = 'Supplier Code'
          AutoSize = False
        end
        object bsSkinSpinEdit1: TbsSkinSpinEdit
          Left = 8
          Top = 92
          Width = 101
          Height = 20
          TabOrder = 4
          SkinDataName = 'spinedit'
          DefaultFont.Charset = DEFAULT_CHARSET
          DefaultFont.Color = clWindowText
          DefaultFont.Height = 14
          DefaultFont.Name = 'Arial'
          DefaultFont.Style = []
          DefaultWidth = 0
          DefaultHeight = 0
          UseSkinFont = True
          ValueType = vtInteger
          Increment = 1.000000000000000000
          EditorEnabled = True
          MaxLength = 0
        end
        object bsSkinLabel5: TbsSkinLabel
          Left = 8
          Top = 76
          Width = 101
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
          Caption = 'Adjust Price.. (%)'
          AutoSize = False
        end
        object bsSkinCheckRadioBox1: TbsSkinCheckRadioBox
          Left = 236
          Top = 92
          Width = 221
          Height = 25
          TabOrder = 6
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
          Checked = False
          GroupIndex = 0
          Caption = 'Remove Tax Component from price'
        end
        object bsSkinStatusPanel1: TbsSkinStatusPanel
          Left = 120
          Top = 92
          Width = 109
          Height = 21
          TabOrder = 7
          SkinDataName = 'statuspanel'
          DefaultFont.Charset = DEFAULT_CHARSET
          DefaultFont.Color = clWindowText
          DefaultFont.Height = 14
          DefaultFont.Name = 'Arial'
          DefaultFont.Style = []
          DefaultWidth = 0
          DefaultHeight = 0
          UseSkinFont = True
          BorderStyle = bvFrame
          Caption = 'Inclusive'
          AutoSize = False
          NumGlyphs = 1
        end
        object bsSkinLabel6: TbsSkinLabel
          Left = 120
          Top = 76
          Width = 109
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
          Caption = 'Pricelist Tax Status'
          AutoSize = False
        end
        object txtSupplierName: TbsSkinStatusPanel
          Left = 120
          Top = 48
          Width = 265
          Height = 21
          TabOrder = 9
          SkinDataName = 'statuspanel'
          DefaultFont.Charset = DEFAULT_CHARSET
          DefaultFont.Color = clWindowText
          DefaultFont.Height = 14
          DefaultFont.Name = 'Arial'
          DefaultFont.Style = []
          DefaultWidth = 0
          DefaultHeight = 0
          UseSkinFont = True
          BorderStyle = bvFrame
          AutoSize = False
          NumGlyphs = 1
        end
        object txtSupplierCode: TbsSkinStatusPanel
          Left = 8
          Top = 48
          Width = 101
          Height = 21
          TabOrder = 10
          SkinDataName = 'statuspanel'
          DefaultFont.Charset = DEFAULT_CHARSET
          DefaultFont.Color = clWindowText
          DefaultFont.Height = 14
          DefaultFont.Name = 'Arial'
          DefaultFont.Style = []
          DefaultWidth = 0
          DefaultHeight = 0
          UseSkinFont = True
          BorderStyle = bvFrame
          AutoSize = False
          NumGlyphs = 1
        end
      end
      object btnNext1: TbsSkinButton
        Left = 600
        Top = 340
        Width = 79
        Height = 25
        TabOrder = 2
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
        Caption = 'Next >>'
        NumGlyphs = 1
        Spacing = 1
        OnClick = btnNext1Click
      end
      object pnlProdGroups: TbsSkinGroupBox
        Left = 220
        Top = 148
        Width = 237
        Height = 181
        TabOrder = 3
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
        Caption = 'Product Groups to Export'
        object lstProdGroups: TbsSkinTreeView
          Left = 8
          Top = 28
          Width = 221
          Height = 145
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
          StateImages = ImageList1
          TabOrder = 0
          OnDblClick = lstProdGroupsDblClick
        end
      end
      object bsSkinCheckRadioBox3: TbsSkinCheckRadioBox
        Left = 220
        Top = 340
        Width = 150
        Height = 25
        TabOrder = 4
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
        Checked = False
        GroupIndex = 0
        Caption = 'Review Items'
      end
    end
    object pgRun: TbsSkinTabSheet
      Caption = 'Report/Update'
      OnShow = pgRunShow
      object btnCancel: TbsSkinButton
        Left = 596
        Top = 340
        Width = 75
        Height = 25
        TabOrder = 0
        Visible = False
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
        CanFocused = False
        Down = False
        GroupIndex = 0
        Caption = 'Cancel'
        NumGlyphs = 2
        Spacing = 1
      end
      object pnlReady2Apply: TbsSkinGroupBox
        Left = 8
        Top = 12
        Width = 197
        Height = 357
        TabOrder = 1
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
        Caption = 'Ready to Apply'
        object bsSkinTextLabel6: TbsSkinTextLabel
          Left = 8
          Top = 32
          Width = 179
          Height = 221
          UseSkinFont = True
          Lines.Strings = (
            'You are now ready to export the '
            'pricelist file containing your updated '
            'product and price information.'
            ''
            'The workshop will then read through'
            'the tables that you have provided and'
            'create a Pricelist file containing all'
            'the appropriate product and price'
            'information.'
            ''
            'Once the Build is complete, press the'
            '[Save] button to record the changes.'
            ''
            'After the Tradalog is saved, it will'
            'be available for Customers/Prospects'
            'the next time they log in.')
          DefaultFont.Charset = DEFAULT_CHARSET
          DefaultFont.Color = clWindowText
          DefaultFont.Height = -11
          DefaultFont.Name = 'MS Sans Serif'
          DefaultFont.Style = []
          SkinDataName = 'stdlabel'
        end
        object cbxNoUpdate: TbsSkinCheckRadioBox
          Left = 16
          Top = 256
          Width = 177
          Height = 25
          TabOrder = 0
          SkinDataName = 'radiobox'
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
          Radio = True
          Checked = True
          GroupIndex = 1
          Caption = 'Report Only - Don'#39't Update'
        end
        object cbxUpdate: TbsSkinCheckRadioBox
          Left = 16
          Top = 280
          Width = 150
          Height = 25
          TabOrder = 1
          SkinDataName = 'radiobox'
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
          Radio = True
          Checked = False
          GroupIndex = 1
          Caption = 'Update Data'
        end
        object btnProcess: TbsSkinButton
          Left = 17
          Top = 316
          Width = 80
          Height = 25
          TabOrder = 2
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
          CanFocused = False
          Down = False
          GroupIndex = 0
          Caption = 'Process'
          NumGlyphs = 2
          Spacing = 1
          OnClick = btnProcessClick
        end
      end
      object sbUpdates: TbsSkinScrollBar
        Left = 672
        Top = 12
        Width = 19
        Height = 189
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
        PageSize = 9
        Min = 0
        Max = 100
        Position = 0
        SmallChange = 1
        LargeChange = 9
      end
      object lsvItems: TbsSkinListView
        Left = 217
        Top = 12
        Width = 456
        Height = 105
        Columns = <
          item
            Caption = 'Code'
            Width = 80
          end
          item
            Caption = 'Name'
            Width = 190
          end
          item
            Alignment = taRightJustify
            Caption = ' Your Buy Price'
            Width = 95
          end
          item
            Alignment = taRightJustify
            Caption = 'List Price'
            Width = 70
          end>
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = 14
        Font.Name = 'Arial'
        Font.Style = []
        Items.Data = {
          1D0100000400000000000000FFFFFFFFFFFFFFFF040000000000000004353536
          36173235364D4220444452343030205043333230302052414D0535352E303002
          3537013500000000FFFFFFFFFFFFFFFF040000000000000004353536371B3235
          364D42204B696E674D617820444452343030205043333230300536302E303002
          3632013600000000FFFFFFFFFFFFFFFF04000000000000000435353638173531
          324D4220444452343030205043333230302052414D0536352E30300236360135
          00000000FFFFFFFFFFFFFFFF0400000000000000043535363915314742204444
          52343030205043333230302052414D063130302E303003313130023130FFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
        LargeImages = ImageList1
        MultiSelect = True
        RowSelect = True
        ParentFont = False
        StateImages = ImageList1
        TabOrder = 3
        ViewStyle = vsReport
        HeaderSkinDataName = 'resizebutton'
        VScrollBar = sbUpdates
        DefaultFont.Charset = DEFAULT_CHARSET
        DefaultFont.Color = clWindowText
        DefaultFont.Height = 14
        DefaultFont.Name = 'Arial'
        DefaultFont.Style = []
        UseSkinFont = True
        SkinDataName = 'listview'
        DefaultColor = clWindow
      end
      object customerDBGrid: TbsSkinDBGrid
        Left = 217
        Top = 212
        Width = 456
        Height = 121
        TabOrder = 4
        Visible = False
        SkinDataName = 'grid'
        UseSkinFont = True
        UseSkinCellHeight = True
        GridLineColor = clWindowText
        DefaultCellHeight = 20
        UseColumnsFont = False
        DefaultRowHeight = 18
        MouseWheelSupport = False
        SaveMultiSelection = False
        PickListBoxSkinDataName = 'listbox'
        PickListBoxCaptionMode = False
        DataSource = DSAccess
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clBtnText
        TitleFont.Height = 14
        TitleFont.Name = 'Arial'
        TitleFont.Style = []
      end
      object mmoProgress: TbsSkinMemo
        Left = 217
        Top = 212
        Width = 456
        Height = 121
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = 14
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        ScrollBars = ssBoth
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
      object barProgress: TbsSkinGauge
        Left = 335
        Top = 340
        Width = 246
        Height = 25
        TabOrder = 6
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
        ShowProgressText = True
        ShowPercent = True
        MinValue = 0
        MaxValue = 100
        Value = 0
        Vertical = False
      end
      object btnShowHideData_Log: TbsSkinButton
        Left = 217
        Top = 340
        Width = 84
        Height = 25
        TabOrder = 7
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
        CanFocused = False
        Down = False
        GroupIndex = 0
        Caption = 'Show Data'
        NumGlyphs = 2
        Spacing = 1
        OnClick = btnShowHideData_LogClick
      end
      object mmoSQL: TbsSkinMemo2
        Left = 216
        Top = 120
        Width = 457
        Height = 89
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = 14
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ScrollBars = ssBoth
        TabOrder = 8
        DefaultFont.Charset = DEFAULT_CHARSET
        DefaultFont.Color = clWindowText
        DefaultFont.Height = 14
        DefaultFont.Name = 'Arial'
        DefaultFont.Style = []
        UseSkinFont = True
        SkinDataName = 'memo'
      end
    end
  end
  object db1: TDatabase
    SessionName = 'Default'
    Left = 45
    Top = 437
  end
  object qryTemp: TQuery
    Left = 637
    Top = 97
  end
  object dlgOpen: TbsSkinOpenDialog
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
    Title = 'Open file'
    Filter = 'All files|*.*'
    FilterIndex = 1
    Left = 548
    Top = 65532
  end
  object bsSkinMessage1: TbsSkinMessage
    AlphaBlend = False
    AlphaBlendAnimation = False
    AlphaBlendValue = 200
    ButtonSkinDataName = 'button'
    MessageLabelSkinDataName = 'stdlabel'
    DefaultFont.Charset = DEFAULT_CHARSET
    DefaultFont.Color = clWindowText
    DefaultFont.Height = 14
    DefaultFont.Name = 'Arial'
    DefaultFont.Style = []
    DefaultButtonFont.Charset = DEFAULT_CHARSET
    DefaultButtonFont.Color = clWindowText
    DefaultButtonFont.Height = 14
    DefaultButtonFont.Name = 'Arial'
    DefaultButtonFont.Style = []
    UseSkinFont = True
    Left = 460
    Top = 4
  end
  object qrySourceData: TQuery
    DatabaseName = 'SourceDB'
    Left = 104
    Top = 440
  end
  object dsSourceData: TDataSource
    DataSet = qrySourceData
    Left = 580
    Top = 192
  end
  object dsLoadMappings: TDataSource
    DataSet = qryLoadMappings
    Left = 261
    Top = 5
  end
  object qryLoadMappings: TQuery
    DatabaseName = 'TRADALOGS'
    SQL.Strings = (
      'select'
      #9'keyname,keytext'
      'from'
      #9'sysvals'
      'where'
      #9'SECTION = '#39'Pricelist Export'#39';')
    Left = 545
    Top = 193
  end
  object tblSysVal: TTable
    DatabaseName = 'TRADALOGS'
    TableName = 'SysVals.DB'
    Left = 581
    Top = 5
  end
  object tblProductUpdates: TTable
    DatabaseName = 'TRADALOGS'
    IndexName = 'ByRevision_Key1'
    TableName = 'Product_Updates.DB'
    Left = 353
    Top = 5
  end
  object dsProductUpdates: TDataSource
    DataSet = tblProductUpdates
    Left = 385
    Top = 5
  end
  object qryPurgeRevisions: TQuery
    DatabaseName = 'TRADALOGS'
    SQL.Strings = (
      'delete'
      'from'
      #9'Product_Updates'
      'where'
      #9'(Trader_ID = :TraderNo) and (Revision_Number = :Revision)'
      #9'and (Applied_Flag <> "Y")')
    Left = 9
    Top = 441
    ParamData = <
      item
        DataType = ftInteger
        Name = 'TraderNo'
        ParamType = ptUnknown
      end
      item
        DataType = ftInterface
        Name = 'Revision'
        ParamType = ptUnknown
      end>
  end
  object dlgSaveProfileName: TbsSkinInputDialog
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
    Left = 300
    Top = 4
  end
  object DSAccess: TDataSource
    Left = 160
    Top = 440
  end
  object DataSource1: TDataSource
    DataSet = tblSysVal
    Left = 220
    Top = 296
  end
  object ImageList1: TImageList
    BkColor = clWhite
    ShareImages = True
    Left = 496
    Top = 4
    Bitmap = {
      494C010105000900040010001000FFFFFF00FF10FFFFFFFFFFFFFFFF424D3600
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
      000000000000000000000000000000000000FF7FFF7FFF7FFF7FFF7FFF7FFF7F
      FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF7FFF7FFF7FFF7FFF7FFF7FFF7F
      FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF7FFF7FFF7FFF7FFF7FFF7FFF7F
      FF7FFF7FFF7FFF7FFF7F0040FF7FFF7FFF7F0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF7FFF7FFF7F0040FF7FFF7FFF7F
      FF7FFF7FFF7FFF7F0040FF7FFF7FFF7FFF7F0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF7FFF7FFF7F00400040FF7FFF7F
      FF7FFF7FFF7F00400040FF7FFF7FFF7FFF7F0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF7FFF7F0040004000400040FF7F
      FF7FFF7F00400040FF7FFF7FFF7FFF7FFF7F0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF7FFF7F00400040004000400040
      FF7F004000400040FF7FFF7FFF7FFF7FFF7F0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF7FFF7F00400040004000400040
      004000400040FF7FFF7FFF7FFF7FFF7FFF7F0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF7FFF7FFF7FFF7F004000400040
      004000400040FF7FFF7FFF7FFF7FFF7FFF7F0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF7FFF7FFF7FFF7FFF7FFF7F0040
      0040004000400040FF7FFF7FFF7FFF7FFF7F0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF7FFF7FFF7FFF7FFF7F00400040
      004000400040FF7F0040FF7FFF7FFF7FFF7F0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF7FFF7FFF7FFF7F004000400040
      0040FF7FFF7F004000400040FF7FFF7FFF7F0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF7FFF7FFF7F0040004000400040
      0040FF7FFF7FFF7FFF7F00400040FF7FFF7F0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF7FFF7FFF7FFF7FFF7FFF7FFF7F
      FF7FFF7FFF7FFF7FFF7FFF7FFF7F004000400000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF7FFF7FFF7FFF7FFF7FFF7FFF7F
      FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF7FFF7FFF7FFF7FFF7FFF7FFF7F
      FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF7FFF7FFF7FFF7FFF7FFF7FFF7F
      FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F1040104010401040104010401040
      104010401040104010401040104010401040FF7FFF7FFF7FFF7FFF7FFF7FFF7F
      00020002FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F
      FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F
      FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F10401040104010401040E07FE07F
      E07F1040E07F104010401040104010401040FF7FFF7FFF7FFF7FFF7F00020002
      000200020002FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F
      FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F
      FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F10401040104010401040E07F1040
      E07F1040E07FE07F10401040104010401040FF7FFF7FFF7FFF7F000200020002
      00020002000200020002FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF03
      FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F
      FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F10401040104010401040E07F1040
      E07F1040E07F1040E07F1040104010401040FF7FFF7FFF7F0002000200020002
      000200020002000200020002FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF031F00
      FF03FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F1863
      104210421042FF7FFF7FFF7FFF7FFF7FFF7F10401040104010401040E07F1040
      E07F1040E07FE07F10401040104010401040FF7FFF7FFF7FFF7FFF7F00020002
      0002000200020002FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF031F00
      FF03FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F18631863
      1863186310421042FF7FFF7FFF7FFF7FFF7F1040104010401040104010401040
      104010401040104010401040104010401040FF7FFF7FFF7FFF7FFF7F00020002
      0002000200020002FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF031F001F00
      1F00FF03FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F186318631863
      10421863186310421042FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F007C007C
      007C007C007C007CFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F00020002
      0002000200020002FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF031F00FF03
      1F001F00FF03FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F186318631863
      18631042186318631042FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F007C007C
      007C007C007C007CFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F00020002
      0002000200020002FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF031F00FF03FF03
      FF031F001F00FF03FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F1863FF7F
      18631863186318631042FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F007C007C
      007C007C007C007CFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F00020002
      0002000200020002FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF03FF03FF7FFF7F
      FF7FFF031F00FF03FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F1863
      FF7F186318631863FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F007C007C
      007C007C007C007CFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F00020002
      0002000200020002FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F
      FF7FFF7FFF03FF03FF03FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F
      1863FF7F1863FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F007C007C
      007C007C007C007CFF7FFF7FFF7FFF7FFF7F1040104010401040104010401040
      104010401040104010401040104010401040FF7FFF7FFF7FFF7FFF7FFF7FFF7F
      FF7FFF7FFF7FFF7FFF03FF03FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F
      FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F007C007C007C007C
      007C007C007C007C007C007CFF7FFF7FFF7F1040E07FE07F104010401040E07F
      10401040E07F1040E07F1040E07F1040E07FFF7FFF7FFF7FFF7FFF7FFF7FFF7F
      FF7FFF7FFF7FFF7FFF7FFF03FF03FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F
      FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F007C007C007C
      007C007C007C007C007CFF7FFF7FFF7FFF7F1040E07F1040E07F1040E07F1040
      E07F1040E07F1040E07F1040E07F1040E07FFF7FFF7FFF7FFF7FFF7FFF7FFF7F
      FF7FFF7FFF7FFF7FFF7FFF7FFF03FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F
      FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F007C007C
      007C007C007C007CFF7FFF7FFF7FFF7FFF7F1040E07F1040E07F1040E07F1040
      E07FE07F1040E07FE07F1040E07FE07FE07FFF7FFF7FFF7FFF7FFF7FFF7FFF7F
      FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF03FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F
      FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F007C
      007C007C007CFF7FFF7FFF7FFF7FFF7FFF7F1040E07FE07F104010401040E07F
      1040E07F10401040E07F1040E07F1040E07FFF7FFF7FFF7FFF7FFF7FFF7FFF7F
      FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F
      FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F
      007C007CFF7FFF7FFF7FFF7FFF7FFF7FFF7F1040104010401040104010401040
      104010401040104010401040104010401040FF7FFF7FFF7FFF7FFF7FFF7FFF7F
      FF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7FFF7F424D3E000000000000003E000000
      2800000040000000300000000100010000000000800100000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FFFF000000000000FFFF000000000000
      FFF7000000000000EFEF000000000000E7CF000000000000C39F000000000000
      C11F000000000000C03F000000000000F03F000000000000FC1F000000000000
      F82F000000000000F0C7000000000000E0F3000000000000FFFC000000000000
      FFFF000000000000FFFF000000000000FFFF0000FE7FFFFFFFFF0000F83FFFFF
      FFFF0000F00FFDFFFFFF0000E007F8FFFC3F0000F81FF8FFF81F0000F81FF07F
      F00FF81FF81FF03FF00FF81FF81FE01FF00FF81FF81FE71FF81FF81FF81FFF8F
      FC3FF81F0000FFE7FFFFE0070000FFF3FFFFF00F0000FFFBFFFFF81F0000FFFD
      FFFFFC3F0000FFFFFFFFFE7F0000FFFF00000000000000000000000000000000
      000000000000}
  end
  object DQryGroups: TDQuery
    FieldDefs = <>
    Connection = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=D:\ACCESS100.MDB;Pe' +
      'rsist Security Info=False'
    Master = DeersoftDB
    MaxRecords = 0
    SubList = <>
    UpdateMode = upWhereAll
    Options = [opDialog, opFilter, opConnection]
    SQL.Strings = (
      'Select * from Images')
    Left = 544
    Top = 80
  end
  object DeersoftDB: TDMaster
    Connection = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=D:\ACCESS100.MDB;Pe' +
      'rsist Security Info=False'
    Connected = False
    Left = 517
    Top = 49
  end
  object DQryItems: TDQuery
    FieldDefs = <>
    Connection = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=D:\ACCESS100.MDB;Pe' +
      'rsist Security Info=False'
    Master = DeersoftDB
    MaxRecords = 0
    SubList = <>
    UpdateMode = upWhereAll
    Options = [opDialog, opFilter, opConnection]
    Left = 545
    Top = 113
  end
  object DtblDestItems: TDTable
    FieldDefs = <>
    Connection = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=D:\ACCESS100.MDB;Pe' +
      'rsist Security Info=False'
    Master = DeersoftDB
    MaxRecords = 0
    SubList = <>
    UpdateMode = upWhereAll
    Options = [opDialog, opFilter, opConnection]
    ADOCommandOption = coTable
    Left = 677
    Top = 37
  end
end
