function Get-TestLevelTag {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        $Test
    )

    $tierTags = Get-TestBlockTag -Test $Test -Valid ([Catzc.Base.Timeouts.TestTiers]::Names)
    if ($tierTags.Count -eq 1) {
        $tierTags[0]
    }
    else {
        $null
    }
}
