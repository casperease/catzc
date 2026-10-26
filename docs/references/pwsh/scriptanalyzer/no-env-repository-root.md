# pwsh/.scriptanalyzer/NoEnvRepositoryRoot.psm1

The custom analyzer check `Measure-NoEnvRepositoryRoot`: module function files read the repository root through `Get-RepositoryRoot`, not
through the environment variable.

## Why

One accessor reads the root, so where the root comes from can change in one place. A write of the variable is not flagged.

## Predicates

The predicate is a local, not inlined in `FindAll`'s parens, which dodges a cross-version indent skew
([ADR-PWSH-FORMAT-MULTILINEPREDICATEBOUND](../../../drs/automation/pwsh/powershell-formatting.md#rule-adr-pwsh-format-multilinepredicatebound)).
