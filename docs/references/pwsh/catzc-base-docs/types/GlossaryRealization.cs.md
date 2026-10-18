# pwsh/Catzc.Base.Docs/types/GlossaryRealization.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
How a glossary concept exists in the repository (a configs/glossary.yml `realized_by:` mapping): a kind from a
closed set and, for every kind except prose-only, the pattern that locates it — a repo-relative glob, a tag, or
an identifier, never a URL (every glossary source and reference stays in the repository,
[ADR-REPO-VOCAB-SOURCESINREPOSITORY](/docs/adr/repository/controlled-vocabulary.md#rule-adr-repo-vocab-sourcesinrepository)). A
prose-only concept is a pure vocabulary term with nothing in code to enforce
([ADR-REPO-VOCAB-REALIZEDBY](/docs/adr/repository/controlled-vocabulary.md#rule-adr-repo-vocab-realizedby)), so it carries no
pattern. Mirrors the YAML mapping (snake_case keys,
[ADR-AUTO-TYPES-SNAKECASEMIRRORSYAML](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types-snakecasemirrorsyaml)).
```
