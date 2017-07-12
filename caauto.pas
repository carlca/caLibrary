unit caauto;

// {$mode objfpc}
{$ifdef fpc}{$mode delphi}{$endif}
{$H+}

interface

type

  Auto<T: class, constructor> = record
  strict private
    FValue:T;
    FFreeValue: IInterface;
    function GetValue: T;
    type
      TFreeValue = class(TInterfacedObject)
      private
        FObjectToFree: TObject;
      public
        constructor Create(AObjectToFree: TObject);
        destructor Destroy; override;
      end;
  public
    constructor Create(AValue: T); overload;
    procedure Create; overload;
    class operator Implicit(AValue: T): Auto<T>;
    class operator Implicit(Smart: Auto<T>): T;
    property value: T read GetValue;
  end;

implementation

constructor Auto<T>.TFreeValue.Create(AObjectToFree: TObject);
begin
  FObjectToFree := AObjectToFree;
end;

destructor Auto<T>.TFreeValue.Destroy;
begin
  FObjectToFree.Free;
  inherited;
end;

constructor Auto<T>.Create(AValue: T);
begin
  FValue := AValue;
  FFreeValue := TFreeValue.Create(FValue);
end;

procedure Auto<T>.Create;
begin
  Auto<T>.Create(T.Create);
end;

class operator Auto<T>.Implicit(AValue: T): Auto<T>;
begin
  Result := Auto<T>.Create(AValue);
end;

class operator Auto<T>.Implicit(smart: Auto<T>): T;
begin
  Result := Smart.Value;
end;

function Auto<T>.GetValue:T;
begin
  if not Assigned(FFreeValue) then
    Self := Auto<T>.Create(T.Create);
  Result := FValue;
end;

end.
