{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2009   Isaque Pinheiro                      }
{                                                                              }
{ Colaboradores nesse arquivo:                                                 }
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

{$I ACBr.inc}

unit ACBrPAF_S_Class;

interface

uses SysUtils, Classes, DateUtils, ACBrTXTClass, ACBrPAFRegistros,
     ACBrPAF_S;

type
  TPAF_S = class(TACBrTXTClass)
  private
    FRegistroS2: TRegistroS2List;

    function WriteRegistroS3(RegS2: TRegistroS2): String;
    procedure CriaRegistros;
    procedure LiberaRegistros;
  public
    constructor Create;
    destructor Destroy; override; 
    procedure LimpaRegistros;

    function WriteRegistroS2: String;

    property RegistroS2: TRegistroS2List read FRegistroS2 write FRegistroS2;
  end;  

implementation

uses ACBrSpedUtils;

{ TPAF_S }
constructor TPAF_S.Create;
begin
  CriaRegistros;
end;

procedure TPAF_S.CriaRegistros;
begin
  FRegistroS2 := TRegistroS2List.Create;
end;

destructor TPAF_S.Destroy;
begin
  LiberaRegistros;
  inherited;
end;

procedure TPAF_S.LiberaRegistros;
begin
  FRegistroS2.Free;
end;

procedure TPAF_S.LimpaRegistros;
begin
  //Limpa os Registros
  LiberaRegistros;
  //Recriar os Registros Limpos
  CriaRegistros;
end;

function OrdenarS2(const ARegistro1, ARegistro2: Pointer): Integer;
var
  Reg1, Reg2: String;
begin
  Reg1 :=
    FormatDateTime('yyyymmddhhmmss', TRegistroS2(ARegistro1).DT_ABER);

  Reg2 :=
    FormatDateTime('yyyymmddhhmmss', TRegistroS2(ARegistro2).DT_ABER);

  Result := AnsiCompareText(Reg1, Reg2);
end;

function TPAF_S.WriteRegistroS2: String;
var
  intFor: integer;
  strRegistroS2: string;
  strRegistroS3: string;
begin
  strRegistroS2:= '';
  strRegistroS3:= '';

  if Assigned(FRegistroS2) then
    begin
      RegistroS2.Sort(@Ordenars2);

      for intFor := 0 to FRegistroS2.Count - 1 do
      begin
        with FRegistroS2.Items[intFor] do
        begin
          strRegistroS2 := strRegistroS2 + LFill('S2') +
                                           LFill(CNPJ, 14) +
                                           LFill(DT_ABER, 'yyyymmddhhmmss') +
                                           //RFill(SITU, 1) +
                                           RFill(NUM_MESA, 13, ifThen(RegistroValido, ' ', '?')) +
                                           LFill(VL_TOT, 13, 2) +
                                           RFill(COO_CM, 9) +
                                           RFill(NUM_FAB_CM, 20) +
                                           //RFill(COO, 9) +
                                           //RFill(NUM_FAB, 20) +
                                           sLineBreak;
        end;

        strRegistroS3 := strRegistroS3 + WriteRegistroS3( FRegistroS2.Items[intFor] );
      end;

      Result := strRegistroS2 + strRegistroS3;
    end;

end;

function TPAF_S.WriteRegistroS3(RegS2: TRegistroS2): String;
var
  intFor: integer;
  strRegistroS3: String;
begin
  strRegistroS3 := '';
  if Assigned(RegS2.RegistroS3) then
  begin
    for intFor := 0 to RegS2.RegistroS3.Count - 1 do
    begin
      with RegS2.RegistroS3.Items[intFor] do
      begin
        strRegistroS3 := strRegistroS3 + LFill('S3') +
                                         LFill(RegS2.CNPJ, 14) +
                                         LFill(RegS2.DT_ABER, 'yyyymmddhhmmss') +
                                         RFill(NUM_MESA, 13, ifThen(RegistroValido, ' ', '?')) +
                                         RFill(COD_ITEM, 14) +
                                         RFill(DESC_ITEM, 100) +
                                         LFill(QTDE_ITEM, 7, QTDE_DECIMAL) +
                                         RFill(UNI_ITEM, 3) +
                                         LFill(VL_UNIT, 8, VL_DECIMAL) +
                                         LFill(QTDE_DECIMAL, 1) +
                                         LFill(VL_DECIMAL, 1) +
                                         sLineBreak;
      end;
    end;  

    Result:= strRegistroS3;
  end;

end;

end.
 