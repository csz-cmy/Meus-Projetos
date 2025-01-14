{ RRRRRR                  ReportBuilder Class Library                  BBBBB
  RR   RR                                                              BB   BB
  RRRRRR                 Digital Metaphors Corporation                 BB BB
  RR  RR                                                               BB   BB
  RR   RR                   Copyright (c) 1996-2006                    BBBBB   }

unit ppTB2Dock;

{
  Toolbar2000
  Copyright (C) 1998-2004 by Jordan Russell
  All rights reserved.

  The contents of this file are subject to the "Toolbar2000 License"; you may
  not use or distribute this file except in compliance with the
  "Toolbar2000 License". A copy of the "Toolbar2000 License" may be found in
  TB2k-LICENSE.txt or at:
    http://www.jrsoftware.org/files/tb2k/TB2k-LICENSE.txt

  Alternatively, the contents of this file may be used under the terms of the
  GNU General Public License (the "GPL"), in which case the provisions of the
  GPL are applicable instead of those in the "Toolbar2000 License". A copy of
  the GPL may be found in GPL-LICENSE.txt or at:
    http://www.jrsoftware.org/files/tb2k/GPL-LICENSE.txt
  If you wish to allow use of your version of this file only under the terms of
  the GPL and not to allow others to use your version of this file under the
  "Toolbar2000 License", indicate your decision by deleting the provisions
  above and replace them with the notice and other provisions required by the
  GPL. If you do not delete the provisions above, a recipient may use your
  version of this file under either the "Toolbar2000 License" or the GPL.

  $jrsoftware: tb2k/Source/TB2Dock.pas,v 1.88 2004/02/26 07:05:57 jr Exp $
}

interface

{x$DEFINE TB2Dock_DisableLock}
{ Remove the 'x' to enable the define. It will disable calls to
  LockWindowUpdate, which it calls to disable screen updates while dragging.
  You may want to temporarily enable the define while debugging so you are able
  to see your code window while stepping through the dragging routines. }

