{$I ATViewerDef.inc}

unit ATViewerProc;

interface

uses Windows;

function MsgBox(const Msg, Title: WideString; Flags: integer; h: THandle = INVALID_HANDLE_VALUE): integer;
procedure MsgInfo(const Msg: WideString; h: THandle = INVALID_HANDLE_VALUE);
procedure MsgError(const Msg: WideString; h: THandle = INVALID_HANDLE_VALUE);

const
  ssViewerCaption: string = 'Viewer';
  ssViewerAbout: string = 'Universal file viewer';
  ssViewerAbout2 = 'Copyright © 2006 Alexey Torgashin';
  ssViewerErrCannotFindFile: string = 'File not found: %s';
  ssViewerErrCannotOpenFile: string = 'Cannot open file: %s';
  ssViewerErrCannotSaveFile: string = 'Cannot save file: %s';
  ssViewerErrCannotLoadFile: string = 'Cannot load file: %s';
  ssViewerErrCannotReadFile: string = 'Cannot read file: %s';
  ssViewerErrCannotReadPos: string = 'Read error at offset %s';
  ssViewerErrImage: string = 'Unknown image format';
  ssViewerErrMultimedia: string = 'Unknown multimedia format';
  ssViewerErrCannotFindText: string = 'String not found: %s';
  ssViewerErrCannotCopyText: string = 'Cannot copy text to clipboard';

implementation

uses SysUtils, Forms;

function MsgBox(const Msg, Title: WideString; Flags: integer; h: THandle = INVALID_HANDLE_VALUE): integer;
begin
  if h=INVALID_HANDLE_VALUE then
    h:= Application.Handle;
  if Win32Platform=VER_PLATFORM_WIN32_NT
    then Result:= MessageBoxW(h, PWChar(Msg), PWChar(Title), Flags or MB_SETFOREGROUND)
    else Result:= MessageBoxA(h, PChar(string(Msg)), PChar(string(Title)), Flags or MB_SETFOREGROUND);
end;

procedure MsgInfo(const Msg: WideString; h: THandle = INVALID_HANDLE_VALUE);
begin
  MsgBox(Msg, ssViewerCaption, MB_OK or MB_ICONINFORMATION, h);
end;

procedure MsgError(const Msg: WideString; h: THandle = INVALID_HANDLE_VALUE);
begin
  MsgBox(Msg, ssViewerCaption, MB_OK or MB_ICONERROR, h);
end;

end.
