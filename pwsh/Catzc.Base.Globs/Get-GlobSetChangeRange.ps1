<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-globs/Get-GlobSetChangeRange.ps1.md"
  header: "generated"
---
#>

function Get-GlobSetChangeRange {
    [CmdletBinding()]
    [OutputType([string])]
    param()

    if (-not (Test-IsRunningInPipeline)) {
        return 'HEAD'
    }

    $isPullRequest = $env:SYSTEM_PULLREQUEST_PULLREQUESTID -or ($env:GITHUB_EVENT_NAME -eq 'pull_request')
    if (-not $isPullRequest) {
        # A post-commit push to main — squash-merge guarantees a single parent, so first-parent is the push.
        return 'HEAD^1..HEAD'
    }

    $target = if ($env:SYSTEM_PULLREQUEST_TARGETBRANCH) {
        $env:SYSTEM_PULLREQUEST_TARGETBRANCH -replace '^refs/heads/', ''
    }
    else {
        $env:GITHUB_BASE_REF
    }
    if (-not $target) {
        return $null
    }

    "origin/$target...HEAD"
}
