---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-devops-buildvalidation/tests/Register-AdoBuildValidation.Tests.ps1.md
    kind: test-asset
    body_sha: a7025fcbcb78
---

# automation/Catzc.Azure.DevOps.BuildValidation/tests/Register-AdoBuildValidation.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Register-AdoBuildValidation' -Tag 'L0', 'logic' {`.

```text
The write side: idempotent create-or-update of one globset's build-validation policy, everything
defaulted from build-validation.yml, globs.yml, and ado.yml; -DryRun returns the plan
([ADR-AUTO-DRYRUN](/docs/adr/automation/dry-run.md)).
```
