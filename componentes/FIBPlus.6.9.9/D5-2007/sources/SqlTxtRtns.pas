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

unit SqlTxtRtns;

{$I FIBPlus.inc}

interface
uses
 SysUtils,Classes,StrUtil,
 {$IFDEF WINDOWS}
  Windows {$IFDEF D6+}, Variants{$ENDIF}
  ;

 {$ENDIF}
 {$IFDEF LINUX}
  Types , Variants;
 {$ENDIF}


type
  TSQLKind=(skUnknown,skSelect,skUpdate,skInsert,skDelete,skExecuteProc,skDDL,skExecuteBlock);
  TParserState =(sNormal,sQuote,sComment,sFBComment,sQuoteSingle);
  TOnScanSQLText = procedure(Position:integer;var StopScan:boolean) of object;
  TChars = set of Char;

  TSQLSection = (stUnknown,stSelect, stFields,
    stUpdate,stInsert,stDelete,stExecute, stSet, stComment,
    stFrom, stWhere, stGroupBy, stHaving,
    stUnion,    stPlan, stOrderBy, stForUpdate
  );


  TSQLSections = array of TSQLSection;

  TSQLParser  = class
  private
   FState  :TParserState;
   FCurPos :integer;
   FResultPos:integer;
   FBracketOpened:integer;
   FSQLText:string;
   FLen: integer;
   FReserved : integer;
   FReserved1: integer;
   FScanInBrackets:boolean;
   FFirstPos   :integer;
   FSQLKind    :TSQLKind;
   FCanParamsCheck:boolean;
   FTables     :TStrings;
   FBracketOpenedBeforeScan:integer;
   procedure   SetSQLText(const Value: string);
   function    IsClause(Position:integer;const Clause:string):boolean;
   function    GetSQLKind:TSQLKind;
  protected
    procedure  IsOrderBegin(Position:integer;var Yes:boolean);
    procedure  IsGroupBegin(Position:integer;var Yes:boolean);
    procedure  IsByBegin(Position:integer;var Yes:boolean);
    procedure  IsHaving(Position:integer;var Yes:boolean);
    procedure  IsMainOrderBegin(Position:integer;var Yes:boolean);
    procedure  IsMainGroupBegin(Position:integer;var Yes:boolean);    
    procedure  IsFromBegin(Position:integer;var Yes:boolean);
    procedure  IsWhereBegin(Position:integer;var Yes:boolean);
    procedure  IsWhereEnd(Position:integer;var Yes:boolean);

    procedure  IsMainWhereBegin(Position:integer;var Yes:boolean);
    procedure  IsMainFromBegin(Position:integer;var Yes:boolean);
    procedure  IsFromEnd(Position:integer;var Yes:boolean);
    procedure  IsPlanBegin(Position:integer;var Yes:boolean);
    procedure  IsPlanEnd(Position:integer;var Yes:boolean);
    procedure  IsSetBegin(Position:integer;var Yes:boolean);
    procedure  IsIntoBegin(Position:integer;var Yes:boolean);
    procedure  IsUpdateBegin(Position:integer;var Yes:boolean);

    function   IsSelect(Position:integer):boolean;
    function   IsUpdate(Position:integer):boolean;
    function   IsDelete(Position:integer):boolean;
    function   IsInsert(Position:integer):boolean;
    function   IsExecute(Position:integer):boolean;
    function   IsExecuteProc(Position:integer):boolean;
    function   IsExecuteBlock(Position:integer):boolean;

    function   IsDDL:boolean;
    procedure  FillMainTables(WithSP:boolean=False);
  public
   constructor Create; overload;
   constructor Create(const aSQLText:string); overload;
   destructor  Destroy; override;
   procedure   ScanText(FromPosition:integer;Proc:TOnScanSQLText);

   function    PosInSections(Position:integer):TSQLSections; overload;
   function    PosInSections(ScanFrom,Position:integer; var EndScan:integer):TSQLSections; overload;

   function    DispositionMainFrom:TPoint;
   function    MainFrom:string;
   function    ModifiedTables:string;

   function    OrderText(var StartPos,EndPos:integer):string;
   function    OrderClause:string;
   function    SetOrderClause(const Value:string):string;
   function    GetOrderInfo:Variant;
   function    GroupByText(var StartPos,EndPos:integer):string;
   function    GroupByClause:string;
   function    SetGroupClause(const Value:string):string;

   function    GetFieldsClause:string;
   function    SetFieldsClause(const NewFields:string):string;

   function    WhereClause(N:integer;var  StartPos,EndPos:integer):string;
   function    SetWhereClause(N:Integer;const Value:string):string;
   function    SetMainWhereClause(const Value:string):string;
   function    MainWhereClause(var  StartPos,EndPos:integer):string;
   function    WhereCount:integer;
   function    MainWhereIndex:integer;
   function    AddToMainWhere(const NewClause:string;ForceCLRF:boolean = True):string;

   function    PlanCount:integer;
   function    PlanText(N:integer;var  StartPos,EndPos:integer):string;

   function    MainPlanIndex:integer;
   function    MainPlanText(var  StartPos,EndPos:integer):string;
   function    SetMainPlan(const Text:string):string;
   function    GetMainPlan:string;

   function    RecCountSQLText:string;
   function    GetAllTables(WithSP:boolean=False):TStrings;
  public
   property    SQLText:string read FSQLText write SetSQLText;
   property    Len :integer read FLen write FLen;
   property    FirstPos   :integer read FFirstPos;
   property    MainPlanClause:string   read GetMainPlan ;
   property    SQLKind :TSQLKind read FSQLKind;
   property    CanParamsCheck:boolean read FCanParamsCheck;
  end;

const
   SpaceStr='    ';
   ForceNewStr=#13#10+SpaceStr;
   QuotMarks=#39;

 function  DispositionFrom(const SQLText:string):TPoint;
 procedure AllSQLTables(SQLText:string;aTables:TStrings; WithSP:boolean=False
 ;WithAliases:boolean =False
 );
 procedure AllTables(const SQLText:string;aTables:TStrings; WithSP:boolean =False
  ;WithAliases:boolean =False
 );

 function  TableByAlias(const SQLText,Alias:string):string;
 function  AliasForTable(const SQLText,TableName:string):string;

 function  FullFieldName(const SQLText,aFieldName:string):string;
 function  FieldNameFromSelect(const SQLText, FieldName: String):String;
 function  AddToWhereClause(const SQLText,NewClause:string;
  ForceCLRF:boolean  = True
 ):string;
 function  GetWhereClause(const SQLText:string;N:integer;var
   StartPos,EndPos:integer
 ):string;
 function  WhereCount(SQLText:string):integer;
 function  MainWhereIndex(const SQLText:string):integer;
 function  MainFrom(const SQLText:string):string;
 function  MainWhereClause(const SQLText:string):string;
 function  GetOrderInfo(const SQLText:string):variant;
 function  OrderStringTxt(const SQLText:string;
  var StartPos,EndPos:integer
 ):String;

 function  SetOrderClause(const SQLText,NewClause:string):string;
 procedure SetOrderString(SQLText:TStrings;const OrderTxt:string);
//

 function  PrepareConstraint(Src:Tstrings):string;

{ procedure NormalizeSQLText(const SQL: string;MacroChar:Char;
  var NSQL:string
 );

 }
 function  CountSelect(const SrcSQL:string):string;
 function  FieldsClause(const SrcSQL:string):string;
 function  GetModifyTable(const SQLText:string;WithAlias:boolean=False):string;
 function  GetSQLKind(const SQLText:string):TSQLKind;
//

 function  GetLinkFieldName(const SQLText,ParamName: string): string;
 function  GetFieldByAlias(const SQLText,FieldName:string):string;
 function  IsWhereBeginPos(const SQLText:string;Position:integer):boolean;
 function  IsWhereEndPos(const SQLText:string;Position:integer):boolean;
 function  PosInSections(const SQLText:string;Position:integer):TSQLSections;

 function  InvertOrderClause(const OrderText:string):string;
 function  IsEquelSQLNames(const Name1,Name2:string):boolean;

 function CutTableName(const SQLString:string;AliasPosition:integer=0):string;
 function CutAlias(const SQLString:string;AliasPosition:integer=0):string;
 function PosAlias(const SQLString:string):integer;
 function FieldNameForSQL(const TableAlias,FieldName:string):string;

