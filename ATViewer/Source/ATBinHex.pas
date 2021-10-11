{$OPTIMIZATION OFF}

unit ATBinHex;

interface

uses Windows, Messages, SysUtils, Classes, Controls, Graphics,
  StdCtrls, ExtCtrls, Dialogs, Forms;

type
  TATBinHexEncoding = (vencANSI, vencOEM);

  TATBinHexMode = (vbmodeBinary, vbmodeHex, vbmodeUnicode);

  TATBinHex = class(TPanel)
  private
    FFileName: WideString;
    FFileHandle: THandle;
    FFileSize: Int64;
    FFileOK: boolean;
    FBuffer: PChar;
    FBitmap: TBitmap;
    FTimer: TTimer;
    FStrings: TObject;
    FBufferPos: Int64;
    FViewPos: Int64;
    FSelStart: Int64;
    FSelLength: Int64;
    FMode: TATBinHexMode;
    FEncoding: TATBinHexEncoding;
    FTextWidth: word;
    FTextWidthHex: word;
    FTextWidthFit: boolean;
    FTextWidthFitHex: boolean;
    FTextColorHex: TColor;
    FTextColorHex2: TColor;
    FTextColorLines: TColor;
    FTextColorError: TColor;
    FSearchIndent: word;
    FMouseDown: boolean;
    FMouseStart: Int64;
    FMouseScrollUp: boolean;
    procedure Redraw;
    procedure ReadBuffer;
    procedure InitData;
    procedure FreeData;
    function LoadFile: boolean;
    procedure SetScrollBar;
    procedure SetMode(AMode: TATBinHexMode);
    procedure SetEncoding(AEncoding: TATBinHexEncoding);
    procedure SetTextWidth(AWidth: word);
    procedure SetTextWidthHex(AWidth: word);
    procedure SetTextWidthFit(AFit: boolean);
    procedure SetTextWidthFitHex(AFit: boolean);
    procedure SetTextColorHex(AColor: TColor);
    procedure SetTextColorHex2(AColor: TColor);
    procedure SetTextColorLines(AColor: TColor);
    procedure SetTextColorError(AColor: TColor);
    procedure SetSearchIndent(AIndent: word);
    function LinesNum: integer;
    function ColsNumFit: integer;
    function ColsNumHexFit: integer;
    function ColsNum: integer;
    function PosMax: Int64;
    function PosMax2: Int64;
    procedure PosAt(const Pos: Int64; fRedraw: boolean = true);
    procedure PosDec(const n: Int64);
    procedure PosInc(const n: Int64);
    procedure PosLineUp(n: word = 1);
    procedure PosLineDown(n: word = 1);
    procedure PosPageUp;
    procedure PosPageDown;
    procedure PosBegin;
    procedure PosEnd;
    function GetPosPercent: word;
    procedure SetPosPercent(n: word);
    procedure MouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure MouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    function MousePosition(X, Y: integer): Int64;
    procedure MouseMoveAction(X, Y: integer);
    procedure TimerTimer(Sender: TObject);
  protected
    procedure Click; override;
    procedure Resize; override;
    procedure Paint; override;
    procedure WMGetDlgCode(var Message: TMessage); message WM_GETDLGCODE;
    procedure WMEraseBkgnd(var Message: TMessage); message WM_ERASEBKGND;
    procedure WMVScroll(var Message: TWMVScroll); message WM_VSCROLL;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure CreateParams(var Params: TCreateParams); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Open(const AFileName: WideString): boolean;
    function FindText(const fText: string; const fPos: Int64; fWholeWords, fCaseSens: boolean): Int64;
    procedure CopyToClipboard;
    property SelStart: Int64 read FSelStart;
    property SelLength: Int64 read FSelLength;
    procedure SetSelection(const AStart, ALength: Int64; fPosition: boolean);
    procedure SelectAll;
    procedure SelectNone;
    procedure Print(OnlySel: boolean; Copies: word);
    property TextPosPercent: word read GetPosPercent write SetPosPercent;
  published
    property Mode: TATBinHexMode read FMode write SetMode default vbmodeBinary;
    property TextEncoding: TATBinHexEncoding read FEncoding write SetEncoding default vencANSI;
    property TextWidth: word read FTextWidth write SetTextWidth default 80;
    property TextWidthHex: word read FTextWidthHex write SetTextWidthHex default 16;
    property TextWidthFit: boolean read FTextWidthFit write SetTextWidthFit default false;
    property TextWidthFitHex: boolean read FTextWidthFitHex write SetTextWidthFitHex default false;
    property TextColorHex: TColor read FTextColorHex write SetTextColorHex default clNavy;
    property TextColorHex2: TColor read FTextColorHex2 write SetTextColorHex2 default clBlue;
    property TextColorLines: TColor read FTextColorLines write SetTextColorLines default clGray;
    property TextColorError: TColor read FTextColorError write SetTextColorError default clRed;
    property TextSearchIndent: word read FSearchIndent write SetSearchIndent default 5;
  end;

procedure Register;

implementation

