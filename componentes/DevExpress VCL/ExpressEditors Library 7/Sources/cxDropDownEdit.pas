
{********************************************************************}
{                                                                    }
{       Developer Express Visual Component Library                   }
{       ExpressEditors                                               }
{                                                                    }
{       Copyright (c) 1998-2010 Developer Express Inc.               }
{       ALL RIGHTS RESERVED                                          }
{                                                                    }
{   The entire contents of this file is protected by U.S. and        }
{   International Copyright Laws. Unauthorized reproduction,         }
{   reverse-engineering, and distribution of all or any portion of   }
{   the code contained in this file is strictly prohibited and may   }
{   result in severe civil and criminal penalties and will be        }
{   prosecuted to the maximum extent possible under the law.         }
{                                                                    }
{   RESTRICTIONS                                                     }
{                                                                    }
{   THIS SOURCE CODE AND ALL RESULTING INTERMEDIATE FILES            }
{   (DCU, OBJ, DLL, ETC.) ARE CONFIDENTIAL AND PROPRIETARY TRADE     }
{   SECRETS OF DEVELOPER EXPRESS INC. THE REGISTERED DEVELOPER IS    }
{   LICENSED TO DISTRIBUTE THE EXPRESSEDITORS AND ALL                }
{   ACCOMPANYING VCL CONTROLS AS PART OF AN EXECUTABLE PROGRAM ONLY. }
{                                                                    }
{   THE SOURCE CODE CONTAINED WITHIN THIS FILE AND ALL RELATED       }
{   FILES OR ANY PORTION OF ITS CONTENTS SHALL AT NO TIME BE         }
{   COPIED, TRANSFERRED, SOLD, DISTRIBUTED, OR OTHERWISE MADE        }
{   AVAILABLE TO OTHER INDIVIDUALS WITHOUT EXPRESS WRITTEN CONSENT   }
{   AND PERMISSION FROM DEVELOPER EXPRESS INC.                       }
{                                                                    }
{   CONSULT THE END USER LICENSE AGREEMENT FOR INFORMATION ON        }
{   ADDITIONAL RESTRICTIONS.                                         }
{                                                                    }
{********************************************************************}

unit cxDropDownEdit;

{$I cxVer.inc}

interface

uses
  Windows, Messages, Variants, Classes, Controls, Graphics, Forms, SysUtils, StdCtrls,
  dxCore, dxMessages, cxClasses, cxContainer, cxControls,
  cxEdit, cxGraphics, cxLookAndFeelPainters, cxLookAndFeels, cxMaskEdit,
  cxTextEdit, cxVariants, cxFilterControlUtils;

