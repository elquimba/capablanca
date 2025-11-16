@echo off
REM ============================================================================
REM Script de Compilación y Testing para Stockfish Optimizado
REM ============================================================================

echo.
echo ========================================
echo  STOCKFISH OPTIMIZED - BUILD SCRIPT
echo  Capablanca Enhanced Edition
echo ========================================
echo.

REM Verificar si MinGW está instalado
where mingw32-make >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: MinGW no esta instalado.
    echo.
    echo Por favor instala MinGW-w64 desde:
    echo https://www.mingw-w64.org/downloads/
    echo.
    echo O usa WSL (Windows Subsystem for Linux^) para compilar:
    echo   wsl --install
    echo   wsl
    echo   cd /mnt/c/Users/Lester/Documents/GitHub/capablanca/src
    echo   make -j profile-build ARCH=x86-64-avx2
    echo.
    pause
    exit /b 1
)

REM Verificar si g++ está instalado
where g++ >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: g++ no esta instalado.
    echo Por favor agrega MinGW al PATH de Windows.
    pause
    exit /b 1
)

echo Compilador encontrado:
g++ --version | findstr "g++"
echo.

REM Detectar arquitectura del CPU
echo Detectando CPU...
wmic cpu get name | findstr "Intel\|AMD"
echo.

REM Menu de selección de arquitectura
echo Selecciona la arquitectura de CPU:
echo.
echo 1. x86-64-avx2       (Intel Haswell+ 2013, AMD Ryzen+ 2017^)
echo 2. x86-64-avx512icl  (Intel Ice Lake+ 2019, AMD Zen 4+ 2022^)
echo 3. x86-64-sse41-popcnt (Maxima compatibilidad^)
echo 4. native            (Auto-detectar^)
echo.
set /p ARCH_CHOICE="Elige opcion (1-4^): "

if "%ARCH_CHOICE%"=="1" set BUILD_ARCH=x86-64-avx2
if "%ARCH_CHOICE%"=="2" set BUILD_ARCH=x86-64-avx512icl
if "%ARCH_CHOICE%"=="3" set BUILD_ARCH=x86-64-sse41-popcnt
if "%ARCH_CHOICE%"=="4" set BUILD_ARCH=native

if "%BUILD_ARCH%"=="" (
    echo Opcion invalida. Usando x86-64-avx2 por defecto.
    set BUILD_ARCH=x86-64-avx2
)

echo.
echo Compilando con arquitectura: %BUILD_ARCH%
echo.

cd src

REM Descargar redes NNUE si no existen
if not exist "*.nnue" (
    echo Descargando redes neuronales NNUE...
    mingw32-make net
    echo.
)

REM Limpiar compilacion anterior
echo Limpiando compilacion anterior...
mingw32-make clean
echo.

REM Compilar sin PGO primero (más rápido para testing^)
echo ========================================
echo  FASE 1: Compilacion Rapida (sin PGO^)
echo ========================================
echo.
mingw32-make -j build ARCH=%BUILD_ARCH% COMP=mingw

if %errorlevel% neq 0 (
    echo.
    echo ERROR: Compilacion fallida.
    pause
    exit /b 1
)

echo.
echo ========================================
echo  COMPILACION EXITOSA
echo ========================================
echo.

REM Ejecutar benchmark
echo Ejecutando benchmark inicial...
echo.
stockfish.exe bench > benchmark_results.txt 2>&1

REM Mostrar resultados
echo.
echo ========================================
echo  RESULTADOS DEL BENCHMARK
echo ========================================
echo.
type benchmark_results.txt | findstr "Nodes/second"
type benchmark_results.txt | findstr "Nodes searched"
echo.

REM Preguntar si hacer PGO build
echo.
set /p DO_PGO="Deseas hacer compilacion PGO optimizada? (toma ~10 minutos^) (S/N^): "

if /i "%DO_PGO%"=="S" (
    echo.
    echo ========================================
    echo  FASE 2: Compilacion con PGO
    echo ========================================
    echo.
    mingw32-make clean
    mingw32-make -j profile-build ARCH=%BUILD_ARCH% COMP=mingw

    echo.
    echo Ejecutando benchmark OPTIMIZADO...
    echo.
    stockfish.exe bench > benchmark_pgo_results.txt 2>&1

    echo.
    echo ========================================
    echo  RESULTADOS PGO
    echo ========================================
    echo.
    type benchmark_pgo_results.txt | findstr "Nodes/second"
    type benchmark_pgo_results.txt | findstr "Nodes searched"
    echo.
)

cd ..

echo.
echo ========================================
echo  PROCESO COMPLETADO
echo ========================================
echo.
echo El ejecutable esta en: src\stockfish.exe
echo.
echo Para probar el motor:
echo   cd src
echo   stockfish.exe
echo.
echo Para ver las optimizaciones implementadas:
echo   type OPTIMIZATIONS_IMPLEMENTED.md
echo.
pause
