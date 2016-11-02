@echo off
rem -------------------------------------
rem File:           runTest.sh
rem Description:    Enhandcing The Grinder
rem Version:        v0.9
rem History:        1. Created 2016/10/27
rem Author:         hzcaojianglong
rem Email:			caojl01@gmail.com
rem Notes:			Use on Windows
rem -------------------------------------

set SCRIPT_NAME=%~nx0
echo ++++++++++++++++++++++++++++
echo + SCRIPT_NAME: %SCRIPT_NAME% +
echo ++++++++++++++++++++++++++++
echo.

set ENHANCED_GRINDER_HOME_TMP=%~dp0
set ENHANCED_GRINDER_HOME=%ENHANCED_GRINDER_HOME_TMP:~0,-1%

SET CONFIG_FILE=conf\enhanced_grinder.conf
if exist %CONFIG_FILE% (FOR /F "tokens=1,2 delims==" %%i in (%CONFIG_FILE%) DO (SET %%i=%%j)) else (echo %CONFIG_FILE% does not exist & pause & exit) 

set JAVA_HOME=%JAVA_HOME:~1%
set JAVA_HOME=%JAVA_HOME:~0,-1%
set JAVA_PATH=%JAVA_HOME%\bin\java.exe
if not "%JAVA_PATH:~1,1%"==":" (set JAVA_PATH=%ENHANCED_GRINDER_HOME%\%JAVA_PATH%)
if not exist "%JAVA_PATH%" (echo The property JAVA_HOME is incorrectly set! & pause & exit)
echo JAVA_PATH=%JAVA_PATH%
echo.

set GRINDER_HOME=%GRINDER_HOME:~1%
set GRINDER_HOME=%GRINDER_HOME:~0,-1%
if not "%GRINDER_HOME:~1,1%"==":" (set GRINDER_HOME=%ENHANCED_GRINDER_HOME%\%GRINDER_HOME%)
if not exist %GRINDER_HOME% (echo The property GRINDER_HOME is incorrectly set! & set GRINDER_HOME=%ENHANCED_GRINDER_HOME%\grinder-3.11 & echo Use system default setting)
echo GRINDER_HOME=%GRINDER_HOME%
echo.

set DEFAULT_GRINDER_PROPERTIES=%DEFAULT_GRINDER_PROPERTIES:~1%
set DEFAULT_GRINDER_PROPERTIES=%DEFAULT_GRINDER_PROPERTIES:~0,-1%
if not "%DEFAULT_GRINDER_PROPERTIES:~1,1%"==":" (set DEFAULT_GRINDER_PROPERTIES=%ENHANCED_GRINDER_HOME%\%DEFAULT_GRINDER_PROPERTIES%)
if not exist %DEFAULT_GRINDER_PROPERTIES% (echo The property DEFAULT_GRINDER_PROPERTIES is incorrectly set! & set DEFAULT_GRINDER_PROPERTIES=%ENHANCED_GRINDER_HOME%\grinder.properties & echo Use system default setting)
echo DEFAULT_GRINDER_PROPERTIES=%DEFAULT_GRINDER_PROPERTIES%
echo.

:input
rem 警告：输入的内容不能只包含若干个空格，搞不定！
set /p GRINDER_PROPERTIES_READ=Enter the absolute path of your grinder.properties:
rem echo 0[%GRINDER_PROPERTIES_READ%]

if defined GRINDER_PROPERTIES_READ (
    goto slash_replace
) else goto use_default

:slash_replace
set GRINDER_PROPERTIES_READ=%GRINDER_PROPERTIES_READ:/=\%
rem echo 1%GRINDER_PROPERTIES_READ%

:intercept_left
if "%GRINDER_PROPERTIES_READ:~0,1%"==" " set "GRINDER_PROPERTIES_READ=%GRINDER_PROPERTIES_READ:~1%"&goto intercept_left
rem echo 2[%GRINDER_PROPERTIES_READ%]

