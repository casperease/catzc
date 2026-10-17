---
catzc:
  immutable:
    repo_status: clean
    path: docs/references/automation/catzc-tooling-core.md
    folder: docs/references/automation
    name: catzc-tooling-core
    filetype: md
    kind: reference
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    links:
      - docs/adr/automation/BCL/native-csharp-types.md
      - docs/adr/automation/controlling-systemwide-deps.md
      - docs/adr/automation/idempotent-state-functions.md
      - docs/adr/automation/use-proper-package-managers.md
      - docs/adr/automation/uv-python-handler.md
      - docs/references/.assets/automation/catzc-tooling-core/invoke-tool-asserts-locked-version.drawio.png
      - docs/references/automation/catzc-base-execution.md
      - docs/references/automation/catzc-base-objects.md
      - docs/references/automation/catzc-tooling-core/invoke-tool-asserts-locked-version.drawio.md
      - docs/references/automation/catzc-tooling-node.md
      - docs/references/automation/catzc-tooling-provisioning.md
      - docs/references/automation/catzc-tooling-python.md
      - docs/references/automation/catzc-tooling-toolchain.md
---

# Catzc.Tooling.Core

The foundation of the Tooling group. It owns the generic, tool-agnostic engine that reads the single source of truth for which external
command-line tool is locked to which version — the `tools.yml` config and the `ToolConfig` type that models it, both owned by
[Catzc.Base.Execution](catzc-base-execution.md), the module furthest down the stack that reads them — to assert a tool's presence, install
it, and uninstall it through the right mechanism. Every other Tooling module is built on this one; it knows nothing about any specific tool,
only how to drive one from its config. The rationale is in
[controlling-systemwide-deps](../../adr/automation/controlling-systemwide-deps.md) and
[uv-python-handler](../../adr/automation/uv-python-handler.md), and the config is modelled as a native type per
[native-csharp-types](../../adr/automation/BCL/native-csharp-types.md).

## Responsibilities

