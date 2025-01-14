{*******************************************************************}
{                                                                   }
{       Developer Express Visual Component Library                  }
{       ExpressPrinting System COMPONENT SUITE                      }
{                                                                   }
{       Copyright (C) 1998-2010 Developer Express Inc.              }
{       ALL RIGHTS RESERVED                                         }
{                                                                   }
{   The entire contents of this file is protected by U.S. and       }
{   International Copyright Laws. Unauthorized reproduction,        }
{   reverse-engineering, and distribution of all or any portion of  }
{   the code contained in this file is strictly prohibited and may  }
{   result in severe civil and criminal penalties and will be       }
{   prosecuted to the maximum extent possible under the law.        }
{                                                                   }
{   RESTRICTIONS                                                    }
{                                                                   }
{   THIS SOURCE CODE AND ALL RESULTING INTERMEDIATE FILES           }
{   (DCU, OBJ, DLL, ETC.) ARE CONFIDENTIAL AND PROPRIETARY TRADE    }
{   SECRETS OF DEVELOPER EXPRESS INC. THE REGISTERED DEVELOPER IS   }
{   LICENSED TO DISTRIBUTE THE EXPRESSPRINTINGSYSTEM AND            }
{   ALL ACCOMPANYING VCL CONTROLS AS PART OF AN                     }
{   EXECUTABLE PROGRAM ONLY.                                        }
{                                                                   }
{   THE SOURCE CODE CONTAINED WITHIN THIS FILE AND ALL RELATED      }
{   FILES OR ANY PORTION OF ITS CONTENTS SHALL AT NO TIME BE        }
{   COPIED, TRANSFERRED, SOLD, DISTRIBUTED, OR OTHERWISE MADE       }
{   AVAILABLE TO OTHER INDIVIDUALS WITHOUT EXPRESS WRITTEN CONSENT  }
{   AND PERMISSION FROM DEVELOPER EXPRESS INC.                      }
{                                                                   }
{   CONSULT THE END USER LICENSE AGREEMENT FOR INFORMATION ON       }
{   ADDITIONAL RESTRICTIONS.                                        }
{                                                                   }
{*******************************************************************}

unit dxPSfmEditDesc;

interface

{$I cxVer.inc}

uses
  Windows, Messages, Classes, Controls, Forms, StdCtrls, dxPSForm,
  cxLookAndFeelPainters, cxControls, cxContainer, cxEdit, cxGroupBox,
  Menus, cxButtons, cxTextEdit, cxMemo, cxGraphics, cxLookAndFeels;

type
  TdxfmEditDescription = class(TCustomdxPSForm)
    btnCancel: TcxButton;
    btnHelp: TcxButton;
    btnOK: TcxButton;
    gbxMemoHost: TcxGroupBox;
    memDescription: TcxMemo;
    procedure FormResize(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    function GetDescription: string;
    procedure SetDescription(const Value: string);
    procedure WMGetMinMaxInfo(var Message: TWMGetMinMaxInfo); message WM_GETMINMAXINFO;    
  protected
    procedure BeforeConstruction; override;
    procedure Initialize;
    procedure LoadStrings;
  public
    constructor Create(AOwner: TComponent); override;
    function Execute: Boolean;
    property Description: string read GetDescription write SetDescription;
  end;
    
function dxEditDescriptionDlg(var ADescription: string): Boolean;

implementation

{$R *.DFM}

uses
  Types, cxClasses, dxPSRes, dxPSUtl, dxPSGlbl;
  
function dxEditDescriptionDlg(var ADescription: string): Boolean;
var 
  Dialog: TdxfmEditDescription;
begin
  Dialog := TdxfmEditDescription.Create(nil);
  try
    Dialog.Description := ADescription;
    Result := Dialog.Execute;
    if Result then 
      ADescription := Dialog.Description;
  finally
    Dialog.Free;
  end;
end;

{ TdxfmEditDescription }

constructor TdxfmEditDescription.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  HelpContext := dxhcEditDescriptionDlg;
end;

function TdxfmEditDescription.Execute: Boolean;
begin
  Initialize;
  Result := ShowModal = mrOK;
end;

procedure TdxfmEditDescription.FormResize(Sender: TObject);
const
  BtnOffsetX = 6;
  BtnOffsetY = 12;
var
  RightOrigin, TopOrigin: Integer;
begin
  with gbxMemoHost do
    SetBounds(Left, Top, Self.ClientWidth - 2 * Left,
      Self.ClientHeight - Top - btnOK.Height - 2 * BtnOffsetY);

  RightOrigin := gbxMemoHost.Left + gbxMemoHost.Width;
  TopOrigin := gbxMemoHost.Top + gbxMemoHost.Height + BtnOffsetY;

  PlaceButtons([btnHelp, btnCancel, btnOK], BtnOffsetX, RightOrigin, TopOrigin);
end;

procedure TdxfmEditDescription.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_ESCAPE) and cxShiftStateMoveOnly(Shift) and (ActiveControl is TCustomMemo) then
    ModalResult := mrCancel;
end;

procedure TdxfmEditDescription.BeforeConstruction;
begin
  inherited BeforeConstruction;
  Options := Options + [foSizeableDialog];
end;

procedure TdxfmEditDescription.Initialize;
begin
  btnHelp.Visible := HelpContext <> 0;
  if HelpContext <> 0 then 
    BorderIcons := BorderIcons + [biHelp];
  
  if not btnHelp.Visible then
  begin
    btnOK.BoundsRect := btnCancel.BoundsRect;
    btnCancel.BoundsRect := btnHelp.BoundsRect;    
  end;  
  LoadStrings;
  FormResize(nil);
end;

procedure TdxfmEditDescription.LoadStrings;
begin
  Caption := cxGetResourceString(@sdxEditDescription);
  btnOK.Caption := cxGetResourceString(@sdxBtnOKAccelerated);
  btnCancel.Caption := cxGetResourceString(@sdxBtnCancel);
  btnHelp.Caption := cxGetResourceString(@sdxBtnHelp);
end;

function TdxfmEditDescription.GetDescription: string;
begin
  Result := memDescription.Lines.Text;
end;

procedure TdxfmEditDescription.SetDescription(const Value: string);
begin
  memDescription.Lines.Text := Value;
end;
                                                                            
procedure TdxfmEditDescription.WMGetMinMaxInfo(var Message: TWMGetMinMaxInfo);
begin
  inherited;
  Message.MinMaxInfo^.ptMinTrackSize := Point(300, 300);
end;

end.

