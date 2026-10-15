---
catzc:
  derived:
    path: docs/references/automation/catzc-base-globs/tests/Get-ChangedFile.Tests.ps1.md
    kind: test-asset
    body_sha: "8c84ac8dea90"
    adrs:
      - ADR-FLOW-CD-GLOBS#4
---

# automation/Catzc.Base.Globs/tests/Get-ChangedFile.Tests.ps1

<!-- cspell:ignore nsrc -->

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Get-ChangedFile' -Tag 'L0', 'logic' {`.

```text
The diff universe ([ADR-FLOW-CD-GLOBS#4](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs4)): changed paths
from `git diff --name-only --no-renames`, repo-relative,
quotepath off, renames split so both the old and new path count.
```
