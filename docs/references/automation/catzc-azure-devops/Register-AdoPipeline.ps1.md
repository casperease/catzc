---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-devops/Register-AdoPipeline.ps1.md
    kind: comment-page
    body_sha: b1858f066e3c
---

# automation/Catzc.Azure.DevOps/Register-AdoPipeline.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Uses the ADO Pipelines REST API to register a pipeline definition backed
by a YAML file. Supports both Azure Repos Git and GitHub repositories.
Throws if a pipeline with the same name already exists.

Requires authentication via Get-AdoAuthorizationHeader (pipeline token or az login).
```

## comment:2

Section `.PARAMETER GitHubRepository` of the comment-based help.

```text
Full GitHub repository URL (e.g. 'https://github.com/owner/repo').
When set, the pipeline takes its source from GitHub instead of Azure Repos Git.
Requires a GitHub service connection in the ADO project.
```

## comment:3

Section `.PARAMETER RepositoryName` of the comment-based help.

```text
Name of the Azure Repos Git repository. Ignored when -GitHubRepository is set.
Defaults to this checkout's repository (Get-AdoRepositoryName).
```
