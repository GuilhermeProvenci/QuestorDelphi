unit nSqlBuilderTests_U;

interface

uses
  DUnitX.TestFramework,
  nSqlBuilder_U,
  nSqlDialeto_U,
  System.SysUtils;

type
  [TestFixture]
  TnSqlBuilderTests = class
  private
    FBuilder: TnSqlBuilder;
    FDialeto: TnSqlDialeto;
  public
    [Setup]
    procedure Setup;

    [TearDown]
    procedure TearDown;

    [Test]
    procedure TestSelectSemFiltros;

    [Test]
    procedure TestSelectComTodosFiltros;

    //filtros individuais
    [Test]
    procedure TestSelectComFiltroDataInicio;

    [Test]
    procedure TestSelectComFiltroDataFim;

    [Test]
    procedure TestSelectComFiltroCliente;

    [Test]
    procedure TestSelectComFiltroStatus;

    [Test]
    procedure TestSelectComTextoLivre;

    //ordenação
    [Test]
    procedure TestOrdenacaoPorDataEmissao;

    [Test]
    procedure TestOrdenacaoPorNumero;

    [Test]
    procedure TestParametrosSaoGerados;

    [Test]
    procedure TestParametrosCorretos;

    [Test]
    procedure TestLimparParametros;

    //segurança do sql
    [Test]
    procedure TestSqlNaoContemValoresLiterais;

    [Test]
    procedure TestJoinComCliente;

    [Test]
    procedure TestDialetoFirebird;

    [Test]
    procedure TestDialetoOracle;

    [Test]
    procedure TestDialetoPostgreSQL;
  end;

implementation

uses
  System.Variants;

{ TnSqlBuilderTests }

procedure TnSqlBuilderTests.Setup;
begin
  FDialeto := TnSqlDialeto.Create(tdFirebird);
  FBuilder := TnSqlBuilder.Create(FDialeto);
end;

procedure TnSqlBuilderTests.TearDown;
begin
  FBuilder.Free;
  FDialeto.Free;
end;

procedure TnSqlBuilderTests.TestSelectSemFiltros;
var
  AFiltros: TnFiltrosPedido;
  ASql: string;
begin
  FillChar(AFiltros, SizeOf(AFiltros), 0);

  ASql := FBuilder.GerarSelectPedidos(AFiltros, orDataEmissao);

  Assert.Contains(ASql, 'SELECT', True, 'SQL deve conter SELECT');
  Assert.Contains(ASql, 'FROM PEDIDO', True, 'SQL deve conter FROM PEDIDO');
  Assert.Contains(ASql, 'INNER JOIN CLIENTE', True, 'SQL deve conter JOIN com CLIENTE');
  Assert.Contains(ASql, 'ORDER BY', True, 'SQL deve conter ORDER BY');
  Assert.IsFalse(ASql.Contains('WHERE'), 'SQL sem filtros não deveria ter WHERE');
end;

procedure TnSqlBuilderTests.TestSelectComTodosFiltros;
var
  AFiltros: TnFiltrosPedido;
  ASql: string;
  ACountAND: Integer;
  I: Integer;
begin
  FillChar(AFiltros, SizeOf(AFiltros), 0);
  AFiltros.DataInicio := EncodeDate(2025, 1, 1);
  AFiltros.DataFim := EncodeDate(2025, 12, 31);
  AFiltros.CodigoCliente := 5;
  AFiltros.Status := 'ABERTO';
  AFiltros.TextoLivre := 'PED';
  AFiltros.UsarDataInicio := True;
  AFiltros.UsarDataFim := True;
  AFiltros.UsarCliente := True;
  AFiltros.UsarStatus := True;
  AFiltros.UsarTextoLivre := True;

  ASql := FBuilder.GerarSelectPedidos(AFiltros, orDataEmissao);

  Assert.Contains(ASql, 'WHERE', True, 'SQL deve conter WHERE');
  Assert.Contains(ASql, 'AND', True, 'SQL deve conter AND para múltiplos filtros');

  // Contar os AND
  ACountAND := 0;
  I := 1;
  while I <= Length(ASql) do
  begin
    I := Pos('AND', UpperCase(Copy(ASql, I, Length(ASql))));
    if I > 0 then
    begin
      Inc(ACountAND);
      Inc(I, 3); // Pular
    end
    else
      Break;
  end;

  Assert.IsTrue(ACountAND >= 4, 'Deve ter pelo menos 4 ANDs (tem ' + IntToStr(ACountAND) + ')');
