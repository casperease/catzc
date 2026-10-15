<#
.SYNOPSIS
    Removes superseded compiled C# type assemblies, keeping the current combined build.
.DESCRIPTION
    The single combined assembly in automation/.compiled/ (Catzc.Types.<combinedHash8>.dll) is committed to source...
    [ADR-AUTO-CACHE#8](/docs/adr/automation/caching.md#rule-adr-auto-cache8),
    [ADR-DSGN-RUNMODE](/docs/adr/design/run-modes.md)
    [comment:1](/docs/references/automation/catzc-base-typessystem/Clear-ModuleTypeCache.ps1.md#comment1)
.PARAMETER AutomationRoot
    Path to the automation directory (the parent of.compiled/).
    [comment:2](/docs/references/automation/catzc-base-typessystem/Clear-ModuleTypeCache.ps1.md#comment2)
.PARAMETER DryRun
    Return the list of cache files that would be deleted, without deleting anything.
.PARAMETER Silent
    Suppress the per-file and end-state 'type cache: …' messages.
    [comment:3](/docs/references/automation/catzc-base-typessystem/Clear-ModuleTypeCache.ps1.md#comment3)
.PARAMETER StopLockingProcesses
    The kill switch.
    [comment:4](/docs/references/automation/catzc-base-typessystem/Clear-ModuleTypeCache.ps1.md#comment4)
.EXAMPLE
    Clear-ModuleTypeCache
.EXAMPLE
    Clear-ModuleTypeCache -StopLockingProcesses   # stop the sessions holding stale builds, then delete them
.EXAMPLE
    Clear-ModuleTypeCache -DryRun
#>
function Clear-ModuleTypeCache {
    param(
        [string] $AutomationRoot = (Get-CatzcModulesRoot),

        [switch] $DryRun,

        [switch] $Silent,

        [switch] $StopLockingProcesses
    )

    # Build mode: the loaded code root is an installed package, not a devbox cache — never delete inside it.
    if ((Get-CatzcRunMode) -eq 'build') {
        $targetRoot = [System.IO.Path]::GetFullPath($AutomationRoot).TrimEnd('\', '/')
        $packageRoot = [System.IO.Path]::GetFullPath((Get-CatzcModulesRoot)).TrimEnd('\', '/')
        if ($targetRoot -ieq $packageRoot) {
            if (-not $Silent) {
                Write-Message "type cache: skipped — this session runs a built Catzc package ($packageRoot); its .compiled is the build's output, not a cache."
            }
            return
        }
    }

    $compiledDir = Join-Path $AutomationRoot '.compiled'

    # Pipeline: nothing is deleted (CI makes no source-control changes), so more than one Catzc.Types.*.dll means two...
    # [comment:5](/docs/references/automation/catzc-base-typessystem/Clear-ModuleTypeCache.ps1.md#comment5)
    if (Test-IsRunningInPipeline) {
        # @(): an if-expression unrolls a 0/1-item list.
        $typeDlls = @(if (Test-Path $compiledDir -PathType Container) {
                [System.IO.Directory]::EnumerateFiles($compiledDir, 'Catzc.Types.*.dll')
            })
        if ($typeDlls.Count -gt 1) {
            $names = ($typeDlls | ForEach-Object { [System.IO.Path]::GetFileName($_) } | Sort-Object) -join ', '
            throw "More than one compiled type assembly is committed in automation/.compiled ($names). The committed .compiled must contain exactly one build. On the devbox, run Clear-ModuleTypeCache and commit the single remaining build."
        }
        if (-not $Silent) {
            Write-Message 'type cache: skipped — running in a pipeline (CI makes no source-control changes).'
        }
        return
    }

    Assert-PathExist $AutomationRoot -PathType Container

    $ret = [System.Collections.Generic.List[string]]::new()
    if (-not (Test-Path $compiledDir -PathType Container)) {
        if (-not $Silent) {
            Write-Message 'type cache: no .compiled directory present — nothing to clean.'
        }
        if ($DryRun) {
            return $ret
        }
        return
    }

    # Keep exactly the current build (Catzc.Types.<combinedHash8>.dll) and prune every other Catzc.Types.*.dll.
    # [comment:6](/docs/references/automation/catzc-base-typessystem/Clear-ModuleTypeCache.ps1.md#comment6)
    Import-InternalModule Types
    $combinedHash = (Get-CombinedTypeHash $AutomationRoot).CombinedHash
    $keep = if ($combinedHash) {
        "Catzc.Types.$combinedHash.dll"
    }
    else {
        $null
    }

    foreach ($dll in [System.IO.Directory]::EnumerateFiles($compiledDir, '*.dll')) {
        if ($keep -and [System.IO.Path]::GetFileName($dll) -ieq $keep) {
            continue
        }   # current build — keep
        $ret.Add($dll)
    }

    if ($DryRun) {
        if (-not $Silent) {
            Write-Message "type cache: dry run — $($ret.Count) superseded build(s) would be removed."
        }
        return $ret
    }

    # Delete every superseded build, collecting the failures so every deletable build is gone before the throw.
    $removed = 0
    $failed = [System.Collections.Generic.List[pscustomobject]]::new()
    foreach ($dll in $ret) {
        try {
            [System.IO.File]::Delete($dll)
            $removed++
            if (-not $Silent) {
                Write-Message "Removed stale type assembly: $dll"
            }
        }
        catch {
            $failed.Add([pscustomobject]@{ Path = $dll; Reason = $_.Exception.Message })
        }
    }

    # The kill switch: stop each process holding a build that would not delete, then retry the delete.
    # [comment:7](/docs/references/automation/catzc-base-typessystem/Clear-ModuleTypeCache.ps1.md#comment7)
    if ($StopLockingProcesses -and $failed.Count) {
        $retried = [System.Collections.Generic.List[pscustomobject]]::new()
        foreach ($entry in $failed) {
            Stop-FileLockingProcess -Path $entry.Path
            $path = $entry.Path
            $reason = Invoke-WithProgress -Message "Waiting for $([System.IO.Path]::GetFileName($path)) to be released" -IntervalMs 200 {
                $lastError = $null
                for ($attempt = 1; $attempt -le 10; $attempt++) {
                    try {
                        [System.IO.File]::Delete($path)
                        return $null
                    }
                    catch {
                        $lastError = $_.Exception.Message
                        Start-Sleep -Milliseconds 200
                    }
                }
                $lastError
            }
            if ($reason) {
                $retried.Add([pscustomobject]@{ Path = $entry.Path; Reason = $reason })
                continue
            }
            $removed++
            if (-not $Silent) {
                Write-Message "Removed stale type assembly: $($entry.Path)"
            }
        }
        $failed = $retried
    }

    if (-not $Silent) {
        if ($ret.Count -eq 0) {
            Write-Message 'type cache: already clean — no superseded builds to remove.'
        }
        else {
            Write-Message "type cache: removed $removed of $($ret.Count) superseded build(s)."
        }
    }

    if ($failed.Count) {
        # Who holds each surviving file — best-effort: the lookup only enriches the message, so a Restart Manager...
        # [comment:8](/docs/references/automation/catzc-base-typessystem/Clear-ModuleTypeCache.ps1.md#comment8)
        $details = foreach ($entry in $failed) {
            $name = [System.IO.Path]::GetFileName($entry.Path)
            $holders = try {
                Format-FileLockingProcess @(Get-FileLockingProcess $entry.Path)
            }
            catch {
                $null
            }
            if ($holders) {
                "$name, held by $holders"
            }
            else {
                "$name ($($entry.Reason))"
            }
        }
        throw "Could not remove superseded type assemblies from automation/.compiled: $($details -join '; '). Types load from a per-user shadow copy, so no catzc session holds .compiled; close what does, then re-run Clear-ModuleTypeCache."
    }
}
