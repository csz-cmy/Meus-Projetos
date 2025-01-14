/// A small unit containing a VCL print-preview component.
unit UFlexCelPreview;
{$IFDEF LINUX}{$INCLUDE ../FLXCOMPILER.INC}{$ELSE}{$INCLUDE ..\FLXCOMPILER.INC}{$ENDIF}
{$IFDEF LINUX}{$INCLUDE ../FLXCONFIG.INC}{$ELSE}{$INCLUDE ..\FLXCONFIG.INC}{$ENDIF}

interface

uses
  {$IFDEF FLX_VCL}
    {$IFDEF FLX_FPC}
    LCLType, LCLIntf,
    {$ELSE}
    Windows,
    {$ENDIF}
    Graphics, Messages, Printers, Forms, Controls,
  {$ENDIF}
  {$IFDEF FLX_CLX}
    Qt, QGraphics, QGrids, Types, QControls, QPrinters, QForms,
  {$ENDIF}
  {$IFDEF FLX_NEEDSVARIANTS} variants, {$ENDIF}

  SysUtils, Classes, UExcelAdapter, UFlexCelImport, Contnrs,
  UFlexCelGrid, UFlxMessages, XlsMessages;

type
  TBmpCache=class
  public
    PageNo: integer;
    Bmp: TBitmap;

    constructor Create(const aBmp: TBitmap; const aPageNo: integer);
    destructor Destroy; override;
  end;

  TBmpCacheList=class(TObjectList)
    {$INCLUDE TBmpCacheListHdr.inc}
  end;

  TFlexCelPreview=class;

  /// <summary>
  /// Event associated with <see cref="TFlexCelPreview.OnPageChange" />.
  /// </summary>                                                        
  TFlxOnPageChangeEvent=procedure(const Sender: TFlexCelPreview; const PageNumber, TotalPages: integer) of object;

  /// <summary>
  /// Displays a Print-Preview of a TFlexCelGrid.
  /// </summary>
  /// <remarks>
  /// This is a very simple component, to display a print-preview of what TFlexCelGrid is going to print.
  /// You can use it as it is, or modify it to your needs. The preview is really generated by FlexCelGrid,
  /// this component just gives a nicer interface to it.<para></para>
  /// <para></para>
  /// Drop a FlexCelPreview on a form, connect it to a TFlexCelGrid, and remember to call the init method
  /// before using it. You can look at XlsViewer for a demo.<para></para>
  /// <para></para>
  /// \Note that because printers usually have more resolution than screens (typically 1200 DPI on a
  /// printer vs 96 DPI on a screen), the preview can show the data with little rounding errors, maybe a
  /// missing line or a misaligned label, that won't show when you actually print the page.<para></para>
  /// </remarks>
  TFlexCelPreview = class(TScrollBox)
  private
    FCanvas: TCanvas;

    FOnPageChange: TFlxOnPageChangeEvent;
    FPageMargin: integer;
    FMaxBmpCache: integer;
    FFlexCelGrid: TFlexCelGrid;
    FZoomPreview: integer;
    FCenteredPreview: boolean;

    FScrollWheelOffset: integer;


    procedure SetMaxBmpCache(const Value: integer);
    procedure SetPageMargin(const Value: integer);
    procedure SetZoomPreview(const Value: integer);
    procedure SetCenteredPreview(const Value: boolean);

  private
    Ph:integer; Pw: integer;
    PrintRange: TXlsCellRange;
    BmpCache: TBmpCacheList;
    FCurrentPage, FTotalPages, FirstPage, LastPage: integer;
    ZoomPreview100: extended;
    FPageColor: TColor;
    procedure GetPageDim;
    procedure SetCurrentPage(const Value: integer);
    procedure SetPageColor(const Value: TColor);
    { Private declarations }
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure Paint;virtual;
    {$IFDEF FLX_VCL}
    procedure PaintWindow(DC: HDC);override;
      {$IFNDEF FLX_FPC}
      procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
      {$ENDIF}
    {$ENDIF}
    {$IFDEF FLX_CLX}
    procedure Painting(Sender: QObjectH; EventRegion: QRegionH);override;
    {$ENDIF}

    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    function DoMouseWheelDown(Shift: TShiftState; {$IFDEF FLX_CLX}const {$endif} MousePos: TPoint): Boolean; override;
    function DoMouseWheelUp(Shift: TShiftState; {$IFDEF FLX_CLX}const {$endif} MousePos: TPoint): Boolean; override;
    procedure WMGetDlgCode(var Message: TMessage); message WM_GETDLGCODE;
    procedure Click; override;

    /// <summary>
    /// It is called when the preview window is resized. Overwrite this method to add your own custom behavior.
    /// </summary>
    procedure Resize; override;

  public
    /// <summary>
    /// Initializes the preview.
    /// </summary>
    /// <remarks>
    /// Call this method always before activating the preview. It will load all parameters from the grid and
    /// initialize the preview.<para></para>
    /// 
    /// </remarks>
    /// <param name="aPrintRange">Pass the same range here as you will when you finally call print.</param>
    /// <param name="aFirstPage">First page to display in the preview, defaults to 1.</param>
    /// <param name="aLastPage">Last page to display in the preview, defaults to \-1. (\-1 means display up
    ///                         to the last page)</param>                                                   
    procedure Init(const aPrintRange: TXlsCellRange;const aFirstPage:integer =1; const aLastPage:integer =-1);
    /// <summary>
    /// Frees all resources associated with the preview.
    /// </summary>
    /// <remarks>
    /// You don't really need to call this method, as it will be called automatically when the component is
    /// destroyed or re-initialized, so you won't get any memory leaks.<para></para>
    /// But, if you are going to keep the component in memory for a long time, it is good idea to release the
    /// resources allocated as soon as you can.<para></para>
    /// 
    /// </remarks>                                                                                           
    procedure Done;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    /// <summary>
    /// TCanvas where the component will draw the preview.
    /// </summary>
    /// <remarks>
    /// In normal use you shouldn't need this property, but it can be useful if you are creating your own
    /// descendant of TFlexCelPreview.<para></para>
    /// </remarks>
    property Canvas: TCanvas read FCanvas;


    /// <summary>
    /// Page where the preview is. You can change this value to programatically move the preview.
    /// </summary>
    property CurrentPage: integer read FCurrentPage write SetCurrentPage;

    /// <summary>
    /// Number of pages in the preview.
    /// </summary>
    property TotalPages: integer read FTotalPages;

  published
    /// <summary>
    /// TFlexCelGrid component you want to preview.
    /// </summary>
    /// <remarks>
    /// This contains the grid you want to print.
    /// </remarks>
    property FlexCelGrid: TFlexCelGrid read FFlexCelGrid write FFlexCelGrid;

    /// <summary>
    /// Zoom of the preview page on the screen.
    /// </summary>
    /// <remarks>
    /// \Note that the <see cref="TFlexCelGrid.Zoom" text="TFlexCelGrid.Zoom Property" /> remains the same,
    /// this property only changes the zoom of the preview.
    /// </remarks>                                                                                         
    property ZoomPreview: integer read FZoomPreview write SetZoomPreview default 100;

    /// <summary>
    /// Distance, in pixels, between one page and the next.
    /// </summary>
    /// <remarks>
    /// This is the size of the gray border between pages. If you make it larger, pages will appear more
    /// distant from the others.<para></para>
    /// </remarks>
    property PageMargin: integer read FPageMargin write SetPageMargin default 10;

    /// <summary>
    /// When true, the preview will show in the middle of the window, instead of at the left.
    /// </summary>
    property CenteredPreview: boolean read FCenteredPreview write SetCenteredPreview default false;

    /// <summary>
    /// Number of page images to keep in memory.
    /// </summary>
    /// <remarks>
    /// FlexCelPreview holds a collection of generated images for the pages it displays, so it can render
    /// them faster. By changing MaxBmpCache you can decide how many images you want to hold in memory at the
    /// same time. The default is 10.<para></para>
    /// <para></para>
    /// This property has no effect when ZoomPreview is larger than 100% On this case, the Bmp cache will
    /// have only the current page to preserve resources.<para></para>
    /// </remarks>                                                                                           
    property MaxBmpCache: integer read FMaxBmpCache write SetMaxBmpCache default 10;

    /// <summary>
    /// How many lines the preview should scroll down when the user move the scroll wheel.
    /// </summary>
    /// <remarks>
    /// Set ScrollWheelOffset to a negative value to have standard behavior.
    /// </remarks>                                                                        
    property ScrollWheelOffset: integer read FScrollWheelOffset write FScrollWheelOffset default 1;

    /// <summary>
    /// Occurs each time the user scrolls to a different page.
    /// </summary>
    /// <remarks>
    /// You can use this event to have an status bar displaying the actual page.<para></para>
    ///
    /// </remarks>
    /// <param name="Sender">TFlexCelPreview component sending the event.</param>
    /// <param name="PageNumber">Page number we are going to display.</param>
    /// <param name="TotalPages">Total number of pages in the preview.</param>
    property OnPageChange: TFlxOnPageChangeEvent read FOnPageChange write FOnPageChange;

    /// <summary>
    /// Color for the page background. By default this is clWindow.
    /// </summary>
    /// <remarks>
    /// This setting doesn't change what is printed, only what is displayed in the preview.
    /// </remarks>
    property PageColor: TColor read FPageColor write SetPageColor;
  end;

