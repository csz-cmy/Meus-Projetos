{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2009   Juliana Tamizou                      }
{                                                                              }
{ Colaboradores nesse arquivo: Isaque Pinheiro                                 }
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

{******************************************************************************
|* Historico
|*
|* 31/01/2013: Nilson Sergio
|*  - Cria��o e distribui��o da Primeira Versao
*******************************************************************************}

unit ACBrLFDBloco_J_Class;

interface

uses SysUtils, Classes, DateUtils, ACBrLFD3505, ACBrLFDBlocos, ACBrLFDBloco_J,
     ACBrTXTClass;

type

  /// BLOCO J: INFORMA��ES ECON�MICO-FISCAIS

  { TBloco_J }

  TBloco_J = class(TACBrLFD3505)
  private
    FRegistroJ001: TRegistroJ001;
    FRegistroJ990: TRegistroJ990;

    procedure CriaRegistros;
    procedure LiberaRegistros;
  public
    constructor Create;           /// Create
    destructor Destroy; override; /// Destroy
    procedure LimpaRegistros;

    procedure WriteRegistroJ001;
    procedure WriteRegistroJ990;

    property RegistroJ001: TRegistroJ001 read FRegistroJ001 write FRegistroJ001;
    property RegistroJ990: TRegistroJ990 read FRegistroJ990 write FRegistroJ990;
  end;

implementation

uses ACBrLFDUtils, StrUtils;

{ TBloco_J }

constructor TBloco_J.Create ;
begin
  inherited ;
  CriaRegistros;
end;

destructor TBloco_J.Destroy;
begin
  LiberaRegistros;
  inherited;
end;

procedure TBloco_J.CriaRegistros;
begin
  FRegistroJ001 := TRegistroJ001.Create;
  FRegistroJ990 := TRegistroJ990.Create;

  FRegistroJ990.QTD_LIN_J := 0;
end;

procedure TBloco_J.LiberaRegistros;
begin
  FRegistroJ001.Free;
  FRegistroJ990.Free;
end;

procedure TBloco_J.LimpaRegistros;
begin
  /// Limpa os Registros
  LiberaRegistros;
  Conteudo.Clear;

  /// Recriar os Registros Limpos
  CriaRegistros;
end;

procedure TBloco_J.WriteRegistroJ001;
begin
  if Assigned(FRegistroJ001) then
    with FRegistroJ001 do
    begin
      Add( LFill('J001') +
           LFill(Integer(IND_MOV), 0) );

      FRegistroJ990.QTD_LIN_J := FRegistroJ990.QTD_LIN_J + 1;
    end;
end;

procedure TBloco_J.WriteRegistroJ990;
begin
  if Assigned(FRegistroJ990) then
    with FRegistroJ990 do
    begin
      QTD_LIN_J := QTD_LIN_J + 1;

      Add( LFill('J990') +
           LFill(QTD_LIN_J, 0) );
    end;
end;

end.
