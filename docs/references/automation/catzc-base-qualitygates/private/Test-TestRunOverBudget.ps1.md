---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Test-TestRunOverBudget.ps1.md
    kind: comment-page
    body_sha: "29fe94a06bc0"
    adrs:
      - ADR-AUTO-FAILFAST#7
      - ADR-AUTO-TEST#44
    links: []
---

# automation/Catzc.Base.QualityGates/private/Test-TestRunOverBudget.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The whole-run budget fails a devbox run that outlasts it
([ADR-AUTO-TEST#44](/docs/adr/automation/test-automation.md#rule-adr-auto-test44)) — the time safeguard's fail-fast
stance applied to the run itself ([ADR-AUTO-FAILFAST#7](/docs/adr/automation/fail-fast-with-asserts.md#rule-adr-auto-failfast7)):
a slow run is a defect to fix, not a wait to absorb, and the budget is a roof that is never raised to make a run
pass. A pipeline run is bounded by its stage's own limit instead, so it never fails here. A failing run says so on the console,
with its time and the budget.
```