implementation
{$INCLUDE TBmpCacheListImp.inc}
{ TFlexCelPreview }

procedure TFlexCelPreview.GetPageDim;
var
  RealXPpi, RealYPpi: integer;
begin
  {$IFNDEF FLX_FPC}
    RealXPpi:=GetDeviceCaps(Printer.handle, LOGPIXELSX);
    RealYPpi:=GetDeviceCaps(Printer.handle, LOGPIXELSY);
  {$ELSE}
    RealXppi:=Printer.XDPI;
    RealYppi:=Printer.YDPI;
  {$ENDIF}
  
    Ph:=Round((Printer.PageHeight/RealYPPi*96)*ZoomPreview100)+PageMargin;
    Pw:=Round((Printer.PageWidth/RealXPPI*96)*ZoomPreview100)+PageMargin;

    HorzScrollBar.Range:=Pw+PageMargin;
    if (LastPage>0) then VertScrollBar.Range:=(LastPage-FirstPage+1)*Ph+PageMargin
    else VertScrollBar.Range:=(FTotalPages-FirstPage+1)*Ph+PageMargin;
    FCurrentPage:=0;
end;

procedure TFlexCelPreview.Paint;
var
  PageNumber, Index: integer;
  TmpBmp: TBitmap;
  St, En, Delta, i: integer;
  BkColor: TColor;
  XOffset: integer;
