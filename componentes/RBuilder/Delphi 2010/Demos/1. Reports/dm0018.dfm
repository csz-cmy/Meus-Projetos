�
 TFRM0018 0r'  TPF0Tfrm0018frm0018Left� Top~Width,Height� Caption"Move group footer totals to headerColor	clBtnFaceFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style OldCreateOrder	ScaledPixelsPerInch`
TextHeight TLabelLabel1LeftTopWidth=HeightCaptionData Access  TLabelLabel2Left� TopWidth HeightCaptionReport  TLabelLabel3Left� TopAWidthaHeightCaptionTo Edit, double-click  TLabelLabel10LeftTopfWidth� HeightCaption$Two-Pass totals are displayed in red  TppBDEPipelineppBDEPipeline1
DataSourceDataSource1UserNameBDEPipeline1LeftPTop  TppFieldppBDEPipeline1ppField1	AlignmenttaRightJustify
FieldAliasCustNo	FieldNameCustNoFieldLength DataTypedtDoubleDisplayWidth
Position   TppFieldppBDEPipeline1ppField2
FieldAliasCompany	FieldNameCompanyFieldLengthDisplayWidthPosition  TppFieldppBDEPipeline1ppField3
FieldAliasAddr1	FieldNameAddr1FieldLengthDisplayWidthPosition  TppFieldppBDEPipeline1ppField4
FieldAliasAddr2	FieldNameAddr2FieldLengthDisplayWidthPosition  TppFieldppBDEPipeline1ppField5
FieldAliasCity	FieldNameCityFieldLengthDisplayWidthPosition  TppFieldppBDEPipeline1ppField6
FieldAliasState	FieldNameStateFieldLengthDisplayWidthPosition  TppFieldppBDEPipeline1ppField7
FieldAliasZip	FieldNameZipFieldLength
DisplayWidth
Position  TppFieldppBDEPipeline1ppField8
FieldAliasCountry	FieldNameCountryFieldLengthDisplayWidthPosition  TppFieldppBDEPipeline1ppField9
FieldAliasPhone	FieldNamePhoneFieldLengthDisplayWidthPosition  TppFieldppBDEPipeline1ppField10
FieldAliasFAX	FieldNameFAXFieldLengthDisplayWidthPosition	  TppFieldppBDEPipeline1ppField11	AlignmenttaRightJustify
FieldAliasTaxRate	FieldNameTaxRateFieldLength DataTypedtDoubleDisplayWidth
Position
  TppFieldppBDEPipeline1ppField12
