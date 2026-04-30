<#
.SYNOPSIS
    Creates an Azure DevOps pull request via the Git REST API.
.DESCRIPTION
    The "land via PR" half of an INPUT pipeline (see docs/adr/pipelines/pipeline-types.md): once an
    INPUT step has committed a config change to a branch, this opens a PR so the change goes through the
    normal PR gate before the CD pipeline deploys it.

    Resolves the repository by name, normalizes branch names to refs/heads/<branch>, and POSTs the PR.
    Authentication is the dual-auth pattern via Invoke-AdoRestMethod / Get-AdoAuthorizationHeader
    (pipeline SYSTEM_ACCESSTOKEN, PAT, or az login).
.PARAMETER Title
    PR title.
.PARAMETER SourceBranch
    The branch with the change (e.g. 'input/discovery-dev-1234'). Accepts a bare branch name or
    a full 'refs/heads/...' ref.
.PARAMETER TargetBranch
    The branch to merge into. Defaults to 'main'. Bare name or full ref.
.PARAMETER Description
    Optional PR description.
.PARAMETER RepositoryName
    Azure Repos Git repository name. Defaults to $env:BUILD_REPOSITORY_NAME or the leaf of
    $env:RepositoryRoot.
.PARAMETER Project
    Azure DevOps project. Defaults to ado.yml.
.PARAMETER Organization
    Azure DevOps organization URL. Defaults to ado.yml.
.EXAMPLE
    New-AdoPullRequest -Title 'input: discovery/dev' -SourceBranch 'input/discovery-dev-1234'
.EXAMPLE
    New-AdoPullRequest 'input: apex prod' 'input/apex-prod-99' -TargetBranch main -Description 'From ITSM #4821'
#>
function New-AdoPullRequest {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Title,

        [Parameter(Mandatory, Position = 1)]
        [string] $SourceBranch,

        [string] $TargetBranch = 'main',

        [string] $Description = '',

        [string] $RepositoryName,

        [string] $Project,

        [string] $Organization
    )

    Assert-NotNullOrWhitespace $Title
    Assert-NotNullOrWhitespace $SourceBranch

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

    $repos = Invoke-AdoRestMethod -Uri "$apiBase/git/repositories?api-version=7.1"
    $repo = $repos | Where-Object { $_.name -eq $RepositoryName } | Select-Object -First 1
    Assert-NotNull $repo -ErrorText "Repository '$RepositoryName' not found in project '$Project'"

    # ADO refs are fully qualified; accept either a bare branch name or a full ref.
    $sourceRef = if ($SourceBranch -like 'refs/*') {
        $SourceBranch
    }
    else {
        "refs/heads/$SourceBranch"
    }
    $targetRef = if ($TargetBranch -like 'refs/*') {
        $TargetBranch
    }
    else {
        "refs/heads/$TargetBranch"
    }

    $body = @{
        sourceRefName = $sourceRef
        targetRefName = $targetRef
        title         = $Title
        description   = $Description
    }

    $pr = Invoke-AdoRestMethod -Uri "$apiBase/git/repositories/$($repo.id)/pullrequests?api-version=7.1" -Method Post -Body $body
    # Postcondition: confirm the PR actually came back created. A non-throwing response with no id means the
    # create did not take effect — fail fast here rather than return a phantom result downstream.
    Assert-NotNull $pr.pullRequestId -ErrorText "Pull request creation returned no pullRequestId for '$Title' ($sourceRef -> $targetRef) — the PR was not created."
    Write-Message "Created PR #$($pr.pullRequestId): $Title ($sourceRef -> $targetRef)"
    $pr
}
