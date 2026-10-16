<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.TypesSystem/Clear-ModuleTypeCache.ps1
    name: clear-module-type-cache
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.TypesSystem
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    page: docs/references/automation/catzc-base-typessystem/Clear-ModuleTypeCache.ps1.md
    test: automation/Catzc.Base.TypesSystem/tests/Clear-ModuleTypeCache.Tests.ps1
    cites:
      - ADR-AUTO-CACHE#8
      - ADR-DSGN-RUNMODE
  config:
    synopsis: Removes superseded compiled C# type assemblies, keeping the current combined build.
    description: |-
      The single combined assembly in automation/.compiled/ (Catzc.Types.<combinedHash8>.dll) is committed to
      source control (a deterministic, hash-keyed prebuild — like .vendor), so a fresh checkout and CI load it
      without invoking Roslyn. This tidies the cache: it keeps the one assembly whose name matches the current
      combined hash of every module's types/*.cs and deletes the rest — older builds left over from a previous
      version of a type. The current build is never deleted, so the committed file stays put on every platform.

      Nothing in catzc holds a .compiled DLL open: every load goes through a per-user shadow copy
      (Import-TypesAssembly, [ADR-AUTO-CACHE#8](/docs/adr/automation/caching.md#rule-adr-auto-cache8)), so
      a superseded build is always expected to delete. A delete that
      still fails means something outside catzc holds the file (an antivirus scan, an indexer, a session started
      before shadow loading). The janitor removes every deletable build first, then throws one error naming each
      file it could not remove and, on Windows, the processes holding it (Get-FileLockingProcess) — a silent skip
      is how a stale build reaches a commit. The importer catches that error into one red line, so the load
      still completes.

      Makes no source-control changes in a pipeline (Test-IsRunningInPipeline): CI must not modify committed files,
      so the delete pass is a devbox concern — run locally so the tidied .compiled is what gets committed. The
      importer invokes this automatically on a devbox. In a pipeline it enforces the one invariant instead:
      .compiled must hold exactly one Catzc.Types.*.dll, and a second one means two builds were COMMITTED — a hard
      throw, the gate that stops a stale build reaching trunk.

      The combined hash comes from the ONE shared implementation (Get-CombinedTypeHash in the .internal shared
      module) that the loader (Import-CSharpTypes) also calls, so the janitor cannot drift from the loader and plan
      the live build for deletion. A test against the real repo still guards that the live build is never planned.
      A devbox janitor only: in build mode
      ([ADR-DSGN-RUNMODE](/docs/adr/design/run-modes.md)) the default code root is an installed Catzc
      package, whose .compiled holds the one assembly the build produced and is never a cache to tidy, so the
      call is a no-op that reports why. An explicit -AutomationRoot other than the loaded code root is still
      cleaned in either mode.
    parameters:
      AutomationRoot: |-
        Path to the automation directory (the parent of .compiled/). Defaults to the loaded code root
        (Get-CatzcModulesRoot).
      DryRun: Return the list of cache files that would be deleted, without deleting anything.
      Silent: |-
        Suppress the per-file and end-state 'type cache: …' messages. The importer passes this on its automatic
        janitor call so a normal load stays quiet (importer.ps1 -Verbose turns it back on); a manual
        Clear-ModuleTypeCache omits it, so a hand-run always reports the state it left. A failed delete still throws.
      StopLockingProcesses: |-
        The kill switch. When a superseded build will not delete, stop every process holding it (Stop-FileLockingProcess:
        never this session or an ancestor of it, each stop announced even under -Silent), then retry the delete over a
        short bounded window (Windows releases an exited process's mapped image a moment after the exit).
        A build still held afterwards — by this session itself, say — is named in the error as usual. Off by default:
        stopping a process can lose its unsaved work, so it is asked for, never assumed.
    examples:
      - Clear-ModuleTypeCache
      - 'Clear-ModuleTypeCache -StopLockingProcesses   # stop the sessions holding stale builds, then delete them'
      - Clear-ModuleTypeCache -DryRun
---
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
        throw "Could not remove superseded type assemblies from automation/.compiled: $($details -join '; '). Types load from a per-user shadow copy, so no catzc session holds .compiled; close what does, then re-run Clear-ModuleTypeCache."
    }
}
