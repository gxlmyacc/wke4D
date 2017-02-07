unit WkeWebView;

interface

uses
  SysUtils, Classes, Messages, Windows, WkeTypes, WkeApi, WkeIntf, Imm;

type
  TWkeWebView = class;
  
  TWkeTimer = class
  private
    FInterval: Cardinal;
    FWindowHandle: HWND;
    FOnTimer: TNotifyEvent;
    FEnabled: Boolean;
    procedure UpdateTimer;
    procedure SetEnabled(Value: Boolean);
    procedure SetInterval(Value: Cardinal);
    procedure SetOnTimer(Value: TNotifyEvent);
    procedure WndProc(var Msg: TMessage);
  protected
    procedure Timer; dynamic;
  public
    constructor Create;
    destructor Destroy; override;

    property Enabled: Boolean read FEnabled write SetEnabled;
    property Interval: Cardinal read FInterval write SetInterval;
    property OnTimer: TNotifyEvent read FOnTimer write SetOnTimer;
  end;
  
  TWkeWebView = class(TInterfacedObject, IWkeWebView)
  private
    FThis: Pointer;
    FImeCount: Integer;
    FImeResult: WideString;
    FUserAgent: WideString;

    FDestroying: Boolean;
    
    FWebView: TWebView;
    FOwnView: Boolean;
    FJs: IWkeJs;
    FData1: Pointer;
    FData2: Pointer;

    FIsFocused: Boolean;
    FInvalidate: Boolean;

    FWebViewUpdateTimer: TWkeTimer;
    FObjectList: IWkeJsObjectList;

    FOnTitleChange: TWkeWebViewTitleChangeProc;
    FOnURLChange: TWkeWebViewURLChangeProc;
    FOnPaintUpdated: TWkeWebViewPaintUpdatedProc;
    FOnAlertBoxProc: TWkeWebViewAlertBoxProc;
    FOnConfirmBoxProc: TWkeWebViewConfirmBoxProc;
    FOnPromptBoxProc: TWkeWebViewPromptBoxProc;
    FOnConsoleMessageProc: TWkeWebViewConsoleMessageProc;
    FOnNavigationProc: TWkeWebViewNavigationProc;
    FOnCreateViewProc: TWkeWebViewCreateViewProc;
    FOnDocumentReadyProc: TWkeWebViewDocumentReadyProc;
    FOnLoadingFinishProc: TWkeWebViewLoadingFinishProc;

    FOnInvalidate: TWkeInvalidateProc;
    FOnContextMenu: TWkeContextMenuProc;
    FOnWndProc: TWkeWndProc;
    FOnWndDestory: TWkeWndDestoryProc;
  private
    function GetThis: IWkeWebBase; virtual;
    function GetWebView: TWebView;
    function GetName: WideString;
    function GetTransparent: Boolean;
    function GetTitle: WideString;
    function GetUserAgent: WideString;
    function GetCookie: WideString;
    function GetHostWindow: HWND;
    function GetWidth: Integer;
    function GetHeight: Integer;
    function GetContentWidth: Integer;
    function GetContentHeight: Integer;
    function GetViewDC(): Pointer;
    function GetCursorType: wkeCursorType;
    function GetDirty: Boolean;
    function GetFocused: Boolean;
    function GetCookieEnabled: Boolean;
    function GetMediaVolume: float;
    function GetCaretRect: wkeRect;
    function GetZoomFactor: float;
    function GetEnabled: Boolean;
    function GetJs: IWkeJs;
    function GetData1: Pointer;
    function GetData2: Pointer;
    function GetOnTitleChange: TWkeWebViewTitleChangeProc;
    function GetOnURLChange: TWkeWebViewURLChangeProc;
    function GetOnPaintUpdated: TWkeWebViewPaintUpdatedProc;
    function GetOnAlertBox: TWkeWebViewAlertBoxProc;
    function GetOnConfirmBox: TWkeWebViewConfirmBoxProc;
    function GetOnConsoleMessage: TWkeWebViewConsoleMessageProc;
    function GetOnCreateView: TWkeWebViewCreateViewProc;
    function GetOnDocumentReady: TWkeWebViewDocumentReadyProc;
    function GetOnLoadingFinish: TWkeWebViewLoadingFinishProc;
    function GetOnNavigation: TWkeWebViewNavigationProc;
    function GetOnPromptBox: TWkeWebViewPromptBoxProc;
    function GetOnInvalidate: TWkeInvalidateProc;
    function GetOnContextMenu: TWkeContextMenuProc;
    function GetOnWndProc: TWkeWndProc;
    function GetOnWndDestory: TWkeWndDestoryProc;
    procedure SetName(const Value: WideString);
    procedure SetTransparent(const Value: Boolean);
    procedure SetUserAgent(const Value: WideString);
    procedure SetHostWindow(const Value: HWND);
    procedure SetDirty(const Value: Boolean);
    procedure SetCookieEnabled(const Value: Boolean);
    procedure SetMediaVolume(const Value: float);
    procedure SetZoomFactor(const Value: float);
    procedure SetEnabled(const Value: Boolean);
    procedure SetData1(const Value: Pointer);
    procedure SetData2(const Value: Pointer);
    procedure SetOnTitleChange(const Value: TWkeWebViewTitleChangeProc);
    procedure SetOnURLChange(const Value: TWkeWebViewURLChangeProc);
    procedure SetOnPaintUpdated(const Value: TWkeWebViewPaintUpdatedProc);
    procedure SetOnAlertBox(const Value: TWkeWebViewAlertBoxProc);
    procedure SetOnConfirmBox(const Value: TWkeWebViewConfirmBoxProc);
    procedure SetOnConsoleMessage(const Value: TWkeWebViewConsoleMessageProc);
    procedure SetOnCreateView(const Value: TWkeWebViewCreateViewProc);
    procedure SetOnDocumentReady(const Value: TWkeWebViewDocumentReadyProc);
    procedure SetOnLoadingFinish(const Value: TWkeWebViewLoadingFinishProc);
    procedure SetOnNavigation(const Value: TWkeWebViewNavigationProc);
    procedure SetOnPromptBox(const Value: TWkeWebViewPromptBoxProc);
    procedure SetOnInvalidate(const Value: TWkeInvalidateProc);
    procedure SetOnContextMenu(const Value: TWkeContextMenuProc);
    procedure SetOnWndProc(const Value: TWkeWndProc);
    procedure SetOnWndDestory(const Value: TWkeWndDestoryProc);
  protected
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;

    procedure DoAlertBox(const msg: wkeString);
    function  DoConfirmBox(const msg: wkeString): Boolean;
    function  DoOnPromptBox(const msg, defaultResult, result_: wkeString): Boolean;
    procedure DoPaintUpdated(const hdc: HDC; x, y, cx, cy: Integer); 
    procedure DoDocumentReady(const info: PwkeDocumentReadyInfo);
    function  DoCreateView(const info: PwkeNewViewInfo): TWebView;
    function  DoNavigation(navigationType: wkeNavigationType; const url: wkeString): Boolean;
    procedure DoLoadingFinish(const url: wkeString; result_: wkeLoadingResult; const failedReason: wkeString);

    procedure DoRegObjectsNotify(const AInfo: IWkeJsObjectRegInfo; Action: TWkeJsObjectAction);
    procedure DoWebViewUpdateTimer(Sender: TObject);
    procedure DoBeforeLoadHtml();
    procedure DoAfterLoadHtml();
  public
    constructor Create(const AThis: IWkeWebBase); overload;
    constructor Create(const AThis: IWkeWebBase; const AWebView: TWebView; const AOwnView: Boolean = True); overload;
    destructor Destroy; override;

    function ProcND(msg: UINT; wParam: WPARAM; lParam: LPARAM; var pbHandled: Boolean): LRESULT; virtual;

    procedure Close;

    procedure Show(nCmdShow: Integer = SW_SHOW);
    procedure Hide;
    function  IsShowing: Boolean;

    procedure LoadURL(const url: WideString);
    procedure PostURL(const url: WideString; const postData: PAnsiChar; postLen: Integer);
    procedure LoadHTML(const html: WideString); overload;
    procedure LoadHTML(const html: PUtf8);  overload;
    procedure LoadFile(const filename: WideString);
    procedure Load(const str: PUtf8); overload;
    procedure Load(const str: WideString); overload;
    
    procedure Update;
    procedure Invalidate;

    function IsLoading: Boolean;
    function IsLoadSucceeded: Boolean; (*document load sucessed*)
    function IsLoadFailed: Boolean;    (*document load failed*)
    function IsLoadComplete: Boolean;  (*document load complete*)
    function IsDocumentReady: Boolean; (*document ready*)

    procedure StopLoading;
    procedure Reload;

    procedure Resize(w: Integer; h: Integer);

    procedure AddDirtyArea(x, y, w, h: Integer);

    procedure LayoutIfNeeded;
    procedure RepaintIfNeeded;
    procedure Paint(bits: Pointer; pitch: Integer); overload;
    procedure Paint(bits: Pointer; bufWid, bufHei, xDst, yDst, w, h,
      xSrc, ySrc: Integer; bCopyAlpha: Boolean); overload;

    function CanGoBack: Boolean;
    function GoBack: Boolean;
    function CanGoForward: Boolean;
    function GoForward: Boolean;

    procedure EditerSelectAll;
    function  EditerCanCopy: Boolean;
    procedure EditerCopy;
    function  EditerCanCut: Boolean;
    procedure EditerCut;
    function  EditerCanPaste: Boolean;
    procedure EditerPaste;
    function  EditerCanDelete: Boolean;
    procedure EditerDelete;
    function  EditerCanUndo: Boolean;
    procedure EditerUndo;
    function  EditerCanRedo: Boolean;
    procedure EditerRedo;

    function MouseEvent(msg: UINT; x, y: Integer; flags: UINT): Boolean;
    function ContextMenuEvent(x, y: Integer; flags: UINT): Boolean;
    function MouseWheel(x, y, delta: Integer; flags: UINT): Boolean;
    function KeyUp(virtualKeyCode: UINT; flags: UINT; systemKey: Boolean): Boolean;
    function KeyDown(virtualKeyCode: UINT; flags: UINT; systemKey: Boolean): Boolean;
    function KeyPress(charCode: UINT; flags: UINT; systemKey: Boolean): Boolean;

    procedure SetFocus;
    procedure KillFocus;

    function RunJS(const script: PUtf8): jsValue; overload;
    function RunJS(const script: WideString): jsValue; overload;

    function GlobalExec: jsExecState;

    procedure Sleep(); //moveOffscreen
    procedure Wake();  //moveOnscreen
    function  IsAwake: Boolean;

    procedure SetEditable(editable: Boolean);

    procedure BindObject(const objName: WideString; obj: TObject);
    procedure UnbindObject(const objName: WideString);

    property This: IWkeWebBase read GetThis;
    property WebView: TWebView read GetWebView;

    property Name: WideString read GetName write SetName;
    property Transparent: Boolean read GetTransparent write SetTransparent;
    property Title: WideString read GetTitle;
    property UserAgent: WideString read GetUserAgent write SetUserAgent;
    property Cookie: WideString read GetCookie;

    property HostWindow: HWND read GetHostWindow write SetHostWindow;
    property Width: Integer read GetWidth;    (*viewport width*)
    property Height: Integer read GetHeight;  (*viewport height*)

    property ContentWidth: Integer read GetContentWidth;    (*contents width*)
    property ContentHeight: Integer read GetContentHeight;  (*contents height*)

    property ViewDC: Pointer read GetViewDC;

    property CursorType: wkeCursorType read GetCursorType;
    property IsFocused: Boolean read GetFocused;
    property IsDirty: Boolean read GetDirty write SetDirty;
    property CookieEnabled: Boolean read GetCookieEnabled write SetCookieEnabled;
    property MediaVolume: float read GetMediaVolume write SetMediaVolume;
    property CaretRect: wkeRect read GetCaretRect;
    property ZoomFactor: float read GetZoomFactor write SetZoomFactor;
    property Enabled: Boolean read GetEnabled write SetEnabled;

    property Js: IWkeJs read GetJs;

    property Data1: Pointer read GetData1 write SetData1;
    property Data2: Pointer read GetData2 write SetData2;

    property OnTitleChange: TWkeWebViewTitleChangeProc read GetOnTitleChange write SetOnTitleChange;
    property OnURLChange: TWkeWebViewURLChangeProc read GetOnURLChange write SetOnURLChange;
    property OnPaintUpdated: TWkeWebViewPaintUpdatedProc read GetOnPaintUpdated write SetOnPaintUpdated;
    property OnAlertBox: TWkeWebViewAlertBoxProc read GetOnAlertBox write SetOnAlertBox;
    property OnConfirmBox: TWkeWebViewConfirmBoxProc read GetOnConfirmBox write SetOnConfirmBox;
    property OnPromptBox: TWkeWebViewPromptBoxProc read GetOnPromptBox write SetOnPromptBox;
    property OnConsoleMessage: TWkeWebViewConsoleMessageProc read GetOnConsoleMessage write SetOnConsoleMessage;
    property OnNavigation: TWkeWebViewNavigationProc read GetOnNavigation write SetOnNavigation;
    property OnCreateView: TWkeWebViewCreateViewProc read GetOnCreateView write SetOnCreateView;
    property OnDocumentReady: TWkeWebViewDocumentReadyProc read GetOnDocumentReady write SetOnDocumentReady;
    property OnLoadingFinish: TWkeWebViewLoadingFinishProc read GetOnLoadingFinish write SetOnLoadingFinish;

    property OnInvalidate: TWkeInvalidateProc read GetOnInvalidate write SetOnInvalidate;
    property OnContextMenu: TWkeContextMenuProc read GetOnContextMenu write SetOnContextMenu;
    property OnWndProc: TWkeWndProc read GetOnWndProc write SetOnWndProc;
    property OnWndDestory: TWkeWndDestoryProc read GetOnWndDestory write SetOnWndDestory;
  end;

  TWkeWindow = class(TWkeWebView, IWkeWebBase, IWkeWindow)
  private
    FWindowType: wkeWindowType;
    FIsModaling: Boolean;
    FModalCode: Integer;
    FOnClosing: TWkeWindowClosingProc;
    FOnDestroy: TWkeWindowDestroyProc;
  protected
    function GetThis: IWkeWebBase; override;
    function GetTitle: WideString;
    function GetWindowHandle: HWND;
    function GetWindowType: wkeWindowType;
    function GetIsModaling: Boolean;
    function GetModalCode: Integer;
    function GetOnClosing: TWkeWindowClosingProc;
    function GetOnDestroy: TWkeWindowDestroyProc;
    procedure SetTitle(const AValue: WideString);
    procedure SetModalCode(const Value: Integer);
    procedure SetOnClosing(const AValue: TWkeWindowClosingProc);
    procedure SetOnDestroy(const AValue: TWkeWindowDestroyProc);
  protected
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
    
    function  DoClosing: Boolean;
    procedure DoDestroy;

    { IWkeWebBase }
    function GetWindowName: WideString;
    function GetHwnd: HWND;
    function GetResourceInstance: THandle;
    function GetBoundsRect: TRect;
    function GetDrawRect: TRect;
    function GetDrawDC: HDC;
    procedure ReleaseDC(const ADC: HDC);
  public
    constructor Create(type_: wkeWindowType; parent: HWND; x, y, width, height: Integer); overload;
    destructor Destroy; override;
    
    procedure ShowWindow();
    procedure HideWindow();
    procedure EnableWindow(enable: Boolean);
    procedure CloseWindow;
    procedure DestroyWindow;

    function  ShowModal(AParent: HWND = 0): Integer;
    procedure EndModal(nCode: Integer);

    procedure MoveWindow(x, y, width, height: Integer);
    procedure MoveToCenter;
    procedure ResizeWindow(width, height: Integer);

    property Title: WideString read GetTitle write SetTitle;
    property WindowHandle: HWND read GetWindowHandle;
    property WindowType: wkeWindowType read GetWindowType;
    property IsModaling: Boolean read GetIsModaling;
    property ModalCode: Integer read GetModalCode write SetModalCode;
    property OnClosing: TWkeWindowClosingProc read GetOnClosing write SetOnClosing;
    property OnDestroy: TWkeWindowDestroyProc read GetOnDestroy write SetOnDestroy;
  end;

