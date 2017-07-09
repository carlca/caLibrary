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

unit caListBox;

{$mode objfpc}{$H+}

interface

{$IFDEF WINDOWS}

uses

// FPC units
  Classes, SysUtils, StdCtrls, Windows, Controls, Graphics,
  // Needed to avoid hassle overriding DrawItem
  LclType, Clipbrd,

// caLibrary units
  caUtils, caVector, caObserver, caTypes;

{.$define DBG}

type

// TcaListBoxEdit

  TcaCustomListBox = class;

  TcaListBoxEdit = class(TEdit)
  private
    // Private fields
    FListBox: TcaCustomListBox;
    // Private methods
    procedure EscapePressed;
    procedure ReturnPressed;
  protected
    // Protected methods
    procedure DoExit; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
  public
    // Public properties
    property ListBox: TcaCustomListBox read FListBox write FListBox;
  end;

// TcaCustomListBox

  TcaCustomListBox = class(TCustomListBox, IcaObserver)
  private
    // Property fields
    FAlternateColor: TColor;
    FDisplayMethod: TcaDisplayMethod;
    FVector: TcaVectorBase;
    // Private fields
    FInplaceEditor: TcaListBoxEdit;
    FIsEditing: Boolean;
    FMaxDecPlaces: Integer;
    FMaxStrLength: Integer;
    FVectorType: TcaVectorType;
    // Private methods
    function GetDecPlaces(const ANumStr: string): Integer;
    procedure CopyData;
    procedure CutData;
    procedure PasteData;
    procedure RecreateVector;
    // Property methods
    procedure SetAlternateColor(AValue: TColor);
    procedure SetDisplayMethod(AValue: TcaDisplayMethod);
    procedure SetVectorType(AValue: TcaVectorType);
  protected
    // Protected methods
    procedure DrawItem(Index: Integer; ARect: TRect; State: TOwnerDrawState); override;
    procedure DblClick; override;
    procedure FinishEditing(ASaveEdit: Boolean);
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure StartEditing;
    procedure SynchronizeItems;
    // IcaObserver
    procedure IcaObserver.Update = UpdateObserver;
    procedure UpdateObserver(AMessage: TcaSubjectMessage);
  public
    // Create/Destroy
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    // Public overridden methods
    function GetDefaultColor(const DefaultColorType: TDefaultColorType): TColor; override;
    // Public properties to be promoted
    property AlternateColor: TColor read FAlternateColor write SetAlternateColor;
    property DisplayMethod: TcaDisplayMethod read FDisplayMethod write SetDisplayMethod;
    property Vector: TcaVectorBase read FVector;
    property VectorType: TcaVectorType read FVectorType write SetVectorType;
  end;

// TcaListBox

  TcaListBox = class(TcaCustomListBox)
  published
    // Published properties
    property Align;
    property AlternateColor;
    property Anchors;
    property BidiMode;
    property BorderSpacing;
    property BorderStyle;
    property ClickOnSelChange;
    property Color;
    // property Columns;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property ExtendedSelect;
    property Enabled;
    property Font;
    property IntegralHeight;
    property Items;
    property ItemHeight;
    property ItemIndex;
    property MultiSelect;
    property OnChangeBounds;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnDrawItem;
    property OnEnter;
    property OnEndDrag;
    property OnExit;
    property OnKeyPress;
    property OnKeyDown;
    property OnKeyUp;
    property OnMeasureItem;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnResize;
    property OnSelectionChange;
    property OnShowHint;
    property OnStartDrag;
    property OnUTF8KeyPress;
    property ParentBidiMode;
    property ParentColor;
    property ParentShowHint;
    property ParentFont;
    property PopupMenu;
    property ScrollWidth;
    property ShowHint;
    property Sorted;
    // property Style;
    property TabOrder;
    property TabStop;
    property TopIndex;
    property VectorType;
    property Visible;
  end;

{$ENDIF}

implementation

{$IFDEF WINDOWS}

// TcaListBoxEdit

// Protected methods

procedure TcaListBoxEdit.DoExit;
begin
  inherited DoExit;
  FListBox.FinishEditing(True);
end;

procedure TcaListBoxEdit.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited KeyDown(Key, Shift);
  if Key = VK_RETURN then
    ReturnPressed;
  if Key = VK_ESCAPE then
    EscapePressed;
