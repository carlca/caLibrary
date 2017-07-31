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

unit caUtils;

{$mode objfpc}{$H+}

interface

uses

// FPC units
  Classes, SysUtils, Math, TypInfo, Graphics, LCLType,

// caLibrary units
  caTypes, caConsts, caRtti;

type

// TcaUtils

  TcaUtils = class
  public
    // Application path methods - works with EXEs and DLLs 
    class function AppName: string;
    class function AppPath: string;
    class function AppPathAndName: string;
    // Pointer methods
    class function PtrToString(APointer: Pointer): string;
    class function PtrToUInt(APointer: Pointer): PtrUInt;
    class function UIntToPtr(AUInt: PtrUInt): Pointer;
    // GUID support
    class function GetGUIDAsString: string;
    // Comparison methods
    class function CompareBooleans(const Item1, Item2: Boolean): TcaCompareResult;
    class function CompareDateTimes(const Item1, Item2: TDateTime): TcaCompareResult;
    class function CompareDoubles(const Item1, Item2: Double): TcaCompareResult;
    class function CompareIntegers(const Item1, Item2: Integer): TcaCompareResult;
    class function CompareInt64s(const Item1, Item2: Int64): TcaCompareResult;
    class function CompareMemos(const Item1, Item2: TStrings; ACaseInsensitive: Boolean = False): TcaCompareResult;
    class function CompareObjects(const Item1, Item2: TObject): TcaCompareResult;
    class function CompareSingles(const Item1, Item2: Single): TcaCompareResult;
    class function CompareStrings(const Item1, Item2: string; ACaseInsensitive: Boolean = False): TcaCompareResult;
    class function CompareUInt32s(const Item1, Item2: UInt32): TcaCompareResult;
    class function CompareUInt64s(const Item1, Item2: UInt64): TcaCompareResult;
    // Rtti methods
    class function TypeKindToStr(const ATypeKind: TTypeKind): string;
    class procedure DumpRttiInfo(const AInstance: TObject; AStrings: TStrings; ADelim: string = cComma); overload;
    class procedure DumpRttiInfo(const AClass: TClass; AStrings: TStrings; ADelim: string = cComma); overload;
  end;

// TcaFileUtils

  TcaFileUtils = class
  public
    // General methods
    class function CreateAltFileName(const FileName, Suffix: string): string;
  end;

