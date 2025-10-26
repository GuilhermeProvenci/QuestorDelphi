object nFrmProdutos: TnFrmProdutos
  Left = 0
  Top = 0
  Caption = 'Cadastro de Produtos'
  ClientHeight = 500
  ClientWidth = 800
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsMDIChild
  Position = poScreenCenter
  Visible = True
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 13
  object PanelTop: TPanel
    Left = 0
    Top = 0
    Width = 800
    Height = 50
    Align = alTop
    BevelOuter = bvNone
    Color = 8404992
    ParentBackground = False
    TabOrder = 0
    object LabelTitulo: TLabel
      Left = 16
      Top = 15
      Width = 176
      Height = 19
      Caption = 'Cadastro de Produtos'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object PanelFiltro: TPanel
    Left = 0
    Top = 50
    Width = 800
    Height = 60
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object LabelFiltro: TLabel
      Left = 16
      Top = 14
      Width = 80
      Height = 13
      Caption = 'Filtrar por texto:'
    end
    object EditFiltro: TEdit
      Left = 16
      Top = 30
      Width = 300
      Height = 21
      TabOrder = 0
      TextHint = 'Digite a descri'#231#227'o para filtrar...'
    end
    object CheckBoxSomenteAtivos: TCheckBox
      Left = 330
      Top = 32
      Width = 120
      Height = 17
      Caption = 'Somente ativos'
      Checked = True
      State = cbChecked
      TabOrder = 1
    end
    object ButtonFiltrar: TButton
      Left = 460
      Top = 28
      Width = 100
      Height = 25
      Caption = 'Filtrar'
      TabOrder = 2
      OnClick = ButtonFiltrarClick
    end
  end
  object PanelGrid: TPanel
    Left = 0
    Top = 110
    Width = 800
    Height = 340
    Align = alClient
    BevelOuter = bvNone
    Caption = 'PanelGrid'
    TabOrder = 2
    object GridProdutos: TDBGrid
      Left = 0
      Top = 0
      Width = 800
      Height = 340
      Align = alClient
      DataSource = DataSource
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      OnDblClick = GridProdutosDblClick
    end
  end
  object PanelButtons: TPanel
    Left = 0
    Top = 450
    Width = 800
    Height = 50
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 3
    object ButtonNovo: TButton
      Left = 16
      Top = 12
      Width = 100
      Height = 30
      Caption = 'Novo'
      TabOrder = 0
      OnClick = ButtonNovoClick
    end
    object ButtonEditar: TButton
      Left = 122
      Top = 12
      Width = 100
      Height = 30
      Caption = 'Editar'
      TabOrder = 1
      OnClick = ButtonEditarClick
    end
    object ButtonExcluir: TButton
      Left = 228
      Top = 12
      Width = 100
      Height = 30
      Caption = 'Excluir'
      TabOrder = 2
      OnClick = ButtonExcluirClick
    end
    object ButtonFechar: TButton
      Left = 684
      Top = 12
      Width = 100
      Height = 30
      Caption = 'Fechar'
      TabOrder = 3
      OnClick = ButtonFecharClick
    end
  end
  object DataSource: TDataSource
    DataSet = MemTableProdutos
    Left = 712
    Top = 238
  end
  object MemTableProdutos: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 712
    Top = 176
  end
end
