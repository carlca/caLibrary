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

// TcaColorUtils

class function TcaColorUtils.ColorAsString(AColor: TColor): string;
begin
  case AColor of
    TColor($000000):                                          Result := 'clBlack';
    TColor($000080):                                          Result := 'clMaroon';
    TColor($008000):                                          Result := 'clGreen';
    TColor($008080):                                          Result := 'clOlive';
    TColor($800000):                                          Result := 'clNavy';
    TColor($800080):                                          Result := 'clPurple';
    TColor($808000):                                          Result := 'clTeal';
    TColor($808080):                                          Result := 'clGray';
    TColor($C0C0C0):                                          Result := 'clSilver';
    TColor($0000FF):                                          Result := 'clRed';
    TColor($00FF00):                                          Result := 'clLime';
    TColor($00FFFF):                                          Result := 'clYellow';
    TColor($FF0000):                                          Result := 'clBlue';
    TColor($FF00FF):                                          Result := 'clFuchsia';
    TColor($FFFF00):                                          Result := 'clAqua';
    TColor($FFFFFF):                                          Result := 'clWhite';

    TColor($C0DCC0):                                          Result := 'clMoneyGreen';
    TColor($F0CAA6):                                          Result := 'clSkyBlue';
    TColor($F0FBFF):                                          Result := 'clCream';
    TColor($A4A0A0):                                          Result := 'clMedGray';

    TColor(SYS_COLOR_BASE or COLOR_SCROLLBAR):                Result := 'clScrollBar';
    TColor(SYS_COLOR_BASE or COLOR_BACKGROUND):               Result := 'clBackground';
    TColor(SYS_COLOR_BASE or COLOR_ACTIVECAPTION):            Result := 'clActiveCaption';
    TColor(SYS_COLOR_BASE or COLOR_INACTIVECAPTION):          Result := 'clInactiveCaption';
    TColor(SYS_COLOR_BASE or COLOR_MENU):                     Result := 'clMenu';
    TColor(SYS_COLOR_BASE or COLOR_WINDOW):                   Result := 'clWindow';
    TColor(SYS_COLOR_BASE or COLOR_WINDOWFRAME):              Result := 'clWindowFrame';
    TColor(SYS_COLOR_BASE or COLOR_MENUTEXT):                 Result := 'clMenuText';
    TColor(SYS_COLOR_BASE or COLOR_WINDOWTEXT):               Result := 'clWindowText';
    TColor(SYS_COLOR_BASE or COLOR_CAPTIONTEXT):              Result := 'clCaptionText';
    TColor(SYS_COLOR_BASE or COLOR_ACTIVEBORDER):             Result := 'clActiveBorder';
    TColor(SYS_COLOR_BASE or COLOR_INACTIVEBORDER):           Result := 'clInactiveBorder';
    TColor(SYS_COLOR_BASE or COLOR_APPWORKSPACE):             Result := 'clAppWorkspace';
    TColor(SYS_COLOR_BASE or COLOR_HIGHLIGHT):                Result := 'clHighlight';
    TColor(SYS_COLOR_BASE or COLOR_HIGHLIGHTTEXT):            Result := 'clHighlightText';
    TColor(SYS_COLOR_BASE or COLOR_BTNFACE):                  Result := 'clBtnFace';
    TColor(SYS_COLOR_BASE or COLOR_BTNSHADOW):                Result := 'clBtnShadow';
    TColor(SYS_COLOR_BASE or COLOR_GRAYTEXT):                 Result := 'clGrayText';
    TColor(SYS_COLOR_BASE or COLOR_BTNTEXT):                  Result := 'clBtnText';
    TColor(SYS_COLOR_BASE or COLOR_INACTIVECAPTIONTEXT):      Result := 'clInactiveCaptionText';
    TColor(SYS_COLOR_BASE or COLOR_BTNHIGHLIGHT):             Result := 'clBtnHighlight';
    TColor(SYS_COLOR_BASE or COLOR_3DDKSHADOW):               Result := 'cl3DDkShadow';
    TColor(SYS_COLOR_BASE or COLOR_3DLIGHT):                  Result := 'cl3DLight';
    TColor(SYS_COLOR_BASE or COLOR_INFOTEXT):                 Result := 'clInfoText';
    TColor(SYS_COLOR_BASE or COLOR_INFOBK):                   Result := 'clInfoBk';

    TColor(SYS_COLOR_BASE or COLOR_HOTLIGHT):                 Result := 'clHotLight';
    TColor(SYS_COLOR_BASE or COLOR_GRADIENTACTIVECAPTION):    Result := 'clGradientActiveCaption';
    TColor(SYS_COLOR_BASE or COLOR_GRADIENTINACTIVECAPTION):  Result := 'clGradientInactiveCaption';
    TColor(SYS_COLOR_BASE or COLOR_MENUHILIGHT):              Result := 'clMenuHighlight';
    TColor(SYS_COLOR_BASE or COLOR_MENUBAR):                  Result := 'clMenuBar';
    TColor(SYS_COLOR_BASE or COLOR_FORM):                     Result := 'clForm';
  else
    Result := 'Unknown';
  end;
end;


