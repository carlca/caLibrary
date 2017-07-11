unit cafontselecter;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Controls, Graphics, ExtCtrls, StdCtrls, ComCtrls, LCLType, Forms,
  caspeedbutton, caUtils, caControls;

type

  { TcaFontSelecter }

  TcaFontSelecter = class(TCustomPanel)
  private
    FLabel: TLabel;
    FFontEdit: TEdit;
    FLabelWidth: Integer;
    FDropDownBtn: TcaSpeedButton;
    FDialogBtn: TcaSpeedButton;
    FFontSizeEdit: TEdit;
    FFontSizeUpDown: TUpDown;
    FSelectedFont: TFont;
    procedure CreateChildControls;
    function GetLabelCaption: string;
    function GetLabelWidth: Integer;
    procedure PositionChildControls;
    procedure SetLabelCaption(AValue: string);
    procedure SetLabelWidth(AValue: Integer);
    procedure LabelFontChangeEvent(Sender: TObject);
    procedure InitSelectedFontProperties;
    procedure UpdateSelectedFontProperties;
    procedure UpDownClickEvent(Sender: TObject; Button: TUDBtnType);
    procedure EditChangeEvent(Sender: TObject);
    procedure EditEnterEvent(Sender: TObject);
    procedure EditLeaveEvent(Sender: TObject);
    procedure EditKeyPressEvent(Sender: TObject; var Key: char);
  protected
    procedure CreateWnd; override;
    procedure BoundsChanged; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property LabelCaption: string read GetLabelCaption write SetLabelCaption;
    property LabelWidth: Integer read GetLabelWidth write SetLabelWidth;
    property SelectedFont: TFont read FSelectedFont;
    // inherited properties
    property Font;
    property Left;
    property Top;
    property Width;
    property Height;
  end;

implementation

{ TcaFontSelecter }

constructor TcaFontSelecter.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  CreateChildControls;
  Width := 300;
  Height := 24;
  SetLabelWidth(100);
  SetLabelCaption('Label Caption');
  FSelectedFont := TFont.Create;
  InitSelectedFontProperties;
  UpdateSelectedFontProperties;
end;

destructor TcaFontSelecter.Destroy;
begin
  FSelectedFont.Free;
  inherited Destroy;
end;

procedure TcaFontSelecter.CreateChildControls;
begin
  // Label
  FLabel := TLabel.Create(Self);
  FLabel.Parent := Self;
  FLabel.AutoSize := False;
  FLabel.Alignment := taRightJustify;
  FLabel.Font.Size := 10;
  FLabel.Font.OnChange := @LabelFontChangeEvent;
  // FontEdit
  FFontEdit := TEdit.Create(Self);
  FFontEdit.Name := 'FontEdit';
  FFontEdit.Parent := Self;
  FFontEdit.Text :=  'Lucida Grande';
  FFontEdit.Cursor := crIBeam;
  FFontEdit.HideSelection := True;
  FFontEdit.AutoSelect := False;
  FFontEdit.ReadOnly := True;
  FFontEdit.OnEnter := @EditEnterEvent;
  // DropDownBtn
  FDropDownBtn := TcaSpeedButton.Create(Self);
  FDropDownBtn.Parent := Self;
  FDropDownBtn.Caption := #$E2#$96#$BC; // down arrow
  FDropDownBtn.Font.Size := 6;
  FDropDownBtn.Cursor := crArrow;
  // DialogBtn
  FDialogBtn := TcaSpeedButton.Create(Self);
  FDialogBtn.Parent := Self;
  FDialogBtn.Caption := #$E2#$80#$A6; // elipsis
  FDialogBtn.Font.Size := 8;
  FDialogBtn.Font.Style := [fsBold];
  FDialogBtn.Cursor := crArrow;
  // FontSizeEdit
  FFontSizeEdit := TEdit.Create(Self);
  FFontSizeEdit.Name := 'FontSizeEdit';
  FFontSizeEdit.Parent := Self;
  FFontSizeEdit.Cursor := crIBeam;
  FFontSizeEdit.HideSelection := True;
  FFontSizeEdit.AutoSelect := False;
  FFontSizeEdit.ReadOnly := True;
  FFontSizeEdit.MaxLength := 2;
  FFontSizeEdit.ParentFont := False;
  FFontSizeEdit.Alignment := taCenter;
  FFontSizeEdit.OnChange := @EditChangeEvent;
  FFontSizeEdit.OnEnter := @EditEnterEvent;
  FFontSizeEdit.OnKeyPress := @EditKeyPressEvent;
  // FontSizeUpDown
  FFontSizeUpDown := TUpDown.Create(Self);
  FFontSizeUpDown.Parent := Self;
  FFontSizeUpDown.Cursor := crArrow;
  FFontSizeUpDown.OnClick := @UpDownClickEvent;
