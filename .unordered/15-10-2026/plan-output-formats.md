# Plan: an ADR for output formats, plus a validated catalogue with built-in sanity tests

## Handoff (read first if you are a new session)

This plan was written by the diagram-waves session; steps 1 and 2 are built. Pick it up cold:

- **The three open questions are decided** (user, 2026-10-14, with catzc-25) — see "Decisions" below.
- **Context to read:**
  - `docs/adr/repository/dedicated-output-directory.md`, the sibling ADR this one complements;
  - `docs/adr/index.md` "Authoring conventions";
  - `.claude/drawio/STYLE.md`, whose "Fan-out" limits move into the catalogue;
  - `automation/Catzc.Base.Reports/` (`reports.yml` + `ReportsConfig.cs`), the pattern to copy;
  - `automation/Catzc.Base.Docs/configs/adrs.yml`, where to register the ADR.
- **The formats to catalogue** are on disk under `out/diagrams/`: `wave-*/`, `lenses/`, `fan-out/` and `gallery.pdf`. The existing
  quality-gate reports are `out/test-*/`.
- **Repo rules that bite here:**
  - every Bash call uses `timeout: 3000`, or runs in the background behind a `timeout <s>` prefix (`.claude/CLAUDE.md` § Time safeguard);
  - edit one file at a time, then verify it;
  - no mutating git;
  - one living version (delete what is replaced);
  - L0 fixtures use neutral widget/gadget names;
  - per-file checks only, since the user runs the full suite and the commits.

## Analysis: what exists today

- **Where output goes is decided, what it is is not.** `ADR-REPO-OUTDIR` (dedicated-output-directory) fixes the place: `Get-OutputRoot`
  (`out/` locally, the artifact staging dir in a pipeline), one subfolder per recurring producer, temp for scratch, gitignored. Nothing
  declares which file **formats** may appear there, who produces each one, who opens it, or how it is checked.
- **The diagram work created about 12 formats in one day, with no contract:**
  - `.drawio.png` and its `.xml` source;
  - `minimap-*.{stack,tree}.png`;
  - `*.sheet.png`;
  - `world-map.*.png`;
  - `gallery.pdf`;
  - `index.html`;
  - `*.verify.md` / `*.lenses.verify.md`;
  - `_manifest.json`, `_slugs.json`, `_placements.json`.

  Their rules live in `.claude/drawio/STYLE.md` (agent guidance) and in five Python scripts (`.claude/drawio/*.py`). Nothing checks the
  files apart from the ad-hoc round-trip asserts inside the scripts.

- **The real failures this session were all format failures that a catalogue gate would have caught:**
  - the headless draw.io CLI writing truncated PNGs (no `IEND`);
  - two makers overwriting each other's files;
  - a preview hiding dashed edges;
  - the user unable to open `index.html`, because they have no HTML viewer.
- **The repo already has the pattern to copy.** A typed config catalogue goes in `<Module>/configs/<name>.yml`, with a C# type in `types/`
  registered in `configs.yml`. `Get-Config` validates it on load, `Test-ShippedConfigs` proves the shipped file loads, and a `Test-*`
  quality gate reports through `Write-QualityGateReport`. Examples: `adrs.yml` + `AdrsConfig` + `Test-AdrRegistry`, and `reports.yml` +
  `ReportsConfig`.
- **`Catzc.Base.Reports` already owns "what a quality gate writes"** (`reports.yml`). It is the natural owner of "what any producer writes".

The ADR is `docs/adr/repository/output-formats.md`; the catalogue is `automation/Catzc.Base.Reports/configs/output-formats.yml`.

## Sanity tests built in

