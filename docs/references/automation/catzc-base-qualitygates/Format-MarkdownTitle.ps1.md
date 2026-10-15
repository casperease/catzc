# docs/references/automation/catzc-base-qualitygates/Format-MarkdownTitle.ps1.md

`automation/Catzc.Base.QualityGates/Format-MarkdownTitle.ps1`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Makes each file's first line after any YAML front matter the H1 `# <repository-relative path>`: a different H1 is
replaced and its wording kept as the body's first line (path H1, blank line, old title between single
backticks), and a file that opens without one gets the title inserted. Then each heading below it is made plain
words: a trailing group of code spans or a citation moves to its own line below the heading, a dora-explains
entry's DORA paragraph becomes a > blockquote, and every link to an anchor that changed is re-pointed
(Get-MarkdownHeadingFinding). A duplicate anchor is reported, not fixed — the author rewords it. The scope is every
git-tracked *.md file except those .gitattributes marks vendored or generated and the test fixture trees
(Get-MarkdownTitleScope). Files are written as UTF-8 without a BOM, with their own line endings kept; a file
already in form is not touched, so a second run changes nothing. Test-MarkdownTitle is the gate. A source-tree
tool: it throws in build mode (Assert-SourceTree).
```

## comment:2

Above `function Format-MarkdownTitle {`.

```text
Uses -DryRun, not ShouldProcess/-WhatIf — see
[ADR-AUTO-DRYRUN#2](/docs/adr/automation/dry-run.md#rule-adr-auto-dryrun2).
```
