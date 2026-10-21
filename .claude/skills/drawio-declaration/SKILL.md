---
name: drawio-declaration
description:
  Put, get, sync, theme and stale-rebuild a diagram folder from its diagram.drawio.yml; for edit-diagram-yml, drawio-diagram-waves and
  print-artifacts; input is the diagram folder's repository path and the direction or switch to run.
user-invocable: false
allowed-tools: Bash, Read
paths: docs/**/.assets/**/diagram.drawio.yml, docs/**/.assets/**/diagram.drawio.png, out/drawio/**
metadata:
  catzc:
    config:
      model_floor: haiku
      needs: [uv, pillow, pwsh]
---

# drawio-declaration

1. The yml is the one source; put renders it into the png, get folds a draw.io edit back (ADR-REPO-SLIDES-TWODIRECTIONS), by folder, in the
   background: `timeout 360 uv run -q --project <repo>/python python <repo>/python/catzc_diagrams/declaration.py put|get <folder>`.
2. `Build-Diagrams -Path <folder> -FromDrawing` runs get, put and Test-Diagrams in one call; `-Stale` rebuilds stale minimaps;
   `-Theme <name>` renders to `out/drawio/themes/<name>/`. A pair whose yml and png both moved since HEAD is a conflict: only put or get by
   name, the author's pick, clears it (ADR-REPO-SLIDES-CONFLICTNEEDSAPICK); never merge or pick. Forward every validation error verbatim.
