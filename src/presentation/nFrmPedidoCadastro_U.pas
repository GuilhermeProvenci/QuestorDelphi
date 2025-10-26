unit nFrmPedidoCadastro_U;

interface

uses
  Winapi.Windows, Winapi.Messages, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Grids, Data.DB, FireDAC.Comp.Client,
  FireDAC.Comp.DataSet, Vcl.DBGrids, System.Generics.Collections,
  nPedido_U, nPedidoItem_U, nProduto_U, nCliente_U, Vcl.ComCtrls,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf;

type
  TnFrmPedidoCadastro = class(TForm)
    PanelTop: TPanel;
    LabelTitulo: TLabel;
    PanelDados: TPanel;
    LabelNumero: TLabel;
    EditNumero: TEdit;
    LabelCliente: TLabel;
    ComboBoxCliente: TComboBox;
    LabelDataEmissao: TLabel;
    DateTimePickerEmissao: TDateTimePicker;
    LabelStatus: TLabel;
    ComboBoxStatus: TComboBox;
    PanelItens: TPanel;
    GridItens: TDBGrid;
    PanelBotoesItens: TPanel;
    ButtonAdicionarItem: TButton;
    ButtonRemoverItem: TButton;
    LabelTotal: TLabel;
    PanelBottom: TPanel;
    ButtonSalvar: TButton;
    ButtonCancelar: TButton;
    MemTableItens: TFDMemTable;
    DataSourceItens: TDataSource;

    procedure FormCreate(Sender: TObject);
    procedure ButtonAdicionarItemClick(Sender: TObject);
    procedure ButtonRemoverItemClick(Sender: TObject);
    procedure ButtonSalvarClick(Sender: TObject);
    procedure ButtonCancelarClick(Sender: TObject);
  private
    FPedido: TnPedido;
    FNovo: Boolean;

    procedure ConfigurarMemTable;
    procedure CarregarClientes;
    procedure CarregarDados;
    procedure CarregarItens;
    procedure AtualizarTotal;
    procedure SalvarDados;
    function ValidarDados: Boolean;
    procedure HabilitarControles;
  public
    procedure SetPedido(const _APedido: TnPedido);
  end;

implementation

{$R *.dfm}

uses
  nRepositorioMem_U, System.SysUtils;

{ TnFrmPedidoCadastro }

procedure TnFrmPedidoCadastro.FormCreate(Sender: TObject);
begin
  FPedido := nil;
  FNovo := False;

  ConfigurarMemTable;
  CarregarClientes;

  ComboBoxStatus.Enabled := False;
end;

procedure TnFrmPedidoCadastro.ConfigurarMemTable;
begin

  if not MemTableItens.Active then
  begin
    MemTableItens.Close;
    MemTableItens.FieldDefs.Clear;
    MemTableItens.FieldDefs.Add('CodigoProduto', ftInteger);
    MemTableItens.FieldDefs.Add('Descricao', ftString, 100);
    MemTableItens.FieldDefs.Add('Qtde', ftFloat);
    MemTableItens.FieldDefs.Add('PrecoUnit', ftCurrency);
    MemTableItens.FieldDefs.Add('Total', ftCurrency);
    MemTableItens.CreateDataSet;
  end;
end;

procedure TnFrmPedidoCadastro.CarregarClientes;
var
  ARepositorio: TnRepositorioMem;
  AClientes: TObjectList<TnCliente>;
  ACliente: TnCliente;
begin
  ComboBoxCliente.Items.Clear;

  ARepositorio := TnRepositorioMem.Instancia;
  AClientes := ARepositorio.ListarClientes;

  for ACliente in AClientes do
  begin
    if ACliente.Ativo then
      ComboBoxCliente.Items.AddObject(ACliente.Nome, TObject(ACliente.CodigoCliente));
  end;

  if ComboBoxCliente.Items.Count > 0 then
    ComboBoxCliente.ItemIndex := 0;
end;

procedure TnFrmPedidoCadastro.SetPedido(const _APedido: TnPedido);
begin
  FPedido := _APedido;
  FNovo := (FPedido.CodigoPedido = 0);

  if FNovo then
    LabelTitulo.Caption := 'Novo Pedido'
  else
    LabelTitulo.Caption := 'Editar Pedido';

  CarregarDados;
  HabilitarControles;
end;

procedure TnFrmPedidoCadastro.CarregarDados;
var
  ARepositorio: TnRepositorioMem;
  ACliente: TnCliente;
  I: Integer;
