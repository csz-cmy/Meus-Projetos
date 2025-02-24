
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
unit cxNavigator;

{$I cxVer.inc}

interface

uses
  Types, Messages, Windows, Classes, Controls, Forms, Graphics, ImgList,
  StdCtrls, SysUtils, cxClasses, cxContainer, cxControls, cxFilter, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, dxThemeManager;

const
  NavigatorButtonCount = 16;

  NBDI_FIRST        = 0;
  NBDI_PRIORPAGE    = 1;
  NBDI_PRIOR        = 2;
  NBDI_NEXT         = 3;
  NBDI_NEXTPAGE     = 4;
  NBDI_LAST         = 5;
  NBDI_INSERT       = 6;
  NBDI_APPEND       = 7;
  NBDI_DELETE       = 8;
  NBDI_EDIT         = 9;
  NBDI_POST         = 10;
  NBDI_CANCEL       = 11;
  NBDI_REFRESH      = 12;
  NBDI_SAVEBOOKMARK = 13;
  NBDI_GOTOBOOKMARK = 14;
  NBDI_FILTER       = 15;

  cxNavigatorInfoPanelDefaultDisplayMask = '[RecordIndex] of [RecordCount]';

type
  TcxNavigatorViewInfo = class;
  TcxCustomNavigatorButtons = class;
  TcxCustomNavigatorInfoPanel = class;

  TcxNavigatorChangeType = (nctProperties, nctSize, nctLayout);

  IcxNavigatorOwner = interface
  ['{504B7F43-8847-46C5-B84A-C24F8E5E61A6}']
    procedure NavigatorChanged(AChangeType: TcxNavigatorChangeType);
    function GetNavigatorBounds: TRect;
    function GetNavigatorButtons: TcxCustomNavigatorButtons;
    function GetNavigatorCanvas: TCanvas;
    function GetNavigatorControl: TWinControl;
    function GetNavigatorFocused: Boolean;
    function GetNavigatorLookAndFeel: TcxLookAndFeel;
    function GetNavigatorOwner: TComponent;
    function GetNavigatorShowHint: Boolean;
    function GetNavigatorTabStop: Boolean;
    procedure NavigatorStateChanged;
    procedure RefreshNavigator;
  end;

  IcxNavigatorOwner2 = interface(IcxNavigatorOwner)
  ['{5AC3BE65-B332-40D4-9635-869F52634B17}']
    function GetNavigatorInfoPanel: TcxCustomNavigatorInfoPanel;
  end;

  TcxNavigatorControlNotifier = class
  private
    FList: TList;
  public
    constructor Create;
    destructor Destroy; override;
    procedure AddNavigator(ANavigator: IcxNavigatorOwner);
    procedure RemoveNavigator(ANavigator: IcxNavigatorOwner);
    procedure RefreshNavigatorButtons;
  end;

  IcxNavigator = interface
  ['{A15F80CA-DE56-47CB-B0EB-035D0BF90E9D}']
    function CanAppend: Boolean;
    function CanDelete: Boolean;
    function CanEdit: Boolean;
    function CanInsert: Boolean;
    function IsActive: Boolean;
    function IsBof: Boolean;
    function IsBookmarkAvailable: Boolean;
    function IsEditing: Boolean;
    function IsEof: Boolean;
    procedure ClearBookmark;
    procedure DoAction(AButtonIndex: Integer);
    function GetNotifier: TcxNavigatorControlNotifier;
    function IsActionSupported(AButtonIndex: Integer): Boolean;
  end;

  IcxNavigatorRecordPosition = interface
  ['{715C9E38-5BA0-4ED8-B35C-BB40EA739362}']
    function GetRecordCount: Integer;
    function GetRecordIndex: Integer;
  end;

  TcxNavigatorButton = class(TPersistent)
  private
    FButtons: TcxCustomNavigatorButtons;
    FDefaultIndex: Integer;
    FDefaultVisible: Boolean;
    FEnabled: Boolean;
    FHint: string;
    FImageIndex: TImageIndex;
    FIsVisibleAssigned: Boolean;
    FVisible: Boolean;
    FOnClick: TNotifyEvent;
    function GetInternalImageIndex: Integer;
    function GetInternalImages: TCustomImageList;
    procedure InternalSetVisible(Value: Boolean; AIsInternalSetting: Boolean = True);
    function IsVisibleStored: Boolean;
    procedure SetEnabled(const Value: Boolean);
    procedure SetHint(const Value: string);
    procedure SetImageIndex(Value: TImageIndex);
    procedure SetOnClick(const Value: TNotifyEvent);
    procedure SetVisible(const Value: Boolean);
  protected
    function  GetOwner: TPersistent; override;
    function GetInternalEnabled: Boolean;
    function GetInternalHint: string;
    function IsUserImageListUsed: Boolean;
    procedure DoClick; dynamic;
    procedure RestoreDefaultVisible(ACanBeVisible: Boolean);

    function GetNavigator: IcxNavigatorOwner;

    property DefaultIndex: Integer read FDefaultIndex write FDefaultIndex;
    property InternalImageIndex: Integer read GetInternalImageIndex;
    property InternalImages: TCustomImageList read GetInternalImages;
  public
    constructor Create(AButtons: TcxCustomNavigatorButtons;
      ADefaultVisible: Boolean);

    procedure Assign(Source: TPersistent); override;
    procedure Click;
    function GetImageSize: TSize;

    property Buttons: TcxCustomNavigatorButtons read FButtons;
    property Navigator: IcxNavigatorOwner read GetNavigator;
    property OnClick: TNotifyEvent read FOnClick write SetOnClick;
  published
    property Enabled: Boolean read FEnabled write SetEnabled default True;
    property Hint: string read FHint write SetHint;
    property ImageIndex: TImageIndex read FImageIndex write SetImageIndex default -1;
    property Visible: Boolean read FVisible write SetVisible stored IsVisibleStored;
  end;

  TcxCustomNavigator = class;

  { TcxNavigatorChildComponent }

  TcxNavigatorChildComponent = class(TPersistent)
  private
    FNavigator: IcxNavigatorOwner;
  protected
    procedure Changed(AChangeType: TcxNavigatorChangeType; ANeedRefresh: Boolean = False);
    function  GetOwner: TPersistent; override;
    function IsNavigatorEnabled: Boolean;
  public
    constructor Create(ANavigator: IcxNavigatorOwner); virtual;

    property Navigator: IcxNavigatorOwner read FNavigator;
  end;

  { TcxCustomNavigatorButtons }

  TcxNavigatorButtonClickEvent = procedure(Sender: TObject; AButtonIndex: Integer;
    var ADone: Boolean) of object;

  TcxCustomNavigatorButtons = class(TcxNavigatorChildComponent)
  private
    FButtons: array [0 .. NavigatorButtonCount - 1] of TcxNavigatorButton;
    FImages: TCustomImageList;
    FImageChangeLink: TChangeLink;
    FConfirmDelete: Boolean;
    FOnButtonClick: TcxNavigatorButtonClickEvent;

    function GetButton(Index: Integer): TcxNavigatorButton;
    function GetButtonCount: Integer;
    function GetDefaultImages: TCustomImageList;
    procedure SetButton(Index: Integer; const Value: TcxNavigatorButton);
    procedure SetConfirmDelete(const Value: Boolean);
    procedure SetImages(const Value: TCustomImageList);
    procedure SetOnButtonClick(const Value: TcxNavigatorButtonClickEvent);
    procedure ImageListChange(Sender: TObject);
  protected
    procedure CreateButtons; virtual;
    procedure DestroyButtons; virtual;

    procedure DoButtonClick(ADefaultIndex: Integer); virtual;
    function GetButtonEnabled(ADefaultIndex: Integer): Boolean; virtual;
    function GetButtonHint(ADefaultIndex: Integer): string; virtual;
    function GetButtonImageOffset: Integer; virtual;

    property ConfirmDelete: Boolean read FConfirmDelete write SetConfirmDelete default True;

    property First: TcxNavigatorButton index NBDI_FIRST read GetButton write SetButton;
    property PriorPage: TcxNavigatorButton index NBDI_PRIORPAGE read GetButton write SetButton;
    property Prior: TcxNavigatorButton index NBDI_PRIOR read GetButton write SetButton;
    property Next: TcxNavigatorButton index NBDI_NEXT read GetButton write SetButton;
    property NextPage: TcxNavigatorButton index NBDI_NEXTPAGE read GetButton write SetButton;
    property Last: TcxNavigatorButton index NBDI_LAST read GetButton write SetButton;
    property Insert: TcxNavigatorButton index NBDI_INSERT read GetButton write SetButton;
    property Append: TcxNavigatorButton index NBDI_APPEND read GetButton write SetButton;
    property Delete: TcxNavigatorButton index NBDI_DELETE read GetButton write SetButton;
    property Edit: TcxNavigatorButton index NBDI_EDIT read GetButton write SetButton;
    property Post: TcxNavigatorButton index NBDI_POST read GetButton write SetButton;
    property Cancel: TcxNavigatorButton index NBDI_CANCEL read GetButton write SetButton;
    property Refresh: TcxNavigatorButton index NBDI_REFRESH read GetButton write SetButton;
    property SaveBookmark: TcxNavigatorButton index NBDI_SAVEBOOKMARK read GetButton write SetButton;
    property GotoBookmark: TcxNavigatorButton index NBDI_GOTOBOOKMARK read GetButton write SetButton;
    property Filter: TcxNavigatorButton index NBDI_FILTER read GetButton write SetButton;
  public
    constructor Create(ANavigator: IcxNavigatorOwner); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    procedure ClickButton(Index: Integer);
    procedure ReleaseBookmark; virtual;

    property ButtonCount: Integer read GetButtonCount;
    property Buttons[Index: Integer]: TcxNavigatorButton read GetButton; default;
    property DefaultImages: TCustomImageList read GetDefaultImages;
    property Images: TCustomImageList read FImages write SetImages;
  published
    property OnButtonClick: TcxNavigatorButtonClickEvent read FOnButtonClick
      write SetOnButtonClick;
  end;

  { TcxCustomNavigatorInfoPanel }

  TcxInfoPanelGetIRecordPosition = function: IcxNavigatorRecordPosition of object;

  TcxCustomNavigatorInfoPanel = class(TcxNavigatorChildComponent)
  private
    FDisplayMask: string;
    FFormatString: string;
    FIsNeedRecordCount: Boolean;
    FIsNeedRecordIndex: Boolean;
    FVisible: Boolean;
    FOnClick: TNotifyEvent;
    FOnGetIRecordPosition: TcxInfoPanelGetIRecordPosition;
    function GetIRecordPosition: IcxNavigatorRecordPosition;
    function IsDisplayMaskStored: Boolean;
    procedure SetDisplayMask(const Value: string);
    procedure SetVisible(Value: Boolean);
  protected
    procedure BuildFormatString;
    procedure DoClick; virtual;
    function GetViewParams: TcxViewParams; virtual; abstract;

    property DisplayMask: string read FDisplayMask write SetDisplayMask stored IsDisplayMaskStored;
    property IsNeedRecordIndex: Boolean read FIsNeedRecordIndex;
    property IsNeedRecordCount: Boolean read FIsNeedRecordCount;
    property IRecordPosition: IcxNavigatorRecordPosition read GetIRecordPosition;
    property Visible: Boolean read FVisible write SetVisible default False;
  public
    constructor Create(ANavigator: IcxNavigatorOwner); override;
    procedure Assign(Source: TPersistent); override;
    function GetFormattedText: string; virtual;

    property OnGetIRecordPosition: TcxInfoPanelGetIRecordPosition
      read FOnGetIRecordPosition write FOnGetIRecordPosition;
  published
    property OnClick: TNotifyEvent read FOnClick write FOnClick;
  end;

  { TcxNavigatorButtonViewInfo }

  TcxNavigatorButtonViewInfo = class
  public
    Button: TcxNavigatorButton;
    Bounds: TRect;
    Enabled: Boolean;
    Hint: string;
  end;

  { TcxCustomNavigatorInfoPanelViewInfo }

  TcxCustomNavigatorInfoPanelViewInfo = class
  private
    FText: string;
    FBounds: TRect;
    FNavigatorViewInfo: TcxNavigatorViewInfo;
    function GetNavigatorOwner: IcxNavigatorOwner2;
  protected
    property NavigatorOwner: IcxNavigatorOwner2 read GetNavigatorOwner;
    property NavigatorViewInfo: TcxNavigatorViewInfo read FNavigatorViewInfo;
  public
    constructor Create(ANavigatorViewInfo: TcxNavigatorViewInfo);
    procedure Calculate(const ABounds: TRect; const AText: string);
    procedure Paint;

    property Bounds: TRect read FBounds;
    property Text: string read FText;
  end;

  { TcxNavigatorViewInfo }

  TcxNavigatorViewInfo = class
  private
    FButtonPressTimer: TcxTimer;
    FButtons: TList;
    FCanvas: TcxCanvas;
    FFocusedButton: TcxNavigatorButton;
    FHintTimer: TcxTimer;
    FHintWindow: THintWindow;
    FHintWindowShowing: Boolean;
    FHotTrackButtonViewInfo: TcxNavigatorButtonViewInfo;
    FInfoPanelPressed: Boolean;
    FInfoPanelViewInfo: TcxCustomNavigatorInfoPanelViewInfo;
    FIsDirty: Boolean;
    FIsInplace: Boolean;
    FIsSelected: Boolean;
    FNavigatorOwner: IcxNavigatorOwner;
    FNavigatorOwner2: IcxNavigatorOwner2;
    FPressedButtonViewInfo: TcxNavigatorButtonViewInfo;
    function GetButton(Index: Integer): TcxNavigatorButtonViewInfo;
    function GetButtonCount: Integer;
    function GetCanvas: TcxCanvas;
    function GetFocusedButton: TcxNavigatorButtonViewInfo;
    procedure SetFocusedButton(Value: TcxNavigatorButtonViewInfo);
    function StopButtonPressTimerIfLeftMouseReleased: Boolean;
    procedure DoButtonPressTimer(Sender: TObject);
    procedure DoHintTimer(Sender: TObject);
    procedure UpdateSelected;
  protected
    function GetButtonBorderExtent(APainter: TcxCustomLookAndFeelPainterClass;
      AButtonIndex, AButtonCount: Integer): TRect;
    function GetButtonState(AButton: TcxNavigatorButtonViewInfo): TcxButtonState;
    function GetInfoPanelFont: TFont;
    function GetInfoPanelText: string;
    function GetInfoPanelSize(AText: string): TSize;
    function GetMiddleButtonBorderExtent(APainter: TcxCustomLookAndFeelPainterClass): TRect;
    function GetMinButtonSize(AButtonIndex, AButtonCount: Integer;
      AAutoHeight: Boolean = False): TSize;
    function GetVisibleButtonCount: Integer;
    procedure InvalidateButton(AButton: TcxNavigatorButtonViewInfo);
    procedure PaintButton(AButtonIndex: Integer);
    function HasInfoPanel: Boolean;
    procedure HintActivate(AShow: Boolean);

    property Canvas: TcxCanvas read GetCanvas;
    property FocusedButton: TcxNavigatorButtonViewInfo read GetFocusedButton
      write SetFocusedButton;
    property HotTrackButtonViewInfo: TcxNavigatorButtonViewInfo
      read FHotTrackButtonViewInfo write FHotTrackButtonViewInfo;
    property InfoPanelViewInfo: TcxCustomNavigatorInfoPanelViewInfo read FInfoPanelViewInfo;
    property IsInplace: Boolean read FIsInplace;
    property NavigatorOwner: IcxNavigatorOwner read FNavigatorOwner;
    property NavigatorOwner2: IcxNavigatorOwner2 read FNavigatorOwner2;
    property PressedButtonViewInfo: TcxNavigatorButtonViewInfo
      read FPressedButtonViewInfo write FPressedButtonViewInfo;
  public
    constructor Create(ANavigator: IcxNavigatorOwner;
      AIsInplace: Boolean = True); virtual;
    destructor Destroy; override;
    procedure Calculate;
    procedure CheckSize(var AWidth, AHeight: Integer;
      ACheckMinHeight: Boolean = False);
    procedure Clear;
    procedure DoEnter;
    procedure DoExit;
    function GetButtonAt(const pt: TPoint): TcxNavigatorButton;
    function GetButtonViewInfoAt(const pt: TPoint): TcxNavigatorButtonViewInfo;
    function GetButtonViewInfoByButton(AButton: TcxNavigatorButton): TcxNavigatorButtonViewInfo;
    procedure MakeIsDirty;
    procedure MouseDown(X, Y: Integer);
    procedure MouseMove(X, Y: Integer);
    procedure MouseUp(X, Y: Integer);
    procedure Paint;
    procedure PressArrowKey(ALeftKey: Boolean);
    procedure Update;
    procedure UpdateButtonsEnabled;

    property ButtonCount: Integer read GetButtonCount;
    property Buttons[Index: Integer]: TcxNavigatorButtonViewInfo read GetButton;
  end;

  TcxNavigatorViewInfoClass = class of TcxNavigatorViewInfo;

  TcxCustomNavigator = class(TcxControl,
    IUnknown,
    IcxNavigatorOwner,
    IcxNavigatorOwner2,
    IcxMouseTrackingCaller,
    IdxSkinSupport)
  private
    FButtons: TcxCustomNavigatorButtons;
    FInfoPanel: TcxCustomNavigatorInfoPanel;
    FSubClassEvents: TNotifyEvent;
    FViewInfo: TcxNavigatorViewInfo;
    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure CMHintShow(var Message: TCMHintShow); message CM_HINTSHOW;
  protected
    function CanFocusOnClick: Boolean; override;
    function CanResize(var NewWidth, NewHeight: Integer): Boolean; override;
    function CreateButtons: TcxCustomNavigatorButtons; virtual;
    function CreateInfoPanel: TcxCustomNavigatorInfoPanel; virtual; abstract;
    procedure DoEnter; override;
    procedure DoExit; override;
    procedure EnabledChanged; dynamic;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure LookAndFeelChanged(Sender: TcxLookAndFeel;
      AChangedValues: TcxLookAndFeelValues); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseEnter(AControl: TControl); override;
    procedure MouseLeave(AControl: TControl); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure Paint; override;
    //IcxMouseTrackingCaller
    procedure IcxMouseTrackingCaller.MouseLeave = NavigatorMouseLeave;
    procedure NavigatorMouseLeave;
    //IcxNavigatorOwner
    procedure NavigatorChanged(AChangeType: TcxNavigatorChangeType);
    function GetNavigatorBounds: TRect;
    function GetNavigatorButtons: TcxCustomNavigatorButtons;
    function GetNavigatorCanvas: TCanvas;
    function GetNavigatorControl: TWinControl;
    function GetNavigatorFocused: Boolean;
    function GetNavigatorLookAndFeel: TcxLookAndFeel;
    function GetNavigatorOwner: TComponent;
    function GetNavigatorShowHint: Boolean;
    function GetNavigatorTabStop: Boolean;
    //IcxNavigatorOwner2
    function GetNavigatorInfoPanel: TcxCustomNavigatorInfoPanel; virtual;

    function GetViewInfoClass: TcxNavigatorViewInfoClass; virtual;
    procedure InitButtons; virtual;
    procedure NavigatorStateChanged;
    procedure RefreshNavigator;
    procedure CreateWnd; override;
    procedure WndProc(var Message: TMessage); override;

    property CustomButtons: TcxCustomNavigatorButtons read FButtons;
    property CustomInfoPanel: TcxCustomNavigatorInfoPanel read FInfoPanel;
    property ViewInfo: TcxNavigatorViewInfo read FViewInfo;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ClickButton(Index: Integer);
    procedure RestoreButtons;
    property LookAndFeel;
  published
    property TabStop default False;
    property ButtonsEvents: TNotifyEvent read FSubClassEvents
      write FSubClassEvents;
    property InfoPanelEvents: TNotifyEvent read FSubClassEvents
      write FSubClassEvents;
  end;

  TcxNavigatorControlButtonsGetControl = function: IcxNavigator of object;

  TcxNavigatorControlButtons = class(TcxCustomNavigatorButtons)
  private
    FOnGetControl: TcxNavigatorControlButtonsGetControl;

    function GetControl: IcxNavigator;
  protected
    procedure DoButtonClick(ADefaultIndex: Integer); override;
    function GetButtonEnabled(ADefaultIndex: Integer): Boolean; override;

    property Control: IcxNavigator read GetControl;
  public
    procedure ReleaseBookmark; override;
    property OnGetControl: TcxNavigatorControlButtonsGetControl
      read FOnGetControl write FOnGetControl;
  published
    property ConfirmDelete;
    property Images;

    property First;
    property PriorPage;
    property Prior;
    property Next;
    property NextPage;
    property Last;
    property Insert;
    property Append;
    property Delete;
    property Edit;
    property Post;
    property Cancel;
    property Refresh;
    property SaveBookmark;
    property GotoBookmark;
    property Filter;
  end;

  TcxNavigatorControlButtonsClass = class of TcxNavigatorControlButtons;

  { TcxNavigatorControlInfoPanel }

  TcxNavigatorControlInfoPanel = class(TcxCustomNavigatorInfoPanel)
  private
    FFont: TFont;
    procedure FontChanged(Sender: TObject);
    procedure SetFont(Value: TFont);
  protected
    function GetViewParams: TcxViewParams; override;
  public
    constructor Create(ANavigator: IcxNavigatorOwner); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
  published
    property DisplayMask;
    property Font: TFont read FFont write SetFont;
    property Visible;
  end;

  TcxNavigatorControlInfoPanelClass = class of TcxNavigatorControlInfoPanel;

  { TcxCustomNavigatorControl }

  TcxCustomNavigatorControl = class(TcxCustomNavigator)
  private
    FControl: TComponent;
    function GetButtons: TcxNavigatorControlButtons;
    function GetIcxNavigator: IcxNavigator;
    function GetIRecordPosition: IcxNavigatorRecordPosition;
    function GetInfoPanel: TcxNavigatorControlInfoPanel;
    procedure SetButtons(Value: TcxNavigatorControlButtons);
    procedure SetControl(Value: TComponent);
    procedure SetInfoPanel(Value: TcxNavigatorControlInfoPanel);
  protected
    function CreateButtons: TcxCustomNavigatorButtons; override;
    function CreateInfoPanel: TcxCustomNavigatorInfoPanel; override;
    function GetButtonsClass: TcxNavigatorControlButtonsClass; virtual;
    function GetInfoPanelClass: TcxNavigatorControlInfoPanelClass; virtual;
    function GetNavigatorInfoPanel: TcxCustomNavigatorInfoPanel; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure InitButtons; override;

    property Buttons: TcxNavigatorControlButtons read GetButtons write SetButtons;
    property Control: TComponent read FControl write SetControl;
    property InfoPanel: TcxNavigatorControlInfoPanel read GetInfoPanel write SetInfoPanel;
  public
    destructor Destroy; override;
  end;

  TcxNavigator = class(TcxCustomNavigatorControl)
  published
    property Control;
    property Buttons;
    property InfoPanel;
    property LookAndFeel;

    property Align;
    property Anchors;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Ctl3D;
    property ParentCtl3D;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnResize;
    property OnStartDock;
    property OnStartDrag;
  end;

