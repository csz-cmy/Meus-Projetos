�
 TFORM1 0s:  TPF0TForm1Form1LeftTopWidth�HeightCaptionVisual Query DemoColor	clBtnFaceFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style OldCreateOrderPositionpoScreenCenterPixelsPerInch`
TextHeight 	TSplitter	Splitter1Left Top� Width�HeightCursorcrVSplitAlignalTop  TatVisualQueryatVisualQuery1Left TopHWidth�HeightLMetaSqlDefsMetaSqlatVisualQuery1.MetaSql1TitleOrders filter	ParamDefsNameCountryCaptionCountry	ParamTypeptDistinctList	ListItems  
MetaSqlStr9SELECT DISTINCT Country FROM Customer.db ORDER BY CountryWidthoTextUS NameCompanyCaptionCompany	ListItems  Width0 NamePaymentmethodCaptionPaymentmethod	ParamTypeptDistinctList	ListItems  
MetaSqlStrCSELECT DISTINCT Paymentmethod FROM Orders.db ORDER BY PaymentmethodTextVisa Name
ItemstotalCaptionTotal of items less than	ListItems  Widthp   MetaSqlatVisualQuery1.MetaSql2TitleCustomers in US MetaSqlatVisualQuery1.MetaSql3Title+Total sales by customer (only US customers)  ResizeHeightColor	clBtnFaceAutoAdjustHeight	TargetDatasetQuery1DatabaseatBdeDatabase1	SQLSyntax
ssBdeLocalDisablePrettyTextQualifiedFieldAliasesFieldAliasSeparator_AutoUpdateFieldAliasesSelectionColorclHighlightSelectionFontColorclHighlightText
ItemHeightAlignalTopBorderStylebsNoneTabOrder  TatInternalMetaSqlMetaSql1	SQLSyntax
ssBdeLocal	SQLTables	TableNameCustomer.db
TableAliasCustomer 	TableName	Orders.db
TableAliasOrders  	SQLFields
FieldAliasCountryDataTypeftString	FieldNameCountry
TableAliasCustomer 
FieldAliasStateActiveDataTypeftString	FieldNameState
TableAliasCustomer 
FieldAliasCityActiveDataTypeftString	FieldNameCity
TableAliasCustomer 
FieldAliasCompanyDataTypeftString	FieldNameCompany
TableAliasCustomer 
FieldAliasCustnoActiveDataTypeftFloat	FieldNameCustno
TableAliasCustomer 
FieldAliasAddr1ActiveDataTypeftString	FieldNameAddr1
TableAliasCustomer 
FieldAliasAddr2ActiveDataTypeftString	FieldNameAddr2
TableAliasCustomer 
FieldAliasZipActiveDataTypeftString	FieldNameZip
TableAliasCustomer 
FieldAliasPhoneActiveDataTypeftString	FieldNamePhone
TableAliasCustomer 
FieldAliasFaxActiveDataTypeftString	FieldNameFax
TableAliasCustomer 
FieldAliasTaxrateActiveDataTypeftFloat	FieldNameTaxrate
TableAliasCustomer 
FieldAliasContactActiveDataTypeftString	FieldNameContact
TableAliasCustomer 
FieldAliasLastinvoicedateActiveDataType
ftDateTime	FieldNameLastinvoicedate
TableAliasCustomer 
FieldAliasOrdernoDataTypeftFloat	FieldNameOrderno
TableAliasOrdersGroupFunctionagfCount 
FieldAliasCustno1ActiveDataTypeftFloat	FieldNameCustno
TableAliasOrders 
FieldAliasSaledateActiveDataType
ftDateTime	FieldNameSaledate
TableAliasOrders 
FieldAliasShipdateActiveDataType
ftDateTime	FieldNameShipdate
TableAliasOrders 
FieldAliasEmpnoActiveDataType	ftInteger	FieldNameEmpno
TableAliasOrders 
FieldAliasShiptocontactActiveDataTypeftString	FieldNameShiptocontact
TableAliasOrders 
FieldAliasShiptoaddr1ActiveDataTypeftString	FieldNameShiptoaddr1
TableAliasOrders 
FieldAliasShiptoaddr2ActiveDataTypeftString	FieldNameShiptoaddr2
TableAliasOrders 
FieldAlias
ShiptocityActiveDataTypeftString	FieldName
Shiptocity
TableAliasOrders 
FieldAliasShiptostateActiveDataTypeftString	FieldNameShiptostate
TableAliasOrders 
FieldAlias	ShiptozipActiveDataTypeftString	FieldName	Shiptozip
TableAliasOrders 
FieldAliasShiptocountryActiveDataTypeftString	FieldNameShiptocountry
TableAliasOrders 
FieldAliasShiptophoneActiveDataTypeftString	FieldNameShiptophone
TableAliasOrders 
FieldAliasShipviaActiveDataTypeftString	FieldNameShipvia
TableAliasOrders 
FieldAliasPoActiveDataTypeftString	FieldNamePo
TableAliasOrders 
FieldAliasTermsActiveDataTypeftString	FieldNameTerms
TableAliasOrders 
FieldAliasPaymentmethodActiveDataTypeftString	FieldNamePaymentmethod
TableAliasOrders 
FieldAlias
ItemstotalActiveDataType
ftCurrency	FieldName
Itemstotal
TableAliasOrders 
FieldAliasTaxrate1ActiveDataTypeftFloat	FieldNameTaxrate
TableAliasOrders 
FieldAliasFreightActiveDataType
ftCurrency	FieldNameFreight
TableAliasOrders 
FieldAlias
AmountpaidDataType
ftCurrency	FieldName
Amountpaid
TableAliasOrdersGroupFunctionagfSum  
TableJoinsPrimaryTableAliasCustomerForeignTableAliasOrdersLinkTypealtLeftJoinJoinConditionsName
Condition0
FieldAliasCustno1Operator=ValueCustnoConditionTypectFieldCompareSubConditions     
ConditionsName
Condition0
FieldAliasCountryOperator=ValueCountryConditionTypectParamCompareSubConditions  Name
Condition1
FieldAliasPaymentmethodOperator=ValuePaymentmethodConditionTypectParamCompareSubConditions  Name
Condition2
FieldAliasCompanyOperatorSTARTSValueCompanyConditionTypectParamCompareSubConditions  Name
Condition3
FieldAlias
ItemstotalOperator<=Value
ItemstotalConditionTypectParamCompareSubConditions   GroupFields
FieldAliasCountry 
FieldAliasCompany  OrderFields
FieldAliasCountrySortTypeortAscending 
FieldAliasCompanySortTypeortAscending  ParamsDataTypeftStringNameCountry	ParamType	ptUnknownValueUS DataTypeftStringNamePaymentmethod	ParamType	ptUnknownValueVisa DataTypeftStringNameCompany	ParamType	ptUnknownActive DataTypeftStringName
Itemstotal	ParamType	ptUnknownActive    TatInternalMetaSqlMetaSql2	SQLSyntax
ssBdeLocal	SQLTables	TableNameCustomer.db
TableAliasCustomer  	SQLFields
FieldAliasCustnoDataTypeftFloat	FieldNameCustno
TableAliasCustomer 
FieldAliasCompanyDataTypeftString	FieldNameCompany
TableAliasCustomer 
FieldAliasAddr1ActiveDataTypeftString	FieldNameAddr1
TableAliasCustomer 
FieldAliasAddr2ActiveDataTypeftString	FieldNameAddr2
TableAliasCustomer 
FieldAliasCityDataTypeftString	FieldNameCity
TableAliasCustomer 
FieldAliasStateDataTypeftString	FieldNameState
TableAliasCustomer 
FieldAliasZipActiveDataTypeftString	FieldNameZip
TableAliasCustomer 
FieldAliasCountryDataTypeftString	FieldNameCountry
TableAliasCustomer 
FieldAliasPhoneActiveDataTypeftString	FieldNamePhone
TableAliasCustomer 
FieldAliasFaxActiveDataTypeftString	FieldNameFax
TableAliasCustomer 
FieldAliasTaxrateActiveDataTypeftFloat	FieldNameTaxrate
TableAliasCustomer 
FieldAliasContactActiveDataTypeftString	FieldNameContact
TableAliasCustomer 
FieldAliasLastinvoicedateActiveDataType
ftDateTime	FieldNameLastinvoicedate
TableAliasCustomer  
TableJoins 
ConditionsName
Condition0
FieldAliasCountryOperator=ValueUSSubConditions   GroupFields
FieldAliasCustno 
FieldAliasCompany 
FieldAliasCity 
FieldAliasState 
FieldAliasCountry  OrderFields
FieldAliasCompanySortTypeortAscending  Params   TatInternalMetaSqlMetaSql3	SQLSyntax
ssBdeLocal	SQLTables	TableNameCustomer.db
TableAliasCustomer 	TableName	Orders.db
TableAliasOrders  	SQLFields
FieldAliasCustnoActiveDataTypeftFloat	FieldNameCustno
TableAliasCustomer 
FieldAliasCompanyDataTypeftString	FieldNameCompany
TableAliasCustomer 
FieldAliasAddr1ActiveDataTypeftString	FieldNameAddr1
TableAliasCustomer 
FieldAliasAddr2ActiveDataTypeftString	FieldNameAddr2
TableAliasCustomer 
FieldAliasCityActiveDataTypeftString	FieldNameCity
TableAliasCustomer 
FieldAliasStateActiveDataTypeftString	FieldNameState
TableAliasCustomer 
FieldAliasZipActiveDataTypeftString	FieldNameZip
TableAliasCustomer 
FieldAliasCountryActiveDataTypeftString	FieldNameCountry
TableAliasCustomer 
FieldAliasPhoneActiveDataTypeftString	FieldNamePhone
TableAliasCustomer 
FieldAliasFaxActiveDataTypeftString	FieldNameFax
TableAliasCustomer 
FieldAliasTaxrateActiveDataTypeftFloat	FieldNameTaxrate
TableAliasCustomer 
FieldAliasContactActiveDataTypeftString	FieldNameContact
TableAliasCustomer 
FieldAliasLastinvoicedateActiveDataType
ftDateTime	FieldNameLastinvoicedate
TableAliasCustomer 
FieldAliasOrdernoActiveDataTypeftFloat	FieldNameOrderno
TableAliasOrders 
FieldAliasCustno1ActiveDataTypeftFloat	FieldNameCustno
TableAliasOrders 
FieldAliasSaledateActiveDataType
ftDateTime	FieldNameSaledate
TableAliasOrders 
FieldAliasShipdateActiveDataType
ftDateTime	FieldNameShipdate
TableAliasOrders 
FieldAliasEmpnoActiveDataType	ftInteger	FieldNameEmpno
TableAliasOrders 
FieldAliasShiptocontactActiveDataTypeftString	FieldNameShiptocontact
TableAliasOrders 
FieldAliasShiptoaddr1ActiveDataTypeftString	FieldNameShiptoaddr1
TableAliasOrders 
FieldAliasShiptoaddr2ActiveDataTypeftString	FieldNameShiptoaddr2
TableAliasOrders 
FieldAlias
ShiptocityActiveDataTypeftString	FieldName
Shiptocity
TableAliasOrders 
FieldAliasShiptostateActiveDataTypeftString	FieldNameShiptostate
TableAliasOrders 
FieldAlias	ShiptozipActiveDataTypeftString	FieldName	Shiptozip
TableAliasOrders 
FieldAliasShiptocountryActiveDataTypeftString	FieldNameShiptocountry
TableAliasOrders 
FieldAliasShiptophoneActiveDataTypeftString	FieldNameShiptophone
TableAliasOrders 
FieldAliasShipviaActiveDataTypeftString	FieldNameShipvia
TableAliasOrders 
FieldAliasPoActiveDataTypeftString	FieldNamePo
TableAliasOrders 
FieldAliasTermsActiveDataTypeftString	FieldNameTerms
TableAliasOrders 
FieldAliasPaymentmethodActiveDataTypeftString	FieldNamePaymentmethod
TableAliasOrders 
FieldAlias
ItemstotalActiveDataType
ftCurrency	FieldName
Itemstotal
TableAliasOrders 
FieldAliasTaxrate1ActiveDataTypeftFloat	FieldNameTaxrate
TableAliasOrders 
FieldAliasFreightActiveDataType
ftCurrency	FieldNameFreight
TableAliasOrders 
FieldAlias
AmountpaidDataType
ftCurrency	FieldName
Amountpaid
TableAliasOrdersGroupFunctionagfSum  
TableJoinsPrimaryTableAliasCustomerForeignTableAliasOrdersLinkTypealtLeftJoinJoinConditionsName
Condition0
FieldAliasCustno1Operator=ValueCustnoConditionTypectFieldCompareSubConditions     
ConditionsName
Condition0
FieldAliasCountryOperator=ValueUSSubConditions   GroupFields
FieldAliasCompany  OrderFields Params    TDBGridDBGrid1Left Top� Width�HeightTAlignalClient
DataSourceDataSource1TabOrderTitleFont.CharsetDEFAULT_CHARSETTitleFont.ColorclWindowTextTitleFont.Height�TitleFont.NameMS Sans SerifTitleFont.Style   TPanelPanel1Left Top Width�HeightHAlignalTop
BevelOuterbvNoneBorderWidthTabOrder 	TGroupBox	GroupBox1LeftTopWidth�Height)AnchorsakLeftakTopakRight CaptionQuery setupFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.StylefsBold 
ParentFontTabOrder  TRadioButton
rbAdvancedLeftTopWidtheHeightCaptionAdvanced modeChecked	Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFontTabOrder TabStop	OnClickrbAdvancedClick  TRadioButtonrbParamsLeft� TopWidth� HeightCaptionOnly parameter editorsFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFontTabOrderOnClickrbParamsClick  TRadioButtonrbFilterLeftrTopWidthuHeightCaptionOnly filter conditionsFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFontTabOrderOnClickrbFilterClick  TRadioButton
rbReadOnlyLeftuTopWidthcHeightCaptionRead-only modeFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFontTabOrderOnClickrbReadOnlyClick  TRadioButtonrbQuerySelectLeft�TopWidthmHeightCaptionQuery select modeFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFontTabOrderOnClickrbQuerySelectClick   TButtonbtLeftLeftUTop1WidthPHeightCaptionL&eft positionedFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFontTabOrderOnClickbtLeftClick  TButtonbtTopLeftTop1WidthPHeightCaption&Top positionedFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFontTabOrderOnClick
btTopClick  TButtonbtSmallLeft� Top1WidthPHeightCaption&Small fontsFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFontTabOrderOnClickbtSmallClick  TButton	btColoredLeftHTop1WidthPHeightCaption&ColoredFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFontTabOrderOnClickbtColoredClick  TButtonbtSaveLeft�Top1WidthPHeightCaption&Save queriesFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFontTabOrderOnClickbtSaveClick  TButtonbtLoadLeft�Top1WidthPHeightCaption&Load queriesFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFontTabOrderOnClickbtLoadClick  TButtonButton1Left� Top1WidthPHeightCaption&Large fontsFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFontTabOrderOnClickButton1Click   TQueryQuery1Active	DatabaseNameDBDEMOSSessionNameDefaultSQL.StringsSELECT   Customer.Country  Country,   Customer.Company  Company,"   COUNT(Orders.Orderno)  Orderno,%   SUM(Orders.Amountpaid)  AmountpaidFROM5   (Customer.db  Customer LEFT JOIN Orders.db  Orders&   ON (Orders.Custno = Customer.Custno))WHERE(   upper(Customer.Country) = upper('US')AND+upper(Orders.Paymentmethod) = upper('Visa')AND0=0AND0=0 GROUP BY   Customer.Country,   Customer.CompanyORDER BY   Customer.Country,   Customer.Company LeftTop8  TDataSourceDataSource1DataSetQuery1Left0Top8  TatBdeDatabaseatBdeDatabase1DatabaseNameDBDEMOSSessionNameDefaultLeftTop   