---
catzc:
  derived:
    path: docs/references/pipelines/Invoke-AdoScript.ps1.md
    kind: reference
    body_sha: "84b8256e57a4"
    adrs: []
---

# pipelines/Invoke-AdoScript.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Called by the invoke-automation.yaml step template. Imports all modules via
importer.ps1, sanitizes the command string (YAML/ADO escaping artifacts),
sets up the error trap, then executes the command.

The command runs in the same scope as the importer — all functions are available
without module qualification.
```

## comment:2

Section `.PARAMETER Command` of the comment-based help.

```text
The PowerShell command string to execute. This should be the same command a
developer would type after running .\importer.ps1 locally.
Supports multiline commands (use YAML pipe operator in the template).
```
