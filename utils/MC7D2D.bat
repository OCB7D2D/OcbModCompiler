@echo off

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

REM /debug:pdbonly|portable (will result in non-deterministic build)
REM "%ROSLYN_PATH%\csc.exe" /langversion:?

"%ROSLYN_PATH%\csc.exe" /out:%* /target:library /nologo /langversion:latest ^
/noconfig /nowarn:1701,1702,2008 /fullpaths /nostdlib+ /errorreport:prompt /warn:4 /define:TRACE ^
/filealign:512 /optimize+ /errorendlocation /preferreduilang:en-US /highentropyva+ ^
/reference:"%PATH_7D2D_MANAGED%\netstandard.dll" ^
/reference:"%PATH_7D2D_MANAGED%\0Harmony.dll" ^
/reference:"%PATH_7D2D_MANAGED%\mscorlib.dll" ^
/reference:"%PATH_7D2D_MANAGED%\System.Core.dll" ^
/reference:"%PATH_7D2D_MANAGED%\System.dll" ^
/reference:"%PATH_7D2D_MANAGED%\System.Xml.dll" ^
/reference:"%PATH_7D2D_MANAGED%\System.Xml.Linq.dll" ^
/reference:"%PATH_7D2D_MANAGED%\Mono.Cecil.dll" ^
/reference:"%PATH_7D2D_MANAGED%\Assembly-CSharp-firstpass.dll" ^
/reference:"%PATH_7D2D_MANAGED%\LogLibrary.dll" ^
/reference:"%PATH_7D2D_MANAGED%\InControl.dll" ^
/reference:"%PATH_7D2D_MANAGED%\UnityEngine.dll" ^
/reference:"%PATH_7D2D_MANAGED%\UnityEngine.UI.dll" ^
/reference:"%PATH_7D2D_MANAGED%\UnityEngine.CoreModule.dll" ^
/reference:"%PATH_7D2D_MANAGED%\UnityEngine.InputModule.dll" ^
/reference:"%PATH_7D2D_MANAGED%\UnityEngine.AudioModule.dll" ^
/reference:"%PATH_7D2D_MANAGED%\UnityEngine.VideoModule.dll" ^
/reference:"%PATH_7D2D_MANAGED%\UnityEngine.PhysicsModule.dll" ^
/reference:"%PATH_7D2D_MANAGED%\UnityEngine.AnimationModule.dll" ^
/reference:"%PATH_7D2D_MANAGED%\UnityEngine.InputLegacyModule.dll" ^
/reference:"%PATH_7D2D_MANAGED%\UnityEngine.UnityWebRequestModule.dll" ^
/reference:"%PATH_7D2D_MANAGED%\UnityEngine.UnityWebRequestWWWModule.dll" ^
/reference:"%PATH_7D2D_MANAGED%\UnityEngine.UnityWebRequestAudioModule.dll" ^
/reference:"%PATH_7D2D_MANAGED%\UnityEngine.UnityWebRequestTextureModule.dll" ^
/reference:"%PATH_7D2D_MANAGED%\UnityEngine.AssetBundleModule.dll" ^
/reference:"%PATH_7D2D_MANAGED%\UnityEngine.ImageConversionModule.dll" ^
/reference:"%PATH_7D2D_MANAGED%\UnityEngine.ParticleSystemModule.dll" ^
/reference:"%PATH_7D2D_MANAGED%\UnityEngine.TerrainModule.dll" ^
/reference:"%PATH_7D2D_MANAGED%\UnityEngine.WindModule.dll" ^
/reference:"%PATH_7D2D_MANAGED%\UnityEngine.IMGUIModule.dll" ^
/reference:"%PATH_7D2D_MANAGED%\AstarPathfindingProject.dll" ^
/reference:"%PATH_7D2D_MANAGED%\Unity.Postprocessing.Runtime.dll" ^
/reference:"%PATH_7D2D_MANAGED%\Unity.ResourceManager.dll" ^
/reference:"%PATH_7D2D_MANAGED%\Unity.Addressables.dll" ^
/reference:Microsoft.CSharp.dll ^
/subsystemversion:6.00 /utf8output /deterministic+ /langversion:10.0

:end
