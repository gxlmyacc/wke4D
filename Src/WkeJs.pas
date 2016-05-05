unit WkeJs;

interface

uses
  SysUtils, Classes, WkeTypes, WkeHash, WkeIntf;

type
  TWkeJsExecState = class(TInterfacedObject, IWkeJsExecState)
  private
    FExecState: jsExecState;
    FGlobalObject: IWkeJsValue;
    FData1: Pointer;
    FData2: Pointer;
  private
    function GetWebView: TWebView;
    function GetProp(const AProp: WideString): IWkeJsValue;
    function GetExecState: jsExecState;
    function GetArg(const argIdx: Integer): IWkeJsValue;
    function GetArgCount: Integer;
    function GetArgType(const argIdx: Integer): jsType;
    function GetGlobalObject: IWkeJsValue;
    function GetData1: Pointer;
    function GetData2: Pointer;
    procedure SetProp(const AProp: WideString; const Value: IWkeJsValue);
    procedure SetData1(const Value: Pointer);
    procedure SetData2(const Value: Pointer);
  public
    constructor Create(const AExecState: JsExecState); overload;
    destructor Destroy; override;

    function jsInt(n: Integer): IWkeJsValue;
    function jsFloat(n: float): IWkeJsValue;
    function jsDouble(n: Double): IWkeJsValue;
    function jsBoolean(n: Boolean): IWkeJsValue;
    function jsUndefined(): IWkeJsValue;
    function jsNull(): IWkeJsValue;
    function jsTrue(): IWkeJsValue;
    function jsFalse(): IWkeJsValue;
    function jsString(const str: PUtf8): IWkeJsValue;
    function jsStringW(const str: Pwchar_t): IWkeJsValue;
    function jsObject(): IWkeJsValue;
    function jsArray(): IWkeJsValue;
    function jsFunction(fn: jsNativeFunction; argCount: Integer): IWkeJsValue;

    function Eval(const str: PUtf8): IWkeJsValue;
    function EvalW(const str: Pwchar_t): IWkeJsValue;

    function CallGlobal(func: jsValue; args: array of OleVariant): OleVariant; overload;
    function CallGlobal(const func: WideString; args: array of OleVariant): OleVariant; overload;
    function CallGlobalEx(func: jsValue; args: array of IWkeJsValue): IWkeJsValue; overload;
    function CallGlobalEx(const func: WideString; args: array of IWkeJsValue): IWkeJsValue; overload;

    function PropExist(const AProp: WideString): Boolean;

    procedure BindFunction(const name: WideString; fn: jsNativeFunction; argCount: Integer);
    procedure UnbindFunction(const name: WideString);
    procedure BindObject(const objName: WideString; obj: TObject);
    procedure UnbindObject(const objName: WideString);

    function CreateJsObject(obj: TObject): jsValue;

    property ExecState: jsExecState read GetExecState;
    //return the window object
    property GlobalObject: IWkeJsValue read GetGlobalObject;
    
    property Prop[const AProp: WideString]: IWkeJsValue read GetProp write SetProp;
    property ArgCount: Integer read GetArgCount;
    property ArgType[const argIdx: Integer]: jsType read GetArgType;
    property Arg[const argIdx: Integer]: IWkeJsValue read GetArg;

    property Data1: Pointer read GetData1 write SetData1;
    property Data2: Pointer read GetData2 write SetData2;

    property WebView: TWebView read GetWebView;
  end;

  TWkeJsValue = class(TInterfacedObject, IWkeJsValue)
  private
    FExecState: jsExecState;
    FValue: jsValue;
    FData1: Pointer;
    FData2: Pointer;
  private
    function GetExecState: jsExecState;
    function GetValue: jsValue;
    function GetValueType: jsType;
    function GetData1: Pointer;
    function GetData2: Pointer;
    procedure SetData1(const Value: Pointer);
    procedure SetData2(const Value: Pointer);
  public
    constructor Create(const AExecState: JsExecState); overload;
    constructor Create(const AExecState: JsExecState; const AValue: jsValue); overload;
    destructor Destroy; override;

    function IsNumber: Boolean;
    function IsString: Boolean;
    function IsBoolean: Boolean;
    function IsObject: Boolean;
    function IsFunction: Boolean;
    function IsUndefined: Boolean;
    function IsNull: Boolean;
    function IsArray: Boolean;
    function IsTrue: Boolean;
    function IsFalse: Boolean;

    function ToInt: Integer;
    function ToFloat: float;
    function ToDouble: Double;
    function ToBoolean: Boolean;
    function ToStringA: PUtf8;
    function ToStringW: Pwchar_t;
    function ToObject: IWkeJsObject;

    procedure SetAsInt(n: Integer);
    procedure SetAsFloat(n: float);
    procedure SetAsDouble(n: Double);
    procedure SetAsBoolean(n: Boolean);
    procedure SetAsUndefined();
    procedure SetAsNull();
    procedure SetAsTrue();
    procedure SetAsFalse();
    procedure SetAsString(const str: PUtf8);
    procedure SetAsStringW(const str: Pwchar_t);
    procedure SetAsObject(v: jsValue);
    procedure SetAsArray(v: jsValue);
    procedure SetAsFunction(fn: jsNativeFunction; argCount: Integer);

    property ExecState: jsExecState read GetExecState;
    property Value: jsValue read GetValue;
    property ValueType: jsType read GetValueType;

    property Data1: Pointer read GetData1 write SetData1;
    property Data2: Pointer read GetData2 write SetData2;
  end;

  TWkeJsObject = class(TWkeJsValue, IWkeJsObject)
  private
    function GetProp(const AName: WideString): IWkeJsValue;
    function GetPropAt(const AIndex: Integer): IWkeJsValue;
    function GetLength: Integer;
    procedure SetProp(const AName: WideString; const Value: IWkeJsValue);
    procedure SetPropAt(const AIndex: Integer; const Value: IWkeJsValue);
    procedure SetLength(const Value: Integer);
  public
    function Call(func: jsValue; args: array of OleVariant): OleVariant; overload;
    function Call(const func: WideString; args: array of OleVariant): OleVariant; overload;
    function CallEx(func: jsValue; args: array of IWkeJsValue): IWkeJsValue; overload;
    function CallEx(const func: WideString; args: array of IWkeJsValue): IWkeJsValue; overload;

    function PropExist(const AProp: WideString): Boolean;

    property Length: Integer read GetLength write SetLength;
    property Prop[const AName: WideString]: IWkeJsValue read GetProp write SetProp;
    property PropAt[const AIndex: Integer]: IWkeJsValue read GetPropAt write SetPropAt;
  end;

  PMethod = ^TMethod;

  TWkeJsObjectRegInfo = class(TInterfaceList, IWkeJsObjectRegInfo)
  private
    FName: WideString;
    FValue: TObject;
  protected
    function GetName: WideString;
    function GetValue: TObject;
    procedure SetName(const Value: WideString);
    procedure SetValue(const Value: TObject);
  public
    constructor Create(const AName: WideString; const AValue: TObject);
    
    property Name: WideString read GetName write SetName;
    property Value: TObject read GetValue write SetValue;
  end;

  TWkeJsObjectList = class(TInterfacedObject, IWkeJsObjectList)
  private
    FList: IInterfaceList;
    FNotifyList: TList;
    FNameHash: TStringHash;
    FNameHashValid: Boolean;
    FData1: Pointer;
    FData2: Pointer;
  protected
    function  GetCount: Integer;
    function  GetItem(const Index: Integer): IWkeJsObjectRegInfo;
    function  GetItemName(const Index: Integer): WideString;
    function  GetItemByName(const AName: WideString): IWkeJsObjectRegInfo;
    function  GetData1: Pointer;
    function  GetData2: Pointer;
    procedure SetItem(const Index: Integer; const Value: IWkeJsObjectRegInfo);
    procedure SetItemByName(const AName: WideString; const Value: IWkeJsObjectRegInfo);
    procedure SetData1(const Value: Pointer);
    procedure SetData2(const Value: Pointer);
  protected
    procedure UpdateNameHash;
    procedure DoNotify(const AInfo: IWkeJsObjectRegInfo; Action: TWkeJsObjectAction);
  public
    constructor Create;
    destructor Destroy; override;

    procedure Invalidate;

    function  Reg(const AName: WideString; const AItem: TObject): Integer;
    procedure UnReg(const Index: Integer); overload;
    procedure UnReg(const AName: WideString); overload;
    procedure Clear;

    function  IndexOf(const AItem: TObject): Integer;
    function  IndexOfName(const AName: WideString): Integer;

    function AddListener(const AListener: TWkeJsObjectListener): Integer;
    function RemoveListener(const AListener: TWkeJsObjectListener): Integer;

    property Count: Integer read GetCount;
    property Item[const Index: Integer]: IWkeJsObjectRegInfo read GetItem write SetItem; default;
    property ItemName[const Index: Integer]: WideString read GetItemName;
    property ItemByName[const AName: WideString]: IWkeJsObjectRegInfo read GetItemByName write SetItemByName;
    property Data1: Pointer read GetData1 write SetData1;
    property Data2: Pointer read GetData2 write SetData2;
  end;

  TWkeJs = class(TInterfacedObject, IWkeJs)
  private
    FWebView: TWebView;
    FGlobalExec: IWkeJsExecState;
    FData1: Pointer;
    FData2: Pointer;
  private
    function GetGlobalExec: IWkeJsExecState;
    function GetData1: Pointer;
    function GetData2: Pointer;
    procedure SetData1(const Value: Pointer);
    procedure SetData2(const Value: Pointer);
  public
    constructor Create(AWebView: TWebView);
    destructor Destroy; override;

    procedure BindFunction(const name: WideString; fn: jsNativeFunction; argCount: Integer);
    procedure UnbindFunction(const name: WideString);
    procedure BindObject(const objName: WideString; obj: TObject);
    procedure UnbindObject(const objName: WideString);

    procedure BindGetter(const name: WideString; fn: jsNativeFunction);
    procedure BindSetter(const name: WideString; fn: jsNativeFunction);

    function CreateJsObject(obj: TObject): jsValue;

    procedure GC();

    property GlobalExec: IWkeJsExecState read GetGlobalExec;
    property Data1: Pointer read GetData1 write SetData1;
    property Data2: Pointer read GetData2 write SetData2;
  end;