end;

procedure TnSqlBuilderTests.TestSelectComFiltroDataInicio;
var
  AFiltros: TnFiltrosPedido;
  ASql: string;
begin
  FillChar(AFiltros, SizeOf(AFiltros), 0);
  AFiltros.DataInicio := EncodeDate(2024, 1, 1);
  AFiltros.UsarDataInicio := True;

  ASql := FBuilder.GerarSelectPedidos(AFiltros, orDataEmissao);

  Assert.Contains(ASql, 'WHERE', True);
  Assert.Contains(ASql, 'DATA_EMISSAO >=', True);
  Assert.Contains(ASql, ':DATA_INICIO', True);
end;

procedure TnSqlBuilderTests.TestSelectComFiltroDataFim;
var
  AFiltros: TnFiltrosPedido;
  ASql: string;
begin
  FillChar(AFiltros, SizeOf(AFiltros), 0);
  AFiltros.DataFim := EncodeDate(2024, 12, 31);
  AFiltros.UsarDataFim := True;

  ASql := FBuilder.GerarSelectPedidos(AFiltros, orDataEmissao);

  Assert.Contains(ASql, 'WHERE', True);
  Assert.Contains(ASql, 'DATA_EMISSAO <=', True);
  Assert.Contains(ASql, ':DATA_FIM', True);
end;

procedure TnSqlBuilderTests.TestSelectComFiltroCliente;
var
  AFiltros: TnFiltrosPedido;
  ASql: string;
begin
  FillChar(AFiltros, SizeOf(AFiltros), 0);
  AFiltros.CodigoCliente := 10;
  AFiltros.UsarCliente := True;

  ASql := FBuilder.GerarSelectPedidos(AFiltros, orDataEmissao);

  Assert.Contains(ASql, 'WHERE', True);
  Assert.Contains(ASql, 'CODIGO_CLIENTE =', True);
  Assert.Contains(ASql, ':CODIGO_CLIENTE', True);
end;

procedure TnSqlBuilderTests.TestSelectComFiltroStatus;
var
  AFiltros: TnFiltrosPedido;
  ASql: string;
begin
  FillChar(AFiltros, SizeOf(AFiltros), 0);
  AFiltros.Status := 'FATURADO';
  AFiltros.UsarStatus := True;

  ASql := FBuilder.GerarSelectPedidos(AFiltros, orDataEmissao);

  Assert.Contains(ASql, 'WHERE', True);
  Assert.Contains(ASql, 'STATUS =', True);
  Assert.Contains(ASql, ':STATUS', True);
end;

procedure TnSqlBuilderTests.TestSelectComTextoLivre;
var
  AFiltros: TnFiltrosPedido;
  ASql: string;
begin
  FillChar(AFiltros, SizeOf(AFiltros), 0);
  AFiltros.TextoLivre := 'teste';
  AFiltros.UsarTextoLivre := True;

  ASql := FBuilder.GerarSelectPedidos(AFiltros, orDataEmissao);

  Assert.Contains(ASql, 'WHERE', True);
  Assert.Contains(ASql, 'NUMERO LIKE', True);
  Assert.Contains(ASql, 'NOME LIKE', True);
  Assert.Contains(ASql, 'OR', True, 'Deve ter OR entre NUMERO e NOME');
end;

