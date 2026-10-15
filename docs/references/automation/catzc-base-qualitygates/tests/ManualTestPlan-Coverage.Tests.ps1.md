---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/ManualTestPlan-Coverage.Tests.ps1.md
    kind: comment-page
    body_sha: a062b8ddd712
    adrs:
      - ADR-AUTO-TEST#{16,35}
---

# automation/Catzc.Base.QualityGates/tests/ManualTestPlan-Coverage.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Manual test plan covers every integrity check' -Tag 'L1',...`, written with `#`.

```text
Keeps the manual test plan's category files (docs/how-to/automation/manual-test-plan/) in sync with the tests, through its quality gate
(Test-ManualTestPlan — [ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)). The gate
derives the integrity blocks by PARSING the test files, never by booting Pester discovery
([ADR-AUTO-TEST#16](/docs/adr/automation/test-automation.md#rule-adr-auto-test16)). It is self-referential: this
Describe is integrity-tagged, so the plan lists it too. source-only: it reads the repository's test files and the
plan document, which give the same answer in both run modes.
```
