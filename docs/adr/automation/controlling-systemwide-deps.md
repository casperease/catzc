# ADR: Controlling system-wide dependencies

## Rules: ADR-SYSDEPS

### Rule ADR-SYSDEPS:1

Lock every tool version in `automation/Catzc.Tooling.Core/configs/tools.yml`. Pinned tools install an explicit, reviewable version; a small
allowlist of base tools (git, vscode) deliberately tracks `latest` and verifies integrity against the publisher's published hash.

- [1. Lock versions in configuration](#1-lock-versions-in-configuration)

### Rule ADR-SYSDEPS:2

Provide one `Install-*` / `Invoke-*` / `Uninstall-*` triad per tool. The installer handles platform differences, the invoker asserts version
and presence, the uninstaller cleans up.

- [2. Platform-aware installers](#2-platform-aware-installers)

### Rule ADR-SYSDEPS:3

Assert before every invocation. `Assert-Tool` runs `Assert-Command` and `Assert-ToolVersion` (presence and version only) before every
external tool call; it does not resolve `DependsOn`.

- [3. Assert at runtime](#3-assert-at-runtime)

### Rule ADR-SYSDEPS:4

Declare install-order dependencies in config. If a tool must be installed after another, add `DependsOn` to its `tools.yml` entry;
`Get-ToolInstallOrder` topologically sorts installs, and it is not a runtime assertion.

- [3b. Declare tool dependencies in config](#3b-declare-tool-dependencies-in-config)

### Rule ADR-SYSDEPS:5

CI and local share the same installers. No separate CI setup scripts — CI calls the same per-tool `Install-*` functions against the same
`tools.yml`, activating cached toolchains via native ADO version tasks first rather than running `Install-DevBoxTools`.

- [5. CI uses the same functions](#5-ci-uses-the-same-functions)

### Rule ADR-SYSDEPS:6

Do not assume tools are pre-installed. Even on CI runners with pre-installed tools, assert the version — runner images change without
notice.

- [3. Assert at runtime](#3-assert-at-runtime)

### Rule ADR-SYSDEPS:7

Two kinds of dependency, two names. A **system dependency** (`ADR-SYSDEPS`) is an external runtime or CLI the automation runs _against_ —
`pwsh`, Python, `dotnet`, the Azure CLI, git — installed at the OS level and covered by the Tooling layer (`tools.yml`, the `Install-*` /
`Invoke-*` triads). A **module dependency** (`ADR-MODDEPS`) is an edge in the internal graph among the repo's _own_ modules, the code we
_build_ — spanning both kinds of module content, `pwsh` functions and C# types — declared in `dependencies.yml`. The two codes carry the
split: `ADR-SYSDEPS` (SYS = system) and `ADR-MODDEPS` (MOD = module). This ADR governs `ADR-SYSDEPS`; `ADR-MODDEPS` has its own ADR,
[controlling-module-dependencies](controlling-module-dependencies.md).

- [System dependencies vs module dependencies](#system-dependencies-vs-module-dependencies)

## Context

Automation code depends on tools installed at the OS level — Python, dotnet, Poetry, Azure CLI, git. These are not PowerShell modules that
can be vendored into the repo. They are binaries managed by platform package managers (winget, brew, apt-get) and installed system-wide.

This creates the hardest reproducibility problem in automation: "works on my machine" caused by different tool versions, missing tools, or
tools installed in unexpected locations.

Containers solve this well — pin a base image, install tools at build time, and every execution is identical. When a container runtime is
available, that is the right approach.

But the platform must also work on machines where Docker is not available. The automation cannot require a container runtime as a
prerequisite.

### System dependencies vs module dependencies

"Dependency" means two different things in this repo, and the two carry distinct names so a reader never has to guess which is meant:

- A **system dependency** — code **`ADR-SYSDEPS`** (SYS = system) — is something the automation _runs against_: an external runtime or CLI
  installed at the OS level, such as `pwsh`, Python, `dotnet`, the Azure CLI, or git. These are not vendored into the repo; they are
  binaries the **Tooling** layer installs, version-locks, and asserts (`tools.yml`, `Get-ToolConfig`, the `Install-*` / `Invoke-*` /
  `Uninstall-*` triads). This ADR — and everything under `Catzc.Tooling.*` — is about `ADR-SYSDEPS`.
- A **module dependency** — code **`ADR-MODDEPS`** (MOD = module) — is an edge in the internal graph among the repo's _own_ modules, the
  code we _build_. It is a separate concern with its own ADR, [controlling-module-dependencies](controlling-module-dependencies.md)
  (`ADR-MODDEPS`); this ADR does not govern it.

The two are governed by opposite disciplines: a `ADR-SYSDEPS` is external and uncontrolled, so the rules below lock, assert, and never
assume it; a `ADR-MODDEPS` is internal and fully ours, so it is declared once and its layering is gated (see
[controlling-module-dependencies](controlling-module-dependencies.md)). Keeping the words distinct keeps the two from being conflated in
code, config, and prose.

### How we control system-wide dependencies

#### 1. Lock versions in configuration

Every tool has a locked version in `automation/Catzc.Tooling.Core/configs/tools.yml`:

```yaml
Python:
  Version: "3.11"
  Command: python
  WingetId: "Python.Python.{0}"
  WingetScope: user
  BrewFormula: "python@{0}"
  AptPackage: "python{0}"
  VersionCommand: "python --version"
  VersionPattern: "^Python (?<ver>.+)$"
```

The config is the source of truth. Functions read it via `Get-ToolConfig`. Version changes are pull requests, not ad-hoc installs.

The schema is intentionally heterogeneous: each tool carries only the install metadata its platforms need, so the installer shape varies per
tool:

- **winget / brew / apt tools** (e.g. `Python`, `NodeJs`, `Terraform`, `Java`) carry `WingetId`, `BrewFormula`, and/or `AptPackage`. Not
  every entry has all three — some platforms are intentionally omitted (e.g. `Terraform` has no `AptPackage` because its installer
  configures the HashiCorp apt repo inline).
- **pip tools** (e.g. `Poetry`, `AzCli`, `PySpark`) carry `PipPackage` plus a `DependsOn` naming the interpreter they install under
  (`Python` for Poetry/AzCli, `Java` for PySpark). On macOS `AzCli` instead uses `BrewFormula`.
- **script-install tools** (e.g. `Dotnet`) set `ScriptInstall: true` and use vendored install scripts with no package manager, plus
  install-dir fields like `WindowsInstallDir`.

All entries share `Version`, `Command`, `VersionCommand`, and `VersionPattern` — the fields used for version-locking and runtime assertion.

#### 2. Platform-aware installers

Each tool has an `Install-*` function that delegates to the platform's native package manager:

- **Windows:** winget
- **macOS:** brew
- **Linux:** apt-get

The installer is idempotent — if the tool is already installed, it returns immediately (see
[idempotent-state-functions](idempotent-state-functions.md#rule-adr-idem1)).

#### 3. Assert at runtime

Every `Invoke-*` wrapper asserts the tool is present and at the correct version before executing:

```powershell
Assert-Tool 'Python'   # is it on PATH? does the version match the lock?
```

`Assert-Tool` looks up the command name from config, calls `Assert-Command` to confirm the command is on PATH, then `Assert-ToolVersion` to
confirm the version matches the lock. It asserts presence and version only — it does **not** resolve `DependsOn`. `DependsOn` is an
install-time concern (see #3b), not a runtime requirement, so a runtime assertion never re-checks a tool's dependencies. If the tool is
missing or at the wrong version, the error says so directly ("Python is not installed (python not found on PATH). Run Install-Python.").

Version checks are cached per session — the first `Invoke-Python` call validates, subsequent calls skip the check.

#### 3c. Devbox version lever (local-only relaxation)

`Assert-ToolVersion` accepts the locked `version` everywhere. A tool may also declare an optional `devbox_version` in `tools.yml`:
**outside** a CI pipeline (`Test-IsRunningInPipeline` is false), an installed version matching **either** the locked `version` or the
`devbox_version` prefix passes the assertion. This lets a devbox run a functional off-pin tool for local pre-commit tooling without an
immediate upgrade — a team-tuned balancing lever, not a second pin. A pipeline session ignores `devbox_version` and enforces the locked
`version` alone, so main/master builds stay deterministically locked: a developer's own tooling can be relaxed, but it never relaxes the
pipeline's.

#### 3b. Declare tool dependencies in config

Some tools must be installed after another tool — Poetry and Azure CLI are installed via pip, so Python must already be present; PySpark is
installed via pip but depends on Java. These dependencies are declared in `tools.yml`:

```yaml
Poetry:
  DependsOn: Python
  PipPackage: poetry
```

`DependsOn` governs **install ordering**, not runtime assertion. `Get-ToolInstallOrder` reads every `DependsOn` and topologically sorts the
tools so each dependency installs before the tools that need it (it throws on a circular dependency). At install time, `Install-PipTool`
also calls `Assert-Tool 'Python'` to confirm the interpreter is present before running pip. Pip-based tools share install and uninstall
logic through `Install-PipTool` and `Uninstall-PipTool`, which parallel `Install-Tool` and `Uninstall-Tool` for platform package managers.

#### 4. Orchestrate with Install-DevBoxTools

A single function provisions the entire local development environment:

```powershell
function Install-DevBoxTools {
    Install-Python
    Install-Poetry
    Install-Dotnet
    # ... more tools
}
```

This is idempotent. Run it after every pull, on every new workstation, or on a schedule. It converges the environment to the desired state
defined in config.

#### 5. CI uses the same functions

CI calls the same per-tool `Install-*` functions that developers use locally, against the same `tools.yml`. There is no separate "CI setup
script" that reimplements installs — same config, same installers, same assertions.

CI does **not** run the `Install-DevBoxTools` orchestrator. Hosted agents already ship cached toolchains, so the tool-installation job first
activates the locked versions of Python, .NET, and Node via the native ADO tasks (`UsePythonVersion`, `UseDotNet`, `UseNode`) to put the
right version on PATH, then calls the individual `Install-*` functions for the remaining tools in dependency order (`Install-AzCli`,
`Install-Poetry`, `Install-Terraform`, `Install-Java`, `Install-PySpark`). The pip-based installers reuse the same `Install-PipTool` path as
local runs.

```yaml
# native task activates the locked version, then our installer asserts/installs
- task: UsePythonVersion@0
  inputs:
    versionSpec: "3.11"
- template: /pipelines/steps/invoke-automation.yaml
  parameters:
    RunCommand: "Install-AzCli -Force" # pip, depends on Python
```

## Decision

System-wide tool dependencies are version-locked in configuration, installed via platform-native package managers, and asserted at runtime
before every use. The platform works without a container runtime on Windows, macOS, and Linux.

## Consequences

- Tool versions are consistent across CI environments and, by default, developer machines; an optional per-tool `devbox_version` lever can
  locally widen the accepted range for pre-commit tooling, while pipelines stay locked to the pinned version (see #3c).
- Version upgrades are pull requests with a one-line config change.
- New developers run `Install-DevBoxTools` once and have a working environment.
- CI pipelines are self-provisioning — they do not depend on runner image contents.
- The platform works on bare metal, VMs, workstations, and CI runners without requiring Docker.