type
  TcxEditDropDownListStyle = (lsEditFixedList, lsEditList, lsFixedList);
  TcxEditMouseSizingDirection = (mmdWE, mmdNS, mmdNWSE, mmdNESW, mmdNone);

  TcxCustomComboBox = class;
  TcxCustomDropDownEdit = class;

  TcxCustomDrawBorderEvent = procedure(AViewInfo: TcxContainerViewInfo; ACanvas: TcxCanvas; const R: TRect; var AHandled: Boolean;
    out ABorderWidth: Integer) of object;
  TcxEditDrawItemEvent = procedure(AControl: TcxCustomComboBox; ACanvas: TcxCanvas;
    AIndex: Integer; const ARect: TRect; AState: TOwnerDrawState) of object;
  TMeasureItemEvent = procedure(AControl: TcxCustomComboBox; AIndex: Integer;
    ACanvas: TcxCanvas; var AHeight: Integer) of object;

  { TcxCustomEditPopupWindowViewInfo }

  TcxCustomEditPopupWindowViewInfo = class(TcxContainerViewInfo)
  private
    FOnCustomDrawBorder: TcxCustomDrawBorderEvent;
  protected
    function DrawCustomBorder(ACanvas: TcxCanvas; const R: TRect; out ABorderWidth: Integer): Boolean;
    function GetBorders: TRect;
    function GetBorderWidth: Integer;
    function GetClientEdges: TRect;
    function GetShadowOffsets: TRect;
    function GetSysPanelDefaultHeight: Integer;
    function GetSysPanelBorders: TRect;
    procedure InternalPaint(ACanvas: TcxCanvas); override;
  public
    BorderStyle: TcxEditPopupBorderStyle;
    ClientEdge: Boolean;
    MinSysPanelHeight: Integer;
    NativeStyle: Boolean;
    Shadow: Boolean;

    ShowCloseButton: Boolean;
    CloseButtonRect: TRect;
    CloseButtonState: TcxButtonState;

    Sizeable: Boolean;
    SizeGripCorner: TdxCorner;
    SizeGripRect: TRect;
    SizeGripSizingRect: TRect;

    SysPanelHeight: Integer;
    SysPanelBounds: TRect;
    SysPanelStyle: Boolean;
    procedure DrawBorder(ACanvas: TcxCanvas; var R: TRect); reintroduce; virtual;
    function GetBorderExtent: TRect; virtual;
    function GetClientExtent: TRect; virtual;
    function GetSysPanelHeight: Integer; virtual;
    property OnCustomDrawBorder: TcxCustomDrawBorderEvent read FOnCustomDrawBorder write FOnCustomDrawBorder;
  end;

  { TcxCustomEditPopupWindow }

  TcxCustomEditPopupWindow = class(TcxCustomPopupWindow)
  private
    FLockCheckSize: Boolean;
    FPopupAutoSize: Boolean;
    FBorderStyle: TcxEditPopupBorderStyle;
    FClientEdge: Boolean;
    FCloseButton: Boolean;
    FMinHeight: Integer;
    FMinWidth: Integer;
    FNativeStyle: Boolean;
    FPopupHeight: Integer;
    FPopupWidth: Integer;
    FShadow: Boolean;
    FShowContentWhileResize: Boolean;
    FSizeable: Boolean;
    FSizeFrame: TcxSizeFrame;
    FSysPanelStyle: Boolean;

    FCapturePoint: TPoint;
    FSizingCapture: Boolean;

    function GetEdit: TcxCustomDropDownEdit;
    function GetMinSysPanelHeight: Integer;
    function GetViewInfo: TcxCustomEditPopupWindowViewInfo;
    procedure SetPopupAutoSize(Value: Boolean);
    procedure SetBorderStyle(Value: TcxEditPopupBorderStyle);
    procedure SetClientEdge(Value: Boolean);
    procedure SetCloseButton(Value: Boolean);
    procedure SetMinSysPanelHeight(Value: Integer);
    procedure SetNativeStyle(Value: Boolean);
    procedure SetShadow(Value: Boolean);
    procedure SetSizeable(Value: Boolean);
    procedure SetSysPanelStyle(Value: Boolean);

    function GetHitTest(const P: TPoint): Integer;
    procedure SetCloseButtonState(AState: TcxButtonState);
    procedure UpdateSysPanelState; overload;
    procedure UpdateSysPanelState(const P: TPoint; AShift: TShiftState); overload;
    procedure StartResize(const P: TPoint);
    procedure DoResize(const P: TPoint);
    procedure EndResize(AApply: Boolean);

    procedure CMPopupControlKey(var Message: TMessage); message DXM_POPUPCONTROLKEY;
  protected
    function AcceptsAnySize: Boolean; override;
    procedure AdjustClientRect(var Rect: TRect); override;
    function CalculatePosition: TPoint; override;
    procedure CalculateSize; override;
    function CanResize(var NewWidth, NewHeight: Integer): Boolean; override;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure DoClosing; override;
    procedure ModalCloseUp; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseLeave(AControl: TControl); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure Resize; override;

    procedure CalculateViewInfo; virtual;
    procedure DoPopupControlKey(Key: Char); virtual;
    procedure DrawSizeFrame(const R: TRect);
    function GetMaxVisualAreaSize: TSize;
    function GetMinSize: TSize; virtual;
    procedure RefreshPopupWindow;
    procedure ResizePopupWindow(ALeft, ATop, AWidth, AHeight: Integer);
  public
    constructor Create(AOwnerControl: TWinControl); override;
    destructor Destroy; override;
    function GetViewInfoClass: TcxContainerViewInfoClass; override;
    procedure Popup(AFocusedControl: TWinControl); override;
    property BorderStyle: TcxEditPopupBorderStyle read FBorderStyle write SetBorderStyle;
    property ClientEdge: Boolean read FClientEdge write SetClientEdge;
    property CloseButton: Boolean read FCloseButton write SetCloseButton;
    property Edit: TcxCustomDropDownEdit read GetEdit;
    property MinHeight: Integer read FMinHeight write FMinHeight;
    property MinSize: TSize read GetMinSize;
    property MinSysPanelHeight: Integer read GetMinSysPanelHeight write SetMinSysPanelHeight;
    property MinWidth: Integer read FMinWidth write FMinWidth;
    property NativeStyle: Boolean read FNativeStyle write SetNativeStyle;
    property PopupAutoSize: Boolean read FPopupAutoSize write SetPopupAutoSize;
    property PopupHeight: Integer read FPopupHeight write FPopupHeight;
    property PopupWidth: Integer read FPopupWidth write FPopupWidth;
    property Shadow: Boolean read FShadow write SetShadow;
    property ShowContentWhileResize: Boolean read FShowContentWhileResize
      write FShowContentWhileResize default False;
    property Sizeable: Boolean read FSizeable write SetSizeable;
    property SysPanelStyle: Boolean read FSysPanelStyle write SetSysPanelStyle;
    property ViewInfo: TcxCustomEditPopupWindowViewInfo read GetViewInfo;
    property OnClosed;
  end;

  TcxCustomEditPopupWindowClass = class of TcxCustomEditPopupWindow;

  { TcxCustomDropDownEditProperties }

  TcxCustomDropDownEditProperties = class(TcxCustomMaskEditProperties)
  private
    FGlyphButtonIndex: Integer;
    FImmediateDropDown: Boolean;
    FImmediatePopup: Boolean;
    FKeepArrowButtonPressedWhenDroppedDown: Boolean;
    FPopupAutoSize: Boolean;
    FPopupClientEdge: Boolean;
    FPopupDirection: TcxPopupDirection;
    FPopupHeight: Integer;
    FPopupHorzAlignment: TcxPopupAlignHorz;
    FPopupMinHeight: Integer;
    FPopupMinWidth: Integer;
    FPopupSizeable: Boolean;
    FPopupSysPanelStyle: Boolean;
    FPopupVertAlignment: TcxPopupAlignVert;
    FPopupWidth: Integer;
    FPostPopupValueOnTab: Boolean;
    FOnCloseQuery: TCloseQueryEvent;
    FOnCloseUp: TNotifyEvent;
    FOnFinalizePopup: TNotifyEvent;    
    FOnInitPopup: TNotifyEvent;
    FOnPopup: TNotifyEvent;
    function GetButtonGlyph: TBitmap;
    function GetPopupAlignment: TAlignment;
    procedure SetButtonGlyph(Value: TBitmap);
    procedure SetGlyphButtonIndex(Value: Integer);
    procedure SetKeepArrowButtonPressedWhenDroppedDown(Value: Boolean);
    procedure SetPopupAlignment(Value: TAlignment);
    procedure SetPopupClientEdge(Value: Boolean);
    procedure SetPopupHeight(Value: Integer);
    procedure SetPopupMinHeight(Value: Integer);
    procedure SetPopupMinWidth(Value: Integer);
    procedure SetPopupSizeable(Value: Boolean);
    procedure SetPopupSysPanelStyle(Value: Boolean);
    procedure SetPopupWidth(Value: Integer);
  protected
    class function GetViewDataClass: TcxCustomEditViewDataClass; override;
    function IsLookupDataVisual: Boolean; override;
    procedure DoChanged; override;
    function DropDownButtonVisibleIndex: Integer; virtual;
    function DropDownOnClick: Boolean; virtual;
    function GetAlwaysPostEditValue: Boolean; virtual;
    class function GetPopupWindowClass: TcxCustomEditPopupWindowClass; virtual;
    function PopupWindowAcceptsAnySize: Boolean; virtual;
    function PopupWindowCapturesFocus: Boolean; virtual;
    property AlwaysPostEditValue: Boolean read GetAlwaysPostEditValue;
    property GlyphButtonIndex: Integer read FGlyphButtonIndex write SetGlyphButtonIndex;
  public
    constructor Create(AOwner: TPersistent); override;
    procedure Assign(Source: TPersistent); override;
    class function GetContainerClass: TcxContainerClass; override;
    // !!!
    property ButtonGlyph: TBitmap read GetButtonGlyph write SetButtonGlyph;
    property ImmediateDropDown: Boolean read FImmediateDropDown write FImmediateDropDown default True;
    property ImmediatePopup: Boolean read FImmediatePopup write FImmediatePopup default False;
    property KeepArrowButtonPressedWhenDroppedDown: Boolean
      read FKeepArrowButtonPressedWhenDroppedDown
      write SetKeepArrowButtonPressedWhenDroppedDown default False;
    property PopupAlignment: TAlignment read GetPopupAlignment write SetPopupAlignment default taLeftJustify;
    property PopupAutoSize: Boolean read FPopupAutoSize write FPopupAutoSize default True;
    property PopupClientEdge: Boolean read FPopupClientEdge write SetPopupClientEdge default False;
    property PopupDirection: TcxPopupDirection read FPopupDirection write FPopupDirection; 
    property PopupHeight: Integer read FPopupHeight write SetPopupHeight default 200;
    property PopupHorzAlignment: TcxPopupAlignHorz read FPopupHorzAlignment write FPopupHorzAlignment;    
    property PopupMinHeight: Integer read FPopupMinHeight write SetPopupMinHeight default 100;
    property PopupMinWidth: Integer read FPopupMinWidth write SetPopupMinWidth default 100;
    property PopupSizeable: Boolean read FPopupSizeable write SetPopupSizeable default False;
    property PopupSysPanelStyle: Boolean read FPopupSysPanelStyle write SetPopupSysPanelStyle default False;
    property PopupVertAlignment: TcxPopupAlignVert read FPopupVertAlignment write FPopupVertAlignment;
    property PopupWidth: Integer read FPopupWidth write SetPopupWidth default 250;
    property PostPopupValueOnTab: Boolean read FPostPopupValueOnTab
      write FPostPopupValueOnTab default False;
    property OnCloseQuery: TCloseQueryEvent read FOnCloseQuery write FOnCloseQuery;
    property OnCloseUp: TNotifyEvent read FOnCloseUp write FOnCloseUp;
    property OnFinalizePopup: TNotifyEvent read FOnFinalizePopup write FOnFinalizePopup;
    property OnInitPopup: TNotifyEvent read FOnInitPopup write FOnInitPopup;
    property OnPopup: TNotifyEvent read FOnPopup write FOnPopup;
  end;

  TcxCustomDropDownEditPropertiesClass = class of TcxCustomDropDownEditProperties;

  { TcxCustomDropDownEditViewData }

  TcxCustomDropDownEditViewData = class(TcxCustomTextEditViewData)
  private
    function GetProperties: TcxCustomDropDownEditProperties;
  protected
    function CanPressButton(AViewInfo: TcxCustomEditViewInfo; AButtonVisibleIndex: Integer): Boolean; override;
    function GetEditNativeState(AViewInfo: TcxCustomEditViewInfo): Integer; override;
    function IsButtonPressed(AViewInfo: TcxCustomEditViewInfo;
      AButtonVisibleIndex: Integer): Boolean; override;
  public
    HasPopupWindow: Boolean;
    IsHotAndPopup: Boolean;
    KeepArrowButtonPressedWhenDroppedDown: Boolean;
    procedure Calculate(ACanvas: TcxCanvas; const ABounds: TRect; const P: TPoint;
      Button: TcxMouseButton; Shift: TShiftState; AViewInfo: TcxCustomEditViewInfo;
      AIsMouseEvent: Boolean); override;
    property Properties: TcxCustomDropDownEditProperties read GetProperties;
  end;

  { TcxCustomDropDownEditData }

  TcxCustomDropDownEditData = class(TcxCustomEditData)
  protected
    Initialized: Boolean;
    Width, Height: Integer;
  end;

  TcxCustomDropDownEditDataClass = class of TcxCustomDropDownEditData;

  { TcxEditPopupControlLookAndFeel }

  TcxEditPopupControlLookAndFeel = class(TcxLookAndFeel)
  private
    function GetEdit: TcxCustomDropDownEdit;
  protected
    procedure EditStyleChanged;
    function InternalGetKind: TcxLookAndFeelKind; override;
    function InternalGetNativeStyle: Boolean; override;
    function InternalGetSkinName: string; override;
    
    property Edit: TcxCustomDropDownEdit read GetEdit;
  end;

  { TcxCustomDropDownInnerEdit }

  TcxCustomDropDownInnerEdit = class(TcxCustomInnerTextEdit)
  private
    function GetContainer: TcxCustomDropDownEdit;
    procedure CMHintShow(var Message: TCMHintShow); message CM_HINTSHOW;
  protected
    property Container: TcxCustomDropDownEdit read GetContainer;
  // TODO CLX
  end;

  { TcxCustomDropDownEdit }

  TcxCustomDropDownEdit = class(TcxCustomMaskEdit)
  private
    FIsActivatingByMouse: Boolean;
    FIsHotAndPopup: Boolean;
    FPopupControlsLookAndFeel: TcxEditPopupControlLookAndFeel;
    FPopupInitialized: Boolean;
    FPopupMouseMoveLocked: Boolean;
    FPopupSizeChanged: Boolean;
    FSendChildrenStyle: Boolean;
    procedure DropDownByPasteHandler;
    function GetDroppedDown: Boolean;
    function GetProperties: TcxCustomDropDownEditProperties;
    function GetActiveProperties: TcxCustomDropDownEditProperties;
    procedure SetDroppedDown(Value: Boolean);
    procedure SetProperties(Value: TcxCustomDropDownEditProperties);
    procedure CMBiDiModeChanged(var Message: TMessage); message CM_BIDIMODECHANGED;
    procedure CMDropDownByPaste(var Message: TMessage); message DXM_DROPDOWNBYPASTE;
    procedure CMHintShow(var Message: TCMHintShow); message CM_HINTSHOW;
  protected
    FCloseUpReason: TcxEditCloseUpReason;
    FPopupWindow: TcxCustomEditPopupWindow;
    procedure ContainerStyleChanged(Sender: TObject); override;
    function CreateViewData: TcxCustomEditViewData; override;
    procedure DestroyWnd; override;
    procedure DoButtonDown(AButtonVisibleIndex: Integer); override;
    procedure DoExit; override;
    procedure DoEditKeyDown(var Key: Word; Shift: TShiftState); override;
    procedure DoEditKeyPress(var Key: Char); override;
    procedure DoEditProcessTab(Shift: TShiftState); override;
    function DoMouseWheel(Shift: TShiftState; WheelDelta: Integer;
       MousePos: TPoint): Boolean; override;
    procedure FocusChanged; override;
    function GetEditDataClass: TcxCustomEditDataClass; override;
    function GetInnerEditClass: TControlClass; override;
    function GetScrollLookupDataList(AScrollCause: TcxEditScrollCause): Boolean; override;
    procedure Initialize; override;
    procedure InitializeEditData; override;
    function InternalGetNotPublishedStyleValues: TcxEditStyleValues; override;
    function IsEditorKey(Key: Word; Shift: TShiftState): Boolean; override;
    procedure PropertiesChanged(Sender: TObject); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    function DoRefreshContainer(const P: TPoint; Button: TcxMouseButton; Shift: TShiftState;
      AIsMouseEvent: Boolean): Boolean; override;
    function SendActivationKey(Key: Char): Boolean; override;
    function TabsNeeded: Boolean; override;
    procedure CreateHandle; override;
    procedure DoStartDock(var DragObject: TDragObject); override;
    function CanDropDown: Boolean; virtual;
    procedure CloseUp(AReason: TcxEditCloseUpReason); virtual;
    procedure CreatePopupWindow; virtual;
    procedure DeleteShowPopupWindowMessages;
    procedure DoCloseQuery(var CanClose: Boolean);
    procedure DoCloseUp; virtual;
    procedure DoFinalizePopup; virtual;
    procedure DoInitPopup; virtual;
    procedure DoPopup; virtual;
    procedure DropDown; virtual;
    procedure EditButtonClick; virtual;
    function GetPopupFocusedControl: TWinControl; virtual;
    function GetPopupWindowClientPreferredSize: TSize; virtual; abstract;
    function GetPopupWindowOwnerControlBounds: TRect;
    procedure InitializeLookupData; virtual;
    procedure InitializePopupWindow; virtual;
    procedure PopupControlsLookAndFeelChanged(Sender: TcxLookAndFeel;
      AChangedValues: TcxLookAndFeelValues); virtual;
    procedure PopupWindowClosed(Sender: TObject); dynamic;
    procedure PopupWindowCloseQuery(Sender: TObject; var CanClose: Boolean); dynamic;
    procedure PopupWindowClosing(Sender: TObject); dynamic;
    procedure PopupWindowShowing(Sender: TObject); dynamic;
    procedure PopupWindowShowed(Sender: TObject); dynamic;
    procedure PositionPopupWindowChilds(const AClientRect: TRect); virtual;
    procedure SetIsHotAndPopup;
    procedure SetupPopupWindow; virtual;
    procedure StorePopupSize; virtual;
    procedure UpdatePopupWindow;
    property IsHotAndPopup: Boolean read FIsHotAndPopup;
    property PopupControlsLookAndFeel: TcxEditPopupControlLookAndFeel
      read FPopupControlsLookAndFeel;
    property PopupMouseMoveLocked: Boolean read FPopupMouseMoveLocked write FPopupMouseMoveLocked;
    property PopupSizeChanged: Boolean read FPopupSizeChanged;
    property SendChildrenStyle: Boolean read FSendChildrenStyle write FSendChildrenStyle;
  public
    destructor Destroy; override;
    procedure Activate(var AEditData: TcxCustomEditData); override;
    procedure ActivateByKey(Key: Char; var AEditData: TcxCustomEditData); override;
    procedure ActivateByMouse(Shift: TShiftState; X, Y: Integer;
      var AEditData: TcxCustomEditData); override;
    procedure BeforeDestruction; override;
    function Deactivate: Boolean; override;
    function Focused: Boolean; override;
    class function GetPropertiesClass: TcxCustomEditPropertiesClass; override;
    function HasPopupWindow: Boolean; override;
    procedure PasteFromClipboard; override;
    function CanHide: Boolean; virtual;
    property ActiveProperties: TcxCustomDropDownEditProperties
      read GetActiveProperties;
    property DroppedDown: Boolean read GetDroppedDown write SetDroppedDown;
    property PopupWindow: TcxCustomEditPopupWindow read FPopupWindow;
    property Properties: TcxCustomDropDownEditProperties read GetProperties
      write SetProperties;
  end;

  { TcxFilterDropDownEditHelper }

  TcxFilterDropDownEditHelper = class(TcxFilterMaskEditHelper)
  public
    class function EditPropertiesHasButtons: Boolean; override;
  end;

  { TcxComboBoxPopupWindow }

  TcxComboBoxPopupWindow = class(TcxCustomEditPopupWindow)
  protected
    procedure CalculateSize; override;
  end;

  { TcxCustomComboBoxListBox }

  TcxCustomComboBoxListBox = class(TcxCustomEditListBox)
  private
    function GetEdit: TcxCustomComboBox;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    function DoDrawItem(AIndex: Integer; const ARect: TRect;
      AState: TOwnerDrawState): Boolean; override;
    function GetItem(Index: Integer): string; override;
    procedure MeasureItem(Index: Integer; var Height: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure RecreateWindow; override;
    property Edit: TcxCustomComboBox read GetEdit;
  public
    constructor Create(AOwner: TComponent); override;
    function GetHeight(ARowCount: Integer; AMaxHeight: Integer): Integer; override;
  end;

  { TcxComboBoxListBox }

  TcxComboBoxListBox = class(TcxCustomComboBoxListBox)
  protected
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure RecreateWindow; override;
    procedure SetItemIndex(const Value: Integer); override;
    procedure Resize; override;
  public
    function GetItemHeight(AIndex: Integer = -1): Integer; override;
  end;

  { TcxComboBoxLookupData }

  TcxComboBoxLookupData = class(TcxCustomTextEditLookupData)
  protected
    function GetListBoxClass: TcxCustomEditListBoxClass; override;
  public
    function CanResizeVisualArea(var NewSize: TSize;
      AMaxHeight: Integer = 0; AMaxWidth: Integer = 0): Boolean; override;
    function GetVisualAreaPreferredSize(AMaxHeight: Integer; AWidth: Integer = 0): TSize; override;
    procedure Initialize(AVisualControlsParent: TWinControl); override;
  end;

  { TcxCustomComboBoxViewData }

  TcxCustomComboBoxProperties = class;

  TcxCustomComboBoxViewData = class(TcxCustomDropDownEditViewData)
  private
    function GetProperties: TcxCustomComboBoxProperties;
  protected
    function IsComboBoxStyle: Boolean; override;
  public
    procedure Calculate(ACanvas: TcxCanvas; const ABounds: TRect; const P: TPoint;
      Button: TcxMouseButton; Shift: TShiftState; AViewInfo: TcxCustomEditViewInfo;
      AIsMouseEvent: Boolean); override;
    procedure EditValueToDrawValue(ACanvas: TcxCanvas; const AEditValue: TcxEditValue;
      AViewInfo: TcxCustomEditViewInfo); override;
    property Properties: TcxCustomComboBoxProperties read GetProperties;
  end;

  { TcxCustomTextEditViewInfo }

  TcxCustomComboBoxViewInfo = class(TcxCustomTextEditViewInfo)
  private
    function GetEdit: TcxCustomComboBox;
  protected
    procedure DoCustomDraw(ACanvas: TcxCanvas; ARect: TRect); virtual;
  public
    ItemIndex: Integer;
    constructor Create; override;
    property Edit: TcxCustomComboBox read GetEdit;
  end;

  { TcxCustomComboBoxProperties }

  TcxCustomComboBoxProperties = class(TcxCustomDropDownEditProperties)
  private
    FDropDownListStyle: TcxEditDropDownListStyle;
    FDropDownRows: Integer;
    FItemHeight: Integer;
    FRevertable: Boolean;
    FOnDrawItem: TcxEditDrawItemEvent;
    FOnMeasureItem: TMeasureItemEvent;
    function GetDropDownAutoWidth: Boolean;
    function GetDropDownSizeable: Boolean;
    function GetDropDownWidth: Integer;
    function GetItems: TStrings;
    function GetSorted: Boolean;
    procedure SetDropDownAutoWidth(Value: Boolean);
    procedure SetDropDownListStyle(Value: TcxEditDropDownListStyle);
    procedure SetDropDownRows(Value: Integer);
    procedure SetDropDownSizeable(Value: Boolean);
    procedure SetDropDownWidth(Value: Integer);
    procedure SetItemHeight(Value: Integer);
    procedure SetItems(Value: TStrings);
    procedure SetSorted(Value: Boolean);
  protected
    function DropDownOnClick: Boolean; override;
    function GetDropDownPageRowCount: Integer; override;
    function GetEditingStyle: TcxEditEditingStyle; override;
    class function GetLookupDataClass: TcxInterfacedPersistentClass; override;
    class function GetPopupWindowClass: TcxCustomEditPopupWindowClass; override;
    class function GetViewDataClass: TcxCustomEditViewDataClass; override;
    function UseLookupData: Boolean; override;
  public
    constructor Create(AOwner: TPersistent); override;
    procedure Assign(Source: TPersistent); override;
    class function GetContainerClass: TcxContainerClass; override;
    class function GetViewInfoClass: TcxContainerViewInfoClass; override;
    // !!!
    property DropDownAutoWidth: Boolean read GetDropDownAutoWidth
      write SetDropDownAutoWidth default True;
    property DropDownListStyle: TcxEditDropDownListStyle read FDropDownListStyle
      write SetDropDownListStyle default lsEditList;
    property DropDownRows: Integer read FDropDownRows write SetDropDownRows
      default cxEditDefaultDropDownPageRowCount;
    property DropDownSizeable: Boolean read GetDropDownSizeable
      write SetDropDownSizeable default False;
    property DropDownWidth: Integer read GetDropDownWidth write SetDropDownWidth
      default 0;
    property ItemHeight: Integer read FItemHeight write SetItemHeight default 0;
    property Items: TStrings read GetItems write SetItems;
    property Revertable: Boolean read FRevertable write FRevertable default False;
    property Sorted: Boolean read GetSorted write SetSorted default False;
    property OnDrawItem: TcxEditDrawItemEvent read FOnDrawItem write FOnDrawItem;
    property OnMeasureItem: TMeasureItemEvent read FOnMeasureItem write FOnMeasureItem;
  end;

  { TcxComboBoxProperties }

  TcxComboBoxProperties = class(TcxCustomComboBoxProperties)
  published
    property Alignment;
    property AssignedValues;
    property AutoSelect;
    property BeepOnError;
    property ButtonGlyph;
    property CaseInsensitive;
    property CharCase;
    property ClearKey;
    property DropDownAutoWidth;
    property DropDownListStyle;
    property DropDownRows;
    property DropDownSizeable;
    property DropDownWidth;
    property HideSelection;
    property IgnoreMaskBlank;
    property ImeMode;
    property ImeName;
    property ImmediateDropDown;
    property ImmediatePost;
    property ImmediateUpdateText;
    property IncrementalSearch;
    property ItemHeight;
    property Items;
    property MaskKind;
    property EditMask;
    property MaxLength;
    property OEMConvert;
    property PopupAlignment;
    property PostPopupValueOnTab;
    property ReadOnly;
    property Revertable;
    property Sorted;
    property UseLeftAlignmentOnEditing;
    property ValidateOnEnter;
    property OnChange;
    property OnCloseUp;
    property OnDrawItem;
    property OnEditValueChanged;
    property OnInitPopup;
    property OnMeasureItem;
    property OnNewLookupDisplayText;
    property OnPopup;
    property OnValidate;
  end;

  { TcxCustomComboBoxInnerEdit }

  TcxCustomComboBoxInnerEdit = class(TcxCustomDropDownInnerEdit)
  private
    procedure WMLButtonUp(var Message: TWMLButtonUp); message WM_LBUTTONUP;
  protected
  end;

  { TcxCustomComboBox }

  TcxCustomComboBox = class(TcxCustomDropDownEdit)
  private
    function GetActiveProperties: TcxCustomComboBoxProperties;
    function GetLookupData: TcxComboBoxLookupData;
    function GetProperties: TcxCustomComboBoxProperties;
    function GetSelectedItem: Integer;
    procedure SetProperties(Value: TcxCustomComboBoxProperties);
    procedure SetSelectedItem(Value: Integer);
    procedure WMLButtonUp(var Message: TWMLButtonUp); message WM_LBUTTONUP;
  protected
    function CanDropDown: Boolean; override;
    procedure ChangeHandler(Sender: TObject); override;
    procedure DblClick; override;
    function GetInnerEditClass: TControlClass; override;
    function GetPopupWindowClientPreferredSize: TSize; override;
    procedure Initialize; override;
    procedure InitializePopupWindow; override;
    function IsTextInputMode: Boolean; override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure PopupWindowShowed(Sender: TObject); override;
    procedure SetupPopupWindow; override;
    function CanSynchronizeLookupData: Boolean;
    procedure ResetPopupHeight;
    procedure SynchronizeItemIndex;
    procedure DoOnDrawItem(ACanvas: TcxCanvas; AIndex: Integer;
      const ARect: TRect; AState: TOwnerDrawState);
    procedure DoOnMeasureItem(AIndex: Integer; ACanvas: TcxCanvas;
      var AHeight: Integer);
    function IsOnDrawItemEventAssigned: Boolean;
    function IsOnMeasureItemEventAssigned: Boolean;
    property LookupData: TcxComboBoxLookupData read GetLookupData;
  public
    procedure Activate(var AEditData: TcxCustomEditData); override;
    class function GetPropertiesClass: TcxCustomEditPropertiesClass; override;
    property ActiveProperties: TcxCustomComboBoxProperties read GetActiveProperties;
    property ItemIndex;
    property ItemObject;
    property Properties: TcxCustomComboBoxProperties read GetProperties
      write SetProperties;
    property SelectedItem: Integer read GetSelectedItem write SetSelectedItem;
  end;

  { TcxComboBox }

  TcxComboBox = class(TcxCustomComboBox)
  private
    function GetActiveProperties: TcxComboBoxProperties;
    function GetProperties: TcxComboBoxProperties;
    procedure SetProperties(Value: TcxComboBoxProperties);
  protected
    function SupportsSpelling: Boolean; override;
  public
    class function GetPropertiesClass: TcxCustomEditPropertiesClass; override;
    property ActiveProperties: TcxComboBoxProperties read GetActiveProperties;
  published
    property Anchors;
    property AutoSize;
    property BeepOnEnter;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property ImeMode;
    property ImeName;
    property ItemIndex;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property Properties: TcxComboBoxProperties read GetProperties
      write SetProperties;
    property ShowHint;
    property Style;
    property StyleDisabled;
    property StyleFocused;
    property StyleHot;
    property TabOrder;
    property TabStop;
    property Text;
  {$IFDEF DELPHI12}
    property TextHint;
  {$ENDIF}
    property Visible;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEditing;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
  end;

  { TcxFilterComboBoxHelper }

  TcxFilterComboBoxHelper = class(TcxFilterDropDownEditHelper)
  public
    class function GetFilterEditClass: TcxCustomEditClass; override;
    class procedure InitializeProperties(AProperties,
      AEditProperties: TcxCustomEditProperties; AHasButtons: Boolean); override;
  end;

  { TcxPopupEditPopupWindowViewInfo }

  TcxPopupEditPopupWindowViewInfo = class(TcxCustomEditPopupWindowViewInfo)
  public
    procedure DrawBorder(ACanvas: TcxCanvas; var R: TRect); override;
  end;

  { TcxPopupEditPopupWindow }

  TcxPopupEditPopupWindow = class(TcxCustomEditPopupWindow)
  public
    function GetViewInfoClass: TcxContainerViewInfoClass; override;
  end;

  { TcxCustomPopupEditProperties }

  TcxCustomPopupEditProperties = class(TcxCustomDropDownEditProperties)
  private
    FPopupControl: TControl;
    procedure SetPopupControl(Value: TControl);
  protected
    procedure FreeNotification(Sender: TComponent); override;
    class function GetPopupWindowClass: TcxCustomEditPopupWindowClass; override;
    function IsLookupDataVisual: Boolean; override;
    function PopupWindowCapturesFocus: Boolean; override;
  public
    constructor Create(AOwner: TPersistent); override;
    procedure Assign(Source: TPersistent); override;
    class function GetContainerClass: TcxContainerClass; override;
    // !!!
    property PopupControl: TControl read FPopupControl write SetPopupControl;
    property PopupSizeable default True;
  end;

  { TcxPopupEditProperties }

  TcxPopupEditProperties = class(TcxCustomPopupEditProperties)
  public
    constructor Create(AOwner: TPersistent); override;
  published
    property Alignment;
    property AssignedValues;
    property AutoSelect;
    property BeepOnError;
    property ButtonGlyph;
    property CaseInsensitive;
    property CharCase;
    property ClearKey;
    property EchoMode;
    property HideSelection;
    property IgnoreMaskBlank;
    property ImeMode;
    property ImeName;
    property ImmediateDropDown;
    property ImmediatePopup default True;
    property IncrementalSearch;
    property LookupItems;
    property LookupItemsSorted;
    property MaxLength;
    property MaskKind;
    property EditMask;
    property OEMConvert;
    property PasswordChar;
    property PopupAlignment;
    property PopupAutoSize;
    property PopupClientEdge;
    property PopupControl;
    property PopupHeight;
    property PopupMinHeight;
    property PopupMinWidth;
    property PopupSizeable;
    property PopupSysPanelStyle;
    property PopupWidth;
    property ReadOnly;
    property UseLeftAlignmentOnEditing;
    property ValidateOnEnter;
    property OnChange;
    property OnCloseQuery;
    property OnCloseUp;
    property OnEditValueChanged;
    property OnInitPopup;
    property OnPopup;
    property OnValidate;
  end;

  { TcxCustomPopupEdit }

  TcxPrevPopupControlData = record
    Align: TAlign;
    Bounds: TRect;
    Parent: TWinControl;
    Visible: Boolean;
    BorderStyle: TFormBorderStyle;
  end;

  TcxCustomPopupEdit = class(TcxCustomDropDownEdit)
  private
    FPrevPopupControlData: TcxPrevPopupControlData;
    function GetProperties: TcxCustomPopupEditProperties;
    function GetActiveProperties: TcxCustomPopupEditProperties;
    procedure SetProperties(Value: TcxCustomPopupEditProperties);
  protected
    function CanDropDown: Boolean; override;
    procedure DoInitPopup; override;
    function GetPopupFocusedControl: TWinControl; override;
    function GetPopupWindowClientPreferredSize: TSize; override;
    procedure PopupWindowClosed(Sender: TObject); override;
    procedure PositionPopupWindowChilds(const AClientRect: TRect); override;
    procedure SetupPopupWindow; override;
    procedure HidePopup(Sender: TcxControl; AReason: TcxEditCloseUpReason); virtual;
    procedure RestorePopupControlData; virtual;
    procedure SavePopupControlData; virtual;
  public
    destructor Destroy; override;
    class function GetPropertiesClass: TcxCustomEditPropertiesClass; override;
    property ActiveProperties: TcxCustomPopupEditProperties read GetActiveProperties;
    property Properties: TcxCustomPopupEditProperties read GetProperties
      write SetProperties;
  end;

  { TcxPopupEdit }

  TcxPopupEdit = class(TcxCustomPopupEdit)
  private
    function GetActiveProperties: TcxPopupEditProperties;
    function GetProperties: TcxPopupEditProperties;
    procedure SetProperties(Value: TcxPopupEditProperties);
  protected
    function SupportsSpelling: Boolean; override;
  public
    class function GetPropertiesClass: TcxCustomEditPropertiesClass; override;
    property ActiveProperties: TcxPopupEditProperties read GetActiveProperties;
  published
    property Anchors;
    property AutoSize;
    property BeepOnEnter;
    property Constraints;
    property DragMode;
    property Enabled;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property Properties: TcxPopupEditProperties read GetProperties
      write SetProperties;
    property ShowHint;
    property Style;
    property StyleDisabled;
    property StyleFocused;
    property StyleHot;
    property TabOrder;
    property TabStop;
    property Text;
  {$IFDEF DELPHI12}
    property TextHint;
  {$ENDIF}
    property Visible;
    property DragCursor;
    property DragKind;
    property ImeMode;
    property ImeName;
    property OnClick;
{$IFDEF DELPHI5}
    property OnContextPopup;
{$ENDIF}
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEditing;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDrag;
    property OnEndDock;
    property OnStartDock;
  end;

implementation

uses
  Math, dxThemeConsts, dxThemeManager, dxUxTheme, cxEditConsts, cxEditPaintUtils,
  cxEditUtils, cxScrollBar, cxGeometry, cxDWMApi, Types;

const
  htCloseButton = 0;
  htSizeGrip = 1;

type
  TcxCustomEditStyleAccess = class(TcxCustomEditStyle);
  TControlAccess = class(TControl);
  TCustomFormAccess = class(TCustomForm);
  TWinControlAccess = class(TWinControl);

var
  FSizeFrameBounds: TRect = (Left: 0; Top: 0; Right: 0; Bottom: 0);
  FPaintedSizeFrameBounds: TRect = (Left: 0; Top: 0; Right: 0; Bottom: 0);

procedure SetEditPopupWindowShadowRegion(APopupWindow: TcxCustomEditPopupWindow);
var
  R: TRect;
  AExcludeRect: TRect;
begin
  AExcludeRect := cxEmptyRect;
  R := GetControlRect(APopupWindow);
  with APopupWindow.ViewInfo do
  begin
    if not NativeStyle then
      if Shadow then
      begin
        R := cxRectContent(R, GetShadowOffsets);
        if SizeGripCorner in [coTopLeft, coTopRight] then
        begin
          AExcludeRect := APopupWindow.OwnerScreenBounds;
          AExcludeRect.TopLeft := APopupWindow.ScreenToClient(AExcludeRect.TopLeft);
          AExcludeRect.BottomRight := APopupWindow.ScreenToClient(AExcludeRect.BottomRight);
          Dec(AExcludeRect.Right, cxEditShadowWidth);
          AExcludeRect.Bottom := APopupWindow.Height;
          AExcludeRect.Top := AExcludeRect.Bottom - cxEditShadowWidth;
        end;
      end;
    SetWindowShadowRegion(APopupWindow.Handle, R, cxEmptyRect,
      NativeStyle, Shadow, AExcludeRect);
  end;
end;

{ TcxCustomEditPopupWindowViewInfo }

procedure TcxCustomEditPopupWindowViewInfo.DrawBorder(ACanvas: TcxCanvas; var R: TRect);
var
  ABorderWidth: Integer;
begin
  if DrawCustomBorder(ACanvas, R, ABorderWidth) then
    InflateRect(R, -ABorderWidth, -ABorderWidth)
  else
    Painter.DrawEditPopupWindowBorder(ACanvas, R, BorderStyle, ClientEdge);
end;

function TcxCustomEditPopupWindowViewInfo.GetBorderExtent: TRect;
begin
  Result := GetBorders;
  Result := cxRectTransform(Result, GetClientEdges);

  if Shadow then
    Result := cxRectTransform(Result, GetShadowOffsets);

  if SysPanelStyle then
  begin
    SysPanelHeight := GetSysPanelHeight;
    if SizeGripCorner in [coBottomLeft, coBottomRight] then
      Inc(Result.Bottom, SysPanelHeight)
    else
      Inc(Result.Top, SysPanelHeight);
  end
  else
    SysPanelHeight := 0;
end;

function TcxCustomEditPopupWindowViewInfo.GetClientExtent: TRect;
begin
  Result := GetBorderExtent;
end;

function TcxCustomEditPopupWindowViewInfo.GetSysPanelHeight: Integer;
begin
  Result := Max(GetSysPanelDefaultHeight, MinSysPanelHeight);
end;

function TcxCustomEditPopupWindowViewInfo.DrawCustomBorder(ACanvas: TcxCanvas; const R: TRect; out ABorderWidth: Integer): Boolean;
begin
  Result := False;
  ABorderWidth := 0;
  if Assigned(FOnCustomDrawBorder) then
    FOnCustomDrawBorder(Self, ACanvas, R, Result, ABorderWidth);
end;

function TcxCustomEditPopupWindowViewInfo.GetBorders: TRect;
var
  ABorderWidth: Integer;
begin
  ABorderWidth := GetBorderWidth;
  Result := cxRect(ABorderWidth, ABorderWidth, ABorderWidth, ABorderWidth);
end;

function TcxCustomEditPopupWindowViewInfo.GetBorderWidth: Integer;
begin
  if not DrawCustomBorder(nil, cxEmptyRect, Result) then
    Result := Painter.GetEditPopupWindowBorderWidth(BorderStyle);
end;

function TcxCustomEditPopupWindowViewInfo.GetClientEdges: TRect;
var
  AClientEdge: Integer;
begin
  if ClientEdge then
  begin
    AClientEdge := Painter.GetEditPopupWindowClientEdgeWidth(BorderStyle);
    Result := cxRect(AClientEdge, AClientEdge, AClientEdge, AClientEdge);
  end
  else
    Result := cxNullRect;
end;

function TcxCustomEditPopupWindowViewInfo.GetShadowOffsets: TRect;
begin
  Result := cxRect(0, 0, cxEditShadowWidth, cxEditShadowWidth);
end;

function TcxCustomEditPopupWindowViewInfo.GetSysPanelDefaultHeight: Integer;
begin
  Result := IfThen(SysPanelStyle, Painter.PopupPanelSize);
end;

function TcxCustomEditPopupWindowViewInfo.GetSysPanelBorders: TRect;
begin
  Result := cxEmptyRect;
  if NativeStyle or (BorderStyle = epbsSingle) or UseSkins then
    if SizeGripCorner in [coBottomLeft, coBottomRight] then
      Result.Top := 1
    else
      Result.Bottom := 1;
end;

procedure TcxCustomEditPopupWindowViewInfo.InternalPaint(ACanvas: TcxCanvas);

  procedure DrawClientEdge;
  var
    ARect: TRect;
  begin
    ARect := cxRectInflate(ClientRect, GetClientEdges);
    ACanvas.DrawEdge(ARect, True, True);
    if NativeStyle or (BorderStyle <> epbsFlat) then
    begin
      InflateRect(ARect, -1, -1);
      ACanvas.DrawEdge(ARect, True, False);
    end;
  end;

  procedure DrawShadow;
  begin
    DrawContainerShadow(ACanvas,
      cxRectContent(cxRectSetNullOrigin(Bounds), GetShadowOffsets));
  end;

  procedure InternalDrawBorder;
  var
    ABorderRect: TRect;
  begin
    ABorderRect := cxRectSetNullOrigin(Bounds);
    if Shadow then
      ABorderRect := cxRectContent(ABorderRect, GetShadowOffsets);
    DrawBorder(ACanvas, ABorderRect);
  end;

begin
  if Shadow then
    DrawShadow;

  InternalDrawBorder;

  if ClientEdge then
    DrawClientEdge;

  if SysPanelStyle then
    Painter.DrawPopupPanelBand(ACanvas, SysPanelBounds, SizeGripRect, CloseButtonRect,
      SizeGripCorner, CloseButtonState, GetSysPanelBorders, Painter.GetContainerBorderColor(False));

  Painter.DrawWindowContent(ACanvas, ClientRect);
end;

{ TcxCustomEditPopupWindow }

constructor TcxCustomEditPopupWindow.Create(AOwnerControl: TWinControl);
begin
  inherited Create(AOwnerControl);
  ViewInfo.CloseButtonState := cxbsNormal;
end;

destructor TcxCustomEditPopupWindow.Destroy;
begin
  FreeAndNil(FSizeFrame);
  inherited Destroy;
end;

function TcxCustomEditPopupWindow.GetViewInfoClass: TcxContainerViewInfoClass;
begin
  Result := TcxCustomEditPopupWindowViewInfo;
end;

procedure TcxCustomEditPopupWindow.Popup(AFocusedControl: TWinControl);
begin
  if not IsOwnerControlVisible then
    Edit.DoFinalizePopup;
  inherited Popup(AFocusedControl);
end;

function TcxCustomEditPopupWindow.AcceptsAnySize: Boolean;
begin
  Result := Edit.ActiveProperties.PopupWindowAcceptsAnySize;
end;

procedure TcxCustomEditPopupWindow.AdjustClientRect(var Rect: TRect);
var
  AClientExtent: TRect;
begin
  AClientExtent := ViewInfo.GetClientExtent;
  ExtendRect(Rect, AClientExtent);
end;

function TcxCustomEditPopupWindow.CalculatePosition: TPoint;
const
  ASizeGripCornerMap: array[Boolean, Boolean] of TdxCorner = (
    (coTopLeft, coBottomLeft),
    (coTopRight, coBottomRight)
  );
var
  ALeftFlag, ATopFlag: Boolean;
  AOwnerRect: TRect;
  ADesktopWorkArea: TRect;
begin
  OwnerBounds := Edit.GetPopupWindowOwnerControlBounds;
  Result := inherited CalculatePosition;

  AOwnerRect := OwnerScreenBounds;
  ADesktopWorkArea := GetDesktopWorkArea(Point(Result.X, Result.Y));

  ALeftFlag := (AlignHorz = pahRight) and (Result.X + Width = AOwnerRect.Right) and (Result.X > ADesktopWorkArea.Left) or {pahRight + pdVertical}
    (Result.X + Width = AOwnerRect.Left) or                                                    {pahLeft + pdHorizontal}
    (Result.X + Width = ADesktopWorkArea.Right) and (Result.X < AOwnerRect.Right);
  ATopFlag := (AlignVert = pavBottom) and (Result.Y + Height = AOwnerRect.Bottom) and (Result.Y > ADesktopWorkArea.Top) or {pavBottom + pdHorizontal}
    (Result.Y + Height = AOwnerRect.Top) or                                                    {pavTop + pdVertical}
    (Result.Y + Height = ADesktopWorkArea.Bottom) and (Result.Y < AOwnerRect.Bottom);

  ViewInfo.SizeGripCorner := ASizeGripCornerMap[not ALeftFlag, not ATopFlag];

  if Shadow and ATopFlag then
    Inc(Result.Y, cxEditShadowWidth);
end;

procedure TcxCustomEditPopupWindow.CalculateSize;
var
  AClientExtent: TRect;
  AMinSize: TSize;
  APreferredWidth, APreferredHeight: Integer;
  APopupWindowVisualAreaSize: TSize;
begin
  ViewInfo.SizeGripCorner := coBottomRight;
  OwnerBounds := Edit.GetPopupWindowOwnerControlBounds;
  AClientExtent := ViewInfo.GetClientExtent;
  AMinSize := MinSize;
  APopupWindowVisualAreaSize := Edit.GetPopupWindowClientPreferredSize;
  with OwnerBounds do
  begin
    if PopupAutoSize then
      APreferredWidth := AClientExtent.Left + AClientExtent.Right + APopupWindowVisualAreaSize.cx
    else
      if PopupWidth = 0 then
        APreferredWidth := Right - Left
      else
        APreferredWidth := PopupWidth;
    if Sizeable and (MinWidth > 0) and (APreferredWidth < MinWidth) then
      APreferredWidth := MinWidth;
    if APreferredWidth < AMinSize.cx then
      APreferredWidth := AMinSize.cx;

    APreferredHeight := AMinSize.cy;
    if PopupAutoSize then
      APreferredHeight := AClientExtent.Top + AClientExtent.Bottom + APopupWindowVisualAreaSize.cy
    else
      if PopupHeight > 0 then
        APreferredHeight := PopupHeight
      else
        if APreferredHeight < MinHeight then
          APreferredHeight := MinHeight;
    if Sizeable and (MinHeight > 0) and (APreferredHeight < MinHeight) then
      APreferredHeight := MinHeight;
    if APreferredHeight < AMinSize.cy then
      APreferredHeight := AMinSize.cy;

    Width := APreferredWidth;
    Height := APreferredHeight;
  end;
end;

procedure TcxCustomEditPopupWindow.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  if Edit.IsNativeStyle and IsWinVistaOrLater then
    Params.WindowClass.Style := Params.WindowClass.style or $20000{= CS_DROPSHADOW};
end;

procedure TcxCustomEditPopupWindow.DoClosing;
begin
  inherited DoClosing;
  FSizingCapture := False;
  DrawSizeFrame(cxEmptyRect);
end;

procedure TcxCustomEditPopupWindow.ModalCloseUp;
var
  AReason: TcxEditCloseUpReason;
begin
  case ModalResult of
    mrOk: AReason := crEnter;
    mrCancel: AReason := crCancel;
  else
    AReason := crUnknown;
  end;
  Edit.CloseUp(AReason);
end;

procedure TcxCustomEditPopupWindow.KeyDown(var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_ESCAPE: EndResize(False);
  end;
  inherited;
end;

procedure TcxCustomEditPopupWindow.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  P: TPoint;
begin
  P := Point(X, Y);
  UpdateSysPanelState(P, Shift);
  if (Button = mbLeft) and (GetHitTest(P) = htSizeGrip) and (GetCaptureControl <> nil) then
    StartResize(P);
end;

procedure TcxCustomEditPopupWindow.MouseLeave(AControl: TControl);
begin
  if not FSizingCapture then
    UpdateSysPanelState;
end;

procedure TcxCustomEditPopupWindow.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  if FSizingCapture then
    DoResize(Point(X, Y))
  else
    UpdateSysPanelState(Point(X, Y), Shift);
end;

procedure TcxCustomEditPopupWindow.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (Button = mbLeft) then
    if FSizingCapture then
      EndResize(True)
    else
      if (ViewInfo.CloseButtonState = cxbsPressed) and CloseQuery then
        Edit.CloseUp(crClose);
  UpdateSysPanelState(Point(X, Y), Shift);
end;

procedure TcxCustomEditPopupWindow.Resize;
begin
  inherited Resize;
  if HandleAllocated then
    SetEditPopupWindowShadowRegion(Self);
end;

procedure TcxCustomEditPopupWindow.CalculateViewInfo;

  procedure CalculateSizeGripSizingRect;
  var
    ARect: TRect;
  begin
    with ViewInfo do
    begin
      ARect := SizeGripRect;
      if SizeGripCorner in [coTopLeft, coBottomLeft] then
        ARect.Left := SysPanelBounds.Left
      else
        ARect.Right := SysPanelBounds.Right;
      if SizeGripCorner in [coTopLeft, coTopRight] then
        ARect.Top := SysPanelBounds.Top
      else
        ARect.Bottom := SysPanelBounds.Bottom;
      SizeGripSizingRect := ARect;
    end;
  end;

begin
  with ViewInfo do
  begin
    UpdateStyle(Style);
    Bounds := GetControlRect(Self);
    ClientRect := cxRectSetNullOrigin(Bounds);
    if Shadow then
      ClientRect := cxRectContent(ClientRect, GetShadowOffsets);

    if SysPanelStyle then
    begin
      Painter.CalculatePopupPanelClientRect(ClientRect, SysPanelBounds,
        SizeGripRect, CloseButtonRect, SizeGripCorner,
        GetBorders, GetSysPanelBorders,
        SysPanelHeight, ShowCloseButton, Sizeable);
      CalculateSizeGripSizingRect;
    end
    else
    begin
      ClientRect := cxRectContent(ClientRect, GetBorders);
      SysPanelBounds := cxNullRect;
      SizeGripRect := cxNullRect;
      CloseButtonRect := cxNullRect;
      SizeGripSizingRect := cxNullRect;
    end;
    ClientRect := cxRectContent(ClientRect, GetClientEdges);
  end;
  UpdateSysPanelState;
end;

function TcxCustomEditPopupWindow.CanResize(var NewWidth, NewHeight: Integer): Boolean;
var
  AClientExtent: TRect;
  AClienExtentSize: TSize;
  AMinSize: TSize;
  ANewVisualAreaSize, AMaxVisualAreaSize: TSize;
begin
  Result := True;
  if not Sizeable or (NewWidth = Width) and (NewHeight = Height) or FLockCheckSize then
    Exit;
  AMinSize := MinSize;
  NewWidth := Max(NewWidth, Max(AMinSize.cx, MinWidth));
  NewHeight := Max(NewHeight, Max(AMinSize.cy, MinHeight));

  if (NewHeight <> Height) or (NewWidth <> Width) then
    with Edit do
      if ActiveProperties.UseLookupData and ActiveProperties.IsLookupDataVisual then
      begin
        AClientExtent := Self.ViewInfo.GetClientExtent;
        AClienExtentSize := cxSize(AClientExtent.Left + AClientExtent.Right, AClientExtent.Top + AClientExtent.Bottom);
        ANewVisualAreaSize := cxSize(NewWidth - AClienExtentSize.cx, NewHeight - AClienExtentSize.cy);
        AMaxVisualAreaSize := GetMaxVisualAreaSize;
        if not ILookupData.CanResizeVisualArea(ANewVisualAreaSize, AMaxVisualAreaSize.cy, AMaxVisualAreaSize.cx) then
        begin
          NewWidth := Self.Width;
          NewHeight := Self.Height;
        end
        else
        begin
          NewWidth := Max(ANewVisualAreaSize.cx + AClienExtentSize.cx, AMinSize.cx);
          NewHeight := Max(ANewVisualAreaSize.cy + AClienExtentSize.cy, AMinSize.cy);
        end;
      end;
end;

procedure TcxCustomEditPopupWindow.DoPopupControlKey(Key: Char);
begin
  SendMessage(GetFocus, WM_CHAR, Integer(Key), 0);
end;

procedure TcxCustomEditPopupWindow.DrawSizeFrame(const R: TRect);
var
  ABorderWidth: Integer;
begin
  if cxRectIsEmpty(R) then
  begin
    FreeAndNil(FSizeFrame);
    Exit;
  end;
  if FSizingCapture and not IsRectEmpty(R) then
  begin
    ABorderWidth := ViewInfo.GetBorderWidth;
    if ABorderWidth < 2 then
      ABorderWidth := 2;
    if FSizeFrame = nil then
    begin
      FSizeFrame := TcxSizeFrame.Create(ABorderWidth);
      FSizeFrame.PopupParent := Self;
    end;
    FSizeFrame.Show;
    FSizeFrame.DrawSizeFrame(R);
  end;
  FPaintedSizeFrameBounds := R;
  if not IsRectEmpty(R) then
    FSizeFrameBounds := R;
end;

function TcxCustomEditPopupWindow.GetMaxVisualAreaSize: TSize;
var
  AClientExtent, AEditBounds, ADesktopArea: TRect;
  AShadowWidth: Integer;
begin
  AClientExtent := ViewInfo.GetClientExtent;
  AEditBounds := Edit.GetPopupWindowOwnerControlBounds;
  if IsChildClassWindow(Edit.Handle) then
  begin
    AEditBounds.TopLeft := Edit.Parent.ClientToScreen(AEditBounds.TopLeft);
    AEditBounds.BottomRight := Edit.Parent.ClientToScreen(AEditBounds.BottomRight);
  end;

  if ViewInfo.Shadow then
    AShadowWidth := cxEditShadowWidth
  else
    AShadowWidth := 0;

  ADesktopArea := GetDesktopWorkArea(AEditBounds.TopLeft);

  if Edit.ActiveProperties.PopupDirection = pdHorizontal then
  begin
    Result.cx := Max(ADesktopArea.Right - AEditBounds.Right, AEditBounds.Left - ADesktopArea.Left + AShadowWidth) + 1;
    Result.cy := cxRectHeight(ADesktopArea);
  end
  else
  begin
    Result.cx := cxRectWidth(ADesktopArea);
    Result.cy := Max(ADesktopArea.Bottom - AEditBounds.Bottom, AEditBounds.Top - ADesktopArea.Top + AShadowWidth);
  end;
  Result.cx := Result.cx - (AClientExtent.Left + AClientExtent.Right);
  Result.cy := Result.cy - (AClientExtent.Top + AClientExtent.Bottom);
end;

function TcxCustomEditPopupWindow.GetMinSize: TSize;
begin
  with ViewInfo.GetClientExtent do
    Result := cxSize(Left + Right, Top + Bottom);
  if Sizeable and SysPanelStyle then
  begin
    with ViewInfo.CloseButtonRect do
      Result.cx := Result.cx + Right - Left;
    with ViewInfo.SizeGripSizingRect do
      Result.cx := Result.cx + Right - Left;
    Result.cx := Result.cx + 10;
  end;
end;

procedure TcxCustomEditPopupWindow.RefreshPopupWindow;
begin
  OwnerBounds := Edit.GetPopupWindowOwnerControlBounds;
  CalculateViewInfo;
  Edit.PositionPopupWindowChilds(ViewInfo.ClientRect);
  cxInvalidateRect(Handle, ViewInfo.Bounds);
  Refresh;
end;

procedure TcxCustomEditPopupWindow.ResizePopupWindow(ALeft, ATop, AWidth, AHeight: Integer);
begin
  Edit.FPopupSizeChanged := True;
  SetBounds(ALeft, ATop, AWidth, AHeight);
  RefreshPopupWindow;
  Edit.StorePopupSize;
end;

function TcxCustomEditPopupWindow.GetEdit: TcxCustomDropDownEdit;
begin
  Result := TcxCustomDropDownEdit(OwnerControl);
end;

function TcxCustomEditPopupWindow.GetMinSysPanelHeight: Integer;
begin
  Result := ViewInfo.MinSysPanelHeight;
end;

function TcxCustomEditPopupWindow.GetViewInfo: TcxCustomEditPopupWindowViewInfo;
begin
  Result := TcxCustomEditPopupWindowViewInfo(FViewInfo);
end;

procedure TcxCustomEditPopupWindow.SetPopupAutoSize(Value: Boolean);
begin
  if Value <> FPopupAutoSize then
    FPopupAutoSize := Value;
end;

procedure TcxCustomEditPopupWindow.SetBorderStyle(Value: TcxEditPopupBorderStyle);
begin
  FBorderStyle := Value;
  ViewInfo.BorderStyle := Value;
end;

procedure TcxCustomEditPopupWindow.SetClientEdge(Value: Boolean);
begin
  FClientEdge := Value;
  ViewInfo.ClientEdge := Value;
end;

procedure TcxCustomEditPopupWindow.SetCloseButton(Value: Boolean);
begin
  FCloseButton := Value;
  ViewInfo.ShowCloseButton := Value;
end;

procedure TcxCustomEditPopupWindow.SetMinSysPanelHeight(Value: Integer);
begin
  ViewInfo.MinSysPanelHeight := Value;
end;

procedure TcxCustomEditPopupWindow.SetNativeStyle(Value: Boolean);
begin
  FNativeStyle := Value;
  ViewInfo.NativeStyle := Value;
end;

procedure TcxCustomEditPopupWindow.SetShadow(Value: Boolean);
begin
  FShadow := Value;
  ViewInfo.Shadow := Value;
end;

procedure TcxCustomEditPopupWindow.SetSizeable(Value: Boolean);
begin
  FSizeable := Value;
  ViewInfo.Sizeable := Value;
end;

procedure TcxCustomEditPopupWindow.SetSysPanelStyle(Value: Boolean);
begin
  FSysPanelStyle := Value;
  ViewInfo.SysPanelStyle := Value;
end;

function TcxCustomEditPopupWindow.GetHitTest(const P: TPoint): Integer;
begin
  Result := -1;
  if cxRectPtIn(ViewInfo.CloseButtonRect, P) then
    Result := htCloseButton
  else
    if cxRectPtIn(ViewInfo.SizeGripSizingRect, P) then
      Result := htSizeGrip;
end;

procedure TcxCustomEditPopupWindow.SetCloseButtonState(AState: TcxButtonState);
begin
  if ViewInfo.CloseButtonState <> AState then
  begin
    ViewInfo.CloseButtonState := AState;
    cxInvalidateRect(Handle, ViewInfo.CloseButtonRect);
  end;
end;

procedure TcxCustomEditPopupWindow.UpdateSysPanelState;
begin
  UpdateSysPanelState(ScreenToClient(GetMouseCursorPos), []);
end;

procedure TcxCustomEditPopupWindow.UpdateSysPanelState(const P: TPoint; AShift: TShiftState);
const
  cxEditMouseSizingCursorMap: array[TdxCorner] of TCursor = (crSizeNWSE, crSizeNESW, crSizeNESW, crSizeNWSE);
var
  AHitTest: Integer;
begin
  AHitTest := GetHitTest(P);
  if AHitTest = htCloseButton then
  begin
    if ssLeft in AShift then
      SetCloseButtonState(cxbsPressed)
    else
      SetCloseButtonState(cxbsHot);
  end
  else
    SetCloseButtonState(cxbsNormal);
  if AHitTest = htSizeGrip then
    Cursor := cxEditMouseSizingCursorMap[ViewInfo.SizeGripCorner]
  else
    Cursor := crDefault;
end;

procedure TcxCustomEditPopupWindow.StartResize(const P: TPoint);
begin
  FCapturePoint := P;
  FSizingCapture := True;
  if not ShowContentWhileResize then
    DrawSizeFrame(BoundsRect);
end;

procedure TcxCustomEditPopupWindow.DoResize(const P: TPoint);

  function GetNewBounds(ANewWidth, ANewHeight: Integer): TRect;
  var
    AOwnerRect: TRect;
  begin
    Result := BoundsRect;

    if ViewInfo.SizeGripCorner in [coTopLeft, coBottomLeft] then
      Result.Left := Result.Right - ANewWidth
    else
      Result.Right := Result.Left + ANewWidth;
    if ViewInfo.SizeGripCorner in [coTopLeft, coTopRight] then
      Result.Top := Result.Bottom - ANewHeight
    else
      Result.Bottom := Result.Top + ANewHeight;

    AOwnerRect := OwnerScreenBounds;
    Result.Left := Min(Result.Left, AOwnerRect.Right - 1);
    Result.Right := Max(Result.Right, AOwnerRect.Left + 1);

    cxRectIntersect(Result, Result, GetDesktopWorkArea(ClientToScreen(P)));
  end;

const
  ASignMap: array[Boolean] of Integer = (-1, 1);
var
  ABoundsRect: TRect;
  DX, DY: Integer;
  ANewWidth, ANewHeight: Integer;
begin
  DX := P.X - FCapturePoint.X;
  DY := P.Y - FCapturePoint.Y;

  ANewWidth := cxRectWidth(BoundsRect) - DX * ASignMap[ViewInfo.SizeGripCorner in [coTopLeft, coBottomLeft]];
  ANewHeight := cxRectHeight(BoundsRect) - DY * ASignMap[ViewInfo.SizeGripCorner in [coTopLeft, coTopRight]];

  if CanResize(ANewWidth, ANewHeight) then
    if (ANewWidth <> Width) or (ANewHeight <> Height) then
    begin
      ABoundsRect := GetNewBounds(ANewWidth, ANewHeight);
      if not EqualRect(BoundsRect, ABoundsRect) then
      begin
        if ShowContentWhileResize then
          ResizePopupWindow(ABoundsRect.Left, ABoundsRect.Top, ANewWidth, ANewHeight)
        else
          DrawSizeFrame(ABoundsRect);
      end;
    end;
end;

procedure TcxCustomEditPopupWindow.EndResize(AApply: Boolean);
begin
  SetCaptureControl(nil);
  FSizingCapture := False;
  DrawSizeFrame(cxEmptyRect);
  if not ShowContentWhileResize and AApply then
    ResizePopupWindow(FSizeFrameBounds.Left, FSizeFrameBounds.Top, cxRectWidth(FSizeFrameBounds), cxRectHeight(FSizeFrameBounds));
end;

procedure TcxCustomEditPopupWindow.CMPopupControlKey(var Message: TMessage);
begin
  if IsVisible then
    DoPopupControlKey(Char(Message.WParam));
end;

{ TcxCustomDropDownEditViewData }

procedure TcxCustomDropDownEditViewData.Calculate(ACanvas: TcxCanvas; const ABounds: TRect;
  const P: TPoint; Button: TcxMouseButton; Shift: TShiftState; AViewInfo: TcxCustomEditViewInfo;
  AIsMouseEvent: Boolean);
begin
  KeepArrowButtonPressedWhenDroppedDown := Properties.KeepArrowButtonPressedWhenDroppedDown or NativeStyle and IsWinVistaOrLater;
  inherited Calculate(ACanvas, ABounds, P, Button, Shift, AViewInfo, AIsMouseEvent);
  with TcxCustomTextEditViewInfo(AViewInfo) do
  begin
    DrawSelectionBar := not IsInplace and ((Edit = nil) or
      not((Properties.EditingStyle = esFixedList) and Properties.FixedListSelection and
      TcxCustomDropDownEdit(Edit).FindSelection));
    if DrawSelectionBar then
      DrawSelectionBar := (Properties.EditingStyle = esFixedList) and Focused and
        not Transparent and not HasPopupWindow and not (NativeStyle and IsWinVistaOrLater);
  end;
end;

function TcxCustomDropDownEditViewData.CanPressButton(AViewInfo: TcxCustomEditViewInfo; AButtonVisibleIndex: Integer): Boolean;
begin
  Result := not(IsHotAndPopup and (AButtonVisibleIndex = Properties.DropDownButtonVisibleIndex));
end;

function TcxCustomDropDownEditViewData.GetEditNativeState(AViewInfo: TcxCustomEditViewInfo): Integer;
begin
  Result := inherited GetEditNativeState(AViewInfo);
  if IsWinVistaOrLater and (Properties.EditingStyle = esFixedList) then {totButton}
  begin
    if not Enabled then
      Result := PBS_DISABLED
    else if HasPopupWindow then
      Result := PBS_PRESSED
    else if csHotTrack in ContainerState then
      Result := PBS_HOT
//    else if Focused then
//      Result := PBS_DEFAULTED    // rejected by SNG
    else
      Result := PBS_NORMAL;
  end;
end;

function TcxCustomDropDownEditViewData.IsButtonPressed(
  AViewInfo: TcxCustomEditViewInfo; AButtonVisibleIndex: Integer): Boolean;
begin
  Result := inherited IsButtonPressed(AViewInfo, AButtonVisibleIndex);
  Result := Result or (Edit <> nil) and (HasPopupWindow or IsHotAndPopup) and
    (AButtonVisibleIndex = Properties.DropDownButtonVisibleIndex) and
    KeepArrowButtonPressedWhenDroppedDown;
end;

function TcxCustomDropDownEditViewData.GetProperties: TcxCustomDropDownEditProperties;
begin
  Result := TcxCustomDropDownEditProperties(FProperties);
end;

{ TcxCustomDropDownEditProperties }

constructor TcxCustomDropDownEditProperties.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner);
  FImmediateDropDown := True;
  Buttons.Add;
  Buttons[0].Kind := bkDown;
  FGlyphButtonIndex := DropDownButtonVisibleIndex;
  FPopupDirection := pdVertical;
  FPopupHorzAlignment := pahLeft;
  FPopupVertAlignment := pavBottom;
  FPopupAutoSize := True;
end;

procedure TcxCustomDropDownEditProperties.Assign(Source: TPersistent);
begin
  if Source is TcxCustomDropDownEditProperties then
  begin
    BeginUpdate;
    try
      inherited Assign(Source);
      with Source as TcxCustomDropDownEditProperties do
      begin
        Self.ButtonGlyph := ButtonGlyph;
        Self.ImmediateDropDown := ImmediateDropDown;
        Self.ImmediatePopup := ImmediatePopup;
        Self.KeepArrowButtonPressedWhenDroppedDown := KeepArrowButtonPressedWhenDroppedDown;
        Self.PopupAutoSize := PopupAutoSize;
        Self.PopupClientEdge := PopupClientEdge;
        Self.PopupDirection := PopupDirection;
        Self.PopupHeight := PopupHeight;
        Self.PopupHorzAlignment := PopupHorzAlignment;
        Self.PopupMinHeight := PopupMinHeight;
        Self.PopupMinWidth := PopupMinWidth;
        Self.PopupSizeable := PopupSizeable;
        Self.PopupSysPanelStyle := PopupSysPanelStyle;
        Self.PopupVertAlignment := PopupVertAlignment;
        Self.PopupWidth := PopupWidth;
        Self.PostPopupValueOnTab := PostPopupValueOnTab;

        Self.OnClosePopup := OnClosePopup;
        Self.OnCloseQuery := OnCloseQuery;
        Self.OnCloseUp := OnCloseUp;
        Self.OnInitPopup := OnInitPopup;
        Self.OnPopup := OnPopup;
      end;
    finally
      EndUpdate;
    end
  end
  else
    inherited Assign(Source);
end;

class function TcxCustomDropDownEditProperties.GetContainerClass: TcxContainerClass;
begin
  Result := TcxCustomDropDownEdit;
end;

class function TcxCustomDropDownEditProperties.GetViewDataClass: TcxCustomEditViewDataClass;
begin
  Result := TcxCustomDropDownEditViewData;
end;

function TcxCustomDropDownEditProperties.IsLookupDataVisual: Boolean;
begin
  Result := True;
end;

procedure TcxCustomDropDownEditProperties.DoChanged;
begin
  BeginUpdate;
  try
    if DropDownButtonVisibleIndex < Buttons.VisibleCount then
      with Buttons[DropDownButtonVisibleIndex] do
      begin
        if VerifyBitmap(Glyph) then
          Kind := bkGlyph
        else
          if Kind = bkGlyph then
            Kind := bkDown;
      end;
  finally
    EndUpdate(False);
  end;
  inherited;
end;

function TcxCustomDropDownEditProperties.DropDownButtonVisibleIndex: Integer;
begin
  Result := 0;
end;

function TcxCustomDropDownEditProperties.DropDownOnClick: Boolean;
begin
  Result := False;
end;

function TcxCustomDropDownEditProperties.GetAlwaysPostEditValue: Boolean;
begin
  Result := False;
end;

class function TcxCustomDropDownEditProperties.GetPopupWindowClass: TcxCustomEditPopupWindowClass;
begin
  Result := TcxCustomEditPopupWindow;
end;

function TcxCustomDropDownEditProperties.PopupWindowAcceptsAnySize: Boolean;
begin
  Result := True;
end;

function TcxCustomDropDownEditProperties.PopupWindowCapturesFocus: Boolean;
begin
  Result := False;
end;

function TcxCustomDropDownEditProperties.GetButtonGlyph: TBitmap;
begin
  if GlyphButtonIndex < Buttons.Count then
    Result := Buttons[GlyphButtonIndex].Glyph
  else
    Result := nil;
end;

function TcxCustomDropDownEditProperties.GetPopupAlignment: TAlignment;
const
  AAlignHorzMap: array[TcxPopupAlignHorz] of TAlignment =
    (taLeftJustify, taCenter, taRightJustify);
begin
  Result := AAlignHorzMap[FPopupHorzAlignment];
end;

procedure TcxCustomDropDownEditProperties.SetButtonGlyph(Value: TBitmap);
begin
  if GlyphButtonIndex < Buttons.Count then
    with Buttons[GlyphButtonIndex] do
    begin
      Glyph := Value;
      if VerifyBitmap(Glyph) then
        Kind := bkGlyph
      else
        if Kind = bkGlyph then
          Kind := bkDown;
    end;
end;

procedure TcxCustomDropDownEditProperties.SetGlyphButtonIndex(Value: Integer);
begin
  if Value <> FGlyphButtonIndex then
  begin
    Buttons[Value].Glyph := Buttons[FGlyphButtonIndex].Glyph;
    Buttons[Value].Kind := bkGlyph;
    Buttons[FGlyphButtonIndex].Glyph := nil;
    FGlyphButtonIndex := Value;
  end;
end;

procedure TcxCustomDropDownEditProperties.SetKeepArrowButtonPressedWhenDroppedDown(
  Value: Boolean);
begin
  if Value <> FKeepArrowButtonPressedWhenDroppedDown then
  begin
    FKeepArrowButtonPressedWhenDroppedDown := Value;
    Changed;
  end;
end;

procedure TcxCustomDropDownEditProperties.SetPopupAlignment(Value: TAlignment);
const
  AAlignHorzMap: array[TAlignment] of TcxPopupAlignHorz =
    (pahLeft, pahRight, pahCenter);
begin
  if Value = PopupAlignment then
    Exit;

  FPopupHorzAlignment := AAlignHorzMap[Value];
  Changed;
end;

procedure TcxCustomDropDownEditProperties.SetPopupClientEdge(Value: Boolean);
begin
  if Value = FPopupClientEdge then
    Exit;
  FPopupClientEdge := Value;
  Changed;
end;

procedure TcxCustomDropDownEditProperties.SetPopupHeight(Value: Integer);
begin
  if Value < FPopupMinHeight then
    Value := FPopupMinHeight;
  if FPopupHeight <> Value then
    FPopupHeight := Value;
end;

procedure TcxCustomDropDownEditProperties.SetPopupMinHeight(Value: Integer);
begin
  if Value < 0 then
    Value := 0;
  FPopupMinHeight := Value;
  SetPopupHeight(FPopupHeight);
end;

procedure TcxCustomDropDownEditProperties.SetPopupMinWidth(Value: Integer);
begin
  if Value < 0 then
    Value := 0;
  FPopupMinWidth := Value;
  SetPopupWidth(FPopupWidth);
end;

procedure TcxCustomDropDownEditProperties.SetPopupSizeable(Value: Boolean);
begin
  if Value = FPopupSizeable then
    Exit;
  FPopupSizeable := Value;
  Changed;
end;

procedure TcxCustomDropDownEditProperties.SetPopupSysPanelStyle(Value: Boolean);
begin
  if Value = FPopupSysPanelStyle then
    Exit;
  FPopupSysPanelStyle := Value;
  Changed;
end;

procedure TcxCustomDropDownEditProperties.SetPopupWidth(Value: Integer);
begin
  if Value < 0 then
    Value := 0
  else
    if (Value > 0) and (Value < FPopupMinWidth) then
    Value := FPopupMinWidth;
  if FPopupWidth <> Value then
    FPopupWidth := Value;
end;

{ TcxEditPopupControlLookAndFeel }

procedure TcxEditPopupControlLookAndFeel.EditStyleChanged;
var
  AChangedValues: TcxLookAndFeelValues;
begin
  AChangedValues := [];
  if Kind <> InternalGetKind then
    Include(AChangedValues, lfvKind);
  if NativeStyle <> InternalGetNativeStyle then
    Include(AChangedValues, lfvNativeStyle);
  if SkinName <> InternalGetSkinName then
    Include(AChangedValues, lfvSkinName);
  if AChangedValues <> [] then
    MasterLookAndFeelChanged(Self, AChangedValues);
end;

function TcxEditPopupControlLookAndFeel.InternalGetKind: TcxLookAndFeelKind;
begin
  Result := GetEditPopupWindowControlsLookAndFeelKind(Edit);
end;

function TcxEditPopupControlLookAndFeel.InternalGetNativeStyle: Boolean;
begin
  Result := Edit.ViewInfo.NativeStyle;
end;

function TcxEditPopupControlLookAndFeel.InternalGetSkinName: string;
begin
  Result := Edit.Style.LookAndFeel.SkinName;
end;

function TcxEditPopupControlLookAndFeel.GetEdit: TcxCustomDropDownEdit;
begin
  Result := TcxCustomDropDownEdit(GetOwner);
end;

{ TcxCustomDropDownInnerEdit }

function TcxCustomDropDownInnerEdit.GetContainer: TcxCustomDropDownEdit;
begin
  Result := TcxCustomDropDownEdit(Owner);
end;

procedure TcxCustomDropDownInnerEdit.CMHintShow(var Message: TCMHintShow);
begin
  Message.Result := Integer(Container.DroppedDown);
end;

{ TcxCustomDropDownEdit }

destructor TcxCustomDropDownEdit.Destroy;
begin
  DeleteShowPopupWindowMessages;
  if FPopupWindow <> nil then
    FreeAndNil(FPopupWindow);
  FreeAndNil(FPopupControlsLookAndFeel);
  inherited Destroy;
end;

procedure TcxCustomDropDownEdit.Activate(var AEditData: TcxCustomEditData);
begin
  inherited Activate(AEditData);
  FPopupSizeChanged := TcxCustomDropDownEditData(AEditData).Initialized and
    ActiveProperties.PopupSizeable;
  if ActiveProperties.ImmediatePopup then
    DroppedDown := True;
end;

procedure TcxCustomDropDownEdit.ActivateByKey(Key: Char; var AEditData: TcxCustomEditData);
begin
  inherited ActivateByKey(Key, AEditData);
  if IsTextChar(Key) and ActiveProperties.ImmediateDropDown and
      not ActiveProperties.ImmediatePopup and not SendActivationKey(Key) then
    DroppedDown := True;
  if not SendActivationKey(Key) and CanDropDown and (GetPopupFocusedControl <> nil) then
    PostMessage(PopupWindow.Handle, DXM_POPUPCONTROLKEY, Integer(Key), 0);
end;

procedure TcxCustomDropDownEdit.ActivateByMouse(Shift: TShiftState; X, Y: Integer;
  var AEditData: TcxCustomEditData);
begin
  FIsActivatingByMouse := True;
  try
    inherited ActivateByMouse(Shift, X, Y, AEditData);
  finally
    FIsActivatingByMouse := False;
  end;
end;

procedure TcxCustomDropDownEdit.BeforeDestruction;
begin
  if ILookupData <> nil then
    ILookupData.Deinitialize;
  inherited BeforeDestruction;
end;

function TcxCustomDropDownEdit.Deactivate: Boolean;
begin
  if HasPopupWindow then
    CloseUp(crUnknown);
  if EditData <> nil then
    TcxCustomDropDownEditData(EditData).Initialized := FPopupSizeChanged;
  Result := inherited Deactivate;
  DeleteShowPopupWindowMessages;
end;

function TcxCustomDropDownEdit.Focused: Boolean;
begin
  Result := inherited Focused or HasPopupWindow;
end;

class function TcxCustomDropDownEdit.GetPropertiesClass: TcxCustomEditPropertiesClass;
begin
  Result := TcxCustomDropDownEditProperties;
end;

procedure TcxCustomDropDownEdit.ContainerStyleChanged(Sender: TObject);
begin
  if HandleAllocated and (FPopupControlsLookAndFeel <> nil) then
    FPopupControlsLookAndFeel.EditStyleChanged;
  inherited ContainerStyleChanged(Sender);
end;

function TcxCustomDropDownEdit.CreateViewData: TcxCustomEditViewData;
begin
  Result := inherited CreateViewData;
  with Result as TcxCustomDropDownEditViewData do
  begin
    HasPopupWindow := Self.HasPopupWindow;
    IsHotAndPopup := FIsHotAndPopup;
  end;
end;

procedure TcxCustomDropDownEdit.DestroyWnd;
begin
  if FPopupWindow <> nil then
  begin
    CloseUp(crUnknown);
    DoFinalizePopup;
    FPopupWindow.DestroyHandle;
  end;
  inherited DestroyWnd;
end;

procedure TcxCustomDropDownEdit.DoButtonDown(AButtonVisibleIndex: Integer);
begin
  inherited DoButtonDown(AButtonVisibleIndex);
  if AButtonVisibleIndex = ActiveProperties.DropDownButtonVisibleIndex then
    DroppedDown := True;
end;

procedure TcxCustomDropDownEdit.DoExit;
begin
  CloseUp(crUnknown);
  FocusChanged;
  inherited DoExit;
end;

procedure TcxCustomDropDownEdit.DoEditKeyDown(var Key: Word; Shift: TShiftState);
var
  AKey: Word;
begin
  AKey := TranslateKey(Key);
  if (((AKey = VK_UP) or (AKey = VK_DOWN)) and (ssAlt in Shift)) or
      ((AKey = VK_F4) and not (ssAlt in Shift)) then
    if HasPopupWindow then
    begin
      CloseUp(crClose);
      Key := 0;
    end else
    begin
      DroppedDown := True;
      Key := 0;
    end
  else
    if ((AKey = VK_RETURN) or (AKey = VK_ESCAPE)) and not(ssAlt in Shift) and HasPopupWindow then
    begin
      FIsPopupWindowJustClosed := True;
      KeyboardAction := True;
      if (AKey = VK_RETURN) and DoEditing then
        CloseUp(crEnter)
      else
        CloseUp(crCancel);
      KeyboardAction := False;
      if not HasPopupWindow then
      begin
//        if not(ActiveProperties.UseLookupData and not ILookupData.Find(DisplayValue)) then // TODO
          Key := 0;
        if AKey = VK_ESCAPE then
          SetCaptureControl(nil);
      end;
    end;
  if Key <> 0 then
    inherited DoEditKeyDown(Key, Shift);
end;

procedure TcxCustomDropDownEdit.DoEditKeyPress(var Key: Char);
begin
  if IsTextChar(Key) and ActiveProperties.ImmediateDropDown and
    not HasPopupWindow then
  begin
    DroppedDown := True;

    if ActiveProperties.PopupWindowCapturesFocus and (TranslateKey(Word(Key)) <> VK_RETURN) and
      CanDropDown and (GetPopupFocusedControl <> nil) then
    begin
      PostMessage(PopupWindow.Handle, DXM_POPUPCONTROLKEY, Integer(Key), 0);
      Key := #0;
    end;
  end;
  if Key <> #0 then
    inherited DoEditKeyPress(Key);
end;

procedure TcxCustomDropDownEdit.DoEditProcessTab(Shift: TShiftState);
begin
  if HasPopupWindow and ActiveProperties.PostPopupValueOnTab then
    CloseUp(crTab);
  inherited DoEditProcessTab(Shift);
end;

function TcxCustomDropDownEdit.DoMouseWheel(Shift: TShiftState; WheelDelta: Integer;
   MousePos: TPoint): Boolean;
begin
  Result := inherited DoMouseWheel(Shift, WheelDelta, MousePos);
  if Result then
    Exit;
  if GetScrollLookupDataList(escMouseWheel) and HasPopupWindow and
      ActiveProperties.UseLookupData and not ILookupData.IsEmpty then
    with ILookupData do
    begin
      Result := True;
{$IFDEF DELPHI6}
      if GetActiveControl is TControl then
        TControlAccess(ActiveControl).DoMouseWheel(Shift, WheelDelta, MousePos)
{$ELSE}
      if GetActiveControl is TWinControl then
        TWinControlAccess(ActiveControl).DoMouseWheel(Shift, WheelDelta, MousePos)
{$ENDIF}
    end;
end;

procedure TcxCustomDropDownEdit.FocusChanged;
begin
  if not ActiveProperties.PopupWindowCapturesFocus and not InnerControl.Focused then
    CloseUp(crUnknown);
  inherited FocusChanged;
end;

function TcxCustomDropDownEdit.GetEditDataClass: TcxCustomEditDataClass;
begin
  Result := TcxCustomDropDownEditData;
end;

function TcxCustomDropDownEdit.GetInnerEditClass: TControlClass;
begin
  Result := TcxCustomDropDownInnerEdit;
end;

function TcxCustomDropDownEdit.GetScrollLookupDataList(AScrollCause: TcxEditScrollCause): Boolean;
begin
  Result := not PropertiesChangeLocked and (not IsInplace or
    (AScrollCause = escMouseWheel) or not InplaceParams.MultiRowParent or HasPopupWindow);
end;

procedure TcxCustomDropDownEdit.Initialize;
begin
  inherited Initialize;
  if not IsDesigning then
    CreatePopupWindow;
  FSendChildrenStyle := True;
  FPopupControlsLookAndFeel := TcxEditPopupControlLookAndFeel.Create(Self);
  FPopupControlsLookAndFeel.OnChanged := PopupControlsLookAndFeelChanged;
end;

procedure TcxCustomDropDownEdit.InitializeEditData;
begin
  with TcxCustomDropDownEditData(EditData) do
  begin
    Initialized := False;
    Width := ActiveProperties.PopupWidth;
    Height := ActiveProperties.PopupHeight;
  end;
end;

function TcxCustomDropDownEdit.InternalGetNotPublishedStyleValues: TcxEditStyleValues;
begin
  Result := inherited InternalGetNotPublishedStyleValues -
    [svButtonStyle, svButtonTransparency, svGradientButtons, svPopupBorderStyle];
end;

function TcxCustomDropDownEdit.IsEditorKey(Key: Word; Shift: TShiftState): Boolean;
begin
  Result := inherited IsEditorKey(Key, Shift) or IsInplace and HasPopupWindow and
    ((Shift * [ssAlt, ssCtrl] <> []) or IsSysKey(Key));
end;

procedure TcxCustomDropDownEdit.PropertiesChanged(Sender: TObject);
begin
  if not ActiveProperties.PopupSizeable then
    FPopupSizeChanged := False;
  if HasPopupWindow then
    SetupPopupWindow;
  inherited PropertiesChanged(Sender);
end;

function TcxCustomDropDownEdit.HasPopupWindow: Boolean;
begin
  Result := (PopupWindow <> nil) and PopupWindow.IsVisible;
end;

procedure TcxCustomDropDownEdit.PasteFromClipboard;
var
  APrevKeyboardAction: Boolean;
  APrevText: string;
begin
  if Focused then
  begin
    APrevKeyboardAction := KeyboardAction;
    KeyboardAction := True;
    try
      APrevText := InnerTextEdit.EditValue;
      inherited PasteFromClipboard;
      if not InternalCompareString(APrevText, InnerTextEdit.EditValue, True) and
        ActiveProperties.ImmediateDropDown and not HasPopupWindow then
      begin
        DroppedDown := True;
        if ActiveProperties.UseLookupData then
          PostMessage(Handle, DXM_DROPDOWNBYPASTE, 0, 0);
      end;
    finally
      KeyboardAction := APrevKeyboardAction;
    end;
  end
  else
    inherited PasteFromClipboard;
end;

function TcxCustomDropDownEdit.CanHide: Boolean;
begin
  Result := True;
end;

procedure TcxCustomDropDownEdit.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited MouseDown(Button, Shift, X, Y);
  if not FIsActivatingByMouse and ActiveProperties.DropDownOnClick and (Button = mbLeft) and
      PtInRect(ViewInfo.ClientRect, Point(X, Y)) and not HasPopupWindow and
      not FIsHotAndPopup and IsFocused then
    DroppedDown := True;
end;

function TcxCustomDropDownEdit.DoRefreshContainer(const P: TPoint; Button: TcxMouseButton;
  Shift: TShiftState; AIsMouseEvent: Boolean): Boolean;
begin
  Result := inherited DoRefreshContainer(P, Button, Shift, AIsMouseEvent);
  if HasPopupWindow then
    with ViewInfo do
      if IsButtonReallyPressed and (PressedButton = -1) then
        CloseUp(crUnknown);
  if AIsMouseEvent and not((Button = cxmbLeft) and (cxButtonToShift(Button) * Shift <> [])) then
    SetIsHotAndPopup;
  if FPopupControlsLookAndFeel <> nil then
    FPopupControlsLookAndFeel.EditStyleChanged;
end;

function TcxCustomDropDownEdit.SendActivationKey(Key: Char): Boolean;
begin
  Result := not(ActiveProperties.ImmediateDropDown and ActiveProperties.PopupWindowCapturesFocus and
    (TranslateKey(Word(Key)) <> VK_RETURN));
end;

function TcxCustomDropDownEdit.TabsNeeded: Boolean;
begin
  Result := inherited TabsNeeded or
    HasPopupWindow and ActiveProperties.PostPopupValueOnTab;
end;

procedure TcxCustomDropDownEdit.CreateHandle;
begin
  inherited CreateHandle;
  InitializeLookupData;
end;

procedure TcxCustomDropDownEdit.DoStartDock(var DragObject: TDragObject);
begin
  CloseUp(crUnknown);
  inherited DoStartDock(DragObject);
end;

function TcxCustomDropDownEdit.CanDropDown: Boolean;
begin
  Result := False;
end;

procedure TcxCustomDropDownEdit.CloseUp(AReason: TcxEditCloseUpReason);
var
  APrevLookupKey: TcxEditValue;
begin
  if not HasPopupWindow then
    Exit;

  if FCloseUpReason = crUnknown then
    FCloseUpReason := AReason;
  LockChangeEvents(True);
  try
    if AReason in [crTab, crEnter, crClose] then
    begin
      if ActiveProperties.UseLookupData then
      begin
        APrevLookupKey := ILookupData.CurrentKey;
        LockClick(True);
        try
          ILookupData.SelectItem;
        finally
          LockClick(False);
          if ModifiedAfterEnter and not VarEqualsExact(APrevLookupKey, ILookupData.CurrentKey) then
            DoClick;
        end;
      end;
      if not ActiveProperties.AlwaysPostEditValue and ActiveProperties.ImmediatePost and
        CanPostEditValue then
          InternalPostEditValue(True);
    end;
  finally
    LockChangeEvents(False);
  end;
  PopupWindow.CloseUp;
end;

procedure TcxCustomDropDownEdit.CreatePopupWindow;
begin
  with ActiveProperties do
    FPopupWindow := GetPopupWindowClass.Create(Self);
  FPopupWindow.CaptureFocus := ActiveProperties.PopupWindowCapturesFocus;
  FPopupWindow.IsTopMost := not IsInplace;
  FPopupWindow.Style.LookAndFeel.MasterLookAndFeel := Style.LookAndFeel;
  FPopupWindow.BiDiMode := BiDiMode;
  FPopupWindow.OnCloseQuery := PopupWindowCloseQuery;
  FPopupWindow.OnClosed := PopupWindowClosed;
  FPopupWindow.OnClosing := PopupWindowClosing;
  FPopupWindow.OnShowed := PopupWindowShowed;
  FPopupWindow.OnShowing := PopupWindowShowing;
end;

procedure TcxCustomDropDownEdit.DeleteShowPopupWindowMessages;
begin
  if (PopupWindow <> nil) and PopupWindow.HandleAllocated and
    KillMessages(PopupWindow.Handle, DXM_SHOWPOPUPWINDOW, DXM_SHOWPOPUPWINDOW) then
      PopupWindowClosed(PopupWindow);
end;

procedure TcxCustomDropDownEdit.DoCloseQuery(var CanClose: Boolean);
begin
  with Properties do
    if Assigned(OnCloseQuery) then
      OnCloseQuery(Self, CanClose);
  if RepositoryItem <> nil then
    with ActiveProperties do
      if Assigned(OnCloseQuery) then
        OnCloseQuery(Self, CanClose);
end;

procedure TcxCustomDropDownEdit.DoCloseUp;
begin
  DoClosePopup(FCloseUpReason);
  with Properties do
    if Assigned(OnCloseUp) then
      OnCloseUp(Self);
  if RepositoryItem <> nil then
    with ActiveProperties do
      if Assigned(OnCloseUp) then
        OnCloseUp(Self);
end;

procedure TcxCustomDropDownEdit.DoFinalizePopup;
begin
  if not FPopupInitialized then
    Exit;
  FPopupInitialized := False;

  if ActiveProperties.UseLookupData then
    ILookupData.CloseUp;

  if Assigned(Properties.OnFinalizePopup) then
    Properties.OnFinalizePopup(Self);
  if (RepositoryItem <> nil) and Assigned(ActiveProperties.OnFinalizePopup) then
    ActiveProperties.OnFinalizePopup(Self);
end;

procedure TcxCustomDropDownEdit.DoInitPopup;
begin
  if FPopupInitialized then
    Exit;
  FPopupInitialized := True;
  try
    with Properties do
      if Assigned(OnInitPopup) then
        OnInitPopup(Self);
    if RepositoryItem <> nil then
      with ActiveProperties do
        if Assigned(OnInitPopup) then
          OnInitPopup(Self);
  except
    FPopupInitialized := False;
    raise;
  end;
  if ActiveProperties.UseLookupData then
    ILookupData.DropDown;
end;

procedure TcxCustomDropDownEdit.DoPopup;
begin
  FCloseUpReason := crUnknown;
  with Properties do
    if Assigned(OnPopup) then
      OnPopup(Self);
  if RepositoryItem <> nil then
    with ActiveProperties do
      if Assigned(OnPopup) then
        OnPopup(Self);
end;

procedure TcxCustomDropDownEdit.SetupPopupWindow;
var
  P: TPoint;
  {$IFDEF DELPHI6}
  AParentForm: TCustomForm;
  {$ENDIF}
begin
  PopupWindow.CaptureFocus := ActiveProperties.PopupWindowCapturesFocus;
  InitializeLookupData;
  InitializePopupWindow;
  PopupWindow.FLockCheckSize := True;
  try
    PopupWindow.CalculateSize;
    P := PopupWindow.CalculatePosition;
    PopupWindow.CorrectBoundsWithDesktopWorkArea(P);
  finally
    PopupWindow.FLockCheckSize := False;
  end;
  PopupWindow.SetBounds(P.X, P.Y, PopupWindow.Width, PopupWindow.Height);
  PopupWindow.RefreshPopupWindow;
  PositionPopupWindowChilds(PopupWindow.ViewInfo.ClientRect);
  SetEditPopupWindowShadowRegion(PopupWindow);

  {$IFDEF DELPHI6}
  if IsWinXPOrLater then // W2K bug
  begin
    AParentForm := GetParentForm(Self);
    if AParentForm <> nil then
    begin
      PopupWindow.AlphaBlend := TCustomFormAccess(AParentForm).AlphaBlend;
      PopupWindow.AlphaBlendValue := TCustomFormAccess(AParentForm).AlphaBlendValue;
      PopupWindow.TransparentColor := TCustomFormAccess(AParentForm).TransparentColor;
      PopupWindow.TransparentColorValue := TCustomFormAccess(AParentForm).TransparentColorValue;
    end;
  end;
  {$ENDIF}
end;

procedure TcxCustomDropDownEdit.StorePopupSize;
begin
  if ActiveProperties.PopupSizeable then
    if IsInplace then
    begin
      if EditData <> nil then
        with TcxCustomDropDownEditData(EditData) do
        begin
          Initialized := True;
          Width := PopupWindow.Width;
          Height := PopupWindow.Height;
        end
    end else
    begin
      with ActiveProperties do
      begin
        PopupWidth := PopupWindow.Width;
        PopupHeight := PopupWindow.Height;
      end;
    end;
end;

procedure TcxCustomDropDownEdit.UpdatePopupWindow;
begin
  if HasPopupWindow then
    SetupPopupWindow;
end;

procedure TcxCustomDropDownEdit.DropDown;
begin
  if not IsWindowVisible(Handle) then
    Exit;
  DoInitPopup;
  if CanDropDown then
  begin
    SetupPopupWindow;
    PopupWindow.HandleNeeded;
    PopupWindow.FocusedControl := GetPopupFocusedControl;
    PostMessage(PopupWindow.Handle, DXM_SHOWPOPUPWINDOW, 0, 0);
  end
  else
    DoFinalizePopup;
end;

procedure TcxCustomDropDownEdit.EditButtonClick;
begin
end;

function TcxCustomDropDownEdit.GetPopupFocusedControl: TWinControl;
var
  AActiveControl: TControl;
begin
  Result := InnerTextEdit.Control;
  with ActiveProperties do
    if (ILookupData <> nil) and IsLookupDataVisual and PopupWindowCapturesFocus then
    begin
      AActiveControl := ILookupData.ActiveControl;
      if (AActiveControl <> nil) and (AActiveControl is TWinControl) then
        Result := TWinControl(AActiveControl);
    end;
end;

function TcxCustomDropDownEdit.GetPopupWindowOwnerControlBounds: TRect;
begin
  if IsInplace and not IsRectEmpty(ContentParams.ExternalBorderBounds) then
    Result := ContentParams.ExternalBorderBounds
  else
    Result := VisibleBounds;
  if ViewInfo.Shadow then
    Inc(Result.Right, cxEditShadowWidth);
  OffsetRect(Result, Left, Top);
end;

procedure TcxCustomDropDownEdit.InitializeLookupData;
begin
  with ActiveProperties do
    if (ILookupData <> nil) and not IsDesigning and IsLookupDataVisual then
      ILookupData.Initialize(PopupWindow);
end;

procedure TcxCustomDropDownEdit.InitializePopupWindow;
begin
  PopupWindow.OwnerParent := Parent;
  with ActiveProperties do
  begin
    PopupWindow.Direction := PopupDirection;
    PopupWindow.AlignHorz := PopupHorzAlignment;
    PopupWindow.AlignVert := PopupVertAlignment;
    PopupWindow.ClientEdge := PopupClientEdge;
    PopupWindow.MinHeight := PopupMinHeight;
    PopupWindow.MinWidth := PopupMinWidth;
    PopupWindow.PopupAutoSize := PopupAutoSize;
    PopupWindow.Sizeable := PopupSizeable;
    PopupWindow.SysPanelStyle := PopupSysPanelStyle;
  end;

  if IsInplace and ActiveProperties.PopupSizeable then
    with TcxCustomDropDownEditData(EditData) do
    begin
      PopupWindow.PopupWidth := Width;
      PopupWindow.PopupHeight := Height;
    end
  else
  begin
    PopupWindow.PopupWidth := ActiveProperties.PopupWidth;
    PopupWindow.PopupHeight := ActiveProperties.PopupHeight;
  end;

  PopupWindow.CloseButton := TcxCustomEditStyleAccess(ActiveStyle).PopupCloseButton;

  with ViewInfo do
  begin
    PopupWindow.BorderStyle := PopupBorderStyle;
    PopupWindow.NativeStyle := NativeStyle;
    PopupWindow.Shadow := Shadow;
  end;
end;

procedure TcxCustomDropDownEdit.PopupControlsLookAndFeelChanged(
  Sender: TcxLookAndFeel; AChangedValues: TcxLookAndFeelValues);
begin
end;

procedure TcxCustomDropDownEdit.PopupWindowClosed(Sender: TObject);
begin
  DoFinalizePopup;

  if ActiveProperties.EditingStyle = esFixedList then
    ShortRefreshContainer(False);
  DoCloseUp;
  LockChangeEvents(True);
  try
    if ActiveProperties.AlwaysPostEditValue and ActiveProperties.ImmediatePost and
      CanPostEditValue and ValidateEdit(True) then
        InternalPostEditValue;
  finally
    LockChangeEvents(False);
  end;

  ShortRefreshContainer(False);
  if not HandleAllocated then
    SetIsHotAndPopup; // perform if VK_ESC was pressed and WM_MOUSEMOVE didn't occur
end;

procedure TcxCustomDropDownEdit.PopupWindowCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  DoCloseQuery(CanClose);
end;

procedure TcxCustomDropDownEdit.PopupWindowClosing(Sender: TObject);
begin
end;

procedure TcxCustomDropDownEdit.PopupWindowShowing(Sender: TObject);
begin
end;

procedure TcxCustomDropDownEdit.PopupWindowShowed(Sender: TObject);
begin
  ShortRefreshContainer(False);
  PopupWindow.CalculateViewInfo;
  PositionPopupWindowChilds(PopupWindow.ViewInfo.ClientRect);
  DoPopup;
  UpdateDrawValue;
  with ActiveProperties do
    if UseLookupData and FindSelection and ImmediateDropDown and
        PopupWindowCapturesFocus then
      ILookupData.DroppedDown(Copy(DisplayValue, 1, SelStart));
end;

procedure TcxCustomDropDownEdit.PositionPopupWindowChilds(const AClientRect: TRect);
begin
  ILookupData.PositionVisualArea(AClientRect);
end;

procedure TcxCustomDropDownEdit.SetIsHotAndPopup;
begin
  FIsHotAndPopup := HasPopupWindow and (csHotTrack in ViewInfo.ContainerState);
end;

procedure TcxCustomDropDownEdit.DropDownByPasteHandler;
var
  APrevLookupKey: TcxEditValue;
begin
  if not HasPopupWindow then
    Exit;

  APrevLookupKey := ILookupData.CurrentKey;
  LockClick(True);
  try
    ILookupData.TextChanged;
  finally
    LockClick(False);
    if not VarEqualsExact(APrevLookupKey, ILookupData.CurrentKey) then
      DoClick;
  end;

  case ActiveProperties.EditingStyle of
    esFixedList:
      FindSelection := True;
    esEdit:
      FindSelection := (SelStart = Length(Text)) and ILookupData.Find(Text);
  end;
end;

function TcxCustomDropDownEdit.GetDroppedDown: Boolean;
begin
  Result := HasPopupWindow;
end;

function TcxCustomDropDownEdit.GetProperties: TcxCustomDropDownEditProperties;
begin
  Result := TcxCustomDropDownEditProperties(FProperties);
end;

function TcxCustomDropDownEdit.GetActiveProperties: TcxCustomDropDownEditProperties;
begin
  Result := TcxCustomDropDownEditProperties(InternalGetActiveProperties);
end;

procedure TcxCustomDropDownEdit.SetDroppedDown(Value: Boolean);
var
  AMsg: TMsg;
begin
  if DroppedDown <> Value then
    if not Value then
      CloseUp(crUnknown)
    else
      if not PeekMessage(AMsg, PopupWindow.Handle, DXM_SHOWPOPUPWINDOW, DXM_SHOWPOPUPWINDOW, PM_NOREMOVE) then
        DropDown;
end;

procedure TcxCustomDropDownEdit.SetProperties(Value: TcxCustomDropDownEditProperties);
begin
  FProperties.Assign(Value);
end;

procedure TcxCustomDropDownEdit.CMBiDiModeChanged(var Message: TMessage);
begin
  inherited;
  if PopupWindow <> nil then
    PopupWindow.BiDiMode := BiDiMode;
end;

procedure TcxCustomDropDownEdit.CMDropDownByPaste(var Message: TMessage);
begin
  DropDownByPasteHandler;
end;

procedure TcxCustomDropDownEdit.CMHintShow(var Message: TCMHintShow);
begin
  inherited;
  Message.Result := Message.Result + Integer(DroppedDown);
end;

{ TcxFilterDropDownEditHelper }

class function TcxFilterDropDownEditHelper.EditPropertiesHasButtons: Boolean;
begin
  Result := True;
end;

{ TcxComboBoxPopupWindow }

procedure TcxComboBoxPopupWindow.CalculateSize;
var
  AClientExtent: TRect;
  AMinSize: TSize;
  APreferredWidth, APreferredHeight: Integer;
  APopupWindowVisualAreaSize: TSize;
  ASizeChanged: Boolean;
begin
  ViewInfo.SizeGripCorner := coBottomRight;
  OwnerBounds := Edit.GetPopupWindowOwnerControlBounds;
  AClientExtent := ViewInfo.GetClientExtent;
  AMinSize := MinSize;
  APopupWindowVisualAreaSize := Edit.GetPopupWindowClientPreferredSize;
  ASizeChanged := Edit.FPopupSizeChanged;
  if Sizeable and ASizeChanged or not PopupAutoSize and (PopupWidth > 0) then
    APreferredWidth := PopupWidth
  else
    if PopupAutoSize then
    begin
      APreferredWidth := APopupWindowVisualAreaSize.cx + AClientExtent.Left + AClientExtent.Right;
      APreferredWidth := Max(APreferredWidth, cxRectWidth(OwnerBounds));
    end
    else
      APreferredWidth := cxRectWidth(OwnerBounds);

  if not(Sizeable and ASizeChanged) and (PopupHeight = 0) or
    not Sizeable and PopupAutoSize then
      APreferredHeight := APopupWindowVisualAreaSize.cy + AClientExtent.Top +
        AClientExtent.Bottom
  else
    APreferredHeight := PopupHeight;

  if Sizeable then
  begin
    APreferredWidth := Max(APreferredWidth, MinWidth);
    APreferredHeight := Max(APreferredHeight, MinHeight);
  end;
  APreferredWidth := Max(APreferredWidth, AMinSize.cx);
  APreferredHeight := Max(APreferredHeight, AMinSize.cy);

  Width := APreferredWidth;
  Height := APreferredHeight;
end;

{ TcxCustomComboBoxListBox }

constructor TcxCustomComboBoxListBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Style := lbOwnerDrawVariable;
end;

function TcxCustomComboBoxListBox.GetHeight(ARowCount: Integer; AMaxHeight: Integer): Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to ARowCount - 1 do
    Inc(Result, GetItemHeight(I));
end;

procedure TcxCustomComboBoxListBox.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  if Edit.IsOnDrawItemEventAssigned then
    with Params.WindowClass do
      style := style or CS_HREDRAW;
end;

function TcxCustomComboBoxListBox.DoDrawItem(AIndex: Integer; const ARect: TRect;
  AState: TOwnerDrawState): Boolean;
begin
  Result := Edit.IsOnDrawItemEventAssigned;
  if Result then
    Edit.DoOnDrawItem(Canvas, AIndex, ARect, AState);
end;

function TcxCustomComboBoxListBox.GetItem(Index: Integer): string;
begin
  Result := Edit.LookupData.GetItem(Index);
end;

procedure TcxCustomComboBoxListBox.MeasureItem(Index: Integer; var Height: Integer);
begin
  Height := GetItemHeight(Index);
end;

procedure TcxCustomComboBoxListBox.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  if (Edit <> nil) and Edit.PopupMouseMoveLocked then
    Edit.PopupMouseMoveLocked := False
  else
    inherited MouseMove(Shift, X, Y);
end;

procedure TcxCustomComboBoxListBox.RecreateWindow;
begin
  InternalRecreateWindow;
end;

function TcxCustomComboBoxListBox.GetEdit: TcxCustomComboBox;
begin
  Result := TcxCustomComboBox(inherited Edit);
end;

{ TcxComboBoxListBox }

function TcxComboBoxListBox.GetItemHeight(AIndex: Integer = -1): Integer;
begin
  if Edit.ActiveProperties.ItemHeight > 0 then
    Result := Edit.ActiveProperties.ItemHeight
  else
    Result := inherited GetItemHeight;
  if (AIndex >= 0) and Edit.IsOnMeasureItemEventAssigned then
    Edit.DoOnMeasureItem(AIndex, Canvas, Result);
end;

procedure TcxComboBoxListBox.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var
  AItemIndex: Integer;
begin
  inherited MouseUp(Button, Shift, X, Y);
  if Button <> mbLeft then
    Exit;
  AItemIndex := ItemAtPos(Point(X, Y), True);
  if AItemIndex <> -1 then
  begin
    SetCaptureControl(nil);
    ItemIndex := AItemIndex;
    Edit.CloseUp(crEnter);
  end;
end;

procedure TcxComboBoxListBox.RecreateWindow;
begin
  ItemHeight := GetItemHeight;
  if Edit.IsOnMeasureItemEventAssigned then
    Style := lbOwnerDrawVariable
  else
    Style := lbOwnerDrawFixed;
end;

procedure TcxComboBoxListBox.SetItemIndex(const Value: Integer);
begin
  Edit.PopupMouseMoveLocked := True;
  inherited SetItemIndex(Value);
end;

procedure TcxComboBoxListBox.Resize;
var
  ARgn: HRGN;
begin
  if not Edit.HasPopupWindow then
    Exit;
  if HScrollBar.Visible and VScrollBar.Visible then
  begin
    ARgn := CreateRectRgnIndirect(GetSizeGripRect);
    SendMessage(Handle, WM_NCPAINT, ARgn, 0);
    DeleteObject(ARgn);
  end;
end;

{ TcxComboBoxLookupData }

function TcxComboBoxLookupData.CanResizeVisualArea(var NewSize: TSize;
  AMaxHeight: Integer = 0; AMaxWidth: Integer = 0): Boolean;
var
  I: Integer;
  AItemCount: Integer;
  AItemHeight: Integer;
  AListClientSize, AListSize: TSize;
  AMinWidth: Integer;
  AScrollBarSize: TSize;
  AVScrollBar: Boolean;
begin
  Result := True;
  if (NewSize.cx = List.Width) and (NewSize.cy = List.Height) then
    Exit;
  if AMaxHeight = 0 then
    AMaxHeight := MaxInt;
  if AMaxWidth = 0 then
    AMaxWidth := MaxInt;
  AItemCount := GetItemCount;
  AListClientSize.cy := 0;
  AScrollBarSize := GetScrollBarSize;
  AVScrollBar := False;
  for I := 0 to AItemCount - 1 do
  begin
    AItemHeight := List.GetItemHeight(I);
    AListClientSize.cy := AListClientSize.cy + AItemHeight;
    AListSize.cy := AListClientSize.cy;
    AListClientSize.cx := NewSize.cx;
    AVScrollBar := I < AItemCount - 1;
    if AVScrollBar then
      AListClientSize.cx := AListClientSize.cx - AScrollBarSize.cx;
    if (AListClientSize.cx < List.ScrollWidth) or (AListClientSize.cx > AMaxWidth) then
      AListSize.cy := AListSize.cy + AScrollBarSize.cy;
    if (AListSize.cy = NewSize.cy) and not (AListSize.cy > AMaxHeight) then
      Break;
    if (AListSize.cy > NewSize.cy) or (AListSize.cy > AMaxHeight) then
      if (AListSize.cy > AMaxHeight) or (NewSize.cy >= List.Height) then
      begin
        AListClientSize.cy := AListClientSize.cy - AItemHeight;
        AListSize.cy := AListClientSize.cy;
        AListClientSize.cx := NewSize.cx;
        AVScrollBar := I < AItemCount;
        if AVScrollBar then
          AListClientSize.cx := AListClientSize.cx - AScrollBarSize.cx;
        if (AListClientSize.cx < List.ScrollWidth) or (AListClientSize.cx > AMaxWidth) then
          AListSize.cy := AListSize.cy + AScrollBarSize.cy;
        Break;
      end
      else
        if NewSize.cy < List.Height then
          Break;
  end;
  NewSize.cy := AListSize.cy;
  AMinWidth := 0;
  if AVScrollBar then
    Inc(AMinWidth, AScrollBarSize.cx);
  if AListSize.cy > AListClientSize.cy then
    Inc(AMinWidth, AScrollBarSize.cx);
  NewSize.cx := Max(NewSize.cx, AMinWidth);
end;

function TcxComboBoxLookupData.GetVisualAreaPreferredSize(AMaxHeight: Integer;
  AWidth: Integer = 0): TSize;
var
  AItemWidth: Integer;
  AListRowCount, I: Integer;
begin
  AListRowCount := GetItemCount;
  with TcxCustomComboBoxProperties(ActiveProperties) do
    if AListRowCount > DropDownRows then
      AListRowCount := DropDownRows;
  Result.cy := List.GetHeight(AListRowCount, AMaxHeight);
  Result.cx := 0;
  for I := 0 to GetItemCount - 1 do
  begin
    AItemWidth := List.GetItemWidth(I);
    if AItemWidth > Result.cx then
      Result.cx := AItemWidth;
  end;
  Result.cx := Result.cx + 4;
  List.SetScrollWidth(Result.cx);
  with TcxCustomComboBoxProperties(ActiveProperties) do
    if (GetItemCount > DropDownRows) or (AMaxHeight > 0) and (Result.cy > AMaxHeight) then
      Result.cx := Result.cx + GetScrollBarSize.cx;
  if (AWidth > 0) and (Result.cx > AWidth) then
    Result.cy := Result.cy + GetScrollBarSize.cy;
end;

procedure TcxComboBoxLookupData.Initialize(AVisualControlsParent: TWinControl);
begin
  inherited Initialize(AVisualControlsParent);
  List.LookAndFeel.MasterLookAndFeel :=
    TcxCustomDropDownEdit(Edit).PopupControlsLookAndFeel;
end;

function TcxComboBoxLookupData.GetListBoxClass: TcxCustomEditListBoxClass;
begin
  Result := TcxComboBoxListBox;
end;

{ TcxCustomComboBoxViewData }

procedure TcxCustomComboBoxViewData.Calculate(ACanvas: TcxCanvas;
  const ABounds: TRect; const P: TPoint; Button: TcxMouseButton;
  Shift: TShiftState; AViewInfo: TcxCustomEditViewInfo; AIsMouseEvent: Boolean);
var
  AItemIndex: Integer;
begin
  inherited Calculate(ACanvas, ABounds, P, Button, Shift, AViewInfo,
    AIsMouseEvent);

  if (Properties.DropDownListStyle = lsFixedList) and Assigned(Edit) and
    TcxCustomComboBox(Edit).IsOnDrawItemEventAssigned then
      AItemIndex := TcxCustomComboBox(Edit).ItemIndex
  else
    AItemIndex := -1;

  with TcxCustomComboBoxViewInfo(AViewInfo) do
  begin
    ItemIndex := AItemIndex;
    IsOwnerDrawing := ItemIndex <> -1;
  end;
end;

procedure TcxCustomComboBoxViewData.EditValueToDrawValue(ACanvas: TcxCanvas;
  const AEditValue: TcxEditValue; AViewInfo: TcxCustomEditViewInfo);
begin
  inherited EditValueToDrawValue(ACanvas, AEditValue, AViewInfo);
  with TcxCustomComboBoxViewInfo(AViewInfo) do
  begin
    if (Properties.DropDownListStyle = lsFixedList) and Assigned(Properties.OnDrawItem) then
      ItemIndex := Properties.LookupItems.IndexOf(VarToStr(AEditValue))
    else
      ItemIndex := -1;
    IsOwnerDrawing := ItemIndex <> -1;
  end;
end;

function TcxCustomComboBoxViewData.IsComboBoxStyle: Boolean;
begin
  Result := True;
end;

function TcxCustomComboBoxViewData.GetProperties: TcxCustomComboBoxProperties;
begin
  Result := TcxCustomComboBoxProperties(FProperties);
end;

{ TcxCustomComboBoxViewInfo }

constructor TcxCustomComboBoxViewInfo.Create;
begin
  inherited Create;
  CustomDrawHandler := DoCustomDraw;
end;

procedure TcxCustomComboBoxViewInfo.DoCustomDraw(ACanvas: TcxCanvas; ARect: TRect);
var
  AState: TOwnerDrawState;
  ATextColor: TColor;
begin
  AState := [odComboBoxEdit];
  if Focused then
    AState := AState + [odSelected, odFocused];

  if DrawSelectionBar then
  begin
    ACanvas.Brush.Color := clHighlight;
    ATextColor := clHighlightText;
  end
  else
  begin
    ACanvas.Brush.Color := BackgroundColor;
    ATextColor := TextColor;
  end;
  ACanvas.Font := Font;
  ACanvas.Font.Color := ATextColor;
  PrepareCanvasFont(ACanvas.Canvas);

  if Edit = nil then
    TcxCustomComboBoxProperties(EditProperties).OnDrawItem(nil, ACanvas,
      ItemIndex, ARect, AState)
  else
    Edit.DoOnDrawItem(ACanvas, ItemIndex, ARect, AState);
end;

function TcxCustomComboBoxViewInfo.GetEdit: TcxCustomComboBox;
begin
  Result := TcxCustomComboBox(FEdit);
end;

{ TcxCustomComboBoxProperties }

constructor TcxCustomComboBoxProperties.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner);
  FDropDownListStyle := lsEditList;
  FDropDownRows := cxEditDefaultDropDownPageRowCount;
