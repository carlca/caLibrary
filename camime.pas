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

unit caMime;

interface

uses

// FPC units
  Classes, SysUtils,

// caLibrary units
  caUtils;

type

// IcaMimeUtils

  IcaMimeUtils = interface
  ['{CFC0CC9A-AC2A-49CE-A0C8-FCD5D3BE254C}']
    // String Encoding & Decoding
    function MimeEncodeString(const S: AnsiString): AnsiString;
    function MimeEncodeStringNoCRLF(const S: AnsiString): AnsiString;
    function MimeDecodeString(const S: AnsiString): AnsiString;
    function TaggedMimeEncodeString(const S: AnsiString): AnsiString;
    function TaggedMimeDecodeString(const S: AnsiString): AnsiString;
    function IsTaggedMimeEncoded(const S: AnsiString): Boolean;
    // Size Functions
    function MimeEncodedSize(const InputSize: PtrUInt): PtrUInt;
    function MimeEncodedSizeNoCRLF(const InputSize: Cardinal): Cardinal;
    function MimeDecodedSize(const InputSize: PtrUInt): PtrUInt;
    procedure DecodeHttpBasicAuthentication(const BasicCredentials: AnsiString; out UserId, PassWord: AnsiString);
    // Encoding Core
    procedure MimeEncode(const InputBuffer; const InputByteCount: Cardinal; out OutputBuffer);
    procedure MimeEncodeFullLines(const InputBuffer; const InputByteCount: Cardinal; out OutputBuffer);
    procedure MimeEncodeNoCRLF(const InputBuffer; const InputByteCount: Cardinal; out OutputBuffer);
    // Decoding Core
    function MimeDecode(const InputBuffer; const InputBytesCount: Cardinal; out OutputBuffer): Cardinal;
    function MimeDecodePartial(const InputBuffer; const InputBytesCount: Cardinal; out OutputBuffer; var ByteBuffer: Cardinal; var ByteBufferSpace: Cardinal): Cardinal;
    function MimeDecodePartialEnd(out OutputBuffer; const ByteBuffer: Cardinal; const ByteBufferSpace: Cardinal): Cardinal;
  end;

// TcaMimeUtils

  TcaMimeUtils = class(TInterfacedObject, IcaMimeUtils)
  // Protected methods
  protected
    // String Encoding & Decoding
    function MimeEncodeString(const S: AnsiString): AnsiString;
    function MimeEncodeStringNoCRLF(const S: AnsiString): AnsiString;
    function MimeDecodeString(const S: AnsiString): AnsiString;
    function TaggedMimeEncodeString(const S: AnsiString): AnsiString;
    function TaggedMimeDecodeString(const S: AnsiString): AnsiString;
    function IsTaggedMimeEncoded(const S: AnsiString): Boolean;
    // Size Functions
    function MimeEncodedSize(const InputSize: PtrUInt): PtrUInt;
    function MimeEncodedSizeNoCRLF(const InputSize: Cardinal): Cardinal;
    function MimeDecodedSize(const InputSize: PtrUInt): PtrUInt;
    procedure DecodeHttpBasicAuthentication(const BasicCredentials: AnsiString;
              out UserId, PassWord: AnsiString);
    // Encoding Core
    procedure MimeEncode(const InputBuffer; const InputByteCount: Cardinal; out OutputBuffer);
    procedure MimeEncodeFullLines(const InputBuffer; const InputByteCount: Cardinal; out OutputBuffer);
    procedure MimeEncodeNoCRLF(const InputBuffer; const InputByteCount: Cardinal; out OutputBuffer);
    // Decoding Core
    function MimeDecode(const InputBuffer; const InputBytesCount: Cardinal; out OutputBuffer): Cardinal;
    function MimeDecodePartial(const InputBuffer; const InputBytesCount: Cardinal;
             out OutputBuffer; var ByteBuffer: Cardinal; var ByteBufferSpace: Cardinal): Cardinal;
    function MimeDecodePartialEnd(out OutputBuffer; const ByteBuffer: Cardinal;
             const ByteBufferSpace: Cardinal): Cardinal;
  end;

  // CoMimeUtilsFactory

    CoMimeUtilsFactory = class
    public
      class function Instance: IcaMimeUtils;
    end;

  var
    MimeUtils: IcaMimeUtils = nil;

const
  MIME_ENCODED_LINE_BREAK = 76;
  MIME_DECODED_LINE_BREAK = MIME_ENCODED_LINE_BREAK div 4 * 3;
  MIME_TAG = 'MIME_ENCODED';

