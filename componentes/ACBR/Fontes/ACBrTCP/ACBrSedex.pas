{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2014 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo:                                                 }
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
{******************************************************************************}
{******************************************************************************
|* Historico
|* Doa��o por "datilas" no link
|* http://www.projetoacbr.com.br/forum/index.php?/topic/17388-correios-calculo-de-sedex-pac/
******************************************************************************}

{$I ACBr.inc}

unit ACBrSedex;

interface

uses
  Classes, SysUtils, contnrs, ACBrSocket, ACBrUtil;

const
  CURL_SEDEX = 'http://ws.correios.com.br/calculador/CalcPrecoPrazo.aspx?';

type
  TACBrTpServico = (Tps41106PAC, Tps40010SEDEX, Tps40215SEDEX10,
    Tps40290SEDEXHOJE, Tps81019eSEDEX, Tps44105MALOTE,
    Tps85480AEROGRAMA, Tps10030CARTASIMPLES, Tps10014CARTAREGISTRADA,
    Tps16012CARTAOPOSTAL, Tps20010IMPRESSO, Tps14010MALADIRETA,
    Tps40010SEDEXVarejo, Tps40045SEDEXaCobrarVarejo, Tps40215SEDEX10Varejo,
    Tps40290SEDEXHojeVarejo, Tps41106PACVarejo);

  TACBrTpFormato = (TpfCaixaPacote, TpfRoloPrisma, TpfEnvelope);

  { EACBrSedexException }

  EACBrSedexException = class(Exception)
  public
    constructor CreateACBrStr(const msg : string);
  end ;

  { TACBrRastreio }

  TACBrRastreio = class
  private
    fDataHora: TDateTime;
    fLocal: string;
    fSituacao: string;
    fObservacao: string;
  public
    property DataHora: TDateTime read fDataHora write fDataHora;
    property Local: String read fLocal write fLocal;
    property Situacao: String read fSituacao write fSituacao;
    property Observacao: String read fObservacao write fObservacao;
  end;

  { TACBrRastreioClass }

  TACBrRastreioClass = class(TObjectList)
  protected
    procedure SetObject(Index: integer; Item: TACBrRastreio);
    function GetObject(Index: integer): TACBrRastreio;
  public
    function Add(Obj: TACBrRastreio): integer;
    function New: TACBrRastreio;
    property Objects[Index: integer]: TACBrRastreio read GetObject write SetObject;
      default;
  end;

  { TACBrSedex }

  TACBrSedex = class(TACBrHTTP)
  private
    fsCodContrato: String;
    fsDsSenha: String;
    fsCepOrigem: String;
    fsCepDestino: String;
    fnVlPeso: Double;
    fnCdFormato: TACBrTpFormato;
    fnVlComprimento: Double;
    fnVlAltura: Double;
    fnVlLargura: Double;
    fsMaoPropria: Boolean;
    fnVlValorDeclarado: Double;
    fsAvisoRecebimento: Boolean;
    fnCdServico: TACBrTpServico;
    fnVlDiametro: Double;
    fUrlConsulta: String;

    fCodigoServico: String;
    fValor: Double;
    fPrazoEntrega: Integer;
    fValorSemAdicionais: Double;
    fValorMaoPropria: Double;
    fValorAvisoRecebimento: Double;
    fValorValorDeclarado: Double;
    fEntregaDomiciliar: String;
    fEntregaSabado: String;
    fErro: Integer;
    fMsgErro: String;
    fRastreio: TACBrRastreioClass;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function Consultar: Boolean;
    procedure Rastrear(const CodRastreio: String);

    property retCodigoServico: String read fCodigoServico write fCodigoServico;
    property retValor: Double read fValor write fValor;
    property retPrazoEntrega: Integer read fPrazoEntrega write fPrazoEntrega;
    property retValorSemAdicionais: Double read fValorSemAdicionais
      write fValorSemAdicionais;
    property retValorMaoPropria: Double read fValorMaoPropria write fValorMaoPropria;
    property retValorAvisoRecebimento: Double
      read fValorAvisoRecebimento write fValorAvisoRecebimento;
    property retValorValorDeclarado: Double
      read fValorValorDeclarado write fValorValorDeclarado;
    property retEntregaDomiciliar: String read fEntregaDomiciliar
      write fEntregaDomiciliar;
    property retEntregaSabado: String read fEntregaSabado write fEntregaSabado;
    property retErro: Integer read fErro write fErro;
    property retMsgErro: String read fMsgErro write fMsgErro;

    property retRastreio: TACBrRastreioClass read fRastreio write fRastreio;

  published
    property CodContrato: String read fsCodContrato write fsCodContrato;
    property Senha: String read fsDsSenha write fsDsSenha;
    property CepOrigem: String read fsCepOrigem write fsCepOrigem;
    property CepDestino: String read fsCepDestino write fsCepDestino;
    property Peso: Double read fnVlPeso write fnVlPeso;
    property Formato: TACBrTpFormato read fnCdFormato write fnCdFormato;
    property Comprimento: Double read fnVlComprimento write fnVlComprimento;
    property Altura: Double read fnVlAltura write fnVlAltura;
    property Largura: Double read fnVlLargura write fnVlLargura;
    property MaoPropria: Boolean read fsMaoPropria write fsMaoPropria
      default false;
    property ValorDeclarado: Double read fnVlValorDeclarado write fnVlValorDeclarado;
    property AvisoRecebimento: Boolean read fsAvisoRecebimento write fsAvisoRecebimento
      default false;
    property Servico: TACBrTpServico read fnCdServico write fnCdServico;
    property Diametro: Double read fnVlDiametro write fnVlDiametro;
    property UrlConsulta: String read fUrlConsulta write fUrlConsulta;
  end;


