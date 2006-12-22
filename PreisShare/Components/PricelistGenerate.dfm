object PricelistGenerator: TPricelistGenerator
  Left = 0
  Top = 0
  Width = 796
  Height = 477
  TabOrder = 0
  object pnlBack: TbsSkinPanel
    Left = 0
    Top = 0
    Width = 796
    Height = 477
    TabOrder = 2
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
    Caption = 'pnlBack'
    Align = alClient
    object lblStatus: TbsSkinStdLabel
      Left = 56
      Top = 164
      Width = 85
      Height = 13
      UseSkinFont = True
      DefaultFont.Charset = DEFAULT_CHARSET
      DefaultFont.Color = clWindowText
      DefaultFont.Height = -11
      DefaultFont.Name = 'MS Sans Serif'
      DefaultFont.Style = []
      SkinDataName = 'stdlabel'
      Caption = 'Processing Status'
    end
    object lblListCount: TbsSkinStdLabel
      Left = 212
      Top = 164
      Width = 88
      Height = 13
      UseSkinFont = True
      DefaultFont.Charset = DEFAULT_CHARSET
      DefaultFont.Color = clWindowText
      DefaultFont.Height = -11
      DefaultFont.Name = 'MS Sans Serif'
      DefaultFont.Style = []
      SkinDataName = 'stdlabel'
      Alignment = taCenter
      Caption = '0 Customers found'
      OnClick = lblListCountClick
    end
    object btnList: TbsSkinSpeedButton
      Left = 308
      Top = 160
      Width = 73
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
      Caption = 'Browse List'
      ShowCaption = True
      NumGlyphs = 1
      Spacing = 1
      OnClick = btnListClick
    end
    object btnPreview: TbsSkinSpeedButton
      Left = 308
      Top = 192
      Width = 73
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
      Caption = 'Preview'
      ShowCaption = True
      NumGlyphs = 1
      Spacing = 1
      OnClick = btnPreviewClick
    end
    object btnGenerate1: TbsSkinSpeedButton
      Left = 16
      Top = 260
      Width = 77
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
      Caption = 'Process One'
      ShowCaption = True
      NumGlyphs = 1
      Spacing = 1
      OnClick = btnGenerate1Click
    end
    object pnlSettings: TbsSkinGroupBox
      Left = 16
      Top = 12
      Width = 173
      Height = 145
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
      Caption = 'Settings'
      object cbxSpecialsOnly: TbsSkinCheckRadioBox
        Left = 8
        Top = 28
        Width = 137
        Height = 25
        TabOrder = 0
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
        Caption = 'Specials Only'
      end
      object cbxNewProducts: TbsSkinCheckRadioBox
        Left = 8
        Top = 92
        Width = 150
        Height = 25
        TabOrder = 1
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
        Caption = 'New Products'
        Enabled = False
      end
      object cbxFullPricelist: TbsSkinCheckRadioBox
        Left = 8
        Top = 116
        Width = 114
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
        Checked = False
        GroupIndex = 0
        Caption = 'Full Pricelists'
        Enabled = False
      end
      object cbxTemplateName: TbsSkinComboBox
        Left = 32
        Top = 72
        Width = 133
        Height = 20
        TabOrder = 3
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
        HideSelection = False
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
        Text = 'SpecialsListing.html'
        Items.Strings = (
          'SpecialsListing.html')
        ItemIndex = 0
        DropDownCount = 8
        HorizontalExtent = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = 14
        Font.Name = 'Arial'
        Font.Style = []
        Sorted = False
        Style = bscbFixedStyle
      end
      object lblTemplateName: TbsSkinLabel
        Left = 32
        Top = 52
        Width = 133
        Height = 21
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
        Caption = 'Template Name'
        AutoSize = False
      end
    end
    object mmoLog: TbsSkinMemo
      Left = 200
      Top = 12
      Width = 181
      Height = 145
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = 14
      Font.Name = 'Arial'
      Font.Style = []
      Lines.Strings = (
        ''
        'This utility will generate and send '
        'pricelists to all customers on the '
        'Custom-Pricelist and Email '
        'Distribution List.'
        ''
        'When you are ready, click on the '
        '[Process] button and processing '
        'and sending will commence.')
      ParentFont = False
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 0
      DefaultFont.Charset = DEFAULT_CHARSET
      DefaultFont.Color = clWindowText
      DefaultFont.Height = 14
      DefaultFont.Name = 'Arial'
      DefaultFont.Style = []
      UseSkinFont = True
      BitMapBG = False
      SkinDataName = 'memo'
    end
    object lsvItems: TbsSkinListView
      Left = 100
      Top = 232
      Width = 250
      Height = 66
      Columns = <>
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = 14
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      Visible = False
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
    object dbgCustomerList: TbsSkinDBGrid
      Left = 12
      Top = 308
      Width = 173
      Height = 145
      TabOrder = 2
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
      DataSource = DataSource1
      ReadOnly = True
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
    end
  end
  object btnGenerateAll: TbsSkinButton
    Left = 16
    Top = 230
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
    Caption = '&Process All'
    NumGlyphs = 1
    Spacing = 1
    OnClick = btnGenerateAllClick
  end
  object sgProgress: TbsSkinGauge
    Left = 16
    Top = 187
    Width = 177
    Height = 20
    TabOrder = 1
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
    Value = 0
    Vertical = False
  end
  object qryFindTargets: TQuery
    Left = 220
    Top = 12
  end
  object SmtpCli1: TSmtpCli
    Tag = 0
    Host = 'mail.preisshare.net'
    LocalAddr = '0.0.0.0'
    Port = 'smtp'
    Username = 'david.lyon@preisshare.net'
    Password = 'starwars92'
    AuthType = smtpAuthLogin
    FromName = 'david.lyon@preisshare.net'
    RcptName.Strings = (
      'bth22749@bigpond.net.au')
    MailMessage.Strings = (
      '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">'
      ''
      '<html>'
      '<head>'
      #9'<title>MailBuild Complex Newsletter Template</title>'
      '</head>'
      ''
      
        '<body bgcolor="#f1f1f1" font-size="10px" leftmargin="0" topmargi' +
        'n="0" rightmargin="0" bottommargin="0" marginwidth="0" marginhei' +
        'ght="0">'
      ''
      
        '<!-- CSS goes in <body> in case contents of <head> is stripped -' +
        '->'
      ''
      '<style>'
      
        'body,td { color: #000000; font-size: 12px; line-height: 14px; fo' +
        'nt-family: Verdana, Arial, Helvetica, sans-serif; }'
      
        'p { font-size: 12px; margin-top : 5px; margin-bottom : 10px; lin' +
        'e-height: 15px; font-family: Verdana, Arial, Helvetica, sans-ser' +
        'if; color: #333; }'
      'a { text-decoration: underline; color: #1e5c29; }'
      'a:hover { text-decoration: none; }'
      
        '.sideTitle { color: #000; font-size: 14px; font-weight: bold; pa' +
        'dding-bottom:5px; margin-bottom: 10px; border-bottom: 1px solid ' +
        '#a3a3a3; }'
      
        '.repeaterTitle { color: #1e5c29; font-size: 14px; font-weight: b' +
        'old; padding-bottom:5px; margin-bottom: 20px; border-bottom: 1px' +
        ' solid #d9d9d9; }'
      '.footerText, .footerText a { color: #fff; font-size: 11px; }'
      
        '.topNote { font-size: 10px; color: #656565; padding: 10px 0 8px ' +
        '0; }'
      '.topNote a { color: #3d3d3d; }'
      '.tocLink a, .sideText { font-size: 11px; }'
      '.imgBorder { border: 5px solid #e2e2e2; }'
      '</style>'
      ''
      
        '<!-- The entire email is wrapped in a table to make sure the bac' +
        'kground color is displayed if it'#39's stripped from the body tag --' +
        '>'
      ''
      
        '<table width="100%" bgcolor="#f1f1f1" cellpadding="0" cellspacin' +
        'g="0">'
      '<tr>'
      '<td valign="top" align="center">'
      ''
      #9'<!-- Link to web-based version of this email -->'
      ''
      
        #9'<table align="center" width="700" cellspacing="0" cellpadding="' +
        '0" border="0">'
      #9'<tr>'
      
        #9#9'<td class="topNote">Having trouble reading this newsletter? <a' +
        ' href="#">Click here</a> to see it in your browser.<br>You are r' +
        'eceiving this newsletter because you signed up from our web site' +
        '. <a href="#">Click here</a> to unsubscribe.</td>'
      #9'</tr>'
      #9'</table>'
      #9
      #9'<!-- Header table -->'
      #9
      
        #9'<table align="center" width="700" cellspacing="0" cellpadding="' +
        '0" border="0" bgcolor="#2f7e3d">'
      #9'<tr>'
      
        #9#9'<td><img src="header.jpg" alt="Widget Quarterly - ABC Widgets ' +
        'Quarterly Newsletter" width="700" height="174"></td>'
      #9'</tr>'
      #9'</table>'
      #9
      #9'<!-- Content table -->'
      #9
      
        #9'<table align="center" width="700" cellspacing="0" cellpadding="' +
        '0" border="0" bgcolor="ffffff">'
      #9'<tr>'
      
        #9#9'<td width="20" bgcolor="#e6e6e6"><img src="_space.gif" width="' +
        '20" height="1" border="0"></td>'
      #9#9'<td width="140" bgcolor="#e6e6e6" valign="top">'
      #9#9
      #9#9'<br><br>'
      #9#9
      #9#9'<p class="sideTitle">In this Issue</p>'
      #9#9
      #9#9'<table cellspacing="0" cellpadding="4" border="0">'
      #9#9'<tr>'
      
        #9#9'    <td valign="top"><img src="pointer.gif" width="3" height="' +
        '11" border="0"></td>'
      
        #9#9'    <td><span class="tocLink"><a href="#">Lorem ipsum dolor</a' +
        '></span></td>'
      #9#9'</tr>'
      #9#9'<tr>'
      
        #9#9'    <td valign="top"><img src="pointer.gif" width="3" height="' +
        '11" border="0"></td>'
      
        #9#9'    <td><span class="tocLink"><a href="#">Sit amet consectetue' +
        'r etiam sed</a></span></td>'
      #9#9'</tr>'
      #9#9'</table>'
      #9#9
      #9#9'<br><br>'
      #9#9
      #9#9'<p class="sideTitle">In Other News</p>'
      #9#9
      
        #9#9'<p class="sideText">Suspendisse lectus neque, eleifend id, dap' +
        'ibus a, fringilla vitae, justo. Suspendisse dictum tellus ut leo' +
        '. Etiam sed pede. Etiam magna quam, commodo a, pretium id, viver' +
        'ra sit amet, metus.</p>'
      ''
      #9#9'<br><br>'
      #9#9
      #9#9'</td>'
      
        #9#9'<td width="20" bgcolor="#e6e6e6"><img src="_space.gif" width="' +
        '20" height="1" border="0"></td>'
      
        #9#9'<td width="25"><img src="_space.gif" width="25" height="1" bor' +
        'der="0"></td>'
      #9#9'<td width="470" valign="top">'
      #9#9
      #9#9'<br><br>'
      #9#9
      #9#9'<!-- Email Content -->'
      #9#9
      
        #9#9'<p class="repeaterTitle">Lorem ipsum dolor sit amet, consectet' +
        'uer</p>'
      #9#9
      
        #9#9'<img class="imgBorder" src="surf.jpg" width="142" hspace="12" ' +
        'vspace="10" align="right">'
      #9#9#9#9
      
        #9#9'<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. E' +
        'tiam bibendum. Aliquam malesuada suscipit sem. Fusce elit est, v' +
        'olutpat id, posuere vel, sodales eget, nulla. Pellentesque vel t' +
        'urpis. Aliquam laoreet vulputate turpis. Curabitur ultricies orn' +
        'are augue. </p>'
      #9
      
        #9#9'<p>Sed pharetra, ante id commodo <a href="#">venenatis</a>, la' +
        'cus nibh tincidunt elit, vitae luctus urna nisi a leo. Ut rhoncu' +
        's purus eget dolor. In semper leo et risus. Nunc aliquam. Vestib' +
        'ulum interdum sapien ut turpis cursus mattis. Nunc rhoncus est v' +
        'itae metus. Sed ut lectus. Nunc rhoncus quam ut leo.</p>'
      ''
      #9#9'<br>'
      #9#9
      
        #9#9'<p class="repeaterTitle">Lorem ipsum dolor sit amet, consectet' +
        'uer</p>'
      #9#9
      
        #9#9'<img class="imgBorder" src="surf2.jpg" width="142" hspace="12"' +
        ' vspace="10" align="right">'
      #9#9#9#9
      
        #9#9'<p>Curabitur ut urna sed elit interdum venenatis. Nullam tinci' +
        'dunt. Pellentesque accumsan consequat purus. Nullam feugiat erat' +
        '. Praesent bibendum lacus ut massa. <a href="#">Praesent non dol' +
        'or</a> sit amet velit mattis iaculis. Donec eget felis sodales e' +
        'rat pretium adipiscing. Sed fringilla enim vel orci. In hac habi' +
        'tasse platea dictumst. Ut tempor nisl in enim. Pellentesque arcu' +
        '.</p>'
      #9
      
        #9#9'<p>Curabitur eu justo. Integer ac sem eget dolor aliquet viver' +
        'ra. Curabitur eget orci vitae nibh scelerisque volutpat. Quisque' +
        ' quis lectus. Vestibulum sem libero, vehicula a, pulvinar a, cur' +
        'sus quis, est. Phasellus purus lacus, ornare quis, suscipit ac, ' +
        'scelerisque vel, urna.</p>'
      ''
      #9#9'<br><br>'
      #9#9
      #9#9'</td>'
      
        #9#9'<td width="25"><img src="_space.gif" width="25" height="1" bor' +
        'der="0"></td>'
      #9'</tr>'
      #9'</table>'
      #9
      #9'<!-- Unsubscribe -->'
      #9
      
        #9'<table align="center" width="700" cellspacing="0" cellpadding="' +
        '00" border="0" bgcolor="#333333">'
      #9'<tr>'
      
        #9#9'<td width="25"><img src="_space.gif" width="25" height="1" bor' +
        'der="0"></td>'#9
      
        #9#9'<td width="325"><span class="footerText">This email was sent t' +
        'o [email]<br><strong><a href="#">Click here</a></strong> to <em>' +
        'instantly</em> unsubscribe.</span></td>'
      
        #9#9'<td width="225" align="right"><img src="/_space.gif" width="1"' +
        ' height="15" border="0"><br><span class="footerText"><strong><a ' +
        'href="#">ABC Widgets</a></strong><br>20 Cog St, Widget Town, CA ' +
        '90210<br>1-847-258-3657</span><br><img src="/_space.gif" width="' +
        '1" height="15" border="0"><br></td>'
      
        #9#9'<td width="25"><img src="_space.gif" width="25" height="1" bor' +
        'der="0"></td>'#9
      #9'</tr>'
      #9'</table>'
      #9
      #9'<br><br>'
      ''
      #9'</td>'
      '</tr>'
      '</table>'
      ''
      '</body>'
      '</html>')
    HdrFrom = 'david.lyon@preisshare.net'
    HdrTo = 'Brad Thomas'
    HdrSubject = 'CSS Email Test'
    CharSet = 'iso-8859-1'
    ContentType = smtpHTML
    OwnHeaders = False
    OnDisplay = SmtpCli1Display
    OnRequestDone = SmtpCli1RequestDone
    EmailFiles.Strings = (
      'D:\PreisShare\PreisShare\Email Templates\header.jpg'
      'D:\PreisShare\PreisShare\Email Templates\_space.gif'
      'D:\PreisShare\PreisShare\Email Templates\pointer.gif'
      'D:\PreisShare\PreisShare\Email Templates\surf.jpg'
      'D:\PreisShare\PreisShare\Email Templates\surf2.jpg')
    Left = 252
    Top = 12
  end
  object DataSource1: TDataSource
    DataSet = qryFindTargets
    Left = 184
    Top = 12
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
    Left = 284
    Top = 12
  end
end
