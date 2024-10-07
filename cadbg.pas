unit caDbg;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, DBugIntf;

procedure dbinit;
procedure db(msg: string);
procedure db(id, msg: string);
procedure db(val: Integer);
procedure db(id: string; val: Integer);
procedure db(IsTrue: Boolean);
procedure db(id: string; IsTrue: Boolean);
procedure db;

implementation

procedure dbinit;
begin
  InitDebugClient;
end;

procedure db(msg: string);
begin
  SendDebug(msg);
end;

procedure db(id, msg: string);
begin
  SendDebug(id + ': ' + msg);
end;

procedure db(val:Integer);
begin
  SendInteger('', val);
end;

procedure db(id: string; val: Integer);
begin
  SendInteger(id, val);
end;

procedure db(IsTrue: Boolean);
begin
  db(specialize IfThen<string>(IsTrue, 'True', 'False'));
end;

procedure db(id: string; IsTrue: Boolean);
begin
  db(id, specialize IfThen<string>(IsTrue, 'True', 'False'));
end;

procedure db;
begin
  SendDebug('----------------------------------------------------------------------------------------------------------------------------------');
end;

end.

