// CodeGear C++Builder
// Copyright (c) 1995, 2009 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'Uflxnumberformat.pas' rev: 21.00

#ifndef UflxnumberformatHPP
#define UflxnumberformatHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member functions
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <Sysinit.hpp>	// Pascal unit
#include <Sysutils.hpp>	// Pascal unit
#include <Variants.hpp>	// Pascal unit
#include <Uflxmessages.hpp>	// Pascal unit
#include <Math.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Uflxnumberformat
{
//-- type declarations -------------------------------------------------------
//-- var, const, procedure ---------------------------------------------------
extern PACKAGE System::UnicodeString __fastcall XlsFormatValue [[deprecated("Use XlsFormatValue1904 instead.")]](const System::Variant &V, const System::UnicodeString Format, int &Color);
extern PACKAGE System::UnicodeString __fastcall XlsFormatValue1904(const System::Variant &V, const System::UnicodeString Format, const bool Dates1904, int &Color, Uflxmessages::PFormatSettings FormatSettings = (void *)(0x0));
extern PACKAGE bool __fastcall HasXlsDateTime(const System::UnicodeString Format, /* out */ bool &HasDate, /* out */ bool &HasTime, Uflxmessages::PFormatSettings FormatSettings = (void *)(0x0));

}	/* namespace Uflxnumberformat */
using namespace Uflxnumberformat;
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// UflxnumberformatHPP
