unit cafontselector;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Controls, Graphics, ExtCtrls, StdCtrls, ComCtrls, LCLType, Forms,
  caspeedbutton, caUtils, caControls;

type

  TcaFontChangedEvent = procedure(Sender: TObject; AFont: TFont) of object;

  { TcaFontSelector }

  TcaFontSelector = class(TCustomPanel)
  private
    FLabel: TLabel;
    FFontEdit: TEdit;
    FLabelWidth: Integer;
    FDropDownBtn: TcaSpeedButton;
    FDialogBtn: TcaSpeedButton;
    FFontSizeEdit: TEdit;
    FFontSizeUpDown: TUpDown;
    FMonoSpaceOnly: Boolean;
    FSelectedFont: TFont;
    FFontNames: TStrings;
    FOnSelectedFontChanged: TcaFontChangedEvent;
    procedure CreateChildControls;
    procedure FontNameChangedEvent(Sender: TObject; const AFontName: string);
    function GetLabelCaption: string;
    function GetLabelWidth: Integer;
    procedure PositionChildControls;
    procedure SelectedFontChangeEvent(Sender: TObject);
    procedure SetLabelCaption(AValue: string);
    procedure SetLabelWidth(AValue: Integer);
    procedure LabelFontChangeEvent(Sender: TObject);
    procedure InitSelectedFontProperties;
    procedure SetMonoSpaceOnly(AValue: Boolean);
    procedure SetSelectedFont(AValue: TFont);
    procedure UpDownClickEvent(Sender: TObject; Button: TUDBtnType);
    procedure EditChangeEvent(Sender: TObject);
    procedure EditEnterEvent(Sender: TObject);
    procedure EditLeaveEvent(Sender: TObject);
    procedure EditKeyPressEvent(Sender: TObject; var Key: char);
    procedure DropDownClickEvent(Sender: TObject);
    procedure DialogBtnClickEvent(Sender: TObject);
  protected
    procedure CreateWnd; override;
    procedure BoundsChanged; override;
    procedure DoSelectedFontChanged; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property LabelCaption: string read GetLabelCaption write SetLabelCaption;
    property LabelWidth: Integer read GetLabelWidth write SetLabelWidth;
    property SelectedFont: TFont read FSelectedFont write SetSelectedFont;
    property MonoSpaceOnly: Boolean read FMonoSpaceOnly write SetMonoSpaceOnly;
    property OnSelectedFontChanged: TcaFontChangedEvent read FOnSelectedFontChanged write FOnSelectedFontChanged;
    // inherited properties
    property Font;
    property Left;
    property Top;
    property Width;
    property Height;
  end;

implementation

uses
  cafontSelectorlist;

{ TcaFontSelector }

constructor TcaFontSelector.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FFontNames := TStringList.Create;
  FSelectedFont := TFont.Create;
  FSelectedFont.OnChange := @SelectedFontChangeEvent;
  CreateChildControls;
  Width := 300;
  Height := 24;
  SetLabelWidth(100);
  SetLabelCaption('Label Caption');
  InitSelectedFontProperties;
end;

destructor TcaFontSelector.Destroy;
begin
  FFontNames.Free;
  FSelectedFont.Free;
  inherited Destroy;
end;

procedure TcaFontSelector.CreateChildControls;
begin
  // Label
  FLabel := TLabel.Create(Self);
  FLabel.Parent := Self;
  FLabel.AutoSize := False;
  FLabel.Alignment := taRightJustify;
  FLabel.Font.Size := 10;
  FLabel.Font.OnChange := @LabelFontChangeEvent;
  // FontEdit
  FFontEdit := TEdit.Create(Parent);
  FFontEdit.Parent := Self;
  FFontEdit.Text :=  '';
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
  FDropDownBtn.OnClick := @DropDownClickEvent;
  // DialogBtn
  FDialogBtn := TcaSpeedButton.Create(Self);
  FDialogBtn.Parent := Self;
  FDialogBtn.Caption := #$E2#$80#$A6; // elipsis
  FDialogBtn.Font.Size := 8;
  FDialogBtn.Font.Style := [fsBold];
  FDialogBtn.Cursor := crArrow;
  FDialogBtn.OnClick := @DialogBtnClickEvent;
  // FontSizeEdit
  FFontSizeEdit := TEdit.Create(Self);
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

procedure TcaFontSelector.FontNameChangedEvent(Sender: TObject; const AFontName: string);
begin
  FSelectedFont.Name := AFontName;
end;