- **L0 (logic, neutral widget/gadget fixtures, per ADR-TEST#3):**
  - the config type rejects each bad-catalogue shape;
  - every validator kind accepts a tiny generated good file and rejects a broken one. The broken cases are a PNG truncated before `IEND`, a
    `.drawio.png` without `mxfile`, a minimap at the wrong size, a PDF without `%%EOF`, and JSON missing a key.
- **L1:** every producer the catalogue names exists, either as a function (`Get-Command`) or as a script path.
- **Gate `Test-OutputFormats`:** it walks the catalogued folders under `Get-OutputRoot`, classifies every file by pattern, runs its
  validator, flags orphans, and reports through `Write-QualityGateReport` (`out/test-output-formats/<stamp>/`). It is an on-demand devbox
  gate, because `out/` is transient and a CI run has only its own artifacts. A pipeline can run it over its own staging dir.

## Cleanup in the same change (one living version)

- **Delete `.claude/drawio/gallery.py` and `out/diagrams/index.html`.** HTML is not a local output format under rule 2, and `gallery_pdf.py`
  replaces them.
- **Move the format limits out of `STYLE.md`** into the catalogue. `STYLE.md` keeps the drawing _style_, and points at the catalogue for
  sizes and limits.
- **Pin Pillow** in one place, and make every `uv run --with pillow` call read the pin.

## Decisions (user, 2026-10-14)

| #   | Question         | Decision                                                                                                                                                                     |
| --- | ---------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 1   | Scope            | **Today's formats and the build outputs** in v1: the `Catzc/<v>/` bundle, the `.nupkg`, and the test results (`out/test-automation/<run>/`, `out/test-file/<run>/`).         |
| 2   | Python producers | **Move into the module**: `.claude/drawio/*.py` (+ `atlas.template.html`) → `automation/Catzc.Base.Reports/assets/drawio/`. They become product code and ship in the bundle. |
| 3   | Owner module     | **`Catzc.Base.Reports`**.                                                                                                                                                    |

### Pattern overlap (user, 2026-10-14)

No "most specific pattern wins". `OutputPattern` (`Catzc.Base.Reports/types/OutputPattern.cs`) parses each glob and decides `Overlaps`;
`OutputFormatsConfig` rejects any two formats whose patterns can match one path. Producers writing the same kind of file into the same
folders share one format (`test-report` covers gate reports plus the runs' `summary.md` / `rule-coverage.md`). The gate in step 4 uses
`OutputPattern.Matches` and never needs a tie-break.

### Status

Built: the ADR and its registration, `OutputPattern`, `OutputFormatsConfig`, and the catalogue `output-formats.yml` with every v1 format,
including decision 1's `catzc-bundle`, `catzc-package` and the `test-run-*` entries. Not built: the validator kinds (declared in the
catalogue, including `zip`, `nunit-xml` and `delegate`), `Test-OutputFormats`, the cleanup and the producer move.

Open: the `*.verify.md` column name. About 20 files use `Verdict`, 15 use `Status`, and the catalogue declares
`# | Claim | Source | Verdict`.

### What decision 2 changes

- **Move, one living version:** `git mv` is the user's (no mutating git here), so the move is delivered as new files under `assets/drawio/`
  plus the deletion of `.claude/drawio/*.py`; the user stages both sides. `STYLE.md` stays in `.claude/drawio/` (it is agent guidance), and
  points at the module path.
- **Callers to update in the same change** (from `git grep '.claude/drawio'`): `.claude/agents/drawio-diagram-waves.md`,
  `.claude/drawio/STYLE.md`, the cross-references inside `atlas.py`, `gallery.py`, `gallery_pdf.py`, and the path entry in
  `Catzc.Base.QualityGates/configs/terminology.yml`. Re-check the `print-artifacts` and `write-drawio-files` agents at execution time.
- **Shipping Python in the bundle** means the scripts run through the module, not by a path an agent remembers: a thin public function (e.g.
  `Invoke-DrawioProducer -Script <name>`) resolves `assets/drawio/<name>.py` the way module assets are resolved today (ADR-AUTO-ASSETDEP)
  and runs it with `uv run --with pillow==<pin>` (ADR-REPO-OUTFMT#7, ADR-AUTO-UVPY). Read ADR-AUTO-ASSETDEP and ADR-AUTO-UVPY before
  designing it.
- **Coordination:** catzc-08 (diagram-waves, active) uses these scripts every wave, and catzc-43's `plan-test-languages.md` P2 is Python.
  Message both before the move; land the move between diagram waves.

## Order of work, once the user says go

1. Validator kinds (private functions) and their L0 tests, one file at a time.
2. `Test-OutputFormats`, then a first run over `out/` with the report fixed.
3. Cleanup: delete the HTML gallery, pin Pillow, point `STYLE.md` at the catalogue.
4. The producer move (decision 2), between diagram waves, after messaging catzc-08 and catzc-43.
5. Re-run the gate. It must be green on the current `out/diagrams` before the fan-out join lands.
