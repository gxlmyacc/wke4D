unit WkeImpl;

interface

uses
  SysUtils, Windows, Classes, Messages, WkeTypes, WkeIntf, WkeApi, TypInfo;

type
  TWkeFileSystem = class(TInterfacedObject, IWkeFileSystem)
  private
    fs: TFileStream;
  public
    destructor Destroy; override;
    
    function Open(const path: PUtf8): Boolean;
    procedure Close;
    
    function  Size: Cardinal;
    function  Read(buffer: Pointer; size: Cardinal): Integer;
    function  Seek(offset: Integer; origin: Integer): Integer;
  end;
  
  TWke = class(TInterfacedObject, IWke)
  private
    FTerminate: Boolean;
    FApi: TWkeAPI;
    FSettings: wkeSettings;
    FGlobalObjects: IWkeJsObjectList;
    FOnGetFileSystem: TWkeGetFileSystemProc;
    FOnGetWkeWebBase: TWkeGetWkeWebBaseProc;
    FData1: Pointer;
    FData2: Pointer;
  private
    function GetDriverName: WideString;
    function GetSettings: wkeSettings;
    function GetWkeVersion: WideString;
    function GetGlobalObjects(): IWkeJsObjectList;
    function GetData1: Pointer;
    function GetData2: Pointer;
    function GetOnGetFileSystem: TWkeGetFileSystemProc;
    function GetOnGetWkeWebBase: TWkeGetWkeWebBaseProc;
    procedure SetDriverName(const Value: WideString);
    procedure SetSettings(const Value: wkeSettings);
    procedure SetData1(const Value: Pointer);
    procedure SetData2(const Value: Pointer);
    procedure SetOnGetFileSystem(const Value: TWkeGetFileSystemProc);
    procedure SetOnGetWkeWebBase(const Value: TWkeGetWkeWebBaseProc);
    
    procedure LoadAPI;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Configure(const settings: wkeSettings);

    function CreateWebView(const AThis: IWkeWebBase): IWkeWebView; overload;
    function CreateWebView(const AThis: IWkeWebBase; const AWebView: TWebView;
      const AOwnView: Boolean = True): IWkeWebView; overload;
    function CreateWebView(const AFilter: WideString = '';
      const ATag: Pointer = nil): IWkeWebView; overload;
    function CreateWindow(type_: wkeWindowType; parent: HWND; x, y,
      width, height: Integer): IWkeWindow;

    function  RunAppclition(const MainWnd: HWND): Integer;
    procedure ProcessMessages;
    procedure Terminate;
        
    function GetString(const str: wkeString): PUtf8;
    function GetStringW(const str: wkeString): Pwchar_t;

    function CreateExecState(const AExecState: JsExecState): IWkeJsExecState;
    function CreateJsValue(const AExecState: JsExecState): IWkeJsValue; overload;
    function CreateJsValue(const AExecState: JsExecState; const AValue: jsValue): IWkeJsValue; overload;

    function CreateFileSystem(const path: PUtf8): IWkeFileSystem;
    function CreateDefaultFileSystem(): IWkeFileSystem;

    procedure BindFunction(const name: WideString; fn: jsNativeFunction; argCount: Integer); overload;
    procedure BindFunction(es: jsExecState; const name: WideString; fn: jsNativeFunction; argCount: Integer); overload;
    procedure UnbindFunction(const name: WideString); overload;
    procedure UnbindFunction(es: jsExecState; const name: WideString); overload;
    procedure BindGetter(const name: WideString; fn: jsNativeFunction);
    procedure BindSetter(const name: WideString; fn: jsNativeFunction);

    procedure BindObject(es: jsExecState; const objName: WideString; obj: TObject);
    procedure UnbindObject(es: jsExecState; const objName: WideString);

    function CreateJsObject(es: jsExecState; obj: TObject): jsValue;

    property DriverName: WideString read GetDriverName write SetDriverName;
    property Settings: wkeSettings read GetSettings write SetSettings;
    property WkeVersion: WideString read GetWkeVersion;
    property GlobalObjects: IWkeJsObjectList read GetGlobalObjects;
    property Data1: Pointer read GetData1 write SetData1;
    property Data2: Pointer read GetData2 write SetData2;

    property OnGetFileSystem: TWkeGetFileSystemProc read GetOnGetFileSystem write SetOnGetFileSystem;
    property OnGetWkeWebBase: TWkeGetWkeWebBaseProc read GetOnGetWkeWebBase write SetOnGetWkeWebBase;
  end;


