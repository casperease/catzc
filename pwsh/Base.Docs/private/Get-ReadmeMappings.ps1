function Get-ReadmeMappings {
    [OutputType([object[]])]
    param(
        [Parameter(Mandatory)]
        $Config,

        [string] $RepositoryRoot = (Get-RepositoryRoot),

        [switch] $Missing
    )

    # The globs expand over the source tree's folders (pwsh/* and the like).
    Assert-SourceTree

    # Explicit mappings first — they win over any pattern that also matches their folder.
    $byFolder = [ordered]@{}
    $absent = [System.Collections.Generic.List[pscustomobject]]::new()
    foreach ($mapping in @($Config.mappings)) {
        $byFolder[$mapping.folder] = [pscustomobject]@{ folder = $mapping.folder; source = $mapping.source }
    }

    $commentPages = Get-Config -Config comment-pages
    foreach ($pattern in @($Config.patterns)) {
        # Only a trailing '/*' glob is supported: <prefix>/* = immediate non-dot subdirectories of <prefix>.
        if ($pattern.glob -match '^(?<prefix>.+)/\*$') {
            $prefix = $Matches['prefix']
        }
        else {
            throw "Unsupported README glob '$($pattern.glob)'. Only a trailing '/*' is supported (e.g. '<folder>/*')."
        }

        # A pattern names a folder of the source tree, so a missing one is a config fault, never an empty match.
        $prefixPath = Join-Path $RepositoryRoot $prefix
        Assert-PathExist $prefixPath -PathType Container -ErrorText "readme.yml: the pattern '$($pattern.glob)' names '$prefix', which is no folder."

        foreach ($dir in @(Get-ChildPath -Path $prefixPath -Depth 1 -Directory | Sort-Object)) {
            $leaf = [System.IO.Path]::GetFileName($dir)
            if ($leaf.StartsWith('.')) {
                continue
            }

            $folder = "$prefix/$leaf"
            if ($byFolder.Contains($folder)) {
                continue   # an explicit mapping already owns this folder
            }

            # A module folder's README is its module article, at the page the one comment-pages resolver derives.
            $source = $commentPages.ModulePageFor($folder)
            if (-not $source -or -not (Test-Path (Join-Path $RepositoryRoot $source) -PathType Leaf)) {
                # No authored source yet: Build-Readme skips it so the importer never throws, and -Missing hands it to the gate.
                $absent.Add([pscustomobject]@{ folder = $folder; source = $source })
                continue
            }

            $byFolder[$folder] = [pscustomobject]@{ folder = $folder; source = $source }
        }
    }

    if ($Missing) {
        return @($absent)
    }
    @($byFolder.Values)
}
