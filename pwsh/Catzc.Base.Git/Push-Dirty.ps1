function Push-Dirty {
    [CmdletBinding()]
    param(
        [string] $Message,

        [switch] $DryRun
    )

    Assert-Command git

    # The one place the empty-message default lives: an empty editor field or no -Message commits as '...'.
    if ([string]::IsNullOrWhiteSpace($Message)) {
        $Message = '...'
    }

    $branch = (Invoke-Executable 'git rev-parse --abbrev-ref HEAD' -PassThru -Silent).Output.Trim()
    if ($branch -eq 'HEAD') {
        throw 'Push-Dirty needs a named branch; HEAD is detached.'
    }
    if ((Test-GitWorkspace -MainViaPr) -and $branch -in 'main', 'master') {
        throw "Push-Dirty stopped: git_workspace is main-via-pr and '$branch' is checked out. Work on a branch and open a pull request."
    }

    $status = (Invoke-Executable 'git status --porcelain' -PassThru -Silent).Output
    $hasChanges = [bool] $status.Trim()

    if ($DryRun) {
        return [pscustomobject]@{
            Branch     = $branch
            HasChanges = $hasChanges
            Message    = $Message
        }
    }

    if ($hasChanges) {
        Invoke-Executable 'git add -A' | Out-Null
        $quotedMessage = '"' + ($Message -replace '"', '\"') + '"'
        Invoke-Executable "git commit -m $quotedMessage" | Out-Null
    }

    $push = Invoke-Executable "git push origin $branch" -PassThru -NoAssert
    if ($push.ExitCode -ne 0) {
        throw "Push rejected for '$branch' (the server's tip moved). Nothing was forced and the commit is kept locally; run 'git pull --rebase', then Push-Dirty again."
    }
    Write-Message "Pushed '$branch'."
}
