////////////////////////////////////////////////////////////////////////////////
//                                                                            //
//              PCN - Projeto Cooperar NFe                                    //
//                                                                            //
//   Descri��o: Classes para gera��o/leitura dos arquivos xml da NFe          //
//                                                                            //
//        site: www.projetocooperar.org                                       //
//       email: projetocooperar@zipmail.com.br                                //
//       forum: http://br.groups.yahoo.com/group/projeto_cooperar_nfe/        //
//     projeto: http://code.google.com/p/projetocooperar/                     //
//         svn: http://projetocooperar.googlecode.com/svn/trunk/              //
//                                                                            //
// Coordena��o: (c) 2009 - Paulo Casagrande                                   //
//                                                                            //
//      Equipe: Vide o arquivo leiame.txt na pasta raiz do projeto            //
//                                                                            //
//      Vers�o: Vide o arquivo leiame.txt na pasta raiz do projeto            //
//                                                                            //
//     Licen�a: GNU Lesser General Public License (GNU LGPL)                  //
//                                                                            //
//              - Este programa � software livre; voc� pode redistribu�-lo    //
//              e/ou modific�-lo sob os termos da Licen�a P�blica Geral GNU,  //
//              conforme publicada pela Free Software Foundation; tanto a     //
//              vers�o 2 da Licen�a como (a seu crit�rio) qualquer vers�o     //
//              mais nova.                                                    //
//                                                                            //
//              - Este programa � distribu�do na expectativa de ser �til,     //
//              mas SEM QUALQUER GARANTIA; sem mesmo a garantia impl�cita de  //
//              COMERCIALIZA��O ou de ADEQUA��O A QUALQUER PROP�SITO EM       //
//              PARTICULAR. Consulte a Licen�a P�blica Geral GNU para obter   //
//              mais detalhes. Voc� deve ter recebido uma c�pia da Licen�a    //
//              P�blica Geral GNU junto com este programa; se n�o, escreva    //
//              para a Free Software Foundation, Inc., 59 Temple Place,       //
//              Suite 330, Boston, MA - 02111-1307, USA ou consulte a         //
//              licen�a oficial em http://www.gnu.org/licenses/gpl.txt        //
//                                                                            //
//    Nota (1): - Esta  licen�a  n�o  concede  o  direito  de  uso  do nome   //
//              "PCN  -  Projeto  Cooperar  NFe", n�o  podendo o mesmo ser    //
//              utilizado sem previa autoriza��o.                             //
//                                                                            //
//    Nota (2): - O uso integral (ou parcial) das units do projeto esta       //
//              condicionado a manuten��o deste cabe�alho junto ao c�digo     //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////

{*******************************************************************************
|* Historico
|*
|* 28/09/2012: Italo
|*  - Revisado gera��o do XML e adicionado propriedade para controle de Vers�o
|*    do WebService Utilizado
*******************************************************************************}

{$I ACBr.inc}

unit pcnInutNFe;

interface

uses
  SysUtils, Classes,
{$IFNDEF VER130}
  Variants,
{$ENDIF}
  pcnAuxiliar, pcnConversao, pcnGerador, pcnRetInutNFe, ACBrUtil;

type

  TinutNFe = class(TPersistent)
  private
    FGerador: TGerador;
    FtpAmb: TpcnTipoAmbiente;
    FcUF: Integer;
    Fano: Integer;
    FCNPJ: String;
    Fmodelo: Integer;
    Fserie: Integer;
    FnNFIni: Integer;
    FnNFFin: Integer;
    FxJust: String;
    FIDInutilizacao: String;
    FVersao: String;
    FInutNFe: TRetInutNFe;
  public
    constructor Create;
    destructor Destroy; override;
    function GerarXML: Boolean;
    function LerXML(CaminhoArquivo: String): Boolean;
    function LerXMLFromString(const AXML: String): Boolean;
    function ObterNomeArquivo: String;
  published
    property Gerador: TGerador       read FGerador write FGerador;
    property tpAmb: TpcnTipoAmbiente read FtpAmb   write FtpAmb;
    property cUF: Integer            read FcUF     write FcUF;
    property ano: Integer            read Fano     write Fano;
    property CNPJ: String            read FCNPJ    write FCNPJ;
    property modelo: Integer         read Fmodelo  write Fmodelo;
    property serie: Integer          read Fserie   write Fserie;
    property nNFIni: Integer         read FnNFIni  write FnNFIni;
    property nNFFin: Integer         read FnNFFin  write FnNFFin;
    property xJust: String           read FxJust   write FxJust;
    property ID: String              read FIDInutilizacao;
    property Versao: String          read FVersao  write FVersao;
    property InutNFe: TRetInutNFe    read FInutNFe write FInutNFe;
  end;

implementation

{ TinutNFe }

constructor TinutNFe.Create;
begin
  FGerador := TGerador.Create;
  FInutNFe := TRetInutNFe.Create;
end;

