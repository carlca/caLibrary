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

unit caCell;

interface

uses

// FPC units
  SysUtils,
  Classes,
  TypInfo,
  Math,

// caLibrary units
  caClasses,
  caUtils,
  caTypes;

type

// EcaCellException

  EcaCellException = class(EcaException);

// TcaCell

  TcaCell = class(TPersistent)
  private
    // Private fields
    FCellType: TcaCellType;
    FEmptyMemo: TStrings;
    FName: String;
    // Event property fields
    FOnChange: TNotifyEvent;
  protected
    // Overridden from TPersistent
    procedure Changed;
    // Protected properties
    property EmptyMemo: TStrings read FEmptyMemo;
    // Virtual abstract methods
    procedure AssignCellValue(ASourceCell: TcaCell); virtual; abstract;
    // Virtual abstract cell access methods
    function GetAsBoolean: Boolean; virtual;
    function GetAsDateTime: TDateTime; virtual;
    function GetAsDouble: Double; virtual;
    function GetAsInteger: Integer; virtual;
    function GetAsInt64: Int64; virtual;
    function GetAsMemo: TStrings; virtual;
    function GetAsObject: TObject; virtual;
    function GetAsSingle: Single; virtual;
    function GetAsString: string; virtual;
    function GetAsUInt32: UInt32; virtual;
    function GetAsUInt64: UInt64; virtual;
    procedure SetAsBoolean({%H-}AValue: Boolean); virtual;
    procedure SetAsDateTime({%H-}AValue: TDateTime); virtual;
    procedure SetAsDouble({%H-}AValue: Double); virtual;
    procedure SetAsInt64({%H-}AValue: Int64); virtual;
    procedure SetAsInteger({%H-}AValue: Integer); virtual;
    procedure SetAsMemo({%H-}AValue: TStrings); virtual;
    procedure SetAsObject({%H-}AValue: TObject); virtual;
    procedure SetAsSingle({%H-}AValue: Single); virtual;
    procedure SetAsString({%H-}AValue: string); virtual;
    procedure SetAsUInt32({%H-}AValue: UInt32); virtual;
    procedure SetAsUInt64({%H-}AValue: UInt64); virtual;
  public
    // Create/Destroy
    constructor Create; virtual;
    destructor Destroy; override;
    // Public methods
    function Compare(ASecondCell: TcaCell): TcaCompareResult; virtual;
    // Overridden from TPersistent
    procedure Assign(Source: TPersistent); override;
    // Public class methods
    class function StringToCellType(ACellTypeString: string): TcaCellType;
    // Properties
    property CellType: TcaCellType read FCellType write FCellType;
    property Name: String read FName write FName;
    // Cell access properties
    property AsBoolean: Boolean read GetAsBoolean write SetAsBoolean;
    property AsDateTime: TDateTime read GetAsDateTime write SetAsDateTime;
    property AsDouble: Double read GetAsDouble write SetAsDouble;
    property AsInteger: Integer read GetAsInteger write SetAsInteger;
    property AsInt64: Int64 read GetAsInt64 write SetAsInt64;
    property AsMemo: TStrings read GetAsMemo write SetAsMemo;
    property AsObject: TObject read GetAsObject write SetAsObject;
    property AsSingle: Single read GetAsSingle write SetAsSingle;
    property AsString: string read GetAsString write SetAsString;
    property AsUInt32: UInt32 read GetAsUInt32 write SetAsUInt32;
    property AsUInt64: UInt64 read GetAsUInt64 write SetAsUInt64;
    // Event properties
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

  TcaCellClass = class of TcaCell;

// TcaNumericCell

  TcaNumericCell = class(TcaCell);

// TcaOrdinalCell

  TcaOrdinalCell = class(TcaNumericCell);         // Boolean, Integer, Int64, UInt32, UInt64

// TcaFloatCell

  TcaFloatCell = class(TcaNumericCell);           // Single, Double

// TcaFormattedFloatCell

  TcaFormattedFloatCell = class(TcaFloatCell);    // DateTime

// TcaNonNumericCell

  TcaNonNumericCell = class(TcaCell);             // String, Memo, Object

// TcaBooleanCell

  TcaBooleanCell = class(TcaOrdinalCell)
  private
    // Property fields
    FValue: Boolean;
  protected
    // Overridden from TcaCell
    procedure AssignCellValue(ASourceCell: TcaCell); override;
    // Overridden property methods
    function GetAsBoolean: Boolean; override;
    function GetAsDateTime: TDateTime; override;
    function GetAsDouble: Double; override;
    function GetAsInteger: Integer; override;
    function GetAsInt64: Int64; override;
    function GetAsMemo: TStrings; override;
    function GetAsObject: TObject; override;
    function GetAsSingle: Single; override;
    function GetAsString: string; override;
    function GetAsUInt32: UInt32; override;
    function GetAsUInt64: UInt64; override;
    procedure SetAsBoolean(AValue: Boolean); override;
  public
    // Create/Destroy
    constructor Create; override;
    // Overridden public methods
    function Compare(ASecondCell: TcaCell): TcaCompareResult; override;
  end;

