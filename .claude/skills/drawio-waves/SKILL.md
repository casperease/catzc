---
name: drawio-waves
description: >
  Lead waves of makers that author new diagrams: bounded fan-out, fixed maker briefs, one shared kit, nothing in docs/ until the user
  approves; the user invokes it; input is the areas or decision records to draw for and the wave number.
user-invocable: true
allowed-tools: Agent, Bash, Read, Glob, Grep, Write, Edit
paths: out/diagrams/**, python/diagrams/**
metadata:
  catzc:
    config:
      model_floor: sonnet
      needs: [uv, pillow]
---

# drawio-waves

Read `python/diagrams/assets/STYLE.md` and the diagram-waves plan in `.claude/plans/` (the backlog) first; words come only from the sources,
never an invented number, part or loop; "domain rules" and "cats" in prose.

1. Wave 0: at most 4 read-only scouts split by area return the style rules (exact hex values, verbatim style strings) and at most 6
   candidates each (filename, finding, source record, box sketch); the lead ranks them, picks at most 12, and keeps the rest as the backlog
   in the plan; every wave launches in one message, never more than 12 agents in flight, the lead preps the next briefs while a wave runs
   and never polls or predicts; a session spawns at most 20 subagents in all, and a fan-out writes its brief once to a file and sends each
   agent one line naming it.
2. Wave N: each maker is a drone-sonnet with exactly this brief: read STYLE.md and its quality-bar diagram; verify each claim against the
   record, code and configs into `<name>.verify.md` (claim, `file:line`, confirmed / contradicted / DRS-only); write
   `out/diagrams/wave-N/<subfolder>/<name>.drawio.yml` (`description:`, `about:`, `content:`, `layout:` only where the grid would misplace a
   cell) to the readability rules; put it with drawio-declaration, look, fix, at most 3 puts; reply in at most 8 lines; the brief names the
   finding and a sketch in the record's exact terms, the time safeguard, never `docs/`, never git.
3. Fan-in: one table per wave (diagram, staged path, finding, the maker's doubts), drift found in existing diagrams surfaced and not fixed,
   then the user's verdicts (approve / change / drop), "change" reworking the brief; fold what a report or verdict teaches into STYLE.md at
   once; bundles (`gallery_pdf.py`, with `--assets <tree>/.assets` for a landed tree, `atlas.py`) only on the user's ask, as PDF or a
   claude.ai page, never a local HTML; an approved diagram lands one at a time as the pair `docs/<area>/.assets/<name>.drawio.yml` and
   `.drawio.png`, embedded in its article with one Edit, never over an existing pair, a `.bkp` or `.dtmp` sibling meaning the user has it
   open; a landed diagram is rebuilt by `Build-Diagrams -Path <name>.drawio.yml` only (ADR-REPO-SLIDES-ONEBUILDCOMMAND).
