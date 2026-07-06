# ADR: Dedicated output directory

## Rules: ADR-OUTDIR

### Rule ADR-OUTDIR:1

Use `Get-OutputRoot` for every output path (reports, exports, generated configs, build artifacts, test results); it resolves to
`{RepositoryRoot}/out` locally and `$env:BUILD_ARTIFACTSTAGINGDIRECTORY` in a pipeline. Pass `-EnsureExists` to create it.

- [Decision](#decision)

### Rule ADR-OUTDIR:2

Functions that produce multiple or recurring files create a subdirectory under the output root rather than dumping into it directly.

- [Decision](#decision)

### Rule ADR-OUTDIR:3

Use `[IO.Path]::GetTempPath()` for scratch files — intermediate files consumed and discarded within the same call belong in the system temp
directory, not the repository.

- [Scratch vs. output](#scratch-vs-output)

### Rule ADR-OUTDIR:4

Never write output files to the repository root, the script directory (`$PSScriptRoot`), or any source folder. Output does not belong next
to source.

- [Context](#context)

### Rule ADR-OUTDIR:5

The combined compiled-type prebuild at `automation/.compiled/` is not transient output: it is a committed, deterministic, hash-keyed
vendored artifact (one assembly for the whole repository) and lives there on purpose. Only the `*.tmp` compile scratch is gitignored.

- [Decision](#decision)

### Rule ADR-OUTDIR:6

`out/` is gitignored: the directory exists via `.gitkeep` but its contents are never committed, so generated files never appear in
`git status`.

- [Consequences](#consequences)

### Rule ADR-OUTDIR:7

Cleaning all output is one command: `Remove-Item (Join-Path (Get-OutputRoot) '*') -Recurse -Force`. CI and developers use the same path.

- [Decision](#decision)

### Rule ADR-OUTDIR:8

The spell-checker dictionaries generated from the terminology registry (ADR-SPELL:5) are NOT committed: like the `.psd1` manifests they are
generated (one `<category>.txt` per vocabulary category under the root `.cspell/`), gitignored, and regenerated at the importer tail from
`configs/terminology.yml`. The registry is the single source of truth; the word lists are ephemeral build artifacts cspell resolves at a
fixed path after an import (a fresh clone must run the importer once before cspell has them). Everything in `.cspell/` is generated — the
word lists, the folder's `.gitignore` (a managed root-config copy), and its `README.md` (a generated link); only the `.gitkeep` keeping the
folder tracked is committed. This is the `.psd1`/generated-README pattern — not the committed-artifact exception of ADR-OUTDIR:5.

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
writes, decompression buffers — should use the system temp directory (`[IO.Path]::GetTempPath()`). Scratch files are transient and
disposable. Nobody needs to find them after the function returns.

Output files are different. They are the _result_ of an operation — something a human or downstream process will consume. These need a
predictable, findable, and cleanable location inside the repository.

## Decision

All output files are written to the path returned by `Get-OutputRoot`.

Locally this is `{RepositoryRoot}/out`; in an Azure DevOps pipeline it is `$env:BUILD_ARTIFACTSTAGINGDIRECTORY`.

Scratch files use the system temp directory.

Two classes of generated file live in the source tree rather than under `out/`. One is committed: the combined compiled-type prebuild
(ADR-OUTDIR:5), an expensive Roslyn build kept at a fixed path so a fresh checkout and CI load without compiling — the deliberate exception
to ADR-OUTDIR:4. The other is gitignored and regenerated on import — the `.psd1` module manifests, the generated READMEs, and the
spell-checker dictionaries (ADR-OUTDIR:8) — cheap to reproduce, so they are never committed and the authored source stays the single source
of truth.

## Consequences

- `git status` stays clean. Generated files never appear as untracked changes.
- There is exactly one place to look for output — `out/`. No searching, no guessing.
- Cleaning up is trivial — delete the contents of one directory.
- The distinction between source (committed) and output (transient) is structural, by convention.
- Output location is determined by convention, not by the function author.
