---
catzc:
  immutable:
    with_body_sha: ecf96c04e49c
    path: docs/references/automation/catzc-base-qualitygates/private/Write-TestAutomationRuleCoverage.ps1.md
    folder: docs/references/automation/catzc-base-qualitygates/private
    name: write-test-automation-rule-coverage-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Base.QualityGates/private/Write-TestAutomationRuleCoverage.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$testEnforcers = @{}`, written with `#`.

```text
Enforcers per rule id, split by kind. Sets so a rule cited by many tests, or an analyzer listed twice,
counts each enforcer once.
```
