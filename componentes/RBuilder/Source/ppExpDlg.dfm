�
 TPPOPENSAVEDIALOG 0�  TPF0TppOpenSaveDialogppOpenSaveDialogLeftTop� BorderStylebsDialogCaption
Save <> AsClientHeight	ClientWidth�Color	clBtnFace
ParentFont	OldCreateOrderPositionpoScreenCenterShowHint	OnCreate
FormCreate	OnDestroyFormDestroyPixelsPerInch`
TextHeight TLabel	lblSaveInLeftTopWidth'HeightCaption	Save &in:  TSpeedButtonspbUpOneLevelLeft!TopWidthHeightFlat	OnClickspbUpOneLevelClick  TSpeedButtonspbNewFolderLeftCTopWidthHeightFlat	OnClickspbNewFolderClick  TSpeedButtonspbListViewLeftdTopWidthHeight
GroupIndexDown	Flat	OnClickspbListViewClick  TSpeedButtonspbDetailViewLeft|TopWidthHeight
GroupIndexFlat	OnClickspbDetailViewClick  TLabellblItemNameLeftTop� Width4HeightCaptionItem &name:  TLabellblSaveAsTypeLeftTop� WidthAHeightCaptionSave as &type:Visible  TPanelsplViewsLeft Top WidthHeight	CursorcrHSplitAlignalLeft
BevelOuterbvNoneTabOrder   	TComboBoxcbxFileTypeLeftPTop� Width� HeightStylecsDropDownList
ItemHeightTabOrderVisible  TEditedtItemNameLeftPTop� Width� HeightTabOrderOnChangeedtItemNameChange  TButtonbtnOKLeftNTop� WidthKHeightCaption&SaveDefault	TabOrderOnClick
btnOKClick  TButton	btnCancelLeftMTop� WidthKHeightCancel	CaptionCancelModalResultTabOrder  TButtonbtnHelpLeftMTop� WidthKHeightCaptionHelpTabOrderOnClickbtnHelpClick  	TComboBox
cbxFoldersLeftJTopWidth� HeightStylecsOwnerDrawVariable
ItemHeightTabOrderOnChangecbxFoldersChange
OnDrawItemcbxFoldersDrawItem
OnDropDowncbxFoldersDropDownOnMeasureItemcbxFoldersMeasureItem  
TPopupMenuppmItemsLeft{Top�  	TMenuItemppmViewCaptionView 	TMenuItemppmViewListCaption&ListChecked	
GroupIndex	RadioItem	OnClickppmViewListClick  	TMenuItemppmViewDetailsCaption&Details
GroupIndex	RadioItem	OnClickppmViewDetailsClick   	TMenuItemN8Caption-  	TMenuItemppmNewFolderCaptionNew &FolderOnClickppmNewFolderClick  	TMenuItemN10Caption-  	TMenuItem	ppmDeleteCaption&DeleteOnClickppmDeleteClick  	TMenuItem	ppmRenameCaptionRena&meOnClickppmRenameClick    