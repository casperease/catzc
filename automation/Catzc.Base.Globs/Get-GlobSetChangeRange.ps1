<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Globs/Get-GlobSetChangeRange.ps1
    kind: public-function
    module: Catzc.Base.Globs
    visibility: public
    adrs:
      - ADR-FLOW-CD-DETECT
      - ADR-REPO-PROTGLOB#5
---
#>

<#
.SYNOPSIS
    The git diff range the current context measures a globset change against — the reference-commit resolver.
.DESCRIPTION
    $null means fail open: an unknown PR target must read as affected, so a wrong skip never happens.
.OUTPUTS
    [string] The git range (e.g. 'HEAD^1..HEAD'), or $null to signal fail-open (proceed).
.EXAMPLE
    Get-GlobSetChangeRange
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
