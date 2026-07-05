<#
.SYNOPSIS
    Removes superseded compiled C# type assemblies, keeping the current combined build.
.DESCRIPTION
    The single combined assembly in automation/.compiled/ (Catzc.Types.<combinedHash8>.dll) is committed to
    source control (a deterministic, hash-keyed prebuild — like .vendor), so a fresh checkout and CI load it
    without invoking Roslyn. This tidies the cache: it keeps the one assembly whose name matches the current
    combined hash of every module's types/*.cs and deletes the rest — older builds left over from a previous
    version of a type. The current build is never deleted, so the committed file stays put on every platform.

    Best-effort and cross-platform BY DEFAULT: a loaded assembly is locked on Windows, so it is skipped via
    Test-FileIsLocked; the delete is also wrapped so any other failure (permissions, a concurrent
    delete/lock, or an advisory-lock platform like Linux/macOS where an open file is not reported locked)
    skips that file rather than throwing. Cleanup never breaks the caller (the importer invokes it). (Superseded
    DLLs are not loaded, so they normally delete cleanly.)

    Opt-in fail-fast with -ThrowOnNonReleasedFromClrTypesDll: on Windows a superseded ('wrong') build that is
    still loaded — the CLR has not released the file, so it cannot be deleted until the process exits — becomes
    a loud "restart PowerShell" red message instead of a silent skip, AFTER the deletable stale builds are removed.
    It is off by default (so the importer's automatic cleanup never breaks) and a no-op on Unix, where deleting an
    open file succeeds. This is the decisive, manual clean when a stale committed assembly must actually go.

    Makes no source-control changes in a pipeline (Test-IsRunningInPipeline): CI must not modify committed files,
    so the delete/skip pass is a devbox concern — run locally so the tidied .compiled is what gets committed. The
    importer invokes this automatically on a devbox.

    One invariant is enforced in both contexts: .compiled must hold exactly one Catzc.Types.*.dll. In a pipeline,
    where nothing is deleted (CI makes no source-control changes), a second coexisting DLL means two builds were
    COMMITTED — a hard throw, the gate that stops a stale build reaching trunk. On a devbox the janitor first
    deletes the superseded build, then warns 'Two dll exists in .compiled - is a console session locking it?'
    (yellow, ignoring -Silent — a locked/stale DLL is actionable, not routine chatter) ONLY when a build actually
    survives the delete — i.e. another session is holding the old DLL so it could not be removed. The warning is
    never emitted when the stale build was freely deletable and just got cleaned up.

    The combined hash comes from the ONE shared implementation (Get-CombinedTypeHash in the .internal shared
    module) that the loader (Import-CSharpTypes) also calls, so the janitor cannot drift from the loader and plan
    the live build for deletion. A test against the real repo still guards that the live build is never planned.
.PARAMETER AutomationRoot
    Path to the automation directory (the parent of .compiled/). Defaults to $env:RepositoryRoot/automation.
.PARAMETER DryRun
    Return the list of cache files that would be deleted, without deleting anything.
.PARAMETER ThrowOnNonReleasedFromClrTypesDll
    Windows-only, opt-in fail-fast. When a superseded assembly is still loaded — the CLR has not released the
    file, so Windows cannot delete it — throw instead of silently skipping (after removing every deletable
    stale build first). The message names the file and says to restart PowerShell, which releases the CLR's
    handle. Off by default so the importer's automatic cleanup never breaks; a no-op on Unix.
.PARAMETER Silent
    Suppress all console output — the per-file and end-state 'type cache: …' messages. The importer passes
    this on its automatic janitor call so a normal load stays quiet (importer.ps1 -NonSilentClear turns it
    back on); a manual Clear-ModuleTypeCache omits it, so a hand-run always reports the state it left.
.EXAMPLE
    Clear-ModuleTypeCache
.EXAMPLE
    Clear-ModuleTypeCache -DryRun
.EXAMPLE
    Clear-ModuleTypeCache -ThrowOnNonReleasedFromClrTypesDll   # fail loudly if a stale build is still loaded
#>
function Clear-ModuleTypeCache {
    param(
        [string] $AutomationRoot = (Join-Path $env:RepositoryRoot 'automation'),

        [switch] $DryRun,

        [switch] $ThrowOnNonReleasedFromClrTypesDll,

        [switch] $Silent
    )

    $compiledDir = Join-Path $AutomationRoot '.compiled'

    # More than one Catzc.Types.*.dll means a superseded build is sitting next to the current one, but the two
    # contexts resolve it differently, so the check is NOT hoisted above the delete pass:
    #   - pipeline: nothing is deleted (CI makes no source-control changes), so >1 means two builds were COMMITTED
    #     — a hard throw, checked before returning, so trunk cannot carry more than one build;
    #   - devbox: the janitor deletes the superseded build below, then warns only if a build actually SURVIVES
    #     (deferred to after the delete pass) — so the warning fires when a live session is locking the old DLL,
    #     and never when the stale build was freely deletable and just got cleaned up.
    $getTypeDlls = {
        if (Test-Path $compiledDir -PathType Container) {
            @([System.IO.Directory]::EnumerateFiles($compiledDir, 'Catzc.Types.*.dll'))
        }
        else {
            @()
        }
    }

    if (Test-IsRunningInPipeline) {
        $typeDlls = & $getTypeDlls
        if ($typeDlls.Count -gt 1) {
            $names = ($typeDlls | ForEach-Object { [System.IO.Path]::GetFileName($_) } | Sort-Object) -join ', '
            throw "More than one compiled type assembly is committed in automation/.compiled ($names). The committed .compiled must contain exactly one build; a superseded DLL reached CI because a console session locked it on the devbox and it was committed instead of deleted. On the devbox, restart PowerShell to release the lock, run Clear-ModuleTypeCache, and commit the single remaining build."
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
    # The combined hash is the ONE implementation shared with the loader (Import-CSharpTypes), reached through
    # the .internal shared module — so the janitor cannot drift from the loader and plan the live build for
    # deletion. Import-InternalModule is a no-op when the importer already loaded it (the usual case).
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

    $removed = 0
    $skipped = 0
    # Superseded builds that are still LOADED (Windows lock = the CLR has not released the file). Collected so
    # the deletable stale builds are removed first, then -ThrowOnNonReleasedFromClrTypesDll can fail loudly.
    $notReleased = [System.Collections.Generic.List[string]]::new()
    foreach ($dll in $ret) {
        # A loaded assembly is locked (Windows) — classify it as in-use and skip without attempting a delete.
        if (Test-FileIsLocked $dll) {
            $skipped++
            $notReleased.Add($dll)
            if (-not $Silent) {
                Write-Message "In use (not released from the CLR), skipped: $dll"
            }
            continue
        }
        # Best-effort delete: tolerate any other failure (permissions, a concurrent delete/lock, or an
        # advisory-lock platform where an open file is not reported locked) so cleanup never breaks.
        try {
            [System.IO.File]::Delete($dll)
            $removed++
            if (-not $Silent) {
                Write-Message "Removed stale type assembly: $dll"
            }
        }
        catch {
            $skipped++
            if (-not $Silent) {
                Write-Message "Could not delete, skipped: $dll — $($_.Exception.Message)"
            }
        }
    }

    # Always report the end state (unless -Silent, which the importer's automatic call passes) — a manual run is
    # never silent about the cache it left behind.
    if (-not $Silent) {
        if ($removed -eq 0 -and $skipped -eq 0) {
            Write-Message 'type cache: already clean — no superseded builds to remove.'
        }
        else {
            Write-Message "type cache: removed $removed, skipped $skipped (in use or not deletable)."
        }
    }

    # Now that the delete pass has run, warn only if more than one build actually SURVIVES — the accurate signal
    # that a stale build could not be removed because a live console session is locking it. Deferred to here (not
    # hoisted above the delete like the pipeline check) so it never fires when the stale build was freely deletable
    # and just got cleaned up. Ignores -Silent — a leftover locked build is actionable, not routine load chatter.
    $remaining = & $getTypeDlls
    if ($remaining.Count -gt 1) {
        Write-Message -Warning 'Two dll exists in .compiled - is a console session locking it?'
    }

    # Opt-in, Windows-only fail-fast: a superseded build the CLR still holds cannot be deleted until the process
    # exits. Default is best-effort (importer must not break); the switch turns it into a restart-PowerShell
    # error, after the deletable stale builds above are already gone. Unix releases an open file on delete.
    if ($ThrowOnNonReleasedFromClrTypesDll -and $IsWindows -and $notReleased.Count -gt 0) {
        $names = ($notReleased | ForEach-Object { [System.IO.Path]::GetFileName($_) } | Sort-Object) -join ', '
        $subject = if ($notReleased.Count -eq 1) {
            'a superseded C# type assembly is'
        }
        else {
            'superseded C# type assemblies are'
        }
        throw "Cannot remove $names — $subject still loaded in this session; the CLR has not released the file. A loaded assembly cannot be deleted on Windows, so restart PowerShell to release it, then re-run Clear-ModuleTypeCache."
    }
}
