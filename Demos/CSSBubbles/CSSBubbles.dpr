program CSSBubbles;

uses
  SysUtils,
  Forms,
  WkeImportDefs,
  WkeFrm in '..\..\Public\WkeFrm.pas' {WkeForm},
  WkeIntf in '..\..\Public\WkeIntf.pas';

{$R *.res}

var
  MainForm: TWkeForm;

begin
  LoadWke4D(ExtractFilePath(ParamStr(0))+DLL_Wke4D);
  
  Application.Initialize;
  Application.CreateForm(TWkeForm, MainForm);
  MainForm.BorderStyle := bsNone;
  MainForm.WindowState := wsMaximized;
  MainForm.IsTransparent := True;
  MainForm.LoadFile(ExtractFilePath(ParamStr(0)) +'CSSBubbles/CSS Bubbles.htm');
  Application.Run;
end.
