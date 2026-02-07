unit uVersion;

{$mode objfpc}{$H+}

interface

function cVERSION: string;
function cMAJOR: Integer;
function cMINOR: Integer;
function cRELEAS: Integer;
function cBUILD: Integer;

const cBUILD_DATE = '{$I %DATE%}';

implementation

uses
  SysUtils,
  FileInfo;

function GetFileVersion: string;
var FVI: TFileVersionInfo;
begin
  Result := '0.0.0.0';

  FVI := TFileVersionInfo.Create(nil);
  try
    FVI.ReadFileInfo;
    if FVI.VersionStrings <> nil then
      Result := FVI.VersionStrings.Values['FileVersion'];
  finally
    FVI.Free;
  end;
end;

procedure ParseVersion(out AMajor, AMinor, ARelease, ABuild: Integer);
var Parts: TStringArray;
begin
  Parts := GetFileVersion.Split('.');
  AMajor   := StrToIntDef(Parts[0], 0);
  AMinor   := StrToIntDef(Parts[1], 0);
  ARelease := StrToIntDef(Parts[2], 0);
  ABuild   := StrToIntDef(Parts[3], 0);
end;

function cMAJOR: Integer;
var m,n,r,b: Integer;
begin
  ParseVersion(m,n,r,b);
  Result := m;
end;

function cMINOR: Integer;
var m,n,r,b: Integer;
begin
  ParseVersion(m,n,r,b);
  Result := n;
end;

function cRELEAS: Integer;
var m,n,r,b: Integer;
begin
  ParseVersion(m,n,r,b);
  Result := r;
end;

function cBUILD: Integer;
var m,n,r,b: Integer;
begin
  ParseVersion(m,n,r,b);
  Result := b;
end;

function cVERSION: string;
begin
  Result := Format('%d.%d.%d_(%d)_',
    [cMAJOR, cMINOR, cRELEAS, cBUILD]);

  {$IFDEF LCLGtk2} Result += 'Gtk2'; {$ENDIF}
  {$IFDEF LCLGtk3} Result += 'Gtk3'; {$ENDIF}
  {$IFDEF LCLQt5}  Result += 'Qt5';  {$ENDIF}
  {$IFDEF LCLQt6}  Result += 'Qt6';  {$ENDIF}
end;

end.

