<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.Cli/Assert-AzCliExtension.ps1
    kind: function
    module: Catzc.Azure.Cli
    visibility: public
    adrs: []
---
#>

<#
.SYNOPSIS
    Asserts that an Azure CLI extension is installed, throwing with remediation if not.
.DESCRIPTION
    It only asserts and never installs, so a missing extension is a clear error, not a hang on the install prompt.
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