function NavigatorImages: TcxImageList;

function cxGetNavigatorFormatString(const ADisplayMask: string;
  out AIsNeedRecordIndex, AIsNeedRecordCount: Boolean): string;

implementation

uses
  Dialogs, cxEditPaintUtils, cxEditUtils, cxEditConsts, dxThemeConsts, dxUxTheme,
  cxGeometry, dxCore;

const
  cxInitRepeatPause = 400;
  cxRepeatPause = 100;

type
  TCustomFormAccess = class(TCustomForm);

var
  FNavigatorImages: TcxImageList = nil;

function NavigatorImages: TcxImageList;
begin
  if FNavigatorImages = nil then
  begin
    FNavigatorImages := TcxImageList.Create(nil);
    FNavigatorImages.Height := 11;
    FNavigatorImages.Width := 11;
    FNavigatorImages.LoadImage(HInstance, 'CXNAVIGATORBUTTONS', $009999, 11);
  end;
  Result := FNavigatorImages;
end;

function cxGetNavigatorFormatString(const ADisplayMask: string;
  out AIsNeedRecordIndex, AIsNeedRecordCount: Boolean): string;
begin
  Result := StringReplace(ADisplayMask, '%', '%%', [rfReplaceAll]);
  AIsNeedRecordIndex := AnsiPos('[RecordIndex]', ADisplayMask) > 0;
  if AIsNeedRecordIndex then
    Result := StringReplace(Result, '[RecordIndex]', '%0:s', [rfReplaceAll, rfIgnoreCase]);
  AIsNeedRecordCount := AnsiPos('[RecordCount]', ADisplayMask) > 0;
  if AIsNeedRecordCount then
    Result := StringReplace(Result, '[RecordCount]', '%1:s', [rfReplaceAll, rfIgnoreCase]);
