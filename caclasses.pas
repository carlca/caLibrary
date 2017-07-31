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

unit caClasses;

{$mode objfpc}{$H+}

interface

uses

// FPC units
  Classes,
  SysUtils,
  Controls;

type

// EcaException

  EcaException = class(Exception);

// EcaClassException

  EcaClassException = class(EcaException);

// TcaAddComponentEvent

  TcaAddComponentEvent = procedure(Sender: TObject; AComponent: TComponent; var AAccept: Boolean) of object;

  // TcaAddControlEvent

    TcaAddControlEvent = procedure(Sender: TObject; AControl: TControl; var AAccept: Boolean) of object;

// IcaString

  IcaString = interface
  ['{5BA56AF4-02C8-4904-ADB1-054788AF0773}']
    // Property methods 
    function GetCh(N: Integer): Char;
    function GetS: string;
    procedure SetCh(N: Integer; AValue: Char);
    procedure SetS(const AValue: string);
    // Interface methods
    function CleanIntString: string;
    function CleanNumString: string;
    function DeleteFromEnd(N: Integer): string;
    function DeleteFromStart(N: Integer): string;
    function EndsWith(const AValue: string): Boolean;
    function Indent(N: Integer): string;
    function IsIntChar(N: Integer): Boolean;
    function IsFloatChar(N: Integer): Boolean;
    function Left(N: Integer): string;
    function Length: Integer;
    function LowerCase: string;
    function Mid(N, ForN: Integer): string;
    function PadLeft(ALength: Integer): string;
    function PadRight(ALength: Integer): string;
    function PosFromEnd(const AFindStr: string): Integer;
    function PosFromStart(const AFindStr: string): Integer;
    function PreZero(ALength: Integer): string;
    function Replace(const AOldPattern, ANewPattern: string): string;
    function Reverse: string;
    function Right(N: Integer): string;
    function SplitCamelCaps: string;
    function StripChar(C: Char): string;
    function Str2Float(Default: Extended): Extended;
    function Str2Int(Default: Integer): Integer;
    function UpperCase: string;
    procedure Add(const AValue: string);
    // Properties
    property Ch[N: Integer]: Char read GetCh write SetCh; default;
    property S: string read GetS write SetS;
  end;

// TcaString

  TcaString = class(TInterfacedObject, IcaString)
  private
    // Property fields 
    FS: string;
    // Property methods 
    function GetCh(N: Integer): Char;
    function GetS: string;
    procedure SetCh(N: Integer; AValue: Char);
    procedure SetS(const AValue: string);
  public
    // Create/Destroy
    constructor Create(AString: string); overload;
    constructor Create(AInteger: Integer); overload;
    // Interface methods
    function CleanIntString: string;
    function CleanNumString: string;
    function DeleteFromEnd(N: Integer): string;
    function DeleteFromStart(N: Integer): string;
    function EndsWith(const AValue: string): Boolean;
    function Indent(N: Integer): string;
    function IsIntChar(N: Integer): Boolean;
    function IsFloatChar(N: Integer): Boolean;
    function Left(N: Integer): string;
    function Length: Integer;
    function LowerCase: string;
    function Mid(N, ForN: Integer): string;
    function PadLeft(ALength: Integer): string;
    function PadRight(ALength: Integer): string;
    function PosFromEnd(const AFindStr: string): Integer;
    function PosFromStart(const AFindStr: string): Integer;
    function PreZero(ALength: Integer): string;
    function Replace(const AOldPattern, ANewPattern: string): string;
    function Reverse: string;
    function Right(N: Integer): string;
    function SplitCamelCaps: string;
    function StripChar(C: Char): string;
    function Str2Float(Default: Extended): Extended;
    function Str2Int(Default: Integer): Integer;
    function UpperCase: string;
    procedure Add(const AValue: string);
    // Properties
    property Ch[N: Integer]: Char read GetCh write SetCh; default;
    property S: string read GetS write SetS;
  end;

// IcaByteString

  IcaByteString = interface
  ['{822C1C95-B6DA-4DC7-A58B-786EC33777FE}']
    // Property methods 
    function GetAsString: string;
    function GetByte(Index: Integer): Byte;
    function GetCount: Integer;
    procedure SetAsString(const AValue: string);
    procedure SetByte(Index: Integer; const AValue: Byte);
    procedure SetCount(const AValue: Integer);
    // Interface methods 
    procedure Clear;
    // Properties 
    property AsString: string read GetAsString write SetAsString;
    property Bytes[Index: Integer]: Byte read GetByte write SetByte;
    property Count: Integer read GetCount write SetCount;
  end;

