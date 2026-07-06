# Catzc.Tooling.Toolchain

The build-toolchain module of the Tooling group. It owns the compiled-language and infrastructure build tools — the .NET SDK, the Java
runtime, and Terraform — plus uv (Astral's Python handler) and the Azure CLI binary, each installed and version-locked through the generic
engine in [Catzc.Tooling.Core](catzc-tooling-core.md). It ships the vendored `dotnet-install.{ps1,sh}` scripts under `assets/scripts/` that
.NET installs from. What it deliberately does **not** own is the az _session_: installing the `az` binary lives here, but using it — logging
in, running commands, selecting a subscription, verifying — belongs to [Catzc.Azure.Cli](catzc-azure-cli.md). uv and the Azure CLI install
user-space per [uv-python-handler](../../adr/automation/uv-python-handler.md); the build tools use their native managers per
[use-proper-package-managers](../../adr/automation/use-proper-package-managers.md).

## Domains

| Domain   | Area        | Name                                                             |
| -------- | ----------- | ---------------------------------------------------------------- |
| domain:1 | build-tools | [Build toolchain lifecycle](#domain1--build-toolchain-lifecycle) |
| domain:2 | uv          | [uv, the Python handler](#domain2--uv-the-python-handler)        |
| domain:3 | az-binary   | [Azure CLI binary](#domain3--azure-cli-binary)                   |

### domain:1 — Build toolchain lifecycle

The full life of the .NET SDK, the Java runtime, and Terraform: install the locked version idempotently, invoke through the asserted
execution wrapper, uninstall the managed install, and — for .NET and Java — hard-remove an unmanaged one. .NET installs from the vendored
official `dotnet-install` script this module ships under `assets/scripts/`; Java and Terraform come from the platform's native package
manager — winget (user scope) on Windows, Homebrew on macOS, apt on Linux (see
[use-proper-package-managers](../../adr/automation/use-proper-package-managers.md)).

### domain:2 — uv, the Python handler

Installing and upgrading uv — a fresh machine bootstraps it via winget (user scope, no admin); an existing Astral-standalone uv upgrades
itself in place with `uv self update`. uv is the standard Python handler: everything the Python family and the Azure CLI install runs
through it, so it is the toolchain's foundational prerequisite (its dependents declare `depends_on: uv`). See
[uv-python-handler](../../adr/automation/uv-python-handler.md).

### domain:3 — Azure CLI binary

Installing, uninstalling, and hard-removing the `az` binary and locking its version. It installs user-space as an isolated uv tool
(`uv tool install azure-cli`) on every platform — no administrator anywhere — so this module carries no machine-scope install path (see
[uv-python-handler](../../adr/automation/uv-python-handler.md); the CLI is still preferred over the Az PowerShell modules per
[prefer-az-cli](../../adr/automation/prefer-az-cli.md)). Everything you do with `az` once it is installed — the session: connect, select a
subscription, verify — lives in [Catzc.Azure.Cli](catzc-azure-cli.md), the subject of
[az-session-verification](../../adr/automation/az-session-verification.md), not here.

## What the module does

The module depends on [Catzc.Tooling.Core](catzc-tooling-core.md) and only that module within the group. Each per-tool function hands its
tool name to Core's engine, which reads `tools.yml` for the locked version and the per-platform identifier and then installs, asserts, or
removes idempotently. The one piece this module adds of its own is the vendored `dotnet-install.{ps1,sh}` scripts: .NET has no single native
package manager across platforms, so the official install script is checked in under `assets/scripts/` (excluded from the spelling and lint
gates) and the engine runs it as a script-based install.

The binary-versus-session split is the deliberate counterpart to [Catzc.Azure.Cli](catzc-azure-cli.md): this module owns the `az` **binary**
(install as a uv tool, uninstall, and the `tools.yml` version lock asserted by Core's `Assert-Tool`), while that module owns the `az`
**session**. The az CLI is just one more managed tool here; its connect-and-verify life is one layer up. The same per-tool functions run
locally and in CI, with no separate provisioning path (see [cross-platform](../../adr/automation/cross-platform.md)).

## Division

The module's public functions, sorted into the domains above.

| Domain                               | Function              |
| ------------------------------------ | --------------------- |
| domain:1 — Build toolchain lifecycle | `Install-Dotnet`      |
|                                      | `Invoke-Dotnet`       |
|                                      | `Uninstall-Dotnet`    |
|                                      | `Remove-Dotnet`       |
|                                      | `Install-Java`        |
|                                      | `Invoke-Java`         |
|                                      | `Uninstall-Java`      |
|                                      | `Remove-Java`         |
|                                      | `Install-Terraform`   |
|                                      | `Invoke-Terraform`    |
|                                      | `Uninstall-Terraform` |
| domain:2 — uv, the Python handler    | `Install-Uv`          |
|                                      | `Uninstall-Uv`        |
| domain:3 — Azure CLI binary          | `Install-AzCli`       |
|                                      | `Uninstall-AzCli`     |
|                                      | `Remove-AzCli`        |
