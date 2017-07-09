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

unit caListBase;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

const

  SListCapacityError            = 'List capacity (%d) exceeded.';
  SListCountError               = 'List count (%d) out of bounds.';
  SListIndexError               = 'List index (%d) out of bounds';
  SListItemSizeError            = 'Incompatible item size in source list';

type

  // Copied from TFPSList in Fgl.pp
  // Altered to descend from TInterfacedObject
  // Otherwise, unchanged

  TcaListCompareFunc = function(Key1, Key2: Pointer): Integer of object;

  TcaListBase = class(TInterfacedObject)
  protected
    FList: PByte;
    FCount: Integer;
    FCapacity: Integer; { list is one longer sgthan capacity, for temp }
    FItemSize: Integer;
    procedure CopyItem(Src, Dest: Pointer); virtual;
    procedure Deref(Item: Pointer); virtual; overload;
    procedure Deref(FromIndex, ToIndex: Integer); overload;
    function Get(Index: Integer): Pointer;
    procedure InternalExchange(Index1, Index2: Integer);
    function  InternalGet(Index: Integer): Pointer; {$ifdef CLASSESINLINE} inline; {$endif}
    procedure InternalPut(Index: Integer; NewItem: Pointer);
    procedure Put(Index: Integer; Item: Pointer);
    procedure QuickSort(L, R: Integer; Compare: TcaListCompareFunc);
    procedure SetCapacity(NewCapacity: Integer);
    procedure SetCount(NewCount: Integer);
    procedure RaiseIndexError(Index : Integer);
    property InternalItems[Index: Integer]: Pointer read InternalGet write InternalPut;
    function GetLast: Pointer;
    procedure SetLast(const Value: Pointer);
    function GetFirst: Pointer;
    procedure SetFirst(const Value: Pointer);
  public
    constructor Create(AItemSize: Integer = sizeof(Pointer));
    destructor Destroy; override;
    function Add(Item: Pointer): Integer;
    procedure Clear;
    procedure Delete(Index: Integer);
    class procedure Error(const Msg: string; Data: PtrInt);
    procedure Exchange(Index1, Index2: Integer);
    function Expand: TcaListBase;
    procedure Extract(Item: Pointer; ResultPtr: Pointer);
    function IndexOf(Item: Pointer): Integer;
    procedure Insert(Index: Integer; Item: Pointer);
    function Insert(Index: Integer): Pointer;
    procedure Move(CurIndex, NewIndex: Integer);
    procedure Assign(Obj: TcaListBase);
    function Remove(Item: Pointer): Integer;
    procedure Pack;
    procedure Sort(Compare: TcaListCompareFunc);
    property Capacity: Integer read FCapacity write SetCapacity;
    property Count: Integer read FCount write SetCount;
    property Items[Index: Integer]: Pointer read Get write Put; default;
    property ItemSize: Integer read FItemSize;
    property List: PByte read FList;
    property First: Pointer read GetFirst write SetFirst;
    property Last: Pointer read GetLast write SetLast;
  end;

implementation

constructor TcaListBase.Create(AItemSize: integer);
begin
  inherited Create;
  FItemSize := AItemSize;
end;

destructor TcaListBase.Destroy;
begin
  Clear;
  // Clear() does not clear the whole list; there is always a single temp entry
  // at the end which is never freed. Take care of that one here.
  FreeMem(FList);
  inherited Destroy;
end;

procedure TcaListBase.CopyItem(Src, Dest: Pointer);
begin
  System.Move(Src^, Dest^, FItemSize);
end;

procedure TcaListBase.RaiseIndexError(Index : Integer);
begin
  Error(SListIndexError, Index);
end;

function TcaListBase.InternalGet(Index: Integer): Pointer;
begin
  Result:=FList+Index*ItemSize;
end;

procedure TcaListBase.InternalPut(Index: Integer; NewItem: Pointer);
var
  ListItem: Pointer;
begin
  ListItem := InternalItems[Index];
  CopyItem(NewItem, ListItem);
end;

function TcaListBase.Get(Index: Integer): Pointer;
begin
  if (Index < 0) or (Index >= FCount) then
    RaiseIndexError(Index);
  Result := InternalItems[Index];
end;

procedure TcaListBase.Put(Index: Integer; Item: Pointer);
var p : Pointer;
begin
  if (Index < 0) or (Index >= FCount) then
    RaiseIndexError(Index);
  p:=InternalItems[Index];
  if assigned(p) then
    DeRef(p);
  InternalItems[Index] := Item;
end;

