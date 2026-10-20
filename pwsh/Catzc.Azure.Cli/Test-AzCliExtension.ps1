<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Azure.Cli/Test-AzCliExtension.ps1
    name: test-az-cli-extension
    filetype: ps1
    role: function
    subkind: gate
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Azure.Cli
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    docs: "[Test-AzCliExtension.ps1.md](docs/references/pwsh/catzc-azure-cli/Test-AzCliExtension.ps1.md)"
---
#>

function Test-AzCliExtension {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string]$Name
    )

    # `extension show` is core; -NoAssert so a "not installed" non-zero exit is reported, not thrown.
    $cli = Invoke-AzCli "extension show --name $Name -o none" -PassThru -Silent -NoAssert
    return $cli.ExitCode -eq 0
}
