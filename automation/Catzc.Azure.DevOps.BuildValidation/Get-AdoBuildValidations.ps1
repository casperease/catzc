<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.DevOps.BuildValidation/Get-AdoBuildValidations.ps1
    kind: public-function
    module: Catzc.Azure.DevOps.BuildValidation
    visibility: public
    adrs:
      - ADR-FLOW-CD-GLOBS
      - ADR-FLOW-CD-TYPE#4
---
#>

<#
.SYNOPSIS
    Lists the build-validation branch policies of the repository, optionally for one branch.
.DESCRIPTION
    Read-only: a policy's path filters are its only tie back to a globset, so they are reported as the server has them.
.PARAMETER Branch
    Return only the policies guarding this branch (e.g. 'main'). Omit for every branch.
.PARAMETER Project
    Azure DevOps project name. Defaults to the value in ado.yml.
.PARAMETER Organization
    Azure DevOps organization URL. Defaults to the value in ado.yml.
.PARAMETER RepositoryName
    Name of the Azure Repos Git repository. Defaults to this checkout's repository (Get-AdoRepositoryName).
.EXAMPLE
    Get-AdoBuildValidations
.EXAMPLE
    Get-AdoBuildValidations -Branch main | Where-Object Blocking
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
