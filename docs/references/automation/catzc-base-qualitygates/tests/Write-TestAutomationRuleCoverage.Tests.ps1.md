---
catzc:
  immutable:
    with_body_sha: "9c64673977d6"
    path: docs/references/automation/catzc-base-qualitygates/tests/Write-TestAutomationRuleCoverage.Tests.ps1.md
    folder: docs/references/automation/catzc-base-qualitygates/tests
    name: write-test-automation-rule-coverage-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Base.QualityGates/tests/Write-TestAutomationRuleCoverage.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$script:allRuleIds = @('ADR-FAKE#1', 'ADR-FAKE#8', 'ADR-FAKE#3',...`, written with `#`.

```text
A fake rule universe (not the real docs) keeps this hermetic — the writer is a pure function of its
inputs. Two rules covered by tests, two by analyzers, one by neither.
```
