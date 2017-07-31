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

// TcaUtils

// Application path methods - works with EXEs and DLLs 

class function TcaUtils.AppName: string;
begin
  Result := ExtractFileName(AppPathAndName);
end;

class function TcaUtils.AppPath: string;
begin
  Result := ExtractFilePath(AppPathAndName);
  if Result[Length(Result)] <> '\' then Result := Result + '\';
end;

class function TcaUtils.AppPathAndName: string;
begin
  if IsLibrary then
    Result := GetModuleName(HInstance)
  else
    Result := ParamStr(0);
end;

class function TcaUtils.PtrToString(APointer: Pointer): string;
var
  FmtStr: string;
begin
  // This is portable between 32 bits and 64 bits
  FmtStr := '%.' + IntToStr(SizeOf(PtrUInt)) + 'x';
  Result := Format(FmtStr, [PtrToUInt(APointer)]);
end;

class function TcaUtils.PtrToUInt(APointer: Pointer): PtrUInt;
begin
  // This is portable between 32 bits and 64 bits
  Result := {%H-}PtrUInt(APointer);
end;

class function TcaUtils.UIntToPtr(AUInt: PtrUInt): Pointer;
begin
  // This is portable between 32 bits and 64 bits
  Result := {%H-}Pointer(AUInt);
end;

// GUID support

class function TcaUtils.GetGUIDAsString: string;
var
  Guid: TGuid;
  GuidStr: string[38];
begin
  CreateGuid(Guid);
  GuidStr := GUIDToString(Guid);
  SetLength(Result, 32);
  Move(GuidStr[2], Result[1], 8);
  Move(GuidStr[11], Result[9], 4);
  Move(GuidStr[16], Result[13], 4);
  Move(GuidStr[21], Result[17], 4);
  Move(GuidStr[26], Result[21], 12);
end;

// Comparison methods

class function TcaUtils.CompareBooleans(const Item1, Item2: Boolean): TcaCompareResult;
begin
  if Item1 = Item2 then Result := crEqual else
    if Item1 > Item2 then Result := crFirstGreater
    else Result := crSecondGreater;
end;

class function TcaUtils.CompareDateTimes(const Item1, Item2: TDateTime): TcaCompareResult;
begin
  if Item1 = Item2 then Result := crEqual else
    if Item1 > Item2 then Result := crFirstGreater
    else Result := crSecondGreater;
end;

class function TcaUtils.CompareDoubles(const Item1, Item2: Double): TcaCompareResult;
begin
  if Item1 = Item2 then Result := crEqual else
    if Item1 > Item2 then Result := crFirstGreater
    else Result := crSecondGreater;
end;

class function TcaUtils.CompareIntegers(const Item1, Item2: Integer): TcaCompareResult;
begin
  if Item1 = Item2 then Result := crEqual else
    if Item1 > Item2 then Result := crFirstGreater
    else Result := crSecondGreater;
end;

class function TcaUtils.CompareInt64s(const Item1, Item2: Int64): TcaCompareResult;
begin
  if Item1 = Item2 then Result := crEqual else
    if Item1 > Item2 then Result := crFirstGreater
    else Result := crSecondGreater;
end;

class function TcaUtils.CompareMemos(const Item1, Item2: TStrings; ACaseInsensitive: Boolean): TcaCompareResult;
var
  S1, S2: string;
begin
  if ACaseInsensitive then
    begin
      S1 := LowerCase(Item1.Text);
      S2 := LowerCase(Item2.Text);
    end
  else
    begin
      S1 := Item1.Text;
      S2 := Item2.Text;
    end;
  if S1 = S2 then Result := crEqual else
    if S1 > S2 then Result := crFirstGreater
    else Result := crSecondGreater;
end;

class function TcaUtils.CompareObjects(const Item1, Item2: TObject): TcaCompareResult;
begin
  // Cannot compare objects in any meaningful way
  Result := crEqual;
  if (Item1 = Item2) or (Item1 <> Item2) then
    Result := crEqual;
end;

class function TcaUtils.CompareSingles(const Item1, Item2: Single): TcaCompareResult;
begin
  if Item1 = Item2 then Result := crEqual else
    if Item1 > Item2 then Result := crFirstGreater
    else Result := crSecondGreater;
end;

class function TcaUtils.CompareStrings(const Item1, Item2: string; ACaseInsensitive: Boolean): TcaCompareResult;
var
  S1, S2: string;
begin
  if ACaseInsensitive then
    begin
      S1 := LowerCase(Item1);
      S2 := LowerCase(Item2);
    end
  else
    begin
      S1 := Item1;
      S2 := Item2;
    end;
  if S1 = S2 then Result := crEqual else
    if S1 > S2 then Result := crFirstGreater
    else Result := crSecondGreater;
end;

class function TcaUtils.CompareUInt32s(const Item1, Item2: UInt32): TcaCompareResult;
begin
  if Item1 = Item2 then Result := crEqual else
    if Item1 > Item2 then Result := crFirstGreater
    else Result := crSecondGreater;
end;

class function TcaUtils.CompareUInt64s(const Item1, Item2: UInt64): TcaCompareResult;
begin
  if Item1 = Item2 then Result := crEqual else
    if Item1 > Item2 then Result := crFirstGreater
    else Result := crSecondGreater;
end;

// Rtti methods

class function TcaUtils.TypeKindToStr(const ATypeKind: TTypeKind): string;
begin
  Result := cTypeKindNames[ATypeKind];
end;

class procedure TcaUtils.DumpRttiInfo(const AInstance: TObject; AStrings: TStrings; ADelim: string);
begin
  DumpRttiInfo(AInstance.ClassType, AStrings, ADelim);
end;

class procedure TcaUtils.DumpRttiInfo(const AClass: TClass; AStrings: TStrings; ADelim: string);
var
  Rtti: TcaRttiList;
  Item: TcaRttiItem;
  Index: Integer;
  PropClassName: string;
  PropKindName: string;
  PropKindExpName: string;
  S: string;
begin
  Rtti := TcaRttiList.Create(AClass);
  try
    for Index := 0 to Pred(Rtti.Count) do
      begin
        Item := Rtti[Index];
        PropKindName := GetEnumName(TypeInfo(Item.PropKind), Ord(Item.PropKind));
        PropKindExpName := Utils.TypeKindToStr(Item.PropKind);
        PropClassName := '';
        if Item.PropKind = tkClass then
          PropClassName := Item.PropClass.ClassName
        else
          PropClassName := Item.PropClassName;
        S := Item.PropName + ADelim + PropKindName + ' (' + PropKindExpName + ')' + ADelim
          + '$' + Format('%P', [Pointer(Item.PropClass)]) + ADelim + PropClassName
          + ADelim + IntToStr(Item.PropSize);
        AStrings.Add(S);
      end;
  finally
    Rtti.Free;
  end;
end;

