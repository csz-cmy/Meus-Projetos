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
|* 04/04/2013:  Andr� Ferreira de Moraes
|*   Inicio do desenvolvimento
******************************************************************************}

{$I ACBr.inc}

unit ACBrSATExtratoClass;

interface

uses SysUtils,
     Classes, Graphics,
     ACBrBase,
     pcnCFe, pcnCFeCanc;

type
   TACBrSATExtratoFiltro = (fiNenhum, fiPDF, fiHTML ) ;

   TACBrSATExtratoLayOut = (lCompleto, lResumido, lCancelamento) ;


   { TACBrSATExtratoMargem }

   TACBrSATExtratoMargem = class( TPersistent )
   private
     fDireita: Integer;
     fEsquerda: Integer;
     fFundo: Integer;
     fTopo: Integer;
   public
     constructor create;
   published
     property Topo     : Integer read fTopo     write fTopo     default 2;
     property Esquerda : Integer read fEsquerda write fEsquerda default 2;
     property Fundo    : Integer read fFundo    write fFundo    default 20;
     property Direita  : Integer read fDireita  write fDireita  default 2;
   end;

  { TACBrSATExtratoClass }

  TACBrSATExtratoClass = class( TACBrComponent )
  private
    fACBrSAT : TComponent;
    fImprimeQRCode: Boolean;
    fCFe: TCFe;
    fCFeCanc: TCFeCanc;

    fFiltro: TACBrSATExtratoFiltro;
    fMask_qCom: String;
    fMask_vUnCom: String;
    fMostrarPreview: Boolean;
    fMostrarSetup: Boolean;
    fNomeArquivo: String;
    fNumCopias: Integer;
    fPrinterName : String;
    fPictureLogo: TPicture;
    fSoftwareHouse: String;

    procedure ErroAbstract(NomeProcedure : String) ;
    function GetAbout: String;
    function GetNomeArquivo: String;
    procedure SetAbout(AValue: String);
    procedure SetNumCopias(AValue: Integer);
    procedure SetPictureLogo(AValue: TPicture);
    procedure SetSAT(const Value: TComponent);

    procedure SetInternalCFe(ACFe: TCFe);
    procedure SetInternalCFeCanc(ACFeCanc: TCFeCanc);
    procedure VerificaExisteACBrSAT;
  protected
    fpAbout : String ;
    fpLayOut: TACBrSATExtratoLayOut;

    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    property PrinterName    : String   read fPrinterName    write fPrinterName;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property LayOut  : TACBrSATExtratoLayOut read fpLayOut ;
    property CFe     : TCFe                  read fCFe;
    property CFeCanc : TCFeCanc              read fCFeCanc;

    procedure ImprimirExtrato(ACFe : TCFe = nil); virtual;
    procedure ImprimirExtratoResumido(ACFe : TCFe = nil); virtual;
    procedure ImprimirExtratoCancelamento(ACFe : TCFe = nil; ACFeCanc: TCFeCanc = nil); virtual;

    function CalcularConteudoQRCode(ID: String; dEmi_hEmi: TDateTime;
      Valor: Double; CNPJCPF: String; assinaturaQRCODE: String): String;
  published
    property ACBrSAT  : TComponent  read FACBrSAT write SetSAT ;

    property About  : String read GetAbout write SetAbout stored False ;

    property Mask_qCom      : String   read fMask_qCom      write fMask_qCom;
    property Mask_vUnCom    : String   read fMask_vUnCom    write fMask_vUnCom;
    property ImprimeQRCode  : Boolean  read fImprimeQRCode  write fImprimeQRCode  default True ;
    property PictureLogo    : TPicture read fPictureLogo    write SetPictureLogo ;
    property MostrarPreview : Boolean  read fMostrarPreview write fMostrarPreview default False ;
    property MostrarSetup   : Boolean  read fMostrarSetup   write fMostrarSetup   default False ;
    property NumCopias      : Integer  read fNumCopias      write SetNumCopias    default 1;
    property NomeArquivo    : String   read GetNomeArquivo  write fNomeArquivo ;
    property SoftwareHouse  : String   read fSoftwareHouse  write fSoftwareHouse;
    property Filtro         : TACBrSATExtratoFiltro read fFiltro write fFiltro default fiNenhum ;
  end ;

implementation

uses ACBrSAT, ACBrDFeUtil, ACBrSATClass;

{ TACBrSATExtratoMargem }

constructor TACBrSATExtratoMargem.create;
begin
  inherited create;

  fDireita  := 2;
  fEsquerda := 2;
  fTopo     := 2;
  fFundo    := 20;
end;

{ TACBrSATExtratoClass }

