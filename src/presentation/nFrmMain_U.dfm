object nFrmMain: TnFrmMain
  Left = 0
  Top = 0
  Caption = 'Sistema de Pedidos - Desafio T'#233'cnico'
  ClientHeight = 441
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  FormStyle = fsMDIForm
  Menu = MainMenu1
  WindowState = wsMaximized
  TextHeight = 15
  object Label1: TLabel
    Left = 0
    Top = 0
    Width = 624
    Height = 441
    Align = alClient
    Alignment = taCenter
    Caption = 'QUESTOR SISTEMAS S.A'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -27
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    Layout = tlCenter
    ExplicitWidth = 285
    ExplicitHeight = 37
  end
  object MainMenu1: TMainMenu
    Left = 512
    Top = 88
    object MenuCadastros: TMenuItem
      Caption = 'Cadastros'
      object MenuClientes: TMenuItem
        Caption = 'Clientes'
        OnClick = MenuClientesClick
      end
      object MenuProdutos: TMenuItem
        Caption = 'Produtos'
        OnClick = MenuProdutosClick
      end
      object MenuPedidos: TMenuItem
        Caption = 'Pedidos'
        OnClick = MenuPedidosClick
      end
      object MenuSqlPreview: TMenuItem
        Caption = 'SQL Preview'
        OnClick = MenuSqlPreviewClick
      end
      object MenuSeparador: TMenuItem
        Caption = '-'
      end
      object MenuSair: TMenuItem
        Caption = 'Sair'
        OnClick = MenuSairClick
      end
    end
  end
end
