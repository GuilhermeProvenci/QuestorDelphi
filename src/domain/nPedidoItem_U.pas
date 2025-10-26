unit nPedidoItem_U;

interface

type
  TnPedidoItem = class
  private
    FCodigoPedidoItem: Integer;
    FCodigoPedido: Integer;
    FCodigoProduto: Integer;
    FQtde: Double;
    FPrecoUnit: Double;

    function GetTotal: Double;
  public
    constructor Create;

    property CodigoPedidoItem: Integer read FCodigoPedidoItem write FCodigoPedidoItem;
    property CodigoPedido: Integer read FCodigoPedido write FCodigoPedido;
    property CodigoProduto: Integer read FCodigoProduto write FCodigoProduto;
    property Qtde: Double read FQtde write FQtde;
    property PrecoUnit: Double read FPrecoUnit write FPrecoUnit;
    property Total: Double read GetTotal;

    function Validar: Boolean;
    function ObterErros: string;
  end;

implementation

uses
  System.SysUtils;

{ TnPedidoItem }

constructor TnPedidoItem.Create;
begin
  inherited;
  FCodigoPedidoItem := 0;
  FCodigoPedido := 0;
  FCodigoProduto := 0;
  FQtde := 0;
  FPrecoUnit := 0;
end;

function TnPedidoItem.GetTotal: Double;
begin
  Result := FQtde * FPrecoUnit;
end;

function TnPedidoItem.Validar: Boolean;
begin
  Result := (FCodigoProduto > 0) and (FQtde > 0) and (FPrecoUnit > 0);
end;

function TnPedidoItem.ObterErros: string;
begin
  Result := '';

  if FCodigoProduto <= 0 then
    Result := Result + 'Produto é obrigatório.' + sLineBreak;

  if FQtde <= 0 then
    Result := Result + 'Quantidade deve ser maior que zero.' + sLineBreak;

  if FPrecoUnit <= 0 then
    Result := Result + 'Preço unitário deve ser maior que zero.' + sLineBreak;
end;

end.