uses SProc, FProc, ATViewerProc, Clipbrd, Printers;

{ Important constants, change with care.
  This will be changed: buffer size will be auto-calculated on Redraw }

const
  cMaxTextWidth = 250;
  cMinTextWidth = 2;
  cMaxLines = 200;
  cMaxBufOffset = cMaxLines*cMaxTextWidth*2; //2 for Unicode
  cBufSize = cMaxBufOffset*3; //buffer contains: 1 offset below + 2 offsets above FViewPos

{ Visual constants, may be changed freely }

const
  cUnicodeChar = '.'; //char that shows Unicode chars >$FF
  cMWheelLines = 3; //lines to scroll by mouse wheel
  cMScrollLines = 1; //lines to scroll when mouse is upper/lower than control
  cMScrollTime = 150; //interval of timer that scrolls control when mouse is upper/lower
  cHexOffsetLen = 10; //number of digits in hex offset (10 is enough for 1024 Gb)
  cHexOffsetSep = ':'; //separator between hex offset and digits
  cHexLines = true; //draw vertical lines in Hex mode
  cHexLinesWidth = 2; //width of lines in pixels

{ Helper functions }

function FontHeight(ACanvas: TCanvas): integer;
begin
  Result:= Round(Abs(ACanvas.Font.Height)*1.2);
end;

function FontWidthDigits(ACanvas: TCanvas): integer;
begin
  Result:= ACanvas.TextWidth('0');
end;

function FontWidthMax(ACanvas: TCanvas): integer;
begin
  Result:= ACanvas.TextWidth('W');
end;

function IsFontFixed(ACanvas: TCanvas): boolean;
begin
  with ACanvas do
    Result:= TextWidth('.')=TextWidth('W');
end;

{ TStrPositions }

type
  TStrPosRecord = record
    Str: string;
    Pnt: TPoint;
    Pos: Int64;
  end;

  TStrPosArray = array[1..cMaxLines] of TStrPosRecord;

  TStrPositions = class(TObject)
  private
    FNum: word;
    FArray: TStrPosArray;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    procedure Add(const AStr: string; const APnt: TPoint; const APos: Int64);
    function GetPosition(ACanvas: TCanvas; const APnt: TPoint): Int64;
    procedure Show;
  end;

constructor TStrPositions.Create;
begin
  inherited Create;
  FillChar(FArray, SizeOf(FArray), 0);
  FNum:= 0;
end;

destructor TStrPositions.Destroy;
begin
  //MessageBox(0, 'TStrPositions.Destroy', 'Debug', MB_OK);
  Clear;
  inherited Destroy;
end;

procedure TStrPositions.Clear;
var
  i: word;
begin
  for i:= FNum downto 1 do
    with FArray[i] do
      begin
      Str:= '';
      Pnt:= Point(0, 0);
      Pos:= 0;
      end;
  FNum:= 0;
end;

procedure TStrPositions.Add(const AStr: string; const APnt: TPoint; const APos: Int64);
begin
  if FNum=High(TStrPosArray) then Exit;
  Inc(FNum);
  with FArray[FNum] do
    begin
    Str:= AStr;
    Pnt:= APnt;
    Pos:= APos;
    end;
end;

function TStrPositions.GetPosition(ACanvas: TCanvas; const APnt: TPoint): Int64;
var
  X, XW, YH: integer;
  Num, i: word;
begin
  Result:= -1;
  if FNum=0 then Exit;

  //Mouse upper than first line
  with FArray[1] do
    if APnt.Y<Pnt.Y then
      begin Result:= Pos; Exit end;

  YH:= FontHeight(ACanvas);
  Num:= 0;
  for i:= 1 to FNum do
    with FArray[i] do
      if (APnt.Y>=Pnt.Y) and (APnt.Y<Pnt.Y+YH) then
        begin Num:= i; Break end;

  //Mouse lower than last line
  if Num=0 then
    with FArray[FNum] do
      begin Result:= Pos+Length(Str); Exit end;

  with FArray[Num] do
    begin
    //Mouse lefter or inside line
    X:= Pnt.X;
    for i:= 1 to Length(Str) do
      begin
      XW:= ACanvas.TextWidth(Str[i]);
      if (APnt.X<X+XW div 2) then
        begin Result:= Pos+i-1; Exit end;
      Inc(X, XW);
      end;
    //Mouse rigther than line
    Result:= Pos+Length(Str);
    end;
end;

procedure TStrPositions.Show;
var
  s: string;
  i: word;
begin
  s:= '';
  for i:= 1 to FNum do
    with FArray[i] do
      s:= s+Format('%s: (%d, %d) "%s"', [IntToHex(Pos, cHexOffsetLen), Pnt.X, Pnt.Y, Str])+#13;
  ShowMessage(s);
end;

{ TATBinHex }