// TcaDateTimeCell

  TcaDateTimeCell = class(TcaFormattedFloatCell)
  private
    // Property fields
    FValue: TDateTime;
  protected
    // Overridden from TcaCell
    procedure AssignCellValue(ASourceCell: TcaCell); override;
    // Overridden property methods
    function GetAsBoolean: Boolean; override;
    function GetAsDateTime: TDateTime; override;
    function GetAsDouble: Double; override;
    function GetAsInteger: Integer; override;
    function GetAsInt64: Int64; override;
    function GetAsMemo: TStrings; override;
    function GetAsObject: TObject; override;
    function GetAsSingle: Single; override;
    function GetAsString: string; override;
    function GetAsUInt32: UInt32; override;
    function GetAsUInt64: UInt64; override;
    procedure SetAsDateTime(AValue: TDateTime); override;
  public
    // Create/Destroy
    constructor Create; override;
    // Overridden public methods
    function Compare(ASecondCell: TcaCell): TcaCompareResult; override;
  end;

// TcaDoubleCell

  TcaDoubleCell = class(TcaFloatCell)
  private
    // Property fields
    FValue: Double;
  protected
    // Overridden from TcaCell
    procedure AssignCellValue(ASourceCell: TcaCell); override;
    // Overridden property methods
    function GetAsBoolean: Boolean; override;
    function GetAsDateTime: TDateTime; override;
    function GetAsDouble: Double; override;
    function GetAsInteger: Integer; override;
    function GetAsInt64: Int64; override;
    function GetAsMemo: TStrings; override;
    function GetAsObject: TObject; override;
    function GetAsSingle: Single; override;
    function GetAsString: string; override;
    function GetAsUInt32: UInt32; override;
    function GetAsUInt64: UInt64; override;
    procedure SetAsDouble(AValue: Double); override;
  public
    // Create/Destroy
    constructor Create; override;
    // Overridden public methods
    function Compare(ASecondCell: TcaCell): TcaCompareResult; override;
  end;

// TcaIntegerCell

  TcaIntegerCell = class(TcaOrdinalCell)
  private
    // Property fields
    FValue: Integer;
  protected
    // Overridden from TcaCell
    procedure AssignCellValue(ASourceCell: TcaCell); override;
    // Overridden property methods
    function GetAsBoolean: Boolean; override;
    function GetAsDateTime: TDateTime; override;
    function GetAsDouble: Double; override;
    function GetAsInteger: Integer; override;
    function GetAsInt64: Int64; override;
    function GetAsMemo: TStrings; override;
    function GetAsObject: TObject; override;
    function GetAsSingle: Single; override;
    function GetAsString: string; override;
    function GetAsUInt32: UInt32; override;
    function GetAsUInt64: UInt64; override;
    procedure SetAsInteger(AValue: Integer); override;
  public
    // Create/Destroy
    constructor Create; override;
    // Overridden public methods
    function Compare(ASecondCell: TcaCell): TcaCompareResult; override;
  end;

// TcaInt64Cell

  TcaInt64Cell = class(TcaOrdinalCell)
  private
    // Property fields
    FValue: Int64;
  protected
    // Overridden from TcaCell
    procedure AssignCellValue(ASourceCell: TcaCell); override;
    // Overridden property methods
    function GetAsBoolean: Boolean; override;
    function GetAsDateTime: TDateTime; override;
    function GetAsDouble: Double; override;
    function GetAsInteger: Integer; override;
    function GetAsInt64: Int64; override;
    function GetAsMemo: TStrings; override;
    function GetAsObject: TObject; override;
    function GetAsSingle: Single; override;
    function GetAsString: string; override;
    function GetAsUInt32: UInt32; override;
    function GetAsUInt64: UInt64; override;
    procedure SetAsInt64(AValue: Int64); override;
  public
    // Create/Destroy
    constructor Create; override;
    // Overridden public methods
    function Compare(ASecondCell: TcaCell): TcaCompareResult; override;
  end;

// TcaMemoCell

  TcaMemoCell = class(TcaNonNumericCell)
  private
    // Property fields
    FValue: TStrings;
  protected
    // Overridden from TcaCell
    procedure AssignCellValue(ASourceCell: TcaCell); override;
    // Overridden property methods
    function GetAsBoolean: Boolean; override;
    function GetAsDateTime: TDateTime; override;
    function GetAsDouble: Double; override;
    function GetAsInteger: Integer; override;
    function GetAsInt64: Int64; override;
    function GetAsMemo: TStrings; override;
    function GetAsObject: TObject; override;
    function GetAsSingle: Single; override;
    function GetAsString: string; override;
    function GetAsUInt32: UInt32; override;
    function GetAsUInt64: UInt64; override;
    procedure SetAsMemo(AValue: TStrings); override;
  public
    // Create/Destroy
    constructor Create; override;
    destructor Destroy; override;
    // Overridden public methods
    function Compare(ASecondCell: TcaCell): TcaCompareResult; override;
  end;

