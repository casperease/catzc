<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.Cli/Test-AzCliExtension.ps1
    kind: function
    module: Catzc.Azure.Cli
    visibility: public
    adrs: []
---
#>

<#
.SYNOPSIS
    Tests whether an Azure CLI extension is installed.
.DESCRIPTION
    Reads the exit code of a core command, so a missing extension never throws or triggers a dynamic install.
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
