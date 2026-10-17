---
catzc:
  immutable:
    repo_status: clean
    path: docs/adr/automation/bash/bash-test-artifacts.md
    folder: docs/adr/automation/bash
    name: bash-test-artifacts
    filetype: md
    kind: adr
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    defines:
      - ADR-AUTO-BASH#{1-6}
    cites:
      - ADR-AUTO-ENGINE#{4,6}
      - ADR-AUTO-GO#7
      - ADR-AUTO-PY#7
      - ADR-AUTO-TEST#{8,9,42}
    links:
      - docs/adr/automation/execution-engines.md
      - docs/adr/automation/execution-engines.md#rule-adr-auto-engine3
      - docs/adr/automation/execution-engines.md#rule-adr-auto-engine4
      - docs/adr/automation/go/go-test-artifacts.md
      - docs/adr/automation/platform-bundle.md
      - docs/adr/automation/python/python-test-artifacts.md
      - docs/adr/automation/test-automation.md
      - docs/adr/design/run-modes.md
      - docs/adr/design/tracks.md#rule-adr-dsgn-track2
      - docs/adr/design/tracks.md#rule-adr-dsgn-track3
      - docs/adr/pwsh/pester-testing.md#rule-adr-pwsh-pester20
      - docs/adr/repository/conventional-folders.md#rule-adr-repo-folders7
---

# ADR: Bash test artifacts — black-box tests of the engine through cats, run by a vendored bats

## Rules: ADR-AUTO-BASH

### Rule ADR-AUTO-BASH:1

