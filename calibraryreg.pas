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

unit caLibraryReg;

{$mode objfpc}{$H+}

interface

procedure Register;

implementation

uses

// FPC units
  Classes,
  LResources,

// caLibrary units
  caControls,
  caMatrix,
  caMatrixTools,
  caSizeMovePanel,
  cargbspinedit,
  caListBox,
  cafontselector,
  caspeedbutton;

procedure Register;
begin
{$IFDEF WINDOWS}
  RegisterClass(TcaSizeMoveButtonItem);
  RegisterClass(TcaSizeMoveButtonCollection);
{$ENDIF}

  RegisterComponents('caControls', [TcaPanel]);
  RegisterComponents('caControls', [TcaFormPanel]);
  RegisterComponents('caControls', [TcaRGBSpinEdit]);
  RegisterComponents('caControls', [TcaFontSelector]);
  RegisterComponents('caControls', [TcaSpeedButton]);

{$IFDEF WINDOWS}
  RegisterComponents('caControls', [TcaSizeMovePanel]);
  RegisterComponents('caControls', [TcaListBox]);
{$ENDIF}

  RegisterComponents('caMatrix', [TcaMatrix]);
  RegisterComponents('caMatrix', [TcaBooleanMatrix]);
  RegisterComponents('caMatrix', [TcaDateTimeMatrix]);
  { TODO : Finish doing the component glyphs }
  RegisterComponents('caMatrix', [TcaDoubleMatrix]);
  RegisterComponents('caMatrix', [TcaIntegerMatrix]);
  RegisterComponents('caMatrix', [TcaInt64Matrix]);
  RegisterComponents('caMatrix', [TcaMemoMatrix]);
  RegisterComponents('caMatrix', [TcaObjectMatrix]);
  RegisterComponents('caMatrix', [TcaSingleMatrix]);
  RegisterComponents('caMatrix', [TcaStringMatrix]);
  RegisterComponents('caMatrix', [TcaUInt32Matrix]);
  RegisterComponents('caMatrix', [TcaUInt64Matrix]);
  RegisterComponents('caMatrix', [TcaMatrixTools]);
end;

initialization
  {$include calibrary.lrs}

end.

