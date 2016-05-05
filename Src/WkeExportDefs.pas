unit WkeExportDefs;

interface

uses
  Windows, WkeImportDefs, WkeIntf;

var
  varWkeExports: TWkeExports;
  
procedure _RegWkeClass;
procedure _UnregWkeClass;
procedure _InitWkeExports(const Api: PPWkeExports; const Instance: HINST);
procedure _FinalWkeExports(const Api: PPWkeExports; const Instance: HINST);

function  __Wke: PIWke;

implementation

uses
  WkeImpl;

var
  varWC: TWndClassA;
  varWke: IWke;
  varDestroying: Boolean;

procedure _RegWkeClass;
begin
  varWkeExports.Flags := 'WA';
  varWkeExports.Instance := SysInit.HInstance;
  varWkeExports.InitWkeExports := _InitWkeExports;
  varWkeExports.FinalWkeExports := _FinalWkeExports;
  varWkeExports.FuncsCount := WkeExports_FuncsCount;
  SetLength(varWkeExports.Funcs, WkeExports_FuncsCount);
  varWkeExports.Funcs[FuncIdx_Wke] := @__Wke;

  FillChar(varWC, SizeOf(varWC), #0);
  varWC.lpszClassName := CLASSNAME_WKE;
  varWC.style         := CS_GLOBALCLASS;
  varWC.hInstance     := SysInit.HInstance;
  varWC.lpfnWndProc   := @varWkeExports;

  if Windows.RegisterClassA(varWC)=0 then
    Halt;
end;

procedure _UnregWkeClass;
begin
  Windows.UnregisterClassA(CLASSNAME_WKE, SysInit.HInstance);
  WkeClearRef;
  varWkeExports.Instance := 0;
  varWkeExports.InitWkeExports := nil;
  varWkeExports.FinalWkeExports := nil;
  varWkeExports.FuncsCount := 0;
  SetLength(varWkeExports.Funcs, 0);
end;

procedure _InitWkeExports(const Api: PPWkeExports; const Instance: HINST);
begin

end;

procedure _FinalWkeExports(const Api: PPWkeExports; const Instance: HINST);
begin

end;

function  __Wke: PIWke;
begin
  if varDestroying then
  begin
    Result := nil;
    Exit;
  end;
  if varWke = nil then
    varWke := TWke.Create;
  Result := @varWke;
end;

initialization
  _RegWkeClass;

finalization
  varDestroying := True;
  varWke := nil;
  _UnregWkeClass;

end.
