<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-azure-dev-ops-build-validation/Sync-AdoBuildValidations.ps1.md"
  header: "generated"
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
