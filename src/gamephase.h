/*
  Capablanca Enhanced - Game Phase Detection
  Copyright (C) 2025 Capablanca Chess Engine Team

  This file implements adaptive search based on game phase detection.
  Different phases (Opening, Middlegame, Endgame) use different search strategies.
*/

#ifndef GAMEPHASE_H_INCLUDED
#define GAMEPHASE_H_INCLUDED

#include "position.h"
#include "types.h"

namespace Stockfish {

// Detect the current game phase based on material and position characteristics
inline GamePhase detect_game_phase(const Position& pos) {

    // Calculate total material on board
    int totalMaterial = pos.non_pawn_material(WHITE) + pos.non_pawn_material(BLACK);

    // Count total pieces (excluding kings)
    int pieceCount = pos.count<ALL_PIECES>() - 2;

    // Get move count from position
    int moveCount = pos.game_ply();

    // ENDGAME detection (highest priority)
    // Few pieces or very low material
    if (pieceCount <= 8 || totalMaterial < 2600) {
        return ENDGAME;
    }

    // OPENING detection
    // Early moves with lots of material still on board
    if (moveCount < 14 && totalMaterial > 5200 && pieceCount >= 24) {
        return OPENING;
    }

    // Extended opening for slower development
    if (moveCount < 20 && totalMaterial > 6000 && pieceCount >= 26) {
        return OPENING;
    }

    // Default to MIDDLEGAME
    return MIDDLEGAME;
}

// Get phase-specific search parameters
struct PhaseParams {
    int nullMoveReductionBase;     // Base reduction for null move
    int futilityFactor;            // Futility pruning aggressiveness (1024 = 100%)
    int lmrExtraReduction;         // Extra LMR reduction for late moves
    int aspirationDeltaMult;       // Aspiration window multiplier (128 = 1.0x)
    int singularExtensionDepth;    // Minimum depth for singular extensions
    bool aggressivePruning;        // Use more aggressive pruning
};

inline PhaseParams get_phase_params(GamePhase phase) {
    switch (phase) {
        case OPENING:
            // Opening: Fast play, less deep search, aggressive pruning
            return {
                5,      // Null move: more aggressive (was 7)
                850,    // Futility: 17% less margin (play faster)
                2,      // LMR: reduce late moves more
                166,    // Aspiration: 30% wider windows (1.3x)
                10,     // Singular: only very deep
                true    // Aggressive pruning
            };

        case MIDDLEGAME:
            // Middlegame: Maximum depth, careful search, less pruning
            return {
                8,      // Null move: conservative
                1100,   // Futility: 7% more margin (more careful)
                0,      // LMR: no extra reduction
                102,    // Aspiration: 20% tighter windows (0.8x)
                7,      // Singular: enable earlier
                false   // Conservative pruning
            };

        case ENDGAME:
            // Endgame: Fast play with tablebase support
            return {
                6,      // Null move: moderate
                800,    // Futility: 22% less margin (fast)
                3,      // LMR: very aggressive
                192,    // Aspiration: 50% wider (1.5x)
                12,     // Singular: only very deep
                true    // Aggressive pruning
            };
    }

    // Default (should never reach here)
    return {7, 1024, 0, 128, 8, false};
}

// Get a descriptive name for the phase (for debugging/UCI output)
inline const char* phase_name(GamePhase phase) {
    switch (phase) {
        case OPENING:    return "Opening";
        case MIDDLEGAME: return "Middlegame";
        case ENDGAME:    return "Endgame";
        default:         return "Unknown";
    }
}

} // namespace Stockfish

#endif // #ifndef GAMEPHASE_H_INCLUDED
