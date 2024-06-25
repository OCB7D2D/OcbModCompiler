@echo off

echo ***************************************
echo 7D2D (A20) Module Compiler v0.0.1
echo ***************************************

set ROSLYN_PATH_ORG=%ROSLYN_PATH%
if exist "%ROSLYN_PATH%\csc.exe" goto HasRoslyn
set ROSLYN_PATH=%ProgramFiles%\Microsoft Visual Studio\2022\Enterprise\MSBuild\Current\Bin\Roslyn
if exist "%ROSLYN_PATH%\csc.exe" goto HasRoslyn
set ROSLYN_PATH=%ProgramFiles(x86)%\Microsoft Visual Studio\2022\Enterprise\MSBuild\Current\Bin\Roslyn
if exist "%ROSLYN_PATH%\csc.exe" goto HasRoslyn
set ROSLYN_PATH=%ProgramFiles%\Microsoft Visual Studio\2022\Community\MSBuild\Current\Bin\Roslyn
if exist "%ROSLYN_PATH%\csc.exe" goto HasRoslyn
set ROSLYN_PATH=%ProgramFiles(x86)%\Microsoft Visual Studio\2022\Community\MSBuild\Current\Bin\Roslyn
if exist "%ROSLYN_PATH%\csc.exe" goto HasRoslyn
set ROSLYN_PATH=%ProgramFiles%\Microsoft Visual Studio\2019\Enterprise\MSBuild\Current\Bin\Roslyn
if exist "%ROSLYN_PATH%\csc.exe" goto HasRoslyn
set ROSLYN_PATH=%ProgramFiles(x86)%\Microsoft Visual Studio\2019\Enterprise\MSBuild\Current\Bin\Roslyn
if exist "%ROSLYN_PATH%\csc.exe" goto HasRoslyn
set ROSLYN_PATH=%ProgramFiles%\Microsoft Visual Studio\2019\Community\MSBuild\Current\Bin\Roslyn
if exist "%ROSLYN_PATH%\csc.exe" goto HasRoslyn
set ROSLYN_PATH=%ProgramFiles(x86)%\Microsoft Visual Studio\2019\Community\MSBuild\Current\Bin\Roslyn
if exist "%ROSLYN_PATH%\csc.exe" goto HasRoslyn
echo %ROSLYN_PATH%
set ROSLYN_PATH=%ROSLYN_PATH_ORG%
set ROSLYN_PATH_ORG=
echo Error: Roslyn compiler (csc.exe) not found
echo Error: Define ROSLYN_PATH env var to point to it
exit /b 2

:HasRoslyn

if exist "%PATH_7D2D_MANAGED%" goto HasManaged
echo Error: 7D2D Managed dll directory not found
echo Error: Define PATH_7D2D_MANAGED to point to it
exit /b 2

:HasManaged

echo Using %PATH_7D2D_MANAGED%

set NAME=%1
set SOURCES=%2
set PATCHERS=%3

call PC7D2D patchers\%NAME%PreloadPatch.dll %PATCHERS% && ^
echo Successfully compiled patchers\%NAME%Patch.dll && ^
call AP7D2D "%PATH_7D2D_MANAGED%" build\Assembly-CSharp.dll patchers\*.dll && ^
echo Successfully patched build\Assembly-CSharp.dll && ^
call MC7D2D %NAME%.dll /reference:build\Assembly-CSharp.dll %SOURCES% && ^
echo Successfully compiled %NAME%.dll

:end