constructor TATBinHex.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  Caption:= '';
  Width:= 200;
  Height:= 150;
  BevelOuter:= bvNone;
  BorderStyle:= bsSingle;
  Color:= clWindow;
  Cursor:= crIBeam;
  ControlStyle:= ControlStyle + [csOpaque];

  Font.Name:= 'Courier New';
  Font.Size:= 10;
  Font.Color:= clWindowText;

  FMode:= vbmodeBinary;
  FEncoding:= vencANSI;
  FTextWidth:= 80;
  FTextWidthHex:= 16;
  FTextWidthFit:= false;
  FTextWidthFitHex:= false;
  FTextColorHex:= clNavy;
  FTextColorHex2:= clBlue;
  FTextColorLines:= clGray;
  FTextColorError:= clRed;
  FSearchIndent:= 5;

  FFileName:= '';
  InitData;

  FBitmap:= TBitmap.Create;
  with FBitmap do
    begin
    Width:= Self.Width;
    Height:= Self.Height;
    //HandleType:= bmDIB;
    //PixelFormat:= pf32bit;
    end;

  FTimer:= TTimer.Create(Self);
  with FTimer do
    begin
    Enabled:= false;
    Interval:= cMScrollTime;
    OnTimer:= TimerTimer;
    end;

  FStrings:= TStrPositions.Create;

  OnMouseWheelUp:= MouseWheelUp;
  OnMouseWheelDown:= MouseWheelDown;
end;

destructor TATBinHex.Destroy;
begin
  FreeData;
  FStrings.Free;
  FBitmap.Free;
  inherited Destroy;
end;

procedure SwapInt64(var n1, n2: Int64);
var
  n: Int64;
begin
  n:= n1;
  n1:= n2;
  n2:= n;
end;

procedure InvertRect(Canvas: TCanvas; const Rect: TRect);
begin
  Windows.InvertRect(Canvas.Handle, Rect);
end;

procedure TextOut(Canvas: TCanvas; const X, Y: integer; const S: string);
begin
  Windows.TextOut(Canvas.Handle, X, Y, PChar(S), Length(S));
end;

procedure TATBinHex.Redraw;

  procedure SelectLine(const Line: string; const Pnt: TPoint; const FilePos: Int64; fSelectAll: boolean = false);
  var
    Len, X, Y, XWidth, YHeight, i: integer;
  begin
    if fSelectAll
      then Len:= 1
      else Len:= Length(Line);
    if (FSelStart>FilePos+Len-1) or (FSelStart+FSelLength-1<FilePos) then Exit;
    if (Pnt.X>=FBitmap.Width) or (Pnt.Y>=FBitmap.Height) then Exit;
    X:= Pnt.X;
    Y:= Pnt.Y;
    YHeight:= FontHeight(FBitmap.Canvas);
    for i:= 1 to Length(Line) do
      begin
      XWidth:= FBitmap.Canvas.TextWidth(Line[i]);
      if fSelectAll or ((FilePos+i-1>=FSelStart) and (FilePos+i-1<=FSelStart+FSelLength-1)) then
        InvertRect(FBitmap.Canvas, Rect(X, Y, X+XWidth, Y+YHeight));
      Inc(X, XWidth);
      end;
  end;

const
  X0 = 2; //position of left-top corner of display
  Y0 = 2;
var
  Strings: TStrPositions;
  X, Y, Y2, CellWidth: integer;
  Pos, PosEnd: Int64;
  Line, LineText: string;
  PosTextX, PosTextY: integer;
  i, j: word;
  ch: char;
  wch: word;
