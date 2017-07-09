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

unit caTypes;

interface

uses

// FPC units 
  Classes;

type

// Array types

  TcaWordBoolArray = array[Boolean] of Word;

  TcaIntBoolArray = array[Boolean] of Integer;

  TcaDoubleBoolArray = array[Boolean] of Double;

// Dynamic array definitions

  TcaPointerArray = array of Pointer;

  TcaPointerArray2 = array of array of Pointer;

  TcaObjectArray = array of TObject;

  TcaObjectArray2 = array of array of TObject;

  TcaIntegerArray = array of Integer;

  TcaIntegerArray2 = array of array of Integer;

  TcaDoubleArray = array of Double;

  TcaDoubleArray2 = array of array of Double;

  TcaExtendedArray = array of Extended;

  TcaExtendedArray2 = array of array of Extended;

  TcaStringArray = array of String;

  TcaStringArray2 = array of array of String;

// ShortString types

  String10 = String[10];
  String20 = String[20];
  String30 = String[30];
  String40 = String[40];
  String50 = String[50];
  String60 = String[60];
  String70 = String[70];
  String80 = String[80];
  String90 = String[90];
  String100 = String[100];
  String110 = String[110];
  String120 = String[120];
  String130 = String[130];
  String140 = String[140];
  String150 = String[150];
  String160 = String[160];
  String170 = String[170];
  String180 = String[180];
  String190 = String[190];
  String200 = String[200];
  String210 = String[210];
  String220 = String[220];
  String230 = String[230];
  String240 = String[240];
  String250 = String[250];

// GUID support

  TcaUniqueID = string[32];

// Time types

  TcaTimePoint = packed record
    Year: Word;
    Month: Word;
    Day: Word;
    Hour: Word;
    Min: Word;
    Sec: Word;
    MSec: Word;
  end;

// Enumerated types and sets

  TcaCellType = (ctNil, ctMany, ctBoolean, ctDateTime, ctDouble, ctInteger, ctInt64,
                 ctMemo, ctObject, ctSingle, ctString, ctUInt32, ctUInt64);

  TcaCellTypes = set of TcaCellType;

  TcaXMLTagType = (ttStart, ttEnd, ttEmpty, ttText);

  TcaCompareResult = (crFirstGreater, crSecondGreater, crEqual, crUndefined);

  TcaSortDirection = (sdAscending, sdDescending);

  TcaSubjectMessage = (smSynchronize);

  TcaDisplayMethod = (dmNumeric, dmText);

  // TcaArrayStringsAlignment = (saLeft, saRight, saPreZero);
  //
  // TcaButtonLayout = (laGlyphLeftCentered, laGlyphLeft, laGlyphRight, laGlyphTop, laGlyphBottom, laTextLeft, laTextRight);
  //
  // TcaButtonState = (bsUp, bsDisabled, bsDown, bsExclusive);
  //
  // TcaButtonStyle = (bsDefault, bsThin, bsFlat, bsNoEdge);
  //
  // TcaFrameStyle = (fsLowered, fsRaised, fsLoweredPanel, fsRaisedPanel, fsLine);
  //
  // TcaNumGlyphs = 1..2;
  //
  // TcaSide = (sdLeft, sdTop, sdRight, sdBottom);
  //
  // TcaSides = set of TcaSide;
  //
  // TcaTextStyle = (tsNormal, tsRaised, tsLowered);
  //
  // TcaMenuState = (meBig, meSmall);
  //
  // TcaSizeBarBtnPosition = (spTop, spCenter, spBottom);
  //
  // TcaSizeBarKind = (sbHorizontal, sbVertical);
  //
  // TcaSizeBarState = (bsBig, bsSmall);
  //
  // TcaSizeBarArrows = (baLeftRight, baRightLeft, baUpDown, baDownUp);
  //
  // TcaArrowType = (atLeft, atRight, atUp, atDown);
  //
  // TcaLetterCase = (caLower, caUpper, caAny);
  //
  // TcaMsgDialogResponse = (mgNone, mgAbort, mgYes, mgOk, mgRetry, mgNo, mgCancel, mgIgnore, mgAll);
  //
  // TcaChartAxisType = (caLeft, caRight, caTop, caBottom);
  //
  // TcaOperatorPrecedence = (opHigher, opLower, opSameLeftAssoc, opSameRightAssoc);
  //
  // TcaTrigUnits = (tuDegrees, tuRadians);
  //
  // TcaColorColumn = (ccColor, ccName, ccHue, ccSaturation, ccValue, ccIntensity, ccLightness, ccYic);
  //
  // TcaNodeCheckState = (csFullyUnChecked, csSemiChecked, csFullyChecked);
  //
  // TcaNodeMatchAction = (maCheck, maClear);
  //
  // TcaNodeMatchMode = (mmMatch, mmLevel, mmAll);
  //
  // TcaNumberType = (ntInteger, ntFloat);
  //
  // TcaCaptionMode = (cmText, cmNumber);
  //
  // TcaByteSet = set of Byte;
  //
  // TcaMathOperation = (moAdd, moDivide, moMultiply, moSubtract);
  //
  // TcaMessageDialogResponse = (drFirst, drSecond, drThird, drUndefined);
  //
  // TcaWinVersion = (wvUnknown, wvWin95, wvWin98, wvWinNT, wvWin2K, wvWinXP);
  //
  // TcaOperator = (opEqual, opLessThan, opGreaterThan, opNotEqual, opGreaterThanOrEqual,
  //                opLessThanOrEqual, opUnspecified);
  //
  // TcaShowWindow = (swHide, swMaximize, swMinimize, swRestore, swShow, swShowDefault, swShowMaximized,
  //                 swShowMinimized, swShowMinNoActive, swShowNA, swShowNoActivate, swShowNormal);
  //
  //  TcaConjunction = (coAnd, coOr);

implementation

end.
