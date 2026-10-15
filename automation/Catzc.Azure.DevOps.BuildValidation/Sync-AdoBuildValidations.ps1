<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.DevOps.BuildValidation/Sync-AdoBuildValidations.ps1
    kind: function
    module: Catzc.Azure.DevOps.BuildValidation
    visibility: public
    adrs: []
---
#>

<#
.SYNOPSIS
    Registers every build-validation branch policy declared in build-validation.yml. Idempotent.
.DESCRIPTION
    The local config is the source of truth: this converges the ADO project to it, never the other way round.
    [comment:1](/docs/references/automation/catzc-azure-devops-buildvalidation/Sync-AdoBuildValidations.ps1.md#comment1)
.PARAMETER Branch
    Override the branch for every policy. Defaults from build-validation.yml 'branch'.
.PARAMETER Project
    Azure DevOps project name. Defaults to the value in ado.yml.
.PARAMETER Organization
    Azure DevOps organization URL. Defaults to the value in ado.yml.
.PARAMETER RepositoryName
    Name of the Azure Repos Git repository. Defaults to this checkout's repository (Get-AdoRepositoryName).
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

        [string] $RepositoryName = (Get-AdoRepositoryName),

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
