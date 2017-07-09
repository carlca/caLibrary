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

unit caMatrix;

{$mode objfpc}{$H+}

interface

uses

// FPC units
  Classes,
  SysUtils,
  TypInfo,
  Base64,

// caLibrary units
  caClasses,
  caTypes,
  caUtils,
  caCell,
  caCellManager,
  caParser,
  caXmlReader,
  caXmlWriter;

type

// EcaMatrixException

  EcaMatrixException = class(EcaException);

// TcaColRow

  TcaColRow = record
    Col: Integer;
    Row: Integer;
  end;

// TcaMatrix

  TcaMatrix = class(TComponent)
  public
    // Create/Destroy
    constructor Create(AOwner: TComponent); override; overload;
    constructor Create(AAutoColCount, AAutoRowCount: Boolean); overload;
    constructor Create(AColCount, ARowCount: Integer); overload;
    constructor Create(AXml: string); overload;
    destructor Destroy; override;
  private
    // Private fields
    FCellManager: TcaCellManager;
    FColumnNames: TStrings;
    FColumnTypeIndex: Integer;
    FColumnTypes: TcaByteString;
    FXmlName: string;
    FXmlReadRow: Integer;
    // Private methods
    function GetAutoColumnType(ACol: Integer): TcaCellType;
    function GetXmlDocumentName: string;
    function GetXmlBodyText: string;
    function CreateXmlWriter: TcaXmlWriter;
    procedure AddXmlHeader(AXmlWriter: TcaXmlWriter);
    procedure AddXmlBodyText(AXmlWriter: TcaXmlWriter);
    procedure AddXmlFooter(AXmlWriter: TcaXmlWriter);
    procedure CreateObjects;
    procedure FreeObjects;
    procedure SynchronizeColumnNames;
    // Xml reading private methods 
    function GetXmlColumnFromTag(const ATag: string): Integer;
    procedure BuildXmlAttributesList(const AAttributes: string; AList: TStrings);
    procedure RunXmlReader(AXmlReader: TcaXmlReader);
    procedure XmlColCountReceived(const AData: string);
    procedure XmlColumnNameReceived(const AData: string);
    procedure XmlColumnTypeReceived(const AData: string);
    procedure XmlDocumentNameReceived(const ATag: string);
    procedure XmlEndRowReceived;
    procedure XmlRowCountReceived(const AData: string);
    procedure XmlRowDataReceived(const ATag, AData, AAttributes: string);
    // Property methods
    function GetAutoColCount: Boolean;
    function GetAutoRowCount: Boolean;
    function GetColCount: Integer;
    function GetColumnType(ACol: Integer): TcaCellType;
    function GetRowCount: Integer;
    function GetXml: string;
    procedure SetAutoColCount(AValue: Boolean);
    procedure SetAutoRowCount(AValue: Boolean);
    procedure SetColCount(AValue: Integer);
    procedure SetColumnType(ACol: Integer; AValue: TcaCellType);
    procedure SetColumnNames(AValue: TStrings);
    procedure SetRowCount(AValue: Integer);
    procedure SetXml(AValue: string);
    // Cell manager event handler
    procedure ColCountChanged(Sender: TObject);
    // Xml reader event handlers 
    procedure XmlDataEvent(Sender: TObject; const ATag, AData, AAttributes: string; ALevel: Integer);
    procedure XmlEndTagEvent(Sender: TObject; const ATag: string; ALevel: Integer);
    procedure XmlTagEvent(Sender: TObject; const ATag, {%H-}AAttributes: string; ALevel: Integer);
  protected
    // Cell access property methods 
    function GetBoolean(ACol, ARow: Integer): Boolean;
    function GetDateTime(ACol, ARow: Integer): TDateTime;
    function GetDouble(ACol, ARow: Integer): Double;
    function GetInteger(ACol, ARow: Integer): Integer;
    function GetInt64(ACol, ARow: Integer): Int64;
    function GetMemo(ACol, ARow: Integer): TStrings;
    function GetObject(ACol, ARow: Integer): TObject;
    function GetSingle(ACol, ARow: Integer): Single;
    function GetString(ACol, ARow: Integer): string;
    function GetUInt32(ACol, ARow: Integer): UInt32;
    function GetUInt64(ACol, ARow: Integer): UInt64;
    procedure SetBoolean(ACol, ARow: Integer; const AValue: Boolean);
    procedure SetDateTime(ACol, ARow: Integer; const AValue: TDateTime);
    procedure SetDouble(ACol, ARow: Integer; const AValue: Double);
    procedure SetInt64(ACol, ARow: Integer; const AValue: Int64);
    procedure SetInteger(ACol, ARow: Integer; const AValue: Integer);
    procedure SetMemo(ACol, ARow: Integer; const AValue: TStrings);
    procedure SetObject(ACol, ARow: Integer; const AValue: TObject);
    procedure SetSingle(ACol, ARow: Integer; const AValue: Single);
    procedure SetString(ACol, ARow: Integer; const AValue: string);
    procedure SetUInt32(ACol, ARow: Integer; const AValue: UInt32);
    procedure SetUInt64(ACol, ARow: Integer; const AValue: UInt64);
  public
    // Methods
    function AddCol: Integer;
    function AddRow: Integer;
    function GetCell(ACol, ARow: Integer): TcaCell;
    function FindObject(AObject: TObject): TcaColRow;
    procedure AddCols(AValue: Integer);
    procedure AddRows(AValue: Integer);
    procedure Assign(Source: TPersistent); override;
    procedure AssignCell(Source: TcaMatrix; const SrcCol, SrcRow, DestCol, DestRow: Integer);
    procedure LoadFromXml(const AFileName: string);
    procedure SaveToXml(const AFileName: string);
    // Properties
    property ColumnTypes[ACol: Integer]: TcaCellType read GetColumnType write SetColumnType;
    property Xml: string read GetXml write SetXml;
    // Cell access properties 
    property Booleans[ACol, ARow: Integer]: Boolean read GetBoolean write SetBoolean;
    property DateTimes[ACol, ARow: Integer]: TDateTime read GetDateTime write SetDateTime;
    property Doubles[ACol, ARow: Integer]: Double read GetDouble write SetDouble;
    property Integers[ACol, ARow: Integer]: Integer read GetInteger write SetInteger;
    property Int64s[ACol, ARow: Integer]: Int64 read GetInt64 write SetInt64;
    property Memos[ACol, ARow: Integer]: TStrings read GetMemo write SetMemo;
    property Objects[ACol, ARow: Integer]: TObject read GetObject write SetObject;
    property Singles[ACol, ARow: Integer]: Single read GetSingle write SetSingle;
    property Strings[ACol, ARow: Integer]: string read GetString write SetString;
    property UInt32s[ACol, ARow: Integer]: UInt32 read GetUInt32 write SetUInt32;
    property UInt64s[ACol, ARow: Integer]: UInt64 read GetUInt64 write SetUInt64;
  published
    property AutoColCount: Boolean read GetAutoColCount write SetAutoColCount;
    property AutoRowCount: Boolean read GetAutoRowCount write SetAutoRowCount;
    property ColCount: Integer read GetColCount write SetColCount;
    property ColumnNames: TStrings read FColumnNames write SetColumnNames;
    property Name;
    property RowCount: Integer read GetRowCount write SetRowCount;
    property Tag;
    property XmlName: string read FXmlName write FXmlName;
  end;

