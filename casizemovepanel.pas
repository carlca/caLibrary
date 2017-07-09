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

unit caSizeMovePanel;

interface

{$IFDEF WINDOWS}
uses

// FPC units
  SysUtils,
  Windows,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  ComCtrls,
  ExtCtrls,
  Menus,
  Buttons,
  Types,
  DbugIntf,
  LResources,

// caLibrary units
  caControls,
  caDbg;

{.$define DBG}

type

// TcaSizeMovePanelState

  TcaSizeMovePanelState = (psCollapsed, psExpanded);

// TcaSizeMoveOption

  TcaSizeMoveOption = (smSizing, smMoving);

  TcaSizeMoveOptions = set of TcaSizeMoveOption;

// TcaSizeMoveBand

  TcaSizeMoveBand = class(TCustomControl);

// TcaSizingBand

  TcaSizingBand = class(TcaSizeMoveBand)
  protected
    procedure Paint; override;
  end;

// TcaMovingBand

  TcaMovingBand = class(TcaSizeMoveBand)
  protected
    procedure Paint; override;
  end;

// TcaSizeMovePanelCaptionProperties

  TcaSizeMovePanelCaptionProperties = class(TPersistent)
  private
    // Property fields
    FBrushColor: TColor;
    FFont: TFont;
    FText: TCaption;
    FTextBorderWidth: Integer;
    // Event property fields
    FOnChanged: TNotifyEvent;
    // Property methods
    procedure SetBrushColor(const Value: TColor);
    procedure SetFont(const Value: TFont);
    procedure SetText(const Value: TCaption);
    procedure SetTextBorderWidth(const Value: Integer);
    // Private methods
    procedure Changed;
    // Event handlers
    procedure FontChangedEvent(Sender: TObject);
  protected
    // Event triggers
    procedure DoChanged; virtual;
  public
    // Create/Destroy
    constructor Create;
    destructor Destroy; override;
    // Public methods
    procedure Assign(Source: TPersistent); override;
    // Event properties
    property OnChanged: TNotifyEvent read FOnChanged write FOnChanged;
  published
    // Published properties
    property BrushColor: TColor read FBrushColor write SetBrushColor;
    property Font: TFont read FFont write SetFont;
    property Text: TCaption read FText write SetText;
    property TextBorderWidth: Integer read FTextBorderWidth write SetTextBorderWidth;
  end;

// TcaSizeMoveButton                  // This class is used as a pseudo-button to avoid the
                                      // hassles involved in using, say, dynamically created
                                      // TSpeedButtons and all the attendent streaming issues.

  TcaSizeMoveButtonItem = class;

  TcaSizeMoveButton = class(TObject)
  private
    // Private fields
    FColor: TColor;
    FCollectionItem: TcaSizeMoveButtonItem;
    FHeight: Integer;
    FLeft: Integer;
    FTop: Integer;
    FWidth: Integer;
    FMouseIsDown: Boolean;
    // Property methods
    procedure SetMouseIsDown(AValue: Boolean);
  protected
    // Protected methods
    procedure DoClick; virtual;
  public
    // Create/Destroy
    constructor Create;
    destructor Destroy; override;
    // Public methods
    function GetBounds: TRect;
    function GetHitTestInfoAt(X, Y: Integer): THitTests;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
    // Public properties
    property Color: TColor read FColor write FColor;
    property CollectionItem: TcaSizeMoveButtonItem read FCollectionItem write FCollectionItem;
    property MouseIsDown: Boolean read FMouseIsDown write SetMouseIsDown;
    property Left: Integer read FLeft write FLeft;
    property Height: Integer read FHeight write FHeight;
    property Top: Integer read FTop write FTop;
    property Width: Integer read FWidth write FWidth;
  end;

// TcaSizeMoveButtonType

  TcaSizeMoveButtonType = (btCollapse, btClose, btClone, btUndefined);

// TcaSizeMoveButtonItem

  TcaSizeMovePanel = class;

  TcaSizeMoveButtonItem = class(TCollectionItem)
  private
    // Property fields
    FButton: TcaSizeMoveButton;
    FButtonType: TcaSizeMoveButtonType;
    FGlyph: TBitmap;
    FOnClick: TNotifyEvent;
    // Property methods
    procedure SetButtonType(AValue: TcaSizeMoveButtonType);
    procedure SetGlyph(AValue: TBitmap);
    // Private methods
    function OwnerPanel: TcaSizeMovePanel;
    procedure UpdateGlyph;
  protected
    // Protected methods
    procedure MouseClicked;
  public
    // Create/Destroy
    constructor Create(ACollection: TCollection); override;
    destructor Destroy; override;
    // Public fields
    property Button: TcaSizeMoveButton read FButton write FButton;
  published
    // Published properties
    property ButtonType: TcaSizeMoveButtonType read FButtonType write SetButtonType;
    property Glyph: TBitmap read FGlyph write SetGlyph;
    property OnClick: TNotifyEvent read FOnClick write FOnClick;
  end;

