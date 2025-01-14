{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2004 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo:    Alexandre Rocha Lima e Marcondes             }
{                                                                              }
{  Voc� pode obter a �ltima vers�o desse arquivo na pagina do  Projeto ACBr    }
{ Componentes localizado em      http://www.sourceforge.net/projects/acbr      }
{                                                                              }
{ Esse arquivo usa a classe  SynaSer   Copyright (c)2001-2003, Lukas Gebauer   }
{  Project : Ararat Synapse     (Found at URL: http://www.ararat.cz/synapse/)  }
{                                                                              }
{  Esta biblioteca � software livre; voc� pode redistribu�-la e/ou modific�-la }
{ sob os termos da Licen�a P�blica Geral Menor do GNU conforme publicada pela  }
{ Free Software Foundation; tanto a vers�o 2.1 da Licen�a, ou (a seu crit�rio) }
{ qualquer vers�o posterior.                                                   }
{                                                                              }
{  Esta biblioteca � distribu�da na expectativa de que seja �til, por�m, SEM   }
{ NENHUMA GARANTIA; nem mesmo a garantia impl�cita de COMERCIABILIDADE OU      }
{ ADEQUA��O A UMA FINALIDADE ESPEC�FICA. Consulte a Licen�a P�blica Geral Menor}
{ do GNU para mais detalhes. (Arquivo LICEN�A.TXT ou LICENSE.TXT)              }
{                                                                              }
{  Voc� deve ter recebido uma c�pia da Licen�a P�blica Geral Menor do GNU junto}
{ com esta biblioteca; se n�o, escreva para a Free Software Foundation, Inc.,  }
{ no endere�o 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.          }
{ Voc� tamb�m pode obter uma copia da licen�a em:                              }
{ http://www.opensource.org/licenses/lgpl-license.php                          }
{                                                                              }
{ Daniel Sim�es de Almeida  -  daniel@djsystem.com.br  -  www.djsystem.com.br  }
{              Pra�a Anita Costa, 34 - Tatu� - SP - 18270-410                  }
{                                                                              }
{******************************************************************************}

{$I ACBr.inc}

Unit ACBrReg ;

interface
uses Classes, SysUtils, ACBrConsts, ACBrBase,
    {$IFDEF FPC}
        LResources, LazarusPackageIntf, PropEdits, componenteditors
     {$ELSE}
		{$IFDEF DELPHI9_UP}ToolsApi, Windows, Graphics,{$ENDIF}
        {$IFNDEF COMPILER6_UP}
           DsgnIntf
        {$ELSE}
           DesignIntf,
           DesignEditors
        {$ENDIF}
     {$ENDIF} ;

type

{ Editor de Proriedades de Componente para mostrar o AboutACBr }
TACBrAboutDialogProperty = class(TPropertyEditor)
public
  procedure Edit; override;
  function GetAttributes: TPropertyAttributes; override;
  function GetValue: string; override;
end;

procedure Register ;

{$IFDEF  DELPHI9_UP}
	{$R ACBrComum.res}
{$ENDIF}
implementation

Uses ACBrUtil, ACBrEAD, ACBrAAC ;
{$IFNDEF FPC}
   {$R ACBrComum.dcr}
{$ENDIF}

{$IFDEF  RTL170_UP}
var
  AboutBoxServices: IOTAAboutBoxServices = nil;
  AboutBoxIndex: Integer = 0;

procedure RegisterAboutBox;
var
  ProductImage: HBITMAP;
begin
  Supports(BorlandIDEServices,IOTAAboutBoxServices, AboutBoxServices);
  Assert(Assigned(AboutBoxServices), '');
  ProductImage := LoadBitmap(FindResourceHInstance(HInstance), 'ACBR');
  AboutBoxIndex := AboutBoxServices.AddPluginInfo(cACBrSobreTitulo , cACBrSobreDescricao,
    ProductImage, False, cACBrSobreLicencaStatus);
end;

procedure UnregisterAboutBox;
begin
  if (AboutBoxIndex <> 0) and Assigned(AboutBoxServices) then
  begin
    AboutBoxServices.RemovePluginInfo(AboutBoxIndex);
    AboutBoxIndex := 0;
    AboutBoxServices := nil;
  end;
end;

procedure AddSplash;
var
  bmp: TBitmap;
begin
  bmp := TBitmap.Create;
  bmp.LoadFromResourceName(HInstance, 'ACBR');
  SplashScreenServices.AddPluginBitmap(cACBrSobreDialogoTitulo,bmp.Handle,false,cACBrSobreLicencaStatus,'');
  bmp.Free;
end;
{$ENDIF}

procedure Register;
begin
  RegisterComponents('ACBr', [TACBrEAD, TACBrAAC]);

  RegisterPropertyEditor(TypeInfo(TACBrAboutInfo), nil, 'AboutACBr',
     TACBrAboutDialogProperty);
end;

{ TACBrAboutDialogProperty }
procedure TACBrAboutDialogProperty.Edit;
begin
  ACBrAboutDialog ;
end;

function TACBrAboutDialogProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog, paReadOnly];
end;

function TACBrAboutDialogProperty.GetValue: string;
begin
  Result := 'http://acbr.sf.net' ;  
end;

{$IFDEF RTL170_UP}
initialization
	AddSplash;
	RegisterAboutBox;
	
finalization
	UnregisterAboutBox;
{$ENDIF}

{$IFDEF FPC}
initialization
   {$I ACBrComum.lrs}
{$ENDIF}

end.