begin
  Strings:= FStrings as TStrPositions;
  Strings.Clear;

  with FBitmap do
    begin
    Width:= Self.ClientWidth;
    Height:= Self.ClientHeight;
    
    Canvas.Brush.Color:= Self.Color;
    Canvas.FillRect(Rect(0, 0, Width, Height));

    Canvas.Font.Name:= Self.Font.Name;
    Canvas.Font.Size:= Self.Font.Size;
    Canvas.Font.Color:= Self.Font.Color;
    Canvas.Font.Style:= Self.Font.Style;

    if FTextWidthFit then SetTextWidth(ColsNumFit);
    if FTextWidthFitHex then SetTextWidthHex(ColsNumHexFit);

    CellWidth:= FontWidthDigits(Canvas);

    if FFileOK then
    case FMode of
      vbmodeHex:
        begin
        for i:= 1 to Min(LinesNum+1, cMaxLines) do
          begin
          Pos:= FViewPos-FBufferPos+(i-1)*FTextWidthHex;
          if FBufferPos+Pos>=FFileSize then Break;

          Y:= Y0+(i-1)*FontHeight(Canvas);
          Y2:= Y+FontHeight(Canvas);

          //Draw offset
          X:= X0;
          Line:= IntToHex(FBufferPos+Pos, cHexOffsetLen)+cHexOffsetSep;
          Canvas.Font.Color:= Self.Font.Color;
          TextOut(Canvas, X, Y, Line);

          //Draw hex digits
          Inc(X, (Length(Line)+2{2 spaces})*CellWidth);

          for j:= 0 to FTextWidthHex-1 do
            if FBufferPos+Pos+j<FFileSize then
              begin
              if (j mod 4)<2
                then Canvas.Font.Color:= FTextColorHex
                else Canvas.Font.Color:= FTextColorHex2;
              Line:= IntToHex(Ord(FBuffer[Pos+j]), 2);
              TextOut(Canvas, X, Y, Line);
              SelectLine(Line, Point(X, Y), FBufferPos+Pos+j, true);
              Inc(X, 3*CellWidth);
              if j=(FTextWidthHex div 2 - 1) then
                Inc(X, CellWidth); //Space
              end;

          //Draw text
          X:= X0+(cHexOffsetLen+Length(cHexOffsetSep)+4{4 spaces}+FTextWidthHex*3)*CellWidth;
          Canvas.Font.Color:= Self.Font.Color;
          Line:= '';

          for j:= 0 to FTextWidthHex-1 do
            if FBufferPos+Pos+j<FFileSize then
              begin
              ch:= FBuffer[Pos+j];
              Line:= Line+ch;
              end;

          if FEncoding=vencOEM then
            Line:= ToANSI(Line);

          LineText:= Line;
          PosTextX:= X;
          PosTextY:= Y;
          TextOut(Canvas, PosTextX, PosTextY, LineText);
          SelectLine(LineText, Point(PosTextX, PosTextY), FBufferPos+Pos);
          Strings.Add(LineText, Point(PosTextX, PosTextY), FBufferPos+Pos);

          //Draw lines
          if cHexLines then
            begin
            Canvas.Pen.Color:= FTextColorLines;
            Canvas.Pen.Width:= cHexLinesWidth;

            X:= X0+(cHexOffsetLen+Length(cHexOffsetSep)+1{1 space})*CellWidth;
            Canvas.MoveTo(X, Y);
            Canvas.LineTo(X, Y2);

            X:= X0+(cHexOffsetLen+Length(cHexOffsetSep)+2{2 spaces}+(FTextWidthHex div 2)*3)*CellWidth;
            Canvas.MoveTo(X, Y);
            Canvas.LineTo(X, Y2);

            X:= X0+(cHexOffsetLen+Length(cHexOffsetSep)+3{3 spaces}+FTextWidthHex*3)*CellWidth;
            Canvas.MoveTo(X, Y);
            Canvas.LineTo(X, Y2);
            end;
          end;
        end;

      vbmodeBinary:
        begin
        for i:= 1 to Min(LinesNum+1, cMaxLines) do
          begin
          Pos:= FViewPos-FBufferPos+(i-1)*FTextWidth;
          if FBufferPos+Pos>=FFileSize then Break;

          PosEnd:= Pos+FTextWidth-1;
          if PosEnd>=FFileSize-FBufferPos then
            PosEnd:= FFileSize-FBufferPos-1;

          Line:= '';
          for j:= Pos to PosEnd do
            Line:= Line+FBuffer[j];

          if FEncoding=vencOEM then
            Line:= ToANSI(Line);

          LineText:= Line;
          PosTextX:= X0;
          PosTextY:= Y0+(i-1)*FontHeight(Canvas);
          TextOut(Canvas, PosTextX, PosTextY, LineText);
          SelectLine(LineText, Point(PosTextX, PosTextY), FBufferPos+Pos);
          Strings.Add(LineText, Point(PosTextX, PosTextY), FBufferPos+Pos);
          end;
        end;

      vbmodeUnicode:
        begin
        for i:= 1 to Min(LinesNum+1, cMaxLines) do
          begin
          Pos:= (FViewPos-FBufferPos) div 2 * 2 + (i-1)*FTextWidth*2;
          if FBufferPos+Pos>=FFileSize then Break;

          Line:= '';
          for j:= 0 to FTextWidth-1 do
            begin
            PosEnd:= Pos+j*2;
            if FBufferPos+PosEnd+1<FFileSize then
              begin
              wch:= Ord(FBuffer[PosEnd])+(Ord(FBuffer[PosEnd+1]) shl 8);
              if wch<=$FF
                then Line:= Line+Chr(wch)
                else Line:= Line+cUnicodeChar;
              end;
            end;

          LineText:= Line;
          PosTextX:= X0;
          PosTextY:= Y0+(i-1)*FontHeight(Canvas);
          TextOut(Canvas, PosTextX, PosTextY, LineText);
          SelectLine(LineText, Point(PosTextX, PosTextY), FBufferPos+Pos);
          Strings.Add(LineText, Point(PosTextX, PosTextY), FBufferPos+Pos);
          end;
        end;

    end // if FFileOK
    else
      begin
      Line:= Format(ssViewerErrCannotReadPos, [IntToHex(FViewPos, cHexOffsetLen)]);
      X:= (Width-Canvas.TextWidth(Line)) div 2;
      Y:= (Height-FontHeight(Canvas)) div 2;
      if X<X0 then X:= X0;
      if Y<Y0 then Y:= Y0;
      Canvas.Font.Color:= FTextColorError;
      TextOut(Canvas, X, Y, Line);
      end;
    end;

  SetScrollBar;
  Paint;
end;

procedure TATBinHex.SetScrollBar;
var
  Cols: integer;
  FSize, Max, Pos, Page: Int64;
  si: TScrollInfo;
