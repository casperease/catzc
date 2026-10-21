<#
---
catzc:
  immutable:
    with_body_sha: d437c4a1cd86
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
    $config = Get-Config -Config languages
    # Every misnamed folder and file, then every function and type name a tracked file defines that breaks its case or its round trip.
    $definitions = @(Get-DefinedName -Path $tracked)
    $issues = @($config.MisnamedPaths([string[]] $tracked)) + @(foreach ($definition in $definitions) {
            $finding = $config.MisnamedDefinition($definition.Path, $definition.Kind, $definition.Name)
            if ($null -ne $finding) {
                $finding
            }
        })

    Write-QualityGateReport -Subject idiomatic-names -Title Test-IdiomaticNames -Issues ([string[]] @($issues)) `
        -Facts ([ordered]@{ Files = $tracked.Count; Definitions = $definitions.Count }) -OutputFolder $OutputFolder -PassThru:$PassThru
}
