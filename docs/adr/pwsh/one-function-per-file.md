---
catzc:
  derived:
    path: docs/adr/pwsh/one-function-per-file.md
    kind: adr
    language: markdown
    filekind: md
    track: docs
    body_sha: d121b8193149
    defines:
      - ADR-PWSH-ONEFUNC#{1-3}
    adrs:
      - ADR-AUTO-EXTEND#4
      - ADR-PWSH-USEPS#1
    links:
      - docs/adr/automation/effective-in-enterprises.md
      - docs/adr/automation/open-closed-architecture.md#rule-adr-auto-extend4
      - docs/adr/automation/platform-bundle.md
      - docs/adr/automation/zero-ceremony-poka-yoke.md#rule-adr-auto-zero2
      - docs/adr/design/run-modes.md
      - docs/adr/pwsh/dynamic-module-manifests.md#rule-adr-pwsh-manifest5
      - docs/adr/pwsh/use-ps1-not-psm1.md#source-and-the-generated-build
---

# ADR: One function per file

## Rules: ADR-PWSH-ONEFUNC

### Rule ADR-PWSH-ONEFUNC:1

Each `.ps1` file contains exactly one exported function, and the file name matches the function name (`Get-Foo.ps1` must contain
`function Get-Foo`). This is the mandatory file-name convention (ADR-AUTO-EXTEND#4) in PowerShell.

- [Decision](#decision)
- [How this is enforced](#how-this-is-enforced)

### Rule ADR-PWSH-ONEFUNC:2

Each function file pairs one-to-one with a test file named `Verb-Noun.Tests.ps1` (`Get-Foo.ps1` → `tests/Get-Foo.Tests.ps1`).

- [Why one function per file](#why-one-function-per-file)

### Rule ADR-PWSH-ONEFUNC:3

This rule and the `.ps1` function files of ADR-PWSH-USEPS#1 govern **source** under `automation/<Module>/`. The installed build's merged
`<Module>.functions.ps1` — every function of one module in one file, the module's single `NestedModules` entry — is a generated artifact of
`Build-Modules`, derived from the one-function source files, never edited by hand and never checked in. It keeps the `.ps1` extension, so
the module's functions share one session state as they do in source; the build asserts the rule on its input and fails when a source file
breaks it.

- [Source and the generated build](#source-and-the-generated-build)
- [use-ps1-not-psm1](use-ps1-not-psm1.md#source-and-the-generated-build)

## Context

[open-closed-architecture](../automation/open-closed-architecture.md#rule-adr-auto-extend4) makes "file name = function name" a mandatory
convention, and [zero-ceremony-poka-yoke](../automation/zero-ceremony-poka-yoke.md#rule-adr-auto-zero2) makes adding a function a matter of
adding a file. This ADR is that convention in PowerShell. We need a convention for how functions map to files within a module. The two
common approaches are:

1. **Multiple functions per file** — group related functions together, use AST parsing or manual export lists to determine what gets
   exported.
2. **One function per file** — each `.ps1` file contains exactly one function, the file name matches the function name (`Get-Foo.ps1` →
   `function Get-Foo`).

### Why one function per file

**File listing = module API.** Running `ls` on a module folder immediately shows every public function. No need to open files, read
manifests, or run `Get-Command -Module`. New contributors can understand a module's surface area in seconds.

**No AST parsing needed for exports.** When file name equals function name, the manifest generator can derive `FunctionsToExport` directly
from file names — a string operation, not a parse. AST parsing is slow (~25ms per file) and adds complexity. With one-function-per-file, the
bootstrap module just uses `$file.BaseName` and skips the parser entirely. This directly impacts import speed.

**Merge conflicts disappear.** When two people add functions to the same file, they conflict. When each function is its own file, parallel
work on different functions never touches the same file. Git blame is also trivially useful — each file has a single author history.

**Searchability.** Looking for `Get-Customer`? The file is `Get-Customer.ps1`. No grepping, no guessing which file it lives in. Every
editor's file-open dialog becomes a function search.

**Consistent granularity.** There is no judgment call about "which functions belong together" or when a file has grown too large and needs
splitting. The rule is mechanical: one function, one file, names match.

**Test file pairing.** Each function file pairs naturally with a test file: `Get-Foo.ps1` → `tests/Get-Foo.Tests.ps1`. No ambiguity about
which test file covers which function.

## Decision

Each `.ps1` file contains exactly one exported function. The file name matches the function name: `Get-Foo.ps1` must contain
`function Get-Foo`.

### Source and the generated build

Every reason above is about the code a developer reads, edits, reviews, and blames, so the rule applies to source. The installed build
([run-modes](../design/run-modes.md), [platform-bundle](../automation/platform-bundle.md)) serves a different reader: a machine that loads
the toolset and pays a per-file antivirus scan on a cold import ([effective-in-enterprises](../automation/effective-in-enterprises.md)). For
that reader `Build-Modules` merges a module's function files into one `<Module>.functions.ps1`
([dynamic-module-manifests](dynamic-module-manifests.md#rule-adr-pwsh-manifest5)), each function preceded by a `# source:` marker line that
names the file it came from, so an error inside the merged file traces back to its source file. The export list of the built manifest is the
file names of the module's root `.ps1` files — the rule is what makes the merged file's exports derivable without parsing it.

### How this is enforced

- **`Test-Automation.Tests.ps1`** — validates every `.ps1` file: file name must be `Verb-Noun` format, must contain exactly one function,
  and function name must match the file basename.
- **Test file naming** — the same test validates that every `.Tests.ps1` file also follows `Verb-Noun.Tests.ps1` format.
- **Bootstrap module** — `New-DynamicManifest` derives `FunctionsToExport` directly from `$file.BaseName`, so files that do not follow the
  convention will not export correctly.
- **`Build-Modules`** — re-asserts the rule on the source files' syntax trees before merging (exactly one function per file, named for the
  file, no top-level statements) and fails the build with every violation collected.

## Consequences

- File name is the function name — `$file.BaseName` is the export list
- AST parsing is eliminated from the bootstrap module's hot path
- Module contents are visible from a directory listing alone
- Each function has its own git history and blame
- Test files map 1:1 to function files
- Modules with many small functions will have many small files — this is acceptable and preferred over fewer large files
- The installed build holds one generated file per module, so the file count a machine opens at load is bounded by the module count, not the
  function count