implementation

{ EACBrSedexException }

constructor EACBrSedexException.CreateACBrStr(const msg: string);
begin
  inherited Create( ACBrStr(msg) );
end;

{ TACBrRastreioClass }

procedure TACBrRastreioClass.SetObject(Index: integer; Item: TACBrRastreio);
begin
  inherited SetItem(Index, Item);
end;

function TACBrRastreioClass.GetObject(Index: integer): TACBrRastreio;
begin
  Result := inherited GetItem(Index) as TACBrRastreio;
end;

function TACBrRastreioClass.New: TACBrRastreio;
begin
  Result := TACBrRastreio.Create;
  Add(Result);
end;

function TACBrRastreioClass.Add(Obj: TACBrRastreio): integer;
begin
  Result := inherited Add(Obj);
end;

{ TACBrSedex }

constructor TACBrSedex.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  fRastreio := TACBrRastreioClass.Create;
  fRastreio.Clear;
  fsCodContrato := '';
  fsDsSenha := '';
  fsCepOrigem := '';
  fsCepDestino := '';
  fnVlPeso := 0;
  fnCdFormato := TpfCaixaPacote;
  fnVlComprimento := 0;
  fnVlAltura := 0;
  fnVlLargura := 0;
  fsMaoPropria := False;
  fnVlValorDeclarado := 0;
  fsAvisoRecebimento := False;
  fnCdServico := Tps41106PAC;
  fUrlConsulta := CURL_SEDEX;

  fCodigoServico := '';
  fValor := 0;
  fPrazoEntrega := 0;
  fValorSemAdicionais := 0;
  fValorMaoPropria := 0;
  fValorAvisoRecebimento := 0;
  fValorValorDeclarado := 0;
  fEntregaDomiciliar := '';
  fEntregaSabado := '';
  fErro := 0;
  fMsgErro := '';
end;

destructor TACBrSedex.Destroy;
begin
  fRastreio.Free;
  inherited Destroy;
end;

function TACBrSedex.Consultar: Boolean;
var
  TpServico, TpFormato, TpMaoPropria, TpAvisoRecebimento, Buffer: string;