FieldAliasContact	FieldNameContactFieldLengthDisplayWidthPosition  TppFieldppBDEPipeline1ppField13
FieldAliasLastInvoiceDate	FieldNameLastInvoiceDateFieldLength DataType
dtDateTimeDisplayWidthPosition  TppFieldppBDEPipeline1ppField14	AlignmenttaRightJustify
FieldAliasOrderNo	FieldNameOrderNoFieldLength DataTypedtDoubleDisplayWidth
Position  TppFieldppBDEPipeline1ppField15	AlignmenttaRightJustify
FieldAliasCustNo_1	FieldNameCustNo_1FieldLength DataTypedtDoubleDisplayWidth
Position  TppFieldppBDEPipeline1ppField16
FieldAliasSaleDate	FieldNameSaleDateFieldLength DataType
dtDateTimeDisplayWidthPosition  TppFieldppBDEPipeline1ppField17
FieldAliasShipDate	FieldNameShipDateFieldLength DataType
dtDateTimeDisplayWidthPosition  TppFieldppBDEPipeline1ppField18	AlignmenttaRightJustify
FieldAliasEmpNo	FieldNameEmpNoFieldLength DataType	dtIntegerDisplayWidth
Position  TppFieldppBDEPipeline1ppField19
FieldAliasShipToContact	FieldNameShipToContactFieldLengthDisplayWidthPosition  TppFieldppBDEPipeline1ppField20
FieldAliasShipToAddr1	FieldNameShipToAddr1FieldLengthDisplayWidthPosition  TppFieldppBDEPipeline1ppField21
FieldAliasShipToAddr2	FieldNameShipToAddr2FieldLengthDisplayWidthPosition  TppFieldppBDEPipeline1ppField22
FieldAlias
ShipToCity	FieldName
ShipToCityFieldLengthDisplayWidthPosition  TppFieldppBDEPipeline1ppField23
FieldAliasShipToState	FieldNameShipToStateFieldLengthDisplayWidthPosition  TppFieldppBDEPipeline1ppField24
FieldAlias	ShipToZip	FieldName	ShipToZipFieldLength
DisplayWidth
Position  TppFieldppBDEPipeline1ppField25
FieldAliasShipToCountry	FieldNameShipToCountryFieldLengthDisplayWidthPosition  TppFieldppBDEPipeline1ppField26
FieldAliasShipToPhone	FieldNameShipToPhoneFieldLengthDisplayWidthPosition  TppFieldppBDEPipeline1ppField27
FieldAliasShipVIA	FieldNameShipVIAFieldLengthDisplayWidthPosition  TppFieldppBDEPipeline1ppField28
FieldAliasPO	FieldNamePOFieldLengthDisplayWidthPosition  TppFieldppBDEPipeline1ppField29
FieldAliasTerms	FieldNameTermsFieldLengthDisplayWidthPosition  TppFieldppBDEPipeline1ppField30
FieldAliasPaymentMethod	FieldNamePaymentMethodFieldLengthDisplayWidthPosition  TppFieldppBDEPipeline1ppField31
FieldAlias
ItemsTotal	FieldName
ItemsTotalFieldLength DataType
dtCurrencyDisplayWidth
Position  TppFieldppBDEPipeline1ppField32	AlignmenttaRightJustify
FieldAlias	TaxRate_1	FieldName	TaxRate_1FieldLength DataTypedtDoubleDisplayWidth
Position  TppFieldppBDEPipeline1ppField33
FieldAliasFreight	FieldNameFreightFieldLength DataType
dtCurrencyDisplayWidth
Position   TppFieldppBDEPipeline1ppField34
FieldAlias
AmountPaid	FieldName
AmountPaidFieldLength DataType
dtCurrencyDisplayWidth
Position!   TDataSourceDataSource1DataSetQuery1Left0Top   TQueryQuery1Active	DatabaseNameDBDEMOSSQL.Stringsselect customer.* ,          orders.*from customer, orders%where orders.custno = customer.custnoorder by customer.custno,             orders.orderno LeftTop   	TppReport	ppReport1AutoStopDataPipelineppBDEPipeline1PassSetting	psTwoPassPrinterSetup.BinNameDefaultPrinterSetup.DocumentName	ppReport1PrinterSetup.PaperNameLetter 8 � x 11 inPrinterSetup.PrinterNameDefaultPrinterSetup.mmMarginBottom�PrinterSetup.mmMarginLeft�PrinterSetup.mmMarginRight�PrinterSetup.mmMarginTop�PrinterSetup.mmPaperHeightiC PrinterSetup.mmPaperWidth\K Template.FileName#P:\Dev\RBldr3\Templates\TwoPass.RTMUserNameReport
CachePages	
DeviceTypeScreenLeft� Top Version5.0mmColumnWidth  TppHeaderBandppReport1HeaderBand1mmBottomOffset mmHeight�3mmPrintPosition  TppLabelppReport1Label1UserNameppReport1Label1AutoSizeCaptionSales ReportFont.CharsetDEFAULT_CHARSET
Font.ColorclBlack	Font.NameArial	Font.Size
Font.StylefsBold Transparent	mmHeight�mmLeftxmmTop�mmWidth��  BandType    TppDetailBandppReport1DetailBand1mmBottomOffset mmHeight�mmPrintPosition  	TppDBTextppReport1DBText3UserNameppReport1DBText3	AlignmenttaRightJustify	DataField
ItemsTotalDataPipelineppBDEPipeline1DisplayFormat$#,0.00;($#,0.00)Font.CharsetDEFAULT_CHARSET
Font.ColorclBlack	Font.NameArial	Font.Size
Font.StylefsBold Transparent	mmHeight�mmLeft�  mmTop"mmWidth�tBandType  	TppDBCalcppReport1DBCalc2UserNameppReport1DBCalc2	AlignmenttaRightJustify	DataField
ItemsTotalDataPipelineppBDEPipeline1DisplayFormat$#,0.00;($#,0.00)Font.CharsetDEFAULT_CHARSET
Font.ColorclBlack	Font.NameArial	Font.Size
Font.StylefsBold 
ResetGroupppReport1Group1Transparent	mmHeight�mmLeftS� mmTopmmWidth~BandType  	TppDBTextppReport1DBText5UserNameppReport1DBText5	DataFieldOrderNoDataPipelineppBDEPipeline1Font.CharsetDEFAULT_CHARSET
Font.ColorclBlack	Font.NameArial	Font.Size
Font.StylefsBold Transparent	mmHeight�mmLeftK�  mmTop"mmWidth>BandType   TppFooterBandppReport1FooterBand1mmBottomOffset mmHeight�3mmPrintPosition  TppSystemVariableppReport1Calc2UserNameReport1Calc2	AlignmenttaRightJustifyAutoSizeVarTypevtPrintDateTimeFont.CharsetDEFAULT_CHARSET
Font.ColorclBlack	Font.NameArial	Font.Size
Font.StylefsBold Transparent	mmHeight�mmLeft8o mmTop�mmWidthf�  BandType  TppSystemVariableppReport1Calc3UserNameReport1Calc3VarTypevtPageSetDescFont.CharsetDEFAULT_CHARSET
Font.ColorclBlack	Font.NameArial	Font.Size
Font.StylefsBold Transparent	mmHeight�mmLeft<mmTop�mmWidth�VBandType   TppGroupppReport1Group1	BreakNamecustnoDataPipelineppBDEPipeline1UserNameReport1Group1mmNewColumnThreshold mmNewPageThreshold  TppGroupHeaderBandppReport1GroupHeaderBand1mmBottomOffset mmHeight�3mmPrintPosition  	TppDBTextppReport1DBText1UserNameppReport1DBText1AutoSize		DataFieldcustnoDataPipelineppBDEPipeline1Font.CharsetDEFAULT_CHARSET
Font.ColorclBlack	Font.NameArial	Font.Size
Font.StylefsBold Transparent	mmHeight�mmLeft�:mmTop�mmWidth5%BandTypeGroupNo   	TppDBTextppReport1DBText4UserNameppReport1DBText4AutoSize		DataFieldCompanyDataPipelineppBDEPipeline1Font.CharsetDEFAULT_CHARSET
Font.ColorclBlack	Font.NameArial	Font.Size
Font.StylefsBold Transparent	mmHeight�mmLeft|mmTop�mmWidth�VBandTypeGroupNo   	TppDBCalc	ppDBCalc1UserNameDBCalc1	AlignmenttaRightJustify	DataField
ItemsTotalDataPipelineppBDEPipeline1DisplayFormat$#,0.00;($#,0.00)Font.CharsetDEFAULT_CHARSET
Font.ColorclRed	Font.NameArial	Font.Size
Font.StylefsBold 
ResetGroupppReport1Group1Transparent		LookAhead	mmHeight�mmLeftӁ mmTop�mmWidth��  BandTypeGroupNo   TppLineppLine1UserNameLine1	Pen.ColorclRed	Pen.StylepsDot	Pen.Width PositionlpBottomWeight       ��?mmHeightV
mmLeft�:mmTopmmWidth�� BandTypeGroupNo    TppGroupFooterBandppReport1GroupFooterBand1mmBottomOffset mmHeightsKmmPrintPosition  	TppDBTextppReport1DBText2UserNameppReport1DBText2AutoSize		DataFieldcustnoDataPipelineppBDEPipeline1Font.CharsetDEFAULT_CHARSET
Font.ColorclBlack	Font.NameArial	Font.Size
Font.StylefsBold Transparent	mmHeight�mmLeft�:mmTop�mmWidth5%BandTypeGroupNo   	TppDBCalcppReport1DBCalc1UserNameppReport1DBCalc1	AlignmenttaRightJustify	DataField
ItemsTotalDataPipelineppBDEPipeline1DisplayFormat$#,0.00;($#,0.00)Font.CharsetDEFAULT_CHARSET
Font.ColorclBlack	Font.NameArial	Font.Size
Font.StylefsBold 
ResetGroupppReport1Group1Transparent	mmHeight�mmLeftS� mmTop�mmWidth~BandTypeGroupNo   TppLineppLine2UserNameLine2	Pen.StylepsDot	Pen.Width Weight       ��?mmHeightV
mmLeft�:mmTop>&mmWidth�� BandTypeGroupNo       