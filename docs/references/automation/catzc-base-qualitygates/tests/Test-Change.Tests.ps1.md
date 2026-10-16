---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/Test-Change.Tests.ps1.md
    kind: comment-page
    language: markdown
    filekind: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "082af78a09ca"
    adrs:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.QualityGates/tests/Test-Change.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter',...`, written with `#`.

```text
Test-Change wiring: the plan's two halves (Get-ChangeTestFile, Get-ChangeCheckPlan) are their own units and are mocked
here; Invoke-TestFile is the mocked test-run boundary; the gates are fixture functions, so the real Get-Command lookup
and the [string[]] -Path test decide how each is called. Neutral fixture names
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```

## comment:2

Above `function global:Test-WidgetLint {`, written with `#`.

```text
A gate that takes the changed files, one that only runs whole, and one that throws.
It names every path it was given, so its issue shows what Test-Change passed.
```
