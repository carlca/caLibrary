unit cahint;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics;

type

  { TcaHint }

  TcaHint = class(THintWindow)
  public
    constructor Create(AOwner: TComponent); override;
    function CalcHintRect(MaxWidth: Integer; const AHint: String; AData: Pointer): TRect; override;
  end;

implementation

{ TcaHint }

constructor TcaHint.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Canvas.Font.Name := 'Lucida Grande';
  Canvas.Font.Size := 8;
end;

function TcaHint.CalcHintRect(MaxWidth: Integer; const AHint: String;
  AData: Pointer): TRect;
begin
  MaxWidth := Canvas.TextWidth(AHint);
  Result := inherited CalcHintRect(MaxWidth, AHint, AData);
  Result.Bottom := Result.Top + 20;
end;

end.

