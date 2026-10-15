---
catzc:
  derived:
    path: docs/references/automation/catzc-base-globs/tests/Get-GlobSetHash.Tests.ps1.md
    kind: test-asset
    body_sha: "3fd662cdf69e"
    adrs:
      - ADR-FLOW-CD-GLOBS#5
---

# automation/Catzc.Base.Globs/tests/Get-GlobSetHash.Tests.ps1

<!-- cspell:ignore ntwo -->

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Get-GlobSetHash' -Tag 'L1', 'logic' {`.

```text
The durable SHA ([ADR-FLOW-CD-GLOBS#5](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs5)):
64-hex-lowercase, EOL-insensitive, path-folded, ordinal, with the
<path>|missing marker for an unstaged deletion.
```
