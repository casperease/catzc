<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.QualityGates/Test-IdiomaticNames.ps1
    name: test-idiomatic-names
    filetype: ps1
    role: function
    subkind: gate
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Base.QualityGates/tests/Test-IdiomaticNames.Tests.ps1
    docs: "[Test-IdiomaticNames.ps1.md](docs/references/pwsh/catzc-base-qualitygates/Test-IdiomaticNames.ps1.md)"
    cites:
      - ADR-AUTO-IDIOM-LANGUAGEIDIOM
---
#>

function Test-IdiomaticNames {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Reports.QualityGateResult])]
    param(
        [string] $OutputFolder,

        [switch] $PassThru
    )

    Assert-SourceTree

    $tracked = @(Get-GitTrackedPath '.')
    $issues = (Get-Config -Config languages).MisnamedPaths([string[]] $tracked)

    Write-QualityGateReport -Subject idiomatic-names -Title Test-IdiomaticNames -Issues ([string[]] @($issues)) `
        -Facts ([ordered]@{ Files = $tracked.Count }) -OutputFolder $OutputFolder -PassThru:$PassThru
}