end;

{ TcxNavigatorButton }

constructor TcxNavigatorButton.Create(AButtons: TcxCustomNavigatorButtons;
  ADefaultVisible: Boolean);
begin
  inherited Create;
  FButtons := AButtons;
  FDefaultIndex := -1;
  FDefaultVisible := ADefaultVisible;
  FEnabled := True;
  FImageIndex := -1;
  FVisible := ADefaultVisible;
end;

function  TcxNavigatorButton.GetOwner: TPersistent;
begin
  Result := FButtons;
end;

procedure TcxNavigatorButton.Assign(Source: TPersistent);
begin
  if Source is TcxNavigatorButton then
    with Source as TcxNavigatorButton do
    begin
      Self.Enabled := Enabled;
      Self.Hint := Hint;
      Self.ImageIndex  := ImageIndex;
      Self.Visible := Visible;
      Self.FIsVisibleAssigned := FIsVisibleAssigned;
      Self.OnClick := OnClick;
    end
  else
    inherited Assign(Source);
end;

procedure TcxNavigatorButton.Click;
begin
  if GetInternalEnabled then
    DoClick;
end;

function TcxNavigatorButton.GetInternalEnabled: Boolean;
begin
  Result := Enabled;
  if Result then
    Result := Buttons.GetButtonEnabled(DefaultIndex);
end;

function TcxNavigatorButton.GetInternalHint: string;
begin
  Result := Hint;
  if Hint = '' then
    Result := Buttons.GetButtonHint(DefaultIndex);
end;

function TcxNavigatorButton.IsUserImageListUsed: Boolean;
begin
  Result := (Buttons.Images <> nil) and (ImageIndex > -1);
end;

procedure TcxNavigatorButton.DoClick;
var
  ADone: Boolean;
begin
  if Assigned(OnClick) then
    OnClick(Self)
  else
  begin
    ADone := False;
    if Assigned(Buttons.FOnButtonClick) then
      Buttons.FOnButtonClick(Buttons, DefaultIndex, ADone);
    if not ADone then
      Buttons.DoButtonClick(DefaultIndex);
  end;
end;

procedure TcxNavigatorButton.RestoreDefaultVisible(ACanBeVisible: Boolean);
begin
  if not FIsVisibleAssigned then
    InternalSetVisible(FDefaultVisible and ACanBeVisible);
end;

function TcxNavigatorButton.GetImageSize: TSize;
var
  APainter: TcxCustomLookAndFeelPainterClass;
begin
  APainter := GetNavigator.GetNavigatorLookAndFeel.SkinPainter;
  if (APainter = nil) or IsUserImageListUsed then
  begin
    Result.cx := InternalImages.Width;
    Result.cy := InternalImages.Height;
  end
  else
    Result := APainter.NavigatorGlyphSize;
end;

function TcxNavigatorButton.GetNavigator: IcxNavigatorOwner;
begin
  Result := Buttons.Navigator;
end;

procedure TcxNavigatorButton.SetEnabled(const Value: Boolean);
begin
  if Enabled <> Value then
  begin
    FEnabled := Value;
    Buttons.Changed(nctLayout, Visible);
  end;
end;

procedure TcxNavigatorButton.SetHint(const Value: string);
begin
  if AnsiCompareStr(FHint, Value) <> 0 then
  begin
    FHint := Value;
    Buttons.Changed(nctProperties);
  end;
end;

function TcxNavigatorButton.GetInternalImageIndex: Integer;
begin
  if (Buttons.Images <> nil) and (ImageIndex > -1) then
    Result := ImageIndex
  else
    Result := DefaultIndex;
end;

function TcxNavigatorButton.GetInternalImages: TCustomImageList;
begin
  if (Buttons.Images <> nil) and (ImageIndex > -1) then
    Result := Buttons.Images
  else
    Result := Buttons.DefaultImages;
end;

procedure TcxNavigatorButton.InternalSetVisible(Value: Boolean;
  AIsInternalSetting: Boolean = True);
begin
  if not AIsInternalSetting then
    FIsVisibleAssigned := True;
  if FVisible <> Value then
  begin
    FVisible := Value;
    Buttons.Changed(nctSize, True);
  end;
end;

function TcxNavigatorButton.IsVisibleStored: Boolean;
begin
  Result := FIsVisibleAssigned;
end;

procedure TcxNavigatorButton.SetImageIndex(Value: TImageIndex);
begin
  if ImageIndex <> Value then
  begin
    FImageIndex := Value;
    Buttons.Changed(nctLayout, Visible);
  end;
end;

procedure TcxNavigatorButton.SetOnClick(const Value: TNotifyEvent);
begin
  FOnClick := Value;
  Buttons.Changed(nctProperties);
end;

procedure TcxNavigatorButton.SetVisible(const Value: Boolean);
begin
  InternalSetVisible(Value, False);
end;

{ TcxNavigatorChildComponent }

constructor TcxNavigatorChildComponent.Create(ANavigator: IcxNavigatorOwner);
begin
  inherited Create;
  FNavigator := ANavigator;
end;

procedure TcxNavigatorChildComponent.Changed(AChangeType: TcxNavigatorChangeType;
  ANeedRefresh: Boolean = False);
begin
  if ANeedRefresh then
    Navigator.RefreshNavigator;
  Navigator.NavigatorChanged(AChangeType);
end;

function TcxNavigatorChildComponent.GetOwner: TPersistent;
begin
  Result := FNavigator.GetNavigatorOwner;
end;

function TcxNavigatorChildComponent.IsNavigatorEnabled: Boolean;
begin
  Result := Navigator.GetNavigatorControl.Enabled;
end;

{ TcxCustomNavigatorButtons }

constructor TcxCustomNavigatorButtons.Create(ANavigator: IcxNavigatorOwner);
begin
  inherited Create(ANavigator);
  FImageChangeLink := TChangeLink.Create;
  FImageChangeLink.OnChange := ImageListChange;
  CreateButtons;
  FConfirmDelete := True;
end;

destructor TcxCustomNavigatorButtons.Destroy;
begin
  FreeAndNil(FImageChangeLink);
  DestroyButtons;
  inherited Destroy;
end;

procedure TcxCustomNavigatorButtons.Assign(Source: TPersistent);
var
  I: Integer;