implementation

const
  MIME_ENCODE_TABLE: array[0..63] of Byte = (
    065, 066, 067, 068, 069, 070, 071, 072, //  00 - 07
    073, 074, 075, 076, 077, 078, 079, 080, //  08 - 15
    081, 082, 083, 084, 085, 086, 087, 088, //  16 - 23
    089, 090, 097, 098, 099, 100, 101, 102, //  24 - 31
    103, 104, 105, 106, 107, 108, 109, 110, //  32 - 39
    111, 112, 113, 114, 115, 116, 117, 118, //  40 - 47
    119, 120, 121, 122, 048, 049, 050, 051, //  48 - 55
    052, 053, 054, 055, 056, 057, 043, 047); // 56 - 63

  MIME_PAD_CHAR = Byte('=');

  MIME_DECODE_TABLE: array[Byte] of Cardinal = (
    255, 255, 255, 255, 255, 255, 255, 255, //   0 -   7
    255, 255, 255, 255, 255, 255, 255, 255, //   8 -  15
    255, 255, 255, 255, 255, 255, 255, 255, //  16 -  23
    255, 255, 255, 255, 255, 255, 255, 255, //  24 -  31
    255, 255, 255, 255, 255, 255, 255, 255, //  32 -  39
    255, 255, 255, 062, 255, 255, 255, 063, //  40 -  47
    052, 053, 054, 055, 056, 057, 058, 059, //  48 -  55
    060, 061, 255, 255, 255, 255, 255, 255, //  56 -  63
    255, 000, 001, 002, 003, 004, 005, 006, //  64 -  71
    007, 008, 009, 010, 011, 012, 013, 014, //  72 -  79
    015, 016, 017, 018, 019, 020, 021, 022, //  80 -  87
    023, 024, 025, 255, 255, 255, 255, 255, //  88 -  95
    255, 026, 027, 028, 029, 030, 031, 032, //  96 - 103
    033, 034, 035, 036, 037, 038, 039, 040, // 104 - 111
    041, 042, 043, 044, 045, 046, 047, 048, // 112 - 119
    049, 050, 051, 255, 255, 255, 255, 255, // 120 - 127
    255, 255, 255, 255, 255, 255, 255, 255,
    255, 255, 255, 255, 255, 255, 255, 255,
    255, 255, 255, 255, 255, 255, 255, 255,
    255, 255, 255, 255, 255, 255, 255, 255,
    255, 255, 255, 255, 255, 255, 255, 255,
    255, 255, 255, 255, 255, 255, 255, 255,
    255, 255, 255, 255, 255, 255, 255, 255,
    255, 255, 255, 255, 255, 255, 255, 255,
    255, 255, 255, 255, 255, 255, 255, 255,
    255, 255, 255, 255, 255, 255, 255, 255,
    255, 255, 255, 255, 255, 255, 255, 255,
    255, 255, 255, 255, 255, 255, 255, 255,
    255, 255, 255, 255, 255, 255, 255, 255,
    255, 255, 255, 255, 255, 255, 255, 255,
    255, 255, 255, 255, 255, 255, 255, 255,
    255, 255, 255, 255, 255, 255, 255, 255);

type
  PByte4 = ^TByte4;
  TByte4 = packed record
    b1: Byte;
    b2: Byte;
    b3: Byte;
    b4: Byte;
  end;

  PByte3 = ^TByte3;
  TByte3 = packed record
    b1: Byte;
    b2: Byte;
    b3: Byte;
  end;

// TcaMimeUtils

// String Encoding & Decoding

function TcaMimeUtils.MimeEncodeString(const S: AnsiString): AnsiString;
var
  L: PtrUInt;
  PtrS: PtrUInt;
  PredPtrS: PtrUInt;
  PredS: Pointer;
begin
  if Pointer(S) <> nil then
    begin
      PtrS := Utils.PtrToUInt(@S);
      PredPtrS := PtrS - SizeOf(PtrUInt);
      //PredS := (Utils.UIntToPtr(PredPtrS))^;
      //L := Utils.PtrToUInt((Utils.UIntToPtr(PredPtrS)^);
      SetLength(Result, MimeEncodedSize(L));
      MimeEncode(Pointer(S)^, L, Pointer(Result)^);
    end
  else
    Result := '';
end;

function TcaMimeUtils.MimeEncodeStringNoCRLF(const S: AnsiString): AnsiString;
var
  L: Cardinal;
