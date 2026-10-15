<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Writers/private/Resolve-WriterColor.ps1
    kind: private-function
    module: Catzc.Base.Writers
    visibility: private
    adrs: []
---
#>

<#
.SYNOPSIS
    Normalises a writer's -ForegroundColor argument into a colour plan — a plain ConsoleColor or a rainbow
    profile — shared by Write-Header and Write-Footer.
.DESCRIPTION
    A rainbow gives a gradient plan whose text uses the base colour; a plain colour or name gives a solid plan.
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
    # A bareword binds as a string here, so the rainbow forms are tried first and any other string falls to the cast.
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