begin
  if Source is TcxCustomNavigatorButtons then
    with TcxCustomNavigatorButtons(Source) do
    begin
      for I := 0 to ButtonCount - 1 do
        Self.FButtons[I].Assign(FButtons[I]);
      Self.ConfirmDelete := ConfirmDelete;
      Self.Images := Images;
      Self.OnButtonClick := OnButtonClick;
    end
  else
    inherited Assign(Source);
end;

procedure TcxCustomNavigatorButtons.ClickButton(Index: Integer);
begin
  Buttons[Index].Click;
end;

procedure TcxCustomNavigatorButtons.ReleaseBookmark;
begin
end;

procedure TcxCustomNavigatorButtons.CreateButtons;

  function IsButtonVisibleByDefault(AIndex: Integer): Boolean;
  begin
    Result := AIndex <> NBDI_APPEND;
  end;

var
  I: Integer;
begin
  for I := 0 to NavigatorButtonCount - 1 do
  begin
    FButtons[I] := TcxNavigatorButton.Create(Self, IsButtonVisibleByDefault(I));
    FButtons[I].DefaultIndex := I;
  end;
end;

procedure TcxCustomNavigatorButtons.DestroyButtons;
var
  I: Integer;
begin
  for I := 0 to NavigatorButtonCount - 1 do
    FButtons[I].Free;
end;

procedure TcxCustomNavigatorButtons.DoButtonClick(ADefaultIndex: Integer);
begin
end;

function TcxCustomNavigatorButtons.GetButtonEnabled(ADefaultIndex: Integer): Boolean;
begin
  Result := IsNavigatorEnabled;
end;

function TcxCustomNavigatorButtons.GetButtonHint(ADefaultIndex: Integer): string;
begin
  case ADefaultIndex of
    NBDI_FIRST: Result := cxGetResourceString(@cxNavigatorHint_First);
    NBDI_PRIORPAGE: Result := cxGetResourceString(@cxNavigatorHint_PriorPage);
    NBDI_PRIOR: Result := cxGetResourceString(@cxNavigatorHint_Prior);
    NBDI_LAST: Result := cxGetResourceString(@cxNavigatorHint_Last);
    NBDI_NEXT: Result := cxGetResourceString(@cxNavigatorHint_Next);
    NBDI_NEXTPAGE: Result := cxGetResourceString(@cxNavigatorHint_NextPage);
    NBDI_INSERT: Result := cxGetResourceString(@cxNavigatorHint_Insert);
    NBDI_APPEND: Result := cxGetResourceString(@cxNavigatorHint_Append);
    NBDI_DELETE: Result := cxGetResourceString(@cxNavigatorHint_Delete);
    NBDI_EDIT: Result := cxGetResourceString(@cxNavigatorHint_Edit);
    NBDI_POST: Result := cxGetResourceString(@cxNavigatorHint_Post);
    NBDI_CANCEL: Result := cxGetResourceString(@cxNavigatorHint_Cancel);
    NBDI_REFRESH: Result := cxGetResourceString(@cxNavigatorHint_Refresh);
    NBDI_SAVEBOOKMARK: Result := cxGetResourceString(@cxNavigatorHint_SaveBookmark);
    NBDI_GOTOBOOKMARK: Result := cxGetResourceString(@cxNavigatorHint_GotoBookmark);
    NBDI_FILTER: Result := cxGetResourceString(@cxNavigatorHint_Filter);
    else Result := '';
  end;
end;

function TcxCustomNavigatorButtons.GetButtonImageOffset: Integer;
begin
  Result := 2;
end;

function TcxCustomNavigatorButtons.GetButton(Index: Integer): TcxNavigatorButton;
begin
  Result := FButtons[Index];
end;

function TcxCustomNavigatorButtons.GetButtonCount: Integer;
begin
  Result := High(FButtons) - Low(FButtons) + 1;
end;

function TcxCustomNavigatorButtons.GetDefaultImages: TCustomImageList;
begin
  Result := NavigatorImages;
end;

procedure TcxCustomNavigatorButtons.SetButton(Index: Integer; const Value: TcxNavigatorButton);
begin
  FButtons[Index].Assign(Value);
end;

procedure TcxCustomNavigatorButtons.SetConfirmDelete(const Value: Boolean);
begin
  if FConfirmDelete <> Value then
  begin
    FConfirmDelete := Value;
    Changed(nctProperties);
  end;
end;

procedure TcxCustomNavigatorButtons.SetImages(const Value: TCustomImageList);
begin
  cxSetImageList(Value, FImages, FImageChangeLink, Navigator.GetNavigatorOwner);
  Changed(nctLayout);
end;

procedure TcxCustomNavigatorButtons.SetOnButtonClick(
  const Value: TcxNavigatorButtonClickEvent);
begin
  FOnButtonClick := Value;
  Changed(nctProperties);
end;

procedure TcxCustomNavigatorButtons.ImageListChange(Sender: TObject);
begin
  Changed(nctProperties, True);
end;

{ TcxCustomNavigatorInfoPanel }

constructor TcxCustomNavigatorInfoPanel.Create(ANavigator: IcxNavigatorOwner);
begin
  inherited Create(ANavigator);
  FVisible := False;
  DisplayMask := cxNavigatorInfoPanelDefaultDisplayMask;
end;

procedure TcxCustomNavigatorInfoPanel.Assign(Source: TPersistent);
begin
  if Source is TcxCustomNavigatorInfoPanel then
    with TcxCustomNavigatorInfoPanel(Source) do
    begin
      Self.DisplayMask := DisplayMask;
      Self.Visible := Visible;
      Self.OnClick := OnClick;
    end
  else
    inherited Assign(Source);
end;

procedure TcxCustomNavigatorInfoPanel.BuildFormatString;
begin
  FFormatString := cxGetNavigatorFormatString(FDisplayMask, FIsNeedRecordIndex,
    FIsNeedRecordCount);
end;

procedure TcxCustomNavigatorInfoPanel.DoClick;
begin
  if Assigned(FOnClick) then
    FOnClick(Self);
end;

function TcxCustomNavigatorInfoPanel.GetFormattedText: string;
var
  ARecordIndex, ARecordCount: string;
begin
  if (IRecordPosition = nil) or (IRecordPosition.GetRecordCount = 0) then
  begin
    Result := '';
    Exit;
  end;
  if IsNeedRecordIndex then
    ARecordIndex := IntToStr(IRecordPosition.GetRecordIndex + 1)
  else
    ARecordIndex := '';
  if IsNeedRecordCount then
    ARecordCount := IntToStr(IRecordPosition.GetRecordCount)
  else
    ARecordCount := '';
  Result := Format(FFormatString, [ARecordIndex, ARecordCount]);
end;

function TcxCustomNavigatorInfoPanel.GetIRecordPosition: IcxNavigatorRecordPosition;
begin
  if Assigned(FOnGetIRecordPosition) then
    Result := FOnGetIRecordPosition
  else
    Result := nil;
end;

function TcxCustomNavigatorInfoPanel.IsDisplayMaskStored: Boolean;
begin
  Result := cxNavigatorInfoPanelDefaultDisplayMask <> DisplayMask;
end;

procedure TcxCustomNavigatorInfoPanel.SetDisplayMask(const Value: string);
begin
  if FDisplayMask <> Value then
  begin
    FDisplayMask := Value;
    BuildFormatString;
    Changed(nctSize, True);
  end;
end;

procedure TcxCustomNavigatorInfoPanel.SetVisible(Value: Boolean);
begin
  if FVisible <> Value then
  begin
    FVisible := Value;
    Changed(nctSize, True);
  end;
end;

{ TcxCustomNavigatorInfoPanelViewInfo }

constructor TcxCustomNavigatorInfoPanelViewInfo.Create(ANavigatorViewInfo: TcxNavigatorViewInfo);
begin
  inherited Create;
  FNavigatorViewInfo := ANavigatorViewInfo;
end;

function TcxCustomNavigatorInfoPanelViewInfo.GetNavigatorOwner: IcxNavigatorOwner2;
begin
  Result := FNavigatorViewInfo.NavigatorOwner2;
end;

procedure TcxCustomNavigatorInfoPanelViewInfo.Calculate(const ABounds: TRect; const AText: string);
begin
  FBounds := ABounds;
  FText := AText;
end;

procedure TcxCustomNavigatorInfoPanelViewInfo.Paint;
var
  ACanvas: TcxCanvas;
  APainter: TcxCustomLookAndFeelPainterClass;
  R: TRect;
  AViewParams: TcxViewParams;
begin
  ACanvas := NavigatorViewInfo.Canvas;
  APainter := NavigatorOwner.GetNavigatorLookAndFeel.Painter;
  AViewParams := NavigatorOwner.GetNavigatorInfoPanel.GetViewParams;
  R := Bounds;
  InflateRect(R, -APainter.BorderSize, -APainter.BorderSize);
  ACanvas.FillRect(R, AViewParams);
  ACanvas.Brush.Style := bsClear;
  ACanvas.Font := AViewParams.Font;
  ACanvas.Font.Color := AViewParams.TextColor;
  ACanvas.DrawTexT(FText, FBounds, cxSingleLine or cxAlignCenter);
  ACanvas.Brush.Style := bsSolid;
end;

{ TcxNavigatorViewInfo }

constructor TcxNavigatorViewInfo.Create(
  ANavigator: IcxNavigatorOwner;
  AIsInplace: Boolean = True);
begin
  inherited Create;
  FNavigatorOwner := ANavigator;
  FIsDirty := True;
  FIsInplace := AIsInplace;
  FButtons := TList.Create;
  FHintWindowShowing := False;
  FButtonPressTimer := TcxTimer.Create(nil);
  FButtonPressTimer.Enabled := False;
  FButtonPressTimer.OnTimer := DoButtonPressTimer;
  FHintTimer := TcxTimer.Create(nil);
  FHintTimer.Enabled := False;
  FHintTimer.Interval := 500;
  FHintTimer.OnTimer := DoHintTimer;
  FCanvas := TcxCanvas.Create(nil);
  Supports(ANavigator, IcxNavigatorOwner2, FNavigatorOwner2);
  FInfoPanelViewInfo := TcxCustomNavigatorInfoPanelViewInfo.Create(Self);
end;

destructor TcxNavigatorViewInfo.Destroy;
begin
  FreeAndNil(FInfoPanelViewInfo);
  FreeAndNil(FCanvas);
  FreeAndNil(FHintTimer);
  FreeAndNil(FButtonPressTimer);
  FreeAndNil(FHintWindow);
  Clear;
  FreeAndNil(FButtons);
  inherited Destroy;
