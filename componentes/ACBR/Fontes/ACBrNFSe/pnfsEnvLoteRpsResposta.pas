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

unit pnfsEnvLoteRpsResposta;

interface

uses
  SysUtils, Classes,
  pcnAuxiliar, pcnConversao, pcnLeitor, pnfsConversao, ACBrNFSeUtil;

type

 TMsgRetornoEnvCollection = class;
 TMsgRetornoEnvCollectionItem = class;

  TInfRec = class
  private
    FNumeroLote: String;
    FDataRecebimento: TDateTime;
    FProtocolo: String;
    FSucesso: String;
    FMsgRetorno: TMsgRetornoEnvCollection;

    procedure SetMsgRetorno(Value: TMsgRetornoEnvCollection);
  public
    constructor Create; reintroduce;
    destructor Destroy; override;

    property NumeroLote: String                   read FNumeroLote      write FNumeroLote;
    property DataRecebimento: TDateTime           read FDataRecebimento write FDataRecebimento;
    property Protocolo: String                    read FProtocolo       write FProtocolo;
    property Sucesso: String                      read FSucesso         write FSucesso;
    property MsgRetorno: TMsgRetornoEnvCollection read FMsgRetorno      write SetMsgRetorno;
  end;

 TMsgRetornoEnvCollection = class(TCollection)
  private
    function GetItem(Index: Integer): TMsgRetornoEnvCollectionItem;
    procedure SetItem(Index: Integer; Value: TMsgRetornoEnvCollectionItem);
  public
    constructor Create(AOwner: TInfRec);
    function Add: TMsgRetornoEnvCollectionItem;
    property Items[Index: Integer]: TMsgRetornoEnvCollectionItem read GetItem write SetItem; default;
  end;

 TMsgRetornoEnvCollectionItem = class(TCollectionItem)
  private
    FCodigo: String;
    FMensagem: String;
    FCorrecao: String;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
  published
    property Codigo: String   read FCodigo   write FCodigo;
    property Mensagem: String read FMensagem write FMensagem;
    property Correcao: String read FCorrecao write FCorrecao;
  end;

  TretEnvLote = class(TPersistent)
  private
    FLeitor: TLeitor;
    FInfRec: TInfRec;
  public
    constructor Create;
    destructor Destroy; override;

    function LerXml: Boolean;
    function LerXml_provedorIssDsf: Boolean;
    function LerXML_provedorEquiplano: Boolean;
	function LerXml_provedorNFSEBrasil: boolean;
	
  published
    property Leitor: TLeitor read FLeitor write FLeitor;
    property InfRec: TInfRec read FInfRec write FInfRec;
  end;

implementation

{ TInfRec }

constructor TInfRec.Create;
begin
  FMsgRetorno := TMsgRetornoEnvCollection.Create(Self);
end;

destructor TInfRec.Destroy;
begin
  FMsgRetorno.Free;

  inherited;
end;

procedure TInfRec.SetMsgRetorno(Value: TMsgRetornoEnvCollection);
begin
  FMsgRetorno.Assign(Value);
end;

{ TMsgRetornoEnvCollection }

function TMsgRetornoEnvCollection.Add: TMsgRetornoEnvCollectionItem;
begin
  Result := TMsgRetornoEnvCollectionItem(inherited Add);
  Result.create;
end;

constructor TMsgRetornoEnvCollection.Create(AOwner: TInfRec);
begin
  inherited Create(TMsgRetornoEnvCollectionItem);
end;

function TMsgRetornoEnvCollection.GetItem(
  Index: Integer): TMsgRetornoEnvCollectionItem;
begin
  Result := TMsgRetornoEnvCollectionItem(inherited GetItem(Index));
end;

procedure TMsgRetornoEnvCollection.SetItem(Index: Integer;
  Value: TMsgRetornoEnvCollectionItem);
begin
  inherited SetItem(Index, Value);
end;

