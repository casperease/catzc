<#
.SYNOPSIS
    Registers every build-validation branch policy declared in build-validation.yml. Idempotent.
.DESCRIPTION
    The config-driven reconcile: for each entry under 'validations' in build-validation.yml, runs
    Register-AdoBuildValidation — creating missing policies, updating drifted ones, and leaving current
    ones alone — and emits each result. This is the everything-as-code path for the server-side policies:
    the local config is the source of truth, and this function converges the ADO project to it.
.PARAMETER Branch
    Override the branch for every policy. Defaults from build-validation.yml 'branch'.
.PARAMETER Project
    Azure DevOps project name. Defaults to the value in ado.yml.
.PARAMETER Organization
    Azure DevOps organization URL. Defaults to the value in ado.yml.
.PARAMETER RepositoryName
    Name of the Azure Repos Git repository. Defaults to $env:BUILD_REPOSITORY_NAME or the leaf folder of
    $env:RepositoryRoot.
.PARAMETER DryRun
    Return every entry's planned action (Create/Update/Unchanged) without touching the server.
.EXAMPLE
    Sync-AdoBuildValidations -DryRun
.EXAMPLE
    Sync-AdoBuildValidations
#>
function Sync-AdoBuildValidations {
    [CmdletBinding()]
    [OutputType([PSCustomObject[]])]
    param(
        [string] $Branch,

        [string] $Project,

        [string] $Organization,

        [string] $RepositoryName,

        [switch] $DryRun
    )

    $config = Get-Config -Config build-validation
    $entries = @($config.validations)

    foreach ($entry in $entries) {
        $params = @{
            GlobSet = $entry.globset
            DryRun  = $DryRun
        }
        if ($Branch) {
            $params.Branch = $Branch
        }
        if ($Project) {
            $params.Project = $Project
        }
        if ($Organization) {
            $params.Organization = $Organization
        }
        if ($RepositoryName) {
            $params.RepositoryName = $RepositoryName
        }
        Register-AdoBuildValidation @params
    }
}
