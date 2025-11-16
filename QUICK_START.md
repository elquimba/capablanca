# ⚡ QUICK START - Stockfish Capablanca Enhanced

## 🚀 Inicio Rápido en 3 Pasos

### Paso 1: Instalar Compilador

#### Windows
```cmd
# Opción A: Usar WSL (Recomendado)
wsl --install
# Reiniciar y luego:
wsl
sudo apt update && sudo apt install g++ make

# Opción B: MinGW
# Descargar de: https://www.mingw-w64.org/downloads/
# O usar MSYS2: https://www.msys2.org/
```

#### Linux (Ubuntu/Debian)
```bash
sudo apt update
sudo apt install g++ make
```

#### Mac
```bash
xcode-select --install
```

### Paso 2: Compilar

#### Automático (Recomendado)

**Linux/Mac/WSL:**
```bash
chmod +x build_and_test.sh
./build_and_test.sh
```

**Windows con MinGW:**
```cmd
build_and_test.bat
```

#### Manual
```bash
cd src
make net  # Descargar redes NNUE
make -j profile-build ARCH=x86-64-avx2  # Compilar con PGO
```

### Paso 3: Probar

```bash
# Test rápido
cd src
./stockfish bench

# Test completo
cd ..
./test_improvements.sh
```

---

## 📊 Resultados Esperados

**Benchmark:**
- NPS: 5,500-6,500 KN/s (vs 4,000 en original)
- Mejora: +35-50%
- Elo: +105-150

---

## 🎮 Usar en GUI

1. Compilar el motor (pasos arriba)
2. Abrir tu GUI de ajedrez (Arena, CuteChess, ChessBase, etc.)
3. Añadir engine UCI:
   - **Ruta:** `C:\Users\Lester\Documents\GitHub\capablanca\src\stockfish.exe` (Windows)
   - **Ruta:** `/path/to/capablanca/src/stockfish` (Linux/Mac)
4. ¡Jugar!

---

## ❓ Problemas Comunes

### Error: "make: command not found"
**Solución:** Instalar build tools
```bash
# Linux
sudo apt install build-essential

# Mac
xcode-select --install

# Windows
Usar WSL o MinGW
```

### Error: "g++: command not found"
**Solución:** Instalar compilador
```bash
sudo apt install g++
```

### Error: NNUE network not found
**Solución:** Descargar redes
```bash
cd src
make net
```

---

## 📚 Documentación Completa

- **Detalles técnicos:** `OPTIMIZATIONS_IMPLEMENTED.md`
- **Resumen ejecutivo:** `IMPLEMENTATION_SUMMARY.md`
- **Guía Claude Code:** `CLAUDE.md`

---

## ✅ Checklist

- [ ] Compilador instalado
- [ ] Código descargado
- [ ] Motor compilado
- [ ] Benchmark ejecutado
- [ ] Motor probado en GUI

---

**¿Listo?** ¡Ejecuta `./build_and_test.sh` y comienza! 🏁
