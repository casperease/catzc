---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/Build-Readme.ps1.md
    kind: comment-page
    body_sha: e6ab36dd79f5
---

# automation/Catzc.Base.Docs/Build-Readme.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:6

Above `$changed = Write-FileIfChanged -Path $readmePath -Content (Get-ReadmeContent...`.

```text
Delete-then-write on a change (Write-FileIfChanged): a README that is still a filesystem link to its
source is severed, never written through.
```
