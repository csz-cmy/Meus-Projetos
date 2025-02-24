{***************************************************************************}
{ This source code was generated automatically by                           }
{ Pas file import tool for Scripter Studio (Pro)                            }
{                                                                           }
{ Scripter Studio and Pas file import tool for Scripter Studio              }
{ written by TMS Software                                                   }
{            copyright � 1997 - 2010                                        }
{            Email : info@tmssoftware.com                                   }
{            Web : http://www.tmssoftware.com                               }
{***************************************************************************}
unit ap_StrUtils;

interface

uses
  SysUtils,
  StrUtils,
  Variants,
  atScript;

{$WARNINGS OFF}

type
  TatStrUtilsLibrary = class(TatScripterLibrary)
    procedure __AnsiResemblesText(AMachine: TatVirtualMachine);
    procedure __AnsiContainsText(AMachine: TatVirtualMachine);
    procedure __AnsiStartsText(AMachine: TatVirtualMachine);
    procedure __AnsiEndsText(AMachine: TatVirtualMachine);
    procedure __AnsiReplaceText(AMachine: TatVirtualMachine);
    procedure __AnsiContainsStr(AMachine: TatVirtualMachine);
    procedure __AnsiStartsStr(AMachine: TatVirtualMachine);
    procedure __AnsiEndsStr(AMachine: TatVirtualMachine);
    procedure __AnsiReplaceStr(AMachine: TatVirtualMachine);
    procedure __DupeString(AMachine: TatVirtualMachine);
    procedure __ReverseString(AMachine: TatVirtualMachine);
    procedure __StuffString(AMachine: TatVirtualMachine);
    procedure __IfThen(AMachine: TatVirtualMachine);
    procedure __LeftStr(AMachine: TatVirtualMachine);
    procedure __RightStr(AMachine: TatVirtualMachine);
    procedure __MidStr(AMachine: TatVirtualMachine);
    procedure __SearchBuf(AMachine: TatVirtualMachine);
    procedure __Soundex(AMachine: TatVirtualMachine);
    procedure __SoundexInt(AMachine: TatVirtualMachine);
    procedure __DecodeSoundexInt(AMachine: TatVirtualMachine);
    procedure __SoundexWord(AMachine: TatVirtualMachine);
    procedure __DecodeSoundexWord(AMachine: TatVirtualMachine);
    procedure __SoundexSimilar(AMachine: TatVirtualMachine);
    procedure __SoundexCompare(AMachine: TatVirtualMachine);
    procedure __SoundexProc(AMachine: TatVirtualMachine);
    procedure __GetWordDelimiters(AMachine: TatVirtualMachine);
    procedure Init; override;
    class function LibraryName: string; override;
  end;




implementation



procedure TatStrUtilsLibrary.__AnsiResemblesText(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := StrUtils.AnsiResemblesText(GetInputArg(0),GetInputArg(1));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatStrUtilsLibrary.__AnsiContainsText(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := StrUtils.AnsiContainsText(GetInputArg(0),GetInputArg(1));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatStrUtilsLibrary.__AnsiStartsText(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := StrUtils.AnsiStartsText(GetInputArg(0),GetInputArg(1));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatStrUtilsLibrary.__AnsiEndsText(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := StrUtils.AnsiEndsText(GetInputArg(0),GetInputArg(1));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatStrUtilsLibrary.__AnsiReplaceText(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := StrUtils.AnsiReplaceText(GetInputArg(0),GetInputArg(1),GetInputArg(2));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatStrUtilsLibrary.__AnsiContainsStr(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := StrUtils.AnsiContainsStr(GetInputArg(0),GetInputArg(1));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatStrUtilsLibrary.__AnsiStartsStr(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := StrUtils.AnsiStartsStr(GetInputArg(0),GetInputArg(1));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatStrUtilsLibrary.__AnsiEndsStr(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := StrUtils.AnsiEndsStr(GetInputArg(0),GetInputArg(1));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatStrUtilsLibrary.__AnsiReplaceStr(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := StrUtils.AnsiReplaceStr(GetInputArg(0),GetInputArg(1),GetInputArg(2));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatStrUtilsLibrary.__DupeString(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := StrUtils.DupeString(GetInputArg(0),VarToInteger(GetInputArg(1)));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatStrUtilsLibrary.__ReverseString(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := StrUtils.ReverseString(GetInputArg(0));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatStrUtilsLibrary.__StuffString(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := StrUtils.StuffString(GetInputArg(0),VarToInteger(GetInputArg(1)),VarToInteger(GetInputArg(2)),GetInputArg(3));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatStrUtilsLibrary.__IfThen(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
case InputArgCount of
2: AResult := StrUtils.IfThen(GetInputArg(0),GetInputArg(1));
3: AResult := StrUtils.IfThen(GetInputArg(0),GetInputArg(1),GetInputArg(2));
end;
    ReturnOutputArg(AResult);
  end;
end;

procedure TatStrUtilsLibrary.__LeftStr(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := StrUtils.LeftStr(GetInputArg(0),VarToInteger(GetInputArg(1)));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatStrUtilsLibrary.__RightStr(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := StrUtils.RightStr(GetInputArg(0),VarToInteger(GetInputArg(1)));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatStrUtilsLibrary.__MidStr(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := StrUtils.MidStr(GetInputArg(0),VarToInteger(GetInputArg(1)),VarToInteger(GetInputArg(2)));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatStrUtilsLibrary.__SearchBuf(AMachine: TatVirtualMachine);
  var
  Param5: TStringSearchOptions;
  AResult: variant;
begin
  with AMachine do
  begin
IntToSet(Param5, VarToInteger(GetInputArg(5)), SizeOf(Param5));
case InputArgCount of
5: AResult := string(StrUtils.SearchBuf(PChar(VarToStr(GetInputArg(0))),VarToInteger(GetInputArg(1)),VarToInteger(GetInputArg(2)),VarToInteger(GetInputArg(3)),GetInputArg(4)));
6: AResult := string(StrUtils.SearchBuf(PChar(VarToStr(GetInputArg(0))),VarToInteger(GetInputArg(1)),VarToInteger(GetInputArg(2)),VarToInteger(GetInputArg(3)),GetInputArg(4),Param5));
end;
    ReturnOutputArg(AResult);
  end;
end;

procedure TatStrUtilsLibrary.__Soundex(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
case InputArgCount of
1: AResult := StrUtils.Soundex(GetInputArg(0));
2: AResult := StrUtils.Soundex(GetInputArg(0),GetInputArg(1));
end;
    ReturnOutputArg(AResult);
  end;
end;

procedure TatStrUtilsLibrary.__SoundexInt(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
case InputArgCount of
1: AResult := Integer(StrUtils.SoundexInt(GetInputArg(0)));
2: AResult := Integer(StrUtils.SoundexInt(GetInputArg(0),GetInputArg(1)));
end;
    ReturnOutputArg(AResult);
  end;
end;

procedure TatStrUtilsLibrary.__DecodeSoundexInt(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := StrUtils.DecodeSoundexInt(VarToInteger(GetInputArg(0)));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatStrUtilsLibrary.__SoundexWord(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Integer(StrUtils.SoundexWord(GetInputArg(0)));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatStrUtilsLibrary.__DecodeSoundexWord(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := StrUtils.DecodeSoundexWord(VarToInteger(GetInputArg(0)));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatStrUtilsLibrary.__SoundexSimilar(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
case InputArgCount of
2: AResult := StrUtils.SoundexSimilar(GetInputArg(0),GetInputArg(1));
3: AResult := StrUtils.SoundexSimilar(GetInputArg(0),GetInputArg(1),GetInputArg(2));
end;
    ReturnOutputArg(AResult);
  end;
end;

procedure TatStrUtilsLibrary.__SoundexCompare(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
case InputArgCount of
2: AResult := Integer(StrUtils.SoundexCompare(GetInputArg(0),GetInputArg(1)));
3: AResult := Integer(StrUtils.SoundexCompare(GetInputArg(0),GetInputArg(1),GetInputArg(2)));
end;
    ReturnOutputArg(AResult);
  end;
end;

procedure TatStrUtilsLibrary.__SoundexProc(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := StrUtils.SoundexProc(GetInputArg(0),GetInputArg(1));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatStrUtilsLibrary.__GetWordDelimiters(AMachine: TatVirtualMachine);
var
PropValueSet: set of Char;
begin
  with AMachine do
  begin
    PropValueSet := StrUtils.WordDelimiters;
    ReturnOutputArg(IntFromSet(PropValueSet, SizeOf(PropValueSet)));
  end;
end;

procedure TatStrUtilsLibrary.Init;
begin
  With Scripter.DefineClass(ClassType) do
  begin
    DefineMethod('AnsiResemblesText',2,tkVariant,nil,__AnsiResemblesText,false,0);
    DefineMethod('AnsiContainsText',2,tkVariant,nil,__AnsiContainsText,false,0);
    DefineMethod('AnsiStartsText',2,tkVariant,nil,__AnsiStartsText,false,0);
    DefineMethod('AnsiEndsText',2,tkVariant,nil,__AnsiEndsText,false,0);
    DefineMethod('AnsiReplaceText',3,tkVariant,nil,__AnsiReplaceText,false,0);
    DefineMethod('AnsiContainsStr',2,tkVariant,nil,__AnsiContainsStr,false,0);
    DefineMethod('AnsiStartsStr',2,tkVariant,nil,__AnsiStartsStr,false,0);
    DefineMethod('AnsiEndsStr',2,tkVariant,nil,__AnsiEndsStr,false,0);
    DefineMethod('AnsiReplaceStr',3,tkVariant,nil,__AnsiReplaceStr,false,0);
    DefineMethod('DupeString',2,tkVariant,nil,__DupeString,false,0);
    DefineMethod('ReverseString',1,tkVariant,nil,__ReverseString,false,0);
    DefineMethod('StuffString',4,tkVariant,nil,__StuffString,false,0);
    DefineMethod('IfThen',3,tkVariant,nil,__IfThen,false,1);
    DefineMethod('LeftStr',2,tkVariant,nil,__LeftStr,false,0);
    DefineMethod('RightStr',2,tkVariant,nil,__RightStr,false,0);
    DefineMethod('MidStr',3,tkVariant,nil,__MidStr,false,0);
    DefineMethod('SearchBuf',6,tkVariant,nil,__SearchBuf,false,1);
    DefineMethod('Soundex',2,tkVariant,nil,__Soundex,false,1);
    DefineMethod('SoundexInt',2,tkInteger,nil,__SoundexInt,false,1);
    DefineMethod('DecodeSoundexInt',1,tkVariant,nil,__DecodeSoundexInt,false,0);
    DefineMethod('SoundexWord',1,tkInteger,nil,__SoundexWord,false,0);
    DefineMethod('DecodeSoundexWord',1,tkVariant,nil,__DecodeSoundexWord,false,0);
    DefineMethod('SoundexSimilar',3,tkVariant,nil,__SoundexSimilar,false,1);
    DefineMethod('SoundexCompare',3,tkInteger,nil,__SoundexCompare,false,1);
    DefineMethod('SoundexProc',2,tkVariant,nil,__SoundexProc,false,0);
    DefineProp('WordDelimiters',tkInteger,__GetWordDelimiters,nil,nil,false,0);
    AddConstant('soDown',soDown);
    AddConstant('soMatchCase',soMatchCase);
    AddConstant('soWholeWord',soWholeWord);
  end;
end;

class function TatStrUtilsLibrary.LibraryName: string;
begin
  result := 'StrUtils';
end;

initialization
  RegisterScripterLibrary(TatStrUtilsLibrary, True);

{$WARNINGS ON}

end.

