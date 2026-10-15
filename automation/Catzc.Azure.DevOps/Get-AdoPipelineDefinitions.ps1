# catzc:
#   path: automation/Catzc.Azure.DevOps/Get-AdoPipelineDefinitions.ps1
#   module: Catzc.Azure.DevOps
#   visibility: public

<#
.SYNOPSIS
    Lists all registered pipeline definitions from Azure DevOps.
.DESCRIPTION
    YamlPath drops its leading slash so it matches the RelativePath that Get-AdoYamlFiles returns.
    [comment:1](/docs/references/automation/catzc-azure-devops/Get-AdoPipelineDefinitions.ps1.md#comment1)
.PARAMETER Project
    Azure DevOps project name. Defaults to the value in ado.yml.
.PARAMETER Organization
    Azure DevOps organization URL. Defaults to the value in ado.yml.
.EXAMPLE
    Get-AdoPipelineDefinitions
.EXAMPLE
    Get-AdoPipelineDefinitions -Organization 'https://dev.azure.com/myorg' -Project 'myproject'
.EXAMPLE
    Get-AdoPipelineDefinitions | Where-Object RepositoryName -eq 'big-mono'
#>
function Get-AdoPipelineDefinitions {
    [CmdletBinding()]
    [OutputType([PSCustomObject[]])]
    param(
        [string] $Project = (Get-Config -Config ado)['project'],

        [string] $Organization = (Get-Config -Config ado)['organization']
    )

    Assert-NotNullOrWhitespace $Project -ErrorText 'Project is required. Set -Project or configure ado.yml.'
    Assert-NotNullOrWhitespace $Organization -ErrorText 'Organization is required. Set -Organization or configure ado.yml.'
    $Organization = $Organization.TrimEnd('/')

    $apiBase = "$Organization/$Project/_apis"

    Write-Message "Listing pipeline definitions from: $Organization/$Project"

    $definitions = Invoke-AdoRestMethod -Uri "$apiBase/build/definitions?api-version=7.1&includeAllProperties=true&`$top=10000"
    Assert-NotNull $definitions -ErrorText 'Build Definitions API returned null'

    $count = ($definitions | Measure-Object).Count

    # Older ADO Server versions ignore includeAllProperties, so a missing yamlFilename triggers per-definition fetches.
    # [comment:2](/docs/references/automation/catzc-azure-devops/Get-AdoPipelineDefinitions.ps1.md#comment2)
    $hasProcessDetails = $definitions | Where-Object { $_.process.yamlFilename } | Select-Object -First 1
    if (-not $hasProcessDetails -and $count -gt 0) {
        Write-Message "Found $count pipeline definitions, fetching details individually"
        $definitions = foreach ($definition in $definitions) {
            Invoke-AdoRestMethod -Uri "$apiBase/build/definitions/$($definition.id)?api-version=7.1" -UnwrapValue $false
        }
    }
    else {
        Write-Message "Found $count pipeline definitions"
    }

    foreach ($definition in $definitions) {
        $yamlPath = $definition.process.yamlFilename
        if ($yamlPath) {
            $yamlPath = $yamlPath.TrimStart('/').TrimStart('.\') -replace '\\', '/'
        }

        $fileName = if ($yamlPath) {
            Split-Path $yamlPath -Leaf
        }
        else {
            $null
        }
        $repoName = $definition.repository.properties.shortName ?? $definition.repository.name

        [Catzc.Azure.DevOps.PipelineDefinition]::new(
            $definition.id, $definition.name, $definition.path, $yamlPath, $fileName, $repoName, $definition.revision, $definition._links.web.href)
    }
}
