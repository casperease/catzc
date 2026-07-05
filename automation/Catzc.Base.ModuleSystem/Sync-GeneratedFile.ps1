<#
.SYNOPSIS
    Regenerates the trigger files and commits the importer-maintained generated files to git.
.DESCRIPTION
    The dev-box convenience behind the importer's -CommitTriggers switch: runs Update-Trigger, then
    commits whatever under the generated-file paths — .triggers/ (durable-SHA trigger files,
    docs/adr/pipelines/durable-sha-globs.md) and automation/.compiled/ (the committed compiled type
    assembly) — differs from HEAD, via Invoke-GitCommit. Deriving the commit set from git status rather
    than this run's reports also picks up generated files an earlier import wrote but never committed
    (the .compiled DLL swap happens during load, before any switch is consulted).

    Guards, in order — each skip is one explanatory message, and every guard leaves the working tree
    untouched or merely re-synced, never committed:
    - Skips in CI (Test-IsRunningInPipeline): the gates there must fail loudly, not be auto-repaired.
    - Skips on main/master and on a detached HEAD: auto-writing the mainline outside the normal
      integration path is what docs/adr/design/ci-discipline-and-promotion-flow.md forbids.
    - Skips the commit (but still syncs) while the tracked working tree is dirty outside the generated
      paths: the durable SHA hashes working-tree content, so a trigger committed from a dirty tree would
      match neither that commit nor HEAD.
.PARAMETER DryRun
    Propagated to Invoke-GitCommit: the trigger files are still regenerated (Update-Trigger is
    idempotent), but instead of committing, the planned git commands are returned.
.OUTPUTS
    [string] The new commit's SHA (or the planned commands with -DryRun); nothing when a guard skipped
    or there was nothing to commit.
.EXAMPLE
    Sync-GeneratedFile
.EXAMPLE
    Sync-GeneratedFile -DryRun
#>
function Sync-GeneratedFile {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [switch] $DryRun
    )

    $generatedPaths = '.triggers', 'automation/.compiled'

    if (Test-IsRunningInPipeline) {
        Write-Message 'Skipped: running in a pipeline — CI gates verify generated files, they never auto-commit them.'
        return
    }

    $branch = Get-GitCurrentBranch
    if ($branch -in 'main', 'master', 'HEAD') {
        Write-Message "Skipped: auto-committing generated files is for feature branches, not '$branch'."
        return
    }

    Update-Trigger

    # One porcelain pass answers both questions: is anything under the generated paths uncommitted, and
    # is any OTHER tracked file dirty (untracked '??' lines never move a durable SHA — membership is
    # `git ls-files` — so they do not count).
    $status = Invoke-Executable 'git status --porcelain' -PassThru -Silent
    $generatedChanges = [System.Collections.Generic.List[string]]::new()
    $otherChanges = [System.Collections.Generic.List[string]]::new()
    foreach ($line in ($status.Output -split "`n")) {
        if ([string]::IsNullOrWhiteSpace($line) -or $line.StartsWith('??')) {
            continue
        }
        $changedPath = $line.Substring(3).Trim()
        $isGenerated = $false
        foreach ($generatedPath in $generatedPaths) {
            if ($changedPath.StartsWith("$generatedPath/")) {
                $isGenerated = $true
            }
        }
        if ($isGenerated) {
            $generatedChanges.Add($changedPath)
        }
        else {
            $otherChanges.Add($changedPath)
        }
    }

    if ($generatedChanges.Count -eq 0) {
        return
    }
    if ($otherChanges.Count -gt 0) {
        Write-Message "Working tree has uncommitted changes ($($otherChanges.Count)) — generated files synced but not committed."
        return
    }

    $result = Invoke-GitCommit -Path $generatedPaths -Message 'chore(repo): sync trigger files and compiled types' -DryRun:$DryRun
    if (-not $DryRun) {
        Write-Message "Sha files were synced to $branch"
    }
    $result
}
