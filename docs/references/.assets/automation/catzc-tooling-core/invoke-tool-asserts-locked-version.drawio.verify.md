# Verification: Each `Invoke-<Tool>` asserts the locked version before it runs (source lens, Catzc.Tooling.Core)

Every line below was re-read on 2026-10-15 after the comment export. The scout's line numbers had moved (`Assert-Tool.ps1:30,36,55` is now
`:30,31,47,50`; `Test-Tool.ps1:42,56,68` is now `:34,35,49`; `Get-ToolVersion.ps1:25` is now `:22`). Only the wrapper lines
(`Invoke-Terraform.ps1:34,37`, `Invoke-Dotnet.ps1:36,39`) still hold, re-checked. `condense-comments` may move them again, so re-grep before
landing. Paths are relative to `pwsh/` unless they start with `docs/`.

## Boxes

| #   | Claim (box)                                                                         | Source (`file:line`)                                                                                                                                                                                                                                                                                                                    | Status    |
| --- | ----------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------- |
| B1  | `Invoke-<Tool>` is a named set of public tool wrappers                              | the 10 files in B2                                                                                                                                                                                                                                                                                                                      | confirmed |
| B2  | Count chip `10`: every `Invoke-<Tool>` wrapper calls `Assert-Tool`                  | `Catzc.Azure.Cli/Invoke-AzCli.ps1:38`; `Catzc.Tooling.Core/Invoke-Uv.ps1:40`; `Catzc.Tooling.Node/Invoke-Npm.ps1:34`; `Catzc.Tooling.Python/Invoke-Poetry.ps1:34`, `Invoke-PySpark.ps1:34`, `Invoke-Python.ps1:36`; `Catzc.Tooling.Toolchain/Invoke-Dotnet.ps1:36`, `Invoke-Go.ps1:37`, `Invoke-Java.ps1:34`, `Invoke-Terraform.ps1:34` | confirmed |
| B3  | `Assert-Tool` is public in Catzc.Tooling.Core                                       | `Catzc.Tooling.Core/Assert-Tool.ps1:17`                                                                                                                                                                                                                                                                                                 | confirmed |
| B4  | `Assert-ToolVersion` is private and caches its verdict per session                  | `Catzc.Tooling.Core/private/Assert-ToolVersion.ps1:10,18-28,53`                                                                                                                                                                                                                                                                         | confirmed |
| B5  | `Get-ToolVersion` is public, runs `version_command`, matches `version_pattern`      | `Catzc.Tooling.Core/Get-ToolVersion.ps1:14,22,25`                                                                                                                                                                                                                                                                                       | confirmed |
| B6  | `Test-Tool` is public                                                               | `Catzc.Tooling.Core/Test-Tool.ps1:22`                                                                                                                                                                                                                                                                                                   | confirmed |
| B7  | `Resolve-ToolExecutable` is public in Catzc.Base.Execution and reads `tools.yml`    | `Catzc.Base.Execution/Resolve-ToolExecutable.ps1:17,25`                                                                                                                                                                                                                                                                                 | confirmed |
| B8  | `Invoke-Executable` is public in Catzc.Base.Execution                               | `Catzc.Base.Execution/Invoke-Executable.ps1:49`                                                                                                                                                                                                                                                                                         | confirmed |
| B9  | `tools.yml` lives in Catzc.Base.Execution and holds `version` and `version_command` | `Catzc.Base.Execution/configs/tools.yml:16,19` (18 tool keys, 18 `version_command` lines)                                                                                                                                                                                                                                               | confirmed |

## Edges (flow: calls)

| #   | Edge                                                                     | Source (`file:line`)                                                                       | Status    |
| --- | ------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------ | --------- |
| E1  | `Invoke-<Tool>` → `Assert-Tool`                                          | `Catzc.Tooling.Toolchain/Invoke-Terraform.ps1:34`, `Invoke-Dotnet.ps1:36` (all of B2)      | confirmed |
| E2  | `Invoke-<Tool>` → `Invoke-Executable`, after E1                          | `Catzc.Tooling.Toolchain/Invoke-Terraform.ps1:37`, `Invoke-Dotnet.ps1:39`                  | confirmed |
| E3  | `Assert-Tool` → `Resolve-ToolExecutable`, when the entry `HasProbes()`   | `Catzc.Tooling.Core/Assert-Tool.ps1:30-31`; `Catzc.Base.Execution/types/ToolConfig.cs:133` | confirmed |
| E4  | `Assert-Tool` → `Assert-ToolVersion`, otherwise (after `Assert-Command`) | `Catzc.Tooling.Core/Assert-Tool.ps1:47,50`                                                 | confirmed |
| E5  | `Assert-ToolVersion` → `Get-ToolVersion`                                 | `Catzc.Tooling.Core/private/Assert-ToolVersion.ps1:32`                                     | confirmed |
| E6  | `Get-ToolVersion` → `Invoke-Executable`                                  | `Catzc.Tooling.Core/Get-ToolVersion.ps1:22`                                                | confirmed |
| E7  | `Test-Tool` → `Resolve-ToolExecutable`, with probes or `-PassThru`       | `Catzc.Tooling.Core/Test-Tool.ps1:34-35`                                                   | confirmed |
| E8  | `Test-Tool` → `Get-ToolVersion`, otherwise                               | `Catzc.Tooling.Core/Test-Tool.ps1:49`                                                      | confirmed |

