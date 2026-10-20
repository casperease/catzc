<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.QualityGates/private/Get-GeneratedFileGenerator.ps1
    folder: private
    name: get-generated-file-generator
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
    docs: "[Get-GeneratedFileGenerator.ps1.md](docs/references/pwsh/catzc-base-qualitygates/private/Get-GeneratedFileGenerator.ps1.md)"
    cites:
      - ADR-AUTO-TEST-QUALITYGATE
---
#>

function Get-GeneratedFileGenerator {
    [CmdletBinding()]
    [OutputType([string[]])]
    param()

    $writers = @((Get-Config -Config generated-files).writers.Keys)
    $rootGenerators = @((Get-Config -Config rootconfig).files | Where-Object { $_.optIn -and $_.generator } | ForEach-Object { "$($_.generator)" } | Select-Object -Unique)
    [string[]] @($writers + $rootGenerators)
}
