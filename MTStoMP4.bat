@echo off
rem Copyright (C) 2013 yumetodo
rem Distributed under the Boost Software License, Version 1.0.
echo ********************************
echo *  mts to mp4 batch Vor.1.1.0  *
echo ********************************

echo %DATE% %TIME% MTS�t�@�C����MP4�ɂ��Ă݂�

title�@MTS�t�@�C����MP4�ɂ��Ă݂�

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
IF EXIST "%BATPATH%\MTStoMP4config.ini" (goto INIRead) ELSE echo ����EXE�t�@�C���̈ʒu���w�肷��͖̂ʓ|�ł��B�ݒ�t�@�C����ۑ����܂����Hy or n�łǂ���
SET  /pinipreset=
GOTO SETTINGa

:INIRead
SET inipreset=n

echo �ݒ�t�@�C����ǂݍ���ł��܂�

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

echo �ǂݍ��ݏI���I
goto demux

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
IF /i "%OPTION%"=="help" GOTO LINK
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
IF /i %inipreset%==y GOTO INImake
goto demux

:INImake
echo .ini�t�@�C���𐻍쒆�ł��B���΂炭���҂����������B
echo MTStoMP4v�Ȃ񂩁@�̂��߂̐ݒ�t�@�C���@by yumetodo > %BATPATH%\MTStoMP4config.ini
echo tsMuxeR.exe�̂���ꏊ >> %BATPATH%MTStoMP4config.ini
echo PLACE1=%PLACE1% >> %BATPATH%MTStoMP4config.ini
echo BeSweet.exe�̂���ꏊ >> %BATPATH%MTStoMP4config.ini
echo PLACE2=%PLACE2% >> %BATPATH%MTStoMP4config.ini
echo neroAacEnc.exe�̂���ꏊ >> %BATPATH%MTStoMP4config.ini
echo PLACE3=%PLACE3% >> %BATPATH%MTStoMP4config.ini
echo neroAacEnc.exe�̃G���R�[�h�I�v�V���� >> %BATPATH%MTStoMP4config.ini
echo OPTION=%OPTION% >> %BATPATH%MTStoMP4config.ini
echo MP4Box.exe�̂���ꏊ >> %BATPATH%MTStoMP4config.ini
echo PLACE4=%PLACE4% >> %BATPATH%MTStoMP4config.ini

PAUSE

goto demux
:demux
rem md�R�}���h�̃t�H���_�[����%date%%time%�ɗv�ύX�I
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
echo �t�@�C�����A�g���q�����ُ�ł��B�������X�L�b�v���܂�
GOTO enderror

:inierror
echo INI�t�@�C���𐳂�������Ă��������B�I�����܂��B
GOTO quit

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
IF /i %YORN%==y GOTO DEL
IF /i %YORN%==n GOTO quit
GOTO DELERROR

:DELERROR
echo �������܂����Ay��n�ł��������������B
goto DELASK

:enderror
echo %DATE% %TIME% MTS�t�@�C����MP4�ɕϊ�����܂���ł����B
GOTO quit

:DEL
rd /s /q %INPath%%foldername%
echo �폜���܂����B
GOTO quit

:quit
ENDLOCAL
echo �����m�ɂ́u�I�������邽�߂ɂ́`�v�Ȃ�ł����ǂ�
PAUSE