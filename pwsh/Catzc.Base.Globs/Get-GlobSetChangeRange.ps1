<#
---
catzc:
  immutable:
    with_body_sha: d116c7e2e022
  edges:
    test: pwsh/Catzc.Base.Globs/tests/Get-GlobSetChangeRange.Tests.ps1
    docs: "[Get-GlobSetChangeRange.ps1.md](docs/references/pwsh/catzc-base-globs/Get-GlobSetChangeRange.ps1.md)"
    cites:
      - ADR-FLOW-CD-DETECT
      - ADR-FLOW-CD-GLOBS-CHANGECOMPUTEDFROMGIT
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
