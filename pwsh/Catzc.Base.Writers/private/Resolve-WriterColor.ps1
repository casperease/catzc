<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-writers/private/Resolve-WriterColor.ps1.md"
  header: "generated"
---
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
    # A rainbow bareword becomes a gradient profile; any other string is a plain ConsoleColor name.
    if ($ForegroundColor -is [string]) {
        $found = [Catzc.Base.Writers.RainbowColor]::FromString($ForegroundColor)
        if ($found) {
            return @{ HasColor = $true; IsRainbow = $true; Rainbow = $found; Base = $found.Base }
        }
    }
    # A ConsoleColor, or its string name — cast covers both (a bareword binds as a string here).
    @{ HasColor = $true; IsRainbow = $false; Rainbow = $null; Base = [System.ConsoleColor] $ForegroundColor }
}
