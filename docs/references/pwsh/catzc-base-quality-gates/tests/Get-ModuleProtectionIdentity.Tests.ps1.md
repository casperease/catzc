# pwsh/Base.QualityGates/tests/Get-ModuleProtectionIdentity.Tests.ps1

The L0 logic test of `Get-ModuleProtectionIdentity`, the composite protection identity of a module
([ADR-REPO-PROTGLOB-COMPOSITEIDENTITY](../../../../drs/repository/protected-globs.md#rule-adr-repo-protglob-compositeidentity)): the module's own
set, plus its declared dependency closure, plus the infrastructure scopes and the runner. The identity widens to the repository-wide set for
integrity tests, unconstrained modules and the infrastructure test units, and it is memoized per run.

## Fixture

Each case builds a small declared graph: a Base group holding Alpha, which Beta depends on, and Gamma declared against the Base group.
`Catzc.Unknown` appears nowhere, so it stays unconstrained. The glob-set hash is mocked and reads the bound `Name` or `GlobSet` through
`Get-Variable`, because the `-Name` path and the `-GlobSet` path each set only one of the two variables and strict mode forbids reading the
unset one.
