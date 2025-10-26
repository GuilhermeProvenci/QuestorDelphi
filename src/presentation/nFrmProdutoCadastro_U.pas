unit nFrmProdutoCadastro_U;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ExtCtrls, nProduto_U;

type
  TnFrmProdutoCadastro = class(TForm)
    PanelTop: TPanel;
    LabelTitulo: TLabel;
    PanelDados: TPanel;
    LabelDescricao: TLabel;
    EditDescricao: TEdit;
    LabelPrecoUnit: TLabel;
    EditPrecoUnit: TEdit;
    CheckBoxAtivo: TCheckBox;
    PanelButtons: TPanel;
    ButtonSalvar: TButton;
    ButtonCancelar: TButton;

    procedure FormCreate(Sender: TObject);
    procedure ButtonSalvarClick(Sender: TObject);
    procedure ButtonCancelarClick(Sender: TObject);
  private
    FProduto: TnProduto;
    FNovo: Boolean;

    procedure CarregarDados;
    function ValidarDados: Boolean;
    procedure SalvarDados;
  public
    procedure SetProduto(const _AProduto: TnProduto);
  end;

implementation

{$R *.dfm}

uses
  nRepositorioMem_U;

{ TnFrmProdutoCadastro }

procedure TnFrmProdutoCadastro.FormCreate(Sender: TObject);
begin
  FProduto := nil;
  FNovo := False;
end;

procedure TnFrmProdutoCadastro.SetProduto(const _AProduto: TnProduto);
begin
  FProduto := _AProduto;
  FNovo := (FProduto.CodigoProduto = 0);

  if FNovo then
    LabelTitulo.Caption := 'Novo Produto'
  else
    LabelTitulo.Caption := 'Editar Produto';

  CarregarDados;
end;

procedure TnFrmProdutoCadastro.CarregarDados;
begin
  if not Assigned(FProduto) then
    Exit;

  EditDescricao.Text := FProduto.Descricao;
  EditPrecoUnit.Text := FormatFloat('0.00', FProduto.PrecoUnit);
  CheckBoxAtivo.Checked := FProduto.Ativo;
end;

function TnFrmProdutoCadastro.ValidarDados: Boolean;
var
  APreco: Double;
begin
  Result := False;

  if Trim(EditDescricao.Text) = '' then
  begin
    ShowMessage('Descrição é obrigatória.');
    EditDescricao.SetFocus;
    Exit;
  end;

  if Trim(EditPrecoUnit.Text) = '' then
  begin
    ShowMessage('Preço unitário é obrigatório.');
    EditPrecoUnit.SetFocus;
    Exit;
  end;

  if not TryStrToFloat(StringReplace(EditPrecoUnit.Text, '.', '', [rfReplaceAll]), APreco) then
  begin
    if not TryStrToFloat(EditPrecoUnit.Text, APreco) then
    begin
      ShowMessage('Preço unitário inválido.');
      EditPrecoUnit.SetFocus;
      Exit;
    end;
  end;

  if APreco <= 0 then
  begin
    ShowMessage('Preço unitário deve ser maior que zero.');
    EditPrecoUnit.SetFocus;
    Exit;
  end;

  Result := True;
end;

procedure TnFrmProdutoCadastro.SalvarDados;
var
  APreco: Double;
begin
  FProduto.Descricao := Trim(EditDescricao.Text);

  if TryStrToFloat(StringReplace(EditPrecoUnit.Text, '.', '', [rfReplaceAll]), APreco) or
     TryStrToFloat(EditPrecoUnit.Text, APreco) then
    FProduto.PrecoUnit := APreco;

  FProduto.Ativo := CheckBoxAtivo.Checked;
end;

procedure TnFrmProdutoCadastro.ButtonSalvarClick(Sender: TObject);
var
  ARepositorio: TnRepositorioMem;
begin
  if not ValidarDados then
    Exit;

  try
    SalvarDados;

    ARepositorio := TnRepositorioMem.Instancia;
    ARepositorio.SalvarProduto(FProduto);

    ShowMessage('Produto salvo com sucesso!');
    ModalResult := mrOk;
  except
    on E: Exception do
      ShowMessage('Erro ao salvar produto: ' + E.Message);
  end;
end;

procedure TnFrmProdutoCadastro.ButtonCancelarClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

end.
