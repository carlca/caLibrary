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

unit cajsonconfig;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, JSONConf, LazUtf8, caUtils;

type

  { TcaJsonConfig }

  TcaJsonConfig = class(TJSONConfig)
  private
    FGroup: string;
    FHexDigits: Byte;
    function ExpandPropName(const PropName: string): UnicodeString;
    function GetBoolProp(const PropName: string): Boolean;
    function GetDblProp(const PropName: string): Double;
    function GetHexProp(const PropName: string): UInt32;
    function GetIntProp(const PropName: string): Int64;
    function GetStrProp(const PropName: string): string;
    procedure SetBoolProp(const PropName: string; AValue: Boolean);
    procedure SetGroup(AValue: string);
    procedure SetDblProp(const PropName: string; AValue: Double);
    procedure SetHexProp(const PropName: string; AValue: UInt32);
    procedure SetIntProp(const PropName: string; AValue: Int64);
    procedure SetStrProp(const PropName: string; AValue: string);
  public
    constructor Create(AOwner: TComponent); override;
    property Group: string read FGroup write SetGroup;
    property BoolProp[const PropName: string]: Boolean read GetBoolProp write SetBoolProp;
    property StrProp[const PropName: string]: string read GetStrProp write SetStrProp;
    property IntProp[const PropName: string]: Int64 read GetIntProp write SetIntProp;
    property HexProp[const PropName: string]: UInt32 read GetHexProp write SetHexProp;
    property DblProp[const PropName: string]: Double read GetDblProp write SetDblProp;
    property HexDigits: Byte read FHexDigits write FHexDigits;
  end;

implementation

{ TcaJsonConfig }

constructor TcaJsonConfig.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Formatted := True;
  FGroup := 'default';
  FHexDigits := 8;
end;

procedure TcaJsonConfig.SetGroup(AValue: string);
begin
  if FGroup=AValue then Exit;
  FGroup:=AValue;
end;

function TcaJsonConfig.ExpandPropName(const PropName: string): UnicodeString;
begin
  Result := UTF8ToUTF16(FGroup + '/' + PropName);
end;

function TcaJsonConfig.GetBoolProp(const PropName: string): Boolean;
begin
  Result := GetValue(ExpandPropName(PropName), False);
end;

function TcaJsonConfig.GetDblProp(const PropName: string): Double;
begin
  Result := GetValue(ExpandPropName(PropName), 0);
end;

function TcaJsonConfig.GetHexProp(const PropName: string): UInt32;
begin
  Result := StringUtils.HexToDec(GetStrProp(PropName));
end;

function TcaJsonConfig.GetIntProp(const PropName: string): Int64;
begin
  Result := GetValue(ExpandPropName(PropName), 0);
end;

function TcaJsonConfig.GetStrProp(const PropName: string): string;
begin
  Result := UTF16ToUTF8(GetValue(ExpandPropName(PropName), ''));
end;

procedure TcaJsonConfig.SetBoolProp(const PropName: string; AValue: Boolean);
begin
  SetValue(ExpandPropName(PropName), AValue);
end;

procedure TcaJsonConfig.SetDblProp(const PropName: string; AValue: Double);
begin
  SetValue(ExpandPropName(PropName), AValue);
end;

procedure TcaJsonConfig.SetIntProp(const PropName: string; AValue: Int64);
begin
  SetValue(ExpandPropName(PropName), AValue);
end;

procedure TcaJsonConfig.SetHexProp(const PropName: string; AValue: UInt32);
begin
  SetStrProp(PropName, IntToHex(AValue, FHexDigits));
end;

procedure TcaJsonConfig.SetStrProp(const PropName: string; AValue: string);
begin
  SetValue(ExpandPropName(PropName), Utf8ToUtf16(AValue));
end;

end.

