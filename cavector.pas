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

unit caVector;

// An investigation into FPC generics...

{$mode objfpc}{$H+}

interface

{.$define DBG}

uses

// FPC units
  Classes,
  SysUtils,
  TypInfo,
  LResources,

// caLibrary units
  caClasses,
  caObserver,
  caTypes
  {$ifdef DBG}, caDbg;{$else DBG};{$endif DBG}

type

// TcaVectorException

  EcaVectorException = class(EcaException);

// TcaVectorBase

  TcaVectorBase = class(TInterfacedObject, IcaSubject)
  private
    // Private members
    FIteratorIndex: Integer;
    FList: TList;
    FOnChange: TNotifyEvent;
    FSubject: IcaSubject;
    FUpdateCount: Integer;
    // Property methods
    function GetCount: Integer;
    function GetPointer(AIndex: Integer): Pointer;
  protected
    // Protected methods
    function GetElementSize: Integer; virtual; abstract;
    procedure Changed;
    procedure DoChanged; virtual;
    procedure IncrementIterator;
    // Protected properties
    property IteratorIndex: Integer read FIteratorIndex;
    property Subject: IcaSubject read FSubject implements IcaSubject;
  public
    // Create/Destroy
    constructor Create; overload;
    constructor Create(AVector: TcaVectorBase); overload;
    destructor Destroy; override;
    // Public methods
    function First: Integer;
    function GetSubject: IcaSubject;
    function HasMore: Boolean;
    function IsEmpty: Boolean;
    function Last: Integer;
    function NextAsString: string; virtual; abstract;
    procedure Assign(Source: TcaVectorBase);
    procedure Clear;
    procedure BeginUpdate;
    procedure Delete(AIndex: Integer);
    procedure EndUpdate;
    procedure ResetIterator;
    // Public properties
    property Count: Integer read GetCount;
    property List: TList read FList;
    property Pointers[AIndex: Integer]: Pointer read GetPointer;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

// TcaVector<T>

  generic TcaVector<T> = class(TcaVectorBase)
  private
    // Property methods
    function GetItem(AIndex: Integer): T;
    procedure SetItem(AIndex: Integer; AValue: T);
  protected
    // Protected methods
    function GetElementSize: Integer; override;
  public
    // Public methods
    function Add(AItem: T): Integer;
    function Contains(AItem: T): Boolean;
    function IndexOf(AItem: T): Integer;
    function Next: T;
    function NextAsString: string; override;
    // Stack public methods 
    function Peek: T;
    function Pop: T;
    function Push(AItem: T): Integer;
    // Public properties
    property Items[AIndex: Integer]: T read GetItem write SetItem; default;
  end;

// TcaIntegerVector

  TcaIntegerVector = specialize TcaVector<Integer>;

// TcaUInt32Vector

  TcaUInt32Vector = specialize TcaVector<UInt32>;

// TcaInt64Vector

  TcaInt64Vector = specialize TcaVector<Int64>;

// TcaUInt64Vector

  TcaUInt64Vector = specialize TcaVector<UInt64>;

// TcaSingleVector

  TcaSingleVector = specialize TcaVector<Single>;

// TcaDoubleVector

  TcaDoubleVector = specialize TcaVector<Double>;

  TcaVectorType = (vtInteger, vtUInt32, vtInt64, vtUInt64, vtSingle, vtDouble);

  TcaVectorTypes = set of TcaVectorType;

implementation

// TcaVectorBase

// Create/Destroy

constructor TcaVectorBase.Create;
begin
  inherited Create;
  ResetIterator;
  FList := TList.Create;
  FSubject := TcaSubject.Create(smSynchronize);
end;

constructor TcaVectorBase.Create(AVector: TcaVectorBase);
begin
  Create;
  Assign(AVector);
end;

destructor TcaVectorBase.Destroy;
begin
  Clear;
  FList.Free;
  FSubject := nil;
  inherited Destroy;
end;

// Public methods

function TcaVectorBase.First: Integer;
begin
  Result := 0;
end;

