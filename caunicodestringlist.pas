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

unit caunicodestringlist;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type

  { TcaUnicodeStringList }

  { TcaUnicodeStringItem }

  TcaUnicodeStringItem = class(TObject)
  private
    FData: UnicodeString;
  public
    constructor Create(const AValue: UnicodeString);
    property Data: UnicodeString read FData write FData;
  end;

  TcaUnicodeStringList = class(TObject)
  private
    FList: TList;
    function GetItemObject(Index: Integer): TcaUnicodeStringItem;
    function GetItem(Index: Integer): UnicodeString;
    procedure SetItem(Index: Integer; AValue: UnicodeString);
  public
    constructor Create;
    destructor Destroy; override;
    function Add(const AValue: UnicodeString): Integer;
    function Count: Integer;
    procedure Insert(Index: Integer; const AValue: UnicodeString);
    procedure Clear;
    procedure Delete(Index: Integer);
    property Items[Index: Integer]: UnicodeString read GetItem write SetItem; default;
  end;

implementation

{ TcaUnicodeStringItem }

constructor TcaUnicodeStringItem.Create(const AValue: UnicodeString);
begin
  inherited Create;
  FData := AValue;
end;

{ TcaUnicodeStringList }

constructor TcaUnicodeStringList.Create;
begin
  inherited Create;
  FList := TList.Create;
end;

destructor TcaUnicodeStringList.Destroy;
begin
  FList.Free;
  inherited Destroy;
end;

function TcaUnicodeStringList.Add(const AValue: UnicodeString): Integer;
var
  Item: TcaUnicodeStringItem;
begin
  Item := TcaUnicodeStringItem.Create(AValue);
  Result := FList.Add(Pointer(Item));
end;

function TcaUnicodeStringList.Count: Integer;
begin
  Result := FList.Count;
end;

procedure TcaUnicodeStringList.Insert(Index: Integer; const AValue: UnicodeString);
var
  Item: TcaUnicodeStringItem;
begin
  Item := TcaUnicodeStringItem.Create(AValue);
  FList.Insert(Index, Pointer(Item));
end;

procedure TcaUnicodeStringList.Clear;
begin
  while Count > 0 do
    Delete(0);
end;

procedure TcaUnicodeStringList.Delete(Index: Integer);
var
  Item: TcaUnicodeStringItem;
begin
  Item := GetItemObject(Index);
  if Assigned(Item) then
    begin
      Item.Free;
      FList.Delete(Index);
    end;
end;

function TcaUnicodeStringList.GetItemObject(Index: Integer): TcaUnicodeStringItem;
begin
  Result := TcaUnicodeStringItem(Flist[Index]);
end;

function TcaUnicodeStringList.GetItem(Index: Integer): UnicodeString;
var
  Item: TcaUnicodeStringItem;
begin
  Item := GetItemObject(Index);
  Result := Item.Data;
end;

procedure TcaUnicodeStringList.SetItem(Index: Integer; AValue: UnicodeString);
var
  Item: TcaUnicodeStringItem;
begin
  if FList[Index] = nil then
    Item := TcaUnicodeStringItem.Create(AValue)
  else
    Item := GetItemObject(Index);
  Item.Data := AValue;
end;

end.

