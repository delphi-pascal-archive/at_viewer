unit SProc;

interface

uses Windows;

procedure SReplace(var s: WideString; const sfrom, sto: WideString);
function SFormatS(const Msg: WideString; Params: array of WideString): WideString;

function ToOEM(const s: string): string;
function ToANSI(const s: string): string;

function SExtractFileDir(const FileName: WideString): WideString;
function SExtractFilePath(const FileName: WideString): WideString;
function SExtractFileExt(const FileName: WideString): WideString;

function SFindString(const F, S: string; fWholeWords, fCaseSens: boolean): integer;

function Min(n1, n2: integer): integer;
function Max(n1, n2: integer): integer;

implementation

procedure SReplace(var s: WideString; const sfrom, sto: WideString);
var
  i: integer;
begin
  i:= Pos(sfrom, s);
  if i>0 then
    begin
    Delete(s, i, Length(sfrom));
    Insert(sto, s, i);
    end;
end;

function SFormatS(const Msg: WideString; Params: array of WideString): WideString;
var
  i: integer;
begin
  Result:= Msg;
  for i:= Low(Params) to High(Params) do
    SReplace(Result, '%s', Params[i]);
end;

function ToOEM(const s: string): string;
begin
  SetLength(Result, Length(s));
  CharToOemBuff(PChar(s), PChar(Result), Length(s));
end;

function ToANSI(const s: string): string;
begin
  SetLength(Result, Length(s));
  OemToCharBuff(PChar(s), PChar(Result), Length(s));
end;

function LastDelimiter(const Delimiters, S: WideString): Integer;
var
  i: integer;
begin
  for i:= Length(S) downto 1 do
    if Pos(S[i], Delimiters)>0 then
      begin Result:= i; Exit end;
  Result:= 0;
end;

function SExtractFileDir(const FileName: WideString): WideString;
var
  I: Integer;
begin
  I := LastDelimiter('\:', FileName);
  if (I > 1) and (FileName[I] = '\') and
    (not (char(FileName[I - 1]) in ['\', ':'])) then Dec(I);
  Result := Copy(FileName, 1, I);
end;

function SExtractFilePath(const FileName: WideString): WideString;
var
  I: Integer;
begin
  I := LastDelimiter('\:', FileName);
  Result := Copy(FileName, 1, I);
end;

function SExtractFileExt(const FileName: WideString): WideString;
var
  I: Integer;
begin
  I := LastDelimiter('.\:', FileName);
  if (I > 0) and (FileName[I] = '.') then
    Result := Copy(FileName, I, MaxInt) else
    Result := '';
end;

function SLower(const S: string): string;
begin
  Result:= S;
  if Result<>'' then
    begin
    UniqueString(Result);
    CharLowerBuff(@Result[1], Length(Result));
    end;
end;

function SDelimiters: string;
const
  Chars = ' !"#$%&''()*+,-./:;<=>?'+'@[\]^'+'`{|}~';
var
  i: integer;
begin
  Result:= '';
  for i:= 0 to 31 do
    Result:= Result+Chr(i);
  Result:= Result+Chars;
end;

function SFindString(const F, S: string; fWholeWords, fCaseSens: boolean): integer;
var
  SBuf, FBuf: string;
  Delimiters: string;
  Match: boolean;
  i, j: integer;
begin
  Result:= 0;
  Delimiters:= SDelimiters;

  SBuf:= S;
  FBuf:= F;
  if not fCaseSens then
    begin
    SBuf:= SLower(SBuf);
    FBuf:= SLower(FBuf);
    end;

  for i:= 1 to Length(S)-Length(F)+1 do
    begin
    //Match:= FBuf=Copy(SBuf, i, Length(FBuf)); //Slow
    Match:= true;
    for j:= 1 to Length(FBuf) do
      if FBuf[j]<>SBuf[i+j-1] then
        begin Match:= false; Break end;

    if fWholeWords then
      Match:= Match
        and ((i=1) or (Pos(S[i-1], Delimiters)>0))
        and (i<Length(S)-Length(F)+1)
        and ({(i>=Length(S)-Length(F)+1) or} (Pos(S[i+Length(F)], Delimiters)>0));

    if Match then
      begin
      Result:= i;
      Break
      end;
    end;
end;

function Min(n1, n2: integer): integer;
begin
  if n1<n2 then Result:= n1 else Result:= n2;
end;

function Max(n1, n2: integer): integer;
begin
  if n1>n2 then Result:= n1 else Result:= n2;
end;


end.
