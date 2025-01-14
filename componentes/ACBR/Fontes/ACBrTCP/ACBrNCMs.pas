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
 |* http://www.projetoacbr.com.br/forum/index.php?/topic/17549-criar-componente-de-consulta-a-ncm-online/#entry109857
 ******************************************************************************}

{$I ACBr.inc}
unit ACBrNCMs;

interface

uses
  Classes, SysUtils, contnrs, ACBrSocket, ACBrUtil;

type
  EACBrNcmException = class(Exception);

  TACBrNCM = class
  private
    fCodigoNcm: string;
    fDescricaoNcm: string;

  public
    property CodigoNcm: string read fCodigoNcm write fCodigoNcm;
    property DescricaoNcm: string read fDescricaoNcm write fDescricaoNcm;
  end;

  { TACBrNCMsList }

  TACBrNCMsList = class(TObjectList)
  protected
    procedure SetObject(Index: integer; Item: TACBrNCM);
    function GetObject(Index: integer): TACBrNCM;
  public
    function Add(Obj: TACBrNCM): integer;
    function New: TACBrNCM;
    property Objects[Index: integer]: TACBrNCM read GetObject write SetObject; default;
    procedure SaveToFile(AFileName: String);
  end;

  TACBrNCMs = class(TACBrHTTP)
  private
    fNcms: TACBrNCMsList;
    fUrlConsulta: string;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ListarNcms(codigoCapitulo: string = '');
    function Validar(const CodigoNcm: string): boolean;
    function DescricaoNcm(const CodigoNcm: string): string;
    property NCMS: TACBrNCMsList read fNcms write fNcms;
  published
    property UrlConsulta: string read fUrlConsulta write fUrlConsulta;
  end;

implementation

constructor TACBrNCMs.Create(AOwner: TComponent);
begin
  inherited;
  fNcms := TACBrNCMsList.Create;
  fNcms.Clear;
  fUrlConsulta :=
    'http://www4.receita.fazenda.gov.br/simulador/PesquisarNCM.jsp?';
end;

procedure TACBrNCMsList.SetObject(Index: integer; Item: TACBrNCM);
begin
  inherited SetItem(Index, Item);
end;

function TACBrNCMsList.GetObject(Index: integer): TACBrNCM;
begin
  Result := inherited GetItem(Index) as TACBrNCM;
end;

function TACBrNCMsList.New: TACBrNCM;
begin
  Result := TACBrNCM.Create;
  Add(Result);
end;

procedure TACBrNCMsList.SaveToFile(AFileName: String);
Var
  SL : TStringList;
  I: Integer;
begin
  SL := TStringList.Create;
  try
    for I := 0 to Count - 1 do
      SL.Add( Objects[i].CodigoNcm + ';' + Objects[i].DescricaoNcm );

    SL.SaveToFile(AFileName);
  finally
    SL.Free;
  end;
end;

function TACBrNCMsList.Add(Obj: TACBrNCM): integer;
begin
  Result := inherited Add(Obj);
end;

destructor TACBrNCMs.Destroy;
begin
  fNcms.Free;
  inherited Destroy;
end;

procedure TACBrNCMs.ListarNcms(codigoCapitulo: string = '');
var
  Buffer, Texto: string;
  SL1: TStringList;
  i, Cont: integer;

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

  procedure CarregaResultado;
  var
    Texto: string;
    i: integer;
  begin
    Buffer := Self.RespHTTP.Text;
    Buffer := StringReplace(Buffer, '&lt;', '<', [rfReplaceAll]);
    Buffer := StringReplace(Buffer, '&gt;', '>' + sLineBreak, [rfReplaceAll]);

    try
      SL1 := TStringList.Create;
      SL1.Text := Buffer;
      for i := 0 to SL1.Count - 1 do
      begin
        Texto := CopyDeAte(SL1[i], 'codNCM.value=', '</a>');
        if Trim(Texto) <> '' then
        begin
          with Ncms.New do
          begin
            CodigoNcm := Trim(Copy(Texto, 13, 8));
            DescricaoNcm := Trim(Copy(Texto, 24, Length(Texto)));
          end;
        end;
      end;
    finally
      SL1.Free;
    end;
  end;

begin
  if Trim(codigoCapitulo) <> '' then
  begin
    try
      Self.HTTPGet(fUrlConsulta + 'codigo=' + Copy(codigoCapitulo, 1, 2) +
        '&codigoCapitulo=' + Copy(codigoCapitulo, 1, 2) +
        '&codigoPosicao=&button=Exibir+NCMs');
    except
      on E: Exception do
      begin
        raise EACBrNcmException.Create('Erro ao consultar Ncm' + #13#10 + E.Message);
      end;
    end;

    CarregaResultado;
  end
  else
  begin
    Cont := 0;
    while Cont < 98 do
    begin
      Inc(Cont);
      try
        Self.HTTPGet(fUrlConsulta + 'codigo=' + FormatFloat('00', Cont) +
          '&codigoCapitulo=' + FormatFloat('00', Cont) +
          '&codigoPosicao=&button=Exibir+NCMs');
      except
        on E: Exception do
        begin
          raise EACBrNcmException.Create('Erro ao consultar Ncm' + #13#10 + E.Message);
        end;
      end;
      CarregaResultado;
    end;
  end;
end;

function TACBrNCMs.validar(const CodigoNcm: string): boolean;
var
  i: integer;
begin
  Result := False;
  ListarNcms(Copy(CodigoNcm, 1, 2));
  for i := 0 to Ncms.Count - 1 do
    if Ncms[i].CodigoNcm = CodigoNcm then
    begin
      Result := True;
      Break;
    end;
end;

function TACBrNCMs.descricaoNcm(const CodigoNcm: string): string;
var
  i: integer;
begin
  Result := '';
  ListarNcms(Copy(CodigoNcm, 1, 2));
  for i := 0 to Ncms.Count - 1 do
    if Ncms[i].CodigoNcm = CodigoNcm then
    begin
      Result := Ncms[i].DescricaoNcm;
      Break;
    end;
end;

end.
