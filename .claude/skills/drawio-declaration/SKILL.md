---
name: drawio-declaration
description:
  Put, get, sync, theme and stale-rebuild a diagram from its <name>.drawio.yml; for edit-diagram-yml, drawio-diagram-waves and
  print-artifacts; input is the diagram's repository path (its .drawio.yml) and the direction or switch to run.
user-invocable: false
allowed-tools: Bash, Read
paths: docs/**/.assets/*.drawio.yml, docs/**/.assets/*.drawio.png, out/drawio/**
metadata:
  catzc:
    config:
      model_floor: haiku
      needs: [uv, pillow, pwsh]
---

# drawio-declaration

1. The yml is the one source; put renders it into the png, get folds a draw.io edit back (ADR-REPO-SLIDES-TWODIRECTIONS), by diagram, in the
   background: `timeout 360 uv run -q --project <repo>/python python -m catzc.diagrams.declaration put|get <name>.drawio.yml`.
2. `Build-Diagrams -Path <name>.drawio.yml -FromDrawing` runs get, put and Test-Diagrams in one call; `-Stale` rebuilds stale minimaps;
   `declaration.py minimaps` reads the data only `Build-Diagrams` refreshes, so the order is Build-Diagrams, minimaps, Build-Diagrams;
   `-Theme <name>` renders to `out/drawio/themes/<name>/`. A pair whose yml and png both moved since HEAD is a conflict: only put or get by
   name, the author's pick, clears it (ADR-REPO-SLIDES-CONFLICTNEEDSAPICK); never merge or pick. Forward every validation error verbatim. A
   sample under `out/` renders by `Write-DiagramMinimapData` then declaration.py put, since `Build-Diagrams -Path` refuses folders outside
   `docs/`. A diagram under `about.lens: action` (DDR-VISUAL-ACTIONISALENS) declares `content.cause`, `action` (`call`, or `calls` for a
   call site) and `effects` (`id`, `zone` from 1 with no gaps, then a state change's `where`, `says`, `proves` or an execution's `call`,
   optionally `after: <id>` of an earlier effect in its own zone or one nearer the action, never a later one), and no bands, groups, edges,
   spans, `relation` or `thick`; the kit draws every edge with its operator (cats, executes, affects, effects) and lists the four in the
   legend; every box carries a story number (cause 1, action 2, effects in declared order) and get reads the order back from them;
   `about.proves` names the proof file of runs each state change's observation occurs in verbatim, and two zones fit the frame, three do
   not. The Proof box under the frame (each call's statement and its words per engine) shows by default and `content.proof: hidden` turns it
   off; `about.lens: proof` draws that box alone from `content.action` and refuses the cause, the effects and `content.proof`. Every
   diagram, band ones too, ends in one legend band: a captioned box per segment (Action, Proof, Map key under the sidebar), the swatches
   centred in a left column and the words beside them. A new article-carried diagram is registered once with
   `declaration.py carry <stem> file`, then `Build-Diagrams -Path <name>.drawio.yml` renders it.
