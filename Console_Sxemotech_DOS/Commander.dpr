program Commander;

{$APPTYPE CONSOLE}

uses
 SysUtils, ShellAPI, Windows;

Label All;

var
 f: text;
 s,s0,s1,ss1,s2,ss2,s3: string;
 NewStr: string;
 Result: string;
 Source, Dest : array[0..255] of Char;
 i,j,per,ch: integer;
 x,y: string;
 r: PChar;
 a: array [0..200] of string;

 ConHandle: THandle; // Дескриптор консольного окна
 sbi: TConsoleScreenBufferInfo;
 Coord: TCoord;

function GetConsoleWindow: THandle;
var
 S: AnsiString;
 C: Char;
begin
 Result := 0;
 Setlength(S, MAX_PATH + 1);
 if GetConsoleTitle(PChar(S), MAX_PATH) <> 0
 then
  begin
   C := S[1];
   S[1] := '$';
   SetConsoleTitle(PChar(S));
   Result := FindWindow(nil, PChar(S));
   S[1] := C;
   SetConsoleTitle(PChar(S));
  end;
end;

function NT_GetConsoleDisplayMode(var lpdwMode: DWORD): Boolean;
type
 TGetConsoleDisplayMode = function(var lpdwMode: DWORD): BOOL;
 stdcall;
var
 hKernel: THandle;
 GetConsoleDisplayMode: TGetConsoleDisplayMode;
begin
 Result := False;
 hKernel := GetModuleHandle('kernel32.dll');
 if (hKernel > 0)
 then
  begin
   @GetConsoleDisplayMode:=GetProcAddress(hKernel, 'GetConsoleDisplayMode');
   if Assigned(GetConsoleDisplayMode)
   then Result := GetConsoleDisplayMode(lpdwMode);
  end;
end;

function NT_SetConsoleDisplayMode(hOut: THandle; dwNewMode: DWORD;
  var lpdwOldMode: DWORD): Boolean;
type
 TSetConsoleDisplayMode = function(hOut: THandle; dwNewMode: DWORD;
 var lpdwOldMode: DWORD): BOOL;
 stdcall;
var
 hKernel: THandle;
 SetConsoleDisplayMode: TSetConsoleDisplayMode;
begin
 Result := False;
 hKernel := GetModuleHandle('kernel32.dll');
 if (hKernel > 0)
 then
  begin
   @SetConsoleDisplayMode:=GetProcAddress(hKernel, 'SetConsoleDisplayMode');
   if Assigned(SetConsoleDisplayMode)
   then Result := SetConsoleDisplayMode(hOut, dwNewMode, lpdwOldMode);
  end;
end;

function SetConsoleFullScreen(bFullScreen: Boolean): Boolean;
const
 MAGIC_CONSOLE_TOGGLE=57359;
var
 dwOldMode: DWORD;
 dwNewMode: DWORD;
 hOut: THandle;
 hConsole: THandle;
begin
 if Win32Platform = VER_PLATFORM_WIN32_NT
 then
  begin
   dwNewMode := Ord(bFullScreen);
   NT_GetConsoleDisplayMode(dwOldMode);
   hOut := GetStdHandle(STD_OUTPUT_HANDLE);
   Result := NT_SetConsoleDisplayMode(hOut, dwNewMode, dwOldMode);
  end
 else
  begin
   hConsole := GetConsoleWindow;
   Result := hConsole <> 0;
   if Result
   then
    begin
     if bFullScreen
     then // SendMessage(GetConsoleWindow, WM_COMMAND, MAGIC_CONSOLE_TOGGLE, 0);
     else
      begin
       // Better solution than keybd_event under Win9X ?
       keybd_event(VK_MENU, MapVirtualKey(VK_MENU, 0), 0, 0);
       keybd_event(VK_RETURN, MapVirtualKey(VK_RETURN, 0), 0, 0);
       keybd_event(VK_RETURN, MapVirtualKey(VK_RETURN, 0), KEYEVENTF_KEYUP, 0);
       keybd_event(VK_MENU, MapVirtualKey(VK_MENU, 0), KEYEVENTF_KEYUP, 0);
      end;
    end;
  end;
end;

///////////////////////////////////////

function GetConOutputHandle: THandle;
begin
 Result:=GetStdHandle(STD_OUTPUT_HANDLE);
end;

