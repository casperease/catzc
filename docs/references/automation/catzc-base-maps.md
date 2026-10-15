---
catzc:
  derived:
    path: docs/references/automation/catzc-base-maps.md
    kind: reference
    body_sha: f9b41c1bf06e
    adrs:
      - ADR-DSGN-TRACK#{3,13,15}
    links:
      - docs/adr/design/tracks.md
      - docs/adr/design/tracks.md#rule-adr-dsgn-track13
      - docs/adr/design/tracks.md#rule-adr-dsgn-track15
      - docs/adr/design/tracks.md#rule-adr-dsgn-track16
      - docs/adr/design/tracks.md#rule-adr-dsgn-track3
      - docs/adr/design/tracks.md#rule-adr-dsgn-track9
      - docs/adr/repository/dedicated-output-directory.md#rule-adr-repo-outdir2
      - docs/references/automation/catzc-base-docs.md
      - docs/references/automation/catzc-base-files.md
      - docs/references/automation/catzc-base-globs.md
      - docs/references/automation/catzc-base-languages.md
      - docs/references/automation/catzc-base-variants.md
---

# Catzc.Base.Maps

The maps module. It **computes the world map**: every tracked file placed in exactly one cell of the repository's tracks crossed with its
file languages, built from the repository's own registries and the git index, never drawn by hand
([tracks](../../adr/design/tracks.md#rule-adr-dsgn-track9)). On that map it lights the cells an ADR code or a set of files concerns, checks
that no track carries a second tech-stack, and draws the map as deterministic PDFs. Beside it, it computes the value-chain map, the ADRs
placed on the value-chain stack crossed with the value-chain concerns ([tracks](../../adr/design/tracks.md#rule-adr-dsgn-track16)). It does
**not** declare the axes: the tracks come from [Catzc.Base.Variants](catzc-base-variants.md), the file languages from
[Catzc.Base.Languages](catzc-base-languages.md), and the value-chain stack and concerns from the ADR registry of
[Catzc.Base.Docs](catzc-base-docs.md); this module only reads them. The concepts it draws are the subject of
[tracks](../../adr/design/tracks.md).

## Responsibilities

| Responsibility   | Area        | Name                                                               |
| ---------------- | ----------- | ------------------------------------------------------------------ |
| responsibility:1 | place       | [World-map placement](#responsibility1--world-map-placement)       |
| responsibility:2 | highlight   | [Lit cells](#responsibility2--lit-cells)                           |
| responsibility:3 | verify      | [World-map quality gate](#responsibility3--world-map-quality-gate) |
| responsibility:4 | value-chain | [Value-chain map](#responsibility4--value-chain-map)               |
| responsibility:5 | render      | [PDF rendering](#responsibility5--pdf-rendering)                   |

### responsibility:1 — World-map placement

Building the world map: one row per track and one for the root files, one column per file language and one for the unlisted files, and every
tracked file in exactly one cell. The root folder of a file gives its track and its extension gives its file language. A cell that holds a
live file whose file language its track does not declare is a stack violation; test files, vendored files, and the files of a verification
track never make one. The map is returned as an object or as JSON, so a tool reads it without PowerShell.

### responsibility:2 — Lit cells

Answering "where does this decision, or this change, sit": the cells an ADR code (or one of its rules) or a set of tracked files lights. An
ADR code lights the ADR files of its ADR domain and every file whose citations name it, derived in a fixed order per artifact kind, and the
reviewed pins and exceptions in the configuration then apply. With no argument it lights the cells the working tree's changes sit in.
Lighting a cell never changes its file count.

### responsibility:3 — World-map quality gate

The quality gate over the map: one issue per stack violation, per root folder that holds tracked files but names no track, and per printed
label whose head names no defined term. It reads the map's placements and never places a file itself, and ends through the shared
quality-gate report.

### responsibility:4 — Value-chain map

Building the value-chain map from the ADR registry: one row per row of the value-chain stack, one column per value-chain concern, and every
ADR in the cells where its ADR domain's row meets each of its value-chain concerns. An ADR code, or one of its rules, lights the cells its
ADR sits in. The map and a highlight are returned as objects or as JSON. Its own quality gate checks that the rows and columns are the
registry's closed sets, that every ADR sits in at least one cell, and that every value-chain label names a defined term.

### responsibility:5 — PDF rendering

Drawing the world map as PDFs, one file per view: the grid, rows by columns with each cell shaded by its file count and each stack violation
marked, and the tree, the tracks as a treemap by file count. With a highlight the lit cells are outlined and the files take their own name,
so a highlight never overwrites the plain map. The colours, labels, limits, page size, reviewed pins and exceptions, and the output folder
are configuration with a default declared once on the config type. The bytes depend only on the map, the configuration, and the highlight.

## What the module does

The module turns two registries and the git index into one picture of the repository. Responsibility 1 is its foundation: every other
world-map responsibility reads the placed map and none places a file itself, so the grid, the treemap, the lit cells, and the quality gate
all agree on where a file sits. Placement is exact rather than heuristic — the root folder and the extension decide — which is what makes
the map the same on every run of the same commit and lets a consumer, such as the small maps on the diagram slides, read it instead of
guessing.

Two rules from [tracks](../../adr/design/tracks.md) shape the checking half. A track owns one tech-stack
([ADR-DSGN-TRACK#3](../../adr/design/tracks.md#rule-adr-dsgn-track3)), so the map marks the cell that breaks it and responsibility 3 turns
that mark into an issue. And every label the map prints names a defined term
([ADR-DSGN-TRACK#13](../../adr/design/tracks.md#rule-adr-dsgn-track13)), so responsibility 3 also holds the configured labels to the
glossary: the renderer of responsibility 5 prints nothing the vocabulary does not define.

Responsibility 2 joins the map to the ADRs. It reads citations from the files' own text, so a file lights for an ADR when it cites it, and
the configuration records the reviewed cases where a citation is a passing mention or a drawing needs a cell its files do not cite. The
module reads the ADR index through [Catzc.Base.Docs](catzc-base-docs.md), the tracked files through [Catzc.Base.Files](catzc-base-files.md),
and the globsets through [Catzc.Base.Globs](catzc-base-globs.md); it writes its PDFs under the output root
([dedicated-output-directory](../../adr/repository/dedicated-output-directory.md#rule-adr-repo-outdir2)) and draws them with its own
BCL-only PDF writer.

Responsibility 4 answers the question the world map cannot: where along delivery a decision acts. It reads nothing but the ADR registry,
where each ADR domain declares its row and a default set of value-chain concerns and an ADR declares its own only when it differs
([ADR-DSGN-TRACK#15](../../adr/design/tracks.md#rule-adr-dsgn-track15)), so its picture is declared, never guessed. Its quality gate is a
sibling of the world map's rather than a part of it, because the two read different registries and check different properties; the labels of
both maps share one configuration section and one glossary check.

## Division

The module's public functions and configuration, sorted into the responsibilities above.

| Responsibility                            | Function                  |
| ----------------------------------------- | ------------------------- |
| responsibility:1 — World-map placement    | `Get-WorldMap`            |
| responsibility:2 — Lit cells              | `Get-WorldMapHighlight`   |
| responsibility:3 — World-map quality gate | `Test-WorldMap`           |
| responsibility:4 — Value-chain map        | `Get-ValueChainMap`       |
|                                           | `Get-ValueChainHighlight` |
|                                           | `Test-ValueChainMap`      |
| responsibility:5 — PDF rendering          | `Export-WorldMapPdf`      |
|                                           | `Get-WorldMapOutputRoot`  |
| config                                    | `maps.yml`                |
