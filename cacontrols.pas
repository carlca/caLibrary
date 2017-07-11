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

unit caControls;

interface

uses

  // FPC units
  Classes,
  Messages,
  Controls,
  Sysutils,
  Graphics,
  Forms,
  ExtCtrls,
  Dialogs,
  caClasses,
  caUtils,
  caDbg;

type

  TcaPaintEvent = procedure(Sender: TObject; ACanvas: TCanvas; ARect: TRect) of object;

  TcaClickOutsideEvent = procedure(Sender: TObject; AClickedControl: TControl) of object;

// TcaCustomPanel

  TcaCustomPanel = class(TCustomPanel)
  private
    // Private fields
    FOnClickOutside: TcaClickOutsideEvent;
    FOnMouseEnter: TNotifyEvent;
    FOnMouseLeave: TNotifyEvent;
    // Component mesage handlers
    procedure CMMouseenter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseleave(var Message: TMessage); message CM_MOUSELEAVE;
  protected
    // Protected methods
    procedure CreateWnd; override;
    procedure DoMouseEnter; virtual;
    procedure DoMouseLeave; virtual;
    // Protected properties
    property OnMouseEnter: TNotifyEvent read FOnMouseEnter write FOnMouseEnter;
    property OnMouseLeave: TNotifyEvent read FOnMouseLeave write FOnMouseLeave;
    // Protected event properties 
    property OnClickOutside: TcaClickOutsideEvent read FOnClickOutside write FOnClickOutside;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

// TcaPanel

  TcaPanel = class(TcaCustomPanel)
  public
    // TCustomPanel
    property DockManager;
  published
    // Event properties
    property OnClickOutside;
    // TCustomPanel
    property Align;
    property Alignment;
    property Anchors;
    property AutoSize;
    property BiDiMode;
    property BorderWidth;
    property BorderStyle;
    property Caption;
    property Color;
    property Constraints;
    property UseDockManager default True;
    property DockSite;
    property DoubleBuffered;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property FullRepaint;
    property Font;
    property ParentBiDiMode;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    // Event properties
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
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnStartDock;
    property OnStartDrag;
    property OnUnDock;
  end;

// TcaFormPanel

  TcaFormCreateEvent = procedure(Sender: TObject; var AForm: TForm) of object;

  TcaFormShowEvent = procedure(Sender: TObject; AForm: TForm) of object;

  TcaCustomFormPanel = class(TcaPanel)
  private
    // Private fields 
    FForm: TForm;
    // Event property fields 
    FOnBeforeShowForm: TcaFormShowEvent;
    FOnCreateForm: TcaFormCreateEvent;
    // Private methods 
    procedure UpdateChildForm;
  protected
    // Protected methods 
    procedure CreateWnd; override;
    procedure DoCreateForm(var AForm: TForm); virtual;
    procedure DoBeforeShowForm(AForm: TForm); virtual;
    // Event properties 
    property OnCreateForm: TcaFormCreateEvent read FOnCreateForm write FOnCreateForm;
    property OnBeforeShowForm: TcaFormShowEvent read FOnBeforeShowForm write FOnBeforeShowForm;
  public
    // Public methods 
    procedure CreateChildForm(AForm: TForm); overload;
    procedure CreateChildForm(AFormClass: TFormClass); overload;
  end;

// TcaFormPanel

  TcaFormPanel = class(TcaCustomFormPanel)
  published
    // TcaCustomFormPanel event properties 
    property OnCreateForm;
    // Promoted properties 
    property Align;
    property Alignment;
    property Anchors;
    property AutoSize;
    property BiDiMode;
    property BorderWidth;
    property BorderStyle;
    // property Caption;
    property Color;
    property Constraints;
    property UseDockManager default True;
    property DockSite;
    property DoubleBuffered;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property FullRepaint;
    property Font;
    property ParentBiDiMode;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    // Event properties 
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
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnStartDock;
    property OnStartDrag;
    property OnUnDock;
  end;

  { TcaControlUtils }

  TcaControlUtils = class
  public
    class procedure SetExclusiveColor(AControl: TControl; AParent: TWinControl; AClass: TControlClass;
      AColor, ADefaultColor: TColor);
  end;

  ControlUtils = class(TcaControlUtils);

implementation

// TcaCustomPanel

constructor TcaCustomPanel.Create(AOwner: TComponent);
begin
  inherited;
end;

destructor TcaCustomPanel.Destroy;
begin
  inherited;
end;

// Protected methods

procedure TcaCustomPanel.CreateWnd;
begin
  inherited;
end;

procedure TcaCustomPanel.DoMouseEnter;
begin
  if Assigned(FOnMouseEnter) then FOnMouseEnter(Self);
end;

procedure TcaCustomPanel.DoMouseLeave;
begin
  if Assigned(FOnMouseLeave) then FOnMouseLeave(Self);
end;

// Component mesage handlers

procedure TcaCustomPanel.CMMouseenter(var Message: TMessage);
begin
  inherited;
  DoMouseEnter;
end;

procedure TcaCustomPanel.CMMouseleave(var Message: TMessage);
begin
  inherited;
  DoMouseLeave;
end;

// TcaCustomFormPanel

// Public methods

procedure TcaCustomFormPanel.CreateChildForm(AForm: TForm);
begin
  FForm := AForm;
  UpdateChildForm;
end;

procedure TcaCustomFormPanel.CreateChildForm(AFormClass: TFormClass);
begin
  FForm := AFormClass.Create(Application);
  UpdateChildForm;
end;

// Protected methods

procedure TcaCustomFormPanel.CreateWnd;
begin
  inherited;
  UpdateChildForm;
end;

procedure TcaCustomFormPanel.DoBeforeShowForm(AForm: TForm);
begin
  if Assigned(FOnBeforeShowForm) then FOnBeforeShowForm(Self, FForm);
end;

procedure TcaCustomFormPanel.DoCreateForm(var AForm: TForm);
begin
  if Assigned(FOnCreateForm) then FOnCreateForm(Self, FForm);
end;

// Private methods

procedure TcaCustomFormPanel.UpdateChildForm;
begin
  if not Assigned(FForm) then
    if Assigned(FOnCreateForm) then FOnCreateForm(Self, FForm);
  if FForm <> nil then
    begin
      FForm.BorderStyle := bsNone;
      FForm.BorderIcons := [];
      FForm.Caption := '';
      FForm.Align := alClient;
      FForm.Parent := Self;
      DoBeforeShowForm(FForm);
      FForm.Show;
    end;
end;

{ TcaControlUtils }

class procedure TcaControlUtils.SetExclusiveColor(AControl: TControl; AParent: TWinControl; AClass: TControlClass;
  AColor, ADefaultColor: TColor);
var
  Comp: TComponent;
  Index: Integer;
  OwnedComps: TcaOwnedComponents;
begin
  OwnedComps := TcaOwnedComponents.Create(AParent);
  for Index := 0 to Pred(OwnedComps.Count) do
    begin
      Comp := OwnedComps.Components[Index];
      if Comp is AClass then
        begin
          if Comp <> AControl then
            TControl(Comp).Color := ADefaultColor;
        end;
    end;
  TControl(AControl).Color := AColor;
end;

end.


