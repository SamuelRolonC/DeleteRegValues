@echo off

copy logs%DATE:/=-%_%TIME::=-%.log

cls

:: Leer txt y guardar en array

setlocal enabledelayedexpansion
set n=0
for /F "tokens=*" %%A in (value_list.txt) do (
    set /A n+=1
    set lines[!n!]=%%A
)

echo Cantidad de lineas: !n!

:: Usar array

for /L %%s in (1,1,%n%) do (    
    set /a dummy=%%s %% 2

    :: Determinar si se esta leyendo una ruta o un nombre de llave
    if !dummy! NEQ 0  (
        set p=!lines[%%s]!
    ) else (
        echo ---------- Procesando key ----------
        echo ---------- Procesando key ---------- >> logs.log
    
        set k=!lines[%%s]!        
        set bkfolder=%~dp0backups\
        set bkfile=!k!%DATE:/=-%_%TIME::=-%.reg
        
        echo backup folder !bkfolder!
        echo backup file !bkfile!
        echo key path !p!
        echo key !k!

        echo backup folder !bkfolder! >> logs.log
        echo backup file !bkfile! >> logs.log
        echo key path !p! >> logs.log
        echo key !k! >> logs.log

        reg query "!p!" /v "!k!"

        if !ERRORLEVEL! EQU 0 (
            if not exist "!bkfolder!" mkdir "!bkfolder!"

            reg export "!p!" "!bkfile!"
            echo Registry key backup ready.
            echo Registry key backup ready.  >> logs.log

            reg delete  "!p!" /v "!k!" /f
            echo Registry key delete ready.
            echo Registry key delete ready. >> logs.log
        ) else (
            echo Registry key not exists.
            echo Registry key not exists. >> logs.log
        )        
    )
)

pause