<#
.SYNOPSIS
    Normalises a writer's -ForegroundColor argument into a colour plan — a plain ConsoleColor or a rainbow
    profile — shared by Write-Header and Write-Footer.
.DESCRIPTION
    A header/footer accepts either a [System.ConsoleColor] (or its string name, e.g.
    [comment:1](/docs/references/automation/catzc-base-writers/private/Resolve-WriterColor.ps1.md#comment1)
.PARAMETER ForegroundColor
    The raw argument (a ConsoleColor, its string name, or a RainbowColor). Ignored when -Bound is not set.
.PARAMETER Bound
    Whether the caller bound -ForegroundColor at all — an unbound call renders with no colour.
#>
function Resolve-WriterColor {
    [CmdletBinding()]
    [OutputType([hashtable])]
    param(
        [object] $ForegroundColor,

        [switch] $Bound
    )

    if (-not $Bound) {
        return @{ HasColor = $false; IsRainbow = $false; Rainbow = $null; Base = $null }
    }
    if ($ForegroundColor -is [Catzc.Base.Writers.RainbowColor]) {
        return @{ HasColor = $true; IsRainbow = $true; Rainbow = $ForegroundColor; Base = $ForegroundColor.Base }
    }
    # A 'rainbow' / '<base>-rainbow' bareword resolves to a gradient profile (the ToString round-trip); any other...
    # [comment:2](/docs/references/automation/catzc-base-writers/private/Resolve-WriterColor.ps1.md#comment2)
    if ($ForegroundColor -is [string]) {
        $found = [Catzc.Base.Writers.RainbowColor]::FromString($ForegroundColor)
        if ($found) {
            return @{ HasColor = $true; IsRainbow = $true; Rainbow = $found; Base = $found.Base }
        }
    }
    # A ConsoleColor, or its string name — cast covers both (a bareword binds as a string here).
    @{ HasColor = $true; IsRainbow = $false; Rainbow = $null; Base = [System.ConsoleColor] $ForegroundColor }
}
