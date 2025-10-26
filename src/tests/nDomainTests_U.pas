unit nDomainTests_U;

interface

uses
  DUnitX.TestFramework,
  nPedido_U,
  nPedidoItem_U,
  nCliente_U,
  nProduto_U;

type
  [TestFixture]
  TnClienteTests = class
  private
    FCliente: TnCliente;
  public
    [Setup]
    procedure Setup;

    [TearDown]
    procedure TearDown;

    [Test]
    procedure TestClienteValidoComCPF;

    [Test]
    procedure TestClienteValidoComCNPJ;

    [Test]
    procedure TestClienteSemNomeInvalido;

    [Test]
    procedure TestClienteSemCpfCnpjInvalido;

    [Test]
    procedure TestClienteComCpfCnpjTamanhoInvalido;
  end;

  [TestFixture]
  TnProdutoTests = class
  private
    FProduto: TnProduto;
  public
    [Setup]
    procedure Setup;

    [TearDown]
    procedure TearDown;

    [Test]
    procedure TestProdutoValido;

    [Test]
    procedure TestProdutoSemDescricaoInvalido;

    [Test]
    procedure TestProdutoComPrecoZeroInvalido;

    [Test]
    procedure TestProdutoComPrecoNegativoInvalido;
  end;

  [TestFixture]
  TnPedidoItemTests = class
  private
    FItem: TnPedidoItem;
  public
    [Setup]
    procedure Setup;

    [TearDown]
    procedure TearDown;

    [Test]
    procedure TestItemValido;

    [Test]
    procedure TestCalculoTotal;

    [Test]
    procedure TestItemComQuantidadeZeroInvalido;

    [Test]
    procedure TestItemComPrecoZeroInvalido;

    [Test]
    procedure TestItemSemProdutoInvalido;
  end;


  //regras de negocio dos pedidos
  [TestFixture]
  TnPedidoTests = class
  private
    FPedido: TnPedido;

    function CriarItemValido(const _ACodigoProduto: Integer; const _AQtde: Double; const _APreco: Double): TnPedidoItem;
  public
    [Setup]
    procedure Setup;

    [TearDown]
    procedure TearDown;

    [Test]
    [TestCase('Pedido sem itens', '0')]
    procedure TestNaoPodeSalvarPedidoSemItens(const _AQtdeItens: Integer);

    [Test]
    procedure TestCalculoValorTotal;

    [Test]
    procedure TestCalculoValorTotalComMultiplosItens;

    [Test]
    procedure TestNaoPodeEditarPedidoFaturado;

    [Test]
    procedure TestPodeFaturarPedidoAberto;

    [Test]
    procedure TestNaoPodeFaturarPedidoSemItens;

    [Test]
    procedure TestNaoPodeFaturarPedidoJaFaturado;

    [Test]
    procedure TestAdicionarItemEmPedidoAberto;

    [Test]
    procedure TestNaoPodeAdicionarItemEmPedidoFaturado;

    [Test]
    procedure TestRemoverItemEmPedidoAberto;

    [Test]
    procedure TestNaoPodeRemoverItemEmPedidoFaturado;

    [Test]
    procedure TestPedidoIniciaComoAberto;

    [Test]
    procedure TestValidacaoClienteObrigatorio;

    [Test]
    procedure TestValidacaoNumeroObrigatorio;
  end;

implementation

uses
  System.SysUtils;

{ TnClienteTests }

procedure TnClienteTests.Setup;
begin
  FCliente := TnCliente.Create;
end;

procedure TnClienteTests.TearDown;
begin
  FCliente.Free;
end;

procedure TnClienteTests.TestClienteValidoComCPF;
begin
  FCliente.Nome := 'cliente exemplo CPF';
  FCliente.CpfCnpj := '12312312312'; //11
  FCliente.Ativo := True;

  Assert.IsTrue(FCliente.Validar, 'Cliente com CPF válido deveria ser aceito');
end;

procedure TnClienteTests.TestClienteValidoComCNPJ;
begin
  FCliente.Nome := 'cliente exemplo CNPJ';
  FCliente.CpfCnpj := '12312312312312'; //14
  FCliente.Ativo := True;

  Assert.IsTrue(FCliente.Validar, 'Cliente com CNPJ válido deveria ser aceito');