end;

procedure TcxCustomComboBoxProperties.Assign(Source: TPersistent);
begin
  if Source is TcxCustomComboBoxProperties then
  begin
    BeginUpdate;
    try
      inherited Assign(Source);
      with Source as TcxCustomComboBoxProperties do
      begin
        Self.DropDownListStyle := DropDownListStyle;
        Self.DropDownRows := DropDownRows;
        Self.ItemHeight := ItemHeight;
        Self.Revertable := Revertable;

        Self.OnDrawItem := OnDrawItem;
        Self.OnMeasureItem := OnMeasureItem;
      end;
    finally
      EndUpdate;
    end
  end
  else
    inherited Assign(Source);
end;

class function TcxCustomComboBoxProperties.GetContainerClass: TcxContainerClass;
begin
  Result := TcxComboBox;
end;

class function TcxCustomComboBoxProperties.GetViewInfoClass: TcxContainerViewInfoClass;
begin
  Result := TcxCustomComboBoxViewInfo;
end;

function TcxCustomComboBoxProperties.DropDownOnClick: Boolean;
begin
  Result := DropDownListStyle = lsFixedList;
end;

function TcxCustomComboBoxProperties.GetDropDownPageRowCount: Integer;
begin
  Result := DropDownRows;
end;

function TcxCustomComboBoxProperties.GetEditingStyle: TcxEditEditingStyle;
const
  AEditingStyleMap: array[TcxEditDropDownListStyle] of TcxEditEditingStyle =
    (esEditList, esEdit, esFixedList);
