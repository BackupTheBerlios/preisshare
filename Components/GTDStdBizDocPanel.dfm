object StdBizDocPanel: TStdBizDocPanel
  Left = 0
  Top = 0
  Width = 443
  Height = 277
  Align = alClient
  AutoScroll = False
  TabOrder = 0
  OnResize = FrameResize
  object pnlBackground: TbsSkinPanel
    Left = 0
    Top = 0
    Width = 443
    Height = 464
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
    BorderStyle = bvNone
    CaptionMode = False
    RollUpMode = False
    RollUpState = False
    NumGlyphs = 1
    Spacing = 2
    Caption = 'pnlBackground'
    Align = alTop
  end
  object tbsNotebook: TbsSkinPageControl
    Left = 8
    Top = 48
    Width = 533
    Height = 329
    ActivePage = bsSkinTabSheet4
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBtnText
    Font.Height = 14
    Font.Name = 'Arial'
    Font.Style = []
    MultiLine = True
    ParentFont = False
    TabOrder = 1
    TabPosition = tpRight
    OnChange = tbsNotebookChange
    DefaultFont.Charset = DEFAULT_CHARSET
    DefaultFont.Color = clBtnText
    DefaultFont.Height = 14
    DefaultFont.Name = 'Arial'
    DefaultFont.Style = []
    UseSkinFont = True
    DefaultItemHeight = 20
    SkinDataName = 'tab'
    object bsSkinTabSheet2: TbsSkinTabSheet
      Caption = 'Items'
      object lsvLineItems: TbsSkinListView
        Left = 8
        Top = 56
        Width = 497
        Height = 261
        Columns = <
          item
            Caption = 'Code'
            Width = 60
          end
          item
            Caption = 'Description'
            Width = 180
          end
          item
            Alignment = taRightJustify
            Caption = 'Quantity'
            Width = 70
          end
          item
            Alignment = taRightJustify
            Caption = 'Rate'
            Width = 60
          end
          item
            Alignment = taCenter
            Caption = 'Units'
            Width = 60
          end
          item
            Alignment = taRightJustify
            Caption = 'Amount'
            Width = 60
          end>
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = 14
        Font.Name = 'Arial'
        Font.Style = []
        HideSelection = False
        MultiSelect = True
        RowSelect = True
        ParentFont = False
        StateImages = ImageList1
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
        OnClick = lsvLineItemsClick
      end
      object lblDate: TbsSkinLabel
        Left = 8
        Top = 8
        Width = 101
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
        Caption = 'Date'
        AutoSize = False
      end
      object txtDocDate: TbsSkinDateEdit
        Left = 8
        Top = 24
        Width = 101
        Height = 20
        EditMask = '!99/99/0000;1; '
        Text = '22/07/2006'
        AlphaBlend = False
        AlphaBlendAnimation = False
        AlphaBlendValue = 0
        Date = 38920.2390403009
        TodayDefault = True
        CalendarWidth = 200
        CalendarHeight = 150
        CalendarFont.Charset = DEFAULT_CHARSET
        CalendarFont.Color = clWindowText
        CalendarFont.Height = 14
        CalendarFont.Name = 'Arial'
        CalendarFont.Style = []
        FirstDayOfWeek = Mon
        DefaultFont.Charset = DEFAULT_CHARSET
        DefaultFont.Color = clWindowText
        DefaultFont.Height = 14
        DefaultFont.Name = 'Arial'
        DefaultFont.Style = []
        DefaultWidth = 0
        DefaultHeight = 20
        ButtonMode = True
        SkinDataName = 'buttonedit'
        ReadOnly = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = 14
        Font.Name = 'Arial'
        Font.Style = []
        MaxLength = 10
        ParentFont = False
        TabOrder = 2
      end
      object bsSkinLabel3: TbsSkinLabel
        Left = 260
        Top = 8
        Width = 109
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
        Caption = 'Telephone'
        AutoSize = False
      end
      object txtTelephone: TbsSkinEdit
        Left = 260
        Top = 24
        Width = 109
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
        TabOrder = 4
      end
      object bsSkinLabel4: TbsSkinLabel
        Left = 116
        Top = 8
        Width = 137
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
        Caption = 'Location'
        AutoSize = False
      end
      object txtLocation: TbsSkinEdit
        Left = 116
        Top = 24
        Width = 137
        Height = 20
        DefaultFont.Charset = DEFAULT_CHARSET
        DefaultFont.Color = clWindowText
        DefaultFont.Height = 14
        DefaultFont.Name = 'Arial'
        DefaultFont.Style = []
        UseSkinFont = True
        DefaultWidth = 0
        DefaultHeight = 20
        ButtonMode = True
        SkinDataName = 'buttonedit'
        ReadOnly = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = 14
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 6
        OnButtonClick = txtLocationButtonClick
      end
      object bsSkinLabel5: TbsSkinLabel
        Left = 376
        Top = 8
        Width = 129
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
        Caption = 'Status'
        AutoSize = False
      end
      object txtStatus: TbsSkinEdit
        Left = 376
        Top = 24
        Width = 129
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
        TabOrder = 8
      end
    end
    object bsSkinTabSheet1: TbsSkinTabSheet
      Caption = 'Details'
      object pnlInfo: TbsSkinGroupBox
        Left = 8
        Top = 8
        Width = 241
        Height = 213
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
        Caption = 'Customer Details'
        object bsSkinStdLabel1: TbsSkinStdLabel
          Left = 8
          Top = 28
          Width = 28
          Height = 13
          UseSkinFont = True
          DefaultFont.Charset = DEFAULT_CHARSET
          DefaultFont.Color = clWindowText
          DefaultFont.Height = -11
          DefaultFont.Name = 'MS Sans Serif'
          DefaultFont.Style = []
          SkinDataName = 'stdlabel'
          Caption = 'Name'
        end
        object bsSkinStdLabel2: TbsSkinStdLabel
          Left = 8
          Top = 68
          Width = 38
          Height = 13
          UseSkinFont = True
          DefaultFont.Charset = DEFAULT_CHARSET
          DefaultFont.Color = clWindowText
          DefaultFont.Height = -11
          DefaultFont.Name = 'MS Sans Serif'
          DefaultFont.Style = []
          SkinDataName = 'stdlabel'
          Caption = 'Address'
        end
        object bsSkinStdLabel3: TbsSkinStdLabel
          Left = 8
          Top = 128
          Width = 49
          Height = 13
          UseSkinFont = True
          DefaultFont.Charset = DEFAULT_CHARSET
          DefaultFont.Color = clWindowText
          DefaultFont.Height = -11
          DefaultFont.Name = 'MS Sans Serif'
          DefaultFont.Style = []
          SkinDataName = 'stdlabel'
          Caption = 'City/Town'
        end
        object bsSkinStdLabel4: TbsSkinStdLabel
          Left = 132
          Top = 128
          Width = 25
          Height = 13
          UseSkinFont = True
          DefaultFont.Charset = DEFAULT_CHARSET
          DefaultFont.Color = clWindowText
          DefaultFont.Height = -11
          DefaultFont.Name = 'MS Sans Serif'
          DefaultFont.Style = []
          SkinDataName = 'stdlabel'
          Caption = 'State'
        end
        object bsSkinStdLabel5: TbsSkinStdLabel
          Left = 132
          Top = 168
          Width = 36
          Height = 13
          UseSkinFont = True
          DefaultFont.Charset = DEFAULT_CHARSET
          DefaultFont.Color = clWindowText
          DefaultFont.Height = -11
          DefaultFont.Name = 'MS Sans Serif'
          DefaultFont.Style = []
          SkinDataName = 'stdlabel'
          Caption = 'Country'
        end
        object bsSkinStdLabel7: TbsSkinStdLabel
          Left = 8
          Top = 168
          Width = 45
          Height = 13
          UseSkinFont = True
          DefaultFont.Charset = DEFAULT_CHARSET
          DefaultFont.Color = clWindowText
          DefaultFont.Height = -11
          DefaultFont.Name = 'MS Sans Serif'
          DefaultFont.Style = []
          SkinDataName = 'stdlabel'
          Caption = 'Postcode'
        end
        object txtName: TbsSkinEdit
          Left = 8
          Top = 44
          Width = 225
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
          TabOrder = 0
        end
        object txtAddress1: TbsSkinEdit
          Left = 8
          Top = 84
          Width = 225
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
          TabOrder = 1
        end
        object txtAddress2: TbsSkinEdit
          Left = 8
          Top = 104
          Width = 225
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
        end
        object txtCity: TbsSkinEdit
          Left = 8
          Top = 144
          Width = 117
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
          TabOrder = 3
        end
        object txtState: TbsSkinEdit
          Left = 132
          Top = 144
          Width = 101
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
          TabOrder = 4
        end
        object txtCountry: TbsSkinEdit
          Left = 132
          Top = 184
          Width = 101
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
          TabOrder = 5
        end
        object txtPostcode: TbsSkinEdit
          Left = 8
          Top = 184
          Width = 117
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
          TabOrder = 6
        end
      end
      object pnlTaxMode: TbsSkinGroupBox
        Left = 8
        Top = 248
        Width = 241
        Height = 69
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
        Caption = 'Tax Mode'
        object bsSkinStdLabel6: TbsSkinStdLabel
          Left = 96
          Top = 36
          Width = 23
          Height = 13
          UseSkinFont = True
          DefaultFont.Charset = DEFAULT_CHARSET
          DefaultFont.Color = clWindowText
          DefaultFont.Height = -11
          DefaultFont.Name = 'MS Sans Serif'
          DefaultFont.Style = []
          SkinDataName = 'stdlabel'
          Caption = 'Rate'
        end
        object txtTaxType: TbsSkinStdLabel
          Left = 188
          Top = 36
          Width = 21
          Height = 13
          UseSkinFont = True
          DefaultFont.Charset = DEFAULT_CHARSET
          DefaultFont.Color = clWindowText
          DefaultFont.Height = -11
          DefaultFont.Name = 'MS Sans Serif'
          DefaultFont.Style = []
          SkinDataName = 'stdlabel'
          Caption = 'VAT'
        end
        object rdoTaxInclusive: TbsSkinCheckRadioBox
          Left = 8
          Top = 20
          Width = 73
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
          Caption = 'Inclusive'
        end
        object rdoTaxExclusive: TbsSkinCheckRadioBox
          Left = 8
          Top = 40
          Width = 77
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
          Caption = 'Exclusive'
        end
        object txtTaxRate: TbsSkinMaskEdit
          Left = 128
          Top = 32
          Width = 53
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
          AutoSize = False
          BorderStyle = bsNone
        end
      end
      object pnlDocDetails: TbsSkinGroupBox
        Left = 256
        Top = 8
        Width = 249
        Height = 309
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
        Caption = 'Document Details'
        object grdDocProperties: TbsSkinListView
          Left = 8
          Top = 28
          Width = 233
          Height = 269
          Columns = <
            item
              Caption = 'Name'
              Width = 100
            end
            item
              Caption = 'Value'
              Width = 120
            end>
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = 14
          Font.Name = 'Arial'
          Font.Style = []
          HideSelection = False
          RowSelect = True
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
      end
      object pnlJobNumbers: TbsSkinGroupBox
        Left = 8
        Top = 232
        Width = 241
        Height = 78
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
        Caption = 'Job Selection'
        object lblJobSelect: TbsSkinLabel
          Left = 8
          Top = 32
          Width = 225
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
          Caption = 'Job #'
          AutoSize = False
        end
        object cbxJobSelect: TbsSkinComboBox
          Left = 8
          Top = 48
          Width = 225
          Height = 20
          TabOrder = 1
          SkinDataName = 'combobox'
          DefaultFont.Charset = DEFAULT_CHARSET
          DefaultFont.Color = clWindowText
          DefaultFont.Height = 14
          DefaultFont.Name = 'Arial'
          DefaultFont.Style = []
          DefaultWidth = 0
          DefaultHeight = 0
          UseSkinFont = True
          AlphaBlend = False
          AlphaBlendValue = 0
          AlphaBlendAnimation = False
          HideSelection = True
          AutoComplete = True
          ListBoxUseSkinFont = True
          ListBoxUseSkinItemHeight = True
          ImageIndex = -1
          ListBoxCaptionMode = False
          ListBoxDefaultFont.Charset = DEFAULT_CHARSET
          ListBoxDefaultFont.Color = clWindowText
          ListBoxDefaultFont.Height = 14
          ListBoxDefaultFont.Name = 'Arial'
          ListBoxDefaultFont.Style = []
          ListBoxDefaultCaptionFont.Charset = DEFAULT_CHARSET
          ListBoxDefaultCaptionFont.Color = clWindowText
          ListBoxDefaultCaptionFont.Height = 14
          ListBoxDefaultCaptionFont.Name = 'Arial'
          ListBoxDefaultCaptionFont.Style = []
          ListBoxDefaultItemHeight = 20
          ListBoxCaptionAlignment = taLeftJustify
          TabStop = True
          ItemIndex = -1
          DropDownCount = 8
          HorizontalExtent = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = 14
          Font.Name = 'Arial'
          Font.Style = []
          Sorted = False
          Style = bscbFixedStyle
          OnChange = cbxJobSelectChange
        end
      end
    end
    object bsSkinTabSheet4: TbsSkinTabSheet
      Caption = 'Status/History'
      object btnNote: TbsSkinSpeedButton
        Left = 8
        Top = 136
        Width = 41
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
        Caption = '+Note'
        ShowCaption = True
        NumGlyphs = 1
        Spacing = 1
        OnClick = btnNoteClick
      end
      object lstHistory: TbsSkinListView
        Left = 8
        Top = 168
        Width = 489
        Height = 149
        Columns = <
          item
            Caption = 'Time'
            Width = 115
          end
          item
            Caption = 'Code'
            Width = 60
          end
          item
            Caption = 'Description'
            Width = 300
          end>
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = 14
        Font.Name = 'Arial'
        Font.Style = []
        ReadOnly = True
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
      object pnlYourStatus: TbsSkinLabel
        Left = 8
        Top = 8
        Width = 233
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
        BorderStyle = bvRaised
        Caption = 'Your Status'
        AutoSize = False
      end
      object cbxOrderOurStatusCode: TbsSkinComboBox
        Left = 8
        Top = 24
        Width = 233
        Height = 20
        Hint = 
          'This is the Status of your Order as far as you are concerned. Yo' +
          'u can change this value to anything that you like so that the Ve' +
          'ndor can see it'
        TabOrder = 2
        SkinDataName = 'combobox'
        DefaultFont.Charset = DEFAULT_CHARSET
        DefaultFont.Color = clWindowText
        DefaultFont.Height = 14
        DefaultFont.Name = 'Arial'
        DefaultFont.Style = []
        DefaultWidth = 0
        DefaultHeight = 0
        UseSkinFont = True
        AlphaBlend = False
        AlphaBlendValue = 0
        AlphaBlendAnimation = False
        HideSelection = True
        AutoComplete = False
        ListBoxUseSkinFont = True
        ListBoxUseSkinItemHeight = True
        ImageIndex = -1
        ListBoxCaption = 'Your Status'
        ListBoxCaptionMode = False
        ListBoxDefaultFont.Charset = DEFAULT_CHARSET
        ListBoxDefaultFont.Color = clWindowText
        ListBoxDefaultFont.Height = 14
        ListBoxDefaultFont.Name = 'Arial'
        ListBoxDefaultFont.Style = []
        ListBoxDefaultCaptionFont.Charset = DEFAULT_CHARSET
        ListBoxDefaultCaptionFont.Color = clWindowText
        ListBoxDefaultCaptionFont.Height = 14
        ListBoxDefaultCaptionFont.Name = 'Arial'
        ListBoxDefaultCaptionFont.Style = []
        ListBoxDefaultItemHeight = 20
        ListBoxCaptionAlignment = taLeftJustify
        ShowHint = True
        Items.Strings = (
          'Not Sent'
          'Sent'
          'Hold'
          'Awaiting Delivery'
          'Awaiting Response'
          'Partially Received'
          'Goods Received'
          'Goods Damaged'
          'Cancelled'
          'Complete')
        ItemIndex = -1
        DropDownCount = 8
        HorizontalExtent = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = 14
        Font.Name = 'Arial'
        Font.Style = []
        Sorted = False
        Style = bscbEditStyle
        OnChange = cbxOrderOurStatusCodeChange
      end
      object rchOrderOurStatusCmts: TbsSkinRichEdit
        Left = 8
        Top = 64
        Width = 233
        Height = 65
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = 14
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        PlainText = True
        TabOrder = 3
        SkinSupport = True
        DefaultFont.Charset = DEFAULT_CHARSET
        DefaultFont.Color = clWindowText
        DefaultFont.Height = 14
        DefaultFont.Name = 'Arial'
        DefaultFont.Style = []
        SkinDataName = 'richedit'
        DefaultColor = clWindow
        OnChange = rchOrderOurStatusCmtsChange
      end
      object lblOrderYourComments: TbsSkinLabel
        Left = 8
        Top = 48
        Width = 233
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
        BorderStyle = bvRaised
        Caption = 'Your Comments'
        AutoSize = False
      end
      object txtOrderTheirStatusCode: TbsSkinEdit
        Left = 252
        Top = 24
        Width = 249
        Height = 20
        Text = 'Not Received'
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
        TabOrder = 5
      end
      object txtOrderTheirStatusCmts: TbsSkinRichEdit
        Left = 252
        Top = 64
        Width = 247
        Height = 65
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = 14
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        TabOrder = 6
        SkinSupport = True
        DefaultFont.Charset = DEFAULT_CHARSET
        DefaultFont.Color = clWindowText
        DefaultFont.Height = 14
        DefaultFont.Name = 'Arial'
        DefaultFont.Style = []
        SkinDataName = 'richedit'
        DefaultColor = clWindow
      end
      object lblOrderTheirComments: TbsSkinLabel
        Left = 252
        Top = 48
        Width = 249
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
        Caption = 'Their Comments'
        AutoSize = False
      end
      object lblOrderTheirStatus: TbsSkinLabel
        Left = 252
        Top = 8
        Width = 249
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
        Caption = 'Their Status'
        AutoSize = False
      end
    end
    object bsSkinTabSheet5: TbsSkinTabSheet
      Caption = 'Source'
      object mmoText: TbsSkinMemo2
        Left = 8
        Top = 8
        Width = 477
        Height = 309
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = 14
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 0
        WordWrap = False
        DefaultFont.Charset = DEFAULT_CHARSET
        DefaultFont.Color = clWindowText
        DefaultFont.Height = 14
        DefaultFont.Name = 'Arial'
        DefaultFont.Style = []
        UseSkinFont = True
        VScrollBar = sbSourceV
        SkinDataName = 'memo'
      end
      object sbSourceV: TbsSkinScrollBar
        Left = 484
        Top = 8
        Width = 19
        Height = 309
        TabOrder = 1
        SkinDataName = 'vscrollbar'
        DefaultFont.Charset = DEFAULT_CHARSET
        DefaultFont.Color = clWindowText
        DefaultFont.Height = 14
        DefaultFont.Name = 'Arial'
        DefaultFont.Style = []
        DefaultWidth = 19
        DefaultHeight = 0
        UseSkinFont = True
        Enabled = False
        Both = False
        BothMarkerWidth = 19
        BothSkinDataName = 'bothhscrollbar'
        CanFocused = False
        Kind = sbVertical
        PageSize = 0
        Min = 0
        Max = 0
        Position = 0
        SmallChange = 1
        LargeChange = 1
      end
    end
  end
  object bsSkinControlBar1: TbsSkinControlBar
    Left = 8
    Top = 8
    Width = 621
    Height = 35
    SkinDataName = 'controlbar'
    SkinBevel = False
    AutoDrag = False
    AutoSize = True
    Constraints.MaxHeight = 40
    DockSite = False
    RowSnap = False
    TabOrder = 2
    OnCanResize = bsSkinControlBar1CanResize
    object btnLineEdit: TbsSkinSpeedButton
      Left = 140
      Top = 2
      Width = 47
      Height = 27
      SkinDataName = 'button'
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
      Caption = 'Edit'
      ShowCaption = True
      NumGlyphs = 1
      Align = alLeft
      Spacing = 1
    end
    object btnLineAdd: TbsSkinSpeedButton
      Left = 82
      Top = 2
      Width = 45
      Height = 27
      SkinDataName = 'button'
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
      Caption = 'Add'
      ShowCaption = True
      NumGlyphs = 1
      Align = alLeft
      Spacing = 1
    end
    object btnSearchProduct: TbsSkinSpeedButton
      Left = 11
      Top = 2
      Width = 58
      Height = 27
      SkinDataName = 'button'
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
      Caption = '+Product'
      ShowCaption = True
      NumGlyphs = 1
      Align = alLeft
      Spacing = 1
    end
    object btnLineDelete: TbsSkinSpeedButton
      Left = 200
      Top = 2
      Width = 39
      Height = 27
      SkinDataName = 'button'
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
      Caption = 'Delete'
      ShowCaption = True
      NumGlyphs = 1
      Align = alLeft
      Spacing = 1
      OnClick = btnLineDeleteClick
    end
    object btnSend: TbsSkinSpeedButton
      Left = 312
      Top = 2
      Width = 41
      Height = 27
      SkinDataName = 'button'
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
      Caption = 'Email'
      ShowCaption = True
      NumGlyphs = 1
      Align = alLeft
      Spacing = 1
      OnClick = btnSendClick
    end
    object btnCancel: TbsSkinSpeedButton
      Left = 495
      Top = 2
      Width = 44
      Height = 27
      SkinDataName = 'button'
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
      Align = alLeft
      Spacing = 1
    end
    object btnSave: TbsSkinSpeedButton
      Left = 438
      Top = 2
      Width = 44
      Height = 27
      SkinDataName = 'button'
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
      Caption = 'Save'
      ShowCaption = True
      NumGlyphs = 1
      Align = alLeft
      Spacing = 1
    end
    object btnReceiveItem: TbsSkinSpeedButton
      Left = 366
      Top = 2
      Width = 59
      Height = 27
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
      Caption = 'Receive'
      ShowCaption = True
      NumGlyphs = 1
      Align = alLeft
      Spacing = 1
      OnClick = btnReceiveItemClick
    end
    object btnPrint1: TbsSkinMenuButton
      Left = 252
      Top = 2
      Width = 47
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
      Caption = 'Print'
      NumGlyphs = 1
      Spacing = 1
      SkinPopupMenu = mnuPrintOptions
      TrackButtonMode = False
    end
  end
  object Emailer: TSmtpCli
    Tag = 0
    LocalAddr = '0.0.0.0'
    Port = 'smtp'
    AuthType = smtpAuthNone
    CharSet = 'iso-8859-1'
    ContentType = smtpPlainText
    OwnHeaders = False
    OnDisplay = EmailerDisplay
    Left = 8
    Top = 388
  end
  object dlgEmailBody: TbsSkinTextDialog
    ShowToolBar = True
    ClientWidth = 350
    ClientHeight = 200
    Caption = 'Input text'
    AlphaBlend = False
    AlphaBlendValue = 200
    AlphaBlendAnimation = False
    ButtonSkinDataName = 'button'
    MemoSkinDataName = 'memo'
    DefaultButtonFont.Charset = DEFAULT_CHARSET
    DefaultButtonFont.Color = clWindowText
    DefaultButtonFont.Height = 14
    DefaultButtonFont.Name = 'Arial'
    DefaultButtonFont.Style = []
    DefaultMemoFont.Charset = DEFAULT_CHARSET
    DefaultMemoFont.Color = clWindowText
    DefaultMemoFont.Height = 14
    DefaultMemoFont.Name = 'Arial'
    DefaultMemoFont.Style = []
    UseSkinFont = True
    Left = 40
    Top = 388
  end
  object dlgTextInput: TbsSkinTextDialog
    ShowToolBar = True
    ClientWidth = 350
    ClientHeight = 200
    Caption = 'Input text'
    AlphaBlend = False
    AlphaBlendValue = 200
    AlphaBlendAnimation = False
    ButtonSkinDataName = 'button'
    MemoSkinDataName = 'memo'
    DefaultButtonFont.Charset = DEFAULT_CHARSET
    DefaultButtonFont.Color = clWindowText
    DefaultButtonFont.Height = 14
    DefaultButtonFont.Name = 'Arial'
    DefaultButtonFont.Style = []
    DefaultMemoFont.Charset = DEFAULT_CHARSET
    DefaultMemoFont.Color = clWindowText
    DefaultMemoFont.Height = 14
    DefaultMemoFont.Name = 'Arial'
    DefaultMemoFont.Style = []
    UseSkinFont = True
    Left = 72
    Top = 388
  end
  object mnuPrintOptions: TbsSkinPopupMenu
    Left = 104
    Top = 388
    object mnuPrintPreview: TMenuItem
      Caption = 'Preview'
      Checked = True
      RadioItem = True
    end
    object mnuPrinter: TMenuItem
      Caption = 'Printer'
      RadioItem = True
    end
  end
  object bsSkinInputDialog1: TbsSkinInputDialog
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
    Left = 140
    Top = 388
  end
  object ImageList1: TImageList
    Left = 176
    Top = 388
    Bitmap = {
      494C010103000400040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      000000000000360000002800000040000000100000000100180000000000000C
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
      00000000FF00FF80008080008080008000000000000000000000000000000000
      0000000000000000000000000000000000000000800080000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000C0C0C080808080808080808000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00FF00FFFF00FFFF00FFFF00FF80008080008000000000000000000000000000
      0000000000000000000000000000000000800080800080800080800080000000
      0000000000000000000000000000000000000000000000000000000000000000
      00C0C0C0C0C0C0C0C0C0C0C0C080808080808000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      FFFF00FFFF00FF800080FF00FFFF00FF80008080008000000000000000000000
      0000000000000000000000000000800080800080800080000000800080800080
      000000000000000000000000000000000000000000000000000000000000C0C0
      C0C0C0C0C0C0C0808080C0C0C0C0C0C080808080808000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      FFFF00FFFF00FFFF00FF800080FF00FFFF00FF80008000000000000000000000
      0000000000000000000000000000800080C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
      800080000000000000000000000000000000000000000000000000000000C0C0
      C0C0C0C0C0C0C0C0C0C0808080C0C0C0C0C0C080808000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C0C0
      C0FF00FFC0C0C0FF00FFFF00FFFF00FFFF00FF80008000000000000000000000
      0000000000000000000000000000C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
      C0C0C0C0C0C0000000000000000000000000000000000000000000000000FFFF
      FFC0C0C0FFFFFFC0C0C0C0C0C0C0C0C0C0C0C080808000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00C0C0C0FF00FFC0C0C0FF00FFFF00FFFF00FF00000000000000000000000000
      0000000000000000000000000000000000000000C0C0C0C0C0C0C0C0C0C0C0C0
      0000000000000000000000000000000000000000000000000000000000000000
      00FFFFFFC0C0C0FFFFFFC0C0C0C0C0C0C0C0C000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000C0C0C0FF00FFC0C0C0FF00FF00000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FFFFFFC0C0C0FFFFFFC0C0C000000000000000000000000000000000
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
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF00FFFFFFFFFFFF0000FFFFFFFFFFFF0000
      FFFFFFFFFFFF0000FFFFFFFFFFFF0000FC3FFC3FFC3F0000F81FF81FF81F0000
      F00FF00FF00F0000F00FF00FF00F0000F00FF00FF00F0000F81FFC3FF81F0000
      FC3FFFFFFC3F0000FFFFFFFFFFFF0000FFFFFFFFFFFF0000FFFFFFFFFFFF0000
      FFFFFFFFFFFF0000FFFFFFFFFFFF000000000000000000000000000000000000
      000000000000}
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
    Left = 212
    Top = 388
  end
end
