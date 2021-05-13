object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'MainForm'
  ClientHeight = 481
  ClientWidth = 1032
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Padding.Left = 4
  Padding.Top = 4
  Padding.Right = 4
  Padding.Bottom = 4
  OldCreateOrder = False
  OnCreate = FormCreate
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 15
  object GnvToolBar3: TGnvToolBar
    Left = 4
    Top = 51
    Width = 1024
    Height = 22
    Align = alTop
    AutoSize = True
    Borders = [gbLeft, gbRight]
    Buttons = <
      item
        Caption = 'Text'
        ParentImages = False
        Kind = gtkLink
      end
      item
        Caption = 'Text-Arrow'
        Kind = gtkLink
        ShowArrow = True
      end
      item
        Caption = 'Glyph'
        Glyph = glPlus
        Kind = gtkLink
        Style = gtsImage
      end
      item
        Caption = 'Glyph-Arrow'
        Glyph = glPlus
        Kind = gtkLink
        ShowArrow = True
        Style = gtsImage
      end
      item
        Caption = 'Glyph-Text'
        Glyph = glPlus
        Kind = gtkLink
      end
      item
        Caption = 'Glyph-Text-Arrow'
        Glyph = glPlus
        GlyphDirection = gdUp
        Kind = gtkLink
        ShowArrow = True
      end
      item
        Caption = 'Image'
        Kind = gtkLink
        Style = gtsImage
        ImageIndex = 0
      end
      item
        Caption = 'Image-Arrow'
        Kind = gtkLink
        ShowArrow = True
        Style = gtsImage
        ImageIndex = 0
      end
      item
        Caption = 'Image-Text'
        Kind = gtkLink
        ImageIndex = 0
      end
      item
        Caption = 'Image-Text-Arrow'
        Kind = gtkLink
        ShowArrow = True
        ImageIndex = 0
      end>
    ParentColor = False
    Images = ImageList2
    Padding.Left = 1
    Padding.Top = 1
    Padding.Right = 1
    Padding.Bottom = 1
    Transparent = True
  end
  object GnvToolBar1: TGnvToolBar
    Left = 4
    Top = 29
    Width = 1024
    Height = 22
    Align = alTop
    AutoSize = True
    Borders = [gbLeft, gbRight]
    Buttons = <
      item
        Caption = 'Text'
        ParentImages = False
        Kind = gtkLabel
      end
      item
        Caption = 'Text-Arrow'
        Kind = gtkLabel
        ShowArrow = True
      end
      item
        Caption = 'Glyph'
        Glyph = glPlus
        Kind = gtkLabel
        Style = gtsImage
      end
      item
        Caption = 'Glyph-Arrow'
        Glyph = glPlus
        Kind = gtkLabel
        ShowArrow = True
        Style = gtsImage
      end
      item
        Caption = 'Glyph-Text'
        Glyph = glPlus
        Kind = gtkLabel
      end
      item
        Caption = 'Glyph-Text-Arrow'
        Glyph = glPlus
        GlyphDirection = gdUp
        Kind = gtkLabel
        ShowArrow = True
      end
      item
        Caption = 'Image'
        Kind = gtkLabel
        Style = gtsImage
        ImageIndex = 0
      end
      item
        Caption = 'Image-Arrow'
        Kind = gtkLabel
        ShowArrow = True
        Style = gtsImage
        ImageIndex = 0
      end
      item
        Caption = 'Image-Text'
        Kind = gtkLabel
        ImageIndex = 0
      end
      item
        Caption = 'Image-Text-Arrow'
        Kind = gtkLabel
        ShowArrow = True
        ImageIndex = 0
      end>
    ParentColor = False
    Images = ImageList2
    Padding.Left = 1
    Padding.Top = 1
    Padding.Right = 1
    Padding.Bottom = 1
    Transparent = True
  end
  object GnvToolBar2: TGnvToolBar
    Left = 4
    Top = 4
    Width = 1024
    Height = 25
    Align = alTop
    AutoSize = True
    Borders = [gbTop, gbLeft, gbRight]
    Buttons = <
      item
        Caption = 'Text'
        ParentImages = False
      end
      item
        Caption = 'Text-Arrow'
        ShowArrow = True
      end
      item
        Caption = 'Glyph'
        Glyph = glCaret
        Style = gtsImage
      end
      item
        Caption = 'Glyph-Arrow'
        Glyph = glPlus
        ShowArrow = True
        Style = gtsImage
      end
      item
        Caption = 'Glyph-Text'
        Glyph = glPlus
      end
      item
        Caption = 'Glyph-Text-Arrow'
        Glyph = glPlus
        GlyphDirection = gdUp
        ShowArrow = True
      end
      item
        Caption = 'Image'
        Style = gtsImage
        ImageIndex = 0
      end
      item
        Caption = 'Image-Arrow'
        ShowArrow = True
        Style = gtsImage
        ImageIndex = 0
      end
      item
        Caption = 'Image-Text'
        ImageIndex = 0
      end
      item
        Caption = 'Image-Text-Arrow'
        ShowArrow = True
        ImageIndex = 0
      end>
    ParentColor = False
    Images = ImageList2
    Padding.Left = 1
    Padding.Top = 1
    Padding.Right = 1
    Padding.Bottom = 1
    Scale = gss100
    Transparent = True
  end
  object GnvToolBar4: TGnvToolBar
    Left = 4
    Top = 73
    Width = 1024
    Height = 24
    Align = alTop
    AutoSize = True
    Borders = [gbLeft, gbRight]
    Buttons = <
      item
        Caption = 'Text'
        ParentImages = False
        Kind = gtkSwitch
      end
      item
        Caption = 'Text-Arrow'
        Kind = gtkSwitch
        ShowArrow = True
      end
      item
        Caption = 'Glyph'
        Glyph = glPlus
        Kind = gtkSwitch
        Style = gtsImage
      end
      item
        Caption = 'Glyph-Arrow'
        Glyph = glPlus
        Kind = gtkSwitch
        ShowArrow = True
        Style = gtsImage
      end
      item
        Caption = 'Glyph-Text'
        Glyph = glPlus
        Kind = gtkSwitch
      end
      item
        Caption = 'Glyph-Text-Arrow'
        Glyph = glPlus
        GlyphDirection = gdUp
        Kind = gtkSwitch
        ShowArrow = True
      end
      item
        Caption = 'Image'
        Kind = gtkSwitch
        Style = gtsImage
        ImageIndex = 0
      end
      item
        Caption = 'Image-Arrow'
        Kind = gtkSwitch
        ShowArrow = True
        Style = gtsImage
        ImageIndex = 0
      end
      item
        Caption = 'Image-Text'
        Kind = gtkSwitch
        ImageIndex = 0
      end
      item
        Caption = 'Image-Text-Arrow'
        Kind = gtkSwitch
        ShowArrow = True
        ImageIndex = 0
      end>
    ParentColor = False
    Images = ImageList2
    Padding.Left = 1
    Padding.Top = 1
    Padding.Right = 1
    Padding.Bottom = 1
    Transparent = True
  end
  object GnvTabBar1_1: TGnvTabBar
    Left = 27
    Top = 248
    Width = 214
    Height = 180
    Buttons = [gtbShift, gtbClose, gtbPlus, gtbPrevious, gtbNext]
    ButtonWidth = 18
    TabIndex = 0
    Tabs = <
      item
        GroupIndex = 0
        Caption = 'Test'
      end>
    Sizing = gisValue
    Style.FlatColor = gscCtrl
    Style.PlasticColor1 = gscCtrl
    Style.PlasticColor2 = gscCtrlShade0125
  end
  object ToolBarGlyphs: TGnvToolBar
    Left = 4
    Top = 97
    Width = 1024
    Height = 31
    Align = alTop
    AutoSize = True
    Borders = [gbLeft, gbRight]
    Buttons = <
      item
        Glyph = glPlus
        Name = 'Plus'
      end
      item
        Glyph = glMinus
        Name = 'Minus'
      end
      item
        Glyph = glMenu
        Name = 'Menu'
      end
      item
        Glyph = glRound
        Name = 'Round'
      end
      item
        Glyph = glSync
        Name = 'Sync'
      end
      item
        Glyph = glClose
        Name = 'Close'
      end
      item
        Kind = gtkSeparator
      end
      item
        Glyph = glUpdate
        GlyphDirection = gdLeft
        Name = 'UpdateForwardLeft'
        Kind = gtkSwitch
        Style = gtsImage
      end
      item
        Glyph = glUpdate
        GlyphDirection = gdUp
        Name = 'UpdateForwardUp'
        Kind = gtkSwitch
        Style = gtsImage
      end
      item
        Glyph = glUpdate
        GlyphDirection = gdRight
        Name = 'UpdateForwardRight'
        Kind = gtkSwitch
        Style = gtsImage
      end
      item
        Glyph = glUpdate
        Name = 'UpdateForwardDown'
        Kind = gtkSwitch
        Style = gtsImage
      end
      item
        Kind = gtkSeparator
        ShowArrow = True
      end
      item
        Caption = 'Glyph'
        Glyph = glUpdate
        GlyphDirection = gdRight
        GlyphOrientation = goBackward
        Name = 'UpdateBackwardRight'
        Kind = gtkSwitch
        Style = gtsImage
      end
      item
        Caption = 'Glyph'
        Glyph = glUpdate
        GlyphDirection = gdUp
        GlyphOrientation = goBackward
        Name = 'UpdateBackwardUp'
        Kind = gtkSwitch
        Style = gtsImage
      end
      item
        Caption = 'Glyph'
        Glyph = glUpdate
        GlyphDirection = gdLeft
        GlyphOrientation = goBackward
        Name = 'UpdateBackwardLeft'
        Kind = gtkSwitch
        Style = gtsImage
      end
      item
        Caption = 'Glyph'
        Glyph = glUpdate
        GlyphOrientation = goBackward
        Name = 'UpdateBackwardDown'
        Kind = gtkSwitch
        Style = gtsImage
      end
      item
        Kind = gtkSeparator
      end
      item
        Glyph = glCaret
        Name = 'CaretDown'
      end
      item
        Glyph = glCaret
        GlyphDirection = gdLeft
        Name = 'CaretLeft'
      end
      item
        Glyph = glCaret
        GlyphDirection = gdUp
        Name = 'CaretUp'
      end
      item
        Glyph = glCaret
        GlyphDirection = gdRight
        Name = 'CaretRight'
      end
      item
        Kind = gtkSeparator
      end
      item
        Glyph = glPane
        GlyphDirection = gdLeft
        Name = 'PaneLeft'
      end
      item
        Glyph = glPane
        GlyphDirection = gdUp
        Name = 'PaneUp'
      end
      item
        Glyph = glPane
        GlyphDirection = gdRight
        Name = 'PaneRight'
      end
      item
        Glyph = glPane
        Name = 'PaneDown'
      end
      item
        Kind = gtkSeparator
      end
      item
        Glyph = glSearch
        Name = 'SearchForward'
      end
      item
        Glyph = glSearch
        GlyphOrientation = goBackward
        Name = 'SearchBackward'
      end
      item
        Kind = gtkSeparator
      end
      item
        Glyph = glChevron
        GlyphDirection = gdLeft
        Name = 'ChevronLeft'
      end
      item
        Glyph = glChevron
        GlyphDirection = gdUp
        Name = 'ChevronUp'
      end
      item
        Glyph = glChevron
        GlyphDirection = gdRight
        Name = 'ChevronRight'
      end
      item
        Glyph = glChevron
        Name = 'ChevronDown'
      end
      item
        Kind = gtkSeparator
      end
      item
        Glyph = glArrow
        GlyphDirection = gdLeft
        Name = 'ArrowLeft'
      end
      item
        Glyph = glArrow
        GlyphDirection = gdUp
        Name = 'ArrowUp'
      end
      item
        Glyph = glArrow
        GlyphDirection = gdRight
        Name = 'ArrowRight'
      end
      item
        Glyph = glArrow
        Name = 'ArrowDown'
      end>
    ParentColor = False
    Images = ImageList2
    Padding.Left = 1
    Padding.Top = 1
    Padding.Right = 1
    Padding.Bottom = 1
    Scale = gss100
    Transparent = True
  end
  object ComboBoxScale: TComboBox
    Left = 640
    Top = 376
    Width = 185
    Height = 23
    Style = csDropDownList
    ItemHeight = 15
    TabOrder = 6
    OnSelect = ComboBoxScaleSelect
  end
  object ComboBoxTheme: TComboBox
    Left = 640
    Top = 405
    Width = 185
    Height = 23
    Style = csDropDownList
    ItemHeight = 15
    TabOrder = 7
    OnSelect = ComboBoxThemeSelect
  end
  object ImageList1: TImageList
    ColorDepth = cd32Bit
    Left = 392
    Top = 400
  end
  object ImageList2: TImageList
    ColorDepth = cd32Bit
    Left = 312
    Top = 400
    Bitmap = {
      494C010101000500040010001000FFFFFFFF2110FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      0000000000000000000000000000000000000000FFFF0000FFFF0000FFFF0000
      FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000
      FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FFFF0000FFFF0000FFFF0000
      FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000
      FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FFFF0000FFFF0000FFFF0000
      FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000
      FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FFFF0000FFFF0000FFFF0000
      FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000
      FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FFFF0000FFFF0000FFFF0000
      FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000
      FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FFFF0000FFFF0000FFFF0000
      FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000
      FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FFFF0000FFFF0000FFFF0000
      FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000
      FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FFFF0000FFFF0000FFFF0000
      FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000
      FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FFFF0000FFFF0000FFFF0000
      FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000
      FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FFFF0000FFFF0000FFFF0000
      FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000
      FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FFFF0000FFFF0000FFFF0000
      FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000
      FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FFFF0000FFFF0000FFFF0000
      FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000
      FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FFFF0000FFFF0000FFFF0000
      FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000
      FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FFFF0000FFFF0000FFFF0000
      FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000
      FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FFFF0000FFFF0000FFFF0000
      FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000
      FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FFFF0000FFFF0000FFFF0000
      FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000
      FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000}
  end
  object PopupMenuTest: TPopupMenu
    Left = 488
    Top = 400
  end
end
