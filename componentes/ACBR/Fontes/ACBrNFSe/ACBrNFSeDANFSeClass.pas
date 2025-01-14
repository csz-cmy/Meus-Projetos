{******************************************************************************}
{ Projeto: Componente ACBrNFSe                                                 }
{  Biblioteca multiplataforma de componentes Delphi                            }
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

{$I ACBr.inc}

unit ACBrNFSeDANFSeClass;

interface

uses
 Forms, SysUtils, Classes,
 pnfsNFSe, pnfsConversao;

type

 TACBrNFSeDANFSeClass = class( TComponent )
  private
    procedure SetNFSe(const Value: TComponent);
    procedure ErroAbstract( NomeProcedure: String );
    function GetPathArquivos: String;
    procedure SetPathArquivos(const Value: String);
  protected
    FACBrNFSe: TComponent;
    FLogo: String;
    FSistema: String;
    FUsuario: String;
    FPathArquivos: String;
    FImpressora: String;
    FMostrarPreview: Boolean;
    FMostrarStatus: Boolean;
    FNumCopias: Integer;
    FExpandirLogoMarca: Boolean;
    FFax : String;
    FSite: String;
    FEmail: String;
    FMargemInferior: Double;
    FMargemSuperior: Double;
    FMargemEsquerda: Double;
    FMargemDireita: Double;
    FPrestLogo: String;
    FPrefeitura: String;
    FRazaoSocial: String;
    FEndereco : String;
    FComplemento : String;
    FFone : String;
    FMunicipio : String;
    FOutrasInformacaoesImp : String;
    FInscMunicipal : String;
    FT_InscEstadual : String;
    FT_InscMunicipal : String;
    FT_Fone          : String;
    FT_Endereco      : String;
    FT_Complemento   : String;
    FT_Email         : String;
    FEMail_Prestador : String;
    FUF : String;
    FAtividade : String;
    FNFSeCancelada: boolean;
    FImprimeCanhoto: Boolean;

    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ImprimirDANFSe(NFSe: TNFSe = nil); virtual;
    procedure ImprimirDANFSePDF(NFSe: TNFSe = nil); virtual;
    procedure ImprimirDANFSeCampinas(NFSe : TNFSe = nil); virtual;
  published
    property ACBrNFSe: TComponent  read FACBrNFSe write SetNFSe;
    property Logo: String read FLogo write FLogo;
    property Sistema: String read FSistema write FSistema;
    property Usuario: String read FUsuario write FUsuario;
    property PathPDF: String read GetPathArquivos write FPathArquivos;
    property Impressora: String read FImpressora write FImpressora;
    property MostrarPreview: Boolean read FMostrarPreview write FMostrarPreview;
    property MostrarStatus: Boolean read FMostrarStatus write FMostrarStatus;
    property NumCopias: Integer read FNumCopias write FNumCopias;
    property ExpandirLogoMarca: Boolean read FExpandirLogoMarca write FExpandirLogoMarca default false;
    property Fax : String read FFax   write FFax;
    property Site: String read FSite  write FSite;
    property Email: String read FEmail write FEmail;
    property MargemInferior: Double read FMargemInferior write FMargemInferior;
    property MargemSuperior: Double read FMargemSuperior write FMargemSuperior;
    property MargemEsquerda: Double read FMargemEsquerda write FMargemEsquerda;
    property MargemDireita: Double read FMargemDireita write FMargemDireita;
    property PrestLogo: String read FPrestLogo write FPrestLogo;
    property Prefeitura: String read FPrefeitura write FPrefeitura;

    property RazaoSocial: String read FRazaoSocial write FRazaoSocial;
    property UF: String read FUF write FUF;
    property Endereco: String read FEndereco write FEndereco;
    property Complemento: String read FComplemento write FComplemento;
    property Fone: String read FFone write FFone;
    property Municipio: String read FMunicipio write FMunicipio;
    property OutrasInformacaoesImp: String read FOutrasInformacaoesImp write FOutrasInformacaoesImp;
    property InscMunicipal: String read FInscMunicipal write FInscMunicipal;
    property EMail_Prestador: String read FEMail_Prestador write FEMail_Prestador;

    property T_InscEstadual: String read FT_InscEstadual write FT_InscEstadual;
    property T_InscMunicipal: String read FT_InscMunicipal write FT_InscMunicipal;
    property T_Fone: String read FT_Fone write FT_Fone;

    property T_Endereco: String read FT_Endereco write FT_Endereco;
    property T_Complemento: String read FT_Complemento write FT_Complemento;
    property T_Email: String read FT_Email write FT_Email;

    property Atividade: String read FAtividade write FAtividade;
    property NFSeCancelada: Boolean read FNFSeCancelada write FNFSeCancelada;
    property ImprimeCanhoto: Boolean read FImprimeCanhoto write FImprimeCanhoto default False;
  end;