function TcaVectorBase.GetSubject: IcaSubject;
begin
  if not GetInterface(IcaSubject, Result) then
    raise EcaVectorException.Create('Interface not created');
end;

function TcaVectorBase.HasMore: Boolean;
begin
  Result := FIteratorIndex < Pred(FList.Count);
end;

function TcaVectorBase.IsEmpty: Boolean;
begin
  Result := FList.Count = 0;
end;

function TcaVectorBase.Last: Integer;
begin
  Result := Pred(FList.Count);
end;

procedure TcaVectorBase.Assign(Source: TcaVectorBase);
var
  Index: Integer;
  P: Pointer;
begin
  Clear;
  for Index := 0 to Pred(Source.Count) do
    begin
      GetMem(P, GetElementSize);
      Move((Source.Pointers[Index])^, P^, GetElementSize);
      FList.Add(P);
    end;
  Changed;
end;

procedure TcaVectorBase.Clear;
begin
  while Count > 0 do
    Delete(0);
end;

procedure TcaVectorBase.BeginUpdate;
begin
  Inc(FUpdateCount);
end;

procedure TcaVectorBase.Delete(AIndex: Integer);
var
  P: Pointer;
begin
  P := FList[AIndex];
  FreeMem(P, GetElementSize);
  FList.Delete(AIndex);
end;

procedure TcaVectorBase.EndUpdate;
begin
  Dec(FUpdateCount);
  if FUpdateCount = 0 then
    Changed;
end;

procedure TcaVectorBase.ResetIterator;
begin
  FIteratorIndex := -1;
end;

// Protected methods

procedure TcaVectorBase.Changed;
begin
  if FUpdateCount = 0 then
    begin
      DoChanged;
      GetSubject.Notify;
    end;
end;

procedure TcaVectorBase.DoChanged;
begin
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

procedure TcaVectorBase.IncrementIterator;
begin
  Inc(FIteratorIndex);
end;

// Property methods

function TcaVectorBase.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TcaVectorBase.GetPointer(AIndex: Integer): Pointer;
begin
  Result := FList[AIndex];
end;

// TcaVector

// Protected methods

function TcaVector.GetElementSize: Integer;
begin
  Result := SizeOf(T);
end;

// Public methods

function TcaVector.Add(AItem: T): Integer;
var
  P: Pointer;
begin
  GetMem(P, GetElementSize);
  Move(AItem, P^, GetElementSize);
  Result := List.Add(P);
  Changed;
end;

function TcaVector.Contains(AItem: T): Boolean;
begin
  Result := IndexOf(AItem) > 0;
end;

function TcaVector.IndexOf(AItem: T): Integer;
var
  Index: Integer;
begin
  Result := -1;
  for Index := 0 to Pred(Count) do
    begin
      if GetItem(Index) = AItem then
        begin
          Result := Index;
          Break;
        end;
    end;
end;

function TcaVector.Next: T;
begin
  if IteratorIndex < Pred(Count) then
    begin
      IncrementIterator;
      Result := GetItem(IteratorIndex);
    end
  else
    Result := Default(T);
end;

function TcaVector.NextAsString: string;
var
  N: Double;
begin
  N := Next;
  Result := FloatToStr(N);
end;

function TcaVector.Peek: T;
begin
  if not IsEmpty then
    Result := GetItem(Last)
  else
    Result := Default(T);
end;

function TcaVector.Pop: T;
begin
  if not IsEmpty then
    begin
      Result := GetItem(Last);
      Delete(Last);
    end
  else
    Result := Default(T);
end;

function TcaVector.Push(AItem: T): Integer;
begin
  Result := Add(AItem);
  Changed;
end;

// Property methods

function TcaVector.GetItem(AIndex: Integer): T;
begin
  Result := T(List[AIndex]^);
end;

procedure TcaVector.SetItem(AIndex: Integer; AValue: T);
var
  P: Pointer;
begin
  GetMem(P, GetElementSize);
  Move(AValue, P^, GetElementSize);
  List[AIndex] := P;
end;

end.

