function Push-Topic {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [string] $Message,

        [Catzc.Base.Git.GitFlowConfig] $Config = (Get-Config -Config git),

        [string] $RepositoryRoot = (Get-RepositoryRoot)
    )

    Assert-Command git

    if ([string]::IsNullOrWhiteSpace($Message)) {
        $Message = '...'
    }
    $quoted = '"' + ($Message -replace '"', '\"') + '"'
    # Every git call runs in the clone named, never in whatever folder the session stands in.
    $run = {
        param([string] $Arguments, [switch] $NoAssert)
        Invoke-Executable "git $Arguments" -WorkingDirectory $RepositoryRoot -PassThru -Silent -NoAssert:$NoAssert
    }
    $git = {
        param([string] $Arguments)
        "$((& $run $Arguments).Output)".Trim()
    }

    $branch = (Save-Topic -Message $Message -Config $Config -RepositoryRoot $RepositoryRoot).Branch
    & $run "fetch $($Config.remote)" | Out-Null

    $main = $null
    foreach ($candidate in $Config.main_branches) {
        if ((& $run "rev-parse --verify --quiet $($Config.remote)/$candidate" -NoAssert).ExitCode -eq 0) {
            $main = $candidate
            break
        }
    }
    Assert-NotNull $main -ErrorText "Push-Topic: the remote '$($Config.remote)' has none of the main branches $($Config.main_branches -join ', ')."
    $serverHead = & $git "rev-parse $($Config.remote)/$main"

    # Squash: one commit over the merge base, so the rebase replays one commit and each conflict is resolved once.
    $base = & $git "merge-base HEAD $serverHead"
    if ([int] (& $git "rev-list --count $base..HEAD") -eq 0) {
        Write-Message "Push-Topic: '$branch' holds no change beyond $($Config.remote)/$main; nothing to push."
        return
    }
    & $run "reset --soft $base" | Out-Null
    & $run "commit -m $quoted" | Out-Null

    # Rebase onto the commit the topic lands on.
    $rebase = & $run "rebase $serverHead" -NoAssert
    if ($rebase.ExitCode -ne 0) {
        $conflicts = @("$((& $run 'diff --name-only --diff-filter=U' -NoAssert).Output)" -split "`r?`n" | Where-Object { $_ })
        throw "Push-Topic stopped: rebasing '$branch' onto $serverHead conflicts in: $($conflicts -join ', '). Resolve them, then run 'git add <file>' and 'git rebase --continue' and Push-Topic again, or run 'git rebase --abort' to go back."
    }

    # Squash again, then hold the result to exactly one commit ahead and none behind.
    & $run "reset --soft $serverHead" | Out-Null
    & $run "commit -m $quoted" | Out-Null
    $ahead = [int] (& $git "rev-list --count $serverHead..HEAD")
    $behind = [int] (& $git "rev-list --count HEAD..$serverHead")
    Assert-True ($ahead -eq 1 -and
        $behind -eq 0) -ErrorText "Push-Topic: '$branch' is $ahead ahead and $behind behind $($Config.remote)/$main after the squash; expected 1 ahead and 0 behind."
    $commit = & $git 'rev-parse HEAD'

    if (Test-GitWorkspace -MainViaPr) {
        Assert-False ($Config.IsMain($branch)) -ErrorText "Push-Topic stopped: git_workspace is main-via-pr and '$branch' is a main branch, which is never forced."
        $target = $branch
        $push = & $run "push --force-with-lease $($Config.remote) ${branch}:$branch" -NoAssert
    }
    else {
        $target = $main
        $push = & $run "push $($Config.remote) HEAD:$main" -NoAssert
    }
    if ($push.ExitCode -ne 0) {
        throw "Push-Topic: the push to $($Config.remote)/$target was rejected (the server moved). Nothing was forced and the commit $commit is kept; run Push-Topic again."
    }
    Write-Message "Push-Topic: pushed $commit to $($Config.remote)/$target."
    [pscustomobject]@{ Branch = $branch; Target = $target; Commit = $commit }
}
