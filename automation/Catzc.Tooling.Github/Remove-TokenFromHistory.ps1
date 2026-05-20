<#
.SYNOPSIS
    Scrubs a token from a git history's blob content and commit messages with
    git-filter-repo. The fallback route — prefer New-SyntheticHistory.
.DESCRIPTION
    Rewrites every commit, replacing the token in file content (and, unless
    -SkipMessages, in commit messages) with a placeholder. This is the
    second-choice tool: a filter-repo rewrite leaves the old, un-scrubbed commits
    as unreachable objects until GitHub garbage-collects them, and it does NOT
    touch the token where it appears in a file *path* (content replacement cannot
    rename files). When the token also lives in path names — or you simply want a
    guaranteed-clean result with no residual objects — rebuild the history from a
    clean tree with New-SyntheticHistory instead.

    After scrubbing it re-scans with Test-GitHistoryClean and returns the result,
    so a caller can see any path-name residue the content scrub could not reach.
.PARAMETER Token
    The literal token to replace across the history.
.PARAMETER ReplaceWith
    The placeholder to substitute. Defaults to '***REMOVED***'.
.PARAMETER SkipMessages
    Only scrub blob content, leaving commit messages untouched.
.PARAMETER RepositoryPath
    The repository to rewrite. Defaults to the repository root.
.PARAMETER DryRun
    Return the planned command and replacement expression without rewriting.
.EXAMPLE
    Remove-TokenFromHistory -Token 'old-name' -DryRun
.EXAMPLE
    $result = Remove-TokenFromHistory -Token 'secret'
    if (-not $result.Clean) { $result.Paths }   # path-name residue the scrub cannot reach
#>
function Remove-TokenFromHistory {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Token,

        [string] $ReplaceWith = '***REMOVED***',

        [switch] $SkipMessages,

        [string] $RepositoryPath = (Get-RepositoryRoot),

        [switch] $DryRun
    )

    # filter-repo replace-text/-message read `literal==>replacement` from a file.
    $expression = "$Token==>$ReplaceWith"

    $planParts = @('git filter-repo', '--replace-text <expressions>')
    if (-not $SkipMessages) {
        $planParts += '--replace-message <expressions>'
    }
    $planParts += '--force'
    $plannedCommand = $planParts -join ' '

    if ($DryRun) {
        return [pscustomobject]@{
            DryRun     = $true
            Command    = $plannedCommand
            Expression = $expression
        }
    }

    Assert-Command git
    $probe = Invoke-Executable 'git filter-repo --version' -PassThru -NoAssert -Silent
    if ($probe.ExitCode -ne 0) {
        throw "git-filter-repo is not installed (install with 'pip install git-filter-repo'). This is the fallback scrub — prefer New-SyntheticHistory, which needs no external tool."
    }

    $expressionFile = Join-Path ([System.IO.Path]::GetTempPath()) ('catzc-scrub-' + [guid]::NewGuid().ToString('N').Substring(0, 12) + '.txt')
    Set-Content -LiteralPath $expressionFile -Value $expression -NoNewline
    try {
        $runArgs = "--replace-text `"$expressionFile`""
        if (-not $SkipMessages) {
            $runArgs += " --replace-message `"$expressionFile`""
        }
        $run = Invoke-Executable "git filter-repo $runArgs --force" -WorkingDirectory $RepositoryPath -PassThru -NoAssert
        if ($run.ExitCode -ne 0) {
            throw "git filter-repo failed: $($run.Errors)"
        }
    }
    finally {
        Remove-Item -LiteralPath $expressionFile -Force -ErrorAction SilentlyContinue
    }

    $scan = Test-GitHistoryClean -Token $Token -Ref '--all' -RepositoryPath $RepositoryPath
    if ($scan.Clean) {
        Write-Message "Scrubbed '$Token' from content and messages; history is clean."
    }
    else {
        Write-Message "Scrubbed content and messages, but '$Token' still appears (likely in file paths — content replacement cannot rename files). Use New-SyntheticHistory for a guaranteed-clean rebuild."
    }

    [pscustomobject]@{
        DryRun   = $false
        Command  = $plannedCommand
        Clean    = $scan.Clean
        Blobs    = $scan.Blobs
        Paths    = $scan.Paths
        Messages = $scan.Messages
    }
}
