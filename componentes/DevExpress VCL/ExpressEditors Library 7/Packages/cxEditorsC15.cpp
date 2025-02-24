//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop
USERES("cxEditorsC15.res");
USEPACKAGE("vcl.bpi");
USEPACKAGE("rtl.bpi");
USEPACKAGE("dxCoreC15.bpi");
USEPACKAGE("cxLibraryC15.bpi");
USEPACKAGE("cxDataC15.bpi");
USEPACKAGE("dxGDIPlusC15.bpi");
USEPACKAGE("dxThemeC15.bpi");
USEPACKAGE("vclimg.bpi");
USEPACKAGE("Vcldb.bpi");
USEPACKAGE("dbrtl.bpi");
USEUNIT("cxBlobEdit.pas");
USEUNIT("cxButtonEdit.pas");
USEUNIT("cxButtons.pas");
USEUNIT("cxCalc.pas");
USEUNIT("cxCalendar.pas");
USEUNIT("cxCheckBox.pas");
USEUNIT("cxCurrencyEdit.pas");
USEUNIT("cxDBEdit.pas");
USEUNIT("cxDBEditRepository.pas");
USEUNIT("cxDBLookupEdit.pas");
USEUNIT("cxDropDownEdit.pas");
USEUNIT("cxEdit.pas");
USEUNIT("cxEditConsts.pas");
USEUNIT("cxEditDataRegisteredRepositoryItems.pas");
USEUNIT("cxEditDBRegisteredRepositoryItems.pas");
USEUNIT("cxEditPaintUtils.pas");
USEUNIT("cxEditRepositoryItems.pas");
USEUNIT("cxEditUtils.pas");
USEUNIT("cxHyperLinkEdit.pas");
USEUNIT("cxImage.pas");
USEUNIT("cxImageComboBox.pas");
USEUNIT("cxLookupDBGrid.pas");
USEUNIT("cxLookupEdit.pas");
USEUNIT("cxLookupGrid.pas");
USEUNIT("cxMaskEdit.pas");
USEUNIT("cxMemo.pas");
USEUNIT("cxMRUEdit.pas");
USEUNIT("cxRegExpr.pas");
USEUNIT("cxSpinEdit.pas");
USEUNIT("cxStandardMask.pas");
USEUNIT("cxTextEdit.pas");
USEUNIT("cxTimeEdit.pas");
USEUNIT("cxListBox.pas");
USEUNIT("cxEditRegisteredRepositoryItems.pas");
USEUNIT("cxDBLookupComboBox.pas");
USEUNIT("cxRadioGroup.pas");
USEUNIT("cxFilterControl.pas");
USEUNIT("cxFilterControlUtils.pas");
USEUNIT("cxFilterControlStrs.pas");
USEUNIT("cxNavigator.pas");
USEUNIT("cxDBNavigator.pas");
USEUNIT("cxDBFilterControl.pas");
USEUNIT("cxInplaceContainer.pas");
USEFORMNS("cxFilterControlDialog.pas", fmfiltercontroldialog, fmFilterControlDialog);
USEFORMNS("cxEditMaskEditor.pas", Cxeditmaskeditor, cxEditMaskEditorDlg);
USEUNIT("cxPropertiesConverters.pas");
USEUNIT("cxGroupBox.pas");
//---------------------------------------------------------------------------
#pragma package(smart_init)
//---------------------------------------------------------------------------

//   Package source.
//---------------------------------------------------------------------------

#pragma argsused
int WINAPI DllEntryPoint(HINSTANCE hinst, unsigned long reason, void*)
{
        return 1;
}
//---------------------------------------------------------------------------