:intercept_right
if "%GRINDER_PROPERTIES_READ:~-1%"==" " set "GRINDER_PROPERTIES_READ=%GRINDER_PROPERTIES_READ:~0,-1%"&goto intercept_right
rem echo 3[%GRINDER_PROPERTIES_READ%]

if not "%GRINDER_PROPERTIES_READ:~1,1%"==":" set GRINDER_PROPERTIES_READ=%ENHANCED_GRINDER_HOME%\%GRINDER_PROPERTIES_READ%
rem echo 4[%GRINDER_PROPERTIES_READ%]
if "%GRINDER_PROPERTIES_READ:~-1%"=="/" set GRINDER_PROPERTIES_READ=%GRINDER_PROPERTIES_READ:~0,-1%
rem echo 4[%GRINDER_PROPERTIES_READ%]
if "%GRINDER_PROPERTIES_READ:~-1%"=="\" set GRINDER_PROPERTIES_READ=%GRINDER_PROPERTIES_READ:~0,-1%
rem echo 5[%GRINDER_PROPERTIES_READ%]
if not "%GRINDER_PROPERTIES_READ:~-18%"=="grinder.properties" set GRINDER_PROPERTIES_READ=%GRINDER_PROPERTIES_READ%\grinder.properties
rem echo 6[%GRINDER_PROPERTIES_READ%]
if not exist %GRINDER_PROPERTIES_READ% echo The path [%GRINDER_PROPERTIES_READ%] does not exist! Please re-enter. & goto input

set GRINDER_PROPERTIES_USER=%GRINDER_PROPERTIES_READ%
goto display_properties

:use_default
set GRINDER_PROPERTIES_USER=%ENHANCED_GRINDER_HOME%\grinder.properties

:display_properties
echo GRINDER_PROPERTIES_USER=%GRINDER_PROPERTIES_USER%
echo.

for /f "delims=" %%t in ('findstr /R "^grinder.script" "%GRINDER_PROPERTIES_USER%"') do set script=%%t
echo %script%
for /f "delims=" %%t in ('findstr /R "^grinder.processes" "%GRINDER_PROPERTIES_USER%"') do set processes=%%t
echo %processes%
for /f "delims=" %%t in ('findstr /R "^grinder.threads" "%GRINDER_PROPERTIES_USER%"') do set threads=%%t
echo %threads%
for /f "delims=" %%t in ('findstr /R "^grinder.runs" "%GRINDER_PROPERTIES_USER%"') do set runs=%%t
echo %runs%
for /f "delims=" %%t in ('findstr /R "^grinder.duration" "%GRINDER_PROPERTIES_USER%"') do set duration=%%t
echo %duration%(ms)
echo.

set CLASSPATH="%GRINDER_HOME%\lib\*;%ENHANCED_GRINDER_HOME%\lib\*"


set SCRIPT_PATH_PREFIX=%GRINDER_PROPERTIES_USER:~0,-19%
for /f "tokens=2 delims==" %%i in ("%script%") do set SCRIPT_PATH_SUFFIX=%%i
for /f "tokens=*" %%i in ("%SCRIPT_PATH_SUFFIX%") do set SCRIPT_PATH_SUFFIX=%%i
set SCRIPT_PATH=%SCRIPT_PATH_PREFIX%/%SCRIPT_PATH_SUFFIX%
set SCRIPT_PATH=%SCRIPT_PATH:/=\%
echo %SCRIPT_PATH%
echo ---------------------------------
echo "%JAVA_PATH%" -cp %CLASSPATH% net.grinder.Grinder "%GRINDER_PROPERTIES_USER%"
cd %SCRIPT_PATH%\.. & "%JAVA_PATH%" -cp %CLASSPATH% net.grinder.Grinder "%GRINDER_PROPERTIES_USER%"
echo ---------------------------------
echo Press Any Key To Close This Window
pause>nul