procedure _wkeTitleChangedCallback(webView: WkeTypes.wkeWebView; param: Pointer; const title: wkeString); cdecl;
procedure _wkeURLChangedCallback(webView: WkeTypes.wkeWebView; param: Pointer; const url: wkeString); cdecl;
procedure _wkePaintUpdatedCallback(webView: WkeTypes.wkeWebView; param: Pointer; const hdc: HDC; x, y, cx, cy: Integer); cdecl;
procedure _wkeOnAlertBox(webView: WkeTypes.wkeWebView; param: Pointer; const msg: wkeString); cdecl;
function  _wkeOnConfirmBox(webView: WkeTypes.wkeWebView; param: Pointer; const msg: wkeString): Boolean; cdecl;
function  _wkeOnPromptBox(webView: WkeTypes.wkeWebView; param: Pointer; const msg, defaultResult: wkeString; result_: wkeString): Boolean; cdecl;
procedure _wkeOnConsoleMessage(webView: WkeTypes.wkeWebView; param: Pointer; const msg: PwkeConsoleMessage);cdecl;
function  _wkeOnNavigation(webView: WkeTypes.wkeWebView; param: Pointer; navigationType: wkeNavigationType; const url: wkeString): Boolean;cdecl;
function  _wkeOnCreateView(webView: WkeTypes.wkeWebView; param: Pointer; const info: PwkeNewViewInfo): WkeTypes.wkeWebView; cdecl;
procedure _wkeOnDocumentReady(webView: WkeTypes.wkeWebView; param: Pointer; const info: PwkeDocumentReadyInfo);cdecl;
procedure _wkeOnLoadingFinish(webView: WkeTypes.wkeWebView; param: Pointer; const url: wkeString; result_: wkeLoadingResult; const failedReason: wkeString);cdecl;
function  _OnWindowClosing(webView: WkeTypes.wkeWebView; param: Pointer): Boolean;cdecl;
procedure _OnWindowDestroy(webView: WkeTypes.wkeWebView; param: Pointer);cdecl;


function GET_X_LPARAM(const lp: LPARAM): Integer;
function GET_Y_LPARAM(const lp: LPARAM): Integer;
function GET_WHEEL_DELTA_WPARAM(const wp: WPARAM): Integer;

function GlobalFunction: TStrings;

{$IF CompilerVersion > 18.5}
function ShellExecute(hWnd: HWND; Operation, FileName, Parameters,
  Directory: PWideChar; ShowCmd: Integer): HINST; stdcall; external 'shell32.dll' name 'ShellExecuteW';
{$ELSE}
function ShellExecute(hWnd: HWND; Operation, FileName, Parameters,
  Directory: PAnsiChar; ShowCmd: Integer): HINST; stdcall; external 'shell32.dll' name 'ShellExecuteA';
{$IFEND}

{$IF CompilerVersion <= 18.5}
function UTF8ToWideString(const S: AnsiString): WideString; 
{$IFEND}

implementation

uses
  WkeJs, StrUtils{$IF CompilerVersion > 18.5}, Types{$IFEND};


resourcestring
  SNoTimers = '没有足够的可用计时器';

var
  varGlobalFunction: TStrings = nil;

function GlobalFunction: TStrings;
begin
  if varGlobalFunction = nil then
    varGlobalFunction := TStringList.Create;
  Result := varGlobalFunction;
end;

{$IF CompilerVersion <= 18.5}
function UTF8ToWideString(const S: AnsiString): WideString;
begin
  Result := S;
end;
{$IFEND}

procedure _wkeTitleChangedCallback(webView: WkeTypes.wkeWebView; param: Pointer; const title: wkeString); cdecl;
var
  LWebView: TWkeWebView;
begin
  LWebView := param;
  if @LWebView.FOnTitleChange <> nil then
  try
    LWebView.FOnTitleChange(LWebView, WAPI.wkeGetStringW(title));
  except
    on E: Exception do
    begin
      Trace('[OnTitleChange]'+E.Message);
    end
  end;             
