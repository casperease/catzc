# catzc:
#   path: automation/Catzc.Azure.Templates/Get-BicepTemplatesOutputRoot.ps1
#   module: Catzc.Azure.Templates
#   visibility: public

<#
.SYNOPSIS
    Returns the root folder Build-Bicep writes template build output under.
.DESCRIPTION
    A build test mocks this root to its own folder, so no two test files ever write the same build folder.
    [ADR-AUTO-TEST#26](/docs/adr/automation/test-automation.md#rule-adr-auto-test26),
    [ADR-PWSH-PESTER#2](/docs/adr/pwsh/pester-testing.md#rule-adr-pwsh-pester2)
    [comment:1](/docs/references/automation/catzc-azure-templates/Get-BicepTemplatesOutputRoot.ps1.md#comment1)
.OUTPUTS
    [string] the absolute output root path.
.EXAMPLE
    Get-BicepTemplatesOutputRoot
#>
function Get-BicepTemplatesOutputRoot {
    [CmdletBinding()]
    [OutputType([string])]
    param()

    Join-Path (Get-RepositoryRoot) 'out'
}
