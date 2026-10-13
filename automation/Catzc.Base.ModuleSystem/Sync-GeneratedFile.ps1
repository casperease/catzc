<#
.SYNOPSIS
    Commits the importer-maintained generated files to git — the dev-box janitor.
.DESCRIPTION
    The dev-box janitor the importer runs by default (opt out: -NoCommitShaMarkersInDevBox): commits what
    actually differs from HEAD under the generated-file paths — automation/.compiled/ (the committed
    compiled type assembly) — via Invoke-GitCommit. Deriving the commit set from git status rather than
    this run's reports also picks up a generated file an earlier import wrote but never committed (the
    .compiled DLL swap happens during load, before any switch is consulted).

    The commit stages and names only the generated paths that actually changed: a type rebuild commits
    'automation/.compiled' as "chore(repo): sync compiled types". The stamp commit's pathspec and message
    are the same fact — never a sibling path that happened to be clean.

    Guards, in order — each skip is one explanatory message and leaves the working tree untouched:
    - Skips in build mode (Get-CatzcRunMode, ADR-DSGN-RUNMODE): the generated files belong to the source tree,
      and the session runs a built package. A skip, not a throw, because the importer's janitor tail calls
      this on every load and a janitor never breaks the load.
    - Skips in CI (Test-IsRunningInPipeline): the gates there must fail loudly, not be auto-repaired.
    - Skips on a detached HEAD: a commit there hangs off no branch and is one checkout away from lost.
    - Skips on main/master when the repo's git_workspace variant is 'main-via-pr' (Test-GitWorkspace,
      ADR-REPO-VARIANT:6): in that mode work always happens on a branch, so standing on main locally is the
      one place a direct commit is forbidden. In 'main-direct' (the default, a solo-author trunk) any
      named branch commits — including main, which IS the integration path (one-living-version).
    - Holds back automation/.compiled while it holds anything but the current build
      (Clear-ModuleTypeCache -DryRun lists the surplus): a superseded DLL a live session still locks
      would otherwise be committed next to the new one. One red line names the surplus; any other
      changed generated path still commits.

    Past the guards it always commits what changed under the generated paths — a dirty or even staged
    working tree does not hold the stamp commit back. Invoke-GitCommit stages and commits by PATHSPEC
    (`git add -A --`/`git commit --` limited to the changed generated paths), so exactly the generated
    files land in the stamp commit whatever else is modified or staged: unrelated staged work stays
    staged, and a generated file someone staged earlier is re-staged at its current content and carried
    along. The stamps hash working-tree content, so mid-work they describe the tree the in-flight edits
    will join in the next work commit; CI verifies the pushed HEAD by recomputing the hashes.
.PARAMETER DryRun
    Propagated to Invoke-GitCommit: the changed generated paths are still probed (a read), but instead of
    committing, the planned git commands for those paths are returned.
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
        'automation/.compiled' = 'compiled types'
    }

    if ((Get-CatzcRunMode) -eq 'build') {
        Write-Message 'Skipped: this session runs a built Catzc package — generated files are committed from the source tree (importer.ps1).'
        return
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
        Write-Message "Skipped: the git_workspace variant is 'main-via-pr' and this is $branch — commit generated files from a working branch (variants.yml, ADR-REPO-VARIANT:6)."
        return
    }

    # Which generated paths actually changed decides both the commit's pathspec and its message — the
    # stamp commit stages and names exactly what this sync did, never a sibling path that was clean.
    $changed = @($generatedPaths.Keys | Where-Object { Test-GitPathChanged $_ })

    # .compiled must hold exactly the current build (ADR-AUTO-TYPES:6). A superseded DLL that survived the
    # janitor (a session still holds it) would otherwise be committed next to the new one — the +1 without
    # the -1. Hold the .compiled commit back until it is tidy; any other changed generated path still commits.
    if ($changed -contains 'automation/.compiled') {
        $surplus = @(Clear-ModuleTypeCache -DryRun -Silent)
        if ($surplus.Count) {
            $names = ($surplus | ForEach-Object { [System.IO.Path]::GetFileName($_) } | Sort-Object) -join ', '
            Write-Message "Skipped automation/.compiled: superseded type assemblies remain ($names). Restart the session holding them, run Clear-ModuleTypeCache, then re-import." -ForegroundColor Red
            $changed = @($changed | Where-Object { $_ -ne 'automation/.compiled' })
        }
    }

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