const
  CharsAfterClause =[' ',#13,#9,#10,#0,';','(','/','-','"'];
//  CharsAfterClause =[' ',#13,#9,#10,#0,';','(','/','-'];
  CharsBeforeClause=[' ',#10,')',#9,#13,'"'];
  endLexem=['+',')','(','*','/','|',',','=','>','<','-','!','^','~',',',';'];
  IBStdCharSetsCount=61;
  IBStdCollationsCount=136;
  UnknownStr='UNKNOWN';

 IBStdCharacterSets:array [0..IBStdCharSetsCount-1] of string =
  ('NONE','OCTETS','ASCII','UNICODE_FSS','UTF8','SJIS_0208',
   'EUCJ_0208',UnknownStr,UnknownStr,
   'DOS737','DOS437','DOS850','DOS865','DOS860',
   'DOS863', 'DOS775','DOS858','DOS862','DOS864','NEXT',UnknownStr,'ISO8859_1',
   'ISO8859_2','ISO8859_3',
    UnknownStr,UnknownStr,UnknownStr,UnknownStr,UnknownStr,UnknownStr,
    UnknownStr,UnknownStr,UnknownStr,UnknownStr,
   'ISO8859_4','ISO8859_5','ISO8859_6',
   'ISO8859_7','ISO8859_8','ISO8859_9','ISO8859_13',
   UnknownStr,UnknownStr,UnknownStr,
   'KSC_5601','DOS852','DOS857','DOS861','DOS866',
   'DOS869','CYRL','WIN1250','WIN1251','WIN1252','WIN1253',
   'WIN1254','BIG_5','GB_2312','WIN1255','WIN1256','WIN1257'
);


function ParseMacroString(const MacroString:string; aMacroChar:Char;var DefValue:string):string ;
function PosClause(const Clause,SQLText:string):integer;

const
  BeginWhere =' WHERE ';

implementation

function InternalIsClause( const EtalonClause:string; const Source:string;
 Position:integer
):boolean;
 // 1 �������� ����������� � uppercase. �� �������� ��������
var
  Len:Integer;
  LenEtalon:Byte;
  pSource:PChar;
  pEtalon:PChar;
  pEtalon1:PChar;
begin
 if (Position>1) and not (Source[Position-1] in CharsBeforeClause) then
 begin
   Result:=False;
   Exit
 end;
 Len:=Length(Source);
 LenEtalon:=Length(EtalonClause);
 if Len-Position+1<LenEtalon then
   Result:=False
 else
 begin
    pSource:=Pointer(Source);
    Inc(pSource,Position-1);
    pEtalon:=Pointer(EtalonClause);
    pEtalon1:=Pointer(EtalonClause);
    Inc(pEtalon1,LenEtalon);
    Result:=True;
    while (pEtalon<>pEtalon1) do
    begin
      if pSource^<>pEtalon^ then
      begin
        // ��� ��� �� ����� 'a'..'z' ��������� �� ���� ��������
          if Byte(pSource^)-32<>Byte(pEtalon^) then
          begin
            Result:=False;
            Break;
          end;
      end;
      Inc(pSource);
      Inc(pEtalon);
    end;
    if Result and (Len-Position>=LenEtalon) then
      Result:=(Source[Position+LenEtalon] in CharsAfterClause)
 end
end;


procedure SkipCommentsAndBlanks(const SQLText:string;Len:integer; var Position:integer);
begin
 while (Position<Len) and
  (SQLText[Position] in CharsAfterClause-['"']) do
 begin
    while (Position<=Len) and(SQLText[Position] in (CharsAfterClause -['/','-','"']) ) do
      Inc(Position);
    if (Position<Len) and (SQLText[Position]='-') and (SQLText[Position+1]='-') then
    begin
     while (Position<=Len) and not(SQLText[Position] in [#13,#10]) do
      Inc(Position);
    end;
    if (Position<Len) and(SQLText[Position]='/') and (SQLText[Position+1]='*') then
    begin
     Inc(Position,2);
     while (Position<Len) and not((SQLText[Position]='*') and (SQLText[Position+1]='/')) do
      Inc(Position);
     Inc(Position,2);
    end;
 end;
end;


function ParseMacroString(const MacroString:string; aMacroChar:Char;var DefValue:string):string ;
var
    PosDef:integer;
begin
// For FIBPlus Macro
   PosDef:=PosCh('%',MacroString);
   if PosDef=0 then
   begin
    if MacroString[1]=aMacroChar then
     Result:=MacroString
    else
     Result:=aMacroChar+MacroString;
   end
   else
   begin
     DoCopy(MacroString,Result,1,PosDef-1);
     DoCopy(MacroString,DefValue,PosDef+1,Length(MacroString)-PosDef);
     if MacroString[1] <> aMacroChar then Result := aMacroChar + Result
   end;
end;

function PosClause(const Clause,SQLText:string):integer;
begin
 Result:=PosExtCI(Clause,SQLText,CharsBeforeClause,CharsAfterClause,False);
end;

function IsEquelSQLNames(const Name1,Name2:string):boolean;
begin
  if (Length(Name1)>0) and (Length(Name2)>0) then
  begin
   case Name1[1] of
       '"':
       if Name2[1]<>'"' then
       begin
        Result:=FastCopy(Name1,2,Length(Name1)-2)=FastUpperCase(Name2)
       end
       else
        Result:=Name1=Name2
   else // else case
       if Name2[1]='"' then
        Result:= ('"'+Name1+'"'=Name2) or
        ('"'+FastUpperCase(Name1)+'"'=Name2)
       else
// ������� ��� �����
        Result:=FastUpperCase(Name1)=FastUpperCase(Name2)
   end
  end
  else
    Result := True; // Unknown
end;


function RemoveSP(const FromStr:string; OnlyArguments:boolean = False ):string;
var pBrIn,pBrOut:integer;
    cBrIn,cBrOut:integer;
    l:integer;
begin
 Result:=FromStr;
 pBrIn:=PosCh('(',FromStr);
 if pBrIn=0 then Exit;
 l:=Length(FromStr);
 while pBrIn >0 do
 begin
  pBrOut:=pBrIn+1;
  cBrIn :=1;     cBrOut:=0;
  while (cBrOut<cBrIn)  do
  begin
   if Result[pBrOut]=')' then Inc(cBrOut)
   else
   if Result[pBrOut]='(' then Inc(cBrIn);
   Inc(pBrOut);
   if pBrOut>l then Exit;
  end;
  if not OnlyArguments then
  begin
   while (pBrIn>1) and not (Result[pBrIn] in [',']) do
    Dec(pBrIn);
   while (pBrOut<=Length(Result)) and not (Result[pBrOut] in [',']) do
    Inc(pBrOut);
  end;
  System.Delete(Result,pBrIn,pBrOut-pBrIn);
  pBrIn:=PosCh('(',Result);
 end;
end;


(*
function  OpenBracketCount(const Txt:string;Len:integer):integer;
var j:integer;
    State:TParserState;
begin
 result:=0; State:=sNormal;
 for j := 1 to Len do
 begin
  case Txt[j] of
    '(':if (State=sNormal) then
          Inc(Result);
    ')': if (State=sNormal) then
          Dec(result);
    '"': case State of
          sNormal: State:=sQuote;
          sQuote : State:=sNormal;
         end;
    '''':case State of
          sNormal      : State:=sQuoteSingle;
          sQuoteSingle : State:=sNormal;
         end;
    '*': case State of
          sNormal:
           if (j>1) and (Txt[j-1]='/') then
             State:=sComment;
          sComment:
            if (j<len) and (Txt[j+1]='/') then
              State:=sNormal
         end;
    '-': case State of
          sNormal:
           if (j>1) and (Txt[j-1]='-') then
             State:=sFBComment;
         end;
    #13,#10:
     if State=sFBComment then
       State:=sNormal
  end;
 end;
end;
*)
function RemoveComments(const SQLText:string):string;
var
 Len:integer;
 Position,RLen:integer;
 State:TParserState;

procedure WriteResultChar;
begin
  Inc(RLen);
  Result[RLen]:=SQLText[Position];
end;

begin
 Len:=Length(SQLText);
 Position:=1; RLen:=0;
 SetLength(Result,Len);
 State:=sNormal;

 while (Position<=Len)do
 begin
    case State of
     sNormal:
     begin
      case SQLText[Position] of
       '"':
        begin
         State:=sQuote;
         WriteResultChar;
        end;
       '''':
        begin
         State:=sQuoteSingle;
         WriteResultChar;
        end;
       '-':
        begin
          if (Position<Len) and (SQLText[Position+1]='-') then
           State:=sFBComment
          else
           WriteResultChar;
        end;
       '/':
        begin
          if (Position<Len) and (SQLText[Position+1]='*') then
           State:=sComment
          else
           WriteResultChar;
        end;
      else
         WriteResultChar;
      end;
     end;
     sQuote:
      begin
       WriteResultChar;
       if (SQLText[Position]='"') then
         State:=sNormal;
      end;
     sQuoteSingle:
      begin
        WriteResultChar;
        if (SQLText[Position]='''') then
         State:=sNormal;
      end;
     sComment:
      if (SQLText[Position]='*') then
      begin
        if (Position<Len) and (SQLText[Position+1]='/') then
        begin
         State:=sNormal;
         Inc(Position);
        end;
      end;
     sFBComment:
      if (SQLText[Position]=#13) then
      begin
        State:=sNormal;
        if (Position<Len) and (SQLText[Position+1]=#10) then
         Inc(Position);
      end;
    end;
    Inc(Position);
 end;
 SetLength(Result,RLen);
end;

function RemoveJoins(const FromStr:string):string;
var pON,pComa,pJOIN:integer;
    tmpStr:string;
begin
 Result:=FromStr;
 pJOIN:=PosClause('JOIN',Result);
 if pJOIN=0 then
  Exit;
 Result:=FastCopy(Result,1,pJOIN-1)+', '+FastCopy(Result,PJOIN+5,MaxInt);
 Result:=ReplaceCIStr(Result, ' LEFT ' , ' ',False);
 Result:=ReplaceCIStr(Result, ' RIGHT ', ' ',False);
 Result:=ReplaceCIStr(Result, ' FULL ' , ' ',False);
 Result:=ReplaceCIStr(Result, ' INNER ', ' ',False);
 Result:=ReplaceCIStr(Result, ' OUTER ', ' ',False);
 Result:=ReplaceCIStr(Result, ' JOIN ', ' , ',False);
 pON:=PosClause('ON',Result);
 tmpStr:='';
 while pOn >0 do
 begin
  DoCopy(Result,tmpStr,pOn+2,MaxInt);
  pComa:=PosCh(',',tmpStr);
  SetLength(Result,pOn-1);
  if pComa>0 then
  begin
   Result:=Result+FastCopy(tmpStr,pComa,MaxInt)
  end;
  pON:=PosClause('ON',Result);
 end;
end;

function DispositionFrom(const SQLText:string):TPoint;
var
   Parser:TSQLParser;
begin
  Parser:=TSQLParser.Create(SQLText);
  try
    Result := Parser.DispositionMainFrom;
  finally
   Parser.Free
  end
end;

function  CountSelect(const SrcSQL:string):string;
var
    Parser:TSQLParser;
begin
  Parser:=TSQLParser.Create(SrcSQL);
  try
   Result:=Parser.RecCountSQLText;
  finally
   Parser.Free
  end;
end;

function  FieldsClause(const SrcSQL:string):string;
var
    Parser:TSQLParser;
begin
  Parser:=TSQLParser.Create(SrcSQL);
  try
   Result:=Parser.GetFieldsClause;
  finally
   Parser.Free
  end;
end;

function  GetModifyTable(const SQLText:string;WithAlias:boolean=False):string;
var
  StartCut,EndCut,L:integer;
  Parser:TSQLParser;
begin
  Parser:=TSQLParser.Create(SQLText);
  try
    Result:=FastTrim(Parser.ModifiedTables);
    L:=Length(Result);
    if not WithAlias and (L>0) then
    begin
      StartCut:=1;
      if Result[StartCut]='"' then
      begin
        Inc(StartCut);
        EndCut:=StartCut+1;
        while EndCut<=L do
        begin
          if Result[EndCut]='"' then
          begin
            Dec(EndCut); Break
          end
          else
           Inc(EndCut);
        end;
        Result:=FastCopy( Result,StartCut,EndCut-StartCut+1);
      end
      else
      begin
        EndCut:=StartCut;
        while EndCut<L do
        begin
          if Result[EndCut+1] in CharsAfterClause-['"'] then
          begin
            Break
          end
          else
           Inc(EndCut);
        end;
       if L>EndCut then
        SetLength(Result,EndCut);
       Result:=FastUpperCase(Result);
      end;
    end;
  finally
   Parser.Free
  end;
end;

function PosAlias(const SQLString:string):integer;
var
   i:integer;
   InQuote1,InQuote2:boolean;
begin
  Result:=0;
  InQuote1:=False;
  InQuote2:=False;
  for i:=1 to Length(SQLString) do
  begin
      case SQLString[i] of
       ' ',#10,#13,#9:
        if not InQuote1 and not InQuote2 then
        begin
          Result:=i;
          Break;
        end;
       '"':
         if not InQuote2 then
           InQuote1:=not InQuote1;
       '''':
          if not InQuote1 then
           InQuote2:=not InQuote2;
      end;
  end;
  if Result>0 then
   while (Result<Length(SQLString)) and (SQLString[Result] in CharsAfterClause-['"']) do
    Inc(Result);
    
end;

function FieldNameForSQL(const TableAlias,FieldName:string):string;
begin
  if Length(TableAlias) > 0 then
   Result:=FormatIdentifier(3,TableAlias)+'.'+
    FormatIdentifier(3,FieldName)
  else
   Result:=FormatIdentifier(3,FieldName);
end;


function CutTableName(const SQLString:string; AliasPosition:integer=0):string;
var
  p:integer;
begin
  if AliasPosition=0 then
   p:=PosAlias(SQLString)
  else
   p:=AliasPosition;
  if p=0 then
   Result:=FastTrim(SQLString)
  else
   Result:=FastTrim(FastCopy(SQLString,1,p-1));
end;

function CutAlias(const SQLString:string; AliasPosition:integer=0):string;
var
  p:integer;
begin
  if AliasPosition=0 then
   p:=PosAlias(SQLString)
  else
   p:=AliasPosition;
  if p+3<=Length(SQLString) then
   if (SQLString[p] in ['A','a']) and (SQLString[p+1] in ['S','s']) and
   (SQLString[p] in CharsAfterClause-['"'])
  then
    Inc(p,3);
  if p=0 then
   Result:=FastTrim(SQLString)
  else
   Result:=FastTrim(FastCopy(SQLString,p,MaxInt));
end;

procedure RemoveAliases(ListOfTables:TStrings);
var
 i:integer;
begin
  for i := 0 to ListOfTables.Count - 1 do
  begin
    ListOfTables[i]:=CutTableName(ListOfTables[i]);
  end
end;

procedure AllTables(const SQLText:string;aTables:TStrings; WithSP:boolean =False
;WithAliases:boolean =False
 );
var
    Parser:TSQLParser;
begin
  Parser:=TSQLParser.Create(SQLText);
  with Parser do
  try
   FillMainTables(WithSP);
   aTables.Assign(FTables);
   if not WithAliases then
     RemoveAliases(aTables);
  finally
   Parser.Free
  end;
end;

procedure AllSQLTables(SQLText:string;aTables:TStrings; WithSP:boolean=False
;WithAliases:boolean =False
);
var
    Parser:TSQLParser;
begin
  Parser:=TSQLParser.Create(SQLText);
  with Parser do
  try
   GetAllTables(WithSP);
   aTables.Assign(FTables);
   if not WithAliases then
     RemoveAliases(aTables);

  finally
   Parser.Free
  end;
end;

function  AliasForTable(const SQLText,TableName:string):string;
var ts:TStrings;
    i,p:integer;
    tmpStr:string;
begin
 Result:=TableName;
 ts:=TStringList.Create;
 try
  AllTables(SQLText,ts,True,True);
  for i:=0 to Pred(ts.Count) do
  begin
   p:=PosAlias(ts[i]);
   if p>0 then
    tmpStr:=CutTableName(ts[i],p)
   else
    tmpStr:=FastTrim(ts[i]);

   if IsEquelSQLNames(tmpStr,TableName) then
   begin
     Result:=CutAlias(ts[i],p);
     Exit;
   end;
  end;
 finally
  ts.Free
 end;
end;

function  TableByAlias(const SQLText,Alias:string):string;
var ts:TStrings;
    i,p:integer;
    tmpStr:string;
    tmpStr1:string;
begin
 Result:='';
 ts:=TStringList.Create;
 tmpStr1:='';
 try
  AllTables(SQLText,ts, True,True);
  for i:=0 to Pred(ts.Count) do
  begin
   p:=PosAlias(ts[i]);
   if p>0 then
    tmpStr:=CutAlias(ts[i],p)
   else
    tmpStr:=FastTrim(ts[i]);

   if IsEquelSQLNames(tmpStr,Alias) then
   begin
     Result:=CutTableName(ts[i],p);
     Break;
   end
   else
   if Length(tmpStr1) = 0 then
   begin
    tmpStr1:=CutTableName(ts[i],p);
    if not IsEquelSQLNames(Alias,tmpStr1) then
     tmpStr1:='';
   end;
  end;
  if (Length(Result) = 0) and (Length(tmpStr1) > 0) then
   Result:=tmpStr1
 finally
  ts.Free
 end;
end;

function FullFieldName(const SQLText,aFieldName:string):string;
var
   p:integer;
   TableName:string;
   FieldName:string;
begin
 p:=PosCh('.',aFieldName);
 if p=0 then
  Result:=aFieldName
 else
 begin
  TableName:= TableByAlias(SQLText,FastCopy(aFieldName,1,p-1));
  if (Length(TableName)=0) then
   Result:=aFieldName
  else
  if (Length(TableName)=0) then
   Result:=aFieldName
  else
  begin
    FieldName:=FastTrim(FastCopy(aFieldName,p+1,MaxInt));
    if (Length(FieldName) > 0) then
     if FieldName[1]='"' then
      FieldName:=FastCopy(FieldName,2,Length(FieldName)-2)
     else
      DoUpperCase(FieldName);

    if (TableName[1]<>'"') then
     Result:=FastUpperCase(TableName)+'.'+FieldName
    else
     Result:=FastCopy(TableName,2,Length(TableName)-2)+'.'+FieldName
  end;
 end;
end;


function FieldNameFromSelect(const SQLText, FieldName: String):String;
var
  p,pb,pe : integer;
begin
  if Length(FieldName) = 0 then
   Result := FieldName
  else
  if PosCh('.', FieldName) > 0  then
   Result := FieldName
  else
  begin
      if FieldName[1]='"' then
       p:=PosInSubstrExt(FieldName, SQLText,
                     1,Length(SQLText),
             endLexem+CharsAfterClause+['.'],endLexem+CharsAfterClause
         )
      else
       p:=PosInSubstrCIExt(FieldName, SQLText,
                     1,Length(SQLText),
             endLexem+CharsAfterClause+['.'],endLexem+CharsAfterClause
         );

      if p > 0 then
      begin
       pb:=p-1;
       while (pb > 0) and ((SQLText[pb] in [' ',#10,#9,#13])) do
         Dec(pb);
       if (pb>0) and (SQLText[pb]='.') then
       begin
         pe:=pb-1;
         while (pe > 0) and (SQLText[pe] in [' ',#10,#9,#13]) do
          Dec(pe);
         if pe>0 then
         begin
           pb:=pe;
           while (pb > 0) and not (SQLText[pb] in ['(',' ',#10,#9,#13]) do
            Dec(pb);
          Inc(pb);
          Result :=FastCopy(SQLText, pb, pe-pb+1)+
           '.'+FastCopy(SQLText, p, Length(FieldName));
         end
         else
          Result := FastCopy(SQLText, p, Length(FieldName));
       end
       else
        Result := FastCopy(SQLText, p, Length(FieldName));
      end
      else
       Result := FieldName;
    end;
end;


function  MainWhereIndex(const SQLText:string):integer;
var
    Parser:TSQLParser;
begin
  Parser:=TSQLParser.Create(SQLText);
  try
   Result:=Parser.MainWhereIndex;
  finally
   Parser.Free
  end;
end;

function  MainFrom(const SQLText:string):string;
var
    Parser:TSQLParser;
begin
  Parser:=TSQLParser.Create(SQLText);
  try
   Result:=Parser.MainFrom;
  finally
   Parser.Free
  end;
end;

function  MainWhereClause(const SQLText:string):string;
var
    Parser:TSQLParser;
    i,j:integer;
begin
  Parser:=TSQLParser.Create(SQLText);
  try
   Result:=Parser.MainWhereClause(i,j);
  finally
   Parser.Free
  end;
end;

function WhereCount(SQLText:string):integer;
var
    Parser:TSQLParser;
begin
  Parser:=TSQLParser.Create(SQLText);
  try
   Result:=Parser.WhereCount;
  finally
   Parser.Free
  end;
end;

function  OrderStringTxt(const SQLText:string;
 var StartPos,EndPos:integer):String;
var
    Parser:TSQLParser;
begin
  Parser:=TSQLParser.Create(SQLText);
  try
    Result:=Parser.OrderText(StartPos,EndPos);
  finally
   Parser.Free
  end
end;


function  GetSQLKind(const SQLText:string):TSQLKind;
var
    Parser:TSQLParser;
begin
  Parser:=TSQLParser.Create(SQLText);
  try
    Result:=Parser.SQLKind;
  finally
   Parser.Free
  end
end;

function    TSQLParser.GetOrderInfo:Variant;
var
  StartPos, EndPos: integer;
  vOrderText:string;
  i,wc,p,L:integer;
  bufStr:string;
  TName,FName:string;
  wc1:integer;
begin
 vOrderText:=FastTrim(RemoveComments(OrderText(StartPos, EndPos)));
 wc:=WordCount(vOrderText,[',']);
 if wc<1 then
  Result:=null
 else
 begin
  Result:=VarArrayCreate([0,wc-1,0,2],varVariant);
  for i:=1 to wc do
  begin
    bufStr:=FastTrim(ExtractWord(i,vOrderText,[',']));
    if WordCount(bufStr,['.'])>1 then
    begin
     TName:=ExtractWord(1,bufStr,['.']);
     if Length(TName) > 0 then
      if TName[1]<>'"' then
       TName:=FastUpperCase(TName);
     FName:=FastTrim(ExtractWord(2,bufStr,['.']));
     if Length(FName) > 0 then
      if FName[1]<>'"' then
       FName:=FastUpperCase(FName);
     bufStr:=TName+ '.'+FName;
    end;


    wc1:=WordCount(bufStr,CharsAfterClause);
    if wc1>0 then
    begin

      p:=PosClause('NULLS',bufStr);
      if p>0 then
      begin
       wc1:=p;
       Inc(p,5);
       L:=Length(bufStr);
       while (p<=L) and (bufStr[p] in CharsAfterClause) do
        Inc(p);
       if p<L then
         Result[i-1,2]:= bufStr[p] in ['F','f']; // NULLS FIRST
       SetLength(bufStr,wc1-1);
      end
      else
       Result[i-1,2]:=False; // NULLS LAST


      p:=PosClause('DESC',bufStr);
      if p=0 then
       p:=PosClause('DESCENDING',bufStr);
      Result[i-1,1]:=p=0;
      if p>0 then
       SetLength(bufStr,p-1)
      else
      begin
       p:=PosClause('ASC',bufStr);
       if p=0 then
        p:=PosClause('ASCENDING',bufStr);
       if p>0 then
        SetLength(bufStr,p-1);
      end;
      p:=PosClause('COLLATE',bufStr);
      if p>0 then
       SetLength(bufStr,p-1);
      Result[i-1,0]:=FastTrim(bufStr);
    end;  
  end;
 end;
end;

function  GetOrderInfo(const SQLText:string):variant;
var 
    Parser:TSQLParser;
begin
 Parser:=TSQLParser.Create(SQLText);
 try
  Result:=Parser.GetOrderInfo;
 finally
  Parser.Free;
 end;
end;


procedure SetOrderString(SQLText:TStrings;const OrderTxt:string);
begin
 SQLText.Text:=SetOrderClause(SQLText.Text,OrderTxt);
end;


function  SetOrderClause(const SQLText,NewClause:string):string;
var
    StartPos,EndPos:integer;
    Old :string;
begin
   Old:=SqlTxtRtns.OrderStringTxt(SQLText, StartPos,EndPos);
   if StartPos>0 then
    if Length(NewClause) > 0 then
     Result:=ReplaceStrInSubstr(SQLText, Old,' '+ NewClause+' ',
               StartPos,EndPos)
    else
     Result:=FastCopy(SQLText,1,StartPos-1)+' '+FastCopy(SQLText,EndPos+1,MaxInt)
   else
   if Length(NewClause) > 0 then
    Result:=SQLText+' ORDER BY '+NewClause
   else
    Result:=SQLText
end;

function  GetWhereClause(const SQLText:string;N:integer;var
 StartPos,EndPos:integer
):string;
var
  Parser:TSQLParser;
begin
  Parser:=TSQLParser.Create(SQLText);
  try
    Result:=Parser.WhereClause(N,StartPos,EndPos);
  finally
   Parser.Free
  end
end;

function AddToWhereClause(const SQLText,NewClause:string;ForceCLRF:boolean  = True):string;
var
  Parser:TSQLParser;
begin
  Parser:=TSQLParser.Create(SQLText);
  try
    Result:=Parser.AddToMainWhere(NewClause,ForceCLRF);
  finally
   Parser.Free
  end;
end;

function PrepareConstraint(Src:Tstrings):string;
var i,pos_no: integer;
begin
// ���������� ������� ����������� � ������� ����
// ��� ���������� ����������� ���������
// �������� �� ������������
    Result := FastTrim(Src.Text);
    pos_no := PosCh('(',Result)+1;
    Result:=FastCopy(Result,Pos_no,Length(Result));
    pos_no :=-1;
    for i := Length(Result) downto 1 do
     if Result[i]=')' then begin pos_no := i; Break; end;
    SetLength(Result,Pos_no-1);
    Result:=
     ReplaceStr(FastCopy(Result,Pos_no,Length(Result)-Pos_no), '"',QuotMarks)
end;


{ TSQLParser }


constructor TSQLParser.Create;
begin
 FTables     :=TStringList.Create;
 FFirstPos :=1;
 inherited Create;
end;

constructor TSQLParser.Create(const aSQLText: string);
begin
 Create;
 SQLText:=aSQLText; 
end;

destructor TSQLParser.Destroy;
begin
  FTables.Free;
  inherited;
end;

procedure TSQLParser.IsFromEnd(Position: integer; var Yes: boolean);
var p:integer;
begin
   if FBracketOpenedBeforeScan<FBracketOpened then
   begin
     Yes := False; Exit;
   end;
   p   := Position;
   Yes := p=Len;
   if Yes then  Exit;
   if P>Len then Exit;
   if (SQLText[P] in [' ',#9,#13,#10]) then
   if (Len-P)>1 then
    case SQLText[P+1] of
    'F','f': // FOR UPDATE
       Yes :=InternalIsClause('FOR',SQLText,P+1);
    'G','g': //GROUP BY
       Yes :=InternalIsClause('GROUP',SQLText,P+1);
    'H','h': //HAVING
       Yes :=InternalIsClause('HAVING',SQLText,P+1);
    'O','o'://ORDER BY
       Yes :=InternalIsClause('ORDER',SQLText,P+1);
    'P','p': // PLAN
       Yes :=InternalIsClause('PLAN',SQLText,P+1);
    'U','u': //UNION
       Yes :=InternalIsClause('UNION',SQLText,P+1);
    'W','w': //WHERE
       Yes :=InternalIsClause('WHERE',SQLText,P+1);
    end;
end;

procedure TSQLParser.IsFromBegin(Position:integer;var Yes:boolean);
begin
 Yes:= InternalIsClause('FROM',SQLText,Position);
end;



procedure TSQLParser.IsMainFromBegin(Position:integer;var Yes:boolean);
begin
 Yes:=  (FBracketOpened=0);
 if Yes then
  IsFromBegin(Position,Yes);
end;

procedure  TSQLParser.IsSetBegin(Position:integer;var Yes:boolean);
begin
  Yes :=InternalIsClause('SET',SQLText,Position);
end;

procedure  TSQLParser.IsUpdateBegin(Position:integer;var Yes:boolean);
begin
  Yes:=IsUpdate(Position);
end;

procedure  TSQLParser.IsIntoBegin(Position:integer;var Yes:boolean);
begin
  Yes :=InternalIsClause('INTO',SQLText,Position);
end;

procedure  TSQLParser.IsPlanBegin(Position:integer;var Yes:boolean);
begin
  Yes :=InternalIsClause('PLAN',SQLText,Position);
  if Yes  and (FReserved>0) then
  begin
   Inc(FReserved1);
   Yes:=FReserved1=FReserved
  end;
end;

procedure TSQLParser.IsPlanEnd(Position:integer;var Yes:boolean);
var p:integer;
begin
   if FBracketOpenedBeforeScan<FBracketOpened then
   begin
     Yes := False; Exit;
   end;
   p   := Position;
   Yes := p=Len;
   if Yes then  Exit;
   if P>Len then Exit;
   if (SQLText[P] in [' ',#9,#13,#10]) then
   begin
    if (Len-P)>1 then
    case SQLText[P+1] of
    'O','o'://ORDER BY
       Yes :=InternalIsClause('ORDER',SQLText,P+1);
    end;
   end
end;

procedure TSQLParser.IsWhereBegin(Position: integer; var Yes: boolean);
begin
  Yes:=IsWhereBeginPos(SQLText,Position);
  if Yes  and (FReserved>0) then
  begin
   Inc(FReserved1);
   Yes:=FReserved1=FReserved
  end;
end;

procedure  TSQLParser.IsWhereEnd(Position:integer;var Yes:boolean);
begin
   if FBracketOpenedBeforeScan<FBracketOpened then
   begin
     Yes := False; Exit;
   end;
   Yes :=IsWhereEndPos(SQLText,Position)
end;

procedure  TSQLParser.IsMainWhereBegin(Position:integer;var Yes:boolean);
begin
  Yes:= FBracketOpened=0;
  if Yes then
   IsWhereBegin(Position,Yes)
end;

procedure TSQLParser.ScanText(FromPosition: integer; Proc: TOnScanSQLText);
var      j  :integer;
    StopScan:boolean;
begin
 if not Assigned(Proc) then Exit;
 FState:=sNormal;
 FResultPos:=0; FBracketOpenedBeforeScan:=FBracketOpened;
 for j := FromPosition to Len do
 begin
  FCurPos:=j;
  case SQLText[j] of
    '(': if not (FState in [sComment,sFBComment,sQuote,sQuoteSingle]) then
         begin
           Inc(FBracketOpened);
         end;
    ')': if not (FState in [sComment,sFBComment,sQuote,sQuoteSingle]) then
         begin
           if (FScanInBrackets  and (FBracketOpened-1<FBracketOpenedBeforeScan))
           then
           begin
              FResultPos:=j;
              Break
           end
           else
            Dec(FBracketOpened);
         end;
    '"':  if not (FState in [sComment,sFBComment,sQuoteSingle]) then
          if  FState=sQuote then
           FState:=sNormal
          else
           FState:=sQuote;
    '''': if not (FState in [sComment,sFBComment,sQuote]) then
          if  FState=sQuoteSingle then
           FState:=sNormal
          else
           FState:=sQuoteSingle;
    '*': if not (FState in [sQuote,sQuoteSingle]) then
         begin
          if FState=sComment then
          begin
            if (j<Len) and (FSQLText[j+1]='/') then
              FState:=sNormal
          end
          else
            if (j>1) and (FSQLText[j-1]='/') then
              FState:=sComment
         end;
     '-': if FState=sNormal then
          begin
           if (j<Len) and (FSQLText[j+1]='-') then
              FState:=sFBComment
          end;
  else
   case FState of
    sNormal:
     begin
      StopScan:=False;
      Proc(j,StopScan);
      if StopScan then
      begin
        FResultPos:=j;
        Break
      end;
     end;
    sFBComment:
     if FSQLText[j]=#13 then
      FState:=sNormal
   end
  end;
 end;

 if (FResultPos=0) and (FState=sNormal) then
 begin
  StopScan:=False;
  Proc(Len,StopScan);
  if StopScan then
  begin
    FResultPos:=Len;
  end;
 end;
 FReserved:=0;
end;

procedure TSQLParser.SetSQLText(const Value: string);
begin
  FSQLText := Value;
  FTables.Clear;
  FLen:=Length(FSQLText);
  FFirstPos:=1;
  SkipCommentsAndBlanks(FSQLText,FLen,FFirstPos);
  FSQLKind :=GetSQLKind;
end;

{
procedure  TSQLParser.GetMainFields(OutList:TStrings);
var
   Position:integer;
   EndPos :integer;
   tmpStr :string;
   vState  :TParserState;
begin
  OutList.Clear;
  case SQLKind of
   skInsert:;
   skUpdate:
    begin
     FResultPos:=0;
     ScanText(FFirstPos,IsSetBegin);
    end;
  else
    Exit;
  end;
   if FResultPos>0 then
   begin
     Position:=FResultPos+3;
     SkipCommentsAndBlanks(SQLText,Len,Position);
     ScanText(FFirstPos,IsMainFromBegin);
     if FResultPos>0 then
      EndPos :=FResultPos
     else
      EndPos :=Len;
     vState:=FState;
     tmpStr:='';
     while (Position<=EndPos) do
     begin
      case SQLText[Position] of
       '''':
        case vState of
         sQuoteSingle:
         begin
          tmpStr:=tmpStr+SQLText[Position];
          vState:=sNormal;
         end;
         sNormal:
         begin
          tmpStr:=tmpStr+SQLText[Position];
          vState:=sQuoteSingle;
         end;
         sQuote:
          tmpStr:=tmpStr+SQLText[Position]
        end;
      '"':
        case vState of
         sQuote:
         begin
          tmpStr:=tmpStr+SQLText[Position];
          vState:=sNormal;
         end;
         sNormal:
         begin
          tmpStr:=tmpStr+SQLText[Position];
          vState:=sQuote;
         end;
         sQuoteSingle:
          tmpStr:=tmpStr+SQLText[Position]
        end;
       '-':
        case vState of
         sNormal:
          if (Position<Len) and (SQLText[Position]='-') then
          begin
            OutList.Add(tmpStr);
            tmpStr:='';
            vState:=sFBComment
          end
          else
           tmpStr:=tmpStr+SQLText[Position];
         sQuoteSingle,sQuote:
          tmpStr:=tmpStr+SQLText[Position];
        end;
        #13:
        case vState of
           sNormal:
           begin
            OutList.Add(tmpStr);
            tmpStr:='';
           end;
           sFBComment:
            vState:=sNormal;
        end;
        ',','=':
        case vState of
           sNormal:
           begin
            OutList.Add(tmpStr);
            tmpStr:='';
           end;
           sQuoteSingle,sQuote:
            tmpStr:=tmpStr+SQLText[Position];
        end;

      end;
      Inc(Position);
     end;
   end;
end;   }

procedure TSQLParser.IsOrderBegin(Position: integer; var Yes: boolean);
begin
 Yes :=InternalIsClause('ORDER',SQLText,Position);
end;


procedure TSQLParser.IsMainOrderBegin(Position: integer; var Yes: boolean);
begin
 Yes:=FBracketOpened=0;
 if Yes then
  IsOrderBegin(Position, Yes)
end;


procedure TSQLParser.IsGroupBegin(Position: integer; var Yes: boolean);
begin
 Yes :=InternalIsClause('GROUP',SQLText,Position);
end;

procedure TSQLParser.IsMainGroupBegin(Position:integer;var Yes:boolean);
begin
 Yes:=FBracketOpened=0;
 if Yes then
  IsGroupBegin(Position, Yes)
end;

function TSQLParser.IsClause(Position: integer;
  const Clause: string): boolean;
var
   LenClause :integer;
begin
 LenClause :=Length(Clause);
 Result:=  (Position>1) and (Len-Position>=LenClause) and
        (SQLText[Position+LenClause] in CharsAfterClause) and
        (SQLText[Position-1] in CharsBeforeClause);
 if Result then
  Result:=Clause=FastUpperCase(FastCopy(SQLText,Position,LenClause))
end;

procedure TSQLParser.IsByBegin(Position: integer; var Yes: boolean);
begin
 Yes:=  IsClause(Position,'BY')
end;

procedure  TSQLParser.IsHaving(Position:integer;var Yes:boolean);
begin
 Yes:=  IsClause(Position,'HAVING')
end;

function TSQLParser.DispositionMainFrom: TPoint;
begin
   // �� � ��
    Result.X:=0;
    Result.Y:=0;
    ScanText(FFirstPos,IsMainFromBegin);
    if FResultPos=0 then
     Exit;
    Result.X:=FResultPos;
    ScanText(Result.X+5,IsFromEnd);
    if FResultPos=0 then
     Result.Y:=Len
    else
     Result.Y:=FResultPos;
end;

function TSQLParser.MainFrom:string;
var
 p:TPoint;
begin
  p:=DispositionMainFrom;
  if p.X>0 then
   if p.Y=Length(SQLText) then
    Result:=FastCopy(SQLText,p.X+5,MaxInt)
   else
    Result:=FastCopy(SQLText,p.X+5,p.Y-p.X-5)
  else
   Result:=''
end;

function    TSQLParser.PosInSections(Position:integer):TSQLSections;
var
  temp:integer;
begin
  Result:=PosInSections(1,Position,temp)
end;

function  TSQLParser.PosInSections(ScanFrom,Position:integer; var EndScan:integer):TSQLSections;
var
  i: Integer;


  MayBe1:TSQLSections;
  vBracketOpenedBeforeScan:integer;
  b:boolean;

procedure AddArray(NewArray:TSQLSections);
var
   j,k:integer;
begin
  SetLength( Result ,Length(Result)+Length(NewArray));
  k:=1;
  for j:=Length(NewArray)-1 downto 0 do
  begin
   Result[Length(Result)-k]:=NewArray[j];
   Inc(k);
  end;
end;

begin
{  TSQLSection = (stUnknown,stSelect, stSelectingFields,
    stUpdate,stInsert,stDelete,stExecute, stSet,
    stFrom, stWhere, stGroupBy, stHaving,
    stUnion,    stPlan, stOrderBy, stForUpdate
  );
}
  FState:=sNormal;
  SetLength(MayBe1,0);
  SetLength( Result ,0);

  if ScanFrom=1 then
  begin
   FBracketOpened:=0;
   vBracketOpenedBeforeScan:=0
  end
  else
   vBracketOpenedBeforeScan:=FBracketOpened;

  i:=ScanFrom;
  while i<=Position do
  begin
    case SQLText[i] of
      '(': if not (FState in [sComment,sFBComment,sQuote,sQuoteSingle]) then
           begin
             Inc(FBracketOpened);
             MayBe1:=PosInSections(i+1,Position,EndScan);
             if EndScan>=Position then
             begin
              AddArray(MayBe1);
              Exit
             end
             else
             begin
               i:=EndScan;
               Continue;
             end;
           end;
      ')': if not (FState in [sComment,sFBComment,sQuote,sQuoteSingle]) then
           begin
              Dec(FBracketOpened);
              if FBracketOpened=vBracketOpenedBeforeScan then
              begin
               EndScan:=i+1;
               Exit;
              end;
           end;
      '"':  if not (FState in [sComment,sFBComment,sQuoteSingle]) then
            if  FState=sQuote then
             FState:=sNormal
            else
             FState:=sQuote;
      '''': if not (FState in [sComment,sFBComment,sQuote]) then
            if  FState=sQuoteSingle then
             FState:=sNormal
            else
             FState:=sQuoteSingle;
      '*': if not (FState in [sQuote,sQuoteSingle]) then
           begin
            if FState=sComment then
            begin
              if (i<Len) and (FSQLText[i+1]='/') then
                FState:=sNormal
            end
            else
              if (i>1) and (FSQLText[i-1]='/') then
                FState:=sComment
           end;
       '-': if FState=sNormal then
            begin
             if (i<Len) and (FSQLText[i+1]='-') then
                FState:=sFBComment
            end;
    else

     if IsSelect(i) then
     begin
       SetLength( Result ,Length(Result)+2);
       Result[Length(Result)-2]:=stSelect;
       Result[Length(Result)-1]:=stFields;
       Inc(i,5);
     end
     else
     if IsUpdate(i) then
     begin
       SetLength(Result,Length(Result)+2);
       Result[Length(Result)-2]:=stUpdate;
       Result[Length(Result)-1]:=stSet;
       Inc(i,5);
     end
     else
     if IsDelete(i) then
     begin
       SetLength(Result,Length(Result)+2);
       Result[Length(Result)-2]:=stDelete;
       Result[Length(Result)-1]:=stFrom;
       Inc(i,5);
     end
     else
     if IsInsert(i)  then
     begin
      SetLength(Result,Length(Result)+2);
      Result[Length(Result)-2]:=stInsert;
      Result[Length(Result)-1]:=stFrom;
      Inc(i,5);
     end
     else
     if IsExecute(i) then
     begin
      SetLength(Result,Length(Result)+2);
      Result[Length(Result)-2]:=stExecute;
      Result[Length(Result)-1]:=stFrom;
      Inc(i,6);
     end
     else
     begin
      b:=False;
      IsFromBegin(i,b);
      if b then
      begin
        if Length(Result)=0 then
         SetLength(Result,1);
        Result[Length(Result)-1]:=stFrom;
        Inc(i,3);
      end
      else
      begin
       IsWhereBegin(i,b);
       if b then
       begin
          if Length(Result)=0 then
           SetLength(Result,1);
          Result[Length(Result)-1]:=stWhere;
         Inc(i,4);
       end
       else
       begin
         IsOrderBegin(i,b);
         if b then
         begin
            if Length(Result)=0 then
             SetLength(Result,1);
            Result[Length(Result)-1]:=stOrderBy;
            Inc(i,4);
         end
         else
         begin
           IsPlanBegin(i,b);
           if b then
           begin
             if Length(Result)=0 then
               SetLength(Result,1);
             Result[Length(Result)-1]:=stPlan;
             Inc(i,3);
           end
           else
           if IsClause(i,'GROUP') then
           begin
             if Length(Result)=0 then
               SetLength(Result,1);
             Result[Length(Result)-1]:=stGroupBy;
             Inc(i,5);
           end;
         end
       end;
      end;
     end;


    end;
    Inc(i);
    EndScan:=i
  end;
end;


function  TSQLParser.ModifiedTables:string;
var
   Start:Integer;
   L:integer;
   tmpStr:string;

procedure CutTable;
var
  p:integer;
  InQuote:boolean;
begin
 L:=0;
 InQuote:=False;
 SkipCommentsAndBlanks(SQLText,Len,Start);
 for p:=Start to Len do
 begin
   case SQLText[p] of
   '-','/':
    if InQuote then
      Inc(L)
    else
      Break;
   '"':
    begin
      InQuote:=not InQuote;
      Inc(L);
      if not InQuote then
       Break
    end;
   '(':
     if InQuote then
      Inc(L)
     else
      Break;
   else
     if InQuote or not (SQLText[p] in CharsAfterClause) then
        Inc(L)
     else
       Break;
   end; //end case
 end;
  Result:=FastCopy(SQLText,Start,L);
end;

begin
   case SQLKind of
    skUpdate:
    begin
      Start:=FFirstPos+6;
      CutTable;
      tmpStr:= Result;
      Start:=Start+L;
      CutTable;
      if FastUpperCase(Result)<>'SET' then
        Result:= tmpStr+' '+Result
      else
        Result:=tmpStr;
    end;
    skInsert:
    begin
     ScanText(FFirstPos+7,IsIntoBegin);
     if FResultPos>0 then
     begin
       Start:=FResultPos+5;
       CutTable;
     end
     else
      Result:='Unknown'
    end;   // skInsert
    skDelete:
    begin
     ScanText(FFirstPos,IsFromBegin);
     if FResultPos>0 then
     begin
      Start:=FResultPos+4;
      CutTable;
      tmpStr:= Result;
      Start := Start+L;
      CutTable;
      if FastUpperCase(Result)<>'WHERE' then
        Result:= tmpStr+' '+Result
      else
        Result:=tmpStr;
     end
     else
      Result:='Unknown';

//      Result:=MainFrom
   end
  end;
end;

function TSQLParser.OrderText(var StartPos, EndPos: integer): string;
begin
  Result:='';StartPos:=0;EndPos:=0;
  ScanText(FFirstPos,IsMainOrderBegin);
  if FResultPos=0 then Exit;
  StartPos:=FResultPos;
  ScanText(FResultPos+5,IsByBegin);
  if FResultPos=0 then
   Exit;
  Result:=FastCopy(SQLText,FResultPos+2,MaxInt);
  EndPos:=Length(SQLText);
end;


function  TSQLParser.OrderClause:string;
var
  StartPos, EndPos: integer;
begin
  Result:=OrderText(StartPos, EndPos)
end;

function TSQLParser.SetOrderClause(const Value:string):string;
var
  StartPos, EndPos: integer;
begin
 OrderText(StartPos, EndPos);
 if StartPos=0 then
 begin
   if FastTrim(Value)='' then
    Result := SQLText
   else
    Result := FastTrim(SQLText)+CLRF+ 'ORDER BY '+Value;
 end
 else
 begin
   if FastTrim(Value)='' then
    Result := FastCopy(SQLText,1,StartPos-1)
   else
    if SQLText[StartPos-1]<>#10 then
     Result := FastCopy(SQLText,1,StartPos-1)+CLRF+ 'ORDER BY '+Value
    else
     Result := FastCopy(SQLText,1,StartPos-1)+ 'ORDER BY '+Value
 end;
end;

function    TSQLParser.GroupByText(var StartPos,EndPos:integer):string;
var
  byPos:integer;
begin
  Result:='';StartPos:=0;EndPos:=0;
  ScanText(FFirstPos,IsMainGroupBegin);
  if FResultPos=0 then
   Exit;
  StartPos:=FResultPos;
  ScanText(FResultPos+5,IsByBegin);
  if FResultPos=0 then
   Exit;
  byPos:=FResultPos;
  ScanText(StartPos,IsHaving);
  if FResultPos=0 then
   ScanText(StartPos,IsPlanBegin);
  if FResultPos=0 then
   ScanText(StartPos,IsOrderBegin);


  if FResultPos=0 then
  begin
   Result:=FastCopy(SQLText,byPos+2,MaxInt);
   EndPos:=Length(SQLText);
  end
  else
  begin
   Result:=FastCopy(SQLText,byPos+2,FResultPos-byPos-2);
   EndPos:=FResultPos-1;
  end;
end;

function    TSQLParser.GroupByClause:string;
var
  StartPos, EndPos: integer;
begin
 Result:=GroupByText(StartPos, EndPos);
end;

function    TSQLParser.SetGroupClause(const Value:string):string;
var
  StartPos, EndPos: integer;
  StartPosO, EndPosO: integer;
begin
 GroupByText(StartPos, EndPos);
 if StartPos=0 then
 begin
   if FastTrim(Value)='' then
    Result := SQLText
   else
   begin
     ScanText(FFirstPos,IsHaving);
     if FResultPos<>0 then
      StartPosO:=FResultPos
     else
     begin
      MainPlanText(StartPosO, EndPosO);
      if StartPosO=0 then
       OrderText(StartPosO, EndPosO);
     end;
     if StartPosO=0 then
      Result := FastTrim(SQLText)+CLRF+ 'GROUP BY '+Value
     else
      Result := FastTrim(FastCopy(SQLText,1,StartPosO-1))+CLRF+
       'GROUP BY '+Value+  CLRF+FastCopy(SQLText,StartPosO,MaxInt)
   end;
 end
 else
 if FastTrim(Value)='' then
   Result := FastCopy(SQLText,1,StartPos-1)+FastCopy(SQLText,EndPos+1,MaxInt)
 else
 begin
   if SQLText[StartPos-1]<>#10 then
     Result := FastCopy(SQLText,1,StartPos-1)+CLRF+ 'GROUP BY '+Value
   else
     Result := FastCopy(SQLText,1,StartPos-1)+ 'GROUP BY '+Value
 end;
end;

function TSQLParser.GetFieldsClause:string;
var
    pb:integer;
    pe:integer;
begin
  if SQLKind<>skSelect then
   Result := ''
  else
  begin
    pe:=DispositionMainFrom.X-1;
    pb:=FFirstPos+6;
    while (pb<=Length(SQLText)) and (SQLText[pb] in [#13,#10,#9,' ']) do
     Inc(pb);
    while (pe>=1) and (SQLText[pe] in [#13,#10,#9,' ']) do
     Dec(pe);
    Result:=FastCopy(SQLText,pb,pe-pb+1);
  end;
end;

function    TSQLParser.SetFieldsClause(const NewFields:string):string;
var
    pb:integer;
    pe:integer;
begin
  if SQLKind<>skSelect then
   Result:=SQLText
  else
  begin
    pe:=DispositionMainFrom.X;
    pb:=FFirstPos+5;
    Result:=FastCopy(SQLText,1,pb)+CLRF+NewFields+CLRF+FastCopy(SQLText,pe,MaxInt);
  end;
end;

function TSQLParser.WhereClause(N: integer; var StartPos,
  EndPos: integer): string;
var StartPos1:integer;  
begin
    if N<0 then
    begin
      Result:=''; StartPos:=0;EndPos:=0;Exit;
    end;

    FReserved :=N; // N- number where clause
    FReserved1:=0;
    ScanText(FFirstPos,IsWhereBegin);
    if FResultPos>0 then
    begin
     StartPos :=FResultPos;
     StartPos1:=FResultPos+5;
     FScanInBrackets:=FBracketOpened>0;
     while (StartPos1<=Len) and (SQLText[StartPos1] in (CharsAfterClause - ['(','/','-','"'])) do
      Inc(StartPos1);
     ScanText(StartPos1,IsWhereEnd);
     EndPos:=FResultPos;
     if EndPos>0 then
     begin
       if EndPos<>Length(SQLText) then
        Dec(EndPos);
       while (EndPos>0) and (SQLText[EndPos] in (CharsAfterClause - ['(','/','"'])) do
        Dec(EndPos);
       Result:= FastCopy(SQLText,StartPos1,EndPos-StartPos1+1);
     end
     else
      StartPos:=0;
    end;
end;

function  TSQLParser.SetWhereClause(N:Integer;const Value:string):string;
var
  StartPos, EndPos: integer;
begin
  WhereClause(N,StartPos, EndPos);
  if StartPos=0 then
   Result := SQLText
  else
  begin
   if IsEmptyStr(Value) then
    Result:=FastCopy(SQLText,1,StartPos-1)+CLRF + FastCopy(SQLText,EndPos+1,MaxInt)
   else
   begin
    if SQLText[StartPos-1]<>#10 then
     Result:=FastCopy(SQLText,1,StartPos-1)+CLRF+ 'WHERE ' + Value
    else
     Result:=FastCopy(SQLText,1,StartPos-1)+'WHERE ' +Value ;
    if SQLText[EndPos+1]<>#13 then
     Result:=Result + CLRF + FastCopy(SQLText,EndPos+1,MaxInt)
    else
     Result:=Result +  FastCopy(SQLText,EndPos+1,MaxInt)    ;
   end;
  end;
end;

function TSQLParser.SetMainWhereClause(const Value:string):string;
var p:integer;
begin
 p:=MainWhereIndex;
 if p>0 then
  Result:=SetWhereClause(p,Value)
 else
  Result:=AddToMainWhere(Value,False);
end;

function TSQLParser.WhereCount: integer;
begin
   Result:=0;
   FReserved:=0;
   repeat
    ScanText(FResultPos+5,IsWhereBegin);
    if FResultPos>0 then  Inc(Result);
   until FResultPos=0;
end;

function TSQLParser.PlanCount:integer;
begin
   Result:=0;
   FReserved:=0;
   repeat
    ScanText(FResultPos+5,IsPlanBegin);
    if FResultPos>0 then  Inc(Result);
   until FResultPos=0;
end;

function TSQLParser.PlanText(N:integer;var  StartPos,EndPos:integer):string;
begin
    if N<0 then
    begin
      Result:=''; StartPos:=0;EndPos:=0;Exit;
    end;

    FReserved1:=0;
    FResultPos:=0;
    FReserved :=N; // N- number plan clause
    ScanText(FFirstPos,IsPlanBegin);
    if FResultPos>0 then
    begin
     StartPos:=FResultPos+5;
     FScanInBrackets:=FBracketOpened>0;
     while (StartPos<=Len) and (SQLText[StartPos] in CharsAfterClause-['(']) do
      Inc(StartPos);
     ScanText(StartPos,IsPlanEnd);
     EndPos:=FResultPos;
     if EndPos>0 then
     begin
       Dec(EndPos);
       while (EndPos>0) and (SQLText[EndPos] in CharsAfterClause) do
        Dec(EndPos);
       Result:= FastCopy(SQLText,StartPos,EndPos-StartPos+1)
     end
     else
      StartPos:=0;
    end;
end;

function  TSQLParser.MainPlanIndex:integer;
var
    p:integer;
begin
  p:=0; Result:=-1;
  FReserved :=0;
  FReserved1:=0;
  FResultPos:=FFirstPos;
  repeat
    ScanText(FResultPos+5,IsPlanBegin);
    if FResultPos>0 then
    begin
      Inc(p);
      if FBracketOpened=0 then
      begin
        Result:=p;
        Exit;
      end;
    end;
  until FResultPos=0;
end;

function  TSQLParser.MainPlanText(var  StartPos,EndPos:integer):string;
begin
 Result:=PlanText(MainPlanIndex,StartPos,EndPos)
end;

function  TSQLParser.SetMainPlan(const Text:string):string;
var
    StartPos,EndPos:integer;
begin
  MainPlanText(StartPos,EndPos);
  if StartPos>0 then
  begin
    if not IsEmptyStr(Text) then
     Result:=FastCopy(SQLText,1,StartPos-1)+Text+FastCopy(SQLText,EndPos+1,MaxInt)
    else
     Result:=FastCopy(SQLText,1,StartPos-6)+FastCopy(SQLText,EndPos+1,MaxInt)
  end
  else
  if IsEmptyStr(Text) then
   Result:=SQLText
  else
  begin
    OrderText(StartPos,EndPos);
    if StartPos>0 then
    begin
      Result:=FastCopy(SQLText,1,StartPos-1);
      if Result[Length(Result)]<>#10 then Result:=Result+CLRF;
      Result:=Result+'PLAN '+Text+ CLRF+
       FastCopy(SQLText,StartPos,MaxInt)
    end
    else
    if SQLText[Length(SQLText)]<>#10 then
     Result:=SQLText+CLRF+'PLAN '+Text
    else
     Result:=SQLText+'PLAN '+Text
  end;
end;

function    TSQLParser.GetMainPlan:string;
var
    StartPos,EndPos:integer;
begin
  Result:=MainPlanText(StartPos,EndPos)
end;

function TSQLParser.MainWhereIndex: integer;
var
    p:integer;
begin
  p:=0; Result:=-1;
  FResultPos:=0;
  FBracketOpened:=0;
  repeat
    ScanText(FResultPos+1,IsWhereBegin);
    if FResultPos>0 then
    begin
      Inc(p);
      if FBracketOpened=0 then
      begin
        Result:=p;
        Exit;
      end;
    end;
  until FResultPos=0;
end;

function TSQLParser.AddToMainWhere(const NewClause: string;
  ForceCLRF: boolean): string;
var p:integer;
    StartPos,EndPos:integer;
    CLRF :string;
begin
  CLRF :=iifStr(ForceCLRF,ForceNewStr,'');
  if IsBlank(NewClause) then
  begin
    Result:=SQLText;  Exit
  end;
  p:=MainWhereIndex;
  if p>=0 then
  begin
   WhereClause(p, StartPos,EndPos);
   Result:=
     FastCopy(SQLText,1,StartPos+4)+
      '( '+FastCopy(SQLText,StartPos+5,EndPos-StartPos-4)+CLRF+
      ' ) and ( '+NewClause+' )'+CLRF+
      FastCopy(SQLText,EndPos+1,MaxInt);
  end
  else
  begin
    p     :=DispositionMainFrom.Y;
    Result:=
      FastCopy(SQLText,1,p)+#13#10+BeginWhere+CLRF+NewClause+#13#10+FastCopy(SQLText,p+1,MaxInt)
  end
end;

function   TSQLParser.IsSelect(Position:integer):boolean;
begin
 Result:=InternalIsClause('SELECT',SQLText,Position);
 if not Result then
   Result:=InternalIsClause('MERGE',SQLText,Position);
end;


function   TSQLParser.IsUpdate(Position:integer):boolean;
begin
 Result:=   InternalIsClause('UPDATE',SQLText,Position);
end;


function   TSQLParser.IsDelete(Position:integer):boolean;
begin
 Result:=   InternalIsClause('DELETE',SQLText,Position);
end;

function   TSQLParser.IsInsert(Position:integer):boolean;
begin
 Result:=   InternalIsClause('INSERT',SQLText,Position);
end;

function TSQLParser.IsExecute(Position:integer):boolean;
begin
 Result:=   InternalIsClause('EXECUTE',SQLText,Position);
end;

function   TSQLParser.IsExecuteBlock(Position:integer):boolean;
var
  vPosition:integer;
begin
 if not IsExecute(Position) then
  Result := False
 else
 begin
    vPosition:=Position+7;
    SkipCommentsAndBlanks(SQLText,Len,vPosition);
    Result:=   InternalIsClause('BLOCK',SQLText,vPosition);
 end;
end;

function   TSQLParser.IsExecuteProc(Position:integer):boolean;
var
  vPosition:integer;
begin
 if not IsExecute(Position) then
  Result := False
 else
 begin
    vPosition:=Position+7;
    SkipCommentsAndBlanks(SQLText,Len,vPosition);
    Result:=   InternalIsClause('PROCEDURE',SQLText,vPosition);
 end;
end;

function TSQLParser.IsDDL:boolean;
var
  vPosition: Integer;
begin
  Result:= (Len>0) and  ((FFirstPos=1) or (SQLText[FFirstPos-1] in CharsBeforeClause));
  if Result then
  case SQLText[FFirstPos] of
    'A','a':
      begin
       Result:=InternalIsClause('ALTER',SQLText,FFirstPos);
      end;
    'C','c':
     begin
       Result:=InternalIsClause('CREATE',SQLText,FFirstPos);
       if not Result then
          Result:=InternalIsClause('COMMENT',SQLText,FFirstPos);
     end;
    'D','d':
     begin
      Result:=InternalIsClause('DROP',SQLText,FFirstPos);
      if not Result then
       Result:=InternalIsClause('DECLARE',SQLText,FFirstPos);
     end;
    'G','g':
    begin
      Result:=InternalIsClause('GRANT',SQLText,FFirstPos);
    end;
    'R','r':
    begin
      Result:=InternalIsClause('RECREATE',SQLText,FFirstPos);
      if not Result then
       Result:=InternalIsClause('REVOKE',SQLText,FFirstPos);
    end;
    'S', 's':
    begin
        if  InternalIsClause('SET',SQLText,FFirstPos) then
        begin
             vPosition := FFirstPos+4;
             while (vPosition <= Len) and (SQLText[vPosition] in CharsBeforeClause) do
              Inc(vPosition);
             Result:=InternalIsClause('GENERATOR',SQLText,vPosition);
        end;
    end;
  else
   Result:=False;
  end;
end;

{
function TSQLParser.IsDDL:boolean;
var
  vPosition: Integer;


begin
  Result:= (Len>0) and  ((FFirstPos=1) or (SQLText[FFirstPos-1] in CharsBeforeClause));
  if Result then
  case SQLText[FFirstPos] of
    'A','a':
      begin
       Result:=
          (Len-FFirstPos>=5)  and
          (SQLText[FFirstPos+1] in ['L','l'])   and
          (SQLText[FFirstPos+2] in ['T','t'])   and
          (SQLText[FFirstPos+3] in ['E','e'])   and
          (SQLText[FFirstPos+4] in ['R','r'])   and
          (SQLText[FFirstPos+5] in CharsAfterClause);
      end;
    'C','c':
     begin
        Result:=
          (Len-FFirstPos>=6)  and
          (SQLText[FFirstPos+1] in ['R','r'])   and
          (SQLText[FFirstPos+2] in ['E','e'])   and
          (SQLText[FFirstPos+3] in ['A','a'])   and
          (SQLText[FFirstPos+4] in ['T','t'])   and
          (SQLText[FFirstPos+5] in ['E','e'])   and
          (SQLText[FFirstPos+6] in CharsAfterClause);

        if not Result then
          Result:=   (Len-FFirstPos>6)and
           (SQLText[FFirstPos]   in ['C','c'])   and
           (SQLText[FFirstPos+1] in ['O','o'])   and
           (SQLText[FFirstPos+2] in ['M','m'])   and
           (SQLText[FFirstPos+3] in ['M','m'])   and
           (SQLText[FFirstPos+4] in ['E','e'])   and
           (SQLText[FFirstPos+5] in ['N','n'])   and
           (SQLText[FFirstPos+6] in ['T','t']) and
           (SQLText[FFirstPos+7] in CharsAfterClause);
     end;
    'D','d':
     begin
      Result:=
          (Len-FFirstPos>=4)  and
          (SQLText[FFirstPos+1] in ['R','r'])   and
          (SQLText[FFirstPos+2] in ['O','o'])   and
          (SQLText[FFirstPos+3] in ['P','p'])   and
          (SQLText[FFirstPos+4] in CharsAfterClause);
      if not Result then
      Result:=
          (Len-FFirstPos>=7)  and
          (SQLText[FFirstPos+1] in ['E','e'])   and
          (SQLText[FFirstPos+2] in ['C','c'])   and
          (SQLText[FFirstPos+3] in ['L','l'])   and
          (SQLText[FFirstPos+4] in ['A','a'])   and
          (SQLText[FFirstPos+5] in ['R','r'])   and
          (SQLText[FFirstPos+6] in ['E','e'])   and
          (SQLText[FFirstPos+7] in CharsAfterClause);
     end;
    'R','r':
    begin
         Result:=
          (Len-FFirstPos>=8)  and
          (SQLText[FFirstPos+1] in ['E','e'])   and
          (SQLText[FFirstPos+2] in ['C','c'])   and
          (SQLText[FFirstPos+3] in ['R','r'])   and
          (SQLText[FFirstPos+4] in ['E','e'])   and
          (SQLText[FFirstPos+5] in ['A','a'])   and
          (SQLText[FFirstPos+6] in ['T','t'])   and
          (SQLText[FFirstPos+7] in ['E','e'])   and
          (SQLText[FFirstPos+8] in CharsAfterClause);
    end;
    'S', 's':
    begin
        if
             (Len-FFirstPos>=3)  and
             (SQLText[FFirstPos+1] in ['E','e'])   and
             (SQLText[FFirstPos+2] in ['T','t'])   and
             (SQLText[FFirstPos+3] in CharsAfterClause) then
            begin
             vPosition := FFirstPos+4;
             while (vPosition <= Len) and (SQLText[vPosition] in CharsBeforeClause) do
              Inc(vPosition);
             Result:=
              (Len-vPosition>=9)  and
              (SQLText[vPosition] in ['G','g'])   and
              (SQLText[vPosition+1] in ['E','e'])   and
              (SQLText[vPosition+2] in ['N','n'])   and
              (SQLText[vPosition+3] in ['E','e'])   and
              (SQLText[vPosition+4] in ['R','r'])   and
              (SQLText[vPosition+5] in ['A','a'])   and
              (SQLText[vPosition+6] in ['T','t'])   and
              (SQLText[vPosition+7] in ['O','o'])   and
              (SQLText[vPosition+8] in ['R','r'])   and
              (SQLText[vPosition+9] in CharsAfterClause);
            end;
    end;
  else
   Result:=False;
  end;
end;
 }
function TSQLParser.GetSQLKind: TSQLKind;
begin
 if IsSelect(FFirstPos)  then
  Result:=skSelect
 else
 if IsUpdate(FFirstPos)  then
  Result:=skUpdate
 else
 if IsDelete(FFirstPos)  then
  Result:=skDelete
 else
 if IsInsert(FFirstPos)  then
  Result:=skInsert
 else
 if IsExecuteProc(FFirstPos) then
  Result:=skExecuteProc
 else
 if IsExecuteBlock(FFirstPos) then
  Result:=skExecuteBlock
 else
 if IsDDL    then
  Result:=skDDL
 else
  Result:=skUnknown;
// FCanParamsCheck:=not (Result in [skDDL,skUnknown]);
 FCanParamsCheck:=Result <> skDDL;
end;


function TSQLParser.RecCountSQLText: string;
var fr:TPoint;
    StartWhere,EndWhere:integer;
    wh:string;
begin
 Result:='';
 if SQLKind<>skSelect then
  Exit;
 fr:=DispositionMainFrom;
 if fr.x=0 then Exit;
 Result:='Select Count(*) '+FastCopy(SQLText,fr.x,fr.y-fr.x+1);
 wh:=MainWhereClause(StartWhere,EndWhere);
 if wh<>'' then
  Result:=Result+#13#10+BeginWhere+wh;
end;

function TSQLParser.MainWhereClause(var StartPos, EndPos: integer): string;
begin
 FResultPos:=0;
 Result:=WhereClause(MainWhereIndex,StartPos,EndPos)
end;

procedure TSQLParser.FillMainTables(WithSP:boolean=False);
var
    FromPos:TPoint;
    FromTxt:string;
    i,p,p1:integer;
    tmpStr:string;
    wc:integer;
    InQuote:boolean;
begin
   FTables.Clear;
   FromPos:=DispositionMainFrom;
   if FromPos.X>0 then
     if FromPos.Y=Length(SQLText) then
      FromTxt:=FastCopy(SQLText,FromPos.X+5,MaxInt)
     else
      FromTxt:=FastCopy(SQLText,FromPos.X+5,FromPos.Y-FromPos.X-5)
   else
    FromTxt:='';
   if Length(FromTxt)= 0 then
    Exit;
   FromTxt:=RemoveComments(FromTxt);
   i:=1; p:=0;
   SetLength(tmpStr,Length(FromTxt));
   InQuote:=False;
   while i<=Length(FromTxt) do
   begin
    if not InQuote and (FromTxt[i] in CharsAfterClause-['(','"']) then
    begin
      if p=0 then
       Inc(i)
      else
      if FromTxt[i-1] in CharsAfterClause -['(','"'] then
       Inc(i)
      else
      begin
        Inc(p);
        tmpStr[p]:=' ';
        Inc(i);
      end;
    end
    else
    begin
      Inc(p);
      tmpStr[p]:=FromTxt[i];
      Inc(i);
      if tmpStr[p] = '"' then
       InQuote:= not InQuote;
    end;
   end;
   if tmpStr[p]=' ' then
    Dec(p);
   SetLength(tmpStr,p);
   FromTxt:=tmpStr;
   FromTxt:=RemoveJoins(FromTxt);
   if PosCh('(',FromTxt)>0 then
    FromTxt:=RemoveSP(FromTxt,WithSP);
   wc:=WordCount(FromTxt,[',']);
   for  i:=1  to wc do
   begin
    tmpStr:=ExtractWord(i, FromTxt,[',']);
    DoTrim(tmpStr);
    if Length(tmpStr) > 0 then
    begin
     p:=PosCh1('"',tmpStr,2);
     if p=0 then
       DoUpperCase(tmpStr)
     else
     begin
       p1:=PosCh1('"',tmpStr,p+1);
       case tmpStr[1]   of
        '"':
        begin
          if p1=0 then
          begin
            DoUpperCase(tmpStr,p+1,MaxInt);
          end;
        end;
       else
        DoUpperCase(tmpStr,1,p-1);
        if p1=0 then
        begin
          DoUpperCase(tmpStr,p+1,MaxInt);
        end;
       end;
     end;
     FTables.Add(tmpStr);
    end;
   end;
end;

function TSQLParser.GetAllTables(WithSP:boolean=False): TStrings;
begin
 if FTables.Count=0 then
 begin
   case SQLKind of    //
     skSelect:
     begin
       FillMainTables(WithSP);
     end;
   else
     FTables.Text:=ModifiedTables;
   end;
 end;
 Result:=FTables
end;


function  GetFieldByAlias(const SQLText,FieldName:string):string;
var
  p:integer;
  cBracket:integer;
  Step:byte;
  FieldsClauseTxt:string;
  OnlyNumeric:boolean;
begin
  FieldsClauseTxt:=FieldsClause(SQLText);
  p:=PosExtCI(FieldName,FieldsClauseTxt,CharsBeforeClause,CharsAfterClause+[',']);
  if p=0 then
   p:=PosExtCI('"'+FieldName+'"',FieldsClauseTxt,CharsBeforeClause,CharsAfterClause+[',']);

  Dec(p);
  if p<=0 then
  begin
    Result:='';
    Exit;
  end
  else
  if FieldsClauseTxt[p]='"' then
   Dec(p);

  while (p>0) and (FieldsClauseTxt[p] in CharsAfterClause) do
   Dec(p);

  if (p=0) or (FieldsClauseTxt[p]=',') then
  begin
    Result:=FieldName;
    Exit;
  end;
  if p>3 then
  begin
    if FieldsClauseTxt[p] in ['S','s'] then
     if FieldsClauseTxt[p-1] in ['A','a'] then
      if FieldsClauseTxt[p-2] in CharsAfterClause+[')'] then
       Dec(p,2);
  end;
  while (p>0) and (FieldsClauseTxt[p] in CharsAfterClause+[#10]) do
   Dec(p);
  if (p=0) or (FieldsClauseTxt[p]=',') then
  begin
    Result:=FieldName;
    Exit;
  end;
  if FieldsClauseTxt[p]<>')' then
   begin
    Result := '';
    Step:=1;
(* Step
   1 - ����������� ��� ���� � ������� �����
   2 - ������� �����
   3 - ����� ��������� , ���������� ������� ����� ����� �������
   4 - ����������� ��� �������, ���� �������� ���� �����������

*)

    while (p>0) do
    begin
       case FieldsClauseTxt[p] of
        ',': Break;
        '.':
        begin
         if Step in[1,2] then
          Step:=3;
         Result := FieldsClauseTxt[p]+Result;
        end;
       else
        if  not (FieldsClauseTxt[p] in CharsAfterClause)  then
        begin
         case Step of
          2: Break;        // ����� �� ��������� �������
          3: Step:=4
         end;
         Result := FieldsClauseTxt[p]+Result;
        end
        else
        case Step of
         1: Step:=2;
         4: Break
        end
       end;
       Dec(p);
    end;
   end
  else
   begin
     cBracket:=1;
     Result:='';
     Dec(p);
     while (cBracket>0) and (p>0) do
     begin
       if FieldsClauseTxt[p]='(' then
        Dec(cBracket)
       else
       if FieldsClauseTxt[p]=')' then
        Inc(cBracket);
       if (cBracket>0)then
        Result:=FieldsClauseTxt[p]+ Result ;
       Dec(p);
     end;
     while (p>0) and (FieldsClauseTxt[p] in CharsAfterClause+[#10]) do
      Dec(p);
     while (p>0) and not (FieldsClauseTxt[p] in CharsAfterClause+[',']) do
     begin
       Result := FieldsClauseTxt[p]+Result;
       Dec(p);
     end;
   end;
   case Length(Result) of
    2: if (Result[1] in ['O','o']) and (Result[2] in ['R','r']) then
        Result:='';
    3: if (Result[1] in ['A','a']) and (Result[2] in ['N','n']) and (Result[3] in ['D','d']) then
        Result:='';
   end;
   if Length(Result)=8 then
    if (Result[1] in ['D','d']) and (Result[2] in ['I','i']) and
       (Result[3] in ['S','s']) and (Result[4] in ['T','t']) and
       (Result[5] in ['I','i']) and (Result[6] in ['N','n']) and
       (Result[7] in ['C','c']) and (Result[8] in ['T','t'])
    then
    begin
      Result:=FieldName;
      Exit;
    end;
    OnlyNumeric:=True;
    for p:=1 to Length(Result) do
     if not (Result[p] in ['0'..'9']) then
     begin
      OnlyNumeric:=False;
      Break
     end;
    if OnlyNumeric then
          Result:=FieldName;
end;


function  GetLinkFieldName(const SQLText,ParamName: string): string;
var Ind:integer;
    Wh:string;
    StartPos,EndPos:integer;
    c,p:integer;
begin
  Result:='';
  c:=WhereCount(SQLText);
  Ind:=1;
  while Ind<=c do
  begin
   Wh:=GetWhereClause(SQLText,Ind,StartPos,EndPos);
   p:=PosExtCI(':'+ParamName,Wh,
    CharsBeforeClause+endLexem,CharsAfterClause+endLexem
   )-1;
   if p<0 then
    p:=PosExt(':"'+ParamName+'"',Wh,
     CharsBeforeClause+endLexem,CharsAfterClause+endLexem
    )-1;

   while (p>0) and (wh[p] in CharsBeforeClause+endLexem+[':',#13]) do
    Dec(p);
   if p>0 then
   begin
    while (p>0) and not (wh[p] in CharsBeforeClause+endLexem+[':','.']) do
    begin
     Result:=wh[p]+Result;
     Dec(p);
    end;
    Exit;
   end;

   p:=PosExtCI('?'+ParamName,Wh,
    CharsBeforeClause+endLexem,CharsAfterClause+endLexem
   )-1;
   while (p>0) and (wh[p] in CharsBeforeClause+endLexem+['?',#13]) do Dec(p);
   if p>0 then
   begin
    while (p>0) and not (wh[p] in CharsBeforeClause+endLexem+['?']) do
    begin
     Result:=wh[p]+Result;
     Dec(p);
    end;
    Exit;
   end;
   Inc(Ind);
  end;  
end;

 function  IsWhereBeginPos(const SQLText:string;Position:integer):boolean;
 var Len:integer;
 begin
  Len:=Length(SQLText);
  Result:=(Position>1) and (Len-Position>=5)
   and (SQLText[Position]   in ['W','w'])
   and (SQLText[Position+1] in ['H','h'])
   and (SQLText[Position+2] in ['E','e'])
   and (SQLText[Position+3] in ['R','r'])
   and (SQLText[Position+4] in ['E','e'])
   and (SQLText[Position-1] in CharsBeforeClause)
   and (SQLText[Position+5] in ['(']+CharsAfterClause);
 end;

function  IsWhereEndPos(const SQLText:string;Position:integer):boolean;
var
    p:integer;
    Len:integer;
begin
   Len:=Length(SQLText);
   p:=Position;
   Result := p=Len;
   if Result then  Exit;
   if (Len>P)and (P>1) and (SQLText[P-1] in CharsBeforeClause) then
   begin
    if (Len-P)>1 then
    case SQLText[P] of
    'F','f': // FOR UPDATE
      Result:=((Len-P)>=3) and
           (SQLText[P+1] in ['O','o']) and
           (SQLText[P+2] in ['R','r']) and
           (SQLText[P+3] in CharsAfterClause);

    'G','g': //GROUP BY
      Result:=((Len-P)>=5) and
           (SQLText[P+1] in ['R','r']) and
           (SQLText[P+2] in ['O','o']) and
           (SQLText[P+3] in ['U','u']) and
           (SQLText[P+4] in ['P','p']) and
           (SQLText[P+5] in CharsAfterClause);
    'H','h': //HAVING
      Result:=((Len-P)>=6)    and
           (SQLText[P+1] in ['A','a']) and
           (SQLText[P+2] in ['V','v']) and
           (SQLText[P+3] in ['I','i']) and
           (SQLText[P+4] in ['N','n']) and
           (SQLText[P+5] in ['G','g']) and
           (SQLText[P+6] in CharsAfterClause+['(']);

    'O','o'://ORDER BY
      Result:=((Len-P)>=5) and
           (SQLText[P+1] in ['R','r']) and
           (SQLText[P+2] in ['D','d']) and
           (SQLText[P+3] in ['E','e']) and
           (SQLText[P+4] in ['R','r']) and
           (SQLText[P+5] in CharsAfterClause);
    'P','p': // PLAN
      Result:=((Len-P)>=4) and
           (SQLText[P+1] in ['L','l']) and
           (SQLText[P+2] in ['A','a']) and
           (SQLText[P+3] in ['N','n']) and
           (SQLText[P+4] in CharsAfterClause+['(']);
    'S','s':
      Result:=((Len-P)>=6) and
           (SQLText[P+1] in ['T','t']) and
           (SQLText[P+2] in ['A','a']) and
           (SQLText[P+3] in ['R','r']) and
           (SQLText[P+4] in ['T','t']) and
           (SQLText[P+5] in CharsAfterClause);
    'U','u':
      Result:=((Len-P)>=6) and
           (SQLText[P+1] in ['N','n']) and
           (SQLText[P+2] in ['I','i']) and
           (SQLText[P+3] in ['O','o']) and
           (SQLText[P+4] in ['N','n']) and
           (SQLText[P+5] in CharsAfterClause);
    end;
  end
end;

 function  PosInSections(const SQLText:string;Position:integer):TSQLSections;
 var
    SQLPars:TSQLParser;
 begin
   SQLPars:=TSQLParser.Create(SQLText);
   try
    Result:=SQLPars.PosInSections(Position)
   finally
     SQLPars.Free
   end;
 end;


function  InvertOrderClause(const OrderText:string):string;
var
  I: Integer;
  State:byte; //0 - ����������� ��� ,1 ���� ASC ��� DESC, 2 - ���� �����, 3 - collate
//0 - ����������� ��� ,1 ���� ASC ��� DESC, 2 - ���� �����, 3,4 - collate,5 - ������������ ��� ����
//6 - NULLS FIRST
  CurAsc:boolean ;
  InComment:TParserState;
begin
   Result := '';
   if Length(OrderText) = 0 then
     Exit;
   I:=1;
   while (I<=Length(OrderText))  and (OrderText[I] in [' ',#13,#9,#10])  do
    Inc(I);

   State  :=0;
   CurAsc :=True;
   InComment:=sNormal;
   while I<=Length(OrderText)  do
   begin
     if I<Length(OrderText) then
     case InComment of
      sNormal:
         case OrderText[I] of
          '-': if OrderText[I+1]='-' then
               begin
                 InComment:=sFBComment;
                 Inc(i);
                 Continue
               end;
           '/':if OrderText[I+1]='*' then
               begin
                 InComment:=sComment;
                 Inc(i);
                 Continue
               end;
         end;
      sFBComment:
        case OrderText[I] of
         #13,#10:  InComment:=sNormal;
        else
          Inc(i);
          Continue
        end;
      sComment:
        case OrderText[I] of
         '*': if OrderText[I+1]='/' then
              begin
               Inc(i,2);
               InComment:=sNormal;
              end
              else
              begin
               Inc(i);
               Continue
              end;
        else
          Inc(i);
          Continue
        end;
     end;
     case State of
      0:
      begin
        case OrderText[I] of
         ' ',#13,#9,#10: State:=1;
         ',' :
         begin
           if CurAsc then
            Result:= Result +' desc,'
           else
            Result:= Result +',';
           while (I<Length(OrderText))  and (OrderText[I+1] in [' ',#13,#9,#10])  do
            Inc(I);
         end;
         '"':
         begin
          Result:=Result+'"';
          State:=5;
         end
        else
          Result := Result+ OrderText[I];
        end;
        Inc(I);
      end;
      1:
      begin
       case OrderText[I] of
          'A','a': Inc(I,2); //ASC
          'C','c'://COLLATE
          begin
           Result:=Result+OrderText[I-1]+OrderText[I];
           State:=3;
          end;
          'D','d'://DESC
          begin
           CurAsc:=False;
           Inc(I,3);
          end;
          'N','n'://NULLS FIRST or LAST
          begin
            if CurAsc then
             Result:= Result +' desc ';
            Inc(I,5);
            while (I<Length(OrderText))  and (OrderText[I] in [' ',#13,#9,#10])  do
             Inc(I);
            if OrderText[I] in ['F','f'] then
            begin
              Result:= Result +' NULLS LAST';
              Inc(I,4);
            end
            else
            begin
              Result:= Result +' NULLS FIRST';
              Inc(I,3);              
            end;
           CurAsc:=True;
           State:=6;
          end;
          ',':
          begin
            if CurAsc then
             Result:= Result +' desc,'
            else
             Result:= Result +',';
           State:=2;
           CurAsc:=True;
          end;
       end;
       Inc(I);
      end;
      2:
        if  (OrderText[I] in [' ',#13,#10,#9]) then
         Inc(I)
        else
         State:=0;
      3:
      while (I<=Length(OrderText))  do
      begin
       if  (OrderText[I]<>',') then
        Result:=Result+OrderText[I];
       if  (OrderText[I] in [' ',#13,#10,#9,',']) then
       begin
        if State=3 then
        begin
         State:=4
        end
        else
        begin
          State:=1;
          Break;
        end;
       end;
       Inc(I);
      end;
      5:
      begin
        Result := Result+ OrderText[I];
        if OrderText[I]='"' then
         State:=0;
       Inc(I);
      end;
      6:
      begin
        if OrderText[I]=',' then
        begin
         Result:= Result+',';
         while (I<Length(OrderText))  and (OrderText[I+1] in [' ',#13,#9,#10])  do
            Inc(I);
         State:=0;
        end;
        Inc(I);
      end;
     end;
   end;
   if CurAsc and (State<>6) then
     Result:= Result +' desc';
end;

end.


