object nFrmClienteCadastro: TnFrmClienteCadastro
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Cadastro de Cliente'
  ClientHeight = 280
  ClientWidth = 500
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poScreenCenter
  Visible = True
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
      Width = 104
      Height = 19
      Caption = 'Novo Cliente'
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
    object LabelNome: TLabel
      Left = 16
      Top = 20
      Width = 31
      Height = 13
      Caption = 'Nome:'
    end
    object LabelCpfCnpj: TLabel
      Left = 16
      Top = 80
      Width = 52
      Height = 13
      Caption = 'CPF/CNPJ:'
    end
    object EditNome: TEdit
      Left = 16
      Top = 39
      Width = 460
      Height = 21
      MaxLength = 100
      TabOrder = 0
    end
    object EditCpfCnpj: TEdit
      Left = 16
      Top = 99
      Width = 200
      Height = 21
      MaxLength = 18
      TabOrder = 1
    end
    object CheckBoxAtivo: TCheckBox
      Left = 230
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
