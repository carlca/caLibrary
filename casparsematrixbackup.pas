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

unit casparsematrixbackup;

{$mode objfpc}{$H+}

interface

uses
// FPC units
  Classes,
  SysUtils,

// caLibrary units
  caUtils;

type

// EcaSparseMatrixException

  EcaSparseMatrixException = class(EcaException);

// TcaSparseMatrix

  TcaSparseMatrix = class(TObject)
  private
    // Private fields 
    FCols: TList;
    FElements: array of array of Pointer;
    FRowCount: Integer;
    // Property methods 
    function GetColCount: Integer;
    function GetItem(ACol, ARow: Integer): Pointer;
    function GetRowCount: Integer;
    procedure SetColCount(const AValue: Integer);
    procedure SetItem(ACol, ARow: Integer; const AValue: Pointer);
    procedure SetRowCount(const AValue: Integer);
    // Private methods 
    procedure FreeRows;
    procedure FreeCell(ACol, ARow: Integer);
    procedure FreeCells;
  public
    // Create/Destroy
    constructor Create;
    destructor Destroy; override;
    // Properties 
    property ColCount: Integer read GetColCount write SetColCount;
    property Items[ACol, ARow: Integer]: Pointer read GetItem write SetItem; default;
    property RowCount: Integer read GetRowCount write SetRowCount;
  end;

implementation

// TcaSparseMatrix

// Create/Destroy                                      setlength

constructor TcaSparseMatrix.Create;
begin
  FCols := TList.Create;
end;

destructor TcaSparseMatrix.Destroy;
begin
  FreeCells;
  FreeRows;
  FCols.Free;
  inherited Destroy;
end;

// Private methods

procedure TcaSparseMatrix.FreeRows;
var
  Index: Integer;
begin
  for Index := 0 to Pred(FCols.Count) do
    TObject(FCols[Index]).Free;
end;

procedure TcaSparseMatrix.FreeCell(ACol, ARow: Integer);
var
  Item: TObject;
begin
  Item := TObject(GetItem(ACol, ARow));
  Item.Free;
  SetItem(ACol, ARow, nil);
end;

procedure TcaSparseMatrix.FreeCells;
var
  ACol: Integer;
  ARow: Integer;
begin
  for ACol := 0 to ColCount - 1 do
    for ARow := 0 to RowCount - 1 do
      FreeCell(ACol, ARow);
end;

// Property methods

function TcaSparseMatrix.GetColCount: Integer;
begin
  Result := FCols.Count;
end;

function TcaSparseMatrix.GetItem(ACol, ARow: Integer): Pointer;
var
  Rows: TList;
begin
  Rows := TList(FCols[ACol]);
  Result := Rows[ARow];
end;

function TcaSparseMatrix.GetRowCount: Integer;
begin
  Result := FRowCount;
end;

procedure TcaSparseMatrix.SetColCount(const AValue: Integer);
var
  ACol: Integer;
  ARow: Integer;
  Rows: TList;
begin
  if AValue <> FCols.Count then
    begin
      // If AValue represents an increase in ColCount
      if AValue > FCols.Count then
        begin
          // For each extra column to be added
          while FCols.Count < AValue do
            begin
              Rows := TList.Create;
              // Create a new column of sparse cells
              for ARow := 0 to Pred(FRowCount) do
                Rows.Add(nil);
              // Add the new Rows list to the new column
              FCols.Add(Rows);
            end;
        end
      else
        begin
          // If AValue represents a decrease on ColCount
          { TODO : Sort out memory leak in following section of code }
          //while FCols.Count > AValue do
          //  begin
          //    // For each row in the column to be deleted
          //    for ARow := 0 to Pred(FRowCount) do
          //      begin
          //        // Free the cell to be deleted
          //        ACol := Pred(FCols.Count);
          //        FreeCell(Pred(FCols.Count), ARow);
          //      end;
          //    // Delete the cell from the row
          //    ACol := Pred(FCols.Count);
          //    FCols.Delete(Pred(FCols.Count));
          //  end;
        end;
    end;
end;

procedure TcaSparseMatrix.SetItem(ACol, ARow: Integer; const AValue: Pointer);
var
  Rows: TList;
begin
  Rows := TList(FCols[ACol]);
  Rows[ARow] := AValue;
end;

procedure TcaSparseMatrix.SetRowCount(const AValue: Integer);
var
  ACol: Integer;
  ARow: Integer;
  Rows: TList;
begin
  if AValue <> FRowCount then
    begin
      // Free the cells to be deleted
      // only occurs if AValue represents a decrease in RowCount
      for ARow := AValue to Pred(FRowCount) do
        for ACol := 0 to FCols.Count - 1 do
          FreeCell(ACol, ARow);
      // Set new RowCount
      FRowCount := AValue;
      // For all columns
      for ACol := 0 to FCols.Count - 1 do
        begin
          // Get Rows list for the given column
          Rows := TList(FCols[ACol]);
          if FRowCount > Rows.Count then
            begin
              // For any extra rows add a sparse cell for the given column
              while Rows.Count < FRowCount do
                Rows.Add(nil);
            end
          else
            begin
              // For any rows to be deleted delete a sparse cell for the given column
              while Rows.Count > FRowCount do
                Rows.Delete(Rows.Count - 1);
            end;
        end;
    end;
end;

end.