function  FILE_OPEN(const path: PUtf8): Pointer; cdecl;
procedure FILE_CLOSE(handle: Pointer); cdecl;
function  FILE_SIZE(handle: Pointer): size_t; cdecl;
function  FILE_READ(handle: Pointer; buffer: Pointer; size: size_t): Integer; cdecl;
function  FILE_SEEK(handle: Pointer; offset: Integer; origin: Integer): Integer; cdecl;

function _WindowCommand(es_: jsExecState): jsValue;
function _CallNativeFunction(es_: jsExecState): jsValue;
function _CallNativeObjectMethod(es_: jsExecState): jsValue;
function _GetNativeObjectProp(es_: jsExecState): jsValue;
function _SetNativeObjectProp(es_: jsExecState): jsValue;

function _CreateFunctionStr(es: jsExecState; const name: WideString; fn: jsNativeFunction; argCount: Integer): string;
function _CreateObjectStr(es: jsExecState; obj: TObject): string;
function _CreateObject(es: jsExecState; obj: TObject): jsValue;

const
  ole32    = 'ole32.dll';
function OleInitialize(pwReserved: Pointer): HResult; stdcall; external ole32 name 'OleInitialize';
procedure OleUninitialize; stdcall; external ole32 name 'OleUninitialize';
function CoInitialize(pvReserved: Pointer): HResult; stdcall; external ole32 name 'CoInitialize';
procedure CoUninitialize; stdcall; external ole32 name 'CoUninitialize';
 

implementation

uses
  WkeWebView, WkeJs, Variants, ObjAutoEx, WkeExportDefs;

var
  varWkeDestorying: Boolean = False;

function FILE_OPEN(const path: PUtf8): Pointer; cdecl;
var
  fs: IWkeFileSystem;
begin
  if varWkeDestorying then
  begin
    Result := nil;
    Exit;
  end;
  fs := __Wke.CreateFileSystem(path);
  if fs = nil then
  begin
    Result := nil;
    Exit;
  end;
  fs._AddRef;
  Result := Pointer(fs);
end;

procedure FILE_CLOSE(handle: Pointer); cdecl;
var
  fs: IWkeFileSystem;
begin
  try
    fs := IWkeFileSystem(handle);
    fs.Close;
    fs._Release;
    fs := nil;
  except
    on E: Exception do
    begin
      Trace('[FILE_CLOSE]'+E.Message);
    end
  end;
end;
function FILE_SIZE(handle: Pointer): size_t; cdecl;
var
  fs: IWkeFileSystem;
begin
  fs := IWkeFileSystem(handle);
  Result := fs.Size;
end;
function FILE_READ(handle: Pointer; buffer: Pointer; size: size_t): Integer; cdecl;
var
  fs: IWkeFileSystem;
begin
  Result := 0;
  try
    fs := IWkeFileSystem(handle);
    Result := fs.read(buffer, size)
  except
    on E: Exception do
    begin
      Trace('[FILE_READ]'+E.Message);
    end
  end;
end;
function FILE_SEEK(handle: Pointer; offset: Integer; origin: Integer): Integer; cdecl;
var
  fs: IWkeFileSystem;
begin
  fs := IWkeFileSystem(handle);
  Result := fs.Seek(offset, origin)
end;

function _WindowCommand(es_:jsExecState):jsValue;
var
  es: IWkeJsExecState;
  sCmd: string;
  pView: TWebView;
  LWebView: TWkeWebView;