end;

procedure TcxNavigatorViewInfo.Calculate;
var
  AHeight, AWidth: Integer;
  I: Integer;
  ANavigatorBounds: TRect;
begin
  ANavigatorBounds := NavigatorOwner.GetNavigatorBounds;
  with ANavigatorBounds do
  begin
    AWidth := Right - Left;
    AHeight := Bottom - Top;
  end;
  CheckSize(AWidth, AHeight);
  for I := 0 to ButtonCount - 1 do
  begin
    Buttons[I].Enabled := Buttons[I].Button.GetInternalEnabled;
    Buttons[I].Hint := Buttons[I].Button.GetInternalHint;
  end;
  FIsDirty := False;
end;

procedure TcxNavigatorViewInfo.CheckSize(var AWidth, AHeight: Integer;
  ACheckMinHeight: Boolean = False);

  procedure CheckButtonCount;
  var
    APButtonViewInfo: TcxNavigatorButtonViewInfo;
    AVisibleButtonCount, I: Integer;
  begin
    AVisibleButtonCount := GetVisibleButtonCount;
    if AVisibleButtonCount < FButtons.Count then
      for I := 1 to FButtons.Count - AVisibleButtonCount do
      begin
        TcxNavigatorButtonViewInfo(FButtons[AVisibleButtonCount]).Free;
        FButtons.Delete(AVisibleButtonCount);
      end
    else
      for I := FButtons.Count to AVisibleButtonCount - 1 do
      begin
        APButtonViewInfo := TcxNavigatorButtonViewInfo.Create;
        FButtons.Add(APButtonViewInfo);
      end;
  end;

var
  AButtonViewInfo: TcxNavigatorButtonViewInfo;
  AButtonVisibleIndex, AMinWidth, AMinHeight, ADifX: Integer;
  AInfoPanelSize, AMinSize: TSize;
  ANavigatorBounds, AButtonBounds: TRect;
  ANavigatorButtons: TcxCustomNavigatorButtons;
  I, AVisibleButtonCount, AInfoPanelInsertionPos: Integer;
  AHotTrackButton, APressedButton: TcxNavigatorButton;
  AInfoPanelText: string;
begin
  ANavigatorBounds := NavigatorOwner.GetNavigatorBounds;

  FIsDirty := True;
  AHotTrackButton := nil;
  APressedButton := nil;
  if FHotTrackButtonViewInfo <> nil then
    AHotTrackButton := FHotTrackButtonViewInfo.Button;
  if FPressedButtonViewInfo <> nil then
    APressedButton := FPressedButtonViewInfo.Button;
  FHotTrackButtonViewInfo := nil;
  FPressedButtonViewInfo := nil;
  AInfoPanelText := GetInfoPanelText;
  AInfoPanelSize := GetInfoPanelSize(AInfoPanelText);
  AMinWidth := AInfoPanelSize.cx;
  AMinHeight := AInfoPanelSize.cy;
  ANavigatorButtons := NavigatorOwner.GetNavigatorButtons;
  AVisibleButtonCount := GetVisibleButtonCount;
  CheckButtonCount;
  AButtonVisibleIndex := 0;
  AInfoPanelInsertionPos := -1;
  for I := 0 to  ANavigatorButtons.ButtonCount - 1 do
    if ANavigatorButtons[I].Visible then
    begin
      AButtonViewInfo := TcxNavigatorButtonViewInfo(FButtons[AButtonVisibleIndex]);
      AButtonViewInfo.Button := ANavigatorButtons[I];
      if AButtonViewInfo.Button = APressedButton then
        FPressedButtonViewInfo := AButtonViewInfo;
      if AButtonViewInfo.Button = AHotTrackButton then
        FHotTrackButtonViewInfo := AButtonViewInfo;
      AMinSize := GetMinButtonSize(AButtonVisibleIndex, AVisibleButtonCount,
        ACheckMinHeight);
      Inc(AMinWidth, AMinSize.cx);
      if AMinHeight < AMinSize.cy then
        AMinHeight := AMinSize.cy;
      if (AInfoPanelInsertionPos < 0) and (ANavigatorButtons[I].DefaultIndex >= NBDI_NEXT) then
        AInfoPanelInsertionPos := AButtonVisibleIndex;
      Inc(AButtonVisibleIndex);
    end;
  ADifX := 0;
  if AHeight < AMinHeight then
    AHeight := AMinHeight;

  if AWidth < AMinWidth then
    AWidth := AMinWidth
  else
  begin
    if ButtonCount > 0 then
      ADifX := (AWidth - AMinWidth) div ButtonCount;
    AWidth := AMinWidth + ADifX * ButtonCount;
  end;
  AButtonBounds.Right := ANavigatorBounds.Left;
  AButtonBounds.Top := ANavigatorBounds.Top;
  AButtonBounds.Bottom := AButtonBounds.Top + AHeight;
  if (ButtonCount = 0) and HasInfoPanel then
    FInfoPanelViewInfo.Calculate(ANavigatorBounds, GetInfoPanelText)
  else
  begin
    for I := 0 to ButtonCount - 1 do
    begin
      if (I = AInfoPanelInsertionPos) and (AInfoPanelText <> '') then
      begin
        AButtonBounds.Left := AButtonBounds.Right;
        AButtonBounds.Right := AButtonBounds.Right + AInfoPanelSize.cx;
        FInfoPanelViewInfo.Calculate(AButtonBounds, AInfoPanelText);
      end;
      AButtonBounds.Left := AButtonBounds.Right;
      AButtonBounds.Right := AButtonBounds.Right + GetMinButtonSize(I, AVisibleButtonCount).cx + ADifX;
      Buttons[I].Bounds := AButtonBounds;
    end;
  end;
end;

procedure TcxNavigatorViewInfo.Clear;
var
  I: Integer;
begin
  FIsDirty := True;
  FInfoPanelPressed := False;
  FHotTrackButtonViewInfo := nil;
  FPressedButtonViewInfo := nil;
  for I := 0 to ButtonCount - 1 do
    TcxNavigatorButtonViewInfo(FButtons[I]).Free;
  FButtons.Clear;
end;

procedure TcxNavigatorViewInfo.DoEnter;
begin
  InvalidateButton(FocusedButton);
  UpdateSelected;
end;

procedure TcxNavigatorViewInfo.DoExit;
begin
  InvalidateButton(FocusedButton);
  UpdateSelected;
end;

function TcxNavigatorViewInfo.GetButtonAt(const pt: TPoint): TcxNavigatorButton;
var
  AViewInfo: TcxNavigatorButtonViewInfo;
begin
  AViewInfo := GetButtonViewInfoAt(pt);
  if AViewInfo <> nil then
    Result := AViewInfo.Button
  else
    Result := nil;
end;

function TcxNavigatorViewInfo.GetButtonViewInfoAt(const pt: TPoint): TcxNavigatorButtonViewInfo;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to ButtonCount - 1 do
    if PtInRect(Buttons[I].Bounds, pt) then
    begin
      Result := Buttons[I];
      Break;
    end;
end;

function TcxNavigatorViewInfo.GetButtonViewInfoByButton(
  AButton: TcxNavigatorButton): TcxNavigatorButtonViewInfo;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to ButtonCount - 1 do
    if Buttons[I].Button = AButton then
    begin
      Result := Buttons[I];
      break;
    end;
end;

procedure TcxNavigatorViewInfo.MakeIsDirty;
begin
  FIsDirty := True;
end;

procedure TcxNavigatorViewInfo.MouseDown(X, Y: Integer);
var
  AButtonViewInfo: TcxNavigatorButtonViewInfo;
begin
  FHintTimer.Enabled := False;
  HintActivate(False);
  FInfoPanelPressed := HasInfoPanel and
    cxRectPtIn(InfoPanelViewInfo.Bounds, X, Y);
  if not FInfoPanelPressed then
  begin
    AButtonViewInfo := GetButtonViewInfoAt(Point(X, Y));
    if (AButtonViewInfo <> nil) and (GetButtonState(AButtonViewInfo) <> cxbsDisabled) then
    begin
      FButtonPressTimer.Interval := cxInitRepeatPause;
      FButtonPressTimer.Enabled := True;
      PressedButtonViewInfo := AButtonViewInfo;
      FocusedButton := AButtonViewInfo;
      InvalidateButton(PressedButtonViewInfo);
    end;
  end;
  UpdateSelected;
end;

procedure TcxNavigatorViewInfo.MouseMove(X, Y: Integer);
var
  AButtonViewInfo: TcxNavigatorButtonViewInfo;
begin
  AButtonViewInfo := GetButtonViewInfoAt(Point(X, Y));
  if AButtonViewInfo <> HotTrackButtonViewInfo then
  begin
    if (HotTrackButtonViewInfo <> nil)
      and (GetButtonState(HotTrackButtonViewInfo) <> cxbsDisabled) then
      InvalidateButton(HotTrackButtonViewInfo);
    FHotTrackButtonViewInfo := AButtonViewInfo;
    if (HotTrackButtonViewInfo <> nil)
      and (GetButtonState(HotTrackButtonViewInfo) <> cxbsDisabled) then
      InvalidateButton(HotTrackButtonViewInfo);
    if FHintWindowShowing then
      HintActivate(True)
    else FHintTimer.Enabled := True;
  end;
  if HotTrackButtonViewInfo = nil then
    HintActivate(False);
  UpdateSelected;
end;

procedure TcxNavigatorViewInfo.MouseUp(X, Y: Integer);
var
  AButtonViewInfo: TcxNavigatorButtonViewInfo;
begin
  FButtonPressTimer.Enabled := False;
  if FInfoPanelPressed then
  begin
    FInfoPanelPressed := False;
    if cxRectPtIn(InfoPanelViewInfo.Bounds, X, Y) then
      NavigatorOwner2.GetNavigatorInfoPanel.DoClick;
  end;
  AButtonViewInfo := PressedButtonViewInfo;
  FPressedButtonViewInfo := nil;
  InvalidateButton(AButtonViewInfo);
  FHintTimer.Enabled := True;
  UpdateSelected;
  if (AButtonViewInfo <> nil) and PtInRect(AButtonViewInfo.Bounds, Point(X, Y)) and AButtonViewInfo.Enabled then
    AButtonViewInfo.Button.DoClick;
end;

procedure TcxNavigatorViewInfo.Paint;
var
  R: TRect;
  I: Integer;
  ANavigatorControl: TWinControl;
