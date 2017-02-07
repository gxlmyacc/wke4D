unit WkeApi;

interface

uses
  SysUtils, Windows, WkeTypes, TypInfo;

const
  WKE_DLL_NAME = 'Wke.dll';

type
  TwkeInitialize = procedure (); cdecl;
  TwkeInitializeEx = procedure (const settings: PwkeSettings); cdecl;
  TwkeConfigure = procedure (const settings: PwkeSettings); cdecl;
  TwkeFinalize = procedure (); cdecl;
  TwkeUpdate = procedure (); cdecl;
  TwkeGetVersion = function (): UINT; cdecl;
  TwkeGetVersionString = function (): PUtf8; cdecl;

  TwkeSetFileSystem = procedure (pfn_open: FILE_OPEN; pfn_close: FILE_CLOSE; pfn_size: FILE_SIZE; pfn_read: FILE_READ; pfn_seek: FILE_SEEK); cdecl;

  TwkeCreateWebView = function (): wkeWebView; cdecl;
  TwkeGetWebView = function (const name: PAnsiChar): wkeWebView; cdecl;
  TwkeDestroyWebView = procedure(webView: wkeWebView); cdecl;

  TwkeGetName = function(webView: wkeWebView): PAnsiChar; cdecl;
  TwkeSetName = procedure(webView: wkeWebView; const name: PAnsiChar); cdecl;

  TwkeIsTransparent = function(webView: wkeWebView): Boolean; cdecl;
  TwkeSetTransparent = procedure (webView: wkeWebView; transparent: Boolean); cdecl;

  TwkeSetUserAgent = procedure(webView: wkeWebView; const userAgent: PUtf8); cdecl;
  TwkeSetUserAgentW = procedure(webView: wkeWebView; const userAgent: Pwchar_t); cdecl;

  TwkeLoadURL = procedure(webView: wkeWebView; const url: PUtf8); cdecl;
  TwkeLoadURLW = procedure(webView: wkeWebView; const url: Pwchar_t); cdecl;
  TwkePostURL = procedure(webView: wkeWebView; const url: PUtf8; const postData: PAnsiChar; postLen: Integer); cdecl;
  TwkePostURLW = procedure(webView: wkeWebView; const url: Pwchar_t; const postData: PAnsiChar; postLen: Integer); cdecl;

  TwkeLoadHTML = procedure(webView: wkeWebView; const html: PUtf8); cdecl;
  TwkeLoadHTMLW = procedure(webView: wkeWebView; const html: Pwchar_t); cdecl;

  TwkeLoadFile = procedure(webView: wkeWebView; const filename: PUtf8); cdecl;
  TwkeLoadFileW = procedure(webView: wkeWebView; const filename: Pwchar_t); cdecl;

  TwkeLoad = procedure(webView: wkeWebView; const str: PUtf8); cdecl;
  TwkeLoadW = procedure(webView: wkeWebView; const str: Pwchar_t); cdecl;

  TwkeIsLoading = function(webView: wkeWebView): Boolean; cdecl;
  TwkeIsLoadingSucceeded = function(webView: wkeWebView): Boolean; cdecl;
  TwkeIsLoadingFailed = function(webView: wkeWebView): Boolean; cdecl;
  TwkeIsLoadingCompleted = function(webView: wkeWebView): Boolean; cdecl;
  TwkeIsDocumentReady = function(webView: wkeWebView): Boolean; cdecl;

  TwkeStopLoading = procedure(webView: wkeWebView); cdecl;
  TwkeReload = procedure(webView: wkeWebView); cdecl;
 
  TwkeGetTitle = function(webView: wkeWebView): PUtf8; cdecl;
  TwkeGetTitleW = function(webView: wkeWebView): Pwchar_t; cdecl;

  TwkeResize = procedure(webView: wkeWebView; w, h: Integer); cdecl;
  TwkeGetWidth = function(webView: wkeWebView): Integer; cdecl;
  TwkeGetHeight = function(webView: wkeWebView): Integer; cdecl;
  TwkeGetContentWidth = function(webView: wkeWebView): Integer; cdecl;
  TwkeGetContentHeight = function(webView: wkeWebView): Integer; cdecl;

  TwkeSetDirty = procedure(webView: wkeWebView; dirty: Boolean); cdecl;
  TwkeIsDirty = function(webView: wkeWebView): Boolean; cdecl;
  TwkeAddDirtyArea = procedure(webView: wkeWebView; x, y, w, h: Integer); cdecl;
  TwkeLayoutIfNeeded = procedure(webView: wkeWebView); cdecl;
  TwkePaint = procedure(webView: wkeWebView; bits: Pointer; bufWid, bufHei, xDst, yDst, w, h, xSrc, ySrc: Integer; bCopyAlpha: Boolean); cdecl;
  TwkePaint2 = procedure(webView: wkeWebView; bits: Pointer; pitch: Integer); cdecl;
  TwkeRepaintIfNeeded = procedure(webView: wkeWebView); cdecl;
  TwkeGetViewDC = function(webView: wkeWebView): Pointer; cdecl;

  TwkeCanGoBack = function(webView: wkeWebView): Boolean; cdecl;
  TwkeGoBack = function(webView: wkeWebView): Boolean; cdecl;
  TwkeCanGoForward = function(webView: wkeWebView): Boolean; cdecl;
  TwkeGoForward = function(webView: wkeWebView): Boolean; cdecl;

  TwkeEditorSelectAll = procedure(webView: wkeWebView); cdecl;
  TwkeEditorCanCopy = function(webView: wkeWebView): Boolean; cdecl;
  TwkeEditorCopy = procedure(webView: wkeWebView); cdecl;
  TwkeEditorCanCut = function(webView: wkeWebView): Boolean; cdecl;
  TwkeEditorCut = procedure(webView: wkeWebView); cdecl;
  TwkeEditorCanPaste = function(webView: wkeWebView): Boolean; cdecl;
  TwkeEditorPaste = procedure(webView: wkeWebView); cdecl;
  TwkeEditorCanDelete = function(webView: wkeWebView): Boolean; cdecl;
  TwkeEditorDelete = procedure(webView: wkeWebView); cdecl;
  TwkeEditorCanUndo = function(webView: wkeWebView): Boolean; cdecl;
  TwkeEditorUndo = procedure(webView: wkeWebView); cdecl;
  TwkeEditorCanRedo = function(webView: wkeWebView): Boolean; cdecl;
  TwkeEditorRedo = procedure(webView: wkeWebView); cdecl;

  TwkeGetCookieW = function(webView: wkeWebView): Pwchar_t; cdecl;
  TwkeGetCookie = function(webView: wkeWebView): PUtf8; cdecl;
  TwkeSetCookieEnabled = procedure (webView: wkeWebView; enable: Boolean); cdecl;
  TwkeIsCookieEnabled = function(webView: wkeWebView): Boolean; cdecl;

  TwkeSetMediaVolume = procedure (webView: wkeWebView; volume: float); cdecl;
  TwkeGetMediaVolume = function(webView: wkeWebView): float; cdecl;

  TwkeFireMouseEvent = function(webView: wkeWebView; msg: UINT; x, y: Integer; flags: UINT): Boolean; cdecl;
  TwkeFireContextMenuEvent = function(webView: wkeWebView; x, y: Integer; flags: UINT): Boolean; cdecl;
  TwkeFireMouseWheelEvent = function(webView: wkeWebView; x, y, delta: Integer; flags: UINT): Boolean; cdecl;
  TwkeFireKeyUpEvent = function(webView: wkeWebView; virtualKeyCode: UINT; flags: UINT; systemKey: Boolean): Boolean; cdecl;
  TwkeFireKeyDownEvent = function(webView: wkeWebView; virtualKeyCode: UINT; flags: UINT; systemKey: Boolean): Boolean; cdecl;
  TwkeFireKeyPressEvent = function(webView: wkeWebView; charCode: UINT; flags: UINT; systemKey: Boolean): Boolean; cdecl;

  TwkeSetFocus = procedure(webView: wkeWebView); cdecl;
  TwkeKillFocus = procedure(webView: wkeWebView); cdecl;

  TwkeGetCaretRect = function(webView: wkeWebView): wkeRect; cdecl;

  TwkeRunJS = function(webView: wkeWebView; const script: PUtf8): jsValue; cdecl;
  TwkeRunJSW = function(webView: wkeWebView; const script: Pwchar_t): jsValue; cdecl;
  TwkeGlobalExec = function(webView: wkeWebView): jsExecState; cdecl;

  TwkeSleep = procedure(webView: wkeWebView); cdecl;
  TwkeWake = procedure(webView: wkeWebView); cdecl;
  TwkeIsAwake = function(webView: wkeWebView): Boolean; cdecl;

  TwkeSetZoomFactor = procedure (webView: wkeWebView; factor: float); cdecl;
  TwkeGetZoomFactor = function(webView: wkeWebView): float; cdecl;

  TwkeSetEditable = procedure (webView: wkeWebView; editable: Boolean); cdecl;

  TwkeSetHostWindow = procedure(webView: wkeWebView; hostWindow: Pointer); cdecl;
  TwkeGetHostWindow = function(webView: wkeWebView): Pointer; cdecl;

  TwkeGetCursorType = function (webView: wkeWebView): wkeCursorType; cdecl;

  TwkeGetString = function(const str: wkeString): PUtf8; cdecl;
  TwkeGetStringW = function(const str: wkeString): Pwchar_t; cdecl;

  TwkeSetString = procedure (wkeStr: wkeString; str: PUtf8; len: size_t); cdecl;
  TwkeSetStringW = procedure (wkeStr: wkeString; str: Pwchar_t; len: size_t); cdecl;

  TwkeOnTitleChanged = procedure (webView: wkeWebView; callback: TwkeTitleChangedCallback; callbackParam: Pointer); cdecl;
  TwkeOnURLChanged = procedure (webView: wkeWebView; callback: TwkeURLChangedCallback; callbackParam: Pointer); cdecl;
  TwkeOnPaintUpdated = procedure (webView: wkeWebView; callback: TwkePaintUpdatedCallback; callbackParam: Pointer); cdecl;
  TwkeOnAlertBox = procedure(webView: wkeWebView; callback: TwkeAlertBoxCallback; callbackParam: Pointer); cdecl;
  TwkeOnConfirmBox = procedure(webView: wkeWebView; callback: TwkeConfirmBoxCallback; callbackParam: Pointer); cdecl;
  TwkeOnPromptBox = procedure(webView: wkeWebView; callback: TwkePromptBoxCallback; callbackParam: Pointer); cdecl;
  TwkeOnConsoleMessage = procedure(webView: wkeWebView; callback: TwkeConsoleMessageCallback; callbackParam: Pointer);cdecl;
  TwkeOnNavigation = procedure(webView: wkeWebView; callback: TwkeNavigationCallback; param: Pointer);cdecl;
  TwkeOnCreateView = procedure(webView: wkeWebView; callback: TwkeCreateViewCallback; param: Pointer);cdecl;
  TwkeOnDocumentReady = procedure(webView: wkeWebView; callback: TwkeDocumentReadyCallback; param: Pointer);cdecl;
  TwkeOnLoadingFinish = procedure(webView: wkeWebView; callback: TwkeLoadingFinishCallback; param: Pointer);cdecl;

  TwkeCreateWebWindow = function(type_: wkeWindowType; parent: Pointer; x, y, width, height: Integer): wkeWebView; cdecl;
  TwkeDestroyWebWindow = procedure(webWindow: wkeWebView);cdecl;
  TwkeGetWindowHandle = function(webWindow: wkeWebView): Pointer;cdecl;

  TwkeOnWindowClosing = procedure(webWindow: wkeWebView; callback: TwkeWindowClosingCallback; param: Pointer); cdecl;
  TwkeOnWindowDestroy = procedure(webWindow: wkeWebView; callback: TwkeWindowDestroyCallback; param: Pointer); cdecl;

  TwkeShowWindow = procedure(webWindow: wkeWebView; show: Boolean);cdecl;
  TwkeEnableWindow = procedure(webWindow: wkeWebView; enable: Boolean);cdecl;

  TwkeMoveWindow = procedure(webWindow: wkeWebView; x, y, width, height: Integer);cdecl;
  TwkeMoveToCenter = procedure(webWindow: wkeWebView);cdecl;
  TwkeResizeWindow = procedure(webWindow: wkeWebView; width, height: Integer);cdecl;

  TwkeSetWindowTitle = procedure(webWindow: wkeWebView; const title: PUtf8);cdecl;
  TwkeSetWindowTitleW = procedure(webWindow: wkeWebView; const title: Pwchar_t);cdecl;

  TwkeSetUserData = procedure (webView: wkeWebView; userData: Pointer); cdecl;
  TwkeGetUserData = function(webView: wkeWebView): Pointer; cdecl;
  
  (***JavaScript Bind***)
  TjsBindFunction = procedure (const name: PAnsiChar; fn: jsNativeFunction; argCount: UINT); cdecl;
  TjsBindGetter = procedure (const name: PAnsiChar; fn: jsNativeFunction); cdecl; (*get property*)
  TjsBindSetter = procedure (const name: PAnsiChar; fn: jsNativeFunction); cdecl; (*set property*)

  TjsArgCount = function(es: jsExecState): Integer; cdecl;
  TjsArgType = function(es: jsExecState; argIdx: Integer): jsType; cdecl;
  TjsArg = function(es: jsExecState; argIdx: Integer): jsValue; cdecl;

  TjsTypeOf = function(v: jsValue): jsType; cdecl;
  TjsIsNumber = function(v: jsValue): Boolean; cdecl;
  TjsIsString = function(v: jsValue): Boolean; cdecl;
  TjsIsBoolean = function(v: jsValue): Boolean; cdecl;
  TjsIsObject = function(v: jsValue): Boolean; cdecl;
  TjsIsFunction = function(v: jsValue): Boolean; cdecl;
  TjsIsUndefined = function(v: jsValue): Boolean; cdecl;
  TjsIsNull = function(v: jsValue): Boolean; cdecl;
  TjsIsArray = function(v: jsValue): Boolean; cdecl;
  TjsIsTrue = function(v: jsValue): Boolean; cdecl;
  TjsIsFalse = function(v: jsValue): Boolean; cdecl;

  TjsToInt = function(es: jsExecState; v: jsValue): Integer; cdecl;
  TjsToFloat = function(es: jsExecState; v: jsValue): float; cdecl;
  TjsToDouble = function(es: jsExecState; v: jsValue): Double; cdecl;
  TjsToBoolean = function(es: jsExecState; v: jsValue): Boolean; cdecl;
  TjsToTempString = function(es: jsExecState; v: jsValue): PUtf8; cdecl;
  TjsToTempStringW = function(es: jsExecState; v: jsValue): Pwchar_t; cdecl;

  TjsInt = function(n: Integer): jsValue; cdecl;
  TjsFloat = function(n: float): jsValue; cdecl;
  TjsDouble = function(n: Double): jsValue; cdecl;
  TjsBoolean = function(n: Boolean): jsValue; cdecl;

  TjsUndefined = function(): jsValue; cdecl;
  TjsNull = function(): jsValue; cdecl;
  TjsTrue = function(): jsValue; cdecl;
  TjsFalse = function(): jsValue; cdecl;

  TjsString = function(es: jsExecState; const str: PUtf8): jsValue; cdecl;
  TjsStringW = function(es: jsExecState; const str: Pwchar_t): jsValue; cdecl;
  TjsEmptyObject = function(es: jsExecState): jsValue; cdecl;
  TjsEmptyArray = function(es: jsExecState): jsValue; cdecl;

  TjsObject =  function(es: jsExecState; obj: PjsData): jsValue; cdecl;
  TjsFunction = function(es: jsExecState; fn: jsNativeFunction; argCount: UINT): jsValue; cdecl;
  TjsGetData = function(es: jsExecState; obj: jsValue): PjsData; cdecl;

  TjsGet = function(es: jsExecState; obj: jsValue; const prop: PAnsiChar): jsValue; cdecl;
  TjsSet = procedure(es: jsExecState; obj: jsValue; const prop: PAnsiChar; v: jsValue); cdecl;

  TjsGetAt = function(es: jsExecState; obj: jsValue; index: Integer): jsValue; cdecl;
  TjsSetAt = procedure(es: jsExecState; obj: jsValue; index: Integer; v: jsValue); cdecl;

  TjsGetLength = function(es: jsExecState; obj: jsValue): Integer; cdecl;
  TjsSetLength = procedure(es: jsExecState; obj: jsValue; length: Integer); cdecl;
  
  //return the window object
  TjsGlobalObject = function(es: jsExecState): jsValue; cdecl;
  TjsGetWebView = function(es: jsExecState): wkeWebView; cdecl;
  
  TjsEval = function(es: jsExecState; const str: PUtf8): jsValue; cdecl;
  TjsEvalW = function(es: jsExecState; const str: Pwchar_t): jsValue; cdecl;

  TjsCall = function(es: jsExecState; func, thisObject: jsValue; args: PJsValeuArray; argCount: Integer): jsValue; cdecl;
  TjsCallGlobal = function(es: jsExecState; func: jsValue; args: PJsValeuArray; argCount: Integer): jsValue; cdecl;

  TjsGetGlobal = function(es: jsExecState; const prop: PAnsiChar): jsValue; cdecl;
  TjsSetGlobal = procedure(es: jsExecState; const prop: PAnsiChar; v: jsValue); cdecl;

  TjsGC = procedure (); cdecl; //garbage collect

  TWkeAPI  = class
  private
    FDriverFile: string;
    FDLLHandle: THandle;
    FLastError: string;
  protected
    function GetLoaded: Boolean;
  public
    constructor Create;
    destructor Destroy; override;

    function LoadDLL(const ADriverFile: string = ''): Boolean;
    procedure UnloadDLL;

    property LastError: string read FLastError;
    property Loaded: Boolean read GetLoaded;
    property DriverFile: string read FDriverFile write FDriverFile;
    property DLLHandle: THandle read FDLLHandle;
  public
    wkeInitialize: TwkeInitialize;
    wkeInitializeEx: TwkeInitializeEx;
    wkeConfigure: TwkeConfigure;
    wkeFinalize: TwkeFinalize;
    wkeUpdate: TwkeUpdate;
    wkeGetVersion: TwkeGetVersion;
    wkeGetVersionString: TwkeGetVersionString;

    wkeSetFileSystem: TwkeSetFileSystem;

    wkeCreateWebView: TwkeCreateWebView;
    wkeGetWebView: TwkeGetWebView;
    wkeDestroyWebView: TwkeDestroyWebView;

    wkeGetName: TwkeGetName;
    wkeSetName: TwkeSetName;

    wkeIsTransparent: TwkeIsTransparent;
    wkeSetTransparent: TwkeSetTransparent; 

    wkeSetUserAgent: TwkeSetUserAgent;
    wkeSetUserAgentW: TwkeSetUserAgentW;

    wkeLoadURL: TwkeLoadURL;
    wkeLoadURLW: TwkeLoadURLW;
    wkePostURL: TwkePostURL;
    wkePostURLW: TwkePostURLW;

    wkeLoadHTML: TwkeLoadHTML;
    wkeLoadHTMLW: TwkeLoadHTMLW;

    wkeLoadFile: TwkeLoadFile;
    wkeLoadFileW: TwkeLoadFileW;

    wkeLoad: TwkeLoad;
    wkeLoadW: TwkeLoadW;

    wkeIsLoading: TwkeIsLoading;
    wkeIsLoadingSucceeded: TwkeIsLoadingSucceeded;
    wkeIsLoadingFailed: TwkeIsLoadingFailed;
    wkeIsLoadingCompleted: TwkeIsLoadingCompleted;
    wkeIsDocumentReady: TwkeIsDocumentReady;

    wkeStopLoading: TwkeStopLoading;
    wkeReload: TwkeReload;

    wkeGetTitle: TwkeGetTitle;
    wkeGetTitleW: TwkeGetTitleW;

    wkeResize: TwkeResize;
    wkeGetWidth: TwkeGetWidth;
    wkeGetHeight: TwkeGetHeight;
    wkeGetContentWidth: TwkeGetContentWidth;
    wkeGetContentHeight: TwkeGetContentHeight;

    wkeSetDirty: TwkeSetDirty;
    wkeIsDirty: TwkeIsDirty;
    wkeAddDirtyArea: TwkeAddDirtyArea; 
    wkeLayoutIfNeeded: TwkeLayoutIfNeeded; 
    wkePaint: TwkePaint;
    wkePaint2: TwkePaint2;
    wkeRepaintIfNeeded: TwkeRepaintIfNeeded;
    wkeGetViewDC: TwkeGetViewDC;

    wkeCanGoBack: TwkeCanGoBack;
    wkeGoBack: TwkeGoBack;
    wkeCanGoForward: TwkeCanGoForward;
    wkeGoForward: TwkeGoForward;

    wkeEditorSelectAll: TwkeEditorSelectAll;
    wkeEditorCanCopy: TwkeEditorCanCopy;
    wkeEditorCopy: TwkeEditorCopy;
    wkeEditorCanCut: TwkeEditorCanCut;
    wkeEditorCut: TwkeEditorCut;
    wkeEditorCanPaste: TwkeEditorCanPaste;
    wkeEditorPaste: TwkeEditorPaste;
    wkeEditorCanDelete: TwkeEditorCanDelete;
    wkeEditorDelete: TwkeEditorDelete;
    wkeEditorCanUndo: TwkeEditorCanUndo;
    wkeEditorUndo: TwkeEditorUndo;
    wkeEditorCanRedo: TwkeEditorCanRedo;
    wkeEditorRedo: TwkeEditorRedo;

    wkeGetCookieW: TwkeGetCookieW;
    wkeGetCookie: TwkeGetCookie;
    wkeSetCookieEnabled: TwkeSetCookieEnabled;
    wkeIsCookieEnabled: TwkeIsCookieEnabled;

    wkeSetMediaVolume: TwkeSetMediaVolume;
    wkeGetMediaVolume: TwkeGetMediaVolume;

    wkeFireMouseEvent: TwkeFireMouseEvent;
    wkeFireContextMenuEvent: TwkeFireContextMenuEvent;
    wkeFireMouseWheelEvent: TwkeFireMouseWheelEvent;
    wkeFireKeyUpEvent: TwkeFireKeyUpEvent;
    wkeFireKeyDownEvent: TwkeFireKeyDownEvent;
    wkeFireKeyPressEvent: TwkeFireKeyPressEvent;

    wkeSetFocus: TwkeSetFocus;
    wkeKillFocus: TwkeKillFocus;

    wkeGetCaretRect: TwkeGetCaretRect;

    wkeRunJS: TwkeRunJS;
    wkeRunJSW: TwkeRunJSW;
    wkeGlobalExec: TwkeGlobalExec;

    wkeSleep: TwkeSleep;
    wkeWake: TwkeWake;
    wkeIsAwake: TwkeIsAwake;

    wkeSetZoomFactor: TwkeSetZoomFactor;
    wkeGetZoomFactor: TwkeGetZoomFactor;

    wkeSetEditable: TwkeSetEditable;

    wkeSetHostWindow: TwkeSetHostWindow;
    wkeGetHostWindow: TwkeGetHostWindow;

    wkeGetCursorType: TwkeGetCursorType;

    wkeGetString: TwkeGetString;
    wkeGetStringW: TwkeGetStringW;

    wkeSetString: TwkeSetString;
    wkeSetStringW: TwkeSetStringW;

    wkeOnTitleChanged: TwkeOnTitleChanged;
    wkeOnURLChanged: TwkeOnURLChanged;
    wkeOnPaintUpdated: TwkeOnPaintUpdated;
    wkeOnAlertBox: TwkeOnAlertBox;
    wkeOnConfirmBox: TwkeOnConfirmBox;
    wkeOnPromptBox: TwkeOnPromptBox;
    wkeOnConsoleMessage: TwkeOnConsoleMessage;
    wkeOnNavigation: TwkeOnNavigation;
    wkeOnCreateView: TwkeOnCreateView;
    wkeOnDocumentReady: TwkeOnDocumentReady;
    wkeOnLoadingFinish: TwkeOnLoadingFinish;

    wkeCreateWebWindow: TwkeCreateWebWindow;
    wkeDestroyWebWindow: TwkeDestroyWebWindow;
    wkeGetWindowHandle: TwkeGetWindowHandle;

    wkeOnWindowClosing: TwkeOnWindowClosing;
    wkeOnWindowDestroy: TwkeOnWindowDestroy;

    wkeShowWindow: TwkeShowWindow;
    wkeEnableWindow: TwkeEnableWindow;

    wkeMoveWindow: TwkeMoveWindow;
    wkeMoveToCenter: TwkeMoveToCenter;
    wkeResizeWindow: TwkeResizeWindow;

    wkeSetWindowTitle: TwkeSetWindowTitle;
    wkeSetWindowTitleW: TwkeSetWindowTitleW;

    wkeSetUserData: TwkeSetUserData;
    wkeGetUserData: TwkeGetUserData;

    jsBindFunction: TjsBindFunction;
    jsBindGetter: TjsBindGetter;
    jsBindSetter: TjsBindSetter;

    jsArgCount: TjsArgCount;
    jsArgType: TjsArgType;
    jsArg: TjsArg;

    jsTypeOf: TjsTypeOf;
    jsIsNumber: TjsIsNumber;
    jsIsString: TjsIsString;
    jsIsBoolean: TjsIsBoolean;
    jsIsObject: TjsIsObject;
    jsIsFunction: TjsIsFunction;
    jsIsUndefined: TjsIsUndefined;
    jsIsNull: TjsIsNull;
    jsIsArray: TjsIsArray;
    jsIsTrue: TjsIsTrue;
    jsIsFalse: TjsIsFalse;

    jsToInt: TjsToInt;
    jsToFloat: TjsToFloat;
    jsToDouble: TjsToDouble;
    jsToBoolean: TjsToBoolean;
    jsToTempString: TjsToTempString;
    jsToTempStringW: TjsToTempStringW;

    jsInt: TjsInt;
    jsFloat: TjsFloat;
    jsDouble: TjsDouble;
    jsBoolean: TjsBoolean;

    jsUndefined: TjsUndefined;
    jsNull: TjsNull;
    jsTrue: TjsTrue;
    jsFalse: TjsFalse;

    jsString: TjsString;
    jsStringW: TjsStringW;
    jsEmptyObject: TjsEmptyObject;
    jsEmptyArray: TjsEmptyArray;

    jsObject: TjsObject;
    jsFunction: TjsFunction;
    jsGetData: TjsGetData;

    jsGet: TjsGet;
    jsSet: TjsSet;

    jsGetAt: TjsGetAt;
    jsSetAt: TjsSetAt;

    jsGetLength: TjsGetLength; 
    jsSetLength: TjsSetLength;

    jsGlobalObject: TjsGlobalObject;
    jsGetWebView: TjsGetWebView;

    jsEval: TjsEval;
    jsEvalW: TjsEvalW;

    jsCall: TjsCall;
    jsCallGlobal: TjsCallGlobal;

    jsGetGlobal: TjsGetGlobal;
    jsSetGlobal: TjsSetGlobal;

    jsGC: TjsGC;
  end;

  { Exceptions }
  EWkeException = class(Exception)
  end;


