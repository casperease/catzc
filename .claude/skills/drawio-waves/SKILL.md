---
name: drawio-waves
description:
  The wave protocol for authoring new diagrams with bounded fan-out, fixed maker briefs and one shared kit; for drawio-diagram-waves; input
  is the areas or ADRs to draw for and the wave number.
user-invocable: false
allowed-tools: Agent, Bash, Read, Glob, Grep, Write, Edit
paths: out/diagrams/**, python/Catzc.Diagrams/**
metadata:
  catzc:
    immutable:
      repo_status: clean
      path: ".claude/skills/drawio-waves/SKILL.md"
      folder: skills/drawio-waves
      name: skill
      filetype: md
      role: capability
      language: markdown
      track: ".claude"
      tracktype: vendor-settings
      vendor: claude
      module: ".claude"
      moduletype: settings
    edges:
      cites:
        - ADR-REPO-SLIDES-ONEBUILDCOMMAND
    config:
      model_floor: sonnet
      needs: [uv, pillow]
---

# drawio-waves

1. Wave 0: at most 4 read-only scouts split by area return the style rules (exact hex values, verbatim style strings) and at most 6
   candidates each (filename, finding, source ADR, box sketch); the lead ranks them, picks at most 12, and keeps the rest as the backlog in
   the diagram-waves plan under `.claude/plans/`; every wave launches in one message, never more than 12 agents in flight, the lead preps
   the next briefs while a wave runs and never polls or predicts.
2. Wave N: each maker gets exactly this brief: read `python/Catzc.Diagrams/assets/STYLE.md` and its quality-bar diagram; verify each claim
   against the ADR, code and configs into `<name>.verify.md` (claim, `file:line`, confirmed / contradicted / ADR-only); write
   `out/diagrams/wave-N/<subfolder>/<name>/diagram.drawio.yml` (`description:`, `about:`, `content:`, `layout:` only where the grid would
   misplace a cell) to the readability rules; put it with drawio-declaration, look, fix, at most 3 puts; reply in at most 8 lines; the brief
   names the finding and a sketch in the ADR's exact terms, the time safeguard, never `docs/`, never git.
3. Fan-in: one table per wave (diagram, staged path, finding, the maker's doubts), drift found in existing diagrams surfaced and not fixed,
   then the user's verdicts (approve / change / drop); fold what a report or verdict teaches into STYLE.md at once; bundles
   (`gallery_pdf.py`, with `--assets <tree>/.assets` for a landed tree, `atlas.py`) only on the user's ask, as PDF or a claude.ai page,
   never a local HTML; an approved folder lands one at a time as `docs/<area>/.assets/<name>/`, its yml and png, embedded in its article
   with one Edit, never over an existing folder, a `.bkp` or `.dtmp` sibling meaning the user has it open; a landed folder is rebuilt by
   `Build-Diagrams -Path <folder>` only, never by hand (ADR-REPO-SLIDES-ONEBUILDCOMMAND).
