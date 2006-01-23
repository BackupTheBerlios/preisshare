unit DelphiUtils;

interface

uses
  {$IFDEF LINUX}
    SysUtils, Types, Classes, Variants, QTypes, QGraphics, QControls, QForms,
    QDialogs, QStdCtrls, DateUtils,QExtCtrls;
  {$ELSE}
    Classes, SysUtils, WinProcs, StdCtrls, Controls, Dialogs, Forms;

  {$ENDIF}
const
    DOSENV_MAX_TOTAL_LENGTH:Integer = 16384;
    DOSENV_MAX_VAL_LENGTH:Integer = 4096;
    DOSENV_MAX_VAR_LENGTH:Integer = 128;
    base36 = '123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ0';
    chrNL: string[2] = Chr(13) + Chr(10);
    chrTAB: string[1] = Chr(9);
    chrS4: string[4] = '    ';
    chrS8: string[8] = '        ';
    chrS16: string[16] = '                ';

    C1 = 52845;
    C2 = 22719;

procedure validNumber(var Key: char);
procedure validFloat(var Key: char);
function IsValidFloat(sender: TEdit): boolean;

function PathString(pth: string): string;
{verify that the string pth has a trailing backslash}
function AppPath: string;

procedure MsgError( msg: string);
function MsgOkCancel( msg: string): boolean;
function MsgYesNoCancel( msg: string): word;
function MsgYesNo( msg: string): boolean;
procedure MsgInfo( msg: string);
function MsgConfirm( msg: string): boolean;
procedure MsgWarning( msg: string);

function RevStr(s: string):string;

procedure PathSplit (fPathName:string; var pth, fName: string);
{split fPathName into path and filename}

function StrSlice( s: PChar; var part: PChar; sep: PChar; var pos: Integer):boolean;
function StrSliceS( s: string; var part: string; sep: string; var StartPos: Integer):boolean;
{slice up a string based on separator sep}

procedure StrSlice2( s, sep: PChar; var p1, p2: PChar);
procedure StrSliceS2( s, sep: string; var s1, s2: string);
procedure StrSliceS3( s, sep: string; var s1, s2, s3: string);

function SQLStr(s: string) : string;
function StrReplace(s, srch, repl: string): string;

function trim(s:string): string;
function TrimL(s: string): string;
function trimR(s:string): string;
function TrimNumeric(s: string): string;

function pad(s:string; n:integer;padchar:Char=' '): string;
function padL(s:string; n:integer): string;
function zeropad(i:integer; n:integer): string;

{$IFNDEF LINUX}
procedure DOSEnvAll( var eAll: PChar);
{return all the DOS environment, separated with char(1)}

function DOSEnv( eVar: PChar; var eVal: PChar): boolean;
{return the value of the environment variable eVar}
{$ENDIF}

function CDbl( s: string ) : Extended;
function CInt( s: string ) : Integer;
function CLong( s: string ) : LongInt;
function CIntZero(s: string): integer;

function Right(s: string; n: integer): string;

function YMDNow: string;

function GetComboBoxIndex(var cb: TComboBox; s: string): integer;
function GetListBoxIndex(var cb: TListBox; s: string): integer;
function GetListIndex(cb: TStrings; s: string): integer;
function GetListIndexLike(cb: TStrings; s: string): integer;

function DateStrToShortDate(sDt:string): string;
function DateStrToMidDate(sDt:string): string;
function DateStrToDateTime(sDt:string): TDateTime;
function DateStrToDateTimeDef(sDt:string; defDt: TDateTime): TDateTime;
function AnyDateStrToDate(sDt:string): TDatetime;
function MonthStrToMonthNumber(s: string): integer;
function TimeStrToMinutes(s: string): longint;
function TimeStrToMinutesS(s: string): string;
function DateAndTimeStrToDateTime(sDt, sTm:string): TDateTime;
function DatePart(dt: TDateTime): TDateTime;
function TimePart(dt: TDateTime): string;

