---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/Get-LogicTestIdentityFinding.Tests.ps1.md
    kind: test-asset
    body_sha: "446dccc69cd5"
---

# automation/Catzc.Base.QualityGates/tests/Get-LogicTestIdentityFinding.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `$script:live = @{`.

```text
A SYNTHETIC live-identity map: 'contoso' stands in for a live customer. It is deliberately NOT a real
shipped identity, so this very test file (which must contain the token to exercise the finder) is not
itself flagged by Test-LogicTestIdentity. The finder's logic is identical for any token set.
```