// TcaSizeMoveButtonCollection

  TcaSizeMoveButtonCollection = class(TCollection)
  private
    // Property fields
    FOwnerPanel: TcaSizeMovePanel;
    // Property methods
    function GetButton(Index: Integer): TcaSizeMoveButtonItem;
    procedure SetButton(Index: Integer; AValue: TcaSizeMoveButtonItem);
  protected
    // Protected methods
    procedure Update(Item: TCollectionItem); override;
  public
    // Public properties
    property Buttons[Index: Integer]: TcaSizeMoveButtonItem read GetButton write SetButton;
    property OwnerPanel: TcaSizeMovePanel read FOwnerPanel write FOwnerPanel;
  end;

// TcaSizeMovePanel

  TcaSizeMovePanel = class(TcaCustomFormPanel)
  private
    FButtonColor: TColor;
    // Private fields
    FMovingBands: array[1..4] of TcaMovingBand;
    FSizingBands: array[1..4] of TcaSizingBand;
    FCurX: Integer;
    FCurY: Integer;
    FFixX: Integer;
    FFixY: Integer;
    FMovX: Integer;
    FMovY: Integer;
    FMoving: Boolean;
    FSizing: Boolean;
    // Property fields
    FButtonCollection: TcaSizeMoveButtonCollection;
    FButtonList: TList;
    FCaptionProperties: TcaSizeMovePanelCaptionProperties;
    FMainControl: TWinControl;
    FMainGapBottom: Integer;
    FMainGapLeft: Integer;
    FMainGapRight: Integer;
    FMainGapTop: Integer;
    FMouseIsDown: Boolean;
    FShowGrabHandle: Boolean;
    FState: TcaSizeMovePanelState;
    FOptions: TcaSizeMoveOptions;
    FSizingPixels: Integer;
    FTempMainControl: TWinControl;
    FTrueHeight: Integer;
    // Event property fields
    FOnMovePanel: TNotifyEvent;
    FOnSizePanel: TNotifyEvent;
    // Property methods
    procedure SetButtonColor(AValue: TColor);
    procedure SetButtons(AValue: TcaSizeMoveButtonCollection);
    procedure SetCaptionProperties(const Value: TcaSizeMovePanelCaptionProperties);
    procedure SetMainControl(const Value: TWinControl);
    procedure SetMainGapBottom(const Value: Integer);
    procedure SetMainGapLeft(const Value: Integer);
    procedure SetMainGapRight(const Value: Integer);
    procedure SetMainGapTop(const Value: Integer);
    procedure SetShowGrabHandle(const Value: Boolean);
    procedure SetState(AValue: TcaSizeMovePanelState);
    // Private methods
    function CombinedButtonRect: TRect;
    function GetButton(AIndex: Integer): TcaSizeMoveButton;
    function GetNewHeight: Integer;
    function GetNewWidth: Integer;
    procedure AlignButtons;
    procedure AlignOneButton(AButton: TcaSizeMoveButton; AIndex: Integer);
    procedure CollapsePanel;
    procedure ExpandPanel;
    procedure FreeButtons;
    procedure FreeMovingBands;
    procedure FreeSizingBands;
    procedure MovingRectangle(X1, Y1: Integer);
    procedure SizingRectangle(X1, Y1, X2, Y2: Integer);
    procedure SynchronizeButtons;
    // Event handlers
    procedure CaptionPropertiesChangedEvent(Sender: TObject);
  protected
    // Protected methods
    procedure AlignControls(AControl: TControl; var Rect: TRect); override;
    procedure AlignMain; virtual;
    procedure DblClick; override;
    procedure DoBeforeShowForm(AForm: TForm); override;
    procedure DoMovePanel; virtual;
    procedure DoSizePanel; virtual;
    procedure Loaded; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure Paint; override;
  public
    // Create/Destroy
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    // Public methods
    procedure Resize; override;
    procedure SetBounds(ALeft: Integer; ATop: Integer; AWidth: Integer; AHeight: Integer); override;
    // Public properties
    property ButtonList: TList read FButtonList;
  published
    // New properties
    property ButtonColor: TColor read FButtonColor write SetButtonColor;
    property Buttons: TcaSizeMoveButtonCollection read FButtonCollection write SetButtons;
    property CaptionProperties: TcaSizeMovePanelCaptionProperties read FCaptionProperties write SetCaptionProperties;
    property MainControl: TWinControl read FMainControl write SetMainControl;
    property MainGapBottom: Integer read FMainGapBottom write SetMainGapBottom;
    property MainGapLeft: Integer read FMainGapLeft write SetMainGapLeft;
    property MainGapRight: Integer read FMainGapRight write SetMainGapRight;
    property MainGapTop: Integer read FMainGapTop write SetMainGapTop;
    property Options: TcaSizeMoveOptions read FOptions write FOptions;
    property ShowGrabHandle: Boolean read FShowGrabHandle write SetShowGrabHandle;
    property SizingPixels: Integer read FSizingPixels write FSizingPixels;
    property State: TcaSizeMovePanelState read FState write SetState;
    // New event properties
    property OnMovePanel: TNotifyEvent read FOnMovePanel write FOnMovePanel;
    property OnSizePanel: TNotifyEvent read FOnSizePanel write FOnSizePanel;
    // Promoted inherited properties
    // TcaCustomPanel
    property OnClickOutside;
    // TcaCustomFormPanel event properties
    property OnCreateForm;
    // TCustomPanel
    property Align;
    property Alignment;
    property Anchors;
    property AutoSize;
    property BiDiMode;
    property BorderStyle;
    property BorderWidth;
    property Color;
    property Constraints;
    property DockSite;
    property DoubleBuffered;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property FullRepaint;
    property ParentBiDiMode;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property UseDockManager default True;
    property Visible;
    // Promoted inherited event properties
    property OnClick;
    property OnConstrainedResize;
    property OnContextPopup;
    property OnDblClick;
    property OnDockDrop;
    property OnDockOver;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGetSiteInfo;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnStartDock;
    property OnStartDrag;
    property OnUnDock;
  end;

