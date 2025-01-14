{******************************************************************************}
{ Projeto: Componente ACBrCTe                                                  }
{  Biblioteca multiplataforma de componentes Delphi para emiss�o de Conhecimen-}
{ to de Transporte eletr�nico - CTe - http://www.cte.fazenda.gov.br            }
{                                                                              }
{ Direitos Autorais Reservados (c) 2008 Wemerson Souto                         }
{                                       Wiliam Zacarias da Silva Rosa          }
{                                       Daniel Simoes de Almeida               }
{                                       Andr� Ferreira de Moraes               }
{                                                                              }
{ Desenvolvimento                                                              }
{         de Cte: Wiliam Zacarias da Silva Rosa                                }
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
{ Wiliam Zacarias da Silva Rosa - wiliamzsr@motta.com.br                       }
{ Daniel Sim�es de Almeida  -  daniel@djsystem.com.br  -  www.djsystem.com.br  }
{              Pra�a Anita Costa, 34 - Tatu� - SP - 18270-410                  }
{                                                                              }
{******************************************************************************}

{*******************************************************************************
|* Historico
|*
|* 19/08/2009: Wiliam Rosa
|*  - Defini��o de classes para impress�o do DACTE
*******************************************************************************}

{$I ACBr.inc}

unit ACBrCTeDACTEClass;

interface

uses
  Forms, SysUtils, Classes,
  pcteCTE, pcnConversao;

type
  TACBrCTeDACTEClass = class(TComponent)
   private
    procedure SetCTE(const Value: TComponent);
    procedure ErroAbstract(NomeProcedure: String);
    function GetPathArquivos: String;
    procedure SetPathArquivos(const Value: String);
  protected
    FACBrCTE: TComponent;
    FLogo: String;
    FSistema: String;
    FUsuario: String;
    FPathArquivos: String;
    FImpressora: String;
    FImprimirHoraSaida: Boolean;
    FImprimirHoraSaida_Hora: String;
    FMostrarPreview: Boolean;
    FMostrarStatus: Boolean;
    FTipoDACTE: TpcnTipoImpressao;
    FTamanhoPapel: TpcnTamanhoPapel;
    FNumCopias: Integer;
    FExpandirLogoMarca: Boolean;
    FFax: String;
    FSite: String;
    FEmail: String;
    FImprimeDescPorc: Boolean;
	  FProtocoloCTE: String;
    FMargemInferior: Double;
    FMargemSuperior: Double;
    FMargemEsquerda: Double;
    FMargemDireita: Double;
    FCTeCancelada: Boolean;
    FResumoCanhoto: Boolean; //Rodrigo DSP 22/01/2014 10:43:44:
    FEPECEnviado: Boolean;

    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ImprimirDACTE(CTE: TCTE = nil); virtual;
    procedure ImprimirDACTEPDF(CTE: TCTE = nil); virtual;
    procedure ImprimirEVENTO(CTE: TCTe = nil); virtual;
    procedure ImprimirEVENTOPDF(CTE: TCTe = nil); virtual;
    procedure ImprimirINUTILIZACAO(CTE: TCTe = nil); virtual;
    procedure ImprimirINUTILIZACAOPDF(CTE: TCTe = nil); virtual;
  published
    property ACBrCTE: TComponent            read FACBrCTE                write SetCTE;
    property Logo: String                   read FLogo                   write FLogo;
    property Sistema: String                read FSistema                write FSistema;
    property Usuario: String                read FUsuario                write FUsuario;
    property PathPDF: String                read GetPathArquivos         write SetPathArquivos;
    property Impressora: String             read FImpressora             write FImpressora;
    property ImprimirHoraSaida: Boolean     read FImprimirHoraSaida      write FImprimirHoraSaida;
    property ImprimirHoraSaida_Hora: String read FImprimirHoraSaida_Hora write FImprimirHoraSaida_Hora;
    property MostrarPreview: Boolean        read FMostrarPreview         write FMostrarPreview;
    property MostrarStatus: Boolean         read FMostrarStatus          write FMostrarStatus;
    property TipoDACTE: TpcnTipoImpressao   read FTipoDACTE              write FTipoDACTE;
    property TamanhoPapel: TpcnTamanhoPapel read FTamanhoPapel           write FTamanhoPapel;
    property NumCopias: Integer             read FNumCopias              write FNumCopias;
    property Fax: String                    read FFax                    write FFax;
    property Site: String                   read FSite                   write FSite;
    property Email: String                  read FEmail                  write FEmail;
    property ImprimirDescPorc: Boolean      read FImprimeDescPorc        write FImprimeDescPorc;
    property ProtocoloCTE: String           read FProtocoloCTE           write FProtocoloCTE;
    property MargemInferior: Double         read FMargemInferior         write FMargemInferior;
    property MargemSuperior: Double         read FMargemSuperior         write FMargemSuperior;
    property MargemEsquerda: Double         read FMargemEsquerda         write FMargemEsquerda;
    property MargemDireita: Double          read FMargemDireita          write FMargemDireita;
    property ExpandirLogoMarca: Boolean     read FExpandirLogoMarca      write FExpandirLogoMarca default false;
    property CTeCancelada: Boolean          read FCTeCancelada           write FCTeCancelada;
    property ResumoCanhoto: Boolean         read FResumoCanhoto          write FResumoCanhoto; //Rodrigo DSP 22/01/2014 10:43:51:
    property EPECEnviado: Boolean           read FEPECEnviado            write FEPECEnviado;
  end;

implementation

uses
  ACBrCTE, ACBrCTeUtil, ACBrUtil, ACBrDFeUtil;

constructor TACBrCTeDACTEClass.Create(AOwner: TComponent);
begin
  inherited create(AOwner);

  FACBrCTE      := nil;
  FLogo         := '';
  FSistema      := '';
  FUsuario      := '';
  FPathArquivos := '';
  FImpressora   := '';

  FImprimirHoraSaida      := False;
  FImprimirHoraSaida_Hora := '';

  FMostrarPreview := True;
  FMostrarStatus  := True;
  FNumCopias      := 1;

  FFax   := '';
  FSite  := '';
  FEmail := '';

  FImprimeDescPorc := False;
  FProtocoloCTE    := '';

  FMargemInferior := 0.8;
  FMargemSuperior := 0.8;
  FMargemEsquerda := 0.6;
  FMargemDireita  := 0.51;
  FCTeCancelada   := False;

  FResumoCanhoto := False; // Rodrigo DSP 22/01/2014 10:43:37:
  FEPECEnviado   := False;
end;

destructor TACBrCTeDACTEClass.Destroy;
begin

  inherited Destroy;
end;

procedure TACBrCTeDACTEClass.ImprimirDACTE(CTE: TCTE = nil);
begin
  ErroAbstract('Imprimir');
end;

procedure TACBrCTeDACTEClass.ImprimirDACTEPDF(CTE: TCTE = nil);
begin
  ErroAbstract('ImprimirPDF');
end;

procedure TACBrCTeDACTEClass.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);

  if (Operation = opRemove) and (FACBrCTE <> nil) and (AComponent is TACBrCTE) then
     FACBrCTE := nil;