function TcaFontSelector.GetLabelCaption: string;
begin
  Result := FLabel.Caption;
end;

function TcaFontSelector.GetLabelWidth: Integer;
begin
  Result := FLabelWidth;
end;

procedure TcaFontSelector.PositionChildControls;
begin
  if Assigned(FLabel) then
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
end;

procedure TcaFontSelector.SelectedFontChangeEvent(Sender: TObject);
begin
  FFontEdit.Text := FSelectedFont.Name;
  FFontSizeEdit.Text := IntToStr(FSelectedFont.Size);
  DoSelectedFontChanged;
end;

procedure TcaFontSelector.SetLabelCaption(AValue: string);
begin
  FLabel.Caption := AValue;
  PositionChildControls;
end;

procedure TcaFontSelector.SetLabelWidth(AValue: Integer);
begin
  FLabelWidth := AValue;
  PositionChildControls;
end;

procedure TcaFontSelector.LabelFontChangeEvent(Sender: TObject);
begin
  PositionChildControls;
end;

procedure TcaFontSelector.InitSelectedFontProperties;
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

procedure TcaFontSelector.SetMonoSpaceOnly(AValue: Boolean);
var
  FontName: string;
begin
  FMonoSpaceOnly := AValue;
  if not (csDesigning in ComponentState) then
    begin
      if FMonoSpaceOnly then
        begin
          FFontNames.Clear;
          for FontName in Screen.Fonts do
            begin
              Canvas.Font.Name := FontName;
              Canvas.Font.Size := 10;
              if Canvas.TextWidth('mmm') = Canvas.TextWidth('iii') then
                FFontNames.Add(FontName);
            end;
        end
      else
        FFontNames.Assign(Screen.Fonts);
    end;
end;

procedure TcaFontSelector.SetSelectedFont(AValue: TFont);
begin
  FSelectedFont.Assign(AValue);
end;

procedure TcaFontSelector.UpDownClickEvent(Sender: TObject; Button: TUDBtnType);
begin
  FFontSizeEdit.SetFocus;
  case Button of
    btNext:   FSelectedFont.Size := FSelectedFont.Size + 1;
    btPrev:   FSelectedFont.Size := FSelectedFont.Size - 1;
  end;
  if FSelectedFont.Size < 0 then FSelectedFont.Size := 0;
  if FSelectedFont.Size > 99 then FSelectedFont.Size := 99;
end;

procedure TcaFontSelector.EditChangeEvent(Sender: TObject);
begin
  FSelectedFont.Size := StrToInt(FFontSizeEdit.Text);
end;

procedure TcaFontSelector.EditEnterEvent(Sender: TObject);
begin
  ControlUtils.SetExclusiveColor(Sender as TControl, Parent, TEdit, clHighlight, clDefault);
end;

procedure TcaFontSelector.EditLeaveEvent(Sender: TObject);
begin
  FFontSizeEdit.Color := clDefault;
  FFontSizeEdit.SelLength := 0;
end;

procedure TcaFontSelector.EditKeyPressEvent(Sender: TObject; var Key: char);
begin
  Key := #0;
end;

procedure TcaFontSelector.DropDownClickEvent(Sender: TObject);
var
  DropDownForm: TcaFontSelectorForm;
begin
  FFontEdit.SetFocus;
  DropDownForm := TcaFontSelectorForm.Create(nil);
  try
    DropDownForm.FontNames := FFontNames;
    DropDownForm.Left := FFontEdit.ClientOrigin.X;
    DropDownForm.Top := FFontEdit.ClientOrigin.Y + FFontEdit.Height - 3;
    DropDownForm.Width := FFontEdit.Width + 32;
    DropDownForm.SelectedFontName := FSelectedFont.Name;
    DropDownForm.OnFontNameChanged := @FontNameChangedEvent;
    DropDownForm.ShowModal;
  finally
    DropDownForm.Free;
  end;
end;

procedure TcaFontSelector.DialogBtnClickEvent(Sender: TObject);
begin
  FFontEdit.SetFocus;
end;

procedure TcaFontSelector.CreateWnd;
begin
  inherited CreateWnd;
  PositionChildControls;
end;

procedure TcaFontSelector.BoundsChanged;
begin
  inherited BoundsChanged;
  PositionChildControls;
end;

procedure TcaFontSelector.DoSelectedFontChanged;
begin
  if Assigned(FOnSelectedFontChanged) then FOnSelectedFontChanged(Self, FSelectedFont);
end;

end.

