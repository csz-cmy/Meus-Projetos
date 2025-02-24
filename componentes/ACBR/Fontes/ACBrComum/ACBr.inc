{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2004 Daniel Simoes de Almeida               }
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
{ http://www.opensource.org/licenses/gpl-license.php                           }
{                                                                              }
{ Alexandre Rocha Lima e Marcondes -  arlm@users.sourceforge.net               }
{                                                                              }
{******************************************************************************}

{******************************************************************************
|* Historico
|*
|* 20/05/2004: Primeira Versao
|*    Alexandre Rocha Lima e Marcondes
|*    Cria�ao e Distribui�ao da Primeira Versao
|* 06/04/2005: Atualiza��o
|*    Alexandre Rocha Lima e Marcondes
|*    Suporte para o Kylix 1, 2 e 3; Delphi 8 e 9; identifica��o da VisualCLX
|* 15/08/2005: Adcionada compatibilidade de suporte a D5 e CLX
|*    Daniel Simoes de Almeida
|*    Se for CLX ou VisualCLX considera DELPHI6_UP com true
|* 21/08/2005: Adcionada compatibilidade com FreePascal e Lazarus
|*    Douglas Fernando Scheibler / Daniel Simoes de Almeida
|* 16/01/2006: Adcionada compatibilidade com o Delphi 2006
|*    Luciano Donato
|* 06/02/2007: Adcionada compatibilidade com o C++ Builder
|*    Thiago Delgado Pinto
|* 23/10/2012: Reformula��o do arquivo para utilizar o jedi.inc e kilyx.inc
|*    do projeto Jedi, visando uma melhor utiliza��o do arquivo
|*    R�gys Borges da Silveira
******************************************************************************}

// Para Usar os componentes de nota fiscal com openssl descomente as linhas abaixo
//--------------------------------------------------------------------------------
//{$DEFINE ACBrNFeOpenSSL}  
//{$DEFINE ACBrCTeOpenSSL}
//{$DEFINE ACBrNFSeOpenSSL}
//{$DEFINE ACBrMDFeOpenSSL}
//{$DEFINE ACBrGNREOpenSSL}

// Descomente a linha abaixo para usar o componente de comunica��o SOAP do Delphi ao inv�s do ACBrHTTPReqResp(Funciona apenas com a vers�o CAPICOM) - N�o � compat�vel com o Lazarus
//--------------------------------------------------------------------------------
//{$DEFINE SoapHTTP}

// Descomente as linhas abaixo para usar os recursos de Collate e/ou Bot�o Salvar do Preview do componente Danfe com Rave Reports
// Essas op��es funcionam dependendo da sua vers�o do Rave Reports. Verifique se sua vers�o suporta o recurso para n�o causar erro de compila��o
//--------------------------------------------------------------------------------
//{$DEFINE RaveCollate}
//{$DEFINE RaveSaveFromPreview}


// Ajusta FreePascal para o modo Delphi
//------------------------------------------------------------------------------
{$IFDEF FPC}
  {$DEFINE ACBrNFeOpenSSL} // Para usar Lazarus com Capcom deve ser cometando as linhas 65 e 191
  {$DEFINE ACBrCTeOpenSSL}
  {$DEFINE ACBrNFSeOpenSSL}
  {$DEFINE ACBrMDFeOpenSSL}
  {$DEFINE ACBrGNREOpenSSL}
  {$DEFINE VCL}
  {$DEFINE UNICODE} // Lazarus 0.9.26 usa UnicodeString como default para String
  {$DEFINE DELPHI7}
  {$DEFINE COMPILER7}
  {$H+}
{$ELSE}
  {$DEFINE BORLAND}
{$ENDIF}

// utilizar para facilitar a manuten��o do ACBr.inc, j� que ele era uma c�pia
// da jedi, essa mudan�a permite uma evolu��o melhor do arquivo.
//------------------------------------------------------------------------------
{$I ACBr_jedi.inc}

// Para usar CLX no Windows / Delphi descomente essa linha
//------------------------------------------------------------------------------
//{$DEFINE CLX}

// Para usar VCL no Windows / Delphi descomente essa linha
{$DEFINE VCL}

// Para usar FMX (Firemonkey) Windows / Delphi descomente essa linha
//{$DEFINE FMX}

{$IFDEF BORLAND}
  {$IFDEF LINUX}
    {$DEFINE ACBrNFeOpenSSL}
    {$DEFINE ACBrCTeOpenSSL}
    {$DEFINE ACBrNFSeOpenSSL}
    {$DEFINE ACBrMDFeOpenSSL}
	{$DEFINE ACBrGNREOpenSSL}
    {$DEFINE KYLIX}
  {$ENDIF LINUX}
{$ENDIF BORLAND}

// Defini��es multi-plataforma
//------------------------------------------------------------------------------
{$IFDEF WIN64}
  {$DEFINE MSWINDOWS}
{$ENDIF}

{$IFDEF DELPHILANGUAGE}
  {$IFDEF LINUX}
    {$IFNDEF FPC} // Suporte ao FreePascal 
      {$DEFINE VisualCLX}
    {$ENDIF}
  {$ENDIF}

  {$IFDEF CLX}
    {$DEFINE VisualCLX}
  {$ENDIF}

  {$IFDEF CONDITIONALEXPRESSIONS}
    {$IF Declared(QEventType_CMQuit) or Declared(Key_Word_Lower)}
        {$DEFINE VisualCLX}
    {$IFEND}
  {$ENDIF}

  {$IFNDEF VisualCLX}
    {$DEFINE VCL}
  {$ENDIF}

  {$IFDEF VisualCLX}
    {$UNDEF VCL}
    {$DEFINE COMPLIB_CLX} // kept for backward compatibility, use VisualCLX instead 
  {$ENDIF}

  {$IFDEF QUnit}
    {$UNDEF VCL}
    {$DEFINE VisualCLX}
  {$ENDIF}

  {$IFDEF VCL}
    {$DEFINE COMPLIB_VCL} // kept for backward compatibility, use VCL instead 
  {$ENDIF}

  {$IFDEF VisualCLX}
    {$DEFINE DELPHI6_UP} // Inserido para Suporte ao D5 e manter compatibilidade com a CLX 
  {$ENDIF}
{$ENDIF DELPHILANGUAGE}

//------------------------------------------------------------------------------
// Defini��es autom�ticas para tipos de licen�a:
//------------------------------------------------------------------------------
{$IFDEF D5Standard}
 {$DEFINE DelphiPersonalEdition}
{$ENDIF}

{$IFDEF D6PersonalEdition}
 {$DEFINE DelphiPersonalEdition}
{$ENDIF}

{$IFDEF D7PersonalEdition}
 {$DEFINE DelphiPersonalEdition}
{$ENDIF}

// Reduz warnings no D7:
//------------------------------------------------------------------------------
{$IFDEF COMPILER7_UP}
  {$IFNDEF FPC}
    {$WARN UNSAFE_TYPE OFF}
    {$WARN UNSAFE_CODE OFF}
    {$WARN UNSAFE_CAST OFF}
  {$ENDIF}
{$ENDIF}

// Delphi 6 ou inferior tem suporte apenas por OpenSSL  
//------------------------------------------------------------------------------
{$IFNDEF COMPILER7_UP}
  {$DEFINE ACBrNFeOpenSSL}
  {$DEFINE ACBrCTeOpenSSL}
  {$DEFINE ACBrNFSeOpenSSL}
  {$DEFINE ACBrMDFeOpenSSL}
  {$DEFINE ACBrGNREOpenSSL}
{$ENDIF}

{$IFDEF ACBrNFeOpenSSL}
  {$DEFINE ACBrCTeOpenSSL}
  {$DEFINE ACBrMDFeOpenSSL}
{$ENDIF}

{$IFDEF ACBrCTeOpenSSL}
  {$DEFINE ACBrNFeOpenSSL}// Para usar Lazarus com Capcom deve ser cometando as linhas 65 e 191
{$ENDIF}

// Defini��es para o Quick Report
// Descomente a linha abaixo caso o Quick Report tenha suporte a PDF
//------------------------------------------------------------------------------
{$DEFINE QReport_PDF}

// Defini��es para o compomente ACBrCTe
// Define o Pacote de Libera��o / Descomente o pacote a ser utilizado 
// Aten��o: descomente apenas uma das defini��es
//------------------------------------------------------------------------------
//{$DEFINE PL_103}
//{$DEFINE PL_104}
{$DEFINE PL_200}

// Verificando se a compila��o deve sem em modo texto "NOGUI"
// Nota: FPC no Linux sempre liga a diretiva "CONSOLE", por isso criamos a NOGUI
{$IFDEF FRAMEWORK}
  {$DEFINE NOGUI}
{$ENDIF}

{$IFDEF FPC}
  {$IFDEF LCL}
    {$UNDEF NOGUI}
  {$ENDIF}
{$ELSE}
  {$IFDEF CONSOLE}
    {$DEFINE NOGUI}
  {$ENDIF}
{$ENDIF}

{$IFDEF NOGUI}
  {$DEFINE CONSOLE}
{$ENDIF}

