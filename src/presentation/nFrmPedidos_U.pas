unit nFrmPedidos_U;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Grids, Vcl.ComCtrls,
  System.Generics.Collections, nPedido_U, nPedidoItem_U, nCliente_U, Data.DB,
  Vcl.DBGrids, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, TypInfo;

type
  TnFrmPedidos = class(TForm)
    PanelTop: TPanel;
    LabelTitulo: TLabel;
    PanelFiltro: TPanel;
    LabelCliente: TLabel;
    ComboBoxCliente: TComboBox;
    LabelStatus: TLabel;
    ComboBoxStatus: TComboBox;
    LabelPeriodo: TLabel;
    DateTimePickerInicio: TDateTimePicker;
    LabelAte: TLabel;
    DateTimePickerFim: TDateTimePicker;
    LabelBusca: TLabel;
    EditFiltro: TEdit;
    PanelGrids: TPanel;
    PanelPedidos: TPanel;
    StringGridPedidos: TDBGrid;
    LabelPedidos: TLabel;
    Splitter1: TSplitter;
    PanelItens: TPanel;
    LabelItens: TLabel;
    StringGridItens: TDBGrid;
    PanelButtons: TPanel;
    ButtonNovo: TButton;
    ButtonEditar: TButton;
    ButtonExcluir: TButton;
    ButtonFaturar: TButton;
    ButtonExportar: TButton;
    ButtonFechar: TButton;
    DataSourceItens: TDataSource;
    DataSourcePedidos: TDataSource;
    MemTablePedidos: TFDMemTable;
    MemTableItens: TFDMemTable;
    ButtonFiltrar: TButton;

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ButtonFecharClick(Sender: TObject);
    procedure ButtonNovoClick(Sender: TObject);
    procedure ButtonEditarClick(Sender: TObject);
    procedure ButtonExcluirClick(Sender: TObject);
    procedure ButtonFaturarClick(Sender: TObject);
    procedure ButtonExportarClick(Sender: TObject);
    procedure StringGridPedidosClick(Sender: TObject);
    procedure ButtonFiltrarClick(Sender: TObject);
    procedure DataSourcePedidosDataChange(Sender: TObject; Field: TField);
  private
    FPedidosFiltrados: TObjectList<TnPedido>;
    procedure CarregarClientes;
    procedure CarregarPedidos;
    procedure PreencherGridPedidos(const _APedidos: TObjectList<TnPedido>);
    procedure PreencherGridItens(const _APedido: TnPedido);
    function ObterPedidoSelecionado: TnPedido;
  public
    { Public declarations }
  end;

var
  nFrmPedidos: TnFrmPedidos;

implementation

{$R *.dfm}

uses
  nRepositorioMem_U, Vcl.FileCtrl, System.DateUtils, nProduto_U,
  nFrmPedidoCadastro_U, nExportador_U;

{ TnFrmPedidos }

procedure TnFrmPedidos.FormCreate(Sender: TObject);
begin
  FPedidosFiltrados := TObjectList<TnPedido>.Create(False);

  DateTimePickerInicio.Date := IncMonth(Now, -3);
  DateTimePickerFim.Date := Now;

  CarregarClientes;
  CarregarPedidos;
end;

procedure TnFrmPedidos.FormDestroy(Sender: TObject);
begin
  FPedidosFiltrados.Free;
end;

procedure TnFrmPedidos.CarregarClientes;
var
  ARepositorio: TnRepositorioMem;
  AClientes: TObjectList<TnCliente>;
  ACliente: TnCliente;
begin
  ComboBoxCliente.Items.Clear;
  ComboBoxCliente.Items.Add('Todos');

  ARepositorio := TnRepositorioMem.Instancia;
  AClientes := ARepositorio.ListarClientes;

  for ACliente in AClientes do
    ComboBoxCliente.Items.AddObject(
      ACliente.Nome,
      TObject(ACliente.CodigoCliente)
    );

  ComboBoxCliente.ItemIndex := 0;
end;

procedure TnFrmPedidos.CarregarPedidos;
var
  ARepositorio: TnRepositorioMem;
  ATodosPedidos: TObjectList<TnPedido>;
  APedido: TnPedido;
  ATextoFiltro, AStatusFiltro: string;
  ACodigoClienteFiltro: Integer;
  ACliente: TnCliente;
