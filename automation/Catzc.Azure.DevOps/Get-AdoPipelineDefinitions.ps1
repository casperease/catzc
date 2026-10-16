<#
---
catzc:
  immutable:
    path: automation/Catzc.Azure.DevOps/Get-AdoPipelineDefinitions.ps1
    name: get-ado-pipeline-definitions
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Azure.DevOps
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    page: docs/references/automation/catzc-azure-devops/Get-AdoPipelineDefinitions.ps1.md
  config:
    synopsis: Lists all registered pipeline definitions from Azure DevOps.
    description: |-
      Queries the ADO Build Definitions REST API and returns a flattened
      list of pipeline definitions with their YAML paths, repository names,
      and ADO folder placement.

      YamlPath is normalized (leading '/' stripped) to match the RelativePath
      output of Get-AdoYamlFiles for easy cross-referencing.
    parameters:
      Project: Azure DevOps project name. Defaults to the value in ado.yml.
      Organization: Azure DevOps organization URL. Defaults to the value in ado.yml.
    examples:
      - Get-AdoPipelineDefinitions
      - Get-AdoPipelineDefinitions -Organization 'https://dev.azure.com/myorg' -Project 'myproject'
      - Get-AdoPipelineDefinitions | Where-Object RepositoryName -eq 'big-mono'
---
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
