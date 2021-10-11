{$I ..\Source\ATViewerDef.inc}

unit UFormView;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Menus,
  {$ifdef TNT}TntForms, TntDialogs,{$endif}
  ATBinHex, ATViewer;

type
  //This cannot be handled by Delphi IDE editor:
  //{$ifdef TNT}
  //TFormView = class(TTntForm)
  //{$else}
  //TFormView = class(TForm)
  //{$endif}

  TFormView = class(TTntForm)
    MainMenu1: TMainMenu;
    mnuFile: TMenuItem;
    mnuOptions: TMenuItem;
    mnuFileExit: TMenuItem;
    N1: TMenuItem;
    mnuFileOpen: TMenuItem;
    mnuOptionsHex: TMenuItem;
    mnuOptionsBinary: TMenuItem;
    mnuOptionsText: TMenuItem;
    mnuOptionsImage: TMenuItem;
    mnuOptionsUnicode: TMenuItem;
    N2: TMenuItem;
    mnuOptionsOEM: TMenuItem;
    mnuOptionsANSI: TMenuItem;
    N3: TMenuItem;
    mnuOptionsWrap: TMenuItem;
    Viewer: TATViewer;
    mnuOptionsFit: TMenuItem;
    Edit1: TMenuItem;
    mnuEditFind: TMenuItem;
    mnuEditFindNext: TMenuItem;
    N4: TMenuItem;
    mnuEditCopy: TMenuItem;
    mnuEditSelectAll: TMenuItem;
    mnuFileClose: TMenuItem;
    Help1: TMenuItem;
    mnuHelpAbout: TMenuItem;
    mnuOptionsWeb: TMenuItem;
    mnuOptionsOffline: TMenuItem;
    N5: TMenuItem;
    mnuFilePrint: TMenuItem;
    mnuFilePrintSetup: TMenuItem;
    mnuFilePrintPreview: TMenuItem;
    N6: TMenuItem;
    mnuOptionsSettings: TMenuItem;
    mnuFileReload: TMenuItem;
    mnuFileSaveAs: TMenuItem;
    N7: TMenuItem;
    mnuEditGoto: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure mnuFileExitClick(Sender: TObject);
    procedure mnuFileOpenClick(Sender: TObject);
    procedure mnuOptionsHexClick(Sender: TObject);
    procedure mnuOptionsBinaryClick(Sender: TObject);
    procedure mnuOptionsTextClick(Sender: TObject);
    procedure mnuOptionsImageClick(Sender: TObject);
    procedure mnuOptionsUnicodeClick(Sender: TObject);
    procedure mnuOptionsOEMClick(Sender: TObject);
    procedure mnuOptionsANSIClick(Sender: TObject);
    procedure mnuOptionsWrapClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure mnuOptionsFitClick(Sender: TObject);
    procedure mnuEditFindClick(Sender: TObject);
    procedure mnuEditFindNextClick(Sender: TObject);
    procedure mnuEditCopyClick(Sender: TObject);
    procedure mnuEditSelectAllClick(Sender: TObject);
    procedure mnuFileCloseClick(Sender: TObject);
    procedure mnuHelpAboutClick(Sender: TObject);
    procedure mnuOptionsWebClick(Sender: TObject);
    procedure mnuOptionsOfflineClick(Sender: TObject);
    procedure mnuFilePrintClick(Sender: TObject);
    procedure mnuFilePrintPreviewClick(Sender: TObject);
    procedure mnuFilePrintSetupClick(Sender: TObject);
    procedure mnuOptionsSettingsClick(Sender: TObject);
    procedure mnuFileReloadClick(Sender: TObject);
    procedure mnuFileSaveAsClick(Sender: TObject);
    procedure mnuEditGotoClick(Sender: TObject);
  private
    { Private declarations }
    procedure UpdateOptions;
    procedure LoadFile(const fn: WideString);
    procedure ReloadFile;
    procedure LoadOptions;
    procedure SaveOptions;
    procedure SaveOptions2;
  public
    { Public declarations }
  end;

var
  FormView: TFormView;