// TcaBooleanMatrix

  TcaBooleanMatrix = class(TcaMatrix)
  public
    property Booleans[ACol, ARow: Integer]: Boolean read GetBoolean write SetBoolean; default;
  end;

// TcaDateTimeMatrix

  TcaDateTimeMatrix = class(TcaMatrix)
  public
    property DateTimes[ACol, ARow: Integer]: TDateTime read GetDateTime write SetDateTime; default;
  end;

// TcaDoubleMatrix

  TcaDoubleMatrix = class(TcaMatrix)
  public
    property Doubles[ACol, ARow: Integer]: Double read GetDouble write SetDouble; default;
  end;

// TcaIntegerMatrix

  TcaIntegerMatrix = class(TcaMatrix)
  public
    property Integers[ACol, ARow: Integer]: Integer read GetInteger write SetInteger; default;
  end;

// TcaInt64Matrix

  TcaInt64Matrix = class(TcaMatrix)
  public
    property Int64s[ACol, ARow: Integer]: Int64 read GetInt64 write SetInt64; default;
  end;

// TcaMemoMatrix

  TcaMemoMatrix = class(TcaMatrix)
  public
    property Memos[ACol, ARow: Integer]: TStrings read GetMemo write SetMemo; default;
  end;

// TcaObjectMatrix

  TcaObjectMatrix = class(TcaMatrix)
  public
    property Objects[ACol, ARow: Integer]: TObject read GetObject write SetObject; default;
  end;