implementation

uses
  WkeApi, Variants;

{ TJsExecState }

function TWkeJsExecState.CallGlobal(func: jsValue;
  args: array of OleVariant): OleVariant;
var
  LArgs: JsValueArray;
  i, cArgs: Integer;
  jValue, jR: jsValue;
  sError: string;
begin
  cArgs := Length(args);
  SetLength(LArgs, cArgs);

  for i := 0 to High(args) do
  begin
    if not V2J(FExecState, args[i].Value, jValue, sError) then
    begin
      if sError <> '' then
        sError := Format('第%d个参数转换失败:%s', [i+1, sError])
      else
        sError := Format('第%d个参数转换失败!', [i+1]);
        
      raise EWkeException.Create(sError);
    end;
    
    LArgs[i] := jValue;
  end;

  jR := WAPI.jsCallGlobal(FExecState, func, @LArgs, cArgs);
  if WAPI.jsIsUndefined(jR) then
  begin
    Result := Unassigned;
  end
  else
  begin
    if not J2V(FExecState, jR, Result, sError) then
    begin
      if sError <> '' then
        sError := Format('返回值转换失败:%s', [sError])
      else
        sError := Format('返回值转换失败!', []);
        
      raise EWkeException.Create(sError);    
    end;
  end;
end;

function TWkeJsExecState.CallGlobalEx(func: jsValue;
  args: array of IWkeJsValue): IWkeJsValue;