const
  ffViewerFindHistoryMaxCount = 30;

var
  ffViewerFindHistory: TStringList;
  ffViewerFindText: string;
  ffViewerFindWords: boolean = false;
  ffViewerFindCase: boolean = false;

var
  ffViewerIniName: WideString = '';

implementation

uses
  SProc, FProc, FIniFile, ATViewerProc,
  UFormFindText, UFormViewOptions, UFormViewGoto;

{$R *.DFM}

var
  OpenDialog1: {$ifdef TNT}TTntOpenDialog{$else}TOpenDialog{$endif};
  SaveDialog1: {$ifdef TNT}TTntSaveDialog{$else}TSaveDialog{$endif};
  FFileName: WideString;

procedure TFormView.LoadOptions;
var
  i: integer;
  s: string;
begin
  Left:= GetIniKey(ffViewerIniName, 'Window', 'Left', Left);
  Top:= GetIniKey(ffViewerIniName, 'Window', 'Top', Top);
  Width:= GetIniKey(ffViewerIniName, 'Window', 'Width', Width);
  Height:= GetIniKey(ffViewerIniName, 'Window', 'Height', Height);
  if GetIniKey(ffViewerIniName, 'Window', 'Maximized', false) then
    WindowState:= wsMaximized;

  ffViewerFindHistory.Clear;
  for i:= 0 to ffViewerFindHistoryMaxCount-1 do
    begin
    s:= GetIniKey(ffViewerIniName, 'SearchHistory', 'Item'+IntToStr(i), '');
    if s='' then Break;
    ffViewerFindHistory.Add(s);
    end;

  with Viewer do
    begin
    MediaMode:= TATViewerMediaMode(GetIniKey(ffViewerIniName, 'Options', 'MediaMode', integer(MediaMode)));
    MediaPlay:= GetIniKey(ffViewerIniName, 'Options', 'MediaPlay', MediaPlay);
    MediaFit:= GetIniKey(ffViewerIniName, 'Options', 'MediaFit', MediaFit);
    TextDetect:= GetIniKey(ffViewerIniName, 'Options', 'TextDetect', TextDetect);
    TextDetectSize:= GetIniKey(ffViewerIniName, 'Options', 'TextDetectSize', TextDetectSize);
    TextDetectLimit:= GetIniKey(ffViewerIniName, 'Options', 'TextDetectLimit', TextDetectLimit);
    //TextEncoding:= TATBinHexEncoding(GetIniKey(ffViewerIniName, 'Options', 'TextEncoding', integer(TextEncoding)));
    TextWrap:= GetIniKey(ffViewerIniName, 'Options', 'TextWrap', TextWrap);
    TextWidth:= GetIniKey(ffViewerIniName, 'Options', 'TextWidth', TextWidth);
    TextSearchIndent:= GetIniKey(ffViewerIniName, 'Options', 'TextSearchIndent', TextSearchIndent);
    WebOffline:= GetIniKey(ffViewerIniName, 'Options', 'WebOffline', WebOffline);
    TextFont.Name:= GetIniKey(ffViewerIniName, 'Options', 'TextFontName', TextFont.Name);
    TextFont.Size:= GetIniKey(ffViewerIniName, 'Options', 'TextFontSize', TextFont.Size);
    TextFont.Color:= GetIniKey(ffViewerIniName, 'Options', 'TextFontColor', TextFont.Color);
    TextFont.Style:= TFontStyles(byte(GetIniKey(ffViewerIniName, 'Options', 'TextFontStyle', byte(TextFont.Style))));
    TextColor:= GetIniKey(ffViewerIniName, 'Options', 'TextBackColor', TextColor);
    TextWidthFit:= GetIniKey(ffViewerIniName, 'Options', 'TextWidthFit', TextWidthFit);
    TextWidthFitHex:= GetIniKey(ffViewerIniName, 'Options', 'TextWidthFit', TextWidthFitHex);
    ffViewerExtText:= GetIniKey(ffViewerIniName, 'Options', 'ExtText', ffViewerExtText);
    ffViewerExtImages:= GetIniKey(ffViewerIniName, 'Options', 'ExtImages', ffViewerExtImages);
    ffViewerExtMedia:= GetIniKey(ffViewerIniName, 'Options', 'ExtMedia', ffViewerExtMedia);
    ffViewerExtWeb:= GetIniKey(ffViewerIniName, 'Options', 'ExtInternet', ffViewerExtWeb);
    end;