{ TMsgRetornoEnvCollectionItem }

constructor TMsgRetornoEnvCollectionItem.Create;
begin

end;

destructor TMsgRetornoEnvCollectionItem.Destroy;
begin

  inherited;
end;

{ TretEnvLote }

constructor TretEnvLote.Create;
begin
  FLeitor := TLeitor.Create;
  FInfRec := TInfRec.Create
end;

destructor TretEnvLote.Destroy;
begin
  FLeitor.Free;
  FinfRec.Free;
  inherited;
end;

function TretEnvLote.LerXml: boolean;
var
  i: Integer;
  iNivel: Integer;
begin
  Result := True;

  try
    Leitor.Arquivo := NotaUtil.RetirarPrefixos(Leitor.Arquivo);
    Leitor.Grupo   := Leitor.Arquivo;

    infRec.FNumeroLote := Leitor.rCampo(tcStr, 'NumeroLote');
    infRec.FProtocolo  := Leitor.rCampo(tcStr, 'Protocolo');

    // Alguns provedores retornam apenas a data, sem o hor�rio
    if Length(Leitor.rCampo(tcStr, 'DataRecebimento')) > 10
     then infRec.FDataRecebimento := Leitor.rCampo(tcDatHor, 'DataRecebimento')
     else infRec.FDataRecebimento := Leitor.rCampo(tcDat, 'DataRecebimento');

    iNivel := 1;
    if leitor.rExtrai(2, 'ListaMensagemRetorno') <> ''
     then iNivel := 3
     else if leitor.rExtrai(1, 'ListaMensagemRetorno') <> ''
           then iNivel := 2;

    i := 0;
    while Leitor.rExtrai(iNivel, 'MensagemRetorno', '', i + 1) <> '' do
     begin
       InfRec.FMsgRetorno.Add;
       InfRec.FMsgRetorno[i].FCodigo   := Leitor.rCampo(tcStr, 'Codigo');
       InfRec.FMsgRetorno[i].FMensagem := Leitor.rCampo(tcStr, 'Mensagem');
       InfRec.FMsgRetorno[i].FCorrecao := Leitor.rCampo(tcStr, 'Correcao');

       inc(i);
     end;

    i := 0;
    while Leitor.rExtrai(iNivel, 'ErroWebServiceResposta', '', i + 1) <> '' do
     begin
       InfRec.FMsgRetorno.Add;
       InfRec.FMsgRetorno[i].FCodigo   := Leitor.rCampo(tcStr, 'CodigoErro');
       InfRec.FMsgRetorno[i].FMensagem := Leitor.rCampo(tcStr, 'MensagemErro');
       InfRec.FMsgRetorno[i].FCorrecao := '';

       inc(i);
     end;

    i := 0;
    while (Leitor.rExtrai(1, 'Fault', '', i + 1) <> '') do
     begin
       InfRec.FMsgRetorno.Add;
       InfRec.FMsgRetorno[i].FCodigo   := Leitor.rCampo(tcStr, 'faultcode');
       InfRec.FMsgRetorno[i].FMensagem := Leitor.rCampo(tcStr, 'faultstring');
       InfRec.FMsgRetorno[i].FCorrecao := '';

       inc(i);
     end;

           //        if i = 0 then
//          InfRec.FMsgRetorno.Add;
//      end;

  except
    Result := False;
  end;
end;

function TretEnvLote.LerXml_provedorIssDsf: boolean;
var
  i, posI, count: Integer;
  VersaoXML: String;
  strAux: AnsiString;
  leitorAux: TLeitor;
