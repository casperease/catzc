<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-variants/Test-HaveCustomers.ps1.md"
  header: "generated"
---
#>

function Test-HaveCustomers {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Position = 0)]
        [string[]] $Name
    )

    $enabled = Get-EnabledCustomers
    $isAll = ($enabled -is [string]) -and ($enabled -ceq 'all')
    # assigned in the branch, not from an if-expression, which would unroll a 0/1-item array to $null/a scalar
    $enabledList = @()
    if (-not $isAll) {
        $enabledList = @($enabled)
    }
    $any = $isAll -or ($enabledList.Count -gt 0)

    if (-not $PSBoundParameters.ContainsKey('Name')) {
        return [bool] $any
    }
    if (-not $any) {
        return $false
    }
    if ($isAll) {
        return $true
    }
    foreach ($customer in $Name) {
        if ("$customer" -notin $enabledList) {
            return $false
        }
    }
    $true
}