implementation

uses
 ACBrNFSe, ACBrNFSeUtil, ACBrUtil, ACBrDFeUtil;

{ TACBrNFSeDANFSeClass }

constructor TACBrNFSeDANFSeClass.Create(AOwner: TComponent);
begin
 inherited create( AOwner );

 FACBrNFSe       := nil;
 FLogo           := '';
 FSistema        := '';
 FUsuario        := '';
 FPathArquivos   := '';
 FImpressora     := '';
 FMostrarPreview := True;
 FMostrarStatus  := True;
 FNumCopias      := 1;
 FFax            := '';
 FSite           := '';
 FEmail          := '';
 FMargemInferior := 0.8;
 FMargemSuperior := 0.8;
 FMargemEsquerda := 0.6;
 FMargemDireita  := 0.51;
 FPrestLogo      := '';
 FPrefeitura     := '';
 FRazaoSocial    := '';
 FEndereco       := '';
 FComplemento    := '';
 FFone           := '';
 FMunicipio      := '';
 FOutrasInformacaoesImp := '';
 FInscMunicipal         := '';
 FEMail_Prestador       := '';
 FUF                    := '';
 FT_InscEstadual        := '';
 FT_InscMunicipal       := '';
 FAtividade             := '';
 FT_Fone                := '';
 FT_Endereco            := '';
 FT_Complemento         := '';
 FT_Email               := '';

 FNFSeCancelada         := False;
end;

destructor TACBrNFSeDANFSeClass.Destroy;
begin

 inherited Destroy;
end;

procedure TACBrNFSeDANFSeClass.ErroAbstract(NomeProcedure: String);
begin
 raise Exception.Create( NomeProcedure );
end;

function TACBrNFSeDANFSeClass.GetPathArquivos: String;
begin
 if DFeUtil.EstaVazio(FPathArquivos)
  then if Assigned(FACBrNFSe)
        then FPathArquivos := TACBrNFSe(FACBrNFSe).Configuracoes.Geral.PathSalvar;

 if DFeUtil.NaoEstaVazio(FPathArquivos)
  then if not DirectoryExists(FPathArquivos)
        then ForceDirectories(FPathArquivos);

 Result := PathWithDelim(FPathArquivos);
end;

procedure TACBrNFSeDANFSeClass.ImprimirDANFSe(NFSe: TNFSe);
begin
 ErroAbstract('Imprimir');
end;

// Fernando Oliveira - 05/08/2013 - ALTERA��O ESPEC�FICA PARA O ASIX
procedure TACBrNFSeDANFSeClass.ImprimirDANFSeCampinas(NFSe: TNFSe);
begin
  ErroAbstract('ImprimirCampinas');
end;

procedure TACBrNFSeDANFSeClass.ImprimirDANFSePDF(NFSe: TNFSe);
begin
 ErroAbstract('ImprimirPDF');
end;

procedure TACBrNFSeDANFSeClass.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
 inherited Notification(AComponent, Operation);

 if (Operation = opRemove) and (FACBrNFSe <> nil) and (AComponent is TACBrNFSe)
  then FACBrNFSe := nil;
end;

procedure TACBrNFSeDANFSeClass.SetNFSe(const Value: TComponent);
var
 OldValue: TACBrNFSe;
begin
 if Value <> FACBrNFSe then
  begin
   if Value <> nil
    then if not (Value is TACBrNFSe)
          then raise Exception.Create('ACBrDANFSe.NFSe deve ser do tipo TACBrNFSe');

   if Assigned(FACBrNFSe)
    then FACBrNFSe.RemoveFreeNotification(Self);

   OldValue  := TACBrNFSe(FACBrNFSe);  // Usa outra variavel para evitar Loop Infinito
   FACBrNFSe := Value;                 // na remo��o da associa��o dos componentes

   if Assigned(OldValue)
    then if Assigned(OldValue.DANFSe)
          then OldValue.DANFSe := nil;

   if Value <> nil
    then begin
     Value.FreeNotification(self);
     TACBrNFSe(Value).DANFSe := self;
    end;
  end;
end;

procedure TACBrNFSeDANFSeClass.SetPathArquivos(const Value: String);
begin
  FPathArquivos := Value;
end;

end.
