unit nFrmClientes_U;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Grids, System.Generics.Collections,
  nCliente_U, Data.DB, Vcl.DBGrids, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Comp.DataSet, FireDAC.Comp.Client, system.StrUtils;

type
  TnFrmClientes = class(TForm)
    PanelTop: TPanel;
    LabelTitulo: TLabel;
    PanelGrid: TPanel;
    GridClientes: TDBGrid;
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
    DataSourceClientes: TDataSource;
    MemTableClientes: TFDMemTable;

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ButtonNovoClick(Sender: TObject);
    procedure ButtonEditarClick(Sender: TObject);
    procedure ButtonExcluirClick(Sender: TObject);
    procedure ButtonFecharClick(Sender: TObject);
    procedure ButtonFiltrarClick(Sender: TObject);
    procedure GridClientesDblClick(Sender: TObject);
  private
    FClientesFiltrados: TObjectList<TnCliente>;

    procedure CarregarClientes;
    procedure PreencherGrid(const _AClientes: TObjectList<TnCliente>);
    function ObterClienteSelecionado: TnCliente;
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses
  nRepositorioMem_U, nFrmClienteCadastro_U;

{ TnFrmClientes }

procedure TnFrmClientes.FormCreate(Sender: TObject);
begin
  FClientesFiltrados := TObjectList<TnCliente>.Create(False);
  CarregarClientes;
end;

procedure TnFrmClientes.FormDestroy;
begin
  FClientesFiltrados.Free;
end;

procedure TnFrmClientes.CarregarClientes;
var
  ARepositorio: TnRepositorioMem;
  AClientes: TObjectList<TnCliente>;
  ACliente: TnCliente;
begin
  ARepositorio := TnRepositorioMem.Instancia;
  AClientes := ARepositorio.ListarClientes;

  FClientesFiltrados.Clear;

  for ACliente in AClientes do
    FClientesFiltrados.Add(ACliente);

  PreencherGrid(FClientesFiltrados);
end;

procedure TnFrmClientes.PreencherGrid(const _AClientes: TObjectList<TnCliente>);
var
  ACliente: TnCliente;
begin
  MemTableClientes.DisableControls;
  try
    //creio que isso seria melhor no create, mas para fins didaticos pode ser aqui
    if not MemTableClientes.Active then
    begin
      MemTableClientes.FieldDefs.Clear;
      MemTableClientes.FieldDefs.Add('CodigoCliente', ftInteger);
      MemTableClientes.FieldDefs.Add('Nome', ftString, 100);
      MemTableClientes.FieldDefs.Add('CpfCnpj', ftString, 20);
      MemTableClientes.FieldDefs.Add('Ativo', ftString, 3);
      MemTableClientes.CreateDataSet;
    end
    else
      MemTableClientes.EmptyDataSet;

    for ACliente in _AClientes do
    begin
      MemTableClientes.Append;
      MemTableClientes.FieldByName('CodigoCliente').AsInteger := ACliente.CodigoCliente;
      MemTableClientes.FieldByName('Nome').AsString := ACliente.Nome;
      MemTableClientes.FieldByName('CpfCnpj').AsString := ACliente.CpfCnpj;
      MemTableClientes.FieldByName('Ativo').AsString := IfThen(ACliente.Ativo, 'Sim', 'Não');
      MemTableClientes.Post;
    end;

    MemTableClientes.First;
    MemTableClientes.active := true;
    MemTableClientes.open;

  finally
    MemTableClientes.EnableControls;
  end;

  GridClientes.Refresh;
end;

function TnFrmClientes.ObterClienteSelecionado: TnCliente;
var
  ACodigoCliente: Integer;
  ARepositorio: TnRepositorioMem;
begin
  Result := nil;

  if MemTableClientes.IsEmpty then
    Exit;

  ACodigoCliente := MemTableClientes.FieldByName('CodigoCliente').AsInteger;

  if ACodigoCliente <= 0 then
    Exit;

  ARepositorio := TnRepositorioMem.Instancia;
  Result := ARepositorio.ObterCliente(ACodigoCliente);
end;

procedure TnFrmClientes.ButtonNovoClick(Sender: TObject);
var
  ACliente: TnCliente;
  AForm: TnFrmClienteCadastro;
begin
  ACliente := TnCliente.Create;
  try
    AForm := TnFrmClienteCadastro.Create(Self);
    try
      AForm.Visible := false;
      AForm.SetCliente(ACliente);

      if AForm.ShowModal = mrOk then
        CarregarClientes;
    finally
      AForm.Free;
    end;
  except
    ACliente.Free;
    raise;
  end;
end;

procedure TnFrmClientes.ButtonEditarClick(Sender: TObject);
var
  ACliente: TnCliente;
  AForm: TnFrmClienteCadastro;
begin
  ACliente := ObterClienteSelecionado;

  if not Assigned(ACliente) then
  begin
    ShowMessage('Selecione um cliente para editar.');
    Exit;
  end;

  AForm := TnFrmClienteCadastro.Create(Self);
  try
    AForm.Visible := false;
    AForm.SetCliente(ACliente);

    if AForm.ShowModal = mrOk then
      CarregarClientes;
  finally
    AForm.Free;
  end;
end;

procedure TnFrmClientes.ButtonExcluirClick(Sender: TObject);
var
  ACliente: TnCliente;
  ARepositorio: TnRepositorioMem;
begin
  ACliente := ObterClienteSelecionado;

  if not Assigned(ACliente) then
  begin
    ShowMessage('Selecione um cliente para excluir.');
    Exit;
  end;

  if MessageDlg('Deseja realmente excluir o cliente ' + ACliente.Nome + '?',
                 mtConfirmation, [mbYes, mbNo], 0 ) = mrYes then
  begin
    ARepositorio := TnRepositorioMem.Instancia;
    ARepositorio.ExcluirCliente(ACliente.CodigoCliente);
    CarregarClientes;
    ShowMessage('Cliente excluído com sucesso!');
  end;
end;

procedure TnFrmClientes.ButtonFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TnFrmClientes.ButtonFiltrarClick(Sender: TObject);
var
  ARepositorio: TnRepositorioMem;
  ATodosClientes: TObjectList<TnCliente>;
  ACliente: TnCliente;
  ATextoFiltro: string;
begin
  FClientesFiltrados.Clear;

  ARepositorio := TnRepositorioMem.Instancia;
  ATodosClientes := ARepositorio.ListarClientes;

  ATextoFiltro := Trim(UpperCase(EditFiltro.Text));

  for ACliente in ATodosClientes do
  begin
    if CheckBoxSomenteAtivos.Checked and (not ACliente.Ativo) then
      Continue;

    if ATextoFiltro <> '' then
    begin
      if not ( (Pos(ATextoFiltro, UpperCase(ACliente.Nome)) > 0) or
        (Pos(ATextoFiltro, UpperCase(ACliente.CpfCnpj)) > 0) ) then
        Continue;
    end;

    FClientesFiltrados.Add(ACliente);
  end;

  PreencherGrid(FClientesFiltrados);
end;

procedure TnFrmClientes.GridClientesDblClick(Sender: TObject);
begin
  ButtonEditarClick(Sender);
end;

end.
