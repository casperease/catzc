<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.Templates/Get-BicepTemplatesOutputRoot.ps1
    kind: function
    module: Catzc.Azure.Templates
    visibility: public
    adrs:
      - ADR-AUTO-TEST#26
      - ADR-PWSH-PESTER#2
---
#>

<#
.SYNOPSIS
    Returns the root folder Build-Bicep writes template build output under.
.DESCRIPTION
    A build test mocks this root to its own folder, so no two test files ever write the same build folder.
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
