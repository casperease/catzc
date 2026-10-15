---
catzc:
  derived:
    path: docs/references/automation/scriptanalyzer/NoAutomaticVariableMisuse.psm1.md
    kind: comment-page
    body_sha: "32dbdb63cf5b"
    adrs:
      - ADR-PWSH-FORMAT#6
---

# automation/.scriptanalyzer/NoAutomaticVariableMisuse.psm1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
$? is overwritten by every statement, making it impossible to check
reliably. Use -ErrorAction Stop and try/catch for cmdlets, or
Assert-LastExitCodeWasZero for native commands.

See ADR: automatic-variable-pitfalls.
```

## comment:2

Above `$isQuestionMarkVariable = {`.

```text
Predicate as a local, not inlined in FindAll's parens — dodges a cross-version indent skew
([ADR-PWSH-FORMAT#6](/docs/adr/pwsh/powershell-formatting.md#rule-adr-pwsh-format6)).
```