begin
  if not Assigned(FFlexCelGrid) then exit;
  try
    if Ph=0 then exit;

    St:=VertScrollBar.Position;
    En:=St+ClientHeight;
    if FCurrentPage<>St div Ph+FirstPage then
    begin
      FCurrentPage:= St div Ph+FirstPage;
      if Assigned(OnPageChange) then OnPageChange(Self, FCurrentPage, FTotalPages);
    end;
    for PageNumber:= St div Ph+FirstPage to En div Ph+FirstPage do
    begin
      if ((LastPage>0) and (PageNumber>LastPage)) or (PageNumber>FTotalPages) then
      begin
      end else
      begin
        if not BmpCache.Find(PageNumber, Index) then
        begin
          if (BmpCache.Count<MaxBmpCache) and ((FZoomPreview<=100)or (BmpCache.Count=0)) then   //For zoom>100 don't keep a cache
          begin
            TmpBmp:=TBitmap.Create;
            TmpBmp.Width:=Pw-PageMargin;
            TmpBmp.Height:=Ph-PageMargin;
            BmpCache.Insert(Index, TBmpCache.Create(TmpBmp, PageNumber));
          end else
          begin
            //Search for the most far away item on the cache
            Index:=0;
            Delta:=0;
            for i:=0 to BmpCache.Count-1 do
              if Abs(BmpCache[i].PageNo-PageNumber)>Delta then
              begin
                Index:=i;
                Delta:=Abs(BmpCache[i].PageNo-PageNumber);
              end;
            BmpCache[Index].PageNo:=PageNumber;
            BmpCache.Sort;
            if not BmpCache.Find(PageNumber, Index) then raise Exception.Create(ErrInternal);
          end;
          BmpCache[Index].Bmp.Canvas.Brush.Color:= PageColor;
          BmpCache[Index].Bmp.Canvas.FillRect(Rect(0, 0, Pw-PageMargin,Ph-PageMargin));

          BkColor := FlexCelGrid.BackgroundColor;
          try
            FlexCelGrid.BackgroundColor := PageColor;
            FFlexCelGrid.PreviewPage(PrintRange, PageNumber, BmpCache[Index].Bmp.Canvas, FZoomPreview);
          finally
            FlexCelGrid.BackgroundColor := BkColor;
          end;
        end;

        XOffset := 0;
        if CenteredPreview and (Width > Pw + 2*PageMargin) then
        begin
          XOffset := (Width - (Pw + 2*PageMargin)) div 2;
        end;

        FCanvas.Draw(PageMargin-HorzScrollBar.Position + XOffset,PageMargin+(Ph*(PageNumber-FirstPage)-VertScrollBar.Position),BmpCache[Index].Bmp);
      end;
    end;
  except
    //no exceptions on paint...
  end;//Except