procedure Log(const ALog: string);
procedure Trace(const ALog: string);

var
  WAPISettings: PwkeSettings = nil;
  WAPI: TWkeAPI = nil;
  CurrentLoadDir: string;
  Default8087CW: Word = 0;

function V2J(es: jsExecState; const vValue: OleVariant; var jValue: jsValue;
  var sError: string; const sPropName: string = ''): Boolean;
function J2V(es: jsExecState; const jValue: jsValue; var vValue: OleVariant;
  var sError: string): Boolean;

function EncodeURI(const WS: WideString): WideString;
function HTTPDecode(const AStr: string): string;
function HTTPEncode(const AStr: string): string;

implementation

uses
  f_DebugIntf, Variants;

resourcestring
  sErrorDecodingURLText = 'Error decoding URL style (%%XX) encoded string at position %d';
  sInvalidURLEncodedChar = 'Invalid URL encoded character (%s) at position %d';
  
procedure Trace(const ALog: string);
begin
  f_DebugIntf.Trace(ALog, 'Wke');
end;

procedure Log(const ALog: string);
begin
  f_DebugIntf.Log(ALog, 'Wke');
end;

function V2J(es: jsExecState; const vValue: OleVariant; var jValue: jsValue;
  var sError: string; const sPropName: string): Boolean;
