<#
---
catzc:
  immutable:
    with_body_sha: "2b0e73e50126"
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
