////////////////////////////////////////////////////////////////////////////////
//                                                                            //
//              PCN - Projeto Cooperar NFe                                    //
//                                                                            //
//   Descri��o: Classes para gera��o/leitura dos arquivos xml da NFe          //
//                                                                            //
//        site: www.projetocooperar.org                                       //
//       email: projetocooperar@zipmail.com.br                                //
//       forum: http://br.groups.yahoo.com/group/projeto_cooperar_nfe/        //
//     projeto: http://code.google.com/p/projetocooperar/                     //
//         svn: http://projetocooperar.googlecode.com/svn/trunk/              //
//                                                                            //
// Coordena��o: (c) 2009 - Paulo Casagrande                                   //
//                                                                            //
//      Equipe: Vide o arquivo leiame.txt na pasta raiz do projeto            //
//                                                                            //
//      Vers�o: Vide o arquivo leiame.txt na pasta raiz do projeto            //
//                                                                            //
//     Licen�a: GNU Lesser General Public License (GNU LGPL)                  //
//                                                                            //
//              - Este programa � software livre; voc� pode redistribu�-lo    //
//              e/ou modific�-lo sob os termos da Licen�a P�blica Geral GNU,  //
//              conforme publicada pela Free Software Foundation; tanto a     //
//              vers�o 2 da Licen�a como (a seu crit�rio) qualquer vers�o     //
//              mais nova.                                                    //
//                                                                            //
//              - Este programa � distribu�do na expectativa de ser �til,     //
//              mas SEM QUALQUER GARANTIA; sem mesmo a garantia impl�cita de  //
//              COMERCIALIZA��O ou de ADEQUA��O A QUALQUER PROP�SITO EM       //
//              PARTICULAR. Consulte a Licen�a P�blica Geral GNU para obter   //
//              mais detalhes. Voc� deve ter recebido uma c�pia da Licen�a    //
//              P�blica Geral GNU junto com este programa; se n�o, escreva    //
//              para a Free Software Foundation, Inc., 59 Temple Place,       //
//              Suite 330, Boston, MA - 02111-1307, USA ou consulte a         //
//              licen�a oficial em http://www.gnu.org/licenses/gpl.txt        //
//                                                                            //
//    Nota (1): - Esta  licen�a  n�o  concede  o  direito  de  uso  do nome   //
//              "PCN  -  Projeto  Cooperar  NFe", n�o  podendo o mesmo ser    //
//              utilizado sem previa autoriza��o.                             //
//                                                                            //
//    Nota (2): - O uso integral (ou parcial) das units do projeto esta       //
//              condicionado a manuten��o deste cabe�alho junto ao c�digo     //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////

{$I ACBr.inc}

unit pcnRetDPEC;

interface

uses
  SysUtils, Classes, pcnAuxiliar, pcnConversao, pcnLeitor;

type

  TRetDPEC = class(TPersistent)
  private
    FLeitor: TLeitor;
    Fversao: String;
    FId: String;
    FtpAmb: TpcnTipoAmbiente;
    FverAplic: String;
    FcStat: Integer;
    FxMotivo: String;
    FdhRegDPEC: TDateTime;
    FnRegDPEC: String;
    FchNFE: String;
  public
    constructor Create;
    destructor Destroy; override;
    function LerXml: Boolean;
  published
    property Leitor: TLeitor         read FLeitor    write FLeitor;
    property versao: String          read Fversao    write Fversao;
    property Id: String              read FId        write FId;
    property tpAmb: TpcnTipoAmbiente read FtpAmb     write FtpAmb;
    property verAplic: String        read FverAplic  write FverAplic;
    property cStat: Integer          read FcStat     write FcStat;
    property xMotivo: String         read FxMotivo   write FxMotivo;
    property dhRegDPEC: TDateTime    read FdhRegDPEC write FdhRegDPEC;
    property nRegDPEC: String        read FnRegDPEC  write FnRegDPEC;
    property chNFE: String           read FchNFE     write FchNFE;
  end;

implementation

{ TRetDPEC }

constructor TRetDPEC.Create;
begin
  FLeitor := TLeitor.Create;
end;

destructor TRetDPEC.Destroy;
begin
  FLeitor.Free;
  inherited;
end;

function TRetDPEC.LerXml: Boolean;
var
  ok: Boolean;
begin
  Result := False;
  try
    Leitor.Grupo := Leitor.Arquivo;

    Fversao := Leitor.rAtributo('versao');
    
    if Leitor.rExtrai(1, 'infDPECReg') <> '' then
    begin
      (*AR04 *)FId       := Leitor.rAtributo('infDPECReg Id=');
      (*AR05 *)FtpAmb    := StrToTpAmb(ok, Leitor.rCampo(tcStr, 'tpAmb'));
      (*AR06 *)FverAplic := Leitor.rCampo(tcStr, 'verAplic');
      (*AR07 *)FcStat    := Leitor.rCampo(tcInt, 'cStat');
      (*AR08 *)FxMotivo  := Leitor.rCampo(tcStr, 'xMotivo');

      if cStat = 124 then
      begin
        (*AR09 *)FdhRegDPEC := Leitor.rCampo(tcDatHor, 'dhRegDPEC');
        (*AR10 *)nRegDPEC   := Leitor.rCampo(tcStr, 'nRegDPEC');
        (*AR10 *)FchNFe     := Leitor.rCampo(tcStr, 'chNFe');
      end;
      
      Result := True;
    end;
  except
    Result := False;
  end;
end;

end.

