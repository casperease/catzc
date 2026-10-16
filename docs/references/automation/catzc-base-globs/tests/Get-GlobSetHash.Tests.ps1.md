---
catzc:
  derived:
    path: docs/references/automation/catzc-base-globs/tests/Get-GlobSetHash.Tests.ps1.md
    kind: comment-page
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "25dcad567406"
    adrs:
      - ADR-FLOW-CD-GLOBS#5
---

# automation/Catzc.Base.Globs/tests/Get-GlobSetHash.Tests.ps1

<!-- cspell:ignore ntwo -->

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Get-GlobSetHash' -Tag 'L1', 'logic' {`, written with `#`.

```text
The durable SHA ([ADR-FLOW-CD-GLOBS#5](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs5)):
64-hex-lowercase, EOL-insensitive, path-folded, ordinal, with the
<path>|missing marker for an unstaged deletion.
```
