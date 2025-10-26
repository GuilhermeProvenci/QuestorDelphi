unit nSqlDialeto_U;

interface

type
  TnTipoDialeto = (tdFirebird, tdOracle, tdPostgreSQL);

  TnSqlDialeto = class
  private
    FTipo: TnTipoDialeto;
  public
    constructor Create(const _ATipo: TnTipoDialeto);

    property Tipo: TnTipoDialeto read FTipo;

    function FormatarParametro(const _ANome: string): string;
    function FormatarData(const _AData: TDateTime): string;
  end;

implementation

uses
  System.SysUtils;

{ TnSqlDialeto }

constructor TnSqlDialeto.Create(const _ATipo: TnTipoDialeto);
begin
  inherited Create;
  FTipo := _ATipo;
end;

function TnSqlDialeto.FormatarParametro(const _ANome: string): string;
begin
  //pra filtros simples da doc, não vai mudar nada na atribuição
  case FTipo of
    tdFirebird: Result := ':' + _ANome;
    tdOracle: Result := ':' + _ANome;
    tdPostgreSQL: Result := ':' + _ANome;
  else
    Result := ':' + _ANome;
  end;
end;

function TnSqlDialeto.FormatarData(const _AData: TDateTime): string;
begin
  //nesse caso acho que depende da config do banco o formato padrão da data, mas padrão creio que é assim
  case FTipo of
    tdFirebird:
      Result := QuotedStr(FormatDateTime('dd.mm.yyyy', _AData));

    tdOracle:
      Result := 'TO_DATE(' + QuotedStr(FormatDateTime('dd/mm/yyyy', _AData)) + ', ''DD/MM/YYYY'')';

    tdPostgreSQL:
      Result := QuotedStr(FormatDateTime('yyyy-mm-dd', _AData));
  else
    Result := QuotedStr(FormatDateTime('yyyy-mm-dd', _AData));
  end;
end;

end.