var
  LArgs: JsValueArray;
  i, cArgs: Integer;
begin
  cArgs := Length(args);
  SetLength(LArgs, cArgs);

  for i := 0 to High(args) do
    LArgs[i] := args[i].Value;

  Result := TWkeJsValue.Create(FExecState,
    WAPI.jsCallGlobal(FExecState, func, @LArgs, cArgs)
  );
end;

function TWkeJsExecState.CallGlobalEx(const func: WideString;
  args: array of IWkeJsValue): IWkeJsValue;
var
  v: IWkeJsValue;
begin
  v := GetProp(func);
  if not v.IsFunction then
    raise EWkeException.CreateFmt('脚本中，[%s]函数不存在，或它不是函数！', [func]);

  Result := CallGlobalEx(v.Value, args);
end;

constructor TWkeJsExecState.Create(const AExecState: JsExecState);
begin
  FExecState := AExecState;
end;

destructor TWkeJsExecState.Destroy;
begin
  FGlobalObject := nil;
  inherited;
end;

function TWkeJsExecState.Eval(const str: PUtf8): IWkeJsValue;
begin
  Result := TWkeJsValue.Create(FExecState,
    WAPI.jsEval(FExecState, str)
  );
end;

function TWkeJsExecState.EvalW(const str: Pwchar_t): IWkeJsValue;
begin
  Result := TWkeJsValue.Create(FExecState,
    WAPI.jsEvalW(FExecState, str)
  );
end;

function TWkeJsExecState.GetArg(const argIdx: Integer): IWkeJsValue ;
begin
  Result := TWkeJsValue.Create(FExecState, WAPI.jsArg(FExecState, argIdx));
end;

function TWkeJsExecState.GetArgCount: Integer;
begin
  Result := WAPI.jsArgCount(FExecState);
end;

function TWkeJsExecState.GetArgType(const argIdx: Integer): jsType;
begin
  Result := WAPI.jsArgType(FExecState, argIdx);
end;

function TWkeJsExecState.GetExecState: jsExecState;
begin
  Result := FExecState;
