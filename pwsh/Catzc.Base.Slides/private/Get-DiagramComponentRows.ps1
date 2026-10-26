<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-slides/private/Get-DiagramComponentRows.ps1.md"
  header: "generated"
---
#>

function Get-DiagramComponentRows {
    [CmdletBinding()]
    [OutputType([System.Collections.Specialized.OrderedDictionary])]
    param(
        [Parameter(Mandatory)]
        [string] $Point,

        [Parameter(Mandatory)]
        [string] $RepositoryRoot
    )

    # C3 by what the point is: the record domains, one module and its neighbours, a container, or a dot folder's psm1s.
    $point = $Point.Trim('/')
    $idOf = { param([string] $Name) ($Name.ToLowerInvariant() -replace '[^a-z0-9]+', '-').Trim('-') }
    $nodes = [System.Collections.Generic.List[object]]::new()
    $edges = [System.Collections.Generic.List[object]]::new()
    $ids = @{}
    $add = {
        param([string] $Name, [string] $Kind)
        if (-not $ids.ContainsKey($Name)) {
            $ids[$Name] = & $idOf $Name
            $nodes.Add([ordered]@{ id = $ids[$Name]; label = $Name; kind = $Kind })
        }
    }
    $drsRoot = (Get-Config -Config drs).Root
    if ($point -ceq "$drsRoot".Replace('\', '/').Trim('/')) {
        $domainEdges = @(Get-DrsDomainEdges | Sort-Object From, To)
        foreach ($edge in $domainEdges) {
            & $add $edge.From 'set'
            & $add $edge.To 'set'
        }
        foreach ($edge in $domainEdges) {
            if ($edge.From -cne $edge.To) {
                $edges.Add([ordered]@{ from = $ids[$edge.From]; to = $ids[$edge.To]; label = 'cites' })
            }
        }
    }
    else {
        $modules = @(Get-CatzcModule -RepositoryRoot $RepositoryRoot)
        $self = @($modules | Where-Object { "$($_.root)".Replace('\', '/').Trim('/') -ceq $point })
        $within = @($modules | Where-Object { "$($_.root)".Replace('\', '/').StartsWith("$point/",
            [System.StringComparison]::Ordinal) })
        if ($self.Count -or $within.Count) {
            $dependencies = @(Get-ModuleDependencyEdges | Sort-Object From, To)
            if ($self.Count) {
                # One module: itself and the modules it calls or is called by.
                $name = $self[0].name
                & $add $name 'module'
                foreach ($edge in $dependencies) {
                    if ($edge.From -ceq $name) {
                        & $add $edge.To 'module'
                    }
                    if ($edge.To -ceq $name) {
                        & $add $edge.From 'module'
                    }
                }
                $dependencies = @($dependencies | Where-Object { $_.From -ceq $name -or $_.To -ceq $name })
            }
            else {
                foreach ($module in $within | Sort-Object name) {
                    & $add $module.name 'module'
                }
            }
            foreach ($edge in $dependencies) {
                if ($ids.ContainsKey($edge.From) -and $ids.ContainsKey($edge.To) -and $edge.From -cne $edge.To) {
                    $edges.Add([ordered]@{ from = $ids[$edge.From]; to = $ids[$edge.To]; label = 'calls' })
                }
            }
        }
        else {
            # A folder no module claims: its module files at the top, the internal modules a dot folder holds.
            $folder = Join-Path $RepositoryRoot $point
            Assert-True ([System.IO.Directory]::Exists($folder)) -ErrorText "Get-DiagramComponentRows: the point $point is no folder of the repository."
            foreach ($file in @(Get-ChildPath $folder -File -Depth 1 -Filter '*.psm1' | Sort-Object)) {
                & $add ([System.IO.Path]::GetFileNameWithoutExtension($file)) 'module'
            }
        }
    }
    [ordered]@{ point = $point; level = 'C3'; nodes = $nodes.ToArray(); edges = $edges.ToArray() }
}
