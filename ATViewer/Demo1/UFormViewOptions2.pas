unit UFormViewOptions2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TFormViewOptions2 = class(TForm)
    chkDetect: TCheckBox;
    btnCancel: TButton;
    btnOk: TButton;
    edDetectSize: TEdit;
    edDetectLimit: TEdit;
    labDetect1: TLabel;
    labDetect2: TLabel;
    labDetectL1: TLabel;
    labDetectL2: TLabel;
    procedure FormShow(Sender: TObject);
    procedure chkDetectClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

//var
//  FormViewOptions2: TFormViewOptions2;

implementation

{$R *.DFM}

procedure TFormViewOptions2.FormShow(Sender: TObject);
begin
  edDetectSize.Left:= labDetect1.Left+labDetect1.Width+6;
  edDetectLimit.Left:= labDetectL1.Left+labDetectL1.Width+6;
  labDetect2.Left:= edDetectSize.Left+edDetectSize.Width+6;
  labDetectL2.Left:= edDetectLimit.Left+edDetectLimit.Width+6;
  chkDetectClick(Self);
end;

procedure TFormViewOptions2.chkDetectClick(Sender: TObject);
begin
  edDetectSize.Enabled:= chkDetect.Checked;
  edDetectLimit.Enabled:= chkDetect.Checked;
end;

end.