end;

{ TWkeJsValue }

constructor TWkeJsValue.Create(const AExecState: JsExecState);
begin
  FExecState := AExecState;
  FValue := WAPI.jsUndefined;
end;

constructor TWkeJsValue.Create(const AExecState: JsExecState;
  const AValue: jsValue);
begin
  FExecState := AExecState;
  FValue := AValue;
end;

destructor TWkeJsValue.Destroy;
begin

  inherited;
end;

function TWkeJsValue.GetData1: Pointer;
begin
  Result := FData1;
end;

function TWkeJsValue.GetData2: Pointer;
begin
  Result := FData2;
end;

function TWkeJsValue.GetExecState: jsExecState;
begin
  Result := FExecState;
end;

function TWkeJsValue.GetValue: jsValue;
begin
  Result := FValue;
end;

function TWkeJsValue.GetValueType: jsType;
begin
  Result := WAPI.jsTypeOf(FValue);
end;

function TWkeJsValue.IsArray: Boolean;
begin
  Result := WAPI.jsIsArray(FValue);
end;

function TWkeJsValue.IsBoolean: Boolean;
begin
  Result := WAPI.jsIsBoolean(FValue);
end;

function TWkeJsValue.IsFalse: Boolean;
begin
  Result := WAPI.jsIsFalse(FValue);
end;

function TWkeJsValue.IsFunction: Boolean;
begin
  Result := WAPI.jsIsFunction(FValue);
end;

function TWkeJsValue.IsNull: Boolean;
begin
  Result := WAPI.jsIsNull(FValue);
end;

function TWkeJsValue.IsNumber: Boolean;
begin
  Result := WAPI.jsIsNumber(FValue);
end;

function TWkeJsValue.IsObject: Boolean;
begin
  Result := WAPI.jsIsObject(FValue);
end;

function TWkeJsValue.IsString: Boolean;
begin
  Result := WAPI.jsIsString(FValue);
end;

function TWkeJsValue.IsTrue: Boolean;
begin
  Result := WAPI.jsIsNull(FValue);
end;

function TWkeJsValue.IsUndefined: Boolean;
begin
  Result := WAPI.jsIsUndefined(FValue);
end;

procedure TWkeJsValue.SetAsArray(v: jsValue);
begin
  FValue := v;
end;

procedure TWkeJsValue.SetAsBoolean(n: Boolean);
begin
  FValue := WAPI.jsBoolean(n);
end;

procedure TWkeJsValue.SetAsDouble(n: Double);
begin
  FValue := WAPI.jsDouble(n);
end;

procedure TWkeJsValue.SetAsFalse;
begin
  FValue := WAPI.jsFalse;
end;

procedure TWkeJsValue.SetAsFloat(n: float);
begin
  FValue := WAPI.jsFloat(n);
end;

procedure TWkeJsValue.SetAsFunction(fn: jsNativeFunction; argCount: Integer);
begin
  FValue := WAPI.jsFunction(FExecState, fn, argCount);
end;

procedure TWkeJsValue.SetAsInt(n: Integer);
begin
  FValue := WAPI.jsInt(n);
end;

procedure TWkeJsValue.SetAsNull;
begin
  FValue := WAPI.jsNull;
end;

procedure TWkeJsValue.SetAsObject(v: jsValue);
begin
  FValue := v;
end;

procedure TWkeJsValue.SetAsString(const str: PUtf8);
begin
  FValue := WAPI.jsString(FExecState, str);
end;

procedure TWkeJsValue.SetAsStringW(const str: Pwchar_t);
begin
  FValue := WAPI.jsStringW(FExecState, str);
end;

procedure TWkeJsValue.SetAsTrue;
begin
  FValue := WAPI.jsTrue;
end;

procedure TWkeJsValue.SetAsUndefined;
begin
  FValue := WAPI.jsUndefined;
end;

procedure TWkeJsValue.SetData1(const Value: Pointer);
begin
  FData1 := Value;
end;

procedure TWkeJsValue.SetData2(const Value: Pointer);
begin
  FData2 := Value;
end;

function TWkeJsValue.ToBoolean: Boolean;
begin
  Result := WAPI.jsToBoolean(FExecState, FValue);
end;

function TWkeJsValue.ToDouble: Double;
begin
  Result := WAPI.jsToDouble(FExecState, FValue);
end;

function TWkeJsValue.ToFloat: float;
begin
  Result := WAPI.jsToFloat(FExecState, FValue);
end;

function TWkeJsValue.ToInt: Integer;
begin
  Result := WAPI.jsToInt(FExecState, FValue);
end;

