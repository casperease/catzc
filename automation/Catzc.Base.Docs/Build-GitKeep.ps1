<#
.SYNOPSIS
    Reproduces every .gitkeep from the one generic authored source — the writer behind the ".gitkeep files
    are generated, README-backed" contract.
.DESCRIPTION
    The folder is the registration: every .gitkeep in the repository (found by a filesystem walk that skips
    `.git` and the vendored modules) is a managed copy of assets/gitkeep — a generic text saying the file
    keeps its folder tracked and that the folder's story lives in its README.md. That pointer is honest
    because an integrity test requires every .gitkeep folder to be a readme-mapped target (a docs/references
    article Build-Readme copies in), so adding a .gitkeep anywhere demands its reference article — the gap
    finder for the reference docs.

    Idempotent and fast by construction, so the importer runs it on every load beside Build-Readme: writes go
    through Write-FileIfChanged (canonical output, EOL-insensitive compare, write only on drift). .gitkeep
    files are committed — tracking the folder is their whole job — so a source change lands as a reviewable
    diff across every location. See docs/adr/repository/generated-readmes.md.
.PARAMETER DryRun
    Report what would change without writing any file. See
    docs/adr/automation/powershell/prefer-dryrun-over-shouldprocess.md.
.PARAMETER Silent
    The per-file status lines are verbose-level — -Silent suppresses them entirely, even under -Verbose
    (used by the importer tail).
.PARAMETER PassThru
    Return one result object per .gitkeep ({ Path, Changed, DryRun }) instead of the paths.
.OUTPUTS
    [string[]] The repo-relative paths of the managed .gitkeep files (with -PassThru, one result object per
    file instead).
.EXAMPLE
    Build-GitKeep
    Reproduces every .gitkeep from the authored source.
.EXAMPLE
    Build-GitKeep -DryRun -PassThru
    Reports which .gitkeep files are stale without writing them.
#>
function Build-GitKeep {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [switch] $DryRun,

        [switch] $Silent,

        [switch] $PassThru
    )

    $sourcePath = Join-Path $PSScriptRoot 'assets/gitkeep'
    Assert-PathExist $sourcePath
    $content = [System.IO.File]::ReadAllText($sourcePath)

    $repositoryRoot = Get-RepositoryRoot

    # Walk the tree for .gitkeep files, skipping git's own store and the vendored modules (not ours to
    # manage). The output root's own .gitkeep is checked, but its contents — transient artifacts that may
    # carry fixture copies — are never descended into. [System.IO] over cmdlets on this hot path
    # (ADR-AUTO-TEST:18); sorted for deterministic output.
    $outputRoot = [System.IO.Path]::Combine($repositoryRoot, 'out')
    $found = [System.Collections.Generic.List[string]]::new()
    $stack = [System.Collections.Generic.Stack[string]]::new()
    $stack.Push($repositoryRoot)
    while ($stack.Count -gt 0) {
        $directory = $stack.Pop()
        if ($directory -ne $outputRoot) {
            foreach ($subdirectory in [System.IO.Directory]::EnumerateDirectories($directory)) {
                $leaf = [System.IO.Path]::GetFileName($subdirectory)
                if ($leaf -in '.git', '.vendor') {
                    continue
                }
                $stack.Push($subdirectory)
            }
        }
        $keepPath = [System.IO.Path]::Combine($directory, '.gitkeep')
        if ([System.IO.File]::Exists($keepPath)) {
            $found.Add((ConvertTo-RepoRelativePath $keepPath))
        }
    }
    $found.Sort([System.StringComparer]::Ordinal)

    $emitVerbose = $VerbosePreference -ne [System.Management.Automation.ActionPreference]::SilentlyContinue

    $ret = foreach ($keep in $found) {
        $changed = Write-FileIfChanged (Resolve-RepoPath $keep) $content -DryRun:$DryRun

        if ($changed -and -not $Silent) {
            $verb = if ($DryRun) {
                'would write'
            }
            else {
                'wrote'
            }
            Write-Message "$verb $keep"
        }
        elseif ($emitVerbose -and -not $Silent) {
            Write-Verbose "unchanged: $keep"
        }

        if ($PassThru) {
            [pscustomobject]@{ Path = $keep; Changed = $changed; DryRun = [bool]$DryRun }
        }
        else {
            $keep
        }
    }

    $ret
}
