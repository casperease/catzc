<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-azure-dev-ops/New-AdoPullRequest.ps1.md"
  header: "generated"
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
    # A non-throwing response with no id means the create did not take effect, so fail here and return no phantom result.
    Assert-NotNull $pr.pullRequestId -ErrorText "Pull request creation returned no pullRequestId for '$Title' ($sourceRef -> $targetRef) — the PR was not created."
    Write-Message "Created PR #$($pr.pullRequestId): $Title ($sourceRef -> $targetRef)"
    $pr
}
