//---------------------------------------------------------------------------
#ifndef ExSrnmU1H
#define ExSrnmU1H
//---------------------------------------------------------------------------
#include <vcl\Classes.hpp>
#include <vcl\Controls.hpp>
#include <vcl\StdCtrls.hpp>
#include <vcl\Forms.hpp>
#include <vcl\Buttons.hpp>
#include <vcl\IniFiles.hpp>
#include "OnGuard.hpp"

TKey CKey = { 0xE5,0x8F,0x84,0xD6,0x92,0xC9,0xA4,0xD8,
              0x1A,0xFA,0x6F,0x8D,0xAB,0xFC,0xDF,0xB4 };

//---------------------------------------------------------------------------
class TForm1 : public TForm
{
__published:	// IDE-managed Components
	TLabel *Label1;
	TMemo *Memo1;
	TBitBtn *CloseBtn;
	TOgSerialNumberCode *OgSerialNumberCode1;
	void __fastcall OgSerialNumberCode1GetKey(TObject *Sender, TKey &Key);
	void __fastcall OgSerialNumberCode1GetCode(TObject *Sender, TCode &Code);
	void __fastcall OgSerialNumberCode1Checked(TObject *Sender, TCodeStatus Status);
private:	// User declarations
  String TheDir;
	int IniSNVal;
  TIniFile* IniFile;
  TDateTime ED;

  int GetSNData(String& S);
 public:		// User declarations
	__fastcall TForm1(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern TForm1 *Form1;
//---------------------------------------------------------------------------
#endif
