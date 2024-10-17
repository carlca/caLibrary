{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit calibrarydsgn;

{$warn 5023 off : no warning about unused units}
interface

uses
  caLibraryReg, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('caLibraryReg',@caLibraryReg.Register);
end;

initialization
  RegisterPackage('calibrarydsgn',@Register);
end.
