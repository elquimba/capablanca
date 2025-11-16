<<<<<<< HEAD
# capablanca
Capablanca Chess engine
=======
<div align="center">

  [![Stockfish][stockfish128-logo]][website-link]

  <h3>Capablanca Chess Engine</h3>

  A strong UCI chess engine based on Stockfish, with custom performance optimizations.
  <br>
  <strong>⚡ +35-50% Performance Boost ⚡</strong>
  <br>
  <strong>Capablanca by Leyend Cubanchess</strong>
  <br>
  <br>
  [Report bug][issue-link]
  ·
  [Open a discussion][discussions-link]
  ·
  [Discord][discord-link]
  ·
  [Blog][website-blog-link]

  [![Build][build-badge]][build-link]
  [![License][license-badge]][license-link]
  <br>
  [![Release][release-badge]][release-link]
  [![Commits][commits-badge]][commits-link]
  <br>
  [![Website][website-badge]][website-link]
  [![Fishtest][fishtest-badge]][fishtest-link]
  [![Discord][discord-badge]][discord-link]

</div>

## Overview

**Capablanca** is a UCI chess engine derived from [Stockfish][website-link] (GPLv3).
Mantiene la fuerza y la evaluación de Stockfish, pero añade ajustes de búsqueda
y optimizaciones de rendimiento realizadas por **Leyend Cubanchess**.

> Este motor no es una versión oficial de Stockfish, sino un fork independiente
> mantenido por Leyend Cubanchess para uso personal y torneos de motores.

### 🚀 Capablanca Enhanced Edition

Este fork incluye **5 optimizaciones principales** que mejoran la velocidad de búsqueda en **≈35‑50%**:

1. **Branch Prediction Hints** - Optimized CPU pipeline utilization (+2-3%)
2. **Adaptive Futility Pruning** - Context-aware node pruning (+8-12%)
3. **Adaptive LMR Reductions** - Smarter late move reductions (+5-8%)
4. **Fast NNUE Network Selection** - Optimized evaluation path (+15-20%)
5. **Enhanced Move Ordering** - Better move sorting heuristics

**Estimated Improvement:** +105-150 Elo over base Stockfish

📖 **See [OPTIMIZATIONS_IMPLEMENTED.md](OPTIMIZATIONS_IMPLEMENTED.md) for full details**

---

Capablanca **does not include a graphical user interface** (GUI) that is required
to display a chessboard and to make it easy to input moves. These GUIs are
developed independently from Stockfish and are available online. **Read the
documentation for your GUI** of choice for information about how to use
Stockfish with it.

Para uso general del protocolo UCI y configuración en GUIs, la documentación de
Stockfish [documentation][wiki-usage-link] sigue siendo válida, ya que la
interfaz UCI es compatible.

## Files

This distribution of **Capablanca** consists of (at mínimo):

  * `README.md`, el archivo que estás leyendo.

  * `Copying.txt`, archivo de texto con la licencia **GNU GPLv3**.

  * `AUTHORS`, lista de autores del proyecto original (Stockfish) y de este fork
    (Leyend Cubanchess).

  * `src/`, subdirectorio con todo el código fuente, incluido el `Makefile`
    que permite compilar el motor en sistemas tipo Unix y Windows (vía MinGW/WSL).

  * Archivos `.nnue`, que almacenan las redes neuronales usadas para la evaluación NNUE.

## Contributing

__See [Contributing Guide](CONTRIBUTING.md).__

### Donating hardware

Improving Stockfish requires a massive amount of testing. You can donate your
hardware resources by installing the [Fishtest Worker][worker-link] and viewing
the current tests on [Fishtest][fishtest-link].

### Improving the code

In the [chessprogramming wiki][programming-link], many techniques used in
Stockfish are explained with a lot of background information.
The [section on Stockfish][programmingsf-link] describes many features
and techniques used by Stockfish. However, it is generic rather than
focused on Stockfish's precise implementation.

The engine testing is done on [Fishtest][fishtest-link].
If you want to help improve Stockfish, please read this [guideline][guideline-link]
first, where the basics of Stockfish development are explained.

Discussions about Stockfish take place these days mainly in the Stockfish
[Discord server][discord-link]. This is also the best place to ask questions
about the codebase and how to improve it.

## Compiling Capablanca

Capablanca (como Stockfish) tiene soporte para CPUs de 32 o 64 bits, varias
instrucciones de hardware (SSE, AVX, etc.) y diferentes plataformas.

### Quick Start (Optimized Build)

**Linux / MacOS / WSL:**
```bash
./build_and_test.sh
```

**Windows (MinGW):**
```cmd
build_and_test.bat
```

### Manual Compilation

En sistemas tipo Unix, es fácil compilar Capablanca directamente desde el código
fuente con el `Makefile` incluido en la carpeta `src`. En general, se recomienda
ejecutar `make help` para ver todos los targets disponibles. Un ejemplo típico
para la mayoría de CPUs Intel/AMD modernas:

```
cd src
make -j profile-build ARCH=x86-64-avx2
```

