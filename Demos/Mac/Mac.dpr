program Mac;

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
  MainForm.WindowState := wsMaximized;
  MainForm.IsTransparent := True;
  MainForm.LoadFile(ExtractFilePath(ParamStr(0)) +'MAC/mac-osx-lion.html');
  Application.Run;
end.
