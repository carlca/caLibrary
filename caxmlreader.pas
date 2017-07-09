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

unit caXmlReader;

{$mode objfpc}{$H+}

interface

uses

// FPC units
  Classes, SysUtils,

// caLibrary units
  caUtils,
  caParser;

type

// Event classes

  TcaXmlReaderDataEvent = procedure(Sender: TObject; const ATag, AData, AAttributes: string;
                                    ALevel: Integer) of object;

  TcaXmlReaderEndTagEvent = procedure(Sender: TObject; const ATag: string;
                                      ALevel: Integer) of object;

  TcaXmlReaderTagEvent = procedure(Sender: TObject; const ATag, AAttributes: string;
                                   ALevel: Integer) of object;

// TcaXmlReader

  TcaXmlReader = class(TObject)
  private
    // Private fields 
    FXml: TStrings;
    FXmlTokens: TStrings;
    // Property fields 
    FOnData: TcaXmlReaderDataEvent;
    FOnEndTag: TcaXmlReaderEndTagEvent;
    FOnTag: TcaXmlReaderTagEvent;
    // Property methods
    function GetDocumentName: string;
    // Private methods
    function IsEndTag(const AToken: string): Boolean;
    function IsTag(const AToken: string): Boolean;
    function StripToken(const AToken: string): string;
    procedure ParseXmlText;
  protected
    // Protected methods
    procedure DoData(const ATag, AData, AAttributes: string; ALevel: Integer); virtual;
    procedure DoEndTag(const ATag: string; ALevel: Integer); virtual;
    procedure DoTag(const ATag, AAttributes: string; ALevel: Integer); virtual;
  public
    // Create/Destroy
    constructor Create;
    destructor Destroy; override;
    // Public methods 
    procedure LoadFromStream(Stream: TStream);
    procedure LoadFromXml(const AFileName: string);
    procedure Read;
    // Properties 
    property DocumentName: string read GetDocumentName;
    // Event properties 
    property OnData: TcaXmlReaderDataEvent read FOnData write FOnData;
    property OnEndTag: TcaXmlReaderEndTagEvent read FOnEndTag write FOnEndTag;
    property OnTag: TcaXmlReaderTagEvent read FOnTag write FOnTag;
  end;

implementation

// TcaXmlReader

// Create/Destroy

constructor TcaXmlReader.Create;
begin
  inherited Create;
  FXml := TStringList.Create;
  FXmlTokens := TStringList.Create;
end;

destructor TcaXmlReader.Destroy;
begin
  FXml.Free;
  FXmlTokens.Free;
  inherited Destroy;
end;

// Public methods

procedure TcaXmlReader.LoadFromStream(Stream: TStream);
begin
  FXml.LoadFromStream(Stream);
end;

procedure TcaXmlReader.LoadFromXml(const AFileName: string);
begin
  FXml.LoadFromFile(AFileName);
end;

procedure TcaXmlReader.Read;
var
  Attributes: string;
  ExpectingData: Boolean;
  Index: Integer;
  LastAttributes: string;
  LastLevel: Integer;
  LastTag: string;
  Level: Integer;
  SpacePos: Integer;
  StrippedToken: string;
  Tag: string;
  Token: string;
begin
  ParseXmlText;
  Level := 0;
  LastTag := '';
  LastLevel := 0;
  LastAttributes := '';
  ExpectingData := False;
  for Index := 0 to FXmlTokens.Count - 1 do
    begin
      Token := FXmlTokens[Index];
      if IsTag(Token) then
        begin
          if IsEndTag(Token) then
            begin
              if ExpectingData then
                begin
                  DoData(LastTag, '', LastAttributes, LastLevel);
                  ExpectingData := False;
                end;
              Dec(Level);
              DoEndTag(StripToken(Token), Level);
            end
          else
            begin
              StrippedToken := StripToken(Token);
              Attributes := '';
              SpacePos := Pos(' ', StrippedToken);
              if SpacePos > 0 then
                begin
                  Attributes := StrippedToken;
                  Attributes := StringUtils.DeleteUntilChar(Attributes, ' ', True);
                  Tag := LeftStr(StrippedToken, SpacePos - 1);
                end
              else
                Tag := StrippedToken;
              LastTag := Tag;
              LastLevel := Level;
              LastAttributes := Attributes;
              DoTag(Tag, Attributes, Level);
              Inc(Level);
              ExpectingData := True;
            end;
        end
      else
        begin
          DoData(LastTag, StripToken(Token), LastAttributes, LastLevel);
          ExpectingData := False;
        end;
    end;
end;

// Protected methods

procedure TcaXmlReader.DoData(const ATag, AData, AAttributes: string; ALevel: Integer);
begin
  if Assigned(FOnData) then FOnData(Self, ATag, AData, AAttributes, ALevel);
end;

procedure TcaXmlReader.DoEndTag(const ATag: string; ALevel: Integer);
begin
  if Assigned(FOnEndTag) then FOnEndTag(Self, ATag, ALevel);
end;

procedure TcaXmlReader.DoTag(const ATag, AAttributes: string; ALevel: Integer);
begin
  if Assigned(FOnTag) then FOnTag(Self, ATag, AAttributes, ALevel);
end;

// Private methods

function TcaXmlReader.IsEndTag(const AToken: string): Boolean;
begin
  Result := SameText(LeftStr(AToken, 2), '</');
end;

function TcaXmlReader.IsTag(const AToken: string): Boolean;
begin
  Result := SameText(LeftStr(AToken, 1), '<');
end;

function TcaXmlReader.StripToken(const AToken: string): string;
var
  Token: string;
begin
  Token := AToken;
  if IsTag(Token) then
    begin
      if IsEndTag(Token) then
        Delete(Token, 1, 2)
      else
        Delete(Token, 1, 1);
    end;
  Result := Trim(Token);
end;

procedure TcaXmlReader.ParseXmlText;
var
  Parser: TcaParser;
  Xml: string;
begin
  FXmlTokens.Clear;
  Xml := StringReplace(FXml.Text, '</', '></', [rfReplaceAll]);
  Parser := TcaParser.Create(Xml);
  try
    Parser.TokenDelimiters := '>';
    Parser.IgnoreBlanks := True;
    while Parser.HasMoreTokens do
      FXmlTokens.Add(Parser.NextToken);
  finally
    Parser.Free;
  end;
end;

// Property methods

function TcaXmlReader.GetDocumentName: string;
begin
  Result := '';
  ParseXmlText;
  if FXmlTokens.Count > 0 then
    Result := StripToken(FXmlTokens[0]);
end;

end.

