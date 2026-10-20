<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Azure.DevOps.BuildValidation/Sync-AdoBuildValidations.ps1
    name: sync-ado-build-validations
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Azure.DevOps.BuildValidation
    moduletype: pwsh-folder
    catzc_bundle: full
    visibility: public
  edges:
    test: pwsh/Catzc.Azure.DevOps.BuildValidation/tests/Sync-AdoBuildValidations.Tests.ps1
    docs: "[Sync-AdoBuildValidations.ps1.md](docs/references/pwsh/catzc-azure-devops-buildvalidation/Sync-AdoBuildValidations.ps1.md)"
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