begin
  Result := WAPI.jsUndefined;
  es := Wke.CreateExecState(es_);
  if es.ArgCount <> 2 then
    Exit;
  {$IF CompilerVersion > 18.5}
  sCmd := es.Arg[0].ToStringW;
  {$ELSE}
  sCmd := es.Arg[0].ToStringA;
  {$IFEND}
  pView := WAPI.jsGetWebView(es_);

  LWebView := WAPI.wkeGetUserData(pView);
  if LWebView = nil then
    Exit;
  if not IsWindow(LWebView.This.GetHwnd) then
    Exit;
  if sCmd = 'min' then
    PostMessage(LWebView.This.GetHwnd, WM_SYSCOMMAND, SC_MINIMIZE, 0)
  else
  if sCmd = 'max' then
    PostMessage(LWebView.This.GetHwnd, WM_SYSCOMMAND, SC_MAXIMIZE, 0)
  else
  if sCmd = 'restore' then
    PostMessage(LWebView.This.GetHwnd, WM_SYSCOMMAND, SC_RESTORE, 0)
  else
  if sCmd = 'close' then
    PostMessage(LWebView.This.GetHwnd, WM_SYSCOMMAND, SC_CLOSE, 0)
  else
  if not IsZoomed(LWebView.This.GetHwnd) then
  begin
    if sCmd = 'drag' then
    begin

      ReleaseCapture;
      PostMessage(LWebView.This.GetHwnd, WM_NCLBUTTONDOWN, HTCAPTION, 0);
    end
    else
    if sCmd = 'hitTopleft' then
    begin
      ReleaseCapture;
      PostMessage(LWebView.This.GetHwnd, WM_NCLBUTTONDOWN, HTTOPLEFT, 0);
    end
    else
    if sCmd = 'hitLeft' then
    begin
      ReleaseCapture;
      PostMessage(LWebView.This.GetHwnd, WM_NCLBUTTONDOWN, HTLEFT, 0)
    end
    else
    if sCmd = 'hitBottomleft' then
    begin
      ReleaseCapture;
      PostMessage(LWebView.This.GetHwnd, WM_NCLBUTTONDOWN, HTBOTTOMLEFT, 0)
    end
    else
    if sCmd = 'hitTop' then
    begin
      ReleaseCapture;
      PostMessage(LWebView.This.GetHwnd, WM_NCLBUTTONDOWN, HTTOP, 0)
    end
    else
    if sCmd = 'hitBottom' then
    begin
      ReleaseCapture;
      PostMessage(LWebView.This.GetHwnd, WM_NCLBUTTONDOWN, HTBOTTOM, 0)
    end
    else
    if sCmd = 'hitTopright' then
    begin
      ReleaseCapture;
      PostMessage(LWebView.This.GetHwnd, WM_NCLBUTTONDOWN, HTTOPRIGHT, 0)
    end
    else
    if sCmd = 'hitRight' then
    begin
      ReleaseCapture;
      PostMessage(LWebView.This.GetHwnd, WM_NCLBUTTONDOWN, HTRIGHT, 0)
    end
    else
    if sCmd = 'hitBottomright' then
    begin
      ReleaseCapture;
      PostMessage(LWebView.This.GetHwnd, WM_NCLBUTTONDOWN, HTBOTTOMRIGHT, 0);
    end;
  end;
end;

function _CallNativeFunction(es_:jsExecState):jsValue;
var
  es: IWkeJsExecState;
  fn: jsNativeFunction;
begin
  Result := WAPI.jsUndefined;
  es := Wke.CreateExecState(es_);
  if es.ArgCount < 1 then
  begin
    Trace('[_CallNativeFunction]'+Format('参数个数[%d]小于1个！', [es.ArgCount]));
    Exit;
  end;
  @fn := @jsNativeFunction(es.Arg[es.ArgCount - 1].ToInt);
  try
    Result := fn(es_);
  except
    on E: Exception do
    begin
      Trace('[_CallNativeFunction]'+E.Message);
    end
  end;
end;

function _CallNativeObjectMethod(es_:jsExecState):jsValue;
var
  es: IWkeJsExecState;
  obj: TObject;
  LMethodInfoHeader: PMethodInfoHeader;
  rVar: OleVariant;
  LParams: array of Variant;
  i: Integer;
  vValue: OleVariant;
  sError: string;
  LReturnInfo: PReturnInfo;
  LVarData: PVarData;
  LObj: TObject;
begin
  Result := WAPI.jsUndefined;

  es := Wke.CreateExecState(es_);

  if es.ArgCount < 2 then
  begin
    Trace('[_CallNativeObjectMethod]'+Format('参数个数[%d]小于2个！', [es.ArgCount]));
    Exit;
  end;

  obj := TObject(es.Arg[0].ToInt);
  LMethodInfoHeader := PMethodInfoHeader(es.Arg[1].ToInt);

  SetLength(LParams, es.ArgCount-2);
  for i := 2 to es.ArgCount-1  do
  begin
    if not J2V(es.ExecState, es.Arg[i].Value, vValue, sError) then
    begin
      Trace('[_CallNativeObjectMethod]'+Format('函数[%s]参数[%d]转换失败！', [LMethodInfoHeader.Name, i-1]));
      Exit;
    end;
   
    LParams[i-2] := vValue;
  end;

  LReturnInfo := GetReturnInfo(LMethodInfoHeader);

  rVar := ObjectInvoke(obj, LMethodInfoHeader, LParams);

  if (LReturnInfo <> nil) and (LReturnInfo.ReturnType <> nil)
    and (not VarIsNull(rVar)) then
  begin
    if LReturnInfo.ReturnType^.Kind = tkClass then
    begin
      LVarData := @rVar;
      LObj := LVarData^.VPointer;
      if LObj <> nil then
        Result := _CreateObject(es_, LObj);
    end
    else
    if not V2J(es_, rVar, Result, sError) then
    begin
      Trace('[_CallNativeObjectMethod]'+Format('函数[%s]返回值转换失败！', [LMethodInfoHeader.Name]));
      Exit;
    end;
  end;
