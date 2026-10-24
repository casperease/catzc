function Resolve-MinimapGlyphPath {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        # The drawing's glyphs, each { kind; label }: only the code and file kinds name a repository place.
        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [object[]] $Glyph,

        # Every tracked repository-relative path, the one index a label is resolved against.
        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [string[]] $TrackedPath
    )

    $byLeaf = @{}
    foreach ($path in $TrackedPath) {
        $leaf = $path.Substring($path.LastIndexOf('/') + 1)
        if (-not $byLeaf.ContainsKey($leaf)) {
            $byLeaf[$leaf] = [System.Collections.Generic.List[string]]::new()
        }
        $byLeaf[$leaf].Add($path)
    }
    $tracked = [System.Collections.Generic.HashSet[string]]::new($TrackedPath, [System.StringComparer]::Ordinal)
    foreach ($drawn in $Glyph) {
        if ($drawn['kind'] -notin @('code', 'private', 'runner', 'type', 'file')) {
            continue
        }
        $label = (("$($drawn['label'])" -split "`r?`n")[0]).Trim()
        $paths = @(
            if ($label -cmatch '^([A-Z][a-z]+(?:To|From)?(?:-[A-Z][A-Za-z0-9]*)+)(?:\(\)| -.*)?$') {
                $byLeaf["$($Matches[1]).ps1"]
            }
            elseif ($label -cmatch '^Catzc(?:\.[A-Z][A-Za-z0-9]*)+$') {
                $manifest = "pwsh/$label/$label.psd1"
                if ($tracked.Contains($manifest)) {
                    $manifest
                }
            }
            elseif ($label -cmatch '^([A-Z][A-Za-z0-9]*)(?:\.[A-Z][A-Za-z0-9]*(?:\(.*\))?)?$') {
                $byLeaf["$($Matches[1]).cs"]
            }
            elseif ($label -cmatch '^[\w-]+\.[A-Za-z0-9]+$') {
                $byLeaf[$label]
            }
        )
        [pscustomobject]@{ Kind = $drawn['kind']; Label = $label; Path = [string[]] $paths }
    }
}
