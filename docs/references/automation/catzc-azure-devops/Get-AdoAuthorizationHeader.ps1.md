---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-devops/Get-AdoAuthorizationHeader.ps1.md
    kind: comment-page
    body_sha: "5b58f415335d"
---

# automation/Catzc.Azure.DevOps/Get-AdoAuthorizationHeader.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:4

Above `Assert-AzCliConnected -TenantId (Get-Config -Config ado).tenant`.

```text
Prove the az session is in the Entra directory that backs the org before minting a token.
(tenant is a required, validated key — the AdoConfig type guarantees it on load.)
```
