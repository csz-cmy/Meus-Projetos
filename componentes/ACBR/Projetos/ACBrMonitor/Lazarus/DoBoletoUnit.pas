{******************************************************************************}
{ Projeto: ACBr Monitor                                                        }
{  Executavel multiplataforma que faz uso do conjunto de componentes ACBr para }
{ criar uma interface de comunicação com equipamentos de automacao comercial.  }
{                                                                              }
{ Direitos Autorais Reservados (c) 2010 Daniel Simões de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Juliana Rodrigues Prado Tamizou                 }
{                              Jean Patrick F. dos Santos (envio de e-mails)   }
{                                                                              }
{  Você pode obter a última versão desse arquivo na página do Projeto ACBr     }
{ Componentes localizado em      http://www.sourceforge.net/projects/acbr      }
{                                                                              }
{  Este programa é software livre; você pode redistribuí-lo e/ou modificá-lo   }
{ sob os termos da Licença Pública Geral GNU, conforme publicada pela Free     }
{ Software Foundation; tanto a versão 2 da Licença como (a seu critério)       }
{ qualquer versão mais nova.                                                   }
{                                                                              }
{  Este programa é distribuído na expectativa de ser útil, mas SEM NENHUMA     }
{ GARANTIA; nem mesmo a garantia implícita de COMERCIALIZAÇÃO OU DE ADEQUAÇÃO A}
{ QUALQUER PROPÓSITO EM PARTICULAR. Consulte a Licença Pública Geral GNU para  }
{ obter mais detalhes. (Arquivo LICENCA.TXT ou LICENSE.TXT)                    }
{                                                                              }
{  Você deve ter recebido uma cópia da Licença Pública Geral GNU junto com este}
{ programa; se não, escreva para a Free Software Foundation, Inc., 59 Temple   }
{ Place, Suite 330, Boston, MA 02111-1307, USA. Você também pode obter uma     }
{ copia da licença em:  http://www.opensource.org/licenses/gpl-license.php     }
{                                                                              }
{ Daniel Simões de Almeida  -  daniel@djsystem.com.br  -  www.djsystem.com.br  }
{       Rua Coronel Aureliano de Camargo, 973 - Tatuí - SP - 18270-170         }
{                                                                              }
{******************************************************************************}

{$mode objfpc}{$H+}

unit DoBoletoUnit;

interface

uses
  Classes, SysUtils, CmdUnit, IniFiles;

procedure DoBoleto(Cmd: TACBrCmd);
procedure LerIniBoletos(aStr: AnsiString);
procedure IncluirTitulo(aIni: TMemIniFile; Sessao: String);
procedure GravarIniRetorno(DirIniRetorno: String);
function EnviarBoletosPorEmail(aAnexo: String; aEmail: String) : String;
function ListaBancos() : String;

implementation

uses ACBrBoleto, ACBrUtil, ACBrMonitor1, DoACBrUnit, strutils, typinfo,
  DoEmailUnit ;

procedure DoBoleto ( Cmd: TACBrCmd ) ;
var
  EnvioResposta: String;
begin
   with FrmACBrMonitor.ACBrBoleto1 do
   begin
      if Cmd.Metodo = 'configurardados' then
         LerIniBoletos(Cmd.Params(0))

      else if cmd.Metodo = 'limparlista' then
         ListadeBoletos.Clear

      else if cmd.Metodo = 'totaltituloslista' then
         Cmd.Resposta:= IntToStr(ListadeBoletos.Count)

      else if cmd.Metodo = 'imprimir' then
       begin
         if Cmd.Params(0) <> '' then
            ACBrMonitor1.FrmACBrMonitor.ACBrBoletoFCFortes1.PrinterName := Cmd.Params(0);

         Imprimir
       end

      else if cmd.Metodo = 'gerarpdf' then
         GerarPDF

      else if cmd.Metodo = 'gerarhtml' then
         GerarHTML

      else if cmd.Metodo = 'gerarremessa' then
       begin
         DirArqRemessa := Cmd.Params(0);
         NomeArqRemessa:= Cmd.Params(2);
         GerarRemessa( StrToIntDef(cmd.Params(1),1))
       end

      else if cmd.Metodo = 'lerretorno' then
       begin
         DirArqRetorno  := Cmd.Params(0);
         NomeArqRetorno := cmd.Params(1);
         LerRetorno();
         GravarIniRetorno(DirArqRetorno);
       end

      else if cmd.Metodo = 'enviaremail' then
       begin
         GerarPDF;
         EnvioResposta := EnviarBoletosPorEmail(FrmACBrMonitor.ACBrBoleto1.ACBrBoletoFC.NomeArquivo,
                                                ListadeBoletos[0].Sacado.Email);
         if ( EnvioResposta = 'OK' ) then
            Cmd.Resposta := 'E-mail enviado com sucesso!'
         else
            raise Exception.Create(EnvioResposta);
       end

      else if cmd.Metodo = 'incluirtitulos' then
       begin
        LerIniBoletos(Cmd.Params(0));
        if Cmd.Params(1) = 'I' then
          Imprimir
        else if Cmd.Params(1)= 'P' then
          GerarPDF
        else if Cmd.Params(1)= 'E' then
         begin
           GerarPDF;
           EnvioResposta := EnviarBoletosPorEmail(FrmACBrMonitor.ACBrBoleto1.ACBrBoletoFC.NomeArquivo,
                                                  ListadeBoletos[0].Sacado.Email);
           if ( EnvioResposta = 'OK' ) then
              Cmd.Resposta := 'E-mail enviado com sucesso!'
           else
              raise Exception.Create(EnvioResposta);
         end;
       end
      else if cmd.Metodo = 'listabancos' then
       begin
         Cmd.Resposta := ListaBancos();
       end
      else if cmd.Metodo = 'tamnossonumero' then
         Cmd.Resposta := IntToStr(Banco.CalcularTamMaximoNossoNumero(Cmd.Params(0)))
      else if cmd.Metodo = 'codigosmoraaceitos' then
         Cmd.Resposta := Banco.CodigosMoraAceitos
      else
         raise Exception.Create(ACBrStr('Comando inválido ('+Cmd.Comando+')'));
   end;

end;

procedure LerIniBoletos( aStr: AnsiString ) ;
var
   IniBoletos: TMemIniFile;
   SL: TStringList;
   ContTitulos: Integer;
   NomeSessao: String;
   MudouDados: boolean;
   NumeroBanco: LongInt;
   IndiceACBr: LongInt;
begin
  MudouDados := False;
  IniBoletos := TMemIniFile.Create('boletos.ini');
  SL         := TStringList.Create;
  try
     if (pos(#10,aStr) = 0) and FileExists(aStr) then
        SL.LoadFromFile(aStr)
     else
       SL.Text := ConvertStrRecived(aStr);

     IniBoletos.SetStrings(SL);

     with FrmACBrMonitor.ACBrBoleto1 do
     begin
        if IniBoletos.SectionExists('Cedente') then
        begin
           MudouDados := True;
           with Cedente do
           begin
              FrmACBrMonitor.cbxBOLF_J.ItemIndex := IniBoletos.ReadInteger('CEDENTE','TipoPessoa',2);
              try
                 TipoInscricao := TACBrPessoa( FrmACBrMonitor.cbxBOLF_J.ItemIndex ) ;
              except
                 TipoInscricao := pJuridica ;
              end ;

              Nome          := IniBoletos.ReadString('CEDENTE','Nome',Nome);
              CNPJCPF       := IniBoletos.ReadString('CEDENTE','CNPJCPF',CNPJCPF);
              Logradouro    := IniBoletos.ReadString('CEDENTE','Logradouro',Logradouro);
              NumeroRes     := IniBoletos.ReadString('CEDENTE','Numero',NumeroRes);
              Bairro        := IniBoletos.ReadString('CEDENTE','Bairro','');
              Cidade        := IniBoletos.ReadString('CEDENTE','Cidade','');
              CEP           := IniBoletos.ReadString('CEDENTE','CEP','');
              Complemento   := IniBoletos.ReadString('CEDENTE','Complemento','');
              UF            := IniBoletos.ReadString('CEDENTE','UF','');
              CodigoCedente := IniBoletos.ReadString('CEDENTE','CodigoCedente','');
              Modalidade    := IniBoletos.ReadString('CEDENTE','MODALIDADE','');
              CodigoTransmissao:= IniBoletos.ReadString('CEDENTE','CODTRANSMISSAO','');
              Convenio      := IniBoletos.ReadString('CEDENTE','CONVENIO','');

              FrmACBrMonitor.edtCodTransmissao.Text := CodigoTransmissao;
              FrmACBrMonitor.edtModalidade.Text     := Modalidade;
              FrmACBrMonitor.edtConvenio.Text       := Convenio;

              FrmACBrMonitor.cbxBOLEmissao.ItemIndex := IniBoletos.ReadInteger('CEDENTE','RespEmis',0);
              try
                 ResponEmissao := TACBrResponEmissao( FrmACBrMonitor.cbxBOLEmissao.ItemIndex ) ;
              except
                 ResponEmissao := tbCliEmite ;
              end ;

              CaracTitulo := TACBrCaracTitulo(IniBoletos.ReadInteger('CEDENTE','CaracTitulo',0));


              with FrmACBrMonitor do
              begin
                 cbxBOLLayout.ItemIndex := IniBoletos.ReadInteger('CEDENTE','LAYOUTBOL',0);
                 try
                   ACBrBoletoFCFortes1.LayOut:= TACBrBolLayOut(cbxBOLLayout.ItemIndex);
                 except
                   ACBrBoletoFCFortes1.LayOut:= lPadrao;
                 end;
              end;
           end;

           with FrmACBrMonitor do
           begin
              edtBOLRazaoSocial.Text  := Cedente.Nome;
              edtBOLCNPJ.Text         := Cedente.CNPJCPF;
              edtBOLLogradouro.Text   := Cedente.Logradouro;
              edtBOLNumero.Text       := Cedente.NumeroRes;
              edtBOLBairro.Text       := Cedente.Bairro;
              edtBOLCidade.Text       := Cedente.Cidade;
              edtBOLComplemento.Text  := Cedente.Complemento;
              cbxBOLUF.Text           := Cedente.UF;
              edtBOLCEP.Text          := Cedente.CEP;
           end;
        end;

        if IniBoletos.SectionExists('Banco') then
        begin
           MudouDados := True;

           NumeroBanco := IniBoletos.ReadInteger('BANCO','Numero',0);
           IndiceACBr  := IniBoletos.ReadInteger('BANCO','IndiceACBr',0);

           if IndiceACBr > 0 then
              Banco.TipoCobranca:= TACBrTipoCobranca(IndiceACBr)
           else if NumeroBanco > 0 then
           begin
              case NumeroBanco of
                001: Banco.TipoCobranca:= cobBancoDoBrasil;
                008,033,353: Banco.TipoCobranca:= cobSantander;
                021: Banco.TipoCobranca:= cobBanestes;
                041: Banco.TipoCobranca:= cobBanrisul;
                104: Banco.TipoCobranca:= cobCaixaEconomica;
                237: Banco.TipoCobranca:= cobBradesco;
                341: Banco.TipoCobranca:= cobItau;
                389: Banco.TipoCobranca:= cobBancoMercantil;
                748: Banco.TipoCobranca:= cobSicred;
                756: Banco.TipoCobranca:= cobBancoob;
                399: Banco.TipoCobranca:= cobHSBC;
              end;
           end;

           if (trim(Banco.Nome) = 'Não definido') then
              raise exception.Create('Banco não definido ou não '+
                                     'implementado no ACBrBoleto!');

           FrmACBrMonitor.cbxBOLBanco.ItemIndex :=  Integer(Banco.TipoCobranca);
           FrmACBrMonitor.cbxCNAB.ItemIndex := IniBoletos.ReadInteger('BANCO','CNAB',0);
           if FrmACBrMonitor.cbxCNAB.ItemIndex = 0 then
              LayoutRemessa := c240
           else
              LayoutRemessa := c400;
        end;

        if IniBoletos.SectionExists('Conta') then
        begin
           MudouDados := True;
           with Cedente do
           begin
             Conta         := IniBoletos.ReadString('CONTA','Conta','');
             ContaDigito   := IniBoletos.ReadString('CONTA','DigitoConta','');
             Agencia       := IniBoletos.ReadString('CONTA','Agencia','');
             AgenciaDigito := IniBoletos.ReadString('CONTA','DigitoAgencia','');
           end;

           with FrmACBrMonitor do
           begin
              edtBOLConta.Text         := Cedente.Conta;
              edtBOLDigitoConta.Text   := Cedente.ContaDigito;
              edtBOLAgencia.Text       := Cedente.Agencia;
              edtBOLDigitoAgencia.Text := Cedente.AgenciaDigito;
              edtCodCliente.Text       := Cedente.CodigoCedente;
           end;
        end;


        if MudouDados then
           FrmACBrMonitor.SalvarConfBoletos;

        if IniBoletos.SectionExists('Titulo') then
           IncluirTitulo(IniBoletos,'Titulo');

        ContTitulos := 1;
        NomeSessao  := 'Titulo1' ;
        while IniBoletos.SectionExists(NomeSessao)do
        begin
           IncluirTitulo( IniBoletos, NomeSessao );
           Inc( ContTitulos );
           NomeSessao := 'Titulo'+IntToStr( ContTitulos );
        end;
     end;
  finally
     SL.Free;
     IniBoletos.Free;
  end ;
end;

procedure IncluirTitulo( aIni: TMemIniFile; Sessao: String ) ;
var
   Titulo : TACBrTitulo;
   MemFormatada : String;
   LocalPagto: String;
begin
   with FrmACBrMonitor.ACBrBoleto1 do
   begin
      if (trim(Banco.Nome) = 'Não definido') then
              raise exception.Create('Banco não definido ou não '+
                                     'implementado no ACBrBoleto!');
      Titulo := CriarTituloNaLista;

      MemFormatada := aIni.ReadString(Sessao,'Mensagem','') ;
      MemFormatada := StringReplace( MemFormatada,'|',sLineBreak, [rfReplaceAll] );

      with Titulo do
      begin
         if aIni.ReadInteger(Sessao,'Aceite',1) = 0 then
            Aceite := atSim
         else
            Aceite := atNao;

         try
            Sacado.Pessoa := TACBrPessoa( aIni.ReadInteger(Sessao,'Sacado.Pessoa',2) );
         except
            Sacado.Pessoa := pOutras;
         end ;

         try
            OcorrenciaOriginal.Tipo := TACBrTipoOcorrencia(
               aini.ReadInteger(Sessao,'OcorrenciaOriginal.TipoOcorrencia',0) ) ;
         except
            OcorrenciaOriginal.Tipo := toRemessaRegistrar ;
         end ;

         try
           TipoDiasProtesto := TACBrTipoDiasIntrucao(aIni.ReadInteger(Sessao,'TipoDiasProtesto',0));
         except
           TipoDiasProtesto := diCorridos;
         end;

         try
           TipoImpressao := TACBrTipoImpressao(aIni.ReadInteger(Sessao,'TipoImpressao',1));
         except
           TipoImpressao := tipNormal;
         end;


         LocalPagto := aIni.ReadString(Sessao,'LocalPagamento','');

         Vencimento          := StrToDateDef(Trim(aIni.ReadString(Sessao,'Vencimento','')), now);
         DataDocumento       := StrToDateDef(Trim(aIni.ReadString(Sessao,'DataDocumento','')),now);
         DataProcessamento   := StrToDateDef(Trim(aIni.ReadString(Sessao,'DataProcessamento','')),now);
         DataAbatimento      := StrToDateDef(Trim(aIni.ReadString(Sessao,'DataAbatimento','')),0);
         DataDesconto        := StrToDateDef(Trim(aIni.ReadString(Sessao,'DataDesconto','')),0);
         DataMoraJuros       := StrToDateDef(Trim(aIni.ReadString(Sessao,'DataMoraJuros','')),0);
         DataProtesto        := StrToDateDef(Trim(aIni.ReadString(Sessao,'DataProtesto','')),0);
         LocalPagamento      := IfThen(Trim(LocalPagto) <> '',LocalPagto,LocalPagamento);
         NumeroDocumento     := aIni.ReadString(Sessao,'NumeroDocumento',NumeroDocumento);
         EspecieDoc          := aIni.ReadString(Sessao,'Especie',EspecieDoc);
         Carteira            := trim(aIni.ReadString(Sessao,'Carteira',''));
         NossoNumero         := aIni.ReadString(Sessao,'NossoNumero','');
         ValorDocumento      := aIni.ReadFloat(Sessao,'ValorDocumento',ValorDocumento);
         Sacado.NomeSacado   := aIni.ReadString(Sessao,'Sacado.NomeSacado','');
         Sacado.CNPJCPF      := OnlyNumber(aIni.ReadString(Sessao,'Sacado.CNPJCPF',''));
         Sacado.Logradouro   := aIni.ReadString(Sessao,'Sacado.Logradouro','');
         Sacado.Numero       := aIni.ReadString(Sessao,'Sacado.Numero','');
         Sacado.Bairro       := aIni.ReadString(Sessao,'Sacado.Bairro','');
         Sacado.Complemento  := aIni.ReadString(Sessao,'Sacado.Complemento','');
         Sacado.Cidade       := aIni.ReadString(Sessao,'Sacado.Cidade','');
         Sacado.UF           := aIni.ReadString(Sessao,'Sacado.UF','');
         Sacado.CEP          := OnlyNumber(aIni.ReadString(Sessao,'Sacado.CEP',''));
         Sacado.Email        := aIni.ReadString(Sessao,'Sacado.Email',Sacado.Email);
         EspecieMod          := aIni.ReadString(Sessao,'EspecieMod',EspecieMod);
         Mensagem.Text       := MemFormatada;
         Instrucao1          := padL(aIni.ReadString(Sessao,'Instrucao1',Instrucao1),2);
         Instrucao2          := padL(aIni.ReadString(Sessao,'Instrucao2',Instrucao2),2);
         TotalParcelas       := aIni.ReadInteger(Sessao,'TotalParcelas',TotalParcelas);
         Parcela             := aIni.ReadInteger(Sessao,'Parcela',Parcela);
         ValorAbatimento     := aIni.ReadFloat(Sessao,'ValorAbatimento',ValorAbatimento);
         ValorDesconto       := aIni.ReadFloat(Sessao,'ValorDesconto',ValorDesconto);
         ValorMoraJuros      := aIni.ReadFloat(Sessao,'ValorMoraJuros',ValorMoraJuros);
         ValorIOF            := aIni.ReadFloat(Sessao,'ValorIOF',ValorIOF);
         ValorOutrasDespesas := aIni.ReadFloat(Sessao,'ValorOutrasDespesas',ValorOutrasDespesas);
         SeuNumero           := aIni.ReadString(Sessao,'SeuNumero',SeuNumero);
         PercentualMulta     := aIni.ReadFloat(Sessao,'PercentualMulta',PercentualMulta);
         CodigoMora          := aIni.ReadString(Sessao,'CodigoMora','1');
      end;
   end;
end;

procedure GravarIniRetorno(DirIniRetorno: String);
var
  IniRetorno: TIniFile;
  wSessao: String;
  I: Integer;
  J: Integer;
begin
  if Pos(PathDelim,DirIniRetorno) <> Length(DirIniRetorno) then
     DirIniRetorno:= DirIniRetorno + PathDelim;

  IniRetorno:= TMemIniFile.Create(DirIniRetorno + 'Retorno.ini');
  try
    with FrmACBrMonitor.ACBrBoleto1 do
    begin
       IniRetorno.WriteString('CEDENTE','Nome',Cedente.Nome);
       IniRetorno.WriteString('CEDENTE','CNPJCPF',Cedente.CNPJCPF);
       IniRetorno.WriteString('CEDENTE','CodigoCedente',Cedente. CodigoCedente);
       IniRetorno.WriteString('CEDENTE','MODALIDADE',Cedente.Modalidade);
       IniRetorno.WriteString('CEDENTE','CODTRANSMISSAO',Cedente.CodigoTransmissao);
       IniRetorno.WriteString('CEDENTE','CONVENIO',Cedente.Convenio);

       IniRetorno.WriteInteger('BANCO','Numero',Banco.Numero);
       IniRetorno.WriteInteger('BANCO','IndiceACBr',Integer(Banco.TipoCobranca));

       IniRetorno.WriteString('CONTA','Conta',Cedente.Conta);
       IniRetorno.WriteString('CONTA','DigitoConta',Cedente.ContaDigito);
       IniRetorno.WriteString('CONTA','Agencia',Cedente.Agencia);
       IniRetorno.WriteString('CONTA','DigitoAgencia',Cedente.AgenciaDigito);

       for I:= 0 to ListadeBoletos.Count - 1 do
       begin
         wSessao:= 'Titulo'+ IntToStr(I+1);
         IniRetorno.WriteString(wSessao,'Sacado.Nome', ListadeBoletos[I].Sacado.NomeSacado);
         IniRetorno.WriteString(wSessao,'Sacado.CNPJCPF', ListadeBoletos[I].Sacado.CNPJCPF);
         IniRetorno.WriteString(wSessao,'Vencimento',DateToStr(ListadeBoletos[I].Vencimento));
         IniRetorno.WriteString(wSessao,'DataDocumento',DateToStr(ListadeBoletos[I].DataDocumento));
         IniRetorno.WriteString(wSessao,'NumeroDocumento',ListadeBoletos[I].NumeroDocumento);
         IniRetorno.WriteString(wSessao,'DataProcessamento',DateToStr(ListadeBoletos[I].DataProcessamento));
         IniRetorno.WriteString(wSessao,'NossoNumero',ListadeBoletos[I].NossoNumero);
         IniRetorno.WriteString(wSessao,'Carteira',ListadeBoletos[I].Carteira);
         IniRetorno.WriteFloat(wSessao,'ValorDocumento',ListadeBoletos[I].ValorDocumento);
         IniRetorno.WriteString(wSessao,'DataOcorrencia',DateToStr(ListadeBoletos[I].DataOcorrencia));
         IniRetorno.WriteString(wSessao,'DataCredito',DateToStr(ListadeBoletos[I].DataCredito));
         IniRetorno.WriteString(wSessao,'DataBaixa',DateToStr(ListadeBoletos[I].DataBaixa));
         IniRetorno.WriteFloat(wSessao,'ValorDespesaCobranca',ListadeBoletos[I].ValorDespesaCobranca);
         IniRetorno.WriteFloat(wSessao,'ValorAbatimento',ListadeBoletos[I].ValorAbatimento);
         IniRetorno.WriteFloat(wSessao,'ValorDesconto',ListadeBoletos[I].ValorDesconto);
         IniRetorno.WriteFloat(wSessao,'ValorMoraJuros',ListadeBoletos[I].ValorMoraJuros);
         IniRetorno.WriteFloat(wSessao,'ValorIOF',ListadeBoletos[I].ValorIOF);
         IniRetorno.WriteFloat(wSessao,'ValorOutrasDespesas',ListadeBoletos[I].ValorOutrasDespesas);
         IniRetorno.WriteFloat(wSessao,'ValorOutrosCreditos',ListadeBoletos[I].ValorOutrosCreditos);
         IniRetorno.WriteFloat(wSessao,'ValorRecebido',ListadeBoletos[I].ValorRecebido);
         IniRetorno.WriteString(wSessao,'SeuNumero',ListadeBoletos[I].SeuNumero);
         IniRetorno.WriteString(wSessao,'CodTipoOcorrencia',
                                GetEnumName( TypeInfo(TACBrTipoOcorrencia),
                                             Integer(ListadeBoletos[I].OcorrenciaOriginal.Tipo)));
         IniRetorno.WriteString(wSessao,'DescricaoTipoOcorrencia',ListadeBoletos[I].OcorrenciaOriginal.Descricao);


         for J:= 0 to ListadeBoletos[I].DescricaoMotivoRejeicaoComando.Count-1 do
            IniRetorno.WriteString(wSessao,'MotivoRejeicao' + IntToStr(I+1),
                                   ListadeBoletos[I].DescricaoMotivoRejeicaoComando[J]);
       end;
    end;
  finally
    IniRetorno.Free;
  end;
end;

function EnviarBoletosPorEmail(aAnexo: String; aEmail: String): String;
begin
  with {$IFNDEF NOGUI}FrmACBrMonitor.ACBrMail1 {$ELSE}dm.ACBrMail1 {$ENDIF} do
  begin
    try
      ConfigurarEmailNovo;
      RecuperarDadosIniciais;
      Subject   := FrmACBrMonitor.edtBOLEmailAssunto.Text;
      Body.Text := FrmACBrMonitor.edtBOLEmailMensagem.Text;
      AddAddress(aEmail);
      AddAttachment(aAnexo);

      Send;
      Result := 'OK';
    except
      on E: Exception do
         Result := (e.Message);
    end;

    { Recupera dados iniciais }
    RecuperarDadosIniciais;
  end;
end;

function ListaBancos() : String;
var
   IBanco : TACBrTipoCobranca;
   SBanco : AnsiString;
begin
   IBanco := Low(TACBrTipoCobranca);
   Inc(IBanco); // Removendo item 0-Nenhum
   Result := '';

   while IBanco <= High(TACBrTipoCobranca) do
   begin
     sBanco := GetEnumName( TypeInfo(TACBrTipoCobranca), Integer(IBanco) );
     sBanco := copy(SBanco,4, Length(SBanco)); // Reovendo "cob" do nome do banco.
     Result := Result + sBanco + '|';

     Inc(IBanco);
   end;

   if Result <> '' then
      Result := copy(Result,1,Length(Result)-1) ;
end;

end.

