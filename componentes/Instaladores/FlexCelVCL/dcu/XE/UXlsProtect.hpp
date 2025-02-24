// CodeGear C++Builder
// Copyright (c) 1995, 2010 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'UXlsProtect.pas' rev: 22.00

#ifndef UxlsprotectHPP
#define UxlsprotectHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member functions
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <UFlxMessages.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Uxlsprotect
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TEncryptionData;
class DELPHICLASS TEncryptionEngine;
class PASCALIMPLEMENTATION TEncryptionData : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	System::UnicodeString ReadPassword;
	TEncryptionEngine* Engine;
	int ActualRecordLen;
	__fastcall TEncryptionData(const System::UnicodeString aReadPassword, const System::TObject* aOnPassword, const System::TObject* aXls);
	int __fastcall TotalSize(void);
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TEncryptionData(void) { }
	
};


class PASCALIMPLEMENTATION TEncryptionEngine : public System::TObject
{
	typedef System::TObject inherited;
	
protected:
	__fastcall TEncryptionEngine(void);
	
public:
	virtual bool __fastcall CheckHash(const System::UnicodeString Password) = 0 ;
	virtual Uflxmessages::ByteArray __fastcall Decode(const Uflxmessages::ByteArray Data, const __int64 StreamPosition, const int StartPos, const int Count, const int RecordLen) = 0 ;
	virtual Uflxmessages::ByteArray __fastcall Encode(const void *Data, const __int64 StreamPosition, const int StartPos, const int Count, const int RecordLen) = 0 /* overload */;
	virtual System::Word __fastcall Encode(const System::Word Data, const __int64 StreamPosition, const int RecordLen) = 0 /* overload */;
	virtual unsigned __fastcall Encode(const unsigned Data, const __int64 StreamPosition, const int RecordLen) = 0 /* overload */;
	virtual Uflxmessages::ByteArray __fastcall GetFilePassRecord(void) = 0 ;
	virtual int __fastcall GetFilePassRecordLen(void) = 0 ;
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TEncryptionEngine(void) { }
	
};


//-- var, const, procedure ---------------------------------------------------

}	/* namespace Uxlsprotect */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE)
using namespace Uxlsprotect;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// UxlsprotectHPP
