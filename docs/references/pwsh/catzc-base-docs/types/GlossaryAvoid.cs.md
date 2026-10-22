---
catzc:
  edges:
    cites:
      - ADR-BCL-TYPES-SNAKECASEMIRRORSYAML
      - ADR-REPO-VOCAB-AVOIDEDPHRASINGREPLACED
---

# pwsh/Catzc.Base.Docs/types/GlossaryAvoid.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
One avoided phrasing of a glossary concept (a configs/glossary.yml `avoid:` entry): the phrase that must not
appear in prose within the source's scope, and what to say instead. Mirrors the YAML entry (snake_case keys,
[ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](/docs/drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)). The phrase is stored lower-cased — matching is
case-insensitive and word-bounded — and the
phrase and its replacement are both required, so a violation can always name the fix. See
[ADR-REPO-VOCAB-AVOIDEDPHRASINGREPLACED](/docs/drs/repository/controlled-vocabulary.md#rule-adr-repo-vocab-avoidedphrasingreplaced).
```
