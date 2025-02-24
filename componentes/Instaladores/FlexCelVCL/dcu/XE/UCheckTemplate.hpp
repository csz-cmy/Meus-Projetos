// CodeGear C++Builder
// Copyright (c) 1995, 2010 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'UCheckTemplate.pas' rev: 22.00

#ifndef UchecktemplateHPP
#define UchecktemplateHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member functions
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <SysUtils.hpp>	// Pascal unit
#include <Classes.hpp>	// Pascal unit
#include <Forms.hpp>	// Pascal unit
#include <Dialogs.hpp>	// Pascal unit
#include <StdCtrls.hpp>	// Pascal unit
#include <ActnList.hpp>	// Pascal unit
#include <ImgList.hpp>	// Pascal unit
#include <ComCtrls.hpp>	// Pascal unit
#include <FileCtrl.hpp>	// Pascal unit
#include <ExtCtrls.hpp>	// Pascal unit
#include <Controls.hpp>	// Pascal unit
#include <TemplateStore.hpp>	// Pascal unit
#include <UFlxMessages.hpp>	// Pascal unit
#include <ToolWin.hpp>	// Pascal unit
#include <XLSAdapter.hpp>	// Pascal unit
#include <XlsMessages.hpp>	// Pascal unit
#include <Types.hpp>	// Pascal unit
#include <UExcelAdapter.hpp>	// Pascal unit
#include <UXlsDB.hpp>	// Pascal unit
#include <UCustomFlexCelReport.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Uchecktemplate
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TCheckTemplate;
class PASCALIMPLEMENTATION TCheckTemplate : public Forms::TForm
{
	typedef Forms::TForm inherited;
	
__published:
	Controls::TImageList* ImageList1;
	Controls::TImageList* ImageList2;
	Controls::TImageList* ImageList3;
	Actnlist::TActionList* ActionList1;
	Actnlist::TAction* ActionClose;
	Extctrls::TPanel* Panel1;
	Extctrls::TPanel* FormCaption;
	Comctrls::TToolBar* ToolBar1;
	Comctrls::TToolButton* btnCancel;
	Stdctrls::TMemo* MemoLog;
	void __fastcall ActionCloseExecute(System::TObject* Sender);
	
private:
	void __fastcall Check(const Ucustomflexcelreport::TCustomFlexCelReport* FlxReport, const bool CheckTStore, const System::UnicodeString aFileName);
	void __fastcall AddHeader(const System::UnicodeString aReportName, const System::UnicodeString aFileName);
	void __fastcall DoError(const System::UnicodeString s1, System::TVarRec const *Args, const int Args_Size);
public:
	/* TCustomForm.Create */ inline __fastcall virtual TCheckTemplate(Classes::TComponent* AOwner) : Forms::TForm(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TCheckTemplate(Classes::TComponent* AOwner, int Dummy) : Forms::TForm(AOwner, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TCheckTemplate(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TCheckTemplate(HWND ParentWindow) : Forms::TForm(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
extern PACKAGE void __fastcall InvokeCheckTemplate(const Ucustomflexcelreport::TCustomFlexCelReport* FlxReport, const TCheckTemplate* aCheckTemplate, const bool CheckTStore, const System::UnicodeString FileName, const System::UnicodeString ProjName);

}	/* namespace Uchecktemplate */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE)
using namespace Uchecktemplate;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// UchecktemplateHPP
