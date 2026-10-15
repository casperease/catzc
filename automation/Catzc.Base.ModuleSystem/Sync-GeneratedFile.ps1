<#
.SYNOPSIS
    Commits the importer-maintained generated files to git — the dev-box janitor.
.DESCRIPTION
    The dev-box janitor the importer runs on every load: in a person's session it commits what actually differs from...
    [ADR-DSGN-RUNMODE](/docs/adr/design/run-modes.md),
    [ADR-AUTO-TYPES#13](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types13),
    [ADR-REPO-VARIANT#6](/docs/adr/repository/repo-variants.md#rule-adr-repo-variant6)
    [comment:1](/docs/references/automation/catzc-base-modulesystem/Sync-GeneratedFile.ps1.md#comment1)
.PARAMETER DryRun
    Propagated to Invoke-GitCommit: the changed generated paths are still probed (a read), but instead of committing,...
    [comment:2](/docs/references/automation/catzc-base-modulesystem/Sync-GeneratedFile.ps1.md#comment2)
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
    # [comment:3](/docs/references/automation/catzc-base-modulesystem/Sync-GeneratedFile.ps1.md#comment3)
    $changed = @($generatedPaths.Keys | Where-Object { Test-GitPathChanged $_ })

    # .compiled must hold exactly the current build.
    # [ADR-AUTO-CACHE#8](/docs/adr/automation/caching.md#rule-adr-auto-cache8)
    # [comment:4](/docs/references/automation/catzc-base-modulesystem/Sync-GeneratedFile.ps1.md#comment4)
    if ($changed -contains 'automation/.compiled') {
        $surplus = @(Clear-ModuleTypeCache -DryRun -Silent)
        if ($surplus.Count) {
            $names = ($surplus | ForEach-Object { [System.IO.Path]::GetFileName($_) } | Sort-Object) -join ', '
            Write-Message "Skipped automation/.compiled: superseded type assemblies remain ($names). Restart the session holding them, run Clear-ModuleTypeCache, then re-import." -ForegroundColor Red
            $changed = @($changed | Where-Object { $_ -ne 'automation/.compiled' })
        }
    }

    # The build is named for the hash of the working-tree type sources.
    # [comment:5](/docs/references/automation/catzc-base-modulesystem/Sync-GeneratedFile.ps1.md#comment5)
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
