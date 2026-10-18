function Sync-GeneratedFile {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [switch] $DryRun
    )

    # The generated paths the janitor owns, each with the commit-message subject naming it; the modules folder comes from its resolver.
    $modulesFolder = Get-CatzcModulesFolder
    $compiled = "$modulesFolder/.compiled"
    $generatedPaths = [ordered]@{
        $compiled = 'compiled types'
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
        Write-Message "Skipped: the git_workspace variant is 'main-via-pr' and this is $branch — commit generated files from a working branch (variants.yml, ADR-REPO-VARIANT-GITWORKSPACE)."
        return
    }

    $changed = @($generatedPaths.Keys | Where-Object { Test-GitPathChanged $_ })

    if ($changed -contains $compiled) {
        $surplus = @(Clear-ModuleTypeCache -DryRun -Silent)
        if ($surplus.Count) {
            $names = ($surplus | ForEach-Object { [System.IO.Path]::GetFileName($_) } | Sort-Object) -join ', '
            Write-Message "Skipped ${compiled}: superseded type assemblies remain ($names). Restart the session holding them, run Clear-ModuleTypeCache, then re-import." -ForegroundColor Red
            $changed = @($changed | Where-Object { $_ -ne $compiled })
        }
    }

    if ($changed -contains $compiled -and (Test-GitPathChanged "$modulesFolder/*/types/*.cs")) {
        Write-Message "Skipped ${compiled}: type sources (types/*.cs) differ from HEAD, so this build is not the one HEAD produces. Commit the type sources, then re-import." -ForegroundColor Yellow
        $changed = @($changed | Where-Object { $_ -ne $compiled })
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
