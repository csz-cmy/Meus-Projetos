//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop
USERES("dxFlowChartC6.res");
USEPACKAGE("vclx.bpi");
USEPACKAGE("dxCoreC6.bpi");
USEPACKAGE("dxThemeC6.bpi");
USEPACKAGE("dxGDIPlusC6.bpi");
USEPACKAGE("cxLibraryVCLC6.bpi");
USEUNIT("Dxflchrt.pas");
USEUNIT("dxLines.pas");
USEUNIT("dxFcStrs.pas");
USEFORMNS("dxSelUnion.pas", Dxselunion, FSelectUnion);
USEFORMNS("dxEditCon.pas", Dxeditcon, FEditConnection);
USEFORMNS("dxEditObj.pas", Dxeditobj, FEditObject);
USEFORMNS("dxFcEdit.pas", Dxfcedit, FChartEditor);
//---------------------------------------------------------------------------
#pragma package(smart_init)
//---------------------------------------------------------------------------
//   Package source.
//---------------------------------------------------------------------------
int WINAPI DllEntryPoint(HINSTANCE hinst, unsigned long reason, void*)
{
    return 1;
}
//---------------------------------------------------------------------------
