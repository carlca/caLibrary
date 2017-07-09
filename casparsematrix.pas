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

unit caSparseMatrix;

{$mode objfpc}{$H+}

interface

uses
// FPC units
  Classes,
  SysUtils,

// caLibrary units
  caClasses;

type

// EcaSparseMatrixException

  EcaSparseMatrixException = class(EcaException);

// TcaSparseMatrix

  TcaSparseMatrix = class(TObject)
  private
    // Private fields 
    FElements: array of array of Pointer;
    FMaintainsObjects: Boolean;
    // Property methods 
    function GetColCount: Integer;
    function GetItem(ACol, ARow: Integer): Pointer;
    function GetRowCount: Integer;
    procedure SetColCount(const AValue: Integer);
    procedure SetItem(ACol, ARow: Integer; const AValue: Pointer);
    procedure SetRowCount(const AValue: Integer);
    // Private methods 
    procedure SetElementToNil(ACol, ARow: Integer);
    procedure SetElementsToNil;
  public
    // Create/Destroy
    constructor Create; overload;
    constructor Create(AMaintainsObjects: Boolean); overload;
    destructor Destroy; override;
    // Properties 
    property ColCount: Integer read GetColCount write SetColCount;
    property MaintainsObjects: Boolean read FMaintainsObjects write FMaintainsObjects;
    property Items[ACol, ARow: Integer]: Pointer read GetItem write SetItem; default;
    property RowCount: Integer read GetRowCount write SetRowCount;
  end;

implementation

// TcaSparseMatrix

// Create/Destroy

constructor TcaSparseMatrix.Create;
begin
  inherited;
  FMaintainsObjects := False;
end;

constructor TcaSparseMatrix.Create(AMaintainsObjects: Boolean);
begin
  Create;
  FMaintainsObjects := AMaintainsObjects;
end;

destructor TcaSparseMatrix.Destroy;
begin
  SetElementsToNil;
  inherited Destroy;
end;

// Private methods

procedure TcaSparseMatrix.SetElementToNil(ACol, ARow: Integer);
var
  Temp: TObject;
begin
  if Assigned(FElements[ACol, ARow]) then
    begin
      if FMaintainsObjects then
        begin
          Temp := TObject(FElements[ACol, ARow]);
          FElements[ACol, ARow] := nil;
          Temp.Free;
        end
      else
        FElements[ACol, ARow] := nil;
    end;
end;

procedure TcaSparseMatrix.SetElementsToNil;
var
  ACol: Integer;
  ARow: Integer;
begin
  for ACol := 0 to GetColCount - 1 do
    for ARow := 0 to GetRowCount - 1 do
      SetElementToNil(ACol, ARow);
end;

// Property methods

function TcaSparseMatrix.GetColCount: Integer;
begin
  Result := Length(FElements);
end;

function TcaSparseMatrix.GetItem(ACol, ARow: Integer): Pointer;
begin
  if (ACol < 0) and (ACol >= GetColCount) then
    raise EcaSparseMatrixException.CreateFmt('ACol is out if range: %d', [ACol]);
  if (ARow < 0) and (ARow >= GetRowCount) then
    raise EcaSparseMatrixException.CreateFmt('ARow is out if range: %d', [ARow]);
  Result := FElements[ACol, ARow];
end;

function TcaSparseMatrix.GetRowCount: Integer;
begin
  Result := 0;
  if Length(FElements) > 0 then
    Result := Length(FElements[0]);
end;

procedure TcaSparseMatrix.SetColCount(const AValue: Integer);
var
  ACol: Integer;
  ARow: Integer;
begin
  if AValue <> GetColCount then
    begin
      if AValue > GetColCount then
        // AValue represents an increase in ColCount
        SetLength(FElements, AValue, GetRowCount)
      else
        begin
          // AValue represents a decrease on ColCount
          for ACol := AValue to Pred(GetColCount) do
            for ARow := 0 to Pred(GetRowCount) do
              // For each row in the column to be deleted
              SetElementToNil(ACol, ARow);
          SetLength(FElements, AValue, GetRowCount)
        end;
    end;
end;

procedure TcaSparseMatrix.SetItem(ACol, ARow: Integer; const AValue: Pointer);
begin
  if (ACol < 0) and (ACol >= GetColCount) then
    raise EcaSparseMatrixException.CreateFmt('ACol is out if range: %d', [ACol]);
  if (ARow < 0) and (ARow >= GetRowCount) then
    raise EcaSparseMatrixException.CreateFmt('ARow is out if range: %d', [ARow]);
  if FMaintainsObjects then
    begin
      if (AValue = nil) or (TObject(AValue).ClassName <> '') then
        FElements[ACol, ARow] := AValue
      else
        raise EcaSparseMatrixException.Create('Only TObjects or nil can be assigned');
    end
  else
    FElements[ACol, ARow] := AValue;
end;

procedure TcaSparseMatrix.SetRowCount(const AValue: Integer);
var
  ACol: Integer;
  ARow: Integer;
begin
  if AValue <> GetRowCount then
    begin
      // Free the cells to be deleted
      // only occurs if AValue represents a decrease in RowCount
      for ARow := AValue to Pred(GetRowCount) do
        for ACol := 0 to Pred(GetColCount) do
          SetElementToNil(ACol, ARow);
      // Set new RowCount
      SetLength(FElements, GetColCount, AValue);
    end;
end;

end.

