<#
.SYNOPSIS
    Lists the build-validation branch policies of the repository, optionally for one branch.
.DESCRIPTION
    Queries the ADO Policy Configurations REST API and returns one object per build-validation policy
    (policy type 'Build') scoped to the repository — the server-side pre-commit gates
    (ADR-PIPETYPE:4). Each result carries the policy id, display name, the guarded branch, the path
    filters (a globset-tied policy filters on its sha-marker file, ADR-GLOBS:9), the pipeline definition
    id it queues, the blocking/enabled bits, and the raw configuration.

    Read-only — registering and removing policies is Register-AdoBuildValidation /
    Unregister-AdoBuildValidation.
.PARAMETER Branch
    Return only the policies guarding this branch (e.g. 'main'). Omit for every branch.
.PARAMETER Project
    Azure DevOps project name. Defaults to the value in ado.yml.
.PARAMETER Organization
    Azure DevOps organization URL. Defaults to the value in ado.yml.
.PARAMETER RepositoryName
    Name of the Azure Repos Git repository. Defaults to $env:BUILD_REPOSITORY_NAME or the leaf folder of
    $env:RepositoryRoot.
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

        [string] $Project,

        [string] $Organization,

        [string] $RepositoryName
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
