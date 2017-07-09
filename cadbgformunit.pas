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

unit cadbgformunit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ComCtrls, Types, caunicodestringlist;

type

  { TcaDbgForm }

  TcaDbgForm = class(TForm)
    List: TListView;
    procedure ListData(Sender: TObject; Item: TListItem);
  private
    { private declarations }
    FData: TcaUnicodeStringList;
  public
    { public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Add(const S: string);
    procedure Clear;
  end;

var
  DbgForm: TcaDbgForm;

implementation

{$R *.lfm}

{ TcaDbgForm }

constructor TcaDbgForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FData := TcaUnicodeStringList.Create;
end;

destructor TcaDbgForm.Destroy;
begin
  FData.Free;
  inherited Destroy;
end;

procedure TcaDbgForm.Add(const S: string);
var
  I: Integer;
  DbgS: UnicodeString;
begin
  if S = '-' then
    begin
      DbgS := '';
      for I := 1 to 200 do
        DbgS := DbgS + UnicodeChar($2500); // '─';
    end
  else
    DbgS := S;
  FData.Add(DbgS);
  List.Items.Count := FData.Count;
end;

procedure TcaDbgForm.ListData(Sender: TObject; Item: TListItem);
var
  ListIndex: Integer;
begin
  ListIndex := Pred(FData.Count) - Item.Index;
  Item.Caption := FData[ListIndex];
end;

procedure TcaDbgForm.Clear;
begin
  FData.Clear;
  List.Clear;
end;

end.