begin
  Cols:= ColsNum;
  FSize:= FFileSize;

  if FFileOK and (FSize>Cols) then
    begin
    Max:= FSize div Cols;
    if Max>MAXSHORT then Max:= MAXSHORT;

    Pos:= Max * FViewPos div FSize;
    if Pos>Max then Pos:= Max;

    Page:= Max * (LinesNum*Cols) div FSize;
    if Page<1 then Page:= 1;
    if Page>=Max then Page:= Max+1;
    if Page>MAXSHORT then Page:= MAXSHORT;
    end
  else
    begin
    Max:= 0;
    Pos:= 0;
    Page:= 0;
    end;

  FillChar(si, SizeOf(si), 0);
  si.cbSize:= SizeOf(si);
  si.fMask:= SIF_ALL;
  si.nMin:= 0;
  si.nMax:= Max;
  si.nPage:= Page;
  si.nPos:= Pos;

  SetScrollInfo(Handle, SB_VERT, si, true);
end;

procedure TATBinHex.Resize;
begin
  Redraw;
end;

procedure TATBinHex.Paint;
begin
  Canvas.Draw(0, 0, FBitmap);
end;

procedure TATBinHex.Click;
begin
  SetFocus;
end;

procedure TATBinHex.ReadBuffer;
var
  PosRec: TInt64Rec;
  BytesRead: DWORD;
begin
  FillChar(FBuffer^, cBufSize, 0);
  PosRec:= TInt64Rec(FBufferPos);
  if FFileHandle<>INVALID_HANDLE_VALUE then
    begin
    SetFilePointer(FFileHandle, PosRec.Lo, @PosRec.Hi, FILE_BEGIN);
    FFileOK:= ReadFile(FFileHandle, FBuffer^, cBufSize, BytesRead, nil);
    if not FFileOK then
      MsgError(SFormatS(ssViewerErrCannotReadFile, [FFileName]));
    end;
end;

function TATBinHex.Open(const AFileName: WideString): boolean;
begin
  Result:= true;
  if FFileName<>AFileName then
    begin
    FFileName:= AFileName;
    Result:= LoadFile;
    if FFileName<>'' then
      Redraw;
    end;
end;

function TATBinHex.LinesNum: integer;
begin
  Result:= (ClientHeight-4) div FontHeight(FBitmap.Canvas);
  if Result<0 then Result:= 0;
  if Result>cMaxLines then Result:= cMaxLines;
end;

function TATBinHex.ColsNumFit: integer;
begin
  Result:= (ClientWidth-4) div FontWidthDigits(FBitmap.Canvas);
  if Result<cMinTextWidth then Result:= cMinTextWidth;
end;

function TATBinHex.ColsNumHexFit: integer;
begin
  Result:= (ColsNumFit-(cHexOffsetLen+Length(cHexOffsetSep)+4{4 spaces})) div 4;
  if Result<cMinTextWidth then Result:= cMinTextWidth;
end;

function TATBinHex.ColsNum: integer;
begin
  case FMode of
    vbmodeHex: Result:= FTextWidthHex;
    vbmodeBinary: Result:= FTextWidth;
    vbmodeUnicode: Result:= FTextWidth*2;
    else Result:= cMinTextWidth;
  end;
end;

//Max position regarding page size
function TATBinHex.PosMax: Int64;
var
  Cols: integer;
begin
  Cols:= ColsNum;
  Result:= FFileSize div Cols * Cols;
  if Result=FFileSize then Dec(Result, Cols);
  Dec(Result, (LinesNum-1)*Cols);
  if Result<0 then Result:= 0;
end;

//Max position at the end of file
function TATBinHex.PosMax2: Int64;
begin
  Result:= FFileSize-1;
  if Result<0 then Result:= 0;
  if FMode=vbmodeUnicode then Result:= Result div 2 * 2;
end;

procedure TATBinHex.PosAt(const Pos: Int64; fRedraw: boolean = true);
begin
  if (Pos<>FViewPos) and (Pos>=0) and (Pos<=PosMax2) then
    begin
    FViewPos:= Pos;
    if not ((FViewPos>=FBufferPos) and (FViewPos<FBufferPos+2*cMaxBufOffset)) then
      begin
      FBufferPos:= Pos-cMaxBufOffset;
      if FBufferPos<0 then FBufferPos:= 0;
      ReadBuffer;
      end;
    if fRedraw then Redraw;
    end;
end;

procedure TATBinHex.PosDec(const n: Int64);
begin
  if FViewPos-n>=0
    then PosAt(FViewPos-n)
    else PosBegin;
end;

procedure TATBinHex.PosInc(const n: Int64);
begin
  if FViewPos<PosMax then
    PosAt(FViewPos+n);
end;

procedure TATBinHex.PosLineUp(n: word = 1);
begin
  PosDec(n*ColsNum);
end;

procedure TATBinHex.PosLineDown(n: word = 1);
begin
  PosInc(n*ColsNum);
end;

procedure TATBinHex.PosPageUp;
begin
  PosDec(LinesNum*ColsNum);
