�
 TFRM0051 0
W  TPF0Tfrm0051frm0051Left4Top� Width,Height� CaptionMultiple Sections: 2Color	clBtnFaceFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style OldCreateOrder	ScaledPixelsPerInch`
TextHeight TLabelLabel1LeftTop	Width=HeightCaptionData Access  TLabelLabel2Left� TopWidth HeightCaptionReport  TLabelLabel3Left� TopAWidthaHeightCaptionTo Edit, double-click  TLabelLabel4LeftTop@WidthMHeightCaptionSection 1 - Data  TLabelLabel5LeftTop� WidthMHeightCaptionSection 2 - Data  TDataSourcedsEmployeeOrderDataSetqryEmployeeOrderLeft/Top_  TppBDEPipelineplEmployeeOrder
DataSourcedsEmployeeOrderUserNameEmployeeOrderLeftOTop_ TppFieldplEmployeeOrderppField1	AlignmenttaRightJustify
FieldAliasEmpNo	FieldNameEmpNoFieldLength DataType	dtIntegerDisplayWidth
Position   TppFieldplEmployeeOrderppField2
FieldAliasLastName	FieldNameLastNameFieldLengthDisplayWidthPosition  TppFieldplEmployeeOrderppField3
FieldAlias	FirstName	FieldName	FirstNameFieldLengthDisplayWidthPosition  TppFieldplEmployeeOrderppField4
FieldAliasPhoneExt	FieldNamePhoneExtFieldLengthDisplayWidthPosition  TppFieldplEmployeeOrderppField5
FieldAliasHireDate	FieldNameHireDateFieldLength DataType
dtDateTimeDisplayWidthPosition  TppFieldplEmployeeOrderppField6	AlignmenttaRightJustify
FieldAliasSalary	FieldNameSalaryFieldLength DataTypedtDoubleDisplayWidth
Position  TppFieldplEmployeeOrderppField7	AlignmenttaRightJustify
FieldAliasOrderNo	FieldNameOrderNoFieldLength DataTypedtDoubleDisplayWidth
Position  TppFieldplEmployeeOrderppField8	AlignmenttaRightJustify
FieldAliasCustNo	FieldNameCustNoFieldLength DataTypedtDoubleDisplayWidth
Position  TppFieldplEmployeeOrderppField9
FieldAliasSaleDate	FieldNameSaleDateFieldLength DataType
dtDateTimeDisplayWidthPosition  TppFieldplEmployeeOrderppField10
FieldAliasShipDate	FieldNameShipDateFieldLength DataType
dtDateTimeDisplayWidthPosition	  TppFieldplEmployeeOrderppField11	AlignmenttaRightJustify
FieldAliasEmpNo_1	FieldNameEmpNo_1FieldLength DataType	dtIntegerDisplayWidth
Position
  TppFieldplEmployeeOrderppField12
FieldAliasShipToContact	FieldNameShipToContactFieldLengthDisplayWidthPosition  TppFieldplEmployeeOrderppField13
FieldAliasShipToAddr1	FieldNameShipToAddr1FieldLengthDisplayWidthPosition  TppFieldplEmployeeOrderppField14
FieldAliasShipToAddr2	FieldNameShipToAddr2FieldLengthDisplayWidthPosition  TppFieldplEmployeeOrderppField15
FieldAlias
ShipToCity	FieldName
ShipToCityFieldLengthDisplayWidthPosition  TppFieldplEmployeeOrderppField16
FieldAliasShipToState	FieldNameShipToStateFieldLengthDisplayWidthPosition  TppFieldplEmployeeOrderppField17
FieldAlias	ShipToZip	FieldName	ShipToZipFieldLength
DisplayWidth
Position  TppFieldplEmployeeOrderppField18
FieldAliasShipToCountry	FieldNameShipToCountryFieldLengthDisplayWidthPosition  TppFieldplEmployeeOrderppField19
FieldAliasShipToPhone	FieldNameShipToPhoneFieldLengthDisplayWidthPosition  TppFieldplEmployeeOrderppField20
FieldAliasShipVIA	FieldNameShipVIAFieldLengthDisplayWidthPosition  TppFieldplEmployeeOrderppField21
FieldAliasPO	FieldNamePOFieldLengthDisplayWidthPosition  TppFieldplEmployeeOrderppField22
FieldAliasTerms	FieldNameTermsFieldLengthDisplayWidthPosition  TppFieldplEmployeeOrderppField23
FieldAliasPaymentMethod	FieldNamePaymentMethodFieldLengthDisplayWidthPosition  TppFieldplEmployeeOrderppField24
FieldAlias
ItemsTotal	FieldName
ItemsTotalFieldLength DataType
dtCurrencyDisplayWidth
Position  TppFieldplEmployeeOrderppField25	AlignmenttaRightJustify
FieldAliasTaxRate	FieldNameTaxRateFieldLength DataTypedtDoubleDisplayWidth
Position  TppFieldplEmployeeOrderppField26
FieldAliasFreight	FieldNameFreightFieldLength DataType
dtCurrencyDisplayWidth
Position  TppFieldplEmployeeOrderppField27
FieldAlias
AmountPaid	FieldName
AmountPaidFieldLength DataType
dtCurrencyDisplayWidth
Position   TQueryqryEmployeeOrderActive	DatabaseNameDBDEMOSSQL.Strings	select * from employee, orders$where orders.EmpNo = employee.EmpNo order by employee.EmpNo LeftTop_  TTabletblCustomerActive	DatabaseNameDBDEMOS	TableNameCUSTOMER.DBLeft	Top  TDataSource
dsCustomerDataSettblCustomerLeft*Top  TppBDEPipeline
plCustomer
DataSource
dsCustomerUserNameCustomerLeftLTop  	TppReport	ppReport1PrinterSetup.BinNameDefaultPrinterSetup.DocumentName	ppReport1PrinterSetup.PaperNameLetter 8 � x 11 inPrinterSetup.PrinterNameDefaultPrinterSetup.mmMarginBottom�PrinterSetup.mmMarginLeft�PrinterSetup.mmMarginRight�PrinterSetup.mmMarginTop�PrinterSetup.mmPaperHeightiC PrinterSetup.mmPaperWidth\K PrinterSetup.PaperSizeUserNameReport
DeviceTypeScreenLeft� TopVersion5.1mmColumnWidth  TppTitleBandppReport1TitleBand1mmBottomOffset mmHeight�@ mmPrintPosition  TppLabelppReport1Label9UserNameppReport1Label9Caption
Title PageFont.CharsetDEFAULT_CHARSET
Font.ColorclBlack	Font.NameTimes New Roman	Font.Size
Font.StylefsBold Transparent	mmHeight�mmLeftmmTopmmWidthHFBandType  TppLabelppReport1Label13UserNameppReport1Label13Caption(Marine Adventures & Sunken Treasures Co.Font.CharsetDEFAULT_CHARSET
Font.ColorclBlack	Font.NameTimes New Roman	Font.Size
Font.StylefsBoldfsItalic TextAlignment
taCenteredTransparent	mmHeight
 mmLeft\�  mmTop+�  mmWidth  BandType  TppLabelppStockListLabel21UserNameppStockListLabel21CaptionTable of ContentsFont.CharsetDEFAULT_CHARSET
Font.ColorclBlack	Font.NameTimes New Roman	Font.Size
Font.StylefsBoldfsItalic TextAlignment
taCenteredTransparent	mmHeight
 mmLeftu# mmTopq mmWidth��  BandType  TppLabelppStockListLabel23UserNameppStockListLabel23CaptionSection 1.....Customer ListFont.CharsetDEFAULT_CHARSET
Font.ColorclBlack	Font.NameTimes New Roman	Font.Size
Font.Style TextAlignment
taCenteredTransparent	mmHeight�mmLeftu# mmTop� mmWidth��  BandType  TppLabelppReport1Label14UserNameppReport1Label14CaptionSection 2.....Sales By EmployeeFont.CharsetDEFAULT_CHARSET
Font.ColorclBlack	Font.NameTimes New Roman	Font.Size
Font.Style TextAlignment
taCenteredTransparent	mmHeight�mmLeftu# mmTop� mmWidth�  BandType  TppLabelppReport1Label10UserNameppReport1Label10CaptionAnnual Report for 1997Font.CharsetDEFAULT_CHARSET
Font.ColorclBlack	Font.NameTimes New Roman	Font.Size
Font.StylefsBoldfsItalic TextAlignment
taCenteredTransparent	mmHeight
 mmLeftH�  mmTopi�  mmWidth' BandType  TppLabelppReport1Label11UserNameppReport1Label11CaptionPrepared ByFont.CharsetDEFAULT_CHARSET
Font.ColorclBlack	Font.NameTimes New Roman	Font.Size
Font.StylefsBoldfsItalic TextAlignment
taCenteredTransparent	mmHeight�mmLeft<Z mmTop� mmWidthIeBandType  TppLabelppReport1Label12UserNameppReport1Label12CaptionArthur Andreesen & Co.Font.CharsetDEFAULT_CHARSET
Font.ColorclBlack	Font.NameTimes New Roman	Font.Size
Font.StylefsBoldfsItalic TextAlignment
taCenteredTransparent	mmHeight�mmLeft�( mmTop�- mmWidthy�  BandType   TppDetailBandppReport1DetailBand1PrintHeight	phDynamicmmBottomOffset mmHeight?EmmPrintPosition  TppSubReportppReport1SubReport1UserNameppReport1SubReport1	ExpandAllNewPrintJobParentPrinterSetupPrintBehavior	pbSectionTraverseAllDatammHeight�mmLeft mmTopxmmWidth� BandTypemmBottomOffset mmOverFlowOffset mmStopPosition  TppChildReport
ppCustListAutoStopDataPipeline
plCustomerPrinterSetup.BinNameAuto SelectPrinterSetup.DocumentName
ppCustListPrinterSetup.OrientationpoLandscapePrinterSetup.PaperNameLetter 8 � x 11 inPrinterSetup.PrinterNameDefaultPrinterSetup.mmMarginBottom�PrinterSetup.mmMarginLeft�PrinterSetup.mmMarginRight�PrinterSetup.mmMarginTop�PrinterSetup.mmPaperHeight\K PrinterSetup.mmPaperWidthiC PrinterSetup.PaperSizeTemplate.FileName*P:\Dev\Piparti3\DEMOS\Reports\custlist.RTMUnitsutMillimetersUserNameReportLeft� Top_Version5.1mmColumnWidth  TppHeaderBandppCustListHeadermmBottomOffset mmHeight�ZmmPrintPosition  TppLabelppCustListLabel1UserNameppCustListLabel1Caption(Marine Adventures & Sunken Treasures Co.Font.CharsetDEFAULT_CHARSET
Font.ColorclNavy	Font.NameTimes New Roman	Font.Size
Font.StylefsBoldfsItalic TextAlignment
taCenteredTransparent	mmHeight�mmLefte@ mmTop+mmWidth�� BandType   TppLabelppCustListLabel2UserNameppCustListLabel2CaptionCustomer ListFont.CharsetDEFAULT_CHARSET
Font.ColorclBlack	Font.NameTimes New Roman	Font.Size
Font.StylefsBoldfsItalic Transparent	mmHeight�mmLeftM	mmTop+mmWidth'aBandType   TppLabelppCustListLabel3UserNameppCustListLabel3CaptionCompanyFont.CharsetDEFAULT_CHARSET
Font.ColorclBlack	Font.NameTimes New Roman	Font.Size
Font.StylefsBold Transparent	mmHeight�mmLeftmmTop.CmmWidthABandType   TppLabelppCustListLabel4UserNameppCustListLabel4CaptionStateFont.CharsetDEFAULT_CHARSET
Font.ColorclBlack	Font.NameTimes New Roman	Font.Size
Font.StylefsBold Transparent	mmHeight�mmLeft� mmTop.CmmWidth,$BandType   TppLabelppCustListLabel6UserNameppCustListLabel6CaptionContactFont.CharsetDEFAULT_CHARSET
Font.ColorclBlack	Font.NameTimes New Roman	Font.Size
Font.StylefsBold Transparent	mmHeight�mmLeftX�  mmTop.CmmWidth�5BandType   TppLabelppCustListLabel7UserNameppCustListLabel7CaptionPhoneFont.CharsetDEFAULT_CHARSET
Font.ColorclBlack	Font.NameTimes New Roman	Font.Size
Font.StylefsBold Transparent	mmHeight�mmLeft�� mmTop.CmmWidth`*BandType   TppLabelppCustListLabel8UserNameppCustListLabel8CaptionAddressFont.CharsetDEFAULT_CHARSET
Font.ColorclBlack	Font.NameTimes New Roman	Font.Size
Font.StylefsBold Transparent	mmHeight�mmLeftg mmTop.CmmWidth�8BandType   TppLabelppCustListLabel9UserNameppCustListLabel9CaptionCityFont.CharsetDEFAULT_CHARSET
Font.ColorclBlack	Font.NameTimes New Roman	Font.Size
Font.StylefsBold Transparent	mmHeight�mmLeft�� mmTop.CmmWidth�BandType   TppLineppCustListLine1UserNameppCustListLine1	Pen.WidthParentWidth	PositionlpBottomWeight       ��?mmHeight+mmLeft mmTop�UmmWidth� BandType    TppDetailBandppCustListDetailmmBottomOffset mmHeight�mmPrintPosition  	TppDBTextppCustListDBText2UserNameppCustListDBText2	DataFieldCompanyDataPipeline
plCustomerFont.CharsetDEFAULT_CHARSET
Font.ColorclBlack	Font.NameTimes New Roman	Font.Size