// TcaObjectCell

  TcaObjectCell = class(TcaNonNumericCell)
  private
    // Property fields
    FOwnsObject: Boolean;
    FValue: TObject;
    // Property methods
    function GetOwnsObject: Boolean;
    procedure SetOwnsObject(AValue: Boolean);
  protected
    // Overridden from TcaCell
    procedure AssignCellValue(ASourceCell: TcaCell); override;
    // Overridden property methods
    function GetAsBoolean: Boolean; override;
    function GetAsDateTime: TDateTime; override;
    function GetAsDouble: Double; override;
    function GetAsInteger: Integer; override;
    function GetAsInt64: Int64; override;
    function GetAsMemo: TStrings; override;
    function GetAsObject: TObject; override;
    function GetAsSingle: Single; override;
    function GetAsString: string; override;
    function GetAsUInt32: UInt32; override;
    function GetAsUInt64: UInt64; override;
    procedure SetAsObject(AValue: TObject); override;
  public
    // Create/Destroy
    constructor Create; override;
    destructor Destroy; override;
    // Overridden public methods
    function Compare(ASecondCell: TcaCell): TcaCompareResult; override;
    // Properties
    property OwnsObject: Boolean read GetOwnsObject write SetOwnsObject;
  end;

// TcaSingleCell

  TcaSingleCell = class(TcaFloatCell)
  private
    // Property fields
    FValue: Single;
  protected
    // Overridden from TcaCell
    procedure AssignCellValue(ASourceCell: TcaCell); override;
    // Overridden property methods
    function GetAsBoolean: Boolean; override;
    function GetAsDateTime: TDateTime; override;
    function GetAsDouble: Double; override;
    function GetAsInteger: Integer; override;
    function GetAsInt64: Int64; override;
    function GetAsMemo: TStrings; override;
    function GetAsObject: TObject; override;
    function GetAsSingle: Single; override;
    function GetAsString: string; override;
    function GetAsUInt32: UInt32; override;
    function GetAsUInt64: UInt64; override;
    procedure SetAsSingle(AValue: Single); override;
  public
    // Create/Destroy
    constructor Create; override;
    // Overridden public methods
    function Compare(ASecondCell: TcaCell): TcaCompareResult; override;
  end;

// TcaStringCell

  TcaStringCell = class(TcaNonNumericCell)
  private
    // Property fields
    FValue: String;
    FMemo: TStrings;
  protected
    // Overridden from TcaCell
    procedure AssignCellValue(ASourceCell: TcaCell); override;
    // Overridden property methods
    function GetAsBoolean: Boolean; override;
    function GetAsDateTime: TDateTime; override;
    function GetAsDouble: Double; override;
    function GetAsInteger: Integer; override;
    function GetAsInt64: Int64; override;
    function GetAsMemo: TStrings; override;
    function GetAsObject: TObject; override;
    function GetAsSingle: Single; override;
    function GetAsString: string; override;
    function GetAsUInt32: UInt32; override;
    function GetAsUInt64: UInt64; override;
    procedure SetAsString(AValue: string); override;
  public
    // Create/Destroy
    constructor Create; override;
    destructor Destroy; override;
    // Overridden public methods
    function Compare(ASecondCell: TcaCell): TcaCompareResult; override;
  end;

// TcaUInt32Cell

  TcaUInt32Cell = class(TcaOrdinalCell)
  private
    // Property fields
    FValue: UInt32;
  protected
    // Overridden from TcaCell
    procedure AssignCellValue(ASourceCell: TcaCell); override;
    // Overridden property methods
    function GetAsBoolean: Boolean; override;
    function GetAsDateTime: TDateTime; override;
    function GetAsDouble: Double; override;
    function GetAsInteger: Integer; override;
    function GetAsInt64: Int64; override;
    function GetAsMemo: TStrings; override;
    function GetAsObject: TObject; override;
    function GetAsSingle: Single; override;
    function GetAsString: string; override;
    function GetAsUInt32: UInt32; override;
    function GetAsUInt64: UInt64; override;
    procedure SetAsUInt32(AValue: UInt32); override;
  public
    // Create/Destroy
    constructor Create; override;
    // Overridden public methods
    function Compare(ASecondCell: TcaCell): TcaCompareResult; override;
  end;

// TcaUInt64Cell

  TcaUInt64Cell = class(TcaOrdinalCell)
  private
    // Property fields
    FValue: UInt64;
  protected
    // Overridden from TcaCell
    procedure AssignCellValue(ASourceCell: TcaCell); override;
    // Overridden property methods
    function GetAsBoolean: Boolean; override;
    function GetAsDateTime: TDateTime; override;
    function GetAsDouble: Double; override;
    function GetAsInteger: Integer; override;
    function GetAsInt64: Int64; override;
    function GetAsMemo: TStrings; override;
    function GetAsObject: TObject; override;
    function GetAsSingle: Single; override;
    function GetAsString: string; override;
    function GetAsUInt32: UInt32; override;
    function GetAsUInt64: UInt64; override;
    procedure SetAsUInt64(AValue: UInt64); override;
  public
    // Create/Destroy
    constructor Create; override;
    // Overridden public methods
    function Compare(ASecondCell: TcaCell): TcaCompareResult; override;
  end;

