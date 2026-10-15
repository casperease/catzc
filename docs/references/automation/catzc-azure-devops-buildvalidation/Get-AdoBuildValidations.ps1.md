---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-devops-buildvalidation/Get-AdoBuildValidations.ps1.md
    kind: comment-page
    body_sha: "69f3baf59aeb"
    adrs:
      - ADR-FLOW-CD-TYPE#4
---

# automation/Catzc.Azure.DevOps.BuildValidation/Get-AdoBuildValidations.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Queries the ADO Policy Configurations REST API and returns one object per build-validation policy
(policy type 'Build') scoped to the repository — the server-side pre-commit gates
([ADR-FLOW-CD-TYPE#4](/docs/adr/flow/pipeline-types.md#rule-adr-flow-cd-type4)). Each result carries the policy id,
display name, the guarded branch, the path
filters (a globset-tied policy filters on its native path projection,
[ADR-FLOW-CD-GLOBS](/docs/adr/flow/durable-sha-globs.md)), the pipeline definition
id it queues, the blocking/enabled bits, and the raw configuration.

Read-only — registering and removing policies is Register-AdoBuildValidation /
Unregister-AdoBuildValidation.
```
