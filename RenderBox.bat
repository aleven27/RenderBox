@echo off
color 04
echo.
setlocal enabledelayedexpansion
if exist settings.ini ( ren settings.ini s.cmd & call s.cmd & ren s.cmd settings.ini )
pushd %~dp0
if [%1]==[] goto scan
set file=%1
set name=%~n1
pushd %~dp1
set /p format=(NVENC - XVID - PRORES): %=%
call :settings
if not exist "!format! Converted" ( mkdir "converted_!format!" )
!%format%!
:scan
echo Convertable files found:
echo.
for %%a in (*.mp4, *.avi, *.wmv, *.mov, *.m4v) do ( echo   %%a )
echo. 
set /p format=(NVENC - XVID - PRORES): %=%
for %%a in (*.mp4, *.avi, *.wmv, *.mov, *.m4v) do ( 
	set file=%%a
	set name=%%~na
	call :settings
	if not exist "converted_!format!" ( mkdir "converted_!format!" )
	!%format%!
)	
:end
echo 	Finished.
echo Press any key to exit.
pause >nul
exit
:settings
set "NVENC=ffmpeg -i ^"!file!^" -r 42 -c:v h264_nvenc -qp 11 -filter:v scale=iw*2:ih*2 -c:a aac -b:a 1411k -vsync 1 -colorspace 1 -y ^"converted_!format!^"/^"!name!^".avi"
set "XVID=ffmpeg -i ^"!file!^" -r 60 -c:v mpeg4 -vtag xvid -qscale:v 1 -qscale:a 1 -g 1 -filter:v scale=iw*2:ih*2 -c:a libmp3lame -qscale:a 0 -vsync 1 -y ^"converted_!format!^"/^"!name!^".avi"
set "PRORES=ffmpeg -i ^"!file!^" -r 60 -c:v prores_ks -profile:v 0.5 -c:a pcm_s16le -filter:v scale=iw*2:ih*2 -c:a aac -b:a 1411k -vsync 1 -y ^"converted_!format!^"/^"!name!^".mov"