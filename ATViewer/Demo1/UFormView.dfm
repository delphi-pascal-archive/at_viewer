object FormView: TFormView
  Left = 188
  Top = 119
  ActiveControl = Viewer
  AutoScroll = False
  Caption = 'Viewer'
  ClientHeight = 394
  ClientWidth = 672
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Shell Dlg'
  Font.Style = []
  Icon.Data = {
    000001000200101010000000000028010000260000002020100000000000E802
    00004E0100002800000010000000200000000100040000000000C00000000000
    0000000000000000000000000000000000000000800000800000008080008000
    00008000800080800000C0C0C000808080000000FF0000FF000000FFFF00FF00
    0000FF00FF00FFFF0000FFFFFF000000000000000000087777777777700008FF
    FFFFFFFF700008F77777777F700008FFFFFFFFFF700008F77777777F700008FF
    FFFFFFFF700008F77777777F700008FFFFFFFFFF700008F77777777F700008FF
    FFFFFFFF700008F777777700000008FFFFFFFF7F800008FFFFFFFF7800000888
    88888880000000000000000000008003101480030000800300008003C0C08003
    C0C08003C0C08003FFFF8003C0C0800300008003FFFF8003FFFF8003FFFF8007
    FFFF800FC0C0801F0000FFFFC0C0280000002000000040000000010004000000
    0000800200000000000000000000000000000000000000000000000080000080
    000000808000800000008000800080800000C0C0C000808080000000FF0000FF
    000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0000000000000000000000
    0000000000000000000000000000000000000000000000008777777777777777
    77777777000000008FFFFFFFFFFFFFFFFFFFFFF7000000008FFFFFFFFFFFFFFF
    FFFFFFF7000000008FFFFFFFFFFFFFFFFFFFFFF7000000008FFFF77777777777
    777FFFF7000000008FFFFFFFFFFFFFFFFFFFFFF7000000008FFFF77777777777
    777FFFF7000000008FFFFFFFFFFFFFFFFFFFFFF7000000008FFFF77777777777
    777FFFF7000000008FFFFFFFFFFFFFFFFFFFFFF7000000008FFFF77777777777
    777FFFF7000000008FFFFFFFFFFFFFFFFFFFFFF7000000008FFFF77777777777
    777FFFF7000000008FFFFFFFFFFFFFFFFFFFFFF7000000008FFFF77777777777
    777FFFF7000000008FFFFFFFFFFFFFFFFFFFFFF7000000008FFFF77777777777
    777FFFF7000000008FFFFFFFFFFFFFFFFFFFFFF7000000008FFFF77777777777
    777FFFF7000000008FFFFFFFFFFFFFFFFFFFFFF7000000008FFFF77777777777
    777FFFF7000000008FFFFFFFFFFFFFFFF8000000000000008FFFF77777777777
    78FFF780000000008FFFFFFFFFFFFFFFF8FF7800000000008FFFFFFFFFFFFFFF
    F8F78000000000008FFFFFFFFFFFFFFFF8780000000000008FFFFFFFFFFFFFFF
    F8800000000000008FFFFFFFFFFFFFFFF8000000000000008888888888888888
    88000000000000000000000000000000000000000000FFFFFFFFF0000007F000
    0007F0000007F0000007F0000007F0000007F0000007F0000007F0000007F000
    0007F0000007F0000007F0000007F0000007F0000007F0000007F0000007F000
    0007F0000007F0000007F0000007F0000007F0000007F000000FF000001FF000
    003FF000007FF00000FFF00001FFF00003FFFFFFFFFF}
  KeyPreview = True
  Menu = MainMenu1
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Viewer: TATViewer
    Left = 0
    Top = 0
    Width = 672
    Height = 394
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    TextFont.Charset = DEFAULT_CHARSET
    TextFont.Color = clWindowText
    TextFont.Height = -13
    TextFont.Name = 'Courier New'
    TextFont.Style = []
    IsFocused = True
  end
  object MainMenu1: TMainMenu
    Left = 408
    object mnuFile: TMenuItem
      Caption = '&File'
      object mnuFileOpen: TMenuItem
        Caption = '&Open...'
        ShortCut = 16463
        OnClick = mnuFileOpenClick
      end
      object mnuFileReload: TMenuItem
        Caption = '&Reload'
        ShortCut = 16466
        Visible = False
        OnClick = mnuFileReloadClick
      end
      object mnuFileSaveAs: TMenuItem
        Caption = 'Save as...'
        ShortCut = 16467
        OnClick = mnuFileSaveAsClick
      end
      object mnuFileClose: TMenuItem
        Caption = '&Close'
        OnClick = mnuFileCloseClick
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object mnuFilePrint: TMenuItem
        Caption = '&Print...'
        ShortCut = 16464
        OnClick = mnuFilePrintClick
      end
      object mnuFilePrintPreview: TMenuItem
        Caption = 'Print previe&w...'
        OnClick = mnuFilePrintPreviewClick
      end
      object mnuFilePrintSetup: TMenuItem
        Caption = 'Page &setup...'
        OnClick = mnuFilePrintSetupClick
      end
      object N5: TMenuItem
        Caption = '-'
      end
      object mnuFileExit: TMenuItem
        Caption = 'E&xit'
        ShortCut = 27
        OnClick = mnuFileExitClick
      end
    end
    object Edit1: TMenuItem
      Caption = '&Edit'
      object mnuEditCopy: TMenuItem
        Caption = '&Copy'
        ShortCut = 16451
        OnClick = mnuEditCopyClick
      end
      object mnuEditSelectAll: TMenuItem
        Caption = 'Select &all'
        ShortCut = 16449
        OnClick = mnuEditSelectAllClick
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object mnuEditFind: TMenuItem
        Caption = '&Find...'
        ShortCut = 16454
        OnClick = mnuEditFindClick
      end
      object mnuEditFindNext: TMenuItem
        Caption = 'Find &next'
        ShortCut = 114
        OnClick = mnuEditFindNextClick
      end
      object N7: TMenuItem
        Caption = '-'
      end
      object mnuEditGoto: TMenuItem
        Caption = '&Go to...'
        ShortCut = 16455
        OnClick = mnuEditGotoClick
      end
    end
    object mnuOptions: TMenuItem
      Caption = '&Options'
      object mnuOptionsText: TMenuItem
        Caption = '&1  Text'
        GroupIndex = 1
        RadioItem = True
        ShortCut = 49
        OnClick = mnuOptionsTextClick
      end
      object mnuOptionsBinary: TMenuItem
        Caption = '&2  Binary (fixed line length)'
        GroupIndex = 1
        RadioItem = True
        ShortCut = 50
        OnClick = mnuOptionsBinaryClick
      end
      object mnuOptionsHex: TMenuItem
        Caption = '&3  Hex'
        GroupIndex = 1
        RadioItem = True
        ShortCut = 51
        OnClick = mnuOptionsHexClick
      end
      object mnuOptionsImage: TMenuItem
        Caption = '&4  Image/Multimedia'
        GroupIndex = 1
        RadioItem = True
        ShortCut = 52
        OnClick = mnuOptionsImageClick
      end
      object mnuOptionsWeb: TMenuItem
        Caption = '&5  Internet/Office'
        GroupIndex = 1
        RadioItem = True
        ShortCut = 53
        OnClick = mnuOptionsWebClick
      end
      object mnuOptionsUnicode: TMenuItem
        Caption = '&6  Unicode'
        GroupIndex = 1
        RadioItem = True
        ShortCut = 54
        OnClick = mnuOptionsUnicodeClick
      end
      object N2: TMenuItem
        Caption = '-'
        GroupIndex = 1
      end
      object mnuOptionsANSI: TMenuItem
        Caption = '&ANSI charset'
        GroupIndex = 2
        RadioItem = True
        ShortCut = 65
        OnClick = mnuOptionsANSIClick
      end
      object mnuOptionsOEM: TMenuItem
        Caption = 'OEM char&set'
        GroupIndex = 2
        RadioItem = True
        ShortCut = 83
        OnClick = mnuOptionsOEMClick
      end
      object N3: TMenuItem
        Caption = '-'
        GroupIndex = 2
      end
      object mnuOptionsWrap: TMenuItem
        Caption = '&Word wrap'
        GroupIndex = 3
        ShortCut = 87
        OnClick = mnuOptionsWrapClick
      end
      object mnuOptionsFit: TMenuItem
        Caption = '&Fit image to window'
        GroupIndex = 3
        ShortCut = 70
        OnClick = mnuOptionsFitClick
      end
      object mnuOptionsOffline: TMenuItem
        Caption = '&Offline browsing'
        GroupIndex = 3
        ShortCut = 79
        OnClick = mnuOptionsOfflineClick
      end
      object N6: TMenuItem
        Caption = '-'
        GroupIndex = 3
      end
      object mnuOptionsSettings: TMenuItem
        Caption = 'Se&ttings...'
        GroupIndex = 3
        OnClick = mnuOptionsSettingsClick
      end
    end
    object Help1: TMenuItem
      Caption = '&Help'
      object mnuHelpAbout: TMenuItem
        Caption = '&About'
        OnClick = mnuHelpAboutClick
      end
    end
  end
end
