object nFrmProdutoCadastro: TnFrmProdutoCadastro
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Cadastro de Produto'
  ClientHeight = 280
  ClientWidth = 500
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  TextHeight = 13
  object PanelTop: TPanel
    Left = 0
    Top = 0
    Width = 500
    Height = 50
    Align = alTop
    BevelOuter = bvNone
    Color = 8404992
    ParentBackground = False
    TabOrder = 0
    object LabelTitulo: TLabel
      Left = 16
      Top = 15
      Width = 111
      Height = 19
      Caption = 'Novo Produto'
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
    Width = 500
    Height = 180
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object LabelDescricao: TLabel
      Left = 16
      Top = 20
      Width = 50
      Height = 13
      Caption = 'Descri'#231#227'o:'
    end
    object LabelPrecoUnit: TLabel
      Left = 16
      Top = 80
      Width = 71
      Height = 13
      Caption = 'Pre'#231'o Unit'#225'rio:'
    end
    object EditDescricao: TEdit
      Left = 16
      Top = 39
      Width = 460
      Height = 21
      MaxLength = 100
      TabOrder = 0
    end
    object EditPrecoUnit: TEdit
      Left = 16
      Top = 99
      Width = 150
      Height = 21
      TabOrder = 1
      TextHint = '0,00'
    end
    object CheckBoxAtivo: TCheckBox
      Left = 180
      Top = 101
      Width = 97
      Height = 17
      Caption = 'Ativo'
      Checked = True
      State = cbChecked
      TabOrder = 2
    end
  end
  object PanelButtons: TPanel
    Left = 0
    Top = 230
    Width = 500
    Height = 50
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    object ButtonSalvar: TButton
      Left = 280
      Top = 10
      Width = 100
      Height = 30
      Caption = 'Salvar'
      Default = True
      TabOrder = 0
      OnClick = ButtonSalvarClick
    end
    object ButtonCancelar: TButton
      Left = 390
      Top = 10
      Width = 100
      Height = 30
      Cancel = True
      Caption = 'Cancelar'
      TabOrder = 1
      OnClick = ButtonCancelarClick
    end
  end
end
