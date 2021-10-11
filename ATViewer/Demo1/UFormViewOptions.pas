unit UFormViewOptions;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TFormViewOptions = class(TForm)
    btnOk: TButton;
    btnCancel: TButton;
    boxExt: TGroupBox;
    edText: TEdit;
    Label1: TLabel;
    edImages: TEdit;
    Label2: TLabel;
    edMedia: TEdit;
    Label3: TLabel;
    edInternet: TEdit;
    Label4: TLabel;
    boxText: TGroupBox;
    boxMedia: TGroupBox;
    chkMediaMCI: TRadioButton;
    chkMediaWMP64: TRadioButton;
    btnTextColor: TButton;
    btnTextFont: TButton;
    FontDialog1: TFontDialog;
    ColorDialog1: TColorDialog;
    labTextFont: TLabel;
    edTextWidth: TEdit;
    Label5: TLabel;
    edTextIndent: TEdit;
    Label6: TLabel;
    btnTextOptions: TButton;
    chkTextWidthFit: TCheckBox;
    procedure btnTextFontClick(Sender: TObject);
    procedure btnTextColorClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnTextOptionsClick(Sender: TObject);
    procedure chkTextWidthFitClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    fTextFontName: string;
    fTextFontSize: integer;
    fTextFontColor: integer;
    fTextFontStyle: TFontStyles;
    fTextBackColor: integer;
    fTextDetect: boolean;
    fTextDetectSize: DWORD;
    fTextDetectLimit: DWORD;
  end;

//var
//  FormViewOptions: TFormViewOptions;

implementation

uses UFormViewOptions2;

{$R *.DFM}

procedure TFormViewOptions.btnTextFontClick(Sender: TObject);
begin
  with FontDialog1 do
    begin
    Font.Name:= fTextFontName;
    Font.Size:= fTextFontSize;
    Font.Color:= fTextFontColor;
    Font.Style:= fTextFontStyle;
    if Execute then
      begin
      fTextFontName:= Font.Name;
      fTextFontSize:= Font.Size;
      fTextFontColor:= Font.Color;
      fTextFontStyle:= Font.Style;
      labTextFont.Caption:= fTextFontName+', '+IntToStr(fTextFontSize);
      end;
    end;
end;

procedure TFormViewOptions.btnTextColorClick(Sender: TObject);
begin
  with ColorDialog1 do
    begin
    Color:= fTextBackColor;
    if Execute then
      fTextBackColor:= Color;
    end;
end;

procedure TFormViewOptions.FormShow(Sender: TObject);
begin
  labTextFont.Caption:= fTextFontName+', '+IntToStr(fTextFontSize);
  chkTextWidthFitClick(Self);
end;

procedure TFormViewOptions.btnTextOptionsClick(Sender: TObject);
begin
  with TFormViewOptions2.Create(Self) do
    try
      chkDetect.Checked:= fTextDetect;
      edDetectSize.Text:= IntToStr(fTextDetectSize);
      edDetectLimit.Text:= IntToStr(fTextDetectLimit);
      if ShowModal=mrOk then
        begin
        fTextDetect:= chkDetect.Checked;
        fTextDetectSize:= StrToIntDef(edDetectSize.Text, fTextDetectSize); 
        fTextDetectLimit:= StrToIntDef(edDetectLimit.Text, fTextDetectLimit); 
        end;
    finally
      Free;
    end;
end;

procedure TFormViewOptions.chkTextWidthFitClick(Sender: TObject);
begin
  edTextWidth.Enabled:= not chkTextWidthFit.Checked;
end;

end.
