object fmMain: TfmMain
  Left = 0
  Top = 0
  Caption = 'Connection Query Example'
  ClientHeight = 442
  ClientWidth = 628
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  DesignSize = (
    628
    442)
  TextHeight = 15
  object ConsultarButton: TButton
    Left = 8
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Consultar'
    TabOrder = 0
    OnClick = ConsultarButtonClick
  end
  object ConsultaDBGrid: TDBGrid
    Left = 8
    Top = 39
    Width = 612
    Height = 395
    Anchors = [akLeft, akTop, akRight, akBottom]
    DataSource = ConsultaDataSource
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
  end
  object Button1: TButton
    Left = 89
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Incluir'
    TabOrder = 2
    OnClick = Button1Click
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'Forms'
    Left = 488
    Top = 80
  end
  object ConsultaDataSource: TDataSource
    Left = 272
    Top = 104
  end
end
