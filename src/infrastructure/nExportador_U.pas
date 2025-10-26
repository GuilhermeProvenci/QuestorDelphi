unit nExportador_U;

interface

uses
  System.Generics.Collections, nPedido_U, System.Classes, System.JSON,
  nPedidoItem_U;

type
  TnFormatoExportacao = (feJSON, feCSV);

  TnExportador = class
  private
    function GerarJSON(const _APedidos: TObjectList<TnPedido>): string;
    function GerarCSV(const _APedidos: TObjectList<TnPedido>): string;
    function StatusParaString(const _AStatus: TnStatusPedido): string;

    function PedidoParaJSON(const _APedido: TnPedido): TJSONObject;
    function ItemParaJSON(const _AItem: TnPedidoItem): TJSONObject;
  public
    function Exportar(const _APedidos: TObjectList<TnPedido>;
                      const _AFormato: TnFormatoExportacao): string;

    procedure SalvarArquivo(
      const _APedidos: TObjectList<TnPedido>;
      const _ACaminhoArquivo: string;
      const _AFormato: TnFormatoExportacao
    );
  end;

implementation

uses
  System.SysUtils, nRepositorioMem_U, nCliente_U;

{ TnExportador }

function TnExportador.StatusParaString(
  const _AStatus: TnStatusPedido
): string;
begin
  case _AStatus of
    spAberto: Result := 'ABERTO';
    spFaturado: Result := 'FATURADO';
    spCancelado: Result := 'CANCELADO';
  else
    Result := 'DESCONHECIDO';
  end;
end;

function TnExportador.ItemParaJSON(const _AItem: TnPedidoItem): TJSONObject;
begin
  Result := TJSONObject.Create;
  try
    Result.AddPair('codigoPedidoItem', TJSONNumber.Create(_AItem.CodigoPedidoItem));
    Result.AddPair('codigoPedido', TJSONNumber.Create(_AItem.CodigoPedido));
    Result.AddPair('codigoProduto', TJSONNumber.Create(_AItem.CodigoProduto));
    Result.AddPair('quantidade', TJSONNumber.Create(_AItem.Qtde));
    Result.AddPair('precoUnitario', TJSONNumber.Create(_AItem.PrecoUnit));
    Result.AddPair('total', TJSONNumber.Create(_AItem.Total));
  except
    Result.Free;
    raise;
  end;
end;

function TnExportador.PedidoParaJSON(const _APedido: TnPedido): TJSONObject;
var
  ARepositorio: TnRepositorioMem;
  ACliente: TnCliente;
  AItensArray: TJSONArray;
  AItem: TnPedidoItem;
begin
  Result := TJSONObject.Create;
  try
    Result.AddPair('codigoPedido', TJSONNumber.Create(_APedido.CodigoPedido));
    Result.AddPair('numero', _APedido.Numero);
    Result.AddPair('codigoCliente', TJSONNumber.Create(_APedido.CodigoCliente));

    //nome do cliente
    ARepositorio := TnRepositorioMem.Instancia;
    ACliente := ARepositorio.ObterCliente(_APedido.CodigoCliente);
    if Assigned(ACliente) then
      Result.AddPair('nomeCliente', ACliente.Nome)
    else
      Result.AddPair('nomeCliente', '(Desconhecido)');

    Result.AddPair('dataEmissao',
      FormatDateTime('yyyy-mm-dd', _APedido.DataEmissao));
    Result.AddPair('valorTotal', TJSONNumber.Create(_APedido.ValorTotal));
    Result.AddPair('status', StatusParaString(_APedido.Status));

    //itens
    AItensArray := TJSONArray.Create;
    for AItem in _APedido.Itens do
      AItensArray.AddElement(ItemParaJSON(AItem));

    Result.AddPair('itens', AItensArray);
  except
    Result.Free;
    raise;
  end;
end;

function TnExportador.GerarJSON(
  const _APedidos: TObjectList<TnPedido>
): string;
var
  APedido: TnPedido;
  APedidosArray: TJSONArray;
  ARootObject: TJSONObject;
begin
  ARootObject := TJSONObject.Create;
  try
    ARootObject.AddPair('exportadoEm',
      FormatDateTime('yyyy-mm-dd"T"hh:nn:ss', Now));
    ARootObject.AddPair('totalPedidos',
      TJSONNumber.Create(_APedidos.Count));

    APedidosArray := TJSONArray.Create;
    for APedido in _APedidos do
      APedidosArray.AddElement(PedidoParaJSON(APedido));

    ARootObject.AddPair('pedidos', APedidosArray);

    Result := ARootObject.Format(2);
  finally
    ARootObject.Free;
  end;
end;

function TnExportador.GerarCSV(
  const _APedidos: TObjectList<TnPedido>
): string;
var
  APedido: TnPedido;
  ARepositorio: TnRepositorioMem;
  ACliente: TnCliente;
  ABuilder: TStringBuilder;
begin
  ABuilder := TStringBuilder.Create;
  try
    //cabeçalho
    ABuilder.AppendLine(
      'Codigo;Numero;CodigoCliente;NomeCliente;DataEmissao;' +
      'ValorTotal;Status;QtdeItens'
    );

    ARepositorio := TnRepositorioMem.Instancia;

    //dados
    for APedido in _APedidos do
    begin
      ABuilder.Append(APedido.CodigoPedido.ToString).Append(';');
      ABuilder.Append(APedido.Numero).Append(';');
      ABuilder.Append(APedido.CodigoCliente.ToString).Append(';');

      //nome do cliente
      ACliente := ARepositorio.ObterCliente(APedido.CodigoCliente);
      if Assigned(ACliente) then
        ABuilder.Append(ACliente.Nome)
      else
        ABuilder.Append('(Desconhecido)');
      ABuilder.Append(';');

      ABuilder.Append(
        FormatDateTime('dd/mm/yyyy', APedido.DataEmissao)
      ).Append(';');

      ABuilder.Append(
        FormatFloat('0.00', APedido.ValorTotal)
      ).Append(';');

      ABuilder.Append(StatusParaString(APedido.Status)).Append(';');
      ABuilder.AppendLine(APedido.Itens.Count.ToString);
    end;

    Result := ABuilder.ToString;
  finally
    ABuilder.Free;
  end;
end;

function TnExportador.Exportar(const _APedidos: TObjectList<TnPedido>;
                               const _AFormato: TnFormatoExportacao): string;
begin
  case _AFormato of
    feJSON: Result := GerarJSON(_APedidos);
    feCSV: Result := GerarCSV(_APedidos);
  else
    raise Exception.Create('Formato de exportação desconhecido');
  end;
end;

procedure TnExportador.SalvarArquivo( const _APedidos: TObjectList<TnPedido>;
                                      const _ACaminhoArquivo: string;
                                      const _AFormato: TnFormatoExportacao);
var
  AConteudo: string;
  AArquivo: TStringList;
begin
  AConteudo := Exportar(_APedidos, _AFormato);

  AArquivo := TStringList.Create;
  try
    AArquivo.Text := AConteudo;
    AArquivo.SaveToFile(_ACaminhoArquivo, TEncoding.UTF8);
  finally
    AArquivo.Free;
  end;
end;

end.