Font.Style Transparent	mmHeight�mmLeftmmTop"mmWidth�  BandType  	TppDBTextppCustListDBText8UserNameppCustListDBText8	DataFieldCityDataPipeline
plCustomerFont.CharsetDEFAULT_CHARSET
Font.ColorclBlack	Font.NameTimes New Roman	Font.Size

Font.Style Transparent	mmHeight�mmLeft�� mmTop"mmWidth��  BandType  	TppDBTextppCustListDBText3UserNameppCustListDBText3	DataFieldContactDataPipeline
plCustomerFont.CharsetDEFAULT_CHARSET
Font.ColorclBlack	Font.NameTimes New Roman	Font.Size

Font.Style Transparent	mmHeight�mmLeftX�  mmTop"mmWidthݕ  BandType  	TppDBTextppCustListDBText4UserNameppCustListDBText4	DataFieldPhoneDataPipeline
plCustomerFont.CharsetDEFAULT_CHARSET
Font.ColorclBlack	Font.NameTimes New Roman	Font.Size

Font.Style Transparent	mmHeight�mmLeft�� mmTop"mmWidthS�  BandType  	TppDBTextppCustListDBText5UserNameppCustListDBText5	DataFieldAddr1DataPipeline
plCustomerFont.CharsetDEFAULT_CHARSET
Font.ColorclBlack	Font.NameTimes New Roman	Font.Size

