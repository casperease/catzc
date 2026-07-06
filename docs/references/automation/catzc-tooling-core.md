# Catzc.Tooling.Core

The foundation of the Tooling group. It owns the single source of truth for which external command-line tool is locked to which version —
the `tools.yml` config and the `ToolConfig` type that models it — and the generic, tool-agnostic engine that reads that contract to assert a
tool's presence, install it, and uninstall it through the right mechanism. Every other Tooling module is built on this one; it knows nothing
about any specific tool, only how to drive one from its config. The rationale is in
[controlling-systemwide-deps](../../adr/automation/controlling-systemwide-deps.md) and
[uv-python-handler](../../adr/automation/uv-python-handler.md), and the config is modelled as a native type per
[native-csharp-types](../../adr/automation/BCL/native-csharp-types.md).

## Domains

| Domain   | Area    | Name                                                                       |
| -------- | ------- | -------------------------------------------------------------------------- |
| domain:1 | config  | [Tool configuration and mapping](#domain1--tool-configuration-and-mapping) |
| domain:2 | verify  | [Presence and version control](#domain2--presence-and-version-control)     |
| domain:3 | engine  | [Install and uninstall engine](#domain3--install-and-uninstall-engine)     |
| domain:4 | session | [Session tool reconciliation](#domain4--session-tool-reconciliation)       |

### domain:1 — Tool configuration and mapping

Reading `tools.yml` and resolving, for any named tool, its locked version, the command it provides (and the per-platform command suffix that
command takes), and the order tools must be installed in to satisfy their declared dependencies. `tools.yml` is the single source of truth;
the `ToolConfig` C# type is its in-memory shape (see [native-csharp-types](../../adr/automation/BCL/native-csharp-types.md)). Because every
fact about a tool lives in config — its install mechanism, dependencies, and any devbox version relaxation or session PATH hint — adding or
upgrading one is an edit here, not new install code.

### domain:2 — Presence and version control

Deciding whether a tool is present at the locked version — in a throwing (assert) and a querying (test) form, both honouring the optional
`devbox_version` relaxation outside CI — and whether it was installed by the manager the platform expects rather than by some stray system
install. This is the gate every tool invocation passes before it runs.

### domain:3 — Install and uninstall engine

The generic mechanism that installs the locked version idempotently and uninstalls a managed install. It drives the platform's native
package manager (winget / brew / apt), installs Python-based CLIs as isolated uv tools (`Install-UvTool`) or into the uv-managed Python,
runs uv through a single asserted wrapper (`Invoke-Uv`), resolves the install scope and script-install directory, checksum-verifies a
download before it is trusted, and hard-removes a system installation placed outside the manager. Idempotence is a requirement here, not a
nicety (see [idempotent-state-functions](../../adr/automation/idempotent-state-functions.md)); the mechanism follows the tool's declared
kind (see [uv-python-handler](../../adr/automation/uv-python-handler.md) and
[use-proper-package-managers](../../adr/automation/use-proper-package-managers.md)).

### domain:4 — Session tool reconciliation

Keeping the current session's PATH pointing at the tools that are actually present. A post-import pass rebuilds PATH so a freshly installed
or relocated tool resolves without a shell restart, uses each tool's declared PATH hints to recover a tool installed outside the installer
layer (e.g. nvm-managed node, or winget's alias directory), and reports on one line any tool running from a location the installer layer
does not own. It is advisory and session-only — it never writes the persistent environment.

## What the module does

The module is a config-driven dispatcher with no tools of its own. `tools.yml` is the single source of truth: each entry names a tool's
locked version, the command it provides, how to read its installed version, and the mechanism to install it — a native package manager
(winget on Windows, Homebrew on macOS, apt on Linux), uv for the Python family (`uv_tool` / `uv_python` / uv-pip), a vendored install
script, or an OS-provided prerequisite (`system_provided`, e.g. winget) that is asserted rather than installed. A small set of generic
engine helpers reads that config and selects the right mechanism, so the per-tool surface in the rest of the group stays thin — each
concrete tool repeats the same lifecycle shape over this shared engine.

The four domains stack cleanly. Configuration and mapping turns a tool name into facts; presence and version control reads those facts
against the live machine; the engine acts on the gap between them; and session reconciliation keeps what is installed resolvable on PATH.
The `ToolConfig` type that carries those facts derives from the shared `DictionaryRecord` base in
[Catzc.Base.Objects](catzc-base-objects.md), so it gets a dictionary view and the extraction helpers without a per-module copy.

The sibling Tooling modules — [Catzc.Tooling.Python](catzc-tooling-python.md), [Catzc.Tooling.Node](catzc-tooling-node.md),
[Catzc.Tooling.Toolchain](catzc-tooling-toolchain.md), and [Catzc.Tooling.Provisioning](catzc-tooling-provisioning.md) — all depend on this
module and only this module within the group. Core is the engine; they are the per-ecosystem and orchestration surfaces over it.

## Division

The module's public functions and configuration, sorted into the domains above.

| Domain                                    | Function                      |
| ----------------------------------------- | ----------------------------- |
| domain:1 — Tool configuration and mapping | `Get-ToolConfig`              |
|                                           | `Get-ToolVersion`             |
|                                           | `Get-ToolCommandSuffix`       |
|                                           | `Get-ToolInstallOrder`        |
| config                                    | `tools.yml`                   |
| domain:2 — Presence and version control   | `Assert-Tool`                 |
|                                           | `Test-Tool`                   |
|                                           | `Test-ExpectedPackageManager` |
| domain:3 — Install and uninstall engine   | `Install-Tool`                |
|                                           | `Uninstall-Tool`              |
|                                           | `Install-UvTool`              |
|                                           | `Uninstall-UvTool`            |
|                                           | `Invoke-Uv`                   |
|                                           | `Save-VerifiedDownload`       |
|                                           | `Remove-SystemInstallation`   |
|                                           | `Get-InstallScope`            |
|                                           | `Get-ScriptInstallDir`        |
| domain:4 — Session tool reconciliation    | `Sync-SessionTools`           |