end;

function _GetNativeObjectProp(es_:jsExecState):jsValue;
var
  es: IWkeJsExecState;
  obj: TObject;
  LPropInfo: PPropInfo;
  rVar: OleVariant;
  sError: string;
  LVarData: PVarData;
  LObj: TObject;
begin
  Result := WAPI.jsUndefined;
  
  es := Wke.CreateExecState(es_);

  if es.ArgCount < 2 then
  begin
    Trace('[_GetNativeObjectProp]'+Format('参数个数[%d]小于2个！', [es.ArgCount]));
    Exit;
  end;

  obj := TObject(es.Arg[0]);
  LPropInfo := PPropInfo(es.Arg[1]);
  {$WARNINGS OFF}
  rVar := GetPropValue(obj, LPropInfo.Name);
  {$WARNINGS ON}

  if (LPropInfo <> nil) and (not VarIsNull(rVar)) then
  begin
    if LPropInfo^.PropType^.Kind = tkClass then
    begin
      LVarData := @rVar;
      LObj := LVarData^.VPointer;
      if LObj <> nil then
        Result := _CreateObject(es_, LObj);
    end
    else
    if not V2J(es_, rVar, Result, sError) then
    begin
      Trace('[_GetNativeObjectProp]'+Format('属性[%s]返回值转换失败！', [LPropInfo.Name]));
      Exit;
    end;
  end;
end;

function _SetNativeObjectProp(es_:jsExecState):jsValue;
var
  es: IWkeJsExecState;
  obj: TObject;
  LPropInfo: PPropInfo;
  vValue: OleVariant;
  v: jsValue;
  sError: string;
begin
  Result := WAPI.jsUndefined;
  
  es := Wke.CreateExecState(es_);

  if es.ArgCount < 3 then
  begin
    Trace('[_SetNativeObjectProp]'+Format('参数个数[%d]小于3个！', [es.ArgCount]));
    Exit;
  end;

  obj := TObject(es.Arg[0]);
  LPropInfo := PPropInfo(es.Arg[1]);

  v := es.Arg[2].Value;
  if not J2V(es.ExecState, v, vValue, sError) then
  begin
    Trace('[_SetNativeObjectProp]'+Format('属性[%s]的值转换失败！', [LPropInfo.Name]));
    Exit;
  end;
  {$WARNINGS OFF}
  SetPropValue(obj, LPropInfo.Name, vValue);
  {$WARNINGS ON}
end;

function _CreateFunctionStr(es: jsExecState; const name: WideString; fn: jsNativeFunction; argCount: Integer): string;
var
  lsFunc: TStrings;
  sArgs: string;
  iArg: Integer;
begin
  sArgs := EmptyStr;
  for iArg := 0 to argCount-1 do
  begin
    sArgs := sArgs + ' arg' + IntToStr(iArg);
      
    if iArg < argCount-1 then
      sArgs := sArgs + ',';
  end;

  lsFunc := TStringList.Create;
  try
    lsFunc.Add(Format('function %s(%s) {', [name, sArgs]));

    if sArgs <> EmptyStr then
      sArgs := sArgs + ',';
      
    lsFunc.Add(Format('    return (function(%s method) {', [sArgs]));
    lsFunc.Add(Format('      return _CallNativeFunction%d(%s method)', [argCount+1, sArgs]));
    lsFunc.Add(Format('    })(%s %d);', [
      sArgs,                      //-->调用参数
      Integer(@fn)                //-->函数指针
    ]));
    lsFunc.Add(Format('}', []));

    //lsFunc.SaveToFile('D:\\func.js');

    Result := lsFunc.Text;
  finally
    lsFunc.Free;
  end;   
end;

function _CreateObjectStr(es: jsExecState; obj: TObject): string;
var
  LMethodInfoArray: TMethodInfoArray;
  LMethodInfoHeader, LGetMethod, LSetMethod: PMethodInfoHeader;
  LPropList: PPropList;
  LPropInfo: PPropInfo;
  lsObj: TStrings;
  iMethod, iArg, iArgCount, iPropCount, iProp: Integer;
  sArgs: string;
  pProp: Pointer;