end;

procedure TATBinHex.PosPageDown;
begin
  PosInc(LinesNum*ColsNum);
end;

procedure TATBinHex.PosBegin;
begin
  PosAt(0);
end;

procedure TATBinHex.PosEnd;
begin
  PosAt(PosMax);
end;

function TATBinHex.GetPosPercent: word;
begin
  if FFileSize=0
    then Result:= 0
    else Result:= word(FViewPos * 100 div FFileSize);
end;

procedure TATBinHex.SetPosPercent(n: word);
var
  Num: Int64;
  Cols: integer;
begin
  if n=0 then PosBegin else
    if n>=100 then PosEnd else
      begin
      Num:= FFileSize * n div 100;
      Cols:= ColsNum;
      if Num>=PosMax then PosEnd else PosAt(Num div Cols * Cols);
      end;
end;

procedure TATBinHex.InitData;
begin
  FFileHandle:= INVALID_HANDLE_VALUE;
  FFileSize:= 0;
  FFileOK:= true;

  FBuffer:= nil;
  FBufferPos:= 0;
  FViewPos:= 0;
  FSelStart:= 0;
  FSelLength:= 0;
  FMouseDown:= false;
  FMouseStart:= -1;
  FMouseScrollUp:= false;
end;

procedure TATBinHex.FreeData;
begin
  if FFileHandle<>INVALID_HANDLE_VALUE then
    CloseHandle(FFileHandle);
  if Assigned(FBuffer) then
    FreeMem(FBuffer);
  InitData;
  FTimer.Enabled:= false;
end;

function TATBinHex.LoadFile: boolean;
var
  Size: Int64;
  SizeRec: TInt64Rec absolute Size;
begin
  Result:= false;
  FreeData;
  if FFileName='' then begin Result:= true; Exit end;

  FFileHandle:= FFileOpen(FFileName);
  if FFileHandle=INVALID_HANDLE_VALUE then
    begin MsgError(SFormatS(ssViewerErrCannotOpenFile, [FFileName])); Exit end;

  SizeRec.Lo:= GetFileSize(FFileHandle, @SizeRec.Hi);
  if (SizeRec.Lo=$FFFFFFFF) and (GetLastError<>NO_ERROR) then
    begin CloseHandle(FFileHandle); Exit end;
  FFileSize:= Size;

  GetMem(FBuffer, cBufSize);
  FillChar(FBuffer^, cBufSize, 0);
  ReadBuffer;
  Result:= true;
end;

procedure TATBinHex.SetMode(AMode: TATBinHexMode);
begin
  //No check for FMode<>AMode so file can be reread by setting the same mode
  FMode:= AMode;
  LoadFile;
  if FFileName<>'' then
    Redraw;
end;

procedure TATBinHex.SetEncoding(AEncoding: TATBinHexEncoding);
begin
  if AEncoding<>FEncoding then
    begin
    FEncoding:= AEncoding;
    Redraw;
    end;
end;

procedure TATBinHex.SetTextWidth(AWidth: word);
begin
  if AWidth<>FTextWidth then
    begin
    FTextWidth:= AWidth;
    if FTextWidth<cMinTextWidth then FTextWidth:= cMinTextWidth;
    if FTextWidth>cMaxTextWidth then FTextWidth:= cMaxTextWidth;
    end;
end;

procedure TATBinHex.SetTextWidthHex(AWidth: word);
begin
  if AWidth<>FTextWidthHex then
    begin
    FTextWidthHex:= AWidth;
    if FTextWidthHex<cMinTextWidth then FTextWidthHex:= cMinTextWidth;
    if FTextWidthHex>cMaxTextWidth then FTextWidthHex:= cMaxTextWidth;
    FTextWidthHex:= FTextWidthHex div 4 * 4;
    if FTextWidthHex=0 then FTextWidthHex:= 2;
    end;
end;

procedure TATBinHex.SetTextWidthFit(AFit: boolean);
begin
  if AFit<>FTextWidthFit then
    FTextWidthFit:= AFit;
end;

procedure TATBinHex.SetTextWidthFitHex(AFit: boolean);
begin
  if AFit<>FTextWidthFitHex then
    begin
    FTextWidthFitHex:= AFit;
    if not FTextWidthFitHex then FTextWidthHex:= 16;
    end;
end;

procedure TATBinHex.SetTextColorHex(AColor: TColor);
begin
  if AColor<>FTextColorHex then
    FTextColorHex:= AColor;
end;

procedure TATBinHex.SetTextColorHex2(AColor: TColor);
begin
  if AColor<>FTextColorHex2 then
    FTextColorHex2:= AColor;
end;

procedure TATBinHex.SetTextColorLines(AColor: TColor);
begin
  if AColor<>FTextColorLines then
    FTextColorLines:= AColor;
end;

procedure TATBinHex.SetTextColorError(AColor: TColor);
begin
  if AColor<>FTextColorError then
    FTextColorError:= AColor;
end;

