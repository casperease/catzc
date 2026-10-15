<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.Templates/private/Get-BicepTemplatesRoot.ps1
    kind: function
    module: Catzc.Azure.Templates
    visibility: private
---
#>

<#
.SYNOPSIS
    Returns the root directory under which bicep templates are discovered.
.DESCRIPTION
    Tests mock this seam to a fixture tree, and the discovery cache keys on it, so the roots never collide.
    [comment:1](/docs/references/automation/catzc-azure-templates/private/Get-BicepTemplatesRoot.ps1.md#comment1)
.EXAMPLE
    Get-BicepTemplatesRoot   # -> <repo>/infrastructure/templates
#>
function Get-BicepTemplatesRoot {
    [OutputType([string])]
    param()

    Join-Path (Get-RepositoryRoot) 'infrastructure/templates'
}
