function Get-GeneratedTarget {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Variants.GeneratedTarget])]
    param()

    $rows = @(foreach ($owner in @(Get-Config -Config generated -ListOwners)) {
            (Get-Config -Config generated -Module $owner.Module).writers
        })

    # Each expanding config answers its instances once, however many rows point at it; its owner's expander answers them.
    $expanded = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
    foreach ($row in $rows) {
        if (-not $row.expands) {
            foreach ($output in $row.outputs) {
                [Catzc.Base.Variants.GeneratedTarget]::new($output.path, $row.name, $row.class, $row.class -ne 'untracked')
            }
            continue
        }
        if (-not $expanded.Add($row.expands)) {
            continue
        }
        $expander = Get-Command -Name $row.expander -CommandType Function -ErrorAction SilentlyContinue
        if (-not $expander) {
            throw "Get-GeneratedTarget: writer '$($row.name)' names expander '$($row.expander)', which no loaded module exports."
        }
        & $expander -Name $row.name -Class $row.class
    }
}
