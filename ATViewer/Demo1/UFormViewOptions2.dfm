object FormViewOptions2: TFormViewOptions2
  Left = 444
  Top = 370
  ActiveControl = chkDetect
  BorderStyle = bsDialog
  Caption = 'Viewer settings'
  ClientHeight = 112
  ClientWidth = 266
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
  object labDetect1: TLabel
    Left = 24
    Top = 29
    Width = 34
    Height = 13
    Caption = 'by first'
  end
  object labDetect2: TLabel
    Left = 128
    Top = 29
    Width = 12
    Height = 13
    Caption = 'Kb'
  end
  object labDetectL1: TLabel
    Left = 24
    Top = 53
    Width = 63
    Height = 13
    Caption = 'maximal size:'
  end
  object labDetectL2: TLabel
    Left = 136
    Top = 53
    Width = 81
    Height = 13
    Caption = 'Kb (0: don'#39't limit)'
  end
  object chkDetect: TCheckBox
    Left = 8
    Top = 8
    Width = 257
    Height = 17
    Caption = '&Auto-detect text files'
    TabOrder = 0
    OnClick = chkDetectClick
  end
  object btnCancel: TButton
    Left = 136
    Top = 80
    Width = 81
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 4
  end
  object btnOk: TButton
    Left = 48
    Top = 80
    Width = 81
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 3
  end
  object edDetectSize: TEdit
    Left = 96
    Top = 26
    Width = 25
    Height = 21
    TabOrder = 1
  end
  object edDetectLimit: TEdit
    Left = 96
    Top = 50
    Width = 33
    Height = 21
    TabOrder = 2
  end
end