begin
  if FIsDirty then
    Calculate;
  for I := 0 to ButtonCount - 1 do
    PaintButton(I);
  R := NavigatorOwner.GetNavigatorBounds;
  ANavigatorControl := NavigatorOwner.GetNavigatorControl;
  NavigatorOwner.GetNavigatorLookAndFeel.GetAvailablePainter(totButton).DrawButtonGroupBorder(Canvas,
    R, FIsInplace and ANavigatorControl.Enabled, FIsSelected or (not FIsInplace and
      (csDesigning in ANavigatorControl.ComponentState) and ANavigatorControl.Enabled));
  if HasInfoPanel then
    InfoPanelViewInfo.Paint;
  if FIsInplace then
    Canvas.ExcludeClipRect(R);
end;

procedure TcxNavigatorViewInfo.PressArrowKey(ALeftKey: Boolean);
var
  AIndex: Integer;
begin
  AIndex := FButtons.IndexOf(FocusedButton);
  if AIndex < 0 then exit;
  if ALeftKey then
  begin
    if AIndex > 0 then
      FocusedButton := Buttons[AIndex - 1];
  end else
  begin
    if AIndex < ButtonCount - 1 then
      FocusedButton := Buttons[AIndex + 1];
  end;
end;

procedure TcxNavigatorViewInfo.Update;
var
  ANewText: string;
  ANavigatorControl: TWinControl;
  ASaveSize: TSize;
begin
  ANavigatorControl := NavigatorOwner.GetNavigatorControl;
  if ANavigatorControl.HandleAllocated and HasInfoPanel then
  begin
    ANewText := GetInfoPanelText;
    if ANewText <> InfoPanelViewInfo.Text then
    begin
      ASaveSize := GetInfoPanelSize(InfoPanelViewInfo.Text);
      if not cxSizeIsEqual(ASaveSize, GetInfoPanelSize(ANewText)) then
      begin
        NavigatorOwner.RefreshNavigator;
        Exit;
      end;
      InfoPanelViewInfo.Calculate(InfoPanelViewInfo.Bounds, ANewText);
    end;
    Windows.InvalidateRect(ANavigatorControl.Handle, @(InfoPanelViewInfo.FBounds), False);
  end;
  UpdateButtonsEnabled;
end;

procedure TcxNavigatorViewInfo.UpdateButtonsEnabled;
var
  I: Integer;
begin
  for I := 0 to ButtonCount - 1 do
    if Buttons[I].Enabled <> Buttons[I].Button.GetInternalEnabled then
    begin
      Buttons[I].Enabled := not Buttons[I].Enabled;
      InvalidateButton(Buttons[I]);
    end;
end;

procedure TcxNavigatorViewInfo.InvalidateButton(AButton: TcxNavigatorButtonViewInfo);
var
  ANavigatorControl: TWinControl;
begin
  if AButton <> nil then
  begin
    ANavigatorControl := NavigatorOwner.GetNavigatorControl;
    if ANavigatorControl.HandleAllocated then
      Windows.InvalidateRect(ANavigatorControl.Handle,
        @(AButton.Bounds), False);
  end;
end;

procedure TcxNavigatorViewInfo.PaintButton(AButtonIndex: Integer);

  procedure DrawButtonGlyph(ACanvas: TcxCanvas; const AGlyphRect: TRect);
  var
    AButton: TcxNavigatorButtonViewInfo;
    AButtonState: TcxButtonState;
    APainter: TcxCustomLookAndFeelPainterClass;
  begin
    AButton := TcxNavigatorButtonViewInfo(FButtons[AButtonIndex]);
    AButtonState := GetButtonState(AButton);
    APainter := NavigatorOwner.GetNavigatorLookAndFeel.GetAvailablePainter(totButton);
    APainter.DrawNavigatorGlyph(ACanvas, AButton.Button.InternalImages,
        AButton.Button.InternalImageIndex, AButtonIndex, AGlyphRect,
        AButtonState <> cxbsDisabled, AButton.Button.IsUserImageListUsed);
  end;

var
  ABitmap: TcxBitmap;
  AButton: TcxNavigatorButtonViewInfo;
  AButtonBounds, AContentRect, AImageRect, R1: TRect;
  AButtonState: TcxButtonState;
  AImageSize: TSize;
  APainter: TcxCustomLookAndFeelPainterClass;
  ACanvas: TcxCanvas;
begin
  AButton := TcxNavigatorButtonViewInfo(FButtons[AButtonIndex]);
  AButtonBounds := AButton.Bounds;
  if not Canvas.RectVisible(AButtonBounds) then
    Exit;
  AButtonState := GetButtonState(AButton);
  APainter := NavigatorOwner.GetNavigatorLookAndFeel.GetAvailablePainter(totButton);
  AButtonBounds := APainter.AdjustGroupButtonDisplayRect(AButtonBounds, FButtons.Count, AButtonIndex);
  AImageSize := AButton.Button.GetImageSize;
  AContentRect := AButtonBounds;
  ExtendRect(AContentRect, GetButtonBorderExtent(APainter, AButtonIndex, FButtons.Count));
  with AContentRect do
  begin
    AImageRect.Left := Left + (Right - Left - AImageSize.cx) div 2;
    AImageRect.Top := Top + (Bottom - Top - AImageSize.cy) div 2;
    AImageRect.Right := AImageRect.Left + AImageSize.cx;
    AImageRect.Bottom := AImageRect.Top + AImageSize.cy;
    if GetButtonState(AButton) = cxbsPressed then
      OffsetRect(AImageRect, 1, 1);
  end;

  ABitmap := TcxBitmap.CreateSize(AButtonBounds, pf32bit);
  try
    ACanvas := ABitmap.cxCanvas;
    cxDrawTransparentControlBackground(NavigatorOwner.GetNavigatorControl, ACanvas,
      AButtonBounds);
    APainter.DrawButtonInGroup(ACanvas, ABitmap.ClientRect,
      AButtonState, FButtons.Count, AButtonIndex, clWindow);

    R1 := AImageRect;
    OffsetRect(R1, - AButtonBounds.Left, - AButtonBounds.Top);
    DrawButtonGlyph(ACanvas, R1);
    cxBitBlt(Canvas.Handle, ACanvas.Handle, AButtonBounds, cxNullPoint, SRCCOPY);

    if NavigatorOwner.GetNavigatorTabStop and (AButton = FocusedButton) and
       NavigatorOwner.GetNavigatorFocused
    then
       Canvas.DrawFocusRect(AImageRect);

    if APainter = TcxWinXPLookAndFeelPainter then
     Canvas.ExcludeClipRect(AButton.Bounds);
  finally
    FreeAndNil(ABitmap);
  end;
end;

function TcxNavigatorViewInfo.HasInfoPanel: Boolean;
begin
  Result := (NavigatorOwner2 <> nil) and
   (NavigatorOwner2.GetNavigatorInfoPanel <> nil) and
    NavigatorOwner2.GetNavigatorInfoPanel.Visible;
end;

procedure TcxNavigatorViewInfo.HintActivate(AShow: Boolean);

  function NeedShowHint(const AHint: string): Boolean;
  begin
    Result := AShow and NavigatorOwner.GetNavigatorShowHint and (AHint <> '') and
      CanShowHint(NavigatorOwner.GetNavigatorControl);
  end;

var
  AHint: string;
  P: TPoint;
  R: TRect;
begin
  if FHintWindow <> nil then
  begin
    FHintWindow.Hide;
    if IsWindowVisible(FHintWindow.Handle) then
      ShowWindow(FHintWindow.Handle, SW_HIDE);
    FreeAndNil(FHintWindow);
  end;
  FHintTimer.Enabled := False;
  FHintWindowShowing := False;
  if (HotTrackButtonViewInfo <> nil) then
    AHint := GetShortHint(HotTrackButtonViewInfo.Hint)
  else
    AHint := '';
  if NeedShowHint(AHint) then
  begin
    FHintWindow := HintWindowClass.Create(nil);
    P := InternalGetCursorPos;
    Inc(P.Y, cxGetCursorSize.cy);
    R := FHintWindow.CalcHintRect(Screen.Width, AHint, nil);
    R := Rect(P.X, P.Y, P.X + R.Right, P.Y + R.Bottom - R.Top);
    FHintWindow.Color := Application.HintColor;
  {$IFDEF DELPHI7}
    FHintWindow.ParentWindow := Application.Handle; //Bug in delphi7 and higher
  {$ENDIF}
    cxActivateHint(FHintWindow, R, AHint);
    FHintWindowShowing := True;
  end;
end;

function TcxNavigatorViewInfo.GetButton(Index: Integer): TcxNavigatorButtonViewInfo;
begin
  Result := TcxNavigatorButtonViewInfo(FButtons[Index]);
end;

function TcxNavigatorViewInfo.GetButtonCount: Integer;
begin
  Result := FButtons.Count;
end;

function TcxNavigatorViewInfo.GetCanvas: TcxCanvas;
begin
  FCanvas.Canvas := NavigatorOwner.GetNavigatorCanvas;
  Result := FCanvas;
end;

function TcxNavigatorViewInfo.GetFocusedButton: TcxNavigatorButtonViewInfo;
begin
  if (FFocusedButton <> nil) and not FFocusedButton.Visible then
    FFocusedButton := nil;
  if (FFocusedButton = nil) and (ButtonCount > 0) then
    FFocusedButton := Buttons[0].Button;
  if (FFocusedButton <> nil) then
    Result := GetButtonViewInfoByButton(FFocusedButton)
  else Result := nil;
end;

procedure TcxNavigatorViewInfo.SetFocusedButton(Value: TcxNavigatorButtonViewInfo);
var
  AOldButtonViewInfo: TcxNavigatorButtonViewInfo;
begin
  AOldButtonViewInfo := GetFocusedButton;
  if AOldButtonViewInfo <> Value then
  begin
    FFocusedButton := Value.Button;
    InvalidateButton(AOldButtonViewInfo);
    InvalidateButton(Value);
  end;
end;

function TcxNavigatorViewInfo.StopButtonPressTimerIfLeftMouseReleased: Boolean;
begin
  if not (ssLeft in InternalGetShiftState) then
  begin
    FButtonPressTimer.Enabled := False;
    MouseUp(-1, -1);
    Result := True;
  end
  else
    Result := False;
end;

function TcxNavigatorViewInfo.GetButtonBorderExtent(APainter: TcxCustomLookAndFeelPainterClass;
  AButtonIndex, AButtonCount: Integer): TRect;
begin
  Result := APainter.ButtonGroupBorderSizes(AButtonCount, AButtonIndex);
end;

