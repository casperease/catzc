---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/types/TerminologyTerm.cs.md
    kind: comment-page
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: ca2933103521
    adrs:
      - ADR-AUTO-SPELL#{5,8}
---

# automation/Catzc.Base.QualityGates/types/TerminologyTerm.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
One approved-vocabulary entry from configs/terminology.yml — a term and its meaning. Its category is the
group it is listed under in the registry (terms: <category>: [...]), passed in by TerminologyConfig, so
the entry itself carries no category key. An abbreviation carries its full-word expansion; the other
categories do not. Mirrors a terminology.yml entry (snake_case keys). See
[ADR-AUTO-SPELL](/docs/adr/automation/spell-out-names.md)
([ADR-AUTO-SPELL#5](/docs/adr/automation/spell-out-names.md#rule-adr-auto-spell5)-[ADR-AUTO-SPELL#8](/docs/adr/automation/spell-out-names.md#rule-adr-auto-spell8)).

Derives from Catzc.Base.Objects.DictionaryRecord, so an instance also presents as a read-only dictionary
over its own properties and its constructor uses the base's Req/OptStr extraction helpers.
```

## comment:2

Above `public string category { get; }`, written with `//`.

```text
The group this term is listed under (a defined category). Supplied by TerminologyConfig from the
registry's terms: <category>: grouping, not read from the entry.
```