end;

procedure TnClienteTests.TestClienteSemNomeInvalido;
begin
  FCliente.Nome := '';
  FCliente.CpfCnpj := '12312312312';

  Assert.IsFalse(FCliente.Validar, 'Cliente sem nome não deveria ser válido');
  Assert.Contains(FCliente.ObterErros, 'Nome', True);
end;

procedure TnClienteTests.TestClienteSemCpfCnpjInvalido;
begin
  FCliente.Nome := 'cliente exemplo';
  FCliente.CpfCnpj := '';

  Assert.IsFalse(FCliente.Validar, 'Cliente sem CPF/CNPJ não deveria ser válido');
  Assert.Contains(FCliente.ObterErros, 'CPF/CNPJ', True);
end;

procedure TnClienteTests.TestClienteComCpfCnpjTamanhoInvalido;
begin
  FCliente.Nome := 'cliente exemplo';
  FCliente.CpfCnpj := '123132'; //menor que 11

  Assert.IsFalse(FCliente.Validar, 'Cliente com CPF/CNPJ de tamanho inválido');
end;

{ TnProdutoTests }

procedure TnProdutoTests.Setup;
begin
  FProduto := TnProduto.Create;
end;

procedure TnProdutoTests.TearDown;
begin
  FProduto.Free;
end;

procedure TnProdutoTests.TestProdutoValido;
begin
  FProduto.Descricao := 'Produto 1';
  FProduto.PrecoUnit := 1000.00;
  FProduto.Ativo := True;

  Assert.IsTrue(FProduto.Validar, 'Produto válido deveria ser aceito');
end;

procedure TnProdutoTests.TestProdutoSemDescricaoInvalido;
begin
  FProduto.Descricao := '';
  FProduto.PrecoUnit := 1000.00;

  Assert.IsFalse(FProduto.Validar, 'Produto sem descrição não deveria ser válido');
  Assert.Contains(FProduto.ObterErros, 'Descrição', True);
end;

procedure TnProdutoTests.TestProdutoComPrecoZeroInvalido;
begin
  FProduto.Descricao := 'Produto Teste';
  FProduto.PrecoUnit := 0;

  Assert.IsFalse(FProduto.Validar, 'Produto com preço zero não deveria ser válido');
  Assert.Contains(FProduto.ObterErros, 'Preço', True);
end;

procedure TnProdutoTests.TestProdutoComPrecoNegativoInvalido;
begin
  FProduto.Descricao := 'Produto Teste';
  FProduto.PrecoUnit := -10.00;

  Assert.IsFalse(FProduto.Validar, 'Produto com preço negativo não deveria ser válido');
end;

{ TnPedidoItemTests }

procedure TnPedidoItemTests.Setup;
begin
  FItem := TnPedidoItem.Create;
end;

procedure TnPedidoItemTests.TearDown;
begin
  FItem.Free;
end;

procedure TnPedidoItemTests.TestItemValido;
begin
  FItem.CodigoProduto := 1;
  FItem.Qtde := 2;
  FItem.PrecoUnit := 50.00;

  Assert.IsTrue(FItem.Validar, 'Item válido deveria ser aceito');
end;

procedure TnPedidoItemTests.TestCalculoTotal;
begin
  FItem.CodigoProduto := 1;
  FItem.Qtde := 3;
  FItem.PrecoUnit := 10.50;

  Assert.AreEqual(31.50, FItem.Total, 0.01,
    'Total deveria ser Qtde * PrecoUnit = 31.50');
end;

procedure TnPedidoItemTests.TestItemComQuantidadeZeroInvalido;
begin
  FItem.CodigoProduto := 1;
  FItem.Qtde := 0;
  FItem.PrecoUnit := 10.00;

  Assert.IsFalse(FItem.Validar,
    'Item com quantidade zero não deveria ser válido');
  Assert.Contains(FItem.ObterErros, 'Quantidade', True);
end;

