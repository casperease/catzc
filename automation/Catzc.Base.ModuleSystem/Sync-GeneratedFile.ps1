<#
.SYNOPSIS
    Regenerates the trigger files and commits the importer-maintained generated files to git.
.DESCRIPTION
    The dev-box janitor the importer runs by default (opt out: -NoCommitTriggersInDevBox): runs Update-Trigger, then
    commits whatever under the generated-file paths — .triggers/ (durable-SHA trigger files,
    docs/adr/pipelines/durable-sha-globs.md) and automation/.compiled/ (the committed compiled type
    assembly) — differs from HEAD, via Invoke-GitCommit. Deriving the commit set from git status rather
    than this run's reports also picks up generated files an earlier import wrote but never committed
    (the .compiled DLL swap happens during load, before any switch is consulted).

    Guards, in order — each skip is one explanatory message and leaves the working tree untouched:
    - Skips in CI (Test-IsRunningInPipeline): the gates there must fail loudly, not be auto-repaired.
    - Skips on a detached HEAD: a commit there hangs off no branch and is one checkout away from lost.
    - Skips on main/master when the repo's git_workspace variant is 'main-via-pr' (Test-GitWorkspace,
      ADR-VARIANT:6): in that mode work always happens on a branch, so standing on main locally is the
      one place a direct commit is forbidden. In 'main-direct' (the default, a solo-author trunk) any
      named branch commits — including main, which IS the integration path (one-living-version).

    Past the guards it always commits what changed under the generated paths — a dirty or even staged
    working tree does not hold the stamp commit back. Invoke-GitCommit stages and commits by PATHSPEC
    (`git add -A --`/`git commit --` limited to the generated paths), so exactly the generated files land
    in the stamp commit whatever else is modified or staged: unrelated staged work stays staged, and a
    generated file someone staged earlier is re-staged at its current content and carried along. The
    stamps hash working-tree content, so mid-work they describe the tree the in-flight edits will join in
    the next work commit; CI verifies the pushed HEAD by recomputing the hashes.
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
    if ($branch -eq 'HEAD') {
        Write-Message 'Skipped: detached HEAD — a commit here hangs off no branch.'
        return
    }
    if ($branch -in 'main', 'master' -and (Test-GitWorkspace -MainViaPr)) {
        Write-Message "Skipped: the git_workspace variant is 'main-via-pr' and this is $branch — commit generated files from a working branch (variants.yml, ADR-VARIANT:6)."
        return
    }

    Update-Trigger

    # Commit whatever changed under the generated paths — Invoke-GitCommit is the idempotent no-op when
    # nothing did, and its pathspec-limited add+commit means exactly the generated files land in the
    # stamp commit whatever else is modified or staged.
    $result = Invoke-GitCommit -Path $generatedPaths -Message 'chore(repo): sync trigger files and compiled types' -DryRun:$DryRun
    if ($result -and -not $DryRun) {
        Write-Message "Sha files were synced to $branch"
    }
    $result
}
