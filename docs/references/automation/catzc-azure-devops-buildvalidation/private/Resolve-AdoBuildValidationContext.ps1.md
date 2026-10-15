---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-devops-buildvalidation/private/Resolve-AdoBuildValidationContext.ps1.md
    kind: comment-page
    body_sha: "4d3c27dea2bf"
---

# automation/Catzc.Azure.DevOps.BuildValidation/private/Resolve-AdoBuildValidationContext.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Defaults organization/project from ado.yml and the repository name from Get-AdoRepositoryName (the same
default as Register-AdoPipeline and the public build-validation functions), resolves the
repository to its GUID via the Git repositories API, and returns one context object the public
functions share — including the well-known Build policy type id, so the constant lives in exactly one
place.
```
