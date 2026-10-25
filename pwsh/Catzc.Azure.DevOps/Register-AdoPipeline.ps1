<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-azure-dev-ops/Register-AdoPipeline.ps1.md"
  header: "generated"
---
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