procedure TATBinHex.SetSearchIndent(AIndent: word);
begin
  if AIndent<>FSearchIndent then
    begin
    FSearchIndent:= AIndent;
    if FSearchIndent>cMaxLines-1 then FSearchIndent:= cMaxLines-1;
    end;
end;

procedure TATBinHex.WMGetDlgCode(var Message: TMessage);
begin
  Message.Result:= DLGC_WANTARROWS;
end;

procedure TATBinHex.WMEraseBkgnd(var Message: TMessage);
begin
  Message.Result:= 1;
end;

procedure TATBinHex.WMVScroll(var Message: TWMVScroll);
var
  Max, Pos: Int64;
  Cols: integer;
begin
  case Message.ScrollCode of
    SB_TOP:
      PosBegin;
    SB_BOTTOM:
      PosEnd;
    //SB_ENDSCROLL:
    SB_LINEUP:
      PosLineUp;
    SB_LINEDOWN:
      PosLineDown;
    SB_PAGEUP:
      PosPageUp;
    SB_PAGEDOWN:
      PosPageDown;
    SB_THUMBPOSITION,
    SB_THUMBTRACK:
      begin
      Cols:= ColsNum;
      Max:= FFileSize div Cols;
      if Max>MAXSHORT then Max:= MAXSHORT;
      Pos:= FFileSize * Message.Pos div Max;
      Pos:= Pos div Cols * Cols;
      PosAt(Pos);
      end;
  end;
  Message.Result:= 0;
end;

procedure TATBinHex.KeyDown(var Key: Word; Shift: TShiftState);
begin
  if (Key=VK_NEXT) and (Shift=[]) then
    begin
    PosPageDown;
    Key:= 0;
    Exit
    end;
  if (Key=VK_PRIOR) and (Shift=[]) then
    begin
    PosPageUp;
    Key:= 0;
    Exit
    end;
  if (Key=VK_DOWN) and (Shift=[]) then
    begin
    PosLineDown;
    Key:= 0;
    Exit
    end;
  if (Key=VK_UP) and (Shift=[]) then
    begin
    PosLineUp;
    Key:= 0;
    Exit
    end;
  if (Key=VK_HOME) and (Shift=[ssCtrl]) then
    begin
    PosBegin;
    Key:= 0;
    Exit
    end;
  if (Key=VK_END) and (Shift=[ssCtrl]) then
    begin
    PosEnd;
    Key:= 0;
    Exit
    end;
  if FMode<>vbmodeUnicode then
    begin
    if (Key=Ord('A')) and (Shift=[ssCtrl]) then
      begin
      SelectAll;
      Key:= 0;
      Exit
      end;
    if (Key=Ord('C')) and (Shift=[ssCtrl]) then
      begin
      CopyToClipboard;
      Key:= 0;
      Exit
      end;
    end;
  inherited KeyDown(Key, Shift);
end;

function TATBinHex.FindText(const fText: string; const fPos: Int64; fWholeWords, fCaseSens: boolean): Int64;
const
  BlockSize = 64*1024;
var
  Buffer: array[0..BlockSize-1] of char;
  BufPos: Int64;
  BufPosRec: TInt64Rec absolute BufPos;
  BytesRead: DWORD;
  SBuffer: string;
  n: integer;
begin
  Result:= -1;
  BufPos:= fPos;
  repeat
    FillChar(Buffer, SizeOf(Buffer), 0);
    SetFilePointer(FFileHandle, BufPosRec.Lo, @BufPosRec.Hi, FILE_BEGIN);
    if not ReadFile(FFileHandle, Buffer, BlockSize, BytesRead, nil) then
      begin
      MsgError(SFormatS(ssViewerErrCannotReadFile, [FFileName]));
      Exit
      end;
    SetString(SBuffer, Buffer, SizeOf(Buffer));
    if FEncoding=vencOEM then
      SBuffer:= ToANSI(SBuffer);
    n:= SFindString(fText, SBuffer, fWholeWords, fCaseSens);
    if n>0 then
      begin
      Result:= BufPos+n-1;
      Exit
      end;
    Inc(BufPos, BlockSize);
    Dec(BufPos, Length(fText)+1);
    if BufPos<0 then BufPos:= 0;
  until BytesRead<BlockSize;
end;

procedure TATBinHex.Print(OnlySel: boolean; Copies: word);
const
  BlockSize = 64*1024;
var
  Buffer: array[0..BlockSize-1] of char;
  PosStart, PosEnd: Int64;
  PosStartRec: TInt64Rec absolute PosStart;
  BytesRead: DWORD;
  SBuffer: string;
  LenAll, Len: Int64;
  f: TextFile;
