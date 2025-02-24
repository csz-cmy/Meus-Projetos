// CodeGear C++Builder
// Copyright (c) 1995, 2009 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'Gttxtengdlg.pas' rev: 21.00

#ifndef GttxtengdlgHPP
#define GttxtengdlgHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member functions
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <Sysinit.hpp>	// Pascal unit
#include <Windows.hpp>	// Pascal unit
#include <Messages.hpp>	// Pascal unit
#include <Sysutils.hpp>	// Pascal unit
#include <Classes.hpp>	// Pascal unit
#include <Graphics.hpp>	// Pascal unit
#include <Controls.hpp>	// Pascal unit
#include <Forms.hpp>	// Pascal unit
#include <Dialogs.hpp>	// Pascal unit
#include <Extdlgs.hpp>	// Pascal unit
#include <Extctrls.hpp>	// Pascal unit
#include <Stdctrls.hpp>	// Pascal unit
#include <Comctrls.hpp>	// Pascal unit
#include <Buttons.hpp>	// Pascal unit
#include <Gtdocdlg.hpp>	// Pascal unit
#include <Gtdocresstrs.hpp>	// Pascal unit
#include <Gtutils.hpp>	// Pascal unit
#include <Gttxteng.hpp>	// Pascal unit
#include <Gtcstdoceng.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Gttxtengdlg
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TgtTextEngineDlg;
class PASCALIMPLEMENTATION TgtTextEngineDlg : public Gtdocdlg::TgtDocumentDlg
{
	typedef Gtdocdlg::TgtDocumentDlg inherited;
	
__published:
	Comctrls::TTabSheet* tsTextFormatting;
	Stdctrls::TGroupBox* gbFormatting;
	Stdctrls::TLabel* lblTextLineSpacing;
	Stdctrls::TComboBox* cbLineSpacing;
	Stdctrls::TLabel* lblTextColumnSpacing;
	Stdctrls::TEdit* edColumnSpacing;
	Stdctrls::TGroupBox* gbSeparatorMode;
	Stdctrls::TCheckBox* chkUseSeparator;
	Stdctrls::TLabel* lblSeparator;
	Stdctrls::TEdit* edSeparator;
	Stdctrls::TLabel* lblTextDefaultFont;
	Extctrls::TPanel* pnlDefaultFont;
	Buttons::TSpeedButton* sbtnSetDefaultFont;
	Stdctrls::TCheckBox* chkTextPageEndLines;
	Stdctrls::TCheckBox* chkInsertPageBreaks;
	Stdctrls::TCheckBox* chkTextSingleFile;
	Dialogs::TFontDialog* FontDialog;
	HIDESBASE void __fastcall FormCreate(System::TObject* Sender);
	void __fastcall chkUseSeparatorClick(System::TObject* Sender);
	HIDESBASE void __fastcall FormShow(System::TObject* Sender);
	void __fastcall sbtnSetDefaultFontClick(System::TObject* Sender);
	HIDESBASE void __fastcall btnOKClick(System::TObject* Sender);
	
protected:
	virtual void __fastcall Localize(void);
public:
	/* TgtBaseDlg.Create */ inline __fastcall virtual TgtTextEngineDlg(Classes::TComponent* AOwner) : Gtdocdlg::TgtDocumentDlg(AOwner) { }
	
public:
	/* TCustomForm.CreateNew */ inline __fastcall virtual TgtTextEngineDlg(Classes::TComponent* AOwner, int Dummy) : Gtdocdlg::TgtDocumentDlg(AOwner, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TgtTextEngineDlg(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TgtTextEngineDlg(HWND ParentWindow) : Gtdocdlg::TgtDocumentDlg(ParentWindow) { }
	
};


typedef StaticArray<System::UnicodeString, 6> Gttxtengdlg__2;

//-- var, const, procedure ---------------------------------------------------
extern PACKAGE Gttxtengdlg__2 TextLineSpacing;

}	/* namespace Gttxtengdlg */
using namespace Gttxtengdlg;
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// GttxtengdlgHPP
