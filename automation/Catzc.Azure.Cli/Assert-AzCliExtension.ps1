<#
.SYNOPSIS
    Asserts that an Azure CLI extension is installed, throwing with remediation if not.
.DESCRIPTION
    Throws a remediation-bearing error when the named extension is missing, so a command that depends on it fails...
    [comment:1](/docs/references/automation/catzc-azure-cli/Assert-AzCliExtension.ps1.md#comment1)
.PARAMETER Name
    The required extension name (e.g. 'ip-group').
.EXAMPLE
    Assert-AzCliExtension 'ip-group'
#>
function Assert-AzCliExtension {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string]$Name
    )

    if (-not (Test-AzCliExtension -Name $Name)) {
        throw "The Azure CLI extension '$Name' is required but not installed. Install it with: az extension add --name $Name (add --allow-preview true if only a preview version exists)."
    }
}
