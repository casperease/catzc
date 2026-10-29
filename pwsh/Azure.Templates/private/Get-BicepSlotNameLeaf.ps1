function Get-BicepSlotNameLeaf {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [AllowNull()]
        [object] $Value,

        [Parameter(Mandatory)]
        [AllowEmptyString()]
        [string] $Location,

        [ValidateRange(-1, 1)]
        [int] $State = 0,

        [string[]] $NotNames = @()
    )

    # State 1: a key on the path ends in Name or Names; -1: a key on the path ends in a not_names suffix, which no later key undoes.
    if ($Value -is [System.Collections.IDictionary]) {
        foreach ($key in @($Value.Keys)) {
            $text = "$key"
            $next = $State
            if ($next -ne -1) {
                if (@($NotNames | Where-Object { $text.EndsWith($_, [System.StringComparison]::Ordinal) }).Count -gt 0) {
                    $next = -1
                }
                elseif ($text -cmatch 'Names?$') {
                    $next = 1
                }
            }
            $at = if ($Location) {
                "$Location.$text"
            }
            else {
                $text
            }
            Get-BicepSlotNameLeaf -Value $Value[$key] -Location $at -State $next -NotNames $NotNames
        }
        return
    }
    if ($Value -is [System.Collections.IList]) {
        for ($index = 0; $index -lt $Value.Count; $index++) {
            Get-BicepSlotNameLeaf -Value $Value[$index] -Location "$Location[$index]" -State $State -NotNames $NotNames
        }
        return
    }
    if ($Value -is [string] -and $Value.Length -gt 0) {
        [pscustomobject]@{ location = $Location; value = $Value; named = $State -eq 1 }
    }
}