// TcaByteString

  TcaByteString = class(TcaString, IcaByteString)
  private
    // Property methods 
    function GetAsString: string;
    function GetByte(Index: Integer): Byte;
    function GetCount: Integer;
    procedure SetAsString(const AValue: string);
    procedure SetByte(Index: Integer; const AValue: Byte);
    procedure SetCount(const AValue: Integer);
    // Private methods 
    function ByteToStr(AByte: Byte): string;
    procedure CheckIndex(Index: Integer);
    procedure GetAsStrings(AStrings: TStrings);
    procedure SetAsStrings(AStrings: TStrings);
  public
    // Create/Destroy 
    constructor Create(ACount: Integer); overload;
    // Public methods 
    procedure Clear;
    // Properties 
    property AsString: string read GetAsString write SetAsString;
    property Bytes[Index: Integer]: Byte read GetByte write SetByte;
    property Count: Integer read GetCount write SetCount;
  end;

// TcaStringStack

  TcaStringStack = class(TObject)
  private
    // Private fields
    FLines: TStrings;
  public
    // Create/Destroy
    constructor Create; overload;
    constructor Create(const AString: string); overload;
    constructor Create(AStrings: TStrings); overload;
    destructor Destroy; override;
    // Public methods
    function HasItems: Boolean;
    function IsEmpty: Boolean;
    function Peek: string;
    function Pop: string;
    function Push(const AItem: string): Integer;
    function Size: Integer;
  end;

  // TcaOwnedComponents

  TcaOwnedComponents = class(TObject)
  private
    // private fields 
    FComponents: TList;
    FOnAddComponent: TcaAddComponentEvent;
    FRootComponent: TComponent;
    // property methods 
    function GetComponent(Index: Integer): TComponent;
    function GetCount: Integer;
    // private methods 
    procedure AddComponents;
    procedure AddComponents_Recursed(AComponent: TComponent);
  protected
    // protected methods 
    procedure DoAddComponent(AComponent: TComponent; var AAccept: Boolean); virtual;
  public
    // create/destroy 
    constructor Create(ARootComponent: TComponent);
    destructor Destroy; override;
    // properties 
    property Components[Index: Integer]: TComponent read GetComponent;
    property Count: Integer read GetCount;
    // event properties 
    property OnAddComponent: TcaAddComponentEvent read FOnAddComponent write FOnAddComponent;
  end;

  // TcaParentedControls

  TcaParentedControls = class(TObject)
  private
    // private fields 
    FControls: TList;
    FOnAddControl: TcaAddControlEvent;
    FRootControl: TWinControl;
    // property methods 
    function GetControl(Index: Integer): TControl;
    function GetCount: Integer;
    // private methods 
    procedure AddControls;
    procedure AddControls_Recursed(AControl: TWinControl);
  protected
    // protected methods 
    procedure DoAddControl(AControl: TWinControl; var AAccept: Boolean); virtual;
  public
    // create/destroy 
    constructor Create(ARootControl: TWinControl);
    destructor Destroy; override;
    // properties 
    property Controls[Index: Integer]: TControl read GetControl;
    property Count: Integer read GetCount;
    // event properties 
    property OnAddControl: TcaAddControlEvent read FOnAddControl write FOnAddControl;
  end;

implementation

uses
// caLibrary units
  caUtils;

// TcaString

// Create/Destroy

constructor TcaString.Create(AString: string);
begin
  inherited Create;
  FS := AString;
end;

constructor TcaString.Create(AInteger: Integer);
begin
  inherited Create;
  FS := IntToStr(AInteger);
end;

// Interface methods 

function TcaString.CleanIntString: string;
begin
  Result := StringUtils.CleanIntString(FS);
end;

function TcaString.CleanNumString: string;
begin
  Result := StringUtils.CleanNumString(FS);
end;

function TcaString.DeleteFromEnd(N: Integer): string;
begin
  Result := StringUtils.DeleteFromEnd(FS, N);
end;

function TcaString.DeleteFromStart(N: Integer): string;
begin
  Result := StringUtils.DeleteFromStart(FS, N);
end;

function TcaString.EndsWith(const AValue: string): Boolean;
begin
  Result := StringUtils.EndsWith(FS, AValue);
end;

function TcaString.Indent(N: Integer): string;
begin
  Result := StringUtils.Indent(FS, N);
end;

function TcaString.IsIntChar(N: Integer): Boolean;
begin
  Result := StringUtils.IsIntChar(FS, N);
end;

function TcaString.IsFloatChar(N: Integer): Boolean;
begin
  Result := StringUtils.IsFloatChar(FS, N);
