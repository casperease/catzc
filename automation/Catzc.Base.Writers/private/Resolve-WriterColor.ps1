<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Writers/private/Resolve-WriterColor.ps1
    kind: automation-function
    language: powershell
    track: automation
    module: Catzc.Base.Writers
    visibility: private
    relatives:
      page: docs/references/automation/catzc-base-writers/private/Resolve-WriterColor.ps1.md
  config:
    synopsis: |-
      Normalises a writer's -ForegroundColor argument into a colour plan — a plain ConsoleColor or a rainbow
      profile — shared by Write-Header and Write-Footer.
    description: |-
      A header/footer accepts either a [System.ConsoleColor] (or its string name, e.g. 'Cyan') or a
      [Catzc.Base.Writers.RainbowColor] profile on -ForegroundColor. This resolves the argument once:

        - unbound            -> no colour (render as terminal default)
        - a RainbowColor     -> the gradient plan; its rule lines take the per-character walk, its text uses
                                the base colour (the profile side-grades to Base)
        - a ConsoleColor     -> a single colour for every line (the pre-rainbow behaviour)
        - a rainbow string   -> 'rainbow' or '<base>-rainbow' (the RainbowColor.ToString form) parses to a
                                gradient plan, so a bareword -ForegroundColor rainbow works with no cast
        - any other string   -> parsed to a ConsoleColor (a bareword binds as a string against the [object]
                                parameter, so 'Cyan' still works)

      Returns a hashtable { HasColor; IsRainbow; Rainbow; Base }.
    parameters:
      ForegroundColor: The raw argument (a ConsoleColor, its string name, or a RainbowColor). Ignored when -Bound is not set.
      Bound: Whether the caller bound -ForegroundColor at all — an unbound call renders with no colour.
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
    if ($ForegroundColor -is [string]) {
        $found = [Catzc.Base.Writers.RainbowColor]::FromString($ForegroundColor)
        if ($found) {
            return @{ HasColor = $true; IsRainbow = $true; Rainbow = $found; Base = $found.Base }
        }
    }
    # A ConsoleColor, or its string name — cast covers both (a bareword binds as a string here).
    @{ HasColor = $true; IsRainbow = $false; Rainbow = $null; Base = [System.ConsoleColor] $ForegroundColor }
}
