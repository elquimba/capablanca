/*
  Capablanca Enhanced - NNUE Evaluation Cache
  Copyright (C) 2025 Capablanca Chess Engine Team

  This file implements a fast cache for NNUE evaluations to avoid
  redundant neural network calculations.
*/

#ifndef EVALCACHE_H_INCLUDED
#define EVALCACHE_H_INCLUDED

#include <cstdint>
#include "types.h"

namespace Stockfish {

// Fast evaluation cache to avoid redundant NNUE calculations
// Uses simple direct-mapped cache with position key as index
class EvalCache {
   public:
    // Cache entry stores position key and evaluation
    struct Entry {
        Key   key;
        Value eval;

        Entry() : key(0), eval(VALUE_NONE) {}
    };

    static constexpr int SIZE = 16384;  // Must be power of 2
    static constexpr int MASK = SIZE - 1;

    EvalCache() { clear(); }

    // Probe the cache for a position
    // Returns true if found, and sets 'value' to cached evaluation
    bool probe(Key posKey, Value& value) const {
        const Entry& e = table[index(posKey)];
        if (e.key == posKey) {
            value = e.eval;
            hits++;
            return true;
        }
        misses++;
        return false;
    }

    // Store evaluation in cache
    void store(Key posKey, Value value) {
        Entry& e = table[index(posKey)];
        e.key = posKey;
        e.eval = value;
        stores++;
    }

    // Clear the entire cache
    void clear() {
        for (int i = 0; i < SIZE; ++i) {
            table[i].key = 0;
            table[i].eval = VALUE_NONE;
        }
        hits = misses = stores = 0;
    }

    // Get cache statistics (for tuning/debugging)
    struct Stats {
        uint64_t hits;
        uint64_t misses;
        uint64_t stores;
        double hitRate() const {
            uint64_t total = hits + misses;
            return total > 0 ? (100.0 * hits) / total : 0.0;
        }
    };

    Stats get_stats() const {
        return {hits, misses, stores};
    }

   private:
    Entry table[SIZE];
    mutable uint64_t hits = 0;
    mutable uint64_t misses = 0;
    mutable uint64_t stores = 0;

    // Hash function: extract lower bits of key
    static int index(Key k) { return static_cast<int>(k & MASK); }
};

} // namespace Stockfish

#endif // #ifndef EVALCACHE_H_INCLUDED
