<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-quality-gates/Test-IdiomaticNames.ps1.md"
  header: "generated"
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
