<#
.SYNOPSIS
    The git diff range the current context measures a globset change against — the reference-commit resolver.
.DESCRIPTION
    Answers "before versus now: which two commits?" for the in-pipeline "is this unit affected?" gate, per
    execution context (ADR-FLOW-CD-DETECT), so the same globset check is correct everywhere it runs:

    - Post-commit on main (the BVT / the CD engine on the merged commit): 'HEAD^1..HEAD'. main advances ONLY
      by squash-merge, so the merged commit has a single parent (the prior main tip) and its first-parent
      diff is exactly what the push added. This is the squash-proof comparison — two real commits that exist
      server-side after the merge, never a hash frozen on the branch.
    - PR pre-commit build-validation (an ADO PR build, a GitHub pull_request): 'origin/<target>...HEAD' —
      the three-dot merge-base range, the net change the PR introduces since it diverged from its target.
      The target comes from SYSTEM_PULLREQUEST_TARGETBRANCH (ADO, 'refs/heads/' stripped) or GITHUB_BASE_REF
      (GitHub).
    - Local / solo dev (not in a pipeline): 'HEAD' — the working tree against the last commit.

    Returns $null when a pipeline PR context names no resolvable target — the fail-open signal
    (ADR-REPO-PROTGLOB:5): a caller treats an unknown range as "affected" and proceeds, never wrongly skipping.
    The range assumes the base commit is present in the clone; a pipeline must checkout with fetchDepth: 0,
    because a shallow (depth 1) clone cannot reach HEAD^1 or the merge-base. The post-commit range needs only
    depth >= 2 and no named-ref fetch, so the deploy-skip that matters most is the most robust; a PR range
    that cannot resolve its target simply fails open (the fast CI engine runs anyway, never wrongly skipped).
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
