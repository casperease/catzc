---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-devops-buildvalidation/tests/Unregister-AdoBuildValidation.Tests.ps1.md
    kind: test-asset
    body_sha: f1b9f73afd14
    adrs:
      - ADR-AUTO-IDEM#2
---

# automation/Catzc.Azure.DevOps.BuildValidation/tests/Unregister-AdoBuildValidation.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Unregister-AdoBuildValidation' -Tag 'L0', 'logic' {`.

```text
Removal by the globset tie (the native path-filter projection): deletes the matched policy, no-ops when
absent ([ADR-AUTO-IDEM#2](/docs/adr/automation/idempotent-state-functions.md#rule-adr-auto-idem2)), and -DryRun
returns the plan ([ADR-AUTO-DRYRUN](/docs/adr/automation/dry-run.md)).
```
