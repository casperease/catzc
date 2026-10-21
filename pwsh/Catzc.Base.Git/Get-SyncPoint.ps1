<#
---
catzc:
  immutable:
    with_body_sha: "802c85fdf7f9"
  edges:
    test: pwsh/Catzc.Base.Git/tests/Get-SyncPoint.Tests.ps1
    docs: "[Get-SyncPoint.ps1.md](docs/references/pwsh/catzc-base-git/Get-SyncPoint.ps1.md)"
    cites:
      - ADR-FLOW-GIT-USERRUNSGIT
      - ADR-FLOW-GIT-SYNCPOINT
      - ADR-FLOW-GIT-FALLBACKISANNOUNCED
---
#>

function Get-SyncPoint {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Catzc.Base.Git.GitFlowConfig] $Config = (Get-Config -Config git),

        [string] $RepositoryRoot = (Get-RepositoryRoot)
    )

    Assert-Command git

    $listing = Invoke-Executable "git ls-remote $($Config.remote)" -WorkingDirectory $RepositoryRoot -PassThru -Silent
    $refs = @{}
    foreach ($line in @("$($listing.Output)" -split "`r?`n")) {
        if ($line -match '^(?<sha>[0-9a-f]{40})\s+(?<ref>\S+)$') {
            $refs[$Matches['ref']] = $Matches['sha']
        }
    }

    $branch = $null
    foreach ($main in $Config.main_branches) {
        if ($refs.ContainsKey("refs/heads/$main")) {
            $branch = $main
            break
        }
    }
    Assert-NotNull $branch -ErrorText "Get-SyncPoint: the remote '$($Config.remote)' has none of the main branches $($Config.main_branches -join ', ')."

    if ($Config.bvt_mark_kind -ceq [Catzc.Base.Git.GitFlowConfig]::RefMark) {
        # An annotated tag lists its commit on the peeled line; a branch or a lightweight tag on the ref itself.
        $marked = if ($refs.ContainsKey("$($Config.bvt_mark_ref)^{}")) {
            $refs["$($Config.bvt_mark_ref)^{}"]
        }
        else {
            $refs[$Config.bvt_mark_ref]
        }
        if ($marked) {
            return [pscustomobject]@{ Commit = $marked; Source = 'bvt'; Branch = $branch }
        }
    }

    $head = $refs["refs/heads/$branch"]
    $missing = if ($Config.bvt_mark_kind -ceq [Catzc.Base.Git.GitFlowConfig]::RefMark) {
        "the BVT mark '$($Config.bvt_mark_ref)' is not on the server"
    }
    else {
        'the server marks no BVT-verified head (bvt_mark: none)'
    }
    Write-Warning "Get-SyncPoint: syncing from the current server HEAD $head of '$branch', because $missing."
    [pscustomobject]@{ Commit = $head; Source = 'fallback'; Branch = $branch }
}