// TcaSingleMatrix

  TcaSingleMatrix = class(TcaMatrix)
  public
    property Singles[ACol, ARow: Integer]: Single read GetSingle write SetSingle; default;
  end;

// TcaStringMatrix

  TcaStringMatrix = class(TcaMatrix)
  public
    property Strings[ACol, ARow: Integer]: string read GetString write SetString; default;
  end;

// TcaUInt32Matrix

  TcaUInt32Matrix = class(TcaMatrix)
  public
    property UInt32s[ACol, ARow: Integer]: UInt32 read GetUInt32 write SetUInt32; default;
  end;

// TcaUInt64Matrix

  TcaUInt64Matrix = class(TcaMatrix)
  public
    property UInt64s[ACol, ARow: Integer]: UInt64 read GetUInt64 write SetUInt64; default;
  end;

implementation

// TcaMatrix

// Create/Destroy

constructor TcaMatrix.Create(AOwner: TComponent);
begin
  inherited;
  CreateObjects;
end;

constructor TcaMatrix.Create(AAutoColCount, AAutoRowCount: Boolean);
begin
  inherited Create(nil);
  CreateObjects;
  FCellManager.AutoColCount := AAutoColCount;
  FCellManager.AutoRowCount := AAutoRowCount;
end;

constructor TcaMatrix.Create(AColCount, ARowCount: Integer);
begin
  inherited Create(nil);
  CreateObjects;
  SetColCount(AColCount);
  SetRowCount(ARowCount);
end;

constructor TcaMatrix.Create(AXml: string);
begin
  inherited Create(nil);
  CreateObjects;
  SetXml(AXml);
end;

destructor TcaMatrix.Destroy;
begin
  FreeObjects;
  inherited Destroy;
end;

// Public methods

function TcaMatrix.AddCol: Integer;
begin
  SetColCount(GetColCount + 1);
  Result := GetColCount - 1;
end;

function TcaMatrix.AddRow: Integer;
begin
  SetRowCount(GetRowCount + 1);
  Result := GetRowCount - 1;
end;

function TcaMatrix.GetCell(ACol, ARow: Integer): TcaCell;
begin
  Result := FCellManager.GetCell(ACol, ARow);
end;

function TcaMatrix.FindObject(AObject: TObject): TcaColRow;
var
 Col, Row: Integer;
 Found: Boolean;
begin
  Result.Col := -1;
  Result.Row := -1;
  for Col := 0 to Pred(ColCount) do
    begin
      for Row := 0 to Pred(RowCount) do
        begin
          if Objects[Col, Row] = AObject then
            begin
              Result.Col := Col;
              Result.Row := Row;
            end;
        end;
      if Result.Col <> -1 then Break;
    end;
end;

procedure TcaMatrix.AddCols(AValue: Integer);
begin
  SetColCount(GetColCount + AValue);
end;

procedure TcaMatrix.AddRows(AValue: Integer);
begin
  SetRowCount(GetRowCount + AValue);
end;

procedure TcaMatrix.Assign(Source: TPersistent);
var
  Col, Row: Integer;
  Src: TcaMatrix;
begin
  if Source is TcaMatrix then
    begin
      Src := TcaMatrix(Source);
      AutoColCount := Src.AutoColCount;
      AutoRowCount := Src.AutoRowCount;
      ColCount := Src.ColCount;
      RowCount := Src.RowCount;
      for Col := 0 to Pred(Src.ColCount) do
        for Row := 0 to Pred(Src.RowCount) do
          AssignCell(Src, Col, Row, Col, Row);
    end
  else
    inherited Assign(Source);
