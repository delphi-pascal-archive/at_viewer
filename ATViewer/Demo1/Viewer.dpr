program Viewer;

uses
  Forms,
  SProc,
  FProc,
  ATViewerProc,
  UFormView in 'UFormView.pas' {FormView},
  UFormFindText in 'UFormFindText.pas' {FormFindText},
  UFormViewOptions in 'UFormViewOptions.pas' {FormViewOptions},
  UFormViewOptions2 in 'UFormViewOptions2.pas' {FormViewOptions2},
  UFormViewGoto in 'UFormViewGoto.pas' {FormViewGoto};

{$R *.RES}
{$R Main.res}

var
  fn: WideString;
begin
  fn:= SParamStr(1);
  if (fn<>'') then
    begin
    if not IsFileExist(fn) then
      begin
      MsgError(SFormatS(ssViewerErrCannotFindFile, [fn]));
      Halt
      end;
    if not IsFileAccessed(fn) then
      begin
      MsgError(SFormatS(ssViewerErrCannotOpenFile, [fn]));
      Halt
      end;
    end;

  Application.Initialize;
  Application.Title := 'Viewer';
  Application.CreateForm(TFormView, FormView);
  Application.Run;
end.
