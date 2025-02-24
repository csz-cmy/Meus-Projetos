{**************************************************************************}
{ Parameter Mini HTML rendering engine                                     }
{ for Delphi & C++Builder                                                  }
{ version 1.3                                                              }
{                                                                          }
{ written by TMS Software                                                  }
{            copyright � 1999-2010                                         }
{            Email : info@tmssoftware.com                                  }
{            Website : http://www.tmssoftware.com/                         }
{                                                                          }
{ The source code is given as is. The author is not responsible            }
{ for any possible damage done due to the use of this code.                }
{ The component can be freely used in any application. The complete        }
{ source code remains property of the author and may not be distributed,   }
{ published, given or sold in any form as such. No parts of the source     }
{ code can be included in any other component or application without       }
{ written authorization of the author.                                     }
{**************************************************************************}

unit atParHTML;

{$I TMSDEFS.INC}
{$DEFINE HILIGHT}
{$DEFINE REMOVEIPOSFROM}
{$DEFINE PARAMS}
{$DEFINE REMOVEDRAW}

interface

uses
  Windows, Graphics, atPictureContainer, Classes, Controls, ComCtrls,
  Mask, StdCtrls, Buttons, ExtCtrls
{$IFDEF DELPHI4_LVL}
  , ImgList
{$ENDIF}
  , Messages
  {$IFNDEF TMSDOTNET}
  ,atParXPVS
  {$ENDIF}
  {$IFDEF TMSDOTNET}
  , uxTheme, System.Runtime.InteropServices, Types
  {$ENDIF}
  ;

var
  IsWinXP: Boolean;

type
  TParamUpdateEvent = procedure(Sender: TObject; Param, Text: string) of object;

  TPopupMaskEdit = class(TMaskEdit)
  private
    FCancelled: Boolean;
    FParam: string;
    FOnUpdate: TParamUpdateEvent;
    FOnReturn: TNotifyEvent;
    procedure WMKeyDown(var Msg: TWMKeydown); message WM_KEYDOWN;
    procedure WMActivate(var Message: TWMActivate); message WM_ACTIVATE;
  protected
    procedure DoExit; override;
    procedure CreateParams(var Params: TCreateParams); override;
  public
    property Cancelled: Boolean read FCancelled write FCancelled;
    property Param: string read FParam write FParam;
    property OnUpdate: TParamUpdateEvent read FOnUpdate write FOnUpdate;
    property OnReturn: TNotifyEvent read FOnReturn write FOnReturn;    
  end;

  TPopupEdit = class(TEdit)
  private
    FCancelled: Boolean;
    FParam: string;
    FOnUpdate: TParamUpdateEvent;
    FAutoSize: Boolean;
    FOnReturn: TNotifyEvent;
    procedure WMKeyDown(var Msg: TWMKeydown); message WM_KEYDOWN;
    procedure WMChar(var Msg:TWMChar); message WM_CHAR;    
    procedure WMActivate(var Message: TWMActivate); message WM_ACTIVATE;
  protected
    procedure DoExit; override;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure Change; override;
  public
    property AutoSize: Boolean read FAutoSize write FAutoSize;
    property Cancelled: Boolean read FCancelled write FCancelled;
    property Param: string read FParam write FParam;
    property OnUpdate: TParamUpdateEvent read FOnUpdate write FOnUpdate;
    property OnReturn: TNotifyEvent read FOnReturn write FOnReturn;
  end;

  TatTimeBtnState = set of (tbFocusRect, tbAllowTimer);

  TatTimerSpeedButton = class(TSpeedButton)
  private
    FRepeatTimer: TTimer;
    FTimeBtnState: TatTimeBtnState;
    procedure TimerExpired(Sender: TObject);
  protected
    procedure Paint; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
  public
    destructor Destroy; override;
    property TimeBtnState: TatTimeBtnState read FTimeBtnState write FTimeBtnState;
  end;

  TatSpinButton = class (TWinControl)
  private
    FUpButton: TatTimerSpeedButton;
    FDownButton: TatTimerSpeedButton;
    FFocusedButton: TatTimerSpeedButton;
    FFocusControl: TWinControl;
    FOnUpClick: TNotifyEvent;
    FOnDownClick: TNotifyEvent;
    function CreateButton: TatTimerSpeedButton;
    function GetUpGlyph: TBitmap;
    function GetDownGlyph: TBitmap;
    procedure SetUpGlyph(Value: TBitmap);
    procedure SetDownGlyph(Value: TBitmap);
    function GetUpNumGlyphs: TNumGlyphs;
    function GetDownNumGlyphs: TNumGlyphs;
    procedure SetUpNumGlyphs(Value: TNumGlyphs);
    procedure SetDownNumGlyphs(Value: TNumGlyphs);
    procedure BtnClick(Sender: TObject);
    procedure BtnMouseDown (Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SetFocusBtn (Btn: TatTimerSpeedButton);
    procedure AdjustSize (var W, H: Integer); reintroduce;
    procedure WMSize(var Message: TWMSize);  message WM_SIZE;
    procedure WMSetFocus(var Message: TWMSetFocus); message WM_SETFOCUS;
    procedure WMKillFocus(var Message: TWMKillFocus); message WM_KILLFOCUS;
    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
  protected
    procedure Loaded; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
  published
    property Align;
    {$IFDEF VER125}
    property Anchors;
    property Constraints;
    property DragKind;
    {$ENDIF}
    property Ctl3D;
    property DownGlyph: TBitmap read GetDownGlyph write SetDownGlyph;
    property DownNumGlyphs: TNumGlyphs read GetDownNumGlyphs write SetDownNumGlyphs default 1;
    property DragCursor;
    property DragMode;
    property Enabled;
    property FocusControl: TWinControl read FFocusControl write FFocusControl;
    property ParentCtl3D;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property UpGlyph: TBitmap read GetUpGlyph write SetUpGlyph;
    property UpNumGlyphs: TNumGlyphs read GetUpNumGlyphs write SetUpNumGlyphs default 1;
    property Visible;
    property OnDownClick: TNotifyEvent read FOnDownClick write FOnDownClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEnter;
    property OnExit;
    {$IFDEF VER125}
    property OnEndDock;
    property OnEndDrag;
    property OnStartDock;
    property OnStartDrag;
    {$ENDIF}
    property OnUpClick: TNotifyEvent read FOnUpClick write FOnUpClick;
  end;

  TatSpinEdit = class(TCustomEdit)
  private
    FMinValue: LongInt;
    FMaxValue: LongInt;
    FIncrement: LongInt;
    FButton: TatSpinButton;
    FEditorEnabled: Boolean;
    function GetMinHeight: Integer;
    function GetValue: LongInt;
    function CheckValue (NewValue: LongInt): LongInt;
    procedure SetValue (NewValue: LongInt);
    procedure SetEditRect;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    procedure CMEnter(var Message: TCMGotFocus); message CM_ENTER;
    procedure CMExit(var Message: TCMExit);   message CM_EXIT;
    procedure WMPaste(var Message: TWMPaste);   message WM_PASTE;
    procedure WMCut(var Message: TWMCut);   message WM_CUT;
  protected
  {$IFNDEF TMSDOTNET}
    procedure GetChildren(Proc: TGetChildProc; Root: TComponent); override;
  {$ENDIF}
    function IsValidChar(Key: Char): Boolean; virtual;
    procedure UpClick (Sender: TObject); virtual;
    procedure DownClick (Sender: TObject); virtual;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;
  public
  {$IFDEF TMSDOTNET}
    procedure GetChildren(Proc: TGetChildProc; Root: TComponent); override;
  {$ENDIF}
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Button: TatSpinButton read FButton;
  published
    property AutoSelect;
    property AutoSize;
    property Color;
    {$IFDEF VER125}
    property Anchors;
    property Constraints;
    {$ENDIF}
    property Ctl3D;
    property DragCursor;
    property DragMode;
    property EditorEnabled: Boolean read FEditorEnabled write FEditorEnabled default True;
    property Enabled;
    property Font;
    property Increment: LongInt read FIncrement write FIncrement default 1;
    property MaxLength;
    property MaxValue: LongInt read FMaxValue write FMaxValue;
    property MinValue: LongInt read FMinValue write FMinValue;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ReadOnly;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Value: LongInt read GetValue write SetValue;
    property Visible;
    property OnChange;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    {$IFDEF VER125}
    property OnStartDrag;
    property OnEndDrag;
    {$ENDIF}
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
  end;
  
  TPopupSpinEdit = class(TatSpinEdit)
  private
    FCancelled: Boolean;
    FParam: string;
    FOnUpdate: TParamUpdateEvent;
    FOnReturn: TNotifyEvent;
    procedure WMKeyDown(var Msg: TWMKeydown); message WM_KEYDOWN;
    procedure WMChar(var Msg:TWMChar); message WM_CHAR;
    procedure WMActivate(var Message: TWMActivate); message WM_ACTIVATE;
  protected
    procedure DoExit; override;
    procedure CreateParams(var Params: TCreateParams); override;
  public
    property Cancelled: Boolean read FCancelled write FCancelled;
    property Param: string read FParam write FParam;
    property OnUpdate: TParamUpdateEvent read FOnUpdate write FOnUpdate;
    property OnReturn: TNotifyEvent read FOnReturn write FOnReturn;
  end;

  TPopupListBox = class(TListBox)
  private
    FParam: string;
    FOnUpdate: TParamUpdateEvent;
    FOnReturn: TNotifyEvent;
    procedure WMKeyDown(var Msg: TWMKeydown); message WM_KEYDOWN;
    procedure WMLButtonUp(var Message: TWMLButtonDown); message WM_LBUTTONUP;
    procedure WMLButtonDown(var Message: TWMLButtonDown); message WM_LBUTTONDOWN;
    procedure WMActivate(var Message: TWMActivate); message WM_ACTIVATE;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    procedure SizeDropDownWidth;
    property Param: string read FParam write FParam;
    property OnUpdate: TParamUpdateEvent read FOnUpdate write FOnUpdate;
    property OnReturn: TNotifyEvent read FOnReturn write FOnReturn;
  end;

  TPopupDatePicker = class(TDateTimePicker)
  private
    FCancelled: Boolean;
    FParam: string;
    FOnUpdate: TParamUpdateEvent;
    FOnReturn: TNotifyEvent;
    {$IFNDEF DELPHI4_LVL}
    FDroppedDown: Boolean;
    procedure CNNotify(var Message: TWMNotify); message CN_NOTIFY;
    {$ENDIF}
    procedure WMKeyDown(var Msg: TWMKeydown); message WM_KEYDOWN;
    procedure WMActivate(var Message: TWMActivate); message WM_ACTIVATE;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure DoExit; override;
  public
    {$IFNDEF DELPHI4_LVL}
    property DroppedDown: Boolean read FDroppedDown;
    {$ENDIF}
    procedure ReInit;
    property Cancelled: Boolean read FCancelled write FCancelled;
    property Param: string read FParam write FParam;
    property OnUpdate: TParamUpdateEvent read FOnUpdate write FOnUpdate;
    property OnReturn: TNotifyEvent read FOnReturn write FOnReturn;
  end;

function HiLight(s,h,tag:string;DoCase:boolean):string;
function UnHiLight(s,tag:string):string;
function HTMLStrip(s:string):string;
procedure PropToList(s: string; sl: TStringList);
function HTMLDrawEx(Canvas:TCanvas; s:string; fr:TRect;
                    FImages: TImageList;
                    XPos,YPos,FocusLink,HoverLink,ShadowOffset: Integer;
                    CheckHotSpot,CheckHeight,Print,Selected,Blink,HoverStyle,WordWrap,Down,GetFocusRect: Boolean;
                    ResFactor:Double;
                    URLColor,HoverColor,HoverFontColor,ShadowColor:TColor;
                    var AnchorVal,StripVal,FocusAnchor: string;
                    var XSize,YSize,HyperLinks,MouseLink: Integer;
                    var HoverRect,ControlRect:TRect;var CID,CV,CT: string;
                    ic: THTMLPictureCache; pc: TatPictureContainer; WinHandle: THandle;LineSpacing: Integer): Boolean;

{$IFNDEF REMOVEDRAW}
function HTMLDraw(Canvas:TCanvas;s:string;fr:trect;
                                 FImages:TImageList;
                                 xpos,ypos:integer;
                                 checkhotspot,checkheight,print,selected,blink:boolean;
                                 resfactor:double;
                                 URLColor:tcolor;
                                 var Anchorval,StripVal:string;
                                 var XSize,YSize:integer):boolean;
{$ENDIF}
function GetControlValue(HTML,ControlID:string;var ControlValue:String): Boolean;
function SetControlValue(var HTML:string;ControlID,ControlValue:string): Boolean;
procedure PrintBitmap(Canvas:  TCanvas; DestRect:  TRect;  Bitmap:  TBitmap);

function HTMLPrep(s: string): string;
function InvHTMLPrep(s: string): string;

function GetHREFValue(html,href:string;var value:string):boolean;
function SetHREFValue(var html:string;href,value:string):boolean;
function ExtractParamInfo(html,href:string; var AClass,AValue,AProps,AHint: string): Boolean;
{$IFNDEF DELPHI5_LVL}
function ExcludeTrailingBackslash(DirName: string): string;
{$ENDIF}

{$IFNDEF DELPHI4_LVL}
function StringReplace(const S, OldPattern, NewPattern: string): string;
{$ENDIF}


implementation

uses
  ShellAPI, SysUtils, CommCtrl;

  
{$IFNDEF DELPHI5_LVL}
function ExcludeTrailingBackslash(DirName: string): string;
begin
  if Length(DirName) > 0 then
  begin
    if (DirName[Length(DirName)] in ['\','/']) then
      Delete(DirName,Length(DirName),1);
  end;
  Result := DirName;
end;
{$ENDIF}


{$IFNDEF TMSDOTNET}
procedure PrintBitmap(Canvas:  TCanvas; DestRect:  TRect;  Bitmap:  TBitmap);
var
  BitmapHeader:  pBitmapInfo;
  BitmapImage :  POINTER;
  HeaderSize  :  DWORD;
  ImageSize   :  DWORD;
begin
  GetDIBSizes(Bitmap.Handle, HeaderSize, ImageSize);
  GetMem(BitmapHeader, HeaderSize);
  GetMem(BitmapImage,  ImageSize);
  try
    GetDIB(Bitmap.Handle, Bitmap.Palette, BitmapHeader^, BitmapImage^);
    StretchDIBits(Canvas.Handle,
                  DestRect.Left, DestRect.Top,     // Destination Origin
                  DestRect.Right  - DestRect.Left, // Destination Width
                  DestRect.Bottom - DestRect.Top,  // Destination Height
                  0, 0,                            // Source Origin
                  Bitmap.Width, Bitmap.Height,     // Source Width & Height
                  BitmapImage,
                  TBitmapInfo(BitmapHeader^),
                  DIB_RGB_COLORS,
                  SRCCOPY)
  finally
    FreeMem(BitmapHeader);
    FreeMem(BitmapImage)
  end;
end;
{$ENDIF}

{$IFDEF TMSDOTNET}
procedure PrintBitmap(Canvas:  TCanvas; DestRect:  TRect;  Bitmap:  TBitmap);
var
  BitmapHeader:  TBitmapInfo;
  HeaderSize  :  DWORD;
  ImageSize   :  DWORD;
  Bits: HBITMAP;
  Image: TBytes;
  Info: IntPtr;

begin
  Bits := Bitmap.Handle;

  GetDIBSizes(Bits, HeaderSize, ImageSize);

  Info := Marshal.AllocHGlobal(HeaderSize);

  try
    SetLength(Image, ImageSize);
    GetDIB(Bits, 0, Info, Image);

    BitmapHeader := TBitmapInfo(Marshal.PtrToStructure(Info, TypeOf(TBitmapInfo)));

    StretchDIBits(Canvas.Handle,
                  DestRect.Left, DestRect.Top,     // Destination Origin
                  DestRect.Right  - DestRect.Left, // Destination Width
                  DestRect.Bottom - DestRect.Top,  // Destination Height
                  0, 0,                            // Source Origin
                  Bitmap.Width, Bitmap.Height,     // Source Width & Height
                  Image,
                  Info,
                  DIB_RGB_COLORS,
                  SRCCOPY)
  finally
    Marshal.FreeHGlobal(Info);
  end;
end;
{$ENDIF}

procedure DrawGradient(Canvas: TCanvas; FromColor,ToColor: TColor; Steps: Integer;R:TRect; Direction: Boolean);
var
  diffr,startr,endr: Integer;
  diffg,startg,endg: Integer;
  diffb,startb,endb: Integer;
  iend: Integer;
  rstepr,rstepg,rstepb,rstepw: Real;
  i,stepw: Word;

begin
  if Steps = 0 then
    Steps := 1;

  FromColor := ColorToRGB(FromColor);
  ToColor := ColorToRGB(ToColor);

  startr := (FromColor and $0000FF);
  startg := (FromColor and $00FF00) shr 8;
  startb := (FromColor and $FF0000) shr 16;
  endr := (ToColor and $0000FF);
  endg := (ToColor and $00FF00) shr 8;
  endb := (ToColor and $FF0000) shr 16;

  diffr := endr - startr;
  diffg := endg - startg;
  diffb := endb - startb;

  rstepr := diffr / steps;
  rstepg := diffg / steps;
  rstepb := diffb / steps;

  if Direction then
    rstepw := (R.Right - R.Left) / Steps
  else
    rstepw := (R.Bottom - R.Top) / Steps;

  with Canvas do
  begin
    for i := 0 to Steps - 1 do
    begin
      endr := startr + Round(rstepr*i);
      endg := startg + Round(rstepg*i);
      endb := startb + Round(rstepb*i);
      stepw := Round(i*rstepw);
      Pen.Color := endr + (endg shl 8) + (endb shl 16);
      Brush.Color := Pen.Color;
      if Direction then
      begin
        iend := R.Left + stepw + Trunc(rstepw) + 1;
        if iend > R.Right then
          iend := R.Right;
        Rectangle(R.Left + stepw,R.Top,iend,R.Bottom)
      end
      else
      begin
        iend := R.Top + stepw + Trunc(rstepw)+1;
        if iend > r.Bottom then
          iend := r.Bottom;
        Rectangle(R.Left,R.Top + stepw,R.Right,iend);
      end;  
    end;
  end;
end;


function DirExists(const Name: string): Boolean;
var
  Code: Integer;
begin
  {$IFNDEF TMSDOTNET}
  Code := GetFileAttributes(PChar(Name));
  {$ENDIF}
  {$IFDEF TMSDOTNET}
  Code := GetFileAttributes(Name);
  {$ENDIF}
  Result := (Code <> -1) and (FILE_ATTRIBUTE_DIRECTORY and Code <> 0);
end;

function SysImage(Canvas:TCanvas;x,y:Integer;APath:string;large,draw,print:boolean;resfactor:double):TPoint;
var
  SFI: TSHFileInfo;
  i,Err: Integer;
  imglsthandle: THandle;
  rx,ry: Integer;
  bmp:TBitmap;
  r: TRect;
begin
  Val(APath,i,Err);

  {$IFNDEF TMSDOTNET}
  if (APath <> '') and (Err <> 0) then
  begin
    if FileExists(APath) or DirExists(APath) then
    // If the file or directory exists, just let Windows figure out it's attrs.
      SHGetFileInfo(PChar(APath), 0, SFI, SizeOf(TSHFileInfo),
                    SHGFI_SYSICONINDEX {or OPEN_FLAG[Open] or SELECTED_FLAG[Selected]})
    else
    // File doesn't exist, so Windows doesn't know what to do with it.  We have
    // to tell it by passing the attributes we want, and specifying the
    // SHGFI_USEFILEATTRIBUTES flag so that the function knows to use them.
      SHGetFileInfo(PChar(APath), 0, SFI, SizeOf(TSHFileInfo),
                    SHGFI_SYSICONINDEX or SHGFI_USEFILEATTRIBUTES {or OPEN_FLAG[Open] or SELECTED_FLAG[Selected]});
    i := SFI.iIcon;
  end;

  if Large then
    imglsthandle := SHGetFileInfo('', 0, SFI, SizeOf(SFI),
                            SHGFI_SYSICONINDEX or SHGFI_LARGEICON)
  else
    imglsthandle := SHGetFileInfo('', 0, SFI, SizeOf(SFI),
                            SHGFI_SYSICONINDEX or SHGFI_SMALLICON);
  {$ENDIF}

  {$IFDEF TMSDOTNET}
  if (APath <> '') and (Err <> 0) then
  begin
    if FileExists(APath) or DirExists(APath) then
    // If the file or directory exists, just let Windows figure out it's attrs.
      SHGetFileInfo(APath, 0, SFI, Marshal.SizeOf(TypeOf(TSHFileInfo)),
                    SHGFI_SYSICONINDEX {or OPEN_FLAG[Open] or SELECTED_FLAG[Selected]})
    else
    // File doesn't exist, so Windows doesn't know what to do with it.  We have
    // to tell it by passing the attributes we want, and specifying the
    // SHGFI_USEFILEATTRIBUTES flag so that the function knows to use them.
      SHGetFileInfo(APath, 0, SFI, Marshal.SizeOf(TypeOf(TSHFileInfo)),
                    SHGFI_SYSICONINDEX or SHGFI_USEFILEATTRIBUTES {or OPEN_FLAG[Open] or SELECTED_FLAG[Selected]});
    i := SFI.iIcon;
  end;

  if Large then
    imglsthandle := SHGetFileInfo('', 0, SFI, Marshal.SizeOf(TypeOf(SFI)),
                            SHGFI_SYSICONINDEX or SHGFI_LARGEICON)
  else
    imglsthandle := SHGetFileInfo('', 0, SFI, Marshal.SizeOf(TypeOf(SFI)),
                            SHGFI_SYSICONINDEX or SHGFI_SMALLICON);
  {$ENDIF}

  ImageList_GetIconSize(imglsthandle,rx,ry);
  Result := Point(rx,ry);

  if Draw and not Print then
    ImageList_Draw(imglsthandle,i,Canvas.handle,x,y, ILD_TRANSPARENT);

  if Draw and Print then
  begin
    bmp := TBitmap.Create;
    bmp.Width := rx;
    bmp.Height := ry;
    ImageList_Draw(imglsthandle,i,bmp.Canvas.handle,0,0,ILD_NORMAL);
    r.left := x;
    r.top := y;
    r.right := x + Round(rx * ResFactor);
    r.bottom := y + Round(ry * ResFactor);
    PrintBitmap(Canvas,r,bmp);
    bmp.Free;
  end;
end;

function Text2Color(s:string):tcolor;
begin
  Result := clBlack;
  
  if (s = 'clred') then Result := clred else
  if (s = 'clblack') then Result := clblack else
  if (s = 'clblue') then Result := clblue else
  if (s = 'clgreen') then Result := clgreen else
  if (s = 'claqua') then Result := claqua else
  if (s = 'clyellow') then Result := clyellow else
  if (s = 'clfuchsia') then Result := clfuchsia else
  if (s = 'clwhite') then Result := clwhite else
  if (s = 'cllime') then Result := cllime else
  if (s = 'clsilver') then Result := clsilver else
  if (s = 'clgray') then Result := clgray else
  if (s = 'clolive') then Result := clolive else
  if (s = 'clnavy') then Result := clnavy else
  if (s = 'clpurple') then Result := clpurple else
  if (s = 'clteal') then Result := clteal else
  if (s = 'clmaroon') then Result := clmaroon;

  if Result <> clBlack then Exit;

  if (s = 'clbackground') then Result := clbackground else
  if (s = 'clactivecaption') then Result := clactivecaption else
  if (s = 'clinactivecaption') then Result := clinactivecaption else
  if (s = 'clmenu') then Result := clmenu else
  if (s = 'clwindow') then Result := clwindow else
  if (s = 'clwindowframe') then Result := clwindowframe else
  if (s = 'clmenutext') then Result := clmenutext else
  if (s = 'clwindowtext') then Result := clwindowtext else
  if (s = 'clcaptiontext') then Result := clcaptiontext else
  if (s = 'clactiveborder') then Result := clactiveborder else
  if (s = 'clinactiveborder') then Result := clinactiveborder else
  if (s = 'clappworkspace') then Result := clappworkspace else
  if (s = 'clhighlight') then Result := clhighlight else
  if (s = 'clhighlighttext') then Result := clhighlighttext else
  if (s = 'clbtnface') then Result := clbtnface else
  if (s = 'clbtnshadow') then Result := clbtnshadow else
  if (s = 'clgraytext') then Result := clgraytext else
  if (s = 'clbtntext') then Result := clbtntext else
  if (s = 'clinactivecaptiontext') then Result := clinactivecaptiontext else
  if (s = 'clbtnhighlight') then Result := clbtnhighlight else
  if (s = 'cl3ddkshadow') then Result := clgraytext else
  if (s = 'cl3dlight') then Result := cl3dlight else
  if (s = 'clinfotext') then Result := clinfotext else
  if (s = 'clinfobk') then Result := clinfobk;
end;

function HexVal(s:string): Integer;
var
  i,j: Integer;
begin
  if Length(s) < 2 then
  begin
    Result := 0;
    Exit;
  end;

  if s[1] >= 'A' then
    i := ord(s[1]) - ord('A') + 10
  else
    i := ord(s[1]) - ord('0');

  if s[2] >= 'A' then
    j := ord(s[2]) - ord('A') + 10
  else
    j := ord(s[2]) - ord('0');

  Result := i shl 4 + j;
end;

function Hex2Color(s:string): TColor;
var
  r,g,b: Integer;
begin
  r := Hexval(Copy(s,2,2));
  g := Hexval(Copy(s,4,2)) shl 8;
  b := Hexval(Copy(s,6,2)) shl 16;
  Result := TColor(b + g + r);
end;

function IPos(su,s:string):Integer;
begin
  Result := Pos(UpperCase(su),UpperCase(s));
end;

function IStrToInt(s:string):Integer;
var
  Err,Res: Integer;
begin
  Val(s,Res,Err);
  Result := Res;
end;

function DBTagStrip(s:string):string;
var
  i,j: Integer;
begin
  i := Pos('<#',s);
  if i > 0 then
  begin
    Result := Copy(s,1,i - 1);
    Delete(s,1,i);
    j := Pos('>',s);
    if j > 0 then
      Delete(s,j,1);
    Result := Result + s;
  end
  else
    Result := s;
end;

function CRLFStrip(s:string;break:boolean):string;
var
  i: Integer;
begin
  Result := '';
  for i := 1 to Length(s) do
  begin
    {$IFDEF DELPHI2009_LVL}
    if not CharInSet(s[i], [#13,#10]) then
    {$ELSE}
    if not (s[i] in [#13,#10]) then
    {$ENDIF}
      Result := Result + s[i]
    else
      if (s[i] = #13) and break then
        Result := Result + '<BR>';
  end;
end;

function VarPos(su,s:string;var Res:Integer):Integer;
begin
  Res := Pos(su,s);
  Result := Res;
end;

function VarIPos(su,s:string;var Res:Integer):Integer;
begin
  Res := Pos(su,Uppercase(s));
  Result := Res;
end;


function TagReplaceString(const Srch,Repl:string;var Dest:string):Boolean;
var
  i: Integer;
begin
  i := IPos(srch,dest);
  if i > 0 then
  begin
    Result := True;
    Delete(Dest,i,Length(Srch));
    Dest := Copy(Dest,1,i-1) + Repl + Copy(Dest,i,Length(Dest));
  end
  else
    Result := False;
end;


function UnFixMarkup(su:string):string;
begin
  while Pos('&lt;',su) > 0 do
  begin
    TagReplacestring('&lt;','<',su);
  end;

  while Pos('&gt;',su) > 0 do
  begin
   TagReplacestring('&gt;','>',su);
  end;

  Result := su;
end;

function FixMarkup(su:string): string;
begin
  while Pos('<',su) > 0 do
  begin
    TagReplacestring('<','&lt;',su);
  end;
  while Pos('>',su) > 0 do
  begin
   TagReplacestring('>','&gt;',su);
  end;
  Result := su;
end;

procedure ParseControl(Tag: string; var ControlType,ControlID,ControlValue,ControlWidth:string);
var
  Prop: string;
  vp: integer;
begin
  ControlType := '';
  ControlWidth := '';
  ControlValue := '';
  ControlID := '';

  if VarIPos('TYPE=',Tag,vp) > 0 then
  begin
    Prop := Copy(Tag,vp + 1,Length(Tag));
    Prop := Copy(Prop,Pos('"',Prop) + 1,Length(Prop));
    Prop := Copy(Prop,1,Pos('"',Prop) - 1);
    ControlType := Uppercase(Prop);
  end;

  if VarIPos('WIDTH=',Tag,vp) > 0 then
  begin
    Prop := Copy(Tag,vp + 1,Length(Tag));
    Prop := Copy(Prop,Pos('"',Prop) + 1,Length(Prop));
    Prop := Copy(Prop,1,Pos('"',Prop) - 1);
    ControlWidth := Prop;
  end;

  if VarIPos('ID=',Tag,vp) > 0 then
  begin
    Prop := Copy(Tag,vp + 1,Length(Tag));
    Prop := Copy(Prop,Pos('"',Prop) + 1,Length(Prop));
    Prop := Copy(Prop,1,Pos('"',Prop) - 1);
    ControlID := Prop;
  end;

  if VarIPos('VALUE=',Tag,vp) > 0 then
  begin
    Prop := Copy(Tag,vp + 1,Length(Tag));
    Prop := Copy(Prop,Pos('"',Prop) + 1,Length(Prop));
    Prop := Copy(Prop,1,Pos('"',Prop) - 1);
    ControlValue := UnFixMarkup(Prop);
  end;
end;


function GetControlValue(HTML,ControlID:string;var ControlValue:String): Boolean;
var
  lp: Integer;
  Tag,CType,CID,CV,CW: string;
begin
  Result := False;
  while VarIPos('<CONTROL ',html,lp) > 0 do
  begin
    Delete(html,1,lp);
    Tag := Copy(html,1,Pos('>',html));
    ParseControl(Tag,CType,CID,CV,CW);
    if (ControlID = CID) then
    begin
      ControlValue := CV;
      Result := True;
      Exit;
    end;
  end;
end;

function SetControlValue(var HTML:string;ControlID,ControlValue:string): Boolean;
var
  lp: Integer;
  Tag,Temp,CType,CID,CV,CW: string;
begin
  Result := False;
  Temp := '';
  ControlValue := FixMarkup(ControlValue);
  while VarIPos('<CONTROL ',html,lp) > 0 do
  begin
    Temp := Temp + Copy(html,1,lp);
    Delete(html,1,lp);
    Tag := Copy(html,1,Pos('>',html));
    ParseControl(Tag,CType,CID,CV,CW);
    if (ControlID = CID) then
    begin
      Temp := Temp + 'CONTROL ID="'+ControlID+'" VALUE="'+ControlValue+'" WIDTH="'+CW+'" TYPE="'+CType+'">';
      html := Temp + Copy(html,pos('>',html)+1,Length(html));
      Result := True;
      Exit;
    end;
  end;
end;

function HTMLDrawEx(Canvas:TCanvas; s:string; fr:TRect;
                    FImages: TImageList;
                    XPos,YPos,FocusLink,HoverLink,ShadowOffset: Integer;
                    CheckHotSpot,CheckHeight,Print,Selected,Blink,HoverStyle,WordWrap,Down,GetFocusRect: Boolean;
                    ResFactor:Double;
                    URLColor,HoverColor,HoverFontColor,ShadowColor:TColor;
                    var AnchorVal,StripVal,FocusAnchor: string;
                    var XSize,YSize,HyperLinks,MouseLink: Integer;
                    var HoverRect,ControlRect:TRect;var CID,CV,CT:string;
                    ic: THTMLPictureCache; pc: TatPictureContainer; WinHandle: THandle;LineSpacing: Integer): Boolean;
var
  su: string;
  r,dr,hr,rr,er: TRect;
  htmlwidth,htmlheight: Integer;
  Align: TAlignment;
  PIndent: Integer;
  OldFont: TFont;
  CalcFont: TFont;
  DrawFont: TFont;
  OldCalcFont: TFont;
  OldDrawFont: TFont;
  Hotspot, ImageHotspot: Boolean;
  Anchor,OldAnchor,MouseInAnchor,Error: Boolean;
  bgcolor,paracolor,hvrcolor,hvrfntcolor,pencolor,blnkcolor,hifcol,hibcol: TColor;
  LastAnchor,OldAnchorVal: string;
  IMGSize: TPoint;
  isSup,isSub,isPara,isShad: Boolean;
  subh,suph,imgali,srchpos,hlcount,licount: Integer;
  hrgn,holdfont: THandle;
  ListIndex: Integer;
  dtp: TDrawTextParams;
  Invisible: Boolean;
  FoundTag: Boolean;
  {new for editing}
  nnFit: Integer;
  nnSize: TSize;
  inspoint: Integer;
  {$IFNDEF TMSDOTNET}
  nndx: Pointer;
  {$ENDIF}
  AltImg,ImgIdx,OldImgIdx: Integer;
  DrawStyle: DWord;
  HTHeme: THandle;
  FHot: Boolean;
  UseWinXP: Boolean;
  ls: Integer;

  procedure StartRotated(Canvas:TCanvas;Angle: Integer);
  var
    LFont:TLogFont;
  begin
    {$IFNDEF TMSDOTNET}
    GetObject(Canvas.Font.Handle,SizeOf(LFont),Addr(LFont));
    {$ENDIF}
    {$IFDEF TMSDOTNET}
    GetObject(Canvas.Font.Handle,Marshal.SizeOf(TypeOf(LFont)),LFont);
    {$ENDIF}
    LFont.lfEscapement := Angle * 10;
    LFont.lfOrientation := Angle * 10;
    hOldFont:=SelectObject(Canvas.Handle,CreateFontIndirect(LFont));
  end;

  procedure EndRotated(Canvas:TCanvas);
  begin
    DeleteObject(SelectObject(Canvas.Handle,hOldFont));
  end;

  {$WARNINGS OFF}
  function HTMLDrawLine(Canvas: TCanvas;var s:string;r: TRect;Calc:Boolean;
                        var w,h,subh,suph,imgali:Integer;var Align:TAlignment; var PIndent: Integer;
                        XPos,YPos:Integer;var Hotspot,ImageHotSpot:Boolean):string;
  var
    su,Res,TagProp,Prop,AltProp,Tagp,LineText:string;
    cr,ir: TRect;
    linebreak,imgbreak,linkbreak: Boolean;
    th,sw,indent,err,bmpx,bmpy: Integer;
    TagPos,SpacePos,o,l: Integer;
    bmp: THTMLPicture;
    ABitmap: TBitmap;
    NewColor,NewColorTo: TColor;
    TagWidth,TagHeight,WordLen,WordLenEx,WordWidth: Integer;
    WordSize:TSize;
    TagChar: Char;
    LengthFits, SpaceBreak: Boolean;
    ControlType,ControlWidth,ControlID,ControlValue: string;

  begin
    WordWidth := 0;
    Result := '';
    LineText := '';
    r.Bottom := r.Bottom - Subh;

    w := 0;
    sw := 0;

    LineBreak := False;
    ImgBreak := False;
    LinkBreak := False;
    HotSpot := False;
    ImageHotSpot := False;
    cr := r;
    res := '';


    if isPara and not Calc then
    begin
      Pencolor := Canvas.Pen.Color;
      Canvas.Pen.color := Canvas.Brush.Color;
      Canvas.Rectangle(fr.Left,r.Top,fr.Right,r.Top + h);
    end;

    while (Length(s) > 0) and not LineBreak and not ImgBreak do
    begin
      // get next word or till next HTML tag
      TagPos := Pos('<',s);

      if WordWrap then
        SpacePos := Pos(' ',s)
      else
        SpacePos := 0;

      if (Tagpos > 0) and ((SpacePos > TagPos) or (SpacePos = 0)) then
      begin
        su := Copy(s,1,TagPos - 1);
      end
      else
      begin
        if SpacePos > 0 then
          su := Copy(s,1,SpacePos)
        else
          su := s;
      end;

      {$IFDEF TMSDEBUG}
      DbgMsg(su+ '.');
      {$ENDIF}

      WordLen := Length(su);

      while Pos('&nbsp;',su) > 0 do
      begin
        TagReplacestring('&nbsp;',' ',su);
      end;

      while Pos('&lt;',su) > 0 do
      begin
        TagReplacestring('&lt;','<',su);
      end;

      while Pos('&gt;',su) > 0 do
      begin
        TagReplacestring('&gt;','>',su);
      end;

      WordLenEx := Length(su);

      if WordLen > 0 then
      begin
        th := Canvas.TextHeight(su);

        if isSub and (subh < (th shr 2)) then subh := th shr 2;
        if isSup and (suph < (th shr 2)) then suph := th shr 2;

        if th > h then
          h := th;

        StripVal := StripVal + su;

        if not Invisible then
        begin
          // draw mode
          if not Calc then
          begin
            if isSup then
              cr.Bottom := cr.Bottom - suph;
            if isSub then
              cr.Bottom := cr.Bottom + subh;

            cr.Bottom := cr.Bottom - imgali;

            if isShad then
            begin
              OffsetRect(cr,ShadowOffset,ShadowOffset);
              NewColor := Canvas.Font.Color;
              Canvas.Font.Color := ShadowColor;
              {$IFNDEF TMSDOTNET}
              DrawTextEx(Canvas.Handle,PChar(su),WordLenEx,cr,DrawStyle,nil);
              {$ENDIF}
              {$IFDEF TMSDOTNET}
              DrawTextEx(Canvas.Handle,su,WordLenEx,cr,DrawStyle,nil);
              {$ENDIF}
              Offsetrect(cr,-ShadowOffset,-ShadowOffset);
              Canvas.Font.Color := NewColor;
            end;

            {$IFNDEF TMSDOTNET}
            DrawTextEx(Canvas.Handle,PChar(su),WordLenEx,cr,DrawStyle,nil);
            DrawTextEx(Canvas.Handle,PChar(su),WordLenEx,cr,DrawStyle or DT_CALCRECT,nil);
            {$ENDIF}
            {$IFDEF TMSDOTNET}
            DrawTextEx(Canvas.Handle,su,WordLenEx,cr,DrawStyle,nil);
            DrawTextEx(Canvas.Handle,su,WordLenEx,cr,DrawStyle or DT_CALCRECT,nil);
            {$ENDIF}

            if Anchor and (Hyperlinks - 1 = FocusLink) then
              FocusAnchor := LastAnchor;

            {$IFDEF TMSDEBUG}
            if Anchor then
              DbgMsg('drawrect for '+anchorval+' = ['+inttostr(cr.Left)+':'+inttostr(cr.Top)+'] ['+inttostr(cr.right)+':'+inttostr(cr.bottom)+'] @ ['+inttostr(xpos)+':'+inttostr(ypos));
            {$ENDIF}

            if Error then
            begin
              Canvas.Pen.Color := clRed;
              Canvas.Pen.Width := 1;

              l := (cr.Left div 2) * 2;
              if (l mod 4)=0 then o := 2 else o := 0;

              Canvas.MoveTo(l,r.Bottom + o - 1);
              while l < cr.Right do
              begin
                if o = 2 then o := 0 else o := 2;
                Canvas.LineTo(l + 2,r.bottom + o - 1);
                Inc(l,2);
              end;
              // if o = 2 then o := 0 else o := 2;
              // Canvas.LineTo(l + 2,r.Bottom + o - 1);
            end;

            cr.Left := cr.Right;
            cr.Right := r.Right;
            cr.Bottom := r.Bottom;
            cr.Top := r.Top;
          end
        else
          begin
            cr := r; //reinitialized each time !
            {$IFNDEF TMSDOTNET}
            DrawTextEx(Canvas.Handle,PChar(su),WordLenEx,cr,DrawStyle or DT_CALCRECT,nil);
            {$ENDIF}
            {$IFDEF TMSDOTNET}
            DrawTextEx(Canvas.Handle,su,WordLenEx,cr,DrawStyle or DT_CALCRECT,nil);
            {$ENDIF}

            // preparations for editing purposes
            if (ypos > cr.Top) and (ypos < cr.bottom) and (xpos > w) then {scan charpos here}
            begin
              er := rect(w,cr.top,xpos,cr.bottom);
              {$IFNDEF TMSDOTNET}
              Fillchar(dtp,sizeof(dtp),0);
              dtp.cbSize:=sizeof(dtp);
              {$ENDIF}
              {$IFDEF TMSDOTNET}
              dtp.cbSize:=Marshal.sizeof(TypeOf(dtp));
              {$ENDIF}

              {$IFDEF DELPHI4_LVL}
              {$IFNDEF TMSDOTNET}
              GetTextExtentExPoint(Canvas.Handle,pChar(su),WordLenEx,xpos-w,@nnfit,nil,nnSize);
              {$ENDIF}
              {$IFDEF TMSDOTNET}
              GetTextExtentExPoint(Canvas.Handle,su,WordLenEx,xpos-w,nnfit,nil,nnSize);
              {$ENDIF}
              {$ELSE}
              nndx:=nil; {fix for declaration error in Delphi 3 WINDOWS.PAS}
              GetTextExtentExPoint(Canvas.Handle,pChar(su),WordLenEx,xpos-w,nnfit,integer(nndx^),nnSize);
              {$ENDIF}

              {this will get the character pos of the insertion point}
              if nnfit = WordLen then
                InsPoint := InsPoint + WordLen
              else
                InsPoint := InsPoint + nnfit;
            end;
            {end of preparations for editing purposes}

            {Calculated text width}
            {$IFNDEF TMSDOTNET}
            GetTextExtentPoint32(Canvas.handle,PChar(su),Length(su), WordSize);
            {$ENDIF}
            {$IFDEF TMSDOTNET}
            GetTextExtentPoint32(Canvas.handle,su,Length(su), WordSize);
            {$ENDIF}

            WordWidth := WordSize.cx;
//            WordWidth := cr.Right - cr.Left;
            w := w + WordWidth;

            if (XPos - cr.Left >= w - WordWidth) and (XPos - cr.Left <= w) and Anchor then
            begin
              HotSpot := True;
              if (YPos > cr.Top){ and (YPos < cr.Bottom)} then
              begin
                Anchorval := LastAnchor;
                MouseInAnchor := True;
              end;
            end;
          end;

          LengthFits := (w < r.Right - r.Left) or (WordWrap and (r.Right - r.Left <= WordWidth));

          {//outputdebugstring(pchar('*'+LineText+'*'));

          if not LengthFits and
            ((Length(LineText) > 0) and (LineText[Length(LineText)] <> ' ')) then
            LengthFits := True;

          LineText := LineText + su; }

          if LengthFits or not WordWrap then
          begin
            Res := Res + Copy(s,1,WordLen);
            if not LengthFits and Calc then
              s := '';
            Delete(s,1,WordLen);
            if Length(su) >= WordLen then
            begin
              if su[WordLen] = ' ' then
                sw := Canvas.TextWidth(' ')
              else
                sw := 0;
            end
          end
          else
          begin
            LineBreak := True;
            w := w - WordWidth;
          end;
        end;
      end;

      TagPos := Pos('<',s);

      if (TagPos = 1) and (Length(s) <= 2) then
        s := '';

      if not LineBreak and (TagPos = 1) and (Length(s) > 2) then
      begin
        if (s[2] = '/') and (Length(s) > 3) then
        begin
          case UpCase(s[3]) of
          'A':begin
                Canvas.Font.Style := Canvas.Font.Style - [fsUnderline];

                if (not HoverStyle or (Hoverlink = Hyperlinks)) and not Calc then
                begin

                  if Hovercolor <> clNone then
                  begin
                    Canvas.Brush.Color := HvrColor;
                    if HvrColor = clNone then
                      Canvas.Brush.Style := bsClear;
                  end;
                  if HoverFontColor <> clNone then
                    Canvas.Font.Color := HoverFontColor;
                end;

                if not Selected then
                  Canvas.Font.Color := Oldfont.Color;

                Anchor := False;

                if MouseInAnchor or (GetFocusRect and (FocusLink = HyperLinks)) then
                begin
                  hr.Bottom := r.Bottom;
                  hr.Right := r.Left + w;

                  if r.Top <> hr.Top then
                  begin
                    hr.Left := r.Left;
                    hr.Top := r.Top;
                  end;

                  HoverRect := hr;
                  MouseLink := HyperLinks;
                  {$IFDEF TMSDEBUG}
                  DbgRect('hotspot anchor '+lastanchor,hr);
                  {$ENDIF}
                  MouseInAnchor := False;
                end;

                if Focuslink = Hyperlinks - 1 then
                begin
                  rr.Right := cr.Left;
                  rr.Bottom := cr.Bottom - ImgAli;
                  rr.Top := rr.Bottom - Canvas.TextHeight('gh');
                  InflateRect(rr,1,0);
                  if not Calc then
                  begin
                    Canvas.Pen.Color := clgray;
                    Canvas.Brush.Style := bsClear;
                    Canvas.Rectangle(rr.Left,rr.Top,rr.Right,rr.Bottom);
                    // Canvas.DrawFocusRect(rr);
                  end;
                end;
              end;
          'E':begin
                if not Calc then
                  Error := False;
              end;
          'B':begin
                if s[4] <> '>' then
                  Canvas.Font.Color := OldFont.Color
                else
                  Canvas.Font.Style := Canvas.Font.Style - [fsBold];
              end;
          'S':begin
                TagChar := UpCase(s[4]);

                if (TagChar = 'U') then
                begin
                  isSup := False;
                  isSub := False;
                end
                else
                 if (TagChar = 'H') then
                  isShad := False
                 else
                  Canvas.Font.Style := Canvas.Font.Style - [fsStrikeOut];
              end;
          'F':begin
                Canvas.Font.Name := OldFont.Name;
                Canvas.Font.Size := OldFont.Size;
                if not Calc and not Selected then
                begin
                  Canvas.Font.Color := OldFont.Color;
                  Canvas.Brush.Color := BGColor;
                  if BGColor = clNone then
                  begin
                    Canvas.Brush.Style := bsClear;
                  end;
                end;
              end;
          'H':begin
                if not Calc then
                begin
                  Canvas.Font.Color := hifCol;
                  Canvas.Brush.Color := hibCol;
                  if hibCol = clNone then
                    Canvas.Brush.Style := bsClear;
                end;    
              end;
          'I':begin
                Canvas.Font.Style := Canvas.Font.Style - [fsItalic];
              end;
          'P':begin
                LineBreak := True;
                if not Calc then
                begin
                  Canvas.Brush.Color := ParaColor;
                  if ParaColor = clNone then
                    Canvas.Brush.Style := bsClear;
                  isPara := false;
                end;
              end;
          'U':begin
                if (s[4] <> '>') and (ListIndex > 0) then
                  Dec(Listindex)
                else
                  Canvas.Font.Style := Canvas.Font.Style - [fsUnderline];
              end;
          'R':begin
                EndRotated(Canvas);
              end;
          'Z':Invisible := False;
          end;
        end
        else
        begin
          case Upcase(s[2]) of
          'A':begin
                {only do this when at hover position in xpos,ypos}
                if (FocusLink = HyperLinks) and not Calc then
                begin
                  rr.Left := cr.Left;
                  rr.Top := cr.Top;
                end;
                  Canvas.Font.Style := Canvas.Font.Style + [fsUnderline];

                Inc(HyperLinks);

                if (not HoverStyle or (Hoverlink = HyperLinks)) and not Calc then
                begin

                  if (Hovercolor <> clNone) and not Calc then
                  begin
                    HvrColor := Canvas.Brush.Color;

                    if Canvas.Brush.Style = bsClear then
                      HvrColor := clNone;
                    Canvas.Brush.Color := HoverColor;
                  end;

                  if HoverFontColor <> clNone then
                  begin
                    hvrfntcolor := Canvas.Font.Color;
                    Canvas.Font.Color := HoverFontColor;
                  end;
                end;

                if not Selected and ((HoverFontColor = clNone) or (HoverLink <> HyperLinks) or not HoverStyle) then
                  Canvas.Font.Color := URLColor;

                TagProp := Copy(s,3,Pos('>',s) - 1);  // <A href="anchor">
                Prop := Copy(TagProp,Pos('"',TagProp) + 1,Length(TagProp));
                Prop := Copy(Prop,1,Pos('"',Prop) - 1);
                LastAnchor := Prop;
                Anchor := True;

                hr.Left := w;
                hr.Top := r.Top;
              end;
          'B':begin
                TagChar := Upcase(s[3]);
                if TagChar = '>' then  // <B> tag
                  Canvas.Font.Style := Canvas.Font.Style + [fsBold]
                else
                  if TagChar = 'R' then // <BR> tag
                  begin
                    LineBreak := true;
                    StripVal := StripVal + #13;
                  end
                  else
                  begin
                    if TagChar = 'L' then // <BLINK> tag
                    begin
                      if not Blink then Canvas.Font.Color := BlnkColor;
                    end
                    else
                    if TagChar = 'O' then  // <BODY ... >
                    begin
                      Res := Res + Copy(s,1,pos('>',s));
                      TagProp := Uppercase(Copy(s,6,pos('>',s)-1));

                      if (Pos('BACKGROUND',TagProp) > 0) and not Calc then
                      begin
                        Prop := Copy(TagProp,Pos('BACKGROUND',TagProp)+10,Length(TagProp));
                        Prop := Copy(Prop,Pos('"',Prop)+1,Length(prop));
                        Prop := Copy(Prop,1,Pos('"',Prop)-1);

                        bmp := nil;

                        if (Pos(':',Prop) = 0) and Assigned(pc) then
                        begin
                          bmp := pc.FindPicture(Prop);
                        end;

                        if (Pos('://',Prop) > 0) and Assigned(ic) then
                        begin
                          if ic.FindPicture(Prop) = nil then
                          with ic.AddPicture do
                          begin
                            Asynch := False;
                            LoadFromURL(Prop);
                          end;

                          bmp := ic.FindPicture(Prop);
                        end;

                        if bmp <> Nil then
                        begin
                          if not bmp.Empty and (bmp.Width > 0) and (bmp.Height > 0) then
                          begin
                            // do the tiling here
                            bmpy := 0;
                            hrgn := CreateRectRgn(fr.left, fr.top, fr.right,fr.bottom);
                            SelectClipRgn(Canvas.Handle, hrgn);

                            while (bmpy < fr.bottom-fr.top) do
                            begin
                              bmpx := 0;
                              while (bmpx < fr.right - fr.left) do
                              begin
                                Canvas.Draw(fr.left+bmpx,fr.top+bmpy,bmp);
                                bmpx := bmpx + bmp.width;
                              end;
                              bmpy := bmpy + bmp.height;
                            end;

                            SelectClipRgn(Canvas.handle, 0);
                            DeleteObject(hrgn);
                          end;
                        end; //end of bmp <> nil
                    end; //end of background

                      if (Pos('BGCOLOR',TagProp)>0) then
                      begin
                        Prop := Copy(TagProp,Pos('BGCOLOR',TagProp) + 7,Length(TagProp));
                        Prop := Copy(Prop,Pos('"',Prop) + 1,Length(Prop));
                        Prop := Copy(Prop,1,Pos('"',Prop) - 1);
                        if not Calc then
                        begin
                          if Pos('CL',Prop) > 0 then
                            Canvas.Brush.color := Text2Color(AnsiLowerCase(Prop));
                          if Pos('#',Prop) > 0 then
                            Canvas.Brush.color := Hex2Color(Prop);

                          if not Calc then
                          begin
                            BGColor := Canvas.Brush.Color;
                            Pencolor := Canvas.Pen.Color;
                            Canvas.Pen.color := BGColor;
                            Canvas.Rectangle(fr.Left,fr.Top,fr.Right,fr.Bottom);
                            Canvas.Pen.Color := PenColor;
                          end;
                        end;
                      end;
                    end;
                  end;
                end;
          'E':begin
                if not Calc then
                  Error := True;
              end;
          'C':begin
                { control here }
                { <CONTROL type="EDIT" width="125" ID="name" VALUE=""> }

                TagProp := Copy(s,9,pos('>',s)-1);
                ParseControl(TagProp,ControlType,ControlID,ControlValue,ControlWidth);

                if ControlWidth <> '' then
                begin
                  val(ControlWidth,Indent,err);

                  if err = 0 then
                  begin
                    IMGSize.x := Indent;
                    IMGSize.y := Canvas.TextHeight('gh') + 6;
                  end;

                  if not Calc then
                  begin
                    if ControlType = 'EDIT' then
                    begin
                      Canvas.Pen.Color := clGray;
                      Canvas.Brush.Style := bsClear;
                      Canvas.Rectangle(cr.Left ,cr.Bottom - h + 3,cr.Left + Indent, cr.Bottom + 1);
                      ir := Rect(cr.Left + 2,cr.Bottom - h + 4,cr.Left + Indent, cr.Bottom);
                      {$IFNDEF TMSDOTNET}
                      DrawText(Canvas.Handle,PChar(ControlValue),Length(ControlValue),ir,DT_LEFT);
                      {$ENDIF}
                      {$IFDEF TMSDOTNET}
                      DrawText(Canvas.Handle,ControlValue,Length(ControlValue),ir,DT_LEFT);
                      {$ENDIF}
                    end;

                    if ControlType = 'COMBO' then
                    begin
                      IMGSize.y := 25;
                      Canvas.Pen.Color := clGray;
                      Canvas.Brush.Style := bsClear;
                      Canvas.Rectangle(cr.Left ,cr.Bottom - h + 3,cr.Left + Indent, cr.Bottom + 1);
                      ir := Rect(cr.Left + 2,cr.Bottom - h + 6,cr.Left + Indent - 17, cr.Bottom);
                      {$IFNDEF TMSDOTNET}
                      DrawText(Canvas.Handle,PChar(ControlValue),Length(ControlValue),ir,DT_LEFT);
                      {$ENDIF}
                      {$IFDEF TMSDOTNET}
                      DrawText(Canvas.Handle,ControlValue,Length(ControlValue),ir,DT_LEFT);
                      {$ENDIF}
                      ir := Rect(cr.Left + Indent - 19,cr.Bottom - h + 6,cr.Left + Indent-3, cr.Bottom-2);
                      
                      if UseWinXP then
                      begin
                        FHot := (XPos > cr.Left ) and (XPos <= cr.Left + IMGSize.x - 1) and
                           (YPos <= cr.Bottom - 1) and (YPos > cr.Bottom - IMGSize.y);

                        HTHeme := OpenThemeData(WinHandle,'combobox');

                        {$IFNDEF TMSDOTNET}
                        if FHot then
                          DrawThemeBackground(HTheme,Canvas.Handle,CP_DROPDOWNBUTTON,CBXS_HOT,@ir,nil)
                        else
                          DrawThemeBackground(HTheme,Canvas.Handle,CP_DROPDOWNBUTTON,CBXS_NORMAL,@ir,nil);
                        {$ENDIF}

                        {$IFDEF TMSDOTNET}
                        if FHot then
                          DrawThemeBackground(HTheme,Canvas.Handle,CP_DROPDOWNBUTTON,CBXS_HOT,ir,nil)
                        else
                          DrawThemeBackground(HTheme,Canvas.Handle,CP_DROPDOWNBUTTON,CBXS_NORMAL,ir,nil);
                        {$ENDIF}

                        CloseThemeData(HTheme);
                      end
                      else
                        DrawFrameControl(Canvas.Handle,ir,DFC_SCROLL,DFCS_SCROLLCOMBOBOX);
                    end;

                    if ControlType = 'CHECK' then
                    begin
                      IMGSize.x := 16;
                      IMGSize.y := 16;
                      Indent := 16;
                      Canvas.Pen.Color := clGray;
                      Canvas.Brush.Style := bsClear;
                      ir := Rect(cr.Left + 2,cr.Bottom - 15,cr.Left + 15, cr.Bottom);

                      FHot := (XPos > cr.Left ) and (XPos <= cr.Left + IMGSize.x - 1) and
                         (YPos <= cr.Bottom - 1) and (YPos > cr.Bottom - IMGSize.y);

                      if UseWinXP then
                      begin
                        HTHeme := OpenThemeData(WinHandle,'button');

                        if Uppercase(ControlValue) = 'TRUE' then
                        begin
                          {$IFNDEF TMSDOTNET}
                          if Down and FHot then
                            DrawThemeBackground(HTheme,Canvas.Handle, BP_CHECKBOX,CBS_CHECKEDPRESSED,@ir,nil)
                          else
                          if FHot then
                            DrawThemeBackground(HTheme,Canvas.Handle, BP_CHECKBOX,CBS_CHECKEDHOT,@ir,nil)
                          else
                            DrawThemeBackground(HTheme,Canvas.Handle, BP_CHECKBOX,CBS_CHECKEDNORMAL,@ir,nil);
                          {$ENDIF}
                          {$IFDEF TMSDOTNET}
                          if Down and FHot then
                            DrawThemeBackground(HTheme,Canvas.Handle, BP_CHECKBOX,CBS_CHECKEDPRESSED,ir,nil)
                          else
                          if FHot then
                            DrawThemeBackground(HTheme,Canvas.Handle, BP_CHECKBOX,CBS_CHECKEDHOT,ir,nil)
                          else
                            DrawThemeBackground(HTheme,Canvas.Handle, BP_CHECKBOX,CBS_CHECKEDNORMAL,ir,nil);
                          {$ENDIF}
                        end
                        else
                        begin
                          {$IFNDEF TMSDOTNET}
                          if Down and FHot then
                            DrawThemeBackground(HTheme,Canvas.Handle, BP_CHECKBOX,CBS_UNCHECKEDPRESSED,@ir,nil)
                          else
                          if FHot then
                            DrawThemeBackground(HTheme,Canvas.Handle, BP_CHECKBOX,CBS_UNCHECKEDHOT,@ir,nil)
                          else
                            DrawThemeBackground(HTheme,Canvas.Handle, BP_CHECKBOX,CBS_UNCHECKEDNORMAL,@ir,nil)
                          {$ENDIF}
                          {$IFDEF TMSDOTNET}
                          if Down and FHot then
                            DrawThemeBackground(HTheme,Canvas.Handle, BP_CHECKBOX,CBS_UNCHECKEDPRESSED,ir,nil)
                          else
                          if FHot then
                            DrawThemeBackground(HTheme,Canvas.Handle, BP_CHECKBOX,CBS_UNCHECKEDHOT,ir,nil)
                          else
                            DrawThemeBackground(HTheme,Canvas.Handle, BP_CHECKBOX,CBS_UNCHECKEDNORMAL,ir,nil)
                          {$ENDIF}

                        end;
                        CloseThemeData(HTHeme);
                      end
                      else
                      begin
                        if Uppercase(ControlValue) = 'TRUE' then
                          DrawFrameControl(Canvas.Handle,ir,DFC_BUTTON, DFCS_BUTTONCHECK or DFCS_FLAT or DFCS_CHECKED)
                        else
                          DrawFrameControl(Canvas.Handle,ir,DFC_BUTTON, DFCS_BUTTONCHECK or DFCS_FLAT);
                      end;
                    end;

                    if ControlType = 'RADIO' then
                    begin
                      IMGSize.x := 16;
                      IMGSize.y := 16;
                      Indent := 16;
                      Canvas.Pen.Color := clGray;
                      Canvas.Brush.Style := bsClear;
                      ir := Rect(cr.Left + 2,cr.Bottom - 14,cr.Left + 14, cr.Bottom);

                      FHot := (XPos > cr.Left ) and (XPos <= cr.Left + IMGSize.x - 1) and
                         (YPos <= cr.Bottom - 1) and (YPos > cr.Bottom - IMGSize.y);

                      if UseWinXP then
                      begin
                        HTHeme := OpenThemeData(WinHandle,'button');

                        if Uppercase(ControlValue) = 'TRUE' then
                        begin
                          {$IFNDEF TMSDOTNET}
                          if Down and FHot then
                            DrawThemeBackground(HTheme,Canvas.Handle, BP_RADIOBUTTON,RBS_CHECKEDPRESSED,@ir,nil)
                          else
                          if FHot then
                            DrawThemeBackground(HTheme,Canvas.Handle, BP_RADIOBUTTON,RBS_CHECKEDHOT,@ir,nil)
                          else
                            DrawThemeBackground(HTheme,Canvas.Handle, BP_RADIOBUTTON,RBS_CHECKEDNORMAL,@ir,nil);
                          {$ENDIF}
                          {$IFDEF TMSDOTNET}
                          if Down and FHot then
                            DrawThemeBackground(HTheme,Canvas.Handle, BP_RADIOBUTTON,RBS_CHECKEDPRESSED,ir,nil)
                          else
                          if FHot then
                            DrawThemeBackground(HTheme,Canvas.Handle, BP_RADIOBUTTON,RBS_CHECKEDHOT,ir,nil)
                          else
                            DrawThemeBackground(HTheme,Canvas.Handle, BP_RADIOBUTTON,RBS_CHECKEDNORMAL,ir,nil);
                          {$ENDIF}
                        end
                        else
                        begin
                          {$IFNDEF TMSDOTNET}
                          if Down and FHot then
                            DrawThemeBackground(HTheme,Canvas.Handle, BP_RADIOBUTTON,RBS_UNCHECKEDPRESSED,@ir,nil)
                          else
                          if FHot then
                            DrawThemeBackground(HTheme,Canvas.Handle, BP_RADIOBUTTON,RBS_UNCHECKEDHOT,@ir,nil)
                          else
                            DrawThemeBackground(HTheme,Canvas.Handle, BP_RADIOBUTTON,RBS_UNCHECKEDNORMAL,@ir,nil)
                          {$ENDIF}
                          {$IFDEF TMSDOTNET}
                          if Down and FHot then
                            DrawThemeBackground(HTheme,Canvas.Handle, BP_RADIOBUTTON,RBS_UNCHECKEDPRESSED,ir,nil)
                          else
                          if FHot then
                            DrawThemeBackground(HTheme,Canvas.Handle, BP_RADIOBUTTON,RBS_UNCHECKEDHOT,ir,nil)
                          else
                            DrawThemeBackground(HTheme,Canvas.Handle, BP_RADIOBUTTON,RBS_UNCHECKEDNORMAL,ir,nil)
                          {$ENDIF}

                        end;
                        CloseThemeData(HTHeme);
                      end
                      else
                      begin
                        if ControlValue = 'True' then
                          DrawFrameControl(Canvas.Handle,ir,DFC_BUTTON, DFCS_BUTTONRADIO or DFCS_FLAT or DFCS_CHECKED)
                        else
                          DrawFrameControl(Canvas.Handle,ir,DFC_BUTTON, DFCS_BUTTONRADIO or DFCS_FLAT);
                      end;
                    end;

                    if (ControlType = 'BUTTON') or (ControlType = 'TOOLBTN') then
                    begin
                      IMGSize.y := 26;
                      Canvas.Pen.Color := clGray;
                      Canvas.Brush.Style := bsClear;
                      ir := Rect(cr.Left + 2,cr.Bottom - 22,cr.Left + Indent -2, cr.Bottom);

                      {$IFDEF TMSDEBUG}
                      outputdebugstring(pchar(inttostr(cr.left)+':'+inttostr(cr.bottom)+':'+inttostr(cr.Left+IMGSize.x)+':'+inttostr(cr.bottom-IMGSIze.y)));
                      {$ENDIF}

                      FHot := (XPos > cr.Left ) and (XPos <= cr.Left + IMGSize.x - 1) and
                         (YPos <= cr.Bottom - 1) and (YPos > cr.Bottom - IMGSize.y);

                      {$IFDEF TMSDEBUG}
                      outputdebugstring(pchar(inttostr(xpos)+':'+inttostr(ypos)));

                      if fhot then
                        outputdebugstring('hot');
                      {$ENDIF}

                      if UseWinXP then
                      begin
                        HTHeme := OpenThemeData(WinHandle,'button');

                        {$IFNDEF TMSDOTNET}
                        if Down and FHot then
                          DrawThemeBackground(HTheme,Canvas.Handle, BP_PUSHBUTTON,PBS_PRESSED,@ir,nil)
                        else
                        if FHot then
                          DrawThemeBackground(HTheme,Canvas.Handle, BP_PUSHBUTTON,PBS_HOT,@ir,nil)
                        else
                          DrawThemeBackground(HTheme,Canvas.Handle, BP_PUSHBUTTON,PBS_NORMAL,@ir,nil);
                        {$ENDIF}
                        {$IFDEF TMSDOTNET}
                        if Down and FHot then
                          DrawThemeBackground(HTheme,Canvas.Handle, BP_PUSHBUTTON,PBS_PRESSED,ir,nil)
                        else
                        if FHot then
                          DrawThemeBackground(HTheme,Canvas.Handle, BP_PUSHBUTTON,PBS_HOT,ir,nil)
                        else
                          DrawThemeBackground(HTheme,Canvas.Handle, BP_PUSHBUTTON,PBS_NORMAL,ir,nil);
                        {$ENDIF}

                        CloseThemeData(HTHeme);
                      end
                      else
                      begin
                        if FHot and Down then
                          DrawFrameControl(Canvas.Handle,ir,DFC_BUTTON, DFCS_BUTTONPUSH or DFCS_PUSHED)
                        else
                          DrawFrameControl(Canvas.Handle,ir,DFC_BUTTON, DFCS_BUTTONPUSH);
                      end;


                      if (ControlValue <> '') and Assigned(FImages) and (ControlType = 'TOOLBTN') then
                      begin
                        Indent := (IMGSize.X - FImages.Width -2) div 2;
                        if Down then
                          FImages.Draw(Canvas,ir.Left + Indent + 1,ir.Top + 4,IStrToInt(ControlValue))
                        else
                          FImages.Draw(Canvas,ir.Left + Indent,ir.Top + 3,IStrToInt(ControlValue));
                      end;

                      if (ControlType = 'BUTTON') then
                      begin
                        InflateRect(ir,-2,-2);
                        {$IFNDEF TMSDOTNET}
                        DrawText(Canvas.Handle,PChar(ControlValue),Length(ControlValue),ir,DT_CENTER);
                        {$ENDIF}
                        {$IFDEF TMSDOTNET}
                        DrawText(Canvas.Handle,ControlValue,Length(ControlValue),ir,DT_CENTER);
                        {$ENDIF}
                      end;
                    end;
                  end;

                  if (ControlType = 'BUTTON') then
                     IMGSize.y := 26;

                  if (ControlType = 'TOOLBTN') then
                     IMGSize.y := 26;

                  if (ControlType = 'COMBO') then
                     IMGSize.y := 25;

                  if (ControlType = 'CHECK') then
                  begin
                    IMGSize.x := 16;
                    IMGSize.y := 16;
                  end;

                  if (ControlType = 'RADIO') then
                  begin
                    IMGSize.x := 16;
                    IMGSize.y := 16;
                  end;

//                outputdebugstring(pchar(controlid+':'+inttostr(cr.Left)));

                  if (XPos - r.Left > w) and (XPos - r.Left < w + IMGSize.x) and
                     (YPos > cr.Top) and (YPos < cr.Top + IMGSize.Y) then
                  begin
                    ImageHotSpot := True;
                    AnchorVal := 'ctrl';
                    AltImg := ImgIdx;

//                    ir := cr;
//                    ir.Right := cr.Left + IMGSize.x;

                    ir.Left := r.left + w;
                    ir.Right := ir.Left + ImgSize.X;
                    ir.Top := cR.Top;
                    ir.Bottom := cr.top + ImgSize.Y;

//                  outputdebugstring(pchar(inttostr(ir.left)+':'+inttostr(ir.Top)+':'+inttostr(ir.Right)+':'+inttostr(ir.Bottom)));
                    ControlRect := ir;
                    CV := ControlValue;
                    CID := ControlID;
                    CT := ControlType;
                  end;

                    if (w + IMGSize.x > r.Right-r.Left) and
                       (IMGSize.x < r.Right - r.Left) then
                    begin
                      ImgBreak := True;
                    end
                    else
                      begin
                        w := w + IMGSize.x;
                        cr.left := cr.left + IMGSize.x;
                        if IMGSize.y > h then
                          h := IMGSize.y;
                      end;

///                  cr.left := fr.left + Indent;
                end;
              end;
          'H':begin
                case Upcase(s[3]) of
                'R':
                begin
                  LineBreak := True;
                  if not Calc then
                  begin
                    Pencolor := Canvas.Pen.color;
                    Canvas.Pen.color:=clblack;
                    Canvas.MoveTo(r.left,cr.bottom+1);
                    Canvas.Lineto(r.right,cr.bottom+1);
                    Canvas.pen.color:=pencolor;
                  end;
                end;
                'I':
                begin
                  if not Calc then
                  begin
                    hifCol := Canvas.Font.Color;
                    hibCol := Canvas.Brush.Color;
                    if Canvas.Brush.Style = bsClear then
                      hibCol := clNone;

                    Canvas.Brush.Color := clHighLight;
                    Canvas.Font.Color := clHighLightText;
                  end;
                end;
                end;
              end;
          'I':begin
                TagChar := Upcase(s[3]);

                if TagChar = '>' then // <I> tag
                  Canvas.Font.Style := Canvas.Font.Style + [fsItalic]
                else
                if TagChar = 'N' then  // <IND> tag
                begin
                  TagProp := Copy(s,3,pos('>',s)-1);

                  Prop := Copy(TagProp,ipos('x',TagProp)+2,Length(TagProp));
                  Prop := Copy(Prop,Pos('"',Prop)+1,Length(prop));
                  Prop := Copy(Prop,1,Pos('"',Prop)-1);

                  val(Prop,indent,err);
                  if err = 0 then
                  begin
                    if Indent > w then
                     begin
                       w := Indent;
                       cr.left := fr.left + Indent;
                     end;
                  end;
                end
                else
                  if TagChar = 'M' then
                  begin
                    inc(ImgIdx);

                    //oldfont.color:=Canvas.font.color;
                    TagProp := Uppercase(Copy(s,3,pos('>',s) - 1));
                    Prop := Copy(TagProp,Pos('SRC',TagProp) + 4,Length(TagProp));
                    Prop := Copy(Prop,Pos('"',Prop) + 1,Length(Prop));
                    Prop := Copy(Prop,1,Pos('"',Prop) - 1);

                    if (Pos('ALT',TagProp) > 0) and (AltImg = ImgIdx) then
                    begin
                      Prop := Copy(TagProp,Pos('ALT',TagProp) + 4,Length(TagProp));
                      Prop := Copy(Prop,Pos('"',Prop) + 1,Length(Prop));
                      Prop := Copy(Prop,1,Pos('"',Prop) - 1);
                    end;

                    TagWidth := 0;
                    TagHeight := 0;

                    if Pos('WIDTH',TagProp) > 0 then
                    begin
                      Tagp := Copy(TagProp,Pos('WIDTH',TagProp) + 6,Length(TagProp));
                      Tagp := Copy(Tagp,Pos('"',tagp) + 1,Length(Tagp));
                      Tagp := Copy(Tagp,1,Pos('"',tagp) - 1);
                      Val(Tagp,TagWidth,Err);
                    end;

                    if Pos('HEIGHT',TagProp) > 0 then
                    begin
                      Tagp := Copy(TagProp,ipos('HEIGHT',TagProp) + 7,Length(TagProp));
                      Tagp := Copy(Tagp,pos('"',Tagp) + 1,Length(Tagp));
                      Tagp := Copy(Tagp,1,pos('"',Tagp) - 1);
                      Val(Tagp,TagHeight,Err);
                    end;

                    IMGSize.x := 0;
                    IMGSize.y := 0;

                    if Pos('IDX:',Prop) > 0 then
                    begin
                      Delete(Prop,1,4);
                      if Assigned(FImages) and (IStrToInt(Prop) < FImages.Count) then
                      begin
                        IMGSize.x := MulDiv(FImages.Width,GetDeviceCaps(Canvas.Handle,LOGPIXELSX),96);
                        IMGSize.y := MulDiv(FImages.Height,GetDeviceCaps(Canvas.Handle,LOGPIXELSY),96);

                        if not Calc and not Print then
                        {$IFDEF DELPHI4_LVL}
                          FImages.Draw(Canvas,cr.Left,cr.Top,IStrToInt(Prop),True);
                        {$ELSE}
                          FImages.Draw(Canvas,cr.Left,cr.Top,IStrToInt(Prop));
                        {$ENDIF}

                        if not Calc and Print then
                        begin
                          cr.Right := cr.Left + Round(ResFactor * FImages.Width);
                          cr.Bottom := cr.Top + Round(ResFactor * FImages.Height);

                          ABitmap := TBitmap.Create;
                          FImages.GetBitmap(IStrToInt(Prop),ABitmap);
                          PrintBitmap(Canvas,cr,ABitmap);
                          ABitmap.Free;
                        end;
                      end;
                    end;

                    if Pos('SSYS:',Prop) > 0 then
                    begin
                      Delete(Prop,1,5);
                      IMGSize := SysImage(Canvas,cr.Left,cr.Top,Prop,False,not Calc,Print,ResFactor);

                      IMGSize.x := MulDiv(IMGSize.X,GetDeviceCaps(Canvas.Handle,LOGPIXELSX),96);
                      IMGSize.y := MulDiv(IMGSize.Y,GetDeviceCaps(Canvas.Handle,LOGPIXELSY),96);
                    end;

                    if Pos('LSYS:',Prop) > 0 then
                    begin
                      Delete(Prop,1,5);
                      IMGsize := SysImage(Canvas,cr.Left,cr.Top,Prop,True,not Calc,Print,ResFactor);

                      IMGSize.x := MulDiv(IMGSize.X,GetDeviceCaps(Canvas.Handle,LOGPIXELSX),96);
                      IMGSize.y := MulDiv(IMGSize.Y,GetDeviceCaps(Canvas.Handle,LOGPIXELSY),96);
                    end;

                    bmp := nil;

                    if (Pos(':',Prop) = 0) and Assigned(pc) then
                    begin
                      bmp := pc.FindPicture(Prop);
                    end;

                    if (Pos('://',Prop) > 0) and Assigned(ic) then
                    begin
                      if ic.FindPicture(Prop) = nil then
                        with ic.AddPicture do
                        begin
                          Asynch := False;
                          LoadFromURL(Prop);
                        end;

                      bmp := ic.FindPicture(Prop);
                    end;

                      if bmp <> nil then
                      begin
                        if not bmp.Empty then
                        begin
                          if not Calc {and not Print} then
                          begin
                            if (TagWidth > 0) and (TagHeight > 0) then
                              Canvas.StretchDraw(Rect(cr.Left,cr.Top,cr.Left + TagWidth,cr.Top + TagHeight),bmp)
                            else
                            begin
                              // need for animation - redraw background
                              if bmp.FrameCount > 1 then
                              begin
                                Canvas.Pen.Color := BlnkColor;
                                Canvas.Brush.Color := BlnkColor;
                                Canvas.Rectangle(cr.Left,cr.Top,cr.Left + bmp.MaxWidth,cr.Top+bmp.MaxHeight);
                              end;

                              Canvas.Draw(cr.Left + bmp.FrameXPos,cr.Top + bmp.FrameYPos,bmp);
                            end;
                          end;

                          if (TagWidth > 0) and (TagHeight > 0) then
                          begin
                            IMGSize.x := MulDiv(TagWidth,GetDeviceCaps(Canvas.Handle,LOGPIXELSX),96);
                            IMGSize.y := MulDiv(TagHeight,GetDeviceCaps(Canvas.Handle,LOGPIXELSY),96);
                          end
                          else
                          begin
                            IMGSize.x := MulDiv(bmp.MaxWidth,GetDeviceCaps(Canvas.Handle,LOGPIXELSX),96);
                            IMGSize.y := MulDiv(bmp.MaxHeight,GetDeviceCaps(Canvas.Handle,LOGPIXELSY),96);
                          end;
                        end;
                      end;

                    if (XPos - r.Left > w) and (XPos - r.Left < w + IMGSize.x) and
                       (YPos > cr.Top) and (YPos < cr.Top + IMGSize.Y) and Anchor then
                    begin
                      ImageHotSpot := True;
                      AnchorVal := LastAnchor;
                      AltImg := ImgIdx;
                    end;

                    if Print then
                    begin
                      //IMGSize.x := Round(IMGSize.x * ResFactor);
                      //IMGSize.y := Round(IMGSize.y * ResFactor);
                      {$IFDEF TMSDEBUG}
                      DbgPoint('bmp : ',point(IMGSize.x,IMGSize.y));
                      {$ENDIF}
                    end;

                    if (w + IMGSize.x > r.Right-r.Left) and
                       (IMGSize.x < r.Right - r.Left) then
                    begin
                      ImgBreak := True;
                    end
                    else
                      begin
                        w := w + IMGSize.x;
                        cr.left := cr.left + IMGSize.x;
                        if IMGSize.y > h then
                          h := IMGSize.y;
                      end;

                    if Pos('ALIGN',TagProp) > 0 then
                    begin
                      if Pos('"TOP',TagProp) > 0 then
                      begin
                        ImgAli := h - Canvas.TextHeight('gh');
                      end
                      else
                      begin
                        if Pos('"MIDDLE',TagProp) > 0 then
                          ImgAli := (h - Canvas.TextHeight('gh')) shr 1;
                      end;
                    end;
                  end;
                end;
          'L':begin
                w := w + 12 * ListIndex;
                if Linkbreak then
                  Imgbreak := True else Linkbreak := True;

                cr.left := cr.left + 12 * (ListIndex - 1);
                if not calc then
                begin
                  Prop := Canvas.Font.Name;
                  Canvas.Font.Name:='Symbol';

                  if Odd(ListIndex) then
                    DrawText(Canvas.Handle,'�',1,cr,0)
                  else
                    DrawText(Canvas.Handle,'o',1,cr,0);

                  Canvas.Font.Name:=prop;
                end;
                cr.Left := cr.Left + 12;
              end;
          'U':begin
                if s[3] <> '>' then
                begin
                  Inc(ListIndex);
                end
                else
                  Canvas.Font.Style := Canvas.Font.Style + [fsUnderline];
              end;
          'P':begin
                if (VarPos('>',s,TagPos)>0) then
                begin
                  TagProp := Uppercase(Copy(s,3,TagPos-1));

                  if VarPos('ALIGN',TagProp,TagPos) > 0 then
                  begin
                    Prop := Copy(TagProp,TagPos+5,Length(TagProp));
                    Prop := Copy(Prop,Pos('"',prop)+1,Length(Prop));
                    Prop := Copy(Prop,1,Pos('"',prop)-1);

                    if Pos('RIGHT',Prop) > 0 then Align := taRightJustify;
                    if Pos('LEFT',Prop) > 0 then Align := taLeftJustify;
                    if Pos('CENTER',Prop) > 0 then Align := taCenter;
                  end;

                  if VarPos('INDENT',TagProp,TagPos) > 0 then
                  begin
                    Prop := Copy(TagProp,TagPos+6,Length(TagProp));
                    Prop := Copy(Prop,Pos('"',prop)+1,Length(Prop));
                    Prop := Copy(Prop,1,Pos('"',prop)-1);
                    PIndent := IStrToInt(Prop);
                  end;


                  if VarPos('BGCOLOR',TagProp,TagPos) > 0 then
                  begin
                    Prop := Copy(TagProp,TagPos + 5,Length(TagProp));
                    Prop := Copy(Prop,Pos('"',Prop) + 1,Length(Prop));
                    Prop := Copy(Prop,1,Pos('"',Prop) - 1);

                    NewColor := clNone;

                    if Length(Prop) > 0 then
                    begin
                      if Prop[1] = '#' then
                        NewColor := Hex2Color(Prop)
                      else
                        NewColor := Text2Color(AnsiLowerCase(prop));
                    end;

                    if VarPos('BGCOLORTO',TagProp,TagPos) > 0 then
                    begin
                      Prop := Copy(TagProp,TagPos + 5,Length(TagProp));
                      Prop := Copy(Prop,Pos('"',Prop) + 1,Length(Prop));
                      Prop := Copy(Prop,1,Pos('"',Prop) - 1);
                      NewColorTo := clNone;

                      if Length(Prop) > 0 then
                      begin
                        if Prop[1] = '#' then
                          NewColorTo := Hex2Color(Prop)
                        else
                          NewColorTo := Text2Color(AnsiLowerCase(prop));
                      end;
                      if not Calc then
                      begin
                        isPara := True;
                        //paracolor := Canvas.Brush.Color;
                        Canvas.Pen.Color := Newcolor;
                        DrawGradient(Canvas,NewColor,NewColorTo,64,Rect(fr.left,r.top,fr.right,r.bottom+2),true);
                        Canvas.Brush.Style := bsClear
                      end;
                    end
                    else
                    begin
                      if not Calc then
                      begin
                        isPara := True;
                        paracolor := Canvas.Brush.Color;
                        if Canvas.Brush.Style = bsClear then ParaColor := clNone;
                        Canvas.Brush.color := NewColor;
                        PenColor:=Canvas.Pen.Color;
                        Canvas.Pen.Color := Newcolor;
                        Canvas.Rectangle(fr.left,r.top,fr.right,r.bottom);
                      end;
                    end;
                  end;
                end;
            end;
        'F':begin
              if (VarPos('>',s,TagPos)>0) then
              begin
                TagProp := UpperCase(Copy(s,6,TagPos-6));

                if (VarPos('FACE',TagProp,TagPos) > 0) then
                begin
                  Prop := Copy(TagProp,TagPos+4,Length(TagProp));
                  Prop := Copy(prop,pos('"',prop)+1,Length(prop));
                  Prop := Copy(prop,1,pos('"',prop)-1);
                  Canvas.Font.Name := Prop;
                end;

                if (VarPos(' COLOR',TagProp,TagPos) > 0) and not Selected then
                begin
                  Prop := Copy(TagProp,TagPos+6,Length(TagProp));
                  Prop := Copy(Prop,Pos('"',prop)+1,Length(prop));
                  Prop := Copy(Prop,1,Pos('"',prop)-1);
                  //oldfont.color:=Canvas.font.color;

                  if Length(Prop) > 0 then
                  begin
                    if Prop[1] = '#' then
                      Canvas.font.color := Hex2Color(Prop)
                    else
                      Canvas.Font.Color := Text2Color(AnsiLowerCase(prop));
                  end;

                end;

                if (VarPos('BGCOLOR',TagProp,TagPos)>0) and not Calc and not Selected then
                begin
                  Prop := Copy(TagProp,TagPos+7,Length(TagProp));
                  Prop := Copy(prop,pos('"',prop)+1,Length(prop));
                  Prop := Copy(prop,1,pos('"',prop)-1);
                  BGColor := Canvas.Brush.Color;

                  if Canvas.Brush.Style = bsClear then
                    bgcolor := clNone;

                  if Length(Prop) > 0 then
                  begin
                    if Prop[1] = '#' then
                      Canvas.Brush.Color := Hex2Color(Prop)
                    else
                      Canvas.Brush.Color := Text2Color(AnsiLowerCase(prop));
                  end;

                end;

                if (VarPos('SIZE',TagProp,TagPos)>0) then
                begin
                  Prop := Copy(TagProp,TagPos+4,Length(TagProp));
                  Prop := Copy(Prop,Pos('=',Prop)+1,Length(Prop));
                  Prop := Copy(Prop,Pos('"',Prop)+1,Length(Prop));

                  case IStrToInt(Prop) of
                  1:Canvas.Font.Size := 8;
                  2:Canvas.Font.Size := 10;
                  3:Canvas.Font.Size := 12;
                  4:Canvas.Font.Size := 14;
                  5:Canvas.Font.Size := 16;
                  else
                    Canvas.Font.Size := IStrToInt(Prop);
                  end;

                end;
              end;
            end;
        'S':begin
              TagChar := Upcase(s[3]);

              if TagChar = '>' then
                Canvas.Font.Style := Canvas.font.Style + [fsStrikeOut]
              else
              begin
                if TagChar = 'H' then
                  isShad := True
                else
                begin
                  if ipos('<SUB>',s)=1 then
                    isSub := True
                  else
                    if ipos('<SUP>',s)=1 then
                      isSup := True;
                end;
              end;
            end;
        'R':begin
              TagProp := Copy(s,3,pos('>',s)-1);
              prop := Copy(TagProp,ipos('a',TagProp)+2,Length(TagProp));
              prop := Copy(prop,pos('"',prop)+1,Length(prop));
              prop := Copy(prop,1,pos('"',prop)-1);
              Val(prop,Indent,err);
              StartRotated(Canvas,indent);
            end;
        'Z':Invisible := True;
        end;
      end;

      if (VarPos('>',s,TagPos)>0) and not ImgBreak then
      begin
        Res := Res + Copy(s,1,TagPos);
        Delete(s,1,TagPos);
      end
      else
        if not Imgbreak then
          Delete(s,1,Length(s));
    end;
  end;

    w := w - sw;

    if w > xsize then
      xsize := w;

    if (FocusLink = Hyperlinks-1) and Anchor and not Calc then
    begin
      rr.Right := cr.Left;
      rr.Bottom := cr.Bottom;
      InflateRect(rr,1,1);
      if not Calc then
        Canvas.DrawFocusRect(fr);
      rr.Left := r.Left + 1;
      rr.Top := rr.Bottom;
    end;

    Result := Res;
  end;
 {$WARNINGS ON}

begin
  Anchor := False;
  Error := False;
  OldFont := TFont.Create;
  OldFont.Assign(Canvas.Font);
  DrawFont := TFont.Create;
  DrawFont.Assign(Canvas.Font);
  CalcFont := TFont.Create;
  CalcFont.Assign(Canvas.Font);
  OldDrawfont := TFont.Create;
  OldDrawFont.Assign(Canvas.Font);
  OldCalcFont := TFont.Create;
  OldCalcFont.Assign(Canvas.Font);
  BlnkColor := Canvas.Brush.color;
  Canvas.Brush.Color := clNone;
  BGColor := clNone;
  ParaColor := clNone;
  isPara := False;
  isShad := False;
  Invisible := False;

  if IsWinXP then
    UseWinXP := IsThemeActive
  else
    UseWinXP := False;  

  // Control param initialization
  ControlRect := Rect(0,0,0,0);
  CV := '';
  CT := '';
  CID := '';

  Result := False;

  r := fr;
  r.Left := r.Left + 1; {required to add offset for DrawText problem with first capital W letter}

  Align := taLeftJustify;
  PIndent := 0;

  XSize := 0;
  YSize := 0;
  HyperLinks := 0;
  HlCount := 0;
  ListIndex := 0;
  LiCount := 0;
  StripVal := '';
  FocusAnchor := '';
  MouseLink := -1;
  MouseInAnchor := False;

  ImgIdx := 0;
  AltImg := -1;

  SetBKMode(Canvas.Handle,TRANSPARENT);

  DrawStyle := DT_LEFT or DT_SINGLELINE or DT_EXTERNALLEADING or DT_BOTTOM  or DT_EXPANDTABS;// or DT_NOPREFIX;

  if not WordWrap then
    DrawStyle := DrawStyle or DT_END_ELLIPSIS;

  if Pos('&',s) > 0 then
  begin
    repeat
      Foundtag := False;
      //if TagReplacestring('&lt;','<',s) then Foundtag := True;
      //if TagReplacestring('&gt;','>',s) then Foundtag := True;

      if TagReplacestring('&amp;','&&',s) then Foundtag := True;
      if TagReplacestring('&quot;','"',s) then Foundtag := True;

      if TagReplacestring('&sect;','�',s) then Foundtag := True;
      if TagReplacestring('&permil;','��',s) then Foundtag := True;
      if TagReplacestring('&reg;','�',s) then Foundtag := True;

      if TagReplacestring('&copy;','�',s) then Foundtag := True;
      if TagReplacestring('&para;','�',s) then Foundtag := True;

      if TagReplacestring('&trade;','�',s) then Foundtag := True;
      if TagReplacestring('&euro;','�',s) then Foundtag := True;

    until not Foundtag;
  end;

  s := DBTagStrip(s);
  s := CRLFStrip(s,True);

  InsPoint := 0;

  while Length(s) > 0 do
  begin
    {calculate part of the HTML text fitting on the next line}
    Oldfont.Assign(OldCalcFont);
    Canvas.Font.Assign(CalcFont);
    Oldanchor := Anchor;
    OldAnchorVal := LastAnchor;
    suph := 0;
    subh := 0;
    imgali := 0;
    isSup := False;
    isSub := False;

    HtmlHeight := Canvas.TextHeight('gh');

    OldImgIdx := ImgIdx;

    su := HTMLDrawLine(Canvas,s,r,True,HtmlWidth,HtmlHeight,subh,suph,imgali,Align,PIndent,XPos,YPos,HotSpot,ImageHotSpot);

    Anchor := OldAnchor;
    LastAnchor := OldAnchorVal;

    CalcFont.Assign(Canvas.Font);
    OldCalcFont.Assign(OldFont);

    HTMLHeight := HTMLHeight + LineSpacing;

    dr := r;

    case Align of
    taCenter:if (r.right - r.left - htmlwidth > 0) then
               dr.left := r.left+((r.right - r.left - htmlwidth) shr 1);
    taRightJustify:if r.right - htmlwidth > r.left then
                       dr.left := r.right - htmlwidth;
    end;

    dr.Left := dr.Left + PIndent;

    dr.Bottom := dr.Top + HtmlHeight + Subh + Suph;

    if not CheckHeight then
    begin
      OldFont.Assign(OldDrawFont);
      Canvas.Font.Assign(DrawFont);

      HyperLinks := HlCount;
      ListIndex := LiCount;
      ImgIdx := OldImgIdx;

      HTMLDrawLine(Canvas,su,dr,CheckHotSpot,HtmlWidth,HtmlHeight,subh,suph,ImgAli,Align,PIndent,XPos,YPos,HotSpot,ImageHotspot);

      HlCount := HyperLinks;
      LiCount := ListIndex;

      if (HotSpot and
         (YPos > dr.Bottom - ImgAli - Canvas.TextHeight('gh')) and
         (YPos < dr.Bottom - ImgAli)) or ImageHotSpot then
        Result := True;

      DrawFont.Assign(Canvas.Font);
      OldDrawFont.Assign(OldFont);
    end;

    r.top := r.top + HtmlHeight + subh + suph;
    ysize := ysize + HtmlHeight + subh + suph;

    // do not draw below bottom
    if (r.top > r.bottom) and not CheckHeight then
      s := '';
  end;

  if (ysize = 0) then
    ysize := Canvas.TextHeight('gh');

  InsPoint := InsPoint shr 1;

  Canvas.Brush.Color := BlnkColor;
  Canvas.Font.Assign(OldFont);
  OldFont.Free;
  DrawFont.Free;
  CalcFont.Free;
  OldDrawfont.Free;
  OldCalcfont.Free;
end;

{$IFNDEF REMOVEDRAW}
function HTMLDraw(Canvas:TCanvas;s:string;fr:trect;
                                 FImages:TImageList;
                                 xpos,ypos:integer;
                                 checkhotspot,checkheight,print,selected,blink:boolean;
                                 resfactor:double;
                                 URLColor:tcolor;
                                 var Anchorval,StripVal:string;
                                 var XSize,YSize:integer;LineSpacing: integer):boolean;
var
  HyperLinks,MouseLink: Integer;
  Focusanchor,ControlID,ControlValue,ControlType: string;
  r: TRect;
  cr: TRect;
begin
  Result := HTMLDrawEx(Canvas,s,fr,FImages,xpos,ypos,-1,-1,1,checkhotspot,checkheight,print,selected,blink,false,
                       False,false,resfactor,URLColor,clNone,clNone,clGray,anchorval,stripval,focusanchor,xsize,ysize,
                       HyperLinks,MouseLink,r,cr,ControlID,ControlValue,ControlType,nil,nil,0,);
end;

{$IFNDEF REMOVEIPOSFROM}
function IPosFrom(su,s:string;frm:integer):Integer;
var
  i:Integer;
begin
  i := Pos(UpperCase(su),UpperCase(s));
  if i > frm then
    Result := i
  else
    Result := 0;
end;
{$ENDIF}

{$ENDIF}


{$IFNDEF DELPHI4_LVL}
function StringReplace(const S, OldPattern, NewPattern: string): string;
var
  SearchStr, Patt, NewStr: string;
  Offset: Integer;
begin
  SearchStr := S;
  Patt := OldPattern;

  NewStr := S;
  Result := '';
  while SearchStr <> '' do
  begin
    {$IFDEF DELPHI3_LVL}
    Offset := AnsiPos(Patt, SearchStr);
    {$ELSE}
    Offset := Pos(Patt, SearchStr);
    {$ENDIF}

    if Offset = 0 then
    begin
      Result := Result + NewStr;
      Break;
    end;
    Result := Result + Copy(NewStr, 1, Offset - 1) + NewPattern;
    NewStr := Copy(NewStr, Offset + Length(OldPattern), MaxInt);
    Result := Result + NewStr;
    Break;
  end;
end;
{$ENDIF}

{$IFNDEF REMOVESTRIP}

function HTMLStrip(s:string):string;
var
  TagPos: integer;
begin
  Result := '';
  // replace line breaks by linefeeds
  {$IFNDEF DELPHI4_LVL}
  while (pos('<br>',uppercase(s))>0) do s := StringReplace(s,'<br>',chr(13)+chr(10));
  while (pos('<BR>',uppercase(s))>0) do s := StringReplace(s,'<BR>',chr(13)+chr(10));
  while (pos('<hr>',uppercase(s))>0) do s := StringReplace(s,'<hr>',chr(13)+chr(10));
  while (pos('<HR>',uppercase(s))>0) do s := StringReplace(s,'<HR>',chr(13)+chr(10));
 {$ELSE}
  while (pos('<BR>',uppercase(s))>0) do s := StringReplace(s,'<BR>',chr(13)+chr(10),[rfIgnoreCase]);
  while (pos('<HR>',uppercase(s))>0) do s := StringReplace(s,'<HR>',chr(13)+chr(10),[rfIgnoreCase]);
  {$ENDIF}

  {remove all other tags}
  while (VarPos('<',s,TagPos) > 0) do
  begin
    Result := Result + Copy(s,1,TagPos-1);
    if (VarPos('>',s,TagPos)>0) then
      Delete(s,1,TagPos)
    else
      Break;
  end;
  Result := Result + s;
end;
{$ENDIF}

{$IFDEF HILIGHT}

function HTMLStripAll(s:string):string;
var
  TagPos: integer;
begin
  Result := '';

  // remove all tags
  while (VarPos('<',s,TagPos)>0) do
  begin
    Result := Result + Copy(s,1,TagPos-1);
    if (VarPos('>',s,TagPos)>0) then
      Delete(s,1,TagPos);
  end;
  Result := Result + s;
end;

function StripPos2HTMLPos(s:string; i: Integer): Integer;
var
  j,k: Integer;
  Skip: Boolean;
begin
  Result := 0;
  k := 1;
  Skip := False;

  for j := 1 to Length(s) do
  begin
    if s[j] = '<' then
      Skip := True;

    if k = i then
    begin
      Result := j;
      Exit;
    end;

    if not Skip then
      Inc(k);

    if s[j] = '>' then
      Skip := False;

  end;

  if k = i then
  begin
    Result := Length(s) + 1;
  end;
end;


function PosFrom(su,s:string; h: Integer;DoCase: boolean; var Res: Integer): Integer;
var
  r: Integer;
begin
  Result := 0;
  Res := 0;

  if h > 0 then
    Delete(s,1,h);

  if DoCase then
    r := Pos(su,s)
  else
    r := Pos(UpperCase(su),UpperCase(s));

  if r > 0 then
  begin
    Res := h + r;
    Result := Res;
  end;
end;

function HiLight(s,h,tag:string;DoCase:boolean):string;
var
  hs: string;
  l,k: Integer;
begin
  hs := HTMLStripAll(s);

  l := 0;

  while PosFrom(h,hs,l,DoCase,k) > 0 do
  begin
    l := k + Length(h);
    Insert('<'+tag+'>',s,StripPos2HTMLPos(s,k));
    Insert('</'+tag+'>',s,StripPos2HTMLPos(s,l));
  end;

  Result := s;
end;

function UnHiLight(s,tag:string):string;
begin
  Result := '';
  // replace line breaks by linefeeds
  {$IFNDEF DELPHI4_LVL}
  while Pos('<'+tag+'>',s) > 0 do s := StringReplace(s,'<'+tag+'>','');
  while Pos('</'+tag+'>',s) > 0 do s := StringReplace(s,'</'+tag+'>','');
  tag := Uppercase(tag);
  while Pos('<'+tag+'>',s) > 0 do s := StringReplace(s,'<'+tag+'>','');
  while Pos('</'+tag+'>',s) > 0 do s := StringReplace(s,'</'+tag+'>','');
 {$ELSE}
  tag := Uppercase(tag);
  while Pos('<'+tag+'>',Uppercase(s)) > 0 do s := StringReplace(s,'<'+tag+'>','',[rfIgnoreCase]);
  while Pos('</'+tag+'>',Uppercase(s)) > 0 do s := StringReplace(s,'</'+tag+'>','',[rfIgnoreCase]);
  {$ENDIF}
  Result := s;
end;

{$ENDIF}

{$IFDEF PARAMS}

function IPosv(su,s:string;var vp:integer): Integer;
begin
  vp := pos(UpperCase(su),UpperCase(s));
  Result := vp;
end;


function GetHREFValue(html,href:string;var value:string):boolean;
var
  lp: Integer;
begin
  Result := False;
  while IPosv('href="',html,lp) > 0 do
  begin
    Delete(html,1,lp+5); {delete all before}
    if IPosv('"',html,lp) > 0 then
    begin
      if CompareText(href,copy(html,1,lp-1))=0 then
      begin
        {href match - get the value now}
        Delete(html,1,lp);
        if (iposv('>',html,lp)>0) then
        begin
          Delete(html,1,lp);
          if (iposv('<',html,lp)>0) then
          begin
            Value := Copy(html,1,lp-1);
            Result := True;
            Break;
          end;
        end;
      end;
    end;
  end;
end;


function SetHREFValue(var html:string;href,value:string):boolean;
var
  h:string;
  p:string;
  vp: Integer;
begin
  {get current value and do a stringreplace}

  Result := False;
  if GetHREFValue(html,href,h) then
  begin
    p := Copy(html,IPosV('href="' + href,html,vp),Length(html));

    {$IFNDEF DELPHI4_LVL}
    p := StringReplace(p,'>' + h + '</A','>' + value + '</A');
    {$ELSE}
    p := StringReplace(p,'>' + h + '</A','>' + value + '</A',[rfIgnoreCase]);
    {$ENDIF}

    html := Copy(html,1,iposv('href="'+href,html,vp)-1)+p;
    Result := True;
  end;
end;

function HTMLPrep(s: string): string;
begin
{$IFDEF DELPHI4_LVL}
  s := StringReplace(s,'&','&amp;',[rfReplaceAll]);
  s := StringReplace(s,'<','&lt;',[rfReplaceAll]);
  s := StringReplace(s,'>','&gt;',[rfReplaceAll]);
  s := StringReplace(s,'"','&quot;',[rfReplaceAll]);
{$ELSE}
  s := StringReplace(s,'&','&amp;');
  s := StringReplace(s,'<','&lt;');
  s := StringReplace(s,'>','&gt;');
  s := StringReplace(s,'"','&quot;');
{$ENDIF}
  Result := s;
end;

function InvHTMLPrep(s: string): string;
begin
{$IFDEF DELPHI4_LVL}
  s := StringReplace(s,'&lt;','<',[rfReplaceAll]);
  s := StringReplace(s,'&gt;','>',[rfReplaceAll]);
  s := StringReplace(s,'&amp;','&',[rfReplaceAll]);
  s := StringReplace(s,'&quot;','"',[rfReplaceAll]);
{$ELSE}
  s := StringReplace(s,'&lt;','<');
  s := StringReplace(s,'&gt;','>');
  s := StringReplace(s,'&amp;','&');
  s := StringReplace(s,'&quot;','"');
{$ENDIF}
  Result := s;
end;

procedure PropToList(s: string; sl: TStringList);
begin
  sl.Clear;
  while (pos('|',s) > 0) do
  begin
    sl.Add(copy(s,1,pos('|',s) - 1));
    delete(s,1,pos('|',s));
  end;
  if s <> '' then
    sl.Add(s);
end;


function ExtractParamInfo(html,href:string; var AClass,AValue,AProps,AHint: string): Boolean;
var
  lp: Integer;
  Tag,TagProp,ParamClass,ParamName,ParamProps,ParamHint: string;
begin
  Result := False;

  while IPosv('<a',html,lp) > 0 do
  begin
    Delete(html,1,lp + 2); //delete all before

    ParamName := '';
    ParamClass := '';
    ParamProps := '';
    ParamHint := '';

    if IPosv('>',html,lp) > 0 then
    begin
      Tag := Copy(html,1,lp);
      Delete(html,1,lp);

      if IPosv('href="',Tag,lp) > 0 then
      begin
        TagProp := Copy(Tag,lp + 6,Length(Tag));
        if IPosv('"',TagProp,lp) > 0 then
          ParamName := Copy(TagProp,1,lp - 1);
      end;

      if IPosv('props="',Tag,lp) > 0 then
      begin
        TagProp := Copy(Tag,lp + 7,Length(Tag));
        if IPosv('"',TagProp,lp) > 0 then
          ParamProps := Copy(TagProp,1,lp - 1);
      end;

      if IPosv('class="',Tag,lp) > 0 then
      begin
        TagProp := Copy(Tag,lp + 7,Length(Tag));
        if IPosv('"',TagProp,lp) > 0 then
          ParamClass := UpperCase(Copy(TagProp,1,lp - 1));
      end;

      if IPosv('hint="',Tag,lp) > 0 then
      begin
        TagProp := Copy(Tag,lp + 6,Length(Tag));
        if IPosv('"',TagProp,lp) > 0 then
          ParamHint := Copy(TagProp,1,lp - 1);
      end;


      if CompareText(href,ParamName) = 0 then
      begin
        // href match - get the value now
        if IPosv('</',html,lp) > 0 then
        begin
          Avalue := copy(html,1,lp-1);
          AClass := ParamClass;
          AProps := ParamProps;
          AHint := ParamHint;
          Result := True;
          Break;
        end;
      end;
    end;
  end;
end;

{$ENDIF}

procedure SetWinXP;
var
  VerInfo: TOSVersionInfo;
begin
  {$IFNDEF TMSDOTNET}
  VerInfo.dwOSVersionInfoSize := SizeOf(TOSVersionInfo);
  {$ENDIF}
  {$IFDEF TMSDOTNET}
  VerInfo.dwOSVersionInfoSize := Marshal.SizeOf(TypeOf(TOSVersionInfo));
  {$ENDIF}

  GetVersionEx(verinfo);

  IsWinXP := (verinfo.dwMajorVersion > 5) OR
    ((verinfo.dwMajorVersion = 5) AND (verinfo.dwMinorVersion >= 1));
end;


{ TPopupMaskEdit }

procedure TPopupMaskEdit.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
    Style := Style AND NOT WS_CHILD OR WS_POPUP;
end;

procedure TPopupMaskEdit.DoExit;
begin
  inherited;
  if not FCancelled then
  begin
    try
      ValidateEdit;
      if Assigned(OnUpdate) then
        OnUpdate(self,Param,Text);
    except
    end;
  end;
end;

procedure TPopupMaskEdit.WMActivate(var Message: TWMActivate);
begin
  inherited;
//  if (Message.Active = 0) then
//    Hide;
end;

procedure TPopupMaskEdit.WMKeyDown(var Msg: TWMKeydown);
begin
  inherited;
  case Msg.charcode of
  VK_RETURN:
    begin
      try
        ValidateEdit;

        if Assigned(OnUpdate) then
          OnUpdate(self,Param,Text);
        FCancelled := True;

        Parent.SetFocus;
        Visible := False;

        if Assigned(FOnReturn) then
          FOnReturn(Self);

      except

      end;
    end;
  VK_ESCAPE:
    begin
      FCancelled := True;
      Parent.SetFocus;
      Visible := False;
    end;
  end;

end;




{ TPopupEdit }

procedure TPopupEdit.Change;
var
  tw: Integer;
  Canvas: TCanvas;
begin
  inherited;

  if AutoSize then
  begin
    Canvas := TCanvas.Create;
    Canvas.Handle := GetDC(Handle);
    Canvas.Font.Assign(Font);

    tw := Canvas.TextWidth(Text) + 16;
    if tw > Width then
      Width := tw;

    ReleaseDC(Handle,Canvas.Handle);
    Canvas.Free;
  end;
end;

procedure TPopupEdit.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
    Style := Style AND NOT WS_CHILD OR WS_POPUP;
end;

procedure TPopupEdit.DoExit;
begin
  inherited;

  if not FCancelled then
  begin
    if Assigned(OnUpdate) then
      OnUpdate(self,Param,Text);
  end;
end;

procedure TPopupEdit.WMActivate(var Message: TWMActivate);
begin
  inherited;
  if Message.Active = 0 then
  begin
    Hide;
  end;
end;

procedure TPopupEdit.WMChar(var Msg: TWMChar);
begin
  if Msg.CharCode = VK_RETURN then
  begin
    Msg.Result := 1;
    Msg.CharCode := 0;
  end
  else
    inherited;
end;

procedure TPopupEdit.WMKeyDown(var Msg: TWMKeydown);
begin
  case Msg.charcode of
  VK_RETURN:
    begin
      if Assigned(OnUpdate) then
        OnUpdate(self,Param,Text);

      FCancelled := True;
      Parent.SetFocus;
      Visible := False;
      Msg.Result := 1;
      if Assigned(OnReturn) then
        OnReturn(Self);
      Exit;
    end;
  VK_ESCAPE:
    begin
      FCancelled := True;
      Parent.SetFocus;
      Visible := False;
    end;
  end;
  inherited;
end;

{ TPopupSpinEdit }

procedure TPopupSpinEdit.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
    Style := Style AND NOT WS_CHILD OR WS_POPUP;
end;

procedure TPopupSpinEdit.WMActivate(var Message: TWMActivate);
begin
  inherited;
  if Message.Active = 0 then
  begin
    Hide;
  end;
end;

procedure TPopupSpinEdit.WMKeyDown(var Msg: TWMKeydown);
begin
  case Msg.charcode of
  VK_RETURN:
    begin
      if Assigned(OnUpdate) then
        OnUpdate(self,Param,Text);
      FCancelled := True;
      Parent.SetFocus;
      Visible := False;
      Msg.CharCode := 0;
      Msg.Result := 1;
      if Assigned(FOnReturn) then
        FOnReturn(Self);
      
      Exit;
    end;
  VK_ESCAPE:
    begin
      FCancelled := True;
      Parent.SetFocus;
      Visible := False;
    end;
  end;
  inherited;
end;

procedure TPopupSpinEdit.WMChar(var Msg: TWMChar);
begin
  if Msg.CharCode = VK_RETURN then
  begin
    Msg.Result := 1;
    Msg.CharCode := 0;
  end
  else
    inherited;
end;

procedure TPopupSpinEdit.DoExit;
begin
  inherited;
  if not FCancelled then
  begin
    if Assigned(OnUpdate) then
      OnUpdate(self,Param,Text);
  end;
end;

{ TPopupListBox}

procedure TPopupListBox.SizeDropDownWidth;
var
  i: Integer;
  tw,nw: Integer;
  lpmin,lpmax: Integer;
  scrlw: Integer;
begin
  GetScrollRange(self.Handle,SB_VERT,lpmin,lpmax);
  if (lpmin <> 0) or (lpmax <> 0) then
    scrlw := GetSystemMetrics(SM_CXVSCROLL)
  else
   scrlw := 0;
  tw := 0;
  if Items.Count > 0 then
    tw := 0;
  Canvas.Font.Assign(self.Font);
  for i := 1 to self.Items.Count do
  begin
    nw := 10 + Canvas.Textwidth(Items[i-1]); {account for border size?}
    if (nw>tw) then
      tw := nw;
  end;
  Width := tw + scrlw;
end;

procedure TPopupListBox.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
    Style := Style AND NOT (WS_CHILD) OR (WS_POPUP);
end;

procedure TPopupListBox.WMKeyDown(var Msg: TWMKeydown);
begin
  inherited;

  case msg.charcode of
  VK_RETURN:
    begin
      if ItemIndex >= 0 then
      begin
        if Assigned(OnUpdate) then
          OnUpdate(self,Param,Items[ItemIndex]);
      end;
      Parent.SetFocus;
      Visible:= False;
      Parent :=nil;
      if Assigned(FOnReturn) then
        FOnReturn(Self);

    end;
  VK_ESCAPE:
    begin
      Parent.SetFocus;
      Visible := False;
    end;
  end;
end;

procedure TPopupListBox.WMLButtonDown(var Message: TWMLButtonDown);
begin
  inherited;
end;

procedure TPopupListBox.WMActivate(var Message: TWMActivate);
begin
  if Message.Active = 0 then Hide;
end;

procedure TPopupListBox.WMLButtonUp(var Message: TWMLButtonDown);
begin
  inherited;

  Parent.SetFocus;
  Visible := False;
  Parent := nil;

  if ItemIndex >= 0 then
  begin
    if Assigned(OnUpdate) then
      OnUpdate(self,Param,Items[ItemIndex]);
  end;

end;

{ TPopupDatePicker }

{$IFNDEF DELPHI4_LVL}
procedure TPopupDatePicker.CNNotify(var Message: TWMNotify);
begin
  inherited;
  with Message, NMHdr^ do
  begin
    Result := 0;
    case code of
      DTN_CLOSEUP:
        begin
          FDroppedDown := False;
        end;
      DTN_DROPDOWN:
        begin
          FDroppedDown := True;
        end;
    end;
  end;
end;
{$ENDIF}


procedure TPopupDatePicker.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
    Style := Style AND NOT WS_CHILD OR WS_POPUP;
end;

procedure TPopupDatePicker.DoExit;
begin
  inherited;
  if not FCancelled then
  begin
    if Kind = dtkDate then
    begin
      if Assigned(OnUpdate) then
        {$IFNDEF TMSDOTNET}
        OnUpdate(Self,Param,DateToStr(Date));
        {$ENDIF}
        {$IFDEF TMSDOTNET}
        OnUpdate(Self,Param,DateToStr(DateTime));
        {$ENDIF}

    end
    else
    begin
      if Assigned(OnUpdate) then
        {$IFNDEF TMSDOTNET}
        OnUpdate(Self,Param,TimeToStr(Date));
        {$ENDIF}
        {$IFDEF TMSDOTNET}
        OnUpdate(Self,Param,TimeToStr(DateTime));
        {$ENDIF}
    end;
  end;
  Hide;
end;

procedure TPopupDatePicker.ReInit;
begin
  RecreateWnd;
end;

procedure TPopupDatePicker.WMActivate(var Message: TWMActivate);
begin
  inherited;
  if not DroppedDown then
    if Message.Active = 0 then
    begin
      Hide;
    end;
end;

procedure TPopupDatePicker.WMKeyDown(var Msg: TWMKeydown);
begin
  inherited;
  case Msg.charcode of
  VK_RETURN:
    begin
      if Kind = dtkDate then
      begin
        if Assigned(OnUpdate) then
          {$IFNDEF TMSDOTNET}
          OnUpdate(Self,Param,DateToStr(Date));
          {$ENDIF}
          {$IFDEF TMSDOTNET}
          OnUpdate(Self,Param,DateToStr(DateTime));
          {$ENDIF}

      end
      else
      begin
        if Assigned(OnUpdate) then
          {$IFNDEF TMSDOTNET}
          OnUpdate(Self,Param,TimeToStr(Date));
          {$ENDIF}
          {$IFDEF TMSDOTNET}
          OnUpdate(Self,Param,TimeToStr(DateTime));
          {$ENDIF}
      end;

      FCancelled := True;
      Parent.SetFocus;
      Visible := False;
      if Assigned(FOnReturn) then
        FOnReturn(Self);
    end;
  VK_ESCAPE:
    begin
      FCancelled := True;
      Parent.SetFocus;
      Visible := False;
    end;
  end;
end;

{ TatSpinEdit }

constructor TatSpinEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FButton := TatSpinButton.Create (Self);
  FButton.Width := 15;
  FButton.Height := 17;
  FButton.Visible := True;
  FButton.Parent := Self;
  FButton.FocusControl := Self;
  FButton.OnUpClick := UpClick;
  FButton.OnDownClick := DownClick;
  Text := '0';
  ControlStyle := ControlStyle - [csSetCaption];
  FIncrement := 1;
  FEditorEnabled := True;
end;

destructor TatSpinEdit.Destroy;
begin
  FButton := nil;
  inherited Destroy;
end;

procedure TatSpinEdit.GetChildren(Proc: TGetChildProc; Root: TComponent);
begin
end;

procedure TatSpinEdit.KeyDown(var Key: Word; Shift: TShiftState);
begin
  if Key = VK_UP then UpClick (Self)
  else if Key = VK_DOWN then DownClick (Self);
  inherited KeyDown(Key, Shift);
end;

procedure TatSpinEdit.KeyPress(var Key: Char);
begin
  if not IsValidChar(Key) then
  begin
    Key := #0;
    MessageBeep(0)
  end;
  if Key <> #0 then inherited KeyPress(Key);
end;

function TatSpinEdit.IsValidChar(Key: Char): Boolean;
begin
  {$IFNDEF TMSDOTNET}
  Result := (Key in [DecimalSeparator, '+', '-', '0'..'9']) or
    ((Key < #32) and (Key <> Chr(VK_RETURN)));
  {$ENDIF}

  {$IFDEF TMSDOTNET}
  Result := (Key = DecimalSeparator) or (Key in ['+', '-', '0'..'9']) or
    ((Key < #32) and (Key <> Chr(VK_RETURN)));
  {$ENDIF}
  if not FEditorEnabled and Result and ((Key >= #32) or
      (Key = Char(VK_BACK)) or (Key = Char(VK_DELETE))) then
    Result := False;
end;

procedure TatSpinEdit.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
{  Params.Style := Params.Style and not WS_BORDER;  }
  Params.Style := Params.Style or ES_MULTILINE or WS_CLIPCHILDREN;
end;

procedure TatSpinEdit.CreateWnd;
begin
  inherited CreateWnd;
  SetEditRect;
end;

procedure TatSpinEdit.SetEditRect;
var
  Loc: TRect;
begin
  {$IFNDEF TMSDOTNET}
  SendMessage(Handle, EM_GETRECT, 0, LongInt(@Loc));
  {$ENDIF}
  {$IFDEF TMSDOTNET}
  Perform(EM_GETRECT, 0 , Loc);
  {$ENDIF}
  Loc.Bottom := ClientHeight + 1;  {+1 is workaround for windows paint bug}
  Loc.Right := ClientWidth - FButton.Width - 2;
  Loc.Top := 0;
  Loc.Left := 0;
  {$IFNDEF TMSDOTNET}
  SendMessage(Handle, EM_SETRECTNP, 0, LongInt(@Loc));
  SendMessage(Handle, EM_GETRECT, 0, LongInt(@Loc));  {debug}
  {$ENDIF}
  {$IFDEF TMSDOTNET}
  Perform(EM_SETRECTNP, 0 , Loc);
  Perform(EM_GETRECT, 0 , Loc);
  {$ENDIF}
end;

procedure TatSpinEdit.WMSize(var Message: TWMSize);
var
  MinHeight: Integer;
begin
  inherited;
  MinHeight := GetMinHeight;
    { text edit bug: if size to less than minheight, then edit ctrl does
      not display the text }
  if Height < MinHeight then   
    Height := MinHeight
  else if FButton <> nil then
  begin
    if NewStyleControls and Ctl3D then
      FButton.SetBounds(Width - FButton.Width - 5, 0, FButton.Width, Height - 5)
    else FButton.SetBounds (Width - FButton.Width, 1, FButton.Width, Height - 3);
    SetEditRect;
  end;
end;

function TatSpinEdit.GetMinHeight: Integer;
var
  DC: HDC;
  SaveFont: HFont;
  I: Integer;
  SysMetrics, Metrics: TTextMetric;
begin
  DC := GetDC(0);
  GetTextMetrics(DC, SysMetrics);
  SaveFont := SelectObject(DC, Font.Handle);
  GetTextMetrics(DC, Metrics);
  SelectObject(DC, SaveFont);
  ReleaseDC(0, DC);
  I := SysMetrics.tmHeight;
  if I > Metrics.tmHeight then I := Metrics.tmHeight;
  Result := Metrics.tmHeight + I div 4 + GetSystemMetrics(SM_CYBORDER) * 4 + 2;
end;

procedure TatSpinEdit.UpClick (Sender: TObject);
begin
  if ReadOnly then MessageBeep(0)
  else Value := Value + FIncrement;
end;

procedure TatSpinEdit.DownClick (Sender: TObject);
begin
  if ReadOnly then MessageBeep(0)
  else Value := Value - FIncrement;
end;

procedure TatSpinEdit.WMPaste(var Message: TWMPaste);   
begin
  if not FEditorEnabled or ReadOnly then Exit;
  inherited;
end;

procedure TatSpinEdit.WMCut(var Message: TWMPaste);   
begin
  if not FEditorEnabled or ReadOnly then Exit;
  inherited;
end;

procedure TatSpinEdit.CMExit(var Message: TCMExit);
begin
  inherited;
  if CheckValue (Value) <> Value then
    SetValue (Value);
end;

function TatSpinEdit.GetValue: LongInt;
begin
  try
    Result := StrToInt (Text);
  except
    Result := FMinValue;
  end;
end;

procedure TatSpinEdit.SetValue (NewValue: LongInt);
begin
  Text := IntToStr (CheckValue (NewValue));
end;

function TatSpinEdit.CheckValue (NewValue: LongInt): LongInt;
begin
  Result := NewValue;
  if (FMaxValue <> FMinValue) then
  begin
    if NewValue < FMinValue then
      Result := FMinValue
    else if NewValue > FMaxValue then
      Result := FMaxValue;
  end;
end;

procedure TatSpinEdit.CMEnter(var Message: TCMGotFocus);
begin
  if AutoSelect and not (csLButtonDown in ControlState) then
    SelectAll;
  inherited;
end;

{TatTimerSpeedButton}

destructor TatTimerSpeedButton.Destroy;
begin
  if FRepeatTimer <> nil then
    FRepeatTimer.Free;
  inherited Destroy;
end;

const
  InitRepeatPause = 400;  { pause before repeat timer (ms) }
  RepeatPause     = 100;  { pause before hint window displays (ms)}
  
procedure TatTimerSpeedButton.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited MouseDown (Button, Shift, X, Y);
  if tbAllowTimer in FTimeBtnState then
  begin
    if FRepeatTimer = nil then
      FRepeatTimer := TTimer.Create(Self);

    FRepeatTimer.OnTimer := TimerExpired;
    FRepeatTimer.Interval := InitRepeatPause;
    FRepeatTimer.Enabled  := True;
  end;
end;

procedure TatTimerSpeedButton.MouseUp(Button: TMouseButton; Shift: TShiftState;
                                  X, Y: Integer);
begin
  inherited MouseUp (Button, Shift, X, Y);
  if FRepeatTimer <> nil then
    FRepeatTimer.Enabled  := False;
end;

procedure TatTimerSpeedButton.TimerExpired(Sender: TObject);
begin
  FRepeatTimer.Interval := RepeatPause;
  if (FState = bsDown) and MouseCapture then
  begin
    try
      Click;
    except
      FRepeatTimer.Enabled := False;
      raise;
    end;
  end;
end;

procedure TatTimerSpeedButton.Paint;
var
  R: TRect;
begin
  inherited Paint;
  if tbFocusRect in FTimeBtnState then
  begin
    R := Bounds(0, 0, Width, Height);
    InflateRect(R, -3, -3);
    if FState = bsDown then
      OffsetRect(R, 1, 1);
    DrawFocusRect(Canvas.Handle, R);
  end;
end;

{ TatSpinButton }

constructor TatSpinButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle - [csAcceptsControls, csSetCaption] +
    [csFramed, csOpaque];

  FUpButton := CreateButton;
  FDownButton := CreateButton;
  UpGlyph := nil;
  DownGlyph := nil;

  Width := 20;
  Height := 25;
  FFocusedButton := FUpButton;
end;

function TatSpinButton.CreateButton: TatTimerSpeedButton;
begin
  Result := TatTimerSpeedButton.Create (Self);
  Result.OnClick := BtnClick;
  Result.OnMouseDown := BtnMouseDown;
  Result.Visible := True;
  Result.Enabled := True;
  Result.TimeBtnState := [tbAllowTimer];
  Result.Parent := Self;
end;

procedure TatSpinButton.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FFocusControl) then
    FFocusControl := nil;
end;

procedure TatSpinButton.AdjustSize (var W, H: Integer);
begin
  if (FUpButton = nil) or (csLoading in ComponentState) then Exit;
  if W < 15 then W := 15;
  FUpButton.SetBounds (0, 0, W, H div 2);
  FDownButton.SetBounds (0, FUpButton.Height - 1, W, H - FUpButton.Height + 1);
end;

procedure TatSpinButton.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
var
  W, H: Integer;
begin
  W := AWidth;
  H := AHeight;
  AdjustSize (W, H);
  inherited SetBounds (ALeft, ATop, W, H);
end;

procedure TatSpinButton.WMSize(var Message: TWMSize);
var
  W, H: Integer;
begin
  inherited;

  { check for minimum size }
  W := Width;
  H := Height;
  AdjustSize (W, H);
  if (W <> Width) or (H <> Height) then
    inherited SetBounds(Left, Top, W, H);
  Message.Result := 0;
end;

procedure TatSpinButton.WMSetFocus(var Message: TWMSetFocus);
begin
  FFocusedButton.TimeBtnState := FFocusedButton.TimeBtnState + [tbFocusRect];
  FFocusedButton.Invalidate;
end;

procedure TatSpinButton.WMKillFocus(var Message: TWMKillFocus);
begin
  FFocusedButton.TimeBtnState := FFocusedButton.TimeBtnState - [tbFocusRect];
  FFocusedButton.Invalidate;
end;

procedure TatSpinButton.KeyDown(var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_UP:
      begin
        SetFocusBtn (FUpButton);
        FUpButton.Click;
      end;
    VK_DOWN:
      begin
        SetFocusBtn (FDownButton);
        FDownButton.Click;
      end;
    VK_SPACE:
      FFocusedButton.Click;
  end;
end;

procedure TatSpinButton.BtnMouseDown (Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    SetFocusBtn (TatTimerSpeedButton (Sender));
    if (FFocusControl <> nil) and FFocusControl.TabStop and 
        FFocusControl.CanFocus and (GetFocus <> FFocusControl.Handle) then
      FFocusControl.SetFocus
    else if TabStop and (GetFocus <> Handle) and CanFocus then
      SetFocus;
  end;
end;

procedure TatSpinButton.BtnClick(Sender: TObject);
begin
  if Sender = FUpButton then
  begin
    if Assigned(FOnUpClick) then FOnUpClick(Self);
  end
  else
    if Assigned(FOnDownClick) then FOnDownClick(Self);
end;

procedure TatSpinButton.SetFocusBtn (Btn: TatTimerSpeedButton);
begin
  if TabStop and CanFocus and  (Btn <> FFocusedButton) then
  begin
    FFocusedButton.TimeBtnState := FFocusedButton.TimeBtnState - [tbFocusRect];
    FFocusedButton := Btn;
    if (GetFocus = Handle) then 
    begin
       FFocusedButton.TimeBtnState := FFocusedButton.TimeBtnState + [tbFocusRect];
       Invalidate;
    end;
  end;
end;

procedure TatSpinButton.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  Message.Result := DLGC_WANTARROWS;
end;

procedure TatSpinButton.Loaded;
var
  W, H: Integer;
begin
  inherited Loaded;
  W := Width;
  H := Height;
  AdjustSize (W, H);
  if (W <> Width) or (H <> Height) then
    inherited SetBounds (Left, Top, W, H);
end;

function TatSpinButton.GetUpGlyph: TBitmap;
begin
  Result := FUpButton.Glyph;
end;

procedure TatSpinButton.SetUpGlyph(Value: TBitmap);
begin
  if Value <> nil then
    FUpButton.Glyph := Value
  else
  begin
    FUpButton.Glyph.Handle := LoadBitmap(HInstance, 'SpinUp');
    FUpButton.NumGlyphs := 1;
    FUpButton.Invalidate;
  end;
end;

function TatSpinButton.GetUpNumGlyphs: TNumGlyphs;
begin
  Result := FUpButton.NumGlyphs;
end;

procedure TatSpinButton.SetUpNumGlyphs(Value: TNumGlyphs);
begin
  FUpButton.NumGlyphs := Value;
end;

function TatSpinButton.GetDownGlyph: TBitmap;
begin
  Result := FDownButton.Glyph;
end;

procedure TatSpinButton.SetDownGlyph(Value: TBitmap);
begin
  if Value <> nil then
    FDownButton.Glyph := Value
  else
  begin
    FDownButton.Glyph.Handle := LoadBitmap(HInstance, 'SpinDown');
    FUpButton.NumGlyphs := 1;
    FDownButton.Invalidate;
  end;
end;

function TatSpinButton.GetDownNumGlyphs: TNumGlyphs;
begin
  Result := FDownButton.NumGlyphs;
end;

procedure TatSpinButton.SetDownNumGlyphs(Value: TNumGlyphs);
begin
  FDownButton.NumGlyphs := Value;
end;

initialization
  SetWinXP;

end.

