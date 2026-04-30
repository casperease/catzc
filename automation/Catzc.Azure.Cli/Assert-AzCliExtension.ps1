<#
.SYNOPSIS
    Asserts that an Azure CLI extension is installed, throwing with remediation if not.
.DESCRIPTION
    Throws a remediation-bearing error when the named extension is missing, so a command that depends on
    it fails fast with a clear message instead of a cryptic argument error (az exit code 2) or — with
    dynamic install disabled in Invoke-AzCli — a hang on the install prompt. Asserts only; it never
    installs the extension, mirroring how Assert-AzCliConnected asserts rather than logging in.

    Guard an extension-dependent call by asserting immediately before it:

        Assert-AzCliExtension 'ip-group'
        Invoke-AzCli "network ip-group list --resource-group $rg -o json" -PassThru
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
