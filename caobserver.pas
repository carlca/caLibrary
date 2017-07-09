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

unit caObserver;

{$mode objfpc}{$H+}

interface

uses
  // FPC units
  Classes, SysUtils,

  // caLibrary units
  caTypes;

type

  IcaObserver = interface
  ['{13C57F0C-12D1-4AEC-B534-31E4EDC1D25F}']
    procedure Update(AMessage: TcaSubjectMessage);
  end;

  // TcaObserver = class(TInterfacedObject, IcaObserver)
  // protected
  //   // Protected methods
  //   procedure Update(Subject: TObject);
  // end;

  IcaSubject = interface
  ['{58D6255A-DA8E-4163-9703-1E9604619821}']
    function GetMessage: TcaSubjectMessage;
    procedure Attach(Observer: IcaObserver);
    procedure Detach(Observer: IcaObserver);
    procedure Notify;
    property Message: TcaSubjectMessage read GetMessage;
  end;

  { TcaSubject }

  TcaSubject = class(TInterfacedObject, IcaSubject)
  private
    // Private members
    FMessage: TcaSubjectMessage;
    FObservers: TInterfaceList;
    // Property methods
    function GetMessage: TcaSubjectMessage;
  protected
    // Protected methods
    procedure Attach(Observer: IcaObserver);
    procedure Detach(Observer: IcaObserver);
    procedure Notify;
  public
    // Create/Destroy
    constructor Create(AMessage: TcaSubjectMessage);
    destructor Destroy; override;
    // Public properties
    property Message: TcaSubjectMessage read GetMessage;
  end;

implementation

// TcaObserver

// Protected methods

// procedure TcaObserver.Update(Subject: TObject);
// begin
// end;

// TcaSubject

// Create/Destroy

constructor TcaSubject.Create(AMessage: TcaSubjectMessage);
begin
  inherited Create;
  FMessage := AMessage;
  FObservers := TInterfaceList.Create;
end;

destructor TcaSubject.Destroy;
begin
  FreeAndNil(FObservers);
  inherited Destroy;
end;

// Protected methods

procedure TcaSubject.Attach(Observer: IcaObserver);
begin
  if FObservers.IndexOf(Observer) = -1 then
    FObservers.Add(Observer);
end;

procedure TcaSubject.Detach(Observer: IcaObserver);
begin
  if FObservers.IndexOf(Observer) >= 0 then
    FObservers.Remove(Observer);
end;

procedure TcaSubject.Notify;
var
  Index: Integer;
begin
  for Index := 0 to Pred(FObservers.Count) do
    IcaObserver(FObservers[Index]).Update(FMessage);
end;

// Property methods

function TcaSubject.GetMessage: TcaSubjectMessage;
begin
  Result := FMessage;
end;

end.

