# docs/references/automation/catzc-base-docs/types/GlossaryRealization.cs.md

`automation/Catzc.Base.Docs/types/GlossaryRealization.cs`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
How a glossary concept exists in the repository (a configs/glossary.yml `realized_by:` mapping): a kind from a
closed set and, for every kind except prose-only, the pattern that locates it — a repo-relative glob, a tag, or
an identifier, never a URL (every glossary source and reference stays in the repository,
[ADR-REPO-VOCAB#3](/docs/adr/repository/controlled-vocabulary.md#rule-adr-repo-vocab3)). A
prose-only concept is a pure vocabulary term with nothing in code to enforce
([ADR-REPO-VOCAB#6](/docs/adr/repository/controlled-vocabulary.md#rule-adr-repo-vocab6)), so it carries no
pattern. Mirrors the YAML mapping (snake_case keys,
[ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).
```
