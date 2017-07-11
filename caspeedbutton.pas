unit caspeedbutton;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Controls, ExtCtrls, Graphics, Buttons;

type

  { TcaSpeedButton }

  TcaSpeedButton = class(TSpeedButton)
  private
  protected
    procedure Paint; override;
    procedure PaintBackground(var PaintRect: TRect); override;
  public
  end;

implementation

{ TcaSpeedButton }

procedure TcaSpeedButton.Paint;
begin
  inherited Paint;
end;

procedure TcaSpeedButton.PaintBackground(var PaintRect: TRect);
begin
  inherited PaintBackground(PaintRect);
  Canvas.Brush.Color := clBlue;
  Canvas.FloodFill(PaintRect.Left, PaintRect.Top, clBlue, fsBorder); // FillRect(PaintRect);
end;

end.

