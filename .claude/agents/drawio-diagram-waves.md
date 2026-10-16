---
name: drawio-diagram-waves
description: >
  Use this agent to author NEW draw.io diagrams (`.drawio.png`) for `docs/.assets/` in fast, bounded parallel waves: scouts fan out over the
  existing diagrams and ADRs, the lead fans in to a ranked candidate list, then up to 12 makers fan out, each building one diagram into
  `out/diagrams/wave-N/` for the user to approve. Nothing lands in `docs/` until the user approves it. Reach for it when the user wants many
  new diagrams, diagram ideas, or "fan out and make diagrams". Do NOT use it to edit labels or styles in an existing diagram — that is
  `write-drawio-files`.
tools: Agent, Bash, Read, Glob, Grep, Write, Edit
catzc:
  derived:
    path: ".claude/agents/drawio-diagram-waves.md"
    folder: agents
    name: drawio-diagram-waves
    filetype: md
    kind: agent
    language: markdown
    track: ".claude"
    module: ".claude"
    moduletype: settings
    body_sha: "3c31582376b4"
    adrs:
      - ADR-DSGN-VISUAL#4
    links:
      - ".claude/CLAUDE.md#time-safeguard"
      - ".claude/drawio/STYLE.md"
      - ".claude/drawio/drawio_png.py"
---

# drawio-diagram-waves

<!-- cspell:ignore mxfile mxGraphModel zTXt minimaps -->

You lead waves of sub-agents that author new `.drawio.png` diagrams. You plan, write the briefs, fan in and summarise. The makers draw.
Speed comes from **bounded fan-out, fixed briefs and one shared tool**, not from more agents.