begin
  case fnCdServico of
    Tps41106PAC :
      TpServico := '41106';
    Tps40010SEDEX :
      TpServico := '40010';
    Tps40215SEDEX10 :
      TpServico := '40215';
    Tps40290SEDEXHOJE :
      TpServico := '40290';
    Tps81019eSEDEX :
      TpServico := '81019';
    Tps44105MALOTE :
      TpServico := '44105';
    Tps85480AEROGRAMA :
      TpServico := '85480';
    Tps10030CARTASIMPLES :
      TpServico := '10030';
    Tps10014CARTAREGISTRADA :
      TpServico := '10014';
    Tps16012CARTAOPOSTAL :
      TpServico := '16012';
    Tps20010IMPRESSO :
      TpServico := '20010';
    Tps14010MALADIRETA :
      TpServico := '14010';
    Tps40010SEDEXVarejo :
      TpServico := '40010';
    Tps40045SEDEXaCobrarVarejo :
      TpServico := '40045';
    Tps40215SEDEX10Varejo :
      TpServico := '40215';
    Tps40290SEDEXHojeVarejo :
      TpServico := '40290';
    Tps41106PACVarejo :
      TpServico := '41106';
    else
      raise EACBrSedexException.CreateACBrStr('Tipo de Servi�o Inv�lido');
  end;

  case fnCdFormato of
    TpfCaixaPacote :
      TpFormato := '1';
    TpfRoloPrisma :
      TpFormato := '2';
    TpfEnvelope :
      TpFormato := '3';
    else
      raise EACBrSedexException.CreateACBrStr('Formato da Embalagem Inv�lido');
  end;

  if fsMaoPropria then
    TpMaoPropria := 'S'
  else
    TpMaoPropria := 'N';

  if fsAvisoRecebimento then
    TpAvisoRecebimento := 'S'
  else
    TpAvisoRecebimento := 'N';

  try
    Self.HTTPGet(fUrlConsulta +
      'nCdEmpresa=' + fsCodContrato +
      '&sDsSenha=' + fsDsSenha +
      '&sCepOrigem=' + OnlyNumber(fsCepOrigem) +
      '&sCepDestino=' + OnlyNumber(fsCepDestino) +
      '&nVlPeso=' + FormatFloat('#,000', fnVlPeso) +
      '&nCdFormato=' + TpFormato +
      '&nVlComprimento=' + FormatFloat('#,000', fnVlComprimento) +
      '&nVlAltura=' + FormatFloat('#,000', fnVlAltura) +
      '&nVlLargura=' + FormatFloat('#,000', fnVlLargura) +
      '&sCdMaoPropria=' + TpMaoPropria +
      '&nVlValorDeclarado=' + FormatFloat('#0,00', fnVlValorDeclarado) +
      '&sCdAvisoRecebimento=' + TpAvisoRecebimento +
      '&nCdServico=' + TpServico +
      '&nVlDiametro=' + FormatFloat('#,000', fnVlDiametro) +
      '&StrRetorno=xml');
  except
    on E: Exception do
    begin
      raise EACBrSedexException.Create('Erro ao consultar Sedex' + sLineBreak + E.Message);
    end;
  end;

  //DEBUG
  //Self.RespHTTP.SaveToFile('C:\TEMP\CONSULTA.HTML');

  Buffer := Self.RespHTTP.Text;

  retCodigoServico         := LerTagXml(Buffer, 'Codigo', True);
  retvalor                 := StringToFloatDef(LerTagXml(Buffer, 'Valor', True),-1);
  retPrazoEntrega          := StrToIntDef(LerTagXml(Buffer, 'PrazoEntrega', True),-1);
  retValorSemAdicionais    := StringToFloatDef(LerTagXml(Buffer, 'ValorSemAdicionais', True),-1);
  retValorMaoPropria       := StringToFloatDef(LerTagXml(Buffer, 'ValorMaoPropria', True),-1);
  retValorAvisoRecebimento := StringToFloatDef(LerTagXml(Buffer, 'ValorAvisoRecebimento', True),-1);
  retValorValorDeclarado   := StringToFloatDef(LerTagXml(Buffer, 'ValorValorDeclarado', True),-1);
  retEntregaDomiciliar     := LerTagXml(Buffer, 'EntregaDomiciliar', True);
  retEntregaSabado         := LerTagXml(Buffer, 'EntregaSabado', True);
  retErro                  := StrToIntDef(LerTagXml(Buffer, 'Erro', True),-1);
  retMsgErro               := LerTagXml(Buffer, 'MsgErro', True);

  retMsgErro := StringReplace(retMsgErro, '<![CDATA[', '', [rfReplaceAll]);
  retMsgErro := StringReplace(retMsgErro, ']]>', '', [rfReplaceAll]);

  Result := (retErro = 0);
end;

