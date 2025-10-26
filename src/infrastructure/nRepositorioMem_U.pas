unit nRepositorioMem_U;

interface

uses
  System.Generics.Collections, nCliente_U, nProduto_U, nPedido_U;

type
  TnRepositorioMem = class
  private
    FClientes: TObjectList<TnCliente>;
    FProdutos: TObjectList<TnProduto>;
    FPedidos: TObjectList<TnPedido>;
    FProximoCodigoCliente: Integer;
    FProximoCodigoProduto: Integer;
    FProximoCodigoPedido: Integer;

    class var FInstancia: TnRepositorioMem;
  public
    constructor Create;
    destructor Destroy; override;

    class function Instancia: TnRepositorioMem;
    class procedure LiberarInstancia;

    function SalvarCliente(const _ACliente: TnCliente): Integer;
    function ObterCliente(const _ACodigo: Integer): TnCliente;
    function ListarClientes: TObjectList<TnCliente>;
    procedure ExcluirCliente(const _ACodigo: Integer);

    function SalvarProduto(const _AProduto: TnProduto): Integer;
    function ObterProduto(const _ACodigo: Integer): TnProduto;
    function ListarProdutos: TObjectList<TnProduto>;
    procedure ExcluirProduto(const _ACodigo: Integer);

    function SalvarPedido(const _APedido: TnPedido): Integer;
    function ObterPedido(const _ACodigo: Integer): TnPedido;
    function ListarPedidos: TObjectList<TnPedido>;
    procedure ExcluirPedido(const _ACodigo: Integer);
  end;

implementation

uses
  System.SysUtils;

{ TnRepositorioMem }

constructor TnRepositorioMem.Create;
begin
  inherited;
  FClientes := TObjectList<TnCliente>.Create(False);
  FProdutos := TObjectList<TnProduto>.Create(False);
  FPedidos := TObjectList<TnPedido>.Create(False);
  FProximoCodigoCliente := 1;
  FProximoCodigoProduto := 1;
  FProximoCodigoPedido := 1;
end;

destructor TnRepositorioMem.Destroy;
var
  ACliente: TnCliente;
  AProduto: TnProduto;
  APedido: TnPedido;
begin
  for ACliente in FClientes do
    ACliente.Free;
  FClientes.Free;

  for AProduto in FProdutos do
    AProduto.Free;
  FProdutos.Free;

  for APedido in FPedidos do
    APedido.Free;
  FPedidos.Free;

  inherited;
end;

class function TnRepositorioMem.Instancia: TnRepositorioMem;
begin
  if not Assigned(FInstancia) then
    FInstancia := TnRepositorioMem.Create;
  Result := FInstancia;
end;

class procedure TnRepositorioMem.LiberarInstancia;
begin
  if Assigned(FInstancia) then
  begin
    FInstancia.Free;
    FInstancia := nil;
  end;
end;

function TnRepositorioMem.SalvarCliente(const _ACliente: TnCliente): Integer;
var
  AClienteExistente: TnCliente;
begin
  if not _ACliente.Validar then
    raise Exception.Create(_ACliente.ObterErros);

  if _ACliente.CodigoCliente = 0 then
  begin
    _ACliente.CodigoCliente := FProximoCodigoCliente;
    Inc(FProximoCodigoCliente);
    FClientes.Add(_ACliente);
  end
  else
  begin
    AClienteExistente := ObterCliente(_ACliente.CodigoCliente);
    if not Assigned(AClienteExistente) then
      raise Exception.Create('Cliente não encontrado');
  end;

  Result := _ACliente.CodigoCliente;
end;

function TnRepositorioMem.ObterCliente(const _ACodigo: Integer): TnCliente;
var
  ACliente: TnCliente;
begin
  Result := nil;
  for ACliente in FClientes do
  begin
    if ACliente.CodigoCliente = _ACodigo then
    begin
      Result := ACliente;
      Break;
    end;
  end;
end;

function TnRepositorioMem.ListarClientes: TObjectList<TnCliente>;
begin
  Result := FClientes;
end;

procedure TnRepositorioMem.ExcluirCliente(const _ACodigo: Integer);
var
  ACliente: TnCliente;
begin
  ACliente := ObterCliente(_ACodigo);
  if Assigned(ACliente) then
  begin
    FClientes.Remove(ACliente);
    ACliente.Free;
  end;
end;

function TnRepositorioMem.SalvarProduto(const _AProduto: TnProduto): Integer;
var
  AProdutoExistente: TnProduto;
begin
  if not _AProduto.Validar then
    raise Exception.Create(_AProduto.ObterErros);

  if _AProduto.CodigoProduto = 0 then
  begin
    _AProduto.CodigoProduto := FProximoCodigoProduto;
    Inc(FProximoCodigoProduto);
    FProdutos.Add(_AProduto);
  end
  else
  begin
    AProdutoExistente := ObterProduto(_AProduto.CodigoProduto);
    if not Assigned(AProdutoExistente) then
      raise Exception.Create('Produto não encontrado');
  end;

  Result := _AProduto.CodigoProduto;
end;

function TnRepositorioMem.ObterProduto(const _ACodigo: Integer): TnProduto;
var
  AProduto: TnProduto;
begin
  Result := nil;
  for AProduto in FProdutos do
  begin
    if AProduto.CodigoProduto = _ACodigo then
    begin
      Result := AProduto;
      Break;
    end;
  end;
end;

function TnRepositorioMem.ListarProdutos: TObjectList<TnProduto>;
begin
  Result := FProdutos;
end;

procedure TnRepositorioMem.ExcluirProduto(const _ACodigo: Integer);
var
  AProduto: TnProduto;
begin
  AProduto := ObterProduto(_ACodigo);
  if Assigned(AProduto) then
  begin
    FProdutos.Remove(AProduto);
    AProduto.Free;
  end;
end;

function TnRepositorioMem.SalvarPedido(const _APedido: TnPedido): Integer;
var
  APedidoExistente: TnPedido;
begin
  if not _APedido.Validar then
    raise Exception.Create(_APedido.ObterErros);

  if _APedido.CodigoPedido = 0 then
  begin
    _APedido.CodigoPedido := FProximoCodigoPedido;
    Inc(FProximoCodigoPedido);
    FPedidos.Add(_APedido);
  end
  else
  begin
    APedidoExistente := ObterPedido(_APedido.CodigoPedido);
    if not Assigned(APedidoExistente) then
      raise Exception.Create('Pedido não encontrado');
  end;

  Result := _APedido.CodigoPedido;
end;

function TnRepositorioMem.ObterPedido(const _ACodigo: Integer): TnPedido;
var
  APedido: TnPedido;
begin
  Result := nil;
  for APedido in FPedidos do
  begin
    if APedido.CodigoPedido = _ACodigo then
    begin
      Result := APedido;
      Break;
    end;
  end;
end;

function TnRepositorioMem.ListarPedidos: TObjectList<TnPedido>;
begin
  Result := FPedidos;
end;

procedure TnRepositorioMem.ExcluirPedido(const _ACodigo: Integer);
var
  APedido: TnPedido;
begin
  APedido := ObterPedido(_ACodigo);
  if Assigned(APedido) then
  begin
    FPedidos.Remove(APedido);
    APedido.Free;
  end;
end;

initialization

finalization
  TnRepositorioMem.LiberarInstancia;

end.