end;

procedure TFlexCelPreview.Init(const aPrintRange: TXlsCellRange;const aFirstPage:integer=1; const aLastPage:integer =-1);
begin
  PrintRange:=aPrintRange;
  FirstPage:=aFirstPage;
  LastPage:=aLastPage;
  FlexCelGrid.CalcNumberOfPrintingPages( PrintRange, FTotalPages);
  GetPageDim;
  Done;
end;

destructor TFlexCelPreview.Destroy;
begin
  FreeAndNil(BmpCache);
//  FCanvas.Free;
  inherited Destroy;
  // This is freed after calling inherited because the inherited destructor
  // can force a paint operation if a Invalidate is pending. We should keep
  // the canvas around as long as possible.
  FCanvas.Free;
end;

procedure TFlexCelPreview.Done;
begin
  if BmpCache<>nil then BmpCache.Clear;
end;


procedure TFlexCelPreview.SetCurrentPage(const Value: integer);
var
  NewPage: integer;
begin
  if Value < 0 then NewPage := 0
  else if Value > TotalPages -1 then NewPage := FTotalPages
  else NewPage := Value;

  VertScrollBar.Position := (NewPage - FirstPage)*Ph;
  Invalidate;
end;

procedure TFlexCelPreview.SetMaxBmpCache(const Value: integer);
begin
  if (Value<1) or (Value>1000) then raise Exception.CreateFmt(ErrIndexOutBounds,[Value,'MaxBmpCache',1, 1000]);
  FMaxBmpCache := Value;
  Done;
  Invalidate;
end;

procedure TFlexCelPreview.SetPageColor(const Value: TColor);
begin
  FPageColor := Value;
  Done;
  Invalidate;
end;

procedure TFlexCelPreview.SetPageMargin(const Value: integer);
begin
  if (Value<1) or (Value>1000) then raise Exception.CreateFmt(ErrIndexOutBounds,[Value,'PageMargin',1, 1000]);
  FPageMargin := Value;
  Done;
  Invalidate;
end;

procedure TFlexCelPreview.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if Operation = opRemove then
  begin
    if AComponent = FFlexCelGrid then
        FFlexCelGrid:= nil;
  end;
end;

constructor TFlexCelPreview.Create(AOwner: TComponent);
begin
  inherited;
  FZoomPreview:=100;
  ZoomPreview100:=FZoomPreview/100;
  FPageMargin:=10;
  FMaxBmpCache:=10;
  FCanvas := TControlCanvas.Create;
  TControlCanvas(FCanvas).Control := Self;
  Color:=cl3DDkShadow;
  FPageColor:=clWindow;
  FCenteredPreview := false;

  {$IFNDEF FLX_FPC}
  VertScrollBar.Tracking:=true;
  HorzScrollBar.Tracking:=true;
  {$ENDIF}
  
  FScrollWheelOffset := 1;
  {$IFDEF FLX_VCL}
  DoubleBuffered:=true;
  {$ENDIF}
  BmpCache:= TBmpCacheList.Create;
  TabStop := true;
  ControlStyle := ControlStyle - [csNoStdEvents];
end;

procedure TFlexCelPreview.SetZoomPreview(const Value: integer);
begin
  if (Value<10) or (Value>400) then raise Exception.CreateFmt(ErrIndexOutBounds,[Value,'ZoomPreview',10, 400]);
  FZoomPreview := Value;
  ZoomPreview100:=FZoomPreview/100;
  Done;
  GetPageDim;
  Invalidate;
end;

procedure TFlexCelPreview.SetCenteredPreview(const Value: boolean);
begin
  FCenteredPreview := Value;
  Invalidate;
end;

{$IFDEF FLX_VCL}
procedure TFlexCelPreview.PaintWindow(DC: HDC);
begin
  FCanvas.Lock;
  try
    FCanvas.Handle := DC;
    try
      {$IFNDEF FLX_FPC}
      TControlCanvas(FCanvas).UpdateTextFlags;
      {$ENDIF}
      Paint;
    finally
      FCanvas.Handle := 0;
    end;
  finally
    FCanvas.Unlock;
  end;
end;

{$IFNDEF FLX_FPC}
procedure TFlexCelPreview.WMPaint(var Message: TWMPaint);
begin
  ControlState:=ControlState + [csCustomPaint];
  try
    inherited;
  except
    //nothing to do...
  end;
  ControlState:=ControlState - [csCustomPaint];