end;

procedure _wkeURLChangedCallback(webView: WkeTypes.wkeWebView; param: Pointer; const url: wkeString); cdecl;
var
  LWebView: TWkeWebView;
begin
  LWebView := param;
  if @LWebView.FOnURLChange <> nil then
  try
    LWebView.FOnURLChange(LWebView, WAPI.wkeGetStringW(url));
  except
    on E: Exception do
    begin
      Trace('[OnURLChange]'+E.Message);
    end
  end;  
end;

procedure _wkePaintUpdatedCallback(webView: WkeTypes.wkeWebView; param: Pointer; const hdc: HDC; x, y, cx, cy: Integer); cdecl;
var
  LWebView: TWkeWebView;
begin
  LWebView := param;
  LWebView.DoPaintUpdated(hdc, x, y, cx, cy);
end;

procedure _wkeOnAlertBox(webView: WkeTypes.wkeWebView; param: Pointer; const msg: wkeString); cdecl;
var
  LWebView: TWkeWebView;
begin
  LWebView := param;
  LWebView.DoAlertBox(msg);
end;

function  _wkeOnConfirmBox(webView: WkeTypes.wkeWebView; param: Pointer; const msg: wkeString): Boolean; cdecl;
var
  LWebView: TWkeWebView;
begin
  LWebView := param;
  Result := LWebView.DoConfirmBox(msg);
end;

function  _wkeOnPromptBox(webView: WkeTypes.wkeWebView; param: Pointer; const msg, defaultResult: wkeString; result_: wkeString): Boolean; cdecl;
var
  LWebView: TWkeWebView;
begin
  LWebView := param;
  Result := LWebView.DoOnPromptBox(msg, defaultResult, result_);
end;

procedure _wkeOnConsoleMessage(webView: WkeTypes.wkeWebView; param: Pointer; const msg: PwkeConsoleMessage);cdecl;
var
  LWebView: TWkeWebView;
begin
  LWebView := param;
  if @LWebView.FOnConsoleMessageProc <> nil then
  try
    LWebView.FOnConsoleMessageProc(LWebView, msg);
  except
    on E: Exception do
    begin
      Trace('[OnConsoleMessageProc]'+E.Message);
    end
  end;
end;

function _wkeOnNavigation(webView: WkeTypes.wkeWebView; param: Pointer;
  navigationType: wkeNavigationType; const url: wkeString): Boolean;cdecl;
var
  LWebView: TWkeWebView;
begin
  LWebView := param;
  Result := LWebView.DoNavigation(navigationType, url);
end;

function  _wkeOnCreateView(webView: WkeTypes.wkeWebView; param: Pointer;
  const info: PwkeNewViewInfo): WkeTypes.wkeWebView; cdecl;
var
  LWebView: TWkeWebView;
begin
  LWebView := param;
  Result := LWebView.DoCreateView(info)
end;

procedure _wkeOnDocumentReady(webView: WkeTypes.wkeWebView; param: Pointer; const info: PwkeDocumentReadyInfo);cdecl;
var
  LWebView: TWkeWebView;
begin
  LWebView := param;
  try
    LWebView.DoDocumentReady(info);
  except
    on E: Exception do
    begin
      Trace('[DoDocumentReady]'+E.Message);
    end
  end;
end;

procedure _wkeOnLoadingFinish(webView: WkeTypes.wkeWebView; param: Pointer;
  const url: wkeString; result_: wkeLoadingResult; const failedReason: wkeString);cdecl;
var
  LWebView: TWkeWebView;
begin
  LWebView := param;
  try
    LWebView.DoLoadingFinish(url, result_, failedReason);
  except
    on E: Exception do
    begin
      Trace('[DoLoadingFinish]'+E.Message);
    end
  end;
end;

function _OnWindowClosing(webView: WkeTypes.wkeWebView; param: Pointer): Boolean;cdecl;
var
  LWindow: TWkeWindow;
begin
  LWindow := param;
  Result := LWindow.DoClosing;
end;

procedure _OnWindowDestroy(webView: WkeTypes.wkeWebView; param: Pointer);cdecl;
var
  LWindow: TWkeWindow;
begin
  LWindow := param;
  LWindow.DoDestroy;
end;


function GET_X_LPARAM(const lp: LPARAM): Integer;
begin
  Result := Integer(short(LOWORD(lp)));
end;

function GET_Y_LPARAM(const lp: LPARAM): Integer;
begin
  Result := Integer(short(HIWORD(lp)));
end;

function GET_WHEEL_DELTA_WPARAM(const wp: WPARAM): Integer;
begin
  Result := Integer(short(HIWORD(wp)));
end;

{ TTimer }

constructor TWkeTimer.Create();
begin
  inherited;
  FEnabled := False;
  FInterval := 1000;
  FWindowHandle := Classes.AllocateHWnd(WndProc);
end;

destructor TWkeTimer.Destroy;
begin
  FEnabled := False;
  UpdateTimer;
  Classes.DeallocateHWnd(FWindowHandle);
  inherited Destroy;
end;

procedure TWkeTimer.WndProc(var Msg: TMessage);
begin
  with Msg do
    if Msg = WM_TIMER then
    try
      Timer;
    except
      on e: Exception do
      begin
        Trace('[TTimer.WndProc]'+e.Message);
        raise;
      end;
    end
    else
      Result := DefWindowProc(FWindowHandle, Msg, wParam, lParam);
end;

procedure TWkeTimer.UpdateTimer;
begin
  KillTimer(FWindowHandle, 1);
  if (FInterval <> 0) and FEnabled and Assigned(FOnTimer) then
    if SetTimer(FWindowHandle, 1, FInterval, nil) = 0 then
      raise EOutOfResources.Create(SNoTimers);
end;

procedure TWkeTimer.SetEnabled(Value: Boolean);
begin
  if Value <> FEnabled then
  begin
    FEnabled := Value;
    UpdateTimer;
  end;
end;

procedure TWkeTimer.SetInterval(Value: Cardinal);
begin
  if Value <> FInterval then
  begin
    FInterval := Value;
    UpdateTimer;
  end;
end;

procedure TWkeTimer.SetOnTimer(Value: TNotifyEvent);
begin
  FOnTimer := Value;
  UpdateTimer;
end;

procedure TWkeTimer.Timer;
begin
  if Assigned(FOnTimer) then FOnTimer(Self);
end;

{ TWkeWebView }

procedure TWkeWebView.AddDirtyArea(x, y, w, h: Integer);
begin
  WAPI.wkeAddDirtyArea(FWebView, x, y, w, h);
end;

procedure TWkeWebView.Wake;
begin
  WAPI.wkeWake(FWebView);
end;

function TWkeWebView.CanGoBack: Boolean;
begin
  Result := WAPI.wkeCanGoBack(FWebView);
end;

function TWkeWebView.CanGoForward: Boolean;
begin
  Result := WAPI.wkeCanGoForward(FWebView); 
end;

procedure TWkeWebView.Close;
begin
  if FDestroying then
    Exit;
  if this.GetHwnd <> 0 then
  begin
    CloseWindow(this.GetHwnd);
  end;
end;

function TWkeWebView.ContextMenuEvent(x, y: Integer; flags: UINT): Boolean;
begin
  Result := False;
  if FDestroying then
    Exit;
  Result := WAPI.wkeFireContextMenuEvent(FWebView, x, y, flags);

  if @FOnContextMenu <> nil then
  try
    FOnContextMenu(Self, x, y, flags);
  except
    on E: Exception do
    begin
      Trace('[TWkeWebView.OnContextMenu]'+E.Message);
    end
  end;             
end;

procedure TWkeWebView.EditerCopy;
begin
  WAPI.wkeEditorCopy(FWebView);
end;

constructor TWkeWebView.Create(const AThis: IWkeWebBase);
begin
  Create(AThis, WAPI.wkeCreateWebView, True);
end;

constructor TWkeWebView.Create(const AThis: IWkeWebBase; const AWebView: TWebView;
  const AOwnView: Boolean);
begin
  FWebView := AWebView;
  FOwnView := AOwnView;
  FThis := Pointer(AThis);
  FObjectList := TWkeJsObjectList.Create;

