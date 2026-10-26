# pwsh/Tooling.Toolchain/private/Resolve-DotnetRemovalTarget.ps1

A private helper of `Remove-Dotnet`: the choice of the folder to evict when the caller names none.

## help

### synopsis

The .NET folder Remove-Dotnet evicts by default: the off-config install, never the managed one.

### description

The folder of the `dotnet` on PATH, unless that is the managed user-space install (Test-ExpectedPackageManager -Path) — in a catzc session
it always is, because the importer puts the managed install first — in which case the machine-wide C:\Program Files\dotnet, the folder a
system installer places. Remove-Dotnet's -InstallDir default
([ADR-PWSH-PARAM-RESOLUTIONORDER](../../../../drs/automation/pwsh/parameter-design.md#rule-adr-pwsh-param-resolutionorder)).

### outputs

`[string]` The folder.
