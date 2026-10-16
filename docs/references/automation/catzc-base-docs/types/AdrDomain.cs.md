---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/types/AdrDomain.cs.md
    kind: comment-page
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "0a0e9b77f768"
    adrs:
      - ADR-AUTO-TYPES#9
      - ADR-DSGN-TRACK#{14,15}
---

# automation/Catzc.Base.Docs/types/AdrDomain.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System.Collections.Generic;`, written with `//`.

```text
One ADR domain (a docs/adr/<area>/ folder) from adrs.yml: its Name, 2-4 letter Code, Role, the reader-facing
Description rendered under the domain's heading in the generated index, the DependsOn links that form the
domain DAG, its row of the value-chain stack (Stack), its default value-chain concerns (Concerns, in value-chain
order), and the RuleSets it owns. Built and validated by AdrsConfig
([ADR-AUTO-TYPES#9](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types9),
[ADR-DSGN-TRACK#14](/docs/adr/design/tracks.md#rule-adr-dsgn-track14),
[ADR-DSGN-TRACK#15](/docs/adr/design/tracks.md#rule-adr-dsgn-track15)).
```
