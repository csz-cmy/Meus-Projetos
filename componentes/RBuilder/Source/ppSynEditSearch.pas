{ RRRRRR                  ReportBuilder Class Library                  BBBBB
  RR   RR                                                              BB   BB
  RRRRRR                 Digital Metaphors Corporation                 BB BB
  RR  RR                                                               BB   BB
  RR   RR                                                              BBBBB   }

{-------------------------------------------------------------------------------
 This unit is a adapted from the SynEdit project
 The original header appears in the box below.

 original unit: SynEditSearch.pas

 This unit is a subset of the original. A prefix of pp has been added
 to all classes and methods to differentiate them from the original.
 This has been done to avoid conflicts for users that install
 ReportBuilder and SynEdit
-------------------------------------------------------------------------------}

{-------------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: SynEditSearch.pas, released 2000-04-07.

The Original Code is based on the mwEditSearch.pas file from the mwEdit
component suite by Martin Waldenburg and other developers.
Portions created by Martin Waldenburg are Copyright 1999 Martin Waldenburg.
All Rights Reserved.

Contributors to the SynEdit project are listed in the Contributors.txt file.

Alternatively, the contents of this file may be used under the terms of the
GNU General Public License Version 2 or later (the "GPL"), in which case
the provisions of the GPL are applicable instead of those above.
If you wish to allow use of your version of this file only under the terms
of the GPL and not to allow others to use your version of this file
under the MPL, indicate your decision by deleting the provisions above and
replace them with the notice and other provisions required by the GPL.
If you do not delete the provisions above, a recipient may use your version
of this file under either the MPL or the GPL.

$Id: SynEditSearch.pas,v 1.7 2002/04/12 12:52:27 harmeister Exp $

You may retrieve the latest version of this file at the SynEdit home page,
located at http://SynEdit.SourceForge.net

Known Issues:
-------------------------------------------------------------------------------}

unit ppSynEditSearch;

{$I ppSynEdit.inc}

interface

uses
  Classes;

procedure MakeCompTable(Sensitive: boolean);
procedure MakeDelimiterTable;

type
  TppSynEditSearch = class;

  TSynEditSearchOverride = procedure(var ASynEditSearch: TppSynEditSearch) of object;

  TppSynEditSearch = class(TObject)
  private
    Run: PChar;
    Origin: PChar;
    TheEnd: PChar;
    Pat: string;
    fCount: Integer;
    fTextLen: Integer;
    Look_At: Integer;
    PatLen, PatLenPlus: Integer;
    Shift: array[0..255] of Integer;
    fSensitive: Boolean;
    fWhole: Boolean;
    fResults: TList;
    fShiftInitialized: boolean;
    function GetFinished: Boolean;
    function GetResult(Index: integer): integer;
    function GetResultCount: integer;
    procedure InitShiftTable;
    procedure SetPattern(const Value: string);
    procedure SetSensitive(const Value: Boolean);
  protected
    function TestWholeWord: boolean; virtual;
  public
    constructor Create;
    destructor Destroy; override;
    function FindAll(const NewText: string): integer;
    function FindFirst(const NewText: string): Integer;
    procedure FixResults(First, Delta: integer);
    function Next: Integer;
    property Count: Integer read fCount write fCount;
    property Finished: Boolean read GetFinished;
    property Pattern: string read Pat write SetPattern;
    property Results[Index: integer]: integer read GetResult;
    property ResultCount: integer read GetResultCount;
    property Sensitive: Boolean read fSensitive write SetSensitive;
    property Whole: Boolean read fWhole write fWhole;
  end;

implementation

uses
{$IFDEF SYN_CLX}
  kTextDrawer,
  Types,
{$ELSE}
  Windows,
{$ENDIF}
  SysUtils;
  
