<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.Templates/private/Get-BicepTemplatesRoot.ps1
    kind: private-function
    module: Catzc.Azure.Templates
    visibility: private
    adrs: []
---
#>

<#
.SYNOPSIS
    Returns the root directory under which bicep templates are discovered.
.DESCRIPTION
    Tests mock this seam to a fixture tree, and the discovery cache keys on it, so the roots never collide.
.EXAMPLE
    Get-BicepTemplatesRoot   # -> <repo>/infrastructure/templates
#>
function Get-BicepTemplatesRoot {
    [OutputType([string])]
    param()

    Join-Path (Get-RepositoryRoot) 'infrastructure/templates'
}
