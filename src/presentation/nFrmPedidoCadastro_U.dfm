object nFrmPedidoCadastro: TnFrmPedidoCadastro
  Left = 0
  Top = 0
  Caption = 'Cadastro de Pedido'
  ClientHeight = 600
  ClientWidth = 800
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  TextHeight = 15
  object PanelTop: TPanel
    Left = 0
    Top = 0
    Width = 800
    Height = 50
    Align = alTop
    Color = 8404992
    ParentBackground = False
    TabOrder = 0
    object LabelTitulo: TLabel
      Left = 16
      Top = 15
      Width = 159
      Height = 19
      Caption = 'Cadastro de Pedido'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object PanelDados: TPanel
    Left = 0
    Top = 50
    Width = 800
    Height = 130
    Align = alTop
    TabOrder = 1
    object LabelNumero: TLabel
      Left = 20
      Top = 20
      Width = 47
      Height = 15
      Caption = 'N'#250'mero:'
    end
    object LabelCliente: TLabel
      Left = 20
      Top = 50
      Width = 40
      Height = 15
      Caption = 'Cliente:'
    end
    object LabelDataEmissao: TLabel
      Left = 400
      Top = 50
      Width = 73
      Height = 15
      Caption = 'Data Emiss'#227'o:'
    end
    object LabelStatus: TLabel
      Left = 400
      Top = 20
      Width = 35
      Height = 15
      Caption = 'Status:'
    end
    object EditNumero: TEdit
      Left = 80
      Top = 16
      Width = 150
      Height = 23
      TabOrder = 0
    end
    object ComboBoxCliente: TComboBox
      Left = 80
      Top = 48
      Width = 300
      Height = 23
      TabOrder = 1
    end
    object DateTimePickerEmissao: TDateTimePicker
      Left = 500
      Top = 48
      Width = 186
      Height = 23
      Date = 45955.000000000000000000
      Time = 0.565145868058607400
      TabOrder = 2
    end
    object ComboBoxStatus: TComboBox
      Left = 500
      Top = 16
      Width = 150
      Height = 23
      ItemIndex = 0
      TabOrder = 3
      Text = 'Aberto'
      Items.Strings = (
        'Aberto'
        'Faturado'
        'Cancelado')
    end
  end
  object PanelItens: TPanel
    Left = 0
    Top = 180
    Width = 800
    Height = 370
    Align = alClient
    TabOrder = 2
    object GridItens: TDBGrid
      Left = 1
      Top = 1
      Width = 798
      Height = 328
      Align = alClient
      DataSource = DataSourceItens
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -12
      TitleFont.Name = 'Segoe UI'
      TitleFont.Style = []
    end
    object PanelBotoesItens: TPanel
      Left = 1
      Top = 329
      Width = 798
      Height = 40
      Align = alBottom
      TabOrder = 1
      object LabelTotal: TLabel
        Left = 600
        Top = 12
        Width = 68
        Height = 15
        Caption = 'Total: R$ 0,00'
      end
      object ButtonAdicionarItem: TButton
        Left = 10
        Top = 8
        Width = 95
        Height = 25
        Caption = 'Adicionar Item'
        TabOrder = 0
        OnClick = ButtonAdicionarItemClick
      end
      object ButtonRemoverItem: TButton
        Left = 130
        Top = 8
        Width = 95
        Height = 25
        Caption = 'Remover Item'
        TabOrder = 1
        OnClick = ButtonRemoverItemClick
      end
    end
  end
  object PanelBottom: TPanel
    Left = 0
    Top = 550
    Width = 800
    Height = 50
    Align = alBottom
    TabOrder = 3
    object ButtonSalvar: TButton
      Left = 600
      Top = 10
      Width = 75
      Height = 25
      Caption = 'Salvar'
      TabOrder = 0
      OnClick = ButtonSalvarClick
    end
    object ButtonCancelar: TButton
      Left = 700
      Top = 10
      Width = 75
      Height = 25
      Caption = 'Cancelar'
      TabOrder = 1
      OnClick = ButtonCancelarClick
    end
  end
  object MemTableItens: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 600
    Top = 264
  end
  object DataSourceItens: TDataSource
    DataSet = MemTableItens
    Left = 600
    Top = 328
  end
end
