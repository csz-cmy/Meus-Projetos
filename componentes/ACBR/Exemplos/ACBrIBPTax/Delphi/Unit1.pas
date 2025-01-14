unit Unit1;

interface

uses
  ACBrIBPTax,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DB, DBClient, Buttons, DBCtrls, ExtCtrls, Grids, DBGrids,
  ACBrBase, ACBrSocket, ComCtrls;

type
  TForm1 = class(TForm)
    GroupBox2: TGroupBox;
    Label3: TLabel;
    edNCM: TEdit;
    btnPesquisar: TBitBtn;
    rgTipoExportacao: TRadioGroup;
    Panel1: TPanel;
    DBNavigator1: TDBNavigator;
    btExportar: TBitBtn;
    btSair: TBitBtn;
    btProxy: TBitBtn;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    sbArquivo: TSpeedButton;
    lVersao: TLabel;
    edArquivo: TEdit;
    btAbrir: TBitBtn;
    btDownload: TBitBtn;
    OpenDialog1: TOpenDialog;
    tmpCadastro: TClientDataSet;
    dtsCadastro: TDataSource;
    SaveDialog1: TSaveDialog;
    tmpCadastroNCM: TStringField;
    tmpCadastroEx: TIntegerField;
    tmpCadastroTabela: TIntegerField;
    ACBrIBPTax1: TACBrIBPTax;
    Label2: TLabel;
    edURL: TEdit;
    ckbBuscaNCMParcial: TCheckBox;
    tmpCadastroDescricao: TStringField;
    Label4: TLabel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    DBGrid1: TDBGrid;
    Memo1: TMemo;
    tmpCadastroAliqFedNacional: TFloatField;
    tmpCadastroAliqFedImportado: TFloatField;
    tmpCadastroAliqEstadual: TFloatField;
    tmpCadastroAliqMunicipal: TFloatField;
    lbVigencia: TLabel;
    lblChave: TLabel;
    lblFonte: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btExportarClick(Sender: TObject);
    procedure btSairClick(Sender: TObject);
    procedure btDownloadClick(Sender: TObject);
    procedure btAbrirClick(Sender: TObject);
    procedure sbArquivoClick(Sender: TObject);
    procedure btProxyClick(Sender: TObject);
    procedure btnPesquisarClick(Sender: TObject);
    procedure ACBrIBPTax1ErroImportacao(const ALinha, AErro: string);
  private

  public

  end;

var
  Form1: TForm1;

implementation

uses
  ProxyConfig;

{$R *.dfm}

procedure TForm1.ACBrIBPTax1ErroImportacao(const ALinha, AErro: string);
begin
  Memo1.Lines.Add(Alinha);
  Memo1.Lines.Add(AErro);
  Memo1.Lines.Add('');
end;

procedure TForm1.btAbrirClick(Sender: TObject);
var
  I: Integer;
begin
  Memo1.Clear;

  // configurar a URL do arquivo para ser baixado
  if Trim(edURL.Text) <> '' then
    ACBrIBPTax1.URLDownload := Trim(edURL.Text);

  // se o path do arquivo n�o for passado, ent�o o componente vai tentar baixar
  // a tabela no URL informado
  Memo1.Lines.BeginUpdate;
  try
    if ACBrIBPTax1.AbrirTabela(edArquivo.Text) then
    begin
      lVersao.Caption := 'Vers�o: ' + ACBrIBPTax1.VersaoArquivo;
      lbVigencia.Caption := 'Vig�ncia: ' + Format('%s a %s', [DateToStr(ACBrIBPTax1.VigenciaInicio), DateToStr(ACBrIBPTax1.VigenciaFim)]);
      lblChave.Caption := 'Chave: ' + ACBrIBPTax1.ChaveArquivo;
      lblFonte.Caption := 'Fonte: ' + ACBrIBPTax1.Fonte;

      tmpCadastro.Close;
      tmpCadastro.CreateDataSet;
      tmpCadastro.DisableControls;
      try
        for I := 0 to ACBrIBPTax1.Itens.Count - 1 do
        begin
          tmpCadastro.Append;
          tmpCadastroNCM.AsString             := ACBrIBPTax1.Itens[I].NCM;
          tmpCadastroDescricao.AsString       := ACBrIBPTax1.Itens[I].Descricao;
          tmpCadastroEx.AsString              := ACBrIBPTax1.Itens[I].Excecao;
          tmpCadastroTabela.AsInteger         := Integer(ACBrIBPTax1.Itens[I].Tabela);
          tmpCadastroAliqFedNacional.AsFloat  := ACBrIBPTax1.Itens[I].FederalNacional;
          tmpCadastroAliqFedImportado.AsFloat := ACBrIBPTax1.Itens[I].FederalImportado;
          tmpCadastroAliqEstadual.AsFloat     := ACBrIBPTax1.Itens[I].Estadual;
          tmpCadastroAliqMunicipal.AsFloat    := ACBrIBPTax1.Itens[I].Municipal;
          tmpCadastro.Post;
        end;
      finally
        tmpCadastro.First;
        tmpCadastro.EnableControls;

        Label4.Caption := 'Quantidade de itens: ' + IntToStr(tmpCadastro.RecordCount);
      end;
    end;
  finally
    Memo1.Lines.EndUpdate;
  end;
end;

procedure TForm1.btDownloadClick(Sender: TObject);
begin
  tmpCadastro.Close;
  ACBrIBPTax1.URLDownload := Trim(edURL.Text);

  if ACBrIBPTax1.DownloadTabela then
  begin
    MessageDlg('Download da tabela efetuado com sucesso.', mtInformation, [mbOK], 0);

    if MessageDlg('Deseja abrir a tabela e mostrar os dados?', mtInformation, [mbYes,mbNo], 0) = mrYes then
      btAbrir.Click;
  end
  else
    MessageDlg('N�o foi poss�vel efetuar o download da tabela.', mtError, [mbOK], 0);