procedure TcaListBase.SetCapacity(NewCapacity: Integer);
begin
  if (NewCapacity < FCount) or (NewCapacity > MaxListSize) then
    Error(SListCapacityError, NewCapacity);
  if NewCapacity = FCapacity then
    exit;
  ReallocMem(FList, (NewCapacity+1) * FItemSize);
  FillChar(InternalItems[FCapacity]^, (NewCapacity+1-FCapacity) * FItemSize, #0);
  FCapacity := NewCapacity;
end;

procedure TcaListBase.Deref(Item: Pointer);
begin
end;

procedure TcaListBase.Deref(FromIndex, ToIndex: Integer);
var
  ListItem, ListItemLast: Pointer;
begin
  ListItem := InternalItems[FromIndex];
  ListItemLast := InternalItems[ToIndex];
  repeat
    Deref(ListItem);
    if ListItem = ListItemLast then
      break;
    ListItem := PByte(ListItem) + ItemSize;
  until false;
end;

procedure TcaListBase.SetCount(NewCount: Integer);
begin
  if (NewCount < 0) or (NewCount > MaxListSize) then
    Error(SListCountError, NewCount);
  if NewCount > FCapacity then
    SetCapacity(NewCount);
  if NewCount > FCount then
    FillByte(InternalItems[FCount]^, (NewCount-FCount) * FItemSize, 0)
  else if NewCount < FCount then
    Deref(NewCount, FCount-1);
  FCount := NewCount;
end;

function TcaListBase.Add(Item: Pointer): Integer;
begin
  if FCount = FCapacity then
    Self.Expand;
  CopyItem(Item, InternalItems[FCount]);
  Result := FCount;
  Inc(FCount);
end;

procedure TcaListBase.Clear;
begin
  if Assigned(FList) then
  begin
    SetCount(0);
    SetCapacity(0);
  end;
end;

procedure TcaListBase.Delete(Index: Integer);
var
  ListItem: Pointer;
begin
  if (Index < 0) or (Index >= FCount) then
    Error(SListIndexError, Index);
  Dec(FCount);
  ListItem := InternalItems[Index];
  Deref(ListItem);
  System.Move(InternalItems[Index+1]^, ListItem^, (FCount - Index) * FItemSize);
  // Shrink the list if appropriate
  if (FCapacity > 256) and (FCount < FCapacity shr 2) then
  begin
    FCapacity := FCapacity shr 1;
    ReallocMem(FList, (FCapacity+1) * FItemSize);
  end;
  { Keep the ending of the list filled with zeros, don't leave garbage data
    there. Otherwise, we could accidentally have there a copy of some item
    on the list, and accidentally Deref it too soon.
    See http://bugs.freepascal.org/view.php?id=20005. }
  FillChar(InternalItems[FCount]^, (FCapacity+1-FCount) * FItemSize, #0);
end;

procedure TcaListBase.Extract(Item: Pointer; ResultPtr: Pointer);
var
  i : Integer;
  ListItemPtr : Pointer;
begin
  i := IndexOf(Item);
  if i >= 0 then
  begin
    ListItemPtr := InternalItems[i];
    System.Move(ListItemPtr^, ResultPtr^, FItemSize);
    { fill with zeros, to avoid freeing/decreasing reference on following Delete }
    System.FillByte(ListItemPtr^, FItemSize, 0);
    Delete(i);
  end else
    System.FillByte(ResultPtr^, FItemSize, 0);
end;

class procedure TcaListBase.Error(const Msg: string; Data: PtrInt);
begin
  raise EListError.CreateFmt(Msg,[Data]) at get_caller_addr(get_frame), get_caller_frame(get_frame);
end;

procedure TcaListBase.Exchange(Index1, Index2: Integer);
begin
  if ((Index1 >= FCount) or (Index1 < 0)) then
    Error(SListIndexError, Index1);
  if ((Index2 >= FCount) or (Index2 < 0)) then
    Error(SListIndexError, Index2);
  InternalExchange(Index1, Index2);
end;

procedure TcaListBase.InternalExchange(Index1, Index2: Integer);
begin
  System.Move(InternalItems[Index1]^, InternalItems[FCapacity]^, FItemSize);
  System.Move(InternalItems[Index2]^, InternalItems[Index1]^, FItemSize);
  System.Move(InternalItems[FCapacity]^, InternalItems[Index2]^, FItemSize);
end;

function TcaListBase.Expand: TcaListBase;
var
  IncSize : Longint;
begin
  if FCount < FCapacity then exit;
  IncSize := 4;
  if FCapacity > 3 then IncSize := IncSize + 4;
  if FCapacity > 8 then IncSize := IncSize + 8;
  if FCapacity > 127 then Inc(IncSize, FCapacity shr 2);
  SetCapacity(FCapacity + IncSize);
  Result := Self;
end;

function TcaListBase.GetFirst: Pointer;
begin
  If FCount = 0 then
    Result := Nil
  else
    Result := InternalItems[0];
end;

procedure TcaListBase.SetFirst(const Value: Pointer);
begin
  Put(0, Value);
end;

function TcaListBase.IndexOf(Item: Pointer): Integer;
var
  ListItem: Pointer;
begin
  Result := 0;
  ListItem := First;
  while (Result < FCount) and (CompareByte(ListItem^, Item^, FItemSize) <> 0) do
  begin
    Inc(Result);
    ListItem := PByte(ListItem)+FItemSize;
  end;
  if Result = FCount then Result := -1;
end;

function TcaListBase.Insert(Index: Integer): Pointer;
begin
  if (Index < 0) or (Index > FCount) then
    Error(SListIndexError, Index);
  if FCount = FCapacity then Self.Expand;
  Result := InternalItems[Index];
  if Index<FCount then
  begin
    System.Move(Result^, (Result+FItemSize)^, (FCount - Index) * FItemSize);
    { clear for compiler assisted types }
    System.FillByte(Result^, FItemSize, 0);
  end;
  Inc(FCount);
end;

procedure TcaListBase.Insert(Index: Integer; Item: Pointer);
begin
  CopyItem(Item, Insert(Index));
end;

function TcaListBase.GetLast: Pointer;
begin
  if FCount = 0 then
    Result := nil
  else
    Result := InternalItems[FCount - 1];
end;

procedure TcaListBase.SetLast(const Value: Pointer);
begin
  Put(FCount - 1, Value);
end;

procedure TcaListBase.Move(CurIndex, NewIndex: Integer);
var
  CurItem, NewItem, TmpItem, Src, Dest: Pointer;
  MoveCount: Integer;
begin
  if (CurIndex < 0) or (CurIndex >= Count) then
    Error(SListIndexError, CurIndex);
  if (NewIndex < 0) or (NewIndex >= Count) then
    Error(SListIndexError, NewIndex);
  if CurIndex = NewIndex then
    exit;
  CurItem := InternalItems[CurIndex];
  NewItem := InternalItems[NewIndex];
  TmpItem := InternalItems[FCapacity];
  System.Move(CurItem^, TmpItem^, FItemSize);
  if NewIndex > CurIndex then
  begin
    Src := InternalItems[CurIndex+1];
    Dest := CurItem;
    MoveCount := NewIndex - CurIndex;
  end else begin
    Src := NewItem;
    Dest := InternalItems[NewIndex+1];
    MoveCount := CurIndex - NewIndex;
  end;
  System.Move(Src^, Dest^, MoveCount * FItemSize);
  System.Move(TmpItem^, NewItem^, FItemSize);
end;

function TcaListBase.Remove(Item: Pointer): Integer;
begin
  Result := IndexOf(Item);
  if Result <> -1 then
    Delete(Result);
end;

const LocalThreshold = 64;

procedure TcaListBase.Pack;
var
  LItemSize : integer;
  NewCount,
  i : integer;
  pdest,
  psrc : Pointer;
  localnul : array[0..LocalThreshold-1] of byte;
  pnul : pointer;
begin
  LItemSize:=FItemSize;
  pnul:=@localnul;
  if LItemSize>Localthreshold then
    getmem(pnul,LItemSize);
  fillchar(pnul^,LItemSize,#0);
  NewCount:=0;
  psrc:=First;
  pdest:=psrc;

  For I:=0 To FCount-1 Do
    begin
        if not CompareMem(psrc,pnul,LItemSize) then
        begin
          System.Move(psrc^, pdest^, LItemSize);
          inc(pdest,LItemSIze);
          inc(NewCount);
        end
      else
        deref(psrc);
      inc(psrc,LitemSize);
    end;
  if LItemSize>Localthreshold then
    FreeMem(pnul,LItemSize);

  FCount:=NewCount;
end;

// Needed by Sort method.

procedure TcaListBase.QuickSort(L, R: Integer; Compare: TcaListCompareFunc);
var
  I, J, P: Integer;
  PivotItem: Pointer;
begin
  repeat
    I := L;
    J := R;
    { cast to dword to avoid overflow to a negative number during addition which
      would result again in a negative number when being divided }
    P := (dword(L) + dword(R)) div 2;
    repeat
      PivotItem := InternalItems[P];
      while Compare(PivotItem, InternalItems[I]) > 0 do
        Inc(I);
      while Compare(PivotItem, InternalItems[J]) < 0 do
        Dec(J);
      if I <= J then
      begin
        InternalExchange(I, J);
        if P = I then
          P := J
        else if P = J then
          P := I;
        Inc(I);
        Dec(J);
      end;
    until I > J;
    if L < J then
      QuickSort(L, J, Compare);
    L := I;
  until I >= R;
end;

procedure TcaListBase.Sort(Compare: TcaListCompareFunc);
begin
  if not Assigned(FList) or (FCount < 2) then exit;
  QuickSort(0, FCount-1, Compare);
end;

procedure TcaListBase.Assign(Obj: TcaListBase);
var
  i: Integer;
begin
  if Obj.ItemSize <> FItemSize then
    Error(SListItemSizeError, 0);
  Clear;
  for I := 0 to Obj.Count - 1 do
    Add(Obj[i]);
end;

end.