begin
 SetConsoleTitle('SCHEMEK');
 SetConsoleFullScreen(true); // переключение в полноэкранный режим
 SetConsoleFullScreen(false); // для Win 98
 SetConsoleFullScreen(true); // для Win 98
 SetConsoleOutputCP(866); // для NT
 //
 s:='КЛЮЧ - ';
 SetLength(NewStr, Length(s));
 CharToOem(PChar(s), PChar(NewStr));
 Write(NewStr);
 Readln(s);
 if s<>'1323' then Exit;
 s:='ДИСК - ';
 SetLength(NewStr, Length(s));
 CharToOem(PChar(s), PChar(NewStr));
 Write(NewStr);
 Readln;
 //
All:
 GetConsoleScreenBufferInfo(GetStdHandle(STD_OUTPUT_HANDLE),sbi);
 for i:=0 to 40 do // sbi.dwSize.y
  WriteLn;
 //
 Coord.X:=10;
 Coord.Y:=10;
 ConHandle:=GetConOutputHandle;
 SetConsoleCursorPosition(ConHandle, Coord);
 s:='1. О ПРОГРАММЕ';
 SetLength(NewStr, Length(s));
 CharToOem(PChar(s), PChar(NewStr));
 WriteLn(NewStr);
 //
 Coord.X:=10;
 Coord.Y:=11;
 ConHandle:=GetConOutputHandle;
 SetConsoleCursorPosition(ConHandle, Coord);
 s:='2. ОБУЧЕНИЕ';
 SetLength(NewStr, Length(s));
 CharToOem(PChar(s), PChar(NewStr));
 WriteLn(NewStr);
 //
 Coord.X:=10;
 Coord.Y:=12;
 ConHandle:=GetConOutputHandle;
 SetConsoleCursorPosition(ConHandle, Coord);
 s:='3. КОНТРОЛЬ';
 SetLength(NewStr, Length(s));
 CharToOem(PChar(s), PChar(NewStr));
 WriteLn(NewStr);
 //
 Coord.X:=10;
 Coord.Y:=13;
 ConHandle:=GetConOutputHandle;
 SetConsoleCursorPosition(ConHandle, Coord);
 s:='0. КОНЕЦ РАБОТЫ';
 SetLength(NewStr, Length(s));
 CharToOem(PChar(s), PChar(NewStr));
 WriteLn(NewStr);
 //
 Coord.X:=10;
 Coord.Y:=15;
 ConHandle:=GetConOutputHandle;
 SetConsoleCursorPosition(ConHandle, Coord);
 s:='ВАШ ОТВЕТ - ?';
 SetLength(NewStr, Length(s));
 CharToOem(PChar(s), PChar(NewStr));
 Write(NewStr);
 Write(' ');
 Read(s);
 //////////////////////////////////////////////////////////////
 if s='0' then Exit;
 //////////////////////////////////////////////////////////////
 if s='1' then
  begin
   GetConsoleScreenBufferInfo(GetStdHandle(STD_OUTPUT_HANDLE),sbi);
   for i:=0 to 40 do // sbi.dwSize.y
    WriteLn;
   //
   Coord.X:=0;
   Coord.Y:=0;
   ConHandle:=GetConOutputHandle;
   SetConsoleCursorPosition(ConHandle, Coord);
   //
   Assignfile(f,'about.txt');
   Reset(f);
   while not (EOF(f)) do
    begin
     ReadLn(f,s);
     SetLength(Result, Length(s));
     if Length(Result)>0
     then AnsiToOem(PChar(s), PChar(Result));
     if Length(Result)>0
     then
      begin
       AnsiToOem(StrPCopy(Source, s), Dest);
       Result:=StrPas(Dest);
      end;
     Writeln(s);
    end;   
   CloseFile(f);
   ReadLn;
   ReadLn;
   goto All;
  end;
 //////////////////////////////////////////////////////////////
 if s='2' then
  begin
   GetConsoleScreenBufferInfo(GetStdHandle(STD_OUTPUT_HANDLE),sbi);
   for i:=0 to 40 do // sbi.dwSize.y
    WriteLn;
   //
   Coord.X:=9;
   Coord.Y:=1;
   ConHandle:=GetConOutputHandle;
   SetConsoleCursorPosition(ConHandle, Coord);
   //
   s:='ВЫБЕРИТЕ РАЗДЕЛ:';
   SetLength(NewStr, Length(s));
   CharToOem(PChar(s), PChar(NewStr));
   WriteLn(NewStr);
   WriteLn;
   //
   Assignfile(f,'contcx.dat');
   Reset(f);
   while not (EOF(f)) do
    begin
     ReadLn(f,s);
     SetLength(Result, Length(s));
     if Length(Result)>0
     then AnsiToOem(PChar(s), PChar(Result));
     if Length(Result)>0
     then
      begin
       AnsiToOem(StrPCopy(Source, s), Dest);
       Result:=StrPas(Dest);
     end;
     Writeln(s);
    end;
    //
   WriteLn;
   s:='ВАШ ОТВЕТ - ?';
   SetLength(NewStr, Length(s));
   CharToOem(PChar(s), PChar(NewStr));
   Write(NewStr);
   Write(' ');
   Readln;
   Read(s0);
   //
   Writeln;
   s:='ПЕРВАЯ СХЕМА - ?';
   SetLength(NewStr, Length(s));
   CharToOem(PChar(s), PChar(NewStr));
   Write(NewStr);
   Write(' ');
   Readln;
   Read(s1);
   //
   Write;
   s:='ПОСЛЕДНЯЯ СХЕМА - ?';
   SetLength(NewStr, Length(s));
   CharToOem(PChar(s), PChar(NewStr));
   Write(NewStr);
   Write(' ');
   Readln;
   Read(s2);
   //
   Write;
   s:='ЧИСЛО ЗАДАЧ ПО СХЕМЕ: 1-ОДНА, 2-ОСНОВНЫЕ, 3-ВСЕ  ?';
   SetLength(NewStr, Length(s));
   CharToOem(PChar(s), PChar(NewStr));
   Write(NewStr);
   Write(' ');
   Readln;
   Readln;   
   //
   if (s0='1') or (s0='2') or (s0='3') or (s0='4')
   then
    begin
     GetConsoleScreenBufferInfo(GetStdHandle(STD_OUTPUT_HANDLE),sbi);
     for i:=0 to 40 do // sbi.dwSize.y
      WriteLn;
     //
     Coord.X:=0;
     Coord.Y:=0;
     ConHandle:=GetConOutputHandle;
     SetConsoleCursorPosition(ConHandle, Coord);
     //
     Assignfile(f,'End.txt');
     Reset(f);
     i:=0;
     while not (EOF(f)) do
      begin
       inc(i);
       if (i=1) or (i=3) or (i=4) or (i=5)
       then
        begin
         if i=1
         then
          begin
           ReadLn(f,s);
           s0:='Раздел - 0'+s0;
           SetLength(NewStr, Length(s0));
           CharToOem(PChar(s0), PChar(NewStr));
           WriteLn(NewStr);
          end;
         if i=3
         then
          begin
           ReadLn(f,s);
           ss1:=s1;
           s1:='Первая схема -  '+s1;
           SetLength(NewStr, Length(s1));
           CharToOem(PChar(s1), PChar(NewStr));
           WriteLn(NewStr);
          end;
         if i=4
         then
          begin
           ReadLn(f,s);
           ss2:=s2;
           s2:='Последняя схема -  '+s2;
           SetLength(NewStr, Length(s2));
           CharToOem(PChar(s2), PChar(NewStr));
           WriteLn(NewStr);
          end;
         if i=5
         then
          begin
           ReadLn(f,s);
           s3:=IntToStr(Abs(StrToInt(ss2)-StrToInt(ss1)+1));
           s3:='Всего задач -  '+s3;
           SetLength(NewStr, Length(s3));
           CharToOem(PChar(s3), PChar(NewStr));
           WriteLn(NewStr);
          end;
         end
       else
        begin
         ReadLn(f,s);
         SetLength(NewStr, Length(s));
         CharToOem(PChar(s), PChar(NewStr));
         WriteLn(NewStr);
        end;
      end;
     Coord.X:=50; // влево/вправо
     Coord.Y:=10; // вверх/вниз
     ConHandle:=GetConOutputHandle;
     SetConsoleCursorPosition(ConHandle, Coord);
     ReadLn;
    end;
   CloseFile(f);
  end;
 //////////////////////////////////////////////////////////////
 if s='3' then
  begin
   GetConsoleScreenBufferInfo(GetStdHandle(STD_OUTPUT_HANDLE),sbi);
   for i:=0 to 40 do // sbi.dwSize.y
    WriteLn;
   //
   Coord.X:=9;
   Coord.Y:=1;
   ConHandle:=GetConOutputHandle;
   SetConsoleCursorPosition(ConHandle, Coord);
   //
   s:='ВЫБЕРИТЕ РАЗДЕЛ:';
   SetLength(NewStr, Length(s));
   CharToOem(PChar(s), PChar(NewStr));
   WriteLn(NewStr);
   WriteLn;
   //
   Assignfile(f,'contcx.dat');
   Reset(f);
   while not (EOF(f)) do
    begin
     ReadLn(f,s);
     SetLength(Result, Length(s));
     if Length(Result)>0
     then AnsiToOem(PChar(s), PChar(Result));
     if Length(Result)>0
     then
      begin
       AnsiToOem(StrPCopy(Source, s), Dest);
       Result:=StrPas(Dest);
     end;
     Writeln(s);
    end;
    //
   WriteLn;
   s:='ВАШ ОТВЕТ - ?';
   SetLength(NewStr, Length(s));
   CharToOem(PChar(s), PChar(NewStr));
   Write(NewStr);
   Write(' ');
   Readln;
   Read(s0);
   //
   Writeln;
   s:='ПЕРВАЯ СХЕМА - ?';
   SetLength(NewStr, Length(s));
   CharToOem(PChar(s), PChar(NewStr));
   Write(NewStr);
   Write(' ');
   Readln;
   Read(s1);
   //
   Write;
   s:='ПОСЛЕДНЯЯ СХЕМА - ?';
   SetLength(NewStr, Length(s));
   CharToOem(PChar(s), PChar(NewStr));
   Write(NewStr);
   Write(' ');
   Readln;
   Read(s2);
   //
   Write;
   s:='ЧИСЛО ЗАДАЧ ПО СХЕМЕ: 1-ОДНА, 2-ОСНОВНЫЕ, 3-ВСЕ  ?';
   SetLength(NewStr, Length(s));
   CharToOem(PChar(s), PChar(NewStr));
   Write(NewStr);
   Write(' ');
   Readln;
   Readln;
   //
   if (s0='1') or (s0='2') or (s0='3') or (s0='4')
   then
    begin
     GetConsoleScreenBufferInfo(GetStdHandle(STD_OUTPUT_HANDLE),sbi);
     for i:=0 to 40 do // sbi.dwSize.y
      WriteLn;
     //
     Coord.X:=0;
     Coord.Y:=0;
     ConHandle:=GetConOutputHandle;
     SetConsoleCursorPosition(ConHandle, Coord);
     //
     Assignfile(f,'End.txt');
     Reset(f);
     i:=0;
     while not (EOF(f)) do
      begin
       inc(i);
       if (i=1) or (i=3) or (i=4) or (i=5)
       then
        begin
         if i=1
         then
          begin
           ReadLn(f,s);
           s0:='Раздел - 0'+s0;
           SetLength(NewStr, Length(s0));
           CharToOem(PChar(s0), PChar(NewStr));
           WriteLn(NewStr);
          end;
         if i=3
         then
          begin
           ReadLn(f,s);
           ss1:=s1;
           s1:='Первая схема -  '+s1;
           SetLength(NewStr, Length(s1));
           CharToOem(PChar(s1), PChar(NewStr));
           WriteLn(NewStr);
          end;
         if i=4
         then
          begin
           ReadLn(f,s);
           ss2:=s2;
           s2:='Последняя схема -  '+s2;
           SetLength(NewStr, Length(s2));
           CharToOem(PChar(s2), PChar(NewStr));
           WriteLn(NewStr);
          end;
         if i=5
         then
          begin
           ReadLn(f,s);
           s3:=IntToStr(Abs(StrToInt(ss2)-StrToInt(ss1)+1));
           s3:='Всего задач -  '+s3;
           SetLength(NewStr, Length(s3));
           CharToOem(PChar(s3), PChar(NewStr));
           WriteLn(NewStr);
          end;
         end
       else
        begin
         ReadLn(f,s);
         SetLength(NewStr, Length(s));
         CharToOem(PChar(s), PChar(NewStr));
         WriteLn(NewStr);
        end;
      end;
     Coord.X:=50; // влево/вправо
     Coord.Y:=10; // вверх/вниз
     ConHandle:=GetConOutputHandle;
     SetConsoleCursorPosition(ConHandle, Coord);
     ReadLn;
    end;
   CloseFile(f);
  end;
 //
 i:=0;
 while i=0 do // чтобы курсор оставался на месте
  begin
   Coord.X:=50; // влево/вправо
   Coord.Y:=10; // вверх/вниз
   ConHandle:=GetConOutputHandle;
   SetConsoleCursorPosition(ConHandle, Coord);
   Readln;
  end;
end.
