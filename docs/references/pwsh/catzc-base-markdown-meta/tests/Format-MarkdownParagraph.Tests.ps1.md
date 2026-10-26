# pwsh/Base.MarkdownMeta/tests/Format-MarkdownParagraph.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Format-MarkdownParagraph'`, written with `#`.

```text
Format-MarkdownParagraph must fill text the way Prettier's proseWrap: always does, so the generated ADR index, glossary,
and contract reference are formatter-stable
([ADR-REPO-FORMAT-GENERATEDARTIFACTSFORMATTED](/docs/drs/repository/uniform-formatting.md#rule-adr-repo-format-generatedartifactsformatted)).
```
