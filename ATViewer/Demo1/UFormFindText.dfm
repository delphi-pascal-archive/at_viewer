object FormFindText: TFormFindText
  Left = 298
  Top = 346
  ActiveControl = edText
  BorderStyle = bsDialog
  Caption = 'Search'
  ClientHeight = 85
  ClientWidth = 346
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
  object Label1: TLabel
    Left = 8
    Top = 10
    Width = 49
    Height = 13
    Caption = '&Find what:'
    FocusControl = edText
  end
  object btnOk: TButton
    Left = 264
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Find'
    Default = True
    ModalResult = 1
    TabOrder = 3
  end
  object btnCancel: TButton
    Left = 264
    Top = 40
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 4
  end
  object chkWords: TCheckBox
    Left = 8
    Top = 40
    Width = 249
    Height = 17
    Caption = '&Whole words only'
    TabOrder = 1
  end
  object chkCase: TCheckBox
    Left = 8
    Top = 58
    Width = 249
    Height = 17
    Caption = '&Case sensitive'
    TabOrder = 2
  end
  object edText: TComboBox
    Left = 72
    Top = 8
    Width = 185
    Height = 21
    ItemHeight = 13
    TabOrder = 0
  end
end
