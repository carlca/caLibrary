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

unit caMathVector;

{$mode objfpc}{$H+}
{$modeswitch typehelpers}

interface

uses

// FPC units
  Classes,
  SysUtils,

// caLibrary units
  caVector,
  caClasses;

type

// EcaMathVectorException

  EcaMathVectorException = class(EcaException);

// DoubleHelper

  DoubleHelper = type helper for Double
  private
  public
    // Public methods
    function Add(AValue: Double): Double;
    function ToCurrency: string;
    function ToString: string; overload;
    function ToString(AFormat: string): string; overload;
  end;

// TcaMathVector

  TcaMathVector = class(TcaDoubleVector)
  private
    // Property methods
    function GetX(Index: Integer): Double;
    procedure SetX(Index: Integer; AValue: Double);
    // Private methods
    procedure CheckIfEmpty;
    procedure RaiseZeroCountException;
  public
    // Public methods
    function Avg: Double;
    function N: Integer;
    function Sum: Double;
    procedure Fill(ACount: Integer; AValue: Double);
    procedure FillRandom(ACount: Integer; AMultiplier: Double = 1);
    // Public properties
    property X[Index: Integer]: Double read GetX write SetX;
  end;

implementation

// DoubleHelper

function DoubleHelper.Add(AValue: Double): Double;
begin
  Self := Self + AValue;
  Result := Self;
end;

function DoubleHelper.ToCurrency: string;
begin
  Result := FormatFloat('#,##0.00', Self);
end;

function DoubleHelper.ToString: string;
begin
  Result := FloatToStr(Self);
end;

function DoubleHelper.ToString(AFormat: string): string;
begin
  Result := FormatFloat(AFormat, Self);
end;

// TcaMathVector

// Public methods

function TcaMathVector.Avg: Double;
begin
  CheckIfEmpty;
  Result := Sum / N;
end;

function TcaMathVector.N: Integer;
begin
  Result := Count;
end;

function TcaMathVector.Sum: Double;
begin
  ResetIterator;
  Result := 0;
  while HasMore do
    Result.Add(Next);
end;

procedure TcaMathVector.Fill(ACount: Integer; AValue: Double);
var
  Index: Integer;
begin
  BeginUpdate;
  for Index := 0 to Pred(ACount) do
    Add(AValue);
  EndUpdate;
end;

procedure TcaMathVector.FillRandom(ACount: Integer; AMultiplier: Double);
var
  Index: Integer;
begin
  for Index := 0 to Pred(ACount) do
    Add(Random * AMultiplier);
end;

// Private methods

procedure TcaMathVector.CheckIfEmpty;
begin
  if IsEmpty then RaiseZeroCountException;
end;

procedure TcaMathVector.RaiseZeroCountException;
begin
  raise EcaMathVectorException.Create('Vector count is zero');
end;

// Property methods

function TcaMathVector.GetX(Index: Integer): Double;
begin
  Result := Items[Index];
end;

procedure TcaMathVector.SetX(Index: Integer; AValue: Double);
begin
  Items[Index] := AValue;
end;

end.