begin
  FPedidosFiltrados.Clear;

  ARepositorio := TnRepositorioMem.Instancia;
  ATodosPedidos := ARepositorio.ListarPedidos;

  ATextoFiltro := Trim(UpperCase(EditFiltro.Text));
  AStatusFiltro := UpperCase(ComboBoxStatus.Text);

  if (ComboBoxCliente.ItemIndex > 0) then
    ACodigoClienteFiltro := Integer(
      ComboBoxCliente.Items.Objects[ComboBoxCliente.ItemIndex]
    )
  else
    ACodigoClienteFiltro := 0;

  for APedido in ATodosPedidos do
  begin
    //período
    if (APedido.DataEmissao < DateTimePickerInicio.Date) or
       (APedido.DataEmissao > DateTimePickerFim.Date) then
      Continue;

    //cliente
    if (ACodigoClienteFiltro > 0) and
       (APedido.CodigoCliente <> ACodigoClienteFiltro) then
      Continue;

    //status
    if AStatusFiltro <> 'TODOS' then
    begin
      case APedido.Status of
        spAberto:
          if AStatusFiltro <> 'ABERTO' then Continue;
        spFaturado:
          if AStatusFiltro <> 'FATURADO' then Continue;
        spCancelado:
          if AStatusFiltro <> 'CANCELADO' then Continue;
      end;
    end;

    //texto livre
    if ATextoFiltro <> '' then
    begin
      ACliente := ARepositorio.ObterCliente(APedido.CodigoCliente);
      if not (
        (Pos(ATextoFiltro, UpperCase(APedido.Numero)) > 0) or
        (Assigned(ACliente) and
         (Pos(ATextoFiltro, UpperCase(ACliente.Nome)) > 0))
      ) then
        Continue;
    end;

    FPedidosFiltrados.Add(APedido);
  end;

  PreencherGridPedidos(FPedidosFiltrados);
end;

procedure TnFrmPedidos.DataSourcePedidosDataChange(Sender: TObject;
  Field: TField);
var
  APedido: TnPedido;
begin
  APedido := ObterPedidoSelecionado;
  PreencherGridItens(APedido);
end;

procedure TnFrmPedidos.PreencherGridPedidos(const _APedidos: TObjectList<TnPedido>);
var
  APedido: TnPedido;
  ARepositorio: TnRepositorioMem;
  ACliente: TnCliente;
  AStatus: string;
begin
  MemTablePedidos.DisableControls;
  try
    MemTablePedidos.Close;
    MemTablePedidos.FieldDefs.Clear;
    MemTablePedidos.FieldDefs.Add('CodigoPedido', ftInteger);
    MemTablePedidos.FieldDefs.Add('Numero', ftString, 20);
    MemTablePedidos.FieldDefs.Add('NomeCliente', ftString, 100);
    MemTablePedidos.FieldDefs.Add('DataEmissao', ftDate);
    MemTablePedidos.FieldDefs.Add('ValorTotal', ftCurrency);
    MemTablePedidos.FieldDefs.Add('Status', ftString, 20);
    MemTablePedidos.CreateDataSet;

    if _APedidos.Count = 0 then
      Exit;

    ARepositorio := TnRepositorioMem.Instancia;

    for APedido in _APedidos do
    begin
      MemTablePedidos.Append;

      MemTablePedidos.FieldByName('CodigoPedido').AsInteger :=
        APedido.CodigoPedido;
      MemTablePedidos.FieldByName('Numero').AsString := APedido.Numero;

      ACliente := ARepositorio.ObterCliente(APedido.CodigoCliente);
      if Assigned(ACliente) then
        MemTablePedidos.FieldByName('NomeCliente').AsString := ACliente.Nome
      else
        MemTablePedidos.FieldByName('NomeCliente').AsString := '(Desconhecido)';

      MemTablePedidos.FieldByName('DataEmissao').AsDateTime :=
        APedido.DataEmissao;
      MemTablePedidos.FieldByName('ValorTotal').AsCurrency :=
        APedido.ValorTotal;

      case APedido.Status of
        spAberto: AStatus := 'ABERTO';
        spFaturado: AStatus := 'FATURADO';
        spCancelado: AStatus := 'CANCELADO';
      else
        AStatus := 'DESCONHECIDO';
      end;
      MemTablePedidos.FieldByName('Status').AsString := AStatus;

      MemTablePedidos.Post;
    end;

    MemTablePedidos.First;

  finally
    MemTablePedidos.EnableControls;
  end;
