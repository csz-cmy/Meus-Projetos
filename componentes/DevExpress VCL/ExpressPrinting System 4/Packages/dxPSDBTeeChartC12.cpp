//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop
USERES("dxPSDBTeeChartC12.res");
USEPACKAGE("rtl.bpi");
USEPACKAGE("dxPSCoreC12.bpi");
USEPACKAGE("dxPSTeeChartC12.bpi");
USEPACKAGE("vcl.bpi");
USEPACKAGE("vclx.bpi");
USEPACKAGE("dbrtl.bpi");
USEPACKAGE("vclimg.bpi");
USEPACKAGE("dxComnC12.bpi");
USEPACKAGE("vcldb.bpi");
USEPACKAGE("dxThemeC12.bpi");
USEPACKAGE("dxCoreC12.bpi");
USEPACKAGE("cxDataC12.bpi");
USEPACKAGE("dxGDIPlusC12.bpi");
USEPACKAGE("cxLibraryC12.bpi");
USEPACKAGE("cxEditorsC12.bpi");
USEPACKAGE("cxExtEditorsC12.bpi");
USEPACKAGE("cxPageControlC12.bpi");
#ifndef TEEPRO
USEPACKAGE("tee.bpi");
USEPACKAGE("teedb.bpi");
#elif defined(TEE5)
USEPACKAGE("tee5C12.bpi");
USEPACKAGE("teedb5C12.bpi");
#elif defined(TEE6)
USEPACKAGE("tee6C12.bpi");
USEPACKAGE("teedb6C12.bpi");
#elif defined(TEE7)
USEPACKAGE("tee712.bpi");
USEPACKAGE("teedb712.bpi");
#elif defined(TEE8)
USEPACKAGE("tee812.bpi");
USEPACKAGE("teedb812.bpi");
#elif defined(TEE9)
USEPACKAGE("tee912.bpi");
USEPACKAGE("teedb912.bpi");
#endif
USEUNIT("dxPSDBTCLnk.pas");
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
