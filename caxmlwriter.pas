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

unit caXmlWriter;

{$mode objfpc}{$H+}

interface

uses

// FPC units
  Classes, SysUtils,

// caLibrary units
  caClasses,
  caTypes,
  caUtils;

type

// TcaXmlWriter

  TcaXmlWriter = class(TObject)
  private
    // Private fields
    FIndentSpaces: Integer;
    FLevel: Integer;
    FLines: TStrings;
    FTagStack: TcaStringStack;
    // Property methods
    function GetAsText: string;
    procedure SetAsText(AValue: string);
    // Private methods
    function BuildTag(const AElement: string; ALevel: Integer; ATagType: TcaXmlTagType): string;
    function GetLevel(ALevel: Integer): Integer;
    function StripDecoration(const AText: string): string;
  public
    // Create/Destroy
    constructor Create; overload;
    constructor CreateUtf8; overload;
    destructor Destroy; override;
    // Public methods
    function MakeAttribute(const AName: string; const AValue: Boolean): string; overload;
    function MakeAttribute(const AName: string; const AValue: Double): string; overload;
    function MakeAttribute(const AName: string; const AValue: Integer): string; overload;
    function MakeAttribute(const AName: string; const AValue: string): string; overload;
    procedure Add(const AElement: string; ALevel: Integer = -1); reintroduce;
    procedure AddTag(const AElement: string; ALevel: Integer = -1); overload;
    procedure AddTag(const AElement: string; AAttributes: string; ALevel: Integer = -1); overload;
    procedure AddTagWithEnd(const AElement: string; ALevel: Integer = -1); overload;
    procedure AddTagWithEnd(const AElement: string; AAttributes: string; ALevel: Integer = -1); overload;
    procedure AddText(const AText: string);
    procedure EmptyTag(const AElement: string; ALevel: Integer = -1);
    procedure EndTag(const AElement: string = ''; ALevel: Integer = -1);
    procedure SaveToFile(const AFileName: string);
    procedure SaveToStream(const AStream: TStream);
    procedure WriteValue(const AName: string; AValue: Boolean; ALevel: Integer = -1); overload;
    procedure WriteValue(const AName: string; AValue: Double; ALevel: Integer = -1); overload;
    procedure WriteValue(const AName: string; AValue: Integer; ALevel: Integer = -1); overload;
    procedure WriteValue(const AName, AValue: string; ALevel: Integer = -1); overload;
    // Properties 
    property AsText: string read GetAsText write SetAsText;
    property IndentSpaces: Integer read FIndentSpaces write FIndentSpaces;
  end;

implementation

// TcaXmlWriter

// Create/Destroy

constructor TcaXmlWriter.Create;
begin
  inherited;
  FLines := TStringList.Create;
  FTagStack := TcaStringStack.Create;
  FIndentSpaces := 2;
end;

constructor TcaXmlWriter.CreateUtf8;
begin
  Create;
  FLines.Add('<?xml version="1.0" encoding="utf-8"?>');
end;

destructor TcaXmlWriter.Destroy;
begin
  FLines.Free;
  FTagStack.Free;
  inherited Destroy;
end;

// Public methods

function TcaXmlWriter.MakeAttribute(const AName: string; const AValue: Boolean): string;
begin
  Result := Format('%s="%s"', [AName, StringUtils.BooleanToString(AValue)]);
end;

function TcaXmlWriter.MakeAttribute(const AName: string; const AValue: Double): string;
begin
  Result := Format('%s="%s"', [AName, FloatToStr(AValue)]);
end;

function TcaXmlWriter.MakeAttribute(const AName: string; const AValue: Integer): string;
begin
  Result := Format('%s="%s"', [AName, IntToStr(AValue)]);
end;

function TcaXmlWriter.MakeAttribute(const AName: string; const AValue: string): string;
begin
  Result := Format('%s="%s"', [AName, AValue]);
end;

procedure TcaXmlWriter.Add(const AElement: string; ALevel: Integer);
begin
  FLines.Add(BuildTag(AElement, GetLevel(ALevel), ttText));
end;

procedure TcaXmlWriter.AddTag(const AElement: string; ALevel: Integer);
begin
  FLines.Add(BuildTag(AElement, GetLevel(ALevel), ttStart));
  Inc(FLevel);
  FTagStack.Push(AElement);
end;

procedure TcaXmlWriter.AddTag(const AElement: string; AAttributes: string; ALevel: Integer);
var
  Attributes: string;
  AttributesList: TStringList;
  ElementAndAttributes: string;
  Index: Integer;
