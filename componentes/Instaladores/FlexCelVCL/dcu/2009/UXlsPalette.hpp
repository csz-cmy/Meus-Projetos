// CodeGear C++Builder
// Copyright (c) 1995, 2008 by CodeGear
// All rights reserved

// (DO NOT EDIT: machine generated header) 'Uxlspalette.pas' rev: 20.00

#ifndef UxlspaletteHPP
#define UxlspaletteHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member functions
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <Sysinit.hpp>	// Pascal unit
#include <Classes.hpp>	// Pascal unit
#include <Sysutils.hpp>	// Pascal unit
#include <Uxlsbaserecords.hpp>	// Pascal unit
#include <Uxlsbaserecordlists.hpp>	// Pascal unit
#include <Xlsmessages.hpp>	// Pascal unit
#include <Uflxmessages.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Uxlspalette
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TPaletteRecord;
class PASCALIMPLEMENTATION TPaletteRecord : public Uxlsbaserecords::TBaseRecord
{
	typedef Uxlsbaserecords::TBaseRecord inherited;
	
private:
	unsigned __fastcall GetColor(int index);
	void __fastcall SetColor(int index, const unsigned Value);
	System::Word __fastcall GetCount(void);
	
public:
	__property System::Word Count = {read=GetCount, nodefault};
	__property unsigned Color[int index] = {read=GetColor, write=SetColor};
	__fastcall TPaletteRecord(void);
public:
	/* TBaseRecord.Create */ inline __fastcall virtual TPaletteRecord(const System::Word aId, const Xlsmessages::PArrayOfByte aData, const int aDataSize) : Uxlsbaserecords::TBaseRecord(aId, aData, aDataSize) { }
	/* TBaseRecord.Destroy */ inline __fastcall virtual ~TPaletteRecord(void) { }
	
};


//-- var, const, procedure ---------------------------------------------------
extern PACKAGE unsigned __fastcall StandardPalette(const int Index);

}	/* namespace Uxlspalette */
using namespace Uxlspalette;
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// UxlspaletteHPP
