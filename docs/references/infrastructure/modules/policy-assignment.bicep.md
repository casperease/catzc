---
catzc:
  derived:
    path: docs/references/infrastructure/modules/policy-assignment.bicep.md
    kind: comment-page
    body_sha: "4cd6ccc298f4"
---

# infrastructure/modules/policy-assignment.bicep

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `targetScope = 'subscription'`.

```text
Reusable bicep module: a policy assignment at subscription scope. The caller passes the policy
definition id, its parameters, and the enforcement mode, which has no default here: the template
reads it from the repository-wide setting in azure.yml (`policy_enforcement`). A policy whose effect
deploys or modifies resources (deployIfNotExists, modify) needs a managed identity and the roles its
remediation uses: set `assignIdentity` and list the role definition ids, and the module grants them on
the subscription. `az bicep build` inlines it.
```