Font.Style Transparent	mmHeight�mmLeftg mmTop"mmWidth�  BandType  	TppDBTextppCustListDBText6UserNameppCustListDBText6	DataFieldStateDataPipeline
plCustomerFont.CharsetDEFAULT_CHARSET
Font.ColorclBlack	Font.NameTimes New Roman	Font.Size

Font.Style Transparent	mmHeight�mmLeft� mmTop+mmWidthRfBandType   TppFooterBandppCustListFootermmBottomOffset mmHeightW)mmPrintPosition  TppSystemVariableppCustListCalc1UserNameCustListCalc1VarTypevtPrintDateTimeFont.CharsetDEFAULT_CHARSET
Font.ColorclBlack	Font.NameTimes New Roman	Font.Size

Font.Style Transparent	mmHeight�mmLeftM	mmTop�mmWidthRfBandType  TppSystemVariableppCustListCalc3UserNameCustListCalc3	AlignmenttaRightJustifyVarTypevtPageSetDescFont.CharsetDEFAULT_CHARSET
Font.ColorclBlack	Font.NameTimes New Roman	Font.Size

Font.Style Transparent	mmHeight�mmLeft�� mmTop�mmWidth�;BandType     TppSubReportppReport1SubReport2UserNameppReport1SubReport2	ExpandAllNewPrintJobPrintBehavior	pbSectionResetPageNoTraverseAllDatammHeight�mmLeft mmTopW)mmWidth� BandTypemmBottomOffset mmOverFlowOffset mmStopPosition  TppChildReport
ppEmpSalesAutoStopDataPipelineplEmployeeOrderPrinterSetup.BinNameDefaultPrinterSetup.DocumentName	ppReport1PrinterSetup.PaperNameLetter 8 � x 11 inPrinterSetup.PrinterNameDefaultPrinterSetup.mmMarginBottom�PrinterSetup.mmMarginLeft�PrinterSetup.mmMarginRight�PrinterSetup.mmMarginTop�PrinterSetup.mmPaperHeightiC PrinterSetup.mmPaperWidth\K PrinterSetup.PaperSizeTemplate.FileName*P:\Dev\Piparti3\DEMOS\Reports\salesemp.RTMUserNameReportLeft� Top_Version5.1mmColumnWidth�  TppHeaderBandppEmpSalesHeaderBand1mmBottomOffset mmHeightaImmPrintPosition  TppLabelppEmpSalesLabel6UserNameppEmpSalesLabel6CaptionSales by EmployeeFont.CharsetDEFAULT_CHARSET
Font.ColorclBlack	Font.NameTimes New Roman	Font.Size
Font.StylefsBoldfsItalic TextAlignmenttaRightJustifiedTransparent	mmHeight�mmLeftEmmTopmmWidth BandType   TppLabelppOrderDetailLabel1UserNameppOrderDetailLabel1Caption(Marine Adventures & Sunken Treasures Co.Font.CharsetDEFAULT_CHARSET
Font.ColorclBlack	Font.NameTimes New Roman	Font.Size
Font.StylefsBoldfsItalic TextAlignment
taCenteredTransparent	mmHeight�mmLeft_�  mmTopmmWidth�� BandType    TppDetailBandppEmpSalesDetailBand1mmBottomOffset mmHeight�mmPrintPosition  	TppDBTextppEmpSalesDBText7UserNameppEmpSalesDBText7	DataFieldOrderNoDataPipelineplEmployeeOrderFont.CharsetDEFAULT_CHARSET
Font.ColorclBlack	Font.NameArial	Font.Size

Font.Style Transparent	mmHeight�mmLeft؋ mmTopmmWidth>BandType  	TppDBTextppEmpSalesDBText8UserNameppEmpSalesDBText8AutoSize		DataField
ItemsTotalDataPipelineplEmployeeOrderDisplayFormat$#,0.00;($#,0.00)Font.CharsetDEFAULT_CHARSET
Font.ColorclBlack	Font.NameArial	Font.Size

Font.Style TextAlignmenttaRightJustifiedTransparent	mmHeight�mmLeft�� mmTopmmWidth�:BandType  TppLineppEmpSalesLine2UserNameppEmpSalesLine2	Pen.ColorclSilver	Pen.WidthParentHeight	PositionlpLeftWeight       � @mmHeight�mmLeft mmTop mmWidth�BandType  TppLineppEmpSalesLine3UserNameppEmpSalesLine3	Pen.ColorclSilver	Pen.WidthParentHeight	PositionlpRightWeight       � @mmHeight�mmLeft� mmTop mmWidth�BandType  TppLabelppLabelContinuedOnPrintppLabelContinuedPrintUserNameppLabelContinuedReprintOnOverFlow	CaptionContinued...Font.CharsetDEFAULT_CHARSET
Font.ColorclBlack	Font.NameArial	Font.Size

Font.Style TextAlignmenttaRightJustifiedTransparent	VisiblemmHeight�mmLefttjmmTop+mmWidthYHBandType   TppFooterBandppEmpSalesFooterBand1mmBottomOffset mmHeight�3mmPrintPosition  TppSystemVariableppOrderDetailCalc2UserNameOrderDetailCalc2VarTypevtPrintDateTimeFont.CharsetDEFAULT_CHARSET
Font.ColorclBlack	Font.NameTimes New Roman	Font.Size

Font.Style Transparent	mmHeight�mmLeft	mmTop�mmWidthRfBandType  TppSystemVariableppOrderDetailCalc3UserNameOrderDetailCalc3	AlignmenttaRightJustifyVarTypevtPageSetDescFont.CharsetDEFAULT_CHARSET
Font.ColorclBlack	Font.NameTimes New Roman	Font.Size

Font.Style Transparent	mmHeight�mmLeft�� mmTop�mmWidth�;BandType  TppSystemVariableppEmpSalesCalc1UserNameEmpSalesCalc1VarTypevtPrintDateTimeFont.CharsetDEFAULT_CHARSET
Font.ColorclBlack	Font.NameTimes New Roman	Font.Size

Font.Style Transparent	mmHeight�mmLeft	mmTop�mmWidthRfBandType  TppSystemVariableppEmpSalesCalc2UserNameEmpSalesCalc2	AlignmenttaRightJustifyVarTypevtPageSetDescFont.CharsetDEFAULT_CHARSET
Font.ColorclBlack	Font.NameTimes New Roman	Font.Size

Font.Style Transparent	mmHeight�mmLeft�� mmTop�mmWidth�;BandType   TppGroupppEmpSalesGroup1	BreakNameEmpNoDataPipelineplEmployeeOrderUserNameEmpSalesGroup1mmNewColumnThreshold mmNewPageThreshold  TppGroupHeaderBandppEmpSalesGroupHeaderBand1mmBottomOffset mmHeight�/mmPrintPosition  TppShapeppEmpSalesShape1UserNameppEmpSalesShape1Brush.ColorclSilverParentHeight	ParentWidth		Pen.ColorclSilvermmHeight�/mmLeft mmTop mmWidth� BandTypeGroupNo   TppLabelppEmpSalesLabel1UserNameppEmpSalesLabel1Caption	Salesman:ColorclSilverFont.CharsetDEFAULT_CHARSET
Font.ColorclBlack	Font.NameArial	Font.Size

Font.StylefsBold Transparent	mmHeight�mmLeftmmTopmmWidth?EBandTypeGroupNo   	TppDBTextppEmpSalesDBText1UserNameppEmpSalesDBText1ColorclSilver	DataField	FirstNameDataPipelineplEmployeeOrderFont.CharsetDEFAULT_CHARSET
Font.ColorclBlack	Font.NameArial	Font.Size

Font.StylefsBoldfsItalic Transparent	mmHeight�mmLefttjmmTopmmWidth]BandTypeGroupNo   	TppDBTextppEmpSalesDBText3UserNameppEmpSalesDBText3ColorclSilver	DataFieldLastNameDataPipelineplEmployeeOrderFont.CharsetDEFAULT_CHARSET
Font.ColorclBlack	Font.NameArial	Font.Size

