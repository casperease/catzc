---
catzc:
  immutable:
    with_body_sha: "6a672e92a9c6"
    path: docs/references/automation/catzc-base-repository/ConvertTo-RepoRelativePath.ps1.md
    folder: docs/references/automation/catzc-base-repository
    name: convert-to-repo-relative-path-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Base.Repository/ConvertTo-RepoRelativePath.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$outputRoot = [IO.Path]::GetFullPath((Get-OutputRoot))`, written with `#`.

```text
1. Prefer the reserved output anchor — an output artifact stays portable as 'out/...' even when the
   output root sits outside the repo (a pipeline's staging area), where no repo-relative form exists.
```
