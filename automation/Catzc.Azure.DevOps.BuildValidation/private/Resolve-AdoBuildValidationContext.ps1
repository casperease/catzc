<#
.SYNOPSIS
    Resolves the ADO coordinates every build-validation call needs — org, project, repository id, API base.
.DESCRIPTION
    Defaults organization/project from ado.yml and the repository name from $env:BUILD_REPOSITORY_NAME or
    the repository root's leaf folder (the same defaulting as Register-AdoPipeline), resolves the
    repository to its GUID via the Git repositories API, and returns one context object the public
    functions share — including the well-known Build policy type id, so the constant lives in exactly one
    place.
.PARAMETER Project
    Azure DevOps project name. Defaults to the value in ado.yml.
.PARAMETER Organization
    Azure DevOps organization URL. Defaults to the value in ado.yml.
.PARAMETER RepositoryName
    Name of the Azure Repos Git repository. Defaults to $env:BUILD_REPOSITORY_NAME or the leaf folder of
    $env:RepositoryRoot.
.EXAMPLE
    $context = Resolve-AdoBuildValidationContext
#>
function Resolve-AdoBuildValidationContext {
    [CmdletBinding()]
    [OutputType([hashtable])]
    param(
        [string] $Project,

        [string] $Organization,

        [string] $RepositoryName
    )

    $adoConfig = Get-Config -Config ado
    if (-not $Project) {
        $Project = $adoConfig['project']
    }
    if (-not $Organization) {
        $Organization = $adoConfig['organization']
    }

    Assert-NotNullOrWhitespace $Project -ErrorText 'Project is required. Set -Project or configure ado.yml.'
    Assert-NotNullOrWhitespace $Organization -ErrorText 'Organization is required. Set -Organization or configure ado.yml.'
    $Organization = $Organization.TrimEnd('/')

    if (-not $RepositoryName) {
        $RepositoryName = if ($env:BUILD_REPOSITORY_NAME) {
            $env:BUILD_REPOSITORY_NAME
        }
        else {
            Split-Path $env:RepositoryRoot -Leaf
        }
        Assert-NotNullOrWhitespace $RepositoryName -ErrorText 'RepositoryName is required. Set -RepositoryName, or ensure $env:BUILD_REPOSITORY_NAME or $env:RepositoryRoot is set.'
    }

    $apiBase = "$Organization/$Project/_apis"

    $repositories = @(Invoke-AdoRestMethod -Uri "$apiBase/git/repositories?api-version=7.1")
    $found = $repositories | Where-Object { $_.name -eq $RepositoryName } | Select-Object -First 1
    Assert-NotNull $found -ErrorText "Repository '$RepositoryName' not found in project '$Project'"

    @{
        Organization   = $Organization
        Project        = $Project
        ApiBase        = $apiBase
        RepositoryName = $RepositoryName
        RepositoryId   = $found.id
        # The well-known ADO 'Build' policy type — the discriminator every build-validation policy carries.
        PolicyTypeId   = '0609b952-1397-4640-95ec-e00a01b2c241'
    }
}
