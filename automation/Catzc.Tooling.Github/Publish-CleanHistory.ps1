<#
.SYNOPSIS
    Publishes a verified local history to a brand-new, empty GitHub repository,
    then independently re-scans the remote to prove what landed is token-free.
.DESCRIPTION
    Use this when there is no existing repository to purge — you already hold a
    clean local tree (for example, freshly rebuilt by New-SyntheticHistory) and
    want to push it to a new repo. It refuses to target a name that already
    exists (that is Reset-GitHubRepository's job), and after pushing it
    mirror-clones the new remote and re-scans it, so the check runs against what
    the server actually stored rather than the local tree.

    Safe by default: unless armed with -ConfirmRepo equal to -NewRepo (and not
    -DryRun), it validates and returns a plan without creating or pushing
    anything.
.PARAMETER NewRepo
    The new GitHub repository to create and push to, as owner/name. Must not
    already exist.
.PARAMETER Branch
    The local branch to push as the default. Defaults to main.
.PARAMETER Token
    The token that must be absent from the pushed history. When set, the new
    remote is mirror-cloned and re-scanned; a hit aborts with a warning.
.PARAMETER RepositoryPath
    The local clone to push from. Defaults to the repository root.
.PARAMETER Visibility
    Visibility of the new repo: 'private' (default) or 'public'.
.PARAMETER ConfirmRepo
    Must equal -NewRepo to arm. Any other value (or absence) keeps the run a dry
    run.
.PARAMETER DryRun
    Force a dry run even when -ConfirmRepo matches.
.EXAMPLE
    Publish-CleanHistory -NewRepo 'me/fresh' -Token 'old-name' -ConfirmRepo 'me/fresh'
#>
function Publish-CleanHistory {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $NewRepo,

        [string] $Branch = 'main',

        [string] $Token,

        [string] $RepositoryPath = (Get-RepositoryRoot),

        [ValidateSet('private', 'public')]
        [string] $Visibility = 'private',

        [string] $ConfirmRepo,

        [switch] $DryRun
    )

    Assert-Command gh -ErrorText "GitHub CLI ('gh') is not installed or not on PATH."
    Assert-Command git

    # The target must be free — Publish never overwrites an existing repo.
    $taken = Invoke-Executable "gh repo view $NewRepo --json name" -PassThru -NoAssert -Silent
    if ($taken.ExitCode -eq 0) {
        throw "Repo '$NewRepo' already exists. Publish only targets a new name; use Reset-GitHubRepository to replace an existing repo."
    }

    # The local history must already be clean before we publish it.
    if ($Token) {
        $local = Test-GitHistoryClean -Token $Token -Ref $Branch -RepositoryPath $RepositoryPath
        if (-not $local.Clean) {
            throw "Local branch '$Branch' still contains '$Token' — clean it before publishing."
        }
    }

    $armed = (-not $DryRun) -and ($ConfirmRepo -eq $NewRepo)
    if (-not $armed) {
        Write-Message "DRY RUN — checks passed. Would create '$NewRepo' ($Visibility) and push '$Branch'. Nothing changed. Arm with -ConfirmRepo '$NewRepo'."
        return [pscustomobject]@{ DryRun = $true; NewRepo = $NewRepo; Branch = $Branch }
    }

    Write-Message "ARMED — creating '$NewRepo' and pushing '$Branch'."

    $create = Invoke-Executable "gh repo create $NewRepo --$Visibility" -PassThru -NoAssert
    if ($create.ExitCode -ne 0) {
        throw "Create failed: $($create.Errors)"
    }

    $newUrl = "https://github.com/$NewRepo.git"
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
        throw "Push failed. Recover: git push -u origin $Branch"
    }

    if ($Token) {
        $mirror = Join-Path ([System.IO.Path]::GetTempPath()) ('catzc-publish-' + [guid]::NewGuid().ToString('N').Substring(0, 12))
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
            throw "The new repo '$NewRepo' contains '$Token' — DO NOT make it public. Investigate before continuing."
        }
        Write-Message "Verified '$NewRepo' is free of '$Token' across all refs."
    }

    Write-Message "Published clean history to '$NewRepo'."
    [pscustomobject]@{ DryRun = $false; NewRepo = $NewRepo; Branch = $Branch; Url = $newUrl }
}