procedure TnPedidoItemTests.TestItemComPrecoZeroInvalido;
begin
  FItem.CodigoProduto := 1;
  FItem.Qtde := 1;
  FItem.PrecoUnit := 0;

  Assert.IsFalse(FItem.Validar,
    'Item com preço zero não deveria ser válido');
  Assert.Contains(FItem.ObterErros, 'Preço', True);
end;

procedure TnPedidoItemTests.TestItemSemProdutoInvalido;
begin
  FItem.CodigoProduto := 0;
  FItem.Qtde := 1;
  FItem.PrecoUnit := 10.00;

  Assert.IsFalse(FItem.Validar,
    'Item sem produto não deveria ser válido');
  Assert.Contains(FItem.ObterErros, 'Produto', True);
end;

{ TnPedidoTests }

procedure TnPedidoTests.Setup;
begin
  FPedido := TnPedido.Create;
  FPedido.Numero := 'PEDIDO-001';
  FPedido.CodigoCliente := 1;
  FPedido.DataEmissao := EncodeDate(2025, 10, 20);
end;

procedure TnPedidoTests.TearDown;
begin
  FPedido.Free;
end;

function TnPedidoTests.CriarItemValido(const _ACodigoProduto: Integer; const _AQtde: Double; const _APreco: Double): TnPedidoItem;
begin
  Result := TnPedidoItem.Create;
  Result.CodigoProduto := _ACodigoProduto;
  Result.Qtde := _AQtde;
  Result.PrecoUnit := _APreco;
end;

procedure TnPedidoTests.TestNaoPodeSalvarPedidoSemItens(const _AQtdeItens: Integer);
begin
  Assert.IsFalse(FPedido.Validar, 'Pedido sem itens não deveria ser válido');
  Assert.Contains(FPedido.ObterErros, 'item', True);
end;

procedure TnPedidoTests.TestCalculoValorTotal;
var
  AItem: TnPedidoItem;
begin
  AItem := CriarItemValido(1, 2, 10.50);
  FPedido.AdicionarItem(AItem);

  Assert.AreEqual(21.00, FPedido.ValorTotal, 0.01, 'Valor total deveria ser 21.00');
end;

procedure TnPedidoTests.TestCalculoValorTotalComMultiplosItens;
var
  AItem1, AItem2, AItem3: TnPedidoItem;
begin
  AItem1 := CriarItemValido(1, 2, 10.50);
  AItem2 := CriarItemValido(2, 3, 5.00);
  AItem3 := CriarItemValido(3, 1, 100.00);

  FPedido.AdicionarItem(AItem1);
  FPedido.AdicionarItem(AItem2);
  FPedido.AdicionarItem(AItem3);

  { 1 X 100.00 = 100
    2 X 10.50  = 21
    3 X 5.00   = 15
                 136.00 }
  Assert.AreEqual(136.00, FPedido.ValorTotal, 0.01, 'Valor total deveria ser 136.00');
end;

procedure TnPedidoTests.TestNaoPodeEditarPedidoFaturado;
var
  AItem: TnPedidoItem;
begin
  AItem := CriarItemValido(1, 1, 10);
  FPedido.AdicionarItem(AItem);

  FPedido.Faturar;

  Assert.IsFalse(FPedido.PodeEditar, 'Pedido faturado não deveria poder ser editado');

  Assert.WillRaise(
    procedure
    var
      ANovoItem: TnPedidoItem;
    begin
      ANovoItem := CriarItemValido(2, 1, 5);
      FPedido.AdicionarItem(ANovoItem);
    end,
    Exception,
    'Deveria lançar exceção ao tentar adicionar item em pedido faturado'
  );
end;

procedure TnPedidoTests.TestPodeFaturarPedidoAberto;
var
  AItem: TnPedidoItem;
begin
  AItem := CriarItemValido(1, 1, 10);
  FPedido.AdicionarItem(AItem);

  Assert.IsTrue(FPedido.PodeFaturar, 'Pedido aberto com itens deveria poder ser faturado');

  FPedido.Faturar;

  Assert.AreEqual(Integer(spFaturado), Integer(FPedido.Status), 'Status deveria ser Faturado');
end;

