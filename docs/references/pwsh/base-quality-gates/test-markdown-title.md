# pwsh/Base.QualityGates/Test-MarkdownTitle.ps1

The quality gate for titles: it fails on any in-scope Markdown file whose H1 is not a title or whose headings are not in normal form.
Format-MarkdownTitle is its fixing half.

## help

### synopsis

Checks Markdown titles and headings and fails on any in-scope file whose H1 is not a title or whose headings are not in normal form.

### description

Runs the same check as Format-MarkdownTitle, read-only, and reports every file whose first line after any YAML front matter is not an H1
title (an H1 that is the file's path, or no H1), every heading with a trailing reference group, every unquoted dora-explains paragraph,
every link to an anchor that moves, and every duplicate anchor. Running Format-MarkdownTitle fixes all of them except a Duplicate, an
Untitled file and a Missing title, which the author writes; each issue says which. A quality gate
([ADR-AUTO-TEST-QUALITYGATE](../../../drs/automation/test-automation.md#rule-adr-auto-test-qualitygate)): it ends through
Write-QualityGateReport, which writes out/test-markdown-title/, prints every issue, and throws once listing them all. It needs the source
tree: it throws in build mode.

It rests on [ADR-REPO-FORMAT-MARKDOWNTITLE](../../../drs/repository/uniform-formatting.md#rule-adr-repo-format-markdowntitle) and
[ADR-REPO-FORMAT-PLAINHEADINGS](../../../drs/repository/uniform-formatting.md#rule-adr-repo-format-plainheadings).

### parameter `Path`

Files or folders to check. Default: every in-scope file.

### parameter `RepositoryRoot`

The repository root titles are relative to. Default: the loaded repository root.

### parameter `OutputFolder`

The report base folder. Defaults to `<out>/test-markdown-title`.

### parameter `PassThru`

Return a result object ({ Subject; IssueCount; Issues; ReportPath; FileCount }) instead of throwing.

### outputs

Throws on any violation; with -PassThru, returns the result object.

### example 1

```powershell
Test-MarkdownTitle
```

### example 2

```powershell
(Test-MarkdownTitle -PassThru).Issues
```
