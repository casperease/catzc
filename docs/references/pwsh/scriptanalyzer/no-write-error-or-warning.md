# pwsh/.scriptanalyzer/NoWriteErrorOrWarning.psm1

The custom analyzer check `Measure-NoWriteErrorOrWarning`: `Write-Error` and `Write-Warning` are forbidden.

## Why

All errors are terminating: use `throw` or an `Assert-*` command.

## Predicates

The predicate is a local, not inlined in `FindAll`'s parens, which dodges a cross-version indent skew
([ADR-PWSH-FORMAT-MULTILINEPREDICATEBOUND](../../../drs/automation/pwsh/powershell-formatting.md#rule-adr-pwsh-format-multilinepredicatebound)).
