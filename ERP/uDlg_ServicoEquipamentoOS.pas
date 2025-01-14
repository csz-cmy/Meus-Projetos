unit uDlg_ServicoEquipamentoOS;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uDlg_CadastroERP, StdCtrls, Buttons, ExtCtrls, Mask, EditPesquisa,
  Grids, DBGrids, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxContainer, cxEdit, dxSkinsCore, dxSkinBlack, dxSkinBlue, dxSkinCaramel,
  dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide, dxSkinFoggy, dxSkinGlassOceans,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSharp, dxSkinSilver, dxSkinSpringTime,
  dxSkinStardust, dxSkinSummer2008, dxSkinsDefaultPainters, dxSkinValentine,
  dxSkinXmas2008Blue, cxTextEdit, cxMemo, cxDBEdit, cxNavigator, cxDBNavigator,
  cxStyles, dxSkinscxPCPainter, cxCustomData, cxFilter, cxData, cxDataStorage,
  DB, cxDBData, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGridLevel, cxClasses, cxGridCustomView, cxGrid, cxSpinEdit, cxTimeEdit,
  cxMaskEdit, cxDropDownEdit, cxCalendar, cxDBLookupComboBox, DBClient,
  pFIBClientDataSet,ulibERP, cxPC,uClassesERP;

type
  TfrmDlg_ServicoEquipamentoOS = class(TfrmDlg_CadastroERP)
    Panel3: TPanel;
    edtServico: TEditPesquisa;
    Panel4: TPanel;
    edtFuncionario: TEditPesquisa;
    Panel5: TPanel;
    Label1: TLabel;
    cxDBDateEdit1: TcxDBDateEdit;
    Label2: TLabel;
    cxDBTimeEdit1: TcxDBTimeEdit;
    DataAlmoxarifado: TDataSource;
    CdsAlmoxarifado: TpFIBClientDataSet;
    DataProdutos: TDataSource;
    DataSerial: TDataSource;
    Page: TcxPageControl;
    cxTabSheet1: TcxTabSheet;
    GroupBox1: TGroupBox;
    mmDefeito: TcxDBMemo;
    Panel6: TPanel;
    edtAlmoxarifado: TEditPesquisa;
    GridProduto: TcxGrid;
    tvProduto: TcxGridDBTableView;
    tvProdutoColumn1: TcxGridDBColumn;
    tvProdutoColumn2: TcxGridDBColumn;
    tvProdutoColumn3: TcxGridDBColumn;
    tvProdutoColumn4: TcxGridDBColumn;
    tvProdutoColumn5: TcxGridDBColumn;
    tvProdutoColumn6: TcxGridDBColumn;
    GridProdutoDBTableView1: TcxGridDBTableView;
    GridProdutoDBTableView1Column1: TcxGridDBColumn;
    GridProdutoLevel1: TcxGridLevel;
    GridProdutoLevel2: TcxGridLevel;
    cxTabSheet2: TcxTabSheet;
    DataPatrimonio: TDataSource;
    cxGrid1DBTableView1: TcxGridDBTableView;
    cxGrid1Level1: TcxGridLevel;
    cxGrid1: TcxGrid;
    cxGrid1DBTableView1Column1: TcxGridDBColumn;
    cxGrid1DBTableView1Column2: TcxGridDBColumn;
    cxGrid1DBTableView1Column3: TcxGridDBColumn;
    edtEventoPatrimonio: TEditPesquisa;
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edtServicoRegAchado(const ValoresCamposEstra: array of Variant);
    procedure btnOkClick(Sender: TObject);
    procedure cxGrid1DBTableView1NavigatorButtonsButtonClick(Sender: TObject;
      AButtonIndex: Integer; var ADone: Boolean);
  private
    FIdCliente: TipoCampoChave;
    FIdEmpresa: TipoCampoChave;
    FData: TDate;
    FDataSetProdutos: TpFIBClientDataSet;
    FDataSetProdutosSerial: TpFIBClientDataSet;
    FDataSetPatrimonio: TpFIBClientDataSet;
    FTipoMovimento: TTipoMovimento;
    FIdPatrimonio: TipoCampoChave;
    procedure SetIdCliente(const Value: TipoCampoChave);
    procedure SetData(const Value: TDate);
    procedure SetIdEmpresa(const Value: TipoCampoChave);
    Function TotalProdutos: Currency;
    procedure SetDataSetProdutos(const Value: TpFIBClientDataSet);
    procedure SetDataSetProdutosSerial(const Value: TpFIBClientDataSet);
    procedure SetDataSetPatrimonio(const Value: TpFIBClientDataSet);
    procedure SetTipoMovimento(const Value: TTipoMovimento);
    procedure SetIdPatrimonio(const Value: TipoCampoChave);
    { Private declarations }
  public
    { Public declarations }
    property IdCliente: TipoCampoChave read FIdCliente write SetIdCliente;
    property IdEmpresa: TipoCampoChave read FIdEmpresa write SetIdEmpresa;
    property IdPatrimonio: TipoCampoChave  read FIdPatrimonio write SetIdPatrimonio;
    property Data: TDate read FData write SetData;
    property DataSetProdutos: TpFIBClientDataSet read FDataSetProdutos write SetDataSetProdutos;
    property DataSetProdutosSerial: TpFIBClientDataSet read FDataSetProdutosSerial write SetDataSetProdutosSerial;
    property DataSetPatrimonio: TpFIBClientDataSet read FDataSetPatrimonio write SetDataSetPatrimonio;
    property TipoMovimento: TTipoMovimento read FTipoMovimento write SetTipoMovimento;
  end;

