---
catzc:
  immutable:
    with_body_sha: "93e86afe9fa8"
    path: docs/references/automation/catzc-base-docs/types/GlossaryAvoid.cs.md
    folder: docs/references/automation/catzc-base-docs/types
    name: glossary-avoid-cs
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-AUTO-TYPES#8
      - ADR-REPO-VOCAB#5
---

# automation/Catzc.Base.Docs/types/GlossaryAvoid.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
One avoided phrasing of a glossary concept (a configs/glossary.yml `avoid:` entry): the phrase that must not
appear in prose within the source's scope, and what to say instead. Mirrors the YAML entry (snake_case keys,
[ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)). The phrase is stored lower-cased — matching is
case-insensitive and word-bounded — and the
phrase and its replacement are both required, so a violation can always name the fix. See
[ADR-REPO-VOCAB#5](/docs/adr/repository/controlled-vocabulary.md#rule-adr-repo-vocab5).
```
