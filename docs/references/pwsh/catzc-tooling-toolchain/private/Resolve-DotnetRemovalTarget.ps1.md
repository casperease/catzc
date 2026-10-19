# automation/pwsh/Catzc.Tooling.Toolchain/private/Resolve-DotnetRemovalTarget.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

The .NET folder Remove-Dotnet evicts by default: the off-config install, never the managed one.

### description

The folder of the `dotnet` on PATH, unless that is the managed user-space install (Test-ExpectedPackageManager -Path) — in a catzc session
it always is, because the importer puts the managed install first — in which case the machine-wide C:\Program Files\dotnet, the folder a
system installer places. Remove-Dotnet's -InstallDir default
([ADR-PWSH-PARAM-RESOLUTIONORDER](../../../../adr/automation/pwsh/parameter-design.md#rule-adr-pwsh-param-resolutionorder)).

### outputs

`[string]` The folder.
