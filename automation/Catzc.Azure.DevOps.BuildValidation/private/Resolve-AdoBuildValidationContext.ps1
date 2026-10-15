<#
.SYNOPSIS
    Resolves the ADO coordinates every build-validation call needs — org, project, repository id, API base.
.DESCRIPTION
    The well-known Build policy type id is held only here, so every public function reads one constant.
    [comment:1](/docs/references/automation/catzc-azure-devops-buildvalidation/private/Resolve-AdoBuildValidationContext.ps1.md#comment1)
.PARAMETER Project
    Azure DevOps project name. Defaults to the value in ado.yml.
.PARAMETER Organization
    Azure DevOps organization URL. Defaults to the value in ado.yml.
.PARAMETER RepositoryName
    Name of the Azure Repos Git repository. Defaults to this checkout's repository (Get-AdoRepositoryName).
.EXAMPLE
    $context = Resolve-AdoBuildValidationContext
#>
function Resolve-AdoBuildValidationContext {
    [CmdletBinding()]
    [OutputType([hashtable])]
    param(
        [string] $Project = (Get-Config -Config ado)['project'],

        [string] $Organization = (Get-Config -Config ado)['organization'],

        [string] $RepositoryName = (Get-AdoRepositoryName)
    )

    Assert-NotNullOrWhitespace $Project -ErrorText 'Project is required. Set -Project or configure ado.yml.'
    Assert-NotNullOrWhitespace $Organization -ErrorText 'Organization is required. Set -Organization or configure ado.yml.'
    $Organization = $Organization.TrimEnd('/')

    Assert-NotNullOrWhitespace $RepositoryName -ErrorText 'RepositoryName is required. Set -RepositoryName, or run inside a checkout or a pipeline.'

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