var
  sWStr: WideString;
  d: Double;
  date: TDateTime;
  //pDisp: IDispatch;
  cCur: Currency;
  vt: Word;
  i: Integer;
  oArrItem: OleVariant;
  tArrItem: jsValue;
begin
  Result := False;
  
  vt := VarType(vValue);

  if (vt and varArray) = varArray then
  begin
    jValue := WAPI.jsEmptyArray(es);
    WAPI.jsSetLength(es, jValue, VarArrayHighBound(vValue, 1) - VarArrayLowBound(vValue, 1) + 1);
    
    for i := VarArrayLowBound(vValue, 1) to VarArrayHighBound(vValue, 1) do
    begin
      oArrItem := VarArrayGet(vValue, [i]);
      
      if not V2J(es, oArrItem, tArrItem, sError) then
      begin
        jValue := WAPI.jsUndefined;
        Exit;
      end;

      WAPI.jsSetAt(es, jValue, i, tArrItem);
    end;
    Result := True;
    Exit;
  end;

  case vt of
    varEmpty:
    begin
      jValue := WAPI.jsUndefined;
      Result := True;
    end;
    varNull:
    begin
      jValue := WAPI.jsNull;
      Result := True;
    end;
    varString, varOleStr:
    begin
      sWStr := vValue;

      if (sPropName = JSONObjectName)
        and (Length(sWStr)>0) and (sWStr[1] = '{') and (sWStr[Length(sWStr)] = '}')  then
      begin
        jValue := WAPI.jsEvalW(es, PUnicodeChar(sWStr));
        Result := True;
        Exit;
      end;

      jValue := WAPI.jsStringW(es, PUnicodeChar(sWStr));
      Result := True;
    end;
    varBoolean:
    begin
      jValue := WAPI.jsBoolean(vValue);
      Result := True;
    end;
    varByte,
    varSmallInt,
    varInteger,
    varWord,
    varLongWord:
    begin
      jValue := WAPI.jsInt(vValue);
      Result := True;
    end;
    varInt64:
    begin
      if sPropName = 'JsValue' then
      begin
        jValue := vValue;
        Exit;
      end;

      jValue := WAPI.jsInt(vValue);
      Result := True;
    end;
    varSingle:
    begin
      jValue := WAPI.jsFloat(vValue);
      Result := True;    
    end;
    varDouble:
    begin
      jValue := WAPI.jsDouble(vValue);
      Result := True;
    end;
    varCurrency:
      begin
        cCur := vValue;
        jValue := WAPI.jsDouble(cCur);
        Result := True;
      end;
    varDate:
      begin
        date := TDateTime(vValue);
        d := Double(date);
        jValue := WAPI.jsDouble(d);
        Result := True;
      end;
    varDispatch:
      begin
