program QuestorProject;

uses
  Vcl.Forms,
  nFrmMain_U in 'src\presentation\nFrmMain_U.pas' {nFrmMain},
  nCliente_U in 'src\domain\nCliente_U.pas',
  nPedido_U in 'src\domain\nPedido_U.pas',
  nProduto_U in 'src\domain\nProduto_U.pas',
  nPedidoItem_U in 'src\domain\nPedidoItem_U.pas',
  nFrmClientes_U in 'src\presentation\nFrmClientes_U.pas' {nFrmClientes},
  nFrmProdutos_U in 'src\presentation\nFrmProdutos_U.pas' {nFrmProdutos},
  nFrmPedidos_U in 'src\presentation\nFrmPedidos_U.pas' {nFrmPedidos},
  nFrmSqlPreview_U in 'src\presentation\nFrmSqlPreview_U.pas' {nFrmSqlPreview},
  nRepositorioMem_U in 'src\infrastructure\nRepositorioMem_U.pas',
  nSqlBuilder_U in 'src\infrastructure\nSqlBuilder_U.pas',
  nSqlDialeto_U in 'src\infrastructure\nSqlDialeto_U.pas',
  nFrmClienteCadastro_U in 'src\presentation\nFrmClienteCadastro_U.pas' {nFrmClienteCadastro},
  nFrmProdutoCadastro_U in 'src\presentation\nFrmProdutoCadastro_U.pas' {nFrmProdutoCadastro},
  nFrmPedidoCadastro_U in 'src\presentation\nFrmPedidoCadastro_U.pas' {nFrmPedidoCadastro},
  nExportador_U in 'src\infrastructure\nExportador_U.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TnFrmMain, nFrmMain);
  Application.Run;
end.
