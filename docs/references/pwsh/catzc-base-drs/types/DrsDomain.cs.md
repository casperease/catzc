# pwsh/Catzc.Base.Drs/types/DrsDomain.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System.Collections.Generic;`, written with `//`.

```text
One ADR domain (a docs/drs/<area>/ folder) from drs.yml: its Name, 2-4 letter Code, Role, the reader-facing
Description rendered under the domain's heading in the generated index, the DependsOn links that form the
domain DAG, its row of the value-chain stack (Stack), its default value-chain concerns (Concerns, in value-chain
order), and the RuleSets it owns. Built and validated by DrsConfig
([ADR-BCL-TYPES-NATIVETYPEDMODEL](/docs/drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-nativetypedmodel),
[DDR-TRACK-VALUECHAINSTACK](/docs/drs/design/tracks.md#rule-ddr-track-valuechainstack),
[DDR-TRACK-VALUECHAINCONCERN](/docs/drs/design/tracks.md#rule-ddr-track-valuechainconcern)).
```

## comment:2

Above `public string Code { get; }`, written with `//`.

```text
null under a kind the domain owns
([ADR-REPO-DRSCODE-DOMAINSEGMENT](/docs/drs/repository/drs-code-language.md#rule-adr-repo-drscode-domainsegment))
```
