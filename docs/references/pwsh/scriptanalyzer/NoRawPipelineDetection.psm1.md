# pwsh/.scriptanalyzer/NoRawPipelineDetection.psm1

The custom analyzer check `Measure-NoRawPipelineDetection`: raw reads of the pipeline-detection environment variables are forbidden.

## Why

One detector owns the agent variables, so the checked set stays hidden and both platforms are always covered.

## Predicates

The predicate is a local, not inlined in `FindAll`'s parens, which dodges a cross-version indent skew
([ADR-PWSH-FORMAT-MULTILINEPREDICATEBOUND](../../../drs/automation/pwsh/powershell-formatting.md#rule-adr-pwsh-format-multilinepredicatebound)).
