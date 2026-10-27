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

    # The pull-request policies guard a branch only a pull request reaches; in main-direct no pull request exists to guard.
    if ((Get-GitWorkspace) -eq 'main-via-pr') {
        $params = @{ DryRun = $DryRun }
        foreach ($name in 'Branch', 'Project', 'Organization', 'RepositoryName') {
            $value = Get-Variable -Name $name -ValueOnly
            if ($value) {
                $params[$name] = $value
            }
        }
        Register-AdoBranchPolicies @params
    }
}
