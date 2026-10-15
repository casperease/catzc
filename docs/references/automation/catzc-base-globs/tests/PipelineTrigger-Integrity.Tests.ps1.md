---
catzc:
  derived:
    path: docs/references/automation/catzc-base-globs/tests/PipelineTrigger-Integrity.Tests.ps1.md
    kind: test-asset
    body_sha: "5dac231d3889"
    adrs:
      - ADR-FLOW-CD-GLOBS#1
---

# automation/Catzc.Base.Globs/tests/PipelineTrigger-Integrity.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'ADO pipeline trigger globs match the globset projection' -Tag 'L2',...`.

```text
Integrity: every pipeline-bound globset's ADO pipeline (and the GitHub CI workflow) declares the trigger
path filters its projection computes — the drift quality gates over THIS repo's real pipeline files
([ADR-FLOW-CD-GLOBS#1](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs1)).
A source-path filter hand-edited out of sync with globs.yml fails here.
```
