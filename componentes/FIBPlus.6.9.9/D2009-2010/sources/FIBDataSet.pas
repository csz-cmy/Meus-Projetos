{***************************************************************}
{ FIBPlus - component library for direct access to Firebird and }
{ InterBase databases                                           }
{                                                               }
{    FIBPlus is based in part on the product                    }
{    Free IB Components, written by Gregory H. Deatz for        }
{    Hoagland, Longo, Moran, Dunst & Doukas Company.            }
{    mailto:gdeatz@hlmdd.com                                    }
{                                                               }
{    Copyright (c) 1998-2007 Devrace Ltd.                       }
{    Written by Serge Buzadzhy (buzz@devrace.com)               }
{                                                               }
{ ------------------------------------------------------------- }
{    FIBPlus home page: http://www.fibplus.com/                 }
{    FIBPlus support  : http://www.devrace.com/support/         }
{ ------------------------------------------------------------- }
{                                                               }
{  Please see the file License.txt for full license information }
{***************************************************************}


unit FIBDataSet;


interface

{$I FIBPlus.inc}
uses
 SysUtils, ibase,IB_Intf, ib_externals, fib,
 pFIBProps,pFIBFieldsDescr,DB,FIBCacheManage,
 DBCommon,DbConsts,DBParsers,//DSContainer,
 FIBDatabase, FIBQuery, FIBMiscellaneous,SqlTxtRtns,pFIBLists,FIBCloneComponents ,
 pFIBInterfaces,pFIBEventLists,
 {$IFDEF WINDOWS}
  Windows, Classes,StdFuncs
  {$IFNDEF NO_GUI}
   ,Forms,Controls // IS GUI units
  {$ENDIF}
  {$IFDEF D6+},FMTBcd, Variants{$ENDIF}
 {$ENDIF}
 {$IFDEF LINUX}
  Types,Libc,Classes,StdFuncs,
  {$IFNDEF NO_GUI}
   QForms,QControls, // IS GUI units
  {$ENDIF}
  FMTBcd, Variants
 {$ENDIF}

 ;

const
  vBufferCacheSize    =  32;  // Allocate cache in this many record chunks
  vMinBufferChunksForLimCache=100;
type
{$IFDEF D11+}
  dbPChar=PByte;
{$ELSE}
  dbPChar=PChar ;
{$ENDIF}

  TFIBCustomDataSet = class;
  TFIBDataSet = class;

  TBlobDataArray =array[0..0] of TFIBBlobStream;
  PBlobDataArray = ^TBlobDataArray;


  TFieldData =record
    fdIsNull: Boolean;
  end;
  PFieldData = ^TFieldData;
 
 
  TCachedUpdateStatus =
   (cusUnmodified, cusModified, cusInserted,cusDeleted, cusUninserted,cusDeletedApplied);
 


  TRecordData =packed record
    rdRecordNumber: Long;
    rdBookmarkFlag: TBookmarkFlag;
    rdFlags       : Byte; // 3 bit - TCachedUpdateStatus
//    rdCachedUpdateStatus: TCachedUpdateStatus;// Bit 7 is Calcs
    rdFields: array[1..1] of TFieldData;
  end;
  PRecordData = ^TRecordData;
 
  TSavedRecordData =packed record
    rdFlags       : Byte;
    rdFields: array[1..1] of TFieldData;
  end;
  PSavedRecordData = ^TSavedRecordData;
 
  TFIBStringField = class(TStringField)
  private
   FPrepared:Boolean;
   vInSetAsString    :boolean;
   FEmptyStrToNull   :boolean;
   FDefaultValueEmptyString:boolean;
   FValueLength      :integer;
   FSqlSubType       :integer;
   FCollateNumber    :Byte;
   FCharacterSetName :string;
   FNeedUnicodeConvert:boolean;
   FReservedBuffer   :PAnsiChar;
   FDataSet          :TDataSet;
   function     GetAsDB_KEY:string;
   procedure Prepare;
   procedure UnPrepare(Sender:TObject);

  protected
    class procedure CheckTypeSize(Value: Integer); override;
    procedure SetDataSet(ADataSet: TDataSet); override;
    function  GetValue(var Value: string): Boolean;
    function  GetAsString: string; override;
    function  GetAsAnsiString: AnsiString; override;
    function  GetAsVariant: Variant; override;
    procedure SetAsString(const Value: string); override;
    procedure SetSize(Value: Integer);  override;
    function GetDataSize: Integer; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy;override;
    function  IsDBKey:boolean;
    function  SqlSubType:integer;
    function  CharacterSet :string;
    procedure Clear; override;
    property  DefaultValueEmptyString:boolean read FDefaultValueEmptyString write FDefaultValueEmptyString;
  published
   property EmptyStrToNull:boolean read FEmptyStrToNull write FEmptyStrToNull ;
  end;

 
  TFIBWideStringField = class(TWideStringField)
  protected
    FPrepared:Boolean;
    FSqlSubType       :Integer;
    FDataSize         :Integer;
    FCollateNumber    :Byte;
    FCharacterSetName :string;
    FDataSet:TDataSet;
    function GetDataSize: Integer; override;
    procedure Prepare;
    procedure UnPrepare(Sender:TObject);
    procedure SetDataSet(ADataSet: TDataSet); override;

  protected
    procedure SetAsString(const Value: string); override;
//    function  GetAsVariant: Variant; override;
    procedure SetAsWideString(const Value: UnicodeString); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Clear; override;
    function  CharacterSet :string;
    function  SqlSubType:Integer;
    function  CollateNumber :Byte;
  end;

  TFIBLargeIntField   = class(TLargeIntField)
  private
   function GetOldAsInt64:Int64;
  protected
   procedure SetVarValue(const Value: Variant); override;
  public
   property OldValue:Int64 read GetOldAsInt64;
  end;

  TFIBIntegerField = class(TIntegerField)
   protected
     function  GetAsBoolean: Boolean; override;
     procedure SetAsBoolean(Value: Boolean); override;
   public
     procedure   Clear; override; 
     constructor Create(AOwner: TComponent); override;
   end;


   TFIBDateField = class(TDateField)
   public

   end;

   TFIBTimeField = class(TTimeField)
   private
     FShowMsec:boolean;
   protected
      procedure GetText(var Text: string; DisplayText: Boolean); override;
   public
   published
    property ShowMsec:boolean read FShowMsec write FShowMsec default False;

   end;
 
   TFIBDateTimeField = class(TDateTimeField)
   private
     FShowMsec:boolean;
     function GetAsTimeStamp:TTimeStamp;
     procedure SetAsTimeStamp(const Value:TTimeStamp);
   protected
     procedure GetText(var Text: string; DisplayText: Boolean); override;
   public
     property AsTimeStamp:TTimeStamp read GetAsTimeStamp write SetAsTimeStamp;
   published
    property ShowMsec:boolean read FShowMsec write FShowMsec default False;
   end;
 

   TFIBBlobField = class(TBlobField)
   private
    FSubType:SmallInt;
    FIsClientCalcField:boolean;
   protected
    function GetAsVariant: Variant; override;
    function GetBlobId:TISC_QUAD;
    function GetIsNull:boolean; override;
   public
    property  SubType:SmallInt read FSubType;
    property  Blob_ID:TISC_QUAD read GetBlobId;
   published
    property  IsClientField:boolean read FIsClientCalcField write FIsClientCalcField default False;
   end;

//TNT Controls Interface

  IWideStringField = interface
    ['{679C5F1A-4356-4696-A8F3-9C7C6970A9F6}']
    function GetAsWideString: UnicodeString;
    procedure SetAsWideString(const Value: UnicodeString);
    function GetWideDisplayText: WideString;
    function GetWideEditText: WideString;
    procedure SetWideEditText(const Value: WideString);
    //--
    property AsWideString: UnicodeString read GetAsWideString write SetAsWideString{inherited};
    property WideDisplayText: WideString read GetWideDisplayText;
    property WideText: WideString read GetWideEditText write SetWideEditText;
  end;
 
   TFIBMemoField = class(TMemoField,IWideStringField)
   private
    FSubType:SmallInt;
    FCharSetID:integer;
    function GetWideDisplayText: WideString;
    function GetWideEditText: WideString;
    procedure SetWideEditText(const Value: WideString);
   protected
    procedure SetAsVariant(const Value: Variant); override;
    function GetBlobId:TISC_QUAD;
    function GetAsAnsiString: AnsiString; override;
   public
    function GetAsWideString: UnicodeString; {$IFDEF D10+} override; {$ENDIF}
    procedure SetAsWideString(const aValue: UnicodeString); {$IFDEF D10+} override; {$ENDIF}
    function GetAsVariant: Variant; override;
    function GetAsString: string;  override;
    procedure SetAsString(const Value: string); override;
    property  SubType:SmallInt read FSubType;
    procedure InternalSetCharSet(aValue:integer); // Internal use
    property  Blob_ID:TISC_QUAD read GetBlobId;
   end;
 

 
  TFIBSmallIntField =class(TSmallintField)
  protected
     function  GetAsBoolean: Boolean; override;
     procedure SetAsBoolean(Value: Boolean); override;
  end;

  TFIBFloatField =class(TFloatField)
   private
    FRoundByScale:boolean;
    function GetScale:integer;
   protected
     procedure SetAsFloat(Value: Double); override;
     procedure GetText(var Text: string; DisplayText: Boolean); override;
   public
     constructor Create(AOwner: TComponent); override;
     property    Scale:integer read GetScale;
   published
     property RoundByScale:boolean read FRoundByScale write FRoundByScale default True;
   end;

  TFIBBCDField = class(TBCDField)
  private
    FRoundByScale:boolean;
    FDataAsComp  :boolean;
    function GetScale:integer;
    function  ServerType:integer;
  protected
    class procedure CheckTypeSize(Value: Integer); override;
    function  GetAsCurrency: Currency; override;
    function  GetAsString: string; override;
    function  GetAsVariant: Variant; override;
    function  GetDataSize: Integer; override;
    procedure GetText(var Text: string; DisplayText: Boolean); override;
    function  GetValue(var Value: Currency): Boolean;
    procedure SetAsString(const Value: string); override;
    procedure SetAsCurrency(Value: Currency); override;
 {$IFNDEF NO_USE_COMP}
    function  GetAsComp: comp;
    procedure SetAsComp(Value: comp);
 {$ENDIF}    
    function  GetAsExtended: Extended;  override;
    procedure SetAsExtended(Value: Extended); override;
    function  GetAsInt64: Int64;
    procedure SetAsInt64(const Value: Int64);
    function  GetAsBCD: TBcd;{$IFDEF D6+} override;{$ENDIF}
    procedure SetAsBCD(const Value: TBcd);{$IFDEF D6+} override;{$ENDIF}
    procedure SetVarValue(const Value: Variant); override;
    function  GetInternalData(var ValueIsNull:boolean):Int64;
    function  GetInternalOldData(var OldIsNull:boolean):Int64;
    function  GetData(Buffer: Pointer): Boolean;
  public
    constructor Create(AOwner: TComponent); override;
{$IFDEF D6+}
    procedure AddExtended(const Value:Extended);
    procedure SubtractExtended(const Value:Extended);
    procedure MultiplyExtended(const Value:Extended);
    procedure DivideExtended(const Value:Extended);

    procedure AddBCD(const Value:TBCD);
    procedure SubtractBCD(const Value:TBCD);
    procedure MultiplyBCD(const Value:TBCD);
    procedure DivideBCD(const Value:TBCD);
{$ENDIF}
    property  AsInt64:Int64 read GetAsInt64 write SetAsInt64;
    procedure Assign(Source: TPersistent); override;
    function  FieldModified:boolean;
    property  AsBcd: TBcd read GetAsBcd write SetAsBcd;
    property Scale:integer read GetScale;
 {$IFNDEF NO_USE_COMP}
    property AsComp: Comp read GetAsComp write SetAsComp;
 {$ENDIF}    
    property AsExtended: Extended read GetAsExtended write SetAsExtended;
    property Value     : Variant read GetAsVariant write  SetVarValue;
  published
    property Size default 8;
    property RoundByScale:boolean read FRoundByScale write FRoundByScale;

  end;

   TFIBGuidField= class (TGuidField)
   private
    FBuffer:Ansistring;
    pBuffer:Pointer;
   protected
    class procedure CheckTypeSize(Value: Integer); override;
    procedure SetAsString(const Value: string); override;
    function GetAsGuid: TGUID;
    procedure SetAsGuid(const Value: TGUID);
    function  GetAsVariant: variant; override;
    procedure SetAsVariant(const Value: Variant); override;
 
   public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    property AsGuid: TGUID read GetAsGuid write SetAsGuid;
   end;
 
   TFIBBooleanField= class (TBooleanField)
   private
    FStringFalse:string;
    FStringTrue :string;
   protected
    function  StoreStrFalse:boolean;
    function  StoreStrTrue :boolean;
 
    function  GetAsInteger: Longint; override;
    procedure SetAsString(const Value: string);override;
    procedure SetVarValue(const Value: Variant); override;
    procedure SetAsInteger(Value: Longint);override;
    procedure SetAsBoolean(Value: Boolean); override;
    function GetDataSize:  Integer;  override;
    function GetAsString:  string; override;
    function GetAsBoolean: Boolean; override;
    function GetAsVariant: Variant; override;
 
   public
    constructor Create(AOwner: TComponent); override;
   published
    property StringFalse:string read FStringFalse write FStringFalse
      stored StoreStrFalse
    ;
    property StringTrue :string read FStringTrue write FStringTrue
      stored StoreStrTrue
    ;
 
   end;

  {$IFDEF SUPPORT_ARRAY_FIELD}
   TFIBArrayField=class(TBytesField)
   private
    FOldValueBuffer:PAnsiChar;
    function GetFIBXSQLVAR:TFIBXSQLVAR;
   protected
    procedure GetText(var Text: string; DisplayText: Boolean); override;
    function  GetDimCount:integer;
    function  GetElementType:TFieldType;
    function  GetDimension(Index:integer):TISC_ARRAY_BOUND;
    function  GetArraySize:integer;
    procedure SaveOldBuffer   ;
    procedure RestoreOldBuffer;
    function  GetArrayId:TISC_QUAD;
    function GetAsVariant: Variant; override;
    procedure SetAsVariant(const Value: Variant); override;
 
   public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property DimensionCount:integer read GetDimCount;
    property ElementType:TFieldType read GetElementType;
    property Dimension[Index: Integer]: TISC_ARRAY_BOUND read GetDimension;
    property ArraySize:Integer read GetArraySize;
    property ArrayID:TISC_QUAD read GetArrayId;
   end;
  {$ENDIF}

 
  TUpdateKinds = set of TUpdateKind;
  TFIBUpdateAction = (uaFail, uaAbort, uaSkip, uaRetry, uaApply, uaApplied);
 
  TFIBUpdateErrorEvent = procedure(DataSet: TDataSet; E: EFIBError;
    UpdateKind: TUpdateKind; var UpdateAction: TFIBUpdateAction) of object;
  TFIBUpdateRecordEvent = procedure(DataSet: TDataSet; UpdateKind: TUpdateKind;
    var UpdateAction: TFIBUpdateAction) of object;
 
  TFIBAfterUpdateRecordEvent = procedure(DataSet: TDataSet; UpdateKind: TUpdateKind;
    var Resume:boolean) of object;

  TFIBUpdateRecordTypes = set of TCachedUpdateStatus;
  TOnFetchRecord  =procedure (FromQuery: TFIBQuery;RecordNumber:integer;
   var StopFetching:boolean
  ) of object;
 
  TpSQLKind = (skModify, skInsert, skDelete, skRefresh);
  TDispositionFieldType= (dfNormal,dfRRecNumber);
  TExtLocateOption =(eloCaseInsensitive, eloPartialKey,eloWildCards,
   eloInSortedDS,eloNearest,eloInFetchedRecords
  );
 
  TExtLocateOptions=set of TExtLocateOption;
  TLocateKind =(lkStandard,lkNext,lkPrior);
 
  TSortFieldInfo=record
                   FieldName:string;
                   InDataSetIndex:integer;
                   InOrderIndex:integer;
                   Asc  :boolean;
                   NullsFirst:boolean;
                  end;
 

  TFIBDataLink = class(TDetailDataLink)
  protected
    FDataSet: TFIBCustomDataSet;
  protected
    procedure ActiveChanged; override;
    procedure RecordChanged(Field: TField); override;
    procedure CheckBrowseMode; override;
    procedure DataSetChanged; override;
    function GetDetailDataSet: TDataSet; override;
  public
    constructor Create(ADataSet: TFIBCustomDataSet);
    destructor Destroy; override;
  end;

  TFIBBookmark = packed record
   bRecordNumber:integer;
   bActiveRecord:integer;
  end;

  PFIBBookMark=^TFIBBookmark;
  (*
   * TFIBCustomDataSet - declaration
   *)
  TTransactionKind=(tkReadTransaction,tkUpdateTransaction);
  TCompareFieldValues= function  (Field:TField;const S1,S2:variant):integer of object;
 
  TRecordsPartition = record
   BeginPartRecordNo: Integer;
   EndPartRecordNo  : Integer;
   IncludeBof       : boolean;
   IncludeEof       : boolean;
  end;
  PRecordsPartition=^TRecordsPartition;
 
  TCacheModelKind=(cmkStandard,cmkLimitedBufferSize);
 
  TCacheModelOptions = class(TPersistent)
  private
    vOwner:TFIBCustomDataSet;
    FCacheModelKind:TCacheModelKind;
    FBufferChunks  :Integer;
    FPlanForDescSQLs:string;
    FBlobCacheLimit :integer;
    procedure SetBufferChunks(Value: Integer);
    procedure SetCacheModelKind(Value:TCacheModelKind);
  public
    constructor Create(Owner:TFIBCustomDataSet);
  published
   property CacheModelKind:TCacheModelKind read FCacheModelKind write SetCacheModelKind default cmkStandard;
   property BufferChunks: Integer read FBufferChunks write SetBufferChunks default vBufferCacheSize;
   property PlanForDescSQLs:string read FPlanForDescSQLs write FPlanForDescSQLs;
   property BlobCacheLimit :integer read FBlobCacheLimit write FBlobCacheLimit default 0;
  end;
 

  TUpdateBlobInfo=(ubiCheckIsNull,ubiPost,ubiCancel,ubiClearOldValue);
  TOnFillClientBlob=procedure(DataSet:TFIBCustomDataSet;Field:TFIBBlobField;Stream:TFIBBlobStream) of object;
  TOnBlobFieldProcessing=procedure(Field:TBlobField;BlobSize:integer;Progress:integer;var Stop:boolean) of object;

  TDataSetRunStateValue=(drsInCacheRefresh,drsInSort,drsInOpenByTimer,
   drsInFilterProc,drsInGetRecordProc,drsInGotoBookMark, drsInClone,
   drsInApplyUpdates,drsInRefreshClientFields,drsDontCheckInactive,
   drsForceCreateCalcFields,drsInRefreshRow,drsInMoveRecord,drsInCacheDelete,
   drsInFetchingAll,drsInLoaded
  );
  TDataSetRunState=set of TDataSetRunStateValue; //InternalUse
 

  TFilteredCacheInfo =
  record
    AllRecords: integer;
    FilteredRecords: integer;
    NonVisibleRecords: TSortedList;
  end;

  TFIBCustomDataSet = class({$IFDEF D10+}TWideDataset{$ELSE}TDataset{$ENDIF},ISQLObject)
  protected
    (*
     * Fields, and internal objects
     *)
    FBase: TFIBBase;          (* Manages database and transaction *)
    FBlobCacheBufferOffset: Integer;
    FBlobCacheOffset: Integer;
    FBlobStreamList: TList;
    FOpenedBlobStreams: TList;    
    FRecordsCache:TRecordsCache;
    FBufferChunkSize,
    FBPos,
    FOBPos,
    FBEnd,
    FOBEnd: DWord;
    FCachedUpdates: Boolean;
    FCalcFieldsOffset: Integer;
    FCurrentRecord: Long;
    FDeletedRecords: Long; (* How many records have been deleted? *)
    FSourceLink: TFIBDataLink;
    FOpen: Boolean;           (* Is the dataset open? *)
    FPrepared: Boolean;
    FQDelete,
    FQInsert,
    FQRefresh,
    FQSelect,
    FQUpdate: TFIBQuery;      (* Dataset management queries *)
    FRecordBufferSize: Integer;
    FBlockReadSize   : Integer;

    FRecordCount: Integer;
    FAllRecordCount:integer;
    FRecordSize: Integer;
    vDisableScrollCount:integer;
 
    FDatabaseDisconnecting,
    FDatabaseDisconnected,
    FDatabaseFree  : TNotifyEvent;
    FOnUpdateError : TFIBUpdateErrorEvent;
    FOnUpdateRecord: TFIBUpdateRecordEvent;
    FAfterUpdateRecord: TFIBAfterUpdateRecordEvent;
    FTransactionEnding: TNotifyEvent;
    FTransactionEnded : TNotifyEvent;
    FTransactionFree  : TNotifyEvent;

    FBeforeStartTr:TNotifyEvent ;
    FAfterStartTr :TNotifyEvent ;
    FBeforeEndTr  :TEndTrEvent  ;
    FAfterEndTr   :TEndTrEvent  ;

    FBeforeStartUpdTr:TNotifyEvent ;
    FAfterStartUpdTr :TNotifyEvent ;
    FBeforeEndUpdTr  :TEndTrEvent  ;
    FAfterEndUpdTr   :TEndTrEvent  ;

    FUpdatesPending: Boolean;
    FUpdateRecordTypes: TFIBUpdateRecordTypes;
    FUniDirectional: Boolean;
    FOnGetRecordError:  TDataSetErrorEvent;
    FOptions:TpFIBDsOptions;
    FDetailConditions:TDetailConditions;
    vInspectRecno:integer;
    vTypeDispositionField:TDispositionFieldType;
    vTimerForDetail:TFIBTimer;
    vScrollTimer   :TFIBTimer;
    FDisableCOCount:integer;
    FDisableCalcFieldsCount:integer;
    FPrepareOptions:TpPrepareOptions;
    vSelectSQLTextChanged:boolean;
    FRefreshTransactionKind:TTransactionKind;
    FAutoCommit:boolean;
    FWaitEndMasterInterval:integer;
    FOnFieldChange:TFieldNotifyEvent;
    FOnFillClientBlob:TOnFillClientBlob;
    FOnBlobFieldRead :TOnBlobFieldProcessing;
    FOnBlobFieldWrite:TOnBlobFieldProcessing;
    FWritingBlob:TField;
    vPredState     : TDataSetState;
    vrdFieldCount  :integer;
    FStringFieldCount  :integer;
    FFilterParser      : TExpressionParser;
    FAllowedUpdateKinds: TUpdateKinds;
    FRunState:TDataSetRunState;
    vCalcFieldsSavedCache:boolean;
    FFieldOriginRule:TFieldOriginRule;
    FFilteredCacheInfo: TFilteredCacheInfo;    
  protected
    FAutoUpdateOptions: TAutoUpdateOptions;
{$IFDEF CSMonitor}
    FCSMonitorSupport: TCSMonitorSupport;
    procedure SetCSMonitorSupport(Value:TCSMonitorSupport);    
{$ENDIF}
 
    function  IsDBKeyField(Field:TObject):boolean;
 
 
// GB
    procedure CheckDataFields(FieldList:TList; const CallerProc:string);
    procedure PrepareAdditionalSelects;
    function  CompareBookMarkAndRecno(BookMark:TBookMark; Rno:integer;OnlyFields:boolean=False ):boolean;
    function RefreshAround(BaseQuery: TFIBQuery; var BaseRecNum:integer;
     IgnoreEmptyBaseQuery:boolean = True;ReopenBaseQuery:boolean = True
    ):boolean;
//End GB
  private
// GB
    FCacheModelOptions:TCacheModelOptions;

    vPartition      :PRecordsPartition;
    FQCurrentSelect :TFIBQuery;
    FQSelectPart    :TFIBQuery;
    FQSelectDescPart:TFIBQuery;
    FQSelectDesc    :TFIBQuery;
    FQBookMark      :TFIBQuery;
    FKeyFieldsForBookMark :TStrings;
    FSortFields:variant;
    function  CanHaveLimitedCache:boolean;

    procedure SetCacheModelOptions(aCacheModelOptions:TCacheModelOptions);
    function  GetBufferChunks:Integer;
    procedure SetBufferChunks(Value:integer);
    procedure ShiftCurRec;    
//End GB

 
    function  StoreUpdTransaction: Boolean;
    procedure SetOnEndScroll(Event:TDataSetNotifyEvent);
    function  GetDefaultFields:boolean;
    procedure ClearBlobStreamList;

    function  CreateInternalQuery(const QName:string):TFIBQuery;
    function GetGroupByString: string;
    function GetMainWhereClause: string;
    procedure SetGroupByString(const Value: string);
    procedure SetMainWhereClause(const Value: string);
    function GetPlanClause: string;
    procedure SetPlanClause(const Value: string);
  protected
   FOnCompareFieldValues:TCompareFieldValues;
   function  CompareFieldValues(Field:TField;const S1,S2:variant):integer; virtual;
  public
   function AnsiCompareString(Field:TField;const val1, val2: variant): Integer;
   function StdAnsiCompareString(Field:TField;const S1, S2: variant): Integer;
   function StdCompareValues(const S1, S2: variant): Integer;
  published
   property  OnCompareFieldValues:TCompareFieldValues read    FOnCompareFieldValues
     write   FOnCompareFieldValues;
  protected
   {$DEFINE FIB_INTERFACE}
    {$I FIBDataSetPT.inc}
   {$UNDEF FIB_INTERFACE}
 
  protected
    function  GetXSQLVAR(Fld:TField):TXSQLVAR;
    function  GetFieldScale(Fld:TNumericField):Short;
    function  GetUpdateTransaction:TFIBTransaction;
    (*
     * Routines for managing access to the database, etc... They have
     * nothing to do with TDataset.
     *)
    function AdjustCurrentRecord(Buffer: Pointer; GetMode: TGetMode): TGetResult;
    function CanEdit: Boolean; virtual;
    function CanInsert: Boolean; virtual;
    function CanDelete: Boolean; virtual;
    procedure CheckFieldCompatibility(Field: TField; FieldDef: TFieldDef); override;
    procedure CheckInactive; override;
    procedure CheckEditState;
    procedure UpdateBlobInfo(Buff: Pointer;Operation:TUpdateBlobInfo;ClearModified,ForceWrite:boolean
     ; Field:TField=nil
    );
    procedure CallBackBlobWrite(BlobSize:integer; BytesProcessing:integer; var Stop:boolean);
    (*
     * When copying a given record buffer, should we overwrite
     * the pointers to "memory" or should we just copy the
     * contents?
     *)
    procedure CopyRecordBuffer(Source, Dest: Pointer);
    procedure DoDatabaseDisconnecting(Sender: TObject);
    procedure DoDatabaseDisconnected(Sender: TObject);
    procedure DoDatabaseFree(Sender: TObject);
    procedure DoTransactionEnding(Sender: TObject); virtual;
    procedure DoTransactionEnded(Sender: TObject);  virtual;
    procedure DoTransactionFree(Sender: TObject);
 
    procedure DoBeforeStartTransaction(Sender: TObject);
    procedure DoAfterStartTransaction(Sender: TObject);
    procedure DoBeforeEndTransaction(EndingTR:TFIBTransaction;Action: TTransactionAction;
      Force: Boolean);
    procedure DoAfterEndTransaction(EndingTR:TFIBTransaction;Action: TTransactionAction;
      Force: Boolean);

    procedure DoBeforeStartUpdateTransaction(Sender: TObject);
    procedure DoAfterStartUpdateTransaction(Sender: TObject);
    procedure DoBeforeEndUpdateTransaction(EndingTR:TFIBTransaction;Action: TTransactionAction;
      Force: Boolean);
    procedure DoAfterEndUpdateTransaction(EndingTR:TFIBTransaction;Action: TTransactionAction;
      Force: Boolean); virtual;
 
    procedure FetchCurrentRecordToBuffer(
     Qry: TFIBQuery; RecordNumber: Integer;Buffer: dbPChar
    );
    procedure FetchRecordToCache(Qry: TFIBQuery; RecordNumber: Integer);
    procedure InitDataSetSchema;
    function GetActiveBuf: dbPChar;
    function GetDatabase: TFIBDatabase;
    function GetDBHandle: PISC_DB_HANDLE;
    function GetDeleteSQL: TStrings;
    function GetInsertSQL: TStrings;
    function GetParams: TFIBXSQLDA;
    function GetRefreshSQL: TStrings;
    function GetSelectSQL: TStrings;
    function GetStatementType: TFIBSQLTypes;
    function GetUpdateSQL: TStrings;
    function GetTransaction: TFIBTransaction;
    function GetTRHandle: PISC_TR_HANDLE;
 
 
    procedure InternalDeleteRecord(Qry: TFIBQuery; Buff: Pointer);virtual;
 
   {$DEFINE FIB_INTERFACE}
    {$I FIBDataSetLocate.inc}
   {$UNDEF FIB_INTERFACE}

    function  InternalLocate(const KeyFields: string; KeyValues:array of Variant;
      Options: TExtLocateOptions ;FromBegin:boolean = False;LocateKind:TLocateKind = lkStandard;
      ResyncToCenter:boolean=False
    ): Boolean; virtual;
 

    function  InternalLocateForLimCache(
     const KeyFields: string; const KeyValues:array of Variant;
      Options: TExtLocateOptions; LocateKind:TLocateKind = lkStandard;aQLocate:TFIBQuery=nil
    ): Boolean;
 
    function  InternalExtLocate(const KeyFields: string; const KeyValues:Variant;
     Options: TExtLocateOptions;LocateKind:TLocateKind):Boolean;
 
    procedure InternalPostRecord(Qry: TFIBQuery; Buff: Pointer); virtual;
    function  InternalRefreshRow(Qry: TFIBQuery; Buff:Pointer) :boolean;
    procedure InternalRevertRecord(RecordNumber: Integer;WithUnInserted:boolean);
    function  IsVisibleStat(Buffer: PRecordData): Boolean;
    function  IsVisible(Buffer: PRecordData): Boolean; virtual;
    procedure SaveOldBuffer(Buffer: dbPChar);
    procedure SetDatabase(Value: TFIBDatabase);
    procedure LiveChangeDatabase(Value: TFIBDatabase); // internal use
    procedure SetDeleteSQL(Value: TStrings);
    procedure SetInsertSQL(Value: TStrings);
    procedure SetQueryParams(Qry: TFIBQuery; Buffer: Pointer);
    procedure SetRefreshSQL(Value: TStrings);
    procedure SetSelectSQL(Value: TStrings);
    procedure SetUpdateSQL(Value: TStrings);
    procedure SetTransaction(Value: TFIBTransaction);
    procedure LiveChangeTransaction(Value: TFIBTransaction); // internal use    
    procedure SetUpdateTransaction(Value:TFIBTransaction) ; virtual;
 
    procedure SetUpdateRecordTypes(Value: TFIBUpdateRecordTypes);
    procedure SetUniDirectional(Value: Boolean);
    procedure SetPrepareOptions(Value:TpPrepareOptions); virtual;
    procedure SetRefreshTransactionKind(const Value: TTransactionKind);    
    procedure SourceChanged;
    procedure SourceDisabled;
  protected
    FParams: TParams;
    procedure SQLChanging(Sender: TObject);
    procedure ReadRecordCache(RecordNumber: Integer; Buffer: dbPChar;
      ReadOldBuffer: Boolean);
    procedure  WriteRecordCache(RecordNumber: Integer; Buffer: dbPChar);
    function   GetNewBuffer:dbPChar;
    function   GetOldBuffer(aRecordNo:integer =-1):dbPChar;
    procedure  CheckUpdateTransaction;
  protected
    vFieldDescrList:TFIBFieldDescrList;
    FFNFields: TStringList;    
    (*
     * Routines from TDataset that need to be overridden to use the IB API
     * directly.
     *)
 

    vIgnoreLocReno:integer;
    vControlsEnabled:boolean;
    FOnEnableControls:TDataSetNotifyEvent;
    FOnDisableControls:TDataSetNotifyEvent;
    FOnEndScroll:TDataSetNotifyEvent;
    FCachedActive       :boolean;
    vNeedReloadClientBlobs:boolean;

    vBeforeCloseEvents : TNotifyEventList;
    procedure SetActive(Value: Boolean); override;
    procedure DataEvent(Event: TDataEvent; Info: Longint); override;
    procedure SetStateFieldValue(State: TDataSetState; Field: TField; const Value: Variant); override;
    procedure DoOnDisableControls(DataSet:TDataSet);
    procedure DoOnEnableControls(DataSet:TDataSet);
    function  AllocRecordBuffer: dbPChar; override; (* abstract *)
    procedure InternalDoBeforeOpen;   virtual;
    procedure DoBeforeOpen;   override;
    procedure DoAfterOpen;    override;
    procedure DoBeforeClose;  override;
    procedure DoAfterClose;   override;
    procedure DoBeforeCancel; override;
    procedure DoAfterCancel;  override;
    procedure DoBeforeDelete; override;
    procedure DoBeforeEdit;   override;
    procedure DoBeforeInsert; override;
    procedure DoBeforeScroll; override;
    procedure DoAfterScroll;  override;
    procedure DoBeforePost;   override;
    procedure DoAfterInsert;  override;
    procedure DoAfterPost;    override;
    procedure DoAfterDelete;  override;
    procedure DoOnEndScroll(Sender:TObject);
    procedure DoOnPostError(DataSet: TDataSet; E: EDatabaseError; var Action: TDataAction); virtual;
    procedure FreeRecordBuffer(var Buffer: dbPChar); override; (* abstract *)
    procedure GetBookmarkData(Buffer: dbPChar; Data: Pointer); override; (* abstract *)
    function GetBookmarkFlag(Buffer: dbPChar): TBookmarkFlag; override; (* abstract *)
    function GetCanModify: Boolean; override;
    function GetDataSource: TDataSource; override;
    function GetFieldClass(FieldType: TFieldType): TFieldClass; override;
    function GetRecNo: Integer; override;
    function GetRealRecNo: Integer;
    procedure TryDesignPrepare;
   protected
    procedure PrepareQuery(KindQuery: TpSQLKind);
    procedure PrepareBookMarkSize;
    procedure ClearCalcFields(Buffer: dbPChar); override;
    procedure GetCalcFields(Buffer: dbPChar); override;
    function GetRecord(Buffer: dbPChar; GetMode: TGetMode;
      DoCheck: Boolean): TGetResult; override; (* abstract *)
    function GetRecordCount: Integer; override;
    function GetRecordSize: Word; override; (* abstract *)

    procedure InternalAddRecord(Buffer: Pointer; Append: Boolean); override; (* abstract *)
    procedure InternalCancel; override;
    procedure InternalClose; override; (* abstract *)
    procedure CloseCursor; override;
    procedure InternalDelete; override; (* abstract *)
    procedure InternalFirst; override; (* abstract *)
    procedure InternalGotoBookmark(Bookmark: Pointer); override; (* abstract *)
    procedure InternalHandleException; override; (* abstract *)
    procedure InternalInitFieldDefs; override; (* abstract *)
    procedure InternalInitRecord(Buffer: dbPChar); override; (* abstract *)
    procedure InternalLast; override; (* abstract *)
    procedure InternalOpen; override; (* abstract *)
    procedure InternalPost; override; (* abstract *)
    procedure DoInternalRefresh(Qry: TFIBQuery; Buff:Pointer;ForceFullRefresh:boolean); virtual;
    procedure InternalRefresh; override;
    procedure InternalSetToRecord(Buffer: dbPChar); override; (* abstract *)
    function  IsCursorOpen: Boolean; override; (* abstract *)

    procedure SetBookmarkFlag(Buffer: dbPChar; Value: TBookmarkFlag); override;
    procedure SetBookmarkData(Buffer: dbPChar; Data: Pointer); override; (* abstract *)
    procedure SetCachedUpdates(Value: Boolean);
    procedure SetDataSource(Value: TDataSource);
    procedure SetOptions(Value:TpFIBDsOptions);
    procedure SetFieldData(Field: TField; Buffer: Pointer); override; (* abstract *)
 
    procedure SetRealRecNo(Value: Integer;ToCenter:boolean =False);
    procedure SetRecNo(Value: Integer); override;
    function  MasterFieldsChanged :boolean; virtual;
    procedure SetParamsFromMaster ;
    procedure ForceEndWaitMaster;

// Filter works
    procedure SetFiltered(Value: Boolean); override;
    procedure ExprParserCreate(const Text: string; Options: TFilterOptions);
    procedure SetFilterData(const Text: string; Options: TFilterOptions);
    procedure SetFilterOptions(Value: TFilterOptions); override;
    procedure SetFilterText(const Value: string); override;
//

  protected
   FIsClientSorting:boolean;
 
   FBeforeFetchRecord: TOnFetchRecord;
   FAfterFetchRecord : TOnFetchRecord;
   FRelationTables : TStringList;
   FCountUpdatesPending:integer;
  {$IFNDEF NO_GUI}
   FSQLScreenCursor    :TCursor;
  {$ENDIF}
   FSQLs               :TSQLs;
   procedure SetBeforeFetchRecord(Value:TOnFetchRecord);
   function  IsValidBuffer(FCache: PAnsiChar):boolean;
   procedure PackMemory(var FCache: PAnsiChar);
   function  GetAllFetched:boolean;
   procedure OpenByTimer(Sender:TObject);
   procedure DoCloseOpen(Sender:TObject);
   function  GetWaitEndMasterScroll:boolean;
   procedure SetWaitEndMasterScroll(Value:boolean);
   function  GetDetailConditions:TDetailConditions;
   procedure SetDetailConditions(Value:TDetailConditions);
 
   function  IsSorted :boolean;
   procedure DoOnSelectFetch(RecordNumber:integer;   var StopFetching:boolean);
   procedure PrepareAdditionalInfo;
   procedure RefreshMasterDS;
   procedure AutoStartUpdateTransaction;
   procedure AutoCommitUpdateTransaction;
    (*
     * Properties that are protected in TFIBCustomDataSet, but should be,
     * at some level, made visible. These are good candidates for
     * being made *public*.
 
     *)
 
 
    property Params: TFIBXSQLDA read GetParams;
    property Prepared: Boolean read FPrepared;
    property QDelete: TFIBQuery read FQDelete;
    property QInsert: TFIBQuery read FQInsert;
    property QRefresh: TFIBQuery read FQRefresh;
    property QSelect: TFIBQuery read FQSelect;
    property QUpdate: TFIBQuery read FQUpdate;
    property StatementType: TFIBSQLTypes read GetStatementType;
    property UpdatesPending: Boolean read FUpdatesPending;

    property BufferChunks: Integer read GetBufferChunks write SetBufferChunks;

    property CachedUpdates: Boolean read FCachedUpdates write SetCachedUpdates default False;
    property DeleteSQL: TStrings read GetDeleteSQL write SetDeleteSQL;
    property InsertSQL: TStrings read GetInsertSQL write SetInsertSQL;
    property RefreshSQL: TStrings read GetRefreshSQL write SetRefreshSQL;
    property SelectSQL: TStrings read GetSelectSQL write SetSelectSQL;
    property UniDirectional: Boolean read FUniDirectional write SetUniDirectional default False;
    property UpdateRecordTypes: TFIBUpdateRecordTypes read FUpdateRecordTypes
         write SetUpdateRecordTypes default [cusUnmodified, cusModified, cusInserted];
    property UpdateSQL: TStrings read GetUpdateSQL write SetUpdateSQL;
    (* -- Events *)
    property DatabaseDisconnecting: TNotifyEvent read FDatabaseDisconnecting
                                                 write FDatabaseDisconnecting;
    property DatabaseDisconnected: TNotifyEvent read FDatabaseDisconnected
                                                write FDatabaseDisconnected;
    property DatabaseFree: TNotifyEvent read FDatabaseFree
                                        write FDatabaseFree;
    property OnUpdateError: TFIBUpdateErrorEvent read FOnUpdateError
                                                 write FOnUpdateError;
    property OnUpdateRecord: TFIBUpdateRecordEvent read FOnUpdateRecord
                                                   write FOnUpdateRecord;
    property AfterUpdateRecord: TFIBAfterUpdateRecordEvent read FAfterUpdateRecord
     write FAfterUpdateRecord
    ;
    property TransactionEnding: TNotifyEvent read FTransactionEnding
                                             write FTransactionEnding;
    property TransactionEnded: TNotifyEvent read FTransactionEnded
                                            write FTransactionEnded;
    property TransactionFree: TNotifyEvent read FTransactionFree
                                           write FTransactionFree;
    property DisableCOCount:integer read FDisableCOCount;
    property CacheModelOptions:TCacheModelOptions  read FCacheModelOptions write SetCacheModelOptions;
 private
 

    function  GetConditions:TConditions;
    procedure SetConditions(Value:TConditions);
    function  GetOrderString:string;
    procedure SetOrderString(const OrderTxt:string);
    function  GetFieldsString:string;
    procedure SetFieldsString(const Value:string);

 public
    function FN(const FieldName: string): TField; //FindField
    function FBN(const FieldName: string): TField; //FieldByName
    procedure SwapRecords(Recno1,Recno2:integer);
    function  GetCacheSize:integer;
    procedure ApplyConditions(Reopen :boolean = False);
    procedure CancelConditions;
 
    property  OrderClause:string read GetOrderString write SetOrderString;
    property  FieldsClause:string read GetFieldsString write SetFieldsString;
    property  GroupByClause:string read GetGroupByString  write SetGroupByString;
    property  MainWhereClause:string read GetMainWhereClause write SetMainWhereClause;
    property  PlanClause:string read GetPlanClause write SetPlanClause;
 
    property  Conditions:TConditions read GetConditions write SetConditions;
 public
    (* public declarations *)
 
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure   Loaded; override;
 
    property AutoUpdateOptions: TAutoUpdateOptions read FAutoUpdateOptions write
      FAutoUpdateOptions;

 private
    vLockResync    :Integer;
    function  NeedMoveRecordToOrderPos:boolean;
    procedure MoveRecordToOrderPos;
    procedure CreateDetailTimer;
    procedure CreateScrollTimer;
 protected
    procedure ChangeScreenCursor(var OldCursor:integer);
    procedure RestoreScreenCursor(const OldCursor:integer);
 public
    property  RunState:TDataSetRunState read FRunState;
    procedure Resync(Mode: TResyncMode); override;
    function  BookmarkValid(Bookmark: TBookmark): Boolean; override;
    procedure Post; override;
    function  SetRecordPosInBuffer(NewPos:integer):integer;

    procedure CloseOpen(const DoFetchAll:boolean);
    procedure StartTransaction;
    procedure BatchInput(InputObject: TFIBBatchInputStream;SQLKind:TpSQLKind =skInsert);
    procedure BatchOutput(OutputObject: TFIBBatchOutputStream);
    function  CachedUpdateStatus: TCachedUpdateStatus;
    procedure CancelUpdates;virtual;
    procedure CheckDatasetClosed(const Reason:string);
    procedure CheckDatasetOpen(const Reason:string);
    procedure CheckNotUniDirectional;
    procedure FetchAll;
    procedure Prepare; virtual;
    procedure UnPrepare;
    procedure RecordModified(Value: Boolean);
 
 
    procedure RevertRecord;
    procedure Undelete;
    procedure DisableScrollEvents;
    procedure EnableScrollEvents;
    procedure DisableCloseOpenEvents;
    procedure EnableCloseOpenEvents;

    procedure DisableCalcFields;
    procedure EnableCalcFields;


{$IFDEF SUPPORT_ARRAY_FIELD}
    function  ArrayFieldValue(Field:TField):Variant;
    procedure SetArrayValue(Field:TField;Value:Variant);
    function  GetElementFromValue( Field:TField;
               Indexes:array of integer):Variant;
 
    procedure SetArrayElementValue(Field:TField;Value:Variant;
     Indexes:array of integer
    );
{$ENDIF}
    function  GetRelationTableName(Field:TObject):string;
    function  GetRelationFieldName(Field:TObject):string;
 
 
    procedure MoveRecord(OldRecno,NewRecno:integer); virtual;

 
    procedure DoSortEx(Fields: array of integer; Ordering: array of Boolean); overload;
    procedure DoSortEx(Fields: TStrings; Ordering: array of Boolean); overload;

    procedure DoSort(Fields: array of const; Ordering: array of Boolean); virtual;

    function  CreateCalcField(FieldClass:TFieldClass; const aName,aFieldName:string;aSize:integer):TField;
    function  CreateLookUpField(FieldClass:TFieldClass; const aName,aFieldName:string;aSize:integer;
     aLookupDataSet: TDataSet; const aKeyFields, aLookupKeyFields, aLookupResultField: string
    ):TField;
    function  GetFieldOrigin(Fld:TField):string;
    function  FieldByOrigin(const aOrigin:string):TField; overload;
    function  FieldByOrigin(const TableName,FieldName:string):TField; overload;
    function  FieldByRelName(const FName:string):TField;
    function  ReadySelectText:string;
    function  TableAliasForField(const aFieldName:string):string;
    function  SQLFieldName(const aFieldName:string):string;
    procedure RestoreMacroDefaultValues;
 
    function  IsComputedField(Fld:Variant):boolean;
    function  DomainForField(Fld:Variant):string;
// Sort Info
    function  SortInfoIsValid:boolean;
    function  IsSortedField(Field:TField; var FieldSortOrder:TSortFieldInfo):boolean;
    function  SortFieldsCount:integer;
    function  SortFieldInfo(OrderIndex:integer):TSortFieldInfo;
    function  SortedFields:string;
    property  SortFields:Variant read FSortFields;
    property  Sorted:boolean read IsSorted;
    property  RelationTables : TStringList read FRelationTables;
    property  CachedActive   :boolean read FCachedActive;
  public
    (* public routines overridden from TDataSet *)
    function CompareBookmarks(Bookmark1, Bookmark2: TBookmark): Integer; override;
    function BlobModified(Field: TField): boolean;
    function CreateBlobStream(Field: TField; Mode: TBlobStreamMode): TStream; override;
    function GetRecordFieldInfo(Field: TField;
      var TableName,FieldName:string; var RecordKeyValues:TDynArray
    ):boolean;

    function GetCurrentRecord(Buffer: dbPChar): Boolean; override;
    function GetBlobFieldData(FieldNo: Integer; var Buffer: TBlobByteData): Integer; override; // MIDAS
    function GetFieldData(Field: TField; Buffer: Pointer): Boolean; override; (* abstract *)
    procedure DataConvert(Field: TField; Source, Dest: Pointer; ToNative: Boolean); override;
    function GetStateFieldValue(State: TDataSetState; Field: TField): Variant; override;
 

    function  RecordFieldValue(Field:TField;RecNumber:integer):Variant; overload;
    function  RecordFieldValue(Field:TField;aBookmark:TBookmark):Variant; overload;

    function ExtLocate(const KeyFields: string; const KeyValues: Variant;
      Options: TExtLocateOptions): Boolean;

    function Locate(const KeyFields: string; const KeyValues: Variant;
      Options: TLocateOptions): Boolean; override;

    function LocatePrior(const KeyFields: string; const KeyValues: Variant;
      Options: TLocateOptions): Boolean; // Sister function to Locate

    function LocateNext(const KeyFields: string; const KeyValues: Variant;
      Options: TLocateOptions): Boolean; // Sister function to Locate
    function ExtLocateNext(const KeyFields: string; const KeyValues: Variant;
      Options: TExtLocateOptions): Boolean; // Sister function to ExtLocate
 
    function ExtLocatePrior(const KeyFields: string; const KeyValues: Variant;
      Options: TExtLocateOptions): Boolean; // Sister function to ExtLocate
 
    procedure RefreshFilters;

    function Lookup(const KeyFields: string; const KeyValues: Variant;
      const ResultFields: string): Variant; override;
    function Translate(Src, Dest: PAnsiChar; ToOem: Boolean): Integer; override;
    function UpdateStatus: TUpdateStatus; override;
    function IsSequenced: Boolean; override;        // Scroll bar
    property  DefaultFields:boolean read GetDefaultFields ;
  public
{$IFDEF CSMonitor}
    procedure SetCSMonitorSupportToQ;
{$ENDIF}    
    procedure CacheDelete;
    procedure CacheOpen;
    procedure RefreshClientFields(ForceCalc:boolean=True);
    function  CreateCalcFieldAs(Field:TField):TField;
    procedure CopyFieldsStructure(Source:TFIBCustomDataSet;RecreateFields:boolean);
    procedure CopyFieldsProperties(Source,Destination:TFIBCustomDataSet);
    procedure AssignProperties(Source:TFIBCustomDataSet);

    procedure OpenAsClone(DataSet:TFIBCustomDataSet);
    procedure Clone(DataSet:TFIBCustomDataSet; RecreateFields:boolean);
    function  CanCloneFromDataSet(DataSet:TFIBCustomDataSet):boolean;



    function  PrimaryKeyFields(const TableName: string): string;
    function  FetchNext(FetchCount:Dword):integer;
    procedure ReopenLocate(const LocateFieldNames:string);
    function  AllFieldValues:variant;
  protected
    procedure InternalFullRefresh(NeedResync:boolean = True;ReopenRefreshSQL:boolean=True);
  public
    procedure FullRefresh;
  private
    FMasSourceDisableCount:integer;
  public
    procedure DisableMasterSource;
    procedure EnableMasterSource;
    function  MasterSourceDisabled:boolean;

    property  CacheSize:integer read GetCacheSize;
    (* Public properties *)
    property  DBHandle: PISC_DB_HANDLE read GetDBHandle;
    property  TRHandle: PISC_TR_HANDLE read GetTRHandle;
    property  AllFetched:boolean read GetAllFetched;
    property  WaitEndMasterInterval:integer read FWaitEndMasterInterval
     write FWaitEndMasterInterval;
    property WaitEndMasterScroll:boolean read GetWaitEndMasterScroll write
     SetWaitEndMasterScroll;
    property CountUpdatesPending: integer read FCountUpdatesPending;
  public
{  ISQLObject }
   function  ParamCount:integer;
   function  ParamName(ParamIndex:integer):string;
   function  FieldsCount:integer;
   function  FieldName(FieldIndex:integer):string;
   function  FieldExist(const FieldName:string; var FieldIndex:integer):boolean;
   function  ParamExist(const ParamName:string; var ParamIndex:integer):boolean;
   function  FieldValue(const FieldName:string; Old:boolean):variant;   overload;
   function  FieldValue(const FieldIndex:integer;Old:boolean):variant; overload;
   function  ParamValue(const ParamName:string):variant;   overload;
   function  ParamValue(const ParamIndex:integer):variant; overload;
   procedure SetParamValue(const ParamIndex:integer; aValue:Variant);
   function  IEof:boolean;
   procedure INext;


{END  ISQLObject }

  public
    (*
     * Published properties implemented in TFIBCustomDataSet
     *)
    (* -- Properties *)

    property Transaction: TFIBTransaction read GetTransaction
                                             write SetTransaction;
    property Database: TFIBDatabase read GetDatabase write SetDatabase;
    property BeforeFetchRecord: TOnFetchRecord read FBeforeFetchRecord
     write SetBeforeFetchRecord;
    property AfterFetchRecord : TOnFetchRecord read FAfterFetchRecord
     write FAfterFetchRecord;
    property OnGetRecordError:TDataSetErrorEvent
     read FOnGetRecordError write FOnGetRecordError;
    property Options:TpFIBDsOptions read FOptions write SetOptions
    {$IFDEF DFM_VERSION1}
    default
     [poTrimCharFields,poStartTransaction,poAutoFormatFields,poRefreshAfterPost];
    {$ELSE}
     stored False;
    {$ENDIF}

    property FieldOriginRule:TFieldOriginRule read FFieldOriginRule write FFieldOriginRule default forTableAndFieldName;

    property DetailConditions:TDetailConditions read
     GetDetailConditions write SetDetailConditions
    stored False;
 
    property  UpdateTransaction:TFIBTransaction read GetUpdateTransaction
     write   SetUpdateTransaction stored StoreUpdTransaction;
    property  PrepareOptions:TpPrepareOptions read FPrepareOptions
              write SetPrepareOptions  stored False;
    property AutoCommit:boolean read FAutoCommit write FAutoCommit default False;
    property OnFieldChange:TFieldNotifyEvent read FOnFieldChange write FOnFieldChange;
    property OnEnableControls:TDataSetNotifyEvent read FOnEnableControls write FOnEnableControls;
    property OnDisableControls:TDataSetNotifyEvent read FOnDisableControls write FOnDisableControls;
    property OnEndScroll      :TDataSetNotifyEvent read FOnEndScroll write SetOnEndScroll;
    property OnFillClientBlob:TOnFillClientBlob read FOnFillClientBlob write FOnFillClientBlob;
    property OnReadBlobField :TOnBlobFieldProcessing read FOnBlobFieldRead write FOnBlobFieldRead;
    property OnWriteBlobField :TOnBlobFieldProcessing read FOnBlobFieldWrite write FOnBlobFieldWrite;
 
  {$IFNDEF NO_GUI}
    property SQLScreenCursor  :TCursor read FSQLScreenCursor write FSQLScreenCursor default crDefault ;
  {$ENDIF}
    property SQLs: TSQLs read FSQLs write FSQLs stored False;
    property RefreshTransactionKind:TTransactionKind read FRefreshTransactionKind
     write SetRefreshTransactionKind default tkReadTransaction;
 
    property BeforeStartTransaction:TNotifyEvent read FBeforeStartTr write FBeforeStartTr ;
    property AfterStartTransaction:TNotifyEvent read FAfterStartTr write FAfterStartTr;
    property BeforeEndTransaction :TEndTrEvent  read FBeforeEndTr write FBeforeEndTr;
    property AfterEndTransaction  :TEndTrEvent  read FAfterEndTr write FAfterEndTr;

    property BeforeStartUpdateTransaction:TNotifyEvent read FBeforeStartUpdTr write FBeforeStartUpdTr;
    property AfterStartUpdateTransaction :TNotifyEvent read FAfterStartUpdTr write FAfterStartUpdTr;
    property BeforeEndUpdateTransaction  :TEndTrEvent  read FBeforeEndUpdTr write FBeforeEndUpdTr;
    property AfterEndUpdateTransaction   :TEndTrEvent  read FAfterEndUpdTr write FAfterEndUpdTr;

    property AllowedUpdateKinds: TUpdateKinds read FAllowedUpdateKinds write
      FAllowedUpdateKinds  default [ukModify, ukInsert, ukDelete];
{$IFDEF CSMonitor}
    property CSMonitorSupport: TCSMonitorSupport read FCSMonitorSupport  write SetCSMonitorSupport;
{$ENDIF}
 
  end;
 
  TFIBDataSet = class(TFIBCustomDataSet)
  private
    function DoStoreActive:boolean;
  public
    property Params;
    property Prepared;
    property QDelete;
    property QInsert;
    property QRefresh;
    property QSelect;
    property QUpdate;
    property StatementType;
    property UpdatesPending;
  public
    property Bof;
    property Bookmark;
    property Designer;
    property Eof;
    property FieldCount;
    property FieldDefs;
    property Fields;
    property FieldValues;
    property Modified;
    property RecordCount;
    property State;
    property BufferChunks;
  published
    property CachedUpdates;
    property UniDirectional;
    property UpdateRecordTypes;
 
    property UpdateSQL;
    property DeleteSQL;
    property InsertSQL;
    property RefreshSQL;
    property SelectSQL;
    property Filter;
    property FilterOptions;
    property CacheModelOptions;    
    property DatabaseDisconnecting;
    property DatabaseDisconnected;
    property DatabaseFree;
    property OnUpdateError;
    property OnUpdateRecord;
    property AfterUpdateRecord;    
    property TransactionEnding;
    property TransactionEnded;
    property TransactionFree;
    property AutoUpdateOptions;

    property Conditions;
  published
    (*
     * Published out of TDataset
     *)
 
    property Active stored DoStoreActive;
    property AutoCalcFields;
//    property DataSource read GetDataSource write SetDataSource;
    property AfterCancel;
    property AfterClose;
    property AfterDelete;
    property AfterEdit;
    property AfterInsert;
    property AfterOpen;
    property AfterPost;
    property AfterScroll;
    property BeforeCancel;
    property BeforeClose;
    property BeforeDelete;
    property BeforeEdit;
    property BeforeInsert;
    property BeforeOpen;
    property BeforePost;
    property BeforeScroll;
    property OnCalcFields;
    property OnDeleteError;
    property OnEditError;
    property OnNewRecord;
    property OnPostError;

    property BeforeRefresh;
    property AfterRefresh;
{TFIBCustomDataSet}
    property AllowedUpdateKinds;
    property Transaction;
    property Database;
    property BeforeFetchRecord;
    property AfterFetchRecord;
    property OnGetRecordError;
    property Options;
    property DetailConditions;
 
    property  UpdateTransaction;
    property  PrepareOptions;
    property FieldOriginRule;    
    property AutoCommit;
    property OnFieldChange;
    property OnEnableControls;
    property OnDisableControls;
    property OnEndScroll     ;
    property OnFillClientBlob;
 {$IFNDEF NO_GUI}
    property SQLScreenCursor ;
 {$ENDIF}
    property SQLs;
    property RefreshTransactionKind;
 
    property BeforeStartTransaction ;
    property AfterStartTransaction;
    property BeforeEndTransaction ;
    property AfterEndTransaction  ;
 
    property BeforeStartUpdateTransaction;
    property AfterStartUpdateTransaction ;
    property BeforeEndUpdateTransaction  ;
    property AfterEndUpdateTransaction   ;
    property DataSource read GetDataSource write SetDataSource;
{$IFDEF CSMonitor}
    property CSMonitorSupport;
{$ENDIF}
 
  end;

  (* TFIBDSBlobStream *)
  TFIBDSBlobStream = class(TStream)
  protected
    FBlobDataArray: PBlobDataArray;
    FBlobID   : TISC_QUAD;
    FModified :boolean;
    FField: TField;
    FBlobStream: TFIBBlobStream;
    FOnBlobFieldRead :TOnBlobFieldProcessing;
    procedure DoCallBack(BlobSize:integer; BytesProcessing:integer; var Stop:boolean);
  public
    constructor Create(AField: TField; ABlobStream: TFIBBlobStream;
      Mode: TBlobStreamMode; ABlobID: TISC_QUAD;aBlobDataArray: PBlobDataArray);
    destructor Destroy; override;
    function  Read(var Buffer; Count: Longint): Longint; override;
    function  Seek(Offset: Longint; Origin: Word): Longint; override;
    procedure SetSize(NewSize: Longint); override;
    function  Write(const Buffer; Count: Longint): Longint; override;
  end;


(*
 * Support routines
 *)
function RecordDataLength(n: Integer): Long;
function IsDBKeyField(Field:TObject):boolean;
function LocateOptionsToExtLocateOptions(LocateOptions:TLocateOptions):TExtLocateOptions;

type
  TFIBFilterType = (ftByField, ftCopy);
 
procedure FilterOut(FromDS: TFIBCustomDataSet);
(* Clear the entire record cache, and do everything short of
   closing the data set--but don't delete anything, etc.. *)


 
procedure Sort(DataSet: TFIBCustomDataSet; aFields: array of const;
  Ordering: array of Boolean);
 
 
 

(*
 * More constants
 *)
const
  DefaultFieldClasses: array[ftUnknown..ftTypedBinary] of TFieldClass = (
    nil,                (* ftUnknown *)
    TFIBStringField,    (* ftString *)
    TFIBSmallIntField,     (* ftSmallint *)
    TFIBIntegerField,      (* ftInteger *)
    TWordField,         (* ftWord *)
    TFIBBooleanField,      (* ftBoolean *)
    TFIBFloatField,     (* ftFloat *)
    TCurrencyField,     (* ftCurrency *)
    TFIBBCDField,          (* ftBCD *)

    TFIBDateField,         (* ftDate *)
    TFIBTimeField,         (* ftTime *)
    TFIBDateTimeField,     (* ftDateTime *)
  {$IFDEF SUPPORT_ARRAY_FIELD}
    TFIBArrayField,
  {$ELSE}
    TBytesField,        (* ftBytes *)
  {$ENDIF}
    TVarBytesField,     (* ftVarBytes *)
    TAutoIncField,      (* ftAutoInc *)

    TFIBBlobField,         (* ftBlob *)
    TFIBMemoField,         (* ftMemo *)
    TGraphicField,      (* ftGraphic *)
 
    TFIBBlobField,         (* ftFmtMemo *)
    TFIBBlobField,         (* ftParadoxOle *)
    TFIBBlobField,         (* ftDBaseOle *)
    TFIBBlobField          (* ftTypedBinary *)
   );
 
 

{$IFDEF LINUX}
const
  FILE_BEGIN = 0;
  FILE_CURRENT = 1;
  FILE_END = 2;
{$ENDIF}
const
  SNoAction = 'No Action';


 

procedure Register;
 
implementation
 uses StrUtil,FIBConsts,pFIBDataInfo,VariantRtn,IB_ErrorCodes,pFIBCacheQueries,DSContainer;
 
const
      DiffSizesRecData=SizeOf(TRecordData)-SizeOf(TSavedRecordData);
      LocateParamPrefix='LOCATE_';

procedure Register;
begin
  RegisterClass(TFIBStringField);
  RegisterClass(TFIBIntegerField);
  RegisterClass(TFIBSmallIntField);
  RegisterClass(TFIBFloatField);
  RegisterClass(TFIBBCDField);
  RegisterClass(TFIBBooleanField);
 
  {$IFDEF SUPPORT_ARRAY_FIELD}
   RegisterClass(TFIBArrayField);
  {$ENDIF}
   RegisterClass(TFIBLargeIntField);
   RegisterClass(TFIBGuidField);
   RegisterClass(TFIBDateField);
   RegisterClass(TFIBTimeField);
   RegisterClass(TFIBDateTimeField);
   RegisterClass(TFIBBlobField);
   RegisterClass(TFIBWideStringField);
   RegisterClass(TFIBMemoField);
end;
 
function IsSysField(const FieldName:string):boolean;
begin
  Result:=False;
  if (Length(FieldName)>4) then
   if (FieldName[1]='R') and (FieldName[2]='D') and (FieldName[3]='B') and
      (FieldName[4]='$')
   then
    Result:=True;
end;
 

function IsDBKeyField(Field:TObject):boolean;
begin
   Result:=((Field is TFIBStringField) and(TFIBStringField(Field).IsDBKey))
    or
    ((Field is TFieldDef) and (TFieldDef(Field).DataType=ftString)
     and
      (TFieldDef(Field).Name='DB_KEY')
    )
end;

(*
 * TFIBStringField - implementation
 *)
 



constructor TFIBStringField.Create(AOwner: TComponent);
begin
   inherited;
   FSqlSubType             :=-1;
   FDefaultValueEmptyString:=False;
end;

destructor  TFIBStringField.Destroy;
begin
 if Assigned(FReservedBuffer) then
  FreeMem(FReservedBuffer);
 if FDataSet is TFIBCustomDataSet then
  TFIBCustomDataSet(FDataSet).vBeforeCloseEvents.Remove(UnPrepare);

 inherited;
end;

class procedure TFIBStringField.CheckTypeSize(Value: Integer);
begin
  (*
   * Just don't check. Any Ansistring size is valid.
   *)
end;

procedure TFIBStringField.Prepare;
var 
 F: TFIBXSQLVAR;
 st:Short;
 lookField:TField;
begin
 if DataSet is TFIBCustomDataSet then
 with TFIBCustomDataSet(DataSet) do
 begin
  if not  QSelect.Prepared then
   QSelect.Prepare;
  F:=QSelect.FindField(Self.FieldName);
  if F<>nil then
  begin
   FSqlSubType:=F.SQLSubtype;
   st:=F.SQLSubtype;
   FCollateNumber:=PByte(Integer(@st)+1)^;
   FCharacterSetName:=F.CharacterSet;
   if (DataSet is TFIBDataset)  then
   begin
    with TFIBDataSet(DataSet).Database do
     FNeedUnicodeConvert:=NeedUnicodeFieldTranslation(Byte(FSqlSubType))
      and   (Byte(FSqlSubType) in UnicodeCharSets)
   end
   else
    FNeedUnicodeConvert:=False;
  end
  else
  begin
   FSqlSubType:=-1;
   FCollateNumber:=0;
   FCharacterSetName:=UnknownStr;
   if FieldKind<>fkLookup  then
    FNeedUnicodeConvert:=False
   else
   begin
    lookField:=LookupDataSet.FindField(LookupResultField);
    if lookField is TWideStringField then
     FNeedUnicodeConvert:=True
    else
    if lookField is TFIBStringField then
     FNeedUnicodeConvert:=TFIBStringField(lookField).FNeedUnicodeConvert
   end;
  end
 end;

 FPrepared:=True;
end;
 
procedure TFIBStringField.UnPrepare(Sender:TObject);
begin
 FPrepared:=False;
end;
 
procedure TFIBStringField.SetDataSet(ADataSet: TDataSet); 
begin
  inherited SetDataSet(ADataSet);
  if DataSet is TFIBCustomDataSet then
    TFIBCustomDataSet(DataSet).vBeforeCloseEvents.Remove(UnPrepare);

  if Assigned(ADataSet) and (ADataSet is TFIBCustomDataSet)  then
  begin
    FEmptyStrToNull         :=
     psSetEmptyStrToNull in TFIBCustomDataSet(ADataSet).FPrepareOptions;
    TFIBCustomDataSet(ADataSet).vBeforeCloseEvents.Add(UnPrepare);
    FDataSet:=ADataSet;
  end;
end;

function   TFIBStringField.GetAsDB_KEY:string;
var
  i : Integer;
  p : Pointer;
begin
  if Dataset.IsEmpty then
  begin
    Result:=''; Exit;
  end;
  if not Assigned(FReservedBuffer) then
  begin
     GetMem(FReservedBuffer, Size + 1);
     FReservedBuffer[Size]:=#0;
  end;
  if not GetData(FReservedBuffer) then
     Result :=''
  else
  for i := 0 to (Size div 4) - 1 do
  begin
      p := Pointer(Integer(FReservedBuffer) + i * 4);
      Result := Result + Format('%-8.8x', [Integer(p^)]);
  end;
end;

function  TFIBStringField.IsDBKey:boolean;
begin
  with TFIBDataSet(DataSet) do
  if (FieldKind=fkData) and Assigned(vFieldDescrList) and (vFieldDescrList.Capacity>0) then
  begin
   Result:=vFieldDescrList[FieldNo-1]^.fdIsDBKey;
  end
  else
   Result:=False;
end;
 
 
function  TFIBStringField.SqlSubType:integer;
begin
 if FieldKind<>fkData then
  Result := -1
 else
 begin
   if not FPrepared then Prepare;
   Result:=FSqlSubType;
 end;
end;

function  TFIBStringField.CharacterSet :string;
begin
 if FieldKind<>fkData then
  Result:=UnknownStr
 else
 begin
   if not FPrepared then Prepare;
   Result:=FCharacterSetName;
 end;
end;
 

function TFIBStringField.GetAsAnsiString: AnsiString;
begin
  if not inherited GetValue(Result) then
   Result := ''
  else
  if (FieldKind=fkData )  and  (DataSet is TFIBDataset) then
  with TFIBDataSet(DataSet).Database do
  begin
   if NeedUnicodeFieldTranslation(Byte(SqlSubType))
    and   (Byte(SqlSubType) in UnicodeCharSets)
   then
     Result:=UTF8ToString(Result)
   else

{$IFDEF SUPPORT_KOI8_CHARSET}
      if IsKOI8Connect
       and not (Byte(SqlSubType) in [1,0]) //OCTETS,NONE
      then
        Result:=ConvertFromCodePage(Result,CodePageKOI8R);
{$ENDIF}

  end;
end;

function TFIBStringField.GetAsString: string;
begin
 Result:=VarToStr(GetAsVariant)
end;

function TFIBStringField.GetAsVariant: Variant;
var
   S: String;
begin
  if not FPrepared then
   Prepare;
  if not GetValue(S) then
   Result := Null
  else
  if FNeedUnicodeConvert then
     Result:=UTF8ToString(S)
 {$IFDEF SUPPORT_KOI8_CHARSET}
  else
  if (FieldKind=fkData )  and  (DataSet is TFIBDataset) then
  with TFIBDataSet(DataSet).Database do
  begin
(*     if NeedUnicodeFieldTranslation(Byte(SqlSubType))
      and   (Byte(SqlSubType) in UnicodeCharSets)
     then
       Result:=UTF8ToString(S)
     else*)
 
{$IFDEF SUPPORT_KOI8_CHARSET}
      if TFIBDataSet(DataSet).Database.IsKOI8Connect
       and not (Byte(SqlSubType) in [1,0]) //OCTETS,NONE
      then
        Result:=ConvertFromCodePage(S,CodePageKOI8R)
      else
{$ENDIF}
 
     Result:=S
  end
{$ENDIF}
  else
     Result:=S
end;
 
 
function TFIBStringField.GetValue(var Value: string): Boolean;
begin
  if IsDBKEY then
  begin
   Value := GetAsDB_KEY;
   Result:=Value<>''
  end
  else
  begin
    if not Assigned(FReservedBuffer) then
    begin
     GetMem(FReservedBuffer, DataSize);
     FReservedBuffer[Size]:=#0;
    end;
    Result := GetData(FReservedBuffer);
    if Result then
     if FReservedBuffer[0]=#0 then
      Value :=''
     else
//      Value :=string(AnsiString(FReservedBuffer));
      Value :=string(AnsiString(FReservedBuffer));
  end;
end;
 
procedure TFIBStringField.SetSize(Value: Integer);
begin
  inherited SetSize(Value);
  FreeMem(FReservedBuffer);
  FReservedBuffer:=nil;
end;

function TFIBStringField.GetDataSize: Integer;
begin
  Result:= inherited;
{$IFDEF UNICODE_TO_STRING_FIELDS}
   if (FieldKind=fkData)  and
     TFIBDataSet(DataSet).Database.NeedUnicodeFieldTranslation(Byte(SqlSubType))
   then
    Result:=(Result-1)*
     TFIBDataSet(DataSet).Database.BytesInUnicodeChar(Byte(sqlsubtype))+1
{$ENDIF}
end;
 
procedure TFIBStringField.Clear;
begin
    SetData(nil);
end;

const
  vEmptyStrBuffer:PAnsiChar = #0;
 
procedure TFIBStringField.SetAsString(const Value: string);
 
procedure InternalSetAsString(const vValue: Ansistring);
begin
   FValueLength :=Length(vValue);
   if FValueLength>0 then
   begin
    SetData(@vValue[1])
   end
   else
    SetData(vEmptyStrBuffer)
end;
 
begin
 vInSetAsString:=True;
 try
   if TFIBDataSet(DataSet).Database.NeedUnicodeFieldTranslation(SqlSubType) then
    InternalSetAsString(UTF8Encode(Value))
   else
{$IFDEF SUPPORT_KOI8_CHARSET}
      if TFIBDataSet(DataSet).Database.IsKOI8Connect and not (Byte(SqlSubType) in [0,1]) //OCTETS,NONE
      then
        InternalSetAsString(ConvertToCodePage(Value,CodePageKOI8R))
      else
{$ENDIF}
    InternalSetAsString(Value);
 finally
  vInSetAsString:=False;
 end;
end;

function TFIBWideStringField.GetDataSize: Integer;
begin
 if FieldKind  in [fkCalculated,fkLookUp] then
  Result:=(Size*3)+1
 else
 begin
  if not FPrepared then  Prepare;
  Result:=FDataSize
 end;
end;
 
 
 
procedure TFIBWideStringField.Prepare;
var
 F: TFIBXSQLVAR;
 st:Short;
begin
 if DataSet is TFIBCustomDataSet then
 with TFIBCustomDataSet(DataSet) do
 begin
  if not  QSelect.Prepared then
   QSelect.Prepare;
  F:=QSelect[Self.FieldName];
  if F<>nil then
  begin
   FSqlSubType:=F.SQLSubtype;
   st:=F.SQLSubtype;
   FCollateNumber:=PByte(Integer(@st)+1)^;
   FCharacterSetName:=F.CharacterSet;
   if Byte(F.SQLSubtype) in Database.UnicodeCharSets then
     FDataSize:=(Size*Database.BytesInUnicodeChar(Byte(F.SQLSubtype)))+1
   else
     FDataSize:=(Size*3)+1;
  end
  else
  begin
   FSqlSubType:=-1;
   FDataSize:=(Size*3)+1;
   FCollateNumber:=0;
   FCharacterSetName:=UnknownStr;
  end
 end;
 
 FPrepared:=True;
end;

procedure TFIBWideStringField.SetAsString(const Value: string);

procedure InternalSetAsString(const vValue: Ansistring);
begin
   if Length(vValue)>0 then
   begin
    SetData(@vValue[1])
   end
   else
    SetData(vEmptyStrBuffer)
end;

begin
   if TFIBDataSet(DataSet).Database.NeedUnicodeFieldsTranslation then
    InternalSetAsString(UTF8Encode(Value))
   else
    InternalSetAsString(Value);
end;
 
procedure TFIBWideStringField.SetAsWideString(const Value: UnicodeString);
begin
// SetAsString(Value)
  inherited
end;
 
procedure TFIBWideStringField.SetDataSet(ADataSet: TDataSet);
begin
  if DataSet is TFIBCustomDataSet then
   TFIBCustomDataSet(DataSet).vBeforeCloseEvents.Remove(UnPrepare);
  if ADataSet is TFIBCustomDataSet then
   TFIBCustomDataSet(ADataSet).vBeforeCloseEvents.Add(UnPrepare);
  FDataSet:=ADataSet;
  inherited SetDataSet(ADataSet);
end;
 
constructor TFIBWideStringField.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FSqlSubType:=-1;
end;
 
destructor TFIBWideStringField.Destroy;
begin
  if FDataSet is TFIBCustomDataSet then
   TFIBCustomDataSet(FDataSet).vBeforeCloseEvents.Remove(UnPrepare);
  inherited;
end;

procedure TFIBWideStringField.Clear;
begin
    SetData(nil);
end;

function  TFIBWideStringField.CharacterSet :string;
begin
 if FieldKind<>fkData then
  Result:=UnknownStr
 else
 begin
   if not FPrepared then Prepare;
   Result:=FCharacterSetName;
 end;
end;
 
function  TFIBWideStringField.SqlSubType:Integer;
begin
 if FieldKind<>fkData then
  Result := -1
 else
 begin
   if not FPrepared then Prepare;
   Result:=FSqlSubType;
 end;
end;

procedure TFIBWideStringField.UnPrepare(Sender: TObject);
begin
 FPrepared:=False;
end;

function  TFIBWideStringField.CollateNumber :Byte;
begin
 if FieldKind<>fkData then
  Result:=0
 else
 begin
   if not FPrepared then Prepare;
   Result:=FCollateNumber;
 end;
end;

(*
 * TFIBLargeIntField - implementation
 *)
 
function TFIBLargeIntField.GetOldAsInt64:Int64;
var 
  SaveState: TDataSetState;
begin
  if FieldKind in [fkData, fkInternalCalc] then
  begin
    SaveState := DataSet.State;
    TFIBCustomDataSet(DataSet).SetTempState(dsOldValue);
    try
      Result := AsLargeInt;
    finally
     TFIBCustomDataSet(DataSet).RestoreState(SaveState);
    end;
  end
  else
    Result := 0;
end;
 
procedure TFIBLargeIntField.SetVarValue(const Value: Variant);
begin
 {$IFNDEF D6+}
    inherited  SetVarValue(Value)
 {$ELSE}
    if VarIsNull(Value) or VarIsEmpty(Value) then
     Clear
    else
     SetAsLargeInt(Value);
 {$ENDIF}
end;
(*
 * TFIBIntegerField - implementation
 *)

 constructor TFIBIntegerField.Create(AOwner: TComponent); //override;
 begin
  inherited Create(AOwner);
 end;

 function TFIBIntegerField.GetAsBoolean: Boolean;
 begin
   Result:=AsInteger>0
 end;
 
 procedure TFIBIntegerField.SetAsBoolean(Value: Boolean);
 begin
  if Value then  AsInteger:=1 else AsInteger:=0
 end;

 procedure   TFIBIntegerField.Clear;
 begin
  SetData(nil);
 end;

(*
 * TFIBDateField - implementation
 *)
 
 
(*
 * TFIBTimeField - implementation
 *)
procedure TFIBTimeField.GetText(var Text: string; DisplayText: Boolean);
var 
    Data: integer;
begin
   inherited GetText(Text,DisplayText);
   if FShowMsec then
   begin
    if Dataset.GetFieldData(Self,@Data) then
    begin
       Data:= Data mod 1000;
       if  Data >0 then
        Text:=Text+'.'+IntToStr(Data)
    end
   end;
 end;
 
(*
 * TFIBDateTimeField - implementation
 *)
 

 procedure TFIBDateTimeField.GetText(var Text: string; DisplayText: Boolean);
 var
    Data: Double;
    ts:TTimeStamp;

 begin
   inherited GetText(Text,DisplayText);
   if FShowMsec then
   begin
    if Dataset.GetFieldData(Self,@Data) then
    begin
       ts:=MSecsToTimeStamp(Data);
       ts.Time:= ts.Time mod 1000;
       if  ts.Time >0 then
        Text:=Text+'.'+IntToStr(ts.Time)
    end
   end;
 end;
 
 function TFIBDateTimeField.GetAsTimeStamp:TTimeStamp;
 var
    Data: Double;
 begin
    if Dataset.GetFieldData(Self,@Data) then
     Result:=MSecsToTimeStamp(Data)
    else
    begin
     Result.Time:=0;
     Result.Date:=0;
    end;
 end;
 
 procedure TFIBDateTimeField.SetAsTimeStamp(const Value:TTimeStamp);
  var
    Data: Double;
 begin
   Data:=TimeStampToMSecs(Value);
   SetData(@Data)
 end;


(*
 * TFIBBlobField - implementation
 *)

 
function TFIBBlobField.GetAsVariant: Variant;
begin
  if IsNull then
   Result:=Null
  else
   Result:= inherited GetAsVariant;
end;
 
function TFIBBlobField.GetBlobId:TISC_QUAD;
var 
 ValueBuffer: PAnsiChar;
begin
  GetMem(ValueBuffer,SizeOf(TISC_QUAD));
  try
   GetData(ValueBuffer);
   Result:=PISC_QUAD(ValueBuffer)^;
  finally
   FreeMem(ValueBuffer)
  end;
end;
 
function TFIBBlobField.GetIsNull:boolean;
begin
 if FIsClientCalcField then
   Result:=BlobSize=0
 else
   Result:= inherited GetIsNull;
end;

function TFIBMemoField.GetAsString: string;
begin
  Result:=inherited GetAsAnsiString;
  with TFIBDataSet(DataSet).Database do
  if NeedUTFEncodeDDL and (IsUnicodeConnect or (FCharSetID in UnicodeCharSets))
  then
    Result:=UTF8ToString(Result)
end;
 
function TFIBMemoField.GetAsVariant: Variant;
begin
  if IsNull then
   Result:=Null
  else
  with TFIBDataSet(DataSet).Database do
  if (NeedUTFEncodeDDL and IsUnicodeConnect) or (FCharSetID in UnicodeCharSets) then
   Result:= GetAsWideString
  else
   Result:= inherited GetAsVariant;
end;

procedure TFIBMemoField.SetAsVariant(const Value: Variant);
begin
  with TFIBDataSet(DataSet).Database do
  if (NeedUTFEncodeDDL and IsUnicodeConnect) or (FCharSetID in UnicodeCharSets) then
  begin
   if VarIsNull(Value) then
    Clear
   else
    SetAsWideString(Value)
  end
  else
   inherited SetAsVariant(Value)
end;

procedure TFIBMemoField.SetAsString(const Value: string); 
begin
 with  TFIBDataSet(DataSet).Database do
  if (NeedUTFEncodeDDL  and IsUnicodeConnect) or (FCharSetID in UnicodeCharSets) then
    inherited SetAsAnsiString(UTF8Encode(Value))
   else
    inherited SetAsString(Value)
end;
 
function TFIBMemoField.GetBlobId:TISC_QUAD;
var
 ValueBuffer: PAnsiChar;
begin
  GetMem(ValueBuffer,SizeOf(TISC_QUAD));
  try
   GetData(ValueBuffer);
   Result:=PISC_QUAD(ValueBuffer)^;
  finally
   FreeMem(ValueBuffer)
  end;
end;

procedure TFIBMemoField.InternalSetCharSet(aValue:integer); // Internal use
begin
 FCharSetID:=aValue
end;
 
function TFIBMemoField.GetAsAnsiString: AnsiString;
begin
 Result:=inherited GetAsAnsiString;
 with  TFIBDataSet(DataSet).Database do
  if (NeedUTFEncodeDDL and IsUnicodeConnect) or (FCharSetID in UnicodeCharSets) then
    Result:=UTF8ToString(Result)
end;

function TFIBMemoField.GetAsWideString: UnicodeString;
begin
 with  TFIBDataSet(DataSet).Database do
  if (NeedUTFEncodeDDL and IsUnicodeConnect) or (FCharSetID in UnicodeCharSets) then
    Result:=UTF8ToString(inherited GetAsAnsiString)
   else
    Result:=inherited GetAsAnsiString;
end;

procedure TFIBMemoField.SetAsWideString(const aValue: UnicodeString);
begin
 with  TFIBDataSet(DataSet).Database do
  if (NeedUTFEncodeDDL and IsUnicodeConnect) or (FCharSetID in UnicodeCharSets) then
    inherited SetAsAnsiString(UTF8Encode(aValue))
   else
    inherited SetAsString(aValue)
end;

function TFIBMemoField.GetWideDisplayText: WideString;
begin
 Result:=GetAsWideString
end;

function TFIBMemoField.GetWideEditText: WideString;
begin
 Result:=GetAsWideString
end;

procedure TFIBMemoField.SetWideEditText(const Value: WideString);
begin
 SetAsWideString(Value)
end;
 
(*
 * TFIBSmallIntField - implementation
 *)
 

 function TFIBSmallIntField.GetAsBoolean: Boolean;
 begin
   Result:=AsInteger>0
 end;
 
 procedure TFIBSmallIntField.SetAsBoolean(Value: Boolean); 
 begin
  if Value then  AsInteger:=1 else AsInteger:=0
 end;

constructor TFIBFloatField.Create(AOwner: TComponent); 
begin
 inherited Create(AOwner);
 FRoundByScale:=True;
end;
 
function TFIBFloatField.GetScale:integer;
begin
 if (FieldKind=fkData) then
  Result:=TFIBCustomDataSet(DataSet).GetFieldScale(Self)
 else
  Result:=-15;
end;

procedure TFIBFloatField.GetText(var Text: string; DisplayText: Boolean);
begin
 inherited GetText(Text,DisplayText);
 Text:=Trim(Text)
end;
 
 
procedure TFIBFloatField.SetAsFloat(Value: Double);
var
  fi:  PFIBFieldDescr;
begin
 if (FieldKind=fkData)  then
 begin
   fi:=TFIBDataSet(DataSet).vFieldDescrList[FieldNo-1];
   if Assigned(fi) then
   case fi^.fdDataType of
    SQL_SHORT:
         if (Value>MaxShort*E10[fi^.fdDataScale]) or
                   (Value<-MaxShort*E10[fi^.fdDataScale])
              then
                RangeError(Value, -MaxShort*E10[fi^.fdDataScale], MaxShort*E10[fi^.fdDataScale]);
 
    SQL_LONG: if (Value>MaxInt*E10[fi^.fdDataScale]) or
                   (Value<-MaxInt*E10[fi^.fdDataScale])
              then
                RangeError(Value, -MaxInt*E10[fi^.fdDataScale], MaxInt*E10[fi^.fdDataScale]);
   end;
 end;
 if FRoundByScale  and (Scale<>0) then
  inherited
   SetAsFloat(RoundExtend(Value,-Scale))
 else
  inherited SetAsFloat(Value)
end;
 
{TFIBBooleanField}

constructor TFIBBooleanField.Create(AOwner: TComponent);
begin
  inherited;
  FStringTrue :=TrueStr ;
  FStringFalse:=FalseStr;
end;


function  TFIBBooleanField.GetAsInteger: Longint; 
begin
 if Value then Result:=1 else Result:=0
end;

function TFIBBooleanField.GetDataSize:Integer;
begin
 if DataSet = nil then
   Result := inherited GetDataSize // SizeOf( WordBool )
  else
  with TFIBDataSet(DataSet).GetXSQLVAR(Self) do
   if SqlType <> -1 then
     Result := sqllen
   else
    Result := inherited GetDataSize;
end;
 

function TFIBBooleanField.StoreStrFalse: boolean;
begin
  Result:=FStringFalse<>'False';
end;

function TFIBBooleanField.StoreStrTrue: boolean;
begin
  Result:=FStringTrue<>'True';
end;
 
function TFIBBooleanField.GetAsString: string;
var
  B:  LongBool;
begin
  B := False; // clear
  if GetData(@B) then
   if B then
    Result :=FStringTrue
   else
    Result :=FStringFalse
  else
   Result :='';
end;
 
procedure TFIBBooleanField.SetAsInteger(Value: Longint);//override;
begin
  SetAsBoolean(Value<>0)
end;
 

procedure TFIBBooleanField.SetAsString(const Value: string);
var StrValue:string;
begin
 if (Value='1') or (Value='T') or (CompareText(Value,FStringTrue)=0) then
   SetAsBoolean(True)
 else
  if (Value='0') or (Value='F') or (CompareText(Value,FStringFalse)=0) then
   SetAsBoolean(False)
  else
  begin
   StrValue:=Value;
   inherited SetAsString(StrValue);
  end;
end;

procedure TFIBBooleanField.SetVarValue(const Value: Variant);
begin
  if VarType(Value) = vtString    then
   SetAsString(Value)
  else
   inherited;
end;
 

function TFIBBooleanField.GetAsBoolean: Boolean;
var 
  B:  LongBool;
begin
  B := False; // clear
  if GetData(@B) then Result := B else Result := False;
end;

function TFIBBooleanField.GetAsVariant: Variant;
var
  B: LongBool;
begin
  B := False; // clear
  if GetData(@B) then Result := B else Result := Null;
end;

procedure TFIBBooleanField.SetAsBoolean(Value: Boolean);
var 
  B: LongBool;
begin
  if Value then Long(B) := 1 else Long(B) := 0;
  SetData(@B);
end;

//Array support
{$IFDEF SUPPORT_ARRAY_FIELD}

 constructor TFIBArrayField.Create(AOwner: TComponent); //override;
 begin
  inherited Create(AOwner);
  FOldValueBuffer:=nil;
 end;

 destructor TFIBArrayField.Destroy; //override;
 begin
  FIBAlloc(FOldValueBuffer, 0, 0);
  inherited Destroy;
 end;


 procedure TFIBArrayField.GetText(var Text: string; DisplayText: Boolean);
 begin
  if IsNull then
   Text:='(Array)'
  else
   Text:='(ARRAY)'
 end;
 
 function TFIBArrayField.GetFIBXSQLVAR:TFIBXSQLVAR;
 begin
   if DataSet=nil then Result:=nil
   else
   with TFIBDataSet(DataSet).QSelect,TFIBDataSet(DataSet) do
   begin
    if not Prepared then Prepare;
    Result:=QSelect[Self.FieldName]
   end;
 end;
 
 function TFIBArrayField.GetDimCount:integer;
 begin
    if GetFIBXSQLVAR=nil then
     Result:=0
    else
     Result:=GetFIBXSQLVAR.DimensionCount
 end;

 function TFIBArrayField.GetElementType:TFieldType;
 begin
    if GetFIBXSQLVAR=nil then
     Result:=ftUnknown
    else
     Result:=GetFIBXSQLVAR.ElementType
 end;

 function TFIBArrayField.GetDimension(Index:integer):TISC_ARRAY_BOUND;
 begin
    if GetFIBXSQLVAR=nil then
     FibError(feInvalidColumnIndex,[nil])
    else
     Result:=GetFIBXSQLVAR.Dimension[Index]
 end;

 function TFIBArrayField.GetArraySize:integer;
 begin
    if GetFIBXSQLVAR=nil then
     Result:=0
    else
     Result:=GetFIBXSQLVAR.ArraySize
 end;
 
function  TFIBArrayField.GetArrayId:TISC_QUAD;
var 
 ValueBuffer:  PAnsiChar;
begin
  GetMem(ValueBuffer,SizeOf(TISC_QUAD));
  try
   GetData(ValueBuffer);
   Result:=PISC_QUAD(ValueBuffer)^;
  finally
   FreeMem(ValueBuffer)
  end;
end;
 

 
function TFIBArrayField.GetAsVariant:Variant;
begin
 Result:=0;
 if DataSet <>nil then
  Result:=TFIBDataSet(DataSet).ArrayFieldValue(Self)
end;

procedure TFIBArrayField.SetAsVariant(const Value: Variant); //override;
begin
 if DataSet <>nil then
  TFIBDataSet(DataSet).SetArrayValue(Self,Value)
end;


procedure  TFIBArrayField.SaveOldBuffer;
begin
  FIBAlloc(FOldValueBuffer,0,ArraySize);
  GetData(FOldValueBuffer);
end;

procedure TFIBArrayField.RestoreOldBuffer;
begin
  SetData(FOldValueBuffer);
end;

{$ENDIF}
 
 
 
 
{ TFIBBCDField }
 
constructor TFIBBCDField.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  SetDataType(ftBCD);
  Size := 8;
  FRoundByScale:=True;
  FDataAsComp  :=False;
end;

{$IFDEF D6+}
procedure   TFIBBCDField.AddExtended(const Value:Extended);
var
    oBCD:  TBCD;
begin
    oBCD:=ExtendedToBCD(Value,Size);
    BcdAdd(asBCD, oBCD,oBCD);
    AsBcd:=oBCD
end;
 

procedure TFIBBCDField.SubtractExtended(const Value:Extended);
var 
    oBCD: TBCD;
begin
    oBCD:=ExtendedToBCD(Value,Size);
    BcdSubtract(asBCD, oBCD,oBCD);
    AsBcd:=oBCD
end;
 
procedure TFIBBCDField.MultiplyExtended(const Value:Extended);
var 
    oBCD:  TBCD;
begin
    oBCD:=ExtendedToBCD(Value,Size);
    BcdMultiply(asBCD, oBCD,oBCD);
    AsBcd:=oBCD
end;
 
procedure TFIBBCDField.DivideExtended(const Value:Extended);
var 
    oBCD: TBCD;
begin
    oBCD:=ExtendedToBCD(Value,Size);
    BcdDivide(asBCD, oBCD,oBCD);
    AsBcd:=oBCD
end;
 

procedure TFIBBCDField.AddBCD(const Value:TBCD);
var
    oBCD: TBCD;
begin
    BcdAdd(asBCD, Value,oBCD);
    AsBcd:=oBCD
end;
 
procedure TFIBBCDField.SubtractBCD(const Value:TBCD);
var 
    oBCD: TBCD;
begin
    BcdSubtract(asBCD, Value,oBCD);
    AsBcd:=oBCD
end;
 
procedure TFIBBCDField.MultiplyBCD(const Value:TBCD);
var 
    oBCD: TBCD;
begin
    BcdMultiply(asBCD, Value,oBCD);
    AsBcd:=oBCD
end;
 
procedure TFIBBCDField.DivideBCD(const Value:TBCD);
var 
    oBCD: TBCD;
begin
    BcdDivide(asBCD, Value,oBCD);
    AsBcd:=oBCD
end;
 
{$ENDIF}

class procedure TFIBBCDField.CheckTypeSize(Value: Integer);
begin
{ No need to check as the base type is currency, not BCD }
end;


function TFIBBCDField.GetScale:integer;
begin
 if (FieldKind=fkData) then
  Result:=TFIBCustomDataSet(DataSet).GetFieldScale(Self)
 else
  Result:=-15;
end;
 
function TFIBBCDField.GetAsCurrency: Currency;
begin
  if (FieldKind=fkCalculated) {or (Scale=-4)} then
    Result := inherited GetAsCurrency
  else
  if not GetValue(Result) then
    Result := 0;
end;
 
 
 
function TFIBBCDField.GetAsString: string;
var 
  C:  Int64;
  Success:boolean;
begin
 if FieldKind=fkCalculated then
  Result:= inherited GetAsString
 else
 begin
    Success:=GetData(@C);
    if Success then
     if Size=0 then
      Result  := IntToStr(C)
     else
     {$IFNDEF D6+}
      Result  := CompWithScaleToStr(C,Size,DecimalSeparator)
     {$ELSE}
      Result  := BCDToStr(GetAsBCD)       
     {$ENDIF}
    else
      Result := '';
 end;
end;


function TFIBBCDField.GetAsVariant: Variant;
begin
  if FieldKind=fkCalculated then
   Result:=inherited GetAsVariant
  else
  if IsNull then
    Result := Null
  else
  begin
  {$IFDEF D6+}
    if Size=0 then
     Result:=AsInt64
    else
  {$ENDIF}
    if Size=4 then
       Result :=AsCurrency
    else
       Result :=AsExtended;
 
  end;

end;


function TFIBBCDField.GetDataSize: Integer;
var
   lTF:  TField;
begin
  case FieldKind  of
   fkCalculated:
    Result := inherited GetDataSize;
   fkLookUp:
    if Assigned(LookupDataSet)  then
    begin
      lTF:=LookupDataSet.FindField(LookupResultField);
      if Assigned(lTF) then
       Result := lTF.DataSize
      else
       Result := SizeOf(Int64);
    end
    else
     Result := SizeOf(Int64);
  else
   if (ServerType=SQL_DOUBLE) then
    Result := 8
   else
    Result := SizeOf(Int64);
  end
end;
 
 
function  TFIBBCDField.ServerType:integer;
var
 F:  TFIBXSQLVAR;
begin
 Result:=SQL_DOUBLE;
 with TFibDataSet(DataSet),TFibDataSet(DataSet).QSelect do
 try
  F:=QSelect[Self.FieldName];
  if F<>nil then Result:=F.Data^.sqltype and (not 1);
 except
 end;
end;


 

procedure TFIBBCDField.GetText(var Text: string; DisplayText: Boolean);
var
  FmtStr:  string;
  Digits: Integer;
  TC: Int64;
  Format: TFloatFormat;
  {$IFDEF D6+}
  bcdValue:TBCD;
  {$ENDIF}
begin
  if FieldKind in [fkCalculated] then
   inherited GetText(Text,DisplayText)
  else
  begin
    if not GetData(@TC) then
      Text := ''
    else
    begin
      if DisplayText or (EditFormat = '') then
        FmtStr := DisplayFormat
      else
        FmtStr := EditFormat;
      if Size = 0 then
      begin
       if FmtStr = '' then
       begin
         Text:=IntToStr(TC)
       end
       else
       begin
        {$IFNDEF D6+}
         Text := FormatFloat(FmtStr, TC);
        {$ELSE}
          Int64ToBCD(TC,Size,bcdValue);
          Text :=FormatBcd(FmtStr,bcdValue)
        {$ENDIF}
       end;
      end
      else
      begin
          if FmtStr = '' then
          begin
            if currency then
            begin
             Digits := CurrencyDecimals;
             if DisplayText then Format := ffCurrency else Format := ffFixed;
             Text := CurrToStrF(TC*E10[-Size], Format, Digits);
            end
            else
            begin
              Digits := Size;
              Text := Int64WithScaleToStr(TC,Digits,DecimalSeparator)
            end;
          end
          else
          if Size=4 then
           Text := FormatCurr(FmtStr, TC*E10[-Size])
          else
          begin
            {$IFNDEF D6+}
              Text := FormatFloat(FmtStr, RoundExtend(TC*E10[-Size],Size));
            {$ELSE}
              Text := FormatNumericString(FmtStr,Int64WithScaleToStr(TC,Size,DecimalSeparator));
            {$ENDIF}
          end;
      end;
    end;
  end;
end;

function TFIBBCDField.GetValue(var Value: Currency): Boolean;
var 
  C  :  Int64;
begin
  if FieldKind=fkCalculated then
     Result:= inherited GetValue(Value)
  else
  if Size=4 then
    Result := GetData(@Value)
  else
  begin
    C:=0;
    if Size = 0 then //patchInt64B start
    begin
      Result := GetData(@C);
      Value  := C;
    end
    else
    begin //patchInt64B end
     Result := GetData(@C);
     if Result then
     begin
      if Size<4 then
      begin
       Value:=E10[-Size];
       Value  := C*Value;
      end
      else
       Value  := C*E10[-Size];
     end  
    end
  end;
end;
 
procedure TFIBBCDField.SetAsString(const Value: string); //override;
begin
 if FieldKind=fkCalculated then
  inherited SetAsString(Value)
 else
 begin
   if Value = '' then
    Clear
   else
   if (ServerType=SQL_INT64)  then
   begin
    if (Size=0) then
     SetAsInt64(StrToInt64(Value))
    else
    {$IFNDEF D6+}
     SetAsExtended(StrToFloat(Value)) ;
    {$ELSE}
     SetAsBCD(StrToBCD(Trim(Value)));
{     I:=StrToInt64(ReplaceStr(Value,DecimalSeparator,''));
     SetData(@I);}
    {$ENDIF}
   end
   else
    inherited SetAsString(Value)
 end;
end;
 
procedure TFIBBCDField.SetAsCurrency(Value: Currency);
var 
  C: comp;
begin
 if FieldKind=fkCalculated then
  inherited SetAsCurrency(Value)
 else
 try
  if Size = 0 then
  begin
    C := Value;
    SetData(@C);
  end
  else
  begin
   if (MinValue <> 0) or (MaxValue <> 0) then
   begin
    Value:= RoundExtend(Value,Size);
    if (Value < MinValue) or (Value > MaxValue) then
      RangeError(Value, MinValue, MaxValue);
   end;
    C:=Value*E10[Size];
    SetData(@C);
  end;
 except
   on E: Exception do
    if Assigned(OnValidate) then
     raise
    else
    if Self.Name='' then
     raise Exception.Create(CmpFullName(Self)+'.'+FieldName+#13#10+E.Message)
    else
     raise Exception.Create(CmpFullName(Self)+#13#10+E.Message)
 end
end;
 
function  TFIBBCDField.GetAsExtended: Extended;
var 
  C:  Int64;
  Success:boolean;
begin
  Success:=GetData(@C);
  if not Success then
    Result := 0
  else
    Result:=C*E10[-Size]
end;
 
 {$IFNDEF NO_USE_COMP}
function TFIBBCDField.GetAsComp: comp;
begin
  if Size = 0 then
  begin
    if not GetData(@Result) then
      Result := 0;
  end
  else
    Result := GetAsExtended;
end;

procedure TFIBBCDField.SetAsComp(Value: comp);
begin
  if FieldKind=fkCalculated then
   inherited SetVarValue(Value)
  else
  if Size = 0 then
    SetData(@Value)
  else
    AsExtended := Value;
end;
{$ENDIF}

function  TFIBBCDField.GetAsBCD: TBcd;
var 
 C: Int64;
begin
 if FieldKind=fkCalculated then
{$IFDEF D6+}
  Result:=inherited GetAsBCD
{$ENDIF}
 else
 begin
  if not GetData(@C) then
   C:=0;
  Int64ToBCD(C,Size,Result)
 end;
end;
 
procedure TFIBBCDField.SetAsBCD(const Value: TBcd);
var
 C:  Int64;
 lScale  :byte;
begin
 if FieldKind=fkCalculated then
{$IFDEF D6+}
  inherited SetAsBcd(Value)
{$ENDIF}
 else
 begin
  BCDToCompWithScale(Value,c,lScale);
  if lScale<>Size then
   C:=Round(C*E10[Size-lScale]);
  SetData(@C);
 end   
end;
 
procedure TFIBBCDField.SetVarValue(const Value: Variant);
var
    C:  Comp;
begin
  if VarIsNull(Value) then
    Clear
  else
 try
{$IFDEF D6+}
  if FieldKind=fkCalculated then
   inherited SetVarValue(Value)
  else
  case VarType(Value) of
   varInt64   :   SetAsInt64(Value);
  else
    C:=Value*E10[Size];
    SetData(@C);
//   inherited SetVarValue(Value)
  end;
{$ELSE}
    C:=Value*E10[Size];
    SetData(@C);
//   inherited SetVarValue(Value)
{$ENDIF}
 except
     on EVariantError do DatabaseErrorFmt(SFieldValueError, [DisplayName]);
 end
end;

function  TFIBBCDField.FieldModified:boolean;
var 
   OldIsNull:  boolean;
   vIsNull:boolean;
begin
  Result:=(GetInternalData(vIsNull)<>GetInternalOldData(OldIsNull))
   or (vIsNull xor OldIsNull);
end;

function  TFIBBCDField.GetInternalData(var ValueIsNull:boolean):Int64;
begin
   ValueIsNull:=not GetData(@Result);
   if ValueIsNull then
      Result := 0;
end;

function  TFIBBCDField.GetInternalOldData(var OldIsNull:boolean):Int64;
var
  SaveState:  TDataSetState;
begin
  if FieldKind in [fkData, fkInternalCalc] then
  begin
    SaveState := DataSet.State;
    TFIBCustomDataSet(DataSet).SetTempState(dsOldValue);
    try
      Result := GetInternalData(OldIsNull);
    finally
     TFIBCustomDataSet(DataSet).RestoreState(SaveState);
    end;
  end
  else
    Result := 0;
end;



function  TFIBBCDField.GetAsInt64: Int64;
begin
  if not GetData(@Result) then
   Result := 0
  else
  if Size > 0 then
    Result := Result div IE10[Size];
end;

{$IFNDEF D6+}
 type
  PComp=^Comp;
{$ENDIF}

procedure TFIBBCDField.SetAsInt64(const Value: Int64);
begin
  if FieldKind=fkCalculated then
  {$IFDEF D6+}
   inherited SetVarValue(Value)
  {$ELSE}
    inherited SetVarValue(PComp(@Value)^)
  {$ENDIF}
  else
  if Size = 0 then
    SetData(@Value)
  else
    AsExtended := Value;
end;

procedure TFIBBCDField.SetAsExtended(Value: Extended);
var
 RndComp : Comp;
begin
  try
   RndComp :=Value*E10[Size];
  except
   on E: Exception do
   begin
    if Self.Name='' then
     raise Exception.Create(CmpFullName(Self)+'.'+FieldName+#13#10+E.Message)
    else
     raise Exception.Create(CmpFullName(Self)+#13#10+E.Message)
   end;
  end;
  SetData(@RndComp);
end;

function TFIBBCDField.GetData(Buffer: Pointer): Boolean;
begin
 if FieldKind=fkCalculated then
    Result:= inherited GetData(Buffer)
 else
 try
  FDataAsComp:=True;
  Result:= inherited GetData(Buffer);
 finally
  FDataAsComp:=False
 end;
end;


procedure TFIBBCDField.Assign(Source: TPersistent);
begin
  if FieldKind=fkCalculated then
    inherited Assign(Source)
  else
  if Source is TBCDField then
  begin
   AsString:=BCDFieldAsString(TBCDField(Source),False)
  end
  else
   inherited Assign(Source);
end;


(*
 * TFIBDataLink - implementation
 *)
constructor TFIBDataLink.Create(ADataSet: TFIBCustomDataSet);
begin
  inherited Create;
  FDataSet := ADataSet;
end;
 
destructor TFIBDataLink.Destroy;
begin
  FDataSet.FSourceLink := nil;
  inherited;
end;
 
procedure TFIBDataLink.DataSetChanged;
begin
 inherited DataSetChanged;
end;
 

function TFIBDataLink.GetDetailDataSet: TDataSet;
begin
  Result := FDataSet;
end;

procedure TFIBDataLink.ActiveChanged;
begin
  if Active then
  begin
    FDataSet.SourceChanged;
  end
  else
  if not Active then
  begin
    FDataSet.SourceDisabled;
  end;
end;
 
procedure TFIBDataLink.CheckBrowseMode;
begin
end;
 
procedure TFIBDataLink.RecordChanged(Field: TField);
begin
  if (Field=nil) and (FDataSet.Active) then
  begin
   if (not FDataSet.MasterFieldsChanged) then
    Exit;
   FDataSet.SourceChanged;
  end;
end;
 
(*
 * TFIBCustomDataSet - implementation
 *)


function TFIBCustomDataSet.CreateInternalQuery(const QName:string):TFIBQuery;
begin
  Result:= TFIBQuery.Create(Self);
{$IFDEF CSMonitor}
   Result.CSMonitorSupport.Enabled := FCSMonitorSupport.Enabled;
   Result.CSMonitorSupport.IncludeDatasetDescription :=
     FCSMonitorSupport.IncludeDatasetDescription;
{$ENDIF}
  with Result do
  begin

    OnSQLChanging := SQLChanging;
    GoToFirstRecordOnExecute := False;
    ParamCheck := True;
    Options    :=[];
    Name       :=QName;
  end;
end;
 
 
constructor TFIBCustomDataSet.Create(AOwner: TComponent);
begin
  inherited;
  FBase := TFIBBase.Create(Self);
  FRecordsCache:=nil;
  FUniDirectional:=False;
  FCachedUpdates :=False;
  FCurrentRecord := -1;
  FDeletedRecords := 0;
{$IFDEF CSMonitor}
  FCSMonitorSupport := TCSMonitorSupport.Create(Self);
{$ENDIF}
  FBlobStreamList := TList.Create;
  FOpenedBlobStreams:= TList.Create;
  FSourceLink := TFIBDataLink.Create(Self);
  FQDelete  := CreateInternalQuery('DeleteQuery' );
  FQInsert  := CreateInternalQuery('InsertQuery' );
  FQRefresh := CreateInternalQuery('RefreshQuery');
  FQUpdate  := CreateInternalQuery('UpdateQuery' );
  FQSelect  := CreateInternalQuery('SelectQuery' );
  FQCurrentSelect:=FQSelect;
//  FQSelect.OnSQLFetch    :=DoOnSelectFetch;
  FRefreshTransactionKind:=tkReadTransaction;
  FUpdateRecordTypes := [cusUnmodified, cusModified, cusInserted];
  vDisableScrollCount:=0;
  BookmarkSize:=SizeOf(TFIBBookmark);
  FFieldOriginRule:=forTableAndFieldName;
  (* Events... *)
  with FBase do
  begin
    OnDatabaseDisconnecting := DoDatabaseDisconnecting;
    OnDatabaseDisconnected  := DoDatabaseDisconnected;
    OnDatabaseFree          := DoDatabaseFree;
    OnTransactionEnding     := DoTransactionEnding;
    OnTransactionEnded      := DoTransactionEnded;
    OnTransactionFree       := DoTransactionFree;
  end;
 
  if (csDesigning in ComponentState)   and not(CmpInLoadedState(Self))
  then
  begin
    FOptions:=DefaultOptions;
    FDetailConditions:=DefaultDetailConditions;
    FPrepareOptions  :=DefaultPrepareOptions;
  end
  else
  begin
   FOptions:=StatDefDataSetOptions;
   FDetailConditions:=[];
   FPrepareOptions    :=  StatDefPrepareOptions;
//    [pfImportDefaultValues,psGetOrderInfo,psUseBooleanField,psSetEmptyStrToNull];
  end;
  vTypeDispositionField:=dfNormal;
  FSortFields    :=null;
  vIgnoreLocReno :=-1;
  vTimerForDetail:=nil;
  vScrollTimer   :=nil;
  FRelationTables:=TStringList.Create;
  with FRelationTables do
  begin
    Sorted:=True;
    Duplicates:=dupIgnore;
  end;

  if (csDesigning in ComponentState) and not CmpInLoadedState(Self)
  then
   DataBase:=DefDataBase;
  FAutoCommit :=False;
  FWaitEndMasterInterval:=300;
  vControlsEnabled:=True;
  FCountUpdatesPending :=0;
  vFieldDescrList:=TFIBFieldDescrList.Create;
 {$IFNDEF NO_GUI}
  FSQLScreenCursor:=crDefault;
 {$ENDIF}
  FSQLs :=TSQLs.Create(Self);


  if AOwner is TFIBDatabase then
    Database := TFIBDatabase(AOwner)
  else
    if AOwner is TFIBTransaction then
      Transaction := TFIBTransaction(AOwner);
  FAutoUpdateOptions := TAutoUpdateOptions.Create(Self);
  FFNFields := TStringList.Create;
  with FFNFields do
  begin
    Sorted := True;
    Duplicates := dupIgnore;
  end;
  FCacheModelOptions:=TCacheModelOptions.Create(Self);
  FAllowedUpdateKinds := [ukModify, ukInsert, ukDelete];
 
  FFilteredCacheInfo.NonVisibleRecords := TSortedList.Create;
  FFilteredCacheInfo.AllRecords := -1;
  vBeforeCloseEvents := TNotifyEventList.Create(Self);

end;
 
destructor TFIBCustomDataSet.Destroy;
begin
  inherited Destroy;
 
{$IFDEF CSMonitor}
  FCSMonitorSupport.Free;
{$ENDIF}

  FSourceLink.Free;
  FBase.Free;
  ClearBlobStreamList;
  FBlobStreamList.Free;
  FOpenedBlobStreams.Free;
  FRelationTables.Free;
  vFieldDescrList.Free;
  FSQLs.Free;
  FFilterParser.Free;
  FFilterParser:=nil;
  FRecordsCache.Free;
  FRecordsCache:=nil;
  FAutoUpdateOptions.Free;
  FFNFields.Free;
  FFNFields:=nil;
  if Assigned(FKeyFieldsForBookMark) then
   FKeyFieldsForBookMark.Free;
 
 FCacheModelOptions.Free;
 FreeMem(vPartition);
 FFilteredCacheInfo.NonVisibleRecords.Free;
end;
 
 
 
 
procedure   TFIBCustomDataSet.Loaded;
begin
 if  csDesigning in ComponentState then
  Include(FRunState,drsInLoaded);
 try
  inherited
 finally
  Exclude(FRunState,drsInLoaded);
 end
end;
 
procedure TFIBCustomDataSet.CreateDetailTimer;
begin
  if not Assigned(vTimerForDetail) then
  begin
    vTimerForDetail:=TFIBTimer.Create(Self);
    with vTimerForDetail do
    begin
      Interval:=0;
      Enabled:=False;
      OnTimer:=OpenByTimer;
    end;
  end;
end;

procedure TFIBCustomDataSet.CreateScrollTimer;
begin
  if not Assigned(vScrollTimer) then
  begin
    vScrollTimer:=TFIBTimer.Create(Self);
    with vScrollTimer do
    begin
      Interval:=0;
      Enabled:=False;
      OnTimer:=DoOnEndScroll;
    end;
  end;
end;
 
procedure  TFIBCustomDataSet.CheckUpdateTransaction;
begin
  if UpdateTransaction = nil then
    FIBError(feTransactionNotAssigned, [CmpFullName(TComponent(Self.Owner))]) ;
  UpdateTransaction.CheckInTransaction;
end;


function TFIBCustomDataSet.FN(const FieldName: string): TField; //FindField
var
  i: integer;
  fname: string;
begin
  if FFNFields.Find(FieldName, i) then
    Result := TField(FFNFields.Objects[i])
  else
  begin
    if (Length(FieldName) > 0) and (FieldName[1] = '"') then
      fname := FastCopy(FieldName, 2, Length(FieldName) - 2)
    else
      fname := FieldName;
    Result := FindField(fname);
    if Assigned(Result) then
      FFNFields.AddObject(FieldName, Result)
  end;
end;
 
function TFIBCustomDataSet.FBN(const FieldName: string): TField; //FieldByName
begin
  Result := FN(FieldName);
  if Result = nil then
    DatabaseErrorFmt(SFieldNotFound, [FieldName], Self);
end;

function  TFIBCustomDataSet.GetCacheSize:integer;
begin
 Result:= FRecordsCache.Size
end;
 
function  TFIBCustomDataSet.GetConditions:TConditions;
begin
 Result:=QSelect.Conditions
end;

procedure TFIBCustomDataSet.SetConditions(Value:TConditions);
begin
 QSelect.Conditions:=Value                          
end;

procedure TFIBCustomDataSet.ApplyConditions(Reopen :boolean = False);
begin
 Close;
 QSelect.Conditions.Apply;
 if Reopen then  Open 
end;

procedure TFIBCustomDataSet.CancelConditions;
begin
 Close;
 QSelect.Conditions.CancelApply;
end;


function  TFIBCustomDataSet.GetOrderString:string;
begin
 Result:=FQSelect.OrderClause
end;
 
procedure TFIBCustomDataSet.SetOrderString(const OrderTxt:string);
begin
 FQSelect.OrderClause:=OrderTxt
end;
 

function  TFIBCustomDataSet.GetFieldsString:string;
begin
 Result:=FQSelect.FieldsClause
end;
 
procedure TFIBCustomDataSet.SetFieldsString(const Value:string);
begin
 FQSelect.FieldsClause:=Value
end;

procedure TFIBCustomDataSet.Resync(Mode: TResyncMode);
begin
 if not Active  then
  Exit;   
 if  drsInGotoBookMark in FRunState then
 try
  Exclude(FRunState,drsInGotoBookMark);
  if vLockResync>0  then
   Dec(vLockResync)
  else
   inherited Resync([])
 finally
  EnableControls;
  EnableScrollEvents;
 end
 else
  if vLockResync=0  then
   inherited Resync(Mode)
end;


function  TFIBCustomDataSet.BookmarkValid(Bookmark: TBookmark): Boolean;
begin
  if Assigned(Bookmark) then
   case FCacheModelOptions.FCacheModelKind of
    cmkStandard:Result := FRecordsCache.BookMarkValid(PFIBBookmark(Bookmark)^.bRecordNumber)
   else
    Result := True; 
   end
  else
   Result := False;
end;
 
procedure TFIBCustomDataSet.Post;
begin
   try
    inherited Post;
   finally
    vLockResync:=0
   end
end;
 
 
procedure TFIBCustomDataSet.PrepareAdditionalSelects;
const
  sign:array [boolean] of char = ('<','>');
  sign1:array [boolean] of char = ('=',' ');
var 
  i: integer;
  vInvertedOrder :string;
  vPartWhere    :string;
  vPartWhereDesc:string;
  sc:integer;
  tf:TField;
  fn:string;
  vLocateWhere:string;
  vSQL:string;
  EquelCondition:string;
  ParName:string;
begin
  vPartWhere    :='';
  vPartWhereDesc:='';

  sc:=SortFieldsCount;
  if sc=0 then
    FIBErrorEx('%s:Can''t find or parse ORDER BY statement.',[CmpFullName(Self)]);

  EquelCondition:='';

  vSQL:=ReadySelectText;
  for i :=sc downto 1 do
  with SortFieldInfo(i) do
  begin
    tf:=FindField(FieldName);
    if Assigned(tf) then
    begin
      fn:=FieldNameForSQL(TableAliasForField(FieldName),GetRelationFieldName(tf));
      ParName:=FormatIdentifier(3,'NEW_'+FieldName);
 
      if i<sc then
      begin
       EquelCondition:=' and ('+fn+'=?'+ParName+')';
       vPartWhere    :='(('+vPartWhere+EquelCondition+') or ('+fn+sign[Asc]+'?'+ParName+'))';
       vPartWhereDesc:='(('+vPartWhereDesc+EquelCondition+') or ('+fn+sign[ not Asc]+'?'+ParName+'))';
      end
      else
      begin
       vPartWhere:= '('+fn+sign[Asc]+'?'+ParName+')';
       vPartWhereDesc:='('+fn+sign[not Asc]+'?'+ParName+')';
      end;
    end;
  end;
  vInvertedOrder:=InvertOrderClause(OrderClause);
  vSQL:=FQSelect.SQL.Text;
  if not Assigned(FQSelectDesc) then
   FQSelectDesc:=CreateInternalQuery('SelectDescQuery');
  with FQSelectDesc do
  begin
         Close;
         BeginModifySQLText;
         SQL.Text:=vSQL;
         OrderClause:=vInvertedOrder;
         Database   :=Self.Database;
         Transaction:=Self.Transaction;
         PlanClause :=FCacheModelOptions.FPlanForDescSQLs;
         EndModifySQLText;
  end;

  if not Assigned(FQSelectPart) then
   FQSelectPart:=CreateInternalQuery('SelectPartQuery');
  with FQSelectPart do
  begin
    Close;
    Database   :=Self.Database;
    Transaction:=Self.Transaction;
    SQL.Text   :=AddToWhereClause(vSQL,vPartWhere);
  end;
 
  if not Assigned(FQSelectDescPart) then
   FQSelectDescPart:=CreateInternalQuery('SelectPartDescQuery');
  with FQSelectDescPart do
  begin
    Close;
    Database   :=Self.Database;
    Transaction:=Self.Transaction;
    BeginModifySQLText;
    SQL.Text   :=
     AddToWhereClause(vSQL,vPartWhereDesc);
    PlanClause :=FCacheModelOptions.FPlanForDescSQLs;
    OrderClause:=vInvertedOrder;
    EndModifySQLText;
  end;
 
  vLocateWhere  :='';
  for i:= 0 to Pred(FKeyFieldsForBookMark.Count) do
  begin
    tf:=FindField(FKeyFieldsForBookMark.Strings[i]);
    if Assigned(tf) then
    begin
      fn:=
       FieldNameForSQL(TableAliasForField(tf.FieldName),GetRelationFieldName(tf));          
      if i>0 then
       vLocateWhere:=vLocateWhere +' and ';
      vLocateWhere:=
       vLocateWhere+'('+fn+'=?'+FormatIdentifier(3,LocateParamPrefix+tf.FieldName)+')';
    end;
  end;

  if not Assigned(FQBookMark) then
    FQBookMark:=CreateInternalQuery('SelectLocate');
  with FQBookMark do
  begin
    Close;
    Database   :=Self.Database;
    Transaction:=Self.Transaction;
    SQL.Text   :=
     AddToWhereClause(vSQL,vLocateWhere);
  end;
end;
 
function  TFIBCustomDataSet.CanHaveLimitedCache:boolean;
var
   i:  integer;
   pc:integer;
begin
  Result:= not CachedUpdates and (OrderClause<>'')
   and (AutoCommit or (UpdateTransaction=Transaction));
 
  if Result then
  begin
   pc:=Pred(ParamCount);
   for i:=0 to pc do
   if IsNewParamName(Params[i].Name) then
   begin
    Result := False;
    Exit;
   end;
  end;
end;
 


procedure TFIBCustomDataSet.SetCacheModelOptions(aCacheModelOptions:TCacheModelOptions);
begin
  FCacheModelOptions.Assign(aCacheModelOptions);
end;
 
function  TFIBCustomDataSet.GetBufferChunks:Integer;
begin
  Result:=FCacheModelOptions.FBufferChunks
end;

procedure TFIBCustomDataSet.SetBufferChunks(Value:integer);
begin
  FCacheModelOptions.BufferChunks:=Value
end;

function TFIBCustomDataSet.StoreUpdTransaction: Boolean;
begin
 Result:=(FQDelete.Transaction<>FQSelect.Transaction)
  or (csAncestor in ComponentState)
end;

procedure TFIBCustomDataSet.SetUpdateTransaction(Value:TFIBTransaction);
begin
  if FRefreshTransactionKind=tkUpdateTransaction then
     FQRefresh.Transaction:= Value;
  if Assigned(FQDelete.Transaction) then
  with FQDelete.Transaction do
  begin
   RemoveEvent(DoBeforeStartUpdateTransaction,tetBeforeStartTransaction);
   RemoveEvent(DoAfterStartUpdateTransaction ,tetAfterStartTransaction);
   RemoveEndEvent(DoBeforeEndUpdateTransaction,tetBeforeEndTransaction);
   RemoveEndEvent(DoAfterEndUpdateTransaction ,tetAfterEndTransaction);
  end;
  FQDelete.Transaction := Value;
  FQInsert.Transaction := Value;
  FQUpdate.Transaction := Value;
  if Assigned(Value) then
  begin
   Value.AddEvent(DoBeforeStartUpdateTransaction,tetBeforeStartTransaction);
   Value.AddEvent(DoAfterStartUpdateTransaction ,tetAfterStartTransaction);
   Value.AddEndEvent(DoBeforeEndUpdateTransaction,tetBeforeEndTransaction);
   Value.AddEndEvent(DoAfterEndUpdateTransaction ,tetAfterEndTransaction);
  end;
end;

function TFIBCustomDataSet.GetUpdateTransaction: TFIBTransaction;
begin
  Result:=FQUpdate.Transaction
end;


procedure   TFIBCustomDataSet.ReopenLocate(const LocateFieldNames:string);
var NeedKeepCurrent:boolean;
    LocateFields:string;
    NewValues   :array of variant;
    i,j,r :integer;
    OldActiveRecord:integer;
begin
  CheckNotUniDirectional;
  if FRecordCount>0 then
   NeedKeepCurrent:=(LocateFieldNames<>'')
     or (not EmptyStrings(QRefresh.SQL) and InternalRefreshRow(QRefresh,GetActiveBuf))
  else
   NeedKeepCurrent:=False;
  r:=GetRecno;
  OldActiveRecord:=ActiveRecord;
  if NeedKeepCurrent then
  begin
    LocateFields:=LocateFieldNames;
    SetLength(NewValues,0);
    j:=0;
    if LocateFields='' then
    begin
      for i:=0 to Pred(FieldCount) do
      if (Fields[i].FieldKind=fkData) and not (Fields[i].IsBlob)
       {$IFDEF SUPPORT_ARRAY_FIELD}
        and not (Fields[i] is TFIBArrayField)
       {$ENDIF}
      then
      begin
        if j>0 then LocateFields:=LocateFields+';';
        LocateFields:=LocateFields+Fields[i].FieldName;
        SetLength(NewValues,j+1);
        NewValues[j]:=Fields[i].Value;
        Inc(j);
      end;
      NeedKeepCurrent:=LocateFields<>''  ;
    end
    else
    begin
      repeat
        i := PosCh(';', LocateFields);
        SetLength(NewValues,j+1);
        if i = 0 then
         NewValues[j]  := FBN(LocateFields).Value
        else
        begin
          NewValues[j] := FBN(FastCopy(LocateFields, 1, i - 1)).Value;
          LocateFields := FastCopy(LocateFields,i+1,MaxInt);
//          System.Delete(LocateFields, 1, i);
        end;
        Inc(j);
      until i = 0;
      LocateFields:=LocateFieldNames;
    end;
  end;
  DisableControls;
  DisableScrollEvents;
  try
   CloseOpen(False);
   if NeedKeepCurrent then
   begin                          
    if FRecordCount<r then FetchNext(r-FRecordCount);
    if InternalLocate(LocateFields,NewValues,[],True) then
    begin
     SetRecordPosInBuffer(OldActiveRecord);
    end;
   end;
  finally
   EnableControls;
   EnableScrollEvents;
   {$IFNDEF D6+}
    DataEvent(deDataSetChange,0);
   {$ENDIF}
  end;
end;

procedure   TFIBCustomDataSet.FullRefresh;
begin
 InternalFullRefresh
end;

procedure   TFIBCustomDataSet.InternalFullRefresh(NeedResync:boolean = True;ReopenRefreshSQL:boolean=True);
var 
   R,R1:  integer;
begin
  case FCacheModelOptions.CacheModelKind of
   cmkStandard:
    ReopenLocate('');
   cmkLimitedBufferSize :
    if Active then
    begin
      DoBeforeRefresh;
      R :=GetRealRecNo;
      R1:=R mod FCacheModelOptions.FBufferChunks;
      if R1=0 then
       R1:=FCacheModelOptions.FBufferChunks;
      FRecordsCache.SaveOldBuffer(R1);
      AssignSQLObjectParams(QRefresh,[Self]);
      RefreshAround(QRefresh,R ,False,ReopenRefreshSQL);
      ClearBlobStreamList;
      if NeedResync then
       Resync([]);
      DoAfterRefresh;
    end
    else
     Open;
  end;
end;
 
{$WARNINGS OFF}
function  TFIBCustomDataSet.FetchNext(FetchCount:Dword):integer;
var
  Buffer:  dbPChar;
  iCurScreenState: Integer;
begin
 Result:=0;
 if AllFetched then Exit;
 Buffer := AllocRecordBuffer;
 ChangeScreenCursor(iCurScreenState);
 try
   while (Result<FetchCount) and (FQSelect.Next <> nil) do
   begin
    FetchRecordToCache(FQSelect,FRecordCount);
    Inc(FRecordCount); Inc(Result)
   end;
{ except
 end;}
 finally
  RestoreScreenCursor(iCurScreenState);
  FreeRecordBuffer(Buffer);
 end 
end;
//{$WARNINGS ON}
 
//// PrepareOptions Stream

{$DEFINE FIB_IMPLEMENT}
 {$I FIBDataSetPT.inc}
{$UNDEF FIB_IMPLEMENT}

function TFIBCustomDataSet.GetXSQLVAR(Fld:TField):TXSQLVAR;
begin
  if (Fld=nil) or (Fld.FieldKind <>fkData) then
  begin
   FillChar(Result,SizeOf(Result),0);
   Result.sqltype:=-1;
   Exit;
  end;
  if FieldDefs.Count=0 then
   FieldDefs.Update;
  if not QSelect.Prepared then
   QSelect.Prepare;
  if not Active and (Fld.FieldNo=0) then
   BindFields(True);
  Result:=QSelect.Current[Fld.FieldNo-1].Data^
end;

function  TFIBCustomDataSet.GetFieldScale(Fld:TNumericField):Short;
begin
 Result:=100;
 if (Fld=nil) or (Fld.FieldKind <>fkData) then exit; 
 with GetXSQLVAR(Fld) do
   if sqltype<>-1 then Result:=sqlscale
end;
 
function  TFIBCustomDataSet.GetRelationTableName(Field:TObject):string;
begin
  Result:='';
  if (Field=nil) then Exit;
  if Field is TField  then
  begin
    case TField(Field).FieldKind of
     fkData:
      with GetXSQLVAR(TField(Field)) do
      begin
        if sqltype<>-1 then
         SetString(Result, relname, relname_length)
      end;
     fkCalculated:
      Result:='CALCULATED';
     fkLookup    :
      if TField(Field).LookupDataSet is TFIBCustomDataSet then
       with TFIBCustomDataSet(TField(Field).LookupDataSet)  do
        Result:=GetRelationTableName(FindField(TField(Field).LookupResultField))
    end;
  end
  else
   if Field is TFieldDef  then
   begin
    with QSelect.Current[TFieldDef(Field).FieldNo-1].Data^ do
    begin
      if sqltype<>-1 then
       SetString(Result, relname, relname_length)
    end;
   end;
end;
 
function  TFIBCustomDataSet.GetRelationFieldName(Field:TObject):string;
begin
  Result:='';
  if (Field=nil) then Exit;
  if Field is TField then
  begin
    case TField(Field).FieldKind of
     fkData:
      with GetXSQLVAR(TField(Field)) do
      begin
        if sqltype<>-1 then
         SetString(Result, sqlname, sqlname_length);
      end;
     fkCalculated:
      Result:=TField(Field).FieldName;
     fkLookup    :
      if TField(Field).LookupDataSet is TFIBCustomDataSet then
       with TFIBCustomDataSet(TField(Field).LookupDataSet)  do
        Result:=GetRelationFieldName(FindField(TField(Field).LookupResultField))
    end;
  end
  else
   if Field is TFieldDef  then
   begin
    with QSelect.Current[TFieldDef(Field).FieldNo-1].Data^ do
    begin
      if sqltype<>-1 then
       SetString(Result, sqlname, sqlname_length)
    end;
   end;
  if Result='DB_KEY' then
     Result:='RDB$DB_KEY'
end;                                               

 



function TFIBCustomDataSet.AdjustCurrentRecord(Buffer: Pointer;
  GetMode: TGetMode): TGetResult;
begin
  (*
   * Skip over all invisible records.
   *)
  if FCacheModelOptions.CacheModelKind=cmkLimitedBufferSize then
  begin
    Result:=grOk;
    Exit;
  end;

  if Assigned(Buffer)  then
  while not IsVisible(Buffer) do
  begin
    if GetMode = gmPrior then
    begin
      if FCurrentRecord>=0 then
       Dec(FCurrentRecord);
      if FCurrentRecord = -1 then
      begin
        Result := grBOF;
        Exit;
      end;
      ReadRecordCache(FCurrentRecord, Buffer, False);
    end
    else
    begin
      Inc(FCurrentRecord);
      if (FCurrentRecord = FRecordCount) then
      begin
        if (not FQSelect.Eof) and (FQSelect.Next <> nil) then
        begin
          FetchCurrentRecordToBuffer(FQSelect, FCurrentRecord, Buffer);
          Inc(FRecordCount);
        end
        else
        begin
          Result := grEOF;
          Exit;
        end;
      end
      else
        ReadRecordCache(FCurrentRecord, Buffer, False);
    end;
  end;
  Result := grOK;
end;

function  TFIBCustomDataSet.GetAllFetched:boolean;
begin
 Result:=QSelect.Eof
end;
 
 
 
procedure TFIBCustomDataSet.BatchInput(InputObject: TFIBBatchInputStream;SQLKind:TpSQLKind);
begin
  case SQLKind of
   skInsert:  FQInsert.BatchInput(InputObject);
   skModify:  FQUpdate.BatchInput(InputObject);
   FIBDataSet.skDelete:  FQDelete.BatchInput(InputObject);
   skRefresh          :  FQRefresh.BatchInput(InputObject);
  else
   FQInsert.BatchInput(InputObject);
  end;
end;
 
procedure TFIBCustomDataSet.BatchOutput(OutputObject: TFIBBatchOutputStream);
var 
  Qry: TFIBQuery;
  i  : integer;
begin
  Qry := TFIBQuery.Create(Self);
{$IFDEF CSMonitor}
  Qry.CSMonitorSupport.Enabled := FCSMonitorSupport.Enabled;
  Qry.CSMonitorSupport.IncludeDatasetDescription :=
    FCSMonitorSupport.IncludeDatasetDescription;
{$ENDIF}  
  with Qry do
  try
     Database    := FBase.Database;
     Transaction := FBase.Transaction;
     SQL.Assign(FQSelect.SQL);
     Prepare;
     for i:=0 to Pred(Params.Count) do
      Params[i].Assign(Self.Params[i]);
     BatchOutput(OutputObject);
  finally
     Free;
  end;
end;
 
procedure TFIBCustomDataSet.CancelUpdates;
var i:integer;
begin
 DisableControls;
 try
   if State in [dsEdit, dsInsert] then
    Cancel;
   if not FUpdatesPending or not FCachedUpdates then
    Exit;
   for i:=0 to Pred(FRecordCount) do
    InternalRevertRecord(i,False);
   FCountUpdatesPending:=0;
   FUpdatesPending:=False;
   RefreshFilters;
   if Assigned(FRecordsCache) then
    FRecordsCache.ClearLog;
 finally
  EnableControls;
 end;
end;

procedure TFIBCustomDataSet.CheckDatasetClosed(const Reason:string);
begin
  if FOpen then
    FIBError(feDataSetOpen,[Reason,CmpFullName(Self)]);
end;
 
procedure TFIBCustomDataSet.CheckDatasetOpen(const Reason:string);
begin
 if State = dsInactive then
  FIBError(feDataSetClosed,[Reason,CmpFullName(Self)]);
end;                                                     

procedure TFIBCustomDataSet.CheckNotUniDirectional;
begin
  if UniDirectional then
    FIBError(feDataSetUniDirectional, [CmpFullName(Self)]);
end;
 
function TFIBCustomDataSet.CanEdit: Boolean;
var 
  Buff: PRecordData;
begin
  Buff := PRecordData(GetActiveBuf);
  Result := (not EmptyStrings(FQUpdate.SQL)) or
            ((Buff <> nil) and (TCachedUpdateStatus(Buff^.rdFlags) = cusInserted) and
             FCachedUpdates);
end;
 
function TFIBCustomDataSet.CanInsert: Boolean;
begin
  Result := not EmptyStrings(FQInsert.SQL);
end;
 
function TFIBCustomDataSet.CanDelete: Boolean;
begin
  Result := not EmptyStrings(FQDelete.SQL)
end;
 
procedure TFIBCustomDataSet.CheckFieldCompatibility(Field: TField; FieldDef: TFieldDef);
begin
  with Field do
  case DataType of
    ftDate, ftTime, ftDateTime:
     if DataType<>FieldDef.DataType then
      DatabaseErrorFmt(SFieldTypeMismatch,
       [DisplayName, FieldTypeNames[DataType], FieldTypeNames[FieldDef.DataType]], Self
      );
  else
   inherited  CheckFieldCompatibility(Field,FieldDef);
  end;
end;
 
procedure TFIBCustomDataSet.CheckInactive;
begin
 if not (drsDontCheckInactive in FRunState) then
  inherited CheckInactive;
end;

procedure TFIBCustomDataSet.CheckEditState;
var 
 RState: TDataSetState;
begin
  CheckActive;
  if State in [dsNewValue,dsOldValue] then
   RState:=vPredState
  else
   RState:=State;
  case RState of
    dsEdit:
     if not CanEdit then  FIBError(feCannotUpdate, [CmpFullName(Self)]);
    dsInsert:
    if not CanInsert then
     FIBError(feCannotInsert, [CmpFullName(Self)]);
    else
     FIBError(feNotInEditState,[CmpFullName(Self)])
  end;
end;

 
procedure TFIBCustomDataSet.ClearBlobStreamList;
var 
  i:  Integer;
begin
 if Assigned(FBlobStreamList) then
  for i :=FBlobStreamList.Count - 1  downto 0 do
   TFIBBlobStream(FBlobStreamList[i]).Free;
end;

function  TFIBCustomDataSet.CompareFieldValues(Field:TField;const S1,S2:variant):integer;
begin
// For Sort Ansistring fields
 if Assigned(FOnCompareFieldValues) then
  Result:=FOnCompareFieldValues(Field,S1,S2)
 else
  Result:=StdCompareValues(S1, S2);
end;

function TFIBCustomDataSet.StdCompareValues(const S1, S2: variant): Integer;
begin
  if VarIsNull(s1) then
  begin
       if VarIsNull(s2) then
        Result:=0
       else
        Result:=-1;
  end
  else
  begin
   if VarIsNull(s2) then
    Result:=1
   else
   begin
    Result:=CompareVariants(S1,S2);
   end;
  end;
end;
 
function TFIBCustomDataSet.StdAnsiCompareString(Field:TField;const S1, S2: variant): Integer;
begin
  if VarIsNull(s1) or VarIsNull(s2) then
    Result:=StdCompareValues(S1, S2)
  else
  if Field.DataType in [ftString,ftFixedChar] then
    Result:=AnsiCompareStr(S1,S2)
  else
   Result:=StdCompareValues(S1, S2);
end;
 
function TFIBCustomDataSet.AnsiCompareString(Field:TField;const val1, val2: variant): Integer;
var
   I,L1,L2: integer;
   up1,up2:boolean;
   S1,S2:string;
begin
 if Field.DataType in [ftString,ftFixedChar] then
 begin
  S1:=val1;
  S2:=val2;
  L1:=Length(S1);
  L2:=Length(S2);
  if L1>L2 then
  begin
   L1:=L2;
   Result:=1
  end
  else
  if L1<L2 then
   Result:=-1
  else
   Result:= 0;
  for i:=1 to L1 do
   if (S1[i]<>S2[i]) then
   begin
     up1:=S1[i]=AnsiUpperCase(S1[i]);
     up2:=S2[i]=AnsiUpperCase(S2[i]);
     if up1 then
     begin
       if up2 then
        Result:=AnsiCompareStr(s1[i],s2[i])
       else
        Result:=-1
     end
     else
     begin
       if up2 then
        Result:=1
       else
        Result:=AnsiCompareStr(s1[i],s2[i])
     end;
    Exit;
   end;
  end
  else
   Result:=StdCompareValues(S1, S2);
end;
 
procedure TFIBCustomDataSet.CopyRecordBuffer(Source, Dest: Pointer);
begin
  if Assigned(Source) and Assigned(Dest) then
   Move(Source^, Dest^, FRecordBufferSize);
end;
 
procedure TFIBCustomDataSet.DoDatabaseDisconnecting(Sender: TObject);
begin
  if Active then
  begin
    if FCachedUpdates then
      FetchAll
    else
      Active := False;
  end;
  FPrepared := False;
  if Assigned(FDatabaseDisconnecting) then
    FDatabaseDisconnecting(Sender);
end;

procedure TFIBCustomDataSet.DoDatabaseDisconnected(Sender: TObject);
begin
  if Assigned(FDatabaseDisconnected) then
    FDatabaseDisconnected(Sender);
end;

procedure TFIBCustomDataSet.DoDatabaseFree(Sender: TObject);
begin
  if Assigned(FDatabaseFree) then
    FDatabaseFree(Sender);
end;
 
procedure TFIBCustomDataSet.DoTransactionEnding(Sender: TObject);
begin
  if Assigned(FTransactionEnding) then   FTransactionEnding(Sender);
  if Transaction.State in [tsDoRollback,tsDoCommit] then
  if Active then
  begin
    if (FCachedUpdates)  and not (csDestroying in ComponentState)  and
     not (csDesigning in ComponentState)
    then
    begin
      FetchAll;
      if QSelect.Open then
       QSelect.Close;
    end
    else
      Active := False;
  end;
end;
 
procedure TFIBCustomDataSet.DoTransactionEnded(Sender: TObject);
begin
  if Assigned(FTransactionEnded) then
    FTransactionEnded(Sender);
end;

procedure TFIBCustomDataSet.DoTransactionFree(Sender: TObject);
begin
  if Assigned(FTransactionFree) then
    FTransactionFree(Sender);
end;



(* Read the record from FQSelect.Current into cache (temporary file) *)
 
const
  IBBuffDateDelta=678576;
  FMSecsPerDay: Single = MSecsPerDay;
 
type
 TFriendBlobStream=class(TFIBBlobStream);
 PTimeStamp=^TTimeStamp;
 
procedure TFIBCustomDataSet.FetchRecordToCache(Qry: TFIBQuery; RecordNumber: Integer);
var
  p:  PSavedRecordData;
  pbd: PBlobDataArray;
  i, j,c: Integer;
  LocalData: PAnsiChar;
  StopFetching:boolean;
  qda:TFIBXSQLDA;
  vvFieldLength :integer;
  fi:PFIBFieldDescr;
  Buffer:dbPChar;
  curVar:TFIBXSQLVAR;
begin
  StopFetching:=False;
  if FUniDirectional  or (FCacheModelOptions.CacheModelKind=cmkLimitedBufferSize)  then
    RecordNumber := RecordNumber mod FCacheModelOptions.FBufferChunks;
  Buffer:=FRecordsCache.PrepareMemory(RecordNumber+1);
  p     := PSavedRecordData(Buffer);
  qda   :=Qry.Current;
  (* Make sure blob cache is empty *)
  pbd := PBlobDataArray(Buffer + FBlobCacheOffset);
  if not (drsInRefreshRow in FRunState) then
  for i := 0 to BlobFieldCount - 1 do
  begin
     if pbd^[i] <>nil then
      begin
        if (pbd^[i].IndexInList>=0) and (pbd^[i].IndexInList<FBlobStreamList.Count) then
         if (pbd^[i]=FBlobStreamList[pbd^[i].IndexInList]) then
            pbd^[i].Free;
        pbd^[i] := nil
      end
  end;
 
  (* Get record information *)
  p^.rdFlags:=Byte(cusUnmodified);
  (* Load up the fields *)
  c:=qda.Count - 1;

  for i := 0 to c do
  begin
    curVar:=qda[i];
    if (Qry = FQSelect) then
      j := i + 1
    else
      j := FQSelect.FieldIndex[curVar.Name] + 1;
    if j > 0 then
    with p^,p^.rdFields[j] do
    begin
     fi:=vFieldDescrList.List.List[j-1];
     with curVar.Data^ do
      fdIsNull := (fi^.fdNullable and (sqlind<>nil) and (sqlind^ = -1)) ;

     if fdIsNull then
     begin
       case fi^.fdDataType of
        SQL_VARYING,SQL_TEXT:
        begin
         if fi^.fdIsSeparateString  then
         begin
          FRecordsCache.SetStringValue(fi^.fdStrIndex,RecordNumber, '');
         end;
         Continue;
        end;
        SQL_BLOB,SQL_ARRAY: ;
       else // case
        Continue;
       end;
     end;

      LocalData := curVar.Data^.sqldata;
      case fi^.fdDataType of
        SQL_TIMESTAMP:
        with PISC_QUAD(LocalData)^ do
        begin
         PTimeStamp(@Buffer[fi^.fdDataOfs-DiffSizesRecData])^.Date:=gds_quad_high + IBBuffDateDelta;
         PTimeStamp(@Buffer[fi^.fdDataOfs-DiffSizesRecData])^.Time:=gds_quad_low div 10;
          PDouble(@Buffer[fi^.fdDataOfs-DiffSizesRecData])^:=
            (gds_quad_high + IBBuffDateDelta)*FMSecsPerDay+(gds_quad_low div 10);
        end;
        SQL_TYPE_DATE:
        begin
          PInteger(@Buffer[fi^.fdDataOfs-DiffSizesRecData])^:=
           PISC_DATE(LocalData)^ + IBBuffDateDelta;
        end;
        SQL_TYPE_TIME:
        begin
          PInteger(@Buffer[fi^.fdDataOfs-DiffSizesRecData])^:=
            PISC_TIME(LocalData)^ div 10;
        end;
        SQL_INT64:
        if (fi^.fdDataScale < -4) and not (psSQLINT64ToBCD in PrepareOptions) then
        begin
          PDouble(@Buffer[fi^.fdDataOfs-DiffSizesRecData])^:=curVar.AsDouble;
        end
        else
        begin
          PInt64(@Buffer[fi^.fdDataOfs-DiffSizesRecData])^:=PInt64(LocalData)^
        end;
        SQL_VARYING:
        begin
//          vvFieldLength :=DataBase.ClientLibrary.isc_vax_integer(LocalData, 2);
          vvFieldLength :=PWord(LocalData)^;     // It is isc_vax_integer(LocalData, 2);
          if vvFieldLength=0 then
          begin
            if fi^.fdIsSeparateString then
             FRecordsCache.SetStringValue(fi^.fdStrIndex,RecordNumber, '')
            else
             FillChar(Buffer[fi^.fdDataOfs-DiffSizesRecData],fi^.fdDataSize,0)
          end
          else
          begin
            Inc(PByte(LocalData),2);
            if vvFieldLength<fi^.fdDataSize then PAnsiChar(LocalData)[vvFieldLength]:=#0;
            if fi^.fdIsSeparateString then
             FRecordsCache.SetStringFromPChar(fi^.fdStrIndex,RecordNumber, PAnsiChar(LocalData),
              vvFieldLength,False
             )
            else
             Move(LocalData^, Buffer[fi^.fdDataOfs-DiffSizesRecData],fi^.fdDataSize);
          end;
        end;
        SQL_TEXT:
         if fi^.fdIsSeparateString then
         begin
           FRecordsCache.SetStringFromPChar(fi^.fdStrIndex,RecordNumber, PAnsiChar(LocalData),-1,
            True
           );
         end
         else
         begin
          if not fdIsNull then
           Move(LocalData^, Buffer[fi^.fdDataOfs-DiffSizesRecData],fi^.fdDataSize)
          else
           FillChar(Buffer[fi^.fdDataOfs-DiffSizesRecData],fi^.fdDataSize,0)
         end;
 
      else
      // BLOBS and BOOLEAN
         if fdIsNull  then
          FillChar(LocalData^,fi^.fdDataSize,0) // for Blob only
         else
          Move(LocalData^, Buffer[fi^.fdDataOfs-DiffSizesRecData],fi^.fdDataSize);
      end;
    end;
  end;
//  if (Qry=FQRefresh) then
  if (drsInRefreshRow in FRunState) then
  begin
   for i := 0 to BlobFieldCount - 1 do
    if pbd^[i] <>nil then
    begin
     j:=Qry.FieldIndex[FQSelect.Fields[pbd^[i].FieldNo-1].Name];
     if (j>-1) then
       if (State in [dsEdit,dsInsert]) and (pbd^[i].BlobID.gds_quad_high=0) and
         (pbd^[i].UpdateTransaction=Qry.Transaction)
       then
       begin
         TFriendBlobStream(pbd^[i]).ReplaceBlobID(Qry.Fields[j].AsQuad);
       end
       else
       if not EquelQUADs(Qry.Fields[j].AsQuad,pbd^[i].BlobID) then
       begin
         pbd^[i].Free;
         pbd^[i] := nil;
       end
    end;
  end;
 
  if Assigned(FAfterFetchRecord) then
   FAfterFetchRecord(Qry,RecordNumber,StopFetching);
  if StopFetching then
  begin
   Inc(FRecordCount);
   Abort;
  end;
end;
 
 
procedure TFIBCustomDataSet.InitDataSetSchema;
var
  i, j,c:  Integer;
  rdl: Integer;
  qda:TFIBXSQLDA;

  vvFieldBufSize:integer;
  vvSeparateString:boolean;
  fi:PFIBFieldDescr;
  vvSqlType:integer;
  vvSqlSubType:Short;
  StrIndex :integer;
  atf:TAddedTypeFields;

begin
  rdl         :=RecordDataLength(FQSelect.Current.Count);
  FRecordSize      :=rdl;             // (1)
  FBlockReadSize   :=rdl-DiffSizesRecData;
  FStringFieldCount:=0;
 
  qda:=QSelect.Current;
  (* Load up the fields *)
  c:=qda.Count - 1;
  vFieldDescrList.Capacity:=C+1;
  vrdFieldCount           :=vFieldDescrList.Capacity;

  for i := 0 to c do
  begin
    j := i + 1;
    if j > 0 then
    begin
      with qda[i].Data^ do
      begin
        vvSqlType:=sqltype and (not 1);
        vvSqlSubType:=sqlsubtype;
        vvSeparateString:=False;
        StrIndex:=-1;
        case vvSqltype of
         SQL_FLOAT:
          vvFieldBufSize:= SizeOf(Single);
         SQL_DOUBLE, SQL_D_FLOAT:
          vvFieldBufSize:= SizeOf(Double);
         SQL_SHORT:
         begin
           vvFieldBufSize:=SizeOf(Short)
         end;
         SQL_LONG:
         begin
           vvFieldBufSize:=SizeOf(Integer)
         end;
         SQL_DATE:
           vvFieldBufSize:=SizeOf(TTimeStamp);
         SQL_TYPE_DATE,SQL_TYPE_TIME:
           vvFieldBufSize:=SizeOf(Integer);
        SQL_INT64:
         begin
          if (sqlscale = 0) then
           vvFieldBufSize:= SizeOf(Int64)
          else
          if (sqlscale >=-4) or (psSQLINT64ToBCD in PrepareOptions)  then
           vvFieldBufSize:= SizeOf(Int64)
          else
           vvFieldBufSize:=  SizeOf(Int64);
         end;
         SQL_VARYING,SQL_TEXT:
         begin
          vvFieldBufSize :=sqllen;
          if not Database.NeedUnicodeFieldTranslation(Byte(vvSqlSubType)) and
             (Byte(vvSqlSubType) in Database.UnicodeCharSets)
          then
          if not IsSysField(sqlName) or  not Database.ReturnDeclaredFieldSize then
           vvFieldBufSize :=vvFieldBufSize div  Database.BytesInUnicodeChar(vvSqlSubType);

          if FieldDefs[i].DataType in [ftGuid] then
           vvSeparateString:=False
          else
           vvSeparateString:=(vvFieldBufSize>12) ;
//                   vvSeparateString:=(vvFieldBufSize>1211) ;
//^^^ Nod separate

          if vvSeparateString then
          begin
           StrIndex:=FStringFieldCount;
           Inc(FStringFieldCount);
          end;
         end;
        else
          vvFieldBufSize:=  sqllen;
        end;
        case FieldDefs[i].DataType of
          ftGuid      :  atf:=atfGuidField;
          ftWideString:  atf:=atfWideStringField;
        else
          atf:=atfStandard
        end;
        vFieldDescrList.Add(vvSqltype and (not 1),sqlscale,vvFieldBufSize,
         sqltype and 1 = 1, StringInArray(sqlname,['DB_KEY','RDB$DB_KEY']),
         vvSeparateString,atf
        ) ;
      end;
     fi:=vFieldDescrList[j-1];
     fi^.fdSubType:=vvSqlSubType;
     if fi^.fdIsSeparateString then
        fi^.fdStrIndex:=StrIndex
     else
     begin
      fi^.fdStrIndex:=-1;
      fi^.fdDataOfs := FRecordSize;
      Inc(FRecordSize,vvFieldBufSize);
      Inc(FBlockReadSize,vvFieldBufSize);
     end;
    end;
  end  ;

  FBlobCacheOffset:=FBlockReadSize;
   for i := 0 to c do
    begin
     fi:=vFieldDescrList[i];
     if fi^.fdIsSeparateString then
     begin
        fi^.fdDataOfs := FRecordSize;
//        Inc(FRecordSize,fi^.fdDataSize);
        Inc(FRecordSize,fi^.fdDataSize+SizeOf(Integer));// LengthExp
     end;
    end;
end;



(*
 * Read the record from FQSelect.Current into the cache (temporary file)
 * Then write it to the record buffer.
 *)


procedure TFIBCustomDataSet.FetchCurrentRecordToBuffer(Qry: TFIBQuery;
  RecordNumber: Integer; Buffer: dbPChar
);
begin
  if RecordNumber>-1 then
  begin
    FetchRecordToCache(Qry,RecordNumber);
    ReadRecordCache(RecordNumber, Buffer, False);
  end
  else
    InitDataSetSchema;
end;


function TFIBCustomDataSet.GetActiveBuf: dbPChar;
begin
  case State of
    dsCalcFields: Result := CalcBuffer;
  else
    if not FOpen then
      Result := nil
    else
    if IsEmpty and (State<>dsInsert) then
     Result := nil
    else
     Result := ActiveBuffer;
  end;
end;

function TFIBCustomDataSet.CachedUpdateStatus: TCachedUpdateStatus;
begin
  if Active then
   if GetActiveBuf<>nil then
   Result := TCachedUpdateStatus(PRecordData(GetActiveBuf)^.rdFlags)
   else
    Result := cusUnmodified
  else
    Result := cusUnmodified;
end;

function TFIBCustomDataSet.GetDatabase: TFIBDatabase;
begin
  Result := FBase.Database;
end;

function TFIBCustomDataSet.GetDBHandle: PISC_DB_HANDLE;
begin
  Result := FBase.DBHandle;
end;
 
function TFIBCustomDataSet.GetDeleteSQL: TStrings;
begin
  Result := FQDelete.SQL;
end;
 
function TFIBCustomDataSet.GetInsertSQL: TStrings;
begin
  Result := FQInsert.SQL;
end;
 
function TFIBCustomDataSet.GetParams: TFIBXSQLDA;
begin
  Result := FQSelect.Params;
end;

function TFIBCustomDataSet.GetRefreshSQL: TStrings;
begin
  Result := FQRefresh.SQL;
end;

function TFIBCustomDataSet.GetSelectSQL: TStrings;
begin
  Result := FQSelect.SQL;
end;
 
function TFIBCustomDataSet.GetStatementType: TFIBSQLTypes;
begin
  Result := FQSelect.SQLType;
end;
 
function TFIBCustomDataSet.GetUpdateSQL: TStrings;
begin
  Result := FQUpdate.SQL;
end;
 
function TFIBCustomDataSet.GetTransaction: TFIBTransaction;
begin
  Result := FBase.Transaction;
end;

function TFIBCustomDataSet.GetTRHandle: PISC_TR_HANDLE;
begin
  Result := FBase.TRHandle;
end;
 

procedure TFIBCustomDataSet.InternalDeleteRecord(Qry: TFIBQuery; Buff: Pointer);
var
   vNeedDeleteFromCache: boolean;
begin
  AutoStartUpdateTransaction;
  SetQueryParams(Qry, Buff);
  Qry.ExecQuery;
  if Qry.Open  then
   Qry.Next;
  if poRefreshAfterDelete in Options then
  begin
   vNeedDeleteFromCache:=not InternalRefreshRow(QRefresh,Buff);
  end
  else
   vNeedDeleteFromCache:=True;
 
  with PRecordData(Buff)^ do
  begin
    if vNeedDeleteFromCache then
     rdFlags := Byte(cusDeletedApplied);
    WriteRecordCache(rdRecordNumber, Buff);
  end;
  if not FCachedUpdates then
   AutoCommitUpdateTransaction;
end;
 
 
{$DEFINE FIB_IMPLEMENT}
    {$I FIBDataSetLocate.inc}
{$UNDEF FIB_IMPLEMENT}
// ^^^^InternalLocate implement
 

procedure TFIBCustomDataSet.CheckDataFields(FieldList:TList; const CallerProc:string);
var 
 i:  integer;
begin
  if FieldList.Count=0 then
    FIBError(feFieldListEmpty,[CmpFullName(Self)+'.'+CallerProc])
  else
  for i := 0 to FieldList.Count - 1 do
  begin
    if TField(FieldList[i]).FieldKind<>fkData then
     FIBError(feCantUseField,[CmpFullName(Self)+'.'+CallerProc,TField(FieldList[i]).FieldName])
  end;
end;

function  TFIBCustomDataSet.InternalLocateForLimCache(
     const KeyFields: string; const KeyValues:array of Variant;
      Options: TExtLocateOptions ; LocateKind:TLocateKind = lkStandard;aQLocate:TFIBQuery=nil
     ): Boolean;
var
  fl:  TList;
  vQLocate:TFIBQuery;
  vLocateWhere:string;
  fn,ParName :string;
  i:integer;
  R:integer;
begin
  fl := TList.Create;
  DisableControls;
  DisableScrollEvents;
  if aQLocate=nil then
   vQLocate:=CreateInternalQuery('QLocate')
  else
   vQLocate:=aQLocate;
  try
    GetFieldList(fl, KeyFields);
    CheckDataFields(fl,'LocateForPartialCache');
    vQLocate.Database:=Database;
    vQLocate.Transaction:=Transaction;
    vLocateWhere:='';
    for i:= 0 to Pred(fl.Count) do
    begin
      fn:=
       FieldNameForSQL(TableAliasForField(TField(fl.List^[i]).FieldName),
        GetRelationFieldName(TField(fl.List^[i])));

      if i>0 then
       vLocateWhere:=vLocateWhere +' and ';
      case VarType(KeyValues[i]) of
       varString:
       begin
        if eloCaseInsensitive in Options then
        begin
         ParName:='UPPER(?'+FormatIdentifier(3,LocateParamPrefix+TField(fl.List^[i]).FieldName)+')';
         fn:='UPPER('+fn+')'
        end
        else
         ParName:='?'+FormatIdentifier(3,LocateParamPrefix+TField(fl.List^[i]).FieldName);

        if eloPartialKey in Options then
         vLocateWhere:=vLocateWhere+'('+fn+' starting with '+ParName+')'
        else
        if eloWildCards in Options then
         vLocateWhere:=vLocateWhere+'('+fn+' like '+ParName+')'
        else
         vLocateWhere:=vLocateWhere+'('+fn+'='+ParName+')'
       end;
      else
       vLocateWhere:=
        vLocateWhere+'('+fn+'=?'+FormatIdentifier(3,LocateParamPrefix+TField(fl.List^[i]).FieldName)+')';
      end
    end;
 
    case LocateKind of
     lkStandard:
      vQLocate.SQL.Text:=AddToWhereClause(QSelect.SQL.Text,vLocateWhere);
     lkNext    :
     begin
      vQLocate.SQL.Text:=AddToWhereClause(FQSelectPart.SQL.Text,vLocateWhere);
      AssignSQLObjectParams(vQLocate,[Self]);
     end;
     lkPrior:
     begin
      vQLocate.SQL.Text:=AddToWhereClause(FQSelectDescPart.SQL.Text,vLocateWhere);
      AssignSQLObjectParams(vQLocate,[Self]);
     end;
    end;

    for i:=0 to Pred(fl.Count) do
    begin
      if Length(KeyValues)>i then
       vQLocate.Params.ByName[LocateParamPrefix+TField(fl.List^[i]).FieldName].Value:=KeyValues[i]
    end;
    R:=(FCacheModelOptions.FBufferChunks div 2)+1;
    vQLocate.OrderClause:='';
    if aQLocate=nil then
    begin
      Result:=RefreshAround(vQLocate,R);
      if Result then
       Resync([rmCenter]);
    end
    else
    with vQLocate do
    begin
    // From Lookup
     Close;
     Params.AssignValues(FQSelect.Params);
     ExecQuery;
     Next;
     Result:=not Eof;
    end;
  finally
   fl.Free;
   EnableScrollEvents;
   EnableControls;
   if aQLocate=nil then
    vQLocate.Free
  end;
end;

 
 
procedure TFIBCustomDataSet.UpdateBlobInfo(Buff: Pointer;Operation:TUpdateBlobInfo;ClearModified,ForceWrite:boolean
 ; Field:TField=nil
);
var
  i, j, k:  Integer;
  pbd: PBlobDataArray;
  vTableName:string;
  vFieldName:string;
  vKeyValues:TDynArray;
 
 
function FillCacheInfo(Field:TField):boolean;
begin
  with  Database.BlobSwapSupport do
  if not Active or (Length(SwapDirectory)=0) then
  begin
    Result := False;
    Exit;
  end;
  Result:=GetRecordFieldInfo(Field,vTableName,vFieldName,vKeyValues);
end;
 
procedure UpdateBlobFieldInfo(aField:TField);
begin
  with PRecordData(Buff)^ do
   if aField.IsBlob then
   begin
    k := aField.FieldNo;
    j := aField.Offset;
    if pbd^[j] <> nil then
    begin
      case Operation of
       ubiPost:
       begin
         if FillCacheInfo(aField) then
         begin
           pbd^[j].TableName:=vTableName;
           pbd^[j].FieldName:=vFieldName;
           pbd^[j].RecordKeyValues:=vKeyValues
         end;
         FWritingBlob:=aField;
         try
          pbd^[j].DoFinalize(ClearModified and (pbd^[j].BlobID.gds_quad_high<>0),ForceWrite,CallBackBlobWrite);
         finally
          FWritingBlob:=nil;
         end
       end;
       ubiCancel:     pbd^[j].Cancel;
       ubiClearOldValue: pbd^[j].FreeOldBuffer;
      end;
      rdFields[k].fdIsNull := pbd^[j].Size = 0;
      if rdFields[k].fdIsNull  and (pbd^[j].BlobID.gds_quad_high=0) then
      begin
       pbd^[j].BlobID:=NullQUID;
      end;
      PISC_QUAD(PAnsiChar(Buff) + vFieldDescrList[k-1].fdDataOfs)^ :=pbd^[j].BlobID;
    end;
   end;
end;
 
begin
  if not Assigned(Buff) then
   Exit;
  if BlobFieldCount=0 then
   Exit;    
  pbd := PBlobDataArray(PAnsiChar(Buff) + FBlobCacheBufferOffset);
  if Field=nil then
  begin
   if (BlobFieldCount>0) then
    for i := 0 to FieldCount - 1 do
     UpdateBlobFieldInfo(Fields[i])
  end
  else
    UpdateBlobFieldInfo(Field)
end;

procedure TFIBCustomDataSet.CallBackBlobWrite(BlobSize:integer; BytesProcessing:integer; var Stop:boolean);
begin
    if (GlobalContainer<>nil)  then
     GlobalContainer.DoOnWriteBlobField(TBlobField(FWritingBlob),BlobSize,BytesProcessing,Stop);
   if Assigned(FOnBlobFieldWrite) then
   begin
    FOnBlobFieldWrite(TBlobField(FWritingBlob),BlobSize,BytesProcessing,Stop);
   end
end;
 
procedure TFIBCustomDataSet.InternalPostRecord(Qry: TFIBQuery; Buff: Pointer);
begin
// abstract
end;

{$WARNINGS OFF}
function TFIBCustomDataSet.InternalRefreshRow(Qry: TFIBQuery; Buff:Pointer):boolean;
var 
  iCurScreenState:  Integer;
begin
  Include(FRunState,drsInRefreshRow);
  ChangeScreenCursor(iCurScreenState);
  Result:=False;
  try
    if Buff=nil then
     Exit;
    if not EmptyStrings(Qry.SQL)  and (Active) then
    begin
     if not FCachedUpdates and (CacheModelOptions.CacheModelKind=cmkStandard) then
      SaveOldBuffer(Buff);
     if  not (Qry.Open  or Qry.ProcExecuted) then
     begin
      SetQueryParams(Qry, Buff);
      PrepareQuery(skRefresh);
      if Qry.OnlySrvParams.Count>0 then
       SetQueryParams(Qry, Buff); // for params in macro
      if (poStartTransaction in Options) and
        not Qry.Transaction.InTransaction
      then
       Qry.Transaction.StartTransaction;
      Qry.ExecQuery;
     end;
     if Qry.Open or Qry.ProcExecuted then
      with PRecordData(Buff)^ do
      try
        if (Qry.SQLType = SQLExecProcedure) or  (Qry.Next <> nil) then
        begin
          FetchCurrentRecordToBuffer(Qry,PRecordData(Buff)^.rdRecordNumber,Buff);
          Result:=True;
        end
        else
        if poRefreshDeletedRecord in Options then
        begin
          if (CacheModelOptions.CacheModelKind=cmkStandard) then
          begin
           Inc(vLockResync);
           try
            CacheDelete;
           finally
            Dec(vLockResync);
           end;
           DoAfterRefresh;
          end;
        end;
      finally
        Qry.Close;
      end;
    end
    else
    if RecordCount>0 then
      FIBError(feCannotRefresh, [CmpFullName(Self)]);
  finally
   Exclude(FRunState,drsInRefreshRow);
   RestoreScreenCursor(iCurScreenState);
  end;
end;

//{$WARNINGS ON}
 
procedure TFIBCustomDataSet.InternalRevertRecord(RecordNumber: Integer;WithUnInserted:boolean);
var 
  pRecBuff:  dbPChar;
begin
  pRecBuff:=FRecordsCache.pRecBuff(RecordNumber+1);
  case TCachedUpdateStatus(PSavedRecordData(pRecBuff)^.rdFlags and 7) of
   cusInserted:
   begin
    TCachedUpdateStatus(PSavedRecordData(pRecBuff)^.rdFlags):=cusUninserted;
    Inc(FDeletedRecords);
   end;
   cusDeleted:
   begin
    TCachedUpdateStatus(PSavedRecordData(pRecBuff)^.rdFlags):=cusUnModified;
    Dec(FDeletedRecords);
   end;
   cusUnInserted:
   if WithUnInserted then
   begin
      TCachedUpdateStatus(PSavedRecordData(pRecBuff)^.rdFlags):=cusInserted;
      Dec(FDeletedRecords);
      Inc(FCountUpdatesPending,2);
   end;
   cusModified:
    FRecordsCache.RevertRecord(RecordNumber+1);
  end;
end;

(*
  A visible record is one that is not truly deleted, and it is also
         listed in the FUpdateRecordTypes set.
 *)
 

function  TFIBCustomDataSet.IsVisibleStat(Buffer: PRecordData): Boolean;
begin
  Result := (TCachedUpdateStatus(PRecordData(Buffer)^.rdFlags and 7) in FUpdateRecordTypes)
   or (FCacheModelOptions.CacheModelKind=cmkLimitedBufferSize) or (drsInApplyUpdates in FRunState)
   or (drsInSort in FRunState);
end;

function TFIBCustomDataSet.IsVisible(Buffer: PRecordData): Boolean;
begin
  Result :=IsVisibleStat(Buffer)
end;


function LocateOptionsToExtLocateOptions(LocateOptions:TLocateOptions):TExtLocateOptions;
begin
  Result:=[];
  if loCaseInsensitive in LocateOptions then
   Include( Result ,eloCaseInsensitive);
  if loPartialKey in LocateOptions then
   Include( Result ,eloPartialKey);
end;

 
 
procedure CastVariantToArray(const KeyValues: Variant; var VarArray:TDynArray);
begin
  if VarIsArray(KeyValues) then
   VarArray:=KeyValues
  else
  begin
    SetLength(VarArray,1);
    VarArray[0]:=KeyValues;
  end;
end;

function TFIBCustomDataSet.Locate(const KeyFields: string;
  const KeyValues: Variant; Options: TLocateOptions): Boolean;
var 
  eOptions: TExtLocateOptions;
  VarArray: TDynArray;
begin
  eOptions:=LocateOptionsToExtLocateOptions(Options);
  CastVariantToArray(KeyValues,VarArray);
  case FCacheModelOptions.CacheModelKind of
   cmkStandard:
    Result := InternalLocate(KeyFields, VarArray, eOptions,True,lkStandard,True);
  else
   Result := InternalLocateForLimCache(KeyFields, VarArray, eOptions);
  end;
end;

function TFIBCustomDataSet.LocateNext(const KeyFields: string;
  const KeyValues: Variant; Options: TLocateOptions): Boolean;
var
  eOptions: TExtLocateOptions;
begin
  eOptions:=LocateOptionsToExtLocateOptions(Options);
  Result:=InternalExtLocate(KeyFields,KeyValues,eOptions,lkNext);
end;

function TFIBCustomDataSet.LocatePrior(const KeyFields: string; const KeyValues: Variant;
      Options: TLocateOptions): Boolean; // Sister function to Locate
var 
  eOptions:  TExtLocateOptions;
begin
  eOptions:=LocateOptionsToExtLocateOptions(Options);
  Result:=InternalExtLocate(KeyFields,KeyValues,eOptions,lkPrior);
end;


function  TFIBCustomDataSet.InternalExtLocate(const KeyFields: string; const KeyValues:Variant;
     Options: TExtLocateOptions;LocateKind:TLocateKind):Boolean;
var
   VarArray: TDynArray;
   ForceInFetchedFlag:boolean;

function EndOfCache:boolean;
begin
  case LocateKind of
   lkNext:
     Result := Eof;
   lkPrior:
    Result  := Bof;
  else
    Result := True;
  end;
end;

begin
  Result:=EndOfCache;
  if Result then
  begin
    Result := False;
    Exit;
  end;



  CastVariantToArray(KeyValues,VarArray);
  ForceInFetchedFlag:=(FCacheModelOptions.CacheModelKind=cmkLimitedBufferSize)
     and not (eloInFetchedRecords in Options)
  ;
  if ForceInFetchedFlag then
    Include(Options,eloInFetchedRecords);
  Result  := InternalLocate(KeyFields, VarArray, Options,False,LocateKind);
  if not Result and
   (FCacheModelOptions.FCacheModelKind=cmkLimitedBufferSize) and  ForceInFetchedFlag
  then
     Result:= InternalLocateForLimCache(KeyFields, VarArray, Options,LocateKind);
end;

function TFIBCustomDataSet.ExtLocateNext(const KeyFields: string; const KeyValues: Variant;
      Options: TExtLocateOptions): Boolean;
begin
  Result:=InternalExtLocate(KeyFields,KeyValues,Options,lkNext);
end;

function TFIBCustomDataSet.ExtLocatePrior(const KeyFields: string; const KeyValues: Variant;
      Options: TExtLocateOptions): Boolean; // Sister function to ExtLocate
begin
  Result:=InternalExtLocate(KeyFields,KeyValues,Options,lkPrior);
end;
 
procedure TFIBCustomDataSet.RefreshFilters;
var
    OldRecNo: integer;
begin
  if csDestroying in ComponentState then
   Exit;
  if Active then
  begin
    CheckBrowseMode;
    if IsEmpty then
     OldRecNo:=-1
    else
     OldRecNo:=GetRealRecNo;
    RefreshClientFields(False);
    if GetRealRecNo<>OldRecNo then
     First
  end
end;
 
procedure TFIBCustomDataSet.ChangeScreenCursor(var OldCursor:integer);
begin
  {$IFNDEF NO_GUI}
   OldCursor := Screen.Cursor;
   if (FSQLScreenCursor <> crDefault) and (FSQLScreenCursor <> OldCursor) then
    Screen.Cursor := FSQLScreenCursor;
  {$ENDIF}
end;
 
procedure TFIBCustomDataSet.RestoreScreenCursor(const OldCursor:integer);
begin
  {$IFNDEF NO_GUI}
   if (FSQLScreenCursor <> crDefault) and (FSQLScreenCursor <> OldCursor) then
    Screen.Cursor := OldCursor;
  {$ENDIF}    
end;

procedure TFIBCustomDataSet.Prepare;
var
  iCurScreenState:  Integer;
begin
  ChangeScreenCursor(iCurScreenState);
  try
    FBase.CheckDatabase;
    StartTransaction;
    FBase.CheckTransaction;
    if not EmptyStrings(FQSelect.SQL) then
    begin
      if not FQSelect.Open then
       FQSelect.Prepare;
      if csDesigning in ComponentState then
      begin
        PrepareQuery(FIBDataSet.skModify);
        PrepareQuery(FIBDataSet.skInsert);
        PrepareQuery(FIBDataSet.skDelete);
        PrepareQuery(skRefresh);
      end;
      FPrepared := True;
      InternalInitFieldDefs;
    end
    else
      FIBError(feEmptyQuery, ['Prepare ' + CmpFullName(Self)]);
  finally
   RestoreScreenCursor(iCurScreenState);
  end;
end;

procedure TFIBCustomDataSet.UnPrepare;
begin
   QSelect.FreeHandle;
   QDelete.FreeHandle;
   QInsert.FreeHandle;
   QUpdate.FreeHandle;
   QRefresh.FreeHandle;   
   FPrepared:=False
end;
 
procedure TFIBCustomDataSet.RecordModified(Value: Boolean);
begin
  SetModified(Value);
end;
 
procedure TFIBCustomDataSet.RevertRecord;
var
  Buff:  PRecordData;
begin
  CheckDatasetOpen(' revert record ') ;
  if FCachedUpdates  then
  begin
    Buff := PRecordData(GetActiveBuf);
    InternalRevertRecord(Buff^.rdRecordNumber,True);
    ReadRecordCache(Buff^.rdRecordNumber, dbPChar(Buff), False);
    if IsVisible(Buff) then
     DataEvent(deRecordChange, 0)
    else
    begin
     SetCurrentRecord(ActiveRecord);
     Resync([]);
    end;
    Dec(FCountUpdatesPending);
    FUpdatesPending:=FCountUpdatesPending>0
  end;
end;

procedure TFIBCustomDataSet.SaveOldBuffer(Buffer: dbPChar);
var
  R:  Integer;
begin
 if Assigned(Buffer) then
 begin
  case FCacheModelOptions.CacheModelKind of
   cmkStandard:
   begin
     FRecordsCache.SaveOldBuffer(PRecordData(Buffer)^.rdRecordNumber+1);
     if FCachedUpdates then
      FRecordsCache.SaveToChangeLog(PRecordData(Buffer)^.rdRecordNumber+1);
   end;
   cmkLimitedBufferSize :
   begin
     R:=(PRecordData(Buffer)^.rdRecordNumber+1) mod FCacheModelOptions.FBufferChunks;
     if R=0 then
      R:=FCacheModelOptions.FBufferChunks;
     FRecordsCache.SaveOldBuffer(R);
   end;

  end;
 end;
end;
 

procedure TFIBCustomDataSet.SetDatabase(Value: TFIBDatabase);
begin
    (* Check that the dataset is closed *)
  CheckDatasetClosed(' change database ');
    (* Unset the database property of all owned components *)
  LiveChangeDatabase(Value)
end;

procedure TFIBCustomDataSet.LiveChangeDatabase(Value: TFIBDatabase); // internal use
begin
  FQDelete.Database  := Value;
  FQInsert.Database  := Value;
  FQRefresh.Database := Value;
  FQSelect.Database  := Value;
  FQUpdate.Database  := Value;

  if FBase.Database <> Value then
  begin
   FBase.Database     := Value;
    if Assigned(Value) and Assigned(Value.DefaultUpdateTransaction) then
    begin
      if
         not (Assigned(UpdateTransaction) and (UpdateTransaction<>Transaction))
      and
         not CmpInLoadedState(Self) and not CmpInLoadedState(Value)
      then
         UpdateTransaction:=Value.DefaultUpdateTransaction
    end;
  end;
end;

procedure TFIBCustomDataSet.SetDeleteSQL(Value: TStrings);
begin
  FQDelete.SQL.Assign(Value);
end;

procedure TFIBCustomDataSet.SetInsertSQL(Value: TStrings);
begin
  FQInsert.SQL.Assign(Value);
end;

{$WARNINGS OFF}
type
   TFriendSQLVAR= class(TFIBXSQLVAR);

procedure TFIBCustomDataSet.SetQueryParams(Qry: TFIBQuery; Buffer: Pointer);
var 
  l,i, j,pc,pc1:  Integer;
  cr, data: PAnsiChar;
  fn, st: Ansistring;
  OldBuffer: Pointer;
  fi:PFIBFieldDescr;
  tf:TField;
  cur_param: TFIBXSQLVAR;
  Source_Param: TFIBXSQLVAR;

begin
  if (Buffer = nil) then
    FIBError(feBufferNotSet, [CmpFullName(Self)]);
  with  PRecordData(Buffer)^ do
  begin
    if rdRecordNumber<0 then
     Exit;
    if (State = dsInsert) then
     OldBuffer :=Buffer
    else
    case FCacheModelOptions.FCacheModelKind  of
     cmkStandard:
      begin
       if UniDirectional then
        OldBuffer := FRecordsCache.OldBuffer((rdRecordNumber mod FCacheModelOptions.FBufferChunks)+1)-DiffSizesRecData
       else
        OldBuffer := FRecordsCache.OldBuffer(rdRecordNumber+1)-DiffSizesRecData
       end
    else
     OldBuffer := FRecordsCache.OldBuffer((rdRecordNumber mod FCacheModelOptions.FBufferChunks)+1)-DiffSizesRecData;
    end;
 
    pc := Qry.Params.Count ;
    pc1:= pc +Qry.OnlySrvParams.Count;
    i:=0;
    while i < pc1 do
    begin
      if i<pc then
       cur_param:=Qry.Params[i]
      else
       cur_param:=Qry.FindParam(Qry.OnlySrvParams[i-pc]);
      Inc(i);
      if cur_param=nil then
       Continue;
      fn := cur_param.Name;
      if IsOldParamName(fn) then
      begin
        fn:=FastCopy(fn,5,MaxInt);
        cr := OldBuffer;
      end
      else
      if IsNewParamName(fn) then
      begin
        fn:=FastCopy(fn,5,MaxInt);
        cr := Buffer;
      end
      else
      if IsMasParamName(fn) and (DataSource<>nil)
       and (DataSource.DataSet<>nil)
      then
      begin
        fn:=FastCopy(fn,5,MaxInt);
        tf:=DataSource.DataSet.FindField(fn);
        if tf<>nil then
        begin
          {$IFDEF D6+}
            cur_param.Value:=tf.Value;
          {$ELSE}
          if (tf is TFIBBCDField) then
          begin
           if(TFIBBCDField(tf).Size=0) then
            cur_param.AsInt64     := TFIBBCDField(tf).AsInt64
           else
            cur_param.AsBcd      := TFIBBCDField(tf).AsBcd;
          end
          else
             cur_param.Value:=tf.Value;
          {$ENDIF}
        end;  
        Continue;
      end
      else
        cr := Buffer;
 
      tf :=Self.FN(fn);
      if Assigned(tf) and (tf.FieldKind=fkData) then
        j := tf.FieldNo
      else
        j := FQSelect.FieldIndex[fn] + 1;

      if (Qry<>FQSelect) then
      begin
        if j=0 then
        begin
        //���� ��� ���� fn �������� ����� �� ���������.
          Source_Param:=Params.ByName[fn];
          if Source_Param<>nil then
            cur_param.Assign(Source_Param)
        end
        else
        if(Qry=FQRefresh) and   (DataSource<>nil) then
        begin
         Source_Param:=Params.ByName[cur_param.Name];
         if (Source_Param<>nil)then
         begin
          //���� ���� ���� fn �� � ������ ������� ���������� �������� �����
          //�� ���������.
            cur_param.Assign(Source_Param);
            Continue
         end;
        end;
      end;

      if (j > 0) then
      with PRecordData(cr)^ do
        if rdFields[j].fdIsNull then
          cur_param.IsNull := True
        else
        begin
          fi:=vFieldDescrList[j-1];

          if cur_param.IsNull then
           cur_param.IsNull := False;
 
          data := cr + fi^.fdDataOfs;
          case fi^.fdDataType of
            SQL_TEXT, SQL_VARYING:
            begin
              if fi^.fdIsDBKey then
              begin
                 SetString(st, data,fi^.fdDataSize);
                 cur_param.Data^.sqltype := SQL_TEXT or (cur_param.Data^.sqltype and 1);
                 cur_param.Data^.sqllen :=fi^.fdDataSize;
                 FIBAlloc(cur_param.Data^.sqldata, 0,  fi^.fdDataSize+1);
                 Move(st[1], cur_param.Data^.sqldata^, fi^.fdDataSize);
              end
              else
              case fi^.fdAddedFields of
               atfGuidField:
                cur_param.AsGuid:=PGuid(data)^;
              else
               if fi^.fdIsSeparateString then
               begin
                L:=PInteger(data)^;
                Inc(Data,SizeOf(Integer));
               end
               else
                L:=Q_StrLen(data);
 
               if L>fi^.fdDataSize then l:=fi^.fdDataSize;
                SetString(st, data,L);
               if L=0 then
                TFriendSQLVAR(cur_param).SetValue(SQL_TEXT,L, tspValue,'')
               else
                TFriendSQLVAR(cur_param).SetValue(SQL_TEXT,L, tspValue,st[1]);
              end;
            end;
            SQL_FLOAT:
              cur_param.AsDouble := PSingle(data)^;
            SQL_DOUBLE, SQL_D_FLOAT:
              cur_param.AsDouble := PDouble(data)^;
            SQL_SHORT:
              if fi^.fdDataScale<0 then
               cur_param.AsDouble := PShort(data)^*E10[fi^.fdDataScale]
              else
               cur_param.AsLong := PShort(data)^;
            SQL_LONG:
              if fi^.fdDataScale<0 then
               cur_param.AsDouble := PLong(data)^*E10[fi^.fdDataScale]
              else
               cur_param.AsLong := PLong(data)^;
            SQL_INT64:
            begin
              if (fi^.fdDataScale >= -4) or (psSQLINT64ToBCD in PrepareOptions)then
              begin
                cur_param.AsInt64:=PInt64(data)^;
                cur_param.Scale :=fi^.fdDataScale;
              end
              else
                cur_param.AsDouble := PDouble(data)^;
            end;
            SQL_ARRAY:
            begin
             cur_param.AsQuad := PISC_QUAD(data)^;
            end;
            SQL_BLOB,  SQL_QUAD:
            begin
              if tf <>nil then
               UpdateBlobInfo(Buffer,ubiPost,False,False, tf);
              cur_param.AsQuad := PISC_QUAD(data)^;
            end;
            SQL_TYPE_DATE:
            begin
              cur_param.AsTimeStamp:=StdFuncs.TimeStamp(PInt(data)^,0);
            end;
            SQL_TYPE_TIME:
            begin
              cur_param.AsTimeStamp:=StdFuncs.TimeStamp(0,PInt(data)^);
            end;
            SQL_DATE:
              cur_param.AsTimeStamp:=MSecsToTimeStamp(PDouble(data)^);
            SQL_BOOLEAN:
              cur_param.AsBoolean  :=(PShort(data)^ = ISC_TRUE)
          end;
        end;
    end;
  end;
end;

//{$WARNINGS ON}
 
procedure TFIBCustomDataSet.SetRefreshSQL(Value: TStrings);
begin
  FQRefresh.SQL.Assign(Value);
end;

procedure TFIBCustomDataSet.SetSelectSQL(Value: TStrings);
begin
 if not (csDesigning in ComponentState) then
  CheckDatasetClosed(' change SelectSQL ')
 else
  Close;
 FQSelect.SQL.Assign(Value);
end;

procedure TFIBCustomDataSet.SetUpdateSQL(Value: TStrings);
begin
  FQUpdate.SQL.Assign(Value);
end;

procedure TFIBCustomDataSet.SetTransaction(Value: TFIBTransaction);
begin
    CheckDatasetClosed(' change transaction ');
    LiveChangeTransaction(Value)
end;

procedure TFIBCustomDataSet.LiveChangeTransaction(Value: TFIBTransaction); // internal use
var 
   vOnlyRead: boolean;
begin
    FBase.Transaction := Value;
    vOnlyRead:=FQSelect.Transaction<>FQDelete.Transaction;
    if Assigned(FQSelect.Transaction) then
    with FQSelect.Transaction do
    begin
     RemoveEvent(DoBeforeStartTransaction,tetBeforeStartTransaction);
     RemoveEvent(DoAfterStartTransaction ,tetAfterStartTransaction);
     RemoveEndEvent(DoBeforeEndTransaction,tetBeforeEndTransaction);
     RemoveEndEvent(DoAfterEndTransaction ,tetAfterEndTransaction);

     RemoveEvent(DoBeforeStartUpdateTransaction,tetBeforeStartTransaction);
     RemoveEvent(DoAfterStartUpdateTransaction ,tetAfterStartTransaction);
     RemoveEndEvent(DoBeforeEndUpdateTransaction,tetBeforeEndTransaction);
     RemoveEndEvent(DoAfterEndUpdateTransaction ,tetAfterEndTransaction);
    end;
 
    FQSelect.Transaction := Value;
    if Assigned(Value) then
    begin
     Value.AddEvent(DoBeforeStartTransaction,tetBeforeStartTransaction);
     Value.AddEvent(DoAfterStartTransaction ,tetAfterStartTransaction);
 
     Value.AddEndEvent(DoBeforeEndTransaction,tetBeforeEndTransaction);
     Value.AddEndEvent(DoAfterEndTransaction ,tetAfterEndTransaction);
    end;
    if not vOnlyRead then
    begin
     FQRefresh.Transaction:= Value;
     FQDelete.Transaction := Value;
     FQInsert.Transaction := Value;
     FQUpdate.Transaction := Value;
     if Assigned(Value) then
     begin
      Value.AddEvent(DoBeforeStartUpdateTransaction,tetBeforeStartTransaction);
      Value.AddEvent(DoAfterStartUpdateTransaction ,tetAfterStartTransaction);
      Value.AddEndEvent(DoBeforeEndUpdateTransaction,tetBeforeEndTransaction);
      Value.AddEndEvent(DoAfterEndUpdateTransaction ,tetAfterEndTransaction);
     end
    end
    else
    if FRefreshTransactionKind=tkReadTransaction then
     FQRefresh.Transaction:= Value;
 
end;
 
procedure TFIBCustomDataSet.SetUpdateRecordTypes(Value: TFIBUpdateRecordTypes);
begin
  FUpdateRecordTypes := Value;
  if Active then First;
end;
 
procedure TFIBCustomDataSet.SetUniDirectional(Value: Boolean);
begin
  CheckDatasetClosed(' change Unidirectional property ');
//  inherited SetUniDirectional(Value);
  FUniDirectional := Value;
end;

 
function  TFIBCustomDataSet.GetWaitEndMasterScroll:boolean;
begin
 if Assigned(vTimerForDetail) then
  Result:=vTimerForDetail.Interval>0
 else
  Result := False;
end;

procedure TFIBCustomDataSet.SetWaitEndMasterScroll(Value:boolean);
begin
 if Value then
 begin
  CreateDetailTimer;
  vTimerForDetail.Interval:=WaitEndMasterInterval;
  Include(FDetailConditions, dcWaitEndMasterScroll);
 end
 else
 begin
  ForceEndWaitMaster;
  if Assigned(vTimerForDetail) then
  begin
    vTimerForDetail.Free;
    vTimerForDetail:=nil;
  end;
  Exclude(FDetailConditions, dcWaitEndMasterScroll);
 end;
end;
 
function TFIBCustomDataSet.GetDetailConditions:TDetailConditions;
begin
  if Assigned(vTimerForDetail) and (vTimerForDetail.Interval>0) then
    Include(FDetailConditions, dcWaitEndMasterScroll)
  else
    Exclude(FDetailConditions, dcWaitEndMasterScroll);
  Result := FDetailConditions;
end;
 
procedure TFIBCustomDataSet.SetDetailConditions(Value:TDetailConditions);
begin
   FDetailConditions := Value;
   if dcWaitEndMasterScroll in FDetailConditions then
   begin
     CreateDetailTimer;
     vTimerForDetail.Interval:=WaitEndMasterInterval
   end
   else
   if Assigned(vTimerForDetail) then
   begin
     vTimerForDetail.Free;
     vTimerForDetail:=nil;
   end;
end;
 
procedure TFIBCustomDataSet.StartTransaction;
begin
 if DataBase=nil then
  if Transaction<>nil then
   DataBase:=Transaction.DefaultDataBase;
 if Transaction=nil then
  if DataBase<>nil then  Transaction:=DataBase.DefaultTransaction;
 if (Transaction<>nil) and not Transaction.Active  then
 begin
   if Transaction.DatabaseCount=0 then
     Transaction.DefaultDatabase:=Database;
   if poStartTransaction in Options then
   Transaction.StartTransaction;
 end;
end;
 
procedure TFIBCustomDataSet.CloseOpen(const DoFetchAll:boolean);
var 
  iCurScreenState: Integer;
  OldDefaultFields:boolean;
begin
 ChangeScreenCursor(iCurScreenState);
 OldDefaultFields:=DefaultFields;
 try
  SetDefaultFields(False);
  if not Active then
  begin
   Open;
   if DoFetchAll then FetchAll;
  end
  else
  begin
   Close;
   Open;
   if DoFetchAll then FetchAll;
  end;
 finally
  SetDefaultFields(OldDefaultFields);
  RestoreScreenCursor(iCurScreenState);
 end;
end;
 
procedure TFIBCustomDataSet.OpenByTimer(Sender:TObject);
begin
  Include(FRunState,drsInOpenByTimer);
  try
    DoCloseOpen(Sender);
  finally
   Exclude(FRunState,drsInOpenByTimer);
  end
end;

procedure TFIBCustomDataSet.DoCloseOpen(Sender:TObject);
begin
  if Assigned(vTimerForDetail) then
   vTimerForDetail.Enabled:=False;
  DisableControls;
  try
    if not EmptyStrings(SelectSQL) then
    begin
     if (Active or (dcForceOpen in FDetailConditions))  then
      CloseOpen(False)
    end;
  finally
   EnableControls;
   DataEvent(deDataSetScroll,0);
  end;
end;

procedure TFIBCustomDataSet.SetPrepareOptions(Value:TpPrepareOptions);
begin
 if not (csReading in ComponentState) and
  (((psUseBooleanField in Value-FPrepareOptions)  or
   (psUseBooleanField in FPrepareOptions-Value)
  )
  or
  ((psSQLINT64ToBCD in Value-FPrepareOptions)  or
   (psSQLINT64ToBCD in FPrepareOptions-Value)
  ))
  or
  ((psUseLargeIntField in Value-FPrepareOptions)  or
   (psUseLargeIntField in FPrepareOptions-Value)
  )
 then
 begin
  CheckDatasetClosed('change psUseBooleanField or psSQLINT64ToBCD or psUseLargeIntField'+#13#10);
  if Prepared then
  begin
   FPrepareOptions:=Value;
   FieldDefs.Clear;
   FieldDefs.Update;
   Exit;
  end;
 end;
 FPrepareOptions:=Value;
end;
 
procedure TFIBCustomDataSet.SetRefreshTransactionKind(
  const Value: TTransactionKind);
begin
  case Value of
    tkReadTransaction  : QRefresh.Transaction:=Transaction;
    tkUpdateTransaction: QRefresh.Transaction:=UpdateTransaction;
  end;
  FRefreshTransactionKind := Value;
end;

procedure TFIBCustomDataSet.SourceChanged;
var IsFirstEndWait:boolean;
begin
  if FMasSourceDisableCount>0 then
    Exit;
  IsFirstEndWait:=(DataSource=nil) or (DataSource.DataSet=nil)
    or not (DataSource.DataSet is TFIBCustomDataSet)
    or not
    (drsInOpenByTimer in TFIBCustomDataSet(DataSource.DataSet).FRunState);
  if Assigned(vTimerForDetail) and (vTimerForDetail.Interval>0) then
  begin
   if IsFirstEndWait then
   begin
     vTimerForDetail.Enabled:=False;
     vTimerForDetail.Interval := WaitEndMasterInterval;
     vTimerForDetail.Enabled:=True;
   end
   else
   try
    Include(FRunState,drsInOpenByTimer);
    DoCloseOpen(nil);
   finally
    Exclude(FRunState,drsInOpenByTimer);
   end;
  end
  else
   DoCloseOpen(nil)
end;

procedure TFIBCustomDataSet.SourceDisabled;
begin
 if not (dcIgnoreMasterClose in DetailConditions) and Active then
 try
  Close;
 except
  if DataSource.DataSet is TFIBCustomDataSet then
   TFIBCustomDataSet(DataSource.DataSet).CloseCursor;
  raise;
 end;
end;
 
 
{MasterDetails Routines}
procedure TFIBCustomDataSet.DisableMasterSource;
begin
 Inc(FMasSourceDisableCount)
end;
 
procedure TFIBCustomDataSet.EnableMasterSource;
begin
 Dec(FMasSourceDisableCount)
end;
 
function  TFIBCustomDataSet.MasterSourceDisabled:boolean;
begin
  Result:=FMasSourceDisableCount>0
end;

procedure TFIBCustomDataSet.SQLChanging(Sender: TObject);
begin
 FAutoUpdateOptions.WhereCondition:='';
 FAutoUpdateOptions.ReadySelectSQL:='';
 if (Sender=QSelect) then
 begin
  FAutoUpdateOptions.UpdateTableName:=FAutoUpdateOptions.UpdateTableName;
  if Assigned(FParams) then
  begin
    FreeAndNil(FParams);
  end;

  vSelectSQLTextChanged:=True;
  if not (csDesigning in ComponentState) then
   CheckDatasetClosed(' change SelectSQL ')
  else
   Close;
  FieldDefs.Clear;
  FPrepared   := False;
 end;
end;
 
(*
 * I can "undelete" uninserted records (make them "inserted" again).
 * I can "undelete" cached deleted (the deletion hasn't yet occurred).
 *)
procedure TFIBCustomDataSet.Undelete;
var 
  Buff:  PRecordData;
begin
  CheckDatasetOpen(' undelete ') ;
  Buff := PRecordData(GetActiveBuf);
  with Buff^ do
  begin
    if TCachedUpdateStatus(rdFlags)=cusUninserted then
    begin
      TCachedUpdateStatus(rdFlags):=cusInserted;
      Inc(FCountUpdatesPending);
    end
    else
    if TCachedUpdateStatus(rdFlags)=cusDeleted then
    begin
      TCachedUpdateStatus(rdFlags):=cusUnmodified;
      Dec(FCountUpdatesPending);
    end;
    Dec(FDeletedRecords);
 
    WriteRecordCache(rdRecordNumber, dbPChar(Buff));
  end;
end;

function TFIBCustomDataSet.UpdateStatus: TUpdateStatus;
var 
 CurBuff:  PRecordData;
begin
  Result := usUnmodified;
  if not Active then Exit;
  CurBuff := PRecordData(GetActiveBuf);
  if CurBuff <> nil then
  with CurBuff^ do
  if (rdFlags and 7)<>Byte(cusUninserted) then
   Result:=TUpdateStatus(rdFlags and 7)
  else
   Result:=usDeleted;
end;

function TFIBCustomDataSet.IsSequenced: Boolean;
begin
  Result := Assigned(FQSelect) and FQSelect.Eof and
   (not Filtered  or (FRecordCount=0)) and not UniDirectional 
   ;
end;


function  TFIBCustomDataSet.IsValidBuffer(FCache: PAnsiChar):boolean;
begin
  Result:=(PRecordData(FCache)^.rdRecordNumber<FRecordCount)
   and (PRecordData(FCache)^.rdRecordNumber>-1)
end;
 
procedure TFIBCustomDataSet.PackMemory(var FCache: PAnsiChar);
begin
end;
 
 
procedure TFIBCustomDataSet.ReadRecordCache(RecordNumber: Integer; Buffer: dbPChar;
  ReadOldBuffer: Boolean);
var
 OldBuf: dbPChar;
 PrRecordNumber:integer;
begin
 PrRecordNumber:=RecordNumber;
 if FUniDirectional  or (FCacheModelOptions.CacheModelKind=cmkLimitedBufferSize)  then
    RecordNumber := RecordNumber mod FCacheModelOptions.FBufferChunks;
 if RecordNumber >= 0 then
 begin
  PInteger(Buffer)^:=PrRecordNumber;
//  FillChar(Buffer[SizeOf(Integer)],FRecordBufferSize-SizeOf(Integer),0);
  if FCalcFieldsOffset<>FRecordBufferSize then
   FillChar(Buffer[FCalcFieldsOffset],FRecordBufferSize-FCalcFieldsOffset,0);
  if ReadOldBuffer then
  begin
    OldBuf:=FRecordsCache.OldBuffer(RecordNumber+1);
    Move(OldBuf[0],Buffer[DiffSizesRecData],FRecordBufferSize-DiffSizesRecData);
  end
  else
  begin
   Inc(Buffer,DiffSizesRecData);
   FRecordsCache.ReadRecordBuffer(RecordNumber+1, Buffer,False);
  end;
 end;
end;
 
procedure TFIBCustomDataSet.WriteRecordCache(RecordNumber: Integer; Buffer: dbPChar);
begin
 if RecordNumber >= 0 then
 begin
    if FUniDirectional or (FCacheModelOptions.CacheModelKind=cmkLimitedBufferSize) then
     RecordNumber := RecordNumber mod FCacheModelOptions.FBufferChunks;
   Buffer:=Buffer+DiffSizesRecData;
   FRecordsCache.WriteRecord(RecordNumber+1,Buffer,True);
 end;
end;

//
function TFIBCustomDataSet.GetNewBuffer:dbPChar;
begin
  Result:=GetActiveBuf;
end;

function TFIBCustomDataSet.GetOldBuffer(aRecordNo:integer =-1):dbPChar;
var 
     buf: dbPChar;
     RecordNo:integer;
begin
 if aRecordNo=-1 then
 begin
   Result:=GetActiveBuf;
   if Result = nil then
    Exit;
    RecordNo:=PRecordData(Result)^.rdRecordNumber;
 end
 else
  RecordNo:=aRecordNo;
 Result  :=AllocRecordBuffer;
 PInteger(Result)^:=RecordNo;
// Move(RecordNo,Result[0],SizeOf(Integer));
 case FCacheModelOptions.FCacheModelKind of
  cmkStandard: buf:=FRecordsCache.OldBuffer(RecordNo+1);
  cmkLimitedBufferSize: buf:=FRecordsCache.OldBuffer((RecordNo mod FCacheModelOptions.FBufferChunks)+1);
 else
   Exit;
 end;
 Move(buf[0],Result[DiffSizesRecData],FRecordBufferSize-DiffSizesRecData);
end;

//
 
function  TFIBCustomDataSet.SortInfoIsValid:boolean;
var
   i,sfc: integer;
begin
  if VarIsNull(FSortFields)  then
   Result := False
  else
  begin
    sfc:=SortFieldsCount-1;
    for i:=0 to sfc do
     if FN(FSortFields[i,0])=nil then
     begin
       Result := False;
       Exit;
     end;
     Result := True;
  end;
end;
 
 
function  TFIBCustomDataSet.IsSortedField(Field:TField; var FieldSortOrder:TSortFieldInfo):boolean;
var fn,tmpStr:string;
    l,i:integer;
begin
  Result:=
   not VarIsNull(FSortFields);
  if not Result then
   Exit;
  Result:=False;
  fn:=Field.FieldName;
  L :=VarArrayHighBound(FSortFields,1);
  for i:=0 to L do
  begin
   tmpStr:=FSortFields[i,0];
   Result:=tmpStr=fn;
   if Result then
   begin
    FieldSortOrder.FieldName     :=tmpStr;
    FieldSortOrder.InDataSetIndex:=Field.Index;
    FieldSortOrder.InOrderIndex  :=i+1;
    FieldSortOrder.Asc           :=FSortFields[i,1];
    FieldSortOrder.NullsFirst    :=FSortFields[i,2];
    Exit;
   end;
  end;
end;
 
function  TFIBCustomDataSet.SortFieldsCount:integer;
begin
 Result:=0;
 if VarIsNull(FSortFields) then
  Exit;
 Result:=VarArrayHighBound(FSortFields,1)+1;
end;

function  TFIBCustomDataSet.IsSorted :boolean;
begin
 Result:=SortFieldsCount>0
end;

function  TFIBCustomDataSet.SortFieldInfo(OrderIndex:integer):TSortFieldInfo;
begin
 if (OrderIndex<1) or (OrderIndex>SortFieldsCount) then
 begin
  Result.FieldName:='Unknown';
  Result.InOrderIndex:=-1;
  Result.InDataSetIndex:=-1;
  Result.Asc           :=True;
 end
 else
 begin
  Result.FieldName:=FSortFields[OrderIndex-1,0];
  Result.InDataSetIndex:=FBN(Result.FieldName).Index;
  Result.InOrderIndex  :=OrderIndex;
  Result.Asc           :=FSortFields[OrderIndex-1,1];
  Result.NullsFirst    :=FSortFields[OrderIndex-1,2];
 end;
end;
 
function  TFIBCustomDataSet.SortedFields:string;
var i,l:integer;
begin
  Result:='';
  if  VarIsNull(FSortFields) then Exit;
  l :=VarArrayHighBound(FSortFields,1);
  for i:=0 to l do
   Result:=Result+iifStr(i>0,';','')+FSortFields[i,0];
end;

function  TFIBCustomDataSet.GetFieldOrigin(Fld:TField):string;
var 
   TName:  string;
   FName:string;
begin
  Result:='';
  if (Fld=nil) then
   Exit;
  if FFieldOriginRule=forNoRule then
   Exit;

  if not Active and (Fld.FieldNo=0) then
  begin
   if not Prepared then Prepare;
   BindFields(True);
  end;
  case FFieldOriginRule of
   forTableAndFieldName:
   begin
    TName:=GetRelationTableName(Fld);
    FName:=GetRelationFieldName(Fld);
   end;
   forClientFieldName:
   begin
     TName:='';
     FName:=Fld.FieldName
   end;
   forTableAliasAndFieldName:
   begin
     TName:=TableAliasForField(Fld.FieldName);
     FName:=GetRelationFieldName(Fld);
   end;
  end;

 
  if Length(TName) > 0 then
   Result:=TName+'.'+FName
  else
  if Length(FName) > 0 then
   Result:=FName
  else
   Result:=''
end;
 
function TFIBCustomDataSet.CreateCalcField(FieldClass:TFieldClass; const aName,aFieldName:string;aSize:integer):TField;
begin
  Result:=FieldClass.Create(Self);
  with Result do
  begin
   FieldKind:=fkCalculated;
   Size     :=aSize;
   FieldName:=aFieldName;
   Name     :=aName;
   if DefaultFields then
    Include(FRunState,drsForceCreateCalcFields);
   try
    DataSet  :=Self;
   except
    Exclude(FRunState,drsForceCreateCalcFields);
    raise
   end;
  end;
end;
 

function  TFIBCustomDataSet.CreateLookUpField(FieldClass:TFieldClass; const aName,aFieldName:string;aSize:integer;
     aLookupDataSet: TDataSet; const aKeyFields, aLookupKeyFields, aLookupResultField: string
):TField;
begin
  Result:=CreateCalcField(FieldClass,aName,aFieldName,aSize);
  with Result do
  begin
   FieldKind:=fkLookup;
   LookupDataSet:=aLookupDataSet;
   KeyFields    :=aKeyFields;
   LookupKeyFields:=aLookupKeyFields;
   LookupResultField:=aLookupResultField
  end;
end;
 
function  TFIBCustomDataSet.IsComputedField(Fld:Variant):boolean;
var 
    Field:  TObject;
    t:integer;
    Fi:TpFIBFieldInfo;
begin
 Result:=False;
 Field:=nil;
 t    :=VarType(Fld);
 case t of
  varInteger: Field:=Fields[Fld];
  varOleStr,varString :
  begin
   Field:=FN(Fld);
   if Field =nil then
    Field:=FieldDefs.Find(Fld);
  end;
 end;
 if (Field=nil) or ((Field is TField) and (TField(Field).FieldKind<>fkData)) then
  Exit;

 Fi:= ListTableInfo.GetFieldInfo( DataBase,GetRelationTableName(Field),
                     GetRelationFieldName(Field),False
 );
 if Fi=nil then
  Exit;
 Result:=fi.IsComputed;
end;

function  TFIBCustomDataSet.DomainForField(Fld:Variant):string;
var                                                    
    Field:  TObject;
    t:integer;
    Fi:TpFIBFieldInfo;
begin
 Result:='';
 Field:=nil;
 t    :=VarType(Fld);
 case t of
  varInteger: Field:=Fields[Fld];
  varOleStr,varString : 
  begin
   Field:=FN(Fld);
   if Field =nil then
    Field:=FieldDefs.Find(Fld);
  end;
 
 end;
 if (Field=nil) or ((Field is TField) and (TField(Field).FieldKind<>fkData)) then
  Exit;

 Fi:= ListTableInfo.GetFieldInfo( DataBase,GetRelationTableName(Field),
                     GetRelationFieldName(Field),False
 );
 if Fi=nil then
  Exit;
 Result:=fi.DomainName;
end;
 
function TFIBCustomDataSet.FieldByOrigin(const aOrigin:string):TField;
begin
// ��������, ���� � ������� ��������� ���� � ����������� Origin
// �� ���������� ������ ������.
  Result:=FieldByOrigin(ExtractWord(1,aOrigin,['.']),ExtractWord(2,aOrigin,['.']));
end;


function  TFIBCustomDataSet.FieldByOrigin(const TableName,FieldName:string):TField;
var 
  i: integer;
  vTableName:string;
  vFieldName:string;
begin
  if Assigned(Database) and ((Database.SQLDialect<3) or Database.UpperOldNames)  then
  begin
   if (Length(TableName) > 0) and (TableName[1]<>'"') then
    vTableName:=FastUpperCase(TableName)
   else
    vTableName:=TableName;
   if (Length(FieldName) > 0) and (FieldName[1]<>'"') then
    vFieldName:=FastUpperCase(FieldName)
   else
    vFieldName:=FieldName      
  end
  else
  begin
   vTableName:=TableName;
   vFieldName:=FieldName;
  end;
  vTableName:=CutQuote(vTableName);
  vFieldName:=CutQuote(vFieldName);
  for i:=0 to Pred(FieldCount) do
  begin
   if (GetRelationTableName(Fields[i])  =vTableName)
      and (GetRelationFieldName(Fields[i])=vFieldName)
   then
   begin
      Result:=Fields[i];
      Exit
   end;
  end;
  Result := nil;
end;

function  TFIBCustomDataSet.ReadySelectText:string;
begin
   if  Length(FAutoUpdateOptions.ReadySelectSQL)= 0 then
   begin
    Result:=FQSelect.ReadySQLText(False); // SetMacro
    FAutoUpdateOptions.ReadySelectSQL:= Result ;
   end
   else
    Result:=FAutoUpdateOptions.ReadySelectSQL;
end;

function TFIBCustomDataSet.TableAliasForField(const aFieldName:string):string;
begin
  Result:=QSelect.TableAliasForFieldByName(aFieldName)
end;

 
function  TFIBCustomDataSet.SQLFieldName(const aFieldName:string):string;
begin
 Result :=QSelect.SQLFieldName(aFieldName);
end;
 

(*
 * TDataset overrides
 *)
 
procedure TFIBCustomDataSet.DoOnDisableControls(DataSet:TDataSet);
begin
 if Assigned(FOnDisableControls) then FOnDisableControls(Self)
end;

procedure TFIBCustomDataSet.DoOnEnableControls(DataSet:TDataSet);
begin
 if Assigned(FOnEnableControls) then FOnEnableControls(Self)
end;

type
   THack=class(TFIBDatabase);

procedure TFIBCustomDataSet.SetActive(Value: Boolean);
begin
  if Value then
  if (csDesigning  in ComponentState) and (drsInLoaded in FRunState) then
  if Assigned(Database) then
  try
    if not Database.Connected  then
    begin
     if THack(Database).StreammedConnectFail then
      Exit;
     Database.Open(False);
     if not Database.Connected then
       Exit;
    end;
  except
    Exit;
  end;
  inherited SetActive(Value);
 
end;
 
procedure TFIBCustomDataSet.DataEvent(Event: TDataEvent; Info: Longint);
begin
 if Event = deFieldChange then
   if Assigned(FOnFieldChange) then FOnFieldChange(TField(Info));
 vNeedReloadClientBlobs:=Event=deDatasetChange;
 try
  inherited DataEvent(Event,Info);
 if ControlsDisabled then
 begin
  if vControlsEnabled then
  begin
   vControlsEnabled:=False;
   DoOnDisableControls(Self);
  end
 end
 else
 if not vControlsEnabled then
 begin
   vControlsEnabled :=True;
   DoOnEnableControls(Self);
 end;
 finally
  vNeedReloadClientBlobs:=False;
 end
end;
 
procedure TFIBCustomDataSet.SetStateFieldValue(State: TDataSetState; Field: TField;
 const Value: Variant
);
begin
 vPredState:=Self.State;
 inherited SetStateFieldValue(State, Field,Value)
end;

function TFIBCustomDataSet.AllocRecordBuffer: dbPChar;
begin
 Result := AllocMem(FRecordBufferSize);
end;

function TFIBCustomDataSet.BlobModified(Field: TField): boolean;
var 
 fs:  TStream;
begin
 if not Field.IsBlob then
 begin
  Result:=False;  Exit;
 end;
 if  not CachedUpdates then Result:= TBlobField(Field).Modified
 else
 begin
   fs:=CreateBlobStream(Field,bmRead);
   if Assigned(fs) then
   begin
    if Assigned(TFIBDSBlobStream(fs).FBlobStream) then
     Result:=TFIBDSBlobStream(fs).FModified or TFIBDSBlobStream(fs).FBlobStream.Modified
    else
     Result:=TFIBDSBlobStream(fs).FModified;
    fs.Free;
   end
   else
    Result:=False
 end;
end;

function TFIBCustomDataSet.GetRecordFieldInfo(Field: TField;
 var TableName,FieldName:string; var RecordKeyValues:TDynArray
):boolean;
var 
  vPKNames: string;
  vPos: Integer;
  vPKField:TField;
begin
  TableName:=GetRelationTableName(Field);
  FieldName:=GetRelationFieldName(Field);
  vPKNames  :=PrimaryKeyFields(TableName);
  if vPKNames='' then
  begin
   Result := False;
   Exit;
  end
  else
  begin
    SetLength(RecordKeyValues,0);
    vPos:=1;
    while vPos <= Length(vPKNames) do
    begin
     vPKField:=FieldByOrigin(TableName,ExtractFieldName(vPKNames,vPos));
     if vPKField=nil then
     begin
       Result := False;
       Exit;
     end;
     SetLength(RecordKeyValues,Length(RecordKeyValues)+1);
     RecordKeyValues[Length(RecordKeyValues)-1]:=vPKField.Value;
    end;
  end;
  Result := True;
end;
 

function TFIBCustomDataSet.CreateBlobStream(Field: TField; Mode: TBlobStreamMode): TStream;
var
  pb: PBlobDataArray;
  fs,fs1: TFIBBlobStream;
  Buff: dbPChar;
  bTr, bDB: Boolean;
  fOfs  :integer;
  BlobID: TISC_QUAD;
  vTableName:string;
  vFieldName:string;
  vKeyValues:TDynArray;
 
function FillFieldInfo:boolean;
begin
  with  Database.BlobSwapSupport do
  if not Active or (Length(SwapDirectory)=0) then
  begin
    Result := False;
    Exit;
  end;
  Result:=GetRecordFieldInfo(Field,vTableName,vFieldName,vKeyValues);
end;
 
begin
  if not ((Field is TFIBBlobField) and TFIBBlobField(Field ).IsClientField) then
  if (Mode <> bmRead) and (not Field.ReadOnly) then
   CheckEditState;

  case vTypeDispositionField of
   dfNormal:
    case State of 
     dsFilter  :
      begin
       Buff:=AllocRecordBuffer;
       if FCurrentRecord<FRecordCount then
        ReadRecordCache(FCurrentRecord, Buff, False)
       else
        ReadRecordCache(FRecordCount-1, Buff, False);
      end;
    else
     Buff := GetActiveBuf;
    end;
   dfRRecNumber:
     begin
         Buff :=AllocRecordBuffer;
         if State<>dsOldValue then
          ReadRecordCache(vInspectRecno, Buff, False)
         else
          ReadRecordCache(vInspectRecno, Buff, True);
     end;
  end;
 
  if (Buff = nil)  then
  begin
    fs:=nil;
    Result := TFIBDSBlobStream.Create(Field, fs, Mode,BlobID,nil);
    Exit;
  end;
 
 
  try
   pb := PBlobDataArray(Buff + FBlobCacheBufferOffset);
   if (pb^[Field.Offset] = nil) or (vNeedReloadClientBlobs and pb^[Field.Offset].IsClientField)  then
   begin
    fOfs := vFieldDescrList[Field.FieldNo - 1].fdDataOfs;
    BlobID :=PISC_QUAD(@Buff[fOfs])^;
    if (Field is TFIBBlobField)  and (TFIBBlobField(Field).FIsClientCalcField) and (Mode = bmRead) then
    begin
      Field.ReadOnly:=True;
      fs := TFIBBlobStream.CreateNew(Field.FieldNo, FBlobStreamList);
      pb^[Field.Offset] := fs;
      fs.IsClientField:=True;
      if Assigned(FOnFillClientBlob) then
       FOnFillClientBlob(Self,TFIBBlobField(Field),fs);
    end
    else
    begin
      if PRecordData(Buff)^.rdFields[Field.FieldNo].fdIsNull then
      begin
       BlobID.gds_quad_high:=0;
       BlobID.gds_quad_low :=0;
      end;
      if ((PRecordData(Buff)^.rdFields[Field.FieldNo].fdIsNull and (Mode = bmRead))) then
       fs := nil
      else
      begin
        if FillFieldInfo then
         fs :=TFIBBlobStream.CreateNew(Field.FieldNo, FBlobStreamList,
          vTableName, vFieldName, @vKeyValues
         )
        else
         fs := TFIBBlobStream.CreateNew(Field.FieldNo, FBlobStreamList);
 
        pb^[Field.Offset] := fs;
        if Field is TFIBBlobField then
         fs.blobSubType := TFIBBlobField(Field).FSubType
        else
        if Field is TFIBMemoField then
         fs.blobSubType := TFIBMemoField(Field).FSubType
        else
         fs.blobSubType := FQSelect[Field.FieldName].AsXSQLVAR^.sqlsubtype;  // ivan_ra
        fs.Mode := bmReadWrite;
        fs.Database := Database;
        fs.Transaction := Transaction;
        fs.UpdateTransaction := UpdateTransaction;
        fs.BlobID := BlobID;
     end;
    end;

 
    if (CachedUpdates) and Assigned(fs) then
    begin
     bTr := not Transaction.InTransaction;
      bDB := not Database.Connected;
      if bDB then
        Database.Open;
      if bTr then
        Transaction.StartTransaction;
      fs.Seek(0, soFromBeginning);
      if bTr then
        Transaction.Commit;
      if bDB then
        Database.Close;
    end;
    if (State=dsBrowse) and (fs<>nil) then
     WriteRecordCache(PRecordData(Buff)^.rdRecordNumber, Pointer(Buff));
   end
   else
    fs := pb^[Field.Offset];
   if Assigned(fs) then
   begin
    BlobID:=fs.BlobID;
    fs.UpdateTransaction:=UpdateTransaction;

// ����������� �� ���������� ���������� ������
    if (FCacheModelOptions.FBlobCacheLimit>0) then
    begin
       fOfs:=FOpenedBlobStreams.IndexOf(fs);
       if fOfs>=0 then
       begin
          FOpenedBlobStreams.Delete(fOfs);
       end;
       FOpenedBlobStreams.Add(fs); // ��������� ������������ ����� � ����� ������
 
      if (FOpenedBlobStreams.Count>FCacheModelOptions.FBlobCacheLimit)  then
      begin
//
       fs1:=TFIBBlobStream(FOpenedBlobStreams[0]);
       fs1.DeInitialize;
       FOpenedBlobStreams.Delete(0);       
      end;
    end
   end;
//
   Result := TFIBDSBlobStream.Create(Field, fs, Mode,BlobID,pb);
  finally
   if (State in [dsFilter]) or (vTypeDispositionField<>dfNormal)
   then
    FreeRecordBuffer(Buff);
  end;
end;
 
function TFIBCustomDataSet.CompareBookmarks(Bookmark1, Bookmark2: TBookmark): Integer;
const
  RetCodes: array[Boolean, Boolean] of ShortInt = ((2, -1),(1, 0));
var
    R1,R2:  Integer;
begin
  Result := RetCodes[Bookmark1 = nil, Bookmark2 = nil];
  if Result = 2 then  // Both bookmarks are initialized
  begin
    with FRecordsCache do
    begin
      R1:= RecordByBookMark(PFIBBookmark(Bookmark1)^.bRecordNumber);
      R2:= RecordByBookMark(PFIBBookmark(Bookmark2)^.bRecordNumber);
    end;
    if R1 < R2  then
     Result := -1
    else
    if R1 > R2 then
     Result := 1
    else
     Result := 0;
  end;
end;
 
procedure TFIBCustomDataSet.CacheDelete;
begin
 try
  Include(FRunState,drsInCacheDelete);
  FilterOut(Self);
 finally
  Exclude(FRunState,drsInCacheDelete);
 end
end;
 
procedure TFIBCustomDataSet.CacheOpen;
begin
 if Active then Close;
 FCachedActive:=True;
 Open;
end;

procedure TFIBCustomDataSet.RefreshClientFields(ForceCalc:boolean=True);
var 
  b: TBookmark;
  CurEof:boolean;
begin
   if IsEmpty then
   begin
     First;
     Exit;
   end;

   b:=Bookmark;
   CurEof:=Eof;
   DisableControls;
   DisableScrollEvents;
   if ForceCalc then
    Include(FRunState,drsInRefreshClientFields);
   try
    Bookmark:=b;
    if CurEof then
     Next; // Restore Eof Flag only
   finally
    if ForceCalc then
     Exclude(FRunState,drsInRefreshClientFields);
    EnableScrollEvents;
    EnableControls
   end;
end;

function  TFIBCustomDataSet.CanCloneFromDataSet(DataSet:TFIBCustomDataSet):boolean;
var i :integer;
begin
  Result:=FieldCount=DataSet.FieldCount;
  if not Result then Exit;
  for i:=FieldCount-1 downto 0 do
  with DataSet.Fields[i] do
  begin
   Result:=
    (Fields[i].DataType=DataType) and
    (Fields[i].Size=Size) and
    (Fields[i].FieldKind=FieldKind) and
    not (DataType in [ftBlob,ftBytes])
    ;
   if not Result then Exit;      
  end;
end;

function TFIBCustomDataSet.CreateCalcFieldAs(Field:TField):TField;
begin
  Result:=TFieldClass(Field.ClassType).Create(Owner);
  with Result do
  begin
    Size:=Field.Size;
    FieldKind:=Field.FieldKind;
    FieldName:=Field.FieldName;
    Lookup:=Field.Lookup;
    KeyFields:=Field.KeyFields;
    LookupDataSet:=Field.LookupDataSet;
    LookupResultField:=Field.LookupResultField;
    LookupKeyFields:=Field.LookupKeyFields;
    DataSet:=Self;
  end;
end;
 
function  TFIBCustomDataSet.IsDBKeyField(Field:TObject):boolean;
var
   fn:  integer;
begin
   if Field is TField then
    fn:=TField(Field).FieldNo-1
   else
   if Field is TFieldDef then
     fn:=TFieldDef(Field).FieldNo-1
   else
   begin
     Result := False;
     Exit;
   end;
   Result:=FQSelect.Prepared and (FQSelect.FieldCount>fn) and
    (FQSelect.Fields[fn].SqlName='DB_KEY')
end;

procedure TFIBCustomDataSet.AssignProperties(Source:TFIBCustomDataSet);
begin
 CheckDatasetClosed('Can''t assign properties');
 CopyProps(Source,Self);
end;

procedure TFIBCustomDataSet.CopyFieldsProperties(Source,Destination:TFIBCustomDataSet);
var
   i: integer;
   fc:integer;
   f,f1:TField;
begin
  if (Source=nil) or (Destination=nil) or (Source=Destination) then Exit;
  fc:=Source.FieldCount-1;
  for i:=0 to fc do
  begin
      f :=Source.Fields[i];
      f1:=Destination.FindField(f.FieldName);
      if f1=nil then
       Continue;
      with f1 do
      begin
        AutoGenerateValue:=f.AutoGenerateValue;
        ConstraintErrorMessage:=f.ConstraintErrorMessage;
        CustomConstraint:=f.CustomConstraint;
        Tag:=f.Tag;
        Index:=f.Index;
        EditMask:=f.EditMask;
        DisplayWidth:=f.DisplayWidth;
        DisplayLabel:=f.DisplayLabel;
        Required:=f.Required;
        ReadOnly:=f.ReadOnly;
        Visible:=f.Visible;
        DefaultExpression:=f.DefaultExpression;
        Alignment:=f.Alignment;
      end;
      if (f is TNumericField) and (f1 is TNumericField) then
      with TNumericField(f1) do
      begin
        DisplayFormat:=TNumericField(f).DisplayFormat;
        EditFormat   :=TNumericField(f).EditFormat;
      end;
 
      if (f is TIntegerField) and (f1 is TIntegerField) then
      with TIntegerField(f1) do
      begin
           MaxValue:=TIntegerField(f).MaxValue;
           MinValue:=TIntegerField(f).MinValue;
      end;
 
      if (f is TDateTimeField) and (f1 is TDateTimeField) then
        TDateTimeField(f1).DisplayFormat:=TDateTimeField(f).DisplayFormat;
      if (f is TBooleanField) and (f1 is TBooleanField) then
        TBooleanField(f1).DisplayValues:=TBooleanField(f).DisplayValues;
      if (f is TFloatField) and (f1 is TFloatField) then
       with TFloatField(f1) do
       begin
            MaxValue :=TFloatField(f).MaxValue;
            MinValue :=TFloatField(f).MinValue;
            Precision:=TFloatField(f).Precision;
            currency :=TFloatField(f).currency;
       end;
 
     if (f is TBCDField) and (f1 is TBCDField) then
      with TBCDField(f1) do
      begin
        MaxValue:=TBCDField(f).MaxValue;
        MinValue:=TBCDField(f).MinValue;
        Precision:=TBCDField(f).Precision;
        currency:=TBCDField(f).currency;
      end;
  end;
end;
 
procedure TFIBCustomDataSet.CopyFieldsStructure(Source:TFIBCustomDataSet;RecreateFields:boolean);
var 
   i: integer;
begin
     if Source=nil then
      Exit;
     CheckInactive;
     Source.FieldDefs.Update;
     FieldDefs.Assign(Source.FieldDefs);
{     for i:=FieldDefs.Count-1 downto 0 do
       if (FieldDefs.Items[i].DataType in [ftBlob,ftBytes]) then
          FieldDefs.Items[i].Free;             }
     if RecreateFields then
     begin
       DestroyFields;  CreateFields;  BindFields(True);
       if not Source.DefaultFields then
       begin
        for  i:= FieldCount-1 downto 0 do
         if Source.FindField(Fields[i].FieldName)=nil then
          Fields[i].Free;
 
        for i:=0 to Source.FieldCount-1 do
         if (Source.Fields[i].FieldKind in [fkLookup,fkCalculated]) then
              CreateCalcFieldAs(Source.Fields[i]);
       end;
     end;
     CopyFieldsProperties(Source,Self);
end;

procedure TFIBCustomDataSet.Clone(DataSet:TFIBCustomDataSet; RecreateFields:boolean);
begin
 Close;
 DataSet.CheckActive;
 Include(FRunState,drsInClone);
 DisableControls;
 try
  CopyFieldsStructure(DataSet,RecreateFields);
  vFieldDescrList.Assign(DataSet.vFieldDescrList);
  vrdFieldCount     := DataSet.vrdFieldCount;
  FBufferChunkSize  := DataSet.FBufferChunkSize;
  FRecordSize       := DataSet.FRecordSize;
  FCalcFieldsOffset := DataSet.FCalcFieldsOffset;
  FBlobCacheBufferOffset  := DataSet.FBlobCacheBufferOffset ;
  FRecordBufferSize := DataSet.FRecordBufferSize;
  FRecordCount      := DataSet.FRecordCount;
  FStringFieldCount := DataSet.FStringFieldCount;
  FBlockReadSize    := DataSet.FBlockReadSize;
  if not Assigned(FRecordsCache) then
   FRecordsCache:=
    TRecordsCache.Create(FCacheModelOptions.FBufferChunks,FRecordBufferSize,FBlockReadSize,FStringFieldCount);
  FRecordsCache.Assign(DataSet.FRecordsCache);

  if (Filter <> '') and not Assigned(FFilterParser) then
     ExprParserCreate(FastTrim(Filter),FilterOptions) ;
 
  Open;
  Recno:=DataSet.Recno;
  RefreshClientFields(False);
 finally
  EnableControls;
  Exclude(FRunState,drsInClone);
 end;
end;

procedure TFIBCustomDataSet.OpenAsClone(DataSet:TFIBCustomDataSet);
begin
  if DefaultFields then
    Clone(DataSet,True)
  else
  begin
    if not CanCloneFromDataSet(DataSet) then
    begin
      Close;
     raise Exception.Create(
       Format(SFIBErrorCloneCursor, [CmpFullName(Self), CmpFullName(DataSet)])
     );
    end;
    Clone(DataSet,True)
  end;
end;

 
procedure TFIBCustomDataSet.DoSortEx(Fields: TStrings; Ordering: array of Boolean);
var 
    vFields : array of TVarRec;
    i:integer;
begin
  SetLength(vFields,Fields.Count);
  for i:=0 to Fields.Count-1 do
    vFields[i].VInteger:=FBN(Fields[i]).Index;
  DoSort(vFields,Ordering);
end;
 
procedure TFIBCustomDataSet.DoSortEx(Fields: array of integer; Ordering: array of Boolean);
var 
    vFields : array of TVarRec;
    i:integer;
begin
  SetLength(vFields,High(Fields)+1);
  for i:=0 to High(Fields) do   vFields[i].VInteger:=Fields[i];
  DoSort(vFields,Ordering);
end;
 
 
procedure TFIBCustomDataSet.DoSort(Fields: array of const;
  Ordering: array of Boolean);
begin
 if State in [dsEdit,dsInsert] then
   Post;
 try
  Include(FRunState,drsInSort );
  Sort(Self,Fields,Ordering);
 finally
  Exclude(FRunState,drsInSort );
  RefreshFilters
 end;
end;

function TFIBCustomDataSet.FieldByRelName(const FName:string):TField;
var 
   j: integer;

begin
  Result:=nil;
  if Length(FName)=0 then
   Exit;
  for j:=0 to Pred(FieldCount) do
   if IsEquelSQLNames(GetRelationFieldName(Fields[j]),FName) then
   begin
    Result:=Fields[j];
    Exit
   end;
end;
 
procedure TFIBCustomDataSet.RestoreMacroDefaultValues;
begin
  FQSelect.RestoreMacroDefaultValues
end;
 
function  TFIBCustomDataSet.PrimaryKeyFields(const TableName: string): string;
var
  PrimKeyFields:  string;
  i, wc: integer;
  vField:TFIBXSQLVAR;
  tf:TField;
begin
  Result := '';
  PrimKeyFields :=
   FastTrim(ListTableInfo.GetTableInfo(Database, TableName, False).PrimaryKeyFields[Database]);
  if PrimKeyFields = '' then
    Exit;
  wc := WordCount(PrimKeyFields, [';']);
  if FieldCount>0 then
  for i := 1 to wc do
  begin
    tf:=FieldByOrigin(TableName,ExtractWord(i, PrimKeyFields, [';']));
    if tf=nil then
    begin
      Result := '';
      Exit;
    end;
    Result := Result + iifStr(i > 1, ';', '') + tf.FieldName;
  end
  else
  for i := 1 to wc do
  begin
    vField:=FQSelect.FieldByOrigin(TableName,ExtractWord(i, PrimKeyFields, [';']));
    if vField=nil then
    begin
      Result := '';
      Exit;
    end;
    Result := Result + iifStr(i > 1, ';', '') + vField.Name;
  end;
end;

procedure  TFIBCustomDataSet.PrepareAdditionalInfo;
var i,oc,fi:integer;
    tf:TField;
    SQLText:string;
    tmpStr:string;
begin
 if  drsInClone in FRunState then
  Exit;

  if  (poPersistentSorting in Options) and
     not VarIsNull(FSortFields) and FIsClientSorting
  then
   Exit;
  if VarIsNull(FSortFields) or not FIsClientSorting then
  begin
    SQLText:=ReadySelectText;
    FSortFields:=GetOrderInfo(SQLText);

    if varIsNull(FSortFields) then
     Exit;
    oc:=VarArrayHighBound(FSortFields,1);
    for i:=0 to oc do
    begin
     fi:=StrToIntDef(FSortFields[i,0],0);
     if fi>0 then
     begin
      tf:=FieldByNumber(fi);
      if tf<>nil then
      begin
       FSortFields[i,0]:= tf.FieldName
      end
      else
       FSortFields[i,0]:= 'NotPresented'
     end
     else
     begin
      tmpStr:=FSortFields[i,0];

      fi:=PosCh('.',tmpStr);
      if fi<>0 then
      begin
       tf:=FieldByOrigin(tmpStr);
       if tf=nil then
        tf:=FieldByOrigin(
         FullFieldName(SQLText,tmpStr));
      end
      else
      begin
       tf:=FieldByRelName(tmpStr);
      end;
      if tf=nil then
      begin
       if FCacheModelOptions.FCacheModelKind=cmkLimitedBufferSize then
        FIBErrorEx(
        '%s.'#13#10+
        'Field %s use in order, but not presented in fields section of SelectSQL',
        [CmpFullName(Self),tmpStr]
        );
       FIsClientSorting:=False;
       FSortFields:=null;
       Exit
      end
      else
      begin
       FSortFields[i,0]:=tf.FieldName;
      end;
     end;
    end;
  end;
  FIsClientSorting:=False;
end;
 
procedure TFIBCustomDataSet.DoBeforeOpen;   //override;
begin
  if DisableCOCount>0 then
   Exit;
  inherited DoBeforeOpen
end;

procedure TFIBCustomDataSet.DoBeforeClose;  //override;
var
   i:  integer;
begin
  if DefaultFields then
  begin
    FFNFields.Clear;
    if Assigned(FFilterParser) then
     FFilterParser.ResetFields;
  end;

  if DisableCOCount>0 then Exit;
  inherited DoBeforeClose;
  for i:=0 to Pred(vBeforeCloseEvents.Count) do
  begin
   vBeforeCloseEvents.Event[i](Self)
  end;

end;

procedure TFIBCustomDataSet.DoAfterClose;  //override;
begin
  if DisableCOCount>0 then Exit;
  inherited DoAfterClose;
  if poFreeHandlesAfterClose in Options then
   UnPrepare;
end;

procedure  TFIBCustomDataSet.DoAfterOpen;
 
var 
    i,L : integer;
    arr1 : array of TVarRec;
    arr2 : array of boolean;
 
 
begin
  if not (csDesigning in ComponentState) and (FFieldOriginRule<>forNoRule) then
   for i:=0 to Pred(FieldCount) do
    Fields[i].Origin:=GetFieldOrigin(Fields[i]);
 
  FRelationTables.Clear;
  for i:=0 to Pred(FieldCount) do
   if Fields[i].FieldKind = fkData then
    FRelationTables.Add(GetRelationTableName(Fields[i]));
 
  if FIsClientSorting and vSelectSQLTextChanged then
  begin
    if not (poPersistentSorting in Options) or
       not SortInfoIsValid
    then
    begin
     FSortFields :=null;
     FIsClientSorting:=False;
    end;
  end;
  inherited;
  if poFetchAll in Options then
   FetchAll;
  if Filtered and Assigned(FFilterParser) and (FFilterParser.ExpressionText<>Filter)
  then
    Filter:=Filter;
  vSelectSQLTextChanged  :=False;
  if Assigned(vTimerForDetail) then
   vTimerForDetail.Enabled:=False;
  if (poPersistentSorting in Options)  then
  begin
    if not FIsClientSorting then
     Exit;
    L:=SortFieldsCount;
    SetLength(arr1,L);
    SetLength(arr2,L);
    Dec(L);
    for i:=0 to L do
    begin
      arr1[i].VInteger:=FindField(FSortFields[i,0]).Index;
      arr2[i]:=FSortFields[i,1]
    end;
    DoSort(arr1,arr2);
    First;
  end
  else
  if not (psGetOrderInfo in PrepareOptions) then
     FSortFields:=null;
end;

procedure TFIBCustomDataSet.DoBeforeCancel;
begin
  inherited;
  if not Active then
   FIBError(feDatasetClosed , ['continue after BeforeCancel',
    CmpFullName(Self)]
   )
end;
 
procedure TFIBCustomDataSet.DoAfterCancel;
begin
   inherited;
end;

procedure TFIBCustomDataSet.DoBeforeDelete;
begin
  ForceEndWaitMaster;
  if  not CanDelete then
   Abort;
  if not CachedUpdates then
   SaveOldBuffer(GetActiveBuf)
  else
  if TCachedUpdateStatus(PRecordData(GetActiveBuf)^.rdFlags and 7)=cusUnmodified then
   SaveOldBuffer(GetActiveBuf);
  inherited;
  if not Active then
   FIBError(feDatasetClosed , ['continue after BeforeDelete',
    CmpFullName(Self)]
   )
end;
 
procedure TFIBCustomDataSet.ForceEndWaitMaster;
begin
  if (DataSource=nil) or (DataSource.Dataset=nil) then Exit;
  if WaitEndMasterScroll then
  begin
    if(DataSource.Dataset is TFIBCustomDataSet) then
     TFIBCustomDataSet(DataSource.Dataset).ForceEndWaitMaster;
    if  MasterFieldsChanged then DoCloseOpen(nil);
    if Assigned(vTimerForDetail) then
     vTimerForDetail.Enabled:=False;
  end
end;
 
procedure TFIBCustomDataSet.DoBeforeEdit;
var 
  Buff:  PRecordData;
  {$IFDEF SUPPORT_ARRAY_FIELD}
  i:integer;
  {$ENDIF}
begin
  ForceEndWaitMaster;
  if not CanEdit then Abort;
  Buff := PRecordData(GetActiveBuf);
  if not CachedUpdates or (TCachedUpdateStatus(Buff^.rdFlags and 7) =cusUnModified) then
   SaveOldBuffer(dbPChar(Buff));
  inherited;
  if not Active then
   FIBError(feDatasetClosed , ['continue after BeforeEdit',CmpFullName(Self)]);
 
  {$IFDEF SUPPORT_ARRAY_FIELD}
   for i:=0 to Pred(FieldCount) do
   begin
    if Fields[i] is TFIBArrayField then
     TFIBArrayField(Fields[i]).SaveOldBuffer
   end;
  {$ENDIF}

end;

procedure TFIBCustomDataSet.DoBeforePost; //override;
begin
  if State in [dsEdit,dsInsert] then
   inherited DoBeforePost;
  if not Active then
   FIBError(feDatasetClosed , ['continue after BeforeDelete',
    CmpFullName(Self)]
  );
end;
 
procedure TFIBCustomDataSet.DoBeforeInsert;
begin
  if not CanInsert then Abort;
  inherited;
end;


procedure TFIBCustomDataSet.DoAfterScroll;
begin
 if vDisableScrollCount=0 then
 begin
   inherited;
   if Assigned(vScrollTimer) then
   with vScrollTimer do
   begin
     Enabled:=False;
     Enabled:=True;
   end;
 end;
end;

procedure TFIBCustomDataSet.DoBeforeScroll;
begin
 if vDisableScrollCount=0 then
  inherited;
end;

procedure TFIBCustomDataSet.DoOnEndScroll(Sender:TObject);
begin
 if Assigned(vScrollTimer) then
  vScrollTimer.Enabled:=False;
 if Assigned(FOnEndScroll) then FOnEndScroll(Self);
end;

procedure TFIBCustomDataSet.DisableScrollEvents;
begin
 Inc(vDisableScrollCount)
end;

procedure TFIBCustomDataSet.EnableScrollEvents;
begin
 if vDisableScrollCount>0 then
  Dec(vDisableScrollCount)
end;

procedure TFIBCustomDataSet.DisableCloseOpenEvents;
begin
  Inc(FDisableCOCount)
end;

procedure TFIBCustomDataSet.EnableCloseOpenEvents;
begin
 if FDisableCOCount>0 then
  Dec(FDisableCOCount)
end;
 
 
procedure TFIBCustomDataSet.DisableCalcFields;
begin
  Inc(FDisableCalcFieldsCount)
end;

procedure TFIBCustomDataSet.EnableCalcFields;
begin
 if FDisableCalcFieldsCount>0 then
 begin
  Dec(FDisableCalcFieldsCount);
  if FDisableCalcFieldsCount=0 then
   RefreshClientFields(False);
 end;
end;

procedure  TFIBCustomDataSet.DoAfterInsert;
{$IFDEF SUPPORT_ARRAY_FIELD}
var i:integer;
{$ENDIF}
begin
  {$IFDEF SUPPORT_ARRAY_FIELD}
   for i:=0 to Pred(FieldCount) do
   begin
    if Fields[i] is TFIBArrayField then
     TFIBArrayField(Fields[i]).SaveOldBuffer
   end;
  {$ENDIF}
  inherited;
end;

procedure TFIBCustomDataSet.DoOnPostError(DataSet: TDataSet; E: EDatabaseError;
 var Action: TDataAction
);
{$IFDEF SUPPORT_ARRAY_FIELD}
var     i:integer;
{$ENDIF}
begin
  {$IFDEF SUPPORT_ARRAY_FIELD}
  for i:=0 to Pred(FieldCount) do
  begin
    if Fields[i] is TFIBArrayField then
     TFIBArrayField(Fields[i]).RestoreOldBuffer
  end;
  {$ENDIF}
end;
 
procedure TFIBCustomDataSet.DoAfterDelete;  //override;
begin
 inherited;
 if
  (dcForceMasterRefresh in FDetailConditions)  and not CachedUpdates
 then
  RefreshMasterDS;
end;
 
 
 
procedure TFIBCustomDataSet.DoAfterPost;
begin
 inherited;
end;
 
procedure TFIBCustomDataSet.MoveRecord(OldRecno,NewRecno:integer);
begin
  if NewRecno<1 then NewRecno:=1;
  if NewRecno>FRecordCount then
  begin
    FetchAll;
    if NewRecno>FRecordCount then
     NewRecno:=FRecordCount;
  end;
  FRecordsCache.MoveRecord(OldRecno-1,NewRecno-1);
  Resync([]);
end;

 
function  TFIBCustomDataSet.SetRecordPosInBuffer(NewPos:integer):integer;
var
  Distance: integer;
  MoveDistance:integer;
begin
  Distance:=NewPos-ActiveRecord;
  Result := ActiveRecord;
  if Distance=0 then
   Exit
  else
  if Distance>0 then
   MoveDistance:=-Distance-ActiveRecord
  else
   MoveDistance:=BufferCount-NewPos-1;
  DisableScrollEvents;
  DisableControls;
  try
   MoveDistance:=MoveBy(MoveDistance);
   MoveBy(-MoveDistance);
   Result:=ActiveRecord
  finally
   EnableScrollEvents;
   EnableControls;
  end;
end;

function  TFIBCustomDataSet.NeedMoveRecordToOrderPos:boolean;
var
 i:  integer;
 OrderFieldsCount:integer;
 fn:string;
 CalculateFieldsForced:boolean;
begin
   if not Sorted then
    Result := False
   else
   if not (poKeepSorting in FOptions) and
    (FCacheModelOptions.CacheModelKind<>cmkLimitedBufferSize)
   then
     Result := False
   else
   begin
     OrderFieldsCount:=VarArrayHighBound(FSortFields,1)+1;
     fn:=FSortFields[0,0];
     if OrderFieldsCount=1 then
     with FBN(fn) do
     begin
      if FieldKind in [fkCalculated,fkLookUp] then
      begin
       GetCalcFields(ActiveBuffer);
      end;
      Result:=Value<>OldValue
     end
     else
     begin
      Result := False;
      CalculateFieldsForced:=False;
      for i := 0 to OrderFieldsCount-1 do
      begin
        fn:=FSortFields[i,0];
        with FBN(fn) do
        begin
          if (FieldKind in [fkCalculated,fkLookUp]) and not CalculateFieldsForced then
          begin
           GetCalcFields(ActiveBuffer);
           CalculateFieldsForced:=True;
          end;
          Result:= Value<>OldValue;
        end;
        if Result then
         Exit;
      end;
     end;
   end;
end;

function  TFIBCustomDataSet.AllFieldValues:variant;
var
  I: Integer;
begin
  Result := VarArrayCreate([0, Fields.Count - 1], varVariant);
  for I := 0 to Fields.Count - 1 do
    Result[I] := Fields[I].Value;
end;
 
procedure TFIBCustomDataSet.MoveRecordToOrderPos;
var i,l:integer;
    KeyValues:Variant;
    OldVisibleRecno :boolean;
    OldFiltered     :boolean;
    OldActiveRecord :integer;
    OrderFieldsCount:integer;
    ForcedCalculateFields:boolean;
    Found:boolean;
    OldFValues:variant;
begin
 if IsEmpty then
   Exit;
 OldVisibleRecno:=poVisibleRecno in Options;
 OldFiltered    :=Filtered;
 if Sorted then
 if not (poKeepSorting in Options) then
  FSortFields:=null
 else
 try
   Include(FRunState,drsInMoveRecord);
   OldActiveRecord:=ActiveRecord;
   DisableControls;
   DisableScrollEvents;
   Options:=Options-[poVisibleRecno];
   vIgnoreLocReno:=Recno;
   if OldFiltered then
   begin
    Filtered:=False;
    First;
    Recno:=vIgnoreLocReno
   end;
   OrderFieldsCount:=VarArrayHighBound(FSortFields,1)+1;
   if OrderFieldsCount=1 then
   begin
    with FBN(FSortFields[0,0]) do
    begin
     if FieldKind in [fkCalculated,fkLookUp] then
      GetCalcFields(ActiveBuffer);
     KeyValues:=Value
    end;
   end
   else
   begin
    KeyValues:=VarArrayCreate([0,OrderFieldsCount-1],varVariant);
    ForcedCalculateFields:=False;
    for i := 0 to OrderFieldsCount-1 do
      with FBN(FSortFields[i,0]) do
      begin
       if (FieldKind in [fkCalculated,fkLookUp]) and not ForcedCalculateFields then
       begin
         GetCalcFields(ActiveBuffer);
         ForcedCalculateFields:=True
       end;
        KeyValues[i]:=Value;
      end;
   end;
   OldFValues:=AllFieldValues;
   Found:=ExtLocate(SortedFields,KeyValues,[eloInSortedDS,eloNearest]);
   if Found then
     Found:=  EasyCompareVarArray1(OldFValues,AllFieldValues,VarArrayHighBound(OldFValues,1));
     if not Found then
     begin
       if (Recno>vIgnoreLocReno) and (not Eof) then
        L:=Recno-1
       else
        L:=Recno;
       if L <> vIgnoreLocReno then
       begin
         MoveRecord(vIgnoreLocReno,L);
         Recno:=L;
       end
       else
        Recno:=vIgnoreLocReno;
   end;
   SetRecordPosInBuffer(OldActiveRecord);
   Inc(vLockResync);
 finally
   Exclude(FRunState,drsInMoveRecord);
   EnableScrollEvents;
   EnableControls;
   vIgnoreLocReno:=-1;
   Filtered:=OldFiltered;
   if OldVisibleRecno then
    Options:=Options+[poVisibleRecno];
 end;
end;

procedure TFIBCustomDataSet.FetchAll;
var
  CurBookmark:  TBookmark;
  iCurScreenState: Integer;
begin
  ChangeScreenCursor(iCurScreenState);
  try
    if FQSelect.Eof or not FQSelect.Open then
     Exit;
    DisableControls;
    DisableScrollEvents;
    try
      CurBookmark := Bookmark;
      Last;
      Bookmark    := CurBookmark;
    finally
      EnableControls;
      EnableScrollEvents;
    end;
  finally
   RestoreScreenCursor(iCurScreenState);
  end;
end;
 
(*
 * Free up the record buffer allocated by TDataset
 *)
procedure TFIBCustomDataSet.FreeRecordBuffer(var Buffer: dbPChar);
begin
  FreeMem(Buffer);
  Buffer := nil;
end;

procedure TFIBCustomDataSet.PrepareQuery(KindQuery: TpSQLKind);
var
  Qry:  TFIBQuery;
  OldUpdateTransaction: TFIBTransaction;
  ForceStartTransaction:boolean;
begin
  case KindQuery of
    skModify: Qry := QUpdate;
    skInsert: Qry := QInsert;
    skDelete: Qry := QDelete;
  else
    Qry := QRefresh;
  end;
  try
    if not EmptyStrings(Qry.SQL) and
      (not Qry.Prepared) and
      (Qry.SQL[0]<>SNoAction)
    then
    begin
      if not Assigned(Qry.Transaction)  then
       FIBError(feTransactionNotAssigned, [CmpFullName(Qry)]);
      if not Assigned(Transaction)  then
       FIBError(feTransactionNotAssigned, [CmpFullName(Self)]);

      if Qry.Transaction.MainDatabase=Database then
      begin
        OldUpdateTransaction := Qry.Transaction;
        try
          Qry.Transaction := Transaction;
          StartTransaction;
          Qry.Prepare;
        finally
          Qry.Transaction := OldUpdateTransaction
        end;
      end
      else
      begin
        ForceStartTransaction:=not Qry.Transaction.InTransaction;
        if ForceStartTransaction then
          Qry.Transaction.StartTransaction;
        Qry.Prepare;
        if ForceStartTransaction then
         Qry.Transaction.Commit;
      end;
    end;
  except
    on E: Exception do
      if (E is EFIBInterbaseError) and
        (EFIBInterbaseError(E).sqlcode = sqlcode_notpermission) and
        FIBHideGrantError and   not (csDesigning in ComponentState)
      then
      begin
        if KindQuery<>skRefresh then
         FAllowedUpdateKinds := FAllowedUpdateKinds - [TUpdateKind(KindQuery)];
        Abort;
      end
      else
        raise;
  end;
end;

procedure TFIBCustomDataSet.PrepareBookMarkSize;
var 
   i,oc:  integer;
   tf:TField;
   Pos: Integer;

begin
 if VarIsNull(FSortFields) then
   FIBErrorEx('%s:Can''t find or parse ORDER BY statement.',[CmpFullName(Self)]);

 if not Assigned(FKeyFieldsForBookMark) then
      FKeyFieldsForBookMark:=TStringList.Create
 else
   FKeyFieldsForBookMark.Clear;
 
 BookMarkSize:=2*SizeOf(Integer);
 if Length(FAutoUpdateOptions.KeyFields)= 0 then
 begin
   oc:=VarArrayHighBound(FSortFields,1);
   for i:=0 to oc do
   begin
     tf:=FN(FSortFields[i,0]);
     if Assigned(tf) then
     begin
       FKeyFieldsForBookMark.AddObject(tf.FieldName,
        TObject(BookMarkSize)
       );
       if tf is TFIBStringField then
        BookMarkSize:=BookMarkSize+SizeOf(Boolean)+tf.DataSize-1
       else
        BookMarkSize:=BookMarkSize+SizeOf(Boolean)+tf.DataSize;
     end;
   end;
 end
 else
 begin
    Pos := 1;
    while Pos <= Length(FAutoUpdateOptions.KeyFields) do
    begin
      tf:= FN(ExtractFieldName(FAutoUpdateOptions.KeyFields, Pos));
      if Assigned(tf)  then
      begin
        FKeyFieldsForBookMark.AddObject(tf.FieldName,TObject(BookMarkSize));
        BookMarkSize:=BookMarkSize+SizeOf(Boolean)+tf.DataSize
      end;
    end;
 end;
end;
 
procedure TFIBCustomDataSet.GetBookmarkData(Buffer: dbPChar; Data: Pointer);
var
   i:  integer;
   fi:PFIBFieldDescr;
   tf:TField;
   PIsNull:PAnsiChar;
   FieldSize:integer;
begin
  if not IsEmpty then
  begin
    FillChar(Data^,BookMarkSize,0);
    with PFIBBookmark(Data)^ do
    begin
      bRecordNumber:=FRecordsCache.BookMarkByRecord(PRecordData(Buffer)^.rdRecordNumber);
      bActiveRecord:=ActiveRecord;
    end;
    if  (FCacheModelOptions.CacheModelKind=cmkLimitedBufferSize) then
    begin
        for i:=0 to Pred(FKeyFieldsForBookMark.Count) do
        begin
          tf:=FN(FKeyFieldsForBookMark[i]);
          if Assigned(tf) then
          begin
            if (tf is TFIBStringField) then
             FieldSize:=tf.DataSize-1
            else
             FieldSize:=tf.DataSize;

            PIsNull:=PAnsiChar(Data)+Integer(FKeyFieldsForBookMark.Objects[i]);
            if PRecordData(Buffer)^.rdFields[tf.FieldNo].fdIsNull then
             PBoolean(PIsNull)^:=True
            else
            begin
             PBoolean(PIsNull)^:=False;
             fi:=vFieldDescrList[tf.FieldNo-1];
             Move(
              PAnsiChar(Buffer + fi^.fdDataOfs)^, PAnsiChar(PIsNull+SizeOf(Boolean))^,
              FieldSize
             );
            end;
          end;
        end;
    end;
  end;
end;

function TFIBCustomDataSet.GetBookmarkFlag(Buffer: dbPChar): TBookmarkFlag;
begin
  Result := PRecordData(Buffer)^.rdBookmarkFlag;
end;

function TFIBCustomDataSet.GetCanModify: Boolean;
begin
  Result := CanEdit or CanInsert or CanDelete
end;

function TFIBCustomDataSet.GetCurrentRecord(Buffer: dbPChar): Boolean;
begin
 if not IsEmpty and (GetBookmarkFlag(ActiveBuffer) = bfCurrent)  then
 begin
    UpdateCursorPos;
    ReadRecordCache(PRecordData(ActiveBuffer)^.rdRecordNumber, Buffer, False);
    Result := True;
 end
 else
    Result := False;
end;

function TFIBCustomDataSet.GetDataSource: TDataSource;
begin
  if FSourceLink = nil then
    Result := nil
  else
    Result := FSourceLink.DataSource;
end;

function TFIBCustomDataSet.GetFieldClass(FieldType: TFieldType): TFieldClass;
begin
  Result:=nil;
  if (FieldType<=ftTypedBinary) then
   Result := DefaultFieldClasses[FieldType]
  else
  case FieldType of
   ftGuid:      Result :=  TFIBGuidField;
   ftWideString:Result :=  TFIBWideStringField;
   ftLargeint  :Result :=  TFIBLargeIntField;
  {$IFDEF SUPPORT_ARRAY_FIELD}
   ftBytes : Result :=  TFIBArrayField;
  {$ENDIF}
   ftWideMemo : Result := TFIBMemoField;
  end;
end;




function  TFIBCustomDataSet.RecordFieldValue(Field:TField;RecNumber:integer):Variant;
var
   P,P1: Pointer;
   fi:PFIBFieldDescr;
   NeedRecalcField:boolean;
   tmpCurrency:Currency;
   tmpDateTime:TDateTime;
   {$IFNDEF D6+}
    ws:WideString;
   {$ENDIF}
begin
  CheckActive;
  case FCacheModelOptions.FCacheModelKind of
   cmkStandard:
   begin
    if FRecordCount<RecNumber then
     FetchNext(RecNumber-FRecordCount+1);
    if FRecordCount<RecNumber then
     raise Exception.Create(CmpFullName(Self)+'.'+'Can''t read record '+IntToStr(RecNumber));
    if  Unidirectional then
     RecNumber:=RecNumber mod FCacheModelOptions.FBufferChunks
   end;
   cmkLimitedBufferSize:
   begin
    if (RecNumber-1<=vPartition.EndPartRecordNo) and (RecNumber-1>=vPartition.BeginPartRecordNo) then
     RecNumber:=RecNumber mod FCacheModelOptions.FBufferChunks
    else
     raise Exception.Create(CmpFullName(Self)+'.'+'Can''t read record '+IntToStr(RecNumber));
   end;
  end;
  NeedRecalcField:=Field.FieldKind in [fkCalculated, fkLookup];
  if NeedRecalcField then
   NeedRecalcField:= not vCalcFieldsSavedCache or
    not GetBit(PSavedRecordData(FRecordsCache.PRecBuffer(RecNumber,False))^.rdFlags,7);
  if NeedRecalcField then
  begin
    vInspectRecno:=RecNumber-1;
    try
      vTypeDispositionField:=dfRRecNumber;
      Result:=Field.Value;
    finally
      vTypeDispositionField:=dfNormal
    end;
  end
  else
  begin
    if Field.FieldNo>0 then
     begin
      fi:=vFieldDescrList[Field.FieldNo-1];
      P:=FRecordsCache.GetFieldData(RecNumber,fi^.fdDataOfs-DiffSizesRecData,fi^.fdStrIndex,P1);
      if PSavedRecordData(P1).rdFields[Field.FieldNo].fdIsNull then
      begin
       Result:=Null;
       Exit;
      end;

      if p=nil then
       Result:=Null
      else
      case fi^.fdDataType of
       SQL_VARYING,SQL_TEXT:
       begin
        if fi^.fdIsSeparateString then
        begin
          case Field.DataType of
            ftString :
            Result:=PAnsiString(P)^;
            ftWideString:
              if Database.NeedUnicodeFieldsTranslation then
               Result:=UTF8ToString(PAnsiString(P)^)
              else
               Result:=PAnsiString(P)^;
          end
          ;
            if poTrimCharFields in FOptions then
             Result:=TrimRight(Result);

        end
        else
          case Field.DataType of
           ftString    :
           begin
            Result:=FastCopy(PAnsiChar(P),1,Field.Size);
            if poTrimCharFields in FOptions then
             Result:=TrimRight(Result);
           end;
           ftWideString:
           begin
              if Database.NeedUnicodeFieldsTranslation then
                 Result:=UTF8Decode(FastCopy(PAnsiChar(P),1,Field.Size))
              else
                 Result:=FastCopy(PAnsiChar(P),1,Field.Size);
            if poTrimCharFields in FOptions then
            {$IFDEF D6+}
             Result:=TrimRight(VarToWideStr(Result));
            {$ELSE}
              ws:=Result;
              Result:=TrimRight(ws);
            {$ENDIF}
           end;
           ftGUID:
                Result:=GUIDAsString(PGuid(P)^);
 
          end;
       end;
 
       SQL_DOUBLE:
         Result:=PDouble(P)^;
       SQL_FLOAT:
        Result:=PSingle(P)^;
       SQL_LONG :
        if fi^.fdDataScale<>0 then
         Result:=PLong(P)^*E10[fi^.fdDataScale]
        else
         Result:=PLong(P)^;
       SQL_SHORT:
        if fi^.fdDataScale<>0 then
         Result:=PShort(P)^*E10[fi^.fdDataScale]
        else
         Result:=PShort(P)^;
       SQL_TIMESTAMP:
        Result:=TimeStampToDateTime(MSecsToTimeStamp(PDateTime(P)^));
       SQL_BOOLEAN:
        Result:=PBoolean(P)^;
       SQL_TYPE_DATE:
       begin
        Result:=TimeStampToDateTime(TimeStamp(PInteger(P)^,0));
       end;
       SQL_TYPE_TIME:
         Result:=TimeStampToDateTime(TimeStamp(DateDelta,PInteger(P)^));
       SQL_INT64:
          case Field.DataType of
           ftFloat:
             Result:=PDouble(P)^;
           ftBCD:
            begin
             if fi^.fdDataScale=0 then
             {$IFDEF D6+}
              Result:=PInt64(P)^
             {$ELSE}
              Result:=PComp(P)^
             {$ENDIF}
             else
             begin
              {$IFDEF D6+}
                Result:=PInt64(P)^*E10[fi^.fdDataScale]
              {$ELSE}
                Result:=PComp(P)^*E10[fi^.fdDataScale]
              {$ENDIF}
              ;
              if Field.Size=4 then
               Result :=VarAsType(Result,varCurrency);
             end;
 
            end;
           ftLargeInt:
            {$IFDEF D6+}
              Result:=PInt64(P)^
            {$ELSE}
              Result:=PComp(P)^
            {$ENDIF}
           ;
          end;
      end;
     end
    else
   begin
     //Calc
      P:=FRecordsCache.GetFieldData(RecNumber, FBlockReadSize+Field.Offset,-1,P1);
      if p=nil then
       Result:=Null
      else
      begin
        if not PBoolean(P)^ then
        begin
          Result:=Null;
          Exit;
        end;          
        Inc(PAnsiChar(P),SizeOf(Boolean));
        case Field.DataType of
         ftString    :
          Result:=FastCopy(Ansistring(PAnsiChar(P)),1,Field.Size);
         ftSmallInt:
            Result := PSmallInt(P)^;
         ftInteger:
          Result:=PInteger(P)^;
         ftBoolean:
          Result:=PBoolean(P)^;
         ftCurrency:
          Result:=PCurrency(P)^;
         ftBCD    :
         begin
          if BCDToCurr(TBcd(P^), tmpCurrency) then
           Result := tmpCurrency
          else
           Result := Null;
         end;
         ftDate,ftTime,ftDateTime:
         begin
          DataConvert(Field,P,@tmpDateTime,False);
          if tmpDateTime=0 then
           Result := Null
          else
           Result:=tmpDateTime;
         end;
         ftFloat  :
          Result:=PDouble(P)^;
         ftWideString:
            if Database.NeedUnicodeFieldsTranslation then
               Result:=UTF8ToString(PAnsiChar(P))
              else
               Result:=Ansistring(PAnsiChar(P));
         ftGUID:
              Result:=GUIDAsString(PGuid(P)^);
         ftLargeint:
         {$IFDEF D6+}
          Result:=PInt64(P)^;
         {$ELSE}
          Result:=PComp(P)^;
         {$ENDIF}
        end;
      end;
   end;
  end;
end;

function  TFIBCustomDataSet.RecordFieldValue(Field:TField;aBookmark:TBookmark):Variant;
begin
  if BookMarkValid(aBookmark) then
   Result:=
    RecordFieldValue(Field, FRecordsCache.RecordByBookMark(PFIBBookmark(@aBookmark)^.bRecordNumber)+1)
  else
   Result:=null
end;

 
{$IFDEF D10+}
 
procedure TFIBCustomDataSet.DataConvert(Field: TField; Source, Dest: Pointer; ToNative: Boolean);
var
  ws : WideString;
  s : AnsiString;
  L:integer;
begin
 if not (Field is TWideStringField) or (Field.FieldKind<>fkData)   then
  inherited
 else
 begin
  FillChar(Dest^,Field.DataSize,0);
  if Database.NeedUnicodeFieldsTranslation then
  begin
    if ToNative then
    begin
      s := UTF8Encode(pWideChar(Source));
      L := Length(s);
      if L>0 then
       Move(s[1], Dest^, (L+1)*SizeOf(AnsiChar));
    end
    else
       inherited
  end
  else
  begin
    if ToNative then
    begin
      s := pWideChar(Source);
      L := Length(s);
      if L>0 then
       Move(s[1], Dest^,L);
    end else
    begin
      ws :=     pAnsiChar(Source);
      L := Length(ws);
      if L>0 then
       Move(ws[1], Dest^, (L+1)*SizeOf(WideChar));
    end;
  end;
 end;
end;
{$ELSE}

procedure TFIBCustomDataSet.DataConvert(Field: TField; Source, Dest: Pointer; ToNative: Boolean);
var
   s : string;
begin
{ if (Field is TDateTimeField)  then
 begin
  if ToNative then
   TTimeStamp(Dest^):=DateTimeToTimeStamp(PDateTime(Source)^)
  else
  begin
   PDateTime(Dest)^:=TimeStampToDateTime(TTimeStamp(Source^));
  end
 end
 else}
 if (Field is TWideStringField)  then
 begin
  if Database.NeedUnicodeFieldsTranslation then
  begin
    if ToNative then
    begin
     FillChar(PChar(Dest)[0],Field.DataSize,0);
     s :=UTF8Encode(PWideString(Source)^);
     if Length(s)>0 then
        Move(s[1],PChar(Dest)[0],Length(s))
    end
    else
     PWideString(Dest)^:=UTF8Decode(PChar(Source))
  end
  else
  begin
    if ToNative then
    begin
      FillChar(PChar(Dest)[0],Field.DataSize,0);
      s :=PWideString(Source)^;
      if Length(s)>0 then
        Move(s[1],PChar(Dest)[0],Length(s))
    end
    else
     PWideString(Dest)^:=PChar(Source)
  end;
 end
 else
   inherited
 
end;
{$ENDIF}
 
function TFIBCustomDataSet.GetBlobFieldData(FieldNo: Integer; var Buffer: TBlobByteData): Integer;  // MIDAS
var
  Stream: TStream;
  blField:TBlobField;
  S :AnsiString;
  WS:string;
begin
  blField:=FieldByNumber(FieldNo) as TBlobField;
  Stream := CreateBlobStream(blField, bmRead);
  Result := Stream.Size;
  if Result = 0 then
   Stream.Free
  else
    if blField.DataType=ftWideMemo then
    try
       blField.Transliterate:=False;
       SetLength(S,Result);
       Stream.Read(S[1], Result);
       WS:=UTF8ToString(S);
       if Length(Buffer) <= Length(WS)*SizeOf(WideChar) then
        SetLength(Buffer, Length(WS)*SizeOf(WideChar) + 3);
       Move(WS[1],Buffer[0],Length(WS)*SizeOf(WideChar));
       Result:=Length(WS)*SizeOf(WideChar)
    finally
      Stream.Free;
    end
    else
    try
     if Length(Buffer) <= Result then
          SetLength(Buffer, Result + Result div 4);
        Stream.Read(Buffer[0], Result);
    finally
      Stream.Free;
    end;
end;
 
function TFIBCustomDataSet.GetFieldData(Field: TField; Buffer: Pointer): Boolean;
var
  Buff, Data:  dbPChar;
  CurrentRecord: PRecordData;
  fi:PFIBFieldDescr;
  L :integer;
  Allocated:boolean;
function IsValidRecord:boolean;
begin
  case FCacheModelOptions.CacheModelKind of
    cmkLimitedBufferSize:
     begin
      Result:=(CurrentRecord^.rdRecordNumber>=vPartition^.BeginPartRecordNo)
      and (CurrentRecord^.rdRecordNumber<=vPartition^.EndPartRecordNo)
      or (State=dsInsert)
     end;
 
  else
   Result:=(State<>dsBrowse) or (CurrentRecord^.rdRecordNumber < FRecordCount)
  end;
end;

procedure GetInspectRecBuffer;
var
  dsState: TDataSetState;
  OldDisableCalcFields:integer;
begin
   dsState:=State;
   Allocated:=
    (dsState<>dsCalcFields) and (Field.FieldKind in [fkLookUp,fkCalculated]);
   if Allocated and vCalcFieldsSavedCache then
   begin
    Allocated:= (drsInRefreshClientFields in FRunState) or
     not GetBit(PSavedRecordData(FRecordsCache.PRecBuffer(vInspectRecno+1,False))^.rdFlags,7)
   end;
   if Allocated then
   begin
    Buff :=AllocRecordBuffer;
    ReadRecordCache(vInspectRecno, Buff, State=dsOldValue);
    if (Field.FieldKind in [fkLookUp,fkCalculated])  then
    begin
      OldDisableCalcFields:=FDisableCalcFieldsCount;
      FDisableCalcFieldsCount:=0;
      try
       SetTempState(dsCalcFields);
       GetCalcFields(Buff);
      finally
       FDisableCalcFieldsCount:=OldDisableCalcFields;
       RestoreState(dsState);
      end
    end;
   end
   else
   begin
    Allocated:=(dsState in [dsOldValue,dsFilter]) or
     ((vTypeDispositionField=dfRRecNumber) and (dsState<>dsCalcFields));
    if Allocated then
    begin
     Buff :=AllocRecordBuffer;
     ReadRecordCache(vInspectRecno, Buff, State=dsOldValue)
    end
    else
     Buff:=GetActiveBuf;
   end;
end;

var
   G: Ansistring;
begin
  Result := False;
  Allocated:=False;
  case vTypeDispositionField of
   dfNormal:
   begin
    if (FCurrentRecord<0) and (drsInCacheDelete in FRunState) then
     Exit;
    vInspectRecno:=FCurrentRecord;
    if (drsInFilterProc in FRunState) or (drsInGetRecordProc in FRunState) then
    begin
     case FCacheModelOptions.FCacheModelKind of
     cmkStandard:
      if (vInspectRecno<0) or (vInspectRecno>=FRecordCount) then
       Exit;
     cmkLimitedBufferSize:
      if (vInspectRecno<vPartition^.BeginPartRecordNo) or (vInspectRecno>vPartition^.EndPartRecordNo) then
       Exit;
     end;
     GetInspectRecBuffer;
    end
    else
    case State of
     dsNewValue:
      Buff := GetNewBuffer;
     dsOldValue:
       begin
        Buff     := GetOldBuffer;
        if Field.FieldKind in [fkCalculated,fkLookup] then
         GetCalcFields(Buff);
        Allocated:= True;
       end;
    else
       Buff := GetActiveBuf;
    end
   end;
   dfRRecNumber:
    begin
     if (vInspectRecno<0) or (vInspectRecno>FRecordCount) then
      Exit;
     GetInspectRecBuffer
    end;
  end;

 
 try
  if (Buff = nil) then
   Exit;
 
 
  if (State<>dsOldValue) and (not IsVisibleStat(PRecordData(Buff)) ) then
   Exit;
 
  (* The intention here is to stuff the buffer with the data for the *)
  (* referenced field for the current record.                        *)
  CurrentRecord := PRecordData(Buff);
  if (Field.FieldNo > 0) and (Field.FieldNo <= vrdFieldCount) and IsValidRecord
  then
  begin
    Result := not CurrentRecord^.rdFields[Field.FieldNo].fdIsNull;
    if (Buffer=nil) then
     Exit;
    if Result then
    begin
        fi:=vFieldDescrList[Field.FieldNo-1];
        Data := Buff + fi^.fdDataOfs;
        case fi^.fdDataType of
          SQL_VARYING,SQL_TEXT:
          begin
            if fi^.fdDataSize > Field.DataSize then
             FIBError(feFieldSizeMismatch,[Name,Field.FieldName]);
         // LengthExp

            if fi^.fdIsSeparateString then
            begin
             L:=PInteger(Data)^;
             Inc(Data,SizeOf(Integer));
             if (poTrimCharFields in FOptions) then
             begin
                 while (L>0) and(PAnsiChar(Data)[L-1] = ' ') do
                  Dec(L);
             end;
            end
            else
            if (Field.DataType=ftGuid) or fi^.fdIsDBKey then
               L:=fi^.fdDataSize
            else
            if PAnsiChar(Data)[0]<>#0 then
            begin
                L:=0;
                while (L<fi^.fdDataSize) and(PAnsiChar(Data)[L] <> #0) do
                 Inc(L);
                if (poTrimCharFields in FOptions) then
                begin
                 while (L>0) and(PAnsiChar(Data)[L-1] = ' ') do
                  Dec(L);
                end;
            end
            else
             L:=0;
            if L=0 then
            begin
               case Field.DataType of
                ftWideString:
                    PWideChar(Buffer)[0]:=#0
               else
                PAnsiChar(Buffer)[0]:=#0
               end
            end
            else
            begin
               case Field.DataType of
                ftString:
                  if (Field is TFIBStringField) and Database.NeedUnicodeFieldTranslation(Byte(TFIBStringField(Field).SqlSubType))
                   and  not (Byte(TFIBStringField(Field).SqlSubType) in Database.UnicodeCharSets)
                  then
                  begin
                    G:=UTF8Decode(PAnsiChar(Data));
                    L:=Length(G);
                    Move(G[1], Buffer^, L);
                    PAnsiChar(Buffer)[L]:=#0
                  end
                  else
                  begin
                   Move(Data^, Buffer^, L);
                   PAnsiChar(Buffer)[L]:=#0
                  end;

                ftWideString:
                begin
                  if Database.NeedUnicodeFieldsTranslation then
                  begin
                    L := Utf8ToUnicode(PWideChar(Buffer), L+1, PAnsiChar(Data), L);
                    if L>Field.Size then
                      L:=Field.Size;
// For space characters
                    PWideChar(Buffer)[L]:=#0
                  end
                  else
                  begin
                   Move(Data^, Buffer^, L);
                   PAnsiChar(Buffer)[L]:=#0
                  end;
                end;
                ftGuid:
                begin
                    GUIDAsStringToPChar(PGuid(Data),Buffer);
                    PAnsiChar(Buffer)[38]:=#0
                end
               end;
 
            end;
          end;
          SQL_FLOAT:
              PDouble(Buffer)^:=PSingle(Data)^;
          SQL_LONG :
          if fi^.fdDataScale<>0 then
           PDouble(Buffer)^:=PLong(Data)^*E10[fi^.fdDataScale]
          else
           PLong(Buffer)^:=PLong(Data)^;
          SQL_SHORT:
          if fi^.fdDataScale<>0 then
           PDouble(Buffer)^:=PShort(Data)^*E10[fi^.fdDataScale]
          else
           PShort(Buffer)^:=PShort(Data)^;
          SQL_TIMESTAMP:
              PDouble(Buffer)^:=PDouble(Data)^;
          SQL_TYPE_TIME,SQL_TYPE_DATE:
           PLong(Buffer)^:=PLong(Data)^;
        else
         begin
          // Avoid BCD Overflow 
          if (Field.DataType = ftBCD) and
            (not (Field is TFIBBCDField) or  not TFIBBCDField(Field).FDataAsComp)
          then
          begin
          // from TDataPacketWriter
            Result :=  Int64ToBCD(PInt64(Data)^,-fi^.fdDataScale, TBcd(Buffer^))
          end
          else     
           Move(Data^, Buffer^, fi^.fdDataSize);
         end;
        end;
    end
  end
  else
  if (Field.FieldNo < 0) then
  begin
   // Calculated Fields
    Result := Boolean(Buff[FCalcFieldsOffset+Field.Offset]);
    if (Buffer=nil) then
     Exit;
    if Result then
    begin
       Move(Buff[FCalcFieldsOffset+Field.Offset+SizeOf(Boolean)], Buffer^, Field.DataSize);
    end;
  end;
 finally
  if Allocated then
   FreeRecordBuffer(Buff);
 end;
end;

function TFIBCustomDataSet.GetStateFieldValue(State: TDataSetState; Field: TField): Variant;
var 
  SaveState:  TDataSetState;
begin
  if (Self.State=dsInsert) and (State=dsOldValue) then
   Result := null
  else
  begin
   case Field.FieldKind  of
    fkData, fkInternalCalc: Result:= inherited GetStateFieldValue(State,Field);
    fkCalculated,fkLookUp :
     case State of
      dsNewValue,dsCurValue:   Result:=Field.Value;
      dsOldValue :
      begin
        SaveState:=Self.State;
        try
         SetTempState(State);
         Result:=Field.AsVariant
        finally
         RestoreState(SaveState);
        end;
      end;
     else
       Result := null
     end;
   end;
  end;
end;

(*
 * GetRecNo and SetRecNo both operate off of 1-based indexes as
 * opposed to 0-based indexes.
 * This is because we want LastRecordNumber/RecordCount = 1
 *)
function TFIBCustomDataSet.GetRealRecNo: Integer;
var 
  ActBuff:  dbPChar;
begin
  ActBuff:=GetActiveBuf;
  if  ActBuff = nil then
    Result := 0
  else
    Result := PRecordData(ActBuff)^.rdRecordNumber + 1;
end;

function TFIBCustomDataSet.GetRecNo: Integer;
begin
 if State=dsFilter then
  Result:=FCurrentRecord
 else
  Result:=GetRealRecNo
end;
 
procedure TFIBCustomDataSet.ClearCalcFields(Buffer: dbPChar);
begin
 // For Set LookUp null value (D7 and more)
 if (FDisableCalcFieldsCount=0) and (CalcFieldsSize>0) then
  begin
    if State in [dsEdit,dsInsert] then
    begin
     FillChar(Buffer[FCalcFieldsOffset],FRecordBufferSize-FCalcFieldsOffset,0);
    end
  end;
end;

procedure TFIBCustomDataSet.GetCalcFields(Buffer: dbPChar);
begin
  if (FDisableCalcFieldsCount=0) and (CalcFieldsSize>0) then
  begin
   if not vCalcFieldsSavedCache then
    inherited GetCalcFields(Buffer)
   else
   if not GetBit(PRecordData(Buffer)^.rdFlags,7) or
    (drsInRefreshClientFields in FRunState)
   then
   begin
    inherited GetCalcFields(Buffer);
    PRecordData(Buffer)^.rdFlags:=SetBit(PRecordData(Buffer)^.rdFlags,7,True);
    WriteRecordCache(PRecordData(Buffer)^.rdRecordNumber,Buffer);
   end
  end;
end;


procedure TFIBCustomDataSet.ShiftCurRec;
var
i:  integer;
begin
 Inc(FCurrentRecord,FCacheModelOptions.FBufferChunks);
 Inc(vPartition^.EndPartRecordNo,FCacheModelOptions.FBufferChunks);
 Inc(vPartition^.BeginPartRecordNo,FCacheModelOptions.FBufferChunks);
 
 for i:=0 to BufferCount-1 do
  begin
     Inc(PRecordData(Buffers[i]).rdRecordNumber,BufferChunks);
    // �������� ��� TDataSet
  end;
end;
 
 
function TFIBCustomDataSet.GetRecord(Buffer: dbPChar; GetMode: TGetMode;
  DoCheck: Boolean): TGetResult;
var
  Action: TDataAction;


 procedure ChangeCurSelect(NewSelect:TFIBQuery);
 begin
   FQCurrentSelect.Close;
   FQCurrentSelect:=NewSelect;
   AssignSQLObjectParams(FQCurrentSelect,[Self]);
   FQCurrentSelect.Params.AssignValues(FQSelect.Params);
   if FQCurrentSelect.Open then
    FQCurrentSelect.Close;
   FQCurrentSelect.ExecQuery;
 end;

begin
 Action:=daAbort;
 Result := grError;
 Include(FRunState,drsInGetRecordProc);
 try
  case GetMode of
    gmCurrent:
    case FCacheModelOptions.CacheModelKind of
    cmkStandard:
      begin
        if (FCurrentRecord >= 0) then
        begin
          if FCurrentRecord < FRecordCount then
            ReadRecordCache(FCurrentRecord, Buffer, False)
          else
          begin
            while (not FQSelect.Eof) and
              (FCurrentRecord >= FRecordCount)  and (FQSelect.Next <> nil)
            do
            begin
              FetchCurrentRecordToBuffer(FQSelect, FRecordCount, Buffer);
              Inc(FRecordCount);
            end;
            Dec(FCurrentRecord);
            if (FCurrentRecord >= 0) then
             ReadRecordCache(FCurrentRecord, Buffer, False)
          end;
          Result := grOk;
        end
        else
          Result := grBOF;
      end;
      cmkLimitedBufferSize:
      begin
       if (FCurrentRecord >= vPartition^.BeginPartRecordNo) then
       begin
         if (FCurrentRecord <=vPartition^.EndPartRecordNo) and (FCurrentRecord>=0)  then
         begin
           ReadRecordCache(FCurrentRecord, Buffer,False);
           Result := grOk;
         end
         else
         if vPartition^.IncludeEof then
           Result := grEOF
         else
           Result := grError;
       end
       else
         if vPartition^.IncludeBof then
          Result := grBOF
         else
           Result := grError;
      end;
    end;
    gmNext:
    begin
      Result := grOk;
      case FCacheModelOptions.CacheModelKind of
       cmkStandard:
         if (FCurrentRecord < FRecordCount-1) then
         begin
              Inc(FCurrentRecord);
              ReadRecordCache(FCurrentRecord, Buffer, False);
         end
         else
         begin
            if FCurrentRecord = FRecordCount then
              Result := grEOF
            else
            if FCurrentRecord = FRecordCount - 1 then
            begin
              if (not FQSelect.Eof) then
              begin
                FQSelect.Next;
                Inc(FCurrentRecord);
              end;
              if (FQSelect.Eof) then
              begin
                Result := grEOF;
              end
              else
              begin
                FetchCurrentRecordToBuffer(FQSelect, FCurrentRecord, Buffer);
                Inc(FRecordCount);
              end;
            end
         end;
       cmkLimitedBufferSize:
       if
        (FCurrentRecord >=vPartition^.BeginPartRecordNo-1)  and (FCurrentRecord<vPartition^.EndPartRecordNo)
       then
       begin
          Inc(FCurrentRecord);
          ReadRecordCache(FCurrentRecord, Buffer, False);
       end
       else
       if (FQCurrentSelect =FQSelect) or (FQCurrentSelect=FQSelectPart) then
       begin
          if (FQCurrentSelect.Eof) then
          begin
            vPartition^.IncludeEof:=True; 
            Result := grEOF;
          end
          else
          begin
            FQCurrentSelect.Next;
            if (FCurrentRecord>-1) or (not FQCurrentSelect.Eof) then
             Inc(FCurrentRecord);
            if FQCurrentSelect.Eof then
            begin
             vPartition^.IncludeEof:=True;
             Result := grEOF;
            end
            else
            begin
              FetchCurrentRecordToBuffer(FQCurrentSelect, FCurrentRecord, Buffer);
              Inc(vPartition^.EndPartRecordNo);
              if vPartition^.BeginPartRecordNo<0 then
               vPartition^.BeginPartRecordNo:=FCurrentRecord
              else
              if (vPartition^.EndPartRecordNo-vPartition^.BeginPartRecordNo)>=FCacheModelOptions.FBufferChunks then
              begin
               Inc(vPartition^.BeginPartRecordNo);
               vPartition^.IncludeBof:=False;
              end;
              FRecordCount:=vPartition^.EndPartRecordNo-vPartition^.BeginPartRecordNo+1;
            end;
          end;
       end
       else
       begin
       // ��������
         if vPartition^.IncludeEof then
          Result := grEOF
         else
         begin
           ChangeCurSelect(FQSelectPart);
           if FQCurrentSelect.Next=nil then
           begin
             vPartition^.IncludeEof:=True;
             Result := grEOF
           end
           else
           begin
            Inc(FCurrentRecord);
            if (vPartition^.EndPartRecordNo-vPartition^.BeginPartRecordNo)>=FCacheModelOptions.FBufferChunks-1 then
            begin
             FRecordsCache.MoveRecord(vPartition^.BeginPartRecordNo mod FCacheModelOptions.FBufferChunks,FCurrentRecord mod FCacheModelOptions.FBufferChunks);
             Inc(vPartition^.BeginPartRecordNo);
             vPartition^.IncludeBof:=False;
            end;
            Inc(vPartition^.EndPartRecordNo);
            FetchCurrentRecordToBuffer(FQCurrentSelect, FCurrentRecord, Buffer);
            Result := grOk;
           end;
         end;
       end;
      end;
    end;
  gmPrior:
   begin
    case FCacheModelOptions.CacheModelKind of
     cmkStandard:
     begin
      if (FCurrentRecord > 0) and  (FCurrentRecord <= FRecordCount) then
      begin
        Dec(FCurrentRecord);
        ReadRecordCache(FCurrentRecord, Buffer, False);
        Result := grOk;
      end
      else
      if (FCurrentRecord = -1) then
       Result := grBOF
      else
      if (FCurrentRecord = 0) then
      begin
        Dec(FCurrentRecord);
        Result := grBOF;
      end
     end;
     cmkLimitedBufferSize:
     begin
      if
        (FCurrentRecord >vPartition^.BeginPartRecordNo)  and (FCurrentRecord<=vPartition^.EndPartRecordNo+1)
      then
      begin
         Dec(FCurrentRecord);
          if (FCurrentRecord = -1) then
          begin
            vPartition^.IncludeBof:=True;
            Result := grBOF
          end
          else
          begin
             ReadRecordCache(FCurrentRecord, Buffer, False);
             Result := grOk;
          end
      end
      else
      if (FCurrentRecord = -1) then
      begin
        vPartition^.IncludeBof:=True;
        Result := grBOF
      end
      else
      if (vPartition^.BeginPartRecordNo = FCurrentRecord) then
      begin
       if (FQCurrentSelect=FQSelectDesc) or (FQCurrentSelect=FQSelectDescPart)
       then
       begin
         if FQCurrentSelect.Next=nil then
         begin
          Dec(FCurrentRecord);
          vPartition^.IncludeBof:=True;
          Result := grBOF
         end
         else
         begin
          Dec(FCurrentRecord);
          if FCurrentRecord=-1 then
          begin
            ShiftCurRec;
          end
          else
          begin
           FRecordsCache.MoveRecord(vPartition^.EndPartRecordNo mod BufferChunks,FCurrentRecord mod FCacheModelOptions.FBufferChunks);
           Dec(vPartition^.EndPartRecordNo);
           vPartition^.IncludeEof:=False;
          end;
          Dec(vPartition^.BeginPartRecordNo);
          FetchCurrentRecordToBuffer(FQCurrentSelect, FCurrentRecord, Buffer);
          Result := grOk;
         end;
       end
       else
       begin
         if vPartition^.IncludeBof then
          Result := grBOF
         else
         begin
         // ��������
 
           ChangeCurSelect(FQSelectDescPart);
           if FQCurrentSelect.Next=nil then
           begin
            vPartition^.IncludeBof:=True;
            Result := grBOF
           end
           else
           begin
            Dec(FCurrentRecord);

            if FCurrentRecord=-1 then
             ShiftCurRec;
 
            if (vPartition^.EndPartRecordNo-vPartition^.BeginPartRecordNo)>=FCacheModelOptions.FBufferChunks-1 then
            begin
             FRecordsCache.MoveRecord(vPartition^.EndPartRecordNo mod FCacheModelOptions.FBufferChunks,FCurrentRecord mod FCacheModelOptions.FBufferChunks);
             Dec(vPartition^.EndPartRecordNo);
             vPartition^.IncludeEof:=False;
            end;
            Dec(vPartition^.BeginPartRecordNo);
            FetchCurrentRecordToBuffer(FQCurrentSelect, FCurrentRecord, Buffer);
            Result := grOk;
           end;
         end;
       end;
      end;
     end;
    end;
   end;
  end;
  if Result = grOk then
    Result := AdjustCurrentRecord(Buffer, GetMode);
  if Result = grOk then
  with PRecordData(Buffer)^ do
  begin
    rdBookmarkFlag := bfCurrent;
    GetCalcFields(Buffer);
  end
  else
  if (Result = grEOF) and Assigned(Buffer) then
  begin
    PRecordData(Buffer)^.rdBookmarkFlag := bfEOF;
  end
  else
  if (Result = grBOF) and Assigned(Buffer) then
  begin
    PRecordData(Buffer)^.rdBookmarkFlag := bfBOF;
  end
  else
  if (Result = grError) and Assigned(Buffer) then
  begin
    PRecordData(Buffer)^.rdBookmarkFlag := bfEOF;
  end;
 except
    On E: EDatabaseError do
    begin
      Exclude(FRunState,drsInGetRecordProc);
      Action:=daFail;
      if Assigned(FOnGetRecordError) then FOnGetRecordError(Self,E,Action);
      case Action of
          daFail : raise;
          daAbort: Abort;
      end;
    end;
 end;
 Exclude(FRunState,drsInGetRecordProc);
end;
 

function TFIBCustomDataSet.GetRecordCount: Integer;
begin
  if not UniDirectional then
   Result := FRecordCount - FDeletedRecords
  else
  if FRecordCount<FCacheModelOptions.FBufferChunks then
   Result := FRecordCount - FDeletedRecords
  else
   Result := FCacheModelOptions.FBufferChunks;
end;
 
function TFIBCustomDataSet.GetRecordSize: Word;
begin
  Result := FRecordBufferSize;
end;
 
 
procedure TFIBCustomDataSet.RefreshMasterDS;
var
   mdVisRecno:  boolean;
begin
 mdVisRecno:=False;
 if (DataSource<>nil) and (DataSource.DataSet<>nil)  then
 try
  if DataSource.DataSet is TFIBCustomDataSet then
  begin
    mdVisRecno:=poVisibleRecno in
     TFIBCustomDataSet(DataSource.DataSet).Options;
    if mdVisRecno then
     TFIBCustomDataSet(DataSource.DataSet).Options:=
      TFIBCustomDataSet(DataSource.DataSet).Options-[poVisibleRecno]
  end;
  DataSource.DataSet.Refresh;
 finally
   if mdVisRecno then
         TFIBCustomDataSet(DataSource.DataSet).Options:=
      TFIBCustomDataSet(DataSource.DataSet).Options+[poVisibleRecno]
 end;
end;
 
procedure TFIBCustomDataSet.AutoStartUpdateTransaction;
begin
 if (UpdateTransaction<>nil) then
  if not UpdateTransaction.InTransaction
   and (poStartTransaction in Options)
  then
    UpdateTransaction.StartTransaction;
end;

procedure TFIBCustomDataSet.AutoCommitUpdateTransaction;
begin
 if FAutoCommit and (UpdateTransaction<>nil) then
  with UpdateTransaction do
  if UpdateTransaction.InTransaction then   
  begin
   if (UpdateTransaction<>Transaction) and (TimeoutAction<>TACommitRetaining)  then
     UpdateTransaction.Commit
   else
     CommitRetaining;
  end;
end;
 
procedure TFIBCustomDataSet.SwapRecords(Recno1,Recno2:integer);
var  r1, r2: dbPChar;
begin
    if Recno1=Recno2 then Exit;
    if (Recno1<0) or (Recno2<0) then Exit;
    if (Recno1>FRecordCount) or (Recno2>FRecordCount) then Exit;
    r1 := AllocRecordBuffer;
    r2 := AllocRecordBuffer;
    try
     ReadRecordCache(Recno1-1, r1, False);
     ReadRecordCache(Recno2-1, r2, False);
     PRecordData(r1)^.rdRecordNumber := Recno2-1;
     PRecordData(r2)^.rdRecordNumber := Recno1-1;
     WriteRecordCache(Recno1-1, r2);
     WriteRecordCache(Recno2-1, r1);
     RefreshClientFields(True);
   finally
    FreeRecordBuffer(r1);
    FreeRecordBuffer(r2);
   end;
end;

procedure TFIBCustomDataSet.InternalAddRecord(Buffer: Pointer; Append: Boolean);
begin
  if CanInsert then
  begin
    if Append and not UniDirectional then
     InternalLast;
    with PRecordData(Buffer)^ do
    begin
      if Append then
      begin
       rdRecordNumber:=FRecordCount;
       FCurrentRecord:=rdRecordNumber ;
      end
      else
       rdRecordNumber:=FCurrentRecord ;
       TCachedUpdateStatus(rdFlags):=cusInserted;
 
    end;
    InternalPost;
  end
  else
    FIBError(feCannotInsert, [CmpFullName(Self)]);
end;
 
procedure TFIBCustomDataSet.InternalCancel;
var 
  Buff:  dbPChar;
begin
  inherited InternalCancel;
  Buff := GetActiveBuf;
  if Buff <> nil then
  begin
    if (State = dsInsert) then
    begin
     case FCacheModelOptions.CacheModelKind of
      cmkStandard:
       if FCurrentRecord>=0 then
       case GetBookmarkFlag(Buff) of
        bfBOF: if FRecordCount=0 then
                Dec(FCurrentRecord);
        bfEOF: Dec(FCurrentRecord);
       end;
      cmkLimitedBufferSize:
       if FCurrentRecord>=0 then
       case GetBookmarkFlag(Buff) of
        bfBOF: if FRecordCount=0 then
                Dec(FCurrentRecord);
        bfEOF:
          begin
           FCurrentRecord:=vPartition^.EndPartRecordNo
          end;
       end;
     end;
    end;
  end;
  UpdateBlobInfo(Buff,ubiCancel,False,False);
end;
 
 


procedure TFIBCustomDataSet.CloseCursor;
begin
  inherited CloseCursor;
  FQSelect.Close;
  if csDesigning in ComponentState then
   UnPrepare;
end;

procedure TFIBCustomDataSet.InternalClose;
begin
  ClearBlobStreamList;
  FCurrentRecord := -1;
  FOpen := False;
  FRecordCount := 0;
  FDeletedRecords := 0;
  FRecordSize := 0;

  FBPos := 0;
  FOBPos := 0;
  FBEnd := 0;
  FOBEnd := 0;
  FRecordsCache.Free;
  FRecordsCache:=nil;
  BindFields(False);                    // Unbind the fields
  if DefaultFields then DestroyFields;
  vFieldDescrList.Clear;
  FCachedActive:=False;
end;
 
procedure TFIBCustomDataSet.InternalDelete;
var 
  Buff:  dbPChar;
  iCurScreenState: Integer;
begin
  ChangeScreenCursor(iCurScreenState);
  try
    Buff := GetActiveBuf;
    (* Cannot delete a record without a FQDelete query existing. *)
    if CanDelete then
    begin
      if not CachedUpdates then
      begin
        InternalDeleteRecord(FQDelete, Buff);
        if FCacheModelOptions.CacheModelKind=cmkLimitedBufferSize then
         InternalFullRefresh(False);

      end
      else
      begin
        with PRecordData(Buff)^ do
        begin
          if TCachedUpdateStatus(rdFlags and 7)= cusInserted  then
          begin
           TCachedUpdateStatus(rdFlags):=cusUninserted;
           Dec(FCountUpdatesPending)
          end
          else
          begin
            if not (drsInCacheRefresh in FRunState) then
            begin
             TCachedUpdateStatus(rdFlags):= cusDeleted;
             Inc(FCountUpdatesPending); 
            end;
          end;
        end;
        WriteRecordCache(PRecordData(Buff)^.rdRecordNumber, Buff);
      end;
      Inc(FDeletedRecords);
      FUpdatesPending := FCountUpdatesPending>0;
    end
    else
      FIBError(feCannotDelete, [CmpFullName(Self)]);
   FFilteredCacheInfo.AllRecords := -1;      
  finally
   RestoreScreenCursor(iCurScreenState);
  end;
end;

procedure TFIBCustomDataSet.InternalFirst;
begin
 case FCacheModelOptions.CacheModelKind of
  cmkStandard :  FCurrentRecord := -1;
  cmkLimitedBufferSize:
  if (FQCurrentSelect<>FQSelect) or (vPartition^.BeginPartRecordNo>0) then
  begin
    FQCurrentSelect.Close;
    if FQSelect.Open then
     FQSelect.Close;
    FQSelect.ExecQuery;
    FQCurrentSelect:=FQSelect;
    with vPartition^ do
    begin
     BeginPartRecordNo:=-1;
     EndPartRecordNo  :=-1;
     IncludeEof       :=False;
     IncludeBof       :=True;     
    end;
  end;
 end;
 FCurrentRecord := -1; 
end;
 
type
 PBookMark=^TBookMark;
 
function  TFIBCustomDataSet.CompareBookMarkAndRecno(BookMark:TBookMark; Rno:integer;OnlyFields:boolean=False):boolean;
var 
   TempBuf:  dbPChar;
   TempBookMark:PBookMark;
begin
      TempBuf:=AllocRecordBuffer;
      GetMem(TempBookMark, BookmarkSize);
      try
       ReadRecordCache(Rno,TempBuf,False);
       GetBookmarkData(TempBuf, TempBookMark);
       PFIBBookmark(TempBookMark)^.bActiveRecord:=PFIBBookmark(BookMark)^.bActiveRecord;
       if OnlyFields then
        PFIBBookmark(TempBookMark)^.bRecordNumber:=PFIBBookmark(BookMark)^.bRecordNumber;
       Result:= CompareMem(TempBookMark,BookMark,BookmarkSize-1);
      finally
       FreeMem(TempBuf);
       FreeMem(TempBookMark);
      end;
end;
 
 
function TFIBCustomDataSet.RefreshAround(BaseQuery: TFIBQuery;var BaseRecNum:integer;
 IgnoreEmptyBaseQuery:boolean = True;ReopenBaseQuery:boolean = True
):boolean;
 
var 
  RecShifted: boolean;
 
 procedure ExecCurSelect( aCurSelect:TFIBQuery; SourceObject:ISQLObject);
 begin
    aCurSelect.Close;
    AssignSQLObjectParams(aCurSelect,[SourceObject]);
    aCurSelect.Params.AssignValues(FQSelect.Params);
    aCurSelect.ExecQuery;
 end;

 function FetchAround(aCurSelect:TFIBQuery; RecordsLimit:integer; Arrow:smallint;
  FromRecNum:integer =-1
 ):boolean;
 var
  i: integer;
 begin
    if FromRecNum=-1 then
     FCurrentRecord:=BaseRecNum
    else
     FCurrentRecord:=FromRecNum;
    i:=RecordsLimit;
    Result := False;
    while  (i>0) and (aCurSelect.Next<>nil)  do
    begin
      Result := True;
      Inc(FCurrentRecord,Arrow);
      if FCurrentRecord=-1 then
      begin
       ShiftCurRec;
       RecShifted:=True;
      end;
 
      FetchRecordToCache(aCurSelect, FCurrentRecord);
      if Arrow<0 then
      begin
       vPartition^.BeginPartRecordNo:=FCurrentRecord;
       if vPartition^.EndPartRecordNo=-1 then
        vPartition^.EndPartRecordNo:=vPartition^.BeginPartRecordNo
      end
      else
      begin
       vPartition^.EndPartRecordNo  :=FCurrentRecord;
       if vPartition^.BeginPartRecordNo=-1 then
        vPartition^.BeginPartRecordNo:=vPartition^.EndPartRecordNo;
      end;
      Dec(i);
    end;
    if aCurSelect.Eof then
     if Arrow<0 then
      vPartition^.IncludeBof:=True
     else
      vPartition^.IncludeEof:=True;
 end;

var 
   RecordSource  : ISQLObject;
   EmptyDataSet  :boolean;
   NotFetchedCount:integer;
begin
 with BaseQuery do
 begin
  if ReopenBaseQuery then
  begin
   Close;
   Params.AssignValues(FQSelect.Params);
   ExecQuery;
   Next;
   Result:=not Eof;
  end
  else
   Result :=RecordCount>0;

 end;
 EmptyDataSet :=True;
 if Result or (not IgnoreEmptyBaseQuery) then
 begin
    if BaseRecNum<(FCacheModelOptions.FBufferChunks div 2) then
     BaseRecNum:=FCacheModelOptions.FBufferChunks div 2;
 
    if Result then
    begin
      EmptyDataSet     :=False;
      FetchRecordToCache(BaseQuery, BaseRecNum);
      vPartition^.BeginPartRecordNo:=BaseRecNum;
      vPartition^.EndPartRecordNo  :=BaseRecNum;
      RecordSource:=BaseQuery
    end
    else
    begin
     RecordSource:=Self;
    end;

    vPartition^.IncludeBof:=False;
    vPartition^.IncludeEof:=False;
 
    ExecCurSelect(FQSelectDescPart,RecordSource);
    ExecCurSelect(FQSelectPart,RecordSource);
    if not Result then
    begin
     vPartition^.BeginPartRecordNo:=-1;
     vPartition^.EndPartRecordNo  :=-1;
    end;

    RecShifted:=False;

    if FetchAround(FQSelectDescPart,FCacheModelOptions.FBufferChunks div 2,-1) then
     EmptyDataSet:=False;

    if not Result then
     Dec(BaseRecNum);

    NotFetchedCount:=
     FCacheModelOptions.FBufferChunks-(vPartition^.EndPartRecordNo-vPartition^.BeginPartRecordNo+2);
    if FetchAround(FQSelectPart,NotFetchedCount,1) then
     EmptyDataSet:=False;

    NotFetchedCount:=
     FCacheModelOptions.FBufferChunks-(vPartition^.EndPartRecordNo-vPartition^.BeginPartRecordNo+2);
    if NotFetchedCount>0 then
     FetchAround(FQSelectDescPart,NotFetchedCount,-1,vPartition^.BeginPartRecordNo);
 
    FQSelectDescPart.Close;
    if RecShifted then
      Inc(BaseRecNum,FCacheModelOptions.FBufferChunks);
    if  Result then
     FCurrentRecord:=BaseRecNum
    else
    if EmptyDataSet then
     FCurrentRecord:=-1
    else
     FCurrentRecord:=BaseRecNum+1;
    FQCurrentSelect:=FQSelectPart ;
 
    BaseQuery.Close;
 end;
end;

procedure TFIBCustomDataSet.InternalGotoBookmark(Bookmark: Pointer);
var
   Rno:  integer;
   i  :integer;
   tf :TField;
   AddrValue:Pointer;

  procedure StdGotoBookMark;
  begin
    if Rno>-1 then
    begin
     MoveBy(TFIBBookmark(Bookmark^).bActiveRecord-ActiveRecord);
     FCurrentRecord := Rno;
    end;
  end;
 
  function InWorkArea: Boolean;
  begin
    Result :=(Rno>-1) and (Rno >= vPartition^.BeginPartRecordNo)
             and (Rno <= (vPartition^.EndPartRecordNo));
  end;

begin
  Include(FRunState,drsInGotoBookMark);
  if not BookmarkValid(BookMark) then
  begin
//    vLockResync:=True;
    Inc(vLockResync);
    Exit;
  end;

  DisableControls;
  DisableScrollEvents;
  try
   Rno:=FRecordsCache.RecordByBookMark(TFIBBookmark(Bookmark^).bRecordNumber);
   if (FCacheModelOptions.CacheModelKind=cmkStandard)  then
   begin
    StdGotoBookMark
   end
   else
   begin
     if (FCacheModelOptions.CacheModelKind=cmkLimitedBufferSize) then
       if InWorkArea and CompareBookMarkAndRecno(BookMark,Rno) then
       begin
          StdGotoBookMark;
          Exit;
       end
       else
       begin
         for i:=vPartition^.BeginPartRecordNo to vPartition^.EndPartRecordNo do
         begin
           if CompareBookMarkAndRecno(BookMark,i,True) then
           begin
             MoveBy(TFIBBookmark(Bookmark^).bActiveRecord-ActiveRecord);
             FCurrentRecord:=FRecordsCache.BookMarkByRecord(i-1);
             Exit;
           end;
         end;
         with FQBookMark do
         begin
           if Open then    Close;
           for i:=0 to Pred(FKeyFieldsForBookMark.Count) do
           begin
            if Boolean(PAnsiChar(BookMark)[Integer(FKeyFieldsForBookMark.Objects[i])]) then
             ParamByName(LocateParamPrefix+FKeyFieldsForBookMark[i]).Clear
            else
            begin
              tf :=Self.FN(FKeyFieldsForBookMark[i]);
              AddrValue:=@PAnsiChar(BookMark)[Integer(FKeyFieldsForBookMark.Objects[i])+SizeOf(Boolean)];
              if Assigned(tf) then
              with ParamByName(LocateParamPrefix+FKeyFieldsForBookMark[i]) do
              case tf.DataType of
               ftSmallint:
                asInteger:=PSmallInt(AddrValue)^;
               ftInteger:
                asInteger:=PInteger(AddrValue)^;
               ftFloat  :
                 asDouble:=PDouble(AddrValue)^;
               ftString :
                 asString:=PAnsiChar(AddrValue);
               ftDate:
                 asDateTime:=IntDateToDateTime(PInteger(AddrValue)^);
               ftTime:
                 asDateTime:=PInteger(AddrValue)^;
               ftDateTime:
                 asDateTime:=PDateTime(AddrValue)^;
              end;
            end;
           end; // for
          if RefreshAround(FQBookMark, TFIBBookmark(Bookmark^).bRecordNumber) then
          begin
           MoveBy(TFIBBookmark(Bookmark^).bActiveRecord-ActiveRecord);
           FCurrentRecord:=TFIBBookmark(Bookmark^).bRecordNumber;
          end
          else
           Inc(vLockResync);
//           vLockResync:=True;
         end;
       end;
   end;
  except
    EnableControls;
    EnableScrollEvents;
    Exclude(FRunState,drsInGotoBookMark);
    raise
  end;
end;

procedure TFIBCustomDataSet.InternalHandleException;
begin
 {$IFDEF D6+}
   if Assigned(Classes.ApplicationHandleException) then
    Classes.ApplicationHandleException(Self);
 {$ENDIF}
end;


procedure TFIBCustomDataSet.TryDesignPrepare;
var 
   ForceConnect:  boolean;
   vLoginPrompt:boolean;
begin
 if Assigned(Database) then
 begin
  ForceConnect:=not Database.Connected;
  vLoginPrompt:=Database.UseLoginPrompt;
  try
    if not Database.Connected then
    try
     Database.UseLoginPrompt:=False;
     Database.Connected:=True;
    except
     Database.UseLoginPrompt:=vLoginPrompt;
     Exit
    end;
    if Assigned(Transaction) and Transaction.InTransaction then
      Prepare
    else
    if  Assigned(Transaction) then
      if  Transaction.InTransaction then
      begin
       Prepare;
      end
      else
      begin
       Transaction.StartTransaction;
       Prepare
      end;
   finally
    Database.UseLoginPrompt:=vLoginPrompt;
    if ForceConnect and Database.Connected then
     Database.Connected:=False
   end;
  end;
 
end;
 
 
procedure TFIBCustomDataSet.InternalInitFieldDefs;
var
  DataType:  TFieldType;
  Size: Word;
  i, FieldNo: Integer;
  Name   : string;
  isSmallInt:boolean;
 
  RelFieldName,RelTabName:string;
  Fi:TpFIBFieldInfo;
  tf:TField;
begin
  if drsInClone in FRunState  then
   Exit;
  if not Prepared then
  begin
    if not (csDesigning in ComponentState) then
     Prepare
    else
    begin
      TryDesignPrepare;
    end;
    Exit;
  end;
  FieldDefs.BeginUpdate;
  try
  (* Destroy any previously existing information... *)
   FieldDefs.Clear;
   for i := 0 to FQSelect.Current.Count - 1 do
    with FQSelect.Current[i].Data^ do
    begin
      (* Get the field name *)
      SetString(Name, aliasname, aliasname_length);
      if Database.IsUnicodeConnect then
        Name:=UTF8ToString(Name);
{$IFDEF SUPPORT_KOI8_CHARSET}
      if Database.IsKOI8Connect then
        Name:=ConvertFromCodePage(Name,CodePageKOI8R);
{$ENDIF}
      Size   := 0;
      case sqltype and not 1 of
        // All VARCHAR's must be converted to strings before recording
        // their values
        SQL_VARYING, SQL_TEXT:
        begin
          Size     := sqllen; // It is DataSize
          DataType := ftString;
          if Byte(sqlsubtype) in Database.UnicodeCharSets then
          begin
{$IFNDEF UNICODE_TO_STRING_FIELDS}
            DataType := ftWideString;
{$ELSE}
            DataType := ftString;
{$ENDIF}
            if not IsSysField(sqlName) or  not Database.ReturnDeclaredFieldSize then
             Size:=Size div   Database.BytesInUnicodeChar(Byte(sqlsubtype));
 
          end;
          tf       :=FindField(Name);
          if (tf<>nil) and (tf.Size<>Size) then
            tf.Size:=Size;

          if (psUseGuidField in PrepareOptions) and (Size=16)  then
          begin
            SetString(RelTabName  , relname, relname_length);
            SetString(RelFieldName, sqlname, sqlname_length);
            Fi:=ListTableInfo.GetFieldInfo(DataBase,RelTabName,RelFieldName,False);
            if Assigned(FI) and Fi.CanBeGUID then
            begin
             DataType := ftGuid;
             if (tf<>nil)  then
              tf.Size:=38;
            end
          end;
 
        end;
        // All Doubles/Floats should be cast to doubles.
        //
        SQL_DOUBLE, SQL_FLOAT:
        begin
          DataType := ftFloat;
        end;

        // SQL_LONG = 4 bytes
        SQL_SHORT, SQL_LONG:
          if (sqlscale < 0) then
            DataType := ftFloat
          else
          begin
            isSmallInt:=(sqlLen<>4)
              and ((FindField(Name)=nil) or (FindField(Name) is TSmallIntField));
             if psUseBooleanField in PrepareOptions then
             begin
               SetString(RelTabName  , relname, relname_length);
               SetString(RelFieldName, sqlname, sqlname_length);
               if RelTabName='FIB$FIELDS_INFO' then
                Fi:=nil
               else
                Fi:=ListTableInfo.GetFieldInfo(DataBase,RelTabName,RelFieldName,False);
             end
             else
             begin
              fi:=nil;
             end;
             if ((fi<>nil) and fi.CanBeBoolean)
             then
               DataType := ftBoolean
             else
             begin
               tf:=FindField(Name);
               if Assigned(tf) and (tf.DataType=ftBoolean) then
                 DataType := ftBoolean
               else  
               if isSmallInt then
                  DataType := ftSmallInt
               else
                  DataType := ftInteger;
             end;
          end;
         SQL_INT64:
         begin
            if (sqlscale = 0) then
            begin
              if psUseLargeIntField in PrepareOptions then
               DataType := ftLargeint
              else
               DataType := ftBCD
            end
            else
            if (sqlscale >= -4) or (psSQLINT64ToBCD in PrepareOptions) then
            begin
              DataType := ftBCD;
              Size:=-sqlscale;
              tf:=FindField(Name);
              if tf<>nil then
               if tf.Size<>Size then tf.Size:=Size;
            end
            else
              DataType := ftFloat;
         end; 
 
// SQL_DATE = 8 bytes
        SQL_TIMESTAMP: DataType := ftDateTime;
        SQL_TYPE_TIME: DataType := ftTime;
        SQL_TYPE_DATE: DataType := ftDate;
// SQL_BLOB = variable
        SQL_BLOB:
        begin
          Size := SizeOf(TISC_QUAD);
          if sqlsubtype = 1 then
          begin
           with  Database do
            if (NeedUTFEncodeDDL  and IsUnicodeConnect)
             and (Byte(sqlScale) in UnicodeCharSets) then
              DataType := ftWideMemo
             else
              DataType := ftMemo
          end
          else
             DataType := ftBlob;
        end;
// SQL_ARRAY = variable
 
        SQL_ARRAY:
        begin
          Size := SizeOf(TISC_QUAD);
          DataType := ftBytes;
        end;
        SQL_BOOLEAN:
          DataType := ftBoolean;
      else
          DataType := ftUnknown;
      end;
      FieldNo := i + 1;
      if DataType <> ftUnknown then
      begin
        (*
         * C++-Builder has a different constructor for TFieldDef than
         * Delphi does. This is kinda annoying...
         * Anyways, I believe the currently discussed C++-Builder uses
         * the compiler define VER110, soo...
         *)
{$IFDEF VER110}
        if DataType <> ftUnknown then
        begin
          FieldDef := TFieldDef.Create( FieldDefs );
          FieldDef.Name := Ansistring( Name );
          FieldDef.DataType := DataType;
          FieldDef.Size := Size;
          FieldDef.Required := False;
          FieldDef.FieldNo := FieldNo;
          FieldDef.InternalCalcField := False;
        end;
{$ELSE}
       if DataType=ftGUID then
        begin
         with TFieldDef.Create(FieldDefs,Name,
                   DataType, 38, False, FieldNo) do
          InternalCalcField := False
        end
        else
         with TFieldDef.Create(FieldDefs,Name,
                   DataType, Size, False, FieldNo) do
          InternalCalcField := False;
{$ENDIF}
      end;
    end;
  finally
    FieldDefs.EndUpdate;
  end
end;
 

 
procedure TFIBCustomDataSet.InternalInitRecord(Buffer: dbPChar);
var
   i:  integer;
begin
 FillChar(Buffer[0],FRecordBufferSize,#0);
 for i:=1 to vFieldDescrList.Capacity do
  PRecordData(Buffer)^.rdFields[i].fdIsNull:=True;
end;
 
 
procedure TFIBCustomDataSet.SetBeforeFetchRecord(Value:TOnFetchRecord);
begin
  FBeforeFetchRecord:=Value;
  if Assigned(FBeforeFetchRecord) then
   FQSelect.OnSQLFetch    :=DoOnSelectFetch
  else
   FQSelect.OnSQLFetch    :=nil
end;
 
procedure TFIBCustomDataSet.DoOnSelectFetch
 (RecordNumber:integer;   var StopFetching:boolean);
begin
 if Assigned(FBeforeFetchRecord) then
  FBeforeFetchRecord(QSelect,RecordNumber,StopFetching);
end;

procedure TFIBCustomDataSet.InternalLast;
var 
  iCurScreenState: Integer;
begin
 case FCacheModelOptions.CacheModelKind of
  cmkStandard:
    if (FQSelect.Eof) then
      FCurrentRecord := FRecordCount
    else
    begin
     ChangeScreenCursor(iCurScreenState);
     Include(FRunState,drsInFetchingAll);
     try
      try
       while (FQSelect.Next <> nil)  do
       begin
         FetchRecordToCache(FQSelect,FRecordCount);
         Inc(FRecordCount);
       end;
      except
       try
        GetPriorRecord;
        GetPriorRecords;
       except
       end;
       raise;
      end;
     finally
      Exclude(FRunState,drsInFetchingAll);
      FCurrentRecord := FRecordCount;     
      RestoreScreenCursor(iCurScreenState);
     end;
    end;
   cmkLimitedBufferSize:
    begin
     if State =dsInsert then
     begin
      FCurrentRecord := vPartition^.EndPartRecordNo+1;
      Exit;
     end
     else
     if vPartition^.IncludeEof then
     begin
      FCurrentRecord := vPartition^.EndPartRecordNo+1;
      Exit;
     end;


     ClearBlobStreamList;
     FQCurrentSelect.Close;
     if FQSelectDesc.Open then
      FQSelectDesc.Close;
     FQCurrentSelect:=FQSelectDesc;
 
     FQCurrentSelect.Params.AssignValues(FQSelect.Params);
     FQCurrentSelect.ExecQuery;
 
 
     vPartition^.BeginPartRecordNo :=MaxInt div 2;
     vPartition^.EndPartRecordNo   :=vPartition^.BeginPartRecordNo-1;
 
     FCurrentRecord  := vPartition^.EndPartRecordNo;
     ChangeScreenCursor(iCurScreenState);
     try
       FRecordCount  := 0;
       try
        while  FQCurrentSelect.Next<>nil  do
        begin
         FetchRecordToCache(FQCurrentSelect,FCurrentRecord);
         Dec(FCurrentRecord);
         Dec(vPartition^.BeginPartRecordNo);
         if (vPartition^.EndPartRecordNo-vPartition^.BeginPartRecordNo>=FCacheModelOptions.FBufferChunks-1) then
          Break;
        end;
       except
       end;
       FCurrentRecord := vPartition^.EndPartRecordNo+1;
       FRecordCount   := vPartition^.EndPartRecordNo-vPartition^.BeginPartRecordNo+1;
       vPartition^.IncludeBof:=False;
       vPartition^.IncludeEof:=True;

     finally
      RestoreScreenCursor(iCurScreenState);
     end;
    end;
 end;
end;

function  TFIBCustomDataSet.MasterFieldsChanged :boolean;
var pc,i :integer;
    cur_param: TFIBXSQLVAR;
    cur_field: TField;
 
function MasParamChanged:boolean;
begin
  Result:=False;
  if (cur_field <> nil) then
  begin
   Result:=cur_field.IsNull xor cur_param.IsNull;
   if not Result then
   case cur_field.DataType of
     ftString,ftWideString:
       Result:=(cur_param.AsString<>cur_field.AsString);
     ftSmallint, ftInteger, ftWord,ftBoolean:
       Result:=(cur_param.AsLong<>cur_field.AsInteger);
     ftFloat, ftCurrency:
       Result:=(cur_param.AsDouble<>cur_field.AsFloat);
     ftBCD:
      if (cur_field is TFIBBCDField) and (TFIBBCDField(cur_field).Size=0) then
       Result:=(cur_param.AsInt64<>TFIBBCDField(cur_field).AsInt64)
      else
       Result:=CompareBCD(cur_param.AsBcd,TFIBBCDField(cur_field).AsBcd)<>0;

     ftDate:
       Result:=(cur_param.AsDate<>cur_field.AsDateTime);
     ftDateTime:
       Result:=(cur_param.AsDateTime <>cur_field.AsDateTime);
     ftTime:
       Result:=(cur_param.AsTime<>cur_field.AsDateTime);
     ftGuid:
       Result:= not IsEqualGUIDs(cur_param.AsGuid,TFIBGuidField(cur_field).AsGuid);
     ftLargeint:
       Result:=cur_param.AsInt64<>TFIBLargeIntField(cur_field).AsLargeInt;
   end;
  end;
end;

begin
    Result:=QSelect.MacroChanged;
    if Result then
    begin
      QSelect.ApplyMacro;  
      Exit;
    end;
    pc:=Params.Count - 1;
    if (DataSource <> nil) and (DataSource.DataSet<>nil) and (pc >=0 )  then
    begin
      for i := 0 to pc do
      begin
        cur_param := Params[i];
        if IsMasParamName(cur_param.Name)  then
         cur_field := DataSource.DataSet.FindField(FastCopy(cur_param.Name,5,MaxInt))
        else
         cur_field := DataSource.DataSet.FindField(cur_param.Name);
        Result:= MasParamChanged;
        if Result then Exit;
      end;
      pc:=QSelect.OnlySrvParams.Count-1;
      for i := 0 to pc do
      begin
        cur_param := QSelect.FindParam(QSelect.OnlySrvParams[i]);
        if cur_param=nil then Continue;
        if IsMasParamName(cur_param.Name)  then
         cur_field := DataSource.DataSet.FindField(FastCopy(cur_param.Name,5,MaxInt))
        else
         cur_field := DataSource.DataSet.FindField(cur_param.Name);

        Result:= MasParamChanged;
        if Result then Exit;
      end
    end;
end;


procedure TFIBCustomDataSet.SetParamsFromMaster;
var pc,i :integer;
    cur_param: TFIBXSQLVAR;
    cur_field: TField;
    s: TStream;
 
procedure SetFieldValue;
begin
 if (cur_field <> nil) then
 begin
   if (cur_field.IsNull) then
     cur_param.IsNull := True
   else
   case cur_field.DataType of
     ftWideString:
      cur_param.Value := cur_field.Value;
     ftString:
       cur_param.AsString := cur_field.AsString;
     ftSmallint, ftInteger, ftWord,ftBoolean:
       cur_param.AsLong := cur_field.AsInteger;
     ftFloat, ftCurrency:
       cur_param.AsDouble := cur_field.AsFloat;
     ftBCD:
      if (cur_field is TFIBBCDField) and
       (TFIBBCDField(cur_field).Size=0) then
       cur_param.AsInt64     := TFIBBCDField(cur_field).AsInt64
      else
        cur_param.AsBcd     := TFIBBCDField(cur_field).AsBcd;
     ftDate:
       cur_param.AsDate     := cur_field.AsDateTime;
     ftDateTime:
       cur_param.AsDateTime := cur_field.AsDateTime;
     ftTime:
       cur_param.AsTime     := cur_field.AsDateTime;
     ftGuid:
       cur_param.AsGuid     := TFIBGuidField(cur_field).AsGuid;
     ftLargeint:
       cur_param.AsInt64    := TFIBLargeIntField(cur_field).AsLargeInt;
     ftBlob:
     begin
       s := nil;
       try
         s :=cur_field.DataSet.CreateBlobStream(cur_field, bmRead);
         cur_param.LoadFromStream(s);
       finally
         s.free;
       end;
     end;
   else
       FIBError(feNotSupported, [CmpFullName(Self)]);
   end;
 end;
end;

begin
    pc:=Params.Count - 1;
    if (DataSource <> nil) and (DataSource.DataSet<>nil) and (pc >=0 )  then
    begin
      for i := 0 to pc do
      begin                         
        cur_param:=Params[i];
        if IsMasParamName(cur_param.Name)  then
         cur_field := DataSource.DataSet.FindField(FastCopy(cur_param.Name,5,MaxInt))
        else
         cur_field := DataSource.DataSet.FindField(cur_param.Name);
       SetFieldValue   
      end;
      pc:=QSelect.OnlySrvParams.Count-1;
      for i := 0 to pc do
      begin
        cur_param := QSelect.FindParam(QSelect.OnlySrvParams[i]);
        if cur_param=nil then Continue;
        if IsMasParamName(cur_param.Name)  then
         cur_field := DataSource.DataSet.FindField(FastCopy(cur_param.Name,5,MaxInt))
        else
         cur_field := DataSource.DataSet.FindField(cur_param.Name);
        SetFieldValue
      end
    end;
end;

procedure TFIBCustomDataSet.InternalDoBeforeOpen;
begin

end;

procedure TFIBCustomDataSet.InternalOpen;
var
  iCurScreenState,
  i,j: Integer;
begin
  if drsInClone in FRunState  then
  begin
   FOpen:=True;
   Exit;
  end;
  ChangeScreenCursor(iCurScreenState);
 try
    FUpdatesPending        :=False;
    if FQSelect.MacroChanged then
     SQLChanging(QSelect);
    if not FPrepared or  not FQSelect.Prepared   then
     Prepare;
    if (FieldDefs.Count=0) then
      InternalInitFieldDefs; 
    SetParamsFromMaster;
    if (FQSelect.SQLType = SQLSelect) or (FQSelect.SQLType = SQLSelectForUpdate) then
    begin
      if DefaultFields then
       CreateFields
      else
      if drsForceCreateCalcFields in FRunState then
      begin
        Exclude(FRunState,drsForceCreateCalcFields);
        CreateFields;
        SetDefaultFields(True);
        i:=0;
        while Fields[0].FieldKind in [fkCalculated, fkLookup] do
        begin
           Fields[0].Index:=FieldCount-1;
           Inc(i);
           if i>FieldCount then
            Break
        end;
      end;
      BindFields(True);

      if BlobFieldCount>0 then
      begin
        for i:=0 to Pred(FieldCount) do
        if Fields[i] is TFIBBlobField then
        begin
         TFIBBlobField(Fields[i]).FSubType:=
          FQSelect[Fields[i].FieldName].AsXSQLVAR^.sqlsubtype;
        end
        else
        if Fields[i] is TFIBMemoField then
        begin
         TFIBMemoField(Fields[i]).FSubType:=
          FQSelect[Fields[i].FieldName].AsXSQLVAR^.sqlsubtype;
        end

      end;

      FQCurrentSelect:=FQSelect;
      FCurrentRecord := -1;
      if FCacheModelOptions.FCacheModelKind=cmkLimitedBufferSize then
      begin
        if not Assigned(vPartition) then
         GetMem(vPartition,SizeOf(TRecordsPartition));

        vPartition^.BeginPartRecordNo:=-1;
        vPartition^.EndPartRecordNo  :=-1;
        vPartition^.IncludeBof:=True;
        vPartition^.IncludeEof:=False;
      end;
 
      InternalDoBeforeOpen;
      if not FCachedActive then
      begin
       FQSelect.ExecQuery;
       FOpen := FQSelect.Open;
      end
      else
       FOpen := True;
      (*
       * Initialize offsets, buffer sizes, etc...
       * 1. Initially FRecordSize is just the "RecordDataLength".
       * 2. Allocate a "model" buffer and do a dummy fetch
       * 3. After the dummy fetch, FRecordSize will be appropriately
       *    adjusted to reflect the additional "weight" of the field
       *    data.
       * 4. Set up the FCalcFieldsOffset, FBlobCacheBufferOffset and FRecordBufferSize.
       * 5. Re-allocate the model buffer, accounting for the new
       *    FRecordBufferSize.
       * 6. Finally, calls to AllocRecordBuffer will work!.
       *)
 
     InitDataSetSchema;

     FBlobCacheBufferOffset  :=FRecordSize;
     FCalcFieldsOffset := FBlobCacheBufferOffset + (BlobFieldCount * SizeOf(TFIBBlobStream));
     FRecordBufferSize := FCalcFieldsOffset + CalcFieldsSize;
     FBlockReadSize    := FBlockReadSize + (BlobFieldCount * SizeOf(TFIBBlobStream));

     FBufferChunkSize := FRecordBufferSize * FCacheModelOptions.FBufferChunks;
     vCalcFieldsSavedCache:=poCacheCalcFields in Options;
     if vCalcFieldsSavedCache then
      FRecordsCache:=
       TRecordsCache.Create(FCacheModelOptions.FBufferChunks,FRecordBufferSize,FBlockReadSize+CalcFieldsSize,FStringFieldCount)
     else
      FRecordsCache:=
       TRecordsCache.Create(FCacheModelOptions.FBufferChunks,FRecordBufferSize,FBlockReadSize,FStringFieldCount);
     FRecordsCache.CreateNewBlock;
     FRecordsCache.SaveChangeLog:=FCachedUpdates;
     j:=1;
     for i:=0 to Pred(vFieldDescrList.Capacity) do
     if vFieldDescrList[i].fdIsSeparateString then
     begin
      FRecordsCache.SetStrOffset(j,vFieldDescrList[i].fdDataOfs-DiffSizesRecData,vFieldDescrList[i].fdDataSize);
      Inc(j);
     end;
      FBPos := 0;
      FOBPos := 0;
      FBEnd := 0;
      FOBEnd := 0;
    end
    else
    begin
      FQSelect.ExecQuery;
      Exit;
    end;
    if (Filter <> '') and (not Assigned(FFilterParser) )then
      ExprParserCreate(FastTrim(Filter),FilterOptions) ;

  if (psGetOrderInfo in PrepareOptions)  or (CacheModelOptions.CacheModelKind =cmkLimitedBufferSize)
  then
   PrepareAdditionalInfo;
  if CacheModelOptions.CacheModelKind =cmkLimitedBufferSize then
  begin
    PrepareBookMarkSize;
    PrepareAdditionalSelects;
  end
  else
   BookmarkSize:=SizeOf(TFIBBookmark);
 
 
 finally
   RestoreScreenCursor(iCurScreenState);
 end;
end;

procedure TFIBCustomDataSet.InternalPost;
var 
  Qry: TFIBQuery;
  Buff: dbPChar;
  iCurScreenState: Integer;
  bInserting: Boolean;
  r:integer;
  vNeedMoveRec:boolean;
begin
  CheckEditState;
  {$IFDEF D6+}
   if not (drsInCacheRefresh in FRunState) then
    inherited InternalPost;
  {$ENDIF}
   ChangeScreenCursor(iCurScreenState);

  if (State = dsInsert) then
  begin
   bInserting := True;
   Qry := FQInsert;
  end
  else
  begin
    bInserting := False;
    Qry := FQUpdate;
  end;

  if State=dsEdit then
   vNeedMoveRec:=NeedMoveRecordToOrderPos
  else
   vNeedMoveRec:=True;

  Buff := GetActiveBuf;
  UpdateBlobInfo(Buff,ubiCheckIsNull,False,False);
  try
    with PRecordData(Buff)^ do
    begin
      if bInserting then
      begin
        if not (drsInCacheRefresh in FRunState) then
        begin
         TCachedUpdateStatus(rdFlags):= cusInserted;
        end;
        with PRecordData(Buff)^ do
        begin
         r:=GetRealRecNo;
         if (r>0) and (GetBookmarkFlag(Buff)<>bfEOF)  then
         begin
          rdRecordNumber := r-1;
         end
         else
         begin
          case FCacheModelOptions.CacheModelKind of
           cmkStandard:    rdRecordNumber := FRecordCount;
           cmkLimitedBufferSize :    rdRecordNumber := vPartition^.EndPartRecordNo+1;
          end;
         end;
        end;
        FCurrentRecord := rdRecordNumber;
      end
      else
      begin
        if not (drsInCacheRefresh in FRunState) then
        begin
         case TCachedUpdateStatus(rdFlags and 7) of
          cusUnmodified :
          begin
           TCachedUpdateStatus(rdFlags):= cusModified;
          end;
          cusUninserted:
          begin
            TCachedUpdateStatus(rdFlags):= cusInserted;
            Dec(FDeletedRecords);
          end;
         end
        end
      end;
    end;
    if (not CachedUpdates) and not (drsInCacheRefresh in FRunState)  then
    begin
      case FCacheModelOptions.CacheModelKind of
       cmkStandard:
        try
         if bInserting then
         begin
          if Unidirectional then
           FRecordsCache.Insert(FCurrentRecord mod BufferChunks)          
          else
           FRecordsCache.Insert(FCurrentRecord);
         end;
          InternalPostRecord(Qry, Buff);
        except
          if bInserting and (FCurrentRecord <=FRecordCount) then
           FRecordsCache.CancelInsert(FCurrentRecord+1);
          raise;
        end;
       cmkLimitedBufferSize:
       begin
         if not (drsInCacheRefresh in FRunState) then
          InternalPostRecord(Qry, Buff);
         if vNeedMoveRec or (not (drsInCacheRefresh in FRunState) and (poRefreshAfterPost in FOptions)) then
          DoInternalRefresh(FQRefresh,Buff,vNeedMoveRec);
         Exit;
       end;
      end;
    end
    else
    begin
      if bInserting then
      begin
       FRecordsCache.Insert(FCurrentRecord);
      end;
      WriteRecordCache(PRecordData(Buff)^.rdRecordNumber, Buff);
      FUpdatesPending := not (drsInCacheRefresh in FRunState);
    end;
    if bInserting then
    begin
     Inc(FRecordCount);
     Inc(FAllRecordCount);
    end;


   if vNeedMoveRec then
   begin
      SetState(dsBrowse);
      if IsVisible(PRecordData(Buff)) then
       MoveRecordToOrderPos;
   end
   else
    if not (poKeepSorting in Options) then
     FSortFields:=null;
  finally
   RestoreScreenCursor(iCurScreenState);
  end;
end;

procedure TFIBCustomDataSet.DoInternalRefresh(Qry: TFIBQuery; Buff:Pointer;ForceFullRefresh:boolean);
var
    i:  integer;
begin
  if FCacheModelOptions.FCacheModelKind=cmkLimitedBufferSize then
  begin
    if not ForceFullRefresh or (State=dsInsert) then
     SaveOldBuffer(Buff);
    if InternalRefreshRow(Qry,Buff) then
    begin
     if ForceFullRefresh or NeedMoveRecordToOrderPos then
      InternalFullRefresh(False, False);
    end
    else
    begin
      if State in [dsEdit,dsInsert] then
      begin
        for i:=0 to Pred(FieldCount) do
        if not Fields[i].IsBlob then
        begin
          Fields[i].Value:=Fields[i].OldValue;
        end;
       // ��� ���� ������� ����� ���������� ���������� ������ ��������, � ��
       // ��������� RefreshQuery 
      end;
      InternalFullRefresh(False,False);
    end;
  end
  else
  begin
    InternalRefreshRow(Qry,Buff);
    if Sorted and (poKeepSorting in Options) then
    begin
     if NeedMoveRecordToOrderPos then
     begin
      MoveRecordToOrderPos;
      if vLockResync>0 then
       Dec(vLockResync);
     end;
     FCurrentRecord:=Recno-1
    end;
    if not (State in [dsEdit,dsInsert]) then
     if dcForceMasterRefresh in DetailConditions then
       RefreshMasterDS;
  end;
end;

procedure TFIBCustomDataSet.InternalRefresh;
begin
  inherited;
  DoInternalRefresh(FQRefresh,ActiveBuffer,False);
end;

procedure TFIBCustomDataSet.InternalSetToRecord(Buffer: dbPChar);
begin
  FCurrentRecord :=PRecordData(Buffer)^.rdRecordNumber
end;

function TFIBCustomDataSet.IsCursorOpen: Boolean;
begin
  Result := FOpen ;
end;

function TFIBCustomDataSet.ExtLocate(const KeyFields: string; const KeyValues: Variant;
      Options: TExtLocateOptions): Boolean;
var
   VarArray: TDynArray;
begin
  CastVariantToArray(KeyValues,VarArray);
  Result := InternalLocate(KeyFields, VarArray, Options,True,lkStandard,True);
end;
 
 
 
function TFIBCustomDataSet.Lookup(const KeyFields: string; const KeyValues: Variant;
  const ResultFields: string): Variant;
var
  CurBookmark: TBookmark;
  rl:boolean;
  VarArray: array of variant;
  vQLookUp:TFIBQuery;
  OldRecno:integer;
begin
  if IsEmptyStr(ResultFields) then
  begin
    Result := null;
    Exit;
  end;
  CurBookmark := Bookmark;
  try
    if VarIsArray(KeyValues) then
     VarArray:=KeyValues
    else
    begin
      SetLength(VarArray,1);
      VarArray[0]:=KeyValues;
    end;
    case FCacheModelOptions.FCacheModelKind of
    cmkStandard:
      begin
       rl:=InternalLocate(KeyFields, VarArray, [eloInSortedDS],True,lkStandard,True);
       if rl then
       begin
         if PosCh(';', ResultFields) <> 0 then
          Result := FieldValues[ResultFields]
         else
          Result := FBN(ResultFields).Value
       end
       else
         Result := Null;
      end;
    cmkLimitedBufferSize:
      begin
       OldRecno:=GetRealRecNo;
       rl:=InternalLocate(KeyFields, VarArray, [eloInFetchedRecords],True);
       if rl then
           Result := FieldValues[ResultFields]
       else
       begin
        vQLookUp:=CreateInternalQuery('QLookUp');
        vQLookUp.OrderClause:='';
        try
         begin
          rl:=InternalLocateForLimCache(KeyFields, VarArray, [],lkStandard,vQLookUp);
          if rl then
           Result := vQLookUp[ResultFields].Value
          else
           Result := Null;
         end
        finally
         vQLookUp.Free;
        end;
       end;
       if GetRealRecNo<>OldRecno then
       begin
        MoveBy(OldRecno-GetRealRecNo);
       end;
      end;
    else
       Result := Null;
    end;
  finally
    if FCacheModelOptions.FCacheModelKind=cmkStandard then
     Bookmark := CurBookmark;
  end;
end;

procedure TFIBCustomDataSet.SetBookmarkData(Buffer: dbPChar; Data: Pointer);
var
   Rno: integer;
begin
  if Data<>nil then
  begin
   Rno:=FRecordsCache.RecordByBookMark(TFIBBookmark(Data^).bRecordNumber);
   PRecordData(Buffer)^.rdRecordNumber := Rno
  end;
end;

 
procedure TFIBCustomDataSet.SetBookmarkFlag(Buffer: dbPChar; Value: TBookmarkFlag);
begin
  if
   (PRecordData(Buffer)^.rdBookmarkFlag=bfInserted)   and (Value=bfEof)
  then
   case FCacheModelOptions.CacheModelKind of
    cmkStandard:    PRecordData(Buffer)^.rdRecordNumber := FRecordCount;
    cmkLimitedBufferSize :
     PRecordData(Buffer)^.rdRecordNumber := vPartition^.EndPartRecordNo+1
   end;
 
  PRecordData(Buffer)^.rdBookmarkFlag := Value;
end;
 
type THackQuery=class (TFIBQuery);
 
procedure TFIBCustomDataSet.SetCachedUpdates(Value: Boolean);
begin
  if Value<>FCachedUpdates then
  begin
    if not Value and FCachedUpdates and Active then
      CancelUpdates;
    if (not (csReading in ComponentState)) and Value then
    begin
     CheckDatasetClosed(' change CachedUpdates mode ');
     if FCacheModelOptions.FCacheModelKind=cmkLimitedBufferSize then
        FIBError(feCantUseLimitedCache,[CmpFullName(Self)]);
    end;
    FCachedUpdates := Value;
    THackQuery(FQSelect).FAutoCloseOnTransactionEnd:=not FCachedUpdates;
  end;
end;

procedure TFIBCustomDataSet.SetOnEndScroll(Event:TDataSetNotifyEvent);
begin
 if Assigned(Event)  then
 begin
  CreateScrollTimer;
  vScrollTimer.Interval:=WaitEndMasterInterval;
 end
 else
 begin
   vScrollTimer.Free;
   vScrollTimer:=nil;
 end;
 FOnEndScroll:=Event
end;

procedure TFIBCustomDataSet.SetDataSource(Value: TDataSource);
begin
  if IsLinkedTo(Value) then FIBError(feCircularReference, [CmpFullName(Self)]);
  if FSourceLink <> nil then FSourceLink.DataSource := Value;
end;
 

procedure TFIBCustomDataSet.SetOptions(Value:TpFIBDsOptions);
begin
 FOptions:= Value;
 {$IFDEF OBSOLETE_PROPS}
  Exclude(FOptions,poAllowChangeSqls);
 {$ENDIF} 
 if poStartTransaction in FOptions then
 begin
  QSelect.Options:=QSelect.Options+[qoStartTransaction];
  QUpdate.Options:=QUpdate.Options+[qoStartTransaction];
  QDelete.Options:=QDelete.Options+[qoStartTransaction];
  QInsert.Options:=QInsert.Options+[qoStartTransaction];
 end
 else
 begin
  QSelect.Options:=QSelect.Options-[qoStartTransaction];
  QUpdate.Options:=QUpdate.Options-[qoStartTransaction];
  QDelete.Options:=QDelete.Options-[qoStartTransaction];
  QInsert.Options:=QInsert.Options-[qoStartTransaction];
 end;

 if poNoForceIsNull in FOptions then
 begin
  QSelect.Options:=QSelect.Options+[qoNoForceIsNull];
  QUpdate.Options:=QUpdate.Options+[qoNoForceIsNull];
  QDelete.Options:=QDelete.Options+[qoNoForceIsNull];
  QInsert.Options:=QInsert.Options+[qoNoForceIsNull];
 end
 else
 begin
  QSelect.Options:=QSelect.Options-[qoNoForceIsNull];
  QUpdate.Options:=QUpdate.Options-[qoNoForceIsNull];
  QDelete.Options:=QDelete.Options-[qoNoForceIsNull];
  QInsert.Options:=QInsert.Options-[qoNoForceIsNull];
 end
end;
 
function  TFIBCustomDataSet.GetDefaultFields:boolean;
begin
    Result:= not Active and (FieldCount=0);
    if not Result then Result:=inherited DefaultFields;
end;
 
 
// Filter works
 
procedure TFIBCustomDataSet.SetFiltered(Value: Boolean);
begin
  FFilteredCacheInfo.NonVisibleRecords.Clear;
  FFilteredCacheInfo.AllRecords := -1;
  if Assigned(FFilterParser) and (FFilterParser.ExpressionText <> Filter) then
    Filter := Filter;
  inherited SetFiltered(Value);
  RefreshFilters
end;

procedure TFIBCustomDataSet.ExprParserCreate(const Text: string; Options: TFilterOptions);
const
  FldTypeMap: TFieldMap = (
    ord(ftUnknown), ord(ftString), ord(ftSmallInt), ord(ftInteger), ord(ftWord), ord(ftBoolean),
    ord(ftFloat), ord(ftFloat), ord(ftBCD), ord(ftDate), ord(ftTime), ord(ftDateTime), ord(ftBytes),
    ord(ftVarBytes), ord(ftInteger), ord(ftBlob), ord(ftBlob), ord(ftBlob), ord(ftBlob), ord(ftBlob),
    ord(ftBlob), ord(ftBlob), ord(ftUnknown), ord(ftString), ord(ftString), ord(ftLargeInt), ord(ftADT),
    ord(ftArray), ord(ftUnknown), ord(ftUnknown), ord(ftUnknown), ord(ftUnknown), ord(ftUnknown),
    ord(ftUnknown),    ord(ftUnknown), ord(ftGuid)
    {$IFDEF D6+}
     ,    ord(ftUnknown), ord(ftUnknown)
    {$ENDIF}
    {$IFDEF D10+}
      ,    ord(ftUnknown), ord(ftUnknown) ,    ord(ftUnknown), ord(ftUnknown)
    {$ENDIF}
    {$IFDEF D11+}
      ,    ord(ftUnknown), ord(ftUnknown) ,    ord(ftUnknown), ord(ftUnknown)
      , ord(ftUnknown) ,    ord(ftUnknown), ord(ftUnknown)
    {$ENDIF}
   {$IFDEF D12+}
      , ord(ftUnknown) ,    ord(ftUnknown), ord(ftUnknown)
    {$ENDIF}
    );

var CalcFieldsList:TList;
    i:integer;
    OldParser:TExpressionParser;
begin
  OldParser:=FFilterParser;
  CalcFieldsList:=TList.Create;
  Include(FRunState,drsDontCheckInactive);
  try
   for i:=0 to Pred(FieldCount) do
    if Fields[i].FieldKind=fkCalculated then
    begin
     CalcFieldsList.Add(Fields[i]);
     Fields[i].FieldKind:=fkInternalCalc;
    end;
    if IsBlank(Text) then
     FFilterParser := nil
    else
     FFilterParser := TExpressionParser.Create(Self, FastTrim(Text), Options,
                         [poExtSyntax], '', nil, FldTypeMap,
                       StrToDateFmt,SQLMaskCompare
                    );
    OldParser.Free;
  finally
   for i:=0 to Pred(CalcFieldsList.Count) do
     TField(CalcFieldsList[i]).FieldKind:=fkCalculated;
   Exclude(FRunState,drsDontCheckInactive);
   CalcFieldsList.Free;
  end;
end;
 
procedure TFIBCustomDataSet.SetFilterData(const Text: string; Options: TFilterOptions);
begin
  if Active then
  begin
    CheckBrowseMode;
    if not Assigned(FFilterParser) or
      (FFilterParser.ExpressionText <> Text) or
      (FilterOptions <> Options)
    then
      ExprParserCreate(Text,Options)
  end
  else
   FreeAndNil(FFilterParser);
  FFilteredCacheInfo.NonVisibleRecords.Clear;
  FFilteredCacheInfo.AllRecords := -1;   
  inherited SetFilterText(Text);
  inherited SetFilterOptions(Options);
  if Active and Filtered then
   First;
end;
 
procedure TFIBCustomDataSet.SetFilterOptions(Value: TFilterOptions);
begin
  SetFilterData(Filter, Value);
end;

procedure TFIBCustomDataSet.SetFilterText(const Value: string);
begin
  SetFilterData(Value, FilterOptions);
end;

procedure TFIBCustomDataSet.SetFieldData(Field: TField; Buffer: Pointer);
var
  Buff, TmpBuff: dbPChar;
  BoolValue,L:integer;
  vFi: TpFIBFieldInfo; sp: boolean;
  fi:PFIBFieldDescr;
begin
  CheckActive;
  Buff := GetActiveBuf;
  if Buff=nil then
   Buff:=ActiveBuffer;
  if Field.FieldNo < 0 then
  begin
    TmpBuff := Buff + FCalcFieldsOffset + Field.Offset;
    Boolean(TmpBuff[0]) := LongBool(Buffer);
    if Boolean(TmpBuff[0]) then
     if (Field is TFIBStringField) then
     begin
       if TFIBStringField(Field).vInSetAsString then
        L:= TFIBStringField(Field).FValueLength
       else
        L:= Q_StrLen(Buffer);
       if L>Field.DataSize-1 then
        L:=Field.DataSize-1;

       Move(Buffer^, TmpBuff[1], L);
       FillChar(TmpBuff[L+1], Field.DataSize-L,0);
     end
     else
     begin
        Move(Buffer^, TmpBuff[1], Field.DataSize);
     end;
  end
  else
  begin
    CheckEditState;
    with PRecordData(Buff)^ do
    begin
      if (Field.FieldNo > 0) and (Field.FieldNo <= vrdFieldCount) then
      begin
        Field.Validate(Buffer);
        sp := False;
         if (Field is TFIBStringField) and (Buffer<>nil) and (PAnsiChar(Buffer)[0] = #0)
          and (TFIBStringField(Field).FEmptyStrToNull)
         then
         begin
            vFi := ListTableInfo.GetFieldInfo(DataBase,GetRelationTableName(Field),
                    GetRelationFieldName(Field),False
                   );
            sp:= not(
                     (vFi<>nil) and(vFi.DefaultValue='') and
                      vFi.DefaultValueEmptyString and
                     (not QSelect[Field.FieldName].IsNullable)
                    )
         end;
        if (Buffer = nil) or sp then
        begin
          rdFields[Field.FieldNo].fdIsNull := True;
          fi:=vFieldDescrList[Field.FieldNo-1];
          if fi^.fdIsSeparateString then
              PInteger(@Buff[fi^.fdDataOfs])^:=0;
        end
        else
        begin
         fi:=vFieldDescrList[Field.FieldNo-1];
         if Field is TFIBBooleanField then
         begin
          BoolValue:=PWord(Buffer)^;
          Move(BoolValue, Buff[fi.fdDataOfs], fi.fdDataSize)
         end
         else
         begin
//          if (Field is TFIBStringField) or (Field is TFIBWideStringField)  then
          if (fi^.fdDataType =SQL_VARYING) or (fi^.fdDataType=SQL_TEXT)  then
          begin
            if (Field is TFIBStringField) and TFIBStringField(Field).vInSetAsString then
             L:= TFIBStringField(Field).FValueLength
            else
             L:= Q_StrLen(Buffer);
            if L>fi.fdDataSize then
             L:=fi.fdDataSize;
 
            if (poTrimCharFields in FOptions) then
            begin
             while (L>0) and(PAnsiChar(Buffer)[L-1] <= ' ') do
              Dec(L);
            end;

            if fi^.fdIsSeparateString then
            begin
              PInteger(@Buff[fi^.fdDataOfs])^:=L;
              Move(Buffer^, Buff[fi^.fdDataOfs+SizeOf(Integer)],L);
              if L<fi.fdDataSize then
               PAnsiChar(Buff)[fi^.fdDataOfs+SizeOf(Integer)+L]:=#0
            end
            else
            begin
              Move(Buffer^, Buff[fi^.fdDataOfs],L);
              if L<fi.fdDataSize then
               PAnsiChar(Buff)[fi^.fdDataOfs+L]:=#0;
            end;
          end
          else
          case fi^.fdDataType of
            SQL_FLOAT:
              PSingle(@Buff[fi^.fdDataOfs])^:=PDouble(Buffer)^;
            SQL_LONG:
             if fi^.fdDataScale<>0 then
              PLong(@Buff[fi^.fdDataOfs])^:=Round(PDouble(Buffer)^*E10[-fi^.fdDataScale])
             else
              PLong(@Buff[fi^.fdDataOfs])^:=PLong(Buffer)^;
             SQL_SHORT:
             if fi^.fdDataScale<>0 then
               PShort(@Buff[fi^.fdDataOfs])^:=Round(PDouble(Buffer)^*E10[-fi^.fdDataScale])
             else
              PShort(@Buff[fi^.fdDataOfs])^:=PShort(Buffer)^;
            SQL_INT64:
             if (fi^.fdDataScale < -4) and not (psSQLINT64ToBCD in PrepareOptions) then
              PDouble(@Buff[fi^.fdDataOfs])^:=PDouble(Buffer)^
             else
              PInt64(@Buff[fi^.fdDataOfs])^:=PInt64(Buffer)^;
          else
            Move(Buffer^, Buff[fi^.fdDataOfs],fi.fdDataSize);
          end;
         end;
          rdFields[Field.FieldNo].fdIsNull := False;
          if (TCachedUpdateStatus(rdFlags and 7) = cusUnmodified) and not (drsInCacheRefresh in FRunState)
          then
          begin
            if State = dsInsert then
              TCachedUpdateStatus(rdFlags):=cusInserted
            else
              TCachedUpdateStatus(rdFlags):=cusModified;

            Inc(FCountUpdatesPending);
          end;
          SetModified(True);
        end;
      end;
    end;
  end;
  if not (State in [dsCalcFields, dsFilter, dsNewValue]) then
    DataEvent(deFieldChange, Longint(Field));
end;

procedure TFIBCustomDataSet.SetRealRecNo(Value: Integer;ToCenter:boolean =False);
var 
   RValue: Integer;
   OldRecno :integer;
begin
  CheckBrowseMode;
  if (Value < 1) then
    RValue := 0
  else
  begin
   if FCacheModelOptions.FCacheModelKind=cmkStandard then
   begin
    if Value > FRecordCount then
    begin
      InternalLast;
      RValue := Min(FRecordCount, Value);
    end
    else
     RValue :=Value-1;
   end
   else
   begin
    // only for internal use
    RValue:=Value-1;
    if (RValue > vPartition.EndPartRecordNo) or (RValue < vPartition.BeginPartRecordNo)
    then
     Exit;
   end;
  end;
  OldRecno:=GetRealRecNo;
  if Eof or Bof or (Value <> OldRecno) then
  begin
    DoBeforeScroll;
    FCurrentRecord := RValue;
    if ToCenter then
     Resync([rmCenter])
    else
     Resync([]);
    if FCacheModelOptions.FCacheModelKind=cmkStandard then
    begin
     if Value<1 then
     begin
      MoveBy(-1); //BOF
      DoAfterScroll;      
      Exit;
     end
     else
     if Value > FRecordCount then
     begin
      MoveBy(1); //EOF
      DoAfterScroll;
      Exit;
     end;
    end;
    if not ToCenter and (RValue-OldRecno<=BufferCount-ActiveRecord) then
      SetRecordPosInBuffer(ActiveRecord+RValue-OldRecno+1);
     DoAfterScroll;
  end;
end;
 
procedure TFIBCustomDataSet.SetRecNo(Value: Integer);
begin
  SetRealRecNo(Value);
end;
 
function TFIBCustomDataSet.Translate(Src, Dest: PAnsiChar; ToOem: Boolean): Integer;
begin
  if Src <> nil then
  begin
    StrCopy(PAnsiChar(Dest), PAnsiChar(Src));
    Result := Q_StrLen(PAnsiChar(Dest));
  end
  else
    Result := 0;
end;
 


// Array support

{$IFDEF SUPPORT_ARRAY_FIELD}
function  TFIBCustomDataSet.ArrayFieldValue(Field:TField):Variant;
var 
  qf:  TFIBXSQLVAR;
begin
 Result:=False;
 if not Assigned(Field) then Exit;
 qf:=QSelect[Field.FieldName];
 if qf.FIBArray=nil then
  Exit;
 Result:=
  qf.FIBArray.GetFieldArrayValues(Field,DBHandle,TRHandle)
end;
 
procedure TFIBCustomDataSet.SetArrayValue(Field:TField;Value:Variant);
var
 qf: TFIBXSQLVAR;
begin
 if not (State in [dsEdit,dsInsert]) then
  Exit;
 if not Assigned(Field) then
  Exit;
 if VarIsEmpty( Value ) or VarIsNull( Value ) then
 begin
   Field.Clear;              
   Exit;
 end;
 qf:=QSelect[Field.FieldName];
 if qf.FIBArray=nil then
  Exit;
 AutoStartUpdateTransaction;
 CheckUpdateTransaction;
 qf.FIBArray.SetFieldArrayValue(Value,Field, DBHandle,@UpdateTransaction.Handle)
end;

function TFIBCustomDataSet.GetElementFromValue( Field:TField;
          Indexes:array of integer):Variant;
var
  qf: TFIBXSQLVAR;
begin
 if not Assigned(Field) then
  Exit;
 qf:=QSelect[Field.FieldName];
 if qf.FIBArray=nil then Exit;
 Result:=
  qf.FIBArray.GetElementFromField(Field, Indexes,DBHandle,TRHandle );
end;
 
procedure TFIBCustomDataSet.SetArrayElementValue(Field:TField;Value:Variant;
     Indexes:array of integer
);
var
 qf: TFIBXSQLVAR;
begin
 if not (State in [dsEdit,dsInsert]) then
  Exit;
 if not Assigned(Field) then
  Exit;
 qf:=QSelect[Field.FieldName];
 if qf.FIBArray=nil then Exit;
 AutoStartUpdateTransaction;
 CheckUpdateTransaction;
 qf.FIBArray.PutElementToField(Field,Value,Indexes,DBHandle,@UpdateTransaction.Handle);
end;
{$ENDIF}
 
function TFIBDataSet.DoStoreActive:boolean;
begin
 Result:=Active and (Database.StoreConnected or not (csDesigning in ComponentState))
end;

 
(*
 * Support routines
 *)
 
function RecordDataLength(n: Integer): Long;
begin
  Result := SizeOf(TRecordData) + ((n - 1) * SizeOf(TFieldData));
end;
 
(*
 * It allows you to remove a record from a
 * DataSet without deleting it.
 *
 * "Remove" the current record from FromDS. (It marks the record deleted
 * without causing a post.
 *)
procedure FilterOut(FromDS: TFIBCustomDataSet);
var
  BufferFrom: PRecordData;
begin
 with FromDS do
 begin
  CheckDatasetOpen(' do delete from cache ') ;
  DisableControls;
  try
    BufferFrom := PRecordData(GetActiveBuf);
    if Assigned(BufferFrom) then
    begin
      TCachedUpdateStatus(BufferFrom^.rdFlags):=cusDeletedApplied;
      Inc(FDeletedRecords);
      WriteRecordCache(BufferFrom^.rdRecordNumber, dbPChar(BufferFrom));
      SetCurrentRecord(ActiveRecord);
      Resync([]);
    end;
  finally
    EnableControls;
  end;
 end;
end;
 

 
(*
 * Do a quick sort on the current Result set in the data set.
 * If bFetchAll, then ensure that all records are fetched before doing
 * the sort.
 * Fields is a list of the fields to sort on.
 * Ordering is a list of booleans specifying DESC or ASC (False, True)
 *
 * Based on randomized quick sort from
 *)

 
procedure FastSort(DataSet: TFIBCustomDataSet; aFields:array of TField; Ordering: array of Boolean);
 
  function Compare1(Num:integer;f:TField;aOrdering:boolean;y:variant; var x:variant):integer;
   var
     SortOrder: integer;
  begin
    try
     x:=DataSet.RecordFieldValue(f,Num+1);
     if aOrdering then
      SortOrder:=1
     else
      SortOrder:=-1;
     Result:=DataSet.CompareFieldValues(f,x,y)*SortOrder;
    except
      Result := 0;
    end
  end;
 
   function Compare(Num,FCount:integer;y: array of variant; var x1: array of variant):integer;
   var
     SortOrder: integer;
     FCur:integer;
   begin
    Result := 0;
    for FCur:=0 to FCount do
    try
     x1[FCur]:=DataSet.RecordFieldValue(aFields[fCur],Num+1);
     if Ordering[fCur] then
      SortOrder:=1
     else
      SortOrder:=-1;
 
     Result:=DataSet.CompareFieldValues(aFields[FCur],x1[FCur],y[fCur])*SortOrder;
     if Result<>0 then
      Exit;
    except
     Result := 0;
     Exit
    end
   end;

   procedure QuickSort1(L, R: Integer;f:TField;aOrdering:boolean);
   var
     I, J: Integer;
     P,V,V1: Variant;
   begin
     repeat
       I := L;
       J := R;
       P:=DataSet.RecordFieldValue(f,((L + R) shr 1)+1);
       repeat
         while (I<DataSet.FRecordCount) and (Compare1(I,f ,aOrdering,P,V) < 0) do
          Inc(I);
         while (J>=0) and (Compare1(J,f ,aOrdering, P,V1) > 0) do
          Dec(J);
         if I <= J then
         begin
           if (i<>j) and (V<>V1) then
            DataSet.FRecordsCache.SwapRecords(I, J);
           Inc(I);
           Dec(J);
         end;
       until I > J;
       if L < J then QuickSort1(L, J,f,aOrdering);
       L := I;
     until I >= R;
   end;

   procedure QuickSort(L, R: Integer);
   var
     I, J: Integer;
     P: array of variant;
     V: array of variant;
     V1:array of variant;
     fCur,fCount:integer;
   begin
     fCount:= High(aFields);
     SetLength(P,fCount+1);
     SetLength(V,fCount+1);
     SetLength(V1,fCount+1);
     repeat
      I := L;
      J := R;
      for fCur:=0 to fCount do
       P[fCur]:=DataSet.RecordFieldValue(aFields[fCur],((L + R) shr 1)+1);
      repeat
         while (I<DataSet.FRecordCount) and (Compare(I,FCount,P,V) < 0) do
          Inc(I);
         while (J>=0) and (Compare(J,FCount,P,V1) > 0) do
          Dec(J);
         if I <= J then
         begin
           if (I<>J) and not EasyCompareVarArray1(V,V1,fCount) then
            DataSet.FRecordsCache.SwapRecords(I, J);
           Inc(I);
           Dec(J);
         end;
      until (I > J) ;
      if L < J then
       QuickSort(L, J);
      L := I;
     until I >= R;
   end;

 begin
    if DataSet.FRecordCount<2 then
     Exit;
    if High(aFields)=0 then
     QuickSort1(0,DataSet.FRecordCount-1,aFields[0],Ordering[0])
    else
     QuickSort(0,DataSet.FRecordCount-1);
 end;

 


procedure Sort(DataSet: TFIBCustomDataSet; aFields: array of const;
  Ordering: array of Boolean);
var
  vFieldCount, i:  Integer;
// ��������� ��� ���������� ������� �������� DataSet
  vOptions:TFIBUpdateRecordTypes;
  B:TBookmark;
  tf:TField;
  iCurScreenState: Integer;
 
  function GetField(IndexF:integer):TField;
  begin
     with DataSet do
      case aFields[IndexF].VType of
        vtChar :
        begin
          Result:=DataSet.FindField(aFields[IndexF].vChar);
          if Result=nil
          then raise
           Exception.Create(SCantSort+IntToStr(IndexF)+']');
        end;
        vtInteger: Result:=Fields[aFields[IndexF].VInteger];
        vtObject :
        begin
          if not(aFields[IndexF].vObject is TField) or
             (TField(aFields[IndexF].vObject).DataSet<>DataSet)
          then raise Exception.Create(SCantSort+IntToStr(IndexF)+']');
          Result:=TField(aFields[IndexF].VObject);
        end;
        vtAnsiString :
        begin
          Result:=DataSet.FindField(string(Ansistring(aFields[IndexF].vString)));
          if Result=nil then
           raise Exception.Create(SCantSort+IntToStr(IndexF)+']');
        end;
        vtVariant:
         case VarType(aFields[IndexF].VVariant^) of
          varInteger         :  Result:=Fields[aFields[IndexF].VVariant^];
          varString,varOleStr:
          begin
            Result:=DataSet.FindField(aFields[IndexF].VVariant^);
            if Result=nil then
             raise  Exception.Create(SCantSort+IntToStr(IndexF)+']');
          end
         else
          raise  Exception.Create(SCantSort+IntToStr(IndexF)+']');
         end;
        vtWideString :
        begin
          Result:=DataSet.FindField(WideString(aFields[IndexF].VWideString));
          if Result=nil then
           raise Exception.Create(SCantSort+IntToStr(IndexF)+']');
        end;
        vtUnicodeString:
        begin
          Result:=DataSet.FindField(string(aFields[IndexF].vString));
          if Result=nil then
           raise Exception.Create(SCantSort+IntToStr(IndexF)+']');
        end                             
      else
          raise  Exception.Create(SCantSort+IntToStr(IndexF)+']');
      end;
  end;
var
 vSortedFields:  array of TField;
 
begin
  DataSet.CheckDatasetOpen(' do local sorting ') ;
  TFIBCustomDataSet(DataSet).ChangeScreenCursor(iCurScreenState);
  B:=DataSet.Bookmark;
  DataSet.DisableControls;
  DataSet.DisableScrollEvents;
  DataSet.FetchAll;
  with DataSet do
  begin
    FFilteredCacheInfo.NonVisibleRecords.Clear;
    FFilteredCacheInfo.AllRecords := -1;
 
    vFieldCount := High(aFields) - Low(aFields) + 1;
    SetLength(vSortedFields,vFieldCount);
 
{$IFNDEF LINUX}
    FSortFields:=VarArrayCreate([0,vFieldCount-1,0,2],varVariant);
{$ELSE}
    FSortFields:=VarArrayCreate([0,vFieldCount-1,0,3],varVariant);
{$ENDIF}
    for i := Low(aFields) to High(aFields) do
    begin
       tf:=GetField(i);
       FSortFields[i,1]:=Ordering[i];
       FSortFields[i,2]:=False; // NULLS FIRST OR LAST
       FSortFields[i,0]:=tf.FieldName;
       vSortedFields[i]:=tf;
    end;
    FIsClientSorting:=True;
  end;
 
  if DataSet.FRecordCount<2 then
  begin
    DataSet.EnableScrollEvents;
    DataSet.EnableControls;
    TFIBCustomDataSet(DataSet).RestoreScreenCursor(iCurScreenState);
    Exit;
  end;
  vOptions:=DataSet.UpdateRecordTypes;
  DataSet.UpdateRecordTypes:=[cusUnModified,cusModified,cusInserted,
                                cusUnInserted,cusDeleted];
 
 try
  try
   FastSort(DataSet,vSortedFields,Ordering);
  except
   DataSet.FSortFields := null;
   raise 
  end;
 finally
   DataSet.UpdateRecordTypes:=vOptions;
   DataSet.Bookmark:=B;
   TFIBCustomDataSet(DataSet).RestoreScreenCursor(iCurScreenState);
   DataSet.EnableScrollEvents;
   DataSet.EnableControls;
 end;
end;

 
(* TFIBDSBlobStream *)
constructor TFIBDSBlobStream.Create(AField: TField; ABlobStream: TFIBBlobStream;
  Mode: TBlobStreamMode; ABlobID: TISC_QUAD;aBlobDataArray: PBlobDataArray);
var
 vDataSet: TFIBCustomDataSet;
begin
  FModified := Mode=bmWrite;
  FField := AField;
  FBlobStream := ABlobStream;
  FBlobDataArray:=aBlobDataArray;
  if Assigned(FBlobStream ) then
  begin
   FBlobID:=FBlobStream.BlobID;
//   FBlobStream.Mode:=Mode;
   if AField.DataSet is TFIBCustomDataSet then
     vDataSet:=TFIBCustomDataSet(AField.DataSet)
   else
     vDataSet:=nil;
   if Assigned(vDataSet) then
    if (Mode=bmRead) and  Assigned(vDataSet.FOnBlobFieldRead) then
      FOnBlobFieldRead:=vDataSet.FOnBlobFieldRead
    else
      FOnBlobFieldRead:=nil;

   FBlobStream.DoSeek(0, soFromBeginning,DoCallBack);
   if (Mode = bmWrite) then
    FBlobStream.Truncate;
  end
  else
   FBlobID:=ABlobID
end;

destructor TFIBDSBlobStream.Destroy;
begin
  if FModified then
  begin
    FModified := False;
    if not TBlobField(FField).Modified then
      TBlobField(FField).Modified := True;
    TFIBCustomDataSet(FField.DataSet).DataEvent(deFieldChange, Longint(FField));
  end;
  inherited Destroy;
end;
 
procedure TFIBDSBlobStream.DoCallBack(BlobSize:integer; BytesProcessing:integer; var Stop:boolean);
begin
   if (GlobalContainer<>nil)  then
     GlobalContainer.DoOnReadBlobField(TBlobField(FField),BlobSize,BytesProcessing,Stop);
   if Assigned(FOnBlobFieldRead) then
   begin
    FOnBlobFieldRead(TBlobField(FField),BlobSize,BytesProcessing,Stop);
   end
end;

 
function TFIBDSBlobStream.Read(var Buffer; Count: Longint): Longint;
begin
  if Assigned(FBlobStream ) then
   case FField.DataSet.State of
     dsOldValue:
      Result := FBlobStream.ReadOldBuffer(Buffer, Count) ;
   else
    Result := FBlobStream.Read(Buffer, Count)
   end
  else
   Result := 0
end;

function TFIBDSBlobStream.Seek(Offset: Longint; Origin: Word): Longint;
begin
  if Assigned(FBlobStream ) then
   case FField.DataSet.State of
     dsOldValue:
      Result := FBlobStream.SeekInOldBuffer(Offset, Origin);
   else
    Result := FBlobStream.Seek(Offset, Origin)
   end
  else
    Result := 0
end;

procedure TFIBDSBlobStream.SetSize(NewSize: Longint);
begin
  if Assigned(FBlobStream ) then
   FBlobStream.SetSize(NewSize);
end;

function TFIBDSBlobStream.Write(const Buffer; Count: Longint): Longint;
begin
  if (FField is TFIBBlobField) and TFIBBlobField(FField ).FIsClientCalcField then
  else
  if not (FField.DataSet.State in [dsEdit, dsInsert]) then
    FIBError(feNotEditing, [CmpFullName(FField.DataSet)]);
  FModified := True;
  TFIBDataSet(FField.DataSet).RecordModified(True);
  TBlobField(FField).Modified := True;
  if Assigned(FBlobStream) then
  begin
   Result := FBlobStream.Write(Buffer, Count);
  end
  else
   Result:=0
end;


 
 
function TFIBCustomDataSet.FieldExist(const FieldName: string;
  var FieldIndex: integer): boolean;
var
  tf: TField;
begin
 tf:=FindField(FieldName);
 Result:= Assigned(tf);
 if Result then
  FieldIndex:=tf.Index;
end;

function TFIBCustomDataSet.FieldValue(const FieldIndex: integer;
  Old: boolean): variant;
var
  tf: TField;
begin
 tf:=Fields[FieldIndex];
 if Old and (State<>dsInsert) then
  Result:= tf.OldValue
 else
  Result:= tf.Value
end;
 
function TFIBCustomDataSet.FieldValue(const FieldName: string;
  Old: boolean): variant;
var
  tf:  TField;
begin
 tf:=FBN(FieldName);
 if Old then
  Result:= tf.OldValue
 else
  Result:= tf.Value
end;

function TFIBCustomDataSet.ParamExist(const ParamName: string; var ParamIndex:integer): boolean;
begin
 Result:=QSelect.ParamExist(ParamName,ParamIndex);
end;

function TFIBCustomDataSet.ParamValue(const ParamIndex: integer): variant;
begin
 Result:=QSelect.ParamValue(ParamIndex)
end;

function TFIBCustomDataSet.ParamValue(const ParamName: string): variant;
begin
 Result:=QSelect.ParamValue(ParamName)
end;
 
 
function TFIBCustomDataSet.ParamCount: integer;
begin
 Result:=Params.Count
end;
 
function  TFIBCustomDataSet.ParamName(ParamIndex:integer):string;
begin
 Result:=Params[ParamIndex].Name;
end;

function TFIBCustomDataSet.FieldsCount: integer;
begin
  Result:=FieldCount
end;

function  TFIBCustomDataSet.FieldName(FieldIndex:integer):string;
begin
  Result:=Fields[FieldIndex].FieldName;
end;

procedure TFIBCustomDataSet.SetParamValue(const ParamIndex: integer;
  aValue: Variant);
begin
  Params[ParamIndex].Value:=aValue;
end;
 
function  TFIBCustomDataSet.IEof:boolean;
begin
  Result:=Eof
end;

procedure TFIBCustomDataSet.INext;
begin
  Next
end;
 
//
 
procedure TFIBCustomDataSet.DoAfterEndTransaction(
  EndingTR: TFIBTransaction; Action: TTransactionAction; Force: Boolean);
begin
 if Assigned(FAfterEndTr) then
  FAfterEndTr(EndingTR,Action,Force);
end;

procedure TFIBCustomDataSet.DoAfterEndUpdateTransaction(
  EndingTR: TFIBTransaction; Action: TTransactionAction; Force: Boolean);
begin
 if Assigned(FAfterEndUpdTr) then
  FAfterEndUpdTr(EndingTR,Action,Force);
end;
 
procedure TFIBCustomDataSet.DoAfterStartTransaction(Sender: TObject);
begin
 if Assigned(FAfterStartTr) then
  FAfterStartTr(Sender);
end;
 
procedure TFIBCustomDataSet.DoAfterStartUpdateTransaction(Sender: TObject);
begin
 if Assigned(FAfterStartUpdTr) then
  FAfterStartUpdTr(Sender);
end;
 
procedure TFIBCustomDataSet.DoBeforeEndTransaction(
  EndingTR: TFIBTransaction; Action: TTransactionAction; Force: Boolean);
begin
 if Assigned(FBeforeEndTr) then
  FBeforeEndTr(EndingTR,Action,Force);
end;
 
procedure TFIBCustomDataSet.DoBeforeEndUpdateTransaction(
  EndingTR: TFIBTransaction; Action: TTransactionAction; Force: Boolean);
begin
 if Assigned(FBeforeEndUpdTr) then
  FBeforeEndUpdTr(EndingTR,Action,Force);
end;

procedure TFIBCustomDataSet.DoBeforeStartTransaction(Sender: TObject);
begin
 if Assigned(FBeforeStartTr) then
  FBeforeStartTr(Sender);
end;
 
procedure TFIBCustomDataSet.DoBeforeStartUpdateTransaction(
  Sender: TObject);
begin
 if Assigned(FBeforeStartUpdTr) then
  FBeforeStartUpdTr(Sender);
end;

 
 
{ TFIBGuidField }
 
class procedure TFIBGuidField.CheckTypeSize(Value: Integer);
begin
  if not Value in [38,16] { Length(GuidString) } then
    DatabaseError(SInvalidFieldSize);
end;
 
constructor TFIBGuidField.Create(AOwner: TComponent);
begin
  SetLength(FBuffer,38);
  pBuffer:=@FBuffer[1];
  inherited Create(AOwner);
end;

destructor  TFIBGuidField.Destroy;
begin
  inherited Destroy
end;


function TFIBGuidField.GetAsVariant: variant;
begin
 Result:=GetAsString
end;

 

procedure TFIBGuidField.SetAsVariant(const Value: Variant);
var
  GuidValue:  TGuid;
  sValue:string;
begin
  sValue:=VarToStr(Value);
  if Length(sValue)=0 then
   Clear
  else
  begin
   GuidValue:=StringAsGuid(AnsiString(sValue));
   SetData(@GuidValue)
  end;
end;

function TFIBGuidField.GetAsGuid: TGUID;
begin
 if not GetData(pBuffer) then
  Result:=fibGUID_NULL
 else
  Result:=StringAsGUID(FBuffer)
end;
 
 
 
procedure TFIBGuidField.SetAsGuid(const Value: TGUID);
begin
 if IsEqualGUIDs(Value,fibGUID_NULL) then
  Clear
 else
   SetData(@Value)
end;

procedure TFIBGuidField.SetAsString(const Value: string);
var GuidValue:TGuid;
begin
  if Length(Value)=0 then
   Clear
  else
  begin
   GuidValue:=StringAsGuid(AnsiString(Value));
   SetData(@GuidValue)
  end;
end;


constructor TCacheModelOptions.Create(Owner:TFIBCustomDataSet);
begin
  inherited Create;
  vOwner:=Owner;
  FBufferChunks:=vBufferCacheSize
end;

procedure TCacheModelOptions.SetBufferChunks(Value: Integer);
begin
  vOwner.CheckInactive;
  if (Value <= 0) then
    FBufferChunks := vBufferCacheSize
  else
    FBufferChunks := Value;

  if FCacheModelKind=cmkLimitedBufferSize then
   if FBufferChunks<vMinBufferChunksForLimCache then
    FBufferChunks:=vMinBufferChunksForLimCache

end;


procedure TCacheModelOptions.SetCacheModelKind(Value:TCacheModelKind);
begin
 if Value<>FCacheModelKind then
 begin
   vOwner.CheckInactive;
   case Value  of
     cmkStandard:
     begin
      FreeMem(vOwner.vPartition);
      vOwner.vPartition:=nil
     end;
     cmkLimitedBufferSize:
     begin
       if not (csLoading in vOwner.ComponentState) then
        if not vOwner.CanHaveLimitedCache then
         FIBError(feCantUseLimitedCache,[CmpFullName(vOwner)]);
       if FBufferChunks<vMinBufferChunksForLimCache then
        FBufferChunks:=vMinBufferChunksForLimCache;
        if not Assigned(vOwner.vPartition) then
        begin
         GetMem(vOwner.vPartition,SizeOf(TRecordsPartition));
         vOwner.vPartition^.BeginPartRecordNo:=-1;
         vOwner.vPartition^.EndPartRecordNo  :=-1;
         vOwner.vPartition^.IncludeBof       :=False;
         vOwner.vPartition^.IncludeEof       :=False;
        end;
     end;
   end;
  FCacheModelKind:=Value;
 end;
end;

function TFIBCustomDataSet.GetGroupByString: string;
begin
 Result:=FQSelect.GroupByClause
end;

function TFIBCustomDataSet.GetMainWhereClause: string;
begin
 Result:=FQSelect.MainWhereClause
end;

procedure TFIBCustomDataSet.SetGroupByString(const Value: string);
begin
 FQSelect.GroupByClause:=Value
end;
 
procedure TFIBCustomDataSet.SetMainWhereClause(const Value: string);
begin
 FQSelect.MainWhereClause:=Value
end;
 
function TFIBCustomDataSet.GetPlanClause: string;
begin
 Result:=FQSelect.PlanClause
end;
 
procedure TFIBCustomDataSet.SetPlanClause(const Value: string);
begin
 FQSelect.PlanClause:=Value
end;


{$IFDEF CSMonitor}
procedure TFIBCustomDataSet.SetCSMonitorSupport(Value:TCSMonitorSupport);
begin
 FCSMonitorSupport.Assign(Value)
end;
 
 
procedure TFIBCustomDataSet.SetCSMonitorSupportToQ;
var i: integer;
  ls: TList;
begin
  ls := TList.Create;
  if Assigned(FQDelete) then ls.Add(FQDelete);
  if Assigned(FQInsert) then ls.Add(FQInsert);
  if Assigned(FQRefresh) then ls.Add(FQRefresh);
  if Assigned(FQUpdate) then ls.Add(FQUpdate);
  if Assigned(FQSelect) then ls.Add(FQSelect);
  if Assigned(FQSelectDesc) then ls.Add(FQSelectDesc);
  if Assigned(FQSelectPart) then ls.Add(FQSelectPart);
  if Assigned(FQBookMark) then ls.Add(FQBookMark);
  for i := 0 to ls.Count - 1 do
  begin
    TFIBQuery(ls[i]).CSMonitorSupport.Enabled := FCSMonitorSupport.Enabled;
    TFIBQuery(ls[i]).CSMonitorSupport.IncludeDatasetDescription :=
      FCSMonitorSupport.IncludeDatasetDescription;
  end;
  ls.Free;             
end;
{$ENDIF}
end.
