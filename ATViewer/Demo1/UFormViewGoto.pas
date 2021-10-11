unit UFormViewGoto;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TFormViewGoto = class(TForm)
    btnOk: TButton;
    btnCancel: TButton;
    edNum: TEdit;
    labDetect1: TLabel;
    Label1: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

//var
//  FormViewGoto: TFormViewGoto;

function FormGotoResult(N: integer): integer;

implementation

{$R *.DFM}

function FormGotoResult(N: integer): integer;
begin
  Result:= -1;
  with TFormViewGoto.Create(nil) do
    try
      edNum.Text:= IntToStr(N);
      if ShowModal=mrOk then
        Result:= StrToIntDef(edNum.Text, -1);
    finally
      Free;
    end;
end;

end.
