{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit caLibrary;

{$warn 5023 off : no warning about unused units}
interface

uses
  caCell, caCellManager, caClasses, caConsts, caControls, caMatrix, 
  caMatrixTools, caParser, caRtti, caSparseMatrix, caUtils, caXmlReader, 
  caSizeMovePanel, caTypes, caXmlWriter, caMathVector, caLibraryReg, 
  caListBox, caObserver, caVector, caDbg, cajsonconfig, cargbspinedit, 
  cadbgintf, cadbgformunit, caunicodestringlist, cafontselector, 
  caspeedbutton, cafontselectorlist, cahint, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('caLibraryReg', @caLibraryReg.Register);
end;

initialization
  RegisterPackage('caLibrary', @Register);
end.
