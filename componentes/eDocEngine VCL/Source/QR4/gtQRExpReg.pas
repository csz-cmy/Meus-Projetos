{***************************************************************************}
{                                                                           }
{  Gnostice eDocEngine 		                                                  }
{                                                                           }
{  Copyright � 2002-2008 Gnostice Information Technologies Private Limited  }
{  http://www.gnostice.com                                                  }
{                                                                           }
{***************************************************************************}

{------------------------------------}
{          Editor Options            }
{------------------------------------}
{                                    }
{ Tab Stops = 2                      }
{ Use Tab Character = True           }
{                                    }
{------------------------------------}

unit gtQRExpReg;

interface
uses
  Classes, gtQRXportIntf;

procedure Register;

implementation

procedure Register;
begin
	RegisterComponents('eDocEngine Additional', [TgtQRExportInterface]);
end;
end.

 