end;

procedure TFormView.SaveOptions;
var
  i, n: integer;
begin
  SetIniKey(ffViewerIniName, 'Window', 'Left', Left);
  SetIniKey(ffViewerIniName, 'Window', 'Top', Top);
  SetIniKey(ffViewerIniName, 'Window', 'Width', Width);
  SetIniKey(ffViewerIniName, 'Window', 'Height', Height);
  SetIniKey(ffViewerIniName, 'Window', 'Maximized', WindowState=wsMaximized);

  with Viewer do
    begin
    SetIniKey(ffViewerIniName, 'Options', 'MediaPlay', MediaPlay);
    SetIniKey(ffViewerIniName, 'Options', 'MediaFit', MediaFit);
    //SetIniKey(ffViewerIniName, 'Options', 'TextEncoding', integer(TextEncoding));
    SetIniKey(ffViewerIniName, 'Options', 'TextWrap', TextWrap);
    SetIniKey(ffViewerIniName, 'Options', 'WebOffline', WebOffline);
    end;

  n:= ffViewerFindHistory.Count;
  if n>ffViewerFindHistoryMaxCount then
    n:= ffViewerFindHistoryMaxCount;
  for i:= 0 to n-1 do
    SetIniKey(ffViewerIniName, 'SearchHistory', 'Item'+IntToStr(i), ffViewerFindHistory[i]);
end;

procedure TFormView.SaveOptions2;
begin
  with Viewer do
    begin
    SetIniKey(ffViewerIniName, 'Options', 'TextDetect', TextDetect);
    SetIniKey(ffViewerIniName, 'Options', 'TextDetectSize', TextDetectSize);
    SetIniKey(ffViewerIniName, 'Options', 'TextDetectLimit', TextDetectLimit);
    SetIniKey(ffViewerIniName, 'Options', 'TextFontName', TextFont.Name);
    SetIniKey(ffViewerIniName, 'Options', 'TextFontSize', TextFont.Size);
    SetIniKey(ffViewerIniName, 'Options', 'TextFontColor', TextFont.Color);
    SetIniKey(ffViewerIniName, 'Options', 'TextFontStyle', byte(TextFont.Style));
    SetIniKey(ffViewerIniName, 'Options', 'TextBackColor', TextColor);
    SetIniKey(ffViewerIniName, 'Options', 'TextWidth', TextWidth);
    SetIniKey(ffViewerIniName, 'Options', 'TextWidthFit', TextWidthFit);
    SetIniKey(ffViewerIniName, 'Options', 'TextSearchIndent', TextSearchIndent);
    SetIniKey(ffViewerIniName, 'Options', 'MediaMode', integer(MediaMode));
    SetIniKey(ffViewerIniName, 'Options', 'ExtText', ffViewerExtText);
    SetIniKey(ffViewerIniName, 'Options', 'ExtImages', ffViewerExtImages);
    SetIniKey(ffViewerIniName, 'Options', 'ExtMedia', ffViewerExtMedia);
    SetIniKey(ffViewerIniName, 'Options', 'ExtInternet', ffViewerExtWeb);
    end;
end;

procedure TFormView.FormCreate(Sender: TObject);
begin
  ffViewerFindHistory:= TStringList.Create;
  ffViewerFindText:= '';
  ffViewerFindWords:= false;
  ffViewerFindCase:= false;

  OpenDialog1:= {$ifdef TNT}TTntOpenDialog{$else}TOpenDialog{$endif}.Create(Self);
  with OpenDialog1 do
    begin
    Filter:= 'All files (*.*)|*.*';
    InitialDir:= 'C:\';
    Options:= [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing];
    end;

  SaveDialog1:= {$ifdef TNT}TTntSaveDialog{$else}TSaveDialog{$endif}.Create(Self);
  with SaveDialog1 do
    begin
    Filter:= OpenDialog1.Filter;
    InitialDir:= OpenDialog1.InitialDir;
    Options:= [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing];
    end;

  FFileName:= '';
  LoadOptions;
