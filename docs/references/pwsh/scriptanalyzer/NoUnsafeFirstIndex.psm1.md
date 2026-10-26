# pwsh/.scriptanalyzer/NoUnsafeFirstIndex.psm1

The custom analyzer check `Measure-NoUnsafeFirstIndex`: taking the first element of a collected result by index is forbidden.

## Why

Under strict mode an empty result throws an engine error before the null check written after it can run.

## Predicates

The predicate is a local, not inlined in `FindAll`'s parens, which dodges a cross-version indent skew
([ADR-PWSH-FORMAT-MULTILINEPREDICATEBOUND](../../../drs/automation/pwsh/powershell-formatting.md#rule-adr-pwsh-format-multilinepredicatebound)).