{$ENDIF}

implementation

{$IFDEF WINDOWS}

// TcaMovingBand

procedure TcaMovingBand.Paint;
var
  R: TRect;
begin
  inherited Paint;
  Canvas.Brush.Color := clRed;
  R := ClientRect;
  Canvas.FillRect(R);
end;

// TcaSizingBand

procedure TcaSizingBand.Paint;
var
  R: TRect;
begin
  inherited Paint;
  Canvas.Brush.Color := clTeal;
  R := ClientRect;
  Canvas.FillRect(R);
end;

// TcaSizeMovePanelCaptionProperties

// Create/Destroy

constructor TcaSizeMovePanelCaptionProperties.Create;
begin
  inherited;
  FFont := TFont.Create;
  FFont.OnChange := @FontChangedEvent;
end;

destructor TcaSizeMovePanelCaptionProperties.Destroy;
begin
  FFont.Free;
  inherited;
end;

// Public methods

procedure TcaSizeMovePanelCaptionProperties.Assign(Source: TPersistent);
var
  SourceProperties: TcaSizeMovePanelCaptionProperties;
begin
  if Source is TcaSizeMovePanelCaptionProperties then
    begin
      SourceProperties := TcaSizeMovePanelCaptionProperties(Source);
      FBrushColor := SourceProperties.BrushColor;
      FFont.Assign(SourceProperties.Font);
      FText := SourceProperties.Text;
      FTextBorderWidth := SourceProperties.TextBorderWidth;
    end
  else
    inherited;
end;

// Event triggers

procedure TcaSizeMovePanelCaptionProperties.DoChanged;
begin
  if Assigned(FOnChanged) then FOnChanged(Self);
end;

// Private methods

procedure TcaSizeMovePanelCaptionProperties.Changed;
begin
  DoChanged;
end;

// Event handlers

procedure TcaSizeMovePanelCaptionProperties.FontChangedEvent(Sender: TObject);
begin
  Changed;
end;

// Property methods

procedure TcaSizeMovePanelCaptionProperties.SetBrushColor(const Value: TColor);
begin
  if Value <> FBrushColor then
    begin
      FBrushColor := Value;
      Changed;
    end;
end;