## Other claims

| #   | Claim                                                                                                                         | Source (`file:line`)                                                                                                 | Status    |
| --- | ----------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------- | --------- |
| C1  | `-DryRun` skips the assert: 9 wrappers guard it with `if (-not $DryRun)`, `Invoke-Go` returns early                           | `Catzc.Tooling.Toolchain/Invoke-Terraform.ps1:33`; `Invoke-Go.ps1:33-34`                                             | confirmed |
| C2  | Of the 10 wrapped tools only `go` declares probes, so 9 take the `Assert-ToolVersion` branch                                  | `Catzc.Base.Execution/configs/tools.yml` (probe lists under five tool keys, `go` among them)                         | confirmed |
| C3  | The probe branch reads the version through `Find-Executable` → `Get-ExecutableVersion`, never `Get-ToolVersion`               | `Catzc.Base.Execution/Resolve-ToolExecutable.ps1:63`; `Find-Executable.ps1:98`                                       | confirmed |
| C4  | Both version reads are cached per session                                                                                     | `Catzc.Tooling.Core/private/Assert-ToolVersion.ps1:18-28`; `Catzc.Base.Execution/Find-Executable.ps1:85-101`         | confirmed |
| C5  | The accepted-prefix rule (locked `version`, plus `devbox_version` outside a pipeline) is written three times                  | `private/Assert-ToolVersion.ps1:40-46`; `Test-Tool.ps1:55-63`; `Resolve-ToolExecutable.ps1:43-48`                    | confirmed |
| C6  | ADR-AUTO-DEPS-ASSERTBEFOREINVOKE: `Assert-Tool` runs `Assert-Command` and `Assert-ToolVersion`, or `Resolve-ToolExecutable` for a probed entry | `docs/adr/automation/controlling-systemwide-deps.md:24-26`; matches E3 and E4                                        | confirmed |
| C7  | Supports: ADR-AUTO-DRYRUN-BRANCHBEFORESIDEEFFECT, ADR-PWSH-CACHE-STRICTSAFEPROBE and ADR-CONF-LOADING-READINGISGLOBAL are cited by the drawn code                              | `Catzc.Base.Execution/Invoke-Executable.ps1:47`; `private/Assert-ToolVersion.ps1:20`; `Resolve-ToolExecutable.ps1:6` | confirmed |

Counts: 24 claims, 24 confirmed, 0 contradicted, 0 ADR-only. The slide draws the code; the brief's sketch had two claims the code
contradicts, corrected below.

## Corrections

- The brief's chain `Assert-Tool` → `Resolve-ToolExecutable` → `Get-ToolVersion` → `Assert-ToolVersion` is contradicted. `Assert-Tool` takes
  one of two exclusive branches on `HasProbes()`: the probe (`Resolve-ToolExecutable`), or `Assert-Command` then `Assert-ToolVersion`, which
  calls `Get-ToolVersion` (the order is reversed). `Resolve-ToolExecutable` never calls `Get-ToolVersion`.
- The brief's "one probe and one version read" is contradicted in part. `Assert-Tool` and `Test-Tool` share the same two branches, but there
  are two version reads (`Get-ToolVersion`, and `Get-ExecutableVersion` inside the probe), and `Test-Tool` calls `Get-ToolVersion` directly,
  skipping `Assert-ToolVersion`'s cache and repeating its accepted-prefix rule (C5).
- The title "Every `Invoke-<Tool>` asserts the locked version before it runs" (61 characters) is shortened to "Each …" (60).

## Drift

None between the slide and ADR-AUTO-DEPS-ASSERTBEFOREINVOKE (C6). Code note for the lead: the accepted-prefix rule lives in three places (C5), and
`Test-Tool.ps1:58` says it "mirrors Assert-ToolVersion". Supports holds the codes the drawn code cites; ADR-AUTO-DEPS-TOOLTRIAD and ADR-AUTO-DEPS-ASSERTBEFOREINVOKE, which
describe this mechanism, are cited by no drawn file. `tools.yml:44` cites ADR-AUTO-BASH-SHELLSCRIPTSCHECKED on the zsh entry; it is not about this finding, so
it is left off Supports.

## Cut

`Get-ToolConfig` and `Get-ToolCommandSuffix` (`Assert-Tool.ps1:25-26`), `Assert-Command` and `Test-Command` (Catzc.Base.Asserts;
`Assert-Tool.ps1:47`, `Test-Tool.ps1:45`), `Find-Executable` and `Get-ExecutableVersion` (inside the probe), `Test-IsRunningInPipeline` (the
devbox lever), `Invoke-Go`'s extra `Test-Tool 'go' -PassThru` (`Invoke-Go.ps1:38`, which runs go by its probed path), and the `Assert-Tool`
callers that are not wrappers (`Connect-AzCli`, `Install-Cspell` and others). Private helpers that call a tool through `Invoke-Executable`
without `Assert-Tool` (`Invoke-DotnetFormat`, `Invoke-Prettier`, `Invoke-BuildForVSCode`) are not `Invoke-<Tool>` wrappers and stay out of
the named set.
