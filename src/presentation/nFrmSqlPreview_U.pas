unit nFrmSqlPreview_U;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Grids;

type
  TnFrmSqlPreview = class(TForm)
    PanelTop: TPanel;
    LabelDialeto: TLabel;
    ComboBoxDialeto: TComboBox;
    PanelFiltros: TPanel;
    GroupBoxFiltros: TGroupBox;
    CheckBoxFiltroData: TCheckBox;
    DateTimePickerInicio: TDateTimePicker;
    LabelAte: TLabel;
    DateTimePickerFim: TDateTimePicker;
    CheckBoxFiltroCliente: TCheckBox;
    ComboBoxCliente: TComboBox;
    CheckBoxFiltroStatus: TCheckBox;
    ComboBoxStatus: TComboBox;
    CheckBoxTextoLivre: TCheckBox;
    EditTextoLivre: TEdit;
    LabelOrdenacao: TLabel;
    RadioGroupOrdenacao: TRadioGroup;
    ButtonGerar: TButton;
    ButtonCopiar: TButton;
    PanelSql: TPanel;
    LabelSql: TLabel;
    MemoSql: TMemo;
    PanelParametros: TPanel;
    LabelParametros: TLabel;
    StringGridParametros: TStringGrid;
    procedure FormCreate(Sender: TObject);
    procedure ButtonGerarClick(Sender: TObject);
    procedure ButtonCopiarClick(Sender: TObject);
  private
    procedure CarregarClientes;
    procedure ConfigurarGridParametros;
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses
  nSqlBuilder_U, nSqlDialeto_U, nRepositorioMem_U, nCliente_U,
  Vcl.Clipbrd, System.Generics.Collections;

{ TnFrmSqlPreview }

procedure TnFrmSqlPreview.FormCreate(Sender: TObject);
begin
  DateTimePickerInicio.Date := IncMonth(Now, -1);
  DateTimePickerFim.Date := Now;

  ConfigurarGridParametros;
  CarregarClientes;
end;

procedure TnFrmSqlPreview.ConfigurarGridParametros;
begin
  with StringGridParametros do
  begin
    Cells[0, 0] := 'Parâmetro';
    Cells[1, 0] := 'Valor';
  end;
end;

procedure TnFrmSqlPreview.CarregarClientes;
var
  ARepositorio: TnRepositorioMem;
  AClientes: TObjectList<TnCliente>;
  ACliente: TnCliente;
begin
  ComboBoxCliente.Items.Clear;

  ARepositorio := TnRepositorioMem.Instancia;
  AClientes := ARepositorio.ListarClientes;

  for ACliente in AClientes do
    ComboBoxCliente.Items.AddObject(ACliente.Nome, TObject(ACliente.CodigoCliente));

  if ComboBoxCliente.Items.Count > 0 then
    ComboBoxCliente.ItemIndex := 0;
end;

procedure TnFrmSqlPreview.ButtonGerarClick(Sender: TObject);
var
  ABuilder: TnSqlBuilder;
  ADialeto: TnSqlDialeto;
  AFiltros: TnFiltrosPedido;
  AOrdenacao: TnOrdenacao;
  ASql: string;
  ATipoDialeto: TnTipoDialeto;
  ARow: Integer;
  AParam: string;
begin
  case ComboBoxDialeto.ItemIndex of
    0: ATipoDialeto := tdFirebird;
    1: ATipoDialeto := tdOracle;
    2: ATipoDialeto := tdPostgreSQL;
  else
    ATipoDialeto := tdFirebird;
  end;

  ADialeto := TnSqlDialeto.Create(ATipoDialeto);
  try
    ABuilder := TnSqlBuilder.Create(ADialeto);
    try
      //filtros
      FillChar(AFiltros, SizeOf(AFiltros), 0);

      if CheckBoxFiltroData.Checked then
      begin
        AFiltros.DataInicio := DateTimePickerInicio.Date;
        AFiltros.DataFim := DateTimePickerFim.Date;
        AFiltros.UsarDataInicio := True;
        AFiltros.UsarDataFim := True;
      end;

      if CheckBoxFiltroCliente.Checked and
         (ComboBoxCliente.ItemIndex >= 0) then
      begin
        AFiltros.CodigoCliente := Integer(ComboBoxCliente.Items.Objects[ComboBoxCliente.ItemIndex]);
        AFiltros.UsarCliente := True;
      end;

      if CheckBoxFiltroStatus.Checked then
      begin
        AFiltros.Status := ComboBoxStatus.Text;
        AFiltros.UsarStatus := True;
      end;

      if CheckBoxTextoLivre.Checked and
         (Trim(EditTextoLivre.Text) <> '') then
      begin
        AFiltros.TextoLivre := Trim(EditTextoLivre.Text);
        AFiltros.UsarTextoLivre := True;
      end;

      if RadioGroupOrdenacao.ItemIndex = 0 then
        AOrdenacao := orDataEmissao
      else
        AOrdenacao := orNumero;

      //sql
      ASql := ABuilder.GerarSelectPedidos(AFiltros, AOrdenacao);
      MemoSql.Lines.Text := ASql;

      StringGridParametros.RowCount := ABuilder.Parametros.Count + 1;
      ARow := 1;

      for AParam in ABuilder.Parametros.Keys do
      begin
        StringGridParametros.Cells[0, ARow] := AParam;
        StringGridParametros.Cells[1, ARow] := VarToStr(ABuilder.Parametros[AParam]);
        Inc(ARow);
      end;

      if ABuilder.Parametros.Count = 0 then
      begin
        StringGridParametros.RowCount := 2;
        StringGridParametros.Cells[0, 1] := '(Nenhum parâmetro)';
        StringGridParametros.Cells[1, 1] := '';
      end;

    finally
      ABuilder.Free;
    end;
  finally
    ADialeto.Free;
  end;
end;

procedure TnFrmSqlPreview.ButtonCopiarClick(Sender: TObject);
begin
  if Trim(MemoSql.Lines.Text) = '' then
  begin
    ShowMessage('Gere o SQL primeiro antes de copiar.');
    exit;
  end;

  Clipboard.AsText := MemoSql.Lines.Text;
  ShowMessage('SQL copiado para a área de transferência!');
end;

end.
