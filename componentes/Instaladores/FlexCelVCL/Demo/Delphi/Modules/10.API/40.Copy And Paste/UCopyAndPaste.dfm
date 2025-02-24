object FCopyAndPaste: TFCopyAndPaste
  Left = 0
  Top = 0
  Caption = 'Copy And Paste'
  ClientHeight = 294
  ClientWidth = 562
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    562
    294)
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 8
    Top = 8
    Width = 465
    Height = 25
    Anchors = [akLeft, akTop, akRight]
    Lines.Strings = (
      '1) Begin by creating a new file...')
    ReadOnly = True
    TabOrder = 0
  end
  object btnNewFile: TButton
    Left = 8
    Top = 39
    Width = 121
    Height = 25
    Caption = 'Create a New File'
    TabOrder = 1
    OnClick = btnNewFileClick
  end
  object Memo2: TMemo
    Left = 8
    Top = 88
    Width = 465
    Height = 41
    Anchors = [akLeft, akTop, akRight]
    Lines.Strings = (
      
        '2) Now go to Excel, copy some cells and Press the "Paste" button' +
        '. '
      '')
    ReadOnly = True
    TabOrder = 2
  end
  object btnPaste: TButton
    Left = 8
    Top = 135
    Width = 121
    Height = 25
    Caption = 'Paste'
    TabOrder = 3
    OnClick = btnPasteClick
  end
  object Memo3: TMemo
    Left = 8
    Top = 192
    Width = 465
    Height = 41
    Anchors = [akLeft, akTop, akRight]
    Lines.Strings = (
      '2) After Pasting, you can now copy the results back into Excel.'
      '')
    ReadOnly = True
    TabOrder = 4
  end
  object btnCopy: TButton
    Left = 8
    Top = 239
    Width = 121
    Height = 25
    Caption = 'Copy'
    TabOrder = 5
    OnClick = btnCopyClick
  end
  object Xls: TFlexCelImport
    Adapter = XLSAdapter1
    Left = 480
    Top = 8
  end
  object XLSAdapter1: TXLSAdapter
    AllowOverwritingFiles = True
    Left = 480
    Top = 40
  end
end
