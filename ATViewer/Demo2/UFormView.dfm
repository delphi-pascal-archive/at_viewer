object FormView: TFormView
  Left = 190
  Top = 121
  Width = 810
  Height = 500
  Caption = 'ATViewer Demo'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 321
    Top = 0
    Width = 4
    Height = 473
    Cursor = crHSplit
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 300
    Height = 473
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 0
    object Splitter2: TSplitter
      Left = 121
      Top = 0
      Width = 4
      Height = 473
      Cursor = crHSplit
    end
    object TreeEx: TVirtualExplorerTreeview
      Left = 0
      Top = 0
      Width = 140
      Height = 473
      Active = True
      Align = alLeft
      ColumnDetails = cdUser
      DefaultNodeHeight = 17
      DragHeight = 250
      DragWidth = 150
      FileSizeFormat = fsfExplorer
      FileSort = fsFileType
      Header.AutoSizeIndex = 0
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'MS Shell Dlg'
      Header.Font.Style = []
      Header.MainColumn = -1
      Header.Options = [hoColumnResize, hoDrag]
      HintMode = hmHint
      ParentColor = False
      RootFolder = rfDrives
      TabOrder = 0
      TabStop = True
      TreeOptions.AutoOptions = [toAutoScroll]
      TreeOptions.MiscOptions = [toAcceptOLEDrop, toEditable, toToggleOnDblClick]
      TreeOptions.PaintOptions = [toShowButtons, toShowTreeLines, toUseBlendedImages, toGhostedIfUnfocused]
      TreeOptions.SelectionOptions = [toLevelSelectConstraint]
      TreeOptions.VETShellOptions = [toContextMenus]
      TreeOptions.VETSyncOptions = [toCollapseTargetFirst, toExpandTarget, toSelectTarget]
      TreeOptions.VETMiscOptions = [toBrowseExecuteFolder, toBrowseExecuteFolderShortcut, toBrowseExecuteZipFolder, toChangeNotifierThread, toRemoveContextMenuShortCut]
      TreeOptions.VETImageOptions = [toImages, toThreadedImages, toMarkCutAndCopy]
      VirtualExplorerListview = LVEx
      Columns = <>
    end
    object LVEx: TVirtualExplorerListview
      Left = 124
      Top = 0
      Width = 180
      Height = 473
      Active = True
      Align = alClient
      ColumnDetails = cdShellColumns
      DefaultNodeHeight = 17
      DragHeight = 250
      DragWidth = 150
      FileObjects = [foFolders, foNonFolders, foHidden]
      FileSizeFormat = fsfExplorer
      FileSort = fsFileType
      Header.AutoSizeIndex = -1
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'MS Shell Dlg'
      Header.Font.Style = []
      Header.Options = [hoColumnResize, hoDblClickResize, hoDrag, hoShowSortGlyphs, hoVisible]
      HintMode = hmHint
      Indent = 0
      ParentColor = False
      RootFolder = rfCustom
      RootFolderCustomPath = 'C:\'
      TabOrder = 1
      TabStop = True
      TreeOptions.AutoOptions = [toAutoScroll]
      TreeOptions.MiscOptions = [toAcceptOLEDrop, toEditable, toReportMode, toToggleOnDblClick]
      TreeOptions.PaintOptions = [toShowTreeLines, toUseBlendedImages, toGhostedIfUnfocused]
      TreeOptions.SelectionOptions = [toMultiSelect, toRightClickSelect, toSiblingSelectConstraint]
      TreeOptions.VETFolderOptions = [toHideRootFolder]
      TreeOptions.VETShellOptions = [toRightAlignSizeColumn, toContextMenus, toShellColumnMenu]
      TreeOptions.VETSyncOptions = [toCollapseTargetFirst, toExpandTarget, toSelectTarget]
      TreeOptions.VETMiscOptions = [toBrowseExecuteFolder, toBrowseExecuteFolderShortcut, toBrowseExecuteZipFolder, toChangeNotifierThread, toExecuteOnDblClk]
      TreeOptions.VETImageOptions = [toImages, toThreadedImages, toMarkCutAndCopy]
      OnChange = LVExChange
      ColumnMenuItemCount = 8
      VirtualExplorerTreeview = TreeEx
    end
  end
  object Panel2: TPanel
    Left = 325
    Top = 0
    Width = 567
    Height = 473
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object GroupBox1: TGroupBox
      Left = 0
      Top = 53
      Width = 567
      Height = 420
      Align = alClient
      Caption = 'View'
      TabOrder = 1
      object Viewer: TATViewer
        Left = 2
        Top = 15
        Width = 563
        Height = 403
        Align = alClient
        BevelOuter = bvNone
        Caption = 'No file loaded'
        TabOrder = 0
        TabStop = True
        TextWrap = True
        TextWidth = 65
        TextWidthFit = True
        TextWidthFitHex = True
        TextFont.Charset = DEFAULT_CHARSET
        TextFont.Color = clWindowText
        TextFont.Height = -12
        TextFont.Name = 'Courier New'
        TextFont.Style = []
      end
    end
    object GroupBox2: TGroupBox
      Left = 0
      Top = 0
      Width = 567
      Height = 53
      Align = alTop
      Caption = 'View mode'
      TabOrder = 0
      object chkModeDetect: TCheckBox
        Left = 8
        Top = 14
        Width = 201
        Height = 17
        Caption = 'Auto-detect on opening'
        TabOrder = 0
        OnClick = chkModeDetectClick
      end
      object chkModeText: TRadioButton
        Left = 8
        Top = 32
        Width = 73
        Height = 17
        Caption = 'Text'
        TabOrder = 1
        OnClick = chkModeTextClick
      end
      object chkModeBinary: TRadioButton
        Left = 72
        Top = 32
        Width = 73
        Height = 17
        Caption = 'Binary'
        TabOrder = 2
        OnClick = chkModeBinaryClick
      end
      object chkModeHex: TRadioButton
        Left = 136
        Top = 32
        Width = 65
        Height = 17
        Caption = 'Hex'
        TabOrder = 3
        OnClick = chkModeHexClick
      end
      object chkModeMedia: TRadioButton
        Left = 192
        Top = 32
        Width = 121
        Height = 17
        Caption = 'Image/Multimedia'
        TabOrder = 4
        OnClick = chkModeMediaClick
      end
      object chkModeWeb: TRadioButton
        Left = 312
        Top = 32
        Width = 113
        Height = 17
        Caption = 'Internet/Office'
        TabOrder = 5
        OnClick = chkModeWebClick
      end
      object chkModeUnicode: TRadioButton
        Left = 416
        Top = 32
        Width = 81
        Height = 17
        Caption = 'Unicode'
        TabOrder = 6
        OnClick = chkModeUnicodeClick
      end
    end
  end
end
