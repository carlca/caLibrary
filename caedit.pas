unit caEdit;

// This code is based on TAviLabeledEdit by @Avishai, to whom, thanks :)

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, StdCtrls, ExtCtrls;

type

  TcaLabelPosition = (lpAbove, lpBelow, lpLeft, lpRight);

  TcaEdit = class(TCustomControl)

  private
    { Private declarations }
    FLabelPosition: TcaLabelPosition;
    FLabelSpacing: Integer;
    FALabel: TLabel;
    FACaption: TCaption;
    FAEdit: TEdit;
    FAFieldWidth: Integer;
    FAText: shortstring;
    procedure SetLabelSpacing(const Value: Integer);
    procedure SetLabelPosition(const Value: TcaLabelPosition);
    procedure DoPositionLabel;
    procedure OnCaptionChanged(const Value: TCaption);
    procedure onTextChanged(const Value: shortstring);
    procedure SetFieldWidth(const Value: Integer);
  protected
    { Protected declarations }
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
  published
    { Published declarations }
    property AEdit: TEdit read FAEdit;
    property ALabel: TLabel read FALabel;
    property Align;
    property Anchors;
    property BiDiMode;
    property Caption: TCaption read FACaption write OnCaptionChanged;
    property Color;
    property Constraints;
    property Enabled;
    property FieldWidth: Integer read FAFieldWidth write SetFieldWidth default 100;
    property Font;
    property LabelPosition: TcaLabelPosition read FLabelPosition write SetLabelPosition;
    property LabelSpacing: Integer read FLabelSpacing write SetLabelSpacing default 3;
    property OnEnter;
    property OnExit;
    property OnClick;
    property OnDblClick;
    property OnEditingDone;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property ParentBiDiMode;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop default True;
    property Text: shortstring read FAText write onTextChanged;
    property Visible;
  end;

implementation

constructor TcaEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FALabel := TLabel.Create(Self);
  FLabelPosition := lpLeft;
  FALabel.Parent := Self;
  FALabel.SetSubComponent(True);
  FALabel.Align := alTop;
  FALabel.Layout := tlCenter;
  FALabel.Name := 'caLabel';
  FALabel.Caption := FALabel.Name;

  FAEdit := TEdit.Create(Self);
  FAEdit.Parent := Self;
  FAEdit.SetSubComponent(True);
  FAEdit.Align := alBottom;
  FAEdit.Name := 'caEdit';
  FAEdit.Text := '';
  FAText := FAEdit.Text;
  FAFieldWidth := FAEdit.Width;

  FALabel.ControlStyle := FALabel.ControlStyle - [csNoDesignSelectable];
  FAEdit.ControlStyle := FAEdit.ControlStyle - [csNoDesignSelectable];

  LabelSpacing := 1;
  Height := FALabel.Height + FAEdit.Height + LabelSpacing;
  SetLabelSpacing(LabelSpacing);
  Width := 100;
  FAFieldWidth := Width;
end;

procedure TcaEdit.DoPositionLabel;
var
  edtHeight: Integer;
  edtWidth: Integer;
begin
  edtHeight := FAEdit.Height;
  edtWidth := FAEdit.Width;
  case FLabelPosition of
    lpAbove:
    begin
      Width := edtWidth;
      FALabel.Align := alTop;
      FAEdit.Align := alBottom;
      Height := FAEdit.Height + FALabel.Height + FLabelSpacing;
    end;
    lpBelow:
    begin
      Width := edtWidth;
      FALabel.Align := alBottom;
      FAEdit.Align := alTop;
      Height := FAEdit.Height + FALabel.Height + FLabelSpacing;
    end;
    lpLeft:
    begin
      Height := edtHeight;
      FALabel.Align := alLeft;
      FAEdit.Align := alRight;
      FAEdit.Width := edtWidth;
      Width := FAEdit.Width + FALabel.Width + FLabelSpacing;
      FAEdit.Top := FAEdit.Top + 1;
    end;
    lpRight:
    begin
      Height := edtHeight;
      FALabel.Align := alRight;
      FAEdit.Align := alLeft;
      FAEdit.Width := edtWidth;
      Width := FAEdit.Width + FALabel.Width + FLabelSpacing;
    end;
  end;
end;

procedure TcaEdit.SetLabelPosition(const Value: TcaLabelPosition);
begin
  if Value = FLabelPosition then exit;
  FLabelPosition := Value;
  DoPositionLabel;
end;

procedure TcaEdit.SetLabelSpacing(const Value: Integer);
begin
  if Value = FLabelSpacing then exit;
  FLabelSpacing := Value;
  DoPositionLabel;
end;

procedure TcaEdit.OnCaptionChanged(const Value: TCaption);
begin
  if Value = FACaption then exit;
  FACaption := Value;
  FALabel.Caption := FACaption;
  if (LabelPosition = lpLeft) or (LabelPosition = lpRight) then
    DoPositionLabel;
end;

procedure TcaEdit.onTextChanged(const Value: shortstring);
begin
  if Value = FAText then exit;
  FAText := Value;
  FAEdit.Text := FAText;
end;

procedure TcaEdit.SetFieldWidth(const Value: Integer);
var
  CurRight: Integer;
begin
  if Value = FAFieldWidth then exit;
  FAFieldWidth := Value;
  CurRight := Left + Width;
  if (LabelPosition = lpAbove) or (LabelPosition = lpBelow) then
    Width := Value
  else
    FAEdit.Width := FAFieldWidth;
  if (akRight in Anchors) and not (akLeft in Anchors) then
  begin
    Left := CurRight - Width;
  end;
  DoPositionLabel;
end;

end.
