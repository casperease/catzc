# pwsh/Azure.Cli/private/Get-AzCliBicepState.ps1

The private function that reads the Bicep CLI state and compares it with the configured minimum version. It is the one place the
comparison is made, shared by the Bicep query and the Bicep assertion.

## help

### synopsis

Returns the Bicep CLI state relative to the configured minimum version.

### description

Runs `az bicep version`, parses the installed MAJOR.MINOR.PATCH, and compares it against Get-AzureBicepMinVersion (azure.yml
`bicep_min_version`). The single source of the comparison, shared by Test-AzCliBicep (returns a bool) and Assert-AzCliBicep (throws), so the
two cannot drift — the same pattern as Get-AzCliConnectionState.

Returns an ordered dictionary:

```text
{ installed, version, min_version, meets_minimum }
```

`installed` is false when `az bicep version` exits non-zero. `version` is the parsed `[version]` (or $null when the output cannot be
parsed). `meets_minimum` requires an installed, parseable version at or above the minimum.

### example 1

```powershell
(Get-AzCliBicepState).meets_minimum
```

## A silent probe

The `az bicep version` call passes `-Silent`: it is a plumbing probe whose output the function captures with `-PassThru` and parses, so the
"Bicep CLI version X" line must not echo to the console on every build
([ADR-AUTO-PRELOG-SILENTSWITCH](../../../../drs/automation/log-before-invoke.md#rule-adr-auto-prelog-silentswitch)).