begin
  Result := False;

  try
    Leitor.Arquivo := NotaUtil.RetirarPrefixos(Leitor.Arquivo);
    VersaoXML      := '1';
    Leitor.Grupo   := Leitor.Arquivo;

    if leitor.rExtrai(1, 'RetornoEnvioLoteRPS') <> '' then
    begin
      if (leitor.rExtrai(2, 'Cabecalho') <> '') then
      begin
         FInfRec.FSucesso := Leitor.rCampo(tcStr, 'Sucesso');
         if (FInfRec.FSucesso = 'true') then
         begin
            FInfRec.FNumeroLote      := Leitor.rCampo(tcStr, 'NumeroLote');
            FInfRec.FProtocolo       := Leitor.rCampo(tcStr, 'NumeroLote');
            FinfRec.FDataRecebimento := Leitor.rCampo(tcDatHor, 'DataEnvioLote')
         end;
      end;

      i := 0;
      if (leitor.rExtrai(1, 'Alertas') <> '') then
      begin
         strAux := leitor.rExtrai(1, 'Alertas');
         if (strAux <> '') then
         begin
            posI := pos('<Alerta>', strAux);

            while ( posI > 0 ) do begin
               count := pos('</Alerta>', strAux) + 7;

               FInfRec.FMsgRetorno.Add;
               inc(i);

               LeitorAux := TLeitor.Create;
               leitorAux.Arquivo := copy(strAux, PosI, count);
               leitorAux.Grupo   := leitorAux.Arquivo;

               FInfRec.FMsgRetorno[i].FCodigo  := leitorAux.rCampo(tcStr, 'Codigo');
               FInfRec.FMsgRetorno[i].Mensagem := leitorAux.rCampo(tcStr, 'Descricao');

               LeitorAux.free;

               Delete(strAux, PosI, count);
               posI := pos('<Alerta>', strAux);
            end;
         end;
      end;

      if (leitor.rExtrai(1, 'Erros') <> '') then
      begin
         strAux := leitor.rExtrai(1, 'Erros');
         if (strAux <> '') then
         begin
            //i := 0 ;
            posI := pos('<Erro>', strAux);

            while (posI > 0) do begin
               count := pos('</Erro>', strAux) + 6;

               FInfRec.FMsgRetorno.Add;
               inc(i);

               LeitorAux := TLeitor.Create;
               leitorAux.Arquivo := copy(strAux, PosI, count);
               leitorAux.Grupo   := leitorAux.Arquivo;

               FInfRec.FMsgRetorno[i].FCodigo  := leitorAux.rCampo(tcStr, 'Codigo');
               FInfRec.FMsgRetorno[i].Mensagem := leitorAux.rCampo(tcStr, 'Descricao');

               LeitorAux.free;

               Delete(strAux, PosI, count);
               posI := pos('<Erro>', strAux);
            end;
         end;
      end;
      Result := True;
    end;
  except
    Result := False;
  end;
end;

function TretEnvLote.LerXML_provedorEquiplano: Boolean;
var
  i: Integer;
begin
  try
    Leitor.Arquivo := NotaUtil.RetirarPrefixos(Leitor.Arquivo);
    Leitor.Grupo   := Leitor.Arquivo;

    infRec.FNumeroLote      := Leitor.rCampo(tcStr, 'nrLote');
    infRec.FDataRecebimento := Leitor.rCampo(tcDatHor, 'dtRecebimento');
    infRec.FProtocolo       := Leitor.rCampo(tcStr, 'nrProtocolo');

    if leitor.rExtrai(1, 'mensagemRetorno') <> '' then
    begin
      i := 0;
      if (leitor.rExtrai(2, 'listaErros') <> '') then
      begin
        while Leitor.rExtrai(3, 'erro', '', i + 1) <> '' do
        begin
          InfRec.FMsgRetorno.Add;
          InfRec.FMsgRetorno[i].FCodigo  := Leitor.rCampo(tcStr, 'cdMensagem');
          InfRec.FMsgRetorno[i].FMensagem:= Leitor.rCampo(tcStr, 'dsMensagem');
          InfRec.FMsgRetorno[i].FCorrecao:= Leitor.rCampo(tcStr, 'dsCorrecao');

          inc(i);
        end;
      end;

      if (leitor.rExtrai(2, 'listaAlertas') <> '') then
      begin
        while Leitor.rExtrai(3, 'alerta', '', i + 1) <> '' do
        begin
          InfRec.FMsgRetorno.Add;
          InfRec.FMsgRetorno[i].FCodigo  := Leitor.rCampo(tcStr, 'cdMensagem');
          InfRec.FMsgRetorno[i].FMensagem:= Leitor.rCampo(tcStr, 'dsMensagem');
          InfRec.FMsgRetorno[i].FCorrecao:= Leitor.rCampo(tcStr, 'dsCorrecao');

          inc(i);
        end;
      end;
    end;

    Result := True;
  except
    Result := False;
  end;