function TWkeJsValue.ToObject: IWkeJsObject;
begin
  Assert(GetValueType = JSTYPE_OBJECT);
  Result := TWkeJsObject.Create(FExecState, FValue); 
end;

function TWkeJsValue.ToStringA: PUtf8;
begin
  Result := WAPI.jsToTempString(FExecState, FValue);
end;

function TWkeJsValue.ToStringW: Pwchar_t;
begin
  Result := WAPI.jsToTempStringW(FExecState, FValue);
end;


{ TTiscriptObjectList }

function TWkeJsObjectList.Reg(const AName: WideString; const AItem: TObject): Integer;
var
  i: Integer;
  LInfo: IWkeJsObjectRegInfo;
begin
  i := IndexOfName(AName);
  LInfo := TWkeJsObjectRegInfo.Create(AName, AItem);
  if i < 0 then
  begin
    Result := FList.Add(LInfo);
    FNameHash.Add(AnsiUpperCase(AName), Result);
    DoNotify(LInfo, woaReg);
  end
  else
  begin
    SetItem(i, LInfo);
    Result := i;
  end;
end;

procedure TWkeJsObjectList.Clear;
var
  i: Integer;
begin
  if FList = nil then Exit;
  for i := FList.Count - 1 downto 0 do
    DoNotify(GetItem(i), woaUnreg);
  FList.Clear;
  FNameHashValid := False;
end;

constructor TWkeJsObjectList.Create;
begin
  FList := TInterfaceList.Create;
  FNameHash := TStringHash.Create(1024);
  FNotifyList := TList.Create;
end;

procedure TWkeJsObjectList.UnReg(const Index: Integer);
begin
  DoNotify(GetItem(Index), woaUnreg);
  FList.Delete(Index);
  FNameHashValid := False;
end;

procedure TWkeJsObjectList.UnReg(const AName: WideString);
var
  i: Integer;
begin
  i := IndexOfName(AName);
  if i >= 0 then
    UnReg(i); 
end;

destructor TWkeJsObjectList.Destroy;
var
  i: Integer;
begin
  if FList <> nil then
  begin
    Clear;
    FList := nil;
  end;
  if FNotifyList <> nil then
  begin
    for i := 0 to FNotifyList.Count - 1 do
      Dispose(PMethod(FNotifyList[i]));
    FreeAndNil(FNotifyList);
  end;
  if FNameHash <> nil then
    FreeAndNil(FNameHash);

  inherited;
end;

function TWkeJsObjectList.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TWkeJsObjectList.GetItem(const Index: Integer): IWkeJsObjectRegInfo;
begin
  Result := FList[index] as IWkeJsObjectRegInfo;
end;

function TWkeJsObjectList.GetItemByName(
  const AName: WideString): IWkeJsObjectRegInfo;
var
  i: Integer;
begin
  i := IndexOfName(AName);
  if i >= 0 then
    Result := GetItem(i)
  else
    Result := nil;
end;

function TWkeJsObjectList.IndexOf(const AItem: TObject): Integer;
begin
  for Result := 0 to  FList.Count - 1 do
  begin
    if GetItem(Result).Value = AItem then
     Exit;
  end;
  Result := -1;
end;

function TWkeJsObjectList.IndexOfName(const AName: WideString): Integer;
begin
  UpdateNameHash;
  Result := FNameHash.ValueOf(AnsiUpperCase(AName));
end;

procedure TWkeJsObjectList.Invalidate;
begin
  FNameHashValid := False;
end;

procedure TWkeJsObjectList.SetItemByName(const AName: WideString;
  const Value: IWkeJsObjectRegInfo);
var
  i: Integer;
begin
  i := IndexOfName(AName);
  if i >= 0 then
    SetItem(i, Value);
end;

procedure TWkeJsObjectList.UpdateNameHash;
var
  I: Integer;
  Key: string;
begin
  if FNameHashValid then Exit;

  FNameHash.Clear;
  for I := 0 to Count - 1 do
  begin
    Key := AnsiUpperCase(GetItem(i).Name);
    FNameHash.Add(Key, I);
  end;
  
  FNameHashValid := True;
end;

procedure TWkeJsObjectList.SetItem(const Index: Integer;
  const Value: IWkeJsObjectRegInfo);
begin
  Assert(GetItem(Index).Name = Value.Name);
  FList[Index] := Value;
  DoNotify(Value, woaChanged);
end;

function TWkeJsObjectList.GetItemName(const Index: Integer): WideString;
begin
  Result := GetItem(index).Name;
end;

{ TWkeJs }

procedure TWkeJs.BindFunction(const name: WideString; fn: jsNativeFunction;
  argCount: Integer);
