<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-types-system/Clear-ModuleTypeCache.ps1.md"
  header: "generated"
---
#>

function Clear-ModuleTypeCache {
    param(
        [string] $ModulesRoot = (Get-CatzcModulesRoot),

        [switch] $DryRun,

        [switch] $Silent
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

    # A pipeline deletes nothing, so two builds there means two were committed, and trunk may carry only one.
    if (Test-IsRunningInPipeline) {
        # @(): an if-expression unrolls a 0/1-item list.
        $typeDlls = @(if (Test-Path $compiledDir -PathType Container) {
                [Catzc.Base.Folders.PathSet]::new((Get-Config -Config folder-walk)).AddPattern($compiledDir, 'Catzc.Types.*.dll', 1).ToArray()
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

    # The build to keep is named by the loader's own combined hash, so the janitor can never disagree with the loader.
    Import-InternalModule Types
    $combinedHash = (Get-CombinedTypeHash $ModulesRoot).CombinedHash
    $keep = if ($combinedHash) {
        "Catzc.Types.$combinedHash.dll"
    }
    else {
        $null
    }

    foreach ($dll in [Catzc.Base.Folders.PathSet]::new((Get-Config -Config folder-walk)).AddPattern($compiledDir, '*.dll', 1).ToArray()) {
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

    if (-not $Silent) {
        if ($ret.Count -eq 0) {
            Write-Message 'type cache: already clean — no superseded builds to remove.'
        }
        else {
            Write-Message "type cache: removed $removed of $($ret.Count) superseded build(s)."
        }
    }

    # A build another process still holds is that process's own until it exits: a fact to name, never an error or a wait.
    if ($failed.Count -and -not $Silent) {
        # Best-effort: the holder only enriches the message, so a lookup failure leaves the delete error alone.
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
        Write-Message "type cache: $($failed.Count) superseded build(s) still open in ${compiledDir}: $($details -join '; '); each goes when its holder exits." -ForegroundColor Yellow
    }
}
