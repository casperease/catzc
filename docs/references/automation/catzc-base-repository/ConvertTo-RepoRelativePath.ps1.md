---
catzc:
  derived:
    path: docs/references/automation/catzc-base-repository/ConvertTo-RepoRelativePath.ps1.md
    kind: comment-page
    body_sha: "35ec74e5e72b"
---

# automation/Catzc.Base.Repository/ConvertTo-RepoRelativePath.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:3

Above `$outputRoot = [IO.Path]::GetFullPath((Get-OutputRoot))`.

```text
1. Prefer the reserved output anchor — an output artifact stays portable as 'out/...' even when the
   output root sits outside the repo (a pipeline's staging area), where no repo-relative form exists.
```
