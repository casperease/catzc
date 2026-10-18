# pwsh/Catzc.Base.Docs/types/AdrRuleSet.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System.Collections.Generic;`, written with `//`.

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