procedure TcaSizeMovePanelCaptionProperties.SetFont(const Value: TFont);
begin
  FFont.Assign(Value);
  Changed;
end;

procedure TcaSizeMovePanelCaptionProperties.SetText(const Value: TCaption);
begin
  if Value <> FText then
    begin
      FText := Value;
      Changed;
    end;
end;

procedure TcaSizeMovePanelCaptionProperties.SetTextBorderWidth(const Value: Integer);
begin
  if Value <> FTextBorderWidth then
    begin
      FTextBorderWidth := Value;
      Changed;
    end;
end;

// TcaSizeMoveButtonItem

// Create/Destroy

constructor TcaSizeMoveButtonItem.Create(ACollection: TCollection);
begin
  inherited Create(ACollection);
  FGlyph := TBitmap.Create;
  FButtonType := btUndefined;
  UpdateGlyph;
end;

destructor TcaSizeMoveButtonItem.Destroy;
begin
  FGlyph.Free;
  inherited Destroy;
end;

// Protected methods

procedure TcaSizeMoveButtonItem.MouseClicked;
begin
  if FButtonType = btCollapse then
    begin
      if OwnerPanel.State = psExpanded then
        OwnerPanel.State := psCollapsed
      else
        OwnerPanel.State := psExpanded;
    end;
  if Assigned(FOnClick) then
    FOnClick(Self);
end;

// Private methods

function TcaSizeMoveButtonItem.OwnerPanel: TcaSizeMovePanel;
begin
  Result := TcaSizeMoveButtonCollection(Collection).OwnerPanel;
end;

procedure TcaSizeMoveButtonItem.UpdateGlyph;
var
  Custom: TCustomBitmap;
begin
  Custom := nil;
  case FButtonType of
    btUndefined:  FGlyph.Clear;
    btClone:          Custom := CreateBitmapFromLazarusResource('clone');
    btClose:          Custom := CreateBitmapFromLazarusResource('close');
    btCollapse:
      case OwnerPanel.State of
        psCollapsed:  Custom := CreateBitmapFromLazarusResource('expand');
        psExpanded:   Custom := CreateBitmapFromLazarusResource('collapse');
      end;
  end;
  try
    if Custom <> nil then
      FGlyph.Assign(Custom);
  finally
    if Custom <> nil then
      Custom.Free;
  end;
end;

// Property methods

procedure TcaSizeMoveButtonItem.SetButtonType(AValue: TcaSizeMoveButtonType);
begin
  if FButtonType = AValue then Exit;
  FButtonType := AValue;
  UpdateGlyph;
end;

procedure TcaSizeMoveButtonItem.SetGlyph(AValue: TBitmap);
begin
  FGlyph.Assign(AValue);
end;

// TcaSizeMoveButtonCollection

// Protected methods

procedure TcaSizeMoveButtonCollection.Update(Item: TCollectionItem);
begin
  inherited Update(Item);
  FOwnerPanel.SynchronizeButtons;
end;

// Property methods

function TcaSizeMoveButtonCollection.GetButton(Index: Integer): TcaSizeMoveButtonItem;
begin
  Result := TcaSizeMoveButtonItem(inherited GetItem(Index));
end;

procedure TcaSizeMoveButtonCollection.SetButton(Index: Integer; AValue: TcaSizeMoveButtonItem);
begin
  inherited SetItem(Index, AValue);
end;

// TcaSizeMoveButton

// Create/Destroy

constructor TcaSizeMoveButton.Create;
begin
  inherited;
end;

destructor TcaSizeMoveButton.Destroy;
begin
  inherited Destroy;
end;

// Public methods

function TcaSizeMoveButton.GetBounds: TRect;
begin
  Result := Bounds(Left, Top, Width, Height);
end;

function TcaSizeMoveButton.GetHitTestInfoAt(X, Y: Integer): THitTests;
begin
  Result := [];
  if PtInRect(GetBounds, Point(X, Y)) then
    Include(Result, htOnButton);
end;

procedure TcaSizeMoveButton.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  FLeft := ALeft;
  FTop := ATop;
  FWidth := AWidth;
  FHeight := AHeight;
end;

// Protected methods

procedure TcaSizeMoveButton.DoClick;
begin
  FCollectionItem.MouseClicked;
end;

// Property methods

procedure TcaSizeMoveButton.SetMouseIsDown(AValue: Boolean);
begin
  if FMouseIsDown = AValue then Exit;
  FMouseIsDown := AValue;
  if FMouseIsDown then
    DoClick;