end;

procedure TFormView.FormDestroy(Sender: TObject);
begin
  SaveOptions;
  ffViewerFindHistory.Free;
end;

procedure TFormView.LoadFile(const fn: WideString);
begin
  if Viewer.Open(fn)
    then FFileName:= fn
    else FFileName:= '';
  if FFileName<>''
    then Self.Caption:= FFileName+' - '+ssViewerCaption
    else Self.Caption:= ssViewerCaption;
  {$ifdef TNT}TntApplication{$else}Application{$endif}.Title:= Self.Caption;
end;

procedure TFormView.FormShow(Sender: TObject);
begin
  Viewer.SetFocus;
  LoadFile(SParamStr(1));
  UpdateOptions;
end;

procedure TFormView.mnuFileExitClick(Sender: TObject);
begin
  Close;
end;

procedure TFormView.mnuFileOpenClick(Sender: TObject);
begin
  with OpenDialog1 do
    begin
    FileName:= FFileName;
    InitialDir:= SExtractFileDir(FFileName);
    if Execute then
      begin
      LoadFile(FileName);
      UpdateOptions;
      end;
    end;
end;

procedure TFormView.mnuFileSaveAsClick(Sender: TObject);
var
  ok: boolean;
begin
  with SaveDialog1 do
    begin
    FileName:= FFileName;
    InitialDir:= SExtractFileDir(FFileName);
    if Execute then
      begin
      Screen.Cursor:= crHourGlass;
      ok:= FFileCopy(FFileName, FileName);
      Screen.Cursor:= crDefault;
      if not ok then
        MsgError(SFormatS(ssViewerErrCannotSaveFile, [FileName]));
      end;
    end;  
end;

procedure TFormView.UpdateOptions;
var
  En, IsTextVar, IsText, IsImage, IsWeb: boolean;
begin
  if Assigned(Viewer) then
    begin
    //Set Checked flag
    case Viewer.Mode of
      vmodeText: mnuOptionsText.Checked:= true;
      vmodeBinary: mnuOptionsBinary.Checked:= true;
      vmodeHex: mnuOptionsHex.Checked:= true;
      vmodeMedia: mnuOptionsImage.Checked:= true;
      vmodeWeb: mnuOptionsWeb.Checked:= true;
      vmodeUnicode: mnuOptionsUnicode.Checked:= true;
    end;
    case Viewer.TextEncoding of
      vencOEM: mnuOptionsOEM.Checked:= true;
      vencANSI: mnuOptionsANSI.Checked:= true;
    end;

    mnuOptionsWrap.Checked:= Viewer.TextWrap;
    mnuOptionsFit.Checked:= Viewer.MediaFit;
    mnuOptionsOffline.Checked:= Viewer.WebOffline;

    //Set Enabled flag
    En:= FFileName<>'';
    IsTextVar:= Viewer.Mode=vmodeText;
    IsText:= Viewer.Mode in [vmodeText, vmodeBinary, vmodeHex];
    IsImage:= (Viewer.Mode=vmodeMedia) and Viewer.IsImage;
    IsWeb:= Viewer.Mode=vmodeWeb;

    mnuFileSaveAs.Enabled:= En;
    mnuFileClose.Enabled:= En;
    mnuFilePrint.Enabled:= En and (IsText or IsWeb);
    mnuFilePrintPreview.Enabled:= En and IsWeb;
    mnuFilePrintSetup.Enabled:= En and (IsText or IsWeb);

    mnuEditCopy.Enabled:= En and (IsText or IsWeb);
    mnuEditSelectAll.Enabled:= En and (IsText or IsWeb);
    mnuEditFind.Enabled:= En and (IsText or IsWeb);
    mnuEditFindNext.Enabled:= En and IsText;
    mnuEditGoto.Enabled:= En and (Viewer.Mode in [vmodeText, vmodeBinary, vmodeHex, vmodeUnicode]);

    mnuOptionsText.Enabled:= En;
    mnuOptionsBinary.Enabled:= En;
    mnuOptionsHex.Enabled:= En;
    mnuOptionsImage.Enabled:= En;
    mnuOptionsWeb.Enabled:= En;
    mnuOptionsUnicode.Enabled:= En;

    mnuOptionsOEM.Enabled:= En and IsText;
    mnuOptionsANSI.Enabled:= En and IsText;
    mnuOptionsWrap.Enabled:= En and IsTextVar;
    mnuOptionsFit.Enabled:= En and IsImage;
    mnuOptionsOffline.Enabled:= En and IsWeb;
    end;
