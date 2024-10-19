unit udebugtest;

{$mode objfpc}{$H+}

interface

uses
  Classes, StdCtrls,SysUtils, Forms, Controls, Graphics, Dialogs;

type
  TForm1 = class(TForm)
    Button1:TButton;
    procedure Button1Click(Sender:TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

procedure TForm1.Button1Click(Sender:TObject);
begin
  ShowMessage('Click');
end;

end.

