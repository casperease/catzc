<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-slides/private/Get-DiagramCodeRows.ps1.md"
  header: "generated"
---
#>

function Get-DiagramCodeRows {
    [CmdletBinding()]
    [OutputType([System.Collections.Specialized.OrderedDictionary])]
    param(
        [Parameter(Mandatory)]
        [string] $Point,

        [Parameter(Mandatory)]
        [string] $RepositoryRoot
    )

    # C4: tracked files only, tests out, so build output and test diamonds never crowd the slide.
    $languages = Get-Config -Config languages
    $point = $Point.Trim('/')
    $folder = [System.IO.Path]::GetFullPath((Join-Path $RepositoryRoot $point))
    Assert-True ([System.IO.Directory]::Exists($folder)) -ErrorText "Get-DiagramCodeRows: the point $point is no folder of the repository."
    $kindOf = @{ 'private-function' = 'private'; 'type' = 'type' }
    $nodes = [System.Collections.Generic.List[object]]::new()
    $ids = @{}
    $tracked = @(Get-GitTrackedPath $point)
    foreach ($file in @($tracked | Sort-Object)) {
        $relative = "$file".Replace('\', '/').Substring($point.Length + 1)
        $place = $languages.PlaceOf($relative)
        $role = if ($place) {
            $place.role
        }
        if ($role -ceq 'test') {
            continue
        }
        $kind = if ($kindOf.ContainsKey("$role")) {
            $kindOf["$role"]
        }
        elseif ($relative.EndsWith('.ps1', [System.StringComparison]::OrdinalIgnoreCase) -and
            -not $relative.Contains('/')) {
            'code'
        }
        else {
            'file'
        }
        $id = ($relative.ToLowerInvariant() -replace '[^a-z0-9]+', '-').Trim('-')
        $ids["$point/$relative"] = $id
        # The glyph's kind already says what the file is, so its label is the name without the extension, short enough
        # for its box.
        $nodes.Add([ordered]@{ id = $id; label = [System.IO.Path]::GetFileNameWithoutExtension($relative); kind = $kind })
    }
    $edges = [System.Collections.Generic.List[object]]::new()
    $pairs = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
    # One walk of the link graph answers every relation into the point; an edge between two of its files is kept once.
    foreach ($edge in @(Get-LinkEdge -To $Point -RepositoryRoot $RepositoryRoot | Sort-Object File, Target)) {
        $from = "$($edge.File)".Replace('\', '/')
        $target = "$($edge.Target)".Replace('\', '/')
        if ($ids.ContainsKey($from) -and $ids.ContainsKey($target) -and $from -cne $target -and
            $pairs.Add("$from>$target")) {
            $edges.Add([ordered]@{ from = $ids[$from]; to = $ids[$target] })
        }
    }
    [ordered]@{ point = $Point; level = 'C4'; nodes = $nodes.ToArray(); edges = $edges.ToArray() }
}