begin
  GlobalExec.BindFunction(name, fn, argCount);
end;

procedure TWkeJs.BindGetter(const name: WideString; fn: jsNativeFunction);
begin
  WAPI.jsBindGetter(PAnsiChar(AnsiString(name)), fn);
end;

procedure TWkeJs.BindObject(const objName: WideString; obj: TObject);
begin
  GlobalExec.BindObject(objName, obj);
end;

procedure TWkeJs.BindSetter(const name: WideString; fn: jsNativeFunction);
begin
  WAPI.jsBindSetter(PAnsiChar(AnsiString(name)), fn);
end;


constructor TWkeJs.Create(AWebView: TWebView);
begin
  FWebView := AWebView;
  FGlobalExec := TWkeJsExecState.Create(WAPI.wkeGlobalExec(FWebView));
end;

function TWkeJs.CreateJsObject(obj: TObject): jsValue;
begin
  Result := GlobalExec.CreateJsObject(obj)
end;

destructor TWkeJs.Destroy;
begin
  FGlobalExec := nil;
  inherited;
end;

procedure TWkeJs.GC;
begin
  WAPI.jsGC();
end;

function TWkeJs.GetData1: Pointer;
begin
  Result := FData1;
end;

function TWkeJs.GetData2: Pointer;
begin
  Result := FData2;
end;

function TWkeJs.GetGlobalExec: IWkeJsExecState;
begin
  Result := FGlobalExec;
end;

function TWkeJsExecState.GetProp(const AProp: WideString): IWkeJsValue;
begin
  Result := TWkeJsValue.Create(FExecState,
    WAPI.jsGetGlobal(FExecState, PAnsiChar(AnsiString(AProp)))
  );
end;

function TWkeJsExecState.GetGlobalObject: IWkeJsValue;
begin
  if FGlobalObject = nil then
    FGlobalObject := TWkeJsValue.Create(FExecState, WAPI.jsGlobalObject(FExecState));

  Result := FGlobalObject;
end;

function TWkeJsExecState.PropExist(const AProp: WideString): Boolean;
var
  v: jsValue;
begin
  v := WAPI.jsGetGlobal(FExecState, PAnsiChar(AnsiString(AProp)));
  Result := not WAPI.jsIsUndefined(v);
end;

function TWkeJsExecState.jsArray: IWkeJsValue;
begin
  Result := TWkeJsValue.Create(FExecState, WAPI.jsEmptyArray(FExecState));
end;

function TWkeJsExecState.jsBoolean(n: Boolean): IWkeJsValue;
begin
  Result := TWkeJsValue.Create(FExecState, WAPI.jsBoolean(n));
end;

function TWkeJsExecState.jsDouble(n: Double): IWkeJsValue;
begin
  Result := TWkeJsValue.Create(FExecState, WAPI.jsDouble(n));
end;

function TWkeJsExecState.jsFalse: IWkeJsValue;
begin
  Result := TWkeJsValue.Create(FExecState, WAPI.jsFalse());
end;

function TWkeJsExecState.jsFloat(n: float): IWkeJsValue;
begin
  Result := TWkeJsValue.Create(FExecState, WAPI.jsFloat(n));
end;

function TWkeJsExecState.jsFunction(fn: jsNativeFunction;
  argCount: Integer): IWkeJsValue;
begin
  Result := TWkeJsValue.Create(FExecState, WAPI.jsFunction(FExecState, fn, ArgCount));
end;

function TWkeJsExecState.jsInt(n: Integer): IWkeJsValue;
begin
  Result := TWkeJsValue.Create(FExecState, WAPI.jsInt(n));
end;

function TWkeJsExecState.jsNull: IWkeJsValue;
begin
  Result := TWkeJsValue.Create(FExecState, WAPI.jsNull());
end;

function TWkeJsExecState.jsObject: IWkeJsValue;
begin
  Result := TWkeJsValue.Create(FExecState, WAPI.jsEmptyObject(FExecState));
end;

function TWkeJsExecState.jsString(const str: PUtf8): IWkeJsValue;
begin
  Result := TWkeJsValue.Create(FExecState, WAPI.jsString(FExecState, str));
end;

function TWkeJsExecState.jsStringW(const str: Pwchar_t): IWkeJsValue;
begin
  Result := TWkeJsValue.Create(FExecState, WAPI.jsStringW(FExecState, str));
end;

function TWkeJsExecState.jsTrue: IWkeJsValue;
begin
  Result := TWkeJsValue.Create(FExecState, WAPI.jsTrue());
end;

function TWkeJsExecState.jsUndefined: IWkeJsValue;
begin
  Result := TWkeJsValue.Create(FExecState, WAPI.jsUndefined());