begin
  Result := AEditingStyleMap[DropDownListStyle];
end;

class function TcxCustomComboBoxProperties.GetLookupDataClass: TcxInterfacedPersistentClass;
begin
  Result := TcxComboBoxLookupData;
end;

class function TcxCustomComboBoxProperties.GetPopupWindowClass: TcxCustomEditPopupWindowClass;
begin
  Result := TcxComboBoxPopupWindow;
end;

class function TcxCustomComboBoxProperties.GetViewDataClass: TcxCustomEditViewDataClass;
begin
  Result := TcxCustomComboBoxViewData;
end;

function TcxCustomComboBoxProperties.UseLookupData: Boolean;
begin
  Result := True;
end;

function TcxCustomComboBoxProperties.GetDropDownAutoWidth: Boolean;
begin
  Result := PopupAutoSize;
end;

function TcxCustomComboBoxProperties.GetDropDownSizeable: Boolean;
begin
  Result := PopupSizeable;
end;

function TcxCustomComboBoxProperties.GetDropDownWidth: Integer;
begin
  Result := PopupWidth;
end;

function TcxCustomComboBoxProperties.GetItems: TStrings;
begin
  Result := LookupItems;
end;

function TcxCustomComboBoxProperties.GetSorted: Boolean;
begin
  Result := LookupItemsSorted;
