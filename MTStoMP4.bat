@echo off
rem Copyright (C) 2013 yumetodo
rem Distributed under the Boost Software License, Version 1.0.
echo ********************************
echo *  mts to mp4 batch Vor.1.0.0  *
echo ********************************

echo %DATE% %TIME% MTS�t�@�C����MP4�ɂ��Ă݂�

title�@MTS�t�@�C����MP4�ɂ��Ă݂�

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
echo tsMuxeR.exe�̂���ꏊ����͂��ĉ�����
echo -----------------------------------------
echo ��jC:\Program Files (x86)\XviD4PSP 5\apps\tsMuxeR
set /p PLACE1=
IF NOT EXIST "%PLACE1%\tsMuxeR.exe" goto errora
goto SETTINGb

:SETTINGb
echo -----------------------------------------
echo BeSweet.exe�̂���ꏊ����͂��ĉ�����
echo -----------------------------------------
echo ��jD:\�v���O�����@�p�x��\BeLight
set /p PLACE2=
IF NOT EXIST "%PLACE2%\BeSweet.exe" goto errorb
goto SETTINGc

:SETTINGc
echo -----------------------------------------
echo neroAacEnc.exe�̂���ꏊ����͂��ĉ�����
echo -----------------------------------------
echo ��jC:\Program Files (x86)\XviD4PSP 5\apps\neroAacEnc
set /p PLACE3=
IF NOT EXIST "%PLACE3%\neroAacEnc.exe" goto errorc
goto SETTINGd

:SETTINGd
echo ---------------------------------------------------------
echo neroAacEnc.exe�̃G���R�[�h�I�v�V�������w�肵�Ă�������
echo ---------------------------------------------------------
echo ��j-q 0.50 -lc
echo �悭�킩��Ȃ��Ƃ��� help �Ƒł��Ă��������B�󔒕s�ł��B
set /p OPTION=
IF "%OPTION%."=="." GOTO errord
IF "%OPTION%"=="help" GOTO LINK
goto SETTINGe

:LINK
start http://note.chiebukuro.yahoo.co.jp/detail/n136981
GOTO SETTINGd

:SETTINGe
echo -----------------------------------------
echo MP4Box.exe�̂���ꏊ����͂��ĉ�����
echo -----------------------------------------
echo ��jC:\Program Files (x86)\XviD4PSP 5\apps\MP4Box
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
echo �t�@�C�����A�g���q�����ُ�ł��B�������X�L�b�v���܂�
GOTO enderror

:errora
echo tsMuxeR.exe�̂���ꏊ�𐳂����w�肵�Ă��������B
GOTO SETTINGa

:errorb
echo BeSweet.exe�̂���ꏊ�𐳂����w�肵�Ă��������B
GOTO SETTINGb

:errorc
echo neroAacEnc.exe�̂���ꏊ�𐳂����w�肵�Ă��������B
GOTO SETTINGc

:errord
echo �G���R�[�h�I�v�V�����𐳂����w�肵�Ă�������
GOTO SETTINGd

:errorf
echo MP4Box.exe�̂���ꏊ�𐳂����w�肵�Ă��������B
GOTO SETTINGe

:erroroftsMuxeR
echo �ϊ��ߒ��itsMuxeR�j�ŃG���[�������܂����B�\���󂠂�܂���B
GOTO enderror

:errorofBeSweet
echo �ϊ��ߒ��iBeSweet�j�ŃG���[�������܂����B�\���󂠂�܂���B
GOTO enderror

:errorofneroAacEnc
echo �ϊ��ߒ��ineroAacEnc�j�ŃG���[�������܂����B�\���󂠂�܂���B
GOTO enderror

:errorofMP4Box
echo �ϊ��ߒ��iMP4Box�j�ŃG���[�������܂����B�\���󂠂�܂���B
GOTO enderror

:end
echo %DATE% %TIME% MTS�t�@�C����MP4�ɖ����ϊ�����܂����B
echo �ϊ����t�@�C���Ɠ����ꏊ�ɏo�͂���Ă��܂��B
goto DELASK

:DELASK
echo �ϊ��ߒ��Ő������t�@�C�����폜���܂����H�iy/n�j
set /p YORN=
IF %YORN%==y GOTO DEL
IF %YORN%.==n GOTO quit
GOTO DELERROR

:DELERROR
echo �������܂����Ay��n�ł��������������B
goto DELASK

:enderror
echo %DATE% %TIME% MTS�t�@�C����MP4�ɕϊ�����܂���ł����B
GOTO quit

:DEL
del %OUTFILE%.meta
del %OUTFILE%.264
del %OUTFILE%.ac3
del %OUTFILE%.m4a
del %INPath%1
echo �폜���܂����B
GOTO quit

:quit
ENDLOCAL
echo �����m�ɂ́u�I�������邽�߂ɂ́`�v�Ȃ�ł����ǂ�
PAUSE