end;

// Private methods

procedure TcaListBoxEdit.EscapePressed;
begin
  FListBox.FinishEditing(False);
end;

procedure TcaListBoxEdit.ReturnPressed;
begin
  FListBox.FinishEditing(True);
end;

// TcaCustomListBox

// Create/Destroy

constructor TcaCustomListBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FAlternateColor := clWindow;
  FInplaceEditor := TcaListBoxEdit.Create(nil);
  FInplaceEditor.ListBox := Self;
  FInplaceEditor.BorderStyle := bsNone;
  FInplaceEditor.Visible := False;
  FInplaceEditor.Parent := Self;
  Style := lbOwnerDrawFixed;
  FDisplayMethod := dmNumeric;
  RecreateVector;
end;

destructor TcaCustomListBox.Destroy;
begin
  FInplaceEditor.Free;
  FVector.Free;
  inherited Destroy;
end;

// Public overridden methods

function TcaCustomListBox.GetDefaultColor(const DefaultColorType: TDefaultColorType): TColor;
begin
  Result := inherited GetDefaultColor(DefaultColorType);
end;

// Protected methods

procedure TcaCustomListBox.DblClick;
begin
  inherited DblClick;
  StartEditing;
end;

procedure TcaCustomListBox.DrawItem(Index: Integer; ARect: TRect; State: TOwnerDrawState);
var
  OldBrushStyle: TBrushStyle;
  OldTextStyle: TTextStyle;
  BackColor: TColor;
  WideStr, PadStr: string;

  procedure SaveOldStyles;
  begin
    OldBrushStyle := Canvas.Brush.Style;
    OldTextStyle := Canvas.TextStyle;
  end;

  function GetStyle: TTextStyle;
  begin
    if UseRightToLeftAlignment then
      Result.Alignment := taRightJustify
    else
      Result.Alignment := taLeftJustify;
    Result.Layout := tlCenter;
    Result.RightToLeft := UseRightToLeftReading;
  end;

  procedure AdjustRect;
  begin
    if UseRightToLeftAlignment then
      ARect.Right := ARect.Right - 2
    else
      ARect.Left := ARect.Left + 2;
  end;

  procedure RestoreOldStyles;
  begin
    Canvas.Brush.Style := OldBrushStyle;
    Canvas.TextStyle := OldTextStyle;
  end;

