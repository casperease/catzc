---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/Build-AdrIndex.ps1.md
    kind: comment-page
    body_sha: "9f4e30bc5b4c"
    adrs:
      - ADR-REPO-FORMAT#5
---

# automation/Catzc.Base.Docs/Build-AdrIndex.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

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