end;

procedure TWkeJsExecState.SetProp(const AProp: WideString;
  const Value: IWkeJsValue);
begin
  if Value = nil then
  begin
    WAPI.jsSetGlobal(FExecState, PAnsiChar(AnsiString(AProp)), WAPI.jsUndefined);
  end
  else
  begin
    WAPI.jsSetGlobal(FExecState, PAnsiChar(AnsiString(AProp)), Value.Value);
  end;
end;

function TWkeJsExecState.CallGlobal(const func: WideString;
  args: array of OleVariant): OleVariant;
var
  v: IWkeJsValue;
begin
  v := GetProp(func);
  if not v.IsFunction then
    raise EWkeException.CreateFmt('脚本中，[%s]函数不存在，或它不是函数！', [func]);

  Result := CallGlobal(v.Value, args);
end;

function TWkeJsExecState.GetWebView: TWebView;
begin
  Result := WAPI.jsGetWebView(FExecState);
end;

procedure TWkeJs.SetData1(const Value: Pointer);
begin
  FData1 := Value;
end;

procedure TWkeJs.SetData2(const Value: Pointer);
begin
  FData2 := Value;
end;

procedure TWkeJs.UnbindFunction(const name: WideString);
begin
  GlobalExec.UnbindFunction(name);
end;

procedure TWkeJs.UnbindObject(const objName: WideString);
begin
  GlobalExec.UnbindObject(objName);
end;

{ TWkeJsObject }

function TWkeJsObject.Call(const func: WideString;
  args: array of OleVariant): OleVariant;
var
  v: IWkeJsValue;
begin
  v := GetProp(func);
  if not v.IsFunction then
    raise EWkeException.CreateFmt('脚本中，[%s]函数不存在，或它不是函数！', [func]);

  Result := Call(v.Value, args);
end;

function TWkeJsObject.Call(func: jsValue;
  args: array of OleVariant): OleVariant;
var
  LArgs: JsValueArray;
  i, cArgs: Integer;
  jValue, jR: jsValue;
  sError: string;
begin
  cArgs := System.Length(args);
  System.SetLength(LArgs, cArgs);

  for i := 0 to High(args) do
  begin
    if not V2J(FExecState, args[i].Value, jValue, sError) then
    begin
      if sError <> '' then
        sError := Format('第%d个参数转换失败:%s', [i+1, sError])
      else
        sError := Format('第%d个参数转换失败!', [i+1]);
        
      raise EWkeException.Create(sError);
    end;
    
    LArgs[i] := jValue;
  end;

  jR := WAPI.jsCall(FExecState, func, FValue, @LArgs, cArgs);
  if WAPI.jsIsUndefined(jR) then
  begin
    Result := Unassigned;
  end
  else
  begin
    if not J2V(FExecState, jR, Result, sError) then
    begin
      if sError <> '' then
        sError := Format('返回值转换失败:%s', [sError])
      else
        sError := Format('返回值转换失败!', []);
        
      raise EWkeException.Create(sError);    
    end;
  end;
end;

function TWkeJsObject.CallEx(const func: WideString;
  args: array of IWkeJsValue): IWkeJsValue;
var
  v: IWkeJsValue;
begin
  v := GetProp(func);
  if not v.IsFunction then
    raise EWkeException.CreateFmt('脚本中，[%s]函数不存在，或它不是函数！', [func]);

  Result := CallEx(v.Value, args);
end;

function TWkeJsObject.CallEx(func: jsValue;
  args: array of IWkeJsValue): IWkeJsValue;
var
  LArgs: JsValueArray;
  i, cArgs: Integer;
begin
  cArgs := System.Length(args);
  System.SetLength(LArgs, cArgs);

  for i := 0 to High(args) do
    LArgs[i] := args[i].Value;

  Result := TWkeJsValue.Create(FExecState,
    WAPI.jsCall(FExecState, func, FValue, @LArgs, cArgs)
  );
end;

function TWkeJsObject.GetLength: Integer;
begin
  Result := WAPI.jsGetLength(FExecState, FValue);
end;

function TWkeJsObject.GetProp(const AName: WideString): IWkeJsValue;
begin
  Result := TWkeJsValue.Create(FExecState,
    WAPI.jsGet(FExecState, FValue, PAnsiChar(AnsiString(AName)))
  );
end;

function TWkeJsObject.GetPropAt(
  const AIndex: Integer): IWkeJsValue;
begin
  Result := TWkeJsValue.Create(FExecState,
    WAPI.jsGetAt(FExecState, FValue, AIndex)
  );
end;

function TWkeJsObject.PropExist(const AProp: WideString): Boolean;
var
  v: jsValue;
