---
plan:
  status: active
  value: medium
  reviewed: 2026-10-25
  class: tooling
  targets:
    [
      pwsh/Catzc.Base.Slides/Build-Diagrams.ps1,
      pwsh/Catzc.Base.Slides/Test-Diagrams.ps1,
      python/catzc_diagrams/drawio_forward.py,
      python/catzc_diagrams/drawio_png.py,
      python/catzc_diagrams/minimaps.py,
      pwsh/Catzc.Base.Timeouts/configs/timeouts.yml,
    ]
---

# Diagram speed: optimize first, then go parallel

`Build-Diagrams -Stale` over 143 stale diagrams takes about 320 s (measured 2026-10-25, `out/profile-build-diagrams.ps1`): `Test-Diagrams`
91 s (it writes every minimap's data, then one batched python `check`), `Write-DiagramMinimapData` 35 s (the same data written a second
time), and 143 renders at about 1.3 s each, one `uv run python` process per diagram. One render's cProfile (`out/profile-diagram.sh`,
`bcl-language`) spends 1.25 s: PyYAML's pure-Python `safe_load` 0.34 s over 9 loads, the minimap registry loaded 4 times, `drop_shadow` 0.23
s over 27 Gaussian blurs, imports about 0.2 s, the git `conflict` check 0.27 s. Optimizing comes before parallelism, so the parallel step
divides the smaller remainder.

## Why its value is medium

Every diagram change waits on this run, and it has no time limit, so a stale-heavy run is unbounded; it breaks nothing today.

## Open steps

5. [ ] Bound it: `Build-Diagrams` gets its limit in `timeouts.yml`, set from the `-Stale` time measured after steps 1-4. Check: Test-Plans
       and the timeouts tests pass, and `out/profile-build-diagrams.ps1` records the new baseline.
6. [ ] Read the git `conflict` base once per batch, not three `git` calls per diagram (~0.12 s each): a long-lived `git cat-file --batch`
       must not serve a stale HEAD to a process that commits between reads, as the kit tests do. Check: the python kit tests pass and the
       pngs of two runs stay byte-equal.

## Decided

- The profiling-script note ("print timings with Write-Host, since an assignment captures the pipeline") lives on the engine's reference
  page, `docs/references/python/catzc_diagrams.md`, not in the `catzc-run` capability, which is at its 10-line roof (orchestrator,
  2026-10-26).
