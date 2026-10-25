<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-root-config/Build-RootConfig.ps1.md"
  header: "generated"
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

    # Only a whole run may skip on the shared writer memo; a targeted, dry or passthru run always renders.
    $whole = -not $Target -and -not $DryRun -and -not $PassThru
    if ($whole) {
        $row = @(Get-GeneratedWriterDue | Where-Object Name -ceq 'Build-RootConfig')
        if ($row.Count -eq 1 -and -not $row[0].Due) {
            if (-not $Silent) {
                Write-Message 'root configs: current since the last run' -Verbose:$emitVerbose
            }
            return
        }
    }

    $ret = foreach ($entry in $entries) {
        if ($entry.source) {
            # Content from an authored source file, under the generated-file head.
            $content = Get-RootConfigCopyContent -Entry $entry -SourcePath (Resolve-RepoPath $entry.source)
            $files = @([pscustomobject]@{ Target = $entry.target; Content = $content; From = $entry.source })
        }
        else {
            # A generator owns its whole output below the head: one file, or one record per wildcard match.
            foreach ($listed in $entry.sources) {
                Assert-PathExist (Resolve-RepoPath $listed)
            }
            $files = @(foreach ($file in @(Get-RootConfigRenderedFile -Entry $entry)) {
                    $content = Format-GeneratedFileHead -Text $file.Content -Path $file.Target -Carrier $entry.carrier
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

            # A link target is always stale: writing through it would change the file it points at.
            $item = Get-Item -LiteralPath $targetPath -Force -ErrorAction Ignore
            $targetIsLink = [bool] ($item -and $item.LinkType)
            if ($targetIsLink -and -not $DryRun) {
                [System.IO.File]::Delete($targetPath)
            }

            # The one shared primitive canonicalises, compares EOL-insensitively and writes only on change.
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

    if ($whole) {
        # The targets just written are among its inputs, so the stamp is taken after the run.
        Save-GeneratedWriterStamp -Name 'Build-RootConfig'
    }

    if ($PassThru) {
        return $ret
    }

    [string[]] @($ret.Path)
}
