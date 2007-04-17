object frmQuote: TfrmQuote
  Left = 216
  Top = 143
  AutoScroll = False
  BorderIcons = []
  Caption = 'Quick Quote..'
  ClientHeight = 397
  ClientWidth = 610
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object btnClose: TbsSkinButton
    Left = 524
    Top = 348
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
    Caption = 'Close'
    NumGlyphs = 1
    Spacing = 1
    OnClick = btnCloseClick
  end
  object btnSend: TbsSkinButton
    Left = 8
    Top = 344
    Width = 75
    Height = 25
    TabOrder = 1
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
    Caption = 'Send'
    NumGlyphs = 1
    Spacing = 1
    OnClick = btnSendClick
  end
  object pnlProductInfo: TbsSkinGroupBox
    Left = 8
    Top = 16
    Width = 381
    Height = 317
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
    Caption = 'Product'
    object bvlPicture: TbsSkinBevel
      Left = 12
      Top = 32
      Width = 165
      Height = 106
      SkinDataName = 'bevel'
      DividerMode = False
    end
    object lblImageName: TbsSkinStdLabel
      Left = 72
      Top = 80
      Width = 50
      Height = 13
      UseSkinFont = True
      DefaultFont.Charset = DEFAULT_CHARSET
      DefaultFont.Color = clWindowText
      DefaultFont.Height = -11
      DefaultFont.Name = 'MS Sans Serif'
      DefaultFont.Style = []
      SkinDataName = 'stdlabel'
      Caption = 'No Picture'
    end
    object bsSkinLabel2: TbsSkinLabel
      Left = 12
      Top = 148
      Width = 357
      Height = 21
      TabOrder = 0
      SkinData = frmMain.bsSkinData1
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
    object txtProductName: TbsSkinEdit
      Left = 12
      Top = 168
      Width = 357
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
      SkinData = frmMain.bsSkinData1
      SkinDataName = 'edit'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = 14
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
    object txtDescription: TbsSkinMemo
      Left = 12
      Top = 196
      Width = 357
      Height = 105
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = 14
      Font.Name = 'Arial'
      Font.Style = []
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
    end
    object txtProductAmount: TbsSkinMaskEdit
      Left = 292
      Top = 116
      Width = 77
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
      SkinData = frmMain.bsSkinData1
      SkinDataName = 'edit'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = 14
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      AutoSize = False
      BorderStyle = bsNone
    end
    object bsSkinLabel1: TbsSkinLabel
      Left = 292
      Top = 96
      Width = 75
      Height = 21
      TabOrder = 4
      SkinData = frmMain.bsSkinData1
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
      Alignment = taRightJustify
      Caption = 'Sell Price'
      AutoSize = False
    end
    object txtPLU: TbsSkinEdit
      Left = 288
      Top = 64
      Width = 65
      Height = 20
      Text = 'txtPLU'
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
      Visible = False
    end
    object bsSkinLabel4: TbsSkinLabel
      Left = 204
      Top = 96
      Width = 75
      Height = 21
      TabOrder = 6
      SkinData = frmMain.bsSkinData1
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
      Alignment = taRightJustify
      Caption = 'Quantity'
      AutoSize = False
    end
    object txtQuantity: TbsSkinMaskEdit
      Left = 204
      Top = 116
      Width = 77
      Height = 20
      Text = '1'
      DefaultFont.Charset = DEFAULT_CHARSET
      DefaultFont.Color = clWindowText
      DefaultFont.Height = 14
      DefaultFont.Name = 'Arial'
      DefaultFont.Style = []
      UseSkinFont = True
      DefaultWidth = 0
      DefaultHeight = 20
      ButtonMode = False
      SkinData = frmMain.bsSkinData1
      SkinDataName = 'edit'
      Alignment = taRightJustify
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = 14
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 7
      AutoSize = False
      BorderStyle = bsNone
    end
  end
  object lblTrader: TbsSkinLabel
    Left = 8
    Top = 16
    Width = 337
    Height = 21
    TabOrder = 3
    SkinData = frmMain.bsSkinData1
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
    Caption = 'Customer/Prospect'
    AutoSize = False
  end
  object btnNext: TbsSkinButton
    Left = 8
    Top = 344
    Width = 75
    Height = 25
    TabOrder = 4
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
    Caption = 'Next >>'
    NumGlyphs = 1
    Spacing = 1
    OnClick = btnNextClick
  end
  object bsSkinGroupBox2: TbsSkinGroupBox
    Left = 404
    Top = 16
    Width = 193
    Height = 317
    TabOrder = 5
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
    Caption = 'Editing the Product'
    object Image2: TImage
      Left = 41
      Top = 33
      Width = 101
      Height = 153
      Picture.Data = {
        0A544A504547496D616765A60C0000FFD8FFE000104A46494600010101004800
        480000FFDB00430006040506050406060506070706080A100A0A09090A140E0F
        0C1017141818171416161A1D251F1A1B231C1616202C20232627292A29191F2D
        302D283025282928FFDB0043010707070A080A130A0A13281A161A2828282828
        2828282828282828282828282828282828282828282828282828282828282828
        28282828282828282828282828FFC00011080096006403011100021101031101
        FFC4001D000001050101010100000000000000000002010304050600070809FF
        C4003A1000010303020207050702070000000000010002030405110621123107
        1341515261711422323342081516238191D134E1436272A1A2B2C1FFC4001B01
        000301010101010000000000000000000001020304050607FFC4002711000202
        0202020201040300000000000000010211031221310413224151143233612371
        81FFDA000C03010002110311003F0085824AFBA3F3AB083494087046718C652D
        905317AA3DC96C83567184E0046C87AB13D9C946E2D0EF6728DD0BD603A9F9EC
        9A9213831A753954A48871632E808EC4F80B6869F114E81646869CC5346AB281
        C1E49517ED34420F7B92CF71E83CDA7F250E65AC63ECA659B99A2C618A61952F
        217EA0C5363B12F60FD42FB30EE4BD83F51DECDE48F60BD409A5CEC064A7EC0F
        51322D3B552C0E9380330321AEE6E50FCA8A746ABC09CA365549465A482371CC
        2E8594E4960A224B4BE4B48E43096122C94BE4B453B3178DA1AF67F257B11AB3
        50D837E4BCEDCF61407990792CDCCD1407990F928722D40310A5B15A8421F249
        C87A05D4F925B0F5275159A7A9C38B7AB6789DFC2896548DA1E3CA7FD17F4769
        A7A5C16B789FE27735CF2C8E476E3C11873F649744A6CD1A28EF76813E6681BF
        9BF50F17F75D18B2EBC338BC8F1D4FE51ECCBCB4D8241183DCBAD4CF3658C892
        52F92D564319621A349BF257EC23D25E363DD71B91E86A3AD8F96CA1B294475B
        1A9722921C6C5E4A762B527D1DA27A8C12DE06789DFC2CE595236878F2917949
        69829B07878DFE272C5E56CEB8608C09A181459AD1C588B0A05D1E55262A1B74
        59F44F6268A9BB59C5434C9080250397896B8F2D70CE7CDE3EFCC7B32B2D396B
        8B5C3046CBAD48F3A50AEC64C3BAAD88D0B06B3758B67450F36350D949163436
        B9EA483C3C0CF139672C891BE3C1291771D152503439FEFBFB0BB73FA058ED29
        F475C71461CB1D0EAAA8F92C1133C4EE697C63D9A7CA5D042D8E78CCD51238F9
        6C97B6BA41EBBED9CEB44447CC941EFE247B987A909F774ACDE1A97FA3B74D65
        4FB4278DAE98DBA6A8A6FEAA2E26F8DA9A5197ED626E51EC990164CC0E8DC1CD
        50ED70CB54FA1C74594AC74535EAD02A5865846260371E25B63CBAF0CE6CFE3E
        EB65D994745C24870C11CC2EBD8F3B52D28ADB3D49CB5BC2C3F5396329A47443
        0CA7D1A0A2B4C1061CE1D63FBCFF000B9E591B3B31E08C7B25554FD480C8C714
        8EF85AA52BE59AB75C216968B0EEB6A0F1CA7BF904A53FA45461F6C9CB32CE40
        8403640088038B4118232100409A91D4EF3351EDE267615AA9EDC48CDC6B9892
        E966654C5C4CD8F223B96728B8B2E2ED586E6A13195F516AA59E5324917BC79A
        D6391A54612C1193B2586EF8C2936A165736189D23B90092E5D03E111E8212E2
        6A25DDEFE5E4139CBE90A2BED93D665898CA005C24238F240C4C2602A041B5A9
        0D15958C34352DA98FE538E241FF00AB58BDD6AC892D5DA2C7673439BB83BACC
        D04C20281C276220D713354C14C3913C4EF45A4384E444B96916006060762CAC
        B3B0900A1001610003DCD8D85F239AD68E65C70022E83B3CEBA58E90AB7434B6
        E10D9CD5535438192A5EFC3000776371F5637C9DBD77C3716E368A86ADD336DA
        6EF143A86CF4D73B5CC25A59DB907B5A7B5A4761076214295838B8BA2D7B1301
        AA9884F03E370D9C309C5D3B1356A8856290BE9DF0C9BBE171615A6554EFF246
        276ABF05986ECB23523E32551041A76F1DD6779FA5A005A4B88244A5F2658E36
        591747610142E10214040CC1F4C5A36AB5869830DBAAA58AB698996287AC2239
        CF85C3967B89E47D5355F634E8C3746BAA29B5BD9EA741EBA8DDF7946D31C6F9
        7DD924E1ECDF948DC7EA07AE5293C6CA9414BE48CEE9CB95CFA16D732DA2F2E7
        CDA7EB1DC5D6069C16F212B4778E4E1FD94E4853DE25425BAD5F67D2B4D3C555
        4F14F4D2325825687B1EC390E6919041EE4269AB44354E98F26057DBE2EAEE75
        98E4EC1573771444153659E1646A4503756408D8DAD90B8632E1BA2DB1B54388
        11C801404828F16E93F5A569E9068F487DE2FB1DA660CF69AF8C625707827DD7
        1F85B9C373D8739DB6447965D52B32962A6BCE9BE940D1F47B729F515BC169AB
        63A42626827DE6C8FF008388730E1E98CE426FFB1F68D4F4C9A21B7B85BAC346
        CAC75D691D99FD91E099780FC4D2DFADA47A9C778DDF7C3262F53416EB3C9D27
        F4754B16B6B64F6FAF63B2C9C3431E48C7E6341F84386C411E9D8A632A4D0492
        4D346EB4D5928B4E5969AD76C6C8DA4A76E18247979DCE49C9F3FD124A86DEDC
        96794C92250CE0DD6AA11CF8415538FC531425F268B4E12B1352005A999024A8
        743778A27FCB95A784F985A28DC5B21CAA4932C966599DE90EED5D62D1975B9D
        AA0135653C5C51B48C81B805C47680093FA289CB545423B3A3C2748EB9D3C61A
        6BB6A7D41A9BF11366324BD4C9F944676606FC3C04632303B56AB8E989A7CAA3
        79A968B4EF4CFA6A69F4ED435B79A0F94E95BC0F6E77E078F0BBB0EF83FA8312
        4E3F2438CAB8652F4772748F65B41D3349A669695F1B9DC372A90191C609DC9E
        1DA43DC467B3394B78BFA1B8FDD9EADA134D0D2B611406A9F573C92BEA2799CD
        E1E391E72E21BD83C91CF6C86EFA34498048010EC3279200ACD383AEABAFABFA
        5D27034F90D9699DD25133C0ADB917CB94E8200E656E6656DFA99F2D2B6687E7
        4078DBE6B4C52A74FECCF245B568956EAB656D247330FC4371DC54CE3ABA2A12
        525649C02082320F3CA87CF0CA301AB74E43413C1358F4058AF31C9C5D7B4B62
        8640EEC2389B8C77EF959D4570D3FF00868A527CEC41E87FA3CAAD2D5F74BCDC
        CD3D3D5DC321B434A7315330BB8B873DA46C063901CCE5526EA853A6CF514C83
        9301004802C24515B7DAA3052F550EF3CC78231E67B56B8636EDF48C72CA952E
        D96369A36D0D0430379B46E7BCACB24F79366D8E3A452266166595D8016E4060
        6763C926067670FB0D7BA7634BADD31CBC0FF0DDDFE8BA22D658D3ED1CF25EB9
        5AE8D04323268DB246E0E6BB7042E76AB866C9DAB43814941200E23640098458
        0A8018ADAB8A8E074B33C35A3FDD5420E6E91129282B641B2D24B59546E55AD2
        D2768633F4B7BFD4ABCB3505EB8938A2E4F791A05CC741C1005603BADC80C148
        04918D9585923439AE1820A2EB942ECA19A8EB6CCF32DB419E909CBA9C9DC7FA
        7F85BA9C722A9F7F9307094398744DB75FE8AACF56E798671CE29470B8289E09
        4795CA2A39A2F87C32D9AE0E1969047AAC4D530BB10305CF63065EE00799424D
        8ACA9ABBEC22430D135D5751CB863DC0F53C82DE3E3BEE7C2319675750E58B43
        699EA676D55DDC1CF1BB216FC2CFE4A53CCA2B5C6543136F6C9D9A11803000C2
        E43A04CA68068CEC69C6E7CD5E8C8DC8216801848036EC9300C14868895B68A1
        B80C5553B1E7B0E37551CB2874C99638CFB467EFD607DB6D755576CB85553BA1
        8DCF0D2FE26EC3B8ADF1F91BC929A4CC6781455C5D1E69D166B6BA6B4A996926
        B94B0543242DC35837031BF256F3436E21C0D6196BCCDD9EB5169689EFE2AEAB
        A9AAFF002BDE437F61B2CDF98D2F82485FA58BFDCDB2F68E869A8E30CA68591B
        47705CD3C929BB933A2308C5524495051C480327608484DD11E5909DB905A254
        632936305590320A66E1B4A401829006DE6A5821D69C2928A2D795B151E91BAC
        D33DAD68A77F33E4B5C11F9A2323F8B3C3BECBDA6279A9AB753F5CD14ECA9740
        23ED3B3493FF0020A77A935F92DAF89F49039E4B318412014EC374D225C861EE
        279AB48C9B19715443606531119A7754CE81CCECA4036BB640060F7240830E2A
        4A3E7DFB57DE2AA8E86D9494F33991CE5DC6D0719185AA9B86375F6438A94B93
        C6F44F49B7ED29A72BEC36C74228ABA40F739CD25F19D812D39DB200FD963075
        24CD1F29A3ED9D2952FACD3B6FA890F13E4818E27CF0AB346A6D233C72B8A65B
        970036E7DEA120721A73B2A9221B197395512D8DB8EC99206500300AB674041C
        A491C6A4341B4A430C148A3E62FB5C4F9BB59E1CFC2C73954F882257EE67CFF0
        FCC6FAACA3D94FA3F4234448DFC256A0CD9BECECC7EC174675FE491C5E349BC5
        16FF0005D17ACA8D6C02E4C5634F29886F89007653A246B1BAA3A820D5201809
        0061A90D0E00958CF94BED685C356DB5B9DBA838FDC2BCAAB1C5FF00B3384AE7
        28FE28F0B88E1E3D560BB353EFEE8E1E64D116771E66999FF50BAFC8FE4679DE
        2FF123485646EC12810050032F187653242401FFD9}
    end
    object xplEditProducts: TbsSkinTextLabel
      Left = 32
      Top = 204
      Width = 117
      Height = 52
      UseSkinFont = True
      Lines.Strings = (
        'You can edit the product'
        'details before they are'
        'written onto the quote.')
      DefaultFont.Charset = DEFAULT_CHARSET
      DefaultFont.Color = clWindowText
      DefaultFont.Height = -11
      DefaultFont.Name = 'MS Sans Serif'
      DefaultFont.Style = []
      SkinDataName = 'stdlabel'
    end
    object xplKeyClient: TbsSkinTextLabel
      Left = 32
      Top = 252
      Width = 113
      Height = 78
      UseSkinFont = True
      Lines.Strings = (
        'Now key the name and'
        'address of the client or'
        'prospect that you would'
        'like to appear on the '
        'Quote.')
      DefaultFont.Charset = DEFAULT_CHARSET
      DefaultFont.Color = clWindowText
      DefaultFont.Height = -11
      DefaultFont.Name = 'MS Sans Serif'
      DefaultFont.Style = []
      SkinDataName = 'stdlabel'
      Visible = False
    end
    object xplEmail: TbsSkinTextLabel
      Left = 108
      Top = 219
      Width = 124
      Height = 65
      UseSkinFont = True
      Lines.Strings = (
        'Now set the email address'
        'subject and body like you'
        'would in a normal email'
        'message.')
      DefaultFont.Charset = DEFAULT_CHARSET
      DefaultFont.Color = clWindowText
      DefaultFont.Height = -11
      DefaultFont.Name = 'MS Sans Serif'
      DefaultFont.Style = []
      SkinDataName = 'stdlabel'
      Visible = False
    end
  end
  object grpPreview: TbsSkinGroupBox
    Left = 416
    Top = 16
    Width = 381
    Height = 317
    TabOrder = 6
    Visible = False
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
    Caption = 'Email Details'
    object bsSkinStdLabel2: TbsSkinStdLabel
      Left = 8
      Top = 32
      Width = 16
      Height = 13
      UseSkinFont = True
      DefaultFont.Charset = DEFAULT_CHARSET
      DefaultFont.Color = clWindowText
      DefaultFont.Height = -11
      DefaultFont.Name = 'MS Sans Serif'
      DefaultFont.Style = []
      SkinData = frmMain.bsSkinData1
      SkinDataName = 'stdlabel'
      Caption = 'To:'
    end
    object bsSkinStdLabel3: TbsSkinStdLabel
      Left = 8
      Top = 56
      Width = 26
      Height = 13
      UseSkinFont = True
      DefaultFont.Charset = DEFAULT_CHARSET
      DefaultFont.Color = clWindowText
      DefaultFont.Height = -11
      DefaultFont.Name = 'MS Sans Serif'
      DefaultFont.Style = []
      SkinData = frmMain.bsSkinData1
      SkinDataName = 'stdlabel'
      Caption = 'From:'
    end
    object bsSkinStdLabel4: TbsSkinStdLabel
      Left = 8
      Top = 80
      Width = 39
      Height = 13
      UseSkinFont = True
      DefaultFont.Charset = DEFAULT_CHARSET
      DefaultFont.Color = clWindowText
      DefaultFont.Height = -11
      DefaultFont.Name = 'MS Sans Serif'
      DefaultFont.Style = []
      SkinData = frmMain.bsSkinData1
      SkinDataName = 'stdlabel'
      Caption = 'Subject:'
    end
    object mmoLog: TbsSkinMemo2
      Left = 8
      Top = 216
      Width = 365
      Height = 89
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = 14
      Font.Name = 'Arial'
      Font.Style = []
      Lines.Strings = (
        'Ready to send')
      ParentFont = False
      ScrollBars = ssBoth
      TabOrder = 0
      DefaultFont.Charset = DEFAULT_CHARSET
      DefaultFont.Color = clWindowText
      DefaultFont.Height = 14
      DefaultFont.Name = 'Arial'
      DefaultFont.Style = []
      UseSkinFont = True
      SkinData = frmMain.bsSkinData1
      SkinDataName = 'memo'
    end
    object bsSkinLabel3: TbsSkinLabel
      Left = 8
      Top = 196
      Width = 365
      Height = 21
      TabOrder = 1
      SkinData = frmMain.bsSkinData1
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
      Caption = 'Log'
      AutoSize = False
    end
    object txtRecipient: TbsSkinEdit
      Left = 56
      Top = 28
      Width = 317
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
      SkinData = frmMain.bsSkinData1
      SkinDataName = 'edit'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = 14
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
    end
    object txtOriginator: TbsSkinEdit
      Left = 56
      Top = 52
      Width = 317
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
      SkinData = frmMain.bsSkinData1
      SkinDataName = 'edit'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = 14
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
    end
    object txtSubject: TbsSkinEdit
      Left = 56
      Top = 76
      Width = 317
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
      SkinData = frmMain.bsSkinData1
      SkinDataName = 'edit'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = 14
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
    end
    object mmoBodyText: TbsSkinMemo
      Left = 56
      Top = 104
      Width = 317
      Height = 77
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
      SkinData = frmMain.bsSkinData1
      SkinDataName = 'memo'
    end
  end
  object dlgSendProgress: TbsSkinGauge
    Left = 96
    Top = 348
    Width = 293
    Height = 20
    TabOrder = 7
    Visible = False
    SkinData = frmMain.bsSkinData1
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
  object tfrLog: TMemo
    Left = 408
    Top = 312
    Width = 105
    Height = 57
    Lines.Strings = (
      'tfrLog')
    TabOrder = 8
    Visible = False
  end
  object btnMore: TbsSkinButton
    Left = 88
    Top = 344
    Width = 75
    Height = 25
    TabOrder = 9
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
    Caption = 'Add More..'
    NumGlyphs = 1
    Spacing = 1
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
    MinHeight = 0
    MinWidth = 0
    Magnetic = False
    MagneticSize = 5
    BorderIcons = [biSystemMenu, biMinimize, biMaximize, biRollUp]
    Left = 140
    Top = 8
  end
  object XMLQuote: TXMLDocument
    Left = 240
    Top = 4
    DOMVendorDesc = 'MSXML'
  end
  object SmtpEmail: TSmtpCli
    Tag = 0
    ShareMode = smtpShareDenyWrite
    LocalAddr = '0.0.0.0'
    Port = 'smtp'
    AuthType = smtpAuthLogin
    ConfirmReceipt = False
    HdrPriority = smtpPriorityNone
    CharSet = 'iso-8859-1'
    SendMode = smtpToSocket
    DefaultEncoding = smtpEnc7bit
    Allow8bitChars = True
    FoldHeaders = False
    WrapMessageText = False
    ContentType = smtpPlainText
    OwnHeaders = False
    OnCommand = SmtpEmailCommand
    OnResponse = SmtpEmailResponse
    OnRcptToError = SmtpEmailRcptToError
    OnRequestDone = SmtpEmailRequestDone
    Left = 308
    Top = 8
  end
  object DataSource1: TDataSource
    Left = 504
    Top = 8
  end
  object xmlTransformation: TXMLDocument
    XML.Strings = (
      '<?xml version='#39'1.0'#39' encoding='#39'utf-8'#39'?>'
      
        '<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/' +
        'XSL/Transform">'
      '<xsl:output method="html" encoding="windows-1252"/>'
      '<xsl:template match="/">'
      #9'<html><head>'
      '<title/>'
      '</head>'
      '  <body dir="ltr" lang="en-US">'
      '  <p style="MARGIN-BOTTOM: 0cm">  <br/> </p>'
      ''
      
        '  <table FRAME="VOID" CELLSPACING="0" COLS="7" RULES="GROUPS" BO' +
        'RDER="0">'
      '    <TR>'
      
        #9'<TD WIDTH="48" HEIGHT="28" ALIGN="LEFT"><FONT FACE="Impact" SIZ' +
        'E="4"><BR/></FONT></TD>'
      
        #9'<TD COLSPAN="7" WIDTH="686" ALIGN="LEFT" BGCOLOR="#333333"><FON' +
        'T FACE="Impact" SIZE="4" COLOR="#FFFFFF"><xsl:value-of select="Q' +
        'uotation/SellerParty/Organisation_Name"/></FONT></TD>'
      '    </TR>'
      '    <TR>'
      
        #9'<TD HEIGHT="18" ALIGN="LEFT"><FONT FACE="Times New Roman"><BR/>' +
        '</FONT></TD>'
      
        #9'<TD COLSPAN="4" ALIGN="LEFT" BGCOLOR="#E6E6FF"><xsl:value-of se' +
        'lect="Quotation/SellerParty/Address_Line_1"/></TD>'
      #9'<TD ALIGN="LEFT"><FONT FACE="Times New Roman"><BR/></FONT></TD>'
      #9'<TD ALIGN="LEFT"><FONT FACE="Times New Roman"><BR/></FONT></TD>'
      '    </TR>'
      '    <TR>'
      
        #9'<TD HEIGHT="18" ALIGN="LEFT"><FONT FACE="Times New Roman"><BR/>' +
        '</FONT></TD>'
      
        #9'<TD COLSPAN="4" ALIGN="LEFT" BGCOLOR="#E6E6FF"><xsl:value-of se' +
        'lect="Quotation/SellerParty/Suburb_Town"/><xsl:value-of select="' +
        'Quotation/SellerParty/State_Region"/><xsl:value-of select="Quota' +
        'tion/SellerParty/Zip_Postcode"/></TD>'
      #9'<TD ALIGN="LEFT"><FONT FACE="Times New Roman"><BR/></FONT></TD>'
      #9'<TD ALIGN="LEFT"><FONT FACE="Times New Roman"><BR/></FONT></TD>'
      '    </TR>'
      '    <TR>'
      
        #9'<TD HEIGHT="18" ALIGN="LEFT"><FONT FACE="Times New Roman"><BR/>' +
        '</FONT></TD>'
      
        #9'<TD COLSPAN="4" ALIGN="LEFT" BGCOLOR="#E6E6FF">Telephone : <xsl' +
        ':value-of select="Quotation/SellerParty/Telephone"/></TD>'
      #9'<TD ALIGN="LEFT"><FONT FACE="Times New Roman"><BR/></FONT></TD>'
      #9'<TD ALIGN="LEFT"><FONT FACE="Times New Roman"><BR/></FONT></TD>'
      '    </TR>'
      '    <TR>'
      
        #9'<TD HEIGHT="18" ALIGN="LEFT"><FONT FACE="Times New Roman"><BR/>' +
        '</FONT></TD>'
      
        #9'<TD COLSPAN="4" ALIGN="LEFT" BGCOLOR="#E6E6FF"><xsl:value-of se' +
        'lect="Quotation/SellerParty/Other_Information"/></TD>'
      #9'<TD ALIGN="LEFT"><FONT FACE="Times New Roman"><BR/></FONT></TD>'
      #9'<TD ALIGN="LEFT"><FONT FACE="Times New Roman"><BR/></FONT></TD>'
      '    </TR>'
      '    <TR>'
      
        #9'<TD HEIGHT="47" ALIGN="LEFT" BGCOLOR="#333333"><FONT FACE="Time' +
        's New Roman"><BR/></FONT></TD>'
      
        #9'<TD COLSPAN="2" ALIGN="LEFT" BGCOLOR="#0099FF"><FONT FACE="Aria' +
        'l Black" SIZE="5">Quotation</FONT></TD>'
      
        #9'<TD COLSPAN="2" ALIGN="RIGHT" BGCOLOR="#B3B3B3"><FONT FACE="Ari' +
        'al Black" SIZE="6">#8185</FONT></TD>'
      
        #9'<TD ALIGN="LEFT" BGCOLOR="#0099FF"><FONT FACE="Times New Roman"' +
        '><BR/></FONT></TD>'
      
        #9'<TD ALIGN="LEFT" BGCOLOR="#0099FF"><FONT FACE="Times New Roman"' +
        '><BR/></FONT></TD>'
      '    </TR>'
      '    <TR>'
      
        #9'<TD HEIGHT="18" ALIGN="LEFT"><FONT FACE="Times New Roman"><BR/>' +
        '</FONT></TD>'
      #9'<TD ALIGN="LEFT" BGCOLOR="#E6E6FF">Name:</TD>'
      
        #9'<TD COLSPAN="3" ALIGN="LEFT" BGCOLOR="#E6E6FF"><xsl:value-of se' +
        'lect="Quotation/BuyerParty/Contact_Name"/></TD>'
      #9'<TD ALIGN="LEFT"><FONT FACE="Times New Roman"><BR/></FONT></TD>'
      #9'<TD ALIGN="LEFT"><FONT FACE="Times New Roman"><BR/></FONT></TD>'
      '    </TR>'
      '    <TR>'
      
        #9'<TD HEIGHT="18" ALIGN="LEFT"><FONT FACE="Times New Roman"><BR/>' +
        '</FONT></TD>'
      #9'<TD ALIGN="LEFT" BGCOLOR="#E6E6FF"><BR/></TD>'
      
        #9'<TD COLSPAN="3" ALIGN="LEFT" BGCOLOR="#E6E6FF"><xsl:value-of se' +
        'lect="Quotation/BuyerParty/Address_Line_1"/></TD>'
      #9'<TD ALIGN="LEFT"><FONT FACE="Times New Roman"><BR/></FONT></TD>'
      #9'<TD ALIGN="LEFT"><FONT FACE="Times New Roman"><BR/></FONT></TD>'
      '    </TR>'
      '    <TR>'
      
        #9'<TD HEIGHT="18" ALIGN="LEFT"><FONT FACE="Times New Roman"><BR/>' +
        '</FONT></TD>'
      #9'<TD ALIGN="LEFT" BGCOLOR="#E6E6FF"><BR/></TD>'
      
        #9'<TD COLSPAN="3" ALIGN="LEFT" BGCOLOR="#E6E6FF"><xsl:value-of se' +
        'lect="Quotation/BuyerParty/Suburb_Town"/><xsl:value-of select="Q' +
        'uotation/BuyerParty/State_Region"/><xsl:value-of select="Quotati' +
        'on/BuyerParty/Zip_Postcode"/></TD>'
      #9'<TD ALIGN="LEFT"><FONT FACE="Times New Roman"><BR/></FONT></TD>'
      #9'<TD ALIGN="LEFT"><FONT FACE="Times New Roman"><BR/></FONT></TD>'
      '    </TR>'
      '    <TR>'
      
        #9'<TD HEIGHT="18" ALIGN="LEFT"><FONT FACE="Verdana"><BR/></FONT><' +
        '/TD>'
      
        #9'<TD ALIGN="LEFT" BGCOLOR="#000000"><FONT FACE="Verdana" COLOR="' +
        '#FFFFFF">Salesperson</FONT></TD>'
      
        #9'<TD ALIGN="LEFT" BGCOLOR="#000000"><FONT FACE="Verdana"><BR/></' +
        'FONT></TD>'
      
        #9'<TD ALIGN="LEFT" BGCOLOR="#000000"><FONT FACE="Verdana"><BR/></' +
        'FONT></TD>'
      
        #9'<TD ALIGN="LEFT" BGCOLOR="#000000"><FONT FACE="Verdana" COLOR="' +
        '#FFFFFF">Date</FONT></TD>'
      
        #9'<TD ALIGN="LEFT" BGCOLOR="#000000"><FONT FACE="Verdana"><BR/></' +
        'FONT></TD>'
      
        #9'<TD ALIGN="LEFT" BGCOLOR="#000000"><FONT FACE="Verdana" COLOR="' +
        '#FFFFFF">Valid Till</FONT></TD>'
      '    </TR>'
      '    <TR>'
      
        #9'<TD HEIGHT="19" ALIGN="LEFT"><FONT FACE="Times New Roman"><BR/>' +
        '</FONT></TD>'
      
        #9'<TD ALIGN="LEFT" BGCOLOR="#E6E6FF"><FONT FACE="Verdana"><xsl:va' +
        'lue-of select="Quotation/Header_Information/Sales_Person"/></FON' +
        'T></TD>'
      
        #9'<TD ALIGN="LEFT" BGCOLOR="#E6E6FF"><FONT FACE="Verdana"><BR/></' +
        'FONT></TD>'
      
        #9'<TD ALIGN="LEFT" BGCOLOR="#E6E6FF"><FONT FACE="Verdana"><BR/></' +
        'FONT></TD>'
      
        #9'<TD ALIGN="LEFT" BGCOLOR="#E6E6FF" SDVAL="39179" SDNUM="1033;0;' +
        'MM/DD/YY"><FONT FACE="Verdana"><xsl:value-of select="Quotation/H' +
        'eader_Information/Delivery_Date"/></FONT></TD>'
      
        #9'<TD ALIGN="LEFT" BGCOLOR="#E6E6FF"><FONT FACE="Verdana"><BR/></' +
        'FONT></TD>'
      
        #9'<TD ALIGN="LEFT" BGCOLOR="#E6E6FF" SDVAL="39206" SDNUM="1033;0;' +
        'MM/DD/YY"><FONT FACE="Verdana"><xsl:value-of select="Quotation/H' +
        'eader_Information/Valid_Until"/></FONT></TD>'
      '    </TR>'
      '    <TR>'
      
        #9'<TD HEIGHT="18" ALIGN="LEFT"><FONT FACE="Verdana"><BR/></FONT><' +
        '/TD>'
      
        #9'<TD ALIGN="LEFT" BGCOLOR="#000000"><FONT FACE="Verdana" COLOR="' +
        '#FFFFFF">Product Code</FONT></TD>'
      
        #9'<TD ALIGN="LEFT" BGCOLOR="#000000"><FONT FACE="Verdana" COLOR="' +
        '#FFFFFF">Description</FONT></TD>'
      
        #9'<TD ALIGN="LEFT" BGCOLOR="#000000"><FONT FACE="Verdana"><BR/></' +
        'FONT></TD>'
      
        #9'<TD ALIGN="RIGHT" BGCOLOR="#000000"><FONT FACE="Verdana" COLOR=' +
        '"#FFFFFF">Quantity</FONT></TD>'
      
        #9'<TD ALIGN="RIGHT" BGCOLOR="#000000"><FONT FACE="Verdana" COLOR=' +
        '"#FFFFFF">Rate</FONT></TD>'
      
        #9'<TD ALIGN="RIGHT" BGCOLOR="#000000"><FONT FACE="Verdana" COLOR=' +
        '"#FFFFFF">Amount</FONT></TD>'
      '    </TR>'
      '    <TR>'
      
        #9'<TD HEIGHT="19" ALIGN="LEFT"><FONT FACE="Times New Roman"><BR/>' +
        '</FONT></TD>'
      #9'<TD ALIGN="LEFT"><FONT FACE="Verdana"><BR/></FONT></TD>'
      
        #9'<TD ALIGN="RIGHT" SDNUM="1033;0;[$$-409]#,##0.00;[RED]-[$$-409]' +
        '#,##0.00"><FONT FACE="Verdana"><BR/></FONT></TD>'
      
        #9'<TD ALIGN="RIGHT" SDNUM="1033;0;[$$-409]#,##0.00;[RED]-[$$-409]' +
        '#,##0.00"><FONT FACE="Verdana"><BR/></FONT></TD>'
      '    </TR>'
      '    <TR>'
      
        #9'<TD HEIGHT="20" ALIGN="LEFT"><FONT FACE="Times New Roman"><BR/>' +
        '</FONT></TD>'
      
        #9'<TD ALIGN="LEFT"><FONT FACE="Verdana" SIZE="3"><xsl:value-of se' +
        'lect="Quotation/Line_Item_List/Line_Item/PLU"/></FONT></TD>'
      
        #9'<TD ALIGN="LEFT"><FONT FACE="Verdana" SIZE="3"><xsl:value-of se' +
        'lect="Quotation/Line_Item_List/Line_Item/Name"/></FONT></TD>'
      
        #9'<TD ALIGN="LEFT"><FONT FACE="Verdana" SIZE="3"><BR/></FONT></TD' +
        '>'
      
        #9'<TD ALIGN="RIGHT" SDVAL="1" SDNUM="1033;"><FONT FACE="Verdana" ' +
        'SIZE="3"><xsl:value-of select="Quotation/Line_Item_List/Line_Ite' +
        'm/Quantity"/></FONT></TD>'
      
        #9'<TD ALIGN="RIGHT" SDVAL="165" SDNUM="1033;0;[$$-409]#,##0.00;[R' +
        'ED]-[$$-409]#,##0.00"><FONT FACE="Verdana" SIZE="3"><xsl:value-o' +
        'f select="Quotation/Line_Item_List/Line_Item/Rate"/></FONT></TD>'
      
        #9'<TD ALIGN="RIGHT" SDVAL="165" SDNUM="1033;0;[$$-409]#,##0.00;[R' +
        'ED]-[$$-409]#,##0.00"><FONT FACE="Verdana" SIZE="3"><xsl:value-o' +
        'f select="Quotation/Line_Item_List/Line_Item/Amount"/></FONT></T' +
        'D>'
      '    </TR>'
      '    <TR>'
      
        #9'<TD HEIGHT="19" ALIGN="LEFT"><FONT FACE="Times New Roman"><BR/>' +
        '</FONT></TD>'
      #9'<TD ALIGN="LEFT"><FONT FACE="Verdana"><BR/></FONT></TD>'
      
        #9'<TD ALIGN="RIGHT" SDNUM="1033;0;[$$-409]#,##0.00;[RED]-[$$-409]' +
        '#,##0.00"><FONT FACE="Verdana"><BR/></FONT></TD>'
      
        #9'<TD ALIGN="RIGHT" SDNUM="1033;0;[$$-409]#,##0.00;[RED]-[$$-409]' +
        '#,##0.00"><FONT FACE="Verdana"><BR/></FONT></TD>'
      '    </TR>'
      '    <TR>'
      
        '        <TD HEIGHT="19" ALIGN="LEFT"><FONT FACE="Times New Roman' +
        '"><BR/></FONT></TD>'
      #9'<TD ALIGN="LEFT"><FONT FACE="Verdana"><BR/></FONT></TD>'
      #9'<TD ALIGN="LEFT"><FONT FACE="Verdana"><BR/></FONT></TD>'
      #9'<TD ALIGN="LEFT"><FONT FACE="Verdana"><BR/></FONT></TD>'
      #9'<TD ALIGN="LEFT"><FONT FACE="Verdana"><BR/></FONT></TD>'
      
        #9'<TD ALIGN="CENTER" BGCOLOR="#E6E6E6" SDNUM="1033;0;[$$-409]#,##' +
        '0.00;[RED]-[$$-409]#,##0.00"><FONT FACE="Verdana">Total GST</FON' +
        'T></TD>'
      
        #9'<TD ALIGN="RIGHT" BGCOLOR="#E6E6E6" SDVAL="16.5" SDNUM="1033;0;' +
        '[$$-409]#,##0.00;[RED]-[$$-409]#,##0.00"><FONT FACE="Verdana">$<' +
        'xsl:value-of select="Quotation/Header_Information/Total_Tax"/></' +
        'FONT></TD>'
      '    </TR>'
      '    <TR>'
      
        #9'<TD HEIGHT="32" ALIGN="LEFT"><FONT FACE="Times New Roman"><BR/>' +
        '</FONT></TD>'
      
        #9'<TD ALIGN="LEFT" BGCOLOR="#0099FF"><FONT FACE="Times New Roman"' +
        '><BR/></FONT></TD>'
      
        #9'<TD ALIGN="LEFT" BGCOLOR="#0099FF"><FONT FACE="Times New Roman"' +
        '><BR/></FONT></TD>'
      
        #9'<TD ALIGN="LEFT" BGCOLOR="#0099FF"><FONT FACE="Times New Roman"' +
        '><BR/></FONT></TD>'
      
        #9'<TD ALIGN="LEFT" BGCOLOR="#0099FF"><FONT FACE="Times New Roman"' +
        '><BR/></FONT></TD>'
      
        #9'<TD ALIGN="CENTER" BGCOLOR="#B3B3B3"><FONT FACE="Verdana" SIZE=' +
        '"3">Total</FONT></TD>'
      
        #9'<TD ALIGN="RIGHT" BGCOLOR="#333333" SDVAL="165" SDNUM="1033;0;[' +
        '$$-409]#,##0.00;[RED]-[$$-409]#,##0.00"><FONT FACE="Verdana" SIZ' +
        'E="4" COLOR="#FFFFFF">$<xsl:value-of select="Quotation/Header_In' +
        'formation/Total_Amount"/></FONT></TD>'
      '    </TR>'
      #9
      '  </table>'
      '  <p><br/><br/>'#9'</p>'
      '</body>'
      '</html>'
      '</xsl:template>'
      '</xsl:stylesheet>')
    Left = 272
    Top = 4
    DOMVendorDesc = 'MSXML'
  end
  object bsSkinMessage1: TbsSkinMessage
    AlphaBlend = False
    AlphaBlendAnimation = False
    AlphaBlendValue = 200
    SkinData = frmMain.bsSkinData1
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
    Left = 208
    Top = 8
  end
end
