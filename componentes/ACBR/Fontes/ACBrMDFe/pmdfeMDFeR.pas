{******************************************************************************}
{ Projeto: Componente ACBrMDFe                                                 }
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

{*******************************************************************************
|* Historico
|*
|* 01/08/2012: Italo Jurisato Junior
|*  - Doa��o do componente para o Projeto ACBr
*******************************************************************************}

{$I ACBr.inc}

unit pmdfeMDFeR;

interface

uses
  SysUtils, Classes,
{$IFNDEF VER130}
  Variants,
{$ENDIF}
  pcnAuxiliar, pcnConversao, pcnLeitor,
  pmdfeConversao, pmdfeMDFe, ACBrUtil;

type

  TMDFeR = class(TPersistent)
  private
    FLeitor: TLeitor;
    FMDFe: TMDFe;
  public
    constructor Create(AOwner: TMDFe);
    destructor Destroy; override;
    function LerXml: Boolean;
  published
    property Leitor: TLeitor read FLeitor write FLeitor;
    property MDFe: TMDFe     read FMDFe   write FMDFe;
  end;

implementation

{ TMDFeR }

constructor TMDFeR.Create(AOwner: TMDFe);
begin
  FLeitor := TLeitor.Create;
  FMDFe := AOwner;
end;

destructor TMDFeR.Destroy;
begin
  FLeitor.Free;
  inherited Destroy;
end;

function TMDFeR.LerXml: Boolean;
var
  ok: Boolean;
  {i, j,} i01, i02, i03, i04, i05: Integer;
