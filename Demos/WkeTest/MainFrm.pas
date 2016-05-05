unit MainFrm;

interface
uses
  Windows, SysUtils, Classes, Controls, Forms,
  Dialogs, StdCtrls, WkeIntf, ComCtrls, WkeCtl, WkeGCtl,
  SynHighlighterHtml, XPMan, Placemnt, WkeTypes,
  SynMemo, ExtCtrls, SynEditHighlighter, SynEdit, WkeFrm, Menus;

type
  THtmlWkeContorl = TWkeControl;
  //THtmlWkeContorl = TWkeGraphicControl;
  
  TMainForm = class(TForm)
    Panel1: TPanel;
    Button1: TButton;
    EdtFilePath: TEdit;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Splitter1: TSplitter;
    Panel2: TPanel;
    Panel3: TPanel;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    XPManifest1: TXPManifest;
    SynMemo1: TSynMemo;
    SynHTMLSyn1: TSynHTMLSyn;
    Button5: TButton;
    Button6: TButton;
    btnBrw: TButton;
    dlgOpen: TOpenDialog;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    Button10: TButton;
    FormStorage: TFormStorage;
    pmContext: TPopupMenu;
    miCopy: TMenuItem;
    miPaste: TMenuItem;
    miCut: TMenuItem;
    miRedo: TMenuItem;
    miUndo: TMenuItem;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure SynMemo1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Button5Click(Sender: TObject);
    procedure EdtFilePathKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Button6Click(Sender: TObject);
    procedure btnBrwClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure miCopyClick(Sender: TObject);
    procedure miPasteClick(Sender: TObject);
    procedure miCutClick(Sender: TObject);
    procedure miRedoClick(Sender: TObject);
    procedure miUndoClick(Sender: TObject);
  private
    Html2: TWkeControl;
    html: THtmlWkeContorl;
    tick: Cardinal;
    FPopupWindow: TWkeForm;
  public
     procedure OnLoadingFinish(const AWebView: IWkeWebView; const url: wkeString;
       result: wkeLoadingResult; const failedReason: wkeString);
     procedure DoContextMenu(const AWebView: IWkeWebView; x, y: Integer; flags: UINT);
  end;

var
  MainForm: TMainForm;

implementation
{$R *.dfm}

uses
  ShellAPI, StrUtils;

procedure TMainForm.Button1Click(Sender: TObject);
var
  sFile: string;
begin
  if Html = nil then
  begin
    Html := THtmlWkeContorl.Create(Panel1);
    Html.Parent := Panel1;
    //Html.Align := alClient;
    html.SetBounds(20, 20, Panel1.Width-40, Panel1.Height-40);
    html.Anchors := [akLeft, akTop, akRight, akBottom];
    Html.WebView.OnLoadingFinish := OnLoadingFinish;
    Html.WebView.OnContextMenu := DoContextMenu;
  end;

  sFile := Trim(EdtFilePath.Text);
  if Pos(':', sFile) <= 0 then
    sFile := ExtractFilePath(ParamStr(0)) + sFile;

  Html.Visible := True;

  tick := GetTickCount;
  if AnsiStartsText('http:', sFile) or AnsiStartsText('https:', sFile) then
    Html.WebView.LoadURL(sFile)
  else
    Html.WebView.Load(sFile);
end;

procedure TMainForm.Button2Click(Sender: TObject);
var
  sFile: string;
begin
  if Html2 = nil then
  begin
    Html2 := TWkeControl.Create(Panel2);
    Html2.Parent := Panel2;
    Html2.Align := alClient;
    Html2.Visible := True;
    Html2.WebView.OnLoadingFinish := OnLoadingFinish;
  end;

  sFile := ChangeFileExt(ParamStr(0), '.html');
  SynMemo1.Lines.SaveToFile(sFile);

  tick := GetTickCount;
  Html2.WebView.LoadFile(sFile);
end;

procedure TMainForm.Button3Click(Sender: TObject);
begin
  ShellExecute(handle, nil,pchar(ChangeFileExt(ParamStr(0), '.html')),nil,nil, SW_shownormal);
end;

procedure TMainForm.SynMemo1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_F9) then
    Button2.Click
  else
  if (Key = VK_F8) then
    Button3.Click
  else
  if (Key = VK_F7) then
    Button5.Click;
end;

