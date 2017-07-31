unit cafontselectorlist;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, LclType, LclIntf;

type

  TcaFontNameChangedEvent = procedure(Sender: TObject; const AFontName: string) of object;

  { TcaFontSelectorForm }

  TcaFontSelectorForm = class(TForm)
    FontList: TListBox;
    procedure FontListDblClick(Sender: TObject);
    procedure FontListKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
      );
    procedure FontListKeyPress(Sender: TObject; var Key: char);
    procedure FontListSelectionChange(Sender: TObject; User: boolean);
    procedure FormDblClick(Sender: TObject);
  private
    FFontNames: TStrings;
    FOnFontNameChanged: TcaFontNameChangedEvent;
    FSelectedFontName: string;
    function GetSelectedFontName: string;
    procedure SetFontNames(AValue: TStrings);
    procedure SetSelectedFontName(AValue: string);
    procedure UpdateFontList;
  protected
    procedure CreateWnd; override;
    procedure DoShow; override;
    procedure DoFontNameChanged; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property SelectedFontName: string read GetSelectedFontName write SetSelectedFontName;
    property FontNames: TStrings read FFontNames write SetFontNames;
    property OnFontNameChanged: TcaFontNameChangedEvent read FOnFontNameChanged write FOnFontNameChanged;
  end;

var
  caFontSelectorForm: TcaFontSelectorForm;

implementation

{$R *.lfm}

{ TcaFontSelectorForm }

constructor TcaFontSelectorForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  BorderIcons := [];
  BorderStyle := bsNone;
  FormStyle := fsStayOnTop;
  ShowInTaskBar := stNever;
  ControlStyle := ControlStyle - [csSetCaption];
  FontList.Items.Clear;
  Height := 194;
end;

destructor TcaFontSelectorForm.Destroy;
begin
  inherited Destroy;
end;

procedure TcaFontSelectorForm.DoShow;
begin
  inherited DoShow;
end;

procedure TcaFontSelectorForm.DoFontNameChanged;
begin
  if Assigned(FOnFontNameChanged) then FOnFontNameChanged(Self, FontList.Items[FontList.ItemIndex]);
end;

procedure TcaFontSelectorForm.FormDblClick(Sender: TObject);
begin
  Close;
end;

procedure TcaFontSelectorForm.SetFontNames(AValue: TStrings);
begin
  FontList.Items.Assign(AValue);
end;

procedure TcaFontSelectorForm.SetSelectedFontName(AValue: string);
begin
  FSelectedFontName := AValue;
end;

procedure TcaFontSelectorForm.UpdateFontList;
var
  Index: Integer;
begin
  Index := FontList.Items.IndexOf(FSelectedFontName);
  if Index >= 0 then
    begin
      FontList.ItemIndex := Index;
      FontList.MakeCurrentVisible;
    end;
end;

function TcaFontSelectorForm.GetSelectedFontName: string;
begin
  Result := '';
  if FontList.ItemIndex >= 0 then
    Result := FontList.Items[FontList.ItemIndex];
end;

procedure TcaFontSelectorForm.CreateWnd;
begin
  inherited CreateWnd;
  UpdateFontList;
end;

procedure TcaFontSelectorForm.FontListDblClick(Sender: TObject);
begin
  Close;
end;

procedure TcaFontSelectorForm.FontListKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    begin
      UpdateFontList;
      Close;
    end;
  if Key = VK_RETURN then
    Close;
end;

procedure TcaFontSelectorForm.FontListKeyPress(Sender: TObject; var Key: char);
begin

end;

procedure TcaFontSelectorForm.FontListSelectionChange(Sender: TObject; User: boolean);
begin
  DoFontNameChanged;
end;

end.

