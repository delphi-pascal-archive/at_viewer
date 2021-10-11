unit FIniFile;

interface

uses Windows;

procedure DelIniKey(const fn: WideString; const section, key: WideString);
procedure SetIniKey(const fn: WideString; const section, key, value: WideString); overload;
procedure SetIniKey(const fn: WideString; const section, key: WideString; value: integer); overload;
procedure SetIniKey(const fn: WideString; const section, key: WideString; value: boolean); overload;

function GetIniKey(const fn: WideString; const section, key, default: WideString): WideString; overload;
function GetIniKey(const fn: WideString; const section, key: WideString; default: integer): integer; overload;
function GetIniKey(const fn: WideString; const section, key: WideString; default: boolean): boolean; overload;

implementation

uses SysUtils;

function IntToStr(n: integer): string;
begin
  Str(n:0, Result);
end;

function StrToIntDef(const s: string; default: integer): integer;
var
  code: integer;
begin
  Val(s, Result, code);
  if code>0 then Result:= default;
end;

procedure DelIniKey(const fn: WideString; const section, key: WideString);
begin
  if Win32Platform=VER_PLATFORM_WIN32_NT
    then WritePrivateProfileStringW(PWChar(section), PWChar(key), nil, PWChar(fn))
    else WritePrivateProfileStringA(PChar(string(section)), PChar(string(key)), nil, PChar(string(fn)));
end;

procedure SetIniKey(const fn: WideString; const section, key, value: WideString);
begin
  if Win32Platform=VER_PLATFORM_WIN32_NT
    then WritePrivateProfileStringW(PWChar(section), PWChar(key), PWChar(value), PWChar(fn))
    else WritePrivateProfileStringA(PChar(string(section)), PChar(string(key)), PChar(string(value)), PChar(string(fn)));
end;

procedure SetIniKey(const fn: WideString; const section, key: WideString; value: integer);
begin
  if Win32Platform=VER_PLATFORM_WIN32_NT
    then WritePrivateProfileStringW(PWChar(section), PWChar(key), PWChar(WideString(IntToStr(value))), PWChar(fn))
    else WritePrivateProfileStringA(PChar(string(section)), PChar(string(key)), PChar(IntToStr(value)), PChar(string(fn)));
end;

procedure SetIniKey(const fn: WideString; const section, key: WideString; value: boolean);
begin
  SetIniKey(fn, section, key, integer(value));
end;

function GetIniKey(const fn: WideString; const section, key, default: WideString): WideString;
const
  bufSize = 5*1024;
var
  bufA: array[0..bufSize-1] of char;
  bufW: array[0..bufSize-1] of WideChar;
begin
  if Win32Platform=VER_PLATFORM_WIN32_NT then
    begin
    FillChar(bufW, SizeOf(bufW), 0);
    GetPrivateProfileStringW(PWChar(section), PWChar(key), PWChar(default),
      bufW, SizeOf(bufW) div 2, PWChar(fn));
    Result:= bufW;
    end
  else
    begin
    FillChar(bufA, SizeOf(bufA), 0);
    GetPrivateProfileStringA(PChar(string(section)), PChar(string(key)), PChar(string(default)),
      bufA, SizeOf(bufA), PChar(string(fn)));
    Result:= string(bufA);
    end;
end;

function GetIniKey(const fn: WideString; const section, key: WideString; default: integer): integer;
var
  s: string;
begin
  s:= GetIniKey(fn, section, key, IntToStr(default));
  Result:= StrToIntDef(s, 0);
end;

function GetIniKey(const fn: WideString; const section, key: WideString; default: boolean): boolean;
begin
  Result:= boolean(GetIniKey(fn, section, key, integer(default)));
end;
 
end.
