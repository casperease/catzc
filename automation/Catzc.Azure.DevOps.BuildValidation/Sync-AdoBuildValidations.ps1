<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.DevOps.BuildValidation/Sync-AdoBuildValidations.ps1
    kind: automation-function
    language: powershell
    track: automation
    module: Catzc.Azure.DevOps.BuildValidation
    visibility: public
    relatives:
      test: automation/Catzc.Azure.DevOps.BuildValidation/tests/Sync-AdoBuildValidations.Tests.ps1
  config:
    synopsis: Registers every build-validation branch policy declared in build-validation.yml. Idempotent.
    description: |-
      The config-driven reconcile: for each entry under 'validations' in build-validation.yml, runs
      Register-AdoBuildValidation — creating missing policies, updating drifted ones, and leaving current
      ones alone — and emits each result. This is the everything-as-code path for the server-side policies:
      the local config is the source of truth, and this function converges the ADO project to it.
    parameters:
      Branch: Override the branch for every policy. Defaults from build-validation.yml 'branch'.
      Project: Azure DevOps project name. Defaults to the value in ado.yml.
      Organization: Azure DevOps organization URL. Defaults to the value in ado.yml.
      RepositoryName: Name of the Azure Repos Git repository. Defaults to this checkout's repository (Get-AdoRepositoryName).
      DryRun: Return every entry's planned action (Create/Update/Unchanged) without touching the server.
    examples:
      - Sync-AdoBuildValidations -DryRun
      - Sync-AdoBuildValidations
---
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
