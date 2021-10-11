object FormViewOptions: TFormViewOptions
  Left = 340
  Top = 206
  ActiveControl = edText
  BorderStyle = bsDialog
  Caption = 'Viewer settings'
  ClientHeight = 279
  ClientWidth = 481
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object btnOk: TButton
    Left = 304
    Top = 248
    Width = 81
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 3
  end
  object btnCancel: TButton
    Left = 392
    Top = 248
    Width = 81
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 4
  end
  object boxExt: TGroupBox
    Left = 8
    Top = 4
    Width = 465
    Height = 117
    Caption = 'File extensions'
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 20
      Width = 26
      Height = 13
      Caption = '&Text:'
      FocusControl = edText
    end
    object Label2: TLabel
      Left = 8
      Top = 44
      Width = 39
      Height = 13
      Caption = '&Images:'
      FocusControl = edImages
    end
    object Label3: TLabel
      Left = 8
      Top = 68
      Width = 32
      Height = 13
      Caption = '&Media:'
      FocusControl = edMedia
    end
    object Label4: TLabel
      Left = 8
      Top = 92
      Width = 44
      Height = 13
      Caption = 'I&nternet:'
      FocusControl = edInternet
    end
    object edText: TEdit
      Left = 88
      Top = 16
      Width = 341
      Height = 21
      TabOrder = 0
    end
    object edImages: TEdit
      Left = 88
      Top = 40
      Width = 341
      Height = 21
      TabOrder = 2
    end
    object edMedia: TEdit
      Left = 88
      Top = 64
      Width = 341
      Height = 21
      TabOrder = 3
    end
    object edInternet: TEdit
      Left = 88
      Top = 88
      Width = 341
      Height = 21
      TabOrder = 4
    end
    object btnTextOptions: TButton
      Left = 434
      Top = 16
      Width = 25
      Height = 21
      Caption = '...'
      TabOrder = 1
      OnClick = btnTextOptionsClick
    end
  end
  object boxText: TGroupBox
    Left = 8
    Top = 124
    Width = 201
    Height = 149
    Caption = 'Text modes'
    TabOrder = 1
    object labTextFont: TLabel
      Left = 88
      Top = 21
      Width = 22
      Height = 13
      Caption = 'Font'
    end
    object Label5: TLabel
      Left = 40
      Top = 104
      Width = 78
      Height = 13
      Caption = 'Fi&xed text width'
      FocusControl = edTextWidth
    end
    object Label6: TLabel
      Left = 40
      Top = 128
      Width = 135
      Height = 13
      Caption = 'Search &result: lines from top'
      FocusControl = edTextIndent
    end
    object btnTextColor: TButton
      Left = 8
      Top = 46
      Width = 73
      Height = 25
      Caption = '&Color...'
      TabOrder = 1
      OnClick = btnTextColorClick
    end
    object btnTextFont: TButton
      Left = 8
      Top = 16
      Width = 73
      Height = 25
      Caption = '&Font...'
      TabOrder = 0
      OnClick = btnTextFontClick
    end
    object edTextWidth: TEdit
      Left = 8
      Top = 100
      Width = 25
      Height = 21
      TabOrder = 3
    end
    object edTextIndent: TEdit
      Left = 8
      Top = 124
      Width = 25
      Height = 21
      TabOrder = 4
    end
    object chkTextWidthFit: TCheckBox
      Left = 8
      Top = 78
      Width = 185
      Height = 17
      Caption = '&Auto-fit text width'
      TabOrder = 2
      OnClick = chkTextWidthFitClick
    end
  end
  object boxMedia: TGroupBox
    Left = 216
    Top = 124
    Width = 257
    Height = 61
    Caption = 'Multimedia mode'
    TabOrder = 2
    object chkMediaMCI: TRadioButton
      Left = 8
      Top = 16
      Width = 241
      Height = 17
      Caption = 'Use &standard media interface'
      TabOrder = 0
    end
    object chkMediaWMP64: TRadioButton
      Left = 8
      Top = 34
      Width = 241
      Height = 17
      Caption = 'Use &Windows Media Player 6.4 interface'
      TabOrder = 1
    end
  end
  object FontDialog1: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Shell Dlg'
    Font.Style = []
    MinFontSize = 0
    MaxFontSize = 0
    Left = 288
    Top = 4
  end
  object ColorDialog1: TColorDialog
    Ctl3D = True
    Left = 312
    Top = 4
  end
end