end;

procedure TcaMatrix.AssignCell(Source: TcaMatrix; const SrcCol, SrcRow, DestCol, DestRow: Integer);
var
  SrcCell: TcaCell;
  DestCell: TcaCell;
begin
  SrcCell := Source.GetCell(SrcCol, SrcRow);
  DestCell := GetCell(DestCol, DestRow);
  if not Assigned(DestCell) then
    DestCell := FCellManager.CreateNewCell(DestCol, DestRow, TcaCellClass(SrcCell.ClassType));
  if Assigned(SrcCell) and Assigned(DestCell) then
    DestCell.Assign(SrcCell)
end;

procedure TcaMatrix.LoadFromXml(const AFileName: string);
var
  FileName: string;
  XmlReader: TcaXmlReader;
begin
  FileName := AFileName;
  if ExtractFileExt(FileName) = '' then
    FileName := FileName + '.xml';
  XmlReader := TcaXmlReader.Create;
  try
    XmlReader.LoadFromXml(FileName);
    RunXmlReader(XmlReader);
  finally
    XmlReader.Free;
  end;
end;

procedure TcaMatrix.SaveToXml(const AFileName: string);
var
  FileName: string;
  XmlWriter: TcaXmlWriter;
begin
  FileName := AFileName;
  if ExtractFileExt(FileName) = '' then
    FileName := FileName + '.xml';
  XmlWriter := CreateXmlWriter;
  try
    XmlWriter.SaveToFile(FileName);
  finally
    XmlWriter.Free;
  end;
end;

// Private methods

function TcaMatrix.GetAutoColumnType(ACol: Integer): TcaCellType;
var
  ARow: Integer;
  Cell: TcaCell;
  CellTypes: TStringList;
  CellTypeStr: string;
begin
  Result := ctNil;
  CellTypes := TStringList.Create;
  try
    for ARow := 0 to Pred(FCellManager.RowCount) do
      begin
        Cell := FCellManager.GetCell(ACol, ARow);
        if Cell = nil then
          CellTypeStr := 'ctNil'
        else
          CellTypeStr := GetEnumName(TypeInfo(TcaCellType), Ord(Cell.CellType));
        if CellTypes.IndexOf(CellTypeStr) = -1 then
          CellTypes.Add(CellTypeStr);
      end;
    if CellTypes.Count = 1 then
      Result := StringUtils.CellTypeStrToCellType(CellTypes[0]);
    if CellTypes.Count > 1 then
      Result := ctMany;
  finally
    CellTypes.Free;
  end;
end;

function TcaMatrix.GetXmlDocumentName: string;
begin
  if FXmlName <> '' then
    Result := FXmlName
  else
    Result := 'Matrix';
end;

function TcaMatrix.GetXmlBodyText: string;
var
  ACol: Integer;
  ARow: Integer;
  XmlWriter: TcaXmlWriter;
  Cell: TcaCell;
  CellType: TcaCellType;
  CellTypeStr: string;
  CellStr: string;
  Attribute: string;
begin
  XmlWriter := TcaXmlWriter.Create;
  try
    for ARow := 0 to Pred(FCellManager.RowCount) do
      begin
        XmlWriter.AddTag('Row', Format('Number="%d"', [ARow]), 1);
        for ACol := 0 to Pred(FCellManager.ColCount) do
          begin
            Cell := FCellManager.GetCell(ACol, ARow);
            if Cell = nil then
              begin
                CellStr := '';
                Attribute := 'CellType="ctNil"';
              end
            else
              begin
                CellStr := Cell.AsString;
                CellType := Cell.CellType;
                if CellType = ctMemo then
                  // Mime encode memos - this is the only way to produce 
                  // valid Xml if the cell itself contains Xml           
                  CellStr := EncodeStringBase64(CellStr);
                CellTypeStr := GetEnumName(TypeInfo(TcaCellType), Ord(CellType));
                Attribute := Format('CellType="%s"', [CellTypeStr]);
              end;
            XmlWriter.AddTag(FColumnNames[ACol], Attribute, 2);
            XmlWriter.Add(CellStr, 3);
            XmlWriter.EndTag(FColumnNames[ACol], 2);
          end;
        XmlWriter.EndTag('Row', 1);
      end;
    Result := XmlWriter.AsText;
  finally
    XmlWriter.Free;
  end;