begin
  if Assigned(OnDrawItem) then
    OnDrawItem(Self, Index, ARect, State)
  else
    begin
      if not (odPainted in State) then
        begin
          if odSelected in State then
            BackColor := clHighlight
          else
            begin
              if MathUtils.IsOdd(Index) then
                BackColor := Color
              else
                BackColor := FAlternateColor;
            end;
          Canvas.Brush.Color := BackColor;
          Canvas.Brush.Style := bsSolid;
          Canvas.FillRect(ARect);
          if (Index >= 0) and (Index < Items.Count) then
            begin
              if FDisplayMethod = dmNumeric then
                begin
                  // FMaxDecPlaces FMaxStrLength
                  WideStr := StringUtils.BuildString(#32, FMaxStrLength);
                  ARect.Left := Canvas.TextWidth(WideStr + '.');
                  PadStr := StringUtils.BuildString(#32, FMaxStrLength - Length(Items[Index]));
                  Canvas.TextRect(ARect, ARect.Left, ARect.Top, PadStr + Items[Index]);
                end
              else
                begin
                  SaveOldStyles;
                  Canvas.TextStyle := GetStyle;
                  AdjustRect;
                  Canvas.TextRect(ARect, ARect.Left, ARect.Top, Items[Index]);
                  RestoreOldStyles;
                end;
            end;
        end;
    end;
end;

procedure TcaCustomListBox.FinishEditing(ASaveEdit: Boolean);
begin
  if ASaveEdit then
    Items[ItemIndex] := FInplaceEditor.Text;
  FInplaceEditor.Visible := False;
  FIsEditing := False;
end;

procedure TcaCustomListBox.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited KeyDown(Key, Shift);
  // Ctrl key presses
  if Shift = [ssCtrl] then
    case Key of
      VK_C:               CopyData;
      VK_INSERT:          CopyData;
      VK_V:               PasteData;
      VK_X:               CutData;
    end;
  // Shift key presses
  if Shift = [ssShift] then
    case Key of
      VK_DELETE:          CutData;
      VK_INSERT:          PasteData;
    end;
  // Unadorned key presses
  if Shift = [] then
    case Key of
      VK_RETURN:          StartEditing;
    end;
end;

procedure TcaCustomListBox.StartEditing;
var
  EditRect: TRect;
begin
  EditRect := ItemRect(ItemIndex);
  OffsetRect(EditRect, -1 ,0);
  FInplaceEditor.BoundsRect := EditRect;
  if MathUtils.IsOdd(ItemIndex) then
    FInplaceEditor.Color := Color
  else
    FInplaceEditor.Color := FAlternateColor;
  FInplaceEditor.Text := Items[ItemIndex];
  FInplaceEditor.SelectAll;
  FInplaceEditor.Visible := True;
  FInplaceEditor.SetFocus;
  FIsEditing := True;
end;

procedure TcaCustomListBox.SynchronizeItems;
var
  DecPlaces: Integer;
  NumStr: string;
  PadStr: string;
  Str: string;
begin
  FDisplayMethod := dmNumeric;
  Items.BeginUpdate;
  Items.Clear;
  // Have to do this as a two-pass process
  // Firstly calculate the greatest number of
  // significant decimal places
  FVector.ResetIterator;
  FMaxDecPlaces := 0;
  while FVector.HasMore do
    begin
      DecPlaces := GetDecPlaces(FVector.NextAsString);
      FMaxDecPlaces := Max(FMaxDecPlaces, DecPlaces);
    end;
  // Secondly pad out the decimal part, if any, with
  // zeroes to ensure all numbers have the same number of
  // decimal places
  FMaxStrLength := 0;
  FVector.ResetIterator;
  while FVector.HasMore do
    begin
      NumStr := FVector.NextAsString;
      DecPlaces := GetDecPlaces(NumStr);
      PadStr := '';
      if DecPlaces < FMaxDecPlaces then
        PadStr := StringUtils.BuildString('0', FMaxDecPlaces - DecPlaces);
      Str := NumStr + PadStr;
      FMaxStrLength := Max(FMaxStrLength, Length(Str));
      Items.Add(Str);
    end;
  Items.EndUpdate;
end;

// IcaObserver

procedure TcaCustomListBox.UpdateObserver(AMessage: TcaSubjectMessage);
begin
  if AMessage = smSynchronize then
    SynchronizeItems;
end;

// Private methods

function TcaCustomListBox.GetDecPlaces(const ANumStr: string): Integer;
begin
  Result := 0;
  if Pos('.', ANumStr) > 0 then
    Result := Length(ANumStr) - Pos('.', ANumStr);
end;

procedure TcaCustomListBox.CopyData;
begin
  Clipboard.AsText := Items[ItemIndex];
end;

procedure TcaCustomListBox.CutData;
begin
  Clipboard.AsText := Items[ItemIndex];
  Items[ItemIndex] := '';
end;

procedure TcaCustomListBox.PasteData;
begin
  Items[ItemIndex] := Clipboard.AsText;
end;

procedure TcaCustomListBox.RecreateVector;
begin
  FreeAndNil(FVector);
  case FVectorType of
    vtDouble:   FVector := TcaDoubleVector.Create;
    vtInt64:    FVector := TcaInt64Vector.Create;
    vtInteger:  FVector := TcaIntegerVector.Create;
    vtSingle:   FVector := TcaSingleVector.Create;
    vtUInt32:   FVector := TcaUInt32Vector.Create;
    vtUInt64:   FVector := TcaUInt64Vector.Create;
  end;
  FVector.GetSubject.Attach(Self);
end;

// Property methods

procedure TcaCustomListBox.SetAlternateColor(AValue: TColor);
begin
  if FAlternateColor = AValue then Exit;
  FAlternateColor := AValue;
  Invalidate;
end;

procedure TcaCustomListBox.SetDisplayMethod(AValue: TcaDisplayMethod);
begin
  if FDisplayMethod = AValue then Exit;
  FDisplayMethod := AValue;
  Invalidate;
end;

procedure TcaCustomListBox.SetVectorType(AValue: TcaVectorType);
begin
  if FVectorType = AValue then Exit;
  FVectorType := AValue;
  RecreateVector;
end;

{$ENDIF}

end.