end;
{$ENDIF}

{$ENDIF}
{$IFDEF FLX_CLX}
procedure TFlexCelPreview.Painting(Sender: QObjectH; EventRegion: QRegionH);
begin
  TControlCanvas(FCanvas).StartPaint;
  try
    QPainter_setClipRegion(FCanvas.Handle, EventRegion);
    Paint;
  finally
    TControlCanvas(FCanvas).StopPaint;
  end;
end;
{$ENDIF}

function TFlexCelPreview.DoMouseWheelDown(Shift: TShiftState;
  {$IFDEF FLX_CLX}const {$endif} MousePos: TPoint): Boolean;
begin
  if (ScrollWheelOffset < 0) then
  begin
    Result:= inherited DoMouseWheelDown(Shift, MousePos);
    exit;
  end;

  Result := False;
  if Assigned(OnMouseWheelDown) then
    OnMouseWheelDown(Self, Shift, MousePos, Result);

  if not Result then
  begin
    if (ssShift in Shift) then
    begin
      HorzScrollBar.Position := HorzScrollBar.Position + Round(ScrollWheelOffset * $A * ColMult);
    end else
    if (ssCtrl in Shift) then
    begin
      if ZoomPreview > 20 then ZoomPreview := ZoomPreview - 5;
    end else
    begin
      VertScrollBar.Position := VertScrollBar.Position + Round(ScrollWheelOffset * $A * RowMult);
    end;
    Result:= true;
  end;
end;

function TFlexCelPreview.DoMouseWheelUp(Shift: TShiftState;
  {$IFDEF FLX_CLX}const {$endif} MousePos: TPoint): Boolean;
begin
  if (ScrollWheelOffset < 0) then
  begin
    Result:= inherited DoMouseWheelUp(Shift, MousePos);
    exit;
  end;

  Result := False;
  if Assigned(OnMouseWheelUp) then
    OnMouseWheelUp(Self, Shift, MousePos, Result);

  if not Result then
  begin
    if (ssShift in Shift) then
    begin
      HorzScrollBar.Position := HorzScrollBar.Position - Round(ScrollWheelOffset * $A * ColMult);
    end else
    if (ssCtrl in Shift) then
    begin
      if ZoomPreview < 200 then ZoomPreview := ZoomPreview + 5;
    end else
    begin
      VertScrollBar.Position := VertScrollBar.Position - Round(ScrollWheelOffset * $A * RowMult);
    end;
    Result:= true;
  end;
end;

procedure TFlexCelPreview.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited KeyDown(Key, Shift);
  case Key of
    VK_UP:
       VertScrollBar.Position := VertScrollBar.Position - Round(ScrollWheelOffset * $A * RowMult);
    VK_DOWN:
       VertScrollBar.Position := VertScrollBar.Position + Round(ScrollWheelOffset * $A * RowMult);
    VK_LEFT:
      HorzScrollBar.Position := HorzScrollBar.Position - Round(ScrollWheelOffset * $A * ColMult);
    VK_RIGHT:
      HorzScrollBar.Position := HorzScrollBar.Position + Round(ScrollWheelOffset * $A * ColMult);
    VK_PRIOR:
       VertScrollBar.Position := VertScrollBar.Position - 2 * Round(ScrollWheelOffset * $A * RowMult);
    VK_NEXT:
       VertScrollBar.Position := VertScrollBar.Position + 2 * Round(ScrollWheelOffset * $A * RowMult);
    VK_HOME:
    begin
      HorzScrollBar.Position := 0;
      VertScrollBar.Position := 0;
    end;
    VK_END:
    begin
      HorzScrollBar.Position := HorzScrollBar.Range;
      VertScrollBar.Position := VertScrollBar.Range;
    end;
  end
end;

procedure TFlexCelPreview.WMGetDlgCode(var Message: TMessage);
begin
  Message.Result := DLGC_WANTARROWS;
end;

procedure TFlexCelPreview.Click;
begin
  inherited;
  if (CanFocus) then SetFocus;
end;

procedure TFlexCelPreview.Resize;
begin
  inherited;
  if (FCenteredPreview) then Invalidate;
end;

{ TBmpCache }

constructor TBmpCache.Create(const aBmp: TBitmap; const aPageNo: integer);
begin
  inherited Create;
  Bmp:=aBmp;
  PageNo:=aPageNo;
end;

destructor TBmpCache.Destroy;
begin
  FreeAndNil(Bmp);
  inherited;
end;

end.