end;

function TcaMatrix.CreateXmlWriter: TcaXmlWriter;
begin
  Result := TcaXmlWriter.Create;
  AddXmlHeader(Result);
  AddXmlBodyText(Result);
  AddXmlFooter(Result);
end;

procedure TcaMatrix.AddXmlHeader(AXmlWriter: TcaXmlWriter);
var
  ACol: Integer;
  CellType: TcaCellType;
  CellTypeStr: string;
begin
  // Document name 
  AXmlWriter.AddTag(GetXmlDocumentName);
  AXmlWriter.WriteValue('ColCount', FCellManager.ColCount);
  AXmlWriter.WriteValue('RowCount', FCellManager.RowCount);
  // ColumnNames 
  AXmlWriter.AddTag('ColumnNames');
  for ACol := 0 to Pred(FColumnNames.Count) do
    begin
      AXmlWriter.AddTag('ColumnName');
      AXmlWriter.Add(FColumnNames[ACol]);
      AXmlWriter.EndTag;
    end;
  AXmlWriter.EndTag;
  // ColumnTypes 
  AXmlWriter.AddTag('ColumnTypes');
  for ACol := 0 to Pred(GetColCount) do
    begin
      AXmlWriter.AddTag('ColumnType');
      CellType := GetColumnType(ACol);
      if CellType = ctNil then
        CellType := GetAutoColumnType(ACol);
      CellTypeStr := GetEnumName(TypeInfo(TcaCellType), Ord(CellType));
      AXmlWriter.Add(CellTypeStr);
      AXmlWriter.EndTag;
    end;
  AXmlWriter.EndTag;
end;

procedure TcaMatrix.AddXmlBodyText(AXmlWriter: TcaXmlWriter);
begin
  AXmlWriter.AddText(GetXmlBodyText);
end;

procedure TcaMatrix.AddXmlFooter(AXmlWriter: TcaXmlWriter);
begin
  AXmlWriter.EndTag(GetXmlDocumentName, 0);
end;

procedure TcaMatrix.CreateObjects;
begin
  FCellManager := TcaCellManagerClass.Create;
  FCellManager.OnColCountChanged := @ColCountChanged;
  FColumnNames := TStringList.Create;
  FColumnTypes := TcaByteString.Create;
end;

procedure TcaMatrix.FreeObjects;
begin
  FCellManager.Free;
  FColumnNames.Free;
  FColumnTypes.Free;
end;

procedure TcaMatrix.SynchronizeColumnNames;
begin
  while FColumnNames.Count > FCellManager.ColCount do
    FColumnNames.Delete(FColumnNames.Count - 1);
  while FColumnNames.Count < FCellManager.ColCount do
    FColumnNames.Add(Format('Column%d', [FColumnNames.Count + 1]));
end;

// Xml reading private methods 

function TcaMatrix.GetXmlColumnFromTag(const ATag: string): Integer;
var
  ColumnName: string;
  Index: Integer;
  StrippedTag: string;
