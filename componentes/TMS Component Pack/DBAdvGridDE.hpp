// CodeGear C++Builder
// Copyright (c) 1995, 2009 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'Dbadvgridde.pas' rev: 21.00

#ifndef DbadvgriddeHPP
#define DbadvgriddeHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member functions
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <Sysinit.hpp>	// Pascal unit
#include <Classes.hpp>	// Pascal unit
#include <Controls.hpp>	// Pascal unit
#include <Dbadvgrid.hpp>	// Pascal unit
#include <Db.hpp>	// Pascal unit
#include <Asgde.hpp>	// Pascal unit
#include <Htmlsde.hpp>	// Pascal unit
#include <Designintf.hpp>	// Pascal unit
#include <Designeditors.hpp>	// Pascal unit
#include <Contnrs.hpp>	// Pascal unit
#include <Widestrings.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Dbadvgridde
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TDBSgFieldNameProperty;
class PASCALIMPLEMENTATION TDBSgFieldNameProperty : public Designeditors::TStringProperty
{
	typedef Designeditors::TStringProperty inherited;
	
public:
	virtual Designintf::TPropertyAttributes __fastcall GetAttributes(void);
	virtual void __fastcall GetValues(Classes::TGetStrProc Proc);
public:
	/* TPropertyEditor.Create */ inline __fastcall virtual TDBSgFieldNameProperty(const Designintf::_di_IDesigner ADesigner, int APropCount) : Designeditors::TStringProperty(ADesigner, APropCount) { }
	/* TPropertyEditor.Destroy */ inline __fastcall virtual ~TDBSgFieldNameProperty(void) { }
	
};


class DELPHICLASS TDBAdvGridEditor;
class PASCALIMPLEMENTATION TDBAdvGridEditor : public Asgde::TAdvStringGridEditor
{
	typedef Asgde::TAdvStringGridEditor inherited;
	
protected:
	virtual void __fastcall EditProperty(const Designintf::_di_IProperty PropertyEditor, bool &Continue);
public:
	/* TComponentEditor.Create */ inline __fastcall virtual TDBAdvGridEditor(Classes::TComponent* AComponent, Designintf::_di_IDesigner ADesigner) : Asgde::TAdvStringGridEditor(AComponent, ADesigner) { }
	
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TDBAdvGridEditor(void) { }
	
};


//-- var, const, procedure ---------------------------------------------------
extern PACKAGE void __fastcall Register(void);

}	/* namespace Dbadvgridde */
using namespace Dbadvgridde;
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// DbadvgriddeHPP
