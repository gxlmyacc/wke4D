program WebOnline;

uses
  {$IF CompilerVersion > 15.0}
  SimpleShareMem,
  {$ELSE}
  FastMM4,
  Fastcode,
  FastMove,
  {$IFEND}
  SysUtils,
  WkeImportDefs,
  WkeIntf,
  WkeTypes,
  WebObj in 'WebObj.pas';

{$R *.res}
var
  Main: IWkeWindow;

begin
  {$IF CompilerVersion > 15.0 }
  ReportMemoryLeaksOnShutdown := True;
  {$IFEND}
  LoadWke4D(ExtractFilePath(ParamStr(0))+DLL_Wke4D);
  wke.BindFunction('malert', @js_malert, 1);
  wke.BindFunction('nalert', @js_nalert, 0);
  wke.BindGetter('testCount', @js_getTestCount);
  wke.BindSetter('testCount', @js_setTestCount);

  Main := Wke.CreateWindow(WKE_WINDOW_TYPE_TRANSPARENT, 0, 0, 0, 800, 600);
  Main.LoadFile(ExtractFilePath(ParamStr(0)) +'WebOnline/index.html');
  Main.Js.BindObject('TestObj', Test);
  Main.ShowWindow;
  Wke.RunAppclition(Main.WindowHandle);
  Main := nil;
end.
