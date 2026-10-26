# pwsh/Base.QualityGates/tests/types/WorkerParentWatch.Tests.ps1

The test of the `WorkerParentWatch` type. It snapshots and restores the process-scope environment variable only
([ADR-PWSH-ENV-NOPESTERISOLATION](../../../../../drs/automation/pwsh/environment-variable-mechanics.md#rule-adr-pwsh-env-nopesterisolation)).
Under the harness the variables hold the real parent, so only the absent and malformed cases run here, because a watch that starts in this
process would watch whatever the variables name.