procedure TnSqlBuilderTests.TestOrdenacaoPorDataEmissao;
var
  AFiltros: TnFiltrosPedido;
  ASql: string;
begin
  FillChar(AFiltros, SizeOf(AFiltros), 0);

  ASql := FBuilder.GerarSelectPedidos(AFiltros, orDataEmissao);

  Assert.Contains(ASql, 'ORDER BY p.DATA_EMISSAO', True);
end;

procedure TnSqlBuilderTests.TestOrdenacaoPorNumero;
var
  AFiltros: TnFiltrosPedido;
  ASql: string;
begin
  FillChar(AFiltros, SizeOf(AFiltros), 0);

  ASql := FBuilder.GerarSelectPedidos(AFiltros, orNumero);

  Assert.Contains(ASql, 'ORDER BY p.NUMERO', True);
end;

procedure TnSqlBuilderTests.TestParametrosSaoGerados;
var
  AFiltros: TnFiltrosPedido;
  ASql: string;
begin
  FillChar(AFiltros, SizeOf(AFiltros), 0);
  AFiltros.DataInicio := EncodeDate(2024, 1, 1);
  AFiltros.CodigoCliente := 10;
  AFiltros.UsarDataInicio := True;
  AFiltros.UsarCliente := True;

  ASql := FBuilder.GerarSelectPedidos(AFiltros, orDataEmissao);

  Assert.AreEqual(2, FBuilder.Parametros.Count, 'Deveria ter 2 parâmetros');
  Assert.IsTrue(FBuilder.Parametros.ContainsKey('DATA_INICIO'), 'Deveria conter parâmetro DATA_INICIO');
  Assert.IsTrue(FBuilder.Parametros.ContainsKey('CODIGO_CLIENTE'), 'Deveria conter parâmetro CODIGO_CLIENTE');
end;

procedure TnSqlBuilderTests.TestParametrosCorretos;
var
  AFiltros: TnFiltrosPedido;
  ASql: string;
  ADataEsperada: TDateTime;
begin
  FillChar(AFiltros, SizeOf(AFiltros), 0);
  ADataEsperada := EncodeDate(2024, 10, 20);
  AFiltros.DataInicio := ADataEsperada;
  AFiltros.CodigoCliente := 5;
  AFiltros.Status := 'ABERTO';
  AFiltros.UsarDataInicio := True;
  AFiltros.UsarCliente := True;
  AFiltros.UsarStatus := True;

  ASql := FBuilder.GerarSelectPedidos(AFiltros, orDataEmissao);

  Assert.AreEqual(
    ADataEsperada, VarToDateTime(FBuilder.Parametros['DATA_INICIO']),
    'Valor do parâmetro DATA_INICIO deve estar correto'
  );
  Assert.AreEqual(
    5, Integer(FBuilder.Parametros['CODIGO_CLIENTE']),
    'Valor do parâmetro CODIGO_CLIENTE deve estar correto'
  );
  Assert.AreEqual(
    'ABERTO', string(FBuilder.Parametros['STATUS']),
    'Valor do parâmetro STATUS deve estar correto'
  );
end;

procedure TnSqlBuilderTests.TestLimparParametros;
var
  AFiltros: TnFiltrosPedido;
  ASql: string;
begin
  FillChar(AFiltros, SizeOf(AFiltros), 0);
  AFiltros.CodigoCliente := 1;
  AFiltros.UsarCliente := True;

  ASql := FBuilder.GerarSelectPedidos(AFiltros, orDataEmissao);
  Assert.AreEqual(1, FBuilder.Parametros.Count, 'Deve ter 1 parâmetro');

  // tem que limpar os parâmetros anteriores
  FillChar(AFiltros, SizeOf(AFiltros), 0);
  ASql := FBuilder.GerarSelectPedidos(AFiltros, orDataEmissao);

  Assert.AreEqual(0, FBuilder.Parametros.Count,
    'Parâmetros devem ser limpos ao gerar novo SQL');
end;

