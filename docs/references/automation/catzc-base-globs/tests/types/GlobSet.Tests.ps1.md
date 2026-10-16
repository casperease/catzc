---
catzc:
  derived:
    path: docs/references/automation/catzc-base-globs/tests/types/GlobSet.Tests.ps1.md
    folder: docs/references/automation/catzc-base-globs/tests/types
    name: glob-set-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: c75700990ee4
    adrs:
      - ADR-FLOW-CD-GLOBS#{4,8}
---

# automation/Catzc.Base.Globs/tests/types/GlobSet.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'GlobSet' -Tag 'L0', 'logic' {`, written with `#`.

```text
The globset record: membership is decided by the scan program — an ordered +/- rule list, last-match-wins
([ADR-FLOW-CD-GLOBS#4](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs4)), flattened through compose with
own-rules-last
([ADR-FLOW-CD-GLOBS#8](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs8)); and the constructor guards the
shape (kebab-case name, required description, a layer declared, include or compose present, no duplicate
patterns).
```
