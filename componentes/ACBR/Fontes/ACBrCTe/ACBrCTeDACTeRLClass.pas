{******************************************************************************}
{ Projeto: Componente ACBrCTe                                                  }
{  Biblioteca multiplataforma de componentes Delphi para emiss�o de Conhecimen-}
{ to de Transporte eletr�nico - CTe - http://www.cte.fazenda.gov.br            }
{                                                                              }
{ Direitos Autorais Reservados (c) 2014 Mark dos Santos Gon�alves              }
{                                        Juliomar Marchetti                    }
{                                       Daniel Simoes de Almeida               }
{                                       Andr� Ferreira de Moraes               }
{                                                                              }
{ Colaboradores nesse arquivo:                                                 }
{                                                                              }
{  Voc� pode obter a �ltima vers�o desse arquivo na pagina do Projeto ACBr     }
{ Componentes localizado em http://www.sourceforge.net/projects/acbr           }
{                                                                              }
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

{******************************************************************************
|* Historico
|*
******************************************************************************}

{$I ACBr.inc}

unit ACBrCTeDACTeRLClass;

interface

{$H+}

uses
  Forms, SysUtils, Classes,
  pcnConversao, pcteCTe, ACBrCTeDACTeClass,RLTypes ,
  ACBrCTeDACTeRL, ACBrCTeDACTeRLRetrato, ACBrCTeDACTeRLRetratoA5,
  ACBrCTeDAEventoRL, ACBrCTeDAEventoRLRetrato;

type
  TACBrCTeDACTeRL = class(TACBrCTeDACTeClass)
  private
    FPosRecibo: TPosRecibo;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ImprimirDACTe(CTe: TCTe = nil); override;
    procedure ImprimirDACTePDF(CTe: TCTe = nil); override;
    procedure ImprimirEVENTO(CTe: TCTe = nil); override;
    procedure ImprimirEVENTOPDF(CTe: TCTe = nil); override;
  published
    property PosRecibo: TPosRecibo read FPosRecibo write FPosRecibo default prCabecalho;
  end;

implementation

uses
  StrUtils, Dialogs, ACBrUtil, ACBrCTe, ACBrCteUtil;

var
  frmCTeDAEventoRL: TfrmCTeDAEventoRL;

constructor TACBrCTeDACTeRL.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TACBrCTeDACTeRL.Destroy;
begin
  inherited Destroy;
end;

procedure TACBrCTeDACTeRL.ImprimirDACTe(CTe: TCTe = nil);
var
  i: integer;
  sProt: string;

  frmDACTeRLRetrato: TfrmDACTeRL;
begin
  case TamanhoPapel of
    tpA5:
    begin
      frmDACTeRLRetrato := TfrmDACTeRLRetratoA5.Create(Self);
      frmDACTeRLRetrato.RLCTe.PageSetup.PaperSize := fpA5;
      frmDACTeRLRetrato.RLCTe.PageSetup.PaperHeight := 148.0;
      frmDACTeRLRetrato.RLCTe.PageSetup.PaperWidth := 210.0;
    end;
    else
    begin // tpA4
      frmDACTeRLRetrato := TfrmDACTeRLRetrato.Create(Self);
      frmDACTeRLRetrato.RLCTe.PageSetup.PaperSize := fpA4;
      frmDACTeRLRetrato.RLCTe.PageSetup.PaperHeight := 297.0;
      frmDACTeRLRetrato.RLCTe.PageSetup.PaperWidth := 210.0;
    end;
  end;

  sProt := TACBrCTe(ACBrCTe).DACTe.ProtocoloCTe;

  if CTe = nil then
  begin
    for i := 0 to TACBrCTe(ACBrCTe).Conhecimentos.Count - 1 do
      frmDACTeRLRetrato.Imprimir(TACBrCTe(ACBrCTe).Conhecimentos.Items[i].CTe
        , Logo
        , Email
        , ImprimirHoraSaida
        , ExpandirLogoMarca
        , ImprimirHoraSaida_Hora
        , ResumoCanhoto
        , Fax
        , NumCopias
        , Sistema
        , Site
        , Usuario
        , MostrarPreview
        , MargemSuperior
        , MargemInferior
        , MargemEsquerda
        , MargemDireita
        , Impressora
        , PosRecibo
        , CTeCancelada
        , EPECEnviado);
  end
  else
    frmDACTeRLRetrato.Imprimir(CTe
      , Logo
      , Email
      , ImprimirHoraSaida
      , ExpandirLogoMarca
      , ImprimirHoraSaida_Hora
      , ResumoCanhoto
      , Fax
      , NumCopias
      , Sistema
      , Site
      , Usuario
      , MostrarPreview
      , MargemSuperior
      , MargemInferior
      , MargemEsquerda
      , MargemDireita
      , Impressora
      , PosRecibo
      , CTeCancelada
      , EPECEnviado);

  if frmDACTeRLRetrato.RLCTe <> nil then
    frmDACTeRLRetrato.Free;
end;

procedure TACBrCTeDACTeRL.ImprimirDACTePDF(CTe: TCTe = nil);
var
  i: integer;
  sProt: string;
  NomeArq: string;

  frmDACTeRLRetrato: TfrmDACTeRL;
begin
  case TamanhoPapel of
    tpA5:
    begin
      frmDACTeRLRetrato := TfrmDACTeRLRetratoA5.Create(Self);
      frmDACTeRLRetrato.RLCTe.PageSetup.PaperSize := fpA5;
      frmDACTeRLRetrato.RLCTe.PageSetup.PaperHeight := 148.0;
      frmDACTeRLRetrato.RLCTe.PageSetup.PaperWidth := 210.0;
    end;
    else
    begin // tpA4
      frmDACTeRLRetrato := TfrmDACTeRLRetrato.Create(Self);
      frmDACTeRLRetrato.RLCTe.PageSetup.PaperSize := fpA4;
      frmDACTeRLRetrato.RLCTe.PageSetup.PaperHeight := 297.0;
      frmDACTeRLRetrato.RLCTe.PageSetup.PaperWidth := 210.0;
    end;
  end;

  sProt := TACBrCTe(ACBrCTe).DACTe.ProtocoloCTe;

  if CTe = nil then
  begin
    for i := 0 to TACBrCTe(ACBrCTe).Conhecimentos.Count - 1 do
    begin
      NomeArq := StringReplace(TACBrCTe(ACBrCTe).Conhecimentos.Items[i].CTe.infCTe.ID, 'CTe', '', [rfIgnoreCase]);
      NomeArq := PathWithDelim(Self.PathPDF) + NomeArq + '-cte.pdf';

      frmDACTeRLRetrato.SavePDF(NomeArq
        , TACBrCTe(ACBrCTe).Conhecimentos.Items[i].CTe
        , Logo
        , Email
        , ImprimirHoraSaida
        , ExpandirLogoMarca
        , ImprimirHoraSaida_Hora
        , ResumoCanhoto
        , Fax
        , NumCopias
        , Sistema
        , Site
        , Usuario
        , MargemSuperior
        , MargemInferior
        , MargemEsquerda
        , MargemDireita
        , PosRecibo
        , CTeCancelada
        , EPECEnviado);
    end;
  end
  else
  begin
    NomeArq := StringReplace(CTe.infCTe.ID, 'CTe', '', [rfIgnoreCase]);
    NomeArq := PathWithDelim(Self.PathPDF) + NomeArq + '-cte.pdf';
    frmDACTeRLRetrato.SavePDF(NomeArq
      , CTe
      , Logo
      , Email
      , ImprimirHoraSaida
      , ExpandirLogoMarca
      , ImprimirHoraSaida_Hora
      , ResumoCanhoto
      , Fax
      , NumCopias
      , Sistema
      , Site
      , Usuario
      , MargemSuperior
      , MargemInferior
      , MargemEsquerda
      , MargemDireita
      , PosRecibo
      , CTeCancelada
      , EPECEnviado);
  end;

  if frmDACTeRLRetrato.RLCTe <> nil then
    frmDACTeRLRetrato.Free;
end;

procedure TACBrCTeDACTeRL.ImprimirEVENTO(CTe: TCTe);
var
  i, j: integer;
  Impresso: boolean;
begin
  frmCTeDAEventoRL := TfrmCTeDAEventoRLRetrato.Create(Self);

  if TACBrCTe(ACBrCTe).Conhecimentos.Count > 0 then
  begin
    for i := 0 to (TACBrCTe(ACBrCTe).EventoCTe.Evento.Count - 1) do
    begin
      Impresso := False;
      for j := 0 to (TACBrCTe(ACBrCTe).Conhecimentos.Count - 1) do
      begin
//        if Copy(TACBrCTe(ACBrCTe).Conhecimentos.Items[j].CTe.infCTe.ID, 4, 44) = TACBrCTe(ACBrCTe).EventoCTe.Evento.Items[i].InfEvento.chCTe then
        if StringReplace(TACBrCTe(ACBrCTe).Conhecimentos.Items[j].CTe.infCTe.Id, 'CTe', '', [rfIgnoreCase]) = TACBrCTe(ACBrCTe).EventoCTe.Evento.Items[i].InfEvento.chCTe then
        begin
          frmCTeDAEventoRL.Imprimir(TACBrCTe(ACBrCTe).EventoCTe.Evento.Items[i],
            FLogo,
            FNumCopias,
            FSistema,
            FUsuario,
            FMostrarPreview,
            FMargemSuperior,
            FMargemInferior,
            FMargemEsquerda,
            FMargemDireita,
            FImpressora,
            TACBrCTe(ACBrCTe).Conhecimentos.Items[j].CTe);
          Impresso := True;
          Break;
        end;
      end;

      if Impresso = False then
      begin
        frmCTeDAEventoRL.Imprimir(TACBrCTe(ACBrCTe).EventoCTe.Evento.Items[i],
          FLogo,
          FNumCopias,
          FSistema,
          FUsuario,
          FMostrarPreview,
          FMargemSuperior,
          FMargemInferior,
          FMargemEsquerda,
          FMargemDireita,
          FImpressora);
      end;
    end;
  end
  else
  begin
    for i := 0 to (TACBrCTe(ACBrCTe).EventoCTe.Evento.Count - 1) do
    begin
      frmCTeDAEventoRL.Imprimir(TACBrCTe(ACBrCTe).EventoCTe.Evento.Items[i],
        FLogo,
        FNumCopias,
        FSistema,
        FUsuario,
        FMostrarPreview,
        FMargemSuperior,
        FMargemInferior,
        FMargemEsquerda,
        FMargemDireita,
        FImpressora);
    end;
  end;

  FreeAndNil(frmCTeDAEventoRL);
end;

procedure TACBrCTeDACTeRL.ImprimirEVENTOPDF(CTe: TCTe);
var
  i, j: integer;
  sFile: string;
  Impresso: boolean;
begin
  frmCTeDAEventoRL := TfrmCTeDAEventoRLRetrato.Create(Self);

  if TACBrCTe(ACBrCTe).Conhecimentos.Count > 0 then
  begin
    for i := 0 to (TACBrCTe(ACBrCTe).EventoCTe.Evento.Count - 1) do
    begin
      sFile := TACBrCTe(ACBrCTe).DACTE.PathPDF +
               StringReplace(TACBrCTe(ACBrCTe).EventoCTe.Evento.Items[i].InfEvento.id, 'ID', '', [rfIgnoreCase]) + 
			   '-procEventoCTe.pdf';
//        Copy(TACBrCTe(ACBrCTe).EventoCTe.Evento.Items[i].InfEvento.id, 09, 44) +
//        Copy(TACBrCTe(ACBrCTe).EventoCTe.Evento.Items[i].InfEvento.id, 03, 06) +
//        Copy(TACBrCTe(ACBrCTe).EventoCTe.Evento.Items[i].InfEvento.id, 53, 02) + 'evento.pdf';
      Impresso := False;

      for j := 0 to (TACBrCTe(ACBrCTe).Conhecimentos.Count - 1) do
      begin
//        if Copy(TACBrCTe(ACBrCTe).Conhecimentos.Items[j].CTe.infCTe.ID, 4, 44) = TACBrCTe(ACBrCTe).EventoCTe.Evento.Items[i].InfEvento.chCTe then
        if StringReplace(TACBrCTe(ACBrCTe).Conhecimentos.Items[j].CTe.infCTe.Id, 'CTe', '', [rfIgnoreCase]) = TACBrCTe(ACBrCTe).EventoCTe.Evento.Items[i].InfEvento.chCTe then
        begin
          frmCTeDAEventoRL.SavePDF(TACBrCTe(ACBrCTe).EventoCTe.Evento.Items[i],
            FLogo,
            sFile,
            FSistema,
            FUsuario,
            FMargemSuperior,
            FMargemInferior,
            FMargemEsquerda,
            FMargemDireita,
            TACBrCTe(ACBrCTe).Conhecimentos.Items[j].CTe);
          Impresso := True;
          Break;
        end;
      end;

      if Impresso = False then
      begin
        frmCTeDAEventoRL.SavePDF(TACBrCTe(ACBrCTe).EventoCTe.Evento.Items[i],
          FLogo,
          sFile,
          FSistema,
          FUsuario,
          FMargemSuperior,
          FMargemInferior,
          FMargemEsquerda,
          FMargemDireita);
      end;
    end;
  end
  else
  begin
    for i := 0 to (TACBrCTe(ACBrCTe).EventoCTe.Evento.Count - 1) do
    begin
      sFile := TACBrCTe(ACBrCTe).DACTE.PathPDF +
               StringReplace(TACBrCTe(ACBrCTe).EventoCTe.Evento.Items[i].InfEvento.id, 'ID', '', [rfIgnoreCase]) +
               '-procEventoCTe.pdf';
//        Copy(TACBrCTe(ACBrCTe).EventoCTe.Evento.Items[i].InfEvento.id, 09, 44) +
//        Copy(TACBrCTe(ACBrCTe).EventoCTe.Evento.Items[i].InfEvento.id, 03, 06) +
//        Copy(TACBrCTe(ACBrCTe).EventoCTe.Evento.Items[i].InfEvento.id, 53, 02) + 'evento.pdf';

      frmCTeDAEventoRL.SavePDF(TACBrCTe(ACBrCTe).EventoCTe.Evento.Items[i],
        FLogo,
        sFile,
        FSistema,
        FUsuario,
        FMargemSuperior,
        FMargemInferior,
        FMargemEsquerda,
        FMargemDireita);
    end;
  end;

  FreeAndNil(frmCTeDAEventoRL);
end;

end.