function StrToTime_(s: string): TDateTime;

function StrRealToInt(rs: string): longint;

procedure Wait(waitSeconds: double);

function LoPowerEncrypt(const S: String): String;
function LoPowerDecrypt(const S: String): String;
function Encode(const S: String): String;
function ReplaceText(TexttoReplace,TextToReplaceWith,aString : String):String;


implementation

function ReplaceText(TexttoReplace,TextToReplaceWith,aString : String):String;
var
	s1,s2 : String;
begin
	if Pos(TextToReplace,aString) <> 0 then
	begin
		// Replace our string
		StrSliceS2(aString, TextToReplace, s1, s2);
		Result := s1 + TextToReplaceWith + s2;
	end
	else
		Result := aString;
end;

function TimePart(dt: TDateTime): string;
begin
    result := FormatDateTime('hh:nn', dt);
end;

function DatePart(dt: TDateTime): TDateTime;
var
    y,m,d: word;
begin
    DecodeDate(dt, y, m, d);
    result := EncodeDate(y, m, d);
end;

function IsValidFloat(sender: TEdit): boolean;
var
    f: real;
begin
    if Sender.Text = '' then Sender.Text := '0.00';
    try
        result := true;
        f := StrToFloat(Sender.Text);
        Sender.Text := Format('%.2f', [f]);
    except
        result := false;
    end;
end;

