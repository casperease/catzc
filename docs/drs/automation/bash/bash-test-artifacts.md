# Automation: Bash modules and test artifacts — modules by layout, black-box tests of the engine through cats, run by a vendored bats

## Rules: ADR-AUTO-BASH

### Rule ADR-AUTO-BASH-BASHTESTFOLDER

The Bash root is `bash` when the repository has a `bash/` folder (the `bash` track), else `.bash`, declared by `bash.yml`'s `root`
(ADR-AUTO-TESTLANG-ONEROOT). A **Bash test folder** is the folder `<root>/tests/<module>/`, named for its catzc module in kebab case,
holding that module's `.bats` files, which call catzc through `importer.sh` and `cats`. A Bash test is one `@test "<name>" {` line; a name
starting with `integrity:` makes it `integrity`, every other test `logic`.

- [The layout](#the-layout)

### Rule ADR-AUTO-BASH-VENDOREDBATS

The test runner is bats-core, vendored at `<root>/.vendor/bats-core/` — its `bin/`, `libexec/`, `lib/` and licence, nothing else — and
pinned in `bash.yml` by release and the SHA-256 of its source archive. A test run uses the vendored copy and never installs or downloads a
runner; `Update-BatsVendor` rebuilds the copy from the pin. The vendored files are LF and carry the executable bit in git.

- [A vendored runner](#a-vendored-runner)

### Rule ADR-AUTO-BASH-SHELLSCRIPTSCHECKED

Every shell script the repository tracks — the `.bats` tests, `importer.sh`, every `*.sh`, and every `*.zsh` — takes the shell-script checks
of the `Test-ShellScripts` quality gate: LF line endings and the executable bit for a script with a shebang, then an analysis. A `*.sh`, a
`.bats` test, and `importer.sh` take ShellCheck at its `tools.yml` pin; a `*.zsh` takes `zsh -n`, zsh's own syntax check, at zsh's
`tools.yml` pin, in place of ShellCheck. The spelling check reads them too.

- [The checks](#the-checks)

## Context

Bash is a test-artifact language: its modules exist by the layout, its tests prove the engine from outside, and the test run reaches them
through the one bridge ([test-artifact-languages](../test-artifact-languages.md)). A test that starts the engine as a process under each
execution engine ([execution-engines](../execution-engines.md)) proves the engine runs; it does not prove what a Bash user sees. A Bash user
loads `importer.sh` and types `cats <command>`, and that path — the dispatcher's quoting, its root detection, its exit codes — needs tests
written the way the user writes commands: in Bash. This record holds Bash's spellings of the shared decision and what is Bash's own: the
vendored runner and the shell-script checks.

### Modules by layout

The tests of the engine sit in the track's own holder
([test-artifact-languages](../test-artifact-languages.md#rule-adr-auto-testlang-modulesbylayout)), `.bats` files that verify the engine the
way a Bash user reaches it. The repository's other shell scripts (`importer.sh`, the vendored installers under `assets/scripts/`) are not
tests; they take the shell-script checks (ADR-AUTO-BASH-SHELLSCRIPTSCHECKED).

### The layout

The Bash root follows the one convention every test-artifact language's root follows
([test-artifact-languages](../test-artifact-languages.md#rule-adr-auto-testlang-oneroot)): `bash/` when present, the `bash` track, else
`.bash/`, declared once on the `BashConfig` type, whose `ResolveRoot` every caller asks. Under it, a Bash test folder's name is the module's
repository normal form in Bash's folder case, kebab ([idiomatic-names](../idiomatic-names.md#rule-adr-auto-idiom-testfolderbyidiom)).

A Bash test is declared on one line, `@test "<name>" {`, so the bridge reads it from the source without running bats. Its name is free text,
so the integrity marker is a prefix of the name, `integrity:`, decided in one place (the `BashTestResult` type).

### The engine start environment

A Bash test is a black-box test ([test-artifact-languages](../test-artifact-languages.md#rule-adr-auto-testlang-blackbox)) that loads the
language's own entry instead of starting the engine with start arguments: its `setup` loads `CATZC_ENGINE_ENTRY`, the repository's
`importer.sh`, and the test runs catzc commands through the `cats` dispatcher. `CATZC_IMPORTER` names the entry `cats` loads into pwsh
([execution-engines](../execution-engines.md#rule-adr-auto-engine-importerentry)), the repository's `importer.ps1` in a source run and the
build's `Import-Catzc.ps1` in a build run, and `CATZC_REPOSITORY_ROOT` names the repository root. `Invoke-BashTest` sets the variables for
its bats run only and restores them afterwards. A Bash test is Bash, so it runs under the bash engine only.

### A vendored runner

bats-core is a set of Bash scripts with no build step. Vendoring it, as the PowerShell modules under `pwsh/.vendor/` are vendored, means a
test run needs no installer, no network, and no admin on any platform: Git Bash on Windows runs it as it is. The pin and the archive digest
in `bash.yml` make the copy reproducible, and `Update-BatsVendor` is the one way it changes. Only the runner's own files are kept: its
tests, docs, and packaging are not the repository's.

Bash reads a carriage return as part of a command, and a Unix checkout runs a script only with its executable bit, so the vendored files are
pinned to LF by `.gitattributes` and carry `100755` in git.

### The bridge

The Bash tests run through the one bridge ([test-artifact-languages](../test-artifact-languages.md#rule-adr-auto-testlang-bridge)), in a
`Test-Automation` test run ([test-automation](../test-automation.md)). The bridge runs `Invoke-BashTest` once per mapped module — the
vendored bats with a JUnit report, from the Bash root — and in pwsh each `@test` is a Pester `It`, tagged `L2`. The `BashTestResult` type
decides the category. The bash engine is the Bash tests' tool: it is located by its `tools.yml` entry
([execution-engines](../execution-engines.md#rule-adr-auto-engine-locateexecutable)) in the run's source session and handed down; without
it, every Bash test skips with `tool_bash_missing`.

### The checks

Shell scripts fail in ways a reader does not see: a carriage return, a missing executable bit, an unquoted expansion. `Test-ShellScripts`
checks every tracked shell script for all three — the line endings, the bit for a script with a shebang, and an analysis — with ShellCheck
installed user-scope at its pin (`Install-Shellcheck`). Microsoft's vendored `dotnet-install.sh` is checked for line endings and its bit,
but not analysed: it is shipped as Microsoft writes it.

ShellCheck reads sh, bash, dash, and ksh, but not zsh, so a `*.zsh` script takes zsh's own check instead: `zsh -f -n` parses the file
without running it and without reading any startup file, and each error it reports is one issue. The check runs the zsh that its `tools.yml`
entry locates ([execution-engines](../execution-engines.md#rule-adr-auto-engine-locateexecutable)): the system's on Linux and macOS, and on
Windows the MSYS2 zsh package that `Install-Zsh` adds, user-space, to the Git Bash tree `Install-Git` provides. A parse check finds less
than ShellCheck's analysis, but it is the one zsh offers; bats runs Bash only, so zsh's behaviour is verified by the per-engine black-box
runs ([execution-engines](../execution-engines.md#rule-adr-auto-engine-startenvironment)), not here.

## Decision

Bash is a language track whose modules exist by the layout and ship only what is packaged, and the black-box test language for the path a
Bash user takes (ADR-AUTO-TESTLANG-MODULESBYLAYOUT). Its tests of the engine live in one Bash test folder per catzc module under the Bash
root (ADR-AUTO-TESTLANG-ONEROOT, ADR-AUTO-BASH-BASHTESTFOLDER), call catzc through `importer.sh` and `cats` from the entry the run names
(ADR-AUTO-TESTLANG-BLACKBOX), run on a vendored, pinned bats-core (ADR-AUTO-BASH-VENDOREDBATS) through `Test-Automation` as `L2` tests
through the one bridge (ADR-AUTO-TESTLANG-BRIDGE), and every shell script takes the shell-script checks (ADR-AUTO-BASH-SHELLSCRIPTSCHECKED).

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