// TcaStringUtils

  TcaStringUtils = class
  public
    // General methods
    class function Add(const S: string; const AValue: string): string;
    class function BuildString(Ch: Char; Count: Integer): string;
    class function CellTypeStrToCellType(const ACellTypeStr: string): TcaCellType;
    class function CleanIntString(const S: string): string;
    class function CleanNumString(const S: string): string;
    class function DeleteFromEnd(const S: string; N: Integer): string;
    class function DeleteFromStart(const S: string; N: Integer): string;
    class function DeleteUntilChar(const S: string; Ch: Char; IncludeChar: Boolean): string;
    class function EndsWith(const S: string; const AValue: string): Boolean;
    class function HexToDec(AHex: string): Integer;
    class function Indent(const S: string; N: Integer): string;
    class function IsIntChar(const S: string; N: Integer): Boolean;
    class function IsFloatChar(const S: string; N: Integer): Boolean;
    class function Left(const S: string; N: Integer): String;
    class function Length(const S: string): Integer;
    class function LowerCase(const S: string): string;
    class function Mid(const S: string; N, ForN: Integer): String;
    class function PadLeft(const S: string; Ch: Char; ALength: Integer): String;
    class function PadRight(const S: string; Ch: Char; ALength: Integer): String;
    class function PosFromEnd(const S: string; const AFindStr: String): Integer;
    class function PosFromStart(const S: string; const AFindStr: String): Integer;
    class function PreZero(const S: string; ALength: Integer): String;
    class function Replace(const S: string; const AOld, ANew: string): string;
    class function Reverse(const S: string): String;
    class function Right(const S: string; N: Integer): string;
    class function Slice(const S: string; StartPos, EndPos: Integer): string;
    class function SplitCamelCaps(const S: string): string;
    class function StartsWith(const S: string; const AValue: string): Boolean;
    class function StripChar(const S: string; C: Char): string;
    class function Str2Float(const S: string; Default: Extended): Extended;
    class function Str2Int(const S: string; Default: Integer): Integer;
    class function UpperCase(const S: string): string;
    // ToString methods
    class function BooleanToString(ABoolean: Boolean): string;
    class function DateTimeToString(ADateTime: TDateTime; const ADateFormat: string): string;
    class function DoubleToString(ADouble: Double; const AFloatFormat: string): string;
    class function Int64ToString(AInt64: Int64; const AIntegerFormat: string): string;
    class function IntegerToString(AInteger: Integer; const AIntegerFormat: string): string;
    class function MemoToString(AMemo: TStrings): string;
    class function ObjectToString(AObject: TObject): string;
    class function SingleToString(ASingle: Single; const AFloatFormat: string): string;
    class function UInt32ToString(AUInt32: UInt32; const AIntegerFormat: string): string;
    class function UInt64ToString(AUInt64: UInt64; const AIntegerFormat: string): string;
    // StringTo methods
    class function StringToBoolean(const ABooleanStr: string): Boolean;
    class function StringToDateTime(const ADateTimeStr: string): TDateTime;
    class function StringToDouble(const ADoubleStr: string): Double;
    class function StringToInteger(const AIntegerStr: string): Integer;
    class function StringToInt64(const AInt64Str: string): Int64;
    class procedure StringToMemo(const AMemoStr: string; AMemo: TStrings);
    class function StringToSingle(const ASingleStr: string): Single;
    class function StringToUInt32(const AUInt32Str: string): UInt32;
    class function StringToUInt64(const AUInt64Str: string): UInt64;
  end;

// TcaMathUtils

  TcaMathUtils = class
  public
    // Max/Min support
    class function InRangeDouble(AValue: Double): Boolean;
    class function InRangeExtended(AValue: Extended): Boolean;
    class function InRangeInt32(AValue: Int32): Boolean;
    class function InRangeInt64(AValue: Int64): Boolean;
    class function InRangeSingle(AValue: Single): Boolean;
    class function InRangeUInt32(AValue: UInt32): Boolean;
    class function InRangeUInt64(AValue: UInt32): Boolean;
    class function IsEven(AValue: Int64): Boolean;
    class function IsEven(AValue: UInt64): Boolean;
    class function IsOdd(AValue: Int64): Boolean;
    class function IsOdd(AValue: UInt64): Boolean;
    class function MaxInt32: Int32;
    class function MaxInt64: Int64;
    class function MaxUInt32: UInt32;
    class function MaxUInt64: UInt64;
    class function MinInt32: Int32;
    class function MinInt64: Int64;
    // Rounding support
    class function RoundToInt32(AValue: Extended): Int32;
    class function RoundToInt64(AValue: Extended): Int64;
  end;

  { TcaColorUtils }

  TcaColorUtils = class
  public
    // Value to ident
    class function ColorAsString(AColor: TColor): string;
  end;

  Utils = class(TcaUtils);

  FileUtils = class(TcaFileUtils);

  StringUtils = class(TcaStringUtils);

  MathUtils = class(TcaMathUtils);

  ColorUtils = class(TcaColorUtils);

  // Exception classes

  EcaUtilsException = class(Exception);

  EcaStringUtilsException = class(Exception);

  EcaMathUtilsException = class(Exception);

// Non-class procedures

procedure Pass;   // Inspired by Guido van Rossum!

implementation

procedure Pass;
begin
end;

// TcaUtils

{$include caUtils.inc}
{$include caUtilsFile.inc}
{$include caUtilsString.inc}
{$include caUtilsMath.inc}
{$include caUtilsColor.inc}

end.