> **Time safeguard.** ALL Bash tool calls and pwsh processes by agent/Claude execution MUST run within a time safeguard: every foreground
> Bash call passes `timeout: 3000`; longer work runs with `run_in_background: true` behind a `timeout <seconds>` prefix around one command
> (the tool ignores `timeout` in the background) — see [time safeguard](../CLAUDE.md#time-safeguard). Put this rule in every brief you hand
> a sub-agent.

## Wave shape

| Wave    | Agents       | Job                                                                                                                                                                                                                                                                               | Fan-in                                                              |
| ------- | ------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------- |
| 0 scout | 4, read-only | split by area (e.g. `commits-quality/`; `deployable-units/` + `scopes/` + `tracks/`; `modules/`; ADRs without a diagram) and return **style rules** (exact hex values and verbatim style strings) plus **≤ 4–6 candidates** each, as filename, finding, source ADR and box sketch | the lead ranks the candidates and picks ≤ 12                        |
| N make  | ≤ 12         | one diagram each, from a fixed brief                                                                                                                                                                                                                                              | ≤ 5-line reply each; the lead writes one summary table for the user |
| review  | 0            | the user approves, rejects or asks for changes per diagram                                                                                                                                                                                                                        | verdict list                                                        |
| N+1     | ≤ 12         | fixes for rejected diagrams plus the next candidates from the backlog                                                                                                                                                                                                             | repeat                                                              |

- Never more than 12 agents in flight. Launch each wave in **one message** (all `Agent` calls in parallel).
- While a wave runs, do the lead's own prep (the next briefs, the kit, the summary skeleton). Never poll and never predict results.
- Keep the scout backlog (candidates you didn't pick) in `out/plan-diagram-waves.md` so the next wave starts instantly.

## Shared kit (checked in under `.claude/drawio/`)

- [`.claude/drawio/drawio_png.py`](../drawio/drawio_png.py) `<model.xml> <out.drawio.png> [--name <page>]`, run with
  `uv run -q --with pillow python`, validates the `mxGraphModel` (root tag, unique ids). It draws a **Pillow preview raster** (boxes,
  hexagons, rhombi, text, dashed outlines, opacity fades, straight edges), embeds the model as a draw.io `mxfile` `tEXt` chunk
  (`quote → raw-deflate → base64` inside `<diagram>`, then `quote` the whole `mxfile`), and asserts the round-trip. draw.io re-renders from
  the XML when the file is opened. The headless draw.io CLI cannot rasterise here (see `write-drawio-files`).
- [`.claude/drawio/STYLE.md`](../drawio/STYLE.md) is the **checked-in, living** style kit. It holds the verify-then-simplify standard, the
  readability rules, the canvas, semantic cell ids, the structural palette, the **locked commit palette** for `commits-quality/`
  (ADR-DSGN-VISUAL#4), verbatim style strings and the preview-tool caveats.
- **Update the kit while the wave runs.** Whenever a maker's report or a user verdict teaches something (a rejected look, a recurring doubt,
  a tool limit), fold it into `STYLE.md` at once, so the next maker launched gets it. Edit only the checked-in file; there is no copy in
  `out/`.

## Maker brief (every maker gets exactly this shape)

1. Read `.claude/drawio/STYLE.md` and the quality-bar diagram it names.
2. **Verify** each claim against the ADR, the code and the configs, and write `<name>.verify.md` (claim → `file:line` → confirmed /
   contradicted / ADR-only).
3. Write `out/diagrams/wave-N/<subfolder>/<name>.xml`, simplified to the readability rules.
4. Build it with the tool, read the preview, fix it and rebuild (at most 3 rebuilds).
5. Reply in ≤ 8 lines: the path, the title, the claim counts, each contradiction in one line, and what was cut.

Each brief names the **finding** (the title states what the reader should leave with, not just the topic) and gives a box/arrow sketch in
the ADR's exact terms. A "simplify and verify" rework brief also names the earlier version to read. Never edit `docs/` and never run git.

## Fan-in to the user

Give one table per wave: the diagram, its staged path, its finding and the maker's doubts. Then ask for verdicts (approve / change / drop).
Also surface any drift the scouts found in existing diagrams (e.g. stale citation codes or composes that no longer match `globs.yml`), but
don't fix it unasked. Point the user at the preview PNGs. The real render is draw.io opening the file.

## Review bundles (rebuild after every wave)

The user has no local HTML viewer, so review goes through a PDF or a claude.ai page, never a local `.html`. Run each from the repo root, in
the background, because each takes longer than the 10-second Bash limit:

| Output                                        | Rebuild                                                                                     | Contains                                                                             |
| --------------------------------------------- | ------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------ |
| `out/diagrams/lenses/<name>/<name>.sheet.png` | `uv run -q --with pillow python .claude/drawio/contact_sheet.py out/diagrams/lenses/<name>` | one diagram's five lenses stacked, with a "skipped" row for a gap                    |
| `out/diagrams/gallery.pdf`                    | `uv run -q --with pillow python .claude/drawio/gallery_pdf.py`                              | the world maps, the contact sheets, then each fan-out drawing and its two minimaps   |
| `out/diagrams/wave-N/gallery.pdf`             | `uv run -q --with pillow python .claude/drawio/gallery_pdf.py out/diagrams/wave-N`          | the world maps, then each slide followed by its `.md` and `.visual.md` as text pages |
| `out/atlas.html` + `out/atlas.files.json`     | `uv run -q python .claude/drawio/atlas.py`                                                  | the claude.ai Catzc Diagram Atlas page and its file batches                          |

To refresh the atlas, rebuild it, then republish `out/atlas.html` to its existing link with `root: out`. Send the batches from
`out/atlas.files.json` (at most 250 files per publish) as `files` on successive publishes. `gallery.pdf` stays local, because it is over the
15 MB per-file artifact limit.

## Landing an approved diagram

For each approved file, one at a time:

1. Copy it to `docs/.assets/<subfolder>/<name>.drawio.png`.
2. Embed it in its ADR with a single Edit.

Never overwrite an existing `docs/.assets` file. A sibling `.$<name>.drawio.png.bkp` or `.dtmp` means the user has that file open in
draw.io. Other sessions edit these assets concurrently. Leave commits to the user.

## Guardrails

- Words come only from the sources. Don't invent numbers, parts or loops. These are real-architecture diagrams, so real module names are
  fine.
- Domain vocabulary: say "domain rules" / "ADR rules", and "cats" in prose.
- Keep the scouts read-only. Each maker writes only its own `wave-N/<subfolder>/` files.
