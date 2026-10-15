<#
---
catzc:
  derived:
    path: automation/Catzc.Base.ModuleSystem/Sync-GeneratedFile.ps1
    kind: automation-function
    module: Catzc.Base.ModuleSystem
    visibility: public
    adrs:
      - ADR-AUTO-CACHE#8
      - ADR-AUTO-TYPES#13
      - ADR-DSGN-RUNMODE
      - ADR-REPO-VARIANT#6
  config:
    synopsis: Commits the importer-maintained generated files to git — the dev-box janitor.
    description: |-
      The dev-box janitor the importer runs on every load: in a person's session it commits what actually
      differs from HEAD under the generated-file paths — automation/.compiled/ (the committed
      compiled type assembly) — via Invoke-GitCommit. Deriving the commit set from git status rather than
      this run's reports also picks up a generated file an earlier import wrote but never committed (the
      .compiled DLL swap happens during load, before any switch is consulted).

      The commit stages and names only the generated paths that actually changed: a type rebuild commits
      'automation/.compiled' as "chore(repo): sync compiled types". The stamp commit's pathspec and message
      are the same fact — never a sibling path that happened to be clean.

      Guards, in order — each skip is one explanatory message and leaves the working tree untouched:
      - Skips in build mode (Get-CatzcRunMode,
      [ADR-DSGN-RUNMODE](/docs/adr/design/run-modes.md)): the generated files belong to the source tree,
        and the session runs a built package. A skip, not a throw, because the importer's janitor tail calls
        this on every load and a janitor never breaks the load.
      - Skips, silently, in a test-run snapshot (Test-RepositorySnapshot): the disposable clone a test run
        executes in is never committed to.
      - Who is running decides (Get-SessionActor,
        [ADR-AUTO-TYPES#13](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types13)): a pipeline skips —
        the gates there must fail loudly, not be auto-repaired — and an agent never commits: it announces which
        generated paths changed and leaves the commit to the person, whose repository it is. Only a person's
        session commits.
      - Skips on a detached HEAD: a commit there hangs off no branch and is one checkout away from lost.
      - Skips on main/master when the repo's git_workspace variant is 'main-via-pr' (Test-GitWorkspace,
        [ADR-REPO-VARIANT#6](/docs/adr/repository/repo-variants.md#rule-adr-repo-variant6)): in that mode work always
        happens on a branch, so standing on main locally is the
        one place a direct commit is forbidden. In 'main-direct' (the default, a solo-author trunk) any
        named branch commits — including main, which IS the integration path (one-living-version).
      - Holds back automation/.compiled while it holds anything but the current build
        (Clear-ModuleTypeCache -DryRun lists the surplus): a superseded DLL a live session still locks
        would otherwise be committed next to the new one. One red line names the surplus; any other
        changed generated path still commits.
      - Holds back automation/.compiled while any type source (automation/*/types/*.cs) differs from HEAD:
        the build is named for the hash of the sources in the working tree, so committing it ahead of them would
        leave HEAD with a build its own sources do not produce. One yellow line asks for the sources to be
        committed; the next import commits the build.

      Past the guards it commits what changed under the generated paths — other uncommitted or staged work
      does not hold the stamp commit back. Invoke-GitCommit stages and commits by PATHSPEC
      (`git add -A --`/`git commit --` limited to the changed generated paths), so exactly the generated
      files land in the stamp commit whatever else is modified or staged: unrelated staged work stays
      staged, and a generated file someone staged earlier is re-staged at its current content and carried
      along. CI verifies the pushed HEAD by recomputing the hashes.
    parameters:
      DryRun: |-
        Propagated to Invoke-GitCommit: the changed generated paths are still probed (a read), but instead of
        committing, the planned git commands for those paths are returned.
    outputs: |-
      [string] The new commit's SHA (or the planned commands with -DryRun); nothing when a guard skipped
      or no generated path changed.
    examples:
      - Sync-GeneratedFile
      - Sync-GeneratedFile -DryRun
---
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

    # A test-run snapshot is a disposable clone: what it generates is never committed there.
    if (Test-RepositorySnapshot) {
        return
    }

    $actor = Get-SessionActor
    if ($actor -eq 'Pipeline') {
        Write-Message 'Skipped: running in a pipeline — CI gates verify generated files, they never auto-commit them.'
        return
    }
    if ($actor -eq 'Agent') {
        $pending = @($generatedPaths.Keys | Where-Object { Test-GitPathChanged $_ })
        if ($pending.Count) {
            Write-Message "Not committed: this is an agent session — generated files changed ($($pending -join ', ')); commit them." -ForegroundColor Yellow
        }
        return
    }

    $branch = Get-GitCurrentBranch
    if ($branch -eq 'HEAD') {
        Write-Message 'Skipped: detached HEAD — a commit here hangs off no branch.'
        return
    }
    if ($branch -in 'main', 'master' -and (Test-GitWorkspace -MainViaPr)) {
        Write-Message "Skipped: the git_workspace variant is 'main-via-pr' and this is $branch — commit generated files from a working branch (variants.yml, ADR-REPO-VARIANT#6)."
        return
    }

    # Which generated paths actually changed decides both the commit's pathspec and its message — the stamp commit...
    # [comment:6](/docs/references/automation/catzc-base-modulesystem/Sync-GeneratedFile.ps1.md#comment6)
    $changed = @($generatedPaths.Keys | Where-Object { Test-GitPathChanged $_ })

    # .compiled must hold exactly the current build.
    # [comment:7](/docs/references/automation/catzc-base-modulesystem/Sync-GeneratedFile.ps1.md#comment7)
    if ($changed -contains 'automation/.compiled') {
        $surplus = @(Clear-ModuleTypeCache -DryRun -Silent)
        if ($surplus.Count) {
            $names = ($surplus | ForEach-Object { [System.IO.Path]::GetFileName($_) } | Sort-Object) -join ', '
            Write-Message "Skipped automation/.compiled: superseded type assemblies remain ($names). Restart the session holding them, run Clear-ModuleTypeCache, then re-import." -ForegroundColor Red
            $changed = @($changed | Where-Object { $_ -ne 'automation/.compiled' })
        }
    }

    # The build is named for the hash of the working-tree type sources.
    # [comment:8](/docs/references/automation/catzc-base-modulesystem/Sync-GeneratedFile.ps1.md#comment8)
    if ($changed -contains 'automation/.compiled' -and (Test-GitPathChanged 'automation/*/types/*.cs')) {
        Write-Message 'Skipped automation/.compiled: type sources (types/*.cs) differ from HEAD, so this build is not the one HEAD produces. Commit the type sources, then re-import.' -ForegroundColor Yellow
        $changed = @($changed | Where-Object { $_ -ne 'automation/.compiled' })
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
