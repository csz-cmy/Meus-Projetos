�
 TFORM1 0j  TPF0TForm1Form1LeftrTop(WidthkHeightLCaption5TatPascalScripter demo with OLE automation to OutlookColor	clBtnFaceFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style OldCreateOrderPixelsPerInch`
TextHeight TLabelLabel1LeftTop� WidthkHeightCaptionContacts telephone list  TLabelContactCountLeft� Top� WidthAHeightCaptionContactCount  TLabelLabel2Left� TopWidth?HeightCaptionSample script  TButtonButton1LeftTopWidthSHeightCaptionExecTabOrder OnClickButton1Click  TListBoxListBox1LeftTopWidthIHeight!
ItemHeightTabOrder  TRadioGroupPhoneSelLeftTop(WidthyHeightQCaptionContacts phone list	ItemIndex Items.StringsHomeBusinessMobile TabOrder  TAdvMemoAdvMemo1Left� TopWidth�Height� CursorcrIBeam!ActiveLineSettings.ShowActiveLine*ActiveLineSettings.ShowActiveLineIndicatorAutoCompletion.Font.CharsetDEFAULT_CHARSETAutoCompletion.Font.ColorclWindowTextAutoCompletion.Font.Height�AutoCompletion.Font.NameMS Sans SerifAutoCompletion.Font.Style AutoCorrect.Active	AutoHintParameterPositionhpBelowCodeBorderStylebsSingleCtl3DDelErase	EnhancedHomeKeyGutter.DigitCountGutter.Font.CharsetDEFAULT_CHARSETGutter.Font.ColorclWindowTextGutter.Font.Height�Gutter.Font.NameCourier NewGutter.Font.Style Gutter.LineNumberStartGutter.LineNumberTextColorclBlackGutter.ShowLineNumbers	Gutter.Visible	Gutter.ShowLeadingZerosFont.CharsetDEFAULT_CHARSET
Font.ColorclBlackFont.Height�	Font.NameCOURIER NEW
Font.Style HiddenCaretLines.Stringslistbox1.Items.Clear;2outlook := CreateOleObject('Outlook.Application');*namespace := outlook.GetNameSpace('MAPI');+contacts := namespace.GetDefaultFolder(10); Rcontactcount.caption := '# contacts in Outlook : '+inttostr(contacts.items.count); %for j := 1 to contacts.items.Count dobegin  contact := contacts.items(j); !  if  phonesel.ItemIndex = 0 then(  phone :=  contact.HomeTelephoneNumber;!  if  phonesel.ItemIndex = 1 then,  phone :=  contact.BusinessTelephoneNumber;!  if  phonesel.ItemIndex = 2 then*  phone :=  contact.MobileTelephoneNumber; J  listbox1.items.Add(contact.FirstName + ' ' + contact.LastName+ ' (Tel:' +phone+')');end;  %MarkerList.UseDefaultMarkerImageIndex"MarkerList.DefaultMarkerImageIndex� MarkerList.ImageTransparentColor   PrintOptions.MarginLeft PrintOptions.MarginRight PrintOptions.MarginTop PrintOptions.MarginBottom PrintOptions.PageNrPrintOptions.PrintLineNumbersRightMarginColor��� 
ScrollHintSelColorclWhite
SelBkColorclNavyShowRightMargin		SmartTabsSyntaxStylesAdvPascalMemoStyler1TabOrderTabSizeTabStop	TrimTrailingSpaces	UndoLimitdUrlStyle.TextColorclBlueUrlStyle.BkColorclWhiteUrlStyle.StylefsUnderline 	UseStyler	Version1.6.0.8WordWrapwwNone  TatPascalFormScripteratPascalFormScripter1SaveCompiledCodeShortBooleanEvalLeftXTop�   TAdvPascalMemoStylerAdvPascalMemoStyler1
BlockStartbeginBlockEndendLineComment//MultiCommentLeft{MultiCommentRight}CommentStyle.TextColorclNavyCommentStyle.BkColorclWhiteCommentStyle.StylefsItalic NumberStyle.TextColor	clFuchsiaNumberStyle.BkColorclWhiteNumberStyle.StylefsBold 	AllStylesKeyWords.Stringsbeginbreakcdeclclassclassconstconstructorcontinuedefault
destructordoelseendexceptfinalisefinallyforfunctionifimplementation	inherited
initialise	interfacenilnotoverridepascalprivate	procedureprogramprogramproperty	protectedpublic	publishedraiserepeatstdcallstoredstringthentotrytypeunituntilusesvarvirtualwhilewith Font.CharsetDEFAULT_CHARSET
Font.ColorclGreenFont.Height�	Font.NameCourier New
Font.StylefsBold BGColorclWhite	StyleType	stKeywordBracketStart 
BracketEnd InfoPascal Standard Default Font.CharsetDEFAULT_CHARSET
Font.ColorclBlueFont.Height�	Font.NameCourier New
Font.Style BGColorclWhite	StyleType	stBracketBracketStart'
BracketEnd'InfoSimple Quote Font.CharsetDEFAULT_CHARSET
Font.ColorclBlueFont.Height�	Font.NameCourier New
Font.Style BGColorclWhite	StyleType	stBracketBracketStart"
BracketEnd"InfoDouble Quote Font.CharsetDEFAULT_CHARSET
Font.ColorclRedFont.Height�	Font.NameCourier New
Font.Style BGColorclWhite	StyleTypestSymbolBracketStart 
BracketEnd Symbols ,;:.(){}[]=-*/^%<>#
InfoSymbols Delimiters  AutoCompletion.StringsShowMessage
MessageDlg HintParameter.TextColorclBlackHintParameter.BkColorclInfoBkHintParameter.HintCharStart(HintParameter.HintCharEnd)HintParameter.HintCharDelimiter;$HintParameter.HintCharWriteDelimiter, HintParameter.Parameters.StringsShowMessage(const Msg: string);iMessageDlg(const Msg: string; DlgType: TMsgDlgType; Buttons: TMsgDlgButtons; HelpCtx: Longint): Integer); HexIdentifier$DescriptionPascalFilter>Pascal Files (*.pas,*.dpr,*.dpk,*.inc)|*.pas;*.dpr;*.dpk;*.incDefaultExtension.pas
StylerNamePascal
Extensionspas;dpr;dpk;incLeft8Top�    