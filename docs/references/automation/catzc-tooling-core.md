# Catzc.Tooling.Core

The foundation of the Tooling group. It owns the single source of truth for which external command-line tool is locked to which version —
the `tools.yml` config and the `ToolConfig` type that models it — and the generic, tool-agnostic engine that reads that contract to assert a
tool's presence, install it, and uninstall it through the right package manager. Every other Tooling module is built on this one; it knows
nothing about any specific tool, only how to drive one from its config. The rationale is in
[controlling-systemwide-deps](../../adr/automation/controlling-systemwide-deps.md), and the config is modelled as a native type per
[native-csharp-types](../../adr/automation/BCL/native-csharp-types.md).

## Domains

| Domain   | Area   | Name                                                                       |
| -------- | ------ | -------------------------------------------------------------------------- |
| domain:1 | config | [Tool configuration and mapping](#domain1--tool-configuration-and-mapping) |
| domain:2 | verify | [Presence and version control](#domain2--presence-and-version-control)     |
| domain:3 | engine | [Install and uninstall engine](#domain3--install-and-uninstall-engine)     |

### domain:1 — Tool configuration and mapping

Reading `tools.yml` and resolving, for any named tool, its locked version, the command it provides (and the per-platform command suffix that
command takes), and the order tools must be installed in to satisfy their declared dependencies. `tools.yml` is the single source of truth;
the `ToolConfig` C# type is its in-memory shape (see [native-csharp-types](../../adr/automation/BCL/native-csharp-types.md)). Because every
fact about a tool lives in config, adding or upgrading one is an edit here, not new install code.

### domain:2 — Presence and version control

Deciding whether a tool is present at the locked version — in a throwing (assert) and a querying (test) form — and whether it was installed
by the package manager the platform expects rather than by some stray system install. This is the gate every tool invocation passes before
it runs.

### domain:3 — Install and uninstall engine

The generic mechanism that installs the locked version idempotently through the platform's native package manager and uninstalls a managed
install. It resolves the install scope (current user versus machine), the directory a script-based install lands in, fetches and
checksum-verifies a download before that download is trusted, and hard-removes a system installation that was placed outside the manager.
Idempotence is a requirement here, not a nicety (see [idempotent-state-functions](../../adr/automation/idempotent-state-functions.md)), and
the manager is always the platform's first-class one (see
[use-proper-package-managers](../../adr/automation/use-proper-package-managers.md)).

## What the module does

The module is a config-driven dispatcher with no tools of its own. `tools.yml` is the single source of truth: each entry names a tool's
locked version, the command it provides, how to read its installed version, and the per-platform identifiers the package managers need
(winget on Windows, Homebrew on macOS, apt on Linux, pip as a cross-platform fallback, or a vendored install script). A small set of generic
engine helpers reads that config and selects the right manager, so the per-tool surface in the rest of the group stays thin — each concrete
tool repeats the same lifecycle shape over this shared engine.

The three domains stack cleanly. Configuration and mapping turns a tool name into facts; presence and version control reads those facts
against the live machine; and the engine acts on the gap between them. The `ToolConfig` type that carries those facts derives from the
shared `DictionaryRecord` base in [Catzc.Base.Objects](catzc-base-objects.md), so it gets a dictionary view and the extraction helpers
without a per-module copy.

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
|                                           | `Save-VerifiedDownload`       |
|                                           | `Remove-SystemInstallation`   |
|                                           | `Get-InstallScope`            |
|                                           | `Get-ScriptInstallDir`        |