implementation

// TcaCell

// Create/Destroy

constructor TcaCell.Create;
begin
  inherited;
  FEmptyMemo := TStringList.Create;
end;

destructor TcaCell.Destroy;
begin
  FEmptyMemo.Free;
  inherited;
end;

// Overridden public methods

function TcaCell.Compare(ASecondCell: TcaCell): TcaCompareResult;
begin
  Result := crEqual;
  if ClassType <> ASecondCell.ClassType then
    raise EcaCellException.Create('Cell types must be of equal type for valid comparison');
end;

// Overridden from TPersistent

procedure TcaCell.Assign(Source: TPersistent);
begin
  if Source is TcaCell then
    AssignCellValue(TcaCell(Source))
  else
    inherited Assign(Source);
end;

  // Public class methods

class function TcaCell.StringToCellType(ACellTypeString: string): TcaCellType;
var
  ACellType: TcaCellType;
begin
  Result := Low(TcaCellType);
  for ACellType := Low(TcaCellType) to High(TcaCellType) do
    begin
      if GetEnumName(TypeInfo(TcaCellType), Ord(ACellType)) = ACellTypeString then
        begin
          Result := ACellType;
          Break;
        end;
    end;
end;

// Protected methods

procedure TcaCell.Changed;
begin
  if Assigned(FOnChange) then FOnChange(Self);
end;

// Virtual property methods

function TcaCell.GetAsBoolean: Boolean;
begin
  Result := Default(Boolean);
end;

function TcaCell.GetAsDateTime: TDateTime;
begin
  Result := Default(TDateTime);
end;

function TcaCell.GetAsDouble: Double;
begin
  Result := Default(Double);
end;

function TcaCell.GetAsInteger: Integer;
begin
  Result := Default(Integer);
end;

function TcaCell.GetAsInt64: Int64;
begin
  Result := Default(Int64);
end;

function TcaCell.GetAsMemo: TStrings;
begin
  Result := nil;
end;

function TcaCell.GetAsObject: TObject;
begin
  Result := nil;
end;

function TcaCell.GetAsSingle: Single;
begin
  Result := Default(Single);
end;

function TcaCell.GetAsString: string;
begin
  Result := Default(string);
end;

function TcaCell.GetAsUInt32: UInt32;
begin
  Result := Default(UInt32);
end;

function TcaCell.GetAsUInt64: UInt64;
begin
  Result := Default(UInt64);
end;

procedure TcaCell.SetAsBoolean(AValue: Boolean);
begin
  Pass;
end;

procedure TcaCell.SetAsDateTime(AValue: TDateTime);
begin
  Pass;
end;

procedure TcaCell.SetAsDouble(AValue: Double);
begin
  Pass;
end;

procedure TcaCell.SetAsInt64(AValue: Int64);
begin
  Pass;
end;

procedure TcaCell.SetAsInteger(AValue: Integer);
begin
  Pass;
end;

procedure TcaCell.SetAsMemo(AValue: TStrings);
begin
  Pass;
end;

procedure TcaCell.SetAsObject(AValue: TObject);
begin
  Pass;
end;

procedure TcaCell.SetAsSingle(AValue: Single);
begin
  Pass;
end;

procedure TcaCell.SetAsString(AValue: string);
begin
  Pass;
end;

procedure TcaCell.SetAsUInt32(AValue: UInt32);
begin
  Pass;
end;

procedure TcaCell.SetAsUInt64(AValue: UInt64);
begin
  Pass;
end;

// TcaBooleanCell

// Create/Destroy

constructor TcaBooleanCell.Create;
begin
  inherited;
  CellType := ctBoolean;
end;

// Overridden public methods

function TcaBooleanCell.Compare(ASecondCell: TcaCell): TcaCompareResult;
begin
  inherited Compare(ASecondCell);
  Result := Utils.CompareBooleans(FValue, ASecondCell.AsBoolean);
end;

// Overridden from TcaCell

procedure TcaBooleanCell.AssignCellValue(ASourceCell: TcaCell);
begin
  FValue := ASourceCell.AsBoolean;
end;

// Overridden property methods

function TcaBooleanCell.GetAsBoolean: Boolean;
begin
  Result := FValue;
end;

function TcaBooleanCell.GetAsDateTime: TDateTime;
begin
  Result := 0;
end;

function TcaBooleanCell.GetAsDouble: Double;
begin
  Result := Ord(FValue);
end;

function TcaBooleanCell.GetAsInteger: Integer;
begin
  Result := Ord(FValue);
end;

function TcaBooleanCell.GetAsInt64: Int64;
begin
  Result := Ord(FValue);
end;

function TcaBooleanCell.GetAsMemo: TStrings;
begin
  Result := EmptyMemo;
end;

function TcaBooleanCell.GetAsObject: TObject;
begin
  Result := nil;
end;

function TcaBooleanCell.GetAsSingle: Single;
begin
  Result := Ord(FValue);
end;

function TcaBooleanCell.GetAsString: string;
begin
  Result := StringUtils.BooleanToString(FValue);
