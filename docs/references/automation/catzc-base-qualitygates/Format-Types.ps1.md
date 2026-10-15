---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/Format-Types.ps1.md
    kind: comment-page
    body_sha: "2c5503b2a362"
    adrs:
      - ADR-PWSH-PESTER#9
---

# automation/Catzc.Base.QualityGates/Format-Types.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:4

Above `$automationRoot = [System.IO.Path]::GetFullPath((Join-Path $root 'automation'))`.

```text
[System.IO] enumeration: each cmdlet call on this path adds about 20ms.
[ADR-PWSH-PESTER#9](/docs/adr/pwsh/pester-testing.md#rule-adr-pwsh-pester9)
```

## comment:5

Above `if ($original -notmatch '(?m)^\s*namespace\s+\S+?\s*;' -and $original -match...`.

```text
A block-scoped `namespace X { … }` is not a shape this repo authors, and rewriting it is not a one-line
fix: report it for a hand edit instead.
```
