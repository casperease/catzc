function Get-Inspiration {
    [CmdletBinding(DefaultParameterSetName = 'All')]
    [OutputType([Catzc.Tooling.Inspiration.Inspiration])]
    param(
        [Parameter(Mandatory, Position = 0, ParameterSetName = 'Id')]
        [ValidateNotNullOrEmpty()]
        [string] $Id,

        [Parameter(Mandatory, ParameterSetName = 'Random')]
        [ValidateRange(0, [int]::MaxValue)]
        [int] $Count,

        [Parameter(ParameterSetName = 'Random')]
        [int] $Seed,

        [Parameter(ParameterSetName = 'All')]
        [Parameter(ParameterSetName = 'Random')]
        [switch] $IncludeUnavailable
    )

    $inspirations = @(
        foreach ($entry in (Get-Config -Config inspiration).inspirations) {
            $root = Resolve-InspirationRoot $entry.root
            [Catzc.Tooling.Inspiration.Inspiration]::new($entry.id, $root, [IO.Directory]::Exists($root), $entry.description, $entry.paths)
        }
    )

    if ($PSCmdlet.ParameterSetName -eq 'Id') {
        $found = @($inspirations | Where-Object Id -CEQ $Id)
        $known = @(foreach ($inspiration in $inspirations) {
                $inspiration.Id
            })
        Assert-True ($found.Count -eq 1) -ErrorText "Unknown inspiration '$Id' in inspiration.yml (known ids: $($known -join ', '))"
        return $found[0]
    }

    $pool = @(
        if ($IncludeUnavailable) {
            $inspirations
        }
        else {
            $inspirations | Where-Object Available
        }
    )
    if ($PSCmdlet.ParameterSetName -eq 'All') {
        return $pool
    }

    # A partial Fisher-Yates shuffle: the first $take positions are a uniform random pick, in pick order.
    $random = if ($PSBoundParameters.ContainsKey('Seed')) {
        [Random]::new($Seed)
    }
    else {
        [Random]::new()
    }
    $take = [Math]::Min($Count, $pool.Count)
    for ($i = 0; $i -lt $take; $i++) {
        $j = $random.Next($i, $pool.Count)
        $swap = $pool[$i]
        $pool[$i] = $pool[$j]
        $pool[$j] = $swap
    }
    if ($take -gt 0) {
        $pool[0..($take - 1)]
    }
}
