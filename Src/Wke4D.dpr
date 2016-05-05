library Wke4D;

uses
  ShareFastMM in '..\Public\ShareFastMM.pas',
  {$IF CompilerVersion <= 18.5}
  Fastcode,
  FastMove,
  {$IFEND}
  f_DebugIntf in 'f_DebugIntf.pas',
  ObjAutoEx in 'ObjAutoEx.pas',
  WkeTypes in '..\Public\WkeTypes.pas',
  WkeApi in 'WkeApi.pas',
  WkeIntf in '..\Public\WkeIntf.pas',
  WkeImpl in 'WkeImpl.pas',
  WkeWebView in 'WkeWebView.pas',
  WkeJs in 'WkeJs.pas',
  WkeHash in 'WkeHash.pas',
  WkeExportDefs in 'WkeExportDefs.pas',
  WkeImportDefs in '..\Public\WkeImportDefs.pas';

{$R *.res}

begin
end.