end;


function TretEnvLote.LerXml_provedorNFSEBrasil: boolean;
var
  ok: boolean;
  i, Item, posI, count: Integer;
  VersaoXML: String;
  strAux,strAux2, strItem: AnsiString;
  leitorAux, leitorItem:TLeitor;
begin
  result := False;
   // Luiz Bai�o 2014.12.01
  (*
  try
    Leitor.Arquivo := NotaUtil.RetirarPrefixos(Leitor.Arquivo);
    VersaoXML      := '1';
    Leitor.Grupo   := Leitor.Arquivo;

    strAux := leitor.rExtrai_NFSEBrasil(1, 'RespostaLoteRps');

    if ( strAux <> emptystr) then  begin
           FInfRec.FSucesso := Leitor.rCampo(tcStr, 'Sucesso');
           if (FInfRec.FSucesso <> emptystr) then  begin
              FInfRec.FNumeroLote :=  Leitor.rCampo(tcStr, 'NumeroLote');
              FInfRec.Protocolo   :=  Leitor.rCampo(tcStr, 'Protocolo');
           end;

       infRec.FProtocolo := Leitor.rCampo(tcStr, 'Protocolo');
    end;

    strAux := leitor.rExtrai_NFSEBrasil(1, 'erros');
    if ( strAux <> emptystr) then begin

        posI := 1;
        i := 0 ;
        while ( posI > 0 ) do begin
             count := pos('</erro>', strAux) + 7;

             LeitorAux := TLeitor.Create;
             leitorAux.Arquivo := copy(strAux, PosI, count);
             leitorAux.Grupo   := leitorAux.Arquivo;
             strAux2 := leitorAux.rExtrai_NFSEBrasil(1,'erro');
             strAux2 := Leitor.rCampo(tcStr, 'erro');
             FInfRec.FMsgRetorno.Add;
             FInfRec.FMsgRetorno.Items[i].Mensagem := Leitor.rCampo(tcStr, 'erro')+#13;
             inc(i);
             LeitorAux.free;
             Delete(strAux, PosI, count);
             posI := pos('<erro>', strAux);
        end;
    end;

    strAux := leitor.rExtrai_NFSEBrasil(1, 'confirmacoes');
    if ( strAux <> emptystr) then begin

        posI := 1;
        // i := 0 ;
        while ( posI > 0 ) do begin

           count := pos('</confirmacao>', strAux) + 7;
           LeitorAux := TLeitor.Create;
           leitorAux.Arquivo := copy(strAux, PosI, count);
           leitorAux.Grupo   := leitorAux.Arquivo;
           strAux2 := leitorAux.rExtrai_NFSEBrasil(1,'confirmacao');
           strAux2 := Leitor.rCampo(tcStr, 'confirmacao');
           FInfRec.FMsgRetorno.Add;
           FInfRec.FMsgRetorno.Items[i].Mensagem := Leitor.rCampo(tcStr, 'confirmacao')+#13;
           inc(i);
           LeitorAux.free;
           Delete(strAux, PosI, count);
           posI := pos('<confirmacao>', strAux);
        end;
    end;

    Result := True;
  except
    result := False;
  end;
  *)
end;

end.

