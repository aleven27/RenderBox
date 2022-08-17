@echo off
chcp 65001 >nul
title RenderBox
color 04
echo.
echo   █████╗ ██╗     ███████╗██╗   ██╗███████╗███╗   ██╗██████╗ ███████╗
echo  ██╔══██╗██║     ██╔════╝██║   ██║██╔════╝████╗  ██║╚════██╗╚════██║
echo  ███████║██║     █████╗  ██║   ██║█████╗  ██╔██╗ ██║ █████╔╝    ██╔╝
echo  ██╔══██║██║     ██╔══╝  ╚██╗ ██╔╝██╔══╝  ██║╚██╗██║██╔═══╝    ██╔╝ 
echo  ██║  ██║███████╗███████╗ ╚████╔╝ ███████╗██║ ╚████║███████╗   ██║  
echo  ╚═╝  ╚═╝╚══════╝╚══════╝  ╚═══╝  ╚══════╝╚═╝  ╚═══╝╚══════╝   ╚═╝   
echo.
setlocal enabledelayedexpansion
if exist settings.ini ( ren settings.ini s.cmd & call s.cmd & ren s.cmd settings.ini )
pushd %~dp0
if [%1]==[] goto scan
set file=%1
set name=%~n1
pushd %~dp1
set /p format=Enter Encoder - [NVENC] [HEVC] [XVID] [PRORES]: %=%
call :settings
if not exist "!format! Converted" ( mkdir "converted_!format!" )
!%format%!
:scan
echo Convertable files found:
echo.
for %%a in (*.mp4, *.avi, *.wmv, *.mov, *.m4v) do ( echo   %%a )
echo. 
set /p format=Enter Format - [NVENC] [HEVC] [XVID] [PRORES]: %=%
set /p fps=Enter FPS - [0 ~ 60]: %=%
set /p quality=Enter Quality - (NVENC [0 ~ 51]) (HEVC [0 ~ 51]) (XVID [1 ~ 31]) (PRORES [0 ~ 5]): %=%
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
set "NVENC=ffmpeg -i ^"!file!^" -r !fps! -c:v h264_nvenc -preset p7 -tune 1 -profile:v high444p -level 6.2 -rc constqp -zerolatency 0 -qp !quality! -colorspace 1 -filter:v scale=iw*2:ih*2:-1:flags=lanczos,unsharp=lx=7:ly=7 -c:a aac -b:a 576k -vsync 1 -y ^"converted_!format!^"/^"!name!^".mp4"
set "HEVC=ffmpeg -i ^"!file!^" -r !fps! -c:v hevc_nvenc -preset p7 -tune 1 -profile:v 1 -level 6.2 -tier 1 -rc constqp -zerolatency 0 -qp !quality! -colorspace 1 -filter:v scale=iw*2:ih*2:-1:flags=lanczos,unsharp=lx=7:ly=7 -c:a aac -b:a 576k -vsync 1 -y ^"converted_!format!^"/^"!name!^".mp4"
set "XVID=ffmpeg -i ^"!file!^" -r !fps! -c:v mpeg4 -vtag xvid -qscale:v !quality! -qscale:a 1 -g 1 -filter:v scale=iw*2:ih*2:-1:flags=lanczos,unsharp=lx=7:ly=7 -c:a copy -colorspace 1 -vsync 1 -y ^"converted_!format!^"/^"!name!^".avi"
set "PRORES=ffmpeg -i ^"!file!^" -r !fps! -c:v prores_ks -profile:v !quality! -filter:v scale=iw*2:ih*2:-1:flags=lanczos,unsharp=lx=7:ly=7 -c:a copy -colorspace 1 -vsync 1 -y ^"converted_!format!^"/^"!name!^".mov"