<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.DevOps.BuildValidation/Get-AdoBuildValidations.ps1
    kind: automation-function
    language: powershell
    track: automation
    module: Catzc.Azure.DevOps.BuildValidation
    visibility: public
    relatives:
      test: automation/Catzc.Azure.DevOps.BuildValidation/tests/Get-AdoBuildValidations.Tests.ps1
    adrs:
      - ADR-FLOW-CD-GLOBS
      - ADR-FLOW-CD-TYPE#4
  config:
    synopsis: Lists the build-validation branch policies of the repository, optionally for one branch.
    description: |-
      Queries the ADO Policy Configurations REST API and returns one object per build-validation policy
      (policy type 'Build') scoped to the repository — the server-side pre-commit gates
      ([ADR-FLOW-CD-TYPE#4](/docs/adr/flow/pipeline-types.md#rule-adr-flow-cd-type4)). Each result carries the policy id,
      display name, the guarded branch, the path
      filters (a globset-tied policy filters on its native path projection,
      [ADR-FLOW-CD-GLOBS](/docs/adr/flow/durable-sha-globs.md)), the pipeline definition
      id it queues, the blocking/enabled bits, and the raw configuration.

      Read-only — registering and removing policies is Register-AdoBuildValidation /
      Unregister-AdoBuildValidation.
    parameters:
      Branch: Return only the policies guarding this branch (e.g. 'main'). Omit for every branch.
      Project: Azure DevOps project name. Defaults to the value in ado.yml.
      Organization: Azure DevOps organization URL. Defaults to the value in ado.yml.
      RepositoryName: Name of the Azure Repos Git repository. Defaults to this checkout's repository (Get-AdoRepositoryName).
    examples:
      - Get-AdoBuildValidations
      - Get-AdoBuildValidations -Branch main | Where-Object Blocking
---
#>

function Get-AdoBuildValidations {
    [CmdletBinding()]
    [OutputType([PSCustomObject[]])]
    param(
        [Parameter(Position = 0)]
        [string] $Branch,

        [string] $Project = (Get-Config -Config ado)['project'],

        [string] $Organization = (Get-Config -Config ado)['organization'],

        [string] $RepositoryName = (Get-AdoRepositoryName)
    )

    $context = Resolve-AdoBuildValidationContext -Project $Project -Organization $Organization -RepositoryName $RepositoryName

    $configurations = @(Invoke-AdoRestMethod -Uri "$($context.ApiBase)/policy/configurations?api-version=7.1")

    foreach ($configuration in $configurations) {
        if ("$($configuration.type.id)" -ne $context.PolicyTypeId) {
            continue
        }
        $scopes = @($configuration.settings.scope)
        $matchingScope = $scopes | Where-Object { "$($_.repositoryId)" -eq "$($context.RepositoryId)" } | Select-Object -First 1
        if (-not $matchingScope) {
            continue
        }
        $scopeBranch = "$($matchingScope.refName)" -replace '^refs/heads/', ''
        if ($Branch -and $scopeBranch -ne $Branch) {
            continue
        }

        [pscustomobject]@{
            Id                   = $configuration.id
            DisplayName          = $configuration.settings.displayName
            PipelineDefinitionId = $configuration.settings.buildDefinitionId
            Branch               = $scopeBranch
            PathFilters          = @($configuration.settings.filenamePatterns)
            Blocking             = [bool]$configuration.isBlocking
            Enabled              = [bool]$configuration.isEnabled
            Raw                  = $configuration
        }
    }
}
