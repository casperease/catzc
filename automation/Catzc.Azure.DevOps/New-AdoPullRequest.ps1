<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.DevOps/New-AdoPullRequest.ps1
    kind: writer-function
    language: powershell
    track: automation
    module: Catzc.Azure.DevOps
    visibility: public
    relatives:
      page: docs/references/automation/catzc-azure-devops/New-AdoPullRequest.ps1.md
      test: automation/Catzc.Azure.DevOps/tests/New-AdoPullRequest.Tests.ps1
    adrs:
      - ADR-FLOW-CD-TYPE
  config:
    synopsis: Creates an Azure DevOps pull request via the Git REST API.
    description: |-
      The "land via PR" half of an INPUT pipeline (see [ADR-FLOW-CD-TYPE](/docs/adr/flow/pipeline-types.md)): once an
      INPUT step has committed a config change to a branch, this opens a PR so the change goes through the
      normal PR gate before the CD pipeline deploys it.

      Resolves the repository by name, normalizes branch names to refs/heads/<branch>, and POSTs the PR.
      Authentication is the dual-auth pattern via Invoke-AdoRestMethod / Get-AdoAuthorizationHeader
      (pipeline SYSTEM_ACCESSTOKEN, PAT, or az login).
    parameters:
      Title: PR title.
      SourceBranch: |-
        The branch with the change (e.g. 'input/discovery-dev-1234'). Accepts a bare branch name or
        a full 'refs/heads/...' ref.
      TargetBranch: The branch to merge into. Defaults to 'main'. Bare name or full ref.
      Description: Optional PR description.
      RepositoryName: Azure Repos Git repository name. Defaults to this checkout's repository (Get-AdoRepositoryName).
      Project: Azure DevOps project. Defaults to ado.yml.
      Organization: Azure DevOps organization URL. Defaults to ado.yml.
    examples:
      - 'New-AdoPullRequest -Title ''input: discovery/dev'' -SourceBranch ''input/discovery-dev-1234'''
      - 'New-AdoPullRequest ''input: apex prod'' ''input/apex-prod-99'' -TargetBranch main -Description ''From ITSM #4821'''
---
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
    Assert-NotNull $pr.pullRequestId -ErrorText "Pull request creation returned no pullRequestId for '$Title' ($sourceRef -> $targetRef) — the PR was not created."
    Write-Message "Created PR #$($pr.pullRequestId): $Title ($sourceRef -> $targetRef)"
    $pr
}
