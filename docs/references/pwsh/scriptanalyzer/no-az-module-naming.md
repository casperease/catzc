# pwsh/.scriptanalyzer/NoAzModuleNaming.psm1

The custom analyzer check `Measure-NoAzModuleNaming`: the naming of the Az PowerShell modules is forbidden for a function.

## Why

Azure is spelled out in full, so a function name never collides with a cmdlet of the Az modules.

## Predicates

The predicate is a local, not inlined in `FindAll`'s parens, which dodges a cross-version indent skew
([ADR-PWSH-FORMAT-MULTILINEPREDICATEBOUND](../../../drs/automation/pwsh/powershell-formatting.md#rule-adr-pwsh-format-multilinepredicatebound)).