end;

function TcaFontSelecter.GetLabelCaption: string;
begin
  Result := FLabel.Caption;
end;

function TcaFontSelecter.GetLabelWidth: Integer;
begin
  Result := FLabelWidth;
end;

procedure TcaFontSelecter.PositionChildControls;
begin
  // Label
  FLabel.SetBounds(0, 0, FLabelWidth, Self.Height - 1);
  FLabel.Layout := tlCenter;
  FLabel.Alignment := taRightJustify;
  // FontEdit
  FFontEdit.SetBounds(FLabelWidth + 4, 0, Self.Width - (FLabelWidth + 4 + 16 + 16 + 24 + 14), Self.Height);
  // DropDownBtn
  FDropDownBtn.SetBounds(Self.Width - (16 + 16 + 24 + 14), 0, 16, 22);
  // DialogBtn
  FDialogBtn.SetBounds(Self.Width -        (16 + 24 + 14), 0, 16, 22);
  // FontSizeEdit
  FFontSizeEdit.SetBounds(Self.Width -          (24 + 14), 0, 24, 22);
  // FontSizeUpDown
  FFontSizeUpDown.SetBounds(Self.Width -              14,  0, 14, 22);
end;

procedure TcaFontSelecter.SetLabelCaption(AValue: string);
begin
  FLabel.Caption := AValue;
  PositionChildControls;
end;

procedure TcaFontSelecter.SetLabelWidth(AValue: Integer);
begin
  FLabelWidth := AValue;
  PositionChildControls;
end;

procedure TcaFontSelecter.LabelFontChangeEvent(Sender: TObject);
begin
  PositionChildControls;
end;

procedure TcaFontSelecter.InitSelectedFontProperties;
var
  FontData: TFontData;
  // PPI: Integer;
begin
  FontData := GetFontData(FLabel.Font.Handle);
  // PPI := Forms.Screen.PixelsPerInch;
  FontData.Height := -FontData.Height;  // GetFontData returns Height as a +ve value
  FSelectedFont.Name := FontData.Name;
  FSelectedFont.Size := 10; // -MulDiv(FontData.Height, 72, PPI) // This should give Size as a +ve valueend;
end;

procedure TcaFontSelecter.UpdateSelectedFontProperties;
begin
  FFontEdit.Text := FSelectedFont.Name;
  FFontSizeEdit.Text := IntToStr(FSelectedFont.Size);
end;

procedure TcaFontSelecter.UpDownClickEvent(Sender: TObject; Button: TUDBtnType);
begin
  case Button of
    btNext:   FSelectedFont.Size := FSelectedFont.Size + 1;
    btPrev:   FSelectedFont.Size := FSelectedFont.Size - 1;
  end;
  if FSelectedFont.Size < 0 then FSelectedFont.Size := 0;
  if FSelectedFont.Size > 99 then FSelectedFont.Size := 99;
  UpdateSelectedFontProperties;
end;

procedure TcaFontSelecter.EditChangeEvent(Sender: TObject);
begin
  FSelectedFont.Size := StrToInt(FFontSizeEdit.Text);
end;

procedure TcaFontSelecter.EditEnterEvent(Sender: TObject);
begin
  ControlUtils.SetExclusiveColor(Sender as TControl, Self, TEdit, clHighlight, clDefault);
end;

procedure TcaFontSelecter.EditLeaveEvent(Sender: TObject);
begin
  FFontSizeEdit.Color := clDefault;
  FFontSizeEdit.SelLength := 0;
end;

procedure TcaFontSelecter.EditKeyPressEvent(Sender: TObject; var Key: char);
begin
  Key := #0;
end;

procedure TcaFontSelecter.CreateWnd;
begin
  inherited CreateWnd;
  PositionChildControls;
end;

procedure TcaFontSelecter.BoundsChanged;
begin
  inherited BoundsChanged;
  if not (csLoading in ComponentState) then
    PositionChildControls;
end;

end.

