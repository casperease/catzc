<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Github/Publish-CleanHistory.ps1
    kind: automation-function
    module: Catzc.Tooling.Github
    visibility: public
  config:
    synopsis: |-
      Publishes a verified local history to a brand-new, empty GitHub repository,
      then independently re-scans the remote to prove what landed is token-free.
    description: |-
      Use this when there is no existing repository to purge — you already hold a
      clean local tree (for example, freshly rebuilt by New-SyntheticHistory) and
      want to push it to a new repo. It refuses to target a name that already
      exists (that is Reset-GitHubRepository's job), and after pushing it reads
      the new remote's refs and proves every one points at the scanned local
      commit, so the check covers what the server actually stored without
      downloading it.

      Pushing a whole history takes longer than an ordinary call, so the function
      declares its own time limit ([TimeLimit]; tune it under `commands` in
      timeouts.yml) and bounds the push and the remote read with it.

      Safe by default: unless armed with -ConfirmRepo equal to -NewRepo (and not
      -DryRun), it validates and returns a plan without creating or pushing
      anything.
    parameters:
      NewRepo: |-
        The new GitHub repository to create and push to, as owner/name. Must not
        already exist.
      Branch: The local branch to push as the default. Defaults to main.
      Token: |-
        The token that must be absent from the pushed history. When set, the local
        branch is scanned before the push, and after it the new remote must hold
        only that branch's commit; anything else aborts with a warning.
      RepositoryPath: The local clone to push from. Defaults to the repository root.
      Visibility: 'Visibility of the new repo: ''private'' (default) or ''public''.'
      ConfirmRepo: |-
        Must equal -NewRepo to arm. Any other value (or absence) keeps the run a dry
        run.
      DryRun: Force a dry run even when -ConfirmRepo matches.
    examples:
      - Publish-CleanHistory -NewRepo 'me/fresh' -Token 'old-name' -ConfirmRepo 'me/fresh'
---
#>

function Publish-CleanHistory {
    [CmdletBinding()]
    [Catzc.Base.Timeouts.TimeLimit(600, Pipeline = 3600)]
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
    $limit = Get-TimeoutSeconds -Command 'Publish-CleanHistory'
    Invoke-Executable "git remote set-url origin $newUrl" -WorkingDirectory $RepositoryPath -Silent | Out-Null
    $pushed = $false
    foreach ($attempt in 1..5) {
        $push = Invoke-Executable "git push -u origin $Branch" -WorkingDirectory $RepositoryPath -PassThru -NoAssert -TimeoutSeconds $limit
        if ($push.ExitCode -eq 0) {
            $pushed = $true; break
        }
        Start-Sleep -Seconds 3
    }
    if (-not $pushed) {
        throw "Push failed. Recover: git push -u origin $Branch"
    }

    if ($Token) {
        # The local branch was scanned clean above; the remote holding only its commit proves the same of the server.
        $null = Assert-RemoteMatchesBranch -Url $newUrl -Branch $Branch -RepositoryPath $RepositoryPath -TimeoutSeconds $limit
        Write-Message "Verified '$NewRepo' is free of '$Token' across all refs."
    }

    Write-Message "Published clean history to '$NewRepo'."
    [pscustomobject]@{ DryRun = $false; NewRepo = $NewRepo; Branch = $Branch; Url = $newUrl }
}
