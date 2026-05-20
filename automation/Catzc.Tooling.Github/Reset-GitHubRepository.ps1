<#
.SYNOPSIS
    Hard-purges a GitHub repository — deletes it, recreates it (optionally under a
    new name), pushes the local history, and verifies the result is token-free.
.DESCRIPTION
    A normal force-push leaves the old commits unreachable but still stored, so a
    fetch of a known old SHA keeps resolving until GitHub garbage-collects (days,
    or a support ticket). Deleting the repository destroys its object store, so
    the old commit hashes stop resolving the instant the repo is gone. This is
    the only way to erase a secret together with its remote objects.

    Safe by default: it runs the full preflight and, unless armed, changes
    nothing and returns a plan. Arm the destructive path by passing -ConfirmRepo
    equal to -Repo (and not -DryRun). On any failure after deletion, it throws
    with the exact recovery commands — the local clone and the backup bundle are
    always intact.
.PARAMETER Repo
    The GitHub repository to delete, as owner/name.
.PARAMETER NewName
    The owner/name to recreate under. Defaults to -Repo (recreate in place). Pass
    a different value to delete-and-rename in one step.
.PARAMETER Branch
    The local branch to push as the new default. Defaults to main.
.PARAMETER Token
    The token that must be absent from the pushed history. When set, the new
    remote is mirror-cloned and re-scanned after the push; a hit aborts with a
    "do not make public" warning.
.PARAMETER BackupBundle
    A verified `git bundle create --all` backup. The purge refuses to run without
    one (checked by Assert-GitHubPurgeReady).
.PARAMETER RepositoryPath
    The local clone to push from. Defaults to the repository root.
.PARAMETER Visibility
    Visibility of the recreated repo: 'private' (default) or 'public'.
.PARAMETER AllowForks
    Proceed even if the repo has forks (they defeat the purge). Off by default.
.PARAMETER ConfirmRepo
    Must equal -Repo to arm the destructive path. Any other value (or absence)
    keeps the run a dry run.
.PARAMETER DryRun
    Force a dry run even when -ConfirmRepo matches.
.EXAMPLE
    Reset-GitHubRepository -Repo 'me/project' -BackupBundle $bundle
    # Dry run: preflight only, nothing changes.
.EXAMPLE
    Reset-GitHubRepository -Repo 'me/old' -NewName 'me/new' -Token 'old-name' -BackupBundle $bundle -ConfirmRepo 'me/old'
    # Armed: delete me/old, create me/new, push, verify token-free.
#>
function Reset-GitHubRepository {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Repo,

        [string] $NewName,

        [string] $Branch = 'main',

        [string] $Token,

        [Parameter(Mandatory)]
        [string] $BackupBundle,

        [string] $RepositoryPath = (Get-RepositoryRoot),

        [ValidateSet('private', 'public')]
        [string] $Visibility = 'private',

        [switch] $AllowForks,

        [string] $ConfirmRepo,

        [switch] $DryRun
    )

    if (-not $NewName) {
        $NewName = $Repo
    }

    # Preflight — throws on any gap. Never mutates.
    Assert-GitHubPurgeReady -Repo $Repo -BackupBundle $BackupBundle -RepositoryPath $RepositoryPath -AllowForks:$AllowForks

    # When renaming, the target name must be free.
    if ($NewName -ne $Repo) {
        $taken = Invoke-Executable "gh repo view $NewName --json name" -PassThru -NoAssert -Silent
        if ($taken.ExitCode -eq 0) {
            throw "Target repo '$NewName' already exists. Choose a free name or delete it first."
        }
    }

    $armed = (-not $DryRun) -and ($ConfirmRepo -eq $Repo)
    if (-not $armed) {
        Write-Message "DRY RUN — preflight passed. Would delete '$Repo', create '$NewName' ($Visibility), push '$Branch'$(if ($Token) { ', verify token-free' }). Nothing changed. Arm with -ConfirmRepo '$Repo'."
        return [pscustomobject]@{
            DryRun  = $true
            Repo    = $Repo
            NewName = $NewName
            Branch  = $Branch
        }
    }

    Write-Message "ARMED — deleting '$Repo', creating '$NewName', pushing '$Branch'."

    # --- Delete: destroys all server-side objects, including the old commit hashes ---
    $delete = Invoke-Executable "gh repo delete $Repo --yes" -PassThru -NoAssert
    if ($delete.ExitCode -ne 0) {
        throw "Delete failed (nothing lost — local clone and backup intact): $($delete.Errors)"
    }

    # --- Recreate (retry: the freed name can take a moment to become available) ---
    $created = $false
    foreach ($attempt in 1..5) {
        $create = Invoke-Executable "gh repo create $NewName --$Visibility" -PassThru -NoAssert
        if ($create.ExitCode -eq 0) {
            $created = $true; break
        }
        Start-Sleep -Seconds 3
    }
    if (-not $created) {
        throw "Create failed. Recover: gh repo create $NewName --$Visibility ; git remote set-url origin https://github.com/$NewName.git ; git push -u origin $Branch"
    }

    # --- Point origin at the new repo and push (retry for propagation) ---
    $newUrl = "https://github.com/$NewName.git"
    Invoke-Executable "git remote set-url origin $newUrl" -WorkingDirectory $RepositoryPath -Silent | Out-Null
    $pushed = $false
    foreach ($attempt in 1..5) {
        $push = Invoke-Executable "git push -u origin $Branch" -WorkingDirectory $RepositoryPath -PassThru -NoAssert
        if ($push.ExitCode -eq 0) {
            $pushed = $true; break
        }
        Start-Sleep -Seconds 3
    }
    if (-not $pushed) {
        throw "Push failed. Recover: git push -u origin $Branch (local clone and backup intact)."
    }

    # --- Post-verify: mirror-clone the new remote and prove the token is gone ---
    if ($Token) {
        $mirror = Join-Path ([System.IO.Path]::GetTempPath()) ('catzc-verify-' + [guid]::NewGuid().ToString('N').Substring(0, 12))
        $clone = Invoke-Executable "git clone --mirror $newUrl `"$mirror`"" -PassThru -NoAssert -Silent
        if ($clone.ExitCode -ne 0) {
            throw "Post-verify clone failed (the push may be fine — check GitHub): $($clone.Errors)"
        }
        try {
            $scan = Test-GitHistoryClean -Token $Token -Ref '--all' -RepositoryPath $mirror
        }
        finally {
            Remove-Item -Recurse -Force $mirror -ErrorAction SilentlyContinue
        }
        if (-not $scan.Clean) {
            throw "The new repo '$NewName' still contains '$Token' — DO NOT make it public. Investigate before continuing."
        }
        Write-Message "Verified '$NewName' is free of '$Token' across all refs."
    }

    Write-Message "Hard purge complete: '$Repo' is gone (old hashes 404); '$NewName' carries the pushed history."
    [pscustomobject]@{
        DryRun  = $false
        Repo    = $Repo
        NewName = $NewName
        Branch  = $Branch
        Url     = $newUrl
    }
}
