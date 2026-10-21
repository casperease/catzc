<#
---
catzc:
  immutable:
    with_body_sha: bac2dccec20a
  edges:
    test: pwsh/Catzc.Base.QualityGates/tests/New-TestAutomationRunDirectory.Tests.ps1
    docs: "[New-TestAutomationRunDirectory.ps1.md](docs/references/pwsh/catzc-base-quality-gates/private/New-TestAutomationRunDirectory.ps1.md)"
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
