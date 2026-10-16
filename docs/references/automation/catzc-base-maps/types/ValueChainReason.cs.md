---
catzc:
  immutable:
    with_body_sha: "13bc199269bc"
    path: docs/references/automation/catzc-base-maps/types/ValueChainReason.cs.md
    folder: docs/references/automation/catzc-base-maps/types
    name: value-chain-reason-cs
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-AUTO-TYPES#8
      - ADR-DSGN-TRACK#{14,15}
---

# automation/Catzc.Base.Maps/types/ValueChainReason.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
Why a value-chain highlight lights a cell for one ADR: the requested citation, the ADR code, its ADR domain and that
domain's row of the value-chain stack ([ADR-DSGN-TRACK#14](/docs/adr/design/tracks.md#rule-adr-dsgn-track14)), the
value-chain concern of the lit cell, and the ADR's value-chain concerns with the ADR domain's default
([ADR-DSGN-TRACK#15](/docs/adr/design/tracks.md#rule-adr-dsgn-track15)): Override is true when the ADR declares its
own concerns instead of the default. A result type, so the properties are PascalCase
([ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).
```