end;

procedure TFormView.mnuFileCloseClick(Sender: TObject);
begin
  LoadFile('');
  UpdateOptions;
end;

procedure TFormView.mnuOptionsTextClick(Sender: TObject);
begin
  Viewer.Mode:= vmodeText;
  UpdateOptions;
end;

procedure TFormView.mnuOptionsHexClick(Sender: TObject);
begin
  Viewer.Mode:= vmodeHex;
  UpdateOptions;
end;

procedure TFormView.mnuOptionsBinaryClick(Sender: TObject);
begin
  Viewer.Mode:= vmodeBinary;
  UpdateOptions;
end;

procedure TFormView.mnuOptionsImageClick(Sender: TObject);
begin
  Viewer.Mode:= vmodeMedia;
  UpdateOptions;
end;

procedure TFormView.mnuOptionsWebClick(Sender: TObject);
begin
  Viewer.Mode:= vmodeWeb;
  UpdateOptions;
end;

procedure TFormView.mnuOptionsUnicodeClick(Sender: TObject);
begin
  Viewer.Mode:= vmodeUnicode;
  UpdateOptions;
end;

procedure TFormView.mnuOptionsOEMClick(Sender: TObject);
begin
  Viewer.TextEncoding:= vencOEM;
  UpdateOptions;
end;

procedure TFormView.mnuOptionsANSIClick(Sender: TObject);
begin
  Viewer.TextEncoding:= vencANSI;
  UpdateOptions;
end;

procedure TFormView.mnuOptionsWrapClick(Sender: TObject);
begin
  Viewer.TextWrap:= not Viewer.TextWrap;
  UpdateOptions;
end;

procedure TFormView.mnuOptionsFitClick(Sender: TObject);
begin
  Viewer.MediaFit:= not Viewer.MediaFit;
  UpdateOptions;
end;

procedure TFormView.mnuOptionsOfflineClick(Sender: TObject);
begin
  Viewer.WebOffline:= not Viewer.WebOffline;
  UpdateOptions;
end;

procedure TFormView.mnuEditFindClick(Sender: TObject);
var
  i: integer;
begin
  if Viewer.Mode=vmodeWeb then
    begin
    Viewer.FindWeb;
    Exit
    end;
  with TFormFindText.Create(Self) do
    try
      with ffViewerFindHistory do
        for i:= 0 to Count-1 do
          edText.Items.Add(Strings[i]);
      edText.Text:= ffViewerFindText;
      chkWords.Checked:= ffViewerFindWords;
      chkCase.Checked:= ffViewerFindCase;
      if ShowModal=mrOk then
        begin
        ffViewerFindText:= edText.Text;
        ffViewerFindWords:= chkWords.Checked;
        ffViewerFindCase:= chkCase.Checked;
        with ffViewerFindHistory do
          begin
          i:= IndexOf(ffViewerFindText);
          if i>=0 then Delete(i);
          Insert(0, ffViewerFindText);
          end;
        Viewer.FindText(ffViewerFindText, ffViewerFindWords, ffViewerFindCase);
        end;
    finally
      Free;
    end;
end;

procedure TFormView.mnuEditFindNextClick(Sender: TObject);
begin
  Viewer.FindNext;
