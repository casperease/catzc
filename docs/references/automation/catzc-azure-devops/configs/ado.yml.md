---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-devops/configs/ado.yml.md
    kind: comment-page
    body_sha: b8843ba8a09d
    adrs: []
    links: []
---

# automation/Catzc.Azure.DevOps/configs/ado.yml

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `organization: "https://dev.azure.com/Catzc"`.

```text
Azure DevOps coupling for this repo's automation — the data that binds it to a specific ADO
organization and the Entra (Azure AD) tenant behind it. Loaded by Get-Config -Config ado. The API functions
(New-AdoPullRequest, Register-AdoPipeline, Get-AdoPipelineDefinitions, …) default organization/project
from here; Get-AdoAuthorizationHeader uses `tenant` to ensure the az CLI session is in the right
directory before minting an ADO token (its az-login fallback path).
```

## comment:2

Above `tenant: "fa0e0000-7e0a-0700-1d00-000000000000"`.

```text
Entra (Azure AD) tenant GUID backing the DevOps organization. The identity coupling: the az session
that mints an ADO token must be logged into this directory. Placeholder ('fake tenant id', the same
minted tenant as azure.yml's) — replace with the real tenant per deployment target.
```