var
  CompTableSensitive: boolean;
  CompTable: array[#0..#255] of Byte;
  DelimTable: array[#0..#255] of boolean;

constructor TppSynEditSearch.Create;
begin
  inherited Create;
  fResults := TList.Create;
end;

procedure MakeCompTable(Sensitive: Boolean);
var
  I: Char;
begin
  if CompTableSensitive <> Sensitive then
  begin
    CompTableSensitive := Sensitive;
    for I := #0 to #255 do CompTable[I] := ord(I);
    if not Sensitive then
{$IFDEF SYN_CLX}
      for I := #0 to #255 do
        CompTable[I] := ord(upcase(char(CompTable[I])));
{$ELSE}
      CharLowerBuff(PChar(@CompTable[#0]), 256);
{$ENDIF}
  end;
end;

procedure MakeDelimiterTable;
var
  c: char;
begin
  for c := #0 to #255 do
{$IFDEF SYN_CLX}
    DelimTable[c] := not (c in ['0'..'9', 'A'..'Z', 'a'..'z', '_']);
{$ELSE}
    DelimTable[c] := not (IsCharAlphaNumeric(c) or (c = '_'));                  //sb 2001-11-23
{$ENDIF}
end;

function TppSynEditSearch.GetFinished: Boolean;
begin
  Result := (Run >= TheEnd) or (PatLen >= fTextLen);
end;

function TppSynEditSearch.GetResult(Index: integer): integer;
begin
  Result := 0;
  if (Index >= 0) and (Index < fResults.Count) then
    Result := integer(fResults[Index]);
end;

function TppSynEditSearch.GetResultCount: integer;
begin
  Result := fResults.Count;
end;

procedure TppSynEditSearch.FixResults(First, Delta: integer);
var
  i: integer;
begin
  if (Delta <> 0) and (fResults.Count > 0) then begin
    i := Pred(fResults.Count);
    while i >= 0 do begin
      if integer(fResults[i]) <= First then break;
      fResults[i] := pointer(integer(fResults[i]) - Delta);
      Dec(i);
    end;
  end;
end;

procedure TppSynEditSearch.InitShiftTable;
var
  I: Byte;
begin
  PatLen := Length(Pat);
  if Patlen = 0 then raise Exception.Create('Pattern is empty');
  PatLenPlus := PatLen + 1;
  Look_At := 1;
  for I := 0 to 255 do Shift[I] := PatLenPlus;
  for I := 1 to PatLen do Shift[CompTable[Pat[i]]] := PatLenPlus - I;
  while Look_at < PatLen do
  begin
    if CompTable[Pat[PatLen]] = CompTable[Pat[PatLen - (Look_at)]] then exit;
    inc(Look_at);
  end;
  fShiftInitialized := TRUE;
end;

function TppSynEditSearch.TestWholeWord: boolean;
var
  Test: PChar;
begin
  Test := Run - PatLen;
  Result := ((Test < Origin) or DelimTable[Test[0]]) and
    ((Run >= TheEnd) or DelimTable[Run[1]]);
end;

function TppSynEditSearch.Next: Integer;
var
  I: Integer;
  J: PChar;
begin
  Result := 0;
  inc(Run, PatLen);
  while Run < TheEnd do
  begin
    if CompTable[Pat[Patlen]] <> CompTable[Run^] then
      inc(Run, Shift[CompTable[(Run + 1)^]])
    else
    begin
      J := Run - PatLen + 1;
      I := 1;
      while CompTable[Pat[I]] = CompTable[J^] do
      begin
        if I = PatLen then
        begin
          Case fWhole of
            True: if not TestWholeWord then break;
          end;
          inc(fCount);
          Result := Run - Origin - Patlen + 2;
          exit;
        end;
        inc(I);
        inc(J);
      end;
{begin}                                                                         //mh 2000-08-29
//      inc(Run, Look_At + Shift[CompTable[(Run + Look_at)^]] - 1);
      Inc(Run, Look_At);
      if Run >= TheEnd then
        break;
      Inc(Run, Shift[CompTable[Run^]] - 1);
{end}                                                                           //mh 2000-08-29
    end;
  end;
end;

destructor TppSynEditSearch.Destroy;
begin
  fResults.Free;
  inherited Destroy;
end;

procedure TppSynEditSearch.SetPattern(const Value: string);
begin
  if Pat <> Value then begin
    Pat := Value;
    fShiftInitialized := FALSE;                                  
  end;
  fCount := 0;
end;

procedure TppSynEditSearch.SetSensitive(const Value: Boolean);
begin
  if fSensitive <> Value then begin
    fSensitive := Value;
    MakeCompTable(Value);
    fShiftInitialized := FALSE;
  end;
end;

function TppSynEditSearch.FindAll(const NewText: string): integer;
var
  Found: integer;
begin
  // never shrink Capacity
  fResults.Count := 0;
  Found := FindFirst(NewText);
  while Found > 0 do
  begin
    fResults.Add(pointer(Found));
    Found := Next;
  end;
  Result := fResults.Count;
end;

function TppSynEditSearch.FindFirst(const NewText: string): Integer;
begin
  if not fShiftInitialized then
    InitShiftTable;
  Result := 0;
  fTextLen := Length(NewText);
  if fTextLen >= PatLen then
  begin
    Origin := PChar(NewText);
    TheEnd := Origin + fTextLen;
    Run := (Origin - 1);
    Result := Next;
  end;
end;

initialization
  CompTableSensitive := True; // force the table initialization
  MakeCompTable(False);
  MakeDelimiterTable;
end.

