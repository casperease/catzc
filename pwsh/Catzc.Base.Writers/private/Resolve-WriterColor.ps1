<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Writers/private/Resolve-WriterColor.ps1
    folder: private
    name: resolve-writer-color
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Writers
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    docs: "[Resolve-WriterColor.ps1.md](docs/references/pwsh/catzc-base-writers/private/Resolve-WriterColor.ps1.md)"
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
