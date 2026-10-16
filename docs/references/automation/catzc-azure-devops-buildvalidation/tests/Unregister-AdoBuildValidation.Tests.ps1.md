---
catzc:
  immutable:
    with_body_sha: "9b1995a20422"
    repo_status: locked
    path: docs/references/automation/catzc-azure-devops-buildvalidation/tests/Unregister-AdoBuildValidation.Tests.ps1.md
    folder: docs/references/automation/catzc-azure-devops-buildvalidation/tests
    name: unregister-ado-build-validation-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-AUTO-IDEM#2
---

# automation/Catzc.Azure.DevOps.BuildValidation/tests/Unregister-AdoBuildValidation.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Unregister-AdoBuildValidation' -Tag 'L0', 'logic' {`, written with `#`.

```text
Removal by the globset tie (the native path-filter projection): deletes the matched policy, no-ops when
absent ([ADR-AUTO-IDEM#2](/docs/adr/automation/idempotent-state-functions.md#rule-adr-auto-idem2)), and -DryRun
returns the plan ([ADR-AUTO-DRYRUN](/docs/adr/automation/dry-run.md)).
```
