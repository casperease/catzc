<#
---
catzc:
  immutable:
    with_body_sha: "2f024148ce1c"
  edges:
    test: pwsh/Catzc.Azure.Templates/tests/Get-BicepTemplatesOutputRoot.Tests.ps1
    docs: "[Get-BicepTemplatesOutputRoot.ps1.md](../../docs/references/pwsh/catzc-azure-templates/Get-BicepTemplatesOutputRoot.ps1.md)"
    cites:
      - ADR-AUTO-TEST-ONESCHEDULINGPOOL
      - ADR-PWSH-PESTER-ISOLATETHROUGHSEAMS
---
#>

function Get-BicepTemplatesOutputRoot {
    [CmdletBinding()]
    [OutputType([string])]
    param()

    Join-Path (Get-RepositoryRoot) 'out'
}
