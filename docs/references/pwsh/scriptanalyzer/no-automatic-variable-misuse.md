# pwsh/.scriptanalyzer/NoAutomaticVariableMisuse.psm1

The custom analyzer check `Measure-NoAutomaticVariableMisuse`: the automatic variable `$?` is forbidden.

## Why

`$?` is overwritten by every statement, which makes it impossible to check reliably.

## Predicates

The predicate is a local, not inlined in `FindAll`'s parens, which dodges a cross-version indent skew
([ADR-PWSH-FORMAT-MULTILINEPREDICATEBOUND](../../../drs/automation/pwsh/powershell-formatting.md#rule-adr-pwsh-format-multilinepredicatebound)).
