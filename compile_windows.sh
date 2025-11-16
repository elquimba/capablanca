#!/bin/bash
# Script para compilar Capablanca para Windows

set -e

echo "=========================================="
echo " COMPILANDO CAPABLANCA PARA WINDOWS"
echo "=========================================="
echo ""

cd src

# Verificar si MinGW está instalado
if ! command -v x86_64-w64-mingw32-c++ > /dev/null 2>&1 && ! command -v x86_64-w64-mingw32-g++ > /dev/null 2>&1; then
    echo "MinGW-w64 no está instalado."
    echo "Instalando MinGW-w64..."
    sudo apt-get update -qq
    sudo apt-get install -y mingw-w64
    echo "MinGW-w64 instalado."
    echo ""
fi

# Verificar compilador
if command -v x86_64-w64-mingw32-c++ > /dev/null 2>&1; then
    COMPILER="x86_64-w64-mingw32-c++"
elif command -v x86_64-w64-mingw32-g++ > /dev/null 2>&1; then
    COMPILER="x86_64-w64-mingw32-g++"
else
    echo "ERROR: No se encontró el compilador MinGW"
    exit 1
fi

echo "Compilador encontrado: $COMPILER"
$COMPILER --version | head -1
echo ""

# Limpiar compilación anterior
echo "Limpiando compilación anterior..."
make clean > /dev/null 2>&1 || true

# Compilar
echo "Compilando Capablanca.exe..."
echo ""

make -j$(nproc) build ARCH=x86-64-avx2 COMP=mingw

echo ""
echo "=========================================="
if [ -f capablanca.exe ]; then
    echo " ✓ COMPILACIÓN EXITOSA"
    echo "=========================================="
    echo ""
    ls -lh capablanca.exe
    echo ""
    echo "Ejecutable creado: src/capablanca.exe"
    echo ""
    echo "Para probarlo:"
    echo "  ./capablanca.exe bench"
else
    echo " ✗ ERROR EN LA COMPILACIÓN"
    echo "=========================================="
    exit 1
fi