begin
  if Copies=0 then Inc(Copies);
  Printer.Copies:= Copies;
  Printer.Canvas.Font:= Self.Font;
  AssignPrn(f);
  Rewrite(f);
  if OnlySel
    then begin PosStart:= FSelStart; PosEnd:= FSelStart+FSelLength-1; end
    else begin PosStart:= 0; PosEnd:= FFileSize-1; end;
  try
    repeat
      FillChar(Buffer, SizeOf(Buffer), 0);
      SetFilePointer(FFileHandle, PosStartRec.Lo, @PosStartRec.Hi, FILE_BEGIN);
      if not ReadFile(FFileHandle, Buffer, BlockSize, BytesRead, nil) then
        begin
        MsgError(SFormatS(ssViewerErrCannotReadFile, [FFileName]));
        Exit
        end;
      LenAll:= PosEnd-PosStart+1;
      Len:= LenAll;
      if Len>BytesRead then Len:= BytesRead;

      SetString(SBuffer, Buffer, Len);
      if FEncoding=vencOEM then
        SBuffer:= ToANSI(SBuffer);
      Write(f, SBuffer);

      Inc(PosStart, BlockSize);
    until (BytesRead<BlockSize) or (LenAll<=BytesRead);
  finally
    CloseFile(f);
  end;
end;

procedure TATBinHex.CopyToClipboard;
var
  Buffer: PChar;
  BufPosRec: TInt64Rec;
  BlockSize, BytesRead: DWORD;
begin
  Buffer:= nil;
  BufPosRec:= TInt64Rec(FSelStart);
  if FSelLength>MaxInt
    then BlockSize:= MaxInt
    else BlockSize:= FSelLength;
  try
    GetMem(Buffer, BlockSize+1);
    FillChar(Buffer^, BlockSize+1, 0);
    SetFilePointer(FFileHandle, BufPosRec.Lo, @BufPosRec.Hi, FILE_BEGIN);
    if not ReadFile(FFileHandle, Buffer^, BlockSize, BytesRead, nil) then
      begin
      MsgError(SFormatS(ssViewerErrCannotReadFile, [FFileName]));
      Exit
      end;
    if FEncoding=vencOEM then
      OemToCharBuff(Buffer, Buffer, BytesRead);
    Clipboard.AsText:= Buffer;
  finally
    FreeMem(Buffer);
  end;
end;

procedure TATBinHex.SetSelection(const AStart, ALength: Int64; fPosition: boolean);
var
  Pos: Int64;
  Cols: integer;
begin
  if (AStart<>FSelStart) or (ALength<>FSelLength) then
    begin
    FSelStart:= AStart;
    FSelLength:= ALength;
    if fPosition then
      begin
      Cols:= ColsNum;
      Pos:= FSelStart div Cols * Cols;
      Dec(Pos, Cols*FSearchIndent);
      if Pos<0 then Pos:= 0;
      PosAt(Pos, false);
      end;
    Redraw;
    end;
end;

procedure TATBinHex.SelectAll;
begin
  SetSelection(0, FFileSize, false);
end;

procedure TATBinHex.SelectNone;
begin
  SetSelection(0, 0, false);
end;

procedure TATBinHex.MouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  PosLineUp(cMWheelLines);
  Handled:= true;
end;

procedure TATBinHex.MouseWheelDown(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  PosLineDown(cMWheelLines);
  Handled:= true;
end;

function TATBinHex.MousePosition(X, Y: integer): Int64;
begin
  Result:= (FStrings as TStrPositions).GetPosition(FBitmap.Canvas, Point(X, Y));
end;

procedure TATBinHex.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  SetFocus;
  if FMode=vbmodeUnicode then Exit;
  if Button=mbLeft then
    begin
    SelectNone;
    FMouseDown:= true;
    FMouseStart:= MousePosition(X, Y);
    end;
end;

procedure TATBinHex.MouseMoveAction(X, Y: integer);
var
  fPosStart, fPosEnd: Int64;
begin
  fPosStart:= FMouseStart;
  if fPosStart<0 then Exit;
  fPosEnd:= MousePosition(X, Y);
  if fPosEnd<0 then Exit;
  if fPosStart>fPosEnd then
    SwapInt64(fPosStart, fPosEnd);
  SetSelection(fPosStart, fPosEnd-fPosStart, false);
end;

procedure TATBinHex.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  if FMode=vbmodeUnicode then Exit;
  if FMouseDown then
    begin
    if Y<0 then
      begin FMouseScrollUp:= true; FTimer.Enabled:= true; Exit end;
    if Y>ClientHeight then
      begin FMouseScrollUp:= false; FTimer.Enabled:= true; Exit end;
    FTimer.Enabled:= false;
    MouseMoveAction(X, Y);
    end
  else
    FTimer.Enabled:= false;
end;

procedure TATBinHex.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button=mbLeft then
    begin
    FMouseDown:= false;
    FMouseStart:= -1;
    FTimer.Enabled:= false;
    end;
end;

procedure TATBinHex.TimerTimer(Sender: TObject);
begin
  if FMouseScrollUp then
    begin
    PosLineUp(cMScrollLines);
    MouseMoveAction(0, -1);
    end
  else
    begin
    PosLineDown(cMScrollLines);
    MouseMoveAction(0, ClientHeight+1);
    end;
end;

procedure TATBinHex.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.Style:= Params.Style or WS_VSCROLL;
end;

procedure Register;
begin
  RegisterComponents('Samples', [TATBinHex]);
end;

end.