//C�digo de erro Mensagem de erro
//0 Processamento com sucesso
//-1 C�digo de servi�o inv�lido
//-2 CEP de origem inv�lido
//-3 CEP de destino inv�lido
//-4 Peso excedido
//-5 O Valor Declarado n�o deve exceder R$ 10.000,00
//-6 Servi�o indispon�vel para o trecho informado
//-7 O Valor Declarado � obrigat�rio para este servi�o
//-8 Este servi�o n�o aceita M�o Pr�pria
//-9 Este servi�o n�o aceita Aviso de Recebimento
//-10 Precifica��o indispon�vel para o trecho informado
//-11 Para defini��o do pre�o dever�o ser informados, tamb�m, o comprimento, a largura e altura do objeto em cent�metros (cm).
//-12 Comprimento inv�lido.
//-13 Largura inv�lida.
//-14 Altura inv�lida.
//-15 O comprimento n�o pode ser maior que 105 cm.
//-16 A largura n�o pode ser maior que 105 cm.
//-17 A altura n�o pode ser maior que 105 cm.
//-18 A altura n�o pode ser inferior a 2 cm.
//-20 A largura n�o pode ser inferior a 11 cm.
//-22 O comprimento n�o pode ser inferior a 16 cm.
//-23 A soma resultante do comprimento + largura + altura n�o deve superar a 200 cm.
//-24 Comprimento inv�lido.
//-25 Di�metro inv�lido
//-26 Informe o comprimento.
//-27 Informe o di�metro.
//-28 O comprimento n�o pode ser maior que 105 cm.
//-29 O di�metro n�o pode ser maior que 91 cm.
//-30 O comprimento n�o pode ser inferior a 18 cm.
//-31 O di�metro n�o pode ser inferior a 5 cm.
//-32 A soma resultante do comprimento + o dobro do di�metro n�o deve superar a 200 cm.
//-33 Sistema temporariamente fora do ar. Favor tentar mais tarde.
//-34 C�digo Administrativo ou Senha inv�lidos.
//-35 Senha incorreta.
//-36 Cliente n�o possui contrato vigente com os Correios.
//-37 Cliente n�o possui servi�o ativo em seu contrato.
//-38 Servi�o indispon�vel para este c�digo administrativo.
//-39 Peso excedido para o formato envelope
//-40 Para definicao do preco deverao ser informados, tambem, o comprimento e a largura e altura do objeto em centimetros (cm).
//-41 O comprimento nao pode ser maior que 60 cm.
//-42 O comprimento nao pode ser inferior a 16 cm.
//-43 A soma resultante do comprimento + largura nao deve superar a 120 cm.
//-44 A largura nao pode ser inferior a 11 cm.
//-45 A largura nao pode ser maior que 60 cm.
//-888 Erro ao calcular a tarifa
//006 Localidade de origem n�o abrange o servi�o informado
//007 Localidade de destino n�o abrange o servi�o informado
//008 Servi�o indispon�vel para o trecho informado
//009 CEP inicial pertencente a �rea de Risco.
//010 CEP final pertencente a �rea de Risco. A entrega ser� realizada, temporariamente, na ag�ncia mais pr�xima do endere�o do destinat�rio.
//011 CEP inicial e final pertencentes a �rea de Risco
//7 Servi�o indispon�vel, tente mais tarde
//99 Outros erros diversos do .Net
procedure TACBrSedex.Rastrear(const CodRastreio: String);
var
  SL: TStringList;
  I, Cont: integer;
  vObs, Erro: String;

  function CopyDeAte(Texto, TextIni, TextFim: string): string;
  var
    ContIni, ContFim: integer;
  begin
    Result := '';
    if (Pos(TextFim, Texto) <> 0) and (Pos(TextIni, Texto) <> 0) then
    begin
      ContIni := Pos(TextIni, Texto) + Length(TextIni);
      ContFim := Pos(TextFim, Texto);
      Result := Copy(Texto, ContIni, ContFim - ContIni);
    end;
  end;
begin
  retRastreio.Clear;

  if Length(CodRastreio) <> 13 then
    raise EACBrSedexException.CreateACBrStr('C�digo de rastreamento deve conter 13 caracteres');

  try
    Self.HTTPGet(
      'http://websro.correios.com.br/sro_bin/txect01$.QueryList?P_LINGUA=001&P_TIPO=001&P_COD_UNI='
      + CodRastreio);
  except
    on E: Exception do
    begin
      raise EACBrSedexException.Create('Erro ao Rastrear' + sLineBreak + E.Message);
    end;
  end;

  //DEBUG
  //Self.RespHTTP.SaveToFile('C:\TEMP\RASTREIO.HTML');

  if Pos(ACBrStr('tente novamente mais tarde'), Self.RespHTTP.Text) > 0 then
  begin
    Erro := Trim(StripHTML(Self.RespHTTP.Text));
    Erro := Trim(StringReplace(Erro,'SRO - Internet','',[rfReplaceAll]));
    Erro := Trim(StringReplace(Erro,'Resultado da Pesquisa','',[rfReplaceAll]));

    //Self.RespHTTP.Text := Erro ;
    //Self.RespHTTP.SaveToFile('C:\TEMP\RASTREIO.txt');

    raise EACBrSedexException.Create(Erro);
  end;

  SL := TStringList.Create;
  try
    SL.Text := Self.RespHTTP.Text;
    Cont := SL.Count - 1;

    for I := cont downto 0 do
    begin
      if Pos('colspan', SL[I]) > 0 then
        vObs := CopyDeAte(SL[I], 'colspan=2>', '</td></tr>')

      else if Pos('rowspan', SL[I]) > 0 then
      begin
        with retRastreio.New do
        begin
          DataHora   := StrToDateTime(Copy(SL[I], 19, 16) + ':00');
          Local      := CopyDeAte(SL[I], '</td><td>', '</td><td><FONT');
          Situacao   := CopyDeAte(SL[I], '">', '</font>');
          Observacao := vObs;
        end;

        vObs := '';
      end;
    end;
  finally
    SL.Free;
  end;
end;

end.
