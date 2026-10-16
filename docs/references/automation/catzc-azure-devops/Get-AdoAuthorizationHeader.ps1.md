---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-devops/Get-AdoAuthorizationHeader.ps1.md
    kind: comment-page
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "63f9c7440a96"
---

# automation/Catzc.Azure.DevOps/Get-AdoAuthorizationHeader.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Assert-AzCliConnected -TenantId (Get-Config -Config ado).tenant`, written with `#`.

```text
Prove the az session is in the Entra directory that backs the org before minting a token.
(tenant is a required, validated key — the AdoConfig type guarantees it on load.)
```