begin
  lsObj := TStringList.Create;
  try
    lsObj.Add('function _CreateNativeObject_5A5DA85372EA() {');
    lsObj.Add('  var obj = {');
    lsObj.Add(Format('    className: "%s", ', [obj.ClassName]));
    lsObj.Add(Format('    instance: %d, ', [Integer(obj)]));

    LMethodInfoArray := GetMethods(obj.ClassType);

    //定义对象属性
    if obj.ClassInfo <> nil then
    begin
      iPropCount := TypInfo.GetPropList(obj, LPropList);
      try
        for iProp := 0 to iPropCount-1 do
        begin
          LPropInfo := LPropList[iProp];

          LGetMethod := nil;
          LSetMethod := nil;
          for iMethod := 0 to High(LMethodInfoArray) do
          begin
            LMethodInfoHeader := LMethodInfoArray[iMethod];
            if LPropInfo^.GetProc = LMethodInfoHeader.Addr then
            begin
              LGetMethod := LMethodInfoHeader;
            end;
            if LPropInfo^.SetProc = LMethodInfoHeader.Addr then
            begin
              LSetMethod := LMethodInfoHeader;
            end;
            if (LGetMethod<>nil) and (LSetMethod<>nil) then
              break;
          end;
          if LPropInfo^.GetProc <> nil then
          begin
            sArgs := EmptyStr;
            iArgCount := 0;
            pProp := LPropInfo;
            if LGetMethod <> nil then
            begin
              pProp := LGetMethod;
              iArgCount := GetParamCount(LGetMethod);
              for iArg := 0 to iArgCount-1 do
              begin
                sArgs := sArgs + ' arg' + IntToStr(iArg);
                if iArg < iArgCount-1 then
                  sArgs := sArgs + ',';
              end;
            end;
            lsObj.Add(Format('    get %s(%s) {', [LPropInfo.Name, sArgs]));
            if sArgs <> EmptyStr then
              sArgs := ',' + sArgs;
      
            lsObj.Add(Format('      return (function(obj, prop %s) {', [sArgs]));

            if LGetMethod = nil then
              lsObj.Add(Format('        return _GetNativeObjectProp2(obj, prop)', []))
            else
              lsObj.Add(Format('        return _CallNativeObjectMethod%d(obj, prop %s)', [iArgCount+2, sArgs]));

            lsObj.Add(Format('      })(%d, %d %s);', [
              Integer(obj),                //-->对象指针
              Integer(pProp),              //-->属性指针
              sArgs
            ]));

            lsObj.Add('    },');
          end;

          if LPropInfo^.SetProc <> nil then
          begin
            sArgs := EmptyStr;
            iArgCount := 0;
            pProp := LPropInfo;
            if LSetMethod <> nil then
            begin
              pProp := LSetMethod;
              iArgCount := GetParamCount(LSetMethod);
              for iArg := 0 to iArgCount-1 do
              begin
                sArgs := sArgs + ' arg' + IntToStr(iArg);
      
                if iArg < iArgCount-1 then
                  sArgs := sArgs + ',';
              end;
            end;
            
            lsObj.Add(Format('    set %s (%s) {', [LPropInfo.Name, sArgs]));

            if sArgs <> EmptyStr then
              sArgs := ',' + sArgs;

            lsObj.Add(Format('      (function(obj, prop %s) {', [sArgs]));

            if LGetMethod = nil then
              lsObj.Add(Format('        _SetNativeObjectProp3(obj, prop %s)', [sArgs]))
            else
              lsObj.Add(Format('        _CallNativeObjectMethod%d(obj, prop %s)', [iArgCount+2, sArgs]));

            lsObj.Add(Format('      })(%d, %d %s);', [
              Integer(obj),                //-->对象指针
              Integer(pProp),   //-->函数指针
              sArgs
            ]));

            lsObj.Add('    },');
          end;
        end;
      finally
        FreeMem(LPropList)
      end;
    end;

    if lsObj.Strings[lsObj.Count  - 1] = '    },' then
      lsObj.Strings[lsObj.Count  - 1] := '    }'; 

    lsObj.Add('  };');

    //定义对象方法
    for iMethod := 0 to High(LMethodInfoArray) do
    begin
      LMethodInfoHeader := LMethodInfoArray[iMethod];

      //函数参数
      sArgs := EmptyStr;
      iArgCount := GetParamCount(LMethodInfoHeader);
      for iArg := 0 to iArgCount-1 do
      begin
        sArgs := sArgs + ' arg' + IntToStr(iArg);
      
        if iArg < iArgCount-1 then
          sArgs := sArgs + ',';
      end;

      //定义函数头
      lsObj.Add(Format('  obj.%s = function(%s) {', [LMethodInfoHeader.Name, sArgs]));

      if sArgs <> EmptyStr then
        sArgs := ',' + sArgs;
      
      lsObj.Add(Format('    return (function(obj, method %s) {', [sArgs]));

      lsObj.Add(Format('      return _CallNativeObjectMethod%d(obj, method %s)', [iArgCount+2, sArgs]));

      lsObj.Add(Format('    })(%d, %d %s);', [
        Integer(obj),                //-->对象指针
        Integer(LMethodInfoHeader),  //-->函数指针
        sArgs                        //-->调用参数
      ]));

      lsObj.Add('  }');
    end;

    lsObj.Add('  return obj;');
    lsObj.Add('}');

   // lsObj.SaveToFile('C:\\123.js');

    Result := lsObj.Text;
  finally
    lsObj.Free;
  end;
