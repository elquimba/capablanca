# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is **Stockfish**, a free and strong UCI (Universal Chess Interface) chess engine derived from Glaurung 2.1. It's a command-line engine that analyzes chess positions and computes optimal moves. It does not include a GUI - users interact with it through UCI protocol via third-party chess GUIs.

Key characteristics:
- Written in C++17
- Uses NNUE (Efficiently Updatable Neural Networks) for position evaluation
- Supports multiple CPU architectures with SIMD optimizations
- Licensed under GPLv3

## Building and Development Commands

### Compilation

All compilation happens in the `src/` directory using the Makefile:

```bash
cd src
make -j profile-build ARCH=x86-64-avx2    # Fast compile for modern systems
make -j profile-build ARCH=x86-64-sse41-popcnt  # Portable 64-bit compile
make -j build ARCH=x86-64                 # Skip profile-guided optimization
make help                                 # Show all architecture options
```

**Profile-guided optimization (PGO) is the standard build process** and happens in 4 steps:
1. Build instrumented executable
2. Run benchmark to collect profiling data
3. Rebuild with profiling data for optimization
4. Clean up profiling artifacts

### Common Architectures
- `native` - Auto-detect best for current CPU (default)
- `x86-64-avx2` - Modern Intel/AMD CPUs
- `x86-64-avx512` - High-end server/desktop CPUs
- `x86-64-sse41-popcnt` - Portable modern 64-bit
- `armv8` - ARM 64-bit
- `apple-silicon` - Apple M1/M2/M3

### Compilers
- `gcc` (default)
- `clang`
- `mingw` (cross-compile for Windows)
- `icx` (Intel oneAPI)

### Code Formatting

Format code with clang-format version 20:
```bash
cd src
make format
```

The project uses a custom code style defined in `.clang-format`. All C++ changes must respect this style.

### Testing

Tests are located in the `tests/` directory:
- `perft.sh` - Position move generation verification
- `signature.sh` - Signature verification tests
- `reprosearch.sh` - Search reproducibility tests
- `instrumented.py` and `testing.py` - Python test utilities

### Other Useful Commands

```bash
cd src
make strip        # Strip debug symbols from executable
make clean        # Clean all build artifacts
make net          # Download default NNUE network file
```

## Architecture Overview

### Core Components

**UCI Interface (`uci.cpp/h`, `main.cpp`)**
- Entry point and UCI protocol handler
- `UCIEngine` class manages command loop and option parsing
- Handles commands: `uci`, `isready`, `position`, `go`, `setoption`, etc.

**Engine (`engine.cpp/h`)**
- `Engine` class orchestrates search and manages workers
- Provides high-level interface between UCI and search subsystem

**Search (`search.cpp/h`)**
- `Search::Worker` - Per-thread search worker (main search logic)
- `SearchManager` - Manages time control and search coordination (main thread only)
- Implements iterative deepening, alpha-beta pruning, aspiration windows
- Node types: `Root`, `PV` (Principal Variation), `NonPV`
- Two search functions: `search()` for main search, `qsearch()` for quiescence search

**Position (`position.cpp/h`)**
- `Position` class represents board state
- Bitboard-based representation for efficient move generation and attack detection
- Handles move execution (`do_move`/`undo_move`) and legal move validation
- Maintains game state including castling rights, en passant, 50-move rule

**Move Generation (`movegen.cpp/h`, `movepick.cpp/h`)**
- `movegen.cpp` - Generate all legal/pseudo-legal moves for a position
- `movepick.cpp` - Move ordering heuristics for search efficiency

**Evaluation (`evaluate.cpp/h`)**
- Position evaluation using NNUE neural networks
- Classical evaluation as fallback

**NNUE Neural Network (`nnue/` directory)**
- `nnue_architecture.h` - Defines network structure (layer sizes, activation functions)
- `network.cpp/h` - Network loading and inference
- `nnue_accumulator.cpp/h` - Efficient incremental feature updates
- `features/half_ka_v2_hm.h` - HalfKAv2_hm feature set (piece-square with king)
- `features/full_threats.h` - Threat-based features
- `layers/` - Neural network layer implementations (affine transforms, activations)
- Networks have two sizes: "Big" (1024 neurons) and "Small" (128 neurons)

**Thread Management (`thread.cpp/h`)**
- `ThreadPool` - Manages worker threads for parallel search
- Platform-specific threading via `thread_win32_osx.h` for Windows/macOS

**Transposition Table (`tt.cpp/h`)**
- Hash table for caching position evaluations
- Critical for search performance and avoiding redundant computation

**Time Management (`timeman.cpp/h`)**
- Controls search time allocation based on game clock

**History and Continuation Heuristics (`history.h`)**
- Move ordering tables: `ButterflyHistory`, `CapturePieceToHistory`, `ContinuationHistory`
- Used to improve move ordering based on previous search results

**Bitboards (`bitboard.cpp/h`)**
- Low-level bit manipulation and attack table generation
- Magic bitboards for sliding piece attacks

**Syzygy Tablebases (`syzygy/tbprobe.cpp/h`)**
- Endgame tablebase probing for perfect play in certain endgames

### Key Design Patterns

1. **Incremental Updates**: NNUE accumulator is updated incrementally during search rather than recomputed from scratch
2. **Copy-Make vs Make-Unmake**: Position uses make-unmake for efficiency; StateInfo chain preserves history
3. **Template-based Node Types**: Search function is templated on `NodeType` (Root/PV/NonPV) for optimal code generation
4. **Shared State Pattern**: `SharedState` struct passes common resources (options, threads, TT, networks) to workers

## Development Guidelines

### Testing Changes

**Functional changes** (affecting playing strength or search behavior):
- MUST be tested on [Fishtest](https://tests.stockfishchess.org/tests) before PR
- Include Fishtest link and new bench signature in PR description

**Non-functional changes** (refactoring, docs, code style):
- No Fishtest required unless performance impact is possible
- Still verify with `make build` and basic sanity checks

### Code Style

- Use clang-format version 20 (`make format`)
- Follow existing patterns for consistency
- C++17 standard
- No exceptions (`-fno-exceptions`)
- Platform-agnostic code preferred; use conditional compilation when necessary

### Git Configuration

To ignore formatting commits in git blame:
```bash
git config blame.ignoreRevsFile .git-blame-ignore-revs
```

### Contributing

- First-time contributors: Add name to `AUTHORS` file
- Focus on performance improvements, not new features
- Feature requests generally closed without discussion (per project policy)
- Bug reports welcome via GitHub issues
- Join [Discord](https://discord.gg/GWDRS3kU6R) for development discussion

## Important Notes

- **NNUE networks are embedded in binary distributions** but must be downloaded during development (`make net`)
- **Neural network data** is trained on [Leela Chess Zero data](https://storage.lczero.org/files/training_data) (ODbL license)
- **Profile-guided optimization significantly improves performance** - don't skip it for releases
- **Architecture selection matters** - wrong arch can halve performance
- The engine is a **UCI engine**, not a standalone game - it requires a GUI to be user-friendly