constructor TACBrSATExtratoClass.Create(AOwner: TComponent);
begin
  inherited create( AOwner );

  fpAbout  := 'ACBrSATExtratoClass' ;
  fpLayOut := lCompleto;

  fACBrSAT := nil;
  fCFe     := nil;
  fCFeCanc := nil;

  fPictureLogo := TPicture.Create;

  fNumCopias      := 1;
  fMostrarPreview := False;
  fMostrarSetup   := False;
  fImprimeQRCode  := True;
  fFiltro         := fiNenhum;
  fNomeArquivo    := '' ;
  fMask_qCom      := '0.0000';
  fMask_vUnCom    := '0.000';
  fPrinterName    := '' ;
end;

destructor TACBrSATExtratoClass.Destroy;
begin
  fPictureLogo.Free;

  inherited Destroy ;
end;

procedure TACBrSATExtratoClass.ImprimirExtrato(ACFe: TCFe);
begin
  SetInternalCFe( ACFe );
  fpLayOut := lCompleto;
end;

procedure TACBrSATExtratoClass.ImprimirExtratoCancelamento(ACFe: TCFe;
  ACFeCanc: TCFeCanc);
begin
  SetInternalCFe( ACFe );
  SetInternalCFeCanc( ACFeCanc );
  fpLayOut := lCancelamento;
end;

function TACBrSATExtratoClass.CalcularConteudoQRCode(ID: String;
  dEmi_hEmi:TDateTime; Valor: Double; CNPJCPF: String;
  assinaturaQRCODE: String): String;
begin
  Result := ID + '|' +
            FormatDateTime('yyyymmddhhmmss',dEmi_hEmi) + '|' +
            DFeUtil.FormatFloat(Valor,'0.00') + '|' +
            Trim(CNPJCPF) + '|' +
            assinaturaQRCODE;
end;

procedure TACBrSATExtratoClass.ImprimirExtratoResumido(ACFe: TCFe);
begin
  SetInternalCFe( ACFe );
  fpLayOut := lResumido;
end;

procedure TACBrSATExtratoClass.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);

  if (Operation = opRemove) and (FACBrSAT <> nil) and (AComponent is TACBrSAT) then
     FACBrSAT := nil ;
end;

procedure TACBrSATExtratoClass.ErroAbstract(NomeProcedure : String) ;
begin
  raise EACBrSATErro.create( Format( 'Procedure: %s '+ sLineBreak +
                                     ' n�o implementada para o Extrato: %s' ,
                                     [NomeProcedure, ClassName] )) ;
end ;

function TACBrSATExtratoClass.GetAbout: String;
begin
  Result := fpAbout ;
end;

function TACBrSATExtratoClass.GetNomeArquivo: String;
var
  wPath: String;
begin
   wPath  := ExtractFilePath(fNomeArquivo);
   Result := '';

   if wPath = '' then
      if not (csDesigning in Self.ComponentState) then
         Result := ExtractFilePath(ParamStr(0)) ;

   Result := trim(Result + fNomeArquivo);
end;

procedure TACBrSATExtratoClass.SetAbout(AValue: String);
begin
  {}
end;

procedure TACBrSATExtratoClass.SetNumCopias(AValue: Integer);
begin
  if fNumCopias = AValue then Exit;
  fNumCopias := AValue;
end;

procedure TACBrSATExtratoClass.SetPictureLogo(AValue: TPicture);
begin
  fPictureLogo.Assign( AValue );
end;

procedure TACBrSATExtratoClass.SetSAT(const Value: TComponent);
var
  OldValue : TACBrSAT ;
begin
  if Value <> FACBrSAT then
  begin
     if Value <> nil then
        if not (Value is TACBrSAT) then
           raise Exception.Create('ACBrSATExtrato.SAT deve ser do tipo TACBrSAT') ;

     if Assigned(FACBrSAT) then
        FACBrSAT.RemoveFreeNotification(Self);

     OldValue := TACBrSAT(FACBrSAT) ;   // Usa outra variavel para evitar Loop Infinito
     FACBrSAT := Value;                 // na remo��o da associa��o dos componentes

     if Assigned(OldValue) then
        if Assigned(OldValue.Extrato) then
           OldValue.Extrato := nil ;

     if Value <> nil then
     begin
        Value.FreeNotification(self);
        TACBrSAT(Value).Extrato := self ;
     end ;
  end ;
end;

procedure TACBrSATExtratoClass.SetInternalCFe(ACFe: TCFe);
begin
  if ACFe = nil then
  begin
    VerificaExisteACBrSAT;
    fCFe := TACBrSAT(ACBrSAT).CFe;
  end
  else
    fCFe := ACFe;
end;

procedure TACBrSATExtratoClass.SetInternalCFeCanc(ACFeCanc: TCFeCanc);
begin
  if ACFeCanc = nil then
  begin
    VerificaExisteACBrSAT;
    fCFeCanc := TACBrSAT(ACBrSAT).CFeCanc;
  end
  else
    fCFeCanc := ACFeCanc;
end;

procedure TACBrSATExtratoClass.VerificaExisteACBrSAT;
begin
  if not Assigned(ACBrSAT) then
     raise Exception.Create('Componente ACBrSAT n�o atribu�do');
end;

end.
