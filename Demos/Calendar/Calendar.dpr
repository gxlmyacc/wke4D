program Calendar;

uses
  SysUtils,
  WkeImportDefs,
  WkeIntf,
  Forms,
  WkeFrm in '..\..\Public\WkeFrm.pas' {WkeForm};

{$R *.res}

var
  MainForm: TWkeForm;

begin
  LoadWke4D(ExtractFilePath(ParamStr(0))+DLL_Wke4D);
  
  Application.Initialize;
  Application.CreateForm(TWkeForm, MainForm);
  MainForm.BorderStyle := bsNone;
  MainForm.Width := 800;
  MainForm.Height := 500;
  //MainForm.Position := poDesktopCenter;
  MainForm.IsTransparent := True;
  MainForm.LoadFile(ExtractFilePath(ParamStr(0)) +'Calendar/calendar.html');
  Application.Run;
end.
