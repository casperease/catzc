---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/Test-Change.Tests.ps1.md
    kind: test-asset
    body_sha: "0deb19700282"
    adrs:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.QualityGates/tests/Test-Change.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter',...`.

```text
Test-Change wiring: the plan's two halves (Get-ChangeTestFile, Get-ChangeCheckPlan) are their own units and are mocked
here; Invoke-TestFile is the mocked test-run boundary; the gates are fixture functions, so the real Get-Command lookup
and the [string[]] -Path test decide how each is called. Neutral fixture names
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```

## comment:2

Above `function global:Test-WidgetLint {`.

```text
A gate that takes the changed files, one that only runs whole, and one that throws.
It names every path it was given, so its issue shows what Test-Change passed.
```