end;

function TcaBooleanCell.GetAsUInt32: UInt32;
begin
  Result := Ord(FValue);
end;

function TcaBooleanCell.GetAsUInt64: UInt64;
begin
  Result := Ord(FValue);
end;

procedure TcaBooleanCell.SetAsBoolean(AValue: Boolean);
begin
  FValue := AValue;
  Changed;
end;

// TcaDateTimeCell

// Create/Destroy

constructor TcaDateTimeCell.Create;
begin
  inherited;
  CellType := ctDateTime;
end;

// Overridden public methods

function TcaDateTimeCell.Compare(ASecondCell: TcaCell): TcaCompareResult;
begin
  inherited Compare(ASecondCell);
  Result := Utils.CompareDateTimes(FValue, ASecondCell.AsDateTime);
end;

// Overridden from TcaCell

procedure TcaDateTimeCell.AssignCellValue(ASourceCell: TcaCell);
begin
  FValue := ASourceCell.AsDateTime;
end;

// Overridden property methods

function TcaDateTimeCell.GetAsBoolean: Boolean;
begin
  Result := not IsZero(FValue);
end;

function TcaDateTimeCell.GetAsDateTime: TDateTime;
begin
  Result := FValue;
end;

function TcaDateTimeCell.GetAsDouble: Double;
begin
  Result := FValue;
end;

function TcaDateTimeCell.GetAsInteger: Integer;
begin
  Result := Trunc(FValue);
end;

function TcaDateTimeCell.GetAsInt64: Int64;
begin
  Result := Trunc(FValue);
end;

function TcaDateTimeCell.GetAsMemo: TStrings;
begin
  Result := EmptyMemo;
end;

function TcaDateTimeCell.GetAsObject: TObject;
begin
  Result := nil;
end;

function TcaDateTimeCell.GetAsSingle: Single;
begin
  Result := Trunc(FValue);
end;

function TcaDateTimeCell.GetAsString: string;
begin
  Result := DateTimeToStr(FValue);
end;

function TcaDateTimeCell.GetAsUInt32: UInt32;
begin
  Result := Trunc(FValue);
end;

function TcaDateTimeCell.GetAsUInt64: UInt64;
begin
  Result := Trunc(FValue);
end;

procedure TcaDateTimeCell.SetAsDateTime(AValue: TDateTime);
begin
  FValue := AValue;
  Changed;
end;

// TcaDoubleCell

// Create/Destroy

constructor TcaDoubleCell.Create;
begin
  inherited;
  CellType := ctDouble;
end;

// Overridden public methods

function TcaDoubleCell.Compare(ASecondCell: TcaCell): TcaCompareResult;
begin
  inherited Compare(ASecondCell);
  Result := Utils.CompareDoubles(FValue, ASecondCell.AsDouble);
end;

// Overridden from TcaCell

procedure TcaDoubleCell.AssignCellValue(ASourceCell: TcaCell);
begin
  FValue := ASourceCell.AsDouble;
end;

// Overridden property methods

function TcaDoubleCell.GetAsBoolean: Boolean;
begin
  Result := not IsZero(FValue);
end;

function TcaDoubleCell.GetAsDateTime: TDateTime;
begin
  Result := FValue;
end;

function TcaDoubleCell.GetAsDouble: Double;
begin
  Result := FValue;
end;

function TcaDoubleCell.GetAsInteger: Integer;
begin
  Result := Round(FValue);
end;

function TcaDoubleCell.GetAsInt64: Int64;
begin
  Result := Round(FValue);
end;

function TcaDoubleCell.GetAsMemo: TStrings;
begin
  Result := EmptyMemo;
end;

function TcaDoubleCell.GetAsObject: TObject;
begin
  Result := nil;
end;

function TcaDoubleCell.GetAsSingle: Single;
begin
  Result := FValue;
end;

function TcaDoubleCell.GetAsString: string;
begin
  Result := FloatToStr(FValue);
end;

function TcaDoubleCell.GetAsUInt32: UInt32;
begin
  Result := Round(FValue);
end;

function TcaDoubleCell.GetAsUInt64: UInt64;
begin
  Result := Round(FValue);
end;

procedure TcaDoubleCell.SetAsDouble(AValue: Double);
begin
  FValue := AValue;
  Changed;
end;

// TcaIntegerCell

// Create/Destroy

constructor TcaIntegerCell.Create;
begin
  inherited;
  CellType := ctInteger;
end;

// Overridden public methods

function TcaIntegerCell.Compare(ASecondCell: TcaCell): TcaCompareResult;
begin
  inherited Compare(ASecondCell);
  Result := Utils.CompareIntegers(FValue, ASecondCell.AsInteger);
end;

// Overridden from TcaCell

procedure TcaIntegerCell.AssignCellValue(ASourceCell: TcaCell);
begin
  FValue := ASourceCell.AsInteger;
end;

// Overridden property methods

function TcaIntegerCell.GetAsBoolean: Boolean;
begin
  Result := FValue <> 0;
end;

