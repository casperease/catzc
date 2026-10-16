---
catzc:
  immutable:
    with_body_sha: "061494e70970"
    path: docs/references/automation/catzc-base-qualitygates/tests/types/CommentsConfig.Tests.ps1.md
    folder: docs/references/automation/catzc-base-qualitygates/tests/types
    name: comments-config-tests-ps1
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

# automation/Catzc.Base.QualityGates/tests/types/CommentsConfig.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'CommentsConfig' -Tag 'L0', 'logic' {`, written with `#`.

```text
CommentsConfig maps comments.yml and is the one declaration of its sensible defaults
([ADR-AUTO-DEFAULT#6](/docs/adr/automation/sensible-defaults.md#rule-adr-auto-default6)): an omitted key
behaves exactly like the default, and a malformed value fails at construction naming the key.
```
