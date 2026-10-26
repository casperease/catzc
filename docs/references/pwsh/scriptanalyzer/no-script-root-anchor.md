# pwsh/.scriptanalyzer/NoScriptRootAnchor.psm1

The custom analyzer check `Measure-NoScriptRootAnchor`: `$PSScriptRoot` anchors are forbidden in module function files.

## Why

In build mode the functions merge into one file, so the script root no longer names the module folder.

## Which files

Only module function files are checked: `pwsh/<Module>/<File>.ps1` or `pwsh/<Module>/private/<File>.ps1`, where `<Module>` is not
dot-prefixed (`.internal`, `.scriptanalyzer` and `.vendor` are infrastructure).

## Predicates

The predicate is a local, not inlined in `FindAll`'s parens, which dodges a cross-version indent skew
([ADR-PWSH-FORMAT-MULTILINEPREDICATEBOUND](../../../drs/automation/pwsh/powershell-formatting.md#rule-adr-pwsh-format-multilinepredicatebound)).
