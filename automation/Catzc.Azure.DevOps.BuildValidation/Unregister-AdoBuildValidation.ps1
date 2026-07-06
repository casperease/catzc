<#
.SYNOPSIS
    Removes the build-validation branch policy tied to a globset. Idempotent — a no-op when none exists.
.DESCRIPTION
    Finds the build-validation policy whose path filter is the globset's sha-marker file
    (.sha-markers/<name>.yml — the tie between policy and globset, ADR-GLOBS:9) on the guarded branch and
    deletes it. When no such policy exists the function reports and returns without error (ADR-IDEM:2).
.PARAMETER GlobSet
    The declared globset whose policy to remove (a name in globs.yml).
.PARAMETER Branch
    The branch the policy guards. Defaults from build-validation.yml 'branch'.
.PARAMETER Project
    Azure DevOps project name. Defaults to the value in ado.yml.
.PARAMETER Organization
    Azure DevOps organization URL. Defaults to the value in ado.yml.
.PARAMETER RepositoryName
    Name of the Azure Repos Git repository. Defaults to $env:BUILD_REPOSITORY_NAME or the leaf folder of
    $env:RepositoryRoot.
.PARAMETER DryRun
    Return the planned removal (the matched policy id) without touching the server.
.EXAMPLE
    Unregister-AdoBuildValidation nova
.EXAMPLE
    Unregister-AdoBuildValidation nova -DryRun
#>
function Unregister-AdoBuildValidation {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $GlobSet,

        [string] $Branch,

        [string] $Project,

        [string] $Organization,

        [string] $RepositoryName,

        [switch] $DryRun
    )

    Assert-NotNullOrWhitespace $GlobSet

    $set = Get-GlobSet -Name $GlobSet
    $config = Get-Config -Config build-validation
    if (-not $Branch) {
        $Branch = $config.branch
    }
    Assert-NotNullOrWhitespace $Branch -ErrorText 'Branch is required. Set -Branch or configure build-validation.yml.'

    $context = Resolve-AdoBuildValidationContext -Project $Project -Organization $Organization -RepositoryName $RepositoryName

    $pathFilter = "/$($set.MarkerPath)"
    $validations = @(Get-AdoBuildValidations -Branch $Branch -Project $context.Project -Organization $context.Organization -RepositoryName $context.RepositoryName)
    $found = $validations | Where-Object { @($_.PathFilters) -contains $pathFilter } | Select-Object -First 1

    if (-not $found) {
        Write-Message "No build validation tied to globset '$GlobSet' on $Branch - nothing to remove"
        return
    }

    if ($DryRun) {
        return [pscustomobject]@{
            GlobSet  = $GlobSet
            Action   = 'Remove'
            Branch   = $Branch
            PolicyId = $found.Id
        }
    }

    Invoke-AdoRestMethod -Uri "$($context.ApiBase)/policy/configurations/$($found.Id)?api-version=7.1" -Method Delete -UnwrapValue $false | Out-Null
    Write-Message "Removed build validation '$($found.DisplayName)' (id: $($found.Id)) for globset '$GlobSet' on $Branch"
}
