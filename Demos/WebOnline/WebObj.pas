unit WebObj;

interface

uses
  WkeIntf, WkeTypes, Windows, SysUtils;

type
  TTest = class(TWkeRttiObject)
  private
    FName: WideString;
  public
    constructor Create(const AName: WideString);
    destructor Destroy; override;
  public
    function  GetName: WideString;
    procedure SetName(const Value: WideString);

    procedure ShowMessage(const Msg: WideString);
  published
    property Name: WideString read GetName write SetName;
  end;

function js_malert(es_:jsExecState):jsValue;
function js_nalert(es_:jsExecState):jsValue;

function js_getTestCount(es_:jsExecState):jsValue;
function js_setTestCount( es_:jsExecState):jsValue;
function Test: TTest;

implementation

var
  varTestCount:integer;
  varTest: TTest;

function Test: TTest;
begin
  if varTest = nil then
    varTest := TTest.Create('Ò»¸öÒ³Ãæ¶ÔÏó');
  Result := varTest;
end;

function js_malert(es_:jsExecState):jsValue;
var
  str:WideString;
  arg: IWkeJsValue;
  es: IWkeJsExecState;
begin
  es := Wke.CreateExecState(es_);
  if es.ArgCount <= 0 then
  begin
    result:= es.jsUndefined.Value;
    Exit;
  end;

  arg := es.Arg[0];
  str:= arg.ToStringW;
  if arg.IsString then
  begin
    MessageBoxW(0, PWideChar('malert:jsIsString:'+str), '²âÊÔ', MB_OK);
  end
  else
  if arg.IsUndefined then
  begin
    MessageBox(0, PChar('malert:jsIsUndefined'), '²âÊÔ', MB_OK);
  end
  else
    MessageBoxW(0, PWideChar('malert:'+str), '²âÊÔ', MB_OK);

  result:= es.jsUndefined.Value;
end;

function js_nalert(es_:jsExecState):jsValue;
var
  es: IWkeJsExecState;
begin
  es := Wke.CreateExecState(es_);

  MessageBox(0, PChar('nalert:ok('+inttostr(es.ArgCount)+')'), '²âÊÔ', MB_OK);
  result:= es.jsUndefined.Value;
  Wke.Terminate;
end;


function js_getTestCount(es_:jsExecState):jsValue;
var
  es: IWkeJsExecState;
begin
  es := Wke.CreateExecState(es_);
  MessageBox(0, PChar('js_getTestCount:varTestCount:'+inttostr(varTestCount)), '²âÊÔ', MB_OK);
  
  Result := es.jsInt(varTestCount).Value;
end;

function js_setTestCount(es_:jsExecState):jsValue;
var
  es: IWkeJsExecState;
begin
  es := Wke.CreateExecState(es_);
  varTestCount := es.Arg[0].ToInt;
  MessageBox(0, PChar('js_setTestCount:varTestCount:'+inttostr(varTestCount)), '²âÊÔ', MB_OK);
  result:= es.jsUndefined.Value;
end;

{ TTest }

constructor TTest.Create(const AName: WideString);
begin
  FName := AName;
end;

destructor TTest.Destroy;
begin
  inherited;
end;

function TTest.GetName: WideString;
begin
  Result := FName;
end;

procedure TTest.SetName(const Value: WideString);
begin
  FName := Value;
end;

procedure TTest.ShowMessage(const Msg: WideString);
begin
  MessageBoxW(0, PWideChar('[TTest.ShowMessage]['+FName+'] ' + Msg), '²âÊÔ', MB_OK);
end;

initialization

finalization
  if varTest <> nil then
    varTest.Free;

end.