end;

procedure TcxCustomComboBoxProperties.SetDropDownAutoWidth(Value: Boolean);
begin
  PopupAutoSize := Value;
end;

procedure TcxCustomComboBoxProperties.SetDropDownListStyle(Value: TcxEditDropDownListStyle);
begin
  if Value = FDropDownListStyle then
    Exit;
  FDropDownListStyle := Value;
  Changed;
end;

procedure TcxCustomComboBoxProperties.SetDropDownRows(Value: Integer);
begin
  if (Value >= 1) and (Value <> FDropDownRows) then
  begin
    FDropDownRows := Value;
    Changed;
  end;
end;

procedure TcxCustomComboBoxProperties.SetDropDownSizeable(Value: Boolean);
begin
  PopupSizeable := Value;
end;

procedure TcxCustomComboBoxProperties.SetDropDownWidth(Value: Integer);
begin
  PopupWidth := Value;
end;

procedure TcxCustomComboBoxProperties.SetItemHeight(Value: Integer);
begin
  if Value <> FItemHeight then
  begin
    FItemHeight := Value;
    Changed;
  end;
end;

procedure TcxCustomComboBoxProperties.SetItems(Value: TStrings);
begin
  LookupItems := Value;
end;

procedure TcxCustomComboBoxProperties.SetSorted(Value: Boolean);
begin
  LookupItemsSorted := Value;
