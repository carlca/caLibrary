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

unit caMatrixTools;

{$mode objfpc}{$H+}

interface

uses

// FPC units
  Classes,
  SysUtils,
  TypInfo,

// caLibrary units
  caClasses,
  caTypes,
  caConsts,
  caUtils,
  caCell,
  caMatrix,
  caVector;

type

// EcaMatrixToolsException

  EcaMatrixToolsException = class(EcaException);

// TcaSortDirectionVector

  // TcaSortDirectionVector = specialize TcaVector<TcaSortDirection>; // Hmmmm....

  { TcaSortDirectionItem }

  TcaSortDirectionItem = class(TObject)
  private
    FSortDirection: TcaSortDirection;
  public
    // Create/Destroy
    constructor Create(ASortDirection: TcaSortDirection);
    property SortDirection: TcaSortDirection read FSortDirection write FSortDirection;
  end;

  TcaSortDirectionVector = class(TObject)
  private
    FList: TList;
    function GetSortDirection(Index: Integer): TcaSortDirection;
  public
    function Add(AItem: TcaSortDirection): Integer;
    function Count: Integer;
    procedure Clear;
    property Items[Index: Integer]: TcaSortDirection read GetSortDirection; default;
  end;

// TcaMatrixTools

  TcaMatrixTools = class(TComponent)
  private
    // Private fields
    FCompRow: Integer;
    FMatrix: TcaMatrix;
    FSortColumns: TcaIntegerVector;
    FSortDirections: TcaSortDirectionVector;
    FSwapRow: Integer;
    // Private methods
    function CompareCells(const ACol1, ARow1, ACol2, ARow2: Integer): TcaCompareResult;
    function CompareRows(const ARow1, ARow2: Integer): TcaCompareResult;
    function GetRowAsString(ARow: Integer; ADelimiter: Char): string;
    procedure CopyRow(const AFromRow, AToRow: Integer);
    procedure ResetSwapRow;
    procedure SwapRows(const ARow1, ARow2: Integer);
  protected
    // Protected properties
    property SortColumns: TcaIntegerVector read FSortColumns;
    property SortDirections: TcaSortDirectionVector read FSortDirections;
  public
    // Create/Destroy
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    // Public methods
    procedure AddSortColumn(const ACol: Integer; const ASortDirection: TcaSortDirection);
    procedure ClearSortColumns;
    procedure DumpToStrings(AStrings: TStrings; ADelimiter: Char = cTab);
    procedure SaveToExcel(const AFileName: string);
    procedure Sort;
    // Public properties
  published
    property Matrix: TcaMatrix read FMatrix write FMatrix;
  end;

implementation

{ TcaSortDirectionItem }

constructor TcaSortDirectionItem.Create(ASortDirection: TcaSortDirection);
begin
  inherited Create;
  FSortDirection := ASortDirection;
end;

{ TcaSortDirectionVector }

function TcaSortDirectionVector.GetSortDirection(Index: Integer): TcaSortDirection;
begin
  Result := TcaSortDirectionItem(FList[Index]).SortDirection;
end;

function TcaSortDirectionVector.Add(AItem: TcaSortDirection): Integer;
begin
  Result := FList.Add(TcaSortDirectionItem.Create(AItem));
end;

function TcaSortDirectionVector.Count: Integer;
begin
  Result := FList.Count;
end;

procedure TcaSortDirectionVector.Clear;
begin
  FList.Clear;
end;

// TcaMatrixTools

// Create/Destroy

constructor TcaMatrixTools.Create(AOwner: TComponent);
begin
  inherited;
  FSortColumns := TcaIntegerVector.Create;
  FSortDirections := TcaSortDirectionVector.Create;
end;

destructor TcaMatrixTools.Destroy;
begin
  FSortColumns.Free;
  FSortDirections.Free;
  inherited Destroy;
end;

// Public methods

procedure TcaMatrixTools.AddSortColumn(const ACol: Integer; const ASortDirection: TcaSortDirection);
begin
  if not FSortColumns.Contains(ACol) then
    begin
      FSortColumns.Add(ACol);
      FSortDirections.Add(ASortDirection);
    end;
end;

procedure TcaMatrixTools.ClearSortColumns;
begin
  FSortColumns.Clear;
  FSortDirections.Clear;
end;

procedure TcaMatrixTools.DumpToStrings(AStrings: TStrings; ADelimiter: Char);
var
  Row: Integer;
  Line: string;
begin
  if FMatrix = nil then raise EcaMatrixToolsException.Create('Matrix has not been assigned');
  for Row := 0 to Pred(FMatrix.RowCount) do
    begin
      Line := GetRowAsString(Row, ADelimiter);
      AStrings.Add(Line);
    end;
end;

