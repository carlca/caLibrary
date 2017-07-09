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

unit caCellManager;

{$mode objfpc}{$H+}

interface

uses

// FPC units
  Classes,
  SysUtils,
  Math,

// caLibrary units
  caClasses,
  caCell,
  caSparseMatrix;

type

// EcaCellManagerException

  EcaCellManagerException = class(EcaException);

// TcaCellManager

  TcaCellManager = class(TObject)
  private
    // Property fields
    FAutoColCount: Boolean;
    FAutoRowCount: Boolean;
    FCells: TcaSparseMatrix;
    // Event property fields
    FOnColCountChanged: TNotifyEvent;
    // Property methods
    function GetColCount: Integer;
    function GetRowCount: Integer;
    procedure SetColCount(AValue: Integer);
    procedure SetRowCount(AValue: Integer);
    // Private methods 
    procedure CheckCounts(ACol, ARow: Integer);
    procedure RemoveOldCell(ACol, ARow: Integer);
  protected
    // Protected event triggers
    procedure DoColCountChanged;
  public
    constructor Create;
    destructor Destroy; override;
    // Public methods
    function CreateNewCell(ACol, ARow: Integer; ACellClass: TcaCellClass): TcaCell;
    function GetCell(ACol, ARow: Integer; ACellClass: TcaCellClass = nil): TcaCell;
    // Properties 
    property AutoColCount: Boolean read FAutoColCount write FAutoColCount;
    property AutoRowCount: Boolean read FAutoRowCount write FAutoRowCount;
    property ColCount: Integer read GetColCount write SetColCount;
    property RowCount: Integer read GetRowCount write SetRowCount;
    // Event properties
    property OnColCountChanged: TNotifyEvent read FOnColCountChanged write FOnColCountChanged;
  end;

  TcaCellManagerClass = class of TcaCellManager;

implementation

// TcaCellFactory

// Create/Destroy

constructor TcaCellManager.Create;
begin
  inherited;
  FCells := TcaSparseMatrix.Create(True);
end;

destructor TcaCellManager.Destroy;
begin
  FCells.Free;
  inherited Destroy;
end;

// Public methods

function TcaCellManager.CreateNewCell(ACol, ARow: Integer; ACellClass: TcaCellClass): TcaCell;
begin
  CheckCounts(ACol, ARow);
  RemoveOldCell(ACol, ARow);
  FCells[ACol, ARow] := ACellClass.Create;
  Result := TcaCell(FCells[ACol, ARow]);
end;

function TcaCellManager.GetCell(ACol, ARow: Integer; ACellClass: TcaCellClass = nil): TcaCell;
begin
  CheckCounts(ACol, ARow);
  if (FCells[ACol, ARow] = nil) and (ACellClass <> nil) then
    FCells[ACol, ARow] := ACellClass.Create;
  Result := TcaCell(FCells[ACol, ARow]);
end;

// Protected event triggers

procedure TcaCellManager.DoColCountChanged;
begin
  if Assigned(FOnColCountChanged) then FOnColCountChanged(Self);
end;

// Private methods

procedure TcaCellManager.CheckCounts(ACol, ARow: Integer);
begin
  if (ACol < 0) or (ACol >= FCells.ColCount) then
    begin
      if FAutoColCount then
        begin
          FCells.ColCount := Max(FCells.ColCount, ACol + 1);
          DoColCountChanged;
        end
      else
        raise EcaCellManagerException.Create('ACol out of range: ' + IntToStr(ACol));
    end;
  if (ARow < 0) or (ARow >= FCells.RowCount) then
    begin
      if FAutoRowCount then
        FCells.RowCount := Max(FCells.RowCount, ARow + 1)
      else
        raise EcaCellManagerException.Create('ARow out of range: ' + IntToStr(ARow));
    end;
end;

procedure TcaCellManager.RemoveOldCell(ACol, ARow: Integer);
var
  Cell: TcaCell;
begin
  Cell := TcaCell(FCells[ACol, ARow]);
  if Cell <> nil then
    begin
      Cell.Free;
      FCells[ACol, ARow] := nil;
    end;
end;

// Property methods

function TcaCellManager.GetColCount: Integer;
begin
  Result := FCells.ColCount;
end;

function TcaCellManager.GetRowCount: Integer;
begin
  Result := FCells.RowCount;
end;

procedure TcaCellManager.SetColCount(AValue: Integer);
begin
  FCells.ColCount := AValue;
  DoColCountChanged;
end;

procedure TcaCellManager.SetRowCount(AValue: Integer);
begin
  FCells.RowCount := AValue;
end;

end.

