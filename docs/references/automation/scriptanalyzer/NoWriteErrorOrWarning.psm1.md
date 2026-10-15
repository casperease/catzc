---
catzc:
  derived:
    path: docs/references/automation/scriptanalyzer/NoWriteErrorOrWarning.psm1.md
    kind: comment-page
    body_sha: dbfe805d6f2e
    adrs:
      - ADR-PWSH-FORMAT#6
    links: []
---

# automation/.scriptanalyzer/NoWriteErrorOrWarning.psm1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
All errors are terminating — use throw or Assert-*.
All warnings are terminating ($WarningPreference = 'Stop') — there is
no middle ground between "fine" and "stop." Use Write-Message for
status, throw for failures.
```

## comment:2

Above `$isCommand = {`.

```text
Predicate as a local, not inlined in FindAll's parens — dodges a cross-version indent skew
([ADR-PWSH-FORMAT#6](/docs/adr/pwsh/powershell-formatting.md#rule-adr-pwsh-format6)).
```
