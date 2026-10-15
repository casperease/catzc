# docs/references/automation/catzc-base-qualitygates/Test-MarkdownTitle.ps1.md

`automation/Catzc.Base.QualityGates/Test-MarkdownTitle.ps1`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Runs the same check as Format-MarkdownTitle, read-only, and reports every file whose first line after any YAML
front matter is not the H1 `# <repository-relative path>`, every heading with a trailing reference group, every
unquoted dora-explains paragraph, every link to an anchor that moves, and every duplicate anchor. Running
Format-MarkdownTitle fixes all of them except a Duplicate, which the author rewords; each issue says which.
A quality gate ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)): it ends
through Write-QualityGateReport, which writes out/test-markdown-title/, prints every issue, and throws once
listing them all. It needs the source tree: it throws in build mode.
```