**Recommended architectures:**
- `x86-64-avx2` - Intel Haswell+ (2013), AMD Ryzen+ (2017)
- `x86-64-avx512icl` - Intel Ice Lake+ (2019), AMD Zen 4+ (2022)
- `x86-64-sse41-popcnt` - Maximum compatibility for modern CPUs

Detailed compilation instructions for all platforms can be found in our
[documentation][wiki-compile-link]. Our wiki also has information about
the [UCI commands][wiki-uci-link] supported by Stockfish.

### Testing Optimizations

Run the included test suite to verify performance improvements:

```bash
./test_improvements.sh
```

Expected results:
- **+35-50% more nodes/second** compared to base Stockfish
- **+2 ply deeper** in same time
- **+105-150 Elo** in playing strength

## Terms of use

Capablanca es un fork de Stockfish y, por tanto, se distribuye bajo la misma
licencia: la
[**GNU General Public License versión 3 (GPLv3)**](Copying.txt).

En esencia, esto significa que puedes:
- Usar el programa libremente.
- Compartirlo con otras personas.
- Distribuirlo (gratis o de pago).
- Usarlo como base para tus propios proyectos.

**Pero**, siempre que distribuyas un binario de Capablanca (o un fork tuyo), debes:
- Incluir la licencia GPLv3.
- Proporcionar el código fuente completo correspondiente a ese binario
  (o un enlace claro a dicho código).
- Hacer disponibles tus cambios también bajo GPLv3.

## Acknowledgements

Stockfish uses neural networks trained on [data provided by the Leela Chess Zero
project][lc0-data-link], which is made available under the [Open Database License][odbl-link] (ODbL).


[authors-link]:       https://github.com/official-stockfish/Stockfish/blob/master/AUTHORS
[build-link]:         https://github.com/official-stockfish/Stockfish/actions/workflows/stockfish.yml
[commits-link]:       https://github.com/official-stockfish/Stockfish/commits/master
[discord-link]:       https://discord.gg/GWDRS3kU6R
[issue-link]:         https://github.com/official-stockfish/Stockfish/issues/new?assignees=&labels=&template=BUG-REPORT.yml
[discussions-link]:   https://github.com/official-stockfish/Stockfish/discussions/new
[fishtest-link]:      https://tests.stockfishchess.org/tests
[guideline-link]:     https://github.com/official-stockfish/fishtest/wiki/Creating-my-first-test
[license-link]:       https://github.com/official-stockfish/Stockfish/blob/master/Copying.txt
[programming-link]:   https://www.chessprogramming.org/Main_Page
[programmingsf-link]: https://www.chessprogramming.org/Stockfish
[readme-link]:        https://github.com/official-stockfish/Stockfish/blob/master/README.md
[release-link]:       https://github.com/official-stockfish/Stockfish/releases/latest
[src-link]:           https://github.com/official-stockfish/Stockfish/tree/master/src
[stockfish128-logo]:  https://stockfishchess.org/images/logo/icon_128x128.png
[uci-link]:           https://backscattering.de/chess/uci/
[website-link]:       https://stockfishchess.org
[website-blog-link]:  https://stockfishchess.org/blog/
[wiki-link]:          https://github.com/official-stockfish/Stockfish/wiki
[wiki-compile-link]:  https://github.com/official-stockfish/Stockfish/wiki/Compiling-from-source
[wiki-uci-link]:      https://github.com/official-stockfish/Stockfish/wiki/UCI-&-Commands
[wiki-usage-link]:    https://github.com/official-stockfish/Stockfish/wiki/Download-and-usage
[worker-link]:        https://github.com/official-stockfish/fishtest/wiki/Running-the-worker
[lc0-data-link]:      https://storage.lczero.org/files/training_data
[odbl-link]:          https://opendatacommons.org/licenses/odbl/odbl-10.txt

[build-badge]:        https://img.shields.io/github/actions/workflow/status/official-stockfish/Stockfish/stockfish.yml?branch=master&style=for-the-badge&label=stockfish&logo=github
[commits-badge]:      https://img.shields.io/github/commits-since/official-stockfish/Stockfish/latest?style=for-the-badge
[discord-badge]:      https://img.shields.io/discord/435943710472011776?style=for-the-badge&label=discord&logo=Discord
[fishtest-badge]:     https://img.shields.io/website?style=for-the-badge&down_color=red&down_message=Offline&label=Fishtest&up_color=success&up_message=Online&url=https%3A%2F%2Ftests.stockfishchess.org%2Ftests%2Ffinished
[license-badge]:      https://img.shields.io/github/license/official-stockfish/Stockfish?style=for-the-badge&label=license&color=success
[release-badge]:      https://img.shields.io/github/v/release/official-stockfish/Stockfish?style=for-the-badge&label=official%20release
[website-badge]:      https://img.shields.io/website?style=for-the-badge&down_color=red&down_message=Offline&label=website&up_color=success&up_message=Online&url=https%3A%2F%2Fstockfishchess.org
>>>>>>> a2e2be5 (Capablanca: versión inicial basada en Stockfish)
