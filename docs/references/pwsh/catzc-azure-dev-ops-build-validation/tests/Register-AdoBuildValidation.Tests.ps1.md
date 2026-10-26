# pwsh/Azure.DevOps.BuildValidation/tests/Register-AdoBuildValidation.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Register-AdoBuildValidation'`, written with `#`.

```text
The write side: idempotent create-or-update of one globset's build-validation policy, everything
defaulted from build-validation.yml, globs.yml, and ado.yml; -DryRun returns the plan
([ADR-AUTO-DRYRUN](/docs/drs/automation/dry-run.md)).
```
