<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Github/Publish-CleanHistory.ps1
    kind: function
    module: Catzc.Tooling.Github
    visibility: public
---
#>

<#
.SYNOPSIS
    Publishes a verified local history to a brand-new, empty GitHub repository,
    then independently re-scans the remote to prove what landed is token-free.
.DESCRIPTION
    Unless armed with -ConfirmRepo equal to -NewRepo, it only returns a plan and creates or pushes nothing.
    [comment:1](/docs/references/automation/catzc-tooling-github/Publish-CleanHistory.ps1.md#comment1)
.PARAMETER NewRepo
    A name that already exists is refused: replacing an existing repo is Reset-GitHubRepository's job.
    [comment:2](/docs/references/automation/catzc-tooling-github/Publish-CleanHistory.ps1.md#comment2)
.PARAMETER Branch
    The local branch to push as the default. Defaults to main.
.PARAMETER Token
    Scanned in the local branch before the push and in the remote after it; any extra commit aborts the run.
    [comment:3](/docs/references/automation/catzc-tooling-github/Publish-CleanHistory.ps1.md#comment3)
.PARAMETER RepositoryPath
    The local clone to push from. Defaults to the repository root.
.PARAMETER Visibility
    Visibility of the new repo: 'private' (default) or 'public'.
.PARAMETER ConfirmRepo
    Any other value, or none, leaves the run a dry run, so a typo can never create a repo.
    [comment:4](/docs/references/automation/catzc-tooling-github/Publish-CleanHistory.ps1.md#comment4)
.PARAMETER DryRun
    Force a dry run even when -ConfirmRepo matches.
.EXAMPLE
    Publish-CleanHistory -NewRepo 'me/fresh' -Token 'old-name' -ConfirmRepo 'me/fresh'
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
