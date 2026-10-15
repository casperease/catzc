# catzc:
#   path: automation/Catzc.Base.Git/Reset-GitCleanFxd.ps1
#   module: Catzc.Base.Git
#   visibility: public

<#
.SYNOPSIS
    Performs a whitelisted `git clean -fxd`: deletes only the untracked files the automation itself
    generates and owns, and leaves everything else in place, reported.
.DESCRIPTION
    Unlike a raw clean, untracked work not on the whitelist survives and is reported, never deleted.
    [ADR-REPO-OUTDIR#10](/docs/adr/repository/dedicated-output-directory.md#rule-adr-repo-outdir10)
    [comment:1](/docs/references/automation/catzc-base-git/Reset-GitCleanFxd.ps1.md#comment1)
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
# The dry run is a plain -DryRun switch returning the plan, not ShouldProcess/-WhatIf.
# [ADR-AUTO-DRYRUN#2](/docs/adr/automation/dry-run.md#rule-adr-auto-dryrun2)
# [comment:2](/docs/references/automation/catzc-base-git/Reset-GitCleanFxd.ps1.md#comment2)
function Reset-GitCleanFxd {
    [CmdletBinding()]
    param(
        [switch] $DryRun
    )

    Assert-Command git

    # Asking git's own dry run means ignore semantics are never re-implemented here.
    # [comment:3](/docs/references/automation/catzc-base-git/Reset-GitCleanFxd.ps1.md#comment3)
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

    # A '!'-prefixed glob is an exclusion: it wins over every inclusion, gitignore-style.
    $globs = Get-AutoControlledGlobs
    $includes = @($globs | Where-Object { -not $_.StartsWith('!') })
    $excludes = @($globs | Where-Object { $_.StartsWith('!') } | ForEach-Object { $_.Substring(1) })
    $remove = [System.Collections.Generic.List[string]]::new()
    $keep = [System.Collections.Generic.List[string]]::new()
    foreach ($candidate in @($candidates)) {
        $isControlled = $false
        foreach ($glob in $includes) {
            if ($candidate -like $glob) {
                $isControlled = $true
                break
            }
        }
        foreach ($glob in $excludes) {
            if ($candidate -like $glob) {
                $isControlled = $false
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
