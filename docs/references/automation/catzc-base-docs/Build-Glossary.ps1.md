# docs/references/automation/catzc-base-docs/Build-Glossary.ps1.md

`automation/Catzc.Base.Docs/Build-Glossary.ps1`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Projects Get-Glossary (every concept of every configs/glossary.yml source,
[ADR-REPO-VOCAB](/docs/adr/repository/controlled-vocabulary.md)) into one markdown page: a section per ADR domain,
in adrs.yml order, and per term its one-line definition, a link to the rule that defines it, how it is realized,
its source, its relations, its allowed forms, its contrasts (linked to the related terms), and its avoided phrasings
with what to say instead. Terms sort by term within a domain, so the output is deterministic.

The page is a derived artifact like the ADR index: committed so GitHub has it (linguist-generated, so its diff
collapses) and rebuilt on import, its sources (the glossary files and this generator) are what is reviewed and
checked
([ADR-REPO-README#7](/docs/adr/repository/generated-readmes.md#rule-adr-repo-readme7)). It is written only when its
content changes, and emitted already formatted (Format-MarkdownParagraph), so Format-Code is a no-op on it.
```
