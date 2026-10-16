---
catzc:
  derived:
    path: docs/references/automation/catzc-base-globs/tests/Get-PipelineTrigger.Tests.ps1.md
    kind: comment-page
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "63b48f8ba3ad"
    adrs:
      - ADR-FLOW-CD-GLOBS#1
---

# automation/Catzc.Base.Globs/tests/Get-PipelineTrigger.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Get-PipelineTrigger' -Tag 'L0', 'logic' {`, written with `#`.

```text
Get-PipelineTrigger: read a pipeline/workflow YAML's actual trigger path filters
([ADR-FLOW-CD-GLOBS#1](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs1)) — the
on-disk side the drift quality gate compares against the computed projection.
```
