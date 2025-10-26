unit nFrmProdutos_U;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Grids, System.Generics.Collections,
  nProduto_U, Data.DB, Vcl.DBGrids, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Comp.DataSet, FireDAC.Comp.Client, System.StrUtils;

type
  TnFrmProdutos = class(TForm)
    PanelTop: TPanel;
    LabelTitulo: TLabel;
    PanelGrid: TPanel;
    GridProdutos: TDBGrid;
    PanelButtons: TPanel;
    ButtonNovo: TButton;
    ButtonEditar: TButton;
    ButtonExcluir: TButton;
    ButtonFechar: TButton;
    PanelFiltro: TPanel;
    LabelFiltro: TLabel;
    EditFiltro: TEdit;
    CheckBoxSomenteAtivos: TCheckBox;
    ButtonFiltrar: TButton;
    DataSource: TDataSource;
    MemTableProdutos: TFDMemTable;

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ButtonNovoClick(Sender: TObject);
    procedure ButtonEditarClick(Sender: TObject);
    procedure ButtonExcluirClick(Sender: TObject);
    procedure ButtonFecharClick(Sender: TObject);
    procedure ButtonFiltrarClick(Sender: TObject);
    procedure GridProdutosDblClick(Sender: TObject);
  private
    FProdutosFiltrados: TObjectList<TnProduto>;

    procedure CarregarProdutos;
    procedure PreencherGrid(const _AProdutos: TObjectList<TnProduto>);
    function ObterProdutoSelecionado: TnProduto;
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses
  nRepositorioMem_U, nFrmProdutoCadastro_U;

{ TnFrmProdutos }

procedure TnFrmProdutos.FormCreate(Sender: TObject);
begin
  FProdutosFiltrados := TObjectList<TnProduto>.Create(False);
  CarregarProdutos;
end;

procedure TnFrmProdutos.FormDestroy;
begin
  FProdutosFiltrados.Free;
end;

procedure TnFrmProdutos.CarregarProdutos;
var
  ARepositorio: TnRepositorioMem;
  AProdutos: TObjectList<TnProduto>;
begin
  ARepositorio := TnRepositorioMem.Instancia;
  AProdutos := ARepositorio.ListarProdutos;

  FProdutosFiltrados.Clear;
  FProdutosFiltrados.AddRange(AProdutos);

  PreencherGrid(FProdutosFiltrados);
end;

procedure TnFrmProdutos.PreencherGrid(const _AProdutos: TObjectList<TnProduto>);
var
  AProduto: TnProduto;
begin
  MemTableProdutos.DisableControls;
  try
    MemTableProdutos.Close;
    MemTableProdutos.FieldDefs.Clear;

    MemTableProdutos.FieldDefs.Add('CodigoProduto', ftInteger);
    MemTableProdutos.FieldDefs.Add('Descricao', ftString, 100);
    MemTableProdutos.FieldDefs.Add('PrecoUnit', ftCurrency);
    MemTableProdutos.FieldDefs.Add('Ativo', ftString, 3);

    MemTableProdutos.CreateDataSet;

    for AProduto in _AProdutos do
    begin
      MemTableProdutos.Append;
      MemTableProdutos.FieldByName('CodigoProduto').AsInteger := AProduto.CodigoProduto;
      MemTableProdutos.FieldByName('Descricao').AsString := AProduto.Descricao;
      MemTableProdutos.FieldByName('PrecoUnit').AsCurrency := AProduto.PrecoUnit;
      MemTableProdutos.FieldByName('Ativo').AsString := IfThen(AProduto.Ativo, 'Sim', 'Não');
      MemTableProdutos.Post;
    end;

    MemTableProdutos.First;
  finally
    MemTableProdutos.EnableControls;
  end;
end;

function TnFrmProdutos.ObterProdutoSelecionado: TnProduto;
var
  ACodigoProduto: Integer;
  ARepositorio: TnRepositorioMem;
begin
  Result := nil;

  if (not Assigned(MemTableProdutos)) or (MemTableProdutos.IsEmpty) then
    Exit;

  ACodigoProduto := MemTableProdutos.FieldByName('CodigoProduto').AsInteger;

  if ACodigoProduto <= 0 then
    Exit;

  ARepositorio := TnRepositorioMem.Instancia;
  Result := ARepositorio.ObterProduto(ACodigoProduto);
end;

procedure TnFrmProdutos.ButtonNovoClick(Sender: TObject);
var
  AProduto: TnProduto;
  AForm: TnFrmProdutoCadastro;
begin
  AProduto := TnProduto.Create;
  try
    AForm := TnFrmProdutoCadastro.Create(Self);
    try
      AForm.Visible := false;
      AForm.SetProduto(AProduto);

      if AForm.ShowModal = mrOk then
        CarregarProdutos;
    finally
      AForm.Free;
    end;
  except
    AProduto.Free;
    raise;
  end;
end;

procedure TnFrmProdutos.ButtonEditarClick(Sender: TObject);
var
  AProduto: TnProduto;
  AForm: TnFrmProdutoCadastro;
begin
  AProduto := ObterProdutoSelecionado;

  if not Assigned(AProduto) then
  begin
    ShowMessage('Selecione um produto para editar.');
    Exit;
  end;

  AForm := TnFrmProdutoCadastro.Create(Self);
  try
    AForm.Visible := false;
    AForm.SetProduto(AProduto);

    if AForm.ShowModal = mrOk then
      CarregarProdutos;
  finally
    AForm.Free;
  end;
end;
procedure TnFrmProdutos.ButtonExcluirClick(Sender: TObject);
var
  AProduto: TnProduto;
  ARepositorio: TnRepositorioMem;
begin
  AProduto := ObterProdutoSelecionado;

  if not Assigned(AProduto) then
  begin
    ShowMessage('Selecione um produto para excluir.');
    Exit;
  end;

  if MessageDlg('Deseja realmente excluir o produto ' + AProduto.Descricao + '?',
                 mtConfirmation, [mbYes, mbNo], 0 ) = mrYes then
  begin
    ARepositorio := TnRepositorioMem.Instancia;
    ARepositorio.ExcluirProduto(AProduto.CodigoProduto);
    CarregarProdutos;
    ShowMessage('Produto excluído com sucesso!');
  end;
end;

procedure TnFrmProdutos.ButtonFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TnFrmProdutos.ButtonFiltrarClick(Sender: TObject);
var
  ARepositorio: TnRepositorioMem;
  ATodosProdutos: TObjectList<TnProduto>;
  AProduto: TnProduto;
  ATextoFiltro: string;
begin
  FProdutosFiltrados.Clear;

  ARepositorio := TnRepositorioMem.Instancia;
  ATodosProdutos := ARepositorio.ListarProdutos;

  ATextoFiltro := Trim(UpperCase(EditFiltro.Text));

  for AProduto in ATodosProdutos do
  begin
    if CheckBoxSomenteAtivos.Checked and (not AProduto.Ativo) then
      Continue;

    if ATextoFiltro <> '' then
    begin
      if Pos(ATextoFiltro, UpperCase(AProduto.Descricao)) = 0 then
        Continue;
    end;

    FProdutosFiltrados.Add(AProduto);
  end;

  PreencherGrid(FProdutosFiltrados);
end;

procedure TnFrmProdutos.GridProdutosDblClick(Sender: TObject);
begin
  ButtonEditarClick(Sender);
end;

end.
