---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Get-ModuleSourceFunctions.ps1.md
    kind: comment-page
    body_sha: ef0302543975
    adrs: []
    links: []
---

# automation/Catzc.Base.QualityGates/private/Get-ModuleSourceFunctions.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
A module is its folder: <Module>/*.ps1 are its public functions and <Module>/private/*.ps1 its private ones,
one function per file named for the file. This reads the names from the file names, so a build can be
compared with the source folder it was built from (Test-BuildArtifact's parity facet).
```
