�
 TFORM1 0�  TPF0TForm1Form1Left� TopGWidthqHeight�Caption2TatBasicScripter demo with OLE automation to ExcelColor	clBtnFaceFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style OldCreateOrderOnCreate
FormCreatePixelsPerInch`
TextHeight TLabelLabel1LeftTop Width.HeightCaption
Order ID :  TLabelLabel2LeftTop@Width2HeightCaption
Customer :  TLabelLabel3LeftTop`Width%HeightCaptionProduct  TLabelLabel4LeftTop� Width-HeightCaption
Quantity :  TLabelLabel5LeftTop� WidthHeightCaptionColor :  TLabelLabel6LeftTopWidth� HeightCaptionORDER INTAKE SYSTEMFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.StylefsBold 
ParentFont  TLabelLabel7Left� TopWidth)HeightCaption
Order list  TButtonButton1LeftTop� WidthSHeightCaptionExec scriptTabOrder OnClickButton1Click  TDBGridDBGrid1Left� Top Width�Height� 
DataSourceDataSource1TabOrderTitleFont.CharsetDEFAULT_CHARSETTitleFont.ColorclWindowTextTitleFont.Height�TitleFont.NameMS Sans SerifTitleFont.Style   TDBNavigatorDBNavigator1LeftTop� Width� Height
DataSourceDataSource1TabOrder  TDBEditDBEdit1Left@Top WidthyHeight	DataFieldORDERID
DataSourceDataSource1TabOrder  TDBEditDBEdit2Left@Top@WidthyHeight	DataFieldCUSTOMER
DataSourceDataSource1TabOrder  TDBEditDBEdit3Left@Top`WidthyHeight	DataFieldPRODUCT
DataSourceDataSource1TabOrder  TDBEditDBEdit4Left@Top� WidthyHeight	DataFieldQUANTITY
DataSourceDataSource1TabOrder  TDBEditDBEdit5Left@Top� WidthyHeight	DataFieldCOLOR
DataSourceDataSource1TabOrder  	TCheckBox	ShowExcelLeftTopWidthQHeightCaption
Show ExcelTabOrder  TAdvMemoAdvMemo1LefthTop� Width�Height� CursorcrIBeam!ActiveLineSettings.ShowActiveLine*ActiveLineSettings.ShowActiveLineIndicatorAutoCompletion.Font.CharsetDEFAULT_CHARSETAutoCompletion.Font.ColorclWindowTextAutoCompletion.Font.Height�AutoCompletion.Font.NameMS Sans SerifAutoCompletion.Font.Style AutoCorrect.Active	AutoHintParameterPositionhpBelowCodeBorderStylebsSingleCtl3DDelErase	EnhancedHomeKeyGutter.DigitCountGutter.Font.CharsetDEFAULT_CHARSETGutter.Font.ColorclWindowTextGutter.Font.Height�Gutter.Font.NameCourier NewGutter.Font.Style Gutter.LineNumberStartGutter.LineNumberTextColorclBlackGutter.ShowLineNumbers	Gutter.Visible	Gutter.ShowLeadingZerosFont.CharsetDEFAULT_CHARSET
Font.ColorclBlackFont.Height�	Font.NameCOURIER NEW
Font.Style HiddenCaretLines.Strings' excel demo,excel = createoleobject("excel.application")!excel.visible = ShowExcel.Checked(FileName = GetCurrentDir + "\orders.xls")workbook = excel.workbooks.open(FileName) worksheet = workbook.ActiveSheet i = 1ordid = "*"do while (ordid <> "")   cell = worksheet.Cells(i,1)  ordid = cell.Text   if (ordid <> "") then 
    Append    dbEdit1.SetValue(ordid)    cell = worksheet.Cells(i,2)    dbEdit2.SetValue(cell.Text)    cell = worksheet.Cells(i,3)    dbEdit3.SetValue(cell.Text)    cell = worksheet.Cells(i,4)    dbEdit4.SetValue(cell.Text)    cell = worksheet.Cells(i,5)    dbEdit5.SetValue(cell.Text)    Post  end if  i = i + 1loop workbook.Close
Excel.QuitExcel = null  %MarkerList.UseDefaultMarkerImageIndex"MarkerList.DefaultMarkerImageIndex� MarkerList.ImageTransparentColor�PrintOptions.MarginLeft PrintOptions.MarginRight PrintOptions.MarginTop PrintOptions.MarginBottom PrintOptions.PageNrPrintOptions.PrintLineNumbersRightMarginColor��� 
ScrollHintSelColorclWhite
SelBkColorclNavyShowRightMargin		SmartTabsSyntaxStylesAdvBasicMemoStyler1TabOrder	TabSizeTabStop	TrimTrailingSpaces	UndoLimitdUrlStyle.TextColorclBlueUrlStyle.BkColorclWhiteUrlStyle.StylefsUnderline 	UseStyler	Version1.6.0.8WordWrapwwNone  TDataSourceDataSource1DataSetTable1LeftTop�   TTableTable1DatabaseNamec:\delphi6\automa\demo\excel	TableName	orders.dbLeft(Top�   TatPascalFormScripteratPascalFormScripter1SaveCompiledCodeShortBooleanEvalLeftHTop�   TAdvBasicMemoStylerAdvBasicMemoStyler1
BlockStartbeginBlockEndendLineComment'MultiCommentLeft{MultiCommentRight}CommentStyle.TextColorclNavyCommentStyle.BkColorclWhiteCommentStyle.StylefsItalic NumberStyle.TextColor	clFuchsiaNumberStyle.BkColorclWhiteNumberStyle.StylefsBold 	AllStylesKeyWords.Stringsaliasallandasattachautoautoxcase	cfunctioncleardcomplexdecdeclaredefaultdimdodoubleeachelseelseifendendiferrorexitexplicitexportexternalfalseforfor nextfuncaddrfunctiongiantgoaddrgosubgotoififfiftifzimportinincinternalislibrarysloopmodmodulenewnextnotnothingoffonoptionorprintprogram	protectedpublicquitreadredimreturnsbytescomplexselect	sfunctionsharedsharedsingleslongsshortstaticstepstopstringsubsubaddrswapthentotruetypetypeofubyteulongunionuntilushortversionvoidwhenwhilewritexlongxor Font.CharsetDEFAULT_CHARSET
Font.ColorclGreenFont.Height�	Font.NameCourier New
Font.Style BGColorclWhite	StyleType	stKeywordBracketStart 
BracketEnd InfoBasic Standard Default Font.CharsetDEFAULT_CHARSET
Font.ColorclBlueFont.Height�	Font.NameCourier New
Font.Style BGColorclWhite	StyleType	stBracketBracketStart 
BracketEnd InfoDouble Quote Font.CharsetDEFAULT_CHARSET
Font.ColorclTealFont.Height�	Font.NameCourier New
Font.Style BGColorclWhite	StyleTypestSymbolBracketStart 
BracketEnd Symbols ,;:.(){}[]=-*/^%<>#
InfoSymbols Delimiters  HexIdentifier0xAutoCompletion.StringsShowMessage
MessageDlg HintParameter.TextColorclBlackHintParameter.BkColorclInfoBkHintParameter.HintCharStart(HintParameter.HintCharEnd)HintParameter.HintCharDelimiter;$HintParameter.HintCharWriteDelimiter, HintParameter.Parameters.StringsShowMessage(string Msg)UMessageDlg(string Msg; TMsgDlgType DlgType; TMsgDlgButtons Buttons; LongInt: HelpCtx) DescriptionMS Visual BasicFilter Visual Basic Files (*.bas)|*.basDefaultExtension.bas
StylerNameMS Visual Basic
ExtensionsbasLeft@Top�  TatBasicFormScripteratBasicFormScripter1SaveCompiledCodeShortBooleanEvalLefthTop�    