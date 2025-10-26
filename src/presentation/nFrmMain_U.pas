unit nFrmMain_U;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.Menus, Vcl.ExtCtrls, Vcl.StdCtrls;

type
  TnFrmMain = class(TForm)
    MainMenu1: TMainMenu;
    MenuCadastros: TMenuItem;
    MenuClientes: TMenuItem;
    MenuProdutos: TMenuItem;
    MenuPedidos: TMenuItem;
    MenuSqlPreview: TMenuItem;
    MenuSeparador: TMenuItem;
    MenuSair: TMenuItem;
    Label1: TLabel;
    procedure MenuClientesClick(Sender: TObject);
    procedure MenuProdutosClick(Sender: TObject);
    procedure MenuPedidosClick(Sender: TObject);
    procedure MenuSqlPreviewClick(Sender: TObject);
    procedure MenuSairClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  nFrmMain: TnFrmMain;

implementation

{$R *.dfm}

uses
  nRepositorioMem_U, nCliente_U, nProduto_U, nFrmClientes_U,nFrmProdutos_U,
  nFrmPedidos_U, nFrmSqlPreview_U;

procedure TnFrmMain.MenuClientesClick(Sender: TObject);
var
  AForm: TnFrmClientes;
begin
  AForm := TnFrmClientes.Create(Self);
  AForm.Show;
end;

procedure TnFrmMain.MenuProdutosClick(Sender: TObject);
var
  AForm: TnFrmProdutos;
begin
  AForm := TnFrmProdutos.Create(Self);
  AForm.Show;
end;

procedure TnFrmMain.MenuPedidosClick(Sender: TObject);
var
  AForm: TnFrmPedidos;
begin
  AForm := TnFrmPedidos.Create(Self);
  AForm.Show;
end;

procedure TnFrmMain.MenuSqlPreviewClick(Sender: TObject);
var
  AForm: TnFrmSqlPreview;
begin
  AForm := TnFrmSqlPreview.Create(Self);
  AForm.Show;
end;

procedure TnFrmMain.MenuSairClick(Sender: TObject);
begin
  Close;
end;

end.
