<#
.SYNOPSIS
    Regenerates the sha-marker files and commits the importer-maintained generated files to git.
.DESCRIPTION
    The dev-box janitor the importer runs by default (opt out: -NoCommitShaMarkersInDevBox): runs
    Update-ShaMarker, then commits what actually differs from HEAD under the generated-file paths —
    .sha-markers/ (durable-SHA marker files, docs/adr/pipelines/durable-sha-globs.md) and
    automation/.compiled/ (the committed compiled type assembly) — via Invoke-GitCommit. Deriving the
    commit set from git status rather than this run's reports also picks up generated files an earlier
    import wrote but never committed (the .compiled DLL swap happens during load, before any switch is
    consulted).

    The commit stages and names only the generated paths that actually changed: a marker-only sync
    commits '.sha-markers' alone as "chore(repo): sync sha-marker files", a type rebuild alone commits
    'automation/.compiled' as "chore(repo): sync compiled types", and only a run that changed both
    stages both and says so. The stamp commit's pathspec and message are the same fact — never a
    sibling path that happened to be clean.

    Guards, in order — each skip is one explanatory message and leaves the working tree untouched:
    - Skips in CI (Test-IsRunningInPipeline): the gates there must fail loudly, not be auto-repaired.
    - Skips on a detached HEAD: a commit there hangs off no branch and is one checkout away from lost.
    - Skips on main/master when the repo's git_workspace variant is 'main-via-pr' (Test-GitWorkspace,
      ADR-VARIANT:6): in that mode work always happens on a branch, so standing on main locally is the
      one place a direct commit is forbidden. In 'main-direct' (the default, a solo-author trunk) any
      named branch commits — including main, which IS the integration path (one-living-version).

    Past the guards it always commits what changed under the generated paths — a dirty or even staged
    working tree does not hold the stamp commit back. Invoke-GitCommit stages and commits by PATHSPEC
    (`git add -A --`/`git commit --` limited to the changed generated paths), so exactly the generated
    files land in the stamp commit whatever else is modified or staged: unrelated staged work stays
    staged, and a generated file someone staged earlier is re-staged at its current content and carried
    along. The stamps hash working-tree content, so mid-work they describe the tree the in-flight edits
    will join in the next work commit; CI verifies the pushed HEAD by recomputing the hashes.
.PARAMETER DryRun
    Propagated to Invoke-GitCommit: the marker files are still regenerated (Update-ShaMarker is
    idempotent) and the changed generated paths are still probed (a read), but instead of committing,
    the planned git commands for those paths are returned.
.OUTPUTS
    [string] The new commit's SHA (or the planned commands with -DryRun); nothing when a guard skipped
    or no generated path changed.
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

    # The generated paths the janitor owns, each with the commit-message subject naming it.
    $generatedPaths = [ordered]@{
        '.sha-markers'         = 'sha-marker files'
        'automation/.compiled' = 'compiled types'
    }

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

    Update-ShaMarker

    # Which generated paths actually changed decides both the commit's pathspec and its message — the
    # stamp commit stages and names exactly what this sync did, never a sibling path that was clean.
    $changed = @($generatedPaths.Keys | Where-Object { Test-GitPathChanged $_ })
    if (-not $changed.Count) {
        return
    }
    $subject = @($changed | ForEach-Object { $generatedPaths[$_] }) -join ' and '

    $result = Invoke-GitCommit -Path $changed -Message "chore(repo): sync $subject" -DryRun:$DryRun
    if ($result -and -not $DryRun) {
        Write-Message "Synced $subject to $branch"
    }
    $result
}