//        pDisp := IDispatch(vValue);
//        jValue := _WrapOleObject(vm, pDisp);

        jValue := WAPI.jsUndefined;
        Result := True;
      end;
  else
    begin
      raise Exception.CreateFmt('Cannot convert VARIANT of type %d to TIScript value.', [vt]);
    end;
  end;
end;

function J2V(es: jsExecState; const jValue: jsValue; var vValue: OleVariant;
  var sError: string): Boolean;
var
  sWStr: WideString;
  arrSize: UINT;
  sArrItem: jsValue;
  oArrItem: OleVariant;
  j: Integer;
begin
  Result := False;
  
  if WAPI.jsIsNumber(jValue) then
  begin
    vValue := WAPI.jsToDouble(es, jValue);
    Result := True;
  end
  else
  if WAPI.jsIsString(jValue) then
  begin
    sWStr := WAPI.jsToTempStringW(es, jValue);
    vValue := sWStr;
    Result := True;
  end
  else
  if WAPI.jsIsBoolean(jValue) then
  begin
    vValue := WAPI.jsToBoolean(es, jValue);
    Result := True;
  end
  else
  if WAPI.jsIsObject(jValue) then
  begin
    vValue := jValue;
    Result := True;
  end
  else
  if WAPI.jsIsFunction(jValue) then
  begin
    vValue :=jValue;
    Result := True;
  end
  else
  if WAPI.jsIsUndefined(jValue) then
  begin
    vValue := Unassigned;
    Result := True;
  end
  else
  if WAPI.jsIsNull(jValue) then
  begin
    vValue := Null;
    Result := True;
  end
  else
  if WAPI.jsIsArray(jValue) then
  begin
    arrSize := WAPI.jsGetLength(es, jValue);
    vValue := VarArrayCreate([0, arrSize], varVariant );
    for j := 0 to arrSize - 1 do
    begin
      sArrItem := WAPI.jsGetAt(es, jValue, j);
      
      if not J2V(es, sArrItem, oArrItem, sError) then
        Exit;
        
      VarArrayPut(Variant(vValue), oArrItem, [j]);
    end;
    Result := True;
  end
  else 
  if WAPI.jsIsTrue(jValue) then
  begin
    vValue := True;
    Result := True;
  end
  else
  if WAPI.jsIsFalse(jValue) then
  begin
    vValue := False;
    Result := True;
  end
  else
    sError := 'Conversion from JsValue type to Variant is not implemented.';
