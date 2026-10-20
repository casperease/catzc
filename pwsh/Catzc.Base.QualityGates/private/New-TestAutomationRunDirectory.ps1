<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.QualityGates/private/New-TestAutomationRunDirectory.ps1
    folder: private
    name: new-test-automation-run-directory
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
    test: pwsh/Catzc.Base.QualityGates/tests/New-TestAutomationRunDirectory.Tests.ps1
    docs: "[New-TestAutomationRunDirectory.ps1.md](docs/references/pwsh/catzc-base-qualitygates/private/New-TestAutomationRunDirectory.ps1.md)"
---
#>

function New-TestAutomationRunDirectory {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [string] $OutputFolder
    )

    $stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
    $runDirectory = Join-Path $OutputFolder $stamp
    $suffix = 2
    while (Test-Path $runDirectory) {
        $runDirectory = Join-Path $OutputFolder "$stamp-$suffix"
        $suffix++
    }
    New-Item -ItemType Directory -Path $runDirectory -Force | Out-Null
    $runDirectory
}