function TcaIntegerCell.GetAsDateTime: TDateTime;
begin
  Result := FValue;
end;

function TcaIntegerCell.GetAsDouble: Double;
begin
  Result := FValue;
end;

function TcaIntegerCell.GetAsInteger: Integer;
begin
  Result := FValue;
end;

function TcaIntegerCell.GetAsInt64: Int64;
begin
  Result := FValue;
end;

function TcaIntegerCell.GetAsMemo: TStrings;
begin
  Result := EmptyMemo;
end;

function TcaIntegerCell.GetAsObject: TObject;
begin
  Result := nil;
end;

function TcaIntegerCell.GetAsSingle: Single;
begin
  Result := FValue;
end;

function TcaIntegerCell.GetAsString: string;
begin
  Result := IntToStr(FValue);
end;

function TcaIntegerCell.GetAsUInt32: UInt32;
begin
  Result := FValue;
end;

function TcaIntegerCell.GetAsUInt64: UInt64;
begin
  Result := FValue;
end;

procedure TcaIntegerCell.SetAsInteger(AValue: Integer);
begin
  FValue := AValue;
  Changed;
end;

// TcaInt64Cell

// Create/Destroy

constructor TcaInt64Cell.Create;
begin
  inherited;
  CellType := ctInt64;
end;

// Overridden public methods

function TcaInt64Cell.Compare(ASecondCell: TcaCell): TcaCompareResult;
begin
  inherited Compare(ASecondCell);
  Result := Utils.CompareInt64s(FValue, ASecondCell.AsInt64);
end;

// Overridden from TcaCell

procedure TcaInt64Cell.AssignCellValue(ASourceCell: TcaCell);
begin
  FValue := ASourceCell.AsInt64;
end;

//Overridden property methods;

function TcaInt64Cell.GetAsBoolean: Boolean;
begin
  Result := FValue <> 0;
end;

function TcaInt64Cell.GetAsDateTime: TDateTime;
begin
  Result := FValue;
end;

function TcaInt64Cell.GetAsDouble: Double;
begin
  Result := FValue;
end;

function TcaInt64Cell.GetAsInteger: Integer;
begin
  Result := FValue;
end;

function TcaInt64Cell.GetAsInt64: Int64;
begin
  Result := FValue;
end;

function TcaInt64Cell.GetAsMemo: TStrings;
begin
  Result := EmptyMemo;
end;

function TcaInt64Cell.GetAsObject: TObject;
begin
  Result := nil;
end;

function TcaInt64Cell.GetAsSingle: Single;
begin
  Result := FValue;
end;

function TcaInt64Cell.GetAsString: string;
begin
  Result := IntToStr(FValue);
end;

function TcaInt64Cell.GetAsUInt32: UInt32;
begin
  Result := FValue;
end;

function TcaInt64Cell.GetAsUInt64: UInt64;
begin
  Result := FValue;
end;

procedure TcaInt64Cell.SetAsInt64(AValue: Int64);
begin
  FValue := AValue;
  Changed;
end;

// TcaMemoCell

// Create/Destroy

constructor TcaMemoCell.Create;
begin
  inherited;
  CellType := ctMemo;
  FValue := TStringList.Create;
end;

destructor TcaMemoCell.Destroy;
begin
  FValue.Free;
  inherited;
end;

// Overridden public methods

function TcaMemoCell.Compare(ASecondCell: TcaCell): TcaCompareResult;
begin
  inherited Compare(ASecondCell);
  Result := Utils.CompareMemos(FValue, ASecondCell.AsMemo);
end;

// Overridden from TcaCell

procedure TcaMemoCell.AssignCellValue(ASourceCell: TcaCell);
begin
  FValue := ASourceCell.AsMemo;
end;

// Overridden property methods

function TcaMemoCell.GetAsBoolean: Boolean;
begin
  Result := FValue.Text <> '';
end;

function TcaMemoCell.GetAsDateTime: TDateTime;
begin
  Result := 0;
end;

function TcaMemoCell.GetAsDouble: Double;
begin
  Result := 0;
end;

function TcaMemoCell.GetAsInteger: Integer;
begin
  Result := 0;
end;

function TcaMemoCell.GetAsInt64: Int64;
begin
  Result := 0;
end;

function TcaMemoCell.GetAsMemo: TStrings;
begin
  Result := FValue;
end;

function TcaMemoCell.GetAsObject: TObject;
begin
  Result := FValue;
end;

function TcaMemoCell.GetAsSingle: Single;
begin
  Result := 0;
end;

function TcaMemoCell.GetAsString: string;
begin
  Result := FValue.Text;
end;

function TcaMemoCell.GetAsUInt32: UInt32;
begin
  Result := 0;
end;

function TcaMemoCell.GetAsUInt64: UInt64;
begin
  Result := 0;
end;

procedure TcaMemoCell.SetAsMemo(AValue: TStrings);
begin
  FValue := AValue;
  Changed;
end;

// TcaObjectCell

// Create/Destroy

constructor TcaObjectCell.Create;
begin
  inherited;
  CellType := ctObject;
end;

