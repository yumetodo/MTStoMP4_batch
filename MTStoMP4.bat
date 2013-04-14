@echo off
rem Copyright (C) 2013 yumetodo
rem Distributed under the Boost Software License, Version 1.0.
echo ********************************
echo *  mts to mp4 batch Vor.1.0.0  *
echo ********************************

echo %DATE% %TIME% MTSファイルをMP4にしてみる

title　MTSファイルをMP4にしてみる

SETLOCAL

SET INPath=%~dp1
SET OUTFILE=%~dpn1
SET INNAME=%~n1
IF %INPath%.==. GOTO ferror
IF "%~x1"==".mts" GOTO SETTINGa
IF "%~x1"==".MTS" GOTO SETTINGa
GOTO ferror

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
IF "%OPTION%"=="help" GOTO LINK
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
goto demux

:demux
md %OUTFILE%
md %OUTFILE%\forMP4box
cd %INPath%

echo MUXOPT --no-pcr-on-video-pid --new-audio-pes --vbr --vbv-len=500 >%OUTFILE%\%INNAME%.meta
echo V_MPEG4/ISO/AVC, "%OUTFILE%%~x1", fps=59.9401, insertSEI, contSPS, track=4113 >>%OUTFILE%\%INNAME%.meta
echo A_AC3, "%OUTFILE%%~x1", track=4352 >>"%OUTFILE%"\%INNAME%.meta

cd /d %PLACE1%
tsMuxeR.exe %OUTFILE%\%INNAME%.meta %OUTFILE%
goto convert

:convert
IF NOT EXIST "%OUTFILE%\%INNAME%.track_4352.ac3" goto erroroftsMuxeR
cd /d %PLACE2%
BeSweet.exe -core( -input "%OUTFILE%\%INNAME%.track_4352.ac3" -output "%OUTFILE%\%INNAME%.wav"  -2ch -logfile "%OUTFILE%\%INNAME%BeSweet.log" ) -azid( -s stereo -c normal -L -3db ) -ota( -hybridgain ) -ssrc( --rate 44100 )

IF NOT EXIST "%OUTFILE%\%INNAME%.wav" goto errorofBeSweet
cd /d %PLACE3%
neroAacEnc.exe %OPTION% -if "%OUTFILE%\%INNAME%.wav" -of "%OUTFILE%\%INNAME%.m4a"
goto mux

:mux
IF NOT EXIST "%OUTFILE%\%INNAME%.m4a" goto errorofneroAacEnc
cd /d %PLACE4%
MP4Box.exe -fps 24.000 -add "%OUTFILE%\%INNAME%.track_4113.264" -add "%OUTFILE%\%INNAME%.m4a" -new "%OUTFILE%.mp4" -tmp "%OUTFILE%\forMP4box"
IF NOT EXIST "%OUTFILE%.mp4" goto errorofMP4Box
goto end

:ferror
echo ファイル名、拡張子等が異常です。処理をスキップします
GOTO enderror

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
IF %YORN%==y GOTO DEL
IF %YORN%.==n GOTO quit
GOTO DELERROR

:DELERROR
echo 恐れ入りますが、yかnでお答えください。
goto DELASK

:enderror
echo %DATE% %TIME% MTSファイルはMP4に変換されませんでした。
GOTO quit

:DEL
del %OUTFILE%.meta
del %OUTFILE%.264
del %OUTFILE%.ac3
del %OUTFILE%.m4a
del %INPath%1
echo 削除しました。
GOTO quit

:quit
ENDLOCAL
echo ↓正確には「終了させるためには～」なんですけどね
PAUSE