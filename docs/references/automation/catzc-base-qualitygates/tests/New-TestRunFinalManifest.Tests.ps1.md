---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/New-TestRunFinalManifest.Tests.ps1.md
    kind: test-asset
    body_sha: b545687c783a
    adrs:
      - ADR-AUTO-TEST#32
---

# automation/Catzc.Base.QualityGates/tests/New-TestRunFinalManifest.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'New-TestRunFinalManifest' -Tag 'L0', 'logic' {`.

```text
New-TestRunFinalManifest over fixture inputs: the terminal run.json record, with and without a context, a worker
run, and an opt-out tag.
```

## comment:2

Above `Describe 'New-TestRunFinalManifest — a snapshot run, written and read back'...`.

```text
The run.json a reader sees for a run that collided with another
([ADR-AUTO-TEST#32](/docs/adr/automation/test-automation.md#rule-adr-auto-test32)): the terminal manifest built
from a snapshot worker run, written by Write-TestRunManifest, and read back as JSON — the shape a script that
watches concurrent runs reads, with no unit between them mocked.
```