end;

procedure TForm1.btExportarClick(Sender: TObject);
begin
  case rgTipoExportacao.ItemIndex of
    0:
      begin
        SaveDialog1.Title      := 'Exportar arquivo CSV';
        SaveDialog1.FileName   := 'IBPTax.csv';
        SaveDialog1.DefaultExt := '.csv';
        SaveDialog1.Filter     := 'Arquivos CSV|*.csv';

        if SaveDialog1.Execute then
          ACBrIBPTax1.Exportar(SaveDialog1.FileName, exCSV);
      end;

    1:
      begin
        SaveDialog1.Title      := 'Exportar arquivo DSV';
        SaveDialog1.FileName   := 'IBPTax.dsv';
        SaveDialog1.DefaultExt := '.dsv';
        SaveDialog1.Filter     := 'Arquivos DSV|*.dsv';

        if SaveDialog1.Execute then
          ACBrIBPTax1.Exportar(SaveDialog1.FileName, exDSV);
      end;

    2:
      begin
        SaveDialog1.Title      := 'Exportar arquivo XML';
        SaveDialog1.FileName   := 'IBPTax.xml';
        SaveDialog1.DefaultExt := '.xml';
        SaveDialog1.Filter     := 'Arquivos XML|*.xml';

        if SaveDialog1.Execute then
          ACBrIBPTax1.Exportar(SaveDialog1.FileName, exXML);
      end;

    3:
      begin
        SaveDialog1.Title      := 'Exportar arquivo HTML';
        SaveDialog1.FileName   := 'IBPTax.html';
        SaveDialog1.DefaultExt := '.html';
        SaveDialog1.Filter     := 'Arquivos HTML|*.html';

        if SaveDialog1.Execute then
          ACBrIBPTax1.Exportar(SaveDialog1.FileName, exHTML);
      end;

    4:
      begin
        SaveDialog1.Title      := 'Exportar arquivo TXT';
        SaveDialog1.FileName   := 'IBPTaxTexto.txt';
        SaveDialog1.DefaultExt := '.txt';
        SaveDialog1.Filter     := 'Arquivos TXT|*.txt';

        if SaveDialog1.Execute then
          ACBrIBPTax1.Exportar(SaveDialog1.FileName, exTXT);
      end;

    5:
      begin
        SaveDialog1.Title      := 'Exportar arquivo delimitado';
        SaveDialog1.FileName   := 'IBPTax.txt';
        SaveDialog1.DefaultExt := '.txt';
        SaveDialog1.Filter     := 'Arquivos TXT|*.txt';

        if SaveDialog1.Execute then
          ACBrIBPTax1.Exportar(SaveDialog1.FileName, '|', False);
      end;
  end;

  MessageDlg(
    Format('Tabela exportada com sucesso em "%s"'+ sLineBreak, [SaveDialog1.FileName]),
    mtInformation,
    [mbOK],
    0
  );
end;

procedure TForm1.btnPesquisarClick(Sender: TObject);
var
  ex, descricao: String;
  tabela: Integer;
  aliqFedNac, aliqFedImp, aliqEst, aliqMun: Double;
begin
  if ACBrIBPTax1.Procurar(edNCM.Text, ex, descricao, tabela, aliqFedNac, aliqFedImp, aliqEst, aliqMun, ckbBuscaNCMParcial.Checked) then
  begin
    ShowMessage(
      'C�digo: '    + edNCM.Text  + sLineBreak +
      'Exce��o: '   + ex + sLineBreak +
      'Descri��o: ' + descricao + sLineBreak +
      'Tabela: '    + IntToStr(tabela) + sLineBreak +
      'Aliq Federal Nacional: '  + FloatToStr(aliqFedNac) + sLineBreak +
      'Aliq Federal Importado: '  + FloatToStr(aliqFedImp) + sLineBreak +
      'Aliq Estadual: '  + FloatToStr(aliqEst) + sLineBreak +
      'Aliq Municipal: '  + FloatToStr(aliqMun)
    );
  end
  else
    showmessage('C�digo n�o encontrado!');
end;

procedure TForm1.btProxyClick(Sender: TObject);
var
  frProxyConfig: TfrProxyConfig;
begin
  frProxyConfig := TfrProxyConfig.Create(self);
  try
    frProxyConfig.edServidor.Text := ACBrIBPTax1.ProxyHost;
    frProxyConfig.edPorta.Text    := ACBrIBPTax1.ProxyPort;
    frProxyConfig.edUser.Text     := ACBrIBPTax1.ProxyUser;
    frProxyConfig.edSenha.Text    := ACBrIBPTax1.ProxyPass;

    if frProxyConfig.ShowModal = mrOK then
    begin
      ACBrIBPTax1.ProxyHost := frProxyConfig.edServidor.Text;
      ACBrIBPTax1.ProxyPort := frProxyConfig.edPorta.Text;
      ACBrIBPTax1.ProxyUser := frProxyConfig.edUser.Text;
      ACBrIBPTax1.ProxyPass := frProxyConfig.edSenha.Text;
    end;
  finally
    frProxyConfig.Free;
  end;
end;

procedure TForm1.btSairClick(Sender: TObject);
begin
  Close;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  PageControl1.ActivePageIndex := 0;
end;

procedure TForm1.sbArquivoClick(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    edArquivo.Text := OpenDialog1.FileName;
    btAbrir.Click;
  end;
end;

end.
