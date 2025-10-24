unit nCliente_U;

interface

type
  TnCliente = class
  private
    FCodigoCliente: Integer;
    FNome: string;
    FCpfCnpj: string;
    FAtivo: Boolean;
  public
    constructor Create;

    property CodigoCliente: Integer read FCodigoCliente write FCodigoCliente;
    property Nome: string read FNome write FNome;
    property CpfCnpj: string read FCpfCnpj write FCpfCnpj;
    property Ativo: Boolean read FAtivo write FAtivo;

    function Validar: Boolean;
    function ObterErros: string;
  end;

implementation

uses
  System.SysUtils;

{ TnCliente }

constructor TnCliente.Create;
begin
  inherited;
  FCodigoCliente := 0;
  FNome := '';
  FCpfCnpj := '';
  FAtivo := True;
end;

function TnCliente.Validar: Boolean;
begin
  Result := (Trim(FNome) <> '') and (Trim(FCpfCnpj) <> '');
end;

function TnCliente.ObterErros: string;
begin
  Result := '';

  if Trim(FNome) = '' then
    Result := Result + 'Nome é obrigatório.' + sLineBreak;

  if Trim(FCpfCnpj) = '' then
    Result := Result + 'CPF/CNPJ é obrigatório.' + sLineBreak;
end;

end.
