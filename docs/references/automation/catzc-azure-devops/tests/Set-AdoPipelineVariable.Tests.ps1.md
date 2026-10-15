---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-devops/tests/Set-AdoPipelineVariable.Tests.ps1.md
    kind: test-asset
    body_sha: "9b7d144dc5bf"
---

# automation/Catzc.Azure.DevOps/tests/Set-AdoPipelineVariable.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `BeforeAll {`.

```text
The ##vso line goes through the writer chokepoint, which a test run silences; lift the guard so the tests can
capture it (every call below captures with 6>&1, so nothing reaches a real pipeline log).
The guard exists only under Test-Automation, so it is read strict-clean and, when it was absent, removed again.
```
