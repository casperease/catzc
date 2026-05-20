<#
.SYNOPSIS
    Asserts every precondition for a hard-purge of a GitHub repository is met,
    throwing on the first gap. Nothing here mutates anything.
.DESCRIPTION
    A hard purge (delete the repo, recreate it, push a clean history) is
    irreversible and only actually erases the old objects when a set of
    conditions all hold. This checks them up front so the destructive step
    never runs against a repo it cannot safely purge:

      * gh is installed and authenticated;
      * the token carries the delete_repo scope (needed to delete a repo);
      * you own the repo and it is not itself a fork;
      * the repo has no forks — a fork keeps the old objects alive elsewhere,
        so deleting this repo would not purge them;
      * the local origin points at the repo you are about to delete;
      * a backup bundle exists and passes git bundle verify.

    Throws a specific, actionable error for whichever check fails first.
.PARAMETER Repo
    The GitHub repository as owner/name (e.g. 'contoso/hello-world').
.PARAMETER BackupBundle
    Path to a `git bundle create --all` backup of the current history. The
    purge refuses to proceed without one that verifies.
.PARAMETER RepositoryPath
    The local clone whose origin is checked. Defaults to the repository root.
.PARAMETER AllowForks
    Proceed even if the repo has forks. Off by default because a fork defeats
    the purge (the old objects survive in the fork).
.EXAMPLE
    Assert-GitHubPurgeReady -Repo 'contoso/hello-world' -BackupBundle $bundle
#>
function Assert-GitHubPurgeReady {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Repo,

        [Parameter(Mandatory)]
        [string] $BackupBundle,

        [string] $RepositoryPath = (Get-RepositoryRoot),

        [switch] $AllowForks
    )

    Assert-Command gh -ErrorText "GitHub CLI ('gh') is not installed or not on PATH. Install it and run 'gh auth login'."
    Assert-Command git

    # --- 1. Authenticated, with the delete_repo scope ---
    $auth = Invoke-Executable 'gh auth status' -PassThru -NoAssert -Silent
    if ($auth.ExitCode -ne 0) {
        throw "gh is not authenticated. Run 'gh auth login'."
    }

    $identity = Invoke-Executable 'gh api user' -PassThru -NoAssert -Silent
    if ($identity.ExitCode -ne 0) {
        throw "Cannot read the authenticated GitHub user: $($identity.Errors)"
    }
    $me = ($identity.Output | ConvertFrom-Json).login
    Assert-NotNullOrWhitespace $me -ErrorText 'Could not determine the authenticated GitHub user.'

    # `gh api -i` prepends the response headers; the granted scopes are listed there.
    $scopeProbe = Invoke-Executable 'gh api -i user' -PassThru -NoAssert -Silent
    if ($scopeProbe.Output -notmatch 'delete_repo') {
        throw 'The gh token lacks the delete_repo scope. Grant it with: gh auth refresh -h github.com -s delete_repo'
    }

    # --- 2. Own the repo, and it has no forks ---
    $view = Invoke-Executable "gh repo view $Repo --json owner,isFork,forkCount,visibility" -PassThru -NoAssert -Silent
    if ($view.ExitCode -ne 0) {
        throw "Cannot view '$Repo' — it does not exist or you cannot access it: $($view.Errors)"
    }
    $info = $view.Output | ConvertFrom-Json
    if ($info.owner.login -ne $me) {
        throw "You ($me) are not the owner of '$Repo' (owner is $($info.owner.login))."
    }
    if ($info.isFork) {
        throw "'$Repo' is itself a fork — purging it would not erase the upstream objects."
    }
    if (-not $AllowForks -and $info.forkCount -gt 0) {
        throw "'$Repo' has $($info.forkCount) fork(s). A fork keeps the old objects alive, so deleting the repo would not purge them. Resolve the forks first, or pass -AllowForks to override."
    }

    # --- 3. Local origin points at the repo we are about to delete ---
    $expectedOrigin = "https://github.com/$Repo.git"
    $originProbe = Invoke-Executable 'git config --get remote.origin.url' -WorkingDirectory $RepositoryPath -PassThru -NoAssert -Silent
    $originUrl = @($originProbe.Output -split '\r?\n' | Where-Object { $_ })[0]
    if ($originUrl -ne $expectedOrigin) {
        throw "Local origin is '$originUrl', expected '$expectedOrigin'."
    }

    # --- 4. A verified backup exists ---
    if (-not (Test-Path -LiteralPath $BackupBundle)) {
        throw "Backup bundle not found: $BackupBundle"
    }
    $verify = Invoke-Executable "git bundle verify `"$BackupBundle`"" -WorkingDirectory $RepositoryPath -PassThru -NoAssert -Silent
    if ($verify.ExitCode -ne 0) {
        throw "Backup bundle failed verification (refusing to proceed without a valid backup): $BackupBundle"
    }

    Write-Message "GitHub purge preconditions met for '$Repo' (owner=$me, forks=$($info.forkCount), backup verified)."
}
