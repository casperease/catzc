function Get-DiagramComponentRows {
    [CmdletBinding()]
    [OutputType([System.Collections.Specialized.OrderedDictionary])]
    param(
        [Parameter(Mandatory)]
        [string] $Point,

        [Parameter(Mandatory)]
        [string] $RepositoryRoot
    )

    # C3: the modules a container holds, each a module glyph, and the dependency edges the code really makes between two of them.
    $prefix = $Point.Trim('/') + '/'
    $modules = @(Get-CatzcModule -RepositoryRoot $RepositoryRoot | Where-Object { "$($_.root)".Replace('\', '/').StartsWith($prefix, [System.StringComparison]::Ordinal) })
    $ids = @{}
    $nodes = foreach ($module in $modules | Sort-Object name) {
        $ids[$module.name] = ($module.name.ToLowerInvariant() -replace '[^a-z0-9]+', '-').Trim('-')
        [ordered]@{ id = $ids[$module.name]; label = $module.name; kind = 'module' }
    }
    $edges = foreach ($edge in @(Get-ModuleDependencyEdges | Sort-Object From, To)) {
        if ($ids.ContainsKey($edge.From) -and $ids.ContainsKey($edge.To) -and $edge.From -cne $edge.To) {
            [ordered]@{ from = $ids[$edge.From]; to = $ids[$edge.To]; label = 'calls' }
        }
    }
    [ordered]@{ point = $Point; level = 'C3'; nodes = @($nodes); edges = @($edges) }
}