//  Trace('wkeOnTitleChanged'+ IntToStr(Integer(@WAPI.wkeOnTitleChanged)));
//  Trace('wkeOnURLChanged'+ IntToStr(Integer(@WAPI.wkeOnURLChanged)));
//  Trace('wkeOnPaintUpdated'+ IntToStr(Integer(@WAPI.wkeOnPaintUpdated)));
//  Trace('wkeOnAlertBox'+ IntToStr(Integer(@WAPI.wkeOnAlertBox)));
//  Trace('wkeOnConfirmBox'+ IntToStr(Integer(@WAPI.wkeOnConfirmBox)));
//  Trace('wkeOnPromptBox'+ IntToStr(Integer(@WAPI.wkeOnPromptBox)));
//  Trace('wkeOnConsoleMessage'+ IntToStr(Integer(@WAPI.wkeOnConsoleMessage)));
//  Trace('wkeOnNavigation'+ IntToStr(Integer(@WAPI.wkeOnNavigation)));
//  Trace('wkeOnCreateView'+ IntToStr(Integer(@WAPI.wkeOnCreateView)));
//  Trace('wkeOnDocumentReady'+ IntToStr(Integer(@WAPI.wkeOnDocumentReady)));
//  Trace('wkeOnLoadingFinish'+ IntToStr(Integer(@WAPI.wkeOnLoadingFinish)));
//  Trace('wkeSetUserAgent'+ IntToStr(Integer(@WAPI.wkeSetUserAgent)));
//  Trace('wkeSetUserData'+ IntToStr(Integer(@WAPI.wkeSetUserData)));

  WAPI.wkeOnTitleChanged(FWebView, _wkeTitleChangedCallback, Self);
  WAPI.wkeOnURLChanged(FWebView, _wkeURLChangedCallback, Self);
  WAPI.wkeOnPaintUpdated(FWebView, _wkePaintUpdatedCallback, Self);
  WAPI.wkeOnAlertBox(FWebView, _wkeOnAlertBox, Self);
  WAPI.wkeOnConfirmBox(FWebView, _wkeOnConfirmBox, Self);
  WAPI.wkeOnPromptBox(FWebView, _wkeOnPromptBox, Self);
  WAPI.wkeOnConsoleMessage(FWebView, _wkeOnConsoleMessage, Self);
  WAPI.wkeOnNavigation(FWebView, _wkeOnNavigation, Self);
  WAPI.wkeOnCreateView(FWebView, _wkeOnCreateView, Self);
  WAPI.wkeOnDocumentReady(FWebView, _wkeOnDocumentReady, Self);
  WAPI.wkeOnLoadingFinish(FWebView, _wkeOnLoadingFinish, Self);

  WAPI.wkeSetUserAgent(FWebView, 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36');

  FWebViewUpdateTimer := TWkeTimer.Create;
  FWebViewUpdateTimer.Interval := 50;
  FWebViewUpdateTimer.OnTimer := DoWebViewUpdateTimer;
  FWebViewUpdateTimer.Enabled := True;

  FInvalidate := False;

  WAPI.wkeSetUserData(FWebView, Self);
end;

procedure TWkeWebView.EditerCut;
begin
  WAPI.wkeEditorCut(FWebView);
end;

procedure TWkeWebView.EditerDelete;
begin
  WAPI.wkeEditorDelete(FWebView);
end;

destructor TWkeWebView.Destroy;
begin
  FDestroying := True;
  StopLoading;
  if FWebViewUpdateTimer <> nil then
  begin
    FWebViewUpdateTimer.OnTimer := nil;
    FWebViewUpdateTimer.Enabled := False;
    FreeAndNil(FWebViewUpdateTimer);
  end;
  FThis := nil;
  if FObjectList <> nil then
  begin
    FObjectList.RemoveListener(DoRegObjectsNotify);
    FObjectList := nil;
  end;
  if (FWebView <> nil) and (WAPI <> nil) then
  begin
    Wke.GlobalObjects.RemoveListener(DoRegObjectsNotify);
    WAPI.wkeOnTitleChanged(FWebView, nil, nil);
    WAPI.wkeOnURLChanged(FWebView, nil, nil);
    WAPI.wkeOnPaintUpdated(FWebView, nil, nil);
    WAPI.wkeOnAlertBox(FWebView, nil, nil);
    WAPI.wkeOnConfirmBox(FWebView, nil, nil);
    WAPI.wkeOnPromptBox(FWebView, nil, nil);
    WAPI.wkeOnConsoleMessage(FWebView, nil, nil);
    WAPI.wkeOnNavigation(FWebView, nil, nil);
    WAPI.wkeOnCreateView(FWebView, nil, nil);
    WAPI.wkeOnDocumentReady(FWebView, nil, nil);
    WAPI.wkeOnLoadingFinish(FWebView, nil, nil);
  end;

  FJs := nil;
  if FWebView <> nil then
  begin
    WAPI.wkeSetUserData(FWebView, nil);
    if FOwnView then
    begin
      WAPI.wkeDestroyWebView(FWebView);
    end;
    FWebView := nil;
  end;

  inherited;
end;

procedure TWkeWebView.DoWebViewUpdateTimer(Sender: TObject);
  function _BytesPerScanline(PixelsPerScanline, BitsPerPixel, Alignment: Longint): Longint;
  begin
    Dec(Alignment);
    Result := ((PixelsPerScanline * BitsPerPixel) + Alignment) and not Alignment;
    Result := Result div 8;
  end;
var
  BufferDC, wndDC: HDC;
  rcDraw, rcClip: TRect;
  BitmapInfo: TBitmapInfo;
  BufferBitmap, OldBitmap: HBitmap;
  BufferBits  : Pointer;
  w, h, i, iRow: Integer;
  p, s, s1: Pointer;
  pt, ptWnd: TPoint;
  sz: TSize;
  bf: _BLENDFUNCTION;
  bHandled: Boolean;
begin
  if FDestroying then
    Exit;
  if FWebView = nil then Exit;
  if FThis = nil then Exit;
    
  if (not IsIconic(this.GetHwnd)) and IsDirty and IsWindowVisible(This.GetHwnd) then
  begin
    FInvalidate := False;
    w := GetWidth;
    h := GetHeight;

    if (w = 0) and (h = 0) then
      Exit;

    if @FOnInvalidate <> nil then
    try
      bHandled := False;
      FOnInvalidate(Self, bHandled);
      if bHandled then
        Exit;
    except
      on E: Exception do
      begin
        Trace('[TWkeWebView.DoWebViewUpdateTimer]'+E.Message);
        Exit;
      end
    end;  
    
    wndDC := 0;
    if not Transparent then
    begin
      wndDC := This.GetDrawDC;
      if wndDC = 0 then
        Exit;
    end;
    try
      if not Transparent then
      begin
        GetClipBox(wndDC, rcClip);
        if IntersectClipRect(wndDC, rcClip.Left, rcClip.Top, rcClip.Right, rcClip.Bottom) in [NULLREGION, ERROR] then
          Exit;
      end;

      BufferDC := CreateCompatibleDC(0);
      try
        Fillchar(BitmapInfo, sizeof(BitmapInfo), #0);
        with BitmapInfo.bmiHeader do
        begin
          biSize     := SizeOf(TBitmapInfoHeader);
          biWidth    := w;
          biHeight   := h;
          biPlanes   := 1;
          biBitCount := 32;
          biCompression := BI_RGB;
        end;
        BufferBitmap := CreateDIBSection(BufferDC, BitmapInfo, DIB_RGB_COLORS, BufferBits, 0, 0);
        try
          OldBitmap := SelectObject(BufferDC, BufferBitmap);
          try
            GetMem(p, h * w * 4);
            try
              Paint(p, 0);
              s := p;
              for i := 0 to h - 1 do
              begin
                iRow := i;
                if BitmapInfo.bmiHeader.biHeight > 0 then  // bottom-up DIB
                  iRow := BitmapInfo.bmiHeader.biHeight - iRow - 1;
              
                Integer(s1) := Integer(BufferBits) +
                      iRow * _BytesPerScanline(BitmapInfo.bmiHeader.biWidth, BitmapInfo.bmiHeader.biBitCount, 32);
      
                Move(s^, s1^, w*4);
                Inc(Integer(s), w*4);
              end;
            finally
              FreeMem(p);
            end;

            if Transparent then
            begin
              rcDraw := This.GetDrawRect;
              pt := Point(0, 0);
              ptWnd := pt;
              ClientToScreen(this.GetHwnd, ptWnd);
              sz.cx := w;
              sz.cY := h;
              bf.BlendOp := AC_SRC_OVER;
              bf.BlendFlags := 0;
              bf.SourceConstantAlpha := 255;
              bf.AlphaFormat := AC_SRC_ALPHA;
              UpdateLayeredWindow(this.GetHwnd, 0, @ptWnd, @sz, BufferDC, @pt, $FFFFFF, @BF, ULW_ALPHA);
            end
            else
            begin
              rcDraw := This.GetDrawRect;
              BitBlt(wndDC, rcDraw.Left, rcDraw.Top, rcDraw.Right-rcDraw.Left, rcDraw.Bottom-rcDraw.Top,
                BufferDC, 0, 0, SRCCOPY);
            end;
          finally
            SelectObject(BufferDC, OldBitmap);
          end;
        finally
          if BufferBitmap <> 0 then DeleteObject(BufferBitmap);
        end;
      finally
        if BufferDC <> 0 then
          DeleteDC(BufferDC);
      end;
    finally
      if wndDC <> 0 then
        this.ReleaseDC(wndDC);
    end;
  end;
end;

procedure TWkeWebView.SetFocus;
begin
  if FDestroying then
    Exit;
  WAPI.wkeSetFocus(FWebView);
  FIsFocused := True;
end;

function TWkeWebView.GetCaretRect: wkeRect;
begin
  Result := WAPI.wkeGetCaretRect(FWebView);
end;

function TWkeWebView.GetContentHeight: Integer;
begin
  Result := WAPI.wkeGetContentHeight(FWebView);
end;

function TWkeWebView.GetContentWidth: Integer;
begin
  Result := WAPI.wkeGetContentWidth(FWebView);
end;

function TWkeWebView.GetCookieEnabled: Boolean;
begin
  Result := WAPI.wkeIsCookieEnabled(FWebView);
end;

function TWkeWebView.GetData1: Pointer;
begin
  Result := FData1;
end;

function TWkeWebView.GetData2: Pointer;
begin
  Result := FData2;
end;

function TWkeWebView.GetDirty: Boolean;
begin
  Result := FInvalidate or WAPI.wkeIsDirty(FWebView);
end;

function TWkeWebView.GetEnabled: Boolean;
begin
  Result := IsWindowEnabled(this.GetHwnd);
end;

function TWkeWebView.GetFocused: Boolean;
begin
  Result := FIsFocused;
end;

function TWkeWebView.GetHeight: Integer;
begin
  Result := WAPI.wkeGetHeight(FWebView);
end;

function TWkeWebView.GetJs: IWkeJs;
begin
  if FJs = nil then
    FJs := TwKeJs.Create(FWebView);

  Result := FJs;
end;

function TWkeWebView.GetMediaVolume: float;
begin
  Result := WAPI.wkeGetMediaVolume(FWebView);
end;

function TWkeWebView.GetName: WideString;
begin
  Result := UTF8ToWideString(WAPI.wkeGetName(FWebView));
end;

function TWkeWebView.GetOnPaintUpdated: TWkeWebViewPaintUpdatedProc;
begin
  Result := FOnPaintUpdated;
end;

function TWkeWebView.GetOnContextMenu: TWkeContextMenuProc;
begin
  Result := FOnContextMenu;
end;

function TWkeWebView.GetOnInvalidate: TWkeInvalidateProc;
begin
  Result := FOnInvalidate;
end;

function TWkeWebView.GetOnTitleChange: TWkeWebViewTitleChangeProc;
begin
  Result := FOnTitleChange;
end;

function TWkeWebView.GetOnURLChange: TWkeWebViewURLChangeProc;
begin
  Result := FOnURLChange;
end;

function TWkeWebView.GetOnWndDestory: TWkeWndDestoryProc;
begin
  Result := FOnWndDestory;
end;

function TWkeWebView.GetOnWndProc: TWkeWndProc;
begin
  Result := FOnWndProc;
end;

function TWkeWebView.GetThis: IWkeWebBase;
begin
  Result := IWkeWebBase(FThis)
end;

function TWkeWebView.GetTitle: WideString;
begin
  Result := WAPI.wkeGetTitleW(FWebView);
end;

function TWkeWebView.GetTransparent: Boolean;
begin
  Result := WAPI.wkeIsTransparent(FWebView); 
end;

function TWkeWebView.GetUserAgent: WideString;
begin
  Result := FUserAgent;
end;

function TWkeWebView.GetViewDC: Pointer;
begin
  Result := WAPI.wkeGetViewDC(FWebView);
end;

function TWkeWebView.GetWebView: TWebView;
begin
  Result := FWebView;
end;

function TWkeWebView.GetWidth: Integer;
begin
  Result := WAPI.wkeGetWidth(FWebView);
end;

function TWkeWebView.GetZoomFactor: float;
begin
  Result := WAPI.wkeGetZoomFactor(FWebView);
end;

function TWkeWebView.GlobalExec: jsExecState;
begin
  Result := WAPI.wkeGlobalExec(FWebView);
end;

function TWkeWebView.GoBack: Boolean;
begin
  Result := WAPI.wkeGoBack(FWebView);
end;

function TWkeWebView.GoForward: Boolean;
begin
  Result := WAPI.wkeGoForward(FWebView); 
end;

procedure TWkeWebView.Hide;
begin
  if FDestroying then
    Exit;
    
  ShowWindow(this.GetHwnd, SW_HIDE);
end;

procedure TWkeWebView.Invalidate;
begin
  FInvalidate := True;
end;

function TWkeWebView.IsAwake: Boolean;
begin
  Result := WAPI.wkeIsAwake(FWebView); 
end;

function TWkeWebView.IsDocumentReady: Boolean;
begin
  Result := WAPI.wkeIsDocumentReady(FWebView); 
end;

function TWkeWebView.IsLoadComplete: Boolean;
begin
  Result := WAPI.wkeIsLoadingCompleted(FWebView);
end;

function TWkeWebView.IsLoadSucceeded: Boolean;
begin
  Result := WAPI.wkeIsLoadingSucceeded(FWebView); 
end;

function TWkeWebView.IsLoadFailed: Boolean;
begin
  Result := WAPI.wkeIsLoadingFailed(FWebView);
end;

function TWkeWebView.IsLoading: Boolean;
begin
  Result := WAPI.wkeIsLoading(FWebView);
end;

function TWkeWebView.IsShowing: Boolean;
begin
  Result := IsWindowVisible(this.GetHwnd)
end;

function TWkeWebView.KeyDown(virtualKeyCode, flags: UINT;
  systemKey: Boolean): Boolean;
begin
  Result := False;
  if FDestroying then
    Exit;
  Result := WAPI.wkeFireKeyDownEvent(FWebView, virtualKeyCode, flags, systemKey);
end;

function TWkeWebView.KeyPress(charCode: UINT; flags: UINT;
  systemKey: Boolean): Boolean;
begin
  Result := False;
  if FDestroying then
    Exit;
  Result := WAPI.wkeFireKeyPressEvent(FWebView, charCode, flags, systemKey)
end;

function TWkeWebView.KeyUp(virtualKeyCode, flags: UINT;
  systemKey: Boolean): Boolean;
begin
  Result := False;
  if FDestroying then
    Exit;
  Result := WAPI.wkeFireKeyUpEvent(FWebView, virtualKeyCode, flags, systemKey)
end;

procedure TWkeWebView.LayoutIfNeeded;
begin
  WAPI.wkeLayoutIfNeeded(FWebView);
end;

procedure TWkeWebView.Load(const str: PUtf8);
begin
  WAPI.wkeLoad(FWebView, str);
end;

procedure TWkeWebView.Load(const str: WideString);
begin
  WAPI.wkeLoadW(FWebView, PWideChar(str));
end;

procedure TWkeWebView.LoadFile(const filename: WideString);
var
  sFile: WideString;
begin
  DoBeforeLoadHtml();
  try
    sFile := StringReplace(filename, '/', '\', [rfReplaceAll]);
    if AnsiStartsText('file:', sFile) then
    begin
      sFile := System.Copy(sFile, 6, MaxInt);
      if sFile[1] = '\' then
        System.Delete(sFile, 1, 1);
      if sFile[1] = '\' then
        System.Delete(sFile, 1, 1);
      if sFile[1] = '\' then
        System.Delete(sFile, 1, 1);
    end;

    CurrentLoadDir := ExtractFilePath(sFile);

    sFile := EncodeURI(sFile);
         
    WAPI.wkeLoadFileW(FWebView, PUnicodeChar(sFile));
    DoAfterLoadHtml();
  except
    on E: Exception do
    begin
      Trace('[TWkeWebView.LoadFile]'+E.Message);
    end
  end;
end;

procedure TWkeWebView.LoadHTML(const html: PUtf8);
begin
  DoBeforeLoadHtml();
  WAPI.wkeLoadHTML(FWebView, html);
  DoAfterLoadHtml();
end;

procedure TWkeWebView.LoadHTML(const html: WideString);
begin
  DoBeforeLoadHtml();
  WAPI.wkeLoadHTMLW(FWebView, PUnicodeChar(html));
  DoAfterLoadHtml();
end;

procedure TWkeWebView.LoadURL(const url: WideString);
begin
  DoBeforeLoadHtml();
  WAPI.wkeLoadURLW(FWebView, PUnicodeChar(url));
  DoAfterLoadHtml();
end;

function TWkeWebView.MouseEvent(msg: UINT; x, y: Integer;
  flags: UINT): Boolean;
begin
  Result := False;
  if FDestroying then
    Exit;
  Result := WAPI.wkeFireMouseEvent(FWebView, msg, x, y, flags)
end;

function TWkeWebView.MouseWheel(x, y, delta: Integer;
  flags: UINT): Boolean;
begin
  Result := False;
  if FDestroying then
    Exit;
  Result := WAPI.wkeFireMouseWheelEvent(FWebView, x, y, delta, flags)
end;

procedure TWkeWebView.Paint(bits: Pointer; pitch: Integer);
begin
  WAPI.wkePaint2(FWebView, bits, pitch);
end;

procedure TWkeWebView.Paint(bits: Pointer; bufWid, bufHei, xDst, yDst, w,
  h, xSrc, ySrc: Integer; bCopyAlpha: Boolean);
begin
  WAPI.wkePaint(FWebView, bits, bufWid, bufHei, xDst, yDst, w, h, xSrc, ySrc, bCopyAlpha);
end;

procedure TWkeWebView.EditerPaste;
begin
  WAPI.wkeEditorPaste(FWebView);
end;

procedure TWkeWebView.PostURL(const url: WideString;
  const postData: PAnsiChar; postLen: Integer);
begin
  WAPI.wkePostURLW(FWebView, PUnicodeChar(url), postData, postLen);
end;

function TWkeWebView.ProcND(msg: UINT; wParam: WPARAM; lParam: LPARAM;
  var pbHandled: Boolean): LRESULT;
var
  flags, virtualKeyCode, charCode: UINT;
  caret:wkeRect;
  form: TCandidateForm;
  compForm: TCompositionForm;
  hIMC, delta, x, y: Integer;
  pt: TPoint;
  rcClient: TRect;
  i: Integer;
  imc: Imm.HIMC;
  p: PChar;
  hParent: HWND;
  bSystemKey: Boolean;
begin
  Result := 0;
  if FDestroying then
    Exit;

  case Msg of
    WM_GETDLGCODE:
    begin
      Result := DLGC_WANTALLKEYS or DLGC_WANTTAB or DLGC_WANTARROWS or DLGC_WANTCHARS or DLGC_HASSETSEL;
      pbHandled := True;
    end;
    WM_COMMAND:
    begin
      {wmId    := LOWORD(wParam);
      wmEvent := HIWORD(wParam);}

      hParent := GetParent(this.GetHwnd);
      if hParent <> 0 then
      begin
        Result := SendMessage(hParent, Msg, wParam, lParam);
        pbHandled := True;
      end;
    end;
    WM_SIZE:
    begin
      Resize(LOWORD(lParam), HIWORD(lParam));
    end;
    WM_SYSKEYDOWN,
    WM_KEYDOWN:
    begin
      virtualKeyCode := WParam;
      bSystemKey := msg = WM_SYSKEYDOWN;
        
      flags := 0;
      if HiWord(lParam) and KF_REPEAT <> 0 then
        flags := flags or WKE_REPEAT
      else
      if HiWord(lParam) and KF_EXTENDED <> 0 then
        flags := flags or WKE_EXTENDED;

      if KeyDown(virtualKeyCode, flags, bSystemKey) then
        pbHandled := True;
    end;
    WM_SYSKEYUP,
    WM_KEYUP:
    begin
      virtualKeyCode := wParam;
      bSystemKey := msg = WM_SYSKEYUP;
        
      flags := 0;
      if HiWord(lParam) and KF_REPEAT <> 0 then
        flags := flags or WKE_REPEAT
      else
      if HiWord(lParam) and KF_EXTENDED <> 0 then
        flags := flags or WKE_EXTENDED;

      if KeyUp(virtualKeyCode, flags, bSystemKey) then
        pbHandled := True;
    end;
    WM_IME_COMPOSITION:
    begin
      if ((lParam and GCS_RESULTSTR) <> 0) then
      begin
        imc := ImmGetContext(this.GetHwnd);
        try
          FImeCount := ImmGetCompositionString(imc, GCS_RESULTSTR, nil, 0);
          GetMem(p, FImeCount + 1);
          try
            ImmGetCompositionString(imc, GCS_RESULTSTR, p, FImeCount);
            p[FImeCount] := #0;

            FImeResult := p;
          finally
            FreeMem(p, FImeCount + 1);
          end;
        finally
          ImmReleaseContext(this.GetHwnd, imc);
        end;
      end;
    end;
    WM_IME_ENDCOMPOSITION:
    begin
      if (Length(FImeResult) > 0) then
      begin
        for i := 1 to Length(FImeResult) do
        begin
          if FImeResult[i] = #0 then
            continue;
          KeyPress(Ord(FImeResult[i]), 0, False)
        end;
        FImeResult := '';
      end;
    end;
    WM_SYSCHAR,
    WM_CHAR:
    begin
      charCode := WParam;
      bSystemKey := msg = WM_SYSCHAR;

      flags := 0;
      if HiWord(lParam) and KF_REPEAT <> 0 then
        flags := flags or WKE_REPEAT
      else
      if HiWord(lParam) and KF_EXTENDED <> 0 then
        flags := flags or WKE_EXTENDED;

      if (Length(FImeResult) > 0) then
      begin
        for i := 1 to Length(FImeResult) do
        begin
          if FImeResult[i] = #0 then
            continue;
          KeyPress(Ord(FImeResult[i]), flags, bSystemKey)
        end;
        FImeResult := '';
      end;

      if (FImeCount > 0) then
      begin
        Dec(FImeCount);
        pbHandled := True;
        Exit;
      end;

      if KeyPress(charCode, flags, bSystemKey) then
        pbHandled := True;
    end;
    WM_SETCURSOR:
    begin
      Result := 0;
      pbHandled := True;
    end;
    WM_LBUTTONDOWN,
    WM_MBUTTONDOWN,
    WM_RBUTTONDOWN,
    WM_LBUTTONDBLCLK,
    WM_MBUTTONDBLCLK,
    WM_RBUTTONDBLCLK,

    WM_LBUTTONUP,
    WM_MBUTTONUP,
    WM_RBUTTONUP,
      
    WM_MOUSEMOVE:
    begin
      if (Msg = WM_LBUTTONDOWN) or (Msg = WM_MBUTTONDOWN) or (Msg = WM_RBUTTONDOWN) then
      begin
        Windows.SetFocus(This.GetHwnd);
        Windows.SetCapture(This.GetHwnd);
      end
      else
      if (Msg = WM_LBUTTONUP) or (Msg = WM_MBUTTONUP) or (Msg = WM_RBUTTONUP) then
      begin
        Windows.ReleaseCapture;
      end;

      Windows.GetClientRect(This.GetHwnd, rcClient);

      x := GET_X_LPARAM(LParam) - rcClient.Left;
      y := GET_Y_LPARAM(LParam) - rcClient.Top;

      flags := 0;
      if WParam and MK_CONTROL <> 0 then
        flags := flags or WKE_CONTROL;
      if WParam and MK_SHIFT <> 0 then
        flags := flags or WKE_SHIFT;

      if WParam and MK_LBUTTON <> 0 then
        flags := flags or WKE_LBUTTON;
      if WParam and MK_MBUTTON <> 0 then
        flags := flags or WKE_MBUTTON;
      if WParam and MK_RBUTTON <> 0 then
        flags := flags or WKE_RBUTTON;
          
      if MouseEvent(Msg, x, y, flags) then
        pbHandled := True;
    end;

    WM_CONTEXTMENU:
    begin
      pt.X := GET_X_LPARAM(lParam);
      pt.Y := GET_Y_LPARAM(lParam);
        
      if (pt.X <> -1) and (pt.Y <> -1) then
        Windows.ScreenToClient(this.GetHwnd, pt);

      flags := 0;
      if WParam and MK_CONTROL <> 0 then
        flags := flags or WKE_CONTROL;
      if WParam and MK_SHIFT <> 0 then
        flags := flags or WKE_SHIFT;

      if WParam and MK_LBUTTON <> 0 then
        flags := flags or WKE_LBUTTON;
      if WParam and MK_MBUTTON <> 0 then
        flags := flags or WKE_MBUTTON;
      if WParam and MK_RBUTTON <> 0 then
        flags := flags or WKE_RBUTTON;

      if ContextMenuEvent(pt.X, pt.Y, flags) then
        pbHandled := True;
    end;
    WM_MOUSEWHEEL:
    begin
      pt.X := GET_X_LPARAM(lParam);
      pt.Y := GET_Y_LPARAM(lParam);
        
      Windows.ScreenToClient(This.GetHwnd, pt);

      delta := GET_WHEEL_DELTA_WPARAM(wParam);
        
      flags := 0;
      if WParam and MK_CONTROL <> 0 then
        flags := flags or WKE_CONTROL;
      if WParam and MK_SHIFT <> 0 then
        flags := flags or WKE_SHIFT;

      if WParam and MK_LBUTTON <> 0 then
        flags := flags or WKE_LBUTTON;
      if WParam and MK_MBUTTON <> 0 then
        flags := flags or WKE_MBUTTON;
      if WParam and MK_RBUTTON <> 0 then
        flags := flags or WKE_RBUTTON;

      if MouseWheel(pt.X, pt.Y, delta, flags) then
        pbHandled := True;
    end;
    WM_SETFOCUS:
    begin
      SetFocus;
    end;
    WM_KILLFOCUS:
    begin
      KillFocus;
    end;
    WM_IME_STARTCOMPOSITION:
    begin
      caret := GetCaretRect;

      rcClient := this.GetBoundsRect;

      ZeroMemory(@form, SizeOf(TCandidateForm));
      ZeroMemory(@compForm, SizeOf(TCompositionForm));

      form.dwIndex := 0;
      form.dwStyle := CFS_EXCLUDE;
      form.ptCurrentPos.x := caret.x + rcClient.left;
      form.ptCurrentPos.y := caret.y + rcClient.top + 5;
      form.rcArea.top := caret.y + rcClient.top;
      form.rcArea.bottom := caret.y + caret.h + rcClient.top;
      form.rcArea.left := caret.x + rcClient.left;
      form.rcArea.right := caret.x + caret.w + rcClient.left;

      compForm.ptCurrentPos := form.ptCurrentPos;
      compForm.rcArea := form.rcArea;
      compForm.dwStyle := CFS_POINT;

      hIMC := ImmGetContext(This.GetHwnd);
      try
        ImmSetCandidateWindow(hIMC, @form);
        ImmSetCompositionWindow(hIMC, @compForm);
      finally
        ImmReleaseContext(This.GetHwnd, hIMC);
      end;   

      pbHandled := True;
    end;
    WM_ERASEBKGND,
    WM_NCPAINT:
    begin
      Result := 0;
      pbHandled := True;
    end;
    WM_PAINT:
    begin
      Invalidate;
    end;
  end;
end;

procedure TWkeWebView.Reload;
begin
  WAPI.wkeReload(FWebView);
end;

procedure TWkeWebView.Resize(w, h: Integer);
begin
  if FDestroying then
    Exit;
    
  WAPI.wkeResize(FWebView, w, h);
end;

function TWkeWebView.RunJS(const script: PUtf8): jsValue;
begin
  Result := 0;
  if FDestroying then
    Exit;
  Result := WAPI.wkeRunJS(FWebView, script)
end;

function TWkeWebView.RunJS(const script: WideString): jsValue;
begin
  Result := 0;
  if FDestroying then
    Exit;
  Result := WAPI.wkeRunJSW(FWebView, PUnicodeChar(script))
end;

procedure TWkeWebView.EditerSelectAll;
begin
  WAPI.wkeEditorSelectAll(FWebView);
end;

procedure TWkeWebView.SetCookieEnabled(const Value: Boolean);
begin
  WAPI.wkeSetCookieEnabled(FWebView, Value);
end;

procedure TWkeWebView.SetData1(const Value: Pointer);
begin
  FData1 := Value;
end;

procedure TWkeWebView.SetData2(const Value: Pointer);
begin
  FData2 := Value;
end;

procedure TWkeWebView.SetDirty(const Value: Boolean);
begin
  WAPI.wkeSetDirty(FWebView, Value);
end;

procedure TWkeWebView.SetEditable(editable: Boolean);
begin
  WAPI.wkeSetEditable(FWebView, editable);
end;

procedure TWkeWebView.SetEnabled(const Value: Boolean);
begin
  EnableWindow(this.GetHwnd, Value)
end;

procedure TWkeWebView.SetMediaVolume(const Value: float);
begin
  WAPI.wkeSetMediaVolume(FWebView, Value);
end;

procedure TWkeWebView.SetName(const Value: WideString);
begin
  WAPI.wkeSetName(FWebView, PAnsiChar(AnsiString(Value)));
end;

procedure TWkeWebView.SetOnPaintUpdated(
  const Value: TWkeWebViewPaintUpdatedProc);
begin
  FOnPaintUpdated := Value;
end;

procedure TWkeWebView.SetOnContextMenu(const Value: TWkeContextMenuProc);
begin
  FOnContextMenu := Value;
end;

procedure TWkeWebView.SetOnInvalidate(const Value: TWkeInvalidateProc);
begin
  FOnInvalidate := Value;
end;

procedure TWkeWebView.SetOnTitleChange(
  const Value: TWkeWebViewTitleChangeProc);
begin
  FOnTitleChange := Value;
end;

procedure TWkeWebView.SetOnURLChange(
  const Value: TWkeWebViewURLChangeProc);
begin
  FOnURLChange := Value;
end;

procedure TWkeWebView.SetOnWndDestory(const Value: TWkeWndDestoryProc);
begin
  FOnWndDestory := Value;
end;

procedure TWkeWebView.SetOnWndProc(const Value: TWkeWndProc);
begin
  FOnWndProc := Value;
end;

procedure TWkeWebView.SetTransparent(const Value: Boolean);
begin
  WAPI.wkeSetTransparent(FWebView, Value);
end;

procedure TWkeWebView.SetUserAgent(const Value: WideString);
begin
  if Value = FUserAgent then
    Exit;

  FUserAgent := Value;
  WAPI.wkeSetUserAgentW(FWebView, PUnicodeChar(FUserAgent));
end;

procedure TWkeWebView.SetZoomFactor(const Value: float);
begin
  WAPI.wkeSetZoomFactor(FWebView, Value);
end;

procedure TWkeWebView.Show(nCmdShow: Integer);
begin
  if FDestroying then
    Exit;
    
  ShowWindow(This.GetHwnd, nCmdShow);
end;

procedure TWkeWebView.Sleep;
begin
  WAPI.wkeSleep(FWebView);
end;

procedure TWkeWebView.StopLoading;
begin
  if FWebView <> nil then
    WAPI.wkeStopLoading(FWebView);
end;

procedure TWkeWebView.KillFocus;
begin
  if FDestroying then
    Exit;
  WAPI.wkeKillFocus(FWebView);
  FIsFocused := False;
end;

procedure TWkeWebView.Update;
begin
  WAPI.wkeUpdate;
end;

function TWkeWebView._AddRef: Integer;
begin
  if FDestroying then
    Result := FRefCount
  else
    Result := inherited _AddRef;
end;

function TWkeWebView._Release: Integer;
begin
  if FDestroying then
    Result := FRefCount           
  else
    Result := inherited _Release;
end;

procedure TWkeWebView.RepaintIfNeeded;
begin
  WAPI.wkeRepaintIfNeeded(FWebView);
end;

function TWkeWebView.GetCookie: WideString;
begin
  Result := WAPI.wkeGetCookieW(FWebView);
end;

function TWkeWebView.GetOnAlertBox: TWkeWebViewAlertBoxProc;
begin
  Result := FOnAlertBoxProc;
end;

function TWkeWebView.GetOnConfirmBox: TWkeWebViewConfirmBoxProc;
begin
  Result := FOnConfirmBoxProc;
end;

function TWkeWebView.GetOnConsoleMessage: TWkeWebViewConsoleMessageProc;
begin
  Result := FOnConsoleMessageProc;
end;

function TWkeWebView.GetOnCreateView: TWkeWebViewCreateViewProc;
begin
  Result := FOnCreateViewProc;
end;

function TWkeWebView.GetOnDocumentReady: TWkeWebViewDocumentReadyProc;
begin
  Result := FOnDocumentReadyProc;
end;

function TWkeWebView.GetOnLoadingFinish: TWkeWebViewLoadingFinishProc;
begin
  Result := FOnLoadingFinishProc;
end;

function TWkeWebView.GetOnNavigation: TWkeWebViewNavigationProc;
begin
  Result := FOnNavigationProc;
end;

function TWkeWebView.GetOnPromptBox: TWkeWebViewPromptBoxProc;
begin
  Result := FOnPromptBoxProc;
end;

procedure TWkeWebView.SetOnAlertBox(const Value: TWkeWebViewAlertBoxProc);
begin
  FOnAlertBoxProc := Value;
end;

procedure TWkeWebView.SetOnConfirmBox(
  const Value: TWkeWebViewConfirmBoxProc);
begin
  FOnConfirmBoxProc := Value;
end;

procedure TWkeWebView.SetOnConsoleMessage(
  const Value: TWkeWebViewConsoleMessageProc);
begin
  FOnConsoleMessageProc := Value;
end;

procedure TWkeWebView.SetOnCreateView(
  const Value: TWkeWebViewCreateViewProc);
begin
  FOnCreateViewProc := Value;
end;

procedure TWkeWebView.SetOnDocumentReady(
  const Value: TWkeWebViewDocumentReadyProc);
begin
  FOnDocumentReadyProc := Value;
end;

procedure TWkeWebView.SetOnLoadingFinish(
  const Value: TWkeWebViewLoadingFinishProc);
begin
  FOnLoadingFinishProc := Value;
end;

procedure TWkeWebView.SetOnNavigation(
  const Value: TWkeWebViewNavigationProc);
begin
  FOnNavigationProc := Value;
end;

procedure TWkeWebView.SetOnPromptBox(
  const Value: TWkeWebViewPromptBoxProc);
begin
  FOnPromptBoxProc := Value;
end;

procedure TWkeWebView.DoDocumentReady(const info: PwkeDocumentReadyInfo);
var
  LGlobalObjects: IWkeJsObjectList;
  i, argCount: Integer;
begin
  if info.frameJSState = Js.GlobalExec.ExecState then
  begin
    LGlobalObjects := Wke.GlobalObjects;
    for i := 0 to LGlobalObjects.Count - 1 do
      GetJs.BindObject(LGlobalObjects.ItemName[i], LGlobalObjects[i].Value);
    LGlobalObjects.RemoveListener(DoRegObjectsNotify);
    LGlobalObjects.AddListener(DoRegObjectsNotify);
    for i := 0 to FObjectList.Count - 1 do
      GetJs.BindObject(FObjectList.ItemName[i], FObjectList[i].Value);
    FObjectList.RemoveListener(DoRegObjectsNotify);
    FObjectList.AddListener(DoRegObjectsNotify);
    
    for i := 0 to GlobalFunction.Count - 1 do
    begin
      argCount := StrToInt(GlobalFunction.ValueFromIndex[i]);
      GetJs.BindFunction(GlobalFunction.Names[i], Pointer(GlobalFunction.Objects[i]), argCount);
    end;
  end;
  if @FOnDocumentReadyProc <> nil then
    FOnDocumentReadyProc(Self, info);
end;

procedure TWkeWebView.DoLoadingFinish(
  const url: wkeString; result_: wkeLoadingResult;
  const failedReason: wkeString);
begin
  if @FOnLoadingFinishProc <> nil then
    FOnLoadingFinishProc(Self, url, result_, failedReason);
end;

procedure TWkeWebView.DoAfterLoadHtml;
begin

end;

procedure TWkeWebView.DoBeforeLoadHtml;
begin
 
end;

function TWkeWebView.GetHostWindow: HWND;
begin
  Result := HWND(WAPI.wkeGetHostWindow(FWebView));
end;

procedure TWkeWebView.SetHostWindow(const Value: HWND);
begin
  WAPI.wkeSetHostWindow(FWebView, Pointer(Value));
end;

function TWkeWebView.EditerCanCopy: Boolean;
begin
  Result := WAPI.wkeEditorCanCopy(FWebView);
end;

function TWkeWebView.EditerCanCut: Boolean;
begin
  Result := WAPI.wkeEditorCanCut(FWebView);
end;

function TWkeWebView.EditerCanDelete: Boolean;
begin
  Result := WAPI.wkeEditorCanDelete(FWebView);
end;

function TWkeWebView.EditerCanPaste: Boolean;
begin
  Result := WAPI.wkeEditorCanPaste(FWebView);
end;

function TWkeWebView.EditerCanRedo: Boolean;
begin
  Result := WAPI.wkeEditorCanRedo(FWebView);
end;

function TWkeWebView.EditerCanUndo: Boolean;
begin
  Result := WAPI.wkeEditorCanUndo(FWebView);
end;

procedure TWkeWebView.EditerRedo;
begin
  WAPI.wkeEditorRedo(FWebView);
end;

procedure TWkeWebView.EditerUndo;
begin
  WAPI.wkeEditorUndo(FWebView);
end;

procedure TWkeWebView.DoPaintUpdated(const hdc: HDC; x, y, cx,
  cy: Integer);
begin
  if FDestroying then
    Exit;
  if FThis = nil  then
    Exit;

  if @FOnPaintUpdated <> nil then
  try
    FOnPaintUpdated(Self, hdc, x, y, cx, cy);
  except
    on E: Exception do
    begin
      Trace('[TWkeWebView.DoPaintUpdated]'+E.Message);
    end
  end;
end;

function TWkeWebView.DoNavigation(navigationType: wkeNavigationType;
  const url: wkeString): Boolean;
var
  sUrl: string;
  processInfo: PROCESS_INFORMATION;
  startupInfo: TStartupInfo;
  succeeded, bHandled: Boolean;
begin
  Result := True;

  if @FOnNavigationProc <> nil then
  try
    bHandled := False;
    Result := FOnNavigationProc(Self, navigationType, url, bHandled);
    if bHandled then
      Exit;
  except
    on E: Exception do
    begin
      Trace('[OnNavigationProc]'+E.Message);
    end
  end;

  sUrl := WAPI.wkeGetStringW(url);
  if AnsiStartsText('exec://', sUrl) then
  begin
    sUrl := Copy(sUrl, 8, MaxInt);
    ZeroMemory(@processInfo, SizeOf(processInfo));
    ZeroMemory(@startupInfo, SizeOf(startupInfo));
    startupInfo.cb := SizeOf(startupInfo);
    succeeded := CreateProcess(nil, PChar(sUrl), nil, nil, False, 0, nil, nil, startupInfo, processInfo);
    if succeeded then
    begin
      CloseHandle(processInfo.hProcess);
      CloseHandle(processInfo.hThread);
    end;
    Result := False;
    Exit;
  end;
end;

function TWkeWebView.DoCreateView(const info: PwkeNewViewInfo): TWebView;
var
  bHandled: Boolean;
  sTarget, sUrl: string;
  newWindow: WkeTypes.wkeWebView;
begin
  Result := nil;
  
  if @FOnCreateViewProc <> nil then
  try
    bHandled := False;
    Result := FOnCreateViewProc(Self, info, bHandled);
    if bHandled then
      Exit;
  except
    on E: Exception do
    begin
      Trace('[OnCreateViewProc]'+E.Message);
    end
  end;

  sTarget := WAPI.wkeGetStringW(info.target);
  sUrl := WAPI.wkeGetStringW(info.url);

  if (sTarget = '') or (sTarget = '_blank') then
  begin
    if AnsiStartsText('file:///', sUrl) then
      sUrl := Copy(sUrl, 9, MaxInt)
    else
    if AnsiStartsText('file://', sUrl) then
      sUrl := Copy(sUrl, 8, MaxInt);
    ShellExecute(0, 'open', PChar(sUrl), nil, nil, SW_SHOW);
    Exit;
  end
  else
  if sTarget = '_self' then
  begin
    Result := FWebView;
    Exit;
  end
  else
  if sTarget = 'wontOpen' then
    Exit
  else
  begin                            
    newWindow := WAPI.wkeCreateWebWindow(WKE_WINDOW_TYPE_POPUP, nil, info.x, info.y, info.width, info.height);
    WAPI.wkeShowWindow(newWindow, True);
    Result := newWindow;
    Exit;
  end;
end;

procedure TWkeWebView.DoAlertBox(const msg: wkeString);
var
  bHandled: Boolean;
  sMsg: WideString;
begin
  if @FOnAlertBoxProc <> nil then
  try
    bHandled := False;
    FOnAlertBoxProc(Self, msg, bHandled);
    if bHandled then
      Exit;
  except
    on E: Exception do
    begin
      Trace('[OnAlertBoxProc]'+E.Message);
    end
  end;
  sMsg := WAPI.wkeGetStringW(msg);
  MessageBoxW(0, PUnicodeChar(sMsg), '警告', MB_OK + MB_ICONWARNING);
end;

function TWkeWebView.DoConfirmBox(const msg: wkeString): Boolean;
var
  bHandled: Boolean;
  sMsg: WideString;
begin
  if @FOnConfirmBoxProc <> nil then
  try
    bHandled := False;
    Result := FOnConfirmBoxProc(Self, msg, bHandled);
    if bHandled then
      Exit;
  except
    on E: Exception do
    begin
      Trace('[OnConfirmBoxProc]'+E.Message);
    end
  end;
  sMsg := WAPI.wkeGetStringW(msg);
  Result := MessageBoxW(0, PUnicodeChar(sMsg), '确认', MB_OKCANCEL + MB_ICONQUESTION) = IDOK;
end;

function TWkeWebView.DoOnPromptBox(const msg, defaultResult,
  result_: wkeString): Boolean;
var
  bHandled: Boolean;
begin
  Result := False;
  if @FOnPromptBoxProc <> nil then
  try
    bHandled := False;
    Result := FOnPromptBoxProc(Self, msg, defaultResult, result_, bHandled);
    if bHandled then
      Exit;
  except
    on E: Exception do
    begin
      Trace('[OnPromptBoxProc]'+E.Message);
    end
  end;
end;

function TWkeWebView.GetCursorType: wkeCursorType;
begin
  Result := WAPI.wkeGetCursorType(FWebView);
end;

procedure TWkeWebView.DoRegObjectsNotify(const AInfo: IWkeJsObjectRegInfo;
  Action: TWkeJsObjectAction);
begin
  case Action of
    woaReg:
    begin
      GetJs.BindObject(AInfo.Name, AInfo.Value);
    end;
    woaUnreg:
    begin
      GetJs.UnbindObject(AInfo.Name);
    end;
    woaChanged:
    begin
      GetJs.UnbindObject(AInfo.Name);
      GetJs.BindObject(AInfo.Name, AInfo.Value);
    end;
  end;
end;

procedure TWkeWebView.BindObject(const objName: WideString; obj: TObject);
begin
  FObjectList.Reg(objName, obj)
end;

procedure TWkeWebView.UnbindObject(const objName: WideString);
begin
  FObjectList.UnReg(objName);
end;

{ TWkeWindow }

procedure TWkeWindow.CloseWindow;
begin
  if FDestroying then
    Exit;
  if GetWindowHandle = 0 then
    Exit;
  if (GetWindowHandle <> 0) and IsWindow(GetWindowHandle) then
  begin
    Windows.DestroyWindow(GetWindowHandle);
  end;
end;

constructor TWkeWindow.Create(type_: wkeWindowType; parent: HWND; x, y,
  width, height: Integer);
var
  LWebView: IWkeWebBase;
begin
  FWebView := WAPI.wkeCreateWebWindow(type_, Pointer(parent), x, y, width, height);
  LWebView := Self;
  inherited Create(LWebView, FWebView, False);
  LWebView := nil;
  if @WAPI.wkeOnWindowClosing <> nil then
    WAPI.wkeOnWindowClosing(FWebView, _OnWindowClosing, Self);
  if @WAPI.wkeOnWindowDestroy <> nil then
    WAPI.wkeOnWindowDestroy(FWebView, _OnWindowDestroy, Self);
end;

destructor TWkeWindow.Destroy;
begin
  Windows.Sleep(10);
  if FWebView <> nil then
  begin
    if @WAPI.wkeOnWindowClosing <> nil then
      WAPI.wkeOnWindowClosing(FWebView, nil, nil);
    if @WAPI.wkeOnWindowDestroy <> nil then
      WAPI.wkeOnWindowDestroy(FWebView, nil, nil);
  end;
  inherited;
  FWebView := nil;
end;

procedure TWkeWindow.DestroyWindow;
begin
  if FWebView <> nil then
  begin
    if @WAPI.wkeOnWindowDestroy <> nil then
      WAPI.wkeDestroyWebWindow(FWebView);
    FWebView := nil;
  end;
end;

function TWkeWindow.DoClosing: Boolean;
begin
  if @FOnClosing <> nil then
    Result := FOnClosing(Self)
  else
    Result := True;
end;

procedure TWkeWindow.DoDestroy;
begin
  if @FOnDestroy <> nil then
    FOnDestroy(Self);
  if FWebView <> nil then
  begin
    WAPI.wkeOnWindowClosing(FWebView, nil, nil);
    WAPI.wkeOnWindowDestroy(FWebView, nil, nil);
  end;
  FWebView := nil;
end;

procedure TWkeWindow.EnableWindow(enable: Boolean);
begin
  WAPI.wkeEnableWindow(FWebView, enable);
end;

procedure TWkeWindow.EndModal(nCode: Integer);
begin
  if nCode >= 0 then
    FModalCode := nCode;
  FIsModaling := False;

  PostMessage(0, WM_NULL, 0, 0);
end;

function TWkeWindow.GetBoundsRect: TRect;
begin
  GetWindowRect(GetWindowHandle, Result)
end;

function TWkeWindow.GetDrawDC: HDC;
begin
  Result := 0;
end;

function TWkeWindow.GetDrawRect: TRect;
begin 
  GetClientRect(GetWindowHandle, Result)
end;

function TWkeWindow.GetHwnd: HWND;
begin
  Result := GetWindowHandle;
end;

function TWkeWindow.GetIsModaling: Boolean;
begin
  Result := FIsModaling;
end;

function TWkeWindow.GetModalCode: Integer;
begin
  Result := FModalCode;
end;

function TWkeWindow.GetOnClosing: TWkeWindowClosingProc;
begin
  Result := FOnClosing;
end;

function TWkeWindow.GetOnDestroy: TWkeWindowDestroyProc;
begin
  Result := FOnDestroy;
end;

function TWkeWindow.GetResourceInstance: THandle;
begin
  Result := MainInstance;
end;

function TWkeWindow.GetThis: IWkeWebBase;
begin
  Result := Self;
end;

function TWkeWindow.GetTitle: WideString;
begin
  Result := inherited GetTitle;
end;

function TWkeWindow.GetWindowHandle: HWND;
begin
  Result := HWND(WAPI.wkeGetWindowHandle(FWebView));
end;

function TWkeWindow.GetWindowName: WideString;
begin
  Result := Self.ClassName;
end;

function TWkeWindow.GetWindowType: wkeWindowType;
begin
  Result := FWindowType;
end;

procedure TWkeWindow.HideWindow;
begin
  WAPI.wkeShowWindow(FWebView, False);
end;

procedure TWkeWindow.MoveToCenter;
begin
  WAPI.wkeMoveToCenter(FWebView);
end;

procedure TWkeWindow.MoveWindow(x, y, width, height: Integer);
begin
  WAPI.wkeMoveWindow(FWebView, x, y, width, height);
end;

procedure TWkeWindow.ReleaseDC(const ADC: HDC);
begin

end;

procedure TWkeWindow.ResizeWindow(width, height: Integer);
begin
  WAPI.wkeResizeWindow(FWebView, width, height);
end;

procedure TWkeWindow.SetModalCode(const Value: Integer);
begin
  FModalCode := Value;
end;

procedure TWkeWindow.SetOnClosing(const AValue: TWkeWindowClosingProc);
begin
  FOnClosing := AValue;
end;

procedure TWkeWindow.SetOnDestroy(const AValue: TWkeWindowDestroyProc);
begin
  FOnDestroy := AValue;
end;

procedure TWkeWindow.SetTitle(const AValue: WideString);
begin
  WAPI.wkeSetWindowTitleW(FWebView, PUnicodeChar(AValue));
end;

function TWkeWindow.ShowModal(AParent: HWND): Integer;
var
  hParentWnd{, hActiveWnd}: HWND;
  msg: TMsg;
begin
  FModalCode  := 0;
  FisModaling := True;

  //hActiveWnd := GetActiveWindow;

  ShowWindow;

  BringWindowToTop(GetWindowHandle);

  if AParent = 0 then
    hParentWnd := Windows.GetParent(GetWindowHandle)
  else
    hParentWnd := AParent;
  while hParentWnd <> 0 do
  begin
    Windows.EnableWindow(hParentWnd, False);
    hParentWnd := Windows.GetParent(hParentWnd);
  end;
  
  while FIsModaling do
  begin
    if not GetMessage(msg, 0, 0, 0) then
      Break;

    TranslateMessage(msg);
    DispatchMessage(msg);
  end;

  if AParent = 0 then
    hParentWnd := Windows.GetParent(GetWindowHandle)
  else
    hParentWnd := AParent;
  while hParentWnd <> 0 do
  begin
    Windows.EnableWindow(hParentWnd, True);
    hParentWnd := Windows.GetParent(hParentWnd);
  end;

  HideWindow;

//  if hActiveWnd <> 0 then
//    SetActiveWindow(hActiveWnd);

  Result := FModalCode;
end;

procedure TWkeWindow.ShowWindow();
begin
  WAPI.wkeShowWindow(FWebView, True);
end;

function TWkeWindow._AddRef: Integer;
begin
  Result := inherited _AddRef;
  //OutputDebugString(PChar('_AddRef:'+IntToStr(Result)));
end;

function TWkeWindow._Release: Integer;
begin
  Result := inherited _Release;
  //OutputDebugString(PChar('_Release:'+IntToStr(Result)));
end;

initialization


finalization
  if varGlobalFunction <> nil then
    FreeAndNil(varGlobalFunction);

end.