begin
  if Pointer(S) <> nil then
    begin
      L := PCardinal(Cardinal(@S) - 4)^;
      SetLength(Result, MimeEncodedSizeNoCRLF(L));
      MimeEncodeNoCRLF(Pointer(S)^, L, Pointer(Result)^);
    end
  else
    Result := '';
end;

function TcaMimeUtils.MimeDecodeString(const S: AnsiString): AnsiString;
var
  ByteBuffer, ByteBufferSpace: Cardinal;
  L: Cardinal;
begin
  if Pointer(S) <> nil then
    begin
      L := PCardinal(Cardinal(@S) - 4)^;
      SetLength(Result, MimeDecodedSize(L));
      ByteBuffer := 0;
      ByteBufferSpace := 4;
      L := MimeDecodePartial(Pointer(S)^, L, Pointer(Result)^, ByteBuffer, ByteBufferSpace);
      Inc(L, MimeDecodePartialEnd(Pointer(Cardinal(@Result) + L)^, ByteBuffer, ByteBufferSpace));
      SetLength(Result, L);
    end
  else
    Result := '';
end;

function TcaMimeUtils.TaggedMimeEncodeString(const S: AnsiString): AnsiString;
begin
  Result := MIME_TAG + MimeEncodeString(S);
end;

function TcaMimeUtils.TaggedMimeDecodeString(const S: AnsiString): AnsiString;
var
  TaggedStr: string;
begin
  TaggedStr := S;
  System.Delete(TaggedStr, 1, Length(MIME_TAG));
  Result := MimeDecodeString(TaggedStr);
end;

function TcaMimeUtils.IsTaggedMimeEncoded(const S: AnsiString): Boolean;
begin
  Result := False;
  if Length(S) >= Length(MIME_TAG) then
    Result := Copy(S, 1, Length(MIME_TAG)) = MIME_TAG;
end;

// Size Functions

function TcaMimeUtils.MimeEncodedSize(const InputSize: PtrUInt): PtrUInt;
begin
  if InputSize > 0 then
    Result := (InputSize + 2) div 3 * 4 + (InputSize - 1) div MIME_DECODED_LINE_BREAK * 2
  else
    Result := InputSize;
end;

function TcaMimeUtils.MimeEncodedSizeNoCRLF(const InputSize: Cardinal): Cardinal;
begin
  Result := (InputSize + 2) div 3 * 4;
end;

function TcaMimeUtils.MimeDecodedSize(const InputSize: PtrUInt): PtrUInt;
begin
  Result := (InputSize + 3) div 4 * 3;
end;

procedure TcaMimeUtils.DecodeHttpBasicAuthentication(const BasicCredentials: AnsiString;
          out UserId, PassWord: AnsiString);
label
  Fail;
const
  LBasic = 6; { Length ('Basic ') }
var
  DecodedPtr, P: PAnsiChar;
  I, L: Cardinal;
begin
  P := Pointer(BasicCredentials);
  if P = nil then goto Fail;

  L := Cardinal(Pointer(P - 4)^);
  if L <= LBasic then goto Fail;

  Dec(L, LBasic);
  Inc(P, LBasic);

  GetMem(DecodedPtr, MimeDecodedSize(L));
  L := MimeDecode(P^, L, DecodedPtr^);

  { Look for colon (':'). }
  I := 0;
  P := DecodedPtr;
  while (L > 0) and (P[I] <> ':') do
    begin
      Inc(I);
      Dec(L);
    end;

  { Store UserId and Password. }
  SetString(UserId, DecodedPtr, I);
  if L > 1 then
    SetString(PassWord, DecodedPtr + I + 1, L - 1)
  else
    PassWord := '';

  FreeMem(DecodedPtr);
  Exit;

  Fail:
  UserId := '';
  PassWord := '';
end;

// Encoding Core

procedure TcaMimeUtils.MimeEncode(const InputBuffer; const InputByteCount: Cardinal; out OutputBuffer);
var
  IDelta, ODelta: Cardinal;
begin
  MimeEncodeFullLines(InputBuffer, InputByteCount, OutputBuffer);
  IDelta := InputByteCount div MIME_DECODED_LINE_BREAK; // Number of lines processed so far.
  ODelta := IDelta * (MIME_ENCODED_LINE_BREAK + 2);
  IDelta := IDelta * MIME_DECODED_LINE_BREAK;
  MimeEncodeNoCRLF(Pointer(Cardinal(@InputBuffer) + IDelta)^, InputByteCount - IDelta, Pointer(Cardinal(@OutputBuffer) + ODelta)^);
