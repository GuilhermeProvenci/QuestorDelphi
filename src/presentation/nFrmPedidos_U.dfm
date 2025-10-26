object nFrmPedidos: TnFrmPedidos
  Left = 0
  Top = 0
  Caption = 'Consulta de Pedidos'
  ClientHeight = 600
  ClientWidth = 1021
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
    Width = 1021
    Height = 50
    Align = alTop
    BevelOuter = bvNone
    Color = 8404992
    ParentBackground = False
    TabOrder = 0
    object LabelTitulo: TLabel
      Left = 16
      Top = 15
      Width = 165
      Height = 19
      Caption = 'Consulta de Pedidos'
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
    Width = 1021
    Height = 70
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object LabelCliente: TLabel
      Left = 16
      Top = 14
      Width = 37
      Height = 13
      Caption = 'Cliente:'
    end
    object LabelStatus: TLabel
      Left = 280
      Top = 14
      Width = 35
      Height = 13
      Caption = 'Status:'
    end
    object LabelPeriodo: TLabel
      Left = 450
      Top = 14
      Width = 36
      Height = 13
      Caption = 'Per'#237'odo'
    end
    object LabelAte: TLabel
      Left = 565
      Top = 34
      Width = 16
      Height = 13
      Caption = 'at'#233
    end
    object LabelBusca: TLabel
      Left = 710
      Top = 14
      Width = 55
      Height = 13
      Caption = 'Texto livre:'
    end
    object ComboBoxCliente: TComboBox
      Left = 16
      Top = 30
      Width = 250
      Height = 21
      Style = csDropDownList
      TabOrder = 0
    end
    object ComboBoxStatus: TComboBox
      Left = 280
      Top = 30
      Width = 150
      Height = 21
      Style = csDropDownList
      ItemIndex = 0
      TabOrder = 1
      Text = 'Todos'
      Items.Strings = (
        'Todos'
        'ABERTO'
        'FATURADO'
        'CANCELADO')
    end
    object DateTimePickerInicio: TDateTimePicker
      Left = 450
      Top = 30
      Width = 110
      Height = 21
      Date = 45954.000000000000000000
      Time = 0.695676122682925800
      TabOrder = 2
    end
    object DateTimePickerFim: TDateTimePicker
      Left = 585
      Top = 30
      Width = 110
      Height = 21
      Date = 45954.000000000000000000
      Time = 0.695676134258974300
      TabOrder = 3
    end
    object EditFiltro: TEdit
      Left = 710
      Top = 30
      Width = 170
      Height = 21
      TabOrder = 4
      TextHint = 'N'#186' Pedido ou Nome...'
    end
    object ButtonFiltrar: TButton
      Left = 892
      Top = 28
      Width = 100
      Height = 25
      Caption = 'Filtrar'
      TabOrder = 5
      OnClick = ButtonFiltrarClick
    end
  end
  object PanelGrids: TPanel
    Left = 0
    Top = 120
    Width = 1021
    Height = 430
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
    object Splitter1: TSplitter
      Left = 0
      Top = 250
      Width = 1021
      Height = 5
      Cursor = crVSplit
      Align = alTop
      ExplicitWidth = 900
    end
    object PanelPedidos: TPanel
      Left = 0
      Top = 0
      Width = 1021
      Height = 250
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      object LabelPedidos: TLabel
        Left = 16
        Top = 4
        Width = 81
        Height = 13
        Caption = 'Lista de Pedidos:'
      end
      object StringGridPedidos: TDBGrid
        Left = 0
        Top = 0
        Width = 1021
        Height = 250
        Align = alClient
        DataSource = DataSourcePedidos
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
      end
    end
    object PanelItens: TPanel
      Left = 0
      Top = 255
      Width = 1021
      Height = 175
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      object LabelItens: TLabel
        Left = 16
        Top = 4
        Width = 79
        Height = 13
        Caption = 'Itens do Pedido:'
      end
      object StringGridItens: TDBGrid
        Left = 0
        Top = 0
        Width = 1021
        Height = 175
        Align = alClient
        DataSource = DataSourceItens
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
      end
    end
  end
  object PanelButtons: TPanel
    Left = 0
    Top = 550
    Width = 1021
    Height = 50
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 3
    DesignSize = (
      1021
      50)
    object ButtonNovo: TButton
      Left = 16
      Top = 10
      Width = 90
      Height = 30
      Caption = 'Novo'
      TabOrder = 0
      OnClick = ButtonNovoClick
    end
    object ButtonEditar: TButton
      Left = 112
      Top = 10
      Width = 90
      Height = 30
      Caption = 'Editar'
      TabOrder = 1
      OnClick = ButtonEditarClick
    end
    object ButtonExcluir: TButton
      Left = 208
      Top = 10
      Width = 90
      Height = 30
      Caption = 'Excluir'
      TabOrder = 2
      OnClick = ButtonExcluirClick
    end
    object ButtonFaturar: TButton
      Left = 304
      Top = 10
      Width = 90
      Height = 30
      Caption = 'Faturar'
      TabOrder = 3
      OnClick = ButtonFaturarClick
    end
    object ButtonExportar: TButton
      Left = 400
      Top = 10
      Width = 90
      Height = 30
      Caption = 'Exportar'
      TabOrder = 4
      OnClick = ButtonExportarClick
    end
    object ButtonFechar: TButton
      Left = 902
      Top = 10
      Width = 90
      Height = 30
      Anchors = [akTop, akRight]
      Caption = 'Fechar'
      TabOrder = 5
      OnClick = ButtonFecharClick
    end
  end
  object DataSourceItens: TDataSource
    DataSet = MemTableItens
    Left = 424
    Top = 448
  end
  object DataSourcePedidos: TDataSource
    DataSet = MemTablePedidos
    OnDataChange = DataSourcePedidosDataChange
    Left = 496
    Top = 288
  end
  object MemTablePedidos: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 632
    Top = 288
  end
  object MemTableItens: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 520
    Top = 448
  end
end