end;

// TcaSizeMovePanel

// Create/Destroy

constructor TcaSizeMovePanel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FButtonCollection := TcaSizeMoveButtonCollection.Create(TcaSizeMoveButtonItem);
  FButtonCollection.OwnerPanel := Self;
  FButtonList := TList.Create;
  FCaptionProperties := TcaSizeMovePanelCaptionProperties.Create;
  FCaptionProperties.OnChanged := @CaptionPropertiesChangedEvent;
  ControlStyle := ControlStyle - [csSetCaption];
  FSizingPixels := 13;
  FMainGapLeft := 4;
  FMainGapRight := 4;
  FMainGapTop := 21;
  FMainGapBottom := 18;
  FOptions := [smSizing, smMoving];
  FState := psExpanded;
  FButtonColor := clSilver;
end;

destructor TcaSizeMovePanel.Destroy;
begin
  FreeButtons;
  FButtonCollection.Free;
  FButtonList.Free;
  FCaptionProperties.Free;
  inherited Destroy;
end;

// Public methods

procedure TcaSizeMovePanel.Resize;
begin
  inherited Resize;
  AlignMain;
  Invalidate;
end;

procedure TcaSizeMovePanel.SetBounds(ALeft: Integer; ATop: Integer; AWidth: Integer; AHeight: Integer);
begin
  inherited;
  if FState = psExpanded then
    FTrueHeight := AHeight;
end;

// Protected methods

procedure TcaSizeMovePanel.AlignControls(AControl: TControl; var Rect: TRect);
begin
  inherited AlignControls(AControl, Rect);
end;

procedure TcaSizeMovePanel.AlignMain;
begin
  if FMainControl <> nil then
    begin
      FMainControl.Left := FMainGapLeft;
      FMainControl.Width := ClientWidth - FMainGapLeft - FMainGapRight;
      FMainControl.Top := FMainGapTop;
      FMainControl.Height := ClientHeight - FMainGapTop - FMainGapBottom;
    end;
end;

procedure TcaSizeMovePanel.DblClick;
begin
  inherited DblClick;
  if State = psExpanded then State := psCollapsed else State := psExpanded;
end;

procedure TcaSizeMovePanel.DoMovePanel;
begin
  if Assigned(FOnMovePanel) then FOnMovePanel(Self);
end;

procedure TcaSizeMovePanel.DoBeforeShowForm(AForm: TForm);
begin
  SetMainControl(AForm);
  AForm.Align := alNone;
end;

procedure TcaSizeMovePanel.DoSizePanel;
begin
  if Assigned(FOnSizePanel) then FOnSizePanel(Self);
end;

procedure TcaSizeMovePanel.Loaded;
begin
  inherited;
  SynchronizeButtons;
  Resize;
end;

procedure TcaSizeMovePanel.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  OwnerForm: TWinControl;
  Index: Integer;
  PanelButton: TcaSizeMoveButton;

  procedure UpdateSizingCoords;
  var
    CaptionHeight: LongInt;
  begin
    CaptionHeight := GetSystemMetrics(SM_CYCAPTION);
    FFixX := ClientOrigin.x - OwnerForm.Left - 8;
    FFixY := ClientOrigin.y - CaptionHeight - OwnerForm.Top - 8;
    FMovX := FFixX + Width - 1;
    FMovY := FFixY + Height - 1;
    FCurX := X;
    FCurY := Y;
  end;

  procedure UpdateMovingCoords;
  begin
    FFixX := Left;
    FFixY := Top;
    FMovX := FFixX;
    FMovY := FFixY;
    FCurX := X;
    FCurY := Y;
  end;

  procedure UpdateSizeMoveBand(ABand: TcaSizeMoveBand);
  begin
    ABand.Visible := False;
    ABand.Parent := OwnerForm;
    ABand.Color := clBlack;
    ABand.Height := 1;
    ABand.Width := 1;
    ABand.Visible := True;
  end;

