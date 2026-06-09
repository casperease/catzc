# ADR: Must be cross-platform

## Rules: ADR-XPLAT

### Rule ADR-XPLAT:1

Use `Join-Path` for all path construction; never concatenate strings with `/` or `\`. It uses the correct separator for the current
platform.

- [How we enforce this](#how-we-enforce-this)

### Rule ADR-XPLAT:2

Never use platform-specific cmdlets (`Get-Service`, `Get-WmiObject`, …) without a cross-platform alternative. If platform-specific behavior
is unavoidable, gate it with `$IsWindows` / `$IsLinux` and implement both.

- [What breaks in practice](#what-breaks-in-practice)

### Rule ADR-XPLAT:3

Never hardcode platform-specific paths (`C:\`, `/tmp/`, `$env:APPDATA`). Use `$env:RepositoryRoot`, `$PSScriptRoot`,
`[IO.Path]::GetTempPath()`, or `Join-Path` from a known anchor.

- [What breaks in practice](#what-breaks-in-practice)

### Rule ADR-XPLAT:4

Never shell out to platform-specific binaries (`cmd /c`, `/bin/sh -c`). Use PowerShell native operations or the `Invoke-Executable` wrapper
with tools that exist on both platforms.

- [What breaks the other way](#what-breaks-the-other-way)

### Rule ADR-XPLAT:5

Gate unavoidable platform-specific logic with the built-in `$IsWindows` / `$IsLinux` automatic variables, and always provide both branches.

- [How we enforce this](#how-we-enforce-this)

### Rule ADR-XPLAT:6

Format and parse machine-bound strings (timestamps, numbers, dates) with `[System.Globalization.CultureInfo]::InvariantCulture` passed to
`ToString` / `ParseExact`; converting to UTC fixes the instant, not the rendering.

- [What breaks in practice](#what-breaks-in-practice)

### Rule ADR-XPLAT:7

Respect case sensitivity in file operations — Linux filesystems are case-sensitive. Use `-ieq` when comparing paths, or compare
`[IO.Path]::GetFullPath()` results, rather than `-eq`.

- [What breaks in practice](#what-breaks-in-practice)

### Rule ADR-XPLAT:8

CI and local use the same code path: the same `Install-DevBoxTools` and `importer.ps1` run on workstations and in CI. No separate scripts,
no "CI-only" branches.

- [How this is enforced](#how-this-is-enforced)

## Context

Our workstations run Windows, maybe MacOS, maybe Linux. Our CI runs Linux. MacOs is a unix based os, so is linux, so we can reduce to
Windows and Linux for most. Everything we write must work on both — and a developer must be able to test locally everything that runs in CI.

PowerShell 7+ is cross-platform by design, but the _code_ people write in it often is not. It is easy to accidentally use Windows-only
cmdlets, .NET types that do not exist on Linux, backslash path separators, registry access, COM objects, or shell-outs to `cmd.exe`. These
work fine on the author's machine and fail silently or loudly in CI.

The usual response is "it works in CI, we'll fix it if it breaks." This is backwards. A developer should never have to push to CI to
discover a platform bug. If you can run it locally, you can debug it locally — fast feedback, no waiting for pipeline queues.

### What breaks in practice

| Windows-ism                                            | Fails on Unix because                                                                                                                     |
| ------------------------------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------- |
| `C:\path\to\file` hardcoded                            | No `C:` drive, no backslash paths                                                                                                         |
| `[Microsoft.Win32.Registry]`                           | Type does not exist on .NET Core Unix                                                                                                     |
| `Get-Service`, `Get-WmiObject`                         | Cmdlets not available on Unix                                                                                                             |
| `cmd /c` or `Start-Process notepad`                    | Binaries do not exist                                                                                                                     |
| `$env:APPDATA`, `$env:USERPROFILE`                     | Variables not set on Unix                                                                                                                 |
| `[System.IO.Path]::DirectorySeparatorChar` assumed `\` | It is `/` on Unix                                                                                                                         |
| Case-insensitive file lookups                          | Unix filesystems are case-sensitive                                                                                                       |
| `$date.ToString('yyyy-MM-dd HH:mm')` (no culture)      | The `:`/`/` separators and month names follow the machine **locale** — a da-DK workstation renders `10.32`, an invariant CI agent `10:32` |

The last row is a different axis from the OS: the same OS with a different **culture** (da-DK vs en-US vs invariant) produces different
output. CI typically runs invariant/en-US while a developer box may be da-DK, so a locale-dependent format is the classic "works on my
machine, diff in the artifact" trap — and it silently changes data others parse.

### What breaks the other way

| Unix-ism                                              | Fails on Windows because                     |
| ----------------------------------------------------- | -------------------------------------------- |
| `#!/usr/bin/env pwsh` shebang relied on for execution | Windows uses file associations, not shebangs |
| `chmod +x` permissions                                | NTFS does not have executable bits           |
| `/tmp`, `/dev/null` in paths                          | Not valid Windows paths                      |
| `apt-get`, `brew` assumed available                   | Windows uses `winget`                        |

### How we enforce this

**PSScriptAnalyzer** validates cmdlets and .NET types against Windows and Ubuntu profiles at analysis time, catching Windows-only APIs
_before the code runs_ — in the L2 test suite, on every developer's machine. The rules that do this (`PSUseCompatibleCmdlets`,
`PSUseCompatibleTypes`), their target profiles, and their current on/off state are defined in `PSScriptAnalyzerSettings.psd1`, documented
inline (they are cost-gated and may be toggled — the psd1 is authoritative).

**Why no macOS profile?** PSScriptAnalyzer's built-in compatibility catalog only ships with Windows and Ubuntu profiles — there is no macOS
catalog. In practice this is fine: macOS and Linux both run .NET on Unix, so the cmdlet and type surface is nearly identical. The Ubuntu
profile effectively covers macOS. If Microsoft ever ships a macOS catalog, we add it to the list.

**Platform-aware installers** (see [controlling-systemwide-deps](controlling-systemwide-deps.md)) abstract package manager differences.
`Install-Python` calls `winget` on Windows and `apt-get` on Linux. The caller never writes platform-specific install logic.

**`Join-Path` and `[IO.Path]::Combine`** handle separators correctly on both platforms. Hardcoded `/` or `\` in paths is always wrong.

## Decision

All automation code must run on both Windows and Linux. Developers must be able to test locally on Windows/MacOS everything that runs in CI
on Linux.

### How this is enforced

- **PSScriptAnalyzer compatibility rules** — `PSUseCompatibleCmdlets` and `PSUseCompatibleTypes` flag cmdlets and .NET types not available
  on all target platforms. The rules, their profiles, and their on/off state live in `PSScriptAnalyzerSettings.psd1`.

- **L2 tests run locally.** Developers run the same `Test-ScriptAnalyzer.Tests.ps1` suite that CI runs. Platform compatibility violations
  are caught before push, not after.

## Consequences

- Code that passes L2 tests locally on Windows is validated against Linux compatibility without needing a Linux machine.
- CI failures caused by platform-specific code are caught before push, not in the pipeline queue.
- Developers can debug any CI issue locally because the code paths are identical.
- Platform-specific concerns are isolated to `Install-*` functions and gated with `$IsWindows` / `$IsLinux`. The rest of the codebase is
  platform-agnostic.
- Path handling is consistent everywhere — `Join-Path` is the only way to build paths.
- New platforms (macOS) can be added by extending the `Install-*` functions without touching business logic.
