<#
---
catzc:
  derived:
    path: automation/Catzc.Base.RootConfig/Build-RootConfig.ps1
    kind: writer-function
    module: Catzc.Base.RootConfig
    visibility: public
    adrs:
      - ADR-AUTO-DRYRUN
      - ADR-DSGN-RUNMODE
      - ADR-REPO-ROOTCFG
---
#>

<#
.SYNOPSIS
    Materialises every opted-in managed root file from its in-repo source of truth — the writer behind the
    "root configs are managed" contract.
.DESCRIPTION
    In build mode this skips instead of throwing, because the importer calls it on every load and must not fail.
.PARAMETER Target
    A wildcard entry is selected by its own pattern, or one of its files by a path the pattern matches.
.PARAMETER DryRun
    The composed content is the same either way; -DryRun only skips the write.
.PARAMETER Silent
    -Silent beats -Verbose, so the importer tail does not chatter during import in a verbose session.
.PARAMETER PassThru
    A wildcard entry reports one object per rendered file, each carrying that file's own Target.
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
            # A link entry skips composition: the target IS the source, so there is no content to compare or write.
            # [comment:6](/docs/references/automation/catzc-base-rootconfig/Build-RootConfig.ps1.md#comment6)
            $sourcePath = Resolve-RepoPath $entry.source
            $files = @([pscustomobject]@{ Target = $entry.target; Content = $null; From = "$($entry.source) (link)" })
        }
        elseif ($entry.source) {
            # Content from an authored source file, with the generated-file head naming the source.
            $sourcePath = Resolve-RepoPath $entry.source
            Assert-PathExist $sourcePath

            # Normalize the source to LF so composition is line-ending agnostic (the write itself canonicalises).
            $content = [System.IO.File]::ReadAllText($sourcePath) -replace "`r`n", "`n" -replace "`r", "`n"
            $content = Format-GeneratedFileHead -Text $content -Path $entry.target -Carrier $entry.carrier -Source $entry.source -Tracked:([bool] $entry.committed)
            $files = @([pscustomobject]@{ Target = $entry.target; Content = $content; From = $entry.source })
        }
        else {
            # A generator owns its whole content below the head and returns one file or one per wildcard match.
            # [comment:7](/docs/references/automation/catzc-base-rootconfig/Build-RootConfig.ps1.md#comment7)
            foreach ($listed in $entry.sources) {
                Assert-PathExist (Resolve-RepoPath $listed)
            }
            $files = @(foreach ($file in @(Get-RootConfigRenderedFile -Entry $entry)) {
                    $content = Format-GeneratedFileHead -Text $file.Content -Path $file.Target -Carrier $entry.carrier -Generator $entry.generator -Source $entry.sources -Tracked:([bool] $entry.committed)
                    [pscustomobject]@{ Target = $file.Target; Content = $content; From = "$($entry.generator) (generator)" }
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
                # A link target is stale despite equal bytes: the compare reads through the link and calls it current.
                # [comment:8](/docs/references/automation/catzc-base-rootconfig/Build-RootConfig.ps1.md#comment8)
                $item = Get-Item -LiteralPath $targetPath -Force -ErrorAction Ignore
                $targetIsLink = [bool] ($item -and $item.LinkType)
                if ($targetIsLink -and -not $DryRun) {
                    [System.IO.File]::Delete($targetPath)
                }

                # Writing only on change keeps a clean tree a true no-op, so the importer can run this on every load.
                # [comment:9](/docs/references/automation/catzc-base-rootconfig/Build-RootConfig.ps1.md#comment9)
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
