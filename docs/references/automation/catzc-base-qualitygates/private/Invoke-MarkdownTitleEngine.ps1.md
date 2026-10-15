---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Invoke-MarkdownTitleEngine.ps1.md
    kind: comment-page
    body_sha: "1edd783bd2a3"
    adrs: []
---

# automation/Catzc.Base.QualityGates/private/Invoke-MarkdownTitleEngine.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Resolves the scope (Get-MarkdownScope), reads each file, checks its title (Get-MarkdownTitleFinding) and
then its headings on the titled text (Get-MarkdownHeadingFinding), so the formatter and the gate can never
disagree. When a heading's anchor changes, every in-scope file — the whole scope, even when Path narrows the
check — has its links to that anchor re-pointed (Get-RepointedMarkdownText) and carries an Anchor finding.
```
