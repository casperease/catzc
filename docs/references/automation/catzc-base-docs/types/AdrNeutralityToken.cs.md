---
catzc:
  immutable:
    with_body_sha: "0659863137bc"
    path: docs/references/automation/catzc-base-docs/types/AdrNeutralityToken.cs.md
    folder: docs/references/automation/catzc-base-docs/types
    name: adr-neutrality-token-cs
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-AUTO-TYPES#8
---

# automation/Catzc.Base.Docs/types/AdrNeutralityToken.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System.Collections.Generic;`, written with `//`.

```text
One forbidden token of the engine-neutrality check (configs/adr-checks.yml, engine_neutrality.tokens): a kebab-case name and a
case-sensitive .NET regular expression that matches engine-specific syntax in a rule summary. Mirrors the YAML entry (snake_case,
[ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)); built and validated by
AdrNeutralityCheck, which rejects a name that is not kebab-case and a pattern that does not compile.
```
