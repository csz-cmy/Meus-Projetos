{******************************************************************************}
{ Projeto: Componente ACBrGNRE                                                 }
{  Biblioteca multiplataforma de componentes Delphi/Lazarus para emiss�o da    }
{  Guia Nacional de Recolhimento de Tributos Estaduais                         }
{  http://www.gnre.pe.gov.br/                                                  }
{                                                                              }
{ Direitos Autorais Reservados (c) 2013 Claudemir Vitor Pereira                }
{                                       Daniel Simoes de Almeida               }
{                                       Andr� Ferreira de Moraes               }
{                                       Juliomar Marchetti                     }
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
|* 09/12/2013 - Claudemir Vitor Pereira
|*  - Doa��o do componente para o Projeto ACBr
******************************************************************************}
{$I ACBr.inc}

unit ACBrGNREGuiaFR;

interface

uses
  Forms, SysUtils, Classes, Graphics, ACBrGNREGuiaClass, ACBrGNREGuiaFRDM,
  pcnConversao, frxClass, pgnreGNRERetorno;

type
  EACBrGNREGuiaFR = class(Exception);

  TACBrGNREGuiaFR = class( TACBrGNREGuiaClass )
   private
    FdmGuia: TdmACBrGNREFR;
    FFastFile: String;
    FEspessuraBorda: Integer;
    function GetPreparedReport: TfrxReport;
    function PrepareReport(GNRE: TGNRERetorno = nil): Boolean;
   public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ImprimirGuia(GNRE: TGNRERetorno = nil); override;
    procedure ImprimirGuiaPDF(GNRE: TGNRERetorno = nil); override;
  published
    property FastFile: String read FFastFile write FFastFile;
    property dmGuia: TdmACBrGNREFR read FdmGuia write FdmGuia;
    property EspessuraBorda: Integer read FEspessuraBorda write FEspessuraBorda;
    property PreparedReport: TfrxReport read GetPreparedReport;
  end;

implementation

uses ACBrGNRE2, ACBrGNREUtil, ACBrUtil, StrUtils, Dialogs,
  ACBrGNREGuiasRetorno;

constructor TACBrGNREGuiaFR.Create(AOwner: TComponent);
begin
  inherited create( AOwner );
  FdmGuia := TdmACBrGNREFR.Create(Self);
  FFastFile := '' ;
  FEspessuraBorda := 1;
end;

destructor TACBrGNREGuiaFR.Destroy;
begin
  dmGuia.Free;
  inherited Destroy;
end;

function TACBrGNREGuiaFR.GetPreparedReport: TfrxReport;
begin
  if Trim(FFastFile) = '' then
    Result := nil
  else
  begin
    if PrepareReport(nil) then
      Result := dmGuia.frxReport
    else
      Result := nil;
  end;
end;

procedure TACBrGNREGuiaFR.ImprimirGuia(GNRE: TGNRERetorno);
begin
  if PrepareReport(GNRE) then
  begin
    if MostrarPreview then
      dmGuia.frxReport.ShowPreparedReport
    else
      dmGuia.frxReport.Print;
  end;
end;

procedure TACBrGNREGuiaFR.ImprimirGuiaPDF(GNRE: TGNRERetorno);
const
  TITULO_PDF = 'Guia Nacional de Recolhimento de Tributos Estaduais - GNRE';
var
  i: Integer;
begin
  if PrepareReport(GNRE) then
  begin
    dmGuia.frxPDFExport.Author     := Sistema;
    dmGuia.frxPDFExport.Creator    := Sistema;
    dmGuia.frxPDFExport.Producer   := Sistema;
    dmGuia.frxPDFExport.Title      := TITULO_PDF;
    dmGuia.frxPDFExport.Subject    := TITULO_PDF;
    dmGuia.frxPDFExport.Keywords   := TITULO_PDF;
    dmGuia.frxPDFExport.ShowDialog := False;

    for I := 0 to TACBrGNRE(ACBrGNRE).GuiasRetorno.Count - 1 do
    begin
      dmGuia.frxPDFExport.FileName := IncludeTrailingPathDelimiter(PathPDF) + 'GNRE_' + dmGuia.GNRE.RepresentacaoNumerica + '.pdf';
      dmGuia.frxReport.Export(dmGuia.frxPDFExport);
    end;
  end;
end;

function TACBrGNREGuiaFR.PrepareReport(GNRE: TGNRERetorno): Boolean;
var
  i: Integer;
begin
  Result := False;

  if Trim(FastFile) <> '' then
  begin
    if FileExists(FastFile) then
      dmGuia.frxReport.LoadFromFile(FastFile)
    else
      raise EACBrGNREGuiaFR.CreateFmt('Caminho do arquivo de impress�o da Guia "%s" inv�lido.', [FastFile]);
  end
  else
    raise EACBrGNREGuiaFR.Create('Caminho do arquivo de impress�o do Guia n�o assinalado.');

  if Assigned(GNRE) then
  begin
    dmGuia.GNRE := GNRE;
    dmGuia.CarregaDados;

    Result := dmGuia.frxReport.PrepareReport;
  end
  else
  begin
    if Assigned(ACBrGNRE) then
    begin
      for i := 0 to TACBrGNRE(ACBrGNRE).GuiasRetorno.Count - 1 do
      begin
        dmGuia.GNRE := TACBrGNRE(ACBrGNRE).GuiasRetorno.Items[i].GNRE;
        dmGuia.CarregaDados;

        if (i > 0) then
          Result := dmGuia.frxReport.PrepareReport(False)
        else
          Result := dmGuia.frxReport.PrepareReport;
      end;
    end
    else
      raise EACBrGNREGuiaFR.Create('Propriedade ACBrGNRE n�o assinalada.');
  end;
end;

end.
