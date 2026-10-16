---
catzc:
  derived:
    path: docs/references/automation/scriptanalyzer/NoEnvRepositoryRoot.psm1.md
    folder: docs/references/automation/scriptanalyzer
    name: no-env-repository-root-psm1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "1bf36336d5bd"
    adrs:
      - ADR-PWSH-FORMAT#6
---

# automation/.scriptanalyzer/NoEnvRepositoryRoot.psm1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `function Measure-NoEnvRepositoryRoot {`, written with `#`.

```text
.SYNOPSIS
    Custom PSScriptAnalyzer rule: module function files read the repository root through Get-RepositoryRoot.
.DESCRIPTION
    One accessor reads the root, so where the root comes from can change in one place; a write is not flagged.
    [comment:1](/docs/references/automation/scriptanalyzer/NoEnvRepositoryRoot.psm1.md#comment1)
```

## comment:2

Above `$isVariable = {`, written with `#`.

```text
Predicate as a local, not inlined in FindAll's parens — dodges a cross-version indent skew
([ADR-PWSH-FORMAT#6](/docs/adr/pwsh/powershell-formatting.md#rule-adr-pwsh-format6)).
```
