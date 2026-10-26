<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-quality-gates/Assert-IdiomaticNames.ps1.md"
  header: "generated"
---
#>

function Assert-IdiomaticNames {
    [CmdletBinding()]
    param()

    Assert-SourceTree

    $tracked = @(Get-GitTrackedPath '.')
    $config = Get-Config -Config languages
    $issues = @($config.MisnamedPaths([string[]] $tracked)) + @(foreach ($definition in @(Get-DefinedName -Path $tracked)) {
            $finding = $config.MisnamedDefinition($definition.Path, $definition.Kind, $definition.Name)
            if ($null -ne $finding) {
                $finding
            }
        })
    if ($issues.Count -gt 0) {
        throw "$($issues.Count) file, folder, function and type name(s) break their language's naming (Catzc.Base.Languages configs/languages.yml):`n$($issues -join "`n")"
    }
}