end;

function TcaString.Left(N: Integer): string;
begin
  Result := StringUtils.Left(FS, N);
end;

function TcaString.Length: Integer;
begin
  Result := StringUtils.Length(FS);
end;

function TcaString.LowerCase: string;
begin
  Result := StringUtils.LowerCase(FS);
end;

function TcaString.Mid(N, ForN: Integer): string;
begin
  Result := StringUtils.Mid(FS, N, ForN);
end;

function TcaString.PadLeft(ALength: Integer): string;
begin
  Result := StringUtils.PadLeft(FS, #32, ALength);
end;

function TcaString.PadRight(ALength: Integer): string;
begin
  Result := StringUtils.PadRight(FS, #32, ALength);
end;

function TcaString.PosFromEnd(const AFindStr: string): Integer;
begin
  Result := StringUtils.PosFromEnd(FS, AFindStr);
end;

function TcaString.PosFromStart(const AFindStr: string): Integer;
begin
  Result := StringUtils.PosFromStart(FS, AFindStr);
end;

function TcaString.PreZero(ALength: Integer): string;
begin
  Result := StringUtils.PreZero(FS, ALength);
end;

function TcaString.Replace(const AOldPattern, ANewPattern: string): string;
begin
  Result := StringUtils.Replace(FS, AOldPattern, ANewPattern);
end;

function TcaString.Reverse: string;
begin
  Result := StringUtils.Reverse(FS);
end;

function TcaString.Right(N: Integer): string;
begin
  Result := StringUtils.Right(FS, N);
end;

function TcaString.SplitCamelCaps: string;
begin
  Result := StringUtils.SplitCamelCaps(FS);
end;

function TcaString.StripChar(C: Char): string;
begin
  Result := StringUtils.StripChar(FS, C);
end;

function TcaString.Str2Float(Default: Extended): Extended;
begin
  Result := StringUtils.Str2Float(FS, Default);
end;

function TcaString.Str2Int(Default: Integer): Integer;
begin
  Result := StringUtils.Str2Int(FS, Default);
end;

function TcaString.UpperCase: string;
begin
  Result := StringUtils.UpperCase(FS);
end;

procedure TcaString.Add(const AValue: string);
begin
  FS := StringUtils.Add(FS, AValue);
end;

// Property methods

function TcaString.GetCh(N: Integer): Char;
begin
  Result := #0;
  if N in [1..Self.Length] then
    Result := FS[N];
end;

function TcaString.GetS: string;
begin
  Result := FS;
end;

procedure TcaString.SetCh(N: Integer; AValue: Char);
begin
  if N in [1..Self.Length] then
    FS[N] := AValue;
end;

procedure TcaString.SetS(const AValue: string);
begin
  FS := AValue;
end;

// TcaByteString

// Create/Destroy

constructor TcaByteString.Create(ACount: Integer);
begin
  inherited Create;
  SetCount(ACount);
end;

// Public methods

procedure TcaByteString.Clear;
begin
  S := '';
end;

// Private methods

function TcaByteString.ByteToStr(AByte: Byte): string;
begin
  Result := Format('%.2x', [AByte]);
end;

procedure TcaByteString.CheckIndex(Index: Integer);
begin
  if Index >= GetCount then SetCount(Succ(Index));
end;

procedure TcaByteString.GetAsStrings(AStrings: TStrings);
var
  Index: Integer;
begin
  AStrings.Clear;
  Index := 1;
  while Index <= Length do
    begin
      AStrings.Add(Copy(S, Index, 2));
      Inc(Index, 2);
    end;
end;

procedure TcaByteString.SetAsStrings(AStrings: TStrings);
var
  Index: Integer;
begin
  Clear;
  for Index := 0 to Pred(AStrings.Count) do
    Add(AStrings[Index]);
end;

// Property methods

function TcaByteString.GetAsString: string;
begin
  Result := S;
end;

function TcaByteString.GetByte(Index: Integer): Byte;
var
  Offset: Integer;
begin
  CheckIndex(Index);
  Offset := Succ(Index * 2);
  Result := StrToInt('$' + Copy(S, Offset, 2));
end;

function TcaByteString.GetCount: Integer;
begin
  Result := Length div 2;
end;

procedure TcaByteString.SetAsString(const AValue: string);
begin
  S := AValue;
end;

procedure TcaByteString.SetByte(Index: Integer; const AValue: Byte);
var
  Strings: TStrings;
begin
  CheckIndex(Index);
  Strings := TStringList.Create;
  try
    GetAsStrings(Strings);
    Strings[Index] := ByteToStr(AValue);
    SetAsStrings(Strings);
  finally
    Strings.Free;
  end;
end;

procedure TcaByteString.SetCount(const AValue: Integer);
begin
  while GetCount < AValue do
    S := S + '00';
end;

// TcaStringStack

// Create/Destroy

constructor TcaStringStack.Create;
begin
  inherited Create;
  FLines := TStringList.Create;
end;

constructor TcaStringStack.Create(const AString: string);
begin
  Create;
  FLines.Text := AString;
end;

constructor TcaStringStack.Create(AStrings: TStrings);
begin
  Create;
  FLines.Text := AStrings.Text;
end;

destructor TcaStringStack.Destroy;
begin
  FLines.Free;
  inherited Destroy;
end;

// Public methods

function TcaStringStack.HasItems: Boolean;
begin
  Result := FLines.Count > 0;
end;

function TcaStringStack.IsEmpty: Boolean;
begin
  Result := FLines.Count = 0;
end;

function TcaStringStack.Peek: string;
begin
  if IsEmpty then
    Result := ''
  else
    Result := FLines[FLines.Count - 1];
end;

function TcaStringStack.Pop: string;
begin
  if IsEmpty then
    Result := ''
  else
    begin
      Result := Peek;
      FLines.Delete(FLines.Count - 1);
    end;
end;

function TcaStringStack.Push(const AItem: string): Integer;
begin
  Result := FLines.Add(AItem);
end;

function TcaStringStack.Size: Integer;
begin
  Result := FLines.Count;
end;

// TcaOwnedComponents                                                        

// Create/Destroy 

constructor TcaOwnedComponents.Create(ARootComponent: TComponent);
begin
  inherited Create;
  FComponents := TList.Create;
  FRootComponent := ARootComponent;
  AddComponents;
end;

destructor TcaOwnedComponents.Destroy;
begin
  FComponents.Free;
  inherited;
end;

// Protected methods 

procedure TcaOwnedComponents.DoAddComponent(AComponent: TComponent; var AAccept: Boolean);
begin
  if Assigned(FOnAddComponent) then FOnAddComponent(Self, AComponent, AAccept);
end;

// Private methods 

procedure TcaOwnedComponents.AddComponents;
begin
  FComponents.Clear;
  AddComponents_Recursed(FRootComponent);
end;

procedure TcaOwnedComponents.AddComponents_Recursed(AComponent: TComponent);
var
  Accept: Boolean;
  Comp: TComponent;
  Index: Integer;
begin
  for Index := 0 to Pred(AComponent.ComponentCount) do
    begin
      Comp := AComponent.Components[Index];
      Accept := True;
      DoAddComponent(Comp, Accept);
      if Accept then
        begin
          FComponents.Add(Comp);
          AddComponents_Recursed(Comp);
        end;
    end;
end;

// Property methods 

function TcaOwnedComponents.GetComponent(Index: Integer): TComponent;
begin
  Result := TComponent(FComponents[Index]);
end;

function TcaOwnedComponents.GetCount: Integer;
begin
  Result := FComponents.Count;
end;

// TcaParentedControls

// Create/Destroy 

constructor TcaParentedControls.Create(ARootControl: TWinControl);
begin
  inherited Create;
  FControls := TList.Create;
  FRootControl := ARootControl;
  AddControls;
end;

destructor TcaParentedControls.Destroy;
begin
  FControls.Free;
  inherited Destroy;
end;

// Protected methods 

procedure TcaParentedControls.DoAddControl(AControl: TWinControl; var AAccept: Boolean);
begin
  if Assigned(FOnAddControl) then FOnAddControl(Self, AControl, AAccept);
end;

// private methods

procedure TcaParentedControls.AddControls;
begin
  FControls.Clear;
  AddControls_Recursed(FRootControl);
end;

procedure TcaParentedControls.AddControls_Recursed(AControl: TWinControl);
var
  Accept: Boolean;
  Ctrl: TControl;
  Index: Integer;
begin
  for Index := 0 to Pred(AControl.ControlCount) do
    begin
      Ctrl := AControl.Controls[Index];
      if Ctrl is TWinControl then
        begin
          Accept := True;
          DoAddControl(TWinControl(Ctrl), Accept);
          if Accept then
            begin
              FControls.Add(TWinControl(Ctrl));
              AddControls_Recursed(TWinControl(Ctrl));
            end;
        end;
    end;
end;

// property methods

function TcaParentedControls.GetControl(Index: Integer): TControl;
begin
  Result := TControl(FControls[Index]);
end;

function TcaParentedControls.GetCount: Integer;
begin
  Result := FControls.Count;
end;

end.

