@echo off

if "%ROSLYN_PATH%"== "" (
    echo Error: ROSLYN_PATH env variable is not defined
	exit /b 2
)

if "%PATH_7D2D_MANAGED%"== "" (
    echo Error: PATH_7D2D_MANAGED env variable is not defined
	exit /b 2
)

"%ROSLYN_PATH%\csc.exe" /target:library /out:%* /nologo ^
/noconfig /nowarn:1701,1702,2008 /fullpaths /nostdlib+ /errorreport:prompt /warn:4 /define:TRACE ^
/debug:pdbonly /filealign:512 /optimize+ /errorendlocation /preferreduilang:en-US /highentropyva+ ^
/reference:"%PATH_7D2D_MANAGED%\mscorlib.dll" ^
/reference:"%PATH_7D2D_MANAGED%\System.Core.dll" ^
/reference:"%PATH_7D2D_MANAGED%\Mono.Cecil.dll" ^
/subsystemversion:6.00 /utf8output /deterministic+ /langversion:7.3

:end
