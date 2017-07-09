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

unit cadbgintf;

interface

type
  TDebugLevel = (dlInformation, dlWarning, dlError);

procedure SendDebug(const AMsg: string);

procedure SetDebuggingEnabled(const AValue: boolean);
function GetDebuggingEnabled: Boolean;

{ low-level routines }

function StartDebugServer: integer;
function InitDebugClient: Boolean;

const
  SendError: string = '';

resourceString
  SProcessID = 'Process %s';
  SServerStartFailed = 'Failed to start debugserver. (%s)';

implementation

uses
  SysUtils, Classes, dbugmsg, process, simpleipc;

const
  DmtInformation = lctInformation;
  DmtWarning     = lctWarning;
  DmtError       = lctError;
  ErrorLevel     : Array[TDebugLevel] of integer
                 = (dmtInformation,dmtWarning,dmtError);
  IndentChars    = 2;

var
  DebugClient: TSimpleIPCClient = nil;
  MsgBuffer: TMemoryStream = Nil;
  ServerID: Integer;
  DebugDisabled: Boolean = False;
  Indent: Integer = 0;

procedure WriteMessage(Const Msg: TDebugMessage);
begin
  MsgBuffer.Seek(0, soFrombeginning);
  WriteDebugMessageToStream(MsgBuffer, Msg);
  DebugClient.SendMessage(mtUnknown, MsgBuffer);
end;

procedure SendDebugMessage(Var Msg: TDebugMessage);
begin
  if DebugDisabled then exit;
  try
    if (DebugClient = Nil) then
      if InitDebugClient = false then exit;
    if (Indent > 0) then
      Msg.Msg := StringOfChar(' ', Indent) + Msg.Msg;
    WriteMessage(Msg);
  except
    on E: Exception do
      SendError := E.Message;
  end;
end;

procedure SendDebug(const AMsg: string);
var
  Msg: TDebugMessage;
begin
  Msg.MsgTimeStamp := Now;
  Msg.MsgType := dmtInformation;
  Msg.Msg := AMsg;
  SendDebugMessage(Msg);
end;

procedure SetDebuggingEnabled(const AValue: boolean);
begin
  DebugDisabled := not AValue;
end;

function GetDebuggingEnabled: Boolean;
begin
  Result := not DebugDisabled;
end;

function StartDebugServer: Integer;
var
  Process: TProcess;
begin
  Process := TProcess.Create(nil);
  try
    try
      Process.CommandLine := 'dbugsrv';
      Process.Execute;
      Result := Process.ProcessID;
    except on E: Exception do
      begin
        SendError := Format(SServerStartFailed,[E.Message]);
        Result := 0;
      end;
    end;
  finally
    Process.Free;
  end;
end;

procedure FreeDebugClient;
var
  Msg: TDebugMessage;
begin
  try
    if (DebugClient <> nil) and (DebugClient.ServerRunning) then
      begin
        Msg.MsgType := lctStop;
        Msg.MsgTimeStamp := Now;
        Msg.Msg := Format(SProcessID, [ApplicationName]);
        WriteMessage(Msg);
      end;
    if Assigned(MsgBuffer) then FreeAndNil(MsgBuffer);
    if Assigned(DebugClient) then FreeAndNil(DebugClient);
  except
  end;
end;

function InitDebugClient : Boolean;
var
  Msg: TDebugMessage;
  I: Integer;
begin
  Result := False;
  DebugClient := TSimpleIPCClient.Create(nil);
  DebugClient.ServerID := DebugServerID;
  if not DebugClient.ServerRunning then
    begin
      ServerID:=StartDebugServer;
      if ServerID = 0 then
        begin
          DebugDisabled := True;
          FreeAndNil(DebugClient);
          Exit;
        end
      else
        DebugDisabled := False;
      I := 0;
      while (I < 10) and not DebugClient.ServerRunning do
        begin
          Inc(I);
          Sleep(100);
        end;
    end;
  try
    DebugClient.Connect;
  except
    FreeAndNil(DebugClient);
    DebugDisabled:=True;
    raise;
  end;
  MsgBuffer := TMemoryStream.Create;
  Msg.MsgType := lctIdentify;
  Msg.MsgTimeStamp := Now;
  Msg.Msg := Format(SProcessID, [ApplicationName]);
  WriteMessage(Msg);
  Result := True;
end;

finalization
  FreeDebugClient;

end.
