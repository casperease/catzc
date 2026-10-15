---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/Format-MarkdownTitle.ps1.md
    kind: comment-page
    body_sha: "109bd3edbc67"
    adrs:
      - ADR-AUTO-DRYRUN#2
    links: []
---

# automation/Catzc.Base.QualityGates/Format-MarkdownTitle.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Makes each file's first line after any YAML front matter its title, an H1 that is not the file's path: an H1 that is
the path followed by one code-span line takes that line's text as its wording (the line goes), and a file with no
title is reported, since only a person can write one. Then each heading below it is made plain
words: a trailing group of code spans or a citation moves to its own line below the heading, a dora-explains
entry's DORA paragraph becomes a > blockquote, and every link to an anchor that changed is re-pointed
(Get-MarkdownHeadingFinding). A duplicate anchor is reported, not fixed — the author rewords it. The scope is every
git-tracked *.md file except those .gitattributes marks vendored or generated and the test fixture trees
(Get-MarkdownScope). Files are written as UTF-8 without a BOM, with their own line endings kept; a file
already in form is not touched, so a second run changes nothing. Test-MarkdownTitle is the gate. A source-tree
tool: it throws in build mode (Assert-SourceTree).
```

## comment:2

Above `function Format-MarkdownTitle {`.

```text
Uses -DryRun, not ShouldProcess/-WhatIf — see
[ADR-AUTO-DRYRUN#2](/docs/adr/automation/dry-run.md#rule-adr-auto-dryrun2).
```