end;

function _CreateObject(es: jsExecState; obj: TObject): jsValue;
var
  sObjStr: UnicodeString;
begin
  sObjStr := _CreateObjectStr(es, obj);

  sObjStr := sObjStr + sLineBreak +
    '_CreateNativeObject_5A5DA85372EA();';

  Result := WAPI.jsEvalW(es, PUnicodeChar(sObjStr));
end;

{ TWke }

constructor TWke.Create;
begin
  FApi := TWkeAPI.Create;
  WAPI := FApi;
  FGlobalObjects := TWkeJsObjectList.Create;
end;

function TWke.CreateWebView(const AThis: IWkeWebBase): IWkeWebView;
begin
  LoadAPI;
  Result := TWkeWebView.Create(AThis);
end;

function TWke.CreateWebView(const AThis: IWkeWebBase; const AWebView: TWebView;
  const AOwnView: Boolean): IWkeWebView;
begin
  LoadAPI;
  
  Result := TWkeWebView.Create(AThis, AWebView, AOwnView);
end;

destructor TWke.Destroy;
begin
  varWkeDestorying := True;
  FGlobalObjects := nil;

  WAPI := nil;
  if FApi <> nil then
  begin
    FApi.wkeSetFileSystem(nil, nil, nil, nil, nil);
    FreeAndNil(FApi);
  end;

  inherited;
end;

function TWke.GetDriverName: WideString;
begin
  Result := FApi.DriverFile;
end;

function TWke.GetWkeVersion: WideString;
begin
  LoadAPI;
  Result := UTF8ToWideString(FApi.wkeGetVersionString);
end;

procedure TWke.SetDriverName(const Value: WideString);
begin
  FApi.DriverFile := Value;
end;

function TWke.GetString(const str: wkeString): PUtf8;
begin
  LoadAPI;
  Result := FApi.wkeGetString(str);
end;

function TWke.GetStringW(const str: wkeString): Pwchar_t;
begin
  LoadAPI;
  Result := FApi.wkeGetStringW(str);
end;

procedure TWke.LoadAPI;
var
  i: Integer;
begin
  if varWkeDestorying then
    Exit;
  if not FApi.Loaded then
  begin
    FApi.LoadDLL();
    
    if @FApi.wkeSetFileSystem <> nil then
      FApi.wkeSetFileSystem(FILE_OPEN, FILE_CLOSE, FILE_SIZE, FILE_READ, FILE_SEEK);

    if @FApi.jsBindFunction <> nil then
    begin
      for i := 1 to 256 do
        FApi.jsBindFunction(PAnsiChar(AnsiString('_CallNativeFunction'+IntToStr(i))), @_CallNativeFunction, i);
      for i := 2 to 256 do
        FApi.jsBindFunction(PAnsiChar(AnsiString('_CallNativeObjectMethod'+IntToStr(i))), @_CallNativeObjectMethod, i);
      for i := 2 to 10 do
        FApi.jsBindFunction(PAnsiChar(AnsiString('_GetNativeObjectProp'+IntToStr(i))), @_GetNativeObjectProp, i);
      for i := 2 to 10 do
        FApi.jsBindFunction(PAnsiChar(AnsiString('_SetNativeObjectProp'+IntToStr(i))), @_SetNativeObjectProp, i);
      BindFunction('WindowCommand', @_WindowCommand, 1);
    end;
  end;
end;

function TWke.GetOnGetFileSystem: TWkeGetFileSystemProc;
begin
  Result := FOnGetFileSystem;
end;

procedure TWke.SetOnGetFileSystem(const Value: TWkeGetFileSystemProc);
begin
  FOnGetFileSystem := Value;
