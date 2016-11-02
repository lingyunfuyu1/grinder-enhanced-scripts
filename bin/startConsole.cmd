@echo off
set SCRIPT_NAME=%~nx0
echo +++++++++++++++++++++++++++++++++
echo + SCRIPT_NAME: %SCRIPT_NAME% +
echo +++++++++++++++++++++++++++++++++
echo.

set CURRENT_PATH_TMP=%~dp0
set CURRENT_PATH=%CURRENT_PATH_TMP:~0,-1%
echo CURRENT_PATH=%CURRENT_PATH%
echo.

call "%CURRENT_PATH%\setGrinderEnv.cmd"
echo JAVA_HOME=%JAVA_HOME%
echo.

echo CLASSPATH=%CLASSPATH%
echo.

echo ---------------------------------
"%JAVA_HOME%\bin\java.exe" -cp "%CLASSPATH%" net.grinder.Console
pause