end;

procedure TnFrmPedidos.PreencherGridItens(const _APedido: TnPedido);
var
  AItem: TnPedidoItem;
  ARepositorio: TnRepositorioMem;
  AProduto: TnProduto;
begin
  MemTableItens.DisableControls;
  try
    MemTableItens.Close;
    MemTableItens.FieldDefs.Clear;
    MemTableItens.FieldDefs.Add('CodigoProduto', ftInteger);
    MemTableItens.FieldDefs.Add('Descricao', ftString, 100);
    MemTableItens.FieldDefs.Add('Quantidade', ftFloat);
    MemTableItens.FieldDefs.Add('PrecoUnit', ftCurrency);
    MemTableItens.FieldDefs.Add('Total', ftCurrency);
    MemTableItens.CreateDataSet;

    if not Assigned(_APedido) then
      Exit;

    if _APedido.Itens.Count = 0 then
      Exit;

    ARepositorio := TnRepositorioMem.Instancia;

    for AItem in _APedido.Itens do
    begin
      MemTableItens.Append;

      MemTableItens.FieldByName('CodigoProduto').AsInteger :=
        AItem.CodigoProduto;

      AProduto := ARepositorio.ObterProduto(AItem.CodigoProduto);
      if Assigned(AProduto) then
        MemTableItens.FieldByName('Descricao').AsString := AProduto.Descricao
      else
        MemTableItens.FieldByName('Descricao').AsString :=
          '(Produto não encontrado)';

      MemTableItens.FieldByName('Quantidade').AsFloat := AItem.Qtde;
      MemTableItens.FieldByName('PrecoUnit').AsCurrency := AItem.PrecoUnit;
      MemTableItens.FieldByName('Total').AsCurrency := AItem.Total;

      MemTableItens.Post;
    end;

    MemTableItens.First;

  finally
    MemTableItens.EnableControls;
  end;
end;

function TnFrmPedidos.ObterPedidoSelecionado: TnPedido;
var
  ACodigoPedido: Integer;
  ARepositorio: TnRepositorioMem;
begin
  Result := nil;

  if MemTablePedidos.IsEmpty then
    Exit;

  ACodigoPedido := MemTablePedidos.FieldByName('CodigoPedido').AsInteger;

  if ACodigoPedido <= 0 then
    Exit;

  ARepositorio := TnRepositorioMem.Instancia;
  Result := ARepositorio.ObterPedido(ACodigoPedido);
end;

procedure TnFrmPedidos.StringGridPedidosClick(Sender: TObject);
var
  APedido: TnPedido;
begin
  APedido := ObterPedidoSelecionado;

  if Assigned(APedido) then
    PreencherGridItens(APedido)
  else
    PreencherGridItens(nil);
end;

procedure TnFrmPedidos.ButtonNovoClick(Sender: TObject);
var
  APedido: TnPedido;
  AForm: TnFrmPedidoCadastro;
  ACodigoSalvo: Integer;
begin
  APedido := TnPedido.Create;
  AForm := TnFrmPedidoCadastro.Create(Self);
  try
    AForm.SetPedido(APedido);

    if AForm.ShowModal = mrOk then
    begin
      ACodigoSalvo := APedido.CodigoPedido;
      CarregarPedidos;

      if ACodigoSalvo > 0 then
        MemTablePedidos.Locate('CodigoPedido', ACodigoSalvo, []);
    end
    else
    begin
      APedido.Free;
    end;
  finally
    AForm.Free;
  end;
end;

procedure TnFrmPedidos.ButtonEditarClick(Sender: TObject);
var
  APedido: TnPedido;
  AForm: TnFrmPedidoCadastro;
  ACodigoPedido: Integer;