function TcxNavigatorViewInfo.GetButtonState(AButton: TcxNavigatorButtonViewInfo): TcxButtonState;
begin
  Result := cxbsNormal;
  if not AButton.Enabled then
    Result := cxbsDisabled
  else
    if (AButton = PressedButtonViewInfo)
      and (AButton = HotTrackButtonViewInfo) then
      Result := cxbsPressed
    else
      if AButton = HotTrackButtonViewInfo then
        Result := cxbsHot;
end;

function TcxNavigatorViewInfo.GetInfoPanelFont: TFont;
begin
  Result := NavigatorOwner2.GetNavigatorInfoPanel.GetViewParams.Font;
end;

function TcxNavigatorViewInfo.GetInfoPanelText: string;
begin
  if HasInfoPanel then
    Result := NavigatorOwner2.GetNavigatorInfoPanel.GetFormattedText
  else
    Result := '';
end;

function TcxNavigatorViewInfo.GetInfoPanelSize(AText: string): TSize;
var
  I: Integer;
begin
  if HasInfoPanel and (AText <> '') then
  begin
    for I := 1 to Length(AText) do
      if (AText[I] >= '0') and (AText[I] <= '9') then
        AText[I] := '0';
    Result := cxTextExtent(GetInfoPanelFont, AText + '00');
  end
  else
    Result := cxNullSize;
end;

function TcxNavigatorViewInfo.GetMiddleButtonBorderExtent(
  APainter: TcxCustomLookAndFeelPainterClass): TRect;
begin
  Result := APainter.ButtonGroupBorderSizes(3, 1);
end;

function TcxNavigatorViewInfo.GetMinButtonSize(
  AButtonIndex, AButtonCount: Integer; AAutoHeight: Boolean = False): TSize;
var
  AButtonBorderExtent: TRect;
  APainter: TcxCustomLookAndFeelPainterClass;
begin
  Result := TcxNavigatorButtonViewInfo(FButtons[AButtonIndex]).Button.GetImageSize;
  APainter := NavigatorOwner.GetNavigatorLookAndFeel.GetAvailablePainter(totButton);
  AButtonBorderExtent := GetMiddleButtonBorderExtent(APainter);
  Result.cx := Result.cx + AButtonBorderExtent.Left + AButtonBorderExtent.Right + 1;
  if AAutoHeight then
    Result.cy := Result.cy + AButtonBorderExtent.Top + AButtonBorderExtent.Bottom + 1
  else
    Result.cy := AButtonBorderExtent.Top + AButtonBorderExtent.Bottom + 1;
end;

function TcxNavigatorViewInfo.GetVisibleButtonCount: Integer;
var
  ANavigatorButtons: TcxCustomNavigatorButtons;
  I: Integer;
begin
  Result := 0;
  ANavigatorButtons := NavigatorOwner.GetNavigatorButtons;
  for I := 0 to  ANavigatorButtons.ButtonCount - 1 do
    if ANavigatorButtons[I].Visible then
      Inc(Result);
end;

procedure TcxNavigatorViewInfo.DoButtonPressTimer(Sender: TObject);
begin
  if StopButtonPressTimerIfLeftMouseReleased then
    Exit;
  FButtonPressTimer.Interval := cxRepeatPause;
  if (HotTrackButtonViewInfo <> nil) and (HotTrackButtonViewInfo = PressedButtonViewInfo) and
      PressedButtonViewInfo.Enabled and (PressedButtonViewInfo.Button.DefaultIndex in [NBDI_PRIOR, NBDI_NEXT]) then
    try
      PressedButtonViewInfo.Button.DoClick;
    except
      FButtonPressTimer.Enabled := False;
      raise;
    end;
end;

procedure TcxNavigatorViewInfo.DoHintTimer(Sender: TObject);
begin
  HintActivate(True);
end;

procedure TcxNavigatorViewInfo.UpdateSelected;
var
  AIsSelected: Boolean;
  ANavigatorControl: TWinControl;
  R1, R2: TRect;
begin
  if not NavigatorOwner.GetNavigatorLookAndFeel.Painter.IsButtonHotTrack then
    Exit;
  ANavigatorControl := NavigatorOwner.GetNavigatorControl;
  AIsSelected := (HotTrackButtonViewInfo <> nil) or (PressedButtonViewInfo <> nil) or
    NavigatorOwner.GetNavigatorFocused or
    (not FIsInplace and HasInfoPanel and ANavigatorControl.HandleAllocated and
    PtInRect(InfoPanelViewInfo.Bounds, ANavigatorControl.ScreenToClient(GetMouseCursorPos)));
  if (AIsSelected <> FIsSelected) and ANavigatorControl.HandleAllocated then
  begin
    FIsSelected := AIsSelected;
    R1 := NavigatorOwner.GetNavigatorBounds;
    R2 := R1;
    InflateRect(R2, -1, -1);
    InternalInvalidate(ANavigatorControl.Handle, R1, R2, False);
  end;
end;

{ TcxCustomNavigator }

constructor TcxCustomNavigator.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle - [csAcceptsControls, csSetCaption] + [csOpaque];
  FButtons := CreateButtons;
  FInfoPanel := CreateInfoPanel;
  FViewInfo := GetViewInfoClass.Create(Self, False);
  TabStop := False;
  Height := 25;
end;

destructor TcxCustomNavigator.Destroy;
begin
  EndMouseTracking(Self);
  FreeAndNil(FViewInfo);
  FreeAndNil(FButtons);
  FreeAndNil(FInfoPanel);
  inherited Destroy;
end;

procedure TcxCustomNavigator.ClickButton(Index: Integer);
begin
  CustomButtons.ClickButton(Index);
end;

procedure TcxCustomNavigator.RestoreButtons;
var
  I: Integer;
begin
  with CustomButtons do
    for I := 0 to ButtonCount - 1 do
      FButtons[I].FIsVisibleAssigned := False;
  InitButtons;
end;

function TcxCustomNavigator.CanFocusOnClick: Boolean;
begin
  Result := inherited CanFocusOnClick and TabStop;
end;

function TcxCustomNavigator.CanResize(var NewWidth, NewHeight: Integer): Boolean;
begin
  Result := inherited CanResize(NewWidth, NewHeight);
  if Result and (FViewInfo <> nil) and HandleAllocated then
    FViewInfo.CheckSize(NewWidth, NewHeight);
end;

function TcxCustomNavigator.CreateButtons: TcxCustomNavigatorButtons;
begin
  Result := TcxCustomNavigatorButtons.Create(Self);
end;

procedure TcxCustomNavigator.Paint;
begin
  FViewInfo.Paint;
end;

procedure TcxCustomNavigator.DoEnter;
begin
  inherited DoEnter;
  FViewInfo.DoEnter;
end;

procedure TcxCustomNavigator.DoExit;
begin
  inherited DoExit;
  FViewInfo.DoExit;
end;

procedure TcxCustomNavigator.EnabledChanged;
begin
  RefreshNavigator;
end;

procedure TcxCustomNavigator.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited KeyDown(Key, Shift);
  if (Key = VK_LEFT) or (Key = VK_RIGHT) then
    FViewInfo.PressArrowKey(Key = VK_LEFT);
  if (Key = VK_SPACE) and (FViewInfo.FocusedButton <> nil)
    and FViewInfo.FocusedButton.Enabled then
    FViewInfo.FocusedButton.Button.DoClick;
end;

procedure TcxCustomNavigator.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseDown(Button, Shift, X, Y);
  if Button = mbLeft then
    FViewInfo.MouseDown(X, Y);
end;

procedure TcxCustomNavigator.MouseEnter(AControl: TControl);
begin
  inherited MouseEnter(AControl);
{$IFDEF DELPHI7}
  if IsDesigning then
    Exit;
{$ENDIF}
  BeginMouseTracking(Self, Bounds, Self);
end;

procedure TcxCustomNavigator.MouseLeave(AControl: TControl);
begin
  inherited MouseLeave(AControl);
{$IFDEF DELPHI7}
  if IsDesigning then
    Exit;
{$ENDIF}
  EndMouseTracking(Self);
  FViewInfo.MouseMove(-1, -1);
end;

procedure TcxCustomNavigator.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseMove(Shift, X, Y);
  FViewInfo.MouseMove(X, Y);
  BeginMouseTracking(Self, Bounds, Self);
end;

procedure TcxCustomNavigator.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseUp(Button, Shift, X, Y);
  FViewInfo.MouseUp(X, Y);
end;

procedure TcxCustomNavigator.LookAndFeelChanged(Sender: TcxLookAndFeel;
  AChangedValues: TcxLookAndFeelValues);
begin
  inherited LookAndFeelChanged(Sender, AChangedValues);
  RecreateWnd
end;

procedure TcxCustomNavigator.NavigatorMouseLeave;
begin
  FViewInfo.MouseMove(-1, -1);
end;

procedure TcxCustomNavigator.NavigatorChanged(AChangeType: TcxNavigatorChangeType);
begin
end;

function TcxCustomNavigator.GetNavigatorBounds: TRect;
begin
  Result := Rect(0, 0, ClientWidth, ClientHeight);
end;

function TcxCustomNavigator.GetNavigatorButtons: TcxCustomNavigatorButtons;
begin
  Result := CustomButtons;
end;

function TcxCustomNavigator.GetNavigatorCanvas: TCanvas;
begin
  Result := Canvas.Canvas;
end;

function TcxCustomNavigator.GetNavigatorControl: TWinControl;
begin
  Result := Self;
end;

function TcxCustomNavigator.GetNavigatorLookAndFeel: TcxLookAndFeel;
begin
  Result := LookAndFeel;
end;

function TcxCustomNavigator.GetNavigatorFocused: Boolean;
begin
  Result := Focused;
end;

function TcxCustomNavigator.GetNavigatorShowHint: Boolean;
begin
  Result := ShowHint;
end;

function TcxCustomNavigator.GetNavigatorTabStop: Boolean;
begin
  Result := TabStop;
end;

function TcxCustomNavigator.GetNavigatorInfoPanel: TcxCustomNavigatorInfoPanel;
begin
  Result := CustomInfoPanel;
end;

function TcxCustomNavigator.GetViewInfoClass: TcxNavigatorViewInfoClass;
begin
  Result := TcxNavigatorViewInfo;
end;

procedure TcxCustomNavigator.InitButtons;
var
  I: Integer;
begin
  for I := 0 to FButtons.ButtonCount - 1 do
    FButtons[I].RestoreDefaultVisible(True);
end;