begin
  inherited MouseDown(Button, Shift, X, Y);
  {$ifdef DBG}DbgEnter('TcaSizeMovePanel.MouseDown');{$endif DBG}
  FMouseIsDown := True;
  for Index := 0 to Pred(FButtonList.Count) do
    begin
      PanelButton := GetButton(Index);
      PanelButton.MouseIsDown := PanelButton.GetHitTestInfoAt(X, Y) = [htOnButton];
    end;
  Invalidate;
  // BringToFront;
  if smSizing in FOptions then
    begin
      if (X > Width - FSizingPixels) and (Y > Height - FSizingPixels) then
        begin
          OwnerForm := Parent;
          UpdateSizingCoords;
          FSizing := True;
          for Index := 1 to 4 do
            begin
              FSizingBands[Index] := TcaSizingBand.Create(Owner);
              UpdateSizeMoveBand(FSizingBands[Index]);
            end;
          SizingRectangle(FFixX, FFixY, FMovX, FMovY);
        end;
    end;
  AlignButtons;
  if (not PtInRect(CombinedButtonRect, Point(X, Y))) and (smMoving in FOptions) and (not FSizing) then
    begin
      OwnerForm := Parent;
      UpdateMovingCoords;
      FSizing := False;
      FMoving := True;
      for Index := 1 to 4 do
        begin
          FMovingBands[Index] := TcaMovingBand.Create(Owner);
          UpdateSizeMoveBand(FMovingBands[Index]);
        end;
      MovingRectangle(Left, Top);
    end;
  {$ifdef DBG}DbgExit('TcaSizeMovePanel.MouseDown');{$endif DBG}
end;

procedure TcaSizeMovePanel.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  Index: Integer;
  Button: TcaSizeMoveButton;
begin
  inherited MouseMove(Shift, X, Y);
  {$ifdef DBG}DbgEnter('TcaSizeMovePanel.MouseMove');{$endif DBG}
  if FSizing then
    begin
      if not (akRight in Anchors) then
        begin
          Inc(FMovX, X - FCurX);
          FCurX := X;
        end;
      if not (akBottom in Anchors) then
        begin
          Inc(FMovY, Y - FCurY);
          FCurY := Y;
          SizingRectangle(FFixX, FFixY, FMovX, FMovY);
        end;
      DoSizePanel;
    end;
  if FMoving then
    begin
      Inc(FMovX, X - FCurX);
      FCurX := X;
      Inc(FMovY, Y - FCurY);
      FCurY := Y;
      MovingRectangle(FMovX, FMovY);
      DoMovePanel;
    end;
  if (not FSizing) and (not FMoving) then
    begin
      for Index := 0 to Pred(FButtonList.Count) do
        begin
          Button := GetButton(Index);
          Button.Color := FButtonColor;
          Invalidate;
        end;
    end;
  if FMouseIsDown and (Parent <> nil) then
    Parent.Invalidate;
  {$ifdef DBG}DbgExit('TcaSizeMovePanel.MouseMove');{$endif DBG}
end;

procedure TcaSizeMovePanel.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  Index: Integer;
  PanelButton: TcaSizeMoveButton;
begin
  inherited MouseUp(Button, Shift, X, Y);
  {$ifdef DBG}DbgEnter('TcaSizeMovePanel.MouseUp');{$endif DBG}
  FMouseIsDown := False;
  for Index := 0 to Pred(FButtonList.Count) do
    begin
      PanelButton := GetButton(Index);
      PanelButton.MouseIsDown := False;
    end;
  Invalidate;
  FreeMovingBands;
  FreeSizingBands;
  if FSizing and (smSizing in FOptions) then
    begin
      Width := GetNewWidth;
      Height := GetNewHeight;
      AlignMain;
      FSizing := False;
    end;
  if FMoving and (smMoving in FOptions) then
    begin
      Left := FMovX;
      Top := FMovY;
      AlignMain;
      FMoving := False;
    end;
  {$ifdef DBG}DbgExit('TcaSizeMovePanel.MouseUp');{$endif DBG}
end;

procedure TcaSizeMovePanel.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (MainControl = AComponent) then
    MainControl := nil;
end;

