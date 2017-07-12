unit cafontselectorlist;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs;

type

  { TcaFontSelectorForm }

  TcaFontSelectorForm = class(TForm)
    procedure FormDblClick(Sender: TObject);
  private

  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  caFontSelectorForm: TcaFontSelectorForm;

implementation

{$R *.lfm}

{ TcaFontSelectorForm }

procedure TcaFontSelectorForm.FormDblClick(Sender: TObject);
begin
  Close;
end;

constructor TcaFontSelectorForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  BorderIcons := [];
  BorderStyle := bsNone;
  FormStyle := fsStayOnTop;
  ShowInTaskBar := stNever;
  ControlStyle := ControlStyle - [csSetCaption];
end;

end.