end;

{ TcxCustomComboBoxInnerEdit }

procedure TcxCustomComboBoxInnerEdit.WMLButtonUp(var Message: TWMLButtonUp);
begin
  ControlState := ControlState - [csClicked];
  inherited;
end;

{ TcxCustomComboBox }

procedure TcxCustomComboBox.Activate(var AEditData: TcxCustomEditData);
begin
  inherited Activate(AEditData);
  SynchronizeItemIndex;
end;

class function TcxCustomComboBox.GetPropertiesClass: TcxCustomEditPropertiesClass;
begin
  Result := TcxCustomComboBoxProperties;
end;

function TcxCustomComboBox.CanDropDown: Boolean;
begin
  Result := not((ILookupData <> nil) and (ILookupData.IsEmpty)); // TODO ???
end;

procedure TcxCustomComboBox.ChangeHandler(Sender: TObject);
var
  APrevLookupKey: TcxEditValue;
begin
  APrevLookupKey := ILookupData.CurrentKey;
  LockChangeEvents(True);
  LockClick(True);
  try
    inherited ChangeHandler(Sender);
    if CanSynchronizeLookupData then
      ILookupData.TextChanged;
  finally
    LockClick(False);
    LockChangeEvents(False);
    if (*ModifiedAfterEnter and *)not VarEqualsExact(APrevLookupKey, ILookupData.CurrentKey) and ActiveProperties.IncrementalSearch then
      DoClick;
  end;
