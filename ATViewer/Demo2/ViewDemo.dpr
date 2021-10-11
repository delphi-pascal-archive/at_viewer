program ViewDemo;

uses
  Forms,
  UFormView in 'UFormView.pas' {FormView};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'ATViewer Demo';
  Application.CreateForm(TFormView, FormView);
  Application.Run;
end.
