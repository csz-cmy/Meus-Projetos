// CodeGear C++Builder
// Copyright (c) 1995, 2007 by CodeGear
// All rights reserved

// (DO NOT EDIT: machine generated header) 'Uxlschart.pas' rev: 11.00

#ifndef UxlschartHPP
#define UxlschartHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member functions
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <Sysinit.hpp>	// Pascal unit
#include <Uxlsbaserecords.hpp>	// Pascal unit
#include <Uxlsbaserecordlists.hpp>	// Pascal unit
#include <Uxlsotherrecords.hpp>	// Pascal unit
#include <Xlsmessages.hpp>	// Pascal unit
#include <Uxlstokenarray.hpp>	// Pascal unit
#include <Classes.hpp>	// Pascal unit
#include <Sysutils.hpp>	// Pascal unit
#include <Uxlsbaselist.hpp>	// Pascal unit
#include <Contnrs.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Uxlschart
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TChartRecord;
class PASCALIMPLEMENTATION TChartRecord : public Uxlsbaserecords::TBaseRecord 
{
	typedef Uxlsbaserecords::TBaseRecord inherited;
	
public:
	#pragma option push -w-inl
	/* TBaseRecord.Create */ inline __fastcall virtual TChartRecord(const Word aId, const Xlsmessages::PArrayOfByte aData, const int aDataSize) : Uxlsbaserecords::TBaseRecord(aId, aData, aDataSize) { }
	#pragma option pop
	#pragma option push -w-inl
	/* TBaseRecord.Destroy */ inline __fastcall virtual ~TChartRecord(void) { }
	#pragma option pop
	
};


class DELPHICLASS TBeginRecord;
class PASCALIMPLEMENTATION TBeginRecord : public TChartRecord 
{
	typedef TChartRecord inherited;
	
public:
	#pragma option push -w-inl
	/* TBaseRecord.Create */ inline __fastcall virtual TBeginRecord(const Word aId, const Xlsmessages::PArrayOfByte aData, const int aDataSize) : TChartRecord(aId, aData, aDataSize) { }
	#pragma option pop
	#pragma option push -w-inl
	/* TBaseRecord.Destroy */ inline __fastcall virtual ~TBeginRecord(void) { }
	#pragma option pop
	
};


class DELPHICLASS TEndRecord;
class PASCALIMPLEMENTATION TEndRecord : public TChartRecord 
{
	typedef TChartRecord inherited;
	
public:
	#pragma option push -w-inl
	/* TBaseRecord.Create */ inline __fastcall virtual TEndRecord(const Word aId, const Xlsmessages::PArrayOfByte aData, const int aDataSize) : TChartRecord(aId, aData, aDataSize) { }
	#pragma option pop
	#pragma option push -w-inl
	/* TBaseRecord.Destroy */ inline __fastcall virtual ~TEndRecord(void) { }
	#pragma option pop
	
};


class DELPHICLASS TChartAIRecord;
class PASCALIMPLEMENTATION TChartAIRecord : public TChartRecord 
{
	typedef TChartRecord inherited;
	
private:
	Word Flags;
	Word FLen;
	void __fastcall ArrangeTokensInsertRowsAndCols(const int InsRowPos, const int InsRowOffset, const int CopyRowOffset, const int InsColPos, const int InsColOffset, const int CopyColOffset, const Xlsmessages::TSheetInfo &SheetInfo);
	
public:
	__fastcall virtual TChartAIRecord(const Word aId, const Xlsmessages::PArrayOfByte aData, const int aDataSize);
	void __fastcall ArrangeInsertRowsAndCols(const int aRowPos, const int aRowCount, const int aColPos, const int aColCount, const Xlsmessages::TSheetInfo &SheetInfo);
	void __fastcall ArrangeCopySheet(const Xlsmessages::TSheetInfo &SheetInfo);
	void __fastcall ArrangeCopyRowsAndCols(const int RowOffset, const int ColOffset);
public:
	#pragma option push -w-inl
	/* TBaseRecord.Destroy */ inline __fastcall virtual ~TChartAIRecord(void) { }
	#pragma option pop
	
};


class DELPHICLASS TChartAIRecordCache;
class PASCALIMPLEMENTATION TChartAIRecordCache : public Uxlsbaselist::TBaseList 
{
	typedef Uxlsbaselist::TBaseList inherited;
	
public:
	TChartAIRecord* operator[](int index) { return Items[index]; }
	
private:
	TChartAIRecord* __fastcall GetItems(int index);
	void __fastcall SetItems(int index, const TChartAIRecord* Value);
	
public:
	__property TChartAIRecord* Items[int index] = {read=GetItems, write=SetItems/*, default*/};
	HIDESBASE int __fastcall Add(TChartAIRecord* aRecord);
	HIDESBASE void __fastcall Insert(int Index, TChartAIRecord* aRecord);
	__fastcall TChartAIRecordCache(void);
	void __fastcall ArrangeCopyRowsAndCols(const int RowOffset, const int ColOffset);
	void __fastcall ArrangeInsertRowsAndCols(const int aRowPos, const int aRowCount, const int aColPos, const int aColCount, const Xlsmessages::TSheetInfo &SheetInfo);
	void __fastcall ArrangeCopySheet(const Xlsmessages::TSheetInfo &SheetInfo);
public:
	#pragma option push -w-inl
	/* TList.Destroy */ inline __fastcall virtual ~TChartAIRecordCache(void) { }
	#pragma option pop
	
};


class DELPHICLASS TChartRecordList;
class PASCALIMPLEMENTATION TChartRecordList : public Uxlsbaserecordlists::TBaseRecordList 
{
	typedef Uxlsbaserecordlists::TBaseRecordList inherited;
	
private:
	TChartAIRecordCache* AICache;
	
protected:
	virtual void __fastcall Notify(void * Ptr, Classes::TListNotification Action);
	
public:
	__fastcall TChartRecordList(void);
	__fastcall virtual ~TChartRecordList(void);
	void __fastcall ArrangeCopyRowsAndCols(const int RowOffset, const int ColOffset);
	void __fastcall ArrangeInsertRowsAndCols(const int aRowPos, const int aRowCount, const int aColPos, const int aColCount, const Xlsmessages::TSheetInfo &SheetInfo);
	void __fastcall ArrangeCopySheet(const Xlsmessages::TSheetInfo &SheetInfo);
};


//-- var, const, procedure ---------------------------------------------------

}	/* namespace Uxlschart */
using namespace Uxlschart;
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Uxlschart
