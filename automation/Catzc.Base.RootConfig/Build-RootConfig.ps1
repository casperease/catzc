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
