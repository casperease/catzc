# Getting started with the automation system

A PowerShell 7.4+ module system for this monorepo. **Drop a file, get a function** — no manifests, no installers, no registration.
Dot-source one script and every function from every module is available.

This guide gets you productive: how to load the system, how to use it in a script and in CI, and a task index pointing at short how-to
articles for the things you will actually do (add a function, add a module, add a C# type, add an infrastructure template, debug in VS Code,
and so on).

The _why_ behind every rule here lives in the [architecture decision records](../../../adr/README.md). This guide is the _how_.

---

## Quick start

From the repository root:

| Context              | Command                            | What it does                                                    |
| -------------------- | ---------------------------------- | --------------------------------------------------------------- |
| Interactive terminal | `.\importer.ps1`                   | Loads everything; sets up the error-diagnostics prompt hook     |
| Inside a script      | `. ./importer.ps1`                 | Dot-sources so the functions land in the script's scope         |
| Debugging            | `. ./importer.ps1 -ExportPrivates` | Also exports `private/` functions so you can call them directly |

After import, every public function from every module is available. Load time is roughly half a second on a warm checkout. The importer also
accepts `-AllowWarnings` (don't make warnings fatal), `-DiagnoseLoadTime` (print a per-stage load breakdown), and `-ClearCompiledTypes`
(rebuild the C# type assembly from source).

> The importer is **dot-sourced** (`. ./importer.ps1`). It runs in your scope so its global state — the prompt hook, `$env:RepositoryRoot`,
> error preferences — takes effect. Re-run it after changing files on disk: the importer invocation is the boundary at which the session's
> view of the repository is fixed (see [caching](../../../adr/automation/caching.md)).

---

## Using it in a script

```powershell
#!/usr/bin/env pwsh
. ./importer.ps1
trap { Write-Exception $_; break }

# Every function from every module is available here.
Assert-Command git
Write-Message 'Ready to go'
```

Dot-source the importer, add the `trap` line for an automatic stack trace on any unhandled error, then write your logic. Nothing else to set
up.

## Using it in CI/CD

Pipeline steps invoke automation through the runner, never inline PowerShell (see
[pipeline-runner-pattern](../../../adr/pipelines/pipeline-runner-pattern.md)):

```yaml
steps:
  - template: /pipelines/steps/invoke-automation.yaml
    parameters:
      RunCommand: "Invoke-MyFunction"
```

- Runs identically on Windows, Linux, and macOS — CI covers all three.
- No install step: every dependency is vendored under `automation/.vendor/`.
- `$ErrorActionPreference = 'Stop'` is set globally, so an error becomes a non-zero exit code automatically.
- No network calls at import time — safe behind corporate proxies and in air-gapped environments.

---

## Error handling in one minute

The importer sets both `$ErrorActionPreference` and `$WarningPreference` to `Stop`. There are exactly two states: everything is fine
(execution continues), or something is wrong (execution stops). No warnings, no "succeeded with warnings", no middle ground (see
[error-handling](../../../adr/automation/powershell/error-handling.md)).

- **Interactive sessions** get a prompt hook that prints a full stack trace after any failed command.
- **Scripts** add `trap { Write-Exception $_; break }` right after the importer line for the same effect.
- Use **`throw`**, never `Write-Error`; use `Write-Message`/`Write-Verbose` for information, never `Write-Warning`.
- Guard preconditions with the **`Assert-*`** library — each throws a self-contained message naming the exact assumption that failed:

```powershell
Assert-Command terraform
Assert-PathExist $configPath
Assert-NotNullOrWhitespace $subscriptionId -ErrorText 'No subscription ID configured'
```

---

## Project layout

```text
importer.ps1                       entry point (dot-source this)
automation/
  .internal/                       shared loader + bootstrap modules — generate manifests, load types, then unload
  .scriptanalyzer/                 custom PSScriptAnalyzer rules
  .vendor/                         third-party modules (checked in, no network)
  .compiled/                       committed, hash-keyed C# type assembly
  <Module>/                        a module = a non-dot folder
    Verb-Noun.ps1                  public function (one function per file)
    private/Verb-Noun.ps1          private helper (shared module scope, not exported)
    types/Type.cs                  C# source autoloaded as a .NET type (filename = type name)
    configs/<name>.yml             the module's own config, read via Get-Config
    assets/                        templates, scripts, schemas the module ships
    tests/Verb-Noun.Tests.ps1      Pester tests (one file per function)
infrastructure/
  modules/                         reusable Bicep modules
  templates/<name>/                deployable Bicep templates
docs/
  adr/                             architecture decision records (the "why")
  how-to/                          getting-started guides + how-to articles (this guide)
pipelines/                         Azure DevOps YAML + the runner
out/                               all generated output (gitignored)
```

The folder structure is a contract — tooling hardcodes these names. See
[conventional-folders](../../../adr/repository/conventional-folders.md).

---

## The conventions that matter

| Rule                            | Detail                                                                     |
| ------------------------------- | -------------------------------------------------------------------------- |
| One function per file           | `Verb-Noun.ps1` contains exactly `function Verb-Noun`                      |
| Folder = module                 | Each non-dot directory under `automation/` is a module                     |
| Public by location              | `.ps1` at the module root is exported; `.ps1` in `private/` is loaded, not |
| Dot-prefix = infrastructure     | `.internal/`, `.vendor/`, `.scriptanalyzer/`, `.compiled/` are not modules |
| Approved verbs only             | Use a verb from `Get-Verb`; plural noun for a collection, singular for one |
| Assert your assumptions         | Roughly every fifth line is an `Assert-*`; throw on failure, never warn    |
| No trailing semicolons          | Statements end at the newline (enforced by PSScriptAnalyzer)               |
| `foreach`, not `ForEach-Object` | …whenever the body has control flow (`if`/`return`/`break`/`continue`)     |
| snake_case in YAML              | Config keys use `snake_case` (enforced by `Assert-YmlNaming`)              |

These are enforced mechanically (PSScriptAnalyzer rules, convention tests in `Test-Automation`), not by review alone.

---

## How do I…? (task guide)

Short, focused how-to articles for the common jobs:

| I want to…                                | Article                                                             |
| ----------------------------------------- | ------------------------------------------------------------------- |
| Add a public function to a module         | [Add a function](powershell/add-a-function.md)                      |
| Create a brand-new module                 | [Add a module](add-a-module.md)                                     |
| Add a native .NET type backed by C#       | [Add a C# type](BCL/add-a-dotnet-type.md)                           |
| Add a deployable Bicep template           | [Add an infrastructure template](add-an-infrastructure-template.md) |
| Define a deployable unit + trigger file   | [Add a deployable unit](add-a-deployable-unit.md)                   |
| Run the tests, linters, and formatters    | [Run tests and checks](run-tests-and-checks.md)                     |
| Set breakpoints and debug module code     | [Debug in VS Code](debug-in-vscode.md)                              |
| Add or upgrade a CLI tool (az, dotnet, …) | [Add a CLI tool](add-a-cli-tool.md)                                 |
| Vendor a third-party PowerShell module    | [Vendor a module](vendor-a-module.md)                               |
| Write a new doc chapter or ADR            | [Add a doc chapter](add-a-doc-chapter.md)                           |

Looking for what a specific module does rather than how to do a task? See the [module reference](../../../references/automation/index.md).

---

## How it works (the 30-second version)

1. `importer.ps1` sets error preferences, loads the bootstrap module, and points `$env:PSModulePath` at the vendored copies (stripping
   network paths so startup stays fast).
2. Vendored modules in `.vendor/` load first; Pester and PSScriptAnalyzer are lazy-loaded so they don't tax startup.
3. The bootstrap module compiles every module's `types/*.cs` into one assembly, then scans each module folder, generates a `.psd1` manifest
   from the filenames, and imports it globally. A duplicate function name fails the import loudly.
4. The bootstrap module unloads itself — it has served its purpose.
5. Interactive sessions get the prompt hook (automatic error diagnostics) and a load-time report.

The filesystem is the single source of truth. There are no hand-maintained manifests, export lists, or registration steps — which is exactly
why "drop a file, get a function" works. For the reasoning, start with
[zero-ceremony, hard to fail](../../../adr/automation/zero-ceremony-poka-yoke.md) and the [FAQ](../../../faq.md).
