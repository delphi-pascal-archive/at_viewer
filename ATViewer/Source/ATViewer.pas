{$OPTIMIZATION OFF}

{$I ATViewerDef.inc}

unit ATViewer;

interface

uses Windows, Messages, SysUtils, Classes, Controls, Graphics,
  StdCtrls, ExtCtrls, ComCtrls, Dialogs, Forms, Jpeg,
  {$ifdef GEx}GraphicEx,{$endif}
  {$ifdef GIF}GifCtrl,{$endif}
  MPlayer, MediaPlayer_TLB, SHDocVw, ATBinHex;

type
  TATViewerMode = (vmodeText, vmodeBinary, vmodeHex, vmodeUnicode,
                   vmodeMedia, vmodeWeb);

  TATViewerMediaMode = (vmmodeMCI, vmmodeWMP64);

  TATViewer = class(TPanel)
  private
    FFileName: WideString;
    FBinHex: TATBinHex;
    FScroll: TScrollBox;
    FImage: TImage;
    {$ifdef GIF}
    FGif: TRxGifAnimator;
    {$endif}
    FEdit: TRichEdit;
    FMediaPanel: TPanel;
    FMediaPanel1: TPanel;
    FMediaPanel2: TPanel;
    FMediaBar: TTrackBar;
    FTimer: TTimer;
    FMedia: TMediaPlayer;
    FMedia2: TWMP;
    FBrowser: TWebBrowser;
    FPrintDialog: TPrintDialog;
    FPrintSetupDialog: TPrinterSetupDialog;
    FMode: TATViewerMode;
    FModeDetect: boolean;
    FMediaMode: TATViewerMediaMode;
    FTextEncoding: TATBinHexEncoding;
    FTextWrap: boolean;
    FTextDetect: boolean;
    FTextDetectSize: DWORD;
    FTextDetectLimit: DWORD;
    FMediaPlay: boolean;
    FMediaFit: boolean;
    FWebOffline: boolean;
    FTextColor: TColor;
    FTextFont: TFont;
    FFocused: boolean;
    FFindText: string;
    FFindWords: boolean;
    FFindCase: boolean;
    FFindPosition: Int64;
    FIsImage: boolean;
    FImageWidth: word;
    FImageHeight: word;
    FSearchIndent: word;
    procedure InitDialogs;
    procedure InitMedia;
    procedure InitWeb;
    procedure FreeMedia;
    function CanSetFocus: boolean;
    procedure SetMode(AMode: TATViewerMode);
    procedure SetMediaMode(AMediaMode: TATViewerMediaMode);
    procedure SetTextEncoding(AEncoding: TATBinHexEncoding);
    procedure SetTextWrap(AWrap: boolean);
    function GetTextWidth: word;
    function GetTextWidthFit: boolean;
    function GetTextWidthFitHex: boolean;
    procedure SetTextWidth(AWidth: word);
    procedure SetTextWidthFit(AFit: boolean);
    procedure SetTextWidthFitHex(AFit: boolean);
    procedure SetSearchIndent(AIndent: word);
    procedure SetMediaFit(AFit: boolean);
    procedure SetWebOffline(AOffline: boolean);
    procedure SetTextColor(AColor: TColor);
    procedure SetTextFont(AFont: TFont);
    function GetTextColorHex: TColor;
    function GetTextColorHex2: TColor;
    function GetTextColorLines: TColor;
    function GetTextColorError: TColor;
    procedure SetTextColorHex(AColor: TColor);
    procedure SetTextColorHex2(AColor: TColor);
    procedure SetTextColorLines(AColor: TColor);
    procedure SetTextColorError(AColor: TColor);
    procedure DetectMode;
    procedure LoadText;
    procedure LoadBinary;
    procedure LoadMedia;
    procedure LoadWeb;
    procedure FreeData;
    procedure HideAll;
    procedure HideMedia;
    procedure HideWeb;
    procedure Enter(Sender: TObject);
    procedure MediaBarChange(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure WebBrowserDocumentComplete(Sender: TObject; const pDisp: IDispatch; var URL: OleVariant);
    procedure PrintEdit(OnlySel: boolean; Copies: word);
    function GetPosPercent: word;
    procedure SetPosPercent(n: word);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Open(const AFileName: WideString): boolean;
    procedure FindText(const fText: string; fWholeWords, fCaseSens: boolean);
    procedure FindNext;
    procedure FindWeb;
    procedure CopyToClipboard;
    procedure SelectAll;
    procedure PrintDialog;
    procedure PrintPreview;
    procedure PrintSetup;
    property IsImage: boolean read FIsImage;
    property ImageWidth: word read FImageWidth;
    property ImageHeight: word read FImageHeight;
    property TextPosPercent: word read GetPosPercent write SetPosPercent;
  protected
    procedure Click; override;
    procedure Resize; override;
  published
    property Mode: TATViewerMode read FMode write SetMode default vmodeBinary;
    property ModeDetect: boolean read FModeDetect write FModeDetect default true;
    property MediaMode: TATViewerMediaMode read FMediaMode write SetMediaMode default vmmodeWMP64;
    property MediaPlay: boolean read FMediaPlay write FMediaPlay default true;
    property MediaFit: boolean read FMediaFit write SetMediaFit default false;
    property TextDetect: boolean read FTextDetect write FTextDetect default true;
    property TextDetectSize: DWORD read FTextDetectSize write FTextDetectSize default 2;
    property TextDetectLimit: DWORD read FTextDetectLimit write FTextDetectLimit default 0;
    property TextEncoding: TATBinHexEncoding read FTextEncoding write SetTextEncoding default vencANSI;
    property TextWrap: boolean read FTextWrap write SetTextWrap default false;
    property TextWidth: word read GetTextWidth write SetTextWidth default 80;
    property TextWidthFit: boolean read GetTextWidthFit write SetTextWidthFit default false;
    property TextWidthFitHex: boolean read GetTextWidthFitHex write SetTextWidthFitHex default false;
    property TextSearchIndent: word read FSearchIndent write SetSearchIndent default 5;
    property TextColor: TColor read FTextColor write SetTextColor default clWindow;
    property TextColorHex: TColor read GetTextColorHex write SetTextColorHex default clNavy;
    property TextColorHex2: TColor read GetTextColorHex2 write SetTextColorHex2 default clBlue;
    property TextColorLines: TColor read GetTextColorLines write SetTextColorLines default clGray;
    property TextColorError: TColor read GetTextColorError write SetTextColorError default clRed;
    property TextFont: TFont read FTextFont write SetTextFont;
    property WebOffline: boolean read FWebOffline write SetWebOffline default true;
    property IsFocused: boolean read FFocused write FFocused default false;
  end;

procedure Register;

{$I ATViewerExt.inc}

implementation

uses SProc, FProc, ATViewerProc, WBProc, REProc;

{ Helper functions }

function SExtMatch(const fn: WideString; const ExtList: string): boolean;
var
  ext: string;
begin
  ext:= LowerCase(SExtractFileExt(fn));
  if (ext<>'') and (ext[1]='.') then Delete(ext, 1, 1);
  Result:= Pos(','+ext+',', ','+ExtList+',')>0;
end;

procedure SDelLastComma(var S: string);
begin
  if (S<>'') and (S[Length(S)]=',') then
    Delete(S, Length(S), 1);
end;

{ TATViewer }

function TATViewer.CanSetFocus: boolean;
begin
  Result:= CanFocus and (FFocused or Focused) and ([csLoading, csDesigning]*ComponentState=[])
end;

constructor TATViewer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  Caption:= '';
  BevelOuter:= bvNone;
  Width:= 200;
  Height:= 150;

  FFileName:= '';
  FMode:= vmodeBinary;
  FModeDetect:= true;
  FMediaMode:= vmmodeWMP64;
  FTextEncoding:= vencANSI;
  FTextWrap:= false;
  FTextDetect:= true;
  FTextDetectSize:= 2;
  FTextDetectLimit:= 0;
  FMediaPlay:= true;
  FMediaFit:= false;
  FWebOffline:= true;
  FSearchIndent:= 5;
  FFocused:= false;
  FIsImage:= false;
  FImageWidth:= 0;
  FImageHeight:= 0;

  OnEnter:= Enter;

  FTextColor:= clWindow;
  FTextFont:= TFont.Create;
  with FTextFont do
    begin
    Name:= 'Courier New';
    Size:= 10;
    Color:= clWindowText;
    end;

  FBinHex:= TATBinHex.Create(Self);
  with FBinHex do
    begin
    Parent:= Self;
    Align:= alClient;
    Color:= FTextColor;
    Font:= FTextFont;
    end;

  FScroll:= TScrollBox.Create(Self);
  with FScroll do
    begin
    Parent:= Self;
    Align:= alClient;
    end;

  FImage:= TImage.Create(Self);
  with FImage do
    begin
    Parent:= FScroll;
    Align:= alNone;
    AutoSize:= true;
    end;

  {$ifdef GIF}
  FGif:= TRxGifAnimator.Create(Self);
  with FGif do
    begin
    Parent:= FScroll;
    Align:= alNone;
    AutoSize:= true;
    end;
  {$endif}

  FEdit:= TRichEdit.Create(Self);
  with FEdit do
    begin
    Parent:= Self;
    Align:= alClient;
    ReadOnly:= true;
    ScrollBars:= ssBoth;
    end;

  FMedia:= nil;
  FMediaPanel:= nil;
  FMediaPanel1:= nil;
  FMediaPanel2:= nil;
  FMediaBar:= nil;
  FTimer:= nil;
  FMedia2:= nil;

  FBrowser:= nil;

  FPrintDialog:= nil;
  FPrintSetupDialog:= nil;

  HideAll;
end;

destructor TATViewer.Destroy;
begin
  FreeData;
  FreeMedia;
  FTextFont.Free;
  inherited Destroy;
end;

procedure TATViewer.InitDialogs;
begin
  if not Assigned(FPrintDialog) then
    FPrintDialog:= TPrintDialog.Create(Self);
  if not Assigned(FPrintSetupDialog) then
    FPrintSetupDialog:= TPrinterSetupDialog.Create(Self);
end;

procedure TATViewer.InitMedia;
begin
  if (FMediaMode=vmmodeMCI) and not Assigned(FMedia) then
    begin
    FMediaPanel:= TPanel.Create(Self);
    with FMediaPanel do
      begin
      Caption:= '';
      BevelOuter:= bvNone;
      Parent:= Self;
      Align:= alClient;
      end;

    FMediaPanel1:= TPanel.Create(Self);
    with FMediaPanel1 do
      begin
      Caption:= '';
      BevelOuter:= bvNone;
      Parent:= FMediaPanel;
      Align:= alBottom;
      Height:= 30;
      end;

    FMediaPanel2:= TPanel.Create(Self);
    with FMediaPanel2 do
      begin
      Caption:= '';
      BevelOuter:= bvNone;
      Parent:= FMediaPanel;
      Align:= alClient;
      end;

    FMedia:= TMediaPlayer.Create(Self);
    with FMedia do
      begin
      Parent:= FMediaPanel1;
      Height:= FMediaPanel1.Height;
      Display:= FMediaPanel2;
      VisibleButtons:= [btPlay, btPause, btStop];
      AutoRewind:= true;
      Shareable:= false;
      TimeFormat:= tfMilliseconds;
      end;

    FMediaBar:= TTrackBar.Create(Self);
    with FMediaBar do
      begin
      Parent:= FMediaPanel1;
      Left:= 90;
      Top:= 2;
      Width:= 100;
      Height:= FMediaPanel1.Height-2*Top;
      PageSize:= 10; 
      TickMarks:= tmBoth;
      TickStyle:= tsNone;
      ThumbLength:= 18;
      OnChange:= MediaBarChange;
      end;

    FTimer:= TTimer.Create(Self);
    with FTimer do
      begin
      OnTimer:= TimerTimer;
      end;
    end;

  if (FMediaMode=vmmodeWMP64) and not Assigned(FMedia2) then
    begin
    FMedia2:= TWMP.Create(Self);
    with FMedia2 do
      begin
      Parent:= Self;
      Align:= alClient;
      AutoStart:= false;
      AutoRewind:= true;
      end;
    end;

  HideMedia;
end;

procedure TATViewer.InitWeb;
begin
  if Assigned(FBrowser) then Exit;
  FBrowser:= TWebBrowser.Create(Self);
  with FBrowser do
    begin
    TControl(FBrowser).Parent:= Self;
    Align:= alClient;
    OnDocumentComplete:= WebBrowserDocumentComplete;
    end;
  HideWeb;
end;

procedure TATViewer.FreeMedia;
begin
  if Assigned(FMedia) then
    begin
    FTimer.Free;
    FMediaBar.Free;
    FMedia.Free;
    FMediaPanel1.Free;
    FMediaPanel2.Free;
    FMediaPanel.Free;

    FTimer:= nil;
    FMediaBar:= nil;
    FMedia:= nil;
    FMediaPanel1:= nil;
    FMediaPanel2:= nil;
    FMediaPanel:= nil;
    end;
    
  if Assigned(FMedia2) then
    begin
    FMedia2.Parent:= nil;
    FMedia2.Free;
    FMedia2:= nil;
    end;
end;

procedure TATViewer.HideAll;
var
  NotLoaded: boolean;
begin
  NotLoaded:= FFileName='';

  //Hide Edit/BinHex/Browser controls only when different mode is set
  if NotLoaded or not (FMode in [vmodeBinary, vmodeHex, vmodeUnicode]) then
    FBinHex.Hide;
  if NotLoaded or (FMode<>vmodeText) then
    FEdit.Hide;
  if NotLoaded or (FMode<>vmodeWeb) then
    HideWeb;

  //Hide media controls always
  FScroll.Hide;
  FImage.Hide;
  {$ifdef GIF}
  FGif.Hide;
  {$endif}
  HideMedia;
end;

procedure TATViewer.HideMedia;
begin
  if Assigned(FMedia) then
    begin
    FMediaPanel.Hide;
    FMedia.Enabled:= false;
    FMediaBar.Enabled:= false;
    end;
  if Assigned(FMedia2) then
    FMedia2.Hide;
end;

procedure TATViewer.HideWeb;
begin
  if Assigned(FBrowser) then
    FBrowser.Hide;
end;

function TATViewer.Open(const AFileName: WideString): boolean;
begin
  Result:= true;
  if (FFileName<>AFileName) then
    begin
    FFileName:= AFileName;
    FreeData;

    if FFileName='' then
      begin
      HideAll;
      Exit
      end;
    if not IsFileExist(FFileName) then
      begin
      FFileName:= '';
      HideAll;
      MsgError(SFormatS(ssViewerErrCannotFindFile, [AFileName]));
      Result:= false;
      Exit
      end;
    if not IsFileAccessed(FFileName) then
      begin
      FFileName:= '';
      HideAll;
      MsgError(SFormatS(ssViewerErrCannotOpenFile, [AFileName]));
      Result:= false;
      Exit
      end;

    if FModeDetect then
      DetectMode;
    HideAll;
    case FMode of
      vmodeText:
        LoadText;
      vmodeHex, vmodeBinary, vmodeUnicode:
        LoadBinary;
      vmodeMedia:
        LoadMedia;
      vmodeWeb:
        LoadWeb;
    end;
    end;
end;

procedure TATViewer.FreeData;
begin
  FBinHex.Open('');
  FImage.Picture:= nil;
  {$ifdef GIF}
  FGif.Image:= nil;
  {$endif}

  if not (csDestroying in ComponentState) then
    begin
    if FEdit.Lines.Count>0 then
      FEdit.Lines.Clear;
    if Assigned(FMedia) and (FMedia.FileName<>'') then
      begin
      FMedia.Close;
      FMedia.FileName:= '';
      end;
    if Assigned(FMedia2) and (FMedia2.FileName<>'') then
      FMedia2.FileName:= '';
    if Assigned(FBrowser) then
      FBrowser.Navigate('');
    end;

  FFindText:= '';
  FFindWords:= false;
  FFindCase:= false;
  FFindPosition:= 0;

  FIsImage:= false;
  FImageWidth:= 0;
  FImageHeight:= 0;
end;

procedure TATViewer.DetectMode;
begin
  SDelLastComma(ffViewerExtText);
  SDelLastComma(ffViewerExtImages);
  SDelLastComma(ffViewerExtMedia);
  SDelLastComma(ffViewerExtWeb);

  if SExtMatch(FFileName, ffViewerExtText) then FMode:= vmodeText else
  if SExtMatch(FFileName, ffViewerExtImages+','+
                          ffViewerExtMedia) then FMode:= vmodeMedia else
  if SExtMatch(FFileName, ffViewerExtWeb) then FMode:= vmodeWeb else

  if FTextDetect and IsFileText(FFileName, FTextDetectSize, FTextDetectLimit) then FMode:= vmodeText else
    FMode:= vmodeBinary;
end;

procedure TATViewer.LoadMedia;
begin
  FreeData;
  if FFileName='' then Exit;

  {$ifdef GIF}
  if SExtMatch(FFileName, 'gif') then
    try
      FGif.Image.LoadFromFile(FFileName);
      FGif.Animate:= true;
      FGif.Show;
      FScroll.Show;
      FIsImage:= true;
      FImageWidth:= FGif.Image.Width;
      FImageHeight:= FGif.Image.Height;
    except
      on E: EInvalidGraphicOperation do
        MsgError(E.Message)
      else
        MsgError(ssViewerErrImage);
    end
  else
  {$endif}
  if SExtMatch(FFileName, ffViewerExtImages) then
    try
      FImage.Picture.LoadFromFile(FFileName);
      FImage.Show;
      FScroll.Show;
      FIsImage:= true;
      FImageWidth:= FImage.Picture.Width;
      FImageHeight:= FImage.Picture.Height;
    except
      on E: EInvalidGraphic do
        MsgError(E.Message)
      else
        MsgError(ssViewerErrImage);
    end
  else
    begin
    InitMedia;
    //MCI interface
    if (FMediaMode=vmmodeMCI) and Assigned(FMedia) then
      try
        Screen.Cursor:= crHourGlass;
        try
          FMediaPanel.Show;
          Resize;
          FMedia.FileName:= FFileName;
          FMedia.Open;
          FMedia.Enabled:= true;
          FMediaBar.Enabled:= true;
          FMediaBar.Max:= FMedia.Length;
          if CanSetFocus then
            FMedia.SetFocus;
          if FMediaPlay then
            FMedia.Play;
        except
          on E: EMCIDeviceError do
            MsgError(E.Message)
          else
            MsgError(ssViewerErrMultimedia);
        end;
      finally
        Screen.Cursor:= crDefault;
      end
    else
    //WMP 6.4 interface
    if (FMediaMode=vmmodeWMP64) and Assigned(FMedia2) then
      try
        with FMedia2 do
          begin
          Show;
          if CanSetFocus then
            SetFocus;
          AutoStart:= FMediaPlay;
          FileName:= FFileName;
          {
          //Alternative method of playing:
          FileName:= FFileName;
          while ReadyState<3 do
            Application.ProcessMessages;
          if FMediaPlay then
            Play;
            }
          end;
      except
        on E: Exception do
          if E.Message<>''
            then MsgError(E.Message)
            else MsgError(ssViewerErrMultimedia);
      end;
    end;
end;

procedure TATViewer.LoadBinary;
begin
  FreeData;
  with FBinHex do
    begin
    Color:= FTextColor;
    Font:= FTextFont;
    TextEncoding:= FTextEncoding;
    case Self.FMode of
      vmodeHex:     Mode:= vbmodeHex;
      vmodeBinary:  Mode:= vbmodeBinary;
      vmodeUnicode: Mode:= vbmodeUnicode;
    end;
    Open(FFileName);
    Show;
    if CanSetFocus then
      SetFocus;
    end;
end;

procedure TATViewer.LoadText;
var
  Size: Int64;
begin
  FreeData;
  if FFileName='' then Exit;

  with FEdit do
    begin
    //work around RichEdit bug, reset font
    Font.Name:= 'Webdings';
    Font.Size:= 8;
    Font.Color:= clWhite;
    Font:= FTextFont;

    //RichEdit bug: WordWrap assignment must be after Font assignment, or font will be broken
    Color:= FTextColor;
    WordWrap:= FTextWrap;
    
    PlainText:= not SExtMatch(FFileName, 'rtf');
    if not PlainText then FTextEncoding:= vencANSI;

    Size:= FFileSize(FFileName);
    if Size>32*1024 then RE_LimitSize(FEdit, Size+100);

    Lines.BeginUpdate;

    try
      try
        Screen.Cursor:= crHourGlass;
        RE_LoadFile(FEdit, FFileName, FTextEncoding=vencOEM, 0, 0);
      finally
        Screen.Cursor:= crDefault;
      end;
    except
      MsgError(SFormatS(ssViewerErrCannotLoadFile, [FFileName]));
    end;

    Lines.EndUpdate;
  
    Show;
    if CanSetFocus then
      SetFocus;
    end;
end;

procedure TATViewer.LoadWeb;
begin
  FreeData;
  if FFileName='' then Exit;
  InitWeb;
  if Assigned(FBrowser) then
    with FBrowser do
      begin
      Show;
      if CanSetFocus then
        SetFocus;
      Offline:= FWebOffline;
      Navigate(FFileName);
      end;
end;

procedure TATViewer.SetMode(AMode: TATViewerMode);
begin
  FMode:= AMode;
  HideAll;
  if FFileName<>'' then
    case FMode of
      vmodeText:
        LoadText;
      vmodeHex, vmodeBinary, vmodeUnicode:
        LoadBinary;
      vmodeMedia:
        LoadMedia;
      vmodeWeb:
        LoadWeb;
    end;
end;

procedure TATViewer.SetMediaMode(AMediaMode: TATViewerMediaMode);
begin
  if AMediaMode<>FMediaMode then
    begin
    FreeData;
    //FreeMedia; //commented: causes strange AV
    FMediaMode:= AMediaMode;
    InitMedia;
    end;
end;

procedure TATViewer.SetTextEncoding(AEncoding: TATBinHexEncoding);
var
  i: integer;
begin
  if (FMode=vmodeText) and (not FEdit.PlainText) then Exit;

  if AEncoding<>FTextEncoding then
    begin
    FTextEncoding:= AEncoding;

    case FMode of
      vmodeHex,
      vmodeBinary,
      vmodeUnicode:
        FBinHex.TextEncoding:= FTextEncoding;

      vmodeText:
        with FEdit do
          begin
          Lines.BeginUpdate;

          case FTextEncoding of
            vencOEM:
              //Convert OEM to ANSI
              begin
              Screen.Cursor:= crHourGlass;
              for i:= 0 to Lines.Count-1 do
                Lines[i]:= ToANSI(string(Lines[i]));
              Screen.Cursor:= crDefault;
              RE_ScrollToStart(FEdit);
              SelStart:= 0;
              SelLength:= 0;
              end;

            vencANSI:
              //Reload file
              try
                try
                  Screen.Cursor:= crHourGlass;
                  RE_LoadFile(FEdit, FFileName, false, 0, 0);
                finally
                  Screen.Cursor:= crDefault;
                end;
              except
                MsgError(SFormatS(ssViewerErrCannotLoadFile, [FFileName]));
              end;
          end;

          Lines.EndUpdate;
        end;
    end;
    end;
end;

procedure TATViewer.SetTextWrap(AWrap: boolean);
begin
  if AWrap<>FTextWrap then
    begin
    FTextWrap:= AWrap;
    FEdit.WordWrap:= FTextWrap;
    end;
end;

function TATViewer.GetTextWidth: word;
begin
  Result:= FBinHex.TextWidth;
end;

function TATViewer.GetTextWidthFit: boolean;
begin
  Result:= FBinHex.TextWidthFit;
end;

function TATViewer.GetTextWidthFitHex: boolean;
begin
  Result:= FBinHex.TextWidthFitHex;
end;

procedure TATViewer.SetTextWidth(AWidth: word);
begin
  FBinHex.TextWidth:= AWidth;
end;

procedure TATViewer.SetTextWidthFit(AFit: boolean);
begin
  FBinHex.TextWidthFit:= AFit;
end;

procedure TATViewer.SetTextWidthFitHex(AFit: boolean);
begin
  FBinHex.TextWidthFitHex:= AFit;
end;

procedure TATViewer.SetSearchIndent(AIndent: word);
const
  cMaxIndent = 200;
begin
  if AIndent<>FSearchIndent then
    begin
    FSearchIndent:= AIndent;
    if FSearchIndent>cMaxIndent then FSearchIndent:= cMaxIndent;
    FBinHex.TextSearchIndent:= FSearchIndent;
    end;
end;

procedure TATViewer.SetMediaFit(AFit: boolean);
const
  FitAlign: array[boolean] of TAlign = (alNone, alClient);
begin
  if AFit<>FMediaFit then
    begin
    FMediaFit:= AFit;
    FImage.Align:= FitAlign[FMediaFit];
    FImage.AutoSize:= not FMediaFit;
    FImage.Stretch:= FMediaFit;
    {$ifdef GIF}
    FGif.Align:= FitAlign[FMediaFit];
    FGif.AutoSize:= not FMediaFit;
    FGif.Stretch:= FMediaFit;
    {$endif}
    end;
end;

procedure TATViewer.SetWebOffline(AOffline: boolean);
begin
  if AOffline<>FWebOffline then
    begin
    FWebOffline:= AOffline;
    if Assigned(FBrowser) then
      begin
      FBrowser.Offline:= FWebOffline;
      if FMode=vmodeWeb then
        FBrowser.Navigate(FFileName);
      end;
    end;
end;

procedure TATViewer.SetTextColor(AColor: TColor);
begin
  if AColor<>FTextColor then
    begin
    FTextColor:= AColor;
    FBinHex.Color:= FTextColor;
    FEdit.Color:= FTextColor;
    end;
end;

procedure TATViewer.SetTextFont(AFont: TFont);
begin
  FTextFont.Assign(AFont);
  FBinHex.Font:= FTextFont;
  FEdit.Font:= FTextFont;
end;

function TATViewer.GetTextColorHex: TColor;
begin
  Result:= FBinHex.TextColorHex;
end;

function TATViewer.GetTextColorHex2: TColor;
begin
  Result:= FBinHex.TextColorHex2;
end;

function TATViewer.GetTextColorLines: TColor;
begin
  Result:= FBinHex.TextColorLines;
end;

function TATViewer.GetTextColorError: TColor;
begin
  Result:= FBinHex.TextColorError;
end;

procedure TATViewer.SetTextColorHex(AColor: TColor);
begin
  FBinHex.TextColorHex:= AColor;
end;

procedure TATViewer.SetTextColorHex2(AColor: TColor);
begin
  FBinHex.TextColorHex2:= AColor;
end;

procedure TATViewer.SetTextColorLines(AColor: TColor);
begin
  FBinHex.TextColorLines:= AColor;
end;

procedure TATViewer.SetTextColorError(AColor: TColor);
begin
  FBinHex.TextColorError:= AColor;
end;

procedure TATViewer.Enter(Sender: TObject);
begin
  case FMode of
    vmodeText:
      if FEdit.Visible then FEdit.SetFocus;

    vmodeHex,
    vmodeBinary,
    vmodeUnicode:
      if FBinHex.Visible then FBinHex.SetFocus;

    vmodeMedia:
      begin
      if Assigned(FMedia) and FMedia.Enabled then FMedia.SetFocus;
      if Assigned(FMedia2) and FMedia2.Visible then FMedia2.SetFocus;
      end;

    vmodeWeb:
      if Assigned(FBrowser) and FBrowser.Visible then FBrowser.SetFocus;
  end;
end;

procedure TATViewer.Click;
begin
  SetFocus;
end;

var
  _IsTimer: boolean = false;

procedure TATViewer.MediaBarChange(Sender: TObject);
begin
  if Assigned(FMedia) then
    with FMedia do
      if Visible and Enabled and (not _IsTimer) then
        Position:= FMediaBar.Position;
end;

procedure TATViewer.TimerTimer(Sender: TObject);
begin
  _IsTimer:= true;
  if Assigned(FMedia) then
    with FMedia do
      if Visible and Enabled and (FileName<>'') then
        begin
        if Position=Length then
          begin
          Position:= 0;
          Stop;
          end;
        FMediaBar.Position:= Position;
        end;
  _IsTimer:= false;
end;

procedure TATViewer.FindText(const fText: string; fWholeWords, fCaseSens: boolean);
var
  i: Int64;
  Options: TSearchTypes;
begin
  FFindText:= fText;
  FFindWords:= fWholeWords;
  FFindCase:= fCaseSens;
  FFindPosition:= 0;

  case FMode of
    vmodeText:
      begin
      Options:= [];
      if fWholeWords then Include(Options, stWholeWord);
      if fCaseSens then Include(Options, stMatchCase);
      Screen.Cursor:= crHourGlass;
      i:= FEdit.FindText(FFindText, 0, MaxInt, Options);
      Screen.Cursor:= crDefault;
      if i=-1 then
        begin
        MsgError(SFormatS(ssViewerErrCannotFindText, [FFindText]));
        Exit
        end;
      FFindPosition:= i;
      FEdit.Lines.BeginUpdate;
      FEdit.SelStart:= i;
      FEdit.SelLength:= Length(FFindText);
      RE_ScrollToLine(FEdit, RE_LineFromPos(FEdit, i), FSearchIndent);
      FEdit.Lines.EndUpdate;
      end;

    vmodeBinary, vmodeHex:
      begin
      Screen.Cursor:= crHourGlass;
      i:= FBinHex.FindText(FFindText, 0, fWholeWords, fCaseSens);
      Screen.Cursor:= crDefault;
      if i=-1 then
        begin
        MsgError(SFormatS(ssViewerErrCannotFindText, [FFindText]));
        Exit
        end;
      FFindPosition:= i;
      FBinHex.SetSelection(i, Length(FFindText), true);
      end;
  end;
end;

procedure TATViewer.FindNext;
var
  i: Int64;
  Options: TSearchTypes;
begin
  if FFindText<>'' then
    case FMode of
      vmodeText:
        begin
        Options:= [];
        if FFindWords then Include(Options, stWholeWord);
        if FFindCase then Include(Options, stMatchCase);
        Screen.Cursor:= crHourGlass;
        i:= FEdit.FindText(FFindText, FFindPosition+1, MaxInt, Options);
        Screen.Cursor:= crDefault;
        if i=-1 then
          begin
          MsgError(SFormatS(ssViewerErrCannotFindText, [FFindText]));
          Exit
          end;
        FFindPosition:= i;
        FEdit.Lines.BeginUpdate;
        FEdit.SelStart:= i;
        FEdit.SelLength:= Length(FFindText);
        RE_ScrollToLine(FEdit, RE_LineFromPos(FEdit, i), FSearchIndent);
        FEdit.Lines.EndUpdate;
        end;

      vmodeBinary, vmodeHex:
        begin
        Screen.Cursor:= crHourGlass;
        i:= FBinHex.FindText(FFindText, FFindPosition+1, FFindWords, FFindCase);
        Screen.Cursor:= crDefault;
        if i=-1 then
          begin
          MsgError(SFormatS(ssViewerErrCannotFindText, [FFindText]));
          Exit
          end;
        FFindPosition:= i;
        FBinHex.SetSelection(i, Length(FFindText), true);
        end;
    end;
end;

procedure TATViewer.FindWeb;
begin
  if FMode=vmodeWeb then
    if Assigned(FBrowser) then
      WB_ShowFindDialog(FBrowser);
end;

procedure TATViewer.CopyToClipboard;
begin
  case FMode of
    vmodeText:
      try
        FEdit.CopyToClipboard;
      except
        MsgError(ssViewerErrCannotCopyText);
      end;
    vmodeBinary, vmodeHex:
      try
        FBinHex.CopyToClipboard;
      except
        MsgError(ssViewerErrCannotCopyText);
      end;
    vmodeWeb:
      if Assigned(FBrowser) then
        WB_Copy(FBrowser);
  end;
end;

procedure TATViewer.SelectAll;
begin
  case FMode of
    vmodeText:
      FEdit.SelectAll;
    vmodeBinary, vmodeHex:
      FBinHex.SelectAll;
    vmodeWeb:
      if Assigned(FBrowser) then
        WB_SelectAll(FBrowser);
  end;
end;

procedure TATViewer.Resize;
begin
  inherited Resize;
  if Assigned(FMedia) then
    with FMediaBar do
      Width:= Self.Width-Left;
end;

procedure TATViewer.PrintEdit(OnlySel: boolean; Copies: word);
var
  FSelStart, FSelLength: integer;
begin
  with FEdit do
    begin
    Lines.BeginUpdate;
    FSelStart:= SelStart;
    FSelLength:= SelLength;
    RE_Print(FEdit, OnlySel, Copies);

    try
      try
        Screen.Cursor:= crHourGlass;
        RE_LoadFile(FEdit, FFileName, FTextEncoding=vencOEM, FSelStart, FSelLength);
      finally
        Screen.Cursor:= crDefault;
      end;
    except
      MsgError(SFormatS(ssViewerErrCannotLoadFile, [FFileName]));
    end;

    Lines.EndUpdate;
    end;
end;

procedure TATViewer.WebBrowserDocumentComplete(Sender: TObject; const pDisp: IDispatch; var URL: OleVariant);
begin
  if CanSetFocus then
    if Assigned(FBrowser) then
      begin
      FBrowser.SetFocus;
      //WB_SetFocus(FBrowser); //bug: AV on exit
      end;
end;

procedure TATViewer.PrintDialog;
var
  Selection: boolean;
begin
  InitDialogs;
  case FMode of
    vmodeText, vmodeBinary, vmodeHex:
      if Assigned(FPrintDialog) then
        with FPrintDialog do
          begin
          Copies:= 1;
          if FMode=vmodeText
            then Selection:= FEdit.SelLength>0
            else Selection:= FBinHex.SelLength>0;
          if Selection
            then begin PrintRange:= prSelection; Options:= [poSelection, poWarning]; end
            else begin PrintRange:= prAllPages; Options:= [poWarning]; end;
          if Execute then
            if FMode=vmodeText
              then PrintEdit(PrintRange=prSelection, Copies)
              else FBinHex.Print(PrintRange=prSelection, Copies);
          end;
    vmodeWeb:
      if Assigned(FBrowser) then
        WB_ShowPrintDialog(FBrowser);
  end;
end;

procedure TATViewer.PrintPreview;
begin
  case FMode of
    vmodeWeb:
      if Assigned(FBrowser) then
        WB_ShowPrintPreview(FBrowser);
  end;
end;

procedure TATViewer.PrintSetup;
begin
  InitDialogs;
  case FMode of
    vmodeText, vmodeBinary, vmodeHex:
      if Assigned(FPrintSetupDialog) then
        FPrintSetupDialog.Execute;
    vmodeWeb:
      if Assigned(FBrowser) then
        WB_ShowPageSetup(FBrowser);
  end;
end;

function TATViewer.GetPosPercent: word;
var
  Num: integer;
begin
  Result:= 0;
  if FMode=vmodeText then
    begin
    Num:= FEdit.Lines.Count;
    if Num=0
      then Result:= 0
      else Result:= word(RE_CurrentLine(FEdit) * 100 div Num);
    end
  else
  if FMode in [vmodeBinary, vmodeHex, vmodeUnicode] then
    Result:= FBinHex.TextPosPercent;
end;

procedure TATViewer.SetPosPercent(n: word);
begin
  if FMode=vmodeText then RE_ScrollToPercent(FEdit, n) else
    if FMode in [vmodeBinary, vmodeHex, vmodeUnicode] then FBinHex.TextPosPercent:= n;
end;

procedure Register;
begin
  RegisterComponents('Samples', [TATViewer]);
end;

end.