{$I ppTB2Ver.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms;

type
  TppTBCustomForm = {$IFDEF JR_D3} TCustomForm {$ELSE} TForm {$ENDIF};

  { TppTBDock }

  TppTBDockBoundLinesValues = (blTop, blBottom, blLeft, blRight);
  TppTBDockBoundLines = set of TppTBDockBoundLinesValues;
  TppTBDockPosition = (dpTop, dpBottom, dpLeft, dpRight);
  TppTBDockType = (dtNotDocked, dtFloating, dtTopBottom, dtLeftRight);
  TppTBDockableTo = set of TppTBDockPosition;

  TppTBCustomDockableWindow = class;
  TppTBBasicBackground = class;

  TppTBInsertRemoveEvent = procedure(Sender: TObject; Inserting: Boolean;
    Bar: TppTBCustomDockableWindow) of object;
  TppTBRequestDockEvent = procedure(Sender: TObject; Bar: TppTBCustomDockableWindow;
    var Accept: Boolean) of object;

  TppTBDock = class(TCustomControl)
  private
    { Property values }
    FPosition: TppTBDockPosition;
    FAllowDrag: Boolean;
    FBoundLines: TppTBDockBoundLines;
    FBackground: TppTBBasicBackground;
    FBkgOnToolbars: Boolean;
    FDragCanSplit: Boolean;
    FDragSplitting: Boolean;
    FDragToolbar: TppTBCustomDockableWindow;
    FFixAlign: Boolean;
    FCommitNewPositions: Boolean;
    FLimitToOneRow: Boolean;
    FOnInsertRemoveBar: TppTBInsertRemoveEvent;
    FOnRequestDock: TppTBRequestDockEvent;
    {$IFNDEF JR_D4}
    FOnResize: TNotifyEvent;
    {$ENDIF}

    { Internal }
    FDisableArrangeToolbars: Integer;  { Increment to disable ArrangeToolbars }
    FArrangeToolbarsNeeded: Boolean;
    FNonClientWidth, FNonClientHeight: Integer;

    { Property access methods }
    //function GetVersion: TToolbar97Version;
    procedure SetAllowDrag(Value: Boolean);
    procedure SetBackground(Value: TppTBBasicBackground);
    procedure SetBackgroundOnToolbars(Value: Boolean);
    procedure SetBoundLines(Value: TppTBDockBoundLines);
    procedure SetFixAlign(Value: Boolean);
    procedure SetPosition(Value: TppTBDockPosition);
    //procedure SetVersion(const Value: TToolbar97Version);

    function GetToolbarCount: Integer;
    function GetToolbars(Index: Integer): TppTBCustomDockableWindow;

    { Internal }
    procedure BackgroundChanged(Sender: TObject);
    procedure ChangeDockList(const Insert: Boolean; const Bar: TppTBCustomDockableWindow);
    procedure CommitPositions;
    procedure DrawNCArea(const DrawToDC: Boolean; const ADC: HDC;
      const Clip: HRGN);
    function GetDesignModeRowOf(const XY: Integer): Integer;
    procedure RelayMsgToFloatingBars(var Message: TMessage);
    procedure ToolbarVisibilityChanged(const Bar: TppTBCustomDockableWindow;
      const ForceRemove: Boolean);

    { Messages }
    procedure CMDialogChar(var Message: TCMDialogChar); message CM_DIALOGCHAR;
    procedure CMDialogKey(var Message: TCMDialogKey); message CM_DIALOGKEY;
    procedure CMSysColorChange(var Message: TMessage); message CM_SYSCOLORCHANGE;
    procedure WMEraseBkgnd(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;
    procedure WMMove(var Message: TWMMove); message WM_MOVE;
    {$IFNDEF JR_D4}
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    {$ENDIF}
    procedure WMNCCalcSize(var Message: TWMNCCalcSize); message WM_NCCALCSIZE;
    procedure WMNCPaint(var Message: TMessage); message WM_NCPAINT;
    procedure WMPrint(var Message: TMessage); message WM_PRINT;
    procedure WMPrintClient(var Message: TMessage); message WM_PRINTCLIENT;
    procedure WMSysCommand(var Message: TWMSysCommand); message WM_SYSCOMMAND;
  protected
    DockList: TList;  { List of the toolbars docked, and those floating and have LastDock
                        pointing to the dock. Items are casted in TppTBCustomDockableWindow's. }
    DockVisibleList: TList;  { Similar to DockList, but lists only docked and visible toolbars }
    function Accepts(ADockableWindow: TppTBCustomDockableWindow): Boolean; virtual;
    procedure AlignControls(AControl: TControl; var Rect: TRect); override;
    procedure ChangeWidthHeight(const NewWidth, NewHeight: Integer);
    procedure DrawBackground(DC: HDC; const DrawRect: TRect); virtual;
    function GetPalette: HPALETTE; override;
    function HasVisibleToolbars: Boolean;
    procedure InvalidateBackgrounds;
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure SetParent(AParent: TWinControl); override;
    function ToolbarVisibleOnDock(const AToolbar: TppTBCustomDockableWindow): Boolean;
    procedure Paint; override;
    function UsingBackground: Boolean; virtual;
    property ArrangeToolbarsNeeded: Boolean read FArrangeToolbarsNeeded write FArrangeToolbarsNeeded;
    property DisableArrangeToolbars: Integer read FDisableArrangeToolbars write FDisableArrangeToolbars;
  public
    constructor Create(AOwner: TComponent); override;
    procedure CreateParams(var Params: TCreateParams); override;
    destructor Destroy; override;

    procedure ArrangeToolbars; virtual;
    procedure BeginUpdate;
    procedure EndUpdate;
    function GetCurrentRowSize(const Row: Integer; var AFullSize: Boolean): Integer;
    function GetHighestRow(const HighestEffective: Boolean): Integer;
    function GetMinRowSize(const Row: Integer;
      const ExcludeControl: TppTBCustomDockableWindow): Integer;

    property CommitNewPositions: Boolean read FCommitNewPositions write FCommitNewPositions;
    property DragCanSplit: Boolean read FDragCanSplit write FDragCanSplit;
    property DragSplitting: Boolean read FDragSplitting write FDragSplitting;
    property DragToolbar: TppTBCustomDockableWindow read FDragToolbar write FDragToolbar;
    property NonClientWidth: Integer read FNonClientWidth;
    property NonClientHeight: Integer read FNonClientHeight;
    property ToolbarCount: Integer read GetToolbarCount;
    property Toolbars[Index: Integer]: TppTBCustomDockableWindow read GetToolbars;
  published
    property AllowDrag: Boolean read FAllowDrag write SetAllowDrag default True;
    property Background: TppTBBasicBackground read FBackground write SetBackground;
    property BackgroundOnToolbars: Boolean read FBkgOnToolbars write SetBackgroundOnToolbars default True;
    property BoundLines: TppTBDockBoundLines read FBoundLines write SetBoundLines default [];
    property Color default clBtnFace;
    property FixAlign: Boolean read FFixAlign write SetFixAlign default False;
    property LimitToOneRow: Boolean read FLimitToOneRow write FLimitToOneRow default False;
    property PopupMenu;
    property Position: TppTBDockPosition read FPosition write SetPosition default dpTop;
    //property Version: TToolbar97Version read GetVersion write SetVersion stored False;
    property Visible;

    {$IFDEF JR_D5}
    property OnContextPopup;
    {$ENDIF}
    property OnInsertRemoveBar: TppTBInsertRemoveEvent read FOnInsertRemoveBar write FOnInsertRemoveBar;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnRequestDock: TppTBRequestDockEvent read FOnRequestDock write FOnRequestDock;
    {$IFDEF JR_D4}
    property OnResize;
    {$ELSE}
    property OnResize: TNotifyEvent read FOnResize write FOnResize;
    {$ENDIF}
  end;

  { TppTBFloatingWindowParent - internal }

  TppTBToolWindowNCRedrawWhatElement = (twrdBorder, twrdCaption, twrdCloseButton);
  TppTBToolWindowNCRedrawWhat = set of TppTBToolWindowNCRedrawWhatElement;

  TppTBFloatingWindowParentClass = class of TppTBFloatingWindowParent;
  TppTBFloatingWindowParent = class(TCustomForm)
  private
    FCloseButtonDown: Boolean; { True if Close button is currently depressed }
    FDockableWindow: TppTBCustomDockableWindow;
    FParentForm: TppTBCustomForm;
    FShouldShow: Boolean;

    procedure SetCloseButtonState(Pushed: Boolean);
    procedure RedrawNCArea(const RedrawWhat: TppTBToolWindowNCRedrawWhat);

    procedure CMShowingChanged(var Message: TMessage); message CM_SHOWINGCHANGED;
    procedure CMDialogKey(var Message: TCMDialogKey); message CM_DIALOGKEY;
    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
    procedure WMActivate(var Message: TWMActivate); message WM_ACTIVATE;
    procedure WMClose(var Message: TWMClose); message WM_CLOSE;
    procedure WMGetMinMaxInfo(var Message: TWMGetMinMaxInfo); message WM_GETMINMAXINFO;
    procedure WMMouseActivate(var Message: TWMMouseActivate); message WM_MOUSEACTIVATE;
    procedure WMMove(var Message: TWMMove); message WM_MOVE;
    procedure WMNCCalcSize(var Message: TWMNCCalcSize); message WM_NCCALCSIZE;
    procedure WMNCHitTest(var Message: TWMNCHitTest); message WM_NCHITTEST;
    procedure WMNCLButtonDblClk(var Message: TWMNCLButtonDblClk); message WM_NCLBUTTONDBLCLK;
    procedure WMNCLButtonDown(var Message: TWMNCLButtonDown); message WM_NCLBUTTONDOWN;
    procedure WMNCPaint(var Message: TMessage); message WM_NCPAINT;
    procedure WMNCRButtonUp(var Message: TWMNCRButtonUp); message WM_NCRBUTTONUP;
    procedure WMPrint(var Message: TMessage); message WM_PRINT;
    procedure WMPrintClient(var Message: TMessage); message WM_PRINTCLIENT;
  protected
    procedure AlignControls(AControl: TControl; var Rect: TRect); override;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure DrawNCArea(const DrawToDC: Boolean; const ADC: HDC;
      const Clip: HRGN; RedrawWhat: TppTBToolWindowNCRedrawWhat); dynamic;
    property DockableWindow: TppTBCustomDockableWindow read FDockableWindow;
    property CloseButtonDown: Boolean read FCloseButtonDown;
  public
    property ParentForm: TppTBCustomForm read FParentForm;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

  { TppTBCustomDockableWindow }

  TppTBDockChangingEvent = procedure(Sender: TObject; Floating: Boolean;
    DockingTo: TppTBDock) of object;
  TppTBDragHandleStyle = (dhDouble, dhNone, dhSingle);
  TppTBDockMode = (dmCanFloat, dmCannotFloat, dmCannotFloatOrChangeDocks);
  TppTBFloatingMode = (fmOnTopOfParentForm, fmOnTopOfAllForms);
  TppTBSizeHandle = (twshLeft, twshRight, twshTop, twshTopLeft,
    twshTopRight, twshBottom, twshBottomLeft, twshBottomRight);
    { ^ must be in same order as HTLEFT..HTBOTTOMRIGHT }
  TppTBPositionReadIntProc = function(const ToolbarName, Value: String; const Default: Longint;
    const ExtraData: Pointer): Longint;
  TppTBPositionReadStringProc = function(const ToolbarName, Value, Default: String;
    const ExtraData: Pointer): String;
  TppTBPositionWriteIntProc = procedure(const ToolbarName, Value: String; const Data: Longint;
    const ExtraData: Pointer);
  TppTBPositionWriteStringProc = procedure(const ToolbarName, Value, Data: String;
    const ExtraData: Pointer);
  TppTBReadPositionData = record
    ReadIntProc: TppTBPositionReadIntProc;
    ReadStringProc: TppTBPositionReadStringProc;
    ExtraData: Pointer;
  end;
  TppTBWritePositionData = record
    WriteIntProc: TppTBPositionWriteIntProc;
    WriteStringProc: TppTBPositionWriteStringProc;
    ExtraData: Pointer;
  end;
  TppTBDockableWindowStyles = set of (tbdsResizeEightCorner, tbdsResizeClipCursor);
  TppTBShrinkMode = (tbsmNone, tbsmWrap, tbsmChevron);

  TppTBCustomDockableWindow = class(TCustomControl)
  private
    { Property variables }
    FAutoResize: Boolean;
    FDblClickUndock: Boolean;
    FDockPos, FDockRow, FEffectiveDockPos, FEffectiveDockRow: Integer;
    FDocked: Boolean;
    FCurrentDock, FDefaultDock, FLastDock: TppTBDock;
    FCurrentSize: Integer;
    FFloating: Boolean;
    FOnClose, FOnDockChanged, FOnMove, FOnRecreated,
      FOnRecreating, {$IFNDEF JR_D4} FOnResize, {$ENDIF}
      FOnVisibleChanged: TNotifyEvent;
    FOnCloseQuery: TCloseQueryEvent;
    FOnDockChanging, FOnDockChangingHidden: TppTBDockChangingEvent;
    FActivateParent, FHideWhenInactive, FCloseButton, FCloseButtonWhenDocked,
      FFullSize, FResizable, FShowCaption, FStretch, FUseLastDock: Boolean;
    FBorderStyle: TBorderStyle;
    FDockMode: TppTBDockMode;
    FDragHandleStyle: TppTBDragHandleStyle;
    FDockableTo: TppTBDockableTo;
    FFloatingMode: TppTBFloatingMode;
    FSmoothDrag: Boolean;
    FDockableWindowStyles: TppTBDockableWindowStyles;
    FLastRowSize: Integer;
    FInsertRowBefore: Boolean;

    { Misc. }
    FUpdatingBounds,           { Incremented while internally changing the bounds. This allows
                                 it to move the toolbar freely in design mode and prevents the
                                 SizeChanging protected method from begin called }
    FDisableArrange,           { Incremented to disable Arrange }
    FDisableOnMove,            { Incremented to prevent WM_MOVE handler from calling the OnMoved handler }
    FHidden: Integer;          { Incremented while the toolbar is temporarily hidden }
    FArrangeNeeded, FMoved: Boolean;
    FInactiveCaption: Boolean; { True when the caption of the toolbar is currently the inactive color }
    FFloatingPosition: TPoint;
    FDockForms: TList;
    FSavedAtRunTime: Boolean;
    //FNonClientWidth, FNonClientHeight: Integer;
    FSmoothDragging: Boolean;

    { When floating. These are not used in design mode }
    FCloseButtonDown: Boolean; { True if Close button is currently depressed }
    FCloseButtonHover: Boolean;
    FFloatParent: TppTBFloatingWindowParent; { Run-time only: The actual Parent of the toolbar when it is floating }

    { Property access methods }
    //function GetVersion: TToolbar97Version;
    function GetNonClientWidth: Integer;
    function GetNonClientHeight: Integer;
    function IsLastDockStored: Boolean;
    function IsWidthAndHeightStored: Boolean;
    procedure SetAutoResize(Value: Boolean);
    procedure SetBorderStyle(Value: TBorderStyle);
    procedure SetCloseButton(Value: Boolean);
    procedure SetCloseButtonWhenDocked(Value: Boolean);
    procedure SetCurrentDock(Value: TppTBDock);
    procedure SetDefaultDock(Value: TppTBDock);
    procedure SetDockPos(Value: Integer);
    procedure SetDockRow(Value: Integer);
    procedure SetDragHandleStyle(Value: TppTBDragHandleStyle);
    procedure SetFloating(Value: Boolean);
    procedure SetFloatingMode(Value: TppTBFloatingMode);
    procedure SetFloatingPosition(Value: TPoint);
    procedure SetFullSize(Value: Boolean);
    procedure SetLastDock(Value: TppTBDock);
    procedure SetResizable(Value: Boolean);
    procedure SetShowCaption(Value: Boolean);
    procedure SetStretch(Value: Boolean);
    procedure SetUseLastDock(Value: Boolean);
    //procedure SetVersion(const Value: TToolbar97Version);

    { Internal }
    procedure CancelNCHover;
    procedure DrawDraggingOutline(const DC: HDC; const NewRect, OldRect: PRect;
      const NewDocking, OldDocking: Boolean);
    procedure RedrawNCArea;
    procedure SetCloseButtonState(Pushed: Boolean);
    procedure SetInactiveCaption(Value: Boolean);
    procedure ShowNCContextMenu(const Pos: TSmallPoint);
    procedure Moved;
    function GetShowingState: Boolean;
    procedure UpdateTopmostFlag;
    procedure UpdateVisibility;
    procedure ReadSavedAtRunTime(Reader: TReader);
    procedure WriteSavedAtRunTime(Writer: TWriter);

    { Messages }
    procedure CMColorChanged(var Message: TMessage); message CM_COLORCHANGED;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
    procedure CMShowingChanged(var Message: TMessage); message CM_SHOWINGCHANGED;
    procedure CMVisibleChanged(var Message: TMessage); message CM_VISIBLECHANGED;
    {$IFDEF JR_D5}
    procedure WMContextMenu(var Message: TWMContextMenu); message WM_CONTEXTMENU;
    {$ENDIF}
    procedure WMEnable(var Message: TWMEnable); message WM_ENABLE;
    procedure WMEraseBkgnd(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;
    procedure WMMove(var Message: TWMMove); message WM_MOVE;
    procedure WMMouseMove(var Message: TMessage); message WM_MOUSEMOVE;
    procedure WMNCCalcSize(var Message: TWMNCCalcSize); message WM_NCCALCSIZE;
    procedure WMNCHitTest(var Message: TWMNCHitTest); message WM_NCHITTEST;
    procedure WMNCMouseLeave(var Message: TMessage); message $2A2 {WM_NCMOUSELEAVE};
    procedure WMNCMouseMove(var Message: TWMNCMouseMove); message WM_NCMOUSEMOVE;
    procedure WMNCLButtonDblClk(var Message: TWMNCLButtonDblClk); message WM_NCLBUTTONDBLCLK;
    procedure WMNCLButtonDown(var Message: TWMNCLButtonDown); message WM_NCLBUTTONDOWN;
    procedure WMNCPaint(var Message: TMessage); message WM_NCPAINT;
    procedure WMNCRButtonUp(var Message: TWMNCRButtonUp); message WM_NCRBUTTONUP;
    procedure WMPrint(var Message: TMessage); message WM_PRINT;
    procedure WMPrintClient(var Message: TMessage); message WM_PRINTCLIENT;
    procedure WMSetCursor(var Message: TWMSetCursor); message WM_SETCURSOR;
    {$IFNDEF JR_D4}
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    {$ENDIF}
  protected
    property ActivateParent: Boolean read FActivateParent write FActivateParent default True;
    property AutoResize: Boolean read FAutoResize write SetAutoResize default True;
    property BorderStyle: TBorderStyle read FBorderStyle write SetBorderStyle default bsSingle;
    property Color default clBtnFace;
    property CloseButton: Boolean read FCloseButton write SetCloseButton default True;
    property CloseButtonDown: Boolean read FCloseButtonDown;
    property CloseButtonHover: Boolean read FCloseButtonHover;
    property CloseButtonWhenDocked: Boolean read FCloseButtonWhenDocked write SetCloseButtonWhenDocked default False;
    property DefaultDock: TppTBDock read FDefaultDock write SetDefaultDock;
    property DockableTo: TppTBDockableTo read FDockableTo write FDockableTo default [dpTop, dpBottom, dpLeft, dpRight];
    property DockableWindowStyles: TppTBDockableWindowStyles read FDockableWindowStyles write FDockableWindowStyles;
    property DockMode: TppTBDockMode read FDockMode write FDockMode default dmCanFloat;
    property DragHandleStyle: TppTBDragHandleStyle read FDragHandleStyle write SetDragHandleStyle default dhSingle;
    property FloatingMode: TppTBFloatingMode read FFloatingMode write SetFloatingMode default fmOnTopOfParentForm;
    property FullSize: Boolean read FFullSize write SetFullSize default False;
    property InactiveCaption: Boolean read FInactiveCaption;
    property HideWhenInactive: Boolean read FHideWhenInactive write FHideWhenInactive default True;
    property Resizable: Boolean read FResizable write SetResizable default True;
    property ShowCaption: Boolean read FShowCaption write SetShowCaption default True;
    property SmoothDrag: Boolean read FSmoothDrag write FSmoothDrag default True;
    property Stretch: Boolean read FStretch write SetStretch default False;
    property UseLastDock: Boolean read FUseLastDock write SetUseLastDock default True;
    //property Version: TToolbar97Version read GetVersion write SetVersion stored False;

    property OnClose: TNotifyEvent read FOnClose write FOnClose;
    property OnCloseQuery: TCloseQueryEvent read FOnCloseQuery write FOnCloseQuery;
    property OnDockChanged: TNotifyEvent read FOnDockChanged write FOnDockChanged;
    property OnDockChanging: TppTBDockChangingEvent read FOnDockChanging write FOnDockChanging;
    property OnDockChangingHidden: TppTBDockChangingEvent read FOnDockChangingHidden write FOnDockChangingHidden;
    property OnMove: TNotifyEvent read FOnMove write FOnMove;
    property OnRecreated: TNotifyEvent read FOnRecreated write FOnRecreated;
    property OnRecreating: TNotifyEvent read FOnRecreating write FOnRecreating;
    {$IFNDEF JR_D4}
    property OnResize: TNotifyEvent read FOnResize write FOnResize;
    {$ENDIF}
    property OnVisibleChanged: TNotifyEvent read FOnVisibleChanged write FOnVisibleChanged;

    { Overridden methods }
    procedure CreateParams(var Params: TCreateParams); override;
    procedure DefineProperties(Filer: TFiler); override;
    function GetPalette: HPALETTE; override;
    procedure Loaded; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    function PaletteChanged(Foreground: Boolean): Boolean; override;
    procedure SetParent(AParent: TWinControl); override;

    { Methods accessible to descendants }
    procedure Arrange;
    function CalcNCSizes: TPoint; virtual;
    function CanDockTo(ADock: TppTBDock): Boolean; virtual;
    procedure ChangeSize(AWidth, AHeight: Integer);
    function ChildControlTransparent(Ctl: TControl): Boolean; dynamic;
    procedure Close;
    procedure ControlExistsAtPos(const P: TPoint; var ControlExists: Boolean); virtual;
    function DoArrange(CanMoveControls: Boolean; PreviousDockType: TppTBDockType;
      NewFloating: Boolean; NewDock: TppTBDock): TPoint; virtual; abstract;
    procedure DoDockChangingHidden(NewFloating: Boolean; DockingTo: TppTBDock); dynamic;
    procedure DoubleClick;
    procedure DrawNCArea(const DrawToDC: Boolean; const ADC: HDC;
      const Clip: HRGN); virtual;
    procedure GetBaseSize(var ASize: TPoint); virtual; abstract;
    function GetDockedCloseButtonRect(LeftRight: Boolean): TRect; virtual;
    function GetFloatingWindowParentClass: TppTBFloatingWindowParentClass; dynamic;
    procedure GetMinShrinkSize(var AMinimumSize: Integer); virtual;
    procedure GetMinMaxSize(var AMinClientWidth, AMinClientHeight,
      AMaxClientWidth, AMaxClientHeight: Integer); virtual;
    function GetShrinkMode: TppTBShrinkMode; virtual;
    procedure InitializeOrdering; dynamic;
    function IsAutoResized: Boolean;
    procedure ResizeBegin(SizeHandle: TppTBSizeHandle); dynamic;
    procedure ResizeEnd; dynamic;
    procedure ResizeTrack(var Rect: TRect; const OrigRect: TRect); dynamic;
    procedure ResizeTrackAccept; dynamic;
    procedure SizeChanging(const AWidth, AHeight: Integer); virtual;
    property EffectiveDockPosAccess: Integer read FEffectiveDockPos write FEffectiveDockPos;
    property EffectiveDockRowAccess: Integer read FEffectiveDockRow write FEffectiveDockRow;
  public
    property DblClickUndock: Boolean read FDblClickUndock write FDblClickUndock default True;
    property Docked: Boolean read FDocked;
    property CurrentDock: TppTBDock read FCurrentDock write SetCurrentDock stored False;
    property CurrentSize: Integer read FCurrentSize write FCurrentSize;
    property DockPos: Integer read FDockPos write SetDockPos default -1;
    property DockRow: Integer read FDockRow write SetDockRow default 0;
    property EffectiveDockPos: Integer read FEffectiveDockPos;
    property EffectiveDockRow: Integer read FEffectiveDockRow;
    property Floating: Boolean read FFloating write SetFloating default False;
    property FloatingPosition: TPoint read FFloatingPosition write SetFloatingPosition;
    property LastDock: TppTBDock read FLastDock write SetLastDock stored IsLastDockStored;
    property NonClientWidth: Integer read GetNonClientWidth;
    property NonClientHeight: Integer read GetNonClientHeight;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetParentComponent: TComponent; override;
    function HasParent: Boolean; override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;

    procedure AddDockForm(const Form: TppTBCustomForm);
    procedure AddDockedNCAreaToSize(var S: TPoint; const LeftRight: Boolean);
    procedure AddFloatingNCAreaToSize(var S: TPoint);
    procedure BeginMoving(const InitX, InitY: Integer);
    procedure BeginSizing(const ASizeHandle: TppTBSizeHandle);
    procedure BeginUpdate;
    procedure DoneReadingPositionData(const Data: TppTBReadPositionData); dynamic;
    procedure EndUpdate;
    procedure GetDockedNCArea(var TopLeft, BottomRight: TPoint;
      const LeftRight: Boolean);
    function GetFloatingBorderSize: TPoint; virtual;
    procedure GetFloatingNCArea(var TopLeft, BottomRight: TPoint);
    function IsMovable: Boolean;
    procedure MoveOnScreen(const OnlyIfFullyOffscreen: Boolean);
    procedure ReadPositionData(const Data: TppTBReadPositionData); dynamic;
    procedure RemoveDockForm(const Form: TppTBCustomForm);
    procedure WritePositionData(const Data: TppTBWritePositionData); dynamic;
  published
    property Height stored IsWidthAndHeightStored;
    property Width stored IsWidthAndHeightStored;
  end;

  TppTBBasicBackground = class(TComponent)
  protected
    procedure Draw(DC: HDC; const DrawRect: TRect); virtual; abstract;
    function GetPalette: HPALETTE; virtual; abstract;
    procedure RegisterChanges(Proc: TNotifyEvent); virtual; abstract;
    procedure SysColorChanged; virtual; abstract;
    procedure UnregisterChanges(Proc: TNotifyEvent); virtual; abstract;
    function UsingBackground: Boolean; virtual; abstract;
  end;

  TppTBBackground = class(TppTBBasicBackground)
  private
    FBitmap, FBitmapCache: TBitmap;
    FBkColor: TColor;
    FNotifyList: TList;
    FTransparent: Boolean;
    procedure BitmapChanged(Sender: TObject);
    procedure SetBitmap(Value: TBitmap);
    procedure SetBkColor(Value: TColor);
    procedure SetTransparent(Value: Boolean);
  protected
    procedure Draw(DC: HDC; const DrawRect: TRect); override;
    function GetPalette: HPALETTE; override;
    procedure RegisterChanges(Proc: TNotifyEvent); override;
    procedure SysColorChanged; override;
    procedure UnregisterChanges(Proc: TNotifyEvent); override;
    function UsingBackground: Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Bitmap: TBitmap read FBitmap write SetBitmap;
    property BkColor: TColor read FBkColor write SetBkColor default clBtnFace;
    property Transparent: Boolean read FTransparent write SetTransparent default False;
  end;

procedure TBRegLoadPositions(const OwnerComponent: TComponent;
  const RootKey: DWORD; const BaseRegistryKey: String);
procedure TBRegSavePositions(const OwnerComponent: TComponent;
  const RootKey: DWORD; const BaseRegistryKey: String);
procedure TBIniLoadPositions(const OwnerComponent: TComponent;
  const Filename, SectionNamePrefix: String);
procedure TBIniSavePositions(const OwnerComponent: TComponent;
  const Filename, SectionNamePrefix: String);

procedure TBCustomLoadPositions(const OwnerComponent: TComponent;
  const ReadIntProc: TppTBPositionReadIntProc;
  const ReadStringProc: TppTBPositionReadStringProc; const ExtraData: Pointer);
procedure TBCustomSavePositions(const OwnerComponent: TComponent;
  const WriteIntProc: TppTBPositionWriteIntProc;
  const WriteStringProc: TppTBPositionWriteStringProc; const ExtraData: Pointer);

function TBGetDockTypeOf(const Control: TppTBDock; const Floating: Boolean): TppTBDockType;
function TBGetToolWindowParentForm(const ToolWindow: TppTBCustomDockableWindow):
  TppTBCustomForm;
function TBValidToolWindowParentForm(const ToolWindow: TppTBCustomDockableWindow):
  TppTBCustomForm;

implementation

uses
  Registry, IniFiles, Consts, Menus,
  ppTB2Common,
  ppTB2Hook,
  ppTB2Consts;

type
  TControlAccess = class(TControl);

const
  DockedBorderSize = 2;
  DockedBorderSize2 = DockedBorderSize*2;
  DragHandleSizes: array[Boolean, TppTBDragHandleStyle] of Integer =
    ((9, 0, 6), (14, 14, 14));
  DragHandleXOffsets: array[Boolean, TppTBDragHandleStyle] of Integer =
    ((2, 0, 1), (3, 0, 5));
  HT_TB2k_Border = 2000;
  HT_TB2k_Close = 2001;
  HT_TB2k_Caption = 2002;

  DefaultBarWidthHeight = 8;

  ForceDockAtTopRow = 0;
  ForceDockAtLeftPos = -8;

  PositionLeftOrRight = [dpLeft, dpRight];

  twrdAll = [Low(TppTBToolWindowNCRedrawWhatElement)..High(TppTBToolWindowNCRedrawWhatElement)];

  { Constants for TppTBCustomDockableWindow registry values/data.
    Don't localize any of these names! }
  rvRev = 'Rev';
  rdCurrentRev = 2000;
  rvVisible = 'Visible';
  rvDockedTo = 'DockedTo';
  rdDockedToFloating = '+';
  rvLastDock = 'LastDock';
  rvDockRow = 'DockRow';
  rvDockPos = 'DockPos';
  rvFloatLeft = 'FloatLeft';
  rvFloatTop = 'FloatTop';

var
  FloatingToolWindows: TList = nil;


{ Misc. functions }

function GetSmallCaptionHeight: Integer;
{ Returns height of the caption of a small window }
begin
  Result := GetSystemMetrics(SM_CYSMCAPTION);
end;

function GetMDIParent(const Form: TppTBCustomForm): TppTBCustomForm;
{ Returns the parent of the specified MDI child form. But, if Form isn't a
  MDI child, it simply returns Form. }
var
  I, J: Integer;
begin
  Result := Form;
  if Form = nil then Exit;
  if {$IFDEF JR_D3} (Form is TForm) and {$ENDIF}
     (TForm(Form).FormStyle = fsMDIChild) then
    for I := 0 to Screen.FormCount-1 do
      with Screen.Forms[I] do begin
        if FormStyle <> fsMDIForm then Continue;
        for J := 0 to MDIChildCount-1 do
          if MDIChildren[J] = Form then begin
            Result := Screen.Forms[I];
            Exit;
          end;
      end;
end;

function TBGetDockTypeOf(const Control: TppTBDock; const Floating: Boolean): TppTBDockType;
begin
  if Floating then
    Result := dtFloating
  else
  if Control = nil then
    Result := dtNotDocked
  else begin
    if not(Control.Position in PositionLeftOrRight) then
      Result := dtTopBottom
    else
      Result := dtLeftRight;
  end;
end;

function TBGetToolWindowParentForm(const ToolWindow: TppTBCustomDockableWindow): TppTBCustomForm;
var
  Ctl: TWinControl;
begin
  Result := nil;
  Ctl := ToolWindow;
  while Assigned(Ctl.Parent) do begin
    if Ctl.Parent is TppTBCustomForm then
      Result := TppTBCustomForm(Ctl.Parent);
    Ctl := Ctl.Parent;
  end;
  { ^ for compatibility with ActiveX controls, that code is used instead of
    GetParentForm because it returns nil unless the form is the *topmost*
    parent }
  if Result is TppTBFloatingWindowParent then
    Result := TppTBFloatingWindowParent(Result).ParentForm;
end;

function TBValidToolWindowParentForm(const ToolWindow: TppTBCustomDockableWindow): TppTBCustomForm;
begin
  Result := TBGetToolWindowParentForm(ToolWindow);
  if Result = nil then
    raise EInvalidOperation.{$IFDEF JR_D3}CreateFmt{$ELSE}CreateResFmt{$ENDIF}
      (SParentRequired, [ToolWindow.Name]);
end;

procedure ToolbarHookProc(Code: THookProcCode; Wnd: HWND; WParam: WPARAM; LParam: LPARAM);
var
  I: Integer;
  ToolWindow: TppTBCustomDockableWindow;
  Form: TppTBCustomForm;
begin
  case Code of
    hpSendActivateApp: begin
        if Assigned(FloatingToolWindows) then
          for I := 0 to FloatingToolWindows.Count-1 do
            with TppTBCustomDockableWindow(FloatingToolWindows.List[I]) do
              { Hide or restore toolbars when application is deactivated or activated.
                UpdateVisibility also sets caption state active/inactive }
              UpdateVisibility;
      end;
    hpSendWindowPosChanged: begin
        if Assigned(FloatingToolWindows) then
          for I := 0 to FloatingToolWindows.Count-1 do begin
            ToolWindow := TppTBCustomDockableWindow(FloatingToolWindows.List[I]);
            with ToolWindow do begin
              if (FFloatingMode = fmOnTopOfParentForm) and HandleAllocated then begin
                with PWindowPos(LParam)^ do
                  { Call UpdateVisibility if parent form's visibility has
                    changed, or if it has been minimized or restored }
                  if ((flags and (SWP_SHOWWINDOW or SWP_HIDEWINDOW) <> 0) or
                      (flags and SWP_FRAMECHANGED <> 0)) then begin
                    Form := TBGetToolWindowParentForm(ToolWindow);
                    if Assigned(Form) and Form.HandleAllocated and ((Wnd = Form.Handle) or IsChild(Wnd, Form.Handle)) then
                      UpdateVisibility;
                  end;
              end;
            end;
          end;
      end;
    hpPreDestroy: begin
        if Assigned(FloatingToolWindows) then
          for I := 0 to FloatingToolWindows.Count-1 do begin
            with TppTBCustomDockableWindow(FloatingToolWindows.List[I]) do
              { It must remove the form window's ownership of the tool window
                *before* the form gets destroyed, otherwise Windows will destroy
                the tool window's handle. }
              if Assigned(Parent) and Parent.HandleAllocated and
                 (HWND(GetWindowLong(Parent.Handle, GWL_HWNDPARENT)) = Wnd) then
                SetWindowLong(Parent.Handle, GWL_HWNDPARENT, Longint(Application.Handle));
                { ^ Restore GWL_HWNDPARENT back to Application.Handle }
          end;
      end;
  end;
end;

type
  PFindWindowData = ^TFindWindowData;
  TFindWindowData = record
    TaskActiveWindow, TaskFirstWindow, TaskFirstTopMost: HWND;
  end;

function DoFindWindow(Wnd: HWND; Param: Longint): Bool; stdcall;
begin
  with PFindWindowData(Param)^ do
    if (Wnd <> TaskActiveWindow) and (Wnd <> Application.Handle) and
       IsWindowVisible(Wnd) and IsWindowEnabled(Wnd) then begin
      if GetWindowLong(Wnd, GWL_EXSTYLE) and WS_EX_TOPMOST = 0 then begin
        if TaskFirstWindow = 0 then TaskFirstWindow := Wnd;
      end
      else begin
        if TaskFirstTopMost = 0 then TaskFirstTopMost := Wnd;
      end;
    end;
  Result := True;
end;

function FindTopLevelWindow(ActiveWindow: HWND): HWND;
var
  FindData: TFindWindowData;
begin
  with FindData do begin
    TaskActiveWindow := ActiveWindow;
    TaskFirstWindow := 0;
    TaskFirstTopMost := 0;
    EnumThreadWindows(GetCurrentThreadID, @DoFindWindow, Longint(@FindData));
    if TaskFirstWindow <> 0 then
      Result := TaskFirstWindow
    else
      Result := TaskFirstTopMost;
  end;
end;

procedure RecalcNCArea(const Ctl: TWinControl);
begin
  if Ctl.HandleAllocated then
    SetWindowPos(Ctl.Handle, 0, 0, 0, 0, 0, SWP_FRAMECHANGED or
      SWP_NOACTIVATE or SWP_NOMOVE or SWP_NOSIZE or SWP_NOZORDER);
end;

procedure InvalidateAll(const Ctl: TWinControl);
{ Invalidate both non-client and client area, and erase. }
begin
  if Ctl.HandleAllocated then
    RedrawWindow(Ctl.Handle, nil, 0, RDW_FRAME or RDW_INVALIDATE or
      RDW_ERASE or RDW_NOCHILDREN);
end;                   

type
  TSetCloseButtonStateProc = procedure(Pushed: Boolean) of object;

function CloseButtonLoop(const Wnd: HWND; const ButtonRect: TRect;
  const SetCloseButtonStateProc: TSetCloseButtonStateProc): Boolean;
  function MouseInButton: Boolean;
  var
    P: TPoint;
  begin
    GetCursorPos(P);
    Result := PtInRect(ButtonRect, P);
  end;
var
  Msg: TMsg;
begin
  Result := False;

  SetCloseButtonStateProc(MouseInButton);

  SetCapture(Wnd);

  try
    while GetCapture = Wnd do begin
      case Integer(GetMessage(Msg, 0, 0, 0)) of
        -1: Break; { if GetMessage failed }
        0: begin
             { Repost WM_QUIT messages }
             PostQuitMessage(Msg.WParam);
             Break;
           end;
      end;

      case Msg.Message of
        WM_KEYDOWN, WM_KEYUP:
          { Ignore all keystrokes while in a close button loop }
          ;
        WM_MOUSEMOVE: begin
            { Note to self: WM_MOUSEMOVE messages should never be dispatched
              here to ensure no hints get shown }
            SetCloseButtonStateProc(MouseInButton);
          end;
        WM_LBUTTONDOWN, WM_LBUTTONDBLCLK:
          { Make sure it doesn't begin another loop }
          Break;
        WM_LBUTTONUP: begin
            if MouseInButton then
              Result := True;
            Break;
          end;
        WM_RBUTTONDOWN..WM_MBUTTONDBLCLK:
          { Ignore all other mouse up/down messages }
          ;
      else
        TranslateMessage(Msg);
        DispatchMessage(Msg);
      end;
    end;
  finally
    if GetCapture = Wnd then
      ReleaseCapture;
    SetCloseButtonStateProc(False);
  end;
end;


{ TppTBDock - internal }

constructor TppTBDock.Create(AOwner: TComponent);
begin
  inherited;

  ControlStyle := ControlStyle + [csAcceptsControls, csMenuEvents] -
    [csClickEvents, csCaptureMouse, csOpaque];
  FAllowDrag := True;
  FBkgOnToolbars := True;
  DockList := TList.Create;
  DockVisibleList := TList.Create;
  Color := clBtnFace;
  Position := dpTop;
end;

procedure TppTBDock.CreateParams(var Params: TCreateParams);
begin
  inherited;
  { Disable complete redraws when size changes. CS_H/VREDRAW cause flicker
    and are not necessary for this control at run time }
  if not(csDesigning in ComponentState) then
    with Params.WindowClass do
      Style := Style and not(CS_HREDRAW or CS_VREDRAW);
end;

destructor TppTBDock.Destroy;
begin
  if Assigned(FBackground) then
    FBackground.UnregisterChanges(BackgroundChanged);
  inherited;
  DockVisibleList.Free;
  DockList.Free;
end;

procedure TppTBDock.SetParent(AParent: TWinControl);
begin
  if (AParent is TppTBCustomDockableWindow) or (AParent is TppTBDock) then
    raise EInvalidOperation.Create(ppSTBDockParentNotAllowed);

  inherited;
end;

procedure TppTBDock.BeginUpdate;
begin
  Inc(FDisableArrangeToolbars);
end;

procedure TppTBDock.EndUpdate;
begin
  Dec(FDisableArrangeToolbars);
  if FArrangeToolbarsNeeded and (FDisableArrangeToolbars = 0) then
    ArrangeToolbars;
end;

function TppTBDock.HasVisibleToolbars: Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to DockList.Count-1 do
    if ToolbarVisibleOnDock(TppTBCustomDockableWindow(DockList[I])) then begin
      Result := True;
      Break;
    end;
end;

function TppTBDock.ToolbarVisibleOnDock(const AToolbar: TppTBCustomDockableWindow): Boolean;
begin
  Result := (AToolbar.Parent = Self) and
    (AToolbar.Visible or (csDesigning in AToolbar.ComponentState));
end;

function TppTBDock.GetCurrentRowSize(const Row: Integer;
  var AFullSize: Boolean): Integer;
var
  I, J: Integer;
  T: TppTBCustomDockableWindow;
begin
  Result := 0;
  AFullSize := False;
  if Row < 0 then Exit;
  for I := 0 to DockList.Count-1 do begin
    T := DockList[I];
    if (T.FEffectiveDockRow = Row) and ToolbarVisibleOnDock(T) then begin
      AFullSize := T.FullSize;
      if not(Position in PositionLeftOrRight) then
        J := T.Height
      else
        J := T.Width;
      if J > Result then
        Result := J;
    end;
  end;
end;

function TppTBDock.GetMinRowSize(const Row: Integer;
  const ExcludeControl: TppTBCustomDockableWindow): Integer;
var
  I, J: Integer;
  T: TppTBCustomDockableWindow;
begin
  Result := 0;
  if Row < 0 then Exit;
  for I := 0 to DockList.Count-1 do begin
    T := DockList[I];
    if (T <> ExcludeControl) and (T.FEffectiveDockRow = Row) and
       ToolbarVisibleOnDock(T) then begin
      J := T.FLastRowSize;
      if J > Result then
        Result := J;
    end;
  end;
end;

function TppTBDock.GetDesignModeRowOf(const XY: Integer): Integer;
{ Similar to GetRowOf, but is a little different to accomidate design mode
  better }
var
  HighestRowPlus1, R, CurY, CurRowSize: Integer;
  FullSize: Boolean;
begin
  Result := 0;
  HighestRowPlus1 := GetHighestRow(True)+1;
  CurY := 0;
  for R := 0 to HighestRowPlus1 do begin
    Result := R;
    if R = HighestRowPlus1 then Break;
    CurRowSize := GetCurrentRowSize(R, FullSize);
    if CurRowSize = 0 then Continue;
    Inc(CurY, CurRowSize);
    if XY < CurY then
      Break;
  end;
end;

function TppTBDock.GetHighestRow(const HighestEffective: Boolean): Integer;
{ Returns highest used row number, or -1 if no rows are used }
var
  I, J: Integer;
begin
  Result := -1;
  for I := 0 to DockList.Count-1 do
    with TppTBCustomDockableWindow(DockList[I]) do begin
      if HighestEffective then
        J := FEffectiveDockRow
      else
        J := FDockRow;
      if J > Result then
        Result := J;
    end;
end;

procedure TppTBDock.ChangeWidthHeight(const NewWidth, NewHeight: Integer);
{ Same as setting Width/Height directly, but does not lose Align position. }
begin
  case Align of
    alNone, alTop, alLeft:
      SetBounds(Left, Top, NewWidth, NewHeight);
    alBottom:
      SetBounds(Left, Top-NewHeight+Height, NewWidth, NewHeight);
    alRight:
      SetBounds(Left-NewWidth+Width, Top, NewWidth, NewHeight);
  end;
end;

function TppTBDock.Accepts(ADockableWindow: TppTBCustomDockableWindow): Boolean;
begin
  Result := AllowDrag;
end;

procedure TppTBDock.AlignControls(AControl: TControl; var Rect: TRect);
begin
  ArrangeToolbars;
end;

function CompareDockRowPos(const Item1, Item2, ExtraData: Pointer): Integer; far;
begin
  if TppTBCustomDockableWindow(Item1).FDockRow <> TppTBCustomDockableWindow(Item2).FDockRow then
    Result := TppTBCustomDockableWindow(Item1).FDockRow - TppTBCustomDockableWindow(Item2).FDockRow
  else
    Result := TppTBCustomDockableWindow(Item1).FDockPos - TppTBCustomDockableWindow(Item2).FDockPos;
end;

procedure TppTBDock.ArrangeToolbars;
{ The main procedure to arrange all the toolbars docked to it }
type
  PPosDataRec = ^TPosDataRec;
  TPosDataRec = record
    Row, ActualRow, PrecSpace, FullSize, MinimumSize, Size, Overlap, Pos: Integer;
    ShrinkMode: TppTBShrinkMode;
    NeedArrange: Boolean;
  end;
  PPosDataArray = ^TPosDataArray;
  TPosDataArray = array[0..$7FFFFFFF div SizeOf(TPosDataRec)-1] of TPosDataRec;
var
  NewDockList: TList;
  PosData: PPosDataArray;

  function ShiftLeft(const Row, StartIndex, MaxSize: Integer): Integer;
  { Removes PrecSpace pixels from toolbars at or before StartIndex until the
    right edge of the toolbar at StartIndex is <= MaxSize.
    Returns the total number of PrecSpace pixels removed from toolbars. }
  var
    PixelsOffEdge, I, J: Integer;
    P: PPosDataRec;
  begin
    Result := 0;
    PixelsOffEdge := -MaxSize;
    for I := 0 to StartIndex do begin
      P := @PosData[I];
      if P.Row = Row then begin
        Inc(PixelsOffEdge, P.PrecSpace);
        Inc(PixelsOffEdge, P.Size);
      end;
    end;
    if PixelsOffEdge > 0 then
      for I := StartIndex downto 0 do begin
        P := @PosData[I];
        if P.Row = Row then begin
          J := PixelsOffEdge;
          if P.PrecSpace < J then
            J := P.PrecSpace;
          Dec(P.PrecSpace, J);
          Dec(PixelsOffEdge, J);
          Inc(Result, J);
          if PixelsOffEdge = 0 then
            Break;
        end;
      end;
  end;

  function GetNextToolbar(const GoForward: Boolean; const Row: Integer;
    const StartIndex: Integer): Integer;
  var
    I: Integer;
  begin
    Result := -1;
    I := StartIndex;
    while True do begin
      if GoForward then begin
        Inc(I);
        if I >= NewDockList.Count then
          Break;
      end
      else begin
        Dec(I);
        if I < 0 then
          Break;
      end;
      if PosData[I].Row = Row then begin
        Result := I;
        Break;
      end;
    end;
  end;

var
  LeftRight: Boolean;
  EmptySize, HighestRow, R, CurPos, CurRowPixel, I, J, K, L, M, ClientW,
    ClientH, MaxSize, TotalSize, PixelsPastMaxSize, Offset, CurRealPos, DragIndex,
    MinRealPos, DragIndexPos, PushOffset, ToolbarsOnRow, CurRowSize: Integer;
  P: PPosDataRec;
  T: TppTBCustomDockableWindow;
  S: TPoint;
  RowIsEmpty: Boolean;
label FoundNextToolbar;
begin
  if (FDisableArrangeToolbars > 0) or (csLoading in ComponentState) then begin
    FArrangeToolbarsNeeded := True;
    Exit;
  end;

  NewDockList := nil;
  PosData := nil;
  Inc(FDisableArrangeToolbars);
  try
    { Work around VCL alignment bug when docking toolbars taller or wider than
      the client height or width of the form. }
    {if not(csDesigning in ComponentState) and HandleAllocated then
      SetWindowPos(Handle, HWND_TOP, 0, 0, 0, 0,
        SWP_NOACTIVATE or SWP_NOMOVE or SWP_NOSIZE);}

    LeftRight := Position in PositionLeftOrRight;

    if not HasVisibleToolbars then begin
      EmptySize := Ord(FFixAlign);
      if csDesigning in ComponentState then
        EmptySize := 9;
      if not LeftRight then
        ChangeWidthHeight(Width, EmptySize)
      else
        ChangeWidthHeight(EmptySize, Height);
      Exit;
    end;

    { It can't read the ClientWidth and ClientHeight properties because they
      attempt to create a handle, which requires Parent to be set. "ClientW"
      and "ClientH" are calculated instead. }
    ClientW := Width - FNonClientWidth;
    if ClientW < 0 then ClientW := 0;
    ClientH := Height - FNonClientHeight;
    if ClientH < 0 then ClientH := 0;

    { Remove toolbars from DockList & DockVisibleList that are destroying, so
      that no methods on these toolbars will be called.
      This is needed because in certain rare cases ArrangeToolbars can be
      indirectly called while a docked toolbar is being destroyed. }
    for I := DockList.Count-1 downto 0 do begin
      T := DockList[I];
      if csDestroying in T.ComponentState then begin
        DockList.Delete(I);
        DockVisibleList.Remove(T);
      end;
    end;

    { If LimitToOneRow is True, only use the first row }
    if FLimitToOneRow then
      for I := 0 to DockList.Count-1 do
        with TppTBCustomDockableWindow(DockList[I]) do
          FDockRow := 0;

    { Copy DockList to NewDockList, and ensure it is in correct ordering
      according to DockRow/DockPos }
    NewDockList := TList.Create;
    NewDockList.Count := DockList.Count;
    for I := 0 to NewDockList.Count-1 do
      NewDockList[I] := DockList[I];
    I := NewDockList.IndexOf(FDragToolbar);
    ListSortEx(NewDockList, CompareDockRowPos, nil);
    DragIndex := NewDockList.IndexOf(FDragToolbar);
    if (I <> -1) and FDragSplitting then begin
      { When splitting, don't allow the toolbar being dragged to change
        positions in the dock list }
      NewDockList.Move(DragIndex, I);
      DragIndex := I;
    end;
    ListSortEx(DockVisibleList, CompareDockRowPos, nil);
    { Find highest row number }
    HighestRow := GetHighestRow(False);

    { Create a temporary array that holds new position data for the toolbars }
    PosData := AllocMem(NewDockList.Count * SizeOf(TPosDataRec));
    for I := 0 to NewDockList.Count-1 do begin
      P := @PosData[I];
      T := NewDockList[I];
      P.ActualRow := T.FDockRow;
      if ToolbarVisibleOnDock(T) then
        P.Row := T.FDockRow
      else
        P.Row := -1;
      P.Pos := T.FDockPos;
    end;

    { Find FInsertRowBefore=True and FullSize=True toolbars and make sure there
      aren't any other toolbars on the same row. If there are, shift them down
      a row. }
    for L := 0 to 1 do begin
      R := 0;
      while R <= HighestRow do begin
        for I := 0 to NewDockList.Count-1 do begin
          T := NewDockList[I];
          if (PosData[I].ActualRow = R) and
             (((L = 0) and T.FInsertRowBefore and not LimitToOneRow) or
              ((L = 1) and T.FullSize)) then
            for J := 0 to NewDockList.Count-1 do
              if (J <> I) and (PosData[J].ActualRow = R) then begin
                for K := 0 to NewDockList.Count-1 do begin
                  if K <> I then begin
                    P := @PosData[K];
                    if P.ActualRow >= R then
                      Inc(P.ActualRow);
                    if P.Row >= R then
                      Inc(P.Row);
                  end;
                end;
                Inc(HighestRow);
                Break;
              end;
        end;
        Inc(R);
      end;
    end;

    { Remove blank rows.
      Note that rows that contain only invisible or currently floating toolbars
      are intentionally not removed, so that when the toolbars are shown again,
      they stay on their own row. }
    R := 0;
    while R <= HighestRow do begin
      RowIsEmpty := True;
      for I := 0 to NewDockList.Count-1 do
        if PosData[I].ActualRow = R then begin
          RowIsEmpty := False;
          Break;
        end;
      if RowIsEmpty then begin
        { Shift all ones higher than R back one }
        for I := 0 to NewDockList.Count-1 do begin
          if PosData[I].ActualRow > R then
            Dec(PosData[I].ActualRow);
          if PosData[I].Row > R then
            Dec(PosData[I].Row);
        end;
        Dec(HighestRow);
      end
      else
        Inc(R);
    end;

    { Calculate positions and sizes of each row }
    R := 0;
    while R <= HighestRow do begin
      if not LeftRight then
        MaxSize := ClientW
      else
        MaxSize := ClientH;

      { Set initial sizes }
      TotalSize := 0;
      ToolbarsOnRow := 0;
      MinRealPos := 0;
      for I := 0 to NewDockList.Count-1 do begin
        P := @PosData[I];
        if P.Row = R then begin
          T := NewDockList[I];
          T.GetBaseSize(S);
          if not LeftRight then
            J := S.X + T.NonClientWidth
          else
            J := S.Y + T.NonClientHeight;
          P.FullSize := J;
          P.Size := J;
          P.ShrinkMode := T.GetShrinkMode;
          P.MinimumSize := 0;
          T.GetMinShrinkSize(P.MinimumSize);
          if P.MinimumSize > P.FullSize then
            { don't allow minimum shrink size to be less than full size } 
            P.MinimumSize := P.FullSize;
          if P.ShrinkMode = tbsmChevron then
            Inc(MinRealPos, P.MinimumSize)
          else
            Inc(MinRealPos, P.FullSize);
          { If the toolbar isn't the first toolbar on the row, and the toolbar
            would go off the edge even after it's shrunk, then move it onto a
            row of its own }
          if (ToolbarsOnRow > 0) and (MinRealPos > MaxSize) and
             not LimitToOneRow then begin
            for K := I to NewDockList.Count-1 do begin
              P := @PosData[K];
              if P.ActualRow >= R then
                Inc(P.ActualRow);
              if P.Row >= R then
                Inc(P.Row);
            end;
            Inc(HighestRow);
            Break;
          end;
          Inc(TotalSize, J);
          Inc(ToolbarsOnRow);
        end;
      end;
      PixelsPastMaxSize := TotalSize - MaxSize;

      { Set initial arrangement; don't shrink toolbars yet }
      DragIndexPos := 0;
      CurPos := 0;
      CurRealPos := 0;
      MinRealPos := 0;
      PushOffset := 0;
      for I := 0 to NewDockList.Count-1 do begin
        P := @PosData[I];
        T := NewDockList[I];
        if P.Row = R then begin
          if (CurPos = 0) and (T.FullSize or T.Stretch) then
            { Force to left }
            J := 0
          else
            J := T.FDockPos + PushOffset;
          if I = DragIndex then
            DragIndexPos := J;
          if J < MinRealPos then
            J := MinRealPos;
          if J > CurPos then begin
            K := J - CurPos;
            if PixelsPastMaxSize <= 0 then
              P.PrecSpace := K
            else
              Inc(PushOffset, K);
            CurPos := J;
          end
          else begin
            if J < CurRealPos then
              P.Overlap := CurRealPos - J;
          end;

          Inc(CurPos, P.Size);
          CurRealPos := J + P.Size;
          Inc(MinRealPos, P.MinimumSize);
        end;
      end;

      { If we aren't exceeding MaxSize, allow the toolbar being dragged
        to push other toolbars to the left }
      if (PixelsPastMaxSize < 0) and (DragIndex <> -1) and
         (PosData[DragIndex].Row = R) then begin
        I := GetNextToolbar(False, R, DragIndex);
        if I <> -1 then begin
          J := ShiftLeft(R, I, DragIndexPos);
          if J > 0 then begin
            { Ensure that toolbars that follow the toolbar being dragged stay
              at the same place by increasing PrecSpace on the next toolbar }
            I := GetNextToolbar(True, R, DragIndex);
            if I <> -1 then
              Inc(PosData[I].PrecSpace, J);
          end;
        end;
      end;

      { If any toolbars are going off the edge of the dock, try to make them
        at least partially visible by shifting preceding toolbars left }
      I := GetNextToolbar(False, R, NewDockList.Count);
      if I <> -1 then
        ShiftLeft(R, I, MaxSize);

      { Shrink toolbars that overlap other toolbars (Overlaps[x] > 0) }
      if PixelsPastMaxSize > 0 then begin
        Offset := 0;
        for I := 0 to NewDockList.Count-1 do begin
          if PosData[I].Row <> R then
            Continue;
          if (ToolbarsOnRow > 1) and (NewDockList[I] = FDragToolbar) then
            FDragCanSplit := True;
          Inc(Offset, PosData[I].Overlap);
          if Offset > PixelsPastMaxSize then
            Offset := PixelsPastMaxSize;
          if Offset > 0 then
            for J := I-1 downto 0 do begin
              P := @PosData[J];
              if P.Row <> R then
                Continue;
              { How much can we shrink this toolbar J to get toolbar I to
                its preferred position? }
              if P.ShrinkMode = tbsmChevron then
                L := Offset
              else
                L := 0;
              K := -(P.Size - L - P.MinimumSize);  { the number of pixels that exceed the minimum size }
              if K > 0 then
                { Don't shrink a toolbar below its minimum allowed size }
                Dec(L, K);
              Dec(P.Size, L);
              Dec(PixelsPastMaxSize, L);
              Dec(Offset, L);
              if (Offset = 0) or
                 { This is needed so toolbars can push other toolbars to the
                   right when splitting: }
                 (J = DragIndex) then
                Break;
            end;
        end;
      end;

      { Still exceeding MaxSize? Make sure the rightmost toolbar(s) are
        at least partially visible with a width of MinimumSize }
      if PixelsPastMaxSize > 0 then begin
        for I := NewDockList.Count-1 downto 0 do begin
          P := @PosData[I];
          if (P.Row <> R) or (P.ShrinkMode = tbsmNone) or
             ((P.ShrinkMode = tbsmWrap) and (ToolbarsOnRow > 1)) then
            Continue;
          J := P.Size - P.MinimumSize;
          if J > 0 then begin  { can we shrink this toolbar any? }
            if J > PixelsPastMaxSize then
              J := PixelsPastMaxSize;
            Dec(P.Size, J);
            Dec(PixelsPastMaxSize, J);
          end;
          if PixelsPastMaxSize = 0 then
            Break;
        end;
      end;

      { Set Poses, and adjust size of FullSize & Stretch toolbars }
      CurPos := 0;
      for I := 0 to NewDockList.Count-1 do begin
        P := @PosData[I];
        T := NewDockList[I];
        if P.Row = R then begin
          if T.FullSize or T.Stretch then begin
            { Remove any preceding space from this toolbar }
            Inc(P.Size, P.PrecSpace);
            P.PrecSpace := 0;
          end;
          Inc(CurPos, P.PrecSpace);
          if T.FullSize then begin
            { Claim all space }
            if P.Size < MaxSize then
              P.Size := MaxSize;
          end
          else if T.Stretch then begin
            { Steal any preceding space from the next toolbar }
            for J := I+1 to NewDockList.Count-1 do
              if PosData[J].Row = R then begin
                Inc(P.Size, PosData[J].PrecSpace);
                PosData[J].PrecSpace := 0;
                goto FoundNextToolbar;
              end;
            { or claim any remaining space }
            if P.Size < MaxSize - CurPos then
              P.Size := MaxSize - CurPos;
            FoundNextToolbar:
          end;
          P.Pos := CurPos;
          Inc(CurPos, P.Size);
        end;
      end;

      Inc(R);
    end;

    for I := 0 to NewDockList.Count-1 do begin
      T := NewDockList[I];
      T.FEffectiveDockRow := PosData[I].ActualRow;
      T.FEffectiveDockPos := PosData[I].Pos;
      { If FCommitNewPositions is True, update all the toolbars' DockPos and
        DockRow properties to match the actual positions.
        Also update the ordering of DockList to match NewDockList }
      if FCommitNewPositions then begin
        T.FDockRow := T.FEffectiveDockRow;
        T.FDockPos := T.FEffectiveDockPos;
        DockList[I] := NewDockList[I];
      end;
    end;

    { Now actually move the toolbars }
    CurRowPixel := 0;
    for R := 0 to HighestRow do begin
      CurRowSize := 0;
      for I := 0 to NewDockList.Count-1 do begin
        P := @PosData[I];
        T := NewDockList[I];
        if P.Row = R then begin
          K := T.FCurrentSize;
          T.FCurrentSize := P.Size;
          if P.Size >= P.FullSize then begin
            T.FCurrentSize := 0;
            { Reason: so that if new items are added to a non-shrunk toolbar
              at run-time (causing its width to increase), the toolbar won't
              shrink unnecessarily }
          end;
          if (P.ShrinkMode <> tbsmNone) and (T.FCurrentSize <> K) then begin
            { If Size is changing and we are to display a chevron or wrap,
              call DoArrange to get an accurate row size }
            S := T.DoArrange(False, TBGetDockTypeOf(Self, False), False, Self);
            { Force a rearrange in case the actual size isn't changing but the
              chevron visibility might have changed (which can happen if
              items are added to a FullSize=True toolbar at run-time) }
            P.NeedArrange := True;
          end
          else begin
            if (P.ShrinkMode = tbsmWrap) and (P.Size < P.FullSize) then begin
              { Preserve existing height (or width) on a wrapped toolbar
                whose size isn't changing now }
              S.X := T.Width - T.NonClientWidth;
              S.Y := T.Height - T.NonClientHeight;
            end
            else
              T.GetBaseSize(S);
          end;
          if not LeftRight then
            K := S.Y
          else
            K := S.X;
          T.FLastRowSize := K;
          if K > CurRowSize then
            CurRowSize := K;
        end;
      end;
      if CurRowSize <> 0 then
        Inc(CurRowSize, DockedBorderSize2);
      for I := 0 to NewDockList.Count-1 do begin
        P := @PosData[I];
        T := NewDockList[I];
        if P.Row = R then begin
          Inc(T.FUpdatingBounds);
          try
            K := T.FCurrentSize;
            if P.NeedArrange then
              T.FArrangeNeeded := True;
            if not LeftRight then
              T.SetBounds(P.Pos, CurRowPixel, P.Size, CurRowSize)
            else
              T.SetBounds(CurRowPixel, P.Pos, CurRowSize, P.Size);
            if T.FArrangeNeeded then
              { ^ don't arrange again if SetBounds call already caused one }
              T.Arrange;
            { Restore FCurrentSize since TppTBToolbarView.DoUpdatePositions
              clears it }
            T.FCurrentSize := K;
          finally
            Dec(T.FUpdatingBounds);
          end;
        end;
      end;
      Inc(CurRowPixel, CurRowSize);
    end;

    { Set the size of the dock }
    if not LeftRight then
      ChangeWidthHeight(Width, CurRowPixel + FNonClientHeight)
    else
      ChangeWidthHeight(CurRowPixel + FNonClientWidth, Height);
  finally
    Dec(FDisableArrangeToolbars);
    FArrangeToolbarsNeeded := False;
    FCommitNewPositions := False;
    FreeMem(PosData);
    NewDockList.Free;
  end;
end;

procedure TppTBDock.CommitPositions;
{ Copies docked toolbars' EffectiveDockRow and EffectiveDockPos properties
  into DockRow and DockPos respectively.
  Note that this does not reorder DockList like ArrangeToolbars does when
  FCommitNewPositions=True. }
var
  I: Integer;
  T: TppTBCustomDockableWindow;
begin
  for I := 0 to DockVisibleList.Count-1 do begin
    T := DockVisibleList[I];
    T.FDockRow := T.FEffectiveDockRow;
    T.FDockPos := T.FEffectiveDockPos;
  end;
end;

procedure TppTBDock.ChangeDockList(const Insert: Boolean;
  const Bar: TppTBCustomDockableWindow);
{ Inserts or removes Bar from DockList }
var
  I: Integer;
begin
  I := DockList.IndexOf(Bar);
  if Insert then begin
    if I = -1 then begin
      Bar.FreeNotification(Self);
      DockList.Add(Bar);
    end;
  end
  else begin
    if I <> -1 then
      DockList.Delete(I);
  end;
  ToolbarVisibilityChanged(Bar, False);
end;

procedure TppTBDock.ToolbarVisibilityChanged(const Bar: TppTBCustomDockableWindow;
  const ForceRemove: Boolean);
var
  Modified, VisibleOnDock: Boolean;
  I: Integer;
begin
  Modified := False;
  I := DockVisibleList.IndexOf(Bar);
  VisibleOnDock := not ForceRemove and ToolbarVisibleOnDock(Bar);
  if VisibleOnDock then begin
    if I = -1 then begin
      DockVisibleList.Add(Bar);
      Modified := True;
    end;
  end
  else begin
    if I <> -1 then begin
      DockVisibleList.Remove(Bar);
      Modified := True;
    end;
  end;

  if Modified then begin
    ArrangeToolbars;

    if Assigned(FOnInsertRemoveBar) then
      FOnInsertRemoveBar(Self, VisibleOnDock, Bar);
  end;
end;

procedure TppTBDock.Loaded;
begin
  inherited;
  { Rearranging is disabled while the component is loading, so now that it's
    loaded, rearrange it. }
  ArrangeToolbars;
end;

procedure TppTBDock.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
  if Operation = opRemove then begin
    if AComponent = FBackground then
      Background := nil
    else if AComponent is TppTBCustomDockableWindow then begin
      DockList.Remove(AComponent);
      DockVisibleList.Remove(AComponent);
    end;
  end;
end;

function TppTBDock.GetPalette: HPALETTE;
begin
  if UsingBackground and Assigned(FBackground) then
    { ^ by default UsingBackground returns False if FBackground isn't assigned,
      but UsingBackground may be overridden and return True when it isn't }
    Result := FBackground.GetPalette
  else
    Result := 0;
end;

procedure TppTBDock.WMEraseBkgnd(var Message: TWMEraseBkgnd);
var
  R, R2: TRect;
  P1, P2: TPoint;
  SaveIndex: Integer;
begin
  { Draw the Background if there is one, otherwise use default erasing
    behavior }
  if UsingBackground then begin
    R := ClientRect;
    R2 := R;
    { Make up for nonclient area }
    P1 := ClientToScreen(Point(0, 0));
    P2 := Parent.ClientToScreen(BoundsRect.TopLeft);
    Dec(R2.Left, Left + (P1.X-P2.X));
    Dec(R2.Top, Top + (P1.Y-P2.Y));
    SaveIndex := SaveDC(Message.DC);
    IntersectClipRect(Message.DC, R.Left, R.Top, R.Right, R.Bottom);
    DrawBackground(Message.DC, R2);
    RestoreDC(Message.DC, SaveIndex);
    Message.Result := 1;
  end
  else
    inherited;
end;

procedure TppTBDock.Paint;
var
  R: TRect;
begin
  inherited;
  { Draw dotted border in design mode }
  if csDesigning in ComponentState then begin
    R := ClientRect;
    with Canvas do begin
      Pen.Style := psDot;
      Pen.Color := clBtnShadow;
      Brush.Style := bsClear;
      Rectangle(R.Left, R.Top, R.Right, R.Bottom);
      Pen.Style := psSolid;
    end;
  end;
end;

procedure TppTBDock.WMMove(var Message: TWMMove);
begin
  inherited;
  if UsingBackground then
    InvalidateBackgrounds;
end;

{$IFNDEF JR_D4}
procedure TppTBDock.WMSize(var Message: TWMSize);
begin
  inherited;
  if not(csLoading in ComponentState) and Assigned(FOnResize) then
    FOnResize(Self);
end;
{$ENDIF}

procedure TppTBDock.WMNCCalcSize(var Message: TWMNCCalcSize);
begin
  inherited;
  { note to self: non-client size is stored in FNonClientWidth &
    FNonClientHeight }
  with Message.CalcSize_Params^.rgrc[0] do begin
    if blTop in BoundLines then Inc(Top);
    if blBottom in BoundLines then Dec(Bottom);
    if blLeft in BoundLines then Inc(Left);
    if blRight in BoundLines then Dec(Right);
  end;
end;

procedure TppTBDock.DrawNCArea(const DrawToDC: Boolean; const ADC: HDC;
  const Clip: HRGN);

  procedure DrawLine(const DC: HDC; const X1, Y1, X2, Y2: Integer);
  begin
    MoveToEx(DC, X1, Y1, nil);  LineTo(DC, X2, Y2);
  end;
var
  RW, R, R2, RC: TRect;
  DC: HDC;
  HighlightPen, ShadowPen, SavePen: HPEN;
  FillBrush: HBRUSH;
label 1;
begin
  { This works around WM_NCPAINT problem described at top of source code }
  {no!  R := Rect(0, 0, Width, Height);}
  GetWindowRect(Handle, RW);
  R := RW;
  OffsetRect(R, -R.Left, -R.Top);

  if not DrawToDC then
    DC := GetWindowDC(Handle)
  else
    DC := ADC;
  try
    { Use update region }
    if not DrawToDC then
      SelectNCUpdateRgn(Handle, DC, Clip);

    { Draw BoundLines }
    R2 := R;
    if (BoundLines <> []) and
       ((csDesigning in ComponentState) or HasVisibleToolbars) then begin
      HighlightPen := CreatePen(PS_SOLID, 1, GetSysColor(COLOR_BTNHIGHLIGHT));
      ShadowPen := CreatePen(PS_SOLID, 1, GetSysColor(COLOR_BTNSHADOW));
      SavePen := SelectObject(DC, ShadowPen);
      if blTop in BoundLines then begin
        DrawLine(DC, R.Left, R.Top, R.Right, R.Top);
        Inc(R2.Top);
      end;
      if blLeft in BoundLines then begin
        DrawLine(DC, R.Left, R.Top, R.Left, R.Bottom);
        Inc(R2.Left);
      end;
      SelectObject(DC, HighlightPen);
      if blBottom in BoundLines then begin
        DrawLine(DC, R.Left, R.Bottom-1, R.Right, R.Bottom-1);
        Dec(R2.Bottom);
      end;
      if blRight in BoundLines then begin
        DrawLine(DC, R.Right-1, R.Top, R.Right-1, R.Bottom);
        Dec(R2.Right);
      end;
      SelectObject(DC, SavePen);
      DeleteObject(ShadowPen);
      DeleteObject(HighlightPen);
    end;
    Windows.GetClientRect(Handle, RC);
    if not IsRectEmpty(RC) then begin
      { ^ ExcludeClipRect can't be passed rectangles that have (Bottom < Top) or
        (Right < Left) since it doesn't treat them as empty }
      MapWindowPoints(Handle, 0, RC, 2);
      OffsetRect(RC, -RW.Left, -RW.Top);
      if EqualRect(RC, R2) then
        { Skip FillRect because there would be nothing left after ExcludeClipRect }
        goto 1;
      ExcludeClipRect(DC, RC.Left, RC.Top, RC.Right, RC.Bottom);
    end;
    FillBrush := CreateSolidBrush(ColorToRGB(Color));
    FillRect(DC, R2, FillBrush);
    DeleteObject(FillBrush);
    1:
  finally
    if not DrawToDC then
      ReleaseDC(Handle, DC);
  end;
end;

procedure TppTBDock.WMNCPaint(var Message: TMessage);
begin
  DrawNCArea(False, 0, HRGN(Message.WParam));
end;

procedure DockNCPaintProc(Wnd: HWND; DC: HDC; AppData: Longint);
begin
  TppTBDock(AppData).DrawNCArea(True, DC, 0);
end;

procedure TppTBDock.WMPrint(var Message: TMessage);
begin
  HandleWMPrint(Handle, Message, DockNCPaintProc, Longint(Self));
end;

procedure TppTBDock.WMPrintClient(var Message: TMessage);
begin
  HandleWMPrintClient(Self, Message);
end;

procedure TppTBDock.CMSysColorChange(var Message: TMessage);
begin
  inherited;
  if Assigned(FBackground) then
    FBackground.SysColorChanged;
end;

procedure TppTBDock.RelayMsgToFloatingBars(var Message: TMessage);
var
  I: Integer;
  T: TppTBCustomDockableWindow;
begin
  for I := 0 to DockList.Count-1 do begin
    T := DockList[I];
    if (csMenuEvents in T.ControlStyle) and T.Floating and T.Showing and
       T.Enabled then begin
      Message.Result := T.Perform(Message.Msg, Message.WParam, Message.LParam);
      if Message.Result <> 0 then
        Exit;
    end;
  end;
end;

procedure TppTBDock.WMSysCommand(var Message: TWMSysCommand);
begin
  { Relay WM_SYSCOMMAND messages to floating toolbars which were formerly
    docked. That way, items on floating menu bars can be accessed with Alt. }
  RelayMsgToFloatingBars(TMessage(Message));
end;

procedure TppTBDock.CMDialogKey(var Message: TCMDialogKey);
begin
  RelayMsgToFloatingBars(TMessage(Message));
  if Message.Result = 0 then
    inherited;
end;

procedure TppTBDock.CMDialogChar(var Message: TCMDialogChar);
begin
  RelayMsgToFloatingBars(TMessage(Message));
  if Message.Result = 0 then
    inherited;
end;

{ TppTBDock - property access methods }

procedure TppTBDock.SetAllowDrag(Value: Boolean);
var
  I: Integer;
begin
  if FAllowDrag <> Value then begin
    FAllowDrag := Value;
    for I := 0 to ControlCount-1 do
      if Controls[I] is TppTBCustomDockableWindow then
        RecalcNCArea(TppTBCustomDockableWindow(Controls[I]));
  end;
end;

function TppTBDock.UsingBackground: Boolean;
begin
  Result := Assigned(FBackground) and FBackground.UsingBackground;
end;

procedure TppTBDock.DrawBackground(DC: HDC; const DrawRect: TRect);
begin
  FBackground.Draw(DC, DrawRect);
end;

procedure TppTBDock.InvalidateBackgrounds;
{ Called after background is changed }
var
  I: Integer;
  T: TppTBCustomDockableWindow;
begin
  Invalidate;
  { Synchronize child toolbars also }
  for I := 0 to DockList.Count-1 do begin
    T := TppTBCustomDockableWindow(DockList[I]);
    if ToolbarVisibleOnDock(T) then
      { Invalidate both non-client and client area }
      InvalidateAll(T);
  end;
end;

procedure TppTBDock.SetBackground(Value: TppTBBasicBackground);
begin
  if FBackground <> Value then begin
    if Assigned(FBackground) then
      FBackground.UnregisterChanges(BackgroundChanged);
    FBackground := Value;
    if Assigned(Value) then begin
      Value.FreeNotification(Self);
      Value.RegisterChanges(BackgroundChanged);
    end;
    InvalidateBackgrounds;
  end;
end;

procedure TppTBDock.BackgroundChanged(Sender: TObject);
begin
  InvalidateBackgrounds;
end;

procedure TppTBDock.SetBackgroundOnToolbars(Value: Boolean);
begin
  if FBkgOnToolbars <> Value then begin
    FBkgOnToolbars := Value;
    InvalidateBackgrounds;
  end;
end;

procedure TppTBDock.SetBoundLines(Value: TppTBDockBoundLines);
var
  X, Y: Integer;
  B: TppTBDockBoundLines;
begin
  if FBoundLines <> Value then begin
    FBoundLines := Value;
    X := 0;
    Y := 0;
    B := BoundLines;  { optimization }
    if blTop in B then Inc(Y);
    if blBottom in B then Inc(Y);
    if blLeft in B then Inc(X);
    if blRight in B then Inc(X);
    FNonClientWidth := X;
    FNonClientHeight := Y;
    RecalcNCArea(Self);
  end;
end;

procedure TppTBDock.SetFixAlign(Value: Boolean);
begin
  if FFixAlign <> Value then begin
    FFixAlign := Value;
    ArrangeToolbars;
  end;
end;

procedure TppTBDock.SetPosition(Value: TppTBDockPosition);
begin
  if (FPosition <> Value) and (ControlCount <> 0) then
    raise EInvalidOperation.Create(ppSTBDockCannotChangePosition);
  FPosition := Value;
  case Position of
    dpTop: Align := alTop;
    dpBottom: Align := alBottom;
    dpLeft: Align := alLeft;
    dpRight: Align := alRight;
  end;
end;

function TppTBDock.GetToolbarCount: Integer;
begin
  Result := DockVisibleList.Count;
end;

function TppTBDock.GetToolbars(Index: Integer): TppTBCustomDockableWindow;
begin
  Result := TppTBCustomDockableWindow(DockVisibleList[Index]);
end;

(*function TppTBDock.GetVersion: TToolbar97Version;
begin
  Result := Toolbar97VersionPropText;
end;

procedure TppTBDock.SetVersion(const Value: TToolbar97Version);
begin
  { write method required for the property to show up in Object Inspector }
end;*)


{ TppTBFloatingWindowParent - Internal }

constructor TppTBFloatingWindowParent.Create(AOwner: TComponent);
begin
  { Don't use TForm's Create since it attempts to load a form resource, which
    TppTBFloatingWindowParent doesn't have. }
  CreateNew(AOwner {$IFDEF VER93} , 0 {$ENDIF});
end;

destructor TppTBFloatingWindowParent.Destroy;
begin
  inherited;
end;

procedure TppTBFloatingWindowParent.CreateParams(var Params: TCreateParams);
const
  ThickFrames: array[Boolean] of DWORD = (0, WS_THICKFRAME);
begin
  inherited;

  { Disable complete redraws when size changes. CS_H/VREDRAW cause flicker
    and are not necessary for this control at run time }
  if not(csDesigning in ComponentState) then
    with Params.WindowClass do
      Style := Style and not(CS_HREDRAW or CS_VREDRAW);

  with Params do begin
    { Note: WS_THICKFRAME and WS_BORDER styles are included to ensure that
      sizing grips are displayed on child controls with scrollbars. The
      thick frame or border is not drawn by Windows; TCustomToolWindow97
      handles all border drawing by itself. }
    if not(csDesigning in ComponentState) then
      Style := WS_POPUP or WS_BORDER or ThickFrames[FDockableWindow.FResizable]
    else
      Style := Style or WS_BORDER or ThickFrames[FDockableWindow.FResizable];
    { The WS_EX_TOOLWINDOW style is needed so there isn't a taskbar button
      for the toolbar when FloatingMode = fmOnTopOfAllForms. }
    ExStyle := WS_EX_TOOLWINDOW;
  end;
end;

procedure TppTBFloatingWindowParent.AlignControls(AControl: TControl; var Rect: TRect);
begin
  { ignore Align setting of the child toolbar }
end;

procedure TppTBFloatingWindowParent.WMGetMinMaxInfo(var Message: TWMGetMinMaxInfo);
begin
  inherited;
  { Because the window uses the WS_THICKFRAME style (but not for the usual
    purpose), it must process the WM_GETMINMAXINFO message to remove the
    minimum and maximum size limits it imposes by default. }
  with Message.MinMaxInfo^ do begin
    with ptMinTrackSize do begin
      X := 1;
      Y := 1;
      { Note to self: Don't put GetMinimumSize code here, since
        ClientWidth/Height values are sometimes invalid during a RecreateWnd }
    end;
    with ptMaxTrackSize do begin
      { Because of the 16-bit (signed) size limitations of Windows 95,
        Smallints must be used instead of Integers or Longints }
      X := High(Smallint);
      Y := High(Smallint);
    end;
  end;
end;

procedure TppTBFloatingWindowParent.CMShowingChanged(var Message: TMessage);
const
  ShowFlags: array[Boolean] of UINT = (
    SWP_NOSIZE or SWP_NOMOVE or SWP_NOZORDER or SWP_NOACTIVATE or SWP_HIDEWINDOW,
    SWP_NOSIZE or SWP_NOMOVE or SWP_NOZORDER or SWP_NOACTIVATE or SWP_SHOWWINDOW);
begin
  { Must override TCustomForm/TForm's CM_SHOWINGCHANGED handler so that the
    form doesn't get activated when Visible is set to True. }
  SetWindowPos(WindowHandle, 0, 0, 0, 0, 0, ShowFlags[Showing and FShouldShow]);
end;

procedure TppTBFloatingWindowParent.CMDialogKey(var Message: TCMDialogKey);
begin
  { If Escape if pressed on a floating toolbar, return focus to the form }
  if (Message.CharCode = VK_ESCAPE) and (KeyDataToShiftState(Message.KeyData) = []) and
     Assigned(ParentForm) then begin
    ParentForm.SetFocus;
    Message.Result := 1;
  end
  else
    inherited;
end;

procedure TppTBFloatingWindowParent.CMTextChanged(var Message: TMessage);
begin
  inherited;
  RedrawNCArea([twrdCaption]);
end;

function GetCaptionRect(const Control: TppTBFloatingWindowParent;
  const AdjustForBorder, MinusCloseButton: Boolean): TRect;
begin
  Result := Rect(0, 0, Control.ClientWidth, GetSmallCaptionHeight-1);
  if MinusCloseButton then
    Dec(Result.Right, Result.Bottom);
  if AdjustForBorder then
    with Control.FDockableWindow.GetFloatingBorderSize do
      OffsetRect(Result, X, Y);
end;

function GetCloseButtonRect(const Control: TppTBFloatingWindowParent;
  const AdjustForBorder: Boolean): TRect;
begin
  Result := GetCaptionRect(Control, AdjustForBorder, False);
  Result.Left := Result.Right - (GetSmallCaptionHeight-1);
end;

procedure TppTBFloatingWindowParent.WMNCCalcSize(var Message: TWMNCCalcSize);
var
  TL, BR: TPoint;
begin
  { Doesn't call inherited since it overrides the normal NC sizes }
  Message.Result := 0;
  with Message.CalcSize_Params^ do begin
    FDockableWindow.GetFloatingNCArea(TL, BR);
    with rgrc[0] do begin
      Inc(Left, TL.X);
      Inc(Top, TL.Y);
      Dec(Right, BR.X);
      Dec(Bottom, BR.Y);
    end;
  end;
end;

procedure TppTBFloatingWindowParent.WMNCPaint(var Message: TMessage);
begin
  { Don't call inherited because it overrides the default NC painting }
  DrawNCArea(False, 0, HRGN(Message.WParam), twrdAll);
end;

procedure FloatingWindowParentNCPaintProc(Wnd: HWND; DC: HDC; AppData: Longint);
begin
  with TppTBFloatingWindowParent(AppData) do
    DrawNCArea(True, DC, 0, twrdAll);
end;

procedure TppTBFloatingWindowParent.WMPrint(var Message: TMessage);
begin
  HandleWMPrint(Handle, Message, FloatingWindowParentNCPaintProc, Longint(Self));
end;

procedure TppTBFloatingWindowParent.WMPrintClient(var Message: TMessage);
begin
  HandleWMPrintClient(Self, Message);
end;

procedure TppTBFloatingWindowParent.WMNCHitTest(var Message: TWMNCHitTest);
var
  P: TPoint;
  R: TRect;
  BorderSize: TPoint;
  C: Integer;
begin
  inherited;
  with Message do begin
    P := SmallPointToPoint(Pos);
    GetWindowRect(Handle, R);
    Dec(P.X, R.Left);  Dec(P.Y, R.Top);
    if Result <> HTCLIENT then begin
      Result := HTNOWHERE;
      if FDockableWindow.ShowCaption and PtInRect(GetCaptionRect(Self, True, False), P) then begin
        if FDockableWindow.FCloseButton and PtInRect(GetCloseButtonRect(Self, True), P) then
          Result := HT_TB2k_Close
        else
          Result := HT_TB2k_Caption;
      end
      else
      if FDockableWindow.Resizable then begin
        BorderSize := FDockableWindow.GetFloatingBorderSize;
        if not(tbdsResizeEightCorner in FDockableWindow.FDockableWindowStyles) then begin
          if (P.Y >= 0) and (P.Y < BorderSize.Y) then Result := HTTOP else
          if (P.Y < Height) and (P.Y >= Height-BorderSize.Y-1) then Result := HTBOTTOM else
          if (P.X >= 0) and (P.X < BorderSize.X) then Result := HTLEFT else
          if (P.X < Width) and (P.X >= Width-BorderSize.X-1) then Result := HTRIGHT;
        end
        else begin
          C := BorderSize.X + (GetSmallCaptionHeight-1);
          if (P.X >= 0) and (P.X < BorderSize.X) then begin
            Result := HTLEFT;
            if (P.Y < C) then Result := HTTOPLEFT else
            if (P.Y >= Height-C) then Result := HTBOTTOMLEFT;
          end
          else
          if (P.X < Width) and (P.X >= Width-BorderSize.X-1) then begin
            Result := HTRIGHT;
            if (P.Y < C) then Result := HTTOPRIGHT else
            if (P.Y >= Height-C) then Result := HTBOTTOMRIGHT;
          end
          else
          if (P.Y >= 0) and (P.Y < BorderSize.Y) then begin
            Result := HTTOP;
            if (P.X < C) then Result := HTTOPLEFT else
            if (P.X >= Width-C) then Result := HTTOPRIGHT;
          end
          else
          if (P.Y < Height) and (P.Y >= Height-BorderSize.Y-1) then begin
            Result := HTBOTTOM;
            if (P.X < C) then Result := HTBOTTOMLEFT else
            if (P.X >= Width-C) then Result := HTBOTTOMRIGHT;
          end;
        end;
      end;
    end;
  end;
end;

procedure TppTBFloatingWindowParent.SetCloseButtonState(Pushed: Boolean);
begin
  if FCloseButtonDown <> Pushed then begin
    FCloseButtonDown := Pushed;
    RedrawNCArea([twrdCloseButton]);
  end;
end;

procedure TppTBFloatingWindowParent.WMNCLButtonDown(var Message: TWMNCLButtonDown);
var
  P: TPoint;
  R, BR: TRect;
begin
  case Message.HitTest of
    HT_TB2k_Caption: begin
        P := FDockableWindow.ScreenToClient(Point(Message.XCursor, Message.YCursor));
        FDockableWindow.BeginMoving(P.X, P.Y);
      end;
    HTLEFT..HTBOTTOMRIGHT:
      if FDockableWindow.Resizable then
        FDockableWindow.BeginSizing(TppTBSizeHandle(Message.HitTest - HTLEFT));
    HT_TB2k_Close: begin
        GetWindowRect(Handle, R);
        BR := GetCloseButtonRect(Self, True);
        OffsetRect(BR, R.Left, R.Top);
        if CloseButtonLoop(Handle, BR, SetCloseButtonState) then
          FDockableWindow.Close;
      end;
  else
    inherited;
  end;
end;

procedure TppTBFloatingWindowParent.WMNCLButtonDblClk(var Message: TWMNCLButtonDblClk);
begin
  if Message.HitTest = HT_TB2k_Caption then
    FDockableWindow.DoubleClick;
end;

procedure TppTBFloatingWindowParent.WMNCRButtonUp(var Message: TWMNCRButtonUp);
begin
  FDockableWindow.ShowNCContextMenu(TSmallPoint(TMessage(Message).LParam));
end;

procedure TppTBFloatingWindowParent.WMClose(var Message: TWMClose);
var
  MDIParentForm: TppTBCustomForm;
begin
  { A floating toolbar does not use WM_CLOSE messages when its close button
    is clicked, but Windows still sends a WM_CLOSE message if the user
    presses Alt+F4 while one of the toolbar's controls is focused. Inherited
    is not called since we do not want Windows' default processing - which
    destroys the window. Instead, relay the message to the parent form. }
  MDIParentForm := GetMDIParent(TBGetToolWindowParentForm(FDockableWindow));
  if Assigned(MDIParentForm) and MDIParentForm.HandleAllocated then
    SendMessage(MDIParentForm.Handle, WM_CLOSE, 0, 0);
  { Note to self: MDIParentForm is used instead of OwnerForm since MDI
    childs don't process Alt+F4 as Close }
end;

procedure TppTBFloatingWindowParent.WMActivate(var Message: TWMActivate);
var
  ParentForm: TppTBCustomForm;
begin
  if csDesigning in ComponentState then begin
    inherited;
    Exit;
  end;

  ParentForm := GetMDIParent(TBGetToolWindowParentForm(FDockableWindow));

  if Assigned(ParentForm) and ParentForm.HandleAllocated then
    SendMessage(ParentForm.Handle, WM_NCACTIVATE, Ord(Message.Active <> WA_INACTIVE), 0);

  if Message.Active <> WA_INACTIVE then begin
    { This works around a "gotcha" in TCustomForm.CMShowingChanged. When a form
      is hidden, it uses the internal VCL function FindTopMostWindow to
      find a new active window. The problem is that handles of floating
      toolbars on the form being hidden can be returned by
      FindTopMostWindow, so the following code is used to prevent floating
      toolbars on the hidden form from being left active. }
    if not IsWindowVisible(Handle) then
      { ^ Calling IsWindowVisible with a floating toolbar handle will
         always return False if its parent form is hidden since the
         WH_CALLWNDPROC hook automatically updates the toolbars'
         visibility. }
      { Find and activate a window besides this toolbar }
      SetActiveWindow(FindTopLevelWindow(Handle))
    else
      { If the toolbar is being activated and the previous active window wasn't
        its parent form, the form is activated instead. This is done so that if
        the application is deactivated while a floating toolbar was active and
        the application is reactivated again, it returns focus to the form. }
      if Assigned(ParentForm) and ParentForm.HandleAllocated and
         (Message.ActiveWindow <> ParentForm.Handle) then
        SetActiveWindow(ParentForm.Handle);
  end;
end;

procedure TppTBFloatingWindowParent.WMMouseActivate(var Message: TWMMouseActivate);
var
  ParentForm, MDIParentForm: TppTBCustomForm;
begin
  if csDesigning in ComponentState then begin
    inherited;
    Exit;
  end;

  { When floating, prevent the toolbar from activating when clicked.
    This is so it doesn't take the focus away from the window that had it }
  Message.Result := MA_NOACTIVATE;

  { Similar to calling BringWindowToTop, but doesn't activate it }
  SetWindowPos(Handle, HWND_TOP, 0, 0, 0, 0,
    SWP_NOACTIVATE or SWP_NOMOVE or SWP_NOSIZE);

  { Since it is returning MA_NOACTIVATE, activate the form instead. }
  ParentForm := TBGetToolWindowParentForm(FDockableWindow);
  MDIParentForm := GetMDIParent(ParentForm);
  if (FDockableWindow.FFloatingMode = fmOnTopOfParentForm) and
     FDockableWindow.FActivateParent and
     Assigned(MDIParentForm) and (GetActiveWindow <> Handle) then begin
    { ^ Note to self: The GetActiveWindow check must be in there so that
        double-clicks work properly on controls like Edits }
    if MDIParentForm.HandleAllocated then
      SetActiveWindow(MDIParentForm.Handle);
    if (MDIParentForm <> ParentForm) and  { if it's an MDI child form }
       ParentForm.HandleAllocated then
      BringWindowToTop(ParentForm.Handle);
  end;
end;

procedure TppTBFloatingWindowParent.WMMove(var Message: TWMMove);
begin
  inherited;
  FDockableWindow.Moved;
end;

procedure TppTBFloatingWindowParent.DrawNCArea(const DrawToDC: Boolean;
  const ADC: HDC; const Clip: HRGN; RedrawWhat: TppTBToolWindowNCRedrawWhat);
{ Redraws all the non-client area (the border, title bar, and close button) of
  the toolbar when it is floating. }
const
  COLOR_GRADIENTACTIVECAPTION = 27;
  COLOR_GRADIENTINACTIVECAPTION = 28;
  CaptionBkColors: array[Boolean, Boolean] of Integer =
    ((COLOR_ACTIVECAPTION, COLOR_INACTIVECAPTION),
     (COLOR_GRADIENTACTIVECAPTION, COLOR_GRADIENTINACTIVECAPTION));
  CaptionTextColors: array[Boolean] of Integer =
    (COLOR_CAPTIONTEXT, COLOR_INACTIVECAPTIONTEXT);

  function GradientCaptionsEnabled: Boolean;
  const
    SPI_GETGRADIENTCAPTIONS = $1008;  { Win98/NT5 only }
  var
    S: BOOL;
  begin
    Result := SystemParametersInfo(SPI_GETGRADIENTCAPTIONS, 0, @S, 0) and S;
  end;

const
  CloseButtonState: array[Boolean] of UINT = (0, DFCS_PUSHED);
  ActiveCaptionFlags: array[Boolean] of UINT = (DC_ACTIVE, 0);
  DC_GRADIENT = $20;
  GradientCaptionFlags: array[Boolean] of UINT = (0, DC_GRADIENT);
var
  DC: HDC;
  R, R2: TRect;
  Gradient: Boolean;
  SavePen: HPEN;
  SaveIndex: Integer;
  S: TPoint;
begin
  if not HandleAllocated then Exit;

  if not DrawToDC then
    DC := GetWindowDC(Handle)
  else
    DC := ADC;
  try
    { Use update region }
    if not DrawToDC then
      SelectNCUpdateRgn(Handle, DC, Clip);

    { Work around an apparent NT 4.0 & 2000 bug. If the width of the DC is
      greater than the width of the screen, then any call to ExcludeClipRect
      inexplicably shrinks the clipping rectangle to the screen width. I've
      found that calling IntersectClipRect as done below magically fixes the
      problem (but I'm not sure why). }
    GetWindowRect(Handle, R);  OffsetRect(R, -R.Left, -R.Top);
    IntersectClipRect(DC, R.Left, R.Top, R.Right, R.Bottom);

    Gradient := GradientCaptionsEnabled;

    { Border }
    if twrdBorder in RedrawWhat then begin
      { This works around WM_NCPAINT problem described at top of source code }
      {no!  R := Rect(0, 0, Width, Height);}
      GetWindowRect(Handle, R);  OffsetRect(R, -R.Left, -R.Top);
      DrawEdge(DC, R, EDGE_RAISED, BF_RECT);
      SaveIndex := SaveDC(DC);
      S := FDockableWindow.GetFloatingBorderSize;
      with R do
        ExcludeClipRect(DC, Left + S.X, Top + S.Y, Right - S.X, Bottom - S.Y);
      InflateRect(R, -2, -2);
      FillRect(DC, R, GetSysColorBrush(COLOR_BTNFACE));
      RestoreDC(DC, SaveIndex);
    end;

    if FDockableWindow.ShowCaption then begin
      if (twrdCaption in RedrawWhat) and FDockableWindow.FCloseButton and
         (twrdCloseButton in RedrawWhat) then
        SaveIndex := SaveDC(DC)
      else
        SaveIndex := 0;
      try
        if SaveIndex <> 0 then
          with GetCloseButtonRect(Self, True) do
            { Reduces flicker }
            ExcludeClipRect(DC, Left, Top, Right, Bottom);

        { Caption }
        if twrdCaption in RedrawWhat then begin
          R := GetCaptionRect(Self, True, FDockableWindow.FCloseButton);
          { Note that Delphi's Win32 help for DrawCaption is totally wrong!
            I got updated info from www.microsoft.com/msdn/sdk/ }
          DrawCaption(Handle, DC, R, DC_TEXT or DC_SMALLCAP or
            ActiveCaptionFlags[FDockableWindow.FInactiveCaption] or
            GradientCaptionFlags[Gradient]);

          { Line below caption }
          R := GetCaptionRect(Self, True, False);
          SavePen := SelectObject(DC, CreatePen(PS_SOLID, 1, GetSysColor(COLOR_BTNFACE)));
          MoveToEx(DC, R.Left, R.Bottom, nil);
          LineTo(DC, R.Right, R.Bottom);
          DeleteObject(SelectObject(DC, SavePen));
        end;
      finally
        if SaveIndex <> 0 then
          RestoreDC(DC, SaveIndex);
      end;

      { Close button }
      if FDockableWindow.FCloseButton then begin
        R := GetCloseButtonRect(Self, True);
        R2 := R;
        InflateRect(R2, 0, -2);
        Dec(R2.Right, 2);
        if twrdCaption in RedrawWhat then begin
          SaveIndex := SaveDC(DC);
          ExcludeClipRect(DC, R2.Left, R2.Top, R2.Right, R2.Bottom);
          FillRect(DC, R, GetSysColorBrush(CaptionBkColors[Gradient,
            FDockableWindow.FInactiveCaption]));
          RestoreDC(DC, SaveIndex);
        end;
        if twrdCloseButton in RedrawWhat then
          DrawFrameControl(DC, R2, DFC_CAPTION, DFCS_CAPTIONCLOSE or
            CloseButtonState[FCloseButtonDown]);
      end;
    end;
  finally
    if not DrawToDC then
      ReleaseDC(Handle, DC);
  end;
end;

procedure TppTBFloatingWindowParent.RedrawNCArea(const RedrawWhat: TppTBToolWindowNCRedrawWhat);
begin
  { Note: IsWindowVisible is called as an optimization. There's no need to
    draw on invisible windows. }
  if HandleAllocated and IsWindowVisible(Handle) then
    DrawNCArea(False, 0, 0, RedrawWhat);
end;


{ TppTBCustomDockableWindow }

constructor TppTBCustomDockableWindow.Create(AOwner: TComponent);
begin
  inherited;

  ControlStyle := ControlStyle +
    [csAcceptsControls, csClickEvents, csDoubleClicks, csSetCaption] -
    [csCaptureMouse{capturing is done manually}, csOpaque];
  FAutoResize := True;
  FActivateParent := True;
  FBorderStyle := bsSingle;
  FCloseButton := True;
  FDblClickUndock := True;
  FDockableTo := [dpTop, dpBottom, dpLeft, dpRight];
  FDockableWindowStyles := [tbdsResizeEightCorner, tbdsResizeClipCursor];
  FDockPos := -1;
  FDragHandleStyle := dhSingle;
  FEffectiveDockRow := -1;
  FHideWhenInactive := True;
  FResizable := True;
  FShowCaption := True;
  FSmoothDrag := True;
  FUseLastDock := True;

  Color := clBtnFace;

  ppTBInstallHookProc(ToolbarHookProc,
    [hpSendActivateApp, hpSendWindowPosChanged, hpPreDestroy],
    csDesigning in ComponentState);
  InitTrackMouseEvent;
end;

destructor TppTBCustomDockableWindow.Destroy;
begin
  inherited;
  FDockForms.Free;  { must be done after 'inherited' because Notification accesses FDockForms }
  FFloatParent.Free;
  ppTBUninstallHookProc(ToolbarHookProc);
end;

function TppTBCustomDockableWindow.HasParent: Boolean;
begin
  if Parent is TppTBFloatingWindowParent then
    Result := False
  else
    Result := inherited HasParent;
end;

function TppTBCustomDockableWindow.GetParentComponent: TComponent;
begin
  if Parent is TppTBFloatingWindowParent then
    Result := nil
  else
    Result := inherited GetParentComponent;
end;

procedure TppTBCustomDockableWindow.SetInactiveCaption(Value: Boolean);
begin
  if csDesigning in ComponentState then
    Value := False;
  if FInactiveCaption <> Value then begin
    FInactiveCaption := Value;
    if Parent is TppTBFloatingWindowParent then
      TppTBFloatingWindowParent(Parent).RedrawNCArea(twrdAll);
  end;
end;

procedure TppTBCustomDockableWindow.Moved;
begin
  if not(csLoading in ComponentState) and Assigned(FOnMove) and (FDisableOnMove <= 0) then
    FOnMove(Self);
end;

procedure TppTBCustomDockableWindow.WMMove(var Message: TWMMove);

  procedure Redraw;
  { Redraws the control using an off-screen bitmap to avoid flicker }
  var
    CR, R: TRect;
    W: HWND;
    DC, BmpDC: HDC;
    Bmp: HBITMAP;
  begin
    if not HandleAllocated then Exit;
    CR := ClientRect;
    W := Handle;
    if GetUpdateRect(W, R, False) and EqualRect(R, CR) then begin
      { The client area is already completely invalid, so don't bother using
        an off-screen bitmap }
      InvalidateAll(Self);
      Exit;
    end;
    BmpDC := 0;
    Bmp := 0;
    DC := GetDC(W);
    try
      BmpDC := CreateCompatibleDC(DC);
      Bmp := CreateCompatibleBitmap(DC, CR.Right, CR.Bottom);
      SelectObject(BmpDC, Bmp);
      SendMessage(W, WM_NCPAINT, 0, 0);
      SendMessage(W, WM_ERASEBKGND, WPARAM(BmpDC), 0);
      SendMessage(W, WM_PAINT, WPARAM(BmpDC), 0);
      BitBlt(DC, 0, 0, CR.Right, CR.Bottom, BmpDC, 0, 0, SRCCOPY);
    finally
      if BmpDC <> 0 then DeleteDC(BmpDC);
      if Bmp <> 0 then DeleteObject(Bmp);
      ReleaseDC(W, DC);
    end;
    ValidateRect(W, nil);
  end;

begin
  inherited;
  FMoved := True;
  if Docked and CurrentDock.UsingBackground then begin
    { Needs to redraw so that the background is lined up with the dock at the
      new position. }
    Redraw;
  end;
  Moved;
end;

{$IFNDEF JR_D4}
procedure TppTBCustomDockableWindow.WMSize(var Message: TWMSize);
begin
  inherited;
  if not(csLoading in ComponentState) and Assigned(FOnResize) then
    FOnResize(Self);
end;
{$ENDIF}

procedure TppTBCustomDockableWindow.WMEnable(var Message: TWMEnable);
begin
  inherited;
  { When a modal dialog is displayed and the toolbar window gets disabled as
    a result, remove its topmost flag. }
  if FFloatingMode = fmOnTopOfAllForms then
    UpdateTopmostFlag;
end;

function TppTBCustomDockableWindow.GetShowingState: Boolean;
var
  HideFloatingToolbars: Boolean;
  ParentForm, MDIParentForm: TppTBCustomForm;
begin
  Result := Showing and (FHidden = 0);
  if Floating and not(csDesigning in ComponentState) then begin
    HideFloatingToolbars := FFloatingMode = fmOnTopOfParentForm;
    if HideFloatingToolbars then begin
      ParentForm := TBGetToolWindowParentForm(Self);
      MDIParentForm := GetMDIParent(ParentForm);
      if Assigned(ParentForm) and Assigned(MDIParentForm) then begin
        HideFloatingToolbars := not ParentForm.HandleAllocated or
          not MDIParentForm.HandleAllocated;
        if not HideFloatingToolbars then begin
          HideFloatingToolbars := IsIconic(Application.Handle) or
            not IsWindowVisible(ParentForm.Handle) or IsIconic(ParentForm.Handle);
          if MDIParentForm <> ParentForm then
            HideFloatingToolbars := HideFloatingToolbars or
              not IsWindowVisible(MDIParentForm.Handle) or IsIconic(MDIParentForm.Handle);
        end;
      end;
    end;
    Result := Result and not (HideFloatingToolbars or (FHideWhenInactive and not ApplicationIsActive));
  end;
end;

procedure TppTBCustomDockableWindow.UpdateVisibility;
begin
  SetInactiveCaption(Floating and (not FHideWhenInactive and not ApplicationIsActive));
  if HandleAllocated and (IsWindowVisible(Handle) <> GetShowingState) then
    Perform(CM_SHOWINGCHANGED, 0, 0);
end;

function IsTopmost(const Wnd: HWND): Boolean;
begin
  Result := GetWindowLong(Wnd, GWL_EXSTYLE) and WS_EX_TOPMOST <> 0;
end;

procedure TppTBCustomDockableWindow.UpdateTopmostFlag;
const
  Wnds: array[Boolean] of HWND = (HWND_NOTOPMOST, HWND_TOPMOST);
var
  ShouldBeTopmost: Boolean;
begin
  if HandleAllocated then begin
    if FFloatingMode = fmOnTopOfAllForms then
      ShouldBeTopmost := IsWindowEnabled(Handle)
    else
      ShouldBeTopmost := IsTopmost(HWND(GetWindowLong(Parent.Handle, GWL_HWNDPARENT)));
    if ShouldBeTopmost <> IsTopmost(Parent.Handle) then
      { ^ it must check if it already was topmost or non-topmost or else
        it causes problems on Win95/98 for some reason }
      SetWindowPos(Parent.Handle, Wnds[ShouldBeTopmost], 0, 0, 0, 0,
        SWP_NOACTIVATE or SWP_NOMOVE or SWP_NOSIZE);
  end;
end;

procedure TppTBCustomDockableWindow.CMShowingChanged(var Message: TMessage);

  function GetPrevWnd(W: HWND): HWND;
  var
    WasTopmost, Done: Boolean;
    ParentWnd: HWND;
  begin
    WasTopmost := IsTopmost(Parent.Handle);
    Result := W;
    repeat
      Done := True;
      Result := GetWindow(Result, GW_HWNDPREV);
      ParentWnd := Result;
      while ParentWnd <> 0 do begin
        if WasTopmost and not IsTopmost(ParentWnd) then begin
          Done := False;
          Break;
        end;
        ParentWnd := HWND(GetWindowLong(ParentWnd, GWL_HWNDPARENT));
        if ParentWnd = W then begin
          Done := False;
          Break;
        end;
      end;
    until Done;
  end;

const
  ShowFlags: array[Boolean] of UINT = (
    SWP_NOSIZE or SWP_NOMOVE or SWP_NOZORDER or SWP_NOACTIVATE or SWP_HIDEWINDOW,
    SWP_NOSIZE or SWP_NOMOVE or SWP_NOZORDER or SWP_NOACTIVATE or SWP_SHOWWINDOW);
var
  Show: Boolean;
  Form: TppTBCustomForm;
begin
  { inherited isn't called since TppTBCustomDockableWindow handles CM_SHOWINGCHANGED
    itself. For reference, the original TWinControl implementation is:
    const
      ShowFlags: array[Boolean] of Word = (
        SWP_NOSIZE + SWP_NOMOVE + SWP_NOZORDER + SWP_NOACTIVATE + SWP_HIDEWINDOW,
        SWP_NOSIZE + SWP_NOMOVE + SWP_NOZORDER + SWP_NOACTIVATE + SWP_SHOWWINDOW);
    begin
      SetWindowPos(FHandle, 0, 0, 0, 0, 0, ShowFlags[FShowing]);
    end;
  }
  if HandleAllocated then begin
    Show := GetShowingState;
    if Parent is TppTBFloatingWindowParent then begin
      if Show then begin
        { If the toolbar is floating, set its "owner window" to the parent form
          so that the toolbar window always stays on top of the form }
        if FFloatingMode = fmOnTopOfParentForm then begin
          Form := GetMDIParent(TBGetToolWindowParentForm(Self));
          if Assigned(Form) and Form.HandleAllocated and
             (HWND(GetWindowLong(Parent.Handle, GWL_HWNDPARENT)) <> Form.Handle) then begin
            SetWindowLong(Parent.Handle, GWL_HWNDPARENT, Longint(Form.Handle));
            { Following is necessarily to make it immediately realize the
              GWL_HWNDPARENT change }
            SetWindowPos(Parent.Handle, GetPrevWnd(Form.Handle), 0, 0, 0, 0, SWP_NOACTIVATE or
              SWP_NOMOVE or SWP_NOSIZE);
          end;
        end
        else begin
          SetWindowLong(Parent.Handle, GWL_HWNDPARENT, Longint(Application.Handle));
        end;
      end;
      UpdateTopmostFlag;
      { Show/hide the TppTBFloatingWindowParent. The following lines had to be
        added to fix a problem that was in 1.65d/e. In 1.65d/e, it always
        kept TppTBFloatingWindowParent visible (this change was made to improve
        compatibility with D4's Actions), but this for some odd reason would
        cause a Stack Overflow error if the program's main form was closed
        while a floating toolwindow was focused. (This problem did not occur
        on NT.) }
      TppTBFloatingWindowParent(Parent).FShouldShow := Show;
      Parent.Perform(CM_SHOWINGCHANGED, 0, 0);
    end;
    SetWindowPos(Handle, 0, 0, 0, 0, 0, ShowFlags[Show]);
    if not Show and (GetActiveWindow = Handle) then
      { If the window is hidden but is still active, find and activate a
        different window }
      SetActiveWindow(FindTopLevelWindow(Handle));
  end;
end;

procedure TppTBCustomDockableWindow.CreateParams(var Params: TCreateParams);
begin
  inherited;

  { Disable complete redraws when size changes. CS_H/VREDRAW cause flicker
    and are not necessary for this control at run time }
  if not(csDesigning in ComponentState) then
    with Params.WindowClass do
      Style := Style and not(CS_HREDRAW or CS_VREDRAW);
end;

procedure TppTBCustomDockableWindow.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
  if Operation = opRemove then begin
    if AComponent = FDefaultDock then
      FDefaultDock := nil
    else
    if AComponent = FLastDock then
      FLastDock := nil
    else begin
      RemoveFromList(FDockForms, AComponent);
      if Assigned(FFloatParent) and (csDestroying in FFloatParent.ComponentState) and
         (AComponent = FFloatParent.FParentForm) then begin
        { ^ Note: Must check csDestroying so that we are sure that FFloatParent
          is actually being destroyed and not just being removed from its
          Owner's component list }
        if Parent = FFloatParent then begin
          if FFloatingMode = fmOnTopOfParentForm then
            Parent := nil
          else
            FFloatParent.FParentForm := nil;
        end
        else begin
          FFloatParent.Free;
          FFloatParent := nil;
        end;
      end;
    end;
  end;
end;

procedure TppTBCustomDockableWindow.MoveOnScreen(const OnlyIfFullyOffscreen: Boolean);
{ Moves the (floating) toolbar so that it is fully (or at least mostly) in
  view on the screen }
var
  R, S, Test: TRect;
begin
  if Floating then begin
    R := Parent.BoundsRect;
    S := GetRectOfMonitorContainingRect(R, True);

    if OnlyIfFullyOffscreen and IntersectRect(Test, R, S) then
      Exit;

    if R.Right > S.Right then
      OffsetRect(R, S.Right - R.Right, 0);
    if R.Bottom > S.Bottom then
      OffsetRect(R, 0, S.Bottom - R.Bottom);
    if R.Left < S.Left then
      OffsetRect(R, S.Left - R.Left, 0);
    if R.Top < S.Top then
      OffsetRect(R, 0, S.Top - R.Top);
    Parent.BoundsRect := R;
  end;
end;

procedure TppTBCustomDockableWindow.ReadPositionData(const Data: TppTBReadPositionData);
begin
end;

procedure TppTBCustomDockableWindow.DoneReadingPositionData(const Data: TppTBReadPositionData);
begin
end;

procedure TppTBCustomDockableWindow.WritePositionData(const Data: TppTBWritePositionData);
begin
end;

procedure TppTBCustomDockableWindow.InitializeOrdering;
begin
end;

procedure TppTBCustomDockableWindow.SizeChanging(const AWidth, AHeight: Integer);
begin
end;

procedure TppTBCustomDockableWindow.ReadSavedAtRunTime(Reader: TReader);
begin
  FSavedAtRunTime := Reader.ReadBoolean;
end;

procedure TppTBCustomDockableWindow.WriteSavedAtRunTime(Writer: TWriter);
begin
  { WriteSavedAtRunTime only called when not(csDesigning in ComponentState) }
  Writer.WriteBoolean(True);
end;

procedure TppTBCustomDockableWindow.DefineProperties(Filer: TFiler);
begin
  inherited;
  Filer.DefineProperty('SavedAtRunTime', ReadSavedAtRunTime,
    WriteSavedAtRunTime, not(csDesigning in ComponentState));
end;

procedure TppTBCustomDockableWindow.Loaded;
var
  R: TRect;
begin
  inherited;
  { Adjust coordinates if it was initially floating }
  if not FSavedAtRunTime and not(csDesigning in ComponentState) and
     (Parent is TppTBFloatingWindowParent) then begin
    R := BoundsRect;
    MapWindowPoints(TBValidToolWindowParentForm(Self).Handle, 0, R, 2);
    BoundsRect := R;
    MoveOnScreen(False);
  end;
  InitializeOrdering;
  { Arranging is disabled while component was loading, so arrange now }
  Arrange;
end;

procedure TppTBCustomDockableWindow.BeginUpdate;
begin
  Inc(FDisableArrange);
end;

procedure TppTBCustomDockableWindow.EndUpdate;
begin
  Dec(FDisableArrange);
  if FArrangeNeeded and (FDisableArrange = 0) then
    Arrange;
end;

procedure TppTBCustomDockableWindow.AddDockForm(const Form: TppTBCustomForm);
begin
  if Form = nil then Exit;
  if AddToList(FDockForms, Form) then
    Form.FreeNotification(Self);
end;

procedure TppTBCustomDockableWindow.RemoveDockForm(const Form: TppTBCustomForm);
begin
  RemoveFromList(FDockForms, Form);
end;

function TppTBCustomDockableWindow.CanDockTo(ADock: TppTBDock): Boolean;
begin
  Result := ADock.Position in DockableTo; 
end;

function TppTBCustomDockableWindow.IsAutoResized: Boolean;
begin
  Result := AutoResize or Assigned(CurrentDock) or Floating;
end;

procedure TppTBCustomDockableWindow.ChangeSize(AWidth, AHeight: Integer);
var
  S: TPoint;
begin
  if Docked then
    CurrentDock.ArrangeToolbars
  else begin
    S := CalcNCSizes;
    Inc(AWidth, S.X);
    Inc(AHeight, S.Y);
    { Leave the width and/or height alone if the control is Anchored
      (or Aligned) }
    if not Floating then begin
      if (akLeft in Anchors) and (akRight in Anchors) then
        AWidth := Width;
      if (akTop in Anchors) and (akBottom in Anchors) then
        AHeight := Height;
    end;
    Inc(FUpdatingBounds);
    try
      SetBounds(Left, Top, AWidth, AHeight);
    finally
      Dec(FUpdatingBounds);
    end;
  end;
end;

procedure TppTBCustomDockableWindow.Arrange;
var
  Size: TPoint;
begin
  if (FDisableArrange > 0) or
     { Prevent flicker while loading }
     (csLoading in ComponentState) or
     { Don't call DoArrangeControls when Parent is nil. The VCL sets Parent to
       'nil' during destruction of a component; we can't have an OrderControls
       call after a descendant control has freed its data. }
     (Parent = nil) then begin
    FArrangeNeeded := True;
    Exit;
  end;

  FArrangeNeeded := False;

  Size := DoArrange(True, TBGetDockTypeOf(CurrentDock, Floating), Floating,
    CurrentDock);
  if IsAutoResized then
    ChangeSize(Size.X, Size.Y);
end;

procedure TppTBCustomDockableWindow.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  if not(csDesigning in ComponentState) and Floating then begin
    { Force Top & Left to 0 if floating }
    ALeft := 0;
    ATop := 0;
    if Parent is TppTBFloatingWindowParent then
      with Parent do
        SetBounds(Left, Top, (Width-ClientWidth) + AWidth,
          (Height-ClientHeight) + AHeight);
  end;
  if (FUpdatingBounds = 0) and ((AWidth <> Width) or (AHeight <> Height)) then
    SizeChanging(AWidth, AHeight);
  { This allows you to drag the toolbar around the dock at design time }
  if (csDesigning in ComponentState) and not(csLoading in ComponentState) and
     Docked and (FUpdatingBounds = 0) and ((ALeft <> Left) or (ATop <> Top)) then begin
    if not(CurrentDock.Position in PositionLeftOrRight) then begin
      FDockRow := CurrentDock.GetDesignModeRowOf(ATop+(Height div 2));
      FDockPos := ALeft;
    end
    else begin
      FDockRow := CurrentDock.GetDesignModeRowOf(ALeft+(Width div 2));
      FDockPos := ATop;
    end;
    inherited SetBounds(Left, Top, AWidth, AHeight);  { only pass any size changes }
    CurrentDock.ArrangeToolbars;  { let ArrangeToolbars take care of position changes }
  end
  else begin
    inherited;
    {if not(csLoading in ComponentState) and Floating and (FUpdatingBounds = 0) then
      FFloatingPosition := BoundsRect.TopLeft;}
  end;
end;

procedure TppTBCustomDockableWindow.SetParent(AParent: TWinControl);
  procedure UpdateFloatingToolWindows;
  begin
    if Parent is TppTBFloatingWindowParent then begin
      AddToList(FloatingToolWindows, Self);
      Parent.SetBounds(FFloatingPosition.X, FFloatingPosition.Y,
        Parent.Width, Parent.Height);
    end
    else
      RemoveFromList(FloatingToolWindows, Self);
  end;
  function ParentToCurrentDock(const Ctl: TWinControl): TppTBDock;
  begin
    if Ctl is TppTBDock then
      Result := TppTBDock(Ctl)
    else
      Result := nil;
  end;
var
  OldCurrentDock, NewCurrentDock: TppTBDock;
  NewFloating: Boolean;
  OldParent: TWinControl;
  SaveHandle: HWND;
begin
  OldCurrentDock := ParentToCurrentDock(Parent);
  NewCurrentDock := ParentToCurrentDock(AParent);
  NewFloating := AParent is TppTBFloatingWindowParent;

  if AParent = Parent then begin
    { Even though AParent is the same as the current Parent, this code is
      necessary because when the VCL destroys the parent of the tool window,
      it calls TWinControl.Remove to set FParent instead of using SetParent.
      However TControl.Destroy does call SetParent(nil), so it is
      eventually notified of the change before it is destroyed. }
    FCurrentDock := NewCurrentDock;
    FFloating := NewFloating;
    FDocked := Assigned(FCurrentDock);
    UpdateFloatingToolWindows;
  end
  else begin
    if not(csDestroying in ComponentState) and Assigned(AParent) then begin
      if Assigned(FOnDockChanging) then
        FOnDockChanging(Self, NewFloating, NewCurrentDock);
      if Assigned(FOnRecreating) then
        FOnRecreating(Self);
    end;

    { Before changing between docked and floating state (and vice-versa)
      or between docks, increment FHidden and call UpdateVisibility to hide the
      toolbar. This prevents any flashing while it's being moved }
    Inc(FHidden);
    Inc(FDisableOnMove);
    try
      UpdateVisibility;
      if Assigned(OldCurrentDock) then
        OldCurrentDock.BeginUpdate;
      if Assigned(NewCurrentDock) then
        NewCurrentDock.BeginUpdate;
      Inc(FUpdatingBounds);
      try
        if Assigned(AParent) then
          DoDockChangingHidden(NewFloating, NewCurrentDock);
        BeginUpdate;
        try
          { FCurrentSize probably won't be valid after changing Parents, so
            reset it to zero }
          FCurrentSize := 0;

          if Parent is TppTBDock then begin
            if not FUseLastDock or (FLastDock <> Parent) then
              TppTBDock(Parent).ChangeDockList(False, Self);
            TppTBDock(Parent).ToolbarVisibilityChanged(Self, True);
          end;

          OldParent := Parent;

          SaveHandle := 0;
          if Assigned(AParent) then begin
            //AParent.HandleNeeded;
            SaveHandle := WindowHandle;
            WindowHandle := 0;
          end;
          { Ensure that the handle is destroyed now so that any messages in the queue
            get flushed. This is neccessary since existing messages may reference
            FDockedTo or FDocked, which is changed below. }
          inherited SetParent(nil);
          { ^ Note to self: SetParent is used instead of DestroyHandle because it does
            additional processing }
          FCurrentDock := NewCurrentDock;
          FFloating := NewFloating;
          FDocked := Assigned(FCurrentDock);
          try
            if SaveHandle <> 0 then begin
              WindowHandle := SaveHandle;
              Windows.SetParent(SaveHandle, AParent.Handle);
              SetWindowPos(SaveHandle, 0, 0, 0, 0, 0, SWP_FRAMECHANGED or
                SWP_NOACTIVATE or SWP_NOMOVE or SWP_NOSIZE or SWP_NOZORDER);
            end;
            inherited;
          except
            { Failure is rare, but just in case, restore FDockedTo and FDocked back. }
            FCurrentDock := ParentToCurrentDock(Parent);
            FFloating := Parent is TppTBFloatingWindowParent;
            FDocked := Assigned(FCurrentDock);
            raise;
          end;

          { FEffectiveDockRow probably won't be valid on the new Parent, so
            reset it to -1 so that GetMinRowSize will temporarily ignore this
            toolbar }
          FEffectiveDockRow := -1;

          if not FSmoothDragging and (OldParent is TppTBFloatingWindowParent) then begin
            if FFloatParent = OldParent then FFloatParent := nil;
            OldParent.Free;
          end;

          if Parent is TppTBDock then begin
            if FUseLastDock and not FSmoothDragging then begin
              LastDock := TppTBDock(Parent);  { calls ChangeDockList if LastDock changes }
              TppTBDock(Parent).ToolbarVisibilityChanged(Self, False);
            end
            else
              TppTBDock(Parent).ChangeDockList(True, Self);
          end;

          UpdateFloatingToolWindows;

          { Schedule an arrange }
          Arrange;
        finally
          EndUpdate;
        end;
      finally
        Dec(FUpdatingBounds);
        if Assigned(NewCurrentDock) then
          NewCurrentDock.EndUpdate;
        if Assigned(OldCurrentDock) then
          OldCurrentDock.EndUpdate;
      end;
    finally
      Dec(FDisableOnMove);
      Dec(FHidden);
      UpdateVisibility;
      { ^ The above UpdateVisibility call not only updates the tool window's
        visibility after decrementing FHidden, it also sets the
        active/inactive state of the caption. }
    end;
    if Assigned(Parent) then
      Moved;

    if not(csDestroying in ComponentState) and Assigned(AParent) then begin
      if Assigned(FOnRecreated) then
        FOnRecreated(Self);
      if Assigned(FOnDockChanged) then
        FOnDockChanged(Self);
    end;
  end;
end;

procedure TppTBCustomDockableWindow.AddDockedNCAreaToSize(var S: TPoint;
  const LeftRight: Boolean);
var
  TopLeft, BottomRight: TPoint;
begin
  GetDockedNCArea(TopLeft, BottomRight, LeftRight);
  Inc(S.X, TopLeft.X + BottomRight.X);
  Inc(S.Y, TopLeft.Y + BottomRight.Y);
end;

procedure TppTBCustomDockableWindow.AddFloatingNCAreaToSize(var S: TPoint);
var
  TopLeft, BottomRight: TPoint;
begin
  GetFloatingNCArea(TopLeft, BottomRight);
  Inc(S.X, TopLeft.X + BottomRight.X);
  Inc(S.Y, TopLeft.Y + BottomRight.Y);
end;

procedure TppTBCustomDockableWindow.GetDockedNCArea(var TopLeft, BottomRight: TPoint;
  const LeftRight: Boolean);
var
  Z: Integer;
begin
  Z := DockedBorderSize;  { code optimization... }
  TopLeft.X := Z;
  TopLeft.Y := Z;
  BottomRight.X := Z;
  BottomRight.Y := Z;
  if not LeftRight then begin
    Inc(TopLeft.X, DragHandleSizes[CloseButtonWhenDocked, DragHandleStyle]);
    //if FShowChevron then
    //  Inc(BottomRight.X, tbChevronSize);
  end
  else begin
    Inc(TopLeft.Y, DragHandleSizes[CloseButtonWhenDocked, DragHandleStyle]);
    //if FShowChevron then
    //  Inc(BottomRight.Y, tbChevronSize);
  end;
end;

function TppTBCustomDockableWindow.GetFloatingBorderSize: TPoint;
{ Returns size of a thick border. Note that, depending on the Windows version,
  this may not be the same as the actual window metrics since it draws its
  own border }
const
  XMetrics: array[Boolean] of Integer = (SM_CXDLGFRAME, SM_CXFRAME);
  YMetrics: array[Boolean] of Integer = (SM_CYDLGFRAME, SM_CYFRAME);
begin
  Result.X := GetSystemMetrics(XMetrics[Resizable]);
  Result.Y := GetSystemMetrics(YMetrics[Resizable]);
end;

procedure TppTBCustomDockableWindow.GetFloatingNCArea(var TopLeft, BottomRight: TPoint);
begin
  with GetFloatingBorderSize do begin
    TopLeft.X := X;
    TopLeft.Y := Y;
    if ShowCaption then
      Inc(TopLeft.Y, GetSmallCaptionHeight);
    BottomRight.X := X;
    BottomRight.Y := Y;
  end;
end;

function TppTBCustomDockableWindow.GetDockedCloseButtonRect(LeftRight: Boolean): TRect;
var
  X, Y, Z: Integer;
begin
  Z := DragHandleSizes[CloseButtonWhenDocked, FDragHandleStyle] - 3;
  if not LeftRight then begin
    X := DockedBorderSize+1;
    Y := DockedBorderSize;
  end
  else begin
    X := (ClientWidth + DockedBorderSize) - Z;
    Y := DockedBorderSize+1;
  end;
  Result := Bounds(X, Y, Z, Z);
end;

function TppTBCustomDockableWindow.CalcNCSizes: TPoint;
var
  Z: Integer;
begin
  if not Docked then begin
    Result.X := 0;
    Result.Y := 0;
  end
  else begin
    Result.X := DockedBorderSize2;
    Result.Y := DockedBorderSize2;
    if CurrentDock.FAllowDrag then begin
      Z := DragHandleSizes[FCloseButtonWhenDocked, FDragHandleStyle];
      if not(CurrentDock.Position in PositionLeftOrRight) then
        Inc(Result.X, Z)
      else
        Inc(Result.Y, Z);
    end;
  end;
end;

procedure TppTBCustomDockableWindow.WMNCCalcSize(var Message: TWMNCCalcSize);
var
  Z: Integer;
begin
  { Doesn't call inherited since it overrides the normal NC sizes }
  Message.Result := 0;
  if Docked then
    with Message.CalcSize_Params^ do begin
      InflateRect(rgrc[0], -DockedBorderSize, -DockedBorderSize);
      if CurrentDock.FAllowDrag then begin
        Z := DragHandleSizes[FCloseButtonWhenDocked, FDragHandleStyle];
        if not(CurrentDock.Position in PositionLeftOrRight) then
          Inc(rgrc[0].Left, Z)
        else
          Inc(rgrc[0].Top, Z);
      end;
    end;
end;

procedure TppTBCustomDockableWindow.WMSetCursor(var Message: TWMSetCursor);
var
  P: TPoint;
  R: TRect;
  I: Integer;
begin
  if Docked and CurrentDock.FAllowDrag and
     (Message.CursorWnd = WindowHandle) and
     (Smallint(Message.HitTest) = HT_TB2k_Border) and
     (DragHandleStyle <> dhNone) then begin
    GetCursorPos(P);
    GetWindowRect(Handle, R);
    if not(CurrentDock.Position in PositionLeftOrRight) then
      I := P.X - R.Left
    else
      I := P.Y - R.Top;
    if I < DockedBorderSize + DragHandleSizes[CloseButtonWhenDocked, DragHandleStyle] then begin
      SetCursor(LoadCursor(0, IDC_SIZEALL));
      Message.Result := 1;
      Exit;
    end;
  end;
  inherited;
end;

procedure TppTBCustomDockableWindow.DrawNCArea(const DrawToDC: Boolean;
  const ADC: HDC; const Clip: HRGN);
{ Redraws all the non-client area of the toolbar when it is docked. }
var
  DC: HDC;
  R: TRect;
  VerticalDock: Boolean;
  X, Y, Y2, Y3, YO, S, SaveIndex: Integer;
  R2, R3, R4: TRect;
  P1, P2: TPoint;
  Brush: HBRUSH;
  Clr: TColorRef;
  UsingBackground, B: Boolean;

  procedure DrawRaisedEdge(R: TRect; const FillInterior: Boolean);
  const
    FillMiddle: array[Boolean] of UINT = (0, BF_MIDDLE);
  begin
    DrawEdge(DC, R, BDR_RAISEDINNER, BF_RECT or FillMiddle[FillInterior]);
  end;

  function CreateCloseButtonBitmap: HBITMAP;
  const
    Pattern: array[0..15] of Byte =
      (0, 0, $CC, 0, $78, 0, $30, 0, $78, 0, $CC, 0, 0, 0, 0, 0);
  begin
    Result := CreateBitmap(8, 8, 1, 1, @Pattern);
  end;

  procedure DrawButtonBitmap(const Bmp: HBITMAP);
  var
    TempBmp: TBitmap;
  begin
    TempBmp := TBitmap.Create;
    try
      TempBmp.Handle := Bmp;
      SetTextColor(DC, clBlack);
      SetBkColor(DC, clWhite);
      SelectObject(DC, GetSysColorBrush(COLOR_BTNTEXT));
      BitBlt(DC, R2.Left, R2.Top, R2.Right - R2.Left, R2.Bottom - R2.Top,
        TempBmp.Canvas.Handle, 0, 0, $00E20746 {ROP_DSPDxax});
    finally
      TempBmp.Free;
    end;
  end;

const
  CloseButtonState: array[Boolean] of UINT = (0, DFCS_PUSHED);
begin
  if not Docked or not HandleAllocated then Exit;

  if not DrawToDC then
    DC := GetWindowDC(Handle)
  else
    DC := ADC;
  try
    { Use update region }
    if not DrawToDC then
      SelectNCUpdateRgn(Handle, DC, Clip);

    { This works around WM_NCPAINT problem described at top of source code }
    {no!  R := Rect(0, 0, Width, Height);}
    GetWindowRect(Handle, R);  OffsetRect(R, -R.Left, -R.Top);

    VerticalDock := CurrentDock.Position in PositionLeftOrRight;

    Brush := CreateSolidBrush(ColorToRGB(Color));

    UsingBackground := CurrentDock.UsingBackground and CurrentDock.FBkgOnToolbars;

    { Border }
    if BorderStyle = bsSingle then
      DrawRaisedEdge(R, False)
    else
      FrameRect(DC, R, Brush);
    R2 := R;
    InflateRect(R2, -1, -1);
    if not UsingBackground then
      FrameRect(DC, R2, Brush);

    { Draw the Background }
    if UsingBackground then begin
      R2 := R;
      P1 := CurrentDock.ClientToScreen(Point(0, 0));
      P2 := CurrentDock.Parent.ClientToScreen(CurrentDock.BoundsRect.TopLeft);
      Dec(R2.Left, Left + CurrentDock.Left + (P1.X-P2.X));
      Dec(R2.Top, Top + CurrentDock.Top + (P1.Y-P2.Y));
      InflateRect(R, -1, -1);
      GetWindowRect(Handle, R4);
      R3 := ClientRect;
      with ClientToScreen(Point(0, 0)) do
        OffsetRect(R3, X-R4.Left, Y-R4.Top);
      SaveIndex := SaveDC(DC);
      IntersectClipRect(DC, R.Left, R.Top, R.Right, R.Bottom);
      ExcludeClipRect(DC, R3.Left, R3.Top, R3.Right, R3.Bottom);
      CurrentDock.DrawBackground(DC, R2);
      RestoreDC(DC, SaveIndex);
    end;

    { The drag handle at the left, or top }
    if CurrentDock.FAllowDrag then begin
      SaveIndex := SaveDC(DC);
      if not VerticalDock then
        Y2 := ClientHeight
      else
        Y2 := ClientWidth;
      Inc(Y2, DockedBorderSize);
      S := DragHandleSizes[FCloseButtonWhenDocked, FDragHandleStyle];
      if FDragHandleStyle <> dhNone then begin
        Y3 := Y2;
        X := DockedBorderSize + DragHandleXOffsets[FCloseButtonWhenDocked, FDragHandleStyle];
        Y := DockedBorderSize;
        YO := Ord(FDragHandleStyle = dhSingle);
        if FCloseButtonWhenDocked then begin
          if not VerticalDock then
            Inc(Y, S - 2)
          else
            Dec(Y3, S - 2);
        end;
        Clr := GetSysColor(COLOR_BTNHIGHLIGHT);
        for B := False to (FDragHandleStyle = dhDouble) do begin
          if not VerticalDock then
            R2 := Rect(X, Y+YO, X+3, Y2-YO)
          else
            R2 := Rect(Y+YO, X, Y3-YO, X+3);
          DrawRaisedEdge(R2, True);
          if not VerticalDock then
            SetPixelV(DC, X, Y2-1-YO, Clr)
          else
            SetPixelV(DC, Y3-1-YO, X, Clr);
          ExcludeClipRect(DC, R2.Left, R2.Top, R2.Right, R2.Bottom);
          Inc(X, 3);
        end;
      end;
      if not UsingBackground then begin
        if not VerticalDock then
          R2 := Rect(DockedBorderSize, DockedBorderSize,
            DockedBorderSize+S, Y2)
        else
          R2 := Rect(DockedBorderSize, DockedBorderSize,
            Y2, DockedBorderSize+S);
        FillRect(DC, R2, Brush);
      end;
      RestoreDC(DC, SaveIndex);
      { Close button }
      if FCloseButtonWhenDocked then begin
        R2 := GetDockedCloseButtonRect(VerticalDock);
        if FCloseButtonDown then
          DrawEdge(DC, R2, BDR_SUNKENOUTER, BF_RECT)
        else if FCloseButtonHover then
          DrawRaisedEdge(R2, False);
        InflateRect(R2, -2, -2);
        if FCloseButtonDown then
          OffsetRect(R2, 1, 1);
        DrawButtonBitmap(CreateCloseButtonBitmap);
      end;
    end;

    DeleteObject(Brush);
  finally
    if not DrawToDC then
      ReleaseDC(Handle, DC);
  end;
end;

procedure TppTBCustomDockableWindow.RedrawNCArea;
begin
  { Note: IsWindowVisible is called as an optimization. There's no need to
    draw on invisible windows. }
  if HandleAllocated and IsWindowVisible(Handle) then
    DrawNCArea(False, 0, 0);
end;

procedure TppTBCustomDockableWindow.WMNCPaint(var Message: TMessage);
begin
  { Don't call inherited because it overrides the default NC painting }
  DrawNCArea(False, 0, HRGN(Message.WParam));
end;

procedure DockableWindowNCPaintProc(Wnd: HWND; DC: HDC; AppData: Longint);
begin
  with TppTBCustomDockableWindow(AppData) do
    DrawNCArea(True, DC, 0)
end;

procedure TppTBCustomDockableWindow.WMPrint(var Message: TMessage);
begin
  HandleWMPrint(Handle, Message, DockableWindowNCPaintProc, Longint(Self));
end;

procedure TppTBCustomDockableWindow.WMPrintClient(var Message: TMessage);
begin
  HandleWMPrintClient(Self, Message);
end;

procedure TppTBCustomDockableWindow.WMEraseBkgnd(var Message: TWMEraseBkgnd);
var
  R, R2, R3: TRect;
  P1, P2: TPoint;
  SaveIndex: Integer;
begin
  if Docked and CurrentDock.UsingBackground and CurrentDock.FBkgOnToolbars then begin
    R := ClientRect;
    R2 := R;
    P1 := CurrentDock.ClientToScreen(Point(0, 0));
    P2 := CurrentDock.Parent.ClientToScreen(CurrentDock.BoundsRect.TopLeft);
    Dec(R2.Left, Left + CurrentDock.Left + (P1.X-P2.X));
    Dec(R2.Top, Top + CurrentDock.Top + (P1.Y-P2.Y));
    GetWindowRect(Handle, R3);
    with ClientToScreen(Point(0, 0)) do begin
      Inc(R2.Left, R3.Left-X);
      Inc(R2.Top, R3.Top-Y);
    end;
    SaveIndex := SaveDC(Message.DC);
    IntersectClipRect(Message.DC, R.Left, R.Top, R.Right, R.Bottom);
    CurrentDock.DrawBackground(Message.DC, R2);
    RestoreDC(Message.DC, SaveIndex);
    Message.Result := 1;
  end
  else
    inherited;
end;

function TppTBCustomDockableWindow.GetPalette: HPALETTE;
begin
  if Docked then
    Result := CurrentDock.GetPalette
  else
    Result := 0;
end;

function TppTBCustomDockableWindow.PaletteChanged(Foreground: Boolean): Boolean;
begin
  Result := inherited PaletteChanged(Foreground);
  if Result and not Foreground then begin
    { There seems to be a bug in Delphi's palette handling. When the form is
      inactive and another window realizes a palette, docked TToolbar97s
      weren't getting redrawn. So this workaround code was added. }
    InvalidateAll(Self);
  end;
end;

procedure TppTBCustomDockableWindow.DrawDraggingOutline(const DC: HDC;
  const NewRect, OldRect: PRect; const NewDocking, OldDocking: Boolean);
var
  NewSize, OldSize: TSize;
begin
  with GetFloatingBorderSize do begin
    if NewDocking then NewSize.cx := 1 else NewSize.cx := X;
    NewSize.cy := NewSize.cx;
    if OldDocking then OldSize.cx := 1 else OldSize.cx := X;
    OldSize.cy := OldSize.cx;
  end;
  DrawHalftoneInvertRect(DC, NewRect, OldRect, NewSize, OldSize);
end;

procedure TppTBCustomDockableWindow.CMColorChanged(var Message: TMessage);
begin
  { Make sure non-client area is redrawn }
  InvalidateAll(Self);
  inherited;  { the inherited handler calls Invalidate }
end;

procedure TppTBCustomDockableWindow.CMTextChanged(var Message: TMessage);
begin
  inherited;
  if Parent is TppTBFloatingWindowParent then
    TppTBFloatingWindowParent(Parent).Caption := Caption;
end;

procedure TppTBCustomDockableWindow.CMVisibleChanged(var Message: TMessage);
begin
  if not(csDesigning in ComponentState) and Docked then
    CurrentDock.ToolbarVisibilityChanged(Self, False);
  inherited;
  if Assigned(FOnVisibleChanged) then
    FOnVisibleChanged(Self);
end;

procedure TppTBCustomDockableWindow.BeginMoving(const InitX, InitY: Integer);
type
  PDockedSize = ^TDockedSize;
  TDockedSize = record
    Dock: TppTBDock;
    BoundsRect: TRect;
    Size: TPoint;
    RowSizes: TList;
  end;
const
  SplitCursors: array[Boolean] of PChar = (IDC_SIZEWE, IDC_SIZENS);
var
  UseSmoothDrag: Boolean;
  DockList: TList;
  NewDockedSizes: TList; {items are pointers to TDockedSizes}
  OriginalDock, MouseOverDock: TppTBDock;
  MoveRect: TRect;
  StartDocking, PreventDocking, PreventFloating, WatchForSplit, SplitVertical: Boolean;
  ScreenDC: HDC;
  OldCursor: HCURSOR;
  NPoint, DPoint: TPoint;
  OriginalDockRow, OriginalDockPos: Integer;
  FirstPos, LastPos, CurPos: TPoint;

  function FindDockedSize(const ADock: TppTBDock): PDockedSize;
  var
    I: Integer;
  begin
    for I := 0 to NewDockedSizes.Count-1 do begin
      Result := NewDockedSizes[I];
      if Result.Dock = ADock then
        Exit;
    end;
    Result := nil;
  end;

  function GetRowOf(const RowSizes: TList; const XY: Integer;
    var Before: Boolean): Integer;
  { Returns row number of the specified coordinate. Before is set to True if it
    was in the top (or left) quarter of the row. }
  var
    HighestRow, R, CurY, NextY, CurRowSize, EdgeSize: Integer;
    FullSizeRow: Boolean;
  begin
    Before := False;
    HighestRow := RowSizes.Count-1;
    CurY := 0;
    for R := 0 to HighestRow do begin
      CurRowSize := Integer(RowSizes[R]);
      FullSizeRow := FullSize or (CurRowSize and $10000 <> 0);
      CurRowSize := Smallint(CurRowSize);
      if CurRowSize = 0 then
        Continue;
      NextY := CurY + CurRowSize;
      if not FullSizeRow then
        EdgeSize := CurRowSize div 4
      else
        EdgeSize := CurRowSize div 2;
      if XY < CurY + EdgeSize then begin
        Result := R;
        Before := True;
        Exit;
      end;
      if not FullSizeRow and (XY < NextY - EdgeSize) then begin
        Result := R;
        Exit;
      end;
      CurY := NextY;
    end;
    Result := HighestRow+1;
  end;

  procedure Dropped;
  var
    NewDockRow: Integer;
    Before: Boolean;
    MoveRectClient: TRect;
    C: Integer;
    DockedSize: PDockedSize;
  begin
    if MouseOverDock <> nil then begin
      DockedSize := FindDockedSize(MouseOverDock);
      MoveRectClient := MoveRect;
      OffsetRect(MoveRectClient, -DockedSize.BoundsRect.Left,
        -DockedSize.BoundsRect.Top);
      if not MouseOverDock.FDragSplitting then begin
        if not(MouseOverDock.Position in PositionLeftOrRight) then
          C := (MoveRectClient.Top+MoveRectClient.Bottom) div 2
        else
          C := (MoveRectClient.Left+MoveRectClient.Right) div 2;
        NewDockRow := GetRowOf(DockedSize.RowSizes, C, Before);
        if Before then
          WatchForSplit := False;
      end
      else begin
        NewDockRow := FDockRow;
        Before := False;
      end;
      if WatchForSplit then begin
        if (MouseOverDock <> OriginalDock) or (NewDockRow <> OriginalDockRow) then
          WatchForSplit := False
        else begin
          if not SplitVertical then
            C := FirstPos.X - LastPos.X
          else
            C := FirstPos.Y - LastPos.Y;
          if Abs(C) >= 10 then begin
            WatchForSplit := False;
            MouseOverDock.FDragSplitting := True;
            SetCursor(LoadCursor(0, SplitCursors[SplitVertical]));
          end;
        end;
      end;
      FDockRow := NewDockRow;
      if not(MouseOverDock.Position in PositionLeftOrRight) then
        FDockPos := MoveRectClient.Left
      else
        FDockPos := MoveRectClient.Top;
      Parent := MouseOverDock;
      if not FSmoothDragging then
        CurrentDock.CommitNewPositions := True;
      FInsertRowBefore := Before;
      try
        CurrentDock.ArrangeToolbars;
      finally
        FInsertRowBefore := False;
      end;
    end
    else begin
      WatchForSplit := False;
      FloatingPosition := MoveRect.TopLeft;
      Floating := True;
      { Make sure it doesn't go completely off the screen }
      MoveOnScreen(True);
    end;

    { Make sure it's repainted immediately (looks better on really slow
      computers when smooth dragging is enabled) }
    Update;
  end;

  procedure MouseMoved;
  var
    OldMouseOverDock: TppTBDock;
    OldMoveRect: TRect;
    Pos: TPoint;

    function GetDockRect(Control: TppTBDock): TRect;
    var
      I: Integer;
    begin
      for I := 0 to NewDockedSizes.Count-1 do
        with PDockedSize(NewDockedSizes[I])^ do begin
          if Dock <> Control then Continue;
          Result := Bounds(Pos.X-MulDiv(Size.X-1, NPoint.X, DPoint.X),
            Pos.Y-MulDiv(Size.Y-1, NPoint.Y, DPoint.Y),
            Size.X, Size.Y);
          Exit;
        end;
      SetRectEmpty(Result);
    end;

    function CheckIfCanDockTo(Control: TppTBDock; R: TRect): Boolean;
    const
      DockSensX = 25;
      DockSensY = 25;
    var
      S, Temp: TRect;
      Sens: Integer;
    begin
      with Control do begin
        Result := False;

        InflateRect(R, 3, 3);
        S := GetDockRect(Control);

        { Like Office, distribute ~25 pixels of extra dock detection area
          to the left side if the toolbar was grabbed at the left, both sides
          if the toolbar was grabbed at the middle, or the right side if
          toolbar was grabbed at the right. If outside, don't try to dock. }
        Sens := MulDiv(DockSensX, NPoint.X, DPoint.X);
        if (Pos.X < R.Left-(DockSensX-Sens)) or (Pos.X >= R.Right+Sens) then
          Exit;

        { Don't try to dock to the left or right if pointer is above or below
          the boundaries of the dock }
        if (Control.Position in PositionLeftOrRight) and
           ((Pos.Y < R.Top) or (Pos.Y >= R.Bottom)) then
          Exit;

        { And also distribute ~25 pixels of extra dock detection area to
          the top or bottom side }
        Sens := MulDiv(DockSensY, NPoint.Y, DPoint.Y);
        if (Pos.Y < R.Top-(DockSensY-Sens)) or (Pos.Y >= R.Bottom+Sens) then
          Exit;

        Result := IntersectRect(Temp, R, S);
      end;
    end;

  var
    R, R2: TRect;
    I: Integer;
    Dock: TppTBDock;
    Accept: Boolean;
    TL, BR: TPoint;
  begin
    OldMouseOverDock := MouseOverDock;
    OldMoveRect := MoveRect;

    GetCursorPos(Pos);

    if Assigned(CurrentDock) and CurrentDock.FDragSplitting then
      MouseOverDock := CurrentDock
    else begin
      { Check if it can dock }
      MouseOverDock := nil;
      if StartDocking and not PreventDocking then
        for I := 0 to DockList.Count-1 do begin
          Dock := DockList[I];
          if CheckIfCanDockTo(Dock, FindDockedSize(Dock).BoundsRect) then begin
            MouseOverDock := Dock;
            Accept := True;
            if Assigned(MouseOverDock.FOnRequestDock) then
              MouseOverDock.FOnRequestDock(MouseOverDock, Self, Accept);
            if Accept then
              Break
            else
              MouseOverDock := nil;
          end;
        end;
    end;

    { If not docking, clip the point so it doesn't get dragged under the
      taskbar }
    if MouseOverDock = nil then begin
      R := GetRectOfMonitorContainingPoint(Pos, True);
      if Pos.X < R.Left then Pos.X := R.Left;
      if Pos.X > R.Right then Pos.X := R.Right;
      if Pos.Y < R.Top then Pos.Y := R.Top;
      if Pos.Y > R.Bottom then Pos.Y := R.Bottom;
    end;

    MoveRect := GetDockRect(MouseOverDock);

    { Make sure title bar (or at least part of the toolbar) is still accessible
      if it's dragged almost completely off the screen. This prevents the
      problem seen in Office 97 where you drag it offscreen so that only the
      border is visible, sometimes leaving you no way to move it back short of
      resetting the toolbar. }
    if MouseOverDock = nil then begin
      R2 := GetRectOfMonitorContainingPoint(Pos, True);
      R := R2;
      with GetFloatingBorderSize do
        InflateRect(R, -(X+4), -(Y+4));
      if MoveRect.Bottom < R.Top then
        OffsetRect(MoveRect, 0, R.Top-MoveRect.Bottom);
      if MoveRect.Top > R.Bottom then
        OffsetRect(MoveRect, 0, R.Bottom-MoveRect.Top);
      if MoveRect.Right < R.Left then
        OffsetRect(MoveRect, R.Left-MoveRect.Right, 0);
      if MoveRect.Left > R.Right then
        OffsetRect(MoveRect, R.Right-MoveRect.Left, 0);

      GetFloatingNCArea(TL, BR);
      I := R2.Top + 4 - TL.Y;
      if MoveRect.Top < I then
        OffsetRect(MoveRect, 0, I-MoveRect.Top);
    end;

    { Empty MoveRect if it's wanting to float but it's not allowed to, and
      set the mouse cursor accordingly. }
    if PreventFloating and not Assigned(MouseOverDock) then begin
      SetRectEmpty(MoveRect);
      SetCursor(LoadCursor(0, IDC_NO));
    end
    else begin
      if Assigned(CurrentDock) and CurrentDock.FDragSplitting then
        SetCursor(LoadCursor(0, SplitCursors[SplitVertical]))
      else
        SetCursor(OldCursor);
    end;

    { Update the dragging outline }
    if not UseSmoothDrag then
      DrawDraggingOutline(ScreenDC, @MoveRect, @OldMoveRect, MouseOverDock <> nil,
        OldMouseOverDock <> nil)
    else
      if not IsRectEmpty(MoveRect) then
        Dropped;
  end;

  procedure BuildDockList;

    procedure Recurse(const ParentCtl: TWinControl);
    var
      D: TppTBDockPosition;
      I: Integer;
    begin
      if ContainsControl(ParentCtl) or not ParentCtl.Showing then
        Exit;
      with ParentCtl do begin
        for D := Low(D) to High(D) do
          for I := 0 to ParentCtl.ControlCount-1 do
            if (Controls[I] is TppTBDock) and (TppTBDock(Controls[I]).Position = D) then
              Recurse(TWinControl(Controls[I]));
        for I := 0 to ParentCtl.ControlCount-1 do
          if (Controls[I] is TWinControl) and not(Controls[I] is TppTBDock) then
            Recurse(TWinControl(Controls[I]));
      end;
      if (ParentCtl is TppTBDock) and TppTBDock(ParentCtl).Accepts(Self) and CanDockTo(TppTBDock(ParentCtl)) and
         (DockList.IndexOf(ParentCtl) = -1) then
        DockList.Add(ParentCtl);
    end;

  var
    ParentForm: TppTBCustomForm;
    DockFormsList: TList;
    I, J: Integer;
  begin
    { Manually add CurrentDock to the DockList first so that it gets priority
      over other docks }
    if Assigned(CurrentDock) and CurrentDock.Accepts(Self) and CanDockTo(CurrentDock) then
      DockList.Add(CurrentDock);
    ParentForm := TBGetToolWindowParentForm(Self);
    DockFormsList := TList.Create;
    try
      if Assigned(FDockForms) then begin
        for I := 0 to Screen.{$IFDEF JR_D3}CustomFormCount{$ELSE}FormCount{$ENDIF}-1 do begin
          J := FDockForms.IndexOf(Screen.{$IFDEF JR_D3}CustomForms{$ELSE}Forms{$ENDIF}[I]);
          if (J <> -1) and (FDockForms[J] <> ParentForm) then
            DockFormsList.Add(FDockForms[J]);
        end;
      end;
      if Assigned(ParentForm) then
        DockFormsList.Insert(0, ParentForm);
      for I := 0 to DockFormsList.Count-1 do
        Recurse(DockFormsList[I]);
    finally
      DockFormsList.Free;
    end;
  end;

var
  Accept, FullSizeRow: Boolean;
  R: TRect;
  Msg: TMsg;
  NewDockedSize: PDockedSize;
  I, J, S: Integer;
begin
  Accept := False;
  SplitVertical := False;
  WatchForSplit := False;
  OriginalDock := CurrentDock;
  OriginalDockRow := FDockRow;
  OriginalDockPos := FDockPos;
  if Docked then begin
    CurrentDock.FDragToolbar := Self;
    CurrentDock.FDragSplitting := False;
    CurrentDock.FDragCanSplit := False;
    CurrentDock.CommitNewPositions := True;
    CurrentDock.ArrangeToolbars;  { needed for WatchForSplit assignment below }
    SplitVertical := CurrentDock.Position in PositionLeftOrRight;
    WatchForSplit := CurrentDock.FDragCanSplit;
  end;
  DockList := nil;
  NewDockedSizes := nil;
  try
    UseSmoothDrag := FSmoothDrag;
    FSmoothDragging := UseSmoothDrag;

    NPoint := Point(InitX, InitY);
    { Adjust for non-client area }
    if not(Parent is TppTBFloatingWindowParent) then begin
      GetWindowRect(Handle, R);
      R.BottomRight := ClientToScreen(Point(0, 0));
      DPoint := Point(Width-1, Height-1);
    end
    else begin
      GetWindowRect(Parent.Handle, R);
      R.BottomRight := Parent.ClientToScreen(Point(0, 0));
      DPoint := Point(Parent.Width-1, Parent.Height-1);
    end;
    Dec(NPoint.X, R.Left-R.Right);
    Dec(NPoint.Y, R.Top-R.Bottom);

    PreventDocking := GetKeyState(VK_CONTROL) < 0;
    PreventFloating := DockMode <> dmCanFloat;

    { Build list of all TppTBDock's on the form }
    DockList := TList.Create;
    if DockMode <> dmCannotFloatOrChangeDocks then
      BuildDockList
    else
      if Docked then
        DockList.Add(CurrentDock);

    { Ensure positions of each possible dock are committed }
    for I := 0 to DockList.Count-1 do
      TppTBDock(DockList[I]).CommitPositions;

    { Set up potential sizes for each dock type }
    NewDockedSizes := TList.Create;
    for I := -1 to DockList.Count-1 do begin
      New(NewDockedSize);
      NewDockedSize.RowSizes := nil;
      try
        with NewDockedSize^ do begin
          if I = -1 then begin
            { -1 adds the floating size }
            Dock := nil;
            SetRectEmpty(BoundsRect);
            Size := DoArrange(False, TBGetDockTypeOf(CurrentDock, Floating), True, nil);
            AddFloatingNCAreaToSize(Size);
          end
          else begin
            Dock := TppTBDock(DockList[I]);
            GetWindowRect(Dock.Handle, BoundsRect);
            if Dock <> CurrentDock then begin
              Size := DoArrange(False, TBGetDockTypeOf(CurrentDock, Floating), False, Dock);
              AddDockedNCAreaToSize(Size, Dock.Position in PositionLeftOrRight);
            end
            else
              Size := Point(Width, Height);
          end;
        end;
        if Assigned(NewDockedSize.Dock) then begin
          NewDockedSize.RowSizes := TList.Create;
          for J := 0 to NewDockedSize.Dock.GetHighestRow(True) do begin
            S := Smallint(NewDockedSize.Dock.GetCurrentRowSize(J, FullSizeRow));
            if FullSizeRow then
              S := S or $10000;
            NewDockedSize.RowSizes.Add(Pointer(S));
          end;
        end;
        NewDockedSizes.Add(NewDockedSize);
      except
        NewDockedSize.RowSizes.Free;
        Dispose(NewDockedSize);
        raise;
      end;
    end;

    { Before locking, make sure all pending paint messages are processed }
    ProcessPaintMessages;

    { Save the original mouse cursor }
    OldCursor := GetCursor;

    if not UseSmoothDrag then begin
      { This uses LockWindowUpdate to suppress all window updating so the
        dragging outlines doesn't sometimes get garbled. (This is safe, and in
        fact, is the main purpose of the LockWindowUpdate function)
        IMPORTANT! While debugging you might want to enable the 'TB2Dock_DisableLock'
        conditional define (see top of the source code). }
      {$IFNDEF TB2Dock_DisableLock}
      LockWindowUpdate(GetDesktopWindow);
      {$ENDIF}
      { Get a DC of the entire screen. Works around the window update lock
        by specifying DCX_LOCKWINDOWUPDATE. }
      ScreenDC := GetDCEx(GetDesktopWindow, 0,
        DCX_LOCKWINDOWUPDATE or DCX_CACHE or DCX_WINDOW);
    end
    else
      ScreenDC := 0;
    try
      SetCapture(Handle);

      { Initialize }
      StartDocking := Docked;
      MouseOverDock := nil;
      SetRectEmpty(MoveRect);
      GetCursorPos(FirstPos);
      LastPos := FirstPos;
      MouseMoved;
      StartDocking := True;

      { Stay in message loop until capture is lost. Capture is removed either
        by this procedure manually doing it, or by an outside influence (like
        a message box or menu popping up) }
      while GetCapture = Handle do begin
        case Integer(GetMessage(Msg, 0, 0, 0)) of
          -1: Break; { if GetMessage failed }
          0: begin
               { Repost WM_QUIT messages }
               PostQuitMessage(Msg.WParam);
               Break;
             end;
        end;

        case Msg.Message of
          WM_KEYDOWN, WM_KEYUP:
            { Ignore all keystrokes while dragging. But process Ctrl and Escape }
            case Msg.WParam of
              VK_CONTROL:
                if PreventDocking <> (Msg.Message = WM_KEYDOWN) then begin
                  PreventDocking := Msg.Message = WM_KEYDOWN;
                  MouseMoved;
                end;
              VK_ESCAPE:
                Break;
            end;
          WM_MOUSEMOVE: begin
              { Note to self: WM_MOUSEMOVE messages should never be dispatched
                here to ensure no hints get shown during the drag process }
              CurPos := SmallPointToPoint(TSmallPoint(DWORD(GetMessagePos)));
              if (LastPos.X <> CurPos.X) or (LastPos.Y <> CurPos.Y) then begin
                MouseMoved;
                LastPos := CurPos;
              end;
            end;
          WM_LBUTTONDOWN, WM_LBUTTONDBLCLK:
            { Make sure it doesn't begin another loop }
            Break;
          WM_LBUTTONUP: begin
              Accept := True;
              Break;
            end;
          WM_RBUTTONDOWN..WM_MBUTTONDBLCLK:
            { Ignore all other mouse up/down messages }
            ;
        else
          TranslateMessage(Msg);
          DispatchMessage(Msg);
        end;
      end;
    finally
      { Since it sometimes breaks out of the loop without capture being
        released }
      if GetCapture = Handle then
        ReleaseCapture;

      if not UseSmoothDrag then begin
        { Hide dragging outline. Since NT will release a window update lock if
          another thread comes to the foreground, it has to release the DC
          and get a new one for erasing the dragging outline. Otherwise,
          the DrawDraggingOutline appears to have no effect when this happens. }
        ReleaseDC(GetDesktopWindow, ScreenDC);
        ScreenDC := GetDCEx(GetDesktopWindow, 0,
          DCX_LOCKWINDOWUPDATE or DCX_CACHE or DCX_WINDOW);
        DrawDraggingOutline(ScreenDC, nil, @MoveRect, True, MouseOverDock <> nil);
        ReleaseDC(GetDesktopWindow, ScreenDC);

        { Release window update lock }
        {$IFNDEF TB2Dock_DisableLock}
        LockWindowUpdate(0);
        {$ENDIF}
      end;
    end;

    { Move to new position only if MoveRect isn't empty }
    FSmoothDragging := False;
    if Accept and not IsRectEmpty(MoveRect) then
      { Note: Dropped must be called again after FSmoothDragging is reset to
        False so that TppTBDock.ArrangeToolbars makes the DockPos changes
        permanent }
      Dropped;

    { LastDock isn't automatically updated while FSmoothDragging=True, so
      update it now that it's back to False }
    if FUseLastDock and Assigned(CurrentDock) then
      LastDock := CurrentDock;

    { Free FFloatParent if it's no longer the Parent }
    if Assigned(FFloatParent) and (Parent <> FFloatParent) then begin
      FFloatParent.Free;
      FFloatParent := nil;
    end;
  finally
    FSmoothDragging := False;
    if Docked and (CurrentDock.FDragToolbar = Self) then
      CurrentDock.FDragToolbar := nil;
    if not Docked then begin
      { If we didn't end up docking, restore the original DockRow & DockPos
        values }
      FDockRow := OriginalDockRow;
      FDockPos := OriginalDockPos;
    end;
    if Assigned(NewDockedSizes) then begin
      for I := NewDockedSizes.Count-1 downto 0 do begin
        NewDockedSize := NewDockedSizes[I];
        NewDockedSize.RowSizes.Free;
        Dispose(NewDockedSize);
      end;
      NewDockedSizes.Free;
    end;
    DockList.Free;
  end;
end;

function TppTBCustomDockableWindow.ChildControlTransparent(Ctl: TControl): Boolean;
begin
  Result := False;
end;

procedure TppTBCustomDockableWindow.ControlExistsAtPos(const P: TPoint;
  var ControlExists: Boolean);
var
  I: Integer;
begin
  for I := 0 to ControlCount-1 do
    if not ChildControlTransparent(Controls[I]) and Controls[I].Visible and
       PtInRect(Controls[I].BoundsRect, P) then begin
      ControlExists := True;
      Break;
    end;
end;

procedure TppTBCustomDockableWindow.DoubleClick;
begin
  if Docked then begin
    if DblClickUndock and (DockMode = dmCanFloat) then begin
      Floating := True;
      MoveOnScreen(True);
    end;
  end
  else if Floating then begin
    if Assigned(LastDock) then
      Parent := LastDock
    else
    if Assigned(DefaultDock) then begin
      FDockRow := ForceDockAtTopRow;
      FDockPos := ForceDockAtLeftPos;
      Parent := DefaultDock;
    end;
  end;
end;

function TppTBCustomDockableWindow.IsMovable: Boolean;
begin
  Result := (Docked and CurrentDock.FAllowDrag) or Floating;
end;

procedure TppTBCustomDockableWindow.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  P: TPoint;
  CtlExists: Boolean;
begin
  inherited;
  if (Button <> mbLeft) or not IsMovable then
    Exit;
  { Ignore message if user clicked on a child control }
  P := Point(X, Y);
  if PtInRect(ClientRect, P) then begin
    CtlExists := False;
    ControlExistsAtPos(P, CtlExists);
    if CtlExists then
      Exit;
  end;

  if not(ssDouble in Shift) then begin
    BeginMoving(X, Y);
    MouseUp(mbLeft, [], -1, -1);
  end
  else
    { Handle double click }
    DoubleClick;
end;

procedure TppTBCustomDockableWindow.WMNCHitTest(var Message: TWMNCHitTest);
var
  P: TPoint;
  R: TRect;
begin
  inherited;
  if Docked then
    with Message do begin
      P := SmallPointToPoint(Pos);
      GetWindowRect(Handle, R);
      Dec(P.X, R.Left);  Dec(P.Y, R.Top);
      if Result <> HTCLIENT then begin
        Result := HTNOWHERE;
        if FCloseButtonWhenDocked and CurrentDock.FAllowDrag and
           PtInRect(GetDockedCloseButtonRect(
             TBGetDockTypeOf(CurrentDock, Floating) = dtLeftRight), P) then
          Result := HT_TB2k_Close
        else
          Result := HT_TB2k_Border;
      end;
    end;
end;

procedure TppTBCustomDockableWindow.WMNCMouseMove(var Message: TWMNCMouseMove);
var
  InArea: Boolean;
begin
  inherited;
  { Note: TME_NONCLIENT was introduced in Windows 98 and 2000 }
  if (Win32MajorVersion >= 5) or
     (Win32MajorVersion = 4) and (Win32MinorVersion >= 10) then
    CallTrackMouseEvent(Handle, TME_LEAVE or $10 {TME_NONCLIENT});
  InArea := Message.HitTest = HT_TB2k_Close;
  if FCloseButtonHover <> InArea then begin
    FCloseButtonHover := InArea;
    RedrawNCArea;
  end;
end;

procedure TppTBCustomDockableWindow.WMNCMouseLeave(var Message: TMessage);
begin
  if not MouseCapture then
    CancelNCHover;
  inherited;
end;

procedure TppTBCustomDockableWindow.CMMouseLeave(var Message: TMessage);
begin
  inherited;
  { On Windows versions that can't send a WM_NCMOUSELEAVE message, trap
    CM_MOUSELEAVE to detect when the mouse moves from the non-client area to
    another control. }
  CancelNCHover;
end;

procedure TppTBCustomDockableWindow.WMMouseMove(var Message: TMessage);
begin
  { On Windows versions that can't send a WM_NCMOUSELEAVE message, trap
    WM_MOUSEMOVE to detect when the mouse moves from the non-client area to
    the client area.
    Note: We are overriding WM_MOUSEMOVE instead of MouseMove so that our
    processing always gets done first. }
  CancelNCHover;
  inherited;
end;

procedure TppTBCustomDockableWindow.CancelNCHover;
begin
  if FCloseButtonHover then begin
    FCloseButtonHover := False;
    RedrawNCArea;
  end;
end;

procedure TppTBCustomDockableWindow.Close;
var
  Accept: Boolean;
begin
  Accept := True;
  if Assigned(FOnCloseQuery) then
    FOnCloseQuery(Self, Accept);
  { Did the CloseQuery event return True? }
  if Accept then begin
    Hide;
    if Assigned(FOnClose) then
      FOnClose(Self);
  end;
end;

procedure TppTBCustomDockableWindow.SetCloseButtonState(Pushed: Boolean);
begin
  if FCloseButtonDown <> Pushed then begin
    FCloseButtonDown := Pushed;
    RedrawNCArea;
  end;
end;

procedure TppTBCustomDockableWindow.WMNCLButtonDown(var Message: TWMNCLButtonDown);
var
  R, BR: TRect;
  P: TPoint;
begin
  case Message.HitTest of
    HT_TB2k_Close: begin
        GetWindowRect(Handle, R);
        BR := GetDockedCloseButtonRect(
          TBGetDockTypeOf(CurrentDock, Floating) = dtLeftRight);
        OffsetRect(BR, R.Left, R.Top);
        if CloseButtonLoop(Handle, BR, SetCloseButtonState) then
          Close;
      end;
    HT_TB2k_Border: begin
        P := ScreenToClient(SmallPointToPoint(TSmallPoint(GetMessagePos())));
        if IsMovable then
          BeginMoving(P.X, P.Y);
      end;
  else
    inherited;
  end;
end;

procedure TppTBCustomDockableWindow.WMNCLButtonDblClk(var Message: TWMNCLButtonDblClk);
begin
  if Message.HitTest = HT_TB2k_Border then begin
    if IsMovable then
      DoubleClick;
  end
  else
    inherited;
end;

procedure TppTBCustomDockableWindow.ShowNCContextMenu(const Pos: TSmallPoint);

  {$IFNDEF JR_D5}
  { Note: this is identical to TControl.CheckMenuPopup (from Delphi 4),
    except where noted.
    TControl.CheckMenuPopup is unfortunately 'private', so it can't be called
    outside of the Controls unit. }
  procedure CheckMenuPopup;
  var
    Control: TControl;
    PopupMenu: TPopupMenu;
  begin
    if csDesigning in ComponentState then Exit;
    Control := Self;
    while Control <> nil do
    begin
      { Added TControlAccess cast because GetPopupMenu is 'protected' }
      PopupMenu := TControlAccess(Control).GetPopupMenu;
      if (PopupMenu <> nil) then
      begin
        if not PopupMenu.AutoPopup then Exit;
        SendCancelMode(nil);
        PopupMenu.PopupComponent := Control;
        { Changed the following. LPARAM of WM_NCRBUTTONUP is in screen
          coordinates, not client coordinates }
        {with ClientToScreen(SmallPointToPoint(Pos)) do
          PopupMenu.Popup(X, Y);}
        PopupMenu.Popup(Pos.X, Pos.Y);
        Exit;
      end;
      Control := Control.Parent;
    end;
  end;
  {$ENDIF}

begin
  {$IFDEF JR_D5}
  { Delphi 5 and later use the WM_CONTEXTMENU message for popup menus }
  SendMessage(Handle, WM_CONTEXTMENU, 0, LPARAM(Pos));
  {$ELSE}
  CheckMenuPopup;
  {$ENDIF}
end;

procedure TppTBCustomDockableWindow.WMNCRButtonUp(var Message: TWMNCRButtonUp);
begin
  ShowNCContextMenu(TSmallPoint(TMessage(Message).LParam));
end;

{$IFDEF JR_D5}
procedure TppTBCustomDockableWindow.WMContextMenu(var Message: TWMContextMenu);
{ Unfortunately TControl.WMContextMenu ignores clicks in the non-client area.
  On docked toolbars, we need right clicks on the border, part of the
  non-client area, to display the popup menu. The only way I see to have it do
  that is to create a new version of WMContextMenu specifically for the
  non-client area, and that is what this method is.
  Note: This is identical to Delphi 5's TControl.WMContextMenu, except where
  noted. }
var
  Pt, Temp: TPoint;
  Handled: Boolean;
  PopupMenu: TPopupMenu;
begin
  { Added 'inherited;' here }
  inherited;
  if Message.Result <> 0 then Exit;
  if csDesigning in ComponentState then Exit;

  Pt := SmallPointToPoint(Message.Pos);
  if Pt.X < 0 then
    Temp := Pt
  else
  begin
    Temp := ScreenToClient(Pt);
    { Changed the following. We're only interested in the non-client area }
    {if not PtInRect(ClientRect, Temp) then}
    if PtInRect(ClientRect, Temp) then
    begin
      {inherited;}
      Exit;
    end;
  end;

  Handled := False;
  DoContextPopup(Temp, Handled);
  Message.Result := Ord(Handled);
  if Handled then Exit;

  PopupMenu := GetPopupMenu;
  if (PopupMenu <> nil) and PopupMenu.AutoPopup then
  begin
    SendCancelMode(nil);
    PopupMenu.PopupComponent := Self;
    if Pt.X < 0 then
      Pt := ClientToScreen(Point(0,0));
    PopupMenu.Popup(Pt.X, Pt.Y);
    Message.Result := 1;
  end;

  if Message.Result = 0 then
    inherited;
end;
{$ENDIF}

procedure TppTBCustomDockableWindow.GetMinShrinkSize(var AMinimumSize: Integer);
begin
end;

function TppTBCustomDockableWindow.GetFloatingWindowParentClass: TppTBFloatingWindowParentClass;
begin
  Result := TppTBFloatingWindowParent;
end;

procedure TppTBCustomDockableWindow.GetMinMaxSize(var AMinClientWidth,
  AMinClientHeight, AMaxClientWidth, AMaxClientHeight: Integer);
begin
end;

function TppTBCustomDockableWindow.GetShrinkMode: TppTBShrinkMode;
begin
  Result := tbsmNone;
end;

procedure TppTBCustomDockableWindow.ResizeBegin;
begin
end;

procedure TppTBCustomDockableWindow.ResizeTrack(var Rect: TRect; const OrigRect: TRect);
begin
end;

procedure TppTBCustomDockableWindow.ResizeTrackAccept;
begin
end;

procedure TppTBCustomDockableWindow.ResizeEnd;
begin
end;

procedure TppTBCustomDockableWindow.BeginSizing(const ASizeHandle: TppTBSizeHandle);
var
  UseSmoothDrag, DragX, DragY, ReverseX, ReverseY: Boolean;
  MinWidth, MinHeight, MaxWidth, MaxHeight: Integer;
  DragRect, OrigDragRect: TRect;
  ScreenDC: HDC;
  OrigPos, OldPos: TPoint;

  procedure DoResize;
  begin
    BeginUpdate;
    try
      ResizeTrackAccept;
      Parent.BoundsRect := DragRect;
      SetBounds(Left, Top, Parent.ClientWidth, Parent.ClientHeight);
    finally
      EndUpdate;
    end;

    { Make sure it doesn't go completely off the screen }
    MoveOnScreen(True);
  end;

  procedure MouseMoved;
  var
    Pos: TPoint;
    OldDragRect: TRect;
  begin
    GetCursorPos(Pos);
    { It needs to check if the cursor actually moved since last time. This is
      because a call to LockWindowUpdate (apparently) generates a mouse move
      message even when mouse hasn't moved. }
    if (Pos.X = OldPos.X) and (Pos.Y = OldPos.Y) then Exit;
    OldPos := Pos;

    OldDragRect := DragRect;
    DragRect := OrigDragRect;
    if DragX then begin
      if not ReverseX then Inc(DragRect.Right, Pos.X-OrigPos.X)
      else Inc(DragRect.Left, Pos.X-OrigPos.X);
    end;
    if DragY then begin
      if not ReverseY then Inc(DragRect.Bottom, Pos.Y-OrigPos.Y)
      else Inc(DragRect.Top, Pos.Y-OrigPos.Y);
    end;
    if DragRect.Right-DragRect.Left < MinWidth then begin
      if not ReverseX then DragRect.Right := DragRect.Left + MinWidth
      else DragRect.Left := DragRect.Right - MinWidth;
    end;
    if (MaxWidth > 0) and (DragRect.Right-DragRect.Left > MaxWidth) then begin
      if not ReverseX then DragRect.Right := DragRect.Left + MaxWidth
      else DragRect.Left := DragRect.Right - MaxWidth;
    end;
    if DragRect.Bottom-DragRect.Top < MinHeight then begin
      if not ReverseY then DragRect.Bottom := DragRect.Top + MinHeight
      else DragRect.Top := DragRect.Bottom - MinHeight;
    end;
    if (MaxHeight > 0) and (DragRect.Bottom-DragRect.Top > MaxHeight) then begin
      if not ReverseY then DragRect.Bottom := DragRect.Top + MaxHeight
      else DragRect.Top := DragRect.Bottom - MaxHeight;
    end;

    ResizeTrack(DragRect, OrigDragRect);
    if not UseSmoothDrag then
      DrawDraggingOutline(ScreenDC, @DragRect, @OldDragRect, False, False)
    else
      DoResize;
  end;
var
  Accept: Boolean;
  Msg: TMsg;
  R: TRect;
begin
  if not Floating then Exit;

  Accept := False;

  UseSmoothDrag := FSmoothDrag;

  MinWidth := 0;
  MinHeight := 0;
  MaxWidth := 0;
  MaxHeight := 0;
  GetMinMaxSize(MinWidth, MinHeight, MaxWidth, MaxHeight);
  Inc(MinWidth, Parent.Width-Width);
  Inc(MinHeight, Parent.Height-Height);
  if MaxWidth > 0 then
    Inc(MaxWidth, Parent.Width-Width);
  if MaxHeight > 0 then
    Inc(MaxHeight, Parent.Height-Height);

  DragX := ASizeHandle in [twshLeft, twshRight, twshTopLeft, twshTopRight,
    twshBottomLeft, twshBottomRight];
  ReverseX := ASizeHandle in [twshLeft, twshTopLeft, twshBottomLeft];
  DragY := ASizeHandle in [twshTop, twshTopLeft, twshTopRight, twshBottom,
    twshBottomLeft, twshBottomRight];
  ReverseY := ASizeHandle in [twshTop, twshTopLeft, twshTopRight];

  ResizeBegin(ASizeHandle);
  try
    { Before locking, make sure all pending paint messages are processed }
    ProcessPaintMessages;

    if not UseSmoothDrag then begin
      { This uses LockWindowUpdate to suppress all window updating so the
        dragging outlines doesn't sometimes get garbled. (This is safe, and in
        fact, is the main purpose of the LockWindowUpdate function)
        IMPORTANT! While debugging you might want to enable the 'TB2Dock_DisableLock'
        conditional define (see top of the source code). }
      {$IFNDEF TB2Dock_DisableLock}
      LockWindowUpdate(GetDesktopWindow);
      {$ENDIF}
      { Get a DC of the entire screen. Works around the window update lock
        by specifying DCX_LOCKWINDOWUPDATE. }
      ScreenDC := GetDCEx(GetDesktopWindow, 0,
        DCX_LOCKWINDOWUPDATE or DCX_CACHE or DCX_WINDOW);
    end
    else
      ScreenDC := 0;
    try
      SetCapture(Handle);
      if (tbdsResizeClipCursor in FDockableWindowStyles) and
         not UsingMultipleMonitors then begin
        R := GetRectOfPrimaryMonitor(False);
        ClipCursor(@R);
      end;

      { Initialize }
      OrigDragRect := Parent.BoundsRect;
      DragRect := OrigDragRect;
      if not UseSmoothDrag then
        DrawDraggingOutline(ScreenDC, @DragRect, nil, False, False);
      GetCursorPos(OrigPos);
      OldPos := OrigPos;

      { Stay in message loop until capture is lost. Capture is removed either
        by this procedure manually doing it, or by an outside influence (like
        a message box or menu popping up) }
      while GetCapture = Handle do begin
        case Integer(GetMessage(Msg, 0, 0, 0)) of
          -1: Break; { if GetMessage failed }
          0: begin
               { Repost WM_QUIT messages }
               PostQuitMessage(Msg.WParam);
               Break;
             end;
        end;

        case Msg.Message of
          WM_KEYDOWN, WM_KEYUP:
            { Ignore all keystrokes while sizing except for Escape }
            if Msg.WParam = VK_ESCAPE then
              Break;
          WM_MOUSEMOVE:
            { Note to self: WM_MOUSEMOVE messages should never be dispatched
              here to ensure no hints get shown during the drag process }
            MouseMoved;
          WM_LBUTTONDOWN, WM_LBUTTONDBLCLK:
            { Make sure it doesn't begin another loop }
            Break;
          WM_LBUTTONUP: begin
              Accept := True;
              Break;
            end;
          WM_RBUTTONDOWN..WM_MBUTTONDBLCLK:
            { Ignore all other mouse up/down messages }
            ;
        else
          TranslateMessage(Msg);
          DispatchMessage(Msg);
        end;
      end;
    finally
      { Since it sometimes breaks out of the loop without capture being
        released }
      if GetCapture = Handle then
        ReleaseCapture;
      ClipCursor(nil);

      if not UseSmoothDrag then begin
        { Hide dragging outline. Since NT will release a window update lock if
          another thread comes to the foreground, it has to release the DC
          and get a new one for erasing the dragging outline. Otherwise,
          the DrawDraggingOutline appears to have no effect when this happens. }
        ReleaseDC(GetDesktopWindow, ScreenDC);
        ScreenDC := GetDCEx(GetDesktopWindow, 0,
          DCX_LOCKWINDOWUPDATE or DCX_CACHE or DCX_WINDOW);
        DrawDraggingOutline(ScreenDC, nil, @DragRect, False, False);
        ReleaseDC(GetDesktopWindow, ScreenDC);

        { Release window update lock }
        {$IFNDEF TB2Dock_DisableLock}
        LockWindowUpdate(0);
        {$ENDIF}
      end;
    end;

    if not UseSmoothDrag and Accept then
      DoResize;
  finally
    ResizeEnd;
  end;
end;

procedure TppTBCustomDockableWindow.DoDockChangingHidden(NewFloating: Boolean;
  DockingTo: TppTBDock);
begin
  if not(csDestroying in ComponentState) and Assigned(FOnDockChangingHidden) then
    FOnDockChangingHidden(Self, NewFloating, DockingTo);
end;

{ TppTBCustomDockableWindow - property access methods }

function TppTBCustomDockableWindow.GetNonClientWidth: Integer;
begin
  Result := CalcNCSizes.X;
end;

function TppTBCustomDockableWindow.GetNonClientHeight: Integer;
begin
  Result := CalcNCSizes.Y;
end;

function TppTBCustomDockableWindow.IsLastDockStored: Boolean;
begin
  Result := FCurrentDock = nil;   {}{should this be changed to 'Floating'?}
end;

function TppTBCustomDockableWindow.IsWidthAndHeightStored: Boolean;
begin
  Result := (CurrentDock = nil) and not Floating;
end;

procedure TppTBCustomDockableWindow.SetCloseButton(Value: Boolean);
begin
  if FCloseButton <> Value then begin
    FCloseButton := Value;

    { Update the close button's visibility }
    if Parent is TppTBFloatingWindowParent then
      TppTBFloatingWindowParent(Parent).RedrawNCArea([twrdCaption, twrdCloseButton]);
  end;
end;

procedure TppTBCustomDockableWindow.SetCloseButtonWhenDocked(Value: Boolean);
begin
  if FCloseButtonWhenDocked <> Value then begin
    FCloseButtonWhenDocked := Value;
    if Docked then
      RecalcNCArea(Self);
  end;
end;

procedure TppTBCustomDockableWindow.SetDefaultDock(Value: TppTBDock);
begin
  if FDefaultDock <> Value then begin
    FDefaultDock := Value;
    if Assigned(Value) then
      Value.FreeNotification(Self);
  end;
end;

procedure TppTBCustomDockableWindow.SetCurrentDock(Value: TppTBDock);
begin
  if not(csLoading in ComponentState) then begin
    if Assigned(Value) then
      Parent := Value
    else
      Parent := TBValidToolWindowParentForm(Self);
  end;
end;

procedure TppTBCustomDockableWindow.SetDockPos(Value: Integer);
begin
  FDockPos := Value;
  if Docked then
    CurrentDock.ArrangeToolbars;
end;

procedure TppTBCustomDockableWindow.SetDockRow(Value: Integer);
begin
  FDockRow := Value;
  if Docked then
    CurrentDock.ArrangeToolbars;
end;

procedure TppTBCustomDockableWindow.SetAutoResize(Value: Boolean);
begin
  if FAutoResize <> Value then begin
    FAutoResize := Value;
    if Value then
      Arrange;
  end;
end;

procedure TppTBCustomDockableWindow.SetBorderStyle(Value: TBorderStyle);
begin
  if FBorderStyle <> Value then begin
    FBorderStyle := Value;
    if Docked then
      RecalcNCArea(Self);
  end;
end;

procedure TppTBCustomDockableWindow.SetDragHandleStyle(Value: TppTBDragHandleStyle);
begin
  if FDragHandleStyle <> Value then begin
    FDragHandleStyle := Value;
    if Docked then
      RecalcNCArea(Self);
  end;
end;

procedure TppTBCustomDockableWindow.SetFloating(Value: Boolean);
var
  ParentFrm: TppTBCustomForm;
  NewFloatParent: TppTBFloatingWindowParent;
begin
  if FFloating <> Value then begin
    if Value and not(csDesigning in ComponentState) then begin
      ParentFrm := TBValidToolWindowParentForm(Self);
      if (FFloatParent = nil) or (FFloatParent.FParentForm <> ParentFrm) then begin
        NewFloatParent := GetFloatingWindowParentClass.Create(nil);
        try
          with NewFloatParent do begin
            TWinControl(FParentForm) := ParentFrm;
            FDockableWindow := Self;
            Name := Format('NBFloatingWindowParent_%.8x', [Longint(NewFloatParent)]);
            { ^ Must assign a unique name. In previous versions, reading in
              components at run-time that had no name caused them to get assigned
              names like "_1" because a component with no name -- the
              TppTBFloatingWindowParent form -- already existed. }
            Caption := Self.Caption;
            BorderStyle := bsToolWindow;
            SetBounds(0, 0, (Width-ClientWidth) + Self.ClientWidth,
              (Height-ClientHeight) + Self.ClientHeight);
            ShowHint := True;
            Visible := True;
          end;
        except
          NewFloatParent.Free;
          raise;
        end;
        FFloatParent := NewFloatParent;
      end;
      ParentFrm.FreeNotification(Self);
      Parent := FFloatParent;
      SetBounds(0, 0, Width, Height);
    end
    else
      Parent := TBValidToolWindowParentForm(Self);
  end;
end;

procedure TppTBCustomDockableWindow.SetFloatingMode(Value: TppTBFloatingMode);
begin
  if FFloatingMode <> Value then begin
    FFloatingMode := Value;
    if HandleAllocated then
      Perform(CM_SHOWINGCHANGED, 0, 0);
  end;
end;

procedure TppTBCustomDockableWindow.SetFloatingPosition(Value: TPoint);
begin
  FFloatingPosition := Value;
  if Floating and Assigned(Parent) then
    Parent.SetBounds(Value.X, Value.Y, Parent.Width, Parent.Height);
end;

procedure TppTBCustomDockableWindow.SetFullSize(Value: Boolean);
begin
  if FFullSize <> Value then begin
    FFullSize := Value;
    if Docked then
      CurrentDock.ArrangeToolbars;
  end;
end;

procedure TppTBCustomDockableWindow.SetLastDock(Value: TppTBDock);
begin
  if FUseLastDock and Assigned(FCurrentDock) then
    { When docked, LastDock must be equal to DockedTo }
    Value := FCurrentDock;
  if FLastDock <> Value then begin
    if Assigned(FLastDock) and (FLastDock <> Parent) then
      FLastDock.ChangeDockList(False, Self);
    FLastDock := Value;
    if Assigned(Value) then begin
      FUseLastDock := True;
      Value.FreeNotification(Self);
      Value.ChangeDockList(True, Self);
    end;
  end;
end;

procedure TppTBCustomDockableWindow.SetResizable(Value: Boolean);
begin
  if FResizable <> Value then begin
    FResizable := Value;
    if Floating and (Parent is TppTBFloatingWindowParent) then begin
      { Recreate the window handle because Resizable affects whether the
        tool window is created with a WS_THICKFRAME style }
      TppTBFloatingWindowParent(Parent).RecreateWnd;
    end;
  end;
end;

procedure TppTBCustomDockableWindow.SetShowCaption(Value: Boolean);
begin
  if FShowCaption <> Value then begin
    FShowCaption := Value;
    if Floating then begin
      { Recalculate FloatingWindowParent's NC area, and resize the toolbar
        accordingly }
      RecalcNCArea(Parent);
      Arrange;
    end;
  end;
end;

procedure TppTBCustomDockableWindow.SetStretch(Value: Boolean);
begin
  if FStretch <> Value then begin
    FStretch := Value;
    if Docked then
      CurrentDock.ArrangeToolbars;
  end;
end;

procedure TppTBCustomDockableWindow.SetUseLastDock(Value: Boolean);
begin
  if FUseLastDock <> Value then begin
    FUseLastDock := Value;
    if not Value then
      LastDock := nil
    else
      LastDock := FCurrentDock;
  end;
end;

(*function TppTBCustomDockableWindow.GetVersion: TToolbar97Version;
begin
  Result := Toolbar97VersionPropText;
end;

procedure TppTBCustomDockableWindow.SetVersion(const Value: TToolbar97Version);
begin
  { write method required for the property to show up in Object Inspector }
end;*)


{ TppTBBackground }

type
  PNotifyEvent = ^TNotifyEvent;

constructor TppTBBackground.Create(AOwner: TComponent);
begin
  inherited;
  FBkColor := clBtnFace;
  FBitmap := TBitmap.Create;
  FBitmap.OnChange := BitmapChanged;
end;

destructor TppTBBackground.Destroy;
var
  I: Integer;
begin
  inherited;
  FBitmapCache.Free;
  FBitmap.Free;
  if Assigned(FNotifyList) then begin
    for I := FNotifyList.Count-1 downto 0 do
      Dispose(PNotifyEvent(FNotifyList[I]));
    FNotifyList.Free;
  end;
end;

procedure TppTBBackground.BitmapChanged(Sender: TObject);
var
  I: Integer;
begin
  { Erase the cache and notify }
  FBitmapCache.Free;
  FBitmapCache := nil;
  if Assigned(FNotifyList) then
    for I := 0 to FNotifyList.Count-1 do
      PNotifyEvent(FNotifyList[I])^(Self);
end;

procedure TppTBBackground.Draw(DC: HDC; const DrawRect: TRect);
var
  UseBmp: TBitmap;
  R2: TRect;
  SaveIndex: Integer;
  DC2: HDC;
  Brush: HBRUSH;
  P: TPoint;
begin
  if FBitmapCache = nil then begin
    FBitmapCache := TBitmap.Create;
    FBitmapCache.Palette := CopyPalette(FBitmap.Palette);
    FBitmapCache.Width := FBitmap.Width;
    FBitmapCache.Height := FBitmap.Height;
    if not FTransparent then begin
      { Copy from a possible DIB to our DDB }
      BitBlt(FBitmapCache.Canvas.Handle, 0, 0, FBitmapCache.Width,
        FBitmapCache.Height, FBitmap.Canvas.Handle, 0, 0, SRCCOPY);
    end
    else begin
      with FBitmapCache do begin
        Canvas.Brush.Color := FBkColor;
        R2 := Rect(0, 0, Width, Height);
        Canvas.BrushCopy(R2, FBitmap, R2,
          FBitmap.Canvas.Pixels[0, Height-1] or $02000000);
      end;
    end;
    FBitmap.Dormant;
  end;
  UseBmp := FBitmapCache;

  DC2 := 0;
  SaveIndex := SaveDC(DC);
  try
    if UseBmp.Palette <> 0 then begin
      SelectPalette(DC, UseBmp.Palette, True);
      RealizePalette(DC);
    end;
    { Note: versions of Toolbar97 prior to 1.68 used 'UseBmp.Canvas.Handle'
      instead of DC2 in the BitBlt call. This was changed because there
      seems to be a bug in D2/BCB1's Graphics.pas: if you called
      <dockname>.Background.LoadFromFile(<filename>) twice the background
      would not be shown. }
    if (UseBmp.Width = 8) and (UseBmp.Height = 8) then begin
      { Use pattern brushes to draw 8x8 bitmaps.
        Note: Win9x can't use bitmaps <8x8 in size for pattern brushes }
      Brush := CreatePatternBrush(UseBmp.Handle);
      GetWindowOrgEx(DC, P);
      SetBrushOrgEx(DC, DrawRect.Left - P.X, DrawRect.Top - P.Y, nil);
      FillRect(DC, DrawRect, Brush);
      DeleteObject(Brush);
    end
    else begin
      { BitBlt is faster than pattern brushes on large bitmaps }
      DC2 := CreateCompatibleDC(DC);
      SelectObject(DC2, UseBmp.Handle);
      R2 := DrawRect;
      while R2.Left < R2.Right do begin
        while R2.Top < R2.Bottom do begin
          BitBlt(DC, R2.Left, R2.Top, UseBmp.Width, UseBmp.Height,
            DC2, 0, 0, SRCCOPY);
          Inc(R2.Top, UseBmp.Height);
        end;
        R2.Top := DrawRect.Top;
        Inc(R2.Left, UseBmp.Width);
      end;
    end;
  finally
    if DC2 <> 0 then
      DeleteDC(DC2);
    { Restore the palette and brush origin back }
    RestoreDC(DC, SaveIndex);
  end;
end;

function TppTBBackground.GetPalette: HPALETTE;
begin
  Result := FBitmap.Palette;
end;

procedure TppTBBackground.SysColorChanged;
begin
  if FTransparent and (FBkColor < 0) then
    BitmapChanged(nil);
end;

function TppTBBackground.UsingBackground: Boolean;
begin
  Result := (FBitmap.Width <> 0) and (FBitmap.Height <> 0);
end;

procedure TppTBBackground.RegisterChanges(Proc: TNotifyEvent);
var
  I: Integer;
  P: PNotifyEvent;
begin
  if FNotifyList = nil then
    FNotifyList := TList.Create;
  for I := 0 to FNotifyList.Count-1 do begin
    P := FNotifyList[I];
    if (TMethod(P^).Code = TMethod(Proc).Code) and
       (TMethod(P^).Data = TMethod(Proc).Data) then
      Exit;
  end;
  FNotifyList.Expand;
  New(P);
  P^ := Proc;
  FNotifyList.Add(P);
end;

procedure TppTBBackground.UnregisterChanges(Proc: TNotifyEvent);
var
  I: Integer;
  P: PNotifyEvent;
begin
  if FNotifyList = nil then
    Exit;
  for I := 0 to FNotifyList.Count-1 do begin
    P := FNotifyList[I];
    if (TMethod(P^).Code = TMethod(Proc).Code) and
       (TMethod(P^).Data = TMethod(Proc).Data) then begin
      FNotifyList.Delete(I);
      Dispose(P);
      Break;
    end;
  end;
end;

procedure TppTBBackground.SetBkColor(Value: TColor);
begin
  if FBkColor <> Value then begin
    FBkColor := Value;
    if FTransparent then
      BitmapChanged(nil);
  end;
end;

procedure TppTBBackground.SetBitmap(Value: TBitmap);
begin
  FBitmap.Assign(Value);
end;

procedure TppTBBackground.SetTransparent(Value: Boolean);
begin
  if FTransparent <> Value then begin
    FTransparent := Value;
    BitmapChanged(nil);
  end;
end;


{ Global procedures }

procedure TBCustomLoadPositions(const OwnerComponent: TComponent;
  const ReadIntProc: TppTBPositionReadIntProc;
  const ReadStringProc: TppTBPositionReadStringProc; const ExtraData: Pointer);
var
  Rev: Integer;

  function FindDock(AName: String): TppTBDock;
  var
    I: Integer;
  begin
    Result := nil;
    for I := 0 to OwnerComponent.ComponentCount-1 do
      if (OwnerComponent.Components[I] is TppTBDock) and
         (CompareText(OwnerComponent.Components[I].Name, AName) = 0) then begin
        Result := TppTBDock(OwnerComponent.Components[I]);
        Break;
      end;
  end;

  procedure ReadValues(const Toolbar: TppTBCustomDockableWindow; const NewDock: TppTBDock);
  var
    Pos: TPoint;
    Data: TppTBReadPositionData;
    LastDockName: String;
    ADock: TppTBDock;
  begin
    with Toolbar do begin
      DockRow := ReadIntProc(Name, rvDockRow, DockRow, ExtraData);
      DockPos := ReadIntProc(Name, rvDockPos, DockPos, ExtraData);
      Pos.X := ReadIntProc(Name, rvFloatLeft, 0, ExtraData);
      Pos.Y := ReadIntProc(Name, rvFloatTop, 0, ExtraData);
      @Data.ReadIntProc := @ReadIntProc;
      @Data.ReadStringProc := @ReadStringProc;
      Data.ExtraData := ExtraData;
      ReadPositionData(Data);
      FloatingPosition := Pos;
      if Assigned(NewDock) then
        Parent := NewDock
      else begin
        //Parent := Form;
        Floating := True;
        MoveOnScreen(True);
        if (Rev >= 3) and FUseLastDock then begin
          LastDockName := ReadStringProc(Name, rvLastDock, '', ExtraData);
          if LastDockName <> '' then begin
            ADock := FindDock(LastDockName);
            if Assigned(ADock) then
              LastDock := ADock;
          end;
        end;
      end;
      Arrange;
      DoneReadingPositionData(Data);
    end;
  end;

var
  DocksDisabled: TList;
  I: Integer;
  ToolWindow: TComponent;
  ADock: TppTBDock;
  DockedToName: String;
begin
  DocksDisabled := TList.Create;
  try
    with OwnerComponent do
      for I := 0 to ComponentCount-1 do
        if Components[I] is TppTBDock then begin
          TppTBDock(Components[I]).BeginUpdate;
          DocksDisabled.Add(Components[I]);
        end;

    for I := 0 to OwnerComponent.ComponentCount-1 do begin
      ToolWindow := OwnerComponent.Components[I];
      if ToolWindow is TppTBCustomDockableWindow then
        with TppTBCustomDockableWindow(ToolWindow) do begin
          {}{should skip over toolbars that are neither Docked nor Floating }
          if Name = '' then
            raise Exception.Create(ppSTBToolWinNameNotSet);
          Rev := ReadIntProc(Name, rvRev, 0, ExtraData);
          if Rev = 2000 then begin
            Visible := ReadIntProc(Name, rvVisible, Ord(Visible), ExtraData) <> 0;
            DockedToName := ReadStringProc(Name, rvDockedTo, '', ExtraData);
            if DockedToName <> '' then begin
              if DockedToName <> rdDockedToFloating then begin
                ADock := FindDock(DockedToName);
                if (ADock <> nil) and (ADock.FAllowDrag) then
                  ReadValues(TppTBCustomDockableWindow(ToolWindow), ADock);
              end
              else
                ReadValues(TppTBCustomDockableWindow(ToolWindow), nil);
            end;
          end;
        end;
    end;
  finally
    for I := DocksDisabled.Count-1 downto 0 do
      TppTBDock(DocksDisabled[I]).EndUpdate;
    DocksDisabled.Free;
  end;
end;

procedure TBCustomSavePositions(const OwnerComponent: TComponent;
  const WriteIntProc: TppTBPositionWriteIntProc;
  const WriteStringProc: TppTBPositionWriteStringProc; const ExtraData: Pointer);
var
  I: Integer;
  N, L: String;
  Data: TppTBWritePositionData;
begin
  for I := 0 to OwnerComponent.ComponentCount-1 do
    if OwnerComponent.Components[I] is TppTBCustomDockableWindow then
      with TppTBCustomDockableWindow(OwnerComponent.Components[I]) do begin
        if Name = '' then
          raise Exception.Create(ppSTBToolwinNameNotSet);
        if Floating then
          N := rdDockedToFloating
        else if Docked then begin
          if CurrentDock.FAllowDrag then begin
            N := CurrentDock.Name;
            if N = '' then
              raise Exception.Create(ppSTBToolwinDockedToNameNotSet);
          end
          else
            N := '';
        end
        else
          Continue;  { skip if it's neither floating nor docked }
        L := '';
        if Assigned(FLastDock) then
          L := FLastDock.Name;
        WriteIntProc(Name, rvRev, rdCurrentRev, ExtraData);
        WriteIntProc(Name, rvVisible, Ord(Visible), ExtraData);
        WriteStringProc(Name, rvDockedTo, N, ExtraData);
        WriteStringProc(Name, rvLastDock, L, ExtraData);
        WriteIntProc(Name, rvDockRow, FDockRow, ExtraData);
        WriteIntProc(Name, rvDockPos, FDockPos, ExtraData);
        WriteIntProc(Name, rvFloatLeft, FFloatingPosition.X, ExtraData);
        WriteIntProc(Name, rvFloatTop, FFloatingPosition.Y, ExtraData);
        @Data.WriteIntProc := @WriteIntProc;
        @Data.WriteStringProc := @WriteStringProc;
        Data.ExtraData := ExtraData;
        WritePositionData(Data);
      end;
end;

type
  PIniReadWriteData = ^TIniReadWriteData;
  TIniReadWriteData = record
    IniFile: TIniFile;
    SectionNamePrefix: String;
  end;

function IniReadInt(const ToolbarName, Value: String; const Default: Longint;
  const ExtraData: Pointer): Longint; far;
begin
  Result := PIniReadWriteData(ExtraData).IniFile.ReadInteger(
    PIniReadWriteData(ExtraData).SectionNamePrefix + ToolbarName, Value, Default);
end;
function IniReadString(const ToolbarName, Value, Default: String;
  const ExtraData: Pointer): String; far;
begin
  Result := PIniReadWriteData(ExtraData).IniFile.ReadString(
    PIniReadWriteData(ExtraData).SectionNamePrefix + ToolbarName, Value, Default);
end;
procedure IniWriteInt(const ToolbarName, Value: String; const Data: Longint;
  const ExtraData: Pointer); far;
begin
  PIniReadWriteData(ExtraData).IniFile.WriteInteger(
    PIniReadWriteData(ExtraData).SectionNamePrefix + ToolbarName, Value, Data);
end;
procedure IniWriteString(const ToolbarName, Value, Data: String;
  const ExtraData: Pointer); far;
begin
  PIniReadWriteData(ExtraData).IniFile.WriteString(
    PIniReadWriteData(ExtraData).SectionNamePrefix + ToolbarName, Value, Data);
end;

procedure TBIniLoadPositions(const OwnerComponent: TComponent;
  const Filename, SectionNamePrefix: String);
var
  Data: TIniReadWriteData;
begin
  Data.IniFile := TIniFile.Create(Filename);
  try
    Data.SectionNamePrefix := SectionNamePrefix;
    TBCustomLoadPositions(OwnerComponent, IniReadInt, IniReadString, @Data);
  finally
    Data.IniFile.Free;
  end;
end;

procedure TBIniSavePositions(const OwnerComponent: TComponent;
  const Filename, SectionNamePrefix: String);
var
  Data: TIniReadWriteData;
begin
  Data.IniFile := TIniFile.Create(Filename);
  try
    Data.SectionNamePrefix := SectionNamePrefix;
    TBCustomSavePositions(OwnerComponent, IniWriteInt, IniWriteString, @Data);
  finally
    Data.IniFile.Free;
  end;
end;

function RegReadInt(const ToolbarName, Value: String; const Default: Longint;
  const ExtraData: Pointer): Longint; far;
begin
  Result := TRegIniFile(ExtraData).ReadInteger(ToolbarName, Value, Default);
end;
function RegReadString(const ToolbarName, Value, Default: String;
  const ExtraData: Pointer): String; far;
begin
  Result := TRegIniFile(ExtraData).ReadString(ToolbarName, Value, Default);
end;
procedure RegWriteInt(const ToolbarName, Value: String; const Data: Longint;
  const ExtraData: Pointer); far;
begin
  TRegIniFile(ExtraData).WriteInteger(ToolbarName, Value, Data);
end;
procedure RegWriteString(const ToolbarName, Value, Data: String;
  const ExtraData: Pointer); far;
begin
  TRegIniFile(ExtraData).WriteString(ToolbarName, Value, Data);
end;

procedure TBRegLoadPositions(const OwnerComponent: TComponent;
  const RootKey: DWORD; const BaseRegistryKey: String);
var
  Reg: TRegIniFile;
begin
  Reg := TRegIniFile.Create('');
  try
    Reg.RootKey := RootKey;
    Reg.OpenKey(BaseRegistryKey, True);  { assigning to RootKey resets the current key }
    TBCustomLoadPositions(OwnerComponent, RegReadInt, RegReadString, Reg);
  finally
    Reg.Free;
  end;
end;

procedure TBRegSavePositions(const OwnerComponent: TComponent;
  const RootKey: DWORD; const BaseRegistryKey: String);
var
  Reg: TRegIniFile;
begin
  Reg := TRegIniFile.Create('');
  try
    Reg.RootKey := RootKey;
    Reg.OpenKey(BaseRegistryKey, True);  { assigning to RootKey resets the current key }
    TBCustomSavePositions(OwnerComponent, RegWriteInt, RegWriteString, Reg);
  finally
    Reg.Free;
  end;
end;

end.