end;

function TWke.CreateDefaultFileSystem(): IWkeFileSystem;
begin
  LoadAPI;
  Result := TWkeFileSystem.Create;
end;

function TWke.CreateFileSystem(const path: PUtf8): IWkeFileSystem;
var
  bHandled: Boolean;
begin
  LoadAPI;
  Result := nil;

  if @FOnGetFileSystem <> nil then
  begin
    bHandled := False;
    Result := FOnGetFileSystem(path, bHandled);
    if bHandled then
      Exit;
  end;
  
  if Result = nil then
    Result := CreateDefaultFileSystem;

  if not Result.Open(path) then
    Result := nil;
end;

function TWke.CreateExecState(
  const AExecState: JsExecState): IWkeJsExecState;
begin
  LoadAPI;
  Result := TWkeJsExecState.Create(AExecState);
end;

function TWke.CreateJsValue(const AExecState: JsExecState): IWkeJsValue;
begin
  LoadAPI;
  Result := TWkeJsValue.Create(AExecState);
end;

function TWke.CreateJsValue(const AExecState: JsExecState;
  const AValue: jsValue): IWkeJsValue;
begin
  LoadAPI;
  Result := TWkeJsValue.Create(AExecState, AValue);
end;

procedure TWke.BindFunction(const name: WideString; fn: jsNativeFunction;
  argCount: Integer);
begin
  LoadAPI;
  GlobalFunction.AddObject(name+'='+IntToStr(argCount), TObject(@fn));
 // WAPI.jsBindFunction(PAnsiChar(AnsiString(name)), fn, argCount);
end;

procedure TWke.BindGetter(const name: WideString; fn: jsNativeFunction);
begin
  LoadAPI;
  WAPI.jsBindGetter(PAnsiChar(AnsiString(name)), fn);
end;

procedure TWke.BindSetter(const name: WideString; fn: jsNativeFunction);
begin
  LoadAPI;
  WAPI.jsBindSetter(PAnsiChar(AnsiString(name)), fn);
end;

procedure TWke.BindObject(es: jsExecState; const objName: WideString; obj: TObject);
var
  sObjStr: UnicodeString;
begin
  LoadAPI;
  sObjStr := _CreateObjectStr(es, obj);

  sObjStr := sObjStr + sLineBreak +
    Format('var %s = _CreateNativeObject_5A5DA85372EA();', [objName]);

  WAPI.jsEvalW(es, PUnicodeChar(sObjStr));
end;

procedure TWke.BindFunction(es: jsExecState; const name: WideString;
  fn: jsNativeFunction; argCount: Integer);
var
  sFuncStr: UnicodeString;
begin
  LoadAPI;
  //WAPI.jsBindFunction(PAnsiChar(AnsiString(name)), fn, argCount);
  
  sFuncStr := _CreateFunctionStr(es, name, fn, argCount);
  WAPI.jsEvalW(es, PUnicodeChar(sFuncStr));
end;

procedure TWke.UnbindObject(es: jsExecState; const objName: WideString);
begin
  {$IF CompilerVersion > 18.5  }
  WAPI.jsEvalW(es, PUnicodeChar(Format('%s = null;', [objName])));
  {$ELSE}
  WAPI.jsEvalW(es, PUnicodeChar(WideFormat('%s = null;', [objName])));
  {$IFEND}
end;

procedure TWke.UnbindFunction(es: jsExecState; const name: WideString);
begin
  //WAPI.jsBindFunction(PAnsiChar(AnsiString(name)), nil, 0);
  {$IF CompilerVersion > 18.5  }
  WAPI.jsEvalW(es, PUnicodeChar(Format('%s = null;', [name])));
  {$ELSE}
  WAPI.jsEvalW(es, PUnicodeChar(WideFormat('%s = null;', [name])));
  {$IFEND}
end;

function TWke.GetGlobalObjects: IWkeJsObjectList;
begin
  Result := FGlobalObjects;
end;

function TWke.GetData1: Pointer;
begin
  Result := FData1;
end;

function TWke.GetData2: Pointer;
begin
  Result := FData2;
end;

procedure TWke.SetData1(const Value: Pointer);
begin
  FData1 := Value;
end;

procedure TWke.SetData2(const Value: Pointer);
begin
  FData2 := Value;
end;

function TWke.GetOnGetWkeWebBase: TWkeGetWkeWebBaseProc;
begin
  Result := FOnGetWkeWebBase;
end;

