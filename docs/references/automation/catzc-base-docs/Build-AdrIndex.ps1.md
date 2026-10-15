---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/Build-AdrIndex.ps1.md
    kind: comment-page
    body_sha: "834385e7d501"
    adrs:
      - ADR-REPO-FORMAT#5
---

# automation/Catzc.Base.Docs/Build-AdrIndex.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
index.md is a derived projection of automation/Catzc.Base.Docs/configs/adrs.yml: authored preamble and
authoring-convention prose wrapped around one code-registry table per domain (in declared order). Every
ADR row is `| ``<external>`` | [<slug>](<path>) |` — the format Get-CatsAdrIndex parses and the citation
grammar Show-Cats presents. Each link path is resolved to the real docs/adr/<domain>/**/<slug>.md file.

The index is committed — so GitHub has it, and every ADR citation's link resolves there — marked
linguist-generated so its diff collapses, and reproduced on every import (before Build-Readme, which generates
the docs/adr README from it), so adrs.yml is the ONLY place the registry is edited — a hand-edit to index.md is overwritten
on the next load. See [ADR-REPO-README](/docs/adr/repository/generated-readmes.md) for the generated-file pattern.

Idempotent and fast: the write goes through Write-FileIfChanged (canonical output, EOL-insensitive compare,
write only on drift), so a clean tree costs one file read.
```

## comment:2

Section `.PARAMETER DryRun` of the comment-based help.

```text
Report whether index.md would change without writing it. See
[ADR-AUTO-DRYRUN](/docs/adr/automation/dry-run.md).
```

## comment:3

Above `$reflow = {`.

```text
The authored prose above is wrapped for reading here, not for the page: reflow every paragraph and list item
through Format-MarkdownParagraph (Prettier's fill), so the generated page is formatter-stable
([ADR-REPO-FORMAT#5](/docs/adr/repository/uniform-formatting.md#rule-adr-repo-format5)). A heading and a blank
line pass through; a '- ' line opens a list item, and an indented or plain line continues the open block.
```

## comment:4

Above `$pathBySlugKey = @{}`.

```text
Map "<domainFolder>/<slug>" -> the ADR file path relative to docs/adr (forward-slashed), so a ruleset
in a subfolder (automation/BCL/) still resolves to its real link target. The
generated index.md and every folder README are skipped — they are not ADRs.
```

## comment:5

Above `$sections = foreach ($domain in $adrs.Domains) {`.

```text
One aligned code-registry table per domain, in declared order. Rows carry the backtick-wrapped external
code and the slug link in the exact shape Get-CatsAdrIndex parses.
```

## comment:6

Above `$reflow = {`.

```text
The authored prose above is wrapped for reading here, not for the page: reflow every paragraph and list item
through Format-MarkdownParagraph (Prettier's fill), so the generated page is formatter-stable
([ADR-REPO-FORMAT#5](/docs/adr/repository/uniform-formatting.md#rule-adr-repo-format5)). A heading and a blank
line pass through; a '- ' line opens a list item, and an indented or plain line continues the open block.
```

## comment:7

Above `$pathBySlugKey = @{}`.

```text
Map "<domainFolder>/<slug>" -> the ADR file path relative to docs/adr (forward-slashed), so a ruleset
in a subfolder (automation/BCL/) still resolves to its real link target. The
generated index.md and every folder README are skipped — they are not ADRs.
```

## comment:8

Above `$sections = foreach ($domain in $adrs.Domains) {`.

```text
One aligned code-registry table per domain, in declared order. Rows carry the backtick-wrapped external
code and the slug link in the exact shape Get-CatsAdrIndex parses.
```