end;

procedure TFormView.mnuEditCopyClick(Sender: TObject);
begin
  Viewer.CopyToClipboard;
end;

procedure TFormView.mnuEditSelectAllClick(Sender: TObject);
begin
  Viewer.SelectAll;
end;

procedure TFormView.mnuHelpAboutClick(Sender: TObject);
begin
  MsgInfo(ssViewerAbout+#13#13+ssViewerAbout2);
end;

procedure TFormView.mnuFilePrintClick(Sender: TObject);
begin
  Viewer.PrintDialog;
end;

procedure TFormView.mnuFilePrintPreviewClick(Sender: TObject);
begin
  Viewer.PrintPreview;
end;

procedure TFormView.mnuFilePrintSetupClick(Sender: TObject);
begin
  Viewer.PrintSetup;
end;

procedure TFormView.mnuOptionsSettingsClick(Sender: TObject);
begin
  with TFormViewOptions.Create(Self) do
    try
      edText.Text:= ffViewerExtText;
      edImages.Text:= ffViewerExtImages;
      edMedia.Text:= ffViewerExtMedia;
      edInternet.Text:= ffViewerExtWeb;
      fTextDetect:= Viewer.TextDetect;
      fTextDetectSize:= Viewer.TextDetectSize;
      fTextDetectLimit:= Viewer.TextDetectLimit;
      fTextFontName:= Viewer.TextFont.Name;
      fTextFontSize:= Viewer.TextFont.Size;
      fTextFontColor:= Viewer.TextFont.Color;
      fTextFontStyle:= Viewer.TextFont.Style;
      fTextBackColor:= Viewer.TextColor;
      chkTextWidthFit.Checked:= Viewer.TextWidthFit;
      edTextWidth.Text:= IntToStr(Viewer.TextWidth);
      edTextIndent.Text:= IntToStr(Viewer.TextSearchIndent);
      chkMediaMCI.Checked:= Viewer.MediaMode=vmmodeMCI;
      chkMediaWMP64.Checked:= Viewer.MediaMode=vmmodeWMP64;
      if ShowModal=mrOk then
        begin
        ffViewerExtText:= edText.Text;
        ffViewerExtImages:= edImages.Text;
        ffViewerExtMedia:= edMedia.Text;
        ffViewerExtWeb:= edInternet.Text;
        Viewer.TextDetect:= fTextDetect;
        Viewer.TextDetectSize:= fTextDetectSize;
        Viewer.TextDetectLimit:= fTextDetectLimit;
        Viewer.TextFont.Name:= fTextFontName;
        Viewer.TextFont.Size:= fTextFontSize;
        Viewer.TextFont.Color:= fTextFontColor;
        Viewer.TextFont.Style:= fTextFontStyle;
        Viewer.TextColor:= fTextBackColor;
        Viewer.TextWidth:= StrToIntDef(edTextWidth.Text, Viewer.TextWidth);
        Viewer.TextWidthFit:= chkTextWidthFit.Checked;
        Viewer.TextWidthFitHex:= chkTextWidthFit.Checked;
        Viewer.TextSearchIndent:= StrToIntDef(edTextIndent.Text, Viewer.TextSearchIndent);
        if chkMediaMCI.Checked then Viewer.MediaMode:= vmmodeMCI else
         if chkMediaWMP64.Checked then Viewer.MediaMode:= vmmodeWMP64;
        SaveOptions2;
        ReloadFile;
        end;
    finally
      Free;
    end;
end;

procedure TFormView.ReloadFile;
begin
  with Viewer do
    Mode:= Mode;
end;

procedure TFormView.mnuFileReloadClick(Sender: TObject);
begin
  ReloadFile;
end;

procedure TFormView.mnuEditGotoClick(Sender: TObject);
var
  N: integer;
begin
  N:= FormGotoResult(Viewer.TextPosPercent);
  if N>=0 then Viewer.TextPosPercent:= N;
end;

initialization
  ffViewerIniName:= SExtractFilePath(SParamStr(0))+'Viewer.ini';

end.
