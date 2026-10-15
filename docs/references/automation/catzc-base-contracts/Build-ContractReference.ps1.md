---
catzc:
  derived:
    path: docs/references/automation/catzc-base-contracts/Build-ContractReference.ps1.md
    kind: comment-page
    body_sha: "414a67e4ab14"
    adrs:
      - ADR-REPO-CONTRACT#2
      - ADR-REPO-FORMAT#5
      - ADR-REPO-README#7
---

# automation/Catzc.Base.Contracts/Build-ContractReference.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Projects Get-Contract over every version folder of every unit
([ADR-REPO-CONTRACT#2](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract2)) into one markdown page per
unit. The page has a section per version folder, the draft 0.0.0 first and then the released folders, newest
first; each section is one table with a row per asset (its owning module, its path under the module, the
repository-relative file it constrains — its target, under the module's target root; a sample payload has none —
its direction, marked when the version's
contract.yml sets it, and its kind), then a list of the notes, one item per asset that carries one.

The note is the asset's header comment (Get-ContractAssetNote), so what an asset is for is written once, in the
asset, and contracts/ holds only assets. A note's code links become relative markdown links and each address an
autolink (ConvertTo-ContractNoteMarkdown). An asset that carries no comment has no list item.

The pages are derived artifacts like the [glossary](/docs/adr/glossary.md): committed so GitHub has them and rebuilt
by this writer, while their inputs (the assets) are what is reviewed and checked
([ADR-REPO-README#7](/docs/adr/repository/generated-readmes.md#rule-adr-repo-readme7)). A page whose unit has no
assets left is removed, but only when it carries this writer's own marker line: a page someone wrote by hand in
docs/references/contracts/ is never touched. Each page is written only when its content changes
(Write-FileIfChanged), and is emitted already formatted — prose and list items filled at the 140-column width
(Format-MarkdownParagraph) and every table aligned — so Format-Code leaves it as written
([ADR-REPO-FORMAT#5](/docs/adr/repository/uniform-formatting.md#rule-adr-repo-format5)). A contracts/ tree that does
not list throws, as Get-Contract does.
```