begin
  (*
  I := 0;
  I := RetornarPosEx('Id=', Leitor.Arquivo, I + 6);
  if I = 0 then
    raise Exception.Create('N�o encontrei inicio do URI: Id=');

  I := RetornarPosEx('"', Leitor.Arquivo, I + 2);
  if I = 0 then
    raise Exception.Create('N�o encontrei inicio do URI: aspas inicial');

  J := RetornarPosEx('"', Leitor.Arquivo, I + 1);
  if J = 0 then
    raise Exception.Create('N�o encontrei inicio do URI: aspas final');

  // MDFe.infMDFe.ID := copy(Leitor.Arquivo, I + 4, J - I - 4);
  MDFe.infMDFe.ID := copy(Leitor.Arquivo, I + 1, J - I -1);
  *)
  Leitor.Grupo := Leitor.Arquivo;

  MDFe.infMDFe.ID := OnlyNumber(Leitor.rAtributo('Id='));
  if MDFe.infMDFe.ID = '' then
    raise Exception.Create('N�o encontrei o atributo: Id');

  (* Grupo da TAG <ide> *******************************************************)
  if Leitor.rExtrai(1, 'ide') <> '' then
  begin
    MDFe.Ide.cUF         := Leitor.rCampo(tcInt, 'cUF');
    MDFe.Ide.tpAmb       := StrToTpAmb(ok, Leitor.rCampo(tcStr, 'tpAmb'));
    MDFe.Ide.tpEmit      := StrToTpEmitente(ok, Leitor.rCampo(tcStr, 'tpEmit'));
    MDFe.Ide.modelo      := Leitor.rCampo(tcStr, 'mod');
    MDFe.Ide.serie       := Leitor.rCampo(tcInt, 'serie');
    MDFe.Ide.nMDF        := Leitor.rCampo(tcInt, 'nMDF');
    MDFe.Ide.cMDF        := Leitor.rCampo(tcStr, 'cMDF');
    MDFe.Ide.cDV         := Leitor.rCampo(tcInt, 'cDV');
    MDFe.Ide.modal       := StrToModal(ok, Leitor.rCampo(tcStr, 'modal'));
    MDFe.Ide.dhEmi       := Leitor.rCampo(tcDatHor, 'dhEmi');
    MDFe.Ide.tpEmis      := StrToTpEmis(ok, Leitor.rCampo(tcStr, 'tpEmis'));
    MDFe.Ide.procEmi     := StrToprocEmi(ok, Leitor.rCampo(tcStr, 'procEmi'));
    MDFe.Ide.verProc     := Leitor.rCampo(tcStr, 'verProc');
    MDFe.Ide.UFIni       := Leitor.rCampo(tcStr, 'UFIni');
    MDFe.Ide.UFFim       := Leitor.rCampo(tcStr, 'UFFim');
    MDFe.Ide.dhIniViagem := Leitor.rCampo(tcDatHor, 'dhIniViagem');

    i01 := 0;
    while Leitor.rExtrai(2, 'infMunCarrega', '', i01 + 1) <> '' do
    begin
      MDFe.Ide.infMunCarrega.Add;
      MDFe.Ide.infMunCarrega[i01].cMunCarrega := Leitor.rCampo(tcInt, 'cMunCarrega');
      MDFe.Ide.infMunCarrega[i01].xMunCarrega := Leitor.rCampo(tcStr, 'xMunCarrega');
      inc(i01);
    end;

    i01 := 0;
    while Leitor.rExtrai(2, 'infPercurso', '', i01 + 1) <> '' do
    begin
      MDFe.Ide.infPercurso.Add;
      MDFe.Ide.infPercurso[i01].UFPer := Leitor.rCampo(tcStr, 'UFPer');
      inc(i01);
    end;

  end;

  (* Grupo da TAG <emit> ******************************************************)
  if Leitor.rExtrai(1, 'emit') <> '' then
  begin
    MDFe.emit.CNPJ  := Leitor.rCampo(tcStr, 'CNPJ');
    MDFe.emit.IE    := Leitor.rCampo(tcStr, 'IE');
    MDFe.emit.xNome := Leitor.rCampo(tcStr, 'xNome');
    MDFe.emit.xFant := Leitor.rCampo(tcStr, 'xFant');

    if Leitor.rExtrai(2, 'enderEmit') <> '' then
    begin
      MDFe.emit.enderemit.xLgr    := Leitor.rCampo(tcStr, 'xLgr');
      MDFe.emit.enderemit.Nro     := Leitor.rCampo(tcStr, 'nro');
      MDFe.emit.enderemit.xCpl    := Leitor.rCampo(tcStr, 'xCpl');
      MDFe.emit.enderemit.xBairro := Leitor.rCampo(tcStr, 'xBairro');
      MDFe.emit.enderemit.cMun    := Leitor.rCampo(tcInt, 'cMun');
      MDFe.emit.enderemit.xMun    := Leitor.rCampo(tcStr, 'xMun');
      MDFe.emit.enderemit.CEP     := Leitor.rCampo(tcInt, 'CEP');
      MDFe.emit.enderemit.UF      := Leitor.rCampo(tcStr, 'UF');
      MDFe.emit.enderemit.fone    := Leitor.rCampo(tcStr, 'fone');
      MDFe.emit.enderemit.email   := Leitor.rCampo(tcStr, 'email');
    end;
  end;

  (* Grupo da TAG <rodo> ******************************************************)
  if Leitor.rExtrai(1, 'infModal') <> '' then
  begin
    if Leitor.rExtrai(2, 'rodo') <> '' then
     begin
      MDFe.Rodo.RNTRC      := Leitor.rCampo(tcStr, 'RNTRC', 'prop');
      MDFe.Rodo.CIOT       := Leitor.rCampo(tcStr, 'CIOT');
      MDFe.Rodo.codAgPorto := Leitor.rCampo(tcStr, 'codAgPorto');

      if (Leitor.rExtrai(3, 'veicTracao') <> '') or (Leitor.rExtrai(3, 'veicPrincipal') <> '')then
       begin
        MDFe.Rodo.veicTracao.cInt    := Leitor.rCampo(tcStr, 'cInt');
        MDFe.Rodo.veicTracao.placa   := Leitor.rCampo(tcStr, 'placa');
        MDFe.Rodo.veicTracao.RENAVAM := Leitor.rCampo(tcStr, 'RENAVAM');
        MDFe.Rodo.veicTracao.tara    := Leitor.rCampo(tcInt, 'tara');
        MDFe.Rodo.veicTracao.capKG   := Leitor.rCampo(tcInt, 'capKG');
        MDFe.Rodo.veicTracao.capM3   := Leitor.rCampo(tcInt, 'capM3');
        MDFe.rodo.veicTracao.tpRod   := StrToTpRodado(ok, Leitor.rCampo(tcStr, 'tpRod'));
        MDFe.rodo.veicTracao.tpCar   := StrToTpCarroceria(ok, Leitor.rCampo(tcStr, 'tpCar'));
        MDFe.rodo.veicTracao.UF      := Leitor.rCampo(tcStr, 'UF');

        if Leitor.rExtrai(4, 'prop') <> '' then
        begin
          MDFe.rodo.veicTracao.prop.CNPJCPF := Leitor.rCampoCNPJCPF;
          MDFe.rodo.veicTracao.prop.RNTRC   := Leitor.rCampo(tcStr, 'RNTRC');
          MDFe.rodo.veicTracao.prop.xNome   := Leitor.rCampo(tcStr, 'xNome');
          MDFe.rodo.veicTracao.prop.IE      := Leitor.rCampo(tcStr, 'IE');
          MDFe.rodo.veicTracao.prop.UF      := Leitor.rCampo(tcStr, 'UF');
          MDFe.rodo.veicTracao.prop.tpProp  := StrToTpProp(ok, Leitor.rCampo(tcStr, 'tpProp'));
        end;

        i01 := 0;
        while Leitor.rExtrai(4, 'condutor', '', i01 + 1) <> '' do
        begin
          MDFe.rodo.veicTracao.condutor.Add;
          MDFe.rodo.veicTracao.condutor[i01].xNome := Leitor.rCampo(tcStr, 'xNome');
          MDFe.rodo.veicTracao.condutor[i01].CPF   := Leitor.rCampo(tcStr, 'CPF');
          inc(i01);
        end;
       end;

      i01 := 0;
      while Leitor.rExtrai(3, 'veicReboque', '', i01 + 1) <> '' do
      begin
        MDFe.rodo.veicReboque.Add;
        MDFe.rodo.veicReboque[i01].cInt    := Leitor.rCampo(tcStr, 'cInt');
        MDFe.Rodo.veicReboque[i01].placa   := Leitor.rCampo(tcStr, 'placa');
        MDFe.Rodo.veicReboque[i01].RENAVAM := Leitor.rCampo(tcStr, 'RENAVAM');
        MDFe.Rodo.veicReboque[i01].tara    := Leitor.rCampo(tcInt, 'tara');
        MDFe.Rodo.veicReboque[i01].capKG   := Leitor.rCampo(tcInt, 'capKG');
        MDFe.Rodo.veicReboque[i01].capM3   := Leitor.rCampo(tcInt, 'capM3');
        MDFe.rodo.veicReboque[i01].tpCar   := StrToTpCarroceria(ok, Leitor.rCampo(tcStr, 'tpCar'));
        MDFe.rodo.veicReboque[i01].UF      := Leitor.rCampo(tcStr, 'UF');

        if Leitor.rExtrai(4, 'prop') <> '' then
        begin
          MDFe.rodo.veicReboque[i01].prop.CNPJCPF := Leitor.rCampoCNPJCPF;
          MDFe.rodo.veicReboque[i01].prop.RNTRC   := Leitor.rCampo(tcStr, 'RNTRC');
          MDFe.rodo.veicReboque[i01].prop.xNome   := Leitor.rCampo(tcStr, 'xNome');
          MDFe.rodo.veicReboque[i01].prop.IE      := Leitor.rCampo(tcStr, 'IE');
          MDFe.rodo.veicReboque[i01].prop.UF      := Leitor.rCampo(tcStr, 'UF');
          MDFe.rodo.veicReboque[i01].prop.tpProp  := StrToTpProp(ok, Leitor.rCampo(tcStr, 'tpProp'));
        end;

        inc(i01);
      end;

      if Leitor.rExtrai(3, 'valePed') <> '' then
       begin
        i01 := 0;
        while Leitor.rExtrai(4, 'disp', '', i01 + 1) <> '' do
        begin
          MDFe.Rodo.valePed.disp.Add;
          MDFe.Rodo.valePed.disp[i01].CNPJForn := Leitor.rCampo(tcStr, 'CNPJForn');
          MDFe.Rodo.valePed.disp[i01].CNPJPg   := Leitor.rCampo(tcStr, 'CNPJPg');
          MDFe.Rodo.valePed.disp[i01].nCompra  := Leitor.rCampo(tcStr, 'nCompra');
          inc(i01);
        end;
       end;

     end; // fim das informa��es do modal Rodovi�rio

    (* Grupo da TAG <aereo> ***************************************************)
    if Leitor.rExtrai(2, 'aereo') <> '' then
     begin
       MDFe.Aereo.nac     := Leitor.rCampo(tcInt, 'nac');
       MDFe.Aereo.matr    := Leitor.rCampo(tcInt, 'matr');
       MDFe.Aereo.nVoo    := Leitor.rCampo(tcStr, 'nVoo');
       MDFe.Aereo.cAerEmb := Leitor.rCampo(tcStr, 'cAerEmb');
       MDFe.Aereo.cAerDes := Leitor.rCampo(tcStr, 'cAerDes');
       MDFe.Aereo.dVoo    := Leitor.rCampo(tcDat, 'dVoo');
     end; // fim das informa��es do modal A�reo

    (* Grupo da TAG <aquav> ***************************************************)
    if Leitor.rExtrai(2, 'aquav') <> '' then
     begin
       MDFe.aquav.CNPJAgeNav := Leitor.rCampo(tcStr, 'CNPJAgeNav');
       MDFe.aquav.tpEmb      := Leitor.rCampo(tcStr, 'tpEmb');
       MDFe.aquav.cEmbar     := Leitor.rCampo(tcStr, 'cEmbar');
       MDFe.aquav.xEmbar     := Leitor.rCampo(tcStr, 'xEmbar');
       MDFe.aquav.nViagem    := Leitor.rCampo(tcStr, 'nViag');
       MDFe.aquav.cPrtEmb    := Leitor.rCampo(tcStr, 'cPrtEmb');
       MDFe.aquav.cPrtDest   := Leitor.rCampo(tcStr, 'cPrtDest');

       i01 := 0;
       while Leitor.rExtrai(3, 'infTermCarreg', '', i01 + 1) <> '' do
       begin
         MDFe.aquav.infTermCarreg.Add;
         MDFe.aquav.infTermCarreg[i01].cTermCarreg := Leitor.rCampo(tcStr, 'cTermCarreg');
         MDFe.aquav.infTermCarreg[i01].xTermCarreg := Leitor.rCampo(tcStr, 'xTermCarreg');
         inc(i01);
       end;

       i01 := 0;
       while Leitor.rExtrai(3, 'infTermDescarreg', '', i01 + 1) <> '' do
       begin
         MDFe.aquav.infTermDescarreg.Add;
         MDFe.aquav.infTermDescarreg[i01].cTermDescarreg := Leitor.rCampo(tcStr, 'cTermDescarreg');
         MDFe.aquav.infTermDescarreg[i01].xTermDescarreg := Leitor.rCampo(tcStr, 'xTermDescarreg');
         inc(i01);
       end;

       i01 := 0;
       while Leitor.rExtrai(3, 'infEmbComb', '', i01 + 1) <> '' do
       begin
         MDFe.aquav.infEmbComb.Add;
         MDFe.aquav.infEmbComb[i01].cEmbComb := Leitor.rCampo(tcStr, 'cEmbComb');
         inc(i01);
       end;

       i01 := 0;
       while Leitor.rExtrai(3, 'infUnidCargaVazia', '', i01 + 1) <> '' do
       begin
         MDFe.aquav.infUnidCargaVazia.Add;
         MDFe.aquav.infUnidCargaVazia[i01].idUnidCargaVazia := Leitor.rCampo(tcStr, 'idUnidCargaVazia');
         MDFe.aquav.infUnidCargaVazia[i01].tpUnidCargaVazia := StrToUnidCarga(ok, Leitor.rCampo(tcStr, 'tpUnidCargaVazia'));
         inc(i01);
       end;

     end; // fim das informa��es do modal Aquavi�rio

    (* Grupo da TAG <ferrov> **************************************************)
    if Leitor.rExtrai(2, 'ferrov') <> '' then
     begin
       if Leitor.rExtrai(3, 'trem') <> '' then
        begin
         MDFe.ferrov.xPref  := Leitor.rCampo(tcStr, 'xPref');
         MDFe.ferrov.dhTrem := Leitor.rCampo(tcDatHor, 'dhTrem');
         MDFe.ferrov.xOri   := Leitor.rCampo(tcStr, 'xOri');
         MDFe.ferrov.xDest  := Leitor.rCampo(tcStr, 'xDest');
         MDFe.ferrov.qVag   := Leitor.rCampo(tcInt, 'qVag');
        end;

       i01 := 0;
       while Leitor.rExtrai(3, 'vag', '', i01 + 1) <> '' do
       begin
         MDFe.ferrov.vag.Add;
         MDFe.ferrov.vag[i01].serie := Leitor.rCampo(tcStr, 'serie');
         MDFe.ferrov.vag[i01].nVag  := Leitor.rCampo(tcInt, 'nVag');
         MDFe.ferrov.vag[i01].nSeq  := Leitor.rCampo(tcInt, 'nSeq');
         MDFe.ferrov.vag[i01].TU    := Leitor.rCampo(tcDe3, 'TU');
         inc(i01);
       end;

     end; // fim das informa��es do modal Ferrovi�rio
   end;

  (* Grupo da TAG <infDoc> ****************************************************)
  if Leitor.rExtrai(1, 'infDoc') <> '' then
  begin
    i01 := 0;
    while Leitor.rExtrai(2, 'infMunDescarga', '', i01 + 1) <> '' do
    begin
      MDFe.infDoc.infMunDescarga.Add;
      MDFe.infDoc.infMunDescarga[i01].cMunDescarga := Leitor.rCampo(tcInt, 'cMunDescarga');
      MDFe.infDoc.infMunDescarga[i01].xMunDescarga := Leitor.rCampo(tcStr, 'xMunDescarga');

      i02 := 0;
      while Leitor.rExtrai(3, 'infCTe', '', i02 + 1) <> '' do
      begin
        MDFe.infDoc.infMunDescarga[i01].infCTe.Add;
        MDFe.infDoc.infMunDescarga[i01].infCTe[i02].chCTe       := Leitor.rCampo(tcStr, 'chCTe');
        MDFe.infDoc.infMunDescarga[i01].infCTe[i02].SegCodBarra := Leitor.rCampo(tcStr, 'SegCodBarra');

        i03 := 0;
        while Leitor.rExtrai(4, 'infUnidTransp', '', i03 + 1) <> '' do
        begin
          MDFe.infDoc.infMunDescarga[i01].infCTe[i02].infUnidTransp.Add;
          MDFe.infDoc.infMunDescarga[i01].infCTe[i02].infUnidTransp[i03].tpUnidTransp := StrToUnidTransp(ok, Leitor.rCampo(tcStr, 'tpUnidTransp'));
          MDFe.infDoc.infMunDescarga[i01].infCTe[i02].infUnidTransp[i03].idUnidTransp := Leitor.rCampo(tcStr, 'idUnidTransp');
          MDFe.infDoc.infMunDescarga[i01].infCTe[i02].infUnidTransp[i03].qtdRat       := Leitor.rCampo(tcDe2, 'qtdRat');

          i04 := 0;
          while Leitor.rExtrai(5, 'lacUnidTransp', '', i04 + 1) <> '' do
          begin
            MDFe.infDoc.infMunDescarga[i01].infCTe[i02].infUnidTransp[i03].lacUnidTransp.Add;
            MDFe.infDoc.infMunDescarga[i01].infCTe[i02].infUnidTransp[i03].lacUnidTransp[i04].nLacre := Leitor.rCampo(tcStr, 'nLacre');
            inc(i04);
          end;

          i04 := 0;
          while Leitor.rExtrai(5, 'infUnidCarga', '', i04 + 1) <> '' do
          begin
            MDFe.infDoc.infMunDescarga[i01].infCTe[i02].infUnidTransp[i03].infUnidCarga.Add;
            MDFe.infDoc.infMunDescarga[i01].infCTe[i02].infUnidTransp[i03].infUnidCarga[i04].tpUnidCarga := StrToUnidCarga(ok, Leitor.rCampo(tcStr, 'tpUnidCarga'));
            MDFe.infDoc.infMunDescarga[i01].infCTe[i02].infUnidTransp[i03].infUnidCarga[i04].idUnidCarga := Leitor.rCampo(tcStr, 'idUnidCarga');
            MDFe.infDoc.infMunDescarga[i01].infCTe[i02].infUnidTransp[i03].infUnidCarga[i04].qtdRat      := Leitor.rCampo(tcDe2, 'qtdRat');

            i05 := 0;
            while Leitor.rExtrai(6, 'lacUnidCarga', '', i05 + 1) <> '' do
            begin
              MDFe.infDoc.infMunDescarga[i01].infCTe[i02].infUnidTransp[i03].infUnidCarga[i04].lacUnidCarga.Add;
              MDFe.infDoc.infMunDescarga[i01].infCTe[i02].infUnidTransp[i03].infUnidCarga[i04].lacUnidCarga[i05].nLacre := Leitor.rCampo(tcStr, 'nLacre');
              inc(i05);
            end;

            inc(i04);
          end;

          inc(i03);
        end;

        inc(i02);
      end;

      i02 := 0;
      while Leitor.rExtrai(3, 'infCT', '', i02 + 1) <> '' do
      begin
        MDFe.infDoc.infMunDescarga[i01].infCT.Add;
        MDFe.infDoc.infMunDescarga[i01].infCT[i02].nCT    := Leitor.rCampo(tcStr, 'nCT');
        MDFe.infDoc.infMunDescarga[i01].infCT[i02].serie  := Leitor.rCampo(tcInt, 'serie');
        MDFe.infDoc.infMunDescarga[i01].infCT[i02].subser := Leitor.rCampo(tcInt, 'subser');
        MDFe.infDoc.infMunDescarga[i01].infCT[i02].dEmi   := Leitor.rCampo(tcDat, 'dEmi');
        MDFe.infDoc.infMunDescarga[i01].infCT[i02].vCarga := Leitor.rCampo(tcDe2, 'vCarga');

        i03 := 0;
        while Leitor.rExtrai(4, 'infUnidTransp', '', i03 + 1) <> '' do
        begin
          MDFe.infDoc.infMunDescarga[i01].infCT[i02].infUnidTransp.Add;
          MDFe.infDoc.infMunDescarga[i01].infCT[i02].infUnidTransp[i03].tpUnidTransp := StrToUnidTransp(ok, Leitor.rCampo(tcStr, 'tpUnidTransp'));
          MDFe.infDoc.infMunDescarga[i01].infCT[i02].infUnidTransp[i03].idUnidTransp := Leitor.rCampo(tcStr, 'idUnidTransp');
          MDFe.infDoc.infMunDescarga[i01].infCT[i02].infUnidTransp[i03].qtdRat       := Leitor.rCampo(tcDe2, 'qtdRat');

          i04 := 0;
          while Leitor.rExtrai(5, 'lacUnidTransp', '', i04 + 1) <> '' do
          begin
            MDFe.infDoc.infMunDescarga[i01].infCT[i02].infUnidTransp[i03].lacUnidTransp.Add;
            MDFe.infDoc.infMunDescarga[i01].infCT[i02].infUnidTransp[i03].lacUnidTransp[i04].nLacre := Leitor.rCampo(tcStr, 'nLacre');
            inc(i04);
          end;

          i04 := 0;
          while Leitor.rExtrai(5, 'infUnidCarga', '', i04 + 1) <> '' do
          begin
            MDFe.infDoc.infMunDescarga[i01].infCT[i02].infUnidTransp[i03].infUnidCarga.Add;
            MDFe.infDoc.infMunDescarga[i01].infCT[i02].infUnidTransp[i03].infUnidCarga[i04].tpUnidCarga := StrToUnidCarga(ok, Leitor.rCampo(tcStr, 'tpUnidCarga'));
            MDFe.infDoc.infMunDescarga[i01].infCT[i02].infUnidTransp[i03].infUnidCarga[i04].idUnidCarga := Leitor.rCampo(tcStr, 'idUnidCarga');
            MDFe.infDoc.infMunDescarga[i01].infCT[i02].infUnidTransp[i03].infUnidCarga[i04].qtdRat      := Leitor.rCampo(tcDe2, 'qtdRat');

            i05 := 0;
            while Leitor.rExtrai(6, 'lacUnidCarga', '', i05 + 1) <> '' do
            begin
              MDFe.infDoc.infMunDescarga[i01].infCT[i02].infUnidTransp[i03].infUnidCarga[i04].lacUnidCarga.Add;
              MDFe.infDoc.infMunDescarga[i01].infCT[i02].infUnidTransp[i03].infUnidCarga[i04].lacUnidCarga[i05].nLacre := Leitor.rCampo(tcStr, 'nLacre');
              inc(i05);
            end;

            inc(i04);
          end;

          inc(i03);
        end;

        inc(i02);
      end;

      i02 := 0;
      while Leitor.rExtrai(3, 'infNFe', '', i02 + 1) <> '' do
      begin
        MDFe.infDoc.infMunDescarga[i01].infNFe.Add;
        MDFe.infDoc.infMunDescarga[i01].infNFe[i02].chNFe       := Leitor.rCampo(tcStr, 'chNFe');
        MDFe.infDoc.infMunDescarga[i01].infNFe[i02].SegCodBarra := Leitor.rCampo(tcStr, 'SegCodBarra');

        i03 := 0;
        while Leitor.rExtrai(4, 'infUnidTransp', '', i03 + 1) <> '' do
        begin
          MDFe.infDoc.infMunDescarga[i01].infNFe[i02].infUnidTransp.Add;
          MDFe.infDoc.infMunDescarga[i01].infNFe[i02].infUnidTransp[i03].tpUnidTransp := StrToUnidTransp(ok, Leitor.rCampo(tcStr, 'tpUnidTransp'));
          MDFe.infDoc.infMunDescarga[i01].infNFe[i02].infUnidTransp[i03].idUnidTransp := Leitor.rCampo(tcStr, 'idUnidTransp');
          MDFe.infDoc.infMunDescarga[i01].infNFe[i02].infUnidTransp[i03].qtdRat       := Leitor.rCampo(tcDe2, 'qtdRat');

          i04 := 0;
          while Leitor.rExtrai(5, 'lacUnidTransp', '', i04 + 1) <> '' do
          begin
            MDFe.infDoc.infMunDescarga[i01].infNFe[i02].infUnidTransp[i03].lacUnidTransp.Add;
            MDFe.infDoc.infMunDescarga[i01].infNFe[i02].infUnidTransp[i03].lacUnidTransp[i04].nLacre := Leitor.rCampo(tcStr, 'nLacre');
            inc(i04);
          end;

          i04 := 0;
          while Leitor.rExtrai(5, 'infUnidCarga', '', i04 + 1) <> '' do
          begin
            MDFe.infDoc.infMunDescarga[i01].infNFe[i02].infUnidTransp[i03].infUnidCarga.Add;
            MDFe.infDoc.infMunDescarga[i01].infNFe[i02].infUnidTransp[i03].infUnidCarga[i04].tpUnidCarga := StrToUnidCarga(ok, Leitor.rCampo(tcStr, 'tpUnidCarga'));
            MDFe.infDoc.infMunDescarga[i01].infNFe[i02].infUnidTransp[i03].infUnidCarga[i04].idUnidCarga := Leitor.rCampo(tcStr, 'idUnidCarga');
            MDFe.infDoc.infMunDescarga[i01].infNFe[i02].infUnidTransp[i03].infUnidCarga[i04].qtdRat      := Leitor.rCampo(tcDe2, 'qtdRat');

            i05 := 0;
            while Leitor.rExtrai(6, 'lacUnidCarga', '', i05 + 1) <> '' do
            begin
              MDFe.infDoc.infMunDescarga[i01].infNFe[i02].infUnidTransp[i03].infUnidCarga[i04].lacUnidCarga.Add;
              MDFe.infDoc.infMunDescarga[i01].infNFe[i02].infUnidTransp[i03].infUnidCarga[i04].lacUnidCarga[i05].nLacre := Leitor.rCampo(tcStr, 'nLacre');
              inc(i05);
            end;

            inc(i04);
          end;

          inc(i03);
        end;

        inc(i02);
      end;

      i02 := 0;
      while Leitor.rExtrai(3, 'infNF', '', i02 + 1) <> '' do
      begin
        MDFe.infDoc.infMunDescarga[i01].infNF.Add;
        MDFe.infDoc.infMunDescarga[i01].infNF[i02].CNPJ  := Leitor.rCampo(tcStr, 'CNPJ');
        MDFe.infDoc.infMunDescarga[i01].infNF[i02].UF    := Leitor.rCampo(tcStr, 'UF');
        MDFe.infDoc.infMunDescarga[i01].infNF[i02].nNF   := Leitor.rCampo(tcStr, 'nNF');
        MDFe.infDoc.infMunDescarga[i01].infNF[i02].serie := Leitor.rCampo(tcInt, 'serie');
        MDFe.infDoc.infMunDescarga[i01].infNF[i02].dEmi  := Leitor.rCampo(tcDat, 'dEmi');
        MDFe.infDoc.infMunDescarga[i01].infNF[i02].vNF   := Leitor.rCampo(tcDe2, 'vNF');
        MDFe.infDoc.infMunDescarga[i01].infNF[i02].PIN   := Leitor.rCampo(tcInt, 'PIN');

        i03 := 0;
        while Leitor.rExtrai(4, 'infUnidTransp', '', i03 + 1) <> '' do
        begin
          MDFe.infDoc.infMunDescarga[i01].infNF[i02].infUnidTransp.Add;
          MDFe.infDoc.infMunDescarga[i01].infNF[i02].infUnidTransp[i03].tpUnidTransp := StrToUnidTransp(ok, Leitor.rCampo(tcStr, 'tpUnidTransp'));
          MDFe.infDoc.infMunDescarga[i01].infNF[i02].infUnidTransp[i03].idUnidTransp := Leitor.rCampo(tcStr, 'idUnidTransp');
          MDFe.infDoc.infMunDescarga[i01].infNF[i02].infUnidTransp[i03].qtdRat       := Leitor.rCampo(tcDe2, 'qtdRat');

          i04 := 0;
          while Leitor.rExtrai(5, 'lacUnidTransp', '', i04 + 1) <> '' do
          begin
            MDFe.infDoc.infMunDescarga[i01].infNF[i02].infUnidTransp[i03].lacUnidTransp.Add;
            MDFe.infDoc.infMunDescarga[i01].infNF[i02].infUnidTransp[i03].lacUnidTransp[i04].nLacre := Leitor.rCampo(tcStr, 'nLacre');
            inc(i04);
          end;

          i04 := 0;
          while Leitor.rExtrai(5, 'infUnidCarga', '', i04 + 1) <> '' do
          begin
            MDFe.infDoc.infMunDescarga[i01].infNF[i02].infUnidTransp[i03].infUnidCarga.Add;
            MDFe.infDoc.infMunDescarga[i01].infNF[i02].infUnidTransp[i03].infUnidCarga[i04].tpUnidCarga := StrToUnidCarga(ok, Leitor.rCampo(tcStr, 'tpUnidCarga'));
            MDFe.infDoc.infMunDescarga[i01].infNF[i02].infUnidTransp[i03].infUnidCarga[i04].idUnidCarga := Leitor.rCampo(tcStr, 'idUnidCarga');
            MDFe.infDoc.infMunDescarga[i01].infNF[i02].infUnidTransp[i03].infUnidCarga[i04].qtdRat      := Leitor.rCampo(tcDe2, 'qtdRat');

            i05 := 0;
            while Leitor.rExtrai(6, 'lacUnidCarga', '', i05 + 1) <> '' do
            begin
              MDFe.infDoc.infMunDescarga[i01].infNF[i02].infUnidTransp[i03].infUnidCarga[i04].lacUnidCarga.Add;
              MDFe.infDoc.infMunDescarga[i01].infNF[i02].infUnidTransp[i03].infUnidCarga[i04].lacUnidCarga[i05].nLacre := Leitor.rCampo(tcStr, 'nLacre');
              inc(i05);
            end;

            inc(i04);
          end;

          inc(i03);
        end;

        inc(i02);
      end;

      i02 := 0;
      while Leitor.rExtrai(3, 'infMDFeTransp', '', i02 + 1) <> '' do
      begin
        MDFe.infDoc.infMunDescarga[i01].infMDFeTransp.Add;
        MDFe.infDoc.infMunDescarga[i01].infMDFeTransp[i02].chMDFe := Leitor.rCampo(tcStr, 'chMDFe');

        i03 := 0;
        while Leitor.rExtrai(4, 'infUnidTransp', '', i03 + 1) <> '' do
        begin
          MDFe.infDoc.infMunDescarga[i01].infMDFeTransp[i02].infUnidTransp.Add;
          MDFe.infDoc.infMunDescarga[i01].infMDFeTransp[i02].infUnidTransp[i03].tpUnidTransp := StrToUnidTransp(ok, Leitor.rCampo(tcStr, 'tpUnidTransp'));
          MDFe.infDoc.infMunDescarga[i01].infMDFeTransp[i02].infUnidTransp[i03].idUnidTransp := Leitor.rCampo(tcStr, 'idUnidTransp');
          MDFe.infDoc.infMunDescarga[i01].infMDFeTransp[i02].infUnidTransp[i03].qtdRat       := Leitor.rCampo(tcDe2, 'qtdRat');

          i04 := 0;
          while Leitor.rExtrai(5, 'lacUnidTransp', '', i04 + 1) <> '' do
          begin
            MDFe.infDoc.infMunDescarga[i01].infMDFeTransp[i02].infUnidTransp[i03].lacUnidTransp.Add;
            MDFe.infDoc.infMunDescarga[i01].infMDFeTransp[i02].infUnidTransp[i03].lacUnidTransp[i04].nLacre := Leitor.rCampo(tcStr, 'nLacre');
            inc(i04);
          end;

          i04 := 0;
          while Leitor.rExtrai(5, 'infUnidCarga', '', i04 + 1) <> '' do
          begin
            MDFe.infDoc.infMunDescarga[i01].infMDFeTransp[i02].infUnidTransp[i03].infUnidCarga.Add;
            MDFe.infDoc.infMunDescarga[i01].infMDFeTransp[i02].infUnidTransp[i03].infUnidCarga[i04].tpUnidCarga := StrToUnidCarga(ok, Leitor.rCampo(tcStr, 'tpUnidCarga'));
            MDFe.infDoc.infMunDescarga[i01].infMDFeTransp[i02].infUnidTransp[i03].infUnidCarga[i04].idUnidCarga := Leitor.rCampo(tcStr, 'idUnidCarga');
            MDFe.infDoc.infMunDescarga[i01].infMDFeTransp[i02].infUnidTransp[i03].infUnidCarga[i04].qtdRat      := Leitor.rCampo(tcDe2, 'qtdRat');

            i05 := 0;
            while Leitor.rExtrai(6, 'lacUnidCarga', '', i05 + 1) <> '' do
            begin
              MDFe.infDoc.infMunDescarga[i01].infMDFeTransp[i02].infUnidTransp[i03].infUnidCarga[i04].lacUnidCarga.Add;
              MDFe.infDoc.infMunDescarga[i01].infMDFeTransp[i02].infUnidTransp[i03].infUnidCarga[i04].lacUnidCarga[i05].nLacre := Leitor.rCampo(tcStr, 'nLacre');
              inc(i05);
            end;

            inc(i04);
          end;

          inc(i03);
        end;

        inc(i02);
      end;

      inc(i01);
    end;
  end;

  (* Grupo da TAG <tot> *******************************************************)
  if Leitor.rExtrai(1, 'tot') <> '' then
  begin
   MDFe.tot.qCTe   := Leitor.rCampo(tcInt, 'qCTe');
   MDFe.tot.qCT    := Leitor.rCampo(tcInt, 'qCT');
   MDFe.tot.qNFe   := Leitor.rCampo(tcInt, 'qNFe');
   MDFe.tot.qNF    := Leitor.rCampo(tcInt, 'qNF');
   MDFe.tot.qMDFe  := Leitor.rCampo(tcInt, 'qMDFe');
   MDFe.tot.vCarga := Leitor.rCampo(tcDe2, 'vCarga');
   MDFe.tot.cUnid  := StrToUnidMed(Ok, Leitor.rCampo(tcStr, 'cUnid'));
   MDFe.tot.qCarga := Leitor.rCampo(tcDe4, 'qCarga');
  end;

  (* Grupo da TAG <lacres> ****************************************************)
  i01 := 0;
  while Leitor.rExtrai(1, 'lacres', '', i01 + 1) <> '' do
  begin
    MDFe.lacres.Add;
    MDFe.lacres[i01].nLacre := Leitor.rCampo(tcStr, 'nLacre');
    inc(i01);
  end;

  (* Grupo da TAG <autXML> ****************************************************)
  i01 := 0;
  while Leitor.rExtrai(1, 'autXML', '', i01 + 1) <> '' do
  begin
    MDFe.autXML.Add;
    MDFe.autXML[i01].CNPJCPF := Leitor.rCampoCNPJCPF;;
    inc(i01);
  end;

  (* Grupo da TAG <infAdic> ***************************************************)
  if Leitor.rExtrai(1, 'infAdic') <> '' then
  begin
   MDFe.infAdic.infAdFisco := Leitor.rCampo(tcStr, 'infAdFisco');
   MDFe.infAdic.infCpl     := Leitor.rCampo(tcStr, 'infCpl');
  end;

  (* Grupo da TAG <signature> *************************************************)

  Leitor.Grupo := Leitor.Arquivo;

  MDFe.signature.URI             := Leitor.rAtributo('Reference URI=');
  MDFe.signature.DigestValue     := Leitor.rCampo(tcStr, 'DigestValue');
  MDFe.signature.SignatureValue  := Leitor.rCampo(tcStr, 'SignatureValue');
  MDFe.signature.X509Certificate := Leitor.rCampo(tcStr, 'X509Certificate');

  (* Grupo da TAG <protMDFe> **************************************************)
  if Leitor.rExtrai(1, 'protMDFe') <> '' then
  begin
    MDFe.procMDFe.tpAmb    := StrToTpAmb(ok, Leitor.rCampo(tcStr, 'tpAmb'));
    MDFe.procMDFe.verAplic := Leitor.rCampo(tcStr, 'verAplic');
    MDFe.procMDFe.chMDFe   := Leitor.rCampo(tcStr, 'chMDFe');
    MDFe.procMDFe.dhRecbto := Leitor.rCampo(tcDatHor, 'dhRecbto');
    MDFe.procMDFe.nProt    := Leitor.rCampo(tcStr, 'nProt');
    MDFe.procMDFe.digVal   := Leitor.rCampo(tcStr, 'digVal');
    MDFe.procMDFe.cStat    := Leitor.rCampo(tcInt, 'cStat');
    MDFe.procMDFe.xMotivo  := Leitor.rCampo(tcStr, 'xMotivo');
  end;

  Result := True;
end;

end.