end;

procedure TcxCustomComboBox.DblClick;
var
  APrevCurrentKey: TcxEditValue;
begin
  inherited DblClick;
  LockChangeEvents(True);
  LookupItemsScrolling := True;
  try
    if not HasPopupWindow and ActiveProperties.Revertable then
      with ILookupData do
      begin
        APrevCurrentKey := CurrentKey;
        Go(egdNext, True);
        if not VarEqualsExact(APrevCurrentKey, ILookupData.CurrentKey) and
          CanPostEditValue and ActiveProperties.ImmediatePost and ValidateEdit(True) then
            InternalPostEditValue;
      end;
  finally
    LookupItemsScrolling := False;
    LockChangeEvents(False);
  end;
end;

function TcxCustomComboBox.GetInnerEditClass: TControlClass;
begin
  Result := TcxCustomComboBoxInnerEdit;
end;

function TcxCustomComboBox.GetPopupWindowClientPreferredSize: TSize;
var
  AMaxVisualAreaSize: TSize;
  AClientExtent: TRect;
  AWidth: Integer;
begin
  AMaxVisualAreaSize := PopupWindow.GetMaxVisualAreaSize;
  with ActiveProperties do
    if not PopupSizeable and not PopupAutoSize then
    begin
      if PopupWidth > 0 then
        AWidth := PopupWidth
      else
        AWidth := cxRectWidth(GetPopupWindowOwnerControlBounds);
      AClientExtent := PopupWindow.ViewInfo.GetClientExtent;
      Dec(AWidth, AClientExtent.Left + AClientExtent.Right);
      AWidth := Min(AWidth, AMaxVisualAreaSize.cx);
    end
    else
      AWidth := AMaxVisualAreaSize.cx;
  Result := ILookupData.GetVisualAreaPreferredSize(AMaxVisualAreaSize.cy, AWidth);
