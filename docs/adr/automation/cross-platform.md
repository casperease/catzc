# ADR: Must be cross-platform

## Rules: ADR-XPLAT

### Rule ADR-XPLAT:3

Never hardcode platform-specific paths (`C:\`, `/tmp/`, `$env:APPDATA`). Use `$env:RepositoryRoot`, `$PSScriptRoot`,
`[IO.Path]::GetTempPath()`, or `Join-Path` from a known anchor.

- [What breaks in practice](#what-breaks-in-practice)

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

The runtime is cross-platform by design, but the _code_ people write in it often is not: platform-only APIs, hardcoded separators and paths,
and shell-outs to binaries the other OS does not have all work fine on the author's machine and fail silently or loudly in CI. The concrete
PowerShell hazards — and the analyzer profiles that catch them at analysis time — are the language layer,
[cross-platform-powershell](powershell/cross-platform-powershell.md) (`ADR-PSXPLAT`).

The usual response is "it works in CI, we'll fix it if it breaks." This is backwards. A developer should never have to push to CI to
discover a platform bug. If you can run it locally, you can debug it locally — fast feedback, no waiting for pipeline queues.

### What breaks in practice

Three failure axes are platform-independent facts every language obeys:

- **Hardcoded platform paths.** `C:\…`, `/tmp/…`, and OS-specific profile variables exist on one platform only; paths resolve from the
  repository anchors or the platform temp API instead.
- **Case sensitivity.** Unix filesystems are case-sensitive; a lookup that happens to match on Windows misses on Linux, so path comparison
  is explicit about case.
- **Culture.** The same OS with a different **culture** (da-DK vs en-US vs invariant) renders dates and numbers differently. CI typically
  runs invariant/en-US while a developer box may be da-DK, so a locale-dependent format is the classic "works on my machine, diff in the
  artifact" trap — and it silently changes data others parse. Converting to UTC fixes the instant, not the rendering; only an invariant
  format fixes the rendering.

The concrete PowerShell breakage tables — Windows-isms that fail on Unix and Unix-isms that fail on Windows — live in
[cross-platform-powershell](powershell/cross-platform-powershell.md).

### How we enforce this

**The analyzer layer** ([cross-platform-powershell](powershell/cross-platform-powershell.md)) validates cmdlets and .NET types against the
target-platform profiles at analysis time, in the L2 test suite, on every developer's machine — so a platform break is caught before push,
not in the pipeline queue.

**Platform-aware installers** (see [controlling-systemwide-deps](controlling-systemwide-deps.md)) abstract package manager differences.
`Install-Python` calls `winget` on Windows and `apt-get` on Linux. The caller never writes platform-specific install logic.

## Decision

All automation code must run on both Windows and Linux. Developers must be able to test locally on Windows/MacOS everything that runs in CI
on Linux.

### How this is enforced

- **The analyzer layer** — the compatibility rules, their profiles, and their on/off state are
  [cross-platform-powershell](powershell/cross-platform-powershell.md) (`ADR-PSXPLAT`).

- **L2 tests run locally.** Developers run the same `Test-ScriptAnalyzer.Tests.ps1` suite that CI runs. Platform compatibility violations
  are caught before push, not after.

## Consequences

- Code that passes the local gates is validated against the other platform without needing a machine running it.
- CI failures caused by platform-specific code are caught before push, not in the pipeline queue.
- Developers can debug any CI issue locally because the code paths are identical.
- Platform-specific concerns are isolated to the installer layer; the rest of the codebase is platform-agnostic.

## Dora explains:

DORA's research links multi-platform software development to reliable deployment across diverse infrastructure. Writing platform-agnostic
code and running the same code paths locally and in CI ensures bugs are caught early and deployments work uniformly across environments.

- [Flexible infrastructure](https://dora.dev/capabilities/flexible-infrastructure/) — platform-agnostic patterns and abstractions enable
  deployments across Windows, Linux, and macOS without rewriting.
- [Continuous integration](https://dora.dev/capabilities/continuous-integration/) — developers test CI code paths locally on any platform,
  catching platform-specific breakage before pipeline runs.
- [Code maintainability](https://dora.dev/capabilities/code-maintainability/) — platform concerns isolated to installers keep the rest of
  the codebase clear and prevent accidental platform-specific APIs.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.
