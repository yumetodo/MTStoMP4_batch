@echo off
rem Copyright (C) 2013 yumetodo
rem Distributed under the Boost Software License, Version 1.0.
echo ********************************
echo *  mts to mp4 batch Vor.1.1.0  *
echo ********************************

echo %DATE% %TIME% MTSファイルをMP4にしてみる

title　MTSファイルをMP4にしてみる

SETLOCAL

SET BATPATH=%~dp0
SET INPath=%~dp1
SET OUTFILE=%~dpn1
SET INNAME=%~n1
SET foldername=MtoMwork%date:~-10,4%%date:~-5,2%%date:~-2,2%%time:~-11,2%%time:~-8,2%%time:~-5,2%
IF NOT "%foldername:~8,2"=="%date:~-2,2" SET foldername=MtoMwork%date:~-10,4%%date:~-5,2%%date:~-2,2%%time:~-11,2%%time:~-8,2%%time:~-5,2%
IF %INPath%.==. GOTO ferror
IF "%~x1"==".mts" GOTO INICHECK
IF "%~x1"==".MTS" GOTO INICHECK
GOTO ferror

:INICHECK
IF EXIST "%BATPATH%\MTStoMP4config.ini" (goto INIRead) ELSE echo 毎回EXEファイルの位置を指定するのは面倒です。設定ファイルを保存しますか？y or nでどうぞ
SET  /pinipreset=
GOTO SETTINGa

:INIRead
SET inipreset=n

echo 設定ファイルを読み込んでいます

for /F "usebackq" %i in ("findstr /i PLACE1 "%BATPATH%\MTStoMP4config.ini"") do set PLACE1=%i
set PLACE1=%PLACE1:~7%
IF not exist "%PLACE1%\tsMuxeR.exe" GOTO inierror

for /F "usebackq" %i in ("findstr /i PLACE1 "%BATPATH%\MTStoMP4config.ini"") do set PLACE1=%i
set PLACE2=%PLACE2:~7%
IF not exist "%PLACE2%\BeSweet.exe" GOTO inierror

for /F "usebackq" %i in ("findstr /i PLACE1 "%BATPATH%\MTStoMP4config.ini"") do set PLACE1=%i
set PLACE3=%PLACE3:~7%
IF not exist "%PLACE3%\neroAacEnc.exe" GOTO inierror

for /F "usebackq" %i in ("findstr /i PLACE1 "%BATPATH%\MTStoMP4config.ini"") do set PLACE1=%i
set OPTION=%OPTION:~7%
IF %OPTION%=="" GOTO inierror

for /F "usebackq" %i in ("findstr /i PLACE1 "%BATPATH%\MTStoMP4config.ini"") do set PLACE1=%i
set PLACE4=%PLACE4:~7%
IF not exist "%PLACE4%\MP4Box.exe" GOTO inierror

echo 読み込み終了！
goto demux

:SETTINGa
echo -----------------------------------------
echo tsMuxeR.exeのある場所を入力して下さい
echo -----------------------------------------
echo 例）C:\Program Files (x86)\XviD4PSP 5\apps\tsMuxeR
set /p PLACE1=
IF NOT EXIST "%PLACE1%\tsMuxeR.exe" goto errora
goto SETTINGb

:SETTINGb
echo -----------------------------------------
echo BeSweet.exeのある場所を入力して下さい
echo -----------------------------------------
echo 例）D:\プログラム　頻度低\BeLight
set /p PLACE2=
IF NOT EXIST "%PLACE2%\BeSweet.exe" goto errorb
goto SETTINGc

:SETTINGc
echo -----------------------------------------
echo neroAacEnc.exeのある場所を入力して下さい
echo -----------------------------------------
echo 例）C:\Program Files (x86)\XviD4PSP 5\apps\neroAacEnc
set /p PLACE3=
IF NOT EXIST "%PLACE3%\neroAacEnc.exe" goto errorc
goto SETTINGd

:SETTINGd
echo ---------------------------------------------------------
echo neroAacEnc.exeのエンコードオプションを指定してください
echo ---------------------------------------------------------
echo 例）-q 0.50 -lc
echo よくわからないときは help と打ってください。空白不可です。
set /p OPTION=
IF "%OPTION%."=="." GOTO errord
IF /i "%OPTION%"=="help" GOTO LINK
goto SETTINGe

:LINK
start http://note.chiebukuro.yahoo.co.jp/detail/n136981
GOTO SETTINGd

:SETTINGe
echo -----------------------------------------
echo MP4Box.exeのある場所を入力して下さい
echo -----------------------------------------
echo 例）C:\Program Files (x86)\XviD4PSP 5\apps\MP4Box
set /p PLACE4=
IF "%PLACE4%."=="." GOTO errorf
IF NOT EXIST "%PLACE3%\neroAacEnc.exe" goto errorf
IF /i %inipreset%==y GOTO INImake
goto demux

