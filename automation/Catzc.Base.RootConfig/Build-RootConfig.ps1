<#
---
catzc:
  derived:
    path: automation/Catzc.Base.RootConfig/Build-RootConfig.ps1
    name: build-root-config
    filetype: ps1
    kind: function
    subkind: writer
    language: powershell
    track: automation
    module: Catzc.Base.RootConfig
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
    relatives:
      page: docs/references/automation/catzc-base-rootconfig/Build-RootConfig.ps1.md
      test: automation/Catzc.Base.RootConfig/tests/Build-RootConfig.Tests.ps1
    adrs:
      - ADR-AUTO-DRYRUN
      - ADR-DSGN-RUNMODE
      - ADR-REPO-ROOTCFG
  config:
    synopsis: |-
      Materialises every opted-in managed root file from its in-repo source of truth — the writer behind the
      "root configs are managed" contract.
    description: |-
      Reads the root-config registry (configs/rootconfig.yml, via Get-Config -Config rootconfig), filters it to
      the opted-in entries (Get-RootConfigTargets), and reproduces each target from its single source of truth:
      a `source` entry copies the authored file out under the generated-file head, a
      `generator` entry renders the content through Invoke-RootConfigGenerator (e.g. New-Importer for
      importer.ps1) and gets the same head, and a `copyAsLink` source entry skips content entirely — the target is materialised as a
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
    parameters:
      Target: |-
        Materialise only this repo-relative path: the entry whose target equals it (e.g.
        'PSScriptAnalyzerSettings.psd1', or a wildcard entry's own pattern for all its files), or the one file of a
        wildcard entry it matches (e.g. 'go/tests/widget/go.mod'). Throws when it selects no opted-in entry, or no file
        of the wildcard entry it matches. Default: every opted-in entry.
      DryRun: |-
        Report what would change without writing any file. The composed content is the same either way; -DryRun
        only skips the write. See [ADR-AUTO-DRYRUN](/docs/adr/automation/dry-run.md).
      Silent: |-
        The per-file status lines are verbose-level — shown only when this function is run with -Verbose. -Silent
        suppresses them entirely, even under -Verbose (used by the importer tail so a session with -Verbose on
        does not chatter during import).
      PassThru: |-
        Return one result object per managed file ({ Target, Source, Generator, Committed, Path, Changed, DryRun })
        instead of the paths. A wildcard entry reports one object per rendered file, each with that file's Target.
    outputs: '[string[]] The paths to the managed files (with -PassThru, one result object per file instead).'
    examples:
      - |-
        Build-RootConfig
        Reproduces every opted-in managed root file from its source of truth.
      - |-
        Build-RootConfig -DryRun -PassThru
        Reports which managed root files are stale without writing them.
      - |-
        Build-RootConfig 'PSScriptAnalyzerSettings.psd1'
        Reproduces only that managed file.
---
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
            $sourcePath = Resolve-RepoPath $entry.source
            $files = @([pscustomobject]@{ Target = $entry.target; Content = $null; From = "$($entry.source) (link)" })
        }
        elseif ($entry.source) {
            # Content from an authored source file, with the generated-file head naming the source.
            $sourcePath = Resolve-RepoPath $entry.source
            Assert-PathExist $sourcePath

            # Normalize the source to LF so composition is line-ending agnostic (the write itself canonicalises).
            $content = [System.IO.File]::ReadAllText($sourcePath) -replace "`r`n", "`n" -replace "`r", "`n"
            $content = Format-GeneratedFileHead -Text $content -Path $entry.target -Carrier $entry.carrier -Generator Build-RootConfig -Source $entry.source -FileKind (Get-FileKind $entry.target)
            $files = @([pscustomobject]@{ Target = $entry.target; Content = $content; From = $entry.source })
        }
        else {
            foreach ($listed in $entry.sources) {
                Assert-PathExist (Resolve-RepoPath $listed)
            }
            $files = @(foreach ($file in @(Get-RootConfigRenderedFile -Entry $entry)) {
                    $content = Format-GeneratedFileHead -Text $file.Content -Path $file.Target -Carrier $entry.carrier -Generator $entry.generator -Source $entry.sources -FileKind (Get-FileKind $file.Target)
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
                $item = Get-Item -LiteralPath $targetPath -Force -ErrorAction Ignore
                $targetIsLink = [bool] ($item -and $item.LinkType)
                if ($targetIsLink -and -not $DryRun) {
                    [System.IO.File]::Delete($targetPath)
                }

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