procedure TnSqlBuilderTests.TestSqlNaoContemValoresLiterais;
var
  AFiltros: TnFiltrosPedido;
  ASql: string;
begin
  FillChar(AFiltros, SizeOf(AFiltros), 0);
  AFiltros.CodigoCliente := 999;
  AFiltros.Status := 'TESTE123';
  AFiltros.UsarCliente := True;
  AFiltros.UsarStatus := True;

  ASql := FBuilder.GerarSelectPedidos(AFiltros, orDataEmissao);

  Assert.IsFalse(ASql.Contains('999'), 'SQL não deve conter valor literal do código cliente');
  Assert.IsFalse(ASql.Contains('TESTE123'), 'SQL não deve conter valor literal do status');

  Assert.Contains(ASql, ':CODIGO_CLIENTE', True);
  Assert.Contains(ASql, ':STATUS', True);
end;

procedure TnSqlBuilderTests.TestJoinComCliente;
var
  AFiltros: TnFiltrosPedido;
  ASql: string;
begin
  FillChar(AFiltros, SizeOf(AFiltros), 0);

  ASql := FBuilder.GerarSelectPedidos(AFiltros, orDataEmissao);

  Assert.Contains(ASql, 'INNER JOIN CLIENTE c', True, 'SQL deve ter JOIN com tabela CLIENTE');
  Assert.Contains(ASql, 'ON c.CODIGO_CLIENTE = p.CODIGO_CLIENTE', True, 'JOIN deve usar CODIGO_CLIENTE como chave');
  Assert.Contains(ASql, 'c.NOME', True, 'SQL deve selecionar nome do cliente');
end;

procedure TnSqlBuilderTests.TestDialetoFirebird;
var
  AFiltros: TnFiltrosPedido;
  ASql: string;
begin
  FDialeto.Free;
  FDialeto := TnSqlDialeto.Create(tdFirebird);
  FBuilder.Free;
  FBuilder := TnSqlBuilder.Create(FDialeto);

  FillChar(AFiltros, SizeOf(AFiltros), 0);
  AFiltros.CodigoCliente := 1;
  AFiltros.UsarCliente := True;

  ASql := FBuilder.GerarSelectPedidos(AFiltros, orDataEmissao);

  Assert.Contains(ASql, ':CODIGO_CLIENTE', True, 'Firebird deve usar : para parâmetros');
end;

procedure TnSqlBuilderTests.TestDialetoOracle;
var
  AFiltros: TnFiltrosPedido;
  ASql: string;
begin
  FDialeto.Free;
  FDialeto := TnSqlDialeto.Create(tdOracle);
  FBuilder.Free;
  FBuilder := TnSqlBuilder.Create(FDialeto);

  FillChar(AFiltros, SizeOf(AFiltros), 0);
  AFiltros.CodigoCliente := 1;
  AFiltros.UsarCliente := True;

  ASql := FBuilder.GerarSelectPedidos(AFiltros, orDataEmissao);

  Assert.Contains(ASql, ':CODIGO_CLIENTE', True, 'Oracle deve usar : para parâmetros');
end;

procedure TnSqlBuilderTests.TestDialetoPostgreSQL;
var
  AFiltros: TnFiltrosPedido;
  ASql: string;
begin
  FDialeto.Free;
  FDialeto := TnSqlDialeto.Create(tdPostgreSQL);
  FBuilder.Free;
  FBuilder := TnSqlBuilder.Create(FDialeto);

  FillChar(AFiltros, SizeOf(AFiltros), 0);
  AFiltros.CodigoCliente := 1;
  AFiltros.UsarCliente := True;

  ASql := FBuilder.GerarSelectPedidos(AFiltros, orDataEmissao);

  Assert.Contains(ASql, ':CODIGO_CLIENTE', True, 'PostgreSQL deve usar : para parâmetros');
end;

initialization
  TDUnitX.RegisterTestFixture(TnSqlBuilderTests);

end.
