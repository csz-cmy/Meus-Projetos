{******************************************************************************}
{ Projeto: Componente ACBrMDFe                                                 }
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

{*******************************************************************************
|* Historico
|*
|* 01/08/2012: Italo Jurisato Junior
|*  - Doa��o do componente para o Projeto ACBr
*******************************************************************************}

{$I ACBr.inc}

unit pmdfeProcMDFe;

interface

uses
  SysUtils, Classes,
  pcnAuxiliar, pcnConversao, pcnGerador, pcnLeitor;

type

  TPcnPadraoNomeProcMDFe = (tpnPublico, tpnPrivado);

  TProcMDFe = class(TPersistent)
  private
    FGerador: TGerador;
    FPathMDFe: String;
    FPathRetConsReciMDFe: String;
    FPathRetConsSitMDFe: String;
    FtpAmb: TpcnTipoAmbiente;
    FverAplic: String;
    FchMDFe: String;
    FdhRecbto: TDateTime;
    FnProt: String;
    FdigVal: String;
    FcStat: Integer;
    FxMotivo: String;
  public
    constructor Create;
    destructor Destroy; override;
    function GerarXML: boolean;
    function ObterNomeArquivo(const PadraoNome: TPcnPadraoNomeProcMDFe = tpnPrivado): String;
  published
    property Gerador: TGerador           read FGerador             write FGerador;
    property PathMDFe: String            read FPathMDFe            write FPathMDFe;
    property PathRetConsReciMDFe: String read FPathRetConsReciMDFe write FPathRetConsReciMDFe;
    property PathRetConsSitMDFe: String  read FPathRetConsSitMDFe  write FPathRetConsSitMDFe;
    property tpAmb: TpcnTipoAmbiente     read FtpAmb               write FtpAmb;
    property verAplic: String            read FverAplic            write FverAplic;
    property chMDFe: String              read FchMDFe              write FchMDFe;
    property dhRecbto: TDateTime         read FdhRecbto            write FdhRecbto;
    property nProt: String               read FnProt               write FnProt;
    property digVal: String              read FdigVal              write FdigVal;
    property cStat: Integer              read FcStat               write FcStat;
    property xMotivo: String             read FxMotivo             write FxMotivo;
  end;

implementation

{ TProcMDFe }

constructor TProcMDFe.Create;
begin
  FGerador := TGerador.Create;
end;

destructor TProcMDFe.Destroy;
begin
  FGerador.Free;
  inherited;
end;

function TProcMDFe.ObterNomeArquivo(const PadraoNome: TPcnPadraoNomeProcMDFe = tpnPrivado): String;
var
  s: String;
begin
  Result := FchMDFe + '-procMDFe.xml';
  if PadraoNome = tpnPublico then
  begin
    s := '00' + MDFeEnviMDFe;
    Result := FnProt + '_v' + copy(s, length(s) - 4, 5) + '-procMDFe.xml';
  end;
end;

function TProcMDFe.GerarXML: boolean;

function PreencherTAG(const TAG: String; Texto: String): String;
begin
  result := '<' + TAG + '>' + RetornarConteudoEntre(Texto, '<' + TAG + '>', '</' + TAG + '>') + '</' + TAG + '>';
end;

var
  XMLMDFe: TStringList;
  XMLinfProt: TStringList;
  XMLinfProt2: TStringList;
  wCstat: String;
  xProtMDFe: String;
  LocLeitor: TLeitor;
  i: Integer;
  ProtLido: Boolean; // Protocolo lido do Arquivo
