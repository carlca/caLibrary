unit caLibraryReg;

{$mode objfpc}{$H+}

interface

procedure Register;

implementation

uses

  // FPC units
  Classes,

  // caLibrary units
  caEdit;

procedure Register;
begin
  RegisterComponents('caControls', [TcaEdit]);
end;

initialization
  //{$include calibrary.lrs}

end.

