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

unit caParser;

{$mode objfpc}{$H+}

interface

uses

  // FPU units
  Classes, SysUtils,

  // caLibrary units
  caConsts;

type

// TcaParser

  TcaParser = class(TObject)
  private
    // Private fields
    FIgnoreBlanks: Boolean;
    FStringToParse: string;
    FTokenDelimiters: string;
    FTokenIndex: Integer;
    FTokens: TStrings;
    // Private methods
    function GetToken(Index: Integer; FromEnd: Boolean = False): string;
    procedure GetTokens(ATokens: TStrings);
  public
    // Create/Destroy
    constructor Create(const AStringToParse: string);
    destructor Destroy; override;
    // Public methods
    function HasMoreTokens: Boolean;
    function NextToken: string;
    procedure Reset;
    // Public properties
    property IgnoreBlanks: Boolean read FIgnoreBlanks write FIgnoreBlanks;
    property TokenDelimiters: string read FTokenDelimiters write FTokenDelimiters;
  end;

implementation

// TcaParser

// Create/Destroy

constructor TcaParser.Create(const AStringToParse: string);
begin
  inherited Create;
  FStringToParse := AStringToParse;
  FTokens := TStringList.Create;
  Reset;
end;

destructor TcaParser.Destroy;
begin
  FTokens.Free;
  inherited Destroy;
end;

// Public methods

function TcaParser.HasMoreTokens: Boolean;
begin
  if FTokens.Count = 0 then GetTokens(FTokens);
  Result := FTokenIndex + 1 < FTokens.Count;
end;

function TcaParser.NextToken: string;
var
  NewTokenIndex: Integer;
begin
  Result := '';
  if FTokens.Count = 0 then GetTokens(FTokens);
  if FTokens.Count > 0 then
    begin
      NewTokenIndex := FTokenIndex;
      Inc(NewTokenIndex);
      if NewTokenIndex < FTokens.Count then
        begin
          FTokenIndex := NewTokenIndex;
          Result := FTokens[FTokenIndex];
        end;
    end;
end;

procedure TcaParser.Reset;
begin
  FTokens.Clear;
  FTokenDelimiters := cDefaultTokenDelimiters;
  FTokenIndex := -1;
end;

// Private methods

function TcaParser.GetToken(Index: Integer; FromEnd: Boolean): string;
begin
  Result := '';
  if FTokens.Count = 0 then GetTokens(FTokens);
  if FTokens.Count > 0 then
    if (Index >= 0) and (Index < FTokens.Count) then
      begin
        if FromEnd then
          Result := FTokens[Pred(FTokens.Count) - Index]
        else
          Result := FTokens[Index]
      end;
end;

procedure TcaParser.GetTokens(ATokens: TStrings);
var
  Ch: Char;
  ChIndex, ChPos: Integer;
  OldDelims: string;
  S: string;
  Token: string;
begin
  S := FStringToParse;
  S := StringReplace(S, #10, #32, [rfReplaceAll]);
  S := StringReplace(S, #13, #32, [rfReplaceAll]);
  OldDelims := FTokenDelimiters;
  try
    if Pos('|', FTokenDelimiters) = 0 then
      FTokenDelimiters := FTokenDelimiters + '|';
    ATokens.Clear;
    if Length(S) > 0 then
      begin
        Ch := S[Length(S)];
        if Pos(Ch, FTokenDelimiters) = 0 then
          S := S + '|';
        ChPos := 1;
        for ChIndex := 1 to Length(S) do
          begin
            Ch := S[ChIndex];
            if Pos(Ch, FTokenDelimiters) > 0 then
              begin
                Token := Trim(Copy(S, ChPos, ChIndex - ChPos));
                if FIgnoreBlanks then
                  begin
                    if Length(Token) > 0 then
                      ATokens.Add(Token);
                  end
                else
                  ATokens.Add(Token);
                ChPos := ChIndex + 1;
              end;
          end;
      end;
  finally
    FTokenDelimiters := OldDelims;
  end;
end;

end.

