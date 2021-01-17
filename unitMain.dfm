object frmMain: TfrmMain
  Left = 283
  Top = 268
  Width = 1305
  Height = 675
  Caption = 'Tetris Placer'
  Color = clOlive
  Constraints.MinHeight = 140
  Constraints.MinWidth = 240
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDefault
  OnCreate = FormCreate
  OnMouseDown = FormMouseDown
  OnMouseMove = FormMouseMove
  OnMouseUp = FormMouseUp
  OnPaint = FormPaint
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object pnlMenu: TPanel
    Left = 0
    Top = 0
    Width = 113
    Height = 636
    Align = alLeft
    TabOrder = 0
    object lblGridWidth: TLabel
      Left = 8
      Top = 44
      Width = 50
      Height = 13
      Caption = 'Grid width:'
    end
    object lblGridHeight: TLabel
      Left = 8
      Top = 68
      Width = 54
      Height = 13
      Caption = 'Grid height:'
    end
    object spinGridX: TSpinEdit
      Left = 64
      Top = 40
      Width = 41
      Height = 22
      EditorEnabled = False
      MaxValue = 20
      MinValue = 1
      TabOrder = 0
      Value = 1
    end
    object spinGridY: TSpinEdit
      Left = 64
      Top = 64
      Width = 41
      Height = 22
      EditorEnabled = False
      MaxValue = 20
      MinValue = 1
      TabOrder = 1
      Value = 1
    end
    object btnSetGridSize: TButton
      Left = 8
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Set grid size'
      TabOrder = 2
      OnClick = btnSetGridSizeClick
    end
  end
end
