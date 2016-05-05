program WkeTest;


uses
  SysUtils,
  Classes,
  Forms,
  WkeImportDefs,
  WkeIntf,
  MainFrm in 'MainFrm.pas' {MainForm},
  WkeFrm in '..\..\Public\WkeFrm.pas' {WkeForm},
  WkeCtl in '..\..\Public\WkeCtl.pas',
  WkeGCtl in '..\..\Public\WkeGCtl.pas';

{$R *.res}

begin
  LoadWke4D(ExtractFilePath(ParamStr(0)) + DLL_Wke4D);
  Wke.DriverName := ExtractFilePath(ParamStr(0)) + DLL_Wke;

  Application.Initialize;
  Application.Title := 'WkeTest';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
