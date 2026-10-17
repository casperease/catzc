---
catzc:
  immutable:
    with_body_sha: "2da8d16357ce"
    repo_status: locked
    path: docs/references/automation/catzc-base-docs/Build-AdrIndex.ps1.md
    folder: docs/references/automation/catzc-base-docs
    name: build-adr-index-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-REPO-FORMAT#5
---

# automation/Catzc.Base.Docs/Build-AdrIndex.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$reflow = {`, written with `#`.

```text
The authored prose above is wrapped for reading here, not for the page: reflow every paragraph and list item
through Format-MarkdownParagraph (Prettier's fill), so the generated page is formatter-stable
([ADR-REPO-FORMAT#5](/docs/adr/repository/uniform-formatting.md#rule-adr-repo-format5)). A heading and a blank
line pass through; a '- ' line opens a list item, and an indented or plain line continues the open block.
```

## comment:2

Above `$pathBySlugKey = @{}`, written with `#`.

```text
Map "<domainFolder>/<slug>" -> the ADR file path relative to docs/adr (forward-slashed), so a ruleset
in a subfolder (automation/BCL/) still resolves to its real link target. The
generated index.md and every folder README are skipped — they are not ADRs.
```

## comment:3

Above `$sections = foreach ($domain in $adrs.Domains) {`, written with `#`.

```text
One aligned code-registry table per domain, in declared order. Rows carry the backtick-wrapped external
code and the slug link in the exact shape Get-CatsAdrIndex parses.
```

## comment:4

Above `$inputsSha = Get-InputStamp -Path @(`, written with `#`.

```text
Every input of the page: the registry, the ADR files the slugs resolve to, and the code that renders. An unchanged stamp means the page on
disk was written from exactly these, so nothing is read or rendered. The generated pages beside the ADRs (the index, the glossary, the READMEs) are outputs, not inputs.
```
