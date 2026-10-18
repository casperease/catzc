# ADR: Must be cross-platform

## Rules: ADR-AUTO-XPLAT

### Rule ADR-AUTO-XPLAT:3

Never hardcode a platform-specific path: a drive letter (`C:\`), a Unix-only directory (`/tmp/`), or a variable that one platform alone sets
(a Windows profile folder). Resolve every path from a known anchor — the working root, the code root, or the platform's temp directory — and
build it with the engine's path-joining primitive, never by writing a separator.

- [What breaks in practice](#what-breaks-in-practice)

### Rule ADR-AUTO-XPLAT:6

Format and parse machine-bound strings (timestamps, numbers, dates) in the invariant culture, named explicitly at each format and parse,
never in the current culture. Converting to UTC fixes the instant, not the rendering.

- [What breaks in practice](#what-breaks-in-practice)

### Rule ADR-AUTO-XPLAT:7

Respect case sensitivity in file operations — Linux filesystems are case-sensitive. A path comparison states its case rule explicitly, or
compares canonical full paths; it never relies on a default that behaves differently per platform.

- [What breaks in practice](#what-breaks-in-practice)

### Rule ADR-AUTO-XPLAT:9

Never shell out to a platform's own shell or a binary only one platform ships (`cmd /c`, `/bin/sh -c`). Use the engine's own operations, or
a tool that exists on every platform.

- [What breaks in practice](#what-breaks-in-practice)

## Context

Our workstations run Windows, maybe MacOS, maybe Linux. Our CI runs Linux. MacOs is a unix based os, so is linux, so we can reduce to
Windows and Linux for most. Everything we write must work on both — and a developer must be able to test locally everything that runs in CI.

The runtime is cross-platform by design, but the _code_ people write in it often is not: platform-only APIs, hardcoded separators and paths,
and shell-outs to binaries the other OS does not have all work fine on the author's machine and fail silently or loudly in CI. The concrete
PowerShell hazards — and the analyzer profiles that catch them at analysis time — are the language layer,
[cross-platform-powershell](../pwsh/cross-platform-powershell.md) (`ADR-PWSH-XPLAT`).

The usual response is "it works in CI, we'll fix it if it breaks." This is backwards. A developer should never have to push to CI to
discover a platform bug. If you can run it locally, you can debug it locally — fast feedback, no waiting for pipeline queues.

### What breaks in practice

Four failure axes are platform-independent facts every language obeys:

- **Hardcoded platform paths.** `C:\…`, `/tmp/…`, and OS-specific profile variables exist on one platform only; paths resolve from the
  repository anchors or the platform temp API instead.
- **Case sensitivity.** Unix filesystems are case-sensitive; a lookup that happens to match on Windows misses on Linux, so path comparison
  is explicit about case.
- **Culture.** The same OS with a different **culture** (da-DK vs en-US vs invariant) renders dates and numbers differently. CI typically
  runs invariant/en-US while a developer box may be da-DK, so a locale-dependent format is the classic "works on my machine, diff in the
  artifact" trap — and it silently changes data others parse. Converting to UTC fixes the instant, not the rendering; only an invariant
  format fixes the rendering.
- **Platform shells and binaries.** `cmd.exe` does not exist on Linux, and `/bin/sh` does not exist on Windows; a shell-out to either works
  on one platform only. A tool that ships on every platform, started directly, works on both.

The concrete PowerShell breakage tables — Windows-isms that fail on Unix and Unix-isms that fail on Windows — live in
[cross-platform-powershell](../pwsh/cross-platform-powershell.md), whose rules carry the PowerShell mechanics of each rule here: the path
anchors and joins of rule 3 (ADR-PWSH-XPLAT#2, ADR-PWSH-XPLAT#6), the invariant culture of rule 6 (ADR-PWSH-XPLAT#7), the path comparison of
rule 7 (ADR-PWSH-XPLAT#8), and the shell-outs of rule 9 (ADR-PWSH-XPLAT#4).

### How we enforce this

**The analyzer layer** ([cross-platform-powershell](../pwsh/cross-platform-powershell.md)) validates cmdlets and .NET types against the
target-platform profiles at analysis time, in the L2 tests, on every developer's machine — so a platform break is caught before push, not in
the pipeline queue.

**Platform-aware installers** (see [controlling-systemwide-deps](controlling-systemwide-deps.md)) abstract package manager differences.
`Install-NodeJs` calls `winget` on Windows and `apt-get` on Linux. The caller never writes platform-specific install logic.

## Decision

All automation code must run on both Windows and Linux. Developers must be able to test locally on Windows/MacOS everything that runs in CI
on Linux.

### How this is enforced

- **The analyzer layer** — the compatibility rules, their profiles, and their on/off state are
  [cross-platform-powershell](../pwsh/cross-platform-powershell.md) (`ADR-PWSH-XPLAT`).

- **L2 tests run locally.** Developers run the same analyzer test file that CI runs. Platform compatibility violations are caught before
  push, not after.

- **One entry, everywhere.** A pipeline step calls the same tool installers and importer entry a developer runs, never a script of its own —
  the one code path of [devbox-pipeline-parity](devbox-pipeline-parity.md#rule-adr-auto-parity1).

## Consequences

- Code that passes the local quality gates is validated against the other platform without needing a machine running it.
- CI failures caused by platform-specific code are caught before push, not in the pipeline queue.
- Developers can debug any CI issue locally because the code paths are identical.
- Platform-specific concerns are isolated to the installer layer; the rest of the codebase is platform-agnostic.
