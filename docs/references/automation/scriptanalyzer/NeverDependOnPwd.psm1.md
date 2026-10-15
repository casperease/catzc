---
catzc:
  derived:
    path: docs/references/automation/scriptanalyzer/NeverDependOnPwd.psm1.md
    kind: comment-page
    body_sha: cfd94b653878
    adrs:
      - ADR-AUTO-NOPWD#1
      - ADR-PWSH-FORMAT#6
      - ADR-PWSH-PWD#2
---

# automation/.scriptanalyzer/NeverDependOnPwd.psm1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Flags:
- References to $PWD (use $PSScriptRoot or $env:RepositoryRoot instead)
- Bare Set-Location / cd calls (use Push-Location / Pop-Location instead)
See [ADR-AUTO-NOPWD#1](/docs/adr/automation/never-depend-on-pwd.md#rule-adr-auto-nopwd1) and
[ADR-PWSH-PWD#2](/docs/adr/pwsh/working-directory-mechanics.md#rule-adr-pwsh-pwd2)
```

## comment:2

Above `$isVariable = {`.

```text
Flag $PWD references
Predicate as a local, not inlined in FindAll's parens — dodges a cross-version indent skew
([ADR-PWSH-FORMAT#6](/docs/adr/pwsh/powershell-formatting.md#rule-adr-pwsh-format6)).
```

## comment:3

Above `$isCommand = {`.

```text
Flag Set-Location / cd calls (Push-Location / Pop-Location are fine)
Predicate as a local, not inlined in FindAll's parens — dodges a cross-version indent skew
([ADR-PWSH-FORMAT#6](/docs/adr/pwsh/powershell-formatting.md#rule-adr-pwsh-format6)).
```