Font.StylefsBoldfsItalic Transparent	mmHeight�mmLefttjmmTop�mmWidth|BandTypeGroupNo   TppLabelppEmpSalesLabel2UserNameppEmpSalesLabel2CaptionSalaryColorclSilverFont.CharsetDEFAULT_CHARSET
Font.ColorclBlack	Font.NameArial	Font.Size

Font.StylefsBold Transparent	mmHeight�mmLeftaU mmTop�mmWidth`*BandTypeGroupNo   	TppDBTextppEmpSalesDBText2UserNameppEmpSalesDBText2ColorclSilver	DataFieldEmpNoDataPipelineplEmployeeOrderFont.CharsetDEFAULT_CHARSET
Font.ColorclBlack	Font.NameArial	Font.Size

Font.StylefsBold Transparent	mmHeight�mmLeft�QmmTopmmWidth�BandTypeGroupNo   TppLabelppEmpSalesLabel3UserNameppEmpSalesLabel3CaptionSales AmountColorclSilverFont.CharsetDEFAULT_CHARSET
Font.ColorclBlack	Font.NameArial	Font.Size

Font.StylefsBold TextAlignmenttaRightJustifiedTransparent	WordWrap	mmHeight$#mmLeft�� mmTop"mmWidth�4BandTypeGroupNo   TppLabelppEmpSalesLabel4UserNameppEmpSalesLabel4CaptionOrder NumberColorclSilverFont.CharsetDEFAULT_CHARSET
Font.ColorclBlack	Font.NameArial	Font.Size

Font.StylefsBold Transparent	WordWrap	mmHeight!mmLeftϊ mmTop<mmWidth�3BandTypeGroupNo   TppLabelppEmpSalesLabel5UserNameppEmpSalesLabel5CaptionNetColorclSilverFont.CharsetDEFAULT_CHARSET
Font.ColorclBlack	Font.NameArial	Font.Size

Font.StylefsBold TextAlignmenttaRightJustifiedTransparent	WordWrap	mmHeight�mmLeft�� mmTop�mmWidth�BandTypeGroupNo   	TppDBTextppEmpSalesDBText5UserNameppEmpSalesDBText5ColorclSilver	DataFieldPhoneExtDataPipelineplEmployeeOrderDisplayFormat!\X99999;0; Font.CharsetDEFAULT_CHARSET
Font.ColorclBlack	Font.NameArial	Font.Size

Font.StylefsBold SuppressRepeatedValues	Transparent	mmHeight�mmLeft7�  mmTop"mmWidth>BandTypeGroupNo    TppGroupFooterBandppEmpSalesGroupFooterBand1BeforePrint%ppEmpSalesGroupFooterBand1BeforePrintmmBottomOffset mmHeightW)mmPrintPosition  	TppDBCalcppDBCalcSumSalesUserNameppDBCalcSumSalesAutoSize		DataField
ItemsTotalDataPipelineplEmployeeOrderDisplayFormat$#,0.00;($#,0.00)Font.CharsetDEFAULT_CHARSET
Font.ColorclBlack	Font.NameArial	Font.Size

Font.StylefsBold 
ResetGroupppEmpSalesGroup1TextAlignmenttaRightJustifiedTransparent	mmHeight�mmLeft� mmTop^mmWidthtjBandTypeGroupNo   TppLineppEmpSalesLine1UserNameppEmpSalesLine1StylelsDoubleWeight       ��?mmHeight�mmLeft�� mmTop	mmWidth�YBandTypeGroupNo   	TppDBText
ppDBSalaryUserName
ppDBSalaryAutoSize		DataFieldSalaryDataPipelineplEmployeeOrderDisplayFormat$#,0.00;($#,0.00)Font.CharsetDEFAULT_CHARSET
Font.ColorclBlack	Font.NameArial	Font.Size

Font.StylefsBoldfsItalic Transparent	mmHeight�mmLeft�= mmTop^mmWidth%BBandTypeGroupNo   TppLineppEmpSalesLine4UserNameppEmpSalesLine4	Pen.ColorclSilver	Pen.WidthParentWidth	Weight       � @mmHeightM	mmLeft mmTop
 mmWidth� BandTypeGroupNo   TppLineppEmpSalesLine5UserNameppEmpSalesLine5	Pen.ColorclSilver	Pen.WidthPositionlpLeftWeight       � @mmHeight
 mmLeft mmTop mmWidth�BandTypeGroupNo   TppLineppEmpSalesLine6UserNameppEmpSalesLine6	Pen.ColorclSilver	Pen.WidthPositionlpRightWeight       � @mmHeight
 mmLeft� mmTop mmWidth�BandTypeGroupNo   TppVariable	ppCalcNetUserName
ppCalcNet1	CalcOrder DataTypedtDoubleDisplayFormat$#,0.00;($#,0.00)Font.CharsetDEFAULT_CHARSET
Font.ColorclBlack	Font.NameArial	Font.Size

Font.StylefsBoldfsItalic Transparent	mmHeight�mmLeftݡ mmTop^mmWidth�0BandTypeGroupNo          