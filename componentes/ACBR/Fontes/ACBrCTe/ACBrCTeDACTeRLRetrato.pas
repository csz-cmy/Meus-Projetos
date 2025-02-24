{******************************************************************************}
{ Projeto: Componente ACBrCTe                                                  }
{  Biblioteca multiplataforma de componentes Delphi para emiss�o de Conhecimen-}
{ to de Transporte eletr�nico - CTe - http://www.cte.fazenda.gov.br            }
{                                                                              }
{ Direitos Autorais Reservados (c) 2014 Mark dos Santos Gon�alves              }
{                                        Juliomar Marchetti                     }
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

unit ACBrCTeDACTeRLRetrato;

interface

{$H+}

uses
  SysUtils, Variants, Classes,
  {$IFDEF CLX}
  QGraphics, QControls, QForms, QDialogs, QExtCtrls, Qt, QStdCtrls,
  {$ELSE}
  Windows, Messages, Graphics, Controls, Forms, Dialogs, ExtCtrls, MaskUtils, StdCtrls,
  {$ENDIF}
  RLReport, RLFilters, RLPDFFilter,
  pcnConversao, RLBarcode, DB, StrUtils, RLRichText, ACBrCTeDACTeRL,

  RLMetaFile, RLFeedBack, RLParser, RLConsts, RLUtils,
  RLPrintDialog, RLTypes, RLPrinters;

type

  { TfrmDACTeRLRetrato }

  TfrmDACTeRLRetrato = class(TfrmDACTeRL)
    RLBarcode1: TRLBarcode;
    rlb_01_Recibo: TRLBand;
    rlsLinhaH03: TRLDraw;
    rlmEmitente: TRLMemo;
    rlmDadosEmitente: TRLMemo;
    rliLogo: TRLImage;
    rllNumCte: TRLLabel;
    rlLabel17: TRLLabel;
    rlLabel18: TRLLabel;
    rlLabel6: TRLLabel;
    rlLabel8: TRLLabel;
    rlLabel21: TRLLabel;
    rlLabel23: TRLLabel;
    rlLabel25: TRLLabel;
    rlLabel33: TRLLabel;
    rlLabel74: TRLLabel;
    rllChave: TRLLabel;
    rllPageNumber: TRLLabel;
    rllSerie: TRLLabel;
    rllModelo: TRLLabel;
    rllEmissao: TRLLabel;
    rllModal: TRLLabel;
    rllProtocolo: TRLLabel;
    rllTipoCte: TRLLabel;
    rllDescricao: TRLLabel;
    rlLabel77: TRLLabel;
    rllTipoServico: TRLLabel;
    rlLabel28: TRLLabel;
    rllTomaServico: TRLLabel;
    rlLabel78: TRLLabel;
    rllFormaPagamento: TRLLabel;
    rllInscSuframa: TRLLabel;
    rlb_07_HeaderItens: TRLBand;
    rlLabel20: TRLLabel;
    RLDraw32: TRLDraw;
    rlLabel91: TRLLabel;
    rlLabel92: TRLLabel;
    rlLabel96: TRLLabel;
    rlLabel100: TRLLabel;
    rlLabel106: TRLLabel;
    rlLabel109: TRLLabel;
    RLDraw34: TRLDraw;
    rlb_09_Obs: TRLBand;
    rlb_02_Cabecalho: TRLBand;
    rlLabel29: TRLLabel;
    rllNatOperacao: TRLLabel;
    rlLabel12: TRLLabel;
    rllOrigPrestacao: TRLLabel;
    rlLabel14: TRLLabel;
    rllDestPrestacao: TRLLabel;
    rlLabel13: TRLLabel;
    rlLabel16: TRLLabel;
    rlLabel22: TRLLabel;
    rlLabel24: TRLLabel;
    rlLabel26: TRLLabel;
    rllRazaoRemet: TRLLabel;
    rllEnderecoRemet1: TRLLabel;
    rllEnderecoRemet2: TRLLabel;
    rllMunRemet: TRLLabel;
    rllCnpjRemet: TRLLabel;
    rllPaisRemet: TRLLabel;
    rlLabel27: TRLLabel;
    rlLabel30: TRLLabel;
    rlLabel31: TRLLabel;
    rlLabel32: TRLLabel;
    rlLabel79: TRLLabel;
    rllRazaoDest: TRLLabel;
    rllEnderecoDest1: TRLLabel;
    rllEnderecoDest2: TRLLabel;
    rlLabel93: TRLLabel;
    rllInscEstRemet: TRLLabel;
    rlLabel95: TRLLabel;
    rllFoneRemet: TRLLabel;
    rllCEPRemet: TRLLabel;
    rlLabel98: TRLLabel;
    rllMunDest: TRLLabel;
    rllPaisDest: TRLLabel;
    rllCnpjDest: TRLLabel;
    rlLabel114: TRLLabel;
    rllInscEstDest: TRLLabel;
    rlLabel116: TRLLabel;
    rllFoneDest: TRLLabel;
    rllCEPDest: TRLLabel;
    rlLabel119: TRLLabel;
    rlLabel86: TRLLabel;
    rlLabel87: TRLLabel;
    rlLabel88: TRLLabel;
    rlLabel89: TRLLabel;
    rlLabel90: TRLLabel;
    rllRazaoExped: TRLLabel;
    rllEnderecoExped1: TRLLabel;
    rllEnderecoExped2: TRLLabel;
    rlLabel99: TRLLabel;
    rlLabel101: TRLLabel;
    rlLabel102: TRLLabel;
    rlLabel103: TRLLabel;
    rlLabel104: TRLLabel;
    rllRazaoReceb: TRLLabel;
    rllEnderecoReceb1: TRLLabel;
    rllEnderecoReceb2: TRLLabel;
    rllMunExped: TRLLabel;
    rllPaisExped: TRLLabel;
    rllCnpjExped: TRLLabel;
    rlLabel105: TRLLabel;
    rllInscEstExped: TRLLabel;
    rlLabel107: TRLLabel;
    rllFoneExped: TRLLabel;
    rllCEPExped: TRLLabel;
    rlLabel110: TRLLabel;
    rllMunReceb: TRLLabel;
    rllPaisReceb: TRLLabel;
    rllCnpjReceb: TRLLabel;
    rlLabel123: TRLLabel;
    rllInscEstReceb: TRLLabel;
    rlLabel125: TRLLabel;
    rllFoneReceb: TRLLabel;
    rllCEPReceb: TRLLabel;
    rlLabel128: TRLLabel;
    rlLabel80: TRLLabel;
    rlLabel81: TRLLabel;
    rlLabel94: TRLLabel;
    rllCEPToma: TRLLabel;
    rlLabel97: TRLLabel;
    rllEnderecoToma: TRLLabel;
    rlLabel82: TRLLabel;
    rllCnpjToma: TRLLabel;
    rlLabel108: TRLLabel;
    rllInscEstToma: TRLLabel;
    rlLabel111: TRLLabel;
    rllFoneToma: TRLLabel;
    rllRazaoToma: TRLLabel;
    rlLabel113: TRLLabel;
    rllPaisToma: TRLLabel;
    rllMunToma: TRLLabel;
    rlb_10_ModRodFracionado: TRLBand;
    rlb_11_ModRodLot103: TRLBand;
    rlLabel10: TRLLabel;
    RLDraw1: TRLDraw;
    rlmObs: TRLMemo;
    rllTituloLotacao: TRLLabel;
    RLDraw24: TRLDraw;
    rlLabel11: TRLLabel;
    RLDraw36: TRLDraw;
    RLDraw37: TRLDraw;
    RLDraw38: TRLDraw;
    rlLabel83: TRLLabel;
    rlLabel84: TRLLabel;
    rlLabel85: TRLLabel;
    rllRntrcEmpresa: TRLLabel;
    rllLotacao: TRLLabel;
    rllDtPrevEntrega: TRLLabel;
    rlmObsExcEmitente: TRLMemo;
    rllMsgTeste: TRLLabel;
    rlLabel7: TRLLabel;
    RLDraw27: TRLDraw;
    rlb_03_DadosDACTe: TRLBand;
    rlLabel1: TRLLabel;
    rllProdPredominante: TRLLabel;
    rlLabel4: TRLLabel;
    rllOutrasCaracCarga: TRLLabel;
    rlLabel34: TRLLabel;
    rllVlrTotalMerc: TRLLabel;
    rlLabel35: TRLLabel;
    rlLabel36: TRLLabel;
    rlLabel41: TRLLabel;
    rlLabel43: TRLLabel;
    rlLabel5: TRLLabel;
    rlLabel37: TRLLabel;
    rlLabel39: TRLLabel;
    rlLabel40: TRLLabel;
    RLDraw8: TRLDraw;
    RLDraw7: TRLDraw;
    rlb_04_DadosNotaFiscal: TRLBand;
    rlb_05_Complemento: TRLBand;
    rlLabel38: TRLLabel;
    rlLabel44: TRLLabel;
    rlmCompNome1: TRLMemo;
    rlLabel46: TRLLabel;
    rlmCompValor1: TRLMemo;
    rlLabel42: TRLLabel;
    rlmCompNome2: TRLMemo;
    rlLabel45: TRLLabel;
    rlmCompValor2: TRLMemo;
    rlLabel47: TRLLabel;
    rlmCompNome3: TRLMemo;
    rlLabel48: TRLLabel;
    rlmCompValor3: TRLMemo;
    rlLabel49: TRLLabel;
    rllVlrTotServico: TRLLabel;
    rlLabel50: TRLLabel;
    rllVlrTotReceber: TRLLabel;
    RLDraw18: TRLDraw;
    RLDraw17: TRLDraw;
    RLDraw16: TRLDraw;
    RLDraw15: TRLDraw;
    RLDraw19: TRLDraw;
    rlLabel51: TRLLabel;
    rlLabel52: TRLLabel;
    rllSitTrib: TRLLabel;
    rlLabel55: TRLLabel;
    rllBaseCalc: TRLLabel;
    rlLabel56: TRLLabel;
    rllAliqICMS: TRLLabel;
    rlLabel54: TRLLabel;
    rllVlrICMS: TRLLabel;
    rlLabel53: TRLLabel;
    rllRedBaseCalc: TRLLabel;
    rlLabel58: TRLLabel;
    rllICMS_ST: TRLLabel;
    RLDraw26: TRLDraw;
    RLDraw25: TRLDraw;
    RLDraw23: TRLDraw;
    RLDraw22: TRLDraw;
    RLDraw21: TRLDraw;
    RLDraw20: TRLDraw;
    rlLabel59: TRLLabel;
    RLDraw5: TRLDraw;
    RLDraw6: TRLDraw;
    rlLabel61: TRLLabel;
    rlLabel62: TRLLabel;
    rlLabel63: TRLLabel;
    rlLabel64: TRLLabel;
    rlsQuadro01: TRLDraw;
    rlsQuadro02: TRLDraw;
    rlsQuadro04: TRLDraw;
    rlsQuadro05: TRLDraw;
    rlsQuadro07: TRLDraw;
    rlsQuadro08: TRLDraw;
    rlsQuadro09: TRLDraw;
    rlsLinhaV10: TRLDraw;
    rlsLinhaV04: TRLDraw;
    rlsLinhaH01: TRLDraw;
    rlsLinhaH02: TRLDraw;
    rlsLinhaV09: TRLDraw;
    rlsLinhaV08: TRLDraw;
    rlsLinhaV06: TRLDraw;
    rlsLinhaV05: TRLDraw;
    rlsLinhaH04: TRLDraw;
    rlsLinhaV07: TRLDraw;
    rlsLinhaV01: TRLDraw;
    rlsLinhaV11: TRLDraw;
    rlsLinhaH06: TRLDraw;
    rlsLinhaH07: TRLDraw;
    rlsLinhaH05: TRLDraw;
    rlsLinhaH08: TRLDraw;
    RLDraw55: TRLDraw;
    RLDraw9: TRLDraw;
    RLDraw56: TRLDraw;
    RLDraw58: TRLDraw;
    RLDraw59: TRLDraw;
    RLDraw60: TRLDraw;
    RLDraw61: TRLDraw;
    RLDraw62: TRLDraw;
    rlb_17_Sistema: TrlBand;
    RLDraw10: TRLDraw;
    rlLabel65: TRLLabel;
    RLDraw2: TRLDraw;
    rlLabel66: TRLLabel;
    rlLabel70: TRLLabel;
    RLDraw53: TRLDraw;
    RLDraw11: TRLDraw;
    rlLabel71: TRLLabel;
    RLDraw12: TRLDraw;
    rlLabel75: TRLLabel;
    RLDraw13: TRLDraw;
    rlLabel76: TRLLabel;
    rlLabel112: TRLLabel;
    rlLabel115: TRLLabel;
    rlLabel117: TRLLabel;
    RLDraw14: TRLDraw;
    RLDraw31: TRLDraw;
    RLDraw33: TRLDraw;
    rlLabel118: TRLLabel;
    rlLabel120: TRLLabel;
    rlLabel121: TRLLabel;
    RLDraw39: TRLDraw;
    rlLabel122: TRLLabel;
    rlLabel124: TRLLabel;
    rlLabel126: TRLLabel;
    rlLabel127: TRLLabel;
    RLDraw40: TRLDraw;
    RLDraw41: TRLDraw;
    rlLabel129: TRLLabel;
    rlLabel130: TRLLabel;
    rlLabel131: TRLLabel;
    RLDraw42: TRLDraw;
    RLDraw43: TRLDraw;
    RLDraw44: TRLDraw;
    rlb_16_DadosExcEmitente: TRLBand;
    rlLabel15: TRLLabel;
    rllblSistema: TRLLabel;
    rllNomeMotorista: TRLLabel;
    rllCPFMotorista: TRLLabel;
    rllNumRegEsp: TRLLabel;
    rllResponsavel: TRLLabel;
    rllValorTotal: TRLLabel;
    rllLacres: TRLLabel;
    rlmTipo: TRLMemo;
    rlmPlaca: TRLMemo;
    rlmUF: TRLMemo;
    rlmRNTRC: TRLMemo;
    rlmEmpresas: TRLMemo;
    rlmVigencias: TRLMemo;
    rlmNumDispositivo: TRLMemo;
    rlmCodTransacao: TRLMemo;
    RLDraw45: TRLDraw;
    rlmQtdUnidMedida1: TRLMemo;
    rlmQtdUnidMedida2: TRLMemo;
    rlmQtdUnidMedida3: TRLMemo;
    rlmQtdUnidMedida5: TRLMemo;
    rlb_06_ValorPrestacao: TRLBand;
    RLDraw46: TRLDraw;
    RLDraw48: TRLDraw;
    RLDraw49: TRLDraw;
    rlLabel3: TRLLabel;
    rlLabel132: TRLLabel;
    rlLabel133: TRLLabel;
    rlLabel134: TRLLabel;
    rlLabel135: TRLLabel;
    rlLabel136: TRLLabel;
    rlLabel137: TRLLabel;
    rlLabel138: TRLLabel;
    rlLabel139: TRLLabel;
    rlLabel140: TRLLabel;
    rllSerie2: TRLLabel;
    rllNumCTe2: TRLLabel;
    rlLabel143: TRLLabel;
    rlb_12_ModAereo: TRLBand;
    rlb_13_ModAquaviario: TRLBand;
    rlb_14_ModFerroviario: TRLBand;
    rlb_15_ModDutoviario: TRLBand;
    RLDraw47: TRLDraw;
    RLDraw54: TRLDraw;
    RLDraw63: TRLDraw;
    RLDraw64: TRLDraw;
    RLDraw65: TRLDraw;
    RLDraw66: TRLDraw;
    RLDraw67: TRLDraw;
    RLDraw68: TRLDraw;
    RLDraw69: TRLDraw;
    rlLabel141: TRLLabel;
    rlLabel142: TRLLabel;
    rlLabel144: TRLLabel;
    rlLabel145: TRLLabel;
    rlLabel146: TRLLabel;
    rlLabel147: TRLLabel;
    rlLabel148: TRLLabel;
    rlLabel149: TRLLabel;
    rlLabel150: TRLLabel;
    rlLabel153: TRLLabel;
    rllTrecho: TRLLabel;
    rllTarifaValor: TRLLabel;
    rllTarifaCodigo: TRLLabel;
    rllTarifaCL: TRLLabel;
    rllMinuta: TRLLabel;
    rllDadosRetira: TRLLabel;
    rllAWB: TRLLabel;
    rlLabel154: TRLLabel;
    rlLabel155: TRLLabel;
    rllCaracAdServico: TRLLabel;
    rllCaracAdTransporte: TRLLabel;
    RLDraw57: TRLDraw;
    RLDraw72: TRLDraw;
    rlLabel156: TRLLabel;
    rllContaCorrente: TRLLabel;
    rlLabel157: TRLLabel;
    rllLojaAgenteEmissor: TRLLabel;
    rllRetira: TRLLabel;
    RLDraw70: TRLDraw;
    RLDraw71: TRLDraw;
    RLDraw73: TRLDraw;
    rlLabel151: TRLLabel;
    RLDraw74: TRLDraw;
    rlLabel152: TRLLabel;
    rllPortoEmbarque: TRLLabel;
    rlLabel158: TRLLabel;
    rllPortoDestino: TRLLabel;
    RLDraw75: TRLDraw;
    rlLabel159: TRLLabel;
    rllIndNavioRebocador: TRLLabel;
    RLDraw76: TRLDraw;
    rlLabel160: TRLLabel;
    rllIndConteiners: TRLLabel;
    RLDraw77: TRLDraw;
    rlLabel162: TRLLabel;
    rllBCAFRMM: TRLLabel;
    rlLabel164: TRLLabel;
    rllValorAFRMM: TRLLabel;
    rlLabel166: TRLLabel;
    rllTipoNav: TRLLabel;
    rlLabel168: TRLLabel;
    rllDirecao: TRLLabel;
    RLDraw78: TRLDraw;
    RLDraw79: TRLDraw;
    RLDraw80: TRLDraw;
    rlb_01_Recibo_Aereo: TRLBand;
    rlLabel19: TRLLabel;
    RLDraw81: TRLDraw;
    RLDraw82: TRLDraw;
    rlLabel57: TRLLabel;
    rlLabel60: TRLLabel;
    rlLabel69: TRLLabel;
    rlLabel161: TRLLabel;
    rlLabel67: TRLLabel;
    rlLabel68: TRLLabel;
    rlLabel72: TRLLabel;
    rlLabel163: TRLLabel;
    RLDraw3: TRLDraw;
    rlLabel165: TRLLabel;
    lblCIOT: TRLLabel;
    rllCIOT: TRLLabel;
    rlsCIOT: TRLDraw;
    rlmObsFisco: TRLMemo;
    rlb_11_ModRodLot104: TRLBand;
    RLDraw4: TRLDraw;
    RLDraw30: TRLDraw;
    RLDraw83: TRLDraw;
    RLDraw84: TRLDraw;
    RLDraw85: TRLDraw;
    RLDraw86: TRLDraw;
    RLDraw87: TRLDraw;
    RLDraw89: TRLDraw;
    RLDraw90: TRLDraw;
    RLDraw92: TRLDraw;
    rlLabel167: TRLLabel;
    rlLabel169: TRLLabel;
    rlLabel170: TRLLabel;
    rlLabel171: TRLLabel;
    rlLabel172: TRLLabel;
    rlLabel173: TRLLabel;
    rlLabel174: TRLLabel;
    rlLabel177: TRLLabel;
    rlLabel179: TRLLabel;
    rlLabel181: TRLLabel;
    rlLabel182: TRLLabel;
    rlLabel183: TRLLabel;
    rlmUF2: TRLMemo;
    rlmTipo2: TRLMemo;
    rlmRNTRC2: TRLMemo;
    rlmPlaca2: TRLMemo;
    rlmCNPJForn: TRLMemo;
    rlmNumCompra: TRLMemo;
    rllNomeMotorista2: TRLLabel;
    rllLacres2: TRLLabel;
    rllCPFMotorista2: TRLLabel;
    rlb_18_Recibo: TRLBand;
    RLDraw91: TRLDraw;
    RLDraw93: TRLDraw;
    RLDraw94: TRLDraw;
    RLDraw95: TRLDraw;
    RLDraw96: TRLDraw;
    RLDraw97: TRLDraw;
    rlLabel175: TRLLabel;
    rlLabel176: TRLLabel;
    rlLabel180: TRLLabel;
    rlLabel184: TRLLabel;
    rlLabel185: TRLLabel;
    rlLabel186: TRLLabel;
    rlLabel187: TRLLabel;
    rlLabel188: TRLLabel;
    rlLabel189: TRLLabel;
    rlLabel190: TRLLabel;
    rlLabel191: TRLLabel;
    rllSerie3: TRLLabel;
    rllNumCTe3: TRLLabel;
    RLDraw98: TRLDraw;
    rlmCNPJPg: TRLMemo;
    RLDraw88: TRLDraw;
    rllVariavel1: TRLLabel;
    RLDraw99: TRLDraw;
    rlmQtdUnidMedida4: TRLMemo;
    rlLabel73: TRLLabel;
    RLDraw100: TRLDraw;
    rlsQuadro03: TRLDraw;
    rlsLinhaPontilhada: TRLDraw;
    rlLabel178: TRLLabel;
    rllIndBalsas: TRLLabel;
    rlmNomeSeguradora: TRLMemo;
    rlmRespSeguroMerc: TRLMemo;
    rlmNroApolice: TRLMemo;
    rlmNroAverbacao: TRLMemo;
    rlb_06_ProdutosPerigosos: TRLBand;
    RLDraw101: TRLDraw;
    rlLabel192: TRLLabel;
    RLDraw102: TRLDraw;
    rlLabel193: TRLLabel;
    rlLabel194: TRLLabel;
    rlLabel195: TRLLabel;
    rlLabel196: TRLLabel;
    rlLabel197: TRLLabel;
    RLDraw103: TRLDraw;
    RLDraw104: TRLDraw;
    RLDraw105: TRLDraw;
    RLDraw106: TRLDraw;
    rlmNumONU: TRLMemo;
    rlmNomeApropriado: TRLMemo;
    rlmClasse: TRLMemo;
    rlmGrupoEmbalagem: TRLMemo;
    rlmQtdeProduto: TRLMemo;
    RLDraw107: TRLDraw;
    rllResumoCanhotoCTe: TRLLabel;
    rllResumoCanhotoCTe2: TRLLabel;
    rlbCodigoBarras: TRLBarcode;
    RLDraw51: TRLDraw;
    RLDraw52: TRLDraw;
    RLDraw50: TRLDraw;
    RLLabel198: TRLLabel;
    RLDraw108: TRLDraw;
    RLDraw109: TRLDraw;
    rlmComplChave1: TRLMemo;
    rlmComplValor1: TRLMemo;
    rlmComplChave2: TRLMemo;
    rlmComplValor2: TRLMemo;
    rlDocOrig_tpDoc1: TRLMemo;
    rlDocOrig_cpf1: TRLMemo;
    rlDocOrig_serie1: TRLMemo;
    rlDocOrig_serie2: TRLMemo;
    rlDocOrig_cpf2: TRLMemo;
    rlDocOrig_tpDoc2: TRLMemo;
    RLLabel199: TRLLabel;
    RLLabel200: TRLLabel;
    RLSystemInfo1: TRLSystemInfo;
    RLSystemInfo2: TRLSystemInfo;
    procedure rlb_01_ReciboBeforePrint(Sender: TrlCustomBand; var PrintBand: boolean);
    procedure rlb_02_CabecalhoBeforePrint(Sender: TrlCustomBand; var PrintBand: boolean);
    procedure rlb_03_DadosDACTeBeforePrint(Sender: TrlCustomBand; var PrintBand: boolean);
    procedure rlb_04_DadosNotaFiscalBeforePrint(Sender: TrlCustomBand; var PrintBand: boolean);
    procedure rlb_05_ComplementoBeforePrint(Sender: TrlCustomBand; var PrintBand: boolean);
    procedure rlb_06_ValorPrestacaoBeforePrint(Sender: TrlCustomBand; var PrintBand: boolean);
    procedure rlb_07_HeaderItensBeforePrint(Sender: TrlCustomBand; var PrintBand: boolean);
    procedure rlb_09_ObsBeforePrint(Sender: TrlCustomBand; var PrintBand: boolean);
    procedure rlb_10_ModRodFracionadoBeforePrint(Sender: TrlCustomBand; var PrintBand: boolean);
    procedure rlb_11_ModRodLot103BeforePrint(Sender: TrlCustomBand; var PrintBand: boolean);
    procedure rlb_17_SistemaBeforePrint(Sender: TrlCustomBand; var PrintBand: boolean);
    procedure rlb_16_DadosExcEmitenteBeforePrint(Sender: TrlCustomBand; var PrintBand: boolean);
    procedure rlb_12_ModAereoBeforePrint(Sender: TrlCustomBand; var PrintBand: boolean);
    procedure rlb_13_ModAquaviarioBeforePrint(Sender: TrlCustomBand; var PrintBand: boolean);
    procedure rlb_14_ModFerroviarioBeforePrint(Sender: TrlCustomBand; var PrintBand: boolean);
    procedure rlb_15_ModDutoviarioBeforePrint(Sender: TrlCustomBand; var PrintBand: boolean);
    procedure rlb_01_Recibo_AereoBeforePrint(Sender: TrlCustomBand; var PrintBand: boolean);
    procedure rlb_11_ModRodLot104BeforePrint(Sender: TrlCustomBand; var PrintBand: boolean);
    procedure rlb_18_ReciboBeforePrint(Sender: TrlCustomBand; var PrintBand: boolean);
    procedure rlb_06_ProdutosPerigososBeforePrint(Sender: TrlCustomBand; var PrintBand: boolean);
    procedure RLCTeBeforePrint(Sender: TObject; var PrintIt: boolean);
  private
    procedure Itens;
  public
    procedure ProtocoloCTe(const sProtocolo: string);
  end;

implementation

uses
  DateUtils, ACBrUtil, ACBrDFeUtil, ACBrCTeUtil;

{$R *.dfm}

var
  FProtocoloCTe: string;
  Versao: integer;

procedure TfrmDACTeRLRetrato.Itens;
var
  I, J, K, Item: integer;
begin
  if RLCTe.PageNumber > 0 then
    exit;

  Item := 0;
{$IFDEF PL_200}
  //Varrendo NF comum
  for I := 0 to (FCTe.infCTeNorm.infDoc.infNF.Count - 1) do
  begin
    with FCTe.infCTeNorm.infDoc.InfNF.Items[I] do
    begin
      if (Item mod 2) = 0 then
      begin
        cdsDocumentos.Append;

        cdsDocumentos.FieldByname('TIPO_1').AsString := 'NF';
        cdsDocumentos.FieldByname('CNPJCPF_1').AsString := DFeUtil.FormatarCNPJCPF(FCTe.Rem.CNPJCPF);
        cdsDocumentos.FieldByname('DOCUMENTO_1').AsString := serie + '-' + nDoc;
      end
      else
      begin
        cdsDocumentos.FieldByname('TIPO_2').AsString := 'NF';
        cdsDocumentos.FieldByname('CNPJCPF_2').AsString := DFeUtil.FormatarCNPJCPF(FCTe.Rem.CNPJCPF);
        cdsDocumentos.FieldByname('DOCUMENTO_2').AsString := serie + '-' + nDoc;

        cdsDocumentos.Post;
      end;
      inc(Item);
    end;
  end;
  //Varrendo NFe
  for I := 0 to (FCTe.infCTeNorm.infDoc.InfNFE.Count - 1) do
  begin
    with FCTe.infCTeNorm.infDoc.InfNFE.Items[I] do
    begin
      if (Item mod 2) = 0 then
      begin
        cdsDocumentos.Append;
        cdsDocumentos.FieldByname('TIPO_1').AsString := 'NF-E ' + copy(chave, 26, 9);
        cdsDocumentos.FieldByname('CNPJCPF_1').AsString := CTeUtil.FormatarChaveAcesso(chave, True);
      end
      else
      begin
        cdsDocumentos.FieldByname('TIPO_2').AsString := 'NF-E ' + copy(chave, 26, 9);
        cdsDocumentos.FieldByname('CNPJCPF_2').AsString := CTeUtil.FormatarChaveAcesso(chave, True);
        cdsDocumentos.Post;
      end;
      inc(Item);
    end;
  end;
  //Varrendo Outros
  for I := 0 to (FCTe.infCTeNorm.infDoc.InfOutros.Count - 1) do
  begin
    with FCTe.infCTeNorm.infDoc.InfOutros.Items[I] do
    begin
      if (Item mod 2) = 0 then
      begin
        cdsDocumentos.Append;
        // TpcteTipoDocumento = (tdDeclaracao, tdDutoviario, tdOutros);
        case tpDoc of
         tdDeclaracao: begin
                        cdsDocumentos.FieldByname('TIPO_1').AsString      := 'DECLAR';
                        cdsDocumentos.FieldByname('CNPJCPF_1').AsString   := DFeUtil.FormatarCNPJCPF(FCTe.Rem.CNPJCPF);
                        cdsDocumentos.FieldByname('DOCUMENTO_1').AsString := 'Declara��o Doc.: ' + nDoc;
                       end;
         tdDutoviario: begin
                        cdsDocumentos.FieldByname('TIPO_1').AsString      := 'DUTO';
                        cdsDocumentos.FieldByname('CNPJCPF_1').AsString   := DFeUtil.FormatarCNPJCPF(FCTe.Rem.CNPJCPF);
                        cdsDocumentos.FieldByname('DOCUMENTO_1').AsString := 'Dutovi�rio Doc.: ' + nDoc;
                       end;
         tdOutros:     begin
                        cdsDocumentos.FieldByname('TIPO_1').AsString      := 'Outros';
                        cdsDocumentos.FieldByname('CNPJCPF_1').AsString   := DFeUtil.FormatarCNPJCPF(FCTe.Rem.CNPJCPF);
                        cdsDocumentos.FieldByname('DOCUMENTO_1').AsString := copy( trim(descOutros), 1, 20 ) + ' Doc.: '+ nDoc;
                       end;
        end;
//        cdsDocumentos.FieldByname('TIPO_1').AsString := descOutros;
//        cdsDocumentos.FieldByname('CNPJCPF_1').AsString := DFeUtil.FormatarCNPJCPF(FCTe.Rem.CNPJCPF);
      end
      else
      begin
        // TpcteTipoDocumento = (tdDeclaracao, tdDutoviario, tdOutros);
        case tpDoc of
         tdDeclaracao: begin
                        cdsDocumentos.FieldByname('TIPO_2').AsString      := 'DECLAR';
                        cdsDocumentos.FieldByname('CNPJCPF_2').AsString   := DFeUtil.FormatarCNPJCPF(FCTe.Rem.CNPJCPF);
                        cdsDocumentos.FieldByname('DOCUMENTO_2').AsString := 'Declara��o Doc.: ' + nDoc;
                       end;
         tdDutoviario: begin
                        cdsDocumentos.FieldByname('TIPO_2').AsString      := 'DUTO';
                        cdsDocumentos.FieldByname('CNPJCPF_2').AsString   := DFeUtil.FormatarCNPJCPF(FCTe.Rem.CNPJCPF);
                        cdsDocumentos.FieldByname('DOCUMENTO_2').AsString := 'Dutovi�rio Doc.: ' + nDoc;
                       end;
         tdOutros:     begin
                        cdsDocumentos.FieldByname('TIPO_2').AsString      := 'Outros';
                        cdsDocumentos.FieldByname('CNPJCPF_2').AsString   := DFeUtil.FormatarCNPJCPF(FCTe.Rem.CNPJCPF);
                        cdsDocumentos.FieldByname('DOCUMENTO_2').AsString := copy( trim(descOutros), 1, 20 ) + ' Doc.: '+ nDoc;
                       end;
        end;
//        cdsDocumentos.FieldByname('TIPO_2').AsString := descOutros;
//        cdsDocumentos.FieldByname('CNPJCPF_2').AsString := DFeUtil.FormatarCNPJCPF(FCTe.Rem.CNPJCPF);
        cdsDocumentos.Post;
      end;
      inc(Item);
    end;
  end;
 //Varrendo Documentos de Transporte anterior
  for I := 0 to (FCTe.infCTeNorm.docAnt.emiDocAnt.Count - 1) do
  begin
    // Em Papel
    for J := 0 to (FCTe.infCTeNorm.docAnt.emiDocAnt.Items[I].idDocAnt.Count - 1) do
    begin
      for K := 0 to (FCTe.infCTeNorm.docAnt.emiDocAnt.Items[I].idDocAnt.Items[J].idDocAntPap.Count - 1) do
      begin
        with FCTe.infCTeNorm.docAnt.emiDocAnt.Items[I].idDocAnt.Items[J].idDocAntPap.Items[K] do
        begin
          if (Item mod 2) = 0 then
          begin
            cdsDocumentos.Append;

            case tpDoc of
             daCTRC: cdsDocumentos.FieldByname('TIPO_1').AsString := 'CTRC';
             daCTAC: cdsDocumentos.FieldByname('TIPO_1').AsString := 'CTAC';
             daACT:  cdsDocumentos.FieldByname('TIPO_1').AsString := 'ACT';
             daNF7:  cdsDocumentos.FieldByname('TIPO_1').AsString := 'NF M7';
             daNF27: cdsDocumentos.FieldByname('TIPO_1').AsString := 'NF M27';
             daCAN:  cdsDocumentos.FieldByname('TIPO_1').AsString := 'CAN';
             daCTMC: cdsDocumentos.FieldByname('TIPO_1').AsString := 'CTMC';
             daATRE: cdsDocumentos.FieldByname('TIPO_1').AsString := 'ATRE';
             daDTA:  cdsDocumentos.FieldByname('TIPO_1').AsString := 'DTA';
             daCAI:  cdsDocumentos.FieldByname('TIPO_1').AsString := 'CAI';
             daCCPI: cdsDocumentos.FieldByname('TIPO_1').AsString := 'CCPI';
             daCA:   cdsDocumentos.FieldByname('TIPO_1').AsString := 'CA';
             daTIF:  cdsDocumentos.FieldByname('TIPO_1').AsString := 'TIF';
             daOutros: cdsDocumentos.FieldByname('TIPO_1').AsString := 'Outros';
            end;
            cdsDocumentos.FieldByname('CNPJCPF_1').AsString := DFeUtil.FormatarCNPJCPF(FCTe.infCTeNorm.docAnt.emiDocAnt.Items[I].CNPJCPF);
            cdsDocumentos.FieldByname('DOCUMENTO_1').AsString := serie + '-' + IntToStr(nDoc);
          end
          else
          begin
            case tpDoc of
             daCTRC: cdsDocumentos.FieldByname('TIPO_2').AsString := 'CTRC';
             daCTAC: cdsDocumentos.FieldByname('TIPO_2').AsString := 'CTAC';
             daACT:  cdsDocumentos.FieldByname('TIPO_2').AsString := 'ACT';
             daNF7:  cdsDocumentos.FieldByname('TIPO_2').AsString := 'NF M7';
             daNF27: cdsDocumentos.FieldByname('TIPO_2').AsString := 'NF M27';
             daCAN:  cdsDocumentos.FieldByname('TIPO_2').AsString := 'CAN';
             daCTMC: cdsDocumentos.FieldByname('TIPO_2').AsString := 'CTMC';
             daATRE: cdsDocumentos.FieldByname('TIPO_2').AsString := 'ATRE';
             daDTA:  cdsDocumentos.FieldByname('TIPO_2').AsString := 'DTA';
             daCAI:  cdsDocumentos.FieldByname('TIPO_2').AsString := 'CAI';
             daCCPI: cdsDocumentos.FieldByname('TIPO_2').AsString := 'CCPI';
             daCA:   cdsDocumentos.FieldByname('TIPO_2').AsString := 'CA';
             daTIF:  cdsDocumentos.FieldByname('TIPO_2').AsString := 'TIF';
             daOutros: cdsDocumentos.FieldByname('TIPO_2').AsString := 'Outros';
            end;
            cdsDocumentos.FieldByname('CNPJCPF_2').AsString := DFeUtil.FormatarCNPJCPF(FCTe.infCTeNorm.docAnt.emiDocAnt.Items[I].CNPJCPF);
            cdsDocumentos.FieldByname('DOCUMENTO_2').AsString := serie + '-' + IntToStr(nDoc);

            cdsDocumentos.Post;
          end;
          inc(Item);
        end;
      end;
    end;

    // Eletr�nico
    for J := 0 to (FCTe.infCTeNorm.docAnt.emiDocAnt.Items[I].idDocAnt.Count - 1) do
    begin
      for K := 0 to (FCTe.infCTeNorm.docAnt.emiDocAnt.Items[I].idDocAnt.Items[J].idDocAntEle.Count - 1) do
      begin
        with FCTe.infCTeNorm.docAnt.emiDocAnt.Items[I].idDocAnt.Items[J].idDocAntEle.Items[K] do
        begin
          if (Item mod 2) = 0 then
          begin
            cdsDocumentos.Append;

            cdsDocumentos.FieldByname('TIPO_1').AsString := 'CT-E';
            cdsDocumentos.FieldByname('CNPJCPF_1').AsString := CTeUtil.FormatarChaveAcesso(chave, True);
          end
          else
          begin
            cdsDocumentos.FieldByname('TIPO_2').AsString := 'CT-E';
            cdsDocumentos.FieldByname('CNPJCPF_2').AsString := CTeUtil.FormatarChaveAcesso(chave, True);

            cdsDocumentos.Post;
          end;
          inc(Item);
        end;
      end;
    end;

  end;
{$ELSE}
  //Varrendo NF comum
  for I := 0 to (FCTe.Rem.InfNF.Count - 1) do
  begin
    with FCTe.Rem.InfNF.Items[I] do
    begin
      if (Item mod 2) = 0 then
      begin
        cdsDocumentos.Append;

        cdsDocumentos.FieldByName('TIPO_1').AsString := 'NF';
        cdsDocumentos.FieldByName('CNPJCPF_1').AsString := DFeUtil.FormatarCNPJCPF(FCTe.Rem.CNPJCPF);
        cdsDocumentos.FieldByName('DOCUMENTO_1').AsString := serie + '-' + nDoc;
      end
      else
      begin
        cdsDocumentos.FieldByName('TIPO_2').AsString := 'NF';
        cdsDocumentos.FieldByName('CNPJCPF_2').AsString := DFeUtil.FormatarCNPJCPF(FCTe.Rem.CNPJCPF);
        cdsDocumentos.FieldByName('DOCUMENTO_2').AsString := serie + '-' + nDoc;

        cdsDocumentos.Post;
      end;
      Inc(Item);
    end;
  end;
  //Varrendo NFe
  for I := 0 to (FCTe.Rem.InfNFE.Count - 1) do
  begin
    with FCTe.Rem.InfNFE.Items[I] do
    begin
      if (Item mod 2) = 0 then
      begin
        cdsDocumentos.Append;
        cdsDocumentos.FieldByName('TIPO_1').AsString := 'NF-E ' + copy(chave, 26, 9);
        cdsDocumentos.FieldByName('CNPJCPF_1').AsString := CTeUtil.FormatarChaveAcesso(chave, True);
      end
      else
      begin
        cdsDocumentos.FieldByName('TIPO_2').AsString := 'NF-E ' + copy(chave, 26, 9);
        cdsDocumentos.FieldByName('CNPJCPF_2').AsString := CTeUtil.FormatarChaveAcesso(chave, True);
        cdsDocumentos.Post;
      end;
      Inc(Item);
    end;
  end;
  //Varrendo Outros
  for I := 0 to (FCTe.Rem.InfOutros.Count - 1) do
  begin
    with FCTe.Rem.InfOutros.Items[I] do
    begin
      if (Item mod 2) = 0 then
      begin
        cdsDocumentos.Append;
        // TpcteTipoDocumento = (tdDeclaracao, tdDutoviario, tdOutros);
        case tpDoc of
          tdDeclaracao:
          begin
            cdsDocumentos.FieldByName('TIPO_1').AsString := 'DECLAR';
            cdsDocumentos.FieldByName('CNPJCPF_1').AsString := DFeUtil.FormatarCNPJCPF(FCTe.Rem.CNPJCPF);
            cdsDocumentos.FieldByName('DOCUMENTO_1').AsString := 'Declara��o Doc.: ' + nDoc;
          end;
          tdDutoviario:
          begin
            cdsDocumentos.FieldByName('TIPO_1').AsString := 'DUTO';
            cdsDocumentos.FieldByName('CNPJCPF_1').AsString := DFeUtil.FormatarCNPJCPF(FCTe.Rem.CNPJCPF);
            cdsDocumentos.FieldByName('DOCUMENTO_1').AsString := 'Dutovi�rio Doc.: ' + nDoc;
          end;
          tdOutros:
          begin
            cdsDocumentos.FieldByName('TIPO_1').AsString := 'Outros';
            cdsDocumentos.FieldByName('CNPJCPF_1').AsString := DFeUtil.FormatarCNPJCPF(FCTe.Rem.CNPJCPF);
            cdsDocumentos.FieldByName('DOCUMENTO_1').AsString :=
              copy(trim(descOutros), 1, 20) + ' Doc.: ' + nDoc;
          end;
        end;
        //        cdsDocumentos.FieldByname('TIPO_1').AsString := descOutros;
        //        cdsDocumentos.FieldByname('CNPJCPF_1').AsString := DFeUtil.FormatarCNPJCPF(FCTe.Rem.CNPJCPF);
      end
      else
      begin
        // TpcteTipoDocumento = (tdDeclaracao, tdDutoviario, tdOutros);
        case tpDoc of
          tdDeclaracao:
          begin
            cdsDocumentos.FieldByName('TIPO_2').AsString := 'DECLAR';
            cdsDocumentos.FieldByName('CNPJCPF_2').AsString := DFeUtil.FormatarCNPJCPF(FCTe.Rem.CNPJCPF);
            cdsDocumentos.FieldByName('DOCUMENTO_2').AsString := 'Declara��o Doc.: ' + nDoc;
          end;
          tdDutoviario:
          begin
            cdsDocumentos.FieldByName('TIPO_2').AsString := 'DUTO';
            cdsDocumentos.FieldByName('CNPJCPF_2').AsString := DFeUtil.FormatarCNPJCPF(FCTe.Rem.CNPJCPF);
            cdsDocumentos.FieldByName('DOCUMENTO_2').AsString := 'Dutovi�rio Doc.: ' + nDoc;
          end;
          tdOutros:
          begin
            cdsDocumentos.FieldByName('TIPO_2').AsString := 'Outros';
            cdsDocumentos.FieldByName('CNPJCPF_2').AsString := DFeUtil.FormatarCNPJCPF(FCTe.Rem.CNPJCPF);
            cdsDocumentos.FieldByName('DOCUMENTO_2').AsString :=
              copy(trim(descOutros), 1, 20) + ' Doc.: ' + nDoc;
          end;
        end;
        //        cdsDocumentos.FieldByname('TIPO_2').AsString := descOutros;
        //        cdsDocumentos.FieldByname('CNPJCPF_2').AsString := DFeUtil.FormatarCNPJCPF(FCTe.Rem.CNPJCPF);
        cdsDocumentos.Post;
      end;
      Inc(Item);
    end;
  end;
  //Varrendo Documentos de Transporte anterior
  for I := 0 to (FCTe.infCTeNorm.emiDocAnt.Count - 1) do
  begin
    // Em Papel
    for J := 0 to (FCTe.infCTeNorm.emiDocAnt.Items[I].idDocAnt.Count - 1) do
    begin
      for K := 0 to (FCTe.infCTeNorm.emiDocAnt.Items[I].idDocAnt.Items[J].idDocAntPap.Count - 1) do
      begin
        with FCTe.infCTeNorm.emiDocAnt.Items[I].idDocAnt.Items[J].idDocAntPap.Items[K] do
        begin
          if (Item mod 2) = 0 then
          begin
            cdsDocumentos.Append;

            case tpDoc of
              daCTRC: cdsDocumentos.FieldByName('TIPO_1').AsString := 'CTRC';
              daCTAC: cdsDocumentos.FieldByName('TIPO_1').AsString := 'CTAC';
              daACT: cdsDocumentos.FieldByName('TIPO_1').AsString := 'ACT';
              daNF7: cdsDocumentos.FieldByName('TIPO_1').AsString := 'NF M7';
              daNF27: cdsDocumentos.FieldByName('TIPO_1').AsString := 'NF M27';
              daCAN: cdsDocumentos.FieldByName('TIPO_1').AsString := 'CAN';
              daCTMC: cdsDocumentos.FieldByName('TIPO_1').AsString := 'CTMC';
              daATRE: cdsDocumentos.FieldByName('TIPO_1').AsString := 'ATRE';
              daDTA: cdsDocumentos.FieldByName('TIPO_1').AsString := 'DTA';
              daCAI: cdsDocumentos.FieldByName('TIPO_1').AsString := 'CAI';
              daCCPI: cdsDocumentos.FieldByName('TIPO_1').AsString := 'CCPI';
              daCA: cdsDocumentos.FieldByName('TIPO_1').AsString := 'CA';
              daTIF: cdsDocumentos.FieldByName('TIPO_1').AsString := 'TIF';
              daOutros: cdsDocumentos.FieldByName('TIPO_1').AsString := 'Outros';
            end;
            cdsDocumentos.FieldByName('CNPJCPF_1').AsString :=
              DFeUtil.FormatarCNPJCPF(FCTe.infCTeNorm.emiDocAnt.Items[I].CNPJCPF);
            cdsDocumentos.FieldByName('DOCUMENTO_1').AsString := serie + '-' + IntToStr(nDoc);
          end
          else
          begin
            case tpDoc of
              daCTRC: cdsDocumentos.FieldByName('TIPO_2').AsString := 'CTRC';
              daCTAC: cdsDocumentos.FieldByName('TIPO_2').AsString := 'CTAC';
              daACT: cdsDocumentos.FieldByName('TIPO_2').AsString := 'ACT';
              daNF7: cdsDocumentos.FieldByName('TIPO_2').AsString := 'NF M7';
              daNF27: cdsDocumentos.FieldByName('TIPO_2').AsString := 'NF M27';
              daCAN: cdsDocumentos.FieldByName('TIPO_2').AsString := 'CAN';
              daCTMC: cdsDocumentos.FieldByName('TIPO_2').AsString := 'CTMC';
              daATRE: cdsDocumentos.FieldByName('TIPO_2').AsString := 'ATRE';
              daDTA: cdsDocumentos.FieldByName('TIPO_2').AsString := 'DTA';
              daCAI: cdsDocumentos.FieldByName('TIPO_2').AsString := 'CAI';
              daCCPI: cdsDocumentos.FieldByName('TIPO_2').AsString := 'CCPI';
              daCA: cdsDocumentos.FieldByName('TIPO_2').AsString := 'CA';
              daTIF: cdsDocumentos.FieldByName('TIPO_2').AsString := 'TIF';
              daOutros: cdsDocumentos.FieldByName('TIPO_2').AsString := 'Outros';
            end;
            cdsDocumentos.FieldByName('CNPJCPF_2').AsString :=
              DFeUtil.FormatarCNPJCPF(FCTe.infCTeNorm.emiDocAnt.Items[I].CNPJCPF);
            cdsDocumentos.FieldByName('DOCUMENTO_2').AsString := serie + '-' + IntToStr(nDoc);

            cdsDocumentos.Post;
          end;
          Inc(Item);
        end;
      end;
    end;

    // Eletr�nico
    for J := 0 to (FCTe.infCTeNorm.emiDocAnt.Items[I].idDocAnt.Count - 1) do
    begin
      for K := 0 to (FCTe.infCTeNorm.emiDocAnt.Items[I].idDocAnt.Items[J].idDocAntEle.Count - 1) do
      begin
        with FCTe.infCTeNorm.emiDocAnt.Items[I].idDocAnt.Items[J].idDocAntEle.Items[K] do
        begin
          if (Item mod 2) = 0 then
          begin
            cdsDocumentos.Append;

            cdsDocumentos.FieldByName('TIPO_1').AsString := 'CT-E';
            cdsDocumentos.FieldByName('CNPJCPF_1').AsString := CTeUtil.FormatarChaveAcesso(chave, True);
          end
          else
          begin
            cdsDocumentos.FieldByName('TIPO_2').AsString := 'CT-E';
            cdsDocumentos.FieldByName('CNPJCPF_2').AsString := CTeUtil.FormatarChaveAcesso(chave, True);

            cdsDocumentos.Post;
          end;
          Inc(Item);
        end;
      end;
    end;

  end;
{$ENDIF}

  cdsDocumentos.First;
end;

procedure TfrmDACTeRLRetrato.ProtocoloCTe(const sProtocolo: string);
begin
  FProtocoloCTe := sProtocolo;
end;

procedure TfrmDACTeRLRetrato.rlb_01_ReciboBeforePrint(Sender: TRLCustomBand; var PrintBand: boolean);
begin
  inherited;
  PrintBand := (RLCTe.PageNumber = 1) and (FCTe.Ide.modal <> mdAereo) and (FPosRecibo = prCabecalho);
  if (FResumoCanhoto) then
    rllResumoCanhotoCTe.Caption := getTextoResumoCanhoto
  else
    rllResumoCanhotoCTe.Caption := '';

  rllSerie2.Caption := IntToStr(FCTe.Ide.serie); // FormatFloat( '000', FCTe.Ide.serie);
  rllNumCte2.Caption := FormatFloat('000,000,000', FCTe.Ide.nCT);
  // TpcteTipoCTe = (tcNormal, tcComplemento, tcAnulacao, tcSubstituto);
  rlb_01_Recibo.Enabled := (FCTe.Ide.tpCTe = tcNormal) or (FCTe.Ide.tpCTe = tcComplemento);
end;

procedure TfrmDACTeRLRetrato.rlb_01_Recibo_AereoBeforePrint(Sender: TrlCustomBand; var PrintBand: boolean);
begin
  inherited;
  PrintBand := (RLCTe.PageNumber = 1) and (FCTe.Ide.modal = mdAereo);

  rlb_01_Recibo_Aereo.Enabled := (FCTe.Ide.tpCTe = tcNormal) or (FCTe.Ide.tpCTe = tcComplemento);
end;

procedure TfrmDACTeRLRetrato.rlb_02_CabecalhoBeforePrint(Sender: TrlCustomBand; var PrintBand: boolean);
var
  strChaveContingencia: string;
  vStringStream: TStringStream;
begin
  inherited;

  if (FLogo <> '') then
  begin
    if FilesExists(FLogo) then
      rliLogo.Picture.LoadFromFile(FLogo)
    else
    begin
      vStringStream := TStringStream.Create(FLogo);
      try
        try
          rliLogo.Picture.Bitmap.LoadFromStream(vStringStream);
        except
        end;
      finally
        vStringStream.Free;
      end;
    end;
  end
  else
  begin
    rlmDadosEmitente.Left  := 7;
    rlmDadosEmitente.Width := 321;
    rlmDadosEmitente.Alignment := taCenter;
  end;

  if FExpandirLogoMarca then
  begin
    rliLogo.top     := 3;
    rliLogo.Left    := 3;
    rliLogo.Height  := 91;
    rliLogo.Width   := 321;
    rliLogo.Stretch := True;
    rlmEmitente.Enabled      := False;
    rlmDadosEmitente.Enabled := False;
  end;

  rllModal.Caption   := TpModalToStrText(FCTe.Ide.modal);
  rllModelo.Caption  := FCTe.Ide.modelo;
  rllSerie.Caption   := IntToStr(FCTe.Ide.serie);  //FormatFloat( '000', FCTe.Ide.serie);
  rllNumCte.Caption  := FormatFloat('000,000,000', FCTe.Ide.nCT);
//  rllPageNumber.Caption   := format('%2.2d', [RLCTe.PageNumber]) + '/' + format('%2.2d', [FTotalPages]);
//  rllPageNumber.Caption   := format('%2.2d', [RLCTe.PageNumber]) + '/' + format('%2.2d', [RLCTe.rlPrinter.PageCount]);
  rllEmissao.Caption      := DFeUtil.FormatDateTime(DateTimeToStr(FCTe.Ide.dhEmi));
  rlbCodigoBarras.Caption := Copy(FCTe.InfCTe.Id, 4, 44);
  rllChave.Caption        := CTeUtil.FormatarChaveAcesso(Copy(FCTe.InfCTe.Id, 4, 44));

  if not FExpandirLogoMarca then
  begin
    rlmEmitente.Enabled := True;
    rlmDadosEmitente.Enabled := True;
    // Emitente
    with FCTe.Emit do
    begin
      rlmEmitente.Lines.Text := XNome;

      rlmDadosEmitente.Lines.Clear;
      with EnderEmit do
      begin
        rlmDadosEmitente.Lines.Add(XLgr + IfThen(Nro = '0', '', ', ' + Nro));
        if XCpl <> '' then
          rlmDadosEmitente.Lines.Add(XCpl);
        if XBairro <> '' then
          rlmDadosEmitente.Lines.Add(XBairro);
        rlmDadosEmitente.Lines.Add('CEP: ' + DFeUtil.FormatarCEP(FormatFloat('00000000', CEP)) +
          ' - ' + XMun + ' - ' + UF);
      end;
      rlmDadosEmitente.Lines.Add('CNPJ: ' + DFeUtil.FormatarCNPJ(CNPJ));
      rlmDadosEmitente.Lines.Add('INSCRI��O ESTADUAL: ' + IE);
      {rlmDadosEmitente.Lines.Add('TELEFONE: ' + DFeUtil.FormatarFone(EnderEmit.Fone));}

      if Trim(FUrl) <> '' then
        rlmDadosEmitente.Lines.Add('SITE: ' + FUrl);
      if Trim(FEmail) <> '' then
        rlmDadosEmitente.Lines.Add('E-MAIL: ' + FEmail);
    end;
  end;

  rllTipoCte.Caption     := tpCTToStrText(FCTe.Ide.tpCTe);
  rllTipoServico.Caption := TpServToStrText(FCTe.Ide.tpServ);
  if FCTe.Ide.Toma4.xNome = '' then
  begin
    rllTomaServico.Caption   := TpTomadorToStrText(FCTe.Ide.Toma03.Toma);
//    rlTomadorServico.Caption := TpTomadorToStrText(FCTe.Ide.Toma03.Toma);
  end
  else
  begin
    rllTomaServico.Caption   := TpTomadorToStrText(FCTe.Ide.Toma4.toma);
//    rlTomadorServico.Caption := TpTomadorToStrText(FCTe.Ide.Toma4.toma);
  end;                                                                   
  rllFormaPagamento.Caption := tpforPagToStrText(FCTe.Ide.forPag);
//  rlFormaPgto.Caption       := tpforPagToStrText(FCTe.Ide.forPag);

  // Normal **************************************************************
  if FCTe.Ide.tpEmis in [teNormal, teSCAN, teSVCSP, teSVCRS] then
  begin
    rllVariavel1.Enabled := True;
    RLBarcode1.Enabled := False;
    if FCTe.procCTe.cStat = 100 then
      rllDescricao.Caption := 'PROTOCOLO DE AUTORIZA��O DE USO';

    if FCTe.procCTe.cStat = 101 then
      rllDescricao.Caption := 'PROTOCOLO DE HOMOLOGA��O DE CANCELAMENTO';

    if FCTe.procCTe.cStat = 110 then
      rllDescricao.Caption := 'PROTOCOLO DE DENEGA��O DE USO';

    if FProtocoloCTE <> '' then
      rllProtocolo.Caption := FProtocoloCTE
    else
      rllProtocolo.Caption := FCTe.procCTe.nProt + '   ' +
        DFeUtil.SeSenao(FCTe.procCTe.dhRecbto <> 0,
        DateTimeToStr(FCTe.procCTe.dhRecbto), '');
  end;

  // Contingencia ********************************************************
  if FCTe.Ide.tpEmis in [teContingencia, teFSDA] then
  begin
    if FCTe.procCTe.cStat in [100, 101, 110] then
    begin
      rllVariavel1.Enabled := True;
      RLBarcode1.Enabled := False;
      if FCTe.procCTe.cStat = 100 then
        rllDescricao.Caption := 'PROTOCOLO DE AUTORIZA��O DE USO';

      if FCTe.procCTe.cStat = 101 then
        rllDescricao.Caption := 'PROTOCOLO DE HOMOLOGA��O DE CANCELAMENTO';

      if FCTe.procCTe.cStat = 110 then
        rllDescricao.Caption := 'PROTOCOLO DE DENEGA��O DE USO';

      if FProtocoloCTE <> '' then
        rllProtocolo.Caption := FProtocoloCTE
      else
        rllProtocolo.Caption := FCTe.procCTe.nProt + '   ' +
          DFeUtil.SeSenao(FCTe.procCTe.dhRecbto <> 0,
          DateTimeToStr(FCTe.procCTe.dhRecbto), '');
    end
    else
    begin
      rllVariavel1.Enabled := False;
      RLBarcode1.Enabled := True;

      strChaveContingencia := CTeUtil.GerarChaveContingencia(FCTe);
      RLBarcode1.Caption := strChaveContingencia;
      rllDescricao.Caption := 'DADOS DO CT-E';
      rllProtocolo.Caption := CTeUtil.FormatarChaveContingencia(strChaveContingencia);
    end;
  end;

  // EPEC ****************************************************************
  if FCTe.Ide.tpEmis = teDPEC then
  begin
    rllVariavel1.Enabled := False;
    RLBarcode1.Enabled := True;

    strChaveContingencia := CTeUtil.GerarChaveContingencia(FCTe);
    RLBarcode1.Caption := strChaveContingencia;
    rllDescricao.Caption := 'DADOS DO CT-E';
    rllProtocolo.Caption := CTeUtil.FormatarChaveContingencia(strChaveContingencia);
  end;

  rllInscSuframa.Caption := FCTe.Dest.ISUF;
end;

procedure TfrmDACTeRLRetrato.rlb_03_DadosDACTeBeforePrint(Sender: TrlCustomBand; var PrintBand: boolean);
var
  i: integer;
begin
  inherited;
  PrintBand := RLCTe.PageNumber = 1;

  rllNatOperacao.Caption := FormatFloat('0000', FCTe.Ide.CFOP) + ' - ' + FCTe.Ide.natOp;
  rllOrigPrestacao.Caption := FCTe.Ide.xMunIni + ' - ' + FCTe.Ide.UFIni + ' - ' + FormatFloat('000', FCTe.Ide.cMunIni);
  rllDestPrestacao.Caption := FCTe.Ide.xMunFim + ' - ' + FCTe.Ide.UFFim + ' - ' + FormatFloat('000', FCTe.Ide.cMunFim);

  //DADOS REMETENTE
  rllRazaoRemet.Caption := FCTe.Rem.xNome;
  rllEnderecoRemet1.Caption := FCTe.Rem.EnderReme.xLgr + ', ' + FCTe.Rem.EnderReme.nro;
  rllEnderecoRemet2.Caption := FCTe.Rem.EnderReme.xCpl + ' - ' + FCTe.Rem.EnderReme.xBairro;
  rllCEPRemet.Caption := DFeUtil.FormatarCEP(FormatFloat('00000000', FCTe.Rem.EnderReme.CEP));
  rllMunRemet.Caption := FCTe.Rem.EnderReme.xMun + ' - ' + FCTe.Rem.EnderReme.UF;
  rllCnpjRemet.Caption := DFeUtil.FormatarCNPJCPF(FCTe.Rem.CNPJCPF);
  rllPaisRemet.Caption := FCTe.Rem.EnderReme.xPais;
  rllInscEstRemet.Caption := FCTe.Rem.IE;
  rllFoneRemet.Caption := DFeUtil.FormatarFone(FCTe.Rem.fone);

  //DADOS DESTINATARIO
  rllRazaoDest.Caption := FCTe.Dest.xNome;
  rllEnderecoDest1.Caption := FCTe.Dest.EnderDest.xLgr + ', ' + FCTe.Dest.EnderDest.nro;
  rllEnderecoDest2.Caption := FCTe.Dest.EnderDest.xCpl + ' - ' + FCTe.Dest.EnderDest.xBairro;
  rllCEPDest.Caption := DFeUtil.FormatarCEP(FormatFloat('00000000', FCTe.Dest.EnderDest.CEP));
  rllMunDest.Caption := FCTe.Dest.EnderDest.xMun + ' - ' + FCTe.Dest.EnderDest.UF;
  rllCnpjDest.Caption := DFeUtil.FormatarCNPJCPF(FCTe.Dest.CNPJCPF);
  rllPaisDest.Caption := FCTe.Dest.EnderDest.xPais;
  rllInscEstDest.Caption := FCTe.Dest.IE;
  rllFoneDest.Caption := DFeUtil.FormatarFone(FCTe.Dest.fone);

  //DADOS EXPEDIDOR
  if FCTe.Exped.xNome <> '' then
  begin
    rllRazaoExped.Caption := FCTe.Exped.xNome;
    rllEnderecoExped1.Caption := FCTe.Exped.EnderExped.xLgr + ', ' + FCTe.Exped.EnderExped.nro;
    rllEnderecoExped2.Caption := FCTe.Exped.EnderExped.xCpl + ' - ' + FCTe.Exped.EnderExped.xBairro;
    rllCEPExped.Caption := DFeUtil.FormatarCEP(FormatFloat('00000000', FCTe.Exped.EnderExped.CEP));
    rllMunExped.Caption := FCTe.Exped.EnderExped.xMun + ' - ' + FCTe.Exped.EnderExped.UF;
    rllCnpjExped.Caption := DFeUtil.FormatarCNPJCPF(FCTe.Exped.CNPJCPF);
    rllPaisExped.Caption := FCTe.Exped.EnderExped.xPais;
    rllInscEstExped.Caption := FCTe.Exped.IE;
    rllFoneExped.Caption := DFeUtil.FormatarFone(FCTe.Exped.fone);
  end;

  //DADOS RECEBEDOR
  if FCTe.Receb.xNome <> '' then
  begin
    rllRazaoReceb.Caption := FCTe.Receb.xNome;
    rllEnderecoReceb1.Caption := FCTe.Receb.EnderReceb.xLgr + ', ' + FCTe.Receb.EnderReceb.nro;
    rllEnderecoReceb2.Caption := FCTe.Receb.EnderReceb.xCpl + ' - ' + FCTe.Receb.EnderReceb.xBairro;
    rllCEPReceb.Caption := DFeUtil.FormatarCEP(FormatFloat('00000000', FCTe.Receb.EnderReceb.CEP));
    rllMunReceb.Caption := FCTe.Receb.EnderReceb.xMun + ' - ' + FCTe.Receb.EnderReceb.UF;
    rllCnpjReceb.Caption := DFeUtil.FormatarCNPJCPF(FCTe.Receb.CNPJCPF);
    rllPaisReceb.Caption := FCTe.Receb.EnderReceb.xPais;
    rllInscEstReceb.Caption := FCTe.Receb.IE;
    rllFoneReceb.Caption := DFeUtil.FormatarFone(FCTe.Receb.fone);
  end;

  if FCTe.Ide.Toma4.xNome = '' then
  begin
    case FCTe.Ide.Toma03.Toma of
      tmRemetente:
      begin
        rllRazaoToma.Caption := FCTe.Rem.xNome;
        rllEnderecoToma.Caption := FCTe.Rem.EnderReme.xLgr + ', ' + FCTe.Rem.EnderReme.nro +
          ' - ' + FCTe.Rem.EnderReme.xCpl + ' - ' + FCTe.Rem.EnderReme.xBairro;
        rllCEPToma.Caption := DFeUtil.FormatarCEP(FormatFloat('00000000', FCTe.Rem.EnderReme.CEP));
        rllMunToma.Caption := FCTe.Rem.EnderReme.xMun + ' - ' + FCTe.Rem.EnderReme.UF;
        rllCnpjToma.Caption := DFeUtil.FormatarCNPJCPF(FCTe.Rem.CNPJCPF);
        rllPaisToma.Caption := FCTe.Rem.EnderReme.xPais;
        rllInscEstToma.Caption := FCTe.Rem.IE;
        rllFoneToma.Caption := DFeUtil.FormatarFone(FCTe.Rem.fone);
      end;
      tmExpedidor:
      begin
        rllRazaoToma.Caption := FCTe.Exped.xNome;
        rllEnderecoToma.Caption := FCTe.Exped.EnderExped.xLgr + ', ' + FCTe.Exped.EnderExped.nro +
          ' - ' + FCTe.Exped.EnderExped.xCpl + ' - ' + FCTe.Exped.EnderExped.xBairro;
        rllCEPToma.Caption := DFeUtil.FormatarCEP(FormatFloat('00000000', FCTe.Exped.EnderExped.CEP));
        rllMunToma.Caption := FCTe.Exped.EnderExped.xMun + ' - ' + FCTe.Exped.EnderExped.UF;
        rllCnpjToma.Caption := DFeUtil.FormatarCNPJCPF(FCTe.Exped.CNPJCPF);
        rllPaisToma.Caption := FCTe.Exped.EnderExped.xPais;
        rllInscEstToma.Caption := FCTe.Exped.IE;
        rllFoneToma.Caption := DFeUtil.FormatarFone(FCTe.Exped.fone);
      end;
      tmRecebedor:
      begin
        rllRazaoToma.Caption := FCTe.Receb.xNome;
        rllEnderecoToma.Caption := FCTe.Receb.EnderReceb.xLgr + ', ' + FCTe.Receb.EnderReceb.nro +
          ' - ' + FCTe.Receb.EnderReceb.xCpl + ' - ' + FCTe.Receb.EnderReceb.xBairro;
        rllCEPToma.Caption := DFeUtil.FormatarCEP(FormatFloat('00000000', FCTe.Receb.EnderReceb.CEP));
        rllMunToma.Caption := FCTe.Receb.EnderReceb.xMun + ' - ' + FCTe.Receb.EnderReceb.UF;
        rllCnpjToma.Caption := DFeUtil.FormatarCNPJCPF(FCTe.Receb.CNPJCPF);
        rllPaisToma.Caption := FCTe.Receb.EnderReceb.xPais;
        rllInscEstToma.Caption := FCTe.Receb.IE;
        rllFoneToma.Caption := DFeUtil.FormatarFone(FCTe.Receb.fone);
      end;
      tmDestinatario:
      begin
        rllRazaoToma.Caption := FCTe.Dest.xNome;
        rllEnderecoToma.Caption := FCTe.Dest.EnderDest.xLgr + ', ' + FCTe.Dest.EnderDest.nro +
          ' - ' + FCTe.Dest.EnderDest.xCpl + ' - ' + FCTe.Dest.EnderDest.xBairro;
        rllCEPToma.Caption := DFeUtil.FormatarCEP(FormatFloat('00000000', FCTe.Dest.EnderDest.CEP));
        rllMunToma.Caption := FCTe.Dest.EnderDest.xMun + ' - ' + FCTe.Dest.EnderDest.UF;
        rllCnpjToma.Caption := DFeUtil.FormatarCNPJCPF(FCTe.Dest.CNPJCPF);
        rllPaisToma.Caption := FCTe.Dest.EnderDest.xPais;
        rllInscEstToma.Caption := FCTe.Dest.IE;
        rllFoneToma.Caption := DFeUtil.FormatarFone(FCTe.Dest.fone);
      end;
    end;
  end
  else
  begin
    if FCTe.Ide.Toma4.xNome <> '' then
    begin
      rllRazaoToma.Caption := FCTe.Ide.Toma4.xNome;
      rllEnderecoToma.Caption := FCTe.Ide.Toma4.EnderToma.xLgr + ', ' + FCTe.Ide.Toma4.EnderToma.nro +
        ' - ' + FCTe.Ide.Toma4.EnderToma.xCpl + ' - ' + FCTe.Ide.Toma4.EnderToma.xBairro;
      rllCEPToma.Caption := DFeUtil.FormatarCEP(FormatFloat('00000000', FCTe.Ide.Toma4.EnderToma.CEP));
      rllMunToma.Caption := FCTe.Ide.Toma4.EnderToma.xMun + ' - ' + FCTe.Ide.Toma4.EnderToma.UF;
      rllCnpjToma.Caption := DFeUtil.FormatarCNPJCPF(FCTe.Ide.Toma4.CNPJCPF);
      rllPaisToma.Caption := FCTe.Ide.Toma4.EnderToma.xPais;
      rllInscEstToma.Caption := FCTe.Ide.Toma4.IE;
      rllFoneToma.Caption := DFeUtil.FormatarFone(FCTe.Ide.Toma4.fone);
    end;
  end;

{$IFDEF PL_200}
  rllProdPredominante.Caption := FCTe.infCTeNorm.infCarga.proPred;
  rllOutrasCaracCarga.Caption := FCTe.infCTeNorm.InfCarga.xOutCat;
{$ELSE}
  rllProdPredominante.Caption := FCTe.InfCarga.proPred;
  rllOutrasCaracCarga.Caption := FCTe.InfCarga.xOutCat;
{$ENDIF}
{$IFDEF PL_103}
  rllVlrTotalMerc.Caption := CTeUtil.FormatarValor(msk15x2, FCTe.InfCarga.vMerc);
{$ENDIF}
{$IFDEF PL_104}
  rllVlrTotalMerc.Caption := CTeUtil.FormatarValor(msk15x2, FCTe.InfCarga.vCarga);
{$ENDIF}
{$IFDEF PL_200}
  rllVlrTotalMerc.Caption := CTeUtil.FormatarValor(msk15x2, FCTe.infCTeNorm.infCarga.vCarga);
{$ENDIF}

  rlmQtdUnidMedida1.Lines.Clear;
  rlmQtdUnidMedida2.Lines.Clear;
  rlmQtdUnidMedida3.Lines.Clear;
  rlmQtdUnidMedida4.Lines.Clear;
  rlmQtdUnidMedida5.Lines.Clear;

  rlmNomeSeguradora.Lines.Clear;
  rlmRespSeguroMerc.Lines.Clear;
  rlmNroApolice.Lines.Clear;
  rlMNroAverbacao.Lines.Clear;

  //  rllNomeSeguradora.Caption := '';
  //  rllRespSeguroMerc.Caption := '';
  //  rllNroApolice.Caption     := '';
  //  rllNroAverbacao.Caption   := '';

  rlmCompNome1.Lines.Clear;
  rlmCompNome2.Lines.Clear;
  rlmCompNome3.Lines.Clear;
  rlmCompValor1.Lines.Clear;
  rlmCompValor2.Lines.Clear;
  rlmCompValor3.Lines.Clear;

{$IFDEF PL_200}
  for i := 0 to (FCTe.infCTeNorm.InfCarga.InfQ.Count - 1) do
   begin
    //UnidMed = (uM3,uKG, uTON, uUNIDADE, uLITROS, uMMBTU);
    case FCTe.infCTeNorm.InfCarga.InfQ.Items[i].cUnid of
          uM3: rlmQtdUnidMedida4.Lines.Add(CTeUtil.FormatarValor(msk6x3,
                 FCTe.infCTeNorm.InfCarga.InfQ.Items[i].qCarga));
          uKg: begin
                if uppercase(trim(FCTe.infCTeNorm.InfCarga.InfQ.Items[i].tpMed))='PESO BRUTO'
                then rlmQtdUnidMedida1.Lines.Add(CTeUtil.FormatarValor(msk6x3,
                        FCTe.infCTeNorm.InfCarga.InfQ.Items[i].qCarga))
                else
                if uppercase(trim(FCTe.infCTeNorm.InfCarga.InfQ.Items[i].tpMed))='PESO BASE DE CALCULO'
                then rlmQtdUnidMedida2.Lines.Add(CTeUtil.FormatarValor(msk6x3,
                        FCTe.infCTeNorm.InfCarga.InfQ.Items[i].qCarga))
                else
                if uppercase(trim(FCTe.infCTeNorm.InfCarga.InfQ.Items[i].tpMed))='PESO BC'
                then rlmQtdUnidMedida2.Lines.Add(CTeUtil.FormatarValor(msk6x3,
                        FCTe.infCTeNorm.InfCarga.InfQ.Items[i].qCarga))
                else rlmQtdUnidMedida3.Lines.Add(CTeUtil.FormatarValor(msk6x3,
                        FCTe.infCTeNorm.InfCarga.InfQ.Items[i].qCarga));
               end;
         uTON: begin
                if uppercase(trim(FCTe.infCTeNorm.InfCarga.InfQ.Items[i].tpMed))='PESO BRUTO'
                then rlmQtdUnidMedida1.Lines.Add(CTeUtil.FormatarValor(msk6x3,
                        FCTe.infCTeNorm.InfCarga.InfQ.Items[i].qCarga * 1000))
                else
                if uppercase(trim(FCTe.infCTeNorm.InfCarga.InfQ.Items[i].tpMed))='PESO BASE DE CALCULO'
                then rlmQtdUnidMedida2.Lines.Add(CTeUtil.FormatarValor(msk6x3,
                        FCTe.infCTeNorm.InfCarga.InfQ.Items[i].qCarga * 1000))
                else
                if uppercase(trim(FCTe.infCTeNorm.InfCarga.InfQ.Items[i].tpMed))='PESO BC'
                then rlmQtdUnidMedida2.Lines.Add(CTeUtil.FormatarValor(msk6x3,
                        FCTe.infCTeNorm.InfCarga.InfQ.Items[i].qCarga * 1000))
                else rlmQtdUnidMedida3.Lines.Add(CTeUtil.FormatarValor(msk6x3,
                        FCTe.infCTeNorm.InfCarga.InfQ.Items[i].qCarga * 1000));
               end;
     uUNIDADE: rlmQtdUnidMedida5.Lines.Add(CTeUtil.FormatarValor(msk6x3,
                 FCTe.infCTeNorm.InfCarga.InfQ.Items[i].qCarga) + '/' + FCTe.infCTeNorm.InfCarga.InfQ.Items[i].tpMed);
     uLITROS:  rlmQtdUnidMedida5.Lines.Add(CTeUtil.FormatarValor(msk6x3,
                 FCTe.infCTeNorm.InfCarga.InfQ.Items[i].qCarga) + '/' + FCTe.infCTeNorm.InfCarga.InfQ.Items[i].tpMed);
     uMMBTU:   rlmQtdUnidMedida5.Lines.Add(CTeUtil.FormatarValor(msk6x3,
                 FCTe.infCTeNorm.InfCarga.InfQ.Items[i].qCarga) + '/' + FCTe.infCTeNorm.InfCarga.InfQ.Items[i].tpMed);
    end;
   end;

  if FCTe.infCTeNorm.seg.Count > 0 then
  begin
    for i := 0 to FCTe.infCTeNorm.seg.Count-1 do
     begin
      rlmNomeSeguradora.Lines.Add(FCTe.infCTeNorm.seg.Items[i].xSeg);
      rlmRespSeguroMerc.Lines.Add(TpRspSeguroToStrText(FCTe.infCTeNorm.seg.Items[i].respSeg));
      rlmNroApolice.Lines.Add(FCTe.infCTeNorm.seg.Items[i].nApol);
      rlmNroAverbacao.Lines.Add(FCTe.infCTeNorm.seg.Items[i].nAver);
     end;
//    rllNomeSeguradora.Caption := FCTe.infCTeNorm.seg.Items[0].xSeg;
//    rllRespSeguroMerc.Caption := TpRspSeguroToStrText(FCTe.infCTeNorm.seg.Items[0].respSeg);
//    rllNroApolice.Caption := FCTe.infCTeNorm.seg.Items[0].nApol;
//    rllNroAverbacao.Caption := FCTe.infCTeNorm.seg.Items[0].nAver;
  end;

  for i := 0 to (FCTe.vPrest.comp.Count - 1) do
  begin
    case i of
      0,3,6,9:
        begin
          rlmCompNome1.Lines.Add(FCTe.vPrest.comp[i].xNome);
          rlmCompValor1.Lines.Add(CTeUtil.FormatarValor(msk10x2, FCTe.vPrest.comp[i].vComp));
        end;
      1,4,7,10:
        begin
          rlmCompNome2.Lines.Add(FCTe.vPrest.comp[i].xNome);
          rlmCompValor2.Lines.Add(CTeUtil.FormatarValor(msk10x2, FCTe.vPrest.comp[i].vComp));
        end;
      2,5,8,11:
        begin
          rlmCompNome3.Lines.Add(FCTe.vPrest.comp[i].xNome);
          rlmCompValor3.Lines.Add(CTeUtil.FormatarValor(msk10x2, FCTe.vPrest.comp[i].vComp));
        end;
    end;
  end;

  rllVlrTotServico.Caption := CTeUtil.FormatarValor(msk13x2, FCTe.vPrest.vTPrest);
  rllVlrTotReceber.Caption := CTeUtil.FormatarValor(msk13x2, FCTe.vPrest.vRec);

  rllSitTrib.Caption := CSTICMSToStr(FCTe.Imp.ICMS.SituTrib)+'-'+
                        CSTICMSToStrTagPosText(FCTe.Imp.ICMS.SituTrib);
{$ELSE}
  for i := 0 to (FCTe.InfCarga.InfQ.Count - 1) do
  begin
    //UnidMed = (uM3,uKG, uTON, uUNIDADE, uLITROS, uMMBTU);
    case FCTe.InfCarga.InfQ.Items[i].cUnid of
      uM3: rlmQtdUnidMedida4.Lines.Add(CTeUtil.FormatarValor(msk6x3,
          FCTe.InfCarga.InfQ.Items[i].qCarga));
      uKg:
      begin
        if uppercase(trim(FCTe.InfCarga.InfQ.Items[i].tpMed)) = 'PESO BRUTO' then
          rlmQtdUnidMedida1.Lines.Add(CTeUtil.FormatarValor(msk6x3,
            FCTe.InfCarga.InfQ.Items[i].qCarga))
        else
        if uppercase(trim(FCTe.InfCarga.InfQ.Items[i].tpMed)) = 'PESO BASE DE CALCULO' then
          rlmQtdUnidMedida2.Lines.Add(CTeUtil.FormatarValor(msk6x3,
            FCTe.InfCarga.InfQ.Items[i].qCarga))
        else
        if uppercase(trim(FCTe.InfCarga.InfQ.Items[i].tpMed)) = 'PESO BC' then
          rlmQtdUnidMedida2.Lines.Add(CTeUtil.FormatarValor(msk6x3,
            FCTe.InfCarga.InfQ.Items[i].qCarga))
        else
          rlmQtdUnidMedida3.Lines.Add(CTeUtil.FormatarValor(msk6x3,
            FCTe.InfCarga.InfQ.Items[i].qCarga));
      end;
      uTON:
      begin
        if uppercase(trim(FCTe.InfCarga.InfQ.Items[i].tpMed)) = 'PESO BRUTO' then
          rlmQtdUnidMedida1.Lines.Add(CTeUtil.FormatarValor(msk6x3,
            FCTe.InfCarga.InfQ.Items[i].qCarga * 1000))
        else
        if uppercase(trim(FCTe.InfCarga.InfQ.Items[i].tpMed)) = 'PESO BASE DE CALCULO' then
          rlmQtdUnidMedida2.Lines.Add(CTeUtil.FormatarValor(msk6x3,
            FCTe.InfCarga.InfQ.Items[i].qCarga * 1000))
        else
        if uppercase(trim(FCTe.InfCarga.InfQ.Items[i].tpMed)) = 'PESO BC' then
          rlmQtdUnidMedida2.Lines.Add(CTeUtil.FormatarValor(msk6x3,
            FCTe.InfCarga.InfQ.Items[i].qCarga * 1000))
        else
          rlmQtdUnidMedida3.Lines.Add(CTeUtil.FormatarValor(msk6x3,
            FCTe.InfCarga.InfQ.Items[i].qCarga * 1000));
      end;
      uUNIDADE: rlmQtdUnidMedida5.Lines.Add(CTeUtil.FormatarValor(msk6x3,
          FCTe.InfCarga.InfQ.Items[i].qCarga) + ' ' + FCTe.InfCarga.InfQ.Items[i].tpMed);
      uLITROS: rlmQtdUnidMedida5.Lines.Add(CTeUtil.FormatarValor(msk6x3,
          FCTe.InfCarga.InfQ.Items[i].qCarga) + ' ' + FCTe.InfCarga.InfQ.Items[i].tpMed);
      uMMBTU: rlmQtdUnidMedida5.Lines.Add(CTeUtil.FormatarValor(msk6x3,
          FCTe.InfCarga.InfQ.Items[i].qCarga) + ' ' + FCTe.InfCarga.InfQ.Items[i].tpMed);
    end;
  end;

  if FCTe.InfSeg.Count > 0 then
  begin
    for i := 0 to FCTe.infSeg.Count - 1 do
    begin
      rlmNomeSeguradora.Lines.Add(FCTe.infSeg.Items[i].xSeg);
      rlmRespSeguroMerc.Lines.Add(TpRspSeguroToStrText(FCTe.infSeg.Items[i].respSeg));
      rlmNroApolice.Lines.Add(FCTe.infSeg.Items[i].nApol);
      rlmNroAverbacao.Lines.Add(FCTe.infSeg.Items[i].nAver);
    end;
    //    rllNomeSeguradora.Caption := FCTe.InfSeg.Items[0].xSeg;
    //    rllRespSeguroMerc.Caption := TpRspSeguroToStrText(FCTe.InfSeg.Items[0].respSeg);
    //    rllNroApolice.Caption := FCTe.InfSeg.Items[0].nApol;
    //    rllNroAverbacao.Caption := FCTe.InfSeg.Items[0].nAver;
  end;

  for i := 0 to (FCTe.vPrest.comp.Count - 1) do
  begin
    case i of
      0, 3, 6, 9:
      begin
        rlmCompNome1.Lines.Add(FCTe.vPrest.comp[i].xNome);
        rlmCompValor1.Lines.Add(CTeUtil.FormatarValor(msk10x2, FCTe.vPrest.comp[i].vComp));
      end;
      1, 4, 7, 10:
      begin
        rlmCompNome2.Lines.Add(FCTe.vPrest.comp[i].xNome);
        rlmCompValor2.Lines.Add(CTeUtil.FormatarValor(msk10x2, FCTe.vPrest.comp[i].vComp));
      end;
      2, 5, 8, 11:
      begin
        rlmCompNome3.Lines.Add(FCTe.vPrest.comp[i].xNome);
        rlmCompValor3.Lines.Add(CTeUtil.FormatarValor(msk10x2, FCTe.vPrest.comp[i].vComp));
      end;
    end;
  end;

  rllVlrTotServico.Caption := CTeUtil.FormatarValor(msk13x2, FCTe.vPrest.vTPrest);
  rllVlrTotReceber.Caption := CTeUtil.FormatarValor(msk13x2, FCTe.vPrest.vRec);

  rllSitTrib.Caption := CSTICMSToStr(FCTe.Imp.ICMS.SituTrib) + '-' +
    CSTICMSToStrTagPosText(FCTe.Imp.ICMS.SituTrib);
{$ENDIF}

{$IFDEF PL_103}
  case FCTe.Imp.ICMS.SituTrib of
    cst00:
      begin
        rllRedBaseCalc.Caption := '';
        rllBaseCalc.Caption    := CTeUtil.FormatarValor(msk9x2, FCTe.Imp.ICMS.CST00.vBC);
//        rllAliqICMS.Caption    := CTeUtil.FormatarValor(mskAliq, FCTe.Imp.ICMS.CST00.pICMS);
        rllAliqICMS.Caption    := CTeUtil.FormatarValor(msk4x2, FCTe.Imp.ICMS.CST00.pICMS);
        rllVlrICMS.Caption     := CTeUtil.FormatarValor(msk4x2, FCTe.Imp.ICMS.CST00.vICMS);
        rllICMS_ST.Caption     := '';
      end;
    cst20:
      begin
//        rllRedBaseCalc.Caption := CTeUtil.FormatarValor(mskAliq, FCTe.Imp.ICMS.CST20.pRedBC);
        rllRedBaseCalc.Caption := CTeUtil.FormatarValor(msk4x2, FCTe.Imp.ICMS.CST20.pRedBC);
        rllBaseCalc.Caption    := CTeUtil.FormatarValor(msk9x2, FCTe.Imp.ICMS.CST20.vBC);
//        rllAliqICMS.Caption    := CTeUtil.FormatarValor(mskAliq, FCTe.Imp.ICMS.CST20.pICMS);
        rllAliqICMS.Caption    := CTeUtil.FormatarValor(msk4x2, FCTe.Imp.ICMS.CST20.pICMS);
        rllVlrICMS.Caption     := CTeUtil.FormatarValor(msk4x2, FCTe.Imp.ICMS.CST20.vICMS);
        rllICMS_ST.Caption     := '';
        // CTeUtil.FormatarValor(msk4x2, FCTe.Imp.ICMS.CST20.vICMS);
      end;
    cst40:
      begin
        rllRedBaseCalc.Caption := '';
        rllBaseCalc.Caption    := '';
        rllAliqICMS.Caption    := '';
        rllVlrICMS.Caption     := '';
        rllICMS_ST.Caption     := '';
      end;
    cst41:
      begin
        rllRedBaseCalc.Caption := '';
        rllBaseCalc.Caption    := '';
        rllAliqICMS.Caption    := '';
        rllVlrICMS.Caption     := '';
        rllICMS_ST.Caption     := '';
      end;
    cst45:
      begin
        rllRedBaseCalc.Caption := '';
        rllBaseCalc.Caption    := '';
        rllAliqICMS.Caption    := '';
        rllVlrICMS.Caption     := '';
        rllICMS_ST.Caption     := '';
      end;
    cst51:
      begin
        rllRedBaseCalc.Caption := '';
        rllBaseCalc.Caption    := '';
        rllAliqICMS.Caption    := '';
        rllVlrICMS.Caption     := '';
        rllICMS_ST.Caption     := '';
      end;
    cst80:
      begin
        rllRedBaseCalc.Caption := '';
        rllBaseCalc.Caption    := CTeUtil.FormatarValor(msk9x2, FCTe.Imp.ICMS.CST80.vBC);
//        rllAliqICMS.Caption    := CTeUtil.FormatarValor(mskAliq, FCTe.Imp.ICMS.CST80.pICMS);
        rllAliqICMS.Caption    := CTeUtil.FormatarValor(msk4x2, FCTe.Imp.ICMS.CST80.pICMS);
        rllVlrICMS.Caption     := CTeUtil.FormatarValor(msk9x2, FCTe.Imp.ICMS.CST80.vICMS);
        rllICMS_ST.Caption     := CTeUtil.FormatarValor(msk9x2, FCTe.Imp.ICMS.CST80.vCred);
      end;
    cst81:
      begin
//        rllRedBaseCalc.Caption := CTeUtil.FormatarValor(mskAliq, FCTe.Imp.ICMS.CST81.pRedBC);
        rllRedBaseCalc.Caption := CTeUtil.FormatarValor(msk4x2, FCTe.Imp.ICMS.CST81.pRedBC);
        rllBaseCalc.Caption    := CTeUtil.FormatarValor(msk9x2, FCTe.Imp.ICMS.CST81.vBC);
//        rllAliqICMS.Caption    := CTeUtil.FormatarValor(mskAliq, FCTe.Imp.ICMS.CST81.pICMS);
        rllAliqICMS.Caption    := CTeUtil.FormatarValor(msk4x2, FCTe.Imp.ICMS.CST81.pICMS);
        rllVlrICMS.Caption     := CTeUtil.FormatarValor(msk9x2, FCTe.Imp.ICMS.CST81.vICMS);
        rllICMS_ST.Caption     := '';
        // CTeUtil.FormatarValor(msk9x2, FCTe.Imp.ICMS.CST81.vICMS);
      end;
    cst90:
      begin
//        rllRedBaseCalc.Caption := CTeUtil.FormatarValor(mskAliq, FCTe.Imp.ICMS.CST90.pRedBC);
        rllRedBaseCalc.Caption := CTeUtil.FormatarValor(msk4x2, FCTe.Imp.ICMS.CST90.pRedBC);
        rllBaseCalc.Caption    := CTeUtil.FormatarValor(msk9x2, FCTe.Imp.ICMS.CST90.vBC);
//        rllAliqICMS.Caption    := CTeUtil.FormatarValor(mskAliq, FCTe.Imp.ICMS.CST90.pICMS);
        rllAliqICMS.Caption    := CTeUtil.FormatarValor(msk4x2, FCTe.Imp.ICMS.CST90.pICMS);
        rllVlrICMS.Caption     := CTeUtil.FormatarValor(msk9x2, FCTe.Imp.ICMS.CST90.vICMS);
        rllICMS_ST.Caption     := CTeUtil.FormatarValor(msk4x2, FCTe.Imp.ICMS.CST90.vCred);
      end;
  end;
{$ELSE}
  //{$ENDIF}
  //{$IFDEF PL_104}
  case FCTe.Imp.ICMS.SituTrib of
    cst00:
    begin
      rllRedBaseCalc.Caption := '';
      rllBaseCalc.Caption := CTeUtil.FormatarValor(msk9x2, FCTe.Imp.ICMS.ICMS00.vBC);
      rllAliqICMS.Caption := CTeUtil.FormatarValor(msk4x2, FCTe.Imp.ICMS.ICMS00.pICMS);
      rllVlrICMS.Caption := CTeUtil.FormatarValor(msk4x2, FCTe.Imp.ICMS.ICMS00.vICMS);
      rllICMS_ST.Caption := '';
    end;
    cst20:
    begin
      //        rllRedBaseCalc.Caption := CTeUtil.FormatarValor(mskAliq, FCTe.Imp.ICMS.ICMS20.pRedBC);
      rllRedBaseCalc.Caption := CTeUtil.FormatarValor(msk4x2, FCTe.Imp.ICMS.ICMS20.pRedBC);
      rllBaseCalc.Caption := CTeUtil.FormatarValor(msk9x2, FCTe.Imp.ICMS.ICMS20.vBC);
      rllAliqICMS.Caption := CTeUtil.FormatarValor(msk4x2, FCTe.Imp.ICMS.ICMS20.pICMS);
      rllVlrICMS.Caption := CTeUtil.FormatarValor(msk4x2, FCTe.Imp.ICMS.ICMS20.vICMS);
      rllICMS_ST.Caption := '';
    end;
    cst40:
    begin
      rllRedBaseCalc.Caption := '';
      rllBaseCalc.Caption := '';
      rllAliqICMS.Caption := '';
      rllVlrICMS.Caption := '';
      rllICMS_ST.Caption := '';
    end;
    cst41:
    begin
      rllRedBaseCalc.Caption := '';
      rllBaseCalc.Caption := '';
      rllAliqICMS.Caption := '';
      rllVlrICMS.Caption := '';
      rllICMS_ST.Caption := '';
    end;
    cst45:
    begin
      rllRedBaseCalc.Caption := '';
      rllBaseCalc.Caption := '';
      rllAliqICMS.Caption := '';
      rllVlrICMS.Caption := '';
      rllICMS_ST.Caption := '';
    end;
    cst51:
    begin
      rllRedBaseCalc.Caption := '';
      rllBaseCalc.Caption := '';
      rllAliqICMS.Caption := '';
      rllVlrICMS.Caption := '';
      rllICMS_ST.Caption := '';
    end;
    cst60:
    begin
      rllRedBaseCalc.Caption := '';
      rllBaseCalc.Caption := CTeUtil.FormatarValor(msk9x2, FCTe.Imp.ICMS.ICMS60.vBCSTRet);
      rllAliqICMS.Caption := CTeUtil.FormatarValor(msk4x2, FCTe.Imp.ICMS.ICMS60.pICMSSTRet);
      //        rllVlrICMS.Caption     := CTeUtil.FormatarValor(msk9x2, FCTe.Imp.ICMS.ICMS60.vICMSSTRet);
      rllVlrICMS.Caption := '';
      //        rllICMS_ST.Caption     := CTeUtil.FormatarValor(msk9x2, FCTe.Imp.ICMS.ICMS60.vCred);
      rllICMS_ST.Caption := CTeUtil.FormatarValor(msk9x2, FCTe.Imp.ICMS.ICMS60.vICMSSTRet);
    end;
    cst90:
    begin
      //        rllRedBaseCalc.Caption := CTeUtil.FormatarValor(mskAliq, FCTe.Imp.ICMS.ICMS90.pRedBC);
      rllRedBaseCalc.Caption := CTeUtil.FormatarValor(msk4x2, FCTe.Imp.ICMS.ICMS90.pRedBC);
      rllBaseCalc.Caption := CTeUtil.FormatarValor(msk9x2, FCTe.Imp.ICMS.ICMS90.vBC);
      rllAliqICMS.Caption := CTeUtil.FormatarValor(msk4x2, FCTe.Imp.ICMS.ICMS90.pICMS);
      rllVlrICMS.Caption := CTeUtil.FormatarValor(msk9x2, FCTe.Imp.ICMS.ICMS90.vICMS);
      //        rllICMS_ST.Caption     := CTeUtil.FormatarValor(msk4x2, FCTe.Imp.ICMS.ICMS90.vCred);
      rllICMS_ST.Caption := '';
    end;
    cstICMSOutraUF:
    begin
      //        rllRedBaseCalc.Caption := CTeUtil.FormatarValor(mskAliq, FCTe.Imp.ICMS.ICMSOutraUF.pRedBCOutraUF);
      rllRedBaseCalc.Caption := CTeUtil.FormatarValor(msk4x2, FCTe.Imp.ICMS.ICMSOutraUF.pRedBCOutraUF);
      rllBaseCalc.Caption := CTeUtil.FormatarValor(msk9x2, FCTe.Imp.ICMS.ICMSOutraUF.vBCOutraUF);
      rllAliqICMS.Caption := CTeUtil.FormatarValor(msk4x2, FCTe.Imp.ICMS.ICMSOutraUF.pICMSOutraUF);
      rllVlrICMS.Caption := CTeUtil.FormatarValor(msk9x2, FCTe.Imp.ICMS.ICMSOutraUF.vICMSOutraUF);
      rllICMS_ST.Caption := '';
    end;
    cstICMSSN:
    begin
      rllRedBaseCalc.Caption := '';
      rllBaseCalc.Caption := '';
      rllAliqICMS.Caption := '';
      rllVlrICMS.Caption := '';
      rllICMS_ST.Caption := '';
    end;
  end;
{$ENDIF}
end;

procedure TfrmDACTeRLRetrato.rlb_04_DadosNotaFiscalBeforePrint(Sender: TrlCustomBand; var PrintBand: boolean);
begin
  inherited;
  PrintBand := RLCTe.PageNumber = 1;

  // Imprime os dados da da Nota Fiscal se o Tipo de CTe for Normal ou Substituto
  rlb_04_DadosNotaFiscal.Enabled := (FCTe.Ide.tpCTe = tcNormal) or (FCTe.Ide.tpCTe = tcSubstituto);
end;

procedure TfrmDACTeRLRetrato.rlb_05_ComplementoBeforePrint(Sender: TrlCustomBand; var PrintBand: boolean);
{$IFNDEF PL_200}
var
  i: integer;
{$ENDIF}
begin
  // Imprime a lista dos CT-e Complementados se o Tipo de CTe for Complemento

  inherited;
  rlb_05_Complemento.Enabled := (FCTe.Ide.tpCTe = tcComplemento);
  if not rlb_05_Complemento.Enabled then
    rlb_05_Complemento.Height := 0;

  PrintBand := (RLCTe.PageNumber = 1);

  rlmComplChave1.Lines.Clear;
  rlmComplValor1.Lines.Clear;
  rlmComplChave2.Lines.Clear;
  rlmComplValor2.Lines.Clear;




{$IFDEF PL_200}
  rlmComplChave1.Lines.Add(FCTe.InfCTeComp.Chave);
  rlmComplValor1.Lines.Add(CTeUtil.FormatarValor(msk10x2, FCTe.vPrest.vTPrest));
{$ELSE}
  for i := 0 to (FCTe.InfCTeComp.Count - 1) do
  begin
    case i of
      0..4:
      begin
        rlmComplChave1.Lines.Add(FCTe.InfCTeComp[i].Chave);
        rlmComplValor1.Lines.Add(CTeUtil.FormatarValor(msk10x2, FCTe.InfCTeComp[i].vPresComp.vTPrest));
      end;
      5..9:
      begin
        rlmComplChave2.Lines.Add(FCTe.InfCTeComp[i].Chave);
        rlmComplValor2.Lines.Add(CTeUtil.FormatarValor(msk10x2, FCTe.InfCTeComp[i].vPresComp.vTPrest));
      end;
    end;
  end;
{$ENDIF}
end;

procedure TfrmDACTeRLRetrato.rlb_06_ValorPrestacaoBeforePrint(Sender: TrlCustomBand; var PrintBand: boolean);
begin
  inherited;
  PrintBand := RLCTe.PageNumber = 1;
end;

procedure TfrmDACTeRLRetrato.rlb_07_HeaderItensBeforePrint(Sender: TrlCustomBand; var PrintBand: boolean);
var
  i : Integer;
begin
  inherited;

  // Imprime os Documentos Origin�rios se o Tipo de CTe for Normal
  rlb_07_HeaderItens.Enabled := (FCTe.Ide.tpCTe = tcNormal) or (FCTe.Ide.tpCTe = tcComplemento) or
    (FCTe.Ide.tpCTe = tcSubstituto);

  rlDocOrig_tpDoc1.Lines.Clear;
  rlDocOrig_tpDoc2.Lines.Clear;
  rlDocOrig_cpf1.Lines.Clear;
  rlDocOrig_cpf2.Lines.Clear;
  rlDocOrig_serie1.Lines.Clear;
  rlDocOrig_serie2.Lines.Clear;

  cdsDocumentos.First;
  while not cdsDocumentos.Eof do
  begin
    if cdsDocumentos.FieldByName('TIPO_1').AsString <> '' then
    begin
      rlDocOrig_tpDoc1.Lines.Add(cdsDocumentos.FieldByName('TIPO_1').AsString);
      rlDocOrig_cpf1.Lines.Add(cdsDocumentos.FieldByName('CNPJCPF_1').AsString);
      rlDocOrig_serie1.Lines.Add(cdsDocumentos.FieldByName('DOCUMENTO_1').AsString);
    end;
    if cdsDocumentos.FieldByName('TIPO_2').AsString <> '' then
    begin
      rlDocOrig_tpDoc2.Lines.Add(cdsDocumentos.FieldByName('TIPO_2').AsString);
      rlDocOrig_cpf2.Lines.Add(cdsDocumentos.FieldByName('CNPJCPF_2').AsString);
      rlDocOrig_serie2.Lines.Add(cdsDocumentos.FieldByName('DOCUMENTO_2').AsString);
    end;
    cdsDocumentos.Next;
  end;
end;

procedure TfrmDACTeRLRetrato.rlb_09_ObsBeforePrint(Sender: TrlCustomBand; var PrintBand: boolean);
begin
  inherited;
  PrintBand := RLCTe.PageNumber = 1;

  rlmObs.Lines.BeginUpdate;
  rlmObs.Lines.Clear;
  //rlmObs.Lines.Text := FCTe.Compl.xObs;
  //rlmObs.Lines.Add(FCTe.Compl.xObs);

  rlmObs.Lines.Add(StringReplace(FCTe.Compl.xObs, '&lt;BR&gt;', #13#10, [rfReplaceAll, rfIgnoreCase]));
  //  for i := 0 to FCTe.Compl.ObsCont.Count-1 do
  //   with FCTe.Compl.ObsCont.Items[i] do
  //    begin
  //     rlmObs.Lines.Add( StringReplace( xCampo, '&lt;BR&gt;', #13#10, [rfReplaceAll,rfIgnoreCase] )+': '+
  //                       StringReplace( xTexto, '&lt;BR&gt;', #13#10, [rfReplaceAll,rfIgnoreCase] ) );
  //    end;
  //  if FCTe.Compl.ObsFisco.Count>0
  //   then rlmObs.Lines.Add('INFORMA��ES ADICIONAIS DE INTERESSE DO FISCO:');
  //  for i := 0 to FCTe.Compl.ObsFisco.Count-1 do
  //   with FCTe.Compl.ObsFisco.Items[i] do
  //    begin
  //     rlmObs.Lines.Add( StringReplace( xCampo, '&lt;BR&gt;', #13#10, [rfReplaceAll,rfIgnoreCase] )+': '+
  //                       StringReplace( xTexto, '&lt;BR&gt;', #13#10, [rfReplaceAll,rfIgnoreCase] ) );
  //    end;

  if FCTe.Ide.tpEmis in [teContingencia, teFSDA, teDPEC] then
  begin
    if not (FCTe.procCTe.cStat in [100, 101, 110]) then
      rlmObs.Lines.Add('DACTE em Conting�ncia - Impresso em decorr�ncia de problemas t�cnicos.');
  end;

  if (FCTe.Ide.tpEmis = teDPEC) and (FEPECEnviado) then
    rlmObs.Lines.Add('EPEC regularmente recebida pela Receita Federal do Brasil');

  rlmObs.Lines.Text := StringReplace(rlmObs.Lines.Text, ';', #13, [rfReplaceAll]);
  rlmObs.Lines.EndUpdate;

  // Mensagem para modo Homologacao.
  rllMsgTeste.Visible := False;
  rllMsgTeste.Enabled := False;

  if FCTe.Ide.tpAmb = taHomologacao then
  begin
    rllMsgTeste.Caption := 'AMBIENTE DE HOMOLOGA��O - SEM VALOR FISCAL';
    rllMsgTeste.Visible := True;
    rllMsgTeste.Enabled := True;
  end
  else
  begin
    if FCTe.procCTe.cStat > 0 then
    begin
      if (FCTe.procCTe.cStat = 101) or (FCTeCancelada) then
      begin
        rllMsgTeste.Caption := 'CT-e CANCELADO';
        rllMsgTeste.Visible := True;
        rllMsgTeste.Enabled := True;
      end;

      if FCTe.procCTe.cStat = 110 then
      begin
        rllMsgTeste.Caption := 'CT-e DENEGADO';
        rllMsgTeste.Visible := True;
        rllMsgTeste.Enabled := True;
      end;

      if not FCTe.procCTe.cStat in [101, 110, 100] then
      begin
        rllMsgTeste.Caption := FCTe.procCTe.xMotivo;
        rllMsgTeste.Visible := True;
        rllMsgTeste.Enabled := True;
      end;
    end
    else
    begin
      rllMsgTeste.Caption := 'CT-E N�O ENVIADO PARA SEFAZ';
      rllMsgTeste.Visible := True;
      rllMsgTeste.Enabled := True;
    end;
  end;

  rllMsgTeste.Repaint;

  //  rllMsgTeste.Enabled := FCTe.Ide.tpAmb = taHomologacao;
end;

procedure TfrmDACTeRLRetrato.rlb_10_ModRodFracionadoBeforePrint(Sender: TrlCustomBand; var PrintBand: boolean);
begin
  inherited;
  PrintBand := RLCTe.PageNumber = 1;

  // Imprime as Informa��es Especificas do Modal se o Tipo de CTe for Normal
  rlb_10_ModRodFracionado.Enabled := (FCTe.Ide.tpCTe = tcNormal) and (FCTe.Ide.modal = mdRodoviario);
  rlb_11_ModRodLot103.Enabled := False;
  rlb_11_ModRodLot104.Enabled := False;

{$IFDEF PL_200}
  with FCTe.infCTeNorm.rodo do
{$ELSE}
  with FCTe.Rodo do
{$ENDIF}
  begin
    rllRntrcEmpresa.Caption := RNTRC;

{$IFDEF PL_103}
    rlsCIOT.Enabled := False;
    lblCIOT.Enabled := False;
    rllCIOT.Enabled := False;
{$ELSE}
    rlsCIOT.Enabled := True;
    lblCIOT.Enabled := True;
    rllCIOT.Enabled := True;
    rllCIOT.Caption := CIOT;
{$ENDIF}

    case Lota of
      ltNao:
      begin
        rllTituloLotacao.Caption := 'DADOS ESPEC�FICOS DO MODAL RODOVI�RIO - CARGA FRACIONADA';
        rllLotacao.Caption := 'N�O';
      end;
      ltsim:
      begin
        rllTituloLotacao.Caption := 'DADOS ESPEC�FICOS DO MODAL RODOVI�RIO - LOTA��O';
        rllLotacao.Caption := 'SIM';
        if Versao = 103 then
          rlb_11_ModRodLot103.Enabled := True
        else
          rlb_11_ModRodLot104.Enabled := True;
      end;
    end;

    rllDtPrevEntrega.Caption := FormatDateTime('DD/MM/YYYY', dPrev);
  end;
end;

procedure TfrmDACTeRLRetrato.rlb_11_ModRodLot103BeforePrint(Sender: TrlCustomBand; var PrintBand: boolean);
var
  i: integer;
begin
  inherited;
  PrintBand := RLCTe.PageNumber = 1;

{$IFDEF PL_103}
  rllNumRegEsp.Caption := FCTe.Rodo.valePed.nroRE;
  case FCTe.Rodo.valePed.respPg of
   rpEmitente:       rllResponsavel.Caption := 'EMITENTE';
   rpRemetente:      rllResponsavel.Caption := 'REMETENTE';
   rpExpedidor:      rllResponsavel.Caption := 'EXPEDIDOR';
   rpRecebedor:      rllResponsavel.Caption := 'RECEBEDOR';
   rpDestinatario:   rllResponsavel.Caption := 'DESTINAT�RIO';
   rpTomadorServico: rllResponsavel.Caption := 'TOMADOR DO SERVI�O';
  end;
  rllValorTotal.Caption := CTeUtil.FormatarValor(msk13x2, FCTe.Rodo.valePed.vTValePed);
{$ENDIF}

  rlmTipo.Lines.Clear;
  rlmPlaca.Lines.Clear;
  rlmUF.Lines.Clear;
  rlmRNTRC.Lines.Clear;

  rlmEmpresas.Lines.Clear;
  rlmVigencias.Lines.Clear;
  rlmNumDispositivo.Lines.Clear;
  rlmCodTransacao.Lines.Clear;

  rllNomeMotorista.Caption := '';
  rllCPFMotorista.Caption := '';
  rllLacres.Caption := '';

{$IFDEF PL_200}
  for i:= 0 to (FCTe.infCTeNorm.Rodo.veic.Count - 1) do
  begin
   // TpcteTipoVeiculo = (tvTracao, tvReboque);
   if FCTe.infCTeNorm.Rodo.veic.Items[i].tpVeic = tvTracao
    then rlmTipo.Lines.Add('Tra��o')
    else rlmTipo.Lines.Add('Reboque');
   rlmPlaca.Lines.Add(FCTe.infCTeNorm.Rodo.veic.Items[i].placa);
   rlmUF.Lines.Add(FCTe.infCTeNorm.Rodo.veic.Items[i].UF);
   rlmRNTRC.Lines.Add(FCTe.infCTeNorm.Rodo.veic.Items[i].Prop.RNTRC);
  end;

  if FCTe.infCTeNorm.Rodo.moto.Count>0
   then begin
    rllNomeMotorista.Caption := FCTe.infCTeNorm.Rodo.moto.Items[0].xNome;
    rllCPFMotorista.Caption  := DFeUtil.FormatarCPF(FCTe.infCTeNorm.Rodo.moto.Items[0].CPF);
   end;

  for i := 0 to (FCTe.infCTeNorm.Rodo.lacRodo.Count - 1) do
  begin
   rllLacres.Caption := rllLacres.Caption + FCTe.infCTeNorm.Rodo.lacRodo.Items[i].nLacre + '/';
  end;
{$ELSE}
  for i := 0 to (FCTe.Rodo.veic.Count - 1) do
  begin
    // TpcteTipoVeiculo = (tvTracao, tvReboque);
    if FCTe.Rodo.veic.Items[i].tpVeic = tvTracao then
      rlmTipo.Lines.Add('Tra��o')
    else
      rlmTipo.Lines.Add('Reboque');
    rlmPlaca.Lines.Add(FCTe.Rodo.veic.Items[i].placa);
    rlmUF.Lines.Add(FCTe.Rodo.veic.Items[i].UF);
    rlmRNTRC.Lines.Add(FCTe.Rodo.veic.Items[i].Prop.RNTRC);
  end;

{$IFDEF PL_103}
  for i := 0 to (FCTe.Rodo.valePed.disp.Count - 1) do
  begin
   rlmEmpresas.Lines.Add(FCTe.Rodo.valePed.disp.Items[i].xEmp);
   rlmVigencias.Lines.Add(FormatDateTime('DD/MM/YYYY', FCTe.Rodo.valePed.disp.Items[i].dVig));
   rlmNumDispositivo.Lines.Add(FCTe.Rodo.valePed.disp.Items[i].nDisp);
   rlmCodTransacao.Lines.Add(FCTe.Rodo.valePed.disp.Items[i].nCompC);
  end;
{$ENDIF}

  if FCTe.Rodo.moto.Count > 0 then
  begin
    rllNomeMotorista.Caption := FCTe.Rodo.moto.Items[0].xNome;
    rllCPFMotorista.Caption := DFeUtil.FormatarCPF(FCTe.Rodo.moto.Items[0].CPF);
  end;

  for i := 0 to (FCTe.Rodo.Lacres.Count - 1) do
  begin
    rllLacres.Caption := rllLacres.Caption + FCTe.Rodo.Lacres.Items[i].nLacre + '/';
  end;
{$ENDIF}
end;

procedure TfrmDACTeRLRetrato.rlb_11_ModRodLot104BeforePrint(Sender: TrlCustomBand; var PrintBand: boolean);
var
  i: integer;
begin
  inherited;

  PrintBand := RLCTe.PageNumber = 1;

  rlmTipo2.Lines.Clear;
  rlmPlaca2.Lines.Clear;
  rlmUF2.Lines.Clear;
  rlmRNTRC2.Lines.Clear;

  rlmCNPJForn.Lines.Clear;
  rlmNumCompra.Lines.Clear;
  rlmCNPJPg.Lines.Clear;

  rllNomeMotorista2.Caption := '';
  rllCPFMotorista2.Caption := '';
  rllLacres2.Caption := '';

{$IFDEF PL_200}
  for i:= 0 to (FCTe.infCTeNorm.Rodo.veic.Count - 1) do
  begin
   // TpcteTipoVeiculo = (tvTracao, tvReboque);
   if FCTe.infCTeNorm.Rodo.veic.Items[i].tpVeic = tvTracao
    then rlmTipo2.Lines.Add('Tra��o')
    else rlmTipo2.Lines.Add('Reboque');
   rlmPlaca2.Lines.Add(FCTe.infCTeNorm.Rodo.veic.Items[i].placa);
   rlmUF2.Lines.Add(FCTe.infCTeNorm.Rodo.veic.Items[i].UF);
   rlmRNTRC2.Lines.Add(FCTe.infCTeNorm.Rodo.veic.Items[i].Prop.RNTRC);
  end;

  for i := 0 to (FCTe.infCTeNorm.Rodo.valePed.Count -1) do
  begin
   rlmCNPJForn.Lines.Add(DFeUtil.FormatarCNPJ(FCTe.infCTeNorm.Rodo.valePed.Items[i].CNPJForn));
   rlmNumCompra.Lines.Add(FCTe.infCTeNorm.Rodo.valePed.Items[i].nCompra);
   rlmCNPJPg.Lines.Add(DFeUtil.FormatarCNPJ(FCTe.infCTeNorm.Rodo.valePed.Items[i].CNPJPg));
  end;

  if FCTe.infCTeNorm.Rodo.moto.Count>0
   then begin
    rllNomeMotorista2.Caption := FCTe.infCTeNorm.Rodo.moto.Items[0].xNome;
    rllCPFMotorista2.Caption  := DFeUtil.FormatarCPF(FCTe.infCTeNorm.Rodo.moto.Items[0].CPF);
   end;

  for i := 0 to (FCTe.infCTeNorm.Rodo.lacRodo.Count - 1) do
  begin
   rllLacres2.Caption := rllLacres2.Caption + FCTe.infCTeNorm.Rodo.lacRodo.Items[i].nLacre + '/';
  end;
{$ELSE}
  for i := 0 to (FCTe.Rodo.veic.Count - 1) do
  begin
    // TpcteTipoVeiculo = (tvTracao, tvReboque);
    if FCTe.Rodo.veic.Items[i].tpVeic = tvTracao then
      rlmTipo2.Lines.Add('Tra��o')
    else
      rlmTipo2.Lines.Add('Reboque');
    rlmPlaca2.Lines.Add(FCTe.Rodo.veic.Items[i].placa);
    rlmUF2.Lines.Add(FCTe.Rodo.veic.Items[i].UF);
    rlmRNTRC2.Lines.Add(FCTe.Rodo.veic.Items[i].Prop.RNTRC);
  end;

{$IFDEF PL_104}
  for i := 0 to (FCTe.Rodo.valePed.Count -1) do
  begin
   rlmCNPJForn.Lines.Add(DFeUtil.FormatarCNPJ(FCTe.Rodo.valePed.Items[i].CNPJForn));
   rlmNumCompra.Lines.Add(FCTe.Rodo.valePed.Items[i].nCompra);
   rlmCNPJPg.Lines.Add(DFeUtil.FormatarCNPJ(FCTe.Rodo.valePed.Items[i].CNPJPg));
  end;
{$ENDIF}

  if FCTe.Rodo.moto.Count > 0 then
  begin
    rllNomeMotorista2.Caption := FCTe.Rodo.moto.Items[0].xNome;
    rllCPFMotorista2.Caption := DFeUtil.FormatarCPF(FCTe.Rodo.moto.Items[0].CPF);
  end;

  for i := 0 to (FCTe.Rodo.Lacres.Count - 1) do
  begin
    rllLacres2.Caption := rllLacres2.Caption + FCTe.Rodo.Lacres.Items[i].nLacre + '/';
  end;
{$ENDIF}
end;

procedure TfrmDACTeRLRetrato.rlb_12_ModAereoBeforePrint(Sender: TrlCustomBand; var PrintBand: boolean);
begin
  inherited;
  PrintBand := RLCTe.PageNumber = 1;
  rlb_12_ModAereo.Enabled := (FCTe.Ide.tpCTe = tcNormal) and (FCTe.Ide.modal = mdAereo);

  rllCaracAdServico.Caption := FCTe.Compl.xCaracSer;
  rllCaracAdTransporte.Caption := FCTe.Compl.xCaracAd;

{$IFDEF PL_200}
  with FCTe.infCTeNorm.aereo do
{$ELSE}
  with FCTe.Aereo do
{$ENDIF}
  begin
    rllAWB.Caption := nOCA;
  {$IFDEF PL_103}
    rllTrecho.Caption        := tarifa.trecho;
    rllContaCorrente.Caption := cIATA; // ??? Conta Corrente ???
  {$ENDIF}
    rllTarifaCL.Caption := tarifa.CL;
    rllTarifaCodigo.Caption := tarifa.cTar;
    rllTarifaValor.Caption := FormatCurr('###,###,##0.00', tarifa.vTar);
  {$IFNDEF PL_103}
    rllContaCorrente.Caption := IdT; // ??? Conta Corrente ???
  {$ENDIF}
    rllMinuta.Caption := FormatFloat('0000000000', nMinu);

    rllLojaAgenteEmissor.Caption := xLAgEmi;
  end;

  if FCte.Ide.retira = rtSim then
    rllRetira.Caption := 'SIM'
  else
    rllRetira.Caption := 'N�O';
  rllDadosRetira.Caption := FCte.Ide.xdetretira;
end;

procedure TfrmDACTeRLRetrato.rlb_13_ModAquaviarioBeforePrint(Sender: TrlCustomBand; var PrintBand: boolean);
var
  i, j: integer;
begin
  inherited;
  PrintBand := RLCTe.PageNumber = 1;
  rlb_13_ModAquaviario.Enabled := (FCTe.Ide.tpCTe = tcNormal) and (FCTe.Ide.modal = mdAquaviario);

{$IFDEF PL_200}
  with FCTe.infCTeNorm.aquav do
{$ELSE}
  with FCTe.aquav do
{$ENDIF}
  begin
    rllBCAFRMM.Caption := FormatCurr('###,###,##0.00', vPrest);
    rllValorAFRMM.Caption := FormatCurr('###,###,##0.00', vAFRMM);

    rllPortoEmbarque.Caption := prtEmb;
    rllPortoDestino.Caption := prtDest;
    rllIndNavioRebocador.Caption := xNavio;

    case tpNav of
      tnInterior: rllTipoNav.Caption := 'INTERIOR';
      tnCabotagem: rllTipoNav.Caption := 'CABOTAGEM';
    end;

    case direc of
      drNorte: rllDirecao.Caption := 'NORTE';
      drLeste: rllDirecao.Caption := 'LESTE';
      drSul: rllDirecao.Caption := 'SUL';
      drOeste: rllDirecao.Caption := 'OESTE';
    end;

    // Incluido por Fabio
    rllIndBalsas.Caption := '';
  {$IFNDEF PL_103}
    for i := 0 to (balsa.Count - 1) do
    begin
      if i = 0 then
        rllIndBalsas.Caption := balsa.Items[i].xBalsa
      else
        rllIndBalsas.Caption := rllIndBalsas.Caption + '/' + balsa.Items[i].xBalsa;
    end;
  {$ENDIF}

  {$IFNDEF PL_200}
    rllIndConteiners.Caption := '';
    for i := 0 to (detCont.Count - 1) do
    begin
      for j := 0 to (detCont.Items[i].Lacre.Count - 1) do
      begin
        if i > 0 then
          rllIndConteiners.Caption := rllIndConteiners.Caption + '  ';
        if j = 0 then
          rllIndConteiners.Caption := rllIndConteiners.Caption + detCont.Items[i].nCont + '-' +
            detCont.Items[i].Lacre.Items[j].nLacre
        else
          rllIndConteiners.Caption := rllIndConteiners.Caption + '/' + detCont.Items[i].Lacre.Items[j].nLacre;
      end;
    end;
  {$ENDIF}
  end;

end;

procedure TfrmDACTeRLRetrato.rlb_14_ModFerroviarioBeforePrint(Sender: TrlCustomBand; var PrintBand: boolean);
begin
  inherited;
  PrintBand := RLCTe.PageNumber = 1;
  rlb_14_ModFerroviario.Enabled := (FCTe.Ide.tpCTe = tcNormal) and (FCTe.Ide.modal = mdFerroviario);

end;

procedure TfrmDACTeRLRetrato.rlb_15_ModDutoviarioBeforePrint(Sender: TrlCustomBand; var PrintBand: boolean);
begin
  inherited;
  PrintBand := RLCTe.PageNumber = 1;
  rlb_15_ModDutoviario.Enabled := (FCTe.Ide.tpCTe = tcNormal) and (FCTe.Ide.modal = mdDutoviario);

end;

procedure TfrmDACTeRLRetrato.rlb_16_DadosExcEmitenteBeforePrint(Sender: TrlCustomBand; var PrintBand: boolean);
var
  i: integer;
begin
  inherited;
  PrintBand := RLCTe.PageNumber = 1;

  rlmObsExcEmitente.Lines.BeginUpdate;
  rlmObsExcEmitente.Lines.Clear;
  rlmObsFisco.Lines.Clear;
  (*
  if FCTe.Ide.modal = mdAereo
   then begin
    rlmObsExcEmitente.Lines.Add( 'O transporte coberto por este conhecimento se rege pelo c�digo brasileiro de aeron�utica. '+
                  'O expedidor/remetente aceita como corretas todas as especifica��es impressas neste conhecimento,' );
    rlmObsExcEmitente.Lines.Add( 'certificando que os artigos perigosos descritos pela regulamenta��o da ICAO foram devidamente '+
                  'informados e acondicionados para transporte a�reo.' );
   end;
*)
  if FCTe.Ide.modal <> mdAereo then
  begin
    for i := 0 to (FCTe.Compl.ObsCont.Count - 1) do
      with FCTe.Compl.ObsCont.Items[i] do
      begin
        rlmObsExcEmitente.Lines.Add(StringReplace(xCampo, '&lt;BR&gt;', #13#10, [rfReplaceAll, rfIgnoreCase]) + ': ' +
          StringReplace(xTexto, '&lt;BR&gt;', #13#10, [rfReplaceAll, rfIgnoreCase]));
      end;
  end;

  rlmObsExcEmitente.Lines.Text := StringReplace(rlmObsExcEmitente.Lines.Text, ';', #13, [rfReplaceAll]);
  rlmObsExcEmitente.Lines.EndUpdate;

  // Incluido por Italo em 17/09/2012
  rlmObsFisco.Lines.Add(StringReplace(FCTe.Imp.infAdFisco, '&lt;BR&gt;', #13#10, [rfReplaceAll, rfIgnoreCase]));

  for i := 0 to (FCTe.Compl.ObsFisco.Count - 1) do
    with FCTe.Compl.ObsFisco.Items[i] do
    begin
      rlmObsFisco.Lines.Add(StringReplace(xCampo, '&lt;BR&gt;', #13#10, [rfReplaceAll, rfIgnoreCase]) + ': ' +
        StringReplace(xTexto, '&lt;BR&gt;', #13#10, [rfReplaceAll, rfIgnoreCase]));
    end;

  rlmObsFisco.Lines.Text := StringReplace(rlmObsFisco.Lines.Text, ';', #13, [rfReplaceAll]);
  rlmObsFisco.Lines.EndUpdate;
end;

procedure TfrmDACTeRLRetrato.rlb_17_SistemaBeforePrint(Sender: TrlCustomBand; var PrintBand: boolean);
begin
  inherited;
  PrintBand := RLCTe.PageNumber = 1;

  rlLabel15.Visible := FImprimeHoraSaida;
  RLSystemInfo2.Visible := FImprimeHoraSaida;
  
  if (FSistema <> '') or (FUsuario <> '') then
    rllblSistema.Caption := FSistema + ' - ' + FUsuario
  else
    rllblSistema.Caption := '';
end;

procedure TfrmDACTeRLRetrato.rlb_18_ReciboBeforePrint(Sender: TrlCustomBand; var PrintBand: boolean);
begin
  inherited;
  PrintBand := (RLCTe.PageNumber = 1);

  if (FResumoCanhoto) then
    rllResumoCanhotoCTe2.Caption := getTextoResumoCanhoto
  else
    rllResumoCanhotoCTe2.Caption := '';

  rllSerie3.Caption := IntToStr(FCTe.Ide.serie); // FormatFloat( '000', FCTe.Ide.serie);
  rllNumCte3.Caption := FormatFloat('000,000,000', FCTe.Ide.nCT);

  // TpcteTipoCTe = (tcNormal, tcComplemento, tcAnulacao, tcSubstituto);
  if PrintBand then
  begin
    rlb_18_Recibo.Enabled := ((FCTe.Ide.tpCTe = tcNormal) or (FCTe.Ide.tpCTe = tcComplemento)) and
      (FCTe.Ide.modal <> mdAereo) and (FPosRecibo = prRodape);
    if rlb_18_Recibo.Enabled then
      rlb_18_Recibo.Height := 97
    else
      rlb_18_Recibo.Height := 0;
  end;
end;

procedure TfrmDACTeRLRetrato.rlb_06_ProdutosPerigososBeforePrint(Sender: TRLCustomBand; var PrintBand: boolean);
var
  i: integer;
begin
  inherited;

{$IFDEF PL_200}
  rlb_06_ProdutosPerigosos.Enabled := (FCTe.infCTeNorm.peri.Count > 0);
{$ELSE}
  rlb_06_ProdutosPerigosos.Enabled := (FCTe.peri.Count > 0);
{$ENDIF}

  PrintBand := (RLCTe.PageNumber = 1);
  if not rlb_06_ProdutosPerigosos.Enabled then
    rlb_06_ProdutosPerigosos.Height := 0;

  rlmNumONU.Lines.Clear;
  rlmNomeApropriado.Lines.Clear;
  rlmClasse.Lines.Clear;
  rlmGrupoEmbalagem.Lines.Clear;
  rlmQtdeProduto.Lines.Clear;

{$IFDEF PL_200}
  for i := 0 to (FCTe.infCTeNorm.peri.Count-1) do
   begin
     rlmNumONU.Lines.Add(FCTe.infCTeNorm.peri.Items[i].nONU);
     rlmNomeApropriado.Lines.Add(FCTe.infCTeNorm.peri.Items[i].xNomeAE);
     rlmClasse.Lines.Add(FCTe.infCTeNorm.peri.Items[i].xClaRisco);
     rlmGrupoEmbalagem.Lines.Add(FCTe.infCTeNorm.peri.Items[i].grEmb);
     rlmQtdeProduto.Lines.Add(FCTe.infCTeNorm.peri.Items[i].qTotProd);
   end;
{$ELSE}
  for i := 0 to (FCTe.peri.Count - 1) do
  begin
    rlmNumONU.Lines.Add(FCTe.peri.Items[i].nONU);
    rlmNomeApropriado.Lines.Add(FCTe.peri.Items[i].xNomeAE);
    rlmClasse.Lines.Add(FCTe.peri.Items[i].xClaRisco);
    rlmGrupoEmbalagem.Lines.Add(FCTe.peri.Items[i].grEmb);
    rlmQtdeProduto.Lines.Add(FCTe.peri.Items[i].qTotProd);
  end;
{$ENDIF}

end;

procedure TfrmDACTeRLRetrato.RLCTeBeforePrint(Sender: TObject; var PrintIt: boolean);
begin
{$IFDEF PL_103}
  Versao := 103;
{$ENDIF}
{$IFDEF PL_104}
  Versao := 104;
{$ENDIF}
{$IFDEF PL_200}
  Versao := 200;
{$ENDIF}

  Itens;

{$IFDEF PL_200}
  if FCTe.infCTeNorm.peri.Count = 0
   then rlb_06_ProdutosPerigosos.Visible := False;
{$ELSE}
  if FCTe.peri.Count = 0 then
    rlb_06_ProdutosPerigosos.Visible := False;
{$ENDIF}

  rlb_10_ModRodFracionado.Height := 0;
  rlb_11_ModRodLot103.Height     := 0;
  rlb_11_ModRodLot104.Height     := 0;
  rlb_12_ModAereo.Height         := 0;
  rlb_13_ModAquaviario.Height    := 0;
  rlb_14_ModFerroviario.Height   := 0;
  rlb_15_ModDutoviario.Height    := 0;

  case FCTe.Ide.modal of
    mdRodoviario:
    begin
                 {$IFDEF PL_200}
                   if FCTe.infCTeNorm.rodo.lota = ltNao
                    then begin
                     rlb_10_ModRodFracionado.Height := 44;
                    end
                    else begin
                     rlb_10_ModRodFracionado.Height := 44;
                     rlb_11_ModRodLot104.Height     := 107;
                    end;
                 {$ELSE}
      if FCTe.Rodo.Lota = ltNao then
      begin
        rlb_10_ModRodFracionado.Height := 44;
      end
      else
      begin
        rlb_10_ModRodFracionado.Height := 44;
        if Versao = 103 then
          rlb_11_ModRodLot103.Height := 108
        else
          rlb_11_ModRodLot104.Height := 107;
      end;
                 {$ENDIF}
    end;
    mdAereo:
    begin
      rlb_12_ModAereo.Height := 97;
    end;
    mdAquaviario:
    begin
      rlb_13_ModAquaviario.Height := 92;
    end;
    mdFerroviario:
    begin
      rlb_14_ModFerroviario.Height := 0;
    end;
    mdDutoviario:
    begin
      rlb_15_ModDutoviario.Height := 0;
    end;
  end;

  RLCTe.Title := 'CT-e: ' + FormatFloat('000,000,000', FCTe.Ide.nCT);

  //RLCTe.Margins.TopMargin := FMargemSuperior * 100;
  //RLCTe.Margins.BottomMargin := FMargemInferior * 100;
  //RLCTe.Margins.LeftMargin := FMargemEsquerda * 100;
  //RLCTe.Margins.RightMargin := FMargemDireita * 100;
end;

end.
