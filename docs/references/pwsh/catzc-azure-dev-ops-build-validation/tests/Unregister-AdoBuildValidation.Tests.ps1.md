# pwsh/Catzc.Azure.DevOps.BuildValidation/tests/Unregister-AdoBuildValidation.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Unregister-AdoBuildValidation'`, written with `#`.

```text
Removal by the globset tie (the native path-filter projection): deletes the matched policy, no-ops when
absent ([ADR-AUTO-IDEM-ALREADYDONEISFINE](/docs/drs/automation/idempotent-state-functions.md#rule-adr-auto-idem-alreadydoneisfine)), and -DryRun
returns the plan ([ADR-AUTO-DRYRUN](/docs/drs/automation/dry-run.md)).
```