| Responsibility   | Area    | Name                                                                               |
| ---------------- | ------- | ---------------------------------------------------------------------------------- |
| responsibility:1 | config  | [Tool configuration and mapping](#responsibility1--tool-configuration-and-mapping) |
| responsibility:2 | verify  | [Presence and version control](#responsibility2--presence-and-version-control)     |
| responsibility:3 | engine  | [Install and uninstall engine](#responsibility3--install-and-uninstall-engine)     |
| responsibility:4 | session | [Session tool reconciliation](#responsibility4--session-tool-reconciliation)       |
| responsibility:5 | parity  | [Per-engine fixture tables](#responsibility5--per-engine-fixture-tables)           |

### responsibility:1 — Tool configuration and mapping

Reading `tools.yml` and resolving, for any named tool, its locked version, the command it provides (and the per-platform command suffix that
command takes), and the order tools must be installed in to satisfy their declared dependencies. `tools.yml` is the single source of truth;
the `ToolConfig` C# type is its in-memory shape (see [native-csharp-types](../../adr/automation/BCL/native-csharp-types.md)). Both live in
[Catzc.Base.Execution](catzc-base-execution.md), so a bundle without the Tooling group still locates every managed tool. Because every fact
about a tool lives in config — its install mechanism, dependencies, and any devbox version relaxation or session PATH hint — adding or
upgrading one is an edit here, not new install code.

### responsibility:2 — Presence and version control

Deciding whether a tool is present at the locked version — in a throwing (assert) and a querying (test) form, both honouring the optional
`devbox_version` relaxation outside CI — and whether it was installed by the manager the platform expects rather than by some stray system
install. This is the gate every tool invocation passes before it runs.

A tool whose `tools.yml` entry declares candidate paths (`windows_probes`, `unix_probes`, and their `*_pipeline_probes` lists) is located
without starting a process: the candidates for the running platform and run environment first (a pipeline reads the pipeline list, a devbox
the devbox list), then PATH, skipping every path in `probe_excludes` (for bash, the WSL launcher). Only a located executable runs its
version command, once per executable file per session (a lazy cache entry), so a check costs file lookups after the first. The probe itself
is generic and lives in [Catzc.Base.Execution](catzc-base-execution.md), which also reads the entry, so a Base module finds a managed tool
the same way; this module keeps the presence and version decision on top of it. `Test-Tool -PassThru` returns the check as a record (where,
how, which version against the pin, and the timings), and `Write-ToolProbeReport` renders such records as a table.

### responsibility:3 — Install and uninstall engine

The generic mechanism that installs the locked version idempotently and uninstalls a managed install. It drives the platform's native
package manager (winget / brew / apt), installs Python-based CLIs as isolated uv tools (`Install-UvTool`) or into the uv-managed Python,
runs uv through a single asserted wrapper (`Invoke-Uv`), resolves the install scope and script-install directory, checksum-verifies a
download before it is trusted, and hard-removes a system installation placed outside the manager. Idempotence is a requirement here, not a
nicety (see [idempotent-state-functions](../../adr/automation/idempotent-state-functions.md)); the mechanism follows the tool's declared
kind (see [uv-python-handler](../../adr/automation/uv-python-handler.md) and
[use-proper-package-managers](../../adr/automation/use-proper-package-managers.md)).

### responsibility:4 — Session tool reconciliation

Keeping the current session's PATH pointing at the tools that are actually present. A post-import pass rebuilds PATH so a freshly installed
or relocated tool resolves without a shell restart, uses each tool's declared PATH hints to recover a tool installed outside the installer
layer (e.g. nvm-managed node, or winget's alias directory), and reports on one line any tool running from a location the installer layer
does not own. It is advisory and session-only — it never writes the persistent environment.

### responsibility:5 — Per-engine fixture tables

Holding test cases for the repository's three execution engines, pwsh, bash and zsh, side by side. A per-engine fixture table is a YAML file
under a module's `tests/assets/engine-cases/`: a subject, then one case per row with a column per engine. Every column holds the case's
fields for that engine, or says why the case does not apply there (`n/a: <reason>`), so a behaviour can never quietly cover one engine only.
The `EngineCaseTable` type validates the shape — its columns are the engines the `ExecutionEngines` model declares — and
`Get-EngineCaseTable` loads a table as rows shaped for Pester's `-ForEach`. Any subject can use the same shape: the time safeguard's command
grammar is the first, and an integrity test holds every table in the repository to it.

## What the module does

The module is a config-driven dispatcher with no tools of its own. `tools.yml` is the single source of truth: each entry names a tool's
locked version, the command it provides, how to read its installed version, and the mechanism to install it — a native package manager
(winget on Windows, Homebrew on macOS, apt on Linux), uv for the Python family (`uv_tool` / `uv_python` / uv-pip), a vendored install
script, or an OS-provided prerequisite (`system_provided`, e.g. winget) that is asserted rather than installed. A small set of generic
engine helpers reads that config and selects the right mechanism, so the per-tool surface in the rest of the group stays thin — each
concrete tool repeats the same lifecycle shape over this shared engine.

The four responsibilities stack cleanly. Configuration and mapping turns a tool name into facts; presence and version control reads those
facts against the live machine; the engine acts on the gap between them; and session reconciliation keeps what is installed resolvable on
PATH. The per-engine fixture tables sit beside them: the engines are tools too, and the tables keep their parity testable. The `ToolConfig`
type that carries those facts derives from the shared `DictionaryRecord` base in [Catzc.Base.Objects](catzc-base-objects.md), so it gets a
dictionary view and the extraction helpers without a per-module copy.

The sibling Tooling modules — [Catzc.Tooling.Python](catzc-tooling-python.md), [Catzc.Tooling.Node](catzc-tooling-node.md),
[Catzc.Tooling.Toolchain](catzc-tooling-toolchain.md), and [Catzc.Tooling.Provisioning](catzc-tooling-provisioning.md) — all depend on this
module and only this module within the group. Core is the engine; they are the per-ecosystem and orchestration surfaces over it.

The diagram below draws tool invocation from the source. Every tool wrapper asserts the locked version from `tools.yml` before it runs the
tool. The assertion either probes for the executable or checks the command and reads its version. The query form shares the same pieces. Its
[description](catzc-tooling-core/invoke-tool-asserts-locked-version.drawio.md) walks it step by step.

![Each Invoke-Tool wrapper asserts the locked version before it runs](../.assets/automation/catzc-tooling-core/invoke-tool-asserts-locked-version.drawio.png)

## Division

The module's public functions and configuration, sorted into the responsibilities above.

| Responsibility                                    | Function                      |
| ------------------------------------------------- | ----------------------------- |
| responsibility:1 — Tool configuration and mapping | `Get-ToolConfig`              |
|                                                   | `Get-ToolVersion`             |
|                                                   | `Get-ToolCommandSuffix`       |
|                                                   | `Get-ToolInstallOrder`        |
| responsibility:2 — Presence and version control   | `Assert-Tool`                 |
|                                                   | `Test-Tool`                   |
|                                                   | `Test-ExpectedPackageManager` |
|                                                   | `Write-ToolProbeReport`       |
| responsibility:3 — Install and uninstall engine   | `Install-Tool`                |
|                                                   | `Uninstall-Tool`              |
|                                                   | `Install-UvTool`              |
|                                                   | `Uninstall-UvTool`            |
|                                                   | `Invoke-Uv`                   |
|                                                   | `Save-VerifiedDownload`       |
|                                                   | `Remove-SystemInstallation`   |
|                                                   | `Get-InstallScope`            |
|                                                   | `Get-ScriptInstallDir`        |
| responsibility:4 — Session tool reconciliation    | `Sync-SessionTools`           |
| responsibility:5 — Per-engine fixture tables      | `Get-EngineCaseTable`         |
