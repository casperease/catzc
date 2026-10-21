<#
---
catzc:
  immutable:
    with_body_sha: "494f82ab9d86"
  edges:
    test: pwsh/Catzc.Base.RootConfig/tests/Build-RootConfig.Tests.ps1
    docs: "[Build-RootConfig.ps1.md](docs/references/pwsh/catzc-base-root-config/Build-RootConfig.ps1.md)"
    cites:
      - ADR-AUTO-DRYRUN
      - ADR-DSGN-RUNMODE
      - ADR-REPO-ROOTCFG
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

    $entries = @(Get-RootConfigTargets -Config $config -FollowMix)
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

    # A whole run is skipped when nothing that feeds or receives it changed since the last run on this machine (the memo under out/cache).
    $memoPath = Join-Path (Get-OutputRoot) 'cache/build-rootconfig.json'
    $stampBefore = $null
    if (-not $Target -and -not $DryRun -and -not $PassThru) {
        $stampBefore = Get-RootConfigInputStamp -Entries $entries
        $memo = $null
        if ([System.IO.File]::Exists($memoPath)) {
            try {
                $memo = [System.IO.File]::ReadAllText($memoPath) | ConvertFrom-Json -AsHashtable
            }
            catch {
                Write-Verbose "Ignoring the unreadable root-config memo '$memoPath': $($_.Exception.Message)"
            }
        }
        if ($memo -is [hashtable] -and $memo['stamp'] -ceq $stampBefore) {
            if (-not $Silent) {
                Write-Message 'root configs: current since the last run' -Verbose:$emitVerbose
            }
            return
        }
    }

    $ret = foreach ($entry in $entries) {
        if ($entry.source) {
            # Content from an authored source file, with the generated-file head naming the source.
            $content = Get-RootConfigCopyContent -Entry $entry -SourcePath (Resolve-RepoPath $entry.source)
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

            $item = Get-Item -LiteralPath $targetPath -Force -ErrorAction Ignore
            $targetIsLink = [bool] ($item -and $item.LinkType)
            if ($targetIsLink -and -not $DryRun) {
                [System.IO.File]::Delete($targetPath)
            }

            $changed = Write-FileIfChanged -Path $targetPath -Content $file.Content -DryRun:$DryRun
            if ($targetIsLink) {
                $changed = $true
            }

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
                Write-Message "$($file.Target) $verb — from $($file.From)" -Verbose:$emitVerbose
            }

            [pscustomobject]@{
                Target    = $file.Target
                Source    = $entry.source
                Generator = $entry.generator
                Committed = [bool] $entry.committed
                Path      = $targetPath
                Changed   = [bool] $changed
                DryRun    = [bool] $DryRun
            }
        }
    }
    $ret = @($ret)

    if ($null -ne $stampBefore) {
        # The targets just written are part of the stamp, so it is taken again and remembered for the next run.
        $folder = [System.IO.Path]::GetDirectoryName($memoPath)
        [System.IO.Directory]::CreateDirectory($folder) | Out-Null
        $json = [ordered]@{ stamp = (Get-RootConfigInputStamp -Entries $entries) } | ConvertTo-Json -Compress
        [System.IO.File]::WriteAllText($memoPath, $json)
    }

    if ($PassThru) {
        return $ret
    }

    [string[]] @($ret.Path)
}
