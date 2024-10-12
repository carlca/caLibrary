unit caHelper;

//{$if fpc_fullversion < 30301}{$error this program needs trunk}{$endif}
{$mode objfpc}{$H+}
{$modeswitch typehelpers}
{$modeswitch multihelpers}

interface

uses
  Classes, SysUtils, TypInfo;

type

  TcaIntegerHelper = type helper for Integer
  public
    function Pred: Integer;
  end;

  TcaInt64Helper = type helper for int64
  public
    function Pred: int64;
  end;

  TcaShiftStateHelper = type helper for TShiftState
  private
    function ShiftToString(shift: TShiftState): string;
  public
    function ToString: string;
  end;

implementation

// TcaIntegerHelper

function TcaIntegerHelper.Pred: Integer;
begin
  Result := Self - 1;
end;

// TcaInt64Helper

function TcaInt64Helper.Pred: int64;
begin
  Result := Self - 1;
end;

// TcaShiftStateHelper

function TcaShiftStateHelper.ShiftToString(shift: TShiftState): string;
var
  EnumType: PTypeInfo;
  EnumValue: Integer;
  Parts: TStringList;
begin
  EnumType := TypeInfo(TShiftStateEnum);
  Parts := TStringList.Create;
  try
    for EnumValue := 0 to Ord(High(TShiftStateEnum)) do
    begin
      if TShiftStateEnum(EnumValue) in Shift then
      begin
        Parts.Add(GetEnumName(EnumType, EnumValue));
      end;
    end;
    Result := Parts.CommaText;
  finally
    Parts.Free;
  end;
end;

function TcaShiftStateHelper.ToString: string;
begin
  Result := ShiftToString(Self);
end;


end.