procedure TMainForm.Button5Click(Sender: TObject);
begin
  ShellExecute(handle, PChar('Open'),pchar('explorer.exe'),
    PChar(ExtractFileDir(ParamStr(0))), nil, SW_shownormal);
end;

procedure TMainForm.EdtFilePathKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_F5) or (Key = VK_RETURN) then
    Button1.Click
  else
  if (Key = VK_F8) then
    Button4.Click;
end;

procedure TMainForm.Button6Click(Sender: TObject);
const
  const_template =
  '<html>'#13#10 +
  ' <head>'#13#10 +
  '  <meta http-equiv="Content-Type" content="text/html; charset=gbk">'#13#10 +
  '  '#13#10 +
  '  <style type="text\css">'#13#10 +
  '  <!--'#13#10 +
  '   '#13#10 +
  '  -->'#13#10 +
  '  </style>'#13#10 +
  ' </head>'#13#10 +
  ' <body style="">'#13#10 +
  '  '#13#10 +
  ' </body>'#13#10 +
  '</html>';
begin
  SynMemo1.Lines.Text := const_template;
end;

procedure TMainForm.btnBrwClick(Sender: TObject);
begin
  if AnsiStartsText('http:', EdtFilePath.Text)
    or AnsiStartsText('https:', EdtFilePath.Text) then
  begin

  end
  else
    dlgOpen.FileName := EdtFilePath.Text;
  if not dlgOpen.Execute then
    Exit;

  EdtFilePath.Text := dlgOpen.FileName;
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  sFile: string;
begin
  FormStorage.IniFileName := ChangeFileExt(ParamStr(0), '.ini');
  Self.DoubleBuffered := True;
  
  sFile := ChangeFileExt(ParamStr(0), '.html');
  if FileExists(sFile) then
    SynMemo1.Lines.LoadFromFile(sFile);
end;

procedure TMainForm.Button7Click(Sender: TObject);
begin
  if FPopupWindow <> nil then
    FreeAndNil(FPopupWindow);
    
  FPopupWindow := TWkeForm.Create(Application);
  FPopupWindow.WebView.LoadFile(EdtFilePath.Text);

  FPopupWindow.Show();
end;

procedure TMainForm.Button8Click(Sender: TObject);
begin
  if FPopupWindow <> nil then
    FreeAndNil(FPopupWindow);
end;

procedure TMainForm.Button4Click(Sender: TObject);
begin
  if Html <> nil then
    Html.WebView.GoBack;
end;

procedure TMainForm.Button9Click(Sender: TObject);
begin
  if Html <> nil then
    Html.WebView.GoForward;
end;

procedure TMainForm.Button10Click(Sender: TObject);
begin
  if Html <> nil then
    Html.WebView.StopLoading;
end;

procedure TMainForm.OnLoadingFinish(const AWebView: IWkeWebView;
  const url: wkeString; result: wkeLoadingResult;
  const failedReason: wkeString);
begin
  Caption := 'Wke “≥√Ê≤‚ ‘£∫' + IntToStr(GetTickCount - tick) + ' ms';
end;

procedure TMainForm.DoContextMenu(const AWebView: IWkeWebView; x, y: Integer;
  flags: UINT);
var
  pt: TPoint;
begin
  miCopy.Enabled := AWebView.EditerCanCopy;
  miPaste.Enabled := AWebView.EditerCanPaste;
  miCut.Enabled := AWebView.EditerCanCut;
  miUndo.Enabled := AWebView.EditerCanUndo;
  miRedo.Enabled := AWebView.EditerCanRedo;

  pt := html.ClientToScreen(Point(x, y));
  pmContext.Popup(pt.X, pt.Y);
end;

procedure TMainForm.miCopyClick(Sender: TObject);
begin
  if Html <> nil then
    Html.WebView.EditerCopy;
end;

procedure TMainForm.miPasteClick(Sender: TObject);
begin
  if Html <> nil then
    Html.WebView.EditerPaste;
end;

procedure TMainForm.miCutClick(Sender: TObject);
begin
  if Html <> nil then
    Html.WebView.EditerCut;
end;

procedure TMainForm.miRedoClick(Sender: TObject);
begin
  if Html <> nil then
    Html.WebView.EditerRedo;
end;

procedure TMainForm.miUndoClick(Sender: TObject);
begin
  if Html <> nil then
    Html.WebView.EditerUndo;
end;

end.