begin
  Result := -1;
  StrippedTag := ATag;
  StrippedTag := StringReplace(StrippedTag, '_', #32, [rfReplaceAll]);
  for Index := 0 to Pred(FColumnNames.Count) do
    begin
      ColumnName := FColumnNames[Index];
      ColumnName := StringReplace(ColumnName, '_', #32, [rfReplaceAll]);
      if StrippedTag = ColumnName then
        begin
          Result := Index;
          Break;
        end;
    end;
end;

procedure TcaMatrix.BuildXmlAttributesList(const AAttributes: string; AList: TStrings);
var
  AttributeName: String;
  AttributeValue: String;
  Parser: TcaParser;
begin
  Parser := TcaParser.Create(AAttributes);
  try
    AList.Clear;
    Parser.TokenDelimiters := '=';
    while Parser.HasMoreTokens do
      begin
        AttributeName := Parser.NextToken;
        AttributeValue := Parser.NextToken;
        AList.Add(AttributeName + '=' + AttributeValue);
      end;
  finally
    Parser.Free;
  end;
end;

procedure TcaMatrix.RunXmlReader(AXmlReader: TcaXmlReader);
begin
  AXmlReader.OnData := @XmlDataEvent;
  AXmlReader.OnEndTag := @XmlEndTagEvent;
  AXmlReader.OnTag := @XmlTagEvent;
  FColumnTypeIndex := 0;
  FXmlReadRow := 0;
  FColumnNames.Clear;
  AXmlReader.Read;
end;

procedure TcaMatrix.XmlColCountReceived(const AData: string);
var
  DataAsInt: Integer;
begin
  DataAsInt := StringUtils.StringToInteger(AData);
  FCellManager.ColCount := DataAsInt;
  FColumnNames.Clear;
end;

procedure TcaMatrix.XmlColumnNameReceived(const AData: string);
begin
  FColumnNames.Add(AData);
end;

procedure TcaMatrix.XmlColumnTypeReceived(const AData: string);
begin
  FColumnTypes.Bytes[FColumnTypeIndex] := Byte(StringUtils.CellTypeStrToCellType(AData));
  Inc(FColumnTypeIndex);
end;

procedure TcaMatrix.XmlDocumentNameReceived(const ATag: string);
begin
  FXmlName := ATag;
end;

procedure TcaMatrix.XmlEndRowReceived;
begin
  Inc(FXmlReadRow);
end;

procedure TcaMatrix.XmlRowCountReceived(const AData: string);
var
  DataAsInt: Integer;
begin
  DataAsInt := StringUtils.StringToInteger(AData);
  FCellManager.RowCount := DataAsInt;
end;

procedure TcaMatrix.XmlRowDataReceived(const ATag, AData, AAttributes: string);
var
  ACol: Integer;
  CellMemo: TStrings;
  CellType: TcaCellType;
  CellTypeStr: String;
  AttributesList: TStrings;
begin
  AttributesList := TStringList.Create;
  try
    BuildXmlAttributesList(AAttributes, AttributesList);
    CellTypeStr := StringReplace(AttributesList.Values['CellType'], '"', '', [rfReplaceAll]);
    if CellTypeStr <> '' then
      begin
        CellType := TcaCell.StringToCellType(CellTypeStr);
        ACol := GetXmlColumnFromTag(ATag);
        if ACol >= 0 then
          begin
            case CellType of
              ctBoolean:  SetBoolean(ACol, FXmlReadRow, StringUtils.StringToBoolean(AData));
              ctDateTime: SetDateTime(ACol, FXmlReadRow, StringUtils.StringToDateTime(AData));
              ctDouble:   SetDouble(ACol, FXmlReadRow, StringUtils.StringToDouble(AData));
              ctInteger:  SetInteger(ACol, FXmlReadRow, StringUtils.StringToInteger(AData));
              ctInt64:    SetInt64(ACol, FXmlReadRow, StringUtils.StringToInt64(AData));
              ctMemo:     begin
                            CellMemo := TStringList.Create;
                            try
                              // Mime decode memos - all memos are mime encoded as 
                              // this is the only way to produce valid Xml if the  
                              // cell itself contains Xml                          
                              CellMemo.Text := DecodeStringBase64(AData);
                              SetMemo(ACol, FXmlReadRow, CellMemo);
                            finally
                              CellMemo.Free;
                            end;
                          end;
              ctObject:   Pass;
              ctSingle:   SetSingle(ACol, FXmlReadRow, StringUtils.StringToSingle(AData));
              ctString:   SetString(ACol, FXmlReadRow, AData);
              ctUInt32:   SetUInt32(ACol, FXmlReadRow, StringUtils.StringToUInt32(AData));
              ctUInt64:   SetUInt64(ACol, FXmlReadRow, StringUtils.StringToUInt64(AData));
            end;
          end;
      end;
  finally
    AttributesList.Free;
  end;
end;

// Property methods

function TcaMatrix.GetAutoColCount: Boolean;
begin
  Result := FCellManager.AutoColCount;
end;

function TcaMatrix.GetAutoRowCount: Boolean;
begin
  Result := FCellManager.AutoRowCount;
end;

function TcaMatrix.GetColCount: Integer;
begin
  Result := FCellManager.ColCount;
end;

function TcaMatrix.GetColumnType(ACol: Integer): TcaCellType;
begin
  Result := TcaCellType(FColumnTypes.Bytes[ACol]);
end;

function TcaMatrix.GetRowCount: Integer;
begin
  Result := FCellManager.RowCount;
end;

function TcaMatrix.GetXml: string;
var
  XmlWriter: TcaXmlWriter;
begin
  XmlWriter := CreateXmlWriter;
  try
    Result := XmlWriter.AsText;
  finally
    XmlWriter.Free;
  end;
end;

procedure TcaMatrix.SetAutoColCount(AValue: Boolean);
begin
  FCellManager.AutoColCount := AValue;
end;

procedure TcaMatrix.SetAutoRowCount(AValue: Boolean);
begin
  FCellManager.AutoRowCount := AValue;
end;

procedure TcaMatrix.SetColumnNames(AValue: TStrings);
begin
  FColumnNames.Assign(AValue);
  SynchronizeColumnNames;
end;

procedure TcaMatrix.SetColCount(AValue: Integer);
begin
  FCellManager.ColCount := AValue;
end;

procedure TcaMatrix.SetColumnType(ACol: Integer; AValue: TcaCellType);
begin
  FColumnTypes.Bytes[ACol] := Byte(AValue);
end;

procedure TcaMatrix.SetRowCount(AValue: Integer);
begin
  FCellManager.RowCount := AValue;
end;

procedure TcaMatrix.SetXml(AValue: string);
var
  StrStream: TStringStream;
  XmlReader: TcaXmlReader;
begin
  XmlReader := TcaXmlReader.Create;
  try
    StrStream := TStringStream.Create(AValue);
    try
      XmlReader.LoadFromStream(StrStream);
    finally
      StrStream.Free;
    end;
    RunXmlReader(XmlReader);
  finally
    XmlReader.Free;
  end;
end;

// Cell manager event handler

procedure TcaMatrix.ColCountChanged(Sender: TObject);
begin
  SynchronizeColumnNames;
end;

// Xml reader event handlers 

procedure TcaMatrix.XmlDataEvent(Sender: TObject; const ATag, AData, AAttributes: string; ALevel: Integer);
begin
  case ALevel of
    1:  begin
          if ATag = 'ColCount' then
            XmlColCountReceived(AData);
          if ATag = 'RowCount' then
            XmlRowCountReceived(AData);
        end;
    2:  begin
          if ATag = 'ColumnName' then
            XmlColumnNameReceived(AData);
          if ATag = 'ColumnType' then
            XmlColumnTypeReceived(AData);
          if FColumnNames.IndexOf(ATag) >= 0 then
            XmlRowDataReceived(ATag, AData, AAttributes);
        end;
    end;
end;

procedure TcaMatrix.XmlEndTagEvent(Sender: TObject; const ATag: string; ALevel: Integer);
begin
  if (ALevel = 1) and (ATag = 'Row') then XmlEndRowReceived;
end;

procedure TcaMatrix.XmlTagEvent(Sender: TObject; const ATag, AAttributes: string; ALevel: Integer);
begin
  if ALevel = 0 then XmlDocumentNameReceived(ATag);
end;

// Cell access property methods 

function TcaMatrix.GetBoolean(ACol, ARow: Integer): Boolean;
begin
  Result := FCellManager.GetCell(ACol, ARow, TcaBooleanCell).AsBoolean;
end;

function TcaMatrix.GetDateTime(ACol, ARow: Integer): TDateTime;
begin
  Result := FCellManager.GetCell(ACol, ARow, TcaDateTimeCell).AsDateTime;
end;

function TcaMatrix.GetDouble(ACol, ARow: Integer): Double;
begin
  Result := FCellManager.GetCell(ACol, ARow, TcaDoubleCell).AsDouble;
end;

function TcaMatrix.GetInteger(ACol, ARow: Integer): Integer;
begin
  Result := FCellManager.GetCell(ACol, ARow, TcaIntegerCell).AsInteger;
end;

function TcaMatrix.GetInt64(ACol, ARow: Integer): Int64;
begin
  Result := FCellManager.GetCell(ACol, ARow, TcaInt64Cell).AsInt64;
end;

function TcaMatrix.GetMemo(ACol, ARow: Integer): TStrings;
begin
  Result := FCellManager.GetCell(ACol, ARow, TcaMemoCell).AsMemo;
end;

function TcaMatrix.GetObject(ACol, ARow: Integer): TObject;
begin
  Result := FCellManager.GetCell(ACol, ARow, TcaObjectCell).AsObject;
end;

function TcaMatrix.GetSingle(ACol, ARow: Integer): Single;
begin
  Result := FCellManager.GetCell(ACol, ARow, TcaSingleCell).AsSingle;
end;

function TcaMatrix.GetString(ACol, ARow: Integer): string;
begin
  Result := FCellManager.GetCell(ACol, ARow, TcaStringCell).AsString;
end;

function TcaMatrix.GetUInt32(ACol, ARow: Integer): UInt32;
begin
  Result := FCellManager.GetCell(ACol, ARow, TcaUInt32Cell).AsUInt32;
end;

function TcaMatrix.GetUInt64(ACol, ARow: Integer): UInt64;
begin
  Result := FCellManager.GetCell(ACol, ARow, TcaUInt64Cell).AsUInt64;
end;

procedure TcaMatrix.SetBoolean(ACol, ARow: Integer; const AValue: Boolean);
begin
  FCellManager.CreateNewCell(ACol, ARow, TcaBooleanCell).AsBoolean := AValue;
end;

procedure TcaMatrix.SetDateTime(ACol, ARow: Integer; const AValue: TDateTime);
begin
  FCellManager.CreateNewCell(ACol, ARow, TcaDateTimeCell).AsDateTime := AValue;
end;

procedure TcaMatrix.SetDouble(ACol, ARow: Integer; const AValue: Double);
begin
  FCellManager.CreateNewCell(ACol, ARow, TcaDoubleCell).AsDouble := AValue;
end;

procedure TcaMatrix.SetInt64(ACol, ARow: Integer; const AValue: Int64);
begin
  FCellManager.CreateNewCell(ACol, ARow, TcaInt64Cell).AsInt64 := AValue;
end;

procedure TcaMatrix.SetInteger(ACol, ARow: Integer; const AValue: Integer);
begin
  FCellManager.CreateNewCell(ACol, ARow, TcaIntegerCell).AsInteger := AValue;
end;

procedure TcaMatrix.SetMemo(ACol, ARow: Integer; const AValue: TStrings);
begin
  FCellManager.CreateNewCell(ACol, ARow, TcaMemoCell).AsMemo := AValue;
end;

procedure TcaMatrix.SetObject(ACol, ARow: Integer; const AValue: TObject);
begin
  FCellManager.CreateNewCell(ACol, ARow, TcaObjectCell).AsObject := AValue;
end;

procedure TcaMatrix.SetSingle(ACol, ARow: Integer; const AValue: Single);
begin
  FCellManager.CreateNewCell(ACol, ARow, TcaSingleCell).AsSingle := AValue;
end;

procedure TcaMatrix.SetString(ACol, ARow: Integer; const AValue: string);
begin
  FCellManager.CreateNewCell(ACol, ARow, TcaStringCell).AsString := AValue;
end;

procedure TcaMatrix.SetUInt32(ACol, ARow: Integer; const AValue: UInt32);
begin
  FCellManager.CreateNewCell(ACol, ARow, TcaUInt32Cell).AsUInt32 := AValue;
end;

procedure TcaMatrix.SetUInt64(ACol, ARow: Integer; const AValue: UInt64);
begin
  FCellManager.CreateNewCell(ACol, ARow, TcaUInt64Cell).AsUInt64 := AValue;
end;

end.

