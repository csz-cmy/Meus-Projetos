// CodeGear C++Builder
// Copyright (c) 1995, 2010 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'fChooseListParamEditor.pas' rev: 22.00

#ifndef FchooselistparameditorHPP
#define FchooselistparameditorHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member functions
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <Windows.hpp>	// Pascal unit
#include <Messages.hpp>	// Pascal unit
#include <SysUtils.hpp>	// Pascal unit
#include <Classes.hpp>	// Pascal unit
#include <Graphics.hpp>	// Pascal unit
#include <Controls.hpp>	// Pascal unit
#include <Forms.hpp>	// Pascal unit
#include <Dialogs.hpp>	// Pascal unit
#include <Menus.hpp>	// Pascal unit
#include <ComCtrls.hpp>	// Pascal unit
#include <StdCtrls.hpp>	// Pascal unit
#include <Buttons.hpp>	// Pascal unit
#include <ExtCtrls.hpp>	// Pascal unit
#include <fCustomListParamEditor.hpp>	// Pascal unit
#include <fCustomEditor.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Fchooselistparameditor
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TfmChooseListParamEditor;
class PASCALIMPLEMENTATION TfmChooseListParamEditor : public Fcustomlistparameditor::TfmCustomListParamEditor
{
	typedef Fcustomlistparameditor::TfmCustomListParamEditor inherited;
	
__published:
	HIDESBASE void __fastcall btOkClick(System::TObject* Sender);
	
private:
	HIDESBASE void __fastcall Localize(void);
	
protected:
	virtual void __fastcall Loaded(void);
public:
	/* TCustomForm.Create */ inline __fastcall virtual TfmChooseListParamEditor(Classes::TComponent* AOwner) : Fcustomlistparameditor::TfmCustomListParamEditor(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TfmChooseListParamEditor(Classes::TComponent* AOwner, int Dummy) : Fcustomlistparameditor::TfmCustomListParamEditor(AOwner, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TfmChooseListParamEditor(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TfmChooseListParamEditor(HWND ParentWindow) : Fcustomlistparameditor::TfmCustomListParamEditor(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
extern PACKAGE TfmChooseListParamEditor* fmChooseListParamEditor;

}	/* namespace Fchooselistparameditor */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE)
using namespace Fchooselistparameditor;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FchooselistparameditorHPP
