---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/Get-LogicTestIdentityFinding.Tests.ps1.md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "51fa2e2d3d46"
---

# automation/Catzc.Base.QualityGates/tests/Get-LogicTestIdentityFinding.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$script:live = @{`, written with `#`.

```text
A SYNTHETIC live-identity map: 'contoso' stands in for a live customer. It is deliberately NOT a real
shipped identity, so this very test file (which must contain the token to exercise the finder) is not
itself flagged by Test-LogicTestIdentity. The finder's logic is identical for any token set.
```
