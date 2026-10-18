---
catzc:
  immutable:
    with_body_sha: a8ed9f652f1a
    repo_status: locked
    path: docs/references/automation/catzc-base-qualitygates/Format-Types.ps1.md
    folder: docs/references/automation/catzc-base-qualitygates
    name: format-types-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-PWSH-PESTER#9
---

# automation/Catzc.Base.QualityGates/Format-Types.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Maintains the file-scoped namespace on each C# type source, derived from its module folder.

### description

Every automation C# type lives at `automation/<Module>/types/<Type>.cs` and belongs to namespace `<Module>`
(ADR native-csharp-types). The namespace is NOT hand-authored: this formatter writes/repairs the
`namespace <Module>;` line from the file's folder, so the folder stays the single source of truth and a
move between modules is a safe refactor — re-running Format-Types rewrites the line to the new folder, and
Test-Formatting (its -DryRun) fails CI on any drift. The declared namespace is what lets the editor's C#
toolchain compile and analyze these files (no CA1050), so the rule is visible in-editor (everything-as-code).

For each `types/*.cs`: the line is inserted after the leading comment/using block (before the first type or
attribute) when absent, corrected when it names the wrong module, and left untouched when already correct.
Files are written back as UTF-8 without a BOM with LF line endings (repo convention). Logic is never
changed — only the namespace line. A block-scoped `namespace X { … }` is the one shape it cannot fix: it is
left untouched and reported in BlockScopedFiles (Test-Formatting turns each into an issue).

A source-tree tool: it rewrites the repository's type sources, so it throws in build mode
(Assert-SourceTree).

### parameter Path

One or more files or directories to process. Defaults to every `automation/<Module>/types/*.cs` file.

### parameter DryRun

Report which files would change without writing them (the returned list is the same either way).

### parameter PassThru

Return a result object ({ ChangedCount, ChangedFiles, BlockScopedFiles, DryRun }) instead of only logging.

### outputs

`[string[]]` The paths of the files that changed (or, under -DryRun, would change).

### example 1

```powershell
Format-Types
```

### example 2

```powershell
Format-Types -DryRun
```

## comment:1

Above `$automationRoot = [System.IO.Path]::GetFullPath((Join-Path $root 'automation'))`, written with `#`.

```text
[System.IO] enumeration: each cmdlet call on this path adds about 20ms.
[ADR-PWSH-PESTER#9](/docs/adr/pwsh/pester-testing.md#rule-adr-pwsh-pester9)
```

## comment:2

Above `if ($original -notmatch '(?m)^\s*namespace\s+\S+?\s*;' -and $original -match...`, written with `#`.

```text
A block-scoped `namespace X { … }` is not a shape this repo authors, and rewriting it is not a one-line
fix: report it for a hand edit instead.
```