begin
  AttributesList := TStringList.Create;
  try
    AttributesList.CommaText := AAttributes;
    Attributes := '';
    for Index := 0 to AttributesList.Count - 1 do
      Attributes := Attributes + ' ' + AttributesList[Index];
    Attributes := StringUtils.Replace(Attributes, #32, '~');
    ElementAndAttributes := AElement + Attributes;
    AddTag(ElementAndAttributes, ALevel);
    FTagStack.Pop;
    FTagStack.Push(AElement);
  finally
    AttributesList.Free;
  end;
end;

procedure TcaXmlWriter.AddTagWithEnd(const AElement: string; ALevel: Integer);
var
  XmlText: string;
begin
  AddTag(AElement, ALevel);
  XmlText := FLines.Text;
  System.Delete(XmlText, Length(XmlText) - 1, 2);
  System.Insert('/', XmlText, Length(XmlText));
  FLines.Text := XmlText;
  Dec(FLevel);
  FTagStack.Pop;
end;

procedure TcaXmlWriter.AddTagWithEnd(const AElement: string; AAttributes: string; ALevel: Integer);
var
  XmlText: string;
begin
  AddTag(AElement, AAttributes, ALevel);
  XmlText := FLines.Text;
  System.Delete(XmlText, Length(XmlText) - 1, 2);
  System.Insert('/', XmlText, Length(XmlText));
  FLines.Text := XmlText;
  Dec(FLevel);
  FTagStack.Pop;
end;

procedure TcaXmlWriter.AddText(const AText: string);
var
  XmlText: string;
begin
  XmlText := FLines.Text;
  if Length(XmlText) > 2 then
    if (XmlText[Length(XmlText) - 1] = #13) and (XmlText[Length(XmlText)] = #10) then
      System.Delete(XmlText, Length(XmlText) - 1, 2);
  XmlText := XmlText + AText;
  FLines.Text := XmlText;
end;

procedure TcaXmlWriter.EmptyTag(const AElement: string; ALevel: Integer);
begin
  FLines.Add(BuildTag(AElement, GetLevel(ALevel) + 1, ttEmpty));
end;

procedure TcaXmlWriter.EndTag(const AElement: string; ALevel: Integer);
var
  Element: string;
  LastTag: string;
  XmlText: string;
  AddToText: Boolean;
  LastLine: string;
  ChevPos: Integer;
begin
  AddToText := False;
  LastTag := FTagStack.Pop;

  XmlText := FLines.Text;
  if Length(XmlText) > 2 then
    if (XmlText[Length(XmlText) - 1] = #13) and (XmlText[Length(XmlText)] = #10) then
      begin
        System.Delete(XmlText, Length(XmlText) - 1, 2);
        AddToText := XmlText[Length(XmlText)] <> '>';
      end;

  Dec(FLevel);
  if AElement <> '' then
    Element := AElement
  else
    Element := LastTag;

  if AddToText then
    begin
      XmlText := XmlText + Trim(BuildTag(Element, GetLevel(ALevel), ttEnd));
      FLines.Text := XmlText;
    end
  else
    FLines.Add(BuildTag(Element, GetLevel(ALevel), ttEnd));

  if FLines.Count >= 2 then
    begin
      if StripDecoration(FLines[FLines.Count - 2]) = StripDecoration(FLines[FLines.Count - 1]) then
        begin
          FLines.Delete(FLines.Count - 1);
          LastLine := FLines[FLines.Count - 1];
          ChevPos := Pos('>', LastLine);
          System.Insert(' /', LastLine, ChevPos);
          FLines[FLines.Count - 1] := LastLine;
        end;
    end;
end;

procedure TcaXmlWriter.SaveToFile(const AFileName: string);
begin
  FLines.SaveToFile(AFileName);
end;

procedure TcaXmlWriter.SaveToStream(const AStream: TStream);
begin
  FLines.SaveToStream(AStream);
end;

procedure TcaXmlWriter.WriteValue(const AName: string; AValue: Boolean; ALevel: Integer);
begin
  WriteValue(AName, StringUtils.BooleanToString(AValue), ALevel);
end;

procedure TcaXmlWriter.WriteValue(const AName: string; AValue: Double; ALevel: Integer);
begin
  WriteValue(AName, StringUtils.DoubleToString(AValue, ''), ALevel);
end;

procedure TcaXmlWriter.WriteValue( const AName: string; AValue: Integer; ALevel: Integer);
begin
  WriteValue(AName, StringUtils.IntegerToString(AValue, ''), ALevel);
end;

procedure TcaXmlWriter.WriteValue( const AName, AValue: string; ALevel: Integer);
begin
  AddTag(AName, GetLevel(ALevel));
  Add(AValue, GetLevel(ALevel));
  EndTag;
end;

// Private methods

function TcaXmlWriter.BuildTag(const AElement: string; ALevel: Integer; ATagType: TcaXmlTagType): string;
var
  T1, T2, T3: string;
  TagElement: string;
begin
  TagElement := AElement;
  TagElement := StringUtils.Replace(TagElement, ' ', '_');
  TagElement := StringUtils.Replace(TagElement, '~', ' ');
  T1 := '';
  T2 := '';
  T3 := '';
  case ATagType of
    ttStart:
      begin
        T1 := TagElement;
      end;
    ttEnd:
      begin
        T1 := '/';
        T2 := TagElement;
      end;
    ttEmpty:
      begin
        T1 := TagElement;
        T2 := ' ';
        T3 := '/';
      end;
    ttText:;
  end;
  if ATagType = ttText then
    Result := StringUtils.Indent(AElement, ALevel * FIndentSpaces)
  else
    Result := StringUtils.Indent(Format('<%s%s%s>', [T1, T2, T3]), ALevel * FIndentSpaces);
end;

function TcaXmlWriter.GetLevel(ALevel: Integer): Integer;
begin
  if ALevel >= 0 then
    Result := ALevel
  else
    Result := FLevel;

end;

function TcaXmlWriter.StripDecoration(const AText: string): string;
begin
  Result := StringUtils.Replace(AText, '<', '');
  Result := StringUtils.Replace(Result, '>', '');
  Result := StringUtils.Replace(Result, '/', '');
end;

// Property methods

function TcaXmlWriter.GetAsText: string;
begin
  Result := FLines.Text;
end;

procedure TcaXmlWriter.SetAsText(AValue: string);
begin
  FLines.Text := AValue;
end;

end.

