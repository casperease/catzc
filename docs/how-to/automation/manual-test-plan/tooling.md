# docs/how-to/automation/manual-test-plan/tooling.md

`Manual test plan — Tooling`

The shipped `tools.yml` and the tool install machinery. Part of the [manual test plan](../manual-test-plan.md), which says how to run a
check.

## Index

| #   | Tier | Test file                                                              | FullNameFilter                                   | Guards                                                                                                                                           |
| --- | ---- | ---------------------------------------------------------------------- | ------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------ |
| 1   | L0   | automation/Catzc.Tooling.Core/tests/types/ToolsConfig.Tests.ps1        | integrity (shipped tools.yml)                    | The shipped `tools.yml` constructs a `ToolsConfig` (snake_case keys).                                                                            |
| 2   | L0   | automation/Catzc.Tooling.Core/tests/Get-ToolInstallOrder.Tests.ps1     | shipped tools.yml (generic invariant)            | The `tools.yml` dependency graph is acyclic and install order is valid.                                                                          |
| 3   | L0   | automation/Catzc.Tooling.Core/tests/Get-ToolConfig.Tests.ps1           | asset dependencies                               | Required tooling asset files are present.                                                                                                        |
| 4   | L0   | automation/Catzc.Tooling.Core/tests/Get-ToolConfig.Tests.ps1           | structural validation                            | Every `tools.yml` entry has required fields and a valid install method.                                                                          |
| 5   | L0   | automation/Catzc.Tooling.Core/tests/Get-ToolConfig.Tests.ps1           | Install/Uninstall function coverage              | Every tool has matching `Install-*` and `Uninstall-*` functions.                                                                                 |
| 6   | L1   | automation/Catzc.Tooling.Toolchain/tests/Install-Dotnet.Tests.ps1      | Install-Dotnet — shipped install scripts         | The vendored .NET install scripts (dotnet-install.ps1/.sh) ship inside the loaded Toolchain module and accept the options Install-Dotnet passes. |
| 7   | L0   | automation/Catzc.Base.Execution/tests/Resolve-ToolExecutable.Tests.ps1 | Resolve-ToolExecutable on the shipped bash entry | The shipped tools.yml bash entry resolves through the executable probe and never accepts the WSL launcher (System32 or WindowsApps bash.exe).    |

## Checks

### 1. integrity (shipped tools.yml) — ToolsConfig

**Guards:** the shipped `tools.yml` conforms to its config type.

**Checks:**

- The `ToolsConfig` constructor accepts the shipped `tools.yml` (all keys snake_case).

### 2. shipped tools.yml (generic invariant)

**Guards:** the `tools.yml` dependency graph is acyclic and install order is valid.

**Checks:**

- `Get-ToolInstallOrder` returns each tool exactly once over the full shipped set.
- Every dependency precedes its dependent in the returned order.

### 3. asset dependencies

**Guards:** the tooling's required asset files are present.

**Checks:**

- `configs/tools.yml` and the `dotnet-install.ps1`/`.sh` scripts exist.

### 4. structural validation

**Guards:** every `tools.yml` entry is well-formed.

**Checks:**

- At least one tool is defined; each has `version`, `command`, `version_command`, `version_pattern`.
- Each `version_pattern` has a named `(?<ver>…)` group; each tool declares an install mechanism.
- Every `DependsOn` reference points to a defined tool.

### 5. Install/Uninstall function coverage

**Guards:** every tool has install and uninstall functions.

**Checks:**

- Each tool has an `Install-<suffix>` and an `Uninstall-<suffix>` function available.

### 6. Asset dependencies (Toolchain)

**Guards:** the vendored .NET install scripts ship with the `Catzc.Tooling.Toolchain` module.

**Checks:**

- `dotnet-install.ps1` and `dotnet-install.sh` exist under `Catzc.Tooling.Toolchain/assets/scripts/`.
