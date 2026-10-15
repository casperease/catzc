---
catzc:
  derived:
    path: docs/references/automation/catzc-base-repository/Get-OutputRoot.ps1.md
    kind: comment-page
    body_sha: cc3b10578efe
    adrs: []
    links: []
---

# automation/Catzc.Base.Repository/Get-OutputRoot.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
In an Azure DevOps pipeline, returns $env:BUILD_ARTIFACTSTAGINGDIRECTORY.
Locally on DevBox, returns {RepositoryRoot}/out.

With -EnsureExists, creates the directory if it does not exist.
```
