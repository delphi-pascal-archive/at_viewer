unit UFormView;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  VirtualExplorerTree, VirtualTrees, ExtCtrls,
  ATViewer, StdCtrls;

type
  TFormView = class(TForm)
    Panel1: TPanel;
    Splitter1: TSplitter;
    Panel2: TPanel;
    TreeEx: TVirtualExplorerTreeview;
    Splitter2: TSplitter;
    LVEx: TVirtualExplorerListview;
    GroupBox1: TGroupBox;
    Viewer: TATViewer;
    GroupBox2: TGroupBox;
    chkModeDetect: TCheckBox;
    chkModeText: TRadioButton;
    chkModeBinary: TRadioButton;
    chkModeHex: TRadioButton;
    chkModeMedia: TRadioButton;
    chkModeWeb: TRadioButton;
    chkModeUnicode: TRadioButton;
    procedure LVExChange(Sender: TBaseVirtualTree;
      Node: PVirtualNode);
    procedure chkModeDetectClick(Sender: TObject);
    procedure chkModeTextClick(Sender: TObject);
    procedure chkModeBinaryClick(Sender: TObject);
    procedure chkModeHexClick(Sender: TObject);
    procedure chkModeMediaClick(Sender: TObject);
    procedure chkModeWebClick(Sender: TObject);
    procedure chkModeUnicodeClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure UpdateView(en: boolean);
  end;

var
  FormView: TFormView;

implementation

uses SProc, FProc, VirtualShellUtilities;

{$R *.DFM}

var
  FLoad: boolean = false;

procedure TFormView.LVExChange(
  Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  NS: TNamespace;
  S: WideString;
begin
  with LVEx do
    if ValidateNameSpace(GetFirstSelected, NS) then
      begin
      S:= NS.NameForParsing;
      if IsFileExist(S)
        then begin if Viewer.Open(S) then UpdateView(true); end
        else begin Viewer.Open(''); UpdateView(false); end;
      end;
end;

procedure TFormView.chkModeDetectClick(Sender: TObject);
begin
  if not FLoad then
    Viewer.ModeDetect:= chkModeDetect.Checked;
end;

procedure TFormView.chkModeTextClick(Sender: TObject);
begin
  if not FLoad then
    Viewer.Mode:= vmodeText;
end;

procedure TFormView.chkModeBinaryClick(Sender: TObject);
begin
  if not FLoad then
    Viewer.Mode:= vmodeBinary;
end;

procedure TFormView.chkModeHexClick(Sender: TObject);
begin
  if not FLoad then
    Viewer.Mode:= vmodeHex;
end;

procedure TFormView.chkModeMediaClick(Sender: TObject);
begin
  if not FLoad then
    Viewer.Mode:= vmodeMedia;
end;

procedure TFormView.chkModeWebClick(Sender: TObject);
begin
  if not FLoad then
    Viewer.Mode:= vmodeWeb;
end;

procedure TFormView.chkModeUnicodeClick(Sender: TObject);
begin
  if not FLoad then
    Viewer.Mode:= vmodeUnicode;
end;

procedure TFormView.UpdateView(en: boolean);
begin
  FLoad:= true;
  chkModeDetect.Checked:= Viewer.ModeDetect;
  chkModeText.Checked:= Viewer.Mode=vmodeText;
  chkModeBinary.Checked:= Viewer.Mode=vmodeBinary;
  chkModeHex.Checked:= Viewer.Mode=vmodeHex;
  chkModeMedia.Checked:= Viewer.Mode=vmodeMedia;
  chkModeWeb.Checked:= Viewer.Mode=vmodeWeb;
  chkModeUnicode.Checked:= Viewer.Mode=vmodeUnicode;

  chkModeText.Enabled:= en;
  chkModeBinary.Enabled:= en;
  chkModeHex.Enabled:= en;
  chkModeMedia.Enabled:= en;
  chkModeWeb.Enabled:= en;
  chkModeUnicode.Enabled:= en;
  FLoad:= false;
end;

procedure TFormView.FormShow(Sender: TObject);
var
  fn: WideString;
begin
  UpdateView(false);

  fn:= SExtractFilePath(SParamStr(0))+'Files';
  if IsDirExist(fn) then
    begin
    LVEx.RootFolder:= rfCustom;
    LVEx.RootFolderCustomPath:= fn;
    end;
end;

end.
