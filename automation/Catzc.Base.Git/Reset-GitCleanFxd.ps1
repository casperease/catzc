<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Git/Reset-GitCleanFxd.ps1
    name: reset-git-clean-fxd
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Git
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    page: docs/references/automation/catzc-base-git/Reset-GitCleanFxd.ps1.md
    test: automation/Catzc.Base.Git/tests/Reset-GitCleanFxd.Tests.ps1
    cites:
      - ADR-AUTO-DRYRUN#2
      - ADR-REPO-OUTDIR#10
---
#>

function Reset-GitCleanFxd {
    [CmdletBinding()]
    param(
        [switch] $DryRun
    )

    Assert-Command git

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
