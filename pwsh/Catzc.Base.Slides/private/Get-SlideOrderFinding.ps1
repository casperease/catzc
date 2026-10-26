<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-slides/private/Get-SlideOrderFinding.ps1.md"
  header: "generated"
---
#>

function Get-SlideOrderFinding {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Slides.SlideFault])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [AllowEmptyCollection()]
        [pscustomobject[]] $Slide,

        [Parameter(Mandatory)]
        [string] $Deck
    )

    $orders = @($Slide | Where-Object { $_.Order -is [int] -or $_.Order -is [long] } |
            ForEach-Object { [long] $_.Order })
    foreach ($group in ($orders | Group-Object | Where-Object Count -GT 1)) {
        $names = @($Slide | Where-Object { "$($_.Order)" -eq $group.Name } | Sort-Object Id |
                ForEach-Object Id) -join ', '
        [Catzc.Base.Slides.SlideFault]::new($Deck, 'order',
            "the order $($group.Name) is held by $($group.Count) slides: $names")
    }
    $distinct = @($orders | Sort-Object -Unique)
    for ($expected = 1; $expected -le $distinct.Count; $expected++) {
        if ($distinct[$expected - 1] -ne $expected) {
            [Catzc.Base.Slides.SlideFault]::new($Deck, 'order',
                "the orders have a gap: expected $expected, found $($distinct[$expected - 1])")
            break
        }
    }
}
