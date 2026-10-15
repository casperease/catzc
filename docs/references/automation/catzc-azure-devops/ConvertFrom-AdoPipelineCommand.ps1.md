---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-devops/ConvertFrom-AdoPipelineCommand.ps1.md
    kind: comment-page
    body_sha: d7ffe2f3dbc3
    adrs: []
    links: []
---

# automation/Catzc.Azure.DevOps/ConvertFrom-AdoPipelineCommand.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
When ADO passes a command string through YAML template parameters, task
arguments, and into PowerShell, the string accumulates escaping artifacts:
carriage returns from Windows line endings, mixed newlines depending on
whether the source YAML used folding (>) or literal (|) block scalars,
and trailing whitespace from YAML indentation. By the time the string
reaches PowerShell, YAML has already been parsed — this function only
deals with the resulting plain string, not YAML syntax.

This function normalizes the string for safe use with [ScriptBlock]::Create().
```
