{ This file is part of the caLibrary (for Lazarus/FPC) package

  Copyright (C) 1999-2017 - Carl Caulkett - carl.caulkett@gmail.com

  MODIFIED LGPL Licence - this is the same licence as that used by the Free Pascal Compiler (FPC)
  A copy of the full licence can be found in the file Licence.md in the same folder as this file.

  This library is free software; you can redistribute it and/or modify it under the terms of the GNU Library General Public
  License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version
  with the following modification:

  As a special exception, the copyright holders of this library give you permission to link this library with independent
  modules to produce an executable, regardless of the license terms of these independent modules, and to copy and distribute the
  resulting executable under terms of your choice, provided that you also meet, for each linked independent module, the terms
  and conditions of the license of that module. An independent module is a module which is not derived from or based on this
  library. If you modify this library, you may extend this exception to your version of the library, but you are not obligated
  to do so. If you do not wish to do so, delete this exception statement from your version.

  This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Library General Public License for more details.

  You should have received a copy of the GNU Library General Public License along with this library; if not, write to the Free
  Software Foundation, Inc., 51 Franklin Street - Fifth Floor, Boston, MA 02110-1335, USA.
}

unit caDbg;

{$mode objfpc}{$H+}

interface

uses

// FPC units
  Classes, SysUtils, Graphics, cadbgintf, cadbgformunit,

// caLibrary units
  caUtils;

type
  TcaDbgMethod = (dmNone, dmForm, dmServer);

procedure Dbg(const S: string); overload;
procedure Dbg(const AIdent, S: string); overload;
procedure Dbg(const AIdent: string; IntValue: Integer); overload;
procedure Dbg(const AIdent: string; UInt32Value: UInt32); overload;
procedure Dbg(const AIdent: string; Int64Value: Int64); overload;
procedure Dbg(const AIdent: string; UInt64Value: UInt64); overload;
procedure Dbg(const AIdent: string; SingleValue: Single); overload;
procedure Dbg(const AIdent: string; DoubleValue: Double); overload;
procedure Dbg(const AIdent: string; BooleanValue: Boolean); overload;
procedure Dbg(const AIdent: string; DateTimeValue: TDateTime); overload;
procedure Dbg(const AIdent: string; PointerValue: Pointer); overload;
procedure Dbg(Args: array of const); overload;
procedure Dbg(const AFormat: string; Args: array of const); overload;
procedure DbgColor(const AIdent: string; AColor: TColor); overload;
procedure DbgEnter(const S: string);
procedure DbgExit(const S: string);
procedure Dbg_;
procedure DbgClear;
procedure DbgSwap;

procedure DbgMethod(AMethod: TcaDbgMethod);

var DebugMethod: TcaDbgMethod;

procedure SelectDbg(const S: string);

const     DbgSleep = 50;    // Milliseconds

implementation

function ObjectName(const P: TObject): string;
begin
  if P = nil then
    Result:='nil'
  else
    if P is TComponent then
      Result := TComponent(P).Name + ': ' + P.ClassName
    else
      Result := P.ClassName;
end;

function ClassName(const P: TClass): string;
begin
  if P = nil then
    Result := 'nil'
  else
    Result := P.ClassName;
end;

function ArgsToString(Args: array of const): string;
var
  Index: Integer;
begin
  Result := '';
  for Index:=Low(Args) to High(Args) do begin
    case Args[Index].VType of
      vtInteger:    Result := Result + IntToStr(Args[Index].vinteger);
      vtInt64:      Result := Result + IntToStr(Args[Index].VInt64^);
      vtQWord:      Result := Result + IntToStr(Args[Index].VQWord^);
      vtBoolean:    Result := Result + StringUtils.BooleanToString(Args[Index].vboolean);
      vtExtended:   Result := Result + FloatToStr(Args[Index].VExtended^);
  //{$ifdef FPC_CURRENCY_IS_INT64}
  //    // MWE:
  //    // fpc 2.x has troubles in choosing the right dbgs()
  //    // so we convert here
  //    vtCurrency:   Result := Result + Copy(FloatToStr(Int64(Args[Index].vCurrency^)/10000), 4);
  //{$else}
  //    vtCurrency:   Result := Result + dbgs(Args[Index].vCurrency^);
  //{$endif}
      vtString:     Result := Result + Args[Index].VString^;
      vtAnsiString: Result := Result + AnsiString(Args[Index].VAnsiString);
      vtChar:       Result := Result + Args[Index].VChar;
      vtPChar:      Result := Result + Args[Index].VPChar;
      vtPWideChar:  Result := {%H-}Result {%H-}+ Args[Index].VPWideChar;
      vtWideChar:   Result := Result + AnsiString(Args[Index].VWideChar);
      vtWidestring: Result := Result + AnsiString(WideString(Args[Index].VWideString));
      vtObject:     Result := Result + ObjectName(Args[Index].VObject);
      vtClass:      Result := Result + ClassName(Args[Index].VClass);
      vtPointer:    Result := Result + HexStr({%H-}PtrUInt(Args[Index].VPointer), 2 * sizeof(PtrInt));
      else          Result := Result + '?unknown variant?';
    end;
  end;
