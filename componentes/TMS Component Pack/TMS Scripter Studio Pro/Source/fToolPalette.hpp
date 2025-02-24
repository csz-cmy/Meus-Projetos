// CodeGear C++Builder
// Copyright (c) 1995, 2010 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'fToolPalette.pas' rev: 22.00

#ifndef FtoolpaletteHPP
#define FtoolpaletteHPP

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
#include <Variants.hpp>	// Pascal unit
#include <Classes.hpp>	// Pascal unit
#include <Graphics.hpp>	// Pascal unit
#include <Controls.hpp>	// Pascal unit
#include <Forms.hpp>	// Pascal unit
#include <Dialogs.hpp>	// Pascal unit
#include <ExtCtrls.hpp>	// Pascal unit
#include <CategoryButtons.hpp>	// Pascal unit
#include <IDEMain.hpp>	// Pascal unit
#include <ActnList.hpp>	// Pascal unit
#include <ComCtrls.hpp>	// Pascal unit
#include <ToolWin.hpp>	// Pascal unit
#include <ImgList.hpp>	// Pascal unit
#include <Menus.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Ftoolpalette
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TfmToolPalette;
class PASCALIMPLEMENTATION TfmToolPalette : public Forms::TForm
{
	typedef Forms::TForm inherited;
	
__published:
	Idemain::TIDEPaletteButtons* FPaletteButtons;
	Menus::TPopupMenu* PopupMenu1;
	Controls::TImageList* ImageList1;
	Comctrls::TToolBar* ToolBar1;
	Comctrls::TToolButton* ToolButton1;
	Comctrls::TToolButton* ToolButton2;
	Comctrls::TToolButton* ToolButton3;
	Actnlist::TActionList* ActionList1;
	Actnlist::TAction* acCancelPlacing;
	Comctrls::TToolButton* ToolButton4;
	Actnlist::TAction* acFilter;
	void __fastcall acCancelPlacingExecute(System::TObject* Sender);
	void __fastcall acCancelPlacingUpdate(System::TObject* Sender);
	void __fastcall ToolButton1Click(System::TObject* Sender);
	void __fastcall acFilterExecute(System::TObject* Sender);
	void __fastcall acFilterUpdate(System::TObject* Sender);
	void __fastcall FormKeyDown(System::TObject* Sender, System::Word &Key, Classes::TShiftState Shift);
	void __fastcall ToolBar1Click(System::TObject* Sender);
	void __fastcall FormCreate(System::TObject* Sender);
	
private:
	void __fastcall SetEngine(const Idemain::TIDEEngine* Value);
	Idemain::TIDEEngine* __fastcall GetEngine(void);
	void __fastcall MenuItemClick(System::TObject* Sender);
	
public:
	__property Idemain::TIDEEngine* Engine = {read=GetEngine, write=SetEngine};
public:
	/* TCustomForm.Create */ inline __fastcall virtual TfmToolPalette(Classes::TComponent* AOwner) : Forms::TForm(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TfmToolPalette(Classes::TComponent* AOwner, int Dummy) : Forms::TForm(AOwner, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TfmToolPalette(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TfmToolPalette(HWND ParentWindow) : Forms::TForm(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
extern PACKAGE TfmToolPalette* fmToolPalette;

}	/* namespace Ftoolpalette */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE)
using namespace Ftoolpalette;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// FtoolpaletteHPP
