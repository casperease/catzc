---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-devops-buildvalidation/tests/Sync-AdoBuildValidations.Tests.ps1.md
    folder: docs/references/automation/catzc-azure-devops-buildvalidation/tests
    name: sync-ado-build-validations-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "443102464c52"
---

# automation/Catzc.Azure.DevOps.BuildValidation/tests/Sync-AdoBuildValidations.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Sync-AdoBuildValidations' -Tag 'L0', 'logic' {`, written with `#`.

```text
The config-driven reconcile: one Register-AdoBuildValidation per build-validation.yml entry, with
overrides and -DryRun passed through.
```
