---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/Write-TestAutomationRuleCoverage.Tests.ps1.md
    kind: test-asset
    body_sha: "03c72cbedf8b"
---

# automation/Catzc.Base.QualityGates/tests/Write-TestAutomationRuleCoverage.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `$script:allRuleIds = @('ADR-FAKE#1', 'ADR-FAKE#8', 'ADR-FAKE#3',...`.

```text
A fake rule universe (not the real docs) keeps this hermetic — the writer is a pure function of its
inputs. Two rules covered by tests, two by analyzers, one by neither.
```
