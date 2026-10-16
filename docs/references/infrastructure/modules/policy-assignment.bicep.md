---
catzc:
  derived:
    path: docs/references/infrastructure/modules/policy-assignment.bicep.md
    kind: comment-page
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "8319265c1cdf"
---

# infrastructure/modules/policy-assignment.bicep

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `targetScope = 'subscription'`, written with `//`.

```text
Reusable bicep module: a policy assignment at subscription scope. The caller passes the policy
definition id, its parameters, and the enforcement mode, which has no default here: the template
reads it from the repository-wide setting in azure.yml (`policy_enforcement`). A policy whose effect
deploys or modifies resources (deployIfNotExists, modify) needs a managed identity and the roles its
remediation uses: set `assignIdentity` and list the role definition ids, and the module grants them on
the subscription. `az bicep build` inlines it.
```
