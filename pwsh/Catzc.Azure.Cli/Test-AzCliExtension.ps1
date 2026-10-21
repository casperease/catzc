<#
---
catzc:
  immutable:
    with_body_sha: "43f5b96ebde8"
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
