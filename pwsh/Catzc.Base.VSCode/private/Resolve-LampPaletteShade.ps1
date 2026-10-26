<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-vs-code/private/Resolve-LampPaletteShade.ps1.md"
  header: "generated"
---
#>

function Resolve-LampPaletteShade {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('Measure-ParameterFillIn', '',
        Justification = 'The palette loads on the first palette reference only, so a tree without one never reads it (ADR-PWSH-PARAM-RESOLUTIONORDER)')]
    [CmdletBinding()]
    [OutputType([object])]
    param(
        [AllowNull()]
        [object] $InputObject,

        # Read on the first reference only, so a tree without one never loads the palette.
        [Catzc.Base.VSCode.LampPaletteConfig] $Palette
    )

    if ($InputObject -is [string]) {
        if ($InputObject -notmatch '^palette\.(?<range>[a-z_]+)\.(?<shade>[a-z_]+)(/(?<alpha>[0-9a-fA-F]{2}))?$') {
            return $InputObject
        }
        $range = $Matches['range']
        $shade = $Matches['shade']
        $alpha = $Matches['alpha']
        if (-not $Palette) {
            $Palette = Get-Config -Config lamp-palette
        }
        if (-not $Palette.ranges.ContainsKey($range)) {
            throw "Resolve-LampPaletteShade: '$InputObject' names no palette range '$range'."
        }
        $property = $Palette.ranges[$range].PSObject.Properties[$shade]
        if (-not $property -or $shade -eq 'name') {
            throw "Resolve-LampPaletteShade: '$InputObject' names no shade '$shade' of range '$range'."
        }
        $hex = $property.Value
        if ($alpha) {
            $hex = $hex.Substring(0, 7) + $alpha.ToLowerInvariant()
        }
        return $hex
    }
    if ($InputObject -is [System.Collections.IDictionary]) {
        $map = [ordered]@{}
        foreach ($key in $InputObject.Keys) {
            $map[$key] = Resolve-LampPaletteShade -InputObject $InputObject[$key] -Palette $Palette
        }
        return $map
    }
    if ($InputObject -is [System.Collections.IList]) {
        return , @(foreach ($item in $InputObject) {
                Resolve-LampPaletteShade -InputObject $item -Palette $Palette
            })
    }
    $InputObject
}
