//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop
USERES("dcldxPSDBTeeChartC14.res");
USEPACKAGE("dxPSCoreC14.bpi");
USEPACKAGE("dcldxPSTeeChartC14.bpi");
USEPACKAGE("dxPSDBTeeChartC14.bpi");
USEPACKAGE("rtl.bpi");
USEPACKAGE("vcl.bpi");
USEPACKAGE("vclx.bpi");
USEPACKAGE("dbrtl.bpi");
USEPACKAGE("vclimg.bpi");
USEPACKAGE("dxComnC14.bpi");
USEPACKAGE("vcldb.bpi");
USEPACKAGE("dxThemeC14.bpi");
USEPACKAGE("dxCoreC14.bpi");
USEPACKAGE("cxDataC14.bpi");
USEPACKAGE("dxGDIPlusC14.bpi");
USEPACKAGE("cxLibraryC14.bpi");
USEPACKAGE("cxEditorsC14.bpi");
USEPACKAGE("cxExtEditorsC14.bpi");
USEPACKAGE("cxPageControlC14.bpi");
USEPACKAGE("designide.bpi");
USEPACKAGE("dxPSTeeChartC14.bpi");
USEPACKAGE("dcldxPSCoreC14.bpi");
#ifndef TEEPRO
USEPACKAGE("tee.bpi");
USEPACKAGE("teedb.bpi");
#elif defined(TEE5)
USEPACKAGE("tee5C14.bpi");
USEPACKAGE("teedb5C14.bpi");
#elif defined(TEE6)
USEPACKAGE("tee6C14.bpi");
USEPACKAGE("teedb6C14.bpi");
#elif defined(TEE7)
USEPACKAGE("tee714.bpi");
USEPACKAGE("teedb714.bpi");
#elif defined(TEE8)
USEPACKAGE("tee814.bpi");
USEPACKAGE("teedb814.bpi");
#elif defined(TEE9)
USEPACKAGE("tee914.bpi");
USEPACKAGE("teedb914.bpi");
#endif
USEUNIT("dxPSDBTCLnkReg.pas");
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