begin
  if not Assigned(FPedido) then
    Exit;

  EditNumero.Text := FPedido.Numero;
  DateTimePickerEmissao.Date := FPedido.DataEmissao;

  ComboBoxStatus.ItemIndex := Ord(FPedido.Status);

  ARepositorio := TnRepositorioMem.Instancia;

  if FPedido.CodigoCliente > 0 then
  begin
    ACliente := ARepositorio.ObterCliente(FPedido.CodigoCliente);
    if Assigned(ACliente) then
    begin
      for I := 0 to ComboBoxCliente.Items.Count - 1 do
      begin
        if Integer(ComboBoxCliente.Items.Objects[I]) = ACliente.CodigoCliente then
        begin
          ComboBoxCliente.ItemIndex := I;
          Break;
        end;
      end;
    end;
  end;

  CarregarItens;
  AtualizarTotal;
end;

procedure TnFrmPedidoCadastro.CarregarItens;
var
  AItem: TnPedidoItem;
  ARepositorio: TnRepositorioMem;
  AProduto: TnProduto;
begin
  MemTableItens.DisableControls;
  try
    MemTableItens.EmptyDataSet;

    if not Assigned(FPedido) then
      Exit;

    ARepositorio := TnRepositorioMem.Instancia;

    for AItem in FPedido.Itens do
    begin
      AProduto := ARepositorio.ObterProduto(AItem.CodigoProduto);

      MemTableItens.Append;
      MemTableItens.FieldByName('CodigoProduto').AsInteger :=
        AItem.CodigoProduto;

      if Assigned(AProduto) then
        MemTableItens.FieldByName('Descricao').AsString := AProduto.Descricao
      else
        MemTableItens.FieldByName('Descricao').AsString := '(Produto não encontrado)';

      MemTableItens.FieldByName('Qtde').AsFloat := AItem.Qtde;
      MemTableItens.FieldByName('PrecoUnit').AsCurrency := AItem.PrecoUnit;
      MemTableItens.FieldByName('Total').AsCurrency := AItem.Total;
      MemTableItens.Post;
    end;

    MemTableItens.First;
  finally
    MemTableItens.EnableControls;
  end;
end;

procedure TnFrmPedidoCadastro.HabilitarControles;
var
  APodeEditar: Boolean;
begin
  if not Assigned(FPedido) then
    Exit;

  APodeEditar := FPedido.PodeEditar;

  EditNumero.Enabled := APodeEditar;
  ComboBoxCliente.Enabled := APodeEditar;
  DateTimePickerEmissao.Enabled := APodeEditar;
  ButtonAdicionarItem.Enabled := APodeEditar;
  ButtonRemoverItem.Enabled := APodeEditar;
  ButtonSalvar.Enabled := APodeEditar;

  if not APodeEditar then
    ShowMessage('Este pedido não pode ser editado (já foi faturado ou cancelado).');
end;

procedure TnFrmPedidoCadastro.ButtonAdicionarItemClick(Sender: TObject);
var
  ARepositorio: TnRepositorioMem;
  AProdutos: TObjectList<TnProduto>;
  AProduto: TnProduto;
  AItem: TnPedidoItem;
  AEscolha: string;
  ACodigoProduto: Integer;
  AQuantidade: Double;
begin
  if not FPedido.PodeEditar then
  begin
    ShowMessage('Pedido não pode ser editado.');
    Exit;
  end;

  ARepositorio := TnRepositorioMem.Instancia;
  AProdutos := ARepositorio.ListarProdutos;

  if AProdutos.Count = 0 then
  begin
    ShowMessage('Não há produtos cadastrados.');
    Exit;
  end;

  //código do produto
  AEscolha := InputBox('Adicionar Item','Informe o código do produto:','');

  if Trim(AEscolha) = '' then
    Exit;

  if not TryStrToInt(AEscolha, ACodigoProduto) then
  begin
    ShowMessage('Código inválido.');
    Exit;
  end;

  AProduto := ARepositorio.ObterProduto(ACodigoProduto);

  if not Assigned(AProduto) then
  begin
    ShowMessage('Produto não encontrado.');
    Exit;
  end;

  if not AProduto.Ativo then
  begin
    ShowMessage('Produto inativo não pode ser adicionado.');
    Exit;
  end;

  //quantidade
  AEscolha := InputBox('Quantidade','Informe a quantidade:','1');

  if Trim(AEscolha) = '' then
    Exit;

  AQuantidade := StrToFloatDef(StringReplace(AEscolha, '.', '', [rfReplaceAll]),0);

  if AQuantidade <= 0 then
    AQuantidade := StrToFloatDef(AEscolha, 1);

  if AQuantidade <= 0 then
  begin
    ShowMessage('Quantidade inválida.');
    Exit;
  end;

  AItem := TnPedidoItem.Create;
  AItem.CodigoProduto := AProduto.CodigoProduto;
  AItem.Qtde := AQuantidade;
  AItem.PrecoUnit := AProduto.PrecoUnit;

  try
    FPedido.AdicionarItem(AItem);
    CarregarItens;
    AtualizarTotal;

    ShowMessage(
      'Item adicionado!' + sLineBreak +
      'Produto: ' + AProduto.Descricao + sLineBreak +
      'Quantidade: ' + FormatFloat('0.##', AQuantidade) + sLineBreak +
      'Valor: R$ ' + FormatFloat('#,##0.00', AItem.Total)
    );
  except
    on E: Exception do
    begin
      AItem.Free;
      ShowMessage('Erro ao adicionar item: ' + E.Message);
    end;
  end;
