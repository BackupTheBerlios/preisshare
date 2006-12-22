object rptPrintStdDocToPDF: TrptPrintStdDocToPDF
  Left = 46
  Top = 77
  Width = 691
  Height = 621
  Caption = 'rptPrintStdDocToPDF'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 8
    Top = 12
    Width = 49
    Height = 25
    Caption = 'Button1'
    TabOrder = 0
  end
  object pdfQuotePage: TPRPage
    Left = 64
    Top = 12
    Width = 596
    Height = 842
    MarginTop = 32
    MarginLeft = 32
    MarginRight = 32
    MarginBottom = 32
    object PRLayoutPanel3: TPRLayoutPanel
      Left = 33
      Top = 343
      Width = 530
      Height = 370
      object PRRect28: TPRRect
        Left = 12
        Top = -3
        Width = 513
        Height = 353
        LineStyle = psSolid
      end
    end
    object PRLayoutPanel1: TPRLayoutPanel
      Left = 33
      Top = 33
      Width = 530
      Height = 312
      Align = alTop
      object PRRect11: TPRRect
        Left = 12
        Top = 292
        Width = 513
        Height = 17
        LineStyle = psSolid
        FillColor = clBlack
      end
      object PRRect10: TPRRect
        Left = 12
        Top = 244
        Width = 513
        Height = 41
        LineStyle = psSolid
      end
      object PRRect1: TPRRect
        Left = 12
        Top = 148
        Width = 245
        Height = 89
        LineStyle = psSolid
      end
      object PRRect8: TPRRect
        Left = 196
        Top = 104
        Width = 265
        Height = 33
        LineStyle = psSolid
      end
      object PRRect7: TPRRect
        Left = 12
        Top = 104
        Width = 245
        Height = 33
        LineStyle = psSolid
        FillColor = clBlack
      end
      object PRRect2: TPRRect
        Left = 360
        Top = 120
        Width = 100
        Height = 17
        LineStyle = psSolid
      end
      object qriLogo: TPRJpegImage
        Left = 0
        Top = 0
        Width = 121
        Height = 95
        SharedImage = True
      end
      object qrlHeaderName: TPRLabel
        Left = 136
        Top = 4
        Width = 401
        Height = 30
        FontName = fnArial
        FontSize = 20
        Caption = 'Global Tradedesk Technology Pty Limited'
      end
      object lblDocumentName: TPRLabel
        Left = 20
        Top = 108
        Width = 157
        Height = 30
        FontColor = clWhite
        FontName = fnArial
        FontSize = 20
        FontBold = True
        Caption = 'Purchase Order'
      end
      object PRLabel7: TPRLabel
        Left = 16
        Top = 152
        Width = 37
        Height = 33
        FontName = fnArial
        FontSize = 10
        Caption = 'To:'
      end
      object qrlToName: TPRLabel
        Left = 16
        Top = 168
        Width = 249
        Height = 17
        FontName = fnArial
        FontSize = 12
        FontBold = True
        Caption = 'Mr Fred Wilson'
      end
      object qrlFieldLabel1: TPRLabel
        Left = 16
        Top = 247
        Width = 81
        Height = 21
        FontName = fnArial
        FontSize = 11
        Caption = 'Delivery Mode:'
      end
      object qrlField1: TPRLabel
        Left = 16
        Top = 268
        Width = 93
        Height = 17
        FontName = fnArial
        FontSize = 11
        FontBold = True
        Caption = 'Collect'
      end
      object qrlFieldLabel2: TPRLabel
        Left = 116
        Top = 247
        Width = 49
        Height = 21
        FontName = fnArial
        FontSize = 11
        Caption = 'Valid Till:'
      end
      object qrlField2: TPRLabel
        Left = 116
        Top = 268
        Width = 93
        Height = 17
        FontName = fnArial
        FontSize = 11
        FontBold = True
        Caption = '17-Aug-2004'
      end
      object qrlFieldLabel3: TPRLabel
        Left = 220
        Top = 247
        Width = 73
        Height = 21
        FontName = fnArial
        FontSize = 11
        Caption = 'Prepared by:'
      end
      object qrlField3: TPRLabel
        Left = 220
        Top = 268
        Width = 97
        Height = 17
        FontName = fnArial
        FontSize = 11
        FontBold = True
        Caption = 'Dennis'
      end
      object PRRect4: TPRRect
        Left = 12
        Top = 261
        Width = 513
        Height = 1
        LineWidth = 1
        LineStyle = psSolid
      end
      object PRLabel18: TPRLabel
        Left = 14
        Top = 294
        Width = 85
        Height = 17
        FontColor = clWhite
        FontName = fnArial
        FontSize = 10
        Caption = 'Code'
      end
      object PRLabel19: TPRLabel
        Left = 68
        Top = 294
        Width = 85
        Height = 17
        FontColor = clWhite
        FontName = fnArial
        FontSize = 10
        Caption = 'Description'
      end
      object PRLabel20: TPRLabel
        Left = 308
        Top = 294
        Width = 49
        Height = 17
        FontColor = clWhite
        FontName = fnArial
        FontSize = 10
        Caption = 'Quantity'
        Alignment = taCenter
      end
      object PRLabel21: TPRLabel
        Left = 368
        Top = 294
        Width = 29
        Height = 17
        FontColor = clWhite
        FontName = fnArial
        FontSize = 10
        Caption = 'Unit'
        Alignment = taRightJustify
      end
      object PRLabel22: TPRLabel
        Left = 412
        Top = 294
        Width = 37
        Height = 17
        FontColor = clWhite
        FontName = fnArial
        FontSize = 10
        Caption = 'Rate'
        Alignment = taRightJustify
      end
      object PRLabel23: TPRLabel
        Left = 480
        Top = 294
        Width = 45
        Height = 17
        FontColor = clWhite
        FontName = fnArial
        FontSize = 10
        Caption = 'Amount'
      end
      object qrlFieldLabel4: TPRLabel
        Left = 328
        Top = 247
        Width = 37
        Height = 21
        FontName = fnArial
        FontSize = 11
        Caption = 'GST'
      end
      object qrlField4: TPRLabel
        Left = 328
        Top = 268
        Width = 133
        Height = 17
        FontName = fnArial
        FontSize = 11
        FontBold = True
        Caption = 'Inclusive'
      end
      object qrlDocNum: TPRLabel
        Left = 272
        Top = 108
        Width = 89
        Height = 21
        FontName = fnArial
        FontSize = 18
        FontBold = True
        Caption = 'qrlDocNum'
      end
      object qrlToAddress: TPRText
        Left = 16
        Top = 184
        Width = 233
        Height = 49
        FontName = fnArial
        FontSize = 12
        Leading = 14
      end
      object qrlHeaderAddress: TPRText
        Left = 320
        Top = 36
        Width = 205
        Height = 57
        FontName = fnArial
        FontSize = 12
        Leading = 14
      end
      object PRRect9: TPRRect
        Left = 360
        Top = 104
        Width = 101
        Height = 17
        LineStyle = psSolid
        FillColor = clBlack
      end
      object PRLabel1: TPRLabel
        Left = 364
        Top = 106
        Width = 37
        Height = 21
        FontColor = clWhite
        FontName = fnArial
        FontSize = 12
        Caption = 'Date'
      end
      object qrlDocDate: TPRLabel
        Left = 368
        Top = 120
        Width = 81
        Height = 14
        FontName = fnArial
        FontSize = 14
        FontBold = True
        Caption = '15-May-2004'
        Alignment = taRightJustify
      end
      object PRRect3: TPRRect
        Left = 268
        Top = 148
        Width = 257
        Height = 89
        LineStyle = psSolid
      end
      object lblDeliverTo: TPRLabel
        Left = 272
        Top = 152
        Width = 161
        Height = 17
        FontName = fnArial
        FontSize = 10
        Caption = 'Deliver To:'
      end
      object qrlOrdDeliveryAddress: TPRText
        Left = 272
        Top = 168
        Width = 245
        Height = 61
        FontName = fnArial
        FontSize = 12
        Leading = 14
      end
      object PRRect12: TPRRect
        Left = 109
        Top = 244
        Width = 1
        Height = 41
        LineWidth = 1
        LineStyle = psSolid
      end
      object PRRect13: TPRRect
        Left = 213
        Top = 244
        Width = 1
        Height = 41
        LineWidth = 1
        LineStyle = psSolid
      end
      object PRRect14: TPRRect
        Left = 321
        Top = 244
        Width = 1
        Height = 41
        LineWidth = 1
        LineStyle = psSolid
      end
    end
    object PRLayoutPanel2: TPRLayoutPanel
      Left = 33
      Top = 709
      Width = 530
      Height = 100
      Align = alBottom
      object PRRect16: TPRRect
        Left = 324
        Top = 3
        Width = 201
        Height = 59
        LineStyle = psSolid
      end
      object PRRect15: TPRRect
        Left = 12
        Top = 3
        Width = 281
        Height = 95
        LineStyle = psSolid
      end
      object PRRect5: TPRRect
        Left = 324
        Top = 40
        Width = 108
        Height = 21
        LineStyle = psSolid
        FillColor = clBlack
      end
      object qrlTotalLabel: TPRLabel
        Left = 328
        Top = 44
        Width = 100
        Height = 17
        FontColor = clWhite
        FontName = fnArial
        FontSize = 14
        FontBold = True
        Caption = 'Total (inc Tax)'
      end
      object PRRect6: TPRRect
        Left = 324
        Top = 40
        Width = 201
        Height = 2
        LineStyle = psSolid
      end
      object qrlDocTotal: TPRLabel
        Left = 436
        Top = 44
        Width = 88
        Height = 17
        FontName = fnArial
        FontSize = 14
        FontBold = True
        Caption = '0.00'
        Alignment = taRightJustify
      end
      object qrlIncTaxTotal: TPRLabel
        Left = 440
        Top = 8
        Width = 80
        Height = 17
        Printable = False
        FontName = fnArial
        FontSize = 12
        Caption = 'qrlIncTaxTotal'
        Alignment = taRightJustify
      end
      object qrlTotalTax: TPRLabel
        Left = 328
        Top = 8
        Width = 100
        Height = 17
        Printable = False
        FontName = fnArial
        FontSize = 12
        Caption = 'qrlTotalTax'
      end
      object qrlSpecialInstructions: TPRText
        Left = 16
        Top = 25
        Width = 273
        Height = 72
        FontName = fnArial
        FontSize = 10
        Leading = 14
        WordWrap = True
      end
      object lblDeliveryCharge: TPRLabel
        Left = 328
        Top = 24
        Width = 100
        Height = 17
        FontName = fnArial
        FontSize = 12
        Caption = 'Delivery Charge'
      end
      object qrlDeliveryCharge: TPRLabel
        Left = 440
        Top = 24
        Width = 80
        Height = 17
        FontName = fnArial
        FontSize = 12
        Caption = 'qrlIncTaxTotal'
        Alignment = taRightJustify
      end
      object PRLabel2: TPRLabel
        Left = 16
        Top = 6
        Width = 100
        Height = 15
        FontName = fnArial
        FontSize = 10
        Caption = 'Special Instructions'
      end
      object PRRect17: TPRRect
        Left = 12
        Top = 20
        Width = 281
        Height = 1
        LineWidth = 1
        LineStyle = psSolid
      end
    end
    object Band1: TPRLayoutPanel
      Left = 33
      Top = 345
      Width = 530
      Height = 58
      Align = alTop
      object qrlProduct1: TPRLabel
        Left = 16
        Top = 7
        Width = 53
        Height = 14
        FontName = fnArial
        FontSize = 10
        Caption = 'qrlProduct'
      end
      object qrlName1: TPRText
        Left = 68
        Top = 4
        Width = 225
        Height = 18
        FontName = fnArial
        FontSize = 12
        Leading = 14
        WordWrap = True
      end
      object qrlDesc1: TPRText
        Left = 68
        Top = 24
        Width = 225
        Height = 29
        FontName = fnArial
        FontSize = 12
        Leading = 14
      end
      object qrlQty1: TPRLabel
        Left = 308
        Top = 7
        Width = 45
        Height = 14
        FontName = fnArial
        FontSize = 12
        Caption = 'qrlQuantity'
        Alignment = taCenter
      end
      object qrlUnit1: TPRLabel
        Left = 368
        Top = 7
        Width = 41
        Height = 14
        FontName = fnArial
        FontSize = 12
        Caption = 'qrlUnit'
        Alignment = taRightJustify
      end
      object qrlRate1: TPRLabel
        Left = 408
        Top = 7
        Width = 45
        Height = 14
        FontName = fnArial
        FontSize = 12
        Caption = 'qrlRate'
        Alignment = taRightJustify
      end
      object qrlAmount1: TPRLabel
        Left = 464
        Top = 7
        Width = 52
        Height = 14
        FontName = fnArial
        FontSize = 12
        Caption = 'qrlAmount'
        Alignment = taRightJustify
      end
    end
    object Band2: TPRLayoutPanel
      Left = 33
      Top = 403
      Width = 530
      Height = 50
      Align = alTop
      object qrlProduct2: TPRLabel
        Left = 16
        Top = 7
        Width = 53
        Height = 14
        FontName = fnArial
        FontSize = 10
        Caption = 'qrlProduct'
      end
      object qrlQty2: TPRLabel
        Left = 308
        Top = 7
        Width = 45
        Height = 14
        FontName = fnArial
        FontSize = 12
        Caption = 'qrlQuantity'
        Alignment = taCenter
      end
      object qrlUnit2: TPRLabel
        Left = 368
        Top = 7
        Width = 41
        Height = 14
        FontName = fnArial
        FontSize = 12
        Caption = 'qrlUnit'
        Alignment = taRightJustify
      end
      object qrlRate2: TPRLabel
        Left = 416
        Top = 7
        Width = 37
        Height = 14
        FontName = fnArial
        FontSize = 12
        Caption = 'qrlRate'
        Alignment = taRightJustify
      end
      object qrlAmount2: TPRLabel
        Left = 464
        Top = 7
        Width = 52
        Height = 14
        FontName = fnArial
        FontSize = 12
        Caption = 'qrlAmount'
        Alignment = taRightJustify
      end
      object qrlName2: TPRText
        Left = 68
        Top = 4
        Width = 225
        Height = 18
        FontName = fnArial
        FontSize = 12
        Leading = 14
        WordWrap = True
      end
      object qrlDesc2: TPRText
        Left = 68
        Top = 24
        Width = 225
        Height = 17
        FontName = fnArial
        FontSize = 12
        Leading = 14
        WordWrap = True
      end
    end
    object Band5: TPRLayoutPanel
      Left = 33
      Top = 551
      Width = 530
      Height = 63
      Align = alTop
      object qrlProduct5: TPRLabel
        Left = 16
        Top = 7
        Width = 53
        Height = 14
        FontName = fnArial
        FontSize = 10
        Caption = 'qrlProduct'
      end
      object qrlName5: TPRText
        Left = 64
        Top = 6
        Width = 229
        Height = 18
        FontName = fnArial
        FontSize = 12
        Leading = 14
        WordWrap = True
      end
      object qrlDesc5: TPRText
        Left = 64
        Top = 23
        Width = 229
        Height = 17
        FontName = fnArial
        FontSize = 12
        Leading = 14
        WordWrap = True
      end
      object qrlQty5: TPRLabel
        Left = 308
        Top = 7
        Width = 45
        Height = 14
        FontName = fnArial
        FontSize = 12
        Caption = 'qrlQty4'
        Alignment = taCenter
      end
      object qrlUnit5: TPRLabel
        Left = 368
        Top = 7
        Width = 41
        Height = 14
        FontName = fnArial
        FontSize = 12
        Caption = 'qrlUnit'
        Alignment = taRightJustify
      end
      object qrlRate5: TPRLabel
        Left = 420
        Top = 6
        Width = 37
        Height = 14
        FontName = fnArial
        FontSize = 12
        Caption = 'qrlRate'
        Alignment = taRightJustify
      end
      object qrlAmount5: TPRLabel
        Left = 464
        Top = 6
        Width = 52
        Height = 14
        FontName = fnArial
        FontSize = 12
        Caption = 'qrlAmount'
        Alignment = taRightJustify
      end
    end
    object Band4: TPRLayoutPanel
      Left = 33
      Top = 501
      Width = 530
      Height = 50
      Align = alTop
      object qrlProduct4: TPRLabel
        Left = 16
        Top = 7
        Width = 53
        Height = 14
        FontName = fnArial
        FontSize = 10
        Caption = 'qrlProduct4'
      end
      object qrlName4: TPRText
        Left = 64
        Top = 6
        Width = 229
        Height = 18
        FontName = fnArial
        FontSize = 12
        Leading = 14
        WordWrap = True
      end
      object qrlDesc4: TPRText
        Left = 64
        Top = 27
        Width = 229
        Height = 17
        FontName = fnArial
        FontSize = 12
        Leading = 14
        WordWrap = True
      end
      object qrlQty4: TPRLabel
        Left = 308
        Top = 7
        Width = 45
        Height = 14
        FontName = fnArial
        FontSize = 12
        Caption = 'qrlQty4'
        Alignment = taCenter
      end
      object qrlUnit4: TPRLabel
        Left = 368
        Top = 7
        Width = 41
        Height = 14
        FontName = fnArial
        FontSize = 12
        Caption = 'qrlUnit4'
        Alignment = taRightJustify
      end
      object qrlRate4: TPRLabel
        Left = 420
        Top = 6
        Width = 37
        Height = 14
        FontName = fnArial
        FontSize = 12
        Caption = 'qrlRate4'
        Alignment = taRightJustify
      end
      object qrlAmount4: TPRLabel
        Left = 464
        Top = 2
        Width = 52
        Height = 14
        FontName = fnArial
        FontSize = 12
        Caption = 'qrlAmount4'
        Alignment = taRightJustify
      end
    end
    object Band3: TPRLayoutPanel
      Left = 33
      Top = 453
      Width = 530
      Height = 48
      Align = alTop
      object qrlProduct3: TPRLabel
        Left = 16
        Top = 7
        Width = 53
        Height = 14
        FontName = fnArial
        FontSize = 10
        Caption = 'qrlProduct'
      end
      object qrlName3: TPRText
        Left = 60
        Top = 6
        Width = 233
        Height = 18
        FontName = fnArial
        FontSize = 12
        Leading = 14
        WordWrap = True
      end
      object qrlDesc3: TPRText
        Left = 60
        Top = 27
        Width = 233
        Height = 17
        FontName = fnArial
        FontSize = 12
        Leading = 14
        WordWrap = True
      end
      object qrlQty3: TPRLabel
        Left = 308
        Top = 7
        Width = 45
        Height = 14
        FontName = fnArial
        FontSize = 12
        Caption = 'qrlQuantity'
        Alignment = taCenter
      end
      object qrlUnit3: TPRLabel
        Left = 368
        Top = 7
        Width = 41
        Height = 14
        FontName = fnArial
        FontSize = 12
        Caption = 'qrlUnit'
        Alignment = taRightJustify
      end
      object qrlAmount3: TPRLabel
        Left = 464
        Top = 6
        Width = 52
        Height = 14
        FontName = fnArial
        FontSize = 12
        Caption = 'qrlAmount'
        Alignment = taRightJustify
      end
      object qrlRate3: TPRLabel
        Left = 420
        Top = 6
        Width = 37
        Height = 14
        FontName = fnArial
        FontSize = 12
        Caption = 'qrlRate'
        Alignment = taRightJustify
      end
    end
  end
  object bsSkinButton1: TbsSkinButton
    Left = 4
    Top = 252
    Width = 75
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
    Caption = 'OpenPDF'
    NumGlyphs = 1
    Spacing = 1
    OnClick = bsSkinButton1Click
  end
  object PDFReport: TPReport
    FileName = 'default.pdf'
    CreationDate = 38125.871883588
    UseOutlines = False
    ViewerPreference = []
    Left = 8
    Top = 48
  end
end