destructor TcaObjectCell.Destroy;
begin
  if FOwnsObject then FValue.Free;
  inherited;
end;

// Overridden public methods

function TcaObjectCell.Compare(ASecondCell: TcaCell): TcaCompareResult;
begin
  inherited Compare(ASecondCell);
  Result := Utils.CompareObjects(FValue, ASecondCell.AsObject);
end;

// Overridden property methods

function TcaObjectCell.GetAsBoolean: Boolean;
begin
  Result := FValue <> nil;
end;

function TcaObjectCell.GetAsDateTime: TDateTime;
begin
  Result := 0;
end;

function TcaObjectCell.GetAsDouble: Double;
begin
  Result := 0;
end;

function TcaObjectCell.GetAsInteger: Integer;
begin
  Result := 0;
end;

function TcaObjectCell.GetAsInt64: Int64;
begin
  Result := 0;
end;

function TcaObjectCell.GetAsMemo: TStrings;
begin
  { TODO : Maybe populate with property info once Rtti is working }
  if FValue is TStrings then
    Result := TStrings(FValue)
  else
    Result := EmptyMemo;
end;

function TcaObjectCell.GetAsObject: TObject;
begin
  Result := FValue;
end;

function TcaObjectCell.GetAsSingle: Single;
begin
  Result := 0;
end;

function TcaObjectCell.GetAsString: string;
//var
//  Addr: UInt64;
begin
  //if SizeOf(Integer) = SizeOf(Pointer) then
  //  begin
  //    {%H-}Addr := Utils.PtrToUInt(FValue);
  //    Result := FValue.ClassName + ': ' + Format('$%8x', [Addr]);
  //  end
  //else
    Result := '';
end;

function TcaObjectCell.GetAsUInt32: UInt32;
begin
  Result := 0;
end;

function TcaObjectCell.GetAsUInt64: UInt64;
begin
  Result := 0;
end;

procedure TcaObjectCell.SetAsObject(AValue: TObject);
begin
  FValue := AValue;
  Changed;
end;

// Property methods

function TcaObjectCell.GetOwnsObject: Boolean;
begin
  Result := FOwnsObject;
end;

procedure TcaObjectCell.SetOwnsObject(AValue: Boolean);
begin
  FOwnsObject := AValue;
end;

// TcaSingleCell

// Create/Destroy

constructor TcaSingleCell.Create;
begin
  inherited;
  CellType := ctSingle;
end;

// Overridden public methods

function TcaSingleCell.Compare(ASecondCell: TcaCell): TcaCompareResult;
begin
  inherited Compare(ASecondCell);
  Result := Utils.CompareSingles(FValue, ASecondCell.AsSingle);
end;

// Overridden from TcaCell

procedure TcaObjectCell.AssignCellValue(ASourceCell: TcaCell);
begin
  FValue := ASourceCell.AsObject;
end;

// Overridden from TcaCell

procedure TcaSingleCell.AssignCellValue(ASourceCell: TcaCell);
begin
  FValue := ASourceCell.AsSingle;
end;

// Overridden property methods

function TcaSingleCell.GetAsBoolean: Boolean;
begin
  Result := not IsZero(FValue);
end;

function TcaSingleCell.GetAsDateTime: TDateTime;
begin
  Result := FValue;
end;

function TcaSingleCell.GetAsDouble: Double;
begin
  Result := FValue;
end;

function TcaSingleCell.GetAsInteger: Integer;
begin
  Result := Round(FValue);
end;

function TcaSingleCell.GetAsInt64: Int64;
begin
  Result := Round(FValue);
end;

function TcaSingleCell.GetAsMemo: TStrings;
begin
  Result := EmptyMemo;
end;

function TcaSingleCell.GetAsObject: TObject;
begin
  Result := nil;
end;

function TcaSingleCell.GetAsSingle: Single;
begin
  Result := FValue;
end;

function TcaSingleCell.GetAsString: string;
begin
  Result := FloatToStr(FValue);
end;

function TcaSingleCell.GetAsUInt32: UInt32;
begin
  Result := Round(FValue);
end;

function TcaSingleCell.GetAsUInt64: UInt64;
begin
  Result := Round(FValue);
end;

procedure TcaSingleCell.SetAsSingle(AValue: Single);
begin
  FValue := AValue;
  Changed;
end;

// TcaStringCell

// Create/Destroy

constructor TcaStringCell.Create;
begin
 inherited;
 CellType := ctString;
 FMemo := TStringList.Create;
end;

destructor TcaStringCell.Destroy;
begin
 FMemo.Free;
 inherited;
end;

// Overridden public methods

function TcaStringCell.Compare(ASecondCell: TcaCell): TcaCompareResult;
begin
  inherited Compare(ASecondCell);
  Result := Utils.CompareStrings(FValue, ASecondCell.AsString);
end;

// Overridden from TcaCell

procedure TcaStringCell.AssignCellValue(ASourceCell: TcaCell);
begin
  FValue := ASourceCell.AsString;
end;

// Overridden property methods

function TcaStringCell.GetAsBoolean: Boolean;
begin
  Result := StringUtils.StringToBoolean(FValue);