end;

procedure TACBrCTeDACTEClass.SetCTE(const Value: TComponent);
var
 OldValue: TACBrCTE;
begin
  if Value <> FACBrCTE then
  begin
     if Value <> nil then
        if not (Value is TACBrCTE) then
           raise Exception.Create('DACTE deve ser do tipo TACBrCTE');

     if Assigned(FACBrCTE) then
        FACBrCTE.RemoveFreeNotification(Self);

     OldValue := TACBrCTE(FACBrCTE);   // Usa outra variavel para evitar Loop Infinito
     FACBrCTE := Value;                // na remo��o da associa��o dos componentes

     if Assigned(OldValue) then
        if Assigned(OldValue.DACTE) then
           OldValue.DACTE := nil;

     if Value <> nil then
     begin
        Value.FreeNotification(self);
        TACBrCTE(Value).DACTE := self;
     end;
  end;
end;

procedure TACBrCTeDACTEClass.ErroAbstract(NomeProcedure: String);
begin
  raise Exception.Create(NomeProcedure);
end;

function TACBrCTeDACTEClass.GetPathArquivos: String;
begin
  if DFeUtil.EstaVazio(FPathArquivos) then
     if Assigned(FACBrCTe) then
        FPathArquivos := TACBrCTe(FACBrCTe).Configuracoes.Geral.PathSalvar;

  if DFeUtil.NaoEstaVazio(FPathArquivos) then
     if not DirectoryExists(FPathArquivos) then
        ForceDirectories(FPathArquivos);

  Result := PathWithDelim(FPathArquivos);
end;

procedure TACBrCTeDACTEClass.SetPathArquivos(const Value: String);
begin
  FPathArquivos := Value;
end;

procedure TACBrCTeDACTEClass.ImprimirEVENTO(CTE: TCTe);
begin
  ErroAbstract('Imprimir');
end;

procedure TACBrCTeDACTEClass.ImprimirEVENTOPDF(CTE: TCTe);
begin
  ErroAbstract('ImprimirPDF');
end;

procedure TACBrCTeDACTEClass.ImprimirINUTILIZACAO(CTE: TCTe);
begin
  ErroAbstract('Imprimir');
end;

procedure TACBrCTeDACTEClass.ImprimirINUTILIZACAOPDF(CTE: TCTe);
begin
  ErroAbstract('ImprimirPDF');
end;

end.