procedure TWke.SetOnGetWkeWebBase(const Value: TWkeGetWkeWebBaseProc);
begin
  FOnGetWkeWebBase := Value;
end;

function TWke.CreateWebView(const AFilter: WideString;
  const ATag: Pointer): IWkeWebView;
var
  LWebBase: IWkeWebBase;
begin
  if @FOnGetWkeWebBase = nil then
    raise EWkeException.Create('OnGetWkeWebBase event not be assigned!');
  LWebBase := FOnGetWkeWebBase(AFilter, ATag);
  if LWebBase = nil then
    raise EWkeException.CreateFmt('OnGetWkeWebBase event Cannot find IWkeWebBase instance which match filter:%s!', [AFilter]);
  Result := CreateWebView(LWebBase);
end;

function TWke.CreateJsObject(es: jsExecState; obj: TObject): jsValue;
begin
  LoadAPI;
  Result := _CreateObject(es, obj)
end;

procedure TWke.UnbindFunction(const name: WideString);
var
  i: Integer;
begin
  i := GlobalFunction.IndexOfName(name);
  if i > 0 then
    GlobalFunction.Delete(i);
end;

function TWke.GetSettings: wkeSettings;
begin
  Result := FSettings;
end;

procedure TWke.SetSettings(const Value: wkeSettings);
begin
  FSettings := Value;
  WAPISettings := @FSettings;
end;

procedure TWke.Configure(const settings: wkeSettings);
begin
  LoadAPI;
  WAPI.wkeConfigure(@settings);
end;

function TWke.CreateWindow(type_: wkeWindowType; parent: HWND; x, y, width,
  height: Integer): IWkeWindow;
begin
  LoadAPI;
  Result := TWkeWindow.Create(type_, parent, x, y, width, height);
end;

function TWke.RunAppclition(const MainWnd: HWND): Integer;
var
  msg: TMsg;
begin
  while (not FTerminate) and (MainWnd<>0) and IsWindow(MainWnd) do
  begin
    if not GetMessage(msg, 0, 0, 0) then
      break;
    Windows.TranslateMessage(msg);
    Windows.DispatchMessage(msg);
  end;
  Result := msg.wParam;
end;

procedure TWke.ProcessMessages;
  function _ProcessMessage(var Msg: TMsg): Boolean;
  begin
    Result := False;
    if PeekMessage(Msg, 0, 0, 0, PM_REMOVE) then
    begin
      Result := True;
      if Msg.Message <> WM_QUIT then
      begin
        TranslateMessage(Msg);
        DispatchMessage(Msg);
      end
      else
        FTerminate := True;
    end;
  end;
var
  Msg: TMsg;
begin
  while _ProcessMessage(Msg) do {loop};
end;

procedure TWke.Terminate;
begin
  FTerminate := True;
  PostQuitMessage(0);
end;

{ TWkeFileSystem }

procedure TWkeFileSystem.Close;
begin
  try
    if fs <> nil then
      FreeAndNil(fs);
  except
    on E: Exception do
    begin
      Trace('[TWkeFileSystem.Close]'+E.Message);
    end
  end;
end;

destructor TWkeFileSystem.Destroy;
begin
  Close;
  inherited;
end;

function TWkeFileSystem.Open(const path: PUtf8): Boolean;
var
  s: UnicodeString;
begin
  Close;
  Result := False;
  try
    s := {$IF CompilerVersion > 18.5}UTF8ToString{$ELSE}UTF8Decode{$IFEND}(path);
    if Pos(':', s) <= 0 then
      s := CurrentLoadDir + s;
    fs := TFileStream.Create(s, fmOpenRead);

    Result := True;
  except
    on E: Exception do
    begin
      Trace('[TWkeFileSystem.Open]'+E.Message);
    end
  end;
end;

function TWkeFileSystem.Read(buffer: Pointer; size: Cardinal): Integer;
begin
  Result := 0;
  try
    if fs = nil then
      Exit;
    Result := fs.read(buffer^, size)
  except
    on E: Exception do
    begin
      Trace('[TWkeFileSystem.Read]'+E.Message);
    end
  end;
end;

function TWkeFileSystem.Seek(offset, origin: Integer): Integer;
begin
  if fs <> nil then
    Result := fs.Seek(offset, origin)
  else
    Result := 0
end;

function TWkeFileSystem.Size: Cardinal;
begin
  if fs <> nil then
    Result := fs.Size
  else
    Result := 0;
end;

initialization
//  OleInitialize(nil);
//  CoInitialize(nil);

finalization
//  CoUninitialize;
//  OleUninitialize;

end.
