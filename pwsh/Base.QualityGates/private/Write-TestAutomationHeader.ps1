<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-quality-gates/private/Write-TestAutomationHeader.ps1.md"
  header: "generated"
---
#>

function Write-TestAutomationHeader {
    [CmdletBinding()]
    param(
        [int] $MinLevel = 0,

        [int] $MaxLevel = 2,

        [string] $Category = 'Both',

        [string[]] $Modules = @(),

        [string] $Title = 'Test Automation'
    )

    $scope = Format-TierRange -MinLevel $MinLevel -MaxLevel $MaxLevel
    if ($Category -ne 'Both') {
        $scope += ", $Category"
    }
    if ($Modules) {
        $scope += ", modules: $($Modules -join ', ')"
    }
    Write-Header "$Title — $scope" -ForegroundColor Cyan
}
