<#
.SYNOPSIS
    Returns the root folder Build-Bicep writes template build output under.
.DESCRIPTION
    The output-side twin of Get-BicepTemplatesRoot: templates' output_folder descriptors resolve to <output...
    [ADR-PWSH-PESTER#2](/docs/adr/pwsh/pester-testing.md#rule-adr-pwsh-pester2),
    [ADR-AUTO-TEST#26](/docs/adr/automation/test-automation.md#rule-adr-auto-test26)
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
