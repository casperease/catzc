<#
.SYNOPSIS
    Performs a whitelisted `git clean -fxd`: deletes only the untracked files the automation itself
    generates and owns, and leaves everything else in place, reported.
.DESCRIPTION
    A raw `git clean -fxd` removes every untracked and ignored file — the regenerable generated
    artifacts AND any in-flight work that simply has not been committed yet. This wrapper keeps the
    convenience and removes the hazard: it asks git what a clean would remove (`git clean -xdn`, the
    dry-run listing), classifies every candidate against the in-memory auto-controlled whitelist
    (Get-AutoControlledGlobs — the managed root-config targets from rootconfig.yml plus the
    conventional generated classes: module manifests, README links, cspell dictionaries, out/, the IDE
    project's bin/obj, compiled-type scratch), deletes exactly the auto-controlled candidates through
    pathspec-limited `git clean -fxd -- <paths>` calls, and reports every candidate it refused to
    touch — the untracked files that are NOT ours to delete.

    Everything deleted is rematerialised by the next import (dot-source importer.ps1) except out/,
    whose content is transient by contract (dedicated-output-directory) — gone means gone, by design.
.PARAMETER DryRun
    Classify without deleting: return the plan as an object with the Remove and Keep lists.
.OUTPUTS
    [pscustomobject] With -DryRun: @{ Remove = the auto-controlled candidates that would be deleted;
    Keep = the untracked candidates left alone }. Otherwise nothing — the outcome is reported.
.EXAMPLE
    Reset-GitCleanFxd -DryRun
.EXAMPLE
    Reset-GitCleanFxd
#>
# Uses -DryRun, not ShouldProcess/-WhatIf — see docs/adr/automation/prefer-dryrun-over-shouldprocess.md#rule-adr-dryrun2.
function Reset-GitCleanFxd {
    [CmdletBinding()]
    param(
        [switch] $DryRun
    )

    Assert-Command git

    # git's own dry run is the candidate source: exactly what `git clean -fxd` would remove, no
    # re-implementation of ignore semantics.
    $listing = Invoke-Executable 'git clean -xdn' -PassThru -Silent
    $candidates = foreach ($line in ($listing.Output -split '\r?\n')) {
        if ($line -match '^Would remove (.+)$') {
            $Matches[1].TrimEnd('/')
        }
    }
    if (-not @($candidates).Count) {
        Write-Message 'Working tree is already clean — nothing a git clean -fxd would remove.'
        return
    }

    $globs = Get-AutoControlledGlobs
    $remove = [System.Collections.Generic.List[string]]::new()
    $keep = [System.Collections.Generic.List[string]]::new()
    foreach ($candidate in @($candidates)) {
        $isControlled = $false
        foreach ($glob in $globs) {
            if ($candidate -like $glob) {
                $isControlled = $true
                break
            }
        }
        if ($isControlled) {
            $remove.Add($candidate)
        }
        else {
            $keep.Add($candidate)
        }
    }

    if ($DryRun) {
        return [pscustomobject]@{
            Remove = @($remove)
            Keep   = @($keep)
        }
    }

    # Delete in pathspec-limited batches so the command line stays short and every call is logged.
    for ($index = 0; $index -lt $remove.Count; $index += 25) {
        $batch = $remove.GetRange($index, [Math]::Min(25, $remove.Count - $index))
        $quotedPaths = foreach ($item in $batch) {
            "`"$item`""
        }
        Invoke-Executable "git clean -fxd -- $($quotedPaths -join ' ')" -PassThru | Out-Null
    }

    foreach ($item in $keep) {
        Write-Message "Kept '$item' — untracked but not auto-controlled; commit or delete it yourself."
    }
    Write-Message "Removed $($remove.Count) auto-controlled entries, kept $($keep.Count). Re-run importer.ps1 to rematerialise the generated files."
}
