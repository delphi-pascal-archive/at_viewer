unit UFormFindText;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TFormFindText = class(TForm)
    Label1: TLabel;
    btnOk: TButton;
    btnCancel: TButton;
    chkWords: TCheckBox;
    chkCase: TCheckBox;
    edText: TComboBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

//var
//  FormFindText: TFormFindText;

implementation

{$R *.DFM}

end.