end;

function TcaStringCell.GetAsDateTime: TDateTime;
begin
  Result := StrToDateTime(FValue);
end;

function TcaStringCell.GetAsDouble: Double;
begin
  Result := StrToFloat(FValue);
end;

function TcaStringCell.GetAsInteger: Integer;
begin
  Result := StrToInt(FValue);
end;

function TcaStringCell.GetAsInt64: Int64;
begin
  Result := StrToInt64(FValue);
end;

function TcaStringCell.GetAsMemo: TStrings;
begin
  FMemo.Text := FValue;
  Result := FMemo;
end;

function TcaStringCell.GetAsObject: TObject;
begin
  Result := nil;
end;

function TcaStringCell.GetAsSingle: Single;
begin
  Result := StrToFloat(FValue);
end;

function TcaStringCell.GetAsString: string;
begin
  Result := FValue;
end;

function TcaStringCell.GetAsUInt32: UInt32;
begin
  Result := StrToInt64(FValue);
end;

function TcaStringCell.GetAsUInt64: UInt64;
begin
  Result := StrToInt64(FValue);
end;

procedure TcaStringCell.SetAsString(AValue: string);
begin
  FValue := AValue;
  Changed;
end;

// TcaUInt32Cell

// Create/Destroy

constructor TcaUInt32Cell.Create;
begin
  inherited;
  CellType := ctUInt32;
end;

// Overridden public methods

function TcaUInt32Cell.Compare(ASecondCell: TcaCell): TcaCompareResult;
begin
  inherited Compare(ASecondCell);
  Result := Utils.CompareUInt32s(FValue, ASecondCell.AsUInt32);
end;

// Overridden from TcaCell

procedure TcaUInt32Cell.AssignCellValue(ASourceCell: TcaCell);
begin
  FValue := ASourceCell.AsUInt32;
end;

// Overridden property methods

function TcaUInt32Cell.GetAsBoolean: Boolean;
begin
  Result := FValue <> 0;
end;

function TcaUInt32Cell.GetAsDateTime: TDateTime;
begin
  Result := FValue;
end;

function TcaUInt32Cell.GetAsDouble: Double;
begin
  Result := FValue;
end;

function TcaUInt32Cell.GetAsInteger: Integer;
begin
  Result := FValue;
end;

function TcaUInt32Cell.GetAsInt64: Int64;
begin
  Result := FValue;
end;

function TcaUInt32Cell.GetAsMemo: TStrings;
begin
  Result := EmptyMemo;
end;

function TcaUInt32Cell.GetAsObject: TObject;
begin
  Result := nil;
end;

function TcaUInt32Cell.GetAsSingle: Single;
begin
  Result := FValue;
end;

function TcaUInt32Cell.GetAsString: string;
begin
  Result := IntToStr(FValue);
end;

function TcaUInt32Cell.GetAsUInt32: UInt32;
begin
  Result := FValue;
end;

function TcaUInt32Cell.GetAsUInt64: UInt64;
begin
  Result := FValue;
end;

procedure TcaUInt32Cell.SetAsUInt32(AValue: UInt32);
begin
  FValue := AValue;
  Changed;
end;

// TcaUInt64Cell

// Create/Destroy

constructor TcaUInt64Cell.Create;
begin
  inherited;
  CellType := ctUInt64;
end;

// Overridden public methods

function TcaUInt64Cell.Compare(ASecondCell: TcaCell): TcaCompareResult;
begin
  inherited Compare(ASecondCell);
  Result := Utils.CompareUInt64s(FValue, ASecondCell.AsUInt64);
end;

// Overridden from TcaCell

procedure TcaUInt64Cell.AssignCellValue(ASourceCell: TcaCell);
begin
  FValue := ASourceCell.AsUInt64;
end;

// Overridden property methods

function TcaUInt64Cell.GetAsBoolean: Boolean;
begin
  Result := FValue <> 0;
end;

function TcaUInt64Cell.GetAsDateTime: TDateTime;
begin
  Result := FValue;
end;

function TcaUInt64Cell.GetAsDouble: Double;
begin
  Result := FValue;
end;

function TcaUInt64Cell.GetAsInteger: Integer;
begin
  Result := FValue;
end;

function TcaUInt64Cell.GetAsInt64: Int64;
begin
  Result := FValue;
end;

function TcaUInt64Cell.GetAsMemo: TStrings;
begin
  Result := EmptyMemo;
end;

function TcaUInt64Cell.GetAsObject: TObject;
begin
  Result := nil;
end;

function TcaUInt64Cell.GetAsSingle: Single;
begin
  Result := FValue;
end;

function TcaUInt64Cell.GetAsString: string;
begin
  Result := IntToStr(FValue);
end;

function TcaUInt64Cell.GetAsUInt32: UInt32;
begin
  Result := FValue;
end;

function TcaUInt64Cell.GetAsUInt64: UInt64;
begin
  Result := FValue;
end;

procedure TcaUInt64Cell.SetAsUInt64(AValue: UInt64);
begin
  FValue := AValue;
  Changed;
end;

end.