var
  frmDlg_ServicoEquipamentoOS: TfrmDlg_ServicoEquipamentoOS;

implementation

uses Comandos, MinhasClasses, UDmConexao, uRegras,  uConstantes, uSQLERP, uSQL;

{$R *.dfm}


procedure TfrmDlg_ServicoEquipamentoOS.btnOkClick(Sender: TObject);
begin
  VerificaEdit(edtFuncionario,'Informe o funcion�rio');
  VerificaEdit(edtServico,'Informe o servi�o');

  pDataSet.FieldByName('VALORTOTALPRODUTOS').AsCurrency := TotalProdutos;
  pDataSet.FieldByName('VALORTOTAL').AsCurrency :=
      pDataSet.FieldByName('VALORTOTALPRODUTOS').AsCurrency +
      edtServico.DataSet.FieldByName('VALORSERVICO').AsCurrency;
  inherited;

end;

procedure TfrmDlg_ServicoEquipamentoOS.cxGrid1DBTableView1NavigatorButtonsButtonClick(
  Sender: TObject; AButtonIndex: Integer; var ADone: Boolean);
begin
  inherited;
  if AButtonIndex = 6 then
  begin
     AdicionaListaPesquisa(FDataSetPatrimonio,tpERPPatrimonio,'Esse patrim�nio j� foi adicionado');
     ADone := True;
  end;

end;

procedure TfrmDlg_ServicoEquipamentoOS.edtServicoRegAchado(
  const ValoresCamposEstra: array of Variant);
 var
   StrSQL:String;
