# pwsh/Base.Docs/Build-Glossary.ps1

The generator of the glossary page: it renders every merged concept of `Get-Glossary` into `docs/drs/glossary.md`, a section per ADR domain,
and writes the page only when its content changes.

## Contrasts

A contrast is declared once, on either term, and shows on both entries. A term's own declaration wins over the mirrored one.

## help

### synopsis

Generates the [glossary](../../../drs/glossary.md) — the controlled vocabulary as one readable page — from the glossary sources.

### description

Projects Get-Glossary (every concept of every configs/glossary.yml source,
[ADR-REPO-VOCAB](../../../drs/repository/controlled-vocabulary.md)) into one markdown page: a section per ADR domain, in drs.yml order, and
per term its one-line definition, a link to the rule that defines it, how it is realized, its source, its relations, its allowed forms, its
contrasts (linked to the related terms), and its avoided phrasings with what to say instead. Terms sort by term within a domain, so the
output is deterministic.

The page is a derived artifact like the ADR index: committed so GitHub has it (linguist-generated, so its diff collapses) and rebuilt on
import, its sources (the glossary files and this generator) are what is reviewed and checked
([ADR-REPO-README-AUTHOREDSOURCES](../../../drs/repository/generated-readmes.md#rule-adr-repo-readme-authoredsources)). It is written only
when its content changes, and emitted already formatted (Format-MarkdownParagraph), so Format-Code is a no-op on it.

### parameter `Path`

The page to write. Defaults to the [glossary](../../../drs/glossary.md); a test points it at a fixture path.

### parameter `DryRun`

Report whether the page would change without writing it.

### parameter `Silent`

Write no message.

### parameter `PassThru`

Return { Path; Changed; DryRun; ConceptCount } instead of the path.

### outputs

`[string]` The repo-relative page path; with -PassThru, `[pscustomobject]` { Path; Changed; DryRun; ConceptCount }.

### example 1

```powershell
Build-Glossary -DryRun -PassThru
```
