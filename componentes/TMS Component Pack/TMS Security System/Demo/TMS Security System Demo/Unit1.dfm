�
 TFORM1 0s&  TPF0TForm1Form1Left�Top� CaptionTMS Security Demo ApplicationClientHeight�ClientWidth!Color	clBtnFaceFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style Menu	MainMenu1OldCreateOrder	OnCreate
FormCreatePixelsPerInch`
TextHeight TShapeShape1LeftTopWidth� HeightmBrush.Color��� ShapestRoundRectVisible  TShapeShape2LeftTop|Width� Height� Brush.ColorclInfoBkShapestRoundRectVisible  TShapeShape3LeftTop� Width� Height� Visible  TShapeShape4LeftTopWidth� HeightABrush.Color��� ShapestRoundRectVisible  TLabelLabel1LeftXTopWidthJHeightCaptionUser TablesFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.StylefsBold 
ParentFontTransparent	Visible  TLabelLabel2Left\Top(WidthHeightCaptionUsersTransparent	Visible  TLabelLabel3Left\TopHWidthzHeightCaption,User Permissions
(Master Detailed to Users)Transparent	Visible  TLabelLabel4LeftXTop� WidthUHeightCaptionGroup TablesFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.StylefsBold 
ParentFontTransparent	Visible  TLabelLabel5LeftXTop� Width"HeightCaptionGroupsTransparent	Visible  TLabelLabel6LeftXTop� Width� HeightCaption.Group Permissions
(Master Detailed to Groups)Transparent	Visible  TLabelLabel7LeftXTop� WidthYHeightCaptionGroup MembershipTransparent	Visible  TLabelLabel8LeftLTopWidthnHeightCaptionPermission TableFont.CharsetDEFAULT_CHARSET
Font.ColorclBlackFont.Height�	Font.NameArial
Font.StylefsBold 
ParentFontTransparent	Visible  TLabelLabel9LeftTop� WidthpHeightCaptionSecurity ManagerFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.StylefsBold 
ParentFontTransparent	Visible  TShapeShape5Left�TopWidth� HeightyBrush.Color
clGrayTextVisible  TLabelLabel10Left�TopWidthLHeightCaptionForm PolicyFont.CharsetDEFAULT_CHARSET
Font.ColorclWhiteFont.Height�	Font.NameArial
Font.StylefsBold 
ParentFontTransparent	Visible  TShapeShape6Left�Top� Width� Height� Brush.ColorclOliveVisible  TLabelLabel11Left�Top� Width/HeightCaptionDialogsFont.CharsetDEFAULT_CHARSET
Font.ColorclWhiteFont.Height�	Font.NameArial
Font.StylefsBold 
ParentFontTransparent	Visible  TLabelLabel12LeftTop� WidthuHeight=AutoSizeCaptionZThis is the main part of the system. All form policies and dialogs link to this component.Transparent	VisibleWordWrap	  TLabelLabel13Left�TopUWidthuHeight-AutoSizeCaptionFThis component controls what parts of the form are disabled or hidden.Font.CharsetDEFAULT_CHARSET
Font.ColorclWhiteFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFontTransparent	VisibleWordWrap	  TLabelLabel14Left�Top� Width;HeightCaptionLogin DialogColorclWhiteFont.CharsetDEFAULT_CHARSET
Font.ColorclWhiteFont.Height�	Font.NameMS Sans Serif
Font.Style ParentColor
ParentFontTransparent	Visible  TLabelLabel15Left�Top� WidthNHeight'Caption User and Group Management DialogColorclWhiteFont.CharsetDEFAULT_CHARSET
Font.ColorclWhiteFont.Height�	Font.NameMS Sans Serif
Font.Style ParentColor
ParentFontTransparent	VisibleWordWrap	  TShapeShape7Left TopWidthAHeightA  TLabelLabel16LeftgTopWidth� Height4CaptiontThe shape is controlled by a custom secure action. Admins should get the rectangle shape, guests the circular shape.WordWrap	  TLabelLabel17Left�Top� WidthvHeightCaptionChange password DialogColorclWhiteFont.CharsetDEFAULT_CHARSET
Font.ColorclWhiteFont.Height�	Font.NameMS Sans Serif
Font.Style ParentColor
ParentFontTransparent	Visible  TuilSecurityManageruilSecurityManager1UserBindary.DataSource
dsADOUsersUserBindary.OnEncryptuilSecurityManager1EncryptUserBindary.UserNameField	LoginNameUserBindary.FullNameFieldFullNameUserBindary.PasswordFieldPasswordUserBindary.AccessCountFieldAccessCountUserBindary.CreatedDateFieldCreatedDateUserBindary.CreatedTimeFieldCreatedTimeUserBindary.EnabledFieldEnabledUserBindary.LastAccessField
LastAccessUserBindary.LastAccessTimeFieldLastAccTime&UserBindary.UserPermissions.DataSourcedsADOUserAccess+UserBindary.UserPermissions.PermissionField
Permission)UserBindary.UserPermissions.UserNameFieldUserNameGroupBindary.DataSourcedsADOGroupsGroupBindary.GroupNameField	GroupName"GroupBindary.GroupDescriptionFieldDescription(GroupBindary.GroupPermissions.DataSourcedsADOGroupAccess-GroupBindary.GroupPermissions.PermissionField
Permission,GroupBindary.GroupPermissions.GroupNameField	GroupName.GroupBindary.GroupMembershipBindary.DataSourcedsADOGroupMembers2GroupBindary.GroupMembershipBindary.GroupNameField	GroupName1GroupBindary.GroupMembershipBindary.UserNameFieldUserNamePermissionBindary.DataSourcedsADOPermissions!PermissionBindary.PermissionField
PermissionPermissionBindary.ActionFieldActionPermissionBindary.ItemFieldItemsPermissionBindary.FormNameFieldFormNamePermissionBindary.StoragepsTableVersion2.4.2.2	OnEncryptuilSecurityManager1EncryptOnFailedLoginuilSecurityManager1FailedLoginOnDisabledLogin uilSecurityManager1DisabledLoginLeft4Top�   TuilLoginDlguilLoginDlg1SecurityManageruilSecurityManager1TitleCaptionLoginUsernameCaption	Username:PasswordCaption	Password:LoginButtonCaptionLoginCancelButtonCaptionCancelLeft�Top�   TuilSecurityDlguilSecurityDlg1FormCaptionSecurity SettingsUsersCaptionUsersGroupsCaptionGroupsMembershipCaption
MembershipSecurityManageruilSecurityManager1RegistryKey Software\UIL\UIL Security SystemSaveToRegistryLeft�Top�   	TMainMenu	MainMenu1LeftTop 	TMenuItemFile1Caption&FileLeftTop� 	TMenuItemNew1CaptionNew...Left�Top�  	TMenuItemOpen1CaptionOpen...Left�Top�  	TMenuItemSave1CaptionSaveLeft�Top�  	TMenuItemSaveAs1Caption
Save As...Left�Top�  	TMenuItemN1Caption-Left[Top�  	TMenuItemExit1CaptionE&xitOnClick
Exit1ClickLeft[Top�   	TMenuItemEdit1CaptionEdit 	TMenuItemCopy1CaptionCopy   	TMenuItemTools1Caption&ToolsLeft[Top� 	TMenuItemNewtool1CaptionNew tool  	TMenuItem	Spelling1CaptionSpelling...OnClickSpelling1ClickLeft[Top�  	TMenuItemN2Caption-Left[Top�  	TMenuItemChangepassword1CaptionChange passwordOnClickChangepassword1Click  	TMenuItemUserManagement1Caption&User ManagementOnClickUserManagement1ClickLeft[Top�  	TMenuItemFormpolicy1CaptionForm policyOnClickFormpolicy1Click   	TMenuItemLogin1CaptionLoginLeft[Top� 	TMenuItemLogin2CaptionLogin...OnClickLogin2ClickLeft[Top�  	TMenuItemLogout1CaptionLogoutOnClickLogout1ClickLeft[Top�    TuilFormPolicyuilFormPolicy1PoliciesItems.Strings	Spelling1 
PolicyNameSpell ChecksPolicyAction	paDisable Items.Strings	Spelling1Tools1UserManagement1 
PolicyNameMenuPolicyActionpaHide 
PolicyNameButton2PolicyActionpaHide Items.StringsShape7 
PolicyNameCustomPolicyActionpaCustom  SecurityManageruilSecurityManager1Version2.4.2.2OnCustomSecureuilFormPolicy1CustomSecureLeft�Top(  	TDatabase	Database1	Connected	DatabaseNameUILDEMOS
DriverNameSTANDARDLoginPromptParams.Stringspath=.\data SessionNameDefaultLeft,Top8  TuilFormPolicyDlguilFormPolicyDlg1
FormPolicyuilFormPolicy1
IgnoreList	ComponentEdit1    RegistryKey$Software\tmssoftware\Security SystemSaveToRegistryLeft�Top,  TActionListActionList1Left0Top TEditCutEditCut1CategoryEditCaptionCu&tHint3Cut|Cuts the selection and puts it on the Clipboard
ImageIndex ShortCutX@  	TEditCopy	EditCopy1CategoryEditCaption&CopyHint6Copy|Copies the selection and puts it on the Clipboard
ImageIndexShortCutC@   	TADOTableADOUsers
ConnectionADOConnection1	TableNameUsersLeft0Top  	TADOTableADOUserAccess
ConnectionADOConnection1IndexFieldNamesUserNameMasterFields	LoginNameMasterSource
dsADOUsers	TableName
UserAccessLeft0Top8  TADOConnectionADOConnection1	Connected	ConnectionString\Provider=Microsoft.Jet.OLEDB.4.0;Data Source=.\Data\security.mdb;Persist Security Info=FalseLoginPromptModecmShareDenyNoneProviderMicrosoft.Jet.OLEDB.4.0Left� Top  TDataSource
dsADOUsersDataSetADOUsersLeftTop  TDataSourcedsADOUserAccessDataSetADOUserAccessLeftTop8  TDataSourcedsADOGroupsDataSet	ADOGroupsLeftTop�   TDataSourcedsADOGroupAccessDataSetADOGroupAccessLeftTop�   TDataSourcedsADOGroupMembersDataSetADOGroupMembersLeftTop�   	TADOTable	ADOGroups
ConnectionADOConnection1	TableNameGroupsLeft0Top�   	TADOTableADOGroupAccess
ConnectionADOConnection1IndexFieldNames	GroupNameMasterFields	GroupNameMasterSourcedsADOGroups	TableNameGroupAccessLeft0Top�   	TADOTableADOGroupMembers
ConnectionADOConnection1	TableNameGroupMembersLeft0Top�   	TADOTableADOPermissionsActive	
ConnectionADOConnection1
CursorTypectStatic	TableNamePermissionsLeft0Top   TDataSourcedsADOPermissionsDataSetADOPermissionsLeftTop   TuilChangePasswordDlguilChangePasswordDlg1SecurityManageruilSecurityManager1TitleCaptionChange PasswordCurrentPasswordCaption&Current password:NewPasswordCaption&New password:ConfirmPasswordCaptionC&onfirm passwordOKButtonCaptionOKCancelButtonCaptionCancelLeft�Top�    