---
catzc:
  derived:
    path: docs/adr/automation/controlling-systemwide-deps.md
    kind: adr
    language: markdown
    track: docs
    body_sha: f306aec32d72
    defines:
      - ADR-AUTO-DEPS#{1-8}
    adrs:
      - ADR-AUTO-PARITY#1
    links:
      - docs/adr/automation/controlling-module-dependencies.md
      - docs/adr/automation/devbox-pipeline-parity.md#rule-adr-auto-parity1
      - docs/adr/automation/idempotent-state-functions.md#rule-adr-auto-idem1
      - docs/adr/automation/tool-removal-lifecycle.md
      - docs/adr/automation/uv-python-handler.md
---

# ADR: Controlling system-wide dependencies

## Rules: ADR-AUTO-DEPS

### Rule ADR-AUTO-DEPS:1

Lock every tool version in `automation/Catzc.Base.Execution/configs/tools.yml`. Pinned tools install an explicit, reviewable version; a
small allowlist of base tools (git, vscode) deliberately tracks `latest` and verifies integrity against the publisher's published hash.

- [1. Lock versions in configuration](#1-lock-versions-in-configuration)

### Rule ADR-AUTO-DEPS:2

Provide one `Install-*` / `Invoke-*` / `Uninstall-*` triad per tool. The installer handles platform differences, the invoker asserts version
and presence, the uninstaller cleans up. A platform-provided prerequisite is the exception (Rule ADR-AUTO-DEPS#8): it is asserted, never
installed by its own entry, so it has no triad.

- [2. Platform-aware installers](#2-platform-aware-installers)

### Rule ADR-AUTO-DEPS:3

Assert before every invocation. `Assert-Tool` runs `Assert-Command` and `Assert-ToolVersion` (presence and version only) before every
external tool call — or, for a tool whose entry declares candidate paths, the fast, timed existence check (`Resolve-ToolExecutable`), which
probes those paths and PATH before starting any process; it does not resolve `depends_on`.

- [3. Assert at runtime](#3-assert-at-runtime)

### Rule ADR-AUTO-DEPS:4

Declare install-order dependencies in config. If a tool must be installed after another, add `depends_on` to its `tools.yml` entry;
`Get-ToolInstallOrder` topologically sorts installs, and it is not a runtime assertion.

- [3b. Tool dependencies in config](#3b-tool-dependencies-in-config)

### Rule ADR-AUTO-DEPS:5

CI provisions tools with the same per-tool `Install-*` functions against the same `tools.yml` — the installer side of the one code path
([ADR-AUTO-PARITY#1](devbox-pipeline-parity.md#rule-adr-auto-parity1)), with no separate CI setup script. It activates the agent's cached
toolchains through native ADO version tasks first, and calls the per-tool functions rather than the `Install-DevBoxTools` orchestrator.

- [5. CI uses the same functions](#5-ci-uses-the-same-functions)

### Rule ADR-AUTO-DEPS:6

Do not assume tools are pre-installed. Even on CI runners with pre-installed tools, assert the version — runner images change without
notice.

- [3. Assert at runtime](#3-assert-at-runtime)

### Rule ADR-AUTO-DEPS:7

Two kinds of dependency, two names. A **system dependency** (`ADR-AUTO-DEPS`) is an external runtime or CLI the automation runs _against_ —
`pwsh`, Python, `dotnet`, the Azure CLI, git — installed at the OS level and covered by the Tooling layer (`tools.yml`, the `Install-*` /
`Invoke-*` triads). A **module dependency** (`ADR-AUTO-DEPM`) is an edge in the internal graph among the repo's _own_ modules, the code we
_build_ — spanning both kinds of module content, `pwsh` functions and C# types — declared in `dependencies.yml`. The two codes carry the
split: `ADR-AUTO-DEPS` (SYS = system) and `ADR-AUTO-DEPM` (MOD = module). This ADR governs `ADR-AUTO-DEPS`; `ADR-AUTO-DEPM` has its own ADR,
[controlling-module-dependencies](controlling-module-dependencies.md).

- [System vs module dependencies](#system-vs-module-dependencies)

### Rule ADR-AUTO-DEPS:8

A platform-provided prerequisite is asserted, never installed by its own entry. "Provided by the platform" means the operating system —
winget (the Windows App Installer), `/bin/bash` on Linux — or a base tool the devbox installs unpinned: git, and Git Bash with it, which is
`bash` on Windows. Such a tool carries `system_provided: true`: the toolchain asserts it is present (keeping it on PATH through
`session_path_hints` where it declares them), but its entry has no `Install-*` / `Uninstall-*` triad. `windows_only: true` marks a tool that
exists only on Windows, skipped by the provisioning and status loops on other platforms. Tools that install through one declare `depends_on`
on it (`depends_on: winget`), so `Get-ToolInstallOrder` orders it first and a missing prerequisite fails fast.

- [3d. Platform-provided prerequisites](#3d-platform-provided-prerequisites)

## Context

Automation code depends on tools installed at the OS level — Python, dotnet, Poetry, Azure CLI, git. These are not PowerShell modules that
can be vendored into the repo. They are binaries managed by platform package managers (winget, brew, apt-get) and installed system-wide.

This creates the hardest reproducibility problem in automation: "works on my machine" caused by different tool versions, missing tools, or
tools installed in unexpected locations.

Containers solve this well — pin a base image, install tools at build time, and every execution is identical. When a container runtime is
available, that is the right approach.

But the platform must also work on machines where Docker is not available. The automation cannot require a container runtime as a
prerequisite.

### System vs module dependencies

`System dependencies vs module dependencies`

"Dependency" means two different things in this repo, and the two carry distinct names so a reader never has to guess which is meant:

- A **system dependency** — code **`ADR-AUTO-DEPS`** (SYS = system) — is something the automation _runs against_: an external runtime or CLI
  installed at the OS level, such as `pwsh`, Python, `dotnet`, the Azure CLI, or git. These are not vendored into the repo; they are
  binaries the **Tooling** layer installs, version-locks, and asserts (`tools.yml`, `Get-ToolConfig`, the `Install-*` / `Invoke-*` /
  `Uninstall-*` triads). This ADR — and everything under `Catzc.Tooling.*` — is about `ADR-AUTO-DEPS`.
- A **module dependency** — code **`ADR-AUTO-DEPM`** (MOD = module) — is an edge in the internal graph among the repo's _own_ modules, the
  code we _build_. It is a separate concern with its own ADR, [controlling-module-dependencies](controlling-module-dependencies.md)
  (`ADR-AUTO-DEPM`); this ADR does not govern it.

The two are governed by opposite disciplines: a `ADR-AUTO-DEPS` is external and uncontrolled, so the rules below lock, assert, and never
assume it; a `ADR-AUTO-DEPM` is internal and fully ours, so it is declared once and its layering is checked (see
[controlling-module-dependencies](controlling-module-dependencies.md)). Keeping the words distinct keeps the two from being conflated in
code, config, and prose.

### Controlling them

`How we control system-wide dependencies`

#### 1. Lock versions in configuration

Every tool has a locked version in `automation/Catzc.Base.Execution/configs/tools.yml`:

```yaml
node_js:
  version: "24"
  command: node
  depends_on: winget
  winget_id: "OpenJS.NodeJS.LTS"
  winget_scope: user
  brew_formula: "node@{0}"
  apt_package: "nodejs"
  version_command: "node --version"
  version_pattern: "^v(?<ver>.+)$"
```

The config is the source of truth. Functions read it via `Get-ToolConfig`. Version changes are pull requests, not ad-hoc installs.

The schema is intentionally heterogeneous: each tool carries only the install metadata its platforms need, so the installer shape varies per
tool:

- **winget / brew / apt tools** (e.g. `node_js`, `terraform`, `java`) carry `winget_id`, `brew_formula`, and/or `apt_package`. Not every
  entry has all three — some platforms are intentionally omitted (e.g. `terraform` has no `apt_package` because its installer configures the
  HashiCorp apt repo inline).
- **script-install tools** (e.g. `dotnet`) set `script_install: true` and use vendored install scripts with no package manager, plus
  install-dir fields like `windows_install_dir`.
- **uv-managed Python family** — Python itself and the CLIs written in Python (the Azure CLI, Poetry, PySpark) install user-space through
  uv, keyed by `uv_python` / `uv_tool` / `pip_package`; see [uv-python-handler](uv-python-handler.md) (`ADR-AUTO-UVPY`).
- **platform-provided prerequisites** (`winget`, `bash`) set `system_provided: true` — asserted, never installed by their own entry (Rule
  ADR-AUTO-DEPS#8).

All entries share `version`, `command`, `version_command`, and `version_pattern` — the fields used for version-locking and runtime
assertion.

#### 2. Platform-aware installers

Each tool has an `Install-*` function that delegates to the platform's native package manager:

- **Windows:** winget
- **macOS:** brew
- **Linux:** apt-get

The Python family is the exception: Python and the CLIs written in it install user-space through uv on every platform rather than the native
manager — see [uv-python-handler](uv-python-handler.md) (`ADR-AUTO-UVPY`).

The installer is idempotent — if the tool is already installed, it returns immediately (see
[idempotent-state-functions](idempotent-state-functions.md#rule-adr-auto-idem1)).

#### 3. Assert at runtime

Every `Invoke-*` wrapper asserts the tool is present and at the correct version before executing:

```powershell
Assert-Tool 'python'   # is it on PATH? does the version match the lock?
```

`Assert-Tool` looks up the command name from config, calls `Assert-Command` to confirm the command is on PATH, then `Assert-ToolVersion` to
confirm the version matches the lock. It asserts presence and version only — it does **not** resolve `depends_on`. `depends_on` is an
install-time concern (see #3b), not a runtime requirement, so a runtime assertion never re-checks a tool's dependencies. If the tool is
missing or at the wrong version, the error says so directly ("python is not installed (python not found on PATH). Run Install-Python.").

Version checks are cached per session — the first `Invoke-Python` call validates, subsequent calls skip the check.

A tool whose entry declares candidate paths is located by the existence check instead of by its bare name on PATH: `Resolve-ToolExecutable`
reads the entry and hands its inputs to `Find-Executable` (both in `Catzc.Base.Execution`, so a module below the Tooling layer locates a
tool the same way). The check is fast first: it probes the candidate paths, then PATH, with file checks only and no process start. Only a
located executable is run, once, to confirm its version, and that result is cached for the session per executable, so a reinstall or an
upgrade is seen on the next call. Both steps are timed, and the record — tool, found, path, method, version, required, `ProbeMs`,
`VersionMs`, and the session actor — is what `Test-Tool -PassThru` returns and `Write-ToolProbeReport` prints. The candidates are declared
once per tool in `tools.yml`, as separate lists for a devbox and a pipeline on each platform: a devbox prefers a user-scope install (for
`bash` on Windows, a user-scope Git for Windows before the machine-wide one), a pipeline reads the hosted agent's locations, and
`probe_excludes` names paths that never count — the WSL launcher, which answers to `bash` on Windows but is not Bash. A caller that must run
the managed executable runs it by the path the check returns, never by its bare name.

#### 3c. Devbox version lever

`3c. Devbox version lever (local-only relaxation)`

`Assert-ToolVersion` accepts the locked `version` everywhere. A tool may also declare an optional `devbox_version` in `tools.yml`:
**outside** a CI pipeline (`Test-IsRunningInPipeline` is false), an installed version matching **either** the locked `version` or the
`devbox_version` prefix passes the assertion. This lets a devbox run a functional off-pin tool for local pre-commit tooling without an
immediate upgrade — a team-tuned balancing lever, not a second pin. A pipeline session ignores `devbox_version` and enforces the locked
`version` alone, so main/master builds stay deterministically locked: a developer's own tooling can be relaxed, but it never relaxes the
pipeline's.

#### 3b. Tool dependencies in config

`3b. Declare tool dependencies in config`

Some tools must be installed after another — the Azure CLI and Poetry install as isolated uv tools, so `uv` must be present; PySpark
installs into the uv-managed Python, so `python` must be present; the winget tools need `winget`. These dependencies are declared in
`tools.yml`:

```yaml
poetry:
  depends_on: uv
  uv_tool: poetry
```

`depends_on` governs **install ordering**, not runtime assertion. `Get-ToolInstallOrder` reads every `depends_on` and topologically sorts
the tools so each dependency installs before the tools that need it (it throws on a circular dependency). The isolated `uv tool` installs
share `Install-UvTool` / `Uninstall-UvTool`; a library installed into the interpreter (`uv pip install --system`, e.g. PySpark) uses
`Install-PipTool` / `Uninstall-PipTool` — both run through `Invoke-Uv`, which asserts `uv` is present, and both parallel `Install-Tool` /
`Uninstall-Tool` for platform package managers.

#### 3d. Platform-provided prerequisites

Some tools the toolchain never installs through their own entry — the platform provides them, and the toolchain only asserts and locates
them. The platform is the operating system, or a base tool the devbox installs unpinned. winget (the Windows App Installer) is the first
kind: it is the platform package manager the winget-based installs run against, so it cannot itself be a winget install. `bash` is both
kinds: Linux ships it as `/bin/bash`, and on Windows it is Git Bash, which arrives with git — a base tool `Install-Git` installs at its
latest release (Rule ADR-AUTO-DEPS#1), user-space on Windows. A second installer for Git Bash would be a second owner of git. Such a tool is
declared with `system_provided: true` (and `windows_only: true` for winget, which exists only on Windows). It is a prerequisite, not a
target:

- `Install-DevBoxTools` **asserts** it is present — with a clear message naming its remedy when it is missing (App Installer from the
  Microsoft Store for winget, `Install-Git` for Git Bash) — rather than installing it, and its entry has no `Install-*` / `Uninstall-*`
  triad.
- `Get-ToolsStatus` reports its manager as `system`, and the session janitor never flags it as foreign.
- It stays resolvable: winget by `session_path_hints`, which the janitor re-adds to PATH on every load, so a dropped
  `%LOCALAPPDATA%\Microsoft\WindowsApps` self-heals without a manual fix; `bash` by its candidate paths, through the existence check (#3),
  so a PATH that leads to the WSL launcher never answers for it.

The winget-based tools (`node_js`, `java`, `terraform`, and uv's fresh bootstrap) declare `depends_on: winget`, so it is ordered and
asserted before anything that needs it.

#### 3e. The best install home

`3e. The session runs the best install home`

A tool can be installed more than once on one machine, and the first one on PATH is not always usable. On Windows the machine PATH always
precedes the user PATH, so a machine-wide install of the same command, such as a runtime-only `C:\Program Files\dotnet` with no SDK,
resolves first and shadows the managed SDK. A tool that can be shadowed this way declares `session_host_probes` in `tools.yml`. These are
ordered folder patterns that end in `{version}`, and each one marks what makes a home usable. For dotnet the list is an SDK at the locked
version (`sdk/{version}`), and failing that a runtime at the locked version (`shared/Microsoft.NETCore.App/{version}`).

The session janitor `Sync-SessionTools` applies them through `Resolve-SessionToolHost`. It looks at the candidate homes in order: the
installer layer's own home first, then the folder of every PATH match. It takes the first probe that any home satisfies, so an SDK is loaded
first if one is there, and a runtime at the proper version is the fallback. It moves that home to the front of the session's PATH, so every
command the session and its child processes run uses it. The move is a state change of the session, so it is announced on the information
stream. The check uses the filesystem only and starts no process. When no home satisfies any probe, PATH is left exactly as it was. The
other installs are left in place — the toolchain prefers its own, it does not evict anyone else's; evicting an off-config install stays the
explicit `Remove-<Tool> -Force` decision ([tool-removal-lifecycle](tool-removal-lifecycle.md)). Like every janitor action this is
session-only, never writes the registry, and is a no-op in CI, where the pipeline activates the locked version natively (`UseDotNet`).

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
`Install-Poetry`, `Install-Terraform`, `Install-Java`, `Install-PySpark`). The Python-family installers run through uv — the same path as
local runs.

```yaml
# native task activates the locked version, then our installer asserts/installs
- task: UsePythonVersion@0
  inputs:
    versionSpec: "3.13"
- template: /pipelines/steps/invoke-automation.yaml
  parameters:
    RunCommand: "Install-AzCli -Force" # uv tool, depends on uv
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