procedure validNumber(var Key: char);
begin
    if not (Key in ['0','1','2','3','4','5','6','7','8','9', #8]) then Key := #0;
end;

procedure validFloat(var Key: char);
begin
    if not (Key in ['0','1','2','3','4','5','6','7','8','9', #8, '.']) then Key := #0;
end;

function DateAndTimeStrToDateTime(sDt, sTm:string): TDateTime;
var
    t,d :TDateTime;
begin
    sDt := Trim(sDt);
    sTm := Trim(sTm);
    try
        if sTm<>'' then t := StrToTime(sTm) else t := 0;
    except
        t := 0;
    end;
    if Length(sDt) = 8 then
    begin
        try
            d := EncodeDate(StrToInt(Copy(sDt, 1, 4)),
                            StrToInt(Copy(sDt, 5, 2)),
                            StrToInt(Copy(sDt, 7, 2)));
        except
            d := 0;
        end;
    end
    else
        d := 0;

    result := d + t;
end;

function StrToTime_(s: string): TDateTime;
begin
    try
        if s='00:00' then
            result := 0
        else
            result := StrToTime(s);
    except
        result := 0;
    end;
end;

function TimeStrToMinutes(s: string): longint;
begin
    try
        if s<>'' then
            result := Round(StrToTime(Trim(s)) * 24 * 60)
        else
            result := 0;
    except
        result := 0;
    end;
end;

function TimeStrToMinutesS(s: string): string;
var
    i: longint;
begin
    i := TimeStrToMinutes(s);
    result := Format('%d', [i]);
end;


procedure Wait(waitSeconds: double);
var
    waitTo: TDateTime;
begin
    waitSeconds := waitSeconds / 86400.0;
    waitTo := Now + waitSeconds;
    while (Now < waitTo) do Application.ProcessMessages;
end;

function CIntZero(s: string): integer;
begin
    try
        result := StrToInt(s)
    except
        result := 0;
    end;
end;

function CLong( s: string ) : LongInt;
begin
    try
        result := StrToInt(s)
    except
        result := 0;
    end;
end;

function CInt(s: string): integer;
var
    i: integer;
begin
    try
        i := StrToInt(s)
    except
        try
            i := Round(StrToFloat(s));
        except
            i := -9999;
        end;
    end;
    CInt := i;
end;

function StrRealToInt(rs: string): longint;
var
    p: byte;
begin
    try
        {strip anything following a decimal point}
        p := Pos('.', rs);
        if p > 0 then rs := Copy(rs, 1, (p-1));
        result := StrToInt(Trim(rs));
    except
        result := 0;
    end;
end;

function DateStrToDateTime(sDt:string): TDateTime;
begin
    sDt := trim(sDt);
    if Length(sDt) = 8 then
    begin
        try
            result := EncodeDate(StrToInt(Copy(sDt, 1, 4)),
                            StrToInt(Copy(sDt, 5, 2)),
                            StrToInt(Copy(sDt, 7, 2)));
        except
            result := 0;
        end;
    end
    else
        result := 0;
end;

function DateStrToDateTimeDef(sDt:string; defDt: TDateTime): TDateTime;
begin
    sDt := trim(sDt);
    if Length(sDt) = 8 then
    begin
        try
            result := EncodeDate(StrToInt(Copy(sDt, 1, 4)),
                            StrToInt(Copy(sDt, 5, 2)),
                            StrToInt(Copy(sDt, 7, 2)));
        except
            result := defDt;
        end;
    end
    else
        result := defDt;
end;

function DateStrToShortDate(sDt:string): string;
var
    dt: TDateTime;
begin
    sDt := trim(sDt);
    if Length(sDt) = 8 then
    begin
        try
            dt := EncodeDate(StrToInt(Copy(sDt, 1, 4)),
                            StrToInt(Copy(sDt, 5, 2)),
                            StrToInt(Copy(sDt, 7, 2)));
            DateStrToShortDate := FormatDateTime('ddddd', dt);
        except
            DateStrToShortDate := sDt;
        end;
    end
    else
        DateStrToShortDate := sDt;
end;

function DateStrToMidDate(sDt:string): string;
var
    dt: TDateTime;
begin
    sDt := trim(sDt);
    if (Length(sDt) = 8) and (sDt <> '00000000') then
    begin
        try
            dt := EncodeDate(StrToInt(Copy(sDt, 1, 4)),
                            StrToInt(Copy(sDt, 5, 2)),
                            StrToInt(Copy(sDt, 7, 2)));
            DateStrToMidDate := FormatDateTime('dd MMM yyyy', dt);
        except
            DateStrToMidDate := sDt;
        end;
    end
    else
        DateStrToMidDate := sDt;
end;

function AnyDateStrToDate(sDt:string): TDatetime;
var
    dt: TDateTime;
    d,m,y, dSep: string;
    yr, y1, m1, d1: word;
    code: integer;
begin
    sDt := Trim(sDt);
    d := '';m := '';y := '';
    if Pos(DateSeparator, sDt) <> 0 then
        dSep := DateSeparator
    else if Pos('/', sDt) <> 0 then
        dSep := '/'
    else if Pos('\', sDt) <> 0 then
        dSep := '\'
    else if Pos('.', sDt) <> 0 then
        dSep := '.'
    else if Pos(' ', sDt) <> 0 then
        dSep := ' '
    else
        dSep := '';

	if dSep<>'' then
	begin
		StrSliceS3(sDt, dSep, d, m, y);
		d := Trim(d);
		m := Trim(m);
		y := Trim(y);
		try
			{are there any short months strings?}
			code := MonthStrToMonthNumber(m);
			if code<>0 then
				m := IntToStr(code)
			else
			begin
				code := MonthStrToMonthNumber(d);
                if code<>0 then
                begin
                    d := m;
                    m := IntToStr(code);
                end;
            end;

            if code=0 then
            begin
                {month first ?}
                if UpperCase(Copy(ShortDateFormat,1,1))='M' then
                begin
                    dSep := d;
                    d := m;
                    m := dSep;
                end;
            end;

            {no century?}
            Val(y, y1, code);
            if code <> 0 then raise EConvertError.Create('Invalid date value');

            if y1 < 100 then
            begin
                DecodeDate(Now, yr, m1, d1);
                y1 := y1 + (yr div 100) * 100;
            end;

            Val(d, d1, code);
            if code <> 0 then raise EConvertError.Create('Invalid date value');

            Val(m, m1, code);
            if code <> 0 then
            begin
                {3 char month str?}
                if (m1 <= 0) and (length(m)=3) then
                    m1 := MonthStrToMonthNumber(m)
                else
                    raise EConvertError.Create('Invalid date value');
            end;

            dt := EncodeDate(y1, m1, d1);
            AnyDateStrToDate := dt;
        except
            raise;
        end;
    end
    else
        raise EConvertError.Create('Invalid date value');
end;

function MonthStrToMonthNumber(s: string): integer;
{const
    mStr = ';JAN;FEB;MAR;APR;MAY;JUN;JUL;AUG;SEP;OCT;NOV;DEC;';}
var
    p: integer;
begin
    result := 0;
    s := Trim(Uppercase(s));
    if length(s)=3 then
    begin
        p := 0;
        while (p<12) and (result = 0) do
        begin
            Inc(p);
            if UpperCase(ShortMonthNames[p]) = s then result := p;
        end;
    end;
end;

function AppPath: string;
var
    fPathName, pth, fName: string;
begin

    fPathName := Application.EXEName;
    PathSplit(fPathName, pth, fName);
    AppPath := PathString(pth);
end;

{$IFNDEF LINUX}
procedure DOSEnvAll( var eAll: PChar);
{return all the DOS environment, separated with char(1)}
var
    c: PChar;
    maxLen: Integer;
begin
    StrCopy(eAll, '');
    c := GetEnvironmentStrings;
    maxLen := DOSENV_MAX_TOTAL_LENGTH - DOSENV_MAX_VAL_LENGTH;
    while (strlen(c) > 0) and (strlen(eAll)< maxLen) do
    begin
        strcat(eAll, c);
        strcat(eAll, '|');
        c := c + strlen(c) + 1;
    end;
end;

function DOSEnv( eVar: PChar; var eVal: PChar): boolean;
{return the value of the environment variable eVar}
var
    eAll, d: PChar;
    posn: integer;
    pVar : PChar;
    haveVar: boolean;
begin
    GetMem(eAll, DOSENV_MAX_TOTAL_LENGTH);
    GetMem(d, DOSENV_MAX_VAL_LENGTH);
    GetMem(pVar, DOSENV_MAX_VAR_LENGTH);

    DOSEnvAll(eAll);
    posn := 0; haveVar := false;
    while not haveVar and StrSlice(eAll, d, '|', posn) do
    begin
        StrSlice2(d, '=', pVar, eVal);
        haveVar := (StrIComp(eVar, pVar) = 0);
    end;
    DOSEnv := haveVar;
    if not haveVar then StrCopy(eVal,'');

    FreeMem(eAll, DOSENV_MAX_TOTAL_LENGTH);
    FreeMem(d, DOSENV_MAX_VAL_LENGTH);
    FreeMem(pVar, DOSENV_MAX_VAR_LENGTH);
end;
{$ENDIF}

function StrSlice( s: PChar; var part: PChar; sep: PChar; var pos: Integer):boolean;
var
    p, f : PChar;
begin
    if (pos < strlen(s)) then
    begin
        StrSlice := true;
        p := s + pos;
        f := StrPos(p, sep);
        if f=nil then
        begin
            strcopy(part, p);
            pos := strlen(s);
        end
        else
        begin
            strLcopy(part, p, f-p);
            pos := pos + (f-p) + strlen(sep);
        end;
    end
    else
        StrSlice := false;
end;

function StrSliceS( s: string; var part: string; sep: string; var StartPos: Integer):boolean;
var
    posn: byte;
    s2: string;
begin
    if (StartPos=0) then StartPos := 1;
    if (StartPos <= Length(s)) then
    begin
        StrSliceS := true;
        s2 := Copy(s, StartPos, Length(s)-StartPos + 1);
        posn := Pos(sep, s2);
        if (posn=0) then
        begin
            part := s2;
            StartPos := Length(s) + 1;
        end
        else
        begin
            part := Copy(s2, 1, posn-1);
            StartPos := StartPos + posn + Length(sep) - 1;
        end;
    end
    else
        StrSliceS := false;
end;

procedure StrSlice2( s, sep: PChar; var p1, p2: PChar);
var
    f: PChar;
begin
    f := StrPos(s, sep);
    if (f <> nil) then
    begin
        StrLCopy(p1, s, f-s);
        StrCopy(p2, f + StrLen(sep));
    end
    else
    begin
        StrCopy(p1, s);
        StrCopy(p2, '');
    end;
end;

procedure StrSliceS2( s, sep: string; var s1, s2: string);
var
    posn: byte;
begin
    posn := Pos(sep, s);
    if (posn=0) then
    begin
        s1 := s;
        s2 := '';
    end
    else
    begin
        s1 := Copy(s, 1, posn-1);
        s2 := Copy(s, posn + Length(sep), Length(s)- posn);
    end;
end;

procedure StrSliceS3( s, sep: string; var s1, s2, s3: string);
var
    rs1: string;
begin
    StrSliceS2(s, sep, s1, rs1);
    StrSliceS2(rs1, sep, s2, s3);
end;

function SQLStr(s: string) : string;
begin
    result := StrReplace(s, Chr(39), Chr(39) + Chr(39));
end;

function StrReplace(s, srch, repl: string): string;
var
    p : integer;
    ss: string;
begin
    p := Pos(srch, s);
    ss := '';

    if p=0 then
        ss := s
    else
    begin
        while p<>0 do
        begin
            ss := ss + Copy(s, 1, p-1) + repl;
            if (p + Length(srch)) > Length(s) then
                s := ''
            else
                s := Copy(s, p + Length(srch), Length(s) - p - Length(srch) + 1);
            p := Pos(srch, s);
        end;
        ss := ss + s
    end;
    StrReplace := ss;
end;

function PathString(pth: string): string;
begin
    If (length(pth) > 0) and (CompareStr(Copy(pth, length(pth), 1), '\') <> 0) then
    begin
        pth := pth + '\';
    end;
    PathString := pth;
end;

procedure MsgError( msg: string);
var
    curC: TCursor;
begin
    curC := Screen.Cursor;
    Screen.Cursor := crDefault;
    MessageDlg(msg, mtError, [mbOK], 0);
    Screen.Cursor := curC;
end;

procedure MsgInfo( msg: string);
var
    curC: TCursor;
begin
    curC := Screen.Cursor;
    Screen.Cursor := crDefault;
    MessageDlg(msg, mtInformation, [mbOK], 0);
    Screen.Cursor := curC;
end;

procedure MsgWarning( msg: string);
var
    curC: TCursor;
begin
    curC := Screen.Cursor;
    Screen.Cursor := crDefault;
    MessageDlg(msg, mtWarning, [mbOK], 0);
    Screen.Cursor := curC;
end;

function MsgConfirm( msg: string): boolean;
var
    curC: TCursor;
begin
    curC := Screen.Cursor;
    Screen.Cursor := crDefault;
    MsgConfirm := (MessageDlg(msg, mtWarning, [mbYes, mbNo], 0) = mrYes);
    Screen.Cursor := curC;
end;

function MsgYesNo( msg: string): boolean;
var
    curC: TCursor;
begin
    curC := Screen.Cursor;
    Screen.Cursor := crDefault;
    MsgYesNo := (MessageDlg(msg, mtConfirmation, [mbYes, mbNo], 0) = mrYes);
    Screen.Cursor := curC;
end;

function MsgOkCancel( msg: string): boolean;
var
    curC: TCursor;
begin
    curC := Screen.Cursor;
    Screen.Cursor := crDefault;
    MsgOkCancel := (MessageDlg(msg, mtConfirmation, mbOKCancel, 0) = mrOk);
    Screen.Cursor := curC;
end;

function MsgYesNoCancel( msg: string): word;
var
    curC: TCursor;
begin
    curC := Screen.Cursor;
    Screen.Cursor := crDefault;
    MsgYesNoCancel := MessageDlg(msg, mtConfirmation, [mbYes, mbNo, mbCancel], 0);
    Screen.Cursor := curC;
end;

procedure PathSplit (fPathName:string; var pth, fName: string);
var
    pos: integer;
    c : string;
    found: boolean;
begin
    { find the last \ or :}
    pos := Length(fPathName);
    found := false;
    while (pos>0) and (not found) do
    begin
        c := Copy(fPathName, pos,1);
        if (c='\') or (c=':') then
            found := true
        else
            Dec(pos);
    end;
    pth := Copy(fPathName, 1, pos);
    fName := Copy(fPathName, pos+1, Length(fPathName)-pos);
end;

function CDbl( s: string ) : Extended;
begin
    {clean up the string}
    s := TrimNumeric(s);
    s := StrReplace(s, ',', '');
    if s='' then s := '0';
    try
         CDbl := StrToFloat(s);
    except
        CDbl := 0;
    end;
end;

{trim non-numerics from L and R of the string}
{has a problem with a '-' followed by non-numeric char}
function TrimNumeric(s: string): string;
var i, n:integer;
const numSet = ['-','0'..'9','.'];
begin
  while (length(s)>0) and not(s[length(s)] in NumSet) do s := Copy(s,1,Length(s)-1);
  i := 1;
  n := length(s);
  while (i<=n) and not(s[i] in NumSet) do inc(i);
  if (i>n) then result := '' else result := copy(s, i, length(s) - i + 1);
end;

function TrimL(s: string): string;
var i, n: integer;
begin
  i := 1;
  n := length(s);
  while (i<=n) and (s[i] = ' ') do inc(i);
  if (i>n) then result := '' else result := copy(s, i, length(s) - i + 1);
end;

function TrimR(s: string): string;
begin
  while s[length(s)] = ' ' do s := Copy(s,1,Length(s)-1);
  result := s;
end;

function Trim(s: string): string;
var i, n: integer;
begin
    if Length(s) = 0 then Exit;
    while s[length(s)] = ' ' do s := Copy(s,1,Length(s)-1);
        i := 1;
    n := length(s);
    while (i<=n) and (s[i] = ' ') do inc(i);
        if (i>n) then result := '' else result := copy(s, i, length(s) - i + 1);
end;

function pad(s:string; n:integer;padchar : char): string;
var
    l: integer;
begin
    l := length(s);
    if (l < n) and (n < 255) then
    while l<n do
    begin
		s := s + padchar;
        inc(l);
    end;
    pad := s;
end;

function padL(s:string; n:integer): string;
var
    l, m, i: integer;
begin
    l := length(s);
    m := n;
    if (l < n) and (n < 255) then
    begin
		s := s + Copy('                           ',1,n-l);
		for i := l downto 1 do
        begin
            s[m] := s[i];
            Dec(m);
        end;
        for i := (n-l) downto 1 do
            s[i] := ' ';
    end;
    padL := s;
end;

function zeropad(i:integer; n:integer): string;
var
    l: integer;
    s: string;
begin
    s := trim(IntToStr(i));
    l := length(s);
    if (l < n) and (n < 255) then
    while l<n do
    begin
        s := '0' + s;
        inc(l);
    end;
    zeropad := s;
end;

function YMDNow: string;
var
    dt: string;
begin
    dt := FormatDateTime('ddmmyyhhmmss', Now);
    YMDNow := Chr(StrToInt(Copy(dt,1,2))) + Chr(StrToInt(Copy(dt,3,2))) +
                Chr(StrToInt(Copy(dt,5,2))) + Chr(StrToInt(Copy(dt,7,2))) +
                Chr(StrToInt(Copy(dt,9,2))) + Chr(StrToInt(Copy(dt,11,2)));
end;


function Right(s: string; n: integer): string;
begin
    if Length(s) >= n then
        Right := Copy(s, Length(s)-n+1, n)
    else
        Right := s;
end;


function GetComboBoxIndex(var cb: TComboBox; s: string): integer;
var
    i, n, z: integer;
begin
    n := cb.Items.Count-1;
    z := -1;
    i := 0;
    while (z=-1) and (i<=n) do
    begin
        if cb.Items[i] = s then z := i;
        Inc(i);
    end;
    GetComboBoxIndex := z;
end;

function GetListBoxIndex(var cb: TListBox; s: string): integer;
var
    i, n, z: integer;
    si: string;
begin
    n := cb.Items.Count-1;
    z := -1;
    i := 0;
    while (z=-1) and (i<=n) do
    begin
        si := Trim(cb.Items[i]);
        if si = s then z := i;
        Inc(i);
    end;
    GetListBoxIndex := z;
end;

function GetListIndexLike(cb: TStrings; s: string): integer;
var
    i, n, z, l: integer;
    si: string;
begin
    n := cb.Count-1;
    z := -1;
    i := 0;
    l := Length(s);
    s := UpperCase(s);
    while (z=-1) and (i<=n) do
    begin
        si := Copy(cb[i], 1, l);
        if UpperCase(si) = s then z := i;
        Inc(i);
    end;
    GetListIndexLike := z;
end;

function GetListIndex(cb: TStrings; s: string): integer;
var
    i, n, z: integer;
begin
    n := cb.Count-1;
    z := -1;
    i := 0;
    while (z=-1) and (i<=n) do
    begin
        if Trim(cb[i]) = s then z := i;
        Inc(i);
    end;
    GetListIndex := z;
end;

function Encode(const S: String): String;
var
  I: byte;
  Key: LongInt;
begin
  Result := S;
  Key := C1;
  for I := 1 to Length(S) do begin
    Result[I] := char(((byte(S[I])- 32) + Key) mod 95 + 32);
    if Result[I]=' ' then Result[I] := '~';
    Key := (byte(Result[I]) + Key) Mod C2;
  end;
end;

function RevStr(s: string):string;
var
    i, l: integer;
begin
    result := s;
    l := length(s);
    for i := 1 to l do
        result[i] := s[l-i+1];
end;

function Decrypt_(const S: String): String;
const
    incc: array[1 .. 10] of integer = (12,37,14,29,53,17,73,41,55,67);
var
    i, o, pos: integer;
    sr: string;
begin
    pos := ord(s[1]) - 32;
    sr := '';
    for i:= 2 to (length(s)-1) do
    begin
        pos := pos mod 10 + 1;
        o := ord(s[i]);
        o := o - incc[pos];
        if o < 32 then o := o + 126 - 31;
        sr := sr + Chr(o);
    end;
    result := sr;
end;

function Encrypt_(const S: String): String;
const
    incc: array[1 .. 10] of integer = (12,37,14,29,53,17,73,41,55,67);
var
    i, o, pos: integer;
    sr: string;
begin
    Randomize;
    pos := Trunc(Random * 10) + 1;

    sr := Chr(32+pos);
    for i:= 1 to length(s) do
    begin
        pos := pos mod 10 + 1;
        o := Ord(s[i]) + incc[pos];
        if o>126 then o := o - 126 + 31;
        sr := sr + Chr(o);
    end;
    o := 32 + Trunc(Random * 90);
    sr := sr + Chr(o);
    result := sr;
end;


function LoPowerEncrypt(const S: String): String;
var
    i: integer;
begin
    result := s;
    for i:=1 to 5 do
    begin
        result := Encrypt_(result);
        result := RevStr(result);
    end;
end;

function LoPowerDecrypt(const S: String): String;
var
    i: integer;
begin
    result := s;
    for i:=1 to 5 do
    begin
        result := RevStr(result);
        result := Decrypt_(result);
    end;
end;

end.
