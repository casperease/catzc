---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Invoke-ImprintStep.ps1.md
    kind: comment-page
    body_sha: "56feace05904"
    adrs:
      - ADR-PRIN-CONFIG#2
---

# automation/Catzc.Base.QualityGates/private/Invoke-ImprintStep.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
A language is never named here: which language runs which step is configuration, not code.
[ADR-PRIN-CONFIG#2](/docs/adr/principles/configure-not-program.md#rule-adr-prin-config2)
```

## comment:2

Above `switch -CaseSensitive ($Step) {`.

```text
Each case first returns for an empty list, so a run with no files still proves the step has its adapter, and an empty list
never reaches a command whose default is the whole repository.
```

## comment:3

Above `switch -CaseSensitive ($Step) {`.

```text
Each case first returns for an empty list, so a run with no files still proves the step has its adapter, and an empty list
never reaches a command whose default is the whole repository.
```
