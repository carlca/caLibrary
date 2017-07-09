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

unit caVectorBackup;

// An investigation into FPC generics...

{$mode objfpc}{$H+}

interface

uses

// FPC units
  Classes,
  SysUtils,
  TypInfo,
  LResources,

// caLibrary units
  caClasses,
  caObserver,
  caListBase;

type

// TcaVectorException

  EcaVectorException = class(EcaException);

// TcaVectorBase

  TcaVectorBase = class(TcaListBase, IcaSubject)
  private
    // Private members
    FSubject: IcaSubject;
  protected
    // Protected methods
    function GetSubject: IcaSubject;
    // Abstract virtual property method
    function GetString(AIndex: Integer): string; virtual; abstract;
    // Protected properties
    property Subject: IcaSubject read FSubject implements IcaSubject;
  public
    // Create/Destroy
    constructor Create(AItemSize: Integer);
    destructor Destroy; override;
    // Public properties
    property Strings[Index: Integer]: string read GetString;
  end;

// TcaVector<T>

  generic TcaVector<T> = class(TcaVectorBase)
  private
    // Private fields
    FIteratorIndex: Integer;
    FOnChange: TNotifyEvent;
    FUpdateCount: Integer;
    // Property methods
    function GetItem(AIndex: Integer): T;
    procedure SetItem(AIndex: Integer; AValue: T);
  protected
    // Protected methods
    procedure Changed;
    procedure DoChanged; virtual;
  public
    // Create/Destroy
    constructor Create; overload;
    constructor Create(AVector: TcaVector); overload;
    destructor Destroy; override;
    // Overridden from TPersistent
    procedure Assign(Source: TcaVector);
    // Public methods
    function Add(AItem: T): Integer;
    function Contains(AItem: T): Boolean;
    function First: Integer;
    function HasMore: Boolean;
    function IndexOf(AItem: T): Integer;
    function IsEmpty: Boolean;
    function Last: Integer;
    function Next: T;
    procedure Clear;
    procedure BeginUpdate;
    procedure Delete(AIndex: Integer);
    procedure EndUpdate;
    procedure ResetIterator;
    // Stack public methods 
    function Peek: T;
    function Pop: T;
    function Push(AItem: T): Integer;
    // Public properties
    property Items[Index: Integer]: T read GetItem write SetItem; default;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

// TcaIntegerVector

  TcaIntegerVectorSpec = specialize TcaVector<Integer>;

  TcaIntegerVector = class(TcaIntegerVectorSpec)
  protected
    function GetString(AIndex: Integer): string; override;
  end;

// TcaUInt32Vector

  TcaUInt32VectorSpec = specialize TcaVector<UInt32>;

  TcaUInt32Vector = class(TcaUInt32VectorSpec)
  protected
    function GetString(AIndex: Integer): string; override;
  end;

// TcaInt64Vector

  TcaInt64VectorSpec = specialize TcaVector<Int64>;

  TcaInt64Vector = class(TcaInt64VectorSpec)
  protected
    function GetString(AIndex: Integer): string; override;
  end;

// TcaUInt64Vector

  TcaUInt64VectorSpec = specialize TcaVector<UInt64>;

  TcaUInt64Vector = class(TcaUInt64VectorSpec)
  protected
    function GetString(AIndex: Integer): string; override;
  end;

// TcaSingleVector

  TcaSingleVectorSpec = specialize TcaVector<Single>;

  TcaSingleVector = class(TcaSingleVectorSpec)
  protected
    function GetString(AIndex: Integer): string; override;
  end;

// TcaDoubleVector

  TcaDoubleVectorSpec = specialize TcaVector<Double>;

  TcaDoubleVector = class(TcaDoubleVectorSpec)
  protected
    function GetString(AIndex: Integer): string; override;
  end;

  TcaVectorType = (vtInteger, vtUInt32, vtInt64, vtUInt64, vtSingle, vtDouble);

  TcaVectorTypes = set of TcaVectorType;

