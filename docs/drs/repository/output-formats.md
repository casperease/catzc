# Repository: Output formats — one catalogue of what lands under the output root

## Rules: ADR-REPO-OUTFMT

### Rule ADR-REPO-OUTFMT-OUTPUTFORMAT

An **output format** is one declared kind of file a producer writes under the output root, listed once in the catalogue
`Catzc.Base.Reports/configs/output-formats.yml` with its id, its file patterns relative to the output root, its producer, its audience, its
validator, and its limits. No path can match the patterns of two formats: the catalogue is rejected on load when two patterns can overlap,
so a file's format never depends on declaration order or on which pattern is more specific. Every file under a catalogued folder belongs to
exactly one output format; a file that matches none is an orphan and an error. The format's **area** (`run`, `build`, `cache`, `review`,
`session`, `log`) sets how long its files stay: the newest stamps of a run, the newest build, every cache entry and review artifact, session
files for seven days. A format overrides the area with `keep` and `max_age`, and the defaults are declared once on the format type.
`Clear-Output` removes what no format keeps, and reports, never removes, a file no format covers; in a pipeline, whose staging directory is
fresh for every run, it removes nothing.

- [The catalogue](#the-catalogue)
- [Retention](#retention)

### Rule ADR-REPO-OUTFMT-REVIEWABLEFORMATS

A format a person reviews opens without developer tools: it is PNG, PDF, or Markdown. HTML is not a local output format. A page meant for a
browser is published as a review page (ADR-REPO-OUTFMT-REVIEWPAGE) instead of written to the output root.

- [Formats for people](#formats-for-people)

### Rule ADR-REPO-OUTFMT-VALIDATORISCODE

Every output format has a validator, and the validator is code. It checks structure, never taste: a file's signature and end marker, an
embedded model that decodes, pixel dimensions against the format's limits, required keys, and the columns and vocabulary of a table. The
validators are a closed set of kinds, written in PowerShell and .NET, so checking needs no Python. A format whose structure another check
proves names that check as its validator and never re-implements it.

- [Validators](#validators)

### Rule ADR-REPO-OUTFMT-DETERMINISTICPRODUCER

A producer is deterministic and re-runnable from its declared inputs, and it writes only the files of its own formats. A producer never
edits another producer's files.

- [Producers](#producers)

### Rule ADR-REPO-OUTFMT-LIMITSINCATALOGUE

A format's limits — sizes, maximum dimensions, text limits — are fields in the catalogue. Prose (this record, agent guidance) gives the
reason for a limit and points at the catalogue; it never restates the value.

- [The catalogue](#the-catalogue)

### Rule ADR-REPO-OUTFMT-REVIEWPAGE

A **review page** is a page published to claude.ai that bundles output files for a person to review. It is never called an artifact: a
published artifact is a file that crosses a stage boundary, and a review page crosses none.

- [Formats for people](#formats-for-people)

### Rule ADR-REPO-OUTFMT-PYTHONPRODUCER

A producer written in Python ships in its owning module's `assets/`, runs through uv, and declares each package it needs with a pinned
version, once. A public function runs it; no caller reaches a producer script by its path.

- [Producers](#producers)

## Context

[ADR-REPO-OUTDIR](dedicated-output-directory.md) decides where output goes: under `Get-OutputRoot`, one subfolder per recurring producer,
never beside the source. It does not say what may land there. Without that, every producer invents its own file shapes, and nothing checks
them. A truncated PNG, a PDF without its end marker, a page the reader has no program to open, and two producers writing the same file all
look the same as a good result until a person opens the file.

The output root holds many kinds of file: quality-gate reports, test-run results, the toolset's build and packages, rendered diagrams with
their embedded models, contact sheets, review PDFs, check notes, and the index files that tie a set of drawings together. Each kind has a
producer, a reader, and a shape it must have. Declaring them once makes the shape checkable.

## Decision

### The catalogue

`output-formats.yml` in `Catzc.Base.Reports` lists every output format. `Catzc.Base.Reports` owns it because it owns `reports.yml`, what a
quality gate writes; the catalogue widens that to what any producer writes. A typed config validates the catalogue on load: it rejects a
duplicate id, an unknown validator kind, a format without a producer or an audience, and two formats whose patterns can match the same path.

The overlap check is structural, not a tie-breaker. A rule such as "the most specific pattern wins" lets a new, broader pattern quietly take
files from an existing format; rejecting the overlap makes every file's format readable from the catalogue alone. When two producers write
the same kind of file into the same folders, they share one format and its producer field names both.

A limit is a field of its format, because a value repeated in prose drifts from the value the check uses. Adding a format is a catalogue
entry, not code, as long as an existing validator kind fits it.

### Retention

A run folder that only grows is noise: a person reads the latest run and compares a few. So every file under the output root is a format,
and the format's area says how long it stays. A run keeps its newest stamps, as whole stamp folders, so a run's report, rows and results go
together. A build keeps its newest version, because the build is regenerated from source. A cache stays, because its own keys decide when an
entry is stale, and age is not staleness. A review artifact stays until a person retires it. A session's scripts, dumps and logs go after a
week, and an appended log stays while it is written. The defaults sit once on the format type and a format states only what differs, so
retention is configured, not programmed (PDR-CONFIG). A file no format covers is reported and left alone: removing what nobody declared
would guess at its owner.

### Formats for people

A person reviews PNG, PDF, and Markdown with the tools every machine has. HTML needs a browser opened on a local file, which not every
reader has or wants; a page that needs a browser is published as a review page, where it opens from a link. A review page has its own name
because "artifact" means a file handed between pipeline stages
([ADR-AUTO-PATH-PUBLISHEDARTIFACT](../automation/path-representation.md#rule-adr-auto-path-publishedartifact)), and one word carries one
meaning ([controlled-vocabulary](controlled-vocabulary.md)).

### Validators

A validator proves a file is whole and has the shape its format declares. It does not judge whether a drawing is good. The checks are
structural because structure is what breaks silently: a writer that stops early, a model that does not round-trip, a raster at the wrong
size. The validator kinds are a closed set with parameters (for example a PNG kind, a PDF kind, a JSON-keys kind, a Markdown-table kind),
written in PowerShell and .NET, so checking runs anywhere the toolset runs. The toolset's build is proven by `Assert-CatzcBundle`, so its
format names that check instead of a second one.

### Producers

A producer rebuilds its files from declared inputs — files on disk, a manifest, the tracked file list — so running it again gives the same
result, and a reviewer can regenerate any file instead of trusting it. A producer writes only its own formats, so parallel producers never
overwrite each other.

A Python producer is product code: it ships in `Catzc.Base.Reports/assets/` and runs through a public function that resolves the script and
starts it through uv with its pinned packages ([ADR-AUTO-UVPY](../automation/uv-python-handler.md)). The caller names the producer, never a
path, so moving or renaming a script changes one function.

## Consequences

- One file says which formats exist, who writes each, who reads it, and how it is checked.
- A broken or orphaned file under the output root is a named failure, not a surprise when someone opens it.
- People receive files they can open; browser pages arrive as review pages.
- A format's limits change in one place.
- Python producers are versioned and shipped with the toolset like every other module asset.

## How this is enforced

- `Get-Config -Config output-formats` validates the catalogue through its typed config; `Test-ShippedConfigs` proves the shipped catalogue
  loads.
- `Test-OutputFormats` walks the catalogued folders under the output root, classifies every file by pattern, runs its validator, reports
  orphans, and writes its report through `Write-QualityGateReport`. It runs on demand on a devbox, where the output root is transient, and a
  pipeline runs it over its own staging directory.
