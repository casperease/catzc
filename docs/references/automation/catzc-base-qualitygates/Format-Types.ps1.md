---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/Format-Types.ps1.md
    kind: comment-page
    language: markdown
    filekind: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: a8ed9f652f1a
    adrs:
      - ADR-PWSH-PESTER#9
---

# automation/Catzc.Base.QualityGates/Format-Types.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

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