begin
  APedido := ObterPedidoSelecionado;

  if not Assigned(APedido) then
  begin
    ShowMessage('Selecione um pedido para editar.');
    Exit;
  end;

  if not APedido.PodeEditar then
  begin
    ShowMessage('Este pedido não pode ser editado (já foi faturado ou cancelado).');
    Exit;
  end;

  ACodigoPedido := APedido.CodigoPedido;

  AForm := TnFrmPedidoCadastro.Create(Self);
  try
    AForm.SetPedido(APedido);

    if AForm.ShowModal = mrOk then
    begin
      CarregarPedidos;

      if ACodigoPedido > 0 then
        MemTablePedidos.Locate('CodigoPedido', ACodigoPedido, []);
    end;
  finally
    AForm.Free;
  end;
end;

procedure TnFrmPedidos.ButtonExcluirClick(Sender: TObject);
var
  APedido: TnPedido;
  ARepositorio: TnRepositorioMem;
begin
  APedido := ObterPedidoSelecionado;

  if not Assigned(APedido) then
  begin
    ShowMessage('Selecione um pedido para excluir.');
    Exit;
  end;

  if APedido.Status = spFaturado then
  begin
    ShowMessage('Não é possível excluir pedido faturado.');
    Exit;
  end;

  if MessageDlg('Deseja realmente excluir o pedido ' + APedido.Numero + '?',
    mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    ARepositorio := TnRepositorioMem.Instancia;
    ARepositorio.ExcluirPedido(APedido.CodigoPedido);
    CarregarPedidos;
    ShowMessage('Pedido excluído com sucesso!');
  end;
end;

procedure TnFrmPedidos.ButtonFaturarClick(Sender: TObject);
var
  APedido: TnPedido;
begin
  APedido := ObterPedidoSelecionado;

  if not Assigned(APedido) then
  begin
    ShowMessage('Selecione um pedido para faturar.');
    Exit;
  end;

  if not APedido.PodeFaturar then
  begin
    if APedido.Status <> spAberto then
      ShowMessage('Apenas pedidos com status ABERTO podem ser faturados.')
    else if APedido.Itens.Count = 0 then
      ShowMessage('Pedido sem itens não pode ser faturado.')
    else
      ShowMessage('Pedido não pode ser faturado.');
    Exit;
  end;

  if MessageDlg('Deseja faturar o pedido ' + APedido.Numero + '?' + sLineBreak +
    'Valor Total: R$ ' + FormatFloat('#,##0.00', APedido.ValorTotal) + sLineBreak +
    'Após faturado, o pedido não poderá mais ser editado.', mtConfirmation, [mbYes, mbNo],0) = mrYes then
  begin
    try
      APedido.Faturar;
      CarregarPedidos;
      ShowMessage('Pedido faturado com sucesso!');
    except
      on E: Exception do
        ShowMessage('Erro ao faturar pedido: ' + E.Message);
    end;

  end;

end;

procedure TnFrmPedidos.ButtonExportarClick(Sender: TObject);
var
  AExportador: TnExportador;
  ASaveDialog: TSaveDialog;
  AFormato: TnFormatoExportacao;
begin
  if FPedidosFiltrados.Count = 0 then
  begin
    ShowMessage('Não há pedidos para exportar.');
    Exit;
  end;

  ASaveDialog := TSaveDialog.Create(nil);
  try
    ASaveDialog.Filter :=
      'Arquivo CSV (*.csv)|*.csv|Arquivo JSON (*.json)|*.json';
    ASaveDialog.DefaultExt := 'csv';
    ASaveDialog.FileName :=
      'Pedidos_' + FormatDateTime('yyyymmdd_hhnnss', Now);

    if ASaveDialog.Execute then
    begin
      if ASaveDialog.FilterIndex = 1 then
        AFormato := feCSV
      else
        AFormato := feJSON;

      AExportador := TnExportador.Create;
      try
        AExportador.SalvarArquivo(FPedidosFiltrados, ASaveDialog.FileName, AFormato);
        ShowMessage('Exportação realizada com sucesso!' + sLineBreak + 'Arquivo: ' + ASaveDialog.FileName);
      finally
        AExportador.Free;
      end;
    end;
  finally
    ASaveDialog.Free;
  end;
end;

procedure TnFrmPedidos.ButtonFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TnFrmPedidos.ButtonFiltrarClick(Sender: TObject);
begin
  CarregarPedidos;
end;

end.