:INImake
echo .iniファイルを製作中です。しばらくお待ちください。
echo MTStoMP4vなんか　のための設定ファイル　by yumetodo > %BATPATH%\MTStoMP4config.ini
echo tsMuxeR.exeのある場所 >> %BATPATH%MTStoMP4config.ini
echo PLACE1=%PLACE1% >> %BATPATH%MTStoMP4config.ini
echo BeSweet.exeのある場所 >> %BATPATH%MTStoMP4config.ini
echo PLACE2=%PLACE2% >> %BATPATH%MTStoMP4config.ini
echo neroAacEnc.exeのある場所 >> %BATPATH%MTStoMP4config.ini
echo PLACE3=%PLACE3% >> %BATPATH%MTStoMP4config.ini
echo neroAacEnc.exeのエンコードオプション >> %BATPATH%MTStoMP4config.ini
echo OPTION=%OPTION% >> %BATPATH%MTStoMP4config.ini
echo MP4Box.exeのある場所 >> %BATPATH%MTStoMP4config.ini
echo PLACE4=%PLACE4% >> %BATPATH%MTStoMP4config.ini

PAUSE

goto demux
:demux
rem mdコマンドのフォルダー名を%date%%time%に要変更！
md %INPath%%foldername%
md %INPath%%foldername%\forMP4box
cd %INPath%

echo MUXOPT --no-pcr-on-video-pid --new-audio-pes --vbr --vbv-len=500 >%INPath%\%foldername%\%INNAME%.meta
echo V_MPEG4/ISO/AVC, "%OUTFILE%%~x1", fps=59.9401, insertSEI, contSPS, track=4113 >>%INPath%%foldername%\%INNAME%.meta
echo A_AC3, "%OUTFILE%%~x1", track=4352 >>%INPath%%foldername%\%INNAME%.meta

cd /d %PLACE1%
tsMuxeR.exe %INPath%%foldername%\%INNAME%.meta %INPath%%foldername%
goto convert

:convert
IF NOT EXIST "%INPath%%foldername%\%INNAME%.track_4352.ac3" goto erroroftsMuxeR
cd /d %PLACE2%
BeSweet.exe -core( -input "%INPath%%foldername%\%INNAME%.track_4352.ac3" -output "%INPath%\%foldername%\%INNAME%.wav"  -2ch -logfile "%INPath%%foldername%\%INNAME%BeSweet.log" ) -azid( -s stereo -c normal -L -3db ) -ota( -hybridgain ) -ssrc( --rate 44100 )

IF NOT EXIST "%INPath%%foldername%\%INNAME%.wav" goto errorofBeSweet
cd /d %PLACE3%
neroAacEnc.exe %OPTION% -if "%INPath%%foldername%\%INNAME%.wav" -of "%INPath%\%foldername%\%INNAME%.m4a"
goto mux

:mux
IF NOT EXIST "%INPath%%foldername%\%INNAME%.m4a" goto errorofneroAacEnc
cd /d %PLACE4%
MP4Box.exe -fps 24.000 -add "%INPath%%foldername%\%INNAME%.track_4113.264" -add "%INPath%\%foldername%\%INNAME%.m4a" -new "%OUTFILE%.mp4" -tmp "%INPath%%foldername%\forMP4box"
IF NOT EXIST "%OUTFILE%.mp4" goto errorofMP4Box
goto end

:ferror
echo ファイル名、拡張子等が異常です。処理をスキップします
GOTO enderror

:inierror
echo INIファイルを正しく作ってください。終了します。
GOTO quit

:errora
echo tsMuxeR.exeのある場所を正しく指定してください。
GOTO SETTINGa

:errorb
echo BeSweet.exeのある場所を正しく指定してください。
GOTO SETTINGb

:errorc
echo neroAacEnc.exeのある場所を正しく指定してください。
GOTO SETTINGc

:errord
echo エンコードオプションを正しく指定してください
GOTO SETTINGd

:errorf
echo MP4Box.exeのある場所を正しく指定してください。
GOTO SETTINGe

:erroroftsMuxeR
echo 変換過程（tsMuxeR）でエラーが生じました。申し訳ありません。
GOTO enderror

:errorofBeSweet
echo 変換過程（BeSweet）でエラーが生じました。申し訳ありません。
GOTO enderror

:errorofneroAacEnc
echo 変換過程（neroAacEnc）でエラーが生じました。申し訳ありません。
GOTO enderror

:errorofMP4Box
echo 変換過程（MP4Box）でエラーが生じました。申し訳ありません。
GOTO enderror

:end
echo %DATE% %TIME% MTSファイルはMP4に無事変換されました。
echo 変換元ファイルと同じ場所に出力されています。
goto DELASK

:DELASK
echo 変換過程で生じたファイルを削除しますか？（y/n）
set /p YORN=
IF /i %YORN%==y GOTO DEL
IF /i %YORN%==n GOTO quit
GOTO DELERROR

:DELERROR
echo 恐れ入りますが、yかnでお答えください。
goto DELASK

:enderror
echo %DATE% %TIME% MTSファイルはMP4に変換されませんでした。
GOTO quit

:DEL
rd /s /q %INPath%%foldername%
echo 削除しました。
GOTO quit

:quit
ENDLOCAL
echo ↓正確には「終了させるためには～」なんですけどね
PAUSE