<#
.SYNOPSIS
    Returns the root directory under which bicep templates are discovered.
.DESCRIPTION
    The single seam for *where* Get-BicepTemplates scans: $(Get-RepositoryRoot)/infrastructure/templates.
    [comment:1](/docs/references/automation/catzc-azure-templates/private/Get-BicepTemplatesRoot.ps1.md#comment1)
.EXAMPLE
    Get-BicepTemplatesRoot   # -> <repo>/infrastructure/templates
#>
function Get-BicepTemplatesRoot {
    [OutputType([string])]
    param()

    Join-Path (Get-RepositoryRoot) 'infrastructure/templates'
}
