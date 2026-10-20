<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.QualityGates/private/Write-TestAutomationHeader.ps1
    folder: private
    name: write-test-automation-header
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
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