Bash code in the repository's test tracks is test artifacts and nothing else: `.bats` files that verify the engine from outside, the way a
Bash user reaches it. No module or function of the engine is written in Bash, and no Bash test file ships — the Bash root lies outside
`automation/`, so `Build-Modules` never sees it. The repository's other shell scripts (`importer.sh`, the vendored installers under
`assets/scripts/`) are not tests, and this rule does not cover them; they take the shell-script checks (ADR-AUTO-BASH#6).

- [Test artifacts only](#test-artifacts-only)

### Rule ADR-AUTO-BASH:2

The Bash tests live under one Bash root, a repository-relative folder declared by `bash.yml`'s `root` with the sensible default every test
language's root takes: `bash` when the repository has a `bash/` folder (the `bash` verification track), else the dot-prefixed `.bash`. A
**Bash test folder** is the folder `<root>/tests/<module>/`, one per catzc module and named for it in kebab case, holding that module's
`.bats` files. A Bash test is one `@test "<name>" {` line; a name starting with `integrity:` makes it an integrity test.

- [The layout](#the-layout)

### Rule ADR-AUTO-BASH:3

A Bash test is a black-box test that calls catzc the way a Bash user does: its `setup` loads `CATZC_ENGINE_ENTRY` — the repository's
`importer.sh` — and the test runs catzc commands through the `cats` dispatcher, asserting on output and exit codes, never on the engine's
internals. `CATZC_IMPORTER` names the entry `cats` loads into pwsh (ADR-AUTO-ENGINE#6) — the repository's in a source run, the build's in a
build run — and `CATZC_REPOSITORY_ROOT` the repository root. `Invoke-BashTest` sets them for its bats run only and restores them afterwards
(ADR-AUTO-ENGINE#4). A Bash test runs under the bash engine only.

- [The engine start environment](#the-engine-start-environment)

### Rule ADR-AUTO-BASH:4

The test runner is bats-core, vendored at `<root>/.vendor/bats-core/` — its `bin/`, `libexec/`, `lib/` and licence, nothing else — and
pinned in `bash.yml` by release and the SHA-256 of its source archive. A test run uses the vendored copy and never installs or downloads a
runner; `Update-BatsVendor` rebuilds the copy from the pin. The vendored files are LF and carry the executable bit in git.

- [A vendored runner](#a-vendored-runner)

### Rule ADR-AUTO-BASH:5

`Test-Automation` runs the Bash tests through the language bridge the Go and Python tests run through (ADR-AUTO-GO#7, ADR-AUTO-PY#7):
discovery maps each Bash test folder to its catzc module, and the bridge turns every `@test` into one test of the run (ADR-AUTO-TEST#42),
tagged `L2` (ADR-AUTO-TEST#9) plus its category from its name. The bash engine is the Bash tests' tool: the run's source session locates it
once and hands its path to the bridge; without it, the bridge skips with `tool_bash_missing` (ADR-AUTO-TEST#8).

- [The bridge](#the-bridge)

### Rule ADR-AUTO-BASH:6

Every shell script the repository tracks — the `.bats` tests, `importer.sh`, every `*.sh`, and every `*.zsh` — takes the shell-script checks
of the `Test-ShellScripts` quality gate: LF line endings and the executable bit for a script with a shebang, then an analysis. A `*.sh`, a
`.bats` test, and `importer.sh` take ShellCheck at its `tools.yml` pin; a `*.zsh` takes `zsh -n`, zsh's own syntax check, at zsh's
`tools.yml` pin, in place of ShellCheck. The spelling check reads them too.

- [The checks](#the-checks)

## Context

The engine is verified from outside by tests in other languages ([go test artifacts](../go/go-test-artifacts.md),
[python test artifacts](../python/python-test-artifacts.md)), which start it as a process under each execution engine
([execution-engines](../execution-engines.md)). Those tests prove the engine runs; they do not prove what a Bash user sees. A Bash user
loads `importer.sh` and types `cats <command>`, and that path — the dispatcher's quoting, its root detection, its exit codes — needs tests
written the way the user writes commands: in Bash.

### Test artifacts only

Bash code in a test track exists only as tests. The engine is PowerShell and C# ([tracks](../../design/tracks.md#rule-adr-dsgn-track3)); a
Bash test verifies it from outside. Because the Bash root lies outside `automation/`, no Bash test reaches a bundle
([platform-bundle](../platform-bundle.md)).

### The layout

The Bash root follows the one convention every test language's root follows
([conventional-folders](../../repository/conventional-folders.md#rule-adr-repo-folders7)): `bash/` when present — the `bash` track, of the
verification class ([tracks](../../design/tracks.md#rule-adr-dsgn-track2)) — else `.bash/`. The default is declared once, on the
`BashConfig` type, and `BashConfig.ResolveRoot` is the one resolver every caller asks. Under the root, `tests/<module>/` holds one Bash test
folder per catzc module, named in kebab case, the convention shared with the Go and Python test folders.

A Bash test is declared on one line, `@test "<name>" {`, so the bridge reads it from the source without running bats. Its name is free text,
so the integrity marker is a prefix of the name, `integrity:`, decided in one place (the `BashTestResult` type).

### The engine start environment

A Go or Python test starts the engine with arguments the runner hands it. A Bash test does what a Bash user does instead: it loads the
engine's entry, `importer.sh`, and calls `cats`. The contract still comes from the runner, never from the test: `CATZC_ENGINE_ENTRY` is the
file to load, and `CATZC_IMPORTER` tells `cats` which PowerShell entry to load — the repository's `importer.ps1` in a source run, the
build's `Import-Catzc.ps1` in a build run — so the same test proves both run modes ([run-modes](../../design/run-modes.md)). A Bash test is
Bash, so it runs under the bash engine only; the Go and Python tests are the ones that run once per engine.

### A vendored runner

bats-core is a set of Bash scripts with no build step. Vendoring it, as the PowerShell modules under `automation/.vendor/` are vendored,
means a test run needs no installer, no network, and no admin on any platform: Git Bash on Windows runs it as it is. The pin and the archive
digest in `bash.yml` make the copy reproducible, and `Update-BatsVendor` is the one way it changes. Only the runner's own files are kept:
its tests, docs, and packaging are not the repository's.

Bash reads a carriage return as part of a command, and a Unix checkout runs a script only with its executable bit, so the vendored files are
pinned to LF by `.gitattributes` and carry `100755` in git.

### The bridge

A Bash test runs where every other test runs: in a `Test-Automation` test run, in both run modes, under the same selection, ordering,
protection, tiers, categories, and report ([test-automation](../test-automation.md)). The bridge runs `Invoke-BashTest` once per mapped
module — the vendored bats with a JUnit report, from the Bash root — and turns each `@test` into one test of the run, in pwsh a Pester `It`
([pester-testing](../../pwsh/pester-testing.md#rule-adr-pwsh-pester20)). Every Bash test starts a real engine through a real shell, so every
one is `L2`. The bash engine is located by its `tools.yml` entry ([execution-engines](../execution-engines.md#rule-adr-auto-engine3)) in the
run's source session and handed down, so a build run tests the build without carrying the tools config.

### The checks

Shell scripts fail in ways a reader does not see: a carriage return, a missing executable bit, an unquoted expansion. `Test-ShellScripts`
checks every tracked shell script for all three — the line endings, the bit for a script with a shebang, and an analysis — with ShellCheck
installed user-scope at its pin (`Install-Shellcheck`). Microsoft's vendored `dotnet-install.sh` is checked for line endings and its bit,
but not analysed: it is shipped as Microsoft writes it.

ShellCheck reads sh, bash, dash, and ksh, but not zsh, so a `*.zsh` script takes zsh's own check instead: `zsh -f -n` parses the file
without running it and without reading any startup file, and each error it reports is one issue. The check runs the zsh that its `tools.yml`
entry locates ([execution-engines](../execution-engines.md#rule-adr-auto-engine3)): the system's on Linux and macOS, and on Windows the
MSYS2 zsh package that `Install-Zsh` adds, user-space, to the Git Bash tree `Install-Git` provides. A parse check finds less than
ShellCheck's analysis, but it is the one zsh offers; bats runs Bash only, so zsh's behaviour is verified by the per-engine black-box runs
([execution-engines](../execution-engines.md#rule-adr-auto-engine4)), not here.

## Decision

Bash is a black-box test language for the path a Bash user takes and nothing else (ADR-AUTO-BASH#1). Its tests live in one Bash test folder
per catzc module under the Bash root (ADR-AUTO-BASH#2), call catzc through `importer.sh` and `cats` from the entry the run names
(ADR-AUTO-BASH#3), run on a vendored, pinned bats-core (ADR-AUTO-BASH#4) through `Test-Automation` as `L2` tests through the language bridge
(ADR-AUTO-BASH#5), and every shell script takes the shell-script checks (ADR-AUTO-BASH#6).

### How this is enforced

- **`BashConfig`** (`Catzc.Base.Languages`) validates `bash.yml` at load, requires the bats-core pin and digest, and declares the Bash
  root's defaults once (`ResolveRoot`).
- **`Invoke-BashTest`** runs the vendored bats under the bash engine, sets the engine contract for its run only, and returns one
  `BashTestResult` per test with its category.
- **`Update-BatsVendor`** (`Catzc.Tooling.Toolchain`) rebuilds the vendored copy from the pin, verifying the archive's digest.
- **The language bridge** in `Catzc.Base.QualityGates` (`Get-LanguageTestFolders`, `Get-BashTestCases`, `Language.Bridge.ps1`) maps each
  Bash test folder to its catzc module and tags each test.
- **`Test-ShellScripts`** checks every tracked shell script, with `zsh -n` for `*.zsh` and ShellCheck for the others, and
  **`.gitattributes`** pins the shell scripts and the vendored runner to LF.

## Consequences

- The path a Bash user takes — `importer.sh` and `cats` — is tested as that user takes it, in both run modes.
- A new Bash test folder is one folder with one `.bats` file: the next run discovers it.
- No Bash test reaches a user, and a test run needs no runner install.
- Each `cats` call imports catzc into a new pwsh, so a Bash test costs seconds per command; Bash tests suit the user's path, not
  fine-grained logic, which belongs in Pester.
