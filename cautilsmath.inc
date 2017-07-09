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

// TcaMathUtils

// Max/Min support

class function TcaMathUtils.InRangeDouble(AValue: Double): Boolean;
begin
  Result := (AValue >= MinDouble) and (AValue <= MaxDouble);
end;

class function TcaMathUtils.InRangeExtended(AValue: Extended): Boolean;
begin
  { TODO : Need to work out how to enable Extended floats - use FPDOC_MATH? }
  Result := (AValue >= MinDouble) and (AValue <= MaxDouble);
end;

class function TcaMathUtils.InRangeInt32(AValue: Int32): Boolean;
begin
  Result := AValue in [MinInt32..MaxInt32];
end;

class function TcaMathUtils.InRangeInt64(AValue: Int64): Boolean;
begin
  Result := (AValue >= MinInt64) and (AValue <= MaxInt64);
end;

class function TcaMathUtils.InRangeSingle(AValue: Single): Boolean;
begin
  Result := (AValue >= MinSingle) and (AValue <= MaxSingle);
end;

class function TcaMathUtils.InRangeUInt32(AValue: UInt32): Boolean;
begin
  Result := AValue in [0..MaxUInt32];
end;

class function TcaMathUtils.InRangeUInt64(AValue: UInt32): Boolean;
begin
  Result := AValue in [0..MaxUInt64];
end;

class function TcaMathUtils.IsEven(AValue: Int64): Boolean;
begin
  Result := (AValue and 1) = 0;
end;

class function TcaMathUtils.IsEven(AValue: UInt64): Boolean;
begin
  Result := (AValue and 1) = 0;
end;

class function TcaMathUtils.IsOdd(AValue: Int64): Boolean;
begin
  Result := (AValue and 1) = 1;
end;

class function TcaMathUtils.IsOdd(AValue: UInt64): Boolean;
begin
  Result := (AValue and 1) = 1;
end;

class function TcaMathUtils.MaxInt32: Int32;
begin
  Result := $7FFFFFFF;
end;

class function TcaMathUtils.MaxInt64: Int64;
begin
  Result := $7FFFFFFFFFFFFFFF;
end;

class function TcaMathUtils.MaxUInt32: UInt32;
begin
  Result := $FFFFFFFF;
end;

class function TcaMathUtils.MaxUInt64: UInt64;
begin
  Result := {%H-}$FFFFFFFFFFFFFFFF;
end;

class function TcaMathUtils.MinInt32: Int32;
begin
  Result := -MaxInt - 1;
end;

class function TcaMathUtils.MinInt64: Int64;
begin
  Result := -MaxInt64 - 1;
end;

// Rounding support

{ TODO : Need to extend the following to take account of Precision and Bankers' rounding etc. }

class function TcaMathUtils.RoundToInt32(AValue: Extended): Int32;
begin
  if AValue > MaxInt32 + 0.5 then
    raise EcaMathUtilsException.Create('Value is greater than MaxInt32 limit');
  if AValue < MinInt32 - 0.5 then
    raise EcaMathUtilsException.Create('Value is less than MinInt32 limit');
  Result := Trunc(AValue);
  if Frac(AValue) > 0.5 then
    Result := Result + 1;
end;

class function TcaMathUtils.RoundToInt64(AValue: Extended): Int64;
begin
  if AValue > MaxInt64 + 0.5 then
    raise EcaMathUtilsException.Create('Value is greater than MaxInt64 limit');
  if AValue < MinInt64 - 0.5 then
    raise EcaMathUtilsException.Create('Value is less than MinInt64 limit');
  Result := Trunc(AValue);
  if Frac(AValue) > 0.5 then
    Result := Result + 1;
end;