end;

procedure TcaMimeUtils.MimeEncodeFullLines(const InputBuffer; const InputByteCount: Cardinal; out OutputBuffer);
  //var
  //  B, InnerLimit, OuterLimit: Cardinal;
  //  InPtr: PByte3;
  //  OutPtr: PByte4;
begin
  //{ Do we have enough input to encode a full line? }
  //if InputByteCount < MIME_DECODED_LINE_BREAK then Exit;
  //
  //InPtr := @InputBuffer;
  //OutPtr := @OutputBuffer;
  //
  //InnerLimit := Cardinal(InPtr);
  //Inc(InnerLimit, MIME_DECODED_LINE_BREAK);
  //
  //OuterLimit := Cardinal(InPtr);
  //Inc(OuterLimit, InputByteCount);
  //
  //{ Multiple line loop. }
  //repeat
  //
  //  { Single line loop. }
  //  repeat
  //    { Read 3 bytes from InputBuffer. }
  //    B := InPtr^.b1;
  //    B := B shl 8;
  //    B := B or InPtr^.b2;
  //    B := B shl 8;
  //    B := B or InPtr^.b3;
  //    Inc(InPtr);
  //    { Write 4 bytes to OutputBuffer (in reverse order). }
  //    OutPtr^.b4 := MIME_ENCODE_TABLE[B and $3F];
  //    B := B shr 6;
  //    OutPtr^.b3 := MIME_ENCODE_TABLE[B and $3F];
  //    B := B shr 6;
  //    OutPtr^.b2 := MIME_ENCODE_TABLE[B and $3F];
  //    B := B shr 6;
  //    OutPtr^.b1 := MIME_ENCODE_TABLE[B];
  //    Inc(OutPtr);
  //  until Cardinal(InPtr) >= InnerLimit;
  //
  //  { Write line break (CRLF). }
  //  OutPtr^.b1 := 13;
  //  OutPtr^.b2 := 10;
  //  Inc(Cardinal(@OutPtr), 2);
  //
  //  Inc(InnerLimit, MIME_DECODED_LINE_BREAK);
  //until InnerLimit > OuterLimit;
end;

procedure TcaMimeUtils.MimeEncodeNoCRLF(const InputBuffer; const InputByteCount: Cardinal; out OutputBuffer);
//var
//  B, InnerLimit, OuterLimit: Cardinal;
//  InPtr: PByte3;
//  OutPtr: PByte4;
begin
  //if InputByteCount = 0 then Exit;
  //
  //InPtr := @InputBuffer;
  //OutPtr := @OutputBuffer;
  //
  //OuterLimit := InputByteCount div 3 * 3;
  //
  //InnerLimit := Cardinal(InPtr);
  //Inc(InnerLimit, OuterLimit);
  //
  //{ Last line loop. }
  //while Cardinal(InPtr) < InnerLimit do
  //  begin
  //    { Read 3 bytes from InputBuffer. }
  //    B := InPtr^.b1;
  //    B := B shl 8;
  //    B := B or InPtr^.b2;
  //    B := B shl 8;
  //    B := B or InPtr^.b3;
  //    Inc(InPtr);
  //    { Write 4 bytes to OutputBuffer (in reverse order). }
  //    OutPtr^.b4 := MIME_ENCODE_TABLE[B and $3F];
  //    B := B shr 6;
  //    OutPtr^.b3 := MIME_ENCODE_TABLE[B and $3F];
  //    B := B shr 6;
  //    OutPtr^.b2 := MIME_ENCODE_TABLE[B and $3F];
  //    B := B shr 6;
  //    OutPtr^.b1 := MIME_ENCODE_TABLE[B];
  //    Inc(OutPtr);
  //  end;
  //
  //{ End of data & padding. }
  //case InputByteCount - OuterLimit of
  //  1:
  //    begin
  //      B := InPtr^.b1;
  //      B := B shl 4;
  //      OutPtr.b2 := MIME_ENCODE_TABLE[B and $3F];
  //      B := B shr 6;
  //      OutPtr.b1 := MIME_ENCODE_TABLE[B];
  //      OutPtr.b3 := MIME_PAD_CHAR; { Pad remaining 2 bytes. }
  //      OutPtr.b4 := MIME_PAD_CHAR;
  //    end;
  //  2:
  //    begin
  //      B := InPtr^.b1;
  //      B := B shl 8;
  //      B := B or InPtr^.b2;
  //      B := B shl 2;
  //      OutPtr.b3 := MIME_ENCODE_TABLE[B and $3F];
  //      B := B shr 6;
  //      OutPtr.b2 := MIME_ENCODE_TABLE[B and $3F];
  //      B := B shr 6;
  //      OutPtr.b1 := MIME_ENCODE_TABLE[B];
  //      OutPtr.b4 := MIME_PAD_CHAR; { Pad remaining byte. }
  //    end;
  //end;
