---
catzc:
  immutable:
    with_body_sha: "85ca84513188"
    repo_status: locked
    path: docs/references/automation/catzc-base-qualitygates/Format-MarkdownTitle.ps1.md
    folder: docs/references/automation/catzc-base-qualitygates
    name: format-markdown-title-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-AUTO-DRYRUN#2
---

# automation/Catzc.Base.QualityGates/Format-MarkdownTitle.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Makes the H1 of every in-scope Markdown file its title and brings its headings into normal form.

### description

Makes each file's first line after any YAML front matter its title, an H1 that is not the file's path: an H1 that is
the path followed by one code-span line takes that line's text as its wording (the line goes), and a file with no
title is reported, since only a person can write one. Then each heading below it is made plain
words: a trailing group of code spans or a citation moves to its own line below the heading, a dora-explains
entry's DORA paragraph becomes a > blockquote, and every link to an anchor that changed is re-pointed
(Get-MarkdownHeadingFinding). A duplicate anchor is reported, not fixed — the author rewords it. The scope is every
git-tracked `*.md` file except those .gitattributes marks vendored or generated and the test fixture trees
(Get-MarkdownScope). Files are written as UTF-8 without a BOM, with their own line endings kept; a file
already in form is not touched, so a second run changes nothing. Test-MarkdownTitle is the gate. A source-tree
tool: it throws in build mode (Assert-SourceTree).

It rests on [ADR-REPO-FORMAT#6](../../../adr/repository/uniform-formatting.md#rule-adr-repo-format6) and [ADR-REPO-FORMAT#7](../../../adr/repository/uniform-formatting.md#rule-adr-repo-format7).

### parameter Path

Files or folders to title. Default: every in-scope file.

### parameter RepositoryRoot

The repository root titles are relative to. Default: the loaded repository root.

### parameter DryRun

Report what would change without writing any file.

### parameter PassThru

Return a result object ({ ChangedCount; ChangedFiles; FileCount; DryRun }) instead of only the changed paths.

### outputs

`[string[]]` the repository-relative paths changed (or, under -DryRun, that would change); with -PassThru, the result
object.

### example 1

```powershell
Format-MarkdownTitle
```

### example 2

```powershell
Format-MarkdownTitle -DryRun -PassThru
```

### example 3

```powershell
Format-MarkdownTitle -Path docs/references
```

## comment:1

Above `function Format-MarkdownTitle {`, written with `#`.

```text
Uses -DryRun, not ShouldProcess/-WhatIf — see
[ADR-AUTO-DRYRUN#2](/docs/adr/automation/dry-run.md#rule-adr-auto-dryrun2).
```
