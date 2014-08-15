{***************************************************************************}
{ Scripter Studio demo                                                      }
{ for Delphi & C++Builder                                                   }
{ version 2.0                                                               }
{                                                                           }
{ written by Automa / TMS Software                                          }
{            copyright � 1997 - 2002                                        }
{            Email : info@tmssoftware.com                                   }
{            Web : http://www.tmssoftware.com                               }
{                                                                           }
{ The source code is given as is. The author is not responsible             }
{ for any possible damage done due to the use of this code.                 }
{ The component can be freely used in any application. The complete         }
{ source code remains property of the author and may not be distributed,    }
{ published, given or sold in any form as such. No parts of the source      }
{ code can be included in any other component or application without        }
{ written authorization of TMS software.                                    }
{***************************************************************************}

unit fMain;

interface

{$I Ascript.inc}

uses
  Windows, Messages, SysUtils,
  {$IFDEF DELPHI6_LVL}Variants,{$ENDIF}
  Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, atScript, comobj, FormScript, Mask, DBCtrls, ExtCtrls,
  DB, DBTables, Grids, DBGrids, atPascal, AdvMemo, Advmps;

type
  TForm1 = class(TForm)
    Button1: TButton;
    DataSource1: TDataSource;
    Table1: TTable;
    DBNavigator1: TDBNavigator;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    DBEdit3: TDBEdit;
    DBEdit4: TDBEdit;
    DBEdit5: TDBEdit;
    DBEdit6: TDBEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    ShowWord: TCheckBox;
    atPascalFormScripter1: TatPascalFormScripter;
    AdvMemo1: TAdvMemo;
    AdvPascalMemoStyler1: TAdvPascalMemoStyler;
    procedure Button1Click(Sender: TObject);
    procedure StAdd;
    procedure StGetValue;
    procedure StGetCurrentDir;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

const
  wdGotoBookmark = -1;

procedure TForm1.Button1Click(Sender: TObject);
begin
  with atPascalFormScripter1.AddDelphiClass(TStrings) do
    AddMethod('Add',1,tkNone,nil,StAdd);

  with atPascalFormScripter1.AddDelphiClass(TDBEdit) do
    AddMethod('GetValue',0,tkString,nil,StGetValue);

  atPascalFormScripter1.SystemLibrary.AddMethod('GetCurrentDir',0,tkString,nil,stGetCurrentDir);
  atPascalFormScripter1.SystemLibrary.AddConstant('wdGotoBookMark',wdGotoBookmark);

  atPascalFormscripter1.SourceCode.Assign(AdvMemo1.Lines);
  atPascalFormscripter1.Execute(null);
end;

procedure TForm1.StAdd;
begin
  TStrings(atPascalFormScripter1.CurrentObject).Add(atPascalFormScripter1.GetInputArgAsString(0));
end;

procedure TForm1.StGetCurrentDir;
begin
  atPascalFormScripter1.ReturnOutputArg(GetCurrentDir);
end;

procedure TForm1.StGetValue;
begin
  atPascalFormScripter1.ReturnOutputArg(TDBEdit(atPascalFormScripter1.CurrentObject).EditText);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
   Table1.Open;
end;

end.