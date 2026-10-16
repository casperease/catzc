---
catzc:
  derived:
    path: docs/references/automation/catzc-base-globs/tests/Get-GlobSetFile.Tests.ps1.md
    kind: comment-page
    language: markdown
    filekind: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: f6d8ae0fc35c
    adrs:
      - ADR-FLOW-CD-GLOBS#{4,5}
---

# automation/Catzc.Base.Globs/tests/Get-GlobSetFile.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Get-GlobSetFile' -Tag 'L0', 'logic' {`, written with `#`.

```text
The member list: tracked universe ∩ globset membership, ordinally sorted
([ADR-FLOW-CD-GLOBS#4](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs4),
[ADR-FLOW-CD-GLOBS#5](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs5)).
```
