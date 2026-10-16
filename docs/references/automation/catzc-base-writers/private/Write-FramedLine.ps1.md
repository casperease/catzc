---
catzc:
  immutable:
    with_body_sha: e5d2921677eb
    repo_status: locked
    path: docs/references/automation/catzc-base-writers/private/Write-FramedLine.ps1.md
    folder: docs/references/automation/catzc-base-writers/private
    name: write-framed-line-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Base.Writers/private/Write-FramedLine.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$rendered = foreach ($s in $Segment) {`, written with `#`.

```text
A rule line takes the per-character gradient; a titled line takes the base colour (the profile
side-grades to Base). The text is pre-coloured here, so it passes through the chokepoint with no
-ForegroundColor of its own.
```
