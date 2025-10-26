unit nFrmClienteCadastro_U;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ExtCtrls, nCliente_U;

type
  TnFrmClienteCadastro = class(TForm)
    PanelTop: TPanel;
    LabelTitulo: TLabel;
    PanelDados: TPanel;
    LabelNome: TLabel;
    EditNome: TEdit;
    LabelCpfCnpj: TLabel;
    EditCpfCnpj: TEdit;
    CheckBoxAtivo: TCheckBox;
    PanelButtons: TPanel;
    ButtonSalvar: TButton;
    ButtonCancelar: TButton;

    procedure FormCreate(Sender: TObject);
    procedure ButtonSalvarClick(Sender: TObject);
    procedure ButtonCancelarClick(Sender: TObject);
  private
    FCliente: TnCliente;
    FNovo: Boolean;

    procedure CarregarDados;
    function ValidarDados: Boolean;
    procedure SalvarDados;
  public
    procedure SetCliente(const _ACliente: TnCliente);
  end;

implementation

{$R *.dfm}

uses
  nRepositorioMem_U;

{ TnFrmClienteCadastro }

procedure TnFrmClienteCadastro.FormCreate(Sender: TObject);
begin
  FCliente := nil;
  FNovo := False;
end;

procedure TnFrmClienteCadastro.SetCliente(const _ACliente: TnCliente);
begin
  FCliente := _ACliente;
  FNovo := (FCliente.CodigoCliente = 0);

  if FNovo then
    LabelTitulo.Caption := 'Novo Cliente'
  else
    LabelTitulo.Caption := 'Editar Cliente';

  CarregarDados;
end;

procedure TnFrmClienteCadastro.CarregarDados;
begin
  if not Assigned(FCliente) then
    Exit;

  EditNome.Text := FCliente.Nome;
  EditCpfCnpj.Text := FCliente.CpfCnpj;
  CheckBoxAtivo.Checked := FCliente.Ativo;
end;

function TnFrmClienteCadastro.ValidarDados: Boolean;
begin
  Result := False;

  if Trim(EditNome.Text) = '' then
  begin
    ShowMessage('Nome é obrigatório.');
    EditNome.SetFocus;
    Exit;
  end;

  if Trim(EditCpfCnpj.Text) = '' then
  begin
    ShowMessage('CPF/CNPJ é obrigatório.');
    EditCpfCnpj.SetFocus;
    Exit;
  end;

  Result := True;
end;

procedure TnFrmClienteCadastro.SalvarDados;
begin
  FCliente.Nome := Trim(EditNome.Text);
  FCliente.CpfCnpj := Trim(EditCpfCnpj.Text);
  FCliente.Ativo := CheckBoxAtivo.Checked;
end;

procedure TnFrmClienteCadastro.ButtonSalvarClick(Sender: TObject);
var
  ARepositorio: TnRepositorioMem;
begin
  if not ValidarDados then
    Exit;

  try
    SalvarDados;

    ARepositorio := TnRepositorioMem.Instancia;
    ARepositorio.SalvarCliente(FCliente);

    ShowMessage('Cliente salvo com sucesso!');
    ModalResult := mrOk;
  except
    on E: Exception do
      ShowMessage('Erro ao salvar cliente: ' + E.Message);
  end;
end;

procedure TnFrmClienteCadastro.ButtonCancelarClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

end.
