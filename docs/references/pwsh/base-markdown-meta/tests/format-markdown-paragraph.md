# pwsh/Base.MarkdownMeta/tests/Format-MarkdownParagraph.Tests.ps1

The tests of `Format-MarkdownParagraph`.

## Why it is shaped so

The command must fill text the way Prettier's `proseWrap: always` does, so the generated ADR index, glossary and contract reference are
formatter-stable
([ADR-REPO-FORMAT-GENERATEDFORMATTED](../../../../drs/repository/uniform-formatting.md#rule-adr-repo-format-generatedformatted)).
