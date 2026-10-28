# Repository: Dedicated output directory

## Rules: ADR-REPO-OUTDIR

### Rule ADR-REPO-OUTDIR-OUTPUTROOTFUNCTION

Use `Get-OutputRoot` for every output path (reports, exports, generated configs, build artifacts, test results); it resolves to
`{RepositoryRoot}/out` locally and `$env:BUILD_ARTIFACTSTAGINGDIRECTORY` in a pipeline. Pass `-EnsureExists` to create it.

- [Decision](#decision)

### Rule ADR-REPO-OUTDIR-SUBDIRECTORYPERPRODUCER

Functions that produce multiple or recurring files create a subdirectory under the output root rather than dumping into it directly.

- [Decision](#decision)

### Rule ADR-REPO-OUTDIR-TEMPFORSCRATCH

Use `[IO.Path]::GetTempPath()` for scratch files — intermediate files consumed and discarded within the same call belong in the system temp
directory, not the repository.

- [Scratch vs. output](#scratch-vs-output)

### Rule ADR-REPO-OUTDIR-NOOUTPUTELSEWHERE

Never write output files to the repository root, the script directory (`$PSScriptRoot`), or any source folder. Output does not belong next
to source.

- [Context](#context)

### Rule ADR-REPO-OUTDIR-COMPILEDPREBUILD

The combined compiled-type prebuild is not output of the repository at all: it is a per-machine, hash-keyed build in the per-user shadow
root, and git keeps no file under `pwsh/.compiled`. What the repository commits about the types is their surface, the provided contract
under `contracts/catzc/0.1.0/catzc.internal.types/`.

- [Decision](#decision)

### Rule ADR-REPO-OUTDIR-OUTGITIGNORED

`out/` is gitignored: the directory exists via `.gitkeep` but its contents are never committed, so generated files never appear in
`git status`. It is a track, the `output` track
([DDR-TRACKTYPE-CLOSEDSETOFTYPES](../design/track-types.md#rule-ddr-tracktype-closedsetoftypes)): git ignores it, the tools operate on it,
and its build destination is none.

- [Consequences](#consequences)

### Rule ADR-REPO-OUTDIR-ONECLEANCOMMAND

Cleaning all output is one command: `Clear-Output -All`, which keeps only the folder's `.gitkeep` and the plan files
(ADR-REPO-OUTDIR-PLANNOTES). CI and developers use the same command.

- [Decision](#decision)

### Rule ADR-REPO-OUTDIR-DICTIONARIESGENERATED

The spell-checker dictionaries generated from the terminology registry are NOT committed: like the `.psd1` manifests they are generated (one
`<category>.txt` per vocabulary category under the root `.cspell/`), gitignored, and regenerated at the importer tail from
`configs/terminology.yml`. The registry is the single source of truth; the word lists are ephemeral build artifacts cspell resolves at a
fixed path after an import (a fresh clone must run the importer once before cspell has them). Everything in `.cspell/` is generated — the
word lists, the folder's `.gitignore` (a managed root-config copy), and its `README.md` (a generated link); only the `.gitkeep` keeping the
folder tracked is committed. This is the `.psd1`/generated-README pattern.

- [Decision](#decision)

### Rule ADR-REPO-OUTDIR-BUILDUNDEROUTPUT

The toolset's own build lives under the output root: `out/pwsh/built/<bundle>/` is the **build root** of each named bundle, where
`Build-Modules` writes that bundle's installable `Catzc/<version>/` module, and `out/pwsh/packages/` holds the packed packages
`Export-Catzc -To nuget` produces. Both resolve through `Get-OutputRoot`, so a pipeline writes them to its staging directory. The build is
output, not source: it is never committed, never edited, and regenerated from the source tree.

- [The toolset's build](#the-toolsets-build)

### Rule ADR-REPO-OUTDIR-PLANNOTES

A plan lives in `.claude/plans`, never under `out/` ([ADR-REPO-PLANS](plans.md)). An `out/plan-*.md` is an authored note in the wrong place,
not output, so the whitelisted clean (`Reset-GitCleanFxd`, `importer.ps1 -cleanClone`) keeps and reports it instead of deleting what cannot
be regenerated, and its author moves it. A **workstream** is one labeled section of a plan's work breakdown — its own `### W<n>:` heading,
order, and gate — that lands as one change, never half-landed (PDR-ONELIVE).

- [Plan files](#plan-files)

### Rule ADR-REPO-OUTDIR-PDFISOUTPUT

A PDF is output: it is rendered from a source, so it belongs under the output root. Git ignores `*.pdf` everywhere in the repository, and a
PDF that must be committed opts out with its own `!` line, and a note saying why, in the gitignore registry (`gitignore.yml`).

- [Decision](#decision)

## Context

Automation functions produce files — reports, exports, generated configs, build artifacts, test results. When each function chooses its own
output location, the repository accumulates files in unpredictable places: a CSV in the repo root, a JSON next to the script that created
it, an HTML report three folders deep.

This creates three problems:

1. **Dirty working tree.** Random output files show up in `git status`. Contributors either commit them by accident, add one-off
   `.gitignore` entries, or manually delete them. All three are ceremony that should not exist.

2. **No single place to clean.** Without a convention, there is no safe `Remove-Item` target. You cannot delete all generated files without
   knowing where each function put them. CI pipelines that need a clean workspace must enumerate locations or start from a fresh checkout.

3. **Confusion between source and output.** When generated files sit next to source files, it is not immediately clear which files are
   checked in and which are transient. Code review becomes harder — reviewers must distinguish authored content from generated artifacts.

### Scratch vs. output

Not every temporary file is output. Functions that need scratch space for intermediate processing — partial downloads, temp files for atomic
writes, decompression buffers — use the system temp directory (`[IO.Path]::GetTempPath()`). Scratch files are transient and disposable.
Nobody needs to find them after the function returns.

Output files are different. They are the _result_ of an operation — something a human or downstream process will consume. These need a
predictable, findable, and cleanable location inside the repository.

## Decision

All output files are written to the path returned by `Get-OutputRoot`.

Locally this is `{RepositoryRoot}/out`; in an Azure DevOps pipeline it is `$env:BUILD_ARTIFACTSTAGINGDIRECTORY`.

Scratch files use the system temp directory.

Two classes of generated file sit outside `out/`. The combined compiled-type prebuild (ADR-REPO-OUTDIR-COMPILEDPREBUILD) is a per-machine
build in the per-user shadow root, outside the repository, and only its types surface is committed, as a provided contract. The other class
sits in the source tree, gitignored and regenerated on import — the `.psd1` module manifests, the generated READMEs, and the spell-checker
dictionaries (ADR-REPO-OUTDIR-DICTIONARIESGENERATED; the terminology registry they are generated from is
[ADR-AUTO-SPELL-ONEVOCABULARYSOURCE](../automation/spell-out-names.md#rule-adr-auto-spell-onevocabularysource)) — cheap to reproduce, so
they are never committed and the authored source stays the single source of truth.

A PDF is output by its nature: every PDF here is rendered from a source, such as a diagram, a world map or a review bundle. So the ignore
rule is by file type, not by folder: `*.pdf` is ignored everywhere (ADR-REPO-OUTDIR-PDFISOUTPUT). Committing a PDF is a deliberate
exception, made visible as its own opt-out line in the gitignore registry.

### The toolset's build

The installable `Catzc` build ([platform-bundle](../automation/platform-bundle.md)) is the largest output the repository produces, and it
follows the same rule as every other: it goes under `Get-OutputRoot`, in a subdirectory of its own. `out/pwsh/` groups the toolset's own
artifacts — `built/` for the built module roots, one folder per bundle (`out/pwsh/built/<bundle>/Catzc/<version>/`), and `packages/` for the
packed `.nupkg` files — so cleaning the output root removes every build with it, and nothing generated by a build ever sits beside the
source it was built from. The build run's reports go to `out/test-catzc-build/`, apart from the source run's, so the two never overwrite
each other.

### Plan files

A plan is written by a human rather than a function, reviewed and kept with the work it plans, so it lives in `.claude/plans`, not under the
output root, which can be wiped at any time. A plan file found under `out/` cannot be regenerated, so the whitelisted clean excludes it — a
clean-clone resets every generated artifact and leaves the stray plan in place, reported like any other untracked file it refused to touch.

A plan's work breaks into workstreams — `### W<n>: <name>` sections such as W0, W1, W2 — each with its own order and gate. A workstream
lands whole: it is never committed half-done, and its citation never aliases an older label (PDR-ONELIVE).

Which files stay and for how long is decided per format, in [output-formats](output-formats.md#retention).

## Consequences

- `git status` stays clean. Generated files never appear as untracked changes.
- There is exactly one place to look for output — `out/`. No searching, no guessing.
- Cleaning up is trivial — delete the contents of one directory.
- The distinction between source (committed) and output (transient) is structural, by convention.
- Output location is determined by convention, not by the function author.