procedure TcaSizeMovePanel.Paint;

  procedure DoLine(C: TColor; Px: Integer);
  begin
    Canvas.Pen.Color := C;
    Canvas.MoveTo(Width - Px, Height - 4);
    Canvas.LineTo(Width - 3, Height - Px - 1);
  end;

  procedure DrawCaption;
  var
    TextH: Integer;
    CaptL: Integer;
    CaptR: Integer;
    CaptT: Integer;
    CaptB: Integer;
    Gap: Integer;
  begin
    Gap := FCaptionProperties.TextBorderWidth + 1;
    Canvas.Font.Assign(FCaptionProperties.Font);
    TextH := Canvas.TextHeight(FCaptionProperties.Text);
    CaptL := FMainGapLeft;
    CaptR := Width - Gap * 2 - 1;
    CaptT := 3;
    CaptB := CaptT + TextH + Gap * 2 - 1;
    Canvas.Brush.Color := FCaptionProperties.BrushColor;
    Canvas.FillRect(Rect(CaptL, CaptT, CaptR, CaptB));
    Canvas.Font.Assign(FCaptionProperties.Font);
    Canvas.TextOut(CaptL + Gap, CaptT + Gap, FCaptionProperties.Text);
  end;

  procedure DrawOneButton(AButton: TcaSizeMoveButton);
  var
    Glyph: TBitmap;
    DestRect: TRect;
    SourceRect: TRect;
  begin
    // Background
    Canvas.Brush.Color := AButton.Color;
    DestRect := Bounds(AButton.Left, AButton.Top, AButton.Width, AButton.Height);
    Canvas.FillRect(DestRect);
    // Glyph
    AButton.CollectionItem.UpdateGlyph;
    Glyph := AButton.CollectionItem.Glyph;
    SourceRect := Rect(0, 0, AButton.Width, AButton.Height);
    Canvas.CopyMode := cmSrcAnd;
    if AButton.MouseIsDown then
      OffsetRect(DestRect, 1, 1);
    Canvas.BrushCopy(DestRect, Glyph, SourceRect, AButton.Color);
  end;

  procedure DrawButtons;
  var
    Index: Integer;
  begin
    for Index := 0 to Pred(FButtonList.Count) do
      DrawOneButton(GetButton(Index));
  end;

begin
  inherited Paint;
  if FShowGrabHandle then
    begin
      DoLine(clDkGray, 13);
      DoLine(clDkGray, 9);
      DoLine(clDkGray, 5);
    end;
  DrawCaption;
  AlignButtons;
  DrawButtons;
end;

// Private methods

function TcaSizeMovePanel.CombinedButtonRect: TRect;
var
  Index: Integer;
begin
  Result := Rect(0, 0, 0, 0);
  if FButtonList.Count > 0 then
    begin
      Result := GetButton(0).GetBounds;
      for Index := 1 to Pred(FButtonList.Count) do
        UnionRect(Result, Result, GetButton(Index).GetBounds);
    end;
end;

function TcaSizeMovePanel.GetButton(AIndex: Integer): TcaSizeMoveButton;
begin
  Result := TcaSizeMoveButton(FButtonList[AIndex]);
end;

function TcaSizeMovePanel.GetNewHeight: Integer;
begin
  Result := FMovY - FFixY + 1;
end;

function TcaSizeMovePanel.GetNewWidth: Integer;
begin
  Result := FMovX - FFixX + 1;
end;

procedure TcaSizeMovePanel.AlignButtons;
var
  Index: Integer;
begin
  for Index := 0 to Pred(FButtonList.Count) do
    AlignOneButton(GetButton(Index), Index);
end;

procedure TcaSizeMovePanel.AlignOneButton(AButton: TcaSizeMoveButton; AIndex: Integer);
begin
  AButton.SetBounds(Width - 17 - (AIndex * 14), 5, 12, 12);
end;

procedure TcaSizeMovePanel.CollapsePanel;
begin
  FMainControl := nil;
  Height := 22;
end;

procedure TcaSizeMovePanel.ExpandPanel;
begin
  Height := FTrueHeight;
  FMainControl := FTempMainControl;
end;

procedure TcaSizeMovePanel.FreeButtons;
var
  Index: Integer;
begin
  for Index := 0 to Pred(FButtonList.Count) do
    GetButton(Index).Free;
end;

procedure TcaSizeMovePanel.FreeMovingBands;
var
  Index: Integer;
begin
  for Index := 1 to 4 do
    if FMovingBands[Index] <> nil then
      FreeAndNil(FMovingBands[Index]);
end;

procedure TcaSizeMovePanel.FreeSizingBands;
var
  Index: Integer;
begin
  for Index := 1 to 4 do
    if FSizingBands[Index] <> nil then
      FreeAndNil(FSizingBands[Index]);
end;

procedure TcaSizeMovePanel.MovingRectangle(X1, Y1: Integer);
begin
  // Left
  FMovingBands[1].SetBounds(X1, Y1, 1, Height);
  // Top
  FMovingBands[2].SetBounds(X1, Y1, Width, 1);
  // Right
  FMovingBands[3].SetBounds(X1 + Width, Y1, 1, Height);
  // Bottom
  FMovingBands[4].SetBounds(X1, Y1 + Height, Width, 1);
