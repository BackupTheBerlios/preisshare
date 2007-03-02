object frmBuildDBPricelist: TfrmBuildDBPricelist
  Left = 264
  Top = 137
  AutoScroll = False
  BorderIcons = []
  Caption = 'Customer Pricelist Builder'
  ClientHeight = 493
  ClientWidth = 401
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object btnConfig: TbsSkinSpeedButton
    Left = 68
    Top = 460
    Width = 57
    Height = 25
    SkinData = frmMain.bsSkinData1
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
    Caption = 'Config'
    ShowCaption = True
    NumGlyphs = 1
    Spacing = 1
    OnClick = btnConfigClick
  end
  object btnRun: TbsSkinSpeedButton
    Left = 4
    Top = 460
    Width = 57
    Height = 25
    Visible = False
    SkinData = frmMain.bsSkinData1
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
    Caption = 'Run'
    ShowCaption = True
    NumGlyphs = 1
    Spacing = 1
    OnClick = btnRunClick
  end
  object Image1: TImage
    Left = 8
    Top = 8
    Width = 181
    Height = 117
    Picture.Data = {
      0A544A504547496D6167651F200000FFD8FFE000104A46494600010101004800
      480000FFE20C584943435F50524F46494C4500010100000C484C696E6F021000
      006D6E74725247422058595A2007CE00020009000600310000616373704D5346
      540000000049454320735247420000000000000000000000000000F6D6000100
      000000D32D485020200000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000001163707274000001
      500000003364657363000001840000006C77747074000001F000000014626B70
      7400000204000000147258595A00000218000000146758595A0000022C000000
      146258595A0000024000000014646D6E640000025400000070646D6464000002
      C400000088767565640000034C0000008676696577000003D4000000246C756D
      69000003F8000000146D6561730000040C000000247465636800000430000000
      0C725452430000043C0000080C675452430000043C0000080C62545243000004
      3C0000080C7465787400000000436F7079726967687420286329203139393820
      4865776C6574742D5061636B61726420436F6D70616E79000064657363000000
      0000000012735247422049454336313936362D322E3100000000000000000000
      0012735247422049454336313936362D322E3100000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000058595A20000000000000F35100010000000116CC58595A20000000
      0000000000000000000000000058595A200000000000006FA2000038F5000003
      9058595A2000000000000062990000B785000018DA58595A2000000000000024
      A000000F840000B6CF64657363000000000000001649454320687474703A2F2F
      7777772E6965632E636800000000000000000000001649454320687474703A2F
      2F7777772E6965632E6368000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000064657363000000
      000000002E4945432036313936362D322E312044656661756C74205247422063
      6F6C6F7572207370616365202D207352474200000000000000000000002E4945
      432036313936362D322E312044656661756C742052474220636F6C6F75722073
      70616365202D2073524742000000000000000000000000000000000000000000
      0064657363000000000000002C5265666572656E63652056696577696E672043
      6F6E646974696F6E20696E2049454336313936362D322E310000000000000000
      0000002C5265666572656E63652056696577696E6720436F6E646974696F6E20
      696E2049454336313936362D322E310000000000000000000000000000000000
      00000000000000000076696577000000000013A4FE00145F2E0010CF140003ED
      CC0004130B00035C9E0000000158595A2000000000004C09560050000000571F
      E76D656173000000000000000100000000000000000000000000000000000002
      8F00000002736967200000000043525420637572760000000000000400000000
      05000A000F00140019001E00230028002D00320037003B00400045004A004F00
      540059005E00630068006D00720077007C00810086008B00900095009A009F00
      A400A900AE00B200B700BC00C100C600CB00D000D500DB00E000E500EB00F000
      F600FB01010107010D01130119011F0125012B01320138013E0145014C015201
      5901600167016E0175017C0183018B0192019A01A101A901B101B901C101C901
      D101D901E101E901F201FA0203020C0214021D0226022F02380241024B025402
      5D02670271027A0284028E029802A202AC02B602C102CB02D502E002EB02F503
      00030B03160321032D03380343034F035A03660372037E038A039603A203AE03
      BA03C703D303E003EC03F9040604130420042D043B0448045504630471047E04
      8C049A04A804B604C404D304E104F004FE050D051C052B053A05490558056705
      770586059605A605B505C505D505E505F6060606160627063706480659066A06
      7B068C069D06AF06C006D106E306F507070719072B073D074F07610774078607
      9907AC07BF07D207E507F8080B081F08320846085A086E0882089608AA08BE08
      D208E708FB09100925093A094F09640979098F09A409BA09CF09E509FB0A110A
      270A3D0A540A6A0A810A980AAE0AC50ADC0AF30B0B0B220B390B510B690B800B
      980BB00BC80BE10BF90C120C2A0C430C5C0C750C8E0CA70CC00CD90CF30D0D0D
      260D400D5A0D740D8E0DA90DC30DDE0DF80E130E2E0E490E640E7F0E9B0EB60E
      D20EEE0F090F250F410F5E0F7A0F960FB30FCF0FEC1009102610431061107E10
      9B10B910D710F511131131114F116D118C11AA11C911E8120712261245126412
      8412A312C312E31303132313431363138313A413C513E5140614271449146A14
      8B14AD14CE14F01512153415561578159B15BD15E0160316261649166C168F16
      B216D616FA171D17411765178917AE17D217F7181B18401865188A18AF18D518
      FA19201945196B199119B719DD1A041A2A1A511A771A9E1AC51AEC1B141B3B1B
      631B8A1BB21BDA1C021C2A1C521C7B1CA31CCC1CF51D1E1D471D701D991DC31D
      EC1E161E401E6A1E941EBE1EE91F131F3E1F691F941FBF1FEA20152041206C20
      9820C420F0211C2148217521A121CE21FB22272255228222AF22DD230A233823
      66239423C223F0241F244D247C24AB24DA250925382568259725C725F7262726
      57268726B726E827182749277A27AB27DC280D283F287128A228D42906293829
      6B299D29D02A022A352A682A9B2ACF2B022B362B692B9D2BD12C052C392C6E2C
      A22CD72D0C2D412D762DAB2DE12E162E4C2E822EB72EEE2F242F5A2F912FC72F
      FE3035306C30A430DB3112314A318231BA31F2322A3263329B32D4330D334633
      7F33B833F1342B3465349E34D83513354D358735C235FD3637367236AE36E937
      243760379C37D738143850388C38C839053942397F39BC39F93A363A743AB23A
      EF3B2D3B6B3BAA3BE83C273C653CA43CE33D223D613DA13DE03E203E603EA03E
      E03F213F613FA23FE24023406440A640E74129416A41AC41EE4230427242B542
      F7433A437D43C044034447448A44CE45124555459A45DE4622466746AB46F047
      35477B47C04805484B489148D7491D496349A949F04A374A7D4AC44B0C4B534B
      9A4BE24C2A4C724CBA4D024D4A4D934DDC4E254E6E4EB74F004F494F934FDD50
      27507150BB51065150519B51E65231527C52C75313535F53AA53F65442548F54
      DB5528557555C2560F565C56A956F75744579257E0582F587D58CB591A596959
      B85A075A565AA65AF55B455B955BE55C355C865CD65D275D785DC95E1A5E6C5E
      BD5F0F5F615FB36005605760AA60FC614F61A261F56249629C62F06343639763
      EB6440649464E9653D659265E7663D669266E8673D679367E9683F689668EC69
      43699A69F16A486A9F6AF76B4F6BA76BFF6C576CAF6D086D606DB96E126E6B6E
      C46F1E6F786FD1702B708670E0713A719571F0724B72A67301735D73B8741474
      7074CC7528758575E1763E769B76F8775677B37811786E78CC792A798979E77A
      467AA57B047B637BC27C217C817CE17D417DA17E017E627EC27F237F847FE580
      4780A8810A816B81CD8230829282F4835783BA841D848084E3854785AB860E86
      7286D7873B879F8804886988CE8933899989FE8A648ACA8B308B968BFC8C638C
      CA8D318D988DFF8E668ECE8F368F9E9006906E90D6913F91A89211927A92E393
      4D93B69420948A94F4955F95C99634969F970A977597E0984C98B89924999099
      FC9A689AD59B429BAF9C1C9C899CF79D649DD29E409EAE9F1D9F8B9FFAA069A0
      D8A147A1B6A226A296A306A376A3E6A456A4C7A538A5A9A61AA68BA6FDA76EA7
      E0A852A8C4A937A9A9AA1CAA8FAB02AB75ABE9AC5CACD0AD44ADB8AE2DAEA1AF
      16AF8BB000B075B0EAB160B1D6B24BB2C2B338B3AEB425B49CB513B58AB601B6
      79B6F0B768B7E0B859B8D1B94AB9C2BA3BBAB5BB2EBBA7BC21BC9BBD15BD8FBE
      0ABE84BEFFBF7ABFF5C070C0ECC167C1E3C25FC2DBC358C3D4C451C4CEC54BC5
      C8C646C6C3C741C7BFC83DC8BCC93AC9B9CA38CAB7CB36CBB6CC35CCB5CD35CD
      B5CE36CEB6CF37CFB8D039D0BAD13CD1BED23FD2C1D344D3C6D449D4CBD54ED5
      D1D655D6D8D75CD7E0D864D8E8D96CD9F1DA76DAFBDB80DC05DC8ADD10DD96DE
      1CDEA2DF29DFAFE036E0BDE144E1CCE253E2DBE363E3EBE473E4FCE584E60DE6
      96E71FE7A9E832E8BCE946E9D0EA5BEAE5EB70EBFBEC86ED11ED9CEE28EEB4EF
      40EFCCF058F0E5F172F1FFF28CF319F3A7F434F4C2F550F5DEF66DF6FBF78AF8
      19F8A8F938F9C7FA57FAE7FB77FC07FC98FD29FDBAFE4BFEDCFF6DFFFFFFDB00
      43000A07070807060A0808080B0A0A0B0E18100E0D0D0E1D15161118231F2524
      221F2221262B372F26293429212230413134393B3E3E3E252E4449433C48373D
      3E3BFFDB0043010A0B0B0E0D0E1C10101C3B2822283B3B3B3B3B3B3B3B3B3B3B
      3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B
      3B3B3B3B3B3B3BFFC00011080062009303012200021101031101FFC4001C0000
      020203010100000000000000000000050600030204070108FFC4003810000201
      0303010605020504020300000001020300041105122131061322415161143271
      819142B1071523A1C11652E1F033924382D1FFC4001901000301010100000000
      00000000000000020304010005FFC40029110002020103030305000300000000
      0000010200031112213104134122327133345181F0146191FFDA000C03010002
      110311003F00E902EDA6C6C550BE6CCF8AB17B9572E768CF560735A8D1433784
      B3320E360F3AD98C5B4506D58E38D547423815E6D76B9F31935AF2CE09A363DC
      962DCEE5F3AD68C5C448228EDBBD63C025F0451259F72700053C038E0D588BB7
      277727D3A5735A18693380C6E2796F6C96E81A576773D726A49A7DAF89F6800F
      2C0F9D6524C912162EBBBCBCE879B8965954A1EF003CF3C0A4D97AA8D2779A04
      29195106140503A7155C1286660D23363D45513EA090C0DB8F88792FFC568C57
      D15C21EEDD632BD41C8FDF34CCE718330ED0C778BBB6B67E95E9C8076788FA37
      9568C122B01E21BBEA79AD5D7351BD8F42BDFE54AA6FBBA221DCC1707CD813E6
      0648F7A1196382713B30A3C40954F8810CB2292A9B87880EA4039F5149FAD764
      25B6326A366D35C3EEDEF1B15C373E58C7ED42BB2DD9ED561BE4ED0769B58B92
      2172D6F6CAFDE197CB2739014F180393C72315D16DF56B4B8916101D243D73D1
      4FA67D6AF14E8DD22DC06F4B443D4ACAECF7135BE9133CF8F1C6541C0FDE8469
      FD9FBBD72E26704C28AE54E5189CD75A71230D801620F4AA6F0BC3692CC91665
      8D72370E33EF8F2AE5B081803F717D8527981B44ECCC5A2D8A886C85C5D672D7
      0E00273E99E82B2BAD4AE2DF565B67291E53254F5AD7965B88EE4DE0D5A7EF64
      04226FCC7F64E95A62FE6D6AD63B89E3577599A3C07542E41C7018E71E59F6A5
      38277F32864D036871AE62650DB4C8F9EA47F8AB1E7910EEEAA07236938FDA95
      6E650B7C60693E1A45F10492618C7D7A510B66D4AE6D8CA238DA0FD2E8CB86FC
      75A10A7F062F5C2227D3E61DE341092DC93B3FE2A52ECB284959648D4303C82F
      CD4A5E5FF13754685DCBE250CA4F241C93581131941DA4A79918AD592F65EF99
      6544DA79F0821BEE4FF8A1CBA988A5685A42DBCF077631F6A06276C4ECC37733
      4726D5505D94E4FB5793DF910810A313E67D2A8B3BF171094560360C0E9935A4
      8E21770CEEC58E7C469362B93A87066EA1C4AA7B899AE4C93A928ABC0693613F
      6A23A5CE8B65DE777B413E4473F7AE6FDABEDB95D45ED74D48DFBAE24B891431
      DDE6173E55BBD88EDC2CF7D25B6B7BE689D40411DB2E14FAF879AA17A362A089
      C239EA7A92C735B430DB8B99E6259636728022E0B127EE071E6455E2FE3B8B68
      6CE48561BE901DA507825206485F7C7383F6CE0E046A274FD475189EDA69C489
      0B22C654AB052CA49071C83B7EBC50FED25CC5A5E8D3DF07912E05D4725A9DD9
      DD28E401EDC1CFB668D6A4442A46F1EB5EA19318ED669E1DC1A3CB8E3693C8AB
      0DFEFB88E17B7562FE156241C67CBC8D14D6358874D553791A84932119B18271
      9C52EF66A59359D75B50312470419DDB720163D368E71D33D78A50E9F0C00313
      E213BB9238D8C6147F4461540C74E2B4DE398448610A48219CB123CF27A7DEB3
      986F33C84ED243107D39AC6161F0D890AECF36271549B483BC7AA0C18CD624DC
      59C53166F12F3B8639ABDA3876959318239C9C563651182D228199599463C26A
      9D55447613DC085A578A36658C67C671C0E3FC55217FD49C9DE009ADA3B5B90D
      DDA1DB91B81C803DBDCD0DD42D3559238A5D0DEC6465C836DE159F775E0B7B50
      3D17B716F65A5DCA6B2D24D751C84C2912821C1FD208E060E79F4F5A4AD7359B
      BD73501773620119CC1144C408BDC1F36F7FDA98BD3BEB20F10ACB55EB041DE1
      8D6B57D7F4EBD8D356967B69339EEE40A09F71EBF6A3B2F6E2CC764A2B4B6576
      B96C090CE14AF27248C1C9FC52D43DB9D4A4B35D3B5A86DF57B1079173103281
      ECE7CFDC826A9FF494FA93ACBA2E9F7F75048774699CC483D0BFAD1594691907
      692AB6F831C2D75ED205B47DF9BE32E32C6394AAE7D813C0A941E1EC3F681620
      1E0D32261D525BC0597D890715293DB8598EF2B18FFF0035ABA1CFCCCC1B27EA
      09C5296B97D70350DCCCB18040187DF9FB7A56F6A3DAC796DDCF757F6ED9F046
      F0AA1C7B8E7F7A4E9B5499AE4FF58AB3E372AE771FCF4A97B43390209619C467
      B9D605AA44D14E4161FD40CC0E78F415E5C6B32B4488CCE18F2A0F19FF00B9A4
      F96F244B8EEC20763C0C90C47E6B25BE992DE73233078C7F4CF9138F23446ADE
      350E4EF00BA3CF76EA8A4B3B9E073E74CDD8F85ADEF6F372BE63C0E23DC7A9F7
      18A05A1CA62D4E39073EBC64915D1F40B07B2D3DE578CA49752191D463701E43
      9A2B2DD3E996555E46A9BB72F2C33412A432288D0E64653E219CF07DAAED5348
      8BB476105BCAE6231CEB3823D40231F4C13416FB5BBB7D56E2CED434D1D94381
      0BE013D09E9F5C6283DD76FF005696493659C56C6504E1C124061C6071E5D286
      AA1AC72418565A1060C68ED95CC9AB68763A9E9970D756710779908C380BC072
      3CC7CDCFA7356FF0C7556B817F1776AAA8A242E4F2D9E140FA73FF00B553D97D
      46D2E746B3B788AB3476E2396127918F09C8F4357F648683A52DF586917534D7
      31CEB05CACC7E465C8240C0F0E41FED5A08D4CA063127643956CF30D6A127776
      F390380A4E3D78A16B3BDCD9221040D8379F7F3A35730FC4C4001F39E7F0687D
      959DC49B2DCC1229CE18B21000FBD4615CBCA832853086AB94D5370675CA2B0C
      1C7B7F8AF2FB58BA6ECFEA106F91A7F876685D1B0F90338CFAF15B1AEDABDC5A
      7796F9EF63047039C7FC50585E63009191C6C6D864DA704FD7A67DAAAB1DEAB7
      3E22502D95E3CCE5B3BBCB233C8C5DDB92CC7249F5AD5718A66ED8696963731D
      FDB4623B69810E074471CFE0F5FCD2A4F3A000EE1EFCD7B62D0EBA84F3B4156D
      2654BBA4B81122B33390AAA064B13C00079D741FE176B77ED7C74458FBFB56CB
      82CC4088F98CF3D7C87AE681F602CE7FF53D96AEF6265B3B47672CE3018ED60B
      B723921883F6AE936F0DCEA3AA99EDE158DDE5123774A1554E7A923F73C9A86C
      BC2FA79CCA969D432768D2348B361BA4B76DC7AE266FF06A56F7DEA50C19C9F5
      98754BE81A2491C423A6D6009FBE6B9BDC896D351C84691118648048FCD75BBE
      0D6D672B0472C478769DA2B8E6B4A3F9948D212F21E58EE0D8F3C66ADEA2B014
      113CCE8DCB390610D52586EAE55AD4246BB32E49239ACEF6DA6B5D2984D1B2CC
      64EEF0DD4E3A9C7A797DA8382915A61006964EBCFCABE9C53C68621D6ACCCA19
      59EDDC2B1EBCFB1F3EBE7EF5E7D8713D5A94660EEC8696CBA8B4F3C5B1421011
      BAF4EBF9A3F75772AB77363349DF1C0CA1C81F5F2E2B656DF610AA8A3DF1CD78
      90B44762B6D5FF006AD4EC8AEFAA5CA4AAE210D36F6CF4E31B5F585ADFCF181F
      D7B5B6EEA5CFA99382DEE08E4FF71DDB0ECED8EB56F73DA0D1A59C5C411AB5C5
      8CCA0111AA81B931E807239F3FA1DC8D6489B842C4D671DE3DB5DA4E870F19E4
      7A8F307ED47DF34B64457685A378B3D8D84C5149AC7C505811BB868F61E7E525
      B77418DDD3F6F374B1B5D134FD46E2E56E21B29AF7134F2CAF9EF180CE00FCF1
      F5A0FA4E8769A15F5D4F7FAAE3467632DBDB93B6301B9009F20338E2BA443A3D
      858DB966B68649963FEA4C546E2073D7D29AFA5EC2E3C8880591749FCC0DA348
      D7CF3C6C3023D92AED4DB85201C63CBAD19E8319A0FF001EDA7DCDC2C11234B7
      51C6A72DB76E0103FB114472E246CF1CD1543048105F700CF26B848DB6B9C1FA
      D51AADCC3FC8258A3951E56915953CD86403FB1AB6EED92EA301B875F95AA58E
      856EECF24F233E483B01C0E9D7F6FC5139639046D31748C11CC59B6B49258196
      EB749163C415371CF96060F3F6357EAC9A259DA2DC6A5F0E96D1F43280DCFA00
      7393EC39A51FE223DED9F6CA58964963B38E3416E8A48400A82DF539CE73ED49
      77B7571A84FDF5DDC4B3B8180D2316C0F41E83D8562D0C00DE1F781C89D0746E
      DA5A6AFDAEB0D320B0D9A74F2F76D24CC43B784E300602F8B1D73F6AEB51C51C
      1188A28D6341D1546057CE9D908DE4ED868E2252C56FA16214670038C9AFA34F
      53446B55DC40D65B6327DAA5799A9433A729D41DF5381961496561F2672A84FA
      93C0C52D43D8676BBEF2F3514193965B74DCC7EE7007F7A65376B2B1114734CF
      E8060510B4D2AEDA2EF6EEE52CA3EBB6342F237EC3FB9ABED60D8D53CBA2B299
      D3E66969DD9FECF6971EE8F488E6947FF25FB77BF7DBF2FDF19ABE7D421963EE
      A2EEBFA7F2C71285451EC074A2F6BA2E98844B736D2CA87A7C4BB3B3FF00F45C
      28FB83576BD2DAC7A3BA436B1DBC4B8C909B71F8E0543681DB6004F469D41D49
      33421D32D670279E4923050111AFCC4FD706AC86CECE19DA4F866947E959243C
      7D718CD65A45FC3AAC3FEC9225FEA0C718F5146A150F0ED5441C8230BCB0F7A7
      5428D3951989B7FC9D4416C41D0847B83235B424638523814B9AEDDD9C3DACFE
      56EA96B25C5B2491600552F93953E8480314E8D1411B1628AA40CEDDD81F5CD7
      2AFE26423FD490CAB90AF000BCF2083CFEE28ACA92E0540C4EA5ECA5812732CE
      D3452DC6862D9958B5ACBDE2F3FA71E218FEF5D53B337FFCDBB1DA7DDBB86125
      98595B3FA946D7FEE0D72CB5BE3AAF6752ED8E6E607EEA727F563A13F51FDF34
      F7FC2F2EBD9CBCB576DD1417CE2207A046447C7E59AA3AB2A851B9065D760B07
      1C18496DADAEA60CA51E50A5F1BF208150EA36F115176C2D5D9885129186F3C8
      3E9D7AE3A57BA9E8705B5B3DC5AC8D1A2FCD09E4303E40D2F451E97087B55B38
      9628DD49471B110E31D0F39C1F21820D1D2AC412C307325BEC0A42A9FF00B187
      F9AE9C71B750B6909048114A1C9C75E1726B3B7D6EDE3B9822559196E4A9490C
      6DB4AE09CE71C71EB8F2F5A5B781AF250F6170F6A36E5A384852B83D3A104F3D
      0F18F4EB5B697A8BA959D95C5BF745941463E15CFCA5570707965C0FA93D0668
      C0224BDD6CCD5EDE5BAC9A94AB246AE1910E1BA1E294B4DD2747959C3580EF10
      8F9D8B039CF9134F7DBA804896F7A982B2C7B723F23F73F8A55D3200213211CB
      3B0E9E807FFB5454014064F7965B481E612ECDD9C506BF662340077A085031F7
      C574A3D6907B33117ED25A9F240EE7FF00523F734FB49EA4E587C4ABA31843F3
      254A9F7A952CB601B1ECFC102296440DE7B724FE68A2DAC6A3011401E9D6AC4F
      97DAB31CFD6B492799C001C4A1ACD1CE36E4FA9E6B9DF6DB528F50D4069B6AFB
      AD6CCF8D97A3C9E7F61D3F34CBDACD766813F9569ACDF152E048F1F2C80FE918
      FD47FEF5AD7ECE762A3B60975AA20671CA5B1E42FBBFAFD3F3E94B627DA23130
      3D4659D8AD01ED34B96EEE136CB74B889587CA98E09FAFED8AAE1D52E9197E2E
      D923232BB236CE39E491C9FCFAFE1C3249C9349377796A9DA2BEB79AD94BA49D
      5D826D53CE7CB20FBD3A9C20D326EA03D87529E3FBF7F130975479C12C6372CD
      B4004A81F8E5B1E7E5EF4035CD1E5ED359CF6F64EAF79660CF1A953BAE001865
      1E87A7E00A2577AD5AD87C541631471C72657BD620601EBB4718A5F8BB45269B
      A9DBDDD912C606CBF1C32F42BF7147DD67216B1F27C404A45459EC3C8C0079FE
      F9E20EEC9E87AE1BA9A2164C2DAE226120775072A0B0206739E31F735D0FF868
      918B6D4482DDEEE8C30CF8768DD8207AE4B67E83D2B3EC7EAF61AC6AF2DFC36F
      F0988C99232D9557240C83E87F7AD0D12EE1D0BB6B75134891D94D24916EDDE1
      519CA1FD867CB26A725CB9D5CCB3D253D3C46BED14E23B6B788B6DEF661CE7D3
      A0FC9148EEABA5DC5D3AFC2DB17943A99A52C705B0495CF889EA06437239F207
      FB70B6F75770DACCCC1AD203760210588048CA8EA48C647BE28541FCCA1BD7BB
      4B58CBCD0C71F7D1F284824970B91924B7424118AB2BC049E45E49B0CAE3916D
      19EF34C8A3BA13AC71C890BEE68C83C679F0820B8CFB29E6ADB6BFD3E5D5458C
      7773DCB631959CB609607C393918DAB8FF00A6B66FB514B5B07588343711A058
      A2990B062785184240C9E9C8AF747B7686DBE32568DEE5D84AED13B244F939CA
      A8C83E439E7A74AC246A9814E300C33AF583DC765E2110693E15037B950304FD
      71CD24697299A392D977128C6451E58C61BF61F8AEA3620FF2EB7120C930AEE0
      4639C73C1AE6F3DA0D0BB628B1AE04530655DD80C87DCFB6456D2C7758EEA107
      A5E5B69AB4BA2DE24F1A6F773B0AE792B9E71FDBFE9A3579DAFB885D00B75018
      900139CD31A68FA5A4BDFAE9F6E1D87CDB01207B7A7DA806B7D939B55D7ADEE6
      2BA4B7B540AAF108F9201C9C1F7AE36A1E5612D162F0D1A94611437CD819FAD4
      AC8F249A952CB26AC3D2AC6E23247071D454A95B3A28F604096E6EE7906F940C
      F78DCB64939E69C6A54AE3C99BF8917907EB5C9FF8924A768EE190ED6291E48E
      0FCB52A532AE4C4DBE3E628C4C5A55DC49CAF9D6772485400E063CAA54ABD642
      DEE8C9D8762350B9504852A808F2C67A56E6A407C73F03E6A952BCBB7EE4FF00
      789EB51F6FFDF9868F8EDF4A99BC52AC312073F30532B0233E980063DA84DC00
      B6F2B00014B347523F4B778391EFEF52A5535F89E3757EE6FDC228EEBA724818
      874851D581E558A2648F4272727DCD14D57C1A1C813C2155318E31E25A95289B
      EA42AFE91F88D6A004400606D1481FC541DD9B19A3F04862906F5E1B00AE39FB
      9FCD4A941D3FD496751F48FEA34F64D99FB2FA796258984724D17FD46A54A53F
      B8C6A7B44F0F5A952A50C39FFFD9}
  end
  object bsSkinSpeedButton3: TbsSkinSpeedButton
    Left = 132
    Top = 461
    Width = 65
    Height = 25
    SkinData = frmMain.bsSkinData1
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
    OnClick = bsSkinSpeedButton3Click
  end
  object btnClose: TbsSkinButton
    Left = 316
    Top = 460
    Width = 75
    Height = 25
    TabOrder = 0
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
    OnClick = btnCloseClick
  end
  object bsSkinMemo1: TbsSkinMemo
    Left = 204
    Top = 8
    Width = 185
    Height = 289
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = 14
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      'Welcome to the Pricelist Builder '
      'screen.'
      ''
      'Here you can build a '
      'Pricelist from an existing Database '
      'or Accounting system.'
      ''
      'To use this screen, you need'
      'to have Customers added.'
      ''
      'Once this is done, you can then'
      'add a custom pricelist for them.')
    ParentFont = False
    ReadOnly = True
    TabOrder = 1
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
  object bsSkinGroupBox1: TbsSkinGroupBox
    Left = 8
    Top = 120
    Width = 185
    Height = 177
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
    Caption = 'Options'
    object btnAddCustomer: TbsSkinSpeedButton
      Left = 76
      Top = 141
      Width = 97
      Height = 25
      SkinData = frmMain.bsSkinData1
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
      Caption = 'Add Customer'
      ShowCaption = True
      NumGlyphs = 1
      Spacing = 1
      OnClick = btnAddCustomerClick
    end
    object lblNoCustomers: TbsSkinTextLabel
      Left = 8
      Top = 32
      Width = 169
      Height = 104
      UseSkinFont = True
      Lines.Strings = (
        'You have no Customers currently '
        'selected for Custom pricelists.'
        ''
        'This means that they will all receive '
        'the Standard Retail Pricelist.'
        ''
        'Click below to add a Customer...')
      DefaultFont.Charset = DEFAULT_CHARSET
      DefaultFont.Color = clWindowText
      DefaultFont.Height = -11
      DefaultFont.Name = 'MS Sans Serif'
      DefaultFont.Style = []
      SkinData = frmMain.bsSkinData1
      SkinDataName = 'stdlabel'
    end
    object lblHaveCustomers: TbsSkinTextLabel
      Left = 16
      Top = 40
      Width = 169
      Height = 104
      UseSkinFont = True
      Lines.Strings = (
        'These are the Customers currently '
        'selected for Custom pricelists.'
        ''
        'This means that they will all receive '
        'the Standard Retail Pricelist.'
        ''
        'Click below to add a Customer...')
      DefaultFont.Charset = DEFAULT_CHARSET
      DefaultFont.Color = clWindowText
      DefaultFont.Height = -11
      DefaultFont.Name = 'MS Sans Serif'
      DefaultFont.Style = []
      SkinData = frmMain.bsSkinData1
      SkinDataName = 'stdlabel'
      Visible = False
    end
  end
  object lsvCustomers: TbsSkinListView
    Left = 8
    Top = 308
    Width = 381
    Height = 137
    Columns = <
      item
        Caption = 'Name'
        Width = 180
      end
      item
        Caption = 'Last Run'
        Width = 130
      end
      item
        Caption = 'Frequency'
        Width = 70
      end>
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = 14
    Font.Name = 'Arial'
    Font.Style = []
    RowSelect = True
    ParentFont = False
    TabOrder = 3
    ViewStyle = vsReport
    HeaderSkinDataName = 'resizebutton'
    DefaultFont.Charset = DEFAULT_CHARSET
    DefaultFont.Color = clWindowText
    DefaultFont.Height = 14
    DefaultFont.Name = 'Arial'
    DefaultFont.Style = []
    UseSkinFont = True
    SkinData = frmMain.bsSkinData1
    SkinDataName = 'listview'
    DefaultColor = clWindow
    OnChange = lsvCustomersChange
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
    Left = 24
    Top = 12
  end
end
