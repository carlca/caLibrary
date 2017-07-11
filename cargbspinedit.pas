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

unit cargbspinedit;

{$mode objfpc}{$H+}

{.$DEFINE DBG}

interface

uses
  Classes, SysUtils, Controls, StdCtrls, ExtCtrls, Graphics, Buttons, ComCtrls,
  Dialogs, TypInfo, caDbg, LclIntf, caUtils, caControls;

const
  cEditWidth = 26;

type

  TcaColorFormat = (cfRGB, cfBGR);

  { TcaRGBSpinEdit }

  TcaRGBSpinEdit = class(TCustomPanel)
  private
    FActiveEdit: TEdit;
    FColorFormat: TcaColorFormat;
    FColorValue: TColor;
    FEdits: array[0..2] of TEdit;
    FPrefix: TLabel;
    FUpDown: TUpDown;
    FOnEditChanged: TNotifyEvent;
    FSettingEdits: Boolean;
    function CreateEdit(Index: Integer): TEdit;
    function CreateLabel: TLabel;
    function CreateUpDown: TUpDown;
    function GetRedCell: TEdit;
    function GetGreenCell: TEdit;
    function GetBlueCell: TEdit;
    function GetPrefix: Char;
    procedure EditChangeEvent(Sender: TObject);
    procedure EditEnterEvent(Sender: TObject);
    procedure EditKeyPressEvent(Sender: TObject; var Key: char);
    procedure UpDownClickEvent(Sender: TObject; Button: TUDBtnType);
    procedure SetColorFormat(AValue: TcaColorFormat);
    procedure SetColorValue(AValue: TColor);
    procedure SetPrefix(AValue: Char);
    procedure UpdateColorCells;
    procedure UpdateHeights;
    procedure UpdateSize;
  protected
    procedure Loaded; override;
    procedure CreateWnd; override;
    procedure DoEditChanged; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Constraints;
  published
    property Color;
    property Enabled;
    property Font;
    property ColorFormat: TcaColorFormat read FColorFormat write SetColorFormat;
    property ColorValue: TColor read FColorValue write SetColorValue;
    property Prefix: Char read GetPrefix write SetPrefix;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnClick;
    property OnEditChanged: TNotifyEvent read FOnEditChanged write FOnEditChanged;
    property OnEnter;
    property OnExit;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnResize;
  end;

implementation

{ TcaRGBSpinEdit }

constructor TcaRGBSpinEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  BorderStyle := bsSingle;
  Caption := '';
  FEdits[0] := CreateEdit(0);
  FEdits[1] := CreateEdit(1);
  FEdits[2] := CreateEdit(2);
  FPrefix := CreateLabel;
  FColorFormat := cfRGB;
  SetPrefix('#');
  FUpDown := CreateUpDown;
  FUpDown.Parent := Self;
end;

destructor TcaRGBSpinEdit.Destroy;
begin
  inherited Destroy;
end;

function TcaRGBSpinEdit.CreateEdit(Index: Integer): TEdit;
var
  Edit: TEdit;
begin
  Edit := TEdit.Create(Self);
  Edit.Parent := Self;
  Edit.Left := 12 + Index * cEditWidth;
  Edit.Top := 0;
  Edit.Width := cEditWidth;
  Edit.MaxLength := 2;
  Edit.OnEnter := @EditEnterEvent;
  Edit.OnKeyPress := @EditKeyPressEvent;
  Edit.OnChange := @EditChangeEvent;
  Edit.ParentFont := False;
  Edit.Font.Size := Edit.Font.Size - 2;
  Edit.Alignment := taCenter;
  Edit.HideSelection := True;
  Edit.AutoSelect := False;
  Edit.ReadOnly := True;
  Result := Edit;
end;

function TcaRGBSpinEdit.CreateLabel: TLabel;
var
  Lbl: TLabel;
begin
  Lbl := TLabel.Create(Self);
  Lbl.Parent := Self;
  Lbl.Left := 2;
  Lbl.Top := 3;
  Lbl.Width := 8;
  Lbl.Layout := tlCenter;
  Result := Lbl;
end;

function TcaRGBSpinEdit.CreateUpDown: TUpDown;
var
  UpDown: TUpDown;
begin
  UpDown := TUpDown.Create(Self);
  UpDown.Left := FEdits[2].Left + FEdits[2].Width + 2;
  UpDown.Top := 0;
  UpDown.Width := 16;
  UpDown.Height := 21;
  UpDown.OnClick := @UpDownClickEvent;
  Result := UpDown;
