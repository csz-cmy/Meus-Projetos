object FHelp: TFHelp
  Left = 279
  Top = 107
  Caption = 'HyperLinks HELP'
  ClientHeight = 566
  ClientWidth = 847
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 0
    Top = 0
    Width = 847
    Height = 566
    Align = alClient
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      'Using HyperLinks:'
      ''
      
        'This is a little application to show how to use hyperlinks. Para' +
        'meters on an hyperlink are not straightforward, so the idea is t' +
        'hat you can go to '
      'Excel, create '
      
        'a Worksheet with your desired hyperlinks, and use this app to se' +
        'e what paramters they have.'
      ''
      'An Explanation of the columns:'
      
        '   Cell1, Cell2: These are the first an last cell of the range t' +
        'he hyperlink is applied to. Normally they will be the same cell,' +
        ' but you can apply '
      'an '
      'hyperlink to a '
      'range too.'
      ''
      '   Type:  There are 4 types of Hyperlinks:'
      '            1) URL: This can be an http, ftp, or mailto://'
      
        '            2) UNC: This is a path to a network site on universa' +
        'l naming convention, , like \\server\folder\xxx.xls.'
      
        '            3) Local File: This is a file stored relative to the' +
        ' path of the sheet. (for example, on the upper folder)'
      
        '            4) Current Workbook: this is a link to a cell on the' +
        ' file. Note that this option always has Text='#39#39
      ''
      '   Text:'
      
        '             Text of the HyperLink. This is empty when linking t' +
        'o a cell.'
      ''
      '   Description: '
      '              Description of the HyperLink'
      '   '
      '   Target Frame:'
      
        '             This parameter is not documented. You can leave it ' +
        'empty.'
      ''
      '   Text Mark:'
      
        '              When entering an URL on excel, you can enter addit' +
        'ional text following the url with a "#" character (for example w' +
        'ww.xxx.com#my '
      'url") The '
      
        'text Mark is the text after the "#" char. When entering an addre' +
        'ss to a cell, the address goes here too.'
      ''
      '   Hint:'
      
        '            This is the hint Excel will show when hovering the m' +
        'ouse over the hyperlink.')
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 0
  end
end
