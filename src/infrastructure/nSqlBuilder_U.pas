unit nSqlBuilder_U;

interface

uses
  System.Generics.Collections, nSqlDialeto_U;

type
  TnOrdenacao = (orDataEmissao, orNumero);

  TnFiltrosPedido = record
    DataInicio: TDateTime;
    DataFim: TDateTime;
    CodigoCliente: Integer;
    Status: string;
    TextoLivre: string;
    UsarDataInicio: Boolean;
    UsarDataFim: Boolean;
    UsarCliente: Boolean;
    UsarStatus: Boolean;
    UsarTextoLivre: Boolean;
  end;

  TnSqlBuilder = class
  private
    FDialeto: TnSqlDialeto;
    FParametros: TDictionary<string, Variant>;

    function AdicionarParametro(const _ANome: string; const _AValor: Variant): string;
  public
    constructor Create(const _ADialeto: TnSqlDialeto);
    destructor Destroy; override;

    property Parametros: TDictionary<string, Variant> read FParametros;

    function GerarSelectPedidos(const _AFiltros: TnFiltrosPedido; const _AOrdenacao: TnOrdenacao): string;

    procedure LimparParametros;
  end;

implementation

uses
  System.SysUtils, System.Variants;

const
  SQL_BASE =
    'SELECT ' + sLineBreak +
    '  p.CODIGO_PEDIDO, ' + sLineBreak +
    '  p.NUMERO, ' + sLineBreak +
    '  p.CODIGO_CLIENTE, ' + sLineBreak +
    '  c.NOME AS NOME_CLIENTE, ' + sLineBreak +
    '  p.DATA_EMISSAO, ' + sLineBreak +
    '  p.VALOR_TOTAL, ' + sLineBreak +
    '  p.STATUS ' + sLineBreak +
    'FROM PEDIDO p ' + sLineBreak +
    'INNER JOIN CLIENTE c ON c.CODIGO_CLIENTE = p.CODIGO_CLIENTE';

{ TnSqlBuilder }

constructor TnSqlBuilder.Create(const _ADialeto: TnSqlDialeto);
begin
  inherited Create;
  FDialeto := _ADialeto;
  FParametros := TDictionary<string, Variant>.Create;
end;

destructor TnSqlBuilder.Destroy;
begin
  FParametros.Free;
  inherited;
end;

function TnSqlBuilder.AdicionarParametro(const _ANome: string; const _AValor: Variant): string;
begin
  Result := FDialeto.FormatarParametro(_ANome);
  FParametros.AddOrSetValue(_ANome, _AValor);
end;

procedure TnSqlBuilder.LimparParametros;
begin
  FParametros.Clear;
end;

function TnSqlBuilder.GerarSelectPedidos(const _AFiltros: TnFiltrosPedido; const _AOrdenacao: TnOrdenacao): string;
var
  ASql: string;
  AWhere: string;
  AOrderBy: string;
  APrimeiraCondicao: Boolean;
begin
  LimparParametros;
  ASql := SQL_BASE;
  AWhere := '';
  APrimeiraCondicao := True;

  //data inicial
  if _AFiltros.UsarDataInicio then
  begin
    if APrimeiraCondicao then
    begin
      AWhere := ' WHERE ';
      APrimeiraCondicao := False;
    end
    else
      AWhere := AWhere + sLineBreak + ' AND ';

    AWhere := AWhere + 'p.DATA_EMISSAO >= ' +
      AdicionarParametro('DATA_INICIO', _AFiltros.DataInicio);
  end;

  //data final
  if _AFiltros.UsarDataFim then
  begin
    if APrimeiraCondicao then
    begin
      AWhere := ' WHERE ';
      APrimeiraCondicao := False;
    end
    else
      AWhere := AWhere + sLineBreak + ' AND ';

    AWhere := AWhere + 'p.DATA_EMISSAO <= ' +
      AdicionarParametro('DATA_FIM', _AFiltros.DataFim);
  end;

  //cliente
  if _AFiltros.UsarCliente then
  begin
    if APrimeiraCondicao then
    begin
      AWhere := ' WHERE ';
      APrimeiraCondicao := False;
    end
    else
      AWhere := AWhere + sLineBreak + ' AND ';

    AWhere := AWhere + 'p.CODIGO_CLIENTE = ' +
      AdicionarParametro('CODIGO_CLIENTE', _AFiltros.CodigoCliente);
  end;

  //status
  if _AFiltros.UsarStatus then
  begin
    if APrimeiraCondicao then
    begin
      AWhere := ' WHERE ';
      APrimeiraCondicao := False;
    end
    else
      AWhere := AWhere + sLineBreak + ' AND ';

    AWhere := AWhere + 'p.STATUS = ' +
      AdicionarParametro('STATUS', _AFiltros.Status);
  end;

  //texto livre, numero ou nome do cliente
  if _AFiltros.UsarTextoLivre then
  begin
    if APrimeiraCondicao then
    begin
      AWhere := ' WHERE ';
      APrimeiraCondicao := False;
    end
    else
      AWhere := AWhere + sLineBreak + ' AND ';

    AWhere := AWhere + sLineBreak + '(p.NUMERO LIKE ' +
      AdicionarParametro('TEXTO_LIVRE_NUM', '%' + _AFiltros.TextoLivre + '%') +
      ' OR c.NOME LIKE ' +
      AdicionarParametro('TEXTO_LIVRE_CLI', '%' + _AFiltros.TextoLivre + '%') + ')';
  end;

  case _AOrdenacao of
    orDataEmissao:
      AOrderBy := ' ORDER BY p.DATA_EMISSAO DESC';
    orNumero:
      AOrderBy := ' ORDER BY p.NUMERO';
  end;

  Result := ASql + AWhere + sLineBreak + AOrderBy;
end;

end.