end;


function HTTPDecode(const AStr: string): string;
var
  Sp, Rp, Cp: PChar;
  S: string;
begin
  SetLength(Result, Length(AStr));
  Sp := PChar(AStr);
  Rp := PChar(Result);
  Cp := Sp;
  try
    while Sp^ <> #0 do
    begin
      case Sp^ of
        '+': Rp^ := ' ';
        '%':
        begin
          // Look for an escaped % (%%) or %<hex> encoded character
          Inc(Sp);
          if Sp^ = '%' then
            Rp^ := '%'
          else
          begin
            Cp := Sp;
            Inc(Sp);
            if (Cp^ <> #0) and (Sp^ <> #0) then
            begin
              S := '$' + Cp^ + Sp^;
              Rp^ := Char(StrToInt(S));
            end
            else
              raise EWkeException.CreateFmt(sErrorDecodingURLText, [Cp - PChar(AStr)]);
          end;
        end;
      else
        Rp^ := Sp^;
      end;
      Inc(Rp);
      Inc(Sp);
    end;
  except
    on E:EConvertError do
      raise EConvertError.CreateFmt(sInvalidURLEncodedChar,
        ['%' + Cp^ + Sp^, Cp - PChar(AStr)])
  end;
  SetLength(Result, Rp - PChar(Result));
end;

function HTTPEncode(const AStr: string): string;
const
  NoConversion = ['A'..'Z','a'..'z','*','@','.','_','-',
                  '0'..'9','$','!','''','(',')'];
var
  Sp: PAnsiChar;
  Rp: PChar;
  sStr: UTF8String;
  sResult: string;
begin
  sStr := UTF8Encode(AStr);
  SetLength(sResult, Length(sStr) * 3);
  Sp := PAnsiChar(sStr);
  Rp := PChar(sResult);
  while Sp^ <> #0 do
  begin
    if Sp^ in NoConversion then
      Rp^ := Char(Sp^)
    else
    if Sp^ = ' ' then
      Rp^ := '+'
    else
    begin
      FormatBuf(Rp{$IF CompilerVersion <= 18.5}^{$IFEND}, 3, '%%%.2x', 6, [Ord(Sp^)]);
      Inc(Rp, 2);
    end;
    Inc(Rp);
    Inc(Sp);
  end;
  SetLength(sResult, Rp - PChar(sResult));
  Result := sResult;
end;

function EncodeURI(const WS: WideString): WideString;
  function IsMultiByte(const Str: PWideChar; const Index: Cardinal): Boolean;
  begin
    Result := Word(Str[Index]) > 128;
  end;
var
  i, iLen: Integer;
  s1, sResult: WideString;
  p: PWideChar;
begin
  iLen := Length(WS);
  p := PWideChar(WS);
  i := 0;
  while i < iLen do
  begin
    case IsMultiByte(p, i) of
      False:
      begin
        if s1 <> '' then
        begin
          sResult := sResult + HTTPEncode(s1);
          s1 := '';
        end;
        sResult := sResult + p[i];
        i := i + 1;
      end;
      True:
      begin
        s1 := s1 + p[i];
        i := i + 1;
      end;
    end;
  end;
  if s1 <> EmptyStr then
  begin
    sResult := sResult + HTTPEncode(s1);
    s1 := EmptyStr;
  end;
  Result := sResult;
end;

{ TWkeAPI }

constructor TWkeAPI.Create;
begin
  FDriverFile := WKE_DLL_NAME;
end;

destructor TWkeAPI.Destroy;
begin
  UnloadDLL;
  inherited;
end;

function TWkeAPI.GetLoaded: Boolean;
begin
  Result := FDLLHandle > 0;
end;

function TWkeAPI.LoadDLL(const ADriverFile: string): Boolean;
var
  sDriverFile: string;
begin
  Result := False;
  try
    if SameText(FDriverFile, ADriverFile) then
    begin
      Result := True;
      Exit;
    end;
    if ADriverFile = EmptyStr then
      sDriverFile := FDriverFile
    else
      sDriverFile := ADriverFile;
    UnloadDLL;
    if not FileExists(sDriverFile) then
    begin
      FLastError := Format('[%s]组件不存在！', [sDriverFile]);
      Log(FLastError);
      Exit;    
    end;
    FDLLHandle := LoadLibrary(PChar(sDriverFile));
    if FDLLHandle < 32 then
    begin
      FLastError := Format('加载[%s]失败！', [sDriverFile]);
      Log(FLastError);
      Exit;
    end;  
    FDriverFile := sDriverFile;

    @wkeInitialize := GetProcAddress(FDLLHandle, 'wkeInitialize');
    @wkeInitializeEx := GetProcAddress(FDLLHandle, 'wkeInitializeEx');
    @wkeConfigure := GetProcAddress(FDLLHandle, 'wkeConfigure');
    @wkeFinalize := GetProcAddress(FDLLHandle, 'wkeFinalize');
    @wkeUpdate := GetProcAddress(FDLLHandle, 'wkeUpdate');
    @wkeGetVersion := GetProcAddress(FDLLHandle, 'wkeGetVersion');
    @wkeGetVersionString := GetProcAddress(FDLLHandle, 'wkeGetVersionString');

    @wkeSetFileSystem := GetProcAddress(FDLLHandle, 'wkeSetFileSystem');

    @wkeCreateWebView := GetProcAddress(FDLLHandle, 'wkeCreateWebView');
    @wkeGetWebView := GetProcAddress(FDLLHandle, 'wkeGetWebView');
    @wkeDestroyWebView := GetProcAddress(FDLLHandle, 'wkeDestroyWebView');

    @wkeGetName := GetProcAddress(FDLLHandle, 'wkeGetName');
    @wkeSetName := GetProcAddress(FDLLHandle, 'wkeSetName');

    @wkeIsTransparent := GetProcAddress(FDLLHandle, 'wkeIsTransparent');
    @wkeSetTransparent := GetProcAddress(FDLLHandle, 'wkeSetTransparent');

    @wkeSetUserAgent := GetProcAddress(FDLLHandle, 'wkeSetUserAgent');
    @wkeSetUserAgentW := GetProcAddress(FDLLHandle, 'wkeSetUserAgentW');

    @wkeLoadURL := GetProcAddress(FDLLHandle, 'wkeLoadURL');
    @wkeLoadURLW := GetProcAddress(FDLLHandle, 'wkeLoadURLW');
    @wkePostURL := GetProcAddress(FDLLHandle, 'wkePostURL');
    @wkePostURLW := GetProcAddress(FDLLHandle, 'wkePostURLW');

    @wkeLoadHTML := GetProcAddress(FDLLHandle, 'wkeLoadHTML');
    @wkeLoadHTMLW := GetProcAddress(FDLLHandle, 'wkeLoadHTMLW');

    @wkeLoadFile := GetProcAddress(FDLLHandle, 'wkeLoadFile');
    @wkeLoadFileW := GetProcAddress(FDLLHandle, 'wkeLoadFileW');

    @wkeLoad := GetProcAddress(FDLLHandle, 'wkeLoad');
    @wkeLoadW := GetProcAddress(FDLLHandle, 'wkeLoadW');

    @wkeIsLoading := GetProcAddress(FDLLHandle, 'wkeIsLoading');
    @wkeIsLoadingSucceeded := GetProcAddress(FDLLHandle, 'wkeIsLoadingSucceeded');
    @wkeIsLoadingFailed := GetProcAddress(FDLLHandle, 'wkeIsLoadingFailed');
    @wkeIsLoadingCompleted := GetProcAddress(FDLLHandle, 'wkeIsLoadingCompleted');
    @wkeIsDocumentReady := GetProcAddress(FDLLHandle, 'wkeIsDocumentReady');

    @wkeStopLoading := GetProcAddress(FDLLHandle, 'wkeStopLoading');
    @wkeReload := GetProcAddress(FDLLHandle, 'wkeReload');

    @wkeGetTitle := GetProcAddress(FDLLHandle, 'wkeGetTitle');
    @wkeGetTitleW := GetProcAddress(FDLLHandle, 'wkeGetTitleW');

    @wkeResize := GetProcAddress(FDLLHandle, 'wkeResize');
    @wkeGetWidth := GetProcAddress(FDLLHandle, 'wkeGetWidth');
    @wkeGetHeight := GetProcAddress(FDLLHandle, 'wkeGetHeight');
    @wkeGetContentWidth := GetProcAddress(FDLLHandle, 'wkeGetContentWidth');
    @wkeGetContentHeight := GetProcAddress(FDLLHandle, 'wkeGetContentHeight');

    @wkeSetDirty := GetProcAddress(FDLLHandle, 'wkeSetDirty');
    @wkeIsDirty := GetProcAddress(FDLLHandle, 'wkeIsDirty');
    @wkeAddDirtyArea := GetProcAddress(FDLLHandle, 'wkeAddDirtyArea');
    @wkeLayoutIfNeeded := GetProcAddress(FDLLHandle, 'wkeLayoutIfNeeded');
    @wkePaint := GetProcAddress(FDLLHandle, 'wkePaint');
    @wkePaint2 := GetProcAddress(FDLLHandle, 'wkePaint2');
    @wkeRepaintIfNeeded := GetProcAddress(FDLLHandle, 'wkeRepaintIfNeeded');
    @wkeGetViewDC := GetProcAddress(FDLLHandle, 'wkeGetViewDC');

    @wkeCanGoBack := GetProcAddress(FDLLHandle, 'wkeCanGoBack');
    @wkeGoBack := GetProcAddress(FDLLHandle, 'wkeGoBack');
    @wkeCanGoForward := GetProcAddress(FDLLHandle, 'wkeCanGoForward');
    @wkeGoForward := GetProcAddress(FDLLHandle, 'wkeGoForward');

    @wkeEditorSelectAll := GetProcAddress(FDLLHandle, 'wkeEditorSelectAll');
    @wkeEditorCanCopy := GetProcAddress(FDLLHandle, 'wkeEditorCanCopy');
    @wkeEditorCopy := GetProcAddress(FDLLHandle, 'wkeEditorCopy');
    @wkeEditorCanCut := GetProcAddress(FDLLHandle, 'wkeEditorCanCut');
    @wkeEditorCut := GetProcAddress(FDLLHandle, 'wkeEditorCut');
    @wkeEditorCanPaste := GetProcAddress(FDLLHandle, 'wkeEditorCanPaste');
    @wkeEditorPaste := GetProcAddress(FDLLHandle, 'wkeEditorPaste');
    @wkeEditorCanDelete := GetProcAddress(FDLLHandle, 'wkeEditorCanDelete');
    @wkeEditorDelete := GetProcAddress(FDLLHandle, 'wkeEditorDelete');
    @wkeEditorCanUndo := GetProcAddress(FDLLHandle, 'wkeEditorCanUndo');
    @wkeEditorUndo := GetProcAddress(FDLLHandle, 'wkeEditorUndo');
    @wkeEditorCanRedo := GetProcAddress(FDLLHandle, 'wkeEditorCanRedo');
    @wkeEditorRedo := GetProcAddress(FDLLHandle, 'wkeEditorRedo');

    @wkeGetCookieW := GetProcAddress(FDLLHandle, 'wkeGetCookieW');
    @wkeGetCookie := GetProcAddress(FDLLHandle, 'wkeGetCookie');
    @wkeSetCookieEnabled := GetProcAddress(FDLLHandle, 'wkeSetCookieEnabled');
    @wkeIsCookieEnabled := GetProcAddress(FDLLHandle, 'wkeIsCookieEnabled');

    @wkeSetMediaVolume := GetProcAddress(FDLLHandle, 'wkeSetMediaVolume');
    @wkeGetMediaVolume := GetProcAddress(FDLLHandle, 'wkeGetMediaVolume');

    @wkeFireMouseEvent := GetProcAddress(FDLLHandle, 'wkeFireMouseEvent');
    @wkeFireContextMenuEvent := GetProcAddress(FDLLHandle, 'wkeFireContextMenuEvent');
    @wkeFireMouseWheelEvent := GetProcAddress(FDLLHandle, 'wkeFireMouseWheelEvent');
    @wkeFireKeyUpEvent := GetProcAddress(FDLLHandle, 'wkeFireKeyUpEvent');
    @wkeFireKeyDownEvent := GetProcAddress(FDLLHandle, 'wkeFireKeyDownEvent');
    @wkeFireKeyPressEvent := GetProcAddress(FDLLHandle, 'wkeFireKeyPressEvent');

    @wkeSetFocus := GetProcAddress(FDLLHandle, 'wkeSetFocus');
    @wkeKillFocus := GetProcAddress(FDLLHandle, 'wkeKillFocus');

    @wkeGetCaretRect := GetProcAddress(FDLLHandle, 'wkeGetCaretRect');

    @wkeRunJS := GetProcAddress(FDLLHandle, 'wkeRunJS');
    @wkeRunJSW := GetProcAddress(FDLLHandle, 'wkeRunJSW');
    @wkeGlobalExec := GetProcAddress(FDLLHandle, 'wkeGlobalExec');

    @wkeSleep := GetProcAddress(FDLLHandle, 'wkeSleep');
    @wkeWake := GetProcAddress(FDLLHandle, 'wkeWake');
    @wkeIsAwake := GetProcAddress(FDLLHandle, 'wkeIsAwake');

    @wkeSetZoomFactor := GetProcAddress(FDLLHandle, 'wkeSetZoomFactor');
    @wkeGetZoomFactor := GetProcAddress(FDLLHandle, 'wkeGetZoomFactor');

    @wkeSetEditable := GetProcAddress(FDLLHandle, 'wkeSetEditable');

    @wkeSetHostWindow := GetProcAddress(FDLLHandle, 'wkeSetHostWindow');
    @wkeGetHostWindow := GetProcAddress(FDLLHandle, 'wkeGetHostWindow');

    @wkeGetCursorType := GetProcAddress(FDLLHandle, 'wkeGetCursorType');

    @wkeGetString := GetProcAddress(FDLLHandle, 'wkeGetString');
    @wkeGetStringW := GetProcAddress(FDLLHandle, 'wkeGetStringW');

    @wkeSetString := GetProcAddress(FDLLHandle, 'wkeSetString');
    @wkeSetStringW := GetProcAddress(FDLLHandle, 'wkeSetStringW');

    @wkeOnTitleChanged := GetProcAddress(FDLLHandle, 'wkeOnTitleChanged');
    @wkeOnURLChanged := GetProcAddress(FDLLHandle, 'wkeOnURLChanged');
    @wkeOnPaintUpdated := GetProcAddress(FDLLHandle, 'wkeOnPaintUpdated');
    @wkeOnAlertBox := GetProcAddress(FDLLHandle, 'wkeOnAlertBox');
    @wkeOnConfirmBox := GetProcAddress(FDLLHandle, 'wkeOnConfirmBox');
    @wkeOnPromptBox := GetProcAddress(FDLLHandle, 'wkeOnPromptBox');
    @wkeOnConsoleMessage := GetProcAddress(FDLLHandle, 'wkeOnConsoleMessage');
    @wkeOnNavigation := GetProcAddress(FDLLHandle, 'wkeOnNavigation');
    @wkeOnCreateView := GetProcAddress(FDLLHandle, 'wkeOnCreateView');
    @wkeOnDocumentReady := GetProcAddress(FDLLHandle, 'wkeOnDocumentReady');
    @wkeOnLoadingFinish := GetProcAddress(FDLLHandle, 'wkeOnLoadingFinish');

    @wkeCreateWebWindow := GetProcAddress(FDLLHandle, 'wkeCreateWebWindow');
    @wkeDestroyWebWindow := GetProcAddress(FDLLHandle, 'wkeDestroyWebWindow');
    @wkeGetWindowHandle := GetProcAddress(FDLLHandle, 'wkeGetWindowHandle');

    @wkeOnWindowClosing := GetProcAddress(FDLLHandle, 'wkeOnWindowClosing');
    @wkeOnWindowDestroy := GetProcAddress(FDLLHandle, 'wkeOnWindowDestroy');

    @wkeShowWindow := GetProcAddress(FDLLHandle, 'wkeShowWindow');
    @wkeEnableWindow := GetProcAddress(FDLLHandle, 'wkeEnableWindow');

    @wkeMoveWindow := GetProcAddress(FDLLHandle, 'wkeMoveWindow');
    @wkeMoveToCenter := GetProcAddress(FDLLHandle, 'wkeMoveToCenter');
    @wkeResizeWindow := GetProcAddress(FDLLHandle, 'wkeResizeWindow');

    @wkeSetWindowTitle := GetProcAddress(FDLLHandle, 'wkeSetWindowTitle');
    @wkeSetWindowTitleW := GetProcAddress(FDLLHandle, 'wkeSetWindowTitleW');

    @wkeSetUserData := GetProcAddress(FDLLHandle, 'wkeSetUserData');
    @wkeGetUserData := GetProcAddress(FDLLHandle, 'wkeGetUserData');

    @jsBindFunction := GetProcAddress(FDLLHandle, 'jsBindFunction');
    @jsBindGetter := GetProcAddress(FDLLHandle, 'jsBindGetter');
    @jsBindSetter := GetProcAddress(FDLLHandle, 'jsBindSetter');

    @jsArgCount := GetProcAddress(FDLLHandle, 'jsArgCount');
    @jsArgType := GetProcAddress(FDLLHandle, 'jsArgType');
    @jsArg := GetProcAddress(FDLLHandle, 'jsArg');

    @jsTypeOf := GetProcAddress(FDLLHandle, 'jsTypeOf');
    @jsIsNumber := GetProcAddress(FDLLHandle, 'jsIsNumber');
    @jsIsString := GetProcAddress(FDLLHandle, 'jsIsString');
    @jsIsBoolean := GetProcAddress(FDLLHandle, 'jsIsBoolean');
    @jsIsObject := GetProcAddress(FDLLHandle, 'jsIsObject');
    @jsIsFunction := GetProcAddress(FDLLHandle, 'jsIsFunction');
    @jsIsUndefined := GetProcAddress(FDLLHandle, 'jsIsUndefined');
    @jsIsNull := GetProcAddress(FDLLHandle, 'jsIsNull');
    @jsIsArray := GetProcAddress(FDLLHandle, 'jsIsArray');
    @jsIsTrue := GetProcAddress(FDLLHandle, 'jsIsTrue');
    @jsIsFalse := GetProcAddress(FDLLHandle, 'jsIsFalse');

    @jsToInt := GetProcAddress(FDLLHandle, 'jsToInt');
    @jsToFloat := GetProcAddress(FDLLHandle, 'jsToFloat');
    @jsToDouble := GetProcAddress(FDLLHandle, 'jsToDouble');
    @jsToBoolean := GetProcAddress(FDLLHandle, 'jsToBoolean');
    @jsToTempString := GetProcAddress(FDLLHandle, 'jsToTempString');
    @jsToTempStringW := GetProcAddress(FDLLHandle, 'jsToTempStringW');

    @jsInt := GetProcAddress(FDLLHandle, 'jsInt');
    @jsFloat := GetProcAddress(FDLLHandle, 'jsFloat');
    @jsDouble := GetProcAddress(FDLLHandle, 'jsDouble');
    @jsBoolean := GetProcAddress(FDLLHandle, 'jsBoolean');

    @jsUndefined := GetProcAddress(FDLLHandle, 'jsUndefined');
    @jsNull := GetProcAddress(FDLLHandle, 'jsNull');
    @jsTrue := GetProcAddress(FDLLHandle, 'jsTrue');
    @jsFalse := GetProcAddress(FDLLHandle, 'jsFalse');

    @jsString := GetProcAddress(FDLLHandle, 'jsString');
    @jsStringW := GetProcAddress(FDLLHandle, 'jsStringW');
    @jsEmptyObject := GetProcAddress(FDLLHandle, 'jsEmptyObject');
    @jsEmptyArray := GetProcAddress(FDLLHandle, 'jsEmptyArray');

    @jsObject := GetProcAddress(FDLLHandle, 'jsObject');
    @jsFunction := GetProcAddress(FDLLHandle, 'jsFunction');
    @jsGetData := GetProcAddress(FDLLHandle, 'jsGetData');

    @jsGet := GetProcAddress(FDLLHandle, 'jsGet');
    @jsSet := GetProcAddress(FDLLHandle, 'jsSet');

    @jsGetAt := GetProcAddress(FDLLHandle, 'jsGetAt');
    @jsSetAt := GetProcAddress(FDLLHandle, 'jsSetAt');

    @jsGetLength := GetProcAddress(FDLLHandle, 'jsGetLength');
    @jsSetLength := GetProcAddress(FDLLHandle, 'jsSetLength');

    @jsGlobalObject := GetProcAddress(FDLLHandle, 'jsGlobalObject');
    @jsGetWebView := GetProcAddress(FDLLHandle, 'jsGetWebView');

    @jsEval := GetProcAddress(FDLLHandle, 'jsEval');
    @jsEvalW := GetProcAddress(FDLLHandle, 'jsEvalW');

    @jsCall := GetProcAddress(FDLLHandle, 'jsCall');
    @jsCallGlobal := GetProcAddress(FDLLHandle, 'jsCallGlobal');

    @jsGetGlobal := GetProcAddress(FDLLHandle, 'jsGetGlobal');
    @jsSetGlobal := GetProcAddress(FDLLHandle, 'jsSetGlobal');

    @jsGC := GetProcAddress(FDLLHandle, 'jsGC');

    if WAPISettings = nil then
      wkeInitialize
    else
      wkeInitializeEx(WAPISettings);
  except
    on E: Exception do
    begin
      Trace('[TWkeAPI.LoadDLL]'+E.Message);
    end
  end;
end;

procedure TWkeAPI.UnloadDLL;
begin
  if not GetLoaded then
    Exit;
  if @wkeFinalize <> nil then
  try
    wkeFinalize;
    Sleep(10);
  except
    on E: Exception do
      OutputDebugString(PChar('[TWkeAPI.UnloadDLL]'+E.Message));
  end;             

  @wkeInitialize := nil;
  @wkeInitializeEx := nil;
  @wkeConfigure := nil;
  @wkeFinalize := nil;
  @wkeUpdate := nil;
  @wkeGetVersion := nil;
  @wkeGetVersionString := nil;

  @wkeSetFileSystem := nil;

  @wkeCreateWebView := nil;
  @wkeGetWebView := nil;
  @wkeDestroyWebView := nil;

  @wkeGetName := nil;
  @wkeSetName := nil;

  @wkeIsTransparent := nil;
  @wkeSetTransparent := nil;

  @wkeSetUserAgent := nil;
  @wkeSetUserAgentW := nil;

  @wkeLoadURL := nil;
  @wkeLoadURLW := nil;
  @wkePostURL := nil;
  @wkePostURLW := nil;

  @wkeLoadHTML := nil;
  @wkeLoadHTMLW := nil;

  @wkeLoadFile := nil;
  @wkeLoadFileW := nil;

  @wkeLoad := nil;
  @wkeLoadW := nil;

  @wkeIsLoading := nil;
  @wkeIsLoadingSucceeded := nil;
  @wkeIsLoadingFailed := nil;
  @wkeIsLoadingCompleted := nil;
  @wkeIsDocumentReady := nil;

  @wkeStopLoading := nil;
  @wkeReload := nil;

  @wkeGetTitle := nil;
  @wkeGetTitleW := nil;

  @wkeResize := nil;
  @wkeGetWidth := nil;
  @wkeGetHeight := nil;
  @wkeGetContentWidth := nil;
  @wkeGetContentHeight := nil;

  @wkeSetDirty := nil;
  @wkeIsDirty := nil;
  @wkeAddDirtyArea := nil;
  @wkeLayoutIfNeeded := nil;
  @wkePaint := nil;
  @wkePaint2 := nil;
  @wkeRepaintIfNeeded := nil;
  @wkeGetViewDC := nil;

  @wkeCanGoBack := nil;
  @wkeGoBack := nil;
  @wkeCanGoForward := nil;
  @wkeGoForward := nil;

  @wkeEditorSelectAll := nil;
  @wkeEditorCanCopy := nil;
  @wkeEditorCopy := nil;
  @wkeEditorCanCut := nil;
  @wkeEditorCut := nil;
  @wkeEditorCanPaste := nil;
  @wkeEditorPaste := nil;
  @wkeEditorCanDelete := nil;
  @wkeEditorDelete := nil;
  @wkeEditorCanUndo := nil;
  @wkeEditorUndo := nil;
  @wkeEditorCanRedo := nil;
  @wkeEditorRedo := nil;

  @wkeGetCookieW := nil;
  @wkeGetCookie := nil;
  @wkeSetCookieEnabled := nil;
  @wkeIsCookieEnabled := nil;

  @wkeSetMediaVolume := nil;
  @wkeGetMediaVolume := nil;

  @wkeFireMouseEvent := nil;
  @wkeFireContextMenuEvent := nil;
  @wkeFireMouseWheelEvent := nil;
  @wkeFireKeyUpEvent := nil;
  @wkeFireKeyDownEvent := nil;
  @wkeFireKeyPressEvent := nil;

  @wkeSetFocus := nil;
  @wkeKillFocus := nil;

  @wkeGetCaretRect := nil;

  @wkeRunJS := nil;
  @wkeRunJSW := nil;
  @wkeGlobalExec := nil;

  @wkeSleep := nil;
  @wkeWake := nil;
  @wkeIsAwake := nil;

  @wkeSetZoomFactor := nil;
  @wkeGetZoomFactor := nil;

  @wkeSetEditable := nil;

  @wkeSetHostWindow := nil;
  @wkeGetHostWindow := nil;

  @wkeGetCursorType := nil;

  @wkeGetString := nil;
  @wkeGetStringW := nil;

  @wkeSetString := nil;
  @wkeSetStringW := nil;

  @wkeOnTitleChanged := nil;
  @wkeOnURLChanged := nil;
  @wkeOnPaintUpdated := nil;
  @wkeOnAlertBox := nil;
  @wkeOnConfirmBox := nil;
  @wkeOnPromptBox := nil;
  @wkeOnConsoleMessage := nil;
  @wkeOnNavigation := nil;
  @wkeOnCreateView := nil;
  @wkeOnDocumentReady := nil;
  @wkeOnLoadingFinish := nil;

  @wkeCreateWebWindow := nil;
  @wkeDestroyWebWindow := nil;
  @wkeGetWindowHandle := nil;

  @wkeOnWindowClosing := nil;
  @wkeOnWindowDestroy := nil;

  @wkeShowWindow := nil;
  @wkeEnableWindow := nil;

  @wkeMoveWindow := nil;
  @wkeMoveToCenter := nil;
  @wkeResizeWindow := nil;

  @wkeSetWindowTitle := nil;
  @wkeSetWindowTitleW := nil;

  @wkeSetUserData := nil;
  @wkeGetUserData := nil;

  @jsBindFunction := nil;
  @jsBindGetter := nil;
  @jsBindSetter := nil;

  @jsArgCount := nil;
  @jsArgType := nil;
  @jsArg := nil;

  @jsTypeOf := nil;
  @jsIsNumber := nil;
  @jsIsString := nil;
  @jsIsBoolean := nil;
  @jsIsObject := nil;
  @jsIsFunction := nil;
  @jsIsUndefined := nil;
  @jsIsNull := nil;
  @jsIsArray := nil;
  @jsIsTrue := nil;
  @jsIsFalse := nil;

  @jsToInt := nil;
  @jsToFloat := nil;
  @jsToDouble := nil;
  @jsToBoolean := nil;
  @jsToTempString := nil;
  @jsToTempStringW := nil;

  @jsInt := nil;
  @jsFloat := nil;
  @jsDouble := nil;
  @jsBoolean := nil;

  @jsUndefined := nil;
  @jsNull := nil;
  @jsTrue := nil;
  @jsFalse := nil;

  @jsString := nil;
  @jsStringW := nil;
  @jsEmptyObject := nil;
  @jsEmptyArray := nil;

  @jsObject := nil;
  @jsFunction := nil;
  @jsGetData := nil;

  @jsGet := nil;
  @jsSet := nil;

  @jsGetAt := nil;
  @jsSetAt := nil;

  @jsGetLength := nil;
  @jsSetLength := nil;

  @jsGlobalObject := nil;
  @jsGetWebView := nil;

  @jsEval := nil;
  @jsEvalW := nil;

  @jsCall := nil;
  @jsCallGlobal := nil;

  @jsGetGlobal := nil;
  @jsSetGlobal := nil;

  @jsGC := nil;

  if FDLLHandle > 0 then
  try
    FreeLibrary(FDLLHandle);
  except
    on E: Exception do
      Trace( '[TWkeAPI.UnloadDLL]'+E.Message);
  end;
  FDLLHandle := 0;
  FDriverFile := WKE_DLL_NAME;
end;


initialization
  Default8087CW := Get8087CW;
  Set8087CW($133F);

finalization
  if Default8087CW <> 0 then
    Set8087CW(Default8087CW);

end.
