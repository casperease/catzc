<#
.SYNOPSIS
    Materialises every opted-in managed root file from its in-repo source of truth — the writer behind the
    "root configs are managed" contract.
.DESCRIPTION
    Reads the root-config registry (configs/rootconfig.yml, via Get-Config -Config rootconfig), filters it to
    the opted-in entries (Get-RootConfigTargets), and reproduces each target from its single source of truth:
    a `source` entry copies the authored file out (prepending the `comment`-style generated-file header), a
    `generator` entry renders the content through Invoke-RootConfigGenerator (e.g. New-Importer for
    importer.ps1). Whether the target is gitignored (committed false) or tracked (committed true) changes
    nothing here — content is produced the same way; `committed` only governs git membership, asserted by the
    integrity test.

    Idempotent and fast by construction, so the importer runs it on every load (see importer.ps1): the write
    goes through Write-FileIfChanged (canonical UTF-8/LF output, EOL-insensitive compare, write-on-change), so
    a clean tree is a true no-op. See docs/adr/repository/generated-root-configs.md.
.PARAMETER Target
    Materialise only the entry whose target equals this repo-relative path (e.g. 'PSScriptAnalyzerSettings.psd1').
    Throws when it matches no opted-in entry. Default: every opted-in entry.
.PARAMETER DryRun
    Report what would change without writing any file. The composed content is the same either way; -DryRun
    only skips the write. See docs/adr/automation/prefer-dryrun-over-shouldprocess.md.
.PARAMETER Silent
    The per-file status lines are verbose-level — shown only when this function is run with -Verbose. -Silent
    suppresses them entirely, even under -Verbose (used by the importer tail so a session with -Verbose on
    does not chatter during import).
.PARAMETER PassThru
    Return one result object per managed file ({ Target, Source, Generator, Committed, Path, Changed, DryRun })
    instead of the paths.
.OUTPUTS
    [string[]] The paths to the managed files (with -PassThru, one result object per file instead).
.EXAMPLE
    Build-RootConfig
    Reproduces every opted-in managed root file from its source of truth.
.EXAMPLE
    Build-RootConfig -DryRun -PassThru
    Reports which managed root files are stale without writing them.
.EXAMPLE
    Build-RootConfig 'PSScriptAnalyzerSettings.psd1'
    Reproduces only that managed file.
#>
function Build-RootConfig {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Position = 0)]
        [string] $Target,

        [switch] $DryRun,

        [switch] $Silent,

        [switch] $PassThru
    )

    $config = Get-Config -Config rootconfig

    $entries = @(Get-RootConfigTargets -Config $config)
    if ($Target) {
        $entries = @($entries | Where-Object { $_.target -eq $Target })
        if ($entries.Count -eq 0) {
            throw "No opted-in root-config entry targets '$Target'. See configs/rootconfig.yml."
        }
    }

    # The per-file status lines are verbose-level detail — shown only when this function is run with -Verbose.
    $emitVerbose = $VerbosePreference -ne [System.Management.Automation.ActionPreference]::SilentlyContinue

    $ret = foreach ($entry in $entries) {
        # Content from the one source of truth: an authored source file (with the generated-file header) or a
        # generator's rendered output (which owns its whole content, header included).
        if ($entry.source) {
            $sourcePath = Resolve-RepoPath $entry.source
            Assert-PathExist $sourcePath

            # Normalize the source to LF so composition is line-ending agnostic (the write itself canonicalises).
            $content = [System.IO.File]::ReadAllText($sourcePath) -replace "`r`n", "`n" -replace "`r", "`n"
            if ($entry.comment -eq 'hash') {
                $header = @(
                    '# GENERATED FILE — do not edit. Single source of truth:'
                    "#   $($entry.source)"
                    '# Regenerated on import by Build-RootConfig; edit the source, not this copy.'
                    ''
                ) -join "`n"
                $content = $header + $content
            }
            $from = $entry.source
        }
        else {
            $content = Invoke-RootConfigGenerator -Name $entry.generator
            $from = "$($entry.generator) (generator)"
        }

        $targetPath = Resolve-RepoPath $entry.target
        # Canonicalise, EOL-insensitively compare, and write-on-change via the one shared primitive
        # (Write-FileIfChanged, Catzc.Base.Files).
        $changed = Write-FileIfChanged -Path $targetPath -Content $content -DryRun:$DryRun

        if (-not $Silent) {
            $verb = if ($DryRun) {
                if ($changed) {
                    'would regenerate'
                }
                else {
                    'already current'
                }
            }
            else {
                if ($changed) {
                    'regenerated'
                }
                else {
                    'unchanged'
                }
            }
            Write-Message "$($entry.target) $verb — from $from" -Verbose:$emitVerbose
        }

        [pscustomobject]@{
            Target    = $entry.target
            Source    = $entry.source
            Generator = $entry.generator
            Committed = [bool] $entry.committed
            Path      = $targetPath
            Changed   = [bool] $changed
            DryRun    = [bool] $DryRun
        }
    }
    $ret = @($ret)

    if ($PassThru) {
        return $ret
    }

    [string[]] @($ret.Path)
}