end;

procedure TcaSizeMovePanel.SizingRectangle(X1, Y1, X2, Y2: Integer);
begin
  // Left
  FSizingBands[1].SetBounds(X1, Y1, 1, Y2 - Y1 + 1);
  // Top
  FSizingBands[2].SetBounds(X1, Y1, X2 - X1 + 1, 1);
  // Right
  FSizingBands[3].SetBounds(X2, Y1, 1, FSizingBands[1].Height);
  // Bottom
  FSizingBands[4].SetBounds(X1, Y2, FSizingBands[2].Width, 1);
end;

procedure TcaSizeMovePanel.SynchronizeButtons;
var
  Index: Integer;
  Button: TcaSizeMoveButton;
  Item: TcaSizeMoveButtonItem;
begin
  // Safety check
  if csDestroying in ComponentState then Exit;
  // Clear out FButtonList
  {$ifdef DBG}Dbg('FButtonList.Count', FButtonList.Count);{$endif DBG}
  while FButtonList.Count > 0 do
    begin
      TcaSizeMoveButton(FButtonList[0]).Free;
      FButtonList.Delete(0);
    end;
  {$ifdef DBG}Dbg('FButtonList.Count', FButtonList.Count);{$endif DBG}
  // Recreate items in FButtonList to match FButtonCollection
  for Index := 0 to Pred(FButtonCollection.Count) do
    begin
      Item := FButtonCollection.GetButton(Index);
      Button := TcaSizeMoveButton.Create;
      Button.Color := FButtonColor;
      Button.CollectionItem := Item;
      Item.Button := Button;
      FButtonList.Add(Button);
    end;
  {$ifdef DBG}Dbg('FButtonCollection.Count', FButtonCollection.Count);{$endif DBG}
  {$ifdef DBG}Dbg('FButtonList.Count', FButtonList.Count);{$endif DBG}
  Repaint;
end;

// Event handlers

procedure TcaSizeMovePanel.CaptionPropertiesChangedEvent(Sender: TObject);
begin
  Invalidate;
end;

// Property methods

procedure TcaSizeMovePanel.SetCaptionProperties(const Value: TcaSizeMovePanelCaptionProperties);
begin
  FCaptionProperties.Assign(Value);
end;

procedure TcaSizeMovePanel.SetButtonColor(AValue: TColor);
begin
  if FButtonColor = AValue then Exit;
  FButtonColor := AValue;
  Invalidate;
end;

procedure TcaSizeMovePanel.SetButtons(AValue: TcaSizeMoveButtonCollection);
begin
  FButtonCollection.Assign(AValue);
end;

procedure TcaSizeMovePanel.SetMainControl(const Value: TWinControl);
begin
  if Value <> FMainControl then
    begin
      FMainControl := Value;
      FTempMainControl := FMainControl;
      if FMainControl <> nil then
        FMainControl.Parent := Self;
      AlignMain;
    end;
end;

procedure TcaSizeMovePanel.SetMainGapBottom(const Value: Integer);
begin
  if Value <> FMainGapBottom then
    begin
      FMainGapBottom := Value;
      AlignMain;
    end;
end;

procedure TcaSizeMovePanel.SetMainGapLeft(const Value: Integer);
begin
  if Value <> FMainGapLeft then
    begin
      FMainGapLeft := Value;
      AlignMain;
    end;
end;

procedure TcaSizeMovePanel.SetMainGapRight(const Value: Integer);
begin
  if Value <> FMainGapRight then
    begin
      FMainGapRight := Value;
      AlignMain;
    end;
end;

procedure TcaSizeMovePanel.SetMainGapTop(const Value: Integer);
begin
  if Value <> FMainGapTop then
    begin
      FMainGapTop := Value;
      AlignMain;
    end;
end;

procedure TcaSizeMovePanel.SetShowGrabHandle(const Value: Boolean);
begin
  if Value <> FShowGrabHandle then
    begin
      FShowGrabHandle := Value;
      Invalidate;
    end;
end;

procedure TcaSizeMovePanel.SetState(AValue: TcaSizeMovePanelState);
begin
  if AValue <> FState then
    begin
      FState := AValue;
      if FState = psCollapsed then
        CollapsePanel
      else
        ExpandPanel;
    end;
end;

initialization
  {$include casizemovepanel.lrs}

{$ENDIF}

end.
