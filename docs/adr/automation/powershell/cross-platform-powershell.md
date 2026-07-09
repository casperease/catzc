# ADR: Cross-platform PowerShell — the language layer over cross-platform

## Rules: ADR-AUTO-PSXPLAT

### Rule ADR-AUTO-PSXPLAT:1

PowerShell code meets [cross-platform](../cross-platform.md) (`ADR-AUTO-XPLAT`) through the rules below, gated mechanically:
PSScriptAnalyzer's compatibility rules validate cmdlets and .NET types against the target-platform profiles at analysis time, before the
code ever runs on the other OS.

- [How the analyzer catches platform breaks](#how-the-analyzer-catches-platform-breaks)

### Rule ADR-AUTO-PSXPLAT:2

Use `Join-Path` for all path construction; never concatenate strings with `/` or `\`. It uses the correct separator for the current
platform.

- [What breaks in practice](#what-breaks-in-practice)

### Rule ADR-AUTO-PSXPLAT:3

Never use platform-specific cmdlets (`Get-Service`, `Get-WmiObject`, …) without a cross-platform alternative. If platform-specific behavior
is unavoidable, gate it with `$IsWindows` / `$IsLinux` and implement both.

- [What breaks in practice](#what-breaks-in-practice)

### Rule ADR-AUTO-PSXPLAT:4

Never shell out to platform-specific binaries (`cmd /c`, `/bin/sh -c`). Use PowerShell native operations or the `Invoke-Executable` wrapper
with tools that exist on both platforms.

- [What breaks the other way](#what-breaks-the-other-way)

### Rule ADR-AUTO-PSXPLAT:5

Gate unavoidable platform-specific logic with the built-in `$IsWindows` / `$IsLinux` automatic variables, and always provide both branches.

- [What breaks in practice](#what-breaks-in-practice)

## Context

[cross-platform](../cross-platform.md) fixes the doctrine: everything runs on Windows and Linux, and a developer tests locally everything
that runs in CI. PowerShell 7+ is cross-platform by design, but the _code_ people write in it often is not: Windows-only cmdlets, .NET types
that do not exist on Linux, backslash separators, registry access, COM objects, shell-outs to `cmd.exe`. These work fine on the author's
machine and fail silently or loudly in CI. This ADR is the language layer — the concrete PowerShell hazards and the analyzer that catches
them before push.

### What breaks in practice

| Windows-ism                                            | Fails on Unix because                 |
| ------------------------------------------------------ | ------------------------------------- |
| `C:\path\to\file` hardcoded                            | No `C:` drive, no backslash paths     |
| `[Microsoft.Win32.Registry]`                           | Type does not exist on .NET Core Unix |
| `Get-Service`, `Get-WmiObject`                         | Cmdlets not available on Unix         |
| `cmd /c` or `Start-Process notepad`                    | Binaries do not exist                 |
| `$env:APPDATA`, `$env:USERPROFILE`                     | Variables not set on Unix             |
| `[System.IO.Path]::DirectorySeparatorChar` assumed `\` | It is `/` on Unix                     |
| Case-insensitive file lookups                          | Unix filesystems are case-sensitive   |

The culture axis — a locale-dependent `ToString` producing different output on a da-DK devbox than an invariant CI agent — is a doctrine
rule, not a language one: see [cross-platform](../cross-platform.md#rule-adr-auto-xplat6).

### What breaks the other way

| Unix-ism                                              | Fails on Windows because                     |
| ----------------------------------------------------- | -------------------------------------------- |
| `#!/usr/bin/env pwsh` shebang relied on for execution | Windows uses file associations, not shebangs |
| `chmod +x` permissions                                | NTFS does not have executable bits           |
| `/tmp`, `/dev/null` in paths                          | Not valid Windows paths                      |
| `apt-get`, `brew` assumed available                   | Windows uses `winget`                        |

### How the analyzer catches platform breaks

**PSScriptAnalyzer** validates cmdlets and .NET types against Windows and Ubuntu profiles at analysis time, catching Windows-only APIs
_before the code runs_ — in the L2 test suite, on every developer's machine. The rules that do this (`PSUseCompatibleCmdlets`,
`PSUseCompatibleTypes`), their target profiles, and their current on/off state are defined in `PSScriptAnalyzerSettings.psd1`, documented
inline (they are cost-gated and may be toggled — the psd1 is authoritative).

**Why no macOS profile?** PSScriptAnalyzer's built-in compatibility catalog only ships with Windows and Ubuntu profiles — there is no macOS
catalog. In practice this is fine: macOS and Linux both run .NET on Unix, so the cmdlet and type surface is nearly identical. The Ubuntu
profile effectively covers macOS. If Microsoft ever ships a macOS catalog, we add it to the list.

**`Join-Path` and `[IO.Path]::Combine`** handle separators correctly on both platforms. Hardcoded `/` or `\` in paths is always wrong.

## Decision

PowerShell code constructs every path with `Join-Path`, uses no platform-only cmdlet or binary without a gated alternative, and expresses
unavoidable platform logic as `$IsWindows` / `$IsLinux` branches — all validated by the analyzer's compatibility profiles before push.

### How this is enforced

- **PSScriptAnalyzer compatibility rules** — `PSUseCompatibleCmdlets` and `PSUseCompatibleTypes` flag cmdlets and .NET types not available
  on all target platforms. The rules, their profiles, and their on/off state live in `PSScriptAnalyzerSettings.psd1`.
- **L2 tests run locally** — developers run the same `Test-ScriptAnalyzer.Tests.ps1` suite that CI runs, so platform violations are caught
  before push, not in the pipeline queue.

## Consequences

- Code that passes L2 tests locally on Windows is validated against Linux compatibility without needing a Linux machine.
- Platform-specific concerns are isolated to `Install-*` functions and gated with `$IsWindows` / `$IsLinux`; the rest of the codebase is
  platform-agnostic.
- Path handling is consistent everywhere — `Join-Path` is the only way to build paths.
- New platforms (macOS) can be added by extending the `Install-*` functions without touching business logic.

## Dora explains

DORA's research on flexible infrastructure links platform-agnostic code to deployment reliability—and PowerShell's cross-platform support
enables one codebase on Windows and Linux. Catching platform incompatibilities at analysis time rather than at runtime reduces the friction
of multi-platform deployment and enables confident automation across all environments.

- [Flexible infrastructure](https://dora.dev/capabilities/flexible-infrastructure/) — running on Windows and Linux from one codebase.
- [Code maintainability](https://dora.dev/capabilities/code-maintainability/) — platform-agnostic patterns centralize business logic away
  from environment-specific concerns.
- [Continuous integration](https://dora.dev/capabilities/continuous-integration/) — analyzer catches platform breaks at analysis time,
  before code runs on different OSes.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.
