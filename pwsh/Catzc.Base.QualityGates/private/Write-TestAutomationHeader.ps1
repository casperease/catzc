<#
---
catzc:
  immutable:
    with_body_sha: fc57769308e9
  edges:
    test: pwsh/Catzc.Base.QualityGates/tests/Write-TestAutomationHeader.Tests.ps1
    docs: "[Write-TestAutomationHeader.ps1.md](docs/references/pwsh/catzc-base-qualitygates/private/Write-TestAutomationHeader.ps1.md)"
    cites:
      - ADR-AUTO-TEST-SAMETESTSBOTHRUNS
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
