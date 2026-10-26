function Build-TrackGlobSets {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [switch] $DryRun,

        [switch] $Silent,

        [switch] $PassThru
    )

    # The declarations are read from the authored part alone: the merged config needs the part this writes.
    $declared = Get-CatzcModuleRoot 'configs/globs/globs.yml'
    $target = Get-CatzcModuleRoot 'configs/globs/track-sets.yml'
    $authored = [System.IO.File]::ReadAllText($declared) | ConvertFrom-Yaml -Ordered
    $sets = @($authored.globsets.Keys | Where-Object { $authored.globsets[$_].Contains('track') })

    $tracks = @(Get-Track)
    $targets = @(Get-GeneratedTarget)
    # A nested track keeps its files in the parent's set unless a set of its own starts a pipeline for it.
    $piped = @(foreach ($name in $authored.globsets.Keys) {
            $entry = $authored.globsets[$name]
            if ($entry.Contains('track') -and $entry.Contains('pipeline')) {
                $entry.track
            }
        })

    $lines = [System.Collections.Generic.List[string]]::new()
    $lines.Add('# The derived patterns of every whole track''s set that globs.yml declares (FDR-CD-GLOBS-TRACKSETDERIVED).')
    $lines.Add('globsets:')
    foreach ($name in $sets) {
        $trackName = $authored.globsets[$name].track
        $track = $tracks | Where-Object name -CEQ $trackName
        Assert-NotNull $track -ErrorText "Build-TrackGlobSets: globset '$name' names track '$trackName', which variants.yml does not declare."

        $include = [System.Collections.Generic.SortedSet[string]]::new([System.StringComparer]::Ordinal)
        $exclude = [System.Collections.Generic.SortedSet[string]]::new([System.StringComparer]::Ordinal)
        foreach ($member in $track.members) {
            $pattern = if ($member.glob) {
                $member.path
            }
            else {
                "$($member.path)/**"
            }
            if ($member.generated) {
                [void] $exclude.Add($pattern)
            }
            elseif (-not $member.glob) {
                [void] $include.Add($pattern)
            }
        }
        foreach ($place in $track.places) {
            foreach ($generated in $targets) {
                if ($generated.path.StartsWith("$place/", [System.StringComparison]::Ordinal)) {
                    [void] $exclude.Add($generated.path)
                }
            }
            foreach ($other in $tracks) {
                if ($other.name -cne $trackName -and $other.name -cin $piped) {
                    foreach ($nested in $other.places.Where({ $_.StartsWith("$place/", [System.StringComparison]::Ordinal) })) {
                        [void] $exclude.Add("$nested/**")
                    }
                }
            }
        }

        $lines.Add("  ${name}:")
        $lines.Add('    include:')
        foreach ($pattern in $include) {
            $lines.Add("      - `"$pattern`"")
        }
        if ($exclude.Count -gt 0) {
            $lines.Add('    exclude:')
            foreach ($pattern in $exclude) {
                $lines.Add("      - `"$pattern`"")
            }
        }
    }

    $relative = ConvertTo-RepoRelativePath $target
    $text = Format-GeneratedFileHead -Text (($lines -join "`n") + "`n") -Path $relative
    $changed = Write-FileIfChanged $target $text -DryRun:$DryRun
    if ($changed -and -not $Silent) {
        Write-Message "$(if ($DryRun) { 'would write' } else { 'wrote' }) $relative"
    }
    if ($PassThru) {
        [pscustomobject]@{ Path = $relative; Changed = $changed; DryRun = [bool] $DryRun }
    }
}