end;

function TcaRGBSpinEdit.GetPrefix: Char;
begin
  Result := FPrefix.Caption[1];
end;

procedure TcaRGBSpinEdit.DoEditChanged;
var
  ColorVal: TColor;
begin
  case FColorFormat of
    cfRGB:
      begin
        ColorVal := StringUtils.HexToDec(FEdits[0].Text);
        ColorVal := ColorVal + StringUtils.HexToDec(FEdits[1].Text) * $100;
        ColorVal := ColorVal + StringUtils.HexToDec(FEdits[2].Text) * $10000;
      end;
    cfBGR:
      begin
        ColorVal := StringUtils.HexToDec(FEdits[2].Text);
        ColorVal := ColorVal + StringUtils.HexToDec(FEdits[1].Text) * $100;
        ColorVal := ColorVal + StringUtils.HexToDec(FEdits[0].Text) * $10000;
      end;
  end;
  FSettingEdits := True;
  SetColorValue(ColorVal);
  if Assigned(FOnEditChanged) then FOnEditChanged(Self);
  FSettingEdits := False;
end;

procedure TcaRGBSpinEdit.EditChangeEvent(Sender: TObject);
begin
  DoEditChanged;
end;

procedure TcaRGBSpinEdit.EditEnterEvent(Sender: TObject);
begin
  FActiveEdit := TEdit(Sender);
  ControlUtils.SetExclusiveColor(FActiveEdit, Parent, TEdit, clHighlight, clDefault);
end;

procedure TcaRGBSpinEdit.EditKeyPressEvent(Sender: TObject; var Key: char);
begin
  Key := #0;
end;

procedure TcaRGBSpinEdit.UpDownClickEvent(Sender: TObject; Button: TUDBtnType);
var
  HexVal: string;
  DecVal: Integer;
begin
  if Assigned(FActiveEdit) then
    begin
      HexVal := FActiveEdit.Text;
      DecVal := StringUtils.HexToDec(HexVal);
      case Button of
        btNext:   Inc(DecVal);
        btPrev:   Dec(DecVal);
      end;
      if DecVal = -1 then DecVal := 255;
      if DecVal = 256 then DecVal := 0;
      FActiveEdit.Text := IntToHex(DecVal, 2);
      DoEditChanged;
    end;
end;

procedure TcaRGBSpinEdit.SetColorFormat(AValue: TcaColorFormat);
begin
  if FColorFormat = AValue then Exit;
  FColorFormat := AValue;
end;

procedure TcaRGBSpinEdit.SetColorValue(AValue: TColor);
begin
  FColorValue := AValue;
  if not FSettingEdits then
    UpdateColorCells;
end;

procedure TcaRGBSpinEdit.SetPrefix(AValue: Char);
begin
  FPrefix.Caption := AValue;
end;

function TcaRGBSpinEdit.GetRedCell: TEdit;
begin
  case FColorFormat of
    cfRGB:  Result := FEdits[0];
    cfBGR:  Result := FEdits[2];
  end;
end;

function TcaRGBSpinEdit.GetGreenCell: TEdit;
begin
  Result := FEdits[1];
end;

function TcaRGBSpinEdit.GetBlueCell: TEdit;
begin
  case FColorFormat of
    cfRGB:  Result := FEdits[2];
    cfBGR:  Result := FEdits[0];
  end;
end;

procedure TcaRGBSpinEdit.UpdateColorCells;
var
  HexColor: string;
begin
  HexColor := IntToHex(FColorValue, 6);
  // IntToHex returns colors in #BGR format
  GetBlueCell.Text := Copy(HexColor, 1, 2);
  GetGreenCell.Text := Copy(HexColor, 3, 2);
  GetRedCell.Text := Copy(HexColor, 5, 2);
end;

procedure TcaRGBSpinEdit.UpdateHeights;
var
  Edit: TEdit;
begin
  for Edit in FEdits do
    Edit.Height := Self.Height;
  FPrefix.Height := Self.Height;
end;

procedure TcaRGBSpinEdit.UpdateSize;
begin
  Height := 23;
  Width := 109;
  Constraints.MinHeight := 23;
  Constraints.MaxHeight := 23;
  Constraints.MinWidth := 109;
  Constraints.MaxWidth := 109;
end;

procedure TcaRGBSpinEdit.Loaded;
begin
  inherited Loaded;
end;

procedure TcaRGBSpinEdit.CreateWnd;
begin
  inherited CreateWnd;
  UpdateSize;
end;

end.

