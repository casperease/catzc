# pwsh/.scriptanalyzer/NeverDependOnPwd.psm1

The custom analyzer check `Measure-NeverDependOnPwd`: code never depends on `$PWD`.

## What is flagged

- Any reference to the `$PWD` variable.
- A `Set-Location` or `cd` call.

`Push-Location` and `Pop-Location` pass: they restore the caller's directory, a bare `Set-Location` does not.

## Predicates

Both predicates are locals, not inlined in `FindAll`'s parens, which dodges a cross-version indent skew
([ADR-PWSH-FORMAT-MULTILINEPREDICATEBOUND](../../../drs/automation/pwsh/powershell-formatting.md#rule-adr-pwsh-format-multilinepredicatebound)).
