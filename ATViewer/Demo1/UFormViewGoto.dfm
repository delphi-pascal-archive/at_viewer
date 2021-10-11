object FormViewGoto: TFormViewGoto
  Left = 374
  Top = 330
  ActiveControl = edNum
  BorderStyle = bsDialog
  Caption = 'Go to'
  ClientHeight = 73
  ClientWidth = 170
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Shell Dlg'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object labDetect1: TLabel
    Left = 8
    Top = 13
    Width = 68
    Height = 13
    Caption = '&Go to position:'
    FocusControl = edNum
  end
  object Label1: TLabel
    Left = 128
    Top = 13
    Width = 8
    Height = 13
    Caption = '%'
  end
  object btnOk: TButton
    Left = 8
    Top = 40
    Width = 73
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object btnCancel: TButton
    Left = 88
    Top = 40
    Width = 73
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object edNum: TEdit
    Left = 96
    Top = 10
    Width = 28
    Height = 21
    TabOrder = 0
  end
end
