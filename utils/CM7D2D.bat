@echo off

echo ***************************************
echo 7D2D (A20) Module Compiler v0.0.1
echo ***************************************

if not "%ROSLYN_PATH%" == "" goto HasRoslyn
	set ROSLYN_PATH=C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\MSBuild\Current\Bin\Roslyn
:hasRoslyn

if not "%ROSLYN_PATH%" == "" goto HasManaged
	echo Error: PATH_7D2D_MANAGED env variable is not defined
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
