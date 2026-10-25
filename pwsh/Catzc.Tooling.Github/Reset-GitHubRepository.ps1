<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-tooling-github/Reset-GitHubRepository.ps1.md"
  warning: "Generated Header"
---
#>

function Reset-GitHubRepository {
    [CmdletBinding()]
    [Catzc.Base.Timeouts.TimeLimit(600, Pipeline = 3600)]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Repo,

        [string] $NewName = $Repo,

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
    $limit = Get-TimeoutSeconds -Command 'Reset-GitHubRepository'
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
        throw "Push failed. Recover: git push -u origin $Branch (local clone and backup intact)."
    }

    # --- Post-verify: the remote holds only the pushed commit, and that commit's history is token-free ---
    if ($Token) {
        $null = Assert-RemoteMatchesBranch -Url $newUrl -Branch $Branch -RepositoryPath $RepositoryPath -TimeoutSeconds $limit
        $scan = Test-GitHistoryClean -Token $Token -Ref $Branch -RepositoryPath $RepositoryPath
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
