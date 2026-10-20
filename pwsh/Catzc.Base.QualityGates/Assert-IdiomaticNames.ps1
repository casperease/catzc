<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.QualityGates/Assert-IdiomaticNames.ps1
    name: assert-idiomatic-names
    filetype: ps1
    role: function
    subkind: assert
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Base.QualityGates/tests/Assert-IdiomaticNames.Tests.ps1
    docs: "[Assert-IdiomaticNames.ps1.md](docs/references/pwsh/catzc-base-qualitygates/Assert-IdiomaticNames.ps1.md)"
    cites:
      - ADR-AUTO-IDIOM-HELDBYGATE
---
#>

function Assert-IdiomaticNames {
    [CmdletBinding()]
    param()

    Assert-SourceTree

    $issues = @((Get-Config -Config languages).MisnamedPaths([string[]] @(Get-GitTrackedPath '.')))
    if ($issues.Count -gt 0) {
        throw "$($issues.Count) file and folder name(s) break their language's naming (Catzc.Base.Languages configs/languages.yml):`n$($issues -join "`n")"
    }
}
