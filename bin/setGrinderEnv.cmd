@echo off
set SCRIPT_NAME=%~nx0
rem echo ++++++++++++++++++++++++++++++++++
rem echo + SCRIPT_NAME: %SCRIPT_NAME% +
rem echo ++++++++++++++++++++++++++++++++++
rem echo.

set CURRENT_PATH_TMP=%~dp0
set CURRENT_PATH=%CURRENT_PATH_TMP:~0,-1%
rem echo CURRENT_PATH=%CURRENT_PATH%
rem echo.

set GRINDER_PATH=%CURRENT_PATH%\..\grinder-3.11
rem echo GRINDER_PATH=%GRINDER_PATH%
rem echo.

set GRINDER_PROPERTIES=%GRINDER_PATH%\examples\grinder.properties
rem echo GRINDER_PROPERTIES=%GRINDER_PROPERTIES%
rem echo.

set CLASSPATH=%GRINDER_PATH%\lib\grinder.jar;%CLASSPATH%
rem echo CLASSPATH=%CLASSPATH%
rem echo.

set JAVA_HOME=%CURRENT_PATH%\..\jdk1.7.0_79_windows
rem echo JAVA_HOME=%JAVA_HOME%
rem echo.
