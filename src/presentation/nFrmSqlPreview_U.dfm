object nFrmSqlPreview: TnFrmSqlPreview
  Left = 0
  Top = 0
  Caption = 'SQL Preview'
  ClientHeight = 700
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
    object LabelDialeto: TLabel
      Left = 16
      Top = 15
      Width = 162
      Height = 19
      Caption = 'Visualiza'#231#227'o de SQL'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object ComboBoxDialeto: TComboBox
      Left = 640
      Top = 15
      Width = 130
      Height = 21
      Style = csDropDownList
      ItemIndex = 0
      TabOrder = 0
      Text = 'Firebird'
      Items.Strings = (
        'Firebird'
        'Oracle'
        'PostgreSQL')
    end
  end
  object PanelFiltros: TPanel
    Left = 0
    Top = 50
    Width = 800
    Height = 140
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object GroupBoxFiltros: TGroupBox
      Left = 8
      Top = 4
      Width = 780
      Height = 132
      Caption = 'Filtros'
      TabOrder = 0
      object LabelAte: TLabel
        Left = 266
        Top = 26
        Width = 16
        Height = 13
        Caption = 'at'#233
      end
      object LabelOrdenacao: TLabel
        Left = 430
        Top = 86
        Width = 63
        Height = 13
        Caption = 'Ordenar por:'
      end
      object CheckBoxFiltroData: TCheckBox
        Left = 16
        Top = 24
        Width = 120
        Height = 17
        Caption = 'Filtrar por Data'
        TabOrder = 0
      end
      object DateTimePickerInicio: TDateTimePicker
        Left = 140
        Top = 22
        Width = 120
        Height = 21
        Date = 45650.000000000000000000
        Time = 45650.000000000000000000
        TabOrder = 1
      end
      object DateTimePickerFim: TDateTimePicker
        Left = 290
        Top = 22
        Width = 120
        Height = 21
        Date = 45650.000000000000000000
        Time = 45650.000000000000000000
        TabOrder = 2
      end
      object CheckBoxFiltroCliente: TCheckBox
        Left = 16
        Top = 55
        Width = 120
        Height = 17
        Caption = 'Filtrar por Cliente'
        TabOrder = 3
      end
      object ComboBoxCliente: TComboBox
        Left = 140
        Top = 53
        Width = 270
        Height = 21
        Style = csDropDownList
        TabOrder = 4
      end
      object CheckBoxFiltroStatus: TCheckBox
        Left = 430
        Top = 55
        Width = 120
        Height = 17
        Caption = 'Filtrar por Status'
        TabOrder = 5
      end
      object ComboBoxStatus: TComboBox
        Left = 550
        Top = 53
        Width = 200
        Height = 21
        Style = csDropDownList
        ItemIndex = 0
        TabOrder = 6
        Text = 'ABERTO'
        Items.Strings = (
          'ABERTO'
          'FATURADO'
          'CANCELADO')
      end
      object CheckBoxTextoLivre: TCheckBox
        Left = 16
        Top = 86
        Width = 120
        Height = 17
        Caption = 'Texto livre'
        TabOrder = 7
      end
      object EditTextoLivre: TEdit
        Left = 140
        Top = 84
        Width = 270
        Height = 21
        TabOrder = 8
      end
      object RadioGroupOrdenacao: TRadioGroup
        Left = 510
        Top = 75
        Width = 240
        Height = 40
        Columns = 2
        Items.Strings = (
          'Data de Emiss'#227'o'
          'N'#250'mero do Pedido')
        TabOrder = 9
      end
    end
  end
  object PanelSql: TPanel
    Left = 0
    Top = 190
    Width = 800
    Height = 300
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    DesignSize = (
      800
      300)
    object LabelSql: TLabel
      Left = 16
      Top = 8
      Width = 61
      Height = 13
      Caption = 'SQL Gerado:'
    end
    object MemoSql: TMemo
      Left = 16
      Top = 24
      Width = 760
      Height = 260
      Anchors = [akLeft, akTop, akRight]
      ScrollBars = ssVertical
      TabOrder = 0
      WordWrap = False
    end
  end
  object PanelParametros: TPanel
    Left = 0
    Top = 490
    Width = 800
    Height = 160
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 3
    DesignSize = (
      800
      160)
    object LabelParametros: TLabel
      Left = 16
      Top = 8
      Width = 59
      Height = 13
      Caption = 'Par'#226'metros:'
    end
    object StringGridParametros: TStringGrid
      Left = 16
      Top = 24
      Width = 760
      Height = 120
      Anchors = [akLeft, akTop, akRight]
      ColCount = 2
      FixedCols = 0
      RowCount = 1
      FixedRows = 0
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing, goRowSelect]
      TabOrder = 0
      ColWidths = (
        200
        300)
    end
  end
  object PanelButtons: TPanel
    Left = 0
    Top = 650
    Width = 800
    Height = 50
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 4
    object ButtonGerar: TButton
      Left = 16
      Top = 12
      Width = 120
      Height = 30
      Caption = 'Gerar SQL'
      TabOrder = 0
      OnClick = ButtonGerarClick
    end
    object ButtonCopiar: TButton
      Left = 142
      Top = 12
      Width = 120
      Height = 30
      Caption = 'Copiar SQL'
      TabOrder = 1
      OnClick = ButtonCopiarClick
    end
  end
end
