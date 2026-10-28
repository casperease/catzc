function Get-PlanHeadIssue {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [AllowNull()]
        [object] $FrontMatter,

        [Parameter(Mandatory)]
        [Catzc.Base.QualityGates.PlansConfig] $Config,

        [Parameter(Mandatory)]
        [string] $RepositoryRoot
    )

    $block = if ($FrontMatter -is [System.Collections.IDictionary] -and $FrontMatter.Contains('plan')) {
        $FrontMatter['plan']
    }
    if (-not ($block -is [System.Collections.IDictionary])) {
        "the head has no 'plan:' block"
        return
    }

    foreach ($key in $Config.head_required) {
        if (-not $block.Contains($key)) {
            "the head misses '$key'"
        }
    }
    foreach ($key in @($block.Keys)) {
        if ($key -notin $Config.head_required -and $key -notin $Config.head_allowed) {
            "the head key '$key' is outside the plan keys ($(($Config.head_required + $Config.head_allowed) -join ', '))"
        }
    }
    if ($block.Contains('status')) {
        $status = "$($block['status'])"
        if ($status -notin $Config.statuses) {
            "status '$status' is not one of: $($Config.statuses -join ', ')"
        }
        elseif ($status -ceq 'blocked' -and -not ($block.Contains('blocked_on') -or $block.Contains('waits_on'))) {
            "a blocked plan names what blocks it in 'blocked_on' or 'waits_on'"
        }
    }
    if ($block.Contains('value') -and "$($block['value'])" -notin $Config.ranks) {
        "value '$($block['value'])' is not one of the ranks: $($Config.ranks -join ', ')"
    }
    if ($block.Contains('targets')) {
        $targets = @($block['targets'])
        if ($targets.Count -eq 0) {
            'targets names no path'
        }
        foreach ($target in $targets) {
            $candidate = Join-Path $RepositoryRoot "$target"
            if (-not ([System.IO.File]::Exists($candidate) -or [System.IO.Directory]::Exists($candidate))) {
                "target '$target' does not exist"
            }
        }
    }
}
