---
catzc:
  immutable:
    with_body_sha: a23a990e0593
    repo_status: locked
    path: docs/references/automation/catzc-base-qualitygates/tests/types/SourceConventionsConfig.Tests.ps1.md
    folder: docs/references/automation/catzc-base-qualitygates/tests/types
    name: source-conventions-config-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-AUTO-DEFAULT#6
---

# automation/Catzc.Base.QualityGates/tests/types/SourceConventionsConfig.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'SourceConventionsConfig' -Tag 'L0' {`, written with `#`.

```text
SourceConventionsConfig maps source-conventions.yml: an omitted check takes every default of its type
([ADR-AUTO-DEFAULT#6](/docs/adr/automation/sensible-defaults.md#rule-adr-auto-default6)), and an unknown key fails at
construction.
```
