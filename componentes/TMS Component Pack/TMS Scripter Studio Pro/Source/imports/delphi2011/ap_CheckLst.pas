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
unit ap_CheckLst;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  StdCtrls,
  CheckLst,
  Variants,
  atScript;

{$WARNINGS OFF}

type
  TatCheckLstLibrary = class(TatScripterLibrary)
    procedure __TCheckListBoxCreate(AMachine: TatVirtualMachine);
    procedure __TCheckListBoxDestroy(AMachine: TatVirtualMachine);
    procedure __TCheckListBoxCheckAll(AMachine: TatVirtualMachine);
    procedure __GetTCheckListBoxChecked(AMachine: TatVirtualMachine);
    procedure __SetTCheckListBoxChecked(AMachine: TatVirtualMachine);
    procedure __GetTCheckListBoxItemEnabled(AMachine: TatVirtualMachine);
    procedure __SetTCheckListBoxItemEnabled(AMachine: TatVirtualMachine);
    procedure __GetTCheckListBoxState(AMachine: TatVirtualMachine);
    procedure __SetTCheckListBoxState(AMachine: TatVirtualMachine);
    procedure __GetTCheckListBoxHeader(AMachine: TatVirtualMachine);
    procedure __SetTCheckListBoxHeader(AMachine: TatVirtualMachine);
    procedure Init; override;
    class function LibraryName: string; override;
  end;

  TCheckListBoxClass = class of TCheckListBox;



implementation



procedure TatCheckLstLibrary.__TCheckListBoxCreate(AMachine: TatVirtualMachine);
  var
  AResult: variant;
begin
  with AMachine do
  begin
AResult := Integer(TCheckListBoxClass(CurrentClass.ClassRef).Create(TComponent(Integer(GetInputArg(0)))));
    ReturnOutputArg(AResult);
  end;
end;

procedure TatCheckLstLibrary.__TCheckListBoxDestroy(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TCheckListBox(CurrentObject).Destroy;
  end;
end;

procedure TatCheckLstLibrary.__TCheckListBoxCheckAll(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    Case InputArgCount of
      1: TCheckListBox(CurrentObject).CheckAll(GetInputArg(0));
      2: TCheckListBox(CurrentObject).CheckAll(GetInputArg(0),GetInputArg(1));
      3: TCheckListBox(CurrentObject).CheckAll(GetInputArg(0),GetInputArg(1),GetInputArg(2));
    end;
  end;
end;

procedure TatCheckLstLibrary.__GetTCheckListBoxChecked(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(TCheckListBox(CurrentObject).Checked[VarToInteger(GetArrayIndex(0))]);
  end;
end;

procedure TatCheckLstLibrary.__SetTCheckListBoxChecked(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TCheckListBox(CurrentObject).Checked[VarToInteger(GetArrayIndex(0))]:=GetInputArg(0);
  end;
end;

procedure TatCheckLstLibrary.__GetTCheckListBoxItemEnabled(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(TCheckListBox(CurrentObject).ItemEnabled[VarToInteger(GetArrayIndex(0))]);
  end;
end;

procedure TatCheckLstLibrary.__SetTCheckListBoxItemEnabled(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TCheckListBox(CurrentObject).ItemEnabled[VarToInteger(GetArrayIndex(0))]:=GetInputArg(0);
  end;
end;

procedure TatCheckLstLibrary.__GetTCheckListBoxState(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(TCheckListBox(CurrentObject).State[VarToInteger(GetArrayIndex(0))]);
  end;
end;

procedure TatCheckLstLibrary.__SetTCheckListBoxState(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TCheckListBox(CurrentObject).State[VarToInteger(GetArrayIndex(0))]:=GetInputArg(0);
  end;
end;

procedure TatCheckLstLibrary.__GetTCheckListBoxHeader(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    ReturnOutputArg(TCheckListBox(CurrentObject).Header[VarToInteger(GetArrayIndex(0))]);
  end;
end;

procedure TatCheckLstLibrary.__SetTCheckListBoxHeader(AMachine: TatVirtualMachine);
begin
  with AMachine do
  begin
    TCheckListBox(CurrentObject).Header[VarToInteger(GetArrayIndex(0))]:=GetInputArg(0);
  end;
end;

procedure TatCheckLstLibrary.Init;
begin
  With Scripter.DefineClass(TCheckListBox) do
  begin
    DefineMethod('Create',1,tkClass,TCheckListBox,__TCheckListBoxCreate,true,0);
    DefineMethod('Destroy',0,tkNone,nil,__TCheckListBoxDestroy,false,0);
    DefineMethod('CheckAll',3,tkNone,nil,__TCheckListBoxCheckAll,false,2);
    DefineProp('Checked',tkVariant,__GetTCheckListBoxChecked,__SetTCheckListBoxChecked,nil,false,1);
    DefineProp('ItemEnabled',tkVariant,__GetTCheckListBoxItemEnabled,__SetTCheckListBoxItemEnabled,nil,false,1);
    DefineProp('State',tkEnumeration,__GetTCheckListBoxState,__SetTCheckListBoxState,nil,false,1);
    DefineProp('Header',tkVariant,__GetTCheckListBoxHeader,__SetTCheckListBoxHeader,nil,false,1);
  end;
  With Scripter.DefineClass(ClassType) do
  begin
  end;
end;

class function TatCheckLstLibrary.LibraryName: string;
begin
  result := 'CheckLst';
end;

initialization
  RegisterScripterLibrary(TatCheckLstLibrary, True);

{$WARNINGS ON}

end.

