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

// TcaStringUtils

// General methods

class function TcaStringUtils.Add(const S: string; const AValue: string): string;
begin
  Result := S + AValue;
end;

class function TcaStringUtils.BuildString(Ch: Char; Count: Integer): string;
begin
  if Count > 0 then
    Result := StringOfChar(Ch, Count)
  else
    Result := '';
end;

class function TcaStringUtils.CellTypeStrToCellType(const ACellTypeStr: string): TcaCellType;
var
  CellType: TcaCellType;
begin
  Result := ctNil;
  for CellType := Low(TcaCellType) to High(TcaCellType) do
    begin
      if GetEnumName(TypeInfo(TcaCellType), Ord(CellType)) = ACellTypeStr then
        begin
          Result := CellType;
          Break;
        end;
    end
end;

class function TcaStringUtils.CleanIntString(const S: string): string;
var
  Index: Integer;
begin
  Result := S;
  for Index := 1 to Length(Result) do
    if not (Result[Index] in ['0'..'9', '-', '+']) then
      Result[Index] := #32;
  Result := StripChar(Result, #32);
  if Result = '' then Result := '0';
end;

class function TcaStringUtils.CleanNumString(const S: string): string;
var
  Index: Integer;
begin
  Result := S;
  for Index := 1 to Length(Result) do
    if not (Result[Index] in ['0'..'9', '-', '+', 'e', 'E', DefaultFormatSettings.DecimalSeparator]) then
      Result[Index] := #32;
  Result := StripChar(Result, #32);
  if Result = '' then Result := '0';
end;

class function TcaStringUtils.DeleteFromEnd(const S: string; N: Integer): string;
begin
  Result := Left(S, Length(S) - N);
end;

class function TcaStringUtils.DeleteFromStart(const S: string; N: Integer): string;
begin
  Result := Right(S, Length(S) - N);
end;

class function TcaStringUtils.DeleteUntilChar(const S: string; Ch: Char; IncludeChar: Boolean): string;
var
  P: Integer;
begin
  Result := S;
  P := System.Pos(Ch, S);
  if P > 0 then
    begin
      if not IncludeChar then Dec(P);
      if P > 0 then Result := DeleteFromStart(S, P);
    end;
end;

class function TcaStringUtils.EndsWith(const S: string; const AValue: string): Boolean;
var
  RightSub: string;
begin
  Result := False;
  if System.Length(AValue) <= System.Length(S) then
    begin
      RightSub := Right(S, System.Length(AValue));
      Result := AnsiSameStr(AValue, RightSub);
    end;
end;

class function TcaStringUtils.HexToDec(AHex: string): Integer;
var
  I, M: Integer;
begin
  Result := 0;
  M := 1;
  AHex := AnsiUpperCase(AHex);
  for I := Length(AHex) downto 1 do
  begin
    case AHex[I] of
      '1'..'9': Result := Result + (Ord(AHex[I]) - Ord('0')) * M;
      'A'..'F': Result := Result + (Ord(AHex[I]) - Ord('A') + 10) * M;
    end;
    M := M shl 4;
  end;
end;

class function TcaStringUtils.Indent(const S: string; N: Integer): string;
begin
  Result := BuildString(#32, N) + S;
end;

class function TcaStringUtils.IsIntChar(const S: string; N: Integer): Boolean;
var
  Ch: Char;
begin
  Result := False;
  if N in [1..System.Length(S)] then
    begin
      Ch := S[N];
      Result := Ch in ['+', '-', '0'..'9'];
    end;
end;

class function TcaStringUtils.IsFloatChar(const S: string; N: Integer): Boolean;
var
  Ch: Char;
begin
  Result := False;
  if N in [1..System.Length(S)] then
    begin
      Ch := S[N];
      Result := Ch in [DefaultFormatSettings.DecimalSeparator, '+', '-', '0'..'9', 'E', 'e'];
    end;
end;

class function TcaStringUtils.Left(const S: string; N: Integer): String;
begin
  Result := SysUtils.LeftStr(S, N);
end;

class function TcaStringUtils.Length(const S: string): Integer;
begin
  Result := System.Length(S);
end;

class function TcaStringUtils.LowerCase(const S: string): string;
begin
  Result := SysUtils.LowerCase(S);
end;

class function TcaStringUtils.Mid(const S: string; N, ForN: Integer): String;
begin
  Result := Copy(S, N, ForN);
end;

class function TcaStringUtils.PadLeft(const S: string; Ch: Char; ALength: Integer): String;
var
  N: Integer;
begin
  N := Length(S);
  if N < ALength then
    Result := BuildString(Ch, ALength - N) + S
  else
    Result := S;
end;

class function TcaStringUtils.PadRight(const S: string; Ch: Char; ALength: Integer): String;
var
  N: Integer;
begin
  N := Length(S);
  if N < ALength then
    Result := S + BuildString(Ch, ALength - N)
  else
    Result := S;
end;

class function TcaStringUtils.PosFromEnd(const S: string; const AFindStr: String): Integer;
var
  Index: Integer;
  S2: string;
  SubPos: Integer;
begin
  Result := 0;
  for Index := Length(S) downto 1 do
    begin
      S2 := S;
      Delete(S2, 1, Index);
      SubPos := Pos(AFindStr, S2);
      if SubPos > 0 then
        begin
          Result := Index + 1;
          Break;
        end;
    end;
end;

class function TcaStringUtils.PosFromStart(const S: string; const AFindStr: String): Integer;
begin
  Result := Pos(AFindStr, S);
end;

class function TcaStringUtils.PreZero(const S: string; ALength: Integer): String;
begin
  Result := StringUtils.PadLeft(S, '0', ALength);
end;

class function TcaStringUtils.Replace(const S: string; const AOld, ANew: string): string;
begin
  Result := StringReplace(S, AOld, ANew, [rfReplaceAll]);
end;

class function TcaStringUtils.Reverse(const S: string): String;
var
  Index: Integer;
  Len: Integer;
begin
  Len := Length(S);
  SetLength(Result, Len);
  for Index := Len downto 1 do
    Result[Len - Index + 1] := S[Index];
end;

class function TcaStringUtils.Right(const S: string; N: Integer): string;
begin
  Result := Copy(S, Length(S) - N + 1, N);
end;

class function TcaStringUtils.Slice(const S: string; StartPos, EndPos: Integer): string;
begin
  Result := Copy(S, StartPos, EndPos - StartPos + 1);
end;

class function TcaStringUtils.SplitCamelCaps(const S: string): string;
var
  C: Char;
  Index: Integer;
begin
  Result := '';
  for Index := 1 to Length(S) do
    begin
      C := S[Index];
      if C in ['A'..'Z', '0'..'9'] then
        Result := Result + ' ';
      Result := Result + C;
    end;
  Result := TrimLeft(Result);
end;

class function TcaStringUtils.StartsWith(const S: string; const AValue: string): Boolean;
var
  LeftSub: string;
begin
  Result := False;
  if System.Length(AValue) <= System.Length(S) then
    begin
      LeftSub := Left(S, System.Length(AValue));
      Result := AnsiSameStr(AValue, LeftSub);
    end;
end;

class function TcaStringUtils.StripChar(const S: string; C: Char): string;
begin
  Result := S;
  while Pos(C, Result) > 0 do
    System.Delete(Result, Pos(C, Result), 1);
end;

class function TcaStringUtils.Str2Float(const S: string; Default: Extended): Extended;
begin
  if not TextToFloat(PChar(CleanNumString(S) + #0), Result, fvExtended) then
    Result := Default;
end;

class function TcaStringUtils.Str2Int(const S: string; Default: Integer): Integer;
begin
  Result := StrToIntDef(CleanIntString(S), Default);
end;

class function TcaStringUtils.UpperCase(const S: string): string;
begin
  Result := SysUtils.UpperCase(S);
end;

// ToString methods

class function TcaStringUtils.BooleanToString(ABoolean: Boolean): string;
begin
  if ABoolean then Result := 'True' else Result := 'False';
end;

class function TcaStringUtils.DateTimeToString(ADateTime: TDateTime; const ADateFormat: string): string;
begin
  if ADateFormat <> '' then
  begin
    if ADateFormat = ' ' then
      Result := ''
    else
      Result := FormatDateTime(ADateFormat, ADateTime)
  end
  else
    Result := FormatDateTime('c', ADateTime);
end;

class function TcaStringUtils.DoubleToString(ADouble: Double; const AFloatFormat: string): string;
begin
  if AFloatFormat <> '' then
    begin
      if AFloatFormat = ' ' then
        Result := ''
      else
        Result := FormatFloat(AFloatFormat, ADouble);
    end
  else
    Result := FloatToStr(ADouble);
end;

class function TcaStringUtils.Int64ToString(AInt64: Int64; const AIntegerFormat: string): string;
begin
  if AIntegerFormat <> '' then
    Result := FormatFloat(AIntegerFormat, AInt64)
  else
    Result := IntToStr(AInt64);
end;

class function TcaStringUtils.IntegerToString(AInteger: Integer; const AIntegerFormat: string): string;
begin
  if AIntegerFormat <> '' then
    Result := FormatFloat(AIntegerFormat, AInteger)
  else
    Result := IntToStr(AInteger);
end;

class function TcaStringUtils.MemoToString(AMemo: TStrings): string;
begin
  Result := AMemo.Text;
end;

class function TcaStringUtils.ObjectToString(AObject: TObject): string;
var
  AName: string;
  AHexValue: string;
begin
  AName := AObject.ClassName;
  AHexValue := Utils.PtrToString(@AObject);
  Result := AName + ': ' + AHexValue;
end;

class function TcaStringUtils.SingleToString(ASingle: Single; const AFloatFormat: string): string;
begin
  if AFloatFormat <> '' then
    Result := FormatFloat(AFloatFormat, ASingle)
  else
    Result := FloatToStr(ASingle);
end;

class function TcaStringUtils.UInt32ToString(AUInt32: UInt32; const AIntegerFormat: string): string;
begin
  if AIntegerFormat <> '' then
    Result := FormatFloat(AIntegerFormat, AUInt32)
  else
    Result := IntToStr(AUInt32);
end;

class function TcaStringUtils.UInt64ToString(AUInt64: UInt64; const AIntegerFormat: string): string;
begin
  if AIntegerFormat <> '' then
    Result := FormatFloat(AIntegerFormat, AUInt64)
  else
    Result := IntToStr(AUInt64);
end;

// StringTo methods

class function TcaStringUtils.StringToBoolean(const ABooleanStr: string): Boolean;
begin
  Result := (Length(ABooleanStr) > 0) and (ABooleanStr[1] in ['T', 't', 'Y', 'y']);
end;

class function TcaStringUtils.StringToDateTime(const ADateTimeStr: string): TDateTime;
begin
  Result := SysUtils.StrToDate(ADateTimeStr);
end;

class function TcaStringUtils.StringToDouble(const ADoubleStr: string): Double;
begin
  Result := Str2Float(ADoubleStr, 0);
end;

class function TcaStringUtils.StringToInteger(const AIntegerStr: string): Integer;
begin
  Result := Str2Int(AIntegerStr, 0);
end;

class function TcaStringUtils.StringToInt64(const AInt64Str: string): Int64;
begin
  Result := Str2Int(AInt64Str, 0);
end;

class function TcaStringUtils.StringToSingle(const ASingleStr: string): Single;
begin
  Result := Str2Float(ASingleStr, 0);
end;

class function TcaStringUtils.StringToUInt32(const AUInt32Str: string): UInt32;
begin
  Result := StrToInt64(AUInt32Str);
end;

class function TcaStringUtils.StringToUInt64(const AUInt64Str: string): UInt64;
begin
  Result := StrToQWord(AUInt64Str);
end;

class procedure TcaStringUtils.StringToMemo(const AMemoStr: string; AMemo: TStrings);
begin
  AMemo.Text := AMemoStr;
end;


