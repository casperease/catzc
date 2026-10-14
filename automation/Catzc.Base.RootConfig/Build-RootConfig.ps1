<#
.SYNOPSIS
    Materialises every opted-in managed root file from its in-repo source of truth — the writer behind the
    "root configs are managed" contract.
.DESCRIPTION
    Reads the root-config registry (configs/rootconfig.yml, via Get-Config -Config rootconfig), filters it to
    the opted-in entries (Get-RootConfigTargets), and reproduces each target from its single source of truth:
    a `source` entry copies the authored file out (prepending the `comment`-style generated-file header), a
    `generator` entry renders the content through Invoke-RootConfigGenerator (e.g. New-Importer for
    importer.ps1), and a `copyAsLink` source entry skips content entirely — the target is materialised as a
    filesystem link to the source (Set-FileLink), so the root file IS the source. Whether the target is
    gitignored (committed false) or tracked (committed true) changes nothing here — content is produced the
    same way; `committed` only governs git membership, asserted by the integrity test.

    A generator renders either one file (the entry's target) or, for a wildcard target such as
    go/tests/*/go.mod, one { Target; Content } record per file (Get-RootConfigRenderedFile): each file is
    written on its own and reported in its own result row, under its own path.

    Idempotent and fast by construction, so the importer runs it on every load (see importer.ps1): the write
    goes through Write-FileIfChanged (canonical UTF-8/LF output, EOL-insensitive compare, write-on-change), so
    a clean tree is a true no-op. See [ADR-REPO-ROOTCFG](/docs/adr/repository/generated-root-configs.md).

    The managed root files are materialised from the source tree, so in build mode
    ([ADR-DSGN-RUNMODE](/docs/adr/design/run-modes.md)) this is a
    no-op that reports why and returns nothing — a skip, not a throw, because the importer's janitor tail calls
    it on every load and a janitor never breaks the load.
.PARAMETER Target
    Materialise only this repo-relative path: the entry whose target equals it (e.g.
    'PSScriptAnalyzerSettings.psd1', or a wildcard entry's own pattern for all its files), or the one file of a
    wildcard entry it matches (e.g. 'go/tests/widget/go.mod'). Throws when it selects no opted-in entry, or no file
    of the wildcard entry it matches. Default: every opted-in entry.
.PARAMETER DryRun
    Report what would change without writing any file. The composed content is the same either way; -DryRun
    only skips the write. See [ADR-AUTO-DRYRUN](/docs/adr/automation/powershell/prefer-dryrun-over-shouldprocess.md).
.PARAMETER Silent
    The per-file status lines are verbose-level — shown only when this function is run with -Verbose. -Silent
    suppresses them entirely, even under -Verbose (used by the importer tail so a session with -Verbose on
    does not chatter during import).
.PARAMETER PassThru
    Return one result object per managed file ({ Target, Source, Generator, Committed, Path, Changed, DryRun })
    instead of the paths. A wildcard entry reports one object per rendered file, each with that file's Target.
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

    if ((Get-CatzcRunMode) -eq 'build') {
        if (-not $Silent) {
            Write-Message 'root configs: skipped — this session runs a built Catzc package; managed root files are materialised from the source tree (importer.ps1).'
        }
        return
    }

    $config = Get-Config -Config rootconfig

    $entries = @(Get-RootConfigTargets -Config $config)
    if ($Target) {
        # An entry is selected by its own target, or — for a wildcard entry — by one path its pattern matches.
        $entries = @($entries | Where-Object {
                $_.target -eq $Target -or (
                    [System.Management.Automation.WildcardPattern]::ContainsWildcardCharacters($_.target) -and
                    $Target -clike $_.target)
            })
        if ($entries.Count -eq 0) {
            throw "No opted-in root-config entry targets '$Target'. See configs/rootconfig.yml."
        }
    }

    # The per-file status lines are verbose-level detail — shown only when this function is run with -Verbose.
    $emitVerbose = $VerbosePreference -ne [System.Management.Automation.ActionPreference]::SilentlyContinue

    $ret = foreach ($entry in $entries) {
        if ($entry.copyAsLink) {
            # A link entry skips content composition entirely: the target IS the source, verified or
            # (re)created as a filesystem link by the one mechanism owner (Set-FileLink, Catzc.Base.Files).
            $sourcePath = Resolve-RepoPath $entry.source
            $files = @([pscustomobject]@{ Target = $entry.target; Content = $null; From = "$($entry.source) (link)" })
        }
        elseif ($entry.source) {
            # Content from an authored source file, with the generated-file header.
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
            $files = @([pscustomobject]@{ Target = $entry.target; Content = $content; From = $entry.source })
        }
        else {
            # A generator's rendered output (which owns its whole content, header included): one file, or one
            # record per file of a wildcard target.
            $files = @(foreach ($file in @(Get-RootConfigRenderedFile -Entry $entry)) {
                    [pscustomobject]@{ Target = $file.Target; Content = $file.Content; From = "$($entry.generator) (generator)" }
                })
        }

        # -Target naming one file of a wildcard entry writes only that file.
        if ($Target -and $Target -ne $entry.target) {
            $files = @($files | Where-Object { $_.Target -eq $Target })
            if ($files.Count -eq 0) {
                throw "Root-config entry '$($entry.target)' renders no file '$Target'. See configs/rootconfig.yml."
            }
        }

        foreach ($file in $files) {
            $targetPath = Resolve-RepoPath $file.Target

            if ($entry.copyAsLink) {
                $changed = Set-FileLink -Path $targetPath -Target $sourcePath -DryRun:$DryRun
            }
            else {
                # A target that is currently a LINK is stale regardless of content equality: a comment:none entry
                # flipped back from copyAsLink composes bytes identical to its source, which the compare would read
                # through the link and call current — leaving the link in place while the registry says copy.
                $item = Get-Item -LiteralPath $targetPath -Force -ErrorAction Ignore
                $targetIsLink = [bool] ($item -and $item.LinkType)
                if ($targetIsLink -and -not $DryRun) {
                    [System.IO.File]::Delete($targetPath)
                }

                # Canonicalise, EOL-insensitively compare, and write-on-change via the one shared primitive
                # (Write-FileIfChanged, Catzc.Base.Files).
                $changed = Write-FileIfChanged -Path $targetPath -Content $file.Content -DryRun:$DryRun
                if ($targetIsLink) {
                    $changed = $true
                }
            }

            if (-not $Silent) {
                $verb = if ($entry.copyAsLink) {
                    if ($changed -and $DryRun) {
                        'would link'
                    }
                    elseif ($changed) {
                        'linked'
                    }
                    else {
                        'link current'
                    }
                }
                elseif ($DryRun) {
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
                Write-Message "$($file.Target) $verb — from $($file.From)" -Verbose:$emitVerbose
            }

            [pscustomobject]@{
                Target     = $file.Target
                Source     = $entry.source
                Generator  = $entry.generator
                Committed  = [bool] $entry.committed
                CopyAsLink = [bool] $entry.copyAsLink
                Path       = $targetPath
                Changed    = [bool] $changed
                DryRun     = [bool] $DryRun
            }
        }
    }
    $ret = @($ret)

    if ($PassThru) {
        return $ret
    }

    [string[]] @($ret.Path)
}