begin
  v := WAPI.jsGet(FExecState, FValue, PAnsiChar(AnsiString(AProp)));
  Result := not WAPI.jsIsUndefined(v);
end;

procedure TWkeJsObject.SetLength(const Value: Integer);
begin
  WAPI.jsSetLength(FExecState, FValue, Value);
end;

procedure TWkeJsObject.SetProp(const AName: WideString;
  const Value: IWkeJsValue);
begin
  if Value = nil then
  begin
    WAPI.jsSet(FExecState, FValue, PAnsiChar(AnsiString(AName)), WAPI.jsUndefined);
  end
  else
  begin
    WAPI.jsSet(FExecState, FValue, PAnsiChar(AnsiString(AName)), Value.Value);
  end;
end;

procedure TWkeJsObject.SetPropAt(const AIndex: Integer;
  const Value: IWkeJsValue);
begin
  if Value = nil then
  begin
    WAPI.jsSetAt(FExecState, FValue, AIndex, WAPI.jsUndefined);
  end
  else
  begin
    WAPI.jsSetAt(FExecState, FValue, AIndex, Value.Value);
  end;
end;

function TWkeJsExecState.GetData1: Pointer;
begin
  Result := FData1;
end;

function TWkeJsExecState.GetData2: Pointer;
begin
  Result := FData2;
end;

procedure TWkeJsExecState.SetData1(const Value: Pointer);
begin
  FData1 := Value;
end;

procedure TWkeJsExecState.SetData2(const Value: Pointer);
begin
  FData2 := Value;
end;

procedure TWkeJsExecState.BindObject(const objName: WideString;
  obj: TObject);
begin
  Wke.BindObject(FExecState, objName, obj);
end;

procedure TWkeJsExecState.BindFunction(const name: WideString;
  fn: jsNativeFunction; argCount: Integer);
begin
  Wke.BindFunction(FExecState, name, fn, argCount);
end;

procedure TWkeJsExecState.UnbindFunction(const name: WideString);
begin
  Wke.UnbindFunction(FExecState, name);
end;

procedure TWkeJsExecState.UnbindObject(const objName: WideString);
begin
  Wke.UnbindObject(FExecState, objName);
end;

function TWkeJsObjectList.GetData1: Pointer;
begin
  Result := FData1;
end;

function TWkeJsObjectList.GetData2: Pointer;
begin
  Result := FData2;
end;

procedure TWkeJsObjectList.SetData1(const Value: Pointer);
begin
  FData1 := Value;
end;

procedure TWkeJsObjectList.SetData2(const Value: Pointer);
begin
  FData2 := Value;
end;

function TWkeJsExecState.CreateJsObject(obj: TObject): jsValue;
begin
  Result := Wke.CreateJsObject(FExecState, obj);
end;

{ TWkeJsObjectRegInfo }

constructor TWkeJsObjectRegInfo.Create(const AName: WideString;
  const AValue: TObject);
begin
  FName := AName;
  FValue := AValue;
end;

function TWkeJsObjectRegInfo.GetName: WideString;
begin
  Result := FName;
end;

function TWkeJsObjectRegInfo.GetValue: TObject;
begin
  Result := FValue;
end;

procedure TWkeJsObjectRegInfo.SetName(const Value: WideString);
begin
  FName := Value;
end;

procedure TWkeJsObjectRegInfo.SetValue(const Value: TObject);
begin
  FValue := Value;
end;

procedure TWkeJsObjectList.DoNotify(const AInfo: IWkeJsObjectRegInfo;
  Action: TWkeJsObjectAction);
var
  i: Integer;
begin
  for i := 0 to FNotifyList.Count - 1 do
  try
    TWkeJsObjectListener(PMethod(FNotifyList[i])^)(AInfo, Action);
  except
  end;
end;

function TWkeJsObjectList.AddListener(
  const AListener: TWkeJsObjectListener): Integer;
var
  LMethod: PMethod;
begin
  New(LMethod);
  LMethod^ := TMethod(AListener);
  Result := FNotifyList.Add(LMethod);
end;

function TWkeJsObjectList.RemoveListener(
  const AListener: TWkeJsObjectListener): Integer;
var
  LMethod: PMethod;
begin
  for Result := FNotifyList.Count - 1 downto 0 do
  begin
    LMethod := PMethod(FNotifyList[Result]);
    if (LMethod.Code = TMethod(AListener).Code) and (LMethod.Data = TMethod(AListener).Data) then
    begin
      Dispose(LMethod);
      FNotifyList.Delete(Result);
      Exit;
    end;
  end;
  Result := -1;
end;

end.
