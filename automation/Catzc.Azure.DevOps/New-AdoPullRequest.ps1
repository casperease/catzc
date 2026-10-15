<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.DevOps/New-AdoPullRequest.ps1
    kind: function
    module: Catzc.Azure.DevOps
    visibility: public
    adrs:
      - ADR-FLOW-CD-TYPE
---
#>

<#
.SYNOPSIS
    Creates an Azure DevOps pull request via the Git REST API.
.DESCRIPTION
    The PR gate runs before the CD pipeline deploys, so a config change from an INPUT step never lands unreviewed.
    [comment:1](/docs/references/automation/catzc-azure-devops/New-AdoPullRequest.ps1.md#comment1)
.PARAMETER Title
    PR title.
.PARAMETER SourceBranch
    A bare name gets refs/heads/ prepended; a name that starts with refs/ is already taken as a full ref.
    [comment:2](/docs/references/automation/catzc-azure-devops/New-AdoPullRequest.ps1.md#comment2)
.PARAMETER TargetBranch
    The branch to merge into. Defaults to 'main'. Bare name or full ref.
.PARAMETER Description
    Optional PR description.
.PARAMETER RepositoryName
    Azure Repos Git repository name. Defaults to this checkout's repository (Get-AdoRepositoryName).
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

        [string] $RepositoryName = (Get-AdoRepositoryName),

        [string] $Project = (Get-Config -Config ado)['project'],

        [string] $Organization = (Get-Config -Config ado)['organization']
    )

    Assert-NotNullOrWhitespace $Title
    Assert-NotNullOrWhitespace $SourceBranch

    Assert-NotNullOrWhitespace $Project -ErrorText 'Project is required. Set -Project or configure ado.yml.'
    Assert-NotNullOrWhitespace $Organization -ErrorText 'Organization is required. Set -Organization or configure ado.yml.'
    $Organization = $Organization.TrimEnd('/')

    Assert-NotNullOrWhitespace $RepositoryName -ErrorText 'RepositoryName is required. Set -RepositoryName, or run inside a checkout or a pipeline.'

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
    # A response without an id means the create did not take effect, so fail here, not downstream.
    # [comment:3](/docs/references/automation/catzc-azure-devops/New-AdoPullRequest.ps1.md#comment3)
    Assert-NotNull $pr.pullRequestId -ErrorText "Pull request creation returned no pullRequestId for '$Title' ($sourceRef -> $targetRef) — the PR was not created."
    Write-Message "Created PR #$($pr.pullRequestId): $Title ($sourceRef -> $targetRef)"
    $pr
}
