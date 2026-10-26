# pwsh/.scriptanalyzer/NoRawInformationStream.psm1

The custom analyzer check `Measure-NoRawInformationStream`: calling `Write-Information` directly is forbidden.

## Why

A direct `Write-Information` skips the Pester guard, so its output leaks into test output and loses the caller header.

## Predicates

The predicate is a local, not inlined in `FindAll`'s parens, which dodges a cross-version indent skew
([ADR-PWSH-FORMAT-MULTILINEPREDICATEBOUND](../../../drs/automation/pwsh/powershell-formatting.md#rule-adr-pwsh-format-multilinepredicatebound)).
