<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Tooling.Github/Assert-GitHubPurgeReady.ps1
    name: assert-git-hub-purge-ready
    filetype: ps1
    role: function
    subkind: assert
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Tooling.Github
    moduletype: pwsh-folder
    catzc_bundle: full
    visibility: public
  edges:
    test: pwsh/Catzc.Tooling.Github/tests/Assert-GitHubPurgeReady.Tests.ps1
    docs: "[Assert-GitHubPurgeReady.ps1.md](docs/references/pwsh/catzc-tooling-github/Assert-GitHubPurgeReady.ps1.md)"
---
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

    # `gh api -i` prepends the response headers; the scopes the token holds are listed there.
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
    # Select-Object -First 1 is $null when there is no origin (indexing an empty array throws under strict)
    $originUrl = $originProbe.Output -split '\r?\n' | Where-Object { $_ } | Select-Object -First 1
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
