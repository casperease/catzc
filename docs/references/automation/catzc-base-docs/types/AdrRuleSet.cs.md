---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/types/AdrRuleSet.cs.md
    kind: reference
    body_sha: a237320d42f9
    adrs:
      - ADR-AUTO-TYPES#9
      - ADR-DSGN-TRACK#15
---

# automation/Catzc.Base.Docs/types/AdrRuleSet.cs

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System.Collections.Generic;`.

```text
One ADR rule-set (an ADR) as declared in adrs.yml: its internal kebab Slug, full External citation code
(ADR-<DC>-<NAME>), the effective domain Code (a leaf override, else the domain default DomainCode), the
folder-owning Domain and its Role, the optional Terminology token, the domain's row of the value-chain stack
(Stack), and the effective value-chain Concerns (a ruleset override, else the domain default DomainConcerns).
A processed record built and validated by AdrsConfig — not a raw YAML mirror, so PascalCase
([ADR-AUTO-TYPES](/docs/adr/automation/BCL/native-csharp-types.md),
[ADR-AUTO-TYPES#9](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types9),
[ADR-DSGN-TRACK#15](/docs/adr/design/tracks.md#rule-adr-dsgn-track15)).
```
