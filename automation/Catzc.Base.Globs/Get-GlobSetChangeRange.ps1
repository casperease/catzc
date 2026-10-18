<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Globs/Get-GlobSetChangeRange.ps1
    name: get-glob-set-change-range
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Globs
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Base.Globs/tests/Get-GlobSetChangeRange.Tests.ps1
    cites:
      - ADR-FLOW-CD-DETECT
      - ADR-REPO-PROTGLOB#5
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
