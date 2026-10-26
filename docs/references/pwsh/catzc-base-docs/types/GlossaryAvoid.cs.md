# pwsh/Base.Docs/types/GlossaryAvoid.cs

One avoided phrasing of a glossary concept (a `configs/glossary` `avoid:` entry): the phrase that must not appear in prose within the
source's scope, and what to say instead. It mirrors the YAML entry, snake_case keys
([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)).
See [ADR-REPO-VOCAB-AVOIDEDPHRASINGREPLACED](../../../../drs/repository/controlled-vocabulary.md#rule-adr-repo-vocab-avoidedphrasingreplaced).

## Properties

- **`phrase`** — stored lower-cased with its whitespace collapsed; matching is case-insensitive and word-bounded.
- **`say`** — the replacement wording. Both are required, so a violation can always name the fix.