procedure TnPedidoTests.TestNaoPodeFaturarPedidoSemItens;
begin
  Assert.IsFalse(FPedido.PodeFaturar, 'Pedido sem itens não deveria poder ser faturado');

  Assert.WillRaise(
    procedure
    begin
      FPedido.Faturar;
    end,
    Exception,
    'Deveria lançar exceção ao tentar faturar pedido sem itens'
  );
end;

procedure TnPedidoTests.TestNaoPodeFaturarPedidoJaFaturado;
var
  AItem: TnPedidoItem;
begin
  AItem := CriarItemValido(1, 1, 10);
  FPedido.AdicionarItem(AItem);
  FPedido.Faturar;

  Assert.IsFalse(FPedido.PodeFaturar, 'Pedido já faturado não deveria poder ser faturado novamente');
end;

procedure TnPedidoTests.TestAdicionarItemEmPedidoAberto;
var
  AItem: TnPedidoItem;
begin
  AItem := CriarItemValido(1, 2, 10);

  Assert.AreEqual(0, FPedido.Itens.Count, 'Pedido deveria começar sem itens');

  FPedido.AdicionarItem(AItem);

  Assert.AreEqual(1, FPedido.Itens.Count, 'Pedido deveria ter 1 item');
end;

procedure TnPedidoTests.TestNaoPodeAdicionarItemEmPedidoFaturado;
var
  AItem1, AItem2: TnPedidoItem;
begin
  AItem1 := CriarItemValido(1, 1, 10);
  FPedido.AdicionarItem(AItem1);
  FPedido.Faturar;

  AItem2 := CriarItemValido(2, 1, 5);

  Assert.WillRaise(
    procedure
    begin
      FPedido.AdicionarItem(AItem2);
    end,
    Exception
  );

  //item que não foi adicionado
  AItem2.Free;
end;

procedure TnPedidoTests.TestRemoverItemEmPedidoAberto;
var
  AItem1, AItem2: TnPedidoItem;
begin
  AItem1 := CriarItemValido(1, 1, 10);
  AItem2 := CriarItemValido(2, 1, 5);

  FPedido.AdicionarItem(AItem1);
  FPedido.AdicionarItem(AItem2);

  Assert.AreEqual(2, FPedido.Itens.Count, 'Deveria ter 2 itens');

  FPedido.RemoverItem(0);

  Assert.AreEqual(1, FPedido.Itens.Count, 'Deveria ter 1 item após remoção');
end;

procedure TnPedidoTests.TestNaoPodeRemoverItemEmPedidoFaturado;
var
  AItem: TnPedidoItem;
begin
  AItem := CriarItemValido(1, 1, 10);
  FPedido.AdicionarItem(AItem);
  FPedido.Faturar;

  Assert.WillRaise(
    procedure
    begin
      FPedido.RemoverItem(0);
    end,
    Exception, 'Deveria lançar exceção ao tentar remover item de pedido faturado'
  );
end;

procedure TnPedidoTests.TestPedidoIniciaComoAberto;
begin
  Assert.AreEqual(Integer(spAberto), Integer(FPedido.Status),
    'Pedido novo deveria iniciar com status Aberto');
end;

procedure TnPedidoTests.TestValidacaoClienteObrigatorio;
var
  AItem: TnPedidoItem;
begin
  FPedido.CodigoCliente := 0;
  AItem := CriarItemValido(1, 1, 10);
  FPedido.AdicionarItem(AItem);

  Assert.IsFalse(FPedido.Validar, 'Pedido sem cliente não deveria ser válido');
  Assert.Contains(FPedido.ObterErros, 'Cliente', True);
end;

procedure TnPedidoTests.TestValidacaoNumeroObrigatorio;
var
  AItem: TnPedidoItem;
begin
  FPedido.Numero := '';
  AItem := CriarItemValido(1, 1, 10);
  FPedido.AdicionarItem(AItem);

  Assert.IsFalse(FPedido.Validar, 'Pedido sem número não deveria ser válido');
  Assert.Contains(FPedido.ObterErros, 'Número', True);
end;

initialization
  TDUnitX.RegisterTestFixture(TnClienteTests);
  TDUnitX.RegisterTestFixture(TnProdutoTests);
  TDUnitX.RegisterTestFixture(TnPedidoItemTests);
  TDUnitX.RegisterTestFixture(TnPedidoTests);

end.