end;

procedure Dbg(const S: string);
begin
  SelectDbg(S);
  if DebugMethod <> dmNone then Sleep(DbgSleep);
end;

procedure Dbg(const AIdent, S: string);
begin
  SelectDbg(AIdent + ' = ' + S);
  if DebugMethod <> dmNone then Sleep(DbgSleep);
end;

procedure Dbg(const AIdent: string; IntValue: Integer);
begin
  SelectDbg(AIdent + ' = ' + IntToStr(IntValue));
  if DebugMethod <> dmNone then Sleep(DbgSleep);
end;

procedure Dbg(const AIdent: string; UInt32Value: UInt32);
begin
  SelectDbg(AIdent + ' = ' + IntToStr(UInt32Value));
  if DebugMethod <> dmNone then Sleep(DbgSleep);
end;

procedure Dbg(const AIdent: string; Int64Value: Int64);
begin
  SelectDbg(AIdent + ' = ' + IntToStr(Int64Value));
  if DebugMethod <> dmNone then Sleep(DbgSleep);
end;

procedure Dbg(const AIdent: string; UInt64Value: UInt64);
begin
  SelectDbg(AIdent + ' = ' + IntToStr(UInt64Value));
  if DebugMethod <> dmNone then Sleep(DbgSleep);
end;

procedure Dbg(const AIdent: string; SingleValue: Single);
begin
  SelectDbg(AIdent + ' = ' + FloatToStr(SingleValue));
  if DebugMethod <> dmNone then Sleep(DbgSleep);
end;

procedure Dbg(const AIdent: string; DoubleValue: Double);
begin
  SelectDbg(AIdent + ' = ' + FloatToStr(DoubleValue));
  if DebugMethod <> dmNone then Sleep(DbgSleep);
end;

procedure Dbg(const AIdent: string; BooleanValue: Boolean);
const
  Booleans : Array[Boolean] of string = ('False','True');
begin
  SelectDbg(AIdent + ' = ' + Booleans[BooleanValue]);
  if DebugMethod <> dmNone then Sleep(DbgSleep);
end;

procedure Dbg(const AIdent: string; DateTimeValue: TDateTime);
begin
  SelectDbg(AIdent + ' = ' + DateTimeToStr(DateTimeValue));
  if DebugMethod <> dmNone then Sleep(DbgSleep);
end;

procedure Dbg(const AIdent: string; PointerValue: Pointer);
begin
  SelectDbg(AIdent + ' = ' + Format('%p', [PointerValue]));
  if DebugMethod <> dmNone then Sleep(DbgSleep);
end;

procedure Dbg(Args: array of const);
begin
  SelectDbg(ArgsToString(Args));
  if DebugMethod <> dmNone then Sleep(DbgSleep);
end;

procedure Dbg(const AFormat: string; Args: array of const);
begin
  SelectDbg(Format(AFormat, Args));
  if DebugMethod <> dmNone then Sleep(DbgSleep);
end;

procedure DbgColor(const AIdent: string; AColor: TColor);
begin
  SelectDbg(AIdent + ' = ' + ColorUtils.ColorAsString(AColor));
  if DebugMethod <> dmNone then Sleep(DbgSleep);
end;

procedure DbgEnter(const S: string);
begin
  SelectDbg('Entering > ' + S);
  if DebugMethod <> dmNone then Sleep(DbgSleep);
end;

procedure DbgExit(const S: string);
begin
  SelectDbg('Exiting < ' + S);
  if DebugMethod <> dmNone then Sleep(DbgSleep);
end;

procedure Dbg_;
begin
  SelectDbg('-');
  if DebugMethod <> dmNone then Sleep(DbgSleep);
end;

procedure DbgClear;
begin
  SelectDbg('');
  if DebugMethod <> dmNone then Sleep(DbgSleep);
end;

procedure DbgSwap;
begin
  SelectDbg('<^v/>');
end;

procedure DbgMethod(AMethod: TcaDbgMethod);
begin
  DebugMethod := AMethod;
  if AMethod = dmForm then
    begin
      if not Assigned(DbgForm) then
        DbgForm := TcaDbgForm.Create(nil);
    end
  else
    FreeAndNil(DbgForm);
end;

procedure SelectDbg(const S: string);
begin
  if Assigned(DbgForm) then
    begin
      if not DbgForm.Showing then
        DbgForm.Show;
      DbgForm.Add(S);
    end
  else
    begin
      if DebugMethod = dmServer then
        SendDebug(S);
    end;
end;

end.

