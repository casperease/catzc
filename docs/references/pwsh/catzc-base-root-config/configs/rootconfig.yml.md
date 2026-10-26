# pwsh/Base.RootConfig/configs/rootconfig.yml

The root config registry: the repository-root files fully managed by the source-of-truth automation. Each entry names one in-repo source of
truth (`source`, an authored file copied out, or `generator`, a function that renders the content), and `Build-RootConfig` reproduces the
target from it on every import.

## Keys

Two booleans, both defaulting to false:

- **`optIn`** — is this file managed at all? Opt-out is the default: an entry with `optIn` false (or a root file with no entry) stays
  hand-authored and committed.
- **`committed`** — is the managed target tracked in git? False means gitignored (reproduced on import, invisible churn); true means
  committed (for files git or the bootstrap reads before the importer runs, such as `importer.ps1` and the git files), where a source change
  surfaces as a reviewable diff.

A `source` target is always a copy of its template under the generated-file head, never a link to it.

`carrier` names the file-carriers entry for the generated-file head of a composed file (default: the entry of the target's file language);
`sources` lists the authored files a generator renders from. All paths are repository-root-relative and forward-slashed (communication form;
see [ADR-AUTO-PATH](../../../../drs/automation/path-representation.md)).

## How it is read

It is loaded via `Get-Config -Config rootconfig`, and `Catzc.Base.RootConfig.RootConfigFiles` validates the shape. See
[ADR-REPO-ROOTCFG](../../../../drs/repository/generated-root-configs.md).

## The importer entries

`importer.ps1` has two valid source-of-truth forms, swapped by editing its entry alone:

- `generator: New-Importer` is the live form: the full shim, rendered from the `Invoke-Importer` overlay's param block on every import (the
  drift guard in `New-Importer.Tests.ps1`).
- `source: pwsh/Base.RootConfig/assets/root/importer.ps1` (comment: none) is the seed form for a first check-in: a minimal bootstrap that
  just performs one full import. The importer tail's `Build-RootConfig` then materialises whatever this entry names, so switching back to
  the generator self-heals the seed into the full shim on the very next load.

`importer.sh` is the bash (and zsh) entry: sourced, it defines the `cats` dispatcher that runs catzc commands through pwsh
([ADR-AUTO-ENGINE](../../../../drs/automation/execution-engines.md)). It is committed for the same reason as `importer.ps1`: a fresh clone
needs it before any import.

## The generated copies

- The three generated `.vscode/` files are gitignored generated copies (`committed: false`): the editor greys them and a fresh clone
  materialises them on the first import. Their sources of truth are the `Catzc.Base.VSCode` registries (settings, extensions, launch).
- The Go test workspace (`Catzc.Base.Languages`, `New-GoWorkspace`) is `go.work` at the repository root, and one `go.mod` per Go test module
  under the Go root (`go.yml` `root`: `go/` when present, else `.go/`). They are gitignored generated copies.
- The Python test workspace (`Catzc.Base.Languages`, `New-PythonProject`) is the uv workspace root `pyproject.toml` in the Python root
  (`python.yml` `root`: `python/` when present, else `.python/`), and one member `pyproject.toml` per Python test folder. They are
  gitignored generated copies; uv makes the one `.venv` and `uv.lock` beside the workspace root.
- `.editorconfig` is the first width-bearing tool config, its asset template with every width filled from `file-limits.yml`. It renders
  before `.vscode/settings.json`, whose generator reads it from disk, so a tree without it (a fresh clone, a test snapshot) renders both at
  once.
- `jsconfig.json` is the project the editor and the js track's types gate read; its type root is the repository-relative folder
  `Install-TypeScript` fills, so it is the same on every machine. `jsconfig.lenient.json` holds the modules `javascript.yml`'s strict list
  does not raise yet, checked leniently; it extends `jsconfig.json`, and holds no file once every module is raised.

## Where the managed-file marker lives

- JSON has no comment syntax (and the dotnet manifest parser rejects `//` line comments), so for `dotnet-tools.json` the managed-file marker
  travels in the authored source as an ignored `//` property.
- MSBuild's solution parser requires the `Format Version` line at the top, so for `catzc.sln` the managed-file note lives inside the
  source's own `#` comment block (which the format allows only after that line).
