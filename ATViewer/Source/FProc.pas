{$I ATViewerDef.inc}

unit FProc;

interface

uses Windows;

function SParamCount: integer;
function SParamStr(n: integer): WideString;

function IsFileExist(const fn: WideString; var IsDir: boolean): boolean; overload;
function IsFileExist(const fn: WideString): boolean; overload;
function IsDirExist(const fn: WideString): boolean; overload;
function IsFileText(const fn: WideString; SizeKb, LimitKb: DWORD): boolean;

function FFileOpen(const fn: WideString): THandle;
function IsFileAccessed(const fn: WideString): boolean;
function FFileCopy(const fnSrc, fnDest: WideString): boolean;
function FFileSize(const fn: WideString): Int64;

type
  PInt64Rec = ^TInt64Rec;
  TInt64Rec = record Lo, Hi: DWORD end;

implementation

uses {$ifdef TNT}TntSystem,{$endif} SysUtils;

var
  IsNT: boolean;

function SParamCount: integer;
begin
  Result:= ParamCount;
  {$ifdef TNT}
  if IsNT then Result:= WideParamCount;
  {$endif}
end;

function SParamStr(n: integer): WideString;
begin
  Result:= ParamStr(n);
  {$ifdef TNT}
  if IsNT then Result:= WideParamStr(n);
  {$endif}
end;

function IsFileExist(const fn: WideString; var IsDir: boolean): boolean; overload;
var
  h: THandle;
  fdA: TWin32FindDataA;
  fdW: TWin32FindDataW;
begin
  IsDir:= false;
  if IsNT then
    begin
    h:= FindFirstFileW(PWChar(fn), fdW);
    Result:= h<>INVALID_HANDLE_VALUE;
    if Result then
      begin
      IsDir:= (fdW.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY)<>0;
      Windows.FindClose(h);
      end;
    end
  else
    begin
    h:= FindFirstFileA(PChar(string(fn)), fdA);
    Result:= h<>INVALID_HANDLE_VALUE;
    if Result then
      begin
      IsDir:= (fdA.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY)<>0;
      Windows.FindClose(h);
      end;
    end;
end;

function IsFileExist(const fn: WideString): boolean; overload;
var
  IsDir: boolean;
begin
  Result:= IsFileExist(fn, IsDir) and (not IsDir);
end;

function IsDirExist(const fn: WideString): boolean; overload;
var
  IsDir: boolean;
begin
  Result:= IsFileExist(fn, IsDir) and IsDir;
end;

function FFileOpen(const fn: WideString): THandle;
begin
  if IsNT then
    Result:= CreateFileW(PWChar(fn),
             GENERIC_READ, FILE_SHARE_READ or FILE_SHARE_WRITE,
             nil, OPEN_EXISTING, 0, 0)
  else
    Result:= CreateFileA(PChar(string(fn)),
             GENERIC_READ, FILE_SHARE_READ or FILE_SHARE_WRITE,
             nil, OPEN_EXISTING, 0, 0);
end;

function FFileCopy(const fnSrc, fnDest: WideString): boolean;
begin
  if IsNT then
    Result:= CopyFileW(PWChar(fnSrc), PWChar(fnDest), false)
  else
    Result:= CopyFileA(PChar(string(fnSrc)), PChar(string(fnDest)), false);
end;

function IsFileAccessed(const fn: WideString): boolean;
var
  h: THandle;
begin
  h:= FFileOpen(fn);
  Result:= h<>INVALID_HANDLE_VALUE;
  if Result then CloseHandle(h);
end;

function IsFileText(const fn: WideString; SizeKb, LimitKb: DWORD): boolean;
var
  Buffer: PChar;
  BufSize, BytesRead: DWORD;
  h: THandle;
  i: integer;
  ch: char;
begin
  Result:= false;
  if (LimitKb>0) and (FFileSize(fn)>Int64(LimitKb)*1024) then Exit;
  if (SizeKb=0) then begin Result:= true; Exit end;

  h:= FFileOpen(fn);
  if h=INVALID_HANDLE_VALUE then Exit;
  Buffer:= nil;
  BufSize:= SizeKb*1024;
  try
    GetMem(Buffer, BufSize);
    FillChar(Buffer^, BufSize, 0);
    if ReadFile(h, Buffer^, BufSize, BytesRead, nil) then
      begin
      Result:= true;
      for i:= 0 to BytesRead-1 do
        begin
        ch:= Buffer[i];
        if (ch<#32) and (ch<>#09) and (ch<>#13) and (ch<>#10) then
          begin Result:= false; Break end;
        end;
      end;
  finally
    FreeMem(Buffer);
    CloseHandle(h);
  end;
end;

function FFileSize(const fn: WideString): Int64;
var
  h: THandle;
  fdA: TWin32FindDataA;
  fdW: TWin32FindDataW;
  SizeRec: TInt64Rec absolute Result;
begin
  Result:= -1;
  if IsNT then
    begin
    h:= FindFirstFileW(PWChar(fn), fdW);
    if h<>INVALID_HANDLE_VALUE then
      begin
      //Attr:= fdW.dwFileAttributes;
      SizeRec.Hi:= fdW.nFileSizeHigh;
      SizeRec.Lo:= fdW.nFileSizeLow;
      //Time:= fdW.ftLastWriteTime;
      Windows.FindClose(h);
      end;
    end
  else
    begin
    h:= FindFirstFileA(PChar(string(fn)), fdA);
    if h<>INVALID_HANDLE_VALUE then
      begin
      //Attr:= fdA.dwFileAttributes;
      SizeRec.Hi:= fdA.nFileSizeHigh;
      SizeRec.Lo:= fdA.nFileSizeLow;
      //Time:= fdA.ftLastWriteTime;
      Windows.FindClose(h);
      end;
    end;
end;

initialization
  IsNT:= Win32Platform=VER_PLATFORM_WIN32_NT;

end.
