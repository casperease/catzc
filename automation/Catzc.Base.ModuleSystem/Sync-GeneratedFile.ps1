<#
---
catzc:
  derived:
    path: automation/Catzc.Base.ModuleSystem/Sync-GeneratedFile.ps1
    kind: function
    module: Catzc.Base.ModuleSystem
    visibility: public
    adrs:
      - ADR-AUTO-CACHE#8
      - ADR-AUTO-TYPES#13
      - ADR-DSGN-RUNMODE
      - ADR-REPO-VARIANT#6
---
#>

<#
.SYNOPSIS
    Commits the importer-maintained generated files to git — the dev-box janitor.
.DESCRIPTION
    Only a person's session commits: a pipeline must fail loudly and an agent leaves the commit to the person.
    [comment:1](/docs/references/automation/catzc-base-modulesystem/Sync-GeneratedFile.ps1.md#comment1)
.PARAMETER DryRun
    Changed paths are still probed, so a dry run returns the exact git commands a real run would issue.
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

    # One fact drives pathspec and message, so the stamp commit never names a sibling path that was clean.
    # [comment:3](/docs/references/automation/catzc-base-modulesystem/Sync-GeneratedFile.ps1.md#comment3)
    $changed = @($generatedPaths.Keys | Where-Object { Test-GitPathChanged $_ })

    # A superseded DLL that a live session still locks would otherwise be committed next to the new one.
    # [comment:4](/docs/references/automation/catzc-base-modulesystem/Sync-GeneratedFile.ps1.md#comment4)
    if ($changed -contains 'automation/.compiled') {
        $surplus = @(Clear-ModuleTypeCache -DryRun -Silent)
        if ($surplus.Count) {
            $names = ($surplus | ForEach-Object { [System.IO.Path]::GetFileName($_) } | Sort-Object) -join ', '
            Write-Message "Skipped automation/.compiled: superseded type assemblies remain ($names). Restart the session holding them, run Clear-ModuleTypeCache, then re-import." -ForegroundColor Red
            $changed = @($changed | Where-Object { $_ -ne 'automation/.compiled' })
        }
    }

    # Committing the build ahead of edited type sources would leave HEAD with a build its own sources do not produce.
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
