unit nPedido_U;

interface

uses
  System.Generics.Collections, nPedidoItem_U;

type
  TnStatusPedido = (spAberto, spFaturado, spCancelado);

  TnPedido = class
  private
    FCodigoPedido: Integer;
    FNumero: string;
    FCodigoCliente: Integer;
    FDataEmissao: TDateTime;
    FValorTotal: Double;
    FStatus: TnStatusPedido;
    FItens: TObjectList<TnPedidoItem>;

    function GetValorTotal: Double;
  public
    constructor Create;
    destructor Destroy; override;

    property CodigoPedido: Integer read FCodigoPedido write FCodigoPedido;
    property Numero: string read FNumero write FNumero;
    property CodigoCliente: Integer read FCodigoCliente write FCodigoCliente;
    property DataEmissao: TDateTime read FDataEmissao write FDataEmissao;
    property ValorTotal: Double read GetValorTotal;
    property Status: TnStatusPedido read FStatus write FStatus;
    property Itens: TObjectList<TnPedidoItem> read FItens;

    procedure AdicionarItem(const _AItem: TnPedidoItem);
    procedure RemoverItem(const _AIndice: Integer);
    function PodeEditar: Boolean;
    function PodeFaturar: Boolean;
    function Validar: Boolean;
    function ObterErros: string;
    procedure Faturar;
  end;

implementation

uses
  System.SysUtils;

{ TnPedido }

constructor TnPedido.Create;
begin
  inherited;
  FCodigoPedido := 0;
  FNumero := '';
  FCodigoCliente := 0;
  FDataEmissao := Now;
  FStatus := spAberto;
  FItens := TObjectList<TnPedidoItem>.Create(True);
end;

destructor TnPedido.Destroy;
begin
  FItens.Free;
  inherited;
end;

function TnPedido.GetValorTotal: Double;
var
  AItem: TnPedidoItem;
begin
  Result := 0;
  for AItem in FItens do
    Result := Result + AItem.Total;
end;

procedure TnPedido.AdicionarItem(const _AItem: TnPedidoItem);
begin
  if not PodeEditar then
    raise Exception.Create('Pedido não pode ser editado');

  FItens.Add(_AItem);
end;

procedure TnPedido.RemoverItem(const _AIndice: Integer);
begin
  if not PodeEditar then
    raise Exception.Create('Pedido não pode ser editado');

  if (_AIndice >= 0) and (_AIndice < FItens.Count) then
    FItens.Delete(_AIndice);
end;

function TnPedido.PodeEditar: Boolean;
begin
  Result := FStatus = spAberto;
end;

function TnPedido.PodeFaturar: Boolean;
begin
  Result := (FStatus = spAberto) and (FItens.Count > 0);
end;

function TnPedido.Validar: Boolean;
begin
  Result := (FCodigoCliente > 0) and (Trim(FNumero) <> '') and (FItens.Count > 0);
end;

function TnPedido.ObterErros: string;
begin
  Result := '';

  if FCodigoCliente <= 0 then
    Result := Result + 'Cliente é obrigatório.' + sLineBreak;

  if Trim(FNumero) = '' then
    Result := Result + 'Número é obrigatório.' + sLineBreak;

  if FItens.Count = 0 then
    Result := Result + 'Pedido deve ter ao menos um item.' + sLineBreak;
end;

procedure TnPedido.Faturar;
begin
  //só mudar o status
  if not PodeFaturar then
    raise Exception.Create('Pedido não pode ser faturado');

  FStatus := spFaturado;
end;

end.