function TcxCustomNavigator.GetNavigatorOwner: TComponent;
begin
  Result := Self;
end;

procedure TcxCustomNavigator.NavigatorStateChanged;
begin
  FViewInfo.Update;
end;

procedure TcxCustomNavigator.RefreshNavigator;
var
  AWidth, AHeight: Integer;
begin
  if not HandleAllocated then
    Exit;
  AWidth := Width;
  AHeight := Height;
  FViewInfo.CheckSize(AWidth, AHeight);
  if (AWidth <> Width) or (Height <> AHeight) then
    SetBounds(Left, Top, AWidth, AHeight)
  else
    Invalidate;
end;

procedure TcxCustomNavigator.CreateWnd;
begin
  inherited CreateWnd;
  RefreshNavigator;
end;

procedure TcxCustomNavigator.WndProc(var Message: TMessage);
begin
  if (FViewInfo <> nil) and (FViewInfo.FHintWindowShowing) then
    with Message do
      if ((Msg >= WM_KEYFIRST) and (Msg <= WM_KEYLAST)) or
        ((Msg = CM_ACTIVATE) or (Msg = CM_DEACTIVATE)) or
        (Msg = CM_APPKEYDOWN) or (Msg = CM_APPSYSCOMMAND) or
        (Msg = WM_COMMAND) or ((Msg > WM_MOUSEMOVE) and
        (Msg <= WM_MOUSELAST)) or (Msg = WM_NCMOUSEMOVE) then
         FViewInfo.HintActivate(False);
  inherited WndProc(Message);
end;

procedure TcxCustomNavigator.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  Message.Result := DLGC_WANTARROWS;
end;

procedure TcxCustomNavigator.CMEnabledChanged(var Message: TMessage);
begin
  inherited;
  EnabledChanged;
end;

procedure TcxCustomNavigator.CMHintShow(var Message: TCMHintShow);
begin
  Message.Result := 1;
end;

{ TcxNavigatorControlNotifier }

constructor TcxNavigatorControlNotifier.Create;
begin
  inherited Create;
  FList := TList.Create;
end;

destructor TcxNavigatorControlNotifier.Destroy;
begin
  FreeAndNil(FList);
  inherited Destroy;
end;

procedure TcxNavigatorControlNotifier.AddNavigator(ANavigator: IcxNavigatorOwner);
begin
  if FList.IndexOf(Pointer(ANavigator)) < 0 then
    FList.Add(Pointer(ANavigator));
end;

procedure TcxNavigatorControlNotifier.RemoveNavigator(ANavigator: IcxNavigatorOwner);
begin
  FList.Remove(Pointer(ANavigator));
end;

procedure TcxNavigatorControlNotifier.RefreshNavigatorButtons;
var
  I: Integer;
begin
  for I := 0 to FList.Count - 1 do
    IcxNavigatorOwner(FList[I]).NavigatorStateChanged;
end;

{ TcxNavigatorControlButtons }
procedure TcxNavigatorControlButtons.ReleaseBookmark;
var
  ANavigatorControl: IcxNavigator;
begin
  ANavigatorControl := Control;
  if (ANavigatorControl <> nil) and ANavigatorControl.IsBookmarkAvailable then
    ANavigatorControl.ClearBookmark;
end;

function TcxNavigatorControlButtons.GetControl: IcxNavigator;
begin
  if Assigned(FOnGetControl) then
    Result := FOnGetControl
  else
    Result := nil;
end;

procedure TcxNavigatorControlButtons.DoButtonClick(ADefaultIndex: Integer);
var
  ANavigatorControl: IcxNavigator;
begin
  ANavigatorControl := Control;
  if (ANavigatorControl <> nil) and ((ADefaultIndex <> NBDI_DELETE) or not ConfirmDelete or
      ((MessageDlg(cxGetResourceString(@cxNavigator_DeleteRecordQuestion),
        mtConfirmation, mbOKCancel, 0) = ID_OK))) then
    ANavigatorControl.DoAction(ADefaultIndex);
  FNavigator.NavigatorStateChanged;
end;

function TcxNavigatorControlButtons.GetButtonEnabled(ADefaultIndex: Integer): Boolean;
var
  ANavigatorControl: IcxNavigator;
begin
  ANavigatorControl := Control;
  Result := (ANavigatorControl <> nil) and IsNavigatorEnabled and
    (ANavigatorControl.IsActive or (ADefaultIndex = NBDI_FILTER));
  if Result then
    case ADefaultIndex of
      NBDI_FIRST, NBDI_PRIOR, NBDI_PRIORPAGE:
        Result := not ANavigatorControl.IsBof;
      NBDI_LAST, NBDI_NEXT, NBDI_NEXTPAGE:
        Result := not ANavigatorControl.IsEof;
      NBDI_INSERT:
        Result := ANavigatorControl.CanInsert;
      NBDI_APPEND:
        Result := ANavigatorControl.CanAppend;
      NBDI_DELETE:
        Result := ANavigatorControl.CanDelete;
      NBDI_EDIT:
        Result := ANavigatorControl.CanEdit and not ANavigatorControl.IsEditing;
      NBDI_POST, NBDI_CANCEL:
        Result := ANavigatorControl.IsEditing;
      NBDI_GOTOBOOKMARK:
        Result := ANavigatorControl.IsBookmarkAvailable;
    end;
end;

{ TcxNavigatorControlInfoPanel }

constructor TcxNavigatorControlInfoPanel.Create(ANavigator: IcxNavigatorOwner);
begin
  inherited Create(ANavigator);
  FFont := TFont.Create;
  FFont.Color := clDefault;
  FFont.OnChange := FontChanged;
end;

destructor TcxNavigatorControlInfoPanel.Destroy;
begin
  FreeAndNil(FFont);
  inherited Destroy;
end;

procedure TcxNavigatorControlInfoPanel.Assign(Source: TPersistent);
begin
  inherited Assign(Source);
  if Source is TcxNavigatorControlInfoPanel then
    Font := TcxNavigatorControlInfoPanel(Source).Font;
end;

procedure TcxNavigatorControlInfoPanel.FontChanged(Sender: TObject);
begin
  if Visible then
    Changed(nctSize, True);
end;

function TcxNavigatorControlInfoPanel.GetViewParams: TcxViewParams;
begin
  Result.Font := Font;
  Result.TextColor := Font.Color;
  Result.Bitmap := nil;
  Result.Color := Navigator.GetNavigatorLookAndFeel.Painter.DefaultGridDetailsSiteColor;
end;

procedure TcxNavigatorControlInfoPanel.SetFont(Value: TFont);
begin
  FFont.Assign(Value);
end;

{ TcxCustomNavigatorControl }

destructor TcxCustomNavigatorControl.Destroy;
begin
  Control := nil;
  inherited Destroy;
end;

function TcxCustomNavigatorControl.CreateButtons: TcxCustomNavigatorButtons;
begin
  Result := GetButtonsClass.Create(Self);
  TcxNavigatorControlButtons(Result).OnGetControl := GetIcxNavigator;
end;

function TcxCustomNavigatorControl.CreateInfoPanel: TcxCustomNavigatorInfoPanel;
begin
  Result := GetInfoPanelClass.Create(Self);
  Result.OnGetIRecordPosition := GetIRecordPosition;
end;

function TcxCustomNavigatorControl.GetButtonsClass: TcxNavigatorControlButtonsClass;
begin
  Result := TcxNavigatorControlButtons;
end;

function TcxCustomNavigatorControl.GetInfoPanelClass: TcxNavigatorControlInfoPanelClass;
begin
  Result := TcxNavigatorControlInfoPanel;
end;

function TcxCustomNavigatorControl.GetNavigatorInfoPanel: TcxCustomNavigatorInfoPanel;
begin
  if GetIRecordPosition <> nil then
    Result := inherited GetNavigatorInfoPanel
  else
    Result := nil;
end;

procedure TcxCustomNavigatorControl.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = Control) then
    Control := nil;
end;

procedure TcxCustomNavigatorControl.InitButtons;
var
  ANavigator: IcxNavigator;
  I: Integer;
begin
  if FControl = nil then
  begin
    for I := 0 to FButtons.ButtonCount - 1 do
      FButtons[I].RestoreDefaultVisible(True);
  end
  else
  begin
    Supports(FControl, IcxNavigator, ANavigator);
    for I := 0 to FButtons.ButtonCount - 1 do
      FButtons[I].RestoreDefaultVisible(ANavigator.IsActionSupported(FButtons[I].DefaultIndex));
  end;
end;

function TcxCustomNavigatorControl.GetButtons: TcxNavigatorControlButtons;
begin
  Result := TcxNavigatorControlButtons(CustomButtons);
end;

function TcxCustomNavigatorControl.GetIcxNavigator: IcxNavigator;
begin
  if Control <> nil then
    Supports(Control, IcxNavigator, Result)
  else
    Result := nil;
end;

function TcxCustomNavigatorControl.GetIRecordPosition: IcxNavigatorRecordPosition;
begin
  if Control <> nil then
    Supports(Control, IcxNavigatorRecordPosition, Result)
  else
    Result := nil;
end;

function TcxCustomNavigatorControl.GetInfoPanel: TcxNavigatorControlInfoPanel;
begin
  Result := TcxNavigatorControlInfoPanel(CustomInfoPanel);
end;

procedure TcxCustomNavigatorControl.SetButtons(Value: TcxNavigatorControlButtons);
begin
  CustomButtons.Assign(Value);
end;

procedure TcxCustomNavigatorControl.SetControl(Value: TComponent);
var
  ANavigator: IcxNavigator;
begin
  if (Value <> FControl) and ((Value = nil) or Supports(Value, IcxNavigator, ANavigator)) then
  begin
    if FControl <> nil then
    begin
      FControl.RemoveFreeNotification(Self);
      Supports(FControl, IcxNavigator, ANavigator);
      if ANavigator.GetNotifier <> nil then
        ANavigator.GetNotifier.RemoveNavigator(Self);
    end;
    FControl := Value;
    if (FControl <> nil) then
    begin
      FControl.FreeNotification(Self);
      Supports(FControl, IcxNavigator, ANavigator);
      if ANavigator.GetNotifier <> nil then
        ANavigator.GetNotifier.AddNavigator(Self);
    end;
    InitButtons;
    RefreshNavigator;
  end;
end;

procedure TcxCustomNavigatorControl.SetInfoPanel(Value: TcxNavigatorControlInfoPanel);
begin
  CustomInfoPanel.Assign(Value);
end;

initialization

finalization
  FreeAndNil(FNavigatorImages);

end.
