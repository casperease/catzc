# pwsh/Base.Docs/types/GlossaryRealization.cs

How a glossary concept exists in the repository (a `realized_by:` mapping): a kind from a closed set and, for every kind except
`prose-only`, the pattern that locates it, a repo-relative glob, a tag or an identifier, never a URL (every glossary source and reference
stays in the repository,
[ADR-REPO-VOCAB-SOURCESINREPOSITORY](../../../../drs/repository/controlled-vocabulary.md#rule-adr-repo-vocab-sourcesinrepository)).

A `prose-only` concept is a pure vocabulary term with nothing in code to enforce
([ADR-REPO-VOCAB-REALIZEDBY](../../../../drs/repository/controlled-vocabulary.md#rule-adr-repo-vocab-realizedby)), so it carries no pattern.
The type mirrors the YAML mapping, snake_case keys
([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)).
