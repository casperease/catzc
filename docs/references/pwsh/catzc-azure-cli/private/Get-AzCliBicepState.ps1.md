# pwsh/Catzc.Azure.Cli/private/Get-AzCliBicepState.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

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

## comment:1

Above `$result = Invoke-AzCli 'bicep version' -PassThru -NoAssert -Silent`, written with `#`.

```text
-Silent: a plumbing probe whose output we capture via -PassThru and parse below, so the
"Bicep CLI version X" line should not echo to the console on every build. See log ADR rule
[ADR-AUTO-PRELOG-SILENTSWITCH](/docs/drs/automation/log-before-invoke.md#rule-adr-auto-prelog-silentswitch).
```