destructor TinutNFe.Destroy;
begin
  FGerador.Free;
  FInutNFe.Free;
  inherited;
end;

function TinutNFe.ObterNomeArquivo: String;
begin
  Result := OnlyNumber(FIDInutilizacao) + '-ped-inu.xml';
end;

function TinutNFe.GerarXML: Boolean;
begin
  FIDInutilizacao := 'ID' + IntToStrZero(FcUF, 2) +  IntToStrZero(Fano, 2)+
                     OnlyNumber(FCNPJ) + IntToStrZero(Fmodelo, 2) + IntToStrZero(Fserie, 3) +
                     IntToStrZero(FnNFIni, 9) + IntToStrZero(FnNFFin, 9);

  Gerador.ArquivoFormatoXML := '';
  Gerador.wGrupo('inutNFe ' + NAME_SPACE + ' versao="' + Versao + '"');
  Gerador.wGrupo('infInut Id="' + FIDInutilizacao + '"');
  if length(FIDInutilizacao) < 43 then
    Gerador.wAlerta('DP04', 'ID', '', 'ID de inutiliza��o inv�lido');
  Gerador.wCampo(tcStr, 'DP05', 'tpAmb ', 001, 001, 1, tpAmbToStr(FtpAmb), DSC_TPAMB);
  Gerador.wCampo(tcStr, 'DP06', 'xServ ', 010, 010, 1, 'INUTILIZAR', DSC_XSERV);
  Gerador.wCampo(tcInt, 'DP07', 'cUF   ', 002, 002, 1, FcUF, DSC_CUF);
  if not ValidarCodigoUF(FcUF) then
    Gerador.wAlerta('DP07', 'cUF', DSC_CUF, ERR_MSG_INVALIDO);
  Gerador.wCampo(tcInt, 'DP08', 'ano   ', 002, 002, 1, Fano, DSC_ANO);
  Gerador.wCampo(tcStr, 'DP09', 'CNPJ  ', 014, 014, 1, OnlyNumber(FCNPJ), DSC_CNPJ);
  if not ValidarCNPJ(FCNPJ) then
    Gerador.wAlerta('DP09', 'CNPJ', DSC_CNPJ, ERR_MSG_INVALIDO);
  Gerador.wCampo(tcInt, 'DP10', 'mod   ', 002, 002, 1, Fmodelo, DSC_MOD);
  Gerador.wCampo(tcInt, 'DP11', 'serie ', 001, 003, 1, Fserie, DSC_SERIE);
  Gerador.wCampo(tcInt, 'DP12', 'nNFIni', 001, 009, 1, FnNFIni, DSC_NNFINI);
  Gerador.wCampo(tcInt, 'DP13', 'nNFFin', 001, 009, 1, FnNFFin, DSC_NNFFIN);
  if FnNFIni > FnNFFin then
    Gerador.wAlerta('DP13', 'nNFFin', DSC_NNFFIN, ERR_MSG_FINAL_MENOR_INICIAL);
  Gerador.wCampo(tcStr, 'CP14', 'xJust ', 015, 255, 1, FiltrarTextoXML(true, FxJust), DSC_XJUST);
  Gerador.wGrupo('/infInut');
  Gerador.wGrupo('/inutNFe');

  Result := (Gerador.ListaDeAlertas.Count = 0);

end;

function TinutNFe.LerXML(CaminhoArquivo: String): Boolean;
var
  ArqInut: TStringList;
begin
  ArqInut := TStringList.Create;
  try
     ArqInut.LoadFromFile(CaminhoArquivo);
     Result := LerXMLFromString(ArqInut.Text);
  finally
     ArqInut.Free;
  end;
end;

function TinutNFe.LerXMLFromString(const AXML: String): Boolean;
var
  RetInutNFe: TRetInutNFe;
begin
  RetInutNFe := TRetInutNFe.Create;
  try
    RetInutNFe.Leitor.Arquivo := AXML;
    Result := RetInutNFe.LerXml;

    with FInutNFe do
     begin
      Id       := RetInutNFe.Id;
      tpAmb    := RetInutNFe.tpAmb;
      verAplic := RetInutNFe.verAplic;
      cStat    := RetInutNFe.cStat;
      xMotivo  := RetInutNFe.xMotivo;
      cUF      := RetInutNFe.cUF;
      xJust    := RetInutNFe.xJust; //Adicionada para trazer a Justificativa, caso seja um arquivo ProcInut

      ano      := RetInutNFe.ano;
      CNPJ     := RetInutNFe.CNPJ;
      Modelo   := RetInutNFe.Modelo;
      Serie    := RetInutNFe.Serie;
      nNFIni   := RetInutNFe.nNFIni;
      nNFFin   := RetInutNFe.nNFFin;
      dhRecbto := RetInutNFe.dhRecbto;
      nProt    := RetInutNFe.nProt;
     end;
  finally
     RetInutNFe.Free;
  end;
end;

end.