procedure TcaMatrixTools.SaveToExcel(const AFileName: string);
var
  ExcelFile: TStringList;
  FileName: string;
begin
  ExcelFile := TStringList.Create;
  try
    DumpToStrings(ExcelFile, cComma);
    FileName := AFileName;
    if ExtractFileExt(FileName) = '' then
      FileName := FileName + cCsv;
    ExcelFile.SaveToFile(FileName);
  finally
    ExcelFile.Free;
  end;
end;

procedure TcaMatrixTools.Sort;

  procedure QuickSort(const ALo, AHi: Integer);
  var
    Lo, Hi, Mid: Integer;
  begin
    Lo := ALo;
    Hi := AHi;
    Mid := (Lo + Hi) div 2;
    CopyRow(Mid, FCompRow);
    repeat
      while (CompareRows(FCompRow, Lo) = TcaCompareResult(sdAscending)) do Inc(Lo);
      while (CompareRows(Hi, FCompRow) = TcaCompareResult(sdAscending)) do Dec(Hi);
      if (Lo <= Hi) then
        begin
          if (Lo <> Hi) then SwapRows(Lo, Hi);
          Inc(Lo);
          Dec(Hi);
        end;
    until Lo > Hi;
    if Hi > ALo then QuickSort(ALo, Hi);
    if Lo < AHi then QuickSort(Lo, AHi);
  end;

begin
  if FMatrix = nil then raise EcaMatrixToolsException.Create('Matrix has not been assigned');
  if FSortColumns.Count > 0 then
    begin
     FCompRow := FMatrix.AddRow;
     FSwapRow := FMatrix.AddRow;
     QuickSort(0, FMatrix.RowCount - 3);
     FMatrix.RowCount := FMatrix.RowCount - 2;
     ResetSwapRow;
    end;
end;

// Private methods

function TcaMatrixTools.CompareCells(const ACol1, ARow1, ACol2, ARow2: Integer): TcaCompareResult;
var
  Cell1: TcaCell;
  Cell2: TcaCell;
begin
  Cell1 := FMatrix.GetCell(ACol1, ARow1);
  Cell2 := FMatrix.GetCell(ACol2, ARow2);
  Result := Cell1.Compare(Cell2);
end;

function TcaMatrixTools.CompareRows(const ARow1, ARow2: Integer): TcaCompareResult;
var
  ColIndex, ACol: Integer;
  CompResult: TcaCompareResult;
begin
  Result := crEqual;
  for ColIndex := 0 to Pred(FSortColumns.Count) do
    begin
      ACol := FSortColumns[ColIndex];
      CompResult := CompareCells(ACol, ARow1, ACol, ARow2);
      if FSortDirections[ColIndex] = sdDescending then
        begin
          case CompResult of
            crFirstGreater:   CompResult := crSecondGreater;
            crSecondGreater:  CompResult := crFirstGreater;
            crEqual:          ;
          end;
        end;
      if CompResult <> crEqual then
        begin
          Result := CompResult;
          Break;
        end;
    end;
end;

function TcaMatrixTools.GetRowAsString(ARow: Integer; ADelimiter: Char): string;
var
  Col: Integer;
  Line: string;
  Cell: TcaCell;
begin
  Line := '';
  for Col := 0 to Pred(FMatrix.ColCount) do
    begin
      Cell := FMatrix.GetCell(Col, ARow);
      if Cell is TcaOrdinalCell then
        Line := Line + Cell.AsString;
      if Cell is TcaFloatCell then
        Line := Line + Format('%f', [Cell.AsDouble]);
      if Cell is TcaFormattedFloatCell then
        Line := Line + Cell.AsString;
      if Cell is TcaNonNumericCell then
        begin
          if (Cell is TcaStringCell) or (Cell is TcaMemoCell) then
            Line := Line + Cell.AsString
          else
            Pass;
        end;
      if Col < Pred(FMatrix.ColCount) then
        Line := Line + ADelimiter;
    end;
  Result := Line;
end;

procedure TcaMatrixTools.CopyRow(const AFromRow, AToRow: Integer);
var
  Col: Integer;
begin
  for Col := 0 to Pred(FMatrix.ColCount) do
    FMatrix.AssignCell(FMatrix, Col, AFromRow, Col, AToRow);
end;

procedure TcaMatrixTools.ResetSwapRow;
begin
  FSwapRow := -1;
end;

procedure TcaMatrixTools.SwapRows(const ARow1, ARow2: Integer);
begin
  if FSwapRow < 0 then raise EcaMatrixToolsException.Create('SwapRow has not been assigned');
  CopyRow(ARow1, FSwapRow);
  CopyRow(ARow2, ARow1);
  CopyRow(FSwapRow, ARow2);
end;

end.

