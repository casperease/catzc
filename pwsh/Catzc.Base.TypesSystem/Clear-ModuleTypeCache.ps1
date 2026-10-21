<#
---
catzc:
  immutable:
    with_body_sha: "8d4643321dc2"
  edges:
    test: pwsh/Catzc.Base.TypesSystem/tests/Clear-ModuleTypeCache.Tests.ps1
    docs: "[Clear-ModuleTypeCache.ps1.md](docs/references/pwsh/catzc-base-types-system/Clear-ModuleTypeCache.ps1.md)"
    cites:
      - ADR-AUTO-CACHE-COMPILEDTYPEPREBUILD
      - ADR-DSGN-RUNMODE
---
#>

function Clear-ModuleTypeCache {
    param(
        [string] $ModulesRoot = (Get-CatzcModulesRoot),

        [switch] $DryRun,

        [switch] $Silent,

        [switch] $StopLockingProcesses
    )

    # Build mode: the loaded code root is an installed package, not a devbox cache — never delete inside it.
    if ((Get-CatzcRunMode) -eq 'build') {
        $targetRoot = [System.IO.Path]::GetFullPath($ModulesRoot).TrimEnd('\', '/')
        $packageRoot = [System.IO.Path]::GetFullPath((Get-CatzcModulesRoot)).TrimEnd('\', '/')
        if ($targetRoot -ieq $packageRoot) {
            if (-not $Silent) {
                Write-Message "type cache: skipped — this session runs a built Catzc package ($packageRoot); its .compiled is the build's output, not a cache."
            }
            return
        }
    }

    $compiledDir = Join-Path $ModulesRoot '.compiled'

    if (Test-IsRunningInPipeline) {
        # @(): an if-expression unrolls a 0/1-item list.
        $typeDlls = @(if (Test-Path $compiledDir -PathType Container) {
                [System.IO.Directory]::EnumerateFiles($compiledDir, 'Catzc.Types.*.dll')
            })
        if ($typeDlls.Count -gt 1) {
            $names = ($typeDlls | ForEach-Object { [System.IO.Path]::GetFileName($_) } | Sort-Object) -join ', '
            throw "More than one compiled type assembly is committed in $compiledDir ($names). The committed .compiled must contain exactly one build. On the devbox, run Clear-ModuleTypeCache and commit the single remaining build."
        }
        if (-not $Silent) {
            Write-Message 'type cache: skipped — running in a pipeline (CI makes no source-control changes).'
        }
        return
    }

    Assert-PathExist $ModulesRoot -PathType Container

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

    Import-InternalModule Types
    $combinedHash = (Get-CombinedTypeHash $ModulesRoot).CombinedHash
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
            [System.IO.File]::Delete([System.IO.Path]::ChangeExtension($dll, 'json'))
            $removed++
            if (-not $Silent) {
                Write-Message "Removed stale type assembly: $dll"
            }
        }
        catch {
            $failed.Add([pscustomobject]@{ Path = $dll; Reason = $_.Exception.Message })
        }
    }

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
            [System.IO.File]::Delete([System.IO.Path]::ChangeExtension($entry.Path, 'json'))
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
        throw "Could not remove superseded type assemblies from ${compiledDir}:$($details -join '; '). Types load from a per-user shadow copy, so no catzc session holds .compiled; close what does, then re-run Clear-ModuleTypeCache."
    }
}
