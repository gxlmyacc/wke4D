program BallPool;

uses
  SysUtils,
  Forms,
  WkeImportDefs,
  WkeFrm in '..\..\Public\WkeFrm.pas' {WkeForm},
  WkeIntf in '..\..\Public\WkeIntf.pas',
  WkeTypes in '..\..\Public\WkeTypes.pas';

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
  MainForm.LoadFile(ExtractFilePath(ParamStr(0)) +'BallPool/Ball Pool.htm');
  Application.Run;
end.
