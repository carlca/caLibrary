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

unit caRtti;

{$mode objfpc}{$H+}

interface

uses

// FPC units
  Classes,
  SysUtils,
  Contnrs,
  TypInfo,
  Variants,

// caLibrary units
  caClasses;

type

// EcaRttiException

  EcaRttiException = class(EcaException);

  // TcaRttiItem

  TcaRttiItem = class(TObject)
  private
    // Private methods
    FIndex: Integer;
    FPropName: string;
    FPropKind: TTypeKind;
    FPropClass: TClass;
    FPropClassName: string;
    FPropSize: Integer;
  public
    // Public properties
    property Index: Integer read FIndex write FIndex;
    property PropName: String read FPropName write FPropName;
    property PropKind: TTypeKind read FPropKind write FPropKind;
    property PropClass: TClass read FPropClass write FPropClass;
    property PropClassName: string read FPropClassName write FPropClassName;
    property PropSize: Integer read FPropSize write FPropSize;
  end;

// TcaRttiList

  TcaRttiList = class(TObject)
  private
    // Private fields
    FClass: TClass;
    FList: TObjectList;
    // Property methods
    function GetCount: Integer;
    function GetItem(Index: Integer): TcaRttiItem;
    // Private methods
    procedure Update;
  public
    // Create/Destroy
    constructor Create(AClass: TClass);
    destructor Destroy; override;
    // Public properties
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TcaRttiItem read GetItem; default;
  end;

implementation

// TcaRttiList

// Create/Destroy

constructor TcaRttiList.Create(AClass: TClass);
begin
  inherited Create;
  FClass := AClass;
  FList := TObjectList.Create(True);
  Update;
end;

destructor TcaRttiList.Destroy;
begin
  FList.Free;
  inherited Destroy;
end;

// Private methods

procedure TcaRttiList.Update;
var
  PropIndex: Integer;
  Item: TcaRttiItem;
  PropInfo: PPropInfo;
  PropList: PPropList;
  PropTypeData: PTypeData;
  PropTypeInfo: PTypeInfo;
  TypeData: PTypeData;
  TypeInfo: PTypeInfo;
begin
  FList.Clear;
  TypeInfo := FClass.ClassInfo;
  TypeData := GetTypeData(TypeInfo);
  if TypeData^.PropCount <> 0 then
    begin
      // Allocate memroy for PropList
      GetMem(PropList, SizeOf(Pointer) * TypeData^.PropCount);
      try
        GetPropInfos(TypeInfo, PropList);
        for PropIndex := 0 to Pred(TypeData^.PropCount) do
          begin
            // Get Rtti for each published object property
            PropInfo := PropList^[PropIndex];
            // Launch points for extended info
            PropTypeInfo := PropInfo^.PropType;
            PropTypeData := GetTypeData(PropTypeInfo);
            // Create the Rtti schema and add to list
            Item := TcaRttiItem.Create;
            FList.Add(Item);
            // Set Rtti schema properties
            Item.Index := PropIndex;
            Item.PropName := PropInfo^.Name;
            Item.PropKind := PropInfo^.PropType^.Kind;
            Item.PropClass := PropTypeData^.ClassType;
            Item.PropClassName := PropTypeInfo^.Name;
            case Item.PropKind of
              tkUnknown:        Item.PropSize := 0;
              tkInteger:        Item.PropSize := SizeOf(Integer);
              tkChar:           Item.PropSize := SizeOf(Char);
              tkEnumeration:    Item.PropSize := SizeOf(LongWord);
              tkFloat:
                case PropTypeData^.FloatType of
                  ftComp:       Item.PropSize := SizeOf(Comp);
                  ftCurr:       Item.PropSize := SizeOf(Currency);
                  ftDouble:     Item.PropSize := SizeOf(Double);
                  ftExtended:   Item.PropSize := SizeOf(Extended);
                  ftSingle:     Item.PropSize := SizeOf(Single);
                end;
              tkSet:            Item.PropSize := 32;    // 'Small sets' are stored as LongInt;
              tkMethod:         Item.PropSize := SizeOf(Pointer);
              tkSString:        Item.PropSize := PropTypeData^.MaxLength;   // Same as tkString
              tkLString, tkAString, tkWString:
                                Item.PropSize := SizeOf(Pointer);
              tkVariant:        Item.PropSize := SizeOf(Variant);
              tkArray:          Item.PropSize := 0;     // I don't know how to deal with arrays!
              tkRecord:         Item.PropSize := PropTypeData^.RecSize;
              tkInterface, tkClass, tkObject:
                                Item.PropSize := SizeOf(Pointer);
              tkWChar:          Item.PropSize := SizeOf(WChar);
              tkBool:           Item.PropSize := SizeOf(Boolean);
              tkInt64:          Item.PropSize := SizeOf(Int64);
              tkQWord:          Item.PropSize := SizeOf(QWord);
              tkDynArray, tkInterfaceRaw, tkProcVar, tkUString:
                                Item.PropSize := SizeOf(Pointer);
              tkUChar:          Item.PropSize := SizeOf(UnicodeChar);
              tkHelper, tkFile, tkClassRef, tkPointer:
                                Item.PropSize := SizeOf(Pointer);
            else
              Item.PropSize := 0;
            end;
          end;
      finally
        FreeMem(PropList);
      end;
    end;
end;

// Property methods

function TcaRttiList.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TcaRttiList.GetItem(Index: Integer): TcaRttiItem;
begin
  Result := TcaRttiItem(FList[Index]);
end;

end.