begin
  inherited;
  if TipoMovimento = tmPatrimonio then
  begin
    StrSQL := ' te.idservico = '+TipoCampoChaveToStr(edtServico.ValorChave)+
              '  and te.idtipoeventopatrimonio in ( select IDTIPOEVENTOPATRIMONIO '+
              '                                       from ('+
                                              GetSelect(tpERPPatrimoniosEventos,'exists(select idtipopatrimonio '+
                                                 '         from patrimonio p     '+
                                                 '        where p.IDPATRIMONIO = '+TipoCampoChaveToStr(FIdPatrimonio)+
                                                 '          and p.idtipopatrimonio = x.idtipopatrimonio)))' );

    edtEventoPatrimonio.SQLComp := StrSQL;

  end else
  if GridProduto.CanFocus then
    GridProduto.SetFocus;
  if edtServico.DataSet.State in [dsInsert,dsEdit]  then
  begin
    edtServico.DataSet.FieldByName('CODIGOSERVICO').AsString := edtServico.Text;
    edtServico.DataSet.FieldByName('DESCRICAOSERVICO').AsString := edtServico.Display.Text;
    edtServico.DataSet.FieldByName('VALORSERVICO').Value :=
         TRegrasVendaProduto.PrecoVendaProduto(edtServico.DataSet.FieldByName('IDPRODUTO').Value,
                                                 IdCliente,
                                                 IdEmpresa,
                                                 Data);
  end;



end;

procedure TfrmDlg_ServicoEquipamentoOS.FormKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
 if (ActiveControl.ClassName = 'TcxGridSite') then
  begin
    if (key= VK_RETURN) or (key= VK_ESCAPE)  then
      Key := 0;
  end;

  inherited;

end;

procedure TfrmDlg_ServicoEquipamentoOS.FormShow(Sender: TObject);
begin
  inherited;
  if FTipoMovimento = tmPatrimonio then
  begin
    ConfiguraEditPesquisa(edtEventoPatrimonio,pDataSet, tpERPTipoEventos);
    edtEventoPatrimonio.NomeTabela := 'TIPOEVENTOPATRIMONIO TE ';
  end;

  ConfiguraEditPesquisa(edtServico,pDataSet,tpERPProduto,True);
  ConfiguraEditPesquisa(edtAlmoxarifado,pDataSet,tpERPAlmoxarifado,True);
  TRotinasPesquisa.ConfiguraPesquisaFuncionario(edtFuncionario,pDataSet);
  SetCds(CdsAlmoxarifado,tpERPAlmoxarifado,'1=1');
  edtServico.SQLComp :='TIPOPRODUTO= '+QuotedStr(TipoProdutoServico);
  DataSerial.DataSet := DataSetProdutosSerial;
  DataProdutos.DataSet := DataSetProdutos;
  DataPatrimonio.DataSet := DataSetPatrimonio;

end;

procedure TfrmDlg_ServicoEquipamentoOS.SetData(const Value: TDate);
begin
  FData := Value;
end;

procedure TfrmDlg_ServicoEquipamentoOS.SetDataSetPatrimonio(
  const Value: TpFIBClientDataSet);
begin
  FDataSetPatrimonio := Value;
end;

procedure TfrmDlg_ServicoEquipamentoOS.SetDataSetProdutos(
  const Value: TpFIBClientDataSet);
begin
  FDataSetProdutos := Value;
end;

procedure TfrmDlg_ServicoEquipamentoOS.SetDataSetProdutosSerial(
  const Value: TpFIBClientDataSet);
begin
  FDataSetProdutosSerial := Value;
end;

procedure TfrmDlg_ServicoEquipamentoOS.SetIdCliente(const Value: TipoCampoChave);
begin
  FIdCliente := Value;
end;

procedure TfrmDlg_ServicoEquipamentoOS.SetIdEmpresa(const Value: TipoCampoChave);
begin
  FIdEmpresa := Value;
end;

procedure TfrmDlg_ServicoEquipamentoOS.SetIdPatrimonio(
  const Value: TipoCampoChave);
begin
  FIdPatrimonio := Value;
end;

procedure TfrmDlg_ServicoEquipamentoOS.SetTipoMovimento(
  const Value: TTipoMovimento);
begin
  FTipoMovimento := Value;
  edtEventoPatrimonio.Visible := Value = tmPatrimonio;
end;

function TfrmDlg_ServicoEquipamentoOS.TotalProdutos: Currency;
var
  Temp: String;
begin
   Result := 0;
   Temp := VarToStr(tvProduto.DataController.Summary.FooterSummaryValues[0]);
   Result := StrToCurrDef(Temp,0);
end;

end.
