# catzc:
#   path: automation/Catzc.Azure.DevOps/Register-AdoPipeline.ps1
#   module: Catzc.Azure.DevOps
#   visibility: public

<#
.SYNOPSIS
    Creates an Azure DevOps pipeline pointing to a YAML file.
.DESCRIPTION
    A pipeline with the same name that already exists throws, so a re-run never registers a duplicate.
    [comment:1](/docs/references/automation/catzc-azure-devops/Register-AdoPipeline.ps1.md#comment1)
.PARAMETER Name
    Display name for the pipeline in Azure DevOps.
.PARAMETER YamlPath
    Repository-relative path to the YAML file (e.g. 'pipelines/ci-automation.yaml').
.PARAMETER GitHubRepository
    Moves the pipeline's code from Azure Repos to GitHub, which needs a GitHub service connection in the project.
    [comment:2](/docs/references/automation/catzc-azure-devops/Register-AdoPipeline.ps1.md#comment2)
.PARAMETER ConnectionId
    ID of the GitHub service connection in ADO. Required when using -GitHubRepository.
.PARAMETER Project
    Azure DevOps project name. Defaults to the value in ado.yml.
.PARAMETER Organization
    Azure DevOps organization URL. Defaults to the value in ado.yml.
.PARAMETER RepositoryName
    Ignored when -GitHubRepository is set; otherwise it defaults to this checkout's own repository.
    [comment:3](/docs/references/automation/catzc-azure-devops/Register-AdoPipeline.ps1.md#comment3)
.PARAMETER FolderPath
    Pipeline folder path in ADO. Defaults to root ('\').
.EXAMPLE
    Register-AdoPipeline 'CI' 'pipelines/ci-automation.yaml'
.EXAMPLE
    Register-AdoPipeline 'CI' 'pipelines/ci-automation.yaml' -GitHubRepository 'https://github.com/casperease/catzc' -ConnectionId $id
.EXAMPLE
    Register-AdoPipeline 'CI Expected Failures' 'pipelines/ci-automation-expected-failures.yaml' -FolderPath '\CI'
#>
function Register-AdoPipeline {
    [CmdletBinding(DefaultParameterSetName = 'AzureRepos')]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Name,

        [Parameter(Mandatory, Position = 1)]
        [string] $YamlPath,

        [Parameter(ParameterSetName = 'GitHub', Mandatory)]
        [string] $GitHubRepository,

        [Parameter(ParameterSetName = 'GitHub', Mandatory)]
        [string] $ConnectionId,

        [string] $Project = (Get-Config -Config ado)['project'],

        [string] $Organization = (Get-Config -Config ado)['organization'],

        [Parameter(ParameterSetName = 'AzureRepos')]
        [string] $RepositoryName = (Get-AdoRepositoryName),

        [string] $FolderPath = '\'
    )

    Assert-NotNullOrWhitespace $Project -ErrorText 'Project is required. Set -Project or configure ado.yml.'
    Assert-NotNullOrWhitespace $Organization -ErrorText 'Organization is required. Set -Organization or configure ado.yml.'
    $Organization = $Organization.TrimEnd('/')

    $apiBase = "$Organization/$Project/_apis"

    # Check if pipeline already exists
    $existing = Invoke-AdoRestMethod -Uri "$apiBase/pipelines?api-version=7.1-preview.1"
    $found = $existing | Where-Object { $_.name -eq $Name } | Select-Object -First 1

    if ($found) {
        throw "Pipeline '$Name' already exists (id: $($found.id)). Use the ADO portal to update it."
    }

    # Build repository config based on source type
    if ($PSCmdlet.ParameterSetName -eq 'GitHub') {
        $repoFullName = $GitHubRepository -replace '^https://github\.com/', ''

        # Resolve connection name to GUID if needed
        if (-not [guid]::TryParse($ConnectionId, [ref][guid]::Empty)) {
            $endpoints = Invoke-AdoRestMethod -Uri "$apiBase/serviceendpoint/endpoints?endpointNames=$ConnectionId&api-version=7.1-preview.4"
            $endpoint = $endpoints | Select-Object -First 1
            Assert-NotNull $endpoint -ErrorText "Service connection '$ConnectionId' not found in organization '$Organization'"
            $ConnectionId = $endpoint.id
        }

        $repoConfig = @{
            fullName   = $repoFullName
            type       = 'gitHub'
            connection = @{
                id = $ConnectionId
            }
        }
    }
    else {
        Assert-NotNullOrWhitespace $RepositoryName -ErrorText 'RepositoryName is required. Set -RepositoryName, or run inside a checkout or a pipeline.'

        $repos = Invoke-AdoRestMethod -Uri "$apiBase/git/repositories?api-version=7.1"
        $repo = $repos | Where-Object { $_.name -eq $RepositoryName } | Select-Object -First 1
        Assert-NotNull $repo -ErrorText "Repository '$RepositoryName' not found in project '$Project'"

        $repoConfig = @{
            id   = $repo.id
            type = 'azureReposGit'
        }
    }

    # Create pipeline
    $body = @{
        name          = $Name
        folder        = $FolderPath
        configuration = @{
            type       = 'yaml'
            path       = "/$YamlPath"
            repository = $repoConfig
        }
    }

    $ret = Invoke-AdoRestMethod -Uri "$apiBase/pipelines?api-version=7.1-preview.1" -Method Post -Body $body
    Write-Message "Created pipeline '$Name' (id: $($ret.id)) -> $YamlPath"
    $ret
}
