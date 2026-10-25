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

3. [ ] Speed the render itself further (the registry read once per process with libyaml took `bcl-language` from 1.25 s to 0.95 s, pngs
       byte-equal): the remaining `yaml.safe_load` sites through one libyaml loader, `drop_shadow`'s 0.22 s (27 blurs; its painter is a
       per-shape closure, so a cache needs a safe key or a cheaper blur proven byte-equal), and the git `conflict` read once per batch.
       Check: the python kit tests pass, the pngs in `out/step3-baseline.sha` stay byte-equal, and the `bcl-language` cProfile drops below
       0.7 s.
4. [ ] Go parallel: the one batch splits into `render_parallel` worker processes, a slides.yml key with its default 3 declared once on
       `SlidesConfig`, each with a disjoint stem list, under the existing `Local\catzc-run` run lock; the first failure is raised after
       every worker ends, the progress lines print in stem order. Check: the Build-Diagrams tests pass with 1 and 3 workers, and both runs
       leave the same pngs.
5. [ ] Bound it: `Build-Diagrams` gets its limit in `timeouts.yml`, set from the `-Stale` time measured after steps 1-4. Check: Test-Plans
       and the timeouts tests pass, and `out/profile-build-diagrams.ps1` records the new baseline.
