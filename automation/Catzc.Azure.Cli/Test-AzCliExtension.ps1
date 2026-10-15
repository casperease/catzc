<#
.SYNOPSIS
    Tests whether an Azure CLI extension is installed.
.DESCRIPTION
    Returns $true if the named extension is installed, $false otherwise.
    [comment:1](/docs/references/automation/catzc-azure-cli/Test-AzCliExtension.ps1.md#comment1)
.PARAMETER Name
    The extension name (e.g. 'ip-group').
.OUTPUTS
    System.Boolean
.EXAMPLE
    if (Test-AzCliExtension 'ip-group') { '...installed' }
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