end;

procedure TcxCustomComboBox.Initialize;
begin
  inherited Initialize;
  ControlStyle := ControlStyle - [csClickEvents];
end;

procedure TcxCustomComboBox.InitializePopupWindow;
begin
  inherited InitializePopupWindow;
  PopupWindow.SysPanelStyle := ActiveProperties.PopupSizeable;
end;

function TcxCustomComboBox.IsTextInputMode: Boolean;
begin
  Result := inherited IsTextInputMode and
    (ActiveProperties.DropDownListStyle = lsEditList);
end;

procedure TcxCustomComboBox.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  AActiveControl: TControl;
  P: TPoint;
begin
  inherited MouseMove(Shift, X, Y);
  AActiveControl := ILookupData.ActiveControl;
  if (GetCaptureControl = Self) and (AActiveControl is TWinControl) then
    with AActiveControl as TWinControl do
    begin
      P := GetMouseCursorPos;
      if HasPopupWindow and PtInRect(PopupWindow.ViewInfo.ClientRect,
        PopupWindow.ScreenToClient(P)) and ILookupData.IsMouseOverList(P) then
        SendMouseEvent(AActiveControl as TWinControl, WM_LBUTTONDOWN, [], ScreenToClient(P));
    end;
end;

procedure TcxCustomComboBox.PopupWindowShowed(Sender: TObject);
var
  P: TPoint;
begin
  inherited PopupWindowShowed(Sender);
  with ILookupData do
    if ActiveControl is TWinControl then
    begin
      P := InternalGetCursorPos;
      if IsMouseOverList(P) then
        FPopupMouseMoveLocked := True;
    end;
end;

procedure TcxCustomComboBox.SetupPopupWindow;
begin
  inherited SetupPopupWindow;
  if ILookupData.ActiveControl <> nil then
    ILookupData.ActiveControl.Invalidate;
end;

function TcxCustomComboBox.CanSynchronizeLookupData: Boolean;
var
  AMsg: TMsg;
begin
  Result := not FLookupDataTextChangedLocked and not EditModeSetting and
  (
    HasPopupWindow or
    not ActiveProperties.CanIncrementalSearch and (PopupWindow <> nil) and PeekMessage(AMsg, PopupWindow.Handle, DXM_SHOWPOPUPWINDOW, DXM_SHOWPOPUPWINDOW, PM_NOREMOVE) or
    (
      (ActiveProperties.EditingStyle in [esEditList, esFixedList, esNoEdit]) or
      Focused and not InternalCompareString(Text, ILookupData.GetDisplayText(ILookupData.CurrentKey), False)
    )
  );
end;

procedure TcxCustomComboBox.ResetPopupHeight;
begin
  if ActiveProperties.PopupSizeable and IsInplace then
  begin
    if EditData <> nil then
      TcxCustomDropDownEditData(EditData).Height := 0
  end
  else
    ActiveProperties.PopupHeight := 0;
end;

procedure TcxCustomComboBox.SynchronizeItemIndex;
begin
  if ActiveProperties.UseLookupData then
    ILookupData.TextChanged;
end;

procedure TcxCustomComboBox.DoOnDrawItem(ACanvas: TcxCanvas; AIndex: Integer;
  const ARect: TRect; AState: TOwnerDrawState);
begin
  with Properties do
    if Assigned(OnDrawItem) then
      OnDrawItem(Self, ACanvas, AIndex, ARect, AState);
  if RepositoryItem <> nil then
    with ActiveProperties do
      if Assigned(OnDrawItem) then
        OnDrawItem(Self, ACanvas, AIndex, ARect, AState);
end;

procedure TcxCustomComboBox.DoOnMeasureItem(AIndex: Integer; ACanvas: TcxCanvas;
  var AHeight: Integer);
begin
  with Properties do
    if Assigned(OnMeasureItem) then
      OnMeasureItem(Self, AIndex, ACanvas, AHeight);
  if RepositoryItem <> nil then
    with ActiveProperties do
      if Assigned(OnMeasureItem) then
        OnMeasureItem(Self, AIndex, ACanvas, AHeight);
end;

function TcxCustomComboBox.IsOnDrawItemEventAssigned: Boolean;
begin
  Result := Assigned(Properties.OnDrawItem) or
    Assigned(ActiveProperties.OnDrawItem);
end;

function TcxCustomComboBox.IsOnMeasureItemEventAssigned: Boolean;
begin
  Result := Assigned(Properties.OnMeasureItem) or
    Assigned(ActiveProperties.OnMeasureItem);
end;

function TcxCustomComboBox.GetActiveProperties: TcxCustomComboBoxProperties;
begin
  Result := TcxCustomComboBoxProperties(InternalGetActiveProperties);
end;

function TcxCustomComboBox.GetLookupData: TcxComboBoxLookupData;
begin
  Result := TcxComboBoxLookupData(FLookupData);
end;

function TcxCustomComboBox.GetProperties: TcxCustomComboBoxProperties;
begin
  Result := TcxCustomComboBoxProperties(FProperties);
end;

function TcxCustomComboBox.GetSelectedItem: Integer;
begin
  if ILookupData.ActiveControl <> nil then
    Result := TcxCustomEditListBox(ILookupData.ActiveControl).ItemIndex
  else
    Result := -1;
end;

procedure TcxCustomComboBox.SetProperties(Value: TcxCustomComboBoxProperties);
begin
  FProperties.Assign(Value);
end;

procedure TcxCustomComboBox.SetSelectedItem(Value: Integer);
begin
  if ILookupData.ActiveControl <> nil then
    TcxCustomEditListBox(ILookupData.ActiveControl).ItemIndex := Value;
end;

procedure TcxCustomComboBox.WMLButtonUp(var Message: TWMLButtonUp);
begin
  ControlState := ControlState - [csClicked];
  inherited;
end;

{ TcxComboBox }

function TcxComboBox.SupportsSpelling: Boolean;
begin
  Result := IsTextInputMode;
end;

class function TcxComboBox.GetPropertiesClass: TcxCustomEditPropertiesClass;
begin
  Result := TcxComboBoxProperties;
end;

function TcxComboBox.GetActiveProperties: TcxComboBoxProperties;
begin
  Result := TcxComboBoxProperties(InternalGetActiveProperties);
end;

function TcxComboBox.GetProperties: TcxComboBoxProperties;
begin
  Result := TcxComboBoxProperties(FProperties);
end;

procedure TcxComboBox.SetProperties(Value: TcxComboBoxProperties);
begin
  FProperties.Assign(Value);
end;

{ TcxFilterComboBoxHelper }

class function TcxFilterComboBoxHelper.GetFilterEditClass: TcxCustomEditClass;
begin
  Result := TcxComboBox;
end;

class procedure TcxFilterComboBoxHelper.InitializeProperties(AProperties,
  AEditProperties: TcxCustomEditProperties; AHasButtons: Boolean);
begin
  inherited InitializeProperties(AProperties, AEditProperties, AHasButtons);
  with TcxCustomComboBoxProperties(AProperties) do
  begin
    ButtonGlyph := nil;
    DropDownRows := 8;
    DropDownListStyle := lsEditList;
    ImmediateDropDown := False;
    PopupAlignment := taLeftJustify;
    Revertable := False;
  end;
end;

{ TcxPopupEditPopupWindowViewInfo }

procedure TcxPopupEditPopupWindowViewInfo.DrawBorder(ACanvas: TcxCanvas; var R: TRect);
var
  AOriginalClientEdge: Boolean;
begin
  AOriginalClientEdge := ClientEdge;
  ClientEdge := True;
  inherited DrawBorder(ACanvas, R);
  ClientEdge := AOriginalClientEdge;
end;

{ TcxPopupEditPopupWindow }

function TcxPopupEditPopupWindow.GetViewInfoClass: TcxContainerViewInfoClass;
begin
  Result := TcxPopupEditPopupWindowViewInfo;
end;

{ TcxCustomPopupEditProperties }

constructor TcxCustomPopupEditProperties.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner);
  FPopupAutoSize := True;
  FPopupHeight := 200;
  FPopupMinHeight := 100;
  FPopupMinWidth := 100;
  FPopupSizeable := True;
  FPopupWidth := 250;
end;

procedure TcxCustomPopupEditProperties.Assign(Source: TPersistent);
begin
  if Source is TcxCustomPopupEditProperties then
  begin
    BeginUpdate;
    try
      inherited Assign(Source);
      with Source as TcxCustomPopupEditProperties do
        Self.PopupControl := PopupControl;
    finally
      EndUpdate;
    end;
  end
  else
    inherited Assign(Source);
end;

class function TcxCustomPopupEditProperties.GetContainerClass: TcxContainerClass;
begin
  Result := TcxPopupEdit;
end;

procedure TcxCustomPopupEditProperties.FreeNotification(Sender: TComponent);
begin
  inherited FreeNotification(Sender);
  if Sender = FPopupControl then
    FPopupControl := nil;
end;

class function TcxCustomPopupEditProperties.GetPopupWindowClass: TcxCustomEditPopupWindowClass;
begin
  Result := TcxPopupEditPopupWindow;
end;

function TcxCustomPopupEditProperties.IsLookupDataVisual: Boolean;
begin
  Result := False;
end;

function TcxCustomPopupEditProperties.PopupWindowCapturesFocus: Boolean;
begin
  Result := True;
end;

procedure TcxCustomPopupEditProperties.SetPopupControl(Value: TControl);
begin
  if Value = FPopupControl then
    Exit;
  if FPopupControl <> nil then
    FreeNotificator.RemoveSender(Value);
  FPopupControl := Value;
  if FPopupControl <> nil then
    FreeNotificator.AddSender(Value);
end;

{ TcxPopupEditProperties }

constructor TcxPopupEditProperties.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner);
  ImmediateDropDown := True;
  ImmediatePopup := True;
end;

{ TcxCustomPopupEdit }

destructor TcxCustomPopupEdit.Destroy;
begin
  if (FPopupWindow <> nil) and FPopupWindow.IsVisible then
    RestorePopupControlData;
  inherited Destroy;
end;

class function TcxCustomPopupEdit.GetPropertiesClass: TcxCustomEditPropertiesClass; 
begin
  Result := TcxCustomPopupEditProperties;
end;

function TcxCustomPopupEdit.CanDropDown: Boolean;
begin
  with ActiveProperties do
    Result := PopupControl <> nil;
end;

procedure TcxCustomPopupEdit.DoInitPopup;

  function ControlHasAsParent(AControl: TControl): Boolean;
  var
    AParent: TControl;
  begin
    Result := AControl = PopupWindow;
    AParent := PopupWindow.OwnerControl;
    while AParent <> nil do
    begin
      if AParent = AControl then
      begin
        Result := True;
        Break;
      end;
      AParent := AParent.Parent;
    end;
  end;

begin
  if ControlHasAsParent(ActiveProperties.FPopupControl) then
    raise EcxEditError.Create(cxGetResourceString(@cxSEditPopupCircularReferencingError));
  inherited DoInitPopup;
end;

function TcxCustomPopupEdit.GetPopupFocusedControl: TWinControl;
begin
  with ActiveProperties do
    if PopupControl is TWinControl then
      Result := TWinControl(PopupControl)
    else
      Result := nil;
end;

function TcxCustomPopupEdit.GetPopupWindowClientPreferredSize: TSize;
begin
  with ActiveProperties.PopupControl do
    Result := cxSize(Width, Height);
end;

procedure TcxCustomPopupEdit.PopupWindowClosed(Sender: TObject);
begin
  RestorePopupControlData;
  inherited PopupWindowClosed(Sender);
end;

procedure TcxCustomPopupEdit.PositionPopupWindowChilds(const AClientRect: TRect);
begin
  with AClientRect do
  begin
    ActiveProperties.PopupControl.Left := Left;
    ActiveProperties.PopupControl.Top := Top;
    ActiveProperties.PopupControl.Width := Right - Left;
    ActiveProperties.PopupControl.Height := Bottom - Top;
  end;
end;

procedure TcxCustomPopupEdit.SetupPopupWindow;
begin
  with ActiveProperties.PopupControl do
  begin
    SavePopupControlData;
    Parent := PopupWindow;
    Visible := True;
    inherited SetupPopupWindow;
    Align := alClient; // TODO
  end;
end;

procedure TcxCustomPopupEdit.HidePopup(Sender: TcxControl; AReason: TcxEditCloseUpReason);
begin
  FCloseUpReason := AReason;
  PopupWindow.ClosePopup;
end;

procedure TcxCustomPopupEdit.RestorePopupControlData;
begin
  if ActiveProperties.PopupControl <> nil then
    with ActiveProperties.PopupControl do
    begin
      Visible := False;
      Parent := FPrevPopupControlData.Parent;
      Align := FPrevPopupControlData.Align;
      BoundsRect := FPrevPopupControlData.Bounds;
      Visible := FPrevPopupControlData.Visible;
    end;
end;

procedure TcxCustomPopupEdit.SavePopupControlData;
var
  APopupControl: TControl;
begin
  APopupControl := ActiveProperties.PopupControl;
  with APopupControl do
  begin
    FPrevPopupControlData.Align := Align;
    if APopupControl is TCustomForm then
    begin
      FPrevPopupControlData.BorderStyle := TCustomForm(APopupControl).BorderStyle;
      TCustomForm(APopupControl).BorderStyle := bsNone;
    end;
    FPrevPopupControlData.Bounds := BoundsRect;
    FPrevPopupControlData.Parent := Parent;
    FPrevPopupControlData.Visible := Visible;
  end;
end;

function TcxCustomPopupEdit.GetProperties: TcxCustomPopupEditProperties;
begin
  Result := TcxCustomPopupEditProperties(FProperties);
end;

function TcxCustomPopupEdit.GetActiveProperties: TcxCustomPopupEditProperties;
begin
  Result := TcxCustomPopupEditProperties(InternalGetActiveProperties);
end;

procedure TcxCustomPopupEdit.SetProperties(Value: TcxCustomPopupEditProperties);
begin
  FProperties.Assign(Value);
end;

{ TcxPopupEdit }

function TcxPopupEdit.SupportsSpelling: Boolean;
begin
  Result := IsTextInputMode;
end;

class function TcxPopupEdit.GetPropertiesClass: TcxCustomEditPropertiesClass;
begin
  Result := TcxPopupEditProperties;
end;

function TcxPopupEdit.GetActiveProperties: TcxPopupEditProperties;
begin
  Result := TcxPopupEditProperties(InternalGetActiveProperties);
end;

function TcxPopupEdit.GetProperties: TcxPopupEditProperties;
begin
  Result := TcxPopupEditProperties(FProperties);
end;

procedure TcxPopupEdit.SetProperties(Value: TcxPopupEditProperties);
begin
  FProperties.Assign(Value);
end;

initialization
  GetRegisteredEditProperties.Register(TcxComboBoxProperties, scxSEditRepositoryComboBoxItem);
  GetRegisteredEditProperties.Register(TcxPopupEditProperties, scxSEditRepositoryPopupItem);
  FilterEditsController.Register(TcxComboBoxProperties, TcxFilterComboBoxHelper);

finalization
  FilterEditsController.Unregister(TcxComboBoxProperties, TcxFilterComboBoxHelper);
  
end.