implementation

// TcaVectorBase

// Create/Destroy

constructor TcaVectorBase.Create(AItemSize: Integer);
begin
  inherited Create(AItemSize);
  FSubject := TcaSubject.Create;
end;

destructor TcaVectorBase.Destroy;
begin
  FSubject := nil;
  inherited Destroy;
end;

// Protected methods

function TcaVectorBase.GetSubject: IcaSubject;
begin
  if not GetInterface(IcaSubject, Result) then
    raise EcaVectorException.Create('Interface not created');
end;

// TcaVector

// Create/Destroy

constructor TcaVector.Create;
begin
  inherited Create(SizeOf(T));
  FIteratorIndex := -1;
end;

constructor TcaVector.Create(AVector: TcaVector);
begin
  inherited Create(SizeOf(T));
  Assign(AVector);
end;

destructor TcaVector.Destroy;
begin
  Clear;
  inherited Destroy;
end;

// Overridden from TPersistent

procedure TcaVector.Assign(Source: TcaVector);
var
  Index: Integer;
begin
  Clear;
  for Index := 0 to Pred(Source.Count) do
    Add(Source[Index]);
end;

// Public methods

function TcaVector.Add(AItem: T): Integer;
begin
  Result := inherited Add(@AItem);
  Changed;
end;

function TcaVector.Contains(AItem: T): Boolean;
begin
  Result := IndexOf(AItem) > 0;
end;

function TcaVector.First: Integer;
begin
  Result := 0;
end;

function TcaVector.HasMore: Boolean;
begin
  Result := FIteratorIndex < Pred(Count);
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

function TcaVector.IsEmpty: Boolean;
begin
  Result := Count = 0;
end;

function TcaVector.Last: Integer;
begin
  Result := Pred(Count);
end;

function TcaVector.Next: T;
begin
  Inc(FIteratorIndex);
  Result := GetItem(FIteratorIndex);
end;

procedure TcaVector.Clear;
begin
  while Count > 0 do
    Delete(0);
end;

procedure TcaVector.BeginUpdate;
begin
  Inc(FUpdateCount);
end;

procedure TcaVector.Delete(AIndex: Integer);
begin
  inherited Delete(AIndex);
end;

procedure TcaVector.EndUpdate;
begin
  Dec(FUpdateCount);
  if FUpdateCount = 0 then
    Changed;
end;

procedure TcaVector.ResetIterator;
begin
  FIteratorIndex := -1;
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

// Protected methods

procedure TcaVector.Changed;
begin
  if FUpdateCount = 0 then
    begin
      DoChanged;
      GetSubject.Notify;
    end;
end;

procedure TcaVector.DoChanged;
begin
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

// Property methods

function TcaVector.GetItem(AIndex: Integer): T;
begin
  Result := T(inherited Get(AIndex)^);
end;

procedure TcaVector.SetItem(AIndex: Integer; AValue: T);
begin
  inherited Put(AIndex, @AValue);
end;

// TcaIntegerVector

function TcaIntegerVector.GetString(AIndex: Integer): string;
begin
  Result := IntToStr(Items[AIndex]);
end;

// TcaUInt32Vector

function TcaUInt32Vector.GetString(AIndex: Integer): string;
begin
  Result := IntToStr(Items[AIndex]);
end;

// TcaInt64Vector

function TcaInt64Vector.GetString(AIndex: Integer): string;
begin
  Result := IntToStr(Items[AIndex]);
end;

// TcaUInt64Vector

function TcaUInt64Vector.GetString(AIndex: Integer): string;
begin
  Result := IntToStr(Items[AIndex]);
end;

// TcaSingleVector

function TcaSingleVector.GetString(AIndex: Integer): string;
begin
  Result := FloatToStr(Items[AIndex]);
end;

// TcaDoubleVector

function TcaDoubleVector.GetString(AIndex: Integer): string;
begin
  Result := FloatToStr(Items[AIndex]);
end;

end.

