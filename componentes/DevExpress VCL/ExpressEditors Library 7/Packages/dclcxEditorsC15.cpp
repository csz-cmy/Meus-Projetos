//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop
USERES("dclcxEditorsC15.res");
USEPACKAGE("vcl.bpi");
USEPACKAGE("rtl.bpi");
USEPACKAGE("dxCoreC15.bpi");
USEPACKAGE("dcldxCoreC15.bpi");
USEPACKAGE("designide.bpi");
USEPACKAGE("dclcxLibraryC15.bpi");
USEPACKAGE("cxEditorsC15.bpi");
USEPACKAGE("vcldb.bpi");
USEPACKAGE("dbrtl.bpi");
USEPACKAGE("vclx.bpi");
USEPACKAGE("dxThemeC15.bpi");
USEPACKAGE("cxLibraryC15.bpi");
USEPACKAGE("cxDataC15.bpi");
USEUNIT("cxEditPropEditors.pas");
USEUNIT("cxEditReg.pas");
USERES("cxEditReg.dcr");
USEFORMNS("cxMaskEditTextEditor.pas", Cxmaskedittexteditor, cxMaskEditTextEditorDlg);
USEFORMNS("cxSelectEditRepositoryItem.pas", Cxselecteditrepositoryitem, cxSelectRepositoryItem);
USEUNIT("cxEditRepositoryEditor.pas");
USEUNIT("cxFilterControlReg.pas");
USEUNIT("cxInplaceContainerReg.pas");
USERES("cxFilterControlReg.dcr");
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
