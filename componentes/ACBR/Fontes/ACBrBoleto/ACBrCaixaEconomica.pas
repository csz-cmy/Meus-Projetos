{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2009 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo:   Jo�o Elson                                    }
{                                                                              }
{  Voc� pode obter a �ltima vers�o desse arquivo na pagina do  Projeto ACBr    }
{ Componentes localizado em      http://www.sourceforge.net/projects/acbr      }
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

{Conv�nio SIGCB Carteira 1 ou 2 Registrada ou Sem Registro} 

{$I ACBr.inc}

unit ACBrCaixaEconomica;

interface

uses
  Classes, SysUtils, ACBrBoleto,
  {$IFDEF COMPILER6_UP} DateUtils {$ELSE} ACBrD5, FileCtrl {$ENDIF};

type

  { TACBrCaixaEconomica}

  TACBrCaixaEconomica = class(TACBrBancoClass)
   protected
   private
    fValorTotalDocs:Double;
    function FormataNossoNumero(const ACBrTitulo :TACBrTitulo): String;
   public
    Constructor create(AOwner: TACBrBanco);
    function CalcularDigitoVerificador(const ACBrTitulo: TACBrTitulo ): String; override;
    function CalcularDVCedente(const ACBrTitulo: TACBrTitulo ): String;
    function MontarCodigoBarras(const ACBrTitulo : TACBrTitulo): String; override;
    function MontarCampoCodigoCedente(const ACBrTitulo: TACBrTitulo): String; override;
    function MontarCampoNossoNumero(const ACBrTitulo :TACBrTitulo): String; override;
    function GerarRegistroHeader240(NumeroRemessa : Integer): String; override;
    function GerarRegistroTransacao240(ACBrTitulo : TACBrTitulo): String; override;
    function GerarRegistroTrailler240(ARemessa : TStringList): String;  override;
    procedure LerRetorno240(ARetorno: TStringList); override;
    function CodMotivoRejeicaoToDescricao(const TipoOcorrencia: TACBrTipoOcorrencia; CodMotivo: Integer): string; override;
    function TipoOcorrenciaToDescricao(const TipoOcorrencia: TACBrTipoOcorrencia): String; override;
    function CodOcorrenciaToTipo(const CodOcorrencia: Integer): TACBrTipoOcorrencia; override;
    function TipoOCorrenciaToCod(const TipoOcorrencia: TACBrTipoOcorrencia): String; override;
    function CodigoLiquidacao_Descricao( CodLiquidacao : Integer) : String;
   end;

implementation

uses ACBrUtil, StrUtils, Variants;

constructor TACBrCaixaEconomica.create(AOwner: TACBrBanco);
begin
   inherited create(AOwner);
   fpDigito := 0;
   fpNome   := 'Caixa Economica Federal';
   fpNumero:= 104;
   fpTamanhoAgencia :=  5;
   fpTamanhoMaximoNossoNum := 15;

   fValorTotalDocs:= 0;

   fpOrientacoesBanco.Clear;
   
   // DONE -oJacinto Junior: Ajustar a mensagem a ser apresentada nos boletos.
//   fpOrientacoesBanco.Add(ACBrStr('SAC CAIXA: 0800 726 0101 (informa��es,reclama��es e elogios) ' + sLineBreak+
//                          'Para pessoas com defici�ncia auditiva ou de fala: 0800 726 2492 ' + sLineBreak +
//                          'Ouvidoria: 0800 725 7474 (reclama��es n�o solucionadas e den�ncias)') + sLineBreak+
//                          '     caixa.gov.br      ');
   fpOrientacoesBanco.Add(ACBrStr(
                          'SAC CAIXA: 0800 726 0101 (informa��es, reclama��es, sugest�es e elogios) ' + sLineBreak +
                          'Para pessoas com defici�ncia auditiva ou de fala: 0800 726 2492 ' + sLineBreak +
                          'Ouvidoria: 0800 725 7474 (reclama��es n�o solucionadas e den�ncias) ') + sLineBreak +
                          'caixa.gov.br ');
end;

function TACBrCaixaEconomica.CalcularDigitoVerificador(const ACBrTitulo: TACBrTitulo ): String;
var
  Num, ACarteira, ANossoNumero, Res :String;
begin
   Result := '0';
   if (ACBrTitulo.Carteira = 'RG') then
      ACarteira := '1'
   else if (ACBrTitulo.Carteira = 'SR')then
      ACarteira := '2'
   else
      raise Exception.Create( ACBrStr('Carteira Inv�lida.'+sLineBreak+'Utilize "RG" ou "SR"') ) ;

   ANossoNumero := OnlyNumber(ACBrTitulo.NossoNumero);

   if ACBrTitulo.CarteiraEnvio = tceCedente then //O Cedente � quem envia o boleto
      Num := ACarteira + '4' + PadR(ANossoNumero, 15, '0')
   else
      Num := ACarteira + '1' + PadR(ANossoNumero, 15, '0'); //o Banco � quem Envia

   Modulo.CalculoPadrao;
   Modulo.MultiplicadorFinal   := 2;
   Modulo.MultiplicadorInicial := 9;
   Modulo.Documento := Num;
   Modulo.Calcular;

   Res:= IntToStr(Modulo.ModuloFinal);

   if Length(Res) > 1 then
      Result := '0'
   else
      Result := Res[1];

end;

function TACBrCaixaEconomica.CalcularDVCedente(const ACBrTitulo: TACBrTitulo): String;
var
  Num, Res: string;
begin 
    Num := ACBrTitulo.ACBrBoleto.Cedente.CodigoCedente;
    Modulo.CalculoPadrao;
    Modulo.MultiplicadorFinal   := 2;
    Modulo.MultiplicadorInicial := 9;
    Modulo.Documento := Num;
    Modulo.Calcular;
    Res := intTostr(Modulo.ModuloFinal);

    if Length(Res) > 1 then
       Result := '0'
    else
       Result := Res[1];
end;

function TACBrCaixaEconomica.FormataNossoNumero(const ACBrTitulo :TACBrTitulo): String;
var
  ANossoNumero :String;
begin
   with ACBrTitulo do
   begin
      ANossoNumero := OnlyNumber(NossoNumero);

      if (ACBrTitulo.Carteira = 'RG') then
      begin         {carterira registrada}
        if ACBrTitulo.CarteiraEnvio = tceCedente then
          ANossoNumero := '14'+padR(ANossoNumero, 15, '0')
        else
          ANossoNumero := '11'+padR(ANossoNumero, 15, '0')
      end
      else if (ACBrTitulo.Carteira = 'SR')then     {carteira 2 sem registro}
      begin
        if ACBrTitulo.CarteiraEnvio = tceCedente then
          ANossoNumero := '24'+padR(ANossoNumero, 15, '0')
        else
          ANossoNumero := '21'+padR(ANossoNumero, 15, '0')
      end
      else
         raise Exception.Create( ACBrStr('Carteira Inv�lida.'+sLineBreak+'Utilize "RG" ou "SR"') ) ;
   end;

   Result := ANossoNumero;
end;

function TACBrCaixaEconomica.MontarCodigoBarras(const ACBrTitulo : TACBrTitulo): String;
var
  CodigoBarras, FatorVencimento, DigitoCodBarras :String;
  CampoLivre,DVCampoLivre, ANossoNumero : String;
begin

    FatorVencimento := CalcularFatorVencimento(ACBrTitulo.Vencimento);
    
    ANossoNumero := FormataNossoNumero(ACBrTitulo);

    {Montando Campo Livre}
    CampoLivre := padR(ACBrTitulo.ACBrBoleto.Cedente.CodigoCedente,6,'0') +
                  CalcularDVCedente(ACBrTitulo) + Copy(ANossoNumero,3,3)  +
                  Copy(ANossoNumero,1,1) + Copy(ANossoNumero,6,3)         +
                  '4' + Copy(ANossoNumero,9,9);

    Modulo.CalculoPadrao;
    Modulo.MultiplicadorFinal   := 2;
    Modulo.MultiplicadorInicial := 9;
    Modulo.Documento := CampoLivre;
    Modulo.Calcular;
    DVCampoLivre := intTostr(Modulo.ModuloFinal);

    if Length(DVCampoLivre) > 1 then
       DVCampoLivre := '0';

    CampoLivre := CampoLivre + DVCampoLivre;
    
    {Codigo de Barras}
    with ACBrTitulo.ACBrBoleto do
    begin
       CodigoBarras := IntToStrZero(Banco.Numero, 3) +
                       '9' +
                       FatorVencimento +
                       IntToStrZero(Round(ACBrTitulo.ValorDocumento * 100), 10) +
                       CampoLivre;
    end;

    DigitoCodBarras := CalcularDigitoCodigoBarras(CodigoBarras);
    Result:= copy( CodigoBarras, 1, 4) + DigitoCodBarras + copy( CodigoBarras, 5, 44);
end;

function TACBrCaixaEconomica.TipoOCorrenciaToCod(const TipoOcorrencia: TACBrTipoOcorrencia): String;
begin
  // DONE -oJacinto Junior: Ajustar para utilizar as ocorr�ncias corretas.
  // TODO -oJacinto Junior: Definir ocorr�ncias pendentes.
  case TipoOcorrencia of
//                                                   : Result := '01'; // Solicita��o de Impress�o de T�tulos Confirmada
    toRetornoRegistroConfirmado                    : Result := '02';
    toRetornoRegistroRecusado                      : Result := '03';
//                                                   : Result := '04'; // Transfer�ncia de Carteira/Entrada
//                                                   : Result := '05'; // Transfer�ncia de Carteira/Baixa
    toRetornoLiquidado                             : Result := '06';
    toRetornoRecebimentoInstrucaoConcederDesconto  : Result := '07';
    toRetornoRecebimentoInstrucaoCancelarDesconto  : Result := '08';
    toRetornoBaixado                               : Result := '09';
//    toRetornoAbatimentoConcedido                   : Result := '12';
    toRetornoRecebimentoInstrucaoConcederAbatimento: Result := '12';
//    toRetornoAbatimentoCancelado                   : Result := '13';
    toRetornoRecebimentoInstrucaoCancelarAbatimento: Result := '13';
//    toRetornoVencimentoAlterado                    : Result := '14';
    toRetornoRecebimentoInstrucaoAlterarVencimento : Result := '14';
    toRetornoRecebimentoInstrucaoProtestar         : Result := '19';
    toRetornoRecebimentoInstrucaoSustarProtesto    : Result := '20';
    toRetornoEntradaEmCartorio                     : Result := '23';
    toRetornoRetiradoDeCartorio                    : Result := '24';
    toRetornoBaixaPorProtesto                      : Result := '25';
    toRetornoInstrucaoRejeitada                    : Result := '26';
//                                                   : Result := '27'; // Confirma��o do Pedido de Altera��o de Outros Dados
    toRetornoDebitoTarifas                         : Result := '28';
    toRetornoAlteracaoOutrosDadosRejeitada         : Result := '30';
//                                                   : Result := '35'; // Confirma��o de Inclus�o Banco de Sacado
//                                                   : Result := '36'; // Confirma��o de Altera��o Banco de Sacado
//                                                   : Result := '37'; // Confirma��o de Exclus�o Banco de Sacado
//                                                   : Result := '38'; // Emiss�o de Bloquetos de Banco de Sacado
//                                                   : Result := '39'; // Manuten��o de Sacado Rejeitada
//                                                   : Result := '40'; // Entrada de T�tulo via Banco de Sacado Rejeitada
//                                                   : Result := '41'; // Manuten��o de Banco de Sacado Rejeitada
    toRetornoBaixaOuLiquidacaoEstornada            : Result := '44';
    toRetornoRecebimentoInstrucaoAlterarDados      : Result := '45';
  else
    Result := '00';
  end;

  // Implementa��o obsoleta.
  {***
//escol
  case TipoOcorrencia of
    toRetornoRegistroConfirmado                 : Result := '02';
    toRetornoRegistroRecusado                   : Result := '03';
    toRetornoLiquidado                          : Result := '06';
    toRetornoAbatimentoConcedido                : Result := '12';
    toRetornoAbatimentoCancelado                : Result := '13';
    toRetornoVencimentoAlterado                 : Result := '14';
    toRetornoRecebimentoInstrucaoProtestar      : Result := '19';
    toRetornoRecebimentoInstrucaoSustarProtesto : Result := '20';
    toRetornoInstrucaoRejeitada                 : Result:=  '26';
    toRetornoDebitoTarifas                      : Result := '28';
    toRetornoALteracaoOutrosDadosRejeitada      : Result := '30';
    toRetornoRecebimentoInstrucaoAlterarDados   : Result := '45';
  else
    Result := '00';
  end;
  ***}
end;

function TACBrCaixaEconomica.MontarCampoCodigoCedente (
   const ACBrTitulo: TACBrTitulo ) : String;
begin
  Result := RightStr(ACBrTitulo.ACBrBoleto.Cedente.Agencia,4)+ '/' +
            ACBrTitulo.ACBrBoleto.Cedente.CodigoCedente+ '-' +
                CalcularDVCedente(ACBrTitulo);
end;

function TACBrCaixaEconomica.MontarCampoNossoNumero (const ACBrTitulo: TACBrTitulo ) : String;
var ANossoNumero : string;
begin
    ANossoNumero := FormataNossoNumero(ACBrTitulo);

    Result := ANossoNumero + '-' + CalcularDigitoVerificador(ACBrTitulo);
end;

function TACBrCaixaEconomica.GerarRegistroHeader240(NumeroRemessa : Integer): String;
var
  ATipoInscricao: string;
begin

   with ACBrBanco.ACBrBoleto.Cedente do
   begin
      case TipoInscricao of
         pFisica  : ATipoInscricao := '1';
         pJuridica: ATipoInscricao := '2';
      end;

          { GERAR REGISTRO-HEADER DO ARQUIVO }

      Result:= IntToStrZero(ACBrBanco.Numero, 3)       + //1 a 3 - C�digo do banco
               '0000'                                  + //4 a 7 - Lote de servi�o
               '0'                                     + //8 - Tipo de registro - Registro header de arquivo
               padL('', 9, ' ')                        + //9 a 17 Uso exclusivo FEBRABAN/CNAB
               ATipoInscricao                          + //18 - Tipo de inscri��o do cedente
               padR(OnlyNumber(CNPJCPF), 14, '0')      + //19 a 32 -N�mero de inscri��o do cedente
               //padL(CodigoCedente, 18, '0') + '  '     + //33 a 52 - C�digo do conv�nio no banco [ Alterado conforme instru��es da CSO Bras�lia ] 27-07-09
               padL('',20, '0')                        +  //33 a 52 - C�digo do conv�nio no banco
               padR(OnlyNumber(Agencia), 5, '0')       + //53 a 57 - C�digo da ag�ncia do cedente
               padL(AgenciaDigito, 1 , '0')            + //58 - D�gito da ag�ncia do cedente
               padR(CodigoCedente, 6, '0')             + //59 a 64 - C�digo Cedente (C�digo do Conv�nio no Banco)
               padL('', 7, '0')                        + //65 a 71 - Uso Exclusivo CAIXA
               '0'                                     + //72 - Uso Exclusivo CAIXA
               padL(Nome, 30, ' ')                     + //73 a 102 - Nome do cedente
               padL('CAIXA ECONOMICA FEDERAL', 30, ' ') + //103 a 132 - Nome do banco
               padL('', 10, ' ')                       + //133 a 142 - Uso exclusivo FEBRABAN/CNAB
               '1'                                     + //143 - C�digo de Remessa (1) / Retorno (2)
               FormatDateTime('ddmmyyyy', Now)         + //144 a 151 - Data do de gera��o do arquivo
               FormatDateTime('hhmmss', Now)           + //152 a 157 - Hora de gera��o do arquivo
               padR(IntToStr(NumeroRemessa), 6, '0')   + //158 a 163 - N�mero seq�encial do arquivo
               '050'                                   + //164 a 166 - N�mero da vers�o do layout do arquivo
               padL('',  5, '0')                       + //167 a 171 - Densidade de grava��o do arquivo (BPI)
               Space(20)                               + // 172 a 191 - Uso reservado do banco
               padL('REMESSA-PRODUCAO', 20, ' ')       + // 192 a 211 - Uso reservado da empresa
               padL('', 4, ' ')                        + // 212 a 215 - Versao Aplicativo Caixa
               padL('', 25, ' ');                        // 216 a 240 - Uso Exclusivo FEBRABAN / CNAB

          { GERAR REGISTRO HEADER DO LOTE }

      Result:= Result + #13#10 +
               IntToStrZero(ACBrBanco.Numero, 3)       + //1 a 3 - C�digo do banco
               '0001'                                  + //4 a 7 - Lote de servi�o
               '1'                                     + //8 - Tipo de registro - Registro header de arquivo
               'R'                                     + //9 - Tipo de opera��o: R (Remessa) ou T (Retorno)
               '01'                                    + //10 a 11 - Tipo de servi�o: 01 (Cobran�a)
               '00'                                    + //12 a 13 - Forma de lan�amento: preencher com ZEROS no caso de cobran�a
               '030'                                   + //14 a 16 - N�mero da vers�o do layout do lote
               ' '                                     + //17 - Uso exclusivo FEBRABAN/CNAB
               ATipoInscricao                          + //18 - Tipo de inscri��o do cedente
               padR(OnlyNumber(CNPJCPF), 15, '0')      + //19 a 33 -N�mero de inscri��o do cedente
               padR(CodigoCedente, 6, '0')             + //34 a 39 - C�digo do conv�nio no banco (c�digo do cedente)
               padL('', 14, '0')                       + //40 a 53 - Uso Exclusivo Caixa
               padR(OnlyNumber(Agencia), 5 , '0')      + //54 a 58 - D�gito da ag�ncia do cedente
               padL(AgenciaDigito, 1 , '0')            + //59 - D�gito da ag�ncia do cedente
               padR(CodigoCedente, 6, '0')             + //60 a 65 - C�digo do conv�nio no banco (c�digo do cedente)
               padL('',7,'0')                          + //66 a 72 - C�digo do Modelo Personalizado (C�digo fornecido pela CAIXA/gr�fica, utilizado somente quando o modelo do bloqueto for personalizado)
               '0'                                     + //73 - Uso Exclusivo Caixa
               padL(Nome, 30, ' ')                     + //74 a 103 - Nome do cedente
               padL('', 40, ' ')                       + //104 a 143 - Mensagem 1 para todos os boletos do lote
               padL('', 40, ' ')                       + //144 a 183 - Mensagem 2 para todos os boletos do lote
               padR(IntToStr(NumeroRemessa), 8, '0')   + //184 a 191 - N�mero do arquivo
               FormatDateTime('ddmmyyyy', Now)         + //192 a 199 - Data de gera��o do arquivo
               padL('', 8, '0')                        + //200 a 207 - Data do cr�dito - S� para arquivo retorno
               padL('', 33, ' ');                        //208 a 240 - Uso exclusivo FEBRABAN/CNAB
   end;
end;

function TACBrCaixaEconomica.GerarRegistroTransacao240(ACBrTitulo : TACBrTitulo): String;
var
  ATipoOcorrencia, ATipoBoleto, ADataMoraJuros         : String;
  ADataDesconto, ANossoNumero, ATipoAceite, AEspecieDoc: String;
begin
   with ACBrTitulo do
   begin
      ANossoNumero := FormataNossoNumero(ACBrTitulo);

      {SEGMENTO P}

      {Pegando o Tipo de Ocorrencia}
      // DONE -oJacinto Junior: Ajustar para utilizar as ocorr�ncias corretas.
      case OcorrenciaOriginal.Tipo of
        toRemessaBaixar                        : ATipoOcorrencia := '02';
        toRemessaConcederAbatimento            : ATipoOcorrencia := '04';
        toRemessaCancelarAbatimento            : ATipoOcorrencia := '05';
        toRemessaAlterarVencimento             : ATipoOcorrencia := '06';
        toRemessaConcederDesconto              : ATipoOcorrencia := '07';
        toRemessaCancelarDesconto              : ATipoOcorrencia := '08';
        toRemessaProtestar                     : ATipoOcorrencia := '09';
        toRemessaCancelarInstrucaoProtestoBaixa: ATipoOcorrencia := '10';
        toRemessaCancelarInstrucaoProtesto     : ATipoOcorrencia := '11';
        toRemessaDispensarJuros                : ATipoOcorrencia := '13';
        toRemessaAlterarNomeEnderecoSacado     : ATipoOcorrencia := '31';
      else
        ATipoOcorrencia := '01';
      end;

      // Implementa��o obsoleta.
      {***
      case OcorrenciaOriginal.Tipo of
         toRemessaBaixar                    : ATipoOcorrencia := '02';
         toRemessaConcederAbatimento        : ATipoOcorrencia := '04';
         toRemessaCancelarAbatimento        : ATipoOcorrencia := '05';
         toRemessaAlterarVencimento         : ATipoOcorrencia := '06';
         toRemessaConcederDesconto          : ATipoOcorrencia := '07';
         toRemessaCancelarDesconto          : ATipoOcorrencia := '08';
         toRemessaProtestar                 : ATipoOcorrencia := '09';
         toRemessaCancelarInstrucaoProtesto : ATipoOcorrencia := '10';
         toRemessaAlterarNomeEnderecoSacado : ATipoOcorrencia := '12';
         toRemessaDispensarJuros            : ATipoOcorrencia := '31';
      else
         ATipoOcorrencia := '01';
      end;
      ***}

      { Pegando o Aceite do Titulo }
      case Aceite of
         atSim :  ATipoAceite := 'A';
         atNao :  ATipoAceite := 'N';
      end;

      // DONE -oJacinto Junior: Utilizar a esp�cie correta do t�tulo.
      if AnsiSameText(EspecieDoc, 'CH') then
        AEspecieDoc := '01'
      else if AnsiSameText(EspecieDoc, 'DM') then
        AEspecieDoc := '02'
      else if AnsiSameText(EspecieDoc, 'DMI') then
        AEspecieDoc := '03'
      else if AnsiSameText(EspecieDoc, 'DS') then
        AEspecieDoc := '04'
      else if AnsiSameText(EspecieDoc, 'DSI') then
        AEspecieDoc := '05'
      else if AnsiSameText(EspecieDoc, 'DR') then
        AEspecieDoc := '06'
      else if AnsiSameText(EspecieDoc, 'LC') then
        AEspecieDoc := '07'
      else if AnsiSameText(EspecieDoc, 'NCC') then
        AEspecieDoc := '08'
      else if AnsiSameText(EspecieDoc, 'NCE') then
        AEspecieDoc := '09'
      else if AnsiSameText(EspecieDoc, 'NCI') then
        AEspecieDoc := '10'
      else if AnsiSameText(EspecieDoc, 'NCR') then
        AEspecieDoc := '11'
      else if AnsiSameText(EspecieDoc, 'NP') then
        AEspecieDoc := '12'
      else if AnsiSameText(EspecieDoc, 'NPR') then
        AEspecieDoc := '13'
      else if AnsiSameText(EspecieDoc, 'TM') then
        AEspecieDoc := '14'
      else if AnsiSameText(EspecieDoc, 'TS') then
        AEspecieDoc := '15'
      else if AnsiSameText(EspecieDoc, 'NS') then
        AEspecieDoc := '16'
      else if AnsiSameText(EspecieDoc, 'RC') then
        AEspecieDoc := '17'
      else if AnsiSameText(EspecieDoc, 'FAT') then
        AEspecieDoc := '18'
      else if AnsiSameText(EspecieDoc, 'ND') then
        AEspecieDoc := '19'
      else if AnsiSameText(EspecieDoc, 'AP') then
        AEspecieDoc := '20'
      else if AnsiSameText(EspecieDoc, 'ME') then
        AEspecieDoc := '21'
      else if AnsiSameText(EspecieDoc, 'PC') then
        AEspecieDoc := '22'
      else if AnsiSameText(EspecieDoc, 'NF') then
        AEspecieDoc := '23'
      else if AnsiSameText(EspecieDoc, 'DD') then
        AEspecieDoc := '24'
      else if AnsiSameText(EspecieDoc, 'CPR') then
        AEspecieDoc := '25'
      else
        AEspecieDoc := '99';

    // Implementa��o obsoleta.
//    { Pegando o tipo de EspecieDoc }
//    if EspecieDoc = 'DM' then
//      EspecieDoc := '02'
//    else if EspecieDoc = 'NP' then
//      EspecieDoc := '12'
//    else if EspecieDoc = 'NS' then
//      EspecieDoc := '16'
//    else if EspecieDoc = 'RC' then
//      EspecieDoc := '17'
//    else if EspecieDoc = 'LC' then
//      EspecieDoc := '07'
//    else if EspecieDoc = 'DS' then
//      EspecieDoc := '04'
//    else if EspecieDoc = 'ND' then
//      EspecieDoc := '19'
//    else
//      EspecieDoc := '02';
        
      {Pegando Tipo de Boleto} //Quem emite e quem distribui o boleto?
      case ACBrBoleto.Cedente.ResponEmissao of
         tbBancoEmite      : ATipoBoleto := '1' + '1';
         tbCliEmite        : ATipoBoleto := '2' + '0';
         tbBancoReemite    : ATipoBoleto := '4' + '1';
         tbBancoNaoReemite : ATipoBoleto := '5' + '2';
      end;

      {Mora Juros}
      if (ValorMoraJuros > 0) then
       begin
         // DONE -oJacinto Junior: Ajustar pois DataMoraJuros � do tipo inteiro e sempre ser� diferente de nulo.
//         if (DataMoraJuros <> Null) then
         if DataMoraJuros <> 0 then
            ADataMoraJuros := FormatDateTime('ddmmyyyy', DataMoraJuros)
         else
            ADataMoraJuros := padL('', 8, '0');
       end
      else
         ADataMoraJuros := padL('', 8, '0');

      {Descontos}
      if (ValorDesconto > 0) then
       begin
         if (DataDesconto <> Null) then
            ADataDesconto := FormatDateTime('ddmmyyyy', DataDesconto)
         else
            ADataDesconto := padL('', 8, '0');
       end
      else
         ADataDesconto := padL('', 8, '0');

      fValorTotalDocs:= fValorTotalDocs  + ValorDocumento;
      Result:= IntToStrZero(ACBrBanco.Numero, 3)                          + //1 a 3 - C�digo do banco
               '0001'                                                     + //4 a 7 - Lote de servi�o
               '3'                                                        + //8 - Tipo do registro: Registro detalhe
               IntToStrZero((3*ACBrBoleto.ListadeBoletos.IndexOf(ACBrTitulo))+1,5) + //9 a 13 - N�mero seq�encial do registro no lote - Cada t�tulo tem 2 registros (P e Q)
               'P'                                                        + //14 - C�digo do segmento do registro detalhe
               ' '                                                        + //15 - Uso exclusivo FEBRABAN/CNAB: Branco
               ATipoOcorrencia                                            + //16 a 17 - C�digo de movimento
               padR(OnlyNumber(ACBrBoleto.Cedente.Agencia), 5, '0')       + //18 a 22 - Ag�ncia mantenedora da conta
               padL(ACBrBoleto.Cedente.AgenciaDigito, 1 , '0')            + //23 -D�gito verificador da ag�ncia
               padL(ACBrBoleto.Cedente.CodigoCedente, 6, '0')             + //24 a 29 - C�digo do Conv�nio no Banco (Codigo do cedente)
               padL('', 11, '0')                                          + //30 a 40 - Uso Exclusivo da CAIXA
               '14'                                                       + //41 a 42 - Modalidade da Carteira
               padR(Copy(ANossoNumero,3,17), 15, '0')                     + //43 a 57 - Nosso n�mero - identifica��o do t�tulo no banco
               '1'                                                        + //58 - Cobran�a Simples
               '1'                                                        + //59 - Forma de cadastramento do t�tulo no banco: com cadastramento  1-cobran�a Registrada
               '2'                                                        + //60 - Tipo de documento: Tradicional
               ATipoBoleto                                                + //61 e 62(juntos)- Quem emite e quem distribui o boleto?
               padL(NumeroDocumento, 11, ' ')                             + //63 a 73 - N�mero que identifica o t�tulo na empresa
               padL('', 4, ' ')                                           + //74 a 77 - Uso Exclusivo Caixa
               FormatDateTime('ddmmyyyy', Vencimento)                     + //78 a 85 - Data de vencimento do t�tulo
               IntToStrZero( round( ValorDocumento * 100), 15)            + //86 a 100 - Valor nominal do t�tulo
               padL('', 5, '0')                                           + //101 a 105 - Ag�ncia cobradora. Se ficar em branco, a caixa determina automaticamente pelo CEP do sacado
               '0'                                                        + //106 - D�gito da ag�ncia cobradora
               // DONE -oJacinto Junior: Utilizar a esp�cie correta do t�tulo.
 //              padL(EspecieDoc,2)                                         + //107 a 108 - Esp�cie do documento
               padL(AEspecieDoc, 2)                                       + // 107 a 108 - Esp�cie do documento
               ATipoAceite                                                + //109 - Identifica��o de t�tulo Aceito / N�o aceito
               FormatDateTime('ddmmyyyy', DataDocumento)                  + //110 a 117 - Data da emiss�o do documento
               IfThen(ValorMoraJuros > 0, '1', '0')                       + //118 - C�digo de juros de mora: Valor por dia
               ADataMoraJuros                                             + //119 a 126 - Data a partir da qual ser�o cobrados juros
               IfThen(ValorMoraJuros > 0, IntToStrZero( round(ValorMoraJuros * 100), 15), padL('', 15, '0')) + //127 a 141 - Valor de juros de mora por dia
               IfThen(ValorDesconto > 0, '1', '0')                        + //142 - C�digo de desconto: Valor fixo at� a data informada
               ADataDesconto                                              + //143 a 150 - Data do desconto
               IfThen(ValorDesconto > 0, IntToStrZero( round(ValorDesconto * 100), 15),padL('', 15, '0'))+ //151 a 165 - Valor do desconto por dia
               IntToStrZero( round(ValorIOF * 100), 15)                   + //166 a 180 - Valor do IOF a ser recolhido
               IntToStrZero( round(ValorAbatimento * 100), 15)            + //181 a 195 - Valor do abatimento
               padL(IfThen(SeuNumero<>'',SeuNumero,NumeroDocumento), 25, ' ') + //196 a 220 - Identifica��o do t�tulo na empresa

               // DONE -oJacinto Junior: Ajustar pois DataProtesto � do tipo inteiro e sempre ser� diferente de nulo.
//               IfThen((DataProtesto <> null) and (DataProtesto > Vencimento), '1', '3') + //221 - C�digo de protesto: Protestar em XX dias corridos
//               IfThen((DataProtesto <> null) and (DataProtesto > Vencimento),
               IfThen((DataProtesto <> 0) and (DataProtesto > Vencimento), '1', '3') + //221 - C�digo de protesto: Protestar em XX dias corridos
               IfThen((DataProtesto <> 0) and (DataProtesto > Vencimento),
                    padR(IntToStr(DaysBetween(DataProtesto, Vencimento)), 2, '0'), '00') + //222 a 223 - Prazo para protesto (em dias corridos)

               // DONE -oJacinto Junior: Ajustar para permitir a baixa e devolu��o do t�tulo.
//               '2'                                                        + //224 - C�digo para baixa/devolu��o: N�o baixar/n�o devolver
//               padL('',3,'0')                                             + //225 a 227 - Prazo para baixa/devolu��o (em dias corridos)
               IfThen((DataBaixa <> 0) and (DataBaixa > Vencimento), '1', '2') + //224 - C�digo para baixa/devolu��o: N�o baixar/n�o devolver
               IfThen((DataBaixa <> 0) and (DataBaixa > Vencimento),
                 padR(IntToStr(DaysBetween(DataBaixa, Vencimento)), 3, '0'), '000') + //225 a 227 - Prazo para baixa/devolu��o (em dias corridos)

               '09'                                                       + //228 a 229 - C�digo da moeda: Real
               padL('', 10 , '0')                                         + //230 a 239 - Uso Exclusivo CAIXA
               ' ';                                                         //240 - Uso exclusivo FEBRABAN/CNAB

      {SEGMENTO Q}
      Result:= Result + #13#10 +
               IntToStrZero(ACBrBanco.Numero, 3)                          + //1 a 3 - C�digo do banco
               '0001'                                                     + //4 a 7 - N�mero do lote
               '3'                                                        + //8 - Tipo do registro: Registro detalhe
               IntToStrZero((3 * ACBrBoleto.ListadeBoletos.IndexOf(ACBrTitulo))+ 2 ,5) + //9 a 13 - N�mero seq�encial do registro no lote - Cada t�tulo tem 2 registros (P e Q)
               'Q'                                                        + //14 - C�digo do segmento do registro detalhe
               ' '                                                        + //15 - Uso exclusivo FEBRABAN/CNAB: Branco
               ATipoOcorrencia                                            + //16 a 17 - C�digo de movimento
                   {Dados do sacado}
               IfThen(Sacado.Pessoa = pJuridica,'2','1')                  + //18 - Tipo inscricao
               padR(OnlyNumber(Sacado.CNPJCPF), 15, '0')                  + //19 a 33 - N�mero de Inscri��o
               padL(Sacado.NomeSacado, 40, ' ')                           + //34 a 73 - Nome sacado
               padL(Sacado.Logradouro +' '+ Sacado.Numero +' '+ Sacado.Complemento , 40, ' ') + //74 a 113 - Endere�o
               padL(Sacado.Bairro, 15, ' ')                               + // 114 a 128 - bairro sacado
               padR(OnlyNumber(Sacado.CEP), 8, '0')                                   + // 129 a 133 e 134 a 136- cep sacado prefixo e sufixo sem o tra�o"-" somente numeros
               padL(Sacado.Cidade, 15, ' ')                               + // 137 a 151 - cidade sacado
               padL(Sacado.UF, 2, ' ')                                    + // 152 a 153 - UF sacado
                        {Dados do sacador/avalista}
               '0'                                                                            + // 154 a 154 - Tipo de inscri��o: N�o informado
               padL('', 15, '0')                                                              + // 155 a 169 - N�mero de inscri��o
               padL('', 40, ' ')                                                              + // 170 a 209 - Nome do sacador/avalista
               padL('', 3, ' ')                                                               + // 210 a 212 - Uso exclusivo FEBRABAN/CNAB
               padL('',20, ' ')                                                               + // 213 a 232 - Uso exclusivo FEBRABAN/CNAB
               padL('', 8, ' ');                                                                // 233 a 240 - Uso exclusivo FEBRABAN/CNAB

 {SEGMENTO R}
      Result:= Result + #13#10 +
               IntToStrZero(ACBrBanco.Numero, 3)                                           + //   1 a 3   - C�digo do banco
               '0001'                                                                      + //   4 a 7   - N�mero do lote
               '3'                                                                         + //   8 a 8   - Tipo do registro: Registro detalhe
               IntToStrZero((3 * ACBrBoleto.ListadeBoletos.IndexOf(ACBrTitulo))+ 3 ,5)     + //   9 a 13  - N�mero seq�encial do registro no lote - Cada t�tulo tem 2 registros (P e Q)
               'R'                                                                         + //  14 a 14  - C�digo do segmento do registro detalhe
               ' '                                                                         + //  15 a 15  - Uso exclusivo FEBRABAN/CNAB: Branco
               ATipoOcorrencia                                                             + //  16 a 17  - Tipo Ocorrencia
               padR('', 1,  '0')                                                           + //  18 a 18  - Codigo do Desconto 2
               padR('', 8,  ' ')                                                           + //  19 a 26  - Data do Desconto 2
               padR('', 15, '0')                                                           + //  27 a 41  - Valor/Percentual a ser concedido
               padR('', 1,  '0')                                                           + //  42 a 42  - C�digo do Desconto 3
               padR('', 8,  ' ')                                                           + //  43 a 50  - Data do Desconto 3
               padR('', 15, '0')                                                           + //  51 a 65  - Valor/Percentual a ser concedido
               IfThen((PercentualMulta <> null) and (PercentualMulta > 0), '2', '0')       + //  66 a 66  - C�digo da Multa
               FormatDateTime('ddmmyyyy',Vencimento)                                       + //  67 a 74  - Data da Multa
               IfThen(PercentualMulta > 0, IntToStrZero(round(PercentualMulta * 100), 15),
                      padL('', 15, '0'))                                                   + //  75 a 89  - Valor/Percentual a ser aplicado
               PadL('', 10, ' ')                                                           + //  90 a 99  - Informa��o ao Sacado
               PadL('', 40, ' ')                                                           + // 100 a 139 - Mensagem 3
               PadL('', 40, ' ')                                                           + // 140 a 179 - Mensagem 4
               PadL('', 50, ' ')                                                           + // 180 a 229 - Email do Sacado P/ Envio de Informacoes
               PadL('', 11, ' ');                                                            // 230 a 240 - Uso Exclusivo Febraban/CNAB
      end;
end;

function TACBrCaixaEconomica.GerarRegistroTrailler240( ARemessa : TStringList ): String;
begin
   {REGISTRO TRAILER DO LOTE}
   Result:= IntToStrZero(ACBrBanco.Numero, 3)                          + //C�digo do banco
            '0001'                                                     + //Lote de Servi�o
            '5'                                                        + //Tipo do registro: Registro trailer do lote
            Space(9)                                                   + //Uso exclusivo FEBRABAN/CNAB
            IntToStrZero((3*ARemessa.Count), 6)                        + //Quantidade de Registro no Lote
            IntToStrZero((ARemessa.Count-1), 6)+ // padL('', 6, '0')                                           + //Quantidade t�tulos em cobran�a
            IntToStrZero( round( fValorTotalDocs * 100), 17)+ // padL('',17, '0')                                           + //Valor dos t�tulos em carteiras}
            padL('', 6, '0')                                           + //Quantidade t�tulos em cobran�a
            padL('',17, '0')                                           + //Valor dos t�tulos em carteiras}
            padL('',6,  '0')                                           + //Quantidade t�tulos em cobran�a
            padL('',17, '0')                                           + //Quantidade de T�tulos em Carteiras
            padL('',31, ' ')                                           + //Uso exclusivo FEBRABAN/CNAB
            padL('',117,' ')                                           ; //Uso exclusivo FEBRABAN/CNAB}

   {GERAR REGISTRO TRAILER DO ARQUIVO}
   Result:= Result + #13#10 +
            IntToStrZero(ACBrBanco.Numero, 3)                          + //C�digo do banco
            '9999'                                                     + //Lote de servi�o
            '9'                                                        + //Tipo do registro: Registro trailer do arquivo
            padL('',9,' ')                                             + //Uso exclusivo FEBRABAN/CNAB}
            '000001'                                                   + //Quantidade de lotes do arquivo}
            IntToStrZero((3*ARemessa.Count)+2, 6)                      + //Quantidade de registros do arquivo, inclusive este registro que est� sendo criado agora}
            padL('',6,' ')                                             + //Uso exclusivo FEBRABAN/CNAB}
            padL('',205,' ');                                            //Uso exclusivo FEBRABAN/CNAB}
end;
procedure TACBrCaixaEconomica.LerRetorno240(ARetorno: TStringList);
var
  ContLinha: Integer;
  Titulo   : TACBrTitulo;
  Linha, rCedente, rCNPJCPF: String;
  rAgencia, rConta,rDigitoConta: String;
  MotivoLinha, I, CodMotivo: Integer;
begin
   ContLinha := 0;

   if (copy(ARetorno.Strings[0],1,3) <> '104') then
      raise Exception.Create(ACBrStr(ACBrBanco.ACBrBoleto.NomeArqRetorno +
                             'n�o � um arquivo de retorno do '+ Nome));

   rCedente := trim(Copy(ARetorno[0],73,30));
   rAgencia := trim(Copy(ARetorno[0],53,5));
   rConta   := trim(Copy(ARetorno[0],59,5));
   rDigitoConta := Copy(ARetorno[0],64,1);
   ACBrBanco.ACBrBoleto.NumeroArquivo := StrToIntDef(Copy(ARetorno[0], 158, 6), 0);

   ACBrBanco.ACBrBoleto.DataArquivo   := StringToDateTimeDef(Copy(ARetorno[1],192,2)+'/'+
                                                             Copy(ARetorno[1],194,2)+'/'+
                                                             Copy(ARetorno[1],198,2),0, 'DD/MM/YY' );

   if StrToIntDef(Copy(ARetorno[1],200,6),0) <> 0 then
      ACBrBanco.ACBrBoleto.DataCreditoLanc := StringToDateTimeDef(Copy(ARetorno[1],200,2)+'/'+
                                                                  Copy(ARetorno[1],202,2)+'/'+
                                                                  Copy(ARetorno[1],204,4),0, 'DD/MM/YY' );
   rCNPJCPF := trim( Copy(ARetorno[0],19,14)) ;

   if ACBrBanco.ACBrBoleto.Cedente.TipoInscricao = pJuridica then
    begin
      rCNPJCPF := trim( Copy(ARetorno[1],19,15));
      rCNPJCPF := RightStr(rCNPJCPF,14) ;
    end
   else
    begin
      rCNPJCPF := trim( Copy(ARetorno[1],23,11));
      rCNPJCPF := RightStr(rCNPJCPF,11) ;
    end;


   with ACBrBanco.ACBrBoleto do
   begin

      if (not LeCedenteRetorno) and (rCNPJCPF <> OnlyNumber(Cedente.CNPJCPF)) then
         raise Exception.Create(ACBrStr('CNPJ\CPF do arquivo inv�lido'));

      if (not LeCedenteRetorno) and ((rAgencia <> OnlyNumber(Cedente.Agencia)) or
          (rConta+rDigitoConta  <> OnlyNumber(Cedente.CodigoCedente))) then
         raise Exception.Create(ACBrStr('Agencia\Conta do arquivo inv�lido'));

      if LeCedenteRetorno then
      begin
         Cedente.Nome    := rCedente;
         Cedente.CNPJCPF := rCNPJCPF;
         Cedente.Agencia := rAgencia;
         Cedente.AgenciaDigito:= '0';
         Cedente.Conta   := rConta;
         Cedente.ContaDigito:= rDigitoConta;
         Cedente.CodigoCedente:= rConta+rDigitoConta;

         case StrToIntDef(Copy(ARetorno[1],18,1),0) of
            1: Cedente.TipoInscricao:= pFisica;
            2: Cedente.TipoInscricao:= pJuridica;
            else
               Cedente.TipoInscricao:= pJuridica;
         end;
      end;

      ACBrBanco.ACBrBoleto.ListadeBoletos.Clear;
   end;

   for ContLinha := 1 to ARetorno.Count - 2 do
   begin
      Linha := ARetorno[ContLinha] ;

      {Segmento T - S� cria ap�s passar pelo seguimento T depois U}
      if Copy(Linha,14,1)= 'T' then
         Titulo := ACBrBanco.ACBrBoleto.CriarTituloNaLista;

      with Titulo do
      begin
         {Segmento T}
         if Copy(Linha,14,1)= 'T' then
          begin
            SeuNumero                   := copy(Linha,59,11);
            NumeroDocumento             := copy(Linha,59,11);
            OcorrenciaOriginal.Tipo     := CodOcorrenciaToTipo(StrToIntDef(copy(Linha,16,2),0));

            //05 = Liquida��o Sem Registro
            Vencimento := StringToDateTimeDef( Copy(Linha,74,2)+'/'+
                                               Copy(Linha,76,2)+'/'+
                                               Copy(Linha,80,2),0, 'DD/MM/YY' );

            ValorDocumento       := StrToFloatDef(Copy(Linha,82,15),0)/100;
            ValorDespesaCobranca := StrToFloatDef(Copy(Linha,199,15),0)/100;
            NossoNumero          := Copy(Linha,42,15);  
            Carteira             := Copy(Linha,40,2);
            CodigoLiquidacao     := Copy(Linha,214,02);
            CodigoLiquidacaoDescricao := CodigoLiquidacao_Descricao( StrToIntDef(CodigoLiquidacao,0) );

            // DONE -oJacinto Junior: Implementar a leitura dos motivos das ocorr�ncias.
            MotivoLinha := 214;

            for I := 0 to 4 do
            begin
              CodMotivo := StrToIntDef(IfThen(Copy(Linha, MotivoLinha, 2) = '00', '00', Copy(Linha, MotivoLinha, 2)), 0);

              if CodMotivo <> 0 then
              begin
                MotivoRejeicaoComando.Add(IfThen(Copy(Linha, MotivoLinha, 2) = '00', '00', Copy(Linha, MotivoLinha, 2)));
                DescricaoMotivoRejeicaoComando.Add(CodMotivoRejeicaoToDescricao(OcorrenciaOriginal.Tipo, CodMotivo));
              end;

              MotivoLinha := MotivoLinha + 2; // Incrementa a coluna dos motivos.
            end;
          end
         {Ssegmento U}
         else if Copy(Linha,14,1)= 'U' then
          begin

            if StrToIntDef(Copy(Linha,138,6),0) <> 0 then
               DataOcorrencia := StringToDateTimeDef( Copy(Linha,138,2)+'/'+
                                                      Copy(Linha,140,2)+'/'+
                                                      Copy(Linha,142,4),0, 'DD/MM/YYYY' );

            if StrToIntDef(Copy(Linha,146,6),0) <> 0 then
               DataCredito:= StringToDateTimeDef( Copy(Linha,146,2)+'/'+
                                                  Copy(Linha,148,2)+'/'+
                                                  Copy(Linha,150,4),0, 'DD/MM/YYYY' );

            ValorMoraJuros       := StrToFloatDef(Copy(Linha,18,15),0)/100;
            ValorDesconto        := StrToFloatDef(Copy(Linha,33,15),0)/100;
            ValorAbatimento      := StrToFloatDef(Copy(Linha,48,15),0)/100;
            ValorIOF             := StrToFloatDef(Copy(Linha,63,15),0)/100;
            ValorRecebido        := StrToFloatDef(Copy(Linha,93,15),0)/100;
            ValorOutrasDespesas  := StrToFloatDef(Copy(Linha,108,15),0)/100;
            ValorOutrosCreditos  := StrToFloatDef(Copy(Linha,123,15),0)/100;
         end
        {Segmento W}
        else if Copy(Linha, 14, 1) = 'W' then
         begin
           //verifica o motivo de rejei��o
           MotivoRejeicaoComando.Add(copy(Linha,29,2));
           DescricaoMotivoRejeicaoComando.Add(CodMotivoRejeicaoToDescricao(
                                              CodOcorrenciaToTipo(
                                              StrToIntDef(copy(Linha, 16, 2), 0)),
                                              StrToInt(Copy(Linha, 29, 2))));
         end;
      end;
   end;

end;
function TACBrCaixaEconomica.CodOcorrenciaToTipo(
  const CodOcorrencia: Integer): TACBrTipoOcorrencia;
begin
  // DONE -oJacinto Junior: Ajustar para utilizar as ocorr�ncias corretas.
  // TODO -oJacinto Junior: Definir ocorr�ncias pendentes.
  case CodOcorrencia of
//    01: Result := ; // Solicita��o de Impress�o de T�tulos Confirmada
    02: Result := toRetornoRegistroConfirmado;
    03: Result := toRetornoRegistroRecusado;
//    04: Result := ; // Transfer�ncia de Carteira/Entrada
//    05: Result := ; // Transfer�ncia de Carteira/Baixa
    06: Result := toRetornoLiquidado;
    07: Result := toRetornoRecebimentoInstrucaoConcederDesconto;
    08: Result := toRetornoRecebimentoInstrucaoCancelarDesconto;
    09: Result := toRetornoBaixado;
//    12: Result := toRetornoAbatimentoConcedido;
    12: Result := toRetornoRecebimentoInstrucaoConcederAbatimento;
//    13: Result := toRetornoAbatimentoCancelado;
    13: Result := toRetornoRecebimentoInstrucaoCancelarAbatimento;
//    14: Result := toRetornoVencimentoAlterado;
    14: Result := toRetornoRecebimentoInstrucaoAlterarVencimento;
    19: Result := toRetornoRecebimentoInstrucaoProtestar;
    20: Result := toRetornoRecebimentoInstrucaoSustarProtesto;
    23: Result := toRetornoEntradaEmCartorio;
    24: Result := toRetornoRetiradoDeCartorio;
    25: Result := toRetornoBaixaPorProtesto;
    26: Result := toRetornoInstrucaoRejeitada;
//    27: Result := ; // Confirma��o do Pedido de Altera��o de Outros Dados
    28: Result := toRetornoDebitoTarifas;
    30: Result := toRetornoAlteracaoOutrosDadosRejeitada;
//    35: Result := ; // Confirma��o de Inclus�o Banco de Sacado
//    36: Result := ; // Confirma��o de Altera��o Banco de Sacado
//    37: Result := ; // Confirma��o de Exclus�o Banco de Sacado
//    38: Result := ; // Emiss�o de Bloquetos de Banco de Sacado
//    39: Result := ; // Manuten��o de Sacado Rejeitada
//    40: Result := ; // Entrada de T�tulo via Banco de Sacado Rejeitada
//    41: Result := ; // Manuten��o de Banco de Sacado Rejeitada
    44: Result := toRetornoBaixaOuLiquidacaoEstornada;
    45: Result := toRetornoRecebimentoInstrucaoAlterarDados;
  else
    Result := toRetornoOutrasOcorrencias;
  end;

  // Implementa��o obsoleta.
  {***
  case CodOcorrencia of
    02: Result := toRetornoRegistroConfirmado;
    03: Result := toRetornoRegistroRecusado;
    06: Result := toRetornoLiquidado;
    12: Result := toRetornoAbatimentoConcedido;
    13: Result := toRetornoAbatimentoCancelado;
    14: Result := toRetornoVencimentoAlterado;
    19: Result := toRetornoRecebimentoInstrucaoProtestar;
    20: Result := toRetornoRecebimentoInstrucaoSustarProtesto;
    26: Result := toRetornoInstrucaoRejeitada;
    28: Result := toRetornoDebitoTarifas;
    30: Result := toRetornoALteracaoOutrosDadosRejeitada;
    45: Result := toRetornoRecebimentoInstrucaoAlterarDados;
  else
    Result := toRetornoOutrasOcorrencias;
  end;
  ***}
end;

function TACBrCaixaEconomica.CodMotivoRejeicaoToDescricao(const TipoOcorrencia: TACBrTipoOcorrencia; CodMotivo: Integer): string;
begin
  // DONE -oJacinto Junior: Ajustar para utilizar as descri��es corretas conforme a ocorr�ncia.
  case TipoOcorrencia of
    toRetornoRegistroConfirmado, toRetornoRegistroRecusado,
      toRetornoInstrucaoRejeitada, toRetornoALteracaoOutrosDadosRejeitada:
    case CodMotivo of
      01: Result := '01-C�digo do Banco Inv�lido';
      02: Result := '02-C�digo do Registro Inv�lido';
      03: Result := '03-C�digo do Segmento Inv�lido';
      04: Result := '04-C�digo do Movimento n�o Permitido p/ Carteira';
      05: Result := '05-C�digo do Movimento Inv�lido';
      06: Result := '06-Tipo N�mero Inscri��o Cedente Inv�lido';
      07: Result := '07-Agencia/Conta/DV Inv�lidos';
      08: Result := '08-Nosso N�mero Inv�lido';
      09: Result := '09-Nosso N�mero Duplicado';
      10: Result := '10-Carteira Inv�lida';
      11: Result := '11-Data de Gera��o Inv�lida';
      12: Result := '12-Tipo de Documento Inv�lido';
      13: Result := '13-Identif. Da Emiss�o do Bloqueto Inv�lida';
      14: Result := '14-Identif. Da Distribui��o do Bloqueto Inv�lida';
      15: Result := '15-Caracter�sticas Cobran�a Incompat�veis';
      16: Result := '16-Data de Vencimento Inv�lida';
      17: Result := '17-Data de Vencimento Anterior a Data de Emiss�o';
      18: Result := '18-Vencimento fora do prazo de opera��o';
      19: Result := '19-T�tulo a Cargo de Bco Correspondentes c/ Vencto Inferior a XX Dias';
      20: Result := '20-Valor do T�tulo Inv�lido';
      21: Result := '21-Esp�cie do T�tulo Inv�lida';
      22: Result := '22-Esp�cie do T�tulo N�o Permitida para a Carteira';
      23: Result := '23-Aceite Inv�lido';
      24: Result := '24-Data da Emiss�o Inv�lida';
      25: Result := '25-Data da Emiss�o Posterior a Data de Entrada';
      26: Result := '26-C�digo de Juros de Mora Inv�lido';
      27: Result := '27-Valor/Taxa de Juros de Mora Inv�lido';
      28: Result := '28-C�digo do Desconto Inv�lido';
      29: Result := '29-Valor do Desconto Maior ou Igual ao Valor do T�tulo';
      30: Result := '30-Desconto a Conceder N�o Confere';
      31: Result := '31-Concess�o de Desconto - J� Existe Desconto Anterior';
      32: Result := '32-Valor do IOF Inv�lido';
      33: Result := '33-Valor do Abatimento Inv�lido';
      34: Result := '34-Valor do Abatimento Maior ou Igual ao Valor do T�tulo';
      35: Result := '35-Valor Abatimento a Conceder N�o Confere';
      36: Result := '36-Concess�o de Abatimento - J� Existe Abatimento Anterior';
      37: Result := '37-C�digo para Protesto Inv�lido';
      38: Result := '38-Prazo para Protesto Inv�lido';
      39: Result := '39-Pedido de Protesto N�o Permitido para o T�tulo';
      40: Result := '40-T�tulo com Ordem de Protesto Emitida';
      41: Result := '41-Pedido Cancelamento/Susta��o p/ T�tulos sem Instru��o Protesto';
      42: Result := '42-C�digo para Baixa/Devolu��o Inv�lido';
      43: Result := '43-Prazo para Baixa/Devolu��o Inv�lido';
      44: Result := '44-C�digo da Moeda Inv�lido';
      45: Result := '45-Nome do Sacado N�o Informado';
      46: Result := '46-Tipo/N�mero de Inscri��o do Sacado Inv�lidos';
      47: Result := '47-Endere�o do Sacado N�o Informado';
      48: Result := '48-CEP Inv�lido';
      49: Result := '49-CEP Sem Pra�a de Cobran�a (N�o Localizado)';
      50: Result := '50-CEP Referente a um Banco Correspondente';
      51: Result := '51-CEP incompat�vel com a Unidade da Federa��o';
      52: Result := '52-Unidade da Federa��o Inv�lida';
      53: Result := '53-Tipo/N�mero de Inscri��o do Sacador/Avalista Inv�lidos';
      54: Result := '54-Sacador/Avalista N�o Informado';
      55: Result := '55-Nosso n�mero no Banco Correspondente N�o Informado';
      56: Result := '56-C�digo do Banco Correspondente N�o Informado';
      57: Result := '57-C�digo da Multa Inv�lido';
      58: Result := '58-Data da Multa Inv�lida';
      59: Result := '59-Valor/Percentual da Multa Inv�lido';
      60: Result := '60-Movimento para T�tulo N�o Cadastrado. Erro gen�rico para as situa��es:' + #13#10
                      + '"Cedente n�o cadastrado" ou' + #13#10
                      + '"Ag�ncia Cedente n�o cadastrada ou desativada"';
      61: Result := '61-Altera��o da Ag�ncia Cobradora/DV Inv�lida';
      62: Result := '62-Tipo de Impress�o Inv�lido';
      63: Result := '63-Entrada para T�tulo j� Cadastrado';
      64: Result := '64-Entrada Inv�lida para Cobran�a Caucionada';
      65: Result := '65-CEP do Sacado n�o encontrado';
      66: Result := '66-Agencia Cobradora n�o encontrada';
      67: Result := '67-Agencia Cedente n�o encontrada';
      68: Result := '68-Movimenta��o inv�lida para t�tulo';
      69: Result := '69-Altera��o de dados inv�lida';
      70: Result := '70-Apelido do cliente n�o cadastrado';
      71: Result := '71-Erro na composi��o do arquivo';
      72: Result := '72-Lote de servi�o inv�lido';
      73: Result := '73-C�digo do Cedente inv�lido';
      74: Result := '74-Cedente n�o pertencente a Cobran�a Eletr�nica';
      75: Result := '75-Nome da Empresa inv�lido';
      76: Result := '76-Nome do Banco inv�lido';
      77: Result := '77-C�digo da Remessa inv�lido';
      78: Result := '78-Data/Hora Gera��o do arquivo inv�lida';
      79: Result := '79-N�mero Sequencial do arquivo inv�lido';
      80: Result := '80-Vers�o do Lay out do arquivo inv�lido';
      81: Result := '81-Literal REMESSA-TESTE - V�lido s� p/ fase testes';
      82: Result := '82-Literal REMESSA-TESTE - Obrigat�rio p/ fase testes';
      83: Result := '83-Tp N�mero Inscri��o Empresa inv�lido';
      84: Result := '84-Tipo de Opera��o inv�lido';
      85: Result := '85-Tipo de servi�o inv�lido';
      86: Result := '86-Forma de lan�amento inv�lido';
      87: Result := '87-N�mero da remessa inv�lido';
      88: Result := '88-N�mero da remessa menor/igual remessa anterior';
      89: Result := '89-Lote de servi�o divergente';
      90: Result := '90-N�mero sequencial do registro inv�lido';
      91: Result := '91-Erro seq de segmento do registro detalhe';
      92: Result := '92-Cod movto divergente entre grupo de segm';
      93: Result := '93-Qtde registros no lote inv�lido';
      94: Result := '94-Qtde registros no lote divergente';
      95: Result := '95-Qtde lotes no arquivo inv�lido';
      96: Result := '96-Qtde lotes no arquivo divergente';
      97: Result := '97-Qtde registros no arquivo inv�lido';
      98: Result := '98-Qtde registros no arquivo divergente';
      99: Result := '99-C�digo de DDD inv�lido';
    else
      Result := IntToStrZero(CodMotivo, 2) + ' - Outros Motivos';
    end;

    toRetornoDebitoTarifas:
    case CodMotivo of
      01: Result := '01-Tarifa de Extrato de Posi��o';
      02: Result := '02-Tarifa de Manuten��o de T�tulo Vencido';
      03: Result := '03-Tarifa de Susta��o';
      04: Result := '04-Tarifa de Protesto';
      05: Result := '05-Tarifa de Outras Instru��es';
      06: Result := '06-Tarifa de Outras Ocorr�ncias';
      07: Result := '07-Tarifa de Envio de Duplicata ao Sacado';
      08: Result := '08-Custas de Protesto';
      09: Result := '09-Custas de Susta��o de Protesto';
      10: Result := '10-Custas de Cart�rio Distribuidor';
      11: Result := '11-Custas de Edital';
      12: Result := '12-Redisponibiliza��o de Arquivo Retorno Eletr�nico';
      13: Result := '13-Tarifa Sobre Registro Cobrada na Baixa/Liquida��o';
      14: Result := '14-Tarifa Sobre Reapresenta��o Autom�tica';
      15: Result := '15-Banco de Sacados';
      16: Result := '16-Tarifa Sobre Informa��es Via Fax';
      17: Result := '17-Entrega Aviso Disp Bloqueto via e-amail ao sacado (s/ emiss�o Bloqueto)';
      18: Result := '18-Emiss�o de Bloqueto Pr�-impresso CAIXA matricial';
      19: Result := '19-Emiss�o de Bloqueto Pr�-impresso CAIXA A4';
      20: Result := '20-Emiss�o de Bloqueto Padr�o CAIXA';
      21: Result := '21-Emiss�o de Bloqueto/Carn�';
      31: Result := '31-Emiss�o de Aviso de Vencido';
      42: Result := '42-Altera��o cadastral de dados do t�tulo - sem emiss�o de aviso';
      45: Result := '45-Emiss�o de 2� via de Bloqueto Cobran�a Registrada';
    else
      Result := IntToStrZero(CodMotivo, 2) + ' - Outros Motivos';
    end;

    toRetornoLiquidado, toRetornoBaixado:
    case CodMotivo of
      02: Result := '02-Casa Lot�rica';
      03: Result := '03-Ag�ncias CAIXA';
      04: Result := '04-Compensa��o Eletr�nica';
      05: Result := '05-Compensa��o Convencional';
      06: Result := '06-Internet Banking';
      07: Result := '07-Correspondente Banc�rio';
      08: Result := '08-Em Cart�rio';
      09: Result := '09-Comandada Banco';
      10: Result := '10-Comandada Cliente via Arquivo';
      11: Result := '11-Comandada Cliente On-line';
      12: Result := '12-Decurso Prazo - Cliente';
      13: Result := '13-Decurso Prazo - Banco';
      14: Result := '14-Protestado';
    else
      Result := IntToStrZero(CodMotivo, 2) + ' - Outros Motivos';
    end;
  end;

  {***
  case TipoOcorrencia of
    toRetornoRegistroConfirmado,
      toRetornoRegistroRecusado,
      toRetornoInstrucaoRejeitada,
      toRetornoALteracaoOutrosDadosRejeitada:
      case CodMotivo of
        01: Result := '01-C�digo do banco inv�lido';
        02: Result := '02-C�digo do registro inv�lido';
        03: Result := '03-C�digo do segmento inv�lido';
        05: Result := '05-C�digo de movimento inv�lido';
        06: Result := '06-Tipo/n�mero de inscri��o do cedente inv�lido';
        07: Result := '07-Ag�ncia/Conta/DV inv�lido';
        08: Result := '08-Nosso n�mero inv�lido';
        09: Result := '09-Nosso n�mero duplicado';
        10: Result := '10-Carteira inv�lida';
        11: Result := '11-Forma de cadastramento do t�tulo inv�lido';
        12: Result := '12-Tipo de documento inv�lido';
        13: Result := '13-Identifica��o da emiss�o do bloqueto inv�lida';
        14: Result := '14-Identifica��o da distribui��o do bloqueto inv�lida';
        15: Result := '15-Caracter�sticas da cobran�a incompat�veis';
        16: Result := '16-Data de vencimento inv�lida';
        20: Result := '20-Valor do t�tulo inv�lido';
        21: Result := '21-Esp�cie do t�tulo inv�lida';
        23: Result := '23-Aceite inv�lido';
        24: Result := '24-Data da emiss�o inv�lida';
        26: Result := '26-C�digo de juros de mora inv�lido';
        27: Result := '27-Valor/Taxa de juros de mora inv�lido';
        28: Result := '28-C�digo do desconto inv�lido';
        29: Result := '29-Valor do desconto maior ou igual ao valor do t�tulo';
        30: Result := '30-Desconto a conceder n�o confere';
        32: Result := '32-Valor do IOF inv�lido';
        33: Result := '33-Valor do abatimento inv�lido';
        37: Result := '37-C�digo para protesto inv�lido';
        38: Result := '38-Prazo para protesto inv�lido';
        40: Result := '40-T�tulo com ordem de protesto emitida';
        42: Result := '42-C�digo para baixa/devolu��o inv�lido';
        43: Result := '43-Prazo para baixa/devolu��o inv�lido';
        44: Result := '44-C�digo da moeda inv�lido';
        45: Result := '45-Nome do sacado n�o informado';
        46: Result := '46-Tipo/n�mero de inscri��o do sacado inv�lido';
        47: Result := '47-Endere�o do sacado n�o informado';
        48: Result := '48-CEP inv�lido';
        49: Result := '49-CEP sem pra�a de cobran�a (n�o localizado)';
        52: Result := '52-Unidade da federa��o inv�lida';
        53: Result := '53-Tipo/n�mero de inscri��o do sacador/avalista inv�lido';
        57: Result := '57-C�digo da multa inv�lido';
        58: Result := '58-Data da multa inv�lida';
        59: Result := '59-Valor/Percentual da multa inv�lido';
        60: Result := '60-Movimento para t�tulo n�o cadastrado. Erro gen�rico para as situa��es:' + #13#10 +
          '�Cedente n�o cadastrado� ou' + #13#10 +
            '�Ag�ncia Cedente n�o cadastrada ou desativada�';
        61: Result := '61-Ag�ncia cobradora inv�lida';
        62: Result := '62-Tipo de impress�o inv�lido';
        63: Result := '63-Entrada para t�tulo j� cadastrado';
        68: Result := '68-Movimenta��o inv�lida para o t�tulo';
        69: Result := '69-Altera��o de dados inv�lida';
        70: Result := '70-Apelido do cliente n�o cadastrado';
        71: Result := '71-Erro na composi��o do arquivo';
        72: Result := '72-Lote de servi�o inv�lido';
        73: Result := '73-C�digo do cedente inv�lido';
        74: Result := '74-Cedente n�o pertence a cobran�a eletr�nica/apelido n�o confere com cedente';
        75: Result := '75-Nome da empresa inv�lido';
        76: Result := '76-Nome do banco inv�lido';
        77: Result := '77-C�digo da remessa inv�lido';
        78: Result := '78-Data/Hora de gera��o do arquivo inv�lida';
        79: Result := '79-N�mero seq�encial do arquivo inv�lido';
        80: Result := '80-N�mero da vers�o do Layout do arquivo/lote inv�lido';
        81: Result := '81-Literal �REMESSA-TESTE� v�lida somente para fase de testes';
        82: Result := '82-Literal �REMESSA-TESTE� obrigat�rio para fase de testes';
        83: Result := '83-Tipo/n�mero de inscri��o da empresa inv�lido';
        84: Result := '84-Tipo de opera��o inv�lido';
        85: Result := '85-Tipo de servi�o inv�lido';
        86: Result := '86-Forma de lan�amento inv�lido';
        87: Result := '87-N�mero da remessa inv�lido';
        88: Result := '88-N�mero da remessa menor/igual que da remessa anterior';
        89: Result := '89-Lote de servi�o divergente';
        90: Result := '90-N�mero seq�encial do registro inv�lido';
        91: Result := '91-Erro na seq��ncia de segmento do registro detalhe';
        92: Result := '92-C�digo de movimento divergente entre grupo de segmentos';
        93: Result := '93-Quantidade de registros no lote inv�lido';
        94: Result := '94-Quantidade de registros no lote divergente';
        95: Result := '95-Quantidade de lotes do arquivo inv�lido';
        96: Result := '96-Quantidade de lotes no arquivo divergente';
        97: Result := '97-Quantidade de registros no arquivo inv�lido';
        98: Result := '98-Quantidade de registros no arquivo divergente';
        99: Result := '99-C�digo de DDD inv�lido';
      else
        Result := IntToStrZero(CodMotivo, 2) + ' - Outros Motivos';
      end;
    toRetornoDebitoTarifas:
      case CodMotivo of
        01: Result := '01-Tarifa de Extrato de Posi��o';
        02: Result := '02-Tarifa de Manuten��o de T�tulo Vencido';
        03: Result := '03-Tarifa de Susta��o';
        04: Result := '04-Tarifa de Protesto';
        05: Result := '05-Tarifa de Outras Instru��es';
        06: Result := '06-Tarifa de Outras Ocorr�ncias';
        07: Result := '07-Tarifa de Envio de Duplicata ao Sacado';
        08: Result := '08-Custas de Protesto';
        09: Result := '09-Custas de Susta��o de Protesto';
        10: Result := '10-Custas de Cart�rio Distribuidor';
        11: Result := '11-Custas de Edital';
        12: Result := '12-Redisponibiliza��o de Arquivo Retorno Eletr�nico';
        13: Result := 'Tarifa Sobre Registro Cobrada na Baixa/Liquida��o';
        14: Result := 'Tarifa Sobre Reapresenta��o Autom�tica';
        15: Result := 'Banco de Sacados';
        16: Result := 'Tarifa Sobre Informa��es Via Fax';
        17: Result := 'Entrega Aviso Disp Bloqueto via e-amail ao sacado (s/ emiss�o Bloqueto)';
        18: Result := 'Emiss�o de Bloqueto Pr�-impresso CAIXA matricial';
        19: Result := 'Emiss�o de Bloqueto Pr�-impresso CAIXA A4';
        20: Result := 'Emiss�o de Bloqueto Padr�o CAIXA';
      end;
  end;
  ***}
end;

function TACBrCaixaEconomica.TipoOcorrenciaToDescricao(const TipoOcorrencia: TACBrTipoOcorrencia): String;
var
  CodOcorrencia: Integer;
begin
  // DONE -oJacinto Junior: Ajustar para utilizar as ocorr�ncias e descri��es corretas.
  CodOcorrencia := StrToIntDef(TipoOCorrenciaToCod(TipoOcorrencia),0);
  case CodOcorrencia of
    01: Result := '01-Solicita��o de Impress�o de T�tulos Confirmada';
    02: Result := '02-Entrada Confirmada';
    03: Result := '03-Entrada Rejeitada';
    04: Result := '04-Transfer�ncia de Carteira/Entrada';
    05: Result := '05-Transfer�ncia de Carteira/Baixa';
    06: Result := '06-Liquida��o';
    07: Result := '07-Confirma��o do Recebimento da Instru��o de Desconto';
    08: Result := '08-Confirma��o do Recebimento do Cancelamento do Desconto';
    09: Result := '09-Baixa';
    12: Result := '12-Confirma��o Recebimento Instru��o de Abatimento';
    13: Result := '13-Confirma��o Recebimento Instru��o de Cancelamento Abatimento';
    14: Result := '14-Confirma��o Recebimento Instru��o Altera��o deVencimento';
    19: Result := '19-Confirma��o Recebimento Instru��o de Protesto';
    20: Result := '20-Confirma��o Recebimento Instru��o de Susta��o/Cancelamento de Protesto';
    23: Result := '23-Remessa a Cart�rio';
    24: Result := '24-Retirada de Cart�rio';
    25: Result := '25-Protestado e Baixado (Baixa por Ter Sido Protestado)';
    26: Result := '26-Instru��o Rejeitada';
    27: Result := '27-Confirma��o do Pedido de Altera��o de Outros Dados';
    28: Result := '28-D�bito de Tarifas/Custas';
    30: Result := '30-Altera��o de Dados Rejeitada';
    35: Result := '35-Confirma��o de Inclus�o Banco de Sacado';
    36: Result := '36-Confirma��o de Altera��o Banco de Sacado';
    37: Result := '37-Confirma��o de Exclus�o Banco de Sacado';
    38: Result := '38-Emiss�o de Bloquetos de Banco de Sacado';
    39: Result := '39-Manuten��o de Sacado Rejeitada';
    40: Result := '40-Entrada de T�tulo via Banco de Sacado Rejeitada';
    41: Result := '41-Manuten��o de Banco de Sacado Rejeitada';
    44: Result := '44-Estorno de Baixa / Liquida��o';
    45: Result := '45-Altera��o de Dados';
    
    // Implementa��o obsoleta.
    {***
    02: Result := '02-Entrada Confirmada';
    03: Result := '03-Entrada Rejeitada';
    04: Result := '04-Transfer�ncia de Carteira/Entrada';
    05: Result := '05-Transfer�ncia de Carteira/Baixa';
    06: Result := '06-Liquida��o';
    09: Result := '09-Baixa';
    12: Result := '12-Confirma��o Recebimento Instru��o de Abatimento';
    13: Result := '13-Confirma��o Recebimento Instru��o de Cancelamento Abatimento';
    14: Result := '14-Confirma��o Recebimento Instru��o Altera��o de Vencimento';
    17: Result := '17-Liquida��o Ap�s Baixa ou Liquida��o T�tulo N�o Registrado';
    19: Result := '19-Confirma��o Recebimento Instru��o de Protesto';
    20: Result := '20-Confirma��o Recebimento Instru��o de Susta��o/Cancelamento de Protesto';
    23: Result := '23-Remessa a Cart�rio (Aponte em Cart�rio)';
    24: Result := '24-Retirada de Cart�rio e Manuten��o em Carteira';
    25: Result := '25-Protestado e Baixado (Baixa por Ter Sido Protestado)';
    26: Result := '26-Instru��o Rejeitada';
    27: Result := '27-Confirma��o do Pedido de Altera��o de Outros Dados';
    28: Result := '28-D�bito de Tarifas/Custas';
    30: Result := '30-Altera��o de Dados Rejeitada';
    36: Result := '36-Confirma��o de envio de e-mail/SMS';
    37: Result := '37-Envio de e-mail/SMS rejeitado';
    43: Result := '43-Estorno de Protesto/Susta��o';
    44: Result := '44-Estorno de Baixa/Liquida��o';
    45: Result := '45-Altera��o de dados';
    51: Result := '51-T�tulo DDA reconhecido pelo sacado';
    52: Result := '52-T�tulo DDA n�o reconhecido pelo sacado';
    53: Result := '53-T�tulo DDA recusado pela CIP';
    ***}
  end;
end;

function TACBrCaixaEconomica.CodigoLiquidacao_Descricao(CodLiquidacao: Integer): String;
begin
  case CodLiquidacao of
    02 : result := 'Casa Lot�rica';
    03 : result := 'Ag�ncias CAIXA';
    04 : result := 'Compensa��o Eletr�nica';
    05 : result := 'Compensa��o Convencional';
    06 : result := 'Internet Banking';
    07 : result := 'Correspondente Banc�rio';
    08 : result := 'Em Cart�rio'
  end;
end;

end.