begin
  ProtLido := False;
  xProtMDFe := '';
  FnProt := '';

  XMLMDFe := TStringList.Create;
  XMLinfProt := TStringList.Create;
  XMLinfProt2 := TStringList.Create;
  try
    // Arquivo MDFe
    if not FileExists(FPathMDFe)
     then Gerador.wAlerta('XR04', 'MDFe', 'MDFe', ERR_MSG_ARQUIVO_NAO_ENCONTRADO)
     else XMLMDFe.LoadFromFile(FPathMDFe);

    FchMDFe := RetornarConteudoEntre(XMLMDFe.Text, 'Id="MDFe', '"');
    if trim(FchMDFe) = ''
     then Gerador.wAlerta('XR01', 'ID/MDFe', 'Numero da chave do MDFe', ERR_MSG_VAZIO);

    if (FPathRetConsReciMDFe = '') and (FPathRetConsSitMDFe = '')
     then begin
      if (FchMDFe = '') and (FnProt = '')
       then Gerador.wAlerta('XR06', 'RECIBO/SITUA��O', 'RECIBO/SITUA��O', ERR_MSG_ARQUIVO_NAO_ENCONTRADO)
       else ProtLido := True;
     end;

    // Gerar arquivo pelo Recibo do MDFe
    if (FPathRetConsReciMDFe <> '') and (FPathRetConsSitMDFe = '') and (not ProtLido)
     then begin
      if not FileExists(FPathRetConsReciMDFe)
       then Gerador.wAlerta('XR06', 'PROTOCOLO', 'PROTOCOLO', ERR_MSG_ARQUIVO_NAO_ENCONTRADO)
       else begin
        I := 0;
        LocLeitor := TLeitor.Create;
        try
          LocLeitor.CarregarArquivo(FPathRetConsReciMDFe);
          while LocLeitor.rExtrai(1, 'protMDFe', '', i + 1) <> '' do
           begin
             if LocLeitor.rCampo(tcStr, 'chMDFe') = FchMDFe
              then FnProt := LocLeitor.rCampo(tcStr, 'nProt');
             if trim(FnProt) = ''
              then Gerador.wAlerta('XR01', 'PROTOCOLO/MDFe', 'Numero do protocolo', ERR_MSG_VAZIO)
              else begin
               xProtMDFe := LocLeitor.rExtrai(1, 'protMDFe', '', i + 1);
               Gerador.ListaDeAlertas.Clear;
               break;
              end;
              I := I + 1;
           end;
         finally
           LocLeitor.Free;
         end;
       end;
     end;

    // Gerar arquivo pelo arquivo de consulta da situa��o do MDFe
    if (FPathRetConsReciMDFe = '') and (FPathRetConsSitMDFe <> '') and (not ProtLido)
     then begin
      if not FileExists(FPathRetConsSitMDFe)
       then Gerador.wAlerta('XR06', 'SITUA��O', 'SITUA��O', ERR_MSG_ARQUIVO_NAO_ENCONTRADO)
       else begin
        XMLinfProt.LoadFromFile(FPathRetConsSitMDFe);

        wCstat:=RetornarConteudoEntre(XMLinfProt.text, '<cStat>', '</cStat>');
        if trim(wCstat) = '101'
         then XMLinfProt2.Text:=RetornarConteudoEntre(XMLinfProt.text, '<infCanc', '</infCanc>')
         else XMLinfProt2.Text:=RetornarConteudoEntre(XMLinfProt.text, '<infProt', '</infProt>');

        xProtMDFe := '<protMDFe versao="' + MDFeEnviMDFe + '">' +
                      '<infProt>' +
                        PreencherTAG('tpAmb', XMLinfProt.text) +
                        PreencherTAG('verAplic', XMLinfProt.text) +
                        PreencherTAG('chMDFe', XMLinfProt.text) +
                        PreencherTAG('dhRecbto', XMLinfProt2.text) +
                        PreencherTAG('nProt', XMLinfProt2.text) +
                        PreencherTAG('digVal', XMLinfProt.text) +
                        PreencherTAG('cStat', XMLinfProt.text) +
                        PreencherTAG('xMotivo', XMLinfProt.text) +
                      '</infProt>' +
                     '</protMDFe>';
       end;
     end;

    if ProtLido
     then begin
      xProtMDFe := '<protMDFe versao="' + MDFeEnviMDFe + '">' +
                    '<infProt>' +
                     '<tpAmb>'+TpAmbToStr(FtpAmb)+'</tpAmb>'+
                     '<verAplic>'+FverAplic+'</verAplic>'+
                     '<chMDFe>'+FchMDFe+'</chMDFe>'+
                     '<dhRecbto>'+FormatDateTime('yyyy-mm-dd"T"hh:nn:ss',FdhRecbto)+'</dhRecbto>'+
                     '<nProt>'+FnProt+'</nProt>'+
                     '<digVal>'+FdigVal+'</digVal>'+
                     '<cStat>'+IntToStr(FcStat)+'</cStat>'+
                     '<xMotivo>'+FxMotivo+'</xMotivo>'+
                    '</infProt>'+
                   '</protMDFe>';
     end;

    // Gerar arquivo
    if Gerador.ListaDeAlertas.Count = 0
     then begin
      Gerador.ArquivoFormatoXML := '';
      Gerador.wGrupo(ENCODING_UTF8, '', False);
      Gerador.wGrupo('mdfeProc versao="' + MDFeEnviMDFe + '" ' + NAME_SPACE_MDFE, '');
      Gerador.wTexto('<MDFe xmlns' + RetornarConteudoEntre(XMLMDFe.Text, '<MDFe xmlns', '</MDFe>') + '</MDFe>');
      Gerador.wTexto(xProtMDFe);
      Gerador.wGrupo('/mdfeProc');
     end;

    Result := (Gerador.ListaDeAlertas.Count = 0);

  finally
    XMLMDFe.Free;
    XMLinfProt.Free;
    XMLinfProt2.Free;
  end;
end;

end.

