---
catzc:
  immutable:
    with_body_sha: "0c03e9388d1d"
    path: docs/references/automation/catzc-base-docs/Build-Readme.ps1.md
    folder: docs/references/automation/catzc-base-docs
    name: build-readme-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Base.Docs/Build-Readme.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$changed = Write-FileIfChanged -Path $readmePath -Content (Get-ReadmeContent...`, written with `#`.

```text
Delete-then-write on a change (Write-FileIfChanged): a README that is still a filesystem link to its
source is severed, never written through.
```