end;

procedure TnFrmPedidoCadastro.ButtonRemoverItemClick(Sender: TObject);
var
  AIndice: Integer;
begin
  if not FPedido.PodeEditar then
  begin
    ShowMessage('Pedido não pode ser editado.');
    Exit;
  end;

  if MemTableItens.IsEmpty then
  begin
    ShowMessage('Não há itens para remover.');
    Exit;
  end;

  if MessageDlg('Deseja remover o item selecionado?',mtConfirmation,[mbYes, mbNo],0) = mrYes then
  begin
    try
      AIndice := MemTableItens.RecNo - 1;

      if (AIndice >= 0) and (AIndice < FPedido.Itens.Count) then
      begin
        FPedido.RemoverItem(AIndice);
        CarregarItens;
        AtualizarTotal;
        ShowMessage('Item removido com sucesso!');
      end;
    except
      on E: Exception do
        ShowMessage('Erro ao remover item: ' + E.Message);
    end;
  end;
end;

procedure TnFrmPedidoCadastro.AtualizarTotal;
begin
  if Assigned(FPedido) then
    LabelTotal.Caption := 'Total: R$ ' + FormatFloat('#,##0.00', FPedido.ValorTotal)
  else
    LabelTotal.Caption := 'Total: R$ 0,00';
end;

function TnFrmPedidoCadastro.ValidarDados: Boolean;
begin
  Result := False;

  if Trim(EditNumero.Text) = '' then
  begin
    ShowMessage('Número do pedido é obrigatório.');
    EditNumero.SetFocus;
    Exit;
  end;

  if ComboBoxCliente.ItemIndex < 0 then
  begin
    ShowMessage('Selecione um cliente.');
    ComboBoxCliente.SetFocus;
    Exit;
  end;

  if FPedido.Itens.Count = 0 then
  begin
    ShowMessage('O pedido deve ter ao menos um item.');
    ButtonAdicionarItem.SetFocus;
    Exit;
  end;

  Result := True;
end;

procedure TnFrmPedidoCadastro.SalvarDados;
var
  ARepositorio: TnRepositorioMem;
begin
  FPedido.Numero := Trim(EditNumero.Text);
  FPedido.DataEmissao := DateTimePickerEmissao.Date;
  FPedido.CodigoCliente := Integer(ComboBoxCliente.Items.Objects[ComboBoxCliente.ItemIndex]);

  if FNovo then
    FPedido.Status := spAberto;

  ARepositorio := TnRepositorioMem.Instancia;
  ARepositorio.SalvarPedido(FPedido);
end;

procedure TnFrmPedidoCadastro.ButtonSalvarClick(Sender: TObject);
begin
  if not ValidarDados then
    Exit;

  try
    SalvarDados;
    ShowMessage('Pedido salvo com sucesso!');
    ModalResult := mrOk;
  except
    on E: Exception do
      ShowMessage('Erro ao salvar pedido: ' + E.Message);
  end;
end;

procedure TnFrmPedidoCadastro.ButtonCancelarClick(Sender: TObject);
begin
  if FPedido.Itens.Count > 0 then
  begin
    if MessageDlg('Deseja realmente cancelar?' + sLineBreak+ 'As alterações não salvas serão perdidas.',
                   mtConfirmation,[mbYes, mbNo],0) = mrNo then
      Exit;
  end;

  ModalResult := mrCancel;
end;

end.
