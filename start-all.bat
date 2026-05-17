@echo off
REM start-all.bat - Arranca MySQL (XAMPP/instalado), backend y frontend en ventanas separadas

SETLOCAL ENABLEDELAYEDEXPANSION
SET SCRIPTDIR=%~dp0

echo --------------------------------------------------
echo Iniciando servicios para RubenGym (FitZone)
echo --------------------------------------------------

:: 1) Intentar arrancar MySQL (XAMPP) si está instalado
echo 1) Arrancando MySQL (XAMPP si está disponible)...
if exist "C:\xampp\mysql_start.bat" (
    start "MySQL (XAMPP)" cmd /k "cd /d C:\xampp && mysql_start.bat"
) else if exist "C:\xampp\mysql\bin\mysqld.exe" (
    start "MySQL (XAMPP)" cmd /k "cd /d C:\xampp\mysql\bin && mysqld.exe --console"
) else (
    echo No se encontró XAMPP en C:\xampp. Intentando iniciar servicio MySQL estándar...
    sc query MySQL >nul 2>&1
    if %errorlevel%==0 (
        echo Intentando iniciar servicio MySQL...
        net start MySQL
    ) else (
        echo No se pudo iniciar MySQL automáticamente. Inicia MySQL manualmente si es necesario.
    )
)

timeout /t 3 /nobreak >nul

:: 2) Backend (Spring Boot)
echo 2) Arrancando backend (fitzone-backend)...
if exist "%SCRIPTDIR%fitzone-backend\mvnw.cmd" (
    start "Backend" cmd /k "cd /d "%SCRIPTDIR%fitzone-backend" && .\mvnw.cmd spring-boot:run"
) else (
    start "Backend" cmd /k "cd /d "%SCRIPTDIR%fitzone-backend" && mvn spring-boot:run"
)

:: 3) Frontend (Angular)
echo 3) Arrancando frontend (FitZone)...
if exist "%SCRIPTDIR%FitZone\node_modules" (
    start "Frontend" cmd /k "cd /d "%SCRIPTDIR%FitZone" && npm start"
) else (
    start "Frontend" cmd /k "cd /d "%SCRIPTDIR%FitZone" && npm install && npm start"
)

echo Todas las ventanas de servicio se han abierto. Revisa las ventanas llamadas "MySQL (XAMPP)", "Backend" y "Frontend".
exit /b 0