end;

// Decoding Core

function TcaMimeUtils.MimeDecode(const InputBuffer; const InputBytesCount: Cardinal; out OutputBuffer): Cardinal;
//var
//  ByteBuffer, ByteBufferSpace: Cardinal;
begin
  //ByteBuffer := 0;
  //ByteBufferSpace := 4;
  //Result := MimeDecodePartial(InputBuffer, InputBytesCount, OutputBuffer, ByteBuffer, ByteBufferSpace);
  //Inc(Result, MimeDecodePartialEnd(Pointer(Cardinal(@OutputBuffer) + Result)^, ByteBuffer, ByteBufferSpace));
end;

function TcaMimeUtils.MimeDecodePartial(const InputBuffer; const InputBytesCount: Cardinal;
         out OutputBuffer; var ByteBuffer: Cardinal; var ByteBufferSpace: Cardinal): Cardinal;
//var
//  lByteBuffer, lByteBufferSpace, C: Cardinal;
//  InPtr, OuterLimit: ^Byte;
//  OutPtr: PByte3;
begin
  //if InputBytesCount > 0 then
  //  begin
  //    InPtr := @InputBuffer;
  //    Cardinal(OuterLimit) := Cardinal(InPtr) + InputBytesCount;
  //    OutPtr := @OutputBuffer;
  //    lByteBuffer := ByteBuffer;
  //    lByteBufferSpace := ByteBufferSpace;
  //    while InPtr <> OuterLimit do
  //      begin
  //        { Read from InputBuffer. }
  //        C := MIME_DECODE_TABLE[InPtr^];
  //        Inc(InPtr);
  //        if C = $FF then Continue;
  //        lByteBuffer := lByteBuffer shl 6;
  //        lByteBuffer := lByteBuffer or C;
  //        Dec(lByteBufferSpace);
  //        { Have we read 4 bytes from InputBuffer? }
  //        if lByteBufferSpace <> 0 then Continue;
  //
  //        { Write 3 bytes to OutputBuffer (in reverse order). }
  //        OutPtr^.b3 := Byte(lByteBuffer);
  //        lByteBuffer := lByteBuffer shr 8;
  //        OutPtr^.b2 := Byte(lByteBuffer);
  //        lByteBuffer := lByteBuffer shr 8;
  //        OutPtr^.b1 := Byte(lByteBuffer);
  //        lByteBuffer := 0;
  //        Inc(OutPtr);
  //        lByteBufferSpace := 4;
  //      end;
  //    ByteBuffer := lByteBuffer;
  //    ByteBufferSpace := lByteBufferSpace;
  //    Result := Cardinal(OutPtr) - Cardinal(@OutputBuffer);
  //  end
  //else
  //  Result := 0;
end;

function TcaMimeUtils.MimeDecodePartialEnd(out OutputBuffer; const ByteBuffer: Cardinal;
         const ByteBufferSpace: Cardinal): Cardinal;
//var
//  lByteBuffer: Cardinal;
begin
  //case ByteBufferSpace of
  //  1:
  //    begin
  //      lByteBuffer := ByteBuffer shr 2;
  //      PByte3(@OutputBuffer)^.b2 := Byte(lByteBuffer);
  //      lByteBuffer := lByteBuffer shr 8;
  //      PByte3(@OutputBuffer)^.b1 := Byte(lByteBuffer);
  //      Result := 2;
  //    end;
  //  2:
  //    begin
  //      lByteBuffer := ByteBuffer shr 4;
  //      PByte3(@OutputBuffer)^.b1 := Byte(lByteBuffer);
  //      Result := 1;
  //    end;
  //else
  //  Result := 0;
  //end;
end;

// CoMimeUtilsFactory

class function CoMimeUtilsFactory.Instance: IcaMimeUtils;
const
  FInstance: IcaMimeUtils = nil;
begin
  if not Assigned(FInstance) then
    FInstance := TcaMimeUtils.Create;
  Result := FInstance;
end;

initialization
  MimeUtils := CoMimeUtilsFactory.Instance;

end.

