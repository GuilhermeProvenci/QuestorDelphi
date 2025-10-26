unit nProduto_U;

interface

type
  TnProduto = class
  private
    FCodigoProduto: Integer;
    FDescricao: string;
    FPrecoUnit: Double;
    FAtivo: Boolean;
  public
    constructor Create;

    property CodigoProduto: Integer read FCodigoProduto write FCodigoProduto;
    property Descricao: string read FDescricao write FDescricao;
    property PrecoUnit: Double read FPrecoUnit write FPrecoUnit;
    property Ativo: Boolean read FAtivo write FAtivo;

    function Validar: Boolean;
    function ObterErros: string;
  end;

implementation

uses
  System.SysUtils;

{ TnProduto }

constructor TnProduto.Create;
begin
  inherited;
  FCodigoProduto := 0;
  FDescricao := '';
  FPrecoUnit := 0;
  FAtivo := True;
end;

function TnProduto.Validar: Boolean;
begin
  Result := (Trim(FDescricao) <> '') and (FPrecoUnit > 0);
end;

function TnProduto.ObterErros: string;
begin
  Result := '';

  if Trim(FDescricao) = '' then
    Result := Result + 'Descrição é obrigatória.' + sLineBreak;

  if FPrecoUnit <= 0 then
    Result := Result + 'Preço unitário deve ser maior que zero.' + sLineBreak;
end;

end.
