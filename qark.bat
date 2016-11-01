@echo off
set DirApp=%1
set PathAPK=%2
set FileApk=%3
set Timestamp=%4
set Documentacion=%5
set Server=%6
set Username=%7
set Password=%8


set PathAPK=%PathAPK:"=%
set FileApk=%FileApk:"=%
set DirApp=%DirApp:"=%
set Documentacion=%Documentacion:"=%
set Documentacion="%Documentacion%\QarkReport - %FileApk%_%Timestamp%.tar.gz"

@title=[Qark] - %FileApk%

rem $git clone https://github.com/linkedin/qark
"%~dp0pscp.exe" -l %Username% -pw %Password% -C "%PathAPK%" %Server%:"/tmp/%FileApk%_%Timestamp%.apk"
"%~dp0pscp.exe" -l %Username% -pw %Password% -C "qark.sh" %Server%:"/tmp/qark.sh"
"%~dp0plink.exe" -P 22 -ssh -l %Username% -pw %Password% -C %Server% "tr -d '\15\32' < /tmp/qark.sh > %DirApp%/qark.sh"

rem echo Ejecutar en el server %Server% el comando:
rem echo cd "%DirApp%" ; chmod 755 ./qark.sh ; ./qark.sh "%DirApp%" "%FileApk%_%Timestamp%"
rem echo Solo cuando termine, presione una tecla para obtener el reporte

rem "%~dp0putty.exe" -C -ssh %Username%@%Server%

"%~dp0plink.exe" -P 22 -ssh -l %Username% -pw %Password% -C %Server% "export TERM=xterm ; cd '%DirApp%' ; chmod 755 ./qark.sh ; ./qark.sh '%DirApp%' '%FileApk%_%Timestamp%'"

"%~dp0plink.exe" -P 22 -ssh -l %Username% -pw %Password% -C %Server% "cd '%DirApp%' ; tar -cvzf '/tmp/QarkReport - %FileApk%_%Timestamp%.tar.gz' '/tmp/%FileApk%_%Timestamp%.apk' 'Report_%FileApk%_%Timestamp%/' logs/ exploit/"
"%~dp0pscp.exe" -P 22 -l %Username% -pw %Password% -C %Server%:"/tmp/QarkReport - %FileApk%_%Timestamp%.tar.gz" %Documentacion%
"%~dp0plink.exe" -P 22 -ssh -l %Username% -pw %Password% -C %Server% "rm -f '/tmp/QarkReport - %FileApk%_%Timestamp%.tar.gz'"

echo %Documentacion%
pause

