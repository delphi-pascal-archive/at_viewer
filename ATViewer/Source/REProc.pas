{$I ATViewerDef.inc}

unit REProc;

interface

uses Windows, ComCtrls;

function RE_CurrentLine(Edit: TRichEdit): integer;
function RE_LineFromPos(Edit: TRichEdit; Pos: integer): integer;
function RE_PosFromLine(Edit: TRichEdit; Line: integer): integer;
procedure RE_ScrollToStart(Edit: TRichEdit);
procedure RE_ScrollToEnd(Edit: TRichEdit);
procedure RE_ScrollToLine(Edit: TRichEdit; Line, Indent: integer);
procedure RE_ScrollToPercent(Edit: TRichEdit; N: integer);

procedure RE_LimitSize(Edit: TRichEdit; Size: DWORD);
procedure RE_LoadFile(Edit: TRichEdit; const AFileName: WideString;
          IsOEM: boolean; ASelStart, ASelLength: integer);

procedure RE_Print(Edit: TRichEdit; OnlySel: boolean; Copies: integer);

implementation

uses
  SysUtils, Messages, Classes,
  {$ifdef TNT}TntClasses,{$endif}
  Printers, RichEdit, SProc;

function RE_CurrentLine(Edit: TRichEdit): integer;
begin
  Result:= Edit.Perform(EM_GETFIRSTVISIBLELINE, 0, 0);
end;

function RE_LineFromPos(Edit: TRichEdit; Pos: integer): integer;
begin
  Result:= Edit.Perform(EM_EXLINEFROMCHAR, 0, Pos);
end;

function RE_PosFromLine(Edit: TRichEdit; Line: integer): integer;
begin
  Result:= Edit.Perform(EM_LINEINDEX, Line, 0);
end;

procedure RE_ScrollToStart(Edit: TRichEdit);
var
  n: DWORD;
begin
  repeat
    n:= Edit.Perform(EM_SCROLL, SB_PAGEUP, 0);
  until (n and $FFFF)=0;
end;

procedure RE_ScrollToEnd(Edit: TRichEdit);
var
  n: DWORD;
begin
  repeat
    n:= Edit.Perform(EM_SCROLL, SB_PAGEDOWN, 0);
  until (n and $FFFF)=0;
end;

procedure RE_ScrollToLine(Edit: TRichEdit; Line, Indent: integer);
begin
  RE_ScrollToStart(Edit);
  Dec(Line, Indent);
  if Line<0 then Line:= 0;
  Edit.Perform(EM_LINESCROLL, 0, Line);
end;

procedure RE_ScrollToPercent(Edit: TRichEdit; N: integer);
var
  Num: integer;
begin
  if N<=0 then
    begin
    RE_ScrollToStart(Edit);
    Edit.SelStart:= 0;
    Edit.SelLength:= 0;
    end
  else
  if N>=100 then
    begin
    RE_ScrollToEnd(Edit);
    Edit.SelStart:= RE_PosFromLine(Edit, Edit.Lines.Count-1);
    Edit.SelLength:= 0;
    end
  else
    begin
    Num:= (Edit.Lines.Count-1) * N div 100;
    if Num>0 then
      begin
      RE_ScrollToLine(Edit, Num, 0);
      Edit.SelStart:= RE_PosFromLine(Edit, Num);
      Edit.SelLength:= 0;
      end;
    end;
end;

procedure RE_LimitSize(Edit: TRichEdit; Size: DWORD);
begin
  Edit.Perform(EM_EXLIMITTEXT, 0, Size);
end;

procedure RE_LoadFile(Edit: TRichEdit; const AFileName: WideString;
  IsOEM: boolean; ASelStart, ASelLength: integer);
var
  Stream: TStream;
  i: integer;
begin
  with Edit do
    begin
    Lines.Clear;
    
    Stream:= {$ifdef TNT}TTntFileStream{$else}TFileStream{$endif}.Create(AFileName, fmOpenRead or fmShareDenyWrite);
    try
      Lines.LoadFromStream(Stream);
    finally
      Stream.Free;
    end;

    if IsOEM then
      for i:= 0 to Lines.Count-1 do
        Lines[i]:= ToANSI(Lines[i]);
    end;

  RE_ScrollToStart(Edit);
  Edit.SelStart:= ASelStart;
  Edit.SelLength:= ASelLength;
end;

procedure RE_Print(Edit: TRichEdit; OnlySel: boolean; Copies: integer);
var
  ASelStart, ASelLength: integer;
begin
  if Copies=0 then Inc(Copies);
  Printer.Copies:= Copies;
  Printer.Canvas.Font:= Edit.Font;
  if OnlySel then
    begin
    ASelStart:= Edit.SelStart;
    ASelLength:= Edit.SelLength;
    Edit.SelStart:= ASelStart+ASelLength;
    Edit.SelLength:= MaxInt;
    Edit.SelText:= '';
    Edit.SelStart:= 0;
    Edit.SelLength:= ASelStart;
    Edit.SelText:= '';
    end;
  Edit.Print('');
end;

end.
