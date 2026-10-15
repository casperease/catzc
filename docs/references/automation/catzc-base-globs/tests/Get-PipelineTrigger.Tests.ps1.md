---
catzc:
  derived:
    path: docs/references/automation/catzc-base-globs/tests/Get-PipelineTrigger.Tests.ps1.md
    kind: test-asset
    body_sha: ddf8ef987248
    adrs:
      - ADR-FLOW-CD-GLOBS#1
---

# automation/Catzc.Base.Globs/tests/Get-PipelineTrigger.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Get-PipelineTrigger' -Tag 'L0', 'logic' {`.

```text
Get-PipelineTrigger: read a pipeline/workflow YAML's actual trigger path filters
([ADR-FLOW-CD-GLOBS#1](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs1)) — the
on-disk side the drift quality gate compares against the computed projection.
```
