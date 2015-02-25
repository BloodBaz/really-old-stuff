@echo off

rem :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
rem :: Do not edit anything below here unless you know what    ::
rem :: you're doing!                                           ::
rem :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

rem Cleanup to avoid confusion
if exist object.o del object.o

rem Compile
wla-z80.exe -o game.asm object.o

rem Make linkfile
echo [objects]>linkfile
echo object.o>>linkfile

rem Link
wlalink.exe -drvs linkfile output.sms

rem Fixup for eSMS
if exist output.sms.sym del output.sms.sym
ren output.sym output.sms.sym

rem Cleanup to avoid mess
if exist linkfile del linkfile
if exist object.o del object.